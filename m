Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAEE5AEA44
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 15:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234243AbiIFNl3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 09:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233093AbiIFNkU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 09:40:20 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BEA7D1CF
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 06:37:13 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id t70so4842981pgc.5
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 06:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=fwgMzl84RkvLtUyzDRO6AYZuKRh3Mtj6DS3co+Xz3yQ=;
        b=aCFDVWQRb6MKZF4pAtk4YBXwSg2Bn1VEb1dd3CYg26zvWm/GTJCKheeFEUBXaG02Bd
         t7Jfi4jDfX9S4PR4JR7+PFtJQ56IUOJS8AqRH83qSqRqVyHHvNPftBKJijaFwpzM2L4K
         zXawKso2oGyOwH7bw7eSqsU5hnuhEjsKucCHQyGrs0YTH/lKUAgRLKLOfLUZJ4+DGzX8
         1fCLyW23Kt/Qb97MDCIvUXljI3xo+xbw7jqHYHWX9f38AU2MQJduiA+OXz/6KOYhbCPV
         9Gu4QcQyZ226F/5Z7bsaMl7yUFjvM1v3gSnkZIJasrxSzAN2FY94a3Y4pYw/aFeeccGM
         y8GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=fwgMzl84RkvLtUyzDRO6AYZuKRh3Mtj6DS3co+Xz3yQ=;
        b=rjx8BCLXYxEp8c9TzUtqXRmtSstwpJ9ETAfIiSvD1pCJ+DgshwcHHkziX+5xYL0xI7
         uq5nYx+X5HFO6bNJZkf9bsKpW5vgZFCNnVC6E/mdm8qE3ZM8JuK8US5DKPa0YzuaKnIX
         ksTN9sTUacaFGdIxEPwu1OJTTBg9zAkMz5HBiM39asGjDP3abwENG7CYstlBiZ610587
         I4bg8s8rw8rMG90L6AJsBTpwnKoFZife5yxVlYmWLcuQsqlijaas2zpoqvJGzbPsx5os
         im4fodQFIAZ9rv+9rtyiGTd8PJstjS3a3HB0n8P1+1YSsoimXgK+y38QOzbPfXkgfRWz
         q6Wg==
X-Gm-Message-State: ACgBeo1cpZdbDvvq47+VlL7SDjXnagx5l9aHSRSeybPZo5BaA4rmKD9G
        57HVbYUcsDofoj7HdiUV2T4=
X-Google-Smtp-Source: AA6agR5+fEtisTlr2eFTIvyaWqzECnyC/8KasjXQhYyiSySlaF2zlqq8wnsVqFmqXx3rClj1YkBitw==
X-Received: by 2002:a63:82c2:0:b0:434:9731:f1d9 with SMTP id w185-20020a6382c2000000b004349731f1d9mr3780779pgd.3.1662471351215;
        Tue, 06 Sep 2022 06:35:51 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id e10-20020a170902b78a00b00176dc67df44sm716943pls.132.2022.09.06.06.35.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 06:35:50 -0700 (PDT)
Message-ID: <a1e202f0-260e-fe00-4e39-42e390d4021b@gmail.com>
Date:   Tue, 6 Sep 2022 21:35:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH v3 10/13] x86/pmu: Update testcases to
 cover Intel Arch PMU Version 1
Content-Language: en-US
To:     Sandipan Das <sandipan.das@amd.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20220819110939.78013-1-likexu@tencent.com>
 <20220819110939.78013-11-likexu@tencent.com>
 <0666abab-ed22-6708-a794-de5449d049f1@amd.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <0666abab-ed22-6708-a794-de5449d049f1@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/9/2022 4:16 pm, Sandipan Das wrote:
> Hi Like,
> 
> On 8/19/2022 4:39 PM, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> For most unit tests, the basic framework and use cases which test
>> any PMU counter do not require any changes, except for two things:
>>
>> - No access to registers introduced only in PMU version 2 and above;
>> - Expanded tolerance for testing counter overflows
>>    due to the loss of uniform control of the gloabl_ctrl register
>>
>> Adding some pmu_version() return value checks can seamlessly support
>> Intel Arch PMU Version 1, while opening the door for AMD PMUs tests.
>>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   x86/pmu.c | 64 +++++++++++++++++++++++++++++++++++++------------------
>>   1 file changed, 43 insertions(+), 21 deletions(-)
>>
>> [...]
>> @@ -327,13 +335,21 @@ static void check_counter_overflow(void)
>>   			cnt.config &= ~EVNTSEL_INT;
>>   		idx = event_to_global_idx(&cnt);
>>   		__measure(&cnt, cnt.count);
>> -		report(cnt.count == 1, "cntr-%d", i);
>> +
>> +		report(check_irq() == (i % 2), "irq-%d", i);
>> +		if (pmu_version() > 1)
>> +			report(cnt.count == 1, "cntr-%d", i);
>> +		else
>> +			report(cnt.count < 4, "cntr-%d", i);
>> +
>> [...]
> 
> Sorry I missed this in the previous response. With an upper bound of
> 4, I see this test failing some times for at least one of the six
> counters (with NMI watchdog disabled on the host) on a Milan (Zen 3)
> system. Increasing it further does reduce the probability but I still
> see failures. Do you see the same behaviour on systems with Zen 3 and
> older processors?

A hundred runs on my machine did not report a failure.

But I'm not surprised by this, because some AMD platforms do
have hw PMU errata which requires bios or ucode fixes.

Please help find the right upper bound for all your available AMD boxes.

What makes me most nervous is that AMD's core hardware events run
repeatedly against the same workload, and their count results are erratic.

You may check is_the_count_reproducible() in the test case:
[1]https://lore.kernel.org/kvm/20220905123946.95223-7-likexu@tencent.com/

> 
> - Sandipan
