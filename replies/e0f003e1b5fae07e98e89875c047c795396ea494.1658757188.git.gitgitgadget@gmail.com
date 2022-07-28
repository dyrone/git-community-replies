Subject: [PATCH v3 1/2] docs: document bundle URI standard

Derrick Stolee <derrickstolee@github.com> writes:

> +bundle.heuristic::
> +	If this string-valued key exists, then the bundle list is designed to
> +	work well with incremental `git fetch` commands. The heuristic signals
> +	that there are additional keys available for each bundle that help
> +	determine which subset of bundles the client should download. The only
> +  heuristic currently planned is `creationToken`.

Seem like there is a small indent nit at the last line?

Thanks.
