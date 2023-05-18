Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15AAB707DFC
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 12:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbjERKZl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 06:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbjERKZj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 06:25:39 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B7F1BDD;
        Thu, 18 May 2023 03:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684405538; x=1715941538;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=24OyC/WH+6pu2Uob3QtLodrvVV7ybxrbmkREJM0utP8=;
  b=lTySKBMqg//zH3wCMqDDsGRfgoerG04FQP1mXWVqQQ4qUolezJr1M0z5
   QW2Vhig3f9aw4Fp1I2NVaYfGgfYWbYYcPvU7ynWyTt0SEr2ZdGFiRWw42
   pVEVBqXWtr+UNkZG0v4dhpF43pzNL42zbk02Edw+i71uAsjoqypLwa4VJ
   VExx6KA1wiCwjAjqSkGIRMiEARyC66vQsZA4ArFrH6Yrq5eQF2jGbusZ6
   4AbAF7SvZVztAAW1UnocptxcIh5zjhheaOcY5DlTjj0eIKj3UtKj4jH2O
   tNhyIF8Br2/ws8kK7kx+KDYCEnECMlP4uDAi/eLfoATVvI5BciDtSeXd6
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="415455820"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="415455820"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 03:25:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="735032349"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="735032349"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.254.211.142]) ([10.254.211.142])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 03:25:33 -0700
Message-ID: <7b90b6c6-9574-eb23-0884-d4ba5fbfb039@intel.com>
Date:   Thu, 18 May 2023 18:25:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.1
Subject: Re: [RFC PATCH v2 08/11] KVM: VMX: Advertise
 MITI_ENUM_RETPOLINE_S_SUPPORT
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org
Cc:     Jiaan Lu <jiaan.lu@intel.com>, Zhang Chen <chen.zhang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20230414062545.270178-1-chao.gao@intel.com>
 <20230414062545.270178-9-chao.gao@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230414062545.270178-9-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/14/2023 2:25 PM, Chao Gao wrote:
> Allow guest to query if the underying VMM understands Retpoline and
> report the statue of Retpoline in suprevisor mode i.e. CPL < 3 via
> MSR_VIRTUAL_MITIGATION_ENUM/CTRL.
> 
> Disable RRSBA behavior by setting RRSBA_DIS_S for guest if guest is
> using retpoline and the processor has the behavior.
> 
> Signed-off-by: Zhang Chen <chen.zhang@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Tested-by: Jiaan Lu <jiaan.lu@intel.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 24 +++++++++++++++++++++---
>   1 file changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 980498c4c30c..25afb4c3e55e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1944,8 +1944,8 @@ static inline bool is_vmx_feature_control_msr_valid(struct vcpu_vmx *vmx,
>   }
>   
>   #define VIRTUAL_ENUMERATION_VALID_BITS	VIRT_ENUM_MITIGATION_CTRL_SUPPORT
> -#define MITI_ENUM_VALID_BITS		0ULL
> -#define MITI_CTRL_VALID_BITS		0ULL
> +#define MITI_ENUM_VALID_BITS		MITI_ENUM_RETPOLINE_S_SUPPORT
> +#define MITI_CTRL_VALID_BITS		MITI_CTRL_RETPOLINE_S_USED
>   
>   static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
>   {
> @@ -2173,7 +2173,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   	struct vmx_uret_msr *msr;
>   	int ret = 0;
>   	u32 msr_index = msr_info->index;
> -	u64 data = msr_info->data, spec_ctrl_mask;
> +	u64 data = msr_info->data, arch_msr = 0, spec_ctrl_mask = 0;

Sugget to make arch_msr and spec_ctrl_mask as local variables of each 
case {} block

>   	u32 index;
>   
>   	switch (msr_index) {
> @@ -2488,6 +2488,24 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		if (data & ~MITI_CTRL_VALID_BITS)
>   			return 1;
>   
> +		if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
> +			rdmsrl(MSR_IA32_ARCH_CAPABILITIES, arch_msr);
> +
> +		if (data & MITI_CTRL_RETPOLINE_S_USED &&
> +		    kvm_cpu_cap_has(X86_FEATURE_RRSBA_CTRL) &&

why kvm_cpu_cap_has() is used here? it means whether KVM supports expose 
this feature to guest. But what we need here is whether host supports 
this feature. Though they might get the same result, we'd better use 
boot_cpu_has() or even read CPUID directly (since cpuid info can be 
changed by clearcpuid magic) to avoid confusion.

> +		    arch_msr & ARCH_CAP_RRSBA)
> +			spec_ctrl_mask |= SPEC_CTRL_RRSBA_DIS_S;
> +
> +		/*
> +		 * Intercept IA32_SPEC_CTRL to disallow guest from changing
> +		 * certain bits.
> +		 */
> +		if (spec_ctrl_mask && !cpu_has_spec_ctrl_virt())
> +			vmx_enable_intercept_for_msr(vcpu, MSR_IA32_SPEC_CTRL, MSR_TYPE_RW);
> +
> +		vmx_set_spec_ctrl_mask(vmx, spec_ctrl_mask);
> +		vmx_set_guest_spec_ctrl(vmx, vmx_get_guest_spec_ctrl(vmx));
> +
>   		vmx->msr_virtual_mitigation_ctrl = data;
>   		break;
>   	default:

