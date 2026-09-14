#!/bin/sh
# Runs in the public mirror after its artifact branch or tag arrives. Never tags.
set -eu
die(){ printf 'release entry: %s\n' "$1" >&2; exit 1; }
[ "${GITHUB_REPOSITORY:-}" = shobman/remit ] || die 'not the public mirror'
case "${GITHUB_REF_TYPE:-}" in
tag) tag=${GITHUB_REF_NAME:-} ;;
branch)
    [ "${GITHUB_EVENT_NAME:-}" = push ] && [ "${GITHUB_REF_NAME:-}" = main ] || die 'select a published version tag'
    tag=v$(git show HEAD:VERSION) || die 'artifact version is missing' ;;
*) die 'select a published version tag' ;;
esac
printf '%s\n' "$tag" | grep -Eq '^v[0-9]+\.[0-9]+\.[0-9]+$' || die 'invalid release tag'
if [ "$GITHUB_REF_TYPE" = branch ]; then
    # Branch and tag arrive in one publication. A checkout can observe the branch
    # first; retry fetching that one tag, never create it or change the checkout.
    for attempt in 1 2 3; do
        git rev-parse --verify "refs/tags/$tag^{commit}" >/dev/null 2>&1 && break
        git fetch -q --no-tags origin "refs/tags/$tag:refs/tags/$tag" && break
        [ "$attempt" = 3 ] || sleep 1
    done
fi
commit=$(git rev-parse --verify "refs/tags/$tag^{commit}") || die 'tag is absent'
[ "$(git rev-parse HEAD)" = "$commit" ] || die 'checkout differs from the tag'
[ "$(git show "$commit:VERSION")" = "${tag#v}" ] || die 'artifact version differs from the tag'
[ -s RELEASE_NOTES.md ] || die 'release notes are missing'
# Refuse local modifications: notes must be the committed artifact's own notes.
git diff --quiet "$commit" -- RELEASE_NOTES.md || die 'release notes differ from the artifact'
# A failed lookup is not evidence that a release is absent. Read the complete
# catalogue, so retries preserve authored notes and cannot manufacture duplicates.
catalogue=$(gh api --paginate --slurp "repos/$GITHUB_REPOSITORY/releases?per_page=100") || die 'could not read releases'
latest=false
# Include published entries as well as the checkout's tags: a newer release may
# have completed since Actions fetched this older job's checkout.
released=$(printf '%s\n' "$catalogue" | jq -er '[.[][] | .tag_name] | join("\n")') || die 'invalid release catalogue'
highest=$({ git tag --list 'v*'; printf '%s\n' "$released"; } | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' | sort -Vr | sed -n 1p)
[ "$tag" != "$highest" ] || latest=true
existing=$(printf '%s\n' "$catalogue" | jq -ce --arg tag "$tag" '[.[][] | select(.tag_name == $tag)]') || die 'invalid release catalogue'
count=$(printf '%s\n' "$existing" | jq length)
if [ "$count" = 0 ]; then
    gh release create "$tag" --repo "$GITHUB_REPOSITORY" --verify-tag \
        --title "remit $tag" --notes-file RELEASE_NOTES.md --latest="$latest"
elif [ "$count" = 1 ]; then
    # A retry may follow a lost create response. Keep existing title/body, and
    # never promote an older tag to Latest when a newer artifact already exists.
    if [ "$latest" = true ] || printf '%s\n' "$existing" | jq -e '.[0].draft or .[0].prerelease' >/dev/null; then
        gh release edit "$tag" --repo "$GITHUB_REPOSITORY" --draft=false --prerelease=false --latest="$latest"
    fi
else
    die 'ambiguous release catalogue'
fi
result=$(gh release view "$tag" --repo "$GITHUB_REPOSITORY" --json tagName,isDraft,isPrerelease,url) || die 'could not verify the release'
printf '%s\n' "$result" | jq -er --arg tag "$tag" \
    'select(.tagName == $tag and .isDraft == false and .isPrerelease == false) | .url' || die 'release is not published as expected'
