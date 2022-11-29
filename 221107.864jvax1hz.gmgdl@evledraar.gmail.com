Subject: Re: [PATCH v2 1/3] notes.c: introduce "--blank-line" option

"Ævar Arnfjörð Bjarmason" <avarab@gmail.com> writes:

> Just make this:
>
> 	--no-blank-line:
> 		Suppress the insertion of a blank line before the
> 		inserted notes.
>
> Or something, i.e. when adding a "true by default" let's add a "no-..." variant
> directly.
>
> ...

Yes, that's what I propose to do originally, but I can accept either NEG or POS
way. So, I will hang this up for a while and try to hear more inputs.

> > -		if (d.buf.len && prev_buf && size)
> > +		if (blankline && d.buf.len && prev_buf && size)
> >  			strbuf_insertstr(&d.buf, 0, "\n");
>
> Maybe this needs to be elaborated in the docs? I.e. it sounds as if
> we'll insert a \n unconditionally, which this shows isn't the case.

The current doc add the content about this circumstance corresponing to this
"if", which describes as:

>  append::
>  	Append to the notes of an existing object (defaults to HEAD).
> -	Creates a new notes object if needed.
> +	Creates a new notes object if needed. If the note of the given
> +	object and the note to be appended are not empty, a blank line
> +	will be inserted between them.

... so you mean we should add more detailed information here?

> This should be a test_when_finished "", for the previous test, otherwise
> this one will presumably fail if you use the "wrong" --run="" arguments
> to skip the last test.

Yes, I agree, will fix (although if we replace it by "test_when_finished,
because of the dependency of the previous repo status, execute
`sh t3301-notes.sh --run=60` also failed).
