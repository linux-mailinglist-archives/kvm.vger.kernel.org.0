Return-Path: <kvm+bounces-5476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 305A88224D0
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 23:35:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9976F1F237A9
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 22:35:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0BD617987;
	Tue,  2 Jan 2024 22:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MAzJotlb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F28717733
	for <kvm@vger.kernel.org>; Tue,  2 Jan 2024 22:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704234893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kC26N0z125b49ixw2KVRoe3L9q4xP4Zyq3Y67Pui4+A=;
	b=MAzJotlbJ5hVx7vOMum5LDFUh9Z5VLls45AFlnl6+UFA32CYG47dQyAO8FwQouyO0IJQ5P
	jJOh5lNO2blVUY2OyK1DnfGKhPujyUj8kySbQCoz/XvTEID7jYz3GQe4jl75gJfrhBHLVM
	UJ8ZokH6ZRuLl6QuAqqA509LQei0Jvc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-266-iDadzjWhPaCeD_yZdFhcFQ-1; Tue, 02 Jan 2024 17:34:52 -0500
X-MC-Unique: iDadzjWhPaCeD_yZdFhcFQ-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-336862fa1a5so6915942f8f.2
        for <kvm@vger.kernel.org>; Tue, 02 Jan 2024 14:34:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704234891; x=1704839691;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kC26N0z125b49ixw2KVRoe3L9q4xP4Zyq3Y67Pui4+A=;
        b=XERI9/93hRbX6TYCPBeqc0wLauk1Fd2npmU5NGZqPemL4+8orhQRRezh0nSKOWh8as
         sBybCEkKfRi4t/NelVDPtiesgKS9p8II7Uvf/SlFQe/G3YJ1MWdtiq4+hYlqocdsXzDK
         Unfyn0WAgXLFFt1pXTtKqzT1ZLioshQU4bYOlb8cL1dxC46M7g5Zzcd9Vcz7YUwU8i4y
         iHprFu8vSnK84/m0QFrSiIARIcCogzgbaPFaAGzzhvVE3hE66NI70enZ16i1ybgS2gbU
         308VLa8kttMIoncNvqtpS+0CbdBoNZs/S95OnBE2tmPDQK8SJ3l9z4mHvlj1DVhKt1HU
         feBg==
X-Gm-Message-State: AOJu0Yx6LYxEOonSHxJG+Rsa/UI+maoTxFGg/ntbF7HaFmADiHRJWvpc
	xLnioDH/XR/WhNsu6lldWMfAZFviKivCl7Jx1pnJ9Q8uA9sqVz/jx1hpVDYTqLMTW9sbyMCmZ3P
	hyxBxYHZH/qDCcjvX98du
X-Received: by 2002:a5d:6487:0:b0:336:ce1f:d89f with SMTP id o7-20020a5d6487000000b00336ce1fd89fmr6612981wri.103.1704234891111;
        Tue, 02 Jan 2024 14:34:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGlYZJepJPVRSLAvzqQI4no1els7mBeSpBR3+s5d5i63HzukKXRTiEKh1vIfkm0tHTRb/E4qw==
X-Received: by 2002:a5d:6487:0:b0:336:ce1f:d89f with SMTP id o7-20020a5d6487000000b00336ce1fd89fmr6612972wri.103.1704234890833;
        Tue, 02 Jan 2024 14:34:50 -0800 (PST)
Received: from starship ([147.235.223.38])
        by smtp.gmail.com with ESMTPSA id e14-20020a5d6d0e000000b00336cbbf2e0fsm19880410wrq.27.2024.01.02.14.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jan 2024 14:34:50 -0800 (PST)
Message-ID: <1000db132dfe8f31dc964a6bd8cd3aeaab724b72.camel@redhat.com>
Subject: Re: [PATCH v8 24/26] KVM: x86: Enable CET virtualization for VMX
 and advertise to userspace
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, dave.hansen@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, chao.gao@intel.com, rick.p.edgecombe@intel.com, 
	john.allen@amd.com
Date: Wed, 03 Jan 2024 00:34:48 +0200
In-Reply-To: <20231221140239.4349-25-weijiang.yang@intel.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
	 <20231221140239.4349-25-weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2023-12-21 at 09:02 -0500, Yang Weijiang wrote:
> Expose CET features to guest if KVM/host can support them, clear CPUID
> feature bits if KVM/host cannot support.
> 
> Set CPUID feature bits so that CET features are available in guest CPUID.
> Add CR4.CET bit support in order to allow guest set CET master control
> bit.
> 
> Disable KVM CET feature if unrestricted_guest is unsupported/disabled as
> KVM does not support emulating CET.
> 
> The CET load-bits in VM_ENTRY/VM_EXIT control fields should be set to make
> guest CET xstates isolated from host's.
> 
> On platforms with VMX_BASIC[bit56] == 0, inject #CP at VMX entry with error
> code will fail, and if VMX_BASIC[bit56] == 1, #CP injection with or without
> error code is allowed. Disable CET feature bits if the MSR bit is cleared
> so that nested VMM can inject #CP if and only if VMX_BASIC[bit56] == 1.

This is a good explanation but IMHO it should be in the code and not in the commit message,
because its hard to trace things to commit messages just to figure out what
the code is doing.

> 
> Don't expose CET feature if either of {U,S}_CET xstate bits is cleared
> in host XSS or if XSAVES isn't supported.
> 
> CET MSR contents after reset, power-up and INIT are set to 0s, clears the
> guest fpstate fields so that the guest MSRs are reset to 0s after the events.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h  |  2 +-
>  arch/x86/include/asm/msr-index.h |  1 +
>  arch/x86/kvm/cpuid.c             | 19 +++++++++++++++++--
>  arch/x86/kvm/vmx/capabilities.h  |  6 ++++++
>  arch/x86/kvm/vmx/vmx.c           | 29 ++++++++++++++++++++++++++++-
>  arch/x86/kvm/vmx/vmx.h           |  6 ++++--
>  arch/x86/kvm/x86.c               | 31 +++++++++++++++++++++++++++++--
>  arch/x86/kvm/x86.h               |  3 +++
>  8 files changed, 89 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 6efaaaa15945..161d0552be5f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -134,7 +134,7 @@
>  			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
>  			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
>  			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
> -			  | X86_CR4_LAM_SUP))
> +			  | X86_CR4_LAM_SUP | X86_CR4_CET))
>  
>  #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
>  
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 1d51e1850ed0..233e00c01e62 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -1102,6 +1102,7 @@
>  #define VMX_BASIC_MEM_TYPE_MASK	0x003c000000000000LLU
>  #define VMX_BASIC_MEM_TYPE_WB	6LLU
>  #define VMX_BASIC_INOUT		0x0040000000000000LLU
> +#define VMX_BASIC_NO_HW_ERROR_CODE_CC	0x0100000000000000LLU
>  
>  /* Resctrl MSRs: */
>  /* - Intel: */
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index cfc0ac8ddb4a..18d1a0eb0f64 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -665,7 +665,7 @@ void kvm_set_cpu_caps(void)
>  		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
>  		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
>  		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
> -		F(SGX_LC) | F(BUS_LOCK_DETECT)
> +		F(SGX_LC) | F(BUS_LOCK_DETECT) | F(SHSTK)
>  	);
>  	/* Set LA57 based on hardware capability. */
>  	if (cpuid_ecx(7) & F(LA57))
> @@ -683,7 +683,8 @@ void kvm_set_cpu_caps(void)
>  		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
>  		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
>  		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16) |
> -		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16) | F(FLUSH_L1D)
> +		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16) | F(FLUSH_L1D) |
> +		F(IBT)
>  	);
>  
>  	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
> @@ -696,6 +697,20 @@ void kvm_set_cpu_caps(void)
>  		kvm_cpu_cap_set(X86_FEATURE_INTEL_STIBP);
>  	if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
>  		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
> +	/*
> +	 * Don't use boot_cpu_has() to check availability of IBT because the
> +	 * feature bit is cleared in boot_cpu_data when ibt=off is applied
> +	 * in host cmdline.
> +	 *
> +	 * As currently there's no HW bug which requires disabling IBT feature
> +	 * while CPU can enumerate it, host cmdline option ibt=off is most
> +	 * likely due to administrative reason on host side, so KVM refers to
> +	 * CPU CPUID enumeration to enable the feature. In future if there's
> +	 * actually some bug clobbered ibt=off option, then enforce additional
> +	 * check here to disable the support in KVM.
> +	 */
> +	if (cpuid_edx(7) & F(IBT))
> +		kvm_cpu_cap_set(X86_FEATURE_IBT);
>  
>  	kvm_cpu_cap_mask(CPUID_7_1_EAX,
>  		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) |
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index ee8938818c8a..e12bc233d88b 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -79,6 +79,12 @@ static inline bool cpu_has_vmx_basic_inout(void)
>  	return	(((u64)vmcs_config.basic_cap << 32) & VMX_BASIC_INOUT);
>  }
>  
> +static inline bool cpu_has_vmx_basic_no_hw_errcode(void)
> +{
> +	return	((u64)vmcs_config.basic_cap << 32) &
> +		 VMX_BASIC_NO_HW_ERROR_CODE_CC;
> +}
> +
>  static inline bool cpu_has_virtual_nmis(void)
>  {
>  	return vmcs_config.pin_based_exec_ctrl & PIN_BASED_VIRTUAL_NMIS &&
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e9c0b571b3bb..c802e790c0d5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2609,6 +2609,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  		{ VM_ENTRY_LOAD_IA32_EFER,		VM_EXIT_LOAD_IA32_EFER },
>  		{ VM_ENTRY_LOAD_BNDCFGS,		VM_EXIT_CLEAR_BNDCFGS },
>  		{ VM_ENTRY_LOAD_IA32_RTIT_CTL,		VM_EXIT_CLEAR_IA32_RTIT_CTL },
> +		{ VM_ENTRY_LOAD_CET_STATE,		VM_EXIT_LOAD_CET_STATE },
>  	};
>  
>  	memset(vmcs_conf, 0, sizeof(*vmcs_conf));
> @@ -4934,6 +4935,15 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  
>  	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);  /* 22.2.1 */
>  
> +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK))
> +		vmcs_writel(GUEST_SSP, 0);
> +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK) ||
> +	    kvm_cpu_cap_has(X86_FEATURE_IBT))
> +		vmcs_writel(GUEST_S_CET, 0);
> +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
> +	    IS_ENABLED(CONFIG_X86_64))
> +		vmcs_writel(GUEST_INTR_SSP_TABLE, 0);
> +
>  	kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
>  
>  	vpid_sync_context(vmx->vpid);
> @@ -6353,6 +6363,12 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
>  	if (vmcs_read32(VM_EXIT_MSR_STORE_COUNT) > 0)
>  		vmx_dump_msrs("guest autostore", &vmx->msr_autostore.guest);
>  
> +	if (vmentry_ctl & VM_ENTRY_LOAD_CET_STATE) {
> +		pr_err("S_CET = 0x%016lx\n", vmcs_readl(GUEST_S_CET));
> +		pr_err("SSP = 0x%016lx\n", vmcs_readl(GUEST_SSP));
> +		pr_err("INTR SSP TABLE = 0x%016lx\n",
> +		       vmcs_readl(GUEST_INTR_SSP_TABLE));
> +	}
>  	pr_err("*** Host State ***\n");
>  	pr_err("RIP = 0x%016lx  RSP = 0x%016lx\n",
>  	       vmcs_readl(HOST_RIP), vmcs_readl(HOST_RSP));
> @@ -6430,6 +6446,12 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
>  	if (secondary_exec_control & SECONDARY_EXEC_ENABLE_VPID)
>  		pr_err("Virtual processor ID = 0x%04x\n",
>  		       vmcs_read16(VIRTUAL_PROCESSOR_ID));
> +	if (vmexit_ctl & VM_EXIT_LOAD_CET_STATE) {
> +		pr_err("S_CET = 0x%016lx\n", vmcs_readl(HOST_S_CET));
> +		pr_err("SSP = 0x%016lx\n", vmcs_readl(HOST_SSP));
> +		pr_err("INTR SSP TABLE = 0x%016lx\n",
> +		       vmcs_readl(HOST_INTR_SSP_TABLE));
> +	}
>  }
>  
>  /*
> @@ -7966,7 +7988,6 @@ static __init void vmx_set_cpu_caps(void)
>  		kvm_cpu_cap_set(X86_FEATURE_UMIP);
>  
>  	/* CPUID 0xD.1 */
> -	kvm_caps.supported_xss = 0;
>  	if (!cpu_has_vmx_xsaves())
>  		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
>  
> @@ -7978,6 +7999,12 @@ static __init void vmx_set_cpu_caps(void)
>  
>  	if (cpu_has_vmx_waitpkg())
>  		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
> +
> +	if (!cpu_has_load_cet_ctrl() || !enable_unrestricted_guest ||
> +	    !cpu_has_vmx_basic_no_hw_errcode()) {
> +		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
> +		kvm_cpu_cap_clear(X86_FEATURE_IBT);
> +	}
>  }
>  
>  static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index e3b0985bb74a..d0cad2624564 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -484,7 +484,8 @@ static inline u8 vmx_get_rvi(void)
>  	 VM_ENTRY_LOAD_IA32_EFER |					\
>  	 VM_ENTRY_LOAD_BNDCFGS |					\
>  	 VM_ENTRY_PT_CONCEAL_PIP |					\
> -	 VM_ENTRY_LOAD_IA32_RTIT_CTL)
> +	 VM_ENTRY_LOAD_IA32_RTIT_CTL |					\
> +	 VM_ENTRY_LOAD_CET_STATE)
>  
>  #define __KVM_REQUIRED_VMX_VM_EXIT_CONTROLS				\
>  	(VM_EXIT_SAVE_DEBUG_CONTROLS |					\
> @@ -506,7 +507,8 @@ static inline u8 vmx_get_rvi(void)
>  	       VM_EXIT_LOAD_IA32_EFER |					\
>  	       VM_EXIT_CLEAR_BNDCFGS |					\
>  	       VM_EXIT_PT_CONCEAL_PIP |					\
> -	       VM_EXIT_CLEAR_IA32_RTIT_CTL)
> +	       VM_EXIT_CLEAR_IA32_RTIT_CTL |				\
> +	       VM_EXIT_LOAD_CET_STATE)
>  
>  #define KVM_REQUIRED_VMX_PIN_BASED_VM_EXEC_CONTROL			\
>  	(PIN_BASED_EXT_INTR_MASK |					\
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9596763fae8d..5058c9c5f4cc 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -231,7 +231,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
>  				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
>  				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
>  
> -#define KVM_SUPPORTED_XSS     0
> +#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_USER | \
> +				 XFEATURE_MASK_CET_KERNEL)
>  
>  u64 __read_mostly host_efer;
>  EXPORT_SYMBOL_GPL(host_efer);
> @@ -9921,6 +9922,20 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
>  		kvm_caps.supported_xss = 0;
>  
> +	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
> +	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
> +		kvm_caps.supported_xss &= ~(XFEATURE_CET_USER |
> +					    XFEATURE_CET_KERNEL);

OK.

> +
> +	if ((kvm_caps.supported_xss & (XFEATURE_MASK_CET_USER |
> +	     XFEATURE_MASK_CET_KERNEL)) !=
> +	    (XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)) {
> +		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
> +		kvm_cpu_cap_clear(X86_FEATURE_IBT);
> +		kvm_caps.supported_xss &= ~(XFEATURE_CET_USER |
> +					    XFEATURE_CET_KERNEL);
> +	}
> +
>  #define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
>  	cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
>  #undef __kvm_cpu_cap_has
> @@ -12392,7 +12407,9 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  
>  static inline bool is_xstate_reset_needed(void)
>  {
> -	return kvm_cpu_cap_has(X86_FEATURE_MPX);
> +	return kvm_cpu_cap_has(X86_FEATURE_MPX) ||
> +	       kvm_cpu_cap_has(X86_FEATURE_SHSTK) ||
> +	       kvm_cpu_cap_has(X86_FEATURE_IBT);
>  }
>  
>  void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> @@ -12469,6 +12486,16 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  						       XFEATURE_BNDCSR);
>  		}
>  
> +		if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
> +			fpstate_clear_xstate_component(fpstate,
> +						       XFEATURE_CET_USER);
> +			fpstate_clear_xstate_component(fpstate,
> +						       XFEATURE_CET_KERNEL);
> +		} else if (kvm_cpu_cap_has(X86_FEATURE_IBT)) {
> +			fpstate_clear_xstate_component(fpstate,
> +						       XFEATURE_CET_USER);
> +		}
> +
>  		if (init_event)
>  			kvm_load_guest_fpu(vcpu);
>  	}
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 656107e64c93..cc585051d24b 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -533,6 +533,9 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
>  		__reserved_bits |= X86_CR4_PCIDE;       \
>  	if (!__cpu_has(__c, X86_FEATURE_LAM))           \
>  		__reserved_bits |= X86_CR4_LAM_SUP;     \
> +	if (!__cpu_has(__c, X86_FEATURE_SHSTK) &&       \
> +	    !__cpu_has(__c, X86_FEATURE_IBT))           \
> +		__reserved_bits |= X86_CR4_CET;         \
>  	__reserved_bits;                                \
>  })
>  

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky





