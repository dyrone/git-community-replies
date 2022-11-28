Subject: [PATCH v3 0/5] notes.c: introduce "--no-blank-line" option

> Teng Long (5):
>   notes.c: cleanup 'strbuf_grow' call in 'append_edit'
>   notes.c: cleanup for "designated init" and "char ptr init"
>   notes.c: drop unreachable code in 'append_edit()'
>   notes.c: provide tips when target and append note are both empty
>   notes.c: introduce "--no-blank-line" option

I'm not sure if this patch series should continue, and if there are no
updated comments it will be temporarily suspended.

Thanks for the reviews on the past patches.
