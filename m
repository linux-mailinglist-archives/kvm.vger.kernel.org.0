Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01A550D963
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 08:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238998AbiDYG0C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 02:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbiDYGZy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 02:25:54 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A22440E43
        for <kvm@vger.kernel.org>; Sun, 24 Apr 2022 23:22:51 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id e15-20020a9d63cf000000b006054e65aaecso10166763otl.0
        for <kvm@vger.kernel.org>; Sun, 24 Apr 2022 23:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZcXMvreojsCQW2V+Q7kqKm5McoJxlL/FAyGsUU3wai8=;
        b=LZZM0dIU0/e0VrjVUq0OmIiCB15M4oU/CVsRvxyC25hxvFBKX6RyuAPggfbHrZzpBf
         io7WmzcHu2czvAFU9ZTsBcET3aK5wPDShnqrHtgvNeuZAnvRFd+FMLN6uHoXyVc5ph0O
         q2TgeHqar+d+Dd8/TGsxyX5/8nRmAyw/p+QAnvohhUOZKS28g5gJpSHE/On1ertMmMaq
         JHTpnE4f/5G+TM84B7F1EM1EPYYw4cYlNGIdUpWPwgxYRzqkf4ahtXp3uJAkwXE4GCb/
         RZ2lIVhnP4cf5hjZAFHVB32CkBA4cXteJDDmrCsPQgUfUOkIhPYsF2tByIIP+wK0y9aN
         G7mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZcXMvreojsCQW2V+Q7kqKm5McoJxlL/FAyGsUU3wai8=;
        b=wkdyzEK3Z2zZ0rgqV8A4D9533veHJqCQ6wZXsenmg3ceGJ8DjvkuQzcj8gPBFUVA5H
         MYbBr1YVwKwH0ILKLlw2EeTKNenc3WYDpW6tUAuQ59+IPRdmEM8Vcm4O5j80N49B3Bq0
         ZF9b6VhKJ/oHrEN9tKT/NxqSVizZQe3Doo4eKbEGuYBIuc1tPJBUpDWZ+c9f+Uo5Iqh2
         jiILVkLq8V2DC7/2hzbFoYSZcji/H5/lLUqkOFMXWIz/MupMC5NeCc2Uizh48fj22x2m
         EpqewXFCn//SQCC8t42G05WH9tCE1dKymAGn2VVXiHypHY64o4CJioUTV3feqOa9eDzj
         Hvog==
X-Gm-Message-State: AOAM533ETltDFwgJvcs4Tc0ies+BXzyikSlEhOppvLwVmLclhVc2Q882
        Co8atxxOFEMV0+j2yOqZITA1Rd60JdPiPzV23PBs7g==
X-Google-Smtp-Source: ABdhPJyMhysmmQ9anpHr3haivBSW1NNMCFb4RAt7KO7BSOw1fpWNwwjnfFBjy+1OmfDUfTbZ4JBOhM9IjmKxuV0Y440=
X-Received: by 2002:a05:6830:18d:b0:605:4cfb:19cd with SMTP id
 q13-20020a056830018d00b006054cfb19cdmr5773806ota.177.1650867770178; Sun, 24
 Apr 2022 23:22:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220423000328.2103733-1-rananta@google.com> <20220423000328.2103733-5-rananta@google.com>
In-Reply-To: <20220423000328.2103733-5-rananta@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Sun, 24 Apr 2022 23:22:34 -0700
Message-ID: <CAAeT=Fyc3=uoOdeXrLKfYxKtL3PFV0U_Bwj_g+bca_Em63wGhw@mail.gmail.com>
Subject: Re: [PATCH v6 4/9] KVM: arm64: Add vendor hypervisor firmware register
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
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

Hi Raghu,

On Fri, Apr 22, 2022 at 5:03 PM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> Introduce the firmware register to hold the vendor specific
> hypervisor service calls (owner value 6) as a bitmap. The
> bitmap represents the features that'll be enabled for the
> guest, as configured by the user-space. Currently, this
> includes support for KVM-vendor features along with
> reading the UID, represented by bit-0, and Precision Time
> Protocol (PTP), represented by bit-1.
>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  2 ++
>  arch/arm64/include/uapi/asm/kvm.h |  4 ++++
>  arch/arm64/kvm/hypercalls.c       | 23 ++++++++++++++++++-----
>  include/kvm/arm_hypercalls.h      |  2 ++
>  4 files changed, 26 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 27d4b2a7970e..a025c2ba012a 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -106,10 +106,12 @@ struct kvm_arch_memory_slot {
>   *
>   * @std_bmap: Bitmap of standard secure service calls
>   * @std_hyp_bmap: Bitmap of standard hypervisor service calls
> + * @vendor_hyp_bmap: Bitmap of vendor specific hypervisor service calls
>   */
>  struct kvm_smccc_features {
>         unsigned long std_bmap;
>         unsigned long std_hyp_bmap;
> +       unsigned long vendor_hyp_bmap;
>  };
>
>  struct kvm_arch {
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 9eecc7ee8c14..e7d5ae222684 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -344,6 +344,10 @@ struct kvm_arm_copy_mte_tags {
>  #define KVM_REG_ARM_STD_HYP_BMAP               KVM_REG_ARM_FW_FEAT_BMAP_REG(1)
>  #define KVM_REG_ARM_STD_HYP_BIT_PV_TIME                0
>
> +#define KVM_REG_ARM_VENDOR_HYP_BMAP            KVM_REG_ARM_FW_FEAT_BMAP_REG(2)
> +#define KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT   0
> +#define KVM_REG_ARM_VENDOR_HYP_BIT_PTP         1
> +
>  /* Device Control API: ARM VGIC */
>  #define KVM_DEV_ARM_VGIC_GRP_ADDR      0
>  #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS 1
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index f097bebdad39..76e626d0e699 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -72,9 +72,6 @@ static bool kvm_hvc_call_default_allowed(struct kvm_vcpu *vcpu, u32 func_id)
>          */
>         case ARM_SMCCC_VERSION_FUNC_ID:
>         case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
> -       case ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID:
> -       case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> -       case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
>                 return true;
>         default:
>                 return kvm_psci_func_id_is_valid(vcpu, func_id);
> @@ -97,6 +94,13 @@ static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
>         case ARM_SMCCC_HV_PV_TIME_ST:
>                 return kvm_arm_fw_reg_feat_enabled(&smccc_feat->std_hyp_bmap,
>                                         KVM_REG_ARM_STD_HYP_BIT_PV_TIME);
> +       case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> +       case ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID:
> +               return kvm_arm_fw_reg_feat_enabled(&smccc_feat->vendor_hyp_bmap,
> +                                       KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT);
> +       case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> +               return kvm_arm_fw_reg_feat_enabled(&smccc_feat->vendor_hyp_bmap,
> +                                       KVM_REG_ARM_VENDOR_HYP_BIT_PTP);
>         default:
>                 return kvm_hvc_call_default_allowed(vcpu, func_id);
>         }
> @@ -189,8 +193,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>                 val[3] = ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3;
>                 break;
>         case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> -               val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
> -               val[0] |= BIT(ARM_SMCCC_KVM_FUNC_PTP);
> +               val[0] = smccc_feat->vendor_hyp_bmap;
>                 break;
>         case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
>                 kvm_ptp_get_time(vcpu, val);
> @@ -217,6 +220,7 @@ static const u64 kvm_arm_fw_reg_ids[] = {
>         KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3,
>         KVM_REG_ARM_STD_BMAP,
>         KVM_REG_ARM_STD_HYP_BMAP,
> +       KVM_REG_ARM_VENDOR_HYP_BMAP,
>  };
>
>  void kvm_arm_init_hypercalls(struct kvm *kvm)
> @@ -225,6 +229,7 @@ void kvm_arm_init_hypercalls(struct kvm *kvm)
>
>         smccc_feat->std_bmap = KVM_ARM_SMCCC_STD_FEATURES;
>         smccc_feat->std_hyp_bmap = KVM_ARM_SMCCC_STD_HYP_FEATURES;
> +       smccc_feat->vendor_hyp_bmap = KVM_ARM_SMCCC_VENDOR_HYP_FEATURES;
>  }
>
>  int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
> @@ -317,6 +322,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>         case KVM_REG_ARM_STD_HYP_BMAP:
>                 val = READ_ONCE(smccc_feat->std_hyp_bmap);
>                 break;
> +       case KVM_REG_ARM_VENDOR_HYP_BMAP:
> +               val = READ_ONCE(smccc_feat->vendor_hyp_bmap);
> +               break;
>         default:
>                 return -ENOENT;
>         }
> @@ -343,6 +351,10 @@ static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
>                 fw_reg_bmap = &smccc_feat->std_hyp_bmap;
>                 fw_reg_features = KVM_ARM_SMCCC_STD_HYP_FEATURES;
>                 break;
> +       case KVM_REG_ARM_VENDOR_HYP_BMAP:
> +               fw_reg_bmap = &smccc_feat->vendor_hyp_bmap;
> +               fw_reg_features = KVM_ARM_SMCCC_VENDOR_HYP_FEATURES;
> +               break;
>         default:
>                 return -ENOENT;
>         }
> @@ -445,6 +457,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>                 return 0;
>         case KVM_REG_ARM_STD_BMAP:
>         case KVM_REG_ARM_STD_HYP_BMAP:
> +       case KVM_REG_ARM_VENDOR_HYP_BMAP:
>                 return kvm_arm_set_fw_reg_bmap(vcpu, reg->id, val);
>         default:
>                 return -ENOENT;
> diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
> index aadd6ae3ab72..4ebfdd26e486 100644
> --- a/include/kvm/arm_hypercalls.h
> +++ b/include/kvm/arm_hypercalls.h
> @@ -9,9 +9,11 @@
>  /* Last valid bits of the bitmapped firmware registers */
>  #define KVM_REG_ARM_STD_BMAP_BIT_MAX           0
>  #define KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX       0
> +#define KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX    1

Nit: IMHO perhaps it might be more convenient to define the MAX macro
in arch/arm64/include/uapi/asm/kvm.h like below for maintenance ?
(The same comments are applied to other KVM_REG_ARM_*_BMAP_BIT_MAX)

#define KVM_REG_ARM_VENDOR_HYP_BIT_MAX KVM_REG_ARM_VENDOR_HYP_BIT_PTP

Thanks,
Reiji


>
>  #define KVM_ARM_SMCCC_STD_FEATURES             GENMASK(KVM_REG_ARM_STD_BMAP_BIT_MAX, 0)
>  #define KVM_ARM_SMCCC_STD_HYP_FEATURES         GENMASK(KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX, 0)
> +#define KVM_ARM_SMCCC_VENDOR_HYP_FEATURES      GENMASK(KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX, 0)
>
>  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
>
> --
> 2.36.0.rc2.479.g8af0fa9b8e-goog
>
