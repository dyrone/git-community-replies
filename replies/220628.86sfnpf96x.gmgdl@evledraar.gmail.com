Subject: Re: [PATCH v5 4/5] pack-bitmap.c: retrieve missing i18n translations

> Usually we don't go for cleanup-while-at-it, but in this case we're
> marking messages that don't conform to our CodingGudielines for
> translation, mostly because they're error messages that start with an
> upper-case letter.
>
> So I think we should fix those issues first, to avoid double-work for
> translators (well, a bit less, since they're the translation memory, but
> it's quite a bit of churn...).

Yes. I think it's need to make a cleanup commit first.

> Lose the \n here, in addition to lower-case & quote %s.
> ...
> Ditto don't include \n.
> ...
> Ditto don't translate BUG().
> ..

etc.Will fix.

Thanks.
