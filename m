Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42C596A272E
	for <lists+kvm@lfdr.de>; Sat, 25 Feb 2023 05:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjBYEAn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 23:00:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjBYEAm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 23:00:42 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F49C241E7
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 20:00:40 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id u14so1481636ple.7
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 20:00:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Z2TmJcFH9O9SUNmkSWnxCIRwMf12CvUDEAZ35VU5Pik=;
        b=WHfqyxuKnYGcFAebnW437TxhTxKmtsrK2XiVjQoNghG6Q3tWpz68j82GKJl150Fb8v
         KwwT9/uI4RnTYK4RohKmHHB32IoEJ0ht6dqKDUIcaOG+qffhmXaf7blm7ZF7eHnL6pBA
         EZbZDEmNJaggrXCZLfTKCjjMQWyoR6Ts0TKBjSv6dtvOMObM2LXRQw3TH2XoVkHfvI5Z
         azsOjJx8SH8UQ3A9Zb7IohawV0Px56BXykOSAPFRpTHUw5mgLZf3sSHMMRWw5I+MnB/0
         pI7yympzS0MgIJmb/lqQyBnf3upuwpjzSVkIx3ywAI4Ln+M1jeQ89m1Tm7FD4ABHQwmz
         QSAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z2TmJcFH9O9SUNmkSWnxCIRwMf12CvUDEAZ35VU5Pik=;
        b=2t9t/9SPEyE4RnGi1zY4KlMYv9Dg5F8NNjyNwQkQkI+2iCrSrvc0yAr9eTH0OccV7c
         X8qK3AG7yrE3vh0LOGscon3Lc3Qn4lfviI+NY4PU1TAacHx+REeLJse6y5gvG+MHXg+U
         dWoKrfDj1fb+jqDzHIgWHvA9wnB6Q2TOa/vJZBipZ2rBjgv6VksXh+eC152L0wFMhYE3
         it8Dmn9F17ZK+m29th4Gmyb5PNshOfIbGRDDF06URiTJi+vYJpdqyR7gT8hxchmSZ8uV
         oEMJIGBFqXkthf+PyAqhm9L0hCdZVB1IMWMIkoe4gZoUkhNvsW51dVpHd5yGx9+p3s+i
         EHJA==
X-Gm-Message-State: AO0yUKWZqb/SmL/L0X5urm2ojUqiCOZa17kEllvNCVfu0ZUplVeZw8Kj
        MOvaJmxe82Iai1O1/1CnRVvvV04NhS9NsqZyywT9rg==
X-Google-Smtp-Source: AK7set813CgWX5YhopvV9eZfavzsoYAC/P0k/rqZERTNcm+E1IhFIs8h6S15zkEXbLZ0anWrGJ4gthBIwDsKKUC8luQ=
X-Received: by 2002:a17:90a:2dc7:b0:234:bed1:1012 with SMTP id
 q7-20020a17090a2dc700b00234bed11012mr2482311pjm.6.1677297639482; Fri, 24 Feb
 2023 20:00:39 -0800 (PST)
MIME-Version: 1.0
References: <20230212215830.2975485-1-jingzhangos@google.com> <20230212215830.2975485-6-jingzhangos@google.com>
In-Reply-To: <20230212215830.2975485-6-jingzhangos@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Fri, 24 Feb 2023 20:00:23 -0800
Message-ID: <CAAeT=Fz-G_EUmh=Pj3UHA7pnKKYi7UyYuedziJxfmSoKpntw3Q@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] KVM: arm64: Introduce ID register specific descriptor
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

On Sun, Feb 12, 2023 at 1:58 PM Jing Zhang <jingzhangos@google.com> wrote:
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
>  arch/arm64/kvm/id_regs.c  | 187 +++++++++++++++++++++++++++++---------
>  arch/arm64/kvm/sys_regs.c |   2 +-
>  arch/arm64/kvm/sys_regs.h |   1 +
>  3 files changed, 144 insertions(+), 46 deletions(-)
>
> diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> index 14ae03a1d8d0..15d0338742b6 100644
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
> @@ -329,21 +333,25 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
>  }
>
>  /* sys_reg_desc initialiser for known cpufeature ID registers */
> -#define ID_SANITISED(name) {                   \
> -       SYS_DESC(SYS_##name),                   \
> -       .access = access_id_reg,                \
> -       .get_user = get_id_reg,                 \
> -       .set_user = set_id_reg,                 \
> -       .visibility = id_visibility,            \
> +#define ID_SANITISED(name) {                           \
> +       .reg_desc = {                                   \
> +               SYS_DESC(SYS_##name),                   \
> +               .access = access_id_reg,                \
> +               .get_user = get_id_reg,                 \
> +               .set_user = set_id_reg,                 \
> +               .visibility = id_visibility,            \
> +       },                                              \
>  }
>
>  /* sys_reg_desc initialiser for known cpufeature ID registers */
> -#define AA32_ID_SANITISED(name) {              \
> -       SYS_DESC(SYS_##name),                   \
> -       .access = access_id_reg,                \
> -       .get_user = get_id_reg,                 \
> -       .set_user = set_id_reg,                 \
> -       .visibility = aa32_id_visibility,       \
> +#define AA32_ID_SANITISED(name) {                      \
> +       .reg_desc = {                                   \
> +               SYS_DESC(SYS_##name),                   \
> +               .access = access_id_reg,                \
> +               .get_user = get_id_reg,                 \
> +               .set_user = set_id_reg,                 \
> +               .visibility = aa32_id_visibility,       \
> +       },                                              \
>  }
>
>  /*
> @@ -351,12 +359,14 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
>   * register with encoding Op0=3, Op1=0, CRn=0, CRm=crm, Op2=op2
>   * (1 <= crm < 8, 0 <= Op2 < 8).
>   */
> -#define ID_UNALLOCATED(crm, op2) {                     \
> -       Op0(3), Op1(0), CRn(0), CRm(crm), Op2(op2),     \
> -       .access = access_id_reg,                        \
> -       .get_user = get_id_reg,                         \
> -       .set_user = set_id_reg,                         \
> -       .visibility = raz_visibility                    \
> +#define ID_UNALLOCATED(crm, op2) {                             \
> +       .reg_desc = {                                           \
> +               Op0(3), Op1(0), CRn(0), CRm(crm), Op2(op2),     \
> +               .access = access_id_reg,                        \
> +               .get_user = get_id_reg,                         \
> +               .set_user = set_id_reg,                         \
> +               .visibility = raz_visibility                    \
> +       },                                                      \
>  }
>
>  /*
> @@ -364,15 +374,17 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
>   * For now, these are exposed just like unallocated ID regs: they appear
>   * RAZ for the guest.
>   */
> -#define ID_HIDDEN(name) {                      \
> -       SYS_DESC(SYS_##name),                   \
> -       .access = access_id_reg,                \
> -       .get_user = get_id_reg,                 \
> -       .set_user = set_id_reg,                 \
> -       .visibility = raz_visibility,           \
> +#define ID_HIDDEN(name) {                              \
> +       .reg_desc = {                                   \
> +               SYS_DESC(SYS_##name),                   \
> +               .access = access_id_reg,                \
> +               .get_user = get_id_reg,                 \
> +               .set_user = set_id_reg,                 \
> +               .visibility = raz_visibility,           \
> +       },                                              \
>  }
>
> -static const struct sys_reg_desc id_reg_descs[] = {
> +static const struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
>         /*
>          * ID regs: all ID_SANITISED() entries here must have corresponding
>          * entries in arm64_ftr_regs[].
> @@ -382,9 +394,13 @@ static const struct sys_reg_desc id_reg_descs[] = {
>         /* CRm=1 */
>         AA32_ID_SANITISED(ID_PFR0_EL1),
>         AA32_ID_SANITISED(ID_PFR1_EL1),
> -       { SYS_DESC(SYS_ID_DFR0_EL1), .access = access_id_reg,
> -         .get_user = get_id_reg, .set_user = set_id_dfr0_el1,
> -         .visibility = aa32_id_visibility, },
> +       { .reg_desc = {
> +               SYS_DESC(SYS_ID_DFR0_EL1),
> +               .access = access_id_reg,
> +               .get_user = get_id_reg,
> +               .set_user = set_id_dfr0_el1,
> +               .visibility = aa32_id_visibility, },
> +       },
>         ID_HIDDEN(ID_AFR0_EL1),
>         AA32_ID_SANITISED(ID_MMFR0_EL1),
>         AA32_ID_SANITISED(ID_MMFR1_EL1),
> @@ -413,8 +429,12 @@ static const struct sys_reg_desc id_reg_descs[] = {
>
>         /* AArch64 ID registers */
>         /* CRm=4 */
> -       { SYS_DESC(SYS_ID_AA64PFR0_EL1), .access = access_id_reg,
> -         .get_user = get_id_reg, .set_user = set_id_aa64pfr0_el1, },
> +       { .reg_desc = {
> +               SYS_DESC(SYS_ID_AA64PFR0_EL1),
> +               .access = access_id_reg,
> +               .get_user = get_id_reg,
> +               .set_user = set_id_aa64pfr0_el1, },
> +       },
>         ID_SANITISED(ID_AA64PFR1_EL1),
>         ID_UNALLOCATED(4, 2),
>         ID_UNALLOCATED(4, 3),
> @@ -424,8 +444,12 @@ static const struct sys_reg_desc id_reg_descs[] = {
>         ID_UNALLOCATED(4, 7),
>
>         /* CRm=5 */
> -       { SYS_DESC(SYS_ID_AA64DFR0_EL1), .access = access_id_reg,
> -         .get_user = get_id_reg, .set_user = set_id_aa64dfr0_el1, },
> +       { .reg_desc = {
> +               SYS_DESC(SYS_ID_AA64DFR0_EL1),
> +               .access = access_id_reg,
> +               .get_user = get_id_reg,
> +               .set_user = set_id_aa64dfr0_el1, },
> +       },
>         ID_SANITISED(ID_AA64DFR1_EL1),
>         ID_UNALLOCATED(5, 2),
>         ID_UNALLOCATED(5, 3),
> @@ -457,7 +481,13 @@ static const struct sys_reg_desc id_reg_descs[] = {
>
>  const struct sys_reg_desc *kvm_arm_find_id_reg(const struct sys_reg_params *params)
>  {
> -       return find_reg(params, id_reg_descs, ARRAY_SIZE(id_reg_descs));
> +       u32 id;
> +
> +       id = reg_to_encoding(params);
> +       if (!is_id_reg(id))
> +               return NULL;
> +
> +       return &id_reg_descs[IDREG_IDX(id)].reg_desc;
>  }
>
>  void kvm_arm_reset_id_regs(struct kvm_vcpu *vcpu)
> @@ -465,39 +495,106 @@ void kvm_arm_reset_id_regs(struct kvm_vcpu *vcpu)
>         unsigned long i;
>
>         for (i = 0; i < ARRAY_SIZE(id_reg_descs); i++)
> -               if (id_reg_descs[i].reset)
> -                       id_reg_descs[i].reset(vcpu, &id_reg_descs[i]);
> +               if (id_reg_descs[i].reg_desc.reset)
> +                       id_reg_descs[i].reg_desc.reset(vcpu, &id_reg_descs[i].reg_desc);
>  }
>
>  int kvm_arm_get_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  {
> -       return kvm_sys_reg_get_user(vcpu, reg,
> -                                   id_reg_descs, ARRAY_SIZE(id_reg_descs));
> +       u64 __user *uaddr = (u64 __user *)(unsigned long)reg->addr;
> +       const struct sys_reg_desc *r;
> +       struct sys_reg_params params;
> +       u64 val;
> +       int ret;
> +       u32 id;
> +
> +       if (!index_to_params(reg->id, &params))
> +               return -ENOENT;
> +       id = reg_to_encoding(&params);
> +
> +       if (!is_id_reg(id))
> +               return -ENOENT;
> +
> +       r = &id_reg_descs[IDREG_IDX(id)].reg_desc;
> +       if (r->get_user) {
> +               ret = (r->get_user)(vcpu, r, &val);
> +       } else {
> +               ret = 0;
> +               val = 0;

When get_user is NULL, I wonder why you want to treat them RAZ.
It can be achieved by using visibility(), which I think might be
better to use before calling get_user.
Another option would be simply reading from IDREG(), which I would
guess might be useful(?) when no special handling is necessary.


> +       }
> +
> +       if (!ret)
> +               ret = put_user(val, uaddr);
> +
> +       return ret;
>  }
>
>  int kvm_arm_set_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  {
> -       return kvm_sys_reg_set_user(vcpu, reg,
> -                                   id_reg_descs, ARRAY_SIZE(id_reg_descs));
> +       u64 __user *uaddr = (u64 __user *)(unsigned long)reg->addr;
> +       const struct sys_reg_desc *r;
> +       struct sys_reg_params params;
> +       u64 val;
> +       int ret;
> +       u32 id;
> +
> +       if (!index_to_params(reg->id, &params))
> +               return -ENOENT;
> +       id = reg_to_encoding(&params);
> +
> +       if (!is_id_reg(id))
> +               return -ENOENT;
> +
> +       if (get_user(val, uaddr))
> +               return -EFAULT;
> +
> +       r = &id_reg_descs[IDREG_IDX(id)].reg_desc;
> +
> +       if (sysreg_user_write_ignore(vcpu, r))
> +               return 0;
> +
> +       if (r->set_user)
> +               ret = (r->set_user)(vcpu, r, val);
> +       else
> +               ret = 0;

This appears to be the same handling as WI.
How do you plan to use this set_user == NULL case ?
I don't think this shouldn't happen with the current code.
You might want to use WARN_ONCE here ?

> +
> +       return ret;
>  }
>
>  bool kvm_arm_check_idreg_table(void)
>  {
> -       return check_sysreg_table(id_reg_descs, ARRAY_SIZE(id_reg_descs), false);
> +       unsigned int i;
> +
> +       for (i = 0; i < ARRAY_SIZE(id_reg_descs); i++) {
> +               const struct sys_reg_desc *r = &id_reg_descs[i].reg_desc;
> +
> +               if (r->reg && !r->reset) {

I don't think we need to check "!r->reset".
If r->reg is not NULL, I believe the entry must be incorrect.

> +                       kvm_err("sys_reg table %pS entry %d lacks reset\n", r, i);
> +                       return false;
> +               }
> +
> +               if (i && cmp_sys_reg(&id_reg_descs[i-1].reg_desc, r) >= 0) {

In this table, each ID register needs to be in the proper place.
So, I would think what should be checked would be if each entry
in the table includes the right ID register.
(e.g. id_reg_descs[0] must be for ID_PFR0_EL1, etc)

Thank you,
Reiji

> +                       kvm_err("sys_reg table %pS entry %d out of order\n",
> +                               &id_reg_descs[i - 1].reg_desc, i - 1);
> +                       return false;
> +               }
> +       }
> +
> +       return true;
>  }
>
>  /* Assumed ordered tables, see kvm_sys_reg_table_init. */
>  int kvm_arm_walk_id_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
>  {
> -       const struct sys_reg_desc *i2, *end2;
> +       const struct id_reg_desc *i2, *end2;
>         unsigned int total = 0;
>         int err;
>
>         i2 = id_reg_descs;
>         end2 = id_reg_descs + ARRAY_SIZE(id_reg_descs);
>
> -       while (i2 != end2) {
> -               err = walk_one_sys_reg(vcpu, i2++, &uind, &total);
> +       for (; i2 != end2; i2++) {
> +               err = walk_one_sys_reg(vcpu, &(i2->reg_desc), &uind, &total);
>                 if (err)
>                         return err;
>         }
> @@ -515,12 +612,12 @@ void kvm_arm_set_default_id_regs(struct kvm *kvm)
>         u64 val;
>
>         for (i = 0; i < ARRAY_SIZE(id_reg_descs); i++) {
> -               id = reg_to_encoding(&id_reg_descs[i]);
> +               id = reg_to_encoding(&id_reg_descs[i].reg_desc);
>                 if (WARN_ON_ONCE(!is_id_reg(id)))
>                         /* Shouldn't happen */
>                         continue;
>
> -               if (id_reg_descs[i].visibility == raz_visibility)
> +               if (id_reg_descs[i].reg_desc.visibility == raz_visibility)
>                         /* Hidden or reserved ID register */
>                         continue;
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index a4350f0737c3..cdcd61ac9868 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2518,7 +2518,7 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
>   * Userspace API
>   *****************************************************************************/
>
> -static bool index_to_params(u64 id, struct sys_reg_params *params)
> +bool index_to_params(u64 id, struct sys_reg_params *params)
>  {
>         switch (id & KVM_REG_SIZE_MASK) {
>         case KVM_REG_SIZE_U64:
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index 5cfab83ce8b8..3797d1b494a2 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -226,6 +226,7 @@ static inline bool write_to_read_only(struct kvm_vcpu *vcpu,
>         return false;
>  }
>
> +bool index_to_params(u64 id, struct sys_reg_params *params);
>  const struct sys_reg_desc *get_reg_by_id(u64 id,
>                                          const struct sys_reg_desc table[],
>                                          unsigned int num);
> --
> 2.39.1.581.gbfd45094c4-goog
>
