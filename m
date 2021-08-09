Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37C243E46C3
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 15:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbhHINhU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 09:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhHINhT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 09:37:19 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B30C0613D3;
        Mon,  9 Aug 2021 06:36:59 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id ca5so27982782pjb.5;
        Mon, 09 Aug 2021 06:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:organization:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y323wp+0M1YiiG3beFUvJBDLsGDflaCzjS1HZtxOBm0=;
        b=P1uoOrMsh/6E3EWQybshnDplcdVPZwvoIh2mtnvNERGS9qqPjeX09Pdl+uAf0gYdOC
         tpn8KBMoq55MOoI1OphcAQISH3/ofdxQVGVK72Y4iQY8rEt+sxym70JrweMd0kGq+0bx
         CPdf70vZO3/n4IBYbJ9f/ZcDoDw/lvY7cagzB3MoQOfpZwgIS26Jqd03d687FNdm+I5n
         +uvjv/2yQxqF2uilUE39GaYzW41Lq02BaZeRBTZkADqIgD+LpYrzB53gM8e3evlK6QuG
         8PSCc8e/5KG/4T1QS+haa4J6AXAGnJoxQluPEq1T8uNPgJDMfaQdjSsEDVxCzUCdvIbN
         tmXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=y323wp+0M1YiiG3beFUvJBDLsGDflaCzjS1HZtxOBm0=;
        b=tUk4TTXNBujaeCxEFXHSRp7B2cLO/kL1lHQ3uAG4Yf+zBNXYDsXcA8yOs2mcLkEuTB
         A8jmYBxWFipUqSAao/wmdQaBQNHGa3E10CcenzU0C6Vv4sp2fpzLRXw7GbYjbM7mgP29
         Gw/MlR3X/VwfQ1gxee5E/ug0f3xNYD5GRhV9K0voNBBC5/8XpRprhlI/WCg4rl+nf9Vy
         YNtlnOyp9ubOWzD6VIceLaHikEDAib0PrSOwd3Xl4NiDGgvsTe53iG2ATD6Vi5h8wQnt
         X2jfmy++ykgESXjl7/iXMkZgkys6RIC+GqKNwbZU95RFfAkJfFZdacJQhJcxyb2UpCJz
         a7rw==
X-Gm-Message-State: AOAM530pe6BeZcW0piFzHiUgIltNiHQPy+Vk2+ckQC9uu6d+Kyf5ET/m
        3A333f9BVdzg12l9bKeeQnNJZwwdIGlRPw==
X-Google-Smtp-Source: ABdhPJwOZaxwP/lYWy9bN2ysRkJ1GG8f/it/2BvjM1pP1uECJG8DbpTj27BeQXGk0psp++zPQCmqew==
X-Received: by 2002:aa7:8148:0:b029:31b:10b4:f391 with SMTP id d8-20020aa781480000b029031b10b4f391mr18009178pfn.69.1628516218659;
        Mon, 09 Aug 2021 06:36:58 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 186sm21092486pfg.11.2021.08.09.06.36.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 06:36:58 -0700 (PDT)
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1628235745-26566-1-git-send-email-weijiang.yang@intel.com>
 <1628235745-26566-6-git-send-email-weijiang.yang@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH v7 05/15] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_CTL for guest
 Arch LBR
Message-ID: <59ef2c3c-0997-d6a5-0d4a-4e777206a665@gmail.com>
Date:   Mon, 9 Aug 2021 21:36:49 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1628235745-26566-6-git-send-email-weijiang.yang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/8/2021 3:42 pm, Yang Weijiang wrote:
> From: Like Xu <like.xu@linux.intel.com>
> 
> Arch LBRs are enabled by setting MSR_ARCH_LBR_CTL.LBREn to 1. A new guest
> state field named "Guest IA32_LBR_CTL" is added to enhance guest LBR usage.
> When guest Arch LBR is enabled, a guest LBR event will be created like the
> model-specific LBR does. Clear guest LBR enable bit on host PMI handling so
> guest can see expected config.
> 
> On processors that support Arch LBR, MSR_IA32_DEBUGCTLMSR[bit 0] has no
> meaning. It can be written to 0 or 1, but reads will always return 0.
> Like IA32_DEBUGCTL, IA32_ARCH_LBR_CTL msr is also preserved on INIT.
> 
> Regardless of the Arch LBR or legacy LBR, when the LBR_EN bit 0 of the
> corresponding control MSR is set to 1, LBR recording will be enabled.
> 
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>   arch/x86/events/intel/lbr.c      |  2 --
>   arch/x86/include/asm/msr-index.h |  1 +
>   arch/x86/include/asm/vmx.h       |  2 ++
>   arch/x86/kvm/vmx/pmu_intel.c     | 48 ++++++++++++++++++++++++++++----
>   arch/x86/kvm/vmx/vmx.c           |  9 ++++++
>   5 files changed, 55 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
> index ceff16eb4bcb..d6773a200c70 100644
> --- a/arch/x86/events/intel/lbr.c
> +++ b/arch/x86/events/intel/lbr.c
> @@ -168,8 +168,6 @@ enum {
>   	 ARCH_LBR_RETURN		|\
>   	 ARCH_LBR_OTHER_BRANCH)
>   
> -#define ARCH_LBR_CTL_MASK			0x7f000e
> -
>   static void intel_pmu_lbr_filter(struct cpu_hw_events *cpuc);
>   
>   static __always_inline bool is_lbr_call_stack_bit_set(u64 config)
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index a7c413432b33..04059e8ed115 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -169,6 +169,7 @@
>   #define LBR_INFO_BR_TYPE		(0xfull << LBR_INFO_BR_TYPE_OFFSET)
>   
>   #define MSR_ARCH_LBR_CTL		0x000014ce
> +#define ARCH_LBR_CTL_MASK		0x7f000e
>   #define ARCH_LBR_CTL_LBREN		BIT(0)
>   #define ARCH_LBR_CTL_CPL_OFFSET		1
>   #define ARCH_LBR_CTL_CPL		(0x3ull << ARCH_LBR_CTL_CPL_OFFSET)
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 0ffaa3156a4e..ea3be961cc8e 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -245,6 +245,8 @@ enum vmcs_field {
>   	GUEST_BNDCFGS_HIGH              = 0x00002813,
>   	GUEST_IA32_RTIT_CTL		= 0x00002814,
>   	GUEST_IA32_RTIT_CTL_HIGH	= 0x00002815,
> +	GUEST_IA32_LBR_CTL		= 0x00002816,
> +	GUEST_IA32_LBR_CTL_HIGH		= 0x00002817,
>   	HOST_IA32_PAT			= 0x00002c00,
>   	HOST_IA32_PAT_HIGH		= 0x00002c01,
>   	HOST_IA32_EFER			= 0x00002c02,
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index a4ef5bbce186..b2631fea5e6c 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -19,6 +19,7 @@
>   #include "pmu.h"
>   
>   #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
> +#define KVM_ARCH_LBR_CTL_MASK  (ARCH_LBR_CTL_MASK | ARCH_LBR_CTL_LBREN)
>   
>   static struct kvm_event_hw_type_mapping intel_arch_events[] = {
>   	/* Index must match CPUID 0x0A.EBX bit vector */
> @@ -221,6 +222,7 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
>   		ret = pmu->version > 1;
>   		break;
>   	case MSR_ARCH_LBR_DEPTH:
> +	case MSR_ARCH_LBR_CTL:
>   		if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
>   			ret = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
>   		break;
> @@ -369,6 +371,26 @@ static bool arch_lbr_depth_is_valid(struct kvm_vcpu *vcpu, u64 depth)
>   	return (depth == fls(eax & 0xff) * 8);
>   }
>   
> +#define ARCH_LBR_CTL_BRN_MASK   GENMASK_ULL(22, 16)
> +
> +static bool arch_lbr_ctl_is_valid(struct kvm_vcpu *vcpu, u64 ctl)
> +{
> +	unsigned int eax, ebx, ecx, edx;
> +
> +	if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
> +		return false;
> +
> +	cpuid_count(0x1c, 0, &eax, &ebx, &ecx, &edx);
> +	if (!(ebx & BIT(0)) && (ctl & ARCH_LBR_CTL_CPL))
> +		return false;
> +	if (!(ebx & BIT(2)) && (ctl & ARCH_LBR_CTL_STACK))
> +		return false;
> +	if (!(ebx & BIT(1)) && (ctl & ARCH_LBR_CTL_BRN_MASK))
> +		return false;
> +
> +	return !(ctl & ~KVM_ARCH_LBR_CTL_MASK);
> +}

Please check it with the *guest* cpuid entry.

And it should remove the bits that are not supported by x86_pmu.lbr_ctl_mask before
vmcs_write64(...) if the guest value is a superset of the host value with 
warning message.

> +
>   static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   {
>   	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> @@ -392,6 +414,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   	case MSR_ARCH_LBR_DEPTH:
>   		msr_info->data = lbr_desc->records.nr;
>   		return 0;
> +	case MSR_ARCH_LBR_CTL:
> +		msr_info->data = vmcs_read64(GUEST_IA32_LBR_CTL);
> +		return 0;
>   	default:
>   		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>   		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
> @@ -460,6 +485,15 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		if (!msr_info->host_initiated)
>   			wrmsrl(MSR_ARCH_LBR_DEPTH, lbr_desc->records.nr);
>   		return 0;
> +	case MSR_ARCH_LBR_CTL:
> +		if (!arch_lbr_ctl_is_valid(vcpu, data))
> +			break;
> +
> +		vmcs_write64(GUEST_IA32_LBR_CTL, data);
> +		if (intel_pmu_lbr_is_enabled(vcpu) && !lbr_desc->event &&
> +		    (data & ARCH_LBR_CTL_LBREN))
> +			intel_pmu_create_guest_lbr_event(vcpu);
> +		return 0;
>   	default:
>   		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>   		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
> @@ -637,12 +671,16 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
>    */
>   static void intel_pmu_legacy_freezing_lbrs_on_pmi(struct kvm_vcpu *vcpu)
>   {
> -	u64 data = vmcs_read64(GUEST_IA32_DEBUGCTL);
> +	u32 lbr_ctl_field = GUEST_IA32_DEBUGCTL;
>   
> -	if (data & DEBUGCTLMSR_FREEZE_LBRS_ON_PMI) {
> -		data &= ~DEBUGCTLMSR_LBR;
> -		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
> -	}
> +	if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_FREEZE_LBRS_ON_PMI))
> +		return;
> +
> +	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
> +	    guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
> +		lbr_ctl_field = GUEST_IA32_LBR_CTL;
> +
> +	vmcs_write64(lbr_ctl_field, vmcs_read64(lbr_ctl_field) & ~0x1ULL);
>   }
>   
>   static void intel_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 927a552393b9..e8df44faf900 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2002,6 +2002,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   						VM_EXIT_SAVE_DEBUG_CONTROLS)
>   			get_vmcs12(vcpu)->guest_ia32_debugctl = data;
>   
> +		/*
> +		 * For Arch LBR, IA32_DEBUGCTL[bit 0] has no meaning.
> +		 * It can be written to 0 or 1, but reads will always return 0.
> +		 */
> +		if (guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
> +			data &= ~DEBUGCTLMSR_LBR;
> +
>   		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
>   		if (intel_pmu_lbr_is_enabled(vcpu) && !to_vmx(vcpu)->lbr_desc.event &&
>   		    (data & DEBUGCTLMSR_LBR))
> @@ -4441,6 +4448,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   		vmcs_writel(GUEST_SYSENTER_ESP, 0);
>   		vmcs_writel(GUEST_SYSENTER_EIP, 0);
>   		vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
> +		if (static_cpu_has(X86_FEATURE_ARCH_LBR))
> +			vmcs_write64(GUEST_IA32_LBR_CTL, 0);

Please update dump_vmcs() to dump GUEST_IA32_LBR_CTL as well.

How about update the load_vmcs12_host_state() for GUEST_IA32_LBR_CTL
since you enabled the nested case in this patch set ?

>   	}
>   
>   	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
> 
