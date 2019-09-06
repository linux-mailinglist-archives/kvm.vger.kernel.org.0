Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38FE7ABE05
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 18:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405934AbfIFQtK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 12:49:10 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:38959 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbfIFQtI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 12:49:08 -0400
Received: by mail-io1-f68.google.com with SMTP id d25so14199106iob.6
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2019 09:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=faOgYAGnpk9YzEf2PpC5o+37WCB6ODxfEk9TQc/WXH0=;
        b=NlEqQ7sPv38dImf2fEqQ9+r4ag0SwchnFXfXLRBxS7HdV2w0EEyZsM2Hkd6mphOZBX
         1aCMH+n0c6BTvgnXX6jDw4UE0mTguRXx56tO0Zk1H8WT570TlcOrC7cQZMeGvNIhxGbS
         wBI3apDI0z47iasp//HO/cIepkfevAIwAwKZK5GS8pVYeNd8owY38fI/yVBjfimIizla
         hE/6KJlpRwptpXpobkzX9I+HwAxZK2iBJz9efqISKzN6xI97bzspcjhOb8U4Wnx8HT6C
         Y5RrD/dPiQWSFFzIXJy8VrsTECz7pFHoyM4OO+2jK6IgVyINFljPPmmvjZQ0cr9nPwTa
         r87g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=faOgYAGnpk9YzEf2PpC5o+37WCB6ODxfEk9TQc/WXH0=;
        b=oHbZp7u2a43xy/Nbfg1+Y6BQyHXStgsLhY0f0ib0m96SNM8s+g56Rl1Z5K7vbWazCp
         etzRZ14cm2I6+Ij3Qj1HoewBmNO2HefqImrWUzlVeQ+p/zXpDU6PzkebtAf1E6cGoA+v
         dUsOcOe+vGbSNb7+BlzRm6Eyl6B3e9PIOHwVf8TS+faBur6pOIh9oCHiZ7paeTZpPGtF
         XX7K++HxxGhQ5hdB3BVtKxG2ViqEWiVGYcm90PxEhaKRTXXnTtXr4j60TEaLxR3t1bUE
         OoepHVF/8sCvtQVyt0hZomvk3AJHNXGP5cEdVVybqBE+uiGj/V8hvMerdV0WN/MPfRbJ
         4GEw==
X-Gm-Message-State: APjAAAWKWRxsWKwQ0e9PXDz4/EH+52vf+yp5TttLdnWePnc7GDpKaQmi
        KylWfSCvSy3UUbOYwQgO2kpSRP+Y7czGdQXAPDnbGsKk7p4=
X-Google-Smtp-Source: APXvYqzwvU1DXcRL3lQH7HqXCfiXoNKWRHA9eVELLnq+DJ2JSpQkJXZJ5PCu6iR/pl89NhOKONqCqW9eyvHuio1BTtA=
X-Received: by 2002:a02:5205:: with SMTP id d5mr9723316jab.31.1567788546939;
 Fri, 06 Sep 2019 09:49:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190821182004.102768-1-jmattson@google.com>
In-Reply-To: <20190821182004.102768-1-jmattson@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 6 Sep 2019 09:48:55 -0700
Message-ID: <CALMp9eTtA5ZXJyWcOpe-pQ66X3sTgCR4-BHec_R3e1-j1FZyZw@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86: Add Intel PMU MSRs to msrs_to_save[]
To:     kvm list <kvm@vger.kernel.org>
Cc:     Eric Hankland <ehankland@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 21, 2019 at 11:20 AM Jim Mattson <jmattson@google.com> wrote:
>
> These MSRs should be enumerated by KVM_GET_MSR_INDEX_LIST, so that
> userspace knows that these MSRs may be part of the vCPU state.
>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Eric Hankland <ehankland@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
>
> ---
>  arch/x86/kvm/x86.c | 41 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 93b0bd45ac73..ecaaa411538f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1140,6 +1140,42 @@ static u32 msrs_to_save[] = {
>         MSR_IA32_RTIT_ADDR1_A, MSR_IA32_RTIT_ADDR1_B,
>         MSR_IA32_RTIT_ADDR2_A, MSR_IA32_RTIT_ADDR2_B,
>         MSR_IA32_RTIT_ADDR3_A, MSR_IA32_RTIT_ADDR3_B,
> +       MSR_ARCH_PERFMON_FIXED_CTR0, MSR_ARCH_PERFMON_FIXED_CTR1,
> +       MSR_ARCH_PERFMON_FIXED_CTR0 + 2, MSR_ARCH_PERFMON_FIXED_CTR0 + 3,
> +       MSR_CORE_PERF_FIXED_CTR_CTRL, MSR_CORE_PERF_GLOBAL_STATUS,
> +       MSR_CORE_PERF_GLOBAL_CTRL, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
> +       MSR_ARCH_PERFMON_PERFCTR0, MSR_ARCH_PERFMON_PERFCTR1,
> +       MSR_ARCH_PERFMON_PERFCTR0 + 2, MSR_ARCH_PERFMON_PERFCTR0 + 3,
> +       MSR_ARCH_PERFMON_PERFCTR0 + 4, MSR_ARCH_PERFMON_PERFCTR0 + 5,
> +       MSR_ARCH_PERFMON_PERFCTR0 + 6, MSR_ARCH_PERFMON_PERFCTR0 + 7,
> +       MSR_ARCH_PERFMON_PERFCTR0 + 8, MSR_ARCH_PERFMON_PERFCTR0 + 9,
> +       MSR_ARCH_PERFMON_PERFCTR0 + 10, MSR_ARCH_PERFMON_PERFCTR0 + 11,
> +       MSR_ARCH_PERFMON_PERFCTR0 + 12, MSR_ARCH_PERFMON_PERFCTR0 + 13,
> +       MSR_ARCH_PERFMON_PERFCTR0 + 14, MSR_ARCH_PERFMON_PERFCTR0 + 15,
> +       MSR_ARCH_PERFMON_PERFCTR0 + 16, MSR_ARCH_PERFMON_PERFCTR0 + 17,
> +       MSR_ARCH_PERFMON_PERFCTR0 + 18, MSR_ARCH_PERFMON_PERFCTR0 + 19,
> +       MSR_ARCH_PERFMON_PERFCTR0 + 20, MSR_ARCH_PERFMON_PERFCTR0 + 21,
> +       MSR_ARCH_PERFMON_PERFCTR0 + 22, MSR_ARCH_PERFMON_PERFCTR0 + 23,
> +       MSR_ARCH_PERFMON_PERFCTR0 + 24, MSR_ARCH_PERFMON_PERFCTR0 + 25,
> +       MSR_ARCH_PERFMON_PERFCTR0 + 26, MSR_ARCH_PERFMON_PERFCTR0 + 27,
> +       MSR_ARCH_PERFMON_PERFCTR0 + 28, MSR_ARCH_PERFMON_PERFCTR0 + 29,
> +       MSR_ARCH_PERFMON_PERFCTR0 + 30, MSR_ARCH_PERFMON_PERFCTR0 + 31,
> +       MSR_ARCH_PERFMON_EVENTSEL0, MSR_ARCH_PERFMON_EVENTSEL1,
> +       MSR_ARCH_PERFMON_EVENTSEL0 + 2, MSR_ARCH_PERFMON_EVENTSEL0 + 3,
> +       MSR_ARCH_PERFMON_EVENTSEL0 + 4, MSR_ARCH_PERFMON_EVENTSEL0 + 5,
> +       MSR_ARCH_PERFMON_EVENTSEL0 + 6, MSR_ARCH_PERFMON_EVENTSEL0 + 7,
> +       MSR_ARCH_PERFMON_EVENTSEL0 + 8, MSR_ARCH_PERFMON_EVENTSEL0 + 9,
> +       MSR_ARCH_PERFMON_EVENTSEL0 + 10, MSR_ARCH_PERFMON_EVENTSEL0 + 11,
> +       MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 + 13,
> +       MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
> +       MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
> +       MSR_ARCH_PERFMON_EVENTSEL0 + 18, MSR_ARCH_PERFMON_EVENTSEL0 + 19,
> +       MSR_ARCH_PERFMON_EVENTSEL0 + 20, MSR_ARCH_PERFMON_EVENTSEL0 + 21,
> +       MSR_ARCH_PERFMON_EVENTSEL0 + 22, MSR_ARCH_PERFMON_EVENTSEL0 + 23,
> +       MSR_ARCH_PERFMON_EVENTSEL0 + 24, MSR_ARCH_PERFMON_EVENTSEL0 + 25,
> +       MSR_ARCH_PERFMON_EVENTSEL0 + 26, MSR_ARCH_PERFMON_EVENTSEL0 + 27,
> +       MSR_ARCH_PERFMON_EVENTSEL0 + 28, MSR_ARCH_PERFMON_EVENTSEL0 + 29,
> +       MSR_ARCH_PERFMON_EVENTSEL0 + 30, MSR_ARCH_PERFMON_EVENTSEL0 + 31,
>  };
>
>  static unsigned num_msrs_to_save;
> @@ -4989,6 +5025,11 @@ static void kvm_init_msr_list(void)
>         u32 dummy[2];
>         unsigned i, j;
>
> +       BUILD_BUG_ON_MSG(INTEL_PMC_MAX_FIXED != 4,
> +                        "Please update the fixed PMCs in msrs_to_save[]");
> +       BUILD_BUG_ON_MSG(INTEL_PMC_MAX_GENERIC != 32,
> +                        "Please update the generic perfctr/eventsel MSRs in msrs_to_save[]");
> +
>         for (i = j = 0; i < ARRAY_SIZE(msrs_to_save); i++) {
>                 if (rdmsr_safe(msrs_to_save[i], &dummy[0], &dummy[1]) < 0)
>                         continue;
> --
> 2.23.0.187.g17f5b7556c-goog


Ping.
