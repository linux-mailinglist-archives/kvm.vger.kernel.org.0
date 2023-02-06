Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E9068B6ED
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 08:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbjBFHx6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 02:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjBFHx4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 02:53:56 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D17E3C38;
        Sun,  5 Feb 2023 23:53:21 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id bd15so7733698pfb.8;
        Sun, 05 Feb 2023 23:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RC7zNS0L3CnQXWjCZgLPgFTllktxigIImj1MiCRT9Vs=;
        b=OmIXs/aLi39xrYY8hN369bOR/aHdt4DZIEQmu/NSGtO2AfUVPwoiLsg9Q0DPgxB5Jh
         0ji8F8PgPTzCR4oAUxkMV6W3YYHcCm8XIyo0P+s1gPE5KeseunUbI3NEpvJ8UEfDFX4T
         cmZH91LhYSmI/FxO4fZIn3y6JDnf3aXwf1lB6oPerZJ8Nsgsfk4oi+/3cEuZjSti9XLi
         OMb0Ybsmu118gvDCaK1bWxdhyRr+AIZcRqVoz4q0ydMGEXxru+u3qVRkExS4CAwuc5/+
         cBcDG2edX9Wfu42Q4Wd9Yc9UoAaB9sPXVlYOGjkqybm4brm1etlbwoB5ZmWRsth1EIFE
         EkSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RC7zNS0L3CnQXWjCZgLPgFTllktxigIImj1MiCRT9Vs=;
        b=79Y3fdBf4oiFFOVxR/HsrA50nf7HU0orvnnzWVRwKJJO8A7DvTICCtbawGxQTLX8an
         /RsMZiI3SEL8+as+rNoL9kWHhXqBP7UJG+0YrK0mM3lkrOAKJQV72fwoeuGLCbtoQmFs
         DC+ZLzvDzWSvEaRJguww0omhSRR0MkFL/i2YGTnpvc48a4bqAcek94IV+SC5tmwcIUTg
         vpZhgg8GFw3/DMMmKfmzc18M86+TH4Q3C73+J2aZStbdOHQPSFxfSFDa5eefB/E27vLD
         oO/T6Cr97oPY1iI2XT1bl3vZ2gNuXN8VvRDZZi7qcoFts1O5DZWfcIbDutPA8GIFNMrH
         fPnA==
X-Gm-Message-State: AO0yUKUyTVgju1i+vA9W7yFx344iXJx6CRoy+rmp5m3pZxzyrrZyti1m
        xTJ9/5IR1DXtnkt82GdJCB8=
X-Google-Smtp-Source: AK7set+96lTkSoAoVwngn2uZE8+YGviXwEiMRN2oMEm3Qc38ZWdyezAZq8cL9K3UJ4kUaJ97ST6yyw==
X-Received: by 2002:a05:6a00:b47:b0:58d:988b:da99 with SMTP id p7-20020a056a000b4700b0058d988bda99mr22460558pfo.19.1675669988434;
        Sun, 05 Feb 2023 23:53:08 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z9-20020aa79589000000b0058e23ca0ca7sm6367041pfj.3.2023.02.05.23.53.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Feb 2023 23:53:07 -0800 (PST)
Message-ID: <c7e0a5b1-0fd0-e2b5-20ca-fc86a1d883db@gmail.com>
Date:   Mon, 6 Feb 2023 15:53:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v3 6/8] KVM: x86/svm/pmu: Add AMD PerfMonV2 support
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>,
        Jim Mattson <jmattson@google.com>
References: <20221111102645.82001-1-likexu@tencent.com>
 <20221111102645.82001-7-likexu@tencent.com> <Y9BzYzEjAwUA+wuy@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Y9BzYzEjAwUA+wuy@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/1/2023 8:10 am, Sean Christopherson wrote:
> On Fri, Nov 11, 2022, Like Xu wrote:
> On Fri, Nov 11, 2022, Like Xu wrote:
>> @@ -162,20 +179,42 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
>>   {
>>        struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>> +     struct kvm_cpuid_entry2 *entry;
>> +     union cpuid_0x80000022_ebx ebx;
>>
>> -     if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE))
>> -             pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS_CORE;
>> +     pmu->version = 1;
>> +     if (kvm_cpu_cap_has(X86_FEATURE_AMD_PMU_V2) &&
> 
> Why check kvm_cpu_cap support?  I.e. what will go wrong if userspace enumerates
> PMU v2 to the guest without proper hardware/KVM support.
> 
> If this is _necessary_ to protect the host kernel, then we should probably have
> a helper to query PMU features, e.g.
> 
> static __always_inline bool guest_pmu_has(struct kvm_vcpu *vcpu,
>                                            unsigned int x86_feature)
> {
>          return kvm_cpu_cap_has(x86_feature) &&
>                 guest_cpuid_has(vcpu, x86_feature);
> }
> 
> 
> 
>> +         guest_cpuid_has(vcpu, X86_FEATURE_AMD_PMU_V2)) {
>> +             pmu->version = 2;
>> +             entry = kvm_find_cpuid_entry_index(vcpu, 0x80000022, 0);
>> +             ebx.full = entry->ebx;
>> +             pmu->nr_arch_gp_counters = min3((unsigned int)ebx.split.num_core_pmc,
>> +                                             (unsigned int)kvm_pmu_cap.num_counters_gp,
>> +                                             (unsigned int)KVM_AMD_PMC_MAX_GENERIC);
> 
> Blech.  This really shouldn't be necessary, KVM should tweak kvm_pmu_cap.num_counters_gp
> as needed during initialization to ensure num_counters_gp doesn't exceed KVM's
> internal limits.
> 
> Posted a patch[*], please take a look.  As mentioned in that thread, I'll somewhat
> speculatively apply that series sooner than later so that you can use it a base
> for this series (assuming the patch isn't busted).
> 
> [*] https://lore.kernel.org/all/20230124234905.3774678-2-seanjc@google.com
> 
>> +     }
>> +
>> +     /* Commitment to minimal PMCs, regardless of CPUID.80000022 */
> 
> Please expand this comment.  I'm still not entirely sure I've interpreted it correctly,
> and I'm not sure that I agree with the code.

In the first version [1], I used almost the same if-elif-else sequence
but the concerns from JimM[2] has changed my mind:

"Nonetheless, for compatibility with old software, Fn8000_0022_EBX can never
report less than four counters (or six, if Fn8000_0001_ECX[PerfCtrExtCore] is set)."

Both in amd_pmu_refresh() and in __do_cpuid_func(), KVM implements
this using the override approach of first applying the semantics of
AMD_PMU_V2 and then implementing a minimum number of counters
supported based on whether or not guest have  PERFCTR_CORE,
the proposed if-elif-else does not fulfill this need.

[1] 20220905123946.95223-4-likexu@tencent.com/
[2] CALMp9eQObuiJGV=YrAU9Fw+KoXfJtZMJ-KUs-qCOVd+R9zGBpw@mail.gmail.com

> 
>> +     if (kvm_cpu_cap_has(X86_FEATURE_PERFCTR_CORE) &&
> 
> AFAICT, checking kvm_cpu_cap_has() is an unrelated change.  Either it's a bug fix
> and belongs in a separate patch, or it's unnecessary and should be dropped.
> 
>> +         guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE))
>> +             pmu->nr_arch_gp_counters = max_t(unsigned int,
>> +                                              pmu->nr_arch_gp_counters,
>> +                                              AMD64_NUM_COUNTERS_CORE);
>>        else
>> -             pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS;
>> +             pmu->nr_arch_gp_counters = max_t(unsigned int,
>> +                                              pmu->nr_arch_gp_counters,
>> +                                              AMD64_NUM_COUNTERS);
> 
> Using max() doesn't look right.  E.g. if KVM ends up running on some odd setup
> where ebx.split.num_core_pmc/kvm_pmu_cap.num_counters_gp is less than
> AMD64_NUM_COUNTERS_CORE or AMD64_NUM_COUNTERS.
> 
> Or more likely, if userspace says "only expose N counters to this guest".
> 
> Shouldn't this be something like?
> 
> 	if (guest_cpuid_has(vcpu, X86_FEATURE_AMD_PMU_V2))
> 		pmu->nr_arch_gp_counters = min(ebx.split.num_core_pmc,
> 					       kvm_pmu_cap.num_counters_gp);
> 	else if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE))
> 		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS_CORE;
> 	else
> 		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERSE;
> 
