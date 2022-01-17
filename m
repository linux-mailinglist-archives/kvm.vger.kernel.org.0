Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A208490FF9
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 18:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241982AbiAQR5T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 12:57:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:28559 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235420AbiAQR5R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 12:57:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642442237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K9kCXO7ufS1sgHwDNkwg1B3hoEyZ/1T3PNCqsxyfB6M=;
        b=DdSxClg1zHdki5CjuFC9/JdwteDOI4Ca2eUBki0hIb+pyaGyyCW6uBbmJ9IYCZhxRSHUGy
        Xf241aN1Vlwbolbz3YTGbEhCilMbp8XhdfrG+nHNUP3mfsAv6xtkpcdjJ3xoE/DCDZwbTg
        YwaY4Drupl9bWDBoKvCvxAQSYSfBcwY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-LNepjOPrPnyBU66LGQrVfA-1; Mon, 17 Jan 2022 12:57:16 -0500
X-MC-Unique: LNepjOPrPnyBU66LGQrVfA-1
Received: by mail-wm1-f72.google.com with SMTP id x10-20020a7bc20a000000b0034c3d77f277so326804wmi.3
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 09:57:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=K9kCXO7ufS1sgHwDNkwg1B3hoEyZ/1T3PNCqsxyfB6M=;
        b=UMtew47oyUYlVApiKSZ21CcKgxzTQ2aKcS7NuIp0GxPjpy++8J0h+Mq9P1meV0LyKS
         y2zNo3pK9ptHF3joyWJi9E6iCJ2Zf8+KJnnV5JT3R5a9Uxhpzjyb7klL6mz1XvcKdfer
         RTyKoQF8P8ZRl0PKgqGU+F3a+x+Hng+pVVGyBFVP544NcdqyPDJRM13cCRiAIYEdVNSy
         +439awFSegE4dTuKNw59MYCQGwPrgCFPGu5/Qae6wLQ6jlEFqCtsGguEXeJ/tcPxeq3b
         NfWZ5rZnCWH2bP0xlpG0z+0z7w1T+gfuGVSrbczcYQPu3t1v9LISvf3+w4KZzU/OR50i
         w6cw==
X-Gm-Message-State: AOAM531Z1weZwgi2Tc39MTmrNd/dypmVAUfa79+jz5TcDAgdcIYRJeyT
        AmerbPixsQYWDxbc4DpmGgHedDaMczGFqXo/rfxLhyPPdycvmuGxgcbucpufa9RsgNEKCirMUCF
        jAz1lc/Op8Qhm
X-Received: by 2002:a05:600c:154b:: with SMTP id f11mr11952591wmg.62.1642442234965;
        Mon, 17 Jan 2022 09:57:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy9poqi18K22C4DLmX3arn0dWMU5OIx+f4+yE7QU/e7Wxcc8+4kRtHO8FGVVmVxA4ig9BVqyQ==
X-Received: by 2002:a05:600c:154b:: with SMTP id f11mr11952576wmg.62.1642442234751;
        Mon, 17 Jan 2022 09:57:14 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id h2sm72101wmq.2.2022.01.17.09.57.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jan 2022 09:57:14 -0800 (PST)
Message-ID: <42dd21d1-8300-3101-4870-bf772783588b@redhat.com>
Date:   Mon, 17 Jan 2022 18:57:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: x86: Making the module parameter of vPMU more common
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220111073823.21885-1-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220111073823.21885-1-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/11/22 08:38, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> The new module parameter to control PMU virtualization should apply
> to Intel as well as AMD, for situations where userspace is not trusted.
> If the module parameter allows PMU virtualization, there could be a
> new KVM_CAP or guest CPUID bits whereby userspace can enable/disable
> PMU virtualization on a per-VM basis.
> 
> If the module parameter does not allow PMU virtualization, there
> should be no userspace override, since we have no precedent for
> authorizing that kind of override. If it's false, other counter-based
> profiling features (such as LBR including the associated CPUID bits
> if any) will not be exposed.
> 
> Change its name from "pmu" to "enable_pmu" as we have temporary
> variables with the same name in our code like "struct kvm_pmu *pmu".
> 
> Fixes: b1d66dad65dc ("KVM: x86/svm: Add module param to control PMU virtualization")
> Suggested-by : Jim Mattson <jmattson@google.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>   arch/x86/kvm/cpuid.c            | 6 +++---
>   arch/x86/kvm/svm/pmu.c          | 2 +-
>   arch/x86/kvm/svm/svm.c          | 8 ++------
>   arch/x86/kvm/svm/svm.h          | 1 -
>   arch/x86/kvm/vmx/capabilities.h | 4 ++++
>   arch/x86/kvm/vmx/pmu_intel.c    | 2 +-
>   arch/x86/kvm/x86.c              | 5 +++++
>   arch/x86/kvm/x86.h              | 1 +
>   8 files changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 0b920e12bb6d..b2ff8bfd8220 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -770,10 +770,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   		perf_get_x86_pmu_capability(&cap);
>   
>   		/*
> -		 * Only support guest architectural pmu on a host
> -		 * with architectural pmu.
> +		 * The guest architecture pmu is only supported if the architecture
> +		 * pmu exists on the host and the module parameters allow it.
>   		 */
> -		if (!cap.version)
> +		if (!cap.version || !enable_pmu)
>   			memset(&cap, 0, sizeof(cap));
>   
>   		eax.split.version_id = min(cap.version, 2);
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index 12d8b301065a..5aa45f13b16d 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -101,7 +101,7 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
>   {
>   	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
>   
> -	if (!pmu)
> +	if (!enable_pmu)
>   		return NULL;
>   
>   	switch (msr) {
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 6cb38044a860..549f73ce5ebc 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -192,10 +192,6 @@ module_param(vgif, int, 0444);
>   static int lbrv = true;
>   module_param(lbrv, int, 0444);
>   
> -/* enable/disable PMU virtualization */
> -bool pmu = true;
> -module_param(pmu, bool, 0444);
> -
>   static int tsc_scaling = true;
>   module_param(tsc_scaling, int, 0444);
>   
> @@ -4573,7 +4569,7 @@ static __init void svm_set_cpu_caps(void)
>   		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
>   
>   	/* AMD PMU PERFCTR_CORE CPUID */
> -	if (pmu && boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
> +	if (enable_pmu && boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
>   		kvm_cpu_cap_set(X86_FEATURE_PERFCTR_CORE);
>   
>   	/* CPUID 0x8000001F (SME/SEV features) */
> @@ -4712,7 +4708,7 @@ static __init int svm_hardware_setup(void)
>   			pr_info("LBR virtualization supported\n");
>   	}
>   
> -	if (!pmu)
> +	if (!enable_pmu)
>   		pr_info("PMU virtualization is disabled\n");
>   
>   	svm_set_cpu_caps();
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index daa8ca84afcc..47ef8f4a9358 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -32,7 +32,6 @@
>   extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
>   extern bool npt_enabled;
>   extern bool intercept_smi;
> -extern bool pmu;
>   
>   /*
>    * Clean bits in VMCB.
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index c8029b7845b6..959b59d13b5a 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -5,6 +5,7 @@
>   #include <asm/vmx.h>
>   
>   #include "lapic.h"
> +#include "x86.h"
>   
>   extern bool __read_mostly enable_vpid;
>   extern bool __read_mostly flexpriority_enabled;
> @@ -389,6 +390,9 @@ static inline u64 vmx_get_perf_capabilities(void)
>   {
>   	u64 perf_cap = 0;
>   
> +	if (!enable_pmu)
> +		return perf_cap;
> +
>   	if (boot_cpu_has(X86_FEATURE_PDCM))
>   		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
>   
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index ffccfd9823c0..466d18fc0c5d 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -487,7 +487,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>   	pmu->reserved_bits = 0xffffffff00200000ull;
>   
>   	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
> -	if (!entry)
> +	if (!entry || !enable_pmu)
>   		return;
>   	eax.full = entry->eax;
>   	edx.full = entry->edx;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c194a8cbd25f..bff2ff8cb35f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -187,6 +187,11 @@ module_param(force_emulation_prefix, bool, S_IRUGO);
>   int __read_mostly pi_inject_timer = -1;
>   module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
>   
> +/* Enable/disable PMU virtualization */
> +bool __read_mostly enable_pmu = true;
> +EXPORT_SYMBOL_GPL(enable_pmu);
> +module_param(enable_pmu, bool, 0444);
> +
>   /*
>    * Restoring the host value for MSRs that are only consumed when running in
>    * usermode, e.g. SYSCALL MSRs and TSC_AUX, can be deferred until the CPU
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index da7031e80f23..1ebd5a7594da 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -336,6 +336,7 @@ extern u64 host_xcr0;
>   extern u64 supported_xcr0;
>   extern u64 host_xss;
>   extern u64 supported_xss;
> +extern bool enable_pmu;
>   
>   static inline bool kvm_mpx_supported(void)
>   {

Queued, thanks.

Paolo

