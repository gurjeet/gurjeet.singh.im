---
layout: post
title:  "Don't Take Automatic Actions"
date:   2020-12-24 00:22:00 -0800
categories: Automation, Magic-actions
---

This [comment][] in a Github issue conversation is an example of the surprise
that the user experiences when they didn't realize their actions in some other
part of the system triggered automatic closure of the issue.

He pushed a commit to the Git repository with the title 'fix #15: ...', and
Github took the liberty of automatically closing the issue. The user caught this
mistake (he didn't intend to close the issue), and reopened it.

This is Gihub's default behaviour, and AFAIK there's no way to disable this
behaviour. If you push a commit to Github that starts with 'fix #ID:', Github
will close that issue in your repository.

The lesson for me here is that design software with the [POLA][] in mind.
Specifically, don't make the software take actions unless the customer
explicitly either takes that action, or approves that action.

Update 1: To identify this behaviour more easily, I'll call this behaviour
["Spooky action at a distance"][spooky action].

[comment]: https://github.com/13-37-org/infnoise/issues/15#issuecomment-453848323
[POLA]: https://en.wikipedia.org/wiki/Principle_of_least_astonishment
[spooky action]: https://en.wikipedia.org/wiki/Quantum_entanglement


