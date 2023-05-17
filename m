Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 216437075A8
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 00:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjEQW4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 18:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjEQWz6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 18:55:58 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 308765B9A
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 15:55:57 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-19a19778b09so585320fac.3
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 15:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684364156; x=1686956156;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=46QpodnGSfHclqw+wxHyKFNt8ooXzRh8RHIYqYrx2+k=;
        b=4+k/qgLfKUbMibjVom5X5UhnGbYr8SY7C4iqF+FjTJPLgxW+FBx+j8VsQMmRbh+LBM
         4HY/nqXerEYNVykQDDyUKEf1PkTanAbpYJIp+6CT/R0xIDDxnZcIeD0cTsct/n+fL2/h
         gIlyInibT0h0yvhStw/4gnW7b/RZCvz9SWM5wNrX9jexUtTLoi3zBHKDMpkQhjIvDpFJ
         CwfGqoDlAf9LQwz/r8jjolXlVq/B2Tn/FfGXbwOnVHffKYY935TCVkIj93Bw33pWsqe3
         1FmE1LGrNcQCwBuvA/GZyt4U2DHr4ZY8pslIiGPLv2es9DjvjwkhPWAW9XIJmIt+iSVI
         zBbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684364156; x=1686956156;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=46QpodnGSfHclqw+wxHyKFNt8ooXzRh8RHIYqYrx2+k=;
        b=UEK6JLwOspjOxLviK9R290Dcoe7I2agcP7xH35yBrtHjHDxe4OiGWOWwY0hbEZTbdK
         SBrMJ5ODzraJCiCUf64KQpDezvvjoBYdasFbujx89tZ+k92CfPYwCW2ARuoCYhVYW1B8
         KiYWnvNC6ltIWuvK4ULi6nT0spyojL2dwluikGRCVv+J74ti5kye70myBtUDEf7DEdPs
         nx/+yb131zJcZTh34fuTMMkrOJJkhs4MMdofCOGu3hum1ZsYUm312yWE+sV0aqOM88m2
         AEmgj1OvLdPePsKlbFzongmSV386D6oHv2Tts4h68TztDti7rPzxSUacQ6kv4mUewp4k
         LY7g==
X-Gm-Message-State: AC+VfDyM+kQ9eQLHCfrhTMOt7mxhwhk1ZgvMBLYsTq8a9BW9hdt9U0br
        fOkcoY8Zd/ETquPF7DmDJsR+DLcWtAwSCh3VoIGszQ==
X-Google-Smtp-Source: ACHHUZ6H1ghtK0PMEZjs5hL/HFrkQgf3pKsDKz0W5jSHZcWf9yXXh6vAhTaYH2vuFwwQF5OoI3Y71eqWqEXYN2I/B3E=
X-Received: by 2002:a05:6870:a891:b0:188:1195:5ec4 with SMTP id
 eb17-20020a056870a89100b0018811955ec4mr158820oab.40.1684364156311; Wed, 17
 May 2023 15:55:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230503171618.2020461-1-jingzhangos@google.com>
 <20230503171618.2020461-7-jingzhangos@google.com> <b64e5639b1b9bb5e5e4ff8eaa10554ae0d9a6016.camel@amazon.com>
In-Reply-To: <b64e5639b1b9bb5e5e4ff8eaa10554ae0d9a6016.camel@amazon.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Wed, 17 May 2023 15:55:44 -0700
Message-ID: <CAAdAUtibBVuMGhh9NEOxpEyMQ6bxde674ME+hHqERoT5hctETA@mail.gmail.com>
Subject: Re: [PATCH v8 6/6] KVM: arm64: Refactor writings for PMUVer/CSV2/CSV3
To:     "Jitindar Singh, Suraj" <surajjs@amazon.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "oupton@google.com" <oupton@google.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        "rananta@google.com" <rananta@google.com>,
        "tabba@google.com" <tabba@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alexandru.elisei@arm.com" <alexandru.elisei@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "reijiw@google.com" <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Suraj,

On Wed, May 17, 2023 at 3:00=E2=80=AFPM Jitindar Singh, Suraj
<surajjs@amazon.com> wrote:
>
> On Wed, 2023-05-03 at 17:16 +0000, Jing Zhang wrote:
> > Refactor writings for ID_AA64PFR0_EL1.[CSV2|CSV3],
> > ID_AA64DFR0_EL1.PMUVer and ID_DFR0_ELF.PerfMon based on utilities
> > introduced by ID register descriptor array.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/include/asm/cpufeature.h |   1 +
> >  arch/arm64/kernel/cpufeature.c      |   2 +-
> >  arch/arm64/kvm/id_regs.c            | 361 ++++++++++++++++++--------
> > --
> >  3 files changed, 242 insertions(+), 122 deletions(-)
> >
> >
>
> [ SNIP ]
>
> >
> > +static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> > +                                         const struct sys_reg_desc
> > *rd)
> > +{
> > +       u64 val;
> > +       u32 id =3D reg_to_encoding(rd);
> > +
> > +       val =3D read_sanitised_ftr_reg(id);
> > +       /*
> > +        * The default is to expose CSV2 =3D=3D 1 if the HW isn't
> > affected.
> > +        * Although this is a per-CPU feature, we make it global
> > because
> > +        * asymmetric systems are just a nuisance.
> > +        *
> > +        * Userspace can override this as long as it doesn't promise
> > +        * the impossible.
> > +        */
> > +       if (arm64_get_spectre_v2_state() =3D=3D SPECTRE_UNAFFECTED) {
> > +               val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
> > +               val |=3D
> > FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2), 1);
> > +       }
> > +       if (arm64_get_meltdown_state() =3D=3D SPECTRE_UNAFFECTED) {
> > +               val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
> > +               val |=3D
> > FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3), 1);
> > +       }
> > +
> > +       val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
> > +
> > +       return val;
> > +}
> > +
> >  static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> >                                const struct sys_reg_desc *rd,
> >                                u64 val)
> >  {
> > -       struct kvm_arch *arch =3D &vcpu->kvm->arch;
> > -       u64 sval =3D val;
> >         u8 csv2, csv3;
> > -       int ret =3D 0;
> >
> >         /*
> >          * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long
> > as
> > @@ -226,26 +338,30 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu
> > *vcpu,
> >         if (csv3 > 1 || (csv3 && arm64_get_meltdown_state() !=3D
> > SPECTRE_UNAFFECTED))
> >                 return -EINVAL;
>
> Can't we remove the checking of csv[23] here as it will be checked by
> arm64_check_features()?
>
> i.e. in arm64_check_features() we will load the "limit" value from the
> "reset" function (read_sanitised_id_aa64pfr0_el1()) which has csv[23]
> set appropriately and limit it to a safe value basically performing the
> same check as we are here.
The limit and the check here might be different if like
arm64_get_meltdown_state() is not SPECTRE_UNAFFECTED.
i.e. if we remove the check here, theoretically, the csv3 can be set a
value greater 1 if arm64_get_meltdown_state() is not
SPECTRE_UNAFFECTED.
>
> >
> > -       mutex_lock(&arch->config_lock);
> > -       /* We can only differ with CSV[23], and anything else is an
> > error */
> > -       val ^=3D read_id_reg(vcpu, rd);
> > -       val &=3D ~(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
> > -                ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
> > -       if (val) {
> > -               ret =3D -EINVAL;
> > -               goto out;
> > -       }
> > +       return set_id_reg(vcpu, rd, val);
> > +}
> >
> > -       /* Only allow userspace to change the idregs before VM
> > running */
> > -       if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &vcpu->kvm-
> > >arch.flags)) {
> > -               if (sval !=3D read_id_reg(vcpu, rd))
> > -                       ret =3D -EBUSY;
> > -       } else {
> > -               IDREG(vcpu->kvm, reg_to_encoding(rd)) =3D sval;
> > -       }
> > -out:
> > -       mutex_unlock(&arch->config_lock);
> > -       return ret;
> > +static u64 read_sanitised_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> > +                                         const struct sys_reg_desc
> > *rd)
> > +{
> > +       u64 val;
> > +       u32 id =3D reg_to_encoding(rd);
> > +
> > +       val =3D read_sanitised_ftr_reg(id);
> > +       /* Limit debug to ARMv8.0 */
> > +       val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer);
> > +       val |=3D
> > FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer), 6);
> > +       /*
> > +        * Initialise the default PMUver before there is a chance to
> > +        * create an actual PMU.
> > +        */
> > +       val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > +       val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
> > +                         kvm_arm_pmu_get_pmuver_limit());
> > +       /* Hide SPE from guests */
> > +       val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMSVer);
> > +
> > +       return val;
> >  }
> >
> >  static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> > @@ -255,7 +371,6 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu
> > *vcpu,
> >         struct kvm_arch *arch =3D &vcpu->kvm->arch;
> >         u8 pmuver, host_pmuver;
> >         bool valid_pmu;
> > -       u64 sval =3D val;
> >         int ret =3D 0;
> >
> >         host_pmuver =3D kvm_arm_pmu_get_pmuver_limit();
> > @@ -277,40 +392,61 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu
> > *vcpu,
> >                 return -EINVAL;
> >
> >         mutex_lock(&arch->config_lock);
> > -       /* We can only differ with PMUver, and anything else is an
> > error */
> > -       val ^=3D read_id_reg(vcpu, rd);
> > -       val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > -       if (val) {
> > -               ret =3D -EINVAL;
> > -               goto out;
> > -       }
> > -
> >         /* Only allow userspace to change the idregs before VM
> > running */
> >         if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &vcpu->kvm-
> > >arch.flags)) {
> > -               if (sval !=3D read_id_reg(vcpu, rd))
> > +               if (val !=3D read_id_reg(vcpu, rd))
> >                         ret =3D -EBUSY;
> > -       } else {
> > -               if (valid_pmu) {
> > -                       val =3D IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);
> > -                       val &=3D ~ID_AA64DFR0_EL1_PMUVer_MASK;
> > -                       val |=3D
> > FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK, pmuver);
> > -                       IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) =3D val;
> > -
> > -                       val =3D IDREG(vcpu->kvm, SYS_ID_DFR0_EL1);
> > -                       val &=3D ~ID_DFR0_EL1_PerfMon_MASK;
> > -                       val |=3D FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK,
> > pmuver_to_perfmon(pmuver));
> > -                       IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) =3D val;
> > -               } else {
> > -
> >                        assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU,
> > &vcpu->kvm->arch.flags,
> > -                                  pmuver =3D=3D
> > ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
> > -               }
> > +               goto out;
> > +       }
> > +
> > +       if (!valid_pmu) {
> > +               /*
> > +                * Ignore the PMUVer filed in @val. The PMUVer would
>
> Nit s/filed/field
Will fix.
>
> > be determined
> > +                * by arch flags bit
> > KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU,
> > +                */
> > +               pmuver =3D FIELD_GET(ID_AA64DFR0_EL1_PMUVer_MASK,
> > +                                  IDREG(vcpu->kvm,
> > SYS_ID_AA64DFR0_EL1));
> > +               val &=3D ~ID_AA64DFR0_EL1_PMUVer_MASK;
> > +               val |=3D FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK,
> > pmuver);
> >         }
> >
> > +       ret =3D arm64_check_features(vcpu, rd, val);
> > +       if (ret)
> > +               goto out;
> > +
> > +       IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) =3D val;
> > +
> > +       val =3D IDREG(vcpu->kvm, SYS_ID_DFR0_EL1);
> > +       val &=3D ~ID_DFR0_EL1_PerfMon_MASK;
> > +       val |=3D FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK,
> > pmuver_to_perfmon(pmuver));
> > +       IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) =3D val;
> > +
> > +       if (!valid_pmu)
> > +               assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu-
> > >kvm->arch.flags,
> > +                          pmuver =3D=3D ID_AA64DFR0_EL1_PMUVer_IMP_DEF=
);
> > +
> >  out:
> >         mutex_unlock(&arch->config_lock);
> >         return ret;
> >  }
> >
> > +static u64 read_sanitised_id_dfr0_el1(struct kvm_vcpu *vcpu,
> > +                                     const struct sys_reg_desc *rd)
> > +{
> > +       u64 val;
> > +       u32 id =3D reg_to_encoding(rd);
> > +
> > +       val =3D read_sanitised_ftr_reg(id);
> > +       /*
> > +        * Initialise the default PMUver before there is a chance to
> > +        * create an actual PMU.
> > +        */
> > +       val &=3D ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
> > +       val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon),
> > kvm_arm_pmu_get_pmuver_limit());
> > +
> > +       return val;
> > +}
> > +
> >  static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> >                            const struct sys_reg_desc *rd,
> >                            u64 val)
> > @@ -318,7 +454,6 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> >         struct kvm_arch *arch =3D &vcpu->kvm->arch;
> >         u8 perfmon, host_perfmon;
> >         bool valid_pmu;
> > -       u64 sval =3D val;
> >         int ret =3D 0;
> >
> >         host_perfmon =3D
> > pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit());
> > @@ -341,35 +476,39 @@ static int set_id_dfr0_el1(struct kvm_vcpu
> > *vcpu,
> >                 return -EINVAL;
> >
> >         mutex_lock(&arch->config_lock);
> > -       /* We can only differ with PerfMon, and anything else is an
> > error */
> > -       val ^=3D read_id_reg(vcpu, rd);
> > -       val &=3D ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
> > -       if (val) {
> > -               ret =3D -EINVAL;
> > -               goto out;
> > -       }
> > -
> >         /* Only allow userspace to change the idregs before VM
> > running */
> >         if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &vcpu->kvm-
> > >arch.flags)) {
> > -               if (sval !=3D read_id_reg(vcpu, rd))
> > +               if (val !=3D read_id_reg(vcpu, rd))
> >                         ret =3D -EBUSY;
> > -       } else {
> > -               if (valid_pmu) {
> > -                       val =3D IDREG(vcpu->kvm, SYS_ID_DFR0_EL1);
> > -                       val &=3D ~ID_DFR0_EL1_PerfMon_MASK;
> > -                       val |=3D FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK,
> > perfmon);
> > -                       IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) =3D val;
> > -
> > -                       val =3D IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);
> > -                       val &=3D ~ID_AA64DFR0_EL1_PMUVer_MASK;
> > -                       val |=3D
> > FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK, perfmon_to_pmuver(perfmon));
> > -                       IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) =3D val;
> > -               } else {
> > -
> >                        assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU,
> > &vcpu->kvm->arch.flags,
> > -                                  perfmon =3D=3D
> > ID_DFR0_EL1_PerfMon_IMPDEF);
> > -               }
> > +               goto out;
> > +       }
> > +
> > +       if (!valid_pmu) {
> > +               /*
> > +                * Ignore the PerfMon filed in @val. The PerfMon
>
> Nit s/filed/field
Thanks, will fix it.
>
> > would be determined
> > +                * by arch flags bit
> > KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU,
> > +                */
> > +               perfmon =3D FIELD_GET(ID_DFR0_EL1_PerfMon_MASK,
> > +                                   IDREG(vcpu->kvm,
> > SYS_ID_DFR0_EL1));
> > +               val &=3D ~ID_DFR0_EL1_PerfMon_MASK;
> > +               val |=3D FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK, perfmon);
> >         }
> >
> > +       ret =3D arm64_check_features(vcpu, rd, val);
> > +       if (ret)
> > +               goto out;
> > +
> > +       IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) =3D val;
> > +
> > +       val =3D IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);
> > +       val &=3D ~ID_AA64DFR0_EL1_PMUVer_MASK;
> > +       val |=3D FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK,
> > perfmon_to_pmuver(perfmon));
> > +       IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) =3D val;
> > +
> > +       if (!valid_pmu)
> > +               assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu-
> > >kvm->arch.flags,
> > +                          perfmon =3D=3D ID_DFR0_EL1_PerfMon_IMPDEF);
> > +
> >  out:
> >         mutex_unlock(&arch->config_lock);
> >         return ret;
>
> Otherwise looks good!
>
> Thanks,
> Suraj

Thanks,
Jing
