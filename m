Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89873352EAD
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 19:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235286AbhDBRpl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 13:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234908AbhDBRpl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 13:45:41 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B5FC0613E6
        for <kvm@vger.kernel.org>; Fri,  2 Apr 2021 10:45:39 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id g15so4026702pfq.3
        for <kvm@vger.kernel.org>; Fri, 02 Apr 2021 10:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eSEUGhg/DNJMaSOiN6UJqXZgCdE5sK2+iSvmcW9CVOQ=;
        b=tZEkKmuYvDXzgXK3IRyDwdoXUk5qH88haJI844Lpm2VI+KH6LiFQ3WyxGGO0t8Njw8
         YB4FtBqT6C31kjWC2ILzktxh3r0GRNMZ2Bk7T7QJcX2PRZgSzskaoTMxXeEAM3ORtQE0
         7OUum91bHriOUZjjtndAlB735fNWogW6Yq1wdPuddDA7AfclXH62qRQGYo0IGl578+Vh
         h3VVWNGca2o4g6JbhGIMOIxPg3GEGof4AlEKmDtsDSiZu4Cxr/QvkIOLas65YukkeD2W
         Ib3pyC2nFFN6OKSp7GaXJ9nzKUMUhQDSvRtJOHOFWup1XJJaRSJstqCQEoKe9vb0UTZZ
         m23g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eSEUGhg/DNJMaSOiN6UJqXZgCdE5sK2+iSvmcW9CVOQ=;
        b=FPYG7KQIVt/QsAqq98HBVWBnRcMoRm37a5lsO1bsoEHAd8FTrMC6wehuuMMb2Xkqpx
         grxomvsmMkmip/l7JQmwCeF7b6rT1yo3j38BFM11wW2+V61NeRF9wUN5FQyTI5tVDP30
         cvrOU7251DQlYEBuPEME+xYT+NR9NDINKkl8hwxl2/dnOMd+VTlDfKtKph+4m6p5Il7+
         loX5epDpGoWiDwDuKqxIwjKOkkWsoGgeptdl7PYIcEB7kSJu0QKw/y+/f+HaXv4uatJn
         1RUPQTRrqTtUVpK3FUg9u91TTBsVGG1TFzFIR+v76L+OVSYOeV86PwUnEy0QIzd4XXB/
         LdPA==
X-Gm-Message-State: AOAM5334yKftMbB9xHBuUMFmcOwx3kV115JVsWfcFC6k0Ef2IPSR2Kxr
        UgXnSypCCykxIHe//MGeZ7hQvg==
X-Google-Smtp-Source: ABdhPJzFYPT+RxqBR2eMCUeJ5cmCifp1DyM+UlHq7Ib1oKCDsH32Tubdv11VvfpuSxceMRa+Cz4k6Q==
X-Received: by 2002:a63:d810:: with SMTP id b16mr12470925pgh.72.1617385539230;
        Fri, 02 Apr 2021 10:45:39 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id mp19sm15903152pjb.2.2021.04.02.10.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 10:45:38 -0700 (PDT)
Date:   Fri, 2 Apr 2021 17:45:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 2/5 v6] nSVM: Check addresses of MSR and IO permission
 maps
Message-ID: <YGdYP46sXC75SwF9@google.com>
References: <20210402004331.91658-1-krish.sadhukhan@oracle.com>
 <20210402004331.91658-3-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210402004331.91658-3-krish.sadhukhan@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 01, 2021, Krish Sadhukhan wrote:
> According to section "Canonicalization and Consistency Checks" in APM vol 2,
> the following guest state is illegal:
> 
>     "The MSR or IOIO intercept tables extend to a physical address that
>      is greater than or equal to the maximum supported physical address."
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>  arch/x86/kvm/svm/nested.c | 23 +++++++++++++++++++----
>  1 file changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index fb204eaa8bb3..b3988b3a3fd5 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -231,7 +231,15 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> -static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
> +static bool nested_svm_check_bitmap_pa(struct kvm_vcpu *vcpu, u64 pa,
> +				       u32 size)

No need to put "u32 size)" on a separate line.

> +{
> +	u64 last_pa = PAGE_ALIGN(pa) + size - 1;

Space between declaration and code.  A comment about the silliness of hardware
silently ignoring bits 11:0 would also be nice.

> +	return (kvm_vcpu_is_legal_gpa(vcpu, last_pa));

This fails to handle the case where "pa == -1", as the above will wrap to a
legal address and generate a false negative.

	/* blah blah blah */
	pa = PAGE_ALIGN(pa);
	return kvm_vcpu_is_legal_gpa(pa) &&
	       kvm_vcpu_is_legal_gpa(pa + size - 1);

> +}
> +
> +static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
> +				       struct vmcb_control_area *control)
>  {
>  	if ((vmcb_is_intercept(control, INTERCEPT_VMRUN)) == 0)
>  		return false;
> @@ -243,6 +251,13 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
>  	    !npt_enabled)
>  		return false;
>  
> +	if (!nested_svm_check_bitmap_pa(vcpu, control->msrpm_base_pa,
> +	    MSRPM_ALLOC_SIZE))
> +		return false;
> +	if (!nested_svm_check_bitmap_pa(vcpu, control->iopm_base_pa,
> +	    IOPM_ALLOC_SIZE - PAGE_SIZE + 1))

Align with the function's paranthesis, not the if statements, for both.

	
	if (!nested_svm_check_bitmap_pa(vcpu, control->iopm_base_pa,
					IOPM_ALLOC_SIZE - PAGE_SIZE + 1))
> +		return false;
> +
>  	return true;
>  }
>  
> @@ -275,7 +290,7 @@ static bool nested_vmcb_check_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
>  		    kvm_vcpu_is_illegal_gpa(vcpu, vmcb12->save.cr3))
>  			return false;
>  	}
> -	if (!kvm_is_valid_cr4(&svm->vcpu, vmcb12->save.cr4))
> +	if (!kvm_is_valid_cr4(vcpu, vmcb12->save.cr4))
>  		return false;
>  
>  	return true;
> @@ -531,7 +546,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
>  	load_nested_vmcb_control(svm, &vmcb12->control);
>  
>  	if (!nested_vmcb_check_save(svm, vmcb12) ||
> -	    !nested_vmcb_check_controls(&svm->nested.ctl)) {
> +	    !nested_vmcb_check_controls(&svm->vcpu, &svm->nested.ctl)) {

Pass "vcpu" directly (probably only once you rebase).

>  		vmcb12->control.exit_code    = SVM_EXIT_ERR;
>  		vmcb12->control.exit_code_hi = 0;
>  		vmcb12->control.exit_info_1  = 0;
> @@ -1207,7 +1222,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  		goto out_free;
>  
>  	ret = -EINVAL;
> -	if (!nested_vmcb_check_controls(ctl))
> +	if (!nested_vmcb_check_controls(vcpu, ctl))
>  		goto out_free;
>  
>  	/*
> -- 
> 2.27.0
> 
