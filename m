Return-Path: <kvm+bounces-50990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AC83AEB859
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 15:01:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B144568587
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 13:00:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75C782D978D;
	Fri, 27 Jun 2025 13:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f5MflKJH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0014938F80;
	Fri, 27 Jun 2025 13:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751029256; cv=none; b=IKbwuDmmQHR03IsUJDWXfKbfmSgQJ+XvOv5y3XatXxPKkwd3/P54MCmZ6SCpxbG/7wteo+YEIJdYWsHcupiGDkIlo9Acs51mf4mUor0tHxzkM33cfZ1BYhsopKQ92rkIZFjgR0BljvhXmVEPp7j3v/oDYIhWhvcSd01a1xz2YRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751029256; c=relaxed/simple;
	bh=1KduQflUx5PWgx69L9xIAgh4GnKwc1j7d9n9HVvizXY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jImVZ3P3zCrSGv+Z8pNfXx1kqTOL+f8UH1jq6SSE+6o931XBT6ZeDcqWHSLW/bHIoM6m0LB7f3+Gm4xEnsiAwIh7ipoeAKYutO5Nmrn7vC7kzQYH6iwdpnhOwUHJqDcyqcIHTTXBgAUv1g80edt6a/5LqBy+u674Y5PIqar1/pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f5MflKJH; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751029255; x=1782565255;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1KduQflUx5PWgx69L9xIAgh4GnKwc1j7d9n9HVvizXY=;
  b=f5MflKJHxUKVyxw7lBlrHeAKImP3RJPUvVMw9HRGg0mezZx0htO5DLHc
   9eAOOTNpzl3HIIQonjdmI4PJFF/XXsM/MV2cJS1jYoQOiLFssia67jhhG
   k4fIXHicmoSgAyZ13HvD/tLh1wkqoFlgc9mwm21ckRCExkASNBroqFj++
   kxeXbMTcNX+jw1Z1Dj3Di1k3Ri6O60uJ1GQq/zrA3y89AoTl9yhoGI8il
   xMDF3f6SQZPClD4gL0PQ7TDxyDU65EGGAiMW1wxoUFVOlbwZmJ1ttwqrU
   ZkyX71F37pPJbrVLrLpP5s70iEgbbayG0MnLhqnNxTjd1fnPWVErqy+zM
   A==;
X-CSE-ConnectionGUID: VHI5FNy4R4+8UY1XJzWy1Q==
X-CSE-MsgGUID: 1ymzMJioQKiOcs9rmyBihg==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="53215158"
X-IronPort-AV: E=Sophos;i="6.16,270,1744095600"; 
   d="scan'208";a="53215158"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2025 06:00:54 -0700
X-CSE-ConnectionGUID: hf8G9/jFRSCfVPp1wMkX0g==
X-CSE-MsgGUID: oU6oojOAR/Wlpq5meRaIhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,270,1744095600"; 
   d="scan'208";a="157347865"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa004.jf.intel.com with ESMTP; 27 Jun 2025 06:00:50 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 34B536A; Fri, 27 Jun 2025 16:00:49 +0300 (EEST)
Date: Fri, 27 Jun 2025 16:00:49 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, dave.hansen@linux.intel.com, 
	rick.p.edgecombe@intel.com, isaku.yamahata@intel.com, kai.huang@intel.com, 
	yan.y.zhao@intel.com, chao.gao@intel.com, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, kvm@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 04/12] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Message-ID: <scebxrgqi7dgnyv6kjjpbcpijl4juita4lnq76jpw47rs5q2mc@xnbyphvk6vhv>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <20250609191340.2051741-5-kirill.shutemov@linux.intel.com>
 <fd9ebb1c-8a5a-44c5-869b-810bb5e7436c@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd9ebb1c-8a5a-44c5-869b-810bb5e7436c@intel.com>

On Wed, Jun 25, 2025 at 01:02:38PM -0700, Dave Hansen wrote:
> On 6/9/25 12:13, Kirill A. Shutemov wrote:
> >  arch/x86/include/asm/tdx.h       |   3 +
> >  arch/x86/include/asm/tdx_errno.h |   6 +
> >  arch/x86/virt/vmx/tdx/tdx.c      | 205 +++++++++++++++++++++++++++++++
> >  arch/x86/virt/vmx/tdx/tdx.h      |   2 +
> >  4 files changed, 216 insertions(+)
> 
> Please go through this whole series and add appropriate comments and
> explanations.
> 
> There are 4 lines of comments in the 216 lines of new code.

Will do.

> I'll give some examples:
> 
> > +static int tdx_nr_pamt_pages(void)
> 
> Despite the naming this function does not return the number of TDX
> PAMT pages. It returns the number of pages needed for each *dynamic*
> PAMT granule.

tdx_nr_dpamt_pages_per_2m()? This gets ugly.

> The naming is not consistent with something used only for dynamic PAMT
> support. This kind of comment would help, but is not a replacement for
> good naming:
> 
> /*
>  * How many pages are needed for the TDX
>  * dynamic page metadata for a 2M region?
>  */
> 
> Oh, and what the heck is with the tdx_supports_dynamic_pamt() check?
> Isn't it illegal to call these functions without dynamic PAMT in
> place? Wouldn't the TDH_PHYMEM_PAMT_ADD blow up if you hand it 0's
> in args.rdx?

Returning zero for !tdx_supports_dynamic_pamt() helps to avoid branches in
mmu_topup_memory_caches(). This way we pre-allocate zero pages in PAMPT
page cache.

> > +static int tdx_nr_pamt_pages(void)
> > +{
> > +	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
> > +		return 0;
> > +
> > +	return tdx_sysinfo.tdmr.pamt_4k_entry_size * PTRS_PER_PTE / PAGE_SIZE;
> > +}
> > +
> > +static u64 tdh_phymem_pamt_add(unsigned long hpa,
> > +			       struct list_head *pamt_pages)
> > +{
> > +	struct tdx_module_args args = {
> > +		.rcx = hpa,
> > +	};
> > +	struct page *page;
> > +	u64 *p;
> > +
> > +	WARN_ON_ONCE(!IS_ALIGNED(hpa & PAGE_MASK, PMD_SIZE));
> > +
> > +	p = &args.rdx;
> > +	list_for_each_entry(page, pamt_pages, lru) {
> > +		*p = page_to_phys(page);
> > +		p++;
> > +	}
> 
> This is sheer voodoo. Voodoo on its own is OK. But uncommented voodoo
> is not.
> 
> Imagine what would happen if, for instance, someone got confused and did:
> 
> 	tdx_alloc_pamt_pages(&pamd_pages);
> 	tdx_alloc_pamt_pages(&pamd_pages);
> 	tdx_alloc_pamt_pages(&pamd_pages);

I think tdx_alloc_pamt_pages() has to flag non-empty pamt_pages list.

> It would *work* because the allocation function would just merrily
> shove lots of pages on the list. But when it's consumed you'd run off
> the end of the data structure in this function far, far away from the
> bug site.
> 
> The least you can do here is comment what's going on. Because treating
> a structure like an array is obtuse at best.
> 
> Even better would be to have a check to ensure that the pointer magic
> doesn't run off the end of the struct:
> 
> 	if (p - &args.rcx >= sizeof(args)/sizeof(u64)) {
> 		WARN_ON_ONCE(1);
> 		break;
> 	}
> 
> or some other pointer voodoo.

Will do.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

