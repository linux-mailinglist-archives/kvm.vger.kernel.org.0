Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB352591D62
	for <lists+kvm@lfdr.de>; Sun, 14 Aug 2022 02:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240174AbiHNAx7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Aug 2022 20:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240165AbiHNAx5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Aug 2022 20:53:57 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B398274A
        for <kvm@vger.kernel.org>; Sat, 13 Aug 2022 17:53:56 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id a8so4125965pjg.5
        for <kvm@vger.kernel.org>; Sat, 13 Aug 2022 17:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=ONwAWRSRQEhkoR/G1uBxh3XvYtM+k2FBu6A5S5bd0Jg=;
        b=WIP1Nfmf3ZWKGeE2qQ1SylzXbCpdNXLsZjCXYtPCxDwcenRPMGPRBZkq+UDEX55Kee
         u/XbOjaCgLS3hNVeDeL5Mn88+ylZ5z+1jbs6xF+QfysESIhvTCor/P2AjDUq3D+Z1AIa
         BrX+Qhy7PUkBL4Y/FJqRdGakPu0C7SDSXdexh64viy+SW6zLl/oF0sUkZA0soCUQnyGj
         riRY1eRs4JdIU1tZbchOlEH7VXddB3XVzBj4F655DtgWw8C6gAhACM5+4a/M9zY/dt8v
         3ZLg3JS1zjmWFojMmlB7uCQFq48rV0aEwAekVtd45fl2d7heGUDhkosSJTjfgMa9o9SN
         V79w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=ONwAWRSRQEhkoR/G1uBxh3XvYtM+k2FBu6A5S5bd0Jg=;
        b=ZzojV/5ibGmqmswhG7Ie6alg9J2/dQixfaiJ2qhpDn5zX1xghSEzZwByRkI62EaIxv
         mQ1SgIGnTHcoVl56a3NhLLCLZ6dK2/IC+IkdgznTsYLVuhuI+BsldKwbMSyJ6Ay4yUUv
         PemrR3BZ08W/HKGcuiU+bKglV6uEyLut94nyu5P7Pu15Jjt2RAgOkGg3hLKWha8Uc2y6
         okUR/IwYMJtQRm9wJWWnq1egiD+pf4Q7rnFx1/Vlk7rBzAiPLxHotgU1m+AOF4h5I5M+
         EH9wR6IYyxbrp65WhL8lH+cdmloYJJce/lZCvqqhcNot+RHfpzQB1Q5tOde7I71CdzsK
         671Q==
X-Gm-Message-State: ACgBeo031WzBbOCNr/Ls9UOJ+Fua5zZlX4Fm1cA6IxDy9NUmLiXOmgPK
        AtnFQgRavPmTxD5AVOHwHRs9lA==
X-Google-Smtp-Source: AA6agR5YB+hFuKCMKuaCy79NdPMoyf2dFWz9fkTJPXXJcDz1jSWe3MGyRJ3YEpquEPxTA/Jw/PnGnA==
X-Received: by 2002:a17:90a:fae:b0:1f7:6ecf:5f45 with SMTP id 43-20020a17090a0fae00b001f76ecf5f45mr11379372pjz.234.1660438435689;
        Sat, 13 Aug 2022 17:53:55 -0700 (PDT)
Received: from google.com (33.5.83.34.bc.googleusercontent.com. [34.83.5.33])
        by smtp.gmail.com with ESMTPSA id q3-20020a170902a3c300b0016f975be2e7sm4279352plb.139.2022.08.13.17.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Aug 2022 17:53:55 -0700 (PDT)
Date:   Sun, 14 Aug 2022 00:53:51 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v3 2/8] KVM: x86/mmu: Tag disallowed NX huge pages even
 if they're not tracked
Message-ID: <YvhHn50lQmRRST8N@google.com>
References: <20220805230513.148869-1-seanjc@google.com>
 <20220805230513.148869-3-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805230513.148869-3-seanjc@google.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 05, 2022, Sean Christopherson wrote:
> Tag shadow pages that cannot be replaced with an NX huge page regardless
> of whether or not zapping the page would allow KVM to immediately create
> a huge page, e.g. because something else prevents creating a huge page.
> 
> I.e. track pages that are disallowed from being NX huge pages regardless
> of whether or not the page could have been huge at the time of fault.
> KVM currently tracks pages that were disallowed from being huge due to
> the NX workaround if and only if the page could otherwise be huge.  But
> that fails to handled the scenario where whatever restriction prevented
> KVM from installing a huge page goes away, e.g. if dirty logging is
> disabled, the host mapping level changes, etc...
> 
> Failure to tag shadow pages appropriately could theoretically lead to
> false negatives, e.g. if a fetch fault requests a small page and thus
> isn't tracked, and a read/write fault later requests a huge page, KVM
> will not reject the huge page as it should.
> 
> To avoid yet another flag, initialize the list_head and use list_empty()
> to determine whether or not a page is on the list of NX huge pages that
> should be recovered.
> 
> Note, the TDP MMU accounting is still flawed as fixing the TDP MMU is
> more involved due to mmu_lock being held for read.  This will be
> addressed in a future commit.
> 
> Fixes: 5bcaf3e1715f ("KVM: x86/mmu: Account NX huge page disallowed iff huge page was requested")
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c          | 27 +++++++++++++++++++--------
>  arch/x86/kvm/mmu/mmu_internal.h | 10 +++++++++-
>  arch/x86/kvm/mmu/paging_tmpl.h  |  6 +++---
>  arch/x86/kvm/mmu/tdp_mmu.c      |  4 +++-
>  4 files changed, 34 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 36b898dbde91..55dac44f3397 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -802,15 +802,20 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
>  		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
>  }
>  
> -void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> +void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp,
> +			  bool nx_huge_page_possible)
>  {
> -	if (KVM_BUG_ON(sp->lpage_disallowed, kvm))
> +	if (KVM_BUG_ON(!list_empty(&sp->lpage_disallowed_link), kvm))
> +		return;
> +
> +	sp->lpage_disallowed = true;
> +
> +	if (!nx_huge_page_possible)
>  		return;
>  
>  	++kvm->stat.nx_lpage_splits;
>  	list_add_tail(&sp->lpage_disallowed_link,
>  		      &kvm->arch.lpage_disallowed_mmu_pages);
> -	sp->lpage_disallowed = true;
>  }
>  
>  static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
> @@ -832,9 +837,13 @@ static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
>  
>  void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
> -	--kvm->stat.nx_lpage_splits;
>  	sp->lpage_disallowed = false;
> -	list_del(&sp->lpage_disallowed_link);
> +
> +	if (list_empty(&sp->lpage_disallowed_link))
> +		return;
> +
> +	--kvm->stat.nx_lpage_splits;
> +	list_del_init(&sp->lpage_disallowed_link);
>  }
>  
>  static struct kvm_memory_slot *
> @@ -2115,6 +2124,8 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
>  
>  	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
>  
> +	INIT_LIST_HEAD(&sp->lpage_disallowed_link);
> +
>  	/*
>  	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
>  	 * depends on valid pages being added to the head of the list.  See
> @@ -3112,9 +3123,9 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  			continue;
>  
>  		link_shadow_page(vcpu, it.sptep, sp);
> -		if (fault->is_tdp && fault->huge_page_disallowed &&
> -		    fault->req_level >= it.level)
> -			account_huge_nx_page(vcpu->kvm, sp);
> +		if (fault->is_tdp && fault->huge_page_disallowed)
> +			account_huge_nx_page(vcpu->kvm, sp,
> +					     fault->req_level >= it.level);
>  	}
>  
>  	if (WARN_ON_ONCE(it.level != fault->goal_level))
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 582def531d4d..cca1ad75d096 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -100,6 +100,13 @@ struct kvm_mmu_page {
>  		};
>  	};
>  
> +	/*
> +	 * Tracks shadow pages that, if zapped, would allow KVM to create an NX
> +	 * huge page.  A shadow page will have lpage_disallowed set but not be
> +	 * on the list if a huge page is disallowed for other reasons, e.g.
> +	 * because KVM is shadowing a PTE at the same gfn, the memslot isn't
> +	 * properly aligned, etc...
> +	 */
>  	struct list_head lpage_disallowed_link;
>  #ifdef CONFIG_X86_32
>  	/*
> @@ -315,7 +322,8 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
>  
>  void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
>  
> -void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
> +void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp,
> +			  bool nx_huge_page_possible);
>  void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
>  
>  #endif /* __KVM_X86_MMU_INTERNAL_H */
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index f5958071220c..e450f49f2225 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -713,9 +713,9 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  			continue;
>  
>  		link_shadow_page(vcpu, it.sptep, sp);
> -		if (fault->huge_page_disallowed &&
> -		    fault->req_level >= it.level)
> -			account_huge_nx_page(vcpu->kvm, sp);
> +		if (fault->huge_page_disallowed)
> +			account_huge_nx_page(vcpu->kvm, sp,
> +					     fault->req_level >= it.level);
>  	}
>  
>  	if (WARN_ON_ONCE(it.level != fault->goal_level))
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index bf2ccf9debca..903d0d3497b6 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -284,6 +284,8 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
>  static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
>  			    gfn_t gfn, union kvm_mmu_page_role role)
>  {
> +	INIT_LIST_HEAD(&sp->lpage_disallowed_link);
> +
>  	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
>  
>  	sp->role = role;
> @@ -1130,7 +1132,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
>  	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
>  	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
>  	if (account_nx)
> -		account_huge_nx_page(kvm, sp);
> +		account_huge_nx_page(kvm, sp, true);
>  	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
>  
>  	return 0;
> -- 
> 2.37.1.559.g78731f0fdb-goog
> 
