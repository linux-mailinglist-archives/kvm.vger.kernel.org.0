Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49130AC16C
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 22:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391150AbfIFUaT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 16:30:19 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:45992 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731976AbfIFUaS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 16:30:18 -0400
Received: by mail-io1-f68.google.com with SMTP id f12so15639788iog.12
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2019 13:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G6SIZUWjhFKlir/vEoGxVJSy6+hlkYMbk0Sgcel4fPA=;
        b=LC1q6XUUQdIGwQRKKibLvFB6Tm6kvMasHF3nVOiEsIcxsQKVdSqlXdP1jIPuBzuq6r
         s+VWj+xzYzkSYAu7ioOCTQFlxYvhnNRvNZ2a7EgFGhcmyfzPITxo8uGR3ijByvVquWtq
         d1PIU/jiBO7kfUriXLV9nmzuTFieUTRQgEFlUR4Su4qg7FyDXzwZEP+LYmh2ZhqIEuxS
         qp6hiBIh3w0sWTRYi39zxwY8QvhkrmFn8r0F7BmN9+f6f0pMmpUVW2WVjX0kJN6y7BuK
         wrmKRC7N9icVI2U1WaDKOLiMtCbtwDM6Nfz/lsLej7wzcGCHKrG/j/SEJOc7Y9qwnaQM
         lnEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G6SIZUWjhFKlir/vEoGxVJSy6+hlkYMbk0Sgcel4fPA=;
        b=HVrqf//1K5a/CbyGRoRv51Go1WsWocKPEkmfMMM2TvWcolO7sWeMGeHwtkue3htUHS
         boGsgsKFpSHb8dIMkdGIyfuaO4rmEJGbHRsc1P0sdcjAHQJwJcHzCSTzcoiGXd5D9k6N
         hdW560VWEet9MNpwHep71bXaEJylkQZ62cUVWcDzc72b6USLIOYrNiQi+hJ1gWOF48x9
         HFiGTiT89utZyprCgWlaMZO8ctI54diW56cz2Dy85e69C+fFv3HzCSgeUrpPHzhYYRQ4
         NXMXNWiEoyayl3Nz7Ht4mC+NSuTsYaiEoQSHs+eLaDF8yD4wZkObOVHD3VCXg4oaXerR
         Qj1w==
X-Gm-Message-State: APjAAAW2D1vFEk1bzStzViTLWmUi1EIVUMYshCJLIIHNrvzBVGM+VrMA
        y/J6MpDDiUQ7mXmpEKPI6Y94dzIPSCqDhYSUuit0CA==
X-Google-Smtp-Source: APXvYqyQYfC3nsf8cE1JP503amncmIWLvPfRx2nYaqIpbArkqMWu5LJ6DiFzWSf7jbOjzDvG9qnJILRWGIpF/UCoQt4=
X-Received: by 2002:a5d:8e15:: with SMTP id e21mr11068885iod.296.1567801817011;
 Fri, 06 Sep 2019 13:30:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190821182004.102768-1-jmattson@google.com> <CALMp9eTtA5ZXJyWcOpe-pQ66X3sTgCR4-BHec_R3e1-j1FZyZw@mail.gmail.com>
 <8907173e-9f27-6769-09fc-0b82c22d6352@oracle.com>
In-Reply-To: <8907173e-9f27-6769-09fc-0b82c22d6352@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 6 Sep 2019 13:30:06 -0700
Message-ID: <CALMp9eSkognb2hJSuENK+5PSgE8sYzQP=4ioERge6ZaFg1=PEA@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86: Add Intel PMU MSRs to msrs_to_save[]
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Eric Hankland <ehankland@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 6, 2019 at 12:59 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
> On 9/6/19 9:48 AM, Jim Mattson wrote:
>
> On Wed, Aug 21, 2019 at 11:20 AM Jim Mattson <jmattson@google.com> wrote:
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
>
> Should we have separate #defines for the MSRs that are at offset from the base MSR?

How about macros that take an offset argument, rather than a whole
slew of new macros?

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
>
>
> Just curious how the condition can ever become false because we are comparing two static numbers here.

Someone just has to change the macros. In fact, I originally developed
this change on a version of the kernel where INTEL_PMC_MAX_FIXED was
3, and so I had:

> +       BUILD_BUG_ON_MSG(INTEL_PMC_MAX_FIXED != 3,
> +                        "Please update the fixed PMCs in msrs_to_save[]")

When I cherry-picked the change to Linux tip, the BUILD_BUG_ON fired,
and I updated the fixed PMCs in msrs_to_save[].

>
> +
>         for (i = j = 0; i < ARRAY_SIZE(msrs_to_save); i++) {
>                 if (rdmsr_safe(msrs_to_save[i], &dummy[0], &dummy[1]) < 0)
>                         continue;
> --
> 2.23.0.187.g17f5b7556c-goog
>
> Ping.
>
>
> Also, since these MSRs are Intel-specific, should these be enumerated via 'intel_pmu_ops' ?

msrs_to_save[] is filtered to remove MSRs that aren't supported on the
host. Or are you asking something else?
