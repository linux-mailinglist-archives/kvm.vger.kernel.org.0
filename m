Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 773A1444FFB
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 09:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbhKDIRD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 04:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbhKDIRC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 04:17:02 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47441C061714;
        Thu,  4 Nov 2021 01:14:25 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id o14so5972544plg.5;
        Thu, 04 Nov 2021 01:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=SAq8tD4DBoE3zQ0QNHeM3XJV9O+xxvOJcQbpkBGQ/QI=;
        b=ogBPcafYnohY+X0IkauFiFrd62W+8zx2i9/Bgsszkgnj59qqRBG1k8E46LN1p0hDL7
         wp6BHMQubFVSbMv0RY9UurAR/fNcmRfzt5cFBoEl7AfTk1RBEr5hrSxyxVXsEnY9bJV6
         zMHDIyNUrHF292nrHTaukcrQh2rvAdueabi8+KXdArN6KRHd/cqMom/DSM9BK5QzRHRx
         2ak2obT2xZQ4NEXrKOhhjmMtbjDsGuz6knPy1UTO2svTPuSmZq9mrUqEbym6GFMfcBcN
         tZuJndwd8N8k12obUgBSptqplE0rx1DPnF6dAUpSIGm+dcAGokc7tcIuP43borlfEYqW
         0sgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=SAq8tD4DBoE3zQ0QNHeM3XJV9O+xxvOJcQbpkBGQ/QI=;
        b=GWNVp7mozWhUv7uGF7myXhXAqdurawyvMGwn8GG95PVKsPsyE0y4fHUWw8MkemfOEX
         fBhv/WRoQ2rOtfpXmF1stuXotjcToRXFnUi45st++OknvwQ8vYLMplzO/6rK6A8UwyE6
         ymQRvicyEIpZuGWmq0JpIrEyJeKhiiaC0nwVT/4nYsB3FWeDxA6cn7MZ9sm39UnUrMkl
         t6eQlN4wn3+0LxGdAEEJ1GELwvoNsAXXXGde0s6VvzgzEqE0k4Ei2HHiJCeOx6DZNdKb
         ZZYw5kc3sr7KdZ8IaUhn9n2g1u0+g6nrR1L1PvczRRap5OkrInBhwVCpLQcMfe9l/WwH
         YPcA==
X-Gm-Message-State: AOAM533HREzFCK8AiY2Wq9wKlxnM8Kp4SsjUJfCt7wfNb+h7VwmjkBt9
        ZS/yBUs7H2ZyqQZ4MtJfdKw=
X-Google-Smtp-Source: ABdhPJxGJVzcX+tivat/qlF387+EdHwzTiMdSlJB2v3eJcn2hMJkloGdcMabPjxhkgdAEvP6dxhMvw==
X-Received: by 2002:a17:90b:4f4c:: with SMTP id pj12mr20603923pjb.217.1636013664764;
        Thu, 04 Nov 2021 01:14:24 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b7sm4568651pfm.28.2021.11.04.01.14.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 01:14:23 -0700 (PDT)
Message-ID: <d70ed6da-443e-f279-326e-9c3963f341b5@gmail.com>
Date:   Thu, 4 Nov 2021 16:14:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Content-Language: en-US
To:     Yao Yuan <yaoyuan0329os@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211103070310.43380-1-likexu@tencent.com>
 <20211103070310.43380-4-likexu@tencent.com>
 <20211103120854.w73q476jk7rvopkt@sapienza>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH 3/3] KVM: x86: Use static calls to reduce kvm_pmu_ops
 overhead
In-Reply-To: <20211103120854.w73q476jk7rvopkt@sapienza>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/11/2021 8:08 pm, Yao Yuan wrote:
> On Wed, Nov 03, 2021 at 03:03:10PM +0800, Like Xu wrote:
>> Convert kvm_pmu_ops to use static calls.
>>
>> Here are the worst sched_clock() nanosecond numbers for the kvm_pmu_ops
>> functions that is most often called (up to 7 digits of calls) when running
>> a single perf test case in a guest on an ICX 2.70GHz host (mitigations=on):
>>
>>        |	legacy	|	static call
>> ------------------------------------------------------------
>> .pmc_idx_to_pmc	|	10946	|	10047 (8%)
>> .pmc_is_enabled	|	11291	|	11175 (1%)
>> .msr_idx_to_pmc	|	13526	|	12346 (8%)
>> .is_valid_msr	|	10895	|	10484 (3%)
>>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   arch/x86/kvm/pmu.c        | 36 +++++++++++++++++-------------------
>>   arch/x86/kvm/pmu.h        |  2 +-
>>   arch/x86/kvm/vmx/nested.c |  2 +-
>>   arch/x86/kvm/x86.c        |  4 +++-
>>   4 files changed, 22 insertions(+), 22 deletions(-)
>>
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>> index b6f08c719125..193f925e2064 100644
>> --- a/arch/x86/kvm/pmu.c
>> +++ b/arch/x86/kvm/pmu.c
>> @@ -224,7 +224,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
>>              ARCH_PERFMON_EVENTSEL_CMASK |
>>              HSW_IN_TX |
>>              HSW_IN_TX_CHECKPOINTED))) {
>> -		config = kvm_pmu_ops.find_arch_event(pmc_to_pmu(pmc),
>> +		config = static_call(kvm_x86_pmu_find_arch_event)(pmc_to_pmu(pmc),
> 
> Why you need change them into kvm_pmu_ops.XXX then convert
> them into static call ? Move the instance definition of
> kvm_pmu_ops from patch 1 into patch 3 and then drop patch 1,
> will this work ?

You may git squash all commits to get it *work*.

With reference to afaf0b2f9b801c6eb2278b52d49e6a7d7b659cf1[1],
doing one thing at a time will make things go smoother.

[1] 
https://lore.kernel.org/lkml/20200321202603.19355-7-sean.j.christopherson@intel.com/

> 
>>                              event_select,
>>                              unit_mask);
>>        if (config != PERF_COUNT_HW_MAX)
>> @@ -278,7 +278,7 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
>>
>>    pmc->current_config = (u64)ctrl;
>>    pmc_reprogram_counter(pmc, PERF_TYPE_HARDWARE,
>> -               kvm_pmu_ops.find_fixed_event(idx),
>> +               static_call(kvm_x86_pmu_find_fixed_event)(idx),
>>                  !(en_field & 0x2), /* exclude user */
>>                  !(en_field & 0x1), /* exclude kernel */
>>                  pmi, false, false);
>> @@ -287,7 +287,7 @@ EXPORT_SYMBOL_GPL(reprogram_fixed_counter);
>>
>>   void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx)
>>   {
>> -	struct kvm_pmc *pmc = kvm_pmu_ops.pmc_idx_to_pmc(pmu, pmc_idx);
>> +	struct kvm_pmc *pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, pmc_idx);
>>
>>    if (!pmc)
>>        return;
>> @@ -309,7 +309,7 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
>>    int bit;
>>
>>    for_each_set_bit(bit, pmu->reprogram_pmi, X86_PMC_IDX_MAX) {
>> -		struct kvm_pmc *pmc = kvm_pmu_ops.pmc_idx_to_pmc(pmu, bit);
>> +		struct kvm_pmc *pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, bit);
>>
>>        if (unlikely(!pmc || !pmc->perf_event)) {
>>            clear_bit(bit, pmu->reprogram_pmi);
>> @@ -331,7 +331,7 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
>>   /* check if idx is a valid index to access PMU */
>>   int kvm_pmu_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
>>   {
>> -	return kvm_pmu_ops.is_valid_rdpmc_ecx(vcpu, idx);
>> +	return static_call(kvm_x86_pmu_is_valid_rdpmc_ecx)(vcpu, idx);
>>   }
>>
>>   bool is_vmware_backdoor_pmc(u32 pmc_idx)
>> @@ -381,7 +381,7 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
>>    if (is_vmware_backdoor_pmc(idx))
>>        return kvm_pmu_rdpmc_vmware(vcpu, idx, data);
>>
>> -	pmc = kvm_pmu_ops.rdpmc_ecx_to_pmc(vcpu, idx, &mask);
>> +	pmc = static_call(kvm_x86_pmu_rdpmc_ecx_to_pmc)(vcpu, idx, &mask);
>>    if (!pmc)
>>        return 1;
>>
>> @@ -397,22 +397,21 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
>>   void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
>>   {
>>    if (lapic_in_kernel(vcpu)) {
>> -		if (kvm_pmu_ops.deliver_pmi)
>> -			kvm_pmu_ops.deliver_pmi(vcpu);
>> +		static_call_cond(kvm_x86_pmu_deliver_pmi)(vcpu);
>>        kvm_apic_local_deliver(vcpu->arch.apic, APIC_LVTPC);
>>    }
>>   }
>>
>>   bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
>>   {
>> -	return kvm_pmu_ops.msr_idx_to_pmc(vcpu, msr) ||
>> -		kvm_pmu_ops.is_valid_msr(vcpu, msr);
>> +	return static_call(kvm_x86_pmu_msr_idx_to_pmc)(vcpu, msr) ||
>> +		static_call(kvm_x86_pmu_is_valid_msr)(vcpu, msr);
>>   }
>>
>>   static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
>>   {
>>    struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>> -	struct kvm_pmc *pmc = kvm_pmu_ops.msr_idx_to_pmc(vcpu, msr);
>> +	struct kvm_pmc *pmc = static_call(kvm_x86_pmu_msr_idx_to_pmc)(vcpu, msr);
>>
>>    if (pmc)
>>        __set_bit(pmc->idx, pmu->pmc_in_use);
>> @@ -420,13 +419,13 @@ static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
>>
>>   int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   {
>> -	return kvm_pmu_ops.get_msr(vcpu, msr_info);
>> +	return static_call(kvm_x86_pmu_get_msr)(vcpu, msr_info);
>>   }
>>
>>   int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   {
>>    kvm_pmu_mark_pmc_in_use(vcpu, msr_info->index);
>> -	return kvm_pmu_ops.set_msr(vcpu, msr_info);
>> +	return static_call(kvm_x86_pmu_set_msr)(vcpu, msr_info);
>>   }
>>
>>   /* refresh PMU settings. This function generally is called when underlying
>> @@ -435,7 +434,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>    */
>>   void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
>>   {
>> -	kvm_pmu_ops.refresh(vcpu);
>> +	static_call(kvm_x86_pmu_refresh)(vcpu);
>>   }
>>
>>   void kvm_pmu_reset(struct kvm_vcpu *vcpu)
>> @@ -443,7 +442,7 @@ void kvm_pmu_reset(struct kvm_vcpu *vcpu)
>>    struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>>
>>    irq_work_sync(&pmu->irq_work);
>> -	kvm_pmu_ops.reset(vcpu);
>> +	static_call(kvm_x86_pmu_reset)(vcpu);
>>   }
>>
>>   void kvm_pmu_init(struct kvm_vcpu *vcpu)
>> @@ -451,7 +450,7 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
>>    struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>>
>>    memset(pmu, 0, sizeof(*pmu));
>> -	kvm_pmu_ops.init(vcpu);
>> +	static_call(kvm_x86_pmu_init)(vcpu);
>>    init_irq_work(&pmu->irq_work, kvm_pmi_trigger_fn);
>>    pmu->event_count = 0;
>>    pmu->need_cleanup = false;
>> @@ -483,14 +482,13 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
>>              pmu->pmc_in_use, X86_PMC_IDX_MAX);
>>
>>    for_each_set_bit(i, bitmask, X86_PMC_IDX_MAX) {
>> -		pmc = kvm_pmu_ops.pmc_idx_to_pmc(pmu, i);
>> +		pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, i);
>>
>>        if (pmc && pmc->perf_event && !pmc_speculative_in_use(pmc))
>>            pmc_stop_counter(pmc);
>>    }
>>
>> -	if (kvm_pmu_ops.cleanup)
>> -		kvm_pmu_ops.cleanup(vcpu);
>> +	static_call_cond(kvm_x86_pmu_cleanup)(vcpu);
>>
>>    bitmap_zero(pmu->pmc_in_use, X86_PMC_IDX_MAX);
>>   }
>> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
>> index e5550d4acf14..1818d1371ece 100644
>> --- a/arch/x86/kvm/pmu.h
>> +++ b/arch/x86/kvm/pmu.h
>> @@ -109,7 +109,7 @@ static inline bool pmc_is_fixed(struct kvm_pmc *pmc)
>>
>>   static inline bool pmc_is_enabled(struct kvm_pmc *pmc)
>>   {
>> -	return kvm_pmu_ops.pmc_is_enabled(pmc);
>> +	return static_call(kvm_x86_pmu_pmc_is_enabled)(pmc);
>>   }
>>
>>   static inline bool kvm_valid_perf_global_ctrl(struct kvm_pmu *pmu,
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 1e793e44b5ff..a61661de1f39 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -4796,7 +4796,7 @@ void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
>>        return;
>>
>>    vmx = to_vmx(vcpu);
>> -	if (kvm_pmu_ops.is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL)) {
>> +	if (static_call(kvm_x86_pmu_is_valid_msr)(vcpu, MSR_CORE_PERF_GLOBAL_CTRL)) {
>>        vmx->nested.msrs.entry_ctls_high |=
>>                VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
>>        vmx->nested.msrs.exit_ctls_high |=
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 72d286595012..88a3ef809c98 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -11317,8 +11317,10 @@ int kvm_arch_hardware_setup(void *opaque)
>>    memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
>>    kvm_ops_static_call_update();
>>
>> -	if (kvm_x86_ops.hardware_enable)
>> +	if (kvm_x86_ops.hardware_enable) {
>>        memcpy(&kvm_pmu_ops, kvm_x86_ops.pmu_ops, sizeof(kvm_pmu_ops));
>> +		kvm_pmu_ops_static_call_update();
>> +	}
>>
>>    if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
>>        supported_xss = 0;
>> --
>> 2.33.0
>>
> 
