Return-Path: <kvm+bounces-64474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 57FA3C83E54
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 09:10:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C410434911D
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 08:10:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 012092D8387;
	Tue, 25 Nov 2025 08:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ED1jUKaM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212C42D5C67;
	Tue, 25 Nov 2025 08:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764058203; cv=none; b=B1gSyZEog5YHLYzG+3rvksjhhtg31cDECYnJLEkEeaW/vDuc3vncHnOmp05t6477CRnTlS768+lPYsb6ku5+PJhvXWd4gzOPyn1Los3Xk9Zk1gcbWwMcOyo4/FbTOZ1HyNLiO50XONcI8pk/m8c4hR2Q4lJDe9loDnoezLPRl6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764058203; c=relaxed/simple;
	bh=hwpDaKWSDHJ2P36LukNL+0xtVFpRjTz2H9WP7hWrNvk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hXV/QHwBd4GZunjJN8mjN6APs+XBVXvnZQ69x7VU51o6UvOd8ss2H3EgfkVIBs4HrZpTr+8WenqAQH6yP8SfmVqoEkR0PS7/8IeD7E61528S2Oxr1vPQTSeaT5UoVGnOyf8heSViSRZauc3tTJAuqFTuZRfM0V7ZQimb+ImMsLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ED1jUKaM; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764058201; x=1795594201;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hwpDaKWSDHJ2P36LukNL+0xtVFpRjTz2H9WP7hWrNvk=;
  b=ED1jUKaMDu9GD3iAILS/U8oNLxZt5+IrpKCnKRvsuDEy30eVHVHMjIto
   wH+3TJ9DYzcxIx5KDFOVJKjIJbrBB6zI8U5bMCSr1MnqlRVZYRx8APDQB
   wm6kU/FEPr7TMmmBasKvpRiQ3+7ijPFLpHSf1kjeum7O8wbGcmMVeG9si
   SUGUAWcNl3pGS8kPeuBe3PQQYh7p2sAdfBwcjNrD1ZT7vyj6O92Kd5NNB
   1UYLMpXvNgT8HNggZCc0Ay4p6RDpNdHsiMOVkKPyGnNN/BMhXGIHl9sWy
   +8D4AqkQ50dyx3pkW+R4B/wbqa5AS9XOVD0NCr5SjqttZJrDKFEtYTmjb
   Q==;
X-CSE-ConnectionGUID: qUUXqi1lQJqnEHVd2LYu8A==
X-CSE-MsgGUID: 4BaBUyq3S/evqmhTNDk56A==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="66024293"
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="66024293"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 00:10:01 -0800
X-CSE-ConnectionGUID: f1yzQwdhQkqM3HQS9JkInw==
X-CSE-MsgGUID: sO+iD+y6R62C1FCxq50Rgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="192571594"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 00:09:56 -0800
Message-ID: <12144256-b71a-4331-8309-2e805dc120d1@linux.intel.com>
Date: Tue, 25 Nov 2025 16:09:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: bp@alien8.de, chao.gao@intel.com, dave.hansen@intel.com,
 isaku.yamahata@intel.com, kai.huang@intel.com, kas@kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
 seanjc@google.com, tglx@linutronix.de, vannapurve@google.com,
 x86@kernel.org, yan.y.zhao@intel.com, xiaoyao.li@intel.com,
 binbin.wu@intel.com
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-8-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251121005125.417831-8-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/21/2025 8:51 AM, Rick Edgecombe wrote:
[...]
>   
> +/* Number PAMT pages to be provided to TDX module per 2M region of PA */
           ^                                             ^
           of                                           2MB
> +static int tdx_dpamt_entry_pages(void)
> +{
> +	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
> +		return 0;
> +
> +	return tdx_sysinfo.tdmr.pamt_4k_entry_size * PTRS_PER_PTE / PAGE_SIZE;
> +}
> +
> +/*
> + * The TDX spec treats the registers like an array, as they are ordered
> + * in the struct. The array size is limited by the number or registers,
> + * so define the max size it could be for worst case allocations and sanity
> + * checking.
> + */
> +#define MAX_TDX_ARG_SIZE(reg) (sizeof(struct tdx_module_args) - \
> +			       offsetof(struct tdx_module_args, reg))

This should be the maximum number of registers could be used to pass the
addresses of the pages (or other information), it needs to be divided by sizeof(u64).

Also, "SIZE" in the name could be confusing.

> +#define TDX_ARG_INDEX(reg) (offsetof(struct tdx_module_args, reg) / \
> +			    sizeof(u64))
> +
> +/*
> + * Treat struct the registers like an array that starts at RDX, per
> + * TDX spec. Do some sanitychecks, and return an indexable type.
sanitychecks -> sanity checks

> + */
[...]
> +/* Serializes adding/removing PAMT memory */
> +static DEFINE_SPINLOCK(pamt_lock);
> +
> +/* Bump PAMT refcount for the given page and allocate PAMT memory if needed */
> +int tdx_pamt_get(struct page *page)
> +{
> +	u64 pamt_pa_array[MAX_TDX_ARG_SIZE(rdx)];
> +	atomic_t *pamt_refcount;
> +	u64 tdx_status;
> +	int ret;
> +
> +	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
> +		return 0;
> +
> +	ret = alloc_pamt_array(pamt_pa_array);
> +	if (ret)
> +		goto out_free;
> +
> +	pamt_refcount = tdx_find_pamt_refcount(page_to_pfn(page));
> +
> +	scoped_guard(spinlock, &pamt_lock) {
> +		/*
> +		 * If the pamt page is already added (i.e. refcount >= 1),
> +		 * then just increment the refcount.
> +		 */
> +		if (atomic_read(pamt_refcount)) {
> +			atomic_inc(pamt_refcount);

So far, all atomic operations are inside the spinlock.
May be better to add some info in the change log that atomic is needed due to
the optimization in the later patch?

> +			goto out_free;
> +		}
> +
> +		/* Try to add the pamt page and take the refcount 0->1. */
> +
> +		tdx_status = tdh_phymem_pamt_add(page, pamt_pa_array);
> +		if (!IS_TDX_SUCCESS(tdx_status)) {
> +			pr_err("TDH_PHYMEM_PAMT_ADD failed: %#llx\n", tdx_status);

Can use pr_tdx_error().

Aslo, so for in this patch, when this SEAMCALL failed, does it indicate a bug?

> +			goto out_free;
> +		}
> +
> +		atomic_inc(pamt_refcount);
> +	}
> +
> +	return ret;

Maybe just return 0 here since all error paths must be directed to out_free.

> +out_free:
> +	/*
> +	 * pamt_pa_array is populated or zeroed up to tdx_dpamt_entry_pages()
> +	 * above. free_pamt_array() can handle either case.
> +	 */
> +	free_pamt_array(pamt_pa_array);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(tdx_pamt_get);
> +
>
[...]

