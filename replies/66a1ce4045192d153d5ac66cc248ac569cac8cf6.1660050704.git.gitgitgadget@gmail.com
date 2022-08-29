Subject: [PATCH v3 4/5] bundle-uri: add support for http(s):// and file://

Derrick Stolee <derrickstolee@github.com> writes:

> +	while (!strbuf_getline(&line, child_out)) {
> +		if (!line.len)
> +			break;
> +		if (!strcmp(line.buf, "get"))
> +			found_get = 1;
> +	}

Clear implementation for me to read, thanks.

I'm not sure but maybe a nit, should it be a "break;" after
"found_get = 1;" for omitting the left uncencerned capabilities
to quit earlier?

Thanks.
