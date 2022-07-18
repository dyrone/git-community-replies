Subject: Re: [PATCH v5 4/5] pack-bitmap.c: retrieve missing i18n translations

On Tue, 28 Jun 2022 13:28:31 -0400, Eric Sunshine wrote:

> > On Tue, Jun 28 2022, Teng Long wrote:
> > >       if (bitmap_equals(result, tdata.base))
> > > -             fprintf(stderr, "OK!\n");
> > > +             fprintf(stderr, _("OK!\n"));
>
> As a minor additional bit of help, you can use fprintf_ln() from
> strbuf.h which will automatically output the trailing "\n":

Yes, agree.

> (Aside: Use of fprintf() here is a bit odd since there are no
> formatting directives in the argument, thus fputs() would have been a
> better choice, but that's a cleanup for another day and a different
> patch series, probably.)

*nod*, by the way, I think I will remove the translation on "OK!", currently I
think it doesnt mean much.

Thanks.
