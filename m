Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75B566AFCFA
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 03:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjCHCq1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 21:46:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjCHCqZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 21:46:25 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65B74617C
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 18:46:24 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id p3-20020a17090ad30300b0023a1cd5065fso713983pju.0
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 18:46:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678243584;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pt5tPy+2NnTQIteoPh6hYGXMnAj6nH0zpr+kADpbsRA=;
        b=o0JEqanW4lMt0wj7QxjjraR6Suh1mhnHW2AQz4xfwOaIBoXILGqPZzk4JHlvB9DHrd
         /2GKAArmaA4ONCzY2daUvo+GwCxYT9LhAxsm597MBS/7hN9Fu1ZTg1ErVISLGYyWMAzY
         CjeBJQ2Azm8pczJRsJcFL3fVW06GLY1H9XnvRxJjtZigIyM9zGBsuTwyehc/XVYuf880
         L61gKRdvMyB+xrIzmFfvTGo/gtUys80hdyB88jruuDSWyypmHzdB9Hfei+czuVGNai82
         KY4ztMm8C7QptnzoQ2jqcVLv7DvF4nUN9eYzCTUjCxuSsmfgBvmquyA2XMtAVFu2ycM2
         scAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678243584;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pt5tPy+2NnTQIteoPh6hYGXMnAj6nH0zpr+kADpbsRA=;
        b=Wc/oXcLWfMD+CY6VT1t+vXTr82F8O7jgTQrDLZEtZROTgWdVAOqhFeH/mnPyVQjVM8
         GzH6elEEb6UqDPkUr+wW4KUDjAl3tuQKo9wjQntm2o2bW1l7h4VFU7XzE562MunsEk3q
         I2bZFvT4oC7R3BGUqD5Pea/RNMgQJe6o/7eV609cBaC0+AbLXaDSjBerC14ZjpeMstp8
         IHDujpbeVrzjOY1Kb27dqNJTD3GPbk9OzjzFDdbiRINzqsvDh0ubhR7vKJAEUmeVnkFn
         iWcq787VJJjteH+9EMc20Q5QPrqzX1gD+QAJjeDNDyEP6tXTd7Sjx+mG87eC0XbogpPl
         DLTQ==
X-Gm-Message-State: AO0yUKUMuacFrkbZWQ1hKcZq9YyZ3iPiYgyJekXDYTVzzmcTWffn6OHt
        7CsZ264A8pKPhVAJDip7n40=
X-Google-Smtp-Source: AK7set/M0nEfdRsLAHvrVzLeJHtVMPDDqAuijzZgYhQ7gIqUy5iPE2bAsQK8UH8wCwJhY1C3/w0cfQ==
X-Received: by 2002:a05:6a20:4290:b0:bf:5d4e:704b with SMTP id o16-20020a056a20429000b000bf5d4e704bmr17889710pzj.32.1678243554230;
        Tue, 07 Mar 2023 18:45:54 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id bm16-20020a056a00321000b005a84ef49c63sm8458375pfb.214.2023.03.07.18.45.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 18:45:53 -0800 (PST)
Message-ID: <741d411a-c5a2-71ae-fba9-52cdebb88cfd@gmail.com>
Date:   Wed, 8 Mar 2023 10:45:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH v3 1/5] KVM: x86/pmu: Prevent the PMU from counting
 disallowed events
To:     Sean Christopherson <seanjc@google.com>,
        Aaron Lewis <aaronlewis@google.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, kvm@vger.kernel.org
References: <20230307141400.1486314-1-aaronlewis@google.com>
 <20230307141400.1486314-2-aaronlewis@google.com>
 <1c7a20c4-742c-9c42-970e-19626323e367@gmail.com>
 <CAAAPnDFuEhhv+3orZ0EGMq4kAm3_p335kRAMOf=ZcLi_pcnPKQ@mail.gmail.com>
 <ZAdfX+S323JVWNZC@google.com>
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <ZAdfX+S323JVWNZC@google.com>
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

On 8/3/2023 12:01 am, Sean Christopherson wrote:
> On Tue, Mar 07, 2023, Aaron Lewis wrote:
>> On Tue, Mar 7, 2023 at 7:19 AM Like Xu <like.xu.linux@gmail.com> wrote:
>>>> ---
>>>>    arch/x86/kvm/pmu.c | 13 ++++++++-----
>>>>    1 file changed, 8 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>>>> index 612e6c70ce2e..9914a9027c60 100644
>>>> --- a/arch/x86/kvm/pmu.c
>>>> +++ b/arch/x86/kvm/pmu.c
>>>> @@ -400,6 +400,12 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
>>>>        return is_fixed_event_allowed(filter, pmc->idx);
>>>>    }
>>>>
>>>> +static bool event_is_allowed(struct kvm_pmc *pmc)
>>>
>>> Nit, an inline event_is_allowed() here might be better.
>>
>> I purposely didn't inline this because Sean generally discourages its
>> use and has commented in several reviews to not use 'inline' and
>> instead leave it up to the compiler to decide, unless using
>> __always_inline.
> 
> Ya.

I think we all respect mainatiner's personal preferences for sure. However,
I'm not sure how to define Sean's "generally discourage", nor does my
binary bi-directional verifier-bot (losing control of these details at the code
level can be frustrating, especially for people who care about performance
gains but can't use the fresh new tool chain for some supply chain policy
reasons), and we don't have someone like Sean or other kernel worlds to
eliminate all inline in the kernel world.

> 
>> I think the sentiment is either use the strong hint or don't use it at all.
>> This seems like an example of where the compiler can decide, and a strong
>> hint isn't needed.
> 
> Not quite.  __always_inline is not a hint, it's a command.  The kernel *requires*
> functions tagged with __always_inline to be (surprise!) always inlined, even when
> building with features that cause the compiler to generate non-inlined functions
> for even the most trivial helpers, e.g. KASAN can cause a literal nop function to
> be non-inlined.  __alway_inlined is used to ensure like no-instrumentation regions
> and __init sections are preserved when invoking common helpers.

So, do you think "__always_inline event_is_allowed()" in the highly recurring path
reprogram_counter() is a better move ? I'd say yes, and am not willing to risk 
paying
for a function call overhead since any advancement in this direction is encouraged.
