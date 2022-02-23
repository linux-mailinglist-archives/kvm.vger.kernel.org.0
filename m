Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3491F4C1C99
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 20:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244526AbiBWTvG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 14:51:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238759AbiBWTvF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 14:51:05 -0500
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963E64BFC6
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 11:50:37 -0800 (PST)
Received: by mail-oo1-xc30.google.com with SMTP id i10-20020a4aab0a000000b002fccf890d5fso101800oon.5
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 11:50:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2zfiF9IZTxtJd2EhXrwpK4rauNyPJ/NDU/OsjD6A3H4=;
        b=oRdeGBXEqd+NldzBBr1Yv9nlwd/OIPOYZf4Tg1ZiJDmUSBrUmIFbta/kfp1iHOZZBB
         aLZoO4EhySArgHUsaLijLXiU3DGIpHINEgRXvQnU4mJyTtTzCCM+lqsks5Ldwk5cGgMK
         BK69t6kkZwbZuSIaDSFH8H1KN02BSwiMtQO6J5GDkuFISuqbvUwDm56t9Nh5iIje5RRl
         cPpcFSFxwyAmGFsFvYaemfnX383YmBn1svtjbFF8LAfkatWrwuTeFEgOW1nVja90MuU/
         9E8z6ySfcbJIkDeWoR9jk/2BT10ffFC+5BQk8rIIRX4yowSI5Yw8WBcVG4odskgCWYMs
         oPpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2zfiF9IZTxtJd2EhXrwpK4rauNyPJ/NDU/OsjD6A3H4=;
        b=wDPvRpqLciiBUPNrt4PP1tNH7wx17lL7o9ugGWoFz/xR/6uaB5+Uf+2pbP/he3hLBi
         6uPksvPUw0xEJTtnRh0t00peQcDFoIm7ZrVXqXm3SG/X4qER2jknz46EdwGcKkhLlgdU
         fCEpUS2t3VKe2EgzP63uJ/lg9nymVUpC+niLpVMLWTNrPTHSCjwvmMAFZcjXT5N9X0Gj
         s2BJmg/iXTdaRXL4x8JbtIfcx4uaUlQ2KtL0UVxkLTQKoHAjkPpYYIC2wFS68gPragJT
         vz3JrRA1BfzDzliU+51ryBkylThorSrkr3KbXcL8ubm2meDxo5x9+7HuhZbQBz+lp8RF
         5qRg==
X-Gm-Message-State: AOAM531aKX1eLBLNK0haWv4uqU0CR8C0ga67tDelZXfRKtFN/AnidWpq
        Z5Bm1fDQodfCF9Uwzf1//fQj6bEYQ4eLM+8YW72lgg==
X-Google-Smtp-Source: ABdhPJz1Rd9SoSeQf7txnVmqe8vlmFpgBN6BMy1tx+iUD1iNn+0o46hlSuyMGLmhUrLD0cUdwb/TrvC2zOIh2Y59o7I=
X-Received: by 2002:a05:6870:2890:b0:d3:f439:2cbb with SMTP id
 gy16-20020a056870289000b000d3f4392cbbmr563277oab.139.1645645836752; Wed, 23
 Feb 2022 11:50:36 -0800 (PST)
MIME-Version: 1.0
References: <20220221115201.22208-1-likexu@tencent.com> <20220221115201.22208-2-likexu@tencent.com>
In-Reply-To: <20220221115201.22208-2-likexu@tencent.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 23 Feb 2022 11:50:25 -0800
Message-ID: <CALMp9eTSyWdDe8yd_g2rp2ipx5CerP8CQ2a0H-1HMZsuxWOpfw@mail.gmail.com>
Subject: Re: [PATCH 01/11] KVM: x86/pmu: Update comments for AMD gp counters
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
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

On Mon, Feb 21, 2022 at 3:52 AM Like Xu <like.xu.linux@gmail.com> wrote:
>
> From: Like Xu <likexu@tencent.com>
>
> The obsolete comment could more accurately state that AMD platforms
> have two base MSR addresses and two different maximum numbers
> for gp counters, depending on the X86_FEATURE_PERFCTR_CORE feature.
>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/kvm/pmu.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index b1a02993782b..c4692f0ff87e 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -34,7 +34,7 @@
>   *   However AMD doesn't support fixed-counters;
>   * - There are three types of index to access perf counters (PMC):
>   *     1. MSR (named msr): For example Intel has MSR_IA32_PERFCTRn and AMD
> - *        has MSR_K7_PERFCTRn.
> + *        has MSR_F15H_PERF_CTRn or MSR_K7_PERFCTRn.

"Or" sounds exclusive. Maybe it would be better to say:

has MSR_K7_PERFCTRn and, for families 15H and later,
MSR_F15H_PERF_CTRn, where MSR_F15H_PERF_CTR[0-3] are aliased to
MSR_K7_PERFCTRn.
