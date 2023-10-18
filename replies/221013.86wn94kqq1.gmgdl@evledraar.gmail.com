Subject: Re: [RFC PATCH 2/2] notes.c: fixed tip when target and append note are both empty


"Ævar Arnfjörð Bjarmason" <avarab@gmail.com> writes:

> Hrm, interesting that (at least my) gcc doesn't catch if we don't
> NULL-initialize this, but -fanalyzer does (usually it's not needed for
> such trivial cases0. Anyawy...

On my local env the warnings shows , show I change the line (initialize with
NULL to "logmsg").

But it seems like different as the last time I built... However now "suggest
braces around initialization of subobject" appears, is it normal or we should
repair this?

builtin/merge-file.c:29:23: warning: suggest braces around initialization of subobject [-Wmissing-braces]
        mmfile_t mmfs[3] = { 0 };
                             ^
                             {}
builtin/merge-file.c:31:20: warning: suggest braces around initialization of subobject [-Wmissing-braces]
        xmparam_t xmp = { 0 };
                          ^
                          {}
2 warnings generated.
builtin/notes.c:641:13: warning: variable 'logmsg' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
        } else if (!cp.buf.len) {
                   ^~~~~~~~~~~
builtin/notes.c:653:7: note: uninitialized use occurs here
        free(logmsg);
             ^~~~~~
builtin/notes.c:641:9: note: remove the 'if' if its condition is always false
        } else if (!cp.buf.len) {
               ^~~~~~~~~~~~~~~~~~
builtin/notes.c:570:14: note: initialize the variable 'logmsg' to silence this warning
        char *logmsg;
                    ^
                     = NULL
1 warning generated.
builtin/submodule--helper.c:1749:56: warning: suggest braces around initialization of subobject [-Wmissing-braces]
        struct list_objects_filter_options filter_options = { 0 };
                                                              ^
                                                              {}
builtin/submodule--helper.c:2623:56: warning: suggest braces around initialization of subobject [-Wmissing-braces]
        struct list_objects_filter_options filter_options = { 0 };
                                                              ^
                                                              {}
builtin/unpack-objects.c:388:26: warning: suggest braces around initialization of subobject [-Wmissing-braces]
        git_zstream zstream = { 0 };
                                ^
                                {}


My gcc version:
   Apple clang version 11.0.0 (clang-1100.0.33.17)
   Target: x86_64-apple-darwin19.6.0
   Thread model: posix


> >  	const char * const *usage;
> >  	struct note_data d = { 0, 0, NULL, STRBUF_INIT };
> > +	struct note_data cp = { 0, 0, NULL, STRBUF_INIT };
>
> This is probably better "fixed while at it" to set both to use "{ .buf =
> STRBUF_INIT }", rather than copying the pre-C99 pattern.


Thanks for figuring this out, will fix both.
