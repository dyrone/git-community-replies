Subject: Re: [PATCH v7 3/4] notes.c: introduce '--separator=<paragraph-break>' option

Junio C Hamano <gitster@pobox.com> writes:

> > The default behavour sometimes is not enough, the user may want
> > to use a custom delimiter between paragraphs, like when
> > specifiy '-m', '-F', '-C', '-c' options. So this commit
>
> "like when specifying", you mean?
>
> "when executing"?
>
> >     $ git notes add -m foo -m bar --separator="-"
> >     $ git notes show HEAD | cat
> >     foo
> >     -
> >     bar
> >
> > A newline is added to the value given to --separator if it
>
> "a newline is ...", because this is not starting a new sentence, but
> continuing from the "for example, when ..." above.
>
> "a newline is ...", because this is not starting a new sentence, but
> continuing from the "for example, when ..." above.
>
> > does not end with one already. So execute:
> >
> >       $ git notes add -m foo -m bar --separator="-"
> > and
> >       $ export LF="
> >       "
> >       $ git notes add -m foo -m bar --separator="-$LF"
> >
> > Running A and B produces the same result.
>
> Here, it is totally unclear what A and B refers to.  "both
> ... and ... produce the same result" or something?

will fix, thanks.

> > @@ -101,6 +102,9 @@ struct note_data {
> >  	int use_editor;
> >  	char *edit_path;
> >  	struct strbuf buf;
> > +	struct strbuf **messages;
> > +	size_t msg_nr;
> > +	size_t msg_alloc;
> >  };
>
> Hmph, OK.  I'd think twice before allowing an array of strbufs,
> though.  strbuf is an excellent data structure to allow editing
> string safely, and an array of strbufs may be very useful when these
> strings need to be edited simultaneously, but such a use case is
> very rare and I suspect this would not be it---rather, don't we take
> one string at a time while processing each option, perhaps running
> stripspace, and then after that aren't we done with the string until
> when we finally have these N strings to loop over and concatenate
> into a single string?  It would be sensible to use a strbuf to
> produce the concatenation, but the strings to be concatenated do not
> have to come from strbufs.  So my intuition, before reading the code
> but after seeing the data structure, says that "const char **messages"
> might be more appropriate here.  It sends a strong message about the
> code structure and "phases" of processing, i.e. "we read each piece
> and store it in the array once we are done preprocessing; then in
> the next phase we concatenate them".

I used string in previous patch, but I found there will be a problem when
specify a binary file to '-F', that is, a binary file maybe contains NUL in
the middle, then if we feed the content to a string, it will be cut off when
appending to the 'string_list'.  So, it seems that strbuf could solve the
issue (will be reproduced as a failure in t3307).

> > @@ -209,71 +213,110 @@ static void write_note_data(struct note_data *d, struct object_id *oid)
> >  	}
> >  }
> >
> > +static void insert_separator(struct strbuf *message, size_t pos)
> > +{
> > +	if (!separator)
> > +		strbuf_insertstr(message, pos, "\n");
> > +	else if (separator[strlen(separator) - 1] == '\n')
> > +		strbuf_insertstr(message, pos, separator);
> > +	else
> > +		strbuf_insertf(message, pos, "%s%s", separator, "\n");
> > +}
>
> Do we need "insert" separator?  The caller in "concat" certainly
> shouldn't---all it needs is "append".

OK, I'm willing to try to do that, "insert at a position" actually because
there is a related codepath need to add the separator in the very beginning.

> > +/* Consume messages and append them into d->buf, then free them */
> > +static void concat_messages(struct note_data *d)
> > +{
> > +	struct strbuf msg = STRBUF_INIT;
> > +
> > +	size_t i;
> > +	for (i = 0; i < d->msg_nr ; i++) {
> > +		if (d->buf.len)
> > +			insert_separator(&d->buf, d->buf.len);
> > +		strbuf_add(&msg, d->messages[i]->buf, d->messages[i]->len);
> > +		strbuf_addbuf(&d->buf, &msg);
> > +		strbuf_reset(&msg);
> > +		strbuf_release(d->messages[i]);
> > +		free(d->messages[i]);
> > +	}
> > +	strbuf_release(&msg);
> > +	free(d->messages);
> > +}
>
> As I suspected earlier, with the way d->messages[i] are used, they
> have no reason to be strbufs---they can and should be a simple
> string "const char *".

As I said about why I choose strbuf in the above, but I expect your
further advice on that.

> >  static int parse_msg_arg(const struct option *opt, const char *arg, int unset)
> >  {
> >  	struct note_data *d = opt->value;
> > +	struct strbuf *buf;
> >
> >  	BUG_ON_OPT_NEG(unset);
> >
> > -	if (d->buf.len)
> > -		strbuf_addch(&d->buf, '\n');
> > -	strbuf_addstr(&d->buf, arg);
> > -	strbuf_stripspace(&d->buf, 0);
> > +	buf = xmalloc(sizeof(*buf));
> > +	strbuf_init(buf, strlen(arg));
> > +	strbuf_addstr(buf, arg);
> > +	strbuf_stripspace(buf, 0);
> >
> > -	d->given = 1;
> > +	ALLOC_GROW_BY(d->messages, d->msg_nr, 1, d->msg_alloc);
> > +	d->messages[d->msg_nr - 1] = buf;
> >  	return 0;
> >  }
>
> And this one can use an on-stack strbuf (initialized with STRBUF_INIT),
> and strbuf_detach() the result into d->messages[].

> >  static int parse_file_arg(const struct option *opt, const char *arg, int unset)
> >  {
> >  	struct note_data *d = opt->value;
> > +	struct strbuf *buf;

> Likewise.

For the same reason as above I think.

> >
> >  	BUG_ON_OPT_NEG(unset);
> >
> > -	if (d->buf.len)
> > -		strbuf_addch(&d->buf, '\n');
> > +	buf = xmalloc(sizeof(*buf));
> > +	strbuf_init(buf, 0);
> > +
> >  	if (!strcmp(arg, "-")) {
> > -		if (strbuf_read(&d->buf, 0, 1024) < 0)
> > +		if (strbuf_read(buf, 0, 1024) < 0)
> >  			die_errno(_("cannot read '%s'"), arg);
> > -	} else if (strbuf_read_file(&d->buf, arg, 1024) < 0)
> > +	} else if (strbuf_read_file(buf, arg, 1024) < 0)
> >  		die_errno(_("could not open or read '%s'"), arg);
> > -	strbuf_stripspace(&d->buf, 0);
> > +	strbuf_stripspace(buf, 0);
> >
> > -	d->given = 1;
> > +	// we will note stripspace the buf here, because the file maybe
> > +	// is a binary and it maybe contains multiple continuous line breaks.
>
> No // comments in our codebase.

Will fix.

> > @@ -567,7 +617,8 @@ static int append_edit(int argc, const char **argv, const char *prefix)
> >  	const struct object_id *note;
> >  	char *logmsg;
> >  	const char * const *usage;
> > -	struct note_data d = { .buf = STRBUF_INIT };
> > +	struct note_data d = { .buf = STRBUF_INIT, .messages = NULL };
>
> Why explicitly initialize .messages to NULL when we are leaving
> other members to zero initialized implicitly by using designated
> initializers?

My bad, will fix.

> > @@ -618,7 +675,7 @@ static int append_edit(int argc, const char **argv, const char *prefix)
> >  		char *prev_buf = read_object_file(note, &type, &size);
> >
> >  		if (d.buf.len && prev_buf && size)
> > -			strbuf_insertstr(&d.buf, 0, "\n");
> > +			insert_separator(&d.buf, 0);
> >  		if (prev_buf && size)
> >  			strbuf_insert(&d.buf, 0, prev_buf, size);
> >  		free(prev_buf);
>
> Having to insert two things in front of d.buf feels somewhat
> wasteful. ...

"wasteful" for?

> ... I wonder if we can easily reorder the logic to first read
> the previous one, and then append new stuff to it, perhaps?

I think it can be done in this way, but in another single commit, perhaps?

> It wouldn't be a huge deal.  If this weren't the only reason why we
> need to invent insertstr that takes "where", I wouldn't even be
> mentioning it.

This makes me think that there is a need for a method 'insert_separator'? For
example, to initialize 'separator' and then use 'strbuf_insertstr' directly?
I'm not sure, but it feels like it could work.


> > diff --git a/t/t3301-notes.sh b/t/t3301-notes.sh
> > index 3288aaec..716192b5 100755
> > --- a/t/t3301-notes.sh
> > +++ b/t/t3301-notes.sh
> > @@ -5,6 +5,7 @@
> >
> >  test_description='Test commit notes'
> >
> > +TEST_PASSES_SANITIZE_LEAK=true
> >  . ./test-lib.sh
>
> This is a strange commit to add this.  If the test and the code
> involved in the test were leak-sanitizer clean before this commit,
> then you should have been able to insert this without any other
> change, and we should do it that way in a separate commit.  If we
> are fixing an existing leak that the sanitizer complains, then that
> is a different matter.  If that is the case, it makes perfect sense
> to have this here, but the proposed commit log message should
> explain that it is what is happening.

Will fix.

Thanks.
