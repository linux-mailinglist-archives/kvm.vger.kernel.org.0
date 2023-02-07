Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D41568DC4A
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 15:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbjBGO55 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 09:57:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232225AbjBGO5z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 09:57:55 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE78C13523
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 06:57:52 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id l14so5948174eds.4
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 06:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=i1Xk4UxjkX2lM5lBm9X6gAvbk7g7P+8uUM07nXciiIY=;
        b=2ju73tcI/+b1hffAojtONj6F9dgvGR2+rarFT1sFhIMciYTHxycrQDlW5ldgnqNlby
         1eHTFP0z1b1PXX29+hY55NhQxK08NIWk08nJ7Iw0wTro6gOSR7ZW5k+QZAJqwrrJnjcd
         7b3GaYnEWO0xsLpk/3TL11MmMl7KXhS2LszSpKXxBGFaeUPFdd8e3kfnKb7gLRuXPU4v
         rOdU8oITbhzDcRN0L9SPAI7XgnF7C8Oi8iYsodh8GJByhWESxw5brIY5+3ZugcRqf9WI
         5Zo96vrCMnHsc3VLwhVOeF54S4w3BEVAGR/ByK2+0eiFA4ieyprA01InkHgvUhW7AQRS
         D2iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i1Xk4UxjkX2lM5lBm9X6gAvbk7g7P+8uUM07nXciiIY=;
        b=u4I3pFAKL1b0mmm4mjavYHjKcODGvfDoceyOThuTBJSXp61IWyDTkK0MWQ2k+TO5Zy
         xcNrw8kfLRlgfidczYrEx6zvVN3SC55H7jU0Oe5o+KNk0jHL2shNrJ7JSXRk4W6yxsar
         98/3CLvTPf+ArEWKT7qwIOEUJuFLDe5GyMoDTR3EBd0703IcOye/shaYsTH3nT/QnW6t
         dal8rwV78JneiwIldgkfmXQxz9HDPT+s/Lmzrsbu9zLF9AdEqBPV1LXhhhrhKHa+hLkg
         PljAm/JKu9/Bx6HLfYEAaNdOZ47rTwPy9U9hchQjLekKefrzLBRo9FH3raAKtMEPNGHQ
         ev5A==
X-Gm-Message-State: AO0yUKVQD3I5FpNuYYWqxPJJgsyWO4Zz/SbouoXPgL3MdJZxLzUKLA+l
        t/SIT/Jl/mjQiD10XeA0G/GGGCk5VMJSqtKmk3o4cQ==
X-Google-Smtp-Source: AK7set8TMMTVARsJ/lKBSntIVoBF2AzZr+FUM1UuvRDmEwf7yn9MTW+eHyvr5Gr4VRnr6Tgq3T6Rjrvs1clD/htMdK4=
X-Received: by 2002:a50:99cc:0:b0:499:f0f:f788 with SMTP id
 n12-20020a5099cc000000b004990f0ff788mr931128edb.25.1675781871354; Tue, 07 Feb
 2023 06:57:51 -0800 (PST)
MIME-Version: 1.0
References: <20230207095529.1787260-1-atishp@rivosinc.com> <20230207095529.1787260-3-atishp@rivosinc.com>
 <20230207104350.ekjklgxehrc7qtil@orel>
In-Reply-To: <20230207104350.ekjklgxehrc7qtil@orel>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 7 Feb 2023 20:27:40 +0530
Message-ID: <CAAhSdy0c7ufa--ipbuZc5f_0ZN6V_Ed0=iEfLYyOXMO7aUaE4A@mail.gmail.com>
Subject: Re: [PATCH v6 2/8] RISC-V: KVM: Add SBI PMU extension support
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     Atish Patra <atishp@rivosinc.com>, linux-kernel@vger.kernel.org,
        Atish Patra <atishp@atishpatra.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On Tue, Feb 7, 2023 at 4:13 PM Andrew Jones <ajones@ventanamicro.com> wrote:
>
> On Tue, Feb 07, 2023 at 01:55:23AM -0800, Atish Patra wrote:
> > SBI PMU extension allows KVM guests to configure/start/stop/query about
> > the PMU counters in virtualized enviornment as well.
> >
> > In order to allow that, KVM implements the entire SBI PMU extension.
> >
> > Reviewed-by: Anup Patel <anup@brainfault.org>
> > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> >  arch/riscv/kvm/Makefile       |  2 +-
> >  arch/riscv/kvm/vcpu_sbi.c     | 11 +++++
> >  arch/riscv/kvm/vcpu_sbi_pmu.c | 86 +++++++++++++++++++++++++++++++++++
> >  3 files changed, 98 insertions(+), 1 deletion(-)
> >  create mode 100644 arch/riscv/kvm/vcpu_sbi_pmu.c
> >
> > diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> > index 5de1053..278e97c 100644
> > --- a/arch/riscv/kvm/Makefile
> > +++ b/arch/riscv/kvm/Makefile
> > @@ -25,4 +25,4 @@ kvm-y += vcpu_sbi_base.o
> >  kvm-y += vcpu_sbi_replace.o
> >  kvm-y += vcpu_sbi_hsm.o
> >  kvm-y += vcpu_timer.o
> > -kvm-$(CONFIG_RISCV_PMU_SBI) += vcpu_pmu.o
> > +kvm-$(CONFIG_RISCV_PMU_SBI) += vcpu_pmu.o vcpu_sbi_pmu.o
> > diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> > index fe2897e..15fde15 100644
> > --- a/arch/riscv/kvm/vcpu_sbi.c
> > +++ b/arch/riscv/kvm/vcpu_sbi.c
> > @@ -20,6 +20,16 @@ static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01 = {
> >  };
> >  #endif
> >
> > +#ifdef CONFIG_RISCV_PMU_SBI
> > +extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu;
> > +#else
> > +static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu = {
> > +     .extid_start = -1UL,
> > +     .extid_end = -1UL,
> > +     .handler = NULL,
> > +};
> > +#endif
> > +
> >  static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
> >       &vcpu_sbi_ext_v01,
> >       &vcpu_sbi_ext_base,
> > @@ -28,6 +38,7 @@ static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
> >       &vcpu_sbi_ext_rfence,
> >       &vcpu_sbi_ext_srst,
> >       &vcpu_sbi_ext_hsm,
> > +     &vcpu_sbi_ext_pmu,
> >       &vcpu_sbi_ext_experimental,
> >       &vcpu_sbi_ext_vendor,
> >  };
> > diff --git a/arch/riscv/kvm/vcpu_sbi_pmu.c b/arch/riscv/kvm/vcpu_sbi_pmu.c
> > new file mode 100644
> > index 0000000..38efadb
> > --- /dev/null
> > +++ b/arch/riscv/kvm/vcpu_sbi_pmu.c
> > @@ -0,0 +1,86 @@
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
> > +#include <asm/csr.h>
> > +#include <asm/sbi.h>
> > +#include <asm/kvm_vcpu_sbi.h>
> > +
> > +static int kvm_sbi_ext_pmu_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> > +                                struct kvm_vcpu_sbi_return *retdata)
> > +{
> > +     int ret = 0;
> > +     struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> > +     struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> > +     unsigned long funcid = cp->a6;
> > +     u64 temp;
> > +
> > +     if (!kvpmu->init_done) {
> > +             retdata->err_val = SBI_ERR_NOT_SUPPORTED;
> > +             return 0;
> > +     }
> > +
> > +     switch (funcid) {
> > +     case SBI_EXT_PMU_NUM_COUNTERS:
> > +             ret = kvm_riscv_vcpu_pmu_num_ctrs(vcpu, retdata);
> > +             break;
> > +     case SBI_EXT_PMU_COUNTER_GET_INFO:
> > +             ret = kvm_riscv_vcpu_pmu_ctr_info(vcpu, cp->a0, retdata);
> > +             break;
> > +     case SBI_EXT_PMU_COUNTER_CFG_MATCH:
> > +#if defined(CONFIG_32BIT)
> > +             temp = ((uint64_t)cp->a5 << 32) | cp->a4;
> > +#else
> > +             temp = cp->a4;
> > +#endif
> > +             /*
> > +              * This can fail if perf core framework fails to create an event.
> > +              * Forward the error to userspace which is an error happened
>
> "Forward the error to userspace because it's an error which happened..."
>
> (Can probably be fixed up on merge.)

Sure, I will fix this at the time of merging this patch.

Thanks,
Anup

>
> > +              * within the host kernel. The other option would be to convert
> > +              * to an SBI error and forward to the guest.
> > +              */
> > +             ret = kvm_riscv_vcpu_pmu_ctr_cfg_match(vcpu, cp->a0, cp->a1,
> > +                                                    cp->a2, cp->a3, temp, retdata);
> > +             break;
> > +     case SBI_EXT_PMU_COUNTER_START:
> > +#if defined(CONFIG_32BIT)
> > +             temp = ((uint64_t)cp->a4 << 32) | cp->a3;
> > +#else
> > +             temp = cp->a3;
> > +#endif
> > +             ret = kvm_riscv_vcpu_pmu_ctr_start(vcpu, cp->a0, cp->a1, cp->a2,
> > +                                                temp, retdata);
> > +             break;
> > +     case SBI_EXT_PMU_COUNTER_STOP:
> > +             ret = kvm_riscv_vcpu_pmu_ctr_stop(vcpu, cp->a0, cp->a1, cp->a2, retdata);
> > +             break;
> > +     case SBI_EXT_PMU_COUNTER_FW_READ:
> > +             ret = kvm_riscv_vcpu_pmu_ctr_read(vcpu, cp->a0, retdata);
> > +             break;
> > +     default:
> > +             retdata->err_val = SBI_ERR_NOT_SUPPORTED;
> > +     }
> > +
> > +     return ret;
> > +}
> > +
> > +static unsigned long kvm_sbi_ext_pmu_probe(struct kvm_vcpu *vcpu)
> > +{
> > +     struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> > +
> > +     return kvpmu->init_done;
> > +}
> > +
> > +const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu = {
> > +     .extid_start = SBI_EXT_PMU,
> > +     .extid_end = SBI_EXT_PMU,
> > +     .handler = kvm_sbi_ext_pmu_handler,
> > +     .probe = kvm_sbi_ext_pmu_probe,
> > +};
> > --
> > 2.25.1
> >
>
> Thanks,
> drew
