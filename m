Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFC664D75BD
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 15:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234536AbiCMOL5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 10:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231891AbiCMOL4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 10:11:56 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433BC1BEAF;
        Sun, 13 Mar 2022 07:10:48 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id k24so20042761wrd.7;
        Sun, 13 Mar 2022 07:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4aFK9mBpkvT45vdXvtUPbOPeqIIUt+cfAG5SpZ8nSsY=;
        b=NnKJWDky3EwghrgU6lXaBIzjvG83zK75jHAVpZD/owJAa01KJnl8OU+yRdpWsqmvzJ
         M404WKLHCpLnaAERShRkzjQiUP129CVuo1M2wf4xoWKaqfBvfu/uNQizgoaq+/L50WDY
         IsmXOwqM5rJMzwTE7TfxPAycg2rUYk5bN/RBhdcimS5rKzQmrxKmqjrvACk8mr4nCdFW
         OzzEadkAt4Z60rrTFvAnL/3ioqjAG2dhHi05ltaGdND7nZj4MxzPKR8hfngYfxSqWCNF
         mj/DdoIW76f62wevWXHZ/p03d5dfk6ObQ07yC+Zuz06y/1lG8xKsN+fjK/QrJBYXeAIi
         EJ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4aFK9mBpkvT45vdXvtUPbOPeqIIUt+cfAG5SpZ8nSsY=;
        b=BuSQYKuDEWeY6+Uez/3iTBW58LY/hZ6KFDY7WYNLM6eehY80R3dMA8DLDfh+eIw3yU
         ub7ImYAK35N1eiMaTefwJ7Dp/NCQ+5quNTf+ScV9gzg7Glzg4eBffIjrLgc1Q+OIRtNp
         bqTDohUJipJI/ZmSa9yDXF620VUZkYq9m/FBl7k6VXNeOGy+pd42QcWphzt8hYuUQle1
         9uh5iu/YSOZKRSNvyx45tEmC2e1Xp64vVJ1PtJW7GU8xLfPD4vYNiFAbinDCLTNfap4N
         nzLho+U2+rChNMVikKLyGR8+d9Gq/jLtLOvQrtzWkblW6Iup/J48FraMyi8L7cFpzI2/
         nbKA==
X-Gm-Message-State: AOAM5321H+YEQc1RsSYFo1eBHwrvyad0GXtvtdF5B070qkjlW2ZgaErd
        SkT7H7qbbPLbL4jihupb3f4=
X-Google-Smtp-Source: ABdhPJyKev8Jo7MkMQ00loMleW6jWhNPSA77KezvHP3mBKNegBY/1noVGFcTrhmpjYOtf45Tsh/5Qg==
X-Received: by 2002:a5d:5846:0:b0:203:6b34:37af with SMTP id i6-20020a5d5846000000b002036b3437afmr14286095wrf.58.1647180646773;
        Sun, 13 Mar 2022 07:10:46 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id j17-20020a05600c191100b00389a1a68b95sm31968300wmq.27.2022.03.13.07.10.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Mar 2022 07:10:46 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <6e2087ee-29a6-b95c-8082-7cdc63bcf381@redhat.com>
Date:   Sun, 13 Mar 2022 15:10:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v5 014/104] KVM: TDX: Add a function for KVM to invoke
 SEAMCALL
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <355f08931d2b1917fd7230393de6f1052bf6f0c9.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <355f08931d2b1917fd7230393de6f1052bf6f0c9.1646422845.git.isaku.yamahata@intel.com>
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
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add an assembly function for KVM to call the TDX module because __seamcall
> defined in arch/x86/virt/vmx/seamcall.S doesn't fit for the KVM use case.
> 
> TDX module API returns extended error information in registers, rcx, rdx,
> r8, r9, r10, and r11 in addition to success case.  KVM uses those extended
> error information in addition to the status code returned in RAX.  Update
> the assembly code to optionally return those outputs even in the error case
> and define the specific version for KVM to call the TDX module.
> 
> SEAMCALL to the SEAM module (P-SEAMLDR or TDX module) can result in the
> error of VmFailInvalid indicated by CF=1 when VMX isn't enabled by VMXON
> instruction.  Because KVM guarantees that VMX is enabled, VmFailInvalid
> error won't happen.  Don't check the error for KVM.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/Makefile       |  2 +-
>   arch/x86/kvm/vmx/seamcall.S | 55 +++++++++++++++++++++++++++++++++++++
>   arch/x86/virt/tdxcall.S     |  8 ++++--
>   3 files changed, 62 insertions(+), 3 deletions(-)
>   create mode 100644 arch/x86/kvm/vmx/seamcall.S
> 
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index e2c05195cb95..e8f83a7d0dc3 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -24,7 +24,7 @@ kvm-$(CONFIG_KVM_XEN)	+= xen.o
>   kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
>   			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o vmx/main.o
>   kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
> -kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o
> +kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o vmx/seamcall.o
>   
>   kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o svm/sev.o
>   
> diff --git a/arch/x86/kvm/vmx/seamcall.S b/arch/x86/kvm/vmx/seamcall.S
> new file mode 100644
> index 000000000000..4a15017fc7dd
> --- /dev/null
> +++ b/arch/x86/kvm/vmx/seamcall.S
> @@ -0,0 +1,55 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#include <linux/linkage.h>
> +#include <asm/export.h>
> +#include <asm/frame.h>
> +
> +#include "../../virt/tdxcall.S"
> +
> +/*
> + * kvm_seamcall()  - Host-side interface functions to SEAM software (TDX module)
> + *
> + * Transform function call register arguments into the SEAMCALL register
> + * ABI.  Return the completion status of the SEAMCALL.  Additional output
> + * operands are saved in @out (if it is provided by the user).
> + * It doesn't check TDX_SEAMCALL_VMFAILINVALID unlike __semcall() because KVM
> + * guarantees that VMX is enabled so that TDX_SEAMCALL_VMFAILINVALID doesn't
> + * happen.  In the case of error completion status code, extended error code may
> + * be stored in leaf specific output registers.
> + *
> + *-------------------------------------------------------------------------
> + * SEAMCALL ABI:
> + *-------------------------------------------------------------------------
> + * Input Registers:
> + *
> + * RAX                 - SEAMCALL Leaf number.
> + * RCX,RDX,R8-R9       - SEAMCALL Leaf specific input registers.
> + *
> + * Output Registers:
> + *
> + * RAX                 - SEAMCALL completion status code.
> + * RCX,RDX,R8-R11      - SEAMCALL Leaf specific output registers.
> + *
> + *-------------------------------------------------------------------------
> + *
> + * kvm_seamcall() function ABI:
> + *
> + * @fn  (RDI)          - SEAMCALL Leaf number, moved to RAX
> + * @rcx (RSI)          - Input parameter 1, moved to RCX
> + * @rdx (RDX)          - Input parameter 2, moved to RDX
> + * @r8  (RCX)          - Input parameter 3, moved to R8
> + * @r9  (R8)           - Input parameter 4, moved to R9
> + *
> + * @out (R9)           - struct tdx_module_output pointer
> + *                       stored temporarily in R12 (not
> + *                       shared with the TDX module). It
> + *                       can be NULL.
> + *
> + * Return (via RAX) the completion status of the SEAMCALL
> + */
> +SYM_FUNC_START(kvm_seamcall)
> +        FRAME_BEGIN
> +        TDX_MODULE_CALL host=1 error_check=0
> +        FRAME_END
> +        ret
> +SYM_FUNC_END(kvm_seamcall)
> +EXPORT_SYMBOL_GPL(kvm_seamcall)
> diff --git a/arch/x86/virt/tdxcall.S b/arch/x86/virt/tdxcall.S
> index 90569faedacc..2e614b6b5f1e 100644
> --- a/arch/x86/virt/tdxcall.S
> +++ b/arch/x86/virt/tdxcall.S
> @@ -13,7 +13,7 @@
>   #define tdcall		.byte 0x66,0x0f,0x01,0xcc
>   #define seamcall	.byte 0x66,0x0f,0x01,0xcf
>   
> -.macro TDX_MODULE_CALL host:req
> +.macro TDX_MODULE_CALL host:req error_check=1

Perhaps name this argument ext_error_out and reverse it (that is, 0 is 
the current behavior while 1 is what KVM needs).

Paolo

>   	/*
>   	 * R12 will be used as temporary storage for struct tdx_module_output
>   	 * pointer. Since R12-R15 registers are not used by TDCALL/SEAMCALL
> @@ -51,9 +51,11 @@
>   	 *
>   	 * Set %rax to TDX_SEAMCALL_VMFAILINVALID for VMfailInvalid.
>   	 * This value will never be used as actual SEAMCALL error code.
> -	 */
> +	*/
> +	.if \error_check
>   	jnc .Lno_vmfailinvalid
>   	mov $TDX_SEAMCALL_VMFAILINVALID, %rax
> +	.endif
>   .Lno_vmfailinvalid:
>   	.else
>   	tdcall
> @@ -66,8 +68,10 @@
>   	pop %r12
>   
>   	/* Check for success: 0 - Successful, otherwise failed */
> +	.if \error_check
>   	test %rax, %rax
>   	jnz .Lno_output_struct
> +	.endif
>   
>   	/*
>   	 * Since this function can be initiated without an output pointer,

