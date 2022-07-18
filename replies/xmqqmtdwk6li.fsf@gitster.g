Subject: Re: [PATCH v5 3/5] pack-bitmap.c: using error() instead of silently returning -1


On 28 Jun 2022 11:04:09 -0700, Junio C Hamano wrote:

> "stat" -> "fstat" perhaps?

Yes.

> Not a new problem, but before this hunk, we have
>
> 	fd = git_open(...);
> 	if (fd < 0)
> 		return -1;
>
> where it probably is legitimate to ignore ENOENT silently.  In
> practice, it may be OK to treat a file that exists but cannot be
> opened for whatever reason, but I do not think it would hurt to
> report such a rare anomaly with a warning, e.g.
>
> 	if (fd < 0) {
> 		if (errno != ENOENT)
> 			warning("'%s' cannot open '%s'",
> 				strerror(errno), bitmap_name);
> 		free(bitmap_name);
> 		return -1;
> 	}
>
> or something like that perhaps.

Yes.

It's more accurate here with your suggestion. At the same time I
found there actually exists many similar place like "ignore ENOENT
silently" in repo. And I think it's not worth to impove them right now
in this patch, if you want to do that it could in another pathset and
please tell me.

> > @@ -361,7 +361,7 @@ static int open_midx_bitmap_1(struct bitmap_index *bitmap_git,
> >  	bitmap_git->map_pos = 0;
> >  	bitmap_git->map = NULL;
> >  	bitmap_git->midx = NULL;
> > -	return -1;
> > +	return error(_("cannot open midx bitmap file"));
>
> This is not exactly "cannot open".  We opened the file, and found
> there was something we do not like in it.  If we failed to find midx
> lacks revindex chunk, we already would have given a warning, and the
> error is not just misleading but is redundant.  load_bitmap_header()
> also gives an error() on its own.
>
> I think this patch aims for a good end result, but needs more work.
> At least, checksum mismatch that goes to cleanup also needs to issue
> its own error() and then we can remove this "cannot open" at the end.

Yes, It's detailed here and I missed it, I will fix this in next
patch: return error() when checksum doesn't match and let "cleanup"
return "-1" but not an inaccurate error().

> "stat" -> "fstat"

Yes.

> > @@ -394,7 +394,7 @@ static int open_pack_bitmap_1(struct bitmap_index *bitmap_git, struct packed_git
> >
> >  	if (!is_pack_valid(packfile)) {
> >  		close(fd);
> > -		return -1;
> > +		return error(_("packfile is invalid"));
>
> Same "sometimes redundant" comment applies here, but not due to this
> part of the code but due to the helpers called from is_pack_valid().

Let me try to know about it, the "helpers" means the place where invoke
is_pack_valid() like here. In fact, in is_pack_valid() they already
return the errors in various scenarios, so it would be no need to
return another error.

> Namely, packfile.c::open_packed_git_1() is mostly chatty, but is
> silent upon "unable to open" and "unable to fstat" (which I think is
> safe to make chatty as well---we do not want to special case ENOENT
> in open_packed_git(), so "cannot open because it is not there" is an
> error).

"chatty" means the code that regularly gives information about its
internal operations. Did I understand it right because I'm actually
firstly know this description.

"cannot open because it is not there" is an error, but I think it will
also could be a BUG, actually I'm not very sure for clarify the
difference bwtween the use of the two, but I will look into it to dig
something out.

> And then, this "invalid" will become redundant and fuzzier message
> than what is_pack_valid() would have already given, so you can leave
> it to silently return -1 here.

Clear now.

Thanks.
