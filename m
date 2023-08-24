Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884077867F2
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 08:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240254AbjHXG5f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 02:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240232AbjHXG5O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 02:57:14 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DE81AD;
        Wed, 23 Aug 2023 23:57:12 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1bf57366ccdso4232775ad.1;
        Wed, 23 Aug 2023 23:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692860232; x=1693465032;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O++FAwpLy1Sw48n/19tu34T/Keo+Dn7i8y+sw2YFXV0=;
        b=XK4k1+wjc6mbThkQsPOmx0jX2sqEJStsXkJqrh9u6XcMFU4+bo2LDkPbsgWHaUuvMF
         TYZmQa9rY2IZEnKWa88/egBYWPkwqKg/FkJmoOVVyktabVsXcA3g9moXdQCPNWXWtKKl
         O5+lUcQrCPNBDmPMx0t1r+irIIHTAqCF8vRo916+vxjSf+ISsQoox5pg3AKfa6LOEUHd
         y5dOPwGkrZGf6qXATvIX6vbaAdjgA2/9uZPx1/6fimjO4eLnqxGowBpiHI72FjZ3LhLQ
         lXzFV5hoC+96SVWEJmy3tqQxUFqXHYbKllJkfvBLHHW3YpD30zVdOdBKRNOY26MNN2i0
         Tuew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692860232; x=1693465032;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O++FAwpLy1Sw48n/19tu34T/Keo+Dn7i8y+sw2YFXV0=;
        b=BPp7V0Vqy77hM5XHtvdYhRGcl1dLwodJLUMFubXRYxp0HcdZ9t1Pr1/w0orqI5DeQ4
         rnCySEvp/ZUnWpE0JEkkc8tIix/t8MES3SDCAB4ugZLqWUm0r5vuDnqI2jY/A3JB6G7f
         wnI+svGnq9VFJ/4fJbuyxJ2U1CJ5Y5MtpsXAYfs3+kdhDHNKOCaE36pSUXQvgeTbC7E/
         /7PeL1w9+xtmpb/m4mK0N2LlT9GmibcwRU1XrusTLhgmfpKcUW5AMjdiMLKwhgRFYud0
         byTimtW37JeB+0hCvuOk9r/ImFEEVK8BZcXlL5mIvbsLH8iDdk8vqszeoFrNJ+U+yxRz
         ZtpQ==
X-Gm-Message-State: AOJu0Ywf0r+nrE9Znhyz1Oko/mngmxN1cgXNnnicprRVpVnoP4HZ5Ocw
        bvyO9LZO8mU5W6dG1sjWoks7Ghf8cwlGORSQ
X-Google-Smtp-Source: AGHT+IGj3L6EUzweJR1xo+63r6rKkk1dXVfEw6dVmgfkcu2gY53x/NZP+E4XqvrkOPF0g5sOHnDb1A==
X-Received: by 2002:a17:903:2443:b0:1bb:c896:1d91 with SMTP id l3-20020a170903244300b001bbc8961d91mr21270824pls.31.1692860231716;
        Wed, 23 Aug 2023 23:57:11 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id u7-20020a170902b28700b001bb9d6b1baasm11987706plr.198.2023.08.23.23.57.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Aug 2023 23:57:11 -0700 (PDT)
Message-ID: <e91f562b-ecdf-6745-a9b1-52fe19126bad@gmail.com>
Date:   Thu, 24 Aug 2023 14:57:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH 7/7] KVM: VMX: Handle NMI VM-Exits in noinstr region
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20221213060912.654668-1-seanjc@google.com>
 <20221213060912.654668-8-seanjc@google.com>
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20221213060912.654668-8-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/12/2022 2:09 pm, Sean Christopherson wrote:
> Move VMX's handling of NMI VM-Exits into vmx_vcpu_enter_exit() so that
> the NMI is handled prior to leaving the safety of noinstr.  Handling the
> NMI after leaving noinstr exposes the kernel to potential ordering
> problems as an instrumentation-induced fault, e.g. #DB, #BP, #PF, etc.
> will unblock NMIs when IRETing back to the faulting instruction.
> 
> Reported-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/vmcs.h    |  4 ++--
>   arch/x86/kvm/vmx/vmenter.S |  8 ++++----
>   arch/x86/kvm/vmx/vmx.c     | 34 +++++++++++++++++++++-------------
>   arch/x86/kvm/x86.h         |  6 +++---
>   4 files changed, 30 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
> index ac290a44a693..7c1996b433e2 100644
> --- a/arch/x86/kvm/vmx/vmcs.h
> +++ b/arch/x86/kvm/vmx/vmcs.h
> @@ -75,7 +75,7 @@ struct loaded_vmcs {
>   	struct vmcs_controls_shadow controls_shadow;
>   };
>   
> -static inline bool is_intr_type(u32 intr_info, u32 type)
> +static __always_inline bool is_intr_type(u32 intr_info, u32 type)
>   {
>   	const u32 mask = INTR_INFO_VALID_MASK | INTR_INFO_INTR_TYPE_MASK;
>   
> @@ -146,7 +146,7 @@ static inline bool is_icebp(u32 intr_info)
>   	return is_intr_type(intr_info, INTR_TYPE_PRIV_SW_EXCEPTION);
>   }
>   
> -static inline bool is_nmi(u32 intr_info)
> +static __always_inline bool is_nmi(u32 intr_info)
>   {
>   	return is_intr_type(intr_info, INTR_TYPE_NMI_INTR);
>   }
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index 9d987e7e48c4..059243085211 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -299,6 +299,10 @@ SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL)
>   
>   SYM_FUNC_END(__vmx_vcpu_run)
>   
> +SYM_FUNC_START(vmx_do_nmi_irqoff)
> +	VMX_DO_EVENT_IRQOFF call asm_exc_nmi_kvm_vmx
> +SYM_FUNC_END(vmx_do_nmi_irqoff)
> +
>   
>   .section .text, "ax"
>   
> @@ -353,10 +357,6 @@ SYM_FUNC_START(vmread_error_trampoline)
>   SYM_FUNC_END(vmread_error_trampoline)
>   #endif
>   
> -SYM_FUNC_START(vmx_do_nmi_irqoff)
> -	VMX_DO_EVENT_IRQOFF call asm_exc_nmi_kvm_vmx
> -SYM_FUNC_END(vmx_do_nmi_irqoff)
> -
>   SYM_FUNC_START(vmx_do_interrupt_irqoff)
>   	VMX_DO_EVENT_IRQOFF CALL_NOSPEC _ASM_ARG1
>   SYM_FUNC_END(vmx_do_interrupt_irqoff)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c242e2591896..b03020ca1840 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5095,8 +5095,13 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>   	vect_info = vmx->idt_vectoring_info;
>   	intr_info = vmx_get_intr_info(vcpu);
>   
> +	/*
> +	 * Machine checks are handled by handle_exception_irqoff(), or by
> +	 * vmx_vcpu_run() if a #MC occurs on VM-Entry.  NMIs are handled by
> +	 * vmx_vcpu_enter_exit().
> +	 */
>   	if (is_machine_check(intr_info) || is_nmi(intr_info))
> -		return 1; /* handled by handle_exception_nmi_irqoff() */
> +		return 1;
>   
>   	/*
>   	 * Queue the exception here instead of in handle_nm_fault_irqoff().
> @@ -6809,7 +6814,7 @@ static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
>   		rdmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
>   }
>   
> -static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
> +static void handle_exception_irqoff(struct vcpu_vmx *vmx)
>   {
>   	u32 intr_info = vmx_get_intr_info(&vmx->vcpu);
>   
> @@ -6822,12 +6827,6 @@ static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
>   	/* Handle machine checks before interrupts are enabled */
>   	else if (is_machine_check(intr_info))
>   		kvm_machine_check();
> -	/* We need to handle NMIs before interrupts are enabled */
> -	else if (is_nmi(intr_info)) {
> -		kvm_before_interrupt(&vmx->vcpu, KVM_HANDLING_NMI);
> -		vmx_do_nmi_irqoff();
> -		kvm_after_interrupt(&vmx->vcpu);
> -	}
>   }
>   
>   static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
> @@ -6857,7 +6856,7 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
>   	if (vmx->exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT)
>   		handle_external_interrupt_irqoff(vcpu);
>   	else if (vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI)
> -		handle_exception_nmi_irqoff(vmx);
> +		handle_exception_irqoff(vmx);
>   }
>   
>   /*
> @@ -7119,6 +7118,18 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
>   
>   	vmx_enable_fb_clear(vmx);
>   
> +	if (unlikely(vmx->fail))
> +		vmx->exit_reason.full = 0xdead;
> +	else
> +		vmx->exit_reason.full = vmcs_read32(VM_EXIT_REASON);
> +
> +	if ((u16)vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI &&
> +	    is_nmi(vmx_get_intr_info(vcpu))) {
> +		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
> +		vmx_do_nmi_irqoff();
> +		kvm_after_interrupt(vcpu);
> +	}

This part of the change brings at least two types of regression:

(1) A simple reproducable case would be to collect PMI inside the guest (e.g. 
via perf),
where the number of guest PMI (a type of NMI) would be very sparse. Further,
this part of the change doesn't call asm_exc_nmi_kvm_vmx as expected and
injects PMI into the guest.

This is because vmx_get_intr_info() depends on this line:
	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
, which is executed after is_nmi(vmx_get_intr_info(vcpu)).

In this case, vmx_get_intr_info() always returned the old value instead of the 
latest
value based on vmcs_read32(VM_EXIT_INTR_INFO).

(2) Even worse, when the control flow is transferred to the host nmi hanlder, 
the context
needed by the host NMI handler is not properly restored:

- update_debugctlmsr(vmx->host_debugctlmsr);
- pt_guest_exit();
- kvm_load_host_xsave_state(); // restore Arch LBR for host nmi hnalder

(3) In addition, trace_kvm_exit() should ideally appear before the host NMI 
trace logs,
which makes it easier to understand.

A proposal fix is to delay vmx_do_nmi_irqoff() a little bit, but not a revert move:

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e6849f780dba..1f29b7f22da7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7230,13 +7230,6 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu 
*vcpu,
  	else
  		vmx->exit_reason.full = vmcs_read32(VM_EXIT_REASON);

-	if ((u16)vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI &&
-	    is_nmi(vmx_get_intr_info(vcpu))) {
-		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
-		vmx_do_nmi_irqoff();
-		kvm_after_interrupt(vcpu);
-	}
-
  	guest_state_exit_irqoff();
  }

@@ -7389,6 +7382,13 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)

  	trace_kvm_exit(vcpu, KVM_ISA_VMX);

+	if ((u16)vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI &&
+	    is_nmi(vmx_get_intr_info(vcpu))) {
+		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
+		vmx_do_nmi_irqoff();
+		kvm_after_interrupt(vcpu);
+	}
+
  	if (unlikely(vmx->exit_reason.failed_vmentry))
  		return EXIT_FASTPATH_NONE;

Please help confirm this change, at least it fixes a lot of vPMI tests.

> +
>   	guest_state_exit_irqoff();
>   }
>   
> @@ -7260,12 +7271,9 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>   
>   	vmx->idt_vectoring_info = 0;
>   
> -	if (unlikely(vmx->fail)) {
> -		vmx->exit_reason.full = 0xdead;
> +	if (unlikely(vmx->fail))
>   		return EXIT_FASTPATH_NONE;
> -	}
>   
> -	vmx->exit_reason.full = vmcs_read32(VM_EXIT_REASON);
>   	if (unlikely((u16)vmx->exit_reason.basic == EXIT_REASON_MCE_DURING_VMENTRY))
>   		kvm_machine_check();
>   
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 9de72586f406..44d1827f0a30 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -382,13 +382,13 @@ enum kvm_intr_type {
>   	KVM_HANDLING_NMI,
>   };
>   
> -static inline void kvm_before_interrupt(struct kvm_vcpu *vcpu,
> -					enum kvm_intr_type intr)
> +static __always_inline void kvm_before_interrupt(struct kvm_vcpu *vcpu,
> +						 enum kvm_intr_type intr)
>   {
>   	WRITE_ONCE(vcpu->arch.handling_intr_from_guest, (u8)intr);
>   }
>   
> -static inline void kvm_after_interrupt(struct kvm_vcpu *vcpu)
> +static __always_inline void kvm_after_interrupt(struct kvm_vcpu *vcpu)
>   {
>   	WRITE_ONCE(vcpu->arch.handling_intr_from_guest, 0);
>   }
