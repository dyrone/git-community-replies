Subject: Re: [PATCH 0/1] pack-bitmap.c: avoid exposing absolute paths

Junio C Hamano <gitster@pobox.com> writes:

> Doesn't it make it harder to diagnose where the extra bitmap file
> you do not need exists (so that you can check if you can/want
> to/need to remove it)?

Yes, if we want that warnings for diagnosing we shouldn't remove the related
path but I think it should build on the security concerns. I don't mean that
to warning the packfile name in a absolute path is a danger, but when serving
a git server maybe we don't want to expose the real path information on server
to client users.

> If the "ignoring extra" is a totally expected situation (e.g. it is
> not suprising if we always ignore the bitmapfile in the alternate
> when we have our own), perhaps we should squelch the warning in such
> expected cases altogether (while warning other cases where we see
> more bitmap files than we expect to see, which may be an anomaly
> worth warning about), and that may be an improvement worth spending
> development cycles on, but I am not sure about this one.

That's exactly good suggestion. In my opinion, I think to avoid the sensitive
warning and the same time we keep some information to let the users know "Oh,
there are some extra existing bitmaps we just ignored then maybe can do some
optimization works", but I think just remove the total warning here is
reasonable also, i'm good with it.

Thanks.
