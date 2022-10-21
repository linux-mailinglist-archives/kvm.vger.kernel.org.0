Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF5F60712C
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 09:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiJUHcq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 03:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiJUHco (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 03:32:44 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4708821F95F
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 00:32:43 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id g28so1823626pfk.8
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 00:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GBh09c5bp2M8+imG6DX1mt6urttUKIOXRq8kmVafKg4=;
        b=VArgmKxavtvoJux29yQwsi49bZTx04on3l4b4zuUJxJVsYJ3qN3np405DIL2mqylTg
         kPvJ1RtOR8dR2yqbnVr8R+wfGT3VMD1RPS/CrvQhqNbsMdjGpiJPX8TnD5fF1lLFjBij
         lDtitTNGeNdNS8+pomTia6Vv70P1AKMOm3rvSzej0NQ5+DsiVkbpcXDMXfT5IvjmSPNa
         BQNvBhRTj+a1P0CCjsjyDY7mGIUIPT/FJiF5Fw3yZpeYnpbT47PwIpJd3pcCiiZSMhx/
         keAPrAE/zNyjsmNdup2/ZWputkbW0V3WawiqxPRWwxDOkvy8d7Uv4EjPdStsPkG69ud9
         gjVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GBh09c5bp2M8+imG6DX1mt6urttUKIOXRq8kmVafKg4=;
        b=6qN6MROGYZaag986ZF3nwuTtFNQiz/4PNqcJsgVykl3YYZ+j4ROMvF4ZvSUpAhylJj
         kBtU3htDq5n2ukE4GDkHqG5rKSXHstbBa9wh3/+laKgWP/nM8+ObehxqkK0DCIDJMB4y
         jaJIQfxDRb3Oeuv6rUwjpJiDeobE7M2EfOdEv7DVF6+sdJP+2O9lOvKUKtg/E20uNatu
         T9C9NXVyHDbheM6wQRGVb/RJbr25qE/7Iig6xPiyLSupr5cvFUkR1VwsviVbhzqoseyZ
         ZOe6aS83xqdxlfcPeGt0SIYajmTHrpa8n8Klf5r0iCDJXOde413NXnnbb7myONraRbpa
         pmQQ==
X-Gm-Message-State: ACrzQf2lmJUfVdApQI2P/OdwQ7ke5RtMyGXb37CmyM2mSAAoK8Iqi4SL
        sapGQFZXdqYzFc9mH/rGUCY=
X-Google-Smtp-Source: AMsMyM6gA3KL/VCz1kns7cnMYB5cciz+4JiYiNwhMd7pAyzNLL3sCRHFsrxTZ9qDVPmZOR159ldCsA==
X-Received: by 2002:a63:8:0:b0:460:e669:a0c4 with SMTP id 8-20020a630008000000b00460e669a0c4mr15238532pga.475.1666337562733;
        Fri, 21 Oct 2022 00:32:42 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id y8-20020a170902b48800b0018099c9618esm2837684plr.231.2022.10.21.00.32.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Oct 2022 00:32:42 -0700 (PDT)
Message-ID: <0210ab19-78b0-d036-687d-1201abc2c732@gmail.com>
Date:   Fri, 21 Oct 2022 15:32:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.3
Subject: Re: [kvm-unit-tests PATCH v3 10/13] x86/pmu: Update testcases to
 cover Intel Arch PMU Version 1
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
To:     Sandipan Das <sandipan.das@amd.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
References: <20220819110939.78013-1-likexu@tencent.com>
 <20220819110939.78013-11-likexu@tencent.com>
 <0666abab-ed22-6708-a794-de5449d049f1@amd.com>
 <a1e202f0-260e-fe00-4e39-42e390d4021b@gmail.com>
 <27ef941b-05df-7fa4-a54e-8571b0bf70e7@amd.com>
 <991bf043-3c5e-09f6-9080-ce8ae5c819e7@gmail.com>
In-Reply-To: <991bf043-3c5e-09f6-9080-ce8ae5c819e7@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sandipan,

On 19/9/2022 3:09 pm, Like Xu wrote:
> On 8/9/2022 4:23 pm, Sandipan Das wrote:
>> On 9/6/2022 7:05 PM, Like Xu wrote:
>>> On 6/9/2022 4:16 pm, Sandipan Das wrote:
>>>> Hi Like,
>>>>
>>>> On 8/19/2022 4:39 PM, Like Xu wrote:
>>>>> From: Like Xu <likexu@tencent.com>
>>>>>
>>>>> For most unit tests, the basic framework and use cases which test
>>>>> any PMU counter do not require any changes, except for two things:
>>>>>
>>>>> - No access to registers introduced only in PMU version 2 and above;
>>>>> - Expanded tolerance for testing counter overflows
>>>>>     due to the loss of uniform control of the gloabl_ctrl register
>>>>>
>>>>> Adding some pmu_version() return value checks can seamlessly support
>>>>> Intel Arch PMU Version 1, while opening the door for AMD PMUs tests.
>>>>>
>>>>> Signed-off-by: Like Xu <likexu@tencent.com>
>>>>> ---
>>>>>    x86/pmu.c | 64 +++++++++++++++++++++++++++++++++++++------------------
>>>>>    1 file changed, 43 insertions(+), 21 deletions(-)
>>>>>
>>>>> [...]
>>>>> @@ -327,13 +335,21 @@ static void check_counter_overflow(void)
>>>>>                cnt.config &= ~EVNTSEL_INT;
>>>>>            idx = event_to_global_idx(&cnt);
>>>>>            __measure(&cnt, cnt.count);
>>>>> -        report(cnt.count == 1, "cntr-%d", i);
>>>>> +
>>>>> +        report(check_irq() == (i % 2), "irq-%d", i);
>>>>> +        if (pmu_version() > 1)
>>>>> +            report(cnt.count == 1, "cntr-%d", i);
>>>>> +        else
>>>>> +            report(cnt.count < 4, "cntr-%d", i);
>>>>> +
>>>>> [...]
>>>>
>>>> Sorry I missed this in the previous response. With an upper bound of
>>>> 4, I see this test failing some times for at least one of the six
>>>> counters (with NMI watchdog disabled on the host) on a Milan (Zen 3)
>>>> system. Increasing it further does reduce the probability but I still
>>>> see failures. Do you see the same behaviour on systems with Zen 3 and
>>>> older processors?
>>>
>>> A hundred runs on my machine did not report a failure.
>>>
>>
>> Was this on a Zen 4 system?
>>
>>> But I'm not surprised by this, because some AMD platforms do
>>> have hw PMU errata which requires bios or ucode fixes.
>>>
>>> Please help find the right upper bound for all your available AMD boxes.
>>>
>>
>> Even after updating the microcode, the tests failed just as often in an
>> overnight loop. However, upon closer inspection, the reason for failure
>> was different. The variance is well within the bounds now but sometimes,
>> is_the_count_reproducible() is true. Since this selects the original
>> verification criteria (cnt.count == 1), the tests fail.
>>
>>> What makes me most nervous is that AMD's core hardware events run
>>> repeatedly against the same workload, and their count results are erratic.
>>>
>>
>> With that in mind, should we consider having the following change?
>>
>> diff --git a/x86/pmu.c b/x86/pmu.c
>> index bb16b3c..39979b8 100644
>> --- a/x86/pmu.c
>> +++ b/x86/pmu.c
>> @@ -352,7 +352,7 @@ static void check_counter_overflow(void)
>>                  .ctr = gp_counter_base,
>>                  .config = EVNTSEL_OS | EVNTSEL_USR | (*gp_events)[1].unit_sel 
>> /* instructions */,
>>          };
>> -       bool precise_event = is_the_count_reproducible(&cnt);
>> +       bool precise_event = is_intel() ? is_the_count_reproducible(&cnt) : 
>> false;
>>
>>          __measure(&cnt, 0);
>>          count = cnt.count;
>>
>> With this, the tests always pass. I will run another overnight loop and
>> report back if I see any errors.
>>
>>> You may check is_the_count_reproducible() in the test case:
>>> [1]https://lore.kernel.org/kvm/20220905123946.95223-7-likexu@tencent.com/
>>
>> On Zen 4 systems, this is always false and the overflow tests always
>> pass irrespective of whether PerfMonV2 is enabled for the guest or not.
>>
>> - Sandipan
> 
> I could change it to:
> 
>          if (is_intel())
>              report(cnt.count == 1, "cntr-%d", i);
>          else
>              report(cnt.count < 4, "cntr-%d", i);

On AMD (zen3/zen4) machines this seems to be the only way to ensure that the 
test cases don't fail:

		if (is_intel())
			report(cnt.count == 1, "cntr-%d", i);
		else
			report(cnt.count == 0xffffffffffff || cnt.count < 7, "cntr-%d", i);

but it means some hardware counter defects, can you further confirm that this 
hardware behaviour
is in line with your expectations ?

> 
> but this does not explain the difference, that is for the same workload:
> 
> if a retired hw event like "PMCx0C0 [Retired Instructions] (ExRetInstr)" is 
> configured,
> then it's expected to count "the number of instructions retired", the value is 
> only relevant
> for workload and it should remain the same over multiple measurements,
> 
> but there are two hardware counters, one AMD and one Intel, both are reset to an 
> identical value
> (like "cnt.count = 1 - count"), and when they overflow, the Intel counter can 
> stay exactly at 1,
> while the AMD counter cannot.
> 
> I know there are ulterior hardware micro-arch implementation differences here,
> but what AMD is doing violates the semantics of "retired".
> 
> Is this behavior normal by design ?
> I'm not sure what I'm missing, this behavior is reinforced in zen4 as you said.
> 
