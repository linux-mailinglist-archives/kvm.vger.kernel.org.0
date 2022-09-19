Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8575BC35E
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 09:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiISHJf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 03:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiISHJd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 03:09:33 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F55BA6
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 00:09:32 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id t70so25960859pgc.5
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 00:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=/ThA6gQddm7dJ9y9JlV7UikTDxzSqWQqGfeXbhTUDKI=;
        b=ArDAzma3jlcP39xtWGqI/PaA2Us7qDq9LVRFA5/jOZ/wQLIBH1EMuElHWxfhZaWAEH
         3IGLLUzo+h8K+DXzKNAT+Lu4hMczI6+9+eWizE8jKStPrZdGdDQldxMqpKdCnqGX/JUT
         /KjE0yat4FevUt7BH6LqlFplfSdCxeXor4qDI3JWxYbBE0PBnPswhu5sFN643+AEprPx
         3+KtFmgU4Qhb7+563+w7Kf5p4/FTgDX5jVvf96UaezKw4ubrcAFJetnPu42RFXksRgCd
         qUI21Yp1MejOpnLOs7QHgkybbbef1FKeBvBy5nA4ahIeLlDPeGGdGZzCIORhmr8gf62b
         HOFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=/ThA6gQddm7dJ9y9JlV7UikTDxzSqWQqGfeXbhTUDKI=;
        b=IYwaeeQfLNh9MYbDYD105i775qYmWUqQzYVlakP5uWuNgch3xnCVNqEVrcI6uaMkhz
         4RNV7NTOWG0ZKoKS2uOKpOrWa/4ykPq4HaF/MC5CV/zkc4emlQaIXHlsobla0u5oOWvh
         /Ym4qynQFh4V47IiI1Gi/xTiIfFJqNiWsuYMQb5SZFrrTuYUhdEi6o/2KHAMRKu10u6c
         luc6dg/V1/ah1aW0eM22n8GSdbKaFmf7ZRh69lvQJtYLtOBjzyaq8X7JxEOJ7rbU1DVs
         a36BiTpRXG97pfGGIC3nUiwvjg5KImDBBvtnxWla4HPsJuNzWpOsII4sCVu/ayfkQZ3I
         qDXg==
X-Gm-Message-State: ACrzQf1uAsvF4zyTawv8amEc6Dpw5Rc/uHTppaSKoYTNqdnv68smWvIs
        28Q9wTrkUqO7JXpk9otcGH0=
X-Google-Smtp-Source: AMsMyM6n1069SjDsD3QwR7lKf8KzfJV5wXxRp0fi8h4TIYGraX0aa5j15RMWUZ8mbZVACo8S1c3WRA==
X-Received: by 2002:a63:e711:0:b0:438:ebbe:4a94 with SMTP id b17-20020a63e711000000b00438ebbe4a94mr14596561pgi.0.1663571371474;
        Mon, 19 Sep 2022 00:09:31 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id a13-20020a170902710d00b00178323e689fsm14723272pll.171.2022.09.19.00.09.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 00:09:30 -0700 (PDT)
Message-ID: <991bf043-3c5e-09f6-9080-ce8ae5c819e7@gmail.com>
Date:   Mon, 19 Sep 2022 15:09:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH v3 10/13] x86/pmu: Update testcases to
 cover Intel Arch PMU Version 1
Content-Language: en-US
To:     Sandipan Das <sandipan.das@amd.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
References: <20220819110939.78013-1-likexu@tencent.com>
 <20220819110939.78013-11-likexu@tencent.com>
 <0666abab-ed22-6708-a794-de5449d049f1@amd.com>
 <a1e202f0-260e-fe00-4e39-42e390d4021b@gmail.com>
 <27ef941b-05df-7fa4-a54e-8571b0bf70e7@amd.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <27ef941b-05df-7fa4-a54e-8571b0bf70e7@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/9/2022 4:23 pm, Sandipan Das wrote:
> On 9/6/2022 7:05 PM, Like Xu wrote:
>> On 6/9/2022 4:16 pm, Sandipan Das wrote:
>>> Hi Like,
>>>
>>> On 8/19/2022 4:39 PM, Like Xu wrote:
>>>> From: Like Xu <likexu@tencent.com>
>>>>
>>>> For most unit tests, the basic framework and use cases which test
>>>> any PMU counter do not require any changes, except for two things:
>>>>
>>>> - No access to registers introduced only in PMU version 2 and above;
>>>> - Expanded tolerance for testing counter overflows
>>>>     due to the loss of uniform control of the gloabl_ctrl register
>>>>
>>>> Adding some pmu_version() return value checks can seamlessly support
>>>> Intel Arch PMU Version 1, while opening the door for AMD PMUs tests.
>>>>
>>>> Signed-off-by: Like Xu <likexu@tencent.com>
>>>> ---
>>>>    x86/pmu.c | 64 +++++++++++++++++++++++++++++++++++++------------------
>>>>    1 file changed, 43 insertions(+), 21 deletions(-)
>>>>
>>>> [...]
>>>> @@ -327,13 +335,21 @@ static void check_counter_overflow(void)
>>>>                cnt.config &= ~EVNTSEL_INT;
>>>>            idx = event_to_global_idx(&cnt);
>>>>            __measure(&cnt, cnt.count);
>>>> -        report(cnt.count == 1, "cntr-%d", i);
>>>> +
>>>> +        report(check_irq() == (i % 2), "irq-%d", i);
>>>> +        if (pmu_version() > 1)
>>>> +            report(cnt.count == 1, "cntr-%d", i);
>>>> +        else
>>>> +            report(cnt.count < 4, "cntr-%d", i);
>>>> +
>>>> [...]
>>>
>>> Sorry I missed this in the previous response. With an upper bound of
>>> 4, I see this test failing some times for at least one of the six
>>> counters (with NMI watchdog disabled on the host) on a Milan (Zen 3)
>>> system. Increasing it further does reduce the probability but I still
>>> see failures. Do you see the same behaviour on systems with Zen 3 and
>>> older processors?
>>
>> A hundred runs on my machine did not report a failure.
>>
> 
> Was this on a Zen 4 system?
> 
>> But I'm not surprised by this, because some AMD platforms do
>> have hw PMU errata which requires bios or ucode fixes.
>>
>> Please help find the right upper bound for all your available AMD boxes.
>>
> 
> Even after updating the microcode, the tests failed just as often in an
> overnight loop. However, upon closer inspection, the reason for failure
> was different. The variance is well within the bounds now but sometimes,
> is_the_count_reproducible() is true. Since this selects the original
> verification criteria (cnt.count == 1), the tests fail.
> 
>> What makes me most nervous is that AMD's core hardware events run
>> repeatedly against the same workload, and their count results are erratic.
>>
> 
> With that in mind, should we consider having the following change?
> 
> diff --git a/x86/pmu.c b/x86/pmu.c
> index bb16b3c..39979b8 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -352,7 +352,7 @@ static void check_counter_overflow(void)
>                  .ctr = gp_counter_base,
>                  .config = EVNTSEL_OS | EVNTSEL_USR | (*gp_events)[1].unit_sel /* instructions */,
>          };
> -       bool precise_event = is_the_count_reproducible(&cnt);
> +       bool precise_event = is_intel() ? is_the_count_reproducible(&cnt) : false;
> 
>          __measure(&cnt, 0);
>          count = cnt.count;
> 
> With this, the tests always pass. I will run another overnight loop and
> report back if I see any errors.
> 
>> You may check is_the_count_reproducible() in the test case:
>> [1]https://lore.kernel.org/kvm/20220905123946.95223-7-likexu@tencent.com/
> 
> On Zen 4 systems, this is always false and the overflow tests always
> pass irrespective of whether PerfMonV2 is enabled for the guest or not.
> 
> - Sandipan

I could change it to:

		if (is_intel())
			report(cnt.count == 1, "cntr-%d", i);
		else
			report(cnt.count < 4, "cntr-%d", i);

but this does not explain the difference, that is for the same workload:

if a retired hw event like "PMCx0C0 [Retired Instructions] (ExRetInstr)" is 
configured,
then it's expected to count "the number of instructions retired", the value is 
only relevant
for workload and it should remain the same over multiple measurements,

but there are two hardware counters, one AMD and one Intel, both are reset to an 
identical value
(like "cnt.count = 1 - count"), and when they overflow, the Intel counter can 
stay exactly at 1,
while the AMD counter cannot.

I know there are ulterior hardware micro-arch implementation differences here,
but what AMD is doing violates the semantics of "retired".

Is this behavior normal by design ?
I'm not sure what I'm missing, this behavior is reinforced in zen4 as you said.
