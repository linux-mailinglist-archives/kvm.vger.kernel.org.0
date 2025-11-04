Return-Path: <kvm+bounces-61934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 64E39C2EE7F
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 03:01:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EAFF71893834
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 02:01:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01F9823A566;
	Tue,  4 Nov 2025 02:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ITMSH1Zx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE64334D3BD;
	Tue,  4 Nov 2025 02:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762221657; cv=none; b=spOY9HiybuywxsGxV1nh/x6E7oucIIb154KIVfauqkHosXE2jmDeyhfkizuT5fI/fWG7v92KyXKDXzeMo84ZAqwLpR1RrwfZ+dPZRpSJpSO3lLX1vBfUcPZHrbGJ5wtBeQR95NYvnP9n0Gck3GTGafISf5rEeXj5jxXEHFYnZJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762221657; c=relaxed/simple;
	bh=VnnJbpfgfc27C1N7saaA0+Ku7w31pE7QI39GzooOGxs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PKvslMPyT1M2IDEpf+MCiRqFAte77rEM6Md2iIQ/UE+TUHogZBCkpWyrKKfXhbABtB75biwFeW+VcVZ/sKAuX395AcLBPizkQiPatF8AY33AQ81OtSZaNa3FetgojxDv5rThPso0pz6KNcl1OWbpl3Mek8Zg68rYe/2VvDd6Z1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ITMSH1Zx; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762221653; x=1793757653;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VnnJbpfgfc27C1N7saaA0+Ku7w31pE7QI39GzooOGxs=;
  b=ITMSH1ZxMu26b2vLdCZJJQZjGUSSOSj8AnAwJ6zGh9e69/TmF6Drd+ZX
   a1YamXbWjWqB5qTLA7C3btIsCV3eQDu5hl3UmdXo9KfuU+qeMPCxygbyt
   /L+HIyRhid7TOMGW4H9lrt7fkqYCKevMeMYKraBmTigYWW0zRuk0k0vLq
   TrTtYs+Esi422+ZK8aFW+3tKyw4DcHddT1EvA4chJYG0/Ta4Ws3RReF4L
   /JRRB6MkTZxwWaYrWi3PclQs5pUfIGjYZt3PLkXg+X3y/4DzY399VFo0v
   CBvajvl6RlBDUMhzg8cYR4I6gUsQHIahhiiWS68u3o3QZt6OVz87NXznH
   g==;
X-CSE-ConnectionGUID: L8kGcRgZQOOzAx25w1hbYA==
X-CSE-MsgGUID: gDR0E0d5Tjaj4DjMSnzKpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="89770004"
X-IronPort-AV: E=Sophos;i="6.19,277,1754982000"; 
   d="scan'208";a="89770004"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 18:00:52 -0800
X-CSE-ConnectionGUID: 25YNGXmjTeKF7zVKx9nqYA==
X-CSE-MsgGUID: W9SIRzFBTCO7E/09AI4wkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,277,1754982000"; 
   d="scan'208";a="187177402"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.49]) ([10.124.240.49])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 18:00:53 -0800
Message-ID: <3391fbf5-c3b0-43e5-b821-8a64a8f77061@intel.com>
Date: Tue, 4 Nov 2025 10:00:50 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Add a helper to dedup reporting of unhandled
 VM-Exits
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251030185004.3372256-1-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20251030185004.3372256-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/2025 2:50 AM, Sean Christopherson wrote:
> Add and use a helper, kvm_prepare_unexpected_reason_exit(), to dedup the
> code that fills the exit reason and CPU when KVM encounters a VM-Exit that
> KVM doesn't know how to handle.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/include/asm/kvm_host.h |  1 +
>   arch/x86/kvm/svm/svm.c          |  7 +------
>   arch/x86/kvm/vmx/tdx.c          |  6 +-----
>   arch/x86/kvm/vmx/vmx.c          |  9 +--------
>   arch/x86/kvm/x86.c              | 12 ++++++++++++
>   5 files changed, 16 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 48598d017d6f..4fbe4b7ce1da 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2167,6 +2167,7 @@ void __kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu,
>   void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu);
>   
>   void kvm_prepare_event_vectoring_exit(struct kvm_vcpu *vcpu, gpa_t gpa);
> +void kvm_prepare_unexpected_reason_exit(struct kvm_vcpu *vcpu, u64 exit_reason);
>   
>   void kvm_enable_efer_bits(u64);
>   bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index f14709a511aa..83e0d4d5f4c5 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3451,13 +3451,8 @@ static bool svm_check_exit_valid(u64 exit_code)
>   
>   static int svm_handle_invalid_exit(struct kvm_vcpu *vcpu, u64 exit_code)
>   {
> -	vcpu_unimpl(vcpu, "svm: unexpected exit reason 0x%llx\n", exit_code);
>   	dump_vmcb(vcpu);
> -	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> -	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
> -	vcpu->run->internal.ndata = 2;
> -	vcpu->run->internal.data[0] = exit_code;
> -	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
> +	kvm_prepare_unexpected_reason_exit(vcpu, exit_code);
>   	return 0;
>   }
>   
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 326db9b9c567..079d9f13eddb 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -2145,11 +2145,7 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
>   	}
>   
>   unhandled_exit:
> -	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> -	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
> -	vcpu->run->internal.ndata = 2;
> -	vcpu->run->internal.data[0] = vp_enter_ret;
> -	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
> +	kvm_prepare_unexpected_reason_exit(vcpu, vp_enter_ret);
>   	return 0;
>   }
>   
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 1021d3b65ea0..08f7957ed4c3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6642,15 +6642,8 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>   	return kvm_vmx_exit_handlers[exit_handler_index](vcpu);
>   
>   unexpected_vmexit:
> -	vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
> -		    exit_reason.full);
>   	dump_vmcs(vcpu);
> -	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> -	vcpu->run->internal.suberror =
> -			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
> -	vcpu->run->internal.ndata = 2;
> -	vcpu->run->internal.data[0] = exit_reason.full;
> -	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
> +	kvm_prepare_unexpected_reason_exit(vcpu, exit_reason.full);
>   	return 0;
>   }
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b4b5d2d09634..c826cd05228a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9110,6 +9110,18 @@ void kvm_prepare_event_vectoring_exit(struct kvm_vcpu *vcpu, gpa_t gpa)
>   }
>   EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_prepare_event_vectoring_exit);
>   
> +void kvm_prepare_unexpected_reason_exit(struct kvm_vcpu *vcpu, u64 exit_reason)
> +{
> +	vcpu_unimpl(vcpu, "unexpected exit reason 0x%llx\n", exit_reason);
> +
> +	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
> +	vcpu->run->internal.ndata = 2;
> +	vcpu->run->internal.data[0] = exit_reason;
> +	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
> +}
> +EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_prepare_unexpected_reason_exit);
> +
>   static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
>   {
>   	struct kvm *kvm = vcpu->kvm;
> 
> base-commit: 4cc167c50eb19d44ac7e204938724e685e3d8057


