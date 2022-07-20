Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30A2657AC65
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 03:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241010AbiGTBXM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 21:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240829AbiGTBNf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 21:13:35 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E734C619
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 18:12:41 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id bk26so23999558wrb.11
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 18:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YJ/hv9oFQdyrfMvyWlCvTg8vw9f09FlcR0Vgk9LoZxo=;
        b=JULpCrAWak1LTBxbGvklS89lndPzgktVTEUnD7/WZjFzTs41iXHReCXZCLaB2QhzYp
         0beqig81wAPq2GQUlhGiDcpdTtLPZCYtHkF9CsTOcDJwc+MkLLSFpZ6dI/az4mVnowsv
         tw5xBo6m0t7zb2HV0c8pIPlRweuLcw4AZyubEU5lGcvb/vSUMmAAEWXB1fS7MCfLNm70
         PW3jH8aGI41ulcGu7sYubWWBXuLov6+ZFbMDP6/vXjM4L2alTy/vgHlN8H3DZ7OxHO1x
         GMoBiEfTIUFts7ydlSg1H0Y9lyVHL+z0LUo3Ou9ay4qaS9kNv4SbPlXX2q/gp27lWAK8
         HmHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YJ/hv9oFQdyrfMvyWlCvTg8vw9f09FlcR0Vgk9LoZxo=;
        b=KN10rml/D+4HHbMMXxbAt9avTFjwpw+zRx89Yh20305MSBTBK/ifWSx3gD1k1iYVOn
         nN5Sv8KNY+eCjnciM9WI0/sfwNcKIJKFGd7eTnAowc4ckGI37hGTNSpHEES5qFHCBDen
         hI8LUCYvF8uVjf/6c5DHylVMcSpGUwEhs8GfgTnQwl+EFcj9kOXAHqpqyWGrGQVNs2BZ
         6XjLeldfKch40TzGyVbCC5xJSIaLEx6Ia6HiaMTajqkhuS/BIj6/D4BETo7gde2C5AEB
         erCJoSjpLLWyaSucjVCg5lG8mixjlSF83RouxiSQaAT5jXgzxWyD9W52nrZCrKX8JXxj
         XwgA==
X-Gm-Message-State: AJIora91DBNor+Dd2T/0ptbZGvIdt9U8oza2QNvtMrwp0idTBs2MNng8
        3WgfAsohXxyDzfP8RZqu8yMsqoFg0Nx5oxNW7IvhGA==
X-Google-Smtp-Source: AGRyM1uVc6rYR9COQQY33A27DWZCJe13M7qEZKdHtIxtNh2LMjsWDV4v8n2RM4gtfNdwaKWhNvdDz7/jaY4lEIMmEAk=
X-Received: by 2002:a5d:4d8e:0:b0:21d:68d4:56eb with SMTP id
 b14-20020a5d4d8e000000b0021d68d456ebmr27806490wru.40.1658279559990; Tue, 19
 Jul 2022 18:12:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220711093218.10967-1-adrian.hunter@intel.com> <20220711093218.10967-29-adrian.hunter@intel.com>
In-Reply-To: <20220711093218.10967-29-adrian.hunter@intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 19 Jul 2022 18:12:28 -0700
Message-ID: <CAP-5=fUokEHjrCkJMTMJHKmLeWWV4Ntcy2HzhLKAKLDgrqW0Pg@mail.gmail.com>
Subject: Re: [PATCH 28/35] perf intel-pt: Remove guest_machine_pid
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
> Remove guest_machine_pid because it is not needed.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Acked-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  tools/perf/util/intel-pt.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
> index 62b2f375a94d..014f9f73cc49 100644
> --- a/tools/perf/util/intel-pt.c
> +++ b/tools/perf/util/intel-pt.c
> @@ -194,7 +194,6 @@ struct intel_pt_queue {
>         struct machine *guest_machine;
>         struct thread *guest_thread;
>         struct thread *unknown_guest_thread;
> -       pid_t guest_machine_pid;
>         bool exclude_kernel;
>         bool have_sample;
>         u64 time;
> @@ -685,7 +684,7 @@ static int intel_pt_get_guest(struct intel_pt_queue *ptq)
>         struct machine *machine;
>         pid_t pid = ptq->pid <= 0 ? DEFAULT_GUEST_KERNEL_ID : ptq->pid;
>
> -       if (ptq->guest_machine && pid == ptq->guest_machine_pid)
> +       if (ptq->guest_machine && pid == ptq->guest_machine->pid)
>                 return 0;
>
>         ptq->guest_machine = NULL;
> @@ -705,7 +704,6 @@ static int intel_pt_get_guest(struct intel_pt_queue *ptq)
>                 return -1;
>
>         ptq->guest_machine = machine;
> -       ptq->guest_machine_pid = pid;
>
>         return 0;
>  }
> --
> 2.25.1
>
