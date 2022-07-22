Subject: Re: [PATCH 2/2] tr2: shows scope unconditionally in addition to key-value pair

Junio C Hamano <gitster@pobox.com> writes:

> Everything in these examples use concrete values and follow the real
> syntax (e.g. param is enclosed in double-quotes and so is its value
> core.abbrev; even though core.abbrev is not the only param that can
> be reported by a def-param event, it is used as a concrete example.
> The same story goes for value).  The new "scope" thing stands out
> like a sore thumb.  I think the above should read more like
>
> 	"event":"def_param",
> 	...
> 	"scope":"global",
> 	"param":"core.abbrev",
> 	"value":"7"
>
> or something.  Pick your favourite value for scope.
>
> Other than that, these two patches make quite a lot of sense.

Yes. I think you are right, in this context, we should obey the same syntax
and will fix in next patch.

Thanks.
