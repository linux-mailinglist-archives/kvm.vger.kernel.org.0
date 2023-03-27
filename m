Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 120606C9CB1
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 09:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbjC0HsL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 03:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232255AbjC0HsJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 03:48:09 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173BB1986;
        Mon, 27 Mar 2023 00:47:45 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id c4so4986650pfl.0;
        Mon, 27 Mar 2023 00:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679903264;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S0vxj5YCRRJuld0ubNXra4DXbGLmwPLiSWw6QOm1FNk=;
        b=dgkJCoTzfDroB99NtBKd57edkxKCItwRC3ZB6rUDR2S91Ki2PH7zpq6gjxeGGvo8KK
         BNCDGtXV7SYWj46aMIggMdKMcqSwYCQBeU8uPGsNnp1fPIi3xPwYJqsIBsL6kxX2mOIs
         whLytDBmlEXx7NUbd0G4vQ5m0vYagerliJp6EOjddDErX4Q3qs21fW+DWUxKkkNiKEhZ
         tdcT6SrrYbGRJiZChtsVx4p9YbWzYOqcyVN0LvJi1ni1S9c9Kmw8Cik+uiRcmz4cmJQQ
         pD2sw0xA+RAKKwmcOb02wHGLMqj72cgTAoSaarGF8Z4P2hsSsSM2MTN9M/oL1790vot2
         toTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679903264;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S0vxj5YCRRJuld0ubNXra4DXbGLmwPLiSWw6QOm1FNk=;
        b=BN/KXIZ55zQWTXO37s2Lj0s+4DsHW+XMg2BrcxTm9dARoVQ9IpCn7JDSbnG7BvvJ10
         jLPdVU2iO+YXbD69ku9no24220tGM4WzmPrfSAYoxRy22kjwmOijJHJZPaFC3CTKQXfM
         ju9i6vTH/yTeuQHd+eThNuwy/4TjGmlM1AyiYeN3h75XhYStk6fd1sPt3woqCmt2mY/2
         xWPMC6iuJZArQ2CixQHSGvF0KPKXRI7FUTj+D2Qhr4VOFp+wcGkkAaIgEE3N3n6lVSUL
         KEeX5W6WNIsi7dw3nPIndyVau7w3y9OQiPhbC/BofU06VFEpvYr2oWd37tf0huPZqDxt
         h7Gg==
X-Gm-Message-State: AO0yUKU6yAhYXqT/g6WV0DYBPW7crRG+ygUZ0VqXHl4jmcwOEXnzXlMz
        328i7ZTI0v3enQDy5bynu0g=
X-Google-Smtp-Source: AK7set+G2S9xHqUd+wHS0T8pOug+8soPc6VrZ/Wh+sI2BWybHHrsJfIzUB8Yg3DikXFRMdSKkm5LgQ==
X-Received: by 2002:a05:6a00:1795:b0:594:1f1c:3d3b with SMTP id s21-20020a056a00179500b005941f1c3d3bmr20993157pfg.16.1679903264250;
        Mon, 27 Mar 2023 00:47:44 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id i10-20020aa78d8a000000b006281bc04392sm10679150pfr.191.2023.03.27.00.47.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 00:47:43 -0700 (PDT)
Message-ID: <e002f554-b69d-cedf-162c-271bc3609a39@gmail.com>
Date:   Mon, 27 Mar 2023 15:47:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH] KVM: x86/pmu: Add Intel PMU supported fixed counters bit
 mask
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230321112742.25255-1-likexu@tencent.com>
 <CALMp9eT0SrXCLriBN+nBv5fFQQ3n+b4Guq=-yLsFFQjeQ-nczA@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <CALMp9eT0SrXCLriBN+nBv5fFQQ3n+b4Guq=-yLsFFQjeQ-nczA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/3/2023 7:19 am, Jim Mattson wrote:
> On Tue, Mar 21, 2023 at 4:28 AM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> From: Like Xu <likexu@tencent.com>
>>
>> Per Intel SDM, fixed-function performance counter 'i' is supported if:
>>
>>          FxCtr[i]_is_supported := ECX[i] || (EDX[4:0] > i);
>>
>> which means that the KVM user space can use EDX to limit the number of
>> fixed counters and at the same time, using ECX to enable part of other
>> KVM supported fixed counters.
>>
>> Add a bitmap (instead of always checking the vcpu's CPUIDs) to keep track
>> of the guest available fixed counters and perform the semantic checks.
>>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h |  2 ++
>>   arch/x86/kvm/pmu.h              |  8 +++++
>>   arch/x86/kvm/vmx/pmu_intel.c    | 53 +++++++++++++++++++++------------
>>   3 files changed, 44 insertions(+), 19 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index a45de1118a42..14689e583127 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -565,6 +565,8 @@ struct kvm_pmu {
>>           */
>>          bool need_cleanup;
>>
>> +       DECLARE_BITMAP(supported_fixed_pmc_idx, KVM_PMC_MAX_FIXED);
>> +
>>          /*
>>           * The total number of programmed perf_events and it helps to avoid
>>           * redundant check before cleanup if guest don't use vPMU at all.
>> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
>> index be62c16f2265..9f4504e5e9d5 100644
>> --- a/arch/x86/kvm/pmu.h
>> +++ b/arch/x86/kvm/pmu.h
>> @@ -111,6 +111,11 @@ static inline struct kvm_pmc *get_gp_pmc(struct kvm_pmu *pmu, u32 msr,
>>          return NULL;
>>   }
>>
>> +static inline bool fixed_ctr_is_supported(struct kvm_pmu *pmu, unsigned int idx)
>> +{
>> +       return test_bit(idx, pmu->supported_fixed_pmc_idx);
>> +}
>> +
>>   /* returns fixed PMC with the specified MSR */
>>   static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 msr)
>>   {
>> @@ -120,6 +125,9 @@ static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 msr)
>>                  u32 index = array_index_nospec(msr - base,
>>                                                 pmu->nr_arch_fixed_counters);
>>
>> +               if (!fixed_ctr_is_supported(pmu, index))
>> +                       return NULL;
>> +
>>                  return &pmu->fixed_counters[index];
>>          }
>>
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index e8a3be0b9df9..12f4b2fe7756 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -43,13 +43,16 @@ static int fixed_pmc_events[] = {1, 0, 7};
>>   static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
>>   {
>>          struct kvm_pmc *pmc;
>> -       u8 old_fixed_ctr_ctrl = pmu->fixed_ctr_ctrl;
>> +       u8 new_ctrl, old_ctrl, old_fixed_ctr_ctrl = pmu->fixed_ctr_ctrl;
>>          int i;
>>
>>          pmu->fixed_ctr_ctrl = data;
>>          for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
>> -               u8 new_ctrl = fixed_ctrl_field(data, i);
>> -               u8 old_ctrl = fixed_ctrl_field(old_fixed_ctr_ctrl, i);
>> +               if (!fixed_ctr_is_supported(pmu, i))
>> +                       continue;
>> +
>> +               new_ctrl = fixed_ctrl_field(data, i);
>> +               old_ctrl = fixed_ctrl_field(old_fixed_ctr_ctrl, i);
>>
>>                  if (old_ctrl == new_ctrl)
>>                          continue;
>> @@ -125,6 +128,9 @@ static bool intel_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
>>
>>          idx &= ~(3u << 30);
>>
>> +       if (fixed && !fixed_ctr_is_supported(pmu, idx))
>> +               return false;
>> +
>>          return fixed ? idx < pmu->nr_arch_fixed_counters
>>                       : idx < pmu->nr_arch_gp_counters;
>>   }
>> @@ -145,7 +151,7 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
>>                  counters = pmu->gp_counters;
>>                  num_counters = pmu->nr_arch_gp_counters;
>>          }
>> -       if (idx >= num_counters)
>> +       if (idx >= num_counters || (fixed && !fixed_ctr_is_supported(pmu, idx)))
>>                  return NULL;
>>          *mask &= pmu->counter_bitmask[fixed ? KVM_PMC_FIXED : KVM_PMC_GP];
>>          return &counters[array_index_nospec(idx, num_counters)];
>> @@ -500,6 +506,9 @@ static void setup_fixed_pmc_eventsel(struct kvm_pmu *pmu)
>>          int i;
>>
>>          for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
>> +               if (!fixed_ctr_is_supported(pmu, i))
>> +                       continue;
>> +
>>                  pmc = &pmu->fixed_counters[i];
>>                  event = fixed_pmc_events[array_index_nospec(i, size)];
>>                  pmc->eventsel = (intel_arch_events[event].unit_mask << 8) |
>> @@ -520,6 +529,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>>
>>          pmu->nr_arch_gp_counters = 0;
>>          pmu->nr_arch_fixed_counters = 0;
>> +       bitmap_zero(pmu->supported_fixed_pmc_idx, KVM_PMC_MAX_FIXED);
>>          pmu->counter_bitmask[KVM_PMC_GP] = 0;
>>          pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
>>          pmu->version = 0;
>> @@ -551,13 +561,24 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>>          pmu->available_event_types = ~entry->ebx &
>>                                          ((1ull << eax.split.mask_length) - 1);
>>
>> -       if (pmu->version == 1) {
>> -               pmu->nr_arch_fixed_counters = 0;
>> -       } else {
>> +       counter_mask = ~(BIT_ULL(pmu->nr_arch_gp_counters) - 1);
>> +       bitmap_set(pmu->all_valid_pmc_idx, 0, pmu->nr_arch_gp_counters);
>> +
>> +       if (pmu->version > 1) {
>>                  pmu->nr_arch_fixed_counters =
>> -                       min3(ARRAY_SIZE(fixed_pmc_events),
>> -                            (size_t) edx.split.num_counters_fixed,
>> -                            (size_t)kvm_pmu_cap.num_counters_fixed);
>> +                       min_t(int, ARRAY_SIZE(fixed_pmc_events),
>> +                             kvm_pmu_cap.num_counters_fixed);
>> +               for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
>> +                       /* FxCtr[i]_is_supported := CPUID.0xA.ECX[i] || (EDX[4:0] > i) */
> 
> This is true only when pmu->version >= 5.

This is true in for "Version 5" section, but not mentioned in the CPUID.0xA section.
I would argue that this is a deliberate omission for the instruction implementation,
as it does use the word "version>1" in the near CPUID.0xA.EDX section.

For virtualised use, this feature offers a kind of flexibility as users can 
enable part of
the fixed counters, don't you think? Or maybe you're more looking forward to the
patch set that raises the vPMU version number from 2 to 5, that part of the code
was already in my tree some years ago.

> 
>  From the SDM, volume 3, section 20.2.5 Architectural Performance
> Monitoring Version 5:
> 
> With Architectural Performance Monitoring Version 5, register
> CPUID.0AH.ECX indicates Fixed Counter enumeration. It is a bit mask
> which enumerates the supported Fixed Counters in a processor. If bit
> 'i' is set, it implies that Fixed Counter 'i' is supported. Software
> is recommended to use the following logic to check if a Fixed Counter
> is supported on a given processor: FxCtr[i]_is_supported := ECX[i] ||
> (EDX[4:0] > i);
> 
> Prior to PMU version 5, all fixed counters from 0 through <number of
> fixed counters - 1> are supported.
> 
>> +                       if (!(entry->ecx & BIT_ULL(i) ||
>> +                             edx.split.num_counters_fixed > i))
>> +                               continue;
>> +
>> +                       set_bit(i, pmu->supported_fixed_pmc_idx);
>> +                       set_bit(INTEL_PMC_MAX_GENERIC + i, pmu->all_valid_pmc_idx);
>> +                       pmu->fixed_ctr_ctrl_mask &= ~(0xbull << (i * 4));
>> +                       counter_mask &= ~BIT_ULL(INTEL_PMC_MAX_GENERIC + i);
>> +               }
>>                  edx.split.bit_width_fixed = min_t(int, edx.split.bit_width_fixed,
>>                                                    kvm_pmu_cap.bit_width_fixed);
>>                  pmu->counter_bitmask[KVM_PMC_FIXED] =
>> @@ -565,10 +586,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>>                  setup_fixed_pmc_eventsel(pmu);
>>          }
>>
>> -       for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
>> -               pmu->fixed_ctr_ctrl_mask &= ~(0xbull << (i * 4));
>> -       counter_mask = ~(((1ull << pmu->nr_arch_gp_counters) - 1) |
>> -               (((1ull << pmu->nr_arch_fixed_counters) - 1) << INTEL_PMC_IDX_FIXED));
>>          pmu->global_ctrl_mask = counter_mask;
>>          pmu->global_ovf_ctrl_mask = pmu->global_ctrl_mask
>>                          & ~(MSR_CORE_PERF_GLOBAL_OVF_CTRL_OVF_BUF |
>> @@ -585,11 +602,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>>                  pmu->raw_event_mask |= (HSW_IN_TX|HSW_IN_TX_CHECKPOINTED);
>>          }
>>
>> -       bitmap_set(pmu->all_valid_pmc_idx,
>> -               0, pmu->nr_arch_gp_counters);
>> -       bitmap_set(pmu->all_valid_pmc_idx,
>> -               INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
>> -
>>          perf_capabilities = vcpu_get_perf_capabilities(vcpu);
>>          if (cpuid_model_is_consistent(vcpu) &&
>>              (perf_capabilities & PMU_CAP_LBR_FMT))
>> @@ -605,6 +617,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>>                          pmu->pebs_enable_mask = counter_mask;
>>                          pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
>>                          for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
>> +                               if (!fixed_ctr_is_supported(pmu, i))
>> +                                       continue;
>> +
>>                                  pmu->fixed_ctr_ctrl_mask &=
>>                                          ~(1ULL << (INTEL_PMC_IDX_FIXED + i * 4));
>>                          }
>>
>> base-commit: d8708b80fa0e6e21bc0c9e7276ad0bccef73b6e7
>> --
>> 2.40.0
>>
