Subject: [PATCH 4/7] bundle-uri: unit test "key=value" parsing

Ævar Arnfjörð Bjarmason <avarab@gmail.com> writes
> +void print_bundle_list(FILE *fp, struct bundle_list *list)
> +{
> +	const char *mode;
> +
> +	switch (list->mode) {
> +	case BUNDLE_MODE_ALL:
> +		mode = "all";
> +		break;
> +
> +	case BUNDLE_MODE_ANY:
> +		mode = "any";
> +		break;
> +
> +	case BUNDLE_MODE_NONE:
> +	default:
> +		mode = "<unknown>";
> +	}
> +
> +	printf("[bundle]\n");
> +	printf("\tversion = %d\n", list->version);
> +	printf("\tmode = %s\n", mode);
> +
> +	for_all_bundles_in_list(list, summarize_bundle, fp);
> +}

"print_bundle_list" use to print the git config formatting lines of
"bundle_list", it's supported to use a "FILE *fp" as it's output. The
"for_all_bundles_in_list" use it, but other places seems not, I'm not
sure, maybe we should change to:

  fprintf(fp, "[bundle]\n");
  fprintf(fp, "\tversion = %d\n", list->version);
  fprintf(fp, "\tmode = %s\n", mode);

here?

Thanks.
