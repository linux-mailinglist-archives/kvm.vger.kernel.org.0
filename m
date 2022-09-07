Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2BD5AF8CD
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 02:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiIGACH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 20:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiIGACF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 20:02:05 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2E082F94
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 17:02:05 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id y136so8014593pfb.3
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 17:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=1L8zL0o7hTZtMzz6sR/DF9E7wPl56tqPy/lCxtqOjSo=;
        b=Wg3tZwZz4PCbUKY7fMW64CU6pz20UFcs401F35uqUB7HUNUddlTNKPvTGNWIzMssRG
         ajegWZM4om0Vg/U1dG8KWj/6eF6Nxv5CafceHgbSrvtshepiKIerXO/FccT2/LzYdB7A
         /rNKAwqkVAsEAHjDHFzj0t6m3XfHidf4Fdghj8NrPWYbBpmsVqq6teBEKDBN4GoP94oR
         Q+jpJA8VnpRK9/lTFGuYRveUNnjimQ8Ty3tvQ8Rp8FbhH1vwpUZ7CkZ0Vsyh7jdbLeke
         TLrXcBCfvzRxbMJkq+BRV7L3OINhM8dk8rUQZwNQwyJaSEWIOpcL93UKrkx4Ij2xFBFz
         PqnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=1L8zL0o7hTZtMzz6sR/DF9E7wPl56tqPy/lCxtqOjSo=;
        b=qu4BEx3Ki+SPj1GlDXXNf+1CZbspxgbFn2TgXvsRzpcz/0ZCeoIfbYVIrE+Tr/pBDh
         pX5cN2H7Uh7chyT89HEPhu2we1XbSTOFv7HI4rdr+CGvAWePvcf2TJ9KgD9xK5qbBdxv
         JnaVwLMYDZYdglIS4YW9HpnRnmRcZE4JWOUP40VxKoXKBM7K0i4vxbMgwIZBzR5eZ4Wc
         Rp/5V4esNnieSLpnuASct3wgwcYtgMw04IjZGDozxCfNpMjUBwXMWWJ0mdCDEJXH+6ro
         yusuFACeDuW+p7k/zGdpoZwcxPIJjqaLBndLhQybHykCnC9GJJ/tzoTV20qeZgzauG3f
         nhtw==
X-Gm-Message-State: ACgBeo0qjqXLnDHyaU89Lf7hBXnWUeJIVLZbjeJXuUL9Hs9iy2h7qLPj
        VCblBX54VtSqgvFSKXW2vphGzA==
X-Google-Smtp-Source: AA6agR4wPzrSFCcW5dYDC3uCWk2IudY5waEIswutRI9pzVOkZebH02YEovOmpOfw5alWlivIHqkAKw==
X-Received: by 2002:a63:81c1:0:b0:434:aeab:7b42 with SMTP id t184-20020a6381c1000000b00434aeab7b42mr979234pgd.619.1662508924385;
        Tue, 06 Sep 2022 17:02:04 -0700 (PDT)
Received: from google.com (33.5.83.34.bc.googleusercontent.com. [34.83.5.33])
        by smtp.gmail.com with ESMTPSA id p3-20020a170902e74300b0017680faa1a8sm8562628plf.112.2022.09.06.17.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 17:02:03 -0700 (PDT)
Date:   Wed, 7 Sep 2022 00:02:00 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>, y@google.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 3/4] KVM: selftests: Add support for posted interrupt
 handling in L2
Message-ID: <YxffeH1AltmmWM8u@google.com>
References: <20220828222544.1964917-1-mizhang@google.com>
 <20220828222544.1964917-4-mizhang@google.com>
 <YwznLAqRb2i4lHiH@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwznLAqRb2i4lHiH@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 29, 2022, Sean Christopherson wrote:
> On Sun, Aug 28, 2022, Mingwei Zhang wrote:
> > Add support for posted interrupt handling in L2. This is done by adding
> > needed data structures in vmx_pages and APIs to allow an L2 receive posted
> > interrupts.
> > 
> > Cc: Jim Mattson <jmattson@google.com>
> > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > ---
> >  tools/testing/selftests/kvm/include/x86_64/vmx.h | 10 ++++++++++
> >  tools/testing/selftests/kvm/lib/x86_64/vmx.c     | 14 ++++++++++++++
> >  2 files changed, 24 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
> > index 99fa1410964c..69784fc71bce 100644
> > --- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
> > +++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
> > @@ -577,6 +577,14 @@ struct vmx_pages {
> >  	void *apic_access_hva;
> >  	uint64_t apic_access_gpa;
> >  	void *apic_access;
> > +
> > +	void *virtual_apic_hva;
> > +	uint64_t virtual_apic_gpa;
> > +	void *virtual_apic;
> > +
> > +	void *posted_intr_desc_hva;
> > +	uint64_t posted_intr_desc_gpa;
> > +	void *posted_intr_desc;
> 
> Can you add a prep patch to dedup the absurd amount of copy-paste code related to
> vmx_pages?
> 
> I.e. take this and give all the other triplets the same treatment.

Will do.

> 
> ---
>  tools/testing/selftests/kvm/include/x86_64/vmx.h | 10 +++++++---
>  tools/testing/selftests/kvm/lib/x86_64/vmx.c     | 15 ++++++++++-----
>  2 files changed, 17 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
> index 99fa1410964c..ecc66d65acc1 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
> @@ -537,10 +537,14 @@ static inline uint32_t vmcs_revision(void)
>  	return rdmsr(MSR_IA32_VMX_BASIC);
>  }
> 
> +struct vmx_page {
> +	void *gva;
> +	uint64_t gpa;
> +	void *hva;
> +};
> +
>  struct vmx_pages {
> -	void *vmxon_hva;
> -	uint64_t vmxon_gpa;
> -	void *vmxon;
> +	struct vmx_page vmxon;
> 
>  	void *vmcs_hva;
>  	uint64_t vmcs_gpa;
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> index 80a568c439b8..e4eeab85741a 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> @@ -58,6 +58,13 @@ int vcpu_enable_evmcs(struct kvm_vcpu *vcpu)
>  	return evmcs_ver;
>  }
> 
> +static void vcpu_alloc_vmx_page(struct kvm_vm *vm, struct vmx_page *page)
> +{
> +	page->gva = (void *)vm_vaddr_alloc_page(vm);
> +	page->hva = addr_gva2hva(vm, (uintptr_t)page->gva);
> +	page->gpa = addr_gva2gpa(vm, (uintptr_t)page->gva);
> +}
> +
>  /* Allocate memory regions for nested VMX tests.
>   *
>   * Input Args:
> @@ -76,9 +83,7 @@ vcpu_alloc_vmx(struct kvm_vm *vm, vm_vaddr_t *p_vmx_gva)
>  	struct vmx_pages *vmx = addr_gva2hva(vm, vmx_gva);
> 
>  	/* Setup of a region of guest memory for the vmxon region. */
> -	vmx->vmxon = (void *)vm_vaddr_alloc_page(vm);
> -	vmx->vmxon_hva = addr_gva2hva(vm, (uintptr_t)vmx->vmxon);
> -	vmx->vmxon_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->vmxon);
> +	vcpu_alloc_vmx_page(vm, &vmx->vmxon);
> 
>  	/* Setup of a region of guest memory for a vmcs. */
>  	vmx->vmcs = (void *)vm_vaddr_alloc_page(vm);
> @@ -160,8 +165,8 @@ bool prepare_for_vmx_operation(struct vmx_pages *vmx)
>  		wrmsr(MSR_IA32_FEAT_CTL, feature_control | required);
> 
>  	/* Enter VMX root operation. */
> -	*(uint32_t *)(vmx->vmxon) = vmcs_revision();
> -	if (vmxon(vmx->vmxon_gpa))
> +	*(uint32_t *)(vmx->vmxon.gva) = vmcs_revision();
> +	if (vmxon(vmx->vmxon.gpa))
>  		return false;
> 
>  	return true;
> 
> base-commit: 372d07084593dc7a399bf9bee815711b1fb1bcf2
> --
> 
