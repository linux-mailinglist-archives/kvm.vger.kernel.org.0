Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD9A6CD132
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 06:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjC2E3i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 00:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjC2E3h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 00:29:37 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A54392127
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 21:29:34 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id r17-20020a05683002f100b006a131458abfso5022909ote.2
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 21:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680064174;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hHiUbEmnrd1nFCCqx2M3YMHCicrSJZXlbSpyBMomdOk=;
        b=KsmaC16QBzSHNXRqBdFrH0RtYihBW139YYX86wQCYhhFfeFlBBBxF4y0nKIWI8l8w8
         kk5diBMfKiZGhERhWDRXvMPWdi1yo+e9wG9gXdtpQDRxa+W4uS8FMTcirR+IzlwXYgEW
         gR8EHLTmv5h/bvpWig9I0WteXF9O3ORLuvdp+CoM2OemEXSWvlsJJU/qhhJqrDbpPrqB
         16c4OQzIerYKLQmq7TlvmsXuCwIwXBbu9Zces4TTPVsrrYV3drSVnS4zs1cAphHID/Tx
         mZHmLXiBeq4WQMEROgoNJO3xJNaH4R1PAbn0dcd0s3MJcFn9eOb6dUlHkV/ymDFBEdaT
         fQYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680064174;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hHiUbEmnrd1nFCCqx2M3YMHCicrSJZXlbSpyBMomdOk=;
        b=2g/+lDvLFzEoaMU4ZF9JlJR+iDWAHOrK4JBmd7SOLJIaZ3S3xJR6VJobvO4zwXxNKo
         EXQzs6kyI1YKT0Sl485hv0nqA8XhPjPBT18QqxCcNuXa69gH1QRCxZGVe/nwqRIx4tcB
         6PrfZzIuoHEcjrpVBoP46fRLh8g1I7APpYRL/v9TbIjOxTa5rhXNdolu56Sn67a3aDmC
         dld3BHOFUkC7fdlL4ZCe2sihns7Q1KyRvoXZqnnEH9pf9IKiPOf0DgSZaWsk6cygi61j
         GzstgAxvlpqzi9KM/vI1MSq7zDUYl28Cqbd9B010o6hpp6jOapPLNDUISVdvBWCGnKje
         +VEQ==
X-Gm-Message-State: AO0yUKW0bQca6/MZE2PlIjZvRyE3Jw35FLijjTd0A7gSHaAxm/bEPBX4
        5n+dkyoG+/Eu4HbM3z0SLdxbnrsMSSqtYUWSW6byZA==
X-Google-Smtp-Source: AK7set/8RfUS9YEx/ISpCCVphMGNUlhdJPVR+2aDQkAPuiZyC4NhdQAqaYBLOS5gwPZl7zeg4mqoRSNc1RZNc/v6rdA=
X-Received: by 2002:a9d:634a:0:b0:699:9baa:e545 with SMTP id
 y10-20020a9d634a000000b006999baae545mr5587158otk.0.1680064173660; Tue, 28 Mar
 2023 21:29:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230317050637.766317-1-jingzhangos@google.com>
 <20230317050637.766317-7-jingzhangos@google.com> <86tty6wc67.wl-maz@kernel.org>
In-Reply-To: <86tty6wc67.wl-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Tue, 28 Mar 2023 21:29:21 -0700
Message-ID: <CAAdAUtg-b1HhCQAR+Xp-ZHZtXfnZ6iDHJhsCRti6QvMjWyW+ZA@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] KVM: arm64: Refactor writings for PMUVer/CSV2/CSV3
To:     Marc Zyngier <maz@kernel.org>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Mon, Mar 27, 2023 at 6:34=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Fri, 17 Mar 2023 05:06:37 +0000,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > Save KVM sanitised ID register value in ID descriptor (kvm_sys_val).
>
> Why do we need to store a separate value *beside* the sanitised value
> the kernel already holds?
>
> > Add an init callback for every ID register to setup kvm_sys_val.
>
> Same question.
It is used to store the value further sanitised by KVM, which might be
different from the one held by kernel. But as you suggested later,
this isn't necessary, we can create KVM sanitised value on the fly
since it is cheap.
>
> > All per VCPU sanitizations are still handled on the fly during ID
> > register read and write from userspace.
> > An arm64_ftr_bits array is used to indicate writable feature fields.
> >
> > Refactor writings for ID_AA64PFR0_EL1.[CSV2|CSV3],
> > ID_AA64DFR0_EL1.PMUVer and ID_DFR0_ELF.PerfMon based on utilities
> > introduced by ID register descriptor.
> >
> > No functional change intended.
> >
> > Co-developed-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/include/asm/cpufeature.h |  25 +++
> >  arch/arm64/include/asm/kvm_host.h   |   2 +-
> >  arch/arm64/kernel/cpufeature.c      |  26 +--
> >  arch/arm64/kvm/arm.c                |   2 +-
> >  arch/arm64/kvm/id_regs.c            | 325 ++++++++++++++++++++--------
> >  arch/arm64/kvm/sys_regs.c           |   3 +-
> >  arch/arm64/kvm/sys_regs.h           |   2 +-
> >  7 files changed, 261 insertions(+), 124 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/a=
sm/cpufeature.h
> > index fc2c739f48f1..493ec530eefc 100644
> > --- a/arch/arm64/include/asm/cpufeature.h
> > +++ b/arch/arm64/include/asm/cpufeature.h
> > @@ -64,6 +64,30 @@ struct arm64_ftr_bits {
> >       s64             safe_val; /* safe value for FTR_EXACT features */
> >  };
> >
> > +#define __ARM64_FTR_BITS(SIGNED, VISIBLE, STRICT, TYPE, SHIFT, WIDTH, =
SAFE_VAL) \
> > +     {                                               \
> > +             .sign =3D SIGNED,                         \
> > +             .visible =3D VISIBLE,                     \
> > +             .strict =3D STRICT,                       \
> > +             .type =3D TYPE,                           \
> > +             .shift =3D SHIFT,                         \
> > +             .width =3D WIDTH,                         \
> > +             .safe_val =3D SAFE_VAL,                   \
> > +     }
> > +
> > +/* Define a feature with unsigned values */
> > +#define ARM64_FTR_BITS(VISIBLE, STRICT, TYPE, SHIFT, WIDTH, SAFE_VAL) =
\
> > +     __ARM64_FTR_BITS(FTR_UNSIGNED, VISIBLE, STRICT, TYPE, SHIFT, WIDT=
H, SAFE_VAL)
> > +
> > +/* Define a feature with a signed value */
> > +#define S_ARM64_FTR_BITS(VISIBLE, STRICT, TYPE, SHIFT, WIDTH, SAFE_VAL=
) \
> > +     __ARM64_FTR_BITS(FTR_SIGNED, VISIBLE, STRICT, TYPE, SHIFT, WIDTH,=
 SAFE_VAL)
> > +
> > +#define ARM64_FTR_END                                        \
> > +     {                                               \
> > +             .width =3D 0,                             \
> > +     }
> > +
> >  /*
> >   * Describe the early feature override to the core override code:
> >   *
> > @@ -911,6 +935,7 @@ static inline unsigned int get_vmid_bits(u64 mmfr1)
> >       return 8;
> >  }
> >
> > +s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new, s=
64 cur);
> >  struct arm64_ftr_reg *get_arm64_ftr_reg(u32 sys_id);
> >
> >  extern struct arm64_ftr_override id_aa64mmfr1_override;
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> > index 102860ba896d..aa83dd79e7ff 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -1013,7 +1013,7 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *v=
cpu,
> >  long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
> >                               struct kvm_arm_copy_mte_tags *copy_tags);
> >
> > -void kvm_arm_set_default_id_regs(struct kvm *kvm);
> > +void kvm_arm_init_id_regs(struct kvm *kvm);
> >
> >  /* Guest/host FPSIMD coordination helpers */
> >  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
> > diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeat=
ure.c
> > index 23bd2a926b74..e18848ee4b98 100644
> > --- a/arch/arm64/kernel/cpufeature.c
> > +++ b/arch/arm64/kernel/cpufeature.c
> > @@ -139,30 +139,6 @@ void dump_cpu_features(void)
> >       pr_emerg("0x%*pb\n", ARM64_NCAPS, &cpu_hwcaps);
> >  }
> >
> > -#define __ARM64_FTR_BITS(SIGNED, VISIBLE, STRICT, TYPE, SHIFT, WIDTH, =
SAFE_VAL) \
> > -     {                                               \
> > -             .sign =3D SIGNED,                         \
> > -             .visible =3D VISIBLE,                     \
> > -             .strict =3D STRICT,                       \
> > -             .type =3D TYPE,                           \
> > -             .shift =3D SHIFT,                         \
> > -             .width =3D WIDTH,                         \
> > -             .safe_val =3D SAFE_VAL,                   \
> > -     }
> > -
> > -/* Define a feature with unsigned values */
> > -#define ARM64_FTR_BITS(VISIBLE, STRICT, TYPE, SHIFT, WIDTH, SAFE_VAL) =
\
> > -     __ARM64_FTR_BITS(FTR_UNSIGNED, VISIBLE, STRICT, TYPE, SHIFT, WIDT=
H, SAFE_VAL)
> > -
> > -/* Define a feature with a signed value */
> > -#define S_ARM64_FTR_BITS(VISIBLE, STRICT, TYPE, SHIFT, WIDTH, SAFE_VAL=
) \
> > -     __ARM64_FTR_BITS(FTR_SIGNED, VISIBLE, STRICT, TYPE, SHIFT, WIDTH,=
 SAFE_VAL)
> > -
> > -#define ARM64_FTR_END                                        \
> > -     {                                               \
> > -             .width =3D 0,                             \
> > -     }
> > -
> >  static void cpu_enable_cnp(struct arm64_cpu_capabilities const *cap);
> >
> >  static bool __system_matches_cap(unsigned int n);
> > @@ -790,7 +766,7 @@ static u64 arm64_ftr_set_value(const struct arm64_f=
tr_bits *ftrp, s64 reg,
> >       return reg;
> >  }
> >
> > -static s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64=
 new,
> > +s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new,
> >                               s64 cur)
> >  {
> >       s64 ret =3D 0;
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index fb2de2cb98cb..e539d9ca9d01 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -135,7 +135,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long=
 type)
> >       /* The maximum number of VCPUs is limited by the host's GIC model=
 */
> >       kvm->max_vcpus =3D kvm_arm_default_max_vcpus();
> >
> > -     kvm_arm_set_default_id_regs(kvm);
> > +     kvm_arm_init_id_regs(kvm);
>
> How about picking the name once and for all from the first patch?
Sure, will do.
>
> >       kvm_arm_init_hypercalls(kvm);
> >
> >       return 0;
> > diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> > index 9956c99d20f7..726b810b6e06 100644
> > --- a/arch/arm64/kvm/id_regs.c
> > +++ b/arch/arm64/kvm/id_regs.c
> > @@ -18,10 +18,88 @@
> >
> >  #include "sys_regs.h"
> >
> > +/*
> > + * Number of entries in id_reg_desc's ftr_bits[] (Number of 4 bits fie=
lds
> > + * in 64 bit register + 1 entry for a terminator entry).
> > + */
> > +#define      FTR_FIELDS_NUM  17
>
> Please see SMFR0_EL1 for an example of a sysreg that doesn't follow
> the 4bits-per-field format. I expect to see more of those in the
> future.
>
> And given that this is always a variable set of fields, why do we need
> to define this as a fixed array that only bloats the structure? I'd
> rather see a variable array in a side structure.
>
Yes, it makes more sense to use a variable array here. Do you have any
suggestions? xarray?
> > +
> >  struct id_reg_desc {
> >       const struct sys_reg_desc       reg_desc;
> > +     /*
> > +      * KVM sanitised ID register value.
> > +      * It is the default value for per VM emulated ID register.
> > +      */
> > +     u64 kvm_sys_val;
> > +     /*
> > +      * Used to validate the ID register values with arm64_check_featu=
res().
> > +      * The last item in the array must be terminated by an item whose
> > +      * width field is zero as that is expected by arm64_check_feature=
s().
> > +      * Only feature bits defined in this array are writable.
> > +      */
> > +     struct arm64_ftr_bits   ftr_bits[FTR_FIELDS_NUM];
> > +
> > +     /*
> > +      * Basically init() is used to setup the KVM sanitised value
> > +      * stored in kvm_sys_val.
> > +      */
> > +     void (*init)(struct id_reg_desc *idr);
>
> Given that this callback only builds the value from the sanitised
> view, and that it is very cheap (only a set of masking), why do we
> bother keeping the value around? It would also allow this structure to
> be kept *const*, something that is extremely desirable.
>
> Also, why do we need an init() method when each sysreg already have a
> reset() method? Surely this should be the same thing...
>
> My gut feeling is that we should only have a callback returning the
> limit value computed on the fly.
Sure, will use a callback to return the limit value on the fly.
>
> >  };
> >
> > +static struct id_reg_desc id_reg_descs[];
> > +
> > +/**
> > + * arm64_check_features() - Check if a feature register value constitu=
tes
> > + * a subset of features indicated by @limit.
> > + *
> > + * @ftrp: Pointer to an array of arm64_ftr_bits. It must be terminated=
 by
> > + * an item whose width field is zero.
> > + * @val: The feature register value to check
> > + * @limit: The limit value of the feature register
> > + *
> > + * This function will check if each feature field of @val is the "safe=
" value
> > + * against @limit based on @ftrp[], each of which specifies the target=
 field
> > + * (shift, width), whether or not the field is for a signed value (sig=
n),
> > + * how the field is determined to be "safe" (type), and the safe value
> > + * (safe_val) when type =3D=3D FTR_EXACT (safe_val won't be used by th=
is
> > + * function when type !=3D FTR_EXACT). Any other fields in arm64_ftr_b=
its
> > + * won't be used by this function. If a field value in @val is the sam=
e
> > + * as the one in @limit, it is always considered the safe value regard=
less
> > + * of the type. For register fields that are not in @ftrp[], only the =
value
> > + * in @limit is considered the safe value.
> > + *
> > + * Return: 0 if all the fields are safe. Otherwise, return negative er=
rno.
> > + */
> > +static int arm64_check_features(const struct arm64_ftr_bits *ftrp, u64=
 val, u64 limit)
> > +{
> > +     u64 mask =3D 0;
> > +
> > +     for (; ftrp->width; ftrp++) {
> > +             s64 f_val, f_lim, safe_val;
> > +
> > +             f_val =3D arm64_ftr_value(ftrp, val);
> > +             f_lim =3D arm64_ftr_value(ftrp, limit);
> > +             mask |=3D arm64_ftr_mask(ftrp);
> > +
> > +             if (f_val =3D=3D f_lim)
> > +                     safe_val =3D f_val;
> > +             else
> > +                     safe_val =3D  arm64_ftr_safe_value(ftrp, f_val, f=
_lim);
> > +
> > +             if (safe_val !=3D f_val)
> > +                     return -E2BIG;
> > +     }
> > +
> > +     /*
> > +      * For fields that are not indicated in ftrp, values in limit are=
 the
> > +      * safe values.
> > +      */
> > +     if ((val & ~mask) !=3D (limit & ~mask))
> > +             return -E2BIG;
> > +
> > +     return 0;
> > +}
>
> I have the feeling that the core code already implements something
> similar...
Right, it is similar to update_cpu_ftr_reg() in cpufeature.c. But that
function can't meet the needs here.
>
> > +
> >  static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
> >  {
> >       if (kvm_vcpu_has_pmu(vcpu))
> > @@ -67,7 +145,6 @@ u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu,=
 u32 id)
> >       case SYS_ID_AA64PFR0_EL1:
> >               if (!vcpu_has_sve(vcpu))
> >                       val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE)=
;
> > -             val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
> >               if (kvm_vgic_global_state.type =3D=3D VGIC_V3) {
> >                       val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC)=
;
> >                       val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR=
0_EL1_GIC), 1);
> > @@ -94,15 +171,10 @@ u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcp=
u, u32 id)
> >                       val &=3D ~ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_WFx=
T);
> >               break;
> >       case SYS_ID_AA64DFR0_EL1:
> > -             /* Limit debug to ARMv8.0 */
> > -             val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer);
> > -             val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_De=
bugVer), 6);
> >               /* Set PMUver to the required version */
> >               val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> >               val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PM=
UVer),
> >                                 vcpu_pmuver(vcpu));
> > -             /* Hide SPE from guests */
> > -             val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMSVer);
> >               break;
> >       case SYS_ID_DFR0_EL1:
> >               val &=3D ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
> > @@ -161,9 +233,15 @@ static int get_id_reg(struct kvm_vcpu *vcpu, const=
 struct sys_reg_desc *rd,
> >  static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc=
 *rd,
> >                     u64 val)
> >  {
> > -     /* This is what we mean by invariant: you can't change it. */
> > -     if (val !=3D read_id_reg(vcpu, rd))
> > -             return -EINVAL;
> > +     int ret;
> > +     int id =3D reg_to_encoding(rd);
> > +
> > +     ret =3D arm64_check_features(id_reg_descs[IDREG_IDX(id)].ftr_bits=
, val,
> > +                                id_reg_descs[IDREG_IDX(id)].kvm_sys_va=
l);
> > +     if (ret)
> > +             return ret;
> > +
> > +     vcpu->kvm->arch.id_regs[IDREG_IDX(id)] =3D val;
> >
> >       return 0;
> >  }
> > @@ -197,12 +275,47 @@ static unsigned int aa32_id_visibility(const stru=
ct kvm_vcpu *vcpu,
> >       return id_visibility(vcpu, r);
> >  }
> >
> > +static void init_id_reg(struct id_reg_desc *idr)
> > +{
> > +     idr->kvm_sys_val =3D read_sanitised_ftr_reg(reg_to_encoding(&idr-=
>reg_desc));
> > +}
> > +
> > +static void init_id_aa64pfr0_el1(struct id_reg_desc *idr)
> > +{
> > +     u64 val;
> > +     u32 id =3D reg_to_encoding(&idr->reg_desc);
> > +
> > +     val =3D read_sanitised_ftr_reg(id);
> > +     /*
> > +      * The default is to expose CSV2 =3D=3D 1 if the HW isn't affecte=
d.
> > +      * Although this is a per-CPU feature, we make it global because
> > +      * asymmetric systems are just a nuisance.
> > +      *
> > +      * Userspace can override this as long as it doesn't promise
> > +      * the impossible.
> > +      */
> > +     if (arm64_get_spectre_v2_state() =3D=3D SPECTRE_UNAFFECTED) {
> > +             val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
> > +             val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CS=
V2), 1);
> > +     }
> > +     if (arm64_get_meltdown_state() =3D=3D SPECTRE_UNAFFECTED) {
> > +             val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
> > +             val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CS=
V3), 1);
> > +     }
> > +
> > +     val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
> > +
> > +     val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC);
> > +     val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC), 1);
>
> What? Why? What if I have a GICv2? What if I have no GIC?
:-) Forgot how these two lines got in here. Will remove them.
>
> > +
> > +     idr->kvm_sys_val =3D val;
> > +}
>
> How does this compose with the runtime feature reduction that takes
> place in access_nested_id_reg()?
kvm_sys_val is used as the initial value for the per VM idregs, which
is passed into access_nested_id_reg in function access_id_reg().
>
> > +
> >  static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> >                              const struct sys_reg_desc *rd,
> >                              u64 val)
> >  {
> >       u8 csv2, csv3;
> > -     u64 sval =3D val;
> >
> >       /*
> >        * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
> > @@ -220,16 +333,29 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *v=
cpu,
> >           (csv3 && arm64_get_meltdown_state() !=3D SPECTRE_UNAFFECTED))
> >               return -EINVAL;
> >
> > -     /* We can only differ with CSV[23], and anything else is an error=
 */
> > -     val ^=3D read_id_reg(vcpu, rd);
> > -     val &=3D ~(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
> > -              ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
> > -     if (val)
> > -             return -EINVAL;
> > +     return set_id_reg(vcpu, rd, val);
> > +}
> >
> > -     vcpu->kvm->arch.id_regs[IDREG_IDX(reg_to_encoding(rd))] =3D sval;
> > +static void init_id_aa64dfr0_el1(struct id_reg_desc *idr)
> > +{
> > +     u64 val;
> > +     u32 id =3D reg_to_encoding(&idr->reg_desc);
> >
> > -     return 0;
> > +     val =3D read_sanitised_ftr_reg(id);
> > +     /* Limit debug to ARMv8.0 */
> > +     val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer);
> > +     val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer),=
 6);
> > +     /*
> > +      * Initialise the default PMUver before there is a chance to
> > +      * create an actual PMU.
> > +      */
> > +     val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > +     val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
> > +                       kvm_arm_pmu_get_pmuver_limit());
> > +     /* Hide SPE from guests */
> > +     val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMSVer);
> > +
> > +     idr->kvm_sys_val =3D val;
> >  }
> >
> >  static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> > @@ -238,6 +364,7 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcp=
u,
> >  {
> >       u8 pmuver, host_pmuver;
> >       bool valid_pmu;
> > +     int ret;
> >
> >       host_pmuver =3D kvm_arm_pmu_get_pmuver_limit();
> >
> > @@ -257,39 +384,58 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *v=
cpu,
> >       if (kvm_vcpu_has_pmu(vcpu) !=3D valid_pmu)
> >               return -EINVAL;
> >
> > -     /* We can only differ with PMUver, and anything else is an error =
*/
> > -     val ^=3D read_id_reg(vcpu, rd);
> > -     val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > -     if (val)
> > -             return -EINVAL;
> > -
> >       if (valid_pmu) {
> >               mutex_lock(&vcpu->kvm->lock);
> > -             vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] &=
=3D
> > -                     ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > -             vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] |=
=3D
> > -                     FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMU=
Ver), pmuver);
> > +             ret =3D set_id_reg(vcpu, rd, val);
> > +             if (ret)
> > +                     return ret;
>
> Next stop, Deadlock City, our final destination.
Will fix it.
>
> >
> >               vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_DFR0_EL1)] &=3D
> >                       ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
> >               vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_DFR0_EL1)] |=3D =
FIELD_PREP(
> >                               ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), =
pmuver_to_perfmon(pmuver));
> >               mutex_unlock(&vcpu->kvm->lock);
> > -     } else if (pmuver =3D=3D ID_AA64DFR0_EL1_PMUVer_IMP_DEF) {
> > -             set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->a=
rch.flags);
> >       } else {
> > -             clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm-=
>arch.flags);
> > +             /* We can only differ with PMUver, and anything else is a=
n error */
> > +             val ^=3D read_id_reg(vcpu, rd);
> > +             val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > +             if (val)
> > +                     return -EINVAL;
>
> I find it very odd that you add all this infrastructure to check for
> writable fields, and yet have to keep this comparison. It makes me
> thing that the data structures are not necessarily the right ones.
This comparison is still here because for this patch, we don't allow
the writable for the whole ID register and in the path of invalid pmu,
the set_id_reg() (This function will do all the checks) is not called.
This comparison can be removed as long as the whole ID reg is enabled
writable.
>
> > +
> > +             if (pmuver =3D=3D ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
> > +                     set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu=
->kvm->arch.flags);
> > +             else
> > +                     clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vc=
pu->kvm->arch.flags);
> > +
> >       }
> >
> >       return 0;
> >  }
> >
> > +static void init_id_dfr0_el1(struct id_reg_desc *idr)
> > +{
> > +     u64 val;
> > +     u32 id =3D reg_to_encoding(&idr->reg_desc);
> > +
> > +     val =3D read_sanitised_ftr_reg(id);
> > +     /*
> > +      * Initialise the default PMUver before there is a chance to
> > +      * create an actual PMU.
> > +      */
> > +     val &=3D ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
> > +     val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon),
> > +                       kvm_arm_pmu_get_pmuver_limit());
> > +
> > +     idr->kvm_sys_val =3D val;
> > +}
> > +
> >  static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> >                          const struct sys_reg_desc *rd,
> >                          u64 val)
> >  {
> >       u8 perfmon, host_perfmon;
> >       bool valid_pmu;
> > +     int ret;
> >
> >       host_perfmon =3D pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit()=
);
> >
> > @@ -310,42 +456,46 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> >       if (kvm_vcpu_has_pmu(vcpu) !=3D valid_pmu)
> >               return -EINVAL;
> >
> > -     /* We can only differ with PerfMon, and anything else is an error=
 */
> > -     val ^=3D read_id_reg(vcpu, rd);
> > -     val &=3D ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
> > -     if (val)
> > -             return -EINVAL;
> > -
> >       if (valid_pmu) {
> >               mutex_lock(&vcpu->kvm->lock);
> > -             vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_DFR0_EL1)] &=3D
> > -                     ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
> > -             vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_DFR0_EL1)] |=3D =
FIELD_PREP(
> > -                     ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), perfmon)=
;
> > +             ret =3D set_id_reg(vcpu, rd, val);
> > +             if (ret)
> > +                     return ret;
>
> Same player, shoot again.
Will fix it.
>
> >
> >               vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] &=
=3D
> >                       ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> >               vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] |=
=3D FIELD_PREP(
> >                       ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), perfm=
on_to_pmuver(perfmon));
> >               mutex_unlock(&vcpu->kvm->lock);
> > -     } else if (perfmon =3D=3D ID_DFR0_EL1_PerfMon_IMPDEF) {
> > -             set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->a=
rch.flags);
> >       } else {
> > -             clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm-=
>arch.flags);
> > +             /* We can only differ with PerfMon, and anything else is =
an error */
> > +             val ^=3D read_id_reg(vcpu, rd);
> > +             val &=3D ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
> > +             if (val)
> > +                     return -EINVAL;
> > +
> > +             if (perfmon =3D=3D ID_DFR0_EL1_PerfMon_IMPDEF)
> > +                     set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu=
->kvm->arch.flags);
> > +             else
> > +                     clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vc=
pu->kvm->arch.flags);
> >       }
>
> Same remarks.
>
> >
> >       return 0;
> >  }
> >
> >  /* sys_reg_desc initialiser for known cpufeature ID registers */
> > +#define SYS_DESC_SANITISED(name) {                   \
> > +     SYS_DESC(SYS_##name),                           \
> > +     .access =3D access_id_reg,                        \
> > +     .get_user =3D get_id_reg,                         \
> > +     .set_user =3D set_id_reg,                         \
> > +     .visibility =3D id_visibility,                    \
> > +}
> > +
> >  #define ID_SANITISED(name) {                         \
> > -     .reg_desc =3D {                                   \
> > -             SYS_DESC(SYS_##name),                   \
> > -             .access =3D access_id_reg,                \
> > -             .get_user =3D get_id_reg,                 \
> > -             .set_user =3D set_id_reg,                 \
> > -             .visibility =3D id_visibility,            \
> > -     },                                              \
> > +     .reg_desc =3D SYS_DESC_SANITISED(name),           \
> > +     .ftr_bits =3D { ARM64_FTR_END, },                 \
> > +     .init =3D init_id_reg,                            \
> >  }
> >
> >  /* sys_reg_desc initialiser for known cpufeature ID registers */
> > @@ -357,6 +507,8 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> >               .set_user =3D set_id_reg,                 \
> >               .visibility =3D aa32_id_visibility,       \
> >       },                                              \
> > +     .ftr_bits =3D { ARM64_FTR_END, },                 \
> > +     .init =3D init_id_reg,                            \
> >  }
> >
> >  /*
> > @@ -372,6 +524,7 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> >               .set_user =3D set_id_reg,                         \
> >               .visibility =3D raz_visibility                    \
> >       },                                                      \
> > +     .ftr_bits =3D { ARM64_FTR_END, },                         \
> >  }
> >
> >  /*
> > @@ -387,9 +540,10 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> >               .set_user =3D set_id_reg,                 \
> >               .visibility =3D raz_visibility,           \
> >       },                                              \
> > +     .ftr_bits =3D { ARM64_FTR_END, },                 \
> >  }
> >
> > -static const struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] =3D {
> > +static struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] =3D {
> >       /*
> >        * ID regs: all ID_SANITISED() entries here must have correspondi=
ng
> >        * entries in arm64_ftr_regs[].
> > @@ -405,6 +559,11 @@ static const struct id_reg_desc id_reg_descs[KVM_A=
RM_ID_REG_NUM] =3D {
> >               .get_user =3D get_id_reg,
> >               .set_user =3D set_id_dfr0_el1,
> >               .visibility =3D aa32_id_visibility, },
> > +       .ftr_bits =3D {
> > +             ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
> > +                     ID_DFR0_EL1_PerfMon_SHIFT, ID_DFR0_EL1_PerfMon_WI=
DTH, 0),
> > +             ARM64_FTR_END, },
> > +       .init =3D init_id_dfr0_el1,
> >       },
> >       ID_HIDDEN(ID_AFR0_EL1),
> >       AA32_ID_SANITISED(ID_MMFR0_EL1),
> > @@ -439,6 +598,13 @@ static const struct id_reg_desc id_reg_descs[KVM_A=
RM_ID_REG_NUM] =3D {
> >               .access =3D access_id_reg,
> >               .get_user =3D get_id_reg,
> >               .set_user =3D set_id_aa64pfr0_el1, },
> > +       .ftr_bits =3D {
> > +             ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
> > +                     ID_AA64PFR0_EL1_CSV2_SHIFT, ID_AA64PFR0_EL1_CSV2_=
WIDTH, 0),
> > +             ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
> > +                     ID_AA64PFR0_EL1_CSV3_SHIFT, ID_AA64PFR0_EL1_CSV3_=
WIDTH, 0),
> > +             ARM64_FTR_END, },
>
> It really strikes me that you are 100% duplicating data that is
> already in ftr_id_aa64pfr0[]. Only that this is a subset of the
> existing data.
>
> You could instead have your 'init()' callback return a pair of values:
> the default value based on the sanitised one, and a 64bit mask. At
> this stage, you'll realise that this looks a lot like the feature
> override, and that you should be able to reuse some of the existing
> infrastructure.
Sure, will try to improve this by your suggestion.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
Thanks,
Jing
