Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC2B868628C
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 10:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbjBAJKT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 04:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbjBAJKK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 04:10:10 -0500
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87486729E
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 01:09:44 -0800 (PST)
Received: by mail-vk1-xa29.google.com with SMTP id b81so8785744vkf.1
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 01:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aITMviYfm8fMzGzu1E4FJT26sq3+JmPG6tHklfmZTHM=;
        b=DhEcJjCLxeylirs1z9kQ4cZENCgjXvZoi58R4zINMkRoQXAbqSNL9RmWH5pZsZ6BFb
         z5PRQiRhPf/jRoEukij1FLqrjJPHGyz2/fhqDqrgrpqS5UlBxZEWwRcWOAlaJ/S/lo5F
         z5XYMeE0vt9p/jksQ93UO9YYeiqTKYdYLNyUkAfFAld2f7/2gIAn3WhMLCN+QGpCs8k/
         cBaUCOPA0IjSxFHify4QD9HoAIQ+1eD5Is+Trmeq2MdGBrhCD6NpCvcikl7UIvZVwrdB
         +bvQgIkDMuLOa5UXmaSBR/33ZcPvp33Cj3eyGYeE9AL21irz2ossPXclZ5WqalJoa9BL
         4tMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aITMviYfm8fMzGzu1E4FJT26sq3+JmPG6tHklfmZTHM=;
        b=103t5AtlKHdu/uRuGfj1X/xc8JfmYpwfGkNH4DoIxpt75YNlq3EURT8tif0Sylsdp5
         hqIpMt4+pGGtRcoAzrit5XPf1xk4LK3qYBSzO8PCUaV4aucRsXD/nRlVaf66I+TjxLaQ
         0jVfTgL2ny/RQEU1ycfomudsGuySjW29de1WsjXlONjKGswDz3Z2KUAMle2JDW5f84ZS
         9U3LOcPPHuwqgKhve57wX38d3MxYHkwgB5hweg0Pr3tl5cGCGZXN2GFbjSCNDnrkf3sM
         ZifQCV21imh4EpwONBuvEGzpMX1Z7BFaUGDhWEAi+FrWkienIAtsUU1k3HX4EEStQ3xC
         hx0Q==
X-Gm-Message-State: AO0yUKUniyh5K0jk01Us2Idj27AX8QUjF537hkmUcK2a7cbcno2qZ5bk
        nY8aMQKO2HhZvTv7FjtqRsNnhNzCNP0thun5vjhKYA==
X-Google-Smtp-Source: AK7set9KkJGY2ec3OdKKnCoSlIqqx4LSiBC81tOJA0eLV87kcizG+AoJ1kaKuVpatq00rMhYlMGCbBol3NcVP4VZqaI=
X-Received: by 2002:a1f:6e0c:0:b0:3e1:95e8:fe1e with SMTP id
 j12-20020a1f6e0c000000b003e195e8fe1emr248504vkc.1.1675242581785; Wed, 01 Feb
 2023 01:09:41 -0800 (PST)
MIME-Version: 1.0
References: <20230127182558.2416400-1-atishp@rivosinc.com> <20230127182558.2416400-12-atishp@rivosinc.com>
 <CAAhSdy1+6AprOdzRRTG98p6swisNFO6MUKjXobxW3RWbixvjCg@mail.gmail.com>
 <CAOnJCU+=A1GXvaQis5RrDabPAvAZccmc9HF1KU4ReuRTSx5pCQ@mail.gmail.com> <CAOnJCUL27aBGre7=mPX7BwMUkUN8CC_UFzmFh7W9LzCxktyGVg@mail.gmail.com>
In-Reply-To: <CAOnJCUL27aBGre7=mPX7BwMUkUN8CC_UFzmFh7W9LzCxktyGVg@mail.gmail.com>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Wed, 1 Feb 2023 14:39:30 +0530
Message-ID: <CAK9=C2U7pP8VegGTaDJhkh2gBVzhPmpx+Um=QCC7uZ-5k4KyOQ@mail.gmail.com>
Subject: Re: [PATCH v3 11/14] RISC-V: KVM: Implement trap & emulate for hpmcounters
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 1, 2023 at 2:29 PM Atish Patra <atishp@atishpatra.org> wrote:
>
> On Tue, Jan 31, 2023 at 2:46 PM Atish Patra <atishp@atishpatra.org> wrote:
> >
> > On Sun, Jan 29, 2023 at 4:44 AM Anup Patel <anup@brainfault.org> wrote:
> > >
> > > On Fri, Jan 27, 2023 at 11:56 PM Atish Patra <atishp@rivosinc.com> wrote:
> > > >
> > > > As the KVM guests only see the virtual PMU counters, all hpmcounter
> > > > access should trap and KVM emulates the read access on behalf of guests.
> > > >
> > > > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > > > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > > > ---
> > > >  arch/riscv/include/asm/kvm_vcpu_pmu.h | 16 ++++++++++
> > > >  arch/riscv/kvm/vcpu_insn.c            |  4 ++-
> > > >  arch/riscv/kvm/vcpu_pmu.c             | 45 ++++++++++++++++++++++++++-
> > > >  3 files changed, 63 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> > > > index 3f43a43..022d45d 100644
> > > > --- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
> > > > +++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> > > > @@ -43,6 +43,19 @@ struct kvm_pmu {
> > > >  #define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu)
> > > >  #define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu))
> > > >
> > > > +#if defined(CONFIG_32BIT)
> > > > +#define KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS \
> > > > +{ .base = CSR_CYCLEH,      .count = 31, .func = kvm_riscv_vcpu_pmu_read_hpm }, \
> > > > +{ .base = CSR_CYCLE,      .count = 31, .func = kvm_riscv_vcpu_pmu_read_hpm },
> > > > +#else
> > > > +#define KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS \
> > > > +{ .base = CSR_CYCLE,      .count = 31, .func = kvm_riscv_vcpu_pmu_read_hpm },
> > > > +#endif
> > > > +
> > > > +int kvm_riscv_vcpu_pmu_read_hpm(struct kvm_vcpu *vcpu, unsigned int csr_num,
> > > > +                               unsigned long *val, unsigned long new_val,
> > > > +                               unsigned long wr_mask);
> > > > +
> > > >  int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, struct kvm_vcpu_sbi_ext_data *edata);
> > > >  int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
> > > >                                 struct kvm_vcpu_sbi_ext_data *edata);
> > > > @@ -65,6 +78,9 @@ void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu);
> > > >  #else
> > > >  struct kvm_pmu {
> > > >  };
> > > > +#define KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS \
> > > > +{ .base = 0,      .count = 0, .func = NULL },
> > > > +
> > >
> > > Redundant newline here.
> > >
> >
> > Fixed.
> >
> > > >
> > > >  static inline int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
> > > >  {
> > > > diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
> > > > index 0bb5276..f689337 100644
> > > > --- a/arch/riscv/kvm/vcpu_insn.c
> > > > +++ b/arch/riscv/kvm/vcpu_insn.c
> > > > @@ -213,7 +213,9 @@ struct csr_func {
> > > >                     unsigned long wr_mask);
> > > >  };
> > > >
> > > > -static const struct csr_func csr_funcs[] = { };
> > > > +static const struct csr_func csr_funcs[] = {
> > > > +       KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS
> > > > +};
> > > >
> > > >  /**
> > > >   * kvm_riscv_vcpu_csr_return -- Handle CSR read/write after user space
> > > > diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> > > > index 7713927..894053a 100644
> > > > --- a/arch/riscv/kvm/vcpu_pmu.c
> > > > +++ b/arch/riscv/kvm/vcpu_pmu.c
> > > > @@ -17,6 +17,44 @@
> > > >
> > > >  #define kvm_pmu_num_counters(pmu) ((pmu)->num_hw_ctrs + (pmu)->num_fw_ctrs)
> > > >
> > > > +static int pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
> > > > +                       unsigned long *out_val)
> > > > +{
> > > > +       struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> > > > +       struct kvm_pmc *pmc;
> > > > +       u64 enabled, running;
> > > > +
> > > > +       pmc = &kvpmu->pmc[cidx];
> > > > +       if (!pmc->perf_event)
> > > > +               return -EINVAL;
> > > > +
> > > > +       pmc->counter_val += perf_event_read_value(pmc->perf_event, &enabled, &running);
> > > > +       *out_val = pmc->counter_val;
> > > > +
> > > > +       return 0;
> > > > +}
> > > > +
> > > > +int kvm_riscv_vcpu_pmu_read_hpm(struct kvm_vcpu *vcpu, unsigned int csr_num,
> > > > +                               unsigned long *val, unsigned long new_val,
> > > > +                               unsigned long wr_mask)
> > > > +{
> > > > +       struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> > > > +       int cidx, ret = KVM_INSN_CONTINUE_NEXT_SEPC;
> > > > +
> > > > +       if (!kvpmu || !kvpmu->init_done)
> > > > +               return KVM_INSN_EXIT_TO_USER_SPACE;
> > >
> > > As discussed previously, this should be KVM_INSN_ILLEGAL_TRAP.
> > >
>
> Thinking about it more, this results in a panic in guest S-mode which
> is probably undesirable.
> As per your earlier suggestion, we can return 0 for cycle/instret
> counters if accessed.
> This is only possible through legacy pmu drivers running in guests or
> some other OS that access any hpmcounters
> for random reasons.
>
> I think we should return KVM_INSN_ILLEGAL_TRAP for other counters and
> make the guest kernel panic.
> This does separate the behavior between fixed and programmable
> counters when everything is denied access in hcounteren.
>
> The new code will look like this:
>
> if (!kvpmu || !kvpmu->init_done) {
>     if (csr_num == CSR_CYCLE || csr_num == CSR_INSTRET) {
>         *val = 0;
>         return ret;
>     } else
>          return KVM_INSN_ILLEGAL_TRAP;
> }
>
> Let me know if you think otherwise.

Looks good to me. Please also add comment block inside
"if (!kvpmu || !kvpmu->init_done)"

>
> >
> > Done.
> > > > +
> > > > +       if (wr_mask)
> > > > +               return KVM_INSN_ILLEGAL_TRAP;
> > > > +
> > > > +       cidx = csr_num - CSR_CYCLE;
> > > > +
> > > > +       if (pmu_ctr_read(vcpu, cidx, val) < 0)
> > > > +               return KVM_INSN_EXIT_TO_USER_SPACE;
> > >
> > > Same as above.
> > >
>
> We can get rid of this as pmu_ctr_read doesn't return errors anyways.
>
> >
> > Done.
> >
> > > > +
> > > > +       return ret;
> > > > +}
> > > > +
> > > >  int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, struct kvm_vcpu_sbi_ext_data *edata)
> > > >  {
> > > >         struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> > > > @@ -69,7 +107,12 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
> > > >  int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
> > > >                                 struct kvm_vcpu_sbi_ext_data *edata)
> > > >  {
> > > > -       /* TODO */
> > > > +       int ret;
> > > > +
> > > > +       ret = pmu_ctr_read(vcpu, cidx, &edata->out_val);
> > > > +       if (ret == -EINVAL)
> > > > +               edata->err_val = SBI_ERR_INVALID_PARAM;
> > > > +
> > > >         return 0;
> > > >  }
> > > >
> > > > --
> > > > 2.25.1
> > > >
> > >
> > > Regards,
> > > Anup
> >
> >
> >
> > --
> > Regards,
> > Atish
>
>
>
> --
> Regards,
> Atish

Regards,
Anup
