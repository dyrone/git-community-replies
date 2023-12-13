Subject: [PATCH v3 2/3] update-index: add --show-index-version

Junio C Hamano <gitster@pobox.com> writes:

> @@ -1181,15 +1183,20 @@ int cmd_update_index(int argc, const char **argv, const char *prefix)
>  
>  	getline_fn = nul_term_line ? strbuf_getline_nul : strbuf_getline_lf;
>  	if (preferred_index_format) {
> -		if (preferred_index_format < INDEX_FORMAT_LB ||
> -		    INDEX_FORMAT_UB < preferred_index_format)
> +		if (preferred_index_format < 0) {
> +			printf(_("%d\n"), the_index.version);

Maybe the "%d\n" shouldn't be translated? :)

Thanks.
