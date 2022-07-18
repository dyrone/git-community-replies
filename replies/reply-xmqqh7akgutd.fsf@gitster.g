Subject: Re: [PATCH v8 6/8] ls-tree.c: support --object-only option for "git-ls-tree"

Junio C Hamano <gitster@pobox.com> writes:

> The resulting code looks unnecessarily complex and brittle; some
> SHOW_FOO mean SHOW_FOO_ONLY_AND_NOTHING_ELSE while other SHOW_BAR
> means SHOW_BAR_BUT_WE_MAY_SHOW_OTHER_THINGS_IN_LATER_PART, and the
> distinction is not clear from their names (which means it is hard
> to later extend and enhance the behaviour of the code).

I agree with you that the relevant code is not very clear, So I
think I will take these steps:

1. Rename "shown_bits" -> "shown_fields"

   essentially we want to show the fields but not bits to user that
   may firstly solve the unclear nameing problem for "shown_bits"
   itself.

2. Rename related macro definitions of "shown_fields by :


	   SHOW_FILE_NAME -> FILE_NAME_FIELD
    	   SHOW_SIZE -> SIZE_FIELD
    	   SHOW_OBJECT_NAME -> OBJECT_NAME_FIELD
    	   SHOW_TYPE -> TYPE_FIELD
    	   SHOW_DEFAULT -> DEFAULT_FIELDS

    I think the confusion comes from " SHOW_FOO_ONLY_AND_NOTHING_ELSE"
    and " SHOW_BAR_BUT_WE_MAY_SHOW_OTHER_THINGS_IN_LATER_PART" is
    because some macros's is named by mixed the "flags" and "the
    operation of flags" together. 

    So with renamings, we try to unify these definitions meaning,
    they are just used for defining a "field" with a specified
    non-repetitive bits.
    
    After that, you can show many "fields" by combining any of "fields",
    such as what the builtin "DEFAULT_FIELDS" does, it shows all the
    fields but except the "size" field.

    By far, the "field(s)" only means the definition themselfs, and
    no business with "which one/ones" or  "how" to shown.

3. Decide "which" fields need to show

   The definition of "WHICH_FIELDS_TO_SHOWN" is by "shown_fields",
   it's used for parse from the options and compute it's value
   by function "parse_shown_fields()".

   Actually, the function already represent what work it do,
   but the problem is I didn't notice to rename "show_bits"
   to "show_fields" before. This may bring some confusion,
   because we are not going to show the bits but the field(s).
   So, I will do the <STEP.1>.

4. Decide "How" fields to be shown

    Now we have already know the field(s) we care about, next
    step is to show the fields.

> > +	if (!(shown_bits ^ SHOW_FILE_NAME)) {

> Is the use of XOR operator significant here?
> 
> I.e. "if (shown_bits & SHOW_FILE_NAME)" would have been a much more
> natural way to guard "this is a block that shows the file name",
> than "the result MUST BE all bits off if we flip SHOW_FILE_NAME bit
> off".  If various SHOW_FOO bits are meant to be mutually exclusive,
> then "if ((shown_bits & SHOW_FILE_NAME) == SHOW_FILE_NAME)" would
> also make sense, but as I said upfront, it is unclear to me if
> shown_bits are meant to be a collection of "this bit means this
> field is shown (and it implies nothing else)", so I dunno.

    Not significant. Both work and It's all right for me. Your
    readability is better, and now I know how to handle this
    situation better.

    E.g, if we only want to show a "filename" field
    (with `--name-only`), we will use a way like
    "if ((shown_fields & FILE_NAME_FIELD) == FILE_NAME_FIELD)"
    to judge this situation.

    And if we want to show fields in a builtin way
    (as described in 'git-ls-tree.txt', default output format
    is compatible with what `--index-info --stdin` of
    'git update-index' expects.), we will use "DEFAULT_FIELDS"
    instead.


I am not sure if this solves the problem you are considering as I
may misunderstand, I can quickly finish this new patch and we can
look at it then。

Thanks.

