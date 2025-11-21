Return-Path: <kvm+bounces-64257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 279F6C7BBE5
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 22:26:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 96DBD35A0C2
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 21:26:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9CEE305045;
	Fri, 21 Nov 2025 21:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X9US9B8H"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A06A533D6;
	Fri, 21 Nov 2025 21:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763760397; cv=none; b=fasCaYv1ZX5hMybfOefcmlBdgTzTYkxrQCCJeq5T8ENUrTPlo3fBc8iMz/gN1QuFF8OvqKTF8oFw1IZTaVQbqMuLLhFj2x/Cxp0SGc7ctkKouvGE3n6gmBT0ASyZZqL4I5x3s/iXQXLu3un7tnOMrGXsBBffhxnLZqpyPZBH2D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763760397; c=relaxed/simple;
	bh=bjI6AUiW5YsANaXNed0oFZeJSdxRaGTrz3o/VZFniFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RUNlLSUgYQktobEkuWMWw5ujVKpsqiC0z6ZetShA/cvuyZ5IBhYIq/Qfzr6VOenSVb5j+cQS9jlRJgXtOYLourNcwhWG6d6CW1QPqT+Ergp+fgAOuSXvVM5/VsHjhMIjOU8Nm04Q1yMh4iDCDTMFEQv6ddgY4GflLuaWHf9Zsnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X9US9B8H; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763760395; x=1795296395;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bjI6AUiW5YsANaXNed0oFZeJSdxRaGTrz3o/VZFniFs=;
  b=X9US9B8HoS3w6+iRNKE5O9IUbPErsyGyo27N5pVYB2O5Vzdzn/b1QDIV
   6bE3g+U5fKyqylWPU77xNY++HDiA9JnKf0qgbb1j+0bZnNkuS39XAnTGz
   yBI//I7vxi1EUfkQqCQ3MQ05lOYCZHvSA3EEvqVvzbzqal8C28+Q1JeJG
   FLGWQI6T1caPZm6csKAlqWeh8hGe2YQW5VA+40wvGyjm0sDpa/4PNVTL6
   hLNkCc0f0TVfkXpdgrGhF5raXv5FLK1kZWUN6sD2XFkXWJiqd5JcIzPQd
   msFrB3e0pOIdvmESpAu81FRYyeGBE6y90Y4U9CTl1ehf74Inw/Ba9KGtm
   Q==;
X-CSE-ConnectionGUID: rMYvK2HHSriK16womvRIvQ==
X-CSE-MsgGUID: Ohu5ScU+TIaUTTH91ONzpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11620"; a="76189279"
X-IronPort-AV: E=Sophos;i="6.20,216,1758610800"; 
   d="scan'208";a="76189279"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2025 13:26:33 -0800
X-CSE-ConnectionGUID: /JWUQO7OQGK4k4NuGPUa8A==
X-CSE-MsgGUID: g4rQLt5DTGeRabvV4iJa6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,216,1758610800"; 
   d="scan'208";a="191826651"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2025 13:26:33 -0800
Date: Fri, 21 Nov 2025 13:26:27 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Nikolay Borisov <nik.borisov@suse.com>, x86@kernel.org,
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
Message-ID: <20251121212627.6vweba7aehs4cc3h@desk>
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
 <20251119-vmscape-bhb-v4-4-1adad4e69ddc@linux.intel.com>
 <4ed6763b-1a88-4254-b063-be652176d1af@intel.com>
 <e9678dd1-7989-4201-8549-f06f6636274b@suse.com>
 <f7442dc7-be8d-43f8-b307-2004bd149910@intel.com>
 <20251121181632.czfwnfzkkebvgbye@desk>
 <e99150f3-62d4-4155-a323-2d81c1d6d47d@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e99150f3-62d4-4155-a323-2d81c1d6d47d@intel.com>

On Fri, Nov 21, 2025 at 10:42:24AM -0800, Dave Hansen wrote:
> On 11/21/25 10:16, Pawan Gupta wrote:
> > On Fri, Nov 21, 2025 at 08:50:17AM -0800, Dave Hansen wrote:
> >> On 11/21/25 08:45, Nikolay Borisov wrote:
> >>> OTOH: the global variable approach seems saner as in the macro you'd
> >>> have direct reference to them and so it will be more obvious how things
> >>> are setup.
> >>
> >> Oh, yeah, duh. You don't need to pass the variables in registers. They
> >> could just be read directly.
> > 
> > IIUC, global variables would introduce extra memory loads that may slow
> > things down. I will try to measure their impact. I think those global
> > variables should be in the .entry.text section to play well with PTI.
> 
> Really? I didn't look exhaustively, but CLEAR_BRANCH_HISTORY seems to
> get called pretty close to where the assembly jumps into C. Long after
> we're running on the kernel CR3.

You are right. PTI is not a concern here.

> > Also I was preferring constants because load values from global variables
> > may also be subject to speculation. Although any speculation should be
> > corrected before an indirect branch is executed because of the LFENCE after
> > the sequence.
> 
> I guess that's a theoretical problem, but it's not a practical one.

Probably yes. But, load from memory would certainly be slower compared to
immediates.

> So I think we have 4-ish options at this point:
> 
> 1. Generate the long and short sequences independently and in their
>    entirety and ALTERNATIVE between them (the original patch)
> 2. Store the inner/outer loop counts in registers and:
>   2a. Load those registers from variables
>   2b. Load them from ALTERNATIVES

Both of these look to be good options to me.

2b. would be my first preference, because it keeps the loop counts as
inline constants. The resulting sequence stays the same as it is today.

> 3. Store the inner/outer loop counts in variables in memory

I could be wrong, but this will likely have non-zero impact on performance.
I am afraid to cause any regressions in BHI mitigation. That is why I
preferred the least invasive approach in my previous attempts.

