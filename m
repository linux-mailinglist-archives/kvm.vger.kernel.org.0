Return-Path: <kvm+bounces-5338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D09A18203FE
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 09:10:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 835EBB21543
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 08:10:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0B593C3D;
	Sat, 30 Dec 2023 08:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="R4gU3vwk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8261023AF
	for <kvm@vger.kernel.org>; Sat, 30 Dec 2023 08:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-35fc1a1b52bso28857975ab.2
        for <kvm@vger.kernel.org>; Sat, 30 Dec 2023 00:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1703923790; x=1704528590; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eW4MUPtM/IW83DLuNI4skokRvtq7HqEqp2priU9d8AU=;
        b=R4gU3vwkVOBn7ZP/TPsxvjE8N0eHfKFOmRKwHxxKVzwILVNZ9xxDYEATvaIeQIX8bc
         VwBtFw8jkAUl80GGGFRLy0wGd+wGfI21TlfZ4MvyXnMpSYPu+bd3uJxNE752eJoX6Fxe
         d0/xuBLlOToSw51lAur0y42cGlomUrV8uNF61S3IJ9ubRj/tDhXDpKioofUykVg/i0pq
         8LhiPT8qzYrlMGN5710E/9PgPEnDRLmSqEMDN5G3vUHAlN/tw2JDY/sQ+FYhIUnieNb8
         Oe7K9Q0YKnx8vOQgApY2StupQaGXzOToQu14PPgoOt8CdVu8XJ05PI37ZrM8mD5tFPsY
         02KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703923790; x=1704528590;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eW4MUPtM/IW83DLuNI4skokRvtq7HqEqp2priU9d8AU=;
        b=U+MpBOE02xGvDMEuRbNqTRQBF50mkVve7odVFAy7dokQkMSj5r93SpgBG53ikomvwq
         lOBprX2wQ8Hoh5wQxkflBk++WN/40yvLmg3YbRt1AiwgtEZny+ttqJTooi/adzfgVS1T
         NwaWRpFJY7rSrSCWrID1kkwvGzBOXI25dUJMhenGh63d11qli734fGXerZ0STaQCXOWR
         tHwn2cPqsd1dkO7mK1AcuTOUK/0JSXbyh/KPH7mZPBs3H3txjS0EeDeIBBZaxfHCJSV9
         2JEQHK+xzsBNTKh/CoPnCOrb7u0ekSfgXZIHEuGd5mhgAOnaOlGmhZt5Thyy72RmlnnN
         B9WQ==
X-Gm-Message-State: AOJu0Yx/20kRyQvPaQ6hUU7HyOP7EBkNPZNlbJUCqmuJVKbQxgV8TeRs
	F1GOEiPzYo2WzAxMlboiYHFJVh0/Vt0vUs5pp5BzfVrciqddzA==
X-Google-Smtp-Source: AGHT+IFEHHlb6myRSSy/Goan2g5uelE2Sdnj+XB3ZBZ7l4tYTYr4vsKb/4oh2O+VOom6Y3jSAi9JAdm/gEzUlGDMVsk=
X-Received: by 2002:a05:6e02:1e04:b0:35f:a46f:f40a with SMTP id
 g4-20020a056e021e0400b0035fa46ff40amr15874323ila.11.1703923790414; Sat, 30
 Dec 2023 00:09:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231229214950.4061381-1-atishp@rivosinc.com> <20231229214950.4061381-10-atishp@rivosinc.com>
In-Reply-To: <20231229214950.4061381-10-atishp@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Sat, 30 Dec 2023 13:39:40 +0530
Message-ID: <CAAhSdy0qKTbq_F2m=g7+4bT2qK28bvtb1kqvrVUuiwNpFRZpZQ@mail.gmail.com>
Subject: Re: [v2 09/10] RISC-V: KVM: Add perf sampling support for guests
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Atish Patra <atishp@atishpatra.org>, Conor Dooley <conor.dooley@microchip.com>, 
	Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 30, 2023 at 3:20=E2=80=AFAM Atish Patra <atishp@rivosinc.com> w=
rote:
>
> KVM enables perf for guest via counter virtualization. However, the
> sampling can not be supported as there is no mechanism to enabled
> trap/emulate scountovf in ISA yet. Rely on the SBI PMU snapshot
> to provide the counter overflow data via the shared memory.
>
> In case of sampling event, the host first guest the LCOFI interrupt
> and injects to the guest via irq filtering mechanism defined in AIA
> specification. Thus, ssaia must be enabled in the host in order to
> use perf sampling in the guest. No other AIA dpeendancy w.r.t kernel
> is required.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/include/asm/csr.h          |  3 +-
>  arch/riscv/include/asm/kvm_vcpu_pmu.h |  1 +
>  arch/riscv/include/uapi/asm/kvm.h     |  1 +
>  arch/riscv/kvm/main.c                 |  1 +
>  arch/riscv/kvm/vcpu.c                 |  8 +--
>  arch/riscv/kvm/vcpu_onereg.c          |  2 +
>  arch/riscv/kvm/vcpu_pmu.c             | 70 +++++++++++++++++++++++++--
>  7 files changed, 77 insertions(+), 9 deletions(-)
>
> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
> index 88cdc8a3e654..bec09b33e2f0 100644
> --- a/arch/riscv/include/asm/csr.h
> +++ b/arch/riscv/include/asm/csr.h
> @@ -168,7 +168,8 @@
>  #define VSIP_TO_HVIP_SHIFT     (IRQ_VS_SOFT - IRQ_S_SOFT)
>  #define VSIP_VALID_MASK                ((_AC(1, UL) << IRQ_S_SOFT) | \
>                                  (_AC(1, UL) << IRQ_S_TIMER) | \
> -                                (_AC(1, UL) << IRQ_S_EXT))
> +                                (_AC(1, UL) << IRQ_S_EXT) | \
> +                                (_AC(1, UL) << IRQ_PMU_OVF))
>
>  /* AIA CSR bits */
>  #define TOPI_IID_SHIFT         16
> diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/a=
sm/kvm_vcpu_pmu.h
> index d56b901a61fc..af6d0ff5ce41 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> @@ -36,6 +36,7 @@ struct kvm_pmc {
>         bool started;
>         /* Monitoring event ID */
>         unsigned long event_idx;
> +       struct kvm_vcpu *vcpu;
>  };
>
>  /* PMU data structure per vcpu */
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/=
asm/kvm.h
> index d6b7a5b95874..d5aea43bc797 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -139,6 +139,7 @@ enum KVM_RISCV_ISA_EXT_ID {
>         KVM_RISCV_ISA_EXT_ZIHPM,
>         KVM_RISCV_ISA_EXT_SMSTATEEN,
>         KVM_RISCV_ISA_EXT_ZICOND,
> +       KVM_RISCV_ISA_EXT_SSCOFPMF,
>         KVM_RISCV_ISA_EXT_MAX,
>  };
>
> diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> index 225a435d9c9a..5a3a4cee0e3d 100644
> --- a/arch/riscv/kvm/main.c
> +++ b/arch/riscv/kvm/main.c
> @@ -43,6 +43,7 @@ int kvm_arch_hardware_enable(void)
>         csr_write(CSR_HCOUNTEREN, 0x02);
>
>         csr_write(CSR_HVIP, 0);
> +       csr_write(CSR_HVIEN, 1UL << IRQ_PMU_OVF);
>
>         kvm_riscv_aia_enable();
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index b5ca9f2e98ac..f83f0226439f 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -382,7 +382,8 @@ int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcp=
u, unsigned int irq)
>         if (irq < IRQ_LOCAL_MAX &&
>             irq !=3D IRQ_VS_SOFT &&
>             irq !=3D IRQ_VS_TIMER &&
> -           irq !=3D IRQ_VS_EXT)
> +           irq !=3D IRQ_VS_EXT &&
> +           irq !=3D IRQ_PMU_OVF)
>                 return -EINVAL;
>
>         set_bit(irq, vcpu->arch.irqs_pending);
> @@ -397,14 +398,15 @@ int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *v=
cpu, unsigned int irq)
>  int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int i=
rq)
>  {
>         /*
> -        * We only allow VS-mode software, timer, and external
> +        * We only allow VS-mode software, timer, counter overflow and ex=
ternal
>          * interrupts when irq is one of the local interrupts
>          * defined by RISC-V privilege specification.
>          */
>         if (irq < IRQ_LOCAL_MAX &&
>             irq !=3D IRQ_VS_SOFT &&
>             irq !=3D IRQ_VS_TIMER &&
> -           irq !=3D IRQ_VS_EXT)
> +           irq !=3D IRQ_VS_EXT &&
> +           irq !=3D IRQ_PMU_OVF)
>                 return -EINVAL;
>
>         clear_bit(irq, vcpu->arch.irqs_pending);
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index 581568847910..1eaaa919aa61 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -36,6 +36,7 @@ static const unsigned long kvm_isa_ext_arr[] =3D {
>         /* Multi letter extensions (alphabetically sorted) */
>         KVM_ISA_EXT_ARR(SMSTATEEN),
>         KVM_ISA_EXT_ARR(SSAIA),
> +       KVM_ISA_EXT_ARR(SSCOFPMF),
>         KVM_ISA_EXT_ARR(SSTC),
>         KVM_ISA_EXT_ARR(SVINVAL),
>         KVM_ISA_EXT_ARR(SVNAPOT),
> @@ -88,6 +89,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned=
 long ext)
>         case KVM_RISCV_ISA_EXT_I:
>         case KVM_RISCV_ISA_EXT_M:
>         case KVM_RISCV_ISA_EXT_SSTC:
> +       case KVM_RISCV_ISA_EXT_SSCOFPMF:
>         case KVM_RISCV_ISA_EXT_SVINVAL:
>         case KVM_RISCV_ISA_EXT_SVNAPOT:
>         case KVM_RISCV_ISA_EXT_ZBA:
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index e980235b8436..f2bf5b5bdd61 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -229,6 +229,47 @@ static int kvm_pmu_validate_counter_mask(struct kvm_=
pmu *kvpmu, unsigned long ct
>         return 0;
>  }
>
> +static void kvm_riscv_pmu_overflow(struct perf_event *perf_event,
> +                                  struct perf_sample_data *data,
> +                                  struct pt_regs *regs)
> +{
> +       struct kvm_pmc *pmc =3D perf_event->overflow_handler_context;
> +       struct kvm_vcpu *vcpu =3D pmc->vcpu;
> +       struct kvm_pmu *kvpmu =3D vcpu_to_pmu(vcpu);
> +       struct riscv_pmu *rpmu =3D to_riscv_pmu(perf_event->pmu);
> +       u64 period;
> +
> +       /*
> +        * Stop the event counting by directly accessing the perf_event.
> +        * Otherwise, this needs to deferred via a workqueue.
> +        * That will introduce skew in the counter value because the actu=
al
> +        * physical counter would start after returning from this functio=
n.
> +        * It will be stopped again once the workqueue is scheduled
> +        */
> +       rpmu->pmu.stop(perf_event, PERF_EF_UPDATE);
> +
> +       /*
> +        * The hw counter would start automatically when this function re=
turns.
> +        * Thus, the host may continue to interrupt and inject it to the =
guest
> +        * even without the guest configuring the next event. Depending o=
n the hardware
> +        * the host may have some sluggishness only if privilege mode fil=
tering is not
> +        * available. In an ideal world, where qemu is not the only capab=
le hardware,
> +        * this can be removed.
> +        * FYI: ARM64 does this way while x86 doesn't do anything as such=
.
> +        * TODO: Should we keep it for RISC-V ?
> +        */
> +       period =3D -(local64_read(&perf_event->count));
> +
> +       local64_set(&perf_event->hw.period_left, 0);
> +       perf_event->attr.sample_period =3D period;
> +       perf_event->hw.sample_period =3D period;
> +
> +       set_bit(pmc->idx, kvpmu->pmc_overflown);
> +       kvm_riscv_vcpu_set_interrupt(vcpu, IRQ_PMU_OVF);
> +
> +       rpmu->pmu.start(perf_event, PERF_EF_RELOAD);
> +}
> +
>  static long kvm_pmu_create_perf_event(struct kvm_pmc *pmc, struct perf_e=
vent_attr *attr,
>                                       unsigned long flags, unsigned long =
eidx,
>                                       unsigned long evtdata)
> @@ -248,7 +289,7 @@ static long kvm_pmu_create_perf_event(struct kvm_pmc =
*pmc, struct perf_event_att
>          */
>         attr->sample_period =3D kvm_pmu_get_sample_period(pmc);
>
> -       event =3D perf_event_create_kernel_counter(attr, -1, current, NUL=
L, pmc);
> +       event =3D perf_event_create_kernel_counter(attr, -1, current, kvm=
_riscv_pmu_overflow, pmc);
>         if (IS_ERR(event)) {
>                 pr_err("kvm pmu event creation failed for eidx %lx: %ld\n=
", eidx, PTR_ERR(event));
>                 return PTR_ERR(event);
> @@ -473,6 +514,12 @@ int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vc=
pu, unsigned long ctr_base,
>                 }
>         }
>
> +       /* The guest have serviced the interrupt and starting the counter=
 again */
> +       if (test_bit(IRQ_PMU_OVF, vcpu->arch.irqs_pending)) {
> +               clear_bit(pmc_index, kvpmu->pmc_overflown);
> +               kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_PMU_OVF);
> +       }
> +
>  out:
>         retdata->err_val =3D sbiret;
>
> @@ -539,7 +586,13 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcp=
u, unsigned long ctr_base,
>                         else if (pmc->perf_event)
>                                 pmc->counter_val +=3D perf_event_read_val=
ue(pmc->perf_event,
>                                                                          =
 &enabled, &running);
> -                       /* TODO: Add counter overflow support when sscofp=
mf support is added */
> +                       /*
> +                        * The counter and overflow indicies in the snaps=
hot region are w.r.to
> +                        * cbase. Modify the set bit in the counter mask =
instead of the pmc_index
> +                        * which indicates the absolute counter index.
> +                        */
> +                       if (test_bit(pmc_index, kvpmu->pmc_overflown))
> +                               kvpmu->sdata->ctr_overflow_mask |=3D (1UL=
 << i);
>                         kvpmu->sdata->ctr_values[i] =3D pmc->counter_val;
>                         kvm_vcpu_write_guest(vcpu, kvpmu->snapshot_addr, =
kvpmu->sdata,
>                                              sizeof(struct riscv_pmu_snap=
shot_data));
> @@ -548,15 +601,20 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vc=
pu, unsigned long ctr_base,
>                 if (flags & SBI_PMU_STOP_FLAG_RESET) {
>                         pmc->event_idx =3D SBI_PMU_EVENT_IDX_INVALID;
>                         clear_bit(pmc_index, kvpmu->pmc_in_use);
> +                       clear_bit(pmc_index, kvpmu->pmc_overflown);
>                         if (snap_flag_set) {
>                                 /* Clear the snapshot area for the upcomi=
ng deletion event */
>                                 kvpmu->sdata->ctr_values[i] =3D 0;
> +                               /*
> +                                * Only clear the given counter as the ca=
ller is responsible to
> +                                * validate both the overflow mask and co=
nfigured counters.
> +                                */
> +                               kvpmu->sdata->ctr_overflow_mask &=3D ~(1U=
L << i);
>                                 kvm_vcpu_write_guest(vcpu, kvpmu->snapsho=
t_addr, kvpmu->sdata,
>                                                      sizeof(struct riscv_=
pmu_snapshot_data));
>                         }
>                 }
>         }
> -
>  out:
>         retdata->err_val =3D sbiret;
>
> @@ -699,6 +757,7 @@ void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
>                 pmc =3D &kvpmu->pmc[i];
>                 pmc->idx =3D i;
>                 pmc->event_idx =3D SBI_PMU_EVENT_IDX_INVALID;
> +               pmc->vcpu =3D vcpu;
>                 if (i < kvpmu->num_hw_ctrs) {
>                         pmc->cinfo.type =3D SBI_PMU_CTR_TYPE_HW;
>                         if (i < 3)
> @@ -731,13 +790,14 @@ void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcp=
u)
>         if (!kvpmu)
>                 return;
>
> -       for_each_set_bit(i, kvpmu->pmc_in_use, RISCV_MAX_COUNTERS) {
> +       for_each_set_bit(i, kvpmu->pmc_in_use, RISCV_KVM_MAX_COUNTERS) {
>                 pmc =3D &kvpmu->pmc[i];
>                 pmc->counter_val =3D 0;
>                 kvm_pmu_release_perf_event(pmc);
>                 pmc->event_idx =3D SBI_PMU_EVENT_IDX_INVALID;
>         }
> -       bitmap_zero(kvpmu->pmc_in_use, RISCV_MAX_COUNTERS);
> +       bitmap_zero(kvpmu->pmc_in_use, RISCV_KVM_MAX_COUNTERS);
> +       bitmap_zero(kvpmu->pmc_overflown, RISCV_KVM_MAX_COUNTERS);
>         memset(&kvpmu->fw_event, 0, SBI_PMU_FW_MAX * sizeof(struct kvm_fw=
_event));
>         kvm_pmu_clear_snapshot_area(vcpu);
>  }
> --
> 2.34.1
>

