Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D87F660713
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 20:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235610AbjAFTYz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 14:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234858AbjAFTYx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 14:24:53 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF23A73E2D;
        Fri,  6 Jan 2023 11:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673033092; x=1704569092;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=urJOmVPJ99y51Km3uk2nWj9LuSQ8wgumbaoe8ilFZxI=;
  b=EA3QJluaZ4LJnq5YTpMWn3bLLNTSTtPD5ouLGbJe7ar49KvcAO0H+9ut
   EDz8uVy5D5W1Ai0HlzVxNva9aVqO/i2LtB+OIkBdmgtENtkUmx/fPzlZ4
   a5KoOaoquwWLIrYb53QyaIh3CYRkdtIUanXskBsf4rJNn5dZnVXGDqgYd
   TXedAyfAWwygQuWDNNbWpGkHfCgl7M/IX1eDigAE2piqdQQGejC45NZWl
   phDwrO5ECjKkOwr1c9hk4sJTJuWhFtfYWAC+YzCDtlEMuPOh0R/ZrJG/l
   ugyqwtuxh8xZenJLlaBzzKoecHSt7pzloXbGsrs7bbI7UzVud79vEFGP4
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="323789766"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="323789766"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 11:24:52 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="688391354"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="688391354"
Received: from xiangyuy-mobl.amr.corp.intel.com (HELO [10.212.251.186]) ([10.212.251.186])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 11:24:51 -0800
Message-ID: <c70c30fb-073f-4355-c6a6-052d013a99da@intel.com>
Date:   Fri, 6 Jan 2023 11:24:51 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v8 08/16] x86/virt/tdx: Add placeholder to construct TDMRs
 to cover all TDX memory regions
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, peterz@infradead.org, tglx@linutronix.de,
        seanjc@google.com, pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1670566861.git.kai.huang@intel.com>
 <ef6fe9247007ee8e15272de01ded1e0a9152be02.1670566861.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <ef6fe9247007ee8e15272de01ded1e0a9152be02.1670566861.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +struct tdmr_info_list {
> +	struct tdmr_info *first_tdmr;

This is named badly.  This is really a pointer to an array.  While it
_does_ of course point to the first member of the array, the naming
should make it clear that there are multiple tdmr_infos here.

> +	int tdmr_sz;
> +	int max_tdmrs;
> +	int nr_tdmrs;	/* Actual number of TDMRs */
> +};

This 'tdmr_info_list's is declared in an unfortunate place.  I thought
the tdmr_size_single() function below was related to it.

Also, tdmr_sz and max_tdmrs can both be derived from 'sysinfo'.  Do they
really need to be stored here?  If so, I think I'd probably do something
like this with the structure:

struct tdmr_info_list {
	struct tdmr_info *tdmrs;
	int nr_consumed_tdmrs; // How many @tdmrs are in use

	/* Metadata for freeing this structure: */
	int tdmr_sz;   // Size of one 'tdmr_info' (has a flex array)
	int max_tdmrs; // How many @tdmrs are allocated
};

Modulo whataver folks are doing for comments these days.

> +/* Calculate the actual TDMR size */
> +static int tdmr_size_single(u16 max_reserved_per_tdmr)
> +{
> +	int tdmr_sz;
> +
> +	/*
> +	 * The actual size of TDMR depends on the maximum
> +	 * number of reserved areas.
> +	 */
> +	tdmr_sz = sizeof(struct tdmr_info);
> +	tdmr_sz += sizeof(struct tdmr_reserved_area) * max_reserved_per_tdmr;
> +
> +	return ALIGN(tdmr_sz, TDMR_INFO_ALIGNMENT);
> +}
> +
> +static int alloc_tdmr_list(struct tdmr_info_list *tdmr_list,
> +			   struct tdsysinfo_struct *sysinfo)
> +{
> +	size_t tdmr_sz, tdmr_array_sz;
> +	void *tdmr_array;
> +
> +	tdmr_sz = tdmr_size_single(sysinfo->max_reserved_per_tdmr);
> +	tdmr_array_sz = tdmr_sz * sysinfo->max_tdmrs;
> +
> +	/*
> +	 * To keep things simple, allocate all TDMRs together.
> +	 * The buffer needs to be physically contiguous to make
> +	 * sure each TDMR is physically contiguous.
> +	 */
> +	tdmr_array = alloc_pages_exact(tdmr_array_sz,
> +			GFP_KERNEL | __GFP_ZERO);
> +	if (!tdmr_array)
> +		return -ENOMEM;
> +
> +	tdmr_list->first_tdmr = tdmr_array;
> +	/*

	^ probably missing whitepsace before the comment

> +	 * Keep the size of TDMR to find the target TDMR
> +	 * at a given index in the TDMR list.
> +	 */
> +	tdmr_list->tdmr_sz = tdmr_sz;
> +	tdmr_list->max_tdmrs = sysinfo->max_tdmrs;
> +	tdmr_list->nr_tdmrs = 0;
> +
> +	return 0;
> +}
> +
> +static void free_tdmr_list(struct tdmr_info_list *tdmr_list)
> +{
> +	free_pages_exact(tdmr_list->first_tdmr,
> +			tdmr_list->max_tdmrs * tdmr_list->tdmr_sz);
> +}
> +
> +/*
> + * Construct a list of TDMRs on the preallocated space in @tdmr_list
> + * to cover all TDX memory regions in @tmb_list based on the TDX module
> + * information in @sysinfo.
> + */
> +static int construct_tdmrs(struct list_head *tmb_list,
> +			   struct tdmr_info_list *tdmr_list,
> +			   struct tdsysinfo_struct *sysinfo)
> +{
> +	/*
> +	 * TODO:
> +	 *
> +	 *  - Fill out TDMRs to cover all TDX memory regions.
> +	 *  - Allocate and set up PAMTs for each TDMR.
> +	 *  - Designate reserved areas for each TDMR.
> +	 *
> +	 * Return -EINVAL until constructing TDMRs is done
> +	 */
> +	return -EINVAL;
> +}
> +
>  static int init_tdx_module(void)
>  {
>  	/*
> @@ -358,6 +439,7 @@ static int init_tdx_module(void)
>  			TDSYSINFO_STRUCT_SIZE, TDSYSINFO_STRUCT_ALIGNMENT);
>  	struct cmr_info cmr_array[MAX_CMRS] __aligned(CMR_INFO_ARRAY_ALIGNMENT);
>  	struct tdsysinfo_struct *sysinfo = &PADDED_STRUCT(tdsysinfo);
> +	struct tdmr_info_list tdmr_list;
>  	int ret;
>  
>  	ret = tdx_get_sysinfo(sysinfo, cmr_array);
> @@ -380,11 +462,19 @@ static int init_tdx_module(void)
>  	if (ret)
>  		goto out;
>  
> +	/* Allocate enough space for constructing TDMRs */
> +	ret = alloc_tdmr_list(&tdmr_list, sysinfo);
> +	if (ret)
> +		goto out_free_tdx_mem;
> +
> +	/* Cover all TDX-usable memory regions in TDMRs */
> +	ret = construct_tdmrs(&tdx_memlist, &tdmr_list, sysinfo);
> +	if (ret)
> +		goto out_free_tdmrs;
> +
>  	/*
>  	 * TODO:
>  	 *
> -	 *  - Construct a list of TDMRs to cover all TDX-usable memory
> -	 *    regions.
>  	 *  - Pick up one TDX private KeyID as the global KeyID.
>  	 *  - Configure the TDMRs and the global KeyID to the TDX module.
>  	 *  - Configure the global KeyID on all packages.
> @@ -393,6 +483,16 @@ static int init_tdx_module(void)
>  	 *  Return error before all steps are done.
>  	 */
>  	ret = -EINVAL;
> +out_free_tdmrs:
> +	/*
> +	 * Free the space for the TDMRs no matter the initialization is
> +	 * successful or not.  They are not needed anymore after the
> +	 * module initialization.
> +	 */
> +	free_tdmr_list(&tdmr_list);
> +out_free_tdx_mem:
> +	if (ret)
> +		free_tdx_memlist(&tdx_memlist);
>  out:
>  	/*
>  	 * @tdx_memlist is written here and read at memory hotplug time.
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index 6d32f62e4182..d0c762f1a94c 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -90,6 +90,29 @@ struct tdsysinfo_struct {
>  	DECLARE_FLEX_ARRAY(struct cpuid_config, cpuid_configs);
>  } __packed;
>  
> +struct tdmr_reserved_area {
> +	u64 offset;
> +	u64 size;
> +} __packed;
> +
> +#define TDMR_INFO_ALIGNMENT	512
> +
> +struct tdmr_info {
> +	u64 base;
> +	u64 size;
> +	u64 pamt_1g_base;
> +	u64 pamt_1g_size;
> +	u64 pamt_2m_base;
> +	u64 pamt_2m_size;
> +	u64 pamt_4k_base;
> +	u64 pamt_4k_size;
> +	/*
> +	 * Actual number of reserved areas depends on
> +	 * 'struct tdsysinfo_struct'::max_reserved_per_tdmr.
> +	 */
> +	DECLARE_FLEX_ARRAY(struct tdmr_reserved_area, reserved_areas);
> +} __packed __aligned(TDMR_INFO_ALIGNMENT);
> +
>  /*
>   * Do not put any hardware-defined TDX structure representations below
>   * this comment!

