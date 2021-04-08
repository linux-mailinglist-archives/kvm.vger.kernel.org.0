Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D878235816F
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 13:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbhDHLOf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 07:14:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47644 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230434AbhDHLOe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Apr 2021 07:14:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617880462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SgTyrhc32KLBJDA+SbH8Gk99friZvtGTdnHubUQi898=;
        b=JO2RVWAJSnr8OXcPiY/e7rHrPIVrYPJQ74LL/10dj6+080H0h2EPVFrzmJKo3fJFW4Af5T
        7/GPZJz27weq1b9ASwNhZ5IpTmSlgVTcbX4WcUYjvhRd8R9GvDQwMRVWNXLtFhLOiqOR7u
        OE+YbnymDJtWrUbrZLbXfiu2Wl/OJrM=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-7Psptm6dOwSbnbyEWIvuYg-1; Thu, 08 Apr 2021 07:14:21 -0400
X-MC-Unique: 7Psptm6dOwSbnbyEWIvuYg-1
Received: by mail-ej1-f72.google.com with SMTP id h19so694203ejk.8
        for <kvm@vger.kernel.org>; Thu, 08 Apr 2021 04:14:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=SgTyrhc32KLBJDA+SbH8Gk99friZvtGTdnHubUQi898=;
        b=gb4NJbeIXvqW5qQZ6Qu1VO6QWtus3n57iUPH68vzfQcPb+CVGlE9eovuf1Wc+3m2gN
         IqCcWF4GA4054r5aInb9dN4qyDZ5aLHJUeKLtC5SDB+rfIvFuuYX9BQds3FFkR3C6SdH
         K89tURk5XpaRbCW826ZMev89KCYH1c9WJaDqkZM/h840H+p6wYAsBmbnIQlc6Juh2Jte
         NGQBQmHXyiXARk6zYL2dX5KFaVBCT9IiuB+tEbSBe6VHF5j5iwu05Yog6RGzJRvlQjEW
         sDzhikOwJ4+S1pB7PG2Ut8GpzckaNNygBMbXZ+K3sWEO+gsJgLvKsaKUz8gx1Di4wUQY
         FxLw==
X-Gm-Message-State: AOAM5321VpNGHy7u1B0Sd7izAQyFRzIo8z8FAfdWgT23VUQwCXMAMgsZ
        0UFCzETc3+zcq3wln43kbEO5P4geOkDlw10vdNAC7Zr+im6KPJiGJ4AhglE+z3p07O8/cLNwOzm
        pScGa8uBJwY88
X-Received: by 2002:a05:6402:3486:: with SMTP id v6mr10527176edc.109.1617880459879;
        Thu, 08 Apr 2021 04:14:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJysuAX0tgEU7bqsEejcMq5OuovIMNAyQw9XWqfPWIR8uA7KERQ3QxOlViHUT6mqJlnxLjtwxw==
X-Received: by 2002:a05:6402:3486:: with SMTP id v6mr10527139edc.109.1617880459659;
        Thu, 08 Apr 2021 04:14:19 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id ka11sm5944217ejb.43.2021.04.08.04.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 04:14:19 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vineeth Pillai <viremana@linux.microsoft.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 3/7] KVM: x86: hyper-v: Move the remote TLB flush logic
 out of vmx
In-Reply-To: <bb757810c7b7c27ebbefe344c20b99d67524ee29.1617804573.git.viremana@linux.microsoft.com>
References: <cover.1617804573.git.viremana@linux.microsoft.com>
 <bb757810c7b7c27ebbefe344c20b99d67524ee29.1617804573.git.viremana@linux.microsoft.com>
Date:   Thu, 08 Apr 2021 13:14:18 +0200
Message-ID: <87im4xav05.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vineeth Pillai <viremana@linux.microsoft.com> writes:

> Currently the remote TLB flush logic is specific to VMX.
> Move it to a common place so that SVM can use it as well.
>
> Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 15 +++++
>  arch/x86/kvm/hyperv.c           | 89 ++++++++++++++++++++++++++++++
>  arch/x86/kvm/hyperv.h           | 12 ++++
>  arch/x86/kvm/vmx/vmx.c          | 97 +++------------------------------
>  arch/x86/kvm/vmx/vmx.h          | 10 ----
>  5 files changed, 123 insertions(+), 100 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 877a4025d8da..336716124b7e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -530,6 +530,12 @@ struct kvm_vcpu_hv {
>  	struct kvm_vcpu_hv_stimer stimer[HV_SYNIC_STIMER_COUNT];
>  	DECLARE_BITMAP(stimer_pending_bitmap, HV_SYNIC_STIMER_COUNT);
>  	cpumask_t tlb_flush;
> +	/*
> +	 * Two Dimensional paging CR3
> +	 * EPTP for Intel
> +	 * nCR3 for AMD
> +	 */
> +	u64 tdp_pointer;
>  };

'struct kvm_vcpu_hv' is only allocated when we emulate Hyper-V in KVM
(run Windows/Hyper-V guests on top of KVM). Remote TLB flush is used
when we run KVM on Hyper-V and this is a very different beast. Let's not
mix these things together. I understand that some unification is needed
to bring the AMD specific feature but let's do it differently.

E.g. 'ept_pointer' and friends from 'struct kvm_vmx' can just go to
'struct kvm_vcpu_arch' (in case they really need to be unified).

>  
>  /* Xen HVM per vcpu emulation context */
> @@ -884,6 +890,12 @@ struct kvm_hv_syndbg {
>  	u64 options;
>  };
>  
> +enum tdp_pointers_status {
> +	TDP_POINTERS_CHECK = 0,
> +	TDP_POINTERS_MATCH = 1,
> +	TDP_POINTERS_MISMATCH = 2
> +};
> +
>  /* Hyper-V emulation context */
>  struct kvm_hv {
>  	struct mutex hv_lock;
> @@ -908,6 +920,9 @@ struct kvm_hv {
>  
>  	struct hv_partition_assist_pg *hv_pa_pg;
>  	struct kvm_hv_syndbg hv_syndbg;
> +
> +	enum tdp_pointers_status tdp_pointers_match;
> +	spinlock_t tdp_pointer_lock;
>  };
>  
>  struct msr_bitmap_range {
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 58fa8c029867..c5bec598bf28 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -32,6 +32,7 @@
>  #include <linux/eventfd.h>
>  
>  #include <asm/apicdef.h>
> +#include <asm/mshyperv.h>
>  #include <trace/events/kvm.h>
>  
>  #include "trace.h"
> @@ -913,6 +914,8 @@ static int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu)
>  	for (i = 0; i < ARRAY_SIZE(hv_vcpu->stimer); i++)
>  		stimer_init(&hv_vcpu->stimer[i], i);
>  
> +	hv_vcpu->tdp_pointer = INVALID_PAGE;
> +
>  	hv_vcpu->vp_index = kvm_vcpu_get_idx(vcpu);
>  
>  	return 0;
> @@ -1960,6 +1963,7 @@ void kvm_hv_init_vm(struct kvm *kvm)
>  {
>  	struct kvm_hv *hv = to_kvm_hv(kvm);
>  
> +	spin_lock_init(&hv->tdp_pointer_lock);
>  	mutex_init(&hv->hv_lock);
>  	idr_init(&hv->conn_to_evt);
>  }
> @@ -2180,3 +2184,88 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  
>  	return 0;
>  }
> +
> +/* check_tdp_pointer() should be under protection of tdp_pointer_lock. */
> +static void check_tdp_pointer_match(struct kvm *kvm)
> +{
> +	u64 tdp_pointer = INVALID_PAGE;
> +	bool valid_tdp = false;
> +	struct kvm_vcpu *vcpu;
> +	int i;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		if (!valid_tdp) {
> +			tdp_pointer = to_hv_vcpu(vcpu)->tdp_pointer;
> +			valid_tdp = true;
> +			continue;
> +		}
> +
> +		if (tdp_pointer != to_hv_vcpu(vcpu)->tdp_pointer) {
> +			to_kvm_hv(kvm)->tdp_pointers_match
> +				= TDP_POINTERS_MISMATCH;
> +			return;
> +		}
> +	}
> +
> +	to_kvm_hv(kvm)->tdp_pointers_match = TDP_POINTERS_MATCH;
> +}
> +
> +static int kvm_fill_hv_flush_list_func(struct hv_guest_mapping_flush_list *flush,
> +		void *data)
> +{
> +	struct kvm_tlb_range *range = data;
> +
> +	return hyperv_fill_flush_guest_mapping_list(flush, range->start_gfn,
> +			range->pages);
> +}
> +
> +static inline int __hv_remote_flush_tlb_with_range(struct kvm *kvm,
> +		struct kvm_vcpu *vcpu, struct kvm_tlb_range *range)
> +{
> +	u64 tdp_pointer = to_hv_vcpu(vcpu)->tdp_pointer;
> +
> +	/*
> +	 * FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE hypercall needs address
> +	 * of the base of EPT PML4 table, strip off EPT configuration
> +	 * information.
> +	 */
> +	if (range)
> +		return hyperv_flush_guest_mapping_range(tdp_pointer & PAGE_MASK,
> +				kvm_fill_hv_flush_list_func, (void *)range);
> +	else
> +		return hyperv_flush_guest_mapping(tdp_pointer & PAGE_MASK);
> +}
> +
> +int kvm_hv_remote_flush_tlb_with_range(struct kvm *kvm,
> +		struct kvm_tlb_range *range)
> +{
> +	struct kvm_vcpu *vcpu;
> +	int ret = 0, i;
> +
> +	spin_lock(&to_kvm_hv(kvm)->tdp_pointer_lock);
> +
> +	if (to_kvm_hv(kvm)->tdp_pointers_match == TDP_POINTERS_CHECK)
> +		check_tdp_pointer_match(kvm);
> +
> +	if (to_kvm_hv(kvm)->tdp_pointers_match != TDP_POINTERS_MATCH) {
> +		kvm_for_each_vcpu(i, vcpu, kvm) {
> +			/* If tdp_pointer is invalid pointer, bypass flush request. */
> +			if (VALID_PAGE(to_hv_vcpu(vcpu)->tdp_pointer))
> +				ret |= __hv_remote_flush_tlb_with_range(
> +					kvm, vcpu, range);
> +		}
> +	} else {
> +		ret = __hv_remote_flush_tlb_with_range(kvm,
> +				kvm_get_vcpu(kvm, 0), range);
> +	}
> +
> +	spin_unlock(&to_kvm_hv(kvm)->tdp_pointer_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(kvm_hv_remote_flush_tlb_with_range);
> +
> +int kvm_hv_remote_flush_tlb(struct kvm *kvm)
> +{
> +	return kvm_hv_remote_flush_tlb_with_range(kvm, NULL);
> +}
> +EXPORT_SYMBOL_GPL(kvm_hv_remote_flush_tlb);
> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> index e951af1fcb2c..225ede22a815 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -141,4 +141,16 @@ int kvm_vm_ioctl_hv_eventfd(struct kvm *kvm, struct kvm_hyperv_eventfd *args);
>  int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  		     struct kvm_cpuid_entry2 __user *entries);
>  
> +static inline void kvm_update_arch_tdp_pointer(struct kvm *kvm,
> +		struct kvm_vcpu *vcpu, u64 tdp_pointer)
> +{
> +	spin_lock(&to_kvm_hv(kvm)->tdp_pointer_lock);
> +	to_hv_vcpu(vcpu)->tdp_pointer = tdp_pointer;
> +	to_kvm_hv(kvm)->tdp_pointers_match = TDP_POINTERS_CHECK;
> +	spin_unlock(&to_kvm_hv(kvm)->tdp_pointer_lock);
> +}
> +
> +int kvm_hv_remote_flush_tlb(struct kvm *kvm);
> +int kvm_hv_remote_flush_tlb_with_range(struct kvm *kvm,
> +		struct kvm_tlb_range *range);
>  #endif
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 50810d471462..67f607319eb7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -62,6 +62,7 @@
>  #include "vmcs12.h"
>  #include "vmx.h"
>  #include "x86.h"
> +#include "hyperv.h"
>  
>  MODULE_AUTHOR("Qumranet");
>  MODULE_LICENSE("GPL");
> @@ -472,83 +473,6 @@ static const u32 vmx_uret_msrs_list[] = {
>  static bool __read_mostly enlightened_vmcs = true;
>  module_param(enlightened_vmcs, bool, 0444);
>  
> -/* check_ept_pointer() should be under protection of ept_pointer_lock. */
> -static void check_ept_pointer_match(struct kvm *kvm)
> -{
> -	struct kvm_vcpu *vcpu;
> -	u64 tmp_eptp = INVALID_PAGE;
> -	int i;
> -
> -	kvm_for_each_vcpu(i, vcpu, kvm) {
> -		if (!VALID_PAGE(tmp_eptp)) {
> -			tmp_eptp = to_vmx(vcpu)->ept_pointer;
> -		} else if (tmp_eptp != to_vmx(vcpu)->ept_pointer) {
> -			to_kvm_vmx(kvm)->ept_pointers_match
> -				= EPT_POINTERS_MISMATCH;
> -			return;
> -		}
> -	}
> -
> -	to_kvm_vmx(kvm)->ept_pointers_match = EPT_POINTERS_MATCH;
> -}
> -
> -static int kvm_fill_hv_flush_list_func(struct hv_guest_mapping_flush_list *flush,
> -		void *data)
> -{
> -	struct kvm_tlb_range *range = data;
> -
> -	return hyperv_fill_flush_guest_mapping_list(flush, range->start_gfn,
> -			range->pages);
> -}
> -
> -static inline int __hv_remote_flush_tlb_with_range(struct kvm *kvm,
> -		struct kvm_vcpu *vcpu, struct kvm_tlb_range *range)
> -{
> -	u64 ept_pointer = to_vmx(vcpu)->ept_pointer;
> -
> -	/*
> -	 * FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE hypercall needs address
> -	 * of the base of EPT PML4 table, strip off EPT configuration
> -	 * information.
> -	 */
> -	if (range)
> -		return hyperv_flush_guest_mapping_range(ept_pointer & PAGE_MASK,
> -				kvm_fill_hv_flush_list_func, (void *)range);
> -	else
> -		return hyperv_flush_guest_mapping(ept_pointer & PAGE_MASK);
> -}
> -
> -static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
> -		struct kvm_tlb_range *range)
> -{
> -	struct kvm_vcpu *vcpu;
> -	int ret = 0, i;
> -
> -	spin_lock(&to_kvm_vmx(kvm)->ept_pointer_lock);
> -
> -	if (to_kvm_vmx(kvm)->ept_pointers_match == EPT_POINTERS_CHECK)
> -		check_ept_pointer_match(kvm);
> -
> -	if (to_kvm_vmx(kvm)->ept_pointers_match != EPT_POINTERS_MATCH) {
> -		kvm_for_each_vcpu(i, vcpu, kvm) {
> -			/* If ept_pointer is invalid pointer, bypass flush request. */
> -			if (VALID_PAGE(to_vmx(vcpu)->ept_pointer))
> -				ret |= __hv_remote_flush_tlb_with_range(
> -					kvm, vcpu, range);
> -		}
> -	} else {
> -		ret = __hv_remote_flush_tlb_with_range(kvm,
> -				kvm_get_vcpu(kvm, 0), range);
> -	}
> -
> -	spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
> -	return ret;
> -}
> -static int hv_remote_flush_tlb(struct kvm *kvm)
> -{
> -	return hv_remote_flush_tlb_with_range(kvm, NULL);
> -}
> -
>  static int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
>  {
>  	struct hv_enlightened_vmcs *evmcs;
> @@ -3115,13 +3039,10 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
>  		eptp = construct_eptp(vcpu, pgd, pgd_level);
>  		vmcs_write64(EPT_POINTER, eptp);
>  
> -		if (kvm_x86_ops.tlb_remote_flush) {
> -			spin_lock(&to_kvm_vmx(kvm)->ept_pointer_lock);
> -			to_vmx(vcpu)->ept_pointer = eptp;
> -			to_kvm_vmx(kvm)->ept_pointers_match
> -				= EPT_POINTERS_CHECK;
> -			spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
> -		}
> +#if IS_ENABLED(CONFIG_HYPERV)
> +		if (kvm_x86_ops.tlb_remote_flush)
> +			kvm_update_arch_tdp_pointer(kvm, vcpu, eptp);
> +#endif
>  
>  		if (!enable_unrestricted_guest && !is_paging(vcpu))
>  			guest_cr3 = to_kvm_vmx(kvm)->ept_identity_map_addr;
> @@ -6989,8 +6910,6 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>  	vmx->pi_desc.nv = POSTED_INTR_VECTOR;
>  	vmx->pi_desc.sn = 1;
>  
> -	vmx->ept_pointer = INVALID_PAGE;
> -
>  	return 0;
>  
>  free_vmcs:
> @@ -7007,8 +6926,6 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>  
>  static int vmx_vm_init(struct kvm *kvm)
>  {
> -	spin_lock_init(&to_kvm_vmx(kvm)->ept_pointer_lock);
> -
>  	if (!ple_gap)
>  		kvm->arch.pause_in_guest = true;
>  
> @@ -7818,9 +7735,9 @@ static __init int hardware_setup(void)
>  #if IS_ENABLED(CONFIG_HYPERV)
>  	if (ms_hyperv.nested_features & HV_X64_NESTED_GUEST_MAPPING_FLUSH
>  	    && enable_ept) {
> -		vmx_x86_ops.tlb_remote_flush = hv_remote_flush_tlb;
> +		vmx_x86_ops.tlb_remote_flush = kvm_hv_remote_flush_tlb;
>  		vmx_x86_ops.tlb_remote_flush_with_range =
> -				hv_remote_flush_tlb_with_range;
> +				kvm_hv_remote_flush_tlb_with_range;
>  	}
>  #endif
>  
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 89da5e1251f1..d2e2ab46f5bb 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -325,7 +325,6 @@ struct vcpu_vmx {
>  	 */
>  	u64 msr_ia32_feature_control;
>  	u64 msr_ia32_feature_control_valid_bits;
> -	u64 ept_pointer;
>  
>  	struct pt_desc pt_desc;
>  	struct lbr_desc lbr_desc;
> @@ -338,21 +337,12 @@ struct vcpu_vmx {
>  	} shadow_msr_intercept;
>  };
>  
> -enum ept_pointers_status {
> -	EPT_POINTERS_CHECK = 0,
> -	EPT_POINTERS_MATCH = 1,
> -	EPT_POINTERS_MISMATCH = 2
> -};
> -
>  struct kvm_vmx {
>  	struct kvm kvm;
>  
>  	unsigned int tss_addr;
>  	bool ept_identity_pagetable_done;
>  	gpa_t ept_identity_map_addr;
> -
> -	enum ept_pointers_status ept_pointers_match;
> -	spinlock_t ept_pointer_lock;
>  };
>  
>  bool nested_vmx_allowed(struct kvm_vcpu *vcpu);

-- 
Vitaly

