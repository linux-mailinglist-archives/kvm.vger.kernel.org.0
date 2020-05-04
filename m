Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A22081C407F
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 18:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729825AbgEDQwa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 12:52:30 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:55473 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729805AbgEDQw3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 12:52:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588611148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sarOM51Bys9lg9gBdr1jISprlN6mX5TssFeACVvRVrI=;
        b=ITp3QhFbsRCYg+8IoqasfuQy/e/tJ81AdvtJcVReurE9OIE6XpkV5arVRCFSwVtFO5fsYr
        0MLynv4o9THK0zp9JrrzJo0iR+Eoq7fO7njrA6phX5nlVedVmrswxlOGnnEeSzbl0K9aSn
        0mYgyWYVFQT+Z9lanzDHcxHR+2YJ7Es=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-2MhEjsQfNE6JvDa1jclBBQ-1; Mon, 04 May 2020 12:52:26 -0400
X-MC-Unique: 2MhEjsQfNE6JvDa1jclBBQ-1
Received: by mail-wr1-f72.google.com with SMTP id j16so11077275wrw.20
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 09:52:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sarOM51Bys9lg9gBdr1jISprlN6mX5TssFeACVvRVrI=;
        b=jqjUFMkpoo0AdcS+3N3AG4QDVc6oKynrKocmxZm2JEQLcYzgbsq8NsVOPm2aqYTM9t
         zUkgLbhjHgYPFm95eSwoPFK2vcMLaRIt+3k60rVrD8DtYXaWlHaNA07nogtsK/y0b2Kn
         M1ENwwFMGhaAYfNnYKupgDAThNCniI+BgPir9y+RZWfzF8bxLqAdVz60FUsU83ojIE/N
         RXWl5i/nI250G4edAc9psmzKtU0qrPNjn5rX8pmsmk75NppmrDW/onzKsbA1nip5m4bP
         +IFknR8zIR2PlLlFXebdFqgzG+Xu7zPVK+FihNrbz/aO2CEcBTSGacqHI9CWSnsT0nv8
         OEGQ==
X-Gm-Message-State: AGi0PuZR9KbuS9fPMuWbder+sewC/aqXPpzue/wnaBJpCcOUnUNBfGrm
        ajSSr4Hj5ewDhxD9WN4+6XDQ6k2/f4PUUj56rUb19eFOU6reGJlkzFO4JY2hZqvc1b/zykiLLtk
        ZAkMaeBVR34gu
X-Received: by 2002:adf:e450:: with SMTP id t16mr21814349wrm.301.1588611145313;
        Mon, 04 May 2020 09:52:25 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ8HcaprUYYmthmxvihpEp6gO9o688crJv4SjtdH2gz1X7X/8TdFSH50Dh9Cf3JzzK174yytQ==
X-Received: by 2002:adf:e450:: with SMTP id t16mr21814331wrm.301.1588611145115;
        Mon, 04 May 2020 09:52:25 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id b4sm19442099wrv.42.2020.05.04.09.52.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 09:52:24 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: VMX: Remove unneeded __ASM_SIZE usage with POP
 instruction
To:     Uros Bizjak <ubizjak@gmail.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200427205035.1594232-1-ubizjak@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0690da2d-f6b4-613a-515f-17fc8f80990c@redhat.com>
Date:   Mon, 4 May 2020 18:52:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200427205035.1594232-1-ubizjak@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/04/20 22:50, Uros Bizjak wrote:
> POP [mem] defaults to the word size, and the only legal non-default
> size is 16 bits, e.g. a 32-bit POP will #UD in 64-bit mode and vice
> versa, no need to use __ASM_SIZE macro to force operating mode.
> 
> Changes since v1:
> - Fix commit message.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> ---
>  arch/x86/kvm/vmx/vmenter.S | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index 87f3f24fef37..94b8794bdd2a 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -163,13 +163,13 @@ SYM_FUNC_START(__vmx_vcpu_run)
>  	mov WORD_SIZE(%_ASM_SP), %_ASM_AX
>  
>  	/* Save all guest registers, including RAX from the stack */
> -	__ASM_SIZE(pop) VCPU_RAX(%_ASM_AX)
> -	mov %_ASM_CX,   VCPU_RCX(%_ASM_AX)
> -	mov %_ASM_DX,   VCPU_RDX(%_ASM_AX)
> -	mov %_ASM_BX,   VCPU_RBX(%_ASM_AX)
> -	mov %_ASM_BP,   VCPU_RBP(%_ASM_AX)
> -	mov %_ASM_SI,   VCPU_RSI(%_ASM_AX)
> -	mov %_ASM_DI,   VCPU_RDI(%_ASM_AX)
> +	pop           VCPU_RAX(%_ASM_AX)
> +	mov %_ASM_CX, VCPU_RCX(%_ASM_AX)
> +	mov %_ASM_DX, VCPU_RDX(%_ASM_AX)
> +	mov %_ASM_BX, VCPU_RBX(%_ASM_AX)
> +	mov %_ASM_BP, VCPU_RBP(%_ASM_AX)
> +	mov %_ASM_SI, VCPU_RSI(%_ASM_AX)
> +	mov %_ASM_DI, VCPU_RDI(%_ASM_AX)
>  #ifdef CONFIG_X86_64
>  	mov %r8,  VCPU_R8 (%_ASM_AX)
>  	mov %r9,  VCPU_R9 (%_ASM_AX)
> 

Queued, thanks.

Paolo

