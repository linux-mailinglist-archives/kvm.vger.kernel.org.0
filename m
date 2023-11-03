Return-Path: <kvm+bounces-506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E62B37E0553
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 16:13:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47D8C281ED1
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 15:13:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A67951B269;
	Fri,  3 Nov 2023 15:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lj+wE/kz"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BC9184C
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 15:13:06 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20BFED52;
	Fri,  3 Nov 2023 08:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699024380; x=1730560380;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jjAzBvdNqU+zJFD678xcgoXGtuJCwhpDnpe6k8NVQRE=;
  b=Lj+wE/kzKmjVdKopp6wEiopfZ8NG0/9tPXeEWjayPBuXAmkpflCPwC0P
   PPE8n8h5WQE+LfAQHmZdG4xD+aKTaPlN2+afGCyLGJ8DFbKRS7LE4VfZL
   e1NxnaB2U2nFv0t5f3974dVNRhtIFTx+S5l7KbL0jUVCm5uXrpE3kUr//
   kEzgtZo+X3JBiwX91QEfwbpwuMR1tfyXgGFiSMxpq5PgPfGFWP0I+TR70
   NOWSDYhgYRSZzaUuxcoNREeAhCNSXxNxi04ch26gJ4RHH4phIdJVV1uux
   vVTmjVRqDT2cXahfF/di3oYAAT6DblQexkGPcPmPH4wh+RcusYFEAP4vQ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10883"; a="373998421"
X-IronPort-AV: E=Sophos;i="6.03,273,1694761200"; 
   d="scan'208";a="373998421"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2023 08:12:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,273,1694761200"; 
   d="scan'208";a="2918519"
Received: from linux.intel.com ([10.54.29.200])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2023 08:12:58 -0700
Received: from [10.209.173.25] (kliang2-mobl1.ccr.corp.intel.com [10.209.173.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id 54945580223;
	Fri,  3 Nov 2023 08:12:56 -0700 (PDT)
Message-ID: <2004baa6-b494-462c-a11f-8104ea152c6a@linux.intel.com>
Date: Fri, 3 Nov 2023 11:12:54 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch 1/2] KVM: x86/pmu: Add Intel CPUID-hinted TopDown slots
 event
To: Jim Mattson <jmattson@google.com>, "Mi, Dapeng"
 <dapeng1.mi@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Zhang Xiong <xiong.y.zhang@intel.com>, Mingwei Zhang <mizhang@google.com>,
 Like Xu <like.xu.linux@gmail.com>, Dapeng Mi <dapeng1.mi@intel.com>,
 Like Xu <likexu@tencent.com>
References: <20231031090613.2872700-1-dapeng1.mi@linux.intel.com>
 <20231031090613.2872700-2-dapeng1.mi@linux.intel.com>
 <CALMp9eR_BFdNNTXhSpbuH66jXcRLVB8VvD8V+kY245NbusN2+g@mail.gmail.com>
 <c3f0e4ac-1790-40c1-a09e-209a09e3d230@linux.intel.com>
 <CALMp9eTDAiJ=Kuh7KkwdAY8x1BL2ZjdgFiPFRHXSSVCpcXp9rw@mail.gmail.com>
 <baa64cf4-11de-4581-89b6-3a86448e3a6e@linux.intel.com>
 <a14147e7-0b35-4fba-b785-ef568474c69b@linux.intel.com>
 <85706bd7-7df0-4d4b-932c-d807ddb14f9e@linux.intel.com>
 <CALMp9eS3NdTUnRrYPB+mMoGKj5NnsYXNUfUJX8Gv=wWCN4dkoQ@mail.gmail.com>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <CALMp9eS3NdTUnRrYPB+mMoGKj5NnsYXNUfUJX8Gv=wWCN4dkoQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2023-11-02 1:45 p.m., Jim Mattson wrote:
> On Wed, Nov 1, 2023 at 7:07 PM Mi, Dapeng <dapeng1.mi@linux.intel.com> wrote:
>>
>>
>> On 11/1/2023 9:33 PM, Liang, Kan wrote:
>>>
>>> On 2023-10-31 11:31 p.m., Mi, Dapeng wrote:
>>>> On 11/1/2023 11:04 AM, Jim Mattson wrote:
>>>>> On Tue, Oct 31, 2023 at 6:59 PM Mi, Dapeng
>>>>> <dapeng1.mi@linux.intel.com> wrote:
>>>>>> On 11/1/2023 2:22 AM, Jim Mattson wrote:
>>>>>>> On Tue, Oct 31, 2023 at 1:58 AM Dapeng Mi
>>>>>>> <dapeng1.mi@linux.intel.com> wrote:
>>>>>>>> This patch adds support for the architectural topdown slots event
>>>>>>>> which
>>>>>>>> is hinted by CPUID.0AH.EBX.
>>>>>>> Can't a guest already program an event selector to count event select
>>>>>>> 0xa4, unit mask 1, unless the event is prohibited by
>>>>>>> KVM_SET_PMU_EVENT_FILTER?
>>>>>> Actually defining this new slots arch event is to do the sanity check
>>>>>> for supported arch-events which is enumerated by CPUID.0AH.EBX.
>>>>>> Currently vPMU would check if the arch event from guest is supported by
>>>>>> KVM. If not, it would be rejected just like intel_hw_event_available()
>>>>>> shows.
>>>>>>
>>>>>> If we don't add the slots event in the intel_arch_events[] array, guest
>>>>>> may program the slots event and pass the sanity check of KVM on a
>>>>>> platform which actually doesn't support slots event and program the
>>>>>> event on a real GP counter and got an invalid count. This is not
>>>>>> correct.
>>>>> On physical hardware, it is possible to program a GP counter with the
>>>>> event selector and unit mask of the slots event whether or not the
>>>>> platform supports it. Isn't KVM wrong to disallow something that a
>>>>> physical CPU allows?
>>>>
>>>> Yeah, I agree. But I'm not sure if this is a flaw on PMU driver. If an
>>>> event is not supported by the hardware,  we can't predict the PMU's
>>>> behavior and a meaningless count may be returned and this could mislead
>>>> the user.
>>> The user can program any events on the GP counter. The perf doesn't
>>> limit it. For the unsupported event, 0 should be returned. Please keep
>>> in mind, the event list keeps updating. If the kernel checks for each
>>> event, it could be a disaster. I don't think it's a flaw.
>>
>>
>> Thanks Kan, it would be ok as long as 0 is always returned for
>> unsupported events. IMO, it's a nice to have feature that KVM does this
>> sanity check for supported arch events, it won't break anything.
> 
> The hardware PMU most assuredly does not return 0 for unsupported events.
>
> For example, if I use host perf to sample event selector 0xa4 unit
> mask 1 on a Broadwell host (406f1), I get...

I think we have different understanding about the meaning of the
"unsupported". There is no enumeration of the Architectural Topdown
Slots, which only means the Topdown Slots/01a4 is not an architectural
event on the platform. It doesn't mean that the event encoding is
unsupported. It could be used by another event, especially on the
previous platform.

Except for the architectural events, the event encoding of model
specific event is not guaranteed to be the same among different
generations. On BDW, the 01a4 is a model specific event with other
meanings. That's why you can observe some values.

Please make sure to only test the event on an enumerated platform.

Thanks,
Kan
> 
> # perf stat -e r01a4 sleep 10
> 
>  Performance counter stats for 'sleep 10':
> 
>            386,964      r01a4
> 
>       10.000907211 seconds time elapsed
> 
> Broadwell does not advertise support for architectural event 7 in
> CPUID.0AH:EBX, so KVM will refuse to measure this event inside a
> guest. That seems broken to me.
> 
>>
>>>
>>> Thanks,
>>> Kan
>>>> Add Kan to confirm this.
>>>>
>>>> Hi Kan,
>>>>
>>>> Have you any comments on this? Thanks.
>>>>
>>>>
>>>>>>> AFAICT, this change just enables event filtering based on
>>>>>>> CPUID.0AH:EBX[bit 7] (though it's not clear to me why two independent
>>>>>>> mechanisms are necessary for event filtering).
>>>>>> IMO, these are two different things. this change is just to enable the
>>>>>> supported arch events check for slot events, the event filtering is
>>>>>> another thing.
>>>>> How is clearing CPUID.0AH:EBX[bit 7] any different from putting {event
>>>>> select 0xa4, unit mask 1} in a deny list with the PMU event filter?
>>>> I think there is no difference in the conclusion but with two different
>>>> methods.
>>>>
>>>>

