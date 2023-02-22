Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD37069FD25
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 21:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbjBVUnE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 15:43:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232774AbjBVUnD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 15:43:03 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 528D67A9C;
        Wed, 22 Feb 2023 12:42:57 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id bp25so11840252lfb.0;
        Wed, 22 Feb 2023 12:42:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677098576;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3pLghbOMnh1AF6uxDquwPbjxAIvGIgrI59/gCPI5GL8=;
        b=LoYZQSVZum4vtB0QbV6sETXieLV8c6vvsXwrHI1vh+AGuUKZMBsz8L7mM6LfJKELKI
         QfvgfhQg+sZ/gniTDFx3ZAy9/xXY55xBIwFP9lZhRlKUk17axgFRUh5vGc8iR+XCl/cx
         jqyyglRPUmn8fEwbDuoZApjPmcKsSiGfD7uz8HQShxJ3mXr1pDKtTKyRlT6NUz6kIiKm
         Rxn5eWJkMDTN7uV4ofHLWtRNGeDVouEKAZuSMJvw94LX3zOwxeJHH2B0U8532rh8gNFl
         CFCAjb80p3am8S6nfeiqM3ZtA5Mnc47up8bpowWhniLnBjT1i6Zkq6FDLT/qd9SBCY/2
         Hh8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677098576;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3pLghbOMnh1AF6uxDquwPbjxAIvGIgrI59/gCPI5GL8=;
        b=FYfOBrAk8+ZV5jOGWQ6YIMK3mn+nAC5ruGWy3zOVbtbSoxsp9a0784qK/+hrkY2PNE
         ssMkV9YUL0PO3XL5vnRPN5+D4OdWqOdeG2NKtvg4UVeFThhZFwXihPNSfZ8pZPADyHAS
         Al6D4fv32zg28RLEOcx23s4LMDQd6kg5Esqx8VA44qVOyjF5OBMt9PQlTcmxPSLq7uxz
         YFvCozmv7e35S56rCgzQT5mrXfBTE4tMaZqu188W+/kVhdf0tGWwqFTE/murbBOCNnOx
         CbMfON2hGiSqhcYuBazDRd+3MCrSEKcIFApbthR8ojpA67IX7yUKgheQVoOXNhXpIIQR
         QWHQ==
X-Gm-Message-State: AO0yUKXY/YK3Thk8Y34HOgfniRZ3Ta/hjjdHgtwFUdYsoUi6QW36I/x3
        LVcRGZUzEfg5OizLQkNubf0=
X-Google-Smtp-Source: AK7set8rAA9AhpMbKSjj7YzXz1bfeSjIQsdkFqAlsea9eIRT6FzIZoaOkh8a/2uc/4oVhXEb/Qh2bw==
X-Received: by 2002:a05:6512:7b:b0:4dd:a025:d87 with SMTP id i27-20020a056512007b00b004dda0250d87mr426608lfo.0.1677098576019;
        Wed, 22 Feb 2023 12:42:56 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id a28-20020ac2521c000000b004d34238ca44sm1135378lfl.214.2023.02.22.12.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 12:42:55 -0800 (PST)
Date:   Wed, 22 Feb 2023 22:42:53 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH RFC v8 31/56] KVM: SVM: Make AVIC backing, VMSA and VMCB
 memory allocation SNP safe
Message-ID: <20230222224253.00002740@gmail.com>
In-Reply-To: <20230220183847.59159-32-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
        <20230220183847.59159-32-michael.roth@amd.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 Feb 2023 12:38:22 -0600
Michael Roth <michael.roth@amd.com> wrote:

> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> Implement a workaround for an SNP erratum where the CPU will incorrectly
> signal an RMP violation #PF if a hugepage (2mb or 1gb) collides with the
> RMP entry of a VMCB, VMSA or AVIC backing page.
> 
> When SEV-SNP is globally enabled, the CPU marks the VMCB, VMSA, and AVIC
> backing   pages as "in-use" in the RMP after a successful VMRUN.  This

Is this "in-use" bit part of an RMP entry? If yes, better list its name 
in APM.

> is done for _all_ VMs, not just SNP-Active VMs.
_All_ VMs? Do you mean SEV VMs and SEVSNP VMs? I guess legacy VM is not
affected, right?
>
> If the hypervisor accesses an in-use page through a writable
> translation, the CPU will throw an RMP violation #PF. On early SNP
> hardware, if an in-use page is 2mb aligned and software accesses any
> part of the associated 2mb region with a hupage, the CPU will
                                            ^hugepage
> incorrectly treat the entire 2mb region as in-use and signal a spurious
> RMP violation #PF.
> 
> The recommended is to not use the hugepage for the VMCB, VMSA or
> AVIC backing page. Add a generic allocator that will ensure that the
> page returns is not hugepage (2mb or 1gb) and is safe to be used when
> SEV-SNP is enabled.
> 
> Co-developed-by: Marc Orr <marcorr@google.com>
> Signed-off-by: Marc Orr <marcorr@google.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  2 ++
>  arch/x86/kvm/lapic.c               |  5 ++++-
>  arch/x86/kvm/svm/sev.c             | 33 ++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c             | 15 ++++++++++++--
>  arch/x86/kvm/svm/svm.h             |  1 +
>  6 files changed, 54 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 6a885f024a00..e116405cbb5f 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -131,6 +131,7 @@ KVM_X86_OP(msr_filter_changed)
>  KVM_X86_OP(complete_emulated_msr)
>  KVM_X86_OP(vcpu_deliver_sipi_vector)
>  KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
> +KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
>  KVM_X86_OP_OPTIONAL_RET0(fault_is_private);
>  KVM_X86_OP_OPTIONAL_RET0(update_mem_attr)
>  KVM_X86_OP_OPTIONAL(invalidate_restricted_mem)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 37c92412035f..a9363a6f779d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1729,6 +1729,8 @@ struct kvm_x86_ops {
>  	 * Returns vCPU specific APICv inhibit reasons
>  	 */
>  	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
> +
> +	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
>  };
>  
>  struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 80f92cbc4029..72e46d5b4201 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2740,7 +2740,10 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
>  
>  	vcpu->arch.apic = apic;
>  
> -	apic->regs = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
> +	if (kvm_x86_ops.alloc_apic_backing_page)
> +		apic->regs = static_call(kvm_x86_alloc_apic_backing_page)(vcpu);
> +	else
> +		apic->regs = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
>  	if (!apic->regs) {
>  		printk(KERN_ERR "malloc apic regs error for vcpu %x\n",
>  		       vcpu->vcpu_id);
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c1f0d4898ce3..9e9efb42a766 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3241,3 +3241,36 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>  		break;
>  	}
>  }
> +
> +struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long pfn;
> +	struct page *p;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +
> +	/*
> +	 * Allocate an SNP safe page to workaround the SNP erratum where
> +	 * the CPU will incorrectly signal an RMP violation  #PF if a
> +	 * hugepage (2mb or 1gb) collides with the RMP entry of VMCB, VMSA
> +	 * or AVIC backing page. The recommeded workaround is to not use the
> +	 * hugepage.
> +	 *
> +	 * Allocate one extra page, use a page which is not 2mb aligned
> +	 * and free the other.
> +	 */
> +	p = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO, 1);
> +	if (!p)
> +		return NULL;
> +
> +	split_page(p, 1);
> +
> +	pfn = page_to_pfn(p);
> +	if (IS_ALIGNED(pfn, PTRS_PER_PMD))
> +		__free_page(p++);
> +	else
> +		__free_page(p + 1);
> +
> +	return p;
> +}

The duplicate allocation routine in snp_alloc_vmsa_page() in sev.c can
be replaced with snp_safe_alloc_page().

> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 213593dbd7a1..1061aaf66f0a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1372,7 +1372,7 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
>  	svm = to_svm(vcpu);
>  
>  	err = -ENOMEM;
> -	vmcb01_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +	vmcb01_page = snp_safe_alloc_page(vcpu);
>  	if (!vmcb01_page)
>  		goto out;
>  
> @@ -1381,7 +1381,7 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
>  		 * SEV-ES guests require a separate VMSA page used to contain
>  		 * the encrypted register state of the guest.
>  		 */
> -		vmsa_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +		vmsa_page = snp_safe_alloc_page(vcpu);
>  		if (!vmsa_page)
>  			goto error_free_vmcb_page;
>  
> @@ -4696,6 +4696,16 @@ static int svm_vm_init(struct kvm *kvm)
>  	return 0;
>  }
>  
> +static void *svm_alloc_apic_backing_page(struct kvm_vcpu *vcpu)
> +{
> +	struct page *page = snp_safe_alloc_page(vcpu);
> +
> +	if (!page)
> +		return NULL;
> +
> +	return page_address(page);
> +}
> +
>  static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.name = KBUILD_MODNAME,
>  
> @@ -4824,6 +4834,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  
>  	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
>  	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
> +	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
>  };
>  
>  /*
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index c249c360fe36..5efcf036ccad 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -692,6 +692,7 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm);
>  void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
>  void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
>  void sev_es_unmap_ghcb(struct vcpu_svm *svm);
> +struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
>  
>  /* vmenter.S */
>  

