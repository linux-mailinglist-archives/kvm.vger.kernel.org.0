Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12887637810
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 12:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiKXLxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 06:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiKXLw7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 06:52:59 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A576B5C74C
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 03:52:57 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id a1-20020a17090abe0100b00218a7df7789so4923863pjs.5
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 03:52:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8ya3C8Im4IoBz+Y/tHIfr3Wdb2ZQLwao3dt8/6S4bJ0=;
        b=mi0J5ffm9NzrQM4w5iCzZrpRqHgCuAXSfU73vQj+B6KEFIJ3mvX7UO5CI4cMAQjReT
         vVZojwDNGkpwqI3Jg9OZFio9htlnjaBWM0/PyM6Hv0C4ZJQXy5Xa08sSUOciFAnqg1Nz
         JYoEj1gUDQUQSY5FZ9QjsXx60CiVzNf1pfmx0CllCSS7KMxGjnopQoYqcZrmpnEMLCae
         Hrqi7X96DOYb2vOTRVrlAikhCNEjYhZbFCOqPe9/DLbVykpTMmu+lnDMPqDtZTbsYQy1
         CgtSUnCPOFCyTBxu8DEQjojdn1PcKUEspjI03w36hMgNG2XkC3ThjfL3BajErleF2cDn
         Fkow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8ya3C8Im4IoBz+Y/tHIfr3Wdb2ZQLwao3dt8/6S4bJ0=;
        b=wC4iC4PWdgxdzgICjSoYaqBJjSsewWmkPRGPLUMUCyDLWVbxnbq3hFE9cCQdd1pz8J
         eB2QitzJe1ToLvqIyQ23Mz7rDnOSGJzK1HI76yB78o2HpkNlrCXuaO2zk0cqEz67ywrw
         VQm4FJoC1p9AtP3YXk3OepwEyIj5EaTGfr+9+EiWloLNLRJ3Kae+fOrU4hxpvJk1fFsg
         NtHH0gMOTPacgOJdglebp+02wkDMs6yAGcAJEWp5ZQx6pCeuuYwl4RdopfuVXkxGqmNm
         J2uqoT69wvor4kmi24DOIhz7cmgMoqpWeNyUtEqDBqpf9zarfSVOpIhdgnCwuIeN5+3O
         kUdw==
X-Gm-Message-State: ANoB5pmsB0ABs31lFUhT0hU+MPVhfjyrvR2uQj8wUI1tDOBcxve7Yr9e
        5YdtRF4X05Fywsjkvc7XvLw=
X-Google-Smtp-Source: AA0mqf6MzT+cbDZwALETXKg3Q/tVwGfwyhm7h19W94jpQ50Plqx69YDuaq9N5mYYtv2SMoMnR6ULYg==
X-Received: by 2002:a17:90a:a003:b0:214:1a8a:a415 with SMTP id q3-20020a17090aa00300b002141a8aa415mr34755618pjp.197.1669290777062;
        Thu, 24 Nov 2022 03:52:57 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id iw14-20020a170903044e00b001869f2120a4sm1123548plb.94.2022.11.24.03.52.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Nov 2022 03:52:56 -0800 (PST)
Message-ID: <9e5bc080-627b-535e-9b74-3a938ecfd83d@gmail.com>
Date:   Thu, 24 Nov 2022 19:52:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [kvm-unit-tests PATCH v5 11/27] x86/pmu: Update rdpmc testcase to
 cover #GP path
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20221102225110.3023543-1-seanjc@google.com>
 <20221102225110.3023543-12-seanjc@google.com>
 <b112d219-adda-b2ac-da74-d00534ec5c04@redhat.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <b112d219-adda-b2ac-da74-d00534ec5c04@redhat.com>
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

On 24/11/2022 7:33 pm, Thomas Huth wrote:
> On 02/11/2022 23.50, Sean Christopherson wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> Specifying an unsupported PMC encoding will cause a #GP(0).
>>
>> There are multiple reasons RDPMC can #GP, the one that is being relied
>> on to guarantee #GP is specifically that the PMC is invalid. The most
>> extensible solution is to provide a safe variant.
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>   lib/x86/processor.h | 21 ++++++++++++++++++---
>>   x86/pmu.c           | 10 ++++++++++
>>   2 files changed, 28 insertions(+), 3 deletions(-)
>>
>> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
>> index f85abe36..ba14c7a0 100644
>> --- a/lib/x86/processor.h
>> +++ b/lib/x86/processor.h
>> @@ -438,11 +438,26 @@ static inline int wrmsr_safe(u32 index, u64 val)
>>       return exception_vector();
>>   }
>> +static inline int rdpmc_safe(u32 index, uint64_t *val)
>> +{
>> +    uint32_t a, d;
>> +
>> +    asm volatile (ASM_TRY("1f")
>> +              "rdpmc\n\t"
>> +              "1:"
>> +              : "=a"(a), "=d"(d) : "c"(index) : "memory");
>> +    *val = (uint64_t)a | ((uint64_t)d << 32);
>> +    return exception_vector();
>> +}
>> +
>>   static inline uint64_t rdpmc(uint32_t index)
>>   {
>> -    uint32_t a, d;
>> -    asm volatile ("rdpmc" : "=a"(a), "=d"(d) : "c"(index));
>> -    return a | ((uint64_t)d << 32);
>> +    uint64_t val;
>> +    int vector = rdpmc_safe(index, &val);
>> +
>> +    assert_msg(!vector, "Unexpected %s on RDPMC(%d)",
>> +           exception_mnemonic(vector), index);
>> +    return val;
>>   }
> 
> Seems like this is causing the CI to fail:
> 
> https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/jobs/3339274319#L1260

I just now noticed that KUT can be used to validate TCG or HVF accel on macOS.
I assume the functionality of the PMU counter on TCG seems to be a blank slate.

> 
> I guess you have to use PRId32 here? Could you please send a patch?
Sure, let me try it on the macOS.

> 
>   Thanks,
>    Thomas
> 
> 
> 
