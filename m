Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E964945F4
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 04:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358248AbiATDCn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 22:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiATDCk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 22:02:40 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30CD1C061574
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 19:02:40 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id mi14-20020a17090b4b4e00b001b51b28c055so586684pjb.1
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 19:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:cc:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=TdxRZhtmU115mCypw4hI9M8Dl6cb7KOaj+L4WncT7zw=;
        b=TJGf3BA9rilCGKyXX5nF51tokhcp0FfUvJZOPXAQpGOE/m2hjHJ6lcJVuRhi0qhTg8
         QKadul04CapjDCszn9Y8Q1G72zEC2NsNoWMitJM55vWtMKHrFtvXHmjfs00PxQTmRoWx
         EN3ultPr8Y8jTYQlGyqZAiBuoBIr71FnEsV7cASKkU/H3E3aUNURuz89ung0ZP6hfLk1
         ov5FB84YvS2cQXpu9DZGpa2nHucO9C2C/Eyw3W4xtd1EuDc7e5xLgIvJdPce+qwDPEyh
         G/A/GUT9FGTxUHkNKo7mDwH6BVHNhUBwY53ArMw7e0yxtGt0XO/a4tCeJ0CwS/Jnk6Q8
         6x+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:cc:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=TdxRZhtmU115mCypw4hI9M8Dl6cb7KOaj+L4WncT7zw=;
        b=jwuNJ6wF2sRQfzzc0SvELruRKmT9ykqcNdLz05VvY8UQsMRdg2YwzX8G9H/PIs0o1W
         p2HZtD0BtPhKwGWHLHzZYn/DG7L0PMU4EQcj1iUgVdXCRF9CYqQaWJ+g79fbYSemNakm
         /br5TNM5cMkYec1z1NEVSRLW8R69ev00eXfg1ESgFHfbJbG5M2hK43ncTU5M5tnyA+T8
         GJ0wmgxq3GhrXOrkrXRNb6rsUZmA/duqnK85MrTwM7kThmk69lYXysTFGB99KWVe/mW1
         PmIPfkBLCi2yyvxguNZHPSQ9XlDFWoqrea5aaPah4onq90a5T6acI8XFS1hq3Re0exc7
         Qfig==
X-Gm-Message-State: AOAM530AnWsSrRom2JHrT26TCM4q11XynQwfpfXzNsUXsw4njc1azRJN
        XXeD79Ya4OjmScneyYzEA1dkfHeTC//ZCA==
X-Google-Smtp-Source: ABdhPJwt+a4YcfiRj/ZObOxYUvhkfBgChqSlKVcndKpKamEfwHPkbDViHoqBS2qLUVVCKu1e3RooeA==
X-Received: by 2002:a17:902:ab85:b0:149:ca14:4a15 with SMTP id f5-20020a170902ab8500b00149ca144a15mr36085858plr.169.1642647759614;
        Wed, 19 Jan 2022 19:02:39 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h10sm1019725pfc.103.2022.01.19.19.02.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jan 2022 19:02:39 -0800 (PST)
Message-ID: <e7322f03-1572-ffb2-ed36-5499e90a685f@gmail.com>
Date:   Thu, 20 Jan 2022 11:02:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH 1/3] Provide VM capability to disable PMU virtualization
 for individual VMs
Content-Language: en-US
To:     David Dunn <daviddunn@google.com>
References: <20220119182818.3641304-1-daviddunn@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org)" 
        <pbonzini@redhat.com>,
        =?UTF-8?B?Y2xvdWRsaWFuZyjmooHph5HojaMp?= <cloudliang@tencent.com>,
        Jim Mattson <jmattson@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <20220119182818.3641304-1-daviddunn@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David,

Thanks for coming to address this.

Please modify the patch(es) subject to follow the convention.

On 20/1/2022 2:28 am, David Dunn wrote:
> When PMU virtualization is enabled via the module parameter, usermode
> can disable PMU virtualization on individual VMs using this new
> capability.

Will the user space fail or be notified when the enable_pmu say no ?

> 
> This provides a uniform way to disable PMU virtualization on x86.  Since
> AMD doesn't have a CPUID bit for PMU support, disabling PMU

Not entirely absent, such as PERFCTR_CORE.

> virtualization requires some other state to indicate whether the PMU
> related MSRs are ignored.

Not just ignored, but made to disappear altogether.

> 
> Since KVM_GET_SUPPORTED_CPUID reports the maximal CPUID information
> based on module parameters, usermode will need to adjust CPUID when
> disabling PMU virtualization on individual VMs.  On Intel CPUs, the
> change to PMU enablement will not alter existing until SET_CPUID2 is
> invoked.

Please clarify. Do we have a requirement for the order in which the
SET_CPUID2 and ioctl_enable_cap interfaces are called?

> 
> Signed-off-by: David Dunn <daviddunn@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  1 +
>   arch/x86/kvm/svm/pmu.c          |  2 +-
>   arch/x86/kvm/vmx/pmu_intel.c    |  2 +-
>   arch/x86/kvm/x86.c              | 11 +++++++++++
>   include/uapi/linux/kvm.h        |  1 +
>   tools/include/uapi/linux/kvm.h  |  1 +
>   6 files changed, 16 insertions(+), 2 deletions(-)
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

The name makes it difficult to distinguish the scope of access to the variable.
Try storing it via "pmu->version == 0".

>   };
>   
>   struct kvm_vm_stat {
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index 5aa45f13b16d..605bcfb55625 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -101,7 +101,7 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
>   {
>   	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
>   
> -	if (!enable_pmu)
> +	if (!enable_pmu || !vcpu->kvm->arch.enable_pmu)
>   		return NULL;
>   
>   	switch (msr) {
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 466d18fc0c5d..4c3885765027 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -487,7 +487,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>   	pmu->reserved_bits = 0xffffffff00200000ull;
>   
>   	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
> -	if (!entry || !enable_pmu)
> +	if (!entry || !vcpu->kvm->arch.enable_pmu || !enable_pmu)
>   		return;
>   	eax.full = entry->eax;
>   	edx.full = entry->edx;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 55518b7d3b96..9b640c5bb4f6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4326,6 +4326,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   		if (r < sizeof(struct kvm_xsave))
>   			r = sizeof(struct kvm_xsave);
>   		break;
> +	case KVM_CAP_ENABLE_PMU:
> +		r = enable_pmu;
> +		break;
>   	}
>   	default:
>   		break;
> @@ -5937,6 +5940,13 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   		kvm->arch.exit_on_emulation_error = cap->args[0];
>   		r = 0;
>   		break;
> +	case KVM_CAP_ENABLE_PMU:
> +		r = -EINVAL;
> +		if (!enable_pmu || cap->args[0] & ~1)
> +			break;
> +		kvm->arch.enable_pmu = cap->args[0];
> +		r = 0;
> +		break;
>   	default:
>   		r = -EINVAL;
>   		break;
> @@ -11562,6 +11572,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
>   
>   	kvm->arch.guest_can_read_msr_platform_info = true;
> +	kvm->arch.enable_pmu = true;
>   
>   #if IS_ENABLED(CONFIG_HYPERV)
>   	spin_lock_init(&kvm->arch.hv_root_tdp_lock);
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 9563d294f181..37cbcdffe773 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1133,6 +1133,7 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
>   #define KVM_CAP_VM_GPA_BITS 207
>   #define KVM_CAP_XSAVE2 208
> +#define KVM_CAP_ENABLE_PMU 209

Rename it to KVM_CAP_PMU_CAPABILITY and use the bit 0 for *DISABLE_PMU*.

>   
>   #ifdef KVM_CAP_IRQ_ROUTING
>   
> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
> index f066637ee206..e71712c71ab1 100644
> --- a/tools/include/uapi/linux/kvm.h
> +++ b/tools/include/uapi/linux/kvm.h
> @@ -1132,6 +1132,7 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_ARM_MTE 205
>   #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
>   #define KVM_CAP_XSAVE2 207
> +#define KVM_CAP_ENABLE_PMU 209
>   
>   #ifdef KVM_CAP_IRQ_ROUTING
>   
