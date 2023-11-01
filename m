Return-Path: <kvm+bounces-276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AEC7A7DDB8C
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 04:32:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF2291C20DBD
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 03:32:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D591110B;
	Wed,  1 Nov 2023 03:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KZ904NB9"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374FCED0
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 03:31:58 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58579A4;
	Tue, 31 Oct 2023 20:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698809513; x=1730345513;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QqGO01Y/1oyO0lTK3Mc38r00JIyBFbJFCspKsxa3IGY=;
  b=KZ904NB9XEtOynIz4iTCx+dpROpak2q49nBciEcHCuvWmKgORlYsolLy
   B+Wmx9nVw2VxvNq0BWpm1+FJebPFpXo+khljRadonWz9AzLX5iksxmgbb
   4hTOMpMm/XSkV9izCM1vMceVsfiINhEV09u+oID4P8ZK3vnNDrLW2Y4qa
   B57vBHSlKqBykP59NNgsMaLchMmDGHh6lKHGJ9VXKUgdl+VzII0KRG9sV
   kiI81x0u7mGXZiq75+TAWwpuPX6MmT8m0vmj5vFTPqPUyyEoKMorDTQRD
   6DOVddKSoWRkmVMzzspBCda+gbTUVF1ERyO8aHdPMTA9zAl+JDw1NKFWn
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="474668040"
X-IronPort-AV: E=Sophos;i="6.03,267,1694761200"; 
   d="scan'208";a="474668040"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 20:31:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="934316919"
X-IronPort-AV: E=Sophos;i="6.03,267,1694761200"; 
   d="scan'208";a="934316919"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.12.33]) ([10.93.12.33])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 20:31:49 -0700
Message-ID: <baa64cf4-11de-4581-89b6-3a86448e3a6e@linux.intel.com>
Date: Wed, 1 Nov 2023 11:31:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch 1/2] KVM: x86/pmu: Add Intel CPUID-hinted TopDown slots
 event
Content-Language: en-US
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Zhang Xiong <xiong.y.zhang@intel.com>, Mingwei Zhang <mizhang@google.com>,
 Like Xu <like.xu.linux@gmail.com>, Dapeng Mi <dapeng1.mi@intel.com>,
 Like Xu <likexu@tencent.com>, Kan Liang <kan.liang@linux.intel.com>
References: <20231031090613.2872700-1-dapeng1.mi@linux.intel.com>
 <20231031090613.2872700-2-dapeng1.mi@linux.intel.com>
 <CALMp9eR_BFdNNTXhSpbuH66jXcRLVB8VvD8V+kY245NbusN2+g@mail.gmail.com>
 <c3f0e4ac-1790-40c1-a09e-209a09e3d230@linux.intel.com>
 <CALMp9eTDAiJ=Kuh7KkwdAY8x1BL2ZjdgFiPFRHXSSVCpcXp9rw@mail.gmail.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <CALMp9eTDAiJ=Kuh7KkwdAY8x1BL2ZjdgFiPFRHXSSVCpcXp9rw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 11/1/2023 11:04 AM, Jim Mattson wrote:
> On Tue, Oct 31, 2023 at 6:59 PM Mi, Dapeng <dapeng1.mi@linux.intel.com> wrote:
>> On 11/1/2023 2:22 AM, Jim Mattson wrote:
>>> On Tue, Oct 31, 2023 at 1:58 AM Dapeng Mi <dapeng1.mi@linux.intel.com> wrote:
>>>> This patch adds support for the architectural topdown slots event which
>>>> is hinted by CPUID.0AH.EBX.
>>> Can't a guest already program an event selector to count event select
>>> 0xa4, unit mask 1, unless the event is prohibited by
>>> KVM_SET_PMU_EVENT_FILTER?
>> Actually defining this new slots arch event is to do the sanity check
>> for supported arch-events which is enumerated by CPUID.0AH.EBX.
>> Currently vPMU would check if the arch event from guest is supported by
>> KVM. If not, it would be rejected just like intel_hw_event_available()
>> shows.
>>
>> If we don't add the slots event in the intel_arch_events[] array, guest
>> may program the slots event and pass the sanity check of KVM on a
>> platform which actually doesn't support slots event and program the
>> event on a real GP counter and got an invalid count. This is not correct.
> On physical hardware, it is possible to program a GP counter with the
> event selector and unit mask of the slots event whether or not the
> platform supports it. Isn't KVM wrong to disallow something that a
> physical CPU allows?


Yeah, I agree. But I'm not sure if this is a flaw on PMU driver. If an 
event is not supported by the hardware,  we can't predict the PMU's 
behavior and a meaningless count may be returned and this could mislead 
the user.

Add Kan to confirm this.

Hi Kan,

Have you any comments on this? Thanks.


>
>>> AFAICT, this change just enables event filtering based on
>>> CPUID.0AH:EBX[bit 7] (though it's not clear to me why two independent
>>> mechanisms are necessary for event filtering).
>>
>> IMO, these are two different things. this change is just to enable the
>> supported arch events check for slot events, the event filtering is
>> another thing.
> How is clearing CPUID.0AH:EBX[bit 7] any different from putting {event
> select 0xa4, unit mask 1} in a deny list with the PMU event filter?

I think there is no difference in the conclusion but with two different 
methods.



