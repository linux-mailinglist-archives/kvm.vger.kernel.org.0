Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3674A59CF92
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 05:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240131AbiHWDj7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 23:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234003AbiHWDj5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 23:39:57 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 589E85AC72;
        Mon, 22 Aug 2022 20:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661225996; x=1692761996;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yvzYmlV0h8A3b8MaJVDQI7eQJR88zPIb6BOXH99svto=;
  b=CFZXvAMIxMtgBVmyz4vss59MjqheiJWRQUDmQqYeC0/KdVjqfDFMim8a
   22+e/BhgRsx88XQ0oguJbOw6wHQUbfy0osjfWZdNn50aCd32u8MUsY0HE
   +4wMIR2oil1iowLYzLtUWQEgda3EtDfoQ8PeYi84Fjz0tGaPG81Q+YtmB
   W8rwd073yBMyA7CpJpsJYjr3hYQmJLlxq8Xz+xXEnibbplO54X0AW47Ii
   4Kf6qkJiuzdkVREUK4CONtZVQ/w+cm/FbsUyw2HkUEYAEuu1JgiOUcaMw
   8XhfGFJnqyQE+CxxJh/kdrCxoGjdeKVo+XQNcOaoNa003y18At+ynsCPe
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="280554364"
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="280554364"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 20:39:55 -0700
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="669839016"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.0.236]) ([10.238.0.236])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 20:39:53 -0700
Message-ID: <651c33a5-4b9b-927f-cb04-ec20b8c3d730@linux.intel.com>
Date:   Tue, 23 Aug 2022 11:39:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH v8 018/103] KVM: TDX: Stub in tdx.h with structs,
 accessors, and VMCS helpers
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <d88e0cee35b70d86493d5a71becffa4ab5c5d97c.1659854790.git.isaku.yamahata@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <d88e0cee35b70d86493d5a71becffa4ab5c5d97c.1659854790.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2022/8/8 6:01, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Stub in kvm_tdx, vcpu_tdx, and their various accessors.  TDX defines
> SEAMCALL APIs to access TDX control structures corresponding to the VMX
> VMCS.  Introduce helper accessors to hide its SEAMCALL ABI details.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/tdx.h | 103 ++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 101 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 2f43db5bbefb..f50d37f3fc9c 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -3,16 +3,29 @@
>   #define __KVM_X86_TDX_H
>   
>   #ifdef CONFIG_INTEL_TDX_HOST
> +
> +#include "tdx_ops.h"
> +
>   int tdx_module_setup(void);
>   
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
> @@ -34,6 +47,92 @@ static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu)
>   {
>   	return container_of(vcpu, struct vcpu_tdx, vcpu);
>   }
> +
> +static __always_inline void tdvps_vmcs_check(u32 field, u8 bits)
> +{
> +	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && (field) & 0x1,
> +			 "Read/Write to TD VMCS *_HIGH fields not supported");
> +
> +	BUILD_BUG_ON(bits != 16 && bits != 32 && bits != 64);
> +
> +	BUILD_BUG_ON_MSG(bits != 64 && __builtin_constant_p(field) &&
> +			 (((field) & 0x6000) == 0x2000 ||
> +			  ((field) & 0x6000) == 0x6000),
> +			 "Invalid TD VMCS access for 64-bit field");

if bits is 64 here, "bits != 64" is false, how could this check for 
"Invalid TD VMCS access for 64-bit field"?


> +	BUILD_BUG_ON_MSG(bits != 32 && __builtin_constant_p(field) &&
> +			 ((field) & 0x6000) == 0x4000,
> +			 "Invalid TD VMCS access for 32-bit field");

ditto


> +	BUILD_BUG_ON_MSG(bits != 16 && __builtin_constant_p(field) &&
> +			 ((field) & 0x6000) == 0x0000,
> +			 "Invalid TD VMCS access for 16-bit field");

ditto


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
> +
> +TDX_BUILD_TDVPS_ACCESSORS(16, VMCS, vmcs);
> +TDX_BUILD_TDVPS_ACCESSORS(32, VMCS, vmcs);
> +TDX_BUILD_TDVPS_ACCESSORS(64, VMCS, vmcs);
> +
> +TDX_BUILD_TDVPS_ACCESSORS(64, STATE_NON_ARCH, state_non_arch);
> +TDX_BUILD_TDVPS_ACCESSORS(8, MANAGEMENT, management);
> +
>   #else
>   static inline int tdx_module_setup(void) { return -ENODEV; };
>   
