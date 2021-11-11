Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A2244DBDE
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 19:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233787AbhKKS6a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 13:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbhKKS63 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 13:58:29 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AEA6C061767
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 10:55:39 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id iq11so4814960pjb.3
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 10:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=12MtUlbQdepDpUV3kFaUinhbWMXccNrtzKgAR8eQc3Q=;
        b=DCFxnm1m6X7yGZLvrujfKshGA+cjWQWIEOcSkLyBJfMnVyYhWj6y6r70Oh0Kzpu7Xo
         i/ruyxTMUqtI4P521ipk4RVvaUt0z9h2NP1z/Mz2OviQJdVYjmFqx4i/EYFwNeLtcjhu
         mCZp+syBM3LilWT/M0SLIYd4Wi1M+m5NmDIGNKGd4IRhFxAA0BdDzsaKo/KsFNoxv4MD
         AYikO5KMycXvAbktH54atiCiZxnRC9LlvvZrR5VB6ZGCRmJM1ApPIw0tZgvI5UMonC9V
         c/kz9kEVIJTQXhpxAyc1SpTBb7w8vD/YpNq++W6BSK2Hjws3L5Yg6IiN0Rfsa4SJzchL
         d+Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=12MtUlbQdepDpUV3kFaUinhbWMXccNrtzKgAR8eQc3Q=;
        b=w/lhLS1GBYGtGwlsnKVNsXuYdChae0q4sZ1QDCdlY7wkbh/2U7kfclCco1peafzKN+
         DeNkfdfiVYLs6y0ehRY6cPKcylysAO9vcpwx0i4HYE8JfODozVg/RpAC24wKfxr4Gkck
         UBmdDy/EFAPIR6bMMAU2pMHsewS7r8J3SSt0FYu9DfeQFACZR3h/Afuw6VV7ieJn1uAU
         qw/xEirNAU2L/Ktmi0X9uwhESeOdhfsfRCHC0FPW2OQ0in1E9SCyXc2wcr31Za1OBXLN
         pLARxb9h+OZD0zInM6xVDldoA/7UPHVnZ+2bXhiEBcvGxrnvpUHwrcDEaWIrv00uIqfH
         7NBw==
X-Gm-Message-State: AOAM530IcSklod0eIxHc+g+CKxwPJF0P76wtpzbjGqlt0QI2BranIC9G
        /vH9GjMpxoRmYXpB6AynBK/dng==
X-Google-Smtp-Source: ABdhPJwVx2m1ZhHyCYVLsPX+pFpoC0J7UXUUsQlyAe8U+uJX7XaxDxQvgtGeq8p5JAg9MxCyNd0m/g==
X-Received: by 2002:a17:90b:1bc4:: with SMTP id oa4mr29339574pjb.179.1636656938572;
        Thu, 11 Nov 2021 10:55:38 -0800 (PST)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id d9sm2965107pgd.40.2021.11.11.10.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 10:55:37 -0800 (PST)
Date:   Thu, 11 Nov 2021 18:55:34 +0000
From:   David Matlack <dmatlack@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [RFC 05/19] KVM: x86/mmu: Remove redundant flushes when
 disabling dirty logging
Message-ID: <YY1nJqWpA0KeP2JB@google.com>
References: <20211110223010.1392399-1-bgardon@google.com>
 <20211110223010.1392399-6-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110223010.1392399-6-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 10, 2021 at 02:29:56PM -0800, Ben Gardon wrote:
> tdp_mmu_zap_spte_atomic flushes on every zap already, so no need to
> flush again after it's done.
> 
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/x86/kvm/mmu/mmu.c     |  4 +---
>  arch/x86/kvm/mmu/tdp_mmu.c | 21 ++++++---------------
>  arch/x86/kvm/mmu/tdp_mmu.h |  5 ++---
>  3 files changed, 9 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 354d2ca92df4..baa94acab516 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5870,9 +5870,7 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
>  
>  	if (is_tdp_mmu_enabled(kvm)) {
>  		read_lock(&kvm->mmu_lock);
> -		flush = kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot, flush);
> -		if (flush)
> -			kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> +		kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot);
>  		read_unlock(&kvm->mmu_lock);
>  	}
>  }
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index c2a9f7acf8ef..1ece645e737f 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1438,10 +1438,9 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
>   * Clear leaf entries which could be replaced by large mappings, for
>   * GFNs within the slot.
>   */
> -static bool zap_collapsible_spte_range(struct kvm *kvm,
> +static void zap_collapsible_spte_range(struct kvm *kvm,
>  				       struct kvm_mmu_page *root,
> -				       const struct kvm_memory_slot *slot,
> -				       bool flush)
> +				       const struct kvm_memory_slot *slot)
>  {
>  	gfn_t start = slot->base_gfn;
>  	gfn_t end = start + slot->npages;
> @@ -1452,10 +1451,8 @@ static bool zap_collapsible_spte_range(struct kvm *kvm,
>  
>  	tdp_root_for_each_pte(iter, root, start, end) {
>  retry:
> -		if (tdp_mmu_iter_cond_resched(kvm, &iter, flush, true)) {
> -			flush = false;
> +		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
>  			continue;
> -		}
>  
>  		if (!is_shadow_present_pte(iter.old_spte) ||
>  		    !is_last_spte(iter.old_spte, iter.level))
> @@ -1475,30 +1472,24 @@ static bool zap_collapsible_spte_range(struct kvm *kvm,
>  			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
>  			goto retry;
>  		}
> -		flush = true;
>  	}
>  
>  	rcu_read_unlock();
> -
> -	return flush;
>  }
>  
>  /*
>   * Clear non-leaf entries (and free associated page tables) which could
>   * be replaced by large mappings, for GFNs within the slot.
>   */
> -bool kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
> -				       const struct kvm_memory_slot *slot,
> -				       bool flush)
> +void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
> +				       const struct kvm_memory_slot *slot)
>  {
>  	struct kvm_mmu_page *root;
>  
>  	lockdep_assert_held_read(&kvm->mmu_lock);
>  
>  	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
> -		flush = zap_collapsible_spte_range(kvm, root, slot, flush);
> -
> -	return flush;
> +		zap_collapsible_spte_range(kvm, root, slot);
>  }
>  
>  /*
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 476b133544dd..3899004a5d91 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -64,9 +64,8 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
>  				       struct kvm_memory_slot *slot,
>  				       gfn_t gfn, unsigned long mask,
>  				       bool wrprot);
> -bool kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
> -				       const struct kvm_memory_slot *slot,
> -				       bool flush);
> +void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
> +				       const struct kvm_memory_slot *slot);
>  
>  bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
>  				   struct kvm_memory_slot *slot, gfn_t gfn,
> -- 
> 2.34.0.rc0.344.g81b53c2807-goog
> 
