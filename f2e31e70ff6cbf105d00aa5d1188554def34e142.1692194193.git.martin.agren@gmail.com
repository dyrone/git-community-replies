Subject: [PATCH 2/4] notes doc: tidy up `--no-stripspace` paragraph

"Martin Ågren" <martin.agren@gmail.com> writes:

> Where we document the `--no-stripspace` option, remove a superfluous
> "For" to fix the grammar. Mark option names and command names using
> `backticks` to set them in monospace.



> Signed-off-by: Martin Ågren <martin.agren@gmail.com>
> ---
>  Documentation/git-notes.txt | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/git-notes.txt b/Documentation/git-notes.txt
> index 9043274ce8..f8310e56a8 100644
> --- a/Documentation/git-notes.txt
> +++ b/Documentation/git-notes.txt
> @@ -179,9 +179,9 @@ OPTIONS
>  --[no-]stripspace::
>  	Strip leading and trailing whitespace from the note message.
>  	Also strip out empty lines other than a single line between
> -	paragraphs. For lines starting with `#` will be stripped out
> -	in non-editor cases like "-m", "-F" and "-C", but not in
> -	editor case like "git notes edit", "-c", etc.
> +	paragraphs. Lines starting with `#` will be stripped out
> +	in non-editor cases like `-m`, `-F` and `-C`, but not in
> +	editor case like `git notes edit`, `-c`, etc.

Oops! I didn't notice to distingush ` and ", there are some places
still using ", but here we think to use ` is the apppropriate
way to surround option and command, etc. in docs, right?

>  --ref <ref>::
>  	Manipulate the notes tree in <ref>.  This overrides
> -- 
> 2.42.0.rc2.215.g538df5cf27

Thanks for fixing this.
