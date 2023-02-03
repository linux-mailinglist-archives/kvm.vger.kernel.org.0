Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34B646892A0
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 09:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbjBCIrm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 03:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbjBCIrl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 03:47:41 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80DD584F9B
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 00:47:39 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id 141so3213729pgc.0
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 00:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YLIGlrDvLBHkMp12DzvuAdmrifvGeQa/SJZdzkO0+I8=;
        b=J4e4Gtvo/CUsIZ6Q8lE8YAc3YACloAqE+yPsy+hXg7oJKPAKud3lU5CtcliSjGf9to
         fHwQXNIvugJnpGR3d57eFy7qpGYSh1fDzbRimZRZ5vG5swRWra+d5N/5PTBM8p2SmqHo
         /snsAhCQlWKUPdUm3FYDgsXqRy68dL4oqwcDo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YLIGlrDvLBHkMp12DzvuAdmrifvGeQa/SJZdzkO0+I8=;
        b=B2Iadu1wfNG86ozpiXEtpwUeNjDQnSR7Uy8PyFIav8sqzh5M3ub82XYxiaRZxx1PXA
         NZ/MdD4AEHla/0vPAEZRK8TvPRjy4C5YN2RJ2uTfcVBlkVySGHi4t0zNtRVCG4/tuwtR
         3tW2hFgzkT5NX1d8/QRC4obiRp3DE1LeRfgBwztIbLTfxz25FkRAIRy8ifY9IGU6MAD/
         hC7LFYHWTzV9F/pbDaw1owqLWZlFa9bc0IVqakZjd9BHH597ugQFaZ0oInOeV8Qv6XoN
         QLsf6a7TULVzrBfMRo3pnXatUBYloXq/4InC7zSlgxZ6IQNH/Hbur96v5XE6dckfAttS
         5jLA==
X-Gm-Message-State: AO0yUKUipKJ8swfvcVt3dJC27DWwWHSkL25oi9plxR4+bnSXBcUtMFQj
        zi+OceseB/5Lykng4htpJMemC1YmzDr64rZCtNtl
X-Google-Smtp-Source: AK7set81cTVO4MDrU89ipqLMeWlMsn73sidftGcwdL/VccrDnQEhzgZiZ/JD3egiJUbJbuU1+1ny33blARlRCn3Tujg=
X-Received: by 2002:a62:e30c:0:b0:592:8390:8b97 with SMTP id
 g12-20020a62e30c000000b0059283908b97mr1876871pfh.15.1675414058953; Fri, 03
 Feb 2023 00:47:38 -0800 (PST)
MIME-Version: 1.0
References: <20230201231250.3806412-1-atishp@rivosinc.com> <20230201231250.3806412-8-atishp@rivosinc.com>
 <20230202170345.uwi72dauzunlzxex@orel>
In-Reply-To: <20230202170345.uwi72dauzunlzxex@orel>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Fri, 3 Feb 2023 00:47:27 -0800
Message-ID: <CAOnJCUJfc8y729GiUdtqhv+PZu8v9rH+kfpwPwdW=GQPEs9FNw@mail.gmail.com>
Subject: Re: [PATCH v4 07/14] RISC-V: KVM: Add skeleton support for perf
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     Atish Patra <atishp@rivosinc.com>, linux-kernel@vger.kernel.org,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Eric Lin <eric.lin@sifive.com>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 2, 2023 at 9:03 AM Andrew Jones <ajones@ventanamicro.com> wrote:
>
> On Wed, Feb 01, 2023 at 03:12:43PM -0800, Atish Patra wrote:
> > This patch only adds barebone structure of perf implementation. Most of
> > the function returns zero at this point and will be implemented
> > fully in the future.
> >
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> >  arch/riscv/include/asm/kvm_host.h     |   4 +
> >  arch/riscv/include/asm/kvm_vcpu_pmu.h |  78 +++++++++++++++
> >  arch/riscv/kvm/Makefile               |   1 +
> >  arch/riscv/kvm/vcpu.c                 |   7 ++
> >  arch/riscv/kvm/vcpu_pmu.c             | 136 ++++++++++++++++++++++++++
> >  5 files changed, 226 insertions(+)
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
> > index 0000000..e2b4038
> > --- /dev/null
> > +++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> > @@ -0,0 +1,78 @@
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
> > +
> > +#if RISCV_KVM_MAX_FW_CTRS > 32
> > +#error "Maximum firmware counter can't exceed 32 without increasing the RISCV_MAX_COUNTERS"
>
> "The number of firmware counters cannot exceed 32 without increasing RISCV_MAX_COUNTERS"
>
> > +#endif
> > +
> > +#define RISCV_MAX_COUNTERS      64
>
> But instead of that message, what I think we need is something like
>
>  #define RISCV_KVM_MAX_HW_CTRS  32
>  #define RISCV_KVM_MAX_FW_CTRS  32
>  #define RISCV_MAX_COUNTERS     (RISCV_KVM_MAX_HW_CTRS + RISCV_KVM_MAX_FW_CTRS)
>
>  static_assert(RISCV_MAX_COUNTERS <= 64)
>
> And then in pmu_sbi_device_probe() should ensure
>
>   num_counters <= RISCV_MAX_COUNTERS
>
> and pmu_sbi_get_ctrinfo() should ensure
>
>   num_hw_ctr <= RISCV_KVM_MAX_HW_CTRS
>   num_fw_ctr <= RISCV_KVM_MAX_FW_CTRS
>
> which has to be done at runtime.
>

Sure. I will add the additional sanity checks.

> > +
> > +/* Per virtual pmu counter data */
> > +struct kvm_pmc {
> > +     u8 idx;
> > +     struct perf_event *perf_event;
> > +     uint64_t counter_val;
> > +     union sbi_pmu_ctr_info cinfo;
> > +     /* Event monitoring status */
> > +     bool started;
> > +};
> > +
> > +/* PMU data structure per vcpu */
> > +struct kvm_pmu {
> > +     struct kvm_pmc pmc[RISCV_MAX_COUNTERS];
> > +     /* Number of the virtual firmware counters available */
> > +     int num_fw_ctrs;
> > +     /* Number of the virtual hardware counters available */
> > +     int num_hw_ctrs;
> > +     /* A flag to indicate that pmu initialization is done */
> > +     bool init_done;
> > +     /* Bit map of all the virtual counter used */
> > +     DECLARE_BITMAP(pmc_in_use, RISCV_MAX_COUNTERS);
> > +};
> > +
> > +#define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu_context)
> > +#define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu_context))
> > +
> > +int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, struct kvm_vcpu_sbi_return *retdata);
> > +int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
> > +                             struct kvm_vcpu_sbi_return *retdata);
> > +int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> > +                              unsigned long ctr_mask, unsigned long flag, uint64_t ival,
> > +                              struct kvm_vcpu_sbi_return *retdata);
> > +int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> > +                             unsigned long ctr_mask, unsigned long flag,
> > +                             struct kvm_vcpu_sbi_return *retdata);
> > +int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> > +                                  unsigned long ctr_mask, unsigned long flag,
> > +                                  unsigned long eidx, uint64_t evtdata,
> > +                                  struct kvm_vcpu_sbi_return *retdata);
>
> s/flag/flags/ for all the above prototypes and all the implementations
> below.
>

Fixed.

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
> > index 0000000..2dad37f
> > --- /dev/null
> > +++ b/arch/riscv/kvm/vcpu_pmu.c
> > @@ -0,0 +1,136 @@
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
> > +     if (cidx > RISCV_MAX_COUNTERS || cidx == 1) {
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
> > +                              unsigned long ctr_mask, unsigned long flag, uint64_t ival,
> > +                              struct kvm_vcpu_sbi_return *retdata)
> > +{
> > +     /* TODO */
> > +     return 0;
> > +}
> > +
> > +int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> > +                             unsigned long ctr_mask, unsigned long flag,
> > +                             struct kvm_vcpu_sbi_return *retdata)
> > +{
> > +     /* TODO */
> > +     return 0;
> > +}
> > +
> > +int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> > +                                  unsigned long ctr_mask, unsigned long flag,
> > +                                  unsigned long eidx, uint64_t evtdata,
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
> > +
> > +     /*
> > +      * It is guranteed that RISCV_KVM_MAX_FW_CTRS can't exceed 32 as
> > +      * that may exceed total number of counters more than RISCV_MAX_COUNTERS
> > +      */
> > +     kvpmu->num_hw_ctrs = num_hw_ctrs;
> > +     kvpmu->num_fw_ctrs = RISCV_KVM_MAX_FW_CTRS;
>
> If we sanity check that num_hw_ctrs <= 32 and num_fw_ctrs <= 32 at sbi_pmu
> probe time, then we can also return num_fw_ctrs (or num_ctrs) along with
> num_hw_ctrs from riscv_pmu_get_hpm_info(). Then, we can put the exact
> number here into kvmpmu->num_fw_ctrs, rather than using its max.
>

The firmware counter information retrieved from PMU driver will be the
number of firmware
counter host supports (i.e. M-mode firmware supports). The number of
counters supported for a
guest is entirely up to the hypervisor. There shouldn't be any
relation with the host's firmware counter.

Looking at it again, we should probably set kvpmu->num_fw_ctrs to
SBI_PMU_FW_MAX instead of RISCV_KVM_MAX_FW_CTRS.
We already have a sanity check for SBI_PMU_FW_MAX in the code.
> > +
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



-- 
Regards,
Atish
