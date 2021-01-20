Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359F22FDD8B
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 01:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbhATX6L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 18:58:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731377AbhATWUU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 17:20:20 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81CAC0613D3
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 14:19:40 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id f63so31902pfa.13
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 14:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7SSM+LDk3KsJhutBMI6Undq7waWSYyBbrLplHXEtdTk=;
        b=RVsjpyJV0u2hR/S/oAcXGZp4k1omDNlEY1uU7tBx+hk4GlSWBkYwFErbhcojZzcI0V
         nvA7eh41lK27EFaqQD6AAk6b42Li2SEhKdGTAef8XpaKBebAhPzN8jha+AO0ZMFclKAx
         OiVAei6pKRcrjm37j1UvK86uGArYbfh91b+9n2HmC26P6fD6XBd2ps4pmUd1/CpMIErN
         drRlcxtsuU3HmUHe+T+ozAfxg3snIygoIOWtSj/+siEQVhEixFZnN8ojFVNmr23gg+ge
         8hy6gk6mNt0zBQhhIW/a4nJOxlOoA6Id+dwdMp9K4uyBAxoL5uvZgjtqXS6bJ/RlUHc3
         iD+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7SSM+LDk3KsJhutBMI6Undq7waWSYyBbrLplHXEtdTk=;
        b=jqFoExorVwe2uPajRYjos5ZELM+GGCziDvMh9crOAI68Dt4D9u/ZX4r5GJTDjdN16C
         rw+HTRxJ8PClZrsMnpsK4DXFbyaXt+pCKWp7AqEbCvpASj+h2K6SJjFEQCnYL0SPcvlR
         tRgrg9GKcxRpEnhH3Tcy/UlaYDViP+dZ1uxSA92A328Rc/0MwRw5zF0QwNRjkJMwK2Do
         2ZwxSCvOJlAvYo+iYDGHAOegvs7nSWxX1flq7OsrAxCXHbDeSQ5P4ZGDiAKUssZuelf+
         ZQPJaWQlw5coFPlF7GC31fCowIBlvJFdFmPawsS6YuDsI4HQYpzeFhjwteJ8fr6FKjF9
         iTHA==
X-Gm-Message-State: AOAM532WvkiEW9dmYqZE7jZgqv7kLOduh59L16MtBa2pc8HAIecRj8PD
        ABFVR7wYnB6gcKMlSmF5WaB0QA==
X-Google-Smtp-Source: ABdhPJwRQgonG0kdWJOrvYGWjb1G6FWjLXO4begKqeLUcHBtEPc+6DkW49nJROUlmKp5OB1sFxayVg==
X-Received: by 2002:a63:1047:: with SMTP id 7mr11624563pgq.292.1611181179930;
        Wed, 20 Jan 2021 14:19:39 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id o7sm3683714pfp.144.2021.01.20.14.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 14:19:39 -0800 (PST)
Date:   Wed, 20 Jan 2021 14:19:32 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH 11/24] kvm: x86/mmu: Put TDP MMU PT walks in RCU
 read-critical section
Message-ID: <YAisdPTXGDqzil5G@google.com>
References: <20210112181041.356734-1-bgardon@google.com>
 <20210112181041.356734-12-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112181041.356734-12-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021, Ben Gardon wrote:                                         
> In order to enable concurrent modifications to the paging structures in       
> the TDP MMU, threads must be able to safely remove pages of page table        
> memory while other threads are traversing the same memory. To ensure          
> threads do not access PT memory after it is freed, protect PT memory          
> with RCU.                                                                     
                                                                                
Normally I like splitting up patches, but the three RCU patches (11-13) probably
need to be combined into a single patch.  I assume you introduced the RCU       
readers in a separate patch to isolate deadlocks, but it's impossible to give   
this patch a proper review without peeking ahead to see how what's actually     
being protected with RCU.                                                       
                                                                                
The combined changelog should also explain why READING_SHADOW_PAGE_TABLES isn't 
a good solution.  I suspect the answer is because the longer-running walks would
disable IRQs for too long, but that should be explicitly documented.

> Reviewed-by: Peter Feiner <pfeiner@google.com>                                
>                                                                               
> Signed-off-by: Ben Gardon <bgardon@google.com>                                
> ---                                                                           
>  arch/x86/kvm/mmu/tdp_mmu.c | 53 ++++++++++++++++++++++++++++++++++++--       
>  1 file changed, 51 insertions(+), 2 deletions(-)                             
>                                                                               
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c          
> index e8f35cd46b4c..662907d374b3 100644                                       
> --- a/arch/x86/kvm/mmu/tdp_mmu.c                                              
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c                                              
> @@ -458,11 +458,14 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
>   * Return true if this function yielded, the TLBs were flushed, and the      
>   * iterator's traversal was reset. Return false if a yield was not needed.   
>   */                                                                          
> -static bool tdp_mmu_iter_flush_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
> +static bool tdp_mmu_iter_flush_cond_resched(struct kvm *kvm,                 
> +             struct tdp_iter *iter)                                          
                                                                                
Unrelated newline.                                                              
                                                                                
>  {                                                                            
>       if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {                 
>               kvm_flush_remote_tlbs(kvm);                                     
> +             rcu_read_unlock();                                              
                                                                                
I'm 99% certain rcu_read_unlock() can be moved before the TLB flush.  IIUC, RCU 
is protecting only the host kernel's software walks; the only true "writer" is  
immediately preceded by a remote TLB flush (in patch 13).                       
                                                                                
        kvm_flush_remote_tlbs_with_address(kvm, gfn,                            
                                           KVM_PAGES_PER_HPAGE(level));         
                                                                                
        call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);                  
                                                                                
That also resolves an inconsistency with zap_gfn_range(), which unlocks before
doing the remote flush.  Ditto for zap_collapsible_spte_range(), and I think a
few other flows.

>  		cond_resched_lock(&kvm->mmu_lock);
> +		rcu_read_lock();
>  		tdp_iter_refresh_walk(iter);
>  		return true;
>  	} else
> @@ -483,7 +486,9 @@ static bool tdp_mmu_iter_flush_cond_resched(struct kvm *kvm, struct tdp_iter *it
>  static bool tdp_mmu_iter_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
>  {
>  	if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
> +		rcu_read_unlock();
>  		cond_resched_lock(&kvm->mmu_lock);
> +		rcu_read_lock();
>  		tdp_iter_refresh_walk(iter);
>  		return true;
>  	} else
> @@ -508,6 +513,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>  	gfn_t last_goal_gfn = start;
>  	bool flush_needed = false;
>  
> +	rcu_read_lock();
> +
>  	tdp_root_for_each_pte(iter, root, start, end) {
>  		/* Ensure forward progress has been made before yielding. */
>  		if (can_yield && iter.goal_gfn != last_goal_gfn &&
> @@ -538,6 +545,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>  		tdp_mmu_set_spte(kvm, &iter, 0);
>  		flush_needed = true;
>  	}
> +
> +	rcu_read_unlock();

Unlock before TLB flush.  <-------

>  	return flush_needed;
>  }

...

> @@ -844,6 +863,8 @@ static int set_tdp_spte(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	u64 new_spte;
>  	int need_flush = 0;
>  
> +	rcu_read_lock();
> +
>  	WARN_ON(pte_huge(*ptep));
>  
>  	new_pfn = pte_pfn(*ptep);
> @@ -872,6 +893,8 @@ static int set_tdp_spte(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	if (need_flush)
>  		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
>  
> +	rcu_read_unlock();

Unlock before flush?

> +
>  	return 0;
>  }
>  
  
...

> @@ -1277,10 +1322,14 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
>  
>  	*root_level = vcpu->arch.mmu->shadow_root_level;
>  
> +	rcu_read_lock();

Hrm, isn't this an existing bug?  And also not really the correct fix?  mmu_lock
is not held here, so the existing code has no protections.  Using
walk_shadow_page_lockless_begin/end() feels more appropriate for this particular
walk.

> +
>  	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
>  		leaf = iter.level;
>  		sptes[leaf] = iter.old_spte;
>  	}
>  
> +	rcu_read_unlock();
> +
>  	return leaf;
>  }
> -- 
> 2.30.0.284.gd98b1dd5eaa7-goog
> 
