Return-Path: <kvm+bounces-48977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A2BF6AD4F05
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 10:59:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E053F1887188
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 08:59:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53DA024DCF2;
	Wed, 11 Jun 2025 08:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Clg1arqZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E9C2517AF;
	Wed, 11 Jun 2025 08:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749632346; cv=none; b=G6XT8sT+hOLPHV/ov8ohkO6/+ebx6hUIA7U8piznxXS+FIWyJn8+roW9Im9xAiD8nSsWuTAMnXeUZ9o9FGJP32N61706ezwFnPNaIci+ad4T50fLAGBqcApFA64gOAlb3HhLv6pF2xlvKz6tSookL5MhlyoJSAlmVBPPNvyV+Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749632346; c=relaxed/simple;
	bh=H1IHx/yRO5qZEp5ATIRAziVQv2P7VBMGrjmsGJ7dA4U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Od3e0dc6r+urB2tmB9Btpbl4mNwHkwGbDf7NEmZygc+4er4SshWIY1d/3yw1xsf2wy9uwj2dOayESt7ZJlwwJdUD8PIlGUNQTMfhJ9xMDP4/RNzCvrlnEeh12YWh7jOen83qH7FyiHUCkjQsBQ8hRYBd8p3DiLt+NaT/sOSiSpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Clg1arqZ; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749632344; x=1781168344;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=H1IHx/yRO5qZEp5ATIRAziVQv2P7VBMGrjmsGJ7dA4U=;
  b=Clg1arqZZXp95SgMxKRc0lhVgH56ZU8Z2hTBVH9joQRtwTzDAgJ48dgD
   jSNI09BAO5A0ey+3cEOf1AhIByYlcluKoIGE09ztl8Us/f3LFuQc6tSdG
   RQEm4m3/4pvRvS2iC9O0/qA8ZeVyf50ddPKkqHb7YveqSIl5IB888hKQv
   nChsjH/Ex+ULddWi1ecjgw0m7bfNzOBzFx6KVkGayquj5mJKpF7b2Cicm
   2q0ZeibowsDPtuwrg21mM4ufxUwMinegI2t+CxBFOHDujKUZWFVuPvS0S
   HINLN7VqN11iS9q/V+TTszoCfJAGJLIMNbPuFAB1VWKWqOIAYvHNnTDXp
   Q==;
X-CSE-ConnectionGUID: g/k/3tjsSR+poFCiXRoOLw==
X-CSE-MsgGUID: Tl6K0Tk8RAWpIT2Nxq8Ulg==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="51682056"
X-IronPort-AV: E=Sophos;i="6.16,227,1744095600"; 
   d="scan'208";a="51682056"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 01:59:03 -0700
X-CSE-ConnectionGUID: ZOFRd4v0RE6I3oTvgxfrEg==
X-CSE-MsgGUID: A5t0RdlsQZufrveceCUMng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,227,1744095600"; 
   d="scan'208";a="184339216"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.144]) ([10.124.245.144])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 01:59:01 -0700
Message-ID: <b8fdbde0-f5d3-484e-877b-c59e8c39bdaa@linux.intel.com>
Date: Wed, 11 Jun 2025 16:58:58 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 7/8] KVM: VMX: Wrap all accesses to IA32_DEBUGCTL with
 getter/setter APIs
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Adrian Hunter <adrian.hunter@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>
References: <20250610232010.162191-1-seanjc@google.com>
 <20250610232010.162191-8-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250610232010.162191-8-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/11/2025 7:20 AM, Sean Christopherson wrote:
> From: Maxim Levitsky <mlevitsk@redhat.com>
>
> Introduce vmx_guest_debugctl_{read,write}() to handle all accesses to
> vmcs.GUEST_IA32_DEBUGCTL. This will allow stuffing FREEZE_IN_SMM into
> GUEST_IA32_DEBUGCTL based on the host setting without bleeding the state
> into the guest, and without needing to copy+paste the FREEZE_IN_SMM
> logic into every patch that accesses GUEST_IA32_DEBUGCTL.
>
> No functional change intended.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> [sean: massage changelog, make inline, use in all prepare_vmcs02() cases]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c    | 10 +++++-----
>  arch/x86/kvm/vmx/pmu_intel.c |  8 ++++----
>  arch/x86/kvm/vmx/vmx.c       |  8 +++++---
>  arch/x86/kvm/vmx/vmx.h       | 10 ++++++++++
>  4 files changed, 24 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 5a6c636954eb..9edce9f411a3 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2662,11 +2662,11 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  	if (vmx->nested.nested_run_pending &&
>  	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS)) {
>  		kvm_set_dr(vcpu, 7, vmcs12->guest_dr7);
> -		vmcs_write64(GUEST_IA32_DEBUGCTL, vmcs12->guest_ia32_debugctl &
> -						  vmx_get_supported_debugctl(vcpu, false));
> +		vmx_guest_debugctl_write(vcpu, vmcs12->guest_ia32_debugctl &
> +					       vmx_get_supported_debugctl(vcpu, false));
>  	} else {
>  		kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
> -		vmcs_write64(GUEST_IA32_DEBUGCTL, vmx->nested.pre_vmenter_debugctl);
> +		vmx_guest_debugctl_write(vcpu, vmx->nested.pre_vmenter_debugctl);
>  	}
>  	if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
>  	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
> @@ -3531,7 +3531,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>  
>  	if (!vmx->nested.nested_run_pending ||
>  	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
> -		vmx->nested.pre_vmenter_debugctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
> +		vmx->nested.pre_vmenter_debugctl = vmx_guest_debugctl_read();
>  	if (kvm_mpx_supported() &&
>  	    (!vmx->nested.nested_run_pending ||
>  	     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
> @@ -4805,7 +4805,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
>  	__vmx_set_segment(vcpu, &seg, VCPU_SREG_LDTR);
>  
>  	kvm_set_dr(vcpu, 7, 0x400);
> -	vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
> +	vmx_guest_debugctl_write(vcpu, 0);
>  
>  	if (nested_vmx_load_msr(vcpu, vmcs12->vm_exit_msr_load_addr,
>  				vmcs12->vm_exit_msr_load_count))
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 8a94b52c5731..578b4ef58260 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -652,11 +652,11 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
>   */
>  static void intel_pmu_legacy_freezing_lbrs_on_pmi(struct kvm_vcpu *vcpu)
>  {
> -	u64 data = vmcs_read64(GUEST_IA32_DEBUGCTL);
> +	u64 data = vmx_guest_debugctl_read();
>  
>  	if (data & DEBUGCTLMSR_FREEZE_LBRS_ON_PMI) {
>  		data &= ~DEBUGCTLMSR_LBR;
> -		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
> +		vmx_guest_debugctl_write(vcpu, data);
>  	}
>  }
>  
> @@ -729,7 +729,7 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
>  
>  	if (!lbr_desc->event) {
>  		vmx_disable_lbr_msrs_passthrough(vcpu);
> -		if (vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR)
> +		if (vmx_guest_debugctl_read() & DEBUGCTLMSR_LBR)
>  			goto warn;
>  		if (test_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use))
>  			goto warn;
> @@ -751,7 +751,7 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
>  
>  static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
>  {
> -	if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR))
> +	if (!(vmx_guest_debugctl_read() & DEBUGCTLMSR_LBR))
>  		intel_pmu_release_guest_lbr_event(vcpu);
>  }
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index b685e43de4e9..196f33d934d3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2147,7 +2147,7 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
>  		break;
>  	case MSR_IA32_DEBUGCTLMSR:
> -		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
> +		msr_info->data = vmx_guest_debugctl_read();
>  		break;
>  	default:
>  	find_uret_msr:
> @@ -2281,7 +2281,8 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  						VM_EXIT_SAVE_DEBUG_CONTROLS)
>  			get_vmcs12(vcpu)->guest_ia32_debugctl = data;
>  
> -		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
> +		vmx_guest_debugctl_write(vcpu, data);
> +
>  		if (intel_pmu_lbr_is_enabled(vcpu) && !to_vmx(vcpu)->lbr_desc.event &&
>  		    (data & DEBUGCTLMSR_LBR))
>  			intel_pmu_create_guest_lbr_event(vcpu);
> @@ -4796,7 +4797,8 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>  	vmcs_write32(GUEST_SYSENTER_CS, 0);
>  	vmcs_writel(GUEST_SYSENTER_ESP, 0);
>  	vmcs_writel(GUEST_SYSENTER_EIP, 0);
> -	vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
> +
> +	vmx_guest_debugctl_write(&vmx->vcpu, 0);
>  
>  	if (cpu_has_vmx_tpr_shadow()) {
>  		vmcs_write64(VIRTUAL_APIC_PAGE_ADDR, 0);
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 392e66c7e5fe..c20a4185d10a 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -417,6 +417,16 @@ void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
>  u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated);
>  bool vmx_is_valid_debugctl(struct kvm_vcpu *vcpu, u64 data, bool host_initiated);
>  
> +static inline void vmx_guest_debugctl_write(struct kvm_vcpu *vcpu, u64 val)
> +{
> +	vmcs_write64(GUEST_IA32_DEBUGCTL, val);
> +}
> +
> +static inline u64 vmx_guest_debugctl_read(void)
> +{
> +	return vmcs_read64(GUEST_IA32_DEBUGCTL);
> +}
> +
>  /*
>   * Note, early Intel manuals have the write-low and read-high bitmap offsets
>   * the wrong way round.  The bitmaps control MSRs 0x00000000-0x00001fff and

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



