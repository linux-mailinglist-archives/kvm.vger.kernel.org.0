Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A24D5AFCA7
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 08:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiIGGko (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 02:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiIGGkk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 02:40:40 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83AF31114B;
        Tue,  6 Sep 2022 23:40:28 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id iw17so6895804plb.0;
        Tue, 06 Sep 2022 23:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=eJHfMK2TZ079rqYIsHEdtV+dP7nwUQN6QV5MYbiH+v4=;
        b=YbpVNHu1ln26JbFLzrkZIoZavABkdHT6wnJEvRT9tUbYIskzkVdccXrkwXFPzH+ZI2
         YE/3jR/74Sj0xhKQkzBp/0KkN6zEun669WPVVPQl2oTIQX1OxH+ABLTnBpZDdWwyRYB/
         nmEeoTTetFfW8S4HV/F1Wm6rqvuICDX153ydxHDlLN29h/ffDvJAWS+V6JLbvtOHUzkV
         UG5072B3hxyXAzYf3PesHIuq3zJ4P/3UPvDu5e15J5jyrL+LkTPLo9HEqjC7/PRjBn19
         DJWQuXD6gDKCZSe5SaapvoXDA3/PdJpq2IjOtoi26WiovKoGI4OL/BEUfoU23JJCElJL
         sBuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=eJHfMK2TZ079rqYIsHEdtV+dP7nwUQN6QV5MYbiH+v4=;
        b=zpnz3Nq38qe6pff2qUhZb9geX8Fsm9NgjVZ/wt85R7eusFOKoIYCL5/n6QY1mfgAuo
         pggRNEQH7OoXmGTdJQlwDgmWOopEUaayxkPkldPxyaw8Wx+PEihnNSrHUmL058lTgBD8
         Td8AAzjNczVeXPs/P377545EbkWSiNflpQ20nbUmkV6zREeavpQnuvzvHzR1tBAdndAl
         R/Uc0QhU7aXEIHtB4aAVML5VJk9CTT0ZbU2UNp8xpHN/kjaB2E+6MurKDTPgIjDaYHyU
         cJ3VZrhnV7TlyR/LzfSIHZf+JnWIcxT0jzPeJwKtUl7nW6pOpzuSCGCgVNeKuqsDOxKR
         yw5g==
X-Gm-Message-State: ACgBeo3E4QMueEag/Mvt7rc2mEGQutL+eC4OUjta4Ve3p8NMESJtpRLj
        HIToMg6ezEVkcDOlFGkR4BhsPESTLe8nAw==
X-Google-Smtp-Source: AA6agR6xZLTRUVcCdJ95y02rGHS1PPJmcT1vkCLAm+VsgT9FCJUZguurXJ2iH46GrM4VYqFZe1PiSw==
X-Received: by 2002:a17:902:cf43:b0:172:86f3:586a with SMTP id e3-20020a170902cf4300b0017286f3586amr2444836plg.71.1662532766218;
        Tue, 06 Sep 2022 23:39:26 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b9-20020a170902d50900b0016c0b0fe1c6sm11297767plg.73.2022.09.06.23.39.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 23:39:25 -0700 (PDT)
Message-ID: <c6559d3e-38ec-9a2c-7698-995eb9f265c6@gmail.com>
Date:   Wed, 7 Sep 2022 14:39:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH 4/4] KVM: x86/cpuid: Add AMD CPUID ExtPerfMonAndDbg leaf
 0x80000022
Content-Language: en-US
To:     Sandipan Das <sandipan.das@amd.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220905123946.95223-1-likexu@tencent.com>
 <20220905123946.95223-5-likexu@tencent.com>
 <CALMp9eQtjZ-iRiW5Jusa+NF-P0sdHtcoR8fPiBSKtNXKgstgVA@mail.gmail.com>
 <0e0f773b-0dde-2282-c2d0-fad2311f59a7@gmail.com>
 <CALMp9eQQe-XDUZmNtg5Z+Vv8hMu_R_fuTv2+-ZfuRwzNUmW0fA@mail.gmail.com>
 <d63e79d8-fcbc-9def-4a90-e7a4614493bb@gmail.com>
 <CALMp9eSXTpkKpmqJiS=0NuQOjCFKDeOqjN3wWfyPCBhx-H=Vsw@mail.gmail.com>
 <c07eb8bf-67fc-c645-18f2-cd1623c7a093@amd.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <c07eb8bf-67fc-c645-18f2-cd1623c7a093@amd.com>
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

On 7/9/2022 1:52 pm, Sandipan Das wrote:
> On 9/7/2022 9:41 AM, Jim Mattson wrote:
>> On Tue, Sep 6, 2022 at 8:59 PM Like Xu <like.xu.linux@gmail.com> wrote:
>> [...]
>>>>>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>>>>>> index 75dcf7a72605..08a29ab096d2 100644
>>>>>>> --- a/arch/x86/kvm/cpuid.c
>>>>>>> +++ b/arch/x86/kvm/cpuid.c
>>>>>>> @@ -1094,7 +1094,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>>>>>>>                    entry->edx = 0;
>>>>>>>                    break;
>>>>>>>            case 0x80000000:
>>>>>>> -               entry->eax = min(entry->eax, 0x80000021);
>>>>>>> +               entry->eax = min(entry->eax, 0x80000022);
>>>>>>>                    /*
>>>>>>>                     * Serializing LFENCE is reported in a multitude of ways, and
>>>>>>>                     * NullSegClearsBase is not reported in CPUID on Zen2; help
>>>>>>> @@ -1203,6 +1203,25 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>>>>>>>                    if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
>>>>>>>                            entry->eax |= BIT(6);
>>>>>>>                    break;
>>>>>>> +       /* AMD Extended Performance Monitoring and Debug */
>>>>>>> +       case 0x80000022: {
>>>>>>> +               union cpuid_0x80000022_eax eax;
>>>>>>> +               union cpuid_0x80000022_ebx ebx;
>>>>>>> +
>>>>>>> +               entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
>>>>>>> +               if (!enable_pmu)
>>>>>>> +                       break;
>>>>>>> +
>>>>>>> +               if (kvm_pmu_cap.version > 1) {
>>>>>>> +                       /* AMD PerfMon is only supported up to V2 in the KVM. */
>>>>>>> +                       eax.split.perfmon_v2 = 1;
>>>>>>> +                       ebx.split.num_core_pmc = min(kvm_pmu_cap.num_counters_gp,
>>>>>>> +                                                    KVM_AMD_PMC_MAX_GENERIC);
>>>>>>
>>>>>> Note that the number of core PMCs has to be at least 6 if
>>>>>> guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE). I suppose this leaf
>>>>>> could claim fewer, but the first 6 PMCs must work, per the v1 PMU
>>>>>> spec. That is, software that knows about PERFCTR_CORE, but not about
>>>>>> PMU v2, can rightfully expect 6 PMCs.
>>>>>
>>>>> I thought the NumCorePmc number would only make sense if
>>>>> CPUID.80000022.eax.perfmon_v2
>>>>> bit was present, but considering that the user space is perfectly fine with just
>>>>> configuring the
>>>>> NumCorePmc number without setting perfmon_v2 bit at all, so how about:
>>>>
>>>> CPUID.80000022H might only make sense if X86_FEATURE_PERFCTR_CORE is
>>>> present. It's hard to know in the absence of documentation.
>>>
>>> Whenever this happens, we may always leave the definition of behavior to the
>>> hypervisor.
>>
>> I disagree. If CPUID.0H reports "AuthenticAMD," then AMD is the sole
>> authority on behavior.

The real world isn't like that, because even AMD has multiple implementations in 
cases
where the hardware specs aren't explicitly stated, and sometimes they're 
intentionally vague.
And the hypervisor can't do nothing, it prefers one over the other and maintains 
maximum compatibility with the legacy user space.

>>
> 
> I understand that official documentation is not out yet. However, for Zen 4
> models, it is expected that both the PerfMonV2 bit of CPUID.80000022H EAX and
> the PerfCtrExtCore bit of CPUID.80000001H ECX will be set.

Is PerfCtrExtCore a PerfMonV2 or PerfMonV3+ precondition ?
Is PerfCtrExtCore a CPUID.80000022 precondition ?

Should we always expect CPUID_Fn80000022_EBX.NumCorePmc to reflect the real
Number of Core Performance Counters regardless of whether PerfMonV2 is set ?

> 
>>>>
>>>>>           /* AMD Extended Performance Monitoring and Debug */
>>>>>           case 0x80000022: {
>>>>>                   union cpuid_0x80000022_eax eax;
>>>>>                   union cpuid_0x80000022_ebx ebx;
>>>>>                   bool perfctr_core;
>>>>>
>>>>>                   entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
>>>>>                   if (!enable_pmu)
>>>>>                           break;
>>>>>
>>>>>                   perfctr_core = kvm_cpu_cap_has(X86_FEATURE_PERFCTR_CORE);
>>>>>                   if (!perfctr_core)
>>>>>                           ebx.split.num_core_pmc = AMD64_NUM_COUNTERS;
>>>>>                   if (kvm_pmu_cap.version > 1) {
>>>>>                           /* AMD PerfMon is only supported up to V2 in the KVM. */
>>>>>                           eax.split.perfmon_v2 = 1;
>>>>>                           ebx.split.num_core_pmc = min(kvm_pmu_cap.num_counters_gp,
>>>>>                                                        KVM_AMD_PMC_MAX_GENERIC);
>>>>>                   }
>>>>>                   if (perfctr_core) {
>>>>>                           ebx.split.num_core_pmc = max(ebx.split.num_core_pmc,
>>>>>                                                        AMD64_NUM_COUNTERS_CORE);
>>>>>                   }
>>>>
>>>> This still isn't quite right. All AMD CPUs must support a minimum of 4 PMCs.
>>>
>>> K7 at least. I could not confirm that all antique AMD CPUs have 4 counters w/o
>>> perfctr_core.
>>
>> The APM says, "All implementations support the base set of four
>> performance counter / event-select pairs." That is unequivocal.
>>
> 
> That is true. The same can be inferred from amd_core_pmu_init() in
> arch/x86/events/amd/core.c. If PERFCTR_CORE is not detected, it assumes
> that the four legacy counters are always available.
> 
> - Sandipan
