Return-Path: <kvm+bounces-40206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E4F7A5400E
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 02:38:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19F0A16D0F5
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 01:38:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CAF618DB02;
	Thu,  6 Mar 2025 01:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SNX1BFD8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADF0EEA9
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 01:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741225101; cv=none; b=I4bfDvdbSgO5RaVA6BFdN8WHIPfZ5LHGDKfxh+2zPgy8gf/SAu1umvuzVqp03r5U+2dezoaBcDvkf8ZLMr98CNDdyh4t6PaHyLqSbxkRmbY7k/a3eikaiGA124GLa/QWe0YLWJvKcKl9JHCryeGDUtubO/+05a8PAslu4CjjGYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741225101; c=relaxed/simple;
	bh=BRkvITwqC9ljJKuED1Pmo+9BOHS4JoP2CXPCODhn8v8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UaYrwOf6ll3AiLeOT0PZbEsvVSnektHP8JVeYynT6Khxg/H9Z2MkbBaI6WsCJsFfMwZrJePr/HnpuMTzH4cpUwMkiyrCvFiWNo6JjjuZr9TSEkte/8C0jmJtT5su2QL7a2vkGP+gViNWWfl4zSf+2E9BFPnwCtSqtBBzsgDbJQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SNX1BFD8; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741225100; x=1772761100;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BRkvITwqC9ljJKuED1Pmo+9BOHS4JoP2CXPCODhn8v8=;
  b=SNX1BFD88ZCXkaJLj0AP6xgTbaf9glNpgqUgBz+DlejTbpGIxiwLHciw
   qzI8bHtbhxtuej3Ri4Zf5ehw1GmuOVCOb+WkYrZHntbgwpmQyMCV0rRDd
   R/eVLJ4ir22eaxORSpmajN78ZivZH/UUullpBXQAhkxNJju7SrlR1nXXF
   elFH1qcAX13on1wKz1mGRDiCWeK7y+y9c6ssjdfMQjr9GtCH9zlgyt/K/
   Sm0w3wOPKP1H3EDZc7J/OB3vMmB9AA/oSwsPaI1JyXidXQzo8jslUr1Pv
   9Tt91xW1ox04P9DIy3RU9L9JO9QlLYFoEjbQLGXJhn6GNIiiG4thmai8U
   Q==;
X-CSE-ConnectionGUID: fo6LGx+iRsi+37ijfQZxKA==
X-CSE-MsgGUID: cfudi+yBTyKKeweEVukf7A==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="52428590"
X-IronPort-AV: E=Sophos;i="6.14,224,1736841600"; 
   d="scan'208";a="52428590"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 17:38:15 -0800
X-CSE-ConnectionGUID: hnAjISE5RfuGECn9t5GiOQ==
X-CSE-MsgGUID: WuST7SpYTACCbpeSzFx/3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,224,1736841600"; 
   d="scan'208";a="119375901"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 17:38:10 -0800
Message-ID: <2f018bf8-9561-4cde-8ee7-a4365f0abce1@linux.intel.com>
Date: Thu, 6 Mar 2025 09:38:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/10] target/i386/kvm: don't stop Intel PMU counters
To: dongli.zhang@oracle.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
 sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
 like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org,
 khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
 davydov-max@yandex-team.ru, xiaoyao.li@intel.com, joe.jin@oracle.com
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-11-dongli.zhang@oracle.com>
 <5f76ce8f-5f69-4a95-8c27-011a7d713fc3@linux.intel.com>
 <3bfa6447-5724-43d7-8176-3dc13cbb0657@oracle.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <3bfa6447-5724-43d7-8176-3dc13cbb0657@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 3/6/2025 3:00 AM, dongli.zhang@oracle.com wrote:
> Hi Dapeng,
>
> On 3/4/25 11:35 PM, Mi, Dapeng wrote:
>> On 3/3/2025 6:00 AM, Dongli Zhang wrote:
>>> The kvm_put_msrs() sets the MSRs using KVM_SET_MSRS. The x86 KVM processes
>>> these MSRs one by one in a loop, only saving the config and triggering the
>>> KVM_REQ_PMU request. This approach does not immediately stop the event
>>> before updating PMC.
>>>
>>> In additional, PMU MSRs are set only at levels >= KVM_PUT_RESET_STATE,
>>> excluding runtime. Therefore, updating these MSRs without stopping events
>>> should be acceptable.
>> Suppose this works for upcoming mediated vPMU as well? If so, please
>> mention it here. Thanks.
> TBH I am not sure if it works for mediated vPMU. The entire patchset is
> based the current implementation in mainline linux kernel.
>
> Otherwise, it is also required to modify the AMD's implementation ... that
> is, to stop AMD general PMCs or global registers (PerfMonV2).
>
> How about only consider the case without mediated vPMU so far?
>
> 1. For user without PerfMonV2 servers, they only need the patchset to reset
> general PMCs.
>
> 2. For user with PerfMonV2 servers, they need extra patch to reset global
> registers.
>
> 3. For mediated vPMU, we may add extra patch in the future.

I suppose it should be fine for mediated vPMU but I have no bandwidth to
thoroughly test it.

Ok, I think it's fine not to consider mediated vPMU in this patch series,
we can look at it later. Thanks.


>
> Thank you very much!
>
> Dongli Zhang
>
>>
>>> Finally, KVM creates kernel perf events with host mode excluded
>>> (exclude_host = 1). While the events remain active, they don't increment
>>> the counter during QEMU vCPU userspace mode.
>>>
>>> No Fixed tag is going to be added for the commit 0d89436786b0 ("kvm:
>>> migrate vPMU state"), because this isn't a bugfix.
>>>
>>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>>> ---
>>>  target/i386/kvm/kvm.c | 9 ---------
>>>  1 file changed, 9 deletions(-)
>>>
>>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>>> index c5911baef0..4902694129 100644
>>> --- a/target/i386/kvm/kvm.c
>>> +++ b/target/i386/kvm/kvm.c
>>> @@ -4160,13 +4160,6 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>>>          }
>>>  
>>>          if (IS_INTEL_CPU(env) && has_pmu_version > 0) {
>>> -            if (has_pmu_version > 1) {
>>> -                /* Stop the counter.  */
>>> -                kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
>>> -                kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
>>> -            }
>>> -
>>> -            /* Set the counter values.  */
>>>              for (i = 0; i < num_pmu_fixed_counters; i++) {
>>>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR0 + i,
>>>                                    env->msr_fixed_counters[i]);
>>> @@ -4182,8 +4175,6 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>>>                                    env->msr_global_status);
>>>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
>>>                                    env->msr_global_ovf_ctrl);
>>> -
>>> -                /* Now start the PMU.  */
>>>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL,
>>>                                    env->msr_fixed_ctr_ctrl);
>>>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL,

