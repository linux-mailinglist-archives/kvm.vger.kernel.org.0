Return-Path: <kvm+bounces-43915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D24C4A986CA
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 12:10:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B4D431B62EFB
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 10:10:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE0C8269CE6;
	Wed, 23 Apr 2025 10:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H49StJjP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0D14430;
	Wed, 23 Apr 2025 10:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745403028; cv=none; b=fTeGhFmG4ldoE0lHANz7IrX5Nut3Q9irF24nUCfpiKIW218D6T6yk/74jTD/iAK34KDCCcywBUFWjqH+XY40Rs9oYsruSiRaioJ7qQ70BtaD+RCmeI27f99zj4UCnqU8L7fIIZDpzm2ZX1nBifrJO+E2r0FrdonuCDE8WazXcYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745403028; c=relaxed/simple;
	bh=I7Q7dtD8lhH5wwvLh0UAUdfy9+RzDi/j203a8I36eko=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HaFRCr1JAr8vPMyqseZIhSTnC9Df1rSiP9YFoB6KWTkzRzFAAxP5GnrJlfhXd0O7DbU3dGg48AHTYE251U8eGB/Lm1MDHZDdIN8llepWtrybCpmiEMUqsOQOriouJAru51pPgFbS06h3ymPr9tMOqvgyhKfkRSBtPTU3jSLgFIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H49StJjP; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745403026; x=1776939026;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=I7Q7dtD8lhH5wwvLh0UAUdfy9+RzDi/j203a8I36eko=;
  b=H49StJjPTf0BP7YSXGZjb4M/rew1Id6KN7r3W2fDqTWgwAmyZvoRByBn
   bjXxDlbssv+39HgmPzdIH7eODUoieCPaHz9Xmqj2y9khtkRZ/s8I0Ec0U
   XxaXwXIq05ZsXHD4EvOQhNMoXfsP4yzeiDXDU3IgGamMtdYbkQscY+kxI
   qjycYFmcOHfGUIqzxyv1X0hB3XQl/8d4g5H9QWJsxE+/JQruFpUdj/vHa
   OTyhmf3uoeiUjyQjCuN4zRUb2/lYsTYvkn2uNj0qU/WoDSxeHOZO1ynNI
   QVB7S/1IC9iCI8rqc7rmlzP372QEo2X9CC7/n5BHSKF3vLJcc6R22e1qu
   g==;
X-CSE-ConnectionGUID: QVTY5Y+wSqaXaP7IfHMk+A==
X-CSE-MsgGUID: JX8VAkX0QP+VuBiS8qKmTA==
X-IronPort-AV: E=McAfee;i="6700,10204,11411"; a="57977815"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="57977815"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 03:10:24 -0700
X-CSE-ConnectionGUID: huoA+GYaTASwXYwT2Bkhbg==
X-CSE-MsgGUID: mfSSYZgnTmyRFlZ7Xy5HEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="137348767"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 03:10:21 -0700
Message-ID: <706eb76a-c094-4e4a-9a38-bd597ebf6874@linux.intel.com>
Date: Wed, 23 Apr 2025 18:10:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] x86: KVM: VMX: preserve host's
 DEBUGCTLMSR_FREEZE_IN_SMM while in the guest mode
To: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
 Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
 Sean Christopherson <seanjc@google.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
 linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20250416002546.3300893-1-mlevitsk@redhat.com>
 <20250416002546.3300893-4-mlevitsk@redhat.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250416002546.3300893-4-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 4/16/2025 8:25 AM, Maxim Levitsky wrote:
> Pass through the host's DEBUGCTL.DEBUGCTLMSR_FREEZE_IN_SMM to the guest
> GUEST_IA32_DEBUGCTL without the guest seeing this value.
>
> Note that in the future we might allow the guest to set this bit as well,
> when we implement PMU freezing on VM own, virtual SMM entry.
>
> Since the value of the host DEBUGCTL can in theory change between VM runs,
> check if has changed, and if yes, then reload the GUEST_IA32_DEBUGCTL with
> the new value of the host portion of it (currently only the
> DEBUGCTLMSR_FREEZE_IN_SMM bit)
>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/svm.c |  2 ++
>  arch/x86/kvm/vmx/vmx.c | 28 +++++++++++++++++++++++++++-
>  arch/x86/kvm/x86.c     |  2 --
>  3 files changed, 29 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index cc1c721ba067..fda0660236d8 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4271,6 +4271,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
>  	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
>  	svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];
>  
> +	vcpu->arch.host_debugctl = get_debugctlmsr();
> +
>  	/*
>  	 * Disable singlestep if we're injecting an interrupt/exception.
>  	 * We don't want our modified rflags to be pushed on the stack where
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c9208a4acda4..e0bc31598d60 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2194,6 +2194,17 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
>  	return debugctl;
>  }
>  
> +static u64 vmx_get_host_preserved_debugctl(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * Bits of host's DEBUGCTL that we should preserve while the guest is
> +	 * running.
> +	 *
> +	 * Some of those bits might still be emulated for the guest own use.
> +	 */
> +	return DEBUGCTLMSR_FREEZE_IN_SMM;
> +}

Seems unnecessary to define a function here, a macro is enough.

#define HOST_DEBUGCTL_PRESERVE_BITS        (DEBUGCTLMSR_FREEZE_IN_SMM)


> +
>  u64 vmx_get_guest_debugctl(struct kvm_vcpu *vcpu)
>  {
>  	return to_vmx(vcpu)->msr_ia32_debugctl;
> @@ -2202,9 +2213,11 @@ u64 vmx_get_guest_debugctl(struct kvm_vcpu *vcpu)
>  static void __vmx_set_guest_debugctl(struct kvm_vcpu *vcpu, u64 data)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	u64 host_mask = vmx_get_host_preserved_debugctl(vcpu);
>  
>  	vmx->msr_ia32_debugctl = data;
> -	vmcs_write64(GUEST_IA32_DEBUGCTL, data);
> +	vmcs_write64(GUEST_IA32_DEBUGCTL,
> +		     (vcpu->arch.host_debugctl & host_mask) | (data & ~host_mask));
>  }
>  
>  bool vmx_set_guest_debugctl(struct kvm_vcpu *vcpu, u64 data, bool host_initiated)
> @@ -2232,6 +2245,7 @@ bool vmx_set_guest_debugctl(struct kvm_vcpu *vcpu, u64 data, bool host_initiated
>  	return true;
>  }
>  
> +
>  /*
>   * Writes msr value into the appropriate "register".
>   * Returns 0 on success, non-0 otherwise.
> @@ -7349,6 +7363,7 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	unsigned long cr3, cr4;
> +	u64 old_debugctl;
>  
>  	/* Record the guest's net vcpu time for enforced NMI injections. */
>  	if (unlikely(!enable_vnmi &&
> @@ -7379,6 +7394,17 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>  		vmcs_write32(PLE_WINDOW, vmx->ple_window);
>  	}
>  
> +	old_debugctl = vcpu->arch.host_debugctl;
> +	vcpu->arch.host_debugctl = get_debugctlmsr();
> +
> +	/*
> +	 * In case the host DEBUGCTL had changed since the last time we
> +	 * read it, update the guest's GUEST_IA32_DEBUGCTL with
> +	 * the host's bits.
> +	 */
> +	if (old_debugctl != vcpu->arch.host_debugctl)
> +		__vmx_set_guest_debugctl(vcpu, vmx->msr_ia32_debugctl);
> +
>  	/*
>  	 * We did this in prepare_switch_to_guest, because it needs to
>  	 * be within srcu_read_lock.
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 844e81ee1d96..05e866ed345d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11020,8 +11020,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		set_debugreg(0, 7);
>  	}
>  
> -	vcpu->arch.host_debugctl = get_debugctlmsr();
> -
>  	guest_timing_enter_irqoff();
>  
>  	for (;;) {

