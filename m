Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB7F720838
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 19:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235825AbjFBRPu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 13:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235529AbjFBRPs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 13:15:48 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08771A2
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 10:15:46 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-1a1b95cc10eso2456493fac.0
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 10:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685726146; x=1688318146;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w+efdKjZMqTriW/c39VG7BsQ50ph9hjKVpeEjowQDww=;
        b=UzHUl1cMzoc5+E/XONIL3rxge4eSLwsyd70FxKcoUcRIOaFIqqmL9YP6tlR9L8gruk
         RwC9Mg8ULyDbieAwArPIcS2TqXtDOU/gwbeQriDjw+GpNFFX4nF5hJpbybXVbl6mH4HU
         3zP2ZBebUauLL2r1e1Jyy1GR3YNpckVk9tdeqM9Vm0//pqdLtCsMU76x/rsOEUOajJBX
         o17RWlnFoVgAprRcZ1gutXrn3Y9PgeyTRTiCiaiV2fBwh4jSXRLHc24X2JvFQdn7JmAk
         jx+uaaVZmOOMO39kWbP8PqWjUcQaeUTGO0QGksYDULUpo6fYxLr1ZLY2mU38V0Rm3yC4
         m6tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685726146; x=1688318146;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w+efdKjZMqTriW/c39VG7BsQ50ph9hjKVpeEjowQDww=;
        b=RmxnLQSmLowapFBT7pXo6tIBqkFuMP4wq15yrVb4HKU+Vn/244U3TF4VROslmMLwks
         imxp7og8TRgmHypkLBjpHIgP2Ao8UrpsDm4Re7sNcxQjM4AjfEXNuIf/kF+3LYCIaNDs
         PLvp/HUlReMa/deJNEC8pUlD0bP3/EuZlvclULDXbrEInxS1zhNy+FpRISgEMjro8Nnu
         8FNEfKpWBKebksPRt/kATdxOr1OS3nDWr/yC0yElZHQzXAygzjWwwvOnsVK75CKI1P+j
         ordJivNkQ7hYowc/TcpRtqFf/6K/tUkpLRb066GfwR5A809guvKugFe2MX5dK8LaYste
         PoOg==
X-Gm-Message-State: AC+VfDyJc3LC1TNMfY5ed01uYOfye01ctnYCl1Xg/rlinzA9VkXmm3IS
        ZNAccOHTcig0rIlsum6ftxjoERVIAmCIpmellXtW9JpAjg47+LoOYPw=
X-Google-Smtp-Source: ACHHUZ6e7Ovj/gxAh4j0MR/m0ADkAVnmpRT099PmZ6Mlqmzs0WFhcNaptk1VkoPvidUlDYUzcuOIWp3Z2fe8UIL5/Ac=
X-Received: by 2002:a05:6870:e145:b0:1a2:ae9a:749c with SMTP id
 z5-20020a056870e14500b001a2ae9a749cmr1091309oaa.42.1685726145787; Fri, 02 Jun
 2023 10:15:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230602005118.2899664-1-jingzhangos@google.com> <20230602005118.2899664-6-jingzhangos@google.com>
In-Reply-To: <20230602005118.2899664-6-jingzhangos@google.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Fri, 2 Jun 2023 10:15:32 -0700
Message-ID: <CAAdAUtiw91APuLbr=OWB0w0eD5n=_4_X=K3xtO4kXZZhOcdDQA@mail.gmail.com>
Subject: Re: [PATCH v11 5/5] KVM: arm64: Refactor writings for PMUVer/CSV2/CSV3
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oupton@google.com>, sjitindarsingh@gmail.com
Cc:     Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-14.3 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Suraj,

Let's continue the problem here you raised in the v9.
For the SVE example, the problem would be gone by enabling the
writable for SVE field? Since we are going to enable the writable for
all ID regs one by one later.
The double checking for CSV[2|3] is gone in this series.

Thanks,
Jing

On Thu, Jun 1, 2023 at 5:51=E2=80=AFPM Jing Zhang <jingzhangos@google.com> =
wrote:
>
> Refactor writings for ID_AA64PFR0_EL1.[CSV2|CSV3],
> ID_AA64DFR0_EL1.PMUVer and ID_DFR0_ELF.PerfMon based on utilities
> specific to ID register.
>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arch/arm64/include/asm/cpufeature.h |   1 +
>  arch/arm64/kernel/cpufeature.c      |   2 +-
>  arch/arm64/kvm/sys_regs.c           | 291 +++++++++++++++++++---------
>  3 files changed, 203 insertions(+), 91 deletions(-)
>
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm=
/cpufeature.h
> index 6bf013fb110d..dc769c2eb7a4 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -915,6 +915,7 @@ static inline unsigned int get_vmid_bits(u64 mmfr1)
>         return 8;
>  }
>
> +s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new, s64=
 cur);
>  struct arm64_ftr_reg *get_arm64_ftr_reg(u32 sys_id);
>
>  extern struct arm64_ftr_override id_aa64mmfr1_override;
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeatur=
e.c
> index 7d7128c65161..3317a7b6deac 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -798,7 +798,7 @@ static u64 arm64_ftr_set_value(const struct arm64_ftr=
_bits *ftrp, s64 reg,
>         return reg;
>  }
>
> -static s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 n=
ew,
> +s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new,
>                                 s64 cur)
>  {
>         s64 ret =3D 0;
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 1a534e0fc4ca..50d4e25f42d3 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -41,6 +41,7 @@
>   * 64bit interface.
>   */
>
> +static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *=
rd, u64 val);
>  static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 encoding=
);
>  static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
>
> @@ -1194,6 +1195,86 @@ static bool access_arch_timer(struct kvm_vcpu *vcp=
u,
>         return true;
>  }
>
> +static s64 kvm_arm64_ftr_safe_value(u32 id, const struct arm64_ftr_bits =
*ftrp,
> +                                   s64 new, s64 cur)
> +{
> +       struct arm64_ftr_bits kvm_ftr =3D *ftrp;
> +
> +       /* Some features have different safe value type in KVM than host =
features */
> +       switch (id) {
> +       case SYS_ID_AA64DFR0_EL1:
> +               if (kvm_ftr.shift =3D=3D ID_AA64DFR0_EL1_PMUVer_SHIFT)
> +                       kvm_ftr.type =3D FTR_LOWER_SAFE;
> +               break;
> +       case SYS_ID_DFR0_EL1:
> +               if (kvm_ftr.shift =3D=3D ID_DFR0_EL1_PerfMon_SHIFT)
> +                       kvm_ftr.type =3D FTR_LOWER_SAFE;
> +               break;
> +       }
> +
> +       return arm64_ftr_safe_value(&kvm_ftr, new, cur);
> +}
> +
> +/**
> + * arm64_check_features() - Check if a feature register value constitute=
s
> + * a subset of features indicated by the idreg's KVM sanitised limit.
> + *
> + * This function will check if each feature field of @val is the "safe" =
value
> + * against idreg's KVM sanitised limit return from reset() callback.
> + * If a field value in @val is the same as the one in limit, it is alway=
s
> + * considered the safe value regardless For register fields that are not=
 in
> + * writable, only the value in limit is considered the safe value.
> + *
> + * Return: 0 if all the fields are safe. Otherwise, return negative errn=
o.
> + */
> +static int arm64_check_features(struct kvm_vcpu *vcpu,
> +                               const struct sys_reg_desc *rd,
> +                               u64 val)
> +{
> +       const struct arm64_ftr_reg *ftr_reg;
> +       const struct arm64_ftr_bits *ftrp =3D NULL;
> +       u32 id =3D reg_to_encoding(rd);
> +       u64 writable_mask =3D rd->val;
> +       u64 limit =3D 0;
> +       u64 mask =3D 0;
> +
> +       /* For hidden and unallocated idregs without reset, only val =3D =
0 is allowed. */
> +       if (rd->reset) {
> +               limit =3D rd->reset(vcpu, rd);
> +               ftr_reg =3D get_arm64_ftr_reg(id);
> +               if (!ftr_reg)
> +                       return -EINVAL;
> +               ftrp =3D ftr_reg->ftr_bits;
> +       }
> +
> +       for (; ftrp && ftrp->width; ftrp++) {
> +               s64 f_val, f_lim, safe_val;
> +               u64 ftr_mask;
> +
> +               ftr_mask =3D arm64_ftr_mask(ftrp);
> +               if ((ftr_mask & writable_mask) !=3D ftr_mask)
> +                       continue;
> +
> +               f_val =3D arm64_ftr_value(ftrp, val);
> +               f_lim =3D arm64_ftr_value(ftrp, limit);
> +               mask |=3D ftr_mask;
> +
> +               if (f_val =3D=3D f_lim)
> +                       safe_val =3D f_val;
> +               else
> +                       safe_val =3D kvm_arm64_ftr_safe_value(id, ftrp, f=
_val, f_lim);
> +
> +               if (safe_val !=3D f_val)
> +                       return -E2BIG;
> +       }
> +
> +       /* For fields that are not writable, values in limit are the safe=
 values. */
> +       if ((val & ~mask) !=3D (limit & ~mask))
> +               return -E2BIG;
> +
> +       return 0;
> +}
> +
>  static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
>  {
>         if (kvm_vcpu_has_pmu(vcpu))
> @@ -1231,9 +1312,17 @@ static u8 pmuver_to_perfmon(u8 pmuver)
>         }
>  }
>
> -static void pmuver_update(struct kvm_vcpu *vcpu, u8 pmuver, bool valid_p=
mu)
> +static int pmuver_update(struct kvm_vcpu *vcpu,
> +                         const struct sys_reg_desc *rd,
> +                         u64 val,
> +                         u8 pmuver,
> +                         bool valid_pmu)
>  {
> -       u64 val;
> +       int ret;
> +
> +       ret =3D set_id_reg(vcpu, rd, val);
> +       if (ret)
> +               return ret;
>
>         if (valid_pmu) {
>                 val =3D IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);
> @@ -1249,6 +1338,8 @@ static void pmuver_update(struct kvm_vcpu *vcpu, u8=
 pmuver, bool valid_pmu)
>                 assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm=
->arch.flags,
>                            pmuver =3D=3D ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
>         }
> +
> +       return 0;
>  }
>
>  static u64 general_read_kvm_sanitised_reg(struct kvm_vcpu *vcpu, const s=
truct sys_reg_desc *rd)
> @@ -1264,7 +1355,6 @@ static u64 kvm_arm_read_id_reg(const struct kvm_vcp=
u *vcpu, u32 encoding)
>         case SYS_ID_AA64PFR0_EL1:
>                 if (!vcpu_has_sve(vcpu))
>                         val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE)=
;
> -               val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
>                 if (kvm_vgic_global_state.type =3D=3D VGIC_V3) {
>                         val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC)=
;
>                         val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR=
0_EL1_GIC), 1);
> @@ -1291,15 +1381,10 @@ static u64 kvm_arm_read_id_reg(const struct kvm_v=
cpu *vcpu, u32 encoding)
>                         val &=3D ~ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_WFx=
T);
>                 break;
>         case SYS_ID_AA64DFR0_EL1:
> -               /* Limit debug to ARMv8.0 */
> -               val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer);
> -               val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_De=
bugVer), 6);
>                 /* Set PMUver to the required version */
>                 val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
>                 val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PM=
UVer),
>                                   vcpu_pmuver(vcpu));
> -               /* Hide SPE from guests */
> -               val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMSVer);
>                 break;
>         case SYS_ID_DFR0_EL1:
>                 val &=3D ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
> @@ -1398,38 +1483,56 @@ static unsigned int sve_visibility(const struct k=
vm_vcpu *vcpu,
>         return REG_HIDDEN;
>  }
>
> -static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> -                              const struct sys_reg_desc *rd,
> -                              u64 val)
> +static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> +                                         const struct sys_reg_desc *rd)
>  {
> -       u64 new_val =3D val;
> -       u8 csv2, csv3;
> +       u64 val;
> +       u32 id =3D reg_to_encoding(rd);
>
> +       val =3D read_sanitised_ftr_reg(id);
>         /*
> -        * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
> -        * it doesn't promise more than what is actually provided (the
> -        * guest could otherwise be covered in ectoplasmic residue).
> +        * The default is to expose CSV2 =3D=3D 1 if the HW isn't affecte=
d.
> +        * Although this is a per-CPU feature, we make it global because
> +        * asymmetric systems are just a nuisance.
> +        *
> +        * Userspace can override this as long as it doesn't promise
> +        * the impossible.
>          */
> -       csv2 =3D cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_EL=
1_CSV2_SHIFT);
> -       if (csv2 > 1 ||
> -           (csv2 && arm64_get_spectre_v2_state() !=3D SPECTRE_UNAFFECTED=
))
> -               return -EINVAL;
> +       if (arm64_get_spectre_v2_state() =3D=3D SPECTRE_UNAFFECTED) {
> +               val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
> +               val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CS=
V2), 1);
> +       }
> +       if (arm64_get_meltdown_state() =3D=3D SPECTRE_UNAFFECTED) {
> +               val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
> +               val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CS=
V3), 1);
> +       }
>
> -       /* Same thing for CSV3 */
> -       csv3 =3D cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_EL=
1_CSV3_SHIFT);
> -       if (csv3 > 1 ||
> -           (csv3 && arm64_get_meltdown_state() !=3D SPECTRE_UNAFFECTED))
> -               return -EINVAL;
> +       val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
>
> -       /* We can only differ with CSV[23], and anything else is an error=
 */
> -       val ^=3D read_id_reg(vcpu, rd);
> -       val &=3D ~(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
> -                ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
> -       if (val)
> -               return -EINVAL;
> +       return val;
> +}
>
> -       IDREG(vcpu->kvm, reg_to_encoding(rd)) =3D new_val;
> -       return 0;
> +static u64 read_sanitised_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> +                                         const struct sys_reg_desc *rd)
> +{
> +       u64 val;
> +       u32 id =3D reg_to_encoding(rd);
> +
> +       val =3D read_sanitised_ftr_reg(id);
> +       /* Limit debug to ARMv8.0 */
> +       val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer);
> +       val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer),=
 6);
> +       /*
> +        * Initialise the default PMUver before there is a chance to
> +        * create an actual PMU.
> +        */
> +       val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> +       val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
> +                         kvm_arm_pmu_get_pmuver_limit());
> +       /* Hide SPE from guests */
> +       val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMSVer);
> +
> +       return val;
>  }
>
>  static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> @@ -1457,14 +1560,35 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *v=
cpu,
>         if (kvm_vcpu_has_pmu(vcpu) !=3D valid_pmu)
>                 return -EINVAL;
>
> -       /* We can only differ with PMUver, and anything else is an error =
*/
> -       val ^=3D read_id_reg(vcpu, rd);
> -       val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> -       if (val)
> -               return -EINVAL;
> +       if (!valid_pmu) {
> +               /*
> +                * Ignore the PMUVer field in @val. The PMUVer would be d=
etermined
> +                * by arch flags bit KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU,
> +                */
> +               pmuver =3D FIELD_GET(ID_AA64DFR0_EL1_PMUVer_MASK,
> +                                  IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1))=
;
> +               val &=3D ~ID_AA64DFR0_EL1_PMUVer_MASK;
> +               val |=3D FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK, pmuver);
> +       }
>
> -       pmuver_update(vcpu, pmuver, valid_pmu);
> -       return 0;
> +       return pmuver_update(vcpu, rd, val, pmuver, valid_pmu);
> +}
> +
> +static u64 read_sanitised_id_dfr0_el1(struct kvm_vcpu *vcpu,
> +                                     const struct sys_reg_desc *rd)
> +{
> +       u64 val;
> +       u32 id =3D reg_to_encoding(rd);
> +
> +       val =3D read_sanitised_ftr_reg(id);
> +       /*
> +        * Initialise the default PMUver before there is a chance to
> +        * create an actual PMU.
> +        */
> +       val &=3D ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
> +       val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), kvm_=
arm_pmu_get_pmuver_limit());
> +
> +       return val;
>  }
>
>  static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> @@ -1493,14 +1617,18 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
>         if (kvm_vcpu_has_pmu(vcpu) !=3D valid_pmu)
>                 return -EINVAL;
>
> -       /* We can only differ with PerfMon, and anything else is an error=
 */
> -       val ^=3D read_id_reg(vcpu, rd);
> -       val &=3D ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
> -       if (val)
> -               return -EINVAL;
> +       if (!valid_pmu) {
> +               /*
> +                * Ignore the PerfMon field in @val. The PerfMon would be=
 determined
> +                * by arch flags bit KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU,
> +                */
> +               perfmon =3D FIELD_GET(ID_DFR0_EL1_PerfMon_MASK,
> +                                   IDREG(vcpu->kvm, SYS_ID_DFR0_EL1));
> +               val &=3D ~ID_DFR0_EL1_PerfMon_MASK;
> +               val |=3D FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK, perfmon);
> +       }
>
> -       pmuver_update(vcpu, perfmon_to_pmuver(perfmon), valid_pmu);
> -       return 0;
> +       return pmuver_update(vcpu, rd, val, perfmon_to_pmuver(perfmon), v=
alid_pmu);
>  }
>
>  /*
> @@ -1520,11 +1648,14 @@ static int get_id_reg(struct kvm_vcpu *vcpu, cons=
t struct sys_reg_desc *rd,
>  static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *=
rd,
>                       u64 val)
>  {
> -       /* This is what we mean by invariant: you can't change it. */
> -       if (val !=3D read_id_reg(vcpu, rd))
> -               return -EINVAL;
> +       u32 id =3D reg_to_encoding(rd);
> +       int ret =3D 0;
>
> -       return 0;
> +       ret =3D arm64_check_features(vcpu, rd, val);
> +       if (!ret)
> +               IDREG(vcpu->kvm, id) =3D val;
> +
> +       return ret;
>  }
>
>  static int get_raz_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc =
*rd,
> @@ -1875,9 +2006,13 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
>         /* CRm=3D1 */
>         AA32_ID_SANITISED(ID_PFR0_EL1),
>         AA32_ID_SANITISED(ID_PFR1_EL1),
> -       { SYS_DESC(SYS_ID_DFR0_EL1), .access =3D access_id_reg,
> -         .get_user =3D get_id_reg, .set_user =3D set_id_dfr0_el1,
> -         .visibility =3D aa32_id_visibility, },
> +       { SYS_DESC(SYS_ID_DFR0_EL1),
> +         .access =3D access_id_reg,
> +         .get_user =3D get_id_reg,
> +         .set_user =3D set_id_dfr0_el1,
> +         .visibility =3D aa32_id_visibility,
> +         .reset =3D read_sanitised_id_dfr0_el1,
> +         .val =3D ID_DFR0_EL1_PerfMon_MASK, },
>         ID_HIDDEN(ID_AFR0_EL1),
>         AA32_ID_SANITISED(ID_MMFR0_EL1),
>         AA32_ID_SANITISED(ID_MMFR1_EL1),
> @@ -1906,8 +2041,12 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
>
>         /* AArch64 ID registers */
>         /* CRm=3D4 */
> -       { SYS_DESC(SYS_ID_AA64PFR0_EL1), .access =3D access_id_reg,
> -         .get_user =3D get_id_reg, .set_user =3D set_id_aa64pfr0_el1, },
> +       { SYS_DESC(SYS_ID_AA64PFR0_EL1),
> +         .access =3D access_id_reg,
> +         .get_user =3D get_id_reg,
> +         .set_user =3D set_id_reg,
> +         .reset =3D read_sanitised_id_aa64pfr0_el1,
> +         .val =3D ID_AA64PFR0_EL1_CSV2_MASK | ID_AA64PFR0_EL1_CSV3_MASK,=
 },
>         ID_SANITISED(ID_AA64PFR1_EL1),
>         ID_UNALLOCATED(4,2),
>         ID_UNALLOCATED(4,3),
> @@ -1917,8 +2056,12 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
>         ID_UNALLOCATED(4,7),
>
>         /* CRm=3D5 */
> -       { SYS_DESC(SYS_ID_AA64DFR0_EL1), .access =3D access_id_reg,
> -         .get_user =3D get_id_reg, .set_user =3D set_id_aa64dfr0_el1, },
> +       { SYS_DESC(SYS_ID_AA64DFR0_EL1),
> +         .access =3D access_id_reg,
> +         .get_user =3D get_id_reg,
> +         .set_user =3D set_id_aa64dfr0_el1,
> +         .reset =3D read_sanitised_id_aa64dfr0_el1,
> +         .val =3D ID_AA64DFR0_EL1_PMUVer_MASK, },
>         ID_SANITISED(ID_AA64DFR1_EL1),
>         ID_UNALLOCATED(5,2),
>         ID_UNALLOCATED(5,3),
> @@ -3454,38 +3597,6 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
>                 idreg++;
>                 id =3D reg_to_encoding(idreg);
>         }
> -
> -       /*
> -        * The default is to expose CSV2 =3D=3D 1 if the HW isn't affecte=
d.
> -        * Although this is a per-CPU feature, we make it global because
> -        * asymmetric systems are just a nuisance.
> -        *
> -        * Userspace can override this as long as it doesn't promise
> -        * the impossible.
> -        */
> -       val =3D IDREG(kvm, SYS_ID_AA64PFR0_EL1);
> -
> -       if (arm64_get_spectre_v2_state() =3D=3D SPECTRE_UNAFFECTED) {
> -               val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
> -               val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CS=
V2), 1);
> -       }
> -       if (arm64_get_meltdown_state() =3D=3D SPECTRE_UNAFFECTED) {
> -               val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
> -               val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CS=
V3), 1);
> -       }
> -
> -       IDREG(kvm, SYS_ID_AA64PFR0_EL1) =3D val;
> -       /*
> -        * Initialise the default PMUver before there is a chance to
> -        * create an actual PMU.
> -        */
> -       val =3D IDREG(kvm, SYS_ID_AA64DFR0_EL1);
> -
> -       val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> -       val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
> -                         kvm_arm_pmu_get_pmuver_limit());
> -
> -       IDREG(kvm, SYS_ID_AA64DFR0_EL1) =3D val;
>  }
>
>  int __init kvm_sys_reg_table_init(void)
> --
> 2.41.0.rc0.172.g3f132b7071-goog
>
