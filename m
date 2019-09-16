Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3E6B4215
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2019 22:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391483AbfIPUny (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Sep 2019 16:43:54 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:44648 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730600AbfIPUny (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Sep 2019 16:43:54 -0400
Received: by mail-io1-f68.google.com with SMTP id j4so2194368iog.11
        for <kvm@vger.kernel.org>; Mon, 16 Sep 2019 13:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1Licd3Gwz3qYDc6svMKdvYmuSmCjOiQXJa2smrKqpwE=;
        b=fM2waGULQo9O1bh3+nD/f7spiG04M1rjE9VoTWg27+IcN4iYjtBS/uhvBesZPwpaAS
         WaaTM6g3pM+FnuXKM+VRtMLyRNWEhwI6QvMOyP83B0P12I7QIuSuZoN7m0ZUDTx+RXZe
         4LQssw84WWuWvP64irJW7j5h7MBWdePG0zUqFTb7GtTmB+1A7vct7D3frKB12J9r4vD1
         fGSElIo1U05X0U2k1Rxmdux/uA4UTQLp1I2JeiPHziuVwfwVhfLeRgbtLypeJax4FQzv
         s7KWwoM3rDMel3+PrAZdpQg3h1XVb5tyQg40UYnmHDKbkVtpsMbTg1ecyalrxa8DUK3Z
         2TKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1Licd3Gwz3qYDc6svMKdvYmuSmCjOiQXJa2smrKqpwE=;
        b=pAK0eKgednnOCHQJ/zuGv/7qw/BlLRUIvGxsoSxDLHpf/Or5ORVbv98x6XxlvfKuKH
         ybRNe+eRepS3ExTuGB2CP3XI0V52Ap57pYDe4bhVHaEV11rUTL4/Yk3yW8AuE+6cwrrk
         8kb0Su+kz2Iq0IoRIdvFaoWedaoRLgj4msepGl9+0WT5Fc3NyIciiLoQhw7Z1gEFYK8L
         nPM2kd4bgwISmvWBI4Ko0eosnpbPCK7JBPPHEBrNJKitzahK1/IV+wSftKmLXHD8vxXV
         AxAUz0W0oJcPt/jZzp7hHBZBexU4RtjXpXP15JrNVnXVR0HBh66FTlfYDA34eB5awYqm
         X95A==
X-Gm-Message-State: APjAAAUWSa9rFZnfut2kDCbrjeg9PlqvzRzc7uG41F5Bl61yOnfFpJnx
        1BQVkQAbv8Bl9PpoZ+IKKPjPgfvZPo+Q1GDzHMVpDB4PHrI=
X-Google-Smtp-Source: APXvYqxjyusdHoLPuR6vC1p7mPr4gNVobPNEi97y6ZfKInCWXfoJd75ZkW8/iFuKP1B+kNT7ApT3cNDUx6f3kyFnAs8=
X-Received: by 2002:a5e:8a43:: with SMTP id o3mr225812iom.296.1568666631672;
 Mon, 16 Sep 2019 13:43:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190821182004.102768-1-jmattson@google.com> <CALMp9eTtA5ZXJyWcOpe-pQ66X3sTgCR4-BHec_R3e1-j1FZyZw@mail.gmail.com>
 <8907173e-9f27-6769-09fc-0b82c22d6352@oracle.com> <CALMp9eSkognb2hJSuENK+5PSgE8sYzQP=4ioERge6ZaFg1=PEA@mail.gmail.com>
 <cb7c570c-389c-2e96-ba46-555218ba60ed@oracle.com> <CALMp9eQULvr5wKt1Aw3MR+tbeNgvA_4p__6n1YTkWjMHCaEmLw@mail.gmail.com>
In-Reply-To: <CALMp9eQULvr5wKt1Aw3MR+tbeNgvA_4p__6n1YTkWjMHCaEmLw@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 16 Sep 2019 13:43:40 -0700
Message-ID: <CALMp9eS1fUVcnVHhty60fUgk3-NuvELMOUFqQmqPLE-Nqy0dFQ@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86: Add Intel PMU MSRs to msrs_to_save[]
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Eric Hankland <ehankland@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 6, 2019 at 2:08 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Fri, Sep 6, 2019 at 1:43 PM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
> >
> >
> > On 9/6/19 1:30 PM, Jim Mattson wrote:
> > > On Fri, Sep 6, 2019 at 12:59 PM Krish Sadhukhan
> > > <krish.sadhukhan@oracle.com> wrote:
> > >>
> > >> On 9/6/19 9:48 AM, Jim Mattson wrote:
> > >>
> > >> On Wed, Aug 21, 2019 at 11:20 AM Jim Mattson <jmattson@google.com> wrote:
> > >>
> > >> These MSRs should be enumerated by KVM_GET_MSR_INDEX_LIST, so that
> > >> userspace knows that these MSRs may be part of the vCPU state.
> > >>
> > >> Signed-off-by: Jim Mattson <jmattson@google.com>
> > >> Reviewed-by: Eric Hankland <ehankland@google.com>
> > >> Reviewed-by: Peter Shier <pshier@google.com>
> > >>
> > >> ---
> > >>   arch/x86/kvm/x86.c | 41 +++++++++++++++++++++++++++++++++++++++++
> > >>   1 file changed, 41 insertions(+)
> > >>
> > >> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > >> index 93b0bd45ac73..ecaaa411538f 100644
> > >> --- a/arch/x86/kvm/x86.c
> > >> +++ b/arch/x86/kvm/x86.c
> > >> @@ -1140,6 +1140,42 @@ static u32 msrs_to_save[] = {
> > >>          MSR_IA32_RTIT_ADDR1_A, MSR_IA32_RTIT_ADDR1_B,
> > >>          MSR_IA32_RTIT_ADDR2_A, MSR_IA32_RTIT_ADDR2_B,
> > >>          MSR_IA32_RTIT_ADDR3_A, MSR_IA32_RTIT_ADDR3_B,
> > >> +       MSR_ARCH_PERFMON_FIXED_CTR0, MSR_ARCH_PERFMON_FIXED_CTR1,
> > >> +       MSR_ARCH_PERFMON_FIXED_CTR0 + 2, MSR_ARCH_PERFMON_FIXED_CTR0 + 3,
> > >> +       MSR_CORE_PERF_FIXED_CTR_CTRL, MSR_CORE_PERF_GLOBAL_STATUS,
> > >> +       MSR_CORE_PERF_GLOBAL_CTRL, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
> > >> +       MSR_ARCH_PERFMON_PERFCTR0, MSR_ARCH_PERFMON_PERFCTR1,
> > >> +       MSR_ARCH_PERFMON_PERFCTR0 + 2, MSR_ARCH_PERFMON_PERFCTR0 + 3,
> > >> +       MSR_ARCH_PERFMON_PERFCTR0 + 4, MSR_ARCH_PERFMON_PERFCTR0 + 5,
> > >> +       MSR_ARCH_PERFMON_PERFCTR0 + 6, MSR_ARCH_PERFMON_PERFCTR0 + 7,
> > >> +       MSR_ARCH_PERFMON_PERFCTR0 + 8, MSR_ARCH_PERFMON_PERFCTR0 + 9,
> > >> +       MSR_ARCH_PERFMON_PERFCTR0 + 10, MSR_ARCH_PERFMON_PERFCTR0 + 11,
> > >> +       MSR_ARCH_PERFMON_PERFCTR0 + 12, MSR_ARCH_PERFMON_PERFCTR0 + 13,
> > >> +       MSR_ARCH_PERFMON_PERFCTR0 + 14, MSR_ARCH_PERFMON_PERFCTR0 + 15,
> > >> +       MSR_ARCH_PERFMON_PERFCTR0 + 16, MSR_ARCH_PERFMON_PERFCTR0 + 17,
> > >> +       MSR_ARCH_PERFMON_PERFCTR0 + 18, MSR_ARCH_PERFMON_PERFCTR0 + 19,
> > >> +       MSR_ARCH_PERFMON_PERFCTR0 + 20, MSR_ARCH_PERFMON_PERFCTR0 + 21,
> > >> +       MSR_ARCH_PERFMON_PERFCTR0 + 22, MSR_ARCH_PERFMON_PERFCTR0 + 23,
> > >> +       MSR_ARCH_PERFMON_PERFCTR0 + 24, MSR_ARCH_PERFMON_PERFCTR0 + 25,
> > >> +       MSR_ARCH_PERFMON_PERFCTR0 + 26, MSR_ARCH_PERFMON_PERFCTR0 + 27,
> > >> +       MSR_ARCH_PERFMON_PERFCTR0 + 28, MSR_ARCH_PERFMON_PERFCTR0 + 29,
> > >> +       MSR_ARCH_PERFMON_PERFCTR0 + 30, MSR_ARCH_PERFMON_PERFCTR0 + 31,
> > >> +       MSR_ARCH_PERFMON_EVENTSEL0, MSR_ARCH_PERFMON_EVENTSEL1,
> > >> +       MSR_ARCH_PERFMON_EVENTSEL0 + 2, MSR_ARCH_PERFMON_EVENTSEL0 + 3,
> > >> +       MSR_ARCH_PERFMON_EVENTSEL0 + 4, MSR_ARCH_PERFMON_EVENTSEL0 + 5,
> > >> +       MSR_ARCH_PERFMON_EVENTSEL0 + 6, MSR_ARCH_PERFMON_EVENTSEL0 + 7,
> > >> +       MSR_ARCH_PERFMON_EVENTSEL0 + 8, MSR_ARCH_PERFMON_EVENTSEL0 + 9,
> > >> +       MSR_ARCH_PERFMON_EVENTSEL0 + 10, MSR_ARCH_PERFMON_EVENTSEL0 + 11,
> > >> +       MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 + 13,
> > >> +       MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
> > >> +       MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
> > >> +       MSR_ARCH_PERFMON_EVENTSEL0 + 18, MSR_ARCH_PERFMON_EVENTSEL0 + 19,
> > >> +       MSR_ARCH_PERFMON_EVENTSEL0 + 20, MSR_ARCH_PERFMON_EVENTSEL0 + 21,
> > >> +       MSR_ARCH_PERFMON_EVENTSEL0 + 22, MSR_ARCH_PERFMON_EVENTSEL0 + 23,
> > >> +       MSR_ARCH_PERFMON_EVENTSEL0 + 24, MSR_ARCH_PERFMON_EVENTSEL0 + 25,
> > >> +       MSR_ARCH_PERFMON_EVENTSEL0 + 26, MSR_ARCH_PERFMON_EVENTSEL0 + 27,
> > >> +       MSR_ARCH_PERFMON_EVENTSEL0 + 28, MSR_ARCH_PERFMON_EVENTSEL0 + 29,
> > >> +       MSR_ARCH_PERFMON_EVENTSEL0 + 30, MSR_ARCH_PERFMON_EVENTSEL0 + 31,
> > >>   };
> > >>
> > >>
> > >> Should we have separate #defines for the MSRs that are at offset from the base MSR?
> > > How about macros that take an offset argument, rather than a whole
> > > slew of new macros?
> >
> >
> > Yes, that works too.
> >
> >
> > >
> > >>   static unsigned num_msrs_to_save;
> > >> @@ -4989,6 +5025,11 @@ static void kvm_init_msr_list(void)
> > >>          u32 dummy[2];
> > >>          unsigned i, j;
> > >>
> > >> +       BUILD_BUG_ON_MSG(INTEL_PMC_MAX_FIXED != 4,
> > >> +                        "Please update the fixed PMCs in msrs_to_save[]");
> > >> +       BUILD_BUG_ON_MSG(INTEL_PMC_MAX_GENERIC != 32,
> > >> +                        "Please update the generic perfctr/eventsel MSRs in msrs_to_save[]");
> > >>
> > >>
> > >> Just curious how the condition can ever become false because we are comparing two static numbers here.
> > > Someone just has to change the macros. In fact, I originally developed
> > > this change on a version of the kernel where INTEL_PMC_MAX_FIXED was
> > > 3, and so I had:
> > >
> > >> +       BUILD_BUG_ON_MSG(INTEL_PMC_MAX_FIXED != 3,
> > >> +                        "Please update the fixed PMCs in msrs_to_save[]")
> > > When I cherry-picked the change to Linux tip, the BUILD_BUG_ON fired,
> > > and I updated the fixed PMCs in msrs_to_save[].
> > >
> > >> +
> > >>          for (i = j = 0; i < ARRAY_SIZE(msrs_to_save); i++) {
> > >>                  if (rdmsr_safe(msrs_to_save[i], &dummy[0], &dummy[1]) < 0)
> > >>                          continue;
> > >> --
> > >> 2.23.0.187.g17f5b7556c-goog
> > >>
> > >> Ping.
> > >>
> > >>
> > >> Also, since these MSRs are Intel-specific, should these be enumerated via 'intel_pmu_ops' ?
> > > msrs_to_save[] is filtered to remove MSRs that aren't supported on the
> > > host. Or are you asking something else?
> >
> >
> > I am referring to the fact that we are enumerating Intel-specific MSRs
> > in the generic KVM code. Should there be some sort of #define guard to
> > not compile the code on AMD ?
>
> No. msrs_to_save[] contains *all* MSRs that may be relevant on some
> platform. Notice that it already includes AMD-only MSRs (e.g.
> MSR_VM_HSAVE_PA) and Intel-only MSRs (e.g. MSR_IA32_BNDCFGS). The MSRs
> that are not relevant are filtered out in kvm_init_msr_list().
>
> This list probably should include the AMD equivalents as well, but I
> haven't looked into the AMD vPMU yet.

Ping.
