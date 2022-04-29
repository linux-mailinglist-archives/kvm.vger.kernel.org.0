Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0115140FE
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 05:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236046AbiD2DYU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 23:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235676AbiD2DYS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 23:24:18 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6D389CC3;
        Thu, 28 Apr 2022 20:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651202460; x=1682738460;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=Ntv4MlFWlw++r1XNowxfCpcex0tbaoL92o8ktxH/k1s=;
  b=iF19R2Zun7qHKnJhUYHL53YcfmUIsik+KQ+biN6dM+EL1K+UIEQAHKK6
   CsWyMpDByJbe50eE7+pWWQvpQLe2SrRyy8cnafjy7MZ1yLFXMGpxyHwMH
   64QZHzUiu4Mf45dWve1vUGKx+opFcl1IpZdid92MBakkwVxzy/nB/TC9u
   /1Sxby8VrVXyim5f9SX/FA3CvodvteQFL30KelgRBLsQ7pOPJGkAjoAYp
   6U00TV9xBbMjfHnPPwq0kweQdU2MXWu8QAfr1LFiZUyPrmBWsOJMhdkC+
   vJMwTyX49tfRelI8wPMwS7lEgRBaoCyDbgbmW7yl4nOZWvQOQIUVjwYYC
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="246429892"
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="246429892"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 20:20:56 -0700
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="560065566"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.249.171.134]) ([10.249.171.134])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 20:20:50 -0700
Message-ID: <63068c6c-ae60-078b-0a9e-70f1dfd8362c@intel.com>
Date:   Fri, 29 Apr 2022 11:20:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v10 07/16] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_CTL for
 guest Arch LBR
Content-Language: en-US
To:     "Liang, Kan" <kan.liang@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220422075509.353942-1-weijiang.yang@intel.com>
 <20220422075509.353942-8-weijiang.yang@intel.com>
 <bc3b3f6c-8d68-ffc1-cb6e-604d84797da1@linux.intel.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <bc3b3f6c-8d68-ffc1-cb6e-604d84797da1@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/28/2022 10:16 PM, Liang, Kan wrote:
>
> On 4/22/2022 3:55 AM, Yang Weijiang wrote:
>> From: Like Xu <like.xu@linux.intel.com>
>>
>> Arch LBR is enabled by setting MSR_ARCH_LBR_CTL.LBREn to 1. A new guest
>> state field named "Guest IA32_LBR_CTL" is added to enhance guest LBR usage.
>> When guest Arch LBR is enabled, a guest LBR event will be created like the
>> model-specific LBR does. Clear guest LBR enable bit on host PMI handling so
>> guest can see expected config.
>>
>> On processors that support Arch LBR, MSR_IA32_DEBUGCTLMSR[bit 0] has no
>> meaning. It can be written to 0 or 1, but reads will always return 0.
>> Like IA32_DEBUGCTL, IA32_ARCH_LBR_CTL msr is also preserved on INIT.
>>
>> Regardless of the Arch LBR or legacy LBR, when the LBR_EN bit 0 of the
>> corresponding control MSR is set to 1, LBR recording will be enabled.
>>
>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>> Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>    arch/x86/events/intel/lbr.c      |  2 --
>>    arch/x86/include/asm/msr-index.h |  1 +
>>    arch/x86/include/asm/vmx.h       |  2 ++
>>    arch/x86/kvm/vmx/pmu_intel.c     | 58 +++++++++++++++++++++++++++++---
>>    arch/x86/kvm/vmx/vmx.c           | 12 +++++++
>>    5 files changed, 68 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
>> index 4529ce448b2e..4fe6c3b50fc3 100644
>> --- a/arch/x86/events/intel/lbr.c
>> +++ b/arch/x86/events/intel/lbr.c
>> @@ -160,8 +160,6 @@ enum {
>>    	 ARCH_LBR_RETURN		|\
>>    	 ARCH_LBR_OTHER_BRANCH)
>>    
>> -#define ARCH_LBR_CTL_MASK			0x7f000e
>> -
>>    static void intel_pmu_lbr_filter(struct cpu_hw_events *cpuc);
>>    
>>    static __always_inline bool is_lbr_call_stack_bit_set(u64 config)
>> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
>> index 0eb90d21049e..60e0ab108dc0 100644
>> --- a/arch/x86/include/asm/msr-index.h
>> +++ b/arch/x86/include/asm/msr-index.h
>> @@ -169,6 +169,7 @@
>>    #define LBR_INFO_BR_TYPE		(0xfull << LBR_INFO_BR_TYPE_OFFSET)
>>    
>>    #define MSR_ARCH_LBR_CTL		0x000014ce
>> +#define ARCH_LBR_CTL_MASK		0x7f000e
>>    #define ARCH_LBR_CTL_LBREN		BIT(0)
>>    #define ARCH_LBR_CTL_CPL_OFFSET		1
>>    #define ARCH_LBR_CTL_CPL		(0x3ull << ARCH_LBR_CTL_CPL_OFFSET)
>> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
>> index 0ffaa3156a4e..ea3be961cc8e 100644
>> --- a/arch/x86/include/asm/vmx.h
>> +++ b/arch/x86/include/asm/vmx.h
>> @@ -245,6 +245,8 @@ enum vmcs_field {
>>    	GUEST_BNDCFGS_HIGH              = 0x00002813,
>>    	GUEST_IA32_RTIT_CTL		= 0x00002814,
>>    	GUEST_IA32_RTIT_CTL_HIGH	= 0x00002815,
>> +	GUEST_IA32_LBR_CTL		= 0x00002816,
>> +	GUEST_IA32_LBR_CTL_HIGH		= 0x00002817,
>>    	HOST_IA32_PAT			= 0x00002c00,
>>    	HOST_IA32_PAT_HIGH		= 0x00002c01,
>>    	HOST_IA32_EFER			= 0x00002c02,
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index c8e6c1e1e00c..7dc8a5783df7 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -19,6 +19,7 @@
>>    #include "pmu.h"
>>    
>>    #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
>> +#define KVM_ARCH_LBR_CTL_MASK  (ARCH_LBR_CTL_MASK | ARCH_LBR_CTL_LBREN)
>>    
>>    static struct kvm_event_hw_type_mapping intel_arch_events[] = {
>>    	[0] = { 0x3c, 0x00, PERF_COUNT_HW_CPU_CYCLES },
>> @@ -215,6 +216,7 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
>>    		ret = pmu->version > 1;
>>    		break;
>>    	case MSR_ARCH_LBR_DEPTH:
>> +	case MSR_ARCH_LBR_CTL:
>>    		if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
>>    			ret = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
>>    		break;
>> @@ -361,6 +363,35 @@ static bool arch_lbr_depth_is_valid(struct kvm_vcpu *vcpu, u64 depth)
>>    	return (depth == pmu->kvm_arch_lbr_depth);
>>    }
>>    
>> +#define ARCH_LBR_CTL_BRN_MASK   GENMASK_ULL(22, 16)
>> +
>> +static bool arch_lbr_ctl_is_valid(struct kvm_vcpu *vcpu, u64 ctl)
>> +{
>> +	struct kvm_cpuid_entry2 *entry;
>> +
>> +	if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
>> +		return false;
>> +
>> +	if (ctl & ~KVM_ARCH_LBR_CTL_MASK)
>> +		goto warn;
>> +
>> +	entry = kvm_find_cpuid_entry(vcpu, 0x1c, 0);
>> +	if (!entry)
>> +		return false;
>> +
>> +	if (!(entry->ebx & BIT(0)) && (ctl & ARCH_LBR_CTL_CPL))
>> +		return false;
>> +	if (!(entry->ebx & BIT(2)) && (ctl & ARCH_LBR_CTL_STACK))
>> +		return false;
>> +	if (!(entry->ebx & BIT(1)) && (ctl & ARCH_LBR_CTL_BRN_MASK))
> Why KVM wants to define this mask by itself? Cannot we use the
> ARCH_LBR_CTL_FILTER?

Thanks Ken for review!

Sounds like the ISE has been updated, per section "CPUID for Ach LBRs":

EBX 1 Branch Filtering Supported If set, the processor supports setting 
IA32_LBR_CTL[22:16] to non-zero value.

but the FILTER definition looks like:

#define ARCH_LBR_CTL_FILTER_OFFSET      16

#define ARCH_LBR_CTL_FILTER             (0x7full << 
ARCH_LBR_CTL_FILTER_OFFSET)

Maybe I need to update the FILTER and re-use it.

>
> Thanks,
> Kan
>
>> +		return false;
>> +	return true;
>> +warn:
>> +	pr_warn_ratelimited("kvm: vcpu-%d: invalid arch lbr ctl.\n",
>> +			    vcpu->vcpu_id);
>> +	return false;
>> +}
>> +
>>    static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>    {
>>    	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>> @@ -384,6 +415,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>    	case MSR_ARCH_LBR_DEPTH:
>>    		msr_info->data = lbr_desc->records.nr;
>>    		return 0;
>> +	case MSR_ARCH_LBR_CTL:
>> +		msr_info->data = vmcs_read64(GUEST_IA32_LBR_CTL);
>> +		return 0;
>>    	default:
>>    		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>>    		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
>> @@ -455,6 +489,16 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>    		 */
>>    		wrmsrl(MSR_ARCH_LBR_DEPTH, lbr_desc->records.nr);
>>    		return 0;
>> +	case MSR_ARCH_LBR_CTL:
>> +		if (!arch_lbr_ctl_is_valid(vcpu, data))
>> +			break;
>> +
>> +		vmcs_write64(GUEST_IA32_LBR_CTL, data);
>> +
>> +		if (intel_pmu_lbr_is_enabled(vcpu) && !lbr_desc->event &&
>> +		    (data & ARCH_LBR_CTL_LBREN))
>> +			intel_pmu_create_guest_lbr_event(vcpu);
>> +		return 0;
>>    	default:
>>    		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>>    		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
>> @@ -668,12 +712,16 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
>>     */
>>    static void intel_pmu_legacy_freezing_lbrs_on_pmi(struct kvm_vcpu *vcpu)
>>    {
>> -	u64 data = vmcs_read64(GUEST_IA32_DEBUGCTL);
>> +	u32 lbr_ctl_field = GUEST_IA32_DEBUGCTL;
>>    
>> -	if (data & DEBUGCTLMSR_FREEZE_LBRS_ON_PMI) {
>> -		data &= ~DEBUGCTLMSR_LBR;
>> -		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
>> -	}
>> +	if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_FREEZE_LBRS_ON_PMI))
>> +		return;
>> +
>> +	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
>> +	    guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
>> +		lbr_ctl_field = GUEST_IA32_LBR_CTL;
>> +
>> +	vmcs_write64(lbr_ctl_field, vmcs_read64(lbr_ctl_field) & ~0x1ULL);
>>    }
>>    
>>    static void intel_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 04d170c4b61e..73961fcfb62d 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -2022,6 +2022,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>    						VM_EXIT_SAVE_DEBUG_CONTROLS)
>>    			get_vmcs12(vcpu)->guest_ia32_debugctl = data;
>>    
>> +		/*
>> +		 * For Arch LBR, IA32_DEBUGCTL[bit 0] has no meaning.
>> +		 * It can be written to 0 or 1, but reads will always return 0.
>> +		 */
>> +		if (guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
>> +			data &= ~DEBUGCTLMSR_LBR;
>> +
>>    		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
>>    		if (intel_pmu_lbr_is_enabled(vcpu) && !to_vmx(vcpu)->lbr_desc.event &&
>>    		    (data & DEBUGCTLMSR_LBR))
>> @@ -4548,6 +4555,11 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>    	kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
>>    
>>    	vpid_sync_context(vmx->vpid);
>> +
>> +	if (!init_event) {
>> +		if (static_cpu_has(X86_FEATURE_ARCH_LBR))
>> +			vmcs_write64(GUEST_IA32_LBR_CTL, 0);
>> +	}
>>    }
>>    
>>    static void vmx_enable_irq_window(struct kvm_vcpu *vcpu)
