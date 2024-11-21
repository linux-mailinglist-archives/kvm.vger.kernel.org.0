Return-Path: <kvm+bounces-32233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5961C9D45E0
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 03:52:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F3B4283DCC
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 02:52:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D1C813C3F2;
	Thu, 21 Nov 2024 02:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="koMWIwlm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7123230998;
	Thu, 21 Nov 2024 02:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732157554; cv=none; b=jJc8BGnyLPIj2hD9OiiZVQrQacXEdzbw2s0BNvttzY3GlXiNXNI6ssOznN/ZNvv9a6qeq6GYVJBHfC42qoeRz/1kdEk9+NdTDy31qnj9dBwonn42h5MWdOoOrPfWRWeBqRpNYjFlqtKFmI05HJJSlEQZJlJjPaoVqH7WdgdzLR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732157554; c=relaxed/simple;
	bh=QSq0UIegl91eM7hb2Qa8l7Qv9YwnBF3MpYI8Ov1SrLs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ASKL4GNkALkahRJDpqlA+DTXxwb/iuBk5npYUZMwr6VQ75fG1d7XtYHM6W2MhJM8U1i47Qx95GforNtbWJ60KNMxuGOvnKw84UhN21qojJ23tsNpSlL1j1dOT50mJNhVS0TGRagS49uECKDwPgicXZuPZxu3IjhxZPaHPiyqNKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=koMWIwlm; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732157553; x=1763693553;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QSq0UIegl91eM7hb2Qa8l7Qv9YwnBF3MpYI8Ov1SrLs=;
  b=koMWIwlmP7nqcI7+uwzVPEtn6YkSULjZq8d22v58H0cEnSVbi7fM9+U+
   u2Asljtf9SaWjDDe0bHbePPgf3mOVPYPAqDYnONntg5vcX4FZQHfQAQiu
   EYgR83YAZoSJuHhH5g6nTwR5/gFA2mApkR7fDAlxRBoWiUJh73L3R881I
   nnH6F3drXzqHzpRGdZSoKk6Bg2k4jb6xvl1Ae+47OLZX7VAnJl71UWq6Z
   qgHFj+wNKr1MCnpJk/F0gd1WRf01hnVYYloXUPI0o/vXisobg2stT5eEG
   AyY4LtRpi3cGzWzFTRzevcfCnPh1shwy1OLz8B8k+FOtIflqANp3+b0ly
   w==;
X-CSE-ConnectionGUID: k4Er/RuoTSmGSl/4ZZn4Xg==
X-CSE-MsgGUID: H8xtZ0+TSiuVOv5tD/tqOg==
X-IronPort-AV: E=McAfee;i="6700,10204,11262"; a="19836994"
X-IronPort-AV: E=Sophos;i="6.12,171,1728975600"; 
   d="scan'208";a="19836994"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 18:52:32 -0800
X-CSE-ConnectionGUID: xiQwVz1ZSAWjCZv4qcHp4g==
X-CSE-MsgGUID: 7bb9PsE4RZScMiqKRE6nRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,171,1728975600"; 
   d="scan'208";a="90231286"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 18:52:27 -0800
Message-ID: <dc796819-584d-445d-bbdc-3579c34dc594@linux.intel.com>
Date: Thu, 21 Nov 2024 10:52:24 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 45/58] KVM: x86/pmu: Update
 pmc_{read,write}_counter() to disconnect perf API
To: Sean Christopherson <seanjc@google.com>,
 Mingwei Zhang <mizhang@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang
 <xiong.y.zhang@intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla
 <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-46-mizhang@google.com> <Zz5EQt16V7z-1xCZ@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Zz5EQt16V7z-1xCZ@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/21/2024 4:19 AM, Sean Christopherson wrote:
> On Thu, Aug 01, 2024, Mingwei Zhang wrote:
>> Update pmc_{read,write}_counter() to disconnect perf API because
>> passthrough PMU does not use host PMU on backend. Because of that
>> pmc->counter contains directly the actual value of the guest VM when set by
>> the host (VMM) side.
>>
>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> ---
>>  arch/x86/kvm/pmu.c | 5 +++++
>>  arch/x86/kvm/pmu.h | 4 ++++
>>  2 files changed, 9 insertions(+)
>>
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>> index 41057d0122bd..3604cf467b34 100644
>> --- a/arch/x86/kvm/pmu.c
>> +++ b/arch/x86/kvm/pmu.c
>> @@ -322,6 +322,11 @@ static void pmc_update_sample_period(struct kvm_pmc *pmc)
>>  
>>  void pmc_write_counter(struct kvm_pmc *pmc, u64 val)
>>  {
>> +	if (pmc_to_pmu(pmc)->passthrough) {
>> +		pmc->counter = val;
> This needs to mask the value with pmc_bitmask(pmc), otherwise emulated events
> will operate on a bad value, and loading the PMU state into hardware will #GP
> if the PMC is written through the sign-extended MSRs, i.e. if val = -1 and the
> CPU supports full-width writes.

Sure.



>
>> +		return;
>> +	}
>> +
>>  	/*
>>  	 * Drop any unconsumed accumulated counts, the WRMSR is a write, not a
>>  	 * read-modify-write.  Adjust the counter value so that its value is
>> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
>> index 78a7f0c5f3ba..7e006cb61296 100644
>> --- a/arch/x86/kvm/pmu.h
>> +++ b/arch/x86/kvm/pmu.h
>> @@ -116,6 +116,10 @@ static inline u64 pmc_read_counter(struct kvm_pmc *pmc)
>>  {
>>  	u64 counter, enabled, running;
>>  
>> +	counter = pmc->counter;
> Using a local variable is pointless, the perf-based path immediately clobbers it.

Sure. would drop it and directly return pmc->counter.


>
>> +	if (pmc_to_pmu(pmc)->passthrough)
>> +		return counter & pmc_bitmask(pmc);
> And then this can simply return pmc->counter.  We _could_ add a WARN on pmc->counter
> overlapping with pmc_bitmask(), but IMO that's unnecessary.  If anything, WARN and
> mask pmc->counter when loading state into hardware.
>
>> +
>>  	counter = pmc->counter + pmc->emulated_counter;
>>  
>>  	if (pmc->perf_event && !pmc->is_paused)
>> -- 
>> 2.46.0.rc1.232.g9752f9e123-goog
>>

