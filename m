Return-Path: <kvm+bounces-57285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F494B52B25
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 10:05:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 20C6F16B021
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 08:05:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 886822D594F;
	Thu, 11 Sep 2025 08:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GdFsbzd8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8C02D29BF;
	Thu, 11 Sep 2025 08:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757577933; cv=none; b=oeidedLVKLSnPG6bplHc6++2Udq5Jj3bfflHVS+l+xPSA8G/rtZhYLJdZCTXWwlNiiAT6Y+dzMCfkIuSrsUvuofJvVsRWDvlRbxXUJ+iAa2V6DWchb4TFTxf3CRlsVnCsfJQmsh33kPnS/RE/xAJHmEsMnBVTtaBNvyUH4p3NeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757577933; c=relaxed/simple;
	bh=IuyXmFfyNmVFfYy0X6AvB4CsaM/2s6wLUM8k5vXFo8c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BZGcMxvM+/s+nFV0+lNW2oERIXWBEQ5VdmaqYAtm4MI7Sq8RXJs1CigTdgHCbRe3MDrXpuNev81UZ8zPeNyuCxlEDHJNJklFuojWTCEYtPOYUBx963y8GSC0p62+08Jj4h7MzKRVzhzLihEZCmc3SJoO8unS09IGXc8w+Obfl+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GdFsbzd8; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757577932; x=1789113932;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IuyXmFfyNmVFfYy0X6AvB4CsaM/2s6wLUM8k5vXFo8c=;
  b=GdFsbzd8YxqfJRCvAq6QkfONpZFsYUX2/mrrxPay2ALeuLPKR4Qnw71z
   4UuS1TZqFnJ0Cz5HbDFVrqWJi4/WPHIZpmx/FKrGYnl8f0CSMBMiCc0v8
   UFsTVE/MZsLx3aGF2ntr+WD+3AvXVIOgYLFVsZqT89Ck96Lx2+PCxbBd7
   TlD8OEL7+yjnL8+ZTWOzo5lgkGNjDkI0EMralPfUwT4fO4WfKcPTUTOSc
   wjmG4IbJZtbydbn+uQAUX7nIlEyxVsL7I/4aFsLxqAhfNOhAIwIOH4yf1
   KjfPgftCRJ2vymf07O2/WbLvWip/ZkRkjrVS6CXCdBgondfcK4GiGUldn
   Q==;
X-CSE-ConnectionGUID: GuqmpCG1Svyb6cPxBVeiMA==
X-CSE-MsgGUID: 14ipyfPNTYCzPw8RRd9BOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11549"; a="59976314"
X-IronPort-AV: E=Sophos;i="6.18,256,1751266800"; 
   d="scan'208";a="59976314"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 01:05:31 -0700
X-CSE-ConnectionGUID: jbhKYp7IS9yFtbeuXx+7xQ==
X-CSE-MsgGUID: 1EhbMNRFSmuKGBmNnDju/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,256,1751266800"; 
   d="scan'208";a="177963143"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 01:05:26 -0700
Message-ID: <bd2999b5-f2fc-4d86-a5c8-0d1af4d51bc0@intel.com>
Date: Thu, 11 Sep 2025 16:05:23 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 11/22] KVM: VMX: Emulate read and write to CET MSRs
To: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: acme@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, john.allen@amd.com, mingo@kernel.org, mingo@redhat.com,
 minipli@grsecurity.net, mlevitsk@redhat.com, namhyung@kernel.org,
 pbonzini@redhat.com, prsampat@amd.com, rick.p.edgecombe@intel.com,
 seanjc@google.com, shuah@kernel.org, tglx@linutronix.de,
 weijiang.yang@intel.com, x86@kernel.org, xin@zytor.com
References: <20250909093953.202028-1-chao.gao@intel.com>
 <20250909093953.202028-12-chao.gao@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250909093953.202028-12-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/9/2025 5:39 PM, Chao Gao wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> Add emulation interface for CET MSR access. The emulation code is split
> into common part and vendor specific part. The former does common checks
> for MSRs, e.g., accessibility, data validity etc., then passes operation
> to either XSAVE-managed MSRs via the helpers or CET VMCS fields.

I planed to continue the review after Sean posts v15 as he promised.
But I want to raise my question regarding it sooner so I just ask it on v14.

Do we expect to put the accessibility and data validity check always in 
__kvm_{s,g}_msr(), when the handling cannot be put in 
kvm_{g,s}et_common() only? i.e., there will be 3 case:

- All the handling in kvm_{g,s}et_common(), when the MSR emulation is 
common to vmx and svm.

- generic accessibility and data validity check in __kvm_{g,s}et_msr() 
and vendor specific handling in {vmx,svm}_{g,s}et_msr()

- generic accessibility and data validity check in __kvm_{g,s}et_msr() , 
vendor specific handling in {vmx,svm}_{g,s}et_msr() and other generic 
handling in kvm_{g,s}et_common()

> SSP can only be read via RDSSP. Writing even requires destructive and
> potentially faulting operations such as SAVEPREVSSP/RSTORSSP or
> SETSSBSY/CLRSSBSY. Let the host use a pseudo-MSR that is just a wrapper
> for the GUEST_SSP field of the VMCS.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> ---
> v14:
> - Update both hardware MSR value and VMCS field when userspace writes to
>    MSR_IA32_S_CET. This keeps guest FPU and VMCS always inconsistent
>    regarding MSR_IA32_S_CET.
> ---
>   arch/x86/kvm/vmx/vmx.c | 19 +++++++++++++
>   arch/x86/kvm/x86.c     | 60 ++++++++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/x86.h     | 23 ++++++++++++++++
>   3 files changed, 102 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 227b45430ad8..22bd71bebfad 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2106,6 +2106,15 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		else
>   			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
>   		break;
> +	case MSR_IA32_S_CET:
> +		msr_info->data = vmcs_readl(GUEST_S_CET);
> +		break;
> +	case MSR_KVM_INTERNAL_GUEST_SSP:
> +		msr_info->data = vmcs_readl(GUEST_SSP);
> +		break;
> +	case MSR_IA32_INT_SSP_TAB:
> +		msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
> +		break;
>   	case MSR_IA32_DEBUGCTLMSR:
>   		msr_info->data = vmx_guest_debugctl_read();
>   		break;
> @@ -2424,6 +2433,16 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		else
>   			vmx->pt_desc.guest.addr_a[index / 2] = data;
>   		break;
> +	case MSR_IA32_S_CET:
> +		vmcs_writel(GUEST_S_CET, data);
> +		kvm_set_xstate_msr(vcpu, msr_info);
> +		break;
> +	case MSR_KVM_INTERNAL_GUEST_SSP:
> +		vmcs_writel(GUEST_SSP, data);
> +		break;
> +	case MSR_IA32_INT_SSP_TAB:
> +		vmcs_writel(GUEST_INTR_SSP_TABLE, data);
> +		break;
>   	case MSR_IA32_PERF_CAPABILITIES:
>   		if (data & PMU_CAP_LBR_FMT) {
>   			if ((data & PMU_CAP_LBR_FMT) !=
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a6036eab3852..79861b7ad44d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1886,6 +1886,44 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
>   
>   		data = (u32)data;
>   		break;
> +	case MSR_IA32_U_CET:
> +	case MSR_IA32_S_CET:
> +		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) &&
> +		    !guest_cpu_cap_has(vcpu, X86_FEATURE_IBT))
> +			return KVM_MSR_RET_UNSUPPORTED;
> +		if (!kvm_is_valid_u_s_cet(vcpu, data))
> +			return 1;
> +		break;
> +	case MSR_KVM_INTERNAL_GUEST_SSP:
> +		if (!host_initiated)
> +			return 1;
> +		fallthrough;
> +		/*
> +		 * Note that the MSR emulation here is flawed when a vCPU
> +		 * doesn't support the Intel 64 architecture. The expected
> +		 * architectural behavior in this case is that the upper 32
> +		 * bits do not exist and should always read '0'. However,
> +		 * because the actual hardware on which the virtual CPU is
> +		 * running does support Intel 64, XRSTORS/XSAVES in the
> +		 * guest could observe behavior that violates the
> +		 * architecture. Intercepting XRSTORS/XSAVES for this
> +		 * special case isn't deemed worthwhile.
> +		 */
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
> +		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK))
> +			return KVM_MSR_RET_UNSUPPORTED;
> +		/*
> +		 * MSR_IA32_INT_SSP_TAB is not present on processors that do
> +		 * not support Intel 64 architecture.
> +		 */
> +		if (index == MSR_IA32_INT_SSP_TAB && !guest_cpu_cap_has(vcpu, X86_FEATURE_LM))
> +			return KVM_MSR_RET_UNSUPPORTED;
> +		if (is_noncanonical_msr_address(data, vcpu))
> +			return 1;
> +		/* All SSP MSRs except MSR_IA32_INT_SSP_TAB must be 4-byte aligned */
> +		if (index != MSR_IA32_INT_SSP_TAB && !IS_ALIGNED(data, 4))
> +			return 1;
> +		break;
>   	}
>   
>   	msr.data = data;
> @@ -1930,6 +1968,20 @@ static int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
>   		    !guest_cpu_cap_has(vcpu, X86_FEATURE_RDPID))
>   			return 1;
>   		break;
> +	case MSR_IA32_U_CET:
> +	case MSR_IA32_S_CET:
> +		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) &&
> +		    !guest_cpu_cap_has(vcpu, X86_FEATURE_IBT))
> +			return KVM_MSR_RET_UNSUPPORTED;
> +		break;
> +	case MSR_KVM_INTERNAL_GUEST_SSP:
> +		if (!host_initiated)
> +			return 1;
> +		fallthrough;
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
> +		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK))
> +			return KVM_MSR_RET_UNSUPPORTED;
> +		break;
>   	}
>   
>   	msr.index = index;
> @@ -4220,6 +4272,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		vcpu->arch.guest_fpu.xfd_err = data;
>   		break;
>   #endif
> +	case MSR_IA32_U_CET:
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> +		kvm_set_xstate_msr(vcpu, msr_info);
> +		break;
>   	default:
>   		if (kvm_pmu_is_valid_msr(vcpu, msr))
>   			return kvm_pmu_set_msr(vcpu, msr_info);
> @@ -4569,6 +4625,10 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		msr_info->data = vcpu->arch.guest_fpu.xfd_err;
>   		break;
>   #endif
> +	case MSR_IA32_U_CET:
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> +		kvm_get_xstate_msr(vcpu, msr_info);
> +		break;
>   	default:
>   		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
>   			return kvm_pmu_get_msr(vcpu, msr_info);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index cf4f73a95825..95d2a82a4674 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -735,4 +735,27 @@ static inline void kvm_set_xstate_msr(struct kvm_vcpu *vcpu,
>   	kvm_fpu_put();
>   }
>   
> +#define CET_US_RESERVED_BITS		GENMASK(9, 6)
> +#define CET_US_SHSTK_MASK_BITS		GENMASK(1, 0)
> +#define CET_US_IBT_MASK_BITS		(GENMASK_ULL(5, 2) | GENMASK_ULL(63, 10))
> +#define CET_US_LEGACY_BITMAP_BASE(data)	((data) >> 12)
> +
> +static inline bool kvm_is_valid_u_s_cet(struct kvm_vcpu *vcpu, u64 data)
> +{
> +	if (data & CET_US_RESERVED_BITS)
> +		return false;
> +	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) &&
> +	    (data & CET_US_SHSTK_MASK_BITS))
> +		return false;
> +	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_IBT) &&
> +	    (data & CET_US_IBT_MASK_BITS))
> +		return false;
> +	if (!IS_ALIGNED(CET_US_LEGACY_BITMAP_BASE(data), 4))
> +		return false;
> +	/* IBT can be suppressed iff the TRACKER isn't WAIT_ENDBR. */
> +	if ((data & CET_SUPPRESS) && (data & CET_WAIT_ENDBR))
> +		return false;
> +
> +	return true;
> +}
>   #endif


