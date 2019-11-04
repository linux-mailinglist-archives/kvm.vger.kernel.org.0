Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84EF5EDF46
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 12:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729262AbfKDLyk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 06:54:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60458 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728377AbfKDLyE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 06:54:04 -0500
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A01C0C057F23
        for <kvm@vger.kernel.org>; Mon,  4 Nov 2019 11:54:03 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id f191so2253074wme.1
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2019 03:54:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K9ShbQwUl3JT1wY9fwM0LVfIdQxr/5VaXCx33ZJ5yec=;
        b=pnFUcaCDTu1R6eYCKMET6Mmt8gWID+gZQzvqllbTQxsfMyRaMh4QhWlcxXeHKpvWhz
         5My8nmfW/aG8iRQEdZ9nnS4YfOkJptI9CwNZzq4+O2Ow4GPNSuH/p0kLVeaBkYOo7TZI
         S6wia+eYagcwk8GEOLZhmwmSOW+VFw+zOJShT6zIhmJAaTONKM+BbAROxqpQ9bViu60e
         UDhnKlnDO4xZDpu0uIaOO6aB7d+EK0VNcgBp4lnO8mtiowhIOMTPfbfXzeQ3depUB+LH
         1IqazabRmWee2CANnzhiuQo8VFBNbSHDWi/vgr4h3/Mn80xjonYIIKA6+sM5RFpguxkh
         rNXw==
X-Gm-Message-State: APjAAAX3tZL8ro4wZmNqOWpCSJx8jKVndqU6IFbc6k7rHN0BqUOSG8aT
        l5XeGnAZERNvzVeHDcVhXFL9E622/zvJeXqceO66daljlz2hGjFt56n8osQNc/Y6Qag9XOUxUuW
        wpeS8Pl2D2KC+
X-Received: by 2002:adf:e5cf:: with SMTP id a15mr24119475wrn.143.1572868442063;
        Mon, 04 Nov 2019 03:54:02 -0800 (PST)
X-Google-Smtp-Source: APXvYqxFiK0uysITL0qyqhqzQe9IaQU3kN4T5tUMeyIETkHAy9fg1Ec1DQbcA/YXPxCfHYIp7okHUA==
X-Received: by 2002:adf:e5cf:: with SMTP id a15mr24119450wrn.143.1572868441791;
        Mon, 04 Nov 2019 03:54:01 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:4051:461:136e:3f74? ([2001:b07:6468:f312:4051:461:136e:3f74])
        by smtp.gmail.com with ESMTPSA id i71sm22623611wri.68.2019.11.04.03.54.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 03:54:01 -0800 (PST)
Subject: Re: [PATCH 2/4] kvm: svm: Enable UMIP feature on AMD
To:     "Moger, Babu" <Babu.Moger@amd.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "nayna@linux.ibm.com" <nayna@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <157262960837.2838.17520432516398899751.stgit@naples-babu.amd.com>
 <157262962352.2838.15656190309312238595.stgit@naples-babu.amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <37c61050-e315-fc84-9699-bb92e5afacda@redhat.com>
Date:   Mon, 4 Nov 2019 12:54:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <157262962352.2838.15656190309312238595.stgit@naples-babu.amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/11/19 18:33, Moger, Babu wrote:
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 4153ca8cddb7..79abbdeca148 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -2533,6 +2533,11 @@ static void svm_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)
>  {
>  }
>  
> +static bool svm_umip_emulated(void)
> +{
> +	return boot_cpu_has(X86_FEATURE_UMIP);
> +}

For hardware that supports UMIP, this is only needed because of your
patch 1.  Without it, X86_FEATURE_UMIP should already be enabled on
processors that natively support UMIP.

If you want UMIP *emulation* instead, this should become "return true".

>  static void update_cr0_intercept(struct vcpu_svm *svm)
>  {
>  	ulong gcr0 = svm->vcpu.arch.cr0;
> @@ -4438,6 +4443,13 @@ static int interrupt_window_interception(struct vcpu_svm *svm)
>  	return 1;
>  }
>  
> +static int umip_interception(struct vcpu_svm *svm)
> +{
> +	struct kvm_vcpu *vcpu = &svm->vcpu;
> +
> +	return kvm_emulate_instruction(vcpu, 0);
> +}
> +
>  static int pause_interception(struct vcpu_svm *svm)
>  {
>  	struct kvm_vcpu *vcpu = &svm->vcpu;
> @@ -4775,6 +4787,10 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
>  	[SVM_EXIT_SMI]				= nop_on_interception,
>  	[SVM_EXIT_INIT]				= nop_on_interception,
>  	[SVM_EXIT_VINTR]			= interrupt_window_interception,
> +	[SVM_EXIT_IDTR_READ]			= umip_interception,
> +	[SVM_EXIT_GDTR_READ]			= umip_interception,
> +	[SVM_EXIT_LDTR_READ]			= umip_interception,
> +	[SVM_EXIT_TR_READ]			= umip_interception,

This is missing enabling the intercepts.  Also, this can be just
emulate_on_interception instead of a new function.

Paolo

>  	[SVM_EXIT_RDPMC]			= rdpmc_interception,
>  	[SVM_EXIT_CPUID]			= cpuid_interception,
>  	[SVM_EXIT_IRET]                         = iret_interception,
> @@ -5976,11 +5992,6 @@ static bool svm_xsaves_supported(void)
>  	return boot_cpu_has(X86_FEATURE_XSAVES);
>  }
>  
> -static bool svm_umip_emulated(void)
> -{
> -	return false;
> -}
> -
>  static bool svm_pt_supported(void)
>  {
>  	return false;
> 

