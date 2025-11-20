Return-Path: <kvm+bounces-63782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C3C1C7257E
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 07:29:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C2BE04E73A3
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 06:25:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E2132F1FCA;
	Thu, 20 Nov 2025 06:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q7um5342"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FC019FA93;
	Thu, 20 Nov 2025 06:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763619891; cv=none; b=YGlmr9yxOPxTm94JWzkE2T0UVpKjNwdPWYoS6Ili1Xh0K7M/W0iRI7pnkHgF473fd+0AIE4jVMlqzG298JE+JNFv6nIVMA938owComf/kJx2lbmk2D8xeOM2HP2UlpzMieOLV3vBpGdJJnJhZ+4XeOoRWiThtw0KmfiqUCP9T2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763619891; c=relaxed/simple;
	bh=aACPGRVkqaH1oQa+8g5OVYAMyLjF6z29dLx9YwvlBwU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=STlHaXMDKbmHE21//rJjUGfa5taxS3tEKPVd3bIUjjcaU9gsOH62D00JMSVNu1abpZp2FdYjVmcrOhoK1J2tSdTy7TPutJaJzQUAEd9TyfcTbswLp3L5UeOJKUM+cjL+17P9laxLXQabW1/b0ZXzlJjpu0H28VYGQonfcFpvJw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q7um5342; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763619890; x=1795155890;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aACPGRVkqaH1oQa+8g5OVYAMyLjF6z29dLx9YwvlBwU=;
  b=Q7um5342Ef1WNa1jsHDn4dUgY44DI1TpxVDAdOwP9AzqxdyxxZP1V9th
   Y5esRiwuT1awVF4xTM5/CuxWSmd7JuHlMLTWCpWtNmEtZv4zjdBEP2uo0
   pcRbdL4/Z2ma3JY/F4XM+wXzIx6rZ8gs/yW6OMRe54sG3HCIwasDA6Ts8
   IV8e8KLHR1P8Z+HqLrH6FKCJmIJhWNpOgtS9D1ZHm4JWY9hgq3rkduXch
   xVmOexgbp2t1V98atnL2g9KTn5Jqv8cq7bGEpe5ANvOeHtWL5dQF/rIGD
   VLLO3hFY6AVajpMYyrpWFXtkpzfvKZ66Xe2yy1/yiJWvYSE1WpMoGeew4
   Q==;
X-CSE-ConnectionGUID: 9hz4fPhaQOKPmJ43BY2xWQ==
X-CSE-MsgGUID: DB1l4j0RS4yxj1nY748BTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="65555069"
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="65555069"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 22:24:49 -0800
X-CSE-ConnectionGUID: nK6wBS+QRSOwdw3pTDHSAg==
X-CSE-MsgGUID: a62DbDRRSNWSCYYiFuyovg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="221919659"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa002.jf.intel.com with ESMTP; 19 Nov 2025 22:24:46 -0800
Date: Thu, 20 Nov 2025 14:09:55 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-coco@lists.linux.dev, linux-pci@vger.kernel.org,
	chao.gao@intel.com, dave.jiang@intel.com, baolu.lu@linux.intel.com,
	yilun.xu@intel.com, zhenzhong.duan@intel.com, kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com, dave.hansen@linux.intel.com,
	dan.j.williams@intel.com, kas@kernel.org, x86@kernel.org
Subject: Re: [PATCH v1 08/26] x86/virt/tdx: Add tdx_enable_ext() to enable of
 TDX Module Extensions
Message-ID: <aR6ws2yzwQumApb9@yilunxu-OptiPlex-7050>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
 <20251117022311.2443900-9-yilun.xu@linux.intel.com>
 <cfcfb160-fcd2-4a75-9639-5f7f0894d14b@intel.com>
 <aRyphEW2jpB/3Ht2@yilunxu-OptiPlex-7050>
 <62bec236-4716-4326-8342-1863ad8a3f24@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62bec236-4716-4326-8342-1863ad8a3f24@intel.com>

On Tue, Nov 18, 2025 at 10:32:13AM -0800, Dave Hansen wrote:
> On 11/18/25 09:14, Xu Yilun wrote:
> ....>>> The extension initialization uses the new TDH.EXT.MEM.ADD and
> >>> TDX.EXT.INIT seamcalls. TDH.EXT.MEM.ADD add pages to a shared memory
> >>> pool for extensions to consume.
> >>
> >> "Shared memory" is an exceedingly unfortunate term to use here. They're
> >> TDX private memory, right?
> > 
> > Sorry, they are indeed TDX private memory. Here 'shared' means the
> > memory in the pool will be consumed by multiple new features but this
> > is TDX Module internal details that I should not ramble, especially in
> > TDX context.
> ... and you'll find a better term in the next revision. Right?

Yes, I think just "memory pool" is enough.

> 
> ...>> How much memory does this consume?
> > 
> > 12800 pages.
> 
> Oof. That's more than I expected and it's also getting up to the amount
> that you don't want to just eat without saying seomthing about it.
> 
> Could you please at least dump a pr_info() out about how much memory
> this consumes?

Sure.

> 
> >>> TDH.EXT.MEM.ADD is the first user of tdx_page_array. It provides pages
> >>> to TDX Module as control (private) pages. A tdx_clflush_page_array()
> >>> helper is introduced to flush shared cache before SEAMCALL, to avoid
> >>> shared cache write back damages these private pages.
> >>
> >> First, this talks about "control pages". But I don't know what a control
> >> page is.
> > 
> > It refers to pages provided to TDX Module to hold all kinds of control
> > structures or metadata. E.g. TDR, TDCS, TDVPR... With TDX Connect we
> > have more, SPDM metadata, IDE metadata...
> 
> Please *say* that. Explain how existing TDX metadata consumes memory and
> how this new mechanism is different.

Yes.

Existing ways to provide an array of metadata pages to TDX Module
varies:

 1. Assign each HPA for each SEAMCALL register.
 2. Call the same seamcall multiple times.
 3. Assign the PA of HPA-array in one register and the page number in
    another register.

TDX Module defines new interfaces trying to unify the page array
provision. It is similar to the 3rd method. The new objects HPA_ARRAY_T
and HPA_LIST_INFO need a 'root page' which contains a list of HPAs.
They collapse the HPA of the root page and the number of valid HPAs
into a 64 bit raw value for one SEAMCALL parameter.

I think these words should be in:

  x86/virt/tdx: Add tdx_page_array helpers for new TDX Module objects
> 
> BTW... Do you see how I'm trimming context as I reply? Could you please
> endeavor to do the same?

Yes.

> 
> >>> @@ -1251,7 +1254,14 @@ static __init int config_tdx_module(struct tdmr_info_list *tdmr_list,
> >>>  	args.rcx = __pa(tdmr_pa_array);
> >>>  	args.rdx = tdmr_list->nr_consumed_tdmrs;
> >>>  	args.r8 = global_keyid;
> >>> -	ret = seamcall_prerr(TDH_SYS_CONFIG, &args);
> >>> +
> >>> +	if (tdx_sysinfo.features.tdx_features0 & TDX_FEATURES0_TDXCONNECT) {
> >>> +		args.r9 |= TDX_FEATURES0_TDXCONNECT;
> >>> +		args.r11 = ktime_get_real_seconds();
> >>> +		ret = seamcall_prerr(TDH_SYS_CONFIG | (1ULL << TDX_VERSION_SHIFT), &args);
> >>> +	} else {
> >>> +		ret = seamcall_prerr(TDH_SYS_CONFIG, &args);
> >>> +	}
> >>
> >> I'm in the first actual hunk of code and I'm lost. I don't have any idea
> >> what the "(1ULL << TDX_VERSION_SHIFT)" is doing.
> > 
> > TDX Module defines the version field in its leaf to specify updated
> > parameter set. The existing user is:
> > 
> > u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid)
> > {
> > 	struct tdx_module_args args = {
> > 		.rcx = vp->tdvpr_pa,
> > 		.rdx = initial_rcx,
> > 		.r8 = x2apicid,
> > 	};
> > 
> > 	/* apicid requires version == 1. */
> > 	return seamcall(TDH_VP_INIT | (1ULL << TDX_VERSION_SHIFT), &args);
> > }
> 
> OK, so there's a single existing user with this thing open coded.
> 
> You're adding a second user, so you just copied and pasted the existing
> code. Is there a better way to do this? For instance, can we just pass
> the version number to *ALL* seamcall()s?

I think it may be too heavy. We have a hundred SEAMCALLs and I expect
few needs version 1. I actually think v2 is nothing different from a new
leaf. How about something like:

--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -46,6 +46,7 @@
 #define TDH_PHYMEM_PAGE_WBINVD         41
 #define TDH_VP_WR                      43
 #define TDH_SYS_CONFIG                 45
+#define TDH_SYS_CONFIG_V1              (TDH_SYS_CONFIG | (1ULL << TDX_VERSION_SHIFT))

And if a SEAMCALL needs export, add new tdh_foobar() helper. Anyway
the parameter list should be different.

> 
> 
> 
> ...>> This is really difficult to understand. It's not really filling a
> >> "root", it's populating an array. The structure of the loop is also
> > 
> > It is populating the root page with part (512 pages at most) of the array.
> > So is it better name the function tdx_page_array_populate_root()?
> 
> That's getting a bit verbose.

tdx_page_array_populate()

> 
> >> rather non-obvious. It's doing:
> >>
> >> 	while (1) {
> >> 		fill(&array);
> >> 		tell_tdx_module(&array);
> >> 	}
> > 
> > There is some explanation in Patch #6:
> 
> That doesn't really help me, or future reviewers.
> 
> >  4. Note the root page contains 512 HPAs at most, if more pages are
> >    required, refilling the tdx_page_array is needed.
> > 
> >  - struct tdx_page_array *array = tdx_page_array_alloc(nr_pages);
> >  - for each 512-page bulk
> >    - tdx_page_array_fill_root(array, offset);
> >    - seamcall(TDH_XXX_ADD, array, ...);
> 
> Great! That is useful information to have here, in the code.
> 
> >> Why can't it be:
> >>
> >> 	while (1)
> >> 		fill(&array);
> >> 	while (1)
> >> 		tell_tdx_module(&array);
> > 
> > The consideration is, no need to create as much supporting
> > structures (struct tdx_page_array *, struct page ** and root page) for
> > each 512-page bulk. Use one and re-populate it in loop is efficient.
> 
> Huh? What is it efficient for? Are you saving a few pages of _temporary_
> memory?

In this case yes, cause no way to reclaim TDX Module EXT required pages.
But when reclaimation is needed, will hold these supporting structures
long time.

Also I want the tdx_page_array object itself not been restricted by 512
pages, so tdx_page_array users don't have to manage an array of array.

> 
> I'm not following at all.
> 
> >>> +static int init_tdx_ext(void)
> >>> +{
> >>> +	int ret;
> >>> +
> >>> +	if (!(tdx_sysinfo.features.tdx_features0 & TDX_FEATURES0_EXT))
> >>> +		return -EOPNOTSUPP;
> >>> +
> >>> +	struct tdx_page_array *mempool __free(tdx_ext_mempool_free) =
> >>> +		tdx_ext_mempool_setup();
> >>> +	/* Return NULL is OK, means no need to setup mempool */
> >>> +	if (IS_ERR(mempool))
> >>> +		return PTR_ERR(mempool);
> >>
> >> That's a somewhat odd comment to put above an if() that doesn't return NULL.
> > 
> > I meant to explain why using IS_ERR instead of IS_ERR_OR_NULL. I can
> > impove the comment.
> 
> I'd kinda rather the code was improved. Why cram everything into a
> pointer if you don't need to. This would be just fine, no?
> 
> 	ret = tdx_ext_mempool_setup(&mempool);
> 	if (ret)
> 		return ret;

It's good.

The usage of pointer is still about __free(). In order to auto-free
something, we need an object handler for something. I think this is a
more controversial usage of __free() than pure allocation. We setup
something and want auto-undo something on failure.

Thanks,
Yilun

