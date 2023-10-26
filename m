Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B407D7ABC
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 04:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbjJZCON (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 22:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbjJZCOJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 22:14:09 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F0893;
        Wed, 25 Oct 2023 19:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698286447; x=1729822447;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rJeotgt3nrNaf9y/6niWwn7vOnD7IEENGknl61i47RU=;
  b=YK3ECjt6eEemgEO1fNUAMCUBhH66ObwmucnEPrsCzobn6xMBO6xzvQjX
   buKpiya5kKgOqqLwd3Pgf9xkp3oHX0MPzoMWwTTJafeIsWU0pk1sYgO2T
   bXx4/6y3VcUTJwlxRybXprlHXHCqMuCb4dhQCuWEEXK9CTMmgkmPAaRcJ
   8Uo6CuHyWa6oJTNyhTF1fbmQstLFXS3JigeckzpiwrsQhqwXaaKKGsNy9
   P+0ZpfQvFSAfDWa3PgQTkZpbU1muxVf5gJQUawUos7UrWx3VHv6mkQ2DO
   xkvTM52e+mvLEt9r5EzikoiB4Lh7G87Ztg+fyticUOuM8dfFXE6lXuAPF
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10874"; a="390300529"
X-IronPort-AV: E=Sophos;i="6.03,252,1694761200"; 
   d="scan'208";a="390300529"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 19:14:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10874"; a="788325962"
X-IronPort-AV: E=Sophos;i="6.03,252,1694761200"; 
   d="scan'208";a="788325962"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.20.184]) ([10.93.20.184])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 19:14:04 -0700
Message-ID: <99684975-6317-4233-b87b-14ca731b335a@linux.intel.com>
Date:   Thu, 26 Oct 2023 10:14:02 +0800
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
From:   "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <CALMp9eSX6OL9=9sgnKpNgRtuTV93A=G=u-5qT1_rpKFjL-dBNw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/25/2023 8:35 PM, Jim Mattson wrote:
> On Wed, Oct 25, 2023 at 4:23 AM Mi, Dapeng <dapeng1.mi@linux.intel.com> wrote:
>>
>> On 10/24/2023 9:03 PM, Jim Mattson wrote:
>>> On Tue, Oct 24, 2023 at 12:51 AM Dapeng Mi <dapeng1.mi@linux.intel.com> wrote:
>>>> Along with the CPU HW's upgrade and optimization, the count of LLC
>>>> misses event for running loop() helper could be 0 just like seen on
>>>> Sapphire Rapids.
>>>>
>>>> So modify the lower limit of possible count range for LLC misses
>>>> events to 0 to avoid LLC misses event test failure on Sapphire Rapids.
>>> I'm not convinced that these tests are really indicative of whether or
>>> not the PMU is working properly. If 0 is allowed for llc misses, for
>>> instance, doesn't this sub-test pass even when the PMU is disabled?
>>>
>>> Surely, we can do better.
>>
>> Considering the testing workload is just a simple adding loop, it's
>> reasonable and possible that it gets a 0 result for LLC misses and
>> branch misses events. Yeah, I agree the 0 count makes the results not so
>> credible. If we want to avoid these 0 count values, we may have to
>> complicate the workload, such as adding flush cache instructions, or
>> something like that (I'm not sure if there are instructions which can
>> force branch misses). How's your idea about this?
> CLFLUSH is probably a good way to ensure cache misses. IBPB may be a
> good way to ensure branch mispredictions, or IBRS on parts without
> eIBRS.


Thanks Jim for the information. I'm not familiar with IBPB/IBRS 
instructions, but just a glance, it looks there two instructions are 
some kind of advanced instructions,  Not all Intel CPUs support these 
instructions and not sure if AMD has similar instructions. It would be 
better if there are more generic instruction to trigger branch miss. 
Anyway I would look at the details and come back again.


>>>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>>>> ---
>>>>    x86/pmu.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/x86/pmu.c b/x86/pmu.c
>>>> index 0def28695c70..7443fdab5c8a 100644
>>>> --- a/x86/pmu.c
>>>> +++ b/x86/pmu.c
>>>> @@ -35,7 +35,7 @@ struct pmu_event {
>>>>           {"instructions", 0x00c0, 10*N, 10.2*N},
>>>>           {"ref cycles", 0x013c, 1*N, 30*N},
>>>>           {"llc references", 0x4f2e, 1, 2*N},
>>>> -       {"llc misses", 0x412e, 1, 1*N},
>>>> +       {"llc misses", 0x412e, 0, 1*N},
>>>>           {"branches", 0x00c4, 1*N, 1.1*N},
>>>>           {"branch misses", 0x00c5, 0, 0.1*N},
>>>>    }, amd_gp_events[] = {
>>>> --
>>>> 2.34.1
>>>>
