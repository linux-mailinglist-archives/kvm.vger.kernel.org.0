Return-Path: <kvm+bounces-62956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DDEDC54C5C
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 00:01:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4806C3A959A
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 23:01:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 515962EB87E;
	Wed, 12 Nov 2025 23:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="COEHRRoB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE54D186294;
	Wed, 12 Nov 2025 23:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762988506; cv=none; b=YeKGU4Ph/AD1WfCkEAUNojrc6+fl/68vSZqaPB7TLxjyuTa7SdftvubIzw96n53G93Hc2HqfYZm/TyKGIEcVvQO6nr1muTvaDvvUwE71sangamSSDxpVRWrdsJiOrkspYPe4qrFqycPUl4SOyY4GtCZRbCT/11Z6kt/YOWzLweI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762988506; c=relaxed/simple;
	bh=ptpQHUkjOPekkiQOHwD58jsF0L267w/KGg8/nZu2zTM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qWtO4hlsTd5eMSiDPmifueyxXzKbXiHBCpihDcJxSYyHjI1qDXGY5sGqTtuFJiokyU6XMA0+Hm4Om8YQEBJNXKXvjXRcXMiO24YAP7+B71QzPDo6EpU8OGfIHL/rLgo1P34HPJTZy5sXnqMw6Sh8uK4gzgBkRhGoyAK3VJ+7ASo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=COEHRRoB; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762988505; x=1794524505;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ptpQHUkjOPekkiQOHwD58jsF0L267w/KGg8/nZu2zTM=;
  b=COEHRRoBGUvkLAx/VFNzBolb23Ugg0bcNOJzpcljxA2zE534odU+4bRv
   uPC2ZdDrAguIpMoOpcGw3J7k1LdhdxtLE/ovNNCDXpXmeKtzgYqYynWx6
   OrYHMrcXLIFjdauUP7nuLdQn7b05EUs69WSjGYYageagc2AUAJU9lvOLU
   ZP4zs5NVg1Lkyfstl4P2gXREvKvX0Qdn2+YhPw37aScqMoQmaNjQ7wWej
   RvS50sosLLFFxQ+W3jh9M1zDX+u92xlU96CEYakAAKGAO243pc2a0rSt9
   elH4NGRVWjZWwKXdzXHAU2GcBDp/XVbkWCUqYvnXZcq20qM/6u5gs3rEr
   w==;
X-CSE-ConnectionGUID: tZwwttguTJKIKb9oSuh00Q==
X-CSE-MsgGUID: woettoVLS2KXDXbnjAo1Ug==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="75371715"
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="75371715"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 15:01:44 -0800
X-CSE-ConnectionGUID: /Ik4MOPGRX60m5ZRK8SEQw==
X-CSE-MsgGUID: CR5Znu9hQVKOq1mhyKZqKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="193734035"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 15:01:45 -0800
Date: Wed, 12 Nov 2025 15:01:38 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Borislav Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v4 4/8] KVM: VMX: Handle MMIO Stale Data in VM-Enter
 assembly via ALTERNATIVES_2
Message-ID: <20251112230138.nepccbv3wf5em5ra@desk>
References: <20251031003040.3491385-1-seanjc@google.com>
 <20251031003040.3491385-5-seanjc@google.com>
 <20251112164144.GAaRS4yKgF0gQrLSnR@fat_crate.local>
 <aRTAlEaq-bI5AMFA@google.com>
 <20251112183836.GBaRTULLaMWA5hkfT9@fat_crate.local>
 <aRTubGCENf2oypeL@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRTubGCENf2oypeL@google.com>

On Wed, Nov 12, 2025 at 12:30:36PM -0800, Sean Christopherson wrote:
> VMX "needs" to abuse RFLAGS no matter what, because RFLAGS is the only register
> that's available at the time of VMLAUNCH/VMRESUME.  On Intel, only RSP and
> RFLAGS are context switched via the VMCS, all other GPRs need to be context
> switch by software.  Which is why I didn't balk at Pawan's idea to use RFLAGS.ZF
> to track whether or not a VERW for MMIO is needed.
> 
> Hmm, actually, @flags is already on the stack because it's needed at VM-Exit.
> Using EBX was a holdover from the conversion from inline asm to "proper" asm,
> e.g. from commit 77df549559db ("KVM: VMX: Pass @launched to the vCPU-run asm via
> standard ABI regs").
> 
> Oooh, and if we stop using bt+RFLAGS.CF, then we drop the annoying SHIFT definitions
> in arch/x86/kvm/vmx/run_flags.h.
> 
> Very lightly tested at this point, but I think this can all be simplified to
> 
> 	/*
> 	 * Note, ALTERNATIVE_2 works in reverse order.  If CLEAR_CPU_BUF_VM is
> 	 * enabled, do VERW unconditionally.  If CPU_BUF_VM_MMIO is enabled,
> 	 * check @flags to see if the vCPU has access to host MMIO, and do VERW
> 	 * if so.  Else, do nothing (no mitigations needed/enabled).
> 	 */
> 	ALTERNATIVE_2 "",									  \
> 		      __stringify(testl $VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO, WORD_SIZE(%_ASM_SP); \

WORD_SIZE(%_ASM_SP) is still a bit fragile, but this is definitely an
improvement.

> 				  jz .Lskip_clear_cpu_buffers;					  \
> 				  VERW;								  \
> 				  .Lskip_clear_cpu_buffers:),					  \
> 		      X86_FEATURE_CLEAR_CPU_BUF_VM_MMIO,					  \
> 		      __stringify(VERW), X86_FEATURE_CLEAR_CPU_BUF_VM
> 
> 	/* Check if vmlaunch or vmresume is needed */
> 	testl $VMX_RUN_VMRESUME, WORD_SIZE(%_ASM_SP)
> 	jz .Lvmlaunch

