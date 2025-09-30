Return-Path: <kvm+bounces-59170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FB56BADCF6
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 17:25:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7126719457BE
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 15:26:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 993A230597A;
	Tue, 30 Sep 2025 15:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sch1TQlO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A055F2FD1DD;
	Tue, 30 Sep 2025 15:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245945; cv=none; b=m3F36iAA/6z/vawYTyk1VToUmyu+KL/dFZ+ELCqkKMYLT7rIx1Zxk8H/aNBT7sweLd95+W3D4Ngl1rZdzwhCOJngZ9X2Dr70KwL5u7/bCwspfqQEa+5RpKW7KjXfpXHCVBtqmO3aSU+qK3tPpqWYRUgAZ8IiIticqBTZ7pr5OAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245945; c=relaxed/simple;
	bh=HBwQytcSwykONCNxeqm1o0gfZIKOYI96xjSq1aGiaLA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QoF+3ORe+g37UP4gztToVFieZ/1Nbs0JzoXQzqmrI+zl6YzkvwVwGJmugLA93gby9Ghz/X/raVrAPylIDf0AAd7aeoEk7PUN3ww7MvfC9f0sI6OFQwSz1gVN7IdRAWsTcwsHuKfqYFWst7blZc5lDnXtH2IMJISALXOykBseR/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Sch1TQlO; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759245942; x=1790781942;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HBwQytcSwykONCNxeqm1o0gfZIKOYI96xjSq1aGiaLA=;
  b=Sch1TQlOJGES0fQrAIEKwNy7ncyV6ZP2D+jwvUJ2NYzCaVvsFSFNja9N
   rcnU0Ax8dkvsnZelIgSKJSV1tIsE5icUE2vjsNAX4Tl2QwIAisx9xpudA
   TevEVEp5SDqp0pWa/YiQXUps44udB7+u+cRb/yjMM6rreQ/hQRRdY3HZz
   mPIcTst4uEbcQs6Bdn5VeeWK5oEfujiAD0rGVVlGttAsI4LEzAksKP74f
   mvIaTdfP19goGr/YAKPw+uCoACWq/wWUDsHNgbLv9qAmc5Nl870AkXhKp
   5znVLAoKqZhypwMjXGRITWA2dFqWeli+3zyL+XoztSQi4cgBHLWOILF92
   Q==;
X-CSE-ConnectionGUID: fNilZaJYSeyQRb6AABDCIw==
X-CSE-MsgGUID: gfZBVS8QSAWGCD7KvpK87Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="61615114"
X-IronPort-AV: E=Sophos;i="6.18,304,1751266800"; 
   d="scan'208";a="61615114"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 08:25:42 -0700
X-CSE-ConnectionGUID: xPIrSchvQRGKByruv3nG5w==
X-CSE-MsgGUID: l3OvyQB4RciR0OIF1sVnkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,304,1751266800"; 
   d="scan'208";a="177823755"
Received: from tslove-mobl4.amr.corp.intel.com (HELO [10.125.109.151]) ([10.125.109.151])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 08:25:41 -0700
Message-ID: <355ad607-52ed-42cc-9a48-63aaa49f4c68@intel.com>
Date: Tue, 30 Sep 2025 08:25:40 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, kas@kernel.org,
 bp@alien8.de, chao.gao@intel.com, dave.hansen@linux.intel.com,
 isaku.yamahata@intel.com, kai.huang@intel.com, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, mingo@redhat.com,
 pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de, x86@kernel.org,
 yan.y.zhao@intel.com, vannapurve@google.com
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
 <20250918232224.2202592-8-rick.p.edgecombe@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20250918232224.2202592-8-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/18/25 16:22, Rick Edgecombe wrote:
...
> +/*
> + * The TDX spec treats the registers like an array, as they are ordered
> + * in the struct. The array size is limited by the number or registers,
> + * so define the max size it could be for worst case allocations and sanity
> + * checking.
> + */
> +#define MAX_DPAMT_ARG_SIZE (sizeof(struct tdx_module_args) - \
> +			    offsetof(struct tdx_module_args, rdx))
> +
> +/*
> + * Treat struct the registers like an array that starts at RDX, per
> + * TDX spec. Do some sanitychecks, and return an indexable type.
> + */
> +static u64 *dpamt_args_array_ptr(struct tdx_module_args *args)
> +{
> +	WARN_ON_ONCE(tdx_dpamt_entry_pages() > MAX_DPAMT_ARG_SIZE);
> +
> +	/*
> +	 * FORTIFY_SOUCE could inline this and complain when callers copy
> +	 * across fields, which is exactly what this is supposed to be
> +	 * used for. Obfuscate it.
> +	 */
> +	return (u64 *)((u8 *)args + offsetof(struct tdx_module_args, rdx));
> +}

There are a lot of ways to to all of this jazz to alias an array over
the top of a bunch of named structure fields. My worry about this
approach is that it intentionally tries to hide the underlying type from
the compiler.

It could be done with a bunch of union/struct voodoo like 'struct page':

struct tdx_module_args {
	u64 rcx;
	union {
		struct {
			u64 rdx;
			u64 r8;
			u64 r9;
			...
		};
		u64 array[FOO];
	};
}

Or a separate structure:

struct tdx_module_array_args {
	u64 rcx;
	u64 array[FOO];
};

So that you could do something simpler:

u64 *dpamt_args_array_ptr(struct tdx_module_args *args)
{
	return ((struct tdx_module_array_args *)args)->array;
}

Along with one of these somewhere:

BUILD_BUG_ON(sizeof(struct tdx_module_array_args) !=
	     sizeof(struct tdx_module_array));

I personally find the offsetof() tricks to be harder to follow than
either of those.

> +static int alloc_pamt_array(u64 *pa_array)
> +{
> +	struct page *page;
> +
> +	for (int i = 0; i < tdx_dpamt_entry_pages(); i++) {
> +		page = alloc_page(GFP_KERNEL);
> +		if (!page)
> +			return -ENOMEM;
> +		pa_array[i] = page_to_phys(page);
> +	}
> +
> +	return 0;
> +}
> +
> +static void free_pamt_array(u64 *pa_array)
> +{
> +	for (int i = 0; i < tdx_dpamt_entry_pages(); i++) {
> +		if (!pa_array[i])
> +			break;
> +
> +		reset_tdx_pages(pa_array[i], PAGE_SIZE);

One nit: this reset is unnecessary in the error cases here where the
array never gets handed to the TDX module. Right?

> +		/*
> +		 * It might have come from 'prealloc', but this is an error
> +		 * path. Don't be fancy, just free them. TDH.PHYMEM.PAMT.ADD
> +		 * only modifies RAX, so the encoded array is still in place.
> +		 */
> +		__free_page(phys_to_page(pa_array[i]));
> +	}
> +}
> +
> +/*
> + * Add PAMT memory for the given HPA. Return's negative error code
> + * for kernel side error conditions (-ENOMEM) and 1 for TDX Module
> + * error. In the case of TDX module error, the return code is stored
> + * in tdx_err.
> + */
> +static u64 tdh_phymem_pamt_add(unsigned long hpa, u64 *pamt_pa_array)
> +{
> +	struct tdx_module_args args = {
> +		.rcx = hpa,
> +	};
> +	u64 *args_array = dpamt_args_array_ptr(&args);
> +
> +	WARN_ON_ONCE(!IS_ALIGNED(hpa & PAGE_MASK, PMD_SIZE));
> +
> +	/* Copy PAMT page PA's into the struct per the TDX ABI */
> +	memcpy(args_array, pamt_pa_array,
> +	       tdx_dpamt_entry_pages() * sizeof(*args_array));

This uses 'sizeof(*args_array)'.

> +	return seamcall(TDH_PHYMEM_PAMT_ADD, &args);
> +}
> +
> +/* Remove PAMT memory for the given HPA */
> +static u64 tdh_phymem_pamt_remove(unsigned long hpa, u64 *pamt_pa_array)
> +{
> +	struct tdx_module_args args = {
> +		.rcx = hpa,
> +	};
> +	u64 *args_array = dpamt_args_array_ptr(&args);
> +	u64 ret;
> +
> +	WARN_ON_ONCE(!IS_ALIGNED(hpa & PAGE_MASK, PMD_SIZE));
> +
> +	ret = seamcall_ret(TDH_PHYMEM_PAMT_REMOVE, &args);
> +	if (ret)
> +		return ret;
> +
> +	/* Copy PAMT page PA's out of the struct per the TDX ABI */
> +	memcpy(pamt_pa_array, args_array,
> +	       tdx_dpamt_entry_pages() * sizeof(u64));

While this one is sizeof(u64).

Could we make it consistent, please?


> +/* Serializes adding/removing PAMT memory */
> +static DEFINE_SPINLOCK(pamt_lock);
> +
> +/* Bump PAMT refcount for the given page and allocate PAMT memory if needed */
> +int tdx_pamt_get(struct page *page)
> +{
> +	unsigned long hpa = ALIGN_DOWN(page_to_phys(page), PMD_SIZE);
> +	u64 pamt_pa_array[MAX_DPAMT_ARG_SIZE];
> +	atomic_t *pamt_refcount;
> +	u64 tdx_status;
> +	int ret;
> +
> +	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
> +		return 0;
> +
> +	ret = alloc_pamt_array(pamt_pa_array);
> +	if (ret)
> +		return ret;
> +
> +	pamt_refcount = tdx_find_pamt_refcount(hpa);
> +
> +	scoped_guard(spinlock, &pamt_lock) {
> +		if (atomic_read(pamt_refcount))
> +			goto out_free;
> +
> +		tdx_status = tdh_phymem_pamt_add(hpa | TDX_PS_2M, pamt_pa_array);
> +
> +		if (IS_TDX_SUCCESS(tdx_status)) {
> +			atomic_inc(pamt_refcount);
> +		} else {
> +			pr_err("TDH_PHYMEM_PAMT_ADD failed: %#llx\n", tdx_status);
> +			goto out_free;
> +		}

I'm feeling like the states here are under-commented.

	1. PAMT already allocated
	2. 'pamt_pa_array' consumed, bump the refcount
	3. TDH_PHYMEM_PAMT_ADD failed

#1 and #3 need to free the allocation.

Could we add comments to that effect, please?

> +	}

This might get easier to read if the pr_err() gets dumped in
tdh_phymem_pamt_add() instead.

> +	return ret;
> +out_free:
> +	free_pamt_array(pamt_pa_array);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(tdx_pamt_get);
> +
> +/*
> + * Drop PAMT refcount for the given page and free PAMT memory if it is no
> + * longer needed.
> + */
> +void tdx_pamt_put(struct page *page)
> +{
> +	unsigned long hpa = ALIGN_DOWN(page_to_phys(page), PMD_SIZE);
> +	u64 pamt_pa_array[MAX_DPAMT_ARG_SIZE];
> +	atomic_t *pamt_refcount;
> +	u64 tdx_status;
> +
> +	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
> +		return;
> +
> +	hpa = ALIGN_DOWN(hpa, PMD_SIZE);
> +
> +	pamt_refcount = tdx_find_pamt_refcount(hpa);
> +
> +	scoped_guard(spinlock, &pamt_lock) {
> +		if (!atomic_read(pamt_refcount))
> +			return;
> +
> +		tdx_status = tdh_phymem_pamt_remove(hpa | TDX_PS_2M, pamt_pa_array);
> +
> +		if (IS_TDX_SUCCESS(tdx_status)) {
> +			atomic_dec(pamt_refcount);
> +		} else {
> +			pr_err("TDH_PHYMEM_PAMT_REMOVE failed: %#llx\n", tdx_status);
> +			return;
> +		}
> +	}
> +
> +	free_pamt_array(pamt_pa_array);
> +}
> +EXPORT_SYMBOL_GPL(tdx_pamt_put);

It feels like there's some magic in terms of how the entire contents of
pamt_pa_array[] get zeroed so that this ends up being safe.

Could that get commented, please?

> +/* Allocate a page and make sure it is backed by PAMT memory */

This comment is giving the "what" but is weak on the "why". Could we add
this?

	This ensures that the page can be used as TDX private
	memory and obtain TDX protections.

> +struct page *tdx_alloc_page(void)
> +{
> +	struct page *page;
> +
> +	page = alloc_page(GFP_KERNEL);
> +	if (!page)
> +		return NULL;
> +
> +	if (tdx_pamt_get(page)) {
> +		__free_page(page);
> +		return NULL;
> +	}
> +
> +	return page;
> +}
> +EXPORT_SYMBOL_GPL(tdx_alloc_page);
> +
> +/* Free a page and release its PAMT memory */

Also:

	After this, the page is can no longer be protected by TDX.

> +void tdx_free_page(struct page *page)
> +{
> +	if (!page)
> +		return;
> +
> +	tdx_pamt_put(page);
> +	__free_page(page);
> +}
> +EXPORT_SYMBOL_GPL(tdx_free_page);
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index 82bb82be8567..46c4214b79fb 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -46,6 +46,8 @@
>  #define TDH_PHYMEM_PAGE_WBINVD		41
>  #define TDH_VP_WR			43
>  #define TDH_SYS_CONFIG			45
> +#define TDH_PHYMEM_PAMT_ADD		58
> +#define TDH_PHYMEM_PAMT_REMOVE		59
>  
>  /*
>   * SEAMCALL leaf:


