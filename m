Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEC06B6E58
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 05:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbjCMEPk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 00:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjCMEPi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 00:15:38 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0526938E94
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 21:15:36 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id s17so6155329pgv.4
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 21:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678680935;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ICiyccuIxNKubJVNPm3vfDjG/ydP+GvUZ2kKe9U3fg8=;
        b=biyQkkRwcXPN0y6l0ypQo6y8R/fz/4fHdXJeJmXz0wBSq7leYuI9OHAP/2rrRzukzU
         TvnoBtGQwwo+XB9hibbSBZSXaluSH+SKhmpukm+vXlDMUq/bh5OuZBiQ7cQuHEvHGqry
         lfG1K3/E35kTlkV9lzN0Yr82Tgny/ha3VQlMMQnf0fnidYADVNv/IkuE0ohdmLWmw8e/
         0SIogYC0tuGlmPGwl4QVIJSm4ad+3kkl4phCuTnIrI6lz2IxiMthoTndh1jjM84YTc+3
         TfWAj3ppORXShpAL/syrJnKe1w15K6N4N3BnBys054RHbdK3/Fy2i5XSEyjrfGlkNSoZ
         cKqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678680935;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ICiyccuIxNKubJVNPm3vfDjG/ydP+GvUZ2kKe9U3fg8=;
        b=42aQoXqda3w46cqlj7SzirrojgcOxHP4N/H2Wcc7O4qJQiXt9R9RYRpEuzyVVinK7J
         GBi4MOlaxtFPN0PSou9JE1mSNeN4FiOs12u9Z2HM0zIiPCGQHSgH5ncmHwspyQnSYRRf
         1nvOFeABCm5ualaBGwDxKVKcECAxqaVmDQfYlOGwd6hZPgMnGi+73MJW9+fWSCYlgJwi
         8bIb7mroQOPYN6k0jnaLxI2L0CXF9z+UnNvx8rGBTR5SNDaiu2KEqLOkqVQNppPvJF1e
         aGa6PC6SCMteRDiuWsvngi+soHC/96j5IFXPWHcy43eTItdwva5GeGtThcKGu2IeX9eR
         xq+w==
X-Gm-Message-State: AO0yUKWblQDaKm/uH+HWCbsPh9tQXCs/E2CQIDUCDwQM6MKZg/V5tVSj
        xmsbwqtARcV47OIiZMq9ZenNpfmWcJDLHAWo7aNvEvv3P33/DCeXeRTgxw==
X-Google-Smtp-Source: AK7set/Biz5ZXyDhWISoW5+C/6opbLb9ahW9+ZsfV9OE9R/ZUhCiuayIe/CdrNcuA6XGjyvosdpfrcnEumV4+IUH/W0=
X-Received: by 2002:a65:4001:0:b0:503:2d3f:a187 with SMTP id
 f1-20020a654001000000b005032d3fa187mr10847064pgp.5.1678680935167; Sun, 12 Mar
 2023 21:15:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230228062246.1222387-1-jingzhangos@google.com> <20230228062246.1222387-6-jingzhangos@google.com>
In-Reply-To: <20230228062246.1222387-6-jingzhangos@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Sun, 12 Mar 2023 21:15:18 -0700
Message-ID: <CAAeT=FyKDe9Fn1o_WUK+EUfZxkxWnYHmnVOD4Eno9aqbWWeOqQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/6] KVM: arm64: Introduce ID register specific descriptor
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

On Mon, Feb 27, 2023 at 10:23=E2=80=AFPM Jing Zhang <jingzhangos@google.com=
> wrote:
>
> Introduce an ID feature register specific descriptor to include ID
> register specific fields and callbacks besides its corresponding
> general system register descriptor.
> New fields for ID register descriptor would be added later when it
> is necessary to support a writable ID register.
>
> No functional change intended.
>
> Co-developed-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arch/arm64/kvm/id_regs.c  | 184 ++++++++++++++++++++++++++++----------
>  arch/arm64/kvm/sys_regs.c |   2 +-
>  arch/arm64/kvm/sys_regs.h |   1 +
>  3 files changed, 138 insertions(+), 49 deletions(-)
>
> diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> index 21ec8fc10d79..fc0dcd557cbb 100644
> --- a/arch/arm64/kvm/id_regs.c
> +++ b/arch/arm64/kvm/id_regs.c
> @@ -18,6 +18,10 @@
>
>  #include "sys_regs.h"
>
> +struct id_reg_desc {
> +       const struct sys_reg_desc       reg_desc;
> +};
> +
>  static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
>  {
>         if (kvm_vcpu_has_pmu(vcpu))
> @@ -326,21 +330,25 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
>  }
>
>  /* sys_reg_desc initialiser for known cpufeature ID registers */
> -#define ID_SANITISED(name) {                   \
> -       SYS_DESC(SYS_##name),                   \
> -       .access =3D access_id_reg,                \
> -       .get_user =3D get_id_reg,                 \
> -       .set_user =3D set_id_reg,                 \
> -       .visibility =3D id_visibility,            \
> +#define ID_SANITISED(name) {                           \
> +       .reg_desc =3D {                                   \
> +               SYS_DESC(SYS_##name),                   \
> +               .access =3D access_id_reg,                \
> +               .get_user =3D get_id_reg,                 \
> +               .set_user =3D set_id_reg,                 \
> +               .visibility =3D id_visibility,            \
> +       },                                              \
>  }
>
>  /* sys_reg_desc initialiser for known cpufeature ID registers */
> -#define AA32_ID_SANITISED(name) {              \
> -       SYS_DESC(SYS_##name),                   \
> -       .access =3D access_id_reg,                \
> -       .get_user =3D get_id_reg,                 \
> -       .set_user =3D set_id_reg,                 \
> -       .visibility =3D aa32_id_visibility,       \
> +#define AA32_ID_SANITISED(name) {                      \
> +       .reg_desc =3D {                                   \
> +               SYS_DESC(SYS_##name),                   \
> +               .access =3D access_id_reg,                \
> +               .get_user =3D get_id_reg,                 \
> +               .set_user =3D set_id_reg,                 \
> +               .visibility =3D aa32_id_visibility,       \
> +       },                                              \
>  }
>
>  /*
> @@ -348,12 +356,14 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
>   * register with encoding Op0=3D3, Op1=3D0, CRn=3D0, CRm=3Dcrm, Op2=3Dop=
2
>   * (1 <=3D crm < 8, 0 <=3D Op2 < 8).
>   */
> -#define ID_UNALLOCATED(crm, op2) {                     \
> -       Op0(3), Op1(0), CRn(0), CRm(crm), Op2(op2),     \
> -       .access =3D access_id_reg,                        \
> -       .get_user =3D get_id_reg,                         \
> -       .set_user =3D set_id_reg,                         \
> -       .visibility =3D raz_visibility                    \
> +#define ID_UNALLOCATED(crm, op2) {                             \
> +       .reg_desc =3D {                                           \
> +               Op0(3), Op1(0), CRn(0), CRm(crm), Op2(op2),     \
> +               .access =3D access_id_reg,                        \
> +               .get_user =3D get_id_reg,                         \
> +               .set_user =3D set_id_reg,                         \
> +               .visibility =3D raz_visibility                    \
> +       },                                                      \
>  }
>
>  /*
> @@ -361,15 +371,17 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
>   * For now, these are exposed just like unallocated ID regs: they appear
>   * RAZ for the guest.
>   */
> -#define ID_HIDDEN(name) {                      \
> -       SYS_DESC(SYS_##name),                   \
> -       .access =3D access_id_reg,                \
> -       .get_user =3D get_id_reg,                 \
> -       .set_user =3D set_id_reg,                 \
> -       .visibility =3D raz_visibility,           \
> +#define ID_HIDDEN(name) {                              \
> +       .reg_desc =3D {                                   \
> +               SYS_DESC(SYS_##name),                   \
> +               .access =3D access_id_reg,                \
> +               .get_user =3D get_id_reg,                 \
> +               .set_user =3D set_id_reg,                 \
> +               .visibility =3D raz_visibility,           \
> +       },                                              \
>  }
>
> -static const struct sys_reg_desc id_reg_descs[] =3D {
> +static const struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] =3D {
>         /*
>          * ID regs: all ID_SANITISED() entries here must have correspondi=
ng
>          * entries in arm64_ftr_regs[].
> @@ -379,9 +391,13 @@ static const struct sys_reg_desc id_reg_descs[] =3D =
{
>         /* CRm=3D1 */
>         AA32_ID_SANITISED(ID_PFR0_EL1),
>         AA32_ID_SANITISED(ID_PFR1_EL1),
> -       { SYS_DESC(SYS_ID_DFR0_EL1), .access =3D access_id_reg,
> -         .get_user =3D get_id_reg, .set_user =3D set_id_dfr0_el1,
> -         .visibility =3D aa32_id_visibility, },
> +       { .reg_desc =3D {
> +               SYS_DESC(SYS_ID_DFR0_EL1),
> +               .access =3D access_id_reg,
> +               .get_user =3D get_id_reg,
> +               .set_user =3D set_id_dfr0_el1,
> +               .visibility =3D aa32_id_visibility, },
> +       },
>         ID_HIDDEN(ID_AFR0_EL1),
>         AA32_ID_SANITISED(ID_MMFR0_EL1),
>         AA32_ID_SANITISED(ID_MMFR1_EL1),
> @@ -410,8 +426,12 @@ static const struct sys_reg_desc id_reg_descs[] =3D =
{
>
>         /* AArch64 ID registers */
>         /* CRm=3D4 */
> -       { SYS_DESC(SYS_ID_AA64PFR0_EL1), .access =3D access_id_reg,
> -         .get_user =3D get_id_reg, .set_user =3D set_id_aa64pfr0_el1, },
> +       { .reg_desc =3D {
> +               SYS_DESC(SYS_ID_AA64PFR0_EL1),
> +               .access =3D access_id_reg,
> +               .get_user =3D get_id_reg,
> +               .set_user =3D set_id_aa64pfr0_el1, },
> +       },
>         ID_SANITISED(ID_AA64PFR1_EL1),
>         ID_UNALLOCATED(4, 2),
>         ID_UNALLOCATED(4, 3),
> @@ -421,8 +441,12 @@ static const struct sys_reg_desc id_reg_descs[] =3D =
{
>         ID_UNALLOCATED(4, 7),
>
>         /* CRm=3D5 */
> -       { SYS_DESC(SYS_ID_AA64DFR0_EL1), .access =3D access_id_reg,
> -         .get_user =3D get_id_reg, .set_user =3D set_id_aa64dfr0_el1, },
> +       { .reg_desc =3D {
> +               SYS_DESC(SYS_ID_AA64DFR0_EL1),
> +               .access =3D access_id_reg,
> +               .get_user =3D get_id_reg,
> +               .set_user =3D set_id_aa64dfr0_el1, },
> +       },
>         ID_SANITISED(ID_AA64DFR1_EL1),
>         ID_UNALLOCATED(5, 2),
>         ID_UNALLOCATED(5, 3),
> @@ -461,12 +485,12 @@ static const struct sys_reg_desc id_reg_descs[] =3D=
 {
>   */
>  int emulate_id_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *params)
>  {
> -       const struct sys_reg_desc *r;
> +       u32 id;
>
> -       r =3D find_reg(params, id_reg_descs, ARRAY_SIZE(id_reg_descs));
> +       id =3D reg_to_encoding(params);
>
> -       if (likely(r)) {
> -               perform_access(vcpu, params, r);
> +       if (likely(is_id_reg(id))) {
> +               perform_access(vcpu, params, &id_reg_descs[IDREG_IDX(id)]=
.reg_desc);
>         } else {
>                 print_sys_reg_msg(params,
>                                   "Unsupported guest id_reg access at: %l=
x [%08lx]\n",
> @@ -483,38 +507,102 @@ void kvm_arm_reset_id_regs(struct kvm_vcpu *vcpu)
>         unsigned long i;
>
>         for (i =3D 0; i < ARRAY_SIZE(id_reg_descs); i++)
> -               if (id_reg_descs[i].reset)
> -                       id_reg_descs[i].reset(vcpu, &id_reg_descs[i]);
> +               if (id_reg_descs[i].reg_desc.reset)
> +                       id_reg_descs[i].reg_desc.reset(vcpu, &id_reg_desc=
s[i].reg_desc);
>  }
>
>  int kvm_arm_get_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *=
reg)
>  {
> -       return kvm_sys_reg_get_user(vcpu, reg,
> -                                   id_reg_descs, ARRAY_SIZE(id_reg_descs=
));
> +       u64 __user *uaddr =3D (u64 __user *)(unsigned long)reg->addr;
> +       const struct sys_reg_desc *r;
> +       struct sys_reg_params params;
> +       u64 val;
> +       int ret;
> +       u32 id;
> +
> +       if (!index_to_params(reg->id, &params))
> +               return -ENOENT;
> +       id =3D reg_to_encoding(&params);
> +
> +       if (!is_id_reg(id))
> +               return -ENOENT;
> +
> +       r =3D &id_reg_descs[IDREG_IDX(id)].reg_desc;
> +       if (r->get_user) {
> +               ret =3D (r->get_user)(vcpu, r, &val);
> +       } else {
> +               ret =3D 0;
> +               val =3D IDREG(vcpu->kvm, id);
> +       }
> +
> +       if (!ret)
> +               ret =3D put_user(val, uaddr);
> +
> +       return ret;
>  }
>
>  int kvm_arm_set_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *=
reg)
>  {
> -       return kvm_sys_reg_set_user(vcpu, reg,
> -                                   id_reg_descs, ARRAY_SIZE(id_reg_descs=
));
> +       u64 __user *uaddr =3D (u64 __user *)(unsigned long)reg->addr;
> +       const struct sys_reg_desc *r;
> +       struct sys_reg_params params;
> +       u64 val;
> +       int ret;
> +       u32 id;
> +
> +       if (!index_to_params(reg->id, &params))
> +               return -ENOENT;
> +       id =3D reg_to_encoding(&params);
> +
> +       if (!is_id_reg(id))
> +               return -ENOENT;
> +
> +       if (get_user(val, uaddr))
> +               return -EFAULT;
> +
> +       r =3D &id_reg_descs[IDREG_IDX(id)].reg_desc;
> +
> +       if (sysreg_user_write_ignore(vcpu, r))
> +               return 0;
> +
> +       if (r->set_user) {
> +               ret =3D (r->set_user)(vcpu, r, val);
> +       } else {
> +               WARN_ONCE(1, "ID register set_user callback is NULL\n");
> +               ret =3D 0;
> +       }
> +
> +       return ret;
>  }
>
>  bool kvm_arm_check_idreg_table(void)
>  {
> -       return check_sysreg_table(id_reg_descs, ARRAY_SIZE(id_reg_descs),=
 false);
> +       unsigned int i;
> +
> +       for (i =3D 0; i < ARRAY_SIZE(id_reg_descs); i++) {
> +               const struct sys_reg_desc *r =3D &id_reg_descs[i].reg_des=
c;
> +
> +               if (IDREG_IDX(reg_to_encoding(r)) !=3D i) {

As I mentioned for the previous version of the patch,
can we also check if this is an ID register ?

> +                       kvm_err("id_reg table %pS entry %d not set correc=
tly\n",
> +                               &id_reg_descs[i].reg_desc, i);
> +                       return false;
> +               }
> +       }
> +
> +       return true;
>  }
>
>  int kvm_arm_walk_id_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
>  {
> -       const struct sys_reg_desc *i2, *end2;
> +       const struct id_reg_desc *i2, *end2;
>         unsigned int total =3D 0;
>         int err;
>
>         i2 =3D id_reg_descs;
>         end2 =3D id_reg_descs + ARRAY_SIZE(id_reg_descs);
>
> -       while (i2 !=3D end2) {
> -               err =3D walk_one_sys_reg(vcpu, i2++, &uind, &total);
> +       for (; i2 !=3D end2; i2++) {
> +               err =3D walk_one_sys_reg(vcpu, &(i2->reg_desc), &uind, &t=
otal);
>                 if (err)
>                         return err;
>         }
> @@ -532,12 +620,12 @@ void kvm_arm_set_default_id_regs(struct kvm *kvm)
>         u64 val;
>
>         for (i =3D 0; i < ARRAY_SIZE(id_reg_descs); i++) {
> -               id =3D reg_to_encoding(&id_reg_descs[i]);
> +               id =3D reg_to_encoding(&id_reg_descs[i].reg_desc);
>                 if (WARN_ON_ONCE(!is_id_reg(id)))

If kvm_arm_check_idreg_table() checks all entries in the table
are an ID register, we can remove this checking from here.

Thank you,
Reiji


>                         /* Shouldn't happen */
>                         continue;
>
> -               if (id_reg_descs[i].visibility =3D=3D raz_visibility)
> +               if (id_reg_descs[i].reg_desc.visibility =3D=3D raz_visibi=
lity)
>                         /* Hidden or reserved ID register */
>                         continue;
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 568ebc0fb15c..7b63d9038639 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2519,7 +2519,7 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
>   * Userspace API
>   ***********************************************************************=
******/
>
> -static bool index_to_params(u64 id, struct sys_reg_params *params)
> +bool index_to_params(u64 id, struct sys_reg_params *params)
>  {
>         switch (id & KVM_REG_SIZE_MASK) {
>         case KVM_REG_SIZE_U64:
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index 9231d89889c7..094a7f19d93f 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -239,6 +239,7 @@ static inline bool is_id_reg(u32 id)
>
>  void perform_access(struct kvm_vcpu *vcpu, struct sys_reg_params *params=
,
>                     const struct sys_reg_desc *r);
> +bool index_to_params(u64 id, struct sys_reg_params *params);
>  const struct sys_reg_desc *get_reg_by_id(u64 id,
>                                          const struct sys_reg_desc table[=
],
>                                          unsigned int num);
> --
> 2.39.2.722.g9855ee24e9-goog
>
