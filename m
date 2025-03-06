Return-Path: <kvm+bounces-40207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FC69A5401B
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 02:47:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CC91D188DED1
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 01:47:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FE2A6F31E;
	Thu,  6 Mar 2025 01:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PUeJ4Lwd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08753DDA8
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 01:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741225626; cv=none; b=WRSHkG/h2nQrB69xcZuVVdwsUDpPsDGtUwLGu5b1Q7qmKeY2z5737hqkolLyPK77g42xkCOVdh+3uyl8o37XVEIPcgDuMCxbaEVtTa+xZAUL3UPzKfJDC//u8TbQoSu38nDUHLh/9MkQgtTbYaTJBigjWrLREbHHKl0gd8bCe0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741225626; c=relaxed/simple;
	bh=Mibdji299/9Fc+Z9CJZLXbR6fgWVEtkajMO++k04720=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VYVHnSZfY3RFI6zRbiq20Ld5/PyiFy5iWGptfxDffUFQoD5bYNXVUlaujrbeL2g1kRu9PGnwAfYWmA0SUHT4DfOCu8KWAo7N5gpaMMPV+CjYeSJzXKNZbvokNPPENu4v/601szQy1Y7f9Fnb/3eGWOKEwKm7uSkvSWB9oZ+f5Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PUeJ4Lwd; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741225624; x=1772761624;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Mibdji299/9Fc+Z9CJZLXbR6fgWVEtkajMO++k04720=;
  b=PUeJ4LwddshFeKjSVKpoZ1ix7u7wJBacF1c/XbcubZd9TlMCYQi3+wZm
   oYH2NBdhnlHOXeJCbujgucCyDuE6TN7ZAZWX3eY3ltrJlapScm0P7lLOs
   kmpLxWpr3TtEVYZ4V28Rp4XBGjvdhwjPu2UbNYwTMfmlHmqebXa2eLnQO
   RY8zx1MZKljp3Di1wRU8q2LSvNRzvxmjccfXX3YPr4ZU8uSY3Qs+kozNn
   yDLOrZ/tqE3yzbZWvFVsvr+I39H4a25hLGzTfj/MUwfsbXiWoZh607j68
   v3p9L0TbHX0ZePsyO6BES4CyxiINRzytA/+/t6dkgXE0Vs1dr5Z5z9+6q
   w==;
X-CSE-ConnectionGUID: sSpSlUyBRxa1XRyM4kgGeg==
X-CSE-MsgGUID: iZJlzAyARJWmyHkYLXwplg==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="45993228"
X-IronPort-AV: E=Sophos;i="6.14,224,1736841600"; 
   d="scan'208";a="45993228"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 17:47:04 -0800
X-CSE-ConnectionGUID: TKssOaEjS92rs+OJAE4iEw==
X-CSE-MsgGUID: EmpL3QdaSPeTuAyLLLFufw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,224,1736841600"; 
   d="scan'208";a="123792326"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 17:47:02 -0800
Message-ID: <55a85e20-0871-457f-8055-10d456fc932f@intel.com>
Date: Thu, 6 Mar 2025 09:46:59 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] KVM: x86: Cleanup and fix for reporting CPUID leaf
 0x80000022
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
References: <20250304082314.472202-1-xiaoyao.li@intel.com>
 <174110882170.40250.8746962643426198696.b4-ty@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <174110882170.40250.8746962643426198696.b4-ty@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/6/2025 8:57 AM, Sean Christopherson wrote:
> On Tue, 04 Mar 2025 03:23:12 -0500, Xiaoyao Li wrote:
>> Patch 1 is a cleanup and Patch 2 is a fix. Please see the individual
>> patch for detail.
>>
>> Xiaoyao Li (2):
>>    KVM: x86: Remove the unreachable case for 0x80000022 leaf in
>>      __do_cpuid_func()
>>    KVM: x86: Explicitly set eax and ebx to 0 when X86_FEATURE_PERFMON_V2
>>      cannot be exposed to guest
>>
>> [...]
> 
> Applied patch 2 to kvm-x86 fixes and tagged it for stable, and applied patch 1
> to misc.  Not zeroing eax/ebx is relatively benign, as it only affects the
> !enable_pmu case, but it's most definitely a bug and the fix is about as safe
> as a fix can be.
> 
> I also added quite a bit of extra information to both changelogs.

Thanks! It's much better!

> Thanks!
> 
> [1/2] KVM: x86: Remove the unreachable case for 0x80000022 leaf in __do_cpuid_func()
>        https://github.com/kvm-x86/linux/commit/e6c8728a8e2d
> [2/2] KVM: x86: Explicitly zero EAX and EBX when PERFMON_V2 isn't supported by KVM
>        https://github.com/kvm-x86/linux/commit/f9dc8fb3afc9
> 
> --
> https://github.com/kvm-x86/linux/tree/next


