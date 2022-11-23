Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF4EB6366BB
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 18:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239293AbiKWRMR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 12:12:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239181AbiKWRMA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 12:12:00 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2066B2653
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 09:11:59 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id j10-20020a17090aeb0a00b00218dfce36e5so2119810pjz.1
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 09:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DXmfMcAbqneNQh2BtbA2SOdfF55FaoyuXPVThWrMQPk=;
        b=j+Nr879GxcF8uDjTcxy+dn4iKWz5OWWQy3XOLhQrnfEq+xl71RP17kOYq0+DIPKQBv
         0/9fJGAZxhXAr5GkcPOtUud1ftzRmmTzMfBCx0vX+g/7MiztpxiDyOBEVpL6oItu9Hgd
         Oe+yA11XN1+GEn77sX+S8/XDnzvc3NTmgyAN/thYDEorOBi7JHprGhoRtSHxwzlRmVwx
         toRh5rXQUT3jaWbPXmdBcgEQ0lraUv9k9a8RyHebHODyACac1OwO2/iJQGxZJ2/ODc5Q
         IObCJ2Q5RzNfshLGAsZ1P4ULI+hg2uMhkKYR+WupzjjpKi4+CZjKJbdpRtamClXRjaTB
         AScA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DXmfMcAbqneNQh2BtbA2SOdfF55FaoyuXPVThWrMQPk=;
        b=UTjkorhEVim2uLBbpr75yKqzIMnpRnA+QvK6jVplepmLKEGfbhgcm0up3vfOl8zIH9
         fxrwFEeS7ElKnfu6u4OHGn1Y5yUJzE/5JPFexvpxs2d9iiKyI7j22ES3STGfTENIk+nS
         LYYjG+phkR7d5FID0o7tf8ijQnlmm3aTXjWiEiSyoKbwYciRJnfxU1/yUZKtAnyQAr2A
         8xt18Y8xuQYHme+YURfiosP/e67Ak2KTGsXTvDctOQ0P2lxV1WL+OiO6nuyYHXPpkBrV
         xxAuzJSZYQrINXFm4TxIUgoYvqlVga/YyhtJp0JYe7Y8KHSVXrMJnEGZpli7Auddr4Kd
         5Sig==
X-Gm-Message-State: ANoB5pkNNoQiP0lHQkJMZa7Dh/F5M+yOR5t+meiOUF31gBsB7sl7Inqa
        IZ5DyRf+q5Ndm6eXBSnEy28c52D85PqJAjbimXtqog==
X-Google-Smtp-Source: AA0mqf5FjXv5JHq3QrDuqdHG6FlinCfWMMIXQ/XsjXPJVdIf2BSIxAtgpvd8UuPeJlnhoLHUXy+x91cmFNMS0f1smlg=
X-Received: by 2002:a17:902:cacb:b0:188:5e78:be0 with SMTP id
 y11-20020a170902cacb00b001885e780be0mr9976545pld.18.1669223518357; Wed, 23
 Nov 2022 09:11:58 -0800 (PST)
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org> <20221113163832.3154370-14-maz@kernel.org>
 <CAAeT=Fx=8g2-Z8nzqUit5owtoxbenXnAFA5Mu6AfgZJFN4CfVw@mail.gmail.com> <86leo2ncxl.wl-maz@kernel.org>
In-Reply-To: <86leo2ncxl.wl-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 23 Nov 2022 09:11:41 -0800
Message-ID: <CAAeT=Fyy6ViW+f4w-GWjQp3tdjyzhMaRd3pbkys9iS4gxsAY_Q@mail.gmail.com>
Subject: Re: [PATCH v4 13/16] KVM: arm64: PMU: Implement PMUv3p5 long counter support
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Wed, Nov 23, 2022 at 3:11 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 23 Nov 2022 05:58:17 +0000,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Sun, Nov 13, 2022 at 8:46 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > PMUv3p5 (which is mandatory with ARMv8.5) comes with some extra
> > > features:
> > >
> > > - All counters are 64bit
> > >
> > > - The overflow point is controlled by the PMCR_EL0.LP bit
> > >
> > > Add the required checks in the helpers that control counter
> > > width and overflow, as well as the sysreg handling for the LP
> > > bit. A new kvm_pmu_is_3p5() helper makes it easy to spot the
> > > PMUv3p5 specific handling.
> > >
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/pmu-emul.c | 8 +++++---
> > >  arch/arm64/kvm/sys_regs.c | 4 ++++
> > >  include/kvm/arm_pmu.h     | 7 +++++++
> > >  3 files changed, 16 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > > index 4320c389fa7f..c37cc67ff1d7 100644
> > > --- a/arch/arm64/kvm/pmu-emul.c
> > > +++ b/arch/arm64/kvm/pmu-emul.c
> > > @@ -52,13 +52,15 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
> > >   */
> > >  static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
> > >  {
> > > -       return (select_idx == ARMV8_PMU_CYCLE_IDX);
> > > +       return (select_idx == ARMV8_PMU_CYCLE_IDX || kvm_pmu_is_3p5(vcpu));
> > >  }
> > >
> > >  static bool kvm_pmu_idx_has_64bit_overflow(struct kvm_vcpu *vcpu, u64 select_idx)
> > >  {
> > > -       return (select_idx == ARMV8_PMU_CYCLE_IDX &&
> > > -               __vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_LC);
> > > +       u64 val = __vcpu_sys_reg(vcpu, PMCR_EL0);
> > > +
> > > +       return (select_idx < ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LP)) ||
> > > +              (select_idx == ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LC));
> >
> > Since the vCPU's PMCR_EL0 value is not always in sync with
> > kvm->arch.dfr0_pmuver.imp, shouldn't kvm_pmu_idx_has_64bit_overflow()
> > check kvm_pmu_is_3p5() ?
> > (e.g. when the host supports PMUv3p5, PMCR.LP will be set by reset_pmcr()
> > initially. Then, even if userspace sets ID_AA64DFR0_EL1.PMUVER to
> > PMUVer_V3P1, PMCR.LP will stay the same (still set) unless PMCR is
> > written.  So, kvm_pmu_idx_has_64bit_overflow() might return true
> > even though the guest's PMU version is lower than PMUVer_V3P5.)
>
> I can see two ways to address this: either we spray PMUv3p5 checks
> every time we evaluate PMCR, or we sanitise PMCR after each userspace
> write to ID_AA64DFR0_EL1.
>
> I'd like to be able to take what is stored in the register file at
> face value, so I'm angling towards the second possibility. It also

I thought about that too.  What makes it a bit tricky is that
given that kvm->arch.dfr0_pmuver.imp is shared among all vCPUs
for the guest, updating the PMCR should be done for all the vCPUs.

> +static void update_dfr0_pmuver(struct kvm_vcpu *vcpu, u8 pmuver)
> +{
> +       if (vcpu->kvm->arch.dfr0_pmuver.imp != pmuver) {
> +               vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
> +               __reset_pmcr(vcpu, __vcpu_sys_reg(vcpu, PMCR_EL0));
> +       }
> +}

Or if userspace is expected to set ID_AA64DFR0_EL1 (PMUVER) for
each vCPU, update_dfr0_pmuver() should update PMCR even when
'kvm->arch.dfr0_pmuver.imp' is the same as the given 'pmuver'.
(as PMCR for the vCPU might have not been updated yet)

> makes some sense from a 'HW' perspective: you change the HW
> dynamically by selecting a new version, the HW comes up with its reset
> configuration (i.e don't expect PMCR to stick after you write to
> DFR0 with a different PMUVer).

Yes, it makes some sense.
But, with that, for live migration, PMCR should be restored only
after ID_AA64DFR0_EL1/ID_DFR0_EL1 is restored (to avoid PMCR
being reset after PMCR is restored), which I would think might
affect live migration.
(Or am I misunderstanding something ?)

Thank you,
Reiji


>
> >
> >
> > >  }
> > >
> > >  static bool kvm_pmu_counter_can_chain(struct kvm_vcpu *vcpu, u64 idx)
> > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > index dc201a0557c0..615cb148e22a 100644
> > > --- a/arch/arm64/kvm/sys_regs.c
> > > +++ b/arch/arm64/kvm/sys_regs.c
> > > @@ -654,6 +654,8 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> > >                | (ARMV8_PMU_PMCR_MASK & 0xdecafbad)) & (~ARMV8_PMU_PMCR_E);
> > >         if (!kvm_supports_32bit_el0())
> > >                 val |= ARMV8_PMU_PMCR_LC;
> > > +       if (!kvm_pmu_is_3p5(vcpu))
> > > +               val &= ~ARMV8_PMU_PMCR_LP;
> > >         __vcpu_sys_reg(vcpu, r->reg) = val;
> > >  }
> > >
> > > @@ -703,6 +705,8 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> > >                 val |= p->regval & ARMV8_PMU_PMCR_MASK;
> > >                 if (!kvm_supports_32bit_el0())
> > >                         val |= ARMV8_PMU_PMCR_LC;
> > > +               if (!kvm_pmu_is_3p5(vcpu))
> > > +                       val &= ~ARMV8_PMU_PMCR_LP;
> > >                 __vcpu_sys_reg(vcpu, PMCR_EL0) = val;
> > >                 kvm_pmu_handle_pmcr(vcpu, val);
> > >                 kvm_vcpu_pmu_restore_guest(vcpu);
> >
> > For the read case of access_pmcr() (the code below),
> > since PMCR.LP is RES0 when FEAT_PMUv3p5 is not implemented,
> > shouldn't it clear PMCR.LP if kvm_pmu_is_3p5(vcpu) is false ?
> > (Similar issue to kvm_pmu_idx_has_64bit_overflow())
> >
> >         } else {
> >                 /* PMCR.P & PMCR.C are RAZ */
> >                 val = __vcpu_sys_reg(vcpu, PMCR_EL0)
> >                       & ~(ARMV8_PMU_PMCR_P | ARMV8_PMU_PMCR_C);
> >                 p->regval = val;
> >         }
>
> I think the above would address it. I've tentatively queued the
> following patch, please let me know if this looks OK to you.
>
> Thanks,
>
>         M.
>
> From d90ec0e8768ce5f7ae11403b29db76260dfaa3f2 Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Wed, 23 Nov 2022 11:03:07 +0000
> Subject: [PATCH] KVM: arm64: PMU: Reset PMCR_EL0 on PMU version change
>
> Changing the version of the PMU emulation may result in stale
> bits still being present in the PMCR_EL0 register, leading to
> unexpected results.
>
> Address it by forcing PMCR_EL0 to its reset value when the value
> of ID_AA64DFR0.PMUVer (or ID_DFR0.Perfmon) changes.
>
> Reported-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 32 ++++++++++++++++++++++----------
>  1 file changed, 22 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 67eac0f747be..12a873d94aaf 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -637,15 +637,10 @@ static void reset_pmselr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>         __vcpu_sys_reg(vcpu, r->reg) &= ARMV8_PMU_COUNTER_MASK;
>  }
>
> -static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +static void __reset_pmcr(struct kvm_vcpu *vcpu, u64 pmcr)
>  {
> -       u64 pmcr, val;
> -
> -       /* No PMU available, PMCR_EL0 may UNDEF... */
> -       if (!kvm_arm_support_pmu_v3())
> -               return;
> +       u64 val;
>
> -       pmcr = read_sysreg(pmcr_el0);
>         /*
>          * Writable bits of PMCR_EL0 (ARMV8_PMU_PMCR_MASK) are reset to UNKNOWN
>          * except PMCR.E resetting to zero.
> @@ -656,7 +651,16 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>                 val |= ARMV8_PMU_PMCR_LC;
>         if (!kvm_pmu_is_3p5(vcpu))
>                 val &= ~ARMV8_PMU_PMCR_LP;
> -       __vcpu_sys_reg(vcpu, r->reg) = val;
> +       __vcpu_sys_reg(vcpu, PMCR_EL0) = val;
> +}
> +
> +static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +{
> +       /* No PMU available, PMCR_EL0 may UNDEF... */
> +       if (!kvm_arm_support_pmu_v3())
> +               return;
> +
> +       __reset_pmcr(vcpu, read_sysreg(pmcr_el0));
>  }
>
>  static bool check_pmu_access_disabled(struct kvm_vcpu *vcpu, u64 flags)
> @@ -1259,6 +1263,14 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>         return 0;
>  }
>
> +static void update_dfr0_pmuver(struct kvm_vcpu *vcpu, u8 pmuver)
> +{
> +       if (vcpu->kvm->arch.dfr0_pmuver.imp != pmuver) {
> +               vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
> +               __reset_pmcr(vcpu, __vcpu_sys_reg(vcpu, PMCR_EL0));
> +       }
> +}
> +
>  static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
>                                const struct sys_reg_desc *rd,
>                                u64 val)
> @@ -1291,7 +1303,7 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
>                 return -EINVAL;
>
>         if (valid_pmu)
> -               vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
> +               update_dfr0_pmuver(vcpu, pmuver);
>         else
>                 vcpu->kvm->arch.dfr0_pmuver.unimp = pmuver;
>
> @@ -1331,7 +1343,7 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
>                 return -EINVAL;
>
>         if (valid_pmu)
> -               vcpu->kvm->arch.dfr0_pmuver.imp = perfmon_to_pmuver(perfmon);
> +               update_dfr0_pmuver(vcpu, perfmon_to_pmuver(perfmon));
>         else
>                 vcpu->kvm->arch.dfr0_pmuver.unimp = perfmon_to_pmuver(perfmon);
>
> --
> 2.34.1
>
>
> --
> Without deviation from the norm, progress is not possible.
