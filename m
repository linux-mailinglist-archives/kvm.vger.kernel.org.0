Return-Path: <kvm+bounces-32340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D6AF9D5917
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 06:24:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D35231F22C53
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 05:24:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77EBB16A382;
	Fri, 22 Nov 2024 05:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SzX0d1fS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B63023B0;
	Fri, 22 Nov 2024 05:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732253043; cv=none; b=l9cy+uQXqgGBZ3WCFe7LLIr+3+SrX96LBZ4+B+m2qWQWI6GBDxrkfQ0EAu1qXwkkRZonAvVlIpfj92SmD1ZDGpEjhoBoVzjt5ryljh1R6NZrVjHvxTEdWmoS2MJrvInrCRSa/K4UYdyGN8ljnPOphQZDbP57yTg4ZCxBsxvlm/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732253043; c=relaxed/simple;
	bh=NjsUMY58smocg7uIAIT9o4mibbqm8V1Rdt+BXDoNibI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H6LKlQ7VZ29aUbnK94tAGztP7m0fRBABUcgrgOsoHSkycC5XyZLU/oyxDaTQ1A6Vn8VEXwN0WTIkC8nrupNjGy4q39XJKrvC6mUpHOQB9YTjbXo4OaRkyFEhaYlvcAgzmkzKyKNEMhRVVIlgUNen1PTN00FWxLm1rkn+NYlW7Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SzX0d1fS; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732253041; x=1763789041;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NjsUMY58smocg7uIAIT9o4mibbqm8V1Rdt+BXDoNibI=;
  b=SzX0d1fS328OTN08evOTUc3imc4bRJ8E/+BTnfOauOACDqh1l5COcEVS
   oZcsw3NawA3wgglEbpwZ2GGRZEEF3gvOLvX35BTL3/S/evkmVVaVjpRdi
   ViQWAdDlCaUjrNoMkv7GD++4yCSU3CtdXHXZGFxwKHVYzDMIU0ji2qOZk
   Ej/kG/ZC9mQKzPwx6Del9y8qw9xi/9hh9j46ShbDqXAjJ2sw3n07TSgK2
   nFbmN7WlA1D5Bsr3G3PI64tymCpzlFN/vYiLy9KWAolryEyOu0yqlQ31V
   MhivoGJXCY91ruQBTJiMnePLZftTtOUzPppjlNc13e1ZhKgeyxTAapmjF
   w==;
X-CSE-ConnectionGUID: fDW11BI7RcO/M0u1nuGzfw==
X-CSE-MsgGUID: WodUieqMSECw2zEu0dwI/w==
X-IronPort-AV: E=McAfee;i="6700,10204,11263"; a="43039768"
X-IronPort-AV: E=Sophos;i="6.12,174,1728975600"; 
   d="scan'208";a="43039768"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 21:24:01 -0800
X-CSE-ConnectionGUID: qoJXfrFpQK2+JnkDR+Jw1g==
X-CSE-MsgGUID: GktFVzpVRiiCpp7R2F8FCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,174,1728975600"; 
   d="scan'208";a="113752049"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 21:23:56 -0800
Message-ID: <2f22aeeb-7109-4d3f-bcb7-58ef7f8e0d4c@intel.com>
Date: Fri, 22 Nov 2024 13:23:54 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] KVM: TDX: Implement TDX vcpu enter/exit path
To: Adrian Hunter <adrian.hunter@intel.com>, pbonzini@redhat.com,
 seanjc@google.com, kvm@vger.kernel.org, dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 binbin.wu@linux.intel.com, dmatlack@google.com, isaku.yamahata@intel.com,
 nik.borisov@suse.com, linux-kernel@vger.kernel.org, x86@kernel.org,
 yan.y.zhao@intel.com, chao.gao@intel.com, weijiang.yang@intel.com
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-3-adrian.hunter@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20241121201448.36170-3-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/22/2024 4:14 AM, Adrian Hunter wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> This patch implements running TDX vcpu.  Once vcpu runs on the logical
> processor (LP), the TDX vcpu is associated with it.  When the TDX vcpu
> moves to another LP, the TDX vcpu needs to flush its status on the LP.
> When destroying TDX vcpu, it needs to complete flush, and flush cpu memory
> cache.  Track which LP the TDX vcpu run and flush it as necessary.

The changelog needs update. It doesn't match the patch content.

> Compared to VMX, do nothing on sched_in event as TDX doesn't support pause
> loop.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
> TD vcpu enter/exit v1:
> - Make argument of tdx_vcpu_enter_exit() struct kvm_vcpu.
> - Update for the wrapper functions for SEAMCALLs. (Sean)
> - Remove noinstr (Sean)
> - Add a missing comma, clarify sched_in part, and update changelog to
>    match code by dropping the PMU related paragraph (Binbin)
>    https://lore.kernel.org/lkml/c0029d4d-3dee-4f11-a929-d64d2651bfb3@linux.intel.com/
> - Remove the union tdx_exit_reason. (Sean)
>    https://lore.kernel.org/kvm/ZfSExlemFMKjBtZb@google.com/
> - Remove the code of special handling of vcpu->kvm->vm_bugged (Rick)
>    https://lore.kernel.org/kvm/20240318234010.GD1645738@ls.amr.corp.intel.com/
> - For !tdx->initialized case, set tdx->vp_enter_ret to TDX_SW_ERROR to avoid
>    collision with EXIT_REASON_EXCEPTION_NMI.
> 
> v19:
> - Removed export_symbol_gpl(host_xcr0) to the patch that uses it
> 
> Changes v15 -> v16:
> - use __seamcall_saved_ret()
> - As struct tdx_module_args doesn't match with vcpu.arch.regs, copy regs
>    before/after calling __seamcall_saved_ret().
> ---
>   arch/x86/kvm/vmx/main.c    | 21 ++++++++++-
>   arch/x86/kvm/vmx/tdx.c     | 76 ++++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/tdx.h     |  2 +
>   arch/x86/kvm/vmx/x86_ops.h |  5 +++
>   4 files changed, 102 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index bfed421e6fbb..44ec6005a448 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -129,6 +129,23 @@ static void vt_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   	vmx_vcpu_load(vcpu, cpu);
>   }
>   
> +static int vt_vcpu_pre_run(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		/* Unconditionally continue to vcpu_run(). */
> +		return 1;
> +
> +	return vmx_vcpu_pre_run(vcpu);
> +}
> +
> +static fastpath_t vt_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return tdx_vcpu_run(vcpu, force_immediate_exit);
> +
> +	return vmx_vcpu_run(vcpu, force_immediate_exit);
> +}
> +
>   static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
>   {
>   	if (is_td_vcpu(vcpu)) {
> @@ -267,8 +284,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.flush_tlb_gva = vt_flush_tlb_gva,
>   	.flush_tlb_guest = vt_flush_tlb_guest,
>   
> -	.vcpu_pre_run = vmx_vcpu_pre_run,
> -	.vcpu_run = vmx_vcpu_run,
> +	.vcpu_pre_run = vt_vcpu_pre_run,
> +	.vcpu_run = vt_vcpu_run,
>   	.handle_exit = vmx_handle_exit,
>   	.skip_emulated_instruction = vmx_skip_emulated_instruction,
>   	.update_emulated_instruction = vmx_update_emulated_instruction,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index dc6c5f40608e..5fa5b65b9588 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -10,6 +10,9 @@
>   #include "mmu/spte.h"
>   #include "common.h"
>   
> +#include <trace/events/kvm.h>
> +#include "trace.h"
> +
>   #undef pr_fmt
>   #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>   
> @@ -662,6 +665,79 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu)
>   }
>   
>   
> +static void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +	struct tdx_module_args args;
> +
> +	guest_state_enter_irqoff();
> +
> +	/*
> +	 * TODO: optimization:
> +	 * - Eliminate copy between args and vcpu->arch.regs.
> +	 * - copyin/copyout registers only if (tdx->tdvmvall.regs_mask != 0)
> +	 *   which means TDG.VP.VMCALL.
> +	 */
> +	args = (struct tdx_module_args) {
> +		.rcx = tdx->tdvpr_pa,
> +#define REG(reg, REG)	.reg = vcpu->arch.regs[VCPU_REGS_ ## REG]
> +		REG(rdx, RDX),
> +		REG(r8,  R8),
> +		REG(r9,  R9),
> +		REG(r10, R10),
> +		REG(r11, R11),
> +		REG(r12, R12),
> +		REG(r13, R13),
> +		REG(r14, R14),
> +		REG(r15, R15),
> +		REG(rbx, RBX),
> +		REG(rdi, RDI),
> +		REG(rsi, RSI),
> +#undef REG
> +	};
> +
> +	tdx->vp_enter_ret = tdh_vp_enter(tdx->tdvpr_pa, &args);
> +
> +#define REG(reg, REG)	vcpu->arch.regs[VCPU_REGS_ ## REG] = args.reg
> +	REG(rcx, RCX);
> +	REG(rdx, RDX);
> +	REG(r8,  R8);
> +	REG(r9,  R9);
> +	REG(r10, R10);
> +	REG(r11, R11);
> +	REG(r12, R12);
> +	REG(r13, R13);
> +	REG(r14, R14);
> +	REG(r15, R15);
> +	REG(rbx, RBX);
> +	REG(rdi, RDI);
> +	REG(rsi, RSI);
> +#undef REG
> +
> +	guest_state_exit_irqoff();
> +}
> +
> +fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
> +{
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +
> +	/* TDX exit handle takes care of this error case. */
> +	if (unlikely(tdx->state != VCPU_TD_STATE_INITIALIZED)) {
> +		/* Set to avoid collision with EXIT_REASON_EXCEPTION_NMI. */

It seems the check fits better in tdx_vcpu_pre_run().

And without the patch of how TDX handles Exit (i.e., how deal with 
vp_enter_ret), it's hard to review this comment.

> +		tdx->vp_enter_ret = TDX_SW_ERROR;
> +		return EXIT_FASTPATH_NONE;
> +	}
> +
> +	trace_kvm_entry(vcpu, force_immediate_exit);
> +
> +	tdx_vcpu_enter_exit(vcpu);
> +
> +	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
> +	trace_kvm_exit(vcpu, KVM_ISA_VMX);
> +
> +	return EXIT_FASTPATH_NONE;
> +}
> +
>   void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
>   {
>   	u64 shared_bit = (pgd_level == 5) ? TDX_SHARED_BIT_PWL_5 :
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 899654519df6..ebee1049b08b 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -51,6 +51,8 @@ struct vcpu_tdx {
>   
>   	struct list_head cpu_list;
>   
> +	u64 vp_enter_ret;
> +
>   	enum vcpu_tdx_state state;
>   };
>   
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 06583b1afa4f..3d292a677b92 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -129,6 +129,7 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>   int tdx_vcpu_create(struct kvm_vcpu *vcpu);
>   void tdx_vcpu_free(struct kvm_vcpu *vcpu);
>   void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
> +fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit);
>   
>   int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
>   
> @@ -156,6 +157,10 @@ static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOP
>   static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
>   static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
>   static inline void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
> +static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
> +{
> +	return EXIT_FASTPATH_NONE;
> +}
>   
>   static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
>   


