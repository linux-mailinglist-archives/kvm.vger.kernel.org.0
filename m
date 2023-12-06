Return-Path: <kvm+bounces-3665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3607D8067C9
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 07:52:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 89A53B21281
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 06:51:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D955012E49;
	Wed,  6 Dec 2023 06:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=syntacore.com header.i=@syntacore.com header.b="Snsoge3i";
	dkim=pass (2048-bit key) header.d=syntacore.com header.i=@syntacore.com header.b="HxW7C7+4"
X-Original-To: kvm@vger.kernel.org
X-Greylist: delayed 481 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 05 Dec 2023 22:51:44 PST
Received: from mta-04.yadro.com (mta-04.yadro.com [89.207.88.248])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D01135;
	Tue,  5 Dec 2023 22:51:44 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-04.yadro.com BB215C0003
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=syntacore.com;
	s=mta-04; t=1701845021;
	bh=U2sWimltUqSPu+HrohbmQGMQU7yW2Wqpu0btq2LORM0=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=Snsoge3i0QoEIC67+nMnclFMbod6q8h22opzfAZAzUUw5pCAMMZilsyxZPVWcl8W+
	 1AwOyWaYjtnbEBjBDWIgq5jsfBITTPiZj6ScZ/hOBnexPoupFy1iqRd6cdH2SJAQyo
	 IwjI+5Sp8stG64P2wHMd5U6J0dej0Ic2QuAi6pfjk2FRiHdKkaqPf7HMA3RbhYPqFN
	 cVXwGukDCIlrmZ/StQ4gDfJaKVZQZhXLbvxpQam8udD8ajHAiAR4YcBo02uvHVhPuh
	 330Rmus4t47Gr6GJ7JszbZI32Be0ws3GlVpzhT1W3UwbpOxO3jpQv2QfZfZNxkCdYV
	 aGP1VZ649kNdA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=syntacore.com;
	s=mta-03; t=1701845021;
	bh=U2sWimltUqSPu+HrohbmQGMQU7yW2Wqpu0btq2LORM0=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=HxW7C7+4jE+AtEQ9cJeFk4XVfsktmQ4L9xRb6w23eC0hlCiaF4GZFn331d7nshqyF
	 NCzV93AygoKeM+kZ58CVdNoI/WhduXryLcOLKbDFRr0i+XQvq8Qjh2Oy6T40bAH1fX
	 YAjZGPqeqsLG8R/MTdrOMAbE7KgSkXIrhciRLfucAb+YwsQj/dD8lbLl8XH6zEP0Bu
	 2hbJUexu49BA4HHrKUnVWt+daoCHrb1fF9QlIIr88b5XqJyU1GMtYXLCQzM/13zRGJ
	 3E83wyx1KNHW4vkj20yOhWm3vaApvb/fvWkK0uUGoqJNXfQVkyXQqHZXUKsJO/tNhm
	 Z3DoBImf8u6QA==
Message-ID: <a790c2f7-2952-4268-92c5-f293f6fbaa38@syntacore.com>
Date: Wed, 6 Dec 2023 09:43:39 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 8/9] RISC-V: KVM: Add perf sampling support for guests
Content-Language: en-US, ru-RU
To: Atish Patra <atishp@rivosinc.com>, <linux-kernel@vger.kernel.org>
CC: Mark Rutland <mark.rutland@arm.com>, Alexandre Ghiti
	<alexghiti@rivosinc.com>, <kvm@vger.kernel.org>, Anup Patel
	<anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, Conor Dooley
	<conor.dooley@microchip.com>, Guo Ren <guoren@kernel.org>,
	<kvm-riscv@lists.infradead.org>, Atish Patra <atishp@atishpatra.org>, "Palmer
 Dabbelt" <palmer@dabbelt.com>, <linux-riscv@lists.infradead.org>, Will Deacon
	<will@kernel.org>, Andrew Jones <ajones@ventanamicro.com>
References: <20231205024310.1593100-1-atishp@rivosinc.com>
 <20231205024310.1593100-9-atishp@rivosinc.com>
From: Vladimir Isaev <vladimir.isaev@syntacore.com>
In-Reply-To: <20231205024310.1593100-9-atishp@rivosinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: T-EXCH-08.corp.yadro.com (172.17.11.58) To
 S-Exch-02.corp.yadro.com (10.78.5.239)

05.12.2023 05:43, Atish Patra wrote:
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

I don't understand why do we need HVIEN and AIA, why HIDELEG can't be used for this puprpose?

> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/csr.h      |  3 +-
>  arch/riscv/include/uapi/asm/kvm.h |  1 +
>  arch/riscv/kvm/main.c             |  1 +
>  arch/riscv/kvm/vcpu.c             |  8 ++--
>  arch/riscv/kvm/vcpu_onereg.c      |  1 +
>  arch/riscv/kvm/vcpu_pmu.c         | 69 ++++++++++++++++++++++++++++---
>  6 files changed, 73 insertions(+), 10 deletions(-)
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
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> index 60d3b21dead7..741c16f4518e 100644
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

Is my understanding correct that this will break KVM for non-AIA CPUs?

As I can remember HVIEN depends on AIA.

> 
>         kvm_riscv_aia_enable();
> 
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index e087c809073c..2d9f252356c3 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -380,7 +380,8 @@ int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
>         if (irq < IRQ_LOCAL_MAX &&
>             irq != IRQ_VS_SOFT &&
>             irq != IRQ_VS_TIMER &&
> -           irq != IRQ_VS_EXT)
> +           irq != IRQ_VS_EXT &&
> +           irq != IRQ_PMU_OVF)
>                 return -EINVAL;
> 
>         set_bit(irq, vcpu->arch.irqs_pending);
> @@ -395,14 +396,15 @@ int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
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
> index f8c9fa0c03c5..19a0e4eaf0df 100644
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
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index 622c4ee89e7b..86c8e92f92d3 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -229,6 +229,47 @@ static int kvm_pmu_validate_counter_mask(struct kvm_pmu *kvpmu, unsigned long ct
>         return 0;
>  }
> 
> +static void kvm_riscv_pmu_overflow(struct perf_event *perf_event,
> +                                 struct perf_sample_data *data,
> +                                 struct pt_regs *regs)
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
> +        * Thus, the host may continue to interrupts and inject it to the guest
> +        * even without guest configuring the next event. Depending on the hardware
> +        * the host may some sluggishness only if privilege mode filtering is not
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
>  static int kvm_pmu_create_perf_event(struct kvm_pmc *pmc, struct perf_event_attr *attr,
>                                      unsigned long flags, unsigned long eidx, unsigned long evtdata)
>  {
> @@ -247,7 +288,7 @@ static int kvm_pmu_create_perf_event(struct kvm_pmc *pmc, struct perf_event_attr
>          */
>         attr->sample_period = kvm_pmu_get_sample_period(pmc);
> 
> -       event = perf_event_create_kernel_counter(attr, -1, current, NULL, pmc);
> +       event = perf_event_create_kernel_counter(attr, -1, current, kvm_riscv_pmu_overflow, pmc);
>         if (IS_ERR(event)) {
>                 pr_err("kvm pmu event creation failed for eidx %lx: %ld\n", eidx, PTR_ERR(event));
>                 return PTR_ERR(event);
> @@ -466,6 +507,12 @@ int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
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
> @@ -537,7 +584,12 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
>                 }
> 
>                 if (bSnapshot && !sbiret) {
> -                       //TODO: Add counter overflow support when sscofpmf support is added
> +                       /* The counter and overflow indicies in the snapshot region are w.r.to
> +                        * cbase. Modify the set bit in the counter mask instead of the pmc_index
> +                        * which indicates the absolute counter index.
> +                        */
> +                       if (test_bit(pmc_index, kvpmu->pmc_overflown))
> +                               kvpmu->sdata->ctr_overflow_mask |= (1UL << i);
>                         kvpmu->sdata->ctr_values[i] = pmc->counter_val;
>                         kvm_vcpu_write_guest(vcpu, kvpmu->snapshot_addr, kvpmu->sdata,
>                                              sizeof(struct riscv_pmu_snapshot_data));
> @@ -546,15 +598,19 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
>                 if (flags & SBI_PMU_STOP_FLAG_RESET) {
>                         pmc->event_idx = SBI_PMU_EVENT_IDX_INVALID;
>                         clear_bit(pmc_index, kvpmu->pmc_in_use);
> +                       clear_bit(pmc_index, kvpmu->pmc_overflown);
>                         if (bSnapshot) {
>                                 /* Clear the snapshot area for the upcoming deletion event */
>                                 kvpmu->sdata->ctr_values[i] = 0;
> +                               /* Only clear the given counter as the caller is responsible to
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
> @@ -729,15 +785,16 @@ void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu)
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
> -       kvpmu->snapshot_addr = INVALID_GPA;
> +       kvm_pmu_clear_snapshot_area(vcpu);
>  }
> 
>  void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu)
> --
> 2.34.1
> 
> 
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

Thank you,
Vladimir Isaev

