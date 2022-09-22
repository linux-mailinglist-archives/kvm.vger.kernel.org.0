Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC4A5E5AF8
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 07:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiIVFrw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 01:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiIVFrv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 01:47:51 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F72B40FB;
        Wed, 21 Sep 2022 22:47:49 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id v4so8086308pgi.10;
        Wed, 21 Sep 2022 22:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=x4NnNnawTXFJVg8yDwZJMQUPGTakO4+LOgjirYdrYkQ=;
        b=msJTfnWTtsblJ57DZS7n/WO+OSfFVH+RLlfHbAgCRS1h/QGxE5NpTDcHz2Aaj3VyfN
         3m7xw37FzDDbXcwEpaOoO+1rYuEmc8htHeodms+zyM6sv6MQEr3pq1wS3IV9FlO6tqVt
         M5Qvr67WL7PHeQ1pwyAJlDnCV8dZbkKtiJBylYtOmaRDRqn61lyCd696E3cUf7R9rAEG
         RqOpx97SwcFTIydGkIdIx2X+4HtB2mfK2FGj6og729F93X2Xq2hljZCexSJyeK4FrGar
         UycB2kZ2Mk/l8BYMwXmUYBE1jmX17HyqxMegNK2UCGwp+z8mgDSXgSus4QHLtvyumV2Q
         pY0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=x4NnNnawTXFJVg8yDwZJMQUPGTakO4+LOgjirYdrYkQ=;
        b=R3+PDIQ9wfbkMYTdT/VVA6I1YpIX9TRIcEbf/ZcUYX8lx4t9kXQ5+R/P8T360Qlgf1
         eOKLWcjkrRbSw4EV/kr9+Uay9NLPb/5VjbPwNzXJRo87JAX+6xNkm00nWH9FWzT2o4xT
         cPCahluI4Bgrcr26HrZJjhZwKBPubXhHJ3yYYCAmab2lXZ5Hh/+ENUdmb+35zAEQiTmK
         v/hExvylgs5WDXEDx/m1MufgixCY+IzOhFOCLcHdgIU7ed/4rOQMuyuNtKhsv+E7wDOs
         sgCLS8ZpOQ6q15jr9v4UPDySrP6hGYLGSvHW1Ejb7vQFZaYqzoEzR3h+gCGE4DuI33yM
         Bwow==
X-Gm-Message-State: ACrzQf3VjpL2dChs5jIB8TXsSblgaRO6GeDTQjx96XbCYXE1nydoaqkH
        aQyYEkCl6FVv7BoghRAM4W/AsC0wMdm3tg==
X-Google-Smtp-Source: AMsMyM55RsJuAcJ3JxYW+5urcnzMZMUInvaKpZA3otO6y85XMAs6LgLo7ehRH1IOwc5OUQvzwCwWZA==
X-Received: by 2002:a63:d40b:0:b0:43b:e86f:d384 with SMTP id a11-20020a63d40b000000b0043be86fd384mr1606728pgh.167.1663825669126;
        Wed, 21 Sep 2022 22:47:49 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d185-20020a621dc2000000b00540b979c493sm3197575pfd.55.2022.09.21.22.47.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 22:47:48 -0700 (PDT)
Message-ID: <856e3332-9f6b-a5f7-c3ec-afe89003cb84@gmail.com>
Date:   Thu, 22 Sep 2022 13:47:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v2 1/3] KVM: x86/pmu: Make part of the Intel v2 PMU MSRs
 handling x86 generic
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220919093453.71737-1-likexu@tencent.com>
 <20220919093453.71737-2-likexu@tencent.com>
 <CALMp9eRPEFHFfW+MnMkcTBFB+vjcEe3ekg8JMrKJaRQuq7=-8Q@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <CALMp9eRPEFHFfW+MnMkcTBFB+vjcEe3ekg8JMrKJaRQuq7=-8Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/9/2022 8:20 am, Jim Mattson wrote:
> On Mon, Sep 19, 2022 at 2:35 AM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> From: Like Xu <likexu@tencent.com>
>>
>> The AMD PerfMonV2 defines three registers similar to part of the
>> Intel v2 PMU registers, including the GLOBAL_CTRL, GLOBAL_STATUS
>> and GLOBAL_OVF_CTRL MSRs. For better code reuse, this specific
>> part of the handling can be extracted to make it generic for X86.
>>
>> The new non-prefix pmc_is_enabled() works well as legacy AMD vPMU
>> version is indexeqd as 1. Note that the specific *_is_valid_msr will
> Nit: indexed
>> continue to be used to avoid cross-vendor msr access.
>>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   arch/x86/include/asm/kvm-x86-pmu-ops.h |  1 -
>>   arch/x86/kvm/pmu.c                     | 55 +++++++++++++++++++++---
>>   arch/x86/kvm/pmu.h                     | 30 ++++++++++++-
>>   arch/x86/kvm/svm/pmu.c                 |  9 ----
>>   arch/x86/kvm/vmx/pmu_intel.c           | 58 +-------------------------
>>   5 files changed, 80 insertions(+), 73 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
>> index c17e3e96fc1d..6c98f4bb4228 100644
>> --- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
>> +++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
>> @@ -13,7 +13,6 @@ BUILD_BUG_ON(1)
>>    * at the call sites.
>>    */
>>   KVM_X86_PMU_OP(hw_event_available)
>> -KVM_X86_PMU_OP(pmc_is_enabled)
>>   KVM_X86_PMU_OP(pmc_idx_to_pmc)
>>   KVM_X86_PMU_OP(rdpmc_ecx_to_pmc)
>>   KVM_X86_PMU_OP(msr_idx_to_pmc)
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>> index fabbc43031b3..2643a3994624 100644
>> --- a/arch/x86/kvm/pmu.c
>> +++ b/arch/x86/kvm/pmu.c
>> @@ -83,11 +83,6 @@ void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops)
>>   #undef __KVM_X86_PMU_OP
>>   }
>>
>> -static inline bool pmc_is_enabled(struct kvm_pmc *pmc)
>> -{
>> -       return static_call(kvm_x86_pmu_pmc_is_enabled)(pmc);
>> -}
>> -
>>   static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
>>   {
>>          struct kvm_pmu *pmu = container_of(irq_work, struct kvm_pmu, irq_work);
>> @@ -455,11 +450,61 @@ static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
>>
>>   int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   {
>> +       struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>> +       u32 msr = msr_info->index;
>> +
>> +       switch (msr) {
>> +       case MSR_CORE_PERF_GLOBAL_STATUS:
>> +               msr_info->data = pmu->global_status;
>> +               return 0;
>> +       case MSR_CORE_PERF_GLOBAL_CTRL:
>> +               msr_info->data = pmu->global_ctrl;
>> +               return 0;
>> +       case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
>> +               msr_info->data = 0;
>> +               return 0;
>> +       default:
>> +               break;
>> +       }
>> +
>>          return static_call(kvm_x86_pmu_get_msr)(vcpu, msr_info);
>>   }
>>
>>   int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   {
>> +       struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>> +       u32 msr = msr_info->index;
>> +       u64 data = msr_info->data;
>> +       u64 diff;
>> +
>> +       switch (msr) {
>> +       case MSR_CORE_PERF_GLOBAL_STATUS:
>> +               if (msr_info->host_initiated) {
>> +                       pmu->global_status = data;
>> +                       return 0;
>> +               }
>> +               break; /* RO MSR */
> Perhaps 'return 1'?
>> +       case MSR_CORE_PERF_GLOBAL_CTRL:
>> +               if (pmu->global_ctrl == data)
>> +                       return 0;
>> +               if (kvm_valid_perf_global_ctrl(pmu, data)) {
>> +                       diff = pmu->global_ctrl ^ data;
>> +                       pmu->global_ctrl = data;
>> +                       reprogram_counters(pmu, diff);
>> +                       return 0;
>> +               }
>> +               break;
> Perhaps 'return 1'?
>> +       case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
>> +               if (!(data & pmu->global_ovf_ctrl_mask)) {
>> +                       if (!msr_info->host_initiated)
>> +                               pmu->global_status &= ~data;
>> +                       return 0;
>> +               }
>> +               break;
> Perhaps 'return 1'?

All above applied.

>> +       default:
>> +               break;
>> +       }
>> +
>>          kvm_pmu_mark_pmc_in_use(vcpu, msr_info->index);
>>          return static_call(kvm_x86_pmu_set_msr)(vcpu, msr_info);
>>   }
>> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
>> index 847e7112a5d3..0275f1bff5ea 100644
>> --- a/arch/x86/kvm/pmu.h
>> +++ b/arch/x86/kvm/pmu.h
>> @@ -26,7 +26,6 @@ struct kvm_event_hw_type_mapping {
>>
>>   struct kvm_pmu_ops {
>>          bool (*hw_event_available)(struct kvm_pmc *pmc);
>> -       bool (*pmc_is_enabled)(struct kvm_pmc *pmc);
>>          struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
>>          struct kvm_pmc *(*rdpmc_ecx_to_pmc)(struct kvm_vcpu *vcpu,
>>                  unsigned int idx, u64 *mask);
>> @@ -189,6 +188,35 @@ static inline void kvm_pmu_request_counter_reprogam(struct kvm_pmc *pmc)
>>          kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
>>   }
>>
>> +/*
>> + * Check if a PMC is enabled by comparing it against global_ctrl bits.
>> + *
>> + * If the current version of vPMU doesn't have global_ctrl MSR,
>> + * all vPMCs are enabled (return TRUE).
> 
> The name of this function is a bit misleading. A PMC can be disabled
> either by PERF_CLOBAL_CTRL or by its corresponding EVTSEL.

The name of this function is indeed very legacy.
How about rename it to pmc_is_enabled_globally() in a separate patch?

> 
>> + */
>> +static inline bool pmc_is_enabled(struct kvm_pmc *pmc)
>> +{
>> +       struct kvm_pmu *pmu = pmc_to_pmu(pmc);
>> +
>> +       if (pmu->version < 2)
>> +               return true;
>> +
>> +       return test_bit(pmc->idx, (unsigned long *)&pmu->global_ctrl);
>> +}
>> +
>> +static inline void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
>> +{
>> +       int bit;
>> +
>> +       if (!diff)
>> +               return;
>> +
>> +       for_each_set_bit(bit, (unsigned long *)&diff, X86_PMC_IDX_MAX)
>> +               __set_bit(bit, pmu->reprogram_pmi);
> 
> I see that you've dropped the index to pmc conversion and the test for
> a valid pmc. Maybe this is okay, but I'm not sure what the caller
> looks like, since this is all in global_ctrl_changed() upstream.
> What's your diff base?

As the cover letter says, the diff base is:
https://lore.kernel.org/kvm/20220831085328.45489-1-likexu@tencent.com/.

Based on that, the reprogram_counters() can be reused
when either global_ctrl or pebs_enable is changed.

> 
>> +
>> +       kvm_make_request(KVM_REQ_PMU, pmu_to_vcpu(pmu));
> 
> Why this new request? It's not in the Intel-specific version of these
> function that you elide below.
> 
> Perhaps you could split up the semantic changes from the simple renamings?

The creation of perf_event is delayed to the last step,
https://lore.kernel.org/kvm/20220831085328.45489-5-likexu@tencent.com/

Based on the new code base, no semantic changes I assume.

> 
>> +}
>> +
>>   void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
>>   void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
>>   int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
>> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
>> index f99f2c869664..3a20972e9f1a 100644
>> --- a/arch/x86/kvm/svm/pmu.c
>> +++ b/arch/x86/kvm/svm/pmu.c
>> @@ -76,14 +76,6 @@ static bool amd_hw_event_available(struct kvm_pmc *pmc)
>>          return true;
>>   }
>>
>> -/* check if a PMC is enabled by comparing it against global_ctrl bits. Because
>> - * AMD CPU doesn't have global_ctrl MSR, all PMCs are enabled (return TRUE).
>> - */
>> -static bool amd_pmc_is_enabled(struct kvm_pmc *pmc)
>> -{
>> -       return true;
>> -}
>> -
>>   static bool amd_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
>>   {
>>          struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>> @@ -218,7 +210,6 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
>>
>>   struct kvm_pmu_ops amd_pmu_ops __initdata = {
>>          .hw_event_available = amd_hw_event_available,
>> -       .pmc_is_enabled = amd_pmc_is_enabled,
>>          .pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
>>          .rdpmc_ecx_to_pmc = amd_rdpmc_ecx_to_pmc,
>>          .msr_idx_to_pmc = amd_msr_idx_to_pmc,
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index 612c89ef5398..12eb2edfe9bc 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -68,18 +68,6 @@ static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
>>          }
>>   }
>>
>> -static void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
>> -{
>> -       int bit;
>> -       struct kvm_pmc *pmc;
>> -
>> -       for_each_set_bit(bit, (unsigned long *)&diff, X86_PMC_IDX_MAX) {
>> -               pmc = intel_pmc_idx_to_pmc(pmu, bit);
>> -               if (pmc)
>> -                       kvm_pmu_request_counter_reprogam(pmc);
>> -       }
>> -}
>> -
>>   static bool intel_hw_event_available(struct kvm_pmc *pmc)
>>   {
>>          struct kvm_pmu *pmu = pmc_to_pmu(pmc);
>> @@ -102,17 +90,6 @@ static bool intel_hw_event_available(struct kvm_pmc *pmc)
>>          return true;
>>   }
>>
>> -/* check if a PMC is enabled by comparing it with globl_ctrl bits. */
>> -static bool intel_pmc_is_enabled(struct kvm_pmc *pmc)
>> -{
>> -       struct kvm_pmu *pmu = pmc_to_pmu(pmc);
>> -
>> -       if (!intel_pmu_has_perf_global_ctrl(pmu))
>> -               return true;
>> -
>> -       return test_bit(pmc->idx, (unsigned long *)&pmu->global_ctrl);
>> -}
>> -
>>   static bool intel_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
>>   {
>>          struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>> @@ -347,15 +324,6 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>          case MSR_CORE_PERF_FIXED_CTR_CTRL:
>>                  msr_info->data = pmu->fixed_ctr_ctrl;
>>                  return 0;
>> -       case MSR_CORE_PERF_GLOBAL_STATUS:
>> -               msr_info->data = pmu->global_status;
>> -               return 0;
>> -       case MSR_CORE_PERF_GLOBAL_CTRL:
>> -               msr_info->data = pmu->global_ctrl;
>> -               return 0;
>> -       case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
>> -               msr_info->data = 0;
>> -               return 0;
>>          case MSR_IA32_PEBS_ENABLE:
>>                  msr_info->data = pmu->pebs_enable;
>>                  return 0;
>> @@ -404,29 +372,6 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>                          return 0;
>>                  }
>>                  break;
>> -       case MSR_CORE_PERF_GLOBAL_STATUS:
>> -               if (msr_info->host_initiated) {
>> -                       pmu->global_status = data;
>> -                       return 0;
>> -               }
>> -               break; /* RO MSR */
>> -       case MSR_CORE_PERF_GLOBAL_CTRL:
>> -               if (pmu->global_ctrl == data)
>> -                       return 0;
>> -               if (kvm_valid_perf_global_ctrl(pmu, data)) {
>> -                       diff = pmu->global_ctrl ^ data;
>> -                       pmu->global_ctrl = data;
>> -                       reprogram_counters(pmu, diff);
>> -                       return 0;
>> -               }
>> -               break;
>> -       case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
>> -               if (!(data & pmu->global_ovf_ctrl_mask)) {
>> -                       if (!msr_info->host_initiated)
>> -                               pmu->global_status &= ~data;
>> -                       return 0;
>> -               }
>> -               break;
>>          case MSR_IA32_PEBS_ENABLE:
>>                  if (pmu->pebs_enable == data)
>>                          return 0;
>> @@ -783,7 +728,7 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
>>                  pmc = intel_pmc_idx_to_pmc(pmu, bit);
>>
>>                  if (!pmc || !pmc_speculative_in_use(pmc) ||
>> -                   !intel_pmc_is_enabled(pmc) || !pmc->perf_event)
>> +                   !pmc_is_enabled(pmc) || !pmc->perf_event)
>>                          continue;
>>
>>                  hw_idx = pmc->perf_event->hw.idx;
>> @@ -795,7 +740,6 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
>>
>>   struct kvm_pmu_ops intel_pmu_ops __initdata = {
>>          .hw_event_available = intel_hw_event_available,
>> -       .pmc_is_enabled = intel_pmc_is_enabled,
>>          .pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
>>          .rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
>>          .msr_idx_to_pmc = intel_msr_idx_to_pmc,
>> --
>> 2.37.3
>>
