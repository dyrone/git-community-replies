Subject: Re: [RFC PATCH 1/2] notes.c: introduce "--no-blankline" option

"Ævar Arnfjörð Bjarmason" <avarab@gmail.com> writes:

> Use <<-\EOF here.

As do not escape the heredoc, will apply.

> We usually indent the "EOF" body the same as the "cat", but...
> ... I see this test might be an odd one out, so this is fine.

Yes, the indent sometimes make a little confusion unless you want
to keep it as "<<\EOF".

Thanks for your meticulous reading!
