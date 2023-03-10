Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB5F6B3457
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 03:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjCJCil (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 21:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjCJCii (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 21:38:38 -0500
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D5A7DAA
        for <kvm@vger.kernel.org>; Thu,  9 Mar 2023 18:38:32 -0800 (PST)
Received: by mail-oo1-xc31.google.com with SMTP id u3-20020a4ad0c3000000b0052541ef0bafso599017oor.5
        for <kvm@vger.kernel.org>; Thu, 09 Mar 2023 18:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678415912;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b7t6O2KMMq37bm277QLmLICEVEmQKxMNjlgWb5w3+Mc=;
        b=L4PRyvqDqpjIbp27s16BnckpH3CpPHu3ePaQhAp0IChSOt2J/srDDyzRbUZ82tyUji
         DDnnP14YPGgmehOgtlrJNOQQUM1xdfaTt37VcgR0Wfm1x4L+r5cl+wZTqEyYuLTxL7vQ
         lSumvGPvCs1YCgsDgEFAFU5evSViatfj9K6cv4YOkBdQnxzn0B4gMQnbF80U/VhILVCp
         GJGc250fixc8dtv5Xt4GBTQQlqrt/GLSSVDLDCjUPaKlmkKNQa23EcPOM3UTGEiRVLJq
         WBs4BbX1/pque32ZF1kr/ttjboDGkBxZkBUhkRx1Xk3GUIwUo6HKrHe/CsG+SsI2rNLV
         EzCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678415912;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b7t6O2KMMq37bm277QLmLICEVEmQKxMNjlgWb5w3+Mc=;
        b=Km1baS7o4V2chSsE7+ez+B/2IVv8Blx5IiYT4rUH/gfCpI0ruW00LnmsGraAl6wuRT
         RkBWuQp66L2+QBjdz1eu0UmdAjhHgGFiVCfln+NAVWocsHTmCsGOpGyzoVC4ddOC/a/f
         /o3DAmDXbh4L5+OkkKMQ7B69lxqcaJBt5IVQgrlH2AAEf86eYMmvaQ0SuNUxUBmPoj0V
         nZDoKokFDmkv2VI/IN4cuk798tTbleTVcOhZFOiYjeRDWyzoNI1WYB0juiWqMaoPx0BO
         ptbjKKQI2HWNi15UJgSfkclSVbtAUOYpyOny7LznL6qEU3N+MfQrsH8DlGyjyPleuu+y
         PpoA==
X-Gm-Message-State: AO0yUKXxbmj75j4UO88knn7/hdpwwG6s/msqRg4qCrNLTH1G2LR/5Vlg
        wTNAN4cInfSE8uqg+NCdH37ovKC5Fvj1B90yG05Drw==
X-Google-Smtp-Source: AK7set/JxI6W3C5rLL2FSpjcyauEWtR1JYgVg4F5BJZ5O1LIhvBBHv7xIPcNRRlokD0INeKbpkfd85FMD9vfRVZntzw=
X-Received: by 2002:a4a:bd92:0:b0:525:23cc:a28e with SMTP id
 k18-20020a4abd92000000b0052523cca28emr8252023oop.0.1678415911762; Thu, 09 Mar
 2023 18:38:31 -0800 (PST)
MIME-Version: 1.0
References: <20230228062246.1222387-1-jingzhangos@google.com>
 <20230228062246.1222387-5-jingzhangos@google.com> <CAAeT=Fzm_O-fbk2+jCExtnk7x4XXO1UwiviMmn0BU53A7Ea9WQ@mail.gmail.com>
In-Reply-To: <CAAeT=Fzm_O-fbk2+jCExtnk7x4XXO1UwiviMmn0BU53A7Ea9WQ@mail.gmail.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Thu, 9 Mar 2023 18:38:19 -0800
Message-ID: <CAAdAUtiSfMUHwBmFwvSpo5TdsdSDiEQWqJacg7YNzU_8b+AkDw@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
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

Hi Reiji,

On Wed, Mar 8, 2023 at 8:42 AM Reiji Watanabe <reijiw@google.com> wrote:
>
> Hi Jing,
>
> On Mon, Feb 27, 2023 at 10:23=E2=80=AFPM Jing Zhang <jingzhangos@google.c=
om> wrote:
> >
> > With per guest ID registers, PMUver settings from userspace
> > can be stored in its corresponding ID register.
> >
> > No functional change intended.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 11 ++++---
> >  arch/arm64/kvm/arm.c              |  6 ----
> >  arch/arm64/kvm/id_regs.c          | 52 ++++++++++++++++++++++++-------
> >  include/kvm/arm_pmu.h             |  6 ++--
> >  4 files changed, 51 insertions(+), 24 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> > index f64347eb77c2..effb61a9a855 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -218,6 +218,12 @@ struct kvm_arch {
> >  #define KVM_ARCH_FLAG_EL1_32BIT                                4
> >         /* PSCI SYSTEM_SUSPEND enabled for the guest */
> >  #define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED           5
> > +       /*
> > +        * AA64DFR0_EL1.PMUver was set as ID_AA64DFR0_EL1_PMUVer_IMP_DE=
F
> > +        * or DFR0_EL1.PerfMon was set as ID_DFR0_EL1_PerfMon_IMPDEF fr=
om
> > +        * userspace for VCPUs without PMU.
> > +        */
> > +#define KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU             6
> >
> >         unsigned long flags;
> >
> > @@ -230,11 +236,6 @@ struct kvm_arch {
> >
> >         cpumask_var_t supported_cpus;
> >
> > -       struct {
> > -               u8 imp:4;
> > -               u8 unimp:4;
> > -       } dfr0_pmuver;
> > -
> >         /* Hypercall features firmware registers' descriptor */
> >         struct kvm_smccc_features smccc_feat;
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index c78d68d011cb..fb2de2cb98cb 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -138,12 +138,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned lon=
g type)
> >         kvm_arm_set_default_id_regs(kvm);
> >         kvm_arm_init_hypercalls(kvm);
> >
> > -       /*
> > -        * Initialise the default PMUver before there is a chance to
> > -        * create an actual PMU.
> > -        */
> > -       kvm->arch.dfr0_pmuver.imp =3D kvm_arm_pmu_get_pmuver_limit();
> > -
> >         return 0;
> >
> >  err_free_cpumask:
> > diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> > index 36859e4caf02..21ec8fc10d79 100644
> > --- a/arch/arm64/kvm/id_regs.c
> > +++ b/arch/arm64/kvm/id_regs.c
> > @@ -21,9 +21,12 @@
> >  static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
> >  {
> >         if (kvm_vcpu_has_pmu(vcpu))
> > -               return vcpu->kvm->arch.dfr0_pmuver.imp;
> > -
> > -       return vcpu->kvm->arch.dfr0_pmuver.unimp;
> > +               return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMU=
Ver),
> > +                               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1));
> > +       else if (test_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kv=
m->arch.flags))
> > +               return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
> > +       else
> > +               return 0;
> >  }
> >
> >  static u8 perfmon_to_pmuver(u8 perfmon)
> > @@ -256,10 +259,19 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *v=
cpu,
> >         if (val)
> >                 return -EINVAL;
> >
> > -       if (valid_pmu)
> > -               vcpu->kvm->arch.dfr0_pmuver.imp =3D pmuver;
> > -       else
> > -               vcpu->kvm->arch.dfr0_pmuver.unimp =3D pmuver;
> > +       if (valid_pmu) {
> > +               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &=3D ~ARM64_FEATU=
RE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > +               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=3D
> > +                       FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_P=
MUVer), pmuver);
> > +
> > +               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &=3D ~ARM64_FEATURE_M=
ASK(ID_DFR0_EL1_PerfMon);
> > +               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=3D
> > +                       FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfM=
on), pmuver);
>
> The pmuver must be converted to perfmon for ID_DFR0_EL1.
Yes, wil fix it.
>
> Also, I think those registers should be updated atomically, although PMUv=
er
> specified by userspace will be normally the same for all vCPUs with
> PMUv3 configured (I have the same comment for set_id_dfr0_el1()).
>
I think there is no race condition here. No corrupted data would be
set in the field, right?
>
> > +       } else if (pmuver =3D=3D ID_AA64DFR0_EL1_PMUVer_IMP_DEF) {
> > +               set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm-=
>arch.flags);
> > +       } else {
> > +               clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kv=
m->arch.flags);
> > +       }
> >
> >         return 0;
> >  }
> > @@ -296,10 +308,19 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> >         if (val)
> >                 return -EINVAL;
> >
> > -       if (valid_pmu)
> > -               vcpu->kvm->arch.dfr0_pmuver.imp =3D perfmon_to_pmuver(p=
erfmon);
> > -       else
> > -               vcpu->kvm->arch.dfr0_pmuver.unimp =3D perfmon_to_pmuver=
(perfmon);
> > +       if (valid_pmu) {
> > +               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &=3D ~ARM64_FEATURE_M=
ASK(ID_DFR0_EL1_PerfMon);
> > +               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=3D FIELD_PREP(
> > +                       ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), perfmo=
n_to_pmuver(perfmon));
>
> The perfmon value should be set for ID_DFR0_EL1 (not pmuver).
>
Sure, will fix it.
> > +
> > +               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &=3D ~ARM64_FEATU=
RE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > +               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=3D FIELD_PREP(
> > +                       ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), per=
fmon_to_pmuver(perfmon));
> > +       } else if (perfmon =3D=3D ID_DFR0_EL1_PerfMon_IMPDEF) {
> > +               set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm-=
>arch.flags);
> > +       } else {
> > +               clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kv=
m->arch.flags);
> > +       }
> >
> >         return 0;
> >  }
> > @@ -543,4 +564,13 @@ void kvm_arm_set_default_id_regs(struct kvm *kvm)
> >         }
> >
> >         IDREG(kvm, SYS_ID_AA64PFR0_EL1) =3D val;
> > +
> > +       /*
> > +        * Initialise the default PMUver before there is a chance to
> > +        * create an actual PMU.
> > +        */
> > +       IDREG(kvm, SYS_ID_AA64DFR0_EL1) &=3D ~ARM64_FEATURE_MASK(ID_AA6=
4DFR0_EL1_PMUVer);
> > +       IDREG(kvm, SYS_ID_AA64DFR0_EL1) |=3D
> > +               FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
> > +                          kvm_arm_pmu_get_pmuver_limit());
> >  }
> > diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> > index 628775334d5e..eef67b7d9751 100644
> > --- a/include/kvm/arm_pmu.h
> > +++ b/include/kvm/arm_pmu.h
> > @@ -92,8 +92,10 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu=
);
> >  /*
> >   * Evaluates as true when emulating PMUv3p5, and false otherwise.
> >   */
> > -#define kvm_pmu_is_3p5(vcpu)                                          =
 \
> > -       (vcpu->kvm->arch.dfr0_pmuver.imp >=3D ID_AA64DFR0_EL1_PMUVer_V3=
P5)
> > +#define kvm_pmu_is_3p5(vcpu)                                          =
                         \
> > +       (kvm_vcpu_has_pmu(vcpu) &&                                     =
                         \
>
> What is the reason for adding this kvm_vcpu_has_pmu() checking ?
> I don't think this patch's changes necessitated this.
For the same VM, is it possible that some VCPUs would have PMU, but
some may not have?
That's why the kvm_vcpu_has_pmu is added here.
>
> > +        FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),         =
                         \
> > +                IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1)) >=3D ID_AA64DFR=
0_EL1_PMUVer_V3P5)
> >
> >  u8 kvm_arm_pmu_get_pmuver_limit(void);
> >
> > --
> > 2.39.2.722.g9855ee24e9-goog
> >
> >
>
> Thank you,
> Reiji
Thanks,
Jing
