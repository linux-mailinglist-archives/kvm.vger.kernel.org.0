Return-Path: <kvm+bounces-25516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 31B5A966141
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 14:03:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 559EF1C23CCD
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 12:03:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC290199953;
	Fri, 30 Aug 2024 12:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vj4Yt8EH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7CC1917C8;
	Fri, 30 Aug 2024 12:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725019394; cv=none; b=NAG8r+2h6Q5DrxWpe4I4YlnnByB+KCUu12q1ns1k6y6l583Cg8H9lGHUuxYv3rGSpucGtwyL9bcLyKbULaiHKC/UHiCKDF/B4Y7aSqzp6tq0ssQ1mNu154NpUucpwx3i4OnfQ5tEWVOF2ZuMvFKgMm1zXjPoP08paqmWXuA5Ug8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725019394; c=relaxed/simple;
	bh=NyudRBgFddMQV+jTgCFN57acmB1oqUCZ/XhL5iACqJU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y7ZAgQ8QWYi/GB7iwp+L9BXkbO0TpOJfHuulgD89pAqZFPOYK+wRVWUsNG/PAlKjnnkvPXCqtcQmkEVSRtcypN+fTLX02t6vuNmD6JIBsiDqjgFjX+EIeak51m5HE+v8awioocmuoC/LadgGryCgBw5nNtIory7StyJvEZF9Pis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vj4Yt8EH; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725019392; x=1756555392;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NyudRBgFddMQV+jTgCFN57acmB1oqUCZ/XhL5iACqJU=;
  b=Vj4Yt8EHQs3KHRRsX+hY2Ndy3gH3TsHrc2imwNtKL5SwNSi78wmpgJaJ
   tgOgiLTdyQD2AL1jLuebJWSnLB+yrq3mgb2ijmJOyeq5cu571jcivz9A6
   NhzS2UPawBWp+crWS/iNS3aqi2OdeATolQSsW0Cc2PZZhUv0AQ1A7ZQb/
   k9ADcrsXh8CH+DPvL9/izHqmKgzCbudfRUvwGxBIlxT/z1pyUc/IRQaMI
   JeaYi8VUKtdRoNDI82IXdGI6LiRrbJKMfEqtaXwq0uL03qL5ZbyG8YdRh
   gfvjQ98WU96J7ImCpFPvGdLh03hLdM8XlYrmOjBjmrrw26QwvjjOVYFp2
   w==;
X-CSE-ConnectionGUID: dJdh5wxcT82iz11l1raJQg==
X-CSE-MsgGUID: 7DBVah/CTGGE315mRJ5VEQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="27452147"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="27452147"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 05:03:11 -0700
X-CSE-ConnectionGUID: owpYIVFtQg6Buw0JThfTTA==
X-CSE-MsgGUID: raV8ypFWRDSsVavxyZWQHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="101387138"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.245.96.163])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 05:03:05 -0700
Message-ID: <a8a14103-80a3-4b03-a214-f55429c46f93@intel.com>
Date: Fri, 30 Aug 2024 15:02:58 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/8] x86/virt/tdx: Reduce TDMR's reserved areas by
 using CMRs to find memory holes
To: "Huang, Kai" <kai.huang@intel.com>, "Hansen, Dave"
 <dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>,
 "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
 <peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "mingo@redhat.com" <mingo@redhat.com>,
 "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "Gao, Chao" <chao.gao@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "Yamahata, Isaku"
 <isaku.yamahata@intel.com>
References: <cover.1724741926.git.kai.huang@intel.com>
 <9b55398a1537302fb7135330dba54e79bfabffb1.1724741926.git.kai.huang@intel.com>
 <4b30520d-f3fa-4806-9d58-176adb8791a6@intel.com>
 <2c8087136424fd5a63a183046f114ac01584c3c4.camel@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <2c8087136424fd5a63a183046f114ac01584c3c4.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 30/08/24 14:52, Huang, Kai wrote:
> On Fri, 2024-08-30 at 13:50 +0300, Hunter, Adrian wrote:
>> On 27/08/24 10:14, Kai Huang wrote:
>>> A TDX module initialization failure was reported on a Emerald Rapids
>>> platform:
>>>
>>>   virt/tdx: initialization failed: TDMR [0x0, 0x80000000): reserved areas exhausted.
>>>   virt/tdx: module initialization failed (-28)
>>>
>>> As part of initializing the TDX module, the kernel informs the TDX
>>> module of all "TDX-usable memory regions" using an array of TDX defined
>>> structure "TD Memory Region" (TDMR).  Each TDMR must be in 1GB aligned
>>> and in 1GB granularity, and all "non-TDX-usable memory holes" within a
>>> given TDMR must be marked as "reserved areas".  The TDX module reports a
>>> maximum number of reserved areas that can be supported per TDMR.
>>
>> The statement:
>>
>>       ... all "non-TDX-usable memory holes" within a
>>       given TDMR must be marked as "reserved areas".
>>
>> is not exactly true, which is essentially the basis of this fix.
> 
> Hmm I think I see what you mean.  Perhaps the "must be marked as" confuses
> you?
> 
> The "TDX-usable memory" here means all pages that can potentially be used by
> TDX.  They don't have to be actually used by TDX, i.e., "TDX-usable memory" vs
> "TDX-used memory".
> 
> And the "non-TDX-usable memory holes" means the memory regions that cannot be
> possibly used by TDX at all.
> 
> Is below better if I change "must be marked as" to "are"?
> 
>   As part of initializing the TDX module, the kernel informs the TDX
>   module of all "TDX-usable memory regions" using an array of TDX defined
>   structure "TD Memory Region" (TDMR).  Each TDMR must be in 1GB aligned
>   and in 1GB granularity, and all "non-TDX-usable memory holes" within a
>   given TDMR are marked as "reserved areas".  The TDX module reports a
>   maximum number of reserved areas that can be supported per TDMR.

Yes, that's better.

> 
> Note in my logic here we don't need to mention CMR.  Here I just want to tell
> the fact that each TDMR has number of "reserved areas" and the maximum number
> is reported by TDX module.
> 
>>
>> The relevant requirements are (from the spec):
>>
>>   Any non-reserved 4KB page within a TDMR must be convertible
>>   i.e., it must be within a CMR
> 
> Yes.
> 
>>
>>   Reserved areas within a TDMR need not be within a CMR.
> 
> Yes.  They need not to be, but they can be.
> 
>>
>>   PAMT areas must not overlap with TDMR non-reserved areas;
>>   however, they may reside within TDMR reserved areas
>>   (as long as these are convertible).
> 
> Yes.  However in implementation PAMTs are out of page allocator so they are
> all within TDMRs thus need to be put to reserved areas.
> 
> Those are TDX architectural requirements.  They are not all related to the fix
> of this problem.  The most important thing here is:
> 
>   Any non-reserved memory within a TDMR must be within CMR.
> 
> That means as long as one memory region is CMR, it doesn't need to be in
> "reserved area" from TDX architecture's prespective.
> 
> That means we can include more memory regions (even they cannot be used by TDX
> at all) as "non-reserved" areas in TDMRs to reduce the number of "reserved
> areas" as long as those regions are within CMR.
> 
> This is the logic behind this fix.
> 
>>
>>>
>>> Currently, the kernel finds those "non-TDX-usable memory holes" within a
>>> given TDMR by walking over a list of "TDX-usable memory regions", which
>>> essentially reflects the "usable" regions in the e820 table (w/o memory
>>> hotplug operations precisely, but this is not relevant here).
>>
>> But including e820 table regions that are not "usable" in the TDMR
>> reserved areas is not necessary - it is not one of the rules.
> 
> True.  That's why we can do this fix.
> 
>>
>> What confused me initially was that I did not realize the we already
>> require that the TDX Module does not touch memory in the TDMR
>> non-reserved areas not specifically allocated to it.  So it makes no
>> difference to the TDX Module what the pages that have not been allocated
>> to it, are used for.
>>
>>>
>>> As shown above, the root cause of this failure is when the kernel tries
>>> to construct a TDMR to cover address range [0x0, 0x80000000), there
>>> are too many memory holes within that range and the number of memory
>>> holes exceeds the maximum number of reserved areas.
>>>
>>> The E820 table of that platform (see [1] below) reflects this: the
>>> number of memory holes among e820 "usable" entries exceeds 16, which is
>>> the maximum number of reserved areas TDX module supports in practice.
>>>
>>> === Fix ===
>>>
>>> There are two options to fix this: 1) reduce the number of memory holes
>>> when constructing a TDMR to save "reserved areas"; 2) reduce the TDMR's
>>> size to cover fewer memory regions, thus fewer memory holes.
>>
>> Probably better to try and get rid of this "two options" stuff and focus
>> on how this is a simple and effective fix.
> 
> As I mentioned in another reply I would prefer to keep those options since I
> believe they can provide a full view to the reviewers.


