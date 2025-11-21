Return-Path: <kvm+bounces-64071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B24F9C77825
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 07:11:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4FCD0358D33
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 06:09:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B044C2E8DF3;
	Fri, 21 Nov 2025 06:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XnG4O1lX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABB9271A94;
	Fri, 21 Nov 2025 06:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763705347; cv=none; b=lFGPMx8q4qODZFODkrR1jeAQ05Je9JMa/F+jRneeNqU+QCnBCra7dCmcCMM50zadCVF9So+NTzX+pAXNkPj1hPybpD6i6592oOQnhm7Nz2F8nWAmoKBymySGwWkLkBt2FstSFCwLQR2kyQHhn2BafJjBaS5lTPdS0fQZlXdUuyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763705347; c=relaxed/simple;
	bh=UC5urBcdaR5woWofccN9NZTgo51AUxQjysKrUr+1mkI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YZW3vOunuauqT6xuUPYrMrAeealUP1LToAydlKeq/vAaWnKC5XeMoWQya7WespZzh+AhTNucC4r25WXw1pe+KX5+ApiNaYpyfNRefOfq4TCFY4YBqM+/QNR4SpJoG7jI58t56XetRRKzWfvBYQfaL8MmN89QBoPc2t/0c8dqaXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XnG4O1lX; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763705346; x=1795241346;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UC5urBcdaR5woWofccN9NZTgo51AUxQjysKrUr+1mkI=;
  b=XnG4O1lXahfAeKxjnSG8C52u2lAH+1QIto6NvAxC28PoHCa9m9JznEXh
   5kw8B8CaU6N32hFQOMu6bZVjPDMT1tordcAuyN7lxwuGGWPsOpt1LPA25
   pndJLoJoV5LGu2s25Azfv2LRVXCSB+P9emx7q+/QC5MYXNCDsMhf/V6LI
   cBvSBteKjHmo8TkdtXMubyHvX1ItYiZ1lpSITRxAE9Etf7jkB9jY45Qrp
   /8BrfOq3uYn8PfhoEtH3uyD8ZizcTQ5E0dzWRtTz55OOV0sijYR0p/BLh
   4rfrt3VqE2fkoDVw0B4ZVQmr/iOZKMH3JqlXJmCDe23wJjUH/+4UeA/kU
   Q==;
X-CSE-ConnectionGUID: JcSgIhCGSAiuJn2mYR01ug==
X-CSE-MsgGUID: cdI5TglwSNeiIhdVO9Fv7w==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="77154102"
X-IronPort-AV: E=Sophos;i="6.20,215,1758610800"; 
   d="scan'208";a="77154102"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 22:09:05 -0800
X-CSE-ConnectionGUID: ibcPd2pKQRqisE+/9juuYQ==
X-CSE-MsgGUID: SRw66EwuTX6+sLM5L7juTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,215,1758610800"; 
   d="scan'208";a="195889120"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.241.55]) ([10.124.241.55])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 22:09:03 -0800
Message-ID: <9098c603-70c0-4a22-a27b-4917ec0601d9@linux.intel.com>
Date: Fri, 21 Nov 2025 14:09:00 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] KVM: VMX: Handle #MCs on VM-Enter/TD-Enter outside
 of the fastpath
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov"
 <kas@kernel.org>, kvm@vger.kernel.org, x86@kernel.org,
 linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Jon Kohler <jon@nutanix.com>,
 Tony Lindgren <tony.lindgren@linux.intel.com>
References: <20251118222328.2265758-1-seanjc@google.com>
 <20251118222328.2265758-3-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251118222328.2265758-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/19/2025 6:23 AM, Sean Christopherson wrote:
> Handle Machine Checks (#MC) that happen on VM-Enter (VMX or TDX) outside
> of KVM's fastpath so that as much host state as possible is re-loaded
> before invoking the kernel's #MC handler.  The only requirement is that
> KVM invokes the #MC handler before enabling IRQs (and even that could
> _probably_ be related to handling #MCs before enabling preemption).
>
> Waiting to handle #MCs until "more" host state is loaded hardens KVM
> against flaws in the #MC handler, which has historically been quite
> brittle. E.g. prior to commit 5567d11c21a1 ("x86/mce: Send #MC singal from
> task work"), the #MC code could trigger a schedule() with IRQs and
> preemption disabled.  That led to a KVM hack-a-fix in commit 1811d979c716
> ("x86/kvm: move kvm_load/put_guest_xcr0 into atomic context").
>
> Note, vmx_handle_exit_irqoff() is common to VMX and TDX guests.
>
> Cc: Tony Lindgren <tony.lindgren@linux.intel.com>
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Cc: Jon Kohler <jon@nutanix.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/tdx.c |  3 ---
>   arch/x86/kvm/vmx/vmx.c | 16 +++++++++++-----
>   2 files changed, 11 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index e6105a527372..2d7a4d52ccfb 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1110,9 +1110,6 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
>   	if (unlikely((tdx->vp_enter_ret & TDX_SW_ERROR) == TDX_SW_ERROR))
>   		return EXIT_FASTPATH_NONE;
>   
> -	if (unlikely(vmx_get_exit_reason(vcpu).basic == EXIT_REASON_MCE_DURING_VMENTRY))
> -		kvm_machine_check();
> -
>   	trace_kvm_exit(vcpu, KVM_ISA_VMX);
>   
>   	if (unlikely(tdx_failed_vmentry(vcpu)))
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index fdcc519348cd..f369c499b2c3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7062,10 +7062,19 @@ void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)

I think the bug in v1 is because the fact that the function is the common path
for both VMX and TDX is overlooked. Do you think it is worth a comment to
tell the function is the common path for both VMX and TDX?

Otherwise,
Reviewed-by: Binbin Wu <binbin.wu@linxu.intel.com>


>   	if (to_vt(vcpu)->emulation_required)
>   		return;
>   
> -	if (vmx_get_exit_reason(vcpu).basic == EXIT_REASON_EXTERNAL_INTERRUPT)
> +	switch (vmx_get_exit_reason(vcpu).basic) {
> +	case EXIT_REASON_EXTERNAL_INTERRUPT:
>   		handle_external_interrupt_irqoff(vcpu, vmx_get_intr_info(vcpu));
> -	else if (vmx_get_exit_reason(vcpu).basic == EXIT_REASON_EXCEPTION_NMI)
> +		break;
> +	case EXIT_REASON_EXCEPTION_NMI:
>   		handle_exception_irqoff(vcpu, vmx_get_intr_info(vcpu));
> +		break;
> +	case EXIT_REASON_MCE_DURING_VMENTRY:
> +		kvm_machine_check();
> +		break;
> +	default:
> +		break;
> +	}
>   }
>   
>   /*
> @@ -7528,9 +7537,6 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
>   	if (unlikely(vmx->fail))
>   		return EXIT_FASTPATH_NONE;
>   
> -	if (unlikely((u16)vmx_get_exit_reason(vcpu).basic == EXIT_REASON_MCE_DURING_VMENTRY))
> -		kvm_machine_check();
> -
>   	trace_kvm_exit(vcpu, KVM_ISA_VMX);
>   
>   	if (unlikely(vmx_get_exit_reason(vcpu).failed_vmentry))


