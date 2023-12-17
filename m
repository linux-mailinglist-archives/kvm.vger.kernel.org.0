Return-Path: <kvm+bounces-4644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0760F815D19
	for <lists+kvm@lfdr.de>; Sun, 17 Dec 2023 02:49:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CB831C213F3
	for <lists+kvm@lfdr.de>; Sun, 17 Dec 2023 01:49:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DD2EED0;
	Sun, 17 Dec 2023 01:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Yr+6Iyis"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBFCA35
	for <kvm@vger.kernel.org>; Sun, 17 Dec 2023 01:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-50e34a72660so151988e87.1
        for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 17:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1702777750; x=1703382550; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a4HpPvrAQcAov+UKzHz5bRRuMIZd7b5qHfmtYd8R7NM=;
        b=Yr+6Iyisg4c4fvqqe9IuKbuZzmsu9nMyyj9oJe9byuoPJ08t6q6/sQ9MfidBefIpvL
         xXhapcChm/F9Gcz04uKj0Z3uLHGxS4IyXZsI62WEQDboEv+9i9xVx7U/UvzKJ8DaHqeH
         UEWhv8p5xWieKSo8iBye+UgputpktCWsWk9ycEduvKX+7/pixI5MIpXlN4tp2X1e/zNO
         Uc1FwWZ5IsPkXE4N0OyZS4lpC9Pjrnn9cvu/83+KH4cmQgwsgukpCKC0LdTcD7Ziz7zh
         w4whJnVGh7WFg3FZCILNWpvui2dEJ7qcT+b0nK8fpOHMLx6GX3Q+3iVBgBTmMZ6rX63D
         EknA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702777750; x=1703382550;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a4HpPvrAQcAov+UKzHz5bRRuMIZd7b5qHfmtYd8R7NM=;
        b=dSJR9jay43k6P6lsJjX2mD3aLGGqykFqyqhB4kGki/WYxZ3O/r4zpcwD5BBsd5Em1z
         YAfc+ieHfjV+PSqc51WUxoFJjhgEZXW/Sy0jj6rFNf+CncRYOBCiOSGax5xOauJ4BW2I
         OM+gCluAvF4BTXMRhXlwfBxdONQbtWklw7EgttYPDt7vSVnTc91VX/tPDHT1XJFpE2Ds
         jZDU9V7haNubXGV0Je96MIBA0NK25hhbgyr+0eHcO3c5loMW3xFw4L7KN3wbjpseC4BI
         tXea014Qifx/wxKKNpZs2QZ8t3FT11Kj2yEGPcKPIZU9O94/D6olZ/PMcHruEBGRYiN3
         RWVw==
X-Gm-Message-State: AOJu0Yz3tIHk3wuOdkY3P34t+2giYArzRcXP/I2vLiXGEv9+W/lbdaJs
	Z96/v2wM+F4Z5aeSrUzWFP3liWEQLRUtG4IdmK2Vng==
X-Google-Smtp-Source: AGHT+IFoXFganvC6DWAzAaUd1m+h42jphsfH5eJVXVke+eJqG6IskZOS1eB3Hn0j39RBlA1JrjvlnpMYVK61XN2qH14=
X-Received: by 2002:a05:6512:3713:b0:50e:368f:1f5f with SMTP id
 z19-20020a056512371300b0050e368f1f5fmr3435lfr.75.1702777750458; Sat, 16 Dec
 2023 17:49:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231205024310.1593100-1-atishp@rivosinc.com> <20231205024310.1593100-9-atishp@rivosinc.com>
 <CAAhSdy3SL4HhXkQ4BVNLgNodfRVGCHb8xxJ7YTs-ANJH5kgXPA@mail.gmail.com>
In-Reply-To: <CAAhSdy3SL4HhXkQ4BVNLgNodfRVGCHb8xxJ7YTs-ANJH5kgXPA@mail.gmail.com>
From: Atish Kumar Patra <atishp@rivosinc.com>
Date: Sat, 16 Dec 2023 17:48:59 -0800
Message-ID: <CAHBxVyHAwzckxGnjLmaSMO3LGirayjm5jnKoU3PU8j0LzQkr=Q@mail.gmail.com>
Subject: Re: [RFC 8/9] RISC-V: KVM: Add perf sampling support for guests
To: Anup Patel <anup@brainfault.org>
Cc: linux-kernel@vger.kernel.org, Alexandre Ghiti <alexghiti@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@atishpatra.org>, 
	Conor Dooley <conor.dooley@microchip.com>, Guo Ren <guoren@kernel.org>, 
	Icenowy Zheng <uwu@icenowy.me>, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 14, 2023 at 8:02=E2=80=AFAM Anup Patel <anup@brainfault.org> wr=
ote:
>
> On Tue, Dec 5, 2023 at 8:13=E2=80=AFAM Atish Patra <atishp@rivosinc.com> =
wrote:
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
>
> s/dpeendancy/dependency/
>

Fixed.

> > is required.
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
>
> Sscofpmf can't be disabled for guest so we should add it to
> kvm_riscv_vcpu_isa_disable_allowed(), no ?
>

Just to clarify it can't be disabled from the kvm user space via one
reg interface if kvm already exposes
it to the guest. However, Kvm will not expose Sscofpmf to the guest if
Ssaia is not available.
I have added these fixes in the next version.

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
>
> Ahh, the "vcpu" field is used here. Move that change from
> patch7 to this patch.
>

done.

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
>
> Use a double winged comment block here.
>
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
>
> Use a double winged comment block here.
>

Fixed all the comment styling.

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
>
> Regards,
> Anup

