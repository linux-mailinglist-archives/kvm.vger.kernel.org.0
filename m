Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC5250F130
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 08:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245397AbiDZGky (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 02:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245381AbiDZGkw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 02:40:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 113FB1AF06
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 23:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650955064;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nwXPxDM8I41TBNo7OYIaGVi9oAI/U1FWJ8czSlMN4Xc=;
        b=XPqJ6qKQY4AdYbmifrA+VAjQUeSXIqhrB95zLaRJYNAfGJGXHXcwPnshhNKIm/tHvnc4j/
        TeUmgWqjB/kxjlEevs5YWOMy1C+W272lp0OEf96YSkeuIA0Sn4VBNizMKjbXqgRWLqpp2T
        Pqmogkvyy48F24EZK7S3bwY+GXUvTso=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-l4_c60q9NzSd6PZqsl_1VA-1; Tue, 26 Apr 2022 02:37:40 -0400
X-MC-Unique: l4_c60q9NzSd6PZqsl_1VA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E277833942;
        Tue, 26 Apr 2022 06:37:40 +0000 (UTC)
Received: from [10.72.13.230] (ovpn-13-230.pek2.redhat.com [10.72.13.230])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 773BCC4C7A6;
        Tue, 26 Apr 2022 06:37:32 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v6 3/9] KVM: arm64: Add standard hypervisor firmware
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
References: <20220423000328.2103733-1-rananta@google.com>
 <20220423000328.2103733-4-rananta@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <9ac02210-437e-befd-cea5-2bfc57c00ec2@redhat.com>
Date:   Tue, 26 Apr 2022 14:37:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20220423000328.2103733-4-rananta@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/23/22 8:03 AM, Raghavendra Rao Ananta wrote:
> Introduce the firmware register to hold the standard hypervisor
> service calls (owner value 5) as a bitmap. The bitmap represents
> the features that'll be enabled for the guest, as configured by
> the user-space. Currently, this includes support only for
> Paravirtualized time, represented by bit-0.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>   arch/arm64/include/asm/kvm_host.h |  2 ++
>   arch/arm64/include/uapi/asm/kvm.h |  3 +++
>   arch/arm64/kvm/hypercalls.c       | 21 ++++++++++++++++++---
>   include/kvm/arm_hypercalls.h      |  2 ++
>   4 files changed, 25 insertions(+), 3 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index df07f4c10197..27d4b2a7970e 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -105,9 +105,11 @@ struct kvm_arch_memory_slot {
>    * struct kvm_smccc_features: Descriptor the hypercall services exposed to the guests
>    *
>    * @std_bmap: Bitmap of standard secure service calls
> + * @std_hyp_bmap: Bitmap of standard hypervisor service calls
>    */
>   struct kvm_smccc_features {
>   	unsigned long std_bmap;
> +	unsigned long std_hyp_bmap;
>   };
>   
>   struct kvm_arch {
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 0b79d2dc6ffd..9eecc7ee8c14 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -341,6 +341,9 @@ struct kvm_arm_copy_mte_tags {
>   #define KVM_REG_ARM_STD_BMAP			KVM_REG_ARM_FW_FEAT_BMAP_REG(0)
>   #define KVM_REG_ARM_STD_BIT_TRNG_V1_0		0
>   
> +#define KVM_REG_ARM_STD_HYP_BMAP		KVM_REG_ARM_FW_FEAT_BMAP_REG(1)
> +#define KVM_REG_ARM_STD_HYP_BIT_PV_TIME		0
> +
>   /* Device Control API: ARM VGIC */
>   #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
>   #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS	1
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index df55a04d2fe8..f097bebdad39 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -72,8 +72,6 @@ static bool kvm_hvc_call_default_allowed(struct kvm_vcpu *vcpu, u32 func_id)
>   	 */
>   	case ARM_SMCCC_VERSION_FUNC_ID:
>   	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
> -	case ARM_SMCCC_HV_PV_TIME_FEATURES:
> -	case ARM_SMCCC_HV_PV_TIME_ST:
>   	case ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID:
>   	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
>   	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> @@ -95,6 +93,10 @@ static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
>   	case ARM_SMCCC_TRNG_RND64:
>   		return kvm_arm_fw_reg_feat_enabled(&smccc_feat->std_bmap,
>   						KVM_REG_ARM_STD_BIT_TRNG_V1_0);
> +	case ARM_SMCCC_HV_PV_TIME_FEATURES:
> +	case ARM_SMCCC_HV_PV_TIME_ST:
> +		return kvm_arm_fw_reg_feat_enabled(&smccc_feat->std_hyp_bmap,
> +					KVM_REG_ARM_STD_HYP_BIT_PV_TIME);
>   	default:
>   		return kvm_hvc_call_default_allowed(vcpu, func_id);
>   	}
> @@ -102,6 +104,7 @@ static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
>   
>   int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>   {
> +	struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;
>   	u32 func_id = smccc_get_function(vcpu);
>   	u64 val[4] = {SMCCC_RET_NOT_SUPPORTED};
>   	u32 feature;
> @@ -165,7 +168,9 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>   			}
>   			break;
>   		case ARM_SMCCC_HV_PV_TIME_FEATURES:
> -			val[0] = SMCCC_RET_SUCCESS;
> +			if (kvm_arm_fw_reg_feat_enabled(&smccc_feat->std_hyp_bmap,
> +					KVM_REG_ARM_STD_HYP_BIT_PV_TIME))
> +				val[0] = SMCCC_RET_SUCCESS;
>   			break;
>   		}
>   		break;
> @@ -211,6 +216,7 @@ static const u64 kvm_arm_fw_reg_ids[] = {
>   	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
>   	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3,
>   	KVM_REG_ARM_STD_BMAP,
> +	KVM_REG_ARM_STD_HYP_BMAP,
>   };
>   
>   void kvm_arm_init_hypercalls(struct kvm *kvm)
> @@ -218,6 +224,7 @@ void kvm_arm_init_hypercalls(struct kvm *kvm)
>   	struct kvm_smccc_features *smccc_feat = &kvm->arch.smccc_feat;
>   
>   	smccc_feat->std_bmap = KVM_ARM_SMCCC_STD_FEATURES;
> +	smccc_feat->std_hyp_bmap = KVM_ARM_SMCCC_STD_HYP_FEATURES;
>   }
>   
>   int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
> @@ -307,6 +314,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>   	case KVM_REG_ARM_STD_BMAP:
>   		val = READ_ONCE(smccc_feat->std_bmap);
>   		break;
> +	case KVM_REG_ARM_STD_HYP_BMAP:
> +		val = READ_ONCE(smccc_feat->std_hyp_bmap);
> +		break;
>   	default:
>   		return -ENOENT;
>   	}
> @@ -329,6 +339,10 @@ static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
>   		fw_reg_bmap = &smccc_feat->std_bmap;
>   		fw_reg_features = KVM_ARM_SMCCC_STD_FEATURES;
>   		break;
> +	case KVM_REG_ARM_STD_HYP_BMAP:
> +		fw_reg_bmap = &smccc_feat->std_hyp_bmap;
> +		fw_reg_features = KVM_ARM_SMCCC_STD_HYP_FEATURES;
> +		break;
>   	default:
>   		return -ENOENT;
>   	}
> @@ -430,6 +444,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>   
>   		return 0;
>   	case KVM_REG_ARM_STD_BMAP:
> +	case KVM_REG_ARM_STD_HYP_BMAP:
>   		return kvm_arm_set_fw_reg_bmap(vcpu, reg->id, val);
>   	default:
>   		return -ENOENT;
> diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
> index 499b45b607b6..aadd6ae3ab72 100644
> --- a/include/kvm/arm_hypercalls.h
> +++ b/include/kvm/arm_hypercalls.h
> @@ -8,8 +8,10 @@
>   
>   /* Last valid bits of the bitmapped firmware registers */
>   #define KVM_REG_ARM_STD_BMAP_BIT_MAX		0
> +#define KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX	0
>   
>   #define KVM_ARM_SMCCC_STD_FEATURES		GENMASK(KVM_REG_ARM_STD_BMAP_BIT_MAX, 0)
> +#define KVM_ARM_SMCCC_STD_HYP_FEATURES		GENMASK(KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX, 0)
>   
>   int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
>   
> 

