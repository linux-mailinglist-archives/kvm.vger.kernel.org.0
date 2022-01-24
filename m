Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62CB849870B
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 18:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244317AbiAXRiL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 12:38:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241554AbiAXRiK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 12:38:10 -0500
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59128C06173B
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 09:38:10 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id u25-20020a4ad0d9000000b002e8d4370689so1209307oor.12
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 09:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z+4lX03Z7thqmqhIL7aBtUzzSrlXpBgYJc7/uee7XGU=;
        b=CfJWzykVDss/WnxJ+xPRyCXFPQL0UhnH1vYD1aRvWNPzMn56PDvzi+BO7LjYdTYXJd
         M1kKSZzUw/PYe7pjxjOISiZbMh8bn2YOhLMGk7PsIrxkL1hprkMrbUuY2bJcaFkJrGBf
         yfejo/rfqYKDh4YBJTVwdgc0/JW0MnvZDDoiGO8pEOvc6JoO1Os2YJ4ZhhvJTpmMfCgr
         WNhfeoMwi06gzCrgvaYqn5kXATHHSPfDbKcGM56FZVGU9SYScoGKvv/7qKo1nTJTjAli
         I6uhw2dY/RxZOKXapLRAB1mSK6qfgYXAUyULl4B+vH+Zrigqaoyphp+9mJ+hSXTB2r3O
         AstA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z+4lX03Z7thqmqhIL7aBtUzzSrlXpBgYJc7/uee7XGU=;
        b=bQpwERnIgCAMMbk3RXluvgZUgVr6PVZnxbmlBNf69a7EOG6PTXx1W2pewoJhu+RkFa
         df4GA8YedOfjjxXJD6+TGUwkTadw8+dFD8yOBCUs8KMk9hdxMOQasulN+guNghBfMqa7
         p9oamnW1MkBwEHvpeVGThiu4YeSn5ALmQcyuKOPWXFlWlU7PkzplcaXtJY+ZUxR77zWj
         L/5mTlW+S4g+j83ZWEMDA0XP/KX1a2xxPu+Ys+XyWfMhUJ0undIvQdLJ7jnYfI5JcOOx
         dEMXDnrxPK+m5nBHAcEt4ArRUTzTNPOIXXloUCgqeA+0BOsVyEv4cVdh1mAs2E6zO/Rg
         k1Lw==
X-Gm-Message-State: AOAM532It85nwlONwEDW/4LrALeX1X6PadMSjHGoXSSN0a7xxzVdzMZh
        5CHkaMWPeTLN7dEDfDYKQAnEALsh8ZaTg128F2+uzw==
X-Google-Smtp-Source: ABdhPJwNbl8nKwcswMVjytu39GrV6F0d5lYfA6PlQ7mIlOqKGtIrl6rBCDwkm0L6uHX8c7FdaFykhvjkchb5aT3w7cI=
X-Received: by 2002:a4a:9747:: with SMTP id v7mr10831680ooi.31.1643045889443;
 Mon, 24 Jan 2022 09:38:09 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com> <20220106042708.2869332-24-reijiw@google.com>
In-Reply-To: <20220106042708.2869332-24-reijiw@google.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Mon, 24 Jan 2022 17:37:33 +0000
Message-ID: <CA+EHjTxYqPvyUz96hoJWe43raST1X7oKhdR7PeZDuwuuD9QcYQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4 23/26] KVM: arm64: Trap disabled features of ID_AA64MMFR1_EL1
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

The series might be missing an entry for ID_AA64MMFR0_EL1, Debug
Communications Channel registers, ID_AA64MMFR0_FGT -> MDCR_EL2_TDCC.

Cheers,
/fuad


On Thu, Jan 6, 2022 at 4:29 AM Reiji Watanabe <reijiw@google.com> wrote:
>
> Add feature_config_ctrl for LORegions, which is indicated in
> ID_AA64MMFR1_EL1, to program configuration register to trap
> guest's using the feature when it is not exposed to the guest.
>
> Change trap_loregion() to use vcpu_feature_is_available()
> to simplify checking of the feature's availability.
>
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 229671ec3abd..f8a5ee927ecf 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -365,6 +365,11 @@ static void feature_tracefilt_trap_activate(struct kvm_vcpu *vcpu)
>         feature_trap_activate(vcpu, VCPU_MDCR_EL2, MDCR_EL2_TTRF, 0);
>  }
>
> +static void feature_lor_trap_activate(struct kvm_vcpu *vcpu)
> +{
> +       feature_trap_activate(vcpu, VCPU_HCR_EL2, HCR_TLOR, 0);
> +}
> +
>  /* For ID_AA64PFR0_EL1 */
>  static struct feature_config_ctrl ftr_ctrl_ras = {
>         .ftr_reg = SYS_ID_AA64PFR0_EL1,
> @@ -416,6 +421,15 @@ static struct feature_config_ctrl ftr_ctrl_tracefilt = {
>         .trap_activate = feature_tracefilt_trap_activate,
>  };
>
> +/* For ID_AA64MMFR1_EL1 */
> +static struct feature_config_ctrl ftr_ctrl_lor = {
> +       .ftr_reg = SYS_ID_AA64MMFR1_EL1,
> +       .ftr_shift = ID_AA64MMFR1_LOR_SHIFT,
> +       .ftr_min = 1,
> +       .ftr_signed = FTR_UNSIGNED,
> +       .trap_activate = feature_lor_trap_activate,
> +};
> +
>  struct id_reg_info {
>         u32     sys_reg;        /* Register ID */
>         u64     sys_val;        /* Sanitized system value */
> @@ -947,6 +961,14 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
>         },
>  };
>
> +static struct id_reg_info id_aa64mmfr1_el1_info = {
> +       .sys_reg = SYS_ID_AA64MMFR1_EL1,
> +       .trap_features = &(const struct feature_config_ctrl *[]) {
> +               &ftr_ctrl_lor,
> +               NULL,
> +       },
> +};
> +
>  static struct id_reg_info id_dfr0_el1_info = {
>         .sys_reg = SYS_ID_DFR0_EL1,
>         .init = init_id_dfr0_el1_info,
> @@ -976,6 +998,7 @@ static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
>         [IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
>         [IDREG_IDX(SYS_ID_AA64ISAR1_EL1)] = &id_aa64isar1_el1_info,
>         [IDREG_IDX(SYS_ID_AA64MMFR0_EL1)] = &id_aa64mmfr0_el1_info,
> +       [IDREG_IDX(SYS_ID_AA64MMFR1_EL1)] = &id_aa64mmfr1_el1_info,
>  };
>
>  static int validate_id_reg(struct kvm_vcpu *vcpu, u32 id, u64 val)
> @@ -1050,10 +1073,9 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
>                           struct sys_reg_params *p,
>                           const struct sys_reg_desc *r)
>  {
> -       u64 val = __read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
>         u32 sr = reg_to_encoding(r);
>
> -       if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
> +       if (!vcpu_feature_is_available(vcpu, &ftr_ctrl_lor)) {
>                 kvm_inject_undefined(vcpu);
>                 return false;
>         }
> --
> 2.34.1.448.ga2b2bfdf31-goog
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
