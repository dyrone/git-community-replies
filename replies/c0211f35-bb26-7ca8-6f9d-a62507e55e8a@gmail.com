Subject: Re: [RFC PATCH 2/2] notes.c: fixed tip when target and append note are both empty

Phillip Wood <phillip.wood123@gmail.com> writes:

> I don't think its written to if we take the 'else if' branch added by
> this patch so we need to initialize it for the free() at the end.

Actually, I didn't get it totally (maybe because my English, sorry for that),
but indeed the 'else if' expose this problem out, so I think to initialize it
is needed.

Thanks.

> We only seem to be using cp.buf.len so we can test check if the original
> note was empty so I think it would be better just to add
>
> 	int note_was_empty;
>
> `	...
>
> 	note_was_empty = !d.buf.len
>
> instead.

Yes, it actually does as you describe above, your suggestion makes it look
better, will apply.

Thank you very much for your detailed review.
