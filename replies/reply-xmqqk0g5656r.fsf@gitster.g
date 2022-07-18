Subject: Re: [PATCH v5 1/1] ls-tree.c: support `--object-only` option for "git-ls-tree"


> I notice that this changed from --oid to --object and I agree that
> it would probably be more friendly to end users.  In fact, this
>
>    $ sed -ne '/^SYNOPSIS/,/^DESCRIPTION/p' Documentation/git-*.txt |
>      grep -e -oid
>
> did not find any hits.

Thank you for comfirming that.

> It usually is a good idea to enclose these in () so that they are
> safe to use in any context in a statement.
> 
> Luckily, bitwise-or and bitwise-and, which are the most likely
> candidates for these symbols to be used with, bind looser than
> left-shift, so something like 
> 
> 	if ((LS_TREE_ONLY | LS_SHOW_TREES) & opt)
> 		... do this ...
> 
> is safe either way, but (LS_TREE_ONLY + LS_SHOW_TREES) would have
> different value with and without () around (1 << N).

Make sense.

Will fix in patch v6.


> Style: we do not initialize statics explicitly to zero.
> ...
> Likewise.  It is a bit curious to see these listed in decreasing
> order, though.

Will fix.

> It is a good idea to leave a comma even after the last element,
> _unless_ there is a strong reason why the element that currently is
> at the last MUST stay to be last when new elements are added to the
> enum.  That way, a future patch that adds a new element can add it
> to the list with a patch noise with fewer lines.

Very clear explanation.

Will fix.

> A better name, anybody?
> 
> This bit is to keep track of the fact that we made _some_ output
> already so any further output needs an inter-field space before
> writing what it wants to write out.

I found a word "interspace", it looks like a little better than the old
one. I will rename to it in next patch, and If there's a better idea,
will apply further.

> SP before ','.

Will fix.


> Curious.  I wonder if we can get rid of these two lines (and the
> line_termination bit in the SHOW_FILE_NAME part), and have an
> unconditional 
> 
> 	putchar(line_termination);
> 
> at the end of the function.
> 
> That way, we could in the future choose to introduce a feature to
> show only <mode, type, size> and nothing else, which may be useful
> for taking per-type stats.
> 
> We need to stop using write_name_quoted_relative() in SHOW_FILE_NAME
> part, because the helper insists that the name written by it must be
> at the end of the entry, if we go that route, but it may be a good
> change in the longer term.

Let me try to represent to make sure I understand your suggestion
sufficiently.

"write_name_quoted_relative" is used to compute the relative file name
by "prefix" and output the name and a line termination to the given FD.

We do not want use "write_name_quoted_relative" in here because the
function alway output a line termination after "name", this may bring
some inconvenience because the "name" may not be the last field in the
future.

So, instead:

We need to calculate the file name (relative path and quotes if need)
without "write_name_quoted_relative"  and then output the line
termination before return.


Thanks.
