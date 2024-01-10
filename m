Return-Path: <kvm+bounces-5995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D90C829A99
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 13:49:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8BE4D1F24B76
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 12:49:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C1F6487A2;
	Wed, 10 Jan 2024 12:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=syntacore.com header.i=@syntacore.com header.b="NfOw+sVr";
	dkim=pass (2048-bit key) header.d=syntacore.com header.i=@syntacore.com header.b="vu4X0JnD"
X-Original-To: kvm@vger.kernel.org
Received: from mta-04.yadro.com (mta-04.yadro.com [89.207.88.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD934878F;
	Wed, 10 Jan 2024 12:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=syntacore.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=syntacore.com
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-04.yadro.com B54A0C0003
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=syntacore.com;
	s=mta-04; t=1704890332;
	bh=J2Cdag0SuCiSQAWOmyVPFOmg2nxY7XKZX8eRVsmCIQw=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=NfOw+sVr0+9CvT+I1G82AInbTIKDUOutRQe6K4dcHnTu+uUGvfAiAajMCuS3nz5vX
	 LhD76rRtKrRtgvEg1pSsTsyT5HcMY7pvDSMhZxx3b9mnXy6wZdeULW771qv3qv3zfU
	 m6l6q66W0cFmBx+R+6TL+jCgyDQUGpq9QLxdOtVWcWp3E0z7IMcjugvxD6uMoioukQ
	 bvjjWcZ9KCne/a9XZ68uEadc+mHGUhLPe4ZEsNQSHKQGOL1/1WP5rCSO/q1YyUrjEr
	 x4NPGWK6cfr4VhyzXJysTn0+4k8nEhPhM6lz+yFuYieK+PzwuogPXjZeUqEQVjkpE7
	 vHqtfB8DMnR1A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=syntacore.com;
	s=mta-03; t=1704890332;
	bh=J2Cdag0SuCiSQAWOmyVPFOmg2nxY7XKZX8eRVsmCIQw=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=vu4X0JnDjWBje00FmcUwzz7wWRBMY0yaDLrqwoIM1vEp7Sn8pInu5tzInaHjCxDi1
	 oyIa54sUFlSzbHbE0BaDihK/m1vsiJrv6MVHteu3ezaHehFujrQnafRpWMIrxBkYl2
	 eZwhnDtOtQ7FJpsMZOfJ93qW5dZWwLpIIF0KAz7AmDaz6EKQyud4vTMm+eyV7Xxhdw
	 vlT/BzFJisfX4oqsyFpca++GVXjYi+UblLLoui+30SM8GBvEO4u7YgIcFLcSBUsv5z
	 d8iMy95vAnD7A+W6W48APrNs16RXlJfeVQ0Hl4fig6ziLPMunNIs3FcMB6TazkLLqw
	 r42VT7QT/RuMA==
Message-ID: <db38f118-3682-4b2f-b0a6-76b1c9fba557@syntacore.com>
Date: Wed, 10 Jan 2024 15:38:49 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 09/10] RISC-V: KVM: Add perf sampling support for guests
Content-Language: en-US, ru-RU
To: Atish Patra <atishp@rivosinc.com>, <linux-kernel@vger.kernel.org>
CC: Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti
	<alexghiti@rivosinc.com>, Andrew Jones <ajones@ventanamicro.com>, Anup Patel
	<anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, Conor Dooley
	<conor.dooley@microchip.com>, Guo Ren <guoren@kernel.org>, Heiko Stuebner
	<heiko@sntech.de>, <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
	<linux-riscv@lists.infradead.org>, Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
	<paul.walmsley@sifive.com>, Will Deacon <will@kernel.org>
References: <20231229214950.4061381-1-atishp@rivosinc.com>
 <20231229214950.4061381-10-atishp@rivosinc.com>
From: Vladimir Isaev <vladimir.isaev@syntacore.com>
In-Reply-To: <20231229214950.4061381-10-atishp@rivosinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: T-EXCH-10.corp.yadro.com (172.17.11.60) To
 S-Exch-01.corp.yadro.com (10.78.5.241)


30.12.2023 00:49, Atish Patra wrote:
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
> diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
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
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
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
> +       csr_write(CSR_HVIEN, 1UL << IRQ_PMU_OVF);\

Hi Atish,

Maybe I missed something, but I thought you planned to move CSR_HVIEN to kvm_riscv_aia_enable() and
add dependency for KVM sscofpmf and AIA since this register is part of AIA spec.

Thank you
Vladimir Isaev

> 
>         kvm_riscv_aia_enable();
> 
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index b5ca9f2e98ac..f83f0226439f 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -382,7 +382,8 @@ int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
>         if (irq < IRQ_LOCAL_MAX &&
>             irq != IRQ_VS_SOFT &&
>             irq != IRQ_VS_TIMER &&
> -           irq != IRQ_VS_EXT)
> +           irq != IRQ_VS_EXT &&
> +           irq != IRQ_PMU_OVF)
>                 return -EINVAL;
> 
>         set_bit(irq, vcpu->arch.irqs_pending);
> @@ -397,14 +398,15 @@ int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
>  int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
>  {
>         /*
> -        * We only allow VS-mode software, timer, and external
> +        * We only allow VS-mode software, timer, counter overflow and external
>          * interrupts when irq is one of the local interrupts
>          * defined by RISC-V privilege specification.
>          */
>         if (irq < IRQ_LOCAL_MAX &&
>             irq != IRQ_VS_SOFT &&
>             irq != IRQ_VS_TIMER &&
> -           irq != IRQ_VS_EXT)
> +           irq != IRQ_VS_EXT &&
> +           irq != IRQ_PMU_OVF)
>                 return -EINVAL;
> 
>         clear_bit(irq, vcpu->arch.irqs_pending);
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index 581568847910..1eaaa919aa61 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -36,6 +36,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
>         /* Multi letter extensions (alphabetically sorted) */
>         KVM_ISA_EXT_ARR(SMSTATEEN),
>         KVM_ISA_EXT_ARR(SSAIA),
> +       KVM_ISA_EXT_ARR(SSCOFPMF),
>         KVM_ISA_EXT_ARR(SSTC),
>         KVM_ISA_EXT_ARR(SVINVAL),
>         KVM_ISA_EXT_ARR(SVNAPOT),
> @@ -88,6 +89,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
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
> @@ -229,6 +229,47 @@ static int kvm_pmu_validate_counter_mask(struct kvm_pmu *kvpmu, unsigned long ct
>         return 0;
>  }
> 
> +static void kvm_riscv_pmu_overflow(struct perf_event *perf_event,
> +                                  struct perf_sample_data *data,
> +                                  struct pt_regs *regs)
> +{
> +       struct kvm_pmc *pmc = perf_event->overflow_handler_context;
> +       struct kvm_vcpu *vcpu = pmc->vcpu;
> +       struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +       struct riscv_pmu *rpmu = to_riscv_pmu(perf_event->pmu);
> +       u64 period;
> +
> +       /*
> +        * Stop the event counting by directly accessing the perf_event.
> +        * Otherwise, this needs to deferred via a workqueue.
> +        * That will introduce skew in the counter value because the actual
> +        * physical counter would start after returning from this function.
> +        * It will be stopped again once the workqueue is scheduled
> +        */
> +       rpmu->pmu.stop(perf_event, PERF_EF_UPDATE);
> +
> +       /*
> +        * The hw counter would start automatically when this function returns.
> +        * Thus, the host may continue to interrupt and inject it to the guest
> +        * even without the guest configuring the next event. Depending on the hardware
> +        * the host may have some sluggishness only if privilege mode filtering is not
> +        * available. In an ideal world, where qemu is not the only capable hardware,
> +        * this can be removed.
> +        * FYI: ARM64 does this way while x86 doesn't do anything as such.
> +        * TODO: Should we keep it for RISC-V ?
> +        */
> +       period = -(local64_read(&perf_event->count));
> +
> +       local64_set(&perf_event->hw.period_left, 0);
> +       perf_event->attr.sample_period = period;
> +       perf_event->hw.sample_period = period;
> +
> +       set_bit(pmc->idx, kvpmu->pmc_overflown);
> +       kvm_riscv_vcpu_set_interrupt(vcpu, IRQ_PMU_OVF);
> +
> +       rpmu->pmu.start(perf_event, PERF_EF_RELOAD);
> +}
> +
>  static long kvm_pmu_create_perf_event(struct kvm_pmc *pmc, struct perf_event_attr *attr,
>                                       unsigned long flags, unsigned long eidx,
>                                       unsigned long evtdata)
> @@ -248,7 +289,7 @@ static long kvm_pmu_create_perf_event(struct kvm_pmc *pmc, struct perf_event_att
>          */
>         attr->sample_period = kvm_pmu_get_sample_period(pmc);
> 
> -       event = perf_event_create_kernel_counter(attr, -1, current, NULL, pmc);
> +       event = perf_event_create_kernel_counter(attr, -1, current, kvm_riscv_pmu_overflow, pmc);
>         if (IS_ERR(event)) {
>                 pr_err("kvm pmu event creation failed for eidx %lx: %ld\n", eidx, PTR_ERR(event));
>                 return PTR_ERR(event);
> @@ -473,6 +514,12 @@ int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
>                 }
>         }
> 
> +       /* The guest have serviced the interrupt and starting the counter again */
> +       if (test_bit(IRQ_PMU_OVF, vcpu->arch.irqs_pending)) {
> +               clear_bit(pmc_index, kvpmu->pmc_overflown);
> +               kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_PMU_OVF);
> +       }
> +
>  out:
>         retdata->err_val = sbiret;
> 
> @@ -539,7 +586,13 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
>                         else if (pmc->perf_event)
>                                 pmc->counter_val += perf_event_read_value(pmc->perf_event,
>                                                                           &enabled, &running);
> -                       /* TODO: Add counter overflow support when sscofpmf support is added */
> +                       /*
> +                        * The counter and overflow indicies in the snapshot region are w.r.to
> +                        * cbase. Modify the set bit in the counter mask instead of the pmc_index
> +                        * which indicates the absolute counter index.
> +                        */
> +                       if (test_bit(pmc_index, kvpmu->pmc_overflown))
> +                               kvpmu->sdata->ctr_overflow_mask |= (1UL << i);
>                         kvpmu->sdata->ctr_values[i] = pmc->counter_val;
>                         kvm_vcpu_write_guest(vcpu, kvpmu->snapshot_addr, kvpmu->sdata,
>                                              sizeof(struct riscv_pmu_snapshot_data));
> @@ -548,15 +601,20 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
>                 if (flags & SBI_PMU_STOP_FLAG_RESET) {
>                         pmc->event_idx = SBI_PMU_EVENT_IDX_INVALID;
>                         clear_bit(pmc_index, kvpmu->pmc_in_use);
> +                       clear_bit(pmc_index, kvpmu->pmc_overflown);
>                         if (snap_flag_set) {
>                                 /* Clear the snapshot area for the upcoming deletion event */
>                                 kvpmu->sdata->ctr_values[i] = 0;
> +                               /*
> +                                * Only clear the given counter as the caller is responsible to
> +                                * validate both the overflow mask and configured counters.
> +                                */
> +                               kvpmu->sdata->ctr_overflow_mask &= ~(1UL << i);
>                                 kvm_vcpu_write_guest(vcpu, kvpmu->snapshot_addr, kvpmu->sdata,
>                                                      sizeof(struct riscv_pmu_snapshot_data));
>                         }
>                 }
>         }
> -
>  out:
>         retdata->err_val = sbiret;
> 
> @@ -699,6 +757,7 @@ void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
>                 pmc = &kvpmu->pmc[i];
>                 pmc->idx = i;
>                 pmc->event_idx = SBI_PMU_EVENT_IDX_INVALID;
> +               pmc->vcpu = vcpu;
>                 if (i < kvpmu->num_hw_ctrs) {
>                         pmc->cinfo.type = SBI_PMU_CTR_TYPE_HW;
>                         if (i < 3)
> @@ -731,13 +790,14 @@ void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu)
>         if (!kvpmu)
>                 return;
> 
> -       for_each_set_bit(i, kvpmu->pmc_in_use, RISCV_MAX_COUNTERS) {
> +       for_each_set_bit(i, kvpmu->pmc_in_use, RISCV_KVM_MAX_COUNTERS) {
>                 pmc = &kvpmu->pmc[i];
>                 pmc->counter_val = 0;
>                 kvm_pmu_release_perf_event(pmc);
>                 pmc->event_idx = SBI_PMU_EVENT_IDX_INVALID;
>         }
> -       bitmap_zero(kvpmu->pmc_in_use, RISCV_MAX_COUNTERS);
> +       bitmap_zero(kvpmu->pmc_in_use, RISCV_KVM_MAX_COUNTERS);
> +       bitmap_zero(kvpmu->pmc_overflown, RISCV_KVM_MAX_COUNTERS);
>         memset(&kvpmu->fw_event, 0, SBI_PMU_FW_MAX * sizeof(struct kvm_fw_event));
>         kvm_pmu_clear_snapshot_area(vcpu);
>  }
> --
> 2.34.1
> 
> 
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

