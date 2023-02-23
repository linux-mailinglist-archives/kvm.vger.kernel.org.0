Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 854C76A1084
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 20:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbjBWTY7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 14:24:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232161AbjBWTY4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 14:24:56 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED572A6F1
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 11:24:29 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id h14so2925579wru.4
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 11:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2WUW7m+MbriTC2U91BdHy5e/gS4PISvFC5pTDLmthLM=;
        b=ilbHouOcMp+Ekq6J6OxGkNWAHX+j0tnci9ZYJcNsD94BPqkA9VNn8wfF97nhtcNeQF
         Rd2z3EXCI0Sn7HT2F67rBc9ihauFrLPUUqsHyi9WvdDAlDGyQyhGwjYmvtHhY8gtCLbM
         Li0/DDwKlwYmlmD4opJ6zUJxEfc4I7ua8ZnD/hvSldueDmBpsmMHa86MWBnTtlC16u6g
         X4QwVXUOVq2nDuuTpcV2nua5qO8LYNbQT87/hjsRzekX24ggd5wHIVssJlS0cvZNWOYU
         s9xoaObEUEJ6Av3uydZz4xBCPm1svPwNbiSu/DgeNnfhuaxdVytpXwmZa8XfBTmdSXum
         0N4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2WUW7m+MbriTC2U91BdHy5e/gS4PISvFC5pTDLmthLM=;
        b=lrob8/mleqERgTf8/nLbYLkZyB+s2g3EWFms6XAcCO/E2VYOcxzlHka+1XRQuipDt2
         3g12XaEM7UCItuZ3Zof+jmwlwtOfgtR5zlvvVOrVTf02ByOWz+/6Jq4HZFJXbkHdvUhX
         YV7uUobvNGGAdUDnJOh8bUT3+pGdIST4Z3z8yZGEJNkErh6uYMkFs+kGR7bKd7DJo+PL
         P4PsykoYIkiR0+u7/6Dn2wJvVRk6SlA8IEDmXR8lk1vk0L1QIM91yxkAz7Bfi3XvpEYN
         6VPD86Mp3dcBCvzYnM6uDAn9JVqUImd81OgJP55QdXz3xvN6l8QCWDdGXkNqJ2VmGMRM
         ZUxw==
X-Gm-Message-State: AO0yUKW3fSzMXxpg0WACy7j+j7GHaxXy9j9Wc8Dk0M2F/oyq44WPD7V7
        7YEaLpaY4GybGslvrEP1BN5zKg==
X-Google-Smtp-Source: AK7set9p6BDFOcjNFXYyjjdbXmPAVFfJL/xQjIIlsS//FUfrvOZd8nYyaGDj0Mt2ghpDvo6g0B6b/w==
X-Received: by 2002:a5d:6645:0:b0:2c5:509b:dc54 with SMTP id f5-20020a5d6645000000b002c5509bdc54mr11486541wrw.0.1677180267855;
        Thu, 23 Feb 2023 11:24:27 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b566:0:5ee0:5af0:64bd:6198? ([2a02:6b6a:b566:0:5ee0:5af0:64bd:6198])
        by smtp.gmail.com with ESMTPSA id j21-20020a5d6e55000000b002c3f81c51b6sm12375109wrz.90.2023.02.23.11.24.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 11:24:27 -0800 (PST)
Message-ID: <97e1f2aa-d823-1aea-a41f-8024ba5075aa@bytedance.com>
Date:   Thu, 23 Feb 2023 19:24:26 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [External] Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, kim.phillips@amd.com
Cc:     arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com
References: <20230215145425.420125-1-usama.arif@bytedance.com>
 <62ee53770b4010f065346b7f2a1200013836be97.camel@infradead.org>
 <87a615mz2x.ffs@tglx>
 <701ce2da00e559d517d4e48bd5d88ccae1198e44.camel@infradead.org>
From:   Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <701ce2da00e559d517d4e48bd5d88ccae1198e44.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 23/02/2023 11:07, David Woodhouse wrote:
> On Wed, 2023-02-22 at 17:42 +0100, Thomas Gleixner wrote:
>> David!
>>
>> On Wed, Feb 22 2023 at 10:11, David Woodhouse wrote:
>>> On Wed, 2023-02-15 at 14:54 +0000, Usama Arif wrote:
>>> So the next thing that might be worth looking at is allowing the APs
>>> all to be running their hotplug thread simultaneously, bringing
>>> themselves from CPUHP_BRINGUP_CPU to CPUHP_AP_ONLINE. This series eats
>>> the initial INIT/SIPI/SIPI latency, but if there's any significant time
>>> in the AP hotplug thread, that could be worth parallelising.
>>
>> On a 112 CPU machine (64 cores, HT enabled) the bringup takes
>>
>> Setup and SIPIs sent:    49 ms
>> Bringup each CPU:       516 ms
>>
>> That's about 500 ms faster than a non-parallel bringup!
>>
>> Now looking at the 516 ms, which is ~4.7 ms/CPU. The vast majority of the
>> time is spent on the APs in
>>
>>       cpu_init() -> ucode_cpu_init()
>>
>> for the primary threads of each core. The secondary threads are quickly
>> (1us) out of ucode_cpu_init() because the primary thread already loaded
>> it.
>>
>> A microcode load on that machine takes ~7.5 ms per primary thread on
>> average which sums up to 7.5 * 55 = 412.5 ms
>>
>> The threaded bringup after CPU_AP_ONLINE takes about 100us per CPU.
> 
> Nice analysis; thanks!
> 
>> identify_secondary_cpu() is one of the longer functions which takes
>> ~125us / CPU summing up to 13ms
> 
> Hm, shouldn't that one already be parallelised by my 'part 2' patch?
> 
> It's called from smp_store_cpu_info(), from smp_callin(), which is
> called from somewhere in the middle of start_secondary().
> 
> And if the comments I helpfully added to that function for the benefit
> of our future selves are telling the truth, the AP is free to get that
> far once the BSP has set its bit in cpu_callout_mask, which happens in
> do_wait_cpu_initialized().
> 
> So
> https://git.infradead.org/users/dwmw2/linux.git/commitdiff/4b5731e05b0#patch3
> ought to parallelise that. But Usama emirically reported that 'part 2'
> didn't add any noticeable benefit, not even those 13ms? On a *larger*
> machine.
> 

So I am using a similar machine to Thomas 128 CPU machine (64 cores, HT 
enabled). I have microcode config disabled, so I guess I get similar 
numbers to Thomas, i.e. 100ms (516 - 412) ms. I do see a difference of 
~3ms with part2 which I thought is maybe within the margin of error for 
measuring, but I guess it isn't. After seeing the ~70ms that is cut with 
reusing timer calibration, I didnt really then focus much on part 2 
then. I guess that ~70ms is the "rest" from Thomas' table below?

Thanks,
Usama

> 
>> The TSC sync check for the first CPU on the second socket consumes
>> 20ms. That's only once per socket, intra socket is using MSR_TSC_ADJUST,
>> which is more or less free.
>>
>> So the 516 ms are wasted here:
>>
>>     total                                516 ms
>>     ucode_cpu_init()                     412 ms
>>     identify_secondary_cpu()              13 ms
>>     2ndsocket_tsc_sync                    20 ms
>>     threaded bringup                      12 ms
>>     rest                                  59 ms
>>
>> So the rest is about 530us per CPU, which is just the sum of many small
>> functions, lock contentions...
>>
>> Getting rid of the micro code overhead is possible. There is no reason
>> to serialize that between the cores. But it needs serialization vs. HT
>> siblings, which requires to move identify_secondary_cpu() and its caller
>> smp_store_cpu_info() ahead of the synchronization point and then have
>> serialization between the siblings. That's going to be a major surgery
>> and inspection effort to ensure that there are no hidden assumptions
>> about global hotplug serialization.
>>
>> So that would cut the total cost down to ~100ms plus the
>> preparatory/SIPI stage of 60ms which sums up to about 160ms and about
>> 1.5ms per CPU total.
>>
>> Further optimization starts to be questionable IMO. It's surely possible
>> somehow, but then you really have to go and inspect each and every
>> function in those code pathes, add local locking, etc. Not to talk about
>> the required mess in the core code to support that.
>>
>> The low hanging fruit which brings most is the identification/topology
>> muck and the microcode loading. That needs to be addressed first anyway.
> 
> Agreed, thanks.
> 
