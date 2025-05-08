Return-Path: <kvm+bounces-45850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A201AAAFACF
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:04:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A1BCA1628C6
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:04:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CDC522A80C;
	Thu,  8 May 2025 13:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IYuR7DDx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE3F1F5F6;
	Thu,  8 May 2025 13:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746709432; cv=none; b=Wo7VK7XV+Vlc6H0qrCd/h3hCugbZSNFmcsTwgG9xOidEXcyimwg+qBmxWKh86knuMXB9unlbEGj0HTilE5dDPDJRjV49VaFOgFrWb0TFRzWfFpR6+89ohMw3yjqZacDGevf9f6V5lgv9uyhu/VDU5m3FNIuhSfeFGgss6jInsiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746709432; c=relaxed/simple;
	bh=mNlDzPJ3yL3xQYv9gZ1G3DIrhkhtYmeejPE9W1ui4hc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JrUICTSSpHh/JMNJC29xE5QFx41MBPzz1si6dwIpCMMH1JfTAtEbFgGvaPxmXVUco4PZHUU1rYfpQXHIo6E+AyYa0ny0ORAPPJ6vui5OoCrAtZSW7Eu0BZDudG+1X4FNjhyuhqqlgysww4p8HC1MCKsEoSu6lw3AlgjOuFGaJa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IYuR7DDx; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746709431; x=1778245431;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mNlDzPJ3yL3xQYv9gZ1G3DIrhkhtYmeejPE9W1ui4hc=;
  b=IYuR7DDxsD22oiWjNuJEWeSqXXCWBBPY73m3VTe9umODHrJGZdAJ1ATw
   0mfU+rZKJMhuoe6Ng7iQi77D+OMbgMA3YeX2UBrJ2/gCXg3kr0OYVIaIO
   3AyQcKruI2WvsxXFib1AB5aVS2ZIRRK9wA0lbHAKeHgWYt2yExI7jGACl
   NuoIPpXC0cuc2l5zKaGTlCI9lzbDfI2+7RH6q4eUFuJVIoq4LMNxLgCdo
   Dhea8Ka4jJIJdlq3rkYl4jwZM5P3MnIXhUicpB9WL8zMFDBYfC49FfjLA
   D7og7Zbj2YisDJ6G5wSOYQ+dneA8ro842nD2YCuBjt6FUxhavHf6IASdW
   g==;
X-CSE-ConnectionGUID: CyF3W5qjTYyRSwdprUTU9A==
X-CSE-MsgGUID: 5dxt7QvoSh6oTFhZ2bmBpw==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="48197148"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="48197148"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 06:03:50 -0700
X-CSE-ConnectionGUID: fsaLDxAhS3mkpT7mHdbtNA==
X-CSE-MsgGUID: 7CTJNPGYRb6FVp6zoPECwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="136685601"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa008.fm.intel.com with ESMTP; 08 May 2025 06:03:47 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id D8D3719D; Thu, 08 May 2025 16:03:45 +0300 (EEST)
Date: Thu, 8 May 2025 16:03:45 +0300
From: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"seanjc@google.com" <seanjc@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH 02/12] x86/virt/tdx: Allocate reference counters for
 PAMT memory
Message-ID: <zyqk4zyxpcde7sjzu5xgo7yyntk3w6opoqdspvff4tyud4p6qn@wcnzwwq7d3b6>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <20250502130828.4071412-3-kirill.shutemov@linux.intel.com>
 <1e939e994d4f1f36d0a15a18dd66c5fe9864f2e2.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e939e994d4f1f36d0a15a18dd66c5fe9864f2e2.camel@intel.com>

On Mon, May 05, 2025 at 11:05:12AM +0000, Huang, Kai wrote:
> 
> > +static atomic_t *pamt_refcounts;
> > +
> >  static enum tdx_module_status_t tdx_module_status;
> >  static DEFINE_MUTEX(tdx_module_lock);
> >  
> > @@ -1035,9 +1038,108 @@ static int config_global_keyid(void)
> >  	return ret;
> >  }
> >  
> > +atomic_t *tdx_get_pamt_refcount(unsigned long hpa)
> > +{
> > +	return &pamt_refcounts[hpa / PMD_SIZE];
> > +}
> > +EXPORT_SYMBOL_GPL(tdx_get_pamt_refcount);
> 
> It's not quite clear why this function needs to be exported in this patch.  IMO
> it's better to move the export to the patch which actually needs it.
> 
> Looking at patch 5, tdx_pamt_get()/put() use it, and they are in KVM code.  But
> I think we should just put them here in this file.  tdx_alloc_page() and
> tdx_free_page() should be in this file too.
> 
> And instead of exporting tdx_get_pamt_refcount(), the TDX core code here can
> export tdx_alloc_page() and tdx_free_page(), providing two high level helpers to
> allow the TDX users (e.g., KVM) to allocate/free TDX private pages.  How PAMT
> pages are allocated is then hidden in the core TDX code.

We would still need tdx_get_pamt_refcount() to handle case when we need to
bump refcount for page allocated elsewhere.

> > +
> > +static int pamt_refcount_populate(pte_t *pte, unsigned long addr, void *data)
> > +{
> > +	unsigned long vaddr;
> > +	pte_t entry;
> > +
> > +	if (!pte_none(ptep_get(pte)))
> > +		return 0;
> > +
> > +	vaddr = __get_free_page(GFP_KERNEL | __GFP_ZERO);
> > +	if (!vaddr)
> > +		return -ENOMEM;
> > +
> > +	entry = pfn_pte(PFN_DOWN(__pa(vaddr)), PAGE_KERNEL);
> > +
> > +	spin_lock(&init_mm.page_table_lock);
> > +	if (pte_none(ptep_get(pte)))
> > +		set_pte_at(&init_mm, addr, pte, entry);
> > +	else
> > +		free_page(vaddr);
> > +	spin_unlock(&init_mm.page_table_lock);
> > +
> > +	return 0;
> > +}
> > +
> > +static int pamt_refcount_depopulate(pte_t *pte, unsigned long addr,
> > +				    void *data)
> > +{
> > +	unsigned long vaddr;
> > +
> > +	vaddr = (unsigned long)__va(PFN_PHYS(pte_pfn(ptep_get(pte))));
> > +
> > +	spin_lock(&init_mm.page_table_lock);
> > +	if (!pte_none(ptep_get(pte))) {
> > +		pte_clear(&init_mm, addr, pte);
> > +		free_page(vaddr);
> > +	}
> > +	spin_unlock(&init_mm.page_table_lock);
> > +
> > +	return 0;
> > +}
> > +
> > +static int alloc_tdmr_pamt_refcount(struct tdmr_info *tdmr)
> > +{
> > +	unsigned long start, end;
> > +
> > +	start = (unsigned long)tdx_get_pamt_refcount(tdmr->base);
> > +	end = (unsigned long)tdx_get_pamt_refcount(tdmr->base + tdmr->size);
> > +	start = round_down(start, PAGE_SIZE);
> > +	end = round_up(end, PAGE_SIZE);
> > +
> > +	return apply_to_page_range(&init_mm, start, end - start,
> > +				   pamt_refcount_populate, NULL);
> > +}
> 
> IIUC, populating refcount based on TDMR will slightly waste memory.  The reason
> is IIUC we don't need to populate the refcount for a 2M range if the range is
> completely marked as reserved in TDMR, because it's not possible for the kernel
> to use such range for TDX.
> 
> Populating based on the list of TDX memory blocks should be better.  In
> practice, the difference should be unnoticeable, but conceptually, using TDX
> memory blocks is better.

Okay, I will look into this after dealing with huge pages.

> > +
> > +static int init_pamt_metadata(void)
> > +{
> > +	size_t size = max_pfn / PTRS_PER_PTE * sizeof(*pamt_refcounts);
> > +	struct vm_struct *area;
> > +
> > +	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
> > +		return 0;
> > +
> > +	/*
> > +	 * Reserve vmalloc range for PAMT reference counters. It covers all
> > +	 * physical address space up to max_pfn. It is going to be populated
> > +	 * from init_tdmr() only for present memory that available for TDX use.
> > +	 */
> > +	area = get_vm_area(size, VM_IOREMAP);
> > +	if (!area)
> > +		return -ENOMEM;
> > +
> > +	pamt_refcounts = area->addr;
> > +	return 0;
> > +}
> > +
> > +static void free_pamt_metadata(void)
> > +{
> > +	size_t size = max_pfn / PTRS_PER_PTE * sizeof(*pamt_refcounts);
> > +
> > +	size = round_up(size, PAGE_SIZE);
> > +	apply_to_existing_page_range(&init_mm,
> > +				     (unsigned long)pamt_refcounts,
> > +				     size, pamt_refcount_depopulate,
> > +				     NULL);
> > +	vfree(pamt_refcounts);
> > +	pamt_refcounts = NULL;
> > +}
> > +
> >  static int init_tdmr(struct tdmr_info *tdmr)
> >  {
> >  	u64 next;
> > +	int ret;
> > +
> > +	ret = alloc_tdmr_pamt_refcount(tdmr);
> > +	if (ret)
> > +		return ret;
> >  
> >  	/*
> >  	 * Initializing a TDMR can be time consuming.  To avoid long
> > @@ -1048,7 +1150,6 @@ static int init_tdmr(struct tdmr_info *tdmr)
> >  		struct tdx_module_args args = {
> >  			.rcx = tdmr->base,
> >  		};
> > -		int ret;
> >  
> >  		ret = seamcall_prerr_ret(TDH_SYS_TDMR_INIT, &args);
> >  		if (ret)
> > @@ -1134,10 +1235,15 @@ static int init_tdx_module(void)
> >  	if (ret)
> >  		goto err_reset_pamts;
> >  
> > +	/* Reserve vmalloc range for PAMT reference counters */
> > +	ret = init_pamt_metadata();
> > +	if (ret)
> > +		goto err_reset_pamts;
> > +
> >  	/* Initialize TDMRs to complete the TDX module initialization */
> >  	ret = init_tdmrs(&tdx_tdmr_list);
> >  	if (ret)
> > -		goto err_reset_pamts;
> > +		goto err_free_pamt_metadata;
> >  
> >  	pr_info("%lu KB allocated for PAMT\n", tdmrs_count_pamt_kb(&tdx_tdmr_list));
> >  
> > @@ -1149,6 +1255,9 @@ static int init_tdx_module(void)
> >  	put_online_mems();
> >  	return ret;
> >  
> > +err_free_pamt_metadata:
> > +	free_pamt_metadata();
> > +
> >  err_reset_pamts:
> >  	/*
> >  	 * Part of PAMTs may already have been initialized by the
> 

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

