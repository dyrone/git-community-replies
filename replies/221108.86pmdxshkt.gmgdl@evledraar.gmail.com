Subject: Re: [PATCH v2 1/3] notes.c: introduce "--blank-line" option

"Ævar Arnfjörð Bjarmason" <avarab@gmail.com> writes:

> Sorry, I meant that in both cases it will expose the same options to the
> user: --blank-line and --no-blank-line. I.e. if you create options
> named:
>
> 	"x" "x-y"
>
> Their negations are: --no-x and --no-x-y. But if their names are:
>
> 	"x" "no-x"
>
> The negations are:
>
> 	--no-x and --x
>
> But as your example shows that's unrelated to whether the *variable in
> the code* is negated.
>
> So however you structure the code, which would be:
>
> 	int blankline = 1:
>         [...]
> 	OPT_BOOL(0, "blankline", &blankline, [...]);
>
> Or:
>
> 	int no_blankline = 0:
>         [...]
> 	OPT_BOOL(0, "no-blankline", &no_blankline, [...]);
>
> The documentation could in both cases say:
>
> 	--no-blankline:
> 		describe the non-default[...]

Thank you for the detailed explanation, now it's clear for me.
