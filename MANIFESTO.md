# The work starts and stops with me

I build software with AI every day. The building got fast. Owning the result stayed exactly
as hard as it always was, and it stayed mine.

Here is what the research says about the world I work in now. Agent runs degrade sharply past
a length horizon, and early wrong turns compound because they are costly to roll back
([HORIZON, 2026](https://arxiv.org/abs/2604.11978)). The people judging the output wear down
under the flood: in intensive care, 88.8% of annotated arrhythmia alarms were false, and
clinicians learned to stop hearing them
([Drew et al., 2014](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0110274)).
Urgency beats importance even when the urgency is fake: in experiments, people picked an
unimportant task that seemed about to expire over a more rewarding one that did not
([Zhu, Yang & Hsee, 2018](https://academic.oup.com/jcr/article-abstract/45/3/673/4847790)).
And in recommender experiments, larger option sets raised search effort without necessarily
raising satisfaction
([Bollen et al., 2010](https://research.tue.nl/en/publications/understanding-choice-overload-in-recommender-systems/)).

Those are measured mechanisms. What follows is only my testimony. At my desk, the agent runs
long because it can. The chat feels urgent to me in a way no study has measured. Each
question seems to arrive with five options, and picking one just opens more doors.
Approvals come so fast that yes becomes the way to keep working. I have merged AI work at two in the
morning on a skim, and woken up owning every consequence.

remit is what I built against those mechanisms.

Two of my systems attack the same problem from opposite ends.
[AIDOS](https://github.com/shobman/aidos) makes you think critically before work starts. remit keeps the judgement mine while the work is built. It
tracks the work in Git. It has fresh eyes verify everything, from a brief to a build. It lets
work stop naturally and resume weeks later in a new session, in whichever AI I choose that
morning — Claude Code, Codex, Pi, Devin or Copilot CLI. It works across AI providers, and it moves work
between them. It never decides how big a piece
of work is. And work exists only when I ask for it; it ends only when I say so.

Working with remit is no different than working without it. But:

- My agent is never too busy. Isolated workers do the legwork while the coordinator keeps its
  context and keeps talking to me. That is where the throughput comes from.
- Context that matters survives. Shut the machine down; days later the work continues where
  it stopped.
- Everything reaches me already verified, by a fresh context that had no hand in writing it.
- Work is never created or closed without me. The scope is mine. It is done when I say.
- Crossing providers is native. I dispatch a build to one model and hand the review to a
  rival, and I never copy and paste between agents for a second opinion again.
- When work ships, the code is the law. The records are archived with the item, and nothing
  is left standing to fight the code afterwards.
- Every change names its makers in the commit itself: which human asked, which model wrote,
  which session carried it. Months later, `git log` still answers the question "who decided
  this?"
- And nothing nags. Parked work sits silent until I raise it; remit never manufactures
  urgency. The only real choices it surfaces are the owner's: start work, or stop it.

Small work stays small. A five-minute fix stays a five-minute fix.

One honest concession. No study has yet proven that human judgement gates improve outcomes.
The four mechanisms above are measured, and so is one intervention that points this way:
forcing a decision point reduces over-reliance on AI, and the people it helped rated those
designs the worst ([Buçinca et al., 2021](https://arxiv.org/abs/2102.09692)). Whether remit
reduces the four is untested. I would rather tell you that here than have you find it out
later.

The AI does the housekeeping. The creating and the deciding stay with the owner.

The work starts and stops with you.
