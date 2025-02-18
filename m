Return-Path: <kvm+bounces-38413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DB737A39731
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 10:34:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8856E7A3A52
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 09:33:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80465230D11;
	Tue, 18 Feb 2025 09:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dpjpJu7a"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D6D22D4C9;
	Tue, 18 Feb 2025 09:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739871258; cv=none; b=rLH5T+OzWdEy3AfhPJMMyC3ojd1vaZe0j/7riBqiviQbhyihyGQNuIROWy/1EwBMo2o9c+BPWXEulkXbptOGEc+xP08m1VbQHvAEAb1qz5IAK4HyFAGrakCI8G/fROfoFkNO5e6lgNKvWveyWrMydz7ApmH/aRQ1ouczSGSK6YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739871258; c=relaxed/simple;
	bh=V8X1mDk7JVpQUTClaj7fdDJBMmCj/vyPTzAGGwCbZbg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tReyMv43gsku0dFSvSIcjsdWi3lKnoMgRwhk605HcqhiF0QZAQ7GbemWAqUklgXRGS94aubCQoRuyHgmGyaf4XNUDKvpoliAiFxwb+1u8VH2n7UbeBnz7NpJEGCEvNQeaqaYAOxUnVIw+xI1QIANECdnv54Qw9OEkZFHWPybBg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dpjpJu7a; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739871258; x=1771407258;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=V8X1mDk7JVpQUTClaj7fdDJBMmCj/vyPTzAGGwCbZbg=;
  b=dpjpJu7adSN2m4DURT6N0uuf0/zx0GL6Oc2hsXJmcSazahIGLcSfV45V
   eFtpsq5zWXDzY8cidzYlaJRnpr+dAEsp1oiwwEdpR3YUV65r1sf2gebKW
   6weyro2UJM/6NYNd4qrhk/2wZDncjtiRW3TYv0k4yODl7Nb0exyqS+pYR
   3yVGBWCbB84qq/0Nl50pUBgNxCrtCivGSD4lbCJTj0NYJZwVzsw1NGDho
   aILEnGexHfrZBjkcm61oDpJgeMJtULGZHAdyIAbyG/eTu39kNaY/VyZoJ
   zX3H8KK2p/F6cYVSj+uER5YtUwBnX8fsIjoUbAep1TY+FYsp4gyvaH/0p
   w==;
X-CSE-ConnectionGUID: ExYGjjmgS0+oSgNyDUuBpQ==
X-CSE-MsgGUID: nqEIXHUiQ3axBmnX/uOKBw==
X-IronPort-AV: E=McAfee;i="6700,10204,11348"; a="51542674"
X-IronPort-AV: E=Sophos;i="6.13,295,1732608000"; 
   d="scan'208";a="51542674"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 01:34:16 -0800
X-CSE-ConnectionGUID: mbwZ4YsQQ3OJovpBmDqYOg==
X-CSE-MsgGUID: PlFqrOiYRpK+JdpKoi7x3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="118467594"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 01:34:12 -0800
Message-ID: <28dcae5c-4fb7-46a8-9f37-a4f9f59b45a2@linux.intel.com>
Date: Tue, 18 Feb 2025 17:34:09 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests patch v6 07/18] x86: pmu: Fix potential out of
 bound access for fixed events
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
 Mingwei Zhang <mizhang@google.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Like Xu <like.xu.linux@gmail.com>,
 Jinrong Liang <cloudliang@tencent.com>, Yongwei Ma <yongwei.ma@intel.com>,
 Dapeng Mi <dapeng1.mi@intel.com>
References: <20240914101728.33148-1-dapeng1.mi@linux.intel.com>
 <20240914101728.33148-8-dapeng1.mi@linux.intel.com>
 <Z6-wmhr5JDNuDC7D@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Z6-wmhr5JDNuDC7D@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 2/15/2025 5:07 AM, Sean Christopherson wrote:
> On Sat, Sep 14, 2024, Dapeng Mi wrote:
>> @@ -744,6 +753,12 @@ int main(int ac, char **av)
>>  	printf("Fixed counters:      %d\n", pmu.nr_fixed_counters);
>>  	printf("Fixed counter width: %d\n", pmu.fixed_counter_width);
>>  
>> +	fixed_counters_num = MIN(pmu.nr_fixed_counters, ARRAY_SIZE(fixed_events));
>> +	if (pmu.nr_fixed_counters > ARRAY_SIZE(fixed_events))
>> +		report_info("Fixed counters number %d > defined fixed events %ld. "
> Doesn't compile on 32-bit builds.  Easiest thing is to cast ARRAY_SIZE, because
> size_t is different between 32-bit and 64-bit.

But ARRAY_SIZE() should return same value regardless of 32-bit or 64-bit,
right?


>
>> +			    "Please update test case.", pmu.nr_fixed_counters,
>> +			    ARRAY_SIZE(fixed_events));
>> +
>>  	apic_write(APIC_LVTPC, PMI_VECTOR);
>>  
>>  	check_counters();
>> -- 
>> 2.40.1
>>

