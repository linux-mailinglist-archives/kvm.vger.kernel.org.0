Return-Path: <kvm+bounces-67095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 179ECCF6AA0
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 05:29:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4DAC8304641D
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 04:29:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55A1D280332;
	Tue,  6 Jan 2026 04:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c8gJ9AqF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE9D1A9B24;
	Tue,  6 Jan 2026 04:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767673769; cv=none; b=eP1zU7Yb/EsOsq92tkV/prf5pb4GwVAcrZC+S2Q/d9JYHLX24sijXfkWJgKAPrV4R1SUSTDaWvCriAM0m9NkaDtWZvHE5dIJrhUN8ZtnToUhCnFU1DXaF+D7MYtAguxyYL0HX3vd/dI88GE1DhziMQhsSmSPdHzm+MLlGoK6JaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767673769; c=relaxed/simple;
	bh=E7Qi2sg6WcAfO/3/z5Mpb0eyvNeHgxKfEhIO+/5XFoM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bi38YnA59m4h4PLwslCjrwgjYYogQa1XUYaEVrrux+eGC2oHEj3YyAtM8FCemwWs2WuKcjLciaqRtLg8nN+CuT8rsD4W3UZTN5iiwjL+FmWkPU87AIzJK0rKEyUFZoAVLBnXO44NzRBzyDtZqSZ0BqB422B+rGzBbhgHJdA86So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c8gJ9AqF; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767673768; x=1799209768;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=E7Qi2sg6WcAfO/3/z5Mpb0eyvNeHgxKfEhIO+/5XFoM=;
  b=c8gJ9AqFegFdLi1hCeLOi8KQkLTibiW3TF0GtDy2W+xuzv6fZz/oEmCu
   iuYMqYmcB+bHbJ5uhJitK0HQok+cOmTBZ2WNz2k5s9hEqJYieAfyLKIKX
   suY/dbla/yK28qRSCqnhGNxNgxQz3Iw303NtAMfFKUAYRk6UaodDYc40K
   KO0EUDWpWt8TFhQhE996dukikbnHV5btV1SnMTVR7SII7GcjG0UnC6Kyz
   0UwL3lL/6ydVqu3JPZAO6mCrZJvWB4ozJWVr6wovFqJS1AzbZ5VW5WUrD
   r48NGe0UIOl9ksndF1MFNWs8X8A5V/W1dOFGM3W54PRvUZCxMZBp+vTBo
   g==;
X-CSE-ConnectionGUID: yF4UO3QbSceiy6Mb5wJF2g==
X-CSE-MsgGUID: /9DTrzoaTdK5zYZPchZayQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="68945243"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="68945243"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2026 20:29:27 -0800
X-CSE-ConnectionGUID: CDelGubaSQyPHQKAiPtFkw==
X-CSE-MsgGUID: kYO5DNZbRZu/icM7psS6Nw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="201789025"
Received: from akrish4-mobl2.gar.corp.intel.com (HELO windy) ([10.247.133.231])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2026 20:29:22 -0800
Date: Mon, 5 Jan 2026 20:29:17 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org, David Kaplan <david.kaplan@amd.com>, 
	Nikolay Borisov <nik.borisov@suse.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Asit Mallick <asit.k.mallick@intel.com>, 
	Tao Zhang <tao1.zhang@intel.com>
Subject: Re: [PATCH v6 1/9] x86/bhi: x86/vmscape: Move LFENCE out of
 clear_bhb_loop()
Message-ID: <pu4fkyawy5ie5axn3whkaj7w6gilcqjzva5zru4lksw7g7y6wy@jzaq5mbhzokx>
References: <20251201-vmscape-bhb-v6-0-d610dd515714@linux.intel.com>
 <20251201-vmscape-bhb-v6-1-d610dd515714@linux.intel.com>
 <20260101125122.GCaVZtysCPB0cljZJN@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260101125122.GCaVZtysCPB0cljZJN@fat_crate.local>

On Thu, Jan 01, 2026 at 01:51:22PM +0100, Borislav Petkov wrote:
> On Mon, Dec 01, 2025 at 10:18:59PM -0800, Pawan Gupta wrote:
> > In preparation for adding the support for BHB sequence (without LFENCE) on
> > newer CPUs, move the LFENCE to the caller side after clear_bhb_loop() is
> > executed. This allows callers to decide whether they need the LFENCE or
> 
> s/This allows/Allow/

> > not. This does adds a few extra bytes to the call sites, but it obviates
> 
> s/This does adds/This adds/

Ok.

> > diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> > index ed04a968cc7d0095ab0185b2e3b5beffb7680afd..886f86790b4467347031bc27d3d761d5cc286da1 100644
> > --- a/arch/x86/entry/entry_64.S
> > +++ b/arch/x86/entry/entry_64.S
> > @@ -1528,6 +1528,9 @@ SYM_CODE_END(rewind_stack_and_make_dead)
> >   * refactored in the future if needed. The .skips are for safety, to ensure
> >   * that all RETs are in the second half of a cacheline to mitigate Indirect
> >   * Target Selection, rather than taking the slowpath via its_return_thunk.
> > + *
> > + * Note, callers should use a speculation barrier like LFENCE immediately after
> > + * a call to this function to ensure BHB is cleared before indirect branches.
> >   */
> 
> Comments do get missed. So, I'd call the function clear_bhb_loop_unfenced or
> something to that effect so that it is perfectly clear that !BHI_DIS_S parts
> will need the LFENCE at the end. This way it is in the name and should make
> people think what they're calling. I'd hope...

Sure, renaming this to clear_bhb_loop_nofence() in a separate patch.

Will send v7 after some testing.

