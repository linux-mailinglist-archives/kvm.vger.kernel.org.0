Return-Path: <kvm+bounces-50984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 77FD0AEB68B
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 13:35:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7CB09189A9B1
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 11:36:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9D822BCF5D;
	Fri, 27 Jun 2025 11:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eiEIn019"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06AF293C67;
	Fri, 27 Jun 2025 11:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751024137; cv=none; b=q8I22aVhRyUdjZ/TwUGPh8wkzZ1ntO3Tw/Lpa23Oj9OtrjKuYkMJVBNrzdAWzt61Tlfuf9mOGxzcXtB5+Igt5CHZbMfp6m/qsEuWvVXUY6Nj2zze3zYVGaNAymwPjXuq/AqbCJmMktop3WWfIHz46VqfJnEEcM1MSi5PN++OSXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751024137; c=relaxed/simple;
	bh=eXvK7190AFJgHbf6OzHmasFyFsoUL6SVhDPs+jciPZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XnIT8Y+tm2hH3wlA5UAwww+HjH+p4t5g+22Wt6t+ciBIunhmvMVdF6EE0fZ58/XskjRiNNbjwbodDpYF6/97RX00GSULf39Tl4cLIqHf84244F0Nlokz9ui1tCi99AMESo5YwfOBDTqsaeJzpDs9pmO6a+MZe/o2u9imGsS4284=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eiEIn019; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751024135; x=1782560135;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=eXvK7190AFJgHbf6OzHmasFyFsoUL6SVhDPs+jciPZg=;
  b=eiEIn01967K6AffU/nKAEsOIaedithXWaIgdsT1sGzAal6054SQYPcbx
   d4vezMcq6sIO2hMQqAK2o/+ac88GFCuXuHNwdh7SDduGaPnJEFjvAapdE
   fLpIXZcAP1rGUpDMkHHYAo1eVMi+e07io3GsznarkHfppBmslYgvTUB6R
   1SsguddpkBg1DfrtZsaxdRt3YEW7MhTULqdC3XUAIxDh8tuyEHo2lKhhH
   XGAqmaFggYBlZsPZ422E7nB3qOil7Gf/ZwkBH4O0X0VHeVWcy44fOX5ac
   8oYovPhqrmlfoaSK7vqEiFEtSbVYv914ZtBR80RDks6hTZfD/apxtIVj8
   A==;
X-CSE-ConnectionGUID: I8t/gfRdRDe+A9XUnlEedg==
X-CSE-MsgGUID: ok/V4+y0Rxe8F0ik14rsJQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="64393550"
X-IronPort-AV: E=Sophos;i="6.16,270,1744095600"; 
   d="scan'208";a="64393550"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2025 04:35:35 -0700
X-CSE-ConnectionGUID: KYNGm1WHQTqPlkR0ucTwBA==
X-CSE-MsgGUID: jaMngmLTSFaOD7MhI+c4jQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,270,1744095600"; 
   d="scan'208";a="152526268"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa009.jf.intel.com with ESMTP; 27 Jun 2025 04:35:31 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 34F686A; Fri, 27 Jun 2025 14:35:30 +0300 (EEST)
Date: Fri, 27 Jun 2025 14:35:30 +0300
From: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"seanjc@google.com" <seanjc@google.com>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 03/12] x86/virt/tdx: Allocate reference counters for
 PAMT memory
Message-ID: <c6i6lttkkeupbyfwy42byin7ccxh6rwznvgwsyjmvzeb5rbblv@ge3agfvfyn4e>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <20250609191340.2051741-4-kirill.shutemov@linux.intel.com>
 <104abe744282dba34456d467e4730058ec2e7d99.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <104abe744282dba34456d467e4730058ec2e7d99.camel@intel.com>

On Thu, Jun 26, 2025 at 12:53:29AM +0000, Huang, Kai wrote:
> 
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
> 		^
> 		build_tdx_memlist()

Ack.

> 
> > +	 */
> > +	area = get_vm_area(size, VM_IOREMAP);
> 
> I am not sure why VM_IOREMAP is used? 

It follows vmap_pfn() pattern as usage is similar.

It seems the flag allows vread_iter() to work correct on sparse mappings.

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
> > +	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
> > +		return;
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
> >  /*
> >   * Add a memory region as a TDX memory block.  The caller must make sure
> >   * all memory regions are added in address ascending order and don't
> > @@ -248,6 +347,10 @@ static int build_tdx_memlist(struct list_head *tmb_list)
> >  		ret = add_tdx_memblock(tmb_list, start_pfn, end_pfn, nid);
> >  		if (ret)
> >  			goto err;
> > +
> > +		ret = alloc_pamt_refcount(start_pfn, end_pfn);
> > +		if (ret)
> > +			goto err;
> 
> So this would goto the error path, which only calls free_tdx_memlist(),
> which frees all existing TDX memory blocks that have already created.
> 
> Logically, it would be great to also free PAMT refcount pages too, but they
> all can be freed at free_pamt_metadata() eventually, so it's OK.
> 
> But I think it would still be helpful to put a comment before
> free_tdx_memlist() in the error path to call out.  Something like:
> 
> err:
> 	/*
> 	 * This only frees all TDX memory blocks that have been created.
> 	 * All PAMT refcount pages will be freed when init_tdx_module() 
> 	 * calls free_pamt_metadata() eventually.
> 	 */
> 	free_tdx_memlist(tmb_list);
> 	return ret;

Okay.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

