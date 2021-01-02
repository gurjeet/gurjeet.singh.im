---
layout: post
title:  "Persistence, Perseverance"
date:   2021-01-01 07:22:00 -0800
categories: Persistence, Perseverance, Hard Work, Knowledge, Compound Interest
---

TL;DR version:
- Pursue the technology<sup>+</sup> that interests you
- Get your hands dirty trying to solve your problem (a.k.a scratch your own itch)
- Don't give up (at least not until you've exhausted all the possibilities)
  - Persist, Persevere
- Reap the benefits of hard-earned knowledge for the rest of your life

Somebody recently wrote on Hacker News that the knowledge gained through hard
work is the one that sticks with you. So I wanted to present some data points to
back my agreement with that sentiment.

I am a known person in Postgres community<sup>*</sup> ([commits][]; [emails][]), and it
did not happen by accident. Some 15 years ago, after changing employers (for
personal reasons) from
Oracle to CommVault, I was attracted towards Postgres database project, so I
started exploring its code and participating in their conversations outside of
work. Within a
few months I was pursued by EnterpriseDB to work on their Postgres-based product full-time.

[commits]: http://bit.ly/1q208OG
[emails]: http://bit.ly/1oeQaUu

Bulk of my contributions to Postgres happened during my time at EnterpriseDB,
and most of my contributions were simply something I wanted to work on.
Delivering on any of these required turning off distractions and diving deep and
removing one blocker after another until there was something polished enough for
me to feel satisfied with, and presentable to the Postgres community. The same
is true of any significant contributions I've made to my employers' projects.
The formula is simple: turn off distractions, and slog it out. Now, there may be
many reasons to _not_ want to achieve a goal, but if you want to achive it,
that's the only formula.

More recently, I have been enamored by the core principle of the Nix package
manager. I first got seriously impressed by it in September of 2018, and tried
to learn and use it. But like most others, every attempt of mine to learn it at
any depth proved futile, primarily because the learning curve is _extremely_
steep; the functional programming language, Nix, being the first hurdle. Despite
the benefits it brings to the table, it is a serious undertaking for any
individual, and hence even more difficult to adopt in a company, at your job and
start leveraging its advantages; this is especially true of a technology like
Nix that is novel, but is simply replacing something that generally works and
people/companies have learned to live with.

When I got a new personal laptop a few months ago, I decided to use Nix instead
of Homebrew to install the packages I needed. The journey has been smooth so
far, and am able to get on with my personal work just fine.

Over the winter break I was working on a side project and I hit a snag in my Vim
usage. I had recently uninstalled the `vim` package and replaced it with
`vim_configurable`, because the latter provided Python3 support which I needed
for some of my Vim plugins. So, like any other developer (and like [Hal][]), I
got sidetracked to fix my Vim. It took me 3 days but I finally made my
first non-trivial [contribution][] to Nixpkgs; yes, as the world was celebrating
new year, I was creating the pull/merge-request in the middle of the night<sup>**</sup>.

[Hal]: https://www.youtube.com/watch?v=AbSehcT19u0
[contribution]: https://github.com/NixOS/nixpkgs/pull/108109/files

It could've taken me less than a day if I had just posted what I wanted to get
fixed on one of the various avenues the NixOS/Nixpkgs people hang out in. They
would have given me a neat trick to solve my problem and let me get on with
life. And frankly I have done that so many times in the past where, to be able
to get on with whatever I am doing, I would ask around on the internet, wait for a decent answer
that works, and move on.

But I took it upon myself to get exactly what I need. As usual, I started with
trial and error based on what's already in Nixpkgs. When that didn't work I
searched online for a problem similar enough to mine. When that did not help me
fix my problem, I found the good Nix/NixOS teaching videos in my YouTube history
and spent ~6 hours watching those and noticing things that hadn't made sense the
first time. Followed along doing the small exercises on their slides. All this
while taking care of other life stuff happening on the side; but my side-project
had been suspended while I tired all this. After 3 days of learning, 40+ tabs
still open in my browser, I finally felt confident enough to try writing the Nix
code I needed. I still hit a few bumps, but I was able to reason about the error
messages, debug and resolve the errors.

The things that I learned about Nix and Nixpkgs over these 3 days, I could _not_
have learnt, and definitely could not have retained that knowledge, had I simply
asked someone else to solve my problem. Now, given my knowledge, I feel
confident that I will be able to apply this in other projects and benefit from
it; I may still be slower than the Nix gurus, but I can get it done. As they
say, I now know enough to be dangerous :) For example, I now intuitively know
why `nix-env -iA xxx` is so much faster than `nix-env -i xxx`; answer: because
the `-A` switch lets Nix pick just the variable you're interested in, and lazily
evaluate just that expression, rather than evaluate all the expressions in
Nixpkgs and search for a _package_ named xxx.

Over my 20 years of experience I have seen this to be the case, it's only now
that I realized the pattern where I have reaped huge rewards from small but
difficult investments. Without even realizing it, I have invested my efforts
like this time and again, and gained significant expertise in the C language, Git, Docker, Kubernetes, and Postgres. There have
been some things that I was interested in (RISC-V comes to mind) but I never
invested enough time beyond cursory participation, and as a result I don't have
enough knowledge to call myslef an expert in them.

Not to say that all time spent in such deep/in-the-zone work always bears a
fruit, and to give an idea of how time spent like this, many a times goes to
waste... Over this same 3 day period I encountered a behaviour in Postgres'
psql utility that seemed like a bug, or at least a surprising behaviour. So I
carefully developed a test case that would demonstrate the problem, studied the
psql code and found the place where code would need to be fixed. I stopped short
of developing a patch before starting to write email to pgsql-hackers mailing
list. While I was writing the email, on a whim I decided to read the
documentation. A cursory read of the docs wouldn't have caught it, but because I
was reading the docs to look for mention of the exact behaviour I was seeing, I
found that it was an expected behaviour.  Even though the psql behaviour
violated [POLA][], I could not report the bug because it was known and
expected behaviour. All the effort spent in doing that went down the drain.

[POLA]: https://en.wikipedia.org/wiki/Principle_of_least_astonishment

In essence,
- Pursue the technology<sup>+</sup> that interests you
- Get your hands dirty trying to solve your problem (a.k.a scratch your own itch)
- Don't give up (at least not until you've exhausted all the possibilities)
  - Persist, Persevere
- Reap the benefits of hard-earned knowledge for the rest of your life


_footnote_ +: If your field of work has _techniques_, that means it's a
technology to be learnt and mastered; so in my veiw, fields like art and
politics are also technologies. The technology in these fields may not move fast, but it is still a
technology to learn and improve on.

_footnote_ *: even though I haven't _contributed_ to the community in any significant
capacity in the last few years.

_footnote_ **: I was home alone, since my family is on a trip to India. To be
fair, that was one of the big reasons it took 3 days and not 3 weeks, and very
likely why I did not give up on the goal.

