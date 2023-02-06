Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1C868BBF5
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 12:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjBFLrY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 06:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjBFLrX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 06:47:23 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01494526B;
        Mon,  6 Feb 2023 03:47:21 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id mi9so11347343pjb.4;
        Mon, 06 Feb 2023 03:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G1fIGlri3OVagECTjdCYau5vxAhGRYYCU3SOVSoQVck=;
        b=YEIdJ+T7HSZteCM+8qKysXZWf/v/QjQp0TZDxxcv1fgg5Qw4wWwXkC8RwUTNvUh6O3
         HJXuNLlZB3yGs32Uux9YxNvka1qO6cYgdfRJvii9J6Q61bl9kSdODl65d570FWrlShbj
         KUi+iTEryZtOvXL4Sv3Dkih7t9vQsNErjSfoP/3qVG5RN2CpxmeJ3h7ZLOfK1OAavVZp
         /DN4EOsQGSjVsU5fW2vOGENKjpXtlbpQdE42oP5nEI1EJPRHgkVqKU8rJGqFgIAHMCvl
         Z4Z0aUO/7bVwyKZ63ki+Ffm95HcZghRQgiOdgXYdhkuaCVMJVQFiVHCGf+5tInqY9ScX
         ko/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G1fIGlri3OVagECTjdCYau5vxAhGRYYCU3SOVSoQVck=;
        b=t/HsmM26HdjmbG9q1g0oFHsjXw8rY7SbfL4k5GOUx3YXFdGWnMAS/3UZKHYJ0runpd
         1dVeoa7uFu5ehxix8izNtLSezqV0tX77YItSUWSZRTcrC5djIJCfOdnA08bp76TPJkoJ
         56sDLDFVc34vqg3h3dXa228HmL0ZbpZkWm6jFjzjftVkWDEFvLwIdMCb6dK/6tYVUglg
         o8TBWfkyKtiOgRkEyh2sqJMtcwIPMvQlNKLB948XyeCn/iaydVrH+gGs1Ka0iqEP+9nm
         NFhZEwpfcutZm5HOe0veTgnnzCBFRhOpmTCcInqprOSUo6CiNQgvMAY+b73PVdVoU8iW
         xWCQ==
X-Gm-Message-State: AO0yUKWRLr5cF9kVX4PfUgVut3L7m8HnwyDmOZRvc9+OmecpI3WpqnQ8
        rtgC+mnaU7Ue25ZblSlY9ts=
X-Google-Smtp-Source: AK7set9nd6Om68w1IEJLHmaMAFordvyN+KWFDHRAMONESM83Ai3kmly7T2BaGKX4dmxsZALA2rTCwg==
X-Received: by 2002:a17:903:283:b0:198:de07:f3d with SMTP id j3-20020a170903028300b00198de070f3dmr15118178plr.41.1675684041280;
        Mon, 06 Feb 2023 03:47:21 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id v17-20020a1709028d9100b00198e948d0ffsm5323750plo.276.2023.02.06.03.47.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 03:47:21 -0800 (PST)
Message-ID: <4a7fb3b6-f9eb-6cde-7120-7d256d9d288e@gmail.com>
Date:   Mon, 6 Feb 2023 19:47:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v3 5/8] KVM: x86/cpuid: Add X86_FEATURE_AMD_PMU_V2 as a
 KVM-only leaf entry
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221111102645.82001-1-likexu@tencent.com>
 <20221111102645.82001-6-likexu@tencent.com> <Y9A13G5b1tuoIRUq@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Y9A13G5b1tuoIRUq@google.com>
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

On 25/1/2023 3:47 am, Sean Christopherson wrote:
> On Fri, Nov 11, 2022, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> Alias X86_FEATURE_AMD_PMU_V2 for feature AMD_PMU_V2 in KVM-only leafs that
>> aren't scattered by cpufeatures.h so that it can be used in KVM, e.g. to
>> query guest CPUID.  As a bonus, no translation is needed for these features
>> in __feature_translate().
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   arch/x86/kvm/reverse_cpuid.h | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
>> index a19d473d0184..7cfedb3e47c0 100644
>> --- a/arch/x86/kvm/reverse_cpuid.h
>> +++ b/arch/x86/kvm/reverse_cpuid.h
>> @@ -13,6 +13,7 @@
>>    */
>>   enum kvm_only_cpuid_leafs {
>>   	CPUID_12_EAX	 = NCAPINTS,
>> +	CPUID_8000_0022_EAX,
>>   	NR_KVM_CPU_CAPS,
>>   
>>   	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
>> @@ -23,7 +24,15 @@ enum kvm_only_cpuid_leafs {
>>   /* Intel-defined SGX sub-features, CPUID level 0x12 (EAX). */
>>   #define KVM_X86_FEATURE_SGX1		KVM_X86_FEATURE(CPUID_12_EAX, 0)
>>   #define KVM_X86_FEATURE_SGX2		KVM_X86_FEATURE(CPUID_12_EAX, 1)
>> +#define KVM_X86_FEATURE_AMD_PMU_V2	KVM_X86_FEATURE(CPUID_8000_0022_EAX, 0)
>>   
>> +/*
>> + * Alias X86_FEATURE_* to the KVM variant for features in KVM-only leafs that
>> + * aren't scattered by cpufeatures.h so that X86_FEATURE_* can be used in KVM,
>> + * e.g. to query guest CPUID.  As a bonus, no translation is needed for these
>> + * features in __feature_translate().
>> + */
>> +#define X86_FEATURE_AMD_PMU_V2      KVM_X86_FEATURE_AMD_PMU_V2
> 
> I gave you bad input earlier, for purely KVM-defined flags there's no need for an
> intermediate KVM_X86_FEATURE_AMD_PMU_V2, this could simply be:
> 
>    #define X86_FEATURE_AMD_PMU_V2         KVM_X86_FEATURE(CPUID_8000_0022_EAX, 0)
> 
> That's a moot point though because, after much searching because I had a very hard
> time believing the kernel wouldn't want to know about this flag, I found commit
> 
>    d6d0c7f681fd ("x86/cpufeatures: Add PerfMonV2 feature bit")
> 
> from nearly a year ago.  I.e. to avoid confusiong, this needs to be a scattered
> flag, not a purely KVM flag.
> 
> ---
>   arch/x86/kvm/reverse_cpuid.h | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
> index 4945456fd646..333e28b0a13c 100644
> --- a/arch/x86/kvm/reverse_cpuid.h
> +++ b/arch/x86/kvm/reverse_cpuid.h
> @@ -15,6 +15,7 @@ enum kvm_only_cpuid_leafs {
>   	CPUID_12_EAX	 = NCAPINTS,
>   	CPUID_7_1_EDX,
>   	CPUID_8000_0007_EDX,
> +	CPUID_8000_0022_EAX,
>   	NR_KVM_CPU_CAPS,
>   
>   	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
> @@ -47,6 +48,9 @@ enum kvm_only_cpuid_leafs {
>   /* CPUID level 0x80000007 (EDX). */
>   #define KVM_X86_FEATURE_CONSTANT_TSC	KVM_X86_FEATURE(CPUID_8000_0007_EDX, 8)
>   
> +/* CPUID level 0x80000022 (EAX) */
> +#define KVM_X86_FEATURE_PERFMON_V2	KVM_X86_FEATURE(CPUID_8000_0022_EAX, 0)

I'm very confused and is this the usage you want to see:

	kvm_cpu_cap_set(KVM_X86_FEATURE_PERFMON_V2)
	kvm_cpu_cap_has(KVM_X86_FEATURE_PERFMON_V2)
	guest_cpuid_has(vcpu, X86_FEATURE_PERFMON_V2)

? then what about X86_FEATURE_PERFMON_V2 ?

> +
>   struct cpuid_reg {
>   	u32 function;
>   	u32 index;
> @@ -73,6 +77,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
>   	[CPUID_8000_001F_EAX] = {0x8000001f, 0, CPUID_EAX},
>   	[CPUID_7_1_EDX]       = {         7, 1, CPUID_EDX},
>   	[CPUID_8000_0007_EDX] = {0x80000007, 0, CPUID_EDX},
> +	[CPUID_8000_0022_EAX] = {0x80000022, 0, CPUID_EAX},
>   };
>   
>   /*
> @@ -107,6 +112,8 @@ static __always_inline u32 __feature_translate(int x86_feature)
>   		return KVM_X86_FEATURE_SGX_EDECCSSA;
>   	else if (x86_feature == X86_FEATURE_CONSTANT_TSC)
>   		return KVM_X86_FEATURE_CONSTANT_TSC;
> +	else if (x86_feature == X86_FEATURE_PERFMON_V2)
> +		return KVM_X86_FEATURE_PERFMON_V2;
>   
>   	return x86_feature;
>   }
> 
> base-commit: 5f3f3cc1279cd5cd52d301b97844bd3ce40c8020
