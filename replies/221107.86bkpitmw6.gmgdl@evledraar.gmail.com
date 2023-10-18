Subject: Re: [PATCH v2 2/3] notes.c: fixed tip when target and append note are both empty

"Ævar Arnfjörð Bjarmason" <avarab@gmail.com> writes:

>  I was still on my initial read-through, and was assuming that it was a
> prep change for the 3/3 adding a new field, before I saw the 3/3...

Yes, you are right, that previous patch add a "copy" of "d", but now it's
unnecessary, so I think make a pre-cleanup commit which includes the "char
*logmsg = NULL" and the "designated init" of "struct note_data d" looks
nice.

Thanks.
