Subject: Re: [PATCH v5 3/3] notes.c: introduce "--separator" option

Junio C Hamano <gitster@pobox.com> writes:

> > We use "parse_msg_arg" as a callback when parsing "-m " by OPT_CALLBACK_F,
> > so if we have to read the separator before we parse it, so we could insert
> > it correctly between the messages, So I use OPT_STRING_LIST instead.
>
> That is an implementation detail of how you chose to implement the
> feature, and not an inherent limitation, is it?  It makes a lame
> excuse to give users a hard-to-use UI.

> For example, we could parse all the command line parameters without
> making any action other than recording the strings given to -m and
> contents of files given via -F in the order they appeared on the
> command line, all in a single string list, while remembering the
> last value of --separator you got, and then at the end concatenate
> these strings using the final value of the separator, no?

Yes, please let'me clarify it, we shouldn't to give users a hard-to-use UI, so:

     1. order of "-m" and "-F" matters, it determine the order of the paragraphs
     (remain the same as before, which I need to fix in next patch).

     2. order of "-m""-F" and "--separator" doesn't matter.

Thanks.
