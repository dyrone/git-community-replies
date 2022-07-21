Subject: Re: [PATCH v7 0/7] trace2: dump scope when print "interesting" config

Ævar Arnfjörð Bjarmason <avarab@gmail.com> writes:

> We generally submit patches on a single "topic", what a "topic" is is
> often fuzzy, and sometimes a topic that's mostly trying to do X will fix
> or change some unrelated Y "while at it".
>
> But patch or patches at the end of a series don't depend on anything
> that comes before them, and could be "cherry-pick"'d directly on top of
> "master" that's generally a sign that you should be submitting two sets
> of patches, not one.
>
> Per
> https://lore.kernel.org/git/2016ef2e342c2ec6517afa8ec3e57035021fb965.1650547400.git.dyroneteng@gmail.com/
> the "let's log config" is just something you happened to run into on
> this topic, but it might have just as well been some other command.
>
> So I think it's better to split it up into its own topic.

Make sense.

> Yes, that sound good, although I'd make that "scope" line be:
>
> 	"scope": "global" | "worktree" | <add more things to the list here>
>
> Or just say:
>
> 	"scope": <a string that 'git config --show-scope' would return>,
>
> Which covers all the possibilities, without hardcoding them there.

I think I'd like to prefer the second way, thanks for the input.

> I mean that part of what you're adding is about this new "scope"
> feature, but another part just seems to be explaining how the
> trace2.configParams works in general.
>
> For the "works in general" let's either link to git-config(1), or if
> that explanation is lacking improve it & link to it.

Yes, I think the current explanation is OK for me in git-config[1], so
I add the link as in previous reply (Search: 2db47572d4462e3788a92fd355b97df13b9bcc39) :

+`trace2.configparams` can be used to output config values which you care
+about(see linkgit:git-config[1).

> Yes, something like that, although it's a bit odd to discuss "scope"
> here and not have the trace show it yet, but that's fixed below.:

Yes, because I want the result to be more obvious, if a config only in single
scope maybe it's a litter harder to remember "Wo, what looks like if config is
in multiple scopes?(although it's intentional)"

> Yes, exactly! That makes it much clearer what the functional change was
> about, i.e. we can see what parts of the trace are now different (the
> scope is added to the trace).

Yes.

Thanks.
