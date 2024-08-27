Return-Path: <kvm+bounces-25112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FD6895FE08
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 02:41:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA5E31F22462
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 00:41:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96EC24C92;
	Tue, 27 Aug 2024 00:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gqmXZAJb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6CD7FD;
	Tue, 27 Aug 2024 00:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724719287; cv=none; b=JzBl/59Pq+J+lfh/5UTEQ3fjrLbG6zSgpyrHuspN4inTmtFJ3yZ43ywGt4NXnONE4Jv5dNxjEilw2dlCJoerRTIOYMXfWF4YgTQ09gB/0TWS74Qi/Vs04JgeTUDZZDFH9k7zn5ebntfOZj3HYqfwxA4LW6GdCqQig3m6+ezxuSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724719287; c=relaxed/simple;
	bh=FtiZIXTnx8W3ur7htDZPrgO9irIpW2/Llct8hHGHFcM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h6kVJk/zfQIm5F2tR2tGepfmX1P43cKdjmZ7uGccH0USefqWkTpJomRrUNL5781i0o65x4E1ZpXuVJE/CckjgiyzVlyH8nW2uh18+e0Je2vP08tun4IuVIC12zQMj+32Bf+xJ5rEm+dtNm4BGj9QmIGr3M51kv4Yhfjiekqv7o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gqmXZAJb; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724719286; x=1756255286;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FtiZIXTnx8W3ur7htDZPrgO9irIpW2/Llct8hHGHFcM=;
  b=gqmXZAJbNxNX09Dlc0BG5IewgDgG6yi0o/LpZXxVcAAKzo0NnS1UJ/0T
   sJGWDKuB9dKCFfwh7u4WjdBTKm4SsTPwpz2MgYOhPUdpFCLSa13I6Y/tb
   OITCxM1o8oWdF25PPAYgw5ZUQuRvJSj/M8OGOvh9oI0X/7uAHQDUVnCth
   uHVnmwpSNYsu/tYAAmvWbaFkODbKcRa5shkwyDgXaBOfoysBEfAJpiKzc
   gF5Jg3OOjvvu1MjtozK/AAw/LyCqcmyLFAytJdIRQQogcBrNeaivJZkXY
   F/gQPumb2pbKzXYnqZVqJIpE7CeQ3rFq0x5BAR1fzSfdeGD3F2rC8pS47
   Q==;
X-CSE-ConnectionGUID: COklUwzBSIC7gcQIatV3XQ==
X-CSE-MsgGUID: bdmWSPH3RPuXCPEzOKtQGQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11176"; a="23353643"
X-IronPort-AV: E=Sophos;i="6.10,179,1719903600"; 
   d="scan'208";a="23353643"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2024 17:41:25 -0700
X-CSE-ConnectionGUID: +D1UxytOQv6r6VJn28XUeQ==
X-CSE-MsgGUID: Uqfs88qySn6MXYcBif9VEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,179,1719903600"; 
   d="scan'208";a="66834875"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2024 17:41:22 -0700
Message-ID: <38cf9a8f-97cb-41a4-aac2-4c9f61a90dd7@linux.intel.com>
Date: Tue, 27 Aug 2024 08:41:19 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v5 06/18] x86: pmu: Add asserts to warn inconsistent fixed
 events and counters
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
 Xiong Zhang <xiong.y.zhang@intel.com>, Zhenyu Wang
 <zhenyuw@linux.intel.com>, Like Xu <like.xu.linux@gmail.com>,
 Jinrong Liang <cloudliang@tencent.com>, Dapeng Mi <dapeng1.mi@intel.com>
References: <20240703095712.64202-1-dapeng1.mi@linux.intel.com>
 <20240703095712.64202-7-dapeng1.mi@linux.intel.com>
 <CALMp9eSEuA70itad7oQUo=Ak6MVJYLo4kG4zJwEXkiUG6MgdnA@mail.gmail.com>
 <cea61aab-3feb-4008-adb9-2f2645589714@linux.intel.com>
 <CALMp9eT2pc0qDaySuyNcHr5+tO4gfvrqmYo=a3Ay-0=rfhiksg@mail.gmail.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <CALMp9eT2pc0qDaySuyNcHr5+tO4gfvrqmYo=a3Ay-0=rfhiksg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 8/27/2024 2:36 AM, Jim Mattson wrote:
> On Sun, Aug 25, 2024 at 11:56 PM Mi, Dapeng <dapeng1.mi@linux.intel.com> wrote:
>>
>> On 8/23/2024 2:22 AM, Jim Mattson wrote:
>>> On Tue, Jul 2, 2024 at 7:12 PM Dapeng Mi <dapeng1.mi@linux.intel.com> wrote:
>>>> Current PMU code deosn't check whether PMU fixed counter number is
>>>> larger than pre-defined fixed events. If so, it would cause memory
>>>> access out of range.
>>>>
>>>> So add assert to warn this invalid case.
>>>>
>>>> Reviewed-by: Mingwei Zhang <mizhang@google.com>
>>>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>>>> ---
>>>>  x86/pmu.c | 10 ++++++++--
>>>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/x86/pmu.c b/x86/pmu.c
>>>> index b4de2680..3e0bf3a2 100644
>>>> --- a/x86/pmu.c
>>>> +++ b/x86/pmu.c
>>>> @@ -113,8 +113,12 @@ static struct pmu_event* get_counter_event(pmu_counter_t *cnt)
>>>>                 for (i = 0; i < gp_events_size; i++)
>>>>                         if (gp_events[i].unit_sel == (cnt->config & 0xffff))
>>>>                                 return &gp_events[i];
>>>> -       } else
>>>> -               return &fixed_events[cnt->ctr - MSR_CORE_PERF_FIXED_CTR0];
>>>> +       } else {
>>>> +               unsigned int idx = cnt->ctr - MSR_CORE_PERF_FIXED_CTR0;
>>>> +
>>>> +               assert(idx < ARRAY_SIZE(fixed_events));
>>> Won't this assertion result in a failure on bare metal, for CPUs
>>> supporting fixed counter 3?
>> Yes, this is intended use. Currently KVM vPMU still doesn't support fixed
>> counter 3. If it's supported in KVM vPMU one day but forget to add
>> corresponding support in this pmu test, this assert would remind this.
> These tests are supposed to run (and pass) on bare metal. Hence, they
> should not be dependent on a non-architectural quirk of the KVM
> implementation.
>
> Perhaps a warning would serve as a reminder?

Sounds reasonable. Would change to a warning. Thanks.


>
>>>> +               return &fixed_events[idx];
>>>> +       }
>>>>
>>>>         return (void*)0;
>>>>  }
>>>> @@ -740,6 +744,8 @@ int main(int ac, char **av)
>>>>         printf("Fixed counters:      %d\n", pmu.nr_fixed_counters);
>>>>         printf("Fixed counter width: %d\n", pmu.fixed_counter_width);
>>>>
>>>> +       assert(pmu.nr_fixed_counters <= ARRAY_SIZE(fixed_events));
>>>> +
>>> And this one as well?
>>>
>>>>         apic_write(APIC_LVTPC, PMI_VECTOR);
>>>>
>>>>         check_counters();
>>>> --
>>>> 2.40.1
>>>>

