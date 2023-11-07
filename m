Return-Path: <kvm+bounces-1049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 709527E4837
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 19:26:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 250922810C5
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 18:26:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6415358B2;
	Tue,  7 Nov 2023 18:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OXQ5wmZB"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28258328BC
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 18:26:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F63119
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 10:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699381560;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hAEg3T4lLN4MqpPr07u9aN3J6nLQu4xBSGX7d7hLJvk=;
	b=OXQ5wmZBrkynEtfNa5mSN0NpW5X+9TwT8Zh+31bbJa6D0ei4EcG0KayX8EK8NVtR8/2Voc
	UkDpwMO7dfn3WpyMMXungj5OvIoKbDPYQ5wjKsJs3t4oVyEZnXIZUwv1/vENSfoAxks3f5
	q4PM7Tr4l5t0YcF67rTZnUyWbRscnBw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-539-E8KA5qQuOPqp7Ubx3uImjw-1; Tue, 07 Nov 2023 13:25:52 -0500
X-MC-Unique: E8KA5qQuOPqp7Ubx3uImjw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-32da8de4833so3097521f8f.3
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 10:25:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699381551; x=1699986351;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hAEg3T4lLN4MqpPr07u9aN3J6nLQu4xBSGX7d7hLJvk=;
        b=rgWuQO+j6PJXLofpbQfWVxOlZLzrzk/cb0H8WA0m7fby/a1IlnBxCgoogKNShG4Y8X
         kTQf5pTWwXLvaDS/oOkYywBlBIPfrmCht1QIXw0+m4Wo3epz81ImS97/vd9bi36SC3oh
         qF4HyzzovpBjGmheZqux30lWLBs2vv5fOijH3mHxdbYjvVOn3aqh3c8wO+18zEb4ikJe
         +et5H1gBqQYXyOZNvlukPtt+L8BqUKwKgM/oqhY2lvBgg/b/axWePt0Sqw42Zrb1vRqv
         5ilxhf2OT10b+eeUQ0r2/d/nKv2EA02YT2cMZd/uIZNTc42649PrGf5aRa67brwMH3qB
         +9Vg==
X-Gm-Message-State: AOJu0Yzqqldxrn3ONjumkNTJpbqo17DKf2pBhfphezKirOtrk/jgtpru
	9W+LttN2V1kENVv89HnEGSvZewUARVpfc8/zaBWQ9p1AChKhO8Fp4JxDxxgpHD809WNeR4VcalE
	ug0P0fN1cqsxZ
X-Received: by 2002:a05:6000:1864:b0:32f:7f32:ed3f with SMTP id d4-20020a056000186400b0032f7f32ed3fmr28316120wri.49.1699381551169;
        Tue, 07 Nov 2023 10:25:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFnlSBU+t7UwfubtUy6tfSYADx1OsxAWaHCk+YxL+JGrJsvCzcGT/w8aJh312F+uBXA+7Ffvw==
X-Received: by 2002:a05:6000:1864:b0:32f:7f32:ed3f with SMTP id d4-20020a056000186400b0032f7f32ed3fmr28316102wri.49.1699381550714;
        Tue, 07 Nov 2023 10:25:50 -0800 (PST)
Received: from starship ([89.237.99.95])
        by smtp.gmail.com with ESMTPSA id e14-20020a5d530e000000b0032daf848f68sm3043924wrv.59.2023.11.07.10.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 10:25:50 -0800 (PST)
Message-ID: <aa040db7f7766e2b84bae55a9e68b81d70051c68.camel@redhat.com>
Subject: Re: [PATCH 10/14] KVM: x86: Make Hyper-V emulation optional
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, Paolo
 Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 07 Nov 2023 20:25:48 +0200
In-Reply-To: <20231025152406.1879274-11-vkuznets@redhat.com>
References: <20231025152406.1879274-1-vkuznets@redhat.com>
	 <20231025152406.1879274-11-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2023-10-25 at 17:24 +0200, Vitaly Kuznetsov wrote:
> Hyper-V emulation in KVM is a fairly big chunk and in some cases it may be
> desirable to not compile it in to reduce module sizes as well as the attack
> surface. Introduce CONFIG_KVM_HYPERV option to make it possible.
> 
> Note, there's room for further nVMX/nSVM code optimizations when
> !CONFIG_KVM_HYPERV, this will be done in follow-up patches.
> 
> Reorganize Makefile a bit so all CONFIG_HYPERV and CONFIG_KVM_HYPERV files
> are grouped together.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  4 +++
>  arch/x86/kvm/Kconfig            | 14 ++++++++
>  arch/x86/kvm/Makefile           | 23 ++++++------
>  arch/x86/kvm/cpuid.c            |  6 ++++
>  arch/x86/kvm/hyperv.h           | 30 ++++++++++++++--
>  arch/x86/kvm/irq_comm.c         |  9 ++++-
>  arch/x86/kvm/svm/hyperv.h       |  7 ++++
>  arch/x86/kvm/vmx/hyperv.h       |  8 +++++
>  arch/x86/kvm/vmx/nested.c       | 15 ++++++++
>  arch/x86/kvm/x86.c              | 62 ++++++++++++++++++++++++---------
>  10 files changed, 147 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 7fb2810f4573..e5b881dda747 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1095,6 +1095,7 @@ enum hv_tsc_page_status {
>  	HV_TSC_PAGE_BROKEN,
>  };
>  
> +#ifdef CONFIG_KVM_HYPERV
>  /* Hyper-V emulation context */
>  struct kvm_hv {
>  	struct mutex hv_lock;
> @@ -1127,6 +1128,7 @@ struct kvm_hv {
>  
>  	struct kvm_hv_syndbg hv_syndbg;
>  };
> +#endif
>  
>  struct msr_bitmap_range {
>  	u32 flags;
> @@ -1349,7 +1351,9 @@ struct kvm_arch {
>  	/* reads protected by irq_srcu, writes by irq_lock */
>  	struct hlist_head mask_notifier_list;
>  
> +#ifdef CONFIG_KVM_HYPERV
>  	struct kvm_hv hyperv;
> +#endif
>  
>  #ifdef CONFIG_KVM_XEN
>  	struct kvm_xen xen;
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 950c12868d30..93930cef9b3b 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -129,6 +129,20 @@ config KVM_SMM
>  
>  	  If unsure, say Y.
>  
> +config KVM_HYPERV
> +	bool "Support for Microsoft Hyper-V emulation"
> +	depends on KVM
> +	default y
> +	help
> +	  Provides KVM support for emulating Microsoft Hyper-V.  This allows KVM
> +	  to expose a subset of the paravirtualized interfaces defined in the
> +	  Hyper-V Hypervisor Top-Level Functional Specification (TLFS):
> +	  https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/reference/tlfs
> +	  These interfaces are required for the correct and performant functioning
> +	  of Windows and Hyper-V guests on KVM.
Looks very good.

> +
> +	  If unsure, say "Y".
> +
>  config KVM_XEN
>  	bool "Support for Xen hypercall interface"
>  	depends on KVM
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index 8ea872401cd6..b97b875ad75f 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -11,32 +11,33 @@ include $(srctree)/virt/kvm/Makefile.kvm
>  
>  kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
>  			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
> -			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o \
> +			   debugfs.o mmu/mmu.o mmu/page_track.o \
>  			   mmu/spte.o
>  
> -ifdef CONFIG_HYPERV
> -kvm-y			+= kvm_onhyperv.o
> -endif
> -
>  kvm-$(CONFIG_X86_64) += mmu/tdp_iter.o mmu/tdp_mmu.o
> +kvm-$(CONFIG_KVM_HYPERV) += hyperv.o
>  kvm-$(CONFIG_KVM_XEN)	+= xen.o
>  kvm-$(CONFIG_KVM_SMM)	+= smm.o
>  
>  kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
> -			   vmx/hyperv.o vmx/hyperv_evmcs.o vmx/nested.o vmx/posted_intr.o
> -kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
> +			   vmx/nested.o vmx/posted_intr.o
>  
> -ifdef CONFIG_HYPERV
> -kvm-intel-y		+= vmx/vmx_onhyperv.o
> -endif
> +kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
>  
>  kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o \
> -			   svm/sev.o svm/hyperv.o
> +			   svm/sev.o
>  
>  ifdef CONFIG_HYPERV
> +kvm-y			+= kvm_onhyperv.o
> +kvm-intel-y		+= vmx/vmx_onhyperv.o vmx/hyperv_evmcs.o
>  kvm-amd-y		+= svm/svm_onhyperv.o
>  endif
>  
> +ifdef CONFIG_KVM_HYPERV
> +kvm-intel-y		+= vmx/hyperv.o vmx/hyperv_evmcs.o
> +kvm-amd-y		+= svm/hyperv.o
> +endif
> +
>  obj-$(CONFIG_KVM)	+= kvm.o
>  obj-$(CONFIG_KVM_INTEL)	+= kvm-intel.o
>  obj-$(CONFIG_KVM_AMD)	+= kvm-amd.o

This also looks much better.

> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 464b23ac5f93..da8e0873f63a 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -314,11 +314,15 @@ EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
>  
>  static bool kvm_cpuid_has_hyperv(struct kvm_cpuid_entry2 *entries, int nent)
>  {
> +#ifdef CONFIG_KVM_HYPERV
>  	struct kvm_cpuid_entry2 *entry;
>  
>  	entry = cpuid_entry2_find(entries, nent, HYPERV_CPUID_INTERFACE,
>  				  KVM_CPUID_INDEX_NOT_SIGNIFICANT);
>  	return entry && entry->eax == HYPERV_CPUID_SIGNATURE_EAX;
> +#else
> +	return false;
> +#endif
>  }
>  
>  static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> @@ -433,11 +437,13 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
>  		return 0;
>  	}
>  
> +#ifdef CONFIG_KVM_HYPERV
>  	if (kvm_cpuid_has_hyperv(e2, nent)) {
>  		r = kvm_hv_vcpu_init(vcpu);
>  		if (r)
>  			return r;
>  	}
> +#endif
>  
>  	r = kvm_check_cpuid(vcpu, e2, nent);
>  	if (r)
> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> index 75dcbe598fbc..5c5ec7015136 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -24,6 +24,8 @@
>  #include <linux/kvm_host.h>
>  #include "x86.h"
>  
> +#ifdef CONFIG_KVM_HYPERV
> +
>  /* "Hv#1" signature */
>  #define HYPERV_CPUID_SIGNATURE_EAX 0x31237648
>  
> @@ -259,5 +261,29 @@ static inline void kvm_hv_nested_transtion_tlb_flush(struct kvm_vcpu *vcpu, bool
>  }
>  
>  int kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu);
> -
> -#endif
> +#else /* CONFIG_KVM_HYPERV */
> +static inline void kvm_hv_setup_tsc_page(struct kvm *kvm,
> +					 struct pvclock_vcpu_time_info *hv_clock) {}
> +static inline void kvm_hv_request_tsc_page_update(struct kvm *kvm) {}
> +static inline void kvm_hv_init_vm(struct kvm *kvm) {}
> +static inline void kvm_hv_destroy_vm(struct kvm *kvm) {}
> +static inline int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu) { return 0; }
> +static inline void kvm_hv_vcpu_uninit(struct kvm_vcpu *vcpu) {}
> +static inline bool kvm_hv_hypercall_enabled(struct kvm_vcpu *vcpu) { return false; }
> +static inline int kvm_hv_hypercall(struct kvm_vcpu *vcpu) { return HV_STATUS_ACCESS_DENIED; }
> +static inline void kvm_hv_vcpu_purge_flush_tlb(struct kvm_vcpu *vcpu) {}
> +static inline void kvm_hv_free_pa_page(struct kvm *kvm) {}
> +static inline bool kvm_hv_synic_has_vector(struct kvm_vcpu *vcpu, int vector) { return false; }
> +static inline bool kvm_hv_synic_auto_eoi_set(struct kvm_vcpu *vcpu, int vector) { return false; }
> +static inline void kvm_hv_synic_send_eoi(struct kvm_vcpu *vcpu, int vector) {}
> +static inline bool kvm_hv_invtsc_suppressed(struct kvm_vcpu *vcpu) { return false; }
> +static inline void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu, bool hyperv_enabled) {}
> +static inline bool kvm_hv_has_stimer_pending(struct kvm_vcpu *vcpu) { return false; }
> +static inline bool kvm_hv_is_tlb_flush_hcall(struct kvm_vcpu *vcpu) { return false; }
> +static inline bool guest_hv_cpuid_has_l2_tlb_flush(struct kvm_vcpu *vcpu) { return false; }
> +static inline int kvm_hv_verify_vp_assist(struct kvm_vcpu *vcpu) { return 0; }
> +static inline u32 kvm_hv_get_vpindex(struct kvm_vcpu *vcpu) { return vcpu->vcpu_idx; }
> +static inline void kvm_hv_nested_transtion_tlb_flush(struct kvm_vcpu *vcpu, bool tdp_enabled) {}
> +#endif /* CONFIG_KVM_HYPERV */
> +
> +#endif /* __ARCH_X86_KVM_HYPERV_H__ */


> diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
> index 16d076a1b91a..68f3f6c26046 100644
> --- a/arch/x86/kvm/irq_comm.c
> +++ b/arch/x86/kvm/irq_comm.c
> @@ -144,7 +144,7 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
>  	return kvm_irq_delivery_to_apic(kvm, NULL, &irq, NULL);
>  }
>  
> -
> +#ifdef CONFIG_KVM_HYPERV
>  static int kvm_hv_set_sint(struct kvm_kernel_irq_routing_entry *e,
>  		    struct kvm *kvm, int irq_source_id, int level,
>  		    bool line_status)
> @@ -154,6 +154,7 @@ static int kvm_hv_set_sint(struct kvm_kernel_irq_routing_entry *e,
>  
>  	return kvm_hv_synic_set_irq(kvm, e->hv_sint.vcpu, e->hv_sint.sint);
>  }
> +#endif
>  
>  int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
>  			      struct kvm *kvm, int irq_source_id, int level,
> @@ -163,9 +164,11 @@ int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
>  	int r;
>  
>  	switch (e->type) {
> +#ifdef CONFIG_KVM_HYPERV
>  	case KVM_IRQ_ROUTING_HV_SINT:
>  		return kvm_hv_set_sint(e, kvm, irq_source_id, level,
>  				       line_status);
> +#endif
>  
>  	case KVM_IRQ_ROUTING_MSI:
>  		if (kvm_msi_route_invalid(kvm, e))
> @@ -314,11 +317,13 @@ int kvm_set_routing_entry(struct kvm *kvm,
>  		if (kvm_msi_route_invalid(kvm, e))
>  			return -EINVAL;
>  		break;
> +#ifdef CONFIG_KVM_HYPERV
>  	case KVM_IRQ_ROUTING_HV_SINT:
>  		e->set = kvm_hv_set_sint;
>  		e->hv_sint.vcpu = ue->u.hv_sint.vcpu;
>  		e->hv_sint.sint = ue->u.hv_sint.sint;
>  		break;
> +#endif
>  #ifdef CONFIG_KVM_XEN
>  	case KVM_IRQ_ROUTING_XEN_EVTCHN:
>  		return kvm_xen_setup_evtchn(kvm, e, ue);
> @@ -438,5 +443,7 @@ void kvm_scan_ioapic_routes(struct kvm_vcpu *vcpu,
>  
>  void kvm_arch_irq_routing_update(struct kvm *kvm)
>  {
> +#ifdef CONFIG_KVM_HYPERV
>  	kvm_hv_irq_routing_update(kvm);
> +#endif
>  }
> diff --git a/arch/x86/kvm/svm/hyperv.h b/arch/x86/kvm/svm/hyperv.h
> index 02f4784b5d44..14eec2d9b6be 100644
> --- a/arch/x86/kvm/svm/hyperv.h
> +++ b/arch/x86/kvm/svm/hyperv.h
> @@ -11,6 +11,7 @@
>  #include "../hyperv.h"
>  #include "svm.h"
>  
> +#ifdef CONFIG_KVM_HYPERV
>  static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -41,5 +42,11 @@ static inline bool nested_svm_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu)
>  }
>  
>  void svm_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu);
> +#else /* CONFIG_KVM_HYPERV */
> +static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu) {}
> +static inline bool nested_svm_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu) { return false; }
> +static inline void svm_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu) {}
> +#endif /* CONFIG_KVM_HYPERV */
> +
>  
>  #endif /* __ARCH_X86_KVM_SVM_HYPERV_H__ */
> diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
> index d4ed99008518..933ef6cad5e6 100644
> --- a/arch/x86/kvm/vmx/hyperv.h
> +++ b/arch/x86/kvm/vmx/hyperv.h
> @@ -20,6 +20,7 @@ enum nested_evmptrld_status {
>  	EVMPTRLD_ERROR,
>  };
>  
> +#ifdef CONFIG_KVM_HYPERV
>  u64 nested_get_evmptr(struct kvm_vcpu *vcpu);
>  uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
>  int nested_enable_evmcs(struct kvm_vcpu *vcpu,
> @@ -28,5 +29,12 @@ void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *
>  int nested_evmcs_check_controls(struct vmcs12 *vmcs12);
>  bool nested_evmcs_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu);
>  void vmx_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu);
> +#else
> +static inline u64 nested_get_evmptr(struct kvm_vcpu *vcpu) { return EVMPTR_INVALID; }
> +static inline void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata) {}
> +static inline bool nested_evmcs_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu) { return false; }
> +static inline int nested_evmcs_check_controls(struct vmcs12 *vmcs12) { return 0; }
> +#endif
> +
>  
>  #endif /* __KVM_X86_VMX_HYPERV_H */
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 382c0746d069..d0d735974b2c 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -226,6 +226,7 @@ static void vmx_disable_shadow_vmcs(struct vcpu_vmx *vmx)
>  
>  static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
>  {
> +#ifdef CONFIG_KVM_HYPERV
>  	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
> @@ -241,6 +242,7 @@ static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
>  		hv_vcpu->nested.vm_id = 0;
>  		hv_vcpu->nested.vp_id = 0;
>  	}
> +#endif
>  }
>  
>  static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
> @@ -1570,6 +1572,7 @@ static void copy_vmcs12_to_shadow(struct vcpu_vmx *vmx)
>  	vmcs_load(vmx->loaded_vmcs->vmcs);
>  }
>  
> +#ifdef CONFIG_KVM_HYPERV
>  static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields)
>  {
>  	struct vmcs12 *vmcs12 = vmx->nested.cached_vmcs12;
> @@ -2077,6 +2080,10 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
>  
>  	return EVMPTRLD_SUCCEEDED;
>  }
> +#else /* CONFIG_KVM_HYPERV */
> +static inline void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields) {}
> +static inline void copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx) {}
> +#endif /* CONFIG_KVM_HYPERV */
>  
>  void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu)
>  {
> @@ -3155,6 +3162,7 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_KVM_HYPERV
>  static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -3182,6 +3190,9 @@ static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu)
>  
>  	return true;
>  }
> +#else
> +static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu) { return true; }
> +#endif
>  
>  static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
>  {
> @@ -3552,11 +3563,13 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
>  	if (!nested_vmx_check_permission(vcpu))
>  		return 1;
>  
> +#ifdef CONFIG_KVM_HYPERV
>  	evmptrld_status = nested_vmx_handle_enlightened_vmptrld(vcpu, launch);
>  	if (evmptrld_status == EVMPTRLD_ERROR) {
>  		kvm_queue_exception(vcpu, UD_VECTOR);
>  		return 1;
>  	}
> +#endif
>  
>  	kvm_pmu_trigger_event(vcpu, PERF_COUNT_HW_BRANCH_INSTRUCTIONS);
>  
> @@ -7090,7 +7103,9 @@ struct kvm_x86_nested_ops vmx_nested_ops = {
>  	.set_state = vmx_set_nested_state,
>  	.get_nested_state_pages = vmx_get_nested_state_pages,
>  	.write_log_dirty = nested_vmx_write_pml_buffer,
> +#ifdef CONFIG_KVM_HYPERV
>  	.enable_evmcs = nested_enable_evmcs,
>  	.get_evmcs_version = nested_get_evmcs_version,
>  	.hv_inject_synthetic_vmexit_post_tlb_flush = vmx_hv_inject_synthetic_vmexit_post_tlb_flush,
> +#endif
>  };
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index cc2524598368..8ef9898092cd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1504,6 +1504,8 @@ static unsigned num_msrs_to_save;
>  static const u32 emulated_msrs_all[] = {
>  	MSR_KVM_SYSTEM_TIME, MSR_KVM_WALL_CLOCK,
>  	MSR_KVM_SYSTEM_TIME_NEW, MSR_KVM_WALL_CLOCK_NEW,
> +
> +#ifdef CONFIG_KVM_HYPERV
>  	HV_X64_MSR_GUEST_OS_ID, HV_X64_MSR_HYPERCALL,
>  	HV_X64_MSR_TIME_REF_COUNT, HV_X64_MSR_REFERENCE_TSC,
>  	HV_X64_MSR_TSC_FREQUENCY, HV_X64_MSR_APIC_FREQUENCY,
> @@ -1521,6 +1523,7 @@ static const u32 emulated_msrs_all[] = {
>  	HV_X64_MSR_SYNDBG_CONTROL, HV_X64_MSR_SYNDBG_STATUS,
>  	HV_X64_MSR_SYNDBG_SEND_BUFFER, HV_X64_MSR_SYNDBG_RECV_BUFFER,
>  	HV_X64_MSR_SYNDBG_PENDING_BUFFER,
> +#endif
>  
>  	MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
>  	MSR_KVM_PV_EOI_EN, MSR_KVM_ASYNC_PF_INT, MSR_KVM_ASYNC_PF_ACK,
> @@ -4022,6 +4025,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		 * the need to ignore the workaround.
>  		 */
>  		break;
> +#ifdef CONFIG_KVM_HYPERV
>  	case HV_X64_MSR_GUEST_OS_ID ... HV_X64_MSR_SINT15:
>  	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
>  	case HV_X64_MSR_SYNDBG_OPTIONS:
> @@ -4034,6 +4038,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case HV_X64_MSR_TSC_INVARIANT_CONTROL:
>  		return kvm_hv_set_msr_common(vcpu, msr, data,
>  					     msr_info->host_initiated);
> +#endif
>  	case MSR_IA32_BBL_CR_CTL3:
>  		/* Drop writes to this legacy MSR -- see rdmsr
>  		 * counterpart for further detail.
> @@ -4378,6 +4383,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		 */
>  		msr_info->data = 0x20000000;
>  		break;
> +#ifdef CONFIG_KVM_HYPERV
>  	case HV_X64_MSR_GUEST_OS_ID ... HV_X64_MSR_SINT15:
>  	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
>  	case HV_X64_MSR_SYNDBG_OPTIONS:
> @@ -4391,6 +4397,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		return kvm_hv_get_msr_common(vcpu,
>  					     msr_info->index, &msr_info->data,
>  					     msr_info->host_initiated);
> +#endif
>  	case MSR_IA32_BBL_CR_CTL3:
>  		/* This legacy MSR exists but isn't fully documented in current
>  		 * silicon.  It is however accessed by winxp in very narrow
> @@ -4528,6 +4535,7 @@ static inline bool kvm_can_mwait_in_guest(void)
>  		boot_cpu_has(X86_FEATURE_ARAT);
>  }
>  
> +#ifdef CONFIG_KVM_HYPERV
>  static int kvm_ioctl_get_supported_hv_cpuid(struct kvm_vcpu *vcpu,
>  					    struct kvm_cpuid2 __user *cpuid_arg)
>  {
> @@ -4548,6 +4556,7 @@ static int kvm_ioctl_get_supported_hv_cpuid(struct kvm_vcpu *vcpu,
>  
>  	return 0;
>  }
> +#endif
>  
>  int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  {
> @@ -4574,9 +4583,11 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_PIT_STATE2:
>  	case KVM_CAP_SET_IDENTITY_MAP_ADDR:
>  	case KVM_CAP_VCPU_EVENTS:
> +#ifdef CONFIG_KVM_HYPERV
>  	case KVM_CAP_HYPERV:
>  	case KVM_CAP_HYPERV_VAPIC:
>  	case KVM_CAP_HYPERV_SPIN:
> +	case KVM_CAP_HYPERV_TIME:
>  	case KVM_CAP_HYPERV_SYNIC:
>  	case KVM_CAP_HYPERV_SYNIC2:
>  	case KVM_CAP_HYPERV_VP_INDEX:
> @@ -4586,6 +4597,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_HYPERV_CPUID:
>  	case KVM_CAP_HYPERV_ENFORCE_CPUID:
>  	case KVM_CAP_SYS_HYPERV_CPUID:
> +#endif
>  	case KVM_CAP_PCI_SEGMENT:
>  	case KVM_CAP_DEBUGREGS:
>  	case KVM_CAP_X86_ROBUST_SINGLESTEP:
> @@ -4595,7 +4607,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_GET_TSC_KHZ:
>  	case KVM_CAP_KVMCLOCK_CTRL:
>  	case KVM_CAP_READONLY_MEM:
> -	case KVM_CAP_HYPERV_TIME:
>  	case KVM_CAP_IOAPIC_POLARITY_IGNORED:
>  	case KVM_CAP_TSC_DEADLINE_TIMER:
>  	case KVM_CAP_DISABLE_QUIRKS:
> @@ -4705,12 +4716,14 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		r = kvm_x86_ops.nested_ops->get_state ?
>  			kvm_x86_ops.nested_ops->get_state(NULL, NULL, 0) : 0;
>  		break;
> +#ifdef CONFIG_KVM_HYPERV
>  	case KVM_CAP_HYPERV_DIRECT_TLBFLUSH:
>  		r = kvm_x86_ops.enable_l2_tlb_flush != NULL;
>  		break;
>  	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
>  		r = kvm_x86_ops.nested_ops->enable_evmcs != NULL;
>  		break;
> +#endif
>  	case KVM_CAP_SMALLER_MAXPHYADDR:
>  		r = (int) allow_smaller_maxphyaddr;
>  		break;
> @@ -4872,9 +4885,11 @@ long kvm_arch_dev_ioctl(struct file *filp,
>  	case KVM_GET_MSRS:
>  		r = msr_io(NULL, argp, do_get_msr_feature, 1);
>  		break;
> +#ifdef CONFIG_KVM_HYPERV
>  	case KVM_GET_SUPPORTED_HV_CPUID:
>  		r = kvm_ioctl_get_supported_hv_cpuid(NULL, argp);
>  		break;
> +#endif
>  	case KVM_GET_DEVICE_ATTR: {
>  		struct kvm_device_attr attr;
>  		r = -EFAULT;
> @@ -5700,14 +5715,11 @@ static int kvm_vcpu_ioctl_device_attr(struct kvm_vcpu *vcpu,
>  static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
>  				     struct kvm_enable_cap *cap)
>  {
> -	int r;
> -	uint16_t vmcs_version;
> -	void __user *user_ptr;
> -
>  	if (cap->flags)
>  		return -EINVAL;
>  
>  	switch (cap->cap) {
> +#ifdef CONFIG_KVM_HYPERV
>  	case KVM_CAP_HYPERV_SYNIC2:
>  		if (cap->args[0])
>  			return -EINVAL;
> @@ -5719,16 +5731,22 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
>  		return kvm_hv_activate_synic(vcpu, cap->cap ==
>  					     KVM_CAP_HYPERV_SYNIC2);
>  	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
> -		if (!kvm_x86_ops.nested_ops->enable_evmcs)
> -			return -ENOTTY;
> -		r = kvm_x86_ops.nested_ops->enable_evmcs(vcpu, &vmcs_version);
> -		if (!r) {
> -			user_ptr = (void __user *)(uintptr_t)cap->args[0];
> -			if (copy_to_user(user_ptr, &vmcs_version,
> -					 sizeof(vmcs_version)))
> -				r = -EFAULT;
> +		{
> +			int r;
> +			uint16_t vmcs_version;
> +			void __user *user_ptr;
> +
> +			if (!kvm_x86_ops.nested_ops->enable_evmcs)
> +				return -ENOTTY;
> +			r = kvm_x86_ops.nested_ops->enable_evmcs(vcpu, &vmcs_version);
> +			if (!r) {
> +				user_ptr = (void __user *)(uintptr_t)cap->args[0];
> +				if (copy_to_user(user_ptr, &vmcs_version,
> +						 sizeof(vmcs_version)))
> +					r = -EFAULT;
> +			}
> +			return r;
>  		}
> -		return r;

Minor nitpick: Unless I missed something the above is just refactoring. Can this be split
into a separate patch?


>  	case KVM_CAP_HYPERV_DIRECT_TLBFLUSH:
>  		if (!kvm_x86_ops.enable_l2_tlb_flush)
>  			return -ENOTTY;
> @@ -5737,6 +5755,7 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
>  
>  	case KVM_CAP_HYPERV_ENFORCE_CPUID:
>  		return kvm_hv_set_enforce_cpuid(vcpu, cap->args[0]);
> +#endif
>  
>  	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
>  		vcpu->arch.pv_cpuid.enforce = cap->args[0];
> @@ -6129,9 +6148,11 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  		srcu_read_unlock(&vcpu->kvm->srcu, idx);
>  		break;
>  	}
> +#ifdef CONFIG_KVM_HYPERV
>  	case KVM_GET_SUPPORTED_HV_CPUID:
>  		r = kvm_ioctl_get_supported_hv_cpuid(vcpu, argp);
>  		break;
> +#endif
>  #ifdef CONFIG_KVM_XEN
>  	case KVM_XEN_VCPU_GET_ATTR: {
>  		struct kvm_xen_vcpu_attr xva;
> @@ -7189,6 +7210,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>  		r = static_call(kvm_x86_mem_enc_unregister_region)(kvm, &region);
>  		break;
>  	}
> +#ifdef CONFIG_KVM_HYPERV
>  	case KVM_HYPERV_EVENTFD: {
>  		struct kvm_hyperv_eventfd hvevfd;
>  
> @@ -7198,6 +7220,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>  		r = kvm_vm_ioctl_hv_eventfd(kvm, &hvevfd);
>  		break;
>  	}
> +#endif
>  	case KVM_SET_PMU_EVENT_FILTER:
>  		r = kvm_vm_ioctl_set_pmu_event_filter(kvm, argp);
>  		break;
> @@ -10576,19 +10599,20 @@ static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
>  
>  static void vcpu_load_eoi_exitmap(struct kvm_vcpu *vcpu)
>  {
> -	u64 eoi_exit_bitmap[4];
> -
>  	if (!kvm_apic_hw_enabled(vcpu->arch.apic))
>  		return;
>  
> +#ifdef CONFIG_KVM_HYPERV
>  	if (to_hv_vcpu(vcpu)) {
> +		u64 eoi_exit_bitmap[4];
> +
>  		bitmap_or((ulong *)eoi_exit_bitmap,
>  			  vcpu->arch.ioapic_handled_vectors,
>  			  to_hv_synic(vcpu)->vec_bitmap, 256);
>  		static_call_cond(kvm_x86_load_eoi_exitmap)(vcpu, eoi_exit_bitmap);
>  		return;
>  	}
> -
> +#endif

Same here.

>  	static_call_cond(kvm_x86_load_eoi_exitmap)(
>  		vcpu, (u64 *)vcpu->arch.ioapic_handled_vectors);
>  }
> @@ -10679,9 +10703,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		 * the flushes are considered "remote" and not "local" because
>  		 * the requests can be initiated from other vCPUs.
>  		 */
> +#ifdef CONFIG_KVM_HYPERV
>  		if (kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu) &&
>  		    kvm_hv_vcpu_flush_tlb(vcpu))
>  			kvm_vcpu_flush_tlb_guest(vcpu);
> +#endif
>  
>  		if (kvm_check_request(KVM_REQ_REPORT_TPR_ACCESS, vcpu)) {
>  			vcpu->run->exit_reason = KVM_EXIT_TPR_ACCESS;
> @@ -10734,6 +10760,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  			vcpu_load_eoi_exitmap(vcpu);
>  		if (kvm_check_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu))
>  			kvm_vcpu_reload_apic_access_page(vcpu);
> +#ifdef CONFIG_KVM_HYPERV
>  		if (kvm_check_request(KVM_REQ_HV_CRASH, vcpu)) {
>  			vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
>  			vcpu->run->system_event.type = KVM_SYSTEM_EVENT_CRASH;
> @@ -10764,6 +10791,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		 */
>  		if (kvm_check_request(KVM_REQ_HV_STIMER, vcpu))
>  			kvm_hv_process_stimers(vcpu);
> +#endif
>  		if (kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu))
>  			kvm_vcpu_update_apicv(vcpu);
>  		if (kvm_check_request(KVM_REQ_APF_READY, vcpu))

Besides nitpicks,

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


Best regards,
	Maxim Levitsky



