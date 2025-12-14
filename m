Return-Path: <kvm+bounces-65950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A035CBBEEA
	for <lists+kvm@lfdr.de>; Sun, 14 Dec 2025 19:45:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 402423007DBE
	for <lists+kvm@lfdr.de>; Sun, 14 Dec 2025 18:45:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16C7E2749E6;
	Sun, 14 Dec 2025 18:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eCBTNeQ4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD20224B15;
	Sun, 14 Dec 2025 18:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765737923; cv=none; b=EBVYbTdFgp+g8cCjRgLPua0nAzSIOO0Gt3/B3eBxVfNgcFBgV/CDkUBO19j2ogOE8RY5PUrgj86e9QBdjqXz1ZkEgmUDnYj/0uBZcvyTMOltHyORfA+sbXXbeBeJG0eCbM80UZ77GLX3gHvRQh/79kWkLF4OC7lmugrgYQWbeF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765737923; c=relaxed/simple;
	bh=53v+LXqIcnA1314+HueH+Wo/nhySN/y/0XIUVLVDz7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QMbR95jd7DHkgXByhzYW8Bt4z8dCRnhHmrS8e6ehaQQM1AputFIRMoMST9MVVwHGP2RNdwjB67+qzRkP7md49EN7u0ttySl+yiKv15xs/1oNcsJXsLOrZ4Fbnud6IPyFF/HppZIrrYVLX3Zh5+mU09ZU2lAov7o8ebtuLh8Z6q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eCBTNeQ4; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765737921; x=1797273921;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=53v+LXqIcnA1314+HueH+Wo/nhySN/y/0XIUVLVDz7w=;
  b=eCBTNeQ4yWxBZaT4yLrJY7sArpm+UHCGlMRm2cLQmzZhzMjJ6gWfywVK
   GtKDILkCLaYVyE562KbXNU20UWzEdStxO0QvAu3W2SdXF82hDrE7VVIBm
   N5kp24y/Uw97Ryc+JFGU430XPl4/kRZ73Ko4iZpzLMnNR+SuWOJ8NMHob
   3biDleYTSzr6lW1CZZbDov2kITQFxTkVwVvR8BluWu290JDQ8BxQAhnCg
   6Vk7p2tBwj9SJa/SnBQosERLw3FM5Glf9OQwjqZKBdOMdBrh4blMUDBpW
   drqyGZStpZ60ROsVUQDcp7PekUXZBFZ0TJwrzAtdgj3DUf4v+IWH6En8H
   w==;
X-CSE-ConnectionGUID: t7krjHfnTIa/RgFSLEFOPQ==
X-CSE-MsgGUID: KCApef0lRT2zxz6p3d4S5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11642"; a="55216768"
X-IronPort-AV: E=Sophos;i="6.21,148,1763452800"; 
   d="scan'208";a="55216768"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2025 10:45:21 -0800
X-CSE-ConnectionGUID: kdvrFa+RRnyL9ZChfyk/oA==
X-CSE-MsgGUID: UlSar2s/SpiuW7APZDn7aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,148,1763452800"; 
   d="scan'208";a="197602442"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2025 10:45:21 -0800
Date: Sun, 14 Dec 2025 10:45:12 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, David Kaplan <david.kaplan@amd.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: Re: [PATCH v6 6/9] x86/vmscape: Use static_call() for predictor flush
Message-ID: <20251214184512.mkbxzrzmuqoej7kw@desk>
References: <20251201-vmscape-bhb-v6-0-d610dd515714@linux.intel.com>
 <20251201-vmscape-bhb-v6-6-d610dd515714@linux.intel.com>
 <20251211105050.GB3707891@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251211105050.GB3707891@noisy.programming.kicks-ass.net>

On Thu, Dec 11, 2025 at 11:50:50AM +0100, Peter Zijlstra wrote:
> On Mon, Dec 01, 2025 at 10:20:14PM -0800, Pawan Gupta wrote:
> > Adding more mitigation options at exit-to-userspace for VMSCAPE would
> > usually require a series of checks to decide which mitigation to use. In
> > this case, the mitigation is done by calling a function, which is decided
> > at boot. So, adding more feature flags and multiple checks can be avoided
> > by using static_call() to the mitigating function.
> > 
> > Replace the flag-based mitigation selector with a static_call(). This also
> > frees the existing X86_FEATURE_IBPB_EXIT_TO_USER.
> > 
> > Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> > ---
> >  arch/x86/Kconfig                     | 1 +
> >  arch/x86/include/asm/cpufeatures.h   | 2 +-
> >  arch/x86/include/asm/entry-common.h  | 7 +++----
> >  arch/x86/include/asm/nospec-branch.h | 3 +++
> >  arch/x86/kernel/cpu/bugs.c           | 5 ++++-
> >  arch/x86/kvm/x86.c                   | 2 +-
> >  6 files changed, 13 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index fa3b616af03a2d50eaf5f922bc8cd4e08a284045..066f62f15e67e85fda0f3fd66acabad9a9794ff8 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -2706,6 +2706,7 @@ config MITIGATION_TSA
> >  config MITIGATION_VMSCAPE
> >  	bool "Mitigate VMSCAPE"
> >  	depends on KVM
> > +	select HAVE_STATIC_CALL
> 
> That can't be right.

Hmm, should be "depends on HAVE_STATIC_CALL". Will fix it, thanks.

