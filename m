Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28ED4456AC5
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 08:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbhKSHUJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 02:20:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbhKSHUI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 02:20:08 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F25BC061574;
        Thu, 18 Nov 2021 23:17:07 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id b68so8609039pfg.11;
        Thu, 18 Nov 2021 23:17:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=6qz6xI7WFRPHmyljg0Mk2T7aho0flV//gMy0C1tzj1c=;
        b=NMFPKBHakbF5Bk3iavj3f7hTz+cMS5OMW02RF3iaiDkiLBXa/fkIE5DRP0hqeA2rH9
         jMA3fP1jg5Tgp4aBhhfLHZE9DOpttAMHvPdKeLyvpK45YG49vYveJEabluc+INZ4psGZ
         u4S3IQRjpXlBGP/P5UsiVBC0MCvqGUh5GBDLol0Ss43rqX9eJUURIjIeh/Q1/cwGCnqz
         o5ilkjOPbcOoZS5dO70a+gSn9hhLuU3EpNIjoe0kBIz2iwqA4rh32LzgcMxC3Kcjkh7V
         Nlz+qlz9zy+Xb3O/MPULPfTZ40JvwSyFmhwjpAgN4jHWJGsQbK9A7IhUXXuWiZq85VHM
         0RTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=6qz6xI7WFRPHmyljg0Mk2T7aho0flV//gMy0C1tzj1c=;
        b=OrjTNP5gdpkt9bL3EiqMi/J7X1JlZgGBqX6NFTZHItWA/CRm+QAReWblMCnk4Uk4d4
         V4R5wsH8hbRcAhqWr+4svdGD/CUJPynmhdzqGWze9Orent4gY9yOEJ++7jJqhzXi3pE4
         6E7arCUZxpalR52PYcccTSWqQahLSYZrZvw+HYJlJOVfcFsjgKupymxpSSI6P/JQ2GPJ
         ObZjwygF9fCiKM/mHsGrabU7J1y7gsunPt6Spai1QxnEMSyi1Xin7VSCEb0Jj31mE1m6
         httU+pe2sbeIXWJLz2oJ8kmXVM6QfJnu7gLf5he9ZI+F8FIkw45rQtGfqM7OWQZHwTOS
         59iw==
X-Gm-Message-State: AOAM531B02/s2uk4AmnIhPkHksR/iS267jsUvaf9o+V9MSrGF/kODZz4
        cWt2IyPp8yqYMChxTIFA9EI=
X-Google-Smtp-Source: ABdhPJw0ZoneS2RMFMxxlLnzXy/Xf3b0nC2tFxPTj1tVmugmNHJ46o2d7pdxVE0qzQDt6efHxNIvSQ==
X-Received: by 2002:a63:ea51:: with SMTP id l17mr15578754pgk.363.1637306226647;
        Thu, 18 Nov 2021 23:17:06 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id qe2sm1417853pjb.42.2021.11.18.23.17.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Nov 2021 23:17:06 -0800 (PST)
Message-ID: <e3b3ad6f-b48a-24fa-a242-e28d2422a7f3@gmail.com>
Date:   Fri, 19 Nov 2021 15:16:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>
References: <20211116122030.4698-1-likexu@tencent.com>
 <20211116122030.4698-4-likexu@tencent.com>
 <85286356-8005-8a4d-927c-c3d70c723161@redhat.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH 3/4] KVM: x86/pmu: Reuse find_perf_hw_id() and drop
 find_fixed_event()
In-Reply-To: <85286356-8005-8a4d-927c-c3d70c723161@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/11/2021 11:00 pm, Paolo Bonzini wrote:
> On 11/16/21 13:20, Like Xu wrote:
>> +static inline unsigned int intel_find_fixed_event(int idx)
>> +{
>> +    u32 event;
>> +    size_t size = ARRAY_SIZE(fixed_pmc_events);
>> +
>> +    if (idx >= size)
>> +        return PERF_COUNT_HW_MAX;
>> +
>> +    event = fixed_pmc_events[array_index_nospec(idx, size)];
>> +    return intel_arch_events[event].event_type;
>> +}
>> +
>> +
>>   static unsigned int intel_find_perf_hw_id(struct kvm_pmc *pmc)
>>   {
>>       struct kvm_pmu *pmu = pmc_to_pmu(pmc);
>> @@ -75,6 +88,9 @@ static unsigned int intel_find_perf_hw_id(struct kvm_pmc *pmc)
>>       u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
>>       int i;
>> +    if (pmc_is_fixed(pmc))
>> +        return intel_find_fixed_event(pmc->idx - INTEL_PMC_IDX_FIXED);
> 
> Is intel_find_fixed_event needed at all?  As you point out in the commit
> message, eventsel/unit_mask are valid so you can do
> 
> @@ -88,13 +75,11 @@ static unsigned int intel_pmc_perf_hw_id(struct kvm_pmc *pmc)
>       u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
>       int i;
> 
> -    if (pmc_is_fixed(pmc))
> -        return intel_find_fixed_event(pmc->idx - INTEL_PMC_IDX_FIXED);
> -
>       for (i = 0; i < ARRAY_SIZE(intel_arch_events); i++)
>           if (intel_arch_events[i].eventsel == event_select
>               && intel_arch_events[i].unit_mask == unit_mask
> -            && (pmu->available_event_types & (1 << i)))
> +            && (pmc_is_fixed(pmc) ||
> +            pmu->available_event_types & (1 << i)))

It's a good move while the tricky thing I've found recently is:

the events masked in pmu->available_event_types are just *Intel CPUID* events
(they're not a subset or superset of the *kernel generic* hw events),
some of which can be programmed and enabled with generic or fixed counter.

According Intel SDM, when an Intel CPUID event (e.g. "instructions retirement")
is not masked in pmu->available_event_types (configured via Intel CPUID.0A.EBX),
the guest should not use generic or fixed counter to count/sample this event.

This issue is detailed in another patch set [1] and comments need to be collected.

It's proposed to get [V2] merged and continue to review the fixes from [1] 
seamlessly,
and then further unify all fixed/gp stuff including intel_find_fixed_event() as 
a follow up.

[1] https://lore.kernel.org/kvm/20211112095139.21775-1-likexu@tencent.com/
[V2] https://lore.kernel.org/kvm/20211119064856.77948-1-likexu@tencent.com/

>               break;
> 
>       if (i == ARRAY_SIZE(intel_arch_events))
> 
> What do you think?  It's less efficient but makes fixed/gp more similar.
> 
> Can you please resubmit the series based on the review feedback?
> 
> Thanks,
> 
> 
