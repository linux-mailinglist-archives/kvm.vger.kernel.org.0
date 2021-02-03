Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92EBA30D529
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 09:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbhBCIYp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 03:24:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42092 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232526AbhBCIYd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 03:24:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612340586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GxWB40zhs5nePodYTbAgfnGwCrJPUKUB3VUIrWRZCZ4=;
        b=a4chRDQlrZa+nJNXTxQFMSYpMMOxEIKrbCi5OqCtV/5lgnAw88qcpmbT6pQ5rXxLIoKoiq
        E/6m60LbswqlyCglD+9TVofTxliDXosxIez3ubTy1Dmy0giXwiE1+knrSqEy7n+4iWLGEw
        3kB9/8gXTc9R+lQeT1v8ccyZVcfvXTo=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-9bpar-cMOKqcoD5i37QZ5A-1; Wed, 03 Feb 2021 03:23:05 -0500
X-MC-Unique: 9bpar-cMOKqcoD5i37QZ5A-1
Received: by mail-ej1-f71.google.com with SMTP id w16so4010408ejk.7
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 00:23:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GxWB40zhs5nePodYTbAgfnGwCrJPUKUB3VUIrWRZCZ4=;
        b=gFw0EFZj67d/6mkyQT8OB5Swa8imB8s6Eehq71i4VKENPQP8LkpVXH3Vpu9dOj3aP6
         SIhizDYvHonMcTuaSnCNzwEG8VSVrK8qtzTv7806WhslsZAEqoxiV9AVXZaIykxhCk49
         d7O3cfFYcFBHvtbRenqe+DzoHtStQps9jsKzxIoTu9+zBcYQAwWLdIuqVUD1dPpZNk6y
         y4ruckr5lAVvlLAqAdShawV8Yo4vp7L/YUnZwn8R5kroEXNlM7CdlnRXygZq8QKSrVxd
         HyZTBEByYXKoU0mImL50scs9mTEw3m4hRr/E4iMgcKMCur5Rr8FyxXeRGllhX9AB9mFe
         YhAw==
X-Gm-Message-State: AOAM532steMd01KujZewkqOpBHIUtY971N1rnMKCcE1zAgAbTniz5GEp
        PhbDe/zlJW7n1eYtlbD41wKCFgjYDejrrj58jQY85Z+iYPuH+nnUHRavqO74VJTtrSwLPrD4f+i
        vfSN71hLOPE4L
X-Received: by 2002:a17:906:f195:: with SMTP id gs21mr2065832ejb.225.1612340584139;
        Wed, 03 Feb 2021 00:23:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxJuYm7EmH0rcNZ8IuJ+pMV7AO08/Gb7RpOqdEgNNdylGtBTvK1bs+V4sQC7bAYoEJ5unop3A==
X-Received: by 2002:a17:906:f195:: with SMTP id gs21mr2065821ejb.225.1612340583951;
        Wed, 03 Feb 2021 00:23:03 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g2sm627230ejk.108.2021.02.03.00.23.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 00:23:03 -0800 (PST)
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com
References: <20210203004035.101292-1-krish.sadhukhan@oracle.com>
 <20210203004035.101292-3-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/5 v3] nSVM: Check addresses of MSR and IO bitmap
Message-ID: <506f0a7f-ff99-2ed5-dadd-83375e50adf8@redhat.com>
Date:   Wed, 3 Feb 2021 09:23:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210203004035.101292-3-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/21 01:40, Krish Sadhukhan wrote:
> According to section "Canonicalization and Consistency Checks" in APM vol 2,
> the following guest state is illegal:
> 
>          "The MSR or IOIO intercept tables extend to a physical address that
>           is greater than or equal to the maximum supported physical address."
> 
> Also check that these addresses are aligned on page boundary.
> 
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>   arch/x86/kvm/svm/nested.c | 20 ++++++++++++++------
>   1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 7a605ad8254d..caf285e643db 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -214,7 +214,8 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
>   	return true;
>   }
>   
> -static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
> +static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
> +				       struct vmcb_control_area *control)
>   {
>   	if ((vmcb_is_intercept(control, INTERCEPT_VMRUN)) == 0)
>   		return false;
> @@ -226,10 +227,17 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
>   	    !npt_enabled)
>   		return false;
>   
> +	if (!page_address_valid(vcpu, control->msrpm_base_pa +
> +	    MSRPM_ALLOC_ORDER * PAGE_SIZE))
> +		return false;
> +	if (!page_address_valid(vcpu, control->iopm_base_pa +
> +	    IOPM_ALLOC_ORDER * PAGE_SIZE))

There are four problems:

1) The value does not have to be page-aligned

2) you also have an off-by-one here, the value to be checked is the last 
byte of the previous page

3) ORDER is a shift count not a number of pages

4) there could be an overflow

1-3 can be fixed by something like this:

if (!page_address_valid(vcpu,
                         PAGE_ALIGN(control->xyz_pa) +
                         ((PAGE_SIZE << XYZ_ALLOC_ORDER) - 1)));

but it's even better to extract everything to a new function and not use 
page_address_valid at all.

static inline nested_check_pa(struct kvm_vcpu *vcpu, uint64_t pa,
                               unsigned int order)
{
	uint64_t last_pa = PAGE_ALIGN(pa) + (PAGE_SIZE << order) - 1;
	return last_pa > pa && !(last_pa >> cpuid_maxphyaddr(vcpu));
}

Paolo

> +		return false;
> +
>   	return true;
>   }
>   
> -static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb12)
> +static bool nested_vmcb_checks(struct kvm_vcpu *vcpu, struct vmcb *vmcb12)
>   {
>   	bool vmcb12_lma;
>   
> @@ -258,10 +266,10 @@ static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb12)
>   		    (vmcb12->save.cr3 & MSR_CR3_LONG_MBZ_MASK))
>   			return false;
>   	}
> -	if (!kvm_is_valid_cr4(&svm->vcpu, vmcb12->save.cr4))
> +	if (!kvm_is_valid_cr4(vcpu, vmcb12->save.cr4))
>   		return false;
>   
> -	return nested_vmcb_check_controls(&vmcb12->control);
> +	return nested_vmcb_check_controls(vcpu, &vmcb12->control);
>   }
>   
>   static void load_nested_vmcb_control(struct vcpu_svm *svm,
> @@ -488,7 +496,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
>   	if (WARN_ON_ONCE(!svm->nested.initialized))
>   		return -EINVAL;
>   
> -	if (!nested_vmcb_checks(svm, vmcb12)) {
> +	if (!nested_vmcb_checks(&svm->vcpu, vmcb12)) {
>   		vmcb12->control.exit_code    = SVM_EXIT_ERR;
>   		vmcb12->control.exit_code_hi = 0;
>   		vmcb12->control.exit_info_1  = 0;
> @@ -1176,7 +1184,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>   		goto out_free;
>   
>   	ret = -EINVAL;
> -	if (!nested_vmcb_check_controls(ctl))
> +	if (!nested_vmcb_check_controls(vcpu, ctl))
>   		goto out_free;
>   
>   	/*
> 

