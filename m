Return-Path: <kvm+bounces-26878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EA529978C11
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 02:16:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E92D1C2290B
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 00:16:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23A4723CE;
	Sat, 14 Sep 2024 00:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CTfKcAmr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995EB1370;
	Sat, 14 Sep 2024 00:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726273004; cv=none; b=QhRo62sk6XWaX+w6+UVPmzPCMsEgO2oPSqSbkuXQaVMqhgr3mwW4zgcfQuTgoSdtTsCD4JUJDSPXP/bpMde5xfZae10/eRBaaniXJxvHunmvCujM4cDGkFnNbtRcnLoa3ny3/XjSTf+tPT/S7OiwHJwZ96b21rjjWq4AQjqRJIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726273004; c=relaxed/simple;
	bh=ObSmvscYaRXKIg1yx72Ji1fQveuKwgCMhUB67aQXL2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oRxtDDLQhcRQsa4N/M8BJQg16rNYy0KC9i0LeQ9X6jIKD3C55RiJzLkYKzaROWjKww92I3eDEWIHKbRRRoL2HMEPfFp1QrsOB0Awi739jtXwpH5N+gNicCq0v41XN25Ibkm0GH4rfrQFi6ClHZVj+ujCDeQNhvgpMbUxGzTy3k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CTfKcAmr; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726273002; x=1757809002;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=ObSmvscYaRXKIg1yx72Ji1fQveuKwgCMhUB67aQXL2M=;
  b=CTfKcAmrkpOvyL+iTMQbL1joYsPG6hkDHThEvRlIOq+PsFWlQVcPq8gY
   mN64NJ3LeqC2EabR+AUGSsPtBvsIk8eJ5xfgOtoe3gWHfCttEv2Z2lHWc
   S4S8tlp73hWiA4/zj8jWdX98hLr5xQUTCCGI+StjIOcnp04xr/pJ4+CpJ
   T6Yww3bZGKsp+0EHR1+MNpSiveZ9Skd/hGfUIl/qJSzLRPmX4Y7Uo8zQO
   e+3nfN1O8XTA32ofGeC2LfCpqwjzTmJpb3e7zBokcBSGKJ0NFsmQaNtFt
   tebuy4Y0JBIG3GhI7QYO8JsftHSsl4LRgSmP7aDlzGvmlYzpcJylKlGQ5
   g==;
X-CSE-ConnectionGUID: tGTCTMGzQWihaqKnrSsb9w==
X-CSE-MsgGUID: Pc72cwrASmSofgcOhDEEdA==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="25343544"
X-IronPort-AV: E=Sophos;i="6.10,227,1719903600"; 
   d="scan'208";a="25343544"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2024 17:16:42 -0700
X-CSE-ConnectionGUID: l9kFhpPHRKilOw5t8bluXg==
X-CSE-MsgGUID: 3bEsX3aZTq+jl6mjv+g88A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,227,1719903600"; 
   d="scan'208";a="91521412"
Received: from tbrumzie-mobl2.amr.corp.intel.com (HELO desk) ([10.125.147.158])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2024 17:16:41 -0700
Date: Fri, 13 Sep 2024 17:16:23 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Jim Mattson <jmattson@google.com>
Cc: Chao Gao <chao.gao@intel.com>, Jon Kohler <jon@nutanix.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, X86 ML <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"kvm @ vger . kernel . org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] x86/bhi: avoid hardware mitigation for
 'spectre_bhi=vmexit'
Message-ID: <20240914001623.fzpc2dunmpidi47a@desk>
References: <20240912141156.231429-1-jon@nutanix.com>
 <20240912151410.bazw4tdc7dugtl6c@desk>
 <070B4F7E-5103-4C1B-B901-01CE7191EB9A@nutanix.com>
 <20240912162440.be23sgv5v5ojtf3q@desk>
 <ZuPNmOLJPJsPlufA@intel.com>
 <CALMp9eRDtcYKsxqW=z6m=OqF+kB6=GiL-XaWrVrhVQ_2uQz_nA@mail.gmail.com>
 <CALMp9eTQUznmXKAGYpes=A0b1BMbyKaCa+QAYTwwftMN3kufLA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eTQUznmXKAGYpes=A0b1BMbyKaCa+QAYTwwftMN3kufLA@mail.gmail.com>

On Fri, Sep 13, 2024 at 04:04:56PM -0700, Jim Mattson wrote:
> > The IA32_SPEC_CTRL mask and shadow fields should be perfect for this.
> 
> In fact, this is the guidance given in
> https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/branch-history-injection.html:
> 
> The VMM should use the “virtualize IA32_SPEC_CTRL” VM-execution
> control to cause BHI_DIS_S to be set (see the VMM Support for
> BHB-clearing Software Sequences section) whenever:
> o The VMM is running on a processor for which the short software
> sequence may not be effective:
>   - Specifically, it does not enumerate BHI_NO, but does enumerate
> BHI_DIS_S, and is not an Atom-only processor.
> 
> In other words, the VMM should set bit 10 in the IA32_SPEC_CTRL mask
> on SPR. As long as the *effective* guest IA32_SPEC_CTRL value matches
> the host value, there is no need to write the MSR on VM-{entry,exit}.

With host setting the effective BHI_DIS_S for guest using virtual
SPEC_CTRL, there will be no way for guest to opt-out of BHI mitigation.
Or if the guest is mitigating BHI with the software sequence, it will
still get the hardware mitigation also.

To overcome this, the guest and KVM need to implement
MSR_VIRTUAL_MITIGATION_CTRL to allow guest to opt-out of hardware
mitigation.

> There is no need to disable BHI_DIS_S on the host and use the TSX
> abort sequence in its place.

Exactly.

