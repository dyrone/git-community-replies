Subject: Re: [PATCH v6 3/3] notes.c: introduce '--separator=<paragraph-break>' option

Junio C Hamano <gitster@pobox.com> writes:

> The two callers of this function prepares the string_list, and have
> this function consume it by concatenating its contents to d->buf.
> After calling this function, neither of them talks about messages,
> which means we are leaking the strings kept in the string_list.
>
> I could eject the topic from today's integration run (because the
> topic is not ready to be merged to 'next' as-is; "-C/-c" codepaths
> need to be adjusted, at least), but as I took a look already, I'll
> queue this fix-up on top of the topic for now.  Feel free to squash
> it in (or address the leaks in your own way) when sending in an
> update.
>
> Thanks.
>
>  builtin/notes.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git c/builtin/notes.c w/builtin/notes.c
> index 97c18fc02f..cd7af76e2f 100644
> --- c/builtin/notes.c
> +++ w/builtin/notes.c
> @@ -220,7 +220,8 @@ static void insert_separator(struct strbuf *message, size_t pos)
>  		strbuf_insertf(message, pos, "%s%s", separator, "\n");
>  }
>
> -static void parse_messages(struct string_list *messages, struct note_data *d)
> +/* Consume messages and append them into d->buf */
> +static void concat_messages(struct string_list *messages, struct note_data *d)
>  {
>  	size_t i;
>  	for (i = 0; i < messages->nr; i++) {
> @@ -231,6 +232,7 @@ static void parse_messages(struct string_list *messages, struct note_data *d)
>  		strbuf_stripspace(&d->buf, 0);
>  		d->given = 1;
>  	}
> +	string_list_clear(messages, 0);
>  }
>
>  static int parse_msg_arg(const struct option *opt, const char *arg, int unset)
> @@ -451,7 +453,7 @@ static int add(int argc, const char **argv, const char *prefix)
>  		usage_with_options(git_notes_add_usage, options);
>  	}
>
> -	parse_messages(&messages, &d);
> +	concat_messages(&messages, &d);
>  	object_ref = argc > 1 ? argv[1] : "HEAD";
>
>  	if (get_oid(object_ref, &object))
> @@ -622,7 +624,7 @@ static int append_edit(int argc, const char **argv, const char *prefix)
>  		usage_with_options(usage, options);
>  	}
>
> -	parse_messages(&messages, &d);
> +	concat_messages(&messages, &d);
>
>  	if (d.given && edit)
>  		fprintf(stderr, _("The -m/-F/-c/-C options have been deprecated "

Thanks, will apply in next patch.
