Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 042116C8342
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 18:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbjCXRYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 13:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbjCXRYX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 13:24:23 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97EBF9EE6
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 10:24:21 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id oa14-20020a17090b1bce00b0023d1b58d3baso868409pjb.4
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 10:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679678661;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=L7L+npDRYXiAZkJEepgnaawjk9p3K8XqZzqSe1AxSxs=;
        b=P4FlomE7/eTD8ZXr0/cuAo0YAK93rbyLF4+h2EJbSWMnb0Xv84UgJvrKDv6A66wF8z
         7Sl9Wlax7+rMgCoj2jOdNj/HLL4OMUdBFEuwEe7sFO7vEwX2An1Vw72mCuFXeibJ1hXV
         sRGlS8o/d/Hf+JU/p29kmWnQgchqdVHSHihMTr4SSLWkwrU9390B7QggD6JsOUj7tgjC
         7duP0mRPDyArTHAXGROIXqLeE7SthT3dC5QABoUNvmjkzwhZLlKfwiQVpBMLFJpBhb/5
         t61ZUKIacsd21YmeTUD5yMYTiWJQnMkmunrARnvnDO8MnD/E9GI5A7AqsoODDaJHLifD
         a58w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679678661;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L7L+npDRYXiAZkJEepgnaawjk9p3K8XqZzqSe1AxSxs=;
        b=mqB+SN2vQSp/sLpZ8mtAOKjv/mhIFrOkrPWVj3LRpqxdo2NlSP1N/PSMefXrnFZF8h
         s/vId7TTHw+rbf38wdBPP7qXr/PDwherfZd/tFMp4xqKTtmx63oWNcqPUiWBE1/lnLG6
         6hTs+ioAaezd9oQqe3YTWJZVm9p0bzKE0Z27OtmWQNkYqYyGe/ZqJvJzM5qBk55Vi/Mf
         Pw4/VWQJjsCQu3LbILwDlLCiHLwrXy17dPOttIJsQbj7xV3tDJpXj8G+L9/K/M5FQYWw
         n4mBExkecGTse0u/xZU5vSb0zLxPtXhpiobuLkCEOGR6NdXb84XhMiDptD3VQ28ojuSW
         kdhw==
X-Gm-Message-State: AAQBX9cP6kvTnukniYyXTWw0QxO586Y3P+KSy/pvTemA9KoocuQauar8
        xA0dKoZAcgFeWg6zW5xT5YxRri9phvk=
X-Google-Smtp-Source: AKy350baImAjzbXV/P29CN3tNd99n6TbsIibuJLoHcyRhH5ftYXylw7d972nOR8RBatj9aSgb6cmy8ZuBzc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:5507:0:b0:513:25c1:649b with SMTP id
 f7-20020a655507000000b0051325c1649bmr702423pgr.11.1679678661165; Fri, 24 Mar
 2023 10:24:21 -0700 (PDT)
Date:   Fri, 24 Mar 2023 10:24:19 -0700
In-Reply-To: <20230110175057.715453-4-pgonda@google.com>
Mime-Version: 1.0
References: <20230110175057.715453-1-pgonda@google.com> <20230110175057.715453-4-pgonda@google.com>
Message-ID: <ZB3cw4qsIOXUqS0X@google.com>
Subject: Re: [PATCH V6 3/7] KVM: selftests: handle protected bits in page tables
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 10, 2023, Peter Gonda wrote:
> SEV guests rely on an encyption bit which resides within the range that
> current code treats as address bits. Guest code will expect these bits
> to be set appropriately in their page tables, whereas the rest of the
> kvm_util functions will generally expect these bits to not be present.
> Introduce pte_me_mask and struct kvm_vm_arch to allow for arch specific
> address tagging. Currently just adding

State what the patch does, not what you are doing.

> x86 c_bit and s_bit support for SEV and TDX.

Move the c_bit and s_bit stuff to a different patch.  The introduction of
kvm_util_arch.h and kvm_vm_arch should also go in a separate patch.

> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Vishal Annapurve <vannapurve@google.com>
> Cc: Ackerley Tng <ackerleytng@google.com>
> cc: Andrew Jones <andrew.jones@linux.dev>
> Originally-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> ---
>  tools/arch/arm64/include/asm/kvm_host.h       |  7 +++++++
>  tools/arch/riscv/include/asm/kvm_host.h       |  7 +++++++
>  tools/arch/s390/include/asm/kvm_host.h        |  7 +++++++
>  tools/arch/x86/include/asm/kvm_host.h         | 13 ++++++++++++

Ugh, we need to think of a name other than kvm_host.h, that's going to be far
too confusing with KVM proper's versions.  I want to use kvm_arch.h in KVM proper
too, so that's off the table.  Maybe kvm_util_arch.h?

> @@ -162,6 +167,7 @@ enum vm_guest_mode {
>  	VM_MODE_P40V48_16K,
>  	VM_MODE_P40V48_64K,
>  	VM_MODE_PXXV48_4K,	/* For 48bits VA but ANY bits PA */
> +	VM_MODE_PXXV48_4K_SEV,	/* For 48bits VA but ANY bits PA */

This belongs in the SEV library patch.

>  	VM_MODE_P47V64_4K,
>  	VM_MODE_P44V64_4K,
>  	VM_MODE_P36V48_4K,
> @@ -441,6 +447,17 @@ void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva);
>  vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
>  void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa);
>  
> +

Spurious newline.

> +static inline vm_paddr_t vm_untag_gpa(struct kvm_vm *vm, vm_paddr_t gpa)
> +{
> +	return gpa & ~vm->gpa_protected_mask;
> +}
> +
> +static inline vm_paddr_t vm_tag_gpa(struct kvm_vm *vm, vm_paddr_t gpa)

After seeing how this is all used, this should not exist, i.e. common code should
not (and cannot) tag GPAs, because common code doesn't know the polarity (the whole
C vs. S madness).

So delete this, and then rename gpa_protected_mask to something like gpa_tag_mask,
i.e. make it _really_ generic.

> +{
> +	return gpa | vm->gpa_protected_mask;
> +}
> +
>  void vcpu_run(struct kvm_vcpu *vcpu);
>  int _vcpu_run(struct kvm_vcpu *vcpu);
>  
> @@ -917,4 +934,6 @@ void kvm_selftest_arch_init(void);
>  
>  void kvm_arch_vm_post_create(struct kvm_vm *vm);
>  
> +bool vm_is_gpa_protected(struct kvm_vm *vm, vm_paddr_t paddr);
> +
>  #endif /* SELFTEST_KVM_UTIL_BASE_H */
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 63913b219b42..ba771c2d949d 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1451,9 +1451,10 @@ void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
>   * address providing the memory to the vm physical address is returned.
>   * A TEST_ASSERT failure occurs if no region containing gpa exists.
>   */
> -void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa)
> +void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa_tagged)
>  {
>  	struct userspace_mem_region *region;
> +	vm_paddr_t gpa = vm_untag_gpa(vm, gpa_tagged);

Now need to rename the incoming param, just do

	gpa = vm_untag_gpa(gpa);
>  
>  	region = userspace_mem_region_find(vm, gpa, gpa);
>  	if (!region) {
> @@ -2147,3 +2148,21 @@ void __attribute((constructor)) kvm_selftest_init(void)
>  
>  	kvm_selftest_arch_init();
>  }
> +
> +bool vm_is_gpa_protected(struct kvm_vm *vm, vm_paddr_t paddr)

This is super confusing, I was 100% expecting this to be a wrapper of
gpa_protected_mask.  I think that largely goes away when the field is named
gpa_tag_mask, but I would still prefer to name this

	vm_is_memory_protected()

so that it's clear that the helper cares about the physical memory itself, not
the GPA that's used to reference the memory.  They're related, but two different
thing.

> +{
> +	sparsebit_idx_t pg = 0;
> +	struct userspace_mem_region *region;
> +
> +	if (!vm->protected)
> +		return false;
> +
> +	region = userspace_mem_region_find(vm, paddr, paddr);
> +	if (!region) {
> +		TEST_FAIL("No vm physical memory at 0x%lx", paddr);
> +		return false;
> +	}
> +
> +	pg = paddr >> vm->page_shift;
> +	return sparsebit_is_set(region->protected_phy_pages, pg);
> +}
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index acfa1d01e7df..d03cefd9f6cd 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -127,6 +127,7 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
>  	/* If needed, create page map l4 table. */
>  	if (!vm->pgd_created) {
>  		vm->pgd = vm_alloc_page_table(vm);
> +

Spurious change.

>  		vm->pgd_created = true;
>  	}
>  }
> @@ -153,13 +154,16 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
>  				       int target_level)
>  {
>  	uint64_t *pte = virt_get_pte(vm, parent_pte, vaddr, current_level);
> +	uint64_t paddr_raw = vm_untag_gpa(vm, paddr);

No need for another variable

	paddr = vm_untag_gpa(vm, paddr);
>  
>  	if (!(*pte & PTE_PRESENT_MASK)) {
>  		*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK;
>  		if (current_level == target_level)
> -			*pte |= PTE_LARGE_MASK | (paddr & PHYSICAL_PAGE_MASK);
> -		else
> +			*pte |= PTE_LARGE_MASK | (paddr_raw & PHYSICAL_PAGE_MASK);
> +		else {

Spurious braces

>  			*pte |= vm_alloc_page_table(vm) & PHYSICAL_PAGE_MASK;
> +		}
> +
>  	} else {
>  		/*
>  		 * Entry already present.  Assert that the caller doesn't want
> @@ -197,6 +201,8 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
>  		    "Physical address beyond maximum supported,\n"
>  		    "  paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
>  		    paddr, vm->max_gfn, vm->page_size);
> +	TEST_ASSERT(vm_untag_gpa(vm, paddr) == paddr,
> +		    "Unexpected bits in paddr: %lx", paddr);
>  
>  	/*
>  	 * Allocate upper level page tables, if not already present.  Return
> @@ -219,6 +225,11 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
>  	TEST_ASSERT(!(*pte & PTE_PRESENT_MASK),
>  		    "PTE already present for 4k page at vaddr: 0x%lx\n", vaddr);
>  	*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK | (paddr & PHYSICAL_PAGE_MASK);
> +

Add a comment here, the vast majority of folks reading this don't know the
subtleties of TDX and SEV

> +	if (vm_is_gpa_protected(vm, paddr))
> +		*pte |= vm->arch.c_bit;
> +	else
> +		*pte |= vm->arch.s_bit;
>  }
>  
>  void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
> @@ -493,7 +504,7 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
>  	 * No need for a hugepage mask on the PTE, x86-64 requires the "unused"
>  	 * address bits to be zero.
>  	 */
> -	return PTE_GET_PA(*pte) | (gva & ~HUGEPAGE_MASK(level));
> +	return vm_untag_gpa(vm, PTE_GET_PA(*pte)) | (gva & ~HUGEPAGE_MASK(level));
>  }
>  
>  static void kvm_setup_gdt(struct kvm_vm *vm, struct kvm_dtable *dt)
> -- 
> 2.39.0.314.g84b9a713c41-goog
> 
