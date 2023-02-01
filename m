Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA4D686254
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 10:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbjBAJGJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 04:06:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjBAJGH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 04:06:07 -0500
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F687303DD
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 01:06:02 -0800 (PST)
Received: by mail-vk1-xa34.google.com with SMTP id u199so8245023vkb.12
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 01:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lBsCdefAjfDxyY4lolsg2sBwyIeym18LQ2XkPg2nCyM=;
        b=Ow2GYEL6iy7XA5uet/kJuwyaMqV/AsIS+dRAGhTHUJINyYFYfjzvSfa5y/iB4faZ14
         K1rT1zxGf7YDxnfUz86zBeCmwu4NBQQLdo8q8KSH55QNz9iuJVeKwsyqv40d9IUqN2cl
         +VUDHi8WH1/79kjmolZf/49C9dBp5GQ2iwoyKg5JSxClYWx5oIiOa/5AmMX7JjhhS903
         h4kWAWzZWrTS1aNjbc6EeKW75TFafYtR8/XM1oi/hbJxBvm3Rj920g9fYs7u+5rTBEr1
         GzgcpxwoOUgd1mh2D2iGksV9hJlEPop9eH21H2EpNzP/GovpRz0+L7215eSxEeGMlCYo
         HLJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lBsCdefAjfDxyY4lolsg2sBwyIeym18LQ2XkPg2nCyM=;
        b=VobMNOKdN6b1MFeCqrZeGQt1ooyA/hCSDZGlK0sVvCpE3OCTdXjocmPydFW5CLgcfj
         BDoUXrEPG9tXLPJle+ZYmjPTkKicd+O75No6fMRTMoy1k5N4gsCeAMhRQh/Zwy1oIlpb
         rOPSX0i0S0txi5lQZDxBZ55JZkViQ2xs67TCRT4tnY86d/NzbS1z0BWumgx+ixTbXoMt
         yb4RnsFLITVy18hlolULu0BPXBxQ3/E7PPapouYzN8P70FU9CJPXLGrbfBW5HrAsIJhM
         dtXlm3t7OQdAJMo7zdWwvY8VA7dsDWGJ+eQCll+Gjj9jegla8CWq8hnAMY/DqYe4fygN
         ucAg==
X-Gm-Message-State: AO0yUKV3Bj5OpdtV49pd8+JnI8e7zsLWJTCnVUmzHQ4iVE6Nz/GiDDwL
        5H5AqZkP+PiGKQoZRLd5I0ym2RgKR1lT+qBhFnPxLw==
X-Google-Smtp-Source: AK7set+H009S0LM8c1MvW8AkvJZOkTefOVoQpweqdrWVATCxy+FIxHcuOzqjBWXl1jHofRsCphyE69NDnisYKsRE+Vs=
X-Received: by 2002:a05:6122:e4f:b0:3e7:c4e5:3ccb with SMTP id
 bj15-20020a0561220e4f00b003e7c4e53ccbmr219554vkb.1.1675242361247; Wed, 01 Feb
 2023 01:06:01 -0800 (PST)
MIME-Version: 1.0
References: <20230127182558.2416400-1-atishp@rivosinc.com> <20230127182558.2416400-8-atishp@rivosinc.com>
 <CAAhSdy1P=u4a-4t8kn2Pa3Zs+Njai36QV9hBrwYk8zkhdR8r5g@mail.gmail.com>
 <CAOnJCUK+Ht10utv=18jET=sUTR5660Sm5Tf+e0zyQjUJ9m10_Q@mail.gmail.com>
 <CAK9=C2X11WuN4rr+7fesn-mP8dp-thX0gLWCNn3eObWUUYfoEA@mail.gmail.com> <CAOnJCUJC61n0W-smZLMiMaNv8qZ1hKBxxAQCvEQkQ0a7FHWj6w@mail.gmail.com>
In-Reply-To: <CAOnJCUJC61n0W-smZLMiMaNv8qZ1hKBxxAQCvEQkQ0a7FHWj6w@mail.gmail.com>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Wed, 1 Feb 2023 14:35:50 +0530
Message-ID: <CAK9=C2UyOMd6YfkVuUPmhOFsHc77qGw-M3O3HBNbRK4=RSwODg@mail.gmail.com>
Subject: Re: [PATCH v3 07/14] RISC-V: KVM: Add skeleton support for perf
To:     Atish Patra <atishp@atishpatra.org>
Cc:     Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@rivosinc.com>,
        linux-kernel@vger.kernel.org,
        Andrew Jones <ajones@ventanamicro.com>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
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

On Wed, Feb 1, 2023 at 2:11 PM Atish Patra <atishp@atishpatra.org> wrote:
>
> On Tue, Jan 31, 2023 at 7:48 PM Anup Patel <apatel@ventanamicro.com> wrote:
> >
> > On Wed, Feb 1, 2023 at 4:05 AM Atish Patra <atishp@atishpatra.org> wrote:
> > >
> > > On Sun, Jan 29, 2023 at 4:30 AM Anup Patel <anup@brainfault.org> wrote:
> > > >
> > > > On Fri, Jan 27, 2023 at 11:56 PM Atish Patra <atishp@rivosinc.com> wrote:
> > > > >
> > > > > This patch only adds barebore structure of perf implementation. Most of
> > > >
> > > > s/barebore/barebone/
> > > >
> > > > > the function returns zero at this point and will be implemented
> > > > > fully in the future.
> > > > >
> > > > > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > > > > ---
> > > > >  arch/riscv/include/asm/kvm_host.h     |   3 +
> > > > >  arch/riscv/include/asm/kvm_vcpu_pmu.h |  76 ++++++++++++++
> > > > >  arch/riscv/kvm/Makefile               |   1 +
> > > > >  arch/riscv/kvm/vcpu.c                 |   5 +
> > > > >  arch/riscv/kvm/vcpu_pmu.c             | 145 ++++++++++++++++++++++++++
> > > > >  5 files changed, 230 insertions(+)
> > > > >  create mode 100644 arch/riscv/include/asm/kvm_vcpu_pmu.h
> > > > >  create mode 100644 arch/riscv/kvm/vcpu_pmu.c
> > > > >
> > > > > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> > > > > index 93f43a3..f9874b4 100644
> > > > > --- a/arch/riscv/include/asm/kvm_host.h
> > > > > +++ b/arch/riscv/include/asm/kvm_host.h
> > > > > @@ -18,6 +18,7 @@
> > > > >  #include <asm/kvm_vcpu_insn.h>
> > > > >  #include <asm/kvm_vcpu_sbi.h>
> > > > >  #include <asm/kvm_vcpu_timer.h>
> > > > > +#include <asm/kvm_vcpu_pmu.h>
> > > > >
> > > > >  #define KVM_MAX_VCPUS                  1024
> > > > >
> > > > > @@ -228,6 +229,8 @@ struct kvm_vcpu_arch {
> > > > >
> > > > >         /* Don't run the VCPU (blocked) */
> > > > >         bool pause;
> > > > > +
> > > > > +       struct kvm_pmu pmu;
> > > >
> > > > Add a single line comment just like other members of the structure.
> > > >
> > > > I also suggest naming this variable "pmu_context" or something similar
> > > > for naming consistency.
> > > >
> > >
> > > Done.
> > >
> > > > >  };
> > > > >
> > > > >  static inline void kvm_arch_hardware_unsetup(void) {}
> > > > > diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> > > > > new file mode 100644
> > > > > index 0000000..3f43a43
> > > > > --- /dev/null
> > > > > +++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> > > > > @@ -0,0 +1,76 @@
> > > > > +/* SPDX-License-Identifier: GPL-2.0-only */
> > > > > +/*
> > > > > + * Copyright (c) 2023 Rivos Inc
> > > > > + *
> > > > > + * Authors:
> > > > > + *     Atish Patra <atishp@rivosinc.com>
> > > > > + */
> > > > > +
> > > > > +#ifndef __KVM_VCPU_RISCV_PMU_H
> > > > > +#define __KVM_VCPU_RISCV_PMU_H
> > > > > +
> > > > > +#include <linux/perf/riscv_pmu.h>
> > > > > +#include <asm/kvm_vcpu_sbi.h>
> > > > > +#include <asm/sbi.h>
> > > > > +
> > > > > +#ifdef CONFIG_RISCV_PMU_SBI
> > > > > +#define RISCV_KVM_MAX_FW_CTRS 32
> > > > > +#define RISCV_MAX_COUNTERS      64
> > > > > +
> > > > > +/* Per virtual pmu counter data */
> > > > > +struct kvm_pmc {
> > > > > +       u8 idx;
> > > > > +       struct perf_event *perf_event;
> > > > > +       uint64_t counter_val;
> > > > > +       union sbi_pmu_ctr_info cinfo;
> > > > > +       /* Event monitoring status */
> > > > > +       bool started;
> > > > > +};
> > > > > +
> > > > > +/* PMU data structure per vcpu */
> > > > > +struct kvm_pmu {
> > > > > +       struct kvm_pmc pmc[RISCV_MAX_COUNTERS];
> > > > > +       /* Number of the virtual firmware counters available */
> > > > > +       int num_fw_ctrs;
> > > > > +       /* Number of the virtual hardware counters available */
> > > > > +       int num_hw_ctrs;
> > > > > +       /* A flag to indicate that pmu initialization is done */
> > > > > +       bool init_done;
> > > > > +       /* Bit map of all the virtual counter used */
> > > > > +       DECLARE_BITMAP(pmc_in_use, RISCV_MAX_COUNTERS);
> > > > > +};
> > > > > +
> > > > > +#define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu)
> > > > > +#define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu))
> > > > > +
> > > > > +int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, struct kvm_vcpu_sbi_ext_data *edata);
> > > > > +int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
> > > > > +                               struct kvm_vcpu_sbi_ext_data *edata);
> > > > > +int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> > > > > +                                unsigned long ctr_mask, unsigned long flag, uint64_t ival,
> > > > > +                                struct kvm_vcpu_sbi_ext_data *edata);
> > > > > +int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> > > > > +                               unsigned long ctr_mask, unsigned long flag,
> > > > > +                               struct kvm_vcpu_sbi_ext_data *edata);
> > > > > +int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> > > > > +                                    unsigned long ctr_mask, unsigned long flag,
> > > > > +                                    unsigned long eidx, uint64_t evtdata,
> > > > > +                                    struct kvm_vcpu_sbi_ext_data *edata);
> > > > > +int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
> > > > > +                               struct kvm_vcpu_sbi_ext_data *edata);
> > > > > +int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu);
> > > > > +void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu);
> > > > > +void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu);
> > > > > +
> > > > > +#else
> > > > > +struct kvm_pmu {
> > > > > +};
> > > > > +
> > > > > +static inline int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
> > > > > +{
> > > > > +       return 0;
> > > > > +}
> > > > > +static inline void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu) {}
> > > > > +static inline void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu) {}
> > > > > +#endif /* CONFIG_RISCV_PMU_SBI */
> > > > > +#endif /* !__KVM_VCPU_RISCV_PMU_H */
> > > > > diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> > > > > index 019df920..5de1053 100644
> > > > > --- a/arch/riscv/kvm/Makefile
> > > > > +++ b/arch/riscv/kvm/Makefile
> > > > > @@ -25,3 +25,4 @@ kvm-y += vcpu_sbi_base.o
> > > > >  kvm-y += vcpu_sbi_replace.o
> > > > >  kvm-y += vcpu_sbi_hsm.o
> > > > >  kvm-y += vcpu_timer.o
> > > > > +kvm-$(CONFIG_RISCV_PMU_SBI) += vcpu_pmu.o
> > > > > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > > > > index 7c08567..b746f21 100644
> > > > > --- a/arch/riscv/kvm/vcpu.c
> > > > > +++ b/arch/riscv/kvm/vcpu.c
> > > > > @@ -137,6 +137,7 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
> > > > >
> > > > >         WRITE_ONCE(vcpu->arch.irqs_pending, 0);
> > > > >         WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
> > > >
> > > > Add an empty newline here.
> > > >
> > >
> > > Done.
> > > > > +       kvm_riscv_vcpu_pmu_reset(vcpu);
> > > > >
> > > > >         vcpu->arch.hfence_head = 0;
> > > > >         vcpu->arch.hfence_tail = 0;
> > > > > @@ -194,6 +195,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> > > > >         /* Setup VCPU timer */
> > > > >         kvm_riscv_vcpu_timer_init(vcpu);
> > > > >
> > > > > +       /* setup performance monitoring */
> > > > > +       kvm_riscv_vcpu_pmu_init(vcpu);
> > > > > +
> > > > >         /* Reset VCPU */
> > > > >         kvm_riscv_reset_vcpu(vcpu);
> > > > >
> > > > > @@ -216,6 +220,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
> > > > >         /* Cleanup VCPU timer */
> > > > >         kvm_riscv_vcpu_timer_deinit(vcpu);
> > > > >
> > > > > +       kvm_riscv_vcpu_pmu_deinit(vcpu);
> > > >
> > > > Add an empty newline here.
> > > >
> > >
> > > Done.
> > >
> > > > >         /* Free unused pages pre-allocated for G-stage page table mappings */
> > > > >         kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
> > > > >  }
> > > > > diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> > > > > new file mode 100644
> > > > > index 0000000..d3fd551
> > > > > --- /dev/null
> > > > > +++ b/arch/riscv/kvm/vcpu_pmu.c
> > > > > @@ -0,0 +1,145 @@
> > > > > +// SPDX-License-Identifier: GPL-2.0
> > > > > +/*
> > > > > + * Copyright (c) 2023 Rivos Inc
> > > > > + *
> > > > > + * Authors:
> > > > > + *     Atish Patra <atishp@rivosinc.com>
> > > > > + */
> > > > > +
> > > > > +#include <linux/errno.h>
> > > > > +#include <linux/err.h>
> > > > > +#include <linux/kvm_host.h>
> > > > > +#include <linux/perf/riscv_pmu.h>
> > > > > +#include <asm/csr.h>
> > > > > +#include <asm/kvm_vcpu_sbi.h>
> > > > > +#include <asm/kvm_vcpu_pmu.h>
> > > > > +#include <linux/kvm_host.h>
> > > > > +
> > > > > +#define kvm_pmu_num_counters(pmu) ((pmu)->num_hw_ctrs + (pmu)->num_fw_ctrs)
> > > > > +
> > > > > +int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, struct kvm_vcpu_sbi_ext_data *edata)
> > > > > +{
> > > > > +       struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> > > > > +
> > > > > +       edata->out_val = kvm_pmu_num_counters(kvpmu);
> > > > > +
> > > > > +       return 0;
> > > > > +}
> > > > > +
> > > > > +int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
> > > > > +                               struct kvm_vcpu_sbi_ext_data *edata)
> > > > > +{
> > > > > +       struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> > > > > +
> > > > > +       if (cidx > RISCV_MAX_COUNTERS || cidx == 1) {
> > > > > +               edata->err_val = SBI_ERR_INVALID_PARAM;
> > > > > +               return 0;
> > > > > +       }
> > > > > +
> > > > > +       edata->out_val = kvpmu->pmc[cidx].cinfo.value;
> > > > > +
> > > > > +       return 0;
> > > > > +}
> > > > > +
> > > > > +int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> > > > > +                                unsigned long ctr_mask, unsigned long flag, uint64_t ival,
> > > > > +                                struct kvm_vcpu_sbi_ext_data *edata)
> > > > > +{
> > > > > +       /* TODO */
> > > > > +       return 0;
> > > > > +}
> > > > > +
> > > > > +int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> > > > > +                               unsigned long ctr_mask, unsigned long flag,
> > > > > +                               struct kvm_vcpu_sbi_ext_data *edata)
> > > > > +{
> > > > > +       /* TODO */
> > > > > +       return 0;
> > > > > +}
> > > > > +
> > > > > +int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> > > > > +                                    unsigned long ctr_mask, unsigned long flag,
> > > > > +                                    unsigned long eidx, uint64_t evtdata,
> > > > > +                                    struct kvm_vcpu_sbi_ext_data *edata)
> > > > > +{
> > > > > +       /* TODO */
> > > > > +       return 0;
> > > > > +}
> > > > > +
> > > > > +int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
> > > > > +                               struct kvm_vcpu_sbi_ext_data *edata)
> > > > > +{
> > > > > +       /* TODO */
> > > > > +       return 0;
> > > > > +}
> > > > > +
> > > > > +int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
> > > > > +{
> > > > > +       int i = 0, num_fw_ctrs, ret, num_hw_ctrs = 0, hpm_width = 0;
> > > > > +       struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> > > > > +       struct kvm_pmc *pmc;
> > > > > +
> > > > > +       ret = riscv_pmu_get_hpm_info(&hpm_width, &num_hw_ctrs);
> > > > > +       if (ret < 0)
> > > > > +               return ret;
> > > > > +
> > > > > +       if (!hpm_width || !num_hw_ctrs) {
> > > > > +               pr_err("Cannot initialize VCPU with NULL hpmcounter width or number of counters\n");
> > > >
> > > > What will happen if underlying M-mode firmware does not implement
> > > > SBI PMU extension ?
> > > >
> > >
> > > riscv_pmu_get_hpm_info will return an error and
> > > kvm_riscv_vcpu_pmu_init will fail.
> >
> > Ahh okay. The vcpu_create() is not looking at return value
> > of kvm_riscv_vcpu_pmu_init() but this function should fail
> > silently "return 0" if riscv_pmu_get_hpm_info() fails.
> >
>
> Sure. I am assuming it should return 0 for the next case as well.
> if (!hpm_width || !num_hw_ctrs)

Yes, I agree. Better to make kvm_riscv_vcpu_pmu_init() return void.

>
> Thinking over again, does it make sense to print the error message in
> the above case ?
> In case you do see some use of this error message, it probably needs
> improvement as well
>
> "Cannot initialize pmu for vcpu %d with invalid counter width or
> number of counters"

For now, let's not have any error message in kvm_riscv_vcpu_pmu_init().

>
> > >
> > > > > +               return -EINVAL;
> > > > > +       }
> > > > > +
> > > > > +       if ((num_hw_ctrs + RISCV_KVM_MAX_FW_CTRS) > RISCV_MAX_COUNTERS) {
> > > > > +               pr_warn("Limiting fw counters as hw & fw counters exceed maximum counters\n");
> > > >
> > > > How is this possible ?
> > > >
> > > > Maximum HW counters is 32 (including time, cycle, and instret),
> > > > RISCV_KVM_MAX_FW_CTRS = 32, and
> > > > RISCV_MAX_COUNTERS = 64
> > >
> > > This was added to prevent the condition where somebody changed the
> > > definition RISCV_KVM_MAX_FW_CTRS
> > > without incrementing MAX_COUNTERS. The error might be subtle as it may
> > > work on some platforms (with less hardware counter)
> > > but fail on others (with more hardware counters.)
> > > I couldn't find a better way to describe the relationship between
> > > RISCV_KVM_MAX_FW_CTRS and RISCV_MAX_COUNTERS.
> > >
> > > I can just put a big comment here instead of the condition check if
> > > you prefer that way.
> >
> > Maybe you can add a compile-time check using "#if" and "#error" ?
> >
>
> You mean compile time error when RISCV_KVM_MAX_FW_CTRS > 32 ?
> Because num_hw_ctrs is computed at the runtime. So we can't determine
> the actual limit of firmware counters unless we know how many hardware
> counters are there.

Yes, we should ensure that RISCV_KVM_MAX_FW_CTRS > 32 does not
compile with a proper error message.

>
> > >
> > >
> > > >
> > > > > +               num_fw_ctrs = RISCV_MAX_COUNTERS - num_hw_ctrs;
> > > > > +       } else
> > > > > +               num_fw_ctrs = RISCV_KVM_MAX_FW_CTRS;
> > > > > +
> > > > > +       kvpmu->num_hw_ctrs = num_hw_ctrs;
> > > > > +       kvpmu->num_fw_ctrs = num_fw_ctrs;
> > > > > +
> > > > > +       /*
> > > > > +        * There is no correlation between the logical hardware counter and virtual counters.
> > > > > +        * However, we need to encode a hpmcounter CSR in the counter info field so that
> > > > > +        * KVM can trap n emulate the read. This works well in the migration use case as
> > > > > +        * KVM doesn't care if the actual hpmcounter is available in the hardware or not.
> > > > > +        */
> > > > > +       for (i = 0; i < kvm_pmu_num_counters(kvpmu); i++) {
> > > > > +               /* TIME CSR shouldn't be read from perf interface */
> > > > > +               if (i == 1)
> > > > > +                       continue;
> > > > > +               pmc = &kvpmu->pmc[i];
> > > > > +               pmc->idx = i;
> > > > > +               if (i < kvpmu->num_hw_ctrs) {
> > > > > +                       kvpmu->pmc[i].cinfo.type = SBI_PMU_CTR_TYPE_HW;
> > > > > +                       if (i < 3)
> > > > > +                               /* CY, IR counters */
> > > > > +                               kvpmu->pmc[i].cinfo.width = 63;
> > > > > +                       else
> > > > > +                               kvpmu->pmc[i].cinfo.width = hpm_width;
> > > > > +                       /*
> > > > > +                        * The CSR number doesn't have any relation with the logical
> > > > > +                        * hardware counters. The CSR numbers are encoded sequentially
> > > > > +                        * to avoid maintaining a map between the virtual counter
> > > > > +                        * and CSR number.
> > > > > +                        */
> > > > > +                       pmc->cinfo.csr = CSR_CYCLE + i;
> > > > > +               } else {
> > > > > +                       pmc->cinfo.type = SBI_PMU_CTR_TYPE_FW;
> > > > > +                       pmc->cinfo.width = BITS_PER_LONG - 1;
> > > > > +               }
> > > > > +       }
> > > > > +
> > > > > +       kvpmu->init_done = true;
> > > > > +
> > > > > +       return 0;
> > > > > +}
> > > > > +
> > > > > +void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu)
> > > > > +{
> > > > > +       /* TODO */
> > > > > +}
> > > > > +
> > > > > +void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu)
> > > > > +{
> > > > > +       kvm_riscv_vcpu_pmu_deinit(vcpu);
> > > > > +}
> > > > > --
> > > > > 2.25.1
> > > > >
> > > >
> > > > Regards,
> > > > Anup
> > >
> > >
> > >
> > > --
> > > Regards,
> > > Atish
> >
> > Regards,
> > Anup
>
>
>
> --
> Regards,
> Atish

Regards,
Anup
