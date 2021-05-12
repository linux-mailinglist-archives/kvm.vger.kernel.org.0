Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41AF637BC26
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 13:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbhELL7y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 07:59:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26183 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230190AbhELL7x (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 May 2021 07:59:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620820725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FKwx6IZPG19pDVBrLRPmNSPMxVfkz9RkPDS/rZEOzoo=;
        b=ZdnXRtoXuekzmfnj/rr1LrsgMtes4nrEbz6o7kkyXgGM+nobUeeZp/jlq8mixmuwBNdHQ3
        N0q4pOlUCt9HnPgNsvpj2N7ZDbJSC0GEC8BPTAY6NEtXzMBZNsO/HZ+RMpNgvwiMZipNaT
        pJVrcSc4Iul/Z0E7z0wd5m8N6TmO+2A=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-570-1Aw-eKhKPsOalRzk8HxIYA-1; Wed, 12 May 2021 07:58:43 -0400
X-MC-Unique: 1Aw-eKhKPsOalRzk8HxIYA-1
Received: by mail-ed1-f70.google.com with SMTP id y17-20020a0564023591b02903886c26ada4so12712630edc.5
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 04:58:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FKwx6IZPG19pDVBrLRPmNSPMxVfkz9RkPDS/rZEOzoo=;
        b=ILMUgxeIkWE/9nDhRVj7P7P4XoTblkJX6HppsOxtSotnQoPIfS6NEPrH8V3lw3p2st
         P5sgwz2YFisOlwGxcAnCTppv/okNxCWau9DDU7nIufST+Yc7+WS+vCznqS/TMznNhK/e
         j2IudgYX00/2bSrH/JPspUtjEm4bFTBovwE284BBRew3DdKfBNeE1sCyZdxeXQjk67yM
         dmFrLbEPHaR2r+G5SKV3KpYe+E72jMzi6t4YRhD430tjs2telRCiihuYONHPOycM78pJ
         +t6llthWqsCLsTganuAaO1E6Q74jpufQiBjLEkbIXCmTC46GS07xDTYjOGl9wLiuALPM
         xHPQ==
X-Gm-Message-State: AOAM532HtkYwC2V+sXW41AaFkOmyGNIirsqOIsfAekcdzG6M+2KEe2Y1
        j5v9Be2YMkzpz9k7KJTe5ktYyprL4of/2k7eYeDVmlIy8n9SrsTpo6WT/jLLUzuju7IOmDpMWmH
        jBEyf6nG4UaEq
X-Received: by 2002:a17:906:d145:: with SMTP id br5mr36394887ejb.452.1620820722093;
        Wed, 12 May 2021 04:58:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJybUd0Tc42hvwn4eweSSMY+FH9zJeezVvz9ozZ2fV9+yx+ryjAuIm14mPDT4/Cr8LOZ9eFGRA==
X-Received: by 2002:a17:906:d145:: with SMTP id br5mr36394868ejb.452.1620820721919;
        Wed, 12 May 2021 04:58:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n15sm14512555eje.118.2021.05.12.04.58.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 04:58:41 -0700 (PDT)
Subject: Re: [PATCH] KVM: SVM/VMX: Use %rax instead of %__ASM_AX within
 CONFIG_X86_64
To:     Uros Bizjak <ubizjak@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210512112115.70048-1-ubizjak@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <074223fd-6f82-9ed6-8664-f324f5027da5@redhat.com>
Date:   Wed, 12 May 2021 13:58:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210512112115.70048-1-ubizjak@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/05/21 13:21, Uros Bizjak wrote:
> There is no need to use %__ASM_AX within CONFIG_X86_64. The macro
> will always expand to %rax.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> ---
>   arch/x86/kvm/svm/vmenter.S | 44 +++++++++++++++++++-------------------
>   arch/x86/kvm/vmx/vmenter.S | 32 +++++++++++++--------------
>   2 files changed, 38 insertions(+), 38 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
> index 4fa17df123cd..844b558bb021 100644
> --- a/arch/x86/kvm/svm/vmenter.S
> +++ b/arch/x86/kvm/svm/vmenter.S
> @@ -64,14 +64,14 @@ SYM_FUNC_START(__svm_vcpu_run)
>   	mov VCPU_RSI(%_ASM_AX), %_ASM_SI
>   	mov VCPU_RDI(%_ASM_AX), %_ASM_DI
>   #ifdef CONFIG_X86_64
> -	mov VCPU_R8 (%_ASM_AX),  %r8
> -	mov VCPU_R9 (%_ASM_AX),  %r9
> -	mov VCPU_R10(%_ASM_AX), %r10
> -	mov VCPU_R11(%_ASM_AX), %r11
> -	mov VCPU_R12(%_ASM_AX), %r12
> -	mov VCPU_R13(%_ASM_AX), %r13
> -	mov VCPU_R14(%_ASM_AX), %r14
> -	mov VCPU_R15(%_ASM_AX), %r15
> +	mov VCPU_R8 (%rax),  %r8
> +	mov VCPU_R9 (%rax),  %r9
> +	mov VCPU_R10(%rax), %r10
> +	mov VCPU_R11(%rax), %r11
> +	mov VCPU_R12(%rax), %r12
> +	mov VCPU_R13(%rax), %r13
> +	mov VCPU_R14(%rax), %r14
> +	mov VCPU_R15(%rax), %r15
>   #endif
>   
>   	/* "POP" @vmcb to RAX. */
> @@ -93,21 +93,21 @@ SYM_FUNC_START(__svm_vcpu_run)
>   	pop %_ASM_AX
>   
>   	/* Save all guest registers.  */
> -	mov %_ASM_CX,   VCPU_RCX(%_ASM_AX)
> -	mov %_ASM_DX,   VCPU_RDX(%_ASM_AX)
> -	mov %_ASM_BX,   VCPU_RBX(%_ASM_AX)
> -	mov %_ASM_BP,   VCPU_RBP(%_ASM_AX)
> -	mov %_ASM_SI,   VCPU_RSI(%_ASM_AX)
> -	mov %_ASM_DI,   VCPU_RDI(%_ASM_AX)
> +	mov %_ASM_CX, VCPU_RCX(%_ASM_AX)
> +	mov %_ASM_DX, VCPU_RDX(%_ASM_AX)
> +	mov %_ASM_BX, VCPU_RBX(%_ASM_AX)
> +	mov %_ASM_BP, VCPU_RBP(%_ASM_AX)
> +	mov %_ASM_SI, VCPU_RSI(%_ASM_AX)
> +	mov %_ASM_DI, VCPU_RDI(%_ASM_AX)
>   #ifdef CONFIG_X86_64
> -	mov %r8,  VCPU_R8 (%_ASM_AX)
> -	mov %r9,  VCPU_R9 (%_ASM_AX)
> -	mov %r10, VCPU_R10(%_ASM_AX)
> -	mov %r11, VCPU_R11(%_ASM_AX)
> -	mov %r12, VCPU_R12(%_ASM_AX)
> -	mov %r13, VCPU_R13(%_ASM_AX)
> -	mov %r14, VCPU_R14(%_ASM_AX)
> -	mov %r15, VCPU_R15(%_ASM_AX)
> +	mov %r8,  VCPU_R8 (%rax)
> +	mov %r9,  VCPU_R9 (%rax)
> +	mov %r10, VCPU_R10(%rax)
> +	mov %r11, VCPU_R11(%rax)
> +	mov %r12, VCPU_R12(%rax)
> +	mov %r13, VCPU_R13(%rax)
> +	mov %r14, VCPU_R14(%rax)
> +	mov %r15, VCPU_R15(%rax)
>   #endif
>   
>   	/*
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index 3a6461694fc2..9273709e4800 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -142,14 +142,14 @@ SYM_FUNC_START(__vmx_vcpu_run)
>   	mov VCPU_RSI(%_ASM_AX), %_ASM_SI
>   	mov VCPU_RDI(%_ASM_AX), %_ASM_DI
>   #ifdef CONFIG_X86_64
> -	mov VCPU_R8 (%_ASM_AX),  %r8
> -	mov VCPU_R9 (%_ASM_AX),  %r9
> -	mov VCPU_R10(%_ASM_AX), %r10
> -	mov VCPU_R11(%_ASM_AX), %r11
> -	mov VCPU_R12(%_ASM_AX), %r12
> -	mov VCPU_R13(%_ASM_AX), %r13
> -	mov VCPU_R14(%_ASM_AX), %r14
> -	mov VCPU_R15(%_ASM_AX), %r15
> +	mov VCPU_R8 (%rax),  %r8
> +	mov VCPU_R9 (%rax),  %r9
> +	mov VCPU_R10(%rax), %r10
> +	mov VCPU_R11(%rax), %r11
> +	mov VCPU_R12(%rax), %r12
> +	mov VCPU_R13(%rax), %r13
> +	mov VCPU_R14(%rax), %r14
> +	mov VCPU_R15(%rax), %r15
>   #endif
>   	/* Load guest RAX.  This kills the @regs pointer! */
>   	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
> @@ -175,14 +175,14 @@ SYM_FUNC_START(__vmx_vcpu_run)
>   	mov %_ASM_SI, VCPU_RSI(%_ASM_AX)
>   	mov %_ASM_DI, VCPU_RDI(%_ASM_AX)
>   #ifdef CONFIG_X86_64
> -	mov %r8,  VCPU_R8 (%_ASM_AX)
> -	mov %r9,  VCPU_R9 (%_ASM_AX)
> -	mov %r10, VCPU_R10(%_ASM_AX)
> -	mov %r11, VCPU_R11(%_ASM_AX)
> -	mov %r12, VCPU_R12(%_ASM_AX)
> -	mov %r13, VCPU_R13(%_ASM_AX)
> -	mov %r14, VCPU_R14(%_ASM_AX)
> -	mov %r15, VCPU_R15(%_ASM_AX)
> +	mov %r8,  VCPU_R8 (%rax)
> +	mov %r9,  VCPU_R9 (%rax)
> +	mov %r10, VCPU_R10(%rax)
> +	mov %r11, VCPU_R11(%rax)
> +	mov %r12, VCPU_R12(%rax)
> +	mov %r13, VCPU_R13(%rax)
> +	mov %r14, VCPU_R14(%rax)
> +	mov %r15, VCPU_R15(%rax)
>   #endif
>   
>   	/* Clear RAX to indicate VM-Exit (as opposed to VM-Fail). */
> 

It looks a bit weird either way (either the address is different within 
the #ifdef, or the address is different from the destinatino), so I lean 
more towards avoiding churn.

Paolo

