Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 363FA6A6AC1
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 11:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjCAKZo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 05:25:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjCAKZh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 05:25:37 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540063B21D;
        Wed,  1 Mar 2023 02:25:35 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id r27so16944058lfe.10;
        Wed, 01 Mar 2023 02:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677666333;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JZu0Ks1uYe7IRz+Gi1Lxco47D+ViK2VorG1zsDjPkks=;
        b=WEnSZTunykIiIBgJEVCz0BhZ2TNgPkFmsQt0d8KElWevOE783/UOqHK+3ZM89BkuRu
         FRl5actMlgaIiVFNf7sTSCbeJESVYAOJtjd9aS7le5Am+HyMUibEidoFl05BDdEEbJr2
         RqhBzm+B7e2UkGTKJaMGleR8BDoIoMnA6y0gDxB7IoWJB+4+ADlppzmEB2ks7A68CM7N
         n8u/pRDvUwPgoCPhcEEXAzWmx0Lv+NDTeCux51efdZYQhmfPe3lAkJ2/Qo3HeuJzwUma
         6QdVn+82G4uwwLHyVvG0UFaZVZMjCSXomM4DBFa59vUQsgQPGC4XeBXVnS5t8Zxi9dO9
         xnDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677666333;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JZu0Ks1uYe7IRz+Gi1Lxco47D+ViK2VorG1zsDjPkks=;
        b=saIZL9YbR8rUc6sa+mpW0/HMhjvpT3AWZBBp5RbJbHwEq4un1N0DvsQ6qXl+I1JUZn
         2fVSXGH8oYNlZ4qMj4q4Hm85a1RKitJwvxqa5atIBFYnKVQVOeJ6a2L/QvFBEAWioFoj
         KREFGT5Ma+XI91bUzuYzKecBg8Jv0Ye4Tf7T++QwmbSyu0g3q9r2LrynN+ZC6+i4XwI0
         uOowBat8c/yNn8edZtpL/JKlmMlGRxAby2S2sXlBc17lC8GmIqoELJav9zyRbh71UQwe
         e1kxowck7gJi8xRrqealU2zckM+vW1SuTogfrqLo5tsQZbqk2FJBATDK2Q/2s0e5AW5p
         VTqw==
X-Gm-Message-State: AO0yUKWDAHcUa+iWxF9bkqisO64mMoXino1V8XuG4FTx0rH1utpc7FeC
        A02bpyOQdehLXhWyYpeAs8Q=
X-Google-Smtp-Source: AK7set+bABlwqK9McXLfJZ3vCHfIEcU9y6Jo3dU/O68iZ6+n+40Xw+nNndbqA6MJL9cW5AwBuvpUDA==
X-Received: by 2002:ac2:4c21:0:b0:4b5:a7c7:9dc4 with SMTP id u1-20020ac24c21000000b004b5a7c79dc4mr1272513lfq.3.1677666333460;
        Wed, 01 Mar 2023 02:25:33 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id y6-20020ac255a6000000b004db3eff4b12sm1684552lfg.171.2023.03.01.02.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 02:25:33 -0800 (PST)
From:   Zhi Wang <zhi.wang.linux@gmail.com>
X-Google-Original-From: Zhi Wang <zhi.wang.linux@intel.com>
Date:   Wed, 1 Mar 2023 12:25:31 +0200
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
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>
Subject: Re: [PATCH RFC v8 01/56] KVM: x86: Add 'fault_is_private' x86 op
Message-ID: <20230301122531.00002657@intel.com>
In-Reply-To: <20230220183847.59159-2-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
        <20230220183847.59159-2-michael.roth@amd.com>
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

On Mon, 20 Feb 2023 12:37:52 -0600
Michael Roth <michael.roth@amd.com> wrote:

Basically, I don't think kvm_mmu_fault_is_private() is promising after going
through both SNP and TDX patches:

1) Fault path is critical. kvm_mmu_fault_is_private() is always doing a gfn_to
_memslot() no matter SNP/TDX is enabled or not. It might mostly hits the
slots->last_used_slot, but the worst case is going through an RB-tree search.

Adding extra overhead on the generic fault path needs to be re-considered
carefully. At least, check if the guest is a CC(SNP/TDX) guest.

2) Just after the gfn_to_memslot() in kvm_mmu_fault_is_private(), there is
another gfn_to_memslot():

static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
                                        u64 err, bool prefetch)
{
        struct kvm_page_fault fault = {
                .addr = cr2_or_gpa,
                .error_code = lower_32_bits(err),
                .exec = err & PFERR_FETCH_MASK,
                .write = err & PFERR_WRITE_MASK,
                .present = err & PFERR_PRESENT_MASK,
                .rsvd = err & PFERR_RSVD_MASK,
                .user = err & PFERR_USER_MASK,
                .prefetch = prefetch,
                .is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault),
                .nx_huge_page_workaround_enabled =
                        is_nx_huge_page_enabled(vcpu->kvm),

                .max_level = KVM_MAX_HUGEPAGE_LEVEL,
                .req_level = PG_LEVEL_4K,
                .goal_level = PG_LEVEL_4K,
                .is_private = kvm_mmu_fault_is_private(vcpu->kvm, cr2_or_gpa, err),
        };
        int r;

        if (vcpu->arch.mmu->root_role.direct) {
                fault.gfn = fault.addr >> PAGE_SHIFT;
		/* here */
                fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
        }

I was thinking if checking the private slot and kvm_slot_can_be_private() is
necessary in kvm_mmu_fault_is_private().

TDP MMU is expecting fault.is_private to indicate if CPU thinks the fault
is private or not (For SNP, it is in PF error code, for TDX it is the shared
bit in the fault GPA). TDP MMU will check if the slot is a private slot or
not, leave the userspace to handle it when they thinks differently.

My points:

1) Resolving the PFER in kvm_x86_ops.fault_is_private and setting
fault.is_private is enough. The rest can be handled by the TDP MMU.

2) Put the kvm_x86_ops.fault_is_private in a separate patch so that TDX series
can include it. (64bit-error code part can stay in another patch)

> This callback is used by the KVM MMU to check whether a #NPF was for a
> private GPA or not.
> 
> In some cases the full 64-bit error code for the #NPF will be needed to
> make this determination, so also update kvm_mmu_do_page_fault() to
> accept the full 64-bit value so it can be plumbed through to the
> callback.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  1 +
>  arch/x86/kvm/mmu/mmu.c             |  3 +--
>  arch/x86/kvm/mmu/mmu_internal.h    | 37 +++++++++++++++++++++++++++---
>  4 files changed, 37 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 8dc345cc6318..72183da010b8 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -131,6 +131,7 @@ KVM_X86_OP(msr_filter_changed)
>  KVM_X86_OP(complete_emulated_msr)
>  KVM_X86_OP(vcpu_deliver_sipi_vector)
>  KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
> +KVM_X86_OP_OPTIONAL_RET0(fault_is_private);
>  
>  #undef KVM_X86_OP
>  #undef KVM_X86_OP_OPTIONAL
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e552374f2357..f856d689dda0 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1643,6 +1643,7 @@ struct kvm_x86_ops {
>  
>  	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>  			     int root_level);
> +	bool (*fault_is_private)(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *private_fault);
>  
>  	bool (*has_wbinvd_exit)(void);
>  
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index eda615f3951c..fb3f34b7391c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5724,8 +5724,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
>  	}
>  
>  	if (r == RET_PF_INVALID) {
> -		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
> -					  lower_32_bits(error_code), false);
> +		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, error_code, false);
>  		if (KVM_BUG_ON(r == RET_PF_INVALID, vcpu->kvm))
>  			return -EIO;
>  	}
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index e642d431df4b..557a001210df 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -231,6 +231,37 @@ struct kvm_page_fault {
>  
>  int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
>  
> +static bool kvm_mmu_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 err)
> +{
> +	struct kvm_memory_slot *slot;
> +	bool private_fault = false;
> +	gfn_t gfn = gpa_to_gfn(gpa);
> +
> +	slot = gfn_to_memslot(kvm, gfn);
> +	if (!slot) {
> +		pr_debug("%s: no slot, GFN: 0x%llx\n", __func__, gfn);
> +		goto out;
> +	}
> +
> +	if (!kvm_slot_can_be_private(slot)) {
> +		pr_debug("%s: slot is not private, GFN: 0x%llx\n", __func__, gfn);
> +		goto out;
> +	}
> +
> +	if (static_call(kvm_x86_fault_is_private)(kvm, gpa, err, &private_fault))
> +		goto out;
> +
> +	/*
> +	 * Handling below is for UPM self-tests and guests that treat userspace
> +	 * as the authority on whether a fault should be private or not.
> +	 */
> +	private_fault = kvm_mem_is_private(kvm, gpa >> PAGE_SHIFT);
> +
> +out:
> +	pr_debug("%s: GFN: 0x%llx, private: %d\n", __func__, gfn, private_fault);
> +	return private_fault;
> +}
> +
>  /*
>   * Return values of handle_mmio_page_fault(), mmu.page_fault(), fast_page_fault(),
>   * and of course kvm_mmu_do_page_fault().
> @@ -262,11 +293,11 @@ enum {
>  };
>  
>  static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> -					u32 err, bool prefetch)
> +					u64 err, bool prefetch)
>  {
>  	struct kvm_page_fault fault = {
>  		.addr = cr2_or_gpa,
> -		.error_code = err,
> +		.error_code = lower_32_bits(err),
>  		.exec = err & PFERR_FETCH_MASK,
>  		.write = err & PFERR_WRITE_MASK,
>  		.present = err & PFERR_PRESENT_MASK,
> @@ -280,7 +311,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
>  		.req_level = PG_LEVEL_4K,
>  		.goal_level = PG_LEVEL_4K,
> -		.is_private = kvm_mem_is_private(vcpu->kvm, cr2_or_gpa >> PAGE_SHIFT),
> +		.is_private = kvm_mmu_fault_is_private(vcpu->kvm, cr2_or_gpa, err),
>  	};
>  	int r;
>  

