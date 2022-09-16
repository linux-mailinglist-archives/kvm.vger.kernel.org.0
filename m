Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6BF85BAE22
	for <lists+kvm@lfdr.de>; Fri, 16 Sep 2022 15:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbiIPN1P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Sep 2022 09:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiIPN1N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Sep 2022 09:27:13 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7770C39BB2;
        Fri, 16 Sep 2022 06:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663334831; x=1694870831;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=HNoxeDL5qT17zhAlh+G+qfDO7ou8sVZ/+dkAXvYVPZw=;
  b=f4TV8roCms6fGxFG/7IGmRwgHT2Bbfw9oT6Df0fvLgszLN16BYP6xJyg
   XEfWXvix1lHoh1VTS+A2vnxHD7yMNg9XP+Ztz57ln2zCGDacvGOpvZb5J
   hcwEpp758yf8rXSU62XgkF7aONE6oq2CUI+sSUY3YpnL66Ng+ZtxOF3x9
   6TTMli5Xm1E3DRmDPrtGGiTjqnKHKjTRUut9Be0c9oR+if5LheDSTuRbx
   5LPkEljIGj04yLm2I8wgioLe3hl8/KH4RReSEuX2ID9crgDbby4EHQDgZ
   OlCkQwl4nqxBSWtiqps1BFLC2W17XgdUHK9HVdF5r2zYmqdXKnfFV9wkM
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10472"; a="286029674"
X-IronPort-AV: E=Sophos;i="5.93,320,1654585200"; 
   d="scan'208";a="286029674"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2022 06:27:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,320,1654585200"; 
   d="scan'208";a="793098671"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga005.jf.intel.com with ESMTP; 16 Sep 2022 06:27:10 -0700
Received: from [10.252.210.67] (kliang2-mobl1.ccr.corp.intel.com [10.252.210.67])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 8908F5807E8;
        Fri, 16 Sep 2022 06:27:08 -0700 (PDT)
Message-ID: <da8fe1d8-8cce-7378-18e8-41fd7009ff8d@linux.intel.com>
Date:   Fri, 16 Sep 2022 09:27:07 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
To:     "Wang, Wei W" <wei.w.wang@intel.com>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Liang, Kan" <kan.liang@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>
Cc:     "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20220825085625.867763-1-xiaoyao.li@intel.com>
 <CY5PR11MB6365897E8E6D0B590A298FA0DC769@CY5PR11MB6365.namprd11.prod.outlook.com>
 <815586ac-1eaa-5e38-1e08-492c29d0729d@intel.com>
 <CY5PR11MB63659EBEAEA0E64812E96111DC469@CY5PR11MB6365.namprd11.prod.outlook.com>
 <f7cfb391-c38b-84d2-b2fe-5e289d82862c@linux.intel.com>
 <CY5PR11MB6365676799EBF86B3931D336DC499@CY5PR11MB6365.namprd11.prod.outlook.com>
 <ef391316-cde5-3cda-ff0d-980e8ecc9aef@linux.intel.com>
 <CY5PR11MB636535BE57F8CC07B1B2770DDC499@CY5PR11MB6365.namprd11.prod.outlook.com>
 <4c6a5663-778e-a509-638c-92cfd5315274@linux.intel.com>
 <CY5PR11MB6365EE3B1C4BCED02A1E40D8DC489@CY5PR11MB6365.namprd11.prod.outlook.com>
Content-Language: en-US
From:   "Liang, Kan" <kan.liang@linux.intel.com>
Subject: Re: [RFC PATCH 0/2] KVM: VMX: Fix VM entry failure on
 PT_MODE_HOST_GUEST while host is using PT
In-Reply-To: <CY5PR11MB6365EE3B1C4BCED02A1E40D8DC489@CY5PR11MB6365.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2022-09-15 10:30 p.m., Wang, Wei W wrote:
> On Thursday, September 15, 2022 11:43 PM, Liang, Kan wrote:
>> On 2022-09-15 10:39 a.m., Wang, Wei W wrote:
>>> On Thursday, September 15, 2022 9:55 PM Liang, Kan wrote:
>>>> On 2022-09-14 10:46 p.m., Wang, Wei W wrote:
>>>>> On Thursday, September 15, 2022 4:26 AM, Liang, Kan wrote:
>>>>>> The perf_event_disable() eventually invokes the intel_pt_stop().
>>>>>> We already expose the intel_pt_stop()/cpu_emergency_stop_pt() to
>>>>>> other modules. I don't think we have to use the perf_event_disable().
>>>>>> Also, the
>>>>>> perf_event_disable() requires extra codes.
>>>>>>
>>>>>> I went through the discussions. I agree with Sean's suggestion.
>>>>>> We should only put the logic in the KVM but all the MSR access
>>>>>> details into the PT driver.
>>>>>
>>>>> Even the driver itself doesn’t drive the save/restore of the MSRs,
>>>>> it is drived
>>>> by perf.
>>>>
>>>> It through perf_event, not driven by perf_event. The perf_event
>>>> generic code never knows when should invokes each driver to
>>>> save/restore information. It should be driven by the other subsystem e.g.,
>> scheduler.
>>>
>>> Yes. The cpu scheduler does this via the perf subsystem, though.
>>>
>>>>
>>>> For this case, KVM should drive the save/restore, and the PT driver
>>>> eventually does all the MSR access details.
>>>>
>>>>> 1. If we make KVM a user of perf, we should do this via
>>>> perf_event_disable/enable_*.
>>>>> 2. If we make KVM an alternative to perf (i.e. have direct control
>>>>> over PMU HW), we can do this via driver interfaces like perf.
>>>>> Per my experience, we should go for 1. Probably need Peter's
>>>>> opinions on
>>>> this.
>>>>>
>>>>
>>>> For 1, the perf_event_disable/enable_* are not enough. They don't
>>>> save/restore MSRs.
>>>
>>> perf_event_disable will go through perf to call pt_event_stop which saves
>> the related MSRs, right?
>>
>> I don't think so. The pt_event_stop() doesn't save all the
>> MSR_IA32_RTIT_* MSRs.
> 
> Not all the MSRs are required to be saved. In general, pt_event_stop should have
> saved all the MSRs required for an event switching. Otherwise the general usages
> of PT have been broken. To be more precise, the following MSRs are not saved by
> pt_event_stop, but I don’t see they are required to be saved:
> 
> - MSR_IA32_RTIT_CR3_MATCH: I don’t see it is used by perf. 
> Seems like KVM saved an MSR that's not even used by the host.
> 
> - Address range MSRs (MSR_IA32_RTIT_ADDR0_A etc.): Those are provided by s/w and not updated by h/w.
> So they're just set to MSRs when event gets scheduled in. There is no need to save. 
>

OK. I think you need a clean-up patch to fix them first.


>>
>>> (if so, what large changes did you mean?)
>>>
>>>> If we go to this way, we have to introduce a new generic interface to
>>>> ask each driver to save/restore their MSRs when the guest is
>>>> entering/exiting. We'd better combine the new interface with the
>>>> existing
>>>> perf_guest_get_msrs() of the core driver.
>>>> I think that's an ideal solution, but requires big changes in the code.
>>>>
>>>> 2 is the current KVM implementation. See pt_save_msr()/pt_load_msr().
>>>> I don't think it's a right way. We'd better fix it.
>>>>
>>>> The suggestion should be 3. The KVM notify the PT driver via the
>>>> interface provided by PT. The PT driver save/restore all the registers.
>>>> I think it's an acceptable solution with small code changes.
>>>
>>> This looks like we just relocate the save/restore functions to the PT driver
>> and KVM still directly call them - still not going through perf's management.
>> Imagine every user operates on the pmu h/w directly like this, things would be
>> a mess.
>>>
>>
>>
>> The pt_event_stop() and the proposed interface still manipulate the PT event
>> pt->handle.event. The event status is updated as well. It's still under control of
>> the perf_event.
> 
> Did you mean to handle the PT event in the proposed driver API? Event status is just
> one of the things. There are other things if we want to make it complete for this,
> e.g. event->oncpu = -1, and eventually seems we will re-implement perf_event_disable_*.
>

As my understand, perf always check the status first. If it's a stopped
or inactivated event, I don't think event->oncpu will be touched. That's
why I think the proposed driver API should be acceptable.

> Btw, Xiaoyao has made it work with perf_event_disable_local, and don’t have that many changes.
> If necessary, we can post the 2nd version out to double check.
>

I'm not worry about which ways (either perf_event_disable_local() or the
proposed PT driver API) are chosen to stop the PT. If the existing
perf_event interfaces can meet your requirement, that's perfect.

My real concern is the pt_save_msr()/pt_load_msr(). I don't think it's a
job for KVM. See atomic_switch_perf_msrs(). It is the perf core driver
rather than KVM that tells which MSRs should be saved/restored in VMCS.
We should do the same thing for PT. (Actually, I think we already
encounter issues with the current KVM-dominated method. KVM
saves/restores unnecessary MSRs. Right?)

To do so, I think there may be two ways.
- Since MSRs have to be switched for both PT and core drivers, it sounds
reasonable to provide a new generic interface in the perf_event. The new
interface is to tell KVM which MSRs should be saved/restored. Then KVM
can decide to save/restore via VMCS or direct MSR access. I suspect this
way requires big change, but it will benefit all the drivers which have
similar requirements.
- The proposed driver API. The MSRs are saved/restored in the PT driver.


Thanks,
Kan
