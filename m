Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 227B1AC1D8
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 23:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389632AbfIFVIs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 17:08:48 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:34726 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732020AbfIFVIs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 17:08:48 -0400
Received: by mail-io1-f66.google.com with SMTP id k13so682157ioj.1
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2019 14:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T2fgYHulh/x8JJn2cSBgvTrjLcHVAlJPYeQpLK+oXp4=;
        b=sw4/swbdbJv+yCpvLdXfbwsqoKfbiHdcNwPc13AZeli89bPXgHsPIarepMXO2XDhgT
         1cyrdr0pItoVFcMy3ju+lcvoMVydp+9vnPzAd110IklkcZDtK4b4MKQQaoPUPqqdufaj
         aCDNkyxd8eDBUBUjKkZVixmtDosoYi+2eM7RY9qJyyR9oklfmH0LFW+L7rolcOW7pw/A
         fgKjh5FEr4y6a9gEqwienvAf++i0HWt8AnQvZ3Z5Ap+LG7PbXbqA6qs+6ijjg87OxCdu
         DHopVW+qz4TiVG6tFoApm200SIAciBPHgoS8P2a19XTh+DUCL2LpVkpb6FjqPKrW31BK
         KGWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T2fgYHulh/x8JJn2cSBgvTrjLcHVAlJPYeQpLK+oXp4=;
        b=Kzpv6Tjx0h4yb+P3tI+Y7Yv3F4+TDoT809WXAmKQnzGjuZ6hkfoFUAdA6uVFRjI16b
         oa2YIdsQCdRaBd2tDzAeA/0JtclVroDrCplNFssy9gn2Jt7AT2kAnIJ7hP+s6eyUtVYZ
         W/YeyPgSUOYB5pZLoKGkRmeifLJWJzIETw3SxeMKuWCgVSRS7ujrXMB8yhwMTOrk7TDI
         dj9XSw7fUnMJPfhV09ZGjUxL2LM0mY0/VkTic4kTO4EELXA03nwOmxqpqjZxR+Yh9sBC
         CjSaAY1GrxJi/sSRpsalaEOTrLqPcid8ksgMluLSv6HUYL3I0BxjZ5R/PzO6yCJkWjk8
         ZI5w==
X-Gm-Message-State: APjAAAX9BZp1QR9h/sYgFI9X2FbfpWaABQmLUK/gDzJtzvhjNBuFBjYp
        hTteTbAGAjFELopnSZY/M8Kd5pq1ezT9z6gWr4NUkQ==
X-Google-Smtp-Source: APXvYqyQOT0KpdG/1GgALH/wgFhgyoyWD12+ZhQt3Tv67VVmxXllhvZkWbGxBrmNvXidLCmqMG9WhG8K0n278HrVyUY=
X-Received: by 2002:a5d:9499:: with SMTP id v25mr13246333ioj.138.1567804126728;
 Fri, 06 Sep 2019 14:08:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190821182004.102768-1-jmattson@google.com> <CALMp9eTtA5ZXJyWcOpe-pQ66X3sTgCR4-BHec_R3e1-j1FZyZw@mail.gmail.com>
 <8907173e-9f27-6769-09fc-0b82c22d6352@oracle.com> <CALMp9eSkognb2hJSuENK+5PSgE8sYzQP=4ioERge6ZaFg1=PEA@mail.gmail.com>
 <cb7c570c-389c-2e96-ba46-555218ba60ed@oracle.com>
In-Reply-To: <cb7c570c-389c-2e96-ba46-555218ba60ed@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 6 Sep 2019 14:08:31 -0700
Message-ID: <CALMp9eQULvr5wKt1Aw3MR+tbeNgvA_4p__6n1YTkWjMHCaEmLw@mail.gmail.com>
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

On Fri, Sep 6, 2019 at 1:43 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
> On 9/6/19 1:30 PM, Jim Mattson wrote:
> > On Fri, Sep 6, 2019 at 12:59 PM Krish Sadhukhan
> > <krish.sadhukhan@oracle.com> wrote:
> >>
> >> On 9/6/19 9:48 AM, Jim Mattson wrote:
> >>
> >> On Wed, Aug 21, 2019 at 11:20 AM Jim Mattson <jmattson@google.com> wrote:
> >>
> >> These MSRs should be enumerated by KVM_GET_MSR_INDEX_LIST, so that
> >> userspace knows that these MSRs may be part of the vCPU state.
> >>
> >> Signed-off-by: Jim Mattson <jmattson@google.com>
> >> Reviewed-by: Eric Hankland <ehankland@google.com>
> >> Reviewed-by: Peter Shier <pshier@google.com>
> >>
> >> ---
> >>   arch/x86/kvm/x86.c | 41 +++++++++++++++++++++++++++++++++++++++++
> >>   1 file changed, 41 insertions(+)
> >>
> >> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >> index 93b0bd45ac73..ecaaa411538f 100644
> >> --- a/arch/x86/kvm/x86.c
> >> +++ b/arch/x86/kvm/x86.c
> >> @@ -1140,6 +1140,42 @@ static u32 msrs_to_save[] = {
> >>          MSR_IA32_RTIT_ADDR1_A, MSR_IA32_RTIT_ADDR1_B,
> >>          MSR_IA32_RTIT_ADDR2_A, MSR_IA32_RTIT_ADDR2_B,
> >>          MSR_IA32_RTIT_ADDR3_A, MSR_IA32_RTIT_ADDR3_B,
> >> +       MSR_ARCH_PERFMON_FIXED_CTR0, MSR_ARCH_PERFMON_FIXED_CTR1,
> >> +       MSR_ARCH_PERFMON_FIXED_CTR0 + 2, MSR_ARCH_PERFMON_FIXED_CTR0 + 3,
> >> +       MSR_CORE_PERF_FIXED_CTR_CTRL, MSR_CORE_PERF_GLOBAL_STATUS,
> >> +       MSR_CORE_PERF_GLOBAL_CTRL, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
> >> +       MSR_ARCH_PERFMON_PERFCTR0, MSR_ARCH_PERFMON_PERFCTR1,
> >> +       MSR_ARCH_PERFMON_PERFCTR0 + 2, MSR_ARCH_PERFMON_PERFCTR0 + 3,
> >> +       MSR_ARCH_PERFMON_PERFCTR0 + 4, MSR_ARCH_PERFMON_PERFCTR0 + 5,
> >> +       MSR_ARCH_PERFMON_PERFCTR0 + 6, MSR_ARCH_PERFMON_PERFCTR0 + 7,
> >> +       MSR_ARCH_PERFMON_PERFCTR0 + 8, MSR_ARCH_PERFMON_PERFCTR0 + 9,
> >> +       MSR_ARCH_PERFMON_PERFCTR0 + 10, MSR_ARCH_PERFMON_PERFCTR0 + 11,
> >> +       MSR_ARCH_PERFMON_PERFCTR0 + 12, MSR_ARCH_PERFMON_PERFCTR0 + 13,
> >> +       MSR_ARCH_PERFMON_PERFCTR0 + 14, MSR_ARCH_PERFMON_PERFCTR0 + 15,
> >> +       MSR_ARCH_PERFMON_PERFCTR0 + 16, MSR_ARCH_PERFMON_PERFCTR0 + 17,
> >> +       MSR_ARCH_PERFMON_PERFCTR0 + 18, MSR_ARCH_PERFMON_PERFCTR0 + 19,
> >> +       MSR_ARCH_PERFMON_PERFCTR0 + 20, MSR_ARCH_PERFMON_PERFCTR0 + 21,
> >> +       MSR_ARCH_PERFMON_PERFCTR0 + 22, MSR_ARCH_PERFMON_PERFCTR0 + 23,
> >> +       MSR_ARCH_PERFMON_PERFCTR0 + 24, MSR_ARCH_PERFMON_PERFCTR0 + 25,
> >> +       MSR_ARCH_PERFMON_PERFCTR0 + 26, MSR_ARCH_PERFMON_PERFCTR0 + 27,
> >> +       MSR_ARCH_PERFMON_PERFCTR0 + 28, MSR_ARCH_PERFMON_PERFCTR0 + 29,
> >> +       MSR_ARCH_PERFMON_PERFCTR0 + 30, MSR_ARCH_PERFMON_PERFCTR0 + 31,
> >> +       MSR_ARCH_PERFMON_EVENTSEL0, MSR_ARCH_PERFMON_EVENTSEL1,
> >> +       MSR_ARCH_PERFMON_EVENTSEL0 + 2, MSR_ARCH_PERFMON_EVENTSEL0 + 3,
> >> +       MSR_ARCH_PERFMON_EVENTSEL0 + 4, MSR_ARCH_PERFMON_EVENTSEL0 + 5,
> >> +       MSR_ARCH_PERFMON_EVENTSEL0 + 6, MSR_ARCH_PERFMON_EVENTSEL0 + 7,
> >> +       MSR_ARCH_PERFMON_EVENTSEL0 + 8, MSR_ARCH_PERFMON_EVENTSEL0 + 9,
> >> +       MSR_ARCH_PERFMON_EVENTSEL0 + 10, MSR_ARCH_PERFMON_EVENTSEL0 + 11,
> >> +       MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 + 13,
> >> +       MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
> >> +       MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
> >> +       MSR_ARCH_PERFMON_EVENTSEL0 + 18, MSR_ARCH_PERFMON_EVENTSEL0 + 19,
> >> +       MSR_ARCH_PERFMON_EVENTSEL0 + 20, MSR_ARCH_PERFMON_EVENTSEL0 + 21,
> >> +       MSR_ARCH_PERFMON_EVENTSEL0 + 22, MSR_ARCH_PERFMON_EVENTSEL0 + 23,
> >> +       MSR_ARCH_PERFMON_EVENTSEL0 + 24, MSR_ARCH_PERFMON_EVENTSEL0 + 25,
> >> +       MSR_ARCH_PERFMON_EVENTSEL0 + 26, MSR_ARCH_PERFMON_EVENTSEL0 + 27,
> >> +       MSR_ARCH_PERFMON_EVENTSEL0 + 28, MSR_ARCH_PERFMON_EVENTSEL0 + 29,
> >> +       MSR_ARCH_PERFMON_EVENTSEL0 + 30, MSR_ARCH_PERFMON_EVENTSEL0 + 31,
> >>   };
> >>
> >>
> >> Should we have separate #defines for the MSRs that are at offset from the base MSR?
> > How about macros that take an offset argument, rather than a whole
> > slew of new macros?
>
>
> Yes, that works too.
>
>
> >
> >>   static unsigned num_msrs_to_save;
> >> @@ -4989,6 +5025,11 @@ static void kvm_init_msr_list(void)
> >>          u32 dummy[2];
> >>          unsigned i, j;
> >>
> >> +       BUILD_BUG_ON_MSG(INTEL_PMC_MAX_FIXED != 4,
> >> +                        "Please update the fixed PMCs in msrs_to_save[]");
> >> +       BUILD_BUG_ON_MSG(INTEL_PMC_MAX_GENERIC != 32,
> >> +                        "Please update the generic perfctr/eventsel MSRs in msrs_to_save[]");
> >>
> >>
> >> Just curious how the condition can ever become false because we are comparing two static numbers here.
> > Someone just has to change the macros. In fact, I originally developed
> > this change on a version of the kernel where INTEL_PMC_MAX_FIXED was
> > 3, and so I had:
> >
> >> +       BUILD_BUG_ON_MSG(INTEL_PMC_MAX_FIXED != 3,
> >> +                        "Please update the fixed PMCs in msrs_to_save[]")
> > When I cherry-picked the change to Linux tip, the BUILD_BUG_ON fired,
> > and I updated the fixed PMCs in msrs_to_save[].
> >
> >> +
> >>          for (i = j = 0; i < ARRAY_SIZE(msrs_to_save); i++) {
> >>                  if (rdmsr_safe(msrs_to_save[i], &dummy[0], &dummy[1]) < 0)
> >>                          continue;
> >> --
> >> 2.23.0.187.g17f5b7556c-goog
> >>
> >> Ping.
> >>
> >>
> >> Also, since these MSRs are Intel-specific, should these be enumerated via 'intel_pmu_ops' ?
> > msrs_to_save[] is filtered to remove MSRs that aren't supported on the
> > host. Or are you asking something else?
>
>
> I am referring to the fact that we are enumerating Intel-specific MSRs
> in the generic KVM code. Should there be some sort of #define guard to
> not compile the code on AMD ?

No. msrs_to_save[] contains *all* MSRs that may be relevant on some
platform. Notice that it already includes AMD-only MSRs (e.g.
MSR_VM_HSAVE_PA) and Intel-only MSRs (e.g. MSR_IA32_BNDCFGS). The MSRs
that are not relevant are filtered out in kvm_init_msr_list().

This list probably should include the AMD equivalents as well, but I
haven't looked into the AMD vPMU yet.
