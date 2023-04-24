Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F103D6ED515
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 21:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbjDXTHq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 15:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232463AbjDXTHo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 15:07:44 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BEDB59C0
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 12:07:43 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-1878560f69cso3444323fac.1
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 12:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682363262; x=1684955262;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4LmMKDW5sg8I2aCW2tSOveKUg6dpJBZdBwUQz/srPhs=;
        b=EOOuJEKTdpHSwY6gu7VIPDs+Wv2zqFVu+IxwehMYCPTNj4nbfHOpcb8wLXoEb1HPec
         D2jZF+jabH3VpxRti/AsgisU0osWV6lfB2Jc0eTIehKBHf1BGsWclp9ZdCAbTInDw1FH
         kR4GsBTv5TkfxcOFfs04EFyns5T4EsGPqTvfg/HrqVU7TEvtLiKaiXiKxt/2HK2tG7vq
         QzFumLoO85Y/XE7ZDKE/VmLguHKRIgE9RqkZz/1qEgZ50sG8XYl1uf3gAbtvuJ6xiqaq
         iNrNGdwyUMGPU40q/OHGdlRRHsWKzrv2YmPRqxQxJikKl6xOI6Dw047vMaWuJKG2uOMF
         EKxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682363262; x=1684955262;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4LmMKDW5sg8I2aCW2tSOveKUg6dpJBZdBwUQz/srPhs=;
        b=JgCM9YZuByiUu1EYTS0WxcGa1ZEbTKDNu2K6OacdguWnKSWcHeIca4Pddc7eSvA/DA
         toZC6eH1aOCrpo6V5U9skbkxB7i7JxBRrAcHuMv4kxCE0RC+Btjy/qkiZyv5b8nFKrTh
         5zo6eXH8Qiki14WavhPHP/kCv9LZ0hnmjf37Xj8ZDsVPvv7ZbL+0yCrIM1b3dItlX+Qv
         o3OetGc6VE7ePaVC3gF3dNCtaWn9WPiWM+BnG4CxIIcFO3VGYpdfnDVZa/mrfUcEHEtV
         n1xxXCTn+J/uHBP/VHMYjp/0k78snAd/eqrcdsqlNmLY/uKXcaRnxDdxDwXVbkXooA3B
         kXAA==
X-Gm-Message-State: AAQBX9fv8DAIZipTiml3rfYZj6TiByyzAAtpTwMkg6+/A2aOBOegkwlb
        MOtc1nkyzzhSRBP2mx5I1EUE+ku7GrCIiIkHnHlnLA==
X-Google-Smtp-Source: AKy350bVZUSgyTHNLiuXXC4/UXkbrJfaUChr6P0iizlJ5BUgmEkHQh0BaizUayTKy5bNgqrOsvfHpVdynuN0B6zudx4=
X-Received: by 2002:a05:6870:c38c:b0:187:7733:bcdb with SMTP id
 g12-20020a056870c38c00b001877733bcdbmr9882998oao.31.1682363262432; Mon, 24
 Apr 2023 12:07:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230404035344.4043856-1-jingzhangos@google.com>
 <20230404035344.4043856-5-jingzhangos@google.com> <20230419034042.r56jdectha4asyqi@google.com>
In-Reply-To: <20230419034042.r56jdectha4asyqi@google.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Mon, 24 Apr 2023 12:07:31 -0700
Message-ID: <CAAdAUtgpHCnoAJoVOW51C=_=7Hs9dJGUw1cjZAKMPuV-8eyLJw@mail.gmail.com>
Subject: Re: [PATCH v6 4/6] KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
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
        Raghavendra Rao Ananta <rananta@google.com>
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

Hi Reiji,

On Tue, Apr 18, 2023 at 8:40=E2=80=AFPM Reiji Watanabe <reijiw@google.com> =
wrote:
>
> Hi Jing,
>
> On Tue, Apr 04, 2023 at 03:53:42AM +0000, Jing Zhang wrote:
> > With per guest ID registers, PMUver settings from userspace
> > can be stored in its corresponding ID register.
> >
> > No functional change intended.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 11 +++----
> >  arch/arm64/kvm/arm.c              |  6 ----
> >  arch/arm64/kvm/id_regs.c          | 50 ++++++++++++++++++++++++-------
> >  include/kvm/arm_pmu.h             |  5 ++--
> >  4 files changed, 49 insertions(+), 23 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> > index 67a55177fd83..da46a2729581 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -237,6 +237,12 @@ struct kvm_arch {
> >  #define KVM_ARCH_FLAG_EL1_32BIT                              4
> >       /* PSCI SYSTEM_SUSPEND enabled for the guest */
> >  #define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED         5
> > +     /*
> > +      * AA64DFR0_EL1.PMUver was set as ID_AA64DFR0_EL1_PMUVer_IMP_DEF
> > +      * or DFR0_EL1.PerfMon was set as ID_DFR0_EL1_PerfMon_IMPDEF from
> > +      * userspace for VCPUs without PMU.
> > +      */
> > +#define KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU           6
> >
> >       unsigned long flags;
> >
> > @@ -249,11 +255,6 @@ struct kvm_arch {
> >
> >       cpumask_var_t supported_cpus;
> >
> > -     struct {
> > -             u8 imp:4;
> > -             u8 unimp:4;
> > -     } dfr0_pmuver;
> > -
> >       /* Hypercall features firmware registers' descriptor */
> >       struct kvm_smccc_features smccc_feat;
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 64e1c19e5a9b..3fe28d545b54 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -138,12 +138,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned lon=
g type)
> >       kvm_arm_init_hypercalls(kvm);
> >       kvm_arm_init_id_regs(kvm);
> >
> > -     /*
> > -      * Initialise the default PMUver before there is a chance to
> > -      * create an actual PMU.
> > -      */
> > -     kvm->arch.dfr0_pmuver.imp =3D kvm_arm_pmu_get_pmuver_limit();
> > -
> >       return 0;
> >
> >  err_free_cpumask:
> > diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> > index 291311b1ecca..6f65d30693fe 100644
> > --- a/arch/arm64/kvm/id_regs.c
> > +++ b/arch/arm64/kvm/id_regs.c
> > @@ -21,9 +21,12 @@
> >  static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
> >  {
> >       if (kvm_vcpu_has_pmu(vcpu))
> > -             return vcpu->kvm->arch.dfr0_pmuver.imp;
> > +             return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVe=
r),
> > +                              IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1));
> > +     else if (test_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm-=
>arch.flags))
> > +             return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
> >
> > -     return vcpu->kvm->arch.dfr0_pmuver.unimp;
> > +     return 0;
> >  }
> >
> >  static u8 perfmon_to_pmuver(u8 perfmon)
> > @@ -254,10 +257,20 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *v=
cpu,
> >       if (val)
> >               return -EINVAL;
> >
> > -     if (valid_pmu)
> > -             vcpu->kvm->arch.dfr0_pmuver.imp =3D pmuver;
> > -     else
> > -             vcpu->kvm->arch.dfr0_pmuver.unimp =3D pmuver;
> > +     if (valid_pmu) {
> > +             mutex_lock(&vcpu->kvm->arch.config_lock);
> > +             IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &=3D ~ID_AA64DFR0_E=
L1_PMUVer_MASK;
> > +             IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=3D FIELD_PREP(ID_=
AA64DFR0_EL1_PMUVer_MASK,
> > +                                                                 pmuve=
r);
> > +
> > +             IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &=3D ~ID_DFR0_EL1_PerfM=
on_MASK;
> > +             IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=3D FIELD_PREP(ID_DFR0=
_EL1_PerfMon_MASK,
> > +                                                             pmuver_to=
_perfmon(pmuver));
>
> As those could be read without acquiring the lock, I don't think
> we should expose the intermediate state of the register values.
I will protect all reads/writes to KVM scope emulated ID registers
with the lock.
>
>
> > +             mutex_unlock(&vcpu->kvm->arch.config_lock);
> > +     } else {
> > +             assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm=
->arch.flags,
> > +                        pmuver =3D=3D ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
> > +     }
> >
> >       return 0;
> >  }
> > @@ -294,10 +307,19 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> >       if (val)
> >               return -EINVAL;
> >
> > -     if (valid_pmu)
> > -             vcpu->kvm->arch.dfr0_pmuver.imp =3D perfmon_to_pmuver(per=
fmon);
> > -     else
> > -             vcpu->kvm->arch.dfr0_pmuver.unimp =3D perfmon_to_pmuver(p=
erfmon);
> > +     if (valid_pmu) {
> > +             mutex_lock(&vcpu->kvm->arch.config_lock);
> > +             IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &=3D ~ID_DFR0_EL1_PerfM=
on_MASK;
> > +             IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=3D FIELD_PREP(ID_DFR0=
_EL1_PerfMon_MASK, perfmon);
> > +
> > +             IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &=3D ~ID_AA64DFR0_E=
L1_PMUVer_MASK;
> > +             IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=3D FIELD_PREP(ID_=
AA64DFR0_EL1_PMUVer_MASK,
> > +                                                                 perfm=
on_to_pmuver(perfmon));
>
> I have the same comment as set_id_aa64dfr0_el1().
>
> Thank you,
> Reiji
>
> > +             mutex_unlock(&vcpu->kvm->arch.config_lock);
> > +     } else {
> > +             assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm=
->arch.flags,
> > +                        perfmon =3D=3D ID_DFR0_EL1_PerfMon_IMPDEF);
> > +     }
> >
> >       return 0;
> >  }
> > @@ -503,4 +525,12 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
> >       }
> >
> >       IDREG(kvm, SYS_ID_AA64PFR0_EL1) =3D val;
> > +
> > +     /*
> > +      * Initialise the default PMUver before there is a chance to
> > +      * create an actual PMU.
> > +      */
> > +     IDREG(kvm, SYS_ID_AA64DFR0_EL1) &=3D ~ARM64_FEATURE_MASK(ID_AA64D=
FR0_EL1_PMUVer);
> > +     IDREG(kvm, SYS_ID_AA64DFR0_EL1) |=3D FIELD_PREP(ARM64_FEATURE_MAS=
K(ID_AA64DFR0_EL1_PMUVer),
> > +                                                   kvm_arm_pmu_get_pmu=
ver_limit());
> >  }
> > diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> > index 628775334d5e..856ac59b6821 100644
> > --- a/include/kvm/arm_pmu.h
> > +++ b/include/kvm/arm_pmu.h
> > @@ -92,8 +92,9 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu)=
;
> >  /*
> >   * Evaluates as true when emulating PMUv3p5, and false otherwise.
> >   */
> > -#define kvm_pmu_is_3p5(vcpu)                                         \
> > -     (vcpu->kvm->arch.dfr0_pmuver.imp >=3D ID_AA64DFR0_EL1_PMUVer_V3P5=
)
> > +#define kvm_pmu_is_3p5(vcpu)                                          =
                       \
> > +      (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),          =
                       \
> > +              IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1)) >=3D ID_AA64DFR0_=
EL1_PMUVer_V3P5)
> >
> >  u8 kvm_arm_pmu_get_pmuver_limit(void);
> >
> > --
> > 2.40.0.348.gf938b09366-goog
> >
Thanks,
Jing
