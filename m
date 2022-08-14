Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64D43591D68
	for <lists+kvm@lfdr.de>; Sun, 14 Aug 2022 03:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240114AbiHNBMS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Aug 2022 21:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiHNBMR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Aug 2022 21:12:17 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07C713DEE
        for <kvm@vger.kernel.org>; Sat, 13 Aug 2022 18:12:15 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d16so3680281pll.11
        for <kvm@vger.kernel.org>; Sat, 13 Aug 2022 18:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=uNNmv8kDPlMYHuOnmM/f+sTjEO16OylEBMIt9uRpqPc=;
        b=MBS0kTRuF7veLkGINa1a5VENK0oIkwENkMFVtPa3LDxbRv0ISdi9DGX10KaPkXJIcV
         2hOywWOkh8yRrCYhrPlsb4ZOndPz3fVds5vumMiJL0PpFOFfgM9wxqfOR8TcBoqZqm6l
         13d4kr4GXoN+BRP9nSuYCEg/OL5OpjTK8VNQ4XXEJGXwYiT4ut8zP2je/bjPs/UgoOk3
         aPClrHktXfas9jilhA5xVf13X7W5zZF6pVOwqXLErcTbRl4RspwFkhxJEP6a17B2JEjw
         iNa2aeNFihloN7omAHug+zWXVKqfSzXtf2tWzE5QtvvdKH43rYcVA+UUlblX/mn6CQ3A
         xmgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=uNNmv8kDPlMYHuOnmM/f+sTjEO16OylEBMIt9uRpqPc=;
        b=rga6sSnVz10dSdw3Z7dLLXIJVftEhS7XbsgkKn/X9ZXSbHqgaEROxsH8VrNRlN/Qgw
         oTglksJBlD5JOsJOOlA1X9nQn3ZJh0MB44Q8j06879R1GtYd/M4WQQrKztNiy++OlCnn
         7RLSKeGL0JmG4un/Uq/nI7qEofaXQi0wxPRd03D5ECpX8nTICcgB9pEyPYQPtF11DP0w
         iCPPngZnCX4VoOX/WIj7SocuzyzxU0MupC+w18FL04bZP8Vzu1FCxQzhnXKhgXGTtD0I
         ikX3p8FtKdqnXIZmHA6qLdjEbAhyQ9kuS4LSKzcRMaCfZ3aK8WpAxVZNiahFgpjBjvnc
         Kb0g==
X-Gm-Message-State: ACgBeo1v9kp3/mha++GhsoEwDIfvqRSufJeInA+ohbc2NrdngMDMVM11
        TPWz1iyPlWAYx6M4n2vHqNGi9A==
X-Google-Smtp-Source: AA6agR6em6Ayc75BH8jIaSo555+9u6uvxDLO+XPCrwPaaePEINAClE4mdorvdcr+La5T192ETutsfQ==
X-Received: by 2002:a17:90b:164d:b0:1f6:a38b:91e9 with SMTP id il13-20020a17090b164d00b001f6a38b91e9mr11543216pjb.211.1660439534809;
        Sat, 13 Aug 2022 18:12:14 -0700 (PDT)
Received: from google.com (33.5.83.34.bc.googleusercontent.com. [34.83.5.33])
        by smtp.gmail.com with ESMTPSA id e30-20020a056a0000de00b0052d9d95bb2bsm2814466pfj.180.2022.08.13.18.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Aug 2022 18:12:14 -0700 (PDT)
Date:   Sun, 14 Aug 2022 01:12:10 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v3 3/8] KVM: x86/mmu: Rename NX huge pages
 fields/functions for consistency
Message-ID: <YvhL6jKfKCj0+74w@google.com>
References: <20220805230513.148869-1-seanjc@google.com>
 <20220805230513.148869-4-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805230513.148869-4-seanjc@google.com>
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
> Rename most of the variables/functions involved in the NX huge page
> mitigation to provide consistency, e.g. lpage vs huge page, and NX huge
> vs huge NX, and also to provide clarity, e.g. to make it obvious the flag
> applies only to the NX huge page mitigation, not to any condition that
> prevents creating a huge page.
> 
> Leave the nx_lpage_splits stat alone as the name is ABI and thus set in
> stone.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  8 ++--
>  arch/x86/kvm/mmu/mmu.c          | 70 +++++++++++++++++----------------
>  arch/x86/kvm/mmu/mmu_internal.h | 22 +++++++----
>  arch/x86/kvm/mmu/paging_tmpl.h  |  2 +-
>  arch/x86/kvm/mmu/tdp_mmu.c      |  8 ++--
>  5 files changed, 59 insertions(+), 51 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e8281d64a431..5634347e5d05 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1143,7 +1143,7 @@ struct kvm_arch {
>  	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
>  	struct list_head active_mmu_pages;
>  	struct list_head zapped_obsolete_pages;
> -	struct list_head lpage_disallowed_mmu_pages;
> +	struct list_head possible_nx_huge_pages;

Honestly, I am struggling to understand this one. 'possible_*' indicates
that there are other possibilities. But what are those possibilities? I
feel this name is more confusing than the original one. Maybe just keep
the original name?

>  	struct kvm_page_track_notifier_node mmu_sp_tracker;
>  	struct kvm_page_track_notifier_head track_notifier_head;
>  	/*
> @@ -1259,7 +1259,7 @@ struct kvm_arch {
>  	bool sgx_provisioning_allowed;
>  
>  	struct kvm_pmu_event_filter __rcu *pmu_event_filter;
> -	struct task_struct *nx_lpage_recovery_thread;
> +	struct task_struct *nx_huge_page_recovery_thread;
>  
>  #ifdef CONFIG_X86_64
>  	/*
> @@ -1304,8 +1304,8 @@ struct kvm_arch {
>  	 *  - tdp_mmu_roots (above)
>  	 *  - tdp_mmu_pages (above)
>  	 *  - the link field of struct kvm_mmu_pages used by the TDP MMU
> -	 *  - lpage_disallowed_mmu_pages
> -	 *  - the lpage_disallowed_link field of struct kvm_mmu_pages used
> +	 *  - possible_nx_huge_pages;
> +	 *  - the possible_nx_huge_page_link field of struct kvm_mmu_pages used
>  	 *    by the TDP MMU
>  	 * It is acceptable, but not necessary, to acquire this lock when
>  	 * the thread holds the MMU lock in write mode.
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 55dac44f3397..53d0dafa68ff 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -802,20 +802,20 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
>  		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
>  }
>  
> -void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp,
> +void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
>  			  bool nx_huge_page_possible)
>  {
> -	if (KVM_BUG_ON(!list_empty(&sp->lpage_disallowed_link), kvm))
> +	if (KVM_BUG_ON(!list_empty(&sp->possible_nx_huge_page_link), kvm))
>  		return;
>  
> -	sp->lpage_disallowed = true;
> +	sp->nx_huge_page_disallowed = true;
>  
>  	if (!nx_huge_page_possible)
>  		return;
>  
>  	++kvm->stat.nx_lpage_splits;
> -	list_add_tail(&sp->lpage_disallowed_link,
> -		      &kvm->arch.lpage_disallowed_mmu_pages);
> +	list_add_tail(&sp->possible_nx_huge_page_link,
> +		      &kvm->arch.possible_nx_huge_pages);
>  }
>  
>  static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
> @@ -835,15 +835,15 @@ static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
>  	kvm_mmu_gfn_allow_lpage(slot, gfn);
>  }
>  
> -void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> +void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
> -	sp->lpage_disallowed = false;
> +	sp->nx_huge_page_disallowed = false;
>  
> -	if (list_empty(&sp->lpage_disallowed_link))
> +	if (list_empty(&sp->possible_nx_huge_page_link))
>  		return;
>  
>  	--kvm->stat.nx_lpage_splits;
> -	list_del_init(&sp->lpage_disallowed_link);
> +	list_del_init(&sp->possible_nx_huge_page_link);
>  }
>  
>  static struct kvm_memory_slot *
> @@ -2124,7 +2124,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
>  
>  	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
>  
> -	INIT_LIST_HEAD(&sp->lpage_disallowed_link);
> +	INIT_LIST_HEAD(&sp->possible_nx_huge_page_link);
>  
>  	/*
>  	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
> @@ -2483,8 +2483,8 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
>  		zapped_root = !is_obsolete_sp(kvm, sp);
>  	}
>  
> -	if (sp->lpage_disallowed)
> -		unaccount_huge_nx_page(kvm, sp);
> +	if (sp->nx_huge_page_disallowed)
> +		unaccount_nx_huge_page(kvm, sp);
>  
>  	sp->role.invalid = 1;
>  
> @@ -3124,7 +3124,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  
>  		link_shadow_page(vcpu, it.sptep, sp);
>  		if (fault->is_tdp && fault->huge_page_disallowed)
> -			account_huge_nx_page(vcpu->kvm, sp,
> +			account_nx_huge_page(vcpu->kvm, sp,
>  					     fault->req_level >= it.level);
>  	}
>  
> @@ -5981,7 +5981,7 @@ int kvm_mmu_init_vm(struct kvm *kvm)
>  
>  	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
>  	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
> -	INIT_LIST_HEAD(&kvm->arch.lpage_disallowed_mmu_pages);
> +	INIT_LIST_HEAD(&kvm->arch.possible_nx_huge_pages);
>  	spin_lock_init(&kvm->arch.mmu_unsync_pages_lock);
>  
>  	r = kvm_mmu_init_tdp_mmu(kvm);
> @@ -6699,7 +6699,7 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
>  			kvm_mmu_zap_all_fast(kvm);
>  			mutex_unlock(&kvm->slots_lock);
>  
> -			wake_up_process(kvm->arch.nx_lpage_recovery_thread);
> +			wake_up_process(kvm->arch.nx_huge_page_recovery_thread);
>  		}
>  		mutex_unlock(&kvm_lock);
>  	}
> @@ -6825,7 +6825,7 @@ static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel
>  		mutex_lock(&kvm_lock);
>  
>  		list_for_each_entry(kvm, &vm_list, vm_list)
> -			wake_up_process(kvm->arch.nx_lpage_recovery_thread);
> +			wake_up_process(kvm->arch.nx_huge_page_recovery_thread);
>  
>  		mutex_unlock(&kvm_lock);
>  	}
> @@ -6833,7 +6833,7 @@ static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel
>  	return err;
>  }
>  
> -static void kvm_recover_nx_lpages(struct kvm *kvm)
> +static void kvm_recover_nx_huge_pages(struct kvm *kvm)
>  {
>  	unsigned long nx_lpage_splits = kvm->stat.nx_lpage_splits;
>  	int rcu_idx;
> @@ -6856,23 +6856,25 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
>  	ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
>  	to_zap = ratio ? DIV_ROUND_UP(nx_lpage_splits, ratio) : 0;
>  	for ( ; to_zap; --to_zap) {
> -		if (list_empty(&kvm->arch.lpage_disallowed_mmu_pages))
> +		if (list_empty(&kvm->arch.possible_nx_huge_pages))
>  			break;
>  
>  		/*
>  		 * We use a separate list instead of just using active_mmu_pages
> -		 * because the number of lpage_disallowed pages is expected to
> -		 * be relatively small compared to the total.
> +		 * because the number of shadow pages that be replaced with an
> +		 * NX huge page is expected to be relatively small compared to
> +		 * the total number of shadow pages.  And because the TDP MMU
> +		 * doesn't use active_mmu_pages.
>  		 */
> -		sp = list_first_entry(&kvm->arch.lpage_disallowed_mmu_pages,
> +		sp = list_first_entry(&kvm->arch.possible_nx_huge_pages,
>  				      struct kvm_mmu_page,
> -				      lpage_disallowed_link);
> -		WARN_ON_ONCE(!sp->lpage_disallowed);
> +				      possible_nx_huge_page_link);
> +		WARN_ON_ONCE(!sp->nx_huge_page_disallowed);
>  		if (is_tdp_mmu_page(sp)) {
>  			flush |= kvm_tdp_mmu_zap_sp(kvm, sp);
>  		} else {
>  			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
> -			WARN_ON_ONCE(sp->lpage_disallowed);
> +			WARN_ON_ONCE(sp->nx_huge_page_disallowed);
>  		}
>  
>  		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
> @@ -6893,7 +6895,7 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
>  	srcu_read_unlock(&kvm->srcu, rcu_idx);
>  }
>  
> -static long get_nx_lpage_recovery_timeout(u64 start_time)
> +static long get_nx_huge_page_recovery_timeout(u64 start_time)
>  {
>  	bool enabled;
>  	uint period;
> @@ -6904,19 +6906,19 @@ static long get_nx_lpage_recovery_timeout(u64 start_time)
>  		       : MAX_SCHEDULE_TIMEOUT;
>  }
>  
> -static int kvm_nx_lpage_recovery_worker(struct kvm *kvm, uintptr_t data)
> +static int kvm_nx_huge_page_recovery_worker(struct kvm *kvm, uintptr_t data)
>  {
>  	u64 start_time;
>  	long remaining_time;
>  
>  	while (true) {
>  		start_time = get_jiffies_64();
> -		remaining_time = get_nx_lpage_recovery_timeout(start_time);
> +		remaining_time = get_nx_huge_page_recovery_timeout(start_time);
>  
>  		set_current_state(TASK_INTERRUPTIBLE);
>  		while (!kthread_should_stop() && remaining_time > 0) {
>  			schedule_timeout(remaining_time);
> -			remaining_time = get_nx_lpage_recovery_timeout(start_time);
> +			remaining_time = get_nx_huge_page_recovery_timeout(start_time);
>  			set_current_state(TASK_INTERRUPTIBLE);
>  		}
>  
> @@ -6925,7 +6927,7 @@ static int kvm_nx_lpage_recovery_worker(struct kvm *kvm, uintptr_t data)
>  		if (kthread_should_stop())
>  			return 0;
>  
> -		kvm_recover_nx_lpages(kvm);
> +		kvm_recover_nx_huge_pages(kvm);
>  	}
>  }
>  
> @@ -6933,17 +6935,17 @@ int kvm_mmu_post_init_vm(struct kvm *kvm)
>  {
>  	int err;
>  
> -	err = kvm_vm_create_worker_thread(kvm, kvm_nx_lpage_recovery_worker, 0,
> +	err = kvm_vm_create_worker_thread(kvm, kvm_nx_huge_page_recovery_worker, 0,
>  					  "kvm-nx-lpage-recovery",
> -					  &kvm->arch.nx_lpage_recovery_thread);
> +					  &kvm->arch.nx_huge_page_recovery_thread);
>  	if (!err)
> -		kthread_unpark(kvm->arch.nx_lpage_recovery_thread);
> +		kthread_unpark(kvm->arch.nx_huge_page_recovery_thread);
>  
>  	return err;
>  }
>  
>  void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
>  {
> -	if (kvm->arch.nx_lpage_recovery_thread)
> -		kthread_stop(kvm->arch.nx_lpage_recovery_thread);
> +	if (kvm->arch.nx_huge_page_recovery_thread)
> +		kthread_stop(kvm->arch.nx_huge_page_recovery_thread);
>  }
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index cca1ad75d096..67879459a25c 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -57,7 +57,13 @@ struct kvm_mmu_page {
>  	bool tdp_mmu_page;
>  	bool unsync;
>  	u8 mmu_valid_gen;
> -	bool lpage_disallowed; /* Can't be replaced by an equiv large page */
> +
> +	 /*
> +	  * The shadow page can't be replaced by an equivalent huge page
> +	  * because it is being used to map an executable page in the guest
> +	  * and the NX huge page mitigation is enabled.
> +	  */
> +	bool nx_huge_page_disallowed;
>  
>  	/*
>  	 * The following two entries are used to key the shadow page in the
> @@ -102,12 +108,12 @@ struct kvm_mmu_page {
>  
>  	/*
>  	 * Tracks shadow pages that, if zapped, would allow KVM to create an NX
> -	 * huge page.  A shadow page will have lpage_disallowed set but not be
> -	 * on the list if a huge page is disallowed for other reasons, e.g.
> -	 * because KVM is shadowing a PTE at the same gfn, the memslot isn't
> -	 * properly aligned, etc...
> +	 * huge page.  A shadow page will have nx_huge_page_disallowed set but
> +	 * not be on the list if a huge page is disallowed for other reasons,
> +	 * e.g. because KVM is shadowing a PTE at the same gfn, the memslot
> +	 * isn't properly aligned, etc...
>  	 */
> -	struct list_head lpage_disallowed_link;
> +	struct list_head possible_nx_huge_page_link;
>  #ifdef CONFIG_X86_32
>  	/*
>  	 * Used out of the mmu-lock to avoid reading spte values while an
> @@ -322,8 +328,8 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
>  
>  void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
>  
> -void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp,
> +void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
>  			  bool nx_huge_page_possible);
> -void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
> +void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
>  
>  #endif /* __KVM_X86_MMU_INTERNAL_H */
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index e450f49f2225..259c0f019f09 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -714,7 +714,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  
>  		link_shadow_page(vcpu, it.sptep, sp);
>  		if (fault->huge_page_disallowed)
> -			account_huge_nx_page(vcpu->kvm, sp,
> +			account_nx_huge_page(vcpu->kvm, sp,
>  					     fault->req_level >= it.level);
>  	}
>  
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 903d0d3497b6..0e94182c87be 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -284,7 +284,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
>  static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
>  			    gfn_t gfn, union kvm_mmu_page_role role)
>  {
> -	INIT_LIST_HEAD(&sp->lpage_disallowed_link);
> +	INIT_LIST_HEAD(&sp->possible_nx_huge_page_link);
>  
>  	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
>  
> @@ -392,8 +392,8 @@ static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
>  		lockdep_assert_held_write(&kvm->mmu_lock);
>  
>  	list_del(&sp->link);
> -	if (sp->lpage_disallowed)
> -		unaccount_huge_nx_page(kvm, sp);
> +	if (sp->nx_huge_page_disallowed)
> +		unaccount_nx_huge_page(kvm, sp);
>  
>  	if (shared)
>  		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> @@ -1132,7 +1132,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
>  	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
>  	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
>  	if (account_nx)
> -		account_huge_nx_page(kvm, sp, true);
> +		account_nx_huge_page(kvm, sp, true);
>  	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
>  
>  	return 0;
> -- 
> 2.37.1.559.g78731f0fdb-goog
> 
