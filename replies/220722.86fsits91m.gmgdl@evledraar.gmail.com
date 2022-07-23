Subject: Re: [PATCH v1 1/2] api-trace2.txt: print config key-value pair

Ævar Arnfjörð Bjarmason <avarab@gmail.com> writes:

> I didn't notice this before, but this is an addition to a long section
> where the examples are ------- delimited, starting with "in this
> example.." usually.

A little puzzled. About "------- delimited", do you mean the "block" syntax?

> So this "print configs" seems like on odd continuation. Shouldn't this
> copy the template of "Thread Events::" above. I.e. something like (I
> have not tried to asciidoc render this):
