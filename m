Return-Path: <kvm+bounces-56798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C29B3B4354C
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:16:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB5761767E8
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:16:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBAF42BEFE1;
	Thu,  4 Sep 2025 08:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OS4pUQHN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2BC19E7F8;
	Thu,  4 Sep 2025 08:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973797; cv=none; b=n54V4f5F/4pI9+hvTZAl45DRaViZ7rNPaMGjV6Avq/25lTm3cAX/KDV092VatLLhBLHob+QlXP46eKRTRChtdr6jhQG77V3jteC6OilFdDaCDMEl2V5OjtTEkSWebGsm3ExbVXU5GQs2BBiyyDpnJV+DpxAieido4PskE99Hki8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973797; c=relaxed/simple;
	bh=0uRVCZgU5phbSJgXhd7NozI3rO8rlqQp8LratVeijWo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CTv+WvpJb29jgjkpAO6xfzPw6f+UyhKpbzWZnIVRBnt7p/xtLpuJrdd/i5cm72e3behu2GFsAUbad3i/p6tdvgj/9akHKZmHcMR/EHw0YrELBJplwmSKHGOD4ozZ+fWmXqu3sLY9Zl0u4SpWzACw2gMT0nGQHf/kskzu8tPCcCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OS4pUQHN; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756973795; x=1788509795;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0uRVCZgU5phbSJgXhd7NozI3rO8rlqQp8LratVeijWo=;
  b=OS4pUQHNiwbGaAvhrSjGkRWZPHsvjh3fmUVSAIlADV3lwj4OIVHiLVMf
   qOkmJPT0XA6TsV5/UjFKIWqyvfxhc+YAaAjwljGOJjZUSvmSVkAr4dRSr
   5i6sCeF8C9NiqQAWyAB1mnDr4kBXvuNskrg7c3p6uJzN8TEFnX0swpQ0P
   dI1YLWwU9Mzp7ztbyJr0/ulFr2xtnQ0uolYEc6pr1gqXWyAoEN60s9naj
   y/pj2zKOGjo9NcWxRR5jqPmWritIvEER+4ludlIT0axQHkE8eknhJSNRC
   999SkY3GI8wevYc3sgp+vyg04DTOQStRpHujAhc5OnZt9NPYJP6lX+dFG
   w==;
X-CSE-ConnectionGUID: NFzTnAEmSiC40fv81Fd0ww==
X-CSE-MsgGUID: ALUj9ZCrTP+2hq/BM9+IFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="81891358"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="81891358"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 01:16:34 -0700
X-CSE-ConnectionGUID: lElWuWOzTQOck6HQYwVykQ==
X-CSE-MsgGUID: tn/sM+FSTaS9YffOShqeRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,237,1751266800"; 
   d="scan'208";a="177047588"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 01:16:29 -0700
Message-ID: <0d3229ff-2359-4ade-a715-c8af56c2916c@linux.intel.com>
Date: Thu, 4 Sep 2025 16:16:27 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 18/23] x86/virt/tdx: Do not perform cache flushes
 unless CLFLUSH_BEFORE_ALLOC is set
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com,
 dave.hansen@intel.com, kas@kernel.org, tabba@google.com,
 ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com,
 david@redhat.com, vannapurve@google.com, vbabka@suse.cz,
 thomas.lendacky@amd.com, pgonda@google.com, zhiquan1.li@intel.com,
 fan.du@intel.com, jun.miao@intel.com, ira.weiny@intel.com,
 isaku.yamahata@intel.com, xiaoyao.li@intel.com, chao.p.peng@intel.com
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094516.4705-1-yan.y.zhao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250807094516.4705-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/7/2025 5:45 PM, Yan Zhao wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>
> The TDX module enumerates with a TDX_FEATURES0 bit if an explicit cache
> flush is necessary when switching KeyID for a page, like before
> handing the page over to a TD.
>
> Currently, none of the TDX-capable platforms have this bit enabled.
>
> Moreover, cache flushing with TDH.PHYMEM.PAGE.WBINVD fails if
> Dynamic PAMT is active and the target page is not 4k. The SEAMCALL only
> supports 4k pages and will fail if there is no PAMT_4K for the HPA.
>
> Avoid performing these cache flushes unless the CLFLUSH_BEFORE_ALLOC bit
> of TDX_FEATURES0 is set.
>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
> RFC v2:
> - Pulled from
>    git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git tdx/dpamt-huge.
> - Rebased on top of TDX huge page RFC v2 (Yan)
> ---
>   arch/x86/include/asm/tdx.h  |  1 +
>   arch/x86/virt/vmx/tdx/tdx.c | 19 +++++++++++++------
>   2 files changed, 14 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index f1bd74348b34..c058a82d4a97 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -15,6 +15,7 @@
>   
>   /* Bit definitions of TDX_FEATURES0 metadata field */
>   #define TDX_FEATURES0_NO_RBP_MOD		BIT_ULL(18)
> +#define TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC	BIT_ULL(23)
>   #define TDX_FEATURES0_DYNAMIC_PAMT		BIT_ULL(36)
>   
>   #ifndef __ASSEMBLER__
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 9ed585bde062..b7a0ee0f4a50 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -1648,14 +1648,13 @@ static inline u64 tdx_tdvpr_pa(struct tdx_vp *td)
>   	return page_to_phys(td->tdvpr_page);
>   }
>   
> -/*
> - * The TDX module exposes a CLFLUSH_BEFORE_ALLOC bit to specify whether
> - * a CLFLUSH of pages is required before handing them to the TDX module.
> - * Be conservative and make the code simpler by doing the CLFLUSH
> - * unconditionally.
> - */
>   static void tdx_clflush_page(struct page *page)
>   {
> +	u64 tdx_features0 = tdx_sysinfo.features.tdx_features0;
> +
> +	if (tdx_features0 & TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC)

According to the cover letter, if TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC is enabled,
an explicit cache flush is necessary.
Shouldn't this and below be:
if (!(tdx_features0 & TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC))

> +		return;
> +
>   	clflush_cache_range(page_to_virt(page), PAGE_SIZE);
>   }
>   
> @@ -2030,8 +2029,12 @@ EXPORT_SYMBOL_GPL(tdh_phymem_cache_wb);
>   
>   u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td)
>   {
> +	u64 tdx_features0 = tdx_sysinfo.features.tdx_features0;
>   	struct tdx_module_args args = {};
>   
> +	if (tdx_features0 & TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC)
> +		return 0;
> +
>   	args.rcx = mk_keyed_paddr(tdx_global_keyid, td->tdr_page);
>   
>   	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
> @@ -2041,10 +2044,14 @@ EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_tdr);
>   u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct folio *folio,
>   				unsigned long start_idx, unsigned long npages)
>   {
> +	u64 tdx_features0 = tdx_sysinfo.features.tdx_features0;
>   	struct page *start = folio_page(folio, start_idx);
>   	struct tdx_module_args args = {};
>   	u64 err;
>   
> +	if (tdx_features0 & TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC)
> +		return 0;
> +
>   	if (start_idx + npages > folio_nr_pages(folio))
>   		return TDX_OPERAND_INVALID;
>   


