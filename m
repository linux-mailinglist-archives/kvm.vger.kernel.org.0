Return-Path: <kvm+bounces-59678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B913BBC71E9
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 03:34:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C97D519E3C00
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 01:35:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61C8F18DF89;
	Thu,  9 Oct 2025 01:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZZQuxwcv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8B6F9C1;
	Thu,  9 Oct 2025 01:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759973691; cv=none; b=kusDNVhFj3K8UxiCo4Zf2+qlWPn2Mnfq8F05uB3XkSrktkWt+uSVp51Yx4uCzlYU3nIMN2QXnaMJ2J9ZwS84YZAFWYh8VJDsUFNa8Qk2NRKrK7CLTrhGeaWKIl5TBjcRYpbZ76IEdP272YdCq9rsCNkeACIF/hnjJJ1S/saVnsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759973691; c=relaxed/simple;
	bh=eq1ErBn0paUoH1VyOJWvLBa1xZf5uLKYIdGW7A7Qi+M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A+UtbfAKRVAL0g8DUj92qnWWfx1jMvZhieXfjIlJSO5V2KOn77PVBZy0ZBLZgg/bHwRLiu9boHPn82ntEDs/HSEw26uTeCzJEI1Q8JJVjtPm8y7JHMFEVPxHiE8Ggwo+vAARvhNohwGT9XMACdC7w0GIGn/ccufNKa3apz0lKlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZZQuxwcv; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759973689; x=1791509689;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eq1ErBn0paUoH1VyOJWvLBa1xZf5uLKYIdGW7A7Qi+M=;
  b=ZZQuxwcvIKRMGaF+DJAPt16LcHIv4WKeD/sdbhRBhaebZYgGJhCo1+WX
   noC8IEeA3J/YYClYILxYz/bkv90j/j/vF6PGYGL5nTkKPjhmNtTYUTKFe
   danqGcurhTWtzmMKrNqF5G9kALC9lcwASJPlpR3PyZ8eQPhUT6FQ9X40n
   gP6/Zz4VO15t9/892VLjzTwEvkWQV4ftxSh6tPnxRiEibQ1ZnYl9z8bn6
   4B5ym51I0Kzb7J6ST96vZpvIYzcZtwBq2Ya4ueMnQ9fTNgiUnsAVTzBd/
   mx7EEjw5d/OwG3NTV3FiCywGkCHUBPsCUu+0uFM+tuHtGnf1KcXMPPJAv
   A==;
X-CSE-ConnectionGUID: E+nSCfquTM2wN2b6KAM5Nw==
X-CSE-MsgGUID: enpUYWTPS5mhMwjjKvLUlA==
X-IronPort-AV: E=McAfee;i="6800,10657,11576"; a="72789477"
X-IronPort-AV: E=Sophos;i="6.19,214,1754982000"; 
   d="scan'208";a="72789477"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 18:34:47 -0700
X-CSE-ConnectionGUID: vzF1OKCdSPqPBTsdim5l8w==
X-CSE-MsgGUID: aU7v1SHWTUSeIllMAynIgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,214,1754982000"; 
   d="scan'208";a="179698971"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.232.209]) ([10.124.232.209])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 18:34:44 -0700
Message-ID: <e9e8f087-60f6-455a-b0e0-e5c29fc54129@linux.intel.com>
Date: Thu, 9 Oct 2025 09:34:41 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: REGRESSION on linux-next (next-20250919)
To: "Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>,
 Sean Christopherson <seanjc@google.com>
Cc: "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
 "intel-xe@lists.freedesktop.org" <intel-xe@lists.freedesktop.org>,
 Suresh Kumar Kurmi <suresh.kumar.kurmi@intel.com>,
 Jani Saarinen <jani.saarinen@intel.com>, lucas.demarchi@intel.com,
 linux-perf-users@vger.kernel.org, kvm@vger.kernel.org
References: <70b64347-2aca-4511-af78-a767d5fa8226@intel.com>
 <25af94f5-79e3-4005-964e-e77b1320a16e@linux.intel.com>
 <aNvyjkuDLOfxAANd@google.com>
 <3bbc4e6d-9f52-483c-a25d-166dca62fb25@intel.com>
 <00d0f3f3-d2b4-4885-9a49-5e6f8390142b@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <00d0f3f3-d2b4-4885-9a49-5e6f8390142b@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 10/7/2025 2:22 PM, Borah, Chaitanya Kumar wrote:
> Hi,
>
> On 10/6/2025 1:33 PM, Borah, Chaitanya Kumar wrote:
>> Thank you for your responses.
>>
>> Following change fixes the issue for us.
>>
>>
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>> index 40ac4cb44ed2..487ad19a236e 100644
>> --- a/arch/x86/kvm/pmu.c
>> +++ b/arch/x86/kvm/pmu.c
>> @@ -108,16 +108,18 @@ void kvm_init_pmu_capability(const struct 
>> kvm_pmu_ops *pmu_ops)
>>          bool is_intel = boot_cpu_data.x86_vendor == X86_VENDOR_INTEL;
>>          int min_nr_gp_ctrs = pmu_ops->MIN_NR_GP_COUNTERS;
>>
>> -       perf_get_x86_pmu_capability(&kvm_host_pmu);
>> -
>>          /*
>>           * Hybrid PMUs don't play nice with virtualization without careful
>>           * configuration by userspace, and KVM's APIs for reporting 
>> supported
>>           * vPMU features do not account for hybrid PMUs.  Disable vPMU 
>> support
>>           * for hybrid PMUs until KVM gains a way to let userspace opt-in.
>>           */
>> -       if (cpu_feature_enabled(X86_FEATURE_HYBRID_CPU))
>> +       if (cpu_feature_enabled(X86_FEATURE_HYBRID_CPU)) {
>>                  enable_pmu = false;
>> +               memset(&kvm_host_pmu, 0, sizeof(kvm_host_pmu));
>> +       } else {
>> +               perf_get_x86_pmu_capability(&kvm_host_pmu);
>> +       }
> Can we expect a formal patch soon?

I'd like to post a patch to fix this tomorrow if Sean has no bandwidth on
this. Thanks.


>
> Regards
>
> Chaitanya

