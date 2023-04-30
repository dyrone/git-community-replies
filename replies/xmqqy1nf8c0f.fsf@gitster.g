Subject: Re: [PATCH v7 3/4] notes.c: introduce '--separator=<paragraph-break>' option

Junio C Hamano <gitster@pobox.com> writes:

> Just FYI, it seems that it is indeed premature to declare that this
> one to be leak-free.  With this topic merged to 'seen', the leak
> checker CI job seems to choke on t3301 (in addition, it also barfs
> on t3307).

Yes, it contains a leak in function "parse_reuse_arg()", will fix.

Thanks.
