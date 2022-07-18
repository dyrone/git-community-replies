Subject: Re: What's cooking in git.git (Dec 2021, #05; Thu, 23)


On Thu, 23 Dec 2021 15:42:33 -0800, Junio C Hamano wrote: 


 > "git ls-tree" learns "--oid-only" option, similar to "--name-only".
 > 
 > Will merge to 'next'?
 > source: <cover.1639721750.git.dyroneteng@gmail.com>

Currently, the "source" is patch v6, and there are some test problems in 
[1]. They're not very hard to fix, but I'm considering whether to:

     WAY-1: continue on the current implementation path;

     WAY-2: Combine (steal :) the RFC patch from Ævar Arnfjörð Bjarmason
     and some commits of mine, to the next patch, because some arguments
     given from Ævar are compelling (of couse the test problems will be
     fixed too).

So, I will work on it, I think I will send a new patch based on WAY1
quickly, and send a further RFC patch on WAY2. If both are ok, let the
community decide which one to use.

Thanks.
