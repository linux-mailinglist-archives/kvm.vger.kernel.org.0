Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E85144D728
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 14:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbhKKN1C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 08:27:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23858 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231380AbhKKN1B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 08:27:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636637052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8y1i26z9W/6KGoFrwymr+lNrACQa7pZ4kY4aM7mHvas=;
        b=UFyvOLU46fPuMuZTeaX4sWw552vv6qCJG3YMRVckzofpoRcPiiiuUIKnqjMf8UVtI6q494
        4JClVJK9lU5idKFL6i+T4FeqOr+gjc6jfvjI5nWM5p21lve2tOdaFyvzuiRv3SVKRYwN3h
        JgzA/KG0QG3ElpYsUA90kJCe5Vu6si4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-GIk_Pij2PH6hwyyclsho1g-1; Thu, 11 Nov 2021 08:24:11 -0500
X-MC-Unique: GIk_Pij2PH6hwyyclsho1g-1
Received: by mail-ed1-f71.google.com with SMTP id o15-20020a056402438f00b003e32b274b24so5349002edc.21
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 05:24:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8y1i26z9W/6KGoFrwymr+lNrACQa7pZ4kY4aM7mHvas=;
        b=ZH0rjk1wPeRirfZlLL0BB9b7IuF0kmKB9NwuViARfUFn0WlMaXm18w5I8wLn7FPUo7
         GaZsPzaPV2+VN89bIELrK9R4D2jcXop8AgIKxjJBOma4jARyPOEsMGnn4/mw0F+AAtLg
         4PCB03GjgU2StqqNmAXlS6S7kXatnSy+xxPb/x5v+cnNitlz7JUKiMvXKQZ+j1gMXnm0
         oB6f/4Lp4KZYe0Z57ohQwSLAXUGAqhWfswwfEysNSzVyxSfIvYwVGveUloEKiF7gt4YM
         xHbP/xG3dOmieCXVd+iPE5FsM0kL4gCPlQrcDP8LhXdRukgwUCcXP57TEDdOUfyMza7Z
         foIw==
X-Gm-Message-State: AOAM531JsM5wjkOsOOYr+h5Gtjkmju8aNZ1DEACAleX/0Obg+XW4a0jf
        jGqT3XyrFICc+M2tcW97s4snLbFwttVOda/PWMfw2kWNxm/JY3r4E7a0ksu54CqIbHZ9j8mupFg
        4SiPBMn1cMY7x
X-Received: by 2002:a05:6402:148:: with SMTP id s8mr9903215edu.221.1636637049887;
        Thu, 11 Nov 2021 05:24:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzbVah5ywxQHSq8/Pew3Ppf4Hx2baZmMNT8S6/h/YWBv/jTwmO8wYk/64ctVL0s3FtcQLV5IA==
X-Received: by 2002:a05:6402:148:: with SMTP id s8mr9903182edu.221.1636637049659;
        Thu, 11 Nov 2021 05:24:09 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id sb19sm1386368ejc.120.2021.11.11.05.24.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 05:24:08 -0800 (PST)
Message-ID: <eacffa80-3aac-1221-4cdb-fb69f5ddf474@redhat.com>
Date:   Thu, 11 Nov 2021 14:24:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2] kvm: x86: Convert return type of *is_valid_rdpmc_ecx()
 to bool
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>
References: <20211105202058.1048757-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211105202058.1048757-1-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/5/21 21:20, Jim Mattson wrote:
> These function names sound like predicates, and they have siblings,
> *is_valid_msr(), which _are_ predicates. Moreover, there are comments
> that essentially warn that these functions behave unexpectedly.
> 
> Flip the polarity of the return values, so that they become
> predicates, and convert the boolean result to a success/failure code
> at the outer call site.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/pmu.c           | 2 +-
>   arch/x86/kvm/pmu.h           | 4 ++--
>   arch/x86/kvm/svm/pmu.c       | 5 ++---
>   arch/x86/kvm/vmx/pmu_intel.c | 7 +++----
>   arch/x86/kvm/x86.c           | 4 +++-
>   5 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 0772bad9165c..09873f6488f7 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -319,7 +319,7 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
>   }
>   
>   /* check if idx is a valid index to access PMU */
> -int kvm_pmu_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
> +bool kvm_pmu_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
>   {
>   	return kvm_x86_ops.pmu_ops->is_valid_rdpmc_ecx(vcpu, idx);
>   }
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 0e4f2b1fa9fb..59d6b76203d5 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -32,7 +32,7 @@ struct kvm_pmu_ops {
>   	struct kvm_pmc *(*rdpmc_ecx_to_pmc)(struct kvm_vcpu *vcpu,
>   		unsigned int idx, u64 *mask);
>   	struct kvm_pmc *(*msr_idx_to_pmc)(struct kvm_vcpu *vcpu, u32 msr);
> -	int (*is_valid_rdpmc_ecx)(struct kvm_vcpu *vcpu, unsigned int idx);
> +	bool (*is_valid_rdpmc_ecx)(struct kvm_vcpu *vcpu, unsigned int idx);
>   	bool (*is_valid_msr)(struct kvm_vcpu *vcpu, u32 msr);
>   	int (*get_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
>   	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
> @@ -149,7 +149,7 @@ void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
>   void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
>   void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
>   int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
> -int kvm_pmu_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx);
> +bool kvm_pmu_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx);
>   bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr);
>   int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
>   int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index fdf587f19c5f..871c426ec389 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -181,14 +181,13 @@ static struct kvm_pmc *amd_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
>   	return get_gp_pmc_amd(pmu, base + pmc_idx, PMU_TYPE_COUNTER);
>   }
>   
> -/* returns 0 if idx's corresponding MSR exists; otherwise returns 1. */
> -static int amd_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
> +static bool amd_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
>   {
>   	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>   
>   	idx &= ~(3u << 30);
>   
> -	return (idx >= pmu->nr_arch_gp_counters);
> +	return idx < pmu->nr_arch_gp_counters;
>   }
>   
>   /* idx is the ECX register of RDPMC instruction */
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index b8e0d21b7c8a..1b7456b2177b 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -118,16 +118,15 @@ static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
>   	}
>   }
>   
> -/* returns 0 if idx's corresponding MSR exists; otherwise returns 1. */
> -static int intel_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
> +static bool intel_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
>   {
>   	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>   	bool fixed = idx & (1u << 30);
>   
>   	idx &= ~(3u << 30);
>   
> -	return (!fixed && idx >= pmu->nr_arch_gp_counters) ||
> -		(fixed && idx >= pmu->nr_arch_fixed_counters);
> +	return fixed ? idx < pmu->nr_arch_fixed_counters
> +		     : idx < pmu->nr_arch_gp_counters;
>   }
>   
>   static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c1c4e2b05a63..d7def720227d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7328,7 +7328,9 @@ static void emulator_set_smbase(struct x86_emulate_ctxt *ctxt, u64 smbase)
>   static int emulator_check_pmc(struct x86_emulate_ctxt *ctxt,
>   			      u32 pmc)
>   {
> -	return kvm_pmu_is_valid_rdpmc_ecx(emul_to_vcpu(ctxt), pmc);
> +	if (kvm_pmu_is_valid_rdpmc_ecx(emul_to_vcpu(ctxt), pmc))
> +		return 0;
> +	return -EINVAL;
>   }
>   
>   static int emulator_read_pmc(struct x86_emulate_ctxt *ctxt,
> 

Queued, thanks.

Paolo

