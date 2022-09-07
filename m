Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4B85AFA90
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 05:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiIGDZZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 23:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiIGDZY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 23:25:24 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79534BA6C;
        Tue,  6 Sep 2022 20:25:22 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id i15-20020a17090a4b8f00b0020073b4ac27so6698169pjh.3;
        Tue, 06 Sep 2022 20:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=tTLRn9w9UiykvooemDVOzofv3BW6dns0ZzID1eedVrc=;
        b=gjBsXgFoAhMMjOXGNUn/+JytBFMbyzP2ne1NLogY0j9KuTaNm4mWLE45FiRS8UYuA2
         ij5pZUz+AGsxyn5ZcQ0e1/MrGlLtnkXmKT2xqht3NVq/YIUgnlkO3KmM03IDuWzNUJ09
         YNZHBaV4dyNyMXJNoMSKmBCaIKNd6N/Zj2JyYsiop6WseiYBAf65CwaUqui8QIMZkp6R
         tG2P7RBMBqmEZAihgnuc2DkYn57l2Z8uqiOYr0MI6AbljubFibI1KCEheZapOA0de2eB
         PhG5q97UFAUF+yU99WcLeEcLAqHe4SNI2WGZI50XXRV/1w1ZHRKCfTjipHqKAYzIYf2L
         LjMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=tTLRn9w9UiykvooemDVOzofv3BW6dns0ZzID1eedVrc=;
        b=AC0Ms7mE7nk9kLfGbA3xnpE+qyfR1lJDq12CSmlogd4rYuUfiAkY4Vq72Gpg6PA/UG
         k/Zqm0pDJMDsoy7hygQj8ZxcaGA1ZEcyXO6mLh2ZZH+vg/AHszAzOu1IdvPO8SZi1QeE
         mUrNTsJ4PNIPOs7N4p5rtAndQH3Drc1CC8gPdnYJuuvS5WKg2cIrbvc1yT9GOZA9Zk9U
         P4b78n7kNuT6jP1FvG1tlEqWThTctoYY+CFRiGckVbVwwXD6KjzPOSvjrtXPjUnU4Sm7
         9yoZl5Ten6q2Gjs22OvGOT+vhh2TFN6ld0eKUisG/7Ndi3mCqS4WcaSS9hxvaYP0DgTS
         aL1Q==
X-Gm-Message-State: ACgBeo2gHV0tYWWRVqzJ2ajSFoYmPvIz7SuvOU9hg6U6Fz6rzST8Ty40
        0DW6sS9pZTtDakw9A0LU39A=
X-Google-Smtp-Source: AA6agR6PA3ev1EAKtWZ+HtRhiD2nmHKCj8Vhdy+ahTuTRPmnv6tRJgJgAK/RM50uQ4UcmS8ROzqYqA==
X-Received: by 2002:a17:90b:3b8a:b0:1f5:56c3:54ac with SMTP id pc10-20020a17090b3b8a00b001f556c354acmr1768631pjb.2.1662521122296;
        Tue, 06 Sep 2022 20:25:22 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id m3-20020a17090a7f8300b002001c9bf22esm7658937pjl.8.2022.09.06.20.25.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 20:25:21 -0700 (PDT)
Message-ID: <2c9c1e8a-7ab5-8052-3e99-b4ebfd61edde@gmail.com>
Date:   Wed, 7 Sep 2022 11:25:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH] KVM: x86/pmu: omit "impossible" Intel counter MSRs from
 MSR list
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jamttson@google.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220906081604.24035-1-likexu@tencent.com>
 <CALMp9eSQYp-BC_hERH0jzqY1gKU3HLV2YnJDjaAoR7DxRQu=fQ@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <CALMp9eSQYp-BC_hERH0jzqY1gKU3HLV2YnJDjaAoR7DxRQu=fQ@mail.gmail.com>
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

On 7/9/2022 8:37 am, Jim Mattson wrote:
> On Tue, Sep 6, 2022 at 1:16 AM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> From: Like Xu <likexu@tencent.com>
>>
>> According to Intel April 2022 SDM - Table 2-2. IA-32 Architectural MSRs,
>> combined with the address reservation ranges of PERFCTRx, EVENTSELy, and
>> MSR_IA32_PMCz, the theoretical effective maximum value of the Intel GP
>> counters is 14, instead of 18:
>>
>>    14 = 0xE = min (
>>      0xE = IA32_CORE_CAPABILITIES (0xCF) - IA32_PMC0 (0xC1),
>>      0xF = IA32_OVERCLOCKING_STATUS (0x195) - IA32_PERFEVTSEL0 (0x186),
>>      0xF = IA32_MCG_EXT_CTL (0x4D0) - IA32_A_PMC0 (0x4C1)
>>    )
>>
>> the source of the incorrect number may be:
>>    18 = 0x12 = IA32_PERF_STATUS (0x198) - IA32_PERFEVTSEL0 (0x186)
>> but the range covers IA32_OVERCLOCKING_STATUS, which is also architectural.
>> Cut the list to 14 entries to avoid false positives.
>>
>> Cc: Kan Liang <kan.liang@linux.intel.com>
>> Cc: Jim Mattson <jamttson@google.com>
> 
> That should be 'jmattson.'

Oops, my fault.

> 
>> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Fixes: cf05a67b68b8 ("KVM: x86: omit "impossible" pmu MSRs from MSR list")
> 
> I'm not sure I completely agree with the "Fixes," since
> IA32_OVERCLOCKING_STATUS didn't exist back then. However, Paolo did
> make the incorrect assumption that Intel wouldn't cut the range even
> further with the introduction of new MSRs.

This new msr is added in April 2022.

Driver-like software had to keep up with real hardware changes and
speculatively with potential predictable hardware changes until failure.

> 
> To that point, aren't you setting yourself up for a future "Fixes"
> referencing this change?

(1) We have precedents like be4f3b3f8227;
(2) Fixes tags is introduced to help stable trees' maintainers (and their robot 
selectors)
absorb suitable patches like this one. We can expect similar issues with stable 
trees running
on new hardware without this fix.
(3) Fixing the tags does not feather the developer's nest, on the contrary the 
upstream code
itself as a vehicle for our group knowledge, is reinforced.

> 
> We should probably stop at the maximum number of GP PMCs supported
> today (8, I think).

I actually thought that at first, until I saw the speculative offset +17 :D.

> 
> If Intel doubles the number of PMCs to remain competitive with AMD,
> they'll probably put PMCs 8-15 in a completely different range of MSR
> indices.

I'll do a little cleanup work as the next version, stopping the number at 8.

> 
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   arch/x86/kvm/x86.c | 8 ++------
>>   1 file changed, 2 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 43a6a7efc6ec..98cdd4221447 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1431,8 +1431,6 @@ static const u32 msrs_to_save_all[] = {
>>          MSR_ARCH_PERFMON_PERFCTR0 + 8, MSR_ARCH_PERFMON_PERFCTR0 + 9,
>>          MSR_ARCH_PERFMON_PERFCTR0 + 10, MSR_ARCH_PERFMON_PERFCTR0 + 11,
>>          MSR_ARCH_PERFMON_PERFCTR0 + 12, MSR_ARCH_PERFMON_PERFCTR0 + 13,
>> -       MSR_ARCH_PERFMON_PERFCTR0 + 14, MSR_ARCH_PERFMON_PERFCTR0 + 15,
>> -       MSR_ARCH_PERFMON_PERFCTR0 + 16, MSR_ARCH_PERFMON_PERFCTR0 + 17,
>>          MSR_ARCH_PERFMON_EVENTSEL0, MSR_ARCH_PERFMON_EVENTSEL1,
>>          MSR_ARCH_PERFMON_EVENTSEL0 + 2, MSR_ARCH_PERFMON_EVENTSEL0 + 3,
>>          MSR_ARCH_PERFMON_EVENTSEL0 + 4, MSR_ARCH_PERFMON_EVENTSEL0 + 5,
>> @@ -1440,8 +1438,6 @@ static const u32 msrs_to_save_all[] = {
>>          MSR_ARCH_PERFMON_EVENTSEL0 + 8, MSR_ARCH_PERFMON_EVENTSEL0 + 9,
>>          MSR_ARCH_PERFMON_EVENTSEL0 + 10, MSR_ARCH_PERFMON_EVENTSEL0 + 11,
>>          MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 + 13,
>> -       MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
>> -       MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
>>          MSR_IA32_PEBS_ENABLE, MSR_IA32_DS_AREA, MSR_PEBS_DATA_CFG,
>>
>>          MSR_K7_EVNTSEL0, MSR_K7_EVNTSEL1, MSR_K7_EVNTSEL2, MSR_K7_EVNTSEL3,
>> @@ -6943,12 +6939,12 @@ static void kvm_init_msr_list(void)
>>                                  intel_pt_validate_hw_cap(PT_CAP_num_address_ranges) * 2)
>>                                  continue;
>>                          break;
>> -               case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR0 + 17:
>> +               case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR0 + 13:
>>                          if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
>>                              min(INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
>>                                  continue;
>>                          break;
>> -               case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL0 + 17:
>> +               case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL0 + 13:
>>                          if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
>>                              min(INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
>>                                  continue;
>> --
>> 2.37.3
>>
