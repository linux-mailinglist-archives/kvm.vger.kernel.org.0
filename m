Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632D949B817
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 16:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354012AbiAYP7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 10:59:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46470 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377129AbiAYP5P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jan 2022 10:57:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643126230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EOuF9uHjmu6EB+RqEY9DRd/3karDS0G1/LHvYVm6MBE=;
        b=NNsZFPRrMX/GyTuCAvq7j/SkMxB+o6W3J8qsru+twPOhd93lNYgM2JdmnAhShWCzW6Wi+j
        mu0Nw7Fg+LAsphg8Lh3277Fx9Us2y8xdAFRHPlgYMdSGqFxGFWcFEaSOhlVgp6W9QG7/TM
        UAO/R5mI6cnFFIKEM2QxBM1MN6P1vCs=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-77-01X4VTcBOKOlDY-Sd6fyVg-1; Tue, 25 Jan 2022 10:57:08 -0500
X-MC-Unique: 01X4VTcBOKOlDY-Sd6fyVg-1
Received: by mail-ej1-f70.google.com with SMTP id v2-20020a1709062f0200b006a5f725efc1so3598612eji.23
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 07:57:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EOuF9uHjmu6EB+RqEY9DRd/3karDS0G1/LHvYVm6MBE=;
        b=wkA1xOIK/jP7L6SQT2AoJU4WHfkSdhhSNNlU79dKlgrHYs7DZ7VZK4ZuvEoDG84eF3
         jK+kpbuUyxAv/SLOwZMXI090NCO782qOGJZFh0hZGFPMfyPkB35oRuiR3dwQ8nhcMkDH
         cYGkPZBa8bKhUJA+1IHLDrGmKfHhLsEgSXMXZwIS2Iv6f5Nj4AQYRxIhtCbReeeRzzFH
         PTl9xfRr63u+cTjPIcr16hqhZ5UaFuysnEQ6wXa85xdXJ1vsHilzrbXaJkyJEr2yKvJL
         Ue3KF67teiyaTXC8qgzbBMFBtmfflqL9cbKHdgrdmhmblGlHzQKMLgg7BddPNxWwBFKH
         b5lQ==
X-Gm-Message-State: AOAM533jn4OD4ktgdvtgiFQXIhQLBIIJLBnkEi+Gt4NzH8NIQOiCvQSx
        qVYhvUUVoiXDgX1bGhEWKTviQP8HCnClYIFpcAx2CW8Evo9FcS5fBHedidUILEdOytVoADOnPGn
        zLzH87znnAJyk
X-Received: by 2002:a17:906:560c:: with SMTP id f12mr17417348ejq.197.1643126227117;
        Tue, 25 Jan 2022 07:57:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxNe7yqYzq/tN13zpUzE8HyivuSwsjoWYJAYE+e8EPE8nGSTY0zvG86PwdV/oTDtJSYJxpJng==
X-Received: by 2002:a17:906:560c:: with SMTP id f12mr17417340ejq.197.1643126226886;
        Tue, 25 Jan 2022 07:57:06 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id ec7sm8453751edb.62.2022.01.25.07.57.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 07:57:06 -0800 (PST)
Message-ID: <21da89ed-fe72-f824-902c-a7c4999a908e@redhat.com>
Date:   Tue, 25 Jan 2022 16:57:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 1/5] KVM: SVM: Drop stale comment from
 svm_hv_vmcb_dirty_nested_enlightenments()
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vineeth Pillai <viremana@linux.microsoft.com>,
        linux-kernel@vger.kernel.org
References: <20211220152139.418372-1-vkuznets@redhat.com>
 <20211220152139.418372-2-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211220152139.418372-2-vkuznets@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/20/21 16:21, Vitaly Kuznetsov wrote:
> Commit 3fa5e8fd0a0e4 ("KVM: SVM: delay svm_vcpu_init_msrpm after
> svm->vmcb is initialized") re-arranged svm_vcpu_init_msrpm() call in
> svm_create_vcpu() making the comment about vmcb being NULL
> obsolete. Drop it.
> 
> While on it, drop superfluous vmcb_is_clean() check: vmcb_mark_dirty()
> is a bit flip, an extra check is unlikely to bring any performance gain.
> Drop now-unneeded vmcb_is_clean() helper as well.
> 
> Fixes: 3fa5e8fd0a0e4 ("KVM: SVM: delay svm_vcpu_init_msrpm after svm->vmcb is initialized")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Queued, but with subject changed to "KVM: SVM: clean up beginning of 
svm_hv_vmcb_dirty_nested_enlightenments()".

Paolo

>   arch/x86/kvm/svm/svm.h          | 5 -----
>   arch/x86/kvm/svm/svm_onhyperv.h | 9 +--------
>   2 files changed, 1 insertion(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index daa8ca84afcc..5d197aae3a19 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -305,11 +305,6 @@ static inline void vmcb_mark_all_clean(struct vmcb *vmcb)
>   			       & ~VMCB_ALWAYS_DIRTY_MASK;
>   }
>   
> -static inline bool vmcb_is_clean(struct vmcb *vmcb, int bit)
> -{
> -	return (vmcb->control.clean & (1 << bit));
> -}
> -
>   static inline void vmcb_mark_dirty(struct vmcb *vmcb, int bit)
>   {
>   	vmcb->control.clean &= ~(1 << bit);
> diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
> index c53b8bf8d013..cdbcfc63d171 100644
> --- a/arch/x86/kvm/svm/svm_onhyperv.h
> +++ b/arch/x86/kvm/svm/svm_onhyperv.h
> @@ -83,14 +83,7 @@ static inline void svm_hv_vmcb_dirty_nested_enlightenments(
>   	struct hv_enlightenments *hve =
>   		(struct hv_enlightenments *)vmcb->control.reserved_sw;
>   
> -	/*
> -	 * vmcb can be NULL if called during early vcpu init.
> -	 * And its okay not to mark vmcb dirty during vcpu init
> -	 * as we mark it dirty unconditionally towards end of vcpu
> -	 * init phase.
> -	 */
> -	if (vmcb_is_clean(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS) &&
> -	    hve->hv_enlightenments_control.msr_bitmap)
> +	if (hve->hv_enlightenments_control.msr_bitmap)
>   		vmcb_mark_dirty(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS);
>   }
>   

