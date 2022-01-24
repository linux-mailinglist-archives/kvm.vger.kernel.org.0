Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E41349866F
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 18:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244451AbiAXRUj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 12:20:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244427AbiAXRUe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 12:20:34 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D0CC06173B
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 09:20:34 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id bx18so26529604oib.7
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 09:20:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n6ZSX0OGiLjAj7ZePuzn/e/7hNB5EthGPgk+JtIJg2I=;
        b=k/1vhkL+aQtAKz3YQFBz5OPhZpCJBYi1nWS493oLibLQy8xiq2+NKSFVJrp+FrTbEk
         SYmZqBh7bhkmVXOa/jM28TuVJ9HDT9iAGLg3FErDEAbEFy+BEa91tcM/kgecfKlZVK99
         Fxnu78qzqNye2FLoT0GboS5LhoEM6i/L/oLww9RAk2mTkFiyNNaWrTBZld2R7hJIj4yC
         u2LzPsq6761LxuMEFwd6VrZ+KB0U0pLZ3RtZAtBVqBI8O3ZB7UPckB7PHvw0Ge/VPUpe
         kvHiMwKLT/F8XpIqP2XCPvVhNXeFUPpVrYY5hanWUcVutzC46AsfhY8FuwPRKDvUJRLx
         +u3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n6ZSX0OGiLjAj7ZePuzn/e/7hNB5EthGPgk+JtIJg2I=;
        b=XBAXUtpkvdn/BXakTfNUv5S88Zm7wJL84Uj0Y+oIQdwU8jy7pjdeTHWPJYpPzpGfG4
         vhl7vdSk9RK/fnZ+IgoQvy2ARY4iHcgqo1cnHIuQz5qlYN3MBgZomwP61YcIZCHIm+rr
         IVaC8FQ538PkXm3eP3OHEwv2YOhR30oXEmq5ySaWrbgFslhAiarZ9VKO3iyoPhDbxrlH
         n41hDR0OgpH55pcZrmuP+SP20lqKN+23BE6L6B4a5n4RJqAybR5t4E2VY9CkhyZlF50R
         Iu7XywyGoTMtP5YmeP58rWabpnoxQLn8FCVVTexMVfTpfiFvgagNBfJt/1yOGDH6pn+d
         WnIQ==
X-Gm-Message-State: AOAM531DQQnHBIpLXPB7tiZokHXTbQXqPeCCnS1GoEpj4QY/zlDJG7ZQ
        yJik0DLhCUjykBGAHb7L2atyptWlA6Y8rPuC+e1B3+XkhkiWQA==
X-Google-Smtp-Source: ABdhPJyL4QjGFXgPz8bOY7BIzGA+C5r4lAXfNJPmvzK0kbywEB5UljmnJSozM36IED/hjKZH8iLUQweYxuZt0CD1/7s=
X-Received: by 2002:a05:6808:249:: with SMTP id m9mr1837626oie.96.1643044833375;
 Mon, 24 Jan 2022 09:20:33 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com> <20220106042708.2869332-23-reijiw@google.com>
In-Reply-To: <20220106042708.2869332-23-reijiw@google.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Mon, 24 Jan 2022 17:19:57 +0000
Message-ID: <CA+EHjTyimL8nuE0gH8B3V-MzoA9rz+n3KazqFxMtdJKgjefAag@mail.gmail.com>
Subject: Re: [RFC PATCH v4 22/26] KVM: arm64: Trap disabled features of ID_AA64DFR0_EL1
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

.Hi Reiji,

On Thu, Jan 6, 2022 at 4:29 AM Reiji Watanabe <reijiw@google.com> wrote:
>
> Add feature_config_ctrl for PMUv3, PMS and TraceFilt, which are
> indicated in ID_AA64DFR0_EL1, to program configuration registers
> to trap guest's using those features when they are not exposed to
> the guest.
>
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 47 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 72e745c5a9c2..229671ec3abd 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -349,6 +349,22 @@ static void feature_mte_trap_activate(struct kvm_vcpu *vcpu)
>         feature_trap_activate(vcpu, VCPU_HCR_EL2, HCR_TID5, HCR_DCT | HCR_ATA);
>  }
>
> +static void feature_pmuv3_trap_activate(struct kvm_vcpu *vcpu)
> +{
> +       feature_trap_activate(vcpu, VCPU_MDCR_EL2, MDCR_EL2_TPM, 0);

I think that for full coverage it might be good to include setting
MDCR_EL2_TPMCR, and clearing MDCR_EL2_HPME | MDCR_EL2_MTPME |
MDCR_EL2_HPMN_MASK, even if redundant at this point.

> +}
> +
> +static void feature_pms_trap_activate(struct kvm_vcpu *vcpu)
> +{
> +       feature_trap_activate(vcpu, VCPU_MDCR_EL2, MDCR_EL2_TPMS,
> +                             MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT);
> +}
> +
> +static void feature_tracefilt_trap_activate(struct kvm_vcpu *vcpu)
> +{
> +       feature_trap_activate(vcpu, VCPU_MDCR_EL2, MDCR_EL2_TTRF, 0);
> +}
> +
>  /* For ID_AA64PFR0_EL1 */
>  static struct feature_config_ctrl ftr_ctrl_ras = {
>         .ftr_reg = SYS_ID_AA64PFR0_EL1,
> @@ -375,6 +391,31 @@ static struct feature_config_ctrl ftr_ctrl_mte = {
>         .trap_activate = feature_mte_trap_activate,
>  };
>
> +/* For ID_AA64DFR0_EL1 */
> +static struct feature_config_ctrl ftr_ctrl_pmuv3 = {
> +       .ftr_reg = SYS_ID_AA64DFR0_EL1,
> +       .ftr_shift = ID_AA64DFR0_PMUVER_SHIFT,
> +       .ftr_min = ID_AA64DFR0_PMUVER_8_0,
> +       .ftr_signed = FTR_UNSIGNED,
> +       .trap_activate = feature_pmuv3_trap_activate,
> +};
> +
> +static struct feature_config_ctrl ftr_ctrl_pms = {
> +       .ftr_reg = SYS_ID_AA64DFR0_EL1,
> +       .ftr_shift = ID_AA64DFR0_PMSVER_SHIFT,
> +       .ftr_min = ID_AA64DFR0_PMSVER_8_2,
> +       .ftr_signed = FTR_UNSIGNED,
> +       .trap_activate = feature_pms_trap_activate,
> +};
> +
> +static struct feature_config_ctrl ftr_ctrl_tracefilt = {
> +       .ftr_reg = SYS_ID_AA64DFR0_EL1,
> +       .ftr_shift = ID_AA64DFR0_TRACE_FILT_SHIFT,
> +       .ftr_min = 1,
> +       .ftr_signed = FTR_UNSIGNED,
> +       .trap_activate = feature_tracefilt_trap_activate,
> +};

I think you might be missing trace, ID_AA64DFR0_TRACEVER -> CPTR_EL2_TTA.

Cheers,
/fuad


> +
>  struct id_reg_info {
>         u32     sys_reg;        /* Register ID */
>         u64     sys_val;        /* Sanitized system value */
> @@ -898,6 +939,12 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
>         .init = init_id_aa64dfr0_el1_info,
>         .validate = validate_id_aa64dfr0_el1,
>         .vcpu_mask = vcpu_mask_id_aa64dfr0_el1,
> +       .trap_features = &(const struct feature_config_ctrl *[]) {
> +               &ftr_ctrl_pmuv3,
> +               &ftr_ctrl_pms,
> +               &ftr_ctrl_tracefilt,
> +               NULL,
> +       },
>  };
>
>  static struct id_reg_info id_dfr0_el1_info = {
> --
> 2.34.1.448.ga2b2bfdf31-goog
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
