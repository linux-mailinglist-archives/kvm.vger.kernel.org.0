Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014DF57AC03
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 03:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241090AbiGTBPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 21:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241002AbiGTBPT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 21:15:19 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04814691E8
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 18:13:24 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id z13so4437664wro.13
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 18:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FH/KgreGevFMzjScUNpVyMkOXY2ypEXuM+aIA1gugyc=;
        b=INkgZiK4DUYnl4oocrc5S+A359fzZcaHQbqimbRv1p88ZDzjZK/DEOd0JgDhgL1OTW
         pih0OJiaercJ7M3P5AgDLuWV9LGA4OOIJq315kpcl0Cb9sBoQy7JfPH4bQdeTbhvQUJN
         2I+1A3RBNFfmtHxztBx6Ml/YyFUs3HEi6oPGAAjcAwmQd41EEyDiYASzlhrXR95wq0QD
         KuVk8XKhi8wedl2vim10eNA89bdDY+Y/b0sPblFmpaQIVkDcowoaJmyeqGFE+1yntz1f
         L0du4NhlWrlCFRNaEBR37AXQxW67AFshNCYq3F0jqrpXBzQtzATaz2ujXlExyh5fpPtb
         sEjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FH/KgreGevFMzjScUNpVyMkOXY2ypEXuM+aIA1gugyc=;
        b=3J+SeQHaYFSy6L0PZLzJYH0YXfkQgQgK0s8Zg90wyREMMFi8k+nXIeyKMcdySZ6qAg
         I+iQq2/k8lj41qIbtsKc/IuF38eT2B/hSGvSK9VO2iCCu+xnWlfEO2BZLJGwQNQ3ml2b
         8srYP/+d1uGfZ6R8VlwcnpIm/n93GxLO6BtnPMJcbB+C1ys6Xxz6Sbhgoo4NoBkIlQkM
         oZC5BlipMTJSsM7rqZMSFLtuPubW4EhA+u2V+3S3g97Kv7W1dET4yzTwyDgNVJ21NluI
         QwrMFDL08/ZfLfvvMPTdphGGUheftpveRh/6AmM+V7qNLUJLTuPNXEYsTisWYUdA4Red
         aDLQ==
X-Gm-Message-State: AJIora/tOVRmXb00qaNdj5/V8M47aAal6u/8lCK0/uIC+zE9/i2A4q7r
        ioUM6wY8Zxj+ilOXKdbor4VQtCZJSracIKIIvifVlA==
X-Google-Smtp-Source: AGRyM1uAaV5GBBL2uD9Yvx8MxNCl9fCmaAVGTa0IJxUkRstdkHGMEWdof5PJ4rQgQxWv9KMWEcVTiX3sAYE66d+R7Uw=
X-Received: by 2002:a05:6000:1a8e:b0:21d:a7a8:54f4 with SMTP id
 f14-20020a0560001a8e00b0021da7a854f4mr29416111wry.654.1658279602311; Tue, 19
 Jul 2022 18:13:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220711093218.10967-1-adrian.hunter@intel.com> <20220711093218.10967-30-adrian.hunter@intel.com>
In-Reply-To: <20220711093218.10967-30-adrian.hunter@intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 19 Jul 2022 18:13:10 -0700
Message-ID: <CAP-5=fXA56PMT7X4GprdM49L26XD+LP97QOiiQOHpFCL-He+1w@mail.gmail.com>
Subject: Re: [PATCH 29/35] perf intel-pt: Add some more logging to intel_pt_walk_next_insn()
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 11, 2022 at 2:33 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
>
> To aid debugging, add some more logging to intel_pt_walk_next_insn().
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Acked-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  tools/perf/util/intel-pt.c | 25 ++++++++++++++++++++-----
>  1 file changed, 20 insertions(+), 5 deletions(-)
>
> diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
> index 014f9f73cc49..a8798b5bb311 100644
> --- a/tools/perf/util/intel-pt.c
> +++ b/tools/perf/util/intel-pt.c
> @@ -758,27 +758,38 @@ static int intel_pt_walk_next_insn(struct intel_pt_insn *intel_pt_insn,
>
>         if (nr) {
>                 if ((!symbol_conf.guest_code && cpumode != PERF_RECORD_MISC_GUEST_KERNEL) ||
> -                   intel_pt_get_guest(ptq))
> +                   intel_pt_get_guest(ptq)) {
> +                       intel_pt_log("ERROR: no guest machine\n");
>                         return -EINVAL;
> +               }
>                 machine = ptq->guest_machine;
>                 thread = ptq->guest_thread;
>                 if (!thread) {
> -                       if (cpumode != PERF_RECORD_MISC_GUEST_KERNEL)
> +                       if (cpumode != PERF_RECORD_MISC_GUEST_KERNEL) {
> +                               intel_pt_log("ERROR: no guest thread\n");
>                                 return -EINVAL;
> +                       }
>                         thread = ptq->unknown_guest_thread;
>                 }
>         } else {
>                 thread = ptq->thread;
>                 if (!thread) {
> -                       if (cpumode != PERF_RECORD_MISC_KERNEL)
> +                       if (cpumode != PERF_RECORD_MISC_KERNEL) {
> +                               intel_pt_log("ERROR: no thread\n");
>                                 return -EINVAL;
> +                       }
>                         thread = ptq->pt->unknown_thread;
>                 }
>         }
>
>         while (1) {
> -               if (!thread__find_map(thread, cpumode, *ip, &al) || !al.map->dso)
> +               if (!thread__find_map(thread, cpumode, *ip, &al) || !al.map->dso) {
> +                       if (al.map)
> +                               intel_pt_log("ERROR: thread has no dso for %#" PRIx64 "\n", *ip);
> +                       else
> +                               intel_pt_log("ERROR: thread has no map for %#" PRIx64 "\n", *ip);
>                         return -EINVAL;
> +               }
>
>                 if (al.map->dso->data.status == DSO_DATA_STATUS_ERROR &&
>                     dso__data_status_seen(al.map->dso,
> @@ -819,8 +830,12 @@ static int intel_pt_walk_next_insn(struct intel_pt_insn *intel_pt_insn,
>                         len = dso__data_read_offset(al.map->dso, machine,
>                                                     offset, buf,
>                                                     INTEL_PT_INSN_BUF_SZ);
> -                       if (len <= 0)
> +                       if (len <= 0) {
> +                               intel_pt_log("ERROR: failed to read at %" PRIu64 " ", offset);
> +                               if (intel_pt_enable_logging)
> +                                       dso__fprintf(al.map->dso, intel_pt_log_fp());
>                                 return -EINVAL;
> +                       }
>
>                         if (intel_pt_get_insn(buf, len, x86_64, intel_pt_insn))
>                                 return -EINVAL;
> --
> 2.25.1
>
