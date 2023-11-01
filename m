Return-Path: <kvm+bounces-315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 832B67DE1C5
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 14:52:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3459F2812F0
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 13:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F32E134DA;
	Wed,  1 Nov 2023 13:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GhUvrzlP"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C95566E
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 13:52:10 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8D6C1;
	Wed,  1 Nov 2023 06:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698846725; x=1730382725;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tp49IqToCZQkv1OkVu0UUxq8QnfuUEUZdkCjxQoX4qw=;
  b=GhUvrzlPdceKTV+3rwkCsKLgaddAZRkEUnP2oL//k1STmLHjU57U/Xds
   +XuHoAWkqKxvRjCDD5iTLNMzQ6lyd5XXKpNsafYUv4betvKllzH/L7VDI
   X/XyZhkrfInQtnA46OurHaEkLpTs2Jj6hTi6RDqhteUdXGK6+5lu2j6zg
   gZzMHgvx3/NdFN/94DZugt0H/Nw17jQB7pjAnn4dt7FQnaCdbhmx9tABk
   BQc6b+8FFwZuLwGRjf8x6ASEc8GCDJ+NpbKj9kwMa4ogC5MQLhNZNTD2g
   o5LqWHx9NXeqiRMM5IfMNzfkHyq5iu6KOmuEoTO00WznKbzGSzWLRC467
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10881"; a="387377508"
X-IronPort-AV: E=Sophos;i="6.03,268,1694761200"; 
   d="scan'208";a="387377508"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2023 06:52:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10881"; a="710795430"
X-IronPort-AV: E=Sophos;i="6.03,268,1694761200"; 
   d="scan'208";a="710795430"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2023 06:52:02 -0700
Received: from [10.212.28.1] (kliang2-mobl1.ccr.corp.intel.com [10.212.28.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id D727E580E3D;
	Wed,  1 Nov 2023 06:52:00 -0700 (PDT)
Message-ID: <a9263db5-f3bf-4c07-b87e-280ad51f4d2c@linux.intel.com>
Date: Wed, 1 Nov 2023 09:51:59 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests Patch v2 4/5] x86: pmu: Support validation for
 Intel PMU fixed counter 3
Content-Language: en-US
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>,
 Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Zhang Xiong <xiong.y.zhang@intel.com>, Mingwei Zhang <mizhang@google.com>,
 Like Xu <like.xu.linux@gmail.com>, Dapeng Mi <dapeng1.mi@intel.com>
References: <20231031092921.2885109-1-dapeng1.mi@linux.intel.com>
 <20231031092921.2885109-5-dapeng1.mi@linux.intel.com>
 <CALMp9eQ4Xj5D-kgqVMKUNmdF37rLcMRXyDYdQU339sRCKZ7d9A@mail.gmail.com>
 <28796dd3-ac4e-4a38-b9e1-f79533b2a798@linux.intel.com>
 <CALMp9eRH5pttOA5BApdVeSbbkOU-kWcOWAoGMfK-9f=cy2Jf0g@mail.gmail.com>
 <fbad1983-5cde-4c7b-aaed-412110fe737f@linux.intel.com>
 <CALMp9eQhUaATf=-7zGDCb_WMNwWx2edXH5Piy+D8QybEL0tyNg@mail.gmail.com>
 <df8f7461-3d4e-4b49-9380-d7d74af844d4@linux.intel.com>
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <df8f7461-3d4e-4b49-9380-d7d74af844d4@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2023-10-31 11:57 p.m., Mi, Dapeng wrote:
> 
> On 11/1/2023 11:24 AM, Jim Mattson wrote:
>> On Tue, Oct 31, 2023 at 8:16 PM Mi, Dapeng
>> <dapeng1.mi@linux.intel.com> wrote:
>>>
>>> On 11/1/2023 10:47 AM, Jim Mattson wrote:
>>>> On Tue, Oct 31, 2023 at 7:33 PM Mi, Dapeng
>>>> <dapeng1.mi@linux.intel.com> wrote:
>>>>> On 11/1/2023 2:47 AM, Jim Mattson wrote:
>>>>>> On Tue, Oct 31, 2023 at 2:22 AM Dapeng Mi
>>>>>> <dapeng1.mi@linux.intel.com> wrote:
>>>>>>> Intel CPUs, like Sapphire Rapids, introduces a new fixed counter
>>>>>>> (fixed counter 3) to counter/sample topdown.slots event, but current
>>>>>>> code still doesn't cover this new fixed counter.
>>>>>>>
>>>>>>> So this patch adds code to validate this new fixed counter can count
>>>>>>> slots event correctly.
>>>>>> I'm not convinced that this actually validates anything.
>>>>>>
>>>>>> Suppose, for example, that KVM used fixed counter 1 when the guest
>>>>>> asked for fixed counter 3. Wouldn't this test still pass?
>>>>> Per my understanding, as long as the KVM returns a valid count in the
>>>>> reasonable count range, we can think KVM works correctly. We don't
>>>>> need
>>>>> to entangle on how KVM really uses the HW, it could be impossible and
>>>>> unnecessary.
>>>> Now, I see how the Pentium FDIV bug escaped notice. Hey, the numbers
>>>> are in a reasonable range. What's everyone upset about?
>>>>
>>>>> Yeah, currently the predefined valid count range may be some kind of
>>>>> loose since I want to cover as much as hardwares and avoid to cause
>>>>> regression. Especially after introducing the random jump and clflush
>>>>> instructions, the cycles and slots become much more hard to predict.
>>>>> Maybe we can have a comparable restricted count range in the initial
>>>>> change, and we can loosen the restriction then if we encounter a
>>>>> failure
>>>>> on some specific hardware. do you think it's better? Thanks.
>>>> I think the test is essentially useless, and should probably just be
>>>> deleted, so that it doesn't give a false sense of confidence.
>>> IMO, I can't say the tests are totally useless. Yes,  passing the tests
>>> doesn't mean the KVM vPMU must work correctly, but we can say there is
>>> something probably wrong if it fails to pass these tests. Considering
>>> the hardware differences, it's impossible to set an exact value for
>>> these events in advance and it seems there is no better method to verify
>>> the PMC count as well. I still prefer to keep these tests until we have
>>> a better method to verify the accuracy of the PMC count.
>> If it's impossible to set an exact value for these events in advance,
>> how does Intel validate the hardware PMU?
> 
> 
> I have no much idea how HW team validates the PMU functionality. But per
> my gotten information, they could have some very tiny benchmarks with a
> fixed pattern and run them on a certain scenario, so they can expect an
> very accurate count value. But this is different with our case, a real
> program is executed on a real system (probably shared with other
> programs), the events count is impacted by too much hardware/software
> factors, such as cache contention, it's hard to predict a single
> accurate count in advance.
>

Yes, there are many factors could impact the value of the
microbenchmarks. I don't think there is a universal benchmark for all
generations and all configurations.

Thanks,
Kan

> Anyway, it's only my guess about the ways of hardware validation, still
> add Kan to get more information.
> 
> Hi Kan,
> 
> Do you have more information about how HW team to validate the PMC count
> accuracy? Thanks.
> 
> 

