Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 218BC659148
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 20:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbiL2Tvz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 14:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiL2Tvx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 14:51:53 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3372E16596
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 11:51:51 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id u7so19832627plq.11
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 11:51:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hcNYHSW7T6PMIQSOm5F2rLnVHmU/3Lj35iNScXN8Le0=;
        b=rQ77FPCsFMaH1Zp9kd8t3lq17dw1I9oGfsAMRjnbuNnjcMGdHnfmfi1BdOQNlucQza
         waipiIc21Tp8SVxpq3eSTFh7iHkYIfk3UIxLJUv0r6bTATAsx+4AvVkpSngKjA59/cn4
         Oa/8YbMLJ0dn5bQsudbHt9WQbl1y40UJJtobwsclsX01ok1rm87vA+weQqDF2ArPpnX5
         7Q9u8y59KdDDEjmdkcNGgT7vF60/Lq0FMfzFgQWL4uWm3/JC1q2AqRLYFfsvw9OC1ayq
         On8ppunW/qz4NYxEh/rj649dD/aor02JLcZ8UN4Ul24WvMLsu+7X8w/pmfNQEJhEylnH
         BPog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hcNYHSW7T6PMIQSOm5F2rLnVHmU/3Lj35iNScXN8Le0=;
        b=wNIWiZZe7ZLJZQewMwkVurTJ9NkjX6F9hxKnDzkE0v91ruJ0ri2LRFqKsTH+dt1oST
         S9piYiKJvjfV4h+K985IpY79CgZ6LmQrEus5B/LCRvrLaCb+t9BqotCOphNVh4B3h8dr
         Wq+T3FUVLb/ikU7cj9JXop+j4AUmu3kIhcZy/QdUI6IyMva7tvtoBql3SJSoLUXAyxdG
         m3LXfQ/kG24sK9zMWPsUtVluG9IGE6RWzpwJvtaSJKcbNQ5ASK4e50paqnlnilQzH8Io
         lfHzJp5YEWhE61pqA9vwjBtr9h0fevsL6KcqRgC6ZyPqAke6Iy5U5WTGOwUM0BeNcyWk
         yw8Q==
X-Gm-Message-State: AFqh2kp80Ep/2ZTwsT+6Xk0wIhH2TnqXxXmQNG8sb4DAv65o/HfaMsz5
        U4eOemnebZf5OP/9VPA0hhYF5w==
X-Google-Smtp-Source: AMrXdXvDWWNT+Hy40+Om978yXTcJpUtPGDX+oWGv7q8+LDlFi4L1CQtKZbWYCBrw73pFsREszlU9lg==
X-Received: by 2002:a17:90a:c68d:b0:219:184f:c736 with SMTP id n13-20020a17090ac68d00b00219184fc736mr38552138pjt.48.1672343510424;
        Thu, 29 Dec 2022 11:51:50 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id s63-20020a17090a69c500b002262dd8a39bsm1746845pjj.49.2022.12.29.11.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 11:51:49 -0800 (PST)
Date:   Thu, 29 Dec 2022 11:51:45 -0800
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Robert Hoo <robert.hu@linux.intel.com>,
        Greg Thelen <gthelen@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH 5/5] KVM: x86/mmu: Move kvm_tdp_mmu_map()'s prolog and
 epilog to its caller
Message-ID: <Y63v0UnlI+wrrXfa@google.com>
References: <20221213033030.83345-1-seanjc@google.com>
 <20221213033030.83345-6-seanjc@google.com>
 <Y6H2o2ADCALDA2oL@google.com>
 <Y6NRJTboZnjKbAL7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6NRJTboZnjKbAL7@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 21, 2022 at 06:32:05PM +0000, Sean Christopherson wrote:
> On Tue, Dec 20, 2022, David Matlack wrote:
> > On Tue, Dec 13, 2022 at 03:30:30AM +0000, Sean Christopherson wrote:
> > > Move the hugepage adjust, tracepoint, and RCU (un)lock logic out of
> > > kvm_tdp_mmu_map() and into its sole caller, kvm_tdp_mmu_page_fault(), to
> > > eliminate the gotos used to bounce through rcu_read_unlock() when bailing
> > > from the walk.
> > > 
> > > Opportunistically mark kvm_mmu_hugepage_adjust() as static as
> > > kvm_tdp_mmu_map() was the only external user.
> > > 
> > > No functional change intended.
> > > 
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c          |  9 ++++++++-
> > >  arch/x86/kvm/mmu/mmu_internal.h |  1 -
> > >  arch/x86/kvm/mmu/tdp_mmu.c      | 22 ++++------------------
> > >  3 files changed, 12 insertions(+), 20 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 254bc46234e0..99c40617d325 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -3085,7 +3085,8 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
> > >  	return min(host_level, max_level);
> > >  }
> > >  
> > > -void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> > > +static void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu,
> > > +				    struct kvm_page_fault *fault)
> > >  {
> > >  	struct kvm_memory_slot *slot = fault->slot;
> > >  	kvm_pfn_t mask;
> > > @@ -4405,7 +4406,13 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
> > >  	if (is_page_fault_stale(vcpu, fault))
> > >  		goto out_unlock;
> > >  
> > > +	kvm_mmu_hugepage_adjust(vcpu, fault);
> > 
> > Can you also move the call to kvm_mmu_hugepage_adjust() from
> > direct_map() to direct_page_fault()? I do think it's worth the
> > maintenence burden to keep those functions consistent.
> 
> Sure.
> 
> > > +	trace_kvm_mmu_spte_requested(fault);
> > > +
> > > +	rcu_read_lock();
> > >  	r = kvm_tdp_mmu_map(vcpu, fault);
> > > +	rcu_read_unlock();
> > 
> > I would prefer to keep these in tdp_mmu.c, to reduce the amount of TDP
> > MMU details that bleed into mmu.c (RCU) and for consistency with other
> > TDP MMU APIs that don't require the caller to acquire RCU.  This will
> > also be helpful for the Common MMU, as the tracepoint and RCU will be
> > common.
> > 
> > e.g.
> > 
> > static int __kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> > {
> > 	...
> > }
> > 
> > int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> > {
> > 	int r;
> > 
> > 	trace_kvm_mmu_spte_requested(fault);
> > 
> > 	rcu_read_lock();
> > 	r = __kvm_tdp_mmu_map(vcpu, fault);
> > 	rcu_read_unlock();
> > 
> > 	return r;
> > }
> 
> I did that originally, but it felt really silly to have the trivial wrapper, especially
> because mmu.c already has TDP MMU details, e.g. kvm_tdp_mmu_page_fault() takes mmu_lock
> for read and other flows acquire rcu_read_lock() to protected the TDP MMU.

A trivial wrapper is useful in this case. While mmu.c does already have
some TDP MMU RCU details, I'd like to decrease that not increase it.

> 
> What about the below (split into multiple patches) instead?  kvm_tdp_mmu_page_fault()
> really should live in tdp_mmu.c, the only reason it's in mmu.c is to get at various
> helpers, e.g. fast_page_fault() and kvm_faultin_pfn().

Maybe, I'm not sure. The page fault handling routines have more to do
with mmu.c than tdp_mmu.c. i.e. It's more about integrating with the
rest of KVM/x86 (page fault tracking, MMU notifiers, etc.). We only go
into tdp_mmu.c to manipulate page tables.

> 
> Or is that doomed to fail because the TDP MMU will want to add code before
> kvm_faultin_pfn() (I can't remember what motivated splitting out kvm_tdp_mmu_page_fault()
> in the first place).

To improve readability (less conditionals: if (tdp_mmu_enabled)) and
prepare for more divergence.

Your proposal (below) to split out the "lower half" of the page fault
handling routine works now because that's where all the divergence is.
But with the common MMU there's also going to be divergence in the fast
page fault handler. So I prefer to just keep the routines separate to
avoid thrashing down the road.

> 
> ---
>  arch/x86/kvm/mmu/mmu.c          | 132 ++++++++------------------------
>  arch/x86/kvm/mmu/mmu_internal.h |  50 ++++++++++++
>  arch/x86/kvm/mmu/spte.h         |   7 --
>  arch/x86/kvm/mmu/tdp_mmu.c      |  41 ++++++----
>  arch/x86/kvm/mmu/tdp_mmu.h      |   8 +-
>  5 files changed, 108 insertions(+), 130 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 254bc46234e0..8203b1dd2753 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1927,16 +1927,6 @@ static bool kvm_mmu_remote_flush_or_zap(struct kvm *kvm,
>  	return true;
>  }
>  
> -static bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
> -{
> -	if (sp->role.invalid)
> -		return true;
> -
> -	/* TDP MMU pages do not use the MMU generation. */
> -	return !is_tdp_mmu_page(sp) &&
> -	       unlikely(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen);
> -}
> -
>  struct mmu_page_path {
>  	struct kvm_mmu_page *parent[PT64_ROOT_MAX_LEVEL];
>  	unsigned int idx[PT64_ROOT_MAX_LEVEL];
> @@ -3148,9 +3138,6 @@ static int direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  	int ret;
>  	gfn_t base_gfn = fault->gfn;
>  
> -	kvm_mmu_hugepage_adjust(vcpu, fault);
> -
> -	trace_kvm_mmu_spte_requested(fault);
>  	for_each_shadow_entry(vcpu, fault->addr, it) {
>  		/*
>  		 * We cannot overwrite existing page tables with an NX
> @@ -4270,54 +4257,10 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  	return RET_PF_CONTINUE;
>  }
>  
> -/*
> - * Returns true if the page fault is stale and needs to be retried, i.e. if the
> - * root was invalidated by a memslot update or a relevant mmu_notifier fired.
> - */
> -static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
> -				struct kvm_page_fault *fault)
> +static int __direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
> -	struct kvm_mmu_page *sp = to_shadow_page(vcpu->arch.mmu->root.hpa);
> +	int r = RET_PF_RETRY;
>  
> -	/* Special roots, e.g. pae_root, are not backed by shadow pages. */
> -	if (sp && is_obsolete_sp(vcpu->kvm, sp))
> -		return true;
> -
> -	/*
> -	 * Roots without an associated shadow page are considered invalid if
> -	 * there is a pending request to free obsolete roots.  The request is
> -	 * only a hint that the current root _may_ be obsolete and needs to be
> -	 * reloaded, e.g. if the guest frees a PGD that KVM is tracking as a
> -	 * previous root, then __kvm_mmu_prepare_zap_page() signals all vCPUs
> -	 * to reload even if no vCPU is actively using the root.
> -	 */
> -	if (!sp && kvm_test_request(KVM_REQ_MMU_FREE_OBSOLETE_ROOTS, vcpu))
> -		return true;
> -
> -	return fault->slot &&
> -	       mmu_invalidate_retry_hva(vcpu->kvm, fault->mmu_seq, fault->hva);
> -}
> -
> -static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> -{
> -	int r;
> -
> -	if (page_fault_handle_page_track(vcpu, fault))
> -		return RET_PF_EMULATE;
> -
> -	r = fast_page_fault(vcpu, fault);
> -	if (r != RET_PF_INVALID)
> -		return r;
> -
> -	r = mmu_topup_memory_caches(vcpu, false);
> -	if (r)
> -		return r;
> -
> -	r = kvm_faultin_pfn(vcpu, fault, ACC_ALL);
> -	if (r != RET_PF_CONTINUE)
> -		return r;
> -
> -	r = RET_PF_RETRY;
>  	write_lock(&vcpu->kvm->mmu_lock);
>  
>  	if (is_page_fault_stale(vcpu, fault))
> @@ -4327,6 +4270,10 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	if (r)
>  		goto out_unlock;
>  
> +	kvm_mmu_hugepage_adjust(vcpu, fault);
> +
> +	trace_kvm_mmu_spte_requested(fault);
> +
>  	r = direct_map(vcpu, fault);
>  
>  out_unlock:
> @@ -4335,6 +4282,32 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	return r;
>  }
>  
> +static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> +{
> +	int r;
> +
> +	if (page_fault_handle_page_track(vcpu, fault))
> +		return RET_PF_EMULATE;
> +
> +	r = fast_page_fault(vcpu, fault);
> +	if (r != RET_PF_INVALID)
> +		return r;
> +
> +	r = mmu_topup_memory_caches(vcpu, false);
> +	if (r)
> +		return r;
> +
> +	r = kvm_faultin_pfn(vcpu, fault, ACC_ALL);
> +	if (r != RET_PF_CONTINUE)
> +		return r;
> +
> +#ifdef CONFIG_X86_64
> +	if (tdp_mmu_enabled)
> +		return kvm_tdp_mmu_page_fault(vcpu, fault);
> +#endif
> +	return __direct_page_fault(vcpu, fault);
> +}
> +
>  static int nonpaging_page_fault(struct kvm_vcpu *vcpu,
>  				struct kvm_page_fault *fault)
>  {
> @@ -4378,42 +4351,6 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
>  }
>  EXPORT_SYMBOL_GPL(kvm_handle_page_fault);
>  
> -#ifdef CONFIG_X86_64
> -static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
> -				  struct kvm_page_fault *fault)
> -{
> -	int r;
> -
> -	if (page_fault_handle_page_track(vcpu, fault))
> -		return RET_PF_EMULATE;
> -
> -	r = fast_page_fault(vcpu, fault);
> -	if (r != RET_PF_INVALID)
> -		return r;
> -
> -	r = mmu_topup_memory_caches(vcpu, false);
> -	if (r)
> -		return r;
> -
> -	r = kvm_faultin_pfn(vcpu, fault, ACC_ALL);
> -	if (r != RET_PF_CONTINUE)
> -		return r;
> -
> -	r = RET_PF_RETRY;
> -	read_lock(&vcpu->kvm->mmu_lock);
> -
> -	if (is_page_fault_stale(vcpu, fault))
> -		goto out_unlock;
> -
> -	r = kvm_tdp_mmu_map(vcpu, fault);
> -
> -out_unlock:
> -	read_unlock(&vcpu->kvm->mmu_lock);
> -	kvm_release_pfn_clean(fault->pfn);
> -	return r;
> -}
> -#endif
> -
>  int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
>  	/*
> @@ -4438,11 +4375,6 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  		}
>  	}
>  
> -#ifdef CONFIG_X86_64
> -	if (tdp_mmu_enabled)
> -		return kvm_tdp_mmu_page_fault(vcpu, fault);
> -#endif
> -
>  	return direct_page_fault(vcpu, fault);
>  }
>  
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index ac00bfbf32f6..2c7c2b49f719 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -133,6 +133,28 @@ struct kvm_mmu_page {
>  
>  extern struct kmem_cache *mmu_page_header_cache;
>  
> +static inline struct kvm_mmu_page *to_shadow_page(hpa_t shadow_page)
> +{
> +	struct page *page = pfn_to_page((shadow_page) >> PAGE_SHIFT);
> +
> +	return (struct kvm_mmu_page *)page_private(page);
> +}
> +
> +static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp)
> +{
> +	return IS_ENABLED(CONFIG_X86_64) && sp->tdp_mmu_page;
> +}
> +
> +static inline bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
> +{
> +	if (sp->role.invalid)
> +		return true;
> +
> +	/* TDP MMU pages do not use the MMU generation. */
> +	return !is_tdp_mmu_page(sp) &&
> +	       unlikely(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen);
> +}
> +
>  static inline int kvm_mmu_role_as_id(union kvm_mmu_page_role role)
>  {
>  	return role.smm ? 1 : 0;
> @@ -314,6 +336,34 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  	return r;
>  }
>  
> +/*
> + * Returns true if the page fault is stale and needs to be retried, i.e. if the
> + * root was invalidated by a memslot update or a relevant mmu_notifier fired.
> + */
> +static inline bool is_page_fault_stale(struct kvm_vcpu *vcpu,
> +				       struct kvm_page_fault *fault)
> +{
> +	struct kvm_mmu_page *sp = to_shadow_page(vcpu->arch.mmu->root.hpa);
> +
> +	/* Special roots, e.g. pae_root, are not backed by shadow pages. */
> +	if (sp && is_obsolete_sp(vcpu->kvm, sp))
> +		return true;
> +
> +	/*
> +	 * Roots without an associated shadow page are considered invalid if
> +	 * there is a pending request to free obsolete roots.  The request is
> +	 * only a hint that the current root _may_ be obsolete and needs to be
> +	 * reloaded, e.g. if the guest frees a PGD that KVM is tracking as a
> +	 * previous root, then __kvm_mmu_prepare_zap_page() signals all vCPUs
> +	 * to reload even if no vCPU is actively using the root.
> +	 */
> +	if (!sp && kvm_test_request(KVM_REQ_MMU_FREE_OBSOLETE_ROOTS, vcpu))
> +		return true;
> +
> +	return fault->slot &&
> +	       mmu_invalidate_retry_hva(vcpu->kvm, fault->mmu_seq, fault->hva);
> +}

is_page_fault_stale() is overkill for the TDP MMU and is
KVM/x86-specific. If we do go with your way of splitting things, I'd
prefer to have the TDP MMU not call is_page_fault_stale() so that more
code can be shared across architectures when the TDP MMU is common.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 99c40617d325..68db6805072a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3085,8 +3085,7 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
 	return min(host_level, max_level);
 }
 
-static void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu,
-				    struct kvm_page_fault *fault)
+void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_memory_slot *slot = fault->slot;
 	kvm_pfn_t mask;
@@ -4295,8 +4294,28 @@ static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
 	if (!sp && kvm_test_request(KVM_REQ_MMU_FREE_OBSOLETE_ROOTS, vcpu))
 		return true;
 
-	return fault->slot &&
-	       mmu_invalidate_retry_hva(vcpu->kvm, fault->mmu_seq, fault->hva);
+	return mmu_invalidate_retry_fault(vcpu, fault);
+}
+
+static int __direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+{
+	int r = RET_PF_RETRY;
+
+	write_lock(&vcpu->kvm->mmu_lock);
+
+	if (is_page_fault_stale(vcpu, fault))
+		goto out_unlock;
+
+	r = make_mmu_pages_available(vcpu);
+	if (r)
+		goto out_unlock;
+
+	r = direct_map(vcpu, fault);
+
+out_unlock:
+	write_unlock(&vcpu->kvm->mmu_lock);
+	kvm_release_pfn_clean(fault->pfn);
+	return r;
 }
 
 static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
@@ -4318,22 +4337,13 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (r != RET_PF_CONTINUE)
 		return r;
 
-	r = RET_PF_RETRY;
-	write_lock(&vcpu->kvm->mmu_lock);
-
-	if (is_page_fault_stale(vcpu, fault))
-		goto out_unlock;
-
-	r = make_mmu_pages_available(vcpu);
-	if (r)
-		goto out_unlock;
+#ifdef CONFIG_X86_64
+	if (tdp_mmu_enabled)
+		return kvm_tdp_mmu_page_fault(vcpu, fault);
+#endif
 
-	r = direct_map(vcpu, fault);
+	return __direct_page_fault(vcpu, fault);
 
-out_unlock:
-	write_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
-	return r;
 }
 
 static int nonpaging_page_fault(struct kvm_vcpu *vcpu,
@@ -4379,48 +4389,6 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 }
 EXPORT_SYMBOL_GPL(kvm_handle_page_fault);
 
-#ifdef CONFIG_X86_64
-static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
-				  struct kvm_page_fault *fault)
-{
-	int r;
-
-	if (page_fault_handle_page_track(vcpu, fault))
-		return RET_PF_EMULATE;
-
-	r = fast_page_fault(vcpu, fault);
-	if (r != RET_PF_INVALID)
-		return r;
-
-	r = mmu_topup_memory_caches(vcpu, false);
-	if (r)
-		return r;
-
-	r = kvm_faultin_pfn(vcpu, fault, ACC_ALL);
-	if (r != RET_PF_CONTINUE)
-		return r;
-
-	r = RET_PF_RETRY;
-	read_lock(&vcpu->kvm->mmu_lock);
-
-	if (is_page_fault_stale(vcpu, fault))
-		goto out_unlock;
-
-	kvm_mmu_hugepage_adjust(vcpu, fault);
-
-	trace_kvm_mmu_spte_requested(fault);
-
-	rcu_read_lock();
-	r = kvm_tdp_mmu_map(vcpu, fault);
-	rcu_read_unlock();
-
-out_unlock:
-	read_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
-	return r;
-}
-#endif
-
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	/*
@@ -4445,11 +4413,6 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		}
 	}
 
-#ifdef CONFIG_X86_64
-	if (tdp_mmu_enabled)
-		return kvm_tdp_mmu_page_fault(vcpu, fault);
-#endif
-
 	return direct_page_fault(vcpu, fault);
 }
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 66c294d67641..776b0ad4e58a 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -323,5 +323,13 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 
 void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
+void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
+
+static inline bool mmu_invalidate_retry_fault(struct kvm_vcpu *vcpu,
+					      struct kvm_page_fault *fault)
+{
+	return fault->slot &&
+	       mmu_invalidate_retry_hva(vcpu->kvm, fault->mmu_seq, fault->hva);
+}
 
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 78f47eb74544..d4736cb91c9f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1144,7 +1144,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
  * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
  * page tables and SPTEs to translate the faulting guest physical address.
  */
-int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+static int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	struct kvm *kvm = vcpu->kvm;
@@ -1212,6 +1212,33 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return RET_PF_RETRY;
 }
 
+int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+{
+	struct kvm_mmu_page *root = to_shadow_page(vcpu->arch.mmu->root.hpa);
+	int r = RET_PF_RETRY;
+
+	read_lock(&vcpu->kvm->mmu_lock);
+
+	if (root->role.invalid)
+		goto out;
+
+	if (mmu_invalidate_retry_fault(vcpu, fault))
+		goto out;
+
+	kvm_mmu_hugepage_adjust(vcpu, fault);
+
+	trace_kvm_mmu_spte_requested(fault);
+
+	rcu_read_lock();
+	r = kvm_tdp_mmu_map(vcpu, fault);
+	rcu_read_unlock();
+
+out:
+	read_unlock(&vcpu->kvm->mmu_lock);
+	kvm_release_pfn_clean(fault->pfn);
+	return r;
+}
+
 bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 				 bool flush)
 {
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 0a63b1afabd3..849e5886e73b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -27,7 +27,7 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm);
 
-int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
+int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 
 bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 				 bool flush);
