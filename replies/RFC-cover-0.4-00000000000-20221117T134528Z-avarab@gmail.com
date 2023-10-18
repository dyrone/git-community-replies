Subject: [RFC PATCH 0/4] ls-tree: pass state in struct, not globals

"Ævar Arnfjörð Bjarmason" <avarab@gmail.com> write:


> These are patches I've been carrying locally since April-ish, as a
> follow-up to the "ls-tree --format" topic.

Cool.

> Teng: This conflicts with your topic, but re my suggestion of
> submitting a separate clean-up series in [2] maybe you could look this
> over, see how they differ from yours, and see what would make sense to
> keep/incorporate for such a clean-up series?

Yes, I'd like to.

> E.g. 1/4 here is the opposite approach of your 3/6[3], but as 3/4
> eventually shows we don't need that struct for anything except that
> callback case.

Ok, I will check it out later.


Thanks.
