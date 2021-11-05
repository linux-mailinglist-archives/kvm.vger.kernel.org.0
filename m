Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17DD9445D1D
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 01:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbhKEAy6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 20:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbhKEAy5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 20:54:57 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022BEC061203
        for <kvm@vger.kernel.org>; Thu,  4 Nov 2021 17:52:19 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id u11so10083807plf.3
        for <kvm@vger.kernel.org>; Thu, 04 Nov 2021 17:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uCH8t91lFcjRnDOcwcN0CwWqkbbPkrn0hhYpSIb82zA=;
        b=sShQdCLccwDTVD7/q0z6iiCGczwOGvYtn62xONjWmRoX3hdmqa7pWhwkYkTzzDwyap
         f3oftkJVC1wmV6Uf4T5C0neABifO6XS3FOGF4NShFpCz/xx6ZIS5xDUv3k0vUtrV+Eyl
         CmcOzSkhqCOqtuzaQ7slCeMR+Jt7ZmtCzb+FiSPzKIHJpbcCYaoWLuGTOy7yNVPMKwJf
         GAmK3AepxvfCl03MkAQsWFBsvuTa7J7IeunyyI5elnECuXPXQq2HhBBlC/MYubetH2rv
         zNTanOSJbueofxyorefgQ4Br7WEdTS9FF8nRYxfpXoO6byCf8B2LXgWcuId/w/mgcMj0
         NK0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uCH8t91lFcjRnDOcwcN0CwWqkbbPkrn0hhYpSIb82zA=;
        b=jws01nRXhtdmb/7ftzcTduapzFGHRZcdnHL35tOsuUwgBUanMTn43vJ+5aOWdOe5r6
         st3Bxypk/MJDkzEWNTJq7VXPEmjfald7Uv7S+P0h6gMKC2bK3EnM46fzJH6Mw0QX+obD
         Ln445mVJ9X6upioJsAAsoRWU8kdMoz+ukZr3LMxl8H7WDi2x1EPCtjBJ2RJYmX5yTLAz
         jyvjPqLCR0StYX25BcBKcqKwQ4JoiYDY7+7aCBHrn/212Oljrrmxo5Kfa0tPu3mh7ETo
         +FUdiDgtmKyHk/JYB+juf4rHY/qMET8TEbj1m4cqUlpRg5oEbcQKMIm8ZrSu7f8EadPq
         ZCJA==
X-Gm-Message-State: AOAM532q0gk7TUf00C+FcgixfvdHESC2FCg7Tk4oFT1HfYc/Bw1vd/Xe
        EhtorzfgkyLteiB1E781R3w8Ww==
X-Google-Smtp-Source: ABdhPJyckkmkJ2vXm4o42wBECVNwchkOxHObIjzHdPLNT6jPQYr8FAavO3PW84g/hXRjV4HSaLEsRQ==
X-Received: by 2002:a17:90a:fd96:: with SMTP id cx22mr26586829pjb.151.1636073538326;
        Thu, 04 Nov 2021 17:52:18 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t66sm2046078pfd.150.2021.11.04.17.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 17:52:17 -0700 (PDT)
Date:   Fri, 5 Nov 2021 00:52:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] KVM: nVMX: Don't use Enlightened MSR Bitmap for L3
Message-ID: <YYSAPotqLVIScunK@google.com>
References: <20211013142258.1738415-1-vkuznets@redhat.com>
 <20211013142258.1738415-2-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013142258.1738415-2-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 13, 2021, Vitaly Kuznetsov wrote:
> 3-level nesting is also not a very common setup nowadays.

Says who? :-D

> Don't enable 'Enlightened MSR Bitmap' feature for KVM's L2s (real L3s) for
> now.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 1c8b2b6e7ed9..e82cdde58119 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2655,15 +2655,6 @@ int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
>  		if (!loaded_vmcs->msr_bitmap)
>  			goto out_vmcs;
>  		memset(loaded_vmcs->msr_bitmap, 0xff, PAGE_SIZE);
> -
> -		if (IS_ENABLED(CONFIG_HYPERV) &&
> -		    static_branch_unlikely(&enable_evmcs) &&
> -		    (ms_hyperv.nested_features & HV_X64_NESTED_MSR_BITMAP)) {
> -			struct hv_enlightened_vmcs *evmcs =
> -				(struct hv_enlightened_vmcs *)loaded_vmcs->vmcs;
> -
> -			evmcs->hv_enlightenments_control.msr_bitmap = 1;
> -		}
>  	}
>  
>  	memset(&loaded_vmcs->host_state, 0, sizeof(struct vmcs_host_state));
> @@ -6903,6 +6894,18 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>  
>  	vmx->loaded_vmcs = &vmx->vmcs01;
>  
> +	/*
> +	 * Use Hyper-V 'Enlightened MSR Bitmap' feature when KVM runs as a
> +	 * nested (L1) hypervisor and Hyper-V in L0 supports it.

And maybe call out specifically that KVM intentionally uses this only for vmcs02?

> +	 */
> +	if (IS_ENABLED(CONFIG_HYPERV) && static_branch_unlikely(&enable_evmcs)
> +	    && (ms_hyperv.nested_features & HV_X64_NESTED_MSR_BITMAP)) {

&& on the previous line, I think we'll survive the 82 char line :-)

> +		struct hv_enlightened_vmcs *evmcs =
> +			(struct hv_enlightened_vmcs *)vmx->loaded_vmcs->vmcs;

Hmm, what about landing this right after vmcs01's VMCS is allocated?  It's kinda
weird, but it makes it more obvious that ->vmcs is not NULL.  And if the cast is
simply via a "void *" it all fits on one line.

	err = alloc_loaded_vmcs(&vmx->vmcs01);
	if (err < 0)
		goto free_pml;

	/*
	 * Use Hyper-V 'Enlightened MSR Bitmap' feature when KVM runs as a
	 * nested (L1) hypervisor and Hyper-V in L0 supports it.  Enable an
	 * enlightened bitmap only for vmcs01, KVM currently isn't equipped to
	 * realize any performance benefits from enabling it for vmcs02.
	 */ 
	if (IS_ENABLED(CONFIG_HYPERV) && static_branch_unlikely(&enable_evmcs) &&
	    (ms_hyperv.nested_features & HV_X64_NESTED_MSR_BITMAP)) {
		struct hv_enlightened_vmcs *evmcs = (void *)vmx->vmcs01.vmcs;

		evmcs->hv_enlightenments_control.msr_bitmap = 1;
	}

> +
> +		evmcs->hv_enlightenments_control.msr_bitmap = 1;
> +	}
> +
>  	if (cpu_need_virtualize_apic_accesses(vcpu)) {
>  		err = alloc_apic_access_page(vcpu->kvm);
>  		if (err)
> -- 
> 2.31.1
> 
