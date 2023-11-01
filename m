Return-Path: <kvm+bounces-312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E45207DE17F
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 14:33:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 212EC1C20DE7
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 13:33:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DDCA134C7;
	Wed,  1 Nov 2023 13:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ObBWW/Kn"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1718125BA
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 13:33:40 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C294BD;
	Wed,  1 Nov 2023 06:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698845616; x=1730381616;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dISOpVyZvQSiCHyFzom/7AUnTuWjhbN0bxMSO69eY1Y=;
  b=ObBWW/KnEczlDfOhm+mIvFGIa5XyUTRW70GQhc4+YY2wT1x9Z1cmo1VL
   U42tak1RP9GH57kMFcN/jFurls8sSfUpnFV8WfpSVgcU5SQRKLkNPjYju
   9Gva6y848sTWm6HR8EQlY86zWZ1JXL74KAcYZ9sfwU1KinG5oQM1Qkymh
   WvDBzYq8y+pKbHHlDqa9OrB4CNM1fr3HPt8R7j7n9tJR+XKjpuxslGtCD
   dv+cdk0zFXiubWt6plV7ZjCQtMfdLSqocciuZh1JI4t5+/hRA3NbYoRpb
   286xMEVrSa0DJdLYJN66Gu8RAOLoeLGmp+npnuuVopd11KbRenLb7poUh
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="378880613"
X-IronPort-AV: E=Sophos;i="6.03,268,1694761200"; 
   d="scan'208";a="378880613"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2023 06:33:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="884557172"
X-IronPort-AV: E=Sophos;i="6.03,268,1694761200"; 
   d="scan'208";a="884557172"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2023 06:33:11 -0700
Received: from [10.212.28.1] (kliang2-mobl1.ccr.corp.intel.com [10.212.28.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id 1B896580E3D;
	Wed,  1 Nov 2023 06:33:09 -0700 (PDT)
Message-ID: <a14147e7-0b35-4fba-b785-ef568474c69b@linux.intel.com>
Date: Wed, 1 Nov 2023 09:33:08 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch 1/2] KVM: x86/pmu: Add Intel CPUID-hinted TopDown slots
 event
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>,
 Jim Mattson <jmattson@google.com>
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
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <baa64cf4-11de-4581-89b6-3a86448e3a6e@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2023-10-31 11:31 p.m., Mi, Dapeng wrote:
> 
> On 11/1/2023 11:04 AM, Jim Mattson wrote:
>> On Tue, Oct 31, 2023 at 6:59 PM Mi, Dapeng
>> <dapeng1.mi@linux.intel.com> wrote:
>>> On 11/1/2023 2:22 AM, Jim Mattson wrote:
>>>> On Tue, Oct 31, 2023 at 1:58 AM Dapeng Mi
>>>> <dapeng1.mi@linux.intel.com> wrote:
>>>>> This patch adds support for the architectural topdown slots event
>>>>> which
>>>>> is hinted by CPUID.0AH.EBX.
>>>> Can't a guest already program an event selector to count event select
>>>> 0xa4, unit mask 1, unless the event is prohibited by
>>>> KVM_SET_PMU_EVENT_FILTER?
>>> Actually defining this new slots arch event is to do the sanity check
>>> for supported arch-events which is enumerated by CPUID.0AH.EBX.
>>> Currently vPMU would check if the arch event from guest is supported by
>>> KVM. If not, it would be rejected just like intel_hw_event_available()
>>> shows.
>>>
>>> If we don't add the slots event in the intel_arch_events[] array, guest
>>> may program the slots event and pass the sanity check of KVM on a
>>> platform which actually doesn't support slots event and program the
>>> event on a real GP counter and got an invalid count. This is not
>>> correct.
>> On physical hardware, it is possible to program a GP counter with the
>> event selector and unit mask of the slots event whether or not the
>> platform supports it. Isn't KVM wrong to disallow something that a
>> physical CPU allows?
> 
> 
> Yeah, I agree. But I'm not sure if this is a flaw on PMU driver. If an
> event is not supported by the hardware,  we can't predict the PMU's
> behavior and a meaningless count may be returned and this could mislead
> the user.

The user can program any events on the GP counter. The perf doesn't
limit it. For the unsupported event, 0 should be returned. Please keep
in mind, the event list keeps updating. If the kernel checks for each
event, it could be a disaster. I don't think it's a flaw.

Thanks,
Kan
> 
> Add Kan to confirm this.
> 
> Hi Kan,
> 
> Have you any comments on this? Thanks.
> 
> 
>>
>>>> AFAICT, this change just enables event filtering based on
>>>> CPUID.0AH:EBX[bit 7] (though it's not clear to me why two independent
>>>> mechanisms are necessary for event filtering).
>>>
>>> IMO, these are two different things. this change is just to enable the
>>> supported arch events check for slot events, the event filtering is
>>> another thing.
>> How is clearing CPUID.0AH:EBX[bit 7] any different from putting {event
>> select 0xa4, unit mask 1} in a deny list with the PMU event filter?
> 
> I think there is no difference in the conclusion but with two different
> methods.
> 
> 

