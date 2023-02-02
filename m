Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D0C68743F
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 05:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbjBBEDQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 23:03:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbjBBEDK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 23:03:10 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9970C67A
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 20:03:04 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id me3so2451194ejb.7
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 20:03:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/u7kcraNHuAzpF/FlOTnk1+soLNkuOEC/f42ZPPrEbk=;
        b=Sqr+VnIHVWDCCafOSuSDJiKZ8IxylFm0NvciR/XtTy72+d+zLxvAhaFvkaGs3Pgkzi
         W30yCMg3qoO7hPjUFp14kIaUmLlwC3x3HZ3K81rixrBv8C8DJB/rUXiDRvTTUilmhmfu
         K7z5DEhp0w2tVNL5h9/cBcNABBE39TDMxTgIYW5wWy2HmtcQiN2luK07upBp26mM/JhF
         0a4TTo7K3Q5DFxWg2SueOo94sgl9eAea4OK2v19PQq+K1ZWkn6PY/KvDqWNNy+k7uFEW
         3RxCEbvMawQACTT4RybKlVcvYNC0IS47cw4bJqgmOppvdLRRm1ah0BpJsGNG8KN3+Htw
         u7cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/u7kcraNHuAzpF/FlOTnk1+soLNkuOEC/f42ZPPrEbk=;
        b=ow0LMLYoHvL3KJb45iiRXkfE4rDuNCCov3YdkesNu8AeeetFr6rei566GUwwftmmbR
         p8qU4dnMeSOJf9g+Zk2fJhOn0vq3RQPdtDTTAF5e2eAlmh2W+gL99JrQ/lICrI6+k3zO
         IlrYaavv1Re5GGpHvjgWaXqs6Z1h8yA7cCxcZWlfeNf4sbL242z3aTdBj8E7eERAw55v
         bQOKHTuZuM7XjYZXr88EUnlxySbJzFohCpwbf50qwDEx5ngkSSDbp7W5q96mmQaChors
         RpgdgULHmgBPEicEeRLLSpPrRhreiLjKDsx8y44Ea/Sbmwu03zHBqhdeIvQgLjs0Js5D
         fa1Q==
X-Gm-Message-State: AO0yUKVFCz25l/HS4wl+uO71XpYU5wZTIkQqtJFSbI/3DR2o2jqw2/TY
        382MUPtWfcqycIuVT8LUEcyT+BtG9+dN3M/EUTvPCw==
X-Google-Smtp-Source: AK7set/HhJA6O999jEKxuSb+jTxgWChM9BZJReaCpewmHhoYg4gKWAdlzKzOlF3VDwnI254VGPV3c2eMDaeyUIbwOL8=
X-Received: by 2002:a17:906:1653:b0:88a:7cf5:5d33 with SMTP id
 n19-20020a170906165300b0088a7cf55d33mr1571201ejd.100.1675310583189; Wed, 01
 Feb 2023 20:03:03 -0800 (PST)
MIME-Version: 1.0
References: <20230201231250.3806412-1-atishp@rivosinc.com> <20230201231250.3806412-8-atishp@rivosinc.com>
In-Reply-To: <20230201231250.3806412-8-atishp@rivosinc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Thu, 2 Feb 2023 09:32:52 +0530
Message-ID: <CAAhSdy2CegXrUBsbLJtXZ3yGwxSPAbp=W_iW-_FuD1e1tkZM2g@mail.gmail.com>
Subject: Re: [PATCH v4 07/14] RISC-V: KVM: Add skeleton support for perf
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org, Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Atish Patra <atishp@atishpatra.org>,
        Eric Lin <eric.lin@sifive.com>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 2, 2023 at 4:42 AM Atish Patra <atishp@rivosinc.com> wrote:
>
> This patch only adds barebone structure of perf implementation. Most of
> the function returns zero at this point and will be implemented
> fully in the future.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

Looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/include/asm/kvm_host.h     |   4 +
>  arch/riscv/include/asm/kvm_vcpu_pmu.h |  78 +++++++++++++++
>  arch/riscv/kvm/Makefile               |   1 +
>  arch/riscv/kvm/vcpu.c                 |   7 ++
>  arch/riscv/kvm/vcpu_pmu.c             | 136 ++++++++++++++++++++++++++
>  5 files changed, 226 insertions(+)
>  create mode 100644 arch/riscv/include/asm/kvm_vcpu_pmu.h
>  create mode 100644 arch/riscv/kvm/vcpu_pmu.c
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 93f43a3..b90be9a 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -18,6 +18,7 @@
>  #include <asm/kvm_vcpu_insn.h>
>  #include <asm/kvm_vcpu_sbi.h>
>  #include <asm/kvm_vcpu_timer.h>
> +#include <asm/kvm_vcpu_pmu.h>
>
>  #define KVM_MAX_VCPUS                  1024
>
> @@ -228,6 +229,9 @@ struct kvm_vcpu_arch {
>
>         /* Don't run the VCPU (blocked) */
>         bool pause;
> +
> +       /* Performance monitoring context */
> +       struct kvm_pmu pmu_context;
>  };
>
>  static inline void kvm_arch_hardware_unsetup(void) {}
> diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> new file mode 100644
> index 0000000..e2b4038
> --- /dev/null
> +++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> @@ -0,0 +1,78 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (c) 2023 Rivos Inc
> + *
> + * Authors:
> + *     Atish Patra <atishp@rivosinc.com>
> + */
> +
> +#ifndef __KVM_VCPU_RISCV_PMU_H
> +#define __KVM_VCPU_RISCV_PMU_H
> +
> +#include <linux/perf/riscv_pmu.h>
> +#include <asm/kvm_vcpu_sbi.h>
> +#include <asm/sbi.h>
> +
> +#ifdef CONFIG_RISCV_PMU_SBI
> +#define RISCV_KVM_MAX_FW_CTRS  32
> +
> +#if RISCV_KVM_MAX_FW_CTRS > 32
> +#error "Maximum firmware counter can't exceed 32 without increasing the RISCV_MAX_COUNTERS"
> +#endif
> +
> +#define RISCV_MAX_COUNTERS      64
> +
> +/* Per virtual pmu counter data */
> +struct kvm_pmc {
> +       u8 idx;
> +       struct perf_event *perf_event;
> +       uint64_t counter_val;
> +       union sbi_pmu_ctr_info cinfo;
> +       /* Event monitoring status */
> +       bool started;
> +};
> +
> +/* PMU data structure per vcpu */
> +struct kvm_pmu {
> +       struct kvm_pmc pmc[RISCV_MAX_COUNTERS];
> +       /* Number of the virtual firmware counters available */
> +       int num_fw_ctrs;
> +       /* Number of the virtual hardware counters available */
> +       int num_hw_ctrs;
> +       /* A flag to indicate that pmu initialization is done */
> +       bool init_done;
> +       /* Bit map of all the virtual counter used */
> +       DECLARE_BITMAP(pmc_in_use, RISCV_MAX_COUNTERS);
> +};
> +
> +#define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu_context)
> +#define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu_context))
> +
> +int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, struct kvm_vcpu_sbi_return *retdata);
> +int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
> +                               struct kvm_vcpu_sbi_return *retdata);
> +int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> +                                unsigned long ctr_mask, unsigned long flag, uint64_t ival,
> +                                struct kvm_vcpu_sbi_return *retdata);
> +int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> +                               unsigned long ctr_mask, unsigned long flag,
> +                               struct kvm_vcpu_sbi_return *retdata);
> +int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> +                                    unsigned long ctr_mask, unsigned long flag,
> +                                    unsigned long eidx, uint64_t evtdata,
> +                                    struct kvm_vcpu_sbi_return *retdata);
> +int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
> +                               struct kvm_vcpu_sbi_return *retdata);
> +void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu);
> +void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu);
> +void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu);
> +
> +#else
> +struct kvm_pmu {
> +};
> +
> +static inline void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu) {}
> +static inline void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu) {}
> +static inline void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu) {}
> +#endif /* CONFIG_RISCV_PMU_SBI */
> +#endif /* !__KVM_VCPU_RISCV_PMU_H */
> diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> index 019df920..5de1053 100644
> --- a/arch/riscv/kvm/Makefile
> +++ b/arch/riscv/kvm/Makefile
> @@ -25,3 +25,4 @@ kvm-y += vcpu_sbi_base.o
>  kvm-y += vcpu_sbi_replace.o
>  kvm-y += vcpu_sbi_hsm.o
>  kvm-y += vcpu_timer.o
> +kvm-$(CONFIG_RISCV_PMU_SBI) += vcpu_pmu.o
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 7c08567..7d010b0 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -138,6 +138,8 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
>         WRITE_ONCE(vcpu->arch.irqs_pending, 0);
>         WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
>
> +       kvm_riscv_vcpu_pmu_reset(vcpu);
> +
>         vcpu->arch.hfence_head = 0;
>         vcpu->arch.hfence_tail = 0;
>         memset(vcpu->arch.hfence_queue, 0, sizeof(vcpu->arch.hfence_queue));
> @@ -194,6 +196,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>         /* Setup VCPU timer */
>         kvm_riscv_vcpu_timer_init(vcpu);
>
> +       /* setup performance monitoring */
> +       kvm_riscv_vcpu_pmu_init(vcpu);
> +
>         /* Reset VCPU */
>         kvm_riscv_reset_vcpu(vcpu);
>
> @@ -216,6 +221,8 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>         /* Cleanup VCPU timer */
>         kvm_riscv_vcpu_timer_deinit(vcpu);
>
> +       kvm_riscv_vcpu_pmu_deinit(vcpu);
> +
>         /* Free unused pages pre-allocated for G-stage page table mappings */
>         kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
>  }
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> new file mode 100644
> index 0000000..2dad37f
> --- /dev/null
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -0,0 +1,136 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2023 Rivos Inc
> + *
> + * Authors:
> + *     Atish Patra <atishp@rivosinc.com>
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/err.h>
> +#include <linux/kvm_host.h>
> +#include <linux/perf/riscv_pmu.h>
> +#include <asm/csr.h>
> +#include <asm/kvm_vcpu_sbi.h>
> +#include <asm/kvm_vcpu_pmu.h>
> +#include <linux/kvm_host.h>
> +
> +#define kvm_pmu_num_counters(pmu) ((pmu)->num_hw_ctrs + (pmu)->num_fw_ctrs)
> +
> +int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, struct kvm_vcpu_sbi_return *retdata)
> +{
> +       struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +
> +       retdata->out_val = kvm_pmu_num_counters(kvpmu);
> +
> +       return 0;
> +}
> +
> +int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
> +                               struct kvm_vcpu_sbi_return *retdata)
> +{
> +       struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +
> +       if (cidx > RISCV_MAX_COUNTERS || cidx == 1) {
> +               retdata->err_val = SBI_ERR_INVALID_PARAM;
> +               return 0;
> +       }
> +
> +       retdata->out_val = kvpmu->pmc[cidx].cinfo.value;
> +
> +       return 0;
> +}
> +
> +int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> +                                unsigned long ctr_mask, unsigned long flag, uint64_t ival,
> +                                struct kvm_vcpu_sbi_return *retdata)
> +{
> +       /* TODO */
> +       return 0;
> +}
> +
> +int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> +                               unsigned long ctr_mask, unsigned long flag,
> +                               struct kvm_vcpu_sbi_return *retdata)
> +{
> +       /* TODO */
> +       return 0;
> +}
> +
> +int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> +                                    unsigned long ctr_mask, unsigned long flag,
> +                                    unsigned long eidx, uint64_t evtdata,
> +                                    struct kvm_vcpu_sbi_return *retdata)
> +{
> +       /* TODO */
> +       return 0;
> +}
> +
> +int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
> +                               struct kvm_vcpu_sbi_return *retdata)
> +{
> +       /* TODO */
> +       return 0;
> +}
> +
> +void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
> +{
> +       int i = 0, ret, num_hw_ctrs = 0, hpm_width = 0;
> +       struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +       struct kvm_pmc *pmc;
> +
> +       ret = riscv_pmu_get_hpm_info(&hpm_width, &num_hw_ctrs);
> +       if (ret < 0 || !hpm_width || !num_hw_ctrs)
> +               return;
> +
> +       /*
> +        * It is guranteed that RISCV_KVM_MAX_FW_CTRS can't exceed 32 as
> +        * that may exceed total number of counters more than RISCV_MAX_COUNTERS
> +        */
> +       kvpmu->num_hw_ctrs = num_hw_ctrs;
> +       kvpmu->num_fw_ctrs = RISCV_KVM_MAX_FW_CTRS;
> +
> +       /*
> +        * There is no correlation between the logical hardware counter and virtual counters.
> +        * However, we need to encode a hpmcounter CSR in the counter info field so that
> +        * KVM can trap n emulate the read. This works well in the migration use case as
> +        * KVM doesn't care if the actual hpmcounter is available in the hardware or not.
> +        */
> +       for (i = 0; i < kvm_pmu_num_counters(kvpmu); i++) {
> +               /* TIME CSR shouldn't be read from perf interface */
> +               if (i == 1)
> +                       continue;
> +               pmc = &kvpmu->pmc[i];
> +               pmc->idx = i;
> +               if (i < kvpmu->num_hw_ctrs) {
> +                       pmc->cinfo.type = SBI_PMU_CTR_TYPE_HW;
> +                       if (i < 3)
> +                               /* CY, IR counters */
> +                               pmc->cinfo.width = 63;
> +                       else
> +                               pmc->cinfo.width = hpm_width;
> +                       /*
> +                        * The CSR number doesn't have any relation with the logical
> +                        * hardware counters. The CSR numbers are encoded sequentially
> +                        * to avoid maintaining a map between the virtual counter
> +                        * and CSR number.
> +                        */
> +                       pmc->cinfo.csr = CSR_CYCLE + i;
> +               } else {
> +                       pmc->cinfo.type = SBI_PMU_CTR_TYPE_FW;
> +                       pmc->cinfo.width = BITS_PER_LONG - 1;
> +               }
> +       }
> +
> +       kvpmu->init_done = true;
> +}
> +
> +void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu)
> +{
> +       /* TODO */
> +}
> +
> +void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu)
> +{
> +       kvm_riscv_vcpu_pmu_deinit(vcpu);
> +}
> --
> 2.25.1
>
