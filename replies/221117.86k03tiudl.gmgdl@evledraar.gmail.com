Subject: Re: [RFC PATCH 0/6] ls-tree: introduce '--pattern' option

Taylor Blau <me@ttaylorr.com> writes:

> I think this falls into the same trap as the series on 'git show-ref
> --count' that I worked on earlier this year [1].
>
> At the time, it seemed useful to me (since I was working in an
> environment where counting the number of lines from 'show-ref' was more
> cumbersome than teaching 'show-ref' how to perform the same task
> itself).
>
> And I stand by that value judgement, but sharing the patches with the
> Git mailing list under the intent to merge it in was wrong. Those
> patches were too niche to be more generally useful, and would only serve
> to clutter up the UI of show-ref for everybody else.
>
> So I was glad to drop that topic. Now, I'd be curious to hear from Teng
> whether or not there *is* something that we're missing, since if so, I
> definitely want to know what it is.
>
> But absent of that, I tend to agree with Ævar that I'm not compelled by
> replacing 'ls-tree | grep <pattern>' with 'ls-tree --pattern=<pattern>',
> especially if the latter is slower than the former.
>
> Thanks,
> Taylor
>
> [1]: https://lore.kernel.org/git/cover.1654552560.git.me@ttaylorr.com/

honestly, I just think it's useful to me, but omit the performance recession of
the option. I originally thought about it looks like the "git tag -l <pattern>"
or "git branch -l <pattern>" usage, but it seems not as a regex matching on
them and it indeed executes faster than the pipe grep, because it seems like the
former has the more restrictive matching conditions (because if I move the
last aster， there is no output):


✗ git branch -r --list "avar*" | wc -l
    1498

✗ hyperfine 'git branch -r --list "avar*"'
Benchmark 1: git branch -r --list "avar*"
  Time (mean ± σ):      69.8 ms ±   3.1 ms    [User: 25.8 ms, System: 42.7 ms]
  Range (min … max):    66.6 ms …  81.8 ms    35 runs

✗ hyperfine 'git branch -r --list | grep "avar"'
Benchmark 1: git branch -r --list | grep "avar"
  Time (mean ± σ):      76.4 ms ±   3.7 ms    [User: 32.7 ms, System: 45.2 ms]
  Range (min … max):    72.9 ms …  85.5 ms    34 runs

➜  Documentation git:(tl/extra_bitmap_relative_path) ✗ git branch -r --list "avar" | wc -l
       0

So unless someone finds other benefits, such as the implementation of "git tag
-l <pattern>" to solve the performance problem, this method can bring benefits
in the corresponding scenario. It's ok for me to continue or stop this patch.

Thanks.
