Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B0E5AFAE8
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 06:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiIGD76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 23:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiIGD75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 23:59:57 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 176D423177;
        Tue,  6 Sep 2022 20:59:56 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id s206so12421334pgs.3;
        Tue, 06 Sep 2022 20:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Gnmj5Ex/DqjzpQRNGRfdTyZgVm5mtikP88bVpR4fJzM=;
        b=bqbeoBZwGgYDYNoWifCe6sUVcoOIKi/6vNhdXlZWi+odXuwGfFpte+F+WotAI3VxnU
         m4biV5jOhm1kmJU0NSu0A7Vzs9Xrw654aux5xbPFTrrYjngJy1tuql8WUL3L/euHbETy
         nD/Xod1vRL5YRUcj6Z3VX4iAKRGP64S4Ae66zNR01PPNPqwJ06qm9lijDESJgvJz0a09
         PJnNqA+59tqUjzj97qaJ+SbxO8hgFy2tjjyRRLHw76JnxHAlIfQcvVpjXwOcIabueRTc
         PnLVeLIWAm0JPrTKzIUPFXCAS97d+kd+6qQUKBQ/R+EuPoPyviw9V8UXzeIS0xungOlW
         Fpgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Gnmj5Ex/DqjzpQRNGRfdTyZgVm5mtikP88bVpR4fJzM=;
        b=SRVAPDv++uy9KTqymetiugPy+WApUPR8fu/TkFc6ZPJetpt3PWeLr2OT8deYNvc/Sb
         xVIGdWQDgNTFb28WmkBV4dq+azagnd3INZdDKdBhkQJvF27eCdcjVBaPRgYBx99LvoUG
         YzoQqYD6bNW9T8/QdYBCKAoaywSfUWAoKlIkzEsj9Dr+nM91s3NBq/OBNedixTwXyOPZ
         p0V5Ke2MXRYwzkjxXGmRBHqZ2+APH/nP8yuVCBCVbaXRGE9k3DUA1m7SE2alxN51AFZJ
         6IZKtMdNGC4fIbfMbbI/2XZoNxe23Q5A+rjdcvlmCA8iYmF+mQUH0cOBs+DB6AeGNpax
         M/WA==
X-Gm-Message-State: ACgBeo2hljmA57A4Hh5Ob9AV3vGTRWtPOA09hW3eTEOpc19rQZmUmutE
        +gsJDT4P58lt46CYkEObYEM=
X-Google-Smtp-Source: AA6agR6O7dvel/ZLFrmkLY4tXDS/tRf0PX1WYWVV/PY0Hsxl3LNPF9weKZVQdUtmef+99zbe3lVfYQ==
X-Received: by 2002:a63:91c3:0:b0:434:bafa:ce88 with SMTP id l186-20020a6391c3000000b00434baface88mr1655529pge.188.1662523195621;
        Tue, 06 Sep 2022 20:59:55 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id y15-20020a17090a16cf00b002005fcd2cb4sm5090314pje.2.2022.09.06.20.59.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 20:59:55 -0700 (PDT)
Message-ID: <d63e79d8-fcbc-9def-4a90-e7a4614493bb@gmail.com>
Date:   Wed, 7 Sep 2022 11:59:45 +0800
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
 <0e0f773b-0dde-2282-c2d0-fad2311f59a7@gmail.com>
 <CALMp9eQQe-XDUZmNtg5Z+Vv8hMu_R_fuTv2+-ZfuRwzNUmW0fA@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <CALMp9eQQe-XDUZmNtg5Z+Vv8hMu_R_fuTv2+-ZfuRwzNUmW0fA@mail.gmail.com>
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

On 7/9/2022 4:08 am, Jim Mattson wrote:
> On Tue, Sep 6, 2022 at 5:53 AM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> On 6/9/2022 1:36 am, Jim Mattson wrote:
>>> On Mon, Sep 5, 2022 at 5:45 AM Like Xu <like.xu.linux@gmail.com> wrote:
>>>>
>>>> From: Sandipan Das <sandipan.das@amd.com>
>>>>
>>>> CPUID leaf 0x80000022 i.e. ExtPerfMonAndDbg advertises some
>>>> new performance monitoring features for AMD processors.
>>>>
>>>> Bit 0 of EAX indicates support for Performance Monitoring
>>>> Version 2 (PerfMonV2) features. If found to be set during
>>>> PMU initialization, the EBX bits of the same CPUID function
>>>> can be used to determine the number of available PMCs for
>>>> different PMU types.
>>>>
>>>> Expose the relevant bits via KVM_GET_SUPPORTED_CPUID so
>>>> that guests can make use of the PerfMonV2 features.
>>>>
>>>> Co-developed-by: Like Xu <likexu@tencent.com>
>>>> Signed-off-by: Like Xu <likexu@tencent.com>
>>>> Signed-off-by: Sandipan Das <sandipan.das@amd.com>
>>>> ---
>>>>    arch/x86/include/asm/perf_event.h |  8 ++++++++
>>>>    arch/x86/kvm/cpuid.c              | 21 ++++++++++++++++++++-
>>>>    2 files changed, 28 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
>>>> index f6fc8dd51ef4..c848f504e467 100644
>>>> --- a/arch/x86/include/asm/perf_event.h
>>>> +++ b/arch/x86/include/asm/perf_event.h
>>>> @@ -214,6 +214,14 @@ union cpuid_0x80000022_ebx {
>>>>           unsigned int            full;
>>>>    };
>>>>
>>>> +union cpuid_0x80000022_eax {
>>>> +       struct {
>>>> +               /* Performance Monitoring Version 2 Supported */
>>>> +               unsigned int    perfmon_v2:1;
>>>> +       } split;
>>>> +       unsigned int            full;
>>>> +};
>>>> +
>>>>    struct x86_pmu_capability {
>>>>           int             version;
>>>>           int             num_counters_gp;
>>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>>> index 75dcf7a72605..08a29ab096d2 100644
>>>> --- a/arch/x86/kvm/cpuid.c
>>>> +++ b/arch/x86/kvm/cpuid.c
>>>> @@ -1094,7 +1094,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>>>>                   entry->edx = 0;
>>>>                   break;
>>>>           case 0x80000000:
>>>> -               entry->eax = min(entry->eax, 0x80000021);
>>>> +               entry->eax = min(entry->eax, 0x80000022);
>>>>                   /*
>>>>                    * Serializing LFENCE is reported in a multitude of ways, and
>>>>                    * NullSegClearsBase is not reported in CPUID on Zen2; help
>>>> @@ -1203,6 +1203,25 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>>>>                   if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
>>>>                           entry->eax |= BIT(6);
>>>>                   break;
>>>> +       /* AMD Extended Performance Monitoring and Debug */
>>>> +       case 0x80000022: {
>>>> +               union cpuid_0x80000022_eax eax;
>>>> +               union cpuid_0x80000022_ebx ebx;
>>>> +
>>>> +               entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
>>>> +               if (!enable_pmu)
>>>> +                       break;
>>>> +
>>>> +               if (kvm_pmu_cap.version > 1) {
>>>> +                       /* AMD PerfMon is only supported up to V2 in the KVM. */
>>>> +                       eax.split.perfmon_v2 = 1;
>>>> +                       ebx.split.num_core_pmc = min(kvm_pmu_cap.num_counters_gp,
>>>> +                                                    KVM_AMD_PMC_MAX_GENERIC);
>>>
>>> Note that the number of core PMCs has to be at least 6 if
>>> guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE). I suppose this leaf
>>> could claim fewer, but the first 6 PMCs must work, per the v1 PMU
>>> spec. That is, software that knows about PERFCTR_CORE, but not about
>>> PMU v2, can rightfully expect 6 PMCs.
>>
>> I thought the NumCorePmc number would only make sense if
>> CPUID.80000022.eax.perfmon_v2
>> bit was present, but considering that the user space is perfectly fine with just
>> configuring the
>> NumCorePmc number without setting perfmon_v2 bit at all, so how about:
> 
> CPUID.80000022H might only make sense if X86_FEATURE_PERFCTR_CORE is
> present. It's hard to know in the absence of documentation.

Whenever this happens, we may always leave the definition of behavior to the 
hypervisor.

> 
>>          /* AMD Extended Performance Monitoring and Debug */
>>          case 0x80000022: {
>>                  union cpuid_0x80000022_eax eax;
>>                  union cpuid_0x80000022_ebx ebx;
>>                  bool perfctr_core;
>>
>>                  entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
>>                  if (!enable_pmu)
>>                          break;
>>
>>                  perfctr_core = kvm_cpu_cap_has(X86_FEATURE_PERFCTR_CORE);
>>                  if (!perfctr_core)
>>                          ebx.split.num_core_pmc = AMD64_NUM_COUNTERS;
>>                  if (kvm_pmu_cap.version > 1) {
>>                          /* AMD PerfMon is only supported up to V2 in the KVM. */
>>                          eax.split.perfmon_v2 = 1;
>>                          ebx.split.num_core_pmc = min(kvm_pmu_cap.num_counters_gp,
>>                                                       KVM_AMD_PMC_MAX_GENERIC);
>>                  }
>>                  if (perfctr_core) {
>>                          ebx.split.num_core_pmc = max(ebx.split.num_core_pmc,
>>                                                       AMD64_NUM_COUNTERS_CORE);
>>                  }
> 
> This still isn't quite right. All AMD CPUs must support a minimum of 4 PMCs.

K7 at least. I could not confirm that all antique AMD CPUs have 4 counters w/o 
perfctr_core.

> 
>>
>>                  entry->eax = eax.full;
>>                  entry->ebx = ebx.full;
>>                  break;
>>          }
>>
>> ?
>>
>> Once 0x80000022 appears, ebx.split.num_core_pmc will report only
>> the real "Number of Core Performance Counters" regardless of perfmon_v2.
>>
>>>
>>>
>>>> +               }
>>>> +               entry->eax = eax.full;
>>>> +               entry->ebx = ebx.full;
>>>> +               break;
>>>> +       }
>>>>           /*Add support for Centaur's CPUID instruction*/
>>>>           case 0xC0000000:
>>>>                   /*Just support up to 0xC0000004 now*/
>>>> --
>>>> 2.37.3
>>>>
