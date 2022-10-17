Subject: Re: [RFC PATCH 1/2] notes.c: introduce "--no-blankline" option

Junio C Hamano <gitster@pobox.com> writes:

> --blank-line::
> --no-blank-line::
> 	Controls if a blank line to split paragraphs is inserted
>         when appending (the default is true).

Will fix, "OPT_BOOL" will automatically deal the "--no" prefix, nice design.

> Use
>
> 	int blankline = 1;
>
> to avoid double negative, which is confusing and error prone.

Perfectly reasonable opinion, will fix.

> 	OPT_BOOL(0, "blank-line", &blankline,
> 		 N_("insert paragraph break before appending to an existing note")),
> Then, the conditional would read more naturally without double
> negation.
>
> 		if (blank_line && d.buf.len && prev_buf && size)

Will apply.

> I do not know and I am not judging (yet) if the goal of the patch is
> sensible (in other words, if we should have such an option), but if
> we were to do so, I would expect the implementation to look more
> like what I outlined above.

In fact, as I was learning about this feature, I thought this parameter might be
helpful, so I tried to send this small patch and maybe  I can get some input.

Thank you so much for taking the time to review this patch.
