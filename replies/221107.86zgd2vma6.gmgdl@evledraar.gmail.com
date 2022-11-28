Subject: Re: [PATCH v2 0/3] notes.c: introduce "--blank-line" option

"Ævar Arnfjörð Bjarmason" <avarab@gmail.com> writes:

> > From: Teng Long <dyroneteng@gmail.com>
> > [...]
> > * drop unreachable code in "append_edit()". Ævar found that some code has been
> > unreachable in patch v1. I think it's because, after the commit "notes.c: fixed
> > tip when target and append note are both empty", for example in this patch, the
> > situation of "removing an existing note" should be impossible unless a BUG when
> > trying to do append. The tests are passed, but I'm not sure I fully understand
> > the original design.
>
> I suggested squashing that BUG() in 3/3 into 2/3, but reading this again
> I think it should come first.
>
> I.e. this seems to me like the code in cd067d3bf4e (Builtin-ify
> git-notes, 2010-02-13) might have just been blindly carried forward to
> both "create" and "edit" in 52694cdabbf (builtin/notes: split
> create_note() to clarify add vs. remove logic, 2014-11-12).
>
> But it would be good to have confirmation, e.g. if you check out
> 52694cdabbf and remove that "Removing note" branch from add() does it
> fail tests at the time, but not in the case of append_edit()?

Thanks for mention that. I look back to 52694cdabbf and remove "Removing note"
will make the test fail, because the notes operation "append" is different with
"add", the latter supports to overwrite the existing note then let the
"removing" happen (e.g. execute `git notes add -f -F /dev/null` on an existing
note), but the former will not because it only does "appends" but not doing
"overwrites".

So, I think may just remove the "Removing note" code in append_edit() is OK.

Thanks.
