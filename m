Return-Path: <kvm+bounces-61742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76774C273B0
	for <lists+kvm@lfdr.de>; Sat, 01 Nov 2025 00:55:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 611D03A7B9B
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 23:55:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17DF1330B0B;
	Fri, 31 Oct 2025 23:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BgeoZ9Az"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9BC30F951;
	Fri, 31 Oct 2025 23:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761954940; cv=none; b=oJfBQGKae9Lfl7XYm70JLHFzWJUDbw7eIF42GxoWwyfVrYPPc40MYKIARVx0kYkttkceSqtnyCQQ+vTvUrtGc7TtutlHrtNrAwbjOc8vRB8GUCshyzpJC7pMUVHOUY5QQACMkvqjhcjthFhZoXbTNh+CCv++SNvrdja6R8v5tP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761954940; c=relaxed/simple;
	bh=IgEyLuJD3uU+/Fkjfih5JoAxJ/acgTqLSAUy4L+dzj4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qzzPG2VQxWBOCHI/ILZ1biKpDI6uX0Wex0UHOpQB2H7vu4iTNmU3m97wZW1wzqyls+7LMmqc7puFo1g+I3PKJIGqXLxEuzdVEJaaG1rU5doQHSerK6r8SGNWVT20uswV8UKX4qC/UygW6f51L4f+zTlMFDbEgRY7i8oNAqdm9ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BgeoZ9Az; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761954938; x=1793490938;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IgEyLuJD3uU+/Fkjfih5JoAxJ/acgTqLSAUy4L+dzj4=;
  b=BgeoZ9AzvzqU9mnc1VcQfYZ05mzulxWsHR4AUSw8I6YHOtKCSrApE50h
   NXHaKwxGPkXD40oU6cY2ac4H/qTNzBFuKZ2gyNBcAC0RwOd8UQnFDx1x+
   2gEDichLgZK83oYvBBTHQ1uht4fzMF8GIUrc9nRWR7lH0EeZtORmze9q2
   w7sSMLiWxsO4aGpFiIXIjmckPLwxWYVh9IX4THdHYbJSJj1pBcRL9BKL3
   6UKk0BuX8aEXzCuqlGP8GZxiDX09EemAUeIz6DjBnNadiOMDeaUAJ0Vmg
   TtrfNJvMPx2iFq/bz1xiPO5jKuUi7s0uRXS848IxqGOvDBDATm4J6co6y
   w==;
X-CSE-ConnectionGUID: Lc2FaeMmSUSYU9JDTOsBCA==
X-CSE-MsgGUID: qhigV5T5TIWtVSwsj8Z8BA==
X-IronPort-AV: E=McAfee;i="6800,10657,11599"; a="64040655"
X-IronPort-AV: E=Sophos;i="6.19,270,1754982000"; 
   d="scan'208";a="64040655"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 16:55:37 -0700
X-CSE-ConnectionGUID: E55U3mslQdKxA5GfBKMnxA==
X-CSE-MsgGUID: 7VmckiH8S4im/CbZ6ccR9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,270,1754982000"; 
   d="scan'208";a="185578112"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO desk) ([10.124.220.87])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 16:55:37 -0700
Date: Fri, 31 Oct 2025 16:55:24 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v4 4/8] KVM: VMX: Handle MMIO Stale Data in VM-Enter
 assembly via ALTERNATIVES_2
Message-ID: <20251031235524.cuwrx4qys46xnpjr@desk>
References: <20251031003040.3491385-1-seanjc@google.com>
 <20251031003040.3491385-5-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031003040.3491385-5-seanjc@google.com>

On Thu, Oct 30, 2025 at 05:30:36PM -0700, Sean Christopherson wrote:
...
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index 1f99a98a16a2..61a809790a58 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -71,6 +71,7 @@
>   * @regs:	unsigned long * (to guest registers)
>   * @flags:	VMX_RUN_VMRESUME:	use VMRESUME instead of VMLAUNCH
>   *		VMX_RUN_SAVE_SPEC_CTRL: save guest SPEC_CTRL into vmx->spec_ctrl
> + *		VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO: vCPU can access host MMIO
>   *
>   * Returns:
>   *	0 on VM-Exit, 1 on VM-Fail
> @@ -137,6 +138,12 @@ SYM_FUNC_START(__vmx_vcpu_run)
>  	/* Load @regs to RAX. */
>  	mov (%_ASM_SP), %_ASM_AX
>  
> +	/* Stash "clear for MMIO" in EFLAGS.ZF (used below). */
> +	ALTERNATIVE_2 "",								\
> +		      __stringify(test $VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO, %ebx), 	\
> +		      X86_FEATURE_CLEAR_CPU_BUF_MMIO,					\
> +		      "", X86_FEATURE_CLEAR_CPU_BUF_VM
> +
>  	/* Check if vmlaunch or vmresume is needed */
>  	bt   $VMX_RUN_VMRESUME_SHIFT, %ebx
>  
> @@ -161,7 +168,12 @@ SYM_FUNC_START(__vmx_vcpu_run)
>  	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
>  
>  	/* Clobbers EFLAGS.ZF */
> -	VM_CLEAR_CPU_BUFFERS
> +	ALTERNATIVE_2 "",							\
> +		      __stringify(jz .Lskip_clear_cpu_buffers;			\
> +				  CLEAR_CPU_BUFFERS_SEQ;			\
> +				  .Lskip_clear_cpu_buffers:),			\
> +		      X86_FEATURE_CLEAR_CPU_BUF_MMIO,				\
> +		      __CLEAR_CPU_BUFFERS, X86_FEATURE_CLEAR_CPU_BUF_VM

Another way to write this could be:

	ALTERNATIVE_2 "jmp .Lskip_clear_cpu_buffers",					\
		      "jz  .Lskip_clear_cpu_buffers", X86_FEATURE_CLEAR_CPU_BUF_MMIO,	\
		      "",			      X86_FEATURE_CLEAR_CPU_BUF_VM

	CLEAR_CPU_BUFFERS_SEQ
.Lskip_clear_cpu_buffers:

With this jmp;verw; would show up in the disassembly on unaffected CPUs, I
don't know how big a problem is that. OTOH, I find this easier to understand.

