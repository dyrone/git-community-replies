Subject: [PATCH 1/4] notes doc: split up run-on sentences

> "Martin Ågren" <martin.agren@gmail.com> writes:
> 
> When commit c4e2aa7d45 (notes.c: introduce "--[no-]stripspace" option,
> 2023-05-27) mentioned the new `--no-stripspace` in the documentation for
> `-m` and `-F`, it created run-on sentences. It also used slightly
> different language in the two sections for no apparent reason. Split the
> sentences in two to improve readability, and while touching the two
> sites, make them more similar.
> 
> Signed-off-by: Martin Ågren <martin.agren@gmail.com>
> ---
>  Documentation/git-notes.txt | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/git-notes.txt b/Documentation/git-notes.txt
> index bc1bfa3791..9043274ce8 100644
> --- a/Documentation/git-notes.txt
> +++ b/Documentation/git-notes.txt
> @@ -141,17 +141,16 @@ OPTIONS
>  	If multiple `-m` options are given, their values
>  	are concatenated as separate paragraphs.
>  	Lines starting with `#` and empty lines other than a
> -	single line between paragraphs will be stripped out,
> -	if you wish to keep them verbatim, use `--no-stripspace`.
> +	single line between paragraphs will be stripped out.
> +	If you wish to keep them verbatim, use `--no-stripspace`.
>  
>  -F <file>::
>  --file=<file>::
>  	Take the note message from the given file.  Use '-' to
>  	read the note message from the standard input.
>  	Lines starting with `#` and empty lines other than a
> -	single line between paragraphs will be stripped out,
> -	if you wish to keep them verbatim, use with
> -	`--no-stripspace` option.
> +	single line between paragraphs will be stripped out.
> +	If you wish to keep them verbatim, use `--no-stripspace`.
>  

LGTM.

Thanks for catching and fixing these docs.

>  -C <object>::
>  --reuse-message=<object>::
> -- 
> 2.42.0.rc2.215.g538df5cf27

Thanks
