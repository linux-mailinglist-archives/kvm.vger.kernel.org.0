Return-Path: <kvm+bounces-61739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 032CDC27244
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 23:50:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B0CA3BA537
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 22:50:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 625433126D2;
	Fri, 31 Oct 2025 22:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OHxjxcMn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28C72DEA74;
	Fri, 31 Oct 2025 22:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761951037; cv=none; b=sHscSsSVDVB9oQmXj4ThIojAWwJE4ZDSvBbRkl2YXkMbNflWvmIx44FgztTkA+ub/JD9luH8hMFKcaxCqu2WK6osrDeGPrNtUO1bdEgrZcjOPTdNQ1Mv4OUmJQqH9PF23TunhNj1ztHzDQA0Q64tZSCkEHrMydPYdI1vAugyDMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761951037; c=relaxed/simple;
	bh=N+BjP6skRoZCMXqZexziR26mcgroiZe+JaxD8LzzPKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fOhQGyPjr+ysjhH9fn9m18bBacggqj1abfDw2p8OlXV3IUH9wIBsMNvFQEUkWvpkTdmF4QkzUk587+3kik05GNkiW7SqvFww/RVUgxZS+j89lLvVOiIiw9pWMGtan1wkbo4a7UL2EnJPY5eZoHDiQwpB80tnSfJA15IC0XKxBss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OHxjxcMn; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761951035; x=1793487035;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=N+BjP6skRoZCMXqZexziR26mcgroiZe+JaxD8LzzPKE=;
  b=OHxjxcMnLzfFW7qBc7p8VQDol+s9nbojcg99zMZNw7Ody2T9d+VHSTgE
   okQqJUBrz8rikGWAtqcm6eRixLEVNvAxVFzW2AXeh52fnYuNoEhDynQJu
   ZhOI//9kyFedE2LNEE+14h5CCy8vEGGc4rhZUyXpgkuVego1eqmo1Vif/
   +7iW3p07HUatdwNLzxQRICldoon6RLv2+vsPQ/dins/KOZtnCrodvIV7k
   pgZdTFPjVCYRJS2DOYjEniqEmvHT91FxtZQ7yn75uZ1nucRM/BcGAWfgS
   gb2EBV30su8clI36QfJ6QUJq3D02awDbF9EqnMQKAeeFo2p8wbOsLxwSG
   w==;
X-CSE-ConnectionGUID: qRz9QUgPQCmy52SoVzHqvQ==
X-CSE-MsgGUID: sv4chqy3SESLHNOlYr37Rg==
X-IronPort-AV: E=McAfee;i="6800,10657,11599"; a="86744645"
X-IronPort-AV: E=Sophos;i="6.19,270,1754982000"; 
   d="scan'208";a="86744645"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 15:50:35 -0700
X-CSE-ConnectionGUID: lkyuywq9TSaZ/I5sEjb6ew==
X-CSE-MsgGUID: ++e7E4N7S5u8p3vT24J+VQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,270,1754982000"; 
   d="scan'208";a="209907241"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO desk) ([10.124.220.87])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 15:50:34 -0700
Date: Fri, 31 Oct 2025 15:50:28 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v4 3/8] x86/bugs: Use an X86_FEATURE_xxx flag for the
 MMIO Stale Data mitigation
Message-ID: <20251031225028.fe2jztp4v5peqttb@desk>
References: <20251031003040.3491385-1-seanjc@google.com>
 <20251031003040.3491385-4-seanjc@google.com>
 <20251031222804.s26squjrtbaq7aly@desk>
 <aQU6LqP-PxBQ-R0m@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQU6LqP-PxBQ-R0m@google.com>

On Fri, Oct 31, 2025 at 03:37:34PM -0700, Sean Christopherson wrote:
> On Fri, Oct 31, 2025, Pawan Gupta wrote:
> > On Thu, Oct 30, 2025 at 05:30:35PM -0700, Sean Christopherson wrote:
> > > Convert the MMIO Stale Data mitigation flag from a static branch into an
> > > X86_FEATURE_xxx so that it can be used via ALTERNATIVE_2 in KVM.
> > > 
> > > No functional change intended.
> > > 
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/include/asm/cpufeatures.h   |  1 +
> > >  arch/x86/include/asm/nospec-branch.h |  2 --
> > >  arch/x86/kernel/cpu/bugs.c           | 11 +----------
> > >  arch/x86/kvm/mmu/spte.c              |  2 +-
> > >  arch/x86/kvm/vmx/vmx.c               |  4 ++--
> > >  5 files changed, 5 insertions(+), 15 deletions(-)
> > > 
> > > diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> > > index 7129eb44adad..d1d7b5ec6425 100644
> > > --- a/arch/x86/include/asm/cpufeatures.h
> > > +++ b/arch/x86/include/asm/cpufeatures.h
> > > @@ -501,6 +501,7 @@
> > >  #define X86_FEATURE_ABMC		(21*32+15) /* Assignable Bandwidth Monitoring Counters */
> > >  #define X86_FEATURE_MSR_IMM		(21*32+16) /* MSR immediate form instructions */
> > >  #define X86_FEATURE_X2AVIC_EXT		(21*32+17) /* AMD SVM x2AVIC support for 4k vCPUs */
> > > +#define X86_FEATURE_CLEAR_CPU_BUF_MMIO	(21*32+18) /* Clear CPU buffers using VERW before VMRUN, iff the vCPU can access host MMIO*/
> > 
> > Some bikeshedding from my side too:
> > s/iff/if/
> 
> Heh, that's actually intentional.  "iff" is shorthand for "if and only if".  But
> this isn't the first time my use of "iff" has confused people, so I've no objection
> to switching to "if".

I did a quick search, there are about ~500 instances of "iff" in the
kernel. So, it's a common abbreviation that I learnt today. It is fine to
keep it as is.

