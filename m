Return-Path: <kvm+bounces-67326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C021D00CA5
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 04:08:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A51D6303831B
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 03:07:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 964462853FD;
	Thu,  8 Jan 2026 03:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B/xJ5KUY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BE928030E;
	Thu,  8 Jan 2026 03:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767841634; cv=none; b=IEsJPiUEvwcWCDAlJ0QruzL82UMo/SUwc/8Vi7tXGeByBaZIe3/YSrFjtQfPWSy8RbCj8G9A00kznGFD672+yMz0+4wbpUCZ14TfIukBFqqoBjaCEQYvsHPwa18GzMbV9k6aVxmq5SMKuzcAcUq/92ypmgXywU4hzo5d8N83omk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767841634; c=relaxed/simple;
	bh=A1EDVql3T0qVgDPncFKxMzWgwRWKWjDnLmwzTqzTTKc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d126Nk6fo70ZBQs+MLSHHjqM54H/pF7+Aj73/7ztefvK2gm+riFe/dQe13NU3x2n4cX7dMOrcFeK5JJ84FiOYVjv4AOFqmv+gouS4++zUVHOkFFfGUMZReUfumiZ9jcGCh37VHEBMav0T0Jnky/140x4PFEXovuG5ewzYJ2acRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B/xJ5KUY; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767841633; x=1799377633;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=A1EDVql3T0qVgDPncFKxMzWgwRWKWjDnLmwzTqzTTKc=;
  b=B/xJ5KUYzvXkjEhjX4L7xNU0+qdAoqXADb8l+S0t716gGjj6h+r8oBeI
   XfpobAftbKMGFkFkbM7MMa6LZvCgjv1sEPAHb1H9Rv3djOeSX6QFJBPft
   X3AfpXfL9aGIQM9pss1YGXO8EpO8Qbllvz2r9/b2PYRHmXNHFb/m0GWLJ
   Ojtfs/Q1UY7v6TeWKL4RVp88fp1YAv3tAyNkD/O14YO7QvJFj2n5BC8Vg
   suOUwbx7pi3RoYNRAQtXUtzeR2zvEllU0YfNuB1W3/7ASx8xFY/+rTLhm
   J3bVUvNVFt+sthWhmkReF8ZZhRfk2zFVzm3W8fCkJ5Fc9P0WZ6SV7DJ8N
   w==;
X-CSE-ConnectionGUID: OfMRZumUSmyTZjzHFIkBpA==
X-CSE-MsgGUID: 564hM75VQkGcTEaBDcutNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="91877202"
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="91877202"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 19:07:12 -0800
X-CSE-ConnectionGUID: SpVqtqJKT/WJ/2JUetxXlg==
X-CSE-MsgGUID: JdiG3z9TQZuPUZfpUCpQEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="203105769"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.240.233]) ([10.124.240.233])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 19:07:10 -0800
Message-ID: <959b98b1-fbc4-4515-bc7c-8c146c6c8529@linux.intel.com>
Date: Thu, 8 Jan 2026 11:06:56 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] x86/fpu: Clear XSTATE_BV[i] in save state whenever
 XFD[i]=1
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com,
 x86@kernel.org, stable@vger.kernel.org
References: <20260101090516.316883-1-pbonzini@redhat.com>
 <20260101090516.316883-2-pbonzini@redhat.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260101090516.316883-2-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/1/2026 5:05 PM, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> When loading guest XSAVE state via KVM_SET_XSAVE, and when updating XFD in
> response to a guest WRMSR, clear XFD-disabled features in the saved (or to
> be restored) XSTATE_BV to ensure KVM doesn't attempt to load state for
> features that are disabled via the guest's XFD.  Because the kernel
> executes XRSTOR with the guest's XFD, saving XSTATE_BV[i]=1 with XFD[i]=1
> will cause XRSTOR to #NM and panic the kernel.
> 
> E.g. if fpu_update_guest_xfd() sets XFD without clearing XSTATE_BV:
> 
>   ------------[ cut here ]------------
>   WARNING: arch/x86/kernel/traps.c:1524 at exc_device_not_available+0x101/0x110, CPU#29: amx_test/848
>   Modules linked in: kvm_intel kvm irqbypass
>   CPU: 29 UID: 1000 PID: 848 Comm: amx_test Not tainted 6.19.0-rc2-ffa07f7fd437-x86_amx_nm_xfd_non_init-vm #171 NONE
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>   RIP: 0010:exc_device_not_available+0x101/0x110
>   Call Trace:
>    <TASK>
>    asm_exc_device_not_available+0x1a/0x20
>   RIP: 0010:restore_fpregs_from_fpstate+0x36/0x90
>    switch_fpu_return+0x4a/0xb0
>    kvm_arch_vcpu_ioctl_run+0x1245/0x1e40 [kvm]
>    kvm_vcpu_ioctl+0x2c3/0x8f0 [kvm]
>    __x64_sys_ioctl+0x8f/0xd0
>    do_syscall_64+0x62/0x940
>    entry_SYSCALL_64_after_hwframe+0x4b/0x53
>    </TASK>
>   ---[ end trace 0000000000000000 ]---
> 
> This can happen if the guest executes WRMSR(MSR_IA32_XFD) to set XFD[18] = 1,
> and a host IRQ triggers kernel_fpu_begin() prior to the vmexit handler's
> call to fpu_update_guest_xfd().
> 
> and if userspace stuffs XSTATE_BV[i]=1 via KVM_SET_XSAVE:
> 
>   ------------[ cut here ]------------
>   WARNING: arch/x86/kernel/traps.c:1524 at exc_device_not_available+0x101/0x110, CPU#14: amx_test/867
>   Modules linked in: kvm_intel kvm irqbypass
>   CPU: 14 UID: 1000 PID: 867 Comm: amx_test Not tainted 6.19.0-rc2-2dace9faccd6-x86_amx_nm_xfd_non_init-vm #168 NONE
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>   RIP: 0010:exc_device_not_available+0x101/0x110
>   Call Trace:
>    <TASK>
>    asm_exc_device_not_available+0x1a/0x20
>   RIP: 0010:restore_fpregs_from_fpstate+0x36/0x90
>    fpu_swap_kvm_fpstate+0x6b/0x120
>    kvm_load_guest_fpu+0x30/0x80 [kvm]
>    kvm_arch_vcpu_ioctl_run+0x85/0x1e40 [kvm]
>    kvm_vcpu_ioctl+0x2c3/0x8f0 [kvm]
>    __x64_sys_ioctl+0x8f/0xd0
>    do_syscall_64+0x62/0x940
>    entry_SYSCALL_64_after_hwframe+0x4b/0x53
>    </TASK>
>   ---[ end trace 0000000000000000 ]---
> 
> The new behavior is consistent with the AMX architecture.  Per Intel's SDM,
> XSAVE saves XSTATE_BV as '0' for components that are disabled via XFD
> (and non-compacted XSAVE saves the initial configuration of the state
> component):
> 
>   If XSAVE, XSAVEC, XSAVEOPT, or XSAVES is saving the state component i,
>   the instruction does not generate #NM when XCR0[i] = IA32_XFD[i] = 1;
>   instead, it operates as if XINUSE[i] = 0 (and the state component was
>   in its initial state): it saves bit i of XSTATE_BV field of the XSAVE
>   header as 0; in addition, XSAVE saves the initial configuration of the
>   state component (the other instructions do not save state component i).
> 
> Alternatively, KVM could always do XRSTOR with XFD=0, e.g. by using
> a constant XFD based on the set of enabled features when XSAVEing for
> a struct fpu_guest.  However, having XSTATE_BV[i]=1 for XFD-disabled
> features can only happen in the above interrupt case, or in similar
> scenarios involving preemption on preemptible kernels, because
> fpu_swap_kvm_fpstate()'s call to save_fpregs_to_fpstate() saves the
> outgoing FPU state with the current XFD; and that is (on all but the
> first WRMSR to XFD) the guest XFD.
> 
> Therefore, XFD can only go out of sync with XSTATE_BV in the above
> interrupt case, or in similar scenarios involving preemption on
> preemptible kernels, and it we can consider it (de facto) part of KVM
> ABI that KVM_GET_XSAVE returns XSTATE_BV[i]=0 for XFD-disabled features.

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

One nit blew.

> 
> Reported-by: Paolo Bonzini <pbonzini@redhat.com>
> Cc: stable@vger.kernel.org
> Fixes: 820a6ee944e7 ("kvm: x86: Add emulation for IA32_XFD", 2022-01-14)
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> [Move clearing of XSTATE_BV from fpu_copy_uabi_to_guest_fpstate
>  to kvm_vcpu_ioctl_x86_set_xsave. - Paolo]
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kernel/fpu/core.c | 32 +++++++++++++++++++++++++++++---
>  arch/x86/kvm/x86.c         |  9 +++++++++
>  2 files changed, 38 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> index da233f20ae6f..166c380b0161 100644
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -319,10 +319,29 @@ EXPORT_SYMBOL_FOR_KVM(fpu_enable_guest_xfd_features);
>  #ifdef CONFIG_X86_64
>  void fpu_update_guest_xfd(struct fpu_guest *guest_fpu, u64 xfd)
>  {
> +	struct fpstate *fpstate = guest_fpu->fpstate;
> +
>  	fpregs_lock();
> -	guest_fpu->fpstate->xfd = xfd;
> -	if (guest_fpu->fpstate->in_use)
> -		xfd_update_state(guest_fpu->fpstate);
> +
> +	/*
> +	 * KVM's guest ABI is that setting XFD[i]=1 *can* immediately revert
> +	 * the save state to initialized.  Likewise, KVM_GET_XSAVE does the

Nit:
To me "initialized" has the implication that it's active.
I prefer the description "initial state" or "initial configuration" used in
SDM here.
I am not a native English speaker though, please ignore it if it's just my
feeling.


> +	 * same as XSAVE and returns XSTATE_BV[i]=0 whenever XFD[i]=1.
> +	 *
> +	 * If the guest's FPU state is in hardware, just update XFD: the XSAVE
> +	 * in fpu_swap_kvm_fpstate will clear XSTATE_BV[i] whenever XFD[i]=1.
> +	 *
> +	 * If however the guest's FPU state is NOT resident in hardware, clear
> +	 * disabled components in XSTATE_BV now, or a subsequent XRSTOR will
> +	 * attempt to load disabled components and generate #NM _in the host_.
> +	 */
> +	if (xfd && test_thread_flag(TIF_NEED_FPU_LOAD))
> +		fpstate->regs.xsave.header.xfeatures &= ~xfd;
> +
> +	fpstate->xfd = xfd;
> +	if (fpstate->in_use)
> +		xfd_update_state(fpstate);
> +
>  	fpregs_unlock();
>  }
>  EXPORT_SYMBOL_FOR_KVM(fpu_update_guest_xfd);
> @@ -430,6 +449,13 @@ int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf,
>  	if (ustate->xsave.header.xfeatures & ~xcr0)
>  		return -EINVAL;
>  
> +	/*
> +	 * Disabled features must be in their initial state, otherwise XRSTOR
> +	 * causes an exception.
> +	 */
> +	if (WARN_ON_ONCE(ustate->xsave.header.xfeatures & kstate->xfd))
> +		return -EINVAL;
> +
>  	/*
>  	 * Nullify @vpkru to preserve its current value if PKRU's bit isn't set
>  	 * in the header.  KVM's odd ABI is to leave PKRU untouched in this
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ff8812f3a129..c0416f53b5f5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5807,9 +5807,18 @@ static int kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
>  static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
>  					struct kvm_xsave *guest_xsave)
>  {
> +	union fpregs_state *xstate = (union fpregs_state *)guest_xsave->region;
> +
>  	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
>  		return vcpu->kvm->arch.has_protected_state ? -EINVAL : 0;
>  
> +	/*
> +	 * Do not reject non-initialized disabled features for backwards
> +	 * compatibility, but clear XSTATE_BV[i] whenever XFD[i]=1.
> +	 * Otherwise, XRSTOR would cause a #NM.
> +	 */
> +	xstate->xsave.header.xfeatures &= ~vcpu->arch.guest_fpu.fpstate->xfd;
> +
>  	return fpu_copy_uabi_to_guest_fpstate(&vcpu->arch.guest_fpu,
>  					      guest_xsave->region,
>  					      kvm_caps.supported_xcr0,


