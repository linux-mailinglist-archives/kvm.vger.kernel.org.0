Return-Path: <kvm+bounces-61897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EC4D5C2D7FA
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 18:38:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 69E001898EBB
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 17:38:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 895AA27FD7D;
	Mon,  3 Nov 2025 17:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Du+8OJJ4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A982031AF2E;
	Mon,  3 Nov 2025 17:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762191462; cv=none; b=TKPDi+5BWWEWRcD7KtlZ+O5vpUTlriCasigbGngGiTNDYNZIRGz4o7J8SYbKy6bya+Y+7eGksU+vK5Ksn7ZzPh9u8Ryg5QkER0UISkVXvvBS34vFLOc3rXtRSah/QD7vqI2XCHSpdOCIJvKAXKca1+3Spe0ayz53/13TszWfbxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762191462; c=relaxed/simple;
	bh=XEVPKVaABKMGIe1xDLDQhKQJqUNRoI7AHqwRjkb8nMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k53PmfYjCLfueeEQxcC7G90DFVD9jMykPrk4H6QAUm9MgRC1F1yfFOnxa1y6txDmrx08rXN+u0W27j/hJHYeuezbfZX0Tredro4TSB6Ea6+wGOZ4WVdXbGl9jCw44iE0xBdExWE4u4G9Lk9i7KaYXFdikFg/1anPwnYvXmbq+/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Du+8OJJ4; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762191461; x=1793727461;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XEVPKVaABKMGIe1xDLDQhKQJqUNRoI7AHqwRjkb8nMs=;
  b=Du+8OJJ4ou3nHmeqt6kaXl7Lu4SbVbYb+DbrqLafUc0XOrtqPNLG3Zrg
   QisnLCnAVvvOJHKjzr8YcAl/aPN3nYILs7OEauiUGQKexf0aaECBdg8Mv
   cvtmGqAL2nUipB47rTozZ93f134pOJO4kJLe03+Fo4MO1h4bpqn20TuDm
   +5Njesamp1dBkroaCu27gV5BsiHMB+lHxiR88oo4uf/QU0fMmMn37x8hz
   6Uxz3q5cfIzm5y5Cn91X1J8zV9jfReINYp426wUraBo13zgTHPDCKncVW
   BdWtVY181fi3Ywl5f4lIy17+iLbWXBMPsKKrcZ07bu31nnZOA86P332N0
   A==;
X-CSE-ConnectionGUID: 9xrj66NvS52oN5DRyO2DAA==
X-CSE-MsgGUID: 5DwMVfIsSCC1jpJ+XTzoug==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64178456"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64178456"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 09:37:40 -0800
X-CSE-ConnectionGUID: K0gFR+u7ThOEEa2AyEgoXg==
X-CSE-MsgGUID: PrKQOth4RDKzgjF3E/ToKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,276,1754982000"; 
   d="scan'208";a="186214863"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO desk) ([10.124.220.244])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 09:37:39 -0800
Date: Mon, 3 Nov 2025 09:37:33 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v4 4/8] KVM: VMX: Handle MMIO Stale Data in VM-Enter
 assembly via ALTERNATIVES_2
Message-ID: <20251103173733.tjo54dlu7eoyupwi@desk>
References: <20251031003040.3491385-1-seanjc@google.com>
 <20251031003040.3491385-5-seanjc@google.com>
 <20251031235524.cuwrx4qys46xnpjr@desk>
 <20251103091749.GW3245006@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103091749.GW3245006@noisy.programming.kicks-ass.net>

On Mon, Nov 03, 2025 at 10:17:49AM +0100, Peter Zijlstra wrote:
> On Fri, Oct 31, 2025 at 04:55:24PM -0700, Pawan Gupta wrote:
> > On Thu, Oct 30, 2025 at 05:30:36PM -0700, Sean Christopherson wrote:
> > ...
> > > diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> > > index 1f99a98a16a2..61a809790a58 100644
> > > --- a/arch/x86/kvm/vmx/vmenter.S
> > > +++ b/arch/x86/kvm/vmx/vmenter.S
> > > @@ -71,6 +71,7 @@
> > >   * @regs:	unsigned long * (to guest registers)
> > >   * @flags:	VMX_RUN_VMRESUME:	use VMRESUME instead of VMLAUNCH
> > >   *		VMX_RUN_SAVE_SPEC_CTRL: save guest SPEC_CTRL into vmx->spec_ctrl
> > > + *		VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO: vCPU can access host MMIO
> > >   *
> > >   * Returns:
> > >   *	0 on VM-Exit, 1 on VM-Fail
> > > @@ -137,6 +138,12 @@ SYM_FUNC_START(__vmx_vcpu_run)
> > >  	/* Load @regs to RAX. */
> > >  	mov (%_ASM_SP), %_ASM_AX
> > >  
> > > +	/* Stash "clear for MMIO" in EFLAGS.ZF (used below). */
> > > +	ALTERNATIVE_2 "",								\
> > > +		      __stringify(test $VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO, %ebx), 	\
> > > +		      X86_FEATURE_CLEAR_CPU_BUF_MMIO,					\
> > > +		      "", X86_FEATURE_CLEAR_CPU_BUF_VM
> > > +
> > >  	/* Check if vmlaunch or vmresume is needed */
> > >  	bt   $VMX_RUN_VMRESUME_SHIFT, %ebx
> > >  
> > > @@ -161,7 +168,12 @@ SYM_FUNC_START(__vmx_vcpu_run)
> > >  	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
> > >  
> > >  	/* Clobbers EFLAGS.ZF */
> > > -	VM_CLEAR_CPU_BUFFERS
> > > +	ALTERNATIVE_2 "",							\
> > > +		      __stringify(jz .Lskip_clear_cpu_buffers;			\
> > > +				  CLEAR_CPU_BUFFERS_SEQ;			\
> > > +				  .Lskip_clear_cpu_buffers:),			\
> > > +		      X86_FEATURE_CLEAR_CPU_BUF_MMIO,				\
> > > +		      __CLEAR_CPU_BUFFERS, X86_FEATURE_CLEAR_CPU_BUF_VM
> > 
> > Another way to write this could be:
> > 
> > 	ALTERNATIVE_2 "jmp .Lskip_clear_cpu_buffers",					\
> > 		      "jz  .Lskip_clear_cpu_buffers", X86_FEATURE_CLEAR_CPU_BUF_MMIO,	\
> > 		      "",			      X86_FEATURE_CLEAR_CPU_BUF_VM
> > 
> > 	CLEAR_CPU_BUFFERS_SEQ
> > .Lskip_clear_cpu_buffers:
> > 
> > With this jmp;verw; would show up in the disassembly on unaffected CPUs, I
> > don't know how big a problem is that. OTOH, I find this easier to understand.
> 
> Generating larger code just to keep disassembly 'simple' seems wrong.
> Also, see this:
> 
>   https://lkml.kernel.org/r/194ad779-f41f-46a5-9973-e886f483b60a@oracle.com

Ok thanks, that settles it.

