Return-Path: <kvm+bounces-13823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B5B9589AE55
	for <lists+kvm@lfdr.de>; Sun,  7 Apr 2024 05:47:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7693528268A
	for <lists+kvm@lfdr.de>; Sun,  7 Apr 2024 03:47:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62FBF10A1C;
	Sun,  7 Apr 2024 03:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LierU7u2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A58101C6;
	Sun,  7 Apr 2024 03:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712461627; cv=none; b=LW/5ehzUE2KL2zGOopBFjbZhlPDbcWmeRQUjKkUyMXqAU2lX626xG1+Nctaoe1yuouwe33FZw9l7TUeW58deE4aQV/08+gFhorakUObPz4TuHEQDXyQLV4pbLqCGmtYnpqnmuP7FJwIyyXbjZtoBhO+/tE0gPFzXyHGfUU8L1ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712461627; c=relaxed/simple;
	bh=UYyAN2o2lYJKyFyldlO/qE3sz3B8VwWfcGNbKAx5yCk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eRF2/HwDtiQx+JETpkF0NBySbIolEzO2zIEdKEpGBKdvY0x/yC6X+gksk5ewJfFfCqIL/OW/4APB2uHjmvQjenIJgBiYok06QSM0UuzGTm3IeBhscJL/NWd76yFyWjYSqCRYZbX+YIteujmC1fYuUXK3Th5CoaOMQG6MkDwOqqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LierU7u2; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712461626; x=1743997626;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UYyAN2o2lYJKyFyldlO/qE3sz3B8VwWfcGNbKAx5yCk=;
  b=LierU7u2IO+N4QB5lDfK2AI2DyArBS4xaWgMWxfWbNzVRP3HlDBwfdy4
   qGOMJAChgHAY33T7DKIwkHB960Dnm2MOdG2L2lBluhh2+rvpb8SWw3EWZ
   DvRxGPGsxarjzFJAbyb146wivO6ayFfNXH3hFlWg4ajpnqIxvN5OTQQ09
   sO+7b5y8mcTGxNN0BnTn2nj5aVWVRjx7gW4ASYdtXwrwdFngdfy08fQqp
   lsztb/ezcnbbmLeKAJbhQJ8gpM2CfyOAYJHRbUHfMesKfaQJwWXoI/fkE
   Gjdvbf7mh1DUOqXjRtttUoWMtWXY+OTkAFQc1WaauQkK8v9izhuGSusSi
   A==;
X-CSE-ConnectionGUID: 78ZR2tuYThGGDfa87WqUYA==
X-CSE-MsgGUID: 4zXzT71LQMKr/2BCJoag7Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11036"; a="7880939"
X-IronPort-AV: E=Sophos;i="6.07,184,1708416000"; 
   d="scan'208";a="7880939"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2024 20:47:06 -0700
X-CSE-ConnectionGUID: uBz2GPb5SHSXruuERYiAoQ==
X-CSE-MsgGUID: g4Nfl0DPRki0GVuLZxTE1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,184,1708416000"; 
   d="scan'208";a="24030051"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.236.140]) ([10.124.236.140])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2024 20:47:02 -0700
Message-ID: <57c1a18b-b8b0-4368-99b3-b6ad4ad0e614@linux.intel.com>
Date: Sun, 7 Apr 2024 11:47:00 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 080/130] KVM: TDX: restore host xsave state when exit
 from the guest TD
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <2894ed10014279f4b8caab582e3b7e7061b5dad3.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <2894ed10014279f4b8caab582e3b7e7061b5dad3.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> On exiting from the guest TD, xsave state is clobbered.  Restore xsave
> state on TD exit.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> v19:
> - Add EXPORT_SYMBOL_GPL(host_xcr0)
>
> v15 -> v16:
> - Added CET flag mask
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 19 +++++++++++++++++++
>   arch/x86/kvm/x86.c     |  1 +
>   2 files changed, 20 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 9616b1aab6ce..199226c6cf55 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -2,6 +2,7 @@
>   #include <linux/cpu.h>
>   #include <linux/mmu_context.h>
>   
> +#include <asm/fpu/xcr.h>
>   #include <asm/tdx.h>
>   
>   #include "capabilities.h"
> @@ -534,6 +535,23 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   	 */
>   }
>   
> +static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> +
> +	if (static_cpu_has(X86_FEATURE_XSAVE) &&
> +	    host_xcr0 != (kvm_tdx->xfam & kvm_caps.supported_xcr0))
> +		xsetbv(XCR_XFEATURE_ENABLED_MASK, host_xcr0);
> +	if (static_cpu_has(X86_FEATURE_XSAVES) &&
> +	    /* PT can be exposed to TD guest regardless of KVM's XSS support */
The comment needs to be updated to reflect the case for CET.

> +	    host_xss != (kvm_tdx->xfam &
> +			 (kvm_caps.supported_xss | XFEATURE_MASK_PT | TDX_TD_XFAM_CET)))

For TDX_TD_XFAM_CET, maybe no need to make it TDX specific?

BTW, the definitions for XFEATURE_MASK_CET_USER/XFEATURE_MASK_CET_KERNEL 
have been merged.
https://lore.kernel.org/all/20230613001108.3040476-25-rick.p.edgecombe%40intel.com
You can resolve the TODO in 
https://lore.kernel.org/kvm/5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com/

> +		wrmsrl(MSR_IA32_XSS, host_xss);
> +	if (static_cpu_has(X86_FEATURE_PKU) &&
> +	    (kvm_tdx->xfam & XFEATURE_MASK_PKRU))
> +		write_pkru(vcpu->arch.host_pkru);
> +}
> +
>   static noinstr void tdx_vcpu_enter_exit(struct vcpu_tdx *tdx)
>   {
>   	struct tdx_module_args args;
> @@ -609,6 +627,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
>   
>   	tdx_vcpu_enter_exit(tdx);
>   
> +	tdx_restore_host_xsave_state(vcpu);
>   	tdx->host_state_need_restore = true;
>   
>   	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 23ece956c816..b361d948140f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -315,6 +315,7 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
>   };
>   
>   u64 __read_mostly host_xcr0;
> +EXPORT_SYMBOL_GPL(host_xcr0);
>   
>   static struct kmem_cache *x86_emulator_cache;
>   


