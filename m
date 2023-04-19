Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 927D86E74E6
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 10:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbjDSIVf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 04:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232385AbjDSIVe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 04:21:34 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7E9B472;
        Wed, 19 Apr 2023 01:21:32 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-63b7588005fso2324282b3a.0;
        Wed, 19 Apr 2023 01:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681892492; x=1684484492;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xj0CU7p1W+dCxHqd7qwerjxTqPilnCLLBMGuZMUC06Q=;
        b=j5Gu3XgJYeVdaIZ6qMWbsi/SCCTXKJ3m36sul8TYmTSAEaOy1zORd9Gk0YfUMMWvmZ
         1AAVq49GD/pu6pqXrm3rqXHEGOkjwsQhON0gQkoZu4JlX2Nah+T7P+Q/9wHXsNwECzwO
         JQMYR5Ywjy2MGQOG84odabyL/Kfki/0bqhOSNQFperDXkenLEq0HldRGWsmi0KbEf3wa
         3G/eIOXg+NOzuFowh0jS7XZ/T3BGuu0vcPECoff2xgWOUcyVJHvNg3uSdRtTRMiclx/z
         kl+roAsOEY9dhvlMcxAdkSetJEd0LcApap4geILOZBvYLM8aA+2CwzFa21UD5htdBlex
         QVoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681892492; x=1684484492;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xj0CU7p1W+dCxHqd7qwerjxTqPilnCLLBMGuZMUC06Q=;
        b=M3tIlQj0l040v+t/3owwpQ+UoFVekuQOe81ZrdFZ5rwmjcu6Dn39iSfZS+qUOF6GFZ
         ebbXX7h+6f6Uzb2rWJM1wgn1qhbRlaCVGUt0hDDtZXP9KsSkvpA2za62D/EqfTV6PWgt
         /3eGFU/9Zm2oqplKmtMlRHhMnxll3CIQ/L4048NLqAIFmkQ8sR6A451Km+0+PCfkApju
         BDeTEIeCWhH525+tI7+ddqF1CRBYf66a6mfLo0fNGvTl+5WSwsYOTM5D7kJWvVqLGh9Q
         JTiQ9Zm/EptpZScNAxwHHsh0oil9xciWTLleOKXew22ptBXjAfePrEWpixjkmPpzK5qV
         fOLA==
X-Gm-Message-State: AAQBX9fR3iWGhcin9GgblkZWppXXVMslpaMcnyW8bki0Arq2rfkxN8hh
        XHzxDfwc4ML8fwZuBsCNtW0=
X-Google-Smtp-Source: AKy350YL/kUFUfM07Me+wCmJGs1fo4I5TW3i/TLJBepX0TYQUTVw6TqF7jpJfrHo6opFJf1nnGB1LQ==
X-Received: by 2002:a05:6a00:2d1c:b0:63d:4407:b6c with SMTP id fa28-20020a056a002d1c00b0063d44070b6cmr3240298pfb.7.1681892491562;
        Wed, 19 Apr 2023 01:21:31 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j22-20020aa79296000000b0062a7462d398sm10867911pfa.170.2023.04.19.01.21.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 01:21:31 -0700 (PDT)
Message-ID: <36fb638a-c9ff-0139-3e8e-7e8ff0bbff1f@gmail.com>
Date:   Wed, 19 Apr 2023 16:21:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH v13 021/113] KVM: TDX: Make pmu_intel.c ignore guest TD
 case
Content-Language: en-US
To:     Zhi Wang <zhi.wang.linux@gmail.com>, isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <017a06174fa054ae264a2caba6f7f55e00f258e8.1678643052.git.isaku.yamahata@intel.com>
 <20230402115019.000046fd@gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230402115019.000046fd@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/4/2023 4:50 pm, Zhi Wang wrote:
> Hi Like:
> 
> Would you mind to take a look on this patch? It would be nice to have
> a r-b also from you. :)
> 
> On Sun, 12 Mar 2023 10:55:45 -0700
> isaku.yamahata@intel.com wrote:
> 
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> Because TDX KVM doesn't support PMU yet (it's future work of TDX KVM
>> support as another patch series) and pmu_intel.c touches vmx specific

It would be nice to have pmu support for tdx-guest from the very beginning.
If you guys are more open on the tdx development model, I'd like to help on 
those features.

>> structure in vcpu initialization, as workaround add dummy structure to
>> struct vcpu_tdx and pmu_intel.c can ignore TDX case.

If the target is not to provide a workaround, how about other variants:
	- struct lbr_desc lbr_desc;
	- pebs ds_buffer;
?

We also need tdx selftest to verify the unavailability of these features.
Also, it would be great to have TDX's "System Profiling Mode" featue back in the 
specification.

>>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> ---
>>   arch/x86/kvm/vmx/pmu_intel.c | 46 +++++++++++++++++++++++++++++++++++-
>>   arch/x86/kvm/vmx/pmu_intel.h | 28 ++++++++++++++++++++++
>>   arch/x86/kvm/vmx/tdx.h       |  8 ++++++-
>>   arch/x86/kvm/vmx/vmx.c       |  2 +-
>>   arch/x86/kvm/vmx/vmx.h       | 32 +------------------------
>>   5 files changed, 82 insertions(+), 34 deletions(-)
>>   create mode 100644 arch/x86/kvm/vmx/pmu_intel.h
>>
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index e8a3be0b9df9..df1f4ddfa72d 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -19,6 +19,7 @@
>>   #include "lapic.h"
>>   #include "nested.h"
>>   #include "pmu.h"
>> +#include "tdx.h"
>>   
>>   #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
>>   
>> @@ -40,6 +41,26 @@ static struct {
>>   /* mapping between fixed pmc index and intel_arch_events array */
>>   static int fixed_pmc_events[] = {1, 0, 7};
>>   
>> +struct lbr_desc *vcpu_to_lbr_desc(struct kvm_vcpu *vcpu)
>> +{
>> +#ifdef CONFIG_INTEL_TDX_HOST
>> +	if (is_td_vcpu(vcpu))
>> +		return &to_tdx(vcpu)->lbr_desc;
>> +#endif
>> +
>> +	return &to_vmx(vcpu)->lbr_desc;
>> +}
>> +
>> +struct x86_pmu_lbr *vcpu_to_lbr_records(struct kvm_vcpu *vcpu)
>> +{
>> +#ifdef CONFIG_INTEL_TDX_HOST
>> +	if (is_td_vcpu(vcpu))
>> +		return &to_tdx(vcpu)->lbr_desc.records;
>> +#endif
>> +
>> +	return &to_vmx(vcpu)->lbr_desc.records;
>> +}
>> +
>>   static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
>>   {
>>   	struct kvm_pmc *pmc;
>> @@ -172,6 +193,23 @@ static inline struct kvm_pmc *get_fw_gp_pmc(struct kvm_pmu *pmu, u32 msr)
>>   	return get_gp_pmc(pmu, msr, MSR_IA32_PMC0);
>>   }
>>   
>> +bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu)
>> +{
>> +	if (is_td_vcpu(vcpu))
>> +		return false;
>> +	return cpuid_model_is_consistent(vcpu);
>> +}
>> +
>> +bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
>> +{
>> +	struct x86_pmu_lbr *lbr = vcpu_to_lbr_records(vcpu);
>> +
>> +	if (is_td_vcpu(vcpu))
>> +		return false;
>> +
>> +	return lbr->nr && (vcpu_get_perf_capabilities(vcpu) & PMU_CAP_LBR_FMT);
>> +}
>> +
>>   static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
>>   {
>>   	struct x86_pmu_lbr *records = vcpu_to_lbr_records(vcpu);
>> @@ -282,6 +320,9 @@ int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu)
>>   					PERF_SAMPLE_BRANCH_USER,
>>   	};
>>   
>> +	if (WARN_ON_ONCE(is_td_vcpu(vcpu)))
>> +		return 0;
>> +
>>   	if (unlikely(lbr_desc->event)) {
>>   		__set_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use);
>>   		return 0;
>> @@ -591,7 +632,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>>   		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
>>   
>>   	perf_capabilities = vcpu_get_perf_capabilities(vcpu);
>> -	if (cpuid_model_is_consistent(vcpu) &&
>> +	if (intel_pmu_lbr_is_compatible(vcpu) &&
>>   	    (perf_capabilities & PMU_CAP_LBR_FMT))
>>   		x86_perf_get_lbr(&lbr_desc->records);
>>   	else
>> @@ -647,6 +688,9 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
>>   	struct kvm_pmc *pmc = NULL;
>>   	int i;
>>   
>> +	if (is_td_vcpu(vcpu))
>> +		return;
>> +
>>   	for (i = 0; i < KVM_INTEL_PMC_MAX_GENERIC; i++) {
>>   		pmc = &pmu->gp_counters[i];
>>   
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.h b/arch/x86/kvm/vmx/pmu_intel.h
>> new file mode 100644
>> index 000000000000..66bba47c1269
>> --- /dev/null
>> +++ b/arch/x86/kvm/vmx/pmu_intel.h
>> @@ -0,0 +1,28 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef __KVM_X86_VMX_PMU_INTEL_H
>> +#define  __KVM_X86_VMX_PMU_INTEL_H
>> +
>> +struct lbr_desc *vcpu_to_lbr_desc(struct kvm_vcpu *vcpu);
>> +struct x86_pmu_lbr *vcpu_to_lbr_records(struct kvm_vcpu *vcpu);
>> +
>> +bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu);
>> +bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu);
>> +int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
>> +
>> +struct lbr_desc {
>> +	/* Basic info about guest LBR records. */
>> +	struct x86_pmu_lbr records;
>> +
>> +	/*
>> +	 * Emulate LBR feature via passthrough LBR registers when the
>> +	 * per-vcpu guest LBR event is scheduled on the current pcpu.
>> +	 *
>> +	 * The records may be inaccurate if the host reclaims the LBR.
>> +	 */
>> +	struct perf_event *event;
>> +
>> +	/* True if LBRs are marked as not intercepted in the MSR bitmap */
>> +	bool msr_passthrough;
>> +};
>> +
>> +#endif /* __KVM_X86_VMX_PMU_INTEL_H */
>> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
>> index 1e00e75b1c5e..5728820fed5e 100644
>> --- a/arch/x86/kvm/vmx/tdx.h
>> +++ b/arch/x86/kvm/vmx/tdx.h
>> @@ -4,6 +4,7 @@
>>   
>>   #ifdef CONFIG_INTEL_TDX_HOST
>>   
>> +#include "pmu_intel.h"
>>   #include "tdx_ops.h"
>>   
>>   struct kvm_tdx {
>> @@ -21,7 +22,12 @@ struct kvm_tdx {
>>   
>>   struct vcpu_tdx {
>>   	struct kvm_vcpu	vcpu;
>> -	/* TDX specific members follow. */
>> +
>> +	/*
>> +	 * Dummy to make pmu_intel not corrupt memory.
>> +	 * TODO: Support PMU for TDX.  Future work.
>> +	 */
>> +	struct lbr_desc lbr_desc;
>>   };
>>   
>>   static inline bool is_td(struct kvm *kvm)
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index d23830d92f61..f9e9fd7fde2c 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -2432,7 +2432,7 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   			if ((data & PMU_CAP_LBR_FMT) !=
>>   			    (kvm_caps.supported_perf_cap & PMU_CAP_LBR_FMT))
>>   				return 1;
>> -			if (!cpuid_model_is_consistent(vcpu))
>> +			if (!intel_pmu_lbr_is_compatible(vcpu))
>>   				return 1;
>>   		}
>>   		if (data & PERF_CAP_PEBS_FORMAT) {
>> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>> index 2acdc54bc34b..1d15c3c2751b 100644
>> --- a/arch/x86/kvm/vmx/vmx.h
>> +++ b/arch/x86/kvm/vmx/vmx.h
>> @@ -11,6 +11,7 @@
>>   #include "capabilities.h"
>>   #include "../kvm_cache_regs.h"
>>   #include "posted_intr.h"
>> +#include "pmu_intel.h"
>>   #include "vmcs.h"
>>   #include "vmx_ops.h"
>>   #include "../cpuid.h"
>> @@ -105,22 +106,6 @@ static inline bool intel_pmu_has_perf_global_ctrl(struct kvm_pmu *pmu)
>>   	return pmu->version > 1;
>>   }
>>   
>> -struct lbr_desc {
>> -	/* Basic info about guest LBR records. */
>> -	struct x86_pmu_lbr records;
>> -
>> -	/*
>> -	 * Emulate LBR feature via passthrough LBR registers when the
>> -	 * per-vcpu guest LBR event is scheduled on the current pcpu.
>> -	 *
>> -	 * The records may be inaccurate if the host reclaims the LBR.
>> -	 */
>> -	struct perf_event *event;
>> -
>> -	/* True if LBRs are marked as not intercepted in the MSR bitmap */
>> -	bool msr_passthrough;
>> -};
>> -
>>   /*
>>    * The nested_vmx structure is part of vcpu_vmx, and holds information we need
>>    * for correct emulation of VMX (i.e., nested VMX) on this vcpu.
>> @@ -650,21 +635,6 @@ static __always_inline struct vcpu_vmx *to_vmx(struct kvm_vcpu *vcpu)
>>   	return container_of(vcpu, struct vcpu_vmx, vcpu);
>>   }
>>   
>> -static inline struct lbr_desc *vcpu_to_lbr_desc(struct kvm_vcpu *vcpu)
>> -{
>> -	return &to_vmx(vcpu)->lbr_desc;
>> -}
>> -
>> -static inline struct x86_pmu_lbr *vcpu_to_lbr_records(struct kvm_vcpu *vcpu)
>> -{
>> -	return &vcpu_to_lbr_desc(vcpu)->records;
>> -}
>> -
>> -static inline bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
>> -{
>> -	return !!vcpu_to_lbr_records(vcpu)->nr;
>> -}
>> -
>>   void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu);
>>   int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
>>   void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu);
> 
> 
