Subject: Re: [PATCH v1 1/2] api-trace2.txt: print config key-value pair

Ævar Arnfjörð Bjarmason <avarab@gmail.com> writes:

> I didn't notice this before, but this is an addition to a long section
> where the examples are ------- delimited, starting with "in this
> example.." usually.

A little puzzled. About "------- delimited", do you mean the "block" syntax?

> So this "print configs" seems like on odd continuation. Shouldn't this
> copy the template of "Thread Events::" above. I.e. something like (I
> have not tried to asciidoc render this):

I think "Events" in "Thread Events" means the thread start and end events,
maybe not a template here. So I think it might be better to keep this namingi
if I'm right, but I will use this candidate naming to show diff in the end.

I'm not good at naming so I'm glad to accept the suggestion about it.

>	Config (def param) Events::
>		We can optionally emit configuration events, see
>		`trace2.configParams` in linkgit:git-config[1] for how to enable
>		it.
>	+
>	< your example below would follow this>

I refer to the previous sections, it's like the template is :

<title>

        <brief one-line description>

<detailed multi-lines description>

So, how about this like:

diff --git a/Documentation/technical/api-trace2.txt b/Documentation/technical/api-trace2.txt
index 77a150b30e..38d0878d85 100644
--- a/Documentation/technical/api-trace2.txt
+++ b/Documentation/technical/api-trace2.txt
@@ -1207,6 +1207,37 @@ at offset 508.
 This example also shows that thread names are assigned in a racy manner
 as each thread starts and allocates TLS storage.

+Config (def param) Events::
+
+         Dump "interesting" config values to trace2 log.
++
+We can optionally emit configuration events, see
+`trace2.configparams` in linkgit:git-config[1] for how to enable
+it.
++
+----------------
+$ git config color.ui auto
+----------------
++
+Then, mark the config `color.ui` as "interesting" config with
+`GIT_TRACE2_CONFIG_PARAMS`:
++
+----------------
+$ export GIT_TRACE2_PERF_BRIEF=1
+$ export GIT_TRACE2_PERF=~/log.perf
+$ export GIT_TRACE2_CONFIG_PARAMS=color.ui
+$ git version
+...
+$ cat ~/log.perf
+d0 | main                     | version      |     |           |           |              | ...
+d0 | main                     | start        |     |  0.001642 |           |              | /usr/local/bin/git version
+d0 | main                     | cmd_name     |     |           |           |              | version (version)
+d0 | main                     | def_param    |     |           |           |              | color.ui:auto
+d0 | main                     | data         | r0  |  0.002100 |  0.002100 | fsync        | fsync/writeout-only:0
+d0 | main                     | data         | r0  |  0.002126 |  0.002126 | fsync        | fsync/hardware-flush:0
+d0 | main                     | exit         |     |  0.002142 |           |              | code:0
+d0 | main                     | atexit       |     |  0.002161 |           |              | code:0
+----------------
 == Future Work

 === Relationship to the Existing Trace Api (api-trace.txt)

Thanks.
