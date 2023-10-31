Return-Path: <kvm+bounces-237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B15317DD5A9
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 18:57:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D38391C20C8C
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 17:57:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F01121354;
	Tue, 31 Oct 2023 17:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RYgfrZMS"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD5720B32
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 17:57:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F8E128
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698775022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HyzYUT1aa13yFXkq9NizeFbbKICx/+R50ZuuSVMKwTE=;
	b=RYgfrZMSrtAdMrxFHcf8QMgKVczx67m5RSbnH9n2Zdi/+0zSE/Kx/vONb7gXvP9zmznK9z
	5BSoPpkbIOwXbp2IsFGPPbhgA5qNgg4rU8b/PbLs/ksdqyd1tIyFObsnDM+u3BziAz/Xe5
	djF+x7IxeAldcdffwYNtZs4wDj+Bga4=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-524-9fIbl5c2P5mGveW4b5xhgg-1; Tue, 31 Oct 2023 13:57:01 -0400
X-MC-Unique: 9fIbl5c2P5mGveW4b5xhgg-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5079fe7cc7cso7208689e87.2
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:57:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698775019; x=1699379819;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HyzYUT1aa13yFXkq9NizeFbbKICx/+R50ZuuSVMKwTE=;
        b=LrSrL1JheoVUowtwI67VYe4suohpbC6Jf6ef+SBQzWIa9Twu5bh9qVDondQ3Esv2Ui
         OHnSPJtbwPxLRdz9TEHcS7UJvx/jj8MF8fF0JetQ4X/OeriEi3FgBJVPjPuAyVeyblry
         Znu6EaHEfJrDKxgsEHQATBlBc+K/7sDhHvWOY9hTzppBapGoBA5kK754Oou8ziuKO00U
         J2PD0flO38YWp3Ik8l4s4fcoH276SB2wuNdiCVAO8lD0C1N74JezNjMemRMxKtgR/PgR
         lfAOAOfY4yo9nlU61PKhvY8k64udu+xHy2egIIUoVbkRCHogSNQ+PylmiR8px6TPtM4h
         O5kg==
X-Gm-Message-State: AOJu0YxpNwRMXGLqnM0BwXygCdng1T8lzox6nfNLplwQsM40CcplyMgQ
	JU2BcezlLwfuiwwh77OdcLVFnKwY5RyuU0D00rXdhOkDgxCrvoqwVDnicAti+MDq5bdEZqgrA9s
	iNcQqwRdc8W3P
X-Received: by 2002:a05:6512:3995:b0:509:fbf:f235 with SMTP id j21-20020a056512399500b005090fbff235mr8885408lfu.6.1698775019572;
        Tue, 31 Oct 2023 10:56:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFkK8Todb3yqUt+qa7L0cM1FNVSiGhtRNJjwLjy5j6GYcOj7kDUL67NTByrr8pGiKZ/rXli3A==
X-Received: by 2002:a05:6512:3995:b0:509:fbf:f235 with SMTP id j21-20020a056512399500b005090fbff235mr8885385lfu.6.1698775019181;
        Tue, 31 Oct 2023 10:56:59 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id d8-20020a05600c34c800b0040644e699a0sm2427437wmq.45.2023.10.31.10.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 10:56:58 -0700 (PDT)
Message-ID: <c07416ff2919f0aa30d3a810ccdfbed8c387ce0a.camel@redhat.com>
Subject: Re: [PATCH v6 23/25] KVM: x86: Enable CET virtualization for VMX
 and advertise to userspace
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dave.hansen@intel.com, peterz@infradead.org, chao.gao@intel.com, 
	rick.p.edgecombe@intel.com, john.allen@amd.com
Date: Tue, 31 Oct 2023 19:56:56 +0200
In-Reply-To: <20230914063325.85503-24-weijiang.yang@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
	 <20230914063325.85503-24-weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
> Expose CET features to guest if KVM/host can support them, clear CPUID
> feature bits if KVM/host cannot support.
> 
> Set CPUID feature bits so that CET features are available in guest CPUID.
> Add CR4.CET bit support in order to allow guest set CET master control
> bit.
> 
> Disable KVM CET feature if unrestricted_guest is unsupported/disabled as
> KVM does not support emulating CET.
> Don't expose CET feature if either of {U,S}_CET xstate bits is cleared
> in host XSS or if XSAVES isn't supported.
> 
> The CET load-bits in VM_ENTRY/VM_EXIT control fields should be set to make
> guest CET xstates isolated from host's. And all platforms that support CET
> enumerate VMX_BASIC[bit56] as 1, clear CET feature bits if the bit doesn't
> read 1.
> 
> Regarding the CET MSR contents after Reset/INIT, SDM doesn't mention the
> default values, neither can I get the answer internally so far, will fill
> the gap once it's clear.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h  |  3 ++-
>  arch/x86/include/asm/msr-index.h |  1 +
>  arch/x86/kvm/cpuid.c             | 12 ++++++++++--
>  arch/x86/kvm/vmx/capabilities.h  |  6 ++++++
>  arch/x86/kvm/vmx/vmx.c           | 23 ++++++++++++++++++++++-
>  arch/x86/kvm/vmx/vmx.h           |  6 ++++--
>  arch/x86/kvm/x86.c               | 12 +++++++++++-
>  arch/x86/kvm/x86.h               |  3 +++
>  8 files changed, 59 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d77b030e996c..db0010fa3363 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -125,7 +125,8 @@
>  			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
>  			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
>  			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
> -			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
> +			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
> +			  | X86_CR4_CET))
>  
>  #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
>  
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 1d111350197f..1f8dc04da468 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -1091,6 +1091,7 @@
>  #define VMX_BASIC_MEM_TYPE_MASK	0x003c000000000000LLU
>  #define VMX_BASIC_MEM_TYPE_WB	6LLU
>  #define VMX_BASIC_INOUT		0x0040000000000000LLU
> +#define VMX_BASIC_NO_HW_ERROR_CODE_CC	0x0100000000000000LLU
>  
>  /* Resctrl MSRs: */
>  /* - Intel: */
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 4e7a820cba62..d787a506746a 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -654,7 +654,7 @@ void kvm_set_cpu_caps(void)
>  		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
>  		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
>  		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
> -		F(SGX_LC) | F(BUS_LOCK_DETECT)
> +		F(SGX_LC) | F(BUS_LOCK_DETECT) | F(SHSTK)
>  	);
>  	/* Set LA57 based on hardware capability. */
>  	if (cpuid_ecx(7) & F(LA57))
> @@ -672,7 +672,8 @@ void kvm_set_cpu_caps(void)
>  		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
>  		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
>  		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16) |
> -		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16) | F(FLUSH_L1D)
> +		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16) | F(FLUSH_L1D) |
> +		F(IBT)
>  	);
>  
>  	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
> @@ -685,6 +686,13 @@ void kvm_set_cpu_caps(void)
>  		kvm_cpu_cap_set(X86_FEATURE_INTEL_STIBP);
>  	if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
>  		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
> +	/*
> +	 * The feature bit in boot_cpu_data.x86_capability could have been
> +	 * cleared due to ibt=off cmdline option, then add it back if CPU
> +	 * supports IBT.
> +	 */
> +	if (cpuid_edx(7) & F(IBT))
> +		kvm_cpu_cap_set(X86_FEATURE_IBT);

The usual policy is that when the host doesn't support a feature, then the guest
should not support it either. On the other hand, for this particular feature,
it is probably safe to use it. Just a point for a discussion.

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

I see, this is because #CP does have an error code but when bit 56 of IA32_VMX_BASIC,
is clear then error code must be present iff exception is within a hardcoded list of exceptions,
and #CP is not on this list because back then the #CP didn't exist, and all new CPUs do
have this bit 56 set.

But I am not 100% sure that this check is worth it, I don't mind having it though,
but please add a comment explaining why the bit 56 is needed for CET.

> +
>  static inline bool cpu_has_virtual_nmis(void)
>  {
>  	return vmcs_config.pin_based_exec_ctrl & PIN_BASED_VIRTUAL_NMIS &&
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9ccc2c552f55..f0dea8ecd0c6 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2614,6 +2614,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  		{ VM_ENTRY_LOAD_IA32_EFER,		VM_EXIT_LOAD_IA32_EFER },
>  		{ VM_ENTRY_LOAD_BNDCFGS,		VM_EXIT_CLEAR_BNDCFGS },
>  		{ VM_ENTRY_LOAD_IA32_RTIT_CTL,		VM_EXIT_CLEAR_IA32_RTIT_CTL },
> +		{ VM_ENTRY_LOAD_CET_STATE,		VM_EXIT_LOAD_CET_STATE },
>  	};
>  
>  	memset(vmcs_conf, 0, sizeof(*vmcs_conf));
> @@ -4934,6 +4935,9 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  		vmcs_write64(GUEST_BNDCFGS, 0);
>  
>  	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);  /* 22.2.1 */


I guess that the below 3 writes should only be done if CET is supported,
this is what the kernel test robot is complaining about.


> +	vmcs_writel(GUEST_SSP, 0);
> +	vmcs_writel(GUEST_S_CET, 0);
> +	vmcs_writel(GUEST_INTR_SSP_TABLE, 0);
>  
>  	kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
>  
> @@ -6354,6 +6358,12 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
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
> @@ -6431,6 +6441,12 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
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
> @@ -7967,7 +7983,6 @@ static __init void vmx_set_cpu_caps(void)
>  		kvm_cpu_cap_set(X86_FEATURE_UMIP);
>  
>  	/* CPUID 0xD.1 */
> -	kvm_caps.supported_xss = 0;
>  	if (!cpu_has_vmx_xsaves())
>  		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
>  
> @@ -7979,6 +7994,12 @@ static __init void vmx_set_cpu_caps(void)
>  
>  	if (cpu_has_vmx_waitpkg())
>  		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
> +
> +	if (!cpu_has_load_cet_ctrl() || !enable_unrestricted_guest ||
> +	    !cpu_has_vmx_basic_no_hw_errcode()) {
> +		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
> +		kvm_cpu_cap_clear(X86_FEATURE_IBT);

I think that here we also need to clear kvm_caps.supported_xss,
or even better, lets set the CET bits in kvm_caps.supported_xss only
once CET is fully enabled (both this check and check in __kvm_x86_vendor_init pass).

> +	}
>  }
>  
>  static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index c2130d2c8e24..fb72819fbb41 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -480,7 +480,8 @@ static inline u8 vmx_get_rvi(void)
>  	 VM_ENTRY_LOAD_IA32_EFER |					\
>  	 VM_ENTRY_LOAD_BNDCFGS |					\
>  	 VM_ENTRY_PT_CONCEAL_PIP |					\
> -	 VM_ENTRY_LOAD_IA32_RTIT_CTL)
> +	 VM_ENTRY_LOAD_IA32_RTIT_CTL |					\
> +	 VM_ENTRY_LOAD_CET_STATE)
>  
>  #define __KVM_REQUIRED_VMX_VM_EXIT_CONTROLS				\
>  	(VM_EXIT_SAVE_DEBUG_CONTROLS |					\
> @@ -502,7 +503,8 @@ static inline u8 vmx_get_rvi(void)
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
> index 231d4a7b6f3d..b7d1ac6b8d75 100644
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
> @@ -9699,6 +9700,15 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
>  		kvm_caps.supported_xss = 0;
>  
> +	if ((kvm_caps.supported_xss & (XFEATURE_MASK_CET_USER |
> +	     XFEATURE_MASK_CET_KERNEL)) !=
> +	    (XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)) {
> +		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
> +		kvm_cpu_cap_clear(X86_FEATURE_IBT);
> +		kvm_caps.supported_xss &= ~XFEATURE_CET_USER;
> +		kvm_caps.supported_xss &= ~XFEATURE_CET_KERNEL;
> +	}
> +
>  #define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
>  	cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
>  #undef __kvm_cpu_cap_has
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 0d5f673338dd..665a7f91d04f 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -530,6 +530,9 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
>  		__reserved_bits |= X86_CR4_VMXE;        \
>  	if (!__cpu_has(__c, X86_FEATURE_PCID))          \
>  		__reserved_bits |= X86_CR4_PCIDE;       \
> +	if (!__cpu_has(__c, X86_FEATURE_SHSTK) &&       \
> +	    !__cpu_has(__c, X86_FEATURE_IBT))           \
> +		__reserved_bits |= X86_CR4_CET;         \
>  	__reserved_bits;                                \
>  })
>  


Best regards,
	Maxim Levitsky







