Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403477D9505
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 12:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345616AbjJ0KRl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 06:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231487AbjJ0KRk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 06:17:40 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D187818A;
        Fri, 27 Oct 2023 03:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698401858; x=1729937858;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ovH31mpxEu8DVpROwawryGv3U0nz8LD/NUhAxN46fTI=;
  b=nYLUaBL/5Ko63rNcACQmm92qAGS8FqJngptzfnjJ4MrR0CuflOtuhcbe
   HuCpg08E3Ixxz43PS6NUeRJuWsTwIZxOdeejpEOCPg0OfHiC9/FH4boji
   o9YFHCmathUNvXYNdm+gA6ASwCwJZvuxyiC1MTmKMTvv02CPO8tmgXDRm
   T1GhVIvgoqKc0wSKSSY3KwP+WGgZRV4Cm62wIieGqjD2LBmu9DOdIAzeD
   8uy4McYUx3a+F3Qud9xqBEC79P2lYFJ3BZnK0/2yoxL6GYmPkaE+i8uOS
   sex1kvFQXk5rhBKjdT7u4MNjo2eXmSKGyyEMuSgamp9j7CEIrU6UAjOFV
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10875"; a="367958824"
X-IronPort-AV: E=Sophos;i="6.03,255,1694761200"; 
   d="scan'208";a="367958824"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 03:17:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,255,1694761200"; 
   d="scan'208";a="7609778"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.26.29]) ([10.93.26.29])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 03:17:22 -0700
Message-ID: <a2483e6e-c5fe-4604-9aaa-db2a1df8fa77@linux.intel.com>
Date:   Fri, 27 Oct 2023 18:17:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests Patch 2/5] x86: pmu: Change the minimum value of
 llc_misses event to 0
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Mingwei Zhang <mizhang@google.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Dapeng Mi <dapeng1.mi@intel.com>
References: <20231024075748.1675382-1-dapeng1.mi@linux.intel.com>
 <20231024075748.1675382-3-dapeng1.mi@linux.intel.com>
 <CALMp9eRqGr+5+C1OLhxv1i8Q=YVRmFxkZQJoh7HzWkPg2z=WoA@mail.gmail.com>
 <6132ba52-fdf1-4680-9e4e-5ea2fcb63b3c@linux.intel.com>
 <CALMp9eSX6OL9=9sgnKpNgRtuTV93A=G=u-5qT1_rpKFjL-dBNw@mail.gmail.com>
 <99684975-6317-4233-b87b-14ca731b335a@linux.intel.com>
 <CALMp9eRdiyHQjiSRufKvBLHhXQ9LgTpNO8djETZ9tSYZR_FBFg@mail.gmail.com>
From:   "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <CALMp9eRdiyHQjiSRufKvBLHhXQ9LgTpNO8djETZ9tSYZR_FBFg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/26/2023 8:19 PM, Jim Mattson wrote:
> On Wed, Oct 25, 2023 at 7:14 PM Mi, Dapeng <dapeng1.mi@linux.intel.com> wrote:
>>
>> On 10/25/2023 8:35 PM, Jim Mattson wrote:
>>> On Wed, Oct 25, 2023 at 4:23 AM Mi, Dapeng <dapeng1.mi@linux.intel.com> wrote:
>>>> On 10/24/2023 9:03 PM, Jim Mattson wrote:
>>>>> On Tue, Oct 24, 2023 at 12:51 AM Dapeng Mi <dapeng1.mi@linux.intel.com> wrote:
>>>>>> Along with the CPU HW's upgrade and optimization, the count of LLC
>>>>>> misses event for running loop() helper could be 0 just like seen on
>>>>>> Sapphire Rapids.
>>>>>>
>>>>>> So modify the lower limit of possible count range for LLC misses
>>>>>> events to 0 to avoid LLC misses event test failure on Sapphire Rapids.
>>>>> I'm not convinced that these tests are really indicative of whether or
>>>>> not the PMU is working properly. If 0 is allowed for llc misses, for
>>>>> instance, doesn't this sub-test pass even when the PMU is disabled?
>>>>>
>>>>> Surely, we can do better.
>>>> Considering the testing workload is just a simple adding loop, it's
>>>> reasonable and possible that it gets a 0 result for LLC misses and
>>>> branch misses events. Yeah, I agree the 0 count makes the results not so
>>>> credible. If we want to avoid these 0 count values, we may have to
>>>> complicate the workload, such as adding flush cache instructions, or
>>>> something like that (I'm not sure if there are instructions which can
>>>> force branch misses). How's your idea about this?
>>> CLFLUSH is probably a good way to ensure cache misses. IBPB may be a
>>> good way to ensure branch mispredictions, or IBRS on parts without
>>> eIBRS.
>>
>> Thanks Jim for the information. I'm not familiar with IBPB/IBRS
>> instructions, but just a glance, it looks there two instructions are
>> some kind of advanced instructions,  Not all Intel CPUs support these
>> instructions and not sure if AMD has similar instructions. It would be
>> better if there are more generic instruction to trigger branch miss.
>> Anyway I would look at the details and come back again.
> IBPB and IBRS are not instructions. IBPB (indirect branch predictor
> barrier) is triggered by setting bit 0 of the IA32_PRED_CMD MSR. IBRS
> (indirect branch restricted speculation) is triggered by setting bit 0
> of the IA32_SPEC_CTRL MSR. It is true that the desired behavior of
> IBRS (causing branch mispredictions) is only exhibited by certain
> older parts. However, IBPB is now universally available, as it is
> necessary to mitigate many speculative execution attacks. For Intel
> documentation, see
> https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/cpuid-enumeration-and-architectural-msrs.html.
>
> If you don't want to use these, you could train a branch to go one way
> prior to measurement, and then arrange for the branch under test go
> the other way.


Thanks Jim. From my point of view, IBPB is still some kind of extended 
feature which may be not supported on some older platforms. Considering 
kvm-unit-tests could still be run on these old platforms, IBPB seems not 
the best choice. I'm thinking an alternative way is to use the 'rdrand' 
instruction to get a random value, and then call jmp instruction base on 
the random value results. That would definitely cause branch misses. 
This looks more generic.


>
>>>>>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>>>>>> ---
>>>>>>     x86/pmu.c | 2 +-
>>>>>>     1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/x86/pmu.c b/x86/pmu.c
>>>>>> index 0def28695c70..7443fdab5c8a 100644
>>>>>> --- a/x86/pmu.c
>>>>>> +++ b/x86/pmu.c
>>>>>> @@ -35,7 +35,7 @@ struct pmu_event {
>>>>>>            {"instructions", 0x00c0, 10*N, 10.2*N},
>>>>>>            {"ref cycles", 0x013c, 1*N, 30*N},
>>>>>>            {"llc references", 0x4f2e, 1, 2*N},
>>>>>> -       {"llc misses", 0x412e, 1, 1*N},
>>>>>> +       {"llc misses", 0x412e, 0, 1*N},
>>>>>>            {"branches", 0x00c4, 1*N, 1.1*N},
>>>>>>            {"branch misses", 0x00c5, 0, 0.1*N},
>>>>>>     }, amd_gp_events[] = {
>>>>>> --
>>>>>> 2.34.1
>>>>>>
