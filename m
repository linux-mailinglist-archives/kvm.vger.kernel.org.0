Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 932936E7661
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 11:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbjDSJfI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 05:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232942AbjDSJfE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 05:35:04 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168C0BBBC;
        Wed, 19 Apr 2023 02:35:03 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id k65-20020a17090a3ec700b00247131783f7so686315pjc.0;
        Wed, 19 Apr 2023 02:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681896902; x=1684488902;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ni3X7P4dZXBekYRyqkTdHj8UUMyWtiyS+2JS0EZfGlg=;
        b=dg6kIcJPHrX0R56xrkOpDTeo2BY6dvLXFUWQz1E3e1u3nPD2eInCHM9y3kERXUK0GU
         qA6PcAGU09Sas7CGzZ5i2TzmL2/3+OMeO1WPMfZkWc4AUoxuRBqgxSweAw3k4RYhbWqS
         rItx/mG0xzy0GUMYlHjaM6DhlHl5MP0yE8CXRO3yTSUR/gKfdz7y/SEkLW2qYp8vxiXZ
         rqbTNXjUtff/yOUF9ATaaAYoR0mUP37ZLP93EdSDT9/5fo5vsNRQH5RaZHFtepsnWnGU
         f+bec05VjvtlNBS+/A8FHN0KieyRNdZwUKGZC1tVNgq67moMhA9k0T30kWjhzITdEA0Z
         lp/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681896902; x=1684488902;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ni3X7P4dZXBekYRyqkTdHj8UUMyWtiyS+2JS0EZfGlg=;
        b=g4XMIlZ/sBbMZIhDyuxHJ0u844Vff7zC5SaVn+Ao0UsXviAGbRUn281Xl5OrazV78l
         ACKmJD32lRPXRyiu4SVm/upFi4agjtMChkyy63CRcDKyDmc4PwgN9uNvPlrSfVl7Dhw5
         r9hx3nhgrpvu6l+nfys29Sqi4QoVU9p22eysIM5WfPrga7b6nRc2M+CEbkjX5ugML+PU
         yDSN0zqQhx/P8czIURHyoKY2LfLdlSFhb0TdPgJcQECdQcvlFBG3NXBnRaVoyEjnqcJo
         Lgi1RuCShswPY+fZHFv+m4mbGwtAVHiAOwpe5dY26tEhMecyjgwJD+CZnpLrESz4uLPH
         p7ew==
X-Gm-Message-State: AAQBX9cnoTJjrz4reXfHk06ycyXapRTpFmChKhQ+J7tgKmLaywGRT36p
        8ekLvPWgbX3lkeHykZEYu0U=
X-Google-Smtp-Source: AKy350bzQVq7j8tU18oHwzj3k7clVdTCSje9lUunNFg+wYTVMIPd9hVB2abT88j/B45F971N6EPPlQ==
X-Received: by 2002:a05:6a21:78a2:b0:f0:dedb:83b8 with SMTP id bf34-20020a056a2178a200b000f0dedb83b8mr3598635pzc.19.1681896902187;
        Wed, 19 Apr 2023 02:35:02 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id y23-20020a63fa17000000b0051b93103665sm6734957pgh.63.2023.04.19.02.35.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 02:35:01 -0700 (PDT)
Message-ID: <f4ef3b07-d2f2-5cfc-6783-49e9b6be7a95@gmail.com>
Date:   Wed, 19 Apr 2023 17:34:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
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
 <81bbb700-9346-3d0d-ab86-6e684b185772@gmail.com>
 <CALMp9eSKnE8+jMpp0KzBRC7NDjT+S2cRz9CcBNDKB7JCU8dmTg@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <CALMp9eSKnE8+jMpp0KzBRC7NDjT+S2cRz9CcBNDKB7JCU8dmTg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim, sorry for the late reply.

On 11/4/2023 10:58 pm, Jim Mattson wrote:
> On Tue, Apr 11, 2023 at 6:18 AM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> On 11/4/2023 8:58 pm, Jim Mattson wrote:
>>> On Mon, Apr 10, 2023 at 11:17 PM Like Xu <like.xu.linux@gmail.com> wrote:
>>>>
>>>> On 11/4/2023 1:36 pm, Jim Mattson wrote:
>>>>> On Mon, Apr 10, 2023 at 3:51 AM Like Xu <like.xu.linux@gmail.com> wrote:
>>>>>>
>>>>>> From: Like Xu <likexu@tencent.com>
>>>>>>
>>>>>> Disable PMU support when running on AMD and perf reports fewer than four
>>>>>> general purpose counters. All AMD PMUs must define at least four counters
>>>>>> due to AMD's legacy architecture hardcoding the number of counters
>>>>>> without providing a way to enumerate the number of counters to software,
>>>>>> e.g. from AMD's APM:
>>>>>>
>>>>>>     The legacy architecture defines four performance counters (PerfCtrn)
>>>>>>     and corresponding event-select registers (PerfEvtSeln).
>>>>>>
>>>>>> Virtualizing fewer than four counters can lead to guest instability as
>>>>>> software expects four counters to be available.
>>>>>
>>>>> I'm confused. Isn't zero less than four?
>>>>
>>>> As I understand it, you are saying that virtualization of zero counter is also
>>>> reasonable.
>>>> If so, the above statement could be refined as:
>>>>
>>>>           Virtualizing fewer than four counters when vPMU is enabled may lead to guest
>>>> instability
>>>>           as software expects at least four counters to be available, thus the vPMU is
>>>> disabled if the
>>>>           minimum number of KVM supported counters is not reached during initialization.
>>>>
>>>> Jim, does this help you or could you explain more about your confusion ?
>>>
>>> You say that "fewer than four counters can lead to guest instability
>>> as software expects four counters to be available." Your solution is
>>> to disable the PMU, which leaves zero counters available. Zero is less
>>> than four. Hence, by your claim, disabling the PMU can lead to guest
>>> instability. I don't see how this is an improvement over one, two, or
>>> three counters.
>>
>> As you know, AMD pmu lacks an architected method (such as CPUID) to
>> indicate that the VM does not have any pmu counters available for the
>> current platform. Guests like Linux tend to check if their first counters
>> exist and work properly to infer that other pmu counters exist.
> 
> "Guests like Linux," or just Linux? What do you mean by "tend"? When
> do they perform this check, and when do they not?

We do not know how guests that do not disclose their source code
will detect the presence of pmu counters.

For upstream Linux guests, such a check is implemented in the check_hw_exists(),
which checks the counters one by one, often with an error on the first counter,
and then disables pmu from the kernel perspective.

The key point is that the KVM implementation cannot rely on assumptions about
the guest kernel version, and considering that the above check was added very early,
existing Linux guest instances will most likely (tend to) check the first 
counter and
error out (a VM could also check all of the possible counters and use a bitmap with
holes to track any functional counters).

> 
>> If KVM chooses to emulate greater than 1 less than 4 counters, then the
>> AMD guest PMU agent may assume that there are legacy 4 counters all
>> present (it's what the APM specifies), which requires the legacy code
>> to add #GP error handling for counters that should exist but actually not.
> 
> I would argue that regardless of the number of counters emulated, a
> guest PMU agent may assume that the 4 legacy counters are present,
> since that's what the APM specifies.

I certainly agree that, for example, a particular cpu model is stated in the spec
to have certain features (e.g. uncore pmu), but the KVM does not or chooses
not ro emulate them, for security reasons (e.g. side channel attacks), which
does violate the defined behavior of the hardware spec, such as here where
enable_pmu is false, which is not possible on almost all real hardware today.

> 
>> So at Sean's suggestion, we took a conservative approach. If KVM detects
>> less than 4 counters, we think KVM (under the current configuration and
>> platform) is not capable of emulating the most basic AMD pmu capability.
>> A large number of legacy instances are ready for 0 or 4+ ctrs, not 2 or 3
> 
> Which specific guest operating systems is this change intended for?
> 
>> Does this help you ? I wouldn't mind a better move.
> 
> Which AMD platforms have less than 4 counters available?

All this is for L2 Linux guest, as pmu on L1 Linux guest will be disabled by L0.

> 
>>
>>>
>>>>>
>>>>>> Suggested-by: Sean Christopherson <seanjc@google.com>
>>>>>> Signed-off-by: Like Xu <likexu@tencent.com>
>>>>>> ---
>>>>>>     arch/x86/kvm/pmu.h | 3 +++
>>>>>>     1 file changed, 3 insertions(+)
>>>>>>
>>>>>> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
>>>>>> index dd7c7d4ffe3b..002b527360f4 100644
>>>>>> --- a/arch/x86/kvm/pmu.h
>>>>>> +++ b/arch/x86/kvm/pmu.h
>>>>>> @@ -182,6 +182,9 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
>>>>>>                            enable_pmu = false;
>>>>>>            }
>>>>>>
>>>>>> +       if (!is_intel && kvm_pmu_cap.num_counters_gp < AMD64_NUM_COUNTERS)
> 
> Does this actually guarantee that the requisite number of counters are
> available and will always be available while the guest is running?

Not 100%, the scheduling of physical counters depends on the host perf scheduler.

I noticed that many cloud vendors want to make sure that hardware resources
are given exclusively to VMs, but for upstream, the availability of resources
should depend entirely on the host administrators, and a VMM should take away
access to resources at any time, such as vcpu time slice.

Any attempts in the direction of exclusive use will be thwarted.

> What happens if some other client of the host perf subsystem requests
> a CPU-pinned counter after this checck?

Normal perf use does not grab the counters allocated for kvm, NMI-watchdog
maybe one, but it will be moved to other timer hardware like HPET.

Of interest is that some ebpf programs that access the pmu hardware directly
use the interface that perf sub-system presents to KVM in the kernel.

> 
>>>>>> +               enable_pmu = false;
>>>>>> +
>>>>>>            if (!enable_pmu) {
>>>>>>                    memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
>>>>>>                    return;
>>>>>> --
>>>>>> 2.40.0
>>>>>>
> 
