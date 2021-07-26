Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 207443D62FD
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 18:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238489AbhGZPnK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 11:43:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43795 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238473AbhGZPnJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Jul 2021 11:43:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627316617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9Nj+h4/4VsJBw8NoOPDhsktaJ3nLgphpInIGG3Nj7Jo=;
        b=c/BCdBImwKUqJVeSNIvmCFXWn0dlAUdFU+IiG7mECg9bwmh4DyCIinVdaZNUO/76+kJs3j
        5bZoBkzD/Ax46CA+l8Hl2OIiXqcf1IMXFIwLXP8r2CwHC8VjpgbBBRcNthk/oN4vKYe31X
        qVMTBQimk11nUSi7IuRr96+TneRvowg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-SXcOoPSKPgmWwiXABkYLow-1; Mon, 26 Jul 2021 12:23:35 -0400
X-MC-Unique: SXcOoPSKPgmWwiXABkYLow-1
Received: by mail-ej1-f71.google.com with SMTP id gg1-20020a170906e281b029053d0856c4cdso2233071ejb.15
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 09:23:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9Nj+h4/4VsJBw8NoOPDhsktaJ3nLgphpInIGG3Nj7Jo=;
        b=FkTghHHPHoKvytfi/WHwHOSbGOWrKK6ixpQD+/dMT0R774TMx1y3DSM44L8O00QDsS
         Mb67k5wagSaX0FKQPL8bjmwe9oOTw3H1bZFvXougcyuVjtV4Wz8Vz/wFpphs2UUss0Vs
         086jG7rF10u7WGvRJzkVzX1CVxHo9KJ6KvS7kFT0sFNcKn6PGWh5Ii+7QnuwJp6tX6QN
         5exIV51SXSp9XnfJpEx7LYT5Qh3dp3XYODsqxor0yzTNSOqxg3KSsc4QfOlJ+QD1gMp9
         HFNvJgUFU5bC/j1oo1g6Xh82wTG8Ix3i+0z8xyqjwiqhny2e/zRmqnTKuKIDlPjyPNhB
         OUEg==
X-Gm-Message-State: AOAM531MlL3CszQhzZ5PP4QHn+QZtucjj8xo3ebzfq396SrZYQy35mLD
        seYpHmUzuVvo/3yD5G7bEvMe3hoSmAYi5rmYfhBm0TfThAJKwRj4BBH/WLleWHuM2pRnds1i+kn
        HwejZRzOz5G0ffN6HKjBGAS153kutK5y9rlGrj41cr4NgwZCKXgOmAoLKY+O1J4AS
X-Received: by 2002:aa7:c804:: with SMTP id a4mr22440522edt.294.1627316613411;
        Mon, 26 Jul 2021 09:23:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzGHy5wxn/lgfV+65o0go+l6MLROW3yl2BxKDRa0/k6Z/lp5J3xhzAGjqYkm5ziouG1YVEHUg==
X-Received: by 2002:aa7:c804:: with SMTP id a4mr22440487edt.294.1627316613147;
        Mon, 26 Jul 2021 09:23:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id qo26sm53375ejb.65.2021.07.26.09.23.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 09:23:32 -0700 (PDT)
Subject: Re: [PATCH] KVM: const-ify all relevant uses of struct
 kvm_memory_slot
To:     Hamza Mahfooz <someguy@effective-light.com>,
        linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
References: <20210713023338.57108-1-someguy@effective-light.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3678a043-9a77-ccee-04f9-6cf4627c450d@redhat.com>
Date:   Mon, 26 Jul 2021 18:23:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210713023338.57108-1-someguy@effective-light.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/07/21 04:33, Hamza Mahfooz wrote:
> As alluded to in commit f36f3f2846b5 ("KVM: add "new" argument to
> kvm_arch_commit_memory_region"), a bunch of other places where struct
> kvm_memory_slot is used, needs to be refactored to preserve the
> "const"ness of struct kvm_memory_slot across-the-board.
> 
> Signed-off-by: Hamza Mahfooz <someguy@effective-light.com>

Queued, thanks.

Paolo

> ---
>   arch/x86/include/asm/kvm_host.h |  4 +--
>   arch/x86/kvm/mmu/mmu.c          | 58 ++++++++++++++++++---------------
>   arch/x86/kvm/mmu/mmu_internal.h |  4 +--
>   arch/x86/kvm/mmu/tdp_mmu.c      |  7 ++--
>   arch/x86/kvm/mmu/tdp_mmu.h      |  6 ++--
>   arch/x86/kvm/x86.c              |  7 ++--
>   6 files changed, 44 insertions(+), 42 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 974cbfb1eefe..a195e1c32018 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1536,12 +1536,12 @@ void kvm_mmu_uninit_vm(struct kvm *kvm);
>   void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu);
>   void kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
>   void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
> -				      struct kvm_memory_slot *memslot,
> +				      const struct kvm_memory_slot *memslot,
>   				      int start_level);
>   void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
>   				   const struct kvm_memory_slot *memslot);
>   void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
> -				   struct kvm_memory_slot *memslot);
> +				   const struct kvm_memory_slot *memslot);
>   void kvm_mmu_zap_all(struct kvm *kvm);
>   void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
>   unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 845d114ae075..39ee8df5cc1f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -784,7 +784,7 @@ static struct kvm_lpage_info *lpage_info_slot(gfn_t gfn,
>   	return &slot->arch.lpage_info[level - 2][idx];
>   }
>   
> -static void update_gfn_disallow_lpage_count(struct kvm_memory_slot *slot,
> +static void update_gfn_disallow_lpage_count(const struct kvm_memory_slot *slot,
>   					    gfn_t gfn, int count)
>   {
>   	struct kvm_lpage_info *linfo;
> @@ -797,12 +797,12 @@ static void update_gfn_disallow_lpage_count(struct kvm_memory_slot *slot,
>   	}
>   }
>   
> -void kvm_mmu_gfn_disallow_lpage(struct kvm_memory_slot *slot, gfn_t gfn)
> +void kvm_mmu_gfn_disallow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn)
>   {
>   	update_gfn_disallow_lpage_count(slot, gfn, 1);
>   }
>   
> -void kvm_mmu_gfn_allow_lpage(struct kvm_memory_slot *slot, gfn_t gfn)
> +void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn)
>   {
>   	update_gfn_disallow_lpage_count(slot, gfn, -1);
>   }
> @@ -989,7 +989,7 @@ static void pte_list_remove(struct kvm_rmap_head *rmap_head, u64 *sptep)
>   }
>   
>   static struct kvm_rmap_head *__gfn_to_rmap(gfn_t gfn, int level,
> -					   struct kvm_memory_slot *slot)
> +					   const struct kvm_memory_slot *slot)
>   {
>   	unsigned long idx;
>   
> @@ -1216,7 +1216,7 @@ static bool spte_wrprot_for_clear_dirty(u64 *sptep)
>    * Returns true iff any D or W bits were cleared.
>    */
>   static bool __rmap_clear_dirty(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
> -			       struct kvm_memory_slot *slot)
> +			       const struct kvm_memory_slot *slot)
>   {
>   	u64 *sptep;
>   	struct rmap_iterator iter;
> @@ -1375,7 +1375,7 @@ static bool rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
>   }
>   
>   static bool kvm_zap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
> -			  struct kvm_memory_slot *slot)
> +			  const struct kvm_memory_slot *slot)
>   {
>   	u64 *sptep;
>   	struct rmap_iterator iter;
> @@ -1440,7 +1440,7 @@ static bool kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
>   
>   struct slot_rmap_walk_iterator {
>   	/* input fields. */
> -	struct kvm_memory_slot *slot;
> +	const struct kvm_memory_slot *slot;
>   	gfn_t start_gfn;
>   	gfn_t end_gfn;
>   	int start_level;
> @@ -1467,16 +1467,20 @@ rmap_walk_init_level(struct slot_rmap_walk_iterator *iterator, int level)
>   
>   static void
>   slot_rmap_walk_init(struct slot_rmap_walk_iterator *iterator,
> -		    struct kvm_memory_slot *slot, int start_level,
> +		    const struct kvm_memory_slot *slot, int start_level,
>   		    int end_level, gfn_t start_gfn, gfn_t end_gfn)
>   {
> -	iterator->slot = slot;
> -	iterator->start_level = start_level;
> -	iterator->end_level = end_level;
> -	iterator->start_gfn = start_gfn;
> -	iterator->end_gfn = end_gfn;
> +	struct slot_rmap_walk_iterator iter = {
> +		.slot = slot,
> +		.start_gfn = start_gfn,
> +		.end_gfn = end_gfn,
> +		.start_level = start_level,
> +		.end_level = end_level,
> +	};
> +
> +	rmap_walk_init_level(&iter, iterator->start_level);
>   
> -	rmap_walk_init_level(iterator, iterator->start_level);
> +	memcpy(iterator, &iter, sizeof(struct slot_rmap_walk_iterator));
>   }
>   
>   static bool slot_rmap_walk_okay(struct slot_rmap_walk_iterator *iterator)
> @@ -5274,12 +5278,13 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_max_root_level,
>   EXPORT_SYMBOL_GPL(kvm_configure_mmu);
>   
>   /* The return value indicates if tlb flush on all vcpus is needed. */
> -typedef bool (*slot_level_handler) (struct kvm *kvm, struct kvm_rmap_head *rmap_head,
> -				    struct kvm_memory_slot *slot);
> +typedef bool (*slot_level_handler) (struct kvm *kvm,
> +				    struct kvm_rmap_head *rmap_head,
> +				    const struct kvm_memory_slot *slot);
>   
>   /* The caller should hold mmu-lock before calling this function. */
>   static __always_inline bool
> -slot_handle_level_range(struct kvm *kvm, struct kvm_memory_slot *memslot,
> +slot_handle_level_range(struct kvm *kvm, const struct kvm_memory_slot *memslot,
>   			slot_level_handler fn, int start_level, int end_level,
>   			gfn_t start_gfn, gfn_t end_gfn, bool flush_on_yield,
>   			bool flush)
> @@ -5306,7 +5311,7 @@ slot_handle_level_range(struct kvm *kvm, struct kvm_memory_slot *memslot,
>   }
>   
>   static __always_inline bool
> -slot_handle_level(struct kvm *kvm, struct kvm_memory_slot *memslot,
> +slot_handle_level(struct kvm *kvm, const struct kvm_memory_slot *memslot,
>   		  slot_level_handler fn, int start_level, int end_level,
>   		  bool flush_on_yield)
>   {
> @@ -5317,7 +5322,7 @@ slot_handle_level(struct kvm *kvm, struct kvm_memory_slot *memslot,
>   }
>   
>   static __always_inline bool
> -slot_handle_leaf(struct kvm *kvm, struct kvm_memory_slot *memslot,
> +slot_handle_leaf(struct kvm *kvm, const struct kvm_memory_slot *memslot,
>   		 slot_level_handler fn, bool flush_on_yield)
>   {
>   	return slot_handle_level(kvm, memslot, fn, PG_LEVEL_4K,
> @@ -5576,7 +5581,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
>   				if (start >= end)
>   					continue;
>   
> -				flush = slot_handle_level_range(kvm, memslot,
> +				flush = slot_handle_level_range(kvm,
> +						(const struct kvm_memory_slot *) memslot,
>   						kvm_zap_rmapp, PG_LEVEL_4K,
>   						KVM_MAX_HUGEPAGE_LEVEL, start,
>   						end - 1, true, flush);
> @@ -5604,13 +5610,13 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
>   
>   static bool slot_rmap_write_protect(struct kvm *kvm,
>   				    struct kvm_rmap_head *rmap_head,
> -				    struct kvm_memory_slot *slot)
> +				    const struct kvm_memory_slot *slot)
>   {
>   	return __rmap_write_protect(kvm, rmap_head, false);
>   }
>   
>   void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
> -				      struct kvm_memory_slot *memslot,
> +				      const struct kvm_memory_slot *memslot,
>   				      int start_level)
>   {
>   	bool flush = false;
> @@ -5646,7 +5652,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
>   
>   static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
>   					 struct kvm_rmap_head *rmap_head,
> -					 struct kvm_memory_slot *slot)
> +					 const struct kvm_memory_slot *slot)
>   {
>   	u64 *sptep;
>   	struct rmap_iterator iter;
> @@ -5685,10 +5691,8 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
>   }
>   
>   void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
> -				   const struct kvm_memory_slot *memslot)
> +				   const struct kvm_memory_slot *slot)
>   {
> -	/* FIXME: const-ify all uses of struct kvm_memory_slot.  */
> -	struct kvm_memory_slot *slot = (struct kvm_memory_slot *)memslot;
>   	bool flush = false;
>   
>   	if (kvm_memslots_have_rmaps(kvm)) {
> @@ -5724,7 +5728,7 @@ void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
>   }
>   
>   void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
> -				   struct kvm_memory_slot *memslot)
> +				   const struct kvm_memory_slot *memslot)
>   {
>   	bool flush = false;
>   
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 35567293c1fd..ee4ad9c99219 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -124,8 +124,8 @@ static inline bool is_nx_huge_page_enabled(void)
>   
>   int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync);
>   
> -void kvm_mmu_gfn_disallow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
> -void kvm_mmu_gfn_allow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
> +void kvm_mmu_gfn_disallow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
> +void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
>   bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
>   				    struct kvm_memory_slot *slot, u64 gfn,
>   				    int min_level);
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 0853370bd811..5d8d69d56a81 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1242,8 +1242,8 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>    * only affect leaf SPTEs down to min_level.
>    * Returns true if an SPTE has been changed and the TLBs need to be flushed.
>    */
> -bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
> -			     int min_level)
> +bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
> +			     const struct kvm_memory_slot *slot, int min_level)
>   {
>   	struct kvm_mmu_page *root;
>   	bool spte_set = false;
> @@ -1313,7 +1313,8 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>    * each SPTE. Returns true if an SPTE has been changed and the TLBs need to
>    * be flushed.
>    */
> -bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
> +bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm,
> +				  const struct kvm_memory_slot *slot)
>   {
>   	struct kvm_mmu_page *root;
>   	bool spte_set = false;
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 1cae4485b3bc..49437dbb4804 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -61,10 +61,10 @@ bool kvm_tdp_mmu_age_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
>   bool kvm_tdp_mmu_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
>   bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
>   
> -bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
> -			     int min_level);
> +bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
> +			     const struct kvm_memory_slot *slot, int min_level);
>   bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm,
> -				  struct kvm_memory_slot *slot);
> +				  const struct kvm_memory_slot *slot);
>   void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
>   				       struct kvm_memory_slot *slot,
>   				       gfn_t gfn, unsigned long mask,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c6dc1b445231..970e95110175 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11473,7 +11473,7 @@ static void kvm_mmu_update_cpu_dirty_logging(struct kvm *kvm, bool enable)
>   
>   static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
>   				     struct kvm_memory_slot *old,
> -				     struct kvm_memory_slot *new,
> +				     const struct kvm_memory_slot *new,
>   				     enum kvm_mr_change change)
>   {
>   	bool log_dirty_pages = new->flags & KVM_MEM_LOG_DIRTY_PAGES;
> @@ -11553,10 +11553,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>   		kvm_mmu_change_mmu_pages(kvm,
>   				kvm_mmu_calculate_default_mmu_pages(kvm));
>   
> -	/*
> -	 * FIXME: const-ify all uses of struct kvm_memory_slot.
> -	 */
> -	kvm_mmu_slot_apply_flags(kvm, old, (struct kvm_memory_slot *) new, change);
> +	kvm_mmu_slot_apply_flags(kvm, old, new, change);
>   
>   	/* Free the arrays associated with the old memslot. */
>   	if (change == KVM_MR_MOVE)
> 

