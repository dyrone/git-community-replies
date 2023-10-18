Subject: Re: [RFC PATCH 2/2] notes.c: fixed tip when target and append note are both empty

"Ævar Arnfjörð Bjarmason" <avarab@gmail.com> writes:

But playing with it further:
>
> 	diff --git a/builtin/notes.c b/builtin/notes.c
> 	index cc1e3aa2b6b..262bbffa375 100644
> 	--- a/builtin/notes.c
> 	+++ b/builtin/notes.c
> 	@@ -570,7 +570,6 @@ static int append_edit(int argc, const char **argv, const char *prefix)
> 	 	char *logmsg = NULL;
> 	 	const char * const *usage;
> 	 	struct note_data d = { 0, 0, NULL, STRBUF_INIT };
> 	-	struct note_data cp = { 0, 0, NULL, STRBUF_INIT };
> 	 	struct option options[] = {
> 	 		OPT_CALLBACK_F('m', "message", &d, N_("message"),
> 	 			N_("note contents as a string"), PARSE_OPT_NONEG,
> 	@@ -616,8 +615,6 @@ static int append_edit(int argc, const char **argv, const char *prefix)
>
> 	 	prepare_note_data(&object, &d, edit && note ? note : NULL);
>
> 	-	strbuf_addbuf(&cp.buf, &d.buf);
> 	-
> 	 	if (note && !edit) {
> 	 		/* Append buf to previous note contents */
> 	 		unsigned long size;
> 	@@ -638,21 +635,16 @@ static int append_edit(int argc, const char **argv, const char *prefix)
> 	 			BUG("combine_notes_overwrite failed");
> 	 		logmsg = xstrfmt("Notes added by 'git notes %s'", argv[0]);
> 	 		commit_notes(the_repository, t, logmsg);
> 	-	} else if (!cp.buf.len) {
> 	+	} else if (!d.buf.len) {
> 	 		fprintf(stderr,
> 	 			_("Both original and appended notes are empty in %s, do nothing\n"),
> 	 			oid_to_hex(&object));
> 	 	} else {
> 	-		fprintf(stderr, _("Removing note for object %s\n"),
> 	-			oid_to_hex(&object));
> 	-		remove_note(t, object.hash);
> 	-		logmsg = xstrfmt("Notes removed by 'git notes %s'", argv[0]);
> 	-		commit_notes(the_repository, t, logmsg);
> 	+		BUG("this is not reachable by any test now");
> 	 	}
>
> 	 	free(logmsg);
> 	 	free_note_data(&d);
> 	-	free_note_data(&cp);
> 	 	free_notes(t);
> 	 	return 0;
> 	 }

'd.buf' means the finally version of the note, the original and appending
combined result. So, if 'd.buf' is empty at last, there should be in these
cases:

    case 1: the original and appending are both empty, that just what I added in
    2/2 as the 'else if'

    case 2: the original is not empty, but after appending(could edit actually
    ), the final note 'd.buf' is empty, corresponding to the 'else' is the
    "remove" behavor.

    case 3: whether which is empty, the final note is not empty or 'allow_empty'
    is true, try to add note as the 'if' part.

So, I think my 'else' is needed here maybe, because if in "case 1", the output
will always be like we do the "remove", but actually not.

> This 2/2 makes that "else" test-unreachable, so whatever else we do here
> we should start by making sure that by adding the "else if" we still
> have test coverage for the "else".

em, sorry for that I didn't check the coverage, but I will make it covered after
I read the test by adding the test case.

Thanks for your suggestion as always.
