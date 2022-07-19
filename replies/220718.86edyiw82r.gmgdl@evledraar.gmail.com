Subject: Re: [PATCH v7 0/7] trace2: dump scope when print "interesting" config

> Yeah likewise, it even applies directly on master. But I can live with
> it :)

Sorry, may I ask what's the recommanded way to deal this, alway use
tag or master on update?

> One minor nit is that something like this (which needs to be fleshened
> up) should be fixed up into 7/7 (and maybe we want to keep the "..."?):
>
> diff --git a/Documentation/technical/api-trace2.txt b/Documentation/technical/api-trace2.txt
> index 49bb1ca1924..ce544982a37 100644
> --- a/Documentation/technical/api-trace2.txt
> +++ b/Documentation/technical/api-trace2.txt
> @@ -716,7 +716,7 @@ The "exec_id" field is a command-unique id and is only useful if the
>  ------------
>  {
>  	"event":"def_param",
> -	...
> +	"scope": ...
>  	"param":"core.abbrev",
>  	"value":"7"
>  }

I do a little check, the json format in this scenario is like :

{
  "event": "def_param",
  "sid": "20220719T075535.279369Z-H1b0a19dc-P000093db",
  "thread": "main",
  "time": "2022-07-19T07:55:35.280720Z",
  "file": "git.c",
  "line": 461,
  "scope": "global",
  "param": "color.ui",
  "value": "always"
}

So, I think this is ok maybe:

diff --git a/Documentation/technical/api-trace2.txt b/Documentation/technical/api-trace2.txt
index bb13ca3db8..d66da52686 100644
--- a/Documentation/technical/api-trace2.txt
+++ b/Documentation/technical/api-trace2.txt
@@ -717,6 +717,7 @@ The "exec_id" field is a command-unique id and is only useful if the
 {
        "event":"def_param",
        ...
+       "scope":...
        "param":"core.abbrev",
        "value":"7"
 }

> And that the addition to api-trace2.txt seems to partially be something
> that should just link to Documentation/config/trace2.txt, i.e. it's
> generally documenting an existing facility.

Do you mean the modification about `trace2.configParams` and you suggest
to make a link to Documentation/config/trace2.txt(actually as git-config[1])
in /Documentation/technical/api-trace2.txt?

> I think it would be great in any case to have that 7/7 split into what
> we do now & docs for that, and then the minor addition of "scope".

Let me try to understand this, it's better to split [7/7] into two commits.

First commit is to add docs in /Documentation/technical/api-trace2.txt to let
reader to find the print-config ability, by the way link the doc about the
GIT_TRACE2_CONFIG_PARAM and trace2.configparami in git-config[1].

Like:

commit 2db47572d4462e3788a92fd355b97df13b9bcc39
Author: Teng Long <dyroneteng@gmail.com>
Date:   Tue Jul 19 17:30:35 2022 +0800

    api-trace2.txt: add docs to print config

    It's supported to print "interesting" config value to tr2 log by
    setting the "GIT_TRACE2_CONFIG_PARAMS" environment variable and
    the "trace2.configparam" config, let's add the related docs.

    Signed-off-by: Teng Long <dyroneteng@gmail.com>

diff --git a/Documentation/technical/api-trace2.txt b/Documentation/technical/api-trace2.txt
index bb13ca3db8..4e411f3306 100644
--- a/Documentation/technical/api-trace2.txt
+++ b/Documentation/technical/api-trace2.txt
@@ -1207,6 +1207,45 @@ at offset 508.
 This example also shows that thread names are assigned in a racy manner
 as each thread starts and allocates TLS storage.

+Print Configs::
+
+         Dump "interesting" config values to trace2 log.
++
+The environment variable `GIT_TRACE2_CONFIG_PARAMS` and configuration
+`trace2.configparams` can be used to output config values which you care
+about(see linkgit:git-config[1). For example, assume that we want to
+config different `color.ui` values in multiple scopes, such as:
++
+----------------
+$ git config --system color.ui never
+$ git config --global color.ui always
+$ git config --local color.ui auto
+$ git config --list --show-scope | grep 'color.ui'
+system  color.ui=never
+global  color.ui=always
+local   color.ui=auto
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
+d0 | main                     | start        |     |  0.000260 |           |              | /opt/git/master/bin/git version
+d0 | main                     | cmd_ancestry |     |           |           |              | ancestry:[bash sshd sshd sshd systemd]
+d0 | main                     | cmd_name     |     |           |           |              | version (version)
+d0 | main                     | def_param    |     |           |           |              | color.ui:never
+d0 | main                     | def_param    |     |           |           |              | color.ui:always
+d0 | main                     | def_param    |     |           |           |              | color.ui:auto
+d0 | main                     | exit         |     |  0.000470 |           |              | code:0
+d0 | main                     | atexit       |     |  0.000477 |           |              | code:0
+----------------
 == Future Work

Second is actually what we do in [7/7], modify to support print scope names
and update the docs which based on what we just add in the first commit

Like:


commit 615ab4864fce6b8042778aa78799ac2656785710 (HEAD -> tl/bitmap-append-trace2-outputs)
Author: Teng Long <dyroneteng@gmail.com>
Date:   Thu Jul 7 21:48:32 2022 +0800

    tr2: dump names if config exist in multiple scopes

    When we specify GIT_TRACE2_CONFIG_PARAMS or trace2.configparams,
    trace2 will prints "interesting" config values to log. Sometimes,
    when a config set in multiple scope files, the following output
    looks like (the irrelevant fields are omitted here as "..."):

    ...| def_param    |  ...  | core.multipackindex:false
    ...| def_param    |  ...  | core.multipackindex:false
    ...| def_param    |  ...  | core.multipackindex:false

    As the log shows, even each config in different scope is dumped, but
    we don't know which scope it comes from. Therefore, it's better to
    add the scope names as well to make them be more recognizable. For
    example, when execute:

        $ GIT_TRACE2_PERF=1 \
        > GIT_TRACE2_CONFIG_PARAMS=core.multipackIndex \
        > git rev-list --test-bitmap HEAD"

    The following is the ouput (the irrelevant fields are omitted here
    as "..."):

    Format normal:
    ... git.c:461 ... def_param scope:system core.multipackindex=false
    ... git.c:461 ... def_param scope:global core.multipackindex=false
    ... git.c:461 ... def_param scope:local core.multipackindex=false

    Format perf:

    ... | def_param    | ... | scope:system | core.multipackindex:false
    ... | def_param    | ... | scope:global | core.multipackindex:false
    ... | def_param    | ... | scope:local  | core.multipackindex:false

    Format event:

    {"event":"def_param", ... ,"scope":"system","param":"core.multipackindex","value":"false"}
    {"event":"def_param", ... ,"scope":"global","param":"core.multipackindex","value":"false"}
    {"event":"def_param", ... ,"scope":"local","param":"core.multipackindex","value":"false"}

    Signed-off-by: Teng Long <dyroneteng@gmail.com>

diff --git a/Documentation/technical/api-trace2.txt b/Documentation/technical/api-trace2.txt
index 4e411f3306..50f1e0c259 100644
--- a/Documentation/technical/api-trace2.txt
+++ b/Documentation/technical/api-trace2.txt
@@ -717,6 +717,7 @@ The "exec_id" field is a command-unique id and is only useful if the
 {
        "event":"def_param",
        ...
+       "scope":...
        "param":"core.abbrev",
        "value":"7"
 }
@@ -1240,9 +1241,9 @@ d0 | main                     | version      |     |           |           |
 d0 | main                     | start        |     |  0.000260 |           |              | /opt/git/master/bin/git version
 d0 | main                     | cmd_ancestry |     |           |           |              | ancestry:[bash sshd sshd sshd systemd]
 d0 | main                     | cmd_name     |     |           |           |              | version (version)
-d0 | main                     | def_param    |     |           |           |              | color.ui:never
-d0 | main                     | def_param    |     |           |           |              | color.ui:always
-d0 | main                     | def_param    |     |           |           |              | color.ui:auto
+d0 | main                     | def_param    |     |           |           | scope:system | color.ui:never
+d0 | main                     | def_param    |     |           |           | scope:global | color.ui:always
+d0 | main                     | def_param    |     |           |           | scope:local  | color.ui:auto
 d0 | main                     | exit         |     |  0.000470 |           |              | code:0
 d0 | main                     | atexit       |     |  0.000477 |           |              | code:0
 ----------------
diff --git a/trace2/tr2_tgt_event.c b/trace2/tr2_tgt_event.c
index c5c8cfbbaa..37a3163be1 100644
--- a/trace2/tr2_tgt_event.c
+++ b/trace2/tr2_tgt_event.c
@@ -479,9 +479,12 @@ static void fn_param_fl(const char *file, int line, const char *param,
 {
        const char *event_name = "def_param";
        struct json_writer jw = JSON_WRITER_INIT;
+       enum config_scope scope = current_config_scope();
+       const char *scope_name = config_scope_name(scope);

        jw_object_begin(&jw, 0);
        event_fmt_prepare(event_name, file, line, NULL, &jw);
+       jw_object_string(&jw, "scope", scope_name);
        jw_object_string(&jw, "param", param);
        jw_object_string(&jw, "value", value);
        jw_end(&jw);
diff --git a/trace2/tr2_tgt_normal.c b/trace2/tr2_tgt_normal.c
index c42fbade7f..69f8033077 100644
--- a/trace2/tr2_tgt_normal.c
+++ b/trace2/tr2_tgt_normal.c
@@ -298,8 +298,11 @@ static void fn_param_fl(const char *file, int line, const char *param,
                        const char *value)
 {
        struct strbuf buf_payload = STRBUF_INIT;
+       enum config_scope scope = current_config_scope();
+       const char *scope_name = config_scope_name(scope);

-       strbuf_addf(&buf_payload, "def_param %s=%s", param, value);
+       strbuf_addf(&buf_payload, "def_param scope:%s %s=%s", scope_name, param,
+                   value);
        normal_io_write_fl(file, line, &buf_payload);
        strbuf_release(&buf_payload);
 }
diff --git a/trace2/tr2_tgt_perf.c b/trace2/tr2_tgt_perf.c
index a1eff8bea3..8cb792488c 100644
--- a/trace2/tr2_tgt_perf.c
+++ b/trace2/tr2_tgt_perf.c
@@ -441,12 +441,17 @@ static void fn_param_fl(const char *file, int line, const char *param,
 {
        const char *event_name = "def_param";
        struct strbuf buf_payload = STRBUF_INIT;
+       struct strbuf scope_payload = STRBUF_INIT;
+       enum config_scope scope = current_config_scope();
+       const char *scope_name = config_scope_name(scope);

        strbuf_addf(&buf_payload, "%s:%s", param, value);
+       strbuf_addf(&scope_payload, "%s:%s", "scope", scope_name);

-       perf_io_write_fl(file, line, event_name, NULL, NULL, NULL, NULL,
-                        &buf_payload);
+       perf_io_write_fl(file, line, event_name, NULL, NULL, NULL,
+                        scope_payload.buf, &buf_payload);
        strbuf_release(&buf_payload);
+       strbuf_release(&scope_payload);
 }

 static void fn_repo_fl(const char *file, int line,


Am I understand accurately?
Thanks.
