Subject: Re: [PATCH v9 4/6] notes.c: introduce '--separator=<paragraph-break>' option

>diff --git a/builtin/notes.c b/builtin/notes.c
>index 8905298b..6eede305 100644
>--- a/builtin/notes.c
>+++ b/builtin/notes.c
>@@ -28,7 +28,7 @@
> #include "worktree.h"
> #include "write-or-die.h"
> 
>-static const char *separator = "\n";
>+static char *separator = "\n";
> static const char * const git_notes_usage[] = {
>        N_("git notes [--ref <notes-ref>] [list [<object>]]"),
>        N_("git notes [--ref <notes-ref>] add [-f] [--allow-empty] [--separator=<paragraph-break>] [-m <msg> | -F <file> | (-c | -C) <object>] [<object>]"),
>@@ -248,8 +248,8 @@ static void append_separator(struct strbuf *message)
> static void concat_messages(struct note_data *d)
> {
>        struct strbuf msg = STRBUF_INIT;
>-       size_t i;
> 
>+       size_t i;
>        for (i = 0; i < d->msg_nr ; i++) {
>                if (d->buf.len)
>                        append_separator(&d->buf);

Sorry, the direction is reversed wrongly.

diff --git a/builtin/notes.c b/builtin/notes.c
index 6eede305..8905298b 100644
--- a/builtin/notes.c
+++ b/builtin/notes.c
@@ -28,7 +28,7 @@
 #include "worktree.h"
 #include "write-or-die.h"
 
-static char *separator = "\n";
+static const char *separator = "\n";
 static const char * const git_notes_usage[] = {
        N_("git notes [--ref <notes-ref>] [list [<object>]]"),
        N_("git notes [--ref <notes-ref>] add [-f] [--allow-empty] [--separator=<paragraph-break>] [-m <msg> | -F <file> | (-c | -C) <object>] [<object>]"),
@@ -248,8 +248,8 @@ static void append_separator(struct strbuf *message)
 static void concat_messages(struct note_data *d)
 {
        struct strbuf msg = STRBUF_INIT;
-
        size_t i;
+
        for (i = 0; i < d->msg_nr ; i++) {
                if (d->buf.len)
                        append_separator(&d->buf);
