Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A14D6B6E51
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 05:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjCMEN0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 00:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjCMENY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 00:13:24 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE071816F
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 21:13:22 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id j3-20020a17090adc8300b0023d09aea4a6so1304714pjv.5
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 21:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678680801;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9d29HNVv/mtH93nCPpIBpKbg6i8n20OjIXEbDsVv/Ck=;
        b=oQ2Y2P//6FC33/dHHWYMs+qwhmmgU6yQd8B9Up4ZOIriHmJ8YT5gbDVsEtYUXT/811
         /s2ttDtK2vuhgsjBuPHoi76ED5d9Yv9pBnQ6wk2lkcQ5IGd/+oV4U5S4Lch3OIdXNICA
         Er2jFcKb7SogYd1uRwC7STz7q1AWs8OD2xMvWKOFgcH8Jqy4AGW20cFyjw2/vz1DN+ir
         O2J8Na4/exAEFCjnPabv+NozEMn8U9MQFE1fJw3oMdBk04YaOgxWii78ME77FfxJFsOa
         dkRQ/2WfNFzY3vlW0UuijH5lqwTcnaLxf9eO7uMQRq6wxBzYASeL4LIMRf+30Y9Cxifm
         iRng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678680801;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9d29HNVv/mtH93nCPpIBpKbg6i8n20OjIXEbDsVv/Ck=;
        b=hKtQS7E4kuGhykZ6ENh5RMZjuqotvGqsurebgOlJp00VtvvJM6sqPcBPGAdISepP0x
         U4lNUVPXTcIxFfrtsA5PIkK0MWHD6pBOzBLCORV7S8ZqZFAI/e7fy8SJ8vJw5LOGNEHz
         mJ37NK8/H/PAx4nm6aGj8DgQ0ZPuGG7VLtHCip0mBdDhRZRMiGXYi1QjaSKMoeYPsOLK
         hvmiU1UTg6E8NCQx5HalH3RiDM5TMVKNvlGTxaLSVUqBnjDBveSbu7WdvqFZ48Jtkecc
         Wr5Mks+lIQTYhvJUqXVIjY2kA9RxqDk3/scPYpJm4qrBzj20zIGlc8DaG1zi6UCiSqz/
         oNkw==
X-Gm-Message-State: AO0yUKU7vMXmMVxIU2gyMPo6mG/DSxr8EOgdnxcU6SxxzWqYAbGWlyMe
        6uqQ2TTcbmVUtPEBXSi9AYGW2Xl9dEei+9Qx6z+oHA==
X-Google-Smtp-Source: AK7set/PpUcE2K9JPmajZAFuI6t4TZ8xNrjEi/xAPgOMz3bhLrJQ+nPCEqYCsdB3HhCH0NfSwkOajsS1xi72dvi/oVs=
X-Received: by 2002:a17:903:280f:b0:19e:f660:81ee with SMTP id
 kp15-20020a170903280f00b0019ef66081eemr6069717plb.2.1678680801431; Sun, 12
 Mar 2023 21:13:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230228062246.1222387-1-jingzhangos@google.com>
 <20230228062246.1222387-5-jingzhangos@google.com> <CAAeT=Fzm_O-fbk2+jCExtnk7x4XXO1UwiviMmn0BU53A7Ea9WQ@mail.gmail.com>
 <CAAdAUtiSfMUHwBmFwvSpo5TdsdSDiEQWqJacg7YNzU_8b+AkDw@mail.gmail.com>
In-Reply-To: <CAAdAUtiSfMUHwBmFwvSpo5TdsdSDiEQWqJacg7YNzU_8b+AkDw@mail.gmail.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Sun, 12 Mar 2023 21:13:05 -0700
Message-ID: <CAAeT=FzokuakbRG5U75zCbGzgB-DN17pq+MTLCH1+4iXL7vLHQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
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
Content-Transfer-Encoding: quoted-printable
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

On Thu, Mar 9, 2023 at 6:38=E2=80=AFPM Jing Zhang <jingzhangos@google.com> =
wrote:
>
> Hi Reiji,
>
> On Wed, Mar 8, 2023 at 8:42 AM Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Hi Jing,
> >
> > On Mon, Feb 27, 2023 at 10:23=E2=80=AFPM Jing Zhang <jingzhangos@google=
.com> wrote:
> > >
> > > With per guest ID registers, PMUver settings from userspace
> > > can be stored in its corresponding ID register.
> > >
> > > No functional change intended.
> > >
> > > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_host.h | 11 ++++---
> > >  arch/arm64/kvm/arm.c              |  6 ----
> > >  arch/arm64/kvm/id_regs.c          | 52 ++++++++++++++++++++++++-----=
--
> > >  include/kvm/arm_pmu.h             |  6 ++--
> > >  4 files changed, 51 insertions(+), 24 deletions(-)
> > >
> > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/a=
sm/kvm_host.h
> > > index f64347eb77c2..effb61a9a855 100644
> > > --- a/arch/arm64/include/asm/kvm_host.h
> > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > @@ -218,6 +218,12 @@ struct kvm_arch {
> > >  #define KVM_ARCH_FLAG_EL1_32BIT                                4
> > >         /* PSCI SYSTEM_SUSPEND enabled for the guest */
> > >  #define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED           5
> > > +       /*
> > > +        * AA64DFR0_EL1.PMUver was set as ID_AA64DFR0_EL1_PMUVer_IMP_=
DEF
> > > +        * or DFR0_EL1.PerfMon was set as ID_DFR0_EL1_PerfMon_IMPDEF =
from
> > > +        * userspace for VCPUs without PMU.
> > > +        */
> > > +#define KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU             6
> > >
> > >         unsigned long flags;
> > >
> > > @@ -230,11 +236,6 @@ struct kvm_arch {
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
> > > index c78d68d011cb..fb2de2cb98cb 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -138,12 +138,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned l=
ong type)
> > >         kvm_arm_set_default_id_regs(kvm);
> > >         kvm_arm_init_hypercalls(kvm);
> > >
> > > -       /*
> > > -        * Initialise the default PMUver before there is a chance to
> > > -        * create an actual PMU.
> > > -        */
> > > -       kvm->arch.dfr0_pmuver.imp =3D kvm_arm_pmu_get_pmuver_limit();
> > > -
> > >         return 0;
> > >
> > >  err_free_cpumask:
> > > diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> > > index 36859e4caf02..21ec8fc10d79 100644
> > > --- a/arch/arm64/kvm/id_regs.c
> > > +++ b/arch/arm64/kvm/id_regs.c
> > > @@ -21,9 +21,12 @@
> > >  static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
> > >  {
> > >         if (kvm_vcpu_has_pmu(vcpu))
> > > -               return vcpu->kvm->arch.dfr0_pmuver.imp;
> > > -
> > > -       return vcpu->kvm->arch.dfr0_pmuver.unimp;
> > > +               return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_P=
MUVer),
> > > +                               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1)=
);
> > > +       else if (test_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->=
kvm->arch.flags))
> > > +               return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
> > > +       else
> > > +               return 0;
> > >  }
> > >
> > >  static u8 perfmon_to_pmuver(u8 perfmon)
> > > @@ -256,10 +259,19 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu =
*vcpu,
> > >         if (val)
> > >                 return -EINVAL;
> > >
> > > -       if (valid_pmu)
> > > -               vcpu->kvm->arch.dfr0_pmuver.imp =3D pmuver;
> > > -       else
> > > -               vcpu->kvm->arch.dfr0_pmuver.unimp =3D pmuver;
> > > +       if (valid_pmu) {
> > > +               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &=3D ~ARM64_FEA=
TURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > > +               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=3D
> > > +                       FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1=
_PMUVer), pmuver);
> > > +
> > > +               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &=3D ~ARM64_FEATURE=
_MASK(ID_DFR0_EL1_PerfMon);
> > > +               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=3D
> > > +                       FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_Per=
fMon), pmuver);
> >
> > The pmuver must be converted to perfmon for ID_DFR0_EL1.
> Yes, wil fix it.
> >
> > Also, I think those registers should be updated atomically, although PM=
Uver
> > specified by userspace will be normally the same for all vCPUs with
> > PMUv3 configured (I have the same comment for set_id_dfr0_el1()).
> >
> I think there is no race condition here. No corrupted data would be
> set in the field, right?

If userspace tries to set inconsistent values of PMUver/Perfmon
for vCPUs with vPMU configured at the same time, PMUver and Perfmon
won't be consistent even with this KVM code.
It won't be sane userspace though :)

> >
> > > +       } else if (pmuver =3D=3D ID_AA64DFR0_EL1_PMUVer_IMP_DEF) {
> > > +               set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kv=
m->arch.flags);
> > > +       } else {
> > > +               clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->=
kvm->arch.flags);
> > > +       }
> > >
> > >         return 0;
> > >  }
> > > @@ -296,10 +308,19 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcp=
u,
> > >         if (val)
> > >                 return -EINVAL;
> > >
> > > -       if (valid_pmu)
> > > -               vcpu->kvm->arch.dfr0_pmuver.imp =3D perfmon_to_pmuver=
(perfmon);
> > > -       else
> > > -               vcpu->kvm->arch.dfr0_pmuver.unimp =3D perfmon_to_pmuv=
er(perfmon);
> > > +       if (valid_pmu) {
> > > +               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &=3D ~ARM64_FEATURE=
_MASK(ID_DFR0_EL1_PerfMon);
> > > +               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=3D FIELD_PREP(
> > > +                       ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), perf=
mon_to_pmuver(perfmon));
> >
> > The perfmon value should be set for ID_DFR0_EL1 (not pmuver).
> >
> Sure, will fix it.
> > > +
> > > +               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &=3D ~ARM64_FEA=
TURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > > +               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=3D FIELD_PREP=
(
> > > +                       ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), p=
erfmon_to_pmuver(perfmon));
> > > +       } else if (perfmon =3D=3D ID_DFR0_EL1_PerfMon_IMPDEF) {
> > > +               set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kv=
m->arch.flags);
> > > +       } else {
> > > +               clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->=
kvm->arch.flags);
> > > +       }
> > >
> > >         return 0;
> > >  }
> > > @@ -543,4 +564,13 @@ void kvm_arm_set_default_id_regs(struct kvm *kvm=
)
> > >         }
> > >
> > >         IDREG(kvm, SYS_ID_AA64PFR0_EL1) =3D val;
> > > +
> > > +       /*
> > > +        * Initialise the default PMUver before there is a chance to
> > > +        * create an actual PMU.
> > > +        */
> > > +       IDREG(kvm, SYS_ID_AA64DFR0_EL1) &=3D ~ARM64_FEATURE_MASK(ID_A=
A64DFR0_EL1_PMUVer);
> > > +       IDREG(kvm, SYS_ID_AA64DFR0_EL1) |=3D
> > > +               FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer)=
,
> > > +                          kvm_arm_pmu_get_pmuver_limit());
> > >  }
> > > diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> > > index 628775334d5e..eef67b7d9751 100644
> > > --- a/include/kvm/arm_pmu.h
> > > +++ b/include/kvm/arm_pmu.h
> > > @@ -92,8 +92,10 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vc=
pu);
> > >  /*
> > >   * Evaluates as true when emulating PMUv3p5, and false otherwise.
> > >   */
> > > -#define kvm_pmu_is_3p5(vcpu)                                        =
   \
> > > -       (vcpu->kvm->arch.dfr0_pmuver.imp >=3D ID_AA64DFR0_EL1_PMUVer_=
V3P5)
> > > +#define kvm_pmu_is_3p5(vcpu)                                        =
                           \
> > > +       (kvm_vcpu_has_pmu(vcpu) &&                                   =
                           \
> >
> > What is the reason for adding this kvm_vcpu_has_pmu() checking ?
> > I don't think this patch's changes necessitated this.
> For the same VM, is it possible that some VCPUs would have PMU, but
> some may not have?
> That's why the kvm_vcpu_has_pmu is added here.

Yes, it's possible. But, it doesn't appear that this patch or any
patches in the series adds a code that newly uses the macro.
I believe this macro is always used for the vCPUs with vPMU
configured currently.
Did you find a case where this is used for vCPUs with no vPMU ?

If this change tries to address an existing issue, I think it would
be nicer to fix this in a separate patch. Or it would be helpful
if you could add an explanation in the commit log at least.

Thank you,
Reiji
