Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0BB3539493
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 17:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345957AbiEaP6w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 11:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235314AbiEaP6u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 11:58:50 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BABA811A2F;
        Tue, 31 May 2022 08:58:49 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id u12so1866820eja.8;
        Tue, 31 May 2022 08:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dL+hwlnyQfBxIjai3EdOmMP0TtLf4Hp9ALwZGNm7s1I=;
        b=XOubp5zgtznPb77Ok3lMua3tuOw6RGrccijXoaXIYI6B+YlKY85FdBFyGmDUI1t+BQ
         6I2rYAgxP1S24Hdy94cWBMCl4MyTEyNUtOOovqJ8p6KF22IRaODdwVa3Q3rIHTb92EFr
         vSKrNzDXaNLxve32W6um0RIWYlgqC+a0s+dZdNdHfjPvWyYQt+36s/HLQbIXDgoiQC0x
         EmD5lbGgtysNvTdXKlZZm/r2Nx8cC5l1w9moz2XHkpcnDVLwPBv/HTe3cPJwIK4H+xsL
         iMu+ki2J26ypNdTZ2ltEqN1XqQowjYVR/mTPKYRs1tWmJD24bL0vdhXjdUqWICQU7/D+
         cndw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dL+hwlnyQfBxIjai3EdOmMP0TtLf4Hp9ALwZGNm7s1I=;
        b=wZrcW02HaNV7klJySm7k0Z1SeJFHZUgz4kRO4sHRADHNc95suzZ0zmmzuj2y6yXsQ6
         AMx1Q6yL1diLSBG9h0ostRXXsi7xjj4jH0z9UqCpZaJZcscsavVuo+KCif7b8l4lyqxE
         YpSzfEXdFJ/iXTxcxvizIu7yMutChhLYNPvF1Q+cEVzDg3PLc9GzoBrJG36qeiBUNpHO
         ttPlZBwHQjsoh8LBHmp6g20Nb5AvDNtYCusTQdr1GaAeMgvhjm8ny+kdE1xJhkNRwQPZ
         xGdYhcUxF5nH1emnf1OCuA7w0IIdn9POGMsxp5o1Se5UpihJO5RwFy1JUn3ed+g8LFHS
         g5PA==
X-Gm-Message-State: AOAM530MgAj0fwPRnyCl0d+kmTUcVHF/sDvDAg9HtKfTX+K4kvcnBlMY
        X4dYT5KU+5AlizBlilRg3hI=
X-Google-Smtp-Source: ABdhPJxJKg+EefuQIDZlUs/hl/kmxPY3U2eFBxdlW2gOWQ2YIvGn2x8FMhH2IVwpjNLjdE7Drm8C2Q==
X-Received: by 2002:a17:907:724b:b0:6ff:2ed0:957 with SMTP id ds11-20020a170907724b00b006ff2ed00957mr20309634ejc.445.1654012728164;
        Tue, 31 May 2022 08:58:48 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id h17-20020a1709060f5100b006f3ef214da6sm5203607ejj.12.2022.05.31.08.58.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 08:58:47 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <bf76a63c-c687-34bf-4c46-ecc9cea575eb@redhat.com>
Date:   Tue, 31 May 2022 17:58:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [RFC PATCH v6 064/104] KVM: TDX: Add helper assembly function to
 TDX vcpu
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
 <f40b7827026d65963fea84d4af78cb1cbca85149.1651774250.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <f40b7827026d65963fea84d4af78cb1cbca85149.1651774250.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/5/22 20:14, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TDX defines an API to run TDX vcpu with its own ABI.  Define an assembly
> helper function to run TDX vcpu to hide the special ABI so that C code can
> call it with function call ABI.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

"ret" needs to be "RET" to support SLS mitigation.

Paolo

> ---
>   arch/x86/kvm/vmx/vmenter.S | 146 +++++++++++++++++++++++++++++++++++++
>   1 file changed, 146 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index 435c187927c4..f655bcca0e93 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -2,6 +2,7 @@
>   #include <linux/linkage.h>
>   #include <asm/asm.h>
>   #include <asm/bitsperlong.h>
> +#include <asm/errno.h>
>   #include <asm/kvm_vcpu_regs.h>
>   #include <asm/nospec-branch.h>
>   #include <asm/segment.h>
> @@ -28,6 +29,13 @@
>   #define VCPU_R15	__VCPU_REGS_R15 * WORD_SIZE
>   #endif
>   
> +#ifdef CONFIG_INTEL_TDX_HOST
> +#define TDENTER 		0
> +#define EXIT_REASON_TDCALL	77
> +#define TDENTER_ERROR_BIT	63
> +#define seamcall		.byte 0x66,0x0f,0x01,0xcf
> +#endif
> +
>   .section .noinstr.text, "ax"
>   
>   /**
> @@ -328,3 +336,141 @@ SYM_FUNC_START(vmx_do_interrupt_nmi_irqoff)
>   	pop %_ASM_BP
>   	RET
>   SYM_FUNC_END(vmx_do_interrupt_nmi_irqoff)
> +
> +#ifdef CONFIG_INTEL_TDX_HOST
> +
> +.pushsection .noinstr.text, "ax"
> +
> +/**
> + * __tdx_vcpu_run - Call SEAMCALL(TDENTER) to run a TD vcpu
> + * @tdvpr:	physical address of TDVPR
> + * @regs:	void * (to registers of TDVCPU)
> + * @gpr_mask:	non-zero if guest registers need to be loaded prior to TDENTER
> + *
> + * Returns:
> + *	TD-Exit Reason
> + *
> + * Note: KVM doesn't support using XMM in its hypercalls, it's the HyperV
> + *	 code's responsibility to save/restore XMM registers on TDVMCALL.
> + */
> +SYM_FUNC_START(__tdx_vcpu_run)
> +	push %rbp
> +	mov  %rsp, %rbp
> +
> +	push %r15
> +	push %r14
> +	push %r13
> +	push %r12
> +	push %rbx
> +
> +	/* Save @regs, which is needed after TDENTER to capture output. */
> +	push %rsi
> +
> +	/* Load @tdvpr to RCX */
> +	mov %rdi, %rcx
> +
> +	/* No need to load guest GPRs if the last exit wasn't a TDVMCALL. */
> +	test %dx, %dx
> +	je 1f
> +
> +	/* Load @regs to RAX, which will be clobbered with $TDENTER anyways. */
> +	mov %rsi, %rax
> +
> +	mov VCPU_RBX(%rax), %rbx
> +	mov VCPU_RDX(%rax), %rdx
> +	mov VCPU_RBP(%rax), %rbp
> +	mov VCPU_RSI(%rax), %rsi
> +	mov VCPU_RDI(%rax), %rdi
> +
> +	mov VCPU_R8 (%rax),  %r8
> +	mov VCPU_R9 (%rax),  %r9
> +	mov VCPU_R10(%rax), %r10
> +	mov VCPU_R11(%rax), %r11
> +	mov VCPU_R12(%rax), %r12
> +	mov VCPU_R13(%rax), %r13
> +	mov VCPU_R14(%rax), %r14
> +	mov VCPU_R15(%rax), %r15
> +
> +	/*  Load TDENTER to RAX.  This kills the @regs pointer! */
> +1:	mov $TDENTER, %rax
> +
> +2:	seamcall
> +
> +	/* Skip to the exit path if TDENTER failed. */
> +	bt $TDENTER_ERROR_BIT, %rax
> +	jc 4f
> +
> +	/* Temporarily save the TD-Exit reason. */
> +	push %rax
> +
> +	/* check if TD-exit due to TDVMCALL */
> +	cmp $EXIT_REASON_TDCALL, %ax
> +
> +	/* Reload @regs to RAX. */
> +	mov 8(%rsp), %rax
> +
> +	/* Jump on non-TDVMCALL */
> +	jne 3f
> +
> +	/* Save all output from SEAMCALL(TDENTER) */
> +	mov %rbx, VCPU_RBX(%rax)
> +	mov %rbp, VCPU_RBP(%rax)
> +	mov %rsi, VCPU_RSI(%rax)
> +	mov %rdi, VCPU_RDI(%rax)
> +	mov %r10, VCPU_R10(%rax)
> +	mov %r11, VCPU_R11(%rax)
> +	mov %r12, VCPU_R12(%rax)
> +	mov %r13, VCPU_R13(%rax)
> +	mov %r14, VCPU_R14(%rax)
> +	mov %r15, VCPU_R15(%rax)
> +
> +3:	mov %rcx, VCPU_RCX(%rax)
> +	mov %rdx, VCPU_RDX(%rax)
> +	mov %r8,  VCPU_R8 (%rax)
> +	mov %r9,  VCPU_R9 (%rax)
> +
> +	/*
> +	 * Clear all general purpose registers except RSP and RAX to prevent
> +	 * speculative use of the guest's values.
> +	 */
> +	xor %rbx, %rbx
> +	xor %rcx, %rcx
> +	xor %rdx, %rdx
> +	xor %rsi, %rsi
> +	xor %rdi, %rdi
> +	xor %rbp, %rbp
> +	xor %r8,  %r8
> +	xor %r9,  %r9
> +	xor %r10, %r10
> +	xor %r11, %r11
> +	xor %r12, %r12
> +	xor %r13, %r13
> +	xor %r14, %r14
> +	xor %r15, %r15
> +
> +	/* Restore the TD-Exit reason to RAX for return. */
> +	pop %rax
> +
> +	/* "POP" @regs. */
> +4:	add $8, %rsp
> +	pop %rbx
> +	pop %r12
> +	pop %r13
> +	pop %r14
> +	pop %r15
> +
> +	pop %rbp
> +	ret
> +
> +5:	cmpb $0, kvm_rebooting
> +	je 6f
> +	mov $-EFAULT, %rax
> +	jmp 4b
> +6:	ud2
> +	_ASM_EXTABLE(2b, 5b)
> +
> +SYM_FUNC_END(__tdx_vcpu_run)
> +
> +.popsection
> +
> +#endif

