Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656D51ADCE9
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 14:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgDQMIA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 08:08:00 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23679 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726050AbgDQMH7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Apr 2020 08:07:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587125277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p987HVRVXKnXMCDKJeQUgV4JiVORN2OVGgyrjOrQ/Fo=;
        b=F2PeHN86xvtoYXdKkGTku6N2DoIrP+od0WJ4WJk6kYKuem1aT73q35dDisoSF3Tw6vgoRo
        oL6U+RXXC7vG4G3S9VBr33EsqhsLvCo3vnfbKWoXBc1OVfGEqBfbzjHOqGi8l3X4A3dEBQ
        gxSGZZCpqHfAuGH37M/pzQGVyHZCfBg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-xzrK_PqEMMew1SIKWFEffQ-1; Fri, 17 Apr 2020 08:07:56 -0400
X-MC-Unique: xzrK_PqEMMew1SIKWFEffQ-1
Received: by mail-wm1-f69.google.com with SMTP id h22so863501wml.1
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 05:07:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p987HVRVXKnXMCDKJeQUgV4JiVORN2OVGgyrjOrQ/Fo=;
        b=WclivJcLsr1FfizBHK4yHKDS0/N6gJ7pYHmux2HjHkAGvxUgieasXzYxqGo9cvx6y7
         X5EIZTsAt3GXtv8o8jbNOe636lrK40o1L7/6geSWdO0fw7cF+XvHJvFjMWjRcTDUlpqS
         H3+pclf+UQMPklgS5O7Bw7CKFALteXfcP4C+TpUWF9CfO+hlFuWBv8lQAj7399JQAChs
         PArVTksN2Iis3qA/wGwpd6HrlcujXTiG2FwpUv7BE6EtaQlJ/WPK0X4depvA9T1lITvs
         9rHamTCl8Oyk19kvk6INsAsGEqpDX29Apq3qwdUYS4vjD8gA1HhgAEXGfmVd5kQdDKvb
         BoUw==
X-Gm-Message-State: AGi0PuYayfriO8qK966EhXBudYpZAOCK4XixaoS8CfCh5YH/3yQlFD9n
        nGA+PLQQoXOIpAk/xSEG4cr1jSGJoxQ/DWHITIGhbNsnPg20WFnLtKhRm+VgEwVWpCDvw3KeAu7
        SvvcvH4XL62UG
X-Received: by 2002:a1c:f606:: with SMTP id w6mr2995731wmc.59.1587125275022;
        Fri, 17 Apr 2020 05:07:55 -0700 (PDT)
X-Google-Smtp-Source: APiQypIrZoavNEm2G9wYC6Wo+BFppNi3kvnGO2ojbq2A8TqpQ4KYGxBH1u3K0Pt+zkmgjliHOMTFEw==
X-Received: by 2002:a1c:f606:: with SMTP id w6mr2995708wmc.59.1587125274757;
        Fri, 17 Apr 2020 05:07:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:56e1:adff:fed9:caf0? ([2001:b07:6468:f312:56e1:adff:fed9:caf0])
        by smtp.gmail.com with ESMTPSA id n6sm7347227wmc.28.2020.04.17.05.07.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2020 05:07:54 -0700 (PDT)
Subject: Re: [PATCH] KVM: VMX: Improve handle_external_interrupt_irqoff inline
 assembly
To:     Uros Bizjak <ubizjak@gmail.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200417113524.1280130-1-ubizjak@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <140c189d-4e82-1af5-6a59-6ea42fb818b9@redhat.com>
Date:   Fri, 17 Apr 2020 14:07:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200417113524.1280130-1-ubizjak@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/04/20 13:35, Uros Bizjak wrote:
> Improve handle_external_interrupt_irqoff inline assembly in several ways:
> - use __stringify to use __KERNEL_DS and __KERNEL_CS directly in assembler

What's the advantage of this to pushing cs and ss?  We are faking an
interrupt gate, and interrupts push cs and ss not __KERNEL_DS and
__KERNEL_CS.

> - use %rsp instead of _ASM_SP, since we are in CONFIG_X86_64 part
> - use $-16 immediate to align %rsp
> - avoid earlyclobber by using "l" GCC input operand constraint

What is this and where is it documented?!? :)

Paolo

> - avoid temporary by using current_stack_pointer
> 
> The patch introduces no functional change.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 19 ++++++-------------
>  1 file changed, 6 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 01330096ff3e..4b0d5f0044ff 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6233,9 +6233,6 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
>  {
>  	unsigned int vector;
>  	unsigned long entry;
> -#ifdef CONFIG_X86_64
> -	unsigned long tmp;
> -#endif
>  	gate_desc *desc;
>  	u32 intr_info;
>  
> @@ -6252,23 +6249,19 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
>  
>  	asm volatile(
>  #ifdef CONFIG_X86_64
> -		"mov %%" _ASM_SP ", %[sp]\n\t"
> -		"and $0xfffffffffffffff0, %%" _ASM_SP "\n\t"
> -		"push $%c[ss]\n\t"
> +		"and $-16, %%rsp\n\t"
> +		"push $" __stringify(__KERNEL_DS) "\n\t"
>  		"push %[sp]\n\t"
>  #endif
>  		"pushf\n\t"
> -		__ASM_SIZE(push) " $%c[cs]\n\t"
> +		__ASM_SIZE(push) " $" __stringify(__KERNEL_CS) "\n\t"
>  		CALL_NOSPEC
> +		: ASM_CALL_CONSTRAINT
>  		:

