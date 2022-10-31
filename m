Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E34C6134A2
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 12:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbiJaLjz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 07:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbiJaLjw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 07:39:52 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA456E0A1;
        Mon, 31 Oct 2022 04:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667216391; x=1698752391;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Z1DISDG3lFnXlT+QMl/xIitOF4FDYmEw68146wJjXWA=;
  b=PkQfGTpJGqq94Ul++EQRCl0z0hECK5Qw3ssWrEdZjL9m9TSpgsnB04xI
   8k2HljyFZP2YQNj7+GEuyc/Z7FujrNIrcwQBo+Uiet/x72+tVDOsnYChE
   8Getadp1COvksFLhcgBWZjzM0fOhHLuQPJUIQL1fuzNJEt3fUhTXsdsgk
   Ai+tIYoqv6IzCUFQ5OF+fxCEF6GZv4XnFFAZSEK3W0UOvEcQGZe8V824n
   0rsrQbx2hsIy2au1UuCF2aL6G34a/kKIrDuYbnO3SMOR5L1X5ZR5T37e7
   rsRqao+BAGBjEiGnYHVUW4OlA8rrZ7cMQu5ruIS+nQdQWjznstCyLeNri
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10516"; a="373088367"
X-IronPort-AV: E=Sophos;i="5.95,227,1661842800"; 
   d="scan'208";a="373088367"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2022 04:39:51 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10516"; a="611461271"
X-IronPort-AV: E=Sophos;i="5.95,227,1661842800"; 
   d="scan'208";a="611461271"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.255.28.35]) ([10.255.28.35])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2022 04:39:48 -0700
Message-ID: <e1cb3dd0-796b-73d5-ddb8-38e807c061df@linux.intel.com>
Date:   Mon, 31 Oct 2022 19:39:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v10 014/108] KVM: TDX: Stub in tdx.h with structs,
 accessors, and VMCS helpers
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <75ac959fddbfd057d3ae8ad73e91708a2da60965.1667110240.git.isaku.yamahata@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <75ac959fddbfd057d3ae8ad73e91708a2da60965.1667110240.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2022/10/30 14:22, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Stub in kvm_tdx, vcpu_tdx, and their various accessors.  TDX defines
> SEAMCALL APIs to access TDX control structures corresponding to the VMX
> VMCS.  Introduce helper accessors to hide its SEAMCALL ABI details.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/tdx.h | 118 ++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 116 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 473013265bd8..98999bf3f188 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -3,14 +3,27 @@
>   #define __KVM_X86_TDX_H
>   
>   #ifdef CONFIG_INTEL_TDX_HOST
> +
> +#include "tdx_ops.h"
> +
> +struct tdx_td_page {
> +	unsigned long va;
> +	hpa_t pa;
> +	bool added;
> +};
> +
>   struct kvm_tdx {
>   	struct kvm kvm;
> -	/* TDX specific members follow. */
> +
> +	struct tdx_td_page tdr;
> +	struct tdx_td_page *tdcs;
>   };
>   
>   struct vcpu_tdx {
>   	struct kvm_vcpu	vcpu;
> -	/* TDX specific members follow. */
> +
> +	struct tdx_td_page tdvpr;
> +	struct tdx_td_page *tdvpx;
>   };
>   
>   static inline bool is_td(struct kvm *kvm)
> @@ -32,6 +45,107 @@ static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu)
>   {
>   	return container_of(vcpu, struct vcpu_tdx, vcpu);
>   }
> +
> +static __always_inline void tdvps_vmcs_check(u32 field, u8 bits)
> +{
> +#define VMCS_ENC_ACCESS_TYPE_MASK	0x1UL
> +#define VMCS_ENC_ACCESS_TYPE_FULL	0x0UL
> +#define VMCS_ENC_ACCESS_TYPE_HIGH	0x1UL
> +#define VMCS_ENC_ACCESS_TYPE(field)	((field) & VMCS_ENC_ACCESS_TYPE_MASK)
> +
> +	/* TDX is 64bit only.  HIGH field isn't supported. */
> +	BUILD_BUG_ON_MSG(__builtin_constant_p(field) &&
> +			 VMCS_ENC_ACCESS_TYPE(field) == VMCS_ENC_ACCESS_TYPE_HIGH,
> +			 "Read/Write to TD VMCS *_HIGH fields not supported");
> +
> +	BUILD_BUG_ON(bits != 16 && bits != 32 && bits != 64);
> +
> +#define VMCS_ENC_WIDTH_MASK	GENMASK(14, 13)
> +#define VMCS_ENC_WIDTH_16BIT	(0UL << 13)
> +#define VMCS_ENC_WIDTH_64BIT	(1UL << 13)
> +#define VMCS_ENC_WIDTH_32BIT	(2UL << 13)
> +#define VMCS_ENC_WIDTH_NATURAL	(3UL << 13)
> +#define VMCS_ENC_WIDTH(field)	((field) & VMCS_ENC_WIDTH_MASK)
> +
> +	/* TDX is 64bit only.  i.e. natural width = 64bit. */
> +	BUILD_BUG_ON_MSG(bits != 64 && __builtin_constant_p(field) &&
> +			 (VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_64BIT ||
> +			  VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_NATURAL),
> +			 "Invalid TD VMCS access for 64-bit field");
> +	BUILD_BUG_ON_MSG(bits != 32 && __builtin_constant_p(field) &&
> +			 VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_32BIT,
> +			 "Invalid TD VMCS access for 32-bit field");
> +	BUILD_BUG_ON_MSG(bits != 16 && __builtin_constant_p(field) &&
> +			 VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_16BIT,
> +			 "Invalid TD VMCS access for 16-bit field");
> +}
> +
> +static __always_inline void tdvps_state_non_arch_check(u64 field, u8 bits) {}
> +static __always_inline void tdvps_management_check(u64 field, u8 bits) {}
> +
> +#define TDX_BUILD_TDVPS_ACCESSORS(bits, uclass, lclass)				\
> +static __always_inline u##bits td_##lclass##_read##bits(struct vcpu_tdx *tdx,	\
> +							u32 field)		\
> +{										\
> +	struct tdx_module_output out;						\
> +	u64 err;								\
> +										\
> +	tdvps_##lclass##_check(field, bits);					\
> +	err = tdh_vp_rd(tdx->tdvpr.pa, TDVPS_##uclass(field), &out);		\
> +	if (unlikely(err)) {							\
> +		pr_err("TDH_VP_RD["#uclass".0x%x] failed: 0x%llx\n",		\
> +		       field, err);						\
> +		return 0;							\
> +	}									\
> +	return (u##bits)out.r8;							\
> +}										\
> +static __always_inline void td_##lclass##_write##bits(struct vcpu_tdx *tdx,	\
> +						      u32 field, u##bits val)	\
> +{										\
> +	struct tdx_module_output out;						\
> +	u64 err;								\
> +										\
> +	tdvps_##lclass##_check(field, bits);					\
> +	err = tdh_vp_wr(tdx->tdvpr.pa, TDVPS_##uclass(field), val,		\
> +		      GENMASK_ULL(bits - 1, 0), &out);				\
> +	if (unlikely(err))							\
> +		pr_err("TDH_VP_WR["#uclass".0x%x] = 0x%llx failed: 0x%llx\n",	\
> +		       field, (u64)val, err);					\
> +}										\
> +static __always_inline void td_##lclass##_setbit##bits(struct vcpu_tdx *tdx,	\
> +						       u32 field, u64 bit)	\
> +{										\
> +	struct tdx_module_output out;						\
> +	u64 err;								\
> +										\
> +	tdvps_##lclass##_check(field, bits);					\
> +	err = tdh_vp_wr(tdx->tdvpr.pa, TDVPS_##uclass(field), bit, bit,		\
> +			&out);							\
> +	if (unlikely(err))							\
> +		pr_err("TDH_VP_WR["#uclass".0x%x] |= 0x%llx failed: 0x%llx\n",	\
> +		       field, bit, err);					\
> +}										\
> +static __always_inline void td_##lclass##_clearbit##bits(struct vcpu_tdx *tdx,	\
> +							 u32 field, u64 bit)	\
> +{										\
> +	struct tdx_module_output out;						\
> +	u64 err;								\
> +										\
> +	tdvps_##lclass##_check(field, bits);					\
> +	err = tdh_vp_wr(tdx->tdvpr.pa, TDVPS_##uclass(field), 0, bit,		\
> +			&out);							\
> +	if (unlikely(err))							\
> +		pr_err("TDH_VP_WR["#uclass".0x%x] &= ~0x%llx failed: 0x%llx\n",	\
> +		       field, bit,  err);					\
> +}

For the set of accessors, although there will be kernel errer message 
when tdh_vp_{rd,wr} fails,
the caller doesn't know these function calls succeed or not. Won't this 
cause any unexpected
behavior?


> +
> +TDX_BUILD_TDVPS_ACCESSORS(16, VMCS, vmcs);
> +TDX_BUILD_TDVPS_ACCESSORS(32, VMCS, vmcs);
> +TDX_BUILD_TDVPS_ACCESSORS(64, VMCS, vmcs);
> +
> +TDX_BUILD_TDVPS_ACCESSORS(64, STATE_NON_ARCH, state_non_arch);
> +TDX_BUILD_TDVPS_ACCESSORS(8, MANAGEMENT, management);
> +
>   #else
>   struct kvm_tdx {
>   	struct kvm kvm;
