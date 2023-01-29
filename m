Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96C3567FEE1
	for <lists+kvm@lfdr.de>; Sun, 29 Jan 2023 13:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbjA2MbC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Jan 2023 07:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjA2MbB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Jan 2023 07:31:01 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66CB71EFEA
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 04:30:59 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id bk15so24761725ejb.9
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 04:30:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ivBr8pVNybYv407PEg+sEKyDLzFGL+otvLMsSQtktPk=;
        b=aGACXqge+LsTk53QQJ5Hu4CwziXat+zr2TqdenYHPirIgI9nK+YibfnjWpFTqcO76j
         /5FUIX4DJTIC0N2BnOaSeB5pLj1J3dJlPxWWNnqUI0KeFr9zuFFGRKBkVbfpJq8N/D4Y
         BalFi21LAo2/XUWH/qYBBZJSmVpdLx/WTjFZ/9ndOZ1BbvVmUurFyvwMFmA8DcjbXbym
         Tvc707keufWPEBqpe7ot43LOVeHxVDxDAbNHbUC4DwaE0xZ59cQETokch/R5kryXUFr+
         YMfMHuc8Z/dKPUJCqfECd55KI1mrm1sYnJM1YlAe4pd8IBcaZRs0BAxaub9IBNOkWPtf
         VuCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ivBr8pVNybYv407PEg+sEKyDLzFGL+otvLMsSQtktPk=;
        b=cYELzzVZ4A+ecL6S48jKnKjySh/tIOMCmPV3aej+MEGcMyapExxZ7+DhlrkyhBlNOx
         KqR4Yx4BHt6VKERCbPcfp5B/+OU1pLN2Ru8reyNwVcl/hnDNAzQJVXP8X78NIOctCoxk
         gCG9RMMYJuBdU/DBBGzFbdtE0w+/8tgTv7s+rKH2Wab1Tm2Q6glHBT1zJC55+W2rRdXc
         5ynueqJsFlAnVwXQwald+MSVWeAqFAwPnsVqCLpwxItNEgZrzIGEEF3+me2j4cXq8MWG
         u4imUTvBIYwuBT/3gwHTkdt55ecx4iJK/G2dNuRSunsudy8aGwvx7HxYvKabV7ePzvt3
         vBDQ==
X-Gm-Message-State: AFqh2krpUk/ZYICW4JDyBdH3dQyY98YMXZS3SQ+u47J/DTNQZb64EUNy
        n41ZgcPOhqzVLa85sNfn9J+beAJAg7WfgjwjUn9PXw==
X-Google-Smtp-Source: AMrXdXvdmYk7quFXGQOA5EknUz0DTvcQzPAtiYi12Xz7pX78nsjcB3HDtqEeq2c4qtqFRE8Wk7cGXvpDdS7ljYio8vA=
X-Received: by 2002:a17:906:25c5:b0:86d:fa64:2941 with SMTP id
 n5-20020a17090625c500b0086dfa642941mr7445534ejb.72.1674995457818; Sun, 29 Jan
 2023 04:30:57 -0800 (PST)
MIME-Version: 1.0
References: <20230127182558.2416400-1-atishp@rivosinc.com> <20230127182558.2416400-8-atishp@rivosinc.com>
In-Reply-To: <20230127182558.2416400-8-atishp@rivosinc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Sun, 29 Jan 2023 18:00:46 +0530
Message-ID: <CAAhSdy1P=u4a-4t8kn2Pa3Zs+Njai36QV9hBrwYk8zkhdR8r5g@mail.gmail.com>
Subject: Re: [PATCH v3 07/14] RISC-V: KVM: Add skeleton support for perf
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Jones <ajones@ventanamicro.com>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 27, 2023 at 11:56 PM Atish Patra <atishp@rivosinc.com> wrote:
>
> This patch only adds barebore structure of perf implementation. Most of

s/barebore/barebone/

> the function returns zero at this point and will be implemented
> fully in the future.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/kvm_host.h     |   3 +
>  arch/riscv/include/asm/kvm_vcpu_pmu.h |  76 ++++++++++++++
>  arch/riscv/kvm/Makefile               |   1 +
>  arch/riscv/kvm/vcpu.c                 |   5 +
>  arch/riscv/kvm/vcpu_pmu.c             | 145 ++++++++++++++++++++++++++
>  5 files changed, 230 insertions(+)
>  create mode 100644 arch/riscv/include/asm/kvm_vcpu_pmu.h
>  create mode 100644 arch/riscv/kvm/vcpu_pmu.c
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 93f43a3..f9874b4 100644
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
> @@ -228,6 +229,8 @@ struct kvm_vcpu_arch {
>
>         /* Don't run the VCPU (blocked) */
>         bool pause;
> +
> +       struct kvm_pmu pmu;

Add a single line comment just like other members of the structure.

I also suggest naming this variable "pmu_context" or something similar
for naming consistency.

>  };
>
>  static inline void kvm_arch_hardware_unsetup(void) {}
> diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> new file mode 100644
> index 0000000..3f43a43
> --- /dev/null
> +++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> @@ -0,0 +1,76 @@
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
> +#define RISCV_KVM_MAX_FW_CTRS 32
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
> +#define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu)
> +#define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu))
> +
> +int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, struct kvm_vcpu_sbi_ext_data *edata);
> +int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
> +                               struct kvm_vcpu_sbi_ext_data *edata);
> +int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> +                                unsigned long ctr_mask, unsigned long flag, uint64_t ival,
> +                                struct kvm_vcpu_sbi_ext_data *edata);
> +int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> +                               unsigned long ctr_mask, unsigned long flag,
> +                               struct kvm_vcpu_sbi_ext_data *edata);
> +int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> +                                    unsigned long ctr_mask, unsigned long flag,
> +                                    unsigned long eidx, uint64_t evtdata,
> +                                    struct kvm_vcpu_sbi_ext_data *edata);
> +int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
> +                               struct kvm_vcpu_sbi_ext_data *edata);
> +int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu);
> +void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu);
> +void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu);
> +
> +#else
> +struct kvm_pmu {
> +};
> +
> +static inline int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
> +{
> +       return 0;
> +}
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
> index 7c08567..b746f21 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -137,6 +137,7 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
>
>         WRITE_ONCE(vcpu->arch.irqs_pending, 0);
>         WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);

Add an empty newline here.

> +       kvm_riscv_vcpu_pmu_reset(vcpu);
>
>         vcpu->arch.hfence_head = 0;
>         vcpu->arch.hfence_tail = 0;
> @@ -194,6 +195,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>         /* Setup VCPU timer */
>         kvm_riscv_vcpu_timer_init(vcpu);
>
> +       /* setup performance monitoring */
> +       kvm_riscv_vcpu_pmu_init(vcpu);
> +
>         /* Reset VCPU */
>         kvm_riscv_reset_vcpu(vcpu);
>
> @@ -216,6 +220,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>         /* Cleanup VCPU timer */
>         kvm_riscv_vcpu_timer_deinit(vcpu);
>
> +       kvm_riscv_vcpu_pmu_deinit(vcpu);

Add an empty newline here.

>         /* Free unused pages pre-allocated for G-stage page table mappings */
>         kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
>  }
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> new file mode 100644
> index 0000000..d3fd551
> --- /dev/null
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -0,0 +1,145 @@
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
> +int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, struct kvm_vcpu_sbi_ext_data *edata)
> +{
> +       struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +
> +       edata->out_val = kvm_pmu_num_counters(kvpmu);
> +
> +       return 0;
> +}
> +
> +int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
> +                               struct kvm_vcpu_sbi_ext_data *edata)
> +{
> +       struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +
> +       if (cidx > RISCV_MAX_COUNTERS || cidx == 1) {
> +               edata->err_val = SBI_ERR_INVALID_PARAM;
> +               return 0;
> +       }
> +
> +       edata->out_val = kvpmu->pmc[cidx].cinfo.value;
> +
> +       return 0;
> +}
> +
> +int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> +                                unsigned long ctr_mask, unsigned long flag, uint64_t ival,
> +                                struct kvm_vcpu_sbi_ext_data *edata)
> +{
> +       /* TODO */
> +       return 0;
> +}
> +
> +int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> +                               unsigned long ctr_mask, unsigned long flag,
> +                               struct kvm_vcpu_sbi_ext_data *edata)
> +{
> +       /* TODO */
> +       return 0;
> +}
> +
> +int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> +                                    unsigned long ctr_mask, unsigned long flag,
> +                                    unsigned long eidx, uint64_t evtdata,
> +                                    struct kvm_vcpu_sbi_ext_data *edata)
> +{
> +       /* TODO */
> +       return 0;
> +}
> +
> +int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
> +                               struct kvm_vcpu_sbi_ext_data *edata)
> +{
> +       /* TODO */
> +       return 0;
> +}
> +
> +int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
> +{
> +       int i = 0, num_fw_ctrs, ret, num_hw_ctrs = 0, hpm_width = 0;
> +       struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +       struct kvm_pmc *pmc;
> +
> +       ret = riscv_pmu_get_hpm_info(&hpm_width, &num_hw_ctrs);
> +       if (ret < 0)
> +               return ret;
> +
> +       if (!hpm_width || !num_hw_ctrs) {
> +               pr_err("Cannot initialize VCPU with NULL hpmcounter width or number of counters\n");

What will happen if underlying M-mode firmware does not implement
SBI PMU extension ?

> +               return -EINVAL;
> +       }
> +
> +       if ((num_hw_ctrs + RISCV_KVM_MAX_FW_CTRS) > RISCV_MAX_COUNTERS) {
> +               pr_warn("Limiting fw counters as hw & fw counters exceed maximum counters\n");

How is this possible ?

Maximum HW counters is 32 (including time, cycle, and instret),
RISCV_KVM_MAX_FW_CTRS = 32, and
RISCV_MAX_COUNTERS = 64

> +               num_fw_ctrs = RISCV_MAX_COUNTERS - num_hw_ctrs;
> +       } else
> +               num_fw_ctrs = RISCV_KVM_MAX_FW_CTRS;
> +
> +       kvpmu->num_hw_ctrs = num_hw_ctrs;
> +       kvpmu->num_fw_ctrs = num_fw_ctrs;
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
> +                       kvpmu->pmc[i].cinfo.type = SBI_PMU_CTR_TYPE_HW;
> +                       if (i < 3)
> +                               /* CY, IR counters */
> +                               kvpmu->pmc[i].cinfo.width = 63;
> +                       else
> +                               kvpmu->pmc[i].cinfo.width = hpm_width;
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
> +
> +       return 0;
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

Regards,
Anup
