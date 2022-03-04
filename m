Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFFF64CCA84
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 01:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbiCDAIh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 19:08:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232353AbiCDAIf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 19:08:35 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5661B3EAB2
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 16:07:47 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id z16so6155605pfh.3
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 16:07:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f/WVYsNOPwQRpYpJR/QAbLMXPhxPxVMb49eUEPwW+Rw=;
        b=J5n9kDnH3PSQTd+yFsW5oQydlin1Mea9FaYcGilD65p4NEI89VGcu1mFnj8npKwRhI
         o//lI3JWkfKIi1xuj/QYlSrdfwGsG/3EtB3ZEuuaJTPt1QDO/U1CZiOfcRIVR2aOAKDe
         E57+fbQPPu7TjdxC8s9r5OT0JuAUbnvQatGtfsGSI1iY0TK2LbWURl2iHIZy5OOBY5Jt
         k3e/LRIVi5uRsZ381EL9Zv//IDb9Mm32u/XZ4/ly4RYcVOw2rxShZcm4eAeJUwrwvXK0
         BMyH+/qzTwxs5CZnlWkXnsvhhOExamNh089XIVep8o3vz6+v08tf+NNOo+cW9ghSEiRn
         nwoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f/WVYsNOPwQRpYpJR/QAbLMXPhxPxVMb49eUEPwW+Rw=;
        b=QYJrFzFAqY5ZR05igCFIRcyaCxeEe5u54fGElGeDAnSXwAUvMQEvX57lzLKTrpMGEn
         6Asz/lI09eR7Ne0awYP/hccHGytXU5XH8BPZIeJNdz9gcA8L0T7/qiuXZBYvUoAzke/U
         7LQlcYivvnQ1gx6fzQCMFZT61WS1PN2Tplsh2OejUAoBqN3bK3mYSmD0W00pijGb82Me
         NA7OEi73ZrhE95WQt31EuaV1POOttx59ruhnFctTiSiobI073ndstNFlPzX2Z8r18aDw
         EADtbh9umLjrYsmZOjK7M158iVRDRjKx0vcBM953GyB83LgpylqSdXeMLBhwIKqjC5bA
         Yu1g==
X-Gm-Message-State: AOAM5310YeIIIlTIIIFayBPzEOEnqf8scHCqngdedJRg36XR38HJxM8h
        M4Tr3/v4g8VcZx/cVYFPjyLmyQ==
X-Google-Smtp-Source: ABdhPJz3NBvH52z9Lf3JtcVq37eO4pIhSXDRYPegdztqjJ89XwGDlRslFPE3yJxvvP59s1+1HvA/YA==
X-Received: by 2002:a05:6a00:1646:b0:4f4:58f:b64 with SMTP id m6-20020a056a00164600b004f4058f0b64mr24965696pfc.47.1646352465993;
        Thu, 03 Mar 2022 16:07:45 -0800 (PST)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id p10-20020a637f4a000000b00373a2760775sm2813386pgn.2.2022.03.03.16.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 16:07:45 -0800 (PST)
Date:   Fri, 4 Mar 2022 00:07:41 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v4 16/30] KVM: x86/mmu: Add dedicated helper to zap TDP
 MMU root shadow page
Message-ID: <YiFYTcFk+NYCtuZR@google.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
 <20220303193842.370645-17-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303193842.370645-17-pbonzini@redhat.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 03, 2022, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Add a dedicated helper for zapping a TDP MMU root, and use it in the three
> flows that do "zap_all" and intentionally do not do a TLB flush if SPTEs
> are zapped (zapping an entire root is safe if and only if it cannot be in
> use by any vCPU).  Because a TLB flush is never required, unconditionally
> pass "false" to tdp_mmu_iter_cond_resched() when potentially yielding.
> 
> Opportunistically document why KVM must not yield when zapping roots that
> are being zapped by kvm_tdp_mmu_put_root(), i.e. roots whose refcount has
> reached zero, and further harden the flow to detect improper KVM behavior
> with respect to roots that are supposed to be unreachable.
> 
> In addition to hardening zapping of roots, isolating zapping of roots
> will allow future simplification of zap_gfn_range() by having it zap only
> leaf SPTEs, and by removing its tricky "zap all" heuristic.  By having
> all paths that truly need to free _all_ SPs flow through the dedicated
> root zapper, the generic zapper can be freed of those concerns.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Message-Id: <20220226001546.360188-16-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Mingwei Zhang <mizhang@google.com>

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 98 +++++++++++++++++++++++++++++++-------
>  1 file changed, 82 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index f59f3ff5cb75..970376297b30 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -56,10 +56,6 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
>  	rcu_barrier();
>  }
>  
> -static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> -			  gfn_t start, gfn_t end, bool can_yield, bool flush,
> -			  bool shared);
> -
>  static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
>  {
>  	free_page((unsigned long)sp->spt);
> @@ -82,6 +78,9 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
>  	tdp_mmu_free_sp(sp);
>  }
>  
> +static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
> +			     bool shared);
> +
>  void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
>  			  bool shared)
>  {
> @@ -104,7 +103,7 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
>  	 * intermediate paging structures, that may be zapped, as such entries
>  	 * are associated with the ASID on both VMX and SVM.
>  	 */
> -	(void)zap_gfn_range(kvm, root, 0, -1ull, false, false, shared);
> +	tdp_mmu_zap_root(kvm, root, shared);
>  
>  	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
>  }
> @@ -737,6 +736,76 @@ static inline bool __must_check tdp_mmu_iter_cond_resched(struct kvm *kvm,
>  	return iter->yielded;
>  }
>  
> +static inline gfn_t tdp_mmu_max_gfn_host(void)
> +{
> +	/*
> +	 * Bound TDP MMU walks at host.MAXPHYADDR, guest accesses beyond that
> +	 * will hit a #PF(RSVD) and never hit an EPT Violation/Misconfig / #NPF,
> +	 * and so KVM will never install a SPTE for such addresses.
> +	 */
> +	return 1ULL << (shadow_phys_bits - PAGE_SHIFT);
> +}
> +
> +static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
> +			     bool shared)
> +{
> +	bool root_is_unreachable = !refcount_read(&root->tdp_mmu_root_count);
> +	struct tdp_iter iter;
> +
> +	gfn_t end = tdp_mmu_max_gfn_host();
> +	gfn_t start = 0;
> +
> +	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
> +
> +	rcu_read_lock();
> +
> +	/*
> +	 * No need to try to step down in the iterator when zapping an entire
> +	 * root, zapping an upper-level SPTE will recurse on its children.
> +	 */
> +	for_each_tdp_pte_min_level(iter, root, root->role.level, start, end) {
> +retry:
> +		/*
> +		 * Yielding isn't allowed when zapping an unreachable root as
> +		 * the root won't be processed by mmu_notifier callbacks.  When
> +		 * handling an unmap/release mmu_notifier command, KVM must
> +		 * drop all references to relevant pages prior to completing
> +		 * the callback.  Dropping mmu_lock can result in zapping SPTEs
> +		 * for an unreachable root after a relevant callback completes,
> +		 * which leads to use-after-free as zapping a SPTE triggers
> +		 * "writeback" of dirty/accessed bits to the SPTE's associated
> +		 * struct page.
> +		 */
> +		if (!root_is_unreachable &&
> +		    tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
> +			continue;
> +
> +		if (!is_shadow_present_pte(iter.old_spte))
> +			continue;
> +
> +		if (!shared) {
> +			tdp_mmu_set_spte(kvm, &iter, 0);
> +		} else if (tdp_mmu_set_spte_atomic(kvm, &iter, 0)) {
> +			/*
> +			 * cmpxchg() shouldn't fail if the root is unreachable.
> +			 * Retry so as not to leak the page and its children.
> +			 */
> +			WARN_ONCE(root_is_unreachable,
> +				  "Contended TDP MMU SPTE in unreachable root.");
> +			goto retry;
> +		}
> +
> +		/*
> +		 * WARN if the root is invalid and is unreachable, all SPTEs
> +		 * should've been zapped by kvm_tdp_mmu_zap_invalidated_roots(),
> +		 * and inserting new SPTEs under an invalid root is a KVM bug.
> +		 */
> +		WARN_ON_ONCE(root_is_unreachable && root->role.invalid);
> +	}
> +
> +	rcu_read_unlock();
> +}
> +
>  bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
>  	u64 old_spte;
> @@ -785,8 +854,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>  			  gfn_t start, gfn_t end, bool can_yield, bool flush,
>  			  bool shared)
>  {
> -	gfn_t max_gfn_host = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
> -	bool zap_all = (start == 0 && end >= max_gfn_host);
> +	bool zap_all = (start == 0 && end >= tdp_mmu_max_gfn_host());
>  	struct tdp_iter iter;
>  
>  	/*
> @@ -795,12 +863,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>  	 */
>  	int min_level = zap_all ? root->role.level : PG_LEVEL_4K;
>  
> -	/*
> -	 * Bound the walk at host.MAXPHYADDR, guest accesses beyond that will
> -	 * hit a #PF(RSVD) and never get to an EPT Violation/Misconfig / #NPF,
> -	 * and so KVM will never install a SPTE for such addresses.
> -	 */
> -	end = min(end, max_gfn_host);
> +	end = min(end, tdp_mmu_max_gfn_host());
>  
>  	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
>  
> @@ -860,6 +923,7 @@ bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
>  
>  void kvm_tdp_mmu_zap_all(struct kvm *kvm)
>  {
> +	struct kvm_mmu_page *root;
>  	int i;
>  
>  	/*
> @@ -867,8 +931,10 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
>  	 * is being destroyed or the userspace VMM has exited.  In both cases,
>  	 * KVM_RUN is unreachable, i.e. no vCPUs will ever service the request.
>  	 */
> -	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
> -		(void)kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, -1ull, false);
> +	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> +		for_each_tdp_mmu_root_yield_safe(kvm, root, i)
> +			tdp_mmu_zap_root(kvm, root, false);
> +	}
>  }
>  
>  static struct kvm_mmu_page *next_invalidated_root(struct kvm *kvm,
> @@ -925,7 +991,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
>  		 * will still flush on yield, but that's a minor performance
>  		 * blip and not a functional issue.
>  		 */
> -		(void)zap_gfn_range(kvm, root, 0, -1ull, true, false, true);
> +		tdp_mmu_zap_root(kvm, root, true);
>  
>  		/*
>  		 * Put the reference acquired in
> -- 
> 2.31.1
> 
> 
