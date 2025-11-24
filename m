Return-Path: <kvm+bounces-64427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D24B1C824F6
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 20:31:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D252E3ADEEC
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 19:31:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF4182BD590;
	Mon, 24 Nov 2025 19:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fOpa+VuM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7BF1D61A3;
	Mon, 24 Nov 2025 19:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764012695; cv=none; b=VbxufgwtEGF9Lt6d0Jv1Tnfh/O3/aJ2J8K2YSRgH4CzhNTpHyo1eYSegOxXykRsBY61Jauz5XqA5lSH3s7DtZuFApGMGyPwk4LpT1cS+oea42f54GSnaq0NeJEN7Ey3AqOc9MslMU1AMTh5vnGdNBpQsD7g/zoJNPjoySIGrsjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764012695; c=relaxed/simple;
	bh=6vvdw7cQYX+2lnZH8s4P7oTE2zfPNpMlRK98XsGkVW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o7knfhleFhD46RNOnidmn2zsjCpn0flYnlWyp9pQfpRXP0WMIq67MBkpiJ3XCOXNPwqbzI8j6lLdgPFNrUbjgiUrPq9H/541F6okSjN24dl2NWmGscyKeD1LNrXV5whps3jX/bHFN80FC3IZhdN/1hUR9Cv81ez2k7+hTYTxqkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fOpa+VuM; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764012694; x=1795548694;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6vvdw7cQYX+2lnZH8s4P7oTE2zfPNpMlRK98XsGkVW4=;
  b=fOpa+VuMOyRcM8wHuAj+iev+m4LJvn9E98IA7vQacYgq8KdLd8Si1aZu
   UKVM9KRD4koRu8Kt6bmWqisAWXxY0+aoucGsXCdsj4/f+zft/+iOgTLrV
   /liROCBWzpAsVP8rgIclHYScOqKXPXKUSrtaGAzrW/et97xeBVcnzyr46
   FzdJKXI3OvwCR98V39Hu1f6bFMWdUgNkXN9x7+lxrrBTThozr2FHZMdei
   TbjLR3I6sweyvPJSLFZUkvOoe3r8FwjHTGJGysqJoLw1+ERlpFC3xI2ux
   sQSn9PbMFcw9hi+ymSeDDNV2Tw9x/115v0v2Ek8SRqNs/2XLKVMB9QTR8
   w==;
X-CSE-ConnectionGUID: jydM0sKlRMWgKE1UcoHQSw==
X-CSE-MsgGUID: 9M4c0LAwRTiWo/6rplROSA==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="77387231"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="77387231"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 11:31:32 -0800
X-CSE-ConnectionGUID: arI9Zz5mQsC7+Y/wrxQX2A==
X-CSE-MsgGUID: j/noc/oRTkinL6K2X9+C/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="223397636"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 11:31:31 -0800
Date: Mon, 24 Nov 2025 11:31:26 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: david laight <david.laight@runbox.com>
Cc: Dave Hansen <dave.hansen@intel.com>,
	Nikolay Borisov <nik.borisov@suse.com>, x86@kernel.org,
	David Kaplan <david.kaplan@amd.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v4 04/11] x86/bhi: Make clear_bhb_loop() effective on
 newer CPUs
Message-ID: <20251124193126.sdmrhk6dw4jgf5ql@desk>
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
 <20251119-vmscape-bhb-v4-4-1adad4e69ddc@linux.intel.com>
 <4ed6763b-1a88-4254-b063-be652176d1af@intel.com>
 <e9678dd1-7989-4201-8549-f06f6636274b@suse.com>
 <f7442dc7-be8d-43f8-b307-2004bd149910@intel.com>
 <20251121181632.czfwnfzkkebvgbye@desk>
 <e99150f3-62d4-4155-a323-2d81c1d6d47d@intel.com>
 <20251121212627.6vweba7aehs4cc3h@desk>
 <20251122110558.64455a8d@pumpkin>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122110558.64455a8d@pumpkin>

On Sat, Nov 22, 2025 at 11:05:58AM +0000, david laight wrote:
> On Fri, 21 Nov 2025 13:26:27 -0800
> Pawan Gupta <pawan.kumar.gupta@linux.intel.com> wrote:
> 
> > On Fri, Nov 21, 2025 at 10:42:24AM -0800, Dave Hansen wrote:
> > > On 11/21/25 10:16, Pawan Gupta wrote:  
> > > > On Fri, Nov 21, 2025 at 08:50:17AM -0800, Dave Hansen wrote:  
> > > >> On 11/21/25 08:45, Nikolay Borisov wrote:  
> > > >>> OTOH: the global variable approach seems saner as in the macro you'd
> > > >>> have direct reference to them and so it will be more obvious how things
> > > >>> are setup.  
> > > >>
> > > >> Oh, yeah, duh. You don't need to pass the variables in registers. They
> > > >> could just be read directly.  
> > > > 
> > > > IIUC, global variables would introduce extra memory loads that may slow
> > > > things down. I will try to measure their impact. I think those global
> > > > variables should be in the .entry.text section to play well with PTI.  
> > > 
> > > Really? I didn't look exhaustively, but CLEAR_BRANCH_HISTORY seems to
> > > get called pretty close to where the assembly jumps into C. Long after
> > > we're running on the kernel CR3.  
> > 
> > You are right. PTI is not a concern here.
> > 
> > > > Also I was preferring constants because load values from global variables
> > > > may also be subject to speculation. Although any speculation should be
> > > > corrected before an indirect branch is executed because of the LFENCE after
> > > > the sequence.  
> > > 
> > > I guess that's a theoretical problem, but it's not a practical one.  
> > 
> > Probably yes. But, load from memory would certainly be slower compared to
> > immediates.
> > 
> > > So I think we have 4-ish options at this point:
> > > 
> > > 1. Generate the long and short sequences independently and in their
> > >    entirety and ALTERNATIVE between them (the original patch)
> > > 2. Store the inner/outer loop counts in registers and:
> > >   2a. Load those registers from variables
> > >   2b. Load them from ALTERNATIVES  
> > 
> > Both of these look to be good options to me.
> > 
> > 2b. would be my first preference, because it keeps the loop counts as
> > inline constants. The resulting sequence stays the same as it is today.
> > 
> > > 3. Store the inner/outer loop counts in variables in memory  
> > 
> > I could be wrong, but this will likely have non-zero impact on performance.
> > I am afraid to cause any regressions in BHI mitigation. That is why I
> > preferred the least invasive approach in my previous attempts.
> 
> Surely it won't be significant compared to the cost of the loop itself.
> That is the bit that really kills performance.

Correct, recent data suggests the same.

> For subtle reasons one of the mitigations that slows kernel entry caused
> a doubling of the execution time of a largely single-threaded task that
> spends almost all its time in userspace!
> (I thought I'd disabled it at compile time - but the config option
> changed underneath me...)

That is surprising. If its okay, could you please share more details about
this application? Or any other way I can reproduce this?

