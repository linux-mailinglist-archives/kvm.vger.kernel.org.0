Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269734D75B3
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 15:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234432AbiCMOJI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 10:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234370AbiCMOJF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 10:09:05 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CCB59FD7;
        Sun, 13 Mar 2022 07:07:51 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id r65so7862752wma.2;
        Sun, 13 Mar 2022 07:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5v42B6Asu9c7y2uonyfupy6jjnX4xWboTH68oYuewZ4=;
        b=kLV6CyWcXvyQwwKsa8nDjvKH5MGtLE3JdGGCClrg3FyfP7cgJpoYlyVXofF7j7UPYa
         NtswjFhlaMYL4z7ukPV+b3FmQA/JhYnPIUGS5M6EtB+FnvPFehWWT7aPXY4SrE2eaNNg
         tbo/ISzCPqdMWGNnGUgm6hZfaFx/Ykj0KD71C9maH9FRJ9hKUZKgoSr/sqa3Q+hvrh8Z
         ni4jax9JyT2kHqJZL/i1BDaKKrG+q2XDDWXZDGy3Ati/UYbtbu1XpkAm8isgJYiPGOTi
         aBNCAd5l7R4y/dovnqIveHrt8bZePI9D0GE3wgax659jbJxPK2hGhwadcz+jEoFyIdOa
         sj7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5v42B6Asu9c7y2uonyfupy6jjnX4xWboTH68oYuewZ4=;
        b=hZlKkH18YORui9szpkDM+EPiwtNW7lSiwr+8oa40Dd/Ocsw3AZZ2MGAYJbb3uMp8i9
         J/dqIKcEf+TVzpimuF2vu//cFmkyTWzs+jyMFRHDC9dHUdvMCJbrKWbS9B6MwURXoZt2
         sUlnYJq2E7XguGTmNQMrcc5HFPmJEFHA/bP/BZKUXYwUCyUQNk1mFQ4IEuzPYXCxoqWr
         QaqtK/uz3tkZJ7LAklYHKnPWMvC5OC8Qrk4MW4ZyaFbC6DTCx2q2fWUn1AUthj9YveD3
         wubcRqg/q3WVHtTIt+5pXPdg9TrYTWqmW84AmrSl/2XGXPSIGYxXL+1pM61LxLf0gfJe
         Akeg==
X-Gm-Message-State: AOAM530DyI6O4dSzmgorLq2w3NX7asr88/qduHiljMzzKIl2v5p8uvx3
        jcbA2UoJiWiRWh1snPMwfV8=
X-Google-Smtp-Source: ABdhPJyQGkRfkJ3LEpt3uNtUwXswwmqJQKmFXBG6qyN0+GByjeq3ISevVw1s2Z5ApeUVBgsJpquH+A==
X-Received: by 2002:a1c:540a:0:b0:382:aa24:dfc2 with SMTP id i10-20020a1c540a000000b00382aa24dfc2mr23301088wmb.42.1647180470005;
        Sun, 13 Mar 2022 07:07:50 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id c2-20020a056000184200b002037b40de23sm10805172wri.8.2022.03.13.07.07.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Mar 2022 07:07:49 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <bfca62fe-3c09-44d1-1960-65a862bc2aaa@redhat.com>
Date:   Sun, 13 Mar 2022 15:07:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v5 009/104] KVM: x86: Introduce vm_type to
 differentiate default VMs from confidential VMs
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <262b01c1cfe8c1dc6463773eabacfc1d01a3e651.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <262b01c1cfe8c1dc6463773eabacfc1d01a3e651.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Unlike default VMs, confidential VMs (Intel TDX and AMD SEV-ES) don't allow
> some operations (e.g., memory read/write, register state access, etc).
> 
> Introduce vm_type to track the type of the VM to x86 KVM.  Other arch KVMs
> already use vm_type, KVM_INIT_VM accepts vm_type, and x86 KVM callback
> vm_init accepts vm_type.  So follow them.  Further, a different policy can
> be made based on vm_type.  Define KVM_X86_DEFAULT_VM for default VM as
> default and define KVM_X86_TDX_VM for Intel TDX VM.  The wrapper function
> will be defined as "bool is_td(kvm) { return vm_type == VM_TYPE_TDX; }"
> 
> Add a capability KVM_CAP_VM_TYPES to effectively allow device model,
> e.g. qemu, to query what VM types are supported by KVM.  This (introduce a
> new capability and add vm_type) is chosen to align with other arch KVMs
> that have VM types already.  Other arch KVMs uses different name to query
> supported vm types and there is no common name for it, so new name was
> chosen.
> 
> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

> ---
>   Documentation/virt/kvm/api.rst        | 15 +++++++++++++++
>   arch/x86/include/asm/kvm-x86-ops.h    |  1 +
>   arch/x86/include/asm/kvm_host.h       |  2 ++
>   arch/x86/include/uapi/asm/kvm.h       |  3 +++
>   arch/x86/kvm/svm/svm.c                |  6 ++++++
>   arch/x86/kvm/vmx/main.c               |  1 +
>   arch/x86/kvm/vmx/tdx.h                |  6 +-----
>   arch/x86/kvm/vmx/vmx.c                |  5 +++++
>   arch/x86/kvm/vmx/x86_ops.h            |  1 +
>   arch/x86/kvm/x86.c                    |  9 ++++++++-
>   include/uapi/linux/kvm.h              |  1 +
>   tools/arch/x86/include/uapi/asm/kvm.h |  3 +++
>   tools/include/uapi/linux/kvm.h        |  1 +
>   13 files changed, 48 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 9f3172376ec3..b1e142719ec0 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -147,15 +147,30 @@ described as 'basic' will be available.
>   The new VM has no virtual cpus and no memory.
>   You probably want to use 0 as machine type.
>   
> +X86:
> +^^^^
> +
> +Supported vm type can be queried from KVM_CAP_VM_TYPES, which returns the
> +bitmap of supported vm types. The 1-setting of bit @n means vm type with
> +value @n is supported.
> +
> +S390:
> +^^^^^
> +
>   In order to create user controlled virtual machines on S390, check
>   KVM_CAP_S390_UCONTROL and use the flag KVM_VM_S390_UCONTROL as
>   privileged user (CAP_SYS_ADMIN).
>   
> +MIPS:
> +^^^^^
> +
>   To use hardware assisted virtualization on MIPS (VZ ASE) rather than
>   the default trap & emulate implementation (which changes the virtual
>   memory layout to fit in user mode), check KVM_CAP_MIPS_VZ and use the
>   flag KVM_VM_MIPS_VZ.
>   
> +ARM64:
> +^^^^^^
>   
>   On arm64, the physical address size for a VM (IPA Size limit) is limited
>   to 40bits by default. The limit can be configured if the host supports the
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index d39e0de06be2..8125d43d3566 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -18,6 +18,7 @@ KVM_X86_OP_NULL(hardware_unsetup)
>   KVM_X86_OP_NULL(cpu_has_accelerated_tpr)
>   KVM_X86_OP(has_emulated_msr)
>   KVM_X86_OP(vcpu_after_set_cpuid)
> +KVM_X86_OP(is_vm_type_supported)
>   KVM_X86_OP(vm_init)
>   KVM_X86_OP_NULL(vm_destroy)
>   KVM_X86_OP(vcpu_create)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index b61e46743184..8de357a9ad30 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1048,6 +1048,7 @@ struct kvm_x86_msr_filter {
>   #define APICV_INHIBIT_REASON_ABSENT	7
>   
>   struct kvm_arch {
> +	unsigned long vm_type;
>   	unsigned long n_used_mmu_pages;
>   	unsigned long n_requested_mmu_pages;
>   	unsigned long n_max_mmu_pages;
> @@ -1322,6 +1323,7 @@ struct kvm_x86_ops {
>   	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
>   	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
>   
> +	bool (*is_vm_type_supported)(unsigned long vm_type);
>   	unsigned int vm_size;
>   	int (*vm_init)(struct kvm *kvm);
>   	void (*vm_destroy)(struct kvm *kvm);
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index bf6e96011dfe..71a5851475e7 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -525,4 +525,7 @@ struct kvm_pmu_event_filter {
>   #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
>   #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
>   
> +#define KVM_X86_DEFAULT_VM	0
> +#define KVM_X86_TDX_VM		1
> +
>   #endif /* _ASM_X86_KVM_H */
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index fd3a00c892c7..778075b71dc3 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4512,6 +4512,11 @@ static void svm_vm_destroy(struct kvm *kvm)
>   	sev_vm_destroy(kvm);
>   }
>   
> +static bool svm_is_vm_type_supported(unsigned long type)
> +{
> +	return type == KVM_X86_DEFAULT_VM;
> +}
> +
>   static int svm_vm_init(struct kvm *kvm)
>   {
>   	if (!pause_filter_count || !pause_filter_thresh)
> @@ -4539,6 +4544,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>   	.vcpu_free = svm_free_vcpu,
>   	.vcpu_reset = svm_vcpu_reset,
>   
> +	.is_vm_type_supported = svm_is_vm_type_supported,
>   	.vm_size = sizeof(struct kvm_svm),
>   	.vm_init = svm_vm_init,
>   	.vm_destroy = svm_vm_destroy,
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 28a7597d0782..77da926ee505 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -29,6 +29,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.cpu_has_accelerated_tpr = report_flexpriority,
>   	.has_emulated_msr = vmx_has_emulated_msr,
>   
> +	.is_vm_type_supported = vmx_is_vm_type_supported,
>   	.vm_size = sizeof(struct kvm_vmx),
>   	.vm_init = vmx_vm_init,
>   
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index d448e019602c..616fbf79b129 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -15,11 +15,7 @@ struct vcpu_tdx {
>   
>   static inline bool is_td(struct kvm *kvm)
>   {
> -	/*
> -	 * TDX VM type isn't defined yet.
> -	 * return kvm->arch.vm_type == KVM_X86_TDX_VM;
> -	 */
> -	return false;
> +	return kvm->arch.vm_type == KVM_X86_TDX_VM;
>   }
>   
>   static inline bool is_td_vcpu(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 7838cd177f0e..3c7b3f245fee 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7079,6 +7079,11 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
>   	return err;
>   }
>   
> +bool vmx_is_vm_type_supported(unsigned long type)
> +{
> +	return type == KVM_X86_DEFAULT_VM;
> +}
> +
>   #define L1TF_MSG_SMT "L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
>   #define L1TF_MSG_L1D "L1TF CPU bug present and virtualization mitigation disabled, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
>   
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 1bad27e592b5..f7327bc73be0 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -25,6 +25,7 @@ void vmx_hardware_unsetup(void);
>   int vmx_hardware_enable(void);
>   void vmx_hardware_disable(void);
>   bool report_flexpriority(void);
> +bool vmx_is_vm_type_supported(unsigned long type);
>   int vmx_vm_init(struct kvm *kvm);
>   int vmx_vcpu_create(struct kvm_vcpu *vcpu);
>   int vmx_vcpu_pre_run(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index aa2942060154..f6438750d190 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4344,6 +4344,11 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   			r = sizeof(struct kvm_xsave);
>   		break;
>   	}
> +	case KVM_CAP_VM_TYPES:
> +		r = BIT(KVM_X86_DEFAULT_VM);
> +		if (static_call(kvm_x86_is_vm_type_supported)(KVM_X86_TDX_VM))
> +			r |= BIT(KVM_X86_TDX_VM);
> +		break;
>   	default:
>   		break;
>   	}
> @@ -11583,9 +11588,11 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	int ret;
>   	unsigned long flags;
>   
> -	if (type)
> +	if (!static_call(kvm_x86_is_vm_type_supported)(type))
>   		return -EINVAL;
>   
> +	kvm->arch.vm_type = type;
> +
>   	ret = kvm_page_track_init(kvm);
>   	if (ret)
>   		return ret;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 507ee1f2aa96..bb3e29770f76 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1135,6 +1135,7 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_XSAVE2 208
>   #define KVM_CAP_SYS_ATTRIBUTES 209
>   #define KVM_CAP_PPC_AIL_MODE_3 210
> +#define KVM_CAP_VM_TYPES 21
>   
>   #ifdef KVM_CAP_IRQ_ROUTING
>   
> diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
> index bf6e96011dfe..71a5851475e7 100644
> --- a/tools/arch/x86/include/uapi/asm/kvm.h
> +++ b/tools/arch/x86/include/uapi/asm/kvm.h
> @@ -525,4 +525,7 @@ struct kvm_pmu_event_filter {
>   #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
>   #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
>   
> +#define KVM_X86_DEFAULT_VM	0
> +#define KVM_X86_TDX_VM		1
> +
>   #endif /* _ASM_X86_KVM_H */
> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
> index 507ee1f2aa96..1a99d0aae852 100644
> --- a/tools/include/uapi/linux/kvm.h
> +++ b/tools/include/uapi/linux/kvm.h
> @@ -1135,6 +1135,7 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_XSAVE2 208
>   #define KVM_CAP_SYS_ATTRIBUTES 209
>   #define KVM_CAP_PPC_AIL_MODE_3 210
> +#define KVM_CAP_VM_TYPES 211
>   
>   #ifdef KVM_CAP_IRQ_ROUTING
>   

