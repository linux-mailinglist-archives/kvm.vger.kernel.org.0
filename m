Return-Path: <kvm+bounces-54374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B230EB2004A
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 09:30:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6940F3AC688
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 07:30:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A80452D97B7;
	Mon, 11 Aug 2025 07:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DiHRTfUf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24965EACD
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 07:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754897401; cv=none; b=FVJq2RdMAiPeMycOclBi+xfdksa3X0jJ5RPU/Nb5SGltKY6btD7YrlIwyojfeRRCEaZdXFfECzzSE4g1fnwlGQIRH8Lk3jNhlbqw8zbNIJMvFnz5p0GCZpdiLI0OyVdcG2i/Lgm43eXb+iESh9vD0uhbrpsuTCxikb60IjRMcdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754897401; c=relaxed/simple;
	bh=lYJSLFM2B5pL/HRpletOqpH68aHKhuitZz8AU5TJAHI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t6qWfU2l32XotJVdRMgznEw9/QDHjtPK0En2c935c87VNUYNOHb0ijO+HIaa6pjIcbz7DYQhszL909nPqrDPfFRPdp+QgD6Am4Ul4vEkmia4lJ++xBINBdzSojpMryewAjlsFguFnQ/FKK+Rfb+B1qs9CTJrvsr8+c5rgc7q8Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DiHRTfUf; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754897400; x=1786433400;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lYJSLFM2B5pL/HRpletOqpH68aHKhuitZz8AU5TJAHI=;
  b=DiHRTfUfkTK3Ql5P5+6DEjAGvM3IDeYdBkGALMIDnA+I3uNDKgf52UEv
   vYY+u/4PAsYoZ5H3K7tBn2yo/dTYniP9ihvNYBO53gyASSh0wpxzgy6Mq
   x1IXilQkPf3tBjeGUanz6XQ8Bv2M4QbXSCwDfO5jZbLMhfSFwUKZNUHqn
   Vg91V5cz7Hp5JCKRHQ0HK8DjOhmofHrycbP6yy06suRPpWD1ToMs2G52r
   vbCixny3Do3SEmbnfoPitrFIWwJOqdDo8T03pzyf88RH3RIUc+jA44Jke
   XeYrEsSefuNm1mWqSB9G2lEcaHvLOc+PdSeSlmQKq9e1UGomKJkIGDC8a
   A==;
X-CSE-ConnectionGUID: fhtUTiuERT+LxlVgEY8gLw==
X-CSE-MsgGUID: 7bFDnyDVTy6o6Fa00eEbyw==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="57015891"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="57015891"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 00:30:00 -0700
X-CSE-ConnectionGUID: K+JxOWLRTuyBxEGdgVkDEw==
X-CSE-MsgGUID: I2JyfglWR1q3TUoHDUHU+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="165837359"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 00:29:57 -0700
Message-ID: <6c5efe8d-317e-46ad-94d9-a36adb076936@intel.com>
Date: Mon, 11 Aug 2025 15:29:54 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 1/2] nVMX: Remove the IA32_DEBUGCTLMSR
 access in debugctls test
To: Chenyi Qiang <chenyi.qiang@intel.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
References: <20250811063035.12626-1-chenyi.qiang@intel.com>
 <20250811063035.12626-2-chenyi.qiang@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250811063035.12626-2-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/11/2025 2:30 PM, Chenyi Qiang wrote:
> Current debug controls test can pass but will trigger some error
> messages because it tries to access LBR (bit 0) and BTF (bit 1) in
> IA32_DEBUGCTLMSR:
> 
>    kvm_intel: kvm [18663]: vcpu0, guest rIP: 0x407de7 Unhandled WRMSR(0x1d9) = 0x1
>    kvm_intel: kvm [18663]: vcpu0, guest rIP: 0x0 Unhandled WRMSR(0x1d9) = 0x2
>    kvm_intel: kvm [18663]: vcpu0, guest rIP: 0x40936f Unhandled WRMSR(0x1d9) = 0x3
>    kvm_intel: kvm [18663]: vcpu0, guest rIP: 0x40cf09 Unhandled WRMSR(0x1d9) = 0x1
>    kvm_intel: kvm [18663]: vcpu0, guest rIP: 0x40940d Unhandled WRMSR(0x1d9) = 0x3
> 
> The IA32_DEBUGCTLMSR value isn't used as a criterion for determining
> whether the test is passed. It only provides some hints on the expected
> values with the control of {ENT_LOAD, EXIT_SAVE}_DBGCTLS. The reality is
> different because KVM only allows the guest to access the valid bits
> depending on the supported features. Luckily, KVM will exempt BTF and
> LBR from validity check which makes the test survive.
> 
> Considering that IA32_DEBUGCTLMSR access is not practically effective
> and will bring error messages, eliminate the related code and rename
> the test to specifically address the DR7 check.

I would expect you explained it more clear, e.g.,

"debug controls" test was added by commit[0] to verify that "VM-Entry 
load debug controls" and "VM-Exit save debug controls" are correctly 
emulated by KVM for nested VMX. But due to the limitation that KVM 
didn't support MSR_IA32_DEBUGCTL for guest at that time, the test 
commented out all the value comparison of MSR_IA32_DEBUGCTL and leave it 
to future when KVM supports the MSR.

The test doesn't check the functionality of save/restore guest 
MSR_IA32_DEBUGCTL on vm-exit/-entry, but it keeps the write of 
MSR_IA32_DEBUGCTL. It leads to

   kvm_intel: kvm [18663]: vcpu0, guest rIP: 0x407de7 Unhandled 
WRMSR(0x1d9) = 0x1
   kvm_intel: kvm [18663]: vcpu0, guest rIP: 0x0 Unhandled WRMSR(0x1d9) 
= 0x2
   kvm_intel: kvm [18663]: vcpu0, guest rIP: 0x40936f Unhandled 
WRMSR(0x1d9) = 0x3
   kvm_intel: kvm [18663]: vcpu0, guest rIP: 0x40cf09 Unhandled 
WRMSR(0x1d9) = 0x1
   kvm_intel: kvm [18663]: vcpu0, guest rIP: 0x40940d Unhandled 
WRMSR(0x1d9) = 0x3

to the kernel log. Though it doesn't break the test, the log confuses 
people to think something wrong happened in the testcase.

Current KVM does support some bits of MSR_IA32_DEBUGCTL but they depend 
on the vcpu model exposed. To simplify the case and eliminate the 
confusing "Unhandled WRMSR(0x1d9)" log, remove the MSR_IA32_DEBUGCTL 
logic in the test and make it concentrate only on DR7. Following patch 
will bring back MSR_IA32_DEBUGCTL separately.

[0] dc5c01f17b1a ("VMX: Test behavior on set and cleared save/load debug 
controls")

> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>

For the code change,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   x86/vmx_tests.c | 46 ++++++++++++++--------------------------------
>   1 file changed, 14 insertions(+), 32 deletions(-)
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 0b3cfe50..1832bda3 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -1850,21 +1850,18 @@ static int nmi_hlt_exit_handler(union exit_reason exit_reason)
>   }
>   
>   
> -static int dbgctls_init(struct vmcs *vmcs)
> +static int dbgctls_dr7_init(struct vmcs *vmcs)
>   {
>   	u64 dr7 = 0x402;
>   	u64 zero = 0;
>   
> -	msr_bmp_init();
>   	asm volatile(
>   		"mov %0,%%dr0\n\t"
>   		"mov %0,%%dr1\n\t"
>   		"mov %0,%%dr2\n\t"
>   		"mov %1,%%dr7\n\t"
>   		: : "r" (zero), "r" (dr7));
> -	wrmsr(MSR_IA32_DEBUGCTLMSR, 0x1);
>   	vmcs_write(GUEST_DR7, 0x404);
> -	vmcs_write(GUEST_DEBUGCTL, 0x2);
>   
>   	vmcs_write(ENT_CONTROLS, vmcs_read(ENT_CONTROLS) | ENT_LOAD_DBGCTLS);
>   	vmcs_write(EXI_CONTROLS, vmcs_read(EXI_CONTROLS) | EXI_SAVE_DBGCTLS);
> @@ -1872,23 +1869,19 @@ static int dbgctls_init(struct vmcs *vmcs)
>   	return VMX_TEST_START;
>   }
>   
> -static void dbgctls_main(void)
> +static void dbgctls_dr7_main(void)
>   {
> -	u64 dr7, debugctl;
> +	u64 dr7;
>   
>   	asm volatile("mov %%dr7,%0" : "=r" (dr7));
> -	debugctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
> -	/* Commented out: KVM does not support DEBUGCTL so far */
> -	(void)debugctl;
> -	report(dr7 == 0x404, "Load debug controls" /* && debugctl == 0x2 */);
> +	report(dr7 == 0x404, "DR7: Load debug controls");
>   
>   	dr7 = 0x408;
>   	asm volatile("mov %0,%%dr7" : : "r" (dr7));
> -	wrmsr(MSR_IA32_DEBUGCTLMSR, 0x3);
>   
>   	vmx_set_test_stage(0);
>   	vmcall();
> -	report(vmx_get_test_stage() == 1, "Save debug controls");
> +	report(vmx_get_test_stage() == 1, "DR7: Save debug controls");
>   
>   	if (ctrl_enter_rev.set & ENT_LOAD_DBGCTLS ||
>   	    ctrl_exit_rev.set & EXI_SAVE_DBGCTLS) {
> @@ -1899,46 +1892,37 @@ static void dbgctls_main(void)
>   	vmcall();
>   
>   	asm volatile("mov %%dr7,%0" : "=r" (dr7));
> -	debugctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
> -	/* Commented out: KVM does not support DEBUGCTL so far */
> -	(void)debugctl;
>   	report(dr7 == 0x402,
> -	       "Guest=host debug controls" /* && debugctl == 0x1 */);
> +	       "DR7: Guest=host debug controls");
>   
>   	dr7 = 0x408;
>   	asm volatile("mov %0,%%dr7" : : "r" (dr7));
> -	wrmsr(MSR_IA32_DEBUGCTLMSR, 0x3);
>   
>   	vmx_set_test_stage(3);
>   	vmcall();
> -	report(vmx_get_test_stage() == 4, "Don't save debug controls");
> +	report(vmx_get_test_stage() == 4, "DR7: Don't save debug controls");
>   }
>   
> -static int dbgctls_exit_handler(union exit_reason exit_reason)
> +static int dbgctls_dr7_exit_handler(union exit_reason exit_reason)
>   {
>   	u32 insn_len = vmcs_read(EXI_INST_LEN);
>   	u64 guest_rip = vmcs_read(GUEST_RIP);
> -	u64 dr7, debugctl;
> +	u64 dr7;
>   
>   	asm volatile("mov %%dr7,%0" : "=r" (dr7));
> -	debugctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
>   
>   	switch (exit_reason.basic) {
>   	case VMX_VMCALL:
>   		switch (vmx_get_test_stage()) {
>   		case 0:
> -			if (dr7 == 0x400 && debugctl == 0 &&
> -			    vmcs_read(GUEST_DR7) == 0x408 /* &&
> -			    Commented out: KVM does not support DEBUGCTL so far
> -			    vmcs_read(GUEST_DEBUGCTL) == 0x3 */)
> +			if (dr7 == 0x400 &&
> +			    vmcs_read(GUEST_DR7) == 0x408)
>   				vmx_inc_test_stage();
>   			break;
>   		case 2:
>   			dr7 = 0x402;
>   			asm volatile("mov %0,%%dr7" : : "r" (dr7));
> -			wrmsr(MSR_IA32_DEBUGCTLMSR, 0x1);
>   			vmcs_write(GUEST_DR7, 0x404);
> -			vmcs_write(GUEST_DEBUGCTL, 0x2);
>   
>   			vmcs_write(ENT_CONTROLS,
>   				vmcs_read(ENT_CONTROLS) & ~ENT_LOAD_DBGCTLS);
> @@ -1946,10 +1930,8 @@ static int dbgctls_exit_handler(union exit_reason exit_reason)
>   				vmcs_read(EXI_CONTROLS) & ~EXI_SAVE_DBGCTLS);
>   			break;
>   		case 3:
> -			if (dr7 == 0x400 && debugctl == 0 &&
> -			    vmcs_read(GUEST_DR7) == 0x404 /* &&
> -			    Commented out: KVM does not support DEBUGCTL so far
> -			    vmcs_read(GUEST_DEBUGCTL) == 0x2 */)
> +			if (dr7 == 0x400 &&
> +			    vmcs_read(GUEST_DR7) == 0x404)
>   				vmx_inc_test_stage();
>   			break;
>   		}
> @@ -11402,7 +11384,7 @@ struct vmx_test vmx_tests[] = {
>   		interrupt_exit_handler, NULL, {0} },
>   	{ "nmi_hlt", nmi_hlt_init, nmi_hlt_main,
>   		nmi_hlt_exit_handler, NULL, {0} },
> -	{ "debug controls", dbgctls_init, dbgctls_main, dbgctls_exit_handler,
> +	{ "debug controls dr7", dbgctls_dr7_init, dbgctls_dr7_main, dbgctls_dr7_exit_handler,
>   		NULL, {0} },
>   	{ "MSR switch", msr_switch_init, msr_switch_main,
>   		msr_switch_exit_handler, NULL, {0}, msr_switch_entry_failure },


