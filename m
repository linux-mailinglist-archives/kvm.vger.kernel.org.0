Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26A8707DD6
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 12:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbjERKQp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 06:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbjERKQQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 06:16:16 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567D21FC2;
        Thu, 18 May 2023 03:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684404953; x=1715940953;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=651g/tYK6T33FduvWLYa9fm38qc9TsF8HlVrANNWZn0=;
  b=ZNy5r8oBdtwIwLCspYCMDlndIRYMvOWVid76Q5ua5wR9ZO/jjE0Kr1TQ
   bo1RtXDS1V8A3dHAnZNx1TG0tPtIGBmwTk+kmz1wKithUErAxmpxy754h
   PLRCa2tBB7q7cduMGsuaATpllDIS/cLSfgVs4geh4DUTZwZijwnpOBwbe
   IUGHH8UZFrvnY0o/LTX6cpRxoTZPe0YgFkRGa3dU1nP+6tzew0YE1SFal
   DJhiu1EGuzBkXVrvuQMIjwEly1yPYGZhq6HyahMwVfRrSykvhsH6hgHZ9
   8Fux8CNxjpcTtYW/2PjKgvWmqoCy1/C4T0XzPq0fql4gMFXf24Fscd7cY
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="352045112"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="352045112"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 03:14:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="814265946"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="814265946"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.254.211.142]) ([10.254.211.142])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 03:14:41 -0700
Message-ID: <3b0f3295-27d7-4c83-e1cf-8494548ecf14@intel.com>
Date:   Thu, 18 May 2023 18:14:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.1
Subject: Re: [RFC PATCH v2 06/11] KVM: x86: Advertise ARCH_CAP_VIRTUAL_ENUM
 support
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
 <20230414062545.270178-7-chao.gao@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230414062545.270178-7-chao.gao@intel.com>
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
> From: Zhang Chen <chen.zhang@intel.com>
> 
> Bit 63 of IA32_ARCH_CAPABILITIES MSR indicates availablility of the
> VIRTUAL_ENUMERATION_MSR (index 0x50000000) that enumerates features like
> e.g., mitigation enumeration which is used for guest to hint VMMs the
> software mitigations in use.
> 
> Advertise ARCH_CAP_VIRTUAL_ENUM support for VMX and emulate read/write
> of the VIRTUAL_ENUMERATION_MSR. Now VIRTUAL_ENUMERATION_MSR is always 0.
> 
> Signed-off-by: Zhang Chen <chen.zhang@intel.com>
> Co-developed-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Tested-by: Jiaan Lu <jiaan.lu@intel.com>
> ---
>   arch/x86/kvm/svm/svm.c |  1 +
>   arch/x86/kvm/vmx/vmx.c | 19 +++++++++++++++++++
>   arch/x86/kvm/vmx/vmx.h |  1 +
>   arch/x86/kvm/x86.c     | 16 +++++++++++++++-
>   4 files changed, 36 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 57f241c5a371..195d0cf9309a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4093,6 +4093,7 @@ static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
>   {
>   	switch (index) {
>   	case MSR_IA32_MCG_EXT_CTL:
> +	case MSR_VIRTUAL_ENUMERATION:
>   	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
>   		return false;
>   	case MSR_IA32_SMBASE:
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9f6919bec2b3..85419137decb 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1943,6 +1943,8 @@ static inline bool is_vmx_feature_control_msr_valid(struct vcpu_vmx *vmx,
>   	return !(msr->data & ~valid_bits);
>   }
>   
> +#define VIRTUAL_ENUMERATION_VALID_BITS	0ULL
> +
>   static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
>   {
>   	switch (msr->index) {
> @@ -1950,6 +1952,9 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
>   		if (!nested)
>   			return 1;
>   		return vmx_get_vmx_msr(&vmcs_config.nested, msr->index, &msr->data);
> +	case MSR_VIRTUAL_ENUMERATION:
> +		msr->data = VIRTUAL_ENUMERATION_VALID_BITS;
> +		return 0;
>   	default:
>   		return KVM_MSR_RET_INVALID;
>   	}
> @@ -2096,6 +2101,12 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   	case MSR_IA32_DEBUGCTLMSR:
>   		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
>   		break;
> +	case MSR_VIRTUAL_ENUMERATION:
> +		if (!msr_info->host_initiated &&
> +		    !(vcpu->arch.arch_capabilities & ARCH_CAP_VIRTUAL_ENUM))
> +			return 1;
> +		msr_info->data = vmx->msr_virtual_enumeration;
> +		break;
>   	default:
>   	find_uret_msr:
>   		msr = vmx_find_uret_msr(vmx, msr_info->index);
> @@ -2437,6 +2448,14 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		}
>   		ret = kvm_set_msr_common(vcpu, msr_info);
>   		break;
> +	case MSR_VIRTUAL_ENUMERATION:
> +		if (!msr_info->host_initiated)
> +			return 1;
> +		if (data & ~VIRTUAL_ENUMERATION_VALID_BITS)
> +			return 1;
> +
> +		vmx->msr_virtual_enumeration = data;
> +		break;
>   
>   	default:
>   	find_uret_msr:
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 021d86b52e18..a7faaf9fdc26 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -292,6 +292,7 @@ struct vcpu_vmx {
>   
>   	u64		      spec_ctrl;
>   	u64		      guest_spec_ctrl;
> +	u64		      msr_virtual_enumeration;
>   	u32		      msr_ia32_umwait_control;
>   
>   	/*
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3c58dbae7b4c..a1bc52bebdcc 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1537,6 +1537,7 @@ static const u32 emulated_msrs_all[] = {
>   
>   	MSR_K7_HWCR,
>   	MSR_KVM_POLL_CONTROL,
> +	MSR_VIRTUAL_ENUMERATION,
>   };
>   
>   static u32 emulated_msrs[ARRAY_SIZE(emulated_msrs_all)];
> @@ -1570,6 +1571,7 @@ static const u32 msr_based_features_all[] = {
>   	MSR_IA32_UCODE_REV,
>   	MSR_IA32_ARCH_CAPABILITIES,
>   	MSR_IA32_PERF_CAPABILITIES,
> +	MSR_VIRTUAL_ENUMERATION,
>   };
>   
>   static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all)];
> @@ -1591,7 +1593,8 @@ static unsigned int num_msr_based_features;
>   	 ARCH_CAP_SKIP_VMENTRY_L1DFLUSH | ARCH_CAP_SSB_NO | ARCH_CAP_MDS_NO | \
>   	 ARCH_CAP_PSCHANGE_MC_NO | ARCH_CAP_TSX_CTRL_MSR | ARCH_CAP_TAA_NO | \
>   	 ARCH_CAP_SBDR_SSDP_NO | ARCH_CAP_FBSDP_NO | ARCH_CAP_PSDP_NO | \
> -	 ARCH_CAP_FB_CLEAR | ARCH_CAP_RRSBA | ARCH_CAP_PBRSB_NO)
> +	 ARCH_CAP_FB_CLEAR | ARCH_CAP_RRSBA | ARCH_CAP_PBRSB_NO | \
> +	 ARCH_CAP_VIRTUAL_ENUM)

We cannot do it.

Otherwise, an AMD L1 with X86_FEATURE_ARCH_CAPABILITIES configured is 
possible to expose MSR_VIRTUAL_ENUMERATION to L2 while no support for it.

>   
>   static u64 kvm_get_arch_capabilities(void)
>   {
> @@ -1610,6 +1613,17 @@ static u64 kvm_get_arch_capabilities(void)
>   	 */
>   	data |= ARCH_CAP_PSCHANGE_MC_NO;
>   
> +	/*
> +	 * Virtual enumeration is a paravirt feature. The only usage for now
> +	 * is to bridge the gap caused by microarchitecture changes between
> +	 * different Intel processors. And its usage is linked to "virtualize
> +	 * IA32_SPEC_CTRL" which is a VMX feature. Whether AMD SVM can benefit
> +	 * from the same usage and how to implement it is still unclear. Limit
> +	 * virtual enumeration to VMX.
> +	 */
> +	if (static_call(kvm_x86_has_emulated_msr)(NULL, MSR_VIRTUAL_ENUMERATION))
> +		data |= ARCH_CAP_VIRTUAL_ENUM;
> +
>   	/*
>   	 * If we're doing cache flushes (either "always" or "cond")
>   	 * we will do one whenever the guest does a vmlaunch/vmresume.

