Subject: What's cooking in git.git (Nov 2022, #07; Tue, 29)


> * tl/pack-bitmap-absolute-paths (2022-11-29) 4 commits
>  - pack-bitmap.c: trace bitmap ignore logs when midx-bitmap is found
>  - pack-bitmap.c: break out of the bitmap loop early if not tracing
>   (merged to 'next' on 2022-11-14 at 34eb0ea05a)

Will the two commits which merged to 'next' on 2022-11-14 at 34eb0ea05a
be taken into 2.39.0-rc0 (or v2.39.0 is frozen already)? 

>  + pack-bitmap.c: avoid exposing absolute paths
>  + pack-bitmap.c: remove unnecessary "open_pack_index()" calls
> 
>  The pack-bitmap machinery is taught to log the paths of redundant
>  bitmap(s) to trace2 instead of stderr.
> 
>  Will merge to 'next'.
>  source: <cover.1669644101.git.dyroneteng@gmail.com>

Thanks.
