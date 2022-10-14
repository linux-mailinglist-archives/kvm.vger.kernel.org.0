Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2735FEB7F
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 11:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiJNJ0Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 05:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiJNJ0M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 05:26:12 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B60152C7D;
        Fri, 14 Oct 2022 02:26:09 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id r18so3803996pgr.12;
        Fri, 14 Oct 2022 02:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S1qvkdkHjEbNas9/ZZPIOjRrBJgMEZ8YW9tqgYLo2/A=;
        b=HEPsv2LdvlKEFiy9GlLbJMP21D7B6Ag32ye/blp0kGggQyWUgEXd9TSHw5c66+ECAe
         PiMKhToYIihgmbrCycA89SBQOSlHLOb9ep13DNQUjtyeALesqYNnThLAcaxiayeSmrky
         rzfj/g2wU1qj406xK5QAzgJxG7IizSbXL5WghXxSqKKQiFlZbV0hHjqueyeelYCzcQle
         WJdRetmMGC/u+spZpzPooV2bk/E2kXkAdf7/bgaPzdC2DnzE23iCtbowjrMlWLfmTHK2
         n3CAzBrd8FA0aKKoD1ntjsYtaTouzAWJTYtMG9mXxOtqVlfsdegdX4CZtdikHvIyx1c1
         jR5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S1qvkdkHjEbNas9/ZZPIOjRrBJgMEZ8YW9tqgYLo2/A=;
        b=LaVVRUWfzgbSaKCLgCz/nlF/ibox0l/PJeXOSO9LpGZF/XJ/uOBsqKVnslt5+7Mnrj
         Euy8lpCnwZHMhJ/H6rKcT/xc+GzepV2PZLkULVHcK9t5CPHVALa7GbH8TM4fbWaTcWa+
         6r8V+4M41WenSdTG9fXgKUE0pF0uKPIxxu+n+tAt2xBgXsaYVWnfKMwKzsfVULRRcon7
         l47RXL85yjwmV6dt/6FiSj7MbqTMtdUc1kwQeVF1M2QBc+t4HVdwOnLW9gwlJABvZGf/
         lz32SB7Dk2i99mtwjWxNJ0dLELPlgi5JB6uBMrhH0HmiT5DyHDBq23dzfLlhI40evc3a
         Hz5g==
X-Gm-Message-State: ACrzQf2ojFOWp7MjmyI0MBbmvOZYAaHMuhB6Hz/nbOb09fn0GTOvHfIx
        KBp0WL7Xdnudxp8nplYePm8=
X-Google-Smtp-Source: AMsMyM66mJhmEpsxy1o+YNlVL4Zy8EkA0z7zmNNBni/AoqbNzJGYPkx2pap4zHI4407nu2rTu530kw==
X-Received: by 2002:aa7:8504:0:b0:563:1ae2:6dc0 with SMTP id v4-20020aa78504000000b005631ae26dc0mr4153396pfn.48.1665739568532;
        Fri, 14 Oct 2022 02:26:08 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id s3-20020aa78bc3000000b0056323de479bsm1215487pfd.120.2022.10.14.02.26.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Oct 2022 02:26:07 -0700 (PDT)
Message-ID: <7e3be98e-d0c0-634b-fbb3-0096976a89bf@gmail.com>
Date:   Fri, 14 Oct 2022 17:25:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Subject: Re: [PATCH v5 5/8] KVM: x86: Track supported PERF_CAPABILITIES in
 kvm_caps
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20221006000314.73240-1-seanjc@google.com>
 <20221006000314.73240-6-seanjc@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20221006000314.73240-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/10/2022 8:03 am, Sean Christopherson wrote:
> Track KVM's supported PERF_CAPABILITIES in kvm_caps instead of computing
> the supported capabilities on the fly every time.  Using kvm_caps will
> also allow for future cleanups as the kvm_caps values can be used
> directly in common x86 code.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

A similar change was made to one of my git branches. Please move forward.

Acked-by: Like Xu <likexu@tencent.com>

> ---
>   arch/x86/kvm/svm/svm.c          |  2 ++
>   arch/x86/kvm/vmx/capabilities.h | 25 ------------------------
>   arch/x86/kvm/vmx/pmu_intel.c    |  2 +-
>   arch/x86/kvm/vmx/vmx.c          | 34 +++++++++++++++++++++++++++++----
>   arch/x86/kvm/x86.h              |  1 +
>   5 files changed, 34 insertions(+), 30 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 58f0077d9357..6b680b249975 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2715,6 +2715,7 @@ static int svm_get_msr_feature(struct kvm_msr_entry *msr)
>   			msr->data |= MSR_F10H_DECFG_LFENCE_SERIALIZE;
>   		break;
>   	case MSR_IA32_PERF_CAPABILITIES:
> +		msr->data = kvm_caps.supported_perf_cap;
>   		return 0;
>   	default:
>   		return KVM_MSR_RET_INVALID;
> @@ -4898,6 +4899,7 @@ static __init void svm_set_cpu_caps(void)
>   {
>   	kvm_set_cpu_caps();
>   
> +	kvm_caps.supported_perf_cap = 0;
>   	kvm_caps.supported_xss = 0;
>   
>   	/* CPUID 0x80000001 and 0x8000000A (SVM features) */
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index 479124e49bbd..cd2ac9536c99 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -395,31 +395,6 @@ static inline bool vmx_pebs_supported(void)
>   	return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_ept;
>   }
>   
> -static inline u64 vmx_get_perf_capabilities(void)
> -{
> -	u64 perf_cap = PMU_CAP_FW_WRITES;
> -	struct x86_pmu_lbr lbr;
> -	u64 host_perf_cap = 0;
> -
> -	if (!enable_pmu)
> -		return 0;
> -
> -	if (boot_cpu_has(X86_FEATURE_PDCM))
> -		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
> -
> -	x86_perf_get_lbr(&lbr);
> -	if (lbr.nr)
> -		perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
> -
> -	if (vmx_pebs_supported()) {
> -		perf_cap |= host_perf_cap & PERF_CAP_PEBS_MASK;
> -		if ((perf_cap & PERF_CAP_PEBS_FORMAT) < 4)
> -			perf_cap &= ~PERF_CAP_PEBS_BASELINE;
> -	}
> -
> -	return perf_cap;
> -}
> -
>   static inline bool cpu_has_notify_vmexit(void)
>   {
>   	return vmcs_config.cpu_based_2nd_exec_ctrl &
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 25b70a85bef5..24f4c22691f8 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -631,7 +631,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
>   		pmu->fixed_counters[i].current_config = 0;
>   	}
>   
> -	vcpu->arch.perf_capabilities = vmx_get_perf_capabilities();
> +	vcpu->arch.perf_capabilities = kvm_caps.supported_perf_cap;
>   	lbr_desc->records.nr = 0;
>   	lbr_desc->event = NULL;
>   	lbr_desc->msr_passthrough = false;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e70ac91cd2fb..850ff6e683d1 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1850,7 +1850,7 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
>   			return 1;
>   		return vmx_get_vmx_msr(&vmcs_config.nested, msr->index, &msr->data);
>   	case MSR_IA32_PERF_CAPABILITIES:
> -		msr->data = vmx_get_perf_capabilities();
> +		msr->data = kvm_caps.supported_perf_cap;
>   		return 0;
>   	default:
>   		return KVM_MSR_RET_INVALID;
> @@ -2029,7 +2029,7 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
>   	    (host_initiated || guest_cpuid_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT)))
>   		debugctl |= DEBUGCTLMSR_BUS_LOCK_DETECT;
>   
> -	if ((vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT) &&
> +	if ((kvm_caps.supported_perf_cap & PMU_CAP_LBR_FMT) &&
>   	    (host_initiated || intel_pmu_lbr_is_enabled(vcpu)))
>   		debugctl |= DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI;
>   
> @@ -2342,14 +2342,14 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   			return 1;
>   		if (data & PMU_CAP_LBR_FMT) {
>   			if ((data & PMU_CAP_LBR_FMT) !=
> -			    (vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT))
> +			    (kvm_caps.supported_perf_cap & PMU_CAP_LBR_FMT))
>   				return 1;
>   			if (!cpuid_model_is_consistent(vcpu))
>   				return 1;
>   		}
>   		if (data & PERF_CAP_PEBS_FORMAT) {
>   			if ((data & PERF_CAP_PEBS_MASK) !=
> -			    (vmx_get_perf_capabilities() & PERF_CAP_PEBS_MASK))
> +			    (kvm_caps.supported_perf_cap & PERF_CAP_PEBS_MASK))
>   				return 1;
>   			if (!guest_cpuid_has(vcpu, X86_FEATURE_DS))
>   				return 1;
> @@ -7669,6 +7669,31 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   	vmx_update_exception_bitmap(vcpu);
>   }
>   
> +static u64 vmx_get_perf_capabilities(void)
> +{
> +	u64 perf_cap = PMU_CAP_FW_WRITES;
> +	struct x86_pmu_lbr lbr;
> +	u64 host_perf_cap = 0;
> +
> +	if (!enable_pmu)
> +		return 0;
> +
> +	if (boot_cpu_has(X86_FEATURE_PDCM))
> +		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
> +
> +	x86_perf_get_lbr(&lbr);
> +	if (lbr.nr)
> +		perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
> +
> +	if (vmx_pebs_supported()) {
> +		perf_cap |= host_perf_cap & PERF_CAP_PEBS_MASK;
> +		if ((perf_cap & PERF_CAP_PEBS_FORMAT) < 4)
> +			perf_cap &= ~PERF_CAP_PEBS_BASELINE;
> +	}
> +
> +	return perf_cap;
> +}
> +
>   static __init void vmx_set_cpu_caps(void)
>   {
>   	kvm_set_cpu_caps();
> @@ -7691,6 +7716,7 @@ static __init void vmx_set_cpu_caps(void)
>   
>   	if (!enable_pmu)
>   		kvm_cpu_cap_clear(X86_FEATURE_PDCM);
> +	kvm_caps.supported_perf_cap = vmx_get_perf_capabilities();
>   
>   	if (!enable_sgx) {
>   		kvm_cpu_cap_clear(X86_FEATURE_SGX);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 829d3134c1eb..9de72586f406 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -27,6 +27,7 @@ struct kvm_caps {
>   	u64 supported_mce_cap;
>   	u64 supported_xcr0;
>   	u64 supported_xss;
> +	u64 supported_perf_cap;
>   };
>   
>   void kvm_spurious_fault(void);
