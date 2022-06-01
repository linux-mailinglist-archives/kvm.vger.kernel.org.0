Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E22C539B64
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 04:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346330AbiFACqd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 22:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236514AbiFACqY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 22:46:24 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345A65AA55;
        Tue, 31 May 2022 19:46:23 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id 187so667526pfu.9;
        Tue, 31 May 2022 19:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=04dC20NnK01mBVvwIG46FgYf/L1ar7DW5hi7hZSimsw=;
        b=O742tovRUrLcBitwk2HOb6gTi3EjyUwVAh04Jm8tzfDCoB0iblsUZyLBRJmOGAoBN8
         mF8m9ApCljK11nOaRQglpusFSM3QoyNGul9QfaJnWrAgMZkYbohDhoW0Jl9aWhjxKhiX
         VrSZ6rbZJMpbgM2QTns1B7JefhDysbWJ5t28jjsHCtqTRU81F8Dawzmdsxsi8V5hCLF8
         nCMonC2Z7cTGODo0aX8ueJY4XyMOl0/8XI1pO8+N2ot3MQRlqJSF1iALAQ74Y1nxeeni
         qg4gLOaIIILG5RUN2UL3k1SJJx16VjDdubuteHMXYafGzL6rviwL89BdStODds5wjRaA
         w6Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=04dC20NnK01mBVvwIG46FgYf/L1ar7DW5hi7hZSimsw=;
        b=MgT06HlW4x2JvcBugn0L1kaXw9KywKdDLjHw29NqRRY3e8pf4Qu9brIV/N8TKdbNZI
         J62krJEE/Ax0qdx/URKDCjC2qpxeVjLylEC1uAcw3qiYJJlQADmGZZ6YE1Eer4tGJJn3
         sToKzgt1bdmOZZ9GHcKZ372O/MOj7Xweb8Jv0R9U2pfdi4Td+NeQPRZ48pAsGyIxPLeQ
         DfVoDxJ6lJk2POmTd0vBKohxueCqJgTY+oea7F6Z0s7rjckwK+rZV7Cpg/J65JYOQNEw
         1jFRu98BKv3x5TKSubsyWhiMaAMumGPCxBp4+jcY4XsqnSGz1GpLXf09bqOY+n5tYM7F
         OVzg==
X-Gm-Message-State: AOAM5337ajNXGoyEkWTIF1Av0g9kbjPxDXHzWOLCR5MK18N82/RESeHk
        4mT0uM0yLOjaWCF8jlfDeU0hQiErYld93Q==
X-Google-Smtp-Source: ABdhPJzwyzIzPD35TMdiIX/4bEsAcEVTvnpTq1aybfQdCTgfmvev/beOAv8Ujz4t13U3ZNuGtf72ZA==
X-Received: by 2002:a05:6a00:14d4:b0:518:b918:fae4 with SMTP id w20-20020a056a0014d400b00518b918fae4mr41880834pfu.55.1654051582684;
        Tue, 31 May 2022 19:46:22 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.20])
        by smtp.gmail.com with ESMTPSA id x13-20020a17090a294d00b001e0cc5b13c6sm2693884pjf.26.2022.05.31.19.46.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 19:46:22 -0700 (PDT)
Message-ID: <ce2b4fed-3d9e-a179-a907-5b8e09511b7d@gmail.com>
Date:   Wed, 1 Jun 2022 10:46:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH 1/2] KVM: vmx, pmu: accept 0 for absent MSRs when
 host-initiated
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220531175450.295552-1-pbonzini@redhat.com>
 <20220531175450.295552-2-pbonzini@redhat.com> <YpZgU+vfjkRuHZZR@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <YpZgU+vfjkRuHZZR@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/6/2022 2:37 am, Sean Christopherson wrote:
> On Tue, May 31, 2022, Paolo Bonzini wrote:
>> Whenever an MSR is part of KVM_GET_MSR_INDEX_LIST, as is the case for
>> MSR_IA32_DS_AREA, MSR_ARCH_LBR_DEPTH or MSR_ARCH_LBR_CTL, it has to be
>> always settable with KVM_SET_MSR.  Accept a zero value for these MSRs
>> to obey the contract.

Do we have a rule to decide whether to put MSRs into KVM_GET_MSR_INDEX_LIST,
for example a large number of LBR MSRs do not appear in it ?

I assume that this rule also applies in the case of !enable_pmu:

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 7a74691de223..3575a3746bf9 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -439,11 +439,19 @@ static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, 
u32 msr)

  int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
  {
+	if (msr_info->host_initiated && !vcpu->kvm->arch.enable_pmu) {
+		msr_info->data = 0;
+		return 0;
+	}
+
  	return static_call(kvm_x86_pmu_get_msr)(vcpu, msr_info);
  }

  int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
  {
+	if (msr_info->host_initiated && !vcpu->kvm->arch.enable_pmu)
+		return !!msr_info->data;
+
  	kvm_pmu_mark_pmc_in_use(vcpu, msr_info->index);
  	return static_call(kvm_x86_pmu_set_msr)(vcpu, msr_info);
  }
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 256244b8f89c..fe520b2649b5 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -182,7 +182,16 @@ static struct kvm_pmc *amd_rdpmc_ecx_to_pmc(struct kvm_vcpu 
*vcpu,
  static bool amd_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr, bool host_initiated)
  {
  	/* All MSRs refer to exactly one PMC, so msr_idx_to_pmc is enough.  */
-	return false;
+	if (!host_initiated)
+		return false;
+
+	switch (msr) {
+	case MSR_K7_EVNTSEL0 ... MSR_K7_PERFCTR3:
+	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
+		return true;
+	default:
+		return false;
+	}
  }

  static struct kvm_pmc *amd_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)

>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>   arch/x86/kvm/vmx/pmu_intel.c | 15 ++++++++++++---
>>   1 file changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index 3e04d0407605..66496cb41494 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -367,8 +367,9 @@ static bool arch_lbr_depth_is_valid(struct kvm_vcpu *vcpu, u64 depth)
>>   {
>>   	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>>   
>> -	if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
>> -		return false;
>> +	if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) ||
>> +	    !guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
>> +		return depth == 0;
>>   
>>   	return (depth == pmu->kvm_arch_lbr_depth);
>>   }
>> @@ -378,7 +379,7 @@ static bool arch_lbr_ctl_is_valid(struct kvm_vcpu *vcpu, u64 ctl)
>>   	struct kvm_cpuid_entry2 *entry;
>>   
>>   	if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
>> -		return false;
>> +		return ctl == 0;
>>   
>>   	if (ctl & ~KVM_ARCH_LBR_CTL_MASK)
>>   		goto warn;
>> @@ -510,6 +511,8 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   		}
>>   		break;
>>   	case MSR_IA32_DS_AREA:
>> +		if (msr_info->host_initiated && data && !guest_cpuid_has(vcpu, X86_FEATURE_DS))
>> +			return 1;
>>   		if (is_noncanonical_address(data, vcpu))
>>   			return 1;
>>   		pmu->ds_area = data;
>> @@ -525,7 +528,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   	case MSR_ARCH_LBR_DEPTH:
>>   		if (!arch_lbr_depth_is_valid(vcpu, data))
>>   			return 1;
>> +
>>   		lbr_desc->records.nr = data;
>> +		if (!guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
>> +			return 0;
> 
> This is wrong, it will allow an unchecked wrmsrl() to MSR_ARCH_LBR_DEPTH if
> X86_FEATURE_ARCH_LBR is not supported by hardware but userspace forces it in
> guest CPUID.

What should we expect if the userspace forces guest to use features not 
supported by KVM,
especially the emulation of this feature depends on the functionality of host 
and guest vcpu model ?

> 
> This the only user of arch_lbr_depth_is_valid(), just open code the logic.
> 
>> +
>>   		/*
>>   		 * Writing depth MSR from guest could either setting the
>>   		 * MSR or resetting the LBR records with the side-effect.
>> @@ -535,6 +542,8 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   	case MSR_ARCH_LBR_CTL:
>>   		if (!arch_lbr_ctl_is_valid(vcpu, data))
>>   			break;
>> +		if (!guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
>> +			return 0;
> 
> Similar bug here.
> 
> Can we just punt this out of kvm/queue until its been properly reviewed?  At the
> barest of glances, there are multiple flaws that should block this from being

TBH, our reviewers' attention could not be focused on these patches until the
day it was ready to be ravaged. "Try to accept" is a good thing, and things need
to move forward, not simply be abandoned to the side.

Although later versions of ARCH_LBR is not on my review list, any developer would
sincerely appreciate finding more flaws through the queue tree, please take a 
look at PEBS.

> merged.  Based on the number of checks against X86_FEATURE_ARCH_LBR in KVM, and
> my vague recollection of the passthrough behavior, this is a _massive_ feature.
> 
> The pr_warn_ratelimited() shouldn't exist; it's better than a non-ratelimited warn,
> but it's ultimately useless.

We have two pr_warn_ratelimited(). The one in arch_lbr_ctl_is_valid() should be 
dropped.

> 
> This should check kvm_cpu_has() to ensure the field exists, e.g. if the feature
> is supported in hardware but cpu_has_vmx_arch_lbr() returns false for whatever
> reason.
> 
> 	if (!init_event) {
> 		if (static_cpu_has(X86_FEATURE_ARCH_LBR))
> 			vmcs_write64(GUEST_IA32_LBR_CTL, 0);

If we tweak vmcs_config.vm*_ctrl via adjust_vmx_controls(), VMCS fields
(if any, like this one on a capable platform) are still accessible on the KVM 
side, aren't they?

- VM_ENTRY_LOAD_IA32_LBR_CTL
- VM_EXIT_CLEAR_IA32_LBR_CTL

> 
> intel_pmu_lbr_is_enabled() is going to be a performance problem, e.g. _should_ be
> gated by static_cpu_has() to avoid overhead on CPUs without arch LBRs, and is
> going to incur a _guest_ CPUID lookup on X86_FEATURE_PDCM for every VM-Entry if
> arch LBRs are exposed to the guest (at least, I think that's what it does).

Indeed, this also applies to the legacy LBR, and we can certainly improve it.

> 
>>   
>>   		vmcs_write64(GUEST_IA32_LBR_CTL, data);
>>   
>> -- 
>> 2.31.1
>>
>>
> 
