Subject: Re: [PATCH v7 4/4] notes.c: don't do stripespace when parse file arg

Junio C Hamano <gitster@pobox.com> writes:

> > The file maybe is a binary and it could contains multiple line
>
> "could contain"?

Will fix.

> > breaks, if we do the stripespace on it's content, the notes will
>
> "stripspace"?

Will fix, also in the commit subject.

> If a file is "binary" then by definition there is no "line" and no
> "line break" in it, so while I can see what you are trying to say,
> this needs a bit rephrasing to make it easier to follow for future
> readers.  Perhaps something like...
>
>     The file given to the "-F" option could be binary, in which case
>     we want to store it verbatim without corrupting its contents.

Thanks, the phrasing is obviously better.

> But I do not necessarily agree with the logic here, regardless of
> how it is phrased.  Existing users are used to seeing the contents
> fed from "-F <file>" get cleaned up, and to them, this unconditional
> removal of stripspace() will be a regression.  Besides, don't they
> expect that
>
> 	-m="$(cat file)"
>
> be equivalent to
>
> 	-F file

> for their text file?

Yes, for text file. I agree and I actually notice it will be
a regression, because I didn't figure out when user might
store a binary file's content in notes, so I'd like to discuss
about this issue.

> A --binary-file=<file> option that is incompatible with -m/-F and
> "append" action may make sense if we really want to have a feature
> to help those who want to attach binary contents as a note to
> objects.

Actually, -m/-F/-c/-C in 'git notes add' is quite like the
options in 'git commit', rather than "--binary-file=", I think
maybe '--[no-]stripspace' is a bit better.  Defaults to
'--stripspace' which keeps old logic (stripspace the string fed by
-m/-F). If specifying '--no-stripspace', we do not stripespace.

Thanks.
