Return-Path: <kvm+bounces-58628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 25828B9900F
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 10:57:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 431EB189B7CB
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 08:57:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F4D92D0C9B;
	Wed, 24 Sep 2025 08:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gfPW3Vlz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13122557A;
	Wed, 24 Sep 2025 08:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758704242; cv=none; b=jJKhZGjBTVENyxID+A4eL6pTWz4wdgcXONnP57CIZWnsvcVkCi0/6aAzvqW8FcYOvTz0h9GlVRe1aNf8DCBESHupSaonbz98NAceTBnPQkd110ZqeWqWioENaTasGqnii7XI6Jxqln/CDeAY1AEXiA8W9BXvfPqi9UK/+a4EEMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758704242; c=relaxed/simple;
	bh=kvkpUlFHOMa5WGOYjzBXAHR8vBGu8aMkOK8bYu8QwYI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lc6DD3L5/E3CiYBAzvYRRdxSlWjZ+cmmbcKTcHwDk/MQLB2f9gvqZxbM018svPPAZqa+UhBoqaxY/kfSj24lHaT6jlM2BdbT2xImu7bE0ZFmNEWFmPkE4BdcLaaN7zbQP0a/sz67P1NduDaPN+I1aIdNCD2FWkPYpunuCDR4KRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gfPW3Vlz; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758704240; x=1790240240;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kvkpUlFHOMa5WGOYjzBXAHR8vBGu8aMkOK8bYu8QwYI=;
  b=gfPW3VlzO8viLrEAEJ9DbdbPzzNToG3WpiFfrxaJuYwJRthp0TFwWA1h
   Fpnc68QoAhPZV3Dh7I9PxyyHlq3OMoRuDJTr0CsoHuTSZxsO0p+c7J04G
   rQOMgGmgfPCnsDbnLFivtwVtV0wTeWv0h5C5OzeXhnIXVq4/sTxKwK7b8
   Jz3MXjXYUvUERMgFI1WRyemsxCDnKY5V+dG1NYI9WfkPPleoY/LzDrN8o
   8WWoST4zdb1CAlnSyJA48akL4g4lYj3XhIF/+D9+Tj2hVPnRV7wp7/+9v
   C7ESXpqgkIwMR2Q2YURzvu1d5em1pw1jSYzkdLgzkcwCZY1pXhJ0okFqA
   Q==;
X-CSE-ConnectionGUID: B1YraC4qQpOMrIbzl3jfPQ==
X-CSE-MsgGUID: 80vPEZbVSS28xurH0Lknwg==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="61166405"
X-IronPort-AV: E=Sophos;i="6.18,290,1751266800"; 
   d="scan'208";a="61166405"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 01:57:20 -0700
X-CSE-ConnectionGUID: 9dz6sw87TnCEgt1/+f18CA==
X-CSE-MsgGUID: F/TN14jWRIeSgK593yRD2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,290,1751266800"; 
   d="scan'208";a="177381649"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 01:57:16 -0700
Message-ID: <19889f85-cfd0-4283-bd32-935ef92b3b93@linux.intel.com>
Date: Wed, 24 Sep 2025 16:57:14 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/16] x86/virt/tdx: Improve PAMT refcounters
 allocation for sparse memory
To: "Huang, Kai" <kai.huang@intel.com>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
 "seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
 <mingo@redhat.com>, "kas@kernel.org" <kas@kernel.org>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Annapurve, Vishal" <vannapurve@google.com>, "Gao, Chao"
 <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>,
 "x86@kernel.org" <x86@kernel.org>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
 <20250918232224.2202592-7-rick.p.edgecombe@intel.com>
 <f1018ab125eb18f431ddb3dd50501914b396ee2b.camel@intel.com>
 <e455cb2c-a51c-494e-acc1-12743c4f4d3f@linux.intel.com>
 <7ad102d6105b6244c32e0daebcdb2ac46a5dcc68.camel@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <7ad102d6105b6244c32e0daebcdb2ac46a5dcc68.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 9/24/2025 2:50 PM, Huang, Kai wrote:
> On Tue, 2025-09-23 at 17:38 +0800, Binbin Wu wrote:
>>>> +/*
>>>> + * Allocate PAMT reference counters for the given PFN range.
>>>> + *
>>>> + * It consumes 2MiB for every 1TiB of physical memory.
>>>> + */
>>>> +static int alloc_pamt_refcount(unsigned long start_pfn, unsigned long end_pfn)
>>>> +{
>>>> +	unsigned long start, end;
>>>> +
>>>> +	start = (unsigned long)tdx_find_pamt_refcount(PFN_PHYS(start_pfn));
>>>> +	end   = (unsigned long)tdx_find_pamt_refcount(PFN_PHYS(end_pfn + 1));
>>> (sorry didn't notice this in last version)
>>>
>>> I don't quite follow why we need "end_pfn + 1" instead of just "end_pfn"?
>>>
>>> IIUC this could result in an additional 2M range being populated
>>> unnecessarily when the end_pfn is 2M aligned.
>> IIUC, this will not happen.
>> The +1 page will be converted to 4KB, and will be ignored since in
>> tdx_find_pamt_refcount() the address is divided by 2M.
>>
>> To handle the address unaligned to 2M, +511 should be used instead of +1?
> OK. Thanks for catching.  But I still don't get why we need end_pfn + 1.
>
> Also, when end_pfn == 511, would this result in the second refcount being
> returned for the @end, while the intention should be the first refcount?
>
> For example, assuming we have a range [0, 2M), we only need one refcount.
> And the PFN range (which comes from for_each_mem_pfn_range()) would be:
>
>      start_pfn == 0
>      end_pfn   == 512
>
> This will results in @start pointing to the first refcount and @end
> pointing to the second, IIUC.
>
> So it seems we need:
>
>      start = (unsigned long)tdx_find_pamt_refcount(PFN_PHYS(start_pfn));
>      end   = (unsigned long)tdx_find_pamt_refcount(PFN_PHYS(end_pfn) - 1));
>      start = round_down(start, PAGE_SIZE);
>      end   = round_up(end, PAGE_SIZE);

Checked again, this seems to be the right version.

>
> ?


