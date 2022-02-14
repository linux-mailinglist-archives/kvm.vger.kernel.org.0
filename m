Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31D414B5C37
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 22:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiBNVEW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 16:04:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiBNVEV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 16:04:21 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21AECD227B
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 13:04:12 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id i21so29874019pfd.13
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 13:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QmR8ET/8mF18hhzLHuhApvafpsOEJwyM+qUdgUyNHII=;
        b=ON9HIiXV7ARffVBW6EjjbG3Cm/EAiUiO2190iZr7hGzBjDX2TFzVJuA0ZFNLdZD6n7
         cg0S4JA19XI6y2QwhRSfAbu+mfNIWyvxhczSlzfpC+FAzoM0zUhPGy2nQgjT2u7mcouj
         PFPfhxXnTXmFA4h5PMi5mVp06FhIbBH42T7L9nJsWFyJ3ZYesdlPgYZCAgU4eK/RFim6
         YEAWP9hJNt4513a9WmziML16H1PVK0PdFEivU/2InKnv4okDQz5QNQme45qQOOXD/DSf
         G0eT/S3zS7OoPJPQCVIeevvxOIrvu+jzbilBYUFP1ncLyUPoCaCymcK2SSplhCEzNBo5
         51Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QmR8ET/8mF18hhzLHuhApvafpsOEJwyM+qUdgUyNHII=;
        b=1NR4xcNbkyNz2uiL8U6lhcwqZE/S54RSt7nVjNxAPk1+YfrVom3+9C1DpK8uryFOnZ
         +uL26w4cAhoJ7+b3PCa9DcH/E5q/eSUqaAVptBJ4vV5CODiFQGDGkCU2VC5sIDIWdjJt
         M+J58M9jDUmYadWKx5tTf1scC641jkyY84HhLnWI4YH86YK3/MjsjnHmiTF2oENAvsPf
         pAVHMD80hG88co/56dKN6n7VaVkIIe+mN+GdOjJO2pvJKgU1HsQNKhxYMkGSDFrWUQ8T
         aNvqk5DZ0ifie7MzDuyqQ4UBgABViRvGxFLSUAxJvM4J6/gM32l8THUWMRtI+l6kDVxC
         zEDw==
X-Gm-Message-State: AOAM532NWd5oiBUpvdktXON+iO4JYGg7oc5+FZnSblLhA1M8KU+URy6t
        pr8sWGRnHoKcMoBvhmcOxhbW+Z+HpdYMFQ==
X-Google-Smtp-Source: ABdhPJxmIzovFf4+Mzf28aNOM1P1VbIrgX+NRfvbVfJy8k7dDZvC3hEYWXI7/hkixyV1WHmiubeqAw==
X-Received: by 2002:a63:fe02:: with SMTP id p2mr520432pgh.193.1644868387438;
        Mon, 14 Feb 2022 11:53:07 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c17sm39621251pfv.68.2022.02.14.11.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 11:53:06 -0800 (PST)
Date:   Mon, 14 Feb 2022 19:53:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Dunn <daviddunn@google.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, like.xu.linux@gmail.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH v6 1/3] KVM: x86: Provide per VM capability for disabling
 PMU virtualization
Message-ID: <YgqzHyXzede5YB/f@google.com>
References: <20220209172945.1495014-1-daviddunn@google.com>
 <20220209172945.1495014-2-daviddunn@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209172945.1495014-2-daviddunn@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 09, 2022, David Dunn wrote:
> KVM_CAP_PMU_DISABLE is used to disable PMU virtualization on individual
> x86 VMs.  PMU configuration must be done prior to creating VCPUs.

Please use imperative mood to state what the patch is doing/adding, as opposed to
describing the ABI.  E.g.

  Add a new capability, KVM_CAP_PMU_CAPABILITY, that takes a bitmask of
  settings/features to allow userspace to configure PMU virtualization on
  a per-VM basis.  For now, support a single flag, KVM_CAP_PMU_DISABLE,
  to allow disabling PMU virtualization for a VM even when KVM is configured
  with enable_pmu=true a module level.

  To keep KVM simple, disallow changing VM's PMU configuration after vCPUs
  have been created.

> To enable future extension, KVM_CAP_PMU_CAPABILITY reports available
> settings via bitmask when queried via check_extension.

This can be omitted, the motivation is self-explanatory and the pattern is well
established.  The desire for future expensions can be alluded to by describing
KVM_CAP_PMU_DISABLE as the first/initial flag or whatever.

> For VMs that have PMU virtualization disabled, usermode will need to
> clear CPUID leaf 0xA to notify guests.

Eh, I'd just omit this, it won't age well if there's more that userspace "needs"
to do, and strictly speaking KVM doesn't care if userspace presents a bogus vCPU
model to the guest.

> Signed-off-by: David Dunn <daviddunn@google.com>
> ---
>  Documentation/virt/kvm/api.rst  | 22 ++++++++++++++++++++++
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/svm/pmu.c          |  2 +-
>  arch/x86/kvm/vmx/pmu_intel.c    |  2 +-
>  arch/x86/kvm/x86.c              | 12 ++++++++++++
>  include/uapi/linux/kvm.h        |  4 ++++
>  tools/include/uapi/linux/kvm.h  |  4 ++++
>  7 files changed, 45 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index a4267104db50..df836965b347 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7561,3 +7561,25 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
>  of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
>  the hypercalls whose corresponding bit is in the argument, and return
>  ENOSYS for the others.
> +
> +8.35 KVM_CAP_PMU_CAPABILITY
> +---------------------------
> +
> +:Capability KVM_CAP_PMU_CAPABILITY
> +:Architectures: x86
> +:Type: vm
> +:Parameters: arg[0] is bitmask of PMU virtualization capabilities.
> +:Returns 0 on success, -EINVAL when arg[0] contains invalid bits
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
> +this capability will disable PMU virtualization for that VM.  Usermode
> +should adjust CPUID leaf 0xA to reflect that the PMU is disabled.
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c371ee7e45f7..f832cd0f9b27 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1232,6 +1232,7 @@ struct kvm_arch {
>  	hpa_t	hv_root_tdp;
>  	spinlock_t hv_root_tdp_lock;
>  #endif
> +	bool enable_pmu;
>  };
>  
>  struct kvm_vm_stat {
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index 5aa45f13b16d..d4de52409335 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -101,7 +101,7 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
>  {
>  	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
>  
> -	if (!enable_pmu)
> +	if (!vcpu->kvm->arch.enable_pmu)
>  		return NULL;
>  
>  	switch (msr) {
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 03fab48b149c..4e5b1eeeb77c 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -487,7 +487,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>  	pmu->reserved_bits = 0xffffffff00200000ull;
>  
>  	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
> -	if (!entry || !enable_pmu)
> +	if (!entry || !vcpu->kvm->arch.enable_pmu)
>  		return;
>  	eax.full = entry->eax;
>  	edx.full = entry->edx;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6f69f3e3635e..c35a6a193bf4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4329,6 +4329,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		if (r < sizeof(struct kvm_xsave))
>  			r = sizeof(struct kvm_xsave);
>  		break;
> +	case KVM_CAP_PMU_CAPABILITY:
> +		r = enable_pmu ? KVM_CAP_PMU_MASK : 0;
> +		break;
>  	}
>  	default:
>  		break;
> @@ -6003,6 +6006,14 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		kvm->arch.exit_on_emulation_error = cap->args[0];
>  		r = 0;
>  		break;
> +	case KVM_CAP_PMU_CAPABILITY:
> +		r = -EINVAL;
> +		if (!enable_pmu || kvm->created_vcpus > 0 ||

This needs to take kvm->lock when checking kvm->created_vcpus and setting the
per-VM enable_pmu.  And preferred kernel style is to omit the "> 0" when checking
for a non-zero value.  Despite being an int, created_vcpus can't go negative.

> +		    cap->args[0] & ~KVM_CAP_PMU_MASK)
> +			break;
> +		kvm->arch.enable_pmu = !(cap->args[0] & KVM_CAP_PMU_DISABLE);
> +		r = 0;
> +		break;
>  	default:
>  		r = -EINVAL;
>  		break;
> @@ -11630,6 +11641,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
>  
>  	kvm->arch.guest_can_read_msr_platform_info = true;
> +	kvm->arch.enable_pmu = enable_pmu;
>  
>  #if IS_ENABLED(CONFIG_HYPERV)
>  	spin_lock_init(&kvm->arch.hv_root_tdp_lock);
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 5191b57e1562..cf6774cc18ef 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1134,6 +1134,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_VM_GPA_BITS 207
>  #define KVM_CAP_XSAVE2 208
>  #define KVM_CAP_SYS_ATTRIBUTES 209
> +#define KVM_CAP_PMU_CAPABILITY 210
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> @@ -1970,6 +1971,9 @@ struct kvm_dirty_gfn {
>  #define KVM_BUS_LOCK_DETECTION_OFF             (1 << 0)
>  #define KVM_BUS_LOCK_DETECTION_EXIT            (1 << 1)
>  
> +#define KVM_CAP_PMU_DISABLE                    (1 << 0)
> +#define KVM_CAP_PMU_MASK                       (KVM_CAP_PMU_DISABLE)

KVM_CAP_PMU_MASK shouldn't be in the uapi header, expanding it in the future could
theoretically break userspace
