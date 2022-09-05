Subject: [PATCH 5/7] bundle-uri: parse bundle list in config format

Derrick Stolee <derrickstolee@github.com> writes:

> diff --git a/bundle-uri.h b/bundle-uri.h
> index 41a1510a4ac..294ac804140 100644
> --- a/bundle-uri.h
> +++ b/bundle-uri.h
> @@ -71,6 +71,16 @@ int for_all_bundles_in_list(struct bundle_list *list,
>  struct FILE;
>  void print_bundle_list(FILE *fp, struct bundle_list *list);
>
> +/**
> + * A bundle URI may point to a bundle list where the key=value
> + * pairs are provided in config file format. This method is
> + * exposed publicly for testing purposes.
> + */
> +
> +int parse_bundle_list_in_config_format(const char *uri,
> +				       const char *filename,
> +				       struct bundle_list *list);
> +

Although the comment clarifies the purpose of why to introduce
"parse_bundle_list_in_config_format", but I think this API is useful if finally
config format is supported. So far, we have a API names "bundle_uri_parse_line"
which is used to parsing key-value pairs and package into bundle list, I think
maybe we should rename the API name from "parse_bundle_list_in_config_format" to
"bundle_uri_parse_config_format", maybe better in my opinion for more consistent
naming. I think it doesnt break anything, feel free to accept or remain.

Thanks.
