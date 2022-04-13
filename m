Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8864FEE00
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 05:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbiDMECO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 00:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiDMECN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 00:02:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0AF0549F3E
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 20:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649822390;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/qiTSPilnqb+8HttBSbUgM80usd/Sw8eEZqKgB3SiXI=;
        b=iPQwJ3Yxoqr+VTY7lq5w9k1gM2vku1j5Zawsxv6HbwkzlYnevSfAk83u62kSYV9iR5iKH5
        7h4HLHPYuD17EFZ+a8v+ZiYE35ZG149Cmm81ze0PGckPdJ1IJU2qF9LFFyn0PjlQ+REAly
        dSUuGkxDaJWMO/NP6eRYNR1xHRHZgUc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-4XVIyB8ENPq93URrelPJvQ-1; Tue, 12 Apr 2022 23:59:47 -0400
X-MC-Unique: 4XVIyB8ENPq93URrelPJvQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4664829A9CCB;
        Wed, 13 Apr 2022 03:59:45 +0000 (UTC)
Received: from [10.72.13.171] (ovpn-13-171.pek2.redhat.com [10.72.13.171])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C80B5145BA59;
        Wed, 13 Apr 2022 03:59:38 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v5 04/10] KVM: arm64: Add vendor hypervisor firmware
 register
To:     Raghavendra Rao Ananta <rananta@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
References: <20220407011605.1966778-1-rananta@google.com>
 <20220407011605.1966778-5-rananta@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <06b7539f-c5c0-843d-7617-a35a9f1d0e60@redhat.com>
Date:   Wed, 13 Apr 2022 11:59:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20220407011605.1966778-5-rananta@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghavendra,

On 4/7/22 9:15 AM, Raghavendra Rao Ananta wrote:
> Introduce the firmware register to hold the vendor specific
> hypervisor service calls (owner value 6) as a bitmap. The
> bitmap represents the features that'll be enabled for the
> guest, as configured by the user-space. Currently, this
> includes support for KVM-vendor features, and Precision Time
> Protocol (PTP), represented by bit-0 and bit-1 respectively.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>   arch/arm64/include/asm/kvm_host.h |  2 ++
>   arch/arm64/include/uapi/asm/kvm.h |  4 ++++
>   arch/arm64/kvm/hypercalls.c       | 21 +++++++++++++++++----
>   include/kvm/arm_hypercalls.h      |  4 ++++
>   4 files changed, 27 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 20165242ebd9..b79161bad69a 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -106,10 +106,12 @@ struct kvm_arch_memory_slot {
>    *
>    * @std_bmap: Bitmap of standard secure service calls
>    * @std_hyp_bmap: Bitmap of standard hypervisor service calls
> + * @vendor_hyp_bmap: Bitmap of vendor specific hypervisor service calls
>    */
>   struct kvm_smccc_features {
>   	u64 std_bmap;
>   	u64 std_hyp_bmap;
> +	u64 vendor_hyp_bmap;
>   };
>   
>   struct kvm_arch {
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 67353bf4e69d..9a5ac0ed4113 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -344,6 +344,10 @@ struct kvm_arm_copy_mte_tags {
>   #define KVM_REG_ARM_STD_HYP_BMAP		KVM_REG_ARM_FW_FEAT_BMAP_REG(1)
>   #define KVM_REG_ARM_STD_HYP_BIT_PV_TIME		BIT(0)
>   
> +#define KVM_REG_ARM_VENDOR_HYP_BMAP		KVM_REG_ARM_FW_FEAT_BMAP_REG(2)
> +#define KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT	BIT(0)
> +#define KVM_REG_ARM_VENDOR_HYP_BIT_PTP		BIT(1)
> +
>   /* Device Control API: ARM VGIC */
>   #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
>   #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS	1
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index 64ae6c7e7145..80836c341fd3 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -66,8 +66,6 @@ static const u32 hvc_func_default_allowed_list[] = {
>   	ARM_SMCCC_VERSION_FUNC_ID,
>   	ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
>   	ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID,
> -	ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID,
> -	ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID,
>   };
>   
>   static bool kvm_hvc_call_default_allowed(struct kvm_vcpu *vcpu, u32 func_id)
> @@ -102,6 +100,12 @@ static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
>   	case ARM_SMCCC_HV_PV_TIME_ST:
>   		return kvm_arm_fw_reg_feat_enabled(smccc_feat->std_hyp_bmap,
>   					KVM_REG_ARM_STD_HYP_BIT_PV_TIME);
> +	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> +		return kvm_arm_fw_reg_feat_enabled(smccc_feat->vendor_hyp_bmap,
> +					KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT);
> +	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> +		return kvm_arm_fw_reg_feat_enabled(smccc_feat->vendor_hyp_bmap,
> +					KVM_REG_ARM_VENDOR_HYP_BIT_PTP);
>   	default:
>   		return kvm_hvc_call_default_allowed(vcpu, func_id);
>   	}

I guess we may return SMCCC_RET_NOT_SUPPORTED for ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID
if KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT isn't set? Otherwise, we need explain it
in the commit log.

KVM_REG_ARM_VENDOR_HYP_BIT_{FUNC_FEAT, PTP} aren't parallel to each other.
I think PTP can't be on if KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT is off.

> @@ -194,8 +198,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>   		val[3] = ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3;
>   		break;
>   	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> -		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
> -		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_PTP);
> +		val[0] = smccc_feat->vendor_hyp_bmap;
>   		break;
>   	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
>   		kvm_ptp_get_time(vcpu, val);
> @@ -222,6 +225,7 @@ static const u64 kvm_arm_fw_reg_ids[] = {
>   	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3,
>   	KVM_REG_ARM_STD_BMAP,
>   	KVM_REG_ARM_STD_HYP_BMAP,
> +	KVM_REG_ARM_VENDOR_HYP_BMAP,
>   };
>   
>   void kvm_arm_init_hypercalls(struct kvm *kvm)
> @@ -230,6 +234,7 @@ void kvm_arm_init_hypercalls(struct kvm *kvm)
>   
>   	smccc_feat->std_bmap = KVM_ARM_SMCCC_STD_FEATURES;
>   	smccc_feat->std_hyp_bmap = KVM_ARM_SMCCC_STD_HYP_FEATURES;
> +	smccc_feat->vendor_hyp_bmap = KVM_ARM_SMCCC_VENDOR_HYP_FEATURES;
>   }
>   
>   int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
> @@ -322,6 +327,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>   	case KVM_REG_ARM_STD_HYP_BMAP:
>   		val = READ_ONCE(smccc_feat->std_hyp_bmap);
>   		break;
> +	case KVM_REG_ARM_VENDOR_HYP_BMAP:
> +		val = READ_ONCE(smccc_feat->vendor_hyp_bmap);
> +		break;
>   	default:
>   		return -ENOENT;
>   	}
> @@ -348,6 +356,10 @@ static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
>   		fw_reg_bmap = &smccc_feat->std_hyp_bmap;
>   		fw_reg_features = KVM_ARM_SMCCC_STD_HYP_FEATURES;
>   		break;
> +	case KVM_REG_ARM_VENDOR_HYP_BMAP:
> +		fw_reg_bmap = &smccc_feat->vendor_hyp_bmap;
> +		fw_reg_features = KVM_ARM_SMCCC_VENDOR_HYP_FEATURES;
> +		break;
>   	default:
>   		return -ENOENT;
>   	}

If KVM_REG_ARM_VENDOR_HYP_BIT_{FUNC_FEAT, PTP} aren't parallel to each other,
special code is needed to gurantee PTP is cleared if VENDOR_HYP is disabled.

> @@ -453,6 +465,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>   		return 0;
>   	case KVM_REG_ARM_STD_BMAP:
>   	case KVM_REG_ARM_STD_HYP_BMAP:
> +	case KVM_REG_ARM_VENDOR_HYP_BMAP:
>   		return kvm_arm_set_fw_reg_bmap(vcpu, reg->id, val);
>   	default:
>   		return -ENOENT;
> diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
> index b0915d8c5b81..eaf4f6b318a8 100644
> --- a/include/kvm/arm_hypercalls.h
> +++ b/include/kvm/arm_hypercalls.h
> @@ -9,6 +9,7 @@
>   /* Last valid bits of the bitmapped firmware registers */
>   #define KVM_REG_ARM_STD_BMAP_BIT_MAX		0
>   #define KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX	0
> +#define KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX	1
>   
>   #define KVM_ARM_SMCCC_STD_FEATURES \
>   	GENMASK_ULL(KVM_REG_ARM_STD_BMAP_BIT_MAX, 0)
> @@ -16,6 +17,9 @@
>   #define KVM_ARM_SMCCC_STD_HYP_FEATURES \
>   	GENMASK_ULL(KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX, 0)
>   
> +#define KVM_ARM_SMCCC_VENDOR_HYP_FEATURES \
> +	GENMASK_ULL(KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX, 0)
> +
>   int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
>   
>   static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
> 

Thanks,
Gavin

