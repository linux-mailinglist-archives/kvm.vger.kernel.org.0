Return-Path: <kvm+bounces-40585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 88E0EA58CE5
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 08:28:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5023169348
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 07:28:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B8B71D7E5C;
	Mon, 10 Mar 2025 07:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l4M6tjjF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD97347B4;
	Mon, 10 Mar 2025 07:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741591719; cv=none; b=Cc0cwAK0JDQfAkr4UOH3IFjVPYzhX6ol6PXxS/dHqqxWvUV3gh1GNwbYqcKmDb1SrYIJM4moFEt8gr2CENs2NLXOrhczuNz1m25c+Qi4J0WOzN8etVuZpJm7WyAaqIZO8oOH9Uw1PVyB/R7KroHadwnt03ADTL4Y7oZk+TIvzq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741591719; c=relaxed/simple;
	bh=1g5F+A1cBRXVc1hiVX4P5/HWsys7JL9H0jyHVwU6T2Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qB7z7g9Io08aJlIiLSED9LTjiWCpOv5VDf5W9mcbmBcc0f2CbSyNoKM/Zmxxb7GiXuIlKVx2HSmKk3lkGrsDvNYYeRvzzu1fzIV1xfvKy5LWFExqUn5+vAVLo6qEPgnv3GknhL1mWjaG0McS1y4JQbbtp/oX/OuDBCD2iwqJPKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l4M6tjjF; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741591718; x=1773127718;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1g5F+A1cBRXVc1hiVX4P5/HWsys7JL9H0jyHVwU6T2Q=;
  b=l4M6tjjFiXCJt7S0t89Khv9kDCKSH8Ijr7y+SLdQkqDbawL+ITs/JnD6
   ZfZL9NUvoDcE9FMvDoJ5AX2Dl11rQltyfx6oZMJWulpnIbXXVrMY3/YDA
   4XkaRcXOPPfk/nUXlk/0TLkod+TfWm4vRCpXry2geEExNlMdI501vWPEf
   NrEjs0BqXbgXUFxxKPV+d3pSQRbHaUKSzd4ivfWiDlAFZfRMus/9SJXYt
   c1UimNJD5UYEZp8p19mHPYEX8SFrUMzHIb4i9GA/B4fUDI7jIVftDMkew
   +XCiLfFNlJNFFBWOAA5AXC9N0mSzlsGngJ6TSWm/MguF17qH9wN5XE/Zt
   w==;
X-CSE-ConnectionGUID: 1V3TB6CQRzaTSeon5MTCEw==
X-CSE-MsgGUID: 8nQfB0bJQhucJWcSSa0GEg==
X-IronPort-AV: E=McAfee;i="6700,10204,11368"; a="46219362"
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="46219362"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 00:28:37 -0700
X-CSE-ConnectionGUID: RhJG3G7RQdGEhvRarNRaTg==
X-CSE-MsgGUID: vmNY4aaCRemkotsM1388SA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="124508676"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 00:28:34 -0700
Message-ID: <85ed4258-6a8e-4820-8627-29fff61572d2@intel.com>
Date: Mon, 10 Mar 2025 15:28:30 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/10] KVM: TDX: Save and restore IA32_DEBUGCTL
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: adrian.hunter@intel.com, seanjc@google.com, rick.p.edgecombe@intel.com
References: <20250307212053.2948340-1-pbonzini@redhat.com>
 <20250307212053.2948340-10-pbonzini@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250307212053.2948340-10-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/8/2025 5:20 AM, Paolo Bonzini wrote:
> From: Adrian Hunter <adrian.hunter@intel.com>
> 
> Save the IA32_DEBUGCTL MSR before entering a TDX VCPU and restore it
> afterwards.  The TDX Module preserves bits 1, 12, and 14, so if no
> other bits are set, no restore is done.

Reviewed-by: Xiayao Li <xiaoyao.li@intel.com>

> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Message-ID: <20250129095902.16391-12-adrian.hunter@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 5625b0801ce8..25972e12504b 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -683,6 +683,8 @@ void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>   	else
>   		vt->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
>   
> +	vt->host_debugctlmsr = get_debugctlmsr();
> +
>   	vt->guest_state_loaded = true;
>   }
>   
> @@ -826,11 +828,15 @@ static void tdx_load_host_xsave_state(struct kvm_vcpu *vcpu)
>   	if (kvm_host.xss != (kvm_tdx->xfam & kvm_caps.supported_xss))
>   		wrmsrl(MSR_IA32_XSS, kvm_host.xss);
>   }
> -EXPORT_SYMBOL_GPL(kvm_load_host_xsave_state);

This needs to be cleaned up in patch 05;

> +
> +#define TDX_DEBUGCTL_PRESERVED (DEBUGCTLMSR_BTF | \
> +				DEBUGCTLMSR_FREEZE_PERFMON_ON_PMI | \
> +				DEBUGCTLMSR_FREEZE_IN_SMM)
>   
>   fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>   {
>   	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +	struct vcpu_vt *vt = to_vt(vcpu);
>   
>   	/*
>   	 * force_immediate_exit requires vCPU entering for events injection with
> @@ -846,6 +852,9 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>   
>   	tdx_vcpu_enter_exit(vcpu);
>   
> +	if (vt->host_debugctlmsr & ~TDX_DEBUGCTL_PRESERVED)
> +		update_debugctlmsr(vt->host_debugctlmsr);
> +
>   	tdx_load_host_xsave_state(vcpu);
>   	tdx->guest_entered = true;
>   


