Subject: [PATCH 7/7] bundle-uri: fetch a list of bundles


Derrick Stolee <derrickstolee@github.com> writes:

>  int fetch_bundle_uri(struct repository *r, const char *uri)
>  {
> -	return fetch_bundle_uri_internal(r, uri, 0);
> +	int result;
> +	struct bundle_list list;
> +	struct remote_bundle_info bundle = {
> +		.uri = xstrdup(uri),
> +		.id = xstrdup("<root>"),

Very readable code, thank you very much.

I'm a little curious why we use the "<root>" as the init value of
".id"?

Thanks.
