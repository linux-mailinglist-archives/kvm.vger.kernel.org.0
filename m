Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9134C351E8F
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234838AbhDASnd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:43:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56529 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235060AbhDASca (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 14:32:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617301946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XtDBz7ykDKRMTtDTrLTSXxwTFQJuBtQJjv1Xfg77ytQ=;
        b=PWI3ffGtTOJDJBl5AAj3AsGjYH/QQcwSyydmi59VnMvg0vCXWfP45omRQLEMpHPD/wiA96
        BINv19ZMzF7dmEV9ZD4yya/M3VbG//hlYUGIKYNUNyUIOW5e04Vh9yPclqu32GtdxE0DfK
        WXiTSFT5tal1M/O29ZKhahDbDv/KC0c=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-GtCjSXO8N9iQzf5lEbp2Pw-1; Thu, 01 Apr 2021 10:31:44 -0400
X-MC-Unique: GtCjSXO8N9iQzf5lEbp2Pw-1
Received: by mail-ej1-f70.google.com with SMTP id h14so2305574ejg.7
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 07:31:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XtDBz7ykDKRMTtDTrLTSXxwTFQJuBtQJjv1Xfg77ytQ=;
        b=BadrGYZEvr7nTRFPKlR3sli+GCq/HWrP6mltwVpLFLjCy/XhuQAjtrNRT74zwfsLpN
         juON7ZH0U/ufFDnl8cCC8hxkYrFW9dyym/ql2BXDaXY8ZziU5TN/ylorUnZRkiadOBeB
         eQtmrtq4VNUZQtPn3eKJOXm6lvPuY323AJiT2hbpJsqfXfNlCayliRGbQ/ETrKoStyFS
         5WSEyM2Yj7AqZpKJzmuU1pMCJeRf7dFTzHtVZisJauodUTOJKQo2nw86/E4AQ8E6BFr8
         6r8br5ghxnKZipBFTZclSmQhtNekySq7GptATzypq3u11oS3pJBhJOWcYOT90YpEF9OZ
         0HpA==
X-Gm-Message-State: AOAM530XRrHpfDG7CCizTa/X5AGtEbStsAifjpBLXuCgK2OBWkddN0j6
        V+2UKoCbsJcH84AzyLQ1EseeXWIjXbSDKA4cAUXE1YBAzkgRgWapfMGAjyAyDZIR7pFvYS35jL6
        6doXEhvvlmqVc
X-Received: by 2002:a50:fe08:: with SMTP id f8mr10085895edt.217.1617287501388;
        Thu, 01 Apr 2021 07:31:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzrkplglsUx4FWy5ZDzoNBFaTl9LRJrAQoJMJg7M+SOTlXx6lpwIPeSi7qSlRenq6FjNWqKjg==
X-Received: by 2002:a50:fe08:: with SMTP id f8mr10085877edt.217.1617287501236;
        Thu, 01 Apr 2021 07:31:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id nd36sm2840882ejc.21.2021.04.01.07.31.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 07:31:40 -0700 (PDT)
Subject: Re: [PATCH 3/6] KVM: x86: introduce kvm_register_clear_available
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
References: <20210401141814.1029036-1-mlevitsk@redhat.com>
 <20210401141814.1029036-4-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <75dc7aba-fc9e-8217-e120-9c6ef3a601c8@redhat.com>
Date:   Thu, 1 Apr 2021 16:31:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210401141814.1029036-4-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/04/21 16:18, Maxim Levitsky wrote:
> Small refactoring that will be used in the next patch.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>   arch/x86/kvm/kvm_cache_regs.h | 7 +++++++
>   arch/x86/kvm/svm/svm.c        | 6 ++----
>   2 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
> index 2e11da2f5621..07d607947805 100644
> --- a/arch/x86/kvm/kvm_cache_regs.h
> +++ b/arch/x86/kvm/kvm_cache_regs.h
> @@ -55,6 +55,13 @@ static inline void kvm_register_mark_available(struct kvm_vcpu *vcpu,
>   	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
>   }
>   
> +static inline void kvm_register_clear_available(struct kvm_vcpu *vcpu,
> +					       enum kvm_reg reg)
> +{
> +	__clear_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
> +	__clear_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
> +}
> +
>   static inline void kvm_register_mark_dirty(struct kvm_vcpu *vcpu,
>   					   enum kvm_reg reg)
>   {
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 271196400495..2843732299a2 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3880,10 +3880,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>   		vcpu->arch.apf.host_apf_flags =
>   			kvm_read_and_reset_apf_flags();
>   
> -	if (npt_enabled) {
> -		vcpu->arch.regs_avail &= ~(1 << VCPU_EXREG_PDPTR);
> -		vcpu->arch.regs_dirty &= ~(1 << VCPU_EXREG_PDPTR);
> -	}
> +	if (npt_enabled)
> +		kvm_register_clear_available(vcpu, VCPU_EXREG_PDPTR);
>   
>   	/*
>   	 * We need to handle MC intercepts here before the vcpu has a chance to
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

