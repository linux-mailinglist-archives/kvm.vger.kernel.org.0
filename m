Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40859782820
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 13:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbjHULpU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 07:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjHULpU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 07:45:20 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D203DC;
        Mon, 21 Aug 2023 04:45:18 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id 4fb4d7f45d1cf-523bf06f7f8so3877598a12.1;
        Mon, 21 Aug 2023 04:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692618316; x=1693223116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BALywRkxD9F0CEbONXqG28uHu6lw1Ff8sK80X1DwiJM=;
        b=Pic3ST5DV3SWUyromxS57M56pR1jRJcEBC6QTrbk5SlRNim35s3w9P8Uwed1pPmE+y
         V6CtvNsrWFje4OVXZEUnWaJrNNQ0iGsxDdIkk7gqCz9AJAyXkne0JbrZpR/aHNR1ndao
         JIIMTvDeq1IIux8ZxLhUi/oCLP71aUR9XbmwU9puMmZB5NCscNJfZjdaYIfzs0h2f8LQ
         +ByHTM4x0MCkiWrbQ65mm6Q/psJyTrdwEc/3XS/11EF0PxTvkW915awqL502/aXiefTq
         LVDfFJLUIx+DNZC9Lp+j75IzLUzDAQpXiHbC5yH0/4YlatPIhubaxpO4nzBz7XaqRcTY
         hY3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692618316; x=1693223116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BALywRkxD9F0CEbONXqG28uHu6lw1Ff8sK80X1DwiJM=;
        b=gmgqz6mHa+761DrK7sPsTCF3ZEhP5tjD/jL5CAIef3f7Ptd5GLOIqDqHOkFXIdrdm7
         th4r8VLSBiX8Q858u9tFmMUwtxMA4AIyGhYwSva72iJSUXkCKOiV7nzvBixGSlLlg9jf
         SD7srF7lPEmzoV65qYjXt9FxaLM9/5qaI7nSA1zjmGXy3VqHULllKILvE37lkEynxUsE
         qBSwItVam+0J00SKWcUIfJiKd8MwXChIjeY0cATentUwSbzee2HG0V1sPZs9iHqT2HBm
         ady/aQ94vTegeDy4ZbE0Fs8n70dQIWQsD7aHhkJNFUgNavxhUPzMjv7K40MhsonJOz3u
         LQAA==
X-Gm-Message-State: AOJu0YwK/26a+x/BatsnJWb98Udap6LojK/rSzlchZN/aEsp8PMMLyOE
        OK7CVyASJqKEIogcJUVlyYrOW9rOQuNbYvGGTO0=
X-Google-Smtp-Source: AGHT+IH8zlxRY7nI7DYEwFxFGu2aewn0d3cfUZ54TTl4n+GaHg/hPKO8WmUJci3Fy5fi4dZkjI4WPxwR9ikjxtjkd3U=
X-Received: by 2002:aa7:cd11:0:b0:522:6e3f:b65 with SMTP id
 b17-20020aa7cd11000000b005226e3f0b65mr4444561edw.33.1692618316401; Mon, 21
 Aug 2023 04:45:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230814115108.45741-1-cloudliang@tencent.com>
 <20230814115108.45741-4-cloudliang@tencent.com> <ZN6lKvN2xvQOSnnz@google.com>
In-Reply-To: <ZN6lKvN2xvQOSnnz@google.com>
From:   Jinrong Liang <ljr.kernel@gmail.com>
Date:   Mon, 21 Aug 2023 19:45:05 +0800
Message-ID: <CAFg_LQXJqEZ=2cSA9n5nQV12kpy6LL_mZVO2MuBKq_YwGg4V2Q@mail.gmail.com>
Subject: Re: [PATCH v3 03/11] KVM: selftests: Test Intel PMU architectural
 events on gp counters
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> =E4=BA=8E2023=E5=B9=B48=E6=9C=8818=
=E6=97=A5=E5=91=A8=E4=BA=94 06:54=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, Aug 14, 2023, Jinrong Liang wrote:
> > Add test case for AMD Guest PerfMonV2. Also test Intel
> > MSR_CORE_PERF_GLOBAL_STATUS and MSR_CORE_PERF_GLOBAL_OVF_CTRL.
> >
> > Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> > ---
> >  .../kvm/x86_64/pmu_basic_functionality_test.c | 48 ++++++++++++++++++-
> >  1 file changed, 46 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality=
_test.c b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
> > index cb2a7ad5c504..02bd1fe3900b 100644
> > --- a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
> > +++ b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
> > @@ -58,7 +58,9 @@ static uint64_t run_vcpu(struct kvm_vcpu *vcpu, uint6=
4_t *ucall_arg)
> >
> >  static void guest_measure_loop(uint64_t event_code)
> >  {
> > +     uint64_t global_ovf_ctrl_msr, global_status_msr, global_ctrl_msr;
> >       uint8_t nr_gp_counters, pmu_version =3D 1;
> > +     uint8_t gp_counter_bit_width =3D 48;
> >       uint64_t event_sel_msr;
> >       uint32_t counter_msr;
> >       unsigned int i;
> > @@ -68,6 +70,12 @@ static void guest_measure_loop(uint64_t event_code)
> >               pmu_version =3D this_cpu_property(X86_PROPERTY_PMU_VERSIO=
N);
> >               event_sel_msr =3D MSR_P6_EVNTSEL0;
> >
> > +             if (pmu_version > 1) {
> > +                     global_ovf_ctrl_msr =3D MSR_CORE_PERF_GLOBAL_OVF_=
CTRL;
> > +                     global_status_msr =3D MSR_CORE_PERF_GLOBAL_STATUS=
;
> > +                     global_ctrl_msr =3D MSR_CORE_PERF_GLOBAL_CTRL;
> > +             }
> > +
> >               if (rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES=
)
> >                       counter_msr =3D MSR_IA32_PMC0;
> >               else
> > @@ -76,6 +84,17 @@ static void guest_measure_loop(uint64_t event_code)
> >               nr_gp_counters =3D AMD64_NR_COUNTERS;
> >               event_sel_msr =3D MSR_K7_EVNTSEL0;
> >               counter_msr =3D MSR_K7_PERFCTR0;
> > +
> > +             if (this_cpu_has(X86_FEATURE_AMD_PMU_EXT_CORE) &&
> > +                 this_cpu_has(X86_FEATURE_AMD_PERFMON_V2)) {
> > +                     nr_gp_counters =3D this_cpu_property(X86_PROPERTY=
_AMD_PMU_NR_CORE_COUNTERS);
> > +                     global_ovf_ctrl_msr =3D MSR_AMD64_PERF_CNTR_GLOBA=
L_STATUS_CLR;
> > +                     global_status_msr =3D MSR_AMD64_PERF_CNTR_GLOBAL_=
STATUS;
> > +                     global_ctrl_msr =3D MSR_AMD64_PERF_CNTR_GLOBAL_CT=
L;
> > +                     event_sel_msr =3D MSR_F15H_PERF_CTL0;
> > +                     counter_msr =3D MSR_F15H_PERF_CTR0;
> > +                     pmu_version =3D 2;
> > +             }
>
> Please use an if-else when the two things are completely exclusive, i.e. =
don't
> set "defaults" and then override them.
>
> >       }
> >
> >       for (i =3D 0; i < nr_gp_counters; i++) {
> > @@ -84,14 +103,39 @@ static void guest_measure_loop(uint64_t event_code=
)
> >                     ARCH_PERFMON_EVENTSEL_ENABLE | event_code);
> >
> >               if (pmu_version > 1) {
> > -                     wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, BIT_ULL(i));
> > +                     wrmsr(global_ctrl_msr, BIT_ULL(i));
> >                       __asm__ __volatile__("loop ." : "+c"((int){NUM_BR=
ANCHES}));
> > -                     wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
> > +                     wrmsr(global_ctrl_msr, 0);
> >                       GUEST_SYNC(_rdpmc(i));
> >               } else {
> >                       __asm__ __volatile__("loop ." : "+c"((int){NUM_BR=
ANCHES}));
> >                       GUEST_SYNC(_rdpmc(i));
> >               }
>
> This is extremely difficult to follow.  I think the same thing to do is t=
o split
> this up into helpers, e.g. send pmu_version > 1 into one path, and pmu_ve=
rsion <=3D 1
> into an entirely different path.
>
> E.g. something like this?

I agree with all the proposed code changes you have provided. Your
comments have been incredibly helpful in making the necessary
improvements to the code. I will diligently follow your suggestions
and modify the code accordingly.

>
> static void guest_measure_loop(uint64_t event_code)
> {
>         uint64_t global_ovf_ctrl_msr, global_status_msr, global_ctrl_msr;
>         uint8_t nr_gp_counters, pmu_version;
>         uint8_t gp_counter_bit_width;
>         uint64_t event_sel_msr;
>         uint32_t counter_msr;
>         unsigned int i;
>
>         if (host_cpu_is_intel)
>                 pmu_version =3D this_cpu_property(X86_PROPERTY_PMU_VERSIO=
N);
>         else if (this_cpu_has(X86_FEATURE_PERFCTR_CORE) &&
>                  this_cpu_has(X86_FEATURE_PERFMON_V2)) {
>                 pmu_version =3D 2;
>         } else {
>                 pmu_version =3D 1;
>         }
>
>         if (pmu_version <=3D 1) {
>                 guest_measure_pmu_legacy(...);
>                 return;
>         }
>
>         if (host_cpu_is_intel) {
>                 nr_gp_counters =3D this_cpu_property(X86_PROPERTY_PMU_NR_=
GP_COUNTERS);
>                 global_ovf_ctrl_msr =3D MSR_CORE_PERF_GLOBAL_OVF_CTRL;
>                 global_status_msr =3D MSR_CORE_PERF_GLOBAL_STATUS;
>                 global_ctrl_msr =3D MSR_CORE_PERF_GLOBAL_CTRL;
>                 gp_counter_bit_width =3D this_cpu_property(X86_PROPERTY_P=
MU_GP_COUNTERS_BIT_WIDTH);
>
>                 if (rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES=
)
>                         counter_msr =3D MSR_IA32_PMC0;
>                 else
>                         counter_msr =3D MSR_IA32_PERFCTR0;
>         } else {
>                 nr_gp_counters =3D this_cpu_property(X86_PROPERTY_AMD_PMU=
_NR_CORE_COUNTERS);
>                 global_ovf_ctrl_msr =3D MSR_AMD64_PERF_CNTR_GLOBAL_STATUS=
_CLR;
>                 global_status_msr =3D MSR_AMD64_PERF_CNTR_GLOBAL_STATUS;
>                 global_ctrl_msr =3D MSR_AMD64_PERF_CNTR_GLOBAL_CTL;
>                 event_sel_msr =3D MSR_F15H_PERF_CTL0;
>                 counter_msr =3D MSR_F15H_PERF_CTR0;
>                 gp_counter_bit_width =3D 48;
>         }
>
>         for (i =3D 0; i < nr_gp_counters; i++) {
>                 wrmsr(counter_msr + i, 0);
>                 wrmsr(event_sel_msr + i, ARCH_PERFMON_EVENTSEL_OS |
>                       ARCH_PERFMON_EVENTSEL_ENABLE | event_code);
>
>                 wrmsr(global_ctrl_msr, BIT_ULL(i));
>                 __asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES})=
);
>                 wrmsr(global_ctrl_msr, 0);
>                 counter =3D _rdpmc(i);
>                 GUEST_ASSERT_EQ(this_pmu_has(...), !!counter);
>
>                 if ( _rdpmc(i)) {
>                         wrmsr(global_ctrl_msr, 0);
>                         wrmsr(counter_msr + i, 0);
>                         __asm__ __volatile__("loop ." : "+c"((int){NUM_BR=
ANCHES}));
>                         GUEST_ASSERT(!_rdpmc(i));
>
>                         wrmsr(global_ctrl_msr, BIT_ULL(i));
>                         __asm__ __volatile__("loop ." : "+c"((int){NUM_BR=
ANCHES}));
>                         GUEST_ASSERT(_rdpmc(i));
>
>                         wrmsr(global_ctrl_msr, 0);
>                         wrmsr(counter_msr + i, (1ULL << gp_counter_bit_wi=
dth) - 2);
>                         wrmsr(global_ctrl_msr, BIT_ULL(i));
>                         __asm__ __volatile__("loop ." : "+c"((int){NUM_BR=
ANCHES}));
>                         GUEST_ASSERT(rdmsr(global_status_msr) & BIT_ULL(i=
));
>
>                         wrmsr(global_ctrl_msr, 0);
>                         wrmsr(global_ovf_ctrl_msr, BIT_ULL(i));
>                         GUEST_ASSERT(!(rdmsr(global_status_msr) & BIT_ULL=
(i)));
>                 }
>         }
>

I truly appreciate your time and effort in reviewing the code and
providing such valuable feedback. Please feel free to share any
further suggestions or ideas in the future.
