Return-Path: <kvm+bounces-61510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A3EEC217DB
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 18:28:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B70AF1A24E54
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 17:29:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A47E1368F51;
	Thu, 30 Oct 2025 17:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g0ZjB2ik"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185693678BC;
	Thu, 30 Oct 2025 17:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761845324; cv=none; b=KSod2ZZLQyw1PAovnbjbOwPgCm+wu7qv8vikiO08vZPp7MXNZQMdhm+FPvVfNQ3GkEOMZ0k2tgv3EhbO7Icdnu+dt/S+sj6b1SUDG3II55zMNqom4IZ2oSE+Ca36Q1CiWD5dVcJMQyKOV+TBTnrf+GnxMLuUcv+0QDclKFNyWTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761845324; c=relaxed/simple;
	bh=EeHiZj86ptVWaw1dHp14/Ek3xCgDzVxz3IbbU3pJgHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ApFMFIylRU2KEKSlP6dIglXPp9IkdLseIpENFdN8LIiUNgEZ7wphdV4FlCHTB275ZJ7c8ZZz4H/ktHuzniM1eB1rfAko2LtR5qPtLCF65+oxO15fLTouvZOvaDn1pp2OB2zSyEllaunKZltGzqjC2Xh8Vfh6DBCz5VE8dgoqALc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g0ZjB2ik; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761845323; x=1793381323;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EeHiZj86ptVWaw1dHp14/Ek3xCgDzVxz3IbbU3pJgHo=;
  b=g0ZjB2ikNtEmtG7Pq7phF9auNsHdGpOj/ByTV319P4IXky7874BNTNKU
   q4H0gZ5K/FxmDtn13ghYxypVmubDAOINV9CTcftvyhvC0cCCQu5Euo0zQ
   NYd5QRFTb0cFejvxY2duOvLw/iLnsN/OKARImFAR47s4l66cV3oBdSPW2
   31CLmPcfZevv/6bpxOsqlv1C748cHPFj6oOodcs57wK2KjzgFCxQCfT2O
   5zPzdp1KXEg+G/+21zdtLoT7x7Wa6F7c8dSDoZbWCU30Kk5+960nsxvvA
   E3uyH3cJjFH7GlEvb8b2dtXDMcAG+IGxHuqSxSCmWeE0sSLAk8e6sLEmW
   g==;
X-CSE-ConnectionGUID: foE5fsguQMO5YS1+kT0ynw==
X-CSE-MsgGUID: KRHShXtpTHCpriz9zIF2CQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63900918"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63900918"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 10:28:43 -0700
X-CSE-ConnectionGUID: x2CPNvEORpGk9VGkTwg3LA==
X-CSE-MsgGUID: PAn8cadVQMCLIhHd5b73Xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="186109479"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO desk) ([10.124.223.240])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 10:28:41 -0700
Date: Thu, 30 Oct 2025 10:28:36 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Tao Zhang <tao1.zhang@intel.com>,
	Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 3/3] x86/mmio: Unify VERW mitigation for guests
Message-ID: <20251030172836.5ys2wag3dax5fmwk@desk>
References: <20251029-verw-vm-v1-0-babf9b961519@linux.intel.com>
 <20251029-verw-vm-v1-3-babf9b961519@linux.intel.com>
 <DDVO5U7JZF4F.1WXXE8IYML140@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DDVO5U7JZF4F.1WXXE8IYML140@google.com>

On Thu, Oct 30, 2025 at 12:52:12PM +0000, Brendan Jackman wrote:
> On Wed Oct 29, 2025 at 9:26 PM UTC, Pawan Gupta wrote:
> > When a system is only affected by MMIO Stale Data, VERW mitigation is
> > currently handled differently than other data sampling attacks like
> > MDS/TAA/RFDS, that do the VERW in asm. This is because for MMIO Stale Data,
> > VERW is needed only when the guest can access host MMIO, this was tricky to
> > check in asm.
> >
> > Refactoring done by:
> >
> >   83ebe7157483 ("KVM: VMX: Apply MMIO Stale Data mitigation if KVM maps
> >   MMIO into the guest")
> >
> > now makes it easier to execute VERW conditionally in asm based on
> > VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO.
> >
> > Unify MMIO Stale Data mitigation with other VERW-based mitigations and only
> > have single VERW callsite in __vmx_vcpu_run(). Remove the now unnecessary
> > call to x86_clear_cpu_buffer() in vmx_vcpu_enter_exit().
> >
> > This also untangles L1D Flush and MMIO Stale Data mitigation. Earlier, an
> > L1D Flush would skip the VERW for MMIO Stale Data. Now, both the
> > mitigations are independent of each other. Although, this has little
> > practical implication since there are no CPUs that are affected by L1TF and
> > are *only* affected by MMIO Stale Data (i.e. not affected by MDS/TAA/RFDS).
> > But, this makes the code cleaner and easier to maintain.
> >
> > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> > ---
> >  arch/x86/kvm/vmx/run_flags.h | 12 ++++++------
> >  arch/x86/kvm/vmx/vmenter.S   |  5 +++++
> >  arch/x86/kvm/vmx/vmx.c       | 26 ++++++++++----------------
> >  3 files changed, 21 insertions(+), 22 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/run_flags.h b/arch/x86/kvm/vmx/run_flags.h
> > index 2f20fb170def8b10c8c0c46f7ba751f845c19e2c..004fe1ca89f05524bf3986540056de2caf0abbad 100644
> > --- a/arch/x86/kvm/vmx/run_flags.h
> > +++ b/arch/x86/kvm/vmx/run_flags.h
> > @@ -2,12 +2,12 @@
> >  #ifndef __KVM_X86_VMX_RUN_FLAGS_H
> >  #define __KVM_X86_VMX_RUN_FLAGS_H
> >  
> > -#define VMX_RUN_VMRESUME_SHIFT				0
> > -#define VMX_RUN_SAVE_SPEC_CTRL_SHIFT			1
> > -#define VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO_SHIFT	2
> > +#define VMX_RUN_VMRESUME_SHIFT			0
> > +#define VMX_RUN_SAVE_SPEC_CTRL_SHIFT		1
> > +#define VMX_RUN_CLEAR_CPU_BUFFERS_SHIFT		2
> >  
> > -#define VMX_RUN_VMRESUME			BIT(VMX_RUN_VMRESUME_SHIFT)
> > -#define VMX_RUN_SAVE_SPEC_CTRL			BIT(VMX_RUN_SAVE_SPEC_CTRL_SHIFT)
> > -#define VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO	BIT(VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO_SHIFT)
> > +#define VMX_RUN_VMRESUME		BIT(VMX_RUN_VMRESUME_SHIFT)
> > +#define VMX_RUN_SAVE_SPEC_CTRL		BIT(VMX_RUN_SAVE_SPEC_CTRL_SHIFT)
> > +#define VMX_RUN_CLEAR_CPU_BUFFERS	BIT(VMX_RUN_CLEAR_CPU_BUFFERS_SHIFT)
> >  
> >  #endif /* __KVM_X86_VMX_RUN_FLAGS_H */
> > diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> > index 0dd23beae207795484150698d1674dc4044cc520..ec91f4267eca319ffa8e6079887e8dfecc7f96d8 100644
> > --- a/arch/x86/kvm/vmx/vmenter.S
> > +++ b/arch/x86/kvm/vmx/vmenter.S
> > @@ -137,6 +137,9 @@ SYM_FUNC_START(__vmx_vcpu_run)
> >  	/* Load @regs to RAX. */
> >  	mov (%_ASM_SP), %_ASM_AX
> >  
> > +	/* jz .Lskip_clear_cpu_buffers below relies on this */
> > +	test $VMX_RUN_CLEAR_CPU_BUFFERS, %ebx
> > +
> >  	/* Check if vmlaunch or vmresume is needed */
> >  	bt   $VMX_RUN_VMRESUME_SHIFT, %ebx
> >  
> > @@ -160,6 +163,8 @@ SYM_FUNC_START(__vmx_vcpu_run)
> >  	/* Load guest RAX.  This kills the @regs pointer! */
> >  	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
> >  
> > +	/* Check EFLAGS.ZF from the VMX_RUN_CLEAR_CPU_BUFFERS bit test above */
> > +	jz .Lskip_clear_cpu_buffers
> 
> Hm, it's a bit weird that we have the "alternative" inside
> VM_CLEAR_CPU_BUFFERS, but then we still keep the test+jz
> unconditionally. 

Exactly, but it is tricky to handle the below 2 cases in asm:

1. MDS -> Always do VM_CLEAR_CPU_BUFFERS

2. MMIO -> Do VM_CLEAR_CPU_BUFFERS only if guest can access host MMIO

In th MMIO case, one guest may have access to host MMIO while another may
not. Alternatives alone can't handle this case as they patch code at boot
which is then set in stone. One way is to move the conditional inside
VM_CLEAR_CPU_BUFFERS that gets a flag as an arguement.

> If we really want to super-optimise the no-mitigations-needed case,
> shouldn't we want to avoid the conditional in the asm if it never
> actually leads to a flush?

Ya, so effectively, have VM_CLEAR_CPU_BUFFERS alternative spit out
conditional VERW when affected by MMIO_only, otherwise an unconditional
VERW.

> On the other hand, if we don't mind a couple of extra instructions,
> shouldn't we be fine with just having the whole asm code based solely
> on VMX_RUN_CLEAR_CPU_BUFFERS and leaving the
> X86_FEATURE_CLEAR_CPU_BUF_VM to the C code?

That's also an option.

> I guess the issue is that in the latter case we'd be back to having
> unnecessary inconsistency with AMD code while in the former case... well
> that would just be really annoying asm code - am I on the right
> wavelength there? So I'm not necessarily asking for changes here, just
> probing in case it prompts any interesting insights on your side.
> 
> (Also, maybe this test+jz has a similar cost to the nops that the
> "alternative" would inject anyway...?)

Likely yes. test+jz is a necessary evil that is needed for MMIO Stale Data
for different per-guest handling.

