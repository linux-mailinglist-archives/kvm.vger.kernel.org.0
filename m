Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0CA6DDBEF
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 15:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbjDKNSK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 09:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbjDKNSJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 09:18:09 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976E32D6B;
        Tue, 11 Apr 2023 06:18:07 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id m18so7733153plx.5;
        Tue, 11 Apr 2023 06:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681219087; x=1683811087;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=apOYjMJrfXEAWd08bvTLfUFM5/7pbWAQ78p/8j9CzLQ=;
        b=T9m2UyB3SWpn9AO56dFGBy7BZSBBymUOPeq2KSal6Ur/fiRChKuHYXeNHhwvuw6JVO
         zPb+1ao6RhSxcnUvsidb67rgI0QxUM5UfpnkkREgcl7xaVbVb4e69A9PjqjM/ku+7liB
         Auzytm+S7jK8U3XOtCH8JkdnZMHrqpX0tJm++YWdUaulbifyXmEMwPPMd+CtA5X7Y+wi
         9fvz/WoHBv0pcLroV+Oy/7UchXG8EsicbEDN/PWFyFIjwobmx3fyXR6UL8Rnbou+2kL3
         dYqYKXceb+RIcHtRNDba0jE6OFrc+/B7Yv7IDNBDrX5W29T9uKNGnI0WTuZbHWhIYAVo
         fWnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681219087; x=1683811087;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=apOYjMJrfXEAWd08bvTLfUFM5/7pbWAQ78p/8j9CzLQ=;
        b=cJLpIn9LZvwKICnU93JMIRtRGRuhU+ZfQ1lIoAwO0+Jld8ekoswblYsAP3HHWb7Qx2
         9VvEc9Goz0hXxlYqeofisgjAPBsLmYQtKklL2Qq4FuRW+r079Tt38GBqTMLaJWMsM7OQ
         b7HSyQHKyCNnac58TyRl7IUYHD6BaOJ6OCozzTlwG40HFqLYjN2zK9pmliVy0a/c3UWU
         p36OfcKexp0+ADiAt2eb8OHc/zfeEleKnKA09YzypOiZwzqu2K+tEVGLmJx1v1TG8DGu
         YRAsVgV/++RuQThww41kPfXhV3PMCFK4UeiZfB5fb8IwXDM2UsSQd079Cbl+tkMwJtVA
         3mFg==
X-Gm-Message-State: AAQBX9c8kVaDmB0iMMmc8gFZRXwrWAXcDplcfehSxYKzYqOin7zRvViQ
        JQM3uv3DsoZCUXjYN6jKUWI=
X-Google-Smtp-Source: AKy350aZ4oavzxoIARbZEGdSLt1DMCNwMElNZ7OdqWOrCGaUsjLq43+st+GMzdo1mxZcmmJJ9n3y2w==
X-Received: by 2002:a17:90a:5e4d:b0:240:75de:12d7 with SMTP id u13-20020a17090a5e4d00b0024075de12d7mr17259370pji.13.1681219081535;
        Tue, 11 Apr 2023 06:18:01 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id w2-20020a170902d70200b001a641ea111fsm3693769ply.112.2023.04.11.06.17.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Apr 2023 06:18:01 -0700 (PDT)
Message-ID: <81bbb700-9346-3d0d-ab86-6e684b185772@gmail.com>
Date:   Tue, 11 Apr 2023 21:17:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH V5 05/10] KVM: x86/pmu: Disable vPMU if the minimum num of
 counters isn't met
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230410105056.60973-1-likexu@tencent.com>
 <20230410105056.60973-6-likexu@tencent.com>
 <CALMp9eTLvJ6GW1mfgjO7CL7tW-79asykyz9=Fb=FfT74VRkDVA@mail.gmail.com>
 <9a7d5814-9eb1-d7af-7968-a6e3ebb90248@gmail.com>
 <CALMp9eR6DwY0EjAb1hcV9XGWQizN6R0dXtLaC4NXDgtCqv5cTA@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <CALMp9eR6DwY0EjAb1hcV9XGWQizN6R0dXtLaC4NXDgtCqv5cTA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/4/2023 8:58 pm, Jim Mattson wrote:
> On Mon, Apr 10, 2023 at 11:17 PM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> On 11/4/2023 1:36 pm, Jim Mattson wrote:
>>> On Mon, Apr 10, 2023 at 3:51 AM Like Xu <like.xu.linux@gmail.com> wrote:
>>>>
>>>> From: Like Xu <likexu@tencent.com>
>>>>
>>>> Disable PMU support when running on AMD and perf reports fewer than four
>>>> general purpose counters. All AMD PMUs must define at least four counters
>>>> due to AMD's legacy architecture hardcoding the number of counters
>>>> without providing a way to enumerate the number of counters to software,
>>>> e.g. from AMD's APM:
>>>>
>>>>    The legacy architecture defines four performance counters (PerfCtrn)
>>>>    and corresponding event-select registers (PerfEvtSeln).
>>>>
>>>> Virtualizing fewer than four counters can lead to guest instability as
>>>> software expects four counters to be available.
>>>
>>> I'm confused. Isn't zero less than four?
>>
>> As I understand it, you are saying that virtualization of zero counter is also
>> reasonable.
>> If so, the above statement could be refined as:
>>
>>          Virtualizing fewer than four counters when vPMU is enabled may lead to guest
>> instability
>>          as software expects at least four counters to be available, thus the vPMU is
>> disabled if the
>>          minimum number of KVM supported counters is not reached during initialization.
>>
>> Jim, does this help you or could you explain more about your confusion ?
> 
> You say that "fewer than four counters can lead to guest instability
> as software expects four counters to be available." Your solution is
> to disable the PMU, which leaves zero counters available. Zero is less
> than four. Hence, by your claim, disabling the PMU can lead to guest
> instability. I don't see how this is an improvement over one, two, or
> three counters.

As you know, AMD pmu lacks an architected method (such as CPUID) to
indicate that the VM does not have any pmu counters available for the
current platform. Guests like Linux tend to check if their first counters
exist and work properly to infer that other pmu counters exist.

If KVM chooses to emulate greater than 1 less than 4 counters, then the
AMD guest PMU agent may assume that there are legacy 4 counters all
present (it's what the APM specifies), which requires the legacy code
to add #GP error handling for counters that should exist but actually not.

So at Sean's suggestion, we took a conservative approach. If KVM detects
less than 4 counters, we think KVM (under the current configuration and
platform) is not capable of emulating the most basic AMD pmu capability.
A large number of legacy instances are ready for 0 or 4+ ctrs, not 2 or 3.

Does this help you ? I wouldn't mind a better move.

> 
>>>
>>>> Suggested-by: Sean Christopherson <seanjc@google.com>
>>>> Signed-off-by: Like Xu <likexu@tencent.com>
>>>> ---
>>>>    arch/x86/kvm/pmu.h | 3 +++
>>>>    1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
>>>> index dd7c7d4ffe3b..002b527360f4 100644
>>>> --- a/arch/x86/kvm/pmu.h
>>>> +++ b/arch/x86/kvm/pmu.h
>>>> @@ -182,6 +182,9 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
>>>>                           enable_pmu = false;
>>>>           }
>>>>
>>>> +       if (!is_intel && kvm_pmu_cap.num_counters_gp < AMD64_NUM_COUNTERS)
>>>> +               enable_pmu = false;
>>>> +
>>>>           if (!enable_pmu) {
>>>>                   memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
>>>>                   return;
>>>> --
>>>> 2.40.0
>>>>
