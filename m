Return-Path: <kvm+bounces-3667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 921B98068CF
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 08:42:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B389E1C21263
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 07:42:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8EC718034;
	Wed,  6 Dec 2023 07:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="1XGazvn4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171B5D69
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 23:41:44 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-50be3611794so5340160e87.0
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 23:41:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1701848502; x=1702453302; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rtN1uyl8b2v4ofgZEiUI+89WGtZCbM176XwHrBJP/e8=;
        b=1XGazvn43ynB3m2ov/K65KEI+CUXNGiCMNpJEfQ+hZqG5KIzULglMl/qLxkPPr3ot3
         QhKVMYu/zjiG2p9oAp7vZArvyTJmmHCaoQnSQmdgvXSNyheW1AXfjgOT+5YTdYXuRWUo
         awIFyQMcY7yuTuG6wb4YCFNenOsLt4Cz7KF8a8Tm6iVK/XJMgQmjVknTD/PLfMxNANxM
         /Cuz1ogTeJKQzbctZH2WXUZkBvhXAZSjE3bHtiJVw3udjnjSRfW7olSp1bWoNZwYoQRz
         LyQ+K+lBLPsmBimYoViCFougJbI8LkJtWx0xVrhxcWM2oLCMfnTRScQJKRX7Jv+m6A+N
         l+dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701848502; x=1702453302;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rtN1uyl8b2v4ofgZEiUI+89WGtZCbM176XwHrBJP/e8=;
        b=mos4UTNQPB1EmuQ+6QY3G3JRJiS755i6AIm6tGRa5HDR8xmQrw70a2g+0UmoJQmkdF
         iuDXizBBoW2l+cdHBqzyJHNQrTEqJ0c8L6mm9CGYXeV6PBEfOjw5oAoFEayYz/WF8S0j
         976cItYDuIAEPo9tAWtQB/dCbx0S1wK+Qv5Uk1cuLP6xi7abcnUBWIE96qNU2ron03j5
         QJC8TonxtUK34eMWtX1R0DKheNKewoCMp6GaNv3JfHhvjlVikhOtCiZ9HVVSHkC1kp9P
         GOyPHcAKo9N4idA4HxbxjOmuodGa/ZjMM0nlYNQT7V9A4YsQO8MUCWxU7KjcMu5h57jz
         KExg==
X-Gm-Message-State: AOJu0Yy5dIRQdAYh9pPoq/s/ODDMBqvaGo+aabg63JsN455HHXvDt0Ti
	aZn54IOklAy+4OWLrvMrD0lNyAcKhlaWywfiE7e50A==
X-Google-Smtp-Source: AGHT+IF7o3mCG4z2QxH04Zq0hX1YHdLyO6PYoEATB/HBbkOz2PdqZxBXDLT9fAqBECnDdvQBYsxB2bJjA0QoODazhPk=
X-Received: by 2002:a05:6512:4014:b0:50b:f816:f403 with SMTP id
 br20-20020a056512401400b0050bf816f403mr364962lfb.53.1701848502136; Tue, 05
 Dec 2023 23:41:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231205024310.1593100-1-atishp@rivosinc.com> <20231205024310.1593100-9-atishp@rivosinc.com>
 <a790c2f7-2952-4268-92c5-f293f6fbaa38@syntacore.com>
In-Reply-To: <a790c2f7-2952-4268-92c5-f293f6fbaa38@syntacore.com>
From: Atish Kumar Patra <atishp@rivosinc.com>
Date: Tue, 5 Dec 2023 23:41:31 -0800
Message-ID: <CAHBxVyE-eeDYhc3jmiXPhcM0crrrSmxm3=pcRyw=c0p5vjD6xw@mail.gmail.com>
Subject: Re: [RFC 8/9] RISC-V: KVM: Add perf sampling support for guests
To: Vladimir Isaev <vladimir.isaev@syntacore.com>
Cc: linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, kvm@vger.kernel.org, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Conor Dooley <conor.dooley@microchip.com>, Guo Ren <guoren@kernel.org>, 
	kvm-riscv@lists.infradead.org, Atish Patra <atishp@atishpatra.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, linux-riscv@lists.infradead.org, 
	Will Deacon <will@kernel.org>, Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 5, 2023 at 10:43=E2=80=AFPM Vladimir Isaev
<vladimir.isaev@syntacore.com> wrote:
>
> 05.12.2023 05:43, Atish Patra wrote:
> >
> > KVM enables perf for guest via counter virtualization. However, the
> > sampling can not be supported as there is no mechanism to enabled
> > trap/emulate scountovf in ISA yet. Rely on the SBI PMU snapshot
> > to provide the counter overflow data via the shared memory.
> >
> > In case of sampling event, the host first guest the LCOFI interrupt
> > and injects to the guest via irq filtering mechanism defined in AIA
> > specification. Thus, ssaia must be enabled in the host in order to
> > use perf sampling in the guest. No other AIA dpeendancy w.r.t kernel
> > is required.
>
> I don't understand why do we need HVIEN and AIA, why HIDELEG can't be use=
d for this puprpose?
>

If it is enabled in HIDELEG, the guest gets the interrupt directly. As
the counters are virtualized, the host needs to get
the interrupt and inject it to the guest by setting the hvip bit.

> >
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> >  arch/riscv/include/asm/csr.h      |  3 +-
> >  arch/riscv/include/uapi/asm/kvm.h |  1 +
> >  arch/riscv/kvm/main.c             |  1 +
> >  arch/riscv/kvm/vcpu.c             |  8 ++--
> >  arch/riscv/kvm/vcpu_onereg.c      |  1 +
> >  arch/riscv/kvm/vcpu_pmu.c         | 69 ++++++++++++++++++++++++++++---
> >  6 files changed, 73 insertions(+), 10 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.=
h
> > index 88cdc8a3e654..bec09b33e2f0 100644
> > --- a/arch/riscv/include/asm/csr.h
> > +++ b/arch/riscv/include/asm/csr.h
> > @@ -168,7 +168,8 @@
> >  #define VSIP_TO_HVIP_SHIFT     (IRQ_VS_SOFT - IRQ_S_SOFT)
> >  #define VSIP_VALID_MASK                ((_AC(1, UL) << IRQ_S_SOFT) | \
> >                                  (_AC(1, UL) << IRQ_S_TIMER) | \
> > -                                (_AC(1, UL) << IRQ_S_EXT))
> > +                                (_AC(1, UL) << IRQ_S_EXT) | \
> > +                                (_AC(1, UL) << IRQ_PMU_OVF))
> >
> >  /* AIA CSR bits */
> >  #define TOPI_IID_SHIFT         16
> > diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uap=
i/asm/kvm.h
> > index 60d3b21dead7..741c16f4518e 100644
> > --- a/arch/riscv/include/uapi/asm/kvm.h
> > +++ b/arch/riscv/include/uapi/asm/kvm.h
> > @@ -139,6 +139,7 @@ enum KVM_RISCV_ISA_EXT_ID {
> >         KVM_RISCV_ISA_EXT_ZIHPM,
> >         KVM_RISCV_ISA_EXT_SMSTATEEN,
> >         KVM_RISCV_ISA_EXT_ZICOND,
> > +       KVM_RISCV_ISA_EXT_SSCOFPMF,
> >         KVM_RISCV_ISA_EXT_MAX,
> >  };
> >
> > diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> > index 225a435d9c9a..5a3a4cee0e3d 100644
> > --- a/arch/riscv/kvm/main.c
> > +++ b/arch/riscv/kvm/main.c
> > @@ -43,6 +43,7 @@ int kvm_arch_hardware_enable(void)
> >         csr_write(CSR_HCOUNTEREN, 0x02);
> >
> >         csr_write(CSR_HVIP, 0);
> > +       csr_write(CSR_HVIEN, 1UL << IRQ_PMU_OVF);
>
> Is my understanding correct that this will break KVM for non-AIA CPUs?
>
> As I can remember HVIEN depends on AIA.
>

Yes. It was supposed to be inside kvm_riscv_aia_enable. My bad.
I will fix it and send it v2.

We also should advertise sscofpmf to the guest only if ssaia is available
in the host. I will work on that too.

> >
> >         kvm_riscv_aia_enable();
> >
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > index e087c809073c..2d9f252356c3 100644
> > --- a/arch/riscv/kvm/vcpu.c
> > +++ b/arch/riscv/kvm/vcpu.c
> > @@ -380,7 +380,8 @@ int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *v=
cpu, unsigned int irq)
> >         if (irq < IRQ_LOCAL_MAX &&
> >             irq !=3D IRQ_VS_SOFT &&
> >             irq !=3D IRQ_VS_TIMER &&
> > -           irq !=3D IRQ_VS_EXT)
> > +           irq !=3D IRQ_VS_EXT &&
> > +           irq !=3D IRQ_PMU_OVF)
> >                 return -EINVAL;
> >
> >         set_bit(irq, vcpu->arch.irqs_pending);
> > @@ -395,14 +396,15 @@ int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu =
*vcpu, unsigned int irq)
> >  int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int=
 irq)
> >  {
> >         /*
> > -        * We only allow VS-mode software, timer, and external
> > +        * We only allow VS-mode software, timer, counter overflow and =
external
> >          * interrupts when irq is one of the local interrupts
> >          * defined by RISC-V privilege specification.
> >          */
> >         if (irq < IRQ_LOCAL_MAX &&
> >             irq !=3D IRQ_VS_SOFT &&
> >             irq !=3D IRQ_VS_TIMER &&
> > -           irq !=3D IRQ_VS_EXT)
> > +           irq !=3D IRQ_VS_EXT &&
> > +           irq !=3D IRQ_PMU_OVF)
> >                 return -EINVAL;
> >
> >         clear_bit(irq, vcpu->arch.irqs_pending);
> > diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.=
c
> > index f8c9fa0c03c5..19a0e4eaf0df 100644
> > --- a/arch/riscv/kvm/vcpu_onereg.c
> > +++ b/arch/riscv/kvm/vcpu_onereg.c
> > @@ -36,6 +36,7 @@ static const unsigned long kvm_isa_ext_arr[] =3D {
> >         /* Multi letter extensions (alphabetically sorted) */
> >         KVM_ISA_EXT_ARR(SMSTATEEN),
> >         KVM_ISA_EXT_ARR(SSAIA),
> > +       KVM_ISA_EXT_ARR(SSCOFPMF),
> >         KVM_ISA_EXT_ARR(SSTC),
> >         KVM_ISA_EXT_ARR(SVINVAL),
> >         KVM_ISA_EXT_ARR(SVNAPOT),
> > diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> > index 622c4ee89e7b..86c8e92f92d3 100644
> > --- a/arch/riscv/kvm/vcpu_pmu.c
> > +++ b/arch/riscv/kvm/vcpu_pmu.c
> > @@ -229,6 +229,47 @@ static int kvm_pmu_validate_counter_mask(struct kv=
m_pmu *kvpmu, unsigned long ct
> >         return 0;
> >  }
> >
> > +static void kvm_riscv_pmu_overflow(struct perf_event *perf_event,
> > +                                 struct perf_sample_data *data,
> > +                                 struct pt_regs *regs)
> > +{
> > +       struct kvm_pmc *pmc =3D perf_event->overflow_handler_context;
> > +       struct kvm_vcpu *vcpu =3D pmc->vcpu;
> > +       struct kvm_pmu *kvpmu =3D vcpu_to_pmu(vcpu);
> > +       struct riscv_pmu *rpmu =3D to_riscv_pmu(perf_event->pmu);
> > +       u64 period;
> > +
> > +       /*
> > +        * Stop the event counting by directly accessing the perf_event=
.
> > +        * Otherwise, this needs to deferred via a workqueue.
> > +        * That will introduce skew in the counter value because the ac=
tual
> > +        * physical counter would start after returning from this funct=
ion.
> > +        * It will be stopped again once the workqueue is scheduled
> > +        */
> > +       rpmu->pmu.stop(perf_event, PERF_EF_UPDATE);
> > +
> > +       /*
> > +        * The hw counter would start automatically when this function =
returns.
> > +        * Thus, the host may continue to interrupts and inject it to t=
he guest
> > +        * even without guest configuring the next event. Depending on =
the hardware
> > +        * the host may some sluggishness only if privilege mode filter=
ing is not
> > +        * available. In an ideal world, where qemu is not the only cap=
able hardware,
> > +        * this can be removed.
> > +        * FYI: ARM64 does this way while x86 doesn't do anything as su=
ch.
> > +        * TODO: Should we keep it for RISC-V ?
> > +        */
> > +       period =3D -(local64_read(&perf_event->count));
> > +
> > +       local64_set(&perf_event->hw.period_left, 0);
> > +       perf_event->attr.sample_period =3D period;
> > +       perf_event->hw.sample_period =3D period;
> > +
> > +       set_bit(pmc->idx, kvpmu->pmc_overflown);
> > +       kvm_riscv_vcpu_set_interrupt(vcpu, IRQ_PMU_OVF);
> > +
> > +       rpmu->pmu.start(perf_event, PERF_EF_RELOAD);
> > +}
> > +
> >  static int kvm_pmu_create_perf_event(struct kvm_pmc *pmc, struct perf_=
event_attr *attr,
> >                                      unsigned long flags, unsigned long=
 eidx, unsigned long evtdata)
> >  {
> > @@ -247,7 +288,7 @@ static int kvm_pmu_create_perf_event(struct kvm_pmc=
 *pmc, struct perf_event_attr
> >          */
> >         attr->sample_period =3D kvm_pmu_get_sample_period(pmc);
> >
> > -       event =3D perf_event_create_kernel_counter(attr, -1, current, N=
ULL, pmc);
> > +       event =3D perf_event_create_kernel_counter(attr, -1, current, k=
vm_riscv_pmu_overflow, pmc);
> >         if (IS_ERR(event)) {
> >                 pr_err("kvm pmu event creation failed for eidx %lx: %ld=
\n", eidx, PTR_ERR(event));
> >                 return PTR_ERR(event);
> > @@ -466,6 +507,12 @@ int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *=
vcpu, unsigned long ctr_base,
> >                 }
> >         }
> >
> > +       /* The guest have serviced the interrupt and starting the count=
er again */
> > +       if (test_bit(IRQ_PMU_OVF, vcpu->arch.irqs_pending)) {
> > +               clear_bit(pmc_index, kvpmu->pmc_overflown);
> > +               kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_PMU_OVF);
> > +       }
> > +
> >  out:
> >         retdata->err_val =3D sbiret;
> >
> > @@ -537,7 +584,12 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *v=
cpu, unsigned long ctr_base,
> >                 }
> >
> >                 if (bSnapshot && !sbiret) {
> > -                       //TODO: Add counter overflow support when sscof=
pmf support is added
> > +                       /* The counter and overflow indicies in the sna=
pshot region are w.r.to
> > +                        * cbase. Modify the set bit in the counter mas=
k instead of the pmc_index
> > +                        * which indicates the absolute counter index.
> > +                        */
> > +                       if (test_bit(pmc_index, kvpmu->pmc_overflown))
> > +                               kvpmu->sdata->ctr_overflow_mask |=3D (1=
UL << i);
> >                         kvpmu->sdata->ctr_values[i] =3D pmc->counter_va=
l;
> >                         kvm_vcpu_write_guest(vcpu, kvpmu->snapshot_addr=
, kvpmu->sdata,
> >                                              sizeof(struct riscv_pmu_sn=
apshot_data));
> > @@ -546,15 +598,19 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *=
vcpu, unsigned long ctr_base,
> >                 if (flags & SBI_PMU_STOP_FLAG_RESET) {
> >                         pmc->event_idx =3D SBI_PMU_EVENT_IDX_INVALID;
> >                         clear_bit(pmc_index, kvpmu->pmc_in_use);
> > +                       clear_bit(pmc_index, kvpmu->pmc_overflown);
> >                         if (bSnapshot) {
> >                                 /* Clear the snapshot area for the upco=
ming deletion event */
> >                                 kvpmu->sdata->ctr_values[i] =3D 0;
> > +                               /* Only clear the given counter as the =
caller is responsible to
> > +                                * validate both the overflow mask and =
configured counters.
> > +                                */
> > +                               kvpmu->sdata->ctr_overflow_mask &=3D ~(=
1UL << i);
> >                                 kvm_vcpu_write_guest(vcpu, kvpmu->snaps=
hot_addr, kvpmu->sdata,
> >                                                      sizeof(struct risc=
v_pmu_snapshot_data));
> >                         }
> >                 }
> >         }
> > -
> >  out:
> >         retdata->err_val =3D sbiret;
> >
> > @@ -729,15 +785,16 @@ void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *v=
cpu)
> >         if (!kvpmu)
> >                 return;
> >
> > -       for_each_set_bit(i, kvpmu->pmc_in_use, RISCV_MAX_COUNTERS) {
> > +       for_each_set_bit(i, kvpmu->pmc_in_use, RISCV_KVM_MAX_COUNTERS) =
{
> >                 pmc =3D &kvpmu->pmc[i];
> >                 pmc->counter_val =3D 0;
> >                 kvm_pmu_release_perf_event(pmc);
> >                 pmc->event_idx =3D SBI_PMU_EVENT_IDX_INVALID;
> >         }
> > -       bitmap_zero(kvpmu->pmc_in_use, RISCV_MAX_COUNTERS);
> > +       bitmap_zero(kvpmu->pmc_in_use, RISCV_KVM_MAX_COUNTERS);
> > +       bitmap_zero(kvpmu->pmc_overflown, RISCV_KVM_MAX_COUNTERS);
> >         memset(&kvpmu->fw_event, 0, SBI_PMU_FW_MAX * sizeof(struct kvm_=
fw_event));
> > -       kvpmu->snapshot_addr =3D INVALID_GPA;
> > +       kvm_pmu_clear_snapshot_area(vcpu);
> >  }
> >
> >  void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu)
> > --
> > 2.34.1
> >
> >
> > _______________________________________________
> > linux-riscv mailing list
> > linux-riscv@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-riscv
>
> Thank you,
> Vladimir Isaev

