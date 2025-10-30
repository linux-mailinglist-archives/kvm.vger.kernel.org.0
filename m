Return-Path: <kvm+bounces-61521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 58939C21E39
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 20:13:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3822A1894046
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 19:12:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48C4336E36C;
	Thu, 30 Oct 2025 19:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NioRrMjL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9F636CA8E;
	Thu, 30 Oct 2025 19:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761851522; cv=none; b=jghjmYu+pLw+gUAqojOYwrEY9Z1q4OuBKNve1Vsmzl0rcXlhCE/HMaoI63Wie3ajh9aCOEuAQqXtHMJZHJCgMzLMB5eUt+x6+gPfkoPgwUeAWSjMpvqMe6aYvKTHmjKG+PjOL57AD06VdDuC4YmYPsWaloi11ZuSTJZwsdHAwLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761851522; c=relaxed/simple;
	bh=8LWb+XOQ0h78d+RRyH2hMk1hikrUZlS83DgOhbqo360=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E/QajkKEgxKms0crNzox8XVd1MVdyd7WBVB25G2+qs9OVjbTAk36oQ89+nukfSNL8Mtsb+8eOwiZRULaioNj9I0vfYjQsILNFQuq+WAGq9vsQ+T4S7PjrWlvtvDqgwSEOnxPXEad1Me1/FdOSTH6SzxKdLv4Pw7zTcRWcVuarD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NioRrMjL; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761851520; x=1793387520;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8LWb+XOQ0h78d+RRyH2hMk1hikrUZlS83DgOhbqo360=;
  b=NioRrMjLTkkcHYkQM5RxrJ09iu6hB3tK5N/wf7SS/YG+4/6AtEsetE9j
   WAOcGsZDcnPccHRb4AnJOK1S6bZ5LnyuMns/Ca+4af8F1LWDo9YCgWRLr
   FCNFl3/zQG90exDh49wRGSWxoPF0n3bycm3JjkasLZKT4aHixLulhFBAP
   9oC1JhbraXdGyiJXx615aFfja09Qhn6VOEORRovFnOk06bP9kT/06ckPH
   HmLXhF5ocb/b7gaWdIW0Wb3aJLIJeAvyXL5qOdpTg/1yZZ1bRAmhal2+A
   Rdt4627LZzVvmtblvCoud+uLDa7jF+ehf6tyiblKWaa/IuDjgdiL2b4ro
   Q==;
X-CSE-ConnectionGUID: 9UCS597NTuOajkH3uDjTrg==
X-CSE-MsgGUID: gsqu4XFkTqqSbagMlr3Feg==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="74605173"
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="74605173"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 12:11:59 -0700
X-CSE-ConnectionGUID: 9g2FiWVTQnqWjnq+hVBQiQ==
X-CSE-MsgGUID: FfmGX+12SGupSKbuWfDtzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="185972243"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO desk) ([10.124.223.240])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 12:11:59 -0700
Date: Thu, 30 Oct 2025 12:11:52 -0700
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
Message-ID: <20251030191152.uqvjxmgy2y5f4lb7@desk>
References: <20251029-verw-vm-v1-0-babf9b961519@linux.intel.com>
 <20251029-verw-vm-v1-3-babf9b961519@linux.intel.com>
 <DDVO5U7JZF4F.1WXXE8IYML140@google.com>
 <20251030172836.5ys2wag3dax5fmwk@desk>
 <aQOswAMVciBXu1ud@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQOswAMVciBXu1ud@google.com>

On Thu, Oct 30, 2025 at 11:21:52AM -0700, Sean Christopherson wrote:
> On Thu, Oct 30, 2025, Pawan Gupta wrote:
> > On Thu, Oct 30, 2025 at 12:52:12PM +0000, Brendan Jackman wrote:
> > > On Wed Oct 29, 2025 at 9:26 PM UTC, Pawan Gupta wrote:
> > > > +	/* Check EFLAGS.ZF from the VMX_RUN_CLEAR_CPU_BUFFERS bit test above */
> > > > +	jz .Lskip_clear_cpu_buffers
> > > 
> > > Hm, it's a bit weird that we have the "alternative" inside
> > > VM_CLEAR_CPU_BUFFERS, but then we still keep the test+jz
> > > unconditionally. 
> > 
> > Exactly, but it is tricky to handle the below 2 cases in asm:
> > 
> > 1. MDS -> Always do VM_CLEAR_CPU_BUFFERS
> > 
> > 2. MMIO -> Do VM_CLEAR_CPU_BUFFERS only if guest can access host MMIO
> 
> Overloading VM_CLEAR_CPU_BUFFERS for MMIO is all kinds of confusing, e.g. my
> pseudo-patch messed things.  It's impossible to understand

Agree.

> > In th MMIO case, one guest may have access to host MMIO while another may
> > not. Alternatives alone can't handle this case as they patch code at boot
> > which is then set in stone. One way is to move the conditional inside
> > VM_CLEAR_CPU_BUFFERS that gets a flag as an arguement.
> > 
> > > If we really want to super-optimise the no-mitigations-needed case,
> > > shouldn't we want to avoid the conditional in the asm if it never
> > > actually leads to a flush?
> > 
> > Ya, so effectively, have VM_CLEAR_CPU_BUFFERS alternative spit out
> > conditional VERW when affected by MMIO_only, otherwise an unconditional
> > VERW.
> > 
> > > On the other hand, if we don't mind a couple of extra instructions,
> > > shouldn't we be fine with just having the whole asm code based solely
> > > on VMX_RUN_CLEAR_CPU_BUFFERS and leaving the
> > > X86_FEATURE_CLEAR_CPU_BUF_VM to the C code?
> > 
> > That's also an option.
> > 
> > > I guess the issue is that in the latter case we'd be back to having
> > > unnecessary inconsistency with AMD code while in the former case... well
> > > that would just be really annoying asm code - am I on the right
> > > wavelength there? So I'm not necessarily asking for changes here, just
> > > probing in case it prompts any interesting insights on your side.
> > > 
> > > (Also, maybe this test+jz has a similar cost to the nops that the
> > > "alternative" would inject anyway...?)
> > 
> > Likely yes. test+jz is a necessary evil that is needed for MMIO Stale Data
> > for different per-guest handling.
> 
> I don't like any of those options :-)
> 
> I again vote to add X86_FEATURE_CLEAR_CPU_BUF_MMIO, and then have it be mutually
> exlusive with X86_FEATURE_CLEAR_CPU_BUF_VM, i.e. be an alterantive, not a subset.
> Because as proposed, the MMIO case _isn't_ a strict subset, it's a subset iff
> the MMIO mitigation is enabled, otherwise it's something else entirely.

I don't see a problem with that.

> After half an hour of debugging godawful assembler errors because I used stringify()
> instead of __stringify(),

Not surprised at all :-)

> I was able to get to this, which IMO is readable and intuitive.
> 
> 	/* Clobbers EFLAGS.ZF */
> 	ALTERNATIVE_2 "",							\
> 		      __CLEAR_CPU_BUFFERS, X86_FEATURE_CLEAR_CPU_BUF_VM,	\
> 		      __stringify(jz .Lskip_clear_cpu_buffers;			\
> 				  CLEAR_CPU_BUFFERS_SEQ;			\

Curious what this is doing, I will wait for your patches.

> 				  .Lskip_clear_cpu_buffers:),			\
> 		      X86_FEATURE_CLEAR_CPU_BUF_MMIO
> 
> Without overloading X86_FEATURE_CLEAR_CPU_BUF_VM, e.g. the conversion from a
> static branch to X86_FEATURE_CLEAR_CPU_BUF_MMIO is a pure conversion and yields:
> 
> 	if (verw_clear_cpu_buf_mitigation_selected) {
> 		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF);
> 		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF_VM);
> 	} else {
> 		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF_MMIO);
> 	}
> 
> Give me a few hours to test, and I'll post a v2.  The patches are:
> 
> Pawan Gupta (1):
>   x86/bugs: Use VM_CLEAR_CPU_BUFFERS in VMX as well
> 
> Sean Christopherson (4):
>   x86/bugs: Decouple ALTERNATIVE usage from VERW macro definition
>   x86/bugs: Use an X86_FEATURE_xxx flag for the MMIO Stale Data mitigation
>   KVM: VMX: Handle MMIO Stale Data in VM-Enter assembly via ALTERNATIVES_2
>   x86/bugs: KVM: Move VM_CLEAR_CPU_BUFFERS into SVM as SVM_CLEAR_CPU_BUFFERS

Ok, sounds good to me.

