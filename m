Return-Path: <kvm+bounces-46690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49CDDAB894C
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 16:23:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF6F917C7AB
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 14:22:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A58DC1DE88A;
	Thu, 15 May 2025 14:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H0+PtxAP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180AA18FC91;
	Thu, 15 May 2025 14:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747318928; cv=none; b=nrBeaB+vbio3sWj+hPkByxOcc362qK5yrDPXK6FYLBBxfpUyzdOhElTTRgyZxjvTEGsbZb077tXCQ4UK3jUJ2oRYV5+DkKqZLAT8YqCUWU7ykRmI6Tp4HD9cUoiRWlTABDOQoNHcyHYw0JTJutW6YaKRhK560vVM/4I3fB4s+/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747318928; c=relaxed/simple;
	bh=dHqEeggz/sGBQSp6+BlyRI5Po6EHhiF7PVmQa+VQnfI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L++8PbFvODQhz50SR/t1BRIoHtsTTUX2FMnlbUzlRKRSF0ACvHMjLpKQZMUFf4t9bjSZgq8YjXfpJGEO8GPgkSW2rnZ/KoZJCeah9FDX1Sm1R93dKZKghvBh/Dj1d552+XHlAmDz//Pyn/cChiEQMXDEXaFoG+N4RmX74H+0ULk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H0+PtxAP; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747318927; x=1778854927;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dHqEeggz/sGBQSp6+BlyRI5Po6EHhiF7PVmQa+VQnfI=;
  b=H0+PtxAPNrRDZOpaYnR9hhLdZ3nqci8DuqeIfMSQSl3i5Ya+qEysN/gV
   Fuou/inS1qi1pzfYOF3oyadCUw/u0dAGAeFtHH1hjBU8nFgKdW7QVyy6x
   86HEaYGLfY09XvCL/QOpFJAiVBUl9rsrLKurpt8MecctqiOW1LPNLCWAy
   dTC+vXBh5StECyo+BgNVaLs08IUqC6dzAWE0dTDiR9X3bWJV6qWBxRMwM
   24UMGeEvT9CgSxqgJq2kt0X/bxK9E7ZKEMpHECVgweTeItrnbW4iITrQs
   +NL9JWgXAaBjoB1jURZdLxTMRjkFoZPbFJsvpnoi4mBZIoEvKZghHLHy3
   g==;
X-CSE-ConnectionGUID: 8HjmMDMRQ/y/jfMUabLS8A==
X-CSE-MsgGUID: EM5WIFYqT0KVPhAJ9HUiAw==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="60597584"
X-IronPort-AV: E=Sophos;i="6.15,291,1739865600"; 
   d="scan'208";a="60597584"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 07:22:06 -0700
X-CSE-ConnectionGUID: 3Ica6LFpTe2/lrzVobNRMg==
X-CSE-MsgGUID: scHxO3ftQwOEFQSNhwV6Vg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,291,1739865600"; 
   d="scan'208";a="138264488"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa006.fm.intel.com with ESMTP; 15 May 2025 07:22:02 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 0900238D; Thu, 15 May 2025 17:22:00 +0300 (EEST)
Date: Thu, 15 May 2025 17:22:00 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, rick.p.edgecombe@intel.com, 
	isaku.yamahata@intel.com, kai.huang@intel.com, yan.y.zhao@intel.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, kvm@vger.kernel.org, 
	x86@kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 00/12] TDX: Enable Dynamic PAMT
Message-ID: <pla54zy4z27df57uxmzuog26mddiezbwsyrurnjxivdkg5dibx@574tcxdgjru2>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <aCSddrn7D4J-9iUU@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCSddrn7D4J-9iUU@google.com>

On Wed, May 14, 2025 at 06:41:10AM -0700, Sean Christopherson wrote:
> On Fri, May 02, 2025, Kirill A. Shutemov wrote:
> > This RFC patchset enables Dynamic PAMT in TDX. It is not intended to be
> > applied, but rather to receive early feedback on the feature design and
> > enabling.
> 
> In that case, please describe the design, and specifically *why* you chose this
> particular design, along with the constraints and rules of dynamic PAMTs that
> led to that decision.  It would also be very helpful to know what options you
> considered and discarded, so that others don't waste time coming up with solutions
> that you already rejected.

Dynamic PAMT support in TDX module
==================================

Dynamic PAMT is a TDX feature that allows VMM to allocate PAMT_4K as
needed. PAMT_1G and PAMT_2M are still allocated statically at the time of
TDX module initialization. At init stage allocation of PAMT_4K is replaced
with PAMT_PAGE_BITMAP which currently requires one bit of memory per 4k.

VMM is responsible for allocating and freeing PAMT_4K. There's a pair of
new SEAMCALLs for it: TDH.PHYMEM.PAMT.ADD and TDH.PHYMEM.PAMT.REMOVE. They
add/remove PAMT memory in form of page pair. There's no requirement for
these pages to be contiguous.

Page pair supplied via TDH.PHYMEM.PAMT.ADD will cover specified 2M region.
It allows any 4K from the region to be usable by TDX module.

With Dynamic PAMT, a number of SEAMCALLs can now fail due to missing PAMT
memory (TDX_MISSING_PAMT_PAGE_PAIR):

 - TDH.MNG.CREATE
 - TDH.MNG.ADDCX 
 - TDH.VP.ADDCX
 - TDH.VP.CREATE
 - TDH.MEM.PAGE.ADD
 - TDH.MEM.PAGE.AUG 
 - TDH.MEM.PAGE.DEMOTE
 - TDH.MEM.PAGE.RELOCATE

Basically, if you supply memory to a TD, this memory has to backed by PAMT
memory.

Once no TD uses the 2M range, the PAMT page pair can be reclaimed with
TDH.PHYMEM.PAMT.REMOVE.

TDX module track PAMT memory usage and can give VMM a hint that PAMT
memory can be removed. Such hint is provided from all SEAMCALLs that
removes memory from TD:

 - TDH.MEM.SEPT.REMOVE
 - TDH.MEM.PAGE.REMOVE
 - TDH.MEM.PAGE.PROMOTE
 - TDH.MEM.PAGE.RELOCATE
 - TDH.PHYMEM.PAGE.RECLAIM

With Dynamic PAMT, TDH.MEM.PAGE.DEMOTE takes PAMT page pair as additional
input to populate PAMT_4K on split. TDH.MEM.PAGE.PROMOTE returns no longer
needed PAMT page pair.

PAMT memory is global resource and not tied to a specific TD. TDX modules
maintains PAMT memory in a radix tree addressed by physical address. Each
entry in the tree can be locked with shared or exclusive lock. Any
modification of the tree requires exclusive lock.

Any SEAMCALL that takes explicit HPA as an argument will walk the tree
taking shared lock on entries. It required to make sure that the page
pointed by HPA is of compatible type for the usage.

TDCALLs don't take PAMT locks as none of the take HPA as an argument.

Dynamic PAMT enabling in kernel
===============================

Kernel maintains refcounts for every 2M regions with two helpers
tdx_pamt_get() and tdx_pamt_put().

The refcount represents number of users for the PAMT memory in the region.
Kernel calls TDH.PHYMEM.PAMT.ADD on 0->1 transition and
TDH.PHYMEM.PAMT.REMOVE on transition 1->0.

PAMT memory gets allocated as part of TD init, VCPU init, on populating
SEPT tree and adding guest memory (both during TD build and via AUG on
accept).

PAMT memory removed on reclaim of control pages and guest memory.

Populating PAMT memory on fault is tricky as we cannot allocate memory
from the context where it is needed. I introduced a pair of kvm_x86_ops to
allocate PAMT memory from a per-VCPU pool from context where VCPU is still
around and free it on failuire. This flow will likely be reworked in next
versions.

Previous attempt on Dynamic PAMT enabling
=========================================

My initial kernel enabling attempt was quite different. I wanted to make
PAMT allocation lazy: only try to add PAMT page pair if a SEAMCALL fails
due to missing PAMT and reclaim it back based on hint provided by the TDX
module.

The motivation was to avoid duplication of PAMT memory refcounting that
TDX module does on kernel side.

This approach is inherently more racy as we don't serialize PAMT memory
add/remove against SEAMCALLs that uses add/remove memory for a TD. Such
serialization would require global locking which is no-go.

I made this approach work, but at some point I realized that it cannot be
robust as long as we want to avoid TDX_OPERAND_BUSY loops.
TDX_OPERAND_BUSY will pop up as result of the races I mentioned above.

I gave up on this approach and went with the current one which uses
explicit refcounting.


Brain dumped.

Let me know if anything is unclear.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

