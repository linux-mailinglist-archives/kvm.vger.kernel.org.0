Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE3E2A8B68
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 01:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732684AbgKFAcA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 19:32:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731330AbgKFAb7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 19:31:59 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD52EC0613CF;
        Thu,  5 Nov 2020 16:31:59 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id t14so2584498pgg.1;
        Thu, 05 Nov 2020 16:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tLeTUxO+mrgYM9OsvoYtUI/ekoBjh7HczbMpyd1oOkw=;
        b=o80N8Po0brGaUKDePDDfcBlMM5z5/E+GcRPBFx7zKYr58NOyUxifd0EQ4RUOkF8PFk
         2lpaDJcnzhpN0qbj5/vYj4CrPolIXWQCAOmZ5oJdTLlXtm5m7UVBRQZiv3eXoHUXM1hj
         WzKkFaDClIw63bv9+CCFYR5ud0WXMZPj+ZonENa9TDrz0W2l8gNOH52u8urHmYPbQ17A
         j5P9BlfoFzbp4wVV1sJJhBKk8zlmDI1pDQxQQDvg6peuzWR892Ljk6NGFn8OL52KZev0
         xNx7pe/Gq29WuKQZZM60bT6Ts9E6rzsaJMF58MmTa9dlPxkf7c1nifyz94z1IYtVKrGS
         jY0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tLeTUxO+mrgYM9OsvoYtUI/ekoBjh7HczbMpyd1oOkw=;
        b=s7tL6ZBhxBW186GPPT22j4AcC0D10/xL7gpL+/kewWye8POWoWWAiUbvLJVazCW2BL
         e8Wl/IbJTJo1IkdRYV/NtBQ8Agb/KoldIMu1PGbE1prQV7cXcyPuU9fSNJp0dNxN0kOz
         QawpFVMg8bKpMTxHpkMumwMWfNfpwhhoHAdH6l5RWR5XJveVfQjrOzlsoe+aUDbDBiV2
         ikg+483SPNuOhgizjNhHU3Co3qrxjNkFTXBqyzFf6W0LUsZOL+YgxP2t2F2gKqIzYYib
         gDQz08YQROq11oG7Ml4JMQSzuMvXOAZqSkMCvZY5UTbvGbKfi6hW4Sxzsl99DSeXHlGW
         Ds9g==
X-Gm-Message-State: AOAM531UZZfVb+duvOaPYSriRdCXBF+FL03+CsFgLECwLFF9+FwBhw70
        +Bw6Q55tGLvtQPsJzx/NkYHGR0Wiv67k
X-Google-Smtp-Source: ABdhPJz74EeXycaULN1pvr8TdAW5TT5/kKHY71KMCLgIG+bKFh1TufmuGHryYIslLXXOj716DIL7Bw==
X-Received: by 2002:a63:1619:: with SMTP id w25mr4713623pgl.34.1604622719237;
        Thu, 05 Nov 2020 16:31:59 -0800 (PST)
Received: from [127.0.0.1] ([203.205.141.53])
        by smtp.gmail.com with ESMTPSA id 194sm3735510pgf.72.2020.11.05.16.31.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 16:31:58 -0800 (PST)
Subject: Re: [PATCH v2] KVM: x86: Add tracepoint for dr_write/dr_read
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, Haiwei Li <lihaiwei@tencent.com>
References: <20201009032130.6774-1-lihaiwei.kernel@gmail.com>
Message-ID: <eb80c1e1-152c-0bad-562d-ff07ed9685ea@gmail.com>
Date:   Fri, 6 Nov 2020 08:31:54 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
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
