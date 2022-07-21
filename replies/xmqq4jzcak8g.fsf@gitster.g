Subject: Re: [PATCH v7 7/7] tr2: dump names if config exist in multiple scopes

Junio C Hamano <gitster@pobox.com> writes:

> This make it sound as if we do not show the scope if a configuration
> variable appears only in one scope, but I do not see how the updated
> code achieves that.  Instead, it seems that it shows the scope
> unconditionally in addition to the key-value pair.

Yes. There is a problem with this statement. I will fix it, maybe like:

  tr2: print corresponding scope with config key-value

> If that is the case, a retitle is in order.  Also this should
> probably be a separate topic, unrelated from the other 6 patches.

That's the case. I will send the [0-6] as the v8, and separate [7/7]
as a new patch series.

Thanks.
