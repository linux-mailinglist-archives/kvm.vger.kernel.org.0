Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40CFB1C40B1
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 19:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729876AbgEDRC5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 13:02:57 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58953 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729737AbgEDRC4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 13:02:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588611775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RdPGUfCTFmbtJr9z0t1okb1pknZl3offfY0zWQPEzPM=;
        b=KbEugZxi9G7N/NGIhuq/Aeaj4QssuCCzqYZKb0cUN5GvsiCJyrmT3qvWc0MznWQOON4c+2
        FoStGLRBDxMcIeYxY14vfkblSQf2coRCUkadFNzSNx60C+6H2BbqSMDHGbymQIv1jgyV3D
        HzuUuZ3+jotQ5664Zk1kHY67PbHcELI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-Jtx2u28uMdKOeh0GoDlcAA-1; Mon, 04 May 2020 13:02:53 -0400
X-MC-Unique: Jtx2u28uMdKOeh0GoDlcAA-1
Received: by mail-wr1-f71.google.com with SMTP id r11so7454wrx.21
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 10:02:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RdPGUfCTFmbtJr9z0t1okb1pknZl3offfY0zWQPEzPM=;
        b=Bh/TyxOFOaOYnAFgsgROt+t3fa9ZiIbQ7q6AEJUJg/BrJXmgScJwGN+zJfz1XK615F
         eLKz7Lpt9QvS76/aaRjv3SJn9iCJuXELEnmj5Kylu5hsA0P04i8UsXS7B4CoIncSBU6L
         ZEzLpp2Znmx51NRYuUswSov1bHjOSmS3JbyahUBTl17LdkwAZHMHDrbajue9lOehzhev
         TNehFhxMOPlMU/kf3Rp2XS2AD7SEwbCtLCnJp78+YpmR7qktEAlQXvlm1JzJw0+va1nf
         wi171s+wJ7QXLmy0wzH1ECFxxj19Ln+ZeUz3Lf5pmPJneXdjW9i+Kun8lcJcdek7iEr+
         jV3w==
X-Gm-Message-State: AGi0PuZ37KwHjiiMFgixaQYqKLhdIYsEomv/t6qc7vOt2/n6jHXI18ys
        oMA8TRu6JoMp9GRA/LjbQk0X7iAJVE1tQy+3Io3UQE7Q3IEoqrm4OBrRUo5rI+8EY5sE3oZWAaa
        DSwYN2j5oZv4m
X-Received: by 2002:adf:f1c4:: with SMTP id z4mr275318wro.25.1588611772222;
        Mon, 04 May 2020 10:02:52 -0700 (PDT)
X-Google-Smtp-Source: APiQypKlf1djskaVD+JLdWa8uck/kM5+WTGArk51GBwqcbEnHGWsAXKa4jik2Uimc02tvO6Z0Y9GLg==
X-Received: by 2002:adf:f1c4:: with SMTP id z4mr275297wro.25.1588611772003;
        Mon, 04 May 2020 10:02:52 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id b12sm22309784wro.18.2020.05.04.10.02.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 10:02:51 -0700 (PDT)
Subject: Re: [PATCH v5] KVM: VMX: Improve handle_external_interrupt_irqoff
 inline assembly
To:     Uros Bizjak <ubizjak@gmail.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200504155706.2516956-1-ubizjak@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0be7707b-6fe8-e216-483e-f21ac1cefa53@redhat.com>
Date:   Mon, 4 May 2020 19:02:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200504155706.2516956-1-ubizjak@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/05/20 17:57, Uros Bizjak wrote:
> Improve handle_external_interrupt_irqoff inline assembly in several ways:
> - remove unneeded %c operand modifiers and "$" prefixes
> - use %rsp instead of _ASM_SP, since we are in CONFIG_X86_64 part
> - use $-16 immediate to align %rsp
> - remove unneeded use of __ASM_SIZE macro
> - define "ss" named operand only for X86_64
> 
> The patch introduces no functional changes.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c2c6335a998c..22f3324600e1 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6283,13 +6283,13 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
>  
>  	asm volatile(
>  #ifdef CONFIG_X86_64
> -		"mov %%" _ASM_SP ", %[sp]\n\t"
> -		"and $0xfffffffffffffff0, %%" _ASM_SP "\n\t"
> -		"push $%c[ss]\n\t"
> +		"mov %%rsp, %[sp]\n\t"
> +		"and $-16, %%rsp\n\t"
> +		"push %[ss]\n\t"
>  		"push %[sp]\n\t"
>  #endif
>  		"pushf\n\t"
> -		__ASM_SIZE(push) " $%c[cs]\n\t"
> +		"push %[cs]\n\t"
>  		CALL_NOSPEC
>  		:
>  #ifdef CONFIG_X86_64
> @@ -6298,7 +6298,9 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
>  		ASM_CALL_CONSTRAINT
>  		:
>  		[thunk_target]"r"(entry),
> +#ifdef CONFIG_X86_64
>  		[ss]"i"(__KERNEL_DS),
> +#endif
>  		[cs]"i"(__KERNEL_CS)
>  	);
>  
> 

Queued, thanks.

Paolo

