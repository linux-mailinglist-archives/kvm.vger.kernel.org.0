Return-Path: <kvm+bounces-40583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 40F7FA58CE0
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 08:26:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F2E8188EBAF
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 07:26:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DCEA1DB14C;
	Mon, 10 Mar 2025 07:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cAid51GL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B096C1CAA70;
	Mon, 10 Mar 2025 07:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741591555; cv=none; b=LfOoPOG0/mwlMTVfZoiHCyRKPwRKdZlYCF5PDesd+vmrfKq//NKQciZYAMuL7KZa0KDxvO8W5v/QwoZ2AyE9VTydCLsuT0NxsAskD2AUo8gtLcNNrNv+5KTg6eTJt9MeV2uu4IR4WaqZbj6CLB/BhD/rUPCpwdUWH7IQ2GSF3OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741591555; c=relaxed/simple;
	bh=nfVcLFd2v8qG68sPEUNYNWeHYnBgkR0NkzyvHa3AYUM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uYCAcIiqQOzfYvHOujzMrzN6cpLE+lg9a9TJfUgaMOrPTDBHJTH1aRyAgC1ZP/RRtHWFqZi01DTZJxdJaNfnuIJSlhxPTu4xcRJbBstnok9s3dbLgUV+iJLnAOhUxvOXtjOreXMTfDsIM3//KFE+qEuyTdWNj715VVi45DdUTHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cAid51GL; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741591553; x=1773127553;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nfVcLFd2v8qG68sPEUNYNWeHYnBgkR0NkzyvHa3AYUM=;
  b=cAid51GLksnF5nAGLh+wDalaIArH0Q1oaXnTdps5xXGHN0EpDdn5ozDP
   SQwXBnEvhZ9BtFH0jWjyUSPcdG1EViHpAIJ+1WPWKoPEx15iAIGS5hjSp
   nA7ymlcfhISSvEXSVFpbWWLtRf9Vtjc8PjvxOqTcL19neku1+GQXcz/nV
   ehSmudOq8wyIINXu0EHPGgsNbZFuzbdU1dXCRz0TFvqzOl0bk9F+90147
   L379MpiP8oYV8pUFWBqtYFU9wXevyDAJFRG6+qO81++XK4uBLnV1JynTg
   gqU3P5vWkxnbx1S4pSk8071gchfk59IxeonZoO0fUA7MtWV4CoG7B6t4I
   Q==;
X-CSE-ConnectionGUID: lTVQpgi4R/WYmtDQ+eEm1Q==
X-CSE-MsgGUID: +Hvgpo1vTri/ndkg3O1cLw==
X-IronPort-AV: E=McAfee;i="6700,10204,11368"; a="60124671"
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="60124671"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 00:25:53 -0700
X-CSE-ConnectionGUID: XJZK86NLTpqpRM94POUMuQ==
X-CSE-MsgGUID: okd1d7SbQ+S1FSOWUB/hpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="120072238"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 00:25:51 -0700
Message-ID: <4dfb1a64-e33f-4c87-a02c-753f918aa9d4@intel.com>
Date: Mon, 10 Mar 2025 15:25:48 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/10] KVM: TDX: restore user ret MSRs
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: adrian.hunter@intel.com, seanjc@google.com, rick.p.edgecombe@intel.com,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Tony Lindgren <tony.lindgren@linux.intel.com>
References: <20250307212053.2948340-1-pbonzini@redhat.com>
 <20250307212053.2948340-8-pbonzini@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250307212053.2948340-8-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/8/2025 5:20 AM, Paolo Bonzini wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Several user ret MSRs are clobbered on TD exit.  Ensure the MSR cache is
> updated on vcpu_put, and the MSRs themselves before returning to ring 3.

Reviewed-by: Xiayao Li <xiaoyao.li@intel.com>

> Co-developed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
> Signed-off-by: Tony Lindgren <tony.lindgren@linux.intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Message-ID: <20250129095902.16391-10-adrian.hunter@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 51 +++++++++++++++++++++++++++++++++++++++++-
>   arch/x86/kvm/vmx/tdx.h |  1 +
>   2 files changed, 51 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index b2948318cd8b..5819ed926166 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -646,9 +646,32 @@ void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>   	vt->guest_state_loaded = true;
>   }
>   
> +struct tdx_uret_msr {
> +	u32 msr;
> +	unsigned int slot;
> +	u64 defval;
> +};
> +
> +static struct tdx_uret_msr tdx_uret_msrs[] = {
> +	{.msr = MSR_SYSCALL_MASK, .defval = 0x20200 },
> +	{.msr = MSR_STAR,},
> +	{.msr = MSR_LSTAR,},
> +	{.msr = MSR_TSC_AUX,},
> +};
> +
> +static void tdx_user_return_msr_update_cache(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++)
> +		kvm_user_return_msr_update_cache(tdx_uret_msrs[i].slot,
> +						 tdx_uret_msrs[i].defval);
> +}
> +
>   static void tdx_prepare_switch_to_host(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_vt *vt = to_vt(vcpu);
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
>   
>   	if (!vt->guest_state_loaded)
>   		return;
> @@ -656,6 +679,11 @@ static void tdx_prepare_switch_to_host(struct kvm_vcpu *vcpu)
>   	++vcpu->stat.host_state_reload;
>   	wrmsrl(MSR_KERNEL_GS_BASE, vt->msr_host_kernel_gs_base);
>   
> +	if (tdx->guest_entered) {
> +		tdx_user_return_msr_update_cache();
> +		tdx->guest_entered = false;
> +	}
> +
>   	vt->guest_state_loaded = false;
>   }
>   
> @@ -762,6 +790,8 @@ EXPORT_SYMBOL_GPL(kvm_load_host_xsave_state);
>   
>   fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>   {
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +
>   	/*
>   	 * force_immediate_exit requires vCPU entering for events injection with
>   	 * an immediately exit followed. But The TDX module doesn't guarantee
> @@ -777,6 +807,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>   	tdx_vcpu_enter_exit(vcpu);
>   
>   	tdx_load_host_xsave_state(vcpu);
> +	tdx->guest_entered = true;
>   
>   	vcpu->arch.regs_avail &= TDX_REGS_AVAIL_SET;
>   
> @@ -2236,7 +2267,25 @@ static int __init __do_tdx_bringup(void)
>   static int __init __tdx_bringup(void)
>   {
>   	const struct tdx_sys_info_td_conf *td_conf;
> -	int r;
> +	int r, i;
> +
> +	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++) {
> +		/*
> +		 * Check if MSRs (tdx_uret_msrs) can be saved/restored
> +		 * before returning to user space.
> +		 *
> +		 * this_cpu_ptr(user_return_msrs)->registered isn't checked
> +		 * because the registration is done at vcpu runtime by
> +		 * tdx_user_return_msr_update_cache().
> +		 */
> +		tdx_uret_msrs[i].slot = kvm_find_user_return_msr(tdx_uret_msrs[i].msr);
> +		if (tdx_uret_msrs[i].slot == -1) {
> +			/* If any MSR isn't supported, it is a KVM bug */
> +			pr_err("MSR %x isn't included by kvm_find_user_return_msr\n",
> +				tdx_uret_msrs[i].msr);
> +			return -EIO;
> +		}
> +	}
>   
>   	/*
>   	 * Enabling TDX requires enabling hardware virtualization first,
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 6eb24bbacccc..55af3d866ff6 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -56,6 +56,7 @@ struct vcpu_tdx {
>   	u64 vp_enter_ret;
>   
>   	enum vcpu_tdx_state state;
> +	bool guest_entered;
>   };
>   
>   void tdh_vp_rd_failed(struct vcpu_tdx *tdx, char *uclass, u32 field, u64 err);


