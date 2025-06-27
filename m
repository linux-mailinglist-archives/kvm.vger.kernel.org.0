Return-Path: <kvm+bounces-50999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 88A5EAEB96A
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 16:03:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0BFBB1C460A9
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 14:03:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C4122DAFD1;
	Fri, 27 Jun 2025 14:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TMeGpZ5d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9A7294A15;
	Fri, 27 Jun 2025 14:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751032996; cv=none; b=MphCfnhuTTFgbPJHrBA8Wruc8HvloH+20OuDFjvHePm6lQ2gQv7dEQRMpEUP9+12WV2ZnXPUNbAi9P5K0Dmjer5bK7iq43uje2oX/24ZX1c1Oss33DNn2Sr2b3mfvpn/bwCVnrlw/2LBxkHDNL0ECsaMkxs26QuvrAx5ZzGRNpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751032996; c=relaxed/simple;
	bh=Lg+DHUMrbZqxxeR7eqQH/bVmM1+NysYnrKeCoVBx4VA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hh+TD2LIClpEzoNwwHTwQESbv3OWYnjW/OY4qLzo+dpmcJVlb6Lc6fzUXbhku8Z4WBaZBRnvitJwvmnyrCSFkkV6CSzLxSnFrkNwNjAILHvcfoZp9SDMWtFVsGkucYg380WU87m1EUOlcMn+3cBJP3l/pCyvafHB/0s8l/nkLqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TMeGpZ5d; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751032994; x=1782568994;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Lg+DHUMrbZqxxeR7eqQH/bVmM1+NysYnrKeCoVBx4VA=;
  b=TMeGpZ5dicF8Tgmj0pOz4x6m+hpppJlRbeKQF9f7l2q3rDeiF9w7BZt6
   AcnMOcyHlZrGFf5tlajR/GYbSyU1l8k337ocWsNs6PhZZx+Y+/wia2EA7
   69+2G7LOgXvGRnmz5IU/aCBwFl9uzBRDYMArKnN+NSbWoYMNPCYWtywT8
   uPJvZHo//zq/N7C2FtYW4iTifn2nq1bS+LtFElaPpFzhmdDXTRNcYjEE6
   RqLTDz803Yt3fZxT5Kt5eUnyR4VNopVQuEJ7aJe8DHCV7QGJ4Li3ZlzXh
   Q5HAsVE4uvObsswv8pobnQDbOoYI9LB7F1XemQXOgTdK1rS2om8H8as8w
   Q==;
X-CSE-ConnectionGUID: y8IYFF9CRpaZVvTbMMLAsg==
X-CSE-MsgGUID: UYtfnenKQSmLfwOUivAjSw==
X-IronPort-AV: E=McAfee;i="6800,10657,11477"; a="70916712"
X-IronPort-AV: E=Sophos;i="6.16,270,1744095600"; 
   d="scan'208";a="70916712"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2025 07:03:13 -0700
X-CSE-ConnectionGUID: mrk7EwNkSJ6z8qiTWCv4yw==
X-CSE-MsgGUID: PK6FeGPkSY+LahJw6un/pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,270,1744095600"; 
   d="scan'208";a="152336360"
Received: from spandruv-desk1.amr.corp.intel.com (HELO [10.125.109.66]) ([10.125.109.66])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2025 07:03:14 -0700
Message-ID: <bb0077bc-9dd2-46a6-a130-a2cea5e5628e@intel.com>
Date: Fri, 27 Jun 2025 07:03:12 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2 03/12] x86/virt/tdx: Allocate reference counters for
 PAMT memory
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, dave.hansen@linux.intel.com,
 rick.p.edgecombe@intel.com, isaku.yamahata@intel.com, kai.huang@intel.com,
 yan.y.zhao@intel.com, chao.gao@intel.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, kvm@vger.kernel.org, x86@kernel.org,
 linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <20250609191340.2051741-4-kirill.shutemov@linux.intel.com>
 <fb5addcb-1cfc-45be-978c-e7cee4126b38@intel.com>
 <pihazgqmsx4ltuvi2imgwsgvjsg2jsnxjnrdpxblwe2vc24opf@glsj2t3xosvb>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <pihazgqmsx4ltuvi2imgwsgvjsg2jsnxjnrdpxblwe2vc24opf@glsj2t3xosvb>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/27/25 04:27, Kirill A. Shutemov wrote:
> On Wed, Jun 25, 2025 at 12:26:09PM -0700, Dave Hansen wrote:
>>> +static atomic_t *tdx_get_pamt_refcount(unsigned long hpa)
>>> +{
>>> +	return &pamt_refcounts[hpa / PMD_SIZE];
>>> +}
>>
>> "get refcount" usually means "get a reference". This is looking up the
>> location of the refcount.
>>
>> I think this needs a better name.
> 
> tdx_get_pamt_ref_ptr()?

How about:

	tdx_find_pamt_refcount()

>>> +	unsigned long vaddr;
>>> +	pte_t entry;
>>> +
>>> +	if (!pte_none(ptep_get(pte)))
>>> +		return 0;
>>
>> This ^ is an optimization, right? Could it be comment appropriately, please?
> 
> Not optimization.
> 
> Calls of apply_to_page_range() can overlap by one page due to
> round_up()/round_down() in alloc_pamt_refcount(). We don't need to
> populate these pages again if they are already populated.
> 
> Will add a comment.

But don't you check it again under the lock?

>>> +	vaddr = __get_free_page(GFP_KERNEL | __GFP_ZERO);
>>> +	if (!vaddr)
>>> +		return -ENOMEM;
>>> +
>>> +	entry = pfn_pte(PFN_DOWN(__pa(vaddr)), PAGE_KERNEL);
>>> +
>>> +	spin_lock(&init_mm.page_table_lock);
>>> +	if (pte_none(ptep_get(pte)))

Right there ^

>>> +		set_pte_at(&init_mm, addr, pte, entry);
>>> +	else
>>> +		free_page(vaddr);
>>> +	spin_unlock(&init_mm.page_table_lock);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int pamt_refcount_depopulate(pte_t *pte, unsigned long addr,
>>> +				    void *data)
>>> +{
>>> +	unsigned long vaddr;
>>> +
>>> +	vaddr = (unsigned long)__va(PFN_PHYS(pte_pfn(ptep_get(pte))));
>>
>> Gah, we really need a kpte_to_vaddr() helper here. This is really ugly.
>> How many of these are in the tree?
> 
> I only found such chain in KASAN code.
> 
> What about this?
> 
>       pte_t entry = ptep_get(pte);
>       struct page *page = pte_page(entry);
> 
> and use __free_page(page) instead free_page(vaddr)?
> 
> The similar thing can be don on allocation side.

That does look better.


