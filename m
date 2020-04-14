Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E181A760D
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 10:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436818AbgDNI2Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 04:28:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28235 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2436810AbgDNI2L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 04:28:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586852889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rt7L74f9g6IEBeOrDB6ZsdrjPErudtNVLi/z8gKIbTQ=;
        b=GBDnl3imII37NePTdfH1ierHUH8Md4Wls9foSS51BlNPlUQ8iL1DOu3IvBVs3Hx4i9/S0e
        ix2civqUOrelkxHQGkx/HuR5C2kjyTA+q3GDzvLXIyyd9thjySuiY96T4Mnnw99S2lzwNt
        vStC5DCTeH22SgGjM+gCfqQsZ5MPGvU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-_CS0HRAUM12NQQayd_05bg-1; Tue, 14 Apr 2020 04:28:06 -0400
X-MC-Unique: _CS0HRAUM12NQQayd_05bg-1
Received: by mail-wm1-f70.google.com with SMTP id f81so3485917wmf.2
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 01:28:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rt7L74f9g6IEBeOrDB6ZsdrjPErudtNVLi/z8gKIbTQ=;
        b=NQwFKzuYRPXDZBln3DawFjkXRStZRsJ0f/sJavckkLBUMI4GJ9wsisiK1PloOoQdnx
         ZGDGnPPEAbx8uHfuxsB0MFZBj94L2TNjlC8KZ5//HX/2Lsvi+KkmLbwSCo4yo+y4bIBR
         8ymEAkci0ZF9dSmbUzzBJsKC+Bs91Y+TgNJqDDM1nIz6n205OZXbMLH1bNnwOaU47+HU
         VBWXPKIWA+L856ExcvQxhmc3KCTfM0E8WU7W9RvzXVpC5jFQPFc7cFRyI5iRNBNRXvx6
         f3bikFpeTxoZGbzVXpurG1R3FZHUCq8eQIMZGmXHYa+2safm3M4GyyDIufwEQPiJMmxM
         E2Mg==
X-Gm-Message-State: AGi0PuZJpZcJ9/FU8sX9lpg1jmVbhhjxgbWy5xQIIms/Yo1KN7WWhjA2
        1rCBlU8rL6KDl+4y2VsUfjm99aYNQx7AfMqekclP2QA3QstSJW/G9YsyXccqH3zwK2DDr+xal3E
        m1D3ZopeB4UUB
X-Received: by 2002:adf:a345:: with SMTP id d5mr19469835wrb.23.1586852885575;
        Tue, 14 Apr 2020 01:28:05 -0700 (PDT)
X-Google-Smtp-Source: APiQypJtVXcQxjK7C1sTiZU7cvgSkfQBmZLizhPmZoNSzZY4cXgH2h/gZK+jx1CP6r5OFlxfKc8wJg==
X-Received: by 2002:adf:a345:: with SMTP id d5mr19469816wrb.23.1586852885350;
        Tue, 14 Apr 2020 01:28:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:6c37:bdc0:470a:460c? ([2001:b07:6468:f312:6c37:bdc0:470a:460c])
        by smtp.gmail.com with ESMTPSA id h188sm18818231wme.8.2020.04.14.01.28.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 01:28:04 -0700 (PDT)
Subject: Re: [RFC PATCH] KVM: SVM: Use do_machine_check to pass MCE to the
 host
To:     Uros Bizjak <ubizjak@gmail.com>, kvm@vger.kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200411153627.3474710-1-ubizjak@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <265cb525-6fa7-d1a0-b666-5b17fc590e42@redhat.com>
Date:   Tue, 14 Apr 2020 10:28:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200411153627.3474710-1-ubizjak@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/04/20 17:36, Uros Bizjak wrote:
> Use do_machine_check instead of INT $12 to pass MCE to the host,
> the same approach VMX uses.
> 
> On a related note, there is no reason to limit the use of do_machine_check
> to 64 bit targets, as is currently done for VMX. MCE handling works
> for both target families.
> 
> The patch is only compile tested, for both, 64 and 32 bit targets,
> someone should test the passing of the exception by injecting
> some MCEs into the guest.
> 
> For future non-RFC patch, kvm_machine_check should be moved to some
> appropriate header file.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> ---
>  arch/x86/kvm/svm/svm.c | 26 +++++++++++++++++++++-----
>  arch/x86/kvm/vmx/vmx.c |  2 +-
>  2 files changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 061d19e69c73..cd773f6261e3 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -33,6 +33,7 @@
>  #include <asm/debugreg.h>
>  #include <asm/kvm_para.h>
>  #include <asm/irq_remapping.h>
> +#include <asm/mce.h>
>  #include <asm/spec-ctrl.h>
>  #include <asm/cpu_device_id.h>
>  
> @@ -1839,6 +1840,25 @@ static bool is_erratum_383(void)
>  	return true;
>  }
>  
> +/*
> + * Trigger machine check on the host. We assume all the MSRs are already set up
> + * by the CPU and that we still run on the same CPU as the MCE occurred on.
> + * We pass a fake environment to the machine check handler because we want
> + * the guest to be always treated like user space, no matter what context
> + * it used internally.
> + */
> +static void kvm_machine_check(void)
> +{
> +#if defined(CONFIG_X86_MCE)
> +	struct pt_regs regs = {
> +		.cs = 3, /* Fake ring 3 no matter what the guest ran on */
> +		.flags = X86_EFLAGS_IF,
> +	};
> +
> +	do_machine_check(&regs, 0);
> +#endif
> +}
> +
>  static void svm_handle_mce(struct vcpu_svm *svm)
>  {
>  	if (is_erratum_383()) {
> @@ -1857,11 +1877,7 @@ static void svm_handle_mce(struct vcpu_svm *svm)
>  	 * On an #MC intercept the MCE handler is not called automatically in
>  	 * the host. So do it by hand here.
>  	 */
> -	asm volatile (
> -		"int $0x12\n");
> -	/* not sure if we ever come back to this point */
> -
> -	return;
> +	kvm_machine_check();
>  }
>  
>  static int mc_interception(struct vcpu_svm *svm)

Looks good, but please move kvm_machine_check() to x86.c instead.

Paolo

