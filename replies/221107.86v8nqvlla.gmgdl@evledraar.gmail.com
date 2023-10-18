Subject: Re: [PATCH v2 1/3] notes.c: introduce "--blank-line" option

"Ævar Arnfjörð Bjarmason" <avarab@gmail.com> writes:

> I think the right thin to do is to just drop the strbuf_grow() here
> altogether, since strbuf_insert() will handle it for us, but that would
> make sense before this change, so maybe in pre-cleanup?

Sorry for ignoring this line of code. I think you are right, and I will
make a separate pre-cleanup commit for this in next round.

Thanks.
