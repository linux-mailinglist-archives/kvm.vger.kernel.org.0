Return-Path: <kvm+bounces-63410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 496B8C65EED
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 20:20:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 136B0295E0
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 19:20:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92B86262FD0;
	Mon, 17 Nov 2025 19:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WGfHvDQw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3202BDC09;
	Mon, 17 Nov 2025 19:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763407199; cv=none; b=HbKKV+7480Od+KVOq6xcqJNZhqc7DO2d58n2mbo3RjTXBI3rdwQvpVCCjDqrIDm9yBhkmq4NJaQCZKavaHoFXy0Hbx9Z96jWlu5qZx0IOmmml2/Kqa1OpqHfU+PM0/JyvqcLcYWkDqJOXpOD6H1cL0fQMi40b86lo7SE7jRTorE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763407199; c=relaxed/simple;
	bh=DxSJjZKM5URmk3fo7Akgt1UxU7aR3ec07Z4qjw0rbX0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eFy3KyugSr570WgBuHGNyb0hAS9gdMF1C/NPE1LRAudNaDjhLzdYqHHfepr9i4SbgkjjRzc/XB1fLyNyukK+qc2MUgGv15z7meBlXClnZLr0vZrCH43xiQdQpGznhOwgTu3T4UkwDUIlbXoCvBjpNG0jj+AS/xvD5dS3+vTbEAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WGfHvDQw; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763407194; x=1794943194;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DxSJjZKM5URmk3fo7Akgt1UxU7aR3ec07Z4qjw0rbX0=;
  b=WGfHvDQwQwT71oHs6fVWz+4bBSEpa5N9qkbPt2Fg4pWfZEL6PeDq5gve
   4ut9LI5Ejwq8EsEP3s9Pjr2Sao/VD9dvHdU1FZo70Tt8m+dt2eXPO/dk1
   c1oYPVsU98kr2FPlqZ71OIH4KPBu7XEUw6RNfBhXtq9mnpAHi3ao8gWdR
   g4BjkFFqI912qm3rRKC2Qt1/1MahtAxSbwgGySDnOp7GK0bTgQ1RJXQlC
   i1CXF6S5aUCgWI00/B6GJitYtfKl993skPGvT8clCW84S1tyPnvGs3A0R
   O1DQnEM78Izk2tOmpaAeJ/9IFIB5wGZ5oJzanfesams9yqhwwMrHG8BSQ
   Q==;
X-CSE-ConnectionGUID: MxSDvOpkQ3mnNPpQqtXzSQ==
X-CSE-MsgGUID: Qs8YWjt5RjColmQmhoY8TA==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="65124189"
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="65124189"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 11:19:50 -0800
X-CSE-ConnectionGUID: S+in89atShmaPr/ebjhEWg==
X-CSE-MsgGUID: 2fgOD75HS4esCQX87PHKLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="189830567"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO [10.125.109.33]) ([10.125.109.33])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 11:19:49 -0800
Message-ID: <c9f72a69-e220-4914-b047-60020e6e487d@intel.com>
Date: Mon, 17 Nov 2025 11:19:49 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 15/26] x86/virt/tdx: Extend tdx_page_array to support
 IOMMU_MT
To: Xu Yilun <yilun.xu@linux.intel.com>, linux-coco@lists.linux.dev,
 linux-pci@vger.kernel.org
Cc: chao.gao@intel.com, dave.jiang@intel.com, baolu.lu@linux.intel.com,
 yilun.xu@intel.com, zhenzhong.duan@intel.com, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, dave.hansen@linux.intel.com,
 dan.j.williams@intel.com, kas@kernel.org, x86@kernel.org
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
 <20251117022311.2443900-16-yilun.xu@linux.intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20251117022311.2443900-16-yilun.xu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/16/25 18:22, Xu Yilun wrote:
> +struct tdx_page_array *
> +tdx_page_array_create_iommu_mt(unsigned int iq_order, unsigned int nr_mt_pages)
> +{
> +	unsigned int nr_entries = 2 + nr_mt_pages;
> +	int ret;
> +
> +	if (nr_entries > TDX_PAGE_ARRAY_MAX_NENTS)
> +		return NULL;
> +
> +	struct tdx_page_array *array __free(kfree) = kzalloc(sizeof(*array),
> +							     GFP_KERNEL);
> +	if (!array)
> +		return NULL;
> +
> +	struct page *root __free(__free_page) = alloc_page(GFP_KERNEL |
> +							   __GFP_ZERO);
> +	if (!root)
> +		return NULL;
> +
> +	struct page **pages __free(kfree) = kcalloc(nr_entries, sizeof(*pages),
> +						    GFP_KERNEL);
> +	if (!pages)
> +		return NULL;
> +
> +	/* TODO: folio_alloc_node() is preferred, but need numa info */
> +	struct folio *t_iq __free(folio_put) = folio_alloc(GFP_KERNEL |
> +							   __GFP_ZERO,
> +							   iq_order);
> +	if (!t_iq)
> +		return NULL;
> +
> +	struct folio *t_ctxiq __free(folio_put) = folio_alloc(GFP_KERNEL |
> +							      __GFP_ZERO,
> +							      iq_order);
> +	if (!t_ctxiq)
> +		return NULL;
> +
> +	ret = tdx_alloc_pages_bulk(nr_mt_pages, pages + 2);
> +	if (ret)
> +		return NULL;
> +
> +	pages[0] = folio_page(no_free_ptr(t_iq), 0);
> +	pages[1] = folio_page(no_free_ptr(t_ctxiq), 0);
> +
> +	array->nr_pages = nr_entries;
> +	array->pages = no_free_ptr(pages);
> +	array->root = no_free_ptr(root);
> +
> +	tdx_page_array_fill_root(array, 0);
> +
> +	return no_free_ptr(array);
> +}
> +EXPORT_SYMBOL_GPL(tdx_page_array_create_iommu_mt);

Please endeavor to find another way to do this. This is virtually a
copy-and-paste of the earlier code. Please refactor it in way that you
don't need the copy-and-paste.

