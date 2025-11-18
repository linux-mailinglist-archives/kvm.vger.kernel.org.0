Return-Path: <kvm+bounces-63585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id E5901C6B38D
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 19:33:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DC81A4E386C
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 18:33:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D0372D4811;
	Tue, 18 Nov 2025 18:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d23Wj7YQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94C71F463E;
	Tue, 18 Nov 2025 18:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763490791; cv=none; b=UT8hKQTGVnJh7WYcmghGYA/oErtAXVrW7aERch+hSpj4X4pFdMy3GtV/MJZjVrKBxR8NBr69+FmLRDCf7W6UVOJQHF+aWgBtrWcyprwo0D+CyAYHXypZelyTFFSAQfYprRfiyinGKNT46Axj80I3wwWpwv7cfD5rhPoCBsvYCvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763490791; c=relaxed/simple;
	bh=oFp7Ht22PPUOh7/5jmB3tdowm7xKcV8JqdKM5rlq1w4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p1Ccppi7IurPwtbW94fbvxhgBrGN6HaRErEyZhmSiLZGbz7Vrz4CcWF68hPCLmav+fJmLYWTxciZYpHqVbm5OKvKj/DiXCaYCbmPiVvLNvTFZ2F/0kpg44vz7Uqc/fNWcdHPiBwmdwz+vStBtesaC12X57mgUJG6hFBINOD54k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d23Wj7YQ; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763490790; x=1795026790;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oFp7Ht22PPUOh7/5jmB3tdowm7xKcV8JqdKM5rlq1w4=;
  b=d23Wj7YQYGo4W+k3aaTclqty+YAiLTaXum3ebdWFr2lUwWNddGHp66T7
   a514IsW3Dx51EQ28w2GKNDt0XcX4cjIdK6WzdlRzev7tcSz+j34hU4kJi
   Db/UVLrhyFZkWIYueVCZOrOsyA99kVuakZzZBLxnPIDFR4JtaC1cd38Xg
   fLQ+HUifunA2gSufRzmife72cG3SAfnonVab+oulWbbnmgyqSaV85Yg3L
   +kgqw9xyWLffVdPo1J7qy5uToEc3t7RUmdZZ/9hzWvWGiJz+Hj7xk8tei
   WhW3e7AvK2Xh/5U3T4ilbfDNMXuz3SYOo2miAPeXLWzgtcaytsji6u7j7
   w==;
X-CSE-ConnectionGUID: FQa2dRXiSC+wYSKgs26q4w==
X-CSE-MsgGUID: uIMakv9FR9K+ALuFsSNJ6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="65683105"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="65683105"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 10:32:15 -0800
X-CSE-ConnectionGUID: cd/Mj0+5TSeZ7Q+fNCuX5A==
X-CSE-MsgGUID: NDjD6f09S9WLT+etscKxVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="195141541"
Received: from dwoodwor-mobl2.amr.corp.intel.com (HELO [10.125.109.119]) ([10.125.109.119])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 10:32:15 -0800
Message-ID: <62bec236-4716-4326-8342-1863ad8a3f24@intel.com>
Date: Tue, 18 Nov 2025 10:32:13 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 08/26] x86/virt/tdx: Add tdx_enable_ext() to enable of
 TDX Module Extensions
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: linux-coco@lists.linux.dev, linux-pci@vger.kernel.org,
 chao.gao@intel.com, dave.jiang@intel.com, baolu.lu@linux.intel.com,
 yilun.xu@intel.com, zhenzhong.duan@intel.com, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, dave.hansen@linux.intel.com,
 dan.j.williams@intel.com, kas@kernel.org, x86@kernel.org
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
 <20251117022311.2443900-9-yilun.xu@linux.intel.com>
 <cfcfb160-fcd2-4a75-9639-5f7f0894d14b@intel.com>
 <aRyphEW2jpB/3Ht2@yilunxu-OptiPlex-7050>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <aRyphEW2jpB/3Ht2@yilunxu-OptiPlex-7050>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/18/25 09:14, Xu Yilun wrote:
....>>> The extension initialization uses the new TDH.EXT.MEM.ADD and
>>> TDX.EXT.INIT seamcalls. TDH.EXT.MEM.ADD add pages to a shared memory
>>> pool for extensions to consume.
>>
>> "Shared memory" is an exceedingly unfortunate term to use here. They're
>> TDX private memory, right?
> 
> Sorry, they are indeed TDX private memory. Here 'shared' means the
> memory in the pool will be consumed by multiple new features but this
> is TDX Module internal details that I should not ramble, especially in
> TDX context.
... and you'll find a better term in the next revision. Right?

...>> How much memory does this consume?
> 
> 12800 pages.

Oof. That's more than I expected and it's also getting up to the amount
that you don't want to just eat without saying seomthing about it.

Could you please at least dump a pr_info() out about how much memory
this consumes?

>>> TDH.EXT.MEM.ADD is the first user of tdx_page_array. It provides pages
>>> to TDX Module as control (private) pages. A tdx_clflush_page_array()
>>> helper is introduced to flush shared cache before SEAMCALL, to avoid
>>> shared cache write back damages these private pages.
>>
>> First, this talks about "control pages". But I don't know what a control
>> page is.
> 
> It refers to pages provided to TDX Module to hold all kinds of control
> structures or metadata. E.g. TDR, TDCS, TDVPR... With TDX Connect we
> have more, SPDM metadata, IDE metadata...

Please *say* that. Explain how existing TDX metadata consumes memory and
how this new mechanism is different.

BTW... Do you see how I'm trimming context as I reply? Could you please
endeavor to do the same?

>>> @@ -1251,7 +1254,14 @@ static __init int config_tdx_module(struct tdmr_info_list *tdmr_list,
>>>  	args.rcx = __pa(tdmr_pa_array);
>>>  	args.rdx = tdmr_list->nr_consumed_tdmrs;
>>>  	args.r8 = global_keyid;
>>> -	ret = seamcall_prerr(TDH_SYS_CONFIG, &args);
>>> +
>>> +	if (tdx_sysinfo.features.tdx_features0 & TDX_FEATURES0_TDXCONNECT) {
>>> +		args.r9 |= TDX_FEATURES0_TDXCONNECT;
>>> +		args.r11 = ktime_get_real_seconds();
>>> +		ret = seamcall_prerr(TDH_SYS_CONFIG | (1ULL << TDX_VERSION_SHIFT), &args);
>>> +	} else {
>>> +		ret = seamcall_prerr(TDH_SYS_CONFIG, &args);
>>> +	}
>>
>> I'm in the first actual hunk of code and I'm lost. I don't have any idea
>> what the "(1ULL << TDX_VERSION_SHIFT)" is doing.
> 
> TDX Module defines the version field in its leaf to specify updated
> parameter set. The existing user is:
> 
> u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid)
> {
> 	struct tdx_module_args args = {
> 		.rcx = vp->tdvpr_pa,
> 		.rdx = initial_rcx,
> 		.r8 = x2apicid,
> 	};
> 
> 	/* apicid requires version == 1. */
> 	return seamcall(TDH_VP_INIT | (1ULL << TDX_VERSION_SHIFT), &args);
> }

OK, so there's a single existing user with this thing open coded.

You're adding a second user, so you just copied and pasted the existing
code. Is there a better way to do this? For instance, can we just pass
the version number to *ALL* seamcall()s?



...>> This is really difficult to understand. It's not really filling a
>> "root", it's populating an array. The structure of the loop is also
> 
> It is populating the root page with part (512 pages at most) of the array.
> So is it better name the function tdx_page_array_populate_root()?

That's getting a bit verbose.

>> rather non-obvious. It's doing:
>>
>> 	while (1) {
>> 		fill(&array);
>> 		tell_tdx_module(&array);
>> 	}
> 
> There is some explanation in Patch #6:

That doesn't really help me, or future reviewers.

>  4. Note the root page contains 512 HPAs at most, if more pages are
>    required, refilling the tdx_page_array is needed.
> 
>  - struct tdx_page_array *array = tdx_page_array_alloc(nr_pages);
>  - for each 512-page bulk
>    - tdx_page_array_fill_root(array, offset);
>    - seamcall(TDH_XXX_ADD, array, ...);

Great! That is useful information to have here, in the code.

>> Why can't it be:
>>
>> 	while (1)
>> 		fill(&array);
>> 	while (1)
>> 		tell_tdx_module(&array);
> 
> The consideration is, no need to create as much supporting
> structures (struct tdx_page_array *, struct page ** and root page) for
> each 512-page bulk. Use one and re-populate it in loop is efficient.

Huh? What is it efficient for? Are you saving a few pages of _temporary_
memory?

I'm not following at all.

>>> +static int init_tdx_ext(void)
>>> +{
>>> +	int ret;
>>> +
>>> +	if (!(tdx_sysinfo.features.tdx_features0 & TDX_FEATURES0_EXT))
>>> +		return -EOPNOTSUPP;
>>> +
>>> +	struct tdx_page_array *mempool __free(tdx_ext_mempool_free) =
>>> +		tdx_ext_mempool_setup();
>>> +	/* Return NULL is OK, means no need to setup mempool */
>>> +	if (IS_ERR(mempool))
>>> +		return PTR_ERR(mempool);
>>
>> That's a somewhat odd comment to put above an if() that doesn't return NULL.
> 
> I meant to explain why using IS_ERR instead of IS_ERR_OR_NULL. I can
> impove the comment.

I'd kinda rather the code was improved. Why cram everything into a
pointer if you don't need to. This would be just fine, no?

	ret = tdx_ext_mempool_setup(&mempool);
	if (ret)
		return ret;



