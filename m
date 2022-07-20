Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6886A57AB17
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 02:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238449AbiGTAnw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 20:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238348AbiGTAnv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 20:43:51 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82885A891
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 17:43:50 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id i132-20020a1c3b8a000000b003a2fa488efdso338708wma.4
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 17:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rXTULeEY9CrirRyrfylRIp380NbLgfitDvY5suTQI40=;
        b=L5fCFei6RFPELL6Gqd2iJbH4NdtHa3Ki4zZh4n7tzk4BdU9ZFDOxCrZme3ZUXoqESE
         5HyQUZ5poUV+LhRRRXpTL2oo6+dm25N5hjg2CwO1f9HrvKj3/NUGZp5tlAVGpqA0PdZP
         9Hg5vPnPgZh0SotVFkDpxyzIgePVCLpaVxLroozpEVqVHsVbYHk5mW6n3dBFvD3KYM5Y
         QFAPJ+9Pa0NNbz8ltNAdBSnCD5TyG7eJ74n6vWylzCzHMsFNETZiBo9RKqoV0icMSwFd
         P1VyAqGikSwAnu4CHqWp9SUhuJZgWGLppV8x+teycxX1CPnYQ/yIIirXzx566prYdNQU
         gRSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rXTULeEY9CrirRyrfylRIp380NbLgfitDvY5suTQI40=;
        b=Xs4HAHKpqEbKrHPpeYgFE4BnOsUc8JNpXClwiMcIP+PPJ09LfTcpxDqENIVjtyR8oy
         kRUJ4fIrNSTcG3co/aKZtuIOrx1r2D65NUZj3ip8IRGfpyu0fhqmlxIHHEe+cnjJbNZ4
         49hV1uIOmsBXhQYM3X00/XJKQwu2cALTKzplaos/99ECHevjY2Z/BPVm7KxepvQfjYPY
         iFSJNHcHPgUGSh/i51k+jPFkmBwjulIYLfgViBwK3atLY1xrr4HWjuUDcFgTPx+kQBuB
         ADfWrb4Ewcg97dRpOJCJeEN5Of356TYzEJmqmywOFz/ZQkMn6IvlwOjN977hmbu0FCx2
         yaFg==
X-Gm-Message-State: AJIora8IHeTVHzb17QhQ591TmHjHtgCHnxMUue7it6YrvHKpN+XIgJw7
        XnJSaIap6g1z9qPN/F1xkde2XCo+VVyw7EiCgvdAMA==
X-Google-Smtp-Source: AGRyM1tt64ouXMPd8OZ6jQ4IWoCJ+94MiQ931wYWD0y2DwqC/7mOOVrkd6u+KNbKbCxbDRlr6PI/zVJq7ZJqQjVPeBE=
X-Received: by 2002:a05:600c:19c8:b0:3a1:792e:f913 with SMTP id
 u8-20020a05600c19c800b003a1792ef913mr1433128wmq.182.1658277829242; Tue, 19
 Jul 2022 17:43:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220711093218.10967-1-adrian.hunter@intel.com> <20220711093218.10967-19-adrian.hunter@intel.com>
In-Reply-To: <20220711093218.10967-19-adrian.hunter@intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 19 Jul 2022 17:43:36 -0700
Message-ID: <CAP-5=fVn1=jAm_+r0pq98z5JoCmBvaLbFxR=0nF9VGhbS9FB+w@mail.gmail.com>
Subject: Re: [PATCH 18/35] perf script python: Add machine_pid and vcpu
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
> Add machine_pid and vcpu to python sample events and context switch events.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Acked-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  .../perf/util/scripting-engines/trace-event-python.c  | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
> index 3367c5479199..5bbc1b16f368 100644
> --- a/tools/perf/util/scripting-engines/trace-event-python.c
> +++ b/tools/perf/util/scripting-engines/trace-event-python.c
> @@ -861,6 +861,13 @@ static PyObject *get_perf_sample_dict(struct perf_sample *sample,
>         brstacksym = python_process_brstacksym(sample, al->thread);
>         pydict_set_item_string_decref(dict, "brstacksym", brstacksym);
>
> +       if (sample->machine_pid) {
> +               pydict_set_item_string_decref(dict_sample, "machine_pid",
> +                               _PyLong_FromLong(sample->machine_pid));
> +               pydict_set_item_string_decref(dict_sample, "vcpu",
> +                               _PyLong_FromLong(sample->vcpu));
> +       }
> +
>         pydict_set_item_string_decref(dict_sample, "cpumode",
>                         _PyLong_FromLong((unsigned long)sample->cpumode));
>
> @@ -1509,7 +1516,7 @@ static void python_do_process_switch(union perf_event *event,
>                 np_tid = event->context_switch.next_prev_tid;
>         }
>
> -       t = tuple_new(9);
> +       t = tuple_new(11);
>         if (!t)
>                 return;
>
> @@ -1522,6 +1529,8 @@ static void python_do_process_switch(union perf_event *event,
>         tuple_set_s32(t, 6, machine->pid);
>         tuple_set_bool(t, 7, out);
>         tuple_set_bool(t, 8, out_preempt);
> +       tuple_set_s32(t, 9, sample->machine_pid);
> +       tuple_set_s32(t, 10, sample->vcpu);
>
>         call_object(handler, t, handler_name);
>
> --
> 2.25.1
>
