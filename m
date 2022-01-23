Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A46496FC3
	for <lists+kvm@lfdr.de>; Sun, 23 Jan 2022 05:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235523AbiAWE4V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Jan 2022 23:56:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231782AbiAWE4U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Jan 2022 23:56:20 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1439FC06173B
        for <kvm@vger.kernel.org>; Sat, 22 Jan 2022 20:56:20 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id e8so12452210plh.8
        for <kvm@vger.kernel.org>; Sat, 22 Jan 2022 20:56:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:cc:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=n3Bezlm6GCGDTeIJ796Lv3P10ZsLrWbBYutGRzOay34=;
        b=Y3WzW4f2fgfJe+/LRbmHrXQDn6Zgdw/dkFSO8Fkm3FHX1RI3ZYOogfLT090f5HrJhk
         zMCBvbLwEpBUdYf2cQpKRVZ5E8MIftqw9O/04Ruisod2hnrV+9de69V91LgLTGGk2VLB
         542SAePwFSjAoZdr1Q9dKGWPn1fPB2VrsheHzMNaVUqA2Z9zXU1Bd332dUQKM1hAwjXh
         1pcQAyfArzqV7lS852+4OOjcW4tgPHMLZequx81QQwNs/BahaLYrBmsUvZlhXgeikBOZ
         l/oT7LHvIP+M4r3wj3IFh3/KCozuVxXy3KB71v+rUmUxpVrnx7c3CW/Rd8OpXORSDBNp
         RlLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:cc:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=n3Bezlm6GCGDTeIJ796Lv3P10ZsLrWbBYutGRzOay34=;
        b=LW2B7VVgK78ZtpurVppH2fWCa42bUD2ScM5FBdQ4eG23pliA+sT3x1WfVQ/GKM4vlh
         ipNH2F99QsiDfVCmal30qWzpirNd3NqFwnklvl6tT4qLHYw3CKNj+rCfVZnL67g7qcfU
         YrtuyH/Opu6Wca0zeHJWnxEwCHdUABW4atNCuRUZkAjASjs3J03GbAT2gwK8Z9SrNBP/
         k8mIP3keqXaaNRXi3RRJuJy7UTPvHvo9Vdy303XWhvZMoYV4IpTcLBLHdJK9xpVLH8TY
         QfHOVNpZBJDbMAZDrTLOxno4kI/M2Ww0VOTjTlIDDbcPJORfw9fYSNJwiCu3ZyoxErzr
         /C+g==
X-Gm-Message-State: AOAM533haQNPPpTN3WvhahnWmpzHd1+fEzJluBjVMD4f9IO/tzI5SmYC
        3xNmnWerKBHMi6c3G8LfM08=
X-Google-Smtp-Source: ABdhPJwzWyB5RsCsO5eTekPqiDidVuLyV8km3UqMpAm+bN+YN91RC3zUrS4s1eup0nxWJYtowMKLGw==
X-Received: by 2002:a17:90b:3508:: with SMTP id ls8mr2126903pjb.214.1642913779172;
        Sat, 22 Jan 2022 20:56:19 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d18sm12180185pfv.173.2022.01.22.20.56.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Jan 2022 20:56:18 -0800 (PST)
Message-ID: <1d964610-6f8d-da71-729a-49e36d1e61cf@gmail.com>
Date:   Sun, 23 Jan 2022 12:56:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH v4 1/3] KVM: x86: Provide per VM capability for disabling
 PMU virtualization
Content-Language: en-US
To:     David Dunn <daviddunn@google.com>
References: <20220121222933.696067-1-daviddunn@google.com>
 <20220121222933.696067-2-daviddunn@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        cloudliang@tencent.com, seanjc@google.com
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <20220121222933.696067-2-daviddunn@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/1/2022 6:29 am, David Dunn wrote:
> KVM_CAP_PMU_DISABLE is used to disable PMU virtualization on individual
> x86 VMs.  PMU configuration must be done prior to creating VCPUs.
> 
> To enable future extension, KVM_CAP_PMU_CAPABILITY reports available
> settings via bitmask when queried via check_extension.
> 
> For VMs that have PMU virtualization disabled, CPUID leaf 0xA will be
> cleared to notify guests.
> 
> Signed-off-by: David Dunn <daviddunn@google.com>
> ---
>   Documentation/virt/kvm/api.rst  | 21 +++++++++++++++++++++
>   arch/x86/include/asm/kvm_host.h |  1 +
>   arch/x86/kvm/cpuid.c            |  8 ++++++++
>   arch/x86/kvm/svm/pmu.c          |  2 +-
>   arch/x86/kvm/vmx/pmu_intel.c    |  2 +-
>   arch/x86/kvm/x86.c              | 12 ++++++++++++
>   include/uapi/linux/kvm.h        |  4 ++++
>   tools/include/uapi/linux/kvm.h  |  4 ++++
>   8 files changed, 52 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index bb8cfddbb22d..375d35e8ac47 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7559,3 +7559,24 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
>   of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
>   the hypercalls whose corresponding bit is in the argument, and return
>   ENOSYS for the others.
> +
> +8.35 KVM_CAP_PMU_CAPABILITY
> +---------------------------
> +
> +:Capability KVM_CAP_PMU_CAPABILITY
> +:Architectures: x86
> +:Type: vm

:Parameters: args[0] defines ....
:Returns: 0 on success, -EINVAL when args[0] contains invalid bits

> +
> +This capability alters PMU virtualization in KVM.
> +
> +Calling KVM_CHECK_EXTENSION for this capability returns a bitmask of
> +PMU virtualization capabilities that can be adjusted on a VM.
> +
> +The argument to KVM_ENABLE_CAP is also a bitmask and selects specific
> +PMU virtualization capabilities to be applied to the VM.  This can
> +only be invoked on a VM prior to the creation of VCPUs.
> +
> +At this time, KVM_CAP_PMU_DISABLE is the only capability.  Setting
> +this capability will disable PMU virtualization for that VM.  When
> +PMU virtualization is disabled, CPUID leaf 0xA will always be cleared
> +to properly inform Intel guests.

Valid bits in args[0] are::

   #define KVM_CAP_PMU_DISABLE      (1 << 0)


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
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 3902c28fb6cb..a91c4a00c913 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -217,6 +217,14 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
>   		cpuid_entry_change(best, X86_FEATURE_OSPKE,
>   				   kvm_read_cr4_bits(vcpu, X86_CR4_PKE));
>   
> +	best = cpuid_entry2_find(entries, nent, 0xA, 0);
> +	if (best && !vcpu->kvm->arch.enable_pmu) {
> +		best->eax = 0;
> +		best->ebx = 0;
> +		best->ecx = 0;
> +		best->edx = 0;
> +	}

Sorry, I don't think we should do this stuff for the buggy user space.

For others, Reviewed-by: Like Xu <likexu@tencent.com>

> +
>   	best = cpuid_entry2_find(entries, nent, 0xD, 0);
>   	if (best)
>   		best->ebx = xstate_required_size(vcpu->arch.xcr0, false);
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
> index 55518b7d3b96..a033f019a3f0 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4326,6 +4326,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   		if (r < sizeof(struct kvm_xsave))
>   			r = sizeof(struct kvm_xsave);
>   		break;
> +	case KVM_CAP_PMU_CAPABILITY:
> +		r = enable_pmu ? KVM_CAP_PMU_MASK : 0;
> +		break;
>   	}
>   	default:
>   		break;
> @@ -5937,6 +5940,14 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   		kvm->arch.exit_on_emulation_error = cap->args[0];
>   		r = 0;
>   		break;
> +	case KVM_CAP_PMU_CAPABILITY:
> +		r = -EINVAL;
> +		if (!enable_pmu || kvm->created_vcpus > 0 ||
> +		    cap->args[0] & ~KVM_CAP_PMU_MASK)
> +			break;
> +		kvm->arch.enable_pmu = !(cap->args[0] & KVM_CAP_PMU_DISABLE);
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
> index 9563d294f181..1c5e6e172817 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1133,6 +1133,7 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
>   #define KVM_CAP_VM_GPA_BITS 207
>   #define KVM_CAP_XSAVE2 208
> +#define KVM_CAP_PMU_CAPABILITY 209
>   
>   #ifdef KVM_CAP_IRQ_ROUTING
>   
> @@ -1972,6 +1973,9 @@ struct kvm_dirty_gfn {
>   #define KVM_BUS_LOCK_DETECTION_OFF             (1 << 0)
>   #define KVM_BUS_LOCK_DETECTION_EXIT            (1 << 1)
>   
> +#define KVM_CAP_PMU_DISABLE                    (1 << 0)
> +#define KVM_CAP_PMU_MASK                       (KVM_CAP_PMU_DISABLE)
> +
>   /**
>    * struct kvm_stats_header - Header of per vm/vcpu binary statistics data.
>    * @flags: Some extra information for header, always 0 for now.
> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
> index 9563d294f181..a361cf6e8604 100644
> --- a/tools/include/uapi/linux/kvm.h
> +++ b/tools/include/uapi/linux/kvm.h
> @@ -1133,6 +1133,7 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
>   #define KVM_CAP_VM_GPA_BITS 207
>   #define KVM_CAP_XSAVE2 208
> +#define KVM_CAP_PMU_CAPABILITY 209
>   
>   #ifdef KVM_CAP_IRQ_ROUTING
>   
> @@ -1972,6 +1973,9 @@ struct kvm_dirty_gfn {
>   #define KVM_BUS_LOCK_DETECTION_OFF             (1 << 0)
>   #define KVM_BUS_LOCK_DETECTION_EXIT            (1 << 1)
>   
> +#define KVM_CAP_PMU_DISABLE                    (1 << 0)
> +#define KVM_CAP_PMU_MASK                       (KVM_PMU_CONFIG_DISABLE)
> +
>   /**
>    * struct kvm_stats_header - Header of per vm/vcpu binary statistics data.
>    * @flags: Some extra information for header, always 0 for now.
