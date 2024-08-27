Return-Path: <kvm+bounces-25152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D104960B7C
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 15:13:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9AEDF1F24526
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 13:13:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07DDE1BF7FA;
	Tue, 27 Aug 2024 13:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a8KEz7iE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574E617BED8;
	Tue, 27 Aug 2024 13:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724764254; cv=none; b=uYen0lU7F3MTgr2jzxqT8TvsWVhvIyq+tt+cqp8ZeLTqEXE/pWkaGJBvz0n2FpgyYq6Xcq2SGpOBlMxCNB+1Pv8JwOyAVPlDF+ZfxtQVBd8TCclPG469FvUxMnVGS5VOmQsB9Z9RiuqsVacurZWNSICkQbchBy+Zbb7uA2TjlTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724764254; c=relaxed/simple;
	bh=jhZ04nmyxAmB12hqvL4zQZCI37+eytbUvdynjCzOfCw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fSLVqbtAsjOQcatXm6L971JY7m7xp5g7WrNdpkW0ejn7GMb3aq20rhHBoPsiXIhZa+Ah+K6DuaGJDnREYwei0yXEEasV7ynSACBp1jLqETrtfpVKzv4ixfktcQ64PPGwdfgiWdlVVp25gu/CoVmiBwvsuVQ9kRG+qBWw0Wx7rI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a8KEz7iE; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724764253; x=1756300253;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jhZ04nmyxAmB12hqvL4zQZCI37+eytbUvdynjCzOfCw=;
  b=a8KEz7iEnMYdM+L6m01ngpiYXAY7nR8ud2XeZY/K5a85lcMiZ0YXgxxg
   Wg2vgb65SK4Ee8Es7+oJluz3ZIHsAosMmJiIZoIyZ6OACUBXeXLKTwT/M
   tQEBW6pOBK0Icsu8CaIUUDznDmvGDydfQbBPxKoJYB01k2660pTjA2SKH
   h973ABk3ULmrI9bkQrbGMaIGOMUYrX9lmTH4wzckb8Evs8NS5GOn1b8y8
   vsiM2t2ZGyfyRxIJwonmJuKIZNN3PrSgJ9zg40Hw4gBUknvjjuoAdrA5S
   b3Zpe5v8tvPIkYs6QopsENgOdo5N42qNneDU074Kd/iML56oj8o6YspbP
   g==;
X-CSE-ConnectionGUID: tacw+TCoTuqdsEfwmjFlNg==
X-CSE-MsgGUID: Y0Pt6HqAQ8qxbMRN/9YnRg==
X-IronPort-AV: E=McAfee;i="6700,10204,11176"; a="40710704"
X-IronPort-AV: E=Sophos;i="6.10,180,1719903600"; 
   d="scan'208";a="40710704"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 06:10:52 -0700
X-CSE-ConnectionGUID: eugkAdYqSkyL4fblioKTYw==
X-CSE-MsgGUID: sCuqlaFvS6W/x+EaagLvTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,180,1719903600"; 
   d="scan'208";a="86054847"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.245.89.141])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 06:10:46 -0700
Message-ID: <1b810874-2734-4ca8-933d-ebe9500a8ddc@intel.com>
Date: Tue, 27 Aug 2024 16:10:40 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/8] x86/virt/tdx: Rename 'struct tdx_tdmr_sysinfo' to
 reflect the spec better
To: Kai Huang <kai.huang@intel.com>, dave.hansen@intel.com,
 kirill.shutemov@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
 peterz@infradead.org, mingo@redhat.com, hpa@zytor.com,
 dan.j.williams@intel.com, seanjc@google.com, pbonzini@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, isaku.yamahata@intel.com, chao.gao@intel.com,
 binbin.wu@linux.intel.com
References: <cover.1724741926.git.kai.huang@intel.com>
 <b5e4788739fd7f9100a23808bebe1bb70f4b9073.1724741926.git.kai.huang@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <b5e4788739fd7f9100a23808bebe1bb70f4b9073.1724741926.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/08/24 10:14, Kai Huang wrote:

"to reflect the spec better" is a bit vague.  How about:

x86/virt/tdx: Rename 'struct tdx_tdmr_sysinfo' to 'struct tdx_sys_info_tdmr'

Rename 'struct tdx_tdmr_sysinfo' to 'struct tdx_sys_info_tdmr' to
prepare for adding similar structures that will all be prefixed by
'tdx_sys_info_'.

> The TDX module provides a set of "global metadata fields".  They report

Since it is a name of something, could capitalize "Global Metadata Fields"

> things like TDX module version, supported features, and fields related
> to create/run TDX guests and so on.
> 
> TDX organizes those metadata fields by "Class"es based on the meaning of

by "Class"es	->	into "Classes"

> those fields.  E.g., for now the kernel only reads "TD Memory Region"
> (TDMR) related fields for module initialization.  Those fields are
> defined under class "TDMR Info".
> 
> There are both immediate needs to read more metadata fields for module
> initialization and near-future needs for other kernel components like
> KVM to run TDX guests.  To meet all those requirements, the idea is the
> TDX host core-kernel to provide a centralized, canonical, and read-only
> structure for the global metadata that comes out from the TDX module for
> all kernel components to use.
> 
> More specifically, the target is to end up with something like:
> 
>        struct tdx_sys_info {
> 	       struct tdx_sys_info_classA a;
> 	       struct tdx_sys_info_classB b;
> 	       ...
>        };
> 
> Currently the kernel organizes all fields under "TDMR Info" class in
> 'struct tdx_tdmr_sysinfo'.  To prepare for the above target, rename the
> structure to 'struct tdx_sys_info_tdmr' to follow the class name better.
> 
> No functional change intended.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
> v2 -> v3:
>  - Split out as a separate patch and place it at beginning:
> 
>    https://lore.kernel.org/kvm/cover.1721186590.git.kai.huang@intel.com/T/#m8fec7c429242d640cf5e756eb68e3b822e6dff8b
>  
>  - Rename to 'struct tdx_sys_info_tdmr':
> 
>    https://lore.kernel.org/kvm/cover.1721186590.git.kai.huang@intel.com/T/#md73dd9b02a492acf4a6facae63e8d030e320967d
>    https://lore.kernel.org/kvm/cover.1721186590.git.kai.huang@intel.com/T/#m8fec7c429242d640cf5e756eb68e3b822e6dff8b
> 
> ---
>  arch/x86/virt/vmx/tdx/tdx.c | 36 ++++++++++++++++++------------------
>  arch/x86/virt/vmx/tdx/tdx.h |  2 +-
>  2 files changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 4e2b2e2ac9f9..e979bf442929 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -272,7 +272,7 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
>  
>  static int read_sys_metadata_field16(u64 field_id,
>  				     int offset,
> -				     struct tdx_tdmr_sysinfo *ts)
> +				     struct tdx_sys_info_tdmr *ts)
>  {
>  	u16 *ts_member = ((void *)ts) + offset;
>  	u64 tmp;
> @@ -298,9 +298,9 @@ struct field_mapping {
>  
>  #define TD_SYSINFO_MAP(_field_id, _offset) \
>  	{ .field_id = MD_FIELD_ID_##_field_id,	   \
> -	  .offset   = offsetof(struct tdx_tdmr_sysinfo, _offset) }
> +	  .offset   = offsetof(struct tdx_sys_info_tdmr, _offset) }
>  
> -/* Map TD_SYSINFO fields into 'struct tdx_tdmr_sysinfo': */
> +/* Map TD_SYSINFO fields into 'struct tdx_sys_info_tdmr': */
>  static const struct field_mapping fields[] = {
>  	TD_SYSINFO_MAP(MAX_TDMRS,	      max_tdmrs),
>  	TD_SYSINFO_MAP(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
> @@ -309,16 +309,16 @@ static const struct field_mapping fields[] = {
>  	TD_SYSINFO_MAP(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]),
>  };
>  
> -static int get_tdx_tdmr_sysinfo(struct tdx_tdmr_sysinfo *tdmr_sysinfo)
> +static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
>  {
>  	int ret;
>  	int i;
>  
> -	/* Populate 'tdmr_sysinfo' fields using the mapping structure above: */
> +	/* Populate 'sysinfo_tdmr' fields using the mapping structure above: */
>  	for (i = 0; i < ARRAY_SIZE(fields); i++) {
>  		ret = read_sys_metadata_field16(fields[i].field_id,
>  						fields[i].offset,
> -						tdmr_sysinfo);
> +						sysinfo_tdmr);
>  		if (ret)
>  			return ret;
>  	}
> @@ -342,13 +342,13 @@ static int tdmr_size_single(u16 max_reserved_per_tdmr)
>  }
>  
>  static int alloc_tdmr_list(struct tdmr_info_list *tdmr_list,
> -			   struct tdx_tdmr_sysinfo *tdmr_sysinfo)
> +			   struct tdx_sys_info_tdmr *sysinfo_tdmr)
>  {
>  	size_t tdmr_sz, tdmr_array_sz;
>  	void *tdmr_array;
>  
> -	tdmr_sz = tdmr_size_single(tdmr_sysinfo->max_reserved_per_tdmr);
> -	tdmr_array_sz = tdmr_sz * tdmr_sysinfo->max_tdmrs;
> +	tdmr_sz = tdmr_size_single(sysinfo_tdmr->max_reserved_per_tdmr);
> +	tdmr_array_sz = tdmr_sz * sysinfo_tdmr->max_tdmrs;
>  
>  	/*
>  	 * To keep things simple, allocate all TDMRs together.
> @@ -367,7 +367,7 @@ static int alloc_tdmr_list(struct tdmr_info_list *tdmr_list,
>  	 * at a given index in the TDMR list.
>  	 */
>  	tdmr_list->tdmr_sz = tdmr_sz;
> -	tdmr_list->max_tdmrs = tdmr_sysinfo->max_tdmrs;
> +	tdmr_list->max_tdmrs = sysinfo_tdmr->max_tdmrs;
>  	tdmr_list->nr_consumed_tdmrs = 0;
>  
>  	return 0;
> @@ -921,11 +921,11 @@ static int tdmrs_populate_rsvd_areas_all(struct tdmr_info_list *tdmr_list,
>  /*
>   * Construct a list of TDMRs on the preallocated space in @tdmr_list
>   * to cover all TDX memory regions in @tmb_list based on the TDX module
> - * TDMR global information in @tdmr_sysinfo.
> + * TDMR global information in @sysinfo_tdmr.
>   */
>  static int construct_tdmrs(struct list_head *tmb_list,
>  			   struct tdmr_info_list *tdmr_list,
> -			   struct tdx_tdmr_sysinfo *tdmr_sysinfo)
> +			   struct tdx_sys_info_tdmr *sysinfo_tdmr)
>  {
>  	int ret;
>  
> @@ -934,12 +934,12 @@ static int construct_tdmrs(struct list_head *tmb_list,
>  		return ret;
>  
>  	ret = tdmrs_set_up_pamt_all(tdmr_list, tmb_list,
> -			tdmr_sysinfo->pamt_entry_size);
> +			sysinfo_tdmr->pamt_entry_size);
>  	if (ret)
>  		return ret;
>  
>  	ret = tdmrs_populate_rsvd_areas_all(tdmr_list, tmb_list,
> -			tdmr_sysinfo->max_reserved_per_tdmr);
> +			sysinfo_tdmr->max_reserved_per_tdmr);
>  	if (ret)
>  		tdmrs_free_pamt_all(tdmr_list);
>  
> @@ -1098,7 +1098,7 @@ static int init_tdmrs(struct tdmr_info_list *tdmr_list)
>  
>  static int init_tdx_module(void)
>  {
> -	struct tdx_tdmr_sysinfo tdmr_sysinfo;
> +	struct tdx_sys_info_tdmr sysinfo_tdmr;
>  	int ret;
>  
>  	/*
> @@ -1117,17 +1117,17 @@ static int init_tdx_module(void)
>  	if (ret)
>  		goto out_put_tdxmem;
>  
> -	ret = get_tdx_tdmr_sysinfo(&tdmr_sysinfo);
> +	ret = get_tdx_sys_info_tdmr(&sysinfo_tdmr);
>  	if (ret)
>  		goto err_free_tdxmem;
>  
>  	/* Allocate enough space for constructing TDMRs */
> -	ret = alloc_tdmr_list(&tdx_tdmr_list, &tdmr_sysinfo);
> +	ret = alloc_tdmr_list(&tdx_tdmr_list, &sysinfo_tdmr);
>  	if (ret)
>  		goto err_free_tdxmem;
>  
>  	/* Cover all TDX-usable memory regions in TDMRs */
> -	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, &tdmr_sysinfo);
> +	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, &sysinfo_tdmr);
>  	if (ret)
>  		goto err_free_tdmrs;
>  
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index b701f69485d3..148f9b4d1140 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -100,7 +100,7 @@ struct tdx_memblock {
>  };
>  
>  /* "TDMR info" part of "Global Scope Metadata" for constructing TDMRs */
> -struct tdx_tdmr_sysinfo {
> +struct tdx_sys_info_tdmr {
>  	u16 max_tdmrs;
>  	u16 max_reserved_per_tdmr;
>  	u16 pamt_entry_size[TDX_PS_NR];


