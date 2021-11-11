Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B190044DBCA
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 19:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbhKKSxT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 13:53:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233245AbhKKSxS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 13:53:18 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09812C061766
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 10:50:29 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id b13so6518960plg.2
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 10:50:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rRVHCuHiuxKYNIqQo9pBKH0e3aaYrZJR7xHo+IO8Ccc=;
        b=NhRmv31zjnUd8uznaaqbrITyl6VRhNwqjKbWffpfyujtKjgaad4E9gvn1nbyQxONpS
         BGk78Xi+4ehMUTzl1fBblW1C5FTsqeAChXKxupkoZBo8m5WNDnM5DiRvO3e1S4WE1lYC
         VyDw0VMl5YCkv77GcJZV8AJUtuXfpVPdpGE6yN4RfgbK/ciD1UK7D4VoYD+RZfboIPxv
         x7x9Ihu5Awo8B6LnJ9BVW5pvhTbvpkgMzkQ1mUhQwt7SLmBGL71WGJdJRE3GD6G70E5N
         8N3VmoQbdERYW+XhPfoaHackMWF2Q+mC8JTJGtIdwvajLXloTF4d/gg2Voeu5IrZeaQU
         r8/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rRVHCuHiuxKYNIqQo9pBKH0e3aaYrZJR7xHo+IO8Ccc=;
        b=qNTwU7srdKyXvTGYTVB1GEu0O8usbkWidUYETr/amCxp/Bf2hLqdJVMyDmZXha1Krv
         D2g618PCFcKXH7U1MgCqbesIDmmXssTPTEZ5XrrIea+XQdG+7hDLIX4RQw0238gEDO3y
         HrfFnFG3PUtKuzZUJTTuTVyYG9R3cmZzxa75xB3VkcpZr45mtBVDflfwUhYHMuxtQGyW
         JM0ZXW6JlveVutakrMeRM884GDDgYgwJIrfFJnIC8wOMtkHzPUHDU7llkQZ8CP54TV7b
         TS1IpckefX/Kev88tph7AfVz7JvJCDSYohrutr2NTDrYrtGaZiXdwa50z+WpaLkZXh3N
         Njrw==
X-Gm-Message-State: AOAM531dEXVPMqpwx+BHmqDDgmRc+KM6aNcgrProEFjzkzwm6WHRk6bQ
        YNetm1tW2MuSX4+kdKDCHwnKpg==
X-Google-Smtp-Source: ABdhPJzZZiWTYiCSTtcvOq5/hfnPl//w7ttNemIYs8P8665MMNy+9wWvKRZPpzULktGfQPT2Wu1q/g==
X-Received: by 2002:a17:90b:1c81:: with SMTP id oo1mr10868087pjb.171.1636656628339;
        Thu, 11 Nov 2021 10:50:28 -0800 (PST)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id u19sm3604682pfl.185.2021.11.11.10.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 10:50:27 -0800 (PST)
Date:   Thu, 11 Nov 2021 18:50:24 +0000
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
Subject: Re: [RFC 04/19] KVM: x86/mmu: Yield while processing disconnected_sps
Message-ID: <YY1l8EMsQyTDAAkT@google.com>
References: <20211110223010.1392399-1-bgardon@google.com>
 <20211110223010.1392399-5-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110223010.1392399-5-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 10, 2021 at 02:29:55PM -0800, Ben Gardon wrote:
> When preparing to free disconnected SPs, the list can accumulate many
> entries; enough that it is likely necessary to yeild while queuing RCU
> callbacks to free the SPs.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index a448f0f2d993..c2a9f7acf8ef 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -513,7 +513,8 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>   * being removed from the paging structure and this function being called.
>   */
>  static void handle_disconnected_sps(struct kvm *kvm,
> -				    struct list_head *disconnected_sps)
> +				    struct list_head *disconnected_sps,
> +				    bool can_yield, bool shared)
>  {
>  	struct kvm_mmu_page *sp;
>  	struct kvm_mmu_page *next;
> @@ -521,6 +522,16 @@ static void handle_disconnected_sps(struct kvm *kvm,
>  	list_for_each_entry_safe(sp, next, disconnected_sps, link) {
>  		list_del(&sp->link);
>  		call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
> +
> +		if (can_yield &&
> +		    (need_resched() || rwlock_needbreak(&kvm->mmu_lock))) {
> +			rcu_read_unlock();
> +			if (shared)
> +				cond_resched_rwlock_read(&kvm->mmu_lock);
> +			else
> +				cond_resched_rwlock_write(&kvm->mmu_lock);
> +			rcu_read_lock();
> +		}

What about something like this to cut down on the duplicate code?

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c2a9f7acf8ef..2fd010f2421e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -508,6 +508,26 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
                                      new_spte, level);
 }

+static inline bool tdp_mmu_need_resched(struct kvm *kvm)
+{
+       return need_resched() || rwlock_needbreak(&kvm->mmu_lock);
+}
+
+static void tdp_mmu_cond_resched(struct kvm *kvm, bool shared, bool flush)
+{
+       rcu_read_unlock()
+
+       if (flush)
+               kvm_flush_remote_tlbs(kvm);
+
+       if (shared)
+               cond_resched_rwlock_read(&kvm->mmu_lock);
+       else
+               cond_resched_rwlock_write(&kvm->mmu_lock);
+
+       rcu_read_lock();
+}
+
 /*
  * The TLBs must be flushed between the pages linked from disconnected_sps
  * being removed from the paging structure and this function being called.
@@ -523,15 +543,8 @@ static void handle_disconnected_sps(struct kvm *kvm,
                list_del(&sp->link);
                call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);

-               if (can_yield &&
-                   (need_resched() || rwlock_needbreak(&kvm->mmu_lock))) {
-                       rcu_read_unlock();
-                       if (shared)
-                               cond_resched_rwlock_read(&kvm->mmu_lock);
-                       else
-                               cond_resched_rwlock_write(&kvm->mmu_lock);
-                       rcu_read_lock();
-               }
+               if (can_yield && tdp_mmu_need_resched(kvm))
+                       tdp_mmu_cond_resched(kvm, shared, false);
        }
 }

@@ -724,18 +737,8 @@ static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
        if (iter->next_last_level_gfn == iter->yielded_gfn)
                return false;

-       if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
-               rcu_read_unlock();
-
-               if (flush)
-                       kvm_flush_remote_tlbs(kvm);
-
-               if (shared)
-                       cond_resched_rwlock_read(&kvm->mmu_lock);
-               else
-                       cond_resched_rwlock_write(&kvm->mmu_lock);
-
-               rcu_read_lock();
+       if (tdp_mmu_need_resched(kvm)) {
+               tdp_mmu_cond_resched(kvm, shared, flush);

                WARN_ON(iter->gfn > iter->next_last_level_gfn);

>  	}
>  }
>  
> @@ -599,7 +610,7 @@ static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
>  	 */
>  	WRITE_ONCE(*rcu_dereference(iter->sptep), 0);
>  
> -	handle_disconnected_sps(kvm, &disconnected_sps);
> +	handle_disconnected_sps(kvm, &disconnected_sps, false, true);
>  
>  	return true;
>  }
> @@ -817,7 +828,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>  
>  	if (!list_empty(&disconnected_sps)) {
>  		kvm_flush_remote_tlbs(kvm);
> -		handle_disconnected_sps(kvm, &disconnected_sps);
> +		handle_disconnected_sps(kvm, &disconnected_sps,
> +					can_yield, shared);
>  		flush = false;
>  	}
>  
> -- 
> 2.34.0.rc0.344.g81b53c2807-goog
> 
