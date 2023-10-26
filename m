Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11DE87D7AE5
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 04:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbjJZCaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 22:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjJZCaN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 22:30:13 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D22D8;
        Wed, 25 Oct 2023 19:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698287411; x=1729823411;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BN2P9oZIBpQVE+daOxwlLp98eLacdszXW6NwBh63YoA=;
  b=kim1VtKQ+4Eo0RVWRa2cEVchd+7xEb5ARVDsTfxd+D1djtXG7g82U0Yx
   8+/9OiclnOd6+wsaMjRkR3ZhRF3hMlNWTLmNk5gqE6oFjPV+PCrYxDc+T
   L5PUedHCP4FNvLiOIEN789WZk/IQU1IUR9jAF9rTocR4+88XsocggBwXB
   aKRUaeRrvRzyLD01jtdsXnMu++ymgvVIE3h7/Twb8VK/de24D9BaF/q39
   zJ/etReeOPImswq2dNlS1HbrAqen60dqm+BVPfW+wSjJLYeZFjvwp1U8c
   XzCgzw+jKcsjCiDt/2kL5swRWd+VSWuA1MX3K1373agoLDxPzWOk2Vlhd
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10874"; a="387269388"
X-IronPort-AV: E=Sophos;i="6.03,252,1694761200"; 
   d="scan'208";a="387269388"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 19:29:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10874"; a="882666548"
X-IronPort-AV: E=Sophos;i="6.03,252,1694761200"; 
   d="scan'208";a="882666548"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.20.184]) ([10.93.20.184])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 19:29:52 -0700
Message-ID: <7e6105e3-0baa-45e3-bedf-9e129c1bf93d@linux.intel.com>
Date:   Thu, 26 Oct 2023 10:29:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests Patch 4/5] x86: pmu: Support validation for Intel
 PMU fixed counter 3
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
 <20231024075748.1675382-5-dapeng1.mi@linux.intel.com>
 <CALMp9eSQyyihzEz+xpB0QCZ4=WqQ9TGiSwMYiFob0D_Z7OY7mg@mail.gmail.com>
 <305f1ee4-a8c3-48eb-9368-531329e5266e@linux.intel.com>
 <CALMp9eT94bGZFr3sfPAssh4jJLnLe4jGosRieGVb4pK1E31b5Q@mail.gmail.com>
From:   "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <CALMp9eT94bGZFr3sfPAssh4jJLnLe4jGosRieGVb4pK1E31b5Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/25/2023 8:38 PM, Jim Mattson wrote:
> On Wed, Oct 25, 2023 at 4:26 AM Mi, Dapeng <dapeng1.mi@linux.intel.com> wrote:
>>
>> On 10/25/2023 3:05 AM, Jim Mattson wrote:
>>> On Tue, Oct 24, 2023 at 12:51 AM Dapeng Mi <dapeng1.mi@linux.intel.com> wrote:
>>>> Intel CPUs, like Sapphire Rapids, introduces a new fixed counter
>>>> (fixed counter 3) to counter/sample topdown.slots event, but current
>>>> code still doesn't cover this new fixed counter.
>>>>
>>>> So add code to validate this new fixed counter.
>>> Can you explain how this "validates" anything?
>>
>> I may not describe the sentence clearly. This would validate the fixed
>> counter 3 can count the slots event and get a valid count in a
>> reasonable range. Thanks.
> I thought the current vPMU implementation did not actually support
> top-down slots. If it doesn't work, how can it be validated?

Ops, you reminds me, I just made a mistake, the kernel which I used 
includes the vtopdown supporting patches, so the topdown slots is 
supported. Since there are big arguments on the original vtopdown RFC 
patches,  the topdown metrics feature is probably not to be supported in 
current vPMU emulation framework, but the slots events support patches 
(the former two patches 
https://lore.kernel.org/all/20230927033124.1226509-1-dapeng1.mi@linux.intel.com/T/#m53883e39177eb9a0d8e23e4c382ddc6190c7f0f4 
and 
https://lore.kernel.org/all/20230927033124.1226509-1-dapeng1.mi@linux.intel.com/T/#m1d9c433eb6ce83b32e50f6d976fbfeee2b731fb9) 
are still valuable and just a small piece of work and doesn't touch any 
perf code. I'd like split these two patches into an independent patchset 
and resend to LKML.

>
>>>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>>>> ---
>>>>    x86/pmu.c | 3 ++-
>>>>    1 file changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/x86/pmu.c b/x86/pmu.c
>>>> index 1bebf493d4a4..41165e168d8e 100644
>>>> --- a/x86/pmu.c
>>>> +++ b/x86/pmu.c
>>>> @@ -46,7 +46,8 @@ struct pmu_event {
>>>>    }, fixed_events[] = {
>>>>           {"fixed 1", MSR_CORE_PERF_FIXED_CTR0, 10*N, 10.2*N},
>>>>           {"fixed 2", MSR_CORE_PERF_FIXED_CTR0 + 1, 1*N, 30*N},
>>>> -       {"fixed 3", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 30*N}
>>>> +       {"fixed 3", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 30*N},
>>>> +       {"fixed 4", MSR_CORE_PERF_FIXED_CTR0 + 3, 1*N, 100*N}
>>>>    };
>>>>
>>>>    char *buf;
>>>> --
>>>> 2.34.1
>>>>
