Subject: Re: What's cooking in git.git (Nov 2022, #07; Tue, 29)

Junio C Hamano <gitster@pobox.com> writes:

> >> * tl/pack-bitmap-absolute-paths (2022-11-29) 4 commits
> >>  - pack-bitmap.c: trace bitmap ignore logs when midx-bitmap is found
> >>  - pack-bitmap.c: break out of the bitmap loop early if not tracing
> >>   (merged to 'next' on 2022-11-14 at 34eb0ea05a)
> >
> > Will the two commits which merged to 'next' on 2022-11-14 at 34eb0ea05a
> > be taken into 2.39.0-rc0 (or v2.39.0 is frozen already)?
>
> 2.39-rc0 was a preview of topics that were already done at that
> point about a week ago.  A topic that is not in -rc0 may hit the
> release, but it depends on how urgent the "fix" is, I would say.
> Unless there is a good reason not to, any topic should spend at
> least a week to cook in 'next' before graduating, and because there
> typically is about a week between -rc0 and -rc1, anything outside
> 'next' when -rc0 was tagged is not likely to have spent a week in
> 'next' when -rc1 is done.
>
> We could graduate the early bits separately, but is it so urgent a
> fix to get them in?
>
> I spent a few dozens of minutes to re-read these two patches, and
> while I do not think they are so complex and risky, I did not see
> anything in them to give them such an urgency (for that matter, I
> am not sure if they are even necessary, especially the one that
> loses information from the logs).

I confirmed that our understanding is consistent by your explanation.

Thanks.
