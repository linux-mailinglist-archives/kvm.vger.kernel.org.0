Return-Path: <kvm+bounces-40581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C85F8A58CDA
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 08:24:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 26401168AB3
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 07:24:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2710E1D7E5F;
	Mon, 10 Mar 2025 07:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="flHiQ4KO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C9917BA5;
	Mon, 10 Mar 2025 07:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741591461; cv=none; b=Z3PZlSWz2pIw2+jITe++r+jvPZhu+pVw5mf5NLpPGz4bFk8O+i09pbcdpyyrH/Ec35HzIhwn+1NYFzALb9t5/1tUXjOWjNTOg4EQ+imgkQcqn5Qq8WfK0s8I8D+9ovhVdgOFGKcYZ4k/Rs0q5829f3ZwT7tt9jgHbF+1Qb/Wx18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741591461; c=relaxed/simple;
	bh=s2KVlvf7aOsyX4rM8XmAnc6ILcQMIIfx8RKWz2Liu30=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h+5NsvSj4sHuFBU7PVvBNVExsD7Db+nIGl0mHKd/boJMOHqDWkm4anZntfiBPK+t7jMKMLjEc5QTawEutLWUb9PrQB2zPHbd4x38ABW6hJM3r+mIUBOgvMMk/n2/Fed0PRy6EELmCrL1NOgoVqIQZ9B+NsUqGQ5Et+eHYm/lbtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=flHiQ4KO; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741591459; x=1773127459;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=s2KVlvf7aOsyX4rM8XmAnc6ILcQMIIfx8RKWz2Liu30=;
  b=flHiQ4KOrXL7lGWocP/2/sjrpyU6beEitY2KSuyzBc5IhMSxvl8cP1VR
   DpeINZgLDTMQgzcamhXuwQcAluRAtAm3r3ggKUkytMMFOPsTOfTz/rzZS
   PIuHUJdou3JUJi2t9ixKv0bncTBj6rhNaX422JAKrNUTH71aahYFq+RbQ
   OoTs8mrCYfCnb3KfsV47NVn6nXO3bM80Ul/hTUe/sgWq0wPzq+hE8SHZX
   bldCsjWXGcltXYgNeU5enb0ao01JYCqLbl7LDmXhG1dZpKtBZp65yOjj2
   ZtwV04jSx4a1FAPrZPpPyENvVQbz61HLWBYEAmLsfsddU8DVFVDJMvYBR
   g==;
X-CSE-ConnectionGUID: G8jYTy0NSVCodA3P6TZj8A==
X-CSE-MsgGUID: dH12eqKiStmSiSlQvlfkCQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11368"; a="53560332"
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="53560332"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 00:24:18 -0700
X-CSE-ConnectionGUID: CXJQ/rUjQKSUG4dB8eQ+LQ==
X-CSE-MsgGUID: 11Y7mk/oSDeCEbIxAwzXDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="119902516"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 00:24:16 -0700
Message-ID: <405c30e9-73be-4812-86dc-6791b08ba43c@intel.com>
Date: Mon, 10 Mar 2025 15:24:13 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/10] KVM: TDX: restore host xsave state when exit
 from the guest TD
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: adrian.hunter@intel.com, seanjc@google.com, rick.p.edgecombe@intel.com,
 Isaku Yamahata <isaku.yamahata@intel.com>
References: <20250307212053.2948340-1-pbonzini@redhat.com>
 <20250307212053.2948340-6-pbonzini@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250307212053.2948340-6-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/8/2025 5:20 AM, Paolo Bonzini wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> On exiting from the guest TD, xsave state is clobbered; restore it.

I prefer the implementation as this patch, which is straightforward.
(I would be much better if the changelog can describe more)

Anyway,

Reviewed-by: Xiayao Li <xiaoyao.li@intel.com>

> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Message-ID: <20250129095902.16391-8-adrian.hunter@intel.com>
> [Rewrite to not use kvm_load_host_xsave_state. - Paolo]
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 32 ++++++++++++++++++++++++++++++++
>   1 file changed, 32 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 94e08fdcb775..b2948318cd8b 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -2,6 +2,7 @@
>   #include <linux/cleanup.h>
>   #include <linux/cpu.h>
>   #include <asm/cpufeature.h>
> +#include <asm/fpu/xcr.h>
>   #include <linux/misc_cgroup.h>
>   #include <linux/mmu_context.h>
>   #include <asm/tdx.h>
> @@ -735,6 +736,30 @@ static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu)
>   				 BIT_ULL(VCPU_REGS_R14) | \
>   				 BIT_ULL(VCPU_REGS_R15))
>   
> +static void tdx_load_host_xsave_state(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> +
> +	/*
> +	 * All TDX hosts support PKRU; but even if they didn't,
> +	 * vcpu->arch.host_pkru would be 0 and the wrpkru would be
> +	 * skipped.
> +	 */
> +	if (vcpu->arch.host_pkru != 0)
> +		wrpkru(vcpu->arch.host_pkru);
> +
> +	if (kvm_host.xcr0 != (kvm_tdx->xfam & kvm_caps.supported_xcr0))
> +		xsetbv(XCR_XFEATURE_ENABLED_MASK, kvm_host.xcr0);
> +
> +	/*
> +	 * Likewise, even if a TDX hosts didn't support XSS both arms of
> +	 * the comparison would be 0 and the wrmsrl would be skipped.
> +	 */
> +	if (kvm_host.xss != (kvm_tdx->xfam & kvm_caps.supported_xss))
> +		wrmsrl(MSR_IA32_XSS, kvm_host.xss);
> +}
> +EXPORT_SYMBOL_GPL(kvm_load_host_xsave_state);
> +
>   fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>   {
>   	/*
> @@ -751,6 +776,8 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>   
>   	tdx_vcpu_enter_exit(vcpu);
>   
> +	tdx_load_host_xsave_state(vcpu);
> +
>   	vcpu->arch.regs_avail &= TDX_REGS_AVAIL_SET;
>   
>   	trace_kvm_exit(vcpu, KVM_ISA_VMX);
> @@ -2326,6 +2353,11 @@ int __init tdx_bringup(void)
>   		goto success_disable_tdx;
>   	}
>   
> +	if (!cpu_feature_enabled(X86_FEATURE_OSXSAVE)) {
> +		pr_err("tdx: OSXSAVE is required for TDX\n");
> +		goto success_disable_tdx;
> +	}
> +
>   	if (!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)) {
>   		pr_err("tdx: MOVDIR64B is required for TDX\n");
>   		goto success_disable_tdx;


