Subject: [PATCH v6 0/3] notes.c: introduce "--separator" option

I'm working on the new patchset recently, and I found there may be a
weired test code writting like this in t3301:


test_expect_success 'refusing to edit notes in refs/remotes/' '
	test_must_fail env MSG=1 GIT_NOTES_REF=refs/heads/bogus git notes edit
'

should it be like:

test_expect_success 'refusing to edit notes in refs/remotes/' '
	test_must_fail env MSG=1 GIT_NOTES_REF=refs/remotes/bogus git notes edit
'

Thanks.
