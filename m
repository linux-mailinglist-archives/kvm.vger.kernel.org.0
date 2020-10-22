Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA5E2955BB
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 02:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442610AbgJVAne (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 20:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2442509AbgJVAnd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 20:43:33 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4EADC0613CE;
        Wed, 21 Oct 2020 17:43:33 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id x13so2519708pgp.7;
        Wed, 21 Oct 2020 17:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tLeTUxO+mrgYM9OsvoYtUI/ekoBjh7HczbMpyd1oOkw=;
        b=qwZ3fCb7+lvSYhEaYUnf4XM7dEJbykyKEytf1rHleTatc5vmZ9aa4wbOnuDolqcwVQ
         IxDyVbQL2HsRWHYcOsx2rB4C5TS7bGSbFmTQLKa/fsSnMn1uubgj7dRKQujpWh3qQczn
         ClAVKtqFe7Nfa8eT40FcuNh/1EDTzxqh4bu/IMFgmyYE7+PzjvokyoPgdLZjPUwFjbry
         8Ovjd1o5cpW3D4YSjJLFSWmveQzKOSct703mMaa5GZlBj3+KihcdkxmZBCjKS4iAQZrt
         9xPbXrzTu9q9AVXXA65ydlbDjaKw15UBLayYou5HHq6C3/Rap6ENJEquuNwOCQwLZpyt
         MI4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tLeTUxO+mrgYM9OsvoYtUI/ekoBjh7HczbMpyd1oOkw=;
        b=L+nZ7CCs6ocZhTcp8nW4rQw9Y6EH+wnp/EYJNTzwcoYJozLoXi1Yp26A6YzG3R9xpX
         OlhiXlZRopy5dRd4AZWnoOjK0CEaCrRYJ03aKApdnRB+v7O/ITXh4EcJ/rmiiTDaxA8U
         /hQNuCL3vMsUAFYEbYM0fb0wQeu7pOsS/cOKtfxLVTPC+mLHCYifTnBYz42TruYvpCO/
         zg2F0Kz30jEjwM9aiAZbW11u4vQzbI9GXLpk/susDEzQ4fh21LaaJBbJb4P6X3PsbI/6
         pJsgaNDextZI4u7dgdiAp2Y2GUIno7xb5oeKqBkaYEuEh2mkaukbICnfdptqyIoT9ddP
         PGWQ==
X-Gm-Message-State: AOAM533E32T2yTnOAIC0HAaoFs8XW83unA6EfAb1DyXvsMRIPOS695xO
        TSnApYm9PrH1V6jnCDEg/A==
X-Google-Smtp-Source: ABdhPJx9gN1dUT8nsuVXtw9xnIo7L73cIFVbbBWfg+8wHoc8UkI62HgS4CnIAzL2G7zCnwgAHvI0Gg==
X-Received: by 2002:aa7:87d9:0:b029:155:6486:ac68 with SMTP id i25-20020aa787d90000b02901556486ac68mr232669pfo.30.1603327413317;
        Wed, 21 Oct 2020 17:43:33 -0700 (PDT)
Received: from [127.0.0.1] ([203.205.141.40])
        by smtp.gmail.com with ESMTPSA id q5sm9660pjg.0.2020.10.21.17.43.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2020 17:43:32 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: x86: Add tracepoint for dr_write/dr_read
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, Haiwei Li <lihaiwei@tencent.com>
References: <20201009032130.6774-1-lihaiwei.kernel@gmail.com>
Message-ID: <5439f177-0bd0-084d-b7b0-450ceab475b8@gmail.com>
Date:   Thu, 22 Oct 2020 08:43:26 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.3
MIME-Version: 1.0
In-Reply-To: <20201009032130.6774-1-lihaiwei.kernel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kindly ping. :)

On 20/10/9 11:21, lihaiwei.kernel@gmail.com wrote:
> From: Haiwei Li <lihaiwei@tencent.com>
> 
> When vmexit occurs caused by accessing dr, there is no tracepoint to track
> this action. Add tracepoint for this on x86 kvm.
> 
> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
> ---
> v1 -> v2:
>   * Improve the changelog
> 
>   arch/x86/kvm/svm/svm.c |  2 ++
>   arch/x86/kvm/trace.h   | 27 +++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/vmx.c | 10 ++++++++--
>   arch/x86/kvm/x86.c     |  1 +
>   4 files changed, 38 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 4f401fc6a05d..52c69551aea4 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2423,12 +2423,14 @@ static int dr_interception(struct vcpu_svm *svm)
>   		if (!kvm_require_dr(&svm->vcpu, dr - 16))
>   			return 1;
>   		val = kvm_register_read(&svm->vcpu, reg);
> +		trace_kvm_dr_write(dr - 16, val);
>   		kvm_set_dr(&svm->vcpu, dr - 16, val);
>   	} else {
>   		if (!kvm_require_dr(&svm->vcpu, dr))
>   			return 1;
>   		kvm_get_dr(&svm->vcpu, dr, &val);
>   		kvm_register_write(&svm->vcpu, reg, val);
> +		trace_kvm_dr_read(dr, val);
>   	}
>   
>   	return kvm_skip_emulated_instruction(&svm->vcpu);
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index aef960f90f26..b3bf54405862 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -405,6 +405,33 @@ TRACE_EVENT(kvm_cr,
>   #define trace_kvm_cr_read(cr, val)		trace_kvm_cr(0, cr, val)
>   #define trace_kvm_cr_write(cr, val)		trace_kvm_cr(1, cr, val)
>   
> +/*
> + * Tracepoint for guest DR access.
> + */
> +TRACE_EVENT(kvm_dr,
> +	TP_PROTO(unsigned int rw, unsigned int dr, unsigned long val),
> +	TP_ARGS(rw, dr, val),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned int,	rw		)
> +		__field(	unsigned int,	dr		)
> +		__field(	unsigned long,	val		)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->rw		= rw;
> +		__entry->dr		= dr;
> +		__entry->val		= val;
> +	),
> +
> +	TP_printk("dr_%s %x = 0x%lx",
> +		  __entry->rw ? "write" : "read",
> +		  __entry->dr, __entry->val)
> +);
> +
> +#define trace_kvm_dr_read(dr, val)		trace_kvm_dr(0, dr, val)
> +#define trace_kvm_dr_write(dr, val)		trace_kvm_dr(1, dr, val)
> +
>   TRACE_EVENT(kvm_pic_set_irq,
>   	    TP_PROTO(__u8 chip, __u8 pin, __u8 elcr, __u8 imr, bool coalesced),
>   	    TP_ARGS(chip, pin, elcr, imr, coalesced),
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 4551a7e80ebc..f78fd297d51e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5091,10 +5091,16 @@ static int handle_dr(struct kvm_vcpu *vcpu)
>   
>   		if (kvm_get_dr(vcpu, dr, &val))
>   			return 1;
> +		trace_kvm_dr_read(dr, val);
>   		kvm_register_write(vcpu, reg, val);
> -	} else
> -		if (kvm_set_dr(vcpu, dr, kvm_register_readl(vcpu, reg)))
> +	} else {
> +		unsigned long val;
> +
> +		val = kvm_register_readl(vcpu, reg);
> +		trace_kvm_dr_write(dr, val);
> +		if (kvm_set_dr(vcpu, dr, val))
>   			return 1;
> +	}
>   
>   	return kvm_skip_emulated_instruction(vcpu);
>   }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c4015a43cc8a..68cb7b331324 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11153,6 +11153,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_msr);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_cr);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_dr);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmrun);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit_inject);
> 
