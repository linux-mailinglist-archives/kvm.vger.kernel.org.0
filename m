Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C5149456F
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 02:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240567AbiATBPw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 20:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbiATBPv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 20:15:51 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F03C061574
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 17:15:51 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id pf13so4264980pjb.0
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 17:15:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w+ACjmQj/mxjLPRVwNvc/tjG2xIG1XyGQYSZl8IL2SI=;
        b=EJlGdNfCAuAvcA3VFyhYgZh3NRTeJJtjsfJE73eMvPvLp7THFcP0BLxKzETQiQXcJl
         uel7kdeScf6U/3b8Z37eTcrzIZdXCwBx1sM8Wn5Utg9+0qdVOMWetT6imCw+xVZOeJez
         ttOWF8D8OVnu8hbelXiRgZNEuNvixkAEukj3bzYNaZ/OIvJlHp4gWHd8/aCSDdQHVow2
         5xXxbdpwnohNAw0E/p13bQJOAkKIcrMWKzWNalRqNdC9JlwzqVrAN0AQVFGfRoAgPJOp
         RSHUsNRsWLEgcOWkl0BTaZ+f+1q1qUtzATKp04bmj54cukZJNa672Qe2yy5gmoO+8aTO
         BSwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w+ACjmQj/mxjLPRVwNvc/tjG2xIG1XyGQYSZl8IL2SI=;
        b=c27Z2A+YwLIaEAcQ7dDrERYbGMPi6EHbpb3hB9gq6AVCxqvSrJ8g2IgbRcSYgRjiXh
         ZMM1N8d636HOWqB3f6SeTQjg6jwmG4dO2bU9voMTAAO2QJK6u8Q6WKqdlBB01qHpsrZX
         czt2ma34myQacyPxqCqvjfQMDgA2IoOFlog1S6lMA5VIH0pzUcSwTCdVtBxXWZ8wJFdg
         9B7FBMMPRs7fz5PVqxjqPqhwp8E3tWgggqG/+4Jng4iWDWYmqkFdgxVNjJfQH7dR++b0
         jQ0nuj5a6uIyIdqcUuwCODWpQzX+KbaHKMDgprNg/NA946YnenwxbLwEMizRbwvnt3zh
         WhAA==
X-Gm-Message-State: AOAM532Bj/3BTlwUA/KsRilSmdae7aueHw9PeJKqc3CX2rv+jw5zGVoj
        BDUEEypje17QG2Vdtdc4ZJQdpg==
X-Google-Smtp-Source: ABdhPJxRWrFpB8PZ3TdvMovfqWJ0zlfYwEn0cLlFn/6MLGhvEEOxYRHysPA8Ktntc3X0rc7Lr09PgQ==
X-Received: by 2002:a17:90b:4c0e:: with SMTP id na14mr7787356pjb.84.1642641350791;
        Wed, 19 Jan 2022 17:15:50 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b2sm799339pfv.134.2022.01.19.17.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 17:15:50 -0800 (PST)
Date:   Thu, 20 Jan 2022 01:15:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Dunn <daviddunn@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com,
        jmattson@google.com, cloudliang@tencent.com
Subject: Re: [PATCH 1/3] Provide VM capability to disable PMU virtualization
 for individual VMs
Message-ID: <Yei3whU32mupq9RV@google.com>
References: <20220119182818.3641304-1-daviddunn@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220119182818.3641304-1-daviddunn@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 19, 2022, David Dunn wrote:
> When PMU virtualization is enabled via the module parameter, usermode
> can disable PMU virtualization on individual VMs using this new
> capability.
> 
> This provides a uniform way to disable PMU virtualization on x86.  Since
> AMD doesn't have a CPUID bit for PMU support, disabling PMU
> virtualization requires some other state to indicate whether the PMU
> related MSRs are ignored.
> 
> Since KVM_GET_SUPPORTED_CPUID reports the maximal CPUID information
> based on module parameters, usermode will need to adjust CPUID when
> disabling PMU virtualization on individual VMs.  On Intel CPUs, the
> change to PMU enablement will not alter existing until SET_CPUID2 is
> invoked.
> 
> Signed-off-by: David Dunn <daviddunn@google.com>
> ---

I'm not necessarily opposed to this capability, but can't userspace get the same
result by using MSR filtering to inject #GP on the PMU MSRs?

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 55518b7d3b96..9b640c5bb4f6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4326,6 +4326,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		if (r < sizeof(struct kvm_xsave))
>  			r = sizeof(struct kvm_xsave);
>  		break;
> +	case KVM_CAP_ENABLE_PMU:
> +		r = enable_pmu;
> +		break;
>  	}
>  	default:
>  		break;
> @@ -5937,6 +5940,13 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		kvm->arch.exit_on_emulation_error = cap->args[0];
>  		r = 0;
>  		break;
> +	case KVM_CAP_ENABLE_PMU:
> +		r = -EINVAL;
> +		if (!enable_pmu || cap->args[0] & ~1)

Probably worth adding a #define in uapi/.../kvm.h for bit 0.

> +			break;
> +		kvm->arch.enable_pmu = cap->args[0];
> +		r = 0;
> +		break;
>  	default:
>  		r = -EINVAL;
>  		break;
> @@ -11562,6 +11572,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
>  
>  	kvm->arch.guest_can_read_msr_platform_info = true;
> +	kvm->arch.enable_pmu = true;

Rather than default to "true", just capture the global "enable_pmu" and then all
the sites that check "enable_pmu" in VM context can check _only_ kvm->arch.enable_pmu.
enable_pmu is readonly, so there's no danger of it being toggled after the VM is
created.

>  #if IS_ENABLED(CONFIG_HYPERV)
>  	spin_lock_init(&kvm->arch.hv_root_tdp_lock);
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 9563d294f181..37cbcdffe773 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1133,6 +1133,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
>  #define KVM_CAP_VM_GPA_BITS 207
>  #define KVM_CAP_XSAVE2 208
> +#define KVM_CAP_ENABLE_PMU 209
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
> index f066637ee206..e71712c71ab1 100644
> --- a/tools/include/uapi/linux/kvm.h
> +++ b/tools/include/uapi/linux/kvm.h
> @@ -1132,6 +1132,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_ARM_MTE 205
>  #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
>  #define KVM_CAP_XSAVE2 207
> +#define KVM_CAP_ENABLE_PMU 209
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> -- 
> 2.34.1.703.g22d0c6ccf7-goog
> 
