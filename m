Return-Path: <kvm+bounces-66612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F3FB4CD8CF1
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 11:32:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AAAD13015178
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 10:31:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 486A135F8D0;
	Tue, 23 Dec 2025 10:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L/99JRYW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9124F35FF55;
	Tue, 23 Dec 2025 10:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766485433; cv=none; b=pLCWjacPK6v+MxYVUbTjFsUYiiNxv4RnyygEvNF8/TGqG5374Vo2r9kkH55bK/J7AbMyDo7gXQIk5OHDqpUmkvpvXncaPMVFMUSBe3hOldzKh5u+07ZvA3U1Sy3N1bctFlAb/4T25s87H63oDsvTlntvPT7Pqg6QHn+o5/BgQl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766485433; c=relaxed/simple;
	bh=mL0nVJLKnBfsYHlK46W6g7hGNPIucD7MmzXoRL18dzk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aGWf/dC19ml/3IGoaoJRpjoqjBqxE1OyWGNOIbHn9dWFcm2h6SqRNdxcWBT44u90dpgUJtibKNaqPjqbDQPKdQzOAT8OYCt3KR839dXBywaKrqDo3F2685Kdwrh4vmonwlfHCGmjqyLHq48m+4HOejJPXAmEEE7+LeVgpa800zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L/99JRYW; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766485429; x=1798021429;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mL0nVJLKnBfsYHlK46W6g7hGNPIucD7MmzXoRL18dzk=;
  b=L/99JRYWUFMACDJIvco0dQWpJOJYuXOgDRsufAsmebVnjD6OyL6X96oq
   7FwxoaZw+K7D4QqnSzk+qmmGzixsZkh/IP0BpJG5y5EL6SBXc28R+qOTS
   6uw/lalhXsGD4bFoAmC4NVfVyRoI/8paxp/IeJRGTZEw7c16mcadCnJuC
   32X9QhIVk8voA9GNMzKg/Pet4asLdtwo4+n/qKwD0MBfhw/Jza2ryBP0a
   vl4t2OFNkAf0b7GFIknqBA0Pm7zgPEfKqewUAa6JOfu+6accx+pauHCON
   jJY4A+gh1kAAwx0+CU3KJrXpJg1Rry3AIXvSKIK4A0NXXqFW1sN44eZg6
   w==;
X-CSE-ConnectionGUID: I+9aUGQLQaKa68VUxJ/mqA==
X-CSE-MsgGUID: KujWBhgtRTafSWROtez+ag==
X-IronPort-AV: E=McAfee;i="6800,10657,11650"; a="79053832"
X-IronPort-AV: E=Sophos;i="6.21,170,1763452800"; 
   d="scan'208";a="79053832"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2025 02:23:48 -0800
X-CSE-ConnectionGUID: eEs1RKnISjmBDiZGAIuFOA==
X-CSE-MsgGUID: MH8z20DBQxuYEwa8lmz6hQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,170,1763452800"; 
   d="scan'208";a="200053729"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa008.fm.intel.com with ESMTP; 23 Dec 2025 02:23:45 -0800
Date: Tue, 23 Dec 2025 18:07:18 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-coco@lists.linux.dev, linux-pci@vger.kernel.org,
	chao.gao@intel.com, dave.jiang@intel.com, baolu.lu@linux.intel.com,
	yilun.xu@intel.com, zhenzhong.duan@intel.com, kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com, dave.hansen@linux.intel.com,
	dan.j.williams@intel.com, kas@kernel.org, x86@kernel.org
Subject: Re: [PATCH v1 06/26] x86/virt/tdx: Add tdx_page_array helpers for
 new TDX Module objects
Message-ID: <aUpp1sQ0k24zfjcD@yilunxu-OptiPlex-7050>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
 <20251117022311.2443900-7-yilun.xu@linux.intel.com>
 <20251219113249.000040b1@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219113249.000040b1@huawei.com>

> > +static bool tdx_page_array_validate_release(struct tdx_page_array *array,
> > +					    unsigned int offset,
> > +					    unsigned int nr_released,
> > +					    u64 released_hpa)
> > +{
> > +	unsigned int nents;
> > +	u64 *entries;
> > +	int i;
> > +
> > +	if (offset >= array->nr_pages)
> > +		return false;
> > +
> > +	nents = umin(array->nr_pages - offset, TDX_PAGE_ARRAY_MAX_NENTS);
> > +
> > +	if (nents != nr_released) {
> > +		pr_err("%s nr_released [%d] doesn't match page array nents [%d]\n",
> > +		       __func__, nr_released, nents);
> > +		return false;
> > +	}
> > +
> > +	/*
> > +	 * Unfortunately TDX has multiple page allocation protocols, check the
> > +	 * "singleton" case required for HPA_ARRAY_T.
> > +	 */
> > +	if (page_to_phys(array->pages[0]) == released_hpa &&
> > +	    array->nr_pages == 1)
> > +		return true;
> > +
> > +	/* Then check the "non-singleton" case */
> > +	if (page_to_phys(array->root) == released_hpa) {
> > +		entries = (u64 *)page_address(array->root);
> 
> page_address() returns a void * so the cast here isn't needed and (to me
> at least) doesn't add value from readability point of view.

These casts disappear during the refactoring from alloc_page() to
kzalloc(PAGE_SIZE, ...) for my v2.

> 
> I haven't checked later patches, but if this code doesn't change to use
> entries outside this scope then,
> 		u64 *entries = page_address(array->root);
> would be nice to restrict the scope and make the type here immediately
> visible.

Yes. Also for int i.

Thanks,
Yilun

> 
> > +		for (i = 0; i < nents; i++) {
> > +			struct page *page = array->pages[offset + i];
> > +			u64 val = page_to_phys(page);
> > +
> > +			if (val != entries[i]) {
> > +				pr_err("%s entry[%d] [0x%llx] doesn't match page hpa [0x%llx]\n",
> > +				       __func__, i, entries[i], val);
> > +				return false;
> > +			}
> > +		}
> > +
> > +		return true;
> > +	}
> > +
> > +	pr_err("%s failed to validate, released_hpa [0x%llx], root page hpa [0x%llx], page0 hpa [%#llx], number pages %u\n",
> > +	       __func__, released_hpa, page_to_phys(array->root),
> > +	       page_to_phys(array->pages[0]), array->nr_pages);
> > +
> > +	return false;
> > +}
> 
> 

