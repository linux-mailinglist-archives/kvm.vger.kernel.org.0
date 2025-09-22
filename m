Return-Path: <kvm+bounces-58367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6151DB8F674
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 10:06:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3254A18956AA
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 08:06:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EACD82FC037;
	Mon, 22 Sep 2025 08:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d2ksPqe9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082FF264638;
	Mon, 22 Sep 2025 08:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758528372; cv=none; b=M49UUfcFZCKlTpTvbyJlwP+MIskiwwRxqvhlCuwdDnU8naJqeEhCu0YzN++dRKbFnK5yDqMR9bgy3Ugz4Sva7UVckpAZ0X8fnKgq87CmMfOgzPi2/znQKg1UCdhKYR5PIeiEis3MCCqhnBT/0iSSqRfPJjUs8rxujKlntyNlD8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758528372; c=relaxed/simple;
	bh=1+piIUfrkZscqkfIgKlpu4MasP8OfrL84v0aR2rL2WE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JeAjB2w2Fo3b7NAxXvY27TLosbCvIxd6758nSR3CHdal7CuEUCyhJVZ8AiVs53cG4b8bdK9qoQzXo+xryeGW8mTzIXSjzmL89BgQ5GAI7eKRTgNRLq4puoDz13NkKAIGtYE8K4PfQeqXXq9ruV8bi05zVmZ6d2M7kkoRTSp4Szs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d2ksPqe9; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758528369; x=1790064369;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1+piIUfrkZscqkfIgKlpu4MasP8OfrL84v0aR2rL2WE=;
  b=d2ksPqe9lgQBW85BIBu+ZpAwRairURGkmt3KoWyDs4J55Ta+fiXL6eSA
   EInP+FAyyNnRq8stxtHw+CQ9Fqu6Pmw9nVNyPKITtk9eNye3Tjj1TT84S
   Dt15pTxp/TQNaasaXaJYmMJlLQH9Az5V6+FEJwjqnUJfykTn4tr6VdBJR
   mrBtUg34UyDB1u+BQPH/c+gjagCE7ow83beW63ou5iATQfQBMUjYSCoJo
   quJ7bzmHug9tiGLNCLog9SCjlDQsCDqOSbLRNuQh5hR7XkKqDxYuFeYaz
   TVY9cxCsxQkydXlEAjY5ImRoLNlGD50kehm3GM03ii3wx3fXovv4sV65R
   w==;
X-CSE-ConnectionGUID: CG2vfqjmRZ2ZQMSDk4TXrg==
X-CSE-MsgGUID: qUG+BQuLR4Wv1MwbQaAOIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="60726010"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="60726010"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 01:06:08 -0700
X-CSE-ConnectionGUID: MWo297RiTbSkccnA/aiO4w==
X-CSE-MsgGUID: KDjI0Y6uRqCACBugEBm9Dw==
X-ExtLoop1: 1
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 01:06:05 -0700
Message-ID: <22b26908-16db-4b56-b3f1-f477356cc712@linux.intel.com>
Date: Mon, 22 Sep 2025 16:06:03 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 28/51] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-29-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250919223258.1604852-29-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/20/2025 6:32 AM, Sean Christopherson wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
>
> Add support for the LOAD_CET_STATE VM-Enter and VM-Exit controls, the
> CET XFEATURE bits in XSS, and  advertise support for IBT and SHSTK to
> userspace.  Explicitly clear IBT and SHSTK onn SVM, as additional work is
> needed to enable CET on SVM, e.g. to context switch S_CET and other state.
>
> Disable KVM CET feature if unrestricted_guest is unsupported/disabled as
> KVM does not support emulating CET, as running without Unrestricted Guest
> can result in KVM emulating large swaths of guest code.  While it's highly
> unlikely any guest will trigger emulation while also utilizing IBT or
> SHSTK, there's zero reason to allow CET without Unrestricted Guest as that
> combination should only be possible when explicitly disabling
> unrestricted_guest for testing purposes.
>
> Disable CET if VMX_BASIC[bit56] == 0, i.e. if hardware strictly enforces
> the presence of an Error Code based on exception vector, as attempting to
> inject a #CP with an Error Code (#CP architecturally has an Error Code)
> will fail due to the #CP vector historically not having an Error Code.
>
> Clear S_CET and SSP-related VMCS on "reset" to emulate the architectural
> of CET MSRs and SSP being reset to 0 after RESET, power-up and INIT.  Note,
> KVM already clears guest CET state that is managed via XSTATE in
> kvm_xstate_reset().
>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> [sean: move some bits to separate patches, massage changelog]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/include/asm/vmx.h      |  1 +
>   arch/x86/kvm/cpuid.c            |  2 ++
>   arch/x86/kvm/svm/svm.c          |  4 ++++
>   arch/x86/kvm/vmx/capabilities.h |  5 +++++
>   arch/x86/kvm/vmx/vmx.c          | 30 +++++++++++++++++++++++++++++-
>   arch/x86/kvm/vmx/vmx.h          |  6 ++++--
>   6 files changed, 45 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index ce10a7e2d3d9..c85c50019523 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -134,6 +134,7 @@
>   #define VMX_BASIC_DUAL_MONITOR_TREATMENT	BIT_ULL(49)
>   #define VMX_BASIC_INOUT				BIT_ULL(54)
>   #define VMX_BASIC_TRUE_CTLS			BIT_ULL(55)
> +#define VMX_BASIC_NO_HW_ERROR_CODE_CC		BIT_ULL(56)
>   
>   static inline u32 vmx_basic_vmcs_revision_id(u64 vmx_basic)
>   {
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index b5c4cb13630c..b861a88083e1 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -946,6 +946,7 @@ void kvm_set_cpu_caps(void)
>   		VENDOR_F(WAITPKG),
>   		F(SGX_LC),
>   		F(BUS_LOCK_DETECT),
> +		X86_64_F(SHSTK),
>   	);
>   
>   	/*
> @@ -990,6 +991,7 @@ void kvm_set_cpu_caps(void)
>   		F(AMX_INT8),
>   		F(AMX_BF16),
>   		F(FLUSH_L1D),
> +		F(IBT),
>   	);
>   
>   	if (boot_cpu_has(X86_FEATURE_AMD_IBPB_RET) &&
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 67f4eed01526..73dde1645e46 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5221,6 +5221,10 @@ static __init void svm_set_cpu_caps(void)
>   	kvm_caps.supported_perf_cap = 0;
>   	kvm_caps.supported_xss = 0;
>   
> +	/* KVM doesn't yet support CET virtualization for SVM. */
> +	kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
> +	kvm_cpu_cap_clear(X86_FEATURE_IBT);
> +
>   	/* CPUID 0x80000001 and 0x8000000A (SVM features) */
>   	if (nested) {
>   		kvm_cpu_cap_set(X86_FEATURE_SVM);
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index 59c83888bdc0..02aadb9d730e 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -73,6 +73,11 @@ static inline bool cpu_has_vmx_basic_inout(void)
>   	return	vmcs_config.basic & VMX_BASIC_INOUT;
>   }
>   
> +static inline bool cpu_has_vmx_basic_no_hw_errcode_cc(void)
> +{
> +	return	vmcs_config.basic & VMX_BASIC_NO_HW_ERROR_CODE_CC;
> +}
> +
>   static inline bool cpu_has_virtual_nmis(void)
>   {
>   	return vmcs_config.pin_based_exec_ctrl & PIN_BASED_VIRTUAL_NMIS &&
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index a7d9e60b2771..69e35440cee7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2615,6 +2615,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>   		{ VM_ENTRY_LOAD_IA32_EFER,		VM_EXIT_LOAD_IA32_EFER },
>   		{ VM_ENTRY_LOAD_BNDCFGS,		VM_EXIT_CLEAR_BNDCFGS },
>   		{ VM_ENTRY_LOAD_IA32_RTIT_CTL,		VM_EXIT_CLEAR_IA32_RTIT_CTL },
> +		{ VM_ENTRY_LOAD_CET_STATE,		VM_EXIT_LOAD_CET_STATE },
>   	};
>   
>   	memset(vmcs_conf, 0, sizeof(*vmcs_conf));
> @@ -4881,6 +4882,14 @@ void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   
>   	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);  /* 22.2.1 */
>   
> +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
> +		vmcs_writel(GUEST_SSP, 0);
> +		vmcs_writel(GUEST_INTR_SSP_TABLE, 0);
> +	}
> +	if (kvm_cpu_cap_has(X86_FEATURE_IBT) ||
> +	    kvm_cpu_cap_has(X86_FEATURE_SHSTK))
> +		vmcs_writel(GUEST_S_CET, 0);
> +
>   	kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
>   
>   	vpid_sync_context(vmx->vpid);
> @@ -6348,6 +6357,10 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
>   	if (vmcs_read32(VM_EXIT_MSR_STORE_COUNT) > 0)
>   		vmx_dump_msrs("guest autostore", &vmx->msr_autostore.guest);
>   
> +	if (vmentry_ctl & VM_ENTRY_LOAD_CET_STATE)
> +		pr_err("S_CET = 0x%016lx, SSP = 0x%016lx, SSP TABLE = 0x%016lx\n",
> +		       vmcs_readl(GUEST_S_CET), vmcs_readl(GUEST_SSP),
> +		       vmcs_readl(GUEST_INTR_SSP_TABLE));
>   	pr_err("*** Host State ***\n");
>   	pr_err("RIP = 0x%016lx  RSP = 0x%016lx\n",
>   	       vmcs_readl(HOST_RIP), vmcs_readl(HOST_RSP));
> @@ -6378,6 +6391,10 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
>   		       vmcs_read64(HOST_IA32_PERF_GLOBAL_CTRL));
>   	if (vmcs_read32(VM_EXIT_MSR_LOAD_COUNT) > 0)
>   		vmx_dump_msrs("host autoload", &vmx->msr_autoload.host);
> +	if (vmexit_ctl & VM_EXIT_LOAD_CET_STATE)
> +		pr_err("S_CET = 0x%016lx, SSP = 0x%016lx, SSP TABLE = 0x%016lx\n",
> +		       vmcs_readl(HOST_S_CET), vmcs_readl(HOST_SSP),
> +		       vmcs_readl(HOST_INTR_SSP_TABLE));
>   
>   	pr_err("*** Control State ***\n");
>   	pr_err("CPUBased=0x%08x SecondaryExec=0x%08x TertiaryExec=0x%016llx\n",
> @@ -7959,7 +7976,6 @@ static __init void vmx_set_cpu_caps(void)
>   		kvm_cpu_cap_set(X86_FEATURE_UMIP);
>   
>   	/* CPUID 0xD.1 */
> -	kvm_caps.supported_xss = 0;
>   	if (!cpu_has_vmx_xsaves())
>   		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
>   
> @@ -7971,6 +7987,18 @@ static __init void vmx_set_cpu_caps(void)
>   
>   	if (cpu_has_vmx_waitpkg())
>   		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
> +
> +	/*
> +	 * Disable CET if unrestricted_guest is unsupported as KVM doesn't
> +	 * enforce CET HW behaviors in emulator. On platforms with
> +	 * VMX_BASIC[bit56] == 0, inject #CP at VMX entry with error code
> +	 * fails, so disable CET in this case too.
> +	 */
> +	if (!cpu_has_load_cet_ctrl() || !enable_unrestricted_guest ||
> +	    !cpu_has_vmx_basic_no_hw_errcode_cc()) {
> +		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
> +		kvm_cpu_cap_clear(X86_FEATURE_IBT);
> +	}
>   }
>   
>   static bool vmx_is_io_intercepted(struct kvm_vcpu *vcpu,
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 23d6e89b96f2..af8224e074ee 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -484,7 +484,8 @@ static inline u8 vmx_get_rvi(void)
>   	 VM_ENTRY_LOAD_IA32_EFER |					\
>   	 VM_ENTRY_LOAD_BNDCFGS |					\
>   	 VM_ENTRY_PT_CONCEAL_PIP |					\
> -	 VM_ENTRY_LOAD_IA32_RTIT_CTL)
> +	 VM_ENTRY_LOAD_IA32_RTIT_CTL |					\
> +	 VM_ENTRY_LOAD_CET_STATE)
>   
>   #define __KVM_REQUIRED_VMX_VM_EXIT_CONTROLS				\
>   	(VM_EXIT_SAVE_DEBUG_CONTROLS |					\
> @@ -506,7 +507,8 @@ static inline u8 vmx_get_rvi(void)
>   	       VM_EXIT_LOAD_IA32_EFER |					\
>   	       VM_EXIT_CLEAR_BNDCFGS |					\
>   	       VM_EXIT_PT_CONCEAL_PIP |					\
> -	       VM_EXIT_CLEAR_IA32_RTIT_CTL)
> +	       VM_EXIT_CLEAR_IA32_RTIT_CTL |				\
> +	       VM_EXIT_LOAD_CET_STATE)
>   
>   #define KVM_REQUIRED_VMX_PIN_BASED_VM_EXEC_CONTROL			\
>   	(PIN_BASED_EXT_INTR_MASK |					\


