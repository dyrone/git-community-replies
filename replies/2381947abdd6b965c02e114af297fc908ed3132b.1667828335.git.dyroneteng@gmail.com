Subject: Re: [PATCH v2 1/3] notes.c: introduce "--blank-line" option

Taylor Blau <me@ttaylorr.com> writes:

* Actually that's my suggestion, because I found when I use "git notes appends"
to append new content to an existing note. It will always insert a blank line
between the existing and the new. Does "append" represent "a blank line first
then the content"? If the user does not want it, there may be no way to
circumvent this on "append" at present. For example:

--------example start-------

Here is a commit with notes (from a openstack community repo), the notes is as:

commit ...(HEAD -> master, origin/master, origin/HEAD)
Author: ...
Date:   ...

    .....
    Change-Id: ....

Notes (review):
    Code-Review+2: yatin <ykarel@redhat.com>
    Code-Review+2: chandan kumar <chkumar@redhat.com>
    Workflow+1: chandan kumar <chkumar@redhat.com>
    Verified+1: RDO Third Party CI <dmsimard+rdothirdparty@redhat.com>
    Verified+2: Zuul
    Submitted-by: Zuul
    Submitted-at: Wed, 28 Sep 2022 12:58:46 +0000
    Reviewed-on: https://review.opendev.org/c/openstack/tripleo-quickstart/+/859516
    Project: openstack/tripleo-quickstart
    Branch: refs/heads/master

So, if user wants to append this notes, actually will add a blank line, maybe a
surprise. But I may not represent most users, so I added this compatible option,
maybe better to let the use choose, then send this as a RFC patch.

--------example finished-------

* Another reason is, I found that if I append nothing to a commit (here on my case
is HEAD) which doesn't exist notes on it, the output "Removing note for
object" shows something a little intesting to me, because there is no note to
remove, that's what 2/3 does. The following are specific examples:

--------example start-------

➜  git-notes-test git:(tl/test) ✗ git --no-pager log HEAD -n 1
commit d5a0127568e89239bb02f78d44dfa0427e726103 (HEAD -> tl/test)
Author: tenglong.tl <tenglong.tl@alibaba-inc.com>
Date:   Thu Oct 20 18:09:16 2022 +0800

    111
➜  git-notes-test git:(tl/test) ✗ git notes append -m ""
Removing note for object d5a0127568e89239bb02f78d44dfa0427e726103

--------example finished-------

Thanks.
