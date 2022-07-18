Subject: Re: [PATCH v5 4/5] pack-bitmap.c: retrieve missing i18n translations


On Date: Tue, 28 Jun 2022 11:07:26 -0700, Junio C Hamano wrote:


> The verb "retrieve" is puzzling.

I use "retrieve" because I think they should be there but actually missing.
But If it's not appropriate here I will change another word like "add".

> "," -> ", ".

Yes.

> If we were to do this, to avoid burdening translators with double
> work, we probably would want to fix the "C" locale version of the
> string, either as a preliminary clean-up before this step, or as
> part of this step.  From Documentation/CodingGuidelines:

Yes.

Does git have any NOT "C" Locale string?

Another doublt is I found something like in:

    File: ./contrib/completion/git-completion.bash
    923    LANG=C LC_ALL=C git merge -s help 2>&1

I think LC_ALL=C will override LANG=C in these cases, so I think
`LC_ALL=C git merge -s help 2>&1` is OK here.

From: https://www.gnu.org/software/gettext/manual/html_node/Locale-Environment-Variables.html#Locale-Environment-Variables.

> Error Messages
>
>  - Do not end error messages with a full stop.
>
>  - Do not capitalize the first word, only because it is the first word
>    in the message ("unable to open %s", not "Unable to open %s").  But
>    "SHA-3 not supported" is fine, because the reason the first word is
>    capitalized is not because it is at the beginning of the sentence,
>    but because the word would be spelled in capital letters even when
>    it appeared in the middle of the sentence.
>
>  - Say what the error is first ("cannot open %s", not "%s: cannot open")

Helpful, fill in blind spots.

Actually, in tr2 some text are printed as capitalized the first word. Is this
entry appropriate for this situation? Whether we should unify the both?
