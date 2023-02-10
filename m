Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF947691862
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 07:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbjBJGQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 01:16:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjBJGQd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 01:16:33 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F5426CDD
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 22:16:32 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id x10so3069310pgx.3
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 22:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=97/ihdtp6V2pjbYvRPOOIOzLfOotsPAo1jCtaOeUcwQ=;
        b=bwBOJTsSaew3eTstkbpl+i8mpoHn9AMRw8wGAManl6ATA3qhWDEkoBZ/gRvEaIKQeg
         0hCUbG9eKhmjec3C6kfL1J7DhhWQlZ3+WR/agR8SFm5be8hjmZuA6+0LGAV4G5LywmCo
         CCIZC3BoCLj4EB4M/6660MoY6R51QoHb64CJNEEexTE83p6TXxSQU3xlDTuZa0tAtFu3
         ScB3vcOCUg5ODabX2eaVopaWRl1wC9non+apCRAN13uOKvyQY3TUnwpYlqPzrUdMNJRp
         tc3oKpIbNG8YEKmhuGtyEAX3rAHV9lEMFmP+5piV+JGeOyQCAuBZPlCH8zoSptyYu6nW
         bwHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=97/ihdtp6V2pjbYvRPOOIOzLfOotsPAo1jCtaOeUcwQ=;
        b=J3bnQYb1HhZOPNQC7Ha3sqPN8tMzpAoOAFlb+dt00KGX43qSjtjnyj8+UD5cjQ1sc0
         v9YZow4Vxicyn5XtXXKdUcdwGDVBdQliWfLC0fwVxdNSnw0fQDyu7S1Evd36VLoPn2+v
         SMh8QNcrPU1yPLtRAyBVFZEp1xxT2SVhsP13a+Ox1MsAx2hOmXsoG/GSjzdEW0U4rJVT
         u8luGyvJObC2ylVSlebgUs5zjyVIm0DC+VxxMzDUB6QljSDtJW2Rw494VjGYSRUOElce
         YXF4+OCCuIC5Yw/jstjVwWzsMHqjcHtDyNXeRrl0/S0NUfU/mHF8qjyXauBaDViojlkP
         NMQQ==
X-Gm-Message-State: AO0yUKXn/7atla5ePdia+8rGvTNMZFU9y6vyEkVriNBjSPbmP7PRCJiC
        HPt+LS2JHQ9mt18R34g9S1AhsTLC1R24sbC9Em9CWg==
X-Google-Smtp-Source: AK7set/viG6QnyBLFWs3u2i5MEUzyvJoLoshIrQ+OhJsGVX9iV3k7UFoOe0CclYsUumjQDdHiaKEfyqWF7KBJEnMVw8=
X-Received: by 2002:a62:6d85:0:b0:593:d5a2:e3a4 with SMTP id
 i127-20020a626d85000000b00593d5a2e3a4mr3053907pfc.45.1676009791852; Thu, 09
 Feb 2023 22:16:31 -0800 (PST)
MIME-Version: 1.0
References: <20230201025048.205820-1-jingzhangos@google.com>
 <20230201025048.205820-5-jingzhangos@google.com> <CAAeT=Fy8PN3i-FTMN+c8dauP8qToXZM_toaUx=34Y4hima8teQ@mail.gmail.com>
 <CAAdAUthcEuKB8UG_zR4bFjn9eSJx2m2xNQgPO+7+iZVtmrhk_Q@mail.gmail.com>
In-Reply-To: <CAAdAUthcEuKB8UG_zR4bFjn9eSJx2m2xNQgPO+7+iZVtmrhk_Q@mail.gmail.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 9 Feb 2023 22:16:15 -0800
Message-ID: <CAAeT=Fy+0vs1X_fotjf0zstNyjdJtYUYvr-wa=jXShovQ-idqA@mail.gmail.com>
Subject: Re: [PATCH v1 4/6] KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
To:     Jing Zhang <jingzhangos@google.com>
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

Hi Jing,

On Thu, Feb 9, 2023 at 1:25 PM Jing Zhang <jingzhangos@google.com> wrote:
>
> On Mon, Feb 6, 2023 at 9:30 PM Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Hi Jing,
> >
> > On Tue, Jan 31, 2023 at 6:51 PM Jing Zhang <jingzhangos@google.com> wrote:
> > >
> > > With per guest ID registers, PMUver settings from userspace
> > > can be stored in its corresponding ID register.
> > >
> > > No functional change intended.
> > >
> > > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_host.h |  5 -----
> > >  arch/arm64/kvm/arm.c              |  6 ------
> > >  arch/arm64/kvm/id_regs.c          | 33 ++++++++++++++++++++-----------
> > >  include/kvm/arm_pmu.h             |  6 ++++--
> > >  4 files changed, 25 insertions(+), 25 deletions(-)
> > >
> > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > index fabb30185a4a..1ab443b52c46 100644
> > > --- a/arch/arm64/include/asm/kvm_host.h
> > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > @@ -225,11 +225,6 @@ struct kvm_arch {
> > >
> > >         cpumask_var_t supported_cpus;
> > >
> > > -       struct {
> > > -               u8 imp:4;
> > > -               u8 unimp:4;
> > > -       } dfr0_pmuver;
> > > -
> > >         /* Hypercall features firmware registers' descriptor */
> > >         struct kvm_smccc_features smccc_feat;
> > >
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > index d8ba5106bf51..25bd95650223 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -138,12 +138,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> > >         kvm_arm_set_default_id_regs(kvm);
> > >         kvm_arm_init_hypercalls(kvm);
> > >
> > > -       /*
> > > -        * Initialise the default PMUver before there is a chance to
> > > -        * create an actual PMU.
> > > -        */
> > > -       kvm->arch.dfr0_pmuver.imp = kvm_arm_pmu_get_pmuver_limit();
> > > -
> > >         return 0;
> > >
> > >  err_free_cpumask:
> > > diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> > > index bc5d9bc84eb1..5eade7d380af 100644
> > > --- a/arch/arm64/kvm/id_regs.c
> > > +++ b/arch/arm64/kvm/id_regs.c
> > > @@ -19,10 +19,12 @@
> > >
> > >  static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
> > >  {
> > > -       if (kvm_vcpu_has_pmu(vcpu))
> > > -               return vcpu->kvm->arch.dfr0_pmuver.imp;
> > > -
> > > -       return vcpu->kvm->arch.dfr0_pmuver.unimp;
> > > +       u8 pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
> > > +                       IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1));
> > > +       if (kvm_vcpu_has_pmu(vcpu) || pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
> > > +               return pmuver;
> > > +       else
> > > +               return 0;
> > >  }
> > >
> > >  static u8 perfmon_to_pmuver(u8 perfmon)
> > > @@ -263,10 +265,9 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> > >         if (val)
> > >                 return -EINVAL;
> > >
> > > -       if (valid_pmu)
> > > -               vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
> > > -       else
> > > -               vcpu->kvm->arch.dfr0_pmuver.unimp = pmuver;
> > > +       IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > > +       IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=
> > > +               FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), pmuver);
> >
> > Did you consider there could be guests that have vCPUs with and
> > without PMU ? It looks like the code doesn't work for such guests.
> > (e.g. for such guests, if setting the register is done for vCPUs
> >  without PMU, this code seems to make PMUVer zero or 0xf
> >  even for vCPUs with PMU)
> Yes, I did. The PMUVer field is a per-VCPU field, whose value was
> determined on the fly in the get_user function. Check the function
> kvm_arm_read_id_reg_with_encoding, vcpu_pmuver is called to set the
> real value for the VCPU.
> The perVM ID registers array we put in the kvm structure save
> correctly only for those perVM field, for those pre-VCPU filed, their
> real value is determined on the fly during the register reading
> (get_user).

Yes, I understand that part.
But, if a guest has 2 VCPUs, one of which has a PMU and the other
does not, the PMUVer for them will be different.  Which value do
you try to save in the per VM field ?

It appears that the code always saves the last value set by
userspace in the per VM field, regardless of whether the vCPU
has PMU or not.
If the last value is set for the vCPU without PMU, the per VM
field will be either 0 or 0xf.  Since the per VM field is always
used by vcpu_pmuver() for vCPUs with PMU, I would think the
PMUVer for the vCPU with PMU will end up being 0 or 0xf in this
case (NOTE: the PMUVer for vCPUs with PMU should not be 0 or 0xf).

Or am I missing something??

Thanks,
Reiji
