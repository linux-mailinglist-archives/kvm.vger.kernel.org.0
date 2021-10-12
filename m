Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A61A142AAA9
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 19:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbhJLRYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 13:24:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34842 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232360AbhJLRYU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Oct 2021 13:24:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634059337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RJ4hKggkAg1oAa2rnQG+wzzAGkhAl0EY2OE5++4GObU=;
        b=GRHXfUILnFuISMr9lA5EomcRJdnuTIxlaniKfz6pIXXvLk4naKRYRKutKEJl2i7HkkuD9h
        0ICfhZwg7IfE8IkzZOi68mfu5bmHLK8OWRQ1d0vJoHQs1QI/ufadZKFXO65+bgWWLw3okZ
        RpmO+9CUTm/+1wBLRuEzLMIQqAbggBM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-47MTgVlMNsKeOFz55XC4IQ-1; Tue, 12 Oct 2021 13:22:16 -0400
X-MC-Unique: 47MTgVlMNsKeOFz55XC4IQ-1
Received: by mail-wr1-f72.google.com with SMTP id f11-20020adfc98b000000b0015fedc2a8d4so16362910wrh.0
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 10:22:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RJ4hKggkAg1oAa2rnQG+wzzAGkhAl0EY2OE5++4GObU=;
        b=Kjol2tUknqRSoF0/bYqkej1CKUzuXILDmUJ7YcnAv3EyKawh38QeDWiEJw7DCDFs6I
         Ly9khyf2zqt4fiLMaRRhPUXAFoydqGEYCDuoLA8lhF+bCxbZ787z7OgoVP7kQG25Q+Mt
         qosQgZsBFCwFZ+hXxBQskEJnR6X5HC0m7Hmentf+nh+y7QNKc8eSb2dXYTbncAfd+kkc
         rjKfTSGjSME/81M8Bs2qY4HlgvcKHzU5l6rk0vKahMS2I8KN1XctMaRhQs30thYNCU9d
         Xht5i56aWJUmKVeubLf9cYFMqb3SGNBO3F6syzbW5J5gUoO/nsW4lLRg2PILvtaZgVSG
         bPlQ==
X-Gm-Message-State: AOAM531BckvWsvzqWhfmeKAFlXvarFpBJhLAScsaMwBtL0AqfsEGgonn
        1flhme26NexiGTNhwnB3VT7bC3ZUWyZLe1kF4swD71CniLMskQdbcdvaqVWFIeBNeIGc9n8aqZl
        ytvPyZ1Ke8Ui8
X-Received: by 2002:adf:a390:: with SMTP id l16mr33839916wrb.104.1634059335325;
        Tue, 12 Oct 2021 10:22:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwQZApRtqcdcbKaVEYG74IKLvcLvdupOOoFwEE9VXa/g62lQHLJ4OSprs1zgUHNjnhfy/uy9A==
X-Received: by 2002:adf:a390:: with SMTP id l16mr33839870wrb.104.1634059334928;
        Tue, 12 Oct 2021 10:22:14 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id v23sm3002264wmj.4.2021.10.12.10.22.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 10:22:13 -0700 (PDT)
Message-ID: <8a5762ab-18d5-56f8-78a6-c722a2f387c5@redhat.com>
Date:   Tue, 12 Oct 2021 19:22:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org
References: <20211011215813.558681373@linutronix.de>
 <20211011223611.069324121@linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211011223611.069324121@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/10/21 02:00, Thomas Gleixner wrote:
> Swapping the host/guest FPU is directly fiddling with FPU internals which
> requires 5 exports. The upcoming support of dymanically enabled states
> would even need more.
> 
> Implement a swap function in the FPU core code and export that instead.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: kvm@vger.kernel.org
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/include/asm/fpu/api.h      |    8 +++++
>   arch/x86/include/asm/fpu/internal.h |   15 +---------
>   arch/x86/kernel/fpu/core.c          |   30 ++++++++++++++++++---
>   arch/x86/kernel/fpu/init.c          |    1
>   arch/x86/kernel/fpu/xstate.c        |    1
>   arch/x86/kvm/x86.c                  |   51 +++++++-----------------------------
>   arch/x86/mm/extable.c               |    2 -
>   7 files changed, 48 insertions(+), 60 deletions(-)
> 
> --- a/arch/x86/include/asm/fpu/api.h
> +++ b/arch/x86/include/asm/fpu/api.h
> @@ -12,6 +12,8 @@
>   #define _ASM_X86_FPU_API_H
>   #include <linux/bottom_half.h>
>   
> +#include <asm/fpu/types.h>
> +
>   /*
>    * Use kernel_fpu_begin/end() if you intend to use FPU in kernel context. It
>    * disables preemption so be careful if you intend to use it for long periods
> @@ -108,4 +110,10 @@ extern int cpu_has_xfeatures(u64 xfeatur
>   
>   static inline void update_pasid(void) { }
>   
> +/* FPSTATE related functions which are exported to KVM */
> +extern void fpu_init_fpstate_user(struct fpu *fpu);
> +
> +/* KVM specific functions */
> +extern void fpu_swap_kvm_fpu(struct fpu *save, struct fpu *rstor, u64 restore_mask);
> +
>   #endif /* _ASM_X86_FPU_API_H */
> --- a/arch/x86/include/asm/fpu/internal.h
> +++ b/arch/x86/include/asm/fpu/internal.h
> @@ -74,14 +74,8 @@ static __always_inline __pure bool use_f
>   	return static_cpu_has(X86_FEATURE_FXSR);
>   }
>   
> -/*
> - * fpstate handling functions:
> - */
> -
>   extern union fpregs_state init_fpstate;
> -
>   extern void fpstate_init_user(union fpregs_state *state);
> -extern void fpu_init_fpstate_user(struct fpu *fpu);
>   
>   #ifdef CONFIG_MATH_EMULATION
>   extern void fpstate_init_soft(struct swregs_state *soft);
> @@ -381,12 +375,7 @@ static inline int os_xrstor_safe(struct
>   	return err;
>   }
>   
> -extern void __restore_fpregs_from_fpstate(union fpregs_state *fpstate, u64 mask);
> -
> -static inline void restore_fpregs_from_fpstate(union fpregs_state *fpstate)
> -{
> -	__restore_fpregs_from_fpstate(fpstate, xfeatures_mask_fpstate());
> -}
> +extern void restore_fpregs_from_fpstate(union fpregs_state *fpstate, u64 mask);
>   
>   extern bool copy_fpstate_to_sigframe(void __user *buf, void __user *fp, int size);
>   
> @@ -467,7 +456,7 @@ static inline void fpregs_restore_userre
>   		 */
>   		mask = xfeatures_mask_restore_user() |
>   			xfeatures_mask_supervisor();
> -		__restore_fpregs_from_fpstate(&fpu->state, mask);
> +		restore_fpregs_from_fpstate(&fpu->state, mask);
>   
>   		fpregs_activate(fpu);
>   		fpu->last_cpu = cpu;
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -124,9 +124,8 @@ void save_fpregs_to_fpstate(struct fpu *
>   	asm volatile("fnsave %[fp]; fwait" : [fp] "=m" (fpu->state.fsave));
>   	frstor(&fpu->state.fsave);
>   }
> -EXPORT_SYMBOL(save_fpregs_to_fpstate);
>   
> -void __restore_fpregs_from_fpstate(union fpregs_state *fpstate, u64 mask)
> +void restore_fpregs_from_fpstate(union fpregs_state *fpstate, u64 mask)
>   {
>   	/*
>   	 * AMD K7/K8 and later CPUs up to Zen don't save/restore
> @@ -151,7 +150,31 @@ void __restore_fpregs_from_fpstate(union
>   			frstor(&fpstate->fsave);
>   	}
>   }
> -EXPORT_SYMBOL_GPL(__restore_fpregs_from_fpstate);
> +
> +#if IS_ENABLED(CONFIG_KVM)
> +void fpu_swap_kvm_fpu(struct fpu *save, struct fpu *rstor, u64 restore_mask)
> +{
> +	fpregs_lock();
> +
> +	if (save) {
> +		if (test_thread_flag(TIF_NEED_FPU_LOAD)) {
> +			memcpy(&save->state, &current->thread.fpu.state,
> +			       fpu_kernel_xstate_size);
> +		} else {
> +			save_fpregs_to_fpstate(save);
> +		}
> +	}
> +
> +	if (rstor) {
> +		restore_mask &= xfeatures_mask_fpstate();
> +		restore_fpregs_from_fpstate(&rstor->state, restore_mask);
> +	}
> +
> +	fpregs_mark_activate();
> +	fpregs_unlock();
> +}
> +EXPORT_SYMBOL_GPL(fpu_swap_kvm_fpu);
> +#endif
>   
>   void kernel_fpu_begin_mask(unsigned int kfpu_mask)
>   {
> @@ -459,7 +482,6 @@ void fpregs_mark_activate(void)
>   	fpu->last_cpu = smp_processor_id();
>   	clear_thread_flag(TIF_NEED_FPU_LOAD);
>   }
> -EXPORT_SYMBOL_GPL(fpregs_mark_activate);
>   
>   /*
>    * x87 math exception handling:
> --- a/arch/x86/kernel/fpu/init.c
> +++ b/arch/x86/kernel/fpu/init.c
> @@ -136,7 +136,6 @@ static void __init fpu__init_system_gene
>    * components into a single, continuous memory block:
>    */
>   unsigned int fpu_kernel_xstate_size __ro_after_init;
> -EXPORT_SYMBOL_GPL(fpu_kernel_xstate_size);
>   
>   /* Get alignment of the TYPE. */
>   #define TYPE_ALIGN(TYPE) offsetof(struct { char x; TYPE test; }, test)
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -65,7 +65,6 @@ static short xsave_cpuid_features[] __in
>    * XSAVE buffer, both supervisor and user xstates.
>    */
>   u64 xfeatures_mask_all __ro_after_init;
> -EXPORT_SYMBOL_GPL(xfeatures_mask_all);
>   
>   static unsigned int xstate_offsets[XFEATURE_MAX] __ro_after_init =
>   	{ [ 0 ... XFEATURE_MAX - 1] = -1};
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -68,7 +68,9 @@
>   #include <asm/mce.h>
>   #include <asm/pkru.h>
>   #include <linux/kernel_stat.h>
> -#include <asm/fpu/internal.h> /* Ugh! */
> +#include <asm/fpu/api.h>
> +#include <asm/fpu/xcr.h>
> +#include <asm/fpu/xstate.h>
>   #include <asm/pvclock.h>
>   #include <asm/div64.h>
>   #include <asm/irq_remapping.h>
> @@ -9899,58 +9901,27 @@ static int complete_emulated_mmio(struct
>   	return 0;
>   }
>   
> -static void kvm_save_current_fpu(struct fpu *fpu)
> -{
> -	/*
> -	 * If the target FPU state is not resident in the CPU registers, just
> -	 * memcpy() from current, else save CPU state directly to the target.
> -	 */
> -	if (test_thread_flag(TIF_NEED_FPU_LOAD))
> -		memcpy(&fpu->state, &current->thread.fpu.state,
> -		       fpu_kernel_xstate_size);
> -	else
> -		save_fpregs_to_fpstate(fpu);
> -}
> -
>   /* Swap (qemu) user FPU context for the guest FPU context. */
>   static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
>   {
> -	fpregs_lock();
> -
> -	kvm_save_current_fpu(vcpu->arch.user_fpu);
> -
>   	/*
> -	 * Guests with protected state can't have it set by the hypervisor,
> -	 * so skip trying to set it.
> +	 * Guest with protected state have guest_fpu == NULL which makes
> +	 * the swap only safe the host state. Exclude PKRU from restore as
> +	 * it is restored separately in kvm_x86_ops.run().
>   	 */
> -	if (vcpu->arch.guest_fpu)
> -		/* PKRU is separately restored in kvm_x86_ops.run. */
> -		__restore_fpregs_from_fpstate(&vcpu->arch.guest_fpu->state,
> -					~XFEATURE_MASK_PKRU);
> -
> -	fpregs_mark_activate();
> -	fpregs_unlock();
> -
> +	fpu_swap_kvm_fpu(vcpu->arch.user_fpu, vcpu->arch.guest_fpu,
> +			 ~XFEATURE_MASK_PKRU);
>   	trace_kvm_fpu(1);
>   }
>   
>   /* When vcpu_run ends, restore user space FPU context. */
>   static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
>   {
> -	fpregs_lock();
> -
>   	/*
> -	 * Guests with protected state can't have it read by the hypervisor,
> -	 * so skip trying to save it.
> +	 * Guest with protected state have guest_fpu == NULL which makes
> +	 * swap only restore the host state.
>   	 */
> -	if (vcpu->arch.guest_fpu)
> -		kvm_save_current_fpu(vcpu->arch.guest_fpu);
> -
> -	restore_fpregs_from_fpstate(&vcpu->arch.user_fpu->state);
> -
> -	fpregs_mark_activate();
> -	fpregs_unlock();
> -
> +	fpu_swap_kvm_fpu(vcpu->arch.guest_fpu, vcpu->arch.user_fpu, ~0ULL);
>   	++vcpu->stat.fpu_reload;
>   	trace_kvm_fpu(0);
>   }
> --- a/arch/x86/mm/extable.c
> +++ b/arch/x86/mm/extable.c
> @@ -47,7 +47,7 @@ static bool ex_handler_fprestore(const s
>   	WARN_ONCE(1, "Bad FPU state detected at %pB, reinitializing FPU registers.",
>   		  (void *)instruction_pointer(regs));
>   
> -	__restore_fpregs_from_fpstate(&init_fpstate, xfeatures_mask_fpstate());
> +	restore_fpregs_from_fpstate(&init_fpstate, xfeatures_mask_fpstate());
>   	return true;
>   }
>   
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

