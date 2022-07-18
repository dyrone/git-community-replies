Subject: Re: [PATCH v4 1/1] ls-tree.c: support `--oid-only` option for "git-ls-tree"

On Tue, 23 Nov 2021 14:32:35 -0800, Junio C Hamano wrote:

> I can guess what "intercept the origin" wants to say, but it does
>not roll off the tongue very well.
>
> cf. Documentation/SubmittingPatches[[imperative-mood]]

Will learn and borrow your sentences and be shown in next patch :)

> This does not work well with "--long", right?

I think so.

Peff pointed out this is arguably a bug before because
`git ls-tree --long --name-only` do not really make sense (column of
the object size is not shown in result).

> Usually we say A is "Consistent" with B when A and B are different
> but are moral equivalent in their respective contexts.  These are
> identical, there is no difference.

Clearly understood now.

> Lose all of the above change, except for "Cannot be combined with".
> The original is just fine.

Will.

> Or "--long"?  Does this work with it?

As I understand the disscussed context so far, the "--long", "--name-only"
and "--oid-only" they should be mutually exclusive with each other.

> I suspect that "--long" would be part of this, if we were to go this
> route.

Agree.

> OPT_CMDMODE() is a handy way to ensure "--name-only", "--oid-only",
> and "--long" are not given together, but it may be overkill to make
> only two or three options mutually exclusive.
>
> In any case, once we pass the parsing part, the code should
> translate the option into a bitmask that specifies which among
> <mode>, <type>, <object-name>, <size>, and <filename> fields are
> shown.  It will result in cleaner code in show_tree() if it uses
> that set of fields to decide what is shown and how without looking
> at the cmdmode enum.

Make sense.

Thanks.
