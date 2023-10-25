Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3FA77D69F5
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 13:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234446AbjJYLXF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 07:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232076AbjJYLXE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 07:23:04 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606B3AC;
        Wed, 25 Oct 2023 04:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698232982; x=1729768982;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CZg24sm7bW9fHsCSHaWFydwaTAPtdesmJoU4Yu4b6n8=;
  b=VMgcg73FlyVtlNW6f8icUfjFfKdq5m1xFo+xQ8LcPet/ZAt56iYojmKs
   DMjDvfphZ5qmmtEN/Q9aVJRaz8ezqrZ0vNsPmn23DBVjeKPot9sFZcfd3
   yymxhfpJt0yukcK0tzm1URG+fV33DvII2+H2AzlaszXpivSnlLHEudhoE
   5oslbwgGREbz5L2wgCvua62vU+6AINAHsv/t4Fux/0xqaTbAcUeUVMra4
   icF58eG7yeo+Xi+9ofgKUPlGEdzkTWV89SO7HnAfcsFDs77yb0jJ65L2a
   criBnhktrYfyUeNutfHaL5xLP9r9ZoBhK6XzgOlLV/r0HPXgYS2Ln53Fd
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="386170339"
X-IronPort-AV: E=Sophos;i="6.03,250,1694761200"; 
   d="scan'208";a="386170339"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 04:23:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="1005984943"
X-IronPort-AV: E=Sophos;i="6.03,250,1694761200"; 
   d="scan'208";a="1005984943"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.25.165]) ([10.93.25.165])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 04:22:58 -0700
Message-ID: <6132ba52-fdf1-4680-9e4e-5ea2fcb63b3c@linux.intel.com>
Date:   Wed, 25 Oct 2023 19:22:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests Patch 2/5] x86: pmu: Change the minimum value of
 llc_misses event to 0
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
Content-Language: en-US
From:   "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <CALMp9eRqGr+5+C1OLhxv1i8Q=YVRmFxkZQJoh7HzWkPg2z=WoA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/24/2023 9:03 PM, Jim Mattson wrote:
> On Tue, Oct 24, 2023 at 12:51 AM Dapeng Mi <dapeng1.mi@linux.intel.com> wrote:
>> Along with the CPU HW's upgrade and optimization, the count of LLC
>> misses event for running loop() helper could be 0 just like seen on
>> Sapphire Rapids.
>>
>> So modify the lower limit of possible count range for LLC misses
>> events to 0 to avoid LLC misses event test failure on Sapphire Rapids.
> I'm not convinced that these tests are really indicative of whether or
> not the PMU is working properly. If 0 is allowed for llc misses, for
> instance, doesn't this sub-test pass even when the PMU is disabled?
>
> Surely, we can do better.


Considering the testing workload is just a simple adding loop, it's 
reasonable and possible that it gets a 0 result for LLC misses and 
branch misses events. Yeah, I agree the 0 count makes the results not so 
credible. If we want to avoid these 0 count values, we may have to 
complicate the workload, such as adding flush cache instructions, or 
something like that (I'm not sure if there are instructions which can 
force branch misses). How's your idea about this?


>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> ---
>>   x86/pmu.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/x86/pmu.c b/x86/pmu.c
>> index 0def28695c70..7443fdab5c8a 100644
>> --- a/x86/pmu.c
>> +++ b/x86/pmu.c
>> @@ -35,7 +35,7 @@ struct pmu_event {
>>          {"instructions", 0x00c0, 10*N, 10.2*N},
>>          {"ref cycles", 0x013c, 1*N, 30*N},
>>          {"llc references", 0x4f2e, 1, 2*N},
>> -       {"llc misses", 0x412e, 1, 1*N},
>> +       {"llc misses", 0x412e, 0, 1*N},
>>          {"branches", 0x00c4, 1*N, 1.1*N},
>>          {"branch misses", 0x00c5, 0, 0.1*N},
>>   }, amd_gp_events[] = {
>> --
>> 2.34.1
>>
