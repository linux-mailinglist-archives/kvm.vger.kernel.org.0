Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C8B5AE8DE
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 14:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240337AbiIFMyY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 08:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240472AbiIFMyD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 08:54:03 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38C76C120;
        Tue,  6 Sep 2022 05:53:30 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id z187so11260059pfb.12;
        Tue, 06 Sep 2022 05:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=WH0PAglD7NlW66HOCEb44ocuUbYF/1F/c9xurb0cOJE=;
        b=U/6HFqn10+uX/wVJbOqwNuNVkJ+Zg4eAolFO7k7wAZi4f+FOurGqVxC3d3eSuHc1OL
         EETBOfIg6VcqD9HB9pVlfTwus1LVyJRsWJgmyHhraxVNctIVBha2ZIM5wugFaO31yYFd
         2vHSwjDYEBmOPkiOYNfyXLdWoT6BWCMQTG2QltKfat4xf3XAbnxPZMdGxBeQopNBUndf
         m3ZXs8WKux8MAel6eXR0zV+JUiuDXfOVyE4eM6zG243X96Ljj1uxN7q9Cn/hKQwthDV3
         QZRuQFBlKGjnrLtnVbpHXZeXwVvQVMs0QYcqJz697JXfzxTqkL0NOIl50zcqkWJiHxFJ
         cfrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=WH0PAglD7NlW66HOCEb44ocuUbYF/1F/c9xurb0cOJE=;
        b=GKFdH6lfMTufXmcHu/XV3ZFqp1Yd3Bu9H+kISowc6wCtFGwyyn16eh3ig9ZTUc4NY1
         OTn+x7X3bEJoHsvXjqIyyp+ZgGaPIlCZRsT84FN5W7TfSO4KT/MaLx/zYlLQi39nTUUQ
         uhPvN6TKWYusns7vRRQeW0Hpb5j3I6x2w/lIjW7gGHvVlFr88wkumYOD+1/2IiA45ngI
         s6Q7SsOcyWKYQJX3TJcyHjAHsogMDCemZFB+W4VbduwYBcFP8sc9DolqePuymLitHFz0
         cGzEh/HMwSDv6MKzvr8RKNRnK8rHnwTNA2n29pwQJpcy2NhzAahN+Y2mc4AiP6tTRkJ4
         Vyhg==
X-Gm-Message-State: ACgBeo1HnY3seotmzK9y6MHBO3pY59eq3WxK68I8gGdSvtKSIAthfFMm
        xm4C9X/rlTERQSBYOPGtDaM=
X-Google-Smtp-Source: AA6agR4AtsVERb8PXWVX6GRxRyZxRaFhECrFJTLLNPOXGOD1UbC4nF4zxVK3bjI7/R2cfRF0viewIg==
X-Received: by 2002:a63:f313:0:b0:434:346b:d074 with SMTP id l19-20020a63f313000000b00434346bd074mr11587027pgh.298.1662468809479;
        Tue, 06 Sep 2022 05:53:29 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b130-20020a621b88000000b0052dbad1ea2esm10067976pfb.6.2022.09.06.05.53.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 05:53:29 -0700 (PDT)
Message-ID: <0e0f773b-0dde-2282-c2d0-fad2311f59a7@gmail.com>
Date:   Tue, 6 Sep 2022 20:53:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH 4/4] KVM: x86/cpuid: Add AMD CPUID ExtPerfMonAndDbg leaf
 0x80000022
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sandipan Das <sandipan.das@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220905123946.95223-1-likexu@tencent.com>
 <20220905123946.95223-5-likexu@tencent.com>
 <CALMp9eQtjZ-iRiW5Jusa+NF-P0sdHtcoR8fPiBSKtNXKgstgVA@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <CALMp9eQtjZ-iRiW5Jusa+NF-P0sdHtcoR8fPiBSKtNXKgstgVA@mail.gmail.com>
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

On 6/9/2022 1:36 am, Jim Mattson wrote:
> On Mon, Sep 5, 2022 at 5:45 AM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> From: Sandipan Das <sandipan.das@amd.com>
>>
>> CPUID leaf 0x80000022 i.e. ExtPerfMonAndDbg advertises some
>> new performance monitoring features for AMD processors.
>>
>> Bit 0 of EAX indicates support for Performance Monitoring
>> Version 2 (PerfMonV2) features. If found to be set during
>> PMU initialization, the EBX bits of the same CPUID function
>> can be used to determine the number of available PMCs for
>> different PMU types.
>>
>> Expose the relevant bits via KVM_GET_SUPPORTED_CPUID so
>> that guests can make use of the PerfMonV2 features.
>>
>> Co-developed-by: Like Xu <likexu@tencent.com>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> Signed-off-by: Sandipan Das <sandipan.das@amd.com>
>> ---
>>   arch/x86/include/asm/perf_event.h |  8 ++++++++
>>   arch/x86/kvm/cpuid.c              | 21 ++++++++++++++++++++-
>>   2 files changed, 28 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
>> index f6fc8dd51ef4..c848f504e467 100644
>> --- a/arch/x86/include/asm/perf_event.h
>> +++ b/arch/x86/include/asm/perf_event.h
>> @@ -214,6 +214,14 @@ union cpuid_0x80000022_ebx {
>>          unsigned int            full;
>>   };
>>
>> +union cpuid_0x80000022_eax {
>> +       struct {
>> +               /* Performance Monitoring Version 2 Supported */
>> +               unsigned int    perfmon_v2:1;
>> +       } split;
>> +       unsigned int            full;
>> +};
>> +
>>   struct x86_pmu_capability {
>>          int             version;
>>          int             num_counters_gp;
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 75dcf7a72605..08a29ab096d2 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -1094,7 +1094,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>>                  entry->edx = 0;
>>                  break;
>>          case 0x80000000:
>> -               entry->eax = min(entry->eax, 0x80000021);
>> +               entry->eax = min(entry->eax, 0x80000022);
>>                  /*
>>                   * Serializing LFENCE is reported in a multitude of ways, and
>>                   * NullSegClearsBase is not reported in CPUID on Zen2; help
>> @@ -1203,6 +1203,25 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>>                  if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
>>                          entry->eax |= BIT(6);
>>                  break;
>> +       /* AMD Extended Performance Monitoring and Debug */
>> +       case 0x80000022: {
>> +               union cpuid_0x80000022_eax eax;
>> +               union cpuid_0x80000022_ebx ebx;
>> +
>> +               entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
>> +               if (!enable_pmu)
>> +                       break;
>> +
>> +               if (kvm_pmu_cap.version > 1) {
>> +                       /* AMD PerfMon is only supported up to V2 in the KVM. */
>> +                       eax.split.perfmon_v2 = 1;
>> +                       ebx.split.num_core_pmc = min(kvm_pmu_cap.num_counters_gp,
>> +                                                    KVM_AMD_PMC_MAX_GENERIC);
> 
> Note that the number of core PMCs has to be at least 6 if
> guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE). I suppose this leaf
> could claim fewer, but the first 6 PMCs must work, per the v1 PMU
> spec. That is, software that knows about PERFCTR_CORE, but not about
> PMU v2, can rightfully expect 6 PMCs.

I thought the NumCorePmc number would only make sense if 
CPUID.80000022.eax.perfmon_v2
bit was present, but considering that the user space is perfectly fine with just 
configuring the
NumCorePmc number without setting perfmon_v2 bit at all, so how about:

	/* AMD Extended Performance Monitoring and Debug */
	case 0x80000022: {
		union cpuid_0x80000022_eax eax;
		union cpuid_0x80000022_ebx ebx;
		bool perfctr_core;

		entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
		if (!enable_pmu)
			break;

		perfctr_core = kvm_cpu_cap_has(X86_FEATURE_PERFCTR_CORE);
		if (!perfctr_core)
			ebx.split.num_core_pmc = AMD64_NUM_COUNTERS;
		if (kvm_pmu_cap.version > 1) {
			/* AMD PerfMon is only supported up to V2 in the KVM. */
			eax.split.perfmon_v2 = 1;
			ebx.split.num_core_pmc = min(kvm_pmu_cap.num_counters_gp,
						     KVM_AMD_PMC_MAX_GENERIC);
		}
		if (perfctr_core) {
			ebx.split.num_core_pmc = max(ebx.split.num_core_pmc,
						     AMD64_NUM_COUNTERS_CORE);
		}

		entry->eax = eax.full;
		entry->ebx = ebx.full;
		break;
	}

?

Once 0x80000022 appears, ebx.split.num_core_pmc will report only
the real "Number of Core Performance Counters" regardless of perfmon_v2.

> 
> 
>> +               }
>> +               entry->eax = eax.full;
>> +               entry->ebx = ebx.full;
>> +               break;
>> +       }
>>          /*Add support for Centaur's CPUID instruction*/
>>          case 0xC0000000:
>>                  /*Just support up to 0xC0000004 now*/
>> --
>> 2.37.3
>>
