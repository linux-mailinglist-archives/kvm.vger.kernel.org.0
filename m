Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F22468DC45
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 15:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbjBGO5T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 09:57:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjBGO5R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 09:57:17 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2E41259A
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 06:57:15 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id v13so15818285eda.11
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 06:57:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wKdna/qIh4gNiOALCQ6oDoEjUI1nHMgPmlGIzHYLyjo=;
        b=G/MGj9AO77jdZtn8vwJWKNLMB2XZi5SD11nBPiczJdmvblximA26YW+lggOUBCTftm
         YyhCogpvXJ4vwhYDjpZcYllCK/KEjuWSyG7EWS3uV7HdrC1+NWFO1Uq+6Hxc1iVysJBb
         YzEP5RmE6VipkBNCjSJd8NBUao3MwMCfS1VUHMchaARiGVBd94PFcIxi8KdaPaQ1zzeX
         NVQUkOyOq2T5mygGekHuMtqkTRhcA3vlHlDKbBpKKJ3PB5DwIEvXB2bhcx6u23jS5TpZ
         eBjiXR4m5KBrSq31b9QvfS6a+SjB+ArC0MCnY+JrTQEgd5/2NvLC5mNHfcgBd6Gh5sGt
         aUmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wKdna/qIh4gNiOALCQ6oDoEjUI1nHMgPmlGIzHYLyjo=;
        b=7uCXbz4iBW1VpzjFMLOAgJ61b/RYeWxjYpjr2EKcLtGu1KrtLNFPeVjK2HYUJNz1nY
         obDf4Z9DMOAjR8VKQGtL5KSNbmFPXo/nDcY6SjPVx5cQXAxk/kfmxkcOaG5scz/8iah6
         VuiBx22l/dYsAnDxeBCfD3lqwnHrsOrMK/swCNEz4+UtCYtw5ihMNuu2iaS3Z/MpSEEA
         944654tKCEA60V0DzKoO9A5+nbu3qIeSjTmCtEDID9icP7LrVHKoZ4ANW9jksu8Wvvlk
         NClq+nRGkYy1Cw8TystyshSwIRp7jUEkWELUd1OExrpao2N43sMYtmQDwioNKDSzq+00
         kOmg==
X-Gm-Message-State: AO0yUKUeDLckGoyUKxG+ahwoTQru6fHmG6/1FFEo/0g+EFUK26/vuBU/
        GqcvXSOsfVWFd4k0fCTy9yzTIlJYz3jp9QahT4SQfg==
X-Google-Smtp-Source: AK7set8ZTGav0B2O8UxAjGzwtzjm1lGm0utQ5nERgPZboStE5Hmr8P8RiycGqYwDzyZT5SzOvKZwIcTCK1eXc1i4ZOQ=
X-Received: by 2002:a50:f69c:0:b0:47d:ed8a:af80 with SMTP id
 d28-20020a50f69c000000b0047ded8aaf80mr683873edn.3.1675781834323; Tue, 07 Feb
 2023 06:57:14 -0800 (PST)
MIME-Version: 1.0
References: <20230207095529.1787260-1-atishp@rivosinc.com> <20230207095529.1787260-2-atishp@rivosinc.com>
 <20230207103727.jqgkyugsufgmsjrt@orel>
In-Reply-To: <20230207103727.jqgkyugsufgmsjrt@orel>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 7 Feb 2023 20:27:03 +0530
Message-ID: <CAAhSdy0f7K5G_v_54jABAUr5dEcWsNLMNGTYXHaDbit71bqZvQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/8] RISC-V: KVM: Add skeleton support for perf
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     Atish Patra <atishp@rivosinc.com>, linux-kernel@vger.kernel.org,
        Atish Patra <atishp@atishpatra.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On Tue, Feb 7, 2023 at 4:07 PM Andrew Jones <ajones@ventanamicro.com> wrote:
>
> On Tue, Feb 07, 2023 at 01:55:22AM -0800, Atish Patra wrote:
> > This patch only adds barebone structure of perf implementation. Most of
> > the function returns zero at this point and will be implemented
> > fully in the future.
> >
> > Reviewed-by: Anup Patel <anup@brainfault.org>
> > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>

I will address your comments at the time of merging this patch.

Thanks,
Anup

> > ---
> >  arch/riscv/include/asm/kvm_host.h     |   4 +
> >  arch/riscv/include/asm/kvm_vcpu_pmu.h |  75 ++++++++++++++
> >  arch/riscv/kvm/Makefile               |   1 +
> >  arch/riscv/kvm/vcpu.c                 |   7 ++
> >  arch/riscv/kvm/vcpu_pmu.c             | 138 ++++++++++++++++++++++++++
> >  5 files changed, 225 insertions(+)
> >  create mode 100644 arch/riscv/include/asm/kvm_vcpu_pmu.h
> >  create mode 100644 arch/riscv/kvm/vcpu_pmu.c
> >
> > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> > index 93f43a3..b90be9a 100644
> > --- a/arch/riscv/include/asm/kvm_host.h
> > +++ b/arch/riscv/include/asm/kvm_host.h
> > @@ -18,6 +18,7 @@
> >  #include <asm/kvm_vcpu_insn.h>
> >  #include <asm/kvm_vcpu_sbi.h>
> >  #include <asm/kvm_vcpu_timer.h>
> > +#include <asm/kvm_vcpu_pmu.h>
> >
> >  #define KVM_MAX_VCPUS                        1024
> >
> > @@ -228,6 +229,9 @@ struct kvm_vcpu_arch {
> >
> >       /* Don't run the VCPU (blocked) */
> >       bool pause;
> > +
> > +     /* Performance monitoring context */
> > +     struct kvm_pmu pmu_context;
> >  };
> >
> >  static inline void kvm_arch_hardware_unsetup(void) {}
> > diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> > new file mode 100644
> > index 0000000..0b86a47
> > --- /dev/null
> > +++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> > @@ -0,0 +1,75 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * Copyright (c) 2023 Rivos Inc
> > + *
> > + * Authors:
> > + *     Atish Patra <atishp@rivosinc.com>
> > + */
> > +
> > +#ifndef __KVM_VCPU_RISCV_PMU_H
> > +#define __KVM_VCPU_RISCV_PMU_H
> > +
> > +#include <linux/perf/riscv_pmu.h>
> > +#include <asm/kvm_vcpu_sbi.h>
> > +#include <asm/sbi.h>
> > +
> > +#ifdef CONFIG_RISCV_PMU_SBI
> > +#define RISCV_KVM_MAX_FW_CTRS        32
> > +#define RISCV_KVM_MAX_HW_CTRS        32
> > +#define RISCV_KVM_MAX_COUNTERS       (RISCV_KVM_MAX_HW_CTRS + RISCV_KVM_MAX_FW_CTRS)
> > +static_assert(RISCV_KVM_MAX_COUNTERS <= 64);
> > +
> > +/* Per virtual pmu counter data */
> > +struct kvm_pmc {
> > +     u8 idx;
> > +     struct perf_event *perf_event;
> > +     u64 counter_val;
> > +     union sbi_pmu_ctr_info cinfo;
> > +     /* Event monitoring status */
> > +     bool started;
> > +};
> > +
> > +/* PMU data structure per vcpu */
> > +struct kvm_pmu {
> > +     struct kvm_pmc pmc[RISCV_KVM_MAX_COUNTERS];
> > +     /* Number of the virtual firmware counters available */
> > +     int num_fw_ctrs;
> > +     /* Number of the virtual hardware counters available */
> > +     int num_hw_ctrs;
> > +     /* A flag to indicate that pmu initialization is done */
> > +     bool init_done;
> > +     /* Bit map of all the virtual counter used */
> > +     DECLARE_BITMAP(pmc_in_use, RISCV_KVM_MAX_COUNTERS);
> > +};
> > +
> > +#define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu_context)
> > +#define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu_context))
> > +
> > +int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, struct kvm_vcpu_sbi_return *retdata);
> > +int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
> > +                             struct kvm_vcpu_sbi_return *retdata);
> > +int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> > +                              unsigned long ctr_mask, unsigned long flags, u64 ival,
> > +                              struct kvm_vcpu_sbi_return *retdata);
> > +int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> > +                             unsigned long ctr_mask, unsigned long flags,
> > +                             struct kvm_vcpu_sbi_return *retdata);
> > +int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> > +                                  unsigned long ctr_mask, unsigned long flags,
> > +                                  unsigned long eidx, u64 evtdata,
> > +                                  struct kvm_vcpu_sbi_return *retdata);
> > +int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
> > +                             struct kvm_vcpu_sbi_return *retdata);
> > +void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu);
> > +void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu);
> > +void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu);
> > +
> > +#else
> > +struct kvm_pmu {
> > +};
> > +
> > +static inline void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu) {}
> > +static inline void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu) {}
> > +static inline void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu) {}
> > +#endif /* CONFIG_RISCV_PMU_SBI */
> > +#endif /* !__KVM_VCPU_RISCV_PMU_H */
> > diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> > index 019df920..5de1053 100644
> > --- a/arch/riscv/kvm/Makefile
> > +++ b/arch/riscv/kvm/Makefile
> > @@ -25,3 +25,4 @@ kvm-y += vcpu_sbi_base.o
> >  kvm-y += vcpu_sbi_replace.o
> >  kvm-y += vcpu_sbi_hsm.o
> >  kvm-y += vcpu_timer.o
> > +kvm-$(CONFIG_RISCV_PMU_SBI) += vcpu_pmu.o
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > index 7c08567..7d010b0 100644
> > --- a/arch/riscv/kvm/vcpu.c
> > +++ b/arch/riscv/kvm/vcpu.c
> > @@ -138,6 +138,8 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
> >       WRITE_ONCE(vcpu->arch.irqs_pending, 0);
> >       WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
> >
> > +     kvm_riscv_vcpu_pmu_reset(vcpu);
> > +
> >       vcpu->arch.hfence_head = 0;
> >       vcpu->arch.hfence_tail = 0;
> >       memset(vcpu->arch.hfence_queue, 0, sizeof(vcpu->arch.hfence_queue));
> > @@ -194,6 +196,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> >       /* Setup VCPU timer */
> >       kvm_riscv_vcpu_timer_init(vcpu);
> >
> > +     /* setup performance monitoring */
> > +     kvm_riscv_vcpu_pmu_init(vcpu);
> > +
> >       /* Reset VCPU */
> >       kvm_riscv_reset_vcpu(vcpu);
> >
> > @@ -216,6 +221,8 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
> >       /* Cleanup VCPU timer */
> >       kvm_riscv_vcpu_timer_deinit(vcpu);
> >
> > +     kvm_riscv_vcpu_pmu_deinit(vcpu);
> > +
> >       /* Free unused pages pre-allocated for G-stage page table mappings */
> >       kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
> >  }
> > diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> > new file mode 100644
> > index 0000000..e79721b
> > --- /dev/null
> > +++ b/arch/riscv/kvm/vcpu_pmu.c
> > @@ -0,0 +1,138 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (c) 2023 Rivos Inc
> > + *
> > + * Authors:
> > + *     Atish Patra <atishp@rivosinc.com>
> > + */
> > +
> > +#include <linux/errno.h>
> > +#include <linux/err.h>
> > +#include <linux/kvm_host.h>
> > +#include <linux/perf/riscv_pmu.h>
> > +#include <asm/csr.h>
> > +#include <asm/kvm_vcpu_sbi.h>
> > +#include <asm/kvm_vcpu_pmu.h>
> > +#include <linux/kvm_host.h>
> > +
> > +#define kvm_pmu_num_counters(pmu) ((pmu)->num_hw_ctrs + (pmu)->num_fw_ctrs)
> > +
> > +int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, struct kvm_vcpu_sbi_return *retdata)
> > +{
> > +     struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> > +
> > +     retdata->out_val = kvm_pmu_num_counters(kvpmu);
> > +
> > +     return 0;
> > +}
> > +
> > +int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
> > +                             struct kvm_vcpu_sbi_return *retdata)
> > +{
> > +     struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> > +
> > +     if (cidx > RISCV_KVM_MAX_COUNTERS || cidx == 1) {
> > +             retdata->err_val = SBI_ERR_INVALID_PARAM;
> > +             return 0;
> > +     }
> > +
> > +     retdata->out_val = kvpmu->pmc[cidx].cinfo.value;
> > +
> > +     return 0;
> > +}
> > +
> > +int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> > +                              unsigned long ctr_mask, unsigned long flags, u64 ival,
> > +                              struct kvm_vcpu_sbi_return *retdata)
> > +{
> > +     /* TODO */
> > +     return 0;
> > +}
> > +
> > +int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> > +                             unsigned long ctr_mask, unsigned long flags,
> > +                             struct kvm_vcpu_sbi_return *retdata)
> > +{
> > +     /* TODO */
> > +     return 0;
> > +}
> > +
> > +int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> > +                                  unsigned long ctr_mask, unsigned long flags,
> > +                                  unsigned long eidx, u64 evtdata,
> > +                                  struct kvm_vcpu_sbi_return *retdata)
> > +{
> > +     /* TODO */
> > +     return 0;
> > +}
> > +
> > +int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
> > +                             struct kvm_vcpu_sbi_return *retdata)
> > +{
> > +     /* TODO */
> > +     return 0;
> > +}
> > +
> > +void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
> > +{
> > +     int i = 0, ret, num_hw_ctrs = 0, hpm_width = 0;
> > +     struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> > +     struct kvm_pmc *pmc;
> > +
> > +     ret = riscv_pmu_get_hpm_info(&hpm_width, &num_hw_ctrs);
> > +     if (ret < 0 || !hpm_width || !num_hw_ctrs)
> > +             return;
>
> need blank line here
>
> > +     /*
> > +      * Increase the number of hardware counters to offset the time counter.
> > +      */
> > +     kvpmu->num_hw_ctrs = num_hw_ctrs + 1;
> > +     kvpmu->num_fw_ctrs = SBI_PMU_FW_MAX;
> > +
> > +     if (kvpmu->num_hw_ctrs > RISCV_KVM_MAX_HW_CTRS) {
> > +             pr_warn("Limiting the hardware counters to 32 as specified by the ISA");
>
> pr_warn_once() and we need to set the prefix.
>
> > +             kvpmu->num_hw_ctrs = RISCV_KVM_MAX_HW_CTRS;
> > +     }
>
> need blank line here
>
> > +     /*
> > +      * There is no correlation between the logical hardware counter and virtual counters.
> > +      * However, we need to encode a hpmcounter CSR in the counter info field so that
> > +      * KVM can trap n emulate the read. This works well in the migration use case as
> > +      * KVM doesn't care if the actual hpmcounter is available in the hardware or not.
> > +      */
> > +     for (i = 0; i < kvm_pmu_num_counters(kvpmu); i++) {
> > +             /* TIME CSR shouldn't be read from perf interface */
> > +             if (i == 1)
> > +                     continue;
> > +             pmc = &kvpmu->pmc[i];
> > +             pmc->idx = i;
> > +             if (i < kvpmu->num_hw_ctrs) {
> > +                     pmc->cinfo.type = SBI_PMU_CTR_TYPE_HW;
> > +                     if (i < 3)
> > +                             /* CY, IR counters */
> > +                             pmc->cinfo.width = 63;
> > +                     else
> > +                             pmc->cinfo.width = hpm_width;
> > +                     /*
> > +                      * The CSR number doesn't have any relation with the logical
> > +                      * hardware counters. The CSR numbers are encoded sequentially
> > +                      * to avoid maintaining a map between the virtual counter
> > +                      * and CSR number.
> > +                      */
> > +                     pmc->cinfo.csr = CSR_CYCLE + i;
> > +             } else {
> > +                     pmc->cinfo.type = SBI_PMU_CTR_TYPE_FW;
> > +                     pmc->cinfo.width = BITS_PER_LONG - 1;
> > +             }
> > +     }
> > +
> > +     kvpmu->init_done = true;
> > +}
> > +
> > +void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu)
> > +{
> > +     /* TODO */
> > +}
> > +
> > +void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu)
> > +{
> > +     kvm_riscv_vcpu_pmu_deinit(vcpu);
> > +}
> > --
> > 2.25.1
> >
>
> Thanks,
> drew
