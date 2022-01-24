Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E31498646
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 18:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244255AbiAXRRm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 12:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244254AbiAXRRd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 12:17:33 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5278CC061401
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 09:17:33 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id c3-20020a9d6c83000000b00590b9c8819aso23134002otr.6
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 09:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CL0djcumxtWN+BgS/G/QSSO38KOz4Hm+Dv6snxvPnLQ=;
        b=bEOX7mlSFbkKgmP35DipMBrLAvuLXbJBAG11aNsVoJzXY/NmD/d76/IBO5PRKM2z//
         mJ0hVyqyd59JqpacFdIoSXCurKr4RCKD3BOffUaqKo7Yqky3UvgRYxen3vtR2qmqZxnx
         oV3ef6KkJd/geDXrNFxs826oj+MRRB78BL5PEjyDug/vnEgYydSB6DORewhW9nyQl3T0
         7xrDiKzcV87LacmuCBZcbhevtuONAyEDBDrbqY7fanuy0CJ557oWYzZnXjy5G0uEpDPE
         Aejd+s/oWGk4vMeZCFepE5pR8gGYCcXgpWicwzdduLePpTlcBfv0EMtGBY0+gCOF+3zu
         J/xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CL0djcumxtWN+BgS/G/QSSO38KOz4Hm+Dv6snxvPnLQ=;
        b=b1OjHUFrdTTDFaOL/1eYw/zlftlcpnoO8Cv36yAVS+6BCEyuuY5+0ZQei3anmNNIlp
         1dFuaNwCdlgeZ7uRlfi0e9U1GWccYq6HUDNffYFlQRPcoQ0I5Lab2RJSZ1rKJqzxVaxE
         +3ePwbLSjNBsuhsa3x5xsd2x3auJYbLN+/N6F4yfhKa0Vr/bt9V+GNsFq0ZvlG6a2Luh
         d37i03P4vkClHwOpF5U8BfXxlrhPC0CZAI4aJpYmVeCoDekd91+pkhrH70IW5Tj+OVaJ
         mT887Yg55ZpKYc6/ZEIZKit1vfrpAps9RQlIq7bOh0D+1FqaYm1DM8rZAvRZP8M6iKdr
         l1Ww==
X-Gm-Message-State: AOAM5338bQjQWK+NKRmuccnRY9qo+L9wZiJZxioTqQxQHZJb6/vaVXAy
        qm8mUtrjRv+sZjuCxx0G/VuAwfSr/jwI3HUGMdBYVg==
X-Google-Smtp-Source: ABdhPJyrMjp3o7vm5+0kX9TJJ+ivG+r/ZOeyr6HGlSMAW0c24FM3CFAps82KuddHQJzsa74DX8Q5gGgHPMEQq/YOTHY=
X-Received: by 2002:a9d:6c0d:: with SMTP id f13mr648555otq.299.1643044652111;
 Mon, 24 Jan 2022 09:17:32 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com> <20220106042708.2869332-21-reijiw@google.com>
In-Reply-To: <20220106042708.2869332-21-reijiw@google.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Mon, 24 Jan 2022 17:16:55 +0000
Message-ID: <CA+EHjTy4L37G89orJ+cPTTZdFUehxNSMy0Pd36PW41JKVB0ohA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 20/26] KVM: arm64: Trap disabled features of ID_AA64PFR0_EL1
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

On Thu, Jan 6, 2022 at 4:29 AM Reiji Watanabe <reijiw@google.com> wrote:
>
> Add feature_config_ctrl for RAS and AMU, which are indicated in
> ID_AA64PFR0_EL1, to program configuration registers to trap
> guest's using those features when they are not exposed to the guest.
>
> Introduce trap_ras_regs() to change a behavior of guest's access to
> the registers, which is currently raz/wi, depending on the feature's
> availability for the guest (and inject undefined instruction
> exception when guest's RAS register access are trapped and RAS is
> not exposed to the guest).  In order to keep the current visibility
> of the RAS registers from userspace (always visible), a visibility
> function for RAS registers is not added.
>
> No code is added for AMU's access/visibility handler because the
> current code already injects the exception for Guest's AMU register
> access unconditionally because AMU is never exposed to the guest.

I think it might be code to trap it anyway, in case AMU guest support
is added in the future.

>
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 90 +++++++++++++++++++++++++++++++++++----
>  1 file changed, 82 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 33893a501475..015d67092d5e 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -304,6 +304,63 @@ struct feature_config_ctrl {
>         void    (*trap_activate)(struct kvm_vcpu *vcpu);
>  };
>
> +enum vcpu_config_reg {
> +       VCPU_HCR_EL2 = 1,
> +       VCPU_MDCR_EL2,
> +       VCPU_CPTR_EL2,
> +};
> +
> +static void feature_trap_activate(struct kvm_vcpu *vcpu,
> +                                 enum vcpu_config_reg cfg_reg,
> +                                 u64 cfg_set, u64 cfg_clear)
> +{
> +       u64 *reg_ptr, reg_val;
> +
> +       switch (cfg_reg) {
> +       case VCPU_HCR_EL2:
> +               reg_ptr = &vcpu->arch.hcr_el2;
> +               break;
> +       case VCPU_MDCR_EL2:
> +               reg_ptr = &vcpu->arch.mdcr_el2;
> +               break;
> +       case VCPU_CPTR_EL2:
> +               reg_ptr = &vcpu->arch.cptr_el2;
> +               break;
> +       }
> +
> +       /* Clear/Set fields that are indicated by cfg_clear/cfg_set. */
> +       reg_val = (*reg_ptr & ~cfg_clear);
> +       reg_val |= cfg_set;
> +       *reg_ptr = reg_val;
> +}
> +
> +static void feature_ras_trap_activate(struct kvm_vcpu *vcpu)
> +{
> +       feature_trap_activate(vcpu, VCPU_HCR_EL2, HCR_TERR | HCR_TEA, HCR_FIEN);

Covers all the flags for ras.

> +}
> +
> +static void feature_amu_trap_activate(struct kvm_vcpu *vcpu)
> +{
> +       feature_trap_activate(vcpu, VCPU_CPTR_EL2, CPTR_EL2_TAM, 0);

Covers the CPTR flags for AMU, but as you mentioned, does not
explicitly clear HCR_AMVOFFEN.

Cheers,
/fuad


> +}
> +
> +/* For ID_AA64PFR0_EL1 */
> +static struct feature_config_ctrl ftr_ctrl_ras = {
> +       .ftr_reg = SYS_ID_AA64PFR0_EL1,
> +       .ftr_shift = ID_AA64PFR0_RAS_SHIFT,
> +       .ftr_min = ID_AA64PFR0_RAS_V1,
> +       .ftr_signed = FTR_UNSIGNED,
> +       .trap_activate = feature_ras_trap_activate,
> +};
> +
> +static struct feature_config_ctrl ftr_ctrl_amu = {
> +       .ftr_reg = SYS_ID_AA64PFR0_EL1,
> +       .ftr_shift = ID_AA64PFR0_AMU_SHIFT,
> +       .ftr_min = ID_AA64PFR0_AMU,
> +       .ftr_signed = FTR_UNSIGNED,
> +       .trap_activate = feature_amu_trap_activate,
> +};
> +
>  struct id_reg_info {
>         u32     sys_reg;        /* Register ID */
>         u64     sys_val;        /* Sanitized system value */
> @@ -778,6 +835,11 @@ static struct id_reg_info id_aa64pfr0_el1_info = {
>         .init = init_id_aa64pfr0_el1_info,
>         .validate = validate_id_aa64pfr0_el1,
>         .vcpu_mask = vcpu_mask_id_aa64pfr0_el1,
> +       .trap_features = &(const struct feature_config_ctrl *[]) {
> +               &ftr_ctrl_ras,
> +               &ftr_ctrl_amu,
> +               NULL,
> +       },
>  };
>
>  static struct id_reg_info id_aa64pfr1_el1_info = {
> @@ -901,6 +963,18 @@ static inline bool vcpu_feature_is_available(struct kvm_vcpu *vcpu,
>         return feature_avail(ctrl, val);
>  }
>
> +static bool trap_ras_regs(struct kvm_vcpu *vcpu,
> +                         struct sys_reg_params *p,
> +                         const struct sys_reg_desc *r)
> +{
> +       if (!vcpu_feature_is_available(vcpu, &ftr_ctrl_ras)) {
> +               kvm_inject_undefined(vcpu);
> +               return false;
> +       }
> +
> +       return trap_raz_wi(vcpu, p, r);
> +}
> +
>  /*
>   * ARMv8.1 mandates at least a trivial LORegion implementation, where all the
>   * RW registers are RES0 (which we can implement as RAZ/WI). On an ARMv8.0
> @@ -2265,14 +2339,14 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>         { SYS_DESC(SYS_AFSR1_EL1), access_vm_reg, reset_unknown, AFSR1_EL1 },
>         { SYS_DESC(SYS_ESR_EL1), access_vm_reg, reset_unknown, ESR_EL1 },
>
> -       { SYS_DESC(SYS_ERRIDR_EL1), trap_raz_wi },
> -       { SYS_DESC(SYS_ERRSELR_EL1), trap_raz_wi },
> -       { SYS_DESC(SYS_ERXFR_EL1), trap_raz_wi },
> -       { SYS_DESC(SYS_ERXCTLR_EL1), trap_raz_wi },
> -       { SYS_DESC(SYS_ERXSTATUS_EL1), trap_raz_wi },
> -       { SYS_DESC(SYS_ERXADDR_EL1), trap_raz_wi },
> -       { SYS_DESC(SYS_ERXMISC0_EL1), trap_raz_wi },
> -       { SYS_DESC(SYS_ERXMISC1_EL1), trap_raz_wi },
> +       { SYS_DESC(SYS_ERRIDR_EL1), trap_ras_regs },
> +       { SYS_DESC(SYS_ERRSELR_EL1), trap_ras_regs },
> +       { SYS_DESC(SYS_ERXFR_EL1), trap_ras_regs },
> +       { SYS_DESC(SYS_ERXCTLR_EL1), trap_ras_regs },
> +       { SYS_DESC(SYS_ERXSTATUS_EL1), trap_ras_regs },
> +       { SYS_DESC(SYS_ERXADDR_EL1), trap_ras_regs },
> +       { SYS_DESC(SYS_ERXMISC0_EL1), trap_ras_regs },
> +       { SYS_DESC(SYS_ERXMISC1_EL1), trap_ras_regs },
>
>         MTE_REG(TFSR_EL1),
>         MTE_REG(TFSRE0_EL1),
> --
> 2.34.1.448.ga2b2bfdf31-goog
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
