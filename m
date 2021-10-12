Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 569F442AABB
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 19:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbhJLRcK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 13:32:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46340 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231886AbhJLRcJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Oct 2021 13:32:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634059806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nJCGcnKEbIqqHMfmUDpnKvwtwd5KiHx7SBZCiGYW5Nc=;
        b=OBnojTsO4CqW8LjqRPoqYZLOjw5yrQnxZec+b07wEnhoOXeMKqizMGPHUBahd3PnPg9Vd2
        RL5EJqadT5HqNwp92zfrF/56UQExrmOAq4E1lBAG4Trk95qNcufpv4BuNgoh49wqcb10hi
        +kHOsKVYoCm2+oqk773rAUM9AX6+iUY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-OzGFw6qcOsqbGCHCqpGeXg-1; Tue, 12 Oct 2021 13:30:05 -0400
X-MC-Unique: OzGFw6qcOsqbGCHCqpGeXg-1
Received: by mail-wr1-f69.google.com with SMTP id j19-20020adfb313000000b00160a9de13b3so16348657wrd.8
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 10:30:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nJCGcnKEbIqqHMfmUDpnKvwtwd5KiHx7SBZCiGYW5Nc=;
        b=wcJ56RnwGYue1KAikHtvsozCtoalF4txkygIpG8Y2/lo71IYkEkpEiYft8I8G2nUZC
         iTjMhY/eN6sd+XPLeFY20QJ+HpJ6RBlLZg4wnzthoE7KhDIIiTPTiYJS8LxqKEw3z9B5
         Qrfe6jDSImVAUuRLYdgtY+1IZ0XVeUGcjZ328uhCKp09TqxTx4SYWXjTHAkRqhXvVRE0
         D0l1zX4KJd1uHRUu1YY+kmR6hvj7xaWLRk50OwVuHB4OUIg+hsXFsZz0KLYpJXDFAYqD
         4xQz5g4XqgUoyOBCDOmAN7Bec8jfcMTRjLp9gpYGlvmgQy+k8LzqhjNWl4XYGhPd8rdj
         jiuQ==
X-Gm-Message-State: AOAM533WdXQ9fFFLqmE3m5NERAOjEXQq3SA7S0gpKdtoiyFcjTtt8dFK
        tPMkSZGyRWnYFtnbXL/jqetXfwQdcCu57pNv769QmL6OhTqH9lDTcDI8FRff3axNG6nby07tu7b
        ez1XjqVCuS2na
X-Received: by 2002:a7b:c08b:: with SMTP id r11mr6983643wmh.167.1634059803815;
        Tue, 12 Oct 2021 10:30:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxajnlq/YMP+te0l4ShanGzhvQVEbgsTy6Ll0MJfqn5Q8TCYVC10ObVnmGHZ8yW3jEoeiHIcA==
X-Received: by 2002:a7b:c08b:: with SMTP id r11mr6983605wmh.167.1634059803498;
        Tue, 12 Oct 2021 10:30:03 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g25sm11692781wrc.88.2021.10.12.10.30.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 10:30:02 -0700 (PDT)
Message-ID: <826f57f5-c312-86d1-598b-3f9ac1fc98ac@redhat.com>
Date:   Tue, 12 Oct 2021 19:30:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [patch 14/31] x86/fpu: Replace KVMs homebrewn FPU copy from user
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org
References: <20211011215813.558681373@linutronix.de>
 <20211011223611.129308001@linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211011223611.129308001@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/10/21 02:00, Thomas Gleixner wrote:
> Copying a user space buffer to the memory buffer is already available in
> the FPU core. The copy mechanism in KVM lacks sanity checks and needs to
> use cpuid() to lookup the offset of each component, while the FPU core has
> this information cached.
> 
> Make the FPU core variant accessible for KVM and replace the homebrewn
> mechanism.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: kvm@vger.kernel.org
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/include/asm/fpu/api.h |    3 +
>   arch/x86/kernel/fpu/core.c     |   38 ++++++++++++++++++++-
>   arch/x86/kernel/fpu/xstate.c   |    3 -
>   arch/x86/kvm/x86.c             |   74 +----------------------------------------
>   4 files changed, 44 insertions(+), 74 deletions(-)
> 
> --- a/arch/x86/include/asm/fpu/api.h
> +++ b/arch/x86/include/asm/fpu/api.h
> @@ -116,4 +116,7 @@ extern void fpu_init_fpstate_user(struct
>   /* KVM specific functions */
>   extern void fpu_swap_kvm_fpu(struct fpu *save, struct fpu *rstor, u64 restore_mask);
>   
> +struct kvm_vcpu;
> +extern int fpu_copy_kvm_uabi_to_vcpu(struct fpu *fpu, const void *buf, u64 xcr0, u32 *pkru);
> +
>   #endif /* _ASM_X86_FPU_API_H */
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -174,7 +174,43 @@ void fpu_swap_kvm_fpu(struct fpu *save,
>   	fpregs_unlock();
>   }
>   EXPORT_SYMBOL_GPL(fpu_swap_kvm_fpu);
> -#endif
> +
> +int fpu_copy_kvm_uabi_to_vcpu(struct fpu *fpu, const void *buf, u64 xcr0,
> +			      u32 *vpkru)
> +{
> +	union fpregs_state *kstate = &fpu->state;
> +	const union fpregs_state *ustate = buf;
> +	struct pkru_state *xpkru;
> +	int ret;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_XSAVE)) {
> +		if (ustate->xsave.header.xfeatures & ~XFEATURE_MASK_FPSSE)
> +			return -EINVAL;
> +		if (ustate->fxsave.mxcsr & ~mxcsr_feature_mask)
> +			return -EINVAL;
> +		memcpy(&kstate->fxsave, &ustate->fxsave, sizeof(ustate->fxsave));
> +		return 0;
> +	}
> +
> +	if (ustate->xsave.header.xfeatures & ~xcr0)
> +		return -EINVAL;
> +
> +	ret = copy_uabi_from_kernel_to_xstate(&kstate->xsave, ustate);
> +	if (ret)
> +		return ret;
> +
> +	/* Retrieve PKRU if not in init state */
> +	if (kstate->xsave.header.xfeatures & XFEATURE_MASK_PKRU) {
> +		xpkru = get_xsave_addr(&kstate->xsave, XFEATURE_PKRU);
> +		*vpkru = xpkru->pkru;
> +	}
> +
> +	/* Ensure that XCOMP_BV is set up for XSAVES */
> +	xstate_init_xcomp_bv(&kstate->xsave, xfeatures_mask_uabi());
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(fpu_copy_kvm_uabi_to_vcpu);
> +#endif /* CONFIG_KVM */
>   
>   void kernel_fpu_begin_mask(unsigned int kfpu_mask)
>   {
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -1134,8 +1134,7 @@ static int copy_uabi_to_xstate(struct xr
>   
>   /*
>    * Convert from a ptrace standard-format kernel buffer to kernel XSAVE[S]
> - * format and copy to the target thread. This is called from
> - * xstateregs_set().
> + * format and copy to the target thread. Used by ptrace and KVM.
>    */
>   int copy_uabi_from_kernel_to_xstate(struct xregs_state *xsave, const void *kbuf)
>   {
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4695,8 +4695,6 @@ static int kvm_vcpu_ioctl_x86_set_debugr
>   	return 0;
>   }
>   
> -#define XSTATE_COMPACTION_ENABLED (1ULL << 63)
> -
>   static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
>   {
>   	struct xregs_state *xsave = &vcpu->arch.guest_fpu->state.xsave;
> @@ -4740,50 +4738,6 @@ static void fill_xsave(u8 *dest, struct
>   	}
>   }
>   
> -static void load_xsave(struct kvm_vcpu *vcpu, u8 *src)
> -{
> -	struct xregs_state *xsave = &vcpu->arch.guest_fpu->state.xsave;
> -	u64 xstate_bv = *(u64 *)(src + XSAVE_HDR_OFFSET);
> -	u64 valid;
> -
> -	/*
> -	 * Copy legacy XSAVE area, to avoid complications with CPUID
> -	 * leaves 0 and 1 in the loop below.
> -	 */
> -	memcpy(xsave, src, XSAVE_HDR_OFFSET);
> -
> -	/* Set XSTATE_BV and possibly XCOMP_BV.  */
> -	xsave->header.xfeatures = xstate_bv;
> -	if (boot_cpu_has(X86_FEATURE_XSAVES))
> -		xsave->header.xcomp_bv = host_xcr0 | XSTATE_COMPACTION_ENABLED;
> -
> -	/*
> -	 * Copy each region from the non-compacted offset to the
> -	 * possibly compacted offset.
> -	 */
> -	valid = xstate_bv & ~XFEATURE_MASK_FPSSE;
> -	while (valid) {
> -		u32 size, offset, ecx, edx;
> -		u64 xfeature_mask = valid & -valid;
> -		int xfeature_nr = fls64(xfeature_mask) - 1;
> -
> -		cpuid_count(XSTATE_CPUID, xfeature_nr,
> -			    &size, &offset, &ecx, &edx);
> -
> -		if (xfeature_nr == XFEATURE_PKRU) {
> -			memcpy(&vcpu->arch.pkru, src + offset,
> -			       sizeof(vcpu->arch.pkru));
> -		} else {
> -			void *dest = get_xsave_addr(xsave, xfeature_nr);
> -
> -			if (dest)
> -				memcpy(dest, src + offset, size);
> -		}
> -
> -		valid -= xfeature_mask;
> -	}
> -}
> -
>   static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
>   					 struct kvm_xsave *guest_xsave)
>   {
> @@ -4802,37 +4756,15 @@ static void kvm_vcpu_ioctl_x86_get_xsave
>   	}
>   }
>   
> -#define XSAVE_MXCSR_OFFSET 24
> -
>   static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
>   					struct kvm_xsave *guest_xsave)
>   {
> -	u64 xstate_bv;
> -	u32 mxcsr;
> -
>   	if (!vcpu->arch.guest_fpu)
>   		return 0;
>   
> -	xstate_bv = *(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)];
> -	mxcsr = *(u32 *)&guest_xsave->region[XSAVE_MXCSR_OFFSET / sizeof(u32)];
> -
> -	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
> -		/*
> -		 * Here we allow setting states that are not present in
> -		 * CPUID leaf 0xD, index 0, EDX:EAX.  This is for compatibility
> -		 * with old userspace.
> -		 */
> -		if (xstate_bv & ~supported_xcr0 || mxcsr & ~mxcsr_feature_mask)
> -			return -EINVAL;
> -		load_xsave(vcpu, (u8 *)guest_xsave->region);
> -	} else {
> -		if (xstate_bv & ~XFEATURE_MASK_FPSSE ||
> -			mxcsr & ~mxcsr_feature_mask)
> -			return -EINVAL;
> -		memcpy(&vcpu->arch.guest_fpu->state.fxsave,
> -			guest_xsave->region, sizeof(struct fxregs_state));
> -	}
> -	return 0;
> +	return fpu_copy_kvm_uabi_to_vcpu(vcpu->arch.guest_fpu,
> +					 guest_xsave->region,
> +					 supported_xcr0, &vcpu->arch.pkru);
>   }
>   
>   static void kvm_vcpu_ioctl_x86_get_xcrs(struct kvm_vcpu *vcpu,
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

