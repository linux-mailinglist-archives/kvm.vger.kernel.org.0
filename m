Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2F66924E9
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 18:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbjBJR5A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 12:57:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231792AbjBJR47 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 12:56:59 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2A5402DC
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 09:56:57 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id bd6so5086273oib.6
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 09:56:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZU0DTR2jkb6BgDEFwVxRI9QZqgszPA2FbK1oe+H0PD0=;
        b=VA76dp6+OuYPBS18rf5xv6Ux9MptM92IX3o62MiLMWYngoDBylS/hHVYd1aMzReDgE
         hZUXpH/uZG08n1OwMiMfvn94OqDtJmw+rHnUaIslSN56xy0S7tyxrOLM2F2wuGFceN4+
         QNr4jg9Q/ie3Tkox5/fz5R7H2kI1t4ZcrD7GypVgMYTHg/g7pOsNTis3jlSpfq3utWAC
         1+ES5h383fmwvKqIIvZKqNs94gcl+REKw/N8G+dDLfdc69lfUY7Rum9e1A6K2lMbVRgK
         +Ar161VjNzswIBrPMnHdA7D4ZaPtBGUlYnPrggI3FHdy7yEZHUjboVHgkWWCA8STzkFm
         G0pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZU0DTR2jkb6BgDEFwVxRI9QZqgszPA2FbK1oe+H0PD0=;
        b=2Y1BgHGFImd11f6Z0XxdK1y6YLy6StGoEOXKnEHRX9IM+onA1Q9FU4JmfKsS3cxj87
         keuwUlsEG3RnL7kwBaYAJszlm17vZb6Zcu7iUk3BvFbUFPqa+z7qA2K6/Kcq2o5IQAKv
         6+meZIYB7tyzEplztFWHoattRxFYDpybQuJmR84vjyTHaodAtNPSAVw0HEGY9hex1ADl
         I7KoigJeFL3A+znMWZTikqfPzIAqW8GOy4mQANG+gjODEUr5I097/N84PsXyAWvQx+IB
         oAIq4LJIjkCNG+Hg3oInISZ1fm4SFwZo70WLrZr2XOm5nAsq5GwwGdC9rVyuRi4JxCGY
         wLgg==
X-Gm-Message-State: AO0yUKWx63moVtm1MZ5evswr0SdWGxfwG8CnW8JAxojUNVA0KWzEwM61
        i321xoL0aakqg5hqObR2KlqRFZbsyNCLCeFLAp4r3AmlmdoWLZ07
X-Google-Smtp-Source: AK7set/2Jam/yTqYxsoy0TFU+P+8+KchIrgjR/8cM+Z+RIPwBKZrN3bDSHSfkgI6escJzSwXxywzRNH2A400Q/NQOLg=
X-Received: by 2002:aca:b9c2:0:b0:364:80bf:a3a8 with SMTP id
 j185-20020acab9c2000000b0036480bfa3a8mr1018623oif.243.1676051816639; Fri, 10
 Feb 2023 09:56:56 -0800 (PST)
MIME-Version: 1.0
References: <20230201025048.205820-1-jingzhangos@google.com>
 <20230201025048.205820-5-jingzhangos@google.com> <CAAeT=Fy8PN3i-FTMN+c8dauP8qToXZM_toaUx=34Y4hima8teQ@mail.gmail.com>
 <CAAdAUthcEuKB8UG_zR4bFjn9eSJx2m2xNQgPO+7+iZVtmrhk_Q@mail.gmail.com> <CAAeT=Fy+0vs1X_fotjf0zstNyjdJtYUYvr-wa=jXShovQ-idqA@mail.gmail.com>
In-Reply-To: <CAAeT=Fy+0vs1X_fotjf0zstNyjdJtYUYvr-wa=jXShovQ-idqA@mail.gmail.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Fri, 10 Feb 2023 09:56:44 -0800
Message-ID: <CAAdAUti7h4DcLydwXobuJ_TEjLPzQQpwk7gj+kUvyw541RCVnQ@mail.gmail.com>
Subject: Re: [PATCH v1 4/6] KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
To:     Reiji Watanabe <reijiw@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
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

Hi Reiji,

On Thu, Feb 9, 2023 at 10:16 PM Reiji Watanabe <reijiw@google.com> wrote:
>
> Hi Jing,
>
> On Thu, Feb 9, 2023 at 1:25 PM Jing Zhang <jingzhangos@google.com> wrote:
> >
> > On Mon, Feb 6, 2023 at 9:30 PM Reiji Watanabe <reijiw@google.com> wrote:
> > >
> > > Hi Jing,
> > >
> > > On Tue, Jan 31, 2023 at 6:51 PM Jing Zhang <jingzhangos@google.com> wrote:
> > > >
> > > > With per guest ID registers, PMUver settings from userspace
> > > > can be stored in its corresponding ID register.
> > > >
> > > > No functional change intended.
> > > >
> > > > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > > > ---
> > > >  arch/arm64/include/asm/kvm_host.h |  5 -----
> > > >  arch/arm64/kvm/arm.c              |  6 ------
> > > >  arch/arm64/kvm/id_regs.c          | 33 ++++++++++++++++++++-----------
> > > >  include/kvm/arm_pmu.h             |  6 ++++--
> > > >  4 files changed, 25 insertions(+), 25 deletions(-)
> > > >
> > > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > > index fabb30185a4a..1ab443b52c46 100644
> > > > --- a/arch/arm64/include/asm/kvm_host.h
> > > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > > @@ -225,11 +225,6 @@ struct kvm_arch {
> > > >
> > > >         cpumask_var_t supported_cpus;
> > > >
> > > > -       struct {
> > > > -               u8 imp:4;
> > > > -               u8 unimp:4;
> > > > -       } dfr0_pmuver;
> > > > -
> > > >         /* Hypercall features firmware registers' descriptor */
> > > >         struct kvm_smccc_features smccc_feat;
> > > >
> > > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > > index d8ba5106bf51..25bd95650223 100644
> > > > --- a/arch/arm64/kvm/arm.c
> > > > +++ b/arch/arm64/kvm/arm.c
> > > > @@ -138,12 +138,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> > > >         kvm_arm_set_default_id_regs(kvm);
> > > >         kvm_arm_init_hypercalls(kvm);
> > > >
> > > > -       /*
> > > > -        * Initialise the default PMUver before there is a chance to
> > > > -        * create an actual PMU.
> > > > -        */
> > > > -       kvm->arch.dfr0_pmuver.imp = kvm_arm_pmu_get_pmuver_limit();
> > > > -
> > > >         return 0;
> > > >
> > > >  err_free_cpumask:
> > > > diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> > > > index bc5d9bc84eb1..5eade7d380af 100644
> > > > --- a/arch/arm64/kvm/id_regs.c
> > > > +++ b/arch/arm64/kvm/id_regs.c
> > > > @@ -19,10 +19,12 @@
> > > >
> > > >  static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
> > > >  {
> > > > -       if (kvm_vcpu_has_pmu(vcpu))
> > > > -               return vcpu->kvm->arch.dfr0_pmuver.imp;
> > > > -
> > > > -       return vcpu->kvm->arch.dfr0_pmuver.unimp;
> > > > +       u8 pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
> > > > +                       IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1));
> > > > +       if (kvm_vcpu_has_pmu(vcpu) || pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
> > > > +               return pmuver;
> > > > +       else
> > > > +               return 0;
> > > >  }
> > > >
> > > >  static u8 perfmon_to_pmuver(u8 perfmon)
> > > > @@ -263,10 +265,9 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> > > >         if (val)
> > > >                 return -EINVAL;
> > > >
> > > > -       if (valid_pmu)
> > > > -               vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
> > > > -       else
> > > > -               vcpu->kvm->arch.dfr0_pmuver.unimp = pmuver;
> > > > +       IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > > > +       IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=
> > > > +               FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), pmuver);
> > >
> > > Did you consider there could be guests that have vCPUs with and
> > > without PMU ? It looks like the code doesn't work for such guests.
> > > (e.g. for such guests, if setting the register is done for vCPUs
> > >  without PMU, this code seems to make PMUVer zero or 0xf
> > >  even for vCPUs with PMU)
> > Yes, I did. The PMUVer field is a per-VCPU field, whose value was
> > determined on the fly in the get_user function. Check the function
> > kvm_arm_read_id_reg_with_encoding, vcpu_pmuver is called to set the
> > real value for the VCPU.
> > The perVM ID registers array we put in the kvm structure save
> > correctly only for those perVM field, for those pre-VCPU filed, their
> > real value is determined on the fly during the register reading
> > (get_user).
>
> Yes, I understand that part.
> But, if a guest has 2 VCPUs, one of which has a PMU and the other
> does not, the PMUVer for them will be different.  Which value do
> you try to save in the per VM field ?
>
> It appears that the code always saves the last value set by
> userspace in the per VM field, regardless of whether the vCPU
> has PMU or not.
> If the last value is set for the vCPU without PMU, the per VM
> field will be either 0 or 0xf.  Since the per VM field is always
> used by vcpu_pmuver() for vCPUs with PMU, I would think the
> PMUVer for the vCPU with PMU will end up being 0 or 0xf in this
> case (NOTE: the PMUVer for vCPUs with PMU should not be 0 or 0xf).
>
> Or am I missing something??
Thanks for the clarification. You are right about the issue. I'll fix
it in the next version by utilizing a bit in kvm->arch.flags to
indicate the IMPDEF PMU. The value stored in id_regs would be the one
for vCPU with PMU support.
>
> Thanks,
> Reiji
