Subject: Re: What's cooking in git.git (Dec 2021, #05; Thu, 23)

On Sun, 26 Dec 2021 18:15:53 +0100, Ævar Arnfjörð Bjarmason wrote:

> Yes there's the test problem I mentioned in [1], but in addition to that
> your current set of patches have around a ~10% performance regression,
> as noted in [2]. My RFC series[2] side-steps that by leaving the current
> code in-place, and only introducing a new optional --format path for new
> output formats.
> 
> I really don't mind if you go for "WAY-1" first over my RFC --format
> "WAY-2", but I do think any such change should be prominently
> noting/selling that this new feature is worth the performance
> regression, or finding some alternate "WAY-1+" to avoid it.

Yes, I see what you mean, and what I'm trying to say is that we see eye to eye on
this.

As I mentioned above, the performace regression is compelling and I looked
into it on the night before and already found out why the regression was
produced (But I can not send patch over gmail at home because of the network,
maybe i'd like to try with GitGitGadget next time). I will not omit this problem
and go on working at it today, similarly, wouldn't reply this thread otherwise
the new patchset is reach the standard (As I see the "cooking" is let others know
what's new and the corresponding progress currently and discussions should still
be made under the "patch").

Thanks.
