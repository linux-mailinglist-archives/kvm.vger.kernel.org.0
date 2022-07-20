Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEAEB57AB1B
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 02:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238691AbiGTAqA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 20:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232281AbiGTAp6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 20:45:58 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C2411A01
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 17:45:57 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id z13so4380806wro.13
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 17:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SWZJK2a5FJh+xqduxqkQ1AlPGmtOJw7B0YsiYXOcGsI=;
        b=cOEZSVjegdW48/U7AZLjKSVgGWSSjYZnjyDVDRodY8XwtrM2QXLzcrOuPuRmPyYNo/
         F3KRB5LuDcCZrCr+G+Ixeo7CcUcHaoROjCDRDt+HbjiRiJjgg0eAkxaU39GT0vFbv4Uz
         rkqaHboeVKcnylk0sUDOVF3yRS9YB1vItukhkJAFLhEwvuCoav7jVhqF6IH00wDfnYrF
         gz56e1UYTawqsAuICghNM/CtfYqWoVl7LW+t8JCFOU3arQHLUUzWeCwOU4BYJOvzqxrI
         nV8QfIajB5GfSLhQPWdaISdDi8pRoYdKYy5vgGsKPZ+ix3+hoiP5mJykf1aZVNyIVM9F
         L0Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SWZJK2a5FJh+xqduxqkQ1AlPGmtOJw7B0YsiYXOcGsI=;
        b=bHBT8pvBtSq1l2nlJNTMw4YafDRQPmOLp7LWvHVE9EJJny3vlXF15q35YIpK6hslb1
         bzrfuqoctwKm6OCyNSZ+mcqW2t+1y0gySVCmlyEyQVivcMgRZnd5NSO1UFtqoXWjvsBA
         ggygOP1B1oItSE9/IowfMyu7ksvey874qEEcVn3a1FfSLRw47L+SPG9lqK2Di1v1yyO3
         7AiGmfQsw0RkYpBEVl5fOWVemPfk8SH0xSlDWzy6Fbvocb7BICLQR58ZVGhxVbdd/Ymk
         T2ETaEauH9NH4n4LhaS1XWFdIcK9j+1pPO9PHlA8aQpLBWEW0GxorZr76eYWupLyaCDl
         X4Cg==
X-Gm-Message-State: AJIora/qIjncw/pgsKMJQtLAudg/reGQkZdFI4qi/DE1F7WpQb+nRJr7
        SPvnNgDeuul7NiFGqN+IXJtMdodrWigNzLixANBmdg==
X-Google-Smtp-Source: AGRyM1siLdcEH5H28bgj9+GPN5eKcSWM+TGOD/Dqvbiymn7mcnaRTyzL/DiTnB9FVhk/GJHB73BOgO2Qy2IISVtTzSQ=
X-Received: by 2002:a05:6000:1a8e:b0:21d:a7a8:54f4 with SMTP id
 f14-20020a0560001a8e00b0021da7a854f4mr29360494wry.654.1658277955696; Tue, 19
 Jul 2022 17:45:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220711093218.10967-1-adrian.hunter@intel.com> <20220711093218.10967-21-adrian.hunter@intel.com>
In-Reply-To: <20220711093218.10967-21-adrian.hunter@intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 19 Jul 2022 17:45:43 -0700
Message-ID: <CAP-5=fXya0idvwme2KTzVkFWkANx-n-r03gV-p+JK3KvRYerag@mail.gmail.com>
Subject: Re: [PATCH 20/35] perf tools: Remove also guest kcore_dir with host kcore_dir
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 11, 2022 at 2:33 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
>
> Copies of /proc/kallsyms, /proc/modules and an extract of /proc/kcore can
> be stored in the perf.data output directory under the subdirectory named
> kcore_dir. Guest machines will have their files also under subdirectories
> beginning kcore_dir__ followed by the machine pid. Remove these also when
> removing kcore_dir.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Acked-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  tools/perf/util/util.c | 37 +++++++++++++++++++++++++++++++++++--
>  1 file changed, 35 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
> index eeb83c80f458..9b02edf9311d 100644
> --- a/tools/perf/util/util.c
> +++ b/tools/perf/util/util.c
> @@ -200,7 +200,7 @@ static int rm_rf_depth_pat(const char *path, int depth, const char **pat)
>         return rmdir(path);
>  }
>
> -static int rm_rf_kcore_dir(const char *path)
> +static int rm_rf_a_kcore_dir(const char *path, const char *name)
>  {
>         char kcore_dir_path[PATH_MAX];
>         const char *pat[] = {
> @@ -210,11 +210,44 @@ static int rm_rf_kcore_dir(const char *path)
>                 NULL,
>         };
>
> -       snprintf(kcore_dir_path, sizeof(kcore_dir_path), "%s/kcore_dir", path);
> +       snprintf(kcore_dir_path, sizeof(kcore_dir_path), "%s/%s", path, name);
>
>         return rm_rf_depth_pat(kcore_dir_path, 0, pat);
>  }
>
> +static bool kcore_dir_filter(const char *name __maybe_unused, struct dirent *d)
> +{
> +       const char *pat[] = {
> +               "kcore_dir",
> +               "kcore_dir__[1-9]*",
> +               NULL,
> +       };
> +
> +       return match_pat(d->d_name, pat);
> +}
> +
> +static int rm_rf_kcore_dir(const char *path)
> +{
> +       struct strlist *kcore_dirs;
> +       struct str_node *nd;
> +       int ret;
> +
> +       kcore_dirs = lsdir(path, kcore_dir_filter);
> +
> +       if (!kcore_dirs)
> +               return 0;
> +
> +       strlist__for_each_entry(nd, kcore_dirs) {
> +               ret = rm_rf_a_kcore_dir(path, nd->s);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       strlist__delete(kcore_dirs);
> +
> +       return 0;
> +}
> +
>  int rm_rf_perf_data(const char *path)
>  {
>         const char *pat[] = {
> --
> 2.25.1
>
