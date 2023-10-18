Subject: Re: [PATCH v4 3/4] pack-bitmap.c: break out of the bitmap loop early if not tracing

Junio C Hamano <gitster@pobox.com> writes:

> From: Jeff King <peff@peff.net>
>
> When we successfully open a bitmap, we will continue to try to open
> other packs, and when trace2 is enabled, we will report any subsequent
> bitmap ignored information in the log. So when we find that trace2 is
> not enabled, we can actually terminate the loop early.

> The above took me a few reads to understand what it wants to say,
> probably because the "and when trace2 is enabled" comes a bit too
> late to explain why "try to open other" is done.  After reading it a
> few times, here is what I think it wants to say:
>
>     After opening a bitmap successfully, we try opening others only
>     because we want to report that other bitmap files are ignored in
>     the trace2 log.  When trace2 is not enabled, we do not have to
>     do any of that.

Thanks for the reword, will apply in reroll.
