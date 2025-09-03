Return-Path: <kvm+bounces-56683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A220B41CEB
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 13:19:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0456617507F
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 11:19:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCB0C2F618F;
	Wed,  3 Sep 2025 11:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nHqnw+LI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D6D27A476;
	Wed,  3 Sep 2025 11:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756898385; cv=none; b=Ybr1WhxsseKn5avspQTPui/xQP8o+IQJKETNhoqaz+P6Pb50rs/2oinLW0OKRXNcOUwZg47RajgMeftrnT0FTfoJ4aCg9o46DJlFl5Ziy0zjSP1zMquHBgP/Svf5QIPZAZhdGTOvIMlJ0Lwy3L5IW9fqraMgY5iyQRVgE3841W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756898385; c=relaxed/simple;
	bh=Hhu23ZKM03iRMG9GrOYxaRgeFHhng4bMn3jUd+Yr/Tw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q/u3OsWobrP4NwK+2Un9iG6UHt9mnICm5D/grxq//DleQp66nCB+HCLkwk1yaFE4pVD1UibHJXJWvzojmjBm3I1EU/hzVgrNYWKRlqe9Kk+6GZAjOE5XIFzPJmrXBaZJBgGz2wiPvtBEpGPhGr2ZRIDQqpAqaKqpBTy2QqTLVdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nHqnw+LI; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756898383; x=1788434383;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Hhu23ZKM03iRMG9GrOYxaRgeFHhng4bMn3jUd+Yr/Tw=;
  b=nHqnw+LIp0AuCFmPClCrgjyid5lAVVNmO/Hqw8JHqgyQRP05npY8Ivsb
   exeopVgf5yrpp1tiKr4/JsxgN5vw8C72EkGfmIBYt4dhljqaoTT1B9qTv
   BeugwK1Qpqn1+445do48LcyHX5h6yEVGdGGhdTr5qmUjvA0YYvj/bp8bi
   LtATwKDJvoQiVwbj+L3nk3Tgum8MSjDyBQWxM6ysq/k5DFsoAZEWNogOG
   x0kI1YUdcKL/itsFcfkI6C/fZw+w9gMy2evmh4Wl3hv8erYMu4/ob4zVm
   i2dE6T8o7dkNAts00vP7DFpRjcHOuz272DI0zuWAhxMGxU94cNWh813SH
   Q==;
X-CSE-ConnectionGUID: VHmHla/PQui+K/CiWSbSQQ==
X-CSE-MsgGUID: TZFlqZO1QmWMl3z98S1jjg==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="70585862"
X-IronPort-AV: E=Sophos;i="6.18,235,1751266800"; 
   d="scan'208";a="70585862"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 04:19:42 -0700
X-CSE-ConnectionGUID: oI7RqsbTRlOg+UjuWab8Jg==
X-CSE-MsgGUID: VVJ9CYNzT2G8Jl44rq7Shw==
X-ExtLoop1: 1
Received: from junyubia-mobl1.ccr.corp.intel.com (HELO [10.124.233.111]) ([10.124.233.111])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 04:19:36 -0700
Message-ID: <a42dae7e-4608-4488-9621-0cf32b68dfbc@linux.intel.com>
Date: Wed, 3 Sep 2025 19:19:32 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 04/23] KVM: TDX: Introduce tdx_clear_folio() to
 clear huge pages
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
 <20250807094214.4495-1-yan.y.zhao@intel.com>
 <04d6d306-b495-428f-ac3a-44057fd6ccfc@linux.intel.com>
 <aLgPsZ6PxGVqmeZl@yzhao56-desk.sh.intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <aLgPsZ6PxGVqmeZl@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/3/2025 5:51 PM, Yan Zhao wrote:
> On Tue, Sep 02, 2025 at 10:56:25AM +0800, Binbin Wu wrote:
>>
>> On 8/7/2025 5:42 PM, Yan Zhao wrote:
>>> After removing or reclaiming a guest private page or a control page from a
>>> TD, zero the physical page using movdir64b(), enabling the kernel to reuse
>>> the pages.
>>>
>>> Introduce the function tdx_clear_folio() to zero out physical memory using
>>> movdir64b(), starting from the page at "start_idx" within a "folio" and
>>> spanning "npages" contiguous PFNs.
>>>
>>> Convert tdx_clear_page() to be a helper function to facilitate the
>>> zeroing of 4KB pages.
>> I think this sentence is outdated?
> No? tdx_clear_page() is still invoked to clear tdr_page.

I didn't get the word "Convert".

>
>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>>> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
>>> ---
>>> RFC v2:
>>> - Add tdx_clear_folio().
>>> - Drop inner loop _tdx_clear_page() and move __mb() outside of the loop.
>>>     (Rick)
>>> - Use C99-style definition of variables inside a for loop.
>>> - Note: [1] also changes tdx_clear_page(). RFC v2 is not based on [1] now.
>>>
>>> [1] https://lore.kernel.org/all/20250724130354.79392-2-adrian.hunter@intel.com
>>>
>>> RFC v1:
>>> - split out, let tdx_clear_page() accept level.
>>> ---
>>>    arch/x86/kvm/vmx/tdx.c | 22 ++++++++++++++++------
>>>    1 file changed, 16 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>>> index 8eaf8431c5f1..4fabefb27135 100644
>>> --- a/arch/x86/kvm/vmx/tdx.c
>>> +++ b/arch/x86/kvm/vmx/tdx.c
>>> @@ -277,18 +277,21 @@ static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
>>>    	vcpu->cpu = -1;
>>>    }
>>> -static void tdx_clear_page(struct page *page)
>>> +static void tdx_clear_folio(struct folio *folio, unsigned long start_idx,
>>> +			    unsigned long npages)
>>>    {
>>>    	const void *zero_page = (const void *) page_to_virt(ZERO_PAGE(0));
>>> -	void *dest = page_to_virt(page);
>>> -	unsigned long i;
>>>    	/*
>>>    	 * The page could have been poisoned.  MOVDIR64B also clears
>>>    	 * the poison bit so the kernel can safely use the page again.
>>>    	 */
>>> -	for (i = 0; i < PAGE_SIZE; i += 64)
>>> -		movdir64b(dest + i, zero_page);
>>> +	for (unsigned long j = 0; j < npages; j++) {
>>> +		void *dest = page_to_virt(folio_page(folio, start_idx + j));
>>> +
>>> +		for (unsigned long i = 0; i < PAGE_SIZE; i += 64)
>>> +			movdir64b(dest + i, zero_page);
>>> +	}
>>>    	/*
>>>    	 * MOVDIR64B store uses WC buffer.  Prevent following memory reads
>>>    	 * from seeing potentially poisoned cache.
>>> @@ -296,6 +299,13 @@ static void tdx_clear_page(struct page *page)
>>>    	__mb();
>>>    }
>>> +static inline void tdx_clear_page(struct page *page)
>> No need to tag a local static function with "inline".
> Ok.
>


