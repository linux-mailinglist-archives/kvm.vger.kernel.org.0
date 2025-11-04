Return-Path: <kvm+bounces-62031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 37E2DC331FB
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 23:01:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6695018C12B2
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 22:01:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B01B42D0602;
	Tue,  4 Nov 2025 22:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ShRrGc1D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3075220F37;
	Tue,  4 Nov 2025 22:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762293669; cv=none; b=PM6IZ4R1P3k43+RnNVRMPqTjNttItBp1FMh27+DvNAn1yRbIpDRwEMktkLcttN8DWh0Z8ynb1P8LDceWrAlw+JwwI3UuYmkoGAw83LYyRmPEItN2Bs4SnDxzVA59aO4l1HqpvVvU/PXy7j0O9pVKSU5dhqgRcswcrDwXRaqqAwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762293669; c=relaxed/simple;
	bh=UF+BqzV9UYT54FrE7n4BLmjOzRp93XgcC+tPJbuWy/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uM7GML6qhHGm+ZFn9RF5rILeE3n1/9Ht2A+4DNZMat+HEonQb3z3E9KL02xycvgCZhGdhOSXaUmQfB8wBpuwr4RqoKHayd4TorvFEIKPFulhhY7Rfe8BU7clYY2k9dVGa6bBfGoF5wNR5Gy4mZJZuorFPkwUe/g8cSucj6rLn+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ShRrGc1D; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762293668; x=1793829668;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UF+BqzV9UYT54FrE7n4BLmjOzRp93XgcC+tPJbuWy/U=;
  b=ShRrGc1DYTUHFY4ug0Q7cOCBgqgLMooMq4g9HWJtZoWvwvdZuLbaUR4P
   WcFBoPen1h92D3oNbi4FF+/ucQELGWnVZaQXTq5GdQzBHEE7wFcy6ExoD
   6e1fFkY0o07BunCnx7OFkGUlEXFa8TXhI3sAXWTYSJsBU8NyaAGk9/Dk6
   798VEVcYkphDGhSjyZGBFUAvrbzKSubvEauKza9aLCwW1JPVrrD0btpGS
   VaP2wDiP5DRS52llJbNJB9Lz3cKTXBkZrUCiNrP3GxcBmH9mztZ28aV/V
   pxJBzw/uo27mFXMFZQorzC3q4UKMsBV7HJ1Y6r3pkmM4OeKgfC4bfJ4ZU
   w==;
X-CSE-ConnectionGUID: WmqiljvpSfOOky/67yhhcw==
X-CSE-MsgGUID: MEVVD48uSKCooYCPPIauXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64307932"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64307932"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 14:01:06 -0800
X-CSE-ConnectionGUID: TppXmAYDQ6eBaZBefOC5hQ==
X-CSE-MsgGUID: RvUqZEQcTi+DH+8tSzY7bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,280,1754982000"; 
   d="scan'208";a="186523485"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO desk) ([10.124.221.88])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 14:01:05 -0800
Date: Tue, 4 Nov 2025 14:01:00 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: Re: [PATCH v3 3/3] x86/vmscape: Remove LFENCE from BHB clearing long
 loop
Message-ID: <20251104220100.wrorcuok5slqy74u@desk>
References: <20251027-vmscape-bhb-v3-0-5793c2534e93@linux.intel.com>
 <20251027-vmscape-bhb-v3-3-5793c2534e93@linux.intel.com>
 <c98e68f0-e5e2-482d-9a64-ad8164e4bae8@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c98e68f0-e5e2-482d-9a64-ad8164e4bae8@intel.com>

On Mon, Nov 03, 2025 at 12:45:35PM -0800, Dave Hansen wrote:
> On 10/27/25 16:43, Pawan Gupta wrote:
> > Long loop is used to clear the branch history when switching from a guest
> > to host userspace. The LFENCE barrier is not required in this case as ring
> > transition itself acts as a barrier.
> > 
> > Move the prologue, LFENCE and epilogue out of __CLEAR_BHB_LOOP macro to
> > allow skipping the LFENCE in the long loop variant. Rename the long loop
> > function to clear_bhb_long_loop_no_barrier() to reflect the change.
> 
> Too. Much. Assembly.
>
> Is there a reason we can't do more of this in C?

Apart from VMSCAPE, BHB clearing is also required when entering kernel from
system calls. And one of the safety requirement is to absolutely not
execute any indirect call/jmp unless we have cleared the BHB. In a C
implementation we cannot guarantee that the compiler won't generate
indirect branches before the BHB clearing can be done.

> Can we have _one_ assembly function, please? One that takes the loop
> counts? No macros, no duplication functions. Just one:

This seems possible for all the C callers. ASM callers should stick to asm
versions of BHB clearing to guarantee the compiler did not do anything
funky that would break the mitigation.

> 	void __clear_bhb_loop(int inner, int outer);
> 
> Then we have sensible code that looks like this:
> 
> 	void clear_bhb_loop()
> 	{
> 		__clear_bhb_loop(inner, outer);
> 		lfence();
> 	}
> 
> 	void clear_bhb_loop_nofence()
> 	{
> 		__clear_bhb_loop(inner, outer);
> 	}
> 
> We don't need a short and a long *version*. We just have one function
> (or pair of functions) that gets called that works everywhere.
> 
> Actually, if you just used global variables and called the assembly one:
> 
> 	extern void clear_bhb_loop_nofence();
> 
> then the other implementation would just be:
> 
> 	void clear_bhb_loop()
> 	{
> 		__clear_bhb_loop(inner, outer);
> 		lfence();
> 	}
> 
> Then we have *ONE* assembly function instead of four.
> 
> Right? What am I missing?

Overall, these look to be good improvements to me. The only concern is
making sure that we don't inadvertently call the C version from places that
strictly require no indirect branches before BHB clearing.

> Does the LFENCE *need* to be before that last pop and RET?

At syscall entry, VMexit and BPF (for native BHI mitigation), it does not
matter whether the LFENCE is before or after the last RET, if we can
guarantee that there will be no indirect call/jmp before LFENCE. C version
may not be able to provide this guarantee.

For exit-to-userspace (for VMSCAPE), C implementation is perfectly fine
since the goal is to protect userspace.

To summarize, only 1 of the BHB clear callsite can safely use the C
version, while others need to continue to use the assembly version. I do
not anticipate more such callsites that would be okay with indirect
branches before BHB clearing.

I am open to suggestions on making the code more readable while ensuring
the safety.

