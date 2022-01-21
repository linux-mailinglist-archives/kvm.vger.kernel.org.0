Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188D0495A34
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 07:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245144AbiAUG7i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 01:59:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233755AbiAUG7h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 01:59:37 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6BFC061574
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 22:59:37 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id n16-20020a17090a091000b001b46196d572so8317401pjn.5
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 22:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:cc:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=YmUl4JVzOBhY1+7qgspYKEZSmcUNQu7rAXxC2003xgM=;
        b=IVN/zSIGrkdC7VFvF6jgMtI5/oO108CTvva0XSy2ijzaEAuHmybDhbRUIXtbn00E0T
         9kEwJOPZcM2zfcLyaFe2paHw1qH0tdawnF1o9qXWiRAPB2Eie441giWDyH+JXzdLirX8
         +TF3PRECXBIYHlnDD5K6T8F0vAYS7tObZLIMicqLDFBl6gTgjb5wAHV0h5dRoLvwOrgF
         JN7heFd1OzghII5pAGgPsF136iHypPi12LIxU2Scw9G3D7c8nbYz3koDC8EyOxIynx5r
         0hPHP6r9p9uadm7yxOiX13Cu69aLn/0XpziHE5OY+7FkP5csEBcMeGmLrGsZSMIDr9/X
         fVHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:cc:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=YmUl4JVzOBhY1+7qgspYKEZSmcUNQu7rAXxC2003xgM=;
        b=1V7waYimEuZRSObscEvcML4NyOoD5Y3xjzzxNc3+jDs+6AB24HMZx9uJeCA2WToQ7g
         71CumnHnN0PmaVAwwI9yL+5QS+5FEgey6ng1oTrLHVLszhkw8VrWp5QNoLNvl/GtV37W
         8U/4nlm1yqSuKNiQehdoPt2iSTa4BnLF1E5Eq0J8/+h0iP83+f/3xprlgfN4Vv9CFWtw
         RKIYHfL+nqQopFOUkgVktDRl146byiKlP0X+lFo1wdrfNTVk/fwNTe0fOnjzVRoGPGee
         eDr7Nms3idsYfbwB//AhhRzPCl9tjGiFvPp6nkVLARlLSwsOF55wtcQdglLvAPVnio+q
         aZeg==
X-Gm-Message-State: AOAM532oav9ZqdDJg7orcbIUjzQ4UWzTzJJmDQnPfAdjqWF8B7tmpFIn
        dQxIqJcLNy5ay47kkFSafYc=
X-Google-Smtp-Source: ABdhPJzXAHvsvEjCYoykvfgXVTHd7amiod2yoaH8sbZfsTtcmLvEbqxy6+MWGtX011VTGIcth+oh0g==
X-Received: by 2002:a17:90a:7e81:: with SMTP id j1mr15175125pjl.14.1642748376177;
        Thu, 20 Jan 2022 22:59:36 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id w9sm11461485pjf.9.2022.01.20.22.59.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jan 2022 22:59:35 -0800 (PST)
Message-ID: <1c02c6b3-1520-5b15-8c77-26fe59e86c1e@gmail.com>
Date:   Fri, 21 Jan 2022 14:59:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH v2 1/3] Provide VM capability to disable PMU
 virtualization for individual VMs
Content-Language: en-US
To:     David Dunn <daviddunn@google.com>
References: <20220121002952.241015-1-daviddunn@google.com>
 <20220121002952.241015-2-daviddunn@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org)" 
        <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>,
        =?UTF-8?B?Y2xvdWRsaWFuZyjmooHph5HojaMp?= <cloudliang@tencent.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <20220121002952.241015-2-daviddunn@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David,

Please modify the subject of this patch to follow the convention.

On 21/1/2022 8:29 am, David Dunn wrote:
> KVM_PMU_CONFIG_DISABLE can be used to disable PMU virtualization on

How about using:

case KVM_CAP_PMU_CAPABILITY
#define KVM_CAP_PMU_DISABLE	(1 << 0)
#define KVM_CAP_PMU_MASK (KVM_CAP_PMU_DISABLE)

> individual x86 VMs.  PMU configuration must be done prior to creating
> VCPUs.
> 
> To enable future extension, KVM_CAP_PMU_CONFIG reports available
> settings when queried via check_extension.

Please help update the document in the Documentation/virt/kvm/api.rst

> 
> Since KVM_GET_SUPPORTED_CPUID reports the maximal CPUID information
> based on module parameters, usermode will need to adjust CPUID when
> disabling PMU virtualization on individual VMs.

For an irrational user space (set both pmu cpuid bits and KVM_CAP_PMU_DISABLE),
how about we remove the relevant PMU cpuid bits in kvm_pmu_refresh() silently?

> 
> Signed-off-by: David Dunn <daviddunn@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  1 +
>   arch/x86/kvm/svm/pmu.c          |  2 +-
>   arch/x86/kvm/vmx/pmu_intel.c    |  2 +-
>   arch/x86/kvm/x86.c              | 12 ++++++++++++
>   include/uapi/linux/kvm.h        |  4 ++++
>   tools/include/uapi/linux/kvm.h  |  4 ++++
>   6 files changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 682ad02a4e58..5cdcd4a7671b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1232,6 +1232,7 @@ struct kvm_arch {
>   	hpa_t	hv_root_tdp;
>   	spinlock_t hv_root_tdp_lock;
>   #endif
> +	bool enable_pmu;
>   };
>   
>   struct kvm_vm_stat {
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index 5aa45f13b16d..d4de52409335 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -101,7 +101,7 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
>   {
>   	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
>   
> -	if (!enable_pmu)
> +	if (!vcpu->kvm->arch.enable_pmu)

Compared to diff in the v1:

-	if (!enable_pmu)
+	if (!enable_pmu || !vcpu->kvm->arch.enable_pmu)

Now I have come to appreciate the ingenious name.

>   		return NULL;
>   
>   	switch (msr) {
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 466d18fc0c5d..2c5868d77268 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -487,7 +487,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>   	pmu->reserved_bits = 0xffffffff00200000ull;
>   
>   	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
> -	if (!entry || !enable_pmu)
> +	if (!entry || !vcpu->kvm->arch.enable_pmu)
>   		return;
>   	eax.full = entry->eax;
>   	edx.full = entry->edx;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 55518b7d3b96..42a98635bea5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4326,6 +4326,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   		if (r < sizeof(struct kvm_xsave))
>   			r = sizeof(struct kvm_xsave);
>   		break;
> +	case KVM_CAP_PMU_CONFIG:
> +		r = enable_pmu ? KVM_PMU_CONFIG_VALID : 0;
> +		break;

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 42a98635bea5..94481f92355d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4326,10 +4326,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
  		if (r < sizeof(struct kvm_xsave))
  			r = sizeof(struct kvm_xsave);
  		break;
+	}
  	case KVM_CAP_PMU_CONFIG:
  		r = enable_pmu ? KVM_CAP_PMU_MASK : 0;
  		break;
-	}
  	default:
  		break;
  	}

>   	}
>   	default:
>   		break;
> @@ -5937,6 +5940,14 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   		kvm->arch.exit_on_emulation_error = cap->args[0];
>   		r = 0;
>   		break;
> +	case KVM_CAP_PMU_CONFIG:
> +		r = -EINVAL;
> +		if (!enable_pmu || kvm->created_vcpus > 0 ||
> +		    cap->args[0] & ~KVM_PMU_CONFIG_VALID)
> +			break;
> +		kvm->arch.enable_pmu = !(cap->args[0] & KVM_PMU_CONFIG_DISABLE);
> +		r = 0;
> +		break;
>   	default:
>   		r = -EINVAL;
>   		break;
> @@ -11562,6 +11573,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
>   
>   	kvm->arch.guest_can_read_msr_platform_info = true;
> +	kvm->arch.enable_pmu = enable_pmu;
>   
>   #if IS_ENABLED(CONFIG_HYPERV)
>   	spin_lock_init(&kvm->arch.hv_root_tdp_lock);
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 9563d294f181..57a1280fa43b 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1133,6 +1133,7 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
>   #define KVM_CAP_VM_GPA_BITS 207
>   #define KVM_CAP_XSAVE2 208
> +#define KVM_CAP_PMU_CONFIG 209
>   
>   #ifdef KVM_CAP_IRQ_ROUTING
>   
> @@ -1972,6 +1973,9 @@ struct kvm_dirty_gfn {
>   #define KVM_BUS_LOCK_DETECTION_OFF             (1 << 0)
>   #define KVM_BUS_LOCK_DETECTION_EXIT            (1 << 1)
>   
> +#define KVM_PMU_CONFIG_DISABLE                 (1 << 0)
> +#define KVM_PMU_CONFIG_VALID                   (KVM_PMU_CONFIG_DISABLE)
> +
>   /**
>    * struct kvm_stats_header - Header of per vm/vcpu binary statistics data.
>    * @flags: Some extra information for header, always 0 for now.
> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
> index 9563d294f181..57a1280fa43b 100644
> --- a/tools/include/uapi/linux/kvm.h
> +++ b/tools/include/uapi/linux/kvm.h
> @@ -1133,6 +1133,7 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
>   #define KVM_CAP_VM_GPA_BITS 207
>   #define KVM_CAP_XSAVE2 208
> +#define KVM_CAP_PMU_CONFIG 209
>   
>   #ifdef KVM_CAP_IRQ_ROUTING
>   
> @@ -1972,6 +1973,9 @@ struct kvm_dirty_gfn {
>   #define KVM_BUS_LOCK_DETECTION_OFF             (1 << 0)
>   #define KVM_BUS_LOCK_DETECTION_EXIT            (1 << 1)
>   
> +#define KVM_PMU_CONFIG_DISABLE                 (1 << 0)
> +#define KVM_PMU_CONFIG_VALID                   (KVM_PMU_CONFIG_DISABLE)
> +
>   /**
>    * struct kvm_stats_header - Header of per vm/vcpu binary statistics data.
>    * @flags: Some extra information for header, always 0 for now.
