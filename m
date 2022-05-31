Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD40053955F
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 19:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346507AbiEaRVL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 13:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346500AbiEaRVJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 13:21:09 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43B43D490
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 10:21:06 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 3-20020a17090a174300b001e426a02ac5so294750pjm.2
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 10:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=d6looA2UP+ywwrJMPZ03TmeHZDINp5HCkg5hQxlfWLM=;
        b=h+7RD/vqbs8N2gNgq/+f2Qw5MMhzYnXPw+uFsMkDZWkdLttVU7dsjLJXP7/YQWvfHu
         GZWOEgzVXRwYsA0EJMMHTaf5rFo+5P0fFKNqTKfOg/PV8Aq5yuN6sYZ/IMoN7c3Dt+Pd
         p/LBLA2KZYp+JLtMdmB/2XDzfkuJ0tge8wWvJJIlUbc+2AvyX6j78Pek0w+ZFax7MXOu
         t64IA71VIsTTtQU55s3Hg4NBhWUrYWvycsG+GlJCXrYb6jp9es/UgXwwpb9dPPv/VQGC
         AED++NYKpzsJTjegtZSK6hx975w/IWNnamytLvd+AXy3RJEXm+naYSKqhKU+LIL3h0uF
         ME2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=d6looA2UP+ywwrJMPZ03TmeHZDINp5HCkg5hQxlfWLM=;
        b=P8m9oupRhyl2+XVoU1yYRAVKaHvgTxLjqG0AbFVqbA4nvY6xVCLPJhJS1m6QV2CTJ/
         dPWW1xelybE0ZIyWpg6hr3s2ljGWTy83Ux+bzxqDN/GuHgiL0WJ2Y7tifNwN4WUK6Los
         tPj5FOKi5hB2g/z0/7qj5m19rM/2uikZq8eyN8X0PcyGqA9dAPJZFr0OfHu8LVF5Lo8p
         EMcVcyk/UEqXwEaWSVeFFEAZJqpXbNj01Nj4eqmDo021XRWtxxA+IPm7WlOVcvdoZvQx
         oSvyi9KATJQ1XtiFLOgpCEk8jOHvOC70M7izhV8LgVQUZVeUi1HAxLZn7ZyYf+KQxsf8
         dN4Q==
X-Gm-Message-State: AOAM5304JoGoFUarW07FtQ3hrxlf6lnK5FWCEL4yKS0r0tKBlBGxbVVV
        ynxXlYH7LogEeTPrplACtJDnUDqt/SYR7J5/zQInk5Trqg==
X-Google-Smtp-Source: ABdhPJwySBNQi5bvbEInlXm+OiLWh3Gg67Cmh8JucV6f0/YaSl0qaS8o1Sz5nxzg5D/geGQn1d6PFJfBgUtVt3Socbk=
X-Received: by 2002:a17:902:cecb:b0:163:fc74:b6a8 with SMTP id
 d11-20020a170902cecb00b00163fc74b6a8mr5951106plg.82.1654017665929; Tue, 31
 May 2022 10:21:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAGG=3QXUfFksVLF=gzU3EYkyf7RQKvr5_FU6Ea5enf39vinY3A@mail.gmail.com>
In-Reply-To: <CAGG=3QXUfFksVLF=gzU3EYkyf7RQKvr5_FU6Ea5enf39vinY3A@mail.gmail.com>
From:   Bill Wendling <morbo@google.com>
Date:   Tue, 31 May 2022 10:20:55 -0700
Message-ID: <CAGG=3QVLKd9thPVnnJcwnn7ja-8-o5jLj0KnazkvgyXA+O-1GA@mail.gmail.com>
Subject: Re: [kvm-unit-tests RFC] Inlining in PMU Test
To:     kvm list <kvm@vger.kernel.org>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bump for exposure.

-bw

On Thu, May 26, 2022 at 6:32 PM Bill Wendling <morbo@google.com> wrote:
>
> I'm into an issue when I compile kvm-unit-tests with a new-ish Clang
> version. It results in a failure similar to this:
>
> Serial contents after VMM exited:
> SeaBIOS (version 1.8.2-20160510_123855-google)
> Total RAM Size = 0x0000000100000000 = 4096 MiB
> CPU Mhz=2000
> CPUs found: 1     Max CPUs supported: 1
> Booting from ROM...
> enabling apic
> paging enabled
> cr0 = 80010011
> cr3 = bfefc000
> cr4 = 20
> PMU version:         4
> GP counters:         3
> GP counter width:    48
> Mask length:         7
> Fixed counters:      3
> Fixed counter width: 48
>  ---8<---
> PASS: all counters
> FAIL: overflow: cntr-0
> PASS: overflow: status-0
> PASS: overflow: status clear-0
> PASS: overflow: irq-0
> FAIL: overflow: cntr-1
> PASS: overflow: status-1
> PASS: overflow: status clear-1
> PASS: overflow: irq-1
> FAIL: overflow: cntr-2
> PASS: overflow: status-2
> PASS: overflow: status clear-2
> PASS: overflow: irq-2
> FAIL: overflow: cntr-3
> PASS: overflow: status-3
> PASS: overflow: status clear-3
> PASS: overflow: irq-3
>  ---8<---
>
> It turns out that newer Clangs are much more aggressive at inlining
> than GCC. I could replicate this failure with GCC with the patch
> below[1] (the patch probably isn't minimal). If I add the "noinline"
> attribute "measure()" in the patch below, the test passes.
>
> Is there a subtle assumption being made by the test that breaks with
> aggressive inlining? If so, is adding the "noinline" attribute to
> "measure()" the correct fix, or should the test be made more robust?
>
> -bw
>
> [1]
> diff --git a/x86/pmu.c b/x86/pmu.c
> index a46bdbf4788c..4295e0c83aa0 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -104,7 +104,7 @@ static int num_counters;
>
>  char *buf;
>
> -static inline void loop(void)
> +static __always_inline void loop(void)
>  {
>         unsigned long tmp, tmp2, tmp3;
>
> @@ -144,7 +144,7 @@ static int event_to_global_idx(pmu_counter_t *cnt)
>                 (MSR_CORE_PERF_FIXED_CTR0 - FIXED_CNT_INDEX));
>  }
>
> -static struct pmu_event* get_counter_event(pmu_counter_t *cnt)
> +static __always_inline struct pmu_event* get_counter_event(pmu_counter_t *cnt)
>  {
>         if (is_gp(cnt)) {
>                 int i;
> @@ -158,7 +158,7 @@ static struct pmu_event*
> get_counter_event(pmu_counter_t *cnt)
>         return (void*)0;
>  }
>
> -static void global_enable(pmu_counter_t *cnt)
> +static __always_inline void global_enable(pmu_counter_t *cnt)
>  {
>         cnt->idx = event_to_global_idx(cnt);
>
> @@ -166,14 +166,14 @@ static void global_enable(pmu_counter_t *cnt)
>                         (1ull << cnt->idx));
>  }
>
> -static void global_disable(pmu_counter_t *cnt)
> +static __always_inline void global_disable(pmu_counter_t *cnt)
>  {
>         wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, rdmsr(MSR_CORE_PERF_GLOBAL_CTRL) &
>                         ~(1ull << cnt->idx));
>  }
>
>
> -static void start_event(pmu_counter_t *evt)
> +static __always_inline void start_event(pmu_counter_t *evt)
>  {
>      wrmsr(evt->ctr, evt->count);
>      if (is_gp(evt))
> @@ -197,7 +197,7 @@ static void start_event(pmu_counter_t *evt)
>      apic_write(APIC_LVTPC, PC_VECTOR);
>  }
>
> -static void stop_event(pmu_counter_t *evt)
> +static __always_inline void stop_event(pmu_counter_t *evt)
>  {
>         global_disable(evt);
>         if (is_gp(evt))
> @@ -211,7 +211,7 @@ static void stop_event(pmu_counter_t *evt)
>         evt->count = rdmsr(evt->ctr);
>  }
>
> -static void measure(pmu_counter_t *evt, int count)
> +static __always_inline void measure(pmu_counter_t *evt, int count)
>  {
>         int i;
>         for (i = 0; i < count; i++)
