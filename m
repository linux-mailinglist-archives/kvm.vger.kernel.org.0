Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D237B57A488
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 19:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237802AbiGSREZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 13:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237773AbiGSREY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 13:04:24 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4AD85887A
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 10:04:23 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id r2so21529112wrs.3
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 10:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LfIKIGtwC4Qu36ftUVDNw1P0iKerbqrdfHB7A+1kcMU=;
        b=X/WYD0qKq/hTS58sDse/MpagQekgfYeweLKLFRfdByU2Jje+tgzBK7ac9+6JL/YSd4
         zjmUZOl9PCBhD+0bUfGl34TTFljLwtwddXHuk+WVxU1B6p7e84lfHRpDYLRnI1pulHOD
         hX7tIRV6Ux5eXEgLyAR2BIBsP/ROziJPctR3bPOaU9x3LLEz/xVN9NAtZzF5Yc5XSfLM
         wcpaazXxtkbuH8hOedOLHYpflLLSJuj5J6VdeTp+UuAp21xRxT4fLf0OwCJg86C5ib3B
         c+foxoaxP1N9sZYcAnaY5JANi/dgCb1e/BSEM4R9jPfYcDethQhC6NZS8ne/SQYM+0ba
         klkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LfIKIGtwC4Qu36ftUVDNw1P0iKerbqrdfHB7A+1kcMU=;
        b=6tOc61PUoAvf6BNhRfvsg8WqwRYkOg38Ls4sErmxXU4PkHj0KGe07Ji/kxwRKZmy5O
         ncOKOAUZQfgFM7e3tz5u8zEUKzy5Qs3KRRaQHp12tmjvuV3sT9jUcUBGBYMNslXG/e8e
         fbpUo/IqZhvvz5d7L2na8tSHzf4MVnl6CxFTttb+g6wFW9jUyMMb/sFmlhZ3zbARpUPo
         Pvu6YKiqsILSNcSHnVpm/oCo2L8+f85K03Egbk+oNLaAYvt9JLCxPLkS74ULU2falyYO
         MWGEFRyg51c5sCuaM57bbJuVlRQgRZYU3li1f7saGsdogRKLYUrgqi0HDAKndmXeoSy1
         xiYQ==
X-Gm-Message-State: AJIora9m+n0KpoB9IoImjZaDhsIp/1sw3nP6SC6ZuuaPNPVutXrsuL86
        5/N5zuVXH82jwbhWD0CawqxceMSWbJOFHVzxSTykew==
X-Google-Smtp-Source: AGRyM1vbJn4azVD7zJMxVxsXXb7CcHeqGF+eTvEeZoLxTwVQuAOXddSFecihVwNYJEZKnVI47G9A26ePq/7enOzVWuY=
X-Received: by 2002:a05:6000:8e:b0:21d:7e97:67ed with SMTP id
 m14-20020a056000008e00b0021d7e9767edmr26676566wrx.343.1658250262153; Tue, 19
 Jul 2022 10:04:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220711093218.10967-1-adrian.hunter@intel.com> <20220711093218.10967-5-adrian.hunter@intel.com>
In-Reply-To: <20220711093218.10967-5-adrian.hunter@intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 19 Jul 2022 10:04:09 -0700
Message-ID: <CAP-5=fVbfiVJXAHcZV+3bqc-bV3XfbpxKVVtZtH+jJauzh9NQQ@mail.gmail.com>
Subject: Re: [PATCH 04/35] perf tools: Export perf_event__process_finished_round()
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

On Mon, Jul 11, 2022 at 2:32 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
>
> Export perf_event__process_finished_round() so it can be used elsewhere.
>
> This is needed in perf inject to obey finished-round ordering.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/util/session.c | 12 ++++--------
>  tools/perf/util/session.h |  4 ++++
>  2 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 37f833c3c81b..4c9513bc6d89 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -374,10 +374,6 @@ static int process_finished_round_stub(struct perf_tool *tool __maybe_unused,
>         return 0;
>  }
>
> -static int process_finished_round(struct perf_tool *tool,
> -                                 union perf_event *event,
> -                                 struct ordered_events *oe);
> -
>  static int skipn(int fd, off_t n)
>  {
>         char buf[4096];
> @@ -534,7 +530,7 @@ void perf_tool__fill_defaults(struct perf_tool *tool)
>                 tool->build_id = process_event_op2_stub;
>         if (tool->finished_round == NULL) {
>                 if (tool->ordered_events)
> -                       tool->finished_round = process_finished_round;
> +                       tool->finished_round = perf_event__process_finished_round;
>                 else
>                         tool->finished_round = process_finished_round_stub;
>         }
> @@ -1069,9 +1065,9 @@ static perf_event__swap_op perf_event__swap_ops[] = {
>   *      Flush every events below timestamp 7
>   *      etc...
>   */
> -static int process_finished_round(struct perf_tool *tool __maybe_unused,
> -                                 union perf_event *event __maybe_unused,
> -                                 struct ordered_events *oe)
> +int perf_event__process_finished_round(struct perf_tool *tool __maybe_unused,
> +                                      union perf_event *event __maybe_unused,
> +                                      struct ordered_events *oe)
>  {
>         if (dump_trace)
>                 fprintf(stdout, "\n");
> diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
> index 34500a3da735..be5871ea558f 100644
> --- a/tools/perf/util/session.h
> +++ b/tools/perf/util/session.h
> @@ -155,4 +155,8 @@ int perf_session__deliver_synth_event(struct perf_session *session,
>  int perf_event__process_id_index(struct perf_session *session,
>                                  union perf_event *event);
>
> +int perf_event__process_finished_round(struct perf_tool *tool,
> +                                      union perf_event *event,
> +                                      struct ordered_events *oe);
> +

Sorry to be naive, why is this  perf_event__ and not perf_session__ ..
well I guess it is at least passed an event even though it doesn't use
it. Would be nice if there were comments, but this change is just
shifting things around. Anyway..

Acked-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

>  #endif /* __PERF_SESSION_H */
> --
> 2.25.1
>
