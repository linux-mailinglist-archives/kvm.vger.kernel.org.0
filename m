Return-Path: <kvm+bounces-63571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B6BEC6AF63
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 18:29:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id AA1772A3A4
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 17:29:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F09430FC1C;
	Tue, 18 Nov 2025 17:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n8vCnaTU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E05E1FF7C8;
	Tue, 18 Nov 2025 17:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763486978; cv=none; b=sl6Updd4wQb8hI8ewVgZ4U1b8S0N7w6xppyNnuX2yB2xVX5C3wpOC6GaFrmPXutLGIp/hmBX2u0BR8CgJ0CYUXgotJX+T0MvRiUk1TWzdzr9pnGc4wUV7gDDPcjK2/lKFx5bWzKU4Moop16LTMZO14HhKgFjhdksBHpy2jeEhLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763486978; c=relaxed/simple;
	bh=zB71HuM3fl7vgn9us3RRLOR4cnJTm8J9xfgQbdNKn9w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sYkOJfi10PWjxYb9ruFigDR+tbvaaBvx26dtXcUFlkRbfxbGqlh7KOC05D57J1EMka9vqJH9+elfEPH+SNFeygBRsvJi2pPPHq6OPTZjL+/SlQvdiPS3YmvVRYuw4xPgU3OVFxQjaB3MBpATd7gC4jm/6xHDwVFrD1xMvzGGF6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n8vCnaTU; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763486975; x=1795022975;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zB71HuM3fl7vgn9us3RRLOR4cnJTm8J9xfgQbdNKn9w=;
  b=n8vCnaTUMi3onPNXiCBMlrm+IWhKGrp96/HyWxCo32hH94Qj3fQfJThp
   QFuvtq/eo5qWpuPPEC9Tl75bCuHJvaNm5AD5UvnkEpo7t4nxcMVmBRJzq
   fEi/7IkMlStI8tjNlbSTdZGJdxXT4oOYZvcgNAr6PzjhPz4US6Qp8Zubq
   6WRRL3iuLao3fgaF4uZP325/G+KGqJWQDWTDef9AqDlUAtDuS81cCBILa
   xaZym8Tx7OY4iaVStDJBec4jVJZxRWWwsJbKcEOjbVnfUMIMigc4wMotf
   0oqck6h8jOSAXpGkec05V3AhBupu2IUtd8HKURwc9mwJOPq/c4yFdGtST
   Q==;
X-CSE-ConnectionGUID: uD6d2VbXSwWZEYfAR5OdXg==
X-CSE-MsgGUID: PeXOT1g6RQKARP16SGAP6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="76195502"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="76195502"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 09:29:34 -0800
X-CSE-ConnectionGUID: an6P6IorSzuFi2Osg/JceA==
X-CSE-MsgGUID: fhEwDgr2T4KHSkTS4d8O+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="228152261"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa001.jf.intel.com with ESMTP; 18 Nov 2025 09:29:31 -0800
Date: Wed, 19 Nov 2025 01:14:44 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-coco@lists.linux.dev, linux-pci@vger.kernel.org,
	chao.gao@intel.com, dave.jiang@intel.com, baolu.lu@linux.intel.com,
	yilun.xu@intel.com, zhenzhong.duan@intel.com, kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com, dave.hansen@linux.intel.com,
	dan.j.williams@intel.com, kas@kernel.org, x86@kernel.org
Subject: Re: [PATCH v1 08/26] x86/virt/tdx: Add tdx_enable_ext() to enable of
 TDX Module Extensions
Message-ID: <aRyphEW2jpB/3Ht2@yilunxu-OptiPlex-7050>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
 <20251117022311.2443900-9-yilun.xu@linux.intel.com>
 <cfcfb160-fcd2-4a75-9639-5f7f0894d14b@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfcfb160-fcd2-4a75-9639-5f7f0894d14b@intel.com>

On Mon, Nov 17, 2025 at 09:34:30AM -0800, Dave Hansen wrote:
> I really dislike subjects like this. I honestly don't need to know what
> the function's name is. The _rest_ of the subject is just words that
> don't tell me _anything_ about what this patch does.
> 
> In this case, I suspect it's because the patch is doing about 15
> discrete things and it's impossible to write a subject that's anything
> other than some form of:
> 
> 	x86/virt/tdx: Implement $FOO by making miscellaneous changes
> 
> So it's a symptom of the real disease.

Yes, I'll try split the patch.

> 
> On 11/16/25 18:22, Xu Yilun wrote:
> > From: Zhenzhong Duan <zhenzhong.duan@intel.com>
> > 
> > Add a kAPI tdx_enable_ext() for kernel to enable TDX Module Extensions
> > after basic TDX Module initialization.
> > 
> > The extension initialization uses the new TDH.EXT.MEM.ADD and
> > TDX.EXT.INIT seamcalls. TDH.EXT.MEM.ADD add pages to a shared memory
> > pool for extensions to consume.
> 
> "Shared memory" is an exceedingly unfortunate term to use here. They're
> TDX private memory, right?

Sorry, they are indeed TDX private memory. Here 'shared' means the
memory in the pool will be consumed by multiple new features but this
is TDX Module internal details that I should not ramble, especially in
TDX context.

> 
> > The number of pages required is
> > published in the MEMORY_POOL_REQUIRED_PAGES field from TDH.SYS.RD. Then
> > on TDX.EXT.INIT, the extensions consume from the pool and initialize.
> 
> This all seems backwards to me. I don't need to read the ABI names in
> the changelog. I *REALLY* don't need to read the TDX documentation names
> for them. If *ANYTHING* these names should be trivialy mappable to the
> patch that sits below this changelog. They're not.
> 
> This changelog _should_ begin:
> 
> 	Currently, TDX module memory use is relatively static. But, some
> 	new features (called "TDX Module Extensions") need to use memory
> 	more dynamically.
> 
> How much memory does this consume?

12800 pages.

> 
> > TDH.EXT.MEM.ADD is the first user of tdx_page_array. It provides pages
> > to TDX Module as control (private) pages. A tdx_clflush_page_array()
> > helper is introduced to flush shared cache before SEAMCALL, to avoid
> > shared cache write back damages these private pages.
> 
> First, this talks about "control pages". But I don't know what a control
> page is.

It refers to pages provided to TDX Module to hold all kinds of control
structures or metadata. E.g. TDR, TDCS, TDVPR... With TDX Connect we
have more, SPDM metadata, IDE metadata...

> 
> Second, these all need to be in imperative voice. Not:
> 
> 	It provides pages to TDX Module as control (private) pages.
> 
> Do this:
> 
> 	Provide pages to TDX Module as control (private) pages.
> 
> > TDH.EXT.MEM.ADD uses HPA_LIST_INFO as parameter so could leverage the
> > 'first_entry' field to simplify the interrupted - retry flow. Host
> > don't have to care about partial page adding and 'first_entry'.
> > 
> > Use a new version TDH.SYS.CONFIG for VMM to tell TDX Module which
> > optional features (e.g. TDX Connect, and selecting TDX Connect implies
> > selecting TDX Module Extensions) to use and let TDX Module update its
> > global metadata (e.g. memory_pool_required_pages for TDX Module
> > Extensions). So after calling this new version TDH.SYS.CONFIG, VMM
> > updates the cached tdx_sysinfo.
> > 
> > Note that this extension initialization does not impact existing
> > in-flight SEAMCALLs that are not implemented by the extension. So only
> > the first user of an extension-seamcall needs invoke this helper.
> 
> Ahh, so this is another bit of very useful information buried deep in
> this changelog.
> 
> Extensions consume memory, but they're *optional*.
> 
> > diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> > index 3a3ea3fa04f2..1eeb77a6790a 100644
> > --- a/arch/x86/include/asm/tdx.h
> > +++ b/arch/x86/include/asm/tdx.h
> > @@ -125,11 +125,13 @@ static __always_inline u64 sc_retry(sc_func_t func, u64 fn,
> >  #define seamcall(_fn, _args)		sc_retry(__seamcall, (_fn), (_args))
> >  #define seamcall_ret(_fn, _args)	sc_retry(__seamcall_ret, (_fn), (_args))
> >  #define seamcall_saved_ret(_fn, _args)	sc_retry(__seamcall_saved_ret, (_fn), (_args))
> > +int tdx_enable_ext(void);
> >  const char *tdx_dump_mce_info(struct mce *m);
> >  
> >  /* Bit definitions of TDX_FEATURES0 metadata field */
> >  #define TDX_FEATURES0_TDXCONNECT	BIT_ULL(6)
> >  #define TDX_FEATURES0_NO_RBP_MOD	BIT_ULL(18)
> > +#define TDX_FEATURES0_EXT		BIT_ULL(39)
> >  
> >  const struct tdx_sys_info *tdx_get_sysinfo(void);
> >  
> > @@ -223,6 +225,7 @@ u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
> >  u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page);
> >  #else
> >  static inline void tdx_init(void) { }
> > +static inline int tdx_enable_ext(void) { return -ENODEV; }
> >  static inline u32 tdx_get_nr_guest_keyids(void) { return 0; }
> >  static inline const char *tdx_dump_mce_info(struct mce *m) { return NULL; }
> >  static inline const struct tdx_sys_info *tdx_get_sysinfo(void) { return NULL; }
> > diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> > index 4370d3d177f6..b84678165d00 100644
> > --- a/arch/x86/virt/vmx/tdx/tdx.h
> > +++ b/arch/x86/virt/vmx/tdx/tdx.h
> > @@ -46,6 +46,8 @@
> >  #define TDH_PHYMEM_PAGE_WBINVD		41
> >  #define TDH_VP_WR			43
> >  #define TDH_SYS_CONFIG			45
> > +#define TDH_EXT_INIT			60
> > +#define TDH_EXT_MEM_ADD			61
> >  
> >  /*
> >   * SEAMCALL leaf:
> > diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> > index 9a5c32dc1767..bbf93cad5bf2 100644
> > --- a/arch/x86/virt/vmx/tdx/tdx.c
> > +++ b/arch/x86/virt/vmx/tdx/tdx.c
> > @@ -59,6 +59,9 @@ static LIST_HEAD(tdx_memlist);
> >  static struct tdx_sys_info tdx_sysinfo __ro_after_init;
> >  static bool tdx_module_initialized __ro_after_init;
> >  
> > +static DEFINE_MUTEX(tdx_module_ext_lock);
> > +static bool tdx_module_ext_initialized;
> > +
> >  typedef void (*sc_err_func_t)(u64 fn, u64 err, struct tdx_module_args *args);
> >  
> >  static inline void seamcall_err(u64 fn, u64 err, struct tdx_module_args *args)
> > @@ -517,7 +520,7 @@ EXPORT_SYMBOL_GPL(tdx_page_array_ctrl_release);
> >  #define HPA_LIST_INFO_PFN		GENMASK_U64(51, 12)
> >  #define HPA_LIST_INFO_LAST_ENTRY	GENMASK_U64(63, 55)
> >  
> > -static u64 __maybe_unused hpa_list_info_assign_raw(struct tdx_page_array *array)
> > +static u64 hpa_list_info_assign_raw(struct tdx_page_array *array)
> >  {
> >  	return FIELD_PREP(HPA_LIST_INFO_FIRST_ENTRY, 0) |
> >  	       FIELD_PREP(HPA_LIST_INFO_PFN, page_to_pfn(array->root)) |
> > @@ -1251,7 +1254,14 @@ static __init int config_tdx_module(struct tdmr_info_list *tdmr_list,
> >  	args.rcx = __pa(tdmr_pa_array);
> >  	args.rdx = tdmr_list->nr_consumed_tdmrs;
> >  	args.r8 = global_keyid;
> > -	ret = seamcall_prerr(TDH_SYS_CONFIG, &args);
> > +
> > +	if (tdx_sysinfo.features.tdx_features0 & TDX_FEATURES0_TDXCONNECT) {
> > +		args.r9 |= TDX_FEATURES0_TDXCONNECT;
> > +		args.r11 = ktime_get_real_seconds();
> > +		ret = seamcall_prerr(TDH_SYS_CONFIG | (1ULL << TDX_VERSION_SHIFT), &args);
> > +	} else {
> > +		ret = seamcall_prerr(TDH_SYS_CONFIG, &args);
> > +	}
> 
> I'm in the first actual hunk of code and I'm lost. I don't have any idea
> what the "(1ULL << TDX_VERSION_SHIFT)" is doing.

TDX Module defines the version field in its leaf to specify updated
parameter set. The existing user is:

u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid)
{
	struct tdx_module_args args = {
		.rcx = vp->tdvpr_pa,
		.rdx = initial_rcx,
		.r8 = x2apicid,
	};

	/* apicid requires version == 1. */
	return seamcall(TDH_VP_INIT | (1ULL << TDX_VERSION_SHIFT), &args);
}

> 
> Also, bifurcating code paths is discouraged. It's much better to not
> copy and paste the code and instead name your variables and change
> *them* in a single path:
> 
>     u64 module_function = TDH_SYS_CONFIG;
>     u64 features = 0;
>     u64 timestamp = 0;
> 
>     if (tdx_sysinfo.features.tdx_features0 & TDX_FEATURES0_TDXCONNECT) {
> 	features |= TDX_FEATURES0_TDXCONNECT;
> 	timestamp = ktime_get_real_seconds();
> 	module_function |= 1ULL << TDX_VERSION_SHIFT;
>     }

and the following code would be:

	args.r9 = features;
	args.r11 = timestamp;

But the version0 leaf doesn't define these inputs. So I'm wondering
if bifurcating here explains the SPEC evolution better. But anyway
I'm also good to no bifurcation.

> 
>     ret = seamcall_prerr(module_function, &args);
> 
> This would also provide a place to say what the heck is going on with
> the whole "(1ULL << TDX_VERSION_SHIFT)" thing. Just hacking it in and
> open-coding makes it actually harder to comment and describe it.
> 
> >  	/* Free the array as it is not required anymore. */
> >  	kfree(tdmr_pa_array);
> > @@ -1411,6 +1421,11 @@ static __init int init_tdx_module(void)
> >  	if (ret)
> >  		goto err_free_pamts;
> >  
> > +	/* configuration to tdx module may change tdx_sysinfo, update it */
> > +	ret = get_tdx_sys_info(&tdx_sysinfo);
> > +	if (ret)
> > +		goto err_reset_pamts;
> > +
> >  	/* Config the key of global KeyID on all packages */
> >  	ret = config_global_keyid();
> >  	if (ret)
> > @@ -1488,6 +1503,160 @@ static __init int tdx_enable(void)
> >  }
> >  subsys_initcall(tdx_enable);
> >  
> > +static int enable_tdx_ext(void)
> > +{
> 
> Comments, please. "ext" can mean too many things.

Yes.

> What does this do and

I would probably say "Initialize the TDX Module extension". I assume no
need to deep dive into TDX Module internal details, and the SPEC doesn't
reveal them.

> why can it fail?

I would say "Fail when TDH.EXT.INIT is required but returns error on
execution." This is the only thing VMM can see, we don't (have to)
know what's inside.

> 
> > +	struct tdx_module_args args = {};
> > +	u64 r;
> > +
> > +	if (!tdx_sysinfo.ext.ext_required)
> > +		return 0;
> 
> Is this an optimization or is it functionally required?

It is functionally required. When ext_required is 0, it means
no need TDH.EXT.INIT to enable TDX Module Extension, it is already
enabled.

> 
> > +	do {
> > +		r = seamcall(TDH_EXT_INIT, &args);
> > +		cond_resched();
> > +	} while (r == TDX_INTERRUPTED_RESUMABLE);
> > +
> > +	if (r != TDX_SUCCESS)
> > +		return -EFAULT;
> > +
> > +	return 0;
> > +}
> > +
> > +static void tdx_ext_mempool_free(struct tdx_page_array *mempool)
> > +{
> > +	/*
> > +	 * Some pages may have been touched by the TDX module.
> > +	 * Flush cache before returning these pages to kernel.
> > +	 */
> > +	wbinvd_on_all_cpus();
> > +	tdx_page_array_free(mempool);
> > +}
> > +
> > +DEFINE_FREE(tdx_ext_mempool_free, struct tdx_page_array *,
> > +	    if (!IS_ERR_OR_NULL(_T)) tdx_ext_mempool_free(_T))
> > +
> > +/*
> > + * The TDX module exposes a CLFLUSH_BEFORE_ALLOC bit to specify whether
> > + * a CLFLUSH of pages is required before handing them to the TDX module.
> > + * Be conservative and make the code simpler by doing the CLFLUSH
> > + * unconditionally.
> > + */
> > +static void tdx_clflush_page(struct page *page)
> > +{
> > +	clflush_cache_range(page_to_virt(page), PAGE_SIZE);
> > +}
> 
> arch/x86/virt/vmx/tdx/tdx.c has:
> 
> static void tdx_clflush_page(struct page *page)
> {
>         clflush_cache_range(page_to_virt(page), PAGE_SIZE);
> }
> 
> Seems odd to see this here.
> 
> > +static void tdx_clflush_page_array(struct tdx_page_array *array)
> > +{
> > +	for (int i = 0; i < array->nents; i++)
> > +		tdx_clflush_page(array->pages[array->offset + i]);
> > +}
> > +
> > +static int tdx_ext_mem_add(struct tdx_page_array *mempool)
> > +{
> 
> I just realized the 'mempool' has nothing to do with 'struct mempool',
> which makes this a rather unfortunate naming choice.

Maybe tdx_ext_mem?

> 
> > +	struct tdx_module_args args = {
> > +		.rcx = hpa_list_info_assign_raw(mempool),
> > +	};
> > +	u64 r;
> > +
> > +	tdx_clflush_page_array(mempool);
> > +
> > +	do {
> > +		r = seamcall_ret(TDH_EXT_MEM_ADD, &args);
> > +		cond_resched();
> > +	} while (r == TDX_INTERRUPTED_RESUMABLE);
> > +
> > +	if (r != TDX_SUCCESS)
> > +		return -EFAULT;
> > +
> > +	return 0;
> > +}
> > +
> > +static struct tdx_page_array *tdx_ext_mempool_setup(void)
> > +{
> > +	unsigned int nr_pages, nents, offset = 0;
> > +	int ret;
> > +
> > +	nr_pages = tdx_sysinfo.ext.memory_pool_required_pages;
> > +	if (!nr_pages)
> > +		return NULL;
> > +
> > +	struct tdx_page_array *mempool __free(tdx_page_array_free) =
> > +		tdx_page_array_alloc(nr_pages);
> > +	if (!mempool)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	while (1) {
> > +		nents = tdx_page_array_fill_root(mempool, offset);
> 
> This is really difficult to understand. It's not really filling a
> "root", it's populating an array. The structure of the loop is also

It is populating the root page with part (512 pages at most) of the array.
So is it better name the function tdx_page_array_populate_root()?

> rather non-obvious. It's doing:
> 
> 	while (1) {
> 		fill(&array);
> 		tell_tdx_module(&array);
> 	}

There is some explanation in Patch #6:

 4. Note the root page contains 512 HPAs at most, if more pages are
   required, refilling the tdx_page_array is needed.

 - struct tdx_page_array *array = tdx_page_array_alloc(nr_pages);
 - for each 512-page bulk
   - tdx_page_array_fill_root(array, offset);
   - seamcall(TDH_XXX_ADD, array, ...);

> 
> Why can't it be:
> 
> 	while (1)
> 		fill(&array);
> 	while (1)
> 		tell_tdx_module(&array);

The consideration is, no need to create as much supporting
structures (struct tdx_page_array *, struct page ** and root page) for
each 512-page bulk. Use one and re-populate it in loop is efficient.

> 
> for example?
> 
> > +		if (!nents)
> > +			break;
> > +
> > +		ret = tdx_ext_mem_add(mempool);
> > +		if (ret)
> > +			return ERR_PTR(ret);
> > +
> > +		offset += nents;
> > +	}
> > +
> > +	return no_free_ptr(mempool);
> > +}
> 
> This patch is getting waaaaaaaaaaaaaaay too long. I'd say it needs to be
> 4 or 5 patches, just eyeballing it.

I agree.

> 
> Call be old fashioned, but I suspect the use of __free() here is atually
> hurting readability.

Ah.. Dan, could you help me here? :)   I'm infected by Dan and truly
start to love scope-based cleanup.

> 
> > +static int init_tdx_ext(void)
> > +{
> > +	int ret;
> > +
> > +	if (!(tdx_sysinfo.features.tdx_features0 & TDX_FEATURES0_EXT))
> > +		return -EOPNOTSUPP;
> > +
> > +	struct tdx_page_array *mempool __free(tdx_ext_mempool_free) =
> > +		tdx_ext_mempool_setup();
> > +	/* Return NULL is OK, means no need to setup mempool */
> > +	if (IS_ERR(mempool))
> > +		return PTR_ERR(mempool);
> 
> That's a somewhat odd comment to put above an if() that doesn't return NULL.

I meant to explain why using IS_ERR instead of IS_ERR_OR_NULL. I can
impove the comment.

> 
> > +	ret = enable_tdx_ext();
> > +	if (ret)
> > +		return ret;
> > +
> > +	/* Extension memory is never reclaimed once assigned */
> > +	if (mempool)
> > +		tdx_page_array_ctrl_leak(no_free_ptr(mempool));
> > +
> > +	return 0;
> > +}
> 
> 
> 
> > +/**
> > + * tdx_enable_ext - Enable TDX module extensions.
> > + *
> > + * This function can be called in parallel by multiple callers.
> > + *
> > + * Return 0 if TDX module extension is enabled successfully, otherwise error.
> > + */
> > +int tdx_enable_ext(void)
> > +{
> > +	int ret;
> > +
> > +	if (!tdx_module_initialized)
> > +		return -ENOENT;
> > +
> > +	guard(mutex)(&tdx_module_ext_lock);
> > +
> > +	if (tdx_module_ext_initialized)
> > +		return 0;
> > +
> > +	ret = init_tdx_ext();
> > +	if (ret) {
> > +		pr_debug("module extension initialization failed (%d)\n", ret);
> > +		return ret;
> > +	}
> > +
> > +	pr_debug("module extension initialized\n");
> > +	tdx_module_ext_initialized = true;
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(tdx_enable_ext);
> > +
> >  static bool is_pamt_page(unsigned long phys)
> >  {
> >  	struct tdmr_info_list *tdmr_list = &tdx_tdmr_list;
> > @@ -1769,17 +1938,6 @@ static inline u64 tdx_tdr_pa(struct tdx_td *td)
> >  	return page_to_phys(td->tdr_page);
> >  }
> >  
> > -/*
> > - * The TDX module exposes a CLFLUSH_BEFORE_ALLOC bit to specify whether
> > - * a CLFLUSH of pages is required before handing them to the TDX module.
> > - * Be conservative and make the code simpler by doing the CLFLUSH
> > - * unconditionally.
> > - */
> > -static void tdx_clflush_page(struct page *page)
> > -{
> > -	clflush_cache_range(page_to_virt(page), PAGE_SIZE);
> > -}
> 
> Ahh, here's the code move.
> 
> This should be in its own patch.

Yes.

> 
> 

