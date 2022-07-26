Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7B87581C79
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 01:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240014AbiGZXlQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 19:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239904AbiGZXlO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 19:41:14 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0721262F;
        Tue, 26 Jul 2022 16:41:12 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id jw17so2418948pjb.0;
        Tue, 26 Jul 2022 16:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PrCjjOFOhMf6B7WrLBgvK9Jo76b6OWWmpIz9dDeyPYI=;
        b=RoRx4uaHZ9Sl5cWrYWUdnVTYuRdiYfHn/62vISpKjuaJ4BPQ6lQbYO0223GTJcukhU
         BQhiV9JxInPIswIrKmSwowovHK8zE9gppLVVlehlyWPLtRMczovuUh2zg/QwkPbud5X8
         qi3JM3M3PtfVLyOng32VIk1xSLzc1o0oRbvr7XSqbKTYlao3d7YDH3wm92lpQI4aBge8
         8JzilSfeyNcTwfsKiypTl12BgJi3rPKxztIOWRKymujVA0yfYkFrTa82K1ZCMomTv8Jq
         RY/of9eKZRGilyanIlOvZeMDni3EccUKOKTyRwZw6gzoOl0gOAIiZ8mtPw73wgXFRltP
         ZNIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PrCjjOFOhMf6B7WrLBgvK9Jo76b6OWWmpIz9dDeyPYI=;
        b=YU8u01fGS7/y6COQMTGSHAOUuoof4eJFqr6yqp7gGKeFgi/rrcSLEp2RwuAP77WsBK
         pajprJYerdTPuA2Zi5ZSKtcoyDbtupmGXV99Y2KB3xq0pCjKTFXxuoTOhRZXJjRxkEvp
         jk8V5MUBsSYhCCtnLk6a0LP6LQV8lB+vfXxdKNdksTK+6W4OgUv3xFaBCi0+sLJV40Uv
         X01zDb2TdtpTH2/94UM6QhkJwdiZTSG9WyXNKrxLNI0CUVJUx2rQZrDx0xJ13eQZe+sv
         eaP0Sg8i0w447AeIwxi5/6MCQvT5TRzkW7IOKYuCHLGERFrxxzI/f+jGSluUrrZaDGvz
         nIOQ==
X-Gm-Message-State: AJIora9qy9Ltz3tFWCU38+QLfB61jaJ5N1NS3ta49TBsiR0j1XqZHz96
        Mdw0LzXoc0JmSlQluQkWcAk=
X-Google-Smtp-Source: AGRyM1tw4qn/AMwPrcEBvPTXq/nrt47sQDR1vq02Zhnb0jf8tDbrpMUoKeT//tX5ol+zHvQWin/eCw==
X-Received: by 2002:a17:90a:b391:b0:1f3:6c3:392c with SMTP id e17-20020a17090ab39100b001f306c3392cmr1131974pjr.166.1658878872033;
        Tue, 26 Jul 2022 16:41:12 -0700 (PDT)
Received: from localhost ([192.55.54.49])
        by smtp.gmail.com with ESMTPSA id m7-20020a62a207000000b0052b36de51cdsm12197953pff.111.2022.07.26.16.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 16:41:11 -0700 (PDT)
Date:   Tue, 26 Jul 2022 16:41:10 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v7 046/102] KVM: x86/tdp_mmu: Support TDX private mapping
 for TDP MMU
Message-ID: <20220726234110.GD1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <94524fe1d3ead13019a2b502f37797727296fbd1.1656366338.git.isaku.yamahata@intel.com>
 <20220711082818.ksm5hxg3zho66oct@yy-desk-7060>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220711082818.ksm5hxg3zho66oct@yy-desk-7060>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 11, 2022 at 04:28:18PM +0800,
Yuan Yao <yuan.yao@linux.intel.com> wrote:

> On Mon, Jun 27, 2022 at 02:53:38PM -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> > Allocate mirrored private page table for private page table, and add hooks
> > to operate on mirrored private page table.  This patch adds only hooks. As
> > kvm_gfn_shared_mask() returns false always, those hooks aren't called yet.
> >
> > Because private guest page is protected, page copy with mmu_notifier to
> > migrate page doesn't work.  Callback from backing store is needed.
> >
> > When the faulting GPA is private, the KVM fault is also called private.
> > When resolving private KVM, allocate mirrored private page table and call
> > hooks to operate on mirrored private page table. On the change of the
> > private PTE entry, invoke kvm_x86_ops hook in __handle_changed_spte() to
> > propagate the change to mirrored private page table. The following depicts
> > the relationship.
> >
> >   private KVM page fault   |
> >       |                    |
> >       V                    |
> >  private GPA               |
> >       |                    |
> >       V                    |
> >  KVM private PT root       |  CPU private PT root
> >       |                    |           |
> >       V                    |           V
> >    private PT ---hook to mirror--->mirrored private PT
> >       |                    |           |
> >       \--------------------+------\    |
> >                            |      |    |
> >                            |      V    V
> >                            |    private guest page
> >                            |
> >                            |
> >      non-encrypted memory  |    encrypted memory
> >                            |
> > PT: page table
> >
> > The existing KVM TDP MMU code uses atomic update of SPTE.  On populating
> > the EPT entry, atomically set the entry.  However, it requires TLB
> > shootdown to zap SPTE.  To address it, the entry is frozen with the special
> > SPTE value that clears the present bit. After the TLB shootdown, the entry
> > is set to the eventual value (unfreeze).
> >
> > For mirrored private page table, hooks are called to update mirrored
> > private page table in addition to direct access to the private SPTE. For
> > the zapping case, it works to freeze the SPTE. It can call hooks in
> > addition to TLB shootdown.  For populating the private SPTE entry, there
> > can be a race condition without further protection
> >
> >   vcpu 1: populating 2M private SPTE
> >   vcpu 2: populating 4K private SPTE
> >   vcpu 2: TDX SEAMCALL to update 4K mirrored private SPTE => error
> >   vcpu 1: TDX SEAMCALL to update 2M mirrored private SPTE
> >
> > To avoid the race, the frozen SPTE is utilized.  Instead of atomic update
> > of the private entry, freeze the entry, call the hook that update mirrored
> > private SPTE, set the entry to the final value.
> >
> > Support 4K page only at this stage.  2M page support can be done in future
> > patches.
> >
> > Add is_private member to kvm_page_fault to indicate the fault is private.
> > Also is_private member to struct tdp_inter to propagate it.
> >
> > Co-developed-by: Kai Huang <kai.huang@intel.com>
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/include/asm/kvm-x86-ops.h |   2 +
> >  arch/x86/include/asm/kvm_host.h    |  20 +++
> >  arch/x86/kvm/mmu/mmu.c             |  86 +++++++++-
> >  arch/x86/kvm/mmu/mmu_internal.h    |  37 +++++
> >  arch/x86/kvm/mmu/paging_tmpl.h     |   2 +-
> >  arch/x86/kvm/mmu/tdp_iter.c        |   1 +
> >  arch/x86/kvm/mmu/tdp_iter.h        |   5 +-
> >  arch/x86/kvm/mmu/tdp_mmu.c         | 247 +++++++++++++++++++++++------
> >  arch/x86/kvm/mmu/tdp_mmu.h         |   7 +-
> >  virt/kvm/kvm_main.c                |   1 +
> >  10 files changed, 346 insertions(+), 62 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > index 32a6df784ea6..6982d57e4518 100644
> > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > @@ -93,6 +93,8 @@ KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
> >  KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
> >  KVM_X86_OP(get_mt_mask)
> >  KVM_X86_OP(load_mmu_pgd)
> > +KVM_X86_OP_OPTIONAL(free_private_sp)
> > +KVM_X86_OP_OPTIONAL(handle_changed_private_spte)
> >  KVM_X86_OP(has_wbinvd_exit)
> >  KVM_X86_OP(get_l2_tsc_offset)
> >  KVM_X86_OP(get_l2_tsc_multiplier)
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index bfc934dc9a33..f2a4d5a18851 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -440,6 +440,7 @@ struct kvm_mmu {
> >  			 struct kvm_mmu_page *sp);
> >  	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa);
> >  	struct kvm_mmu_root_info root;
> > +	hpa_t private_root_hpa;
> >  	union kvm_cpu_role cpu_role;
> >  	union kvm_mmu_page_role root_role;
> >
> > @@ -1435,6 +1436,20 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
> >  	return dest_mode_logical ? APIC_DEST_LOGICAL : APIC_DEST_PHYSICAL;
> >  }
> >
> > +struct kvm_spte {
> > +	kvm_pfn_t pfn;
> > +	bool is_present;
> > +	bool is_leaf;
> > +};
> > +
> > +struct kvm_spte_change {
> > +	gfn_t gfn;
> > +	enum pg_level level;
> > +	struct kvm_spte old;
> > +	struct kvm_spte new;
> > +	void *sept_page;
> > +};
> > +
> >  struct kvm_x86_ops {
> >  	const char *name;
> >
> > @@ -1547,6 +1562,11 @@ struct kvm_x86_ops {
> >  	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
> >  			     int root_level);
> >
> > +	int (*free_private_sp)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> > +			       void *private_sp);
> > +	void (*handle_changed_private_spte)(
> > +		struct kvm *kvm, const struct kvm_spte_change *change);
> > +
> >  	bool (*has_wbinvd_exit)(void);
> >
> >  	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index a5bf3e40e209..ef925722ee28 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1577,7 +1577,11 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
> >  		flush = kvm_handle_gfn_range(kvm, range, kvm_unmap_rmapp);
> >
> >  	if (is_tdp_mmu_enabled(kvm))
> > -		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
> > +		/*
> > +		 * private page needs to be kept and handle page migration
> > +		 * on next EPT violation.
> > +		 */
> > +		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush, false);
> >
> >  	return flush;
> >  }
> > @@ -3082,7 +3086,8 @@ static int handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fau
> >  		 * SPTE value without #VE suppress bit cleared
> >  		 * (kvm->arch.shadow_mmio_value = 0).
> >  		 */
> > -		if (unlikely(!vcpu->kvm->arch.enable_mmio_caching) ||
> > +		if (unlikely(!vcpu->kvm->arch.enable_mmio_caching &&
> > +			     !kvm_gfn_shared_mask(vcpu->kvm)) ||
> >  		    unlikely(fault->gfn > kvm_mmu_max_gfn()))
> >  			return RET_PF_EMULATE;
> >  	}
> > @@ -3454,7 +3459,12 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
> >  		goto out_unlock;
> >
> >  	if (is_tdp_mmu_enabled(vcpu->kvm)) {
> > -		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
> > +		if (kvm_gfn_shared_mask(vcpu->kvm) &&
> > +		    !VALID_PAGE(mmu->private_root_hpa)) {
> > +			root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu, true);
> > +			mmu->private_root_hpa = root;
> > +		}
> > +		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu, false);
> >  		mmu->root.hpa = root;
> >  	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
> >  		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level, true);
> > @@ -4026,6 +4036,32 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
> >  	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
> >  }
> >
> > +/*
> > + * Private page can't be release on mmu_notifier without losing page contents.
> > + * The help, callback, from backing store is needed to allow page migration.
> > + * For now, pin the page.
> > + */
> > +static int kvm_faultin_pfn_private_mapped(struct kvm_vcpu *vcpu,
> > +					   struct kvm_page_fault *fault)
> > +{
> > +	hva_t hva = gfn_to_hva_memslot(fault->slot, fault->gfn);
> > +	struct page *page[1];
> > +
> > +	fault->map_writable = false;
> > +	fault->pfn = KVM_PFN_ERR_FAULT;
> > +	if (hva == KVM_HVA_ERR_RO_BAD || hva == KVM_HVA_ERR_BAD)
> > +		return RET_PF_CONTINUE;
> > +
> > +	/* TDX allows only RWX.  Read-only isn't supported. */
> > +	WARN_ON_ONCE(!fault->write);
> > +	if (pin_user_pages_fast(hva, 1, FOLL_WRITE, page) != 1)
> > +		return RET_PF_INVALID;
> > +
> > +	fault->map_writable = true;
> > +	fault->pfn = page_to_pfn(page[0]);
> > +	return RET_PF_CONTINUE;
> > +}
> > +
> >  static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >  {
> >  	struct kvm_memory_slot *slot = fault->slot;
> > @@ -4058,6 +4094,9 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >  			return RET_PF_EMULATE;
> >  	}
> >
> > +	if (fault->is_private)
> > +		return kvm_faultin_pfn_private_mapped(vcpu, fault);
> > +
> >  	async = false;
> >  	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, &async,
> >  					  fault->write, &fault->map_writable,
> > @@ -4110,6 +4149,17 @@ static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
> >  	       mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, fault->hva);
> >  }
> >
> > +void kvm_mmu_release_fault(struct kvm *kvm, struct kvm_page_fault *fault, int r)
> > +{
> > +	if (is_error_noslot_pfn(fault->pfn) || kvm_is_reserved_pfn(fault->pfn))
> > +		return;
> > +
> > +	if (fault->is_private)
> > +		put_page(pfn_to_page(fault->pfn));
> 
> The pin_user_pages_fast() is used above which has FOLL_PIN set
> internal, so should we use unpin_user_page() here ? The FOLL_PIN means
> the unpin should be done by unpin_user_page() but not put_page, please
> see /Documentation/core-api/pin_user_pages.rst and comments on
> FOLL_PIN;

To align with large page support, I'll make it to use get_user_pages_fast() and
put_page().

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
