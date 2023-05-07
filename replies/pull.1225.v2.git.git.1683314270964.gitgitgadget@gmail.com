Subject: [PATCH v2] name-rev: make --stdin hidden

 John Cai <johncai86@gmail.com> writes:

>-		OPT_BOOL(0, "stdin", &transform_stdin, N_("deprecated: use --annotate-stdin instead")),
>+		OPT_BOOL_F(0,
>+			   "stdin",
>+			   &transform_stdin,
>+			   N_("deprecated: use --annotate-stdin instead"),
>+			   PARSE_OPT_HIDDEN),
> 		OPT_BOOL(0, "annotate-stdin", &annotate_stdin, N_("annotate text from stdin")),
> 		OPT_BOOL(0, "undefined", &allow_undefined, N_("allow to print `undefined` names (default)")),
> 		OPT_BOOL(0, "always",     &always,

It seems like there is an odd indent before "&always", of course, it's
not introduced by this patch.

Thanks.
