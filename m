Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F275649003E
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 03:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234070AbiAQCeE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Jan 2022 21:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiAQCeD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Jan 2022 21:34:03 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E72CC061574;
        Sun, 16 Jan 2022 18:34:02 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id g5so19776720plo.12;
        Sun, 16 Jan 2022 18:34:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=KlnOK8g4Edefb043EQsqUHF8oDJQb8Ntv8+8ul6Frj0=;
        b=mL70LWhl8jgugjxenuHeAivedcJQTctzhsDpDxvmAkCN3+6fOLAnSohmTtI90mwqJH
         OH6QUbuhtGTdMjjRFI4KXtGtuCR5UbuHoDrTq24dkfnvxm6pYmpNBiboC9CDnRTDqi6Q
         3l2DKFbijqHk74FFKOwRf54Tfg09o3ywBIDoz0uAC+VDarH0D1xtAr1ADFBdDqMVm20g
         EZzfnYqbtwY1XJjGGuAXKbgxTUOJOUTu7obxtYaygBpIxKuQsilvtjPVBSUYP/y0c5Yk
         XTfmpNb4RkhpwWGJCWmcsdq6zZlmW2XA6owQhjYYng5+24neZUHrJACicRJCzrUCII0Z
         PfOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=KlnOK8g4Edefb043EQsqUHF8oDJQb8Ntv8+8ul6Frj0=;
        b=E0AnBhA++CnCQqKWrLwe7POKPOhVqJecqjVCZsR3luXBCS+wTLtNenH8mezYQFF4MC
         w8oU9hXw/aFNfY6hRlnG1owysVg5+1S02+B7pcBaKxqwXHzGcUfXENk0GC7Kb6iGJodq
         sygwnsrqcR4sV5NIgL/kHk94unDHv1Re4L65xM/03vndqv9Bj65bdtBjJURqIvvSHe84
         vpqK8c6/LIb2zEmmxC6YOJUlEuyzgxWgopi+KFAuvkwGnRNzT4BxFBvMwUuqmWZapjVV
         oakGWw9L+gixiPi/U39xDk8LvzMrmDAHixXDnYyHt0Iqs+RE0iW+03OlHlba73AENEvf
         4I7Q==
X-Gm-Message-State: AOAM5332nUrpl+oE1B5eTdBlBUycf3a+zwnX0o/D4TZGPF6dCu9+gBaC
        dzmDbgN19EFWMqB+Aqzz7X8=
X-Google-Smtp-Source: ABdhPJwNo6QA1j4XGX5jVDfERE2T5a4/SN079/Wst4ZyZh7WxZ0Bbak4Xv/AediHMbt9iotjhs22uQ==
X-Received: by 2002:a17:90b:4d11:: with SMTP id mw17mr15707218pjb.32.1642386842049;
        Sun, 16 Jan 2022 18:34:02 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id c17sm10829173pjs.25.2022.01.16.18.33.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Jan 2022 18:34:01 -0800 (PST)
Message-ID: <ad3cc4b9-11d4-861b-6e31-a75564539216@gmail.com>
Date:   Mon, 17 Jan 2022 10:33:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH] KVM: x86/svm: Add module param to control PMU
 virtualization
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211117080304.38989-1-likexu@tencent.com>
 <c840f1fe-5000-fb45-b5f6-eac15e205995@redhat.com>
 <CALMp9eQCEFsQTbm7F9CqotirbP18OF_cQUySb7Q=dqiuiK1FMg@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <CALMp9eQCEFsQTbm7F9CqotirbP18OF_cQUySb7Q=dqiuiK1FMg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/1/2022 9:26 am, Jim Mattson wrote:
> On Thu, Nov 18, 2021 at 5:25 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 11/17/21 09:03, Like Xu wrote:
>>> From: Like Xu <likexu@tencent.com>
>>>
>>> For Intel, the guest PMU can be disabled via clearing the PMU CPUID.
>>> For AMD, all hw implementations support the base set of four
>>> performance counters, with current mainstream hardware indicating
>>> the presence of two additional counters via X86_FEATURE_PERFCTR_CORE.
>>>
>>> In the virtualized world, the AMD guest driver may detect
>>> the presence of at least one counter MSR. Most hypervisor
>>> vendors would introduce a module param (like lbrv for svm)
>>> to disable PMU for all guests.
>>>
>>> Another control proposal per-VM is to pass PMU disable information
>>> via MSR_IA32_PERF_CAPABILITIES or one bit in CPUID Fn4000_00[FF:00].
>>> Both of methods require some guest-side changes, so a module
>>> parameter may not be sufficiently granular, but practical enough.
>>>
>>> Signed-off-by: Like Xu <likexu@tencent.com>
>>> ---
>>>    arch/x86/kvm/cpuid.c   |  2 +-
>>>    arch/x86/kvm/svm/pmu.c |  4 ++++
>>>    arch/x86/kvm/svm/svm.c | 11 +++++++++++
>>>    arch/x86/kvm/svm/svm.h |  1 +
>>>    4 files changed, 17 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>> index 2d70edb0f323..647af2a184ad 100644
>>> --- a/arch/x86/kvm/cpuid.c
>>> +++ b/arch/x86/kvm/cpuid.c
>>> @@ -487,7 +487,7 @@ void kvm_set_cpu_caps(void)
>>>                F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
>>>                F(3DNOWPREFETCH) | F(OSVW) | 0 /* IBS */ | F(XOP) |
>>>                0 /* SKINIT, WDT, LWP */ | F(FMA4) | F(TBM) |
>>> -             F(TOPOEXT) | F(PERFCTR_CORE)
>>> +             F(TOPOEXT) | 0 /* PERFCTR_CORE */
>>>        );
>>>
>>>        kvm_cpu_cap_mask(CPUID_8000_0001_EDX,
>>> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
>>> index fdf587f19c5f..a0bcf0144664 100644
>>> --- a/arch/x86/kvm/svm/pmu.c
>>> +++ b/arch/x86/kvm/svm/pmu.c
>>> @@ -16,6 +16,7 @@
>>>    #include "cpuid.h"
>>>    #include "lapic.h"
>>>    #include "pmu.h"
>>> +#include "svm.h"
>>>
>>>    enum pmu_type {
>>>        PMU_TYPE_COUNTER = 0,
>>> @@ -100,6 +101,9 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
>>>    {
>>>        struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
>>>
>>> +     if (!pmuv)
>>> +             return NULL;
>>> +
>>>        switch (msr) {
>>>        case MSR_F15H_PERF_CTL0:
>>>        case MSR_F15H_PERF_CTL1:
>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>> index 21bb81710e0f..062e48c191ee 100644
>>> --- a/arch/x86/kvm/svm/svm.c
>>> +++ b/arch/x86/kvm/svm/svm.c
>>> @@ -190,6 +190,10 @@ module_param(vgif, int, 0444);
>>>    static int lbrv = true;
>>>    module_param(lbrv, int, 0444);
>>>
>>> +/* enable/disable PMU virtualization */
>>> +bool pmuv = true;
>>> +module_param(pmuv, bool, 0444);
>>> +
>>>    static int tsc_scaling = true;
>>>    module_param(tsc_scaling, int, 0444);
>>>
>>> @@ -952,6 +956,10 @@ static __init void svm_set_cpu_caps(void)
>>>            boot_cpu_has(X86_FEATURE_AMD_SSBD))
>>>                kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
>>>
>>> +     /* AMD PMU PERFCTR_CORE CPUID */
>>> +     if (pmuv && boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
>>> +             kvm_cpu_cap_set(X86_FEATURE_PERFCTR_CORE);
>>> +
>>>        /* CPUID 0x8000001F (SME/SEV features) */
>>>        sev_set_cpu_caps();
>>>    }
>>> @@ -1085,6 +1093,9 @@ static __init int svm_hardware_setup(void)
>>>                        pr_info("LBR virtualization supported\n");
>>>        }
>>>
>>> +     if (!pmuv)
>>> +             pr_info("PMU virtualization is disabled\n");
>>> +
>>>        svm_set_cpu_caps();
>>>
>>>        /*
>>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>>> index 0d7bbe548ac3..08e1c19ffbdf 100644
>>> --- a/arch/x86/kvm/svm/svm.h
>>> +++ b/arch/x86/kvm/svm/svm.h
>>> @@ -32,6 +32,7 @@
>>>    extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
>>>    extern bool npt_enabled;
>>>    extern bool intercept_smi;
>>> +extern bool pmuv;
>>>
>>>    /*
>>>     * Clean bits in VMCB.
>>>
>>
>> Queued, thanks - just changed the parameter name to "pmu".
> 
> Whoops! The global 'pmu' is hidden by a local 'pmu' in get_gp_pmc_amd().

Indeed, I wonder if Poalo would like to take a look at this fix:
https://lore.kernel.org/kvm/20220113035324.59572-1-likexu@tencent.com/
