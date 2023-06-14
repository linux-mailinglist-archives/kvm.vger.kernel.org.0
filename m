Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9F473055A
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 18:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235920AbjFNQrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 12:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjFNQrN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 12:47:13 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41674EC;
        Wed, 14 Jun 2023 09:47:12 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1b3af7e3925so30597105ad.3;
        Wed, 14 Jun 2023 09:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686761231; x=1689353231;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=12MPORJYTdRaxuQWvnPe0uInIKYb4u8od8aH9jpQ52k=;
        b=DC2zDgn1z/Yjl45gfG0Phjz8VODs0yrmxTMp6+IqxDmlZlJ7Jz/IED2WIsKnV84zwj
         gn8rdevPHAD0ubADyIhBK93xK5txCIKo7RQSMA75eKXnMoUkw4qA6RIo/7tLRNLZ2XPy
         UY8MhtOrlBwjafEclLoSKWDprDg4piYJAkN9MXfCvktb0r226MJ96HC32f10n29f7WZn
         mJzFfShZQGW2Ag8Wi9EwfPoR542mz2CCr5EFYz9kKLHTHb7NZ2vKr8z03CdgIkfRrgQk
         p0YEL5BPaGWqUDU6jjtp/WwXUJyZauS95FH2F2BtTlEeRP9UpJXrJwRCkt8C/GknA+Wf
         I8Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686761231; x=1689353231;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=12MPORJYTdRaxuQWvnPe0uInIKYb4u8od8aH9jpQ52k=;
        b=dAuzeAk1v3pSsHdTgWZQYIZzytzJj8bjno/qCavtkjgyf6AHP8DdxSE2xu6CH51x92
         p5HEtmAUB0i+8eiDPCabu+SAzUp5mARrwpmGuvbHc6AoR3fiIhjyo+uV4mBkTPbf6v7i
         vLX5bbRG/6EQCB1kTZBYoGoURLnJvV89Sdt58ZZbjTYv2TbOCznCTlpOxopKwOhm7o+E
         jF5XfR+uplCFkekdnmXEZr0mts6kWrHfOgqxlAoubzzocqTivu7MleB0LfZq8Ml+HVig
         SR0wdycq9rCD6rjkuj/WdGYsAad/SQgI2BuP65yplk/pt9qrZo7pXGCKtuCkIcSgUNFk
         7E5A==
X-Gm-Message-State: AC+VfDy18sY6KUARG/FJVv4W6+nUSpPc7j5BiqxP1XijIFwdR698cvdL
        zzUWcV4LjpwB582jsUCedh0=
X-Google-Smtp-Source: ACHHUZ6t8N6IBSWvdJvyRkmm0c03psAWogPX0vP/Ol0n4nnWls6/IXHJjRosLSS7EI/95vJQ1fS+Ng==
X-Received: by 2002:a17:902:8c84:b0:1b1:a2c3:29c0 with SMTP id t4-20020a1709028c8400b001b1a2c329c0mr11199347plo.24.1686761231544;
        Wed, 14 Jun 2023 09:47:11 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id y10-20020a17090322ca00b001ae6b4b28adsm7016713plg.130.2023.06.14.09.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 09:47:10 -0700 (PDT)
Date:   Wed, 14 Jun 2023 09:47:09 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com, isaku.yamahata@gmail.com
Subject: Re: [PATCH RFC v9 04/51] KVM: x86: Determine shared/private faults
 using a configurable mask
Message-ID: <20230614164709.GT2244082@ls.amr.corp.intel.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-5-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230612042559.375660-5-michael.roth@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 11, 2023 at 11:25:12PM -0500,
Michael Roth <michael.roth@amd.com> wrote:

> This will be used to determine whether or not an #NPF should be serviced
> using a normal page vs. a guarded/gmem one.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  7 +++++++
>  arch/x86/kvm/mmu/mmu_internal.h | 35 ++++++++++++++++++++++++++++++++-
>  2 files changed, 41 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index b3bd24f2a390..c26f76641121 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1445,6 +1445,13 @@ struct kvm_arch {
>  	 */
>  #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
>  	struct kvm_mmu_memory_cache split_desc_cache;
> +
> +	/*
> +	 * When set, used to determine whether a fault should be treated as
> +	 * private in the context of protected VMs which use a separate gmem
> +	 * pool to back private guest pages.
> +	 */
> +	u64 mmu_private_fault_mask;
>  };
>  
>  struct kvm_vm_stat {
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 780b91e1da9f..9b9e75aa43f4 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -252,6 +252,39 @@ struct kvm_page_fault {
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
> +	if (kvm->arch.mmu_private_fault_mask) {
> +		private_fault = !!(err & kvm->arch.mmu_private_fault_mask);
> +		goto out;
> +	}

What's the convention of err? Can we abstract it by introducing a new bit
PFERR_PRIVATE_MASK? The caller sets it based on arch specific value.
the logic will be
        .is_private = err & PFERR_PRIVATE_MASK;


> +
> +	/*
> +	 * Handling below is for UPM self-tests and guests that treat userspace
> +	 * as the authority on whether a fault should be private or not.
> +	 */
> +	private_fault = kvm_mem_is_private(kvm, gpa >> PAGE_SHIFT);

This code path is sad. One extra slot lookup and xarray look up.
Without mmu lock, the result can change by other vcpu.
Let's find a better way.

> +
> +out:
> +	pr_debug("%s: GFN: 0x%llx, private: %d\n", __func__, gfn, private_fault);
> +	return private_fault;
> +}
> +
>  /*
>   * Return values of handle_mmio_page_fault(), mmu.page_fault(), fast_page_fault(),
>   * and of course kvm_mmu_do_page_fault().
> @@ -301,7 +334,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
>  		.req_level = PG_LEVEL_4K,
>  		.goal_level = PG_LEVEL_4K,
> -		.is_private = kvm_mem_is_private(vcpu->kvm, cr2_or_gpa >> PAGE_SHIFT),
> +		.is_private = kvm_mmu_fault_is_private(vcpu->kvm, cr2_or_gpa, err),
>  	};
>  	int r;
>  
> -- 
> 2.25.1
> 

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
