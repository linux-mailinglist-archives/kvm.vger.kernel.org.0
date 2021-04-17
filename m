Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0507F36308F
	for <lists+kvm@lfdr.de>; Sat, 17 Apr 2021 16:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236367AbhDQOSC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Apr 2021 10:18:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47984 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233008AbhDQOSB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 17 Apr 2021 10:18:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618669054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z7yPFf3+48ZJgqLyzMTV32VBFPPkX9MP19GVAcBjN1s=;
        b=VJ7NptboXQX0n/Kv8zHG2iS+67A0rva9kkSLp37ShxoyR/wKNIJlUeHdBA0VVsc+LvRJ8b
        V3Xrc+cwWcZTEoi6H17GEqdBN+OCTYhdwP+SviARpOEwslfGi3LFmXD0AzX1JdB9FLb/dF
        6hkpFnrqjeKQ+hqTR9Spa7U3JvTDsPM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-sZp32rlcPNaAnOPVtn6KUg-1; Sat, 17 Apr 2021 10:17:33 -0400
X-MC-Unique: sZp32rlcPNaAnOPVtn6KUg-1
Received: by mail-ed1-f69.google.com with SMTP id l22-20020a0564021256b0290384ebfba68cso4855276edw.2
        for <kvm@vger.kernel.org>; Sat, 17 Apr 2021 07:17:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z7yPFf3+48ZJgqLyzMTV32VBFPPkX9MP19GVAcBjN1s=;
        b=cbaYMDNcbPuL0smtE4F9SMW4Yd3Wn/tkoZVgzMb3Sf5x7lBZvPUKaAWaUY24Q6x0l1
         4kcX3wijoklGHCP8FV6fc2S93WdYO+On4Mz5kC1E0MDqKwi5DWb67T8uUP5IaSaRjO+5
         dUweYmL1V+TG9fmfTb3ICXVjn1R3aHjrX0WCk4MfT8SJUmHDQBQVBeDc/zH3rmOmNA7T
         d1I1SVmJidWv71UULkRj+ZHKM38qOYGhgo1OTU6wQ3lKyK+Z1xkOzS4UXQO5jdwr7trA
         Wl+2+qbh5zU1n9ZuNZTWcXcu7tiphbXaqNBCIgj4ZxBDb4QNK4Igbrsv5Q1k3esvgFb+
         La4w==
X-Gm-Message-State: AOAM532rOXRCjSu62zRy3n8mW/kXvpn14biQ0B9p7MVne4bja7YDSPuj
        C6Lzz5QMNoWxuGAfONXDjw7LREk0VuOW0L/Km4V/Jmo3SiKYpyIj+r9P+D/Yl+KsiSvG8RbtolQ
        f7rkG4ufhSm6O
X-Received: by 2002:a17:906:a052:: with SMTP id bg18mr13426641ejb.18.1618669051782;
        Sat, 17 Apr 2021 07:17:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxv0optjUauqZq7UZBqyT+8nq289COjb6Nrfs6UI8i/Bx1jxTdrNLQXqfU3FoFCOV1znmw4AQ==
X-Received: by 2002:a17:906:a052:: with SMTP id bg18mr13426632ejb.18.1618669051578;
        Sat, 17 Apr 2021 07:17:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d1sm6455290eje.26.2021.04.17.07.17.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 07:17:31 -0700 (PDT)
Subject: Re: [PATCH 2/7 v7] KVM: nSVM: Define an exit code to reflect
 consistency check failure
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com
References: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
 <20210412215611.110095-3-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fdf27d2b-d0b6-96fa-f661-bef368f04469@redhat.com>
Date:   Sat, 17 Apr 2021 16:17:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210412215611.110095-3-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/04/21 23:56, Krish Sadhukhan wrote:
> nested_svm_vmrun() returns SVM_EXIT_ERR both when consistency checks for
> MSRPM fail and when merging the MSRPM of vmcb12 with that of KVM fails. These
> two failures are different in that the first one happens during consistency
> checking while the second happens after consistency checking passes and after
> guest mode switch is done. In order to differentiate between the two types of
> error conditions, define an exit code that can be used to denote consistency
> check failures. This new exit code is similar to what nVMX uses to denote
> consistency check failures. For nSVM, we will use the highest bit in the high
> part of the EXIT_CODE field.
> 
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

The exit code is defined by AMD, we cannot change it.

Paolo

> ---
>   arch/x86/include/uapi/asm/svm.h | 1 +
>   arch/x86/kvm/svm/nested.c       | 2 +-
>   2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
> index 554f75fe013c..b0a6550a23f5 100644
> --- a/arch/x86/include/uapi/asm/svm.h
> +++ b/arch/x86/include/uapi/asm/svm.h
> @@ -111,6 +111,7 @@
>   #define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
>   
>   #define SVM_EXIT_ERR           -1
> +#define	SVM_CONSISTENCY_ERR    1 << 31
>   
>   #define SVM_EXIT_REASONS \
>   	{ SVM_EXIT_READ_CR0,    "read_cr0" }, \
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 8453c898b68b..ae53ae46ebca 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -606,7 +606,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
>   	if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save) ||
>   	    !nested_vmcb_check_controls(&svm->nested.ctl)) {
>   		vmcb12->control.exit_code    = SVM_EXIT_ERR;
> -		vmcb12->control.exit_code_hi = 0;
> +		vmcb12->control.exit_code_hi = SVM_CONSISTENCY_ERR;
>   		vmcb12->control.exit_info_1  = 0;
>   		vmcb12->control.exit_info_2  = 0;
>   		goto out;
> 

