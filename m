Return-Path: <kvm+bounces-13819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FD3189AE26
	for <lists+kvm@lfdr.de>; Sun,  7 Apr 2024 05:03:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CA255B220FA
	for <lists+kvm@lfdr.de>; Sun,  7 Apr 2024 03:03:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18DE23D7A;
	Sun,  7 Apr 2024 03:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KA7sVjua"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA9417F0;
	Sun,  7 Apr 2024 03:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712458981; cv=none; b=RCg/orTDcaEmt++86EKbHewpCzp+CXO/sR41eyjprfvZ9IKJwYcHXTshQxnImnxMmMJppIZP3MUYMSU2rWoIo+BIWHcgdy90tBdA6d8IExbGZCFv3BdoS+cwPPRQ210I5DTNJOYcAgMykM7hzL0J4sxUkDuk43TBhvnla3zEAks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712458981; c=relaxed/simple;
	bh=GW6ONfdun9nFNlvt2ESofYOnMbxy3PNCN+5Cdnzb+vY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q2aJ6Aoi4dow0k6OvQx1+BnuxMkXju/zqGGzmsOJkrO5bVkhKiQO4TO4iKxvFAGDxJuYnyII57CbbKdHsfbnz7JlwFqzw8YKbNwSQTSQNxc9WtuGmWH1jBy2AfKHBMbokErRLGRvzPnIi61hFkCMdH/dbtnSSsDtMFh/AxGEnOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KA7sVjua; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712458980; x=1743994980;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GW6ONfdun9nFNlvt2ESofYOnMbxy3PNCN+5Cdnzb+vY=;
  b=KA7sVjuaKaPzEhJV3o5inR6LgttBDQv7aQ5tuhWLeD2tc8JuIzaNiugq
   huHuPd0GCY+HWvI5IkhCfqzgRDR3/IpzWWPiJxWraHVY/bDAiO7/mid8A
   CXw3kTLyPjRCVdH8YGDkxlMJIGuA4iDVlD5t4Ypnx7tRPSFyEqqjFsYAR
   ElUNI+YpaMM+N6rKPukBl8kwUxvx8I0V055g/Ur5MnBPuZ+cfoy/dlpnJ
   yfacKVfyCiSSDarYsubeUh0KWsldpyAYqgubxWlIUe80PJkZP7/Rc2i8c
   vebxqBrYsK0EPaD/DVNi29jfaAgljNx0AffPk1FYUUW0OtqRYV/QVfA2e
   A==;
X-CSE-ConnectionGUID: QPHRuZ5LQseDRBXeDaXdTg==
X-CSE-MsgGUID: tt5I0zp6TqCKnc+4JCpmHQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11036"; a="7635217"
X-IronPort-AV: E=Sophos;i="6.07,184,1708416000"; 
   d="scan'208";a="7635217"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2024 20:02:59 -0700
X-CSE-ConnectionGUID: 1Iw+YbNAQoyS4Cbjm0LK4Q==
X-CSE-MsgGUID: fIrKd7a/QCq77YtIIBLM0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,184,1708416000"; 
   d="scan'208";a="24216059"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.236.140]) ([10.124.236.140])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2024 20:02:56 -0700
Message-ID: <8132ddff-16f3-482f-b08b-a73aa8eddbbc@linux.intel.com>
Date: Sun, 7 Apr 2024 11:02:52 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 079/130] KVM: TDX: vcpu_run: save/restore host
 state(host kernel gs)
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <4a766983346b2c01e943348af3c5ca6691e272f9.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <4a766983346b2c01e943348af3c5ca6691e272f9.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> On entering/exiting TDX vcpu, Preserved or clobbered CPU state is different
> from VMX case.

Could you add more descriptions about the differences?

> Add TDX hooks to save/restore host/guest CPU state.

KVM doesn't save/restore guest CPU state for TDX.

> Save/restore kernel GS base MSR.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/vmx/main.c    | 30 +++++++++++++++++++++++++--
>   arch/x86/kvm/vmx/tdx.c     | 42 ++++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/tdx.h     |  4 ++++
>   arch/x86/kvm/vmx/x86_ops.h |  4 ++++
>   4 files changed, 78 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index d72651ce99ac..8275a242ce07 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -158,6 +158,32 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   	vmx_vcpu_reset(vcpu, init_event);
>   }
>   
> +static void vt_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * All host state is saved/restored across SEAMCALL/SEAMRET,

It sounds confusing to me.
If all host states are saved/restored across SEAMCALL/SEAMRET, why this 
patch saves/restores MSR_KERNEL_GS_BASE for host?

>   and the
> +	 * guest state of a TD is obviously off limits.  Deferring MSRs and DRs
> +	 * is pointless because the TDX module needs to load *something* so as
> +	 * not to expose guest state.
> +	 */
> +	if (is_td_vcpu(vcpu)) {
> +		tdx_prepare_switch_to_guest(vcpu);
> +		return;
> +	}
> +
> +	vmx_prepare_switch_to_guest(vcpu);
> +}
> +
> +static void vt_vcpu_put(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu)) {
> +		tdx_vcpu_put(vcpu);
> +		return;
> +	}
> +
> +	vmx_vcpu_put(vcpu);
> +}
> +
>   static int vt_vcpu_pre_run(struct kvm_vcpu *vcpu)
>   {
>   	if (is_td_vcpu(vcpu))
> @@ -326,9 +352,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.vcpu_free = vt_vcpu_free,
>   	.vcpu_reset = vt_vcpu_reset,
>   
> -	.prepare_switch_to_guest = vmx_prepare_switch_to_guest,
> +	.prepare_switch_to_guest = vt_prepare_switch_to_guest,
>   	.vcpu_load = vmx_vcpu_load,
> -	.vcpu_put = vmx_vcpu_put,
> +	.vcpu_put = vt_vcpu_put,
>   
>   	.update_exception_bitmap = vmx_update_exception_bitmap,
>   	.get_msr_feature = vmx_get_msr_feature,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index fdf9196cb592..9616b1aab6ce 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1,5 +1,6 @@
>   // SPDX-License-Identifier: GPL-2.0
>   #include <linux/cpu.h>
> +#include <linux/mmu_context.h>
>   
>   #include <asm/tdx.h>
>   
> @@ -423,6 +424,7 @@ u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>   int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
>   
>   	WARN_ON_ONCE(vcpu->arch.cpuid_entries);
>   	WARN_ON_ONCE(vcpu->arch.cpuid_nent);
> @@ -446,9 +448,47 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>   	if ((kvm_tdx->xfam & XFEATURE_MASK_XTILE) == XFEATURE_MASK_XTILE)
>   		vcpu->arch.xfd_no_write_intercept = true;
>   
> +	tdx->host_state_need_save = true;
> +	tdx->host_state_need_restore = false;
> +
>   	return 0;
>   }
>   
> +void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)

Just like vmx_prepare_switch_to_host(), the input can be "struct 
vcpu_tdx *", since vcpu is not used inside the function.
And the callsites just use "to_tdx(vcpu)"

> +{
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
Then, this can be dropped.

> +
> +	if (!tdx->host_state_need_save)
> +		return;
> +
> +	if (likely(is_64bit_mm(current->mm)))
> +		tdx->msr_host_kernel_gs_base = current->thread.gsbase;
> +	else
> +		tdx->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
> +
> +	tdx->host_state_need_save = false;
> +}
> +
> +static void tdx_prepare_switch_to_host(struct kvm_vcpu *vcpu)

ditto

> +{
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +
> +	tdx->host_state_need_save = true;
> +	if (!tdx->host_state_need_restore)
> +		return;
> +
> +	++vcpu->stat.host_state_reload;
> +
> +	wrmsrl(MSR_KERNEL_GS_BASE, tdx->msr_host_kernel_gs_base);
> +	tdx->host_state_need_restore = false;
> +}
> +
> +void tdx_vcpu_put(struct kvm_vcpu *vcpu)
> +{
> +	vmx_vcpu_pi_put(vcpu);
> +	tdx_prepare_switch_to_host(vcpu);
> +}
> +
>   void tdx_vcpu_free(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_tdx *tdx = to_tdx(vcpu);
> @@ -569,6 +609,8 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
>   
>   	tdx_vcpu_enter_exit(tdx);
>   
> +	tdx->host_state_need_restore = true;
> +
>   	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
>   	trace_kvm_exit(vcpu, KVM_ISA_VMX);
>   
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 81d301fbe638..e96c416e73bf 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -69,6 +69,10 @@ struct vcpu_tdx {
>   
>   	bool initialized;
>   
> +	bool host_state_need_save;
> +	bool host_state_need_restore;
> +	u64 msr_host_kernel_gs_base;
> +
>   	/*
>   	 * Dummy to make pmu_intel not corrupt memory.
>   	 * TODO: Support PMU for TDX.  Future work.
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 3e29a6fe28ef..9fd997c79c33 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -151,6 +151,8 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu);
>   void tdx_vcpu_free(struct kvm_vcpu *vcpu);
>   void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
>   fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu);
> +void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
> +void tdx_vcpu_put(struct kvm_vcpu *vcpu);
>   u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
>   
>   int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
> @@ -186,6 +188,8 @@ static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
>   static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
>   static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
>   static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu) { return EXIT_FASTPATH_NONE; }
> +static inline void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu) {}
> +static inline void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
>   static inline u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio) { return 0; }
>   
>   static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }


