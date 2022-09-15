Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E84A5B9F19
	for <lists+kvm@lfdr.de>; Thu, 15 Sep 2022 17:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiIOPnH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 11:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiIOPnD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 11:43:03 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E4E7F135;
        Thu, 15 Sep 2022 08:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663256582; x=1694792582;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=ltV9YD+8EvZckYWyi7wnqQrLyYlIjlXbaAzdbtFSvI0=;
  b=UKszOi2qF/jMgisW+gdDLZLoHlhUKUZz7/0agcPGg7M58F/neGbKkMx9
   78HWoaKrfS9nAd5n1G2lzESaroF0pk3MYEqxEftrAtAJmPfxM75Zq8Kwa
   NGqu3++tsFyVdF2HMw0re2mAujogmTPnsbCW+UQl+6lkYHgCbh14rVgbS
   2LVmMrj9ykMxpfnWnAmV8A3h7zFXzDK+7ykhoQq5CyDjMTo7nMlNfPdwy
   7tNZxPK6c4zrBLjj+ZUzqiJkbi1qbfxKmRmkLezuuBnIQlMTa7hHKmUl/
   TZxt02+WYQUlvjIiLT+X1OM1jCWnJ2+FJT4K4KaO+fKCs70ZZRgu0PNeJ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="385041955"
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="385041955"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 08:43:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="679568759"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga008.fm.intel.com with ESMTP; 15 Sep 2022 08:42:56 -0700
Received: from [10.252.210.17] (kliang2-mobl1.ccr.corp.intel.com [10.252.210.17])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id CAA2A580C38;
        Thu, 15 Sep 2022 08:42:54 -0700 (PDT)
Message-ID: <4c6a5663-778e-a509-638c-92cfd5315274@linux.intel.com>
Date:   Thu, 15 Sep 2022 11:42:53 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
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
From:   "Liang, Kan" <kan.liang@linux.intel.com>
Subject: Re: [RFC PATCH 0/2] KVM: VMX: Fix VM entry failure on
 PT_MODE_HOST_GUEST while host is using PT
In-Reply-To: <CY5PR11MB636535BE57F8CC07B1B2770DDC499@CY5PR11MB6365.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2022-09-15 10:39 a.m., Wang, Wei W wrote:
> On Thursday, September 15, 2022 9:55 PM Liang, Kan wrote:
>> On 2022-09-14 10:46 p.m., Wang, Wei W wrote:
>>> On Thursday, September 15, 2022 4:26 AM, Liang, Kan wrote:
>>>> The perf_event_disable() eventually invokes the intel_pt_stop().
>>>> We already expose the intel_pt_stop()/cpu_emergency_stop_pt() to
>>>> other modules. I don't think we have to use the perf_event_disable().
>>>> Also, the
>>>> perf_event_disable() requires extra codes.
>>>>
>>>> I went through the discussions. I agree with Sean's suggestion.
>>>> We should only put the logic in the KVM but all the MSR access
>>>> details into the PT driver.
>>>
>>> Even the driver itself doesn’t drive the save/restore of the MSRs, it is drived
>> by perf.
>>
>> It through perf_event, not driven by perf_event. The perf_event generic code
>> never knows when should invokes each driver to save/restore information. It
>> should be driven by the other subsystem e.g., scheduler.
> 
> Yes. The cpu scheduler does this via the perf subsystem, though.
> 
>>
>> For this case, KVM should drive the save/restore, and the PT driver eventually
>> does all the MSR access details.
>>
>>> 1. If we make KVM a user of perf, we should do this via
>> perf_event_disable/enable_*.
>>> 2. If we make KVM an alternative to perf (i.e. have direct control
>>> over PMU HW), we can do this via driver interfaces like perf.
>>> Per my experience, we should go for 1. Probably need Peter's opinions on
>> this.
>>>
>>
>> For 1, the perf_event_disable/enable_* are not enough. They don't
>> save/restore MSRs. 
> 
> perf_event_disable will go through perf to call pt_event_stop which saves the related MSRs, right?

I don't think so. The pt_event_stop() doesn't save all the
MSR_IA32_RTIT_* MSRs.

> (if so, what large changes did you mean?)
> 
>> If we go to this way, we have to introduce a new generic
>> interface to ask each driver to save/restore their MSRs when the guest is
>> entering/exiting. We'd better combine the new interface with the existing
>> perf_guest_get_msrs() of the core driver.
>> I think that's an ideal solution, but requires big changes in the code.
>>
>> 2 is the current KVM implementation. See pt_save_msr()/pt_load_msr(). I don't
>> think it's a right way. We'd better fix it.
>>
>> The suggestion should be 3. The KVM notify the PT driver via the interface
>> provided by PT. The PT driver save/restore all the registers.
>> I think it's an acceptable solution with small code changes.
> 
> This looks like we just relocate the save/restore functions to the PT driver and KVM still directly call them - still not going through perf's management. Imagine every user operates on the pmu h/w directly like this, things would be a mess.
> 


The pt_event_stop() and the proposed interface still manipulate the PT
event pt->handle.event. The event status is updated as well. It's still
under control of the perf_event.
While the current KVM implementation implicitly updates the MSRs without
updating the event status.

Also, KVM doesn't know the PT as well as the PT driver. It's better to
let the dedicated driver maintain the details. Otherwise, if we add more
MSRs later, we have to maintain both KVM and PT.

Thanks,
Kan
