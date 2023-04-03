Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14E356D5192
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 21:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbjDCTux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 15:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbjDCTuv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 15:50:51 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803902D7D
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 12:50:48 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id r16so22563608oij.5
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 12:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680551448;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hXVHtWIErg5TsetJYYipgXWq4XISRm1gN5QXpBHd1Fg=;
        b=NrrkuzA/5P7FwHJGmhhGU4wncHxY002rldbRA3VtNLDp/8dYnTO2v9YSBqbVyEuasU
         Fu32ZcC/hon71M0embDuK6D1kOrukHfG3oHUYQQX8uUP8wXPqZhZPEzE6WtCaOSno3pU
         +MrouOmZPrMBMkJX9KmN1hcYKM1zuO5xepP1nAzCvW4GERr2ZInaR/uYsGY16nG7HXC1
         G/cX/Q7OocC6G2j4GYjWyOaDxVC+eFJSWXwfH5Bt6x86/IV8yjkU7XKH/Otce0gFddEs
         PAUi0FZhLWl+emdC8SsPWCLEs66JGXrK42il4UWLNmMrHcPzanbZ5HJblMZmOjekl11H
         9M4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680551448;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hXVHtWIErg5TsetJYYipgXWq4XISRm1gN5QXpBHd1Fg=;
        b=fbh+/x/t+UvPTkfJOhjy+OBuz6FfSXonTLA27gsq1bQpm5B97q2jkeulkmw3+kKb/S
         8LwAIG+Jtp1DmYM9O6MYq4aCI0mviQ4V4WhVRP7q2+ZrftYlzz3rcEjtFMRoAf0aquQ9
         5qSqEs1uIKGtF8itEfHkfLxSYs5izjpRycFjqjTJ+DFhhMZF8ZAcmQlrEQs1j0zM49oV
         jBaIBAqYsWylE7jYfYlNjZk0qIag30fQ5s2sBCwEDe1O3RlKfB+n4RUDfKTFTxlfpqzX
         YzZNWJTCwXl5O5U8C7iWXB/y9AZYZWcq/05nbJkDqWal4CQo/NDHQh3dFbhSJL0hAojh
         yULA==
X-Gm-Message-State: AAQBX9fmDdHBXv48fdyHJZLGHGvhxlUdl7CGQxg0YD9ld0SfwmjfWh8O
        KEeOHknLq6zBpEpG4iM2tGNJwO8+V9f4e4eG1Wqbkw==
X-Google-Smtp-Source: AKy350anxDZFBDZApPF6x/JYKAGXl5/dIkkqkJjRnNOwj4FD7ddmUPFlH6LUly1m7so6RDKIh/aiQxun2lksD7kA/mI=
X-Received: by 2002:a54:4019:0:b0:386:a2d0:2814 with SMTP id
 x25-20020a544019000000b00386a2d02814mr9033050oie.4.1680551447386; Mon, 03 Apr
 2023 12:50:47 -0700 (PDT)
MIME-Version: 1.0
References: <20230402183735.3011540-1-jingzhangos@google.com>
 <20230402183735.3011540-7-jingzhangos@google.com> <86v8iduib5.wl-maz@kernel.org>
In-Reply-To: <86v8iduib5.wl-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Mon, 3 Apr 2023 12:50:36 -0700
Message-ID: <CAAdAUtgErT-NYci7d0BxVzemf-X0a=1pQbNCTcbOXbbLGtSnkQ@mail.gmail.com>
Subject: Re: [PATCH v5 6/6] KVM: arm64: Refactor writings for PMUVer/CSV2/CSV3
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

On Mon, Apr 3, 2023 at 7:55=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> On Sun, 02 Apr 2023 19:37:35 +0100,
> Jing Zhang <jingzhangos@google.com> wrote:
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
> >  arch/arm64/include/asm/cpufeature.h |   5 +
> >  arch/arm64/kernel/cpufeature.c      |   8 +-
> >  arch/arm64/kvm/id_regs.c            | 262 +++++++++++++++++++---------
> >  arch/arm64/kvm/sys_regs.c           |   3 +-
> >  arch/arm64/kvm/sys_regs.h           |   2 +-
> >  5 files changed, 191 insertions(+), 89 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/a=
sm/cpufeature.h
> > index 6bf013fb110d..f17e74afe3e9 100644
> > --- a/arch/arm64/include/asm/cpufeature.h
> > +++ b/arch/arm64/include/asm/cpufeature.h
> > @@ -915,6 +915,7 @@ static inline unsigned int get_vmid_bits(u64 mmfr1)
> >       return 8;
> >  }
> >
> > +s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new, s=
64 cur);
> >  struct arm64_ftr_reg *get_arm64_ftr_reg(u32 sys_id);
> >
> >  extern struct arm64_ftr_override id_aa64mmfr1_override;
> > @@ -925,6 +926,10 @@ extern struct arm64_ftr_override id_aa64smfr0_over=
ride;
> >  extern struct arm64_ftr_override id_aa64isar1_override;
> >  extern struct arm64_ftr_override id_aa64isar2_override;
> >
> > +extern const struct arm64_ftr_bits ftr_id_dfr0[];
> > +extern const struct arm64_ftr_bits ftr_id_aa64pfr0[];
> > +extern const struct arm64_ftr_bits ftr_id_aa64dfr0[];
> > +
> >  u32 get_kvm_ipa_limit(void);
> >  void dump_cpu_features(void);
> >
> > diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeat=
ure.c
> > index c331c49a7d19..5b0e3379e5f8 100644
> > --- a/arch/arm64/kernel/cpufeature.c
> > +++ b/arch/arm64/kernel/cpufeature.c
> > @@ -225,7 +225,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar2=
[] =3D {
> >       ARM64_FTR_END,
> >  };
> >
> > -static const struct arm64_ftr_bits ftr_id_aa64pfr0[] =3D {
> > +const struct arm64_ftr_bits ftr_id_aa64pfr0[] =3D {
> >       ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64=
PFR0_EL1_CSV3_SHIFT, 4, 0),
> >       ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64=
PFR0_EL1_CSV2_SHIFT, 4, 0),
> >       ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PF=
R0_EL1_DIT_SHIFT, 4, 0),
> > @@ -426,7 +426,7 @@ static const struct arm64_ftr_bits ftr_id_mmfr0[] =
=3D {
> >       ARM64_FTR_END,
> >  };
> >
> > -static const struct arm64_ftr_bits ftr_id_aa64dfr0[] =3D {
> > +const struct arm64_ftr_bits ftr_id_aa64dfr0[] =3D {
> >       S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64D=
FR0_EL1_DoubleLock_SHIFT, 4, 0),
> >       ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64=
DFR0_EL1_PMSVer_SHIFT, 4, 0),
> >       ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR=
0_EL1_CTX_CMPs_SHIFT, 4, 0),
> > @@ -578,7 +578,7 @@ static const struct arm64_ftr_bits ftr_id_pfr2[] =
=3D {
> >       ARM64_FTR_END,
> >  };
> >
> > -static const struct arm64_ftr_bits ftr_id_dfr0[] =3D {
> > +const struct arm64_ftr_bits ftr_id_dfr0[] =3D {
> >       /* [31:28] TraceFilt */
> >       S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_EXACT, ID_DFR0_EL=
1_PerfMon_SHIFT, 4, 0),
> >       ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_DFR0_EL=
1_MProfDbg_SHIFT, 4, 0),
>
> There really isn't a good reason for exposing any of this. You can
> readily get to the overarching arm64_ftr_reg.
Yes, will do.
>
> > @@ -791,7 +791,7 @@ static u64 arm64_ftr_set_value(const struct arm64_f=
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
> > diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> > index af86001e2686..395eaf84a0ab 100644
> > --- a/arch/arm64/kvm/id_regs.c
> > +++ b/arch/arm64/kvm/id_regs.c
> > @@ -39,6 +39,64 @@ struct id_reg_desc {
> >       u64 (*read_kvm_sanitised_reg)(const struct id_reg_desc *idr);
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
> > + * @writable_mask: Indicates writable feature bits.
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
> > + * of the type. For register fields that are not in writable, only the=
 value
> > + * in @limit is considered the safe value.
> > + *
> > + * Return: 0 if all the fields are safe. Otherwise, return negative er=
rno.
> > + */
> > +static int arm64_check_features(const struct arm64_ftr_bits *ftrp,
> > +                             u64 writable_mask, u64 val, u64 limit)
> > +{
> > +     u64 mask =3D 0;
> > +
> > +     for (; ftrp && ftrp->width; ftrp++) {
> > +             s64 f_val, f_lim, safe_val;
> > +             u64 ftr_mask;
> > +
> > +             ftr_mask =3D arm64_ftr_mask(ftrp);
> > +             if ((ftr_mask & writable_mask) !=3D ftr_mask)
> > +                     continue;
> > +
> > +             f_val =3D arm64_ftr_value(ftrp, val);
> > +             f_lim =3D arm64_ftr_value(ftrp, limit);
> > +             mask |=3D ftr_mask;
> > +
> > +             if (f_val =3D=3D f_lim)
> > +                     safe_val =3D f_val;
> > +             else
> > +                     safe_val =3D arm64_ftr_safe_value(ftrp, f_val, f_=
lim);
> > +
> > +             if (safe_val !=3D f_val)
> > +                     return -E2BIG;
> > +     }
> > +
> > +     /* For fields that are not writable, values in limit are the safe=
 values. */
> > +     if ((val & ~mask) !=3D (limit & ~mask))
> > +             return -E2BIG;
> > +
> > +     return 0;
> > +}
> > +
> >  static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
> >  {
> >       if (kvm_vcpu_has_pmu(vcpu))
> > @@ -84,7 +142,6 @@ u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu,=
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
> > @@ -111,15 +168,10 @@ u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vc=
pu, u32 id)
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
> > @@ -178,9 +230,16 @@ static int get_id_reg(struct kvm_vcpu *vcpu, const=
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
> > +     const struct id_reg_desc *idr =3D &id_reg_descs[IDREG_IDX(id)];
> > +
> > +     ret =3D arm64_check_features(idr->ftr_bits, idr->writable_mask, v=
al,
> > +                     idr->read_kvm_sanitised_reg ? idr->read_kvm_sanit=
ised_reg(idr) : 0);
> > +     if (ret)
> > +             return ret;
> > +
> > +     IDREG(vcpu->kvm, id) =3D val;
> >
> >       return 0;
> >  }
> > @@ -219,12 +278,39 @@ static u64 general_read_kvm_sanitised_reg(const s=
truct id_reg_desc *idr)
> >       return read_sanitised_ftr_reg(reg_to_encoding(&idr->reg_desc));
> >  }
> >
> > +static u64 read_sanitised_id_aa64pfr0_el1(const struct id_reg_desc *id=
r)
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
> > +     return val;
> > +}
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
> > @@ -232,26 +318,37 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *v=
cpu,
> >        * guest could otherwise be covered in ectoplasmic residue).
> >        */
> >       csv2 =3D cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_EL=
1_CSV2_SHIFT);
> > -     if (csv2 > 1 ||
> > -         (csv2 && arm64_get_spectre_v2_state() !=3D SPECTRE_UNAFFECTED=
))
> > +     if (csv2 > 1 || (csv2 && arm64_get_spectre_v2_state() !=3D SPECTR=
E_UNAFFECTED))
> >               return -EINVAL;
> >
> >       /* Same thing for CSV3 */
> >       csv3 =3D cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_EL=
1_CSV3_SHIFT);
> > -     if (csv3 > 1 ||
> > -         (csv3 && arm64_get_meltdown_state() !=3D SPECTRE_UNAFFECTED))
> > +     if (csv3 > 1 || (csv3 && arm64_get_meltdown_state() !=3D SPECTRE_=
UNAFFECTED))
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
> > -     IDREG(vcpu->kvm, reg_to_encoding(rd)) =3D sval;
> > +static u64 read_sanitised_id_aa64dfr0_el1(const struct id_reg_desc *id=
r)
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
> > +     return val;
> >  }
> >
> >  static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> > @@ -260,6 +357,7 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcp=
u,
> >  {
> >       u8 pmuver, host_pmuver;
> >       bool valid_pmu;
> > +     int ret;
> >
> >       host_pmuver =3D kvm_arm_pmu_get_pmuver_limit();
> >
> > @@ -279,23 +377,25 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *v=
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
> >               mutex_lock(&vcpu->kvm->arch.config_lock);
> > -             IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &=3D ~ARM64_FEATURE=
_MASK(ID_AA64DFR0_EL1_PMUVer);
> > -             IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=3D
> > -                     FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMU=
Ver), pmuver);
> > +             ret =3D set_id_reg(vcpu, rd, val);
> > +             if (ret) {
> > +                     mutex_unlock(&vcpu->kvm->arch.config_lock);
> > +                     return ret;
> > +             }
> >
> >               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &=3D ~ARM64_FEATURE_MAS=
K(ID_DFR0_EL1_PerfMon);
> >               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=3D
> >                       FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon=
), pmuver_to_perfmon(pmuver));
>
> I repeatedly asked for assignments to be *on a single line*.
Will fix it.
>
> >               mutex_unlock(&vcpu->kvm->arch.config_lock);
> >       } else {
> > +             /* We can only differ with PMUver, and anything else is a=
n error */
> > +             val ^=3D read_id_reg(vcpu, rd);
> > +             val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > +             if (val)
> > +                     return -EINVAL;
> > +
>
> I asked about this before. Why do we need this? Isn't the whole point
> of the exercise to have a *unified* way to check for the writable
> bits?  If you still need to open-code that, the whole exercise is a
> bit pointless, isn't it?
Right. Will find a better way.
>
> Frankly, the whole thing is going the wrong way, starting with the
> wrapping data structure. We already have most of what we need in
> sys_reg_desc, and it only takes a bit of imagination to get there.
>
> I've spent a couple of hours hacking away at the series, and got rid
> of it entirely, simply by repurposing exist fields (val for the write
> mask, reset for the limit value). All I can say is that it compiles.
>
> But at least it doesn't reinvent the wheel.
>
>         M.
>
> diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> index 395eaf84a0ab..30f36e0dd12e 100644
> --- a/arch/arm64/kvm/id_regs.c
> +++ b/arch/arm64/kvm/id_regs.c
> @@ -18,29 +18,6 @@
>
>  #include "sys_regs.h"
>
> -struct id_reg_desc {
> -       const struct sys_reg_desc       reg_desc;
> -       /*
> -        * ftr_bits points to the feature bits array defined in cpufeatur=
e.c for
> -        * writable CPU ID feature register.
> -        */
> -       const struct arm64_ftr_bits *ftr_bits;
> -       /*
> -        * Only bits with 1 are writable from userspace.
> -        * This mask might not be necessary in the future whenever all ID
> -        * registers are enabled as writable from userspace.
> -        */
> -       const u64 writable_mask;
> -       /*
> -        * This function returns the KVM sanitised register value.
> -        * The value would be the same as the host kernel sanitised value=
 if
> -        * there is no KVM sanitisation for this id register.
> -        */
> -       u64 (*read_kvm_sanitised_reg)(const struct id_reg_desc *idr);
> -};
> -
> -static struct id_reg_desc id_reg_descs[];
> -
>  /**
>   * arm64_check_features() - Check if a feature register value constitute=
s
>   * a subset of features indicated by @limit.
> @@ -64,11 +41,26 @@ static struct id_reg_desc id_reg_descs[];
>   *
>   * Return: 0 if all the fields are safe. Otherwise, return negative errn=
o.
>   */
> -static int arm64_check_features(const struct arm64_ftr_bits *ftrp,
> -                               u64 writable_mask, u64 val, u64 limit)
> +static int arm64_check_features(struct kvm_vcpu *vcpu,
> +                               const struct sys_reg_desc *rd,
> +                               u64 val)
>  {
> +       const struct arm64_ftr_reg *ftr_reg;
> +       const struct arm64_ftr_bits *ftrp;
> +       u32 id =3D reg_to_encoding(rd);
> +       u64 writable_mask =3D rd->val;
> +       u64 limit =3D 0;
>         u64 mask =3D 0;
>
> +       if (rd->reset)
> +               limit =3D rd->reset(vcpu, rd);
> +
> +       ftr_reg =3D get_arm64_ftr_reg(id);
> +       if (!ftr_reg)
> +               return -EINVAL;
> +
> +       ftrp =3D ftr_reg->ftr_bits;
> +
>         for (; ftrp && ftrp->width; ftrp++) {
>                 s64 f_val, f_lim, safe_val;
>                 u64 ftr_mask;
> @@ -230,12 +222,10 @@ static int get_id_reg(struct kvm_vcpu *vcpu, const =
struct sys_reg_desc *rd,
>  static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *=
rd,
>                       u64 val)
>  {
> +       u32 id =3D reg_to_encoding(rd);
>         int ret;
> -       int id =3D reg_to_encoding(rd);
> -       const struct id_reg_desc *idr =3D &id_reg_descs[IDREG_IDX(id)];
>
> -       ret =3D arm64_check_features(idr->ftr_bits, idr->writable_mask, v=
al,
> -                       idr->read_kvm_sanitised_reg ? idr->read_kvm_sanit=
ised_reg(idr) : 0);
> +       ret =3D arm64_check_features(vcpu, rd, val);
>         if (ret)
>                 return ret;
>
> @@ -273,15 +263,17 @@ static unsigned int aa32_id_visibility(const struct=
 kvm_vcpu *vcpu,
>         return id_visibility(vcpu, r);
>  }
>
> -static u64 general_read_kvm_sanitised_reg(const struct id_reg_desc *idr)
> +static u64 general_read_kvm_sanitised_reg(struct kvm_vcpu *vcpu,
> +                                         const struct sys_reg_desc *r)
>  {
> -       return read_sanitised_ftr_reg(reg_to_encoding(&idr->reg_desc));
> +       return read_sanitised_ftr_reg(reg_to_encoding(r));
>  }
>
> -static u64 read_sanitised_id_aa64pfr0_el1(const struct id_reg_desc *idr)
> +static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> +                                         const struct sys_reg_desc *r)
>  {
>         u64 val;
> -       u32 id =3D reg_to_encoding(&idr->reg_desc);
> +       u32 id =3D reg_to_encoding(r);
>
>         val =3D read_sanitised_ftr_reg(id);
>         /*
> @@ -329,10 +321,11 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcp=
u,
>         return set_id_reg(vcpu, rd, val);
>  }
>
> -static u64 read_sanitised_id_aa64dfr0_el1(const struct id_reg_desc *idr)
> +static u64 read_sanitised_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> +                                         const struct sys_reg_desc *r)
>  {
>         u64 val;
> -       u32 id =3D reg_to_encoding(&idr->reg_desc);
> +       u32 id =3D reg_to_encoding(r);
>
>         val =3D read_sanitised_ftr_reg(id);
>         /* Limit debug to ARMv8.0 */
> @@ -403,10 +396,11 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcp=
u,
>         return 0;
>  }
>
> -static u64 read_sanitised_id_dfr0_el1(const struct id_reg_desc *idr)
> +static u64 read_sanitised_id_dfr0_el1(struct kvm_vcpu *vcpu,
> +                                     const struct sys_reg_desc *r)
>  {
>         u64 val;
> -       u32 id =3D reg_to_encoding(&idr->reg_desc);
> +       u32 id =3D reg_to_encoding(r);
>
>         val =3D read_sanitised_ftr_reg(id);
>         /*
> @@ -473,33 +467,23 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
>  }
>
>  /* sys_reg_desc initialiser for known cpufeature ID registers */
> -#define SYS_DESC_SANITISED(name) {                     \
> +#define ID_SANITISED(name) {                           \
>         SYS_DESC(SYS_##name),                           \
>         .access =3D access_id_reg,                        \
>         .get_user =3D get_id_reg,                         \
>         .set_user =3D set_id_reg,                         \
>         .visibility =3D id_visibility,                    \
> -}
> -
> -#define ID_SANITISED(name) {                                           \
> -       .reg_desc =3D SYS_DESC_SANITISED(name),                          =
 \
> -       .ftr_bits =3D NULL,                                              =
 \
> -       .writable_mask =3D 0,                                            =
 \
> -       .read_kvm_sanitised_reg =3D general_read_kvm_sanitised_reg,      =
 \
> +       .reset =3D general_read_kvm_sanitised_reg,        \
>  }
>
>  /* sys_reg_desc initialiser for known cpufeature ID registers */
> -#define AA32_ID_SANITISED(name) {                                      \
> -       .reg_desc =3D {                                                  =
 \
> -               SYS_DESC(SYS_##name),                                   \
> -               .access =3D access_id_reg,                               =
 \
> -               .get_user =3D get_id_reg,                                =
 \
> -               .set_user =3D set_id_reg,                                =
 \
> -               .visibility =3D aa32_id_visibility,                      =
 \
> -       },                                                              \
> -       .ftr_bits =3D NULL,                                              =
 \
> -       .writable_mask =3D 0,                                            =
 \
> -       .read_kvm_sanitised_reg =3D general_read_kvm_sanitised_reg,      =
 \
> +#define AA32_ID_SANITISED(name) {                              \
> +       SYS_DESC(SYS_##name),                                   \
> +       .access =3D access_id_reg,                                \
> +       .get_user =3D get_id_reg,                                 \
> +       .set_user =3D set_id_reg,                                 \
> +       .visibility =3D aa32_id_visibility,                       \
> +       .reset =3D general_read_kvm_sanitised_reg,                \
>  }
>
>  /*
> @@ -508,16 +492,11 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
>   * (1 <=3D crm < 8, 0 <=3D Op2 < 8).
>   */
>  #define ID_UNALLOCATED(crm, op2) {                             \
> -       .reg_desc =3D {                                           \
>                 Op0(3), Op1(0), CRn(0), CRm(crm), Op2(op2),     \
>                 .access =3D access_id_reg,                        \
>                 .get_user =3D get_id_reg,                         \
>                 .set_user =3D set_id_reg,                         \
>                 .visibility =3D raz_visibility                    \
> -       },                                                      \
> -       .ftr_bits =3D NULL,                                       \
> -       .writable_mask =3D 0,                                     \
> -       .read_kvm_sanitised_reg =3D NULL,                         \
>  }
>
>  /*
> @@ -526,19 +505,14 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
>   * RAZ for the guest.
>   */
>  #define ID_HIDDEN(name) {                              \
> -       .reg_desc =3D {                                   \
>                 SYS_DESC(SYS_##name),                   \
>                 .access =3D access_id_reg,                \
>                 .get_user =3D get_id_reg,                 \
>                 .set_user =3D set_id_reg,                 \
>                 .visibility =3D raz_visibility,           \
> -       },                                              \
> -       .ftr_bits =3D NULL,                               \
> -       .writable_mask =3D 0,                             \
> -       .read_kvm_sanitised_reg =3D NULL,                 \
>  }
>
> -static struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] =3D {
> +static struct sys_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] =3D {
>         /*
>          * ID regs: all ID_SANITISED() entries here must have correspondi=
ng
>          * entries in arm64_ftr_regs[].
> @@ -548,15 +522,14 @@ static struct id_reg_desc id_reg_descs[KVM_ARM_ID_R=
EG_NUM] =3D {
>         /* CRm=3D1 */
>         AA32_ID_SANITISED(ID_PFR0_EL1),
>         AA32_ID_SANITISED(ID_PFR1_EL1),
> -       { .reg_desc =3D {
> +       {
>                 SYS_DESC(SYS_ID_DFR0_EL1),
>                 .access =3D access_id_reg,
>                 .get_user =3D get_id_reg,
>                 .set_user =3D set_id_dfr0_el1,
> -               .visibility =3D aa32_id_visibility, },
> -         .ftr_bits =3D ftr_id_dfr0,
> -         .writable_mask =3D ID_DFR0_EL1_PerfMon_MASK,
> -         .read_kvm_sanitised_reg =3D read_sanitised_id_dfr0_el1,
> +               .visibility =3D aa32_id_visibility,
> +               .val =3D ID_DFR0_EL1_PerfMon_MASK,
> +               .reset =3D read_sanitised_id_dfr0_el1,
>         },
>         ID_HIDDEN(ID_AFR0_EL1),
>         AA32_ID_SANITISED(ID_MMFR0_EL1),
> @@ -586,14 +559,13 @@ static struct id_reg_desc id_reg_descs[KVM_ARM_ID_R=
EG_NUM] =3D {
>
>         /* AArch64 ID registers */
>         /* CRm=3D4 */
> -       { .reg_desc =3D {
> +       {
>                 SYS_DESC(SYS_ID_AA64PFR0_EL1),
>                 .access =3D access_id_reg,
>                 .get_user =3D get_id_reg,
> -               .set_user =3D set_id_aa64pfr0_el1, },
> -         .ftr_bits =3D ftr_id_aa64pfr0,
> -         .writable_mask =3D ID_AA64PFR0_EL1_CSV2_MASK | ID_AA64PFR0_EL1_=
CSV3_MASK,
> -         .read_kvm_sanitised_reg =3D read_sanitised_id_aa64pfr0_el1,
> +               .set_user =3D set_id_aa64pfr0_el1,
> +               .val =3D ID_AA64PFR0_EL1_CSV2_MASK | ID_AA64PFR0_EL1_CSV3=
_MASK,
> +               .reset =3D read_sanitised_id_aa64pfr0_el1,
>         },
>         ID_SANITISED(ID_AA64PFR1_EL1),
>         ID_UNALLOCATED(4, 2),
> @@ -604,14 +576,13 @@ static struct id_reg_desc id_reg_descs[KVM_ARM_ID_R=
EG_NUM] =3D {
>         ID_UNALLOCATED(4, 7),
>
>         /* CRm=3D5 */
> -       { .reg_desc =3D {
> +       {
>                 SYS_DESC(SYS_ID_AA64DFR0_EL1),
>                 .access =3D access_id_reg,
>                 .get_user =3D get_id_reg,
> -               .set_user =3D set_id_aa64dfr0_el1, },
> -         .ftr_bits =3D ftr_id_aa64dfr0,
> -         .writable_mask =3D ID_AA64DFR0_EL1_PMUVer_MASK,
> -         .read_kvm_sanitised_reg =3D read_sanitised_id_aa64dfr0_el1,
> +               .set_user =3D set_id_aa64dfr0_el1,
> +               .val =3D ID_AA64DFR0_EL1_PMUVer_MASK,
> +               .reset =3D read_sanitised_id_aa64dfr0_el1,
>         },
>         ID_SANITISED(ID_AA64DFR1_EL1),
>         ID_UNALLOCATED(5, 2),
> @@ -648,7 +619,7 @@ static const struct sys_reg_desc *id_params_to_desc(s=
truct sys_reg_params *param
>
>         id =3D reg_to_encoding(params);
>         if (is_id_reg(id))
> -               return &id_reg_descs[IDREG_IDX(id)].reg_desc;
> +               return &id_reg_descs[IDREG_IDX(id)];
>
>         return NULL;
>  }
> @@ -742,11 +713,11 @@ bool kvm_arm_idreg_table_init(void)
>         unsigned int i;
>
>         for (i =3D 0; i < ARRAY_SIZE(id_reg_descs); i++) {
> -               const struct sys_reg_desc *r =3D &id_reg_descs[i].reg_des=
c;
> +               const struct sys_reg_desc *r =3D &id_reg_descs[i];
>
>                 if (!is_id_reg(reg_to_encoding(r))) {
>                         kvm_err("id_reg table %pS entry %d not set correc=
tly\n",
> -                               &id_reg_descs[i].reg_desc, i);
> +                               id_reg_descs, i);
>                         return false;
>                 }
>         }
> @@ -756,7 +727,7 @@ bool kvm_arm_idreg_table_init(void)
>
>  int kvm_arm_walk_id_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
>  {
> -       const struct id_reg_desc *i2, *end2;
> +       const struct sys_reg_desc *i2, *end2;
>         unsigned int total =3D 0;
>         int err;
>
> @@ -764,7 +735,7 @@ int kvm_arm_walk_id_regs(struct kvm_vcpu *vcpu, u64 _=
_user *uind)
>         end2 =3D id_reg_descs + ARRAY_SIZE(id_reg_descs);
>
>         for (; i2 !=3D end2; i2++) {
> -               err =3D walk_one_sys_reg(vcpu, &(i2->reg_desc), &uind, &t=
otal);
> +               err =3D walk_one_sys_reg(vcpu, i2, &uind, &total);
>                 if (err)
>                         return err;
>         }
> @@ -779,11 +750,11 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
>         u64 val;
>
>         for (i =3D 0; i < ARRAY_SIZE(id_reg_descs); i++) {
> -               id =3D reg_to_encoding(&id_reg_descs[i].reg_desc);
> +               id =3D reg_to_encoding(&id_reg_descs[i]);
>
>                 val =3D 0;
> -               if (id_reg_descs[i].read_kvm_sanitised_reg)
> -                       val =3D id_reg_descs[i].read_kvm_sanitised_reg(&i=
d_reg_descs[i]);
> +               if (id_reg_descs[i].reset)
> +                       val =3D id_reg_descs[i].reset(NULL, &id_reg_descs=
[i]);
>
>                 IDREG(kvm, id) =3D val;
>         }
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index b90d1d3ad081..c4f498e75315 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -540,10 +540,11 @@ static int get_bvr(struct kvm_vcpu *vcpu, const str=
uct sys_reg_desc *rd,
>         return 0;
>  }
>
> -static void reset_bvr(struct kvm_vcpu *vcpu,
> +static u64 reset_bvr(struct kvm_vcpu *vcpu,
>                       const struct sys_reg_desc *rd)
>  {
>         vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm] =3D rd->val;
> +       return rd->val;
>  }
>
>  static bool trap_bcr(struct kvm_vcpu *vcpu,
> @@ -576,10 +577,11 @@ static int get_bcr(struct kvm_vcpu *vcpu, const str=
uct sys_reg_desc *rd,
>         return 0;
>  }
>
> -static void reset_bcr(struct kvm_vcpu *vcpu,
> +static u64 reset_bcr(struct kvm_vcpu *vcpu,
>                       const struct sys_reg_desc *rd)
>  {
>         vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm] =3D rd->val;
> +       return rd->val;
>  }
>
>  static bool trap_wvr(struct kvm_vcpu *vcpu,
> @@ -613,10 +615,11 @@ static int get_wvr(struct kvm_vcpu *vcpu, const str=
uct sys_reg_desc *rd,
>         return 0;
>  }
>
> -static void reset_wvr(struct kvm_vcpu *vcpu,
> +static u64 reset_wvr(struct kvm_vcpu *vcpu,
>                       const struct sys_reg_desc *rd)
>  {
>         vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm] =3D rd->val;
> +       return rd->val;
>  }
>
>  static bool trap_wcr(struct kvm_vcpu *vcpu,
> @@ -649,25 +652,28 @@ static int get_wcr(struct kvm_vcpu *vcpu, const str=
uct sys_reg_desc *rd,
>         return 0;
>  }
>
> -static void reset_wcr(struct kvm_vcpu *vcpu,
> +static u64 reset_wcr(struct kvm_vcpu *vcpu,
>                       const struct sys_reg_desc *rd)
>  {
>         vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm] =3D rd->val;
> +       return rd->val;
>  }
>
> -static void reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_reg_=
desc *r)
> +static u64 reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_reg_d=
esc *r)
>  {
>         u64 amair =3D read_sysreg(amair_el1);
>         vcpu_write_sys_reg(vcpu, amair, AMAIR_EL1);
> +       return amair;
>  }
>
> -static void reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc=
 *r)
> +static u64 reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc =
*r)
>  {
>         u64 actlr =3D read_sysreg(actlr_el1);
>         vcpu_write_sys_reg(vcpu, actlr, ACTLR_EL1);
> +       return actlr;
>  }
>
> -static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc=
 *r)
> +static u64 reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc =
*r)
>  {
>         u64 mpidr;
>
> @@ -681,7 +687,9 @@ static void reset_mpidr(struct kvm_vcpu *vcpu, const =
struct sys_reg_desc *r)
>         mpidr =3D (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
>         mpidr |=3D ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
>         mpidr |=3D ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2)=
;
> -       vcpu_write_sys_reg(vcpu, (1ULL << 31) | mpidr, MPIDR_EL1);
> +       mpidr |=3D (1ULL << 31);
> +       vcpu_write_sys_reg(vcpu, mpidr, MPIDR_EL1);
> +       return mpidr;
>  }
>
>  static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
> @@ -693,13 +701,13 @@ static unsigned int pmu_visibility(const struct kvm=
_vcpu *vcpu,
>         return REG_HIDDEN;
>  }
>
> -static void reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_de=
sc *r)
> +static u64 reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_des=
c *r)
>  {
>         u64 n, mask =3D BIT(ARMV8_PMU_CYCLE_IDX);
>
>         /* No PMU available, any PMU reg may UNDEF... */
>         if (!kvm_arm_support_pmu_v3())
> -               return;
> +               return 0;
>
>         n =3D read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
>         n &=3D ARMV8_PMU_PMCR_N_MASK;
> @@ -708,33 +716,37 @@ static void reset_pmu_reg(struct kvm_vcpu *vcpu, co=
nst struct sys_reg_desc *r)
>
>         reset_unknown(vcpu, r);
>         __vcpu_sys_reg(vcpu, r->reg) &=3D mask;
> +       return __vcpu_sys_reg(vcpu, r->reg);
>  }
>
> -static void reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_reg_d=
esc *r)
> +static u64 reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_reg_de=
sc *r)
>  {
>         reset_unknown(vcpu, r);
>         __vcpu_sys_reg(vcpu, r->reg) &=3D GENMASK(31, 0);
> +       return __vcpu_sys_reg(vcpu, r->reg);
>  }
>
> -static void reset_pmevtyper(struct kvm_vcpu *vcpu, const struct sys_reg_=
desc *r)
> +static u64 reset_pmevtyper(struct kvm_vcpu *vcpu, const struct sys_reg_d=
esc *r)
>  {
>         reset_unknown(vcpu, r);
>         __vcpu_sys_reg(vcpu, r->reg) &=3D ARMV8_PMU_EVTYPE_MASK;
> +       return __vcpu_sys_reg(vcpu, r->reg);
>  }
>
> -static void reset_pmselr(struct kvm_vcpu *vcpu, const struct sys_reg_des=
c *r)
> +static u64 reset_pmselr(struct kvm_vcpu *vcpu, const struct sys_reg_desc=
 *r)
>  {
>         reset_unknown(vcpu, r);
>         __vcpu_sys_reg(vcpu, r->reg) &=3D ARMV8_PMU_COUNTER_MASK;
> +       return __vcpu_sys_reg(vcpu, r->reg);
>  }
>
> -static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc =
*r)
> +static u64 reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *=
r)
>  {
>         u64 pmcr;
>
>         /* No PMU available, PMCR_EL0 may UNDEF... */
>         if (!kvm_arm_support_pmu_v3())
> -               return;
> +               return 0;
>
>         /* Only preserve PMCR_EL0.N, and reset the rest to 0 */
>         pmcr =3D read_sysreg(pmcr_el0) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_=
PMU_PMCR_N_SHIFT);
> @@ -742,6 +754,7 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const s=
truct sys_reg_desc *r)
>                 pmcr |=3D ARMV8_PMU_PMCR_LC;
>
>         __vcpu_sys_reg(vcpu, r->reg) =3D pmcr;
> +       return __vcpu_sys_reg(vcpu, r->reg);
>  }
>
>  static bool check_pmu_access_disabled(struct kvm_vcpu *vcpu, u64 flags)
> @@ -1205,7 +1218,7 @@ static bool access_clidr(struct kvm_vcpu *vcpu, str=
uct sys_reg_params *p,
>   * Fabricate a CLIDR_EL1 value instead of using the real value, which ca=
n vary
>   * by the physical CPU which the vcpu currently resides in.
>   */
> -static void reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc=
 *r)
> +static u64 reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc =
*r)
>  {
>         u64 ctr_el0 =3D read_sanitised_ftr_reg(SYS_CTR_EL0);
>         u64 clidr;
> @@ -1253,6 +1266,7 @@ static void reset_clidr(struct kvm_vcpu *vcpu, cons=
t struct sys_reg_desc *r)
>                 clidr |=3D 2 << CLIDR_TTYPE_SHIFT(loc);
>
>         __vcpu_sys_reg(vcpu, r->reg) =3D clidr;
> +       return __vcpu_sys_reg(vcpu, r->reg);
>  }
>
>  static int set_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r=
d,
> @@ -2603,19 +2617,21 @@ id_to_sys_reg_desc(struct kvm_vcpu *vcpu, u64 id,
>   */
>
>  #define FUNCTION_INVARIANT(reg)                                         =
       \
> -       static void get_##reg(struct kvm_vcpu *v,                       \
> +       static u64 get_##reg(struct kvm_vcpu *v,                        \
>                               const struct sys_reg_desc *r)             \
>         {                                                               \
>                 ((struct sys_reg_desc *)r)->val =3D read_sysreg(reg);    =
 \
> +               return ((struct sys_reg_desc *)r)->val;                 \
>         }
>
>  FUNCTION_INVARIANT(midr_el1)
>  FUNCTION_INVARIANT(revidr_el1)
>  FUNCTION_INVARIANT(aidr_el1)
>
> -static void get_ctr_el0(struct kvm_vcpu *v, const struct sys_reg_desc *r=
)
> +static u64 get_ctr_el0(struct kvm_vcpu *v, const struct sys_reg_desc *r)
>  {
>         ((struct sys_reg_desc *)r)->val =3D read_sanitised_ftr_reg(SYS_CT=
R_EL0);
> +       return ((struct sys_reg_desc *)r)->val;
>  }
>
>  /* ->val is filled in by kvm_sys_reg_table_init() */
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index df8d26df93ec..d14d5b41a222 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -65,12 +65,12 @@ struct sys_reg_desc {
>                        const struct sys_reg_desc *);
>
>         /* Initialization for vcpu. */
> -       void (*reset)(struct kvm_vcpu *, const struct sys_reg_desc *);
> +       u64 (*reset)(struct kvm_vcpu *, const struct sys_reg_desc *);
>
>         /* Index into sys_reg[], or 0 if we don't need to save it. */
>         int reg;
>
> -       /* Value (usually reset value) */
> +       /* Value (usually reset value), or write mask for idregs */
>         u64 val;
>
>         /* Custom get/set_user functions, fallback to generic if NULL */
> @@ -123,19 +123,21 @@ static inline bool read_zero(struct kvm_vcpu *vcpu,
>  }
>
>  /* Reset functions */
> -static inline void reset_unknown(struct kvm_vcpu *vcpu,
> +static inline u64 reset_unknown(struct kvm_vcpu *vcpu,
>                                  const struct sys_reg_desc *r)
>  {
>         BUG_ON(!r->reg);
>         BUG_ON(r->reg >=3D NR_SYS_REGS);
>         __vcpu_sys_reg(vcpu, r->reg) =3D 0x1de7ec7edbadc0deULL;
> +       return __vcpu_sys_reg(vcpu, r->reg);
>  }
>
> -static inline void reset_val(struct kvm_vcpu *vcpu, const struct sys_reg=
_desc *r)
> +static inline u64 reset_val(struct kvm_vcpu *vcpu, const struct sys_reg_=
desc *r)
>  {
>         BUG_ON(!r->reg);
>         BUG_ON(r->reg >=3D NR_SYS_REGS);
>         __vcpu_sys_reg(vcpu, r->reg) =3D r->val;
> +       return __vcpu_sys_reg(vcpu, r->reg);
>  }
>
>  static inline unsigned int sysreg_visibility(const struct kvm_vcpu *vcpu=
,
Really appreciate it. It looks great! Will reimplement based on your sugges=
tion.
>
> --
> Without deviation from the norm, progress is not possible.

Thanks,
Jing
