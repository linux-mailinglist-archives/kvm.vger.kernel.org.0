Return-Path: <kvm+bounces-61511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D45FFC21921
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 18:55:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 110CA4EC8A4
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 17:55:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCFF736CA9E;
	Thu, 30 Oct 2025 17:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gGqmPt1R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A0736C23B;
	Thu, 30 Oct 2025 17:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761846883; cv=none; b=CZN0wu20ofiyGlYJSO29UFSXc3XuuVm4lkyLbePvoE7OHzMovaCHZt7E+T3/O432+D/EmTa6raNT6H+qSHI6fI1nF6as5vzWxVWrEYoIJHmIbvmnhDSLxEr11Gm0Cm82dsQq/YpUBzGjfX/KMik4J4TUrZvS24pkPz9JrITYyL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761846883; c=relaxed/simple;
	bh=wN5w0ZpsmRedOFKta+0uAe6rukrpdbaeowWPDsV8m+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VlvrIv6O6MZcDHzLCcZpFv1g5kWf17jkmSrPodknwJWGyRoMcuKnw1ehfTZOm19cBNqnLGrLn+on2zDZiIPW50EdvQo9lbKUgbotrT683oJqFXq+wQ0n/Pns3vgCTVid/1VlQGvJueWXzaPjYmxUSj6MgxlZl0L39X3/TEAWwPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gGqmPt1R; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761846881; x=1793382881;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wN5w0ZpsmRedOFKta+0uAe6rukrpdbaeowWPDsV8m+E=;
  b=gGqmPt1RDSdSMqpV0OaljqW58ziuQHTGP1xnNaDCumePfJqizLGFXm9B
   +vLpXvDgztMnIf41OB2LbbGQyLKQWGyC46ida+x3eZgCmrHD36umDKORb
   L25OKKC9Z+ngn7pJQzSOBAm4I0w+2klJ0+WV4VUuvWwdCfOkaB///u6ZZ
   R3X+SgspUrEbdCeU5a3dmhH3VDdumuBOmXDG3b9F7IlmGufZnXN7Dhr/2
   /ZRaGHt17v6fefO1W+BZeD0DKMOIgcEaLxbKFYIMhyi79im+3dVrp7Zbm
   VedjfjUR+QTj0CqXuFygYlIFbxCy/twa7P+Lt24nwFT//+Cwkv++pmixZ
   g==;
X-CSE-ConnectionGUID: pnzb1urETSen4ryhYs0edQ==
X-CSE-MsgGUID: dr3w+bz1TGqjgh4zOVlkzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="89465156"
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="89465156"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 10:54:41 -0700
X-CSE-ConnectionGUID: 51Mc5goQQR+u5gOBMgShNA==
X-CSE-MsgGUID: GQl1hD2jQhS8/oNgGh4rAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="185708781"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO desk) ([10.124.223.240])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 10:54:40 -0700
Date: Thu, 30 Oct 2025 10:54:35 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Brendan Jackman <jackmanb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Tao Zhang <tao1.zhang@intel.com>,
	Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 3/3] x86/mmio: Unify VERW mitigation for guests
Message-ID: <20251030175435.afooenvymwpv5c2b@desk>
References: <20251029-verw-vm-v1-0-babf9b961519@linux.intel.com>
 <20251029-verw-vm-v1-3-babf9b961519@linux.intel.com>
 <DDVO5U7JZF4F.1WXXE8IYML140@google.com>
 <aQONEWlBwFCXx3o6@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQONEWlBwFCXx3o6@google.com>

On Thu, Oct 30, 2025 at 09:06:41AM -0700, Sean Christopherson wrote:
> On Thu, Oct 30, 2025, Brendan Jackman wrote:
> > > @@ -160,6 +163,8 @@ SYM_FUNC_START(__vmx_vcpu_run)
> > >  	/* Load guest RAX.  This kills the @regs pointer! */
> > >  	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
> > >  
> > > +	/* Check EFLAGS.ZF from the VMX_RUN_CLEAR_CPU_BUFFERS bit test above */
> > > +	jz .Lskip_clear_cpu_buffers
> > 
> > Hm, it's a bit weird that we have the "alternative" inside
> > VM_CLEAR_CPU_BUFFERS, but then we still keep the test+jz
> > unconditionally. 
> 
> Yeah, I had the same reaction, but couldn't come up with a clean-ish solution
> and so ignored it :-)

Ya, it is tricky to handle per-guest mitigation for MMIO in a clean way.

> > If we really want to super-optimise the no-mitigations-needed case,
> > shouldn't we want to avoid the conditional in the asm if it never
> > actually leads to a flush?
> > 
> > On the other hand, if we don't mind a couple of extra instructions,
> > shouldn't we be fine with just having the whole asm code based solely
> > on VMX_RUN_CLEAR_CPU_BUFFERS and leaving the
> > X86_FEATURE_CLEAR_CPU_BUF_VM to the C code?
> > 
> > I guess the issue is that in the latter case we'd be back to having
> > unnecessary inconsistency with AMD code while in the former case... well
> > that would just be really annoying asm code - am I on the right
> > wavelength there? So I'm not necessarily asking for changes here, just
> > probing in case it prompts any interesting insights on your side.
> > 
> > (Also, maybe this test+jz has a similar cost to the nops that the
> > "alternative" would inject anyway...?)
> 
> It's not at all expensive.  My bigger objection is that it's hard to follow what's
> happening.
> 
> Aha!  Idea.  IIUC, only the MMIO Stale Data is conditional based on the properties
> of the vCPU, so we should track _that_ in a KVM_RUN flag.  And then if we add yet
> another X86_FEATURE for MMIO Stale Data flushing (instead of a static branch),
> this path can use ALTERNATIVE_2.  The use of ALTERNATIVE_2 isn't exactly pretty,
> but IMO this is much more intuitive.
> 
> diff --git a/arch/x86/kvm/vmx/run_flags.h b/arch/x86/kvm/vmx/run_flags.h
> index 004fe1ca89f0..b9651960e069 100644
> --- a/arch/x86/kvm/vmx/run_flags.h
> +++ b/arch/x86/kvm/vmx/run_flags.h
> @@ -4,10 +4,10 @@
>  
>  #define VMX_RUN_VMRESUME_SHIFT                 0
>  #define VMX_RUN_SAVE_SPEC_CTRL_SHIFT           1
> -#define VMX_RUN_CLEAR_CPU_BUFFERS_SHIFT                2
> +#define VMX_RUN_CAN_ACCESS_HOST_MMIO_SHIT      2
>  
>  #define VMX_RUN_VMRESUME               BIT(VMX_RUN_VMRESUME_SHIFT)
>  #define VMX_RUN_SAVE_SPEC_CTRL         BIT(VMX_RUN_SAVE_SPEC_CTRL_SHIFT)
> -#define VMX_RUN_CLEAR_CPU_BUFFERS      BIT(VMX_RUN_CLEAR_CPU_BUFFERS_SHIFT)
> +#define VMX_RUN_CAN_ACCESS_HOST_MMIO   BIT(VMX_RUN_CAN_ACCESS_HOST_MMIO_SHIT)
>  
>  #endif /* __KVM_X86_VMX_RUN_FLAGS_H */
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index ec91f4267eca..50a748b489b4 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -137,8 +137,10 @@ SYM_FUNC_START(__vmx_vcpu_run)
>         /* Load @regs to RAX. */
>         mov (%_ASM_SP), %_ASM_AX
>  
> -       /* jz .Lskip_clear_cpu_buffers below relies on this */
> -       test $VMX_RUN_CLEAR_CPU_BUFFERS, %ebx
> +       /* Check if jz .Lskip_clear_cpu_buffers below relies on this */
> +       ALTERNATIVE_2 "",
> +                     "", X86_FEATURE_CLEAR_CPU_BUF
> +                     "test $VMX_RUN_CAN_ACCESS_HOST_MMIO, %ebx", X86_FEATURE_CLEAR_CPU_BUFFERS_MMIO

This approach looks better. I think we will be fine without ALTERNATIVE_2:

       ALTERNATIVE "", "test $VMX_RUN_CAN_ACCESS_HOST_MMIO, %ebx", X86_FEATURE_CLEAR_CPU_BUFFERS_MMIO

>         /* Check if vmlaunch or vmresume is needed */
>         bt   $VMX_RUN_VMRESUME_SHIFT, %ebx
> @@ -163,8 +165,9 @@ SYM_FUNC_START(__vmx_vcpu_run)
>         /* Load guest RAX.  This kills the @regs pointer! */
>         mov VCPU_RAX(%_ASM_AX), %_ASM_AX
>  
> -       /* Check EFLAGS.ZF from the VMX_RUN_CLEAR_CPU_BUFFERS bit test above */
> -       jz .Lskip_clear_cpu_buffers
> +       ALTERNATIVE_2 "jmp .Lskip_clear_cpu_buffers",
> +                     "", X86_FEATURE_CLEAR_CPU_BUF
> +                     "jz .Lskip_clear_cpu_buffers", X86_FEATURE_CLEAR_CPU_BUFFERS_MMIO

I am not 100% sure, but I believe the _MMIO check needs to be before
X86_FEATURE_CLEAR_CPU_BUF_VM, because MMIO mitigation also sets _VM:

       ALTERNATIVE_2 "jmp .Lskip_clear_cpu_buffers",
                     "jz .Lskip_clear_cpu_buffers", X86_FEATURE_CLEAR_CPU_BUFFERS_MMIO
                     "", X86_FEATURE_CLEAR_CPU_BUF_VM

>         /* Clobbers EFLAGS.ZF */
>         VM_CLEAR_CPU_BUFFERS
>  .Lskip_clear_cpu_buffers:
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 303935882a9f..b9e7247e6b9a 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -903,16 +903,9 @@ unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx)
>         if (!msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL))
>                 flags |= VMX_RUN_SAVE_SPEC_CTRL;
>  
> -       /*
> -        * When affected by MMIO Stale Data only (and not other data sampling
> -        * attacks) only clear for MMIO-capable guests.
> -        */
> -       if (static_branch_unlikely(&cpu_buf_vm_clear_mmio_only)) {
> -               if (kvm_vcpu_can_access_host_mmio(&vmx->vcpu))
> -                       flags |= VMX_RUN_CLEAR_CPU_BUFFERS;
> -       } else {
> -               flags |= VMX_RUN_CLEAR_CPU_BUFFERS;
> -       }
> +       if (cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUFFERS_MMIO) &&
> +           kvm_vcpu_can_access_host_mmio(&vmx->vcpu))
> +               flags |= VMX_RUN_CAN_ACCESS_HOST_MMIO;

Thanks Sean! This is much cleaner.

