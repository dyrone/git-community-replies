Subject: Re: [PATCH 0/1] pack-bitmap.c: avoid exposing absolute paths

"Ævar Arnfjörð Bjarmason" <avarab@gmail.com> writes：

> I see that downthread of here there's discussion about keeping the
> warning, adding tracing, etc. etc.
>
> Maybe it's been brought up (I was skimming, sorry), but for the problem
> you have isn't a narrow and acceptable solution to you to keep the
> warning, but just don't print the absolute path?
>
> I.e.:
>
> 	warning: ignoring extra bitmap file: /Users/tenglong.tl/Downloads/alternate_repo.git/.git/objects/pack/pack-bff67e2a7a154e6933afe61b3681726cf9bd8e8b.pack
>
> To:
>
> 	warning: ignoring extra bitmap file: ../alternate_repo.git/.git/objects/pack/pack-bff67e2a7a154e6933afe61b3681726cf9bd8e8b.pack
>
> Or would the relative path to the alternate also be sensitive?
>
> We might also want to just remove this etc., but that's a different
> question than "should we print these absolute paths?".

Oops, sorry for that mistake, and I just sent the patch v2, and the trace2
output might like:

19:33:24.360684 common-main.c:49             | d0 | main                     | version      |     |           |           |              | 2.37.2.1.g520f5131b7c.dirty
19:33:24.360963 common-main.c:50             | d0 | main                     | start        |     |  0.001820 |           |              | /usr/local/bin/git rev-list --test-bitmap HEAD
19:33:24.361487 git.c:461                    | d0 | main                     | cmd_name     |     |           |           |              | rev-list (rev-list)
19:33:24.364617 pack-bitmap.c:435            | d0 | main                     | data         | r0  |  0.005497 |  0.005497 | bitmap       | opened bitmap file:pack-c9fe9d2dc5d002d4a4b622626ffa282bcbccb7ee.pack
19:33:24.365635 pack-bitmap.c:409            | d0 | main                     | data         | r0  |  0.006518 |  0.006518 | bitmap       | ignoring extra bitmap file:pack-3cea516b416961285fd8f519e12102b19bcf257e.pack
Bitmap v1 test (2 entries loaded)
Found bitmap for 2c5959955b5e6167181d08eeb30ee4099b4a4c5b. 64 bits / ca44d5df checksum
19:33:24.365970 progress.c:268               | d0 | main                     | region_enter | r0  |  0.006853 |           | progress     | label:Verifying bitmap entries
Verifying bitmap entries: 100% (6/6), done.
19:33:24.366479 progress.c:340               | d0 | main                     | data         | r0  |  0.007362 |  0.000509 | progress     | ..total_objects:6
19:33:24.366493 progress.c:346               | d0 | main                     | region_leave | r0  |  0.007377 |  0.000524 | progress     | label:Verifying bitmap entries
OK!
19:33:24.366558 wrapper.c:621                | d0 | main                     | data         | r0  |  0.007442 |  0.007442 | fsync        | fsync/writeout-only:0
19:33:24.366572 wrapper.c:622                | d0 | main                     | data         | r0  |  0.007456 |  0.007456 | fsync        | fsync/hardware-flush:0
19:33:24.366578 git.c:720                    | d0 | main                     | exit         |     |  0.007463 |           |              | code:0
19:33:24.366592 trace2/tr2_tgt_perf.c:215    | d0 | main                     | atexit       |     |  0.007476 |           |              | code:0

In short, the "related path" will not appear in output now but the "basename"
(packname) instead. I think maybe it will help the experts like Taylor who
often hacking the bitmap code.

Thanks.
