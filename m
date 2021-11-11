Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7BE44DBA1
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 19:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234200AbhKKSeT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 13:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232930AbhKKSeS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 13:34:18 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6BBC061767
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 10:31:28 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id q17so6382109plr.11
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 10:31:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=s8jf/tX5jyrIo31YjXHUFlHnOpiUaJPDt9RQiWaokMM=;
        b=Z+KAKlex/6ZhLa9BoSJPqzXvqRiKe7hN+fDeZZ1JVshM75MPHZ8jSb7OB5bSHGPkuV
         RVt0kNhVio7qz+MvilBmIPLG4YggyRiMOft8PE9P/yTsRy3U93NTC5RdfTzjC4VR2S0F
         OXzyxt9W42nM3znUclcO+YS4law6AZtwSapHbvfQ0MXfSiU72Ac4csNy/RCIUFxePzB7
         8rDk4j2mzuez+d5OVYZcSh1Ok9Tsfq+yQGqhYXQUyOXNwn6TYfphATOdtxgE1XsR6DNJ
         k4TeKJpgmpHH2ZIdl+DezIAzuxE0aNz9Y1hbAir10vnMsCKyYbYh/j/bsLSS+E6X49R1
         lF+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=s8jf/tX5jyrIo31YjXHUFlHnOpiUaJPDt9RQiWaokMM=;
        b=g0q9+VvqA/AiJ3IvjvLeLcEiS3C71Ll+RilvAur7BUw7lDxFBOG+wkl6GrqTXieIzO
         pHYL/RShcC59UZxh8AmB+4/EIUg+5o9bY2mhxxMHDSG1PEqN59MPhPTqOyjyxkGb/Dba
         9KQKcVn9MAIKswqIqZuxMgveiRGa4SvdkzzQVoEHdf8cETwjAOyUfgLfIFH+nr9d2qvl
         F1FIuFywepjbOsrzDHAb+81WnSpS7iRvjrpELvPBP9Okw3DL/0/YnF9bsxxcMolQOIOf
         yl9Jc4dy4oXJQ1LDNmw+w0RU3Yuq9HcP1jOiabUrtp6vblYUVFkxO4ZzNg1NbolS4GVM
         i0mQ==
X-Gm-Message-State: AOAM530iFaPqNTzyQW1jWbbPLR/Ho+jIK42lEmxUAIrLJh11X+o1LraJ
        4w4MmrJmCig/LzoGFawuPcZ8Kg==
X-Google-Smtp-Source: ABdhPJw5atYngTb3DppEu5M72mop+gP4FS1YgwLKHn3XrApXI6KVOKiIGKphwWxkrAl24185f0809A==
X-Received: by 2002:a17:90b:218:: with SMTP id fy24mr29047971pjb.187.1636655488268;
        Thu, 11 Nov 2021 10:31:28 -0800 (PST)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id h4sm9317189pjm.14.2021.11.11.10.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 10:31:27 -0800 (PST)
Date:   Thu, 11 Nov 2021 18:31:23 +0000
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
Subject: Re: [RFC 03/19] KVM: x86/mmu: Factor flush and free up when zapping
 under MMU write lock
Message-ID: <YY1he0lCLRNUofuw@google.com>
References: <20211110223010.1392399-1-bgardon@google.com>
 <20211110223010.1392399-4-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110223010.1392399-4-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 10, 2021 at 02:29:54PM -0800, Ben Gardon wrote:
> When zapping a GFN range under the MMU write lock, there is no need to
> flush the TLBs for every zap. Instead, follow the lead of the Legacy MMU
> can collect disconnected sps to be freed after a flush at the end of
> the routine.
> 
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 28 +++++++++++++++++++---------
>  1 file changed, 19 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 5b31d046df78..a448f0f2d993 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -623,10 +623,9 @@ static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
>   */
>  static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
>  				      u64 new_spte, bool record_acc_track,
> -				      bool record_dirty_log)
> +				      bool record_dirty_log,
> +				      struct list_head *disconnected_sps)
>  {
> -	LIST_HEAD(disconnected_sps);
> -
>  	lockdep_assert_held_write(&kvm->mmu_lock);
>  
>  	/*
> @@ -641,7 +640,7 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
>  	WRITE_ONCE(*rcu_dereference(iter->sptep), new_spte);
>  
>  	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
> -			      new_spte, iter->level, false, &disconnected_sps);
> +			      new_spte, iter->level, false, disconnected_sps);
>  	if (record_acc_track)
>  		handle_changed_spte_acc_track(iter->old_spte, new_spte,
>  					      iter->level);
> @@ -649,28 +648,32 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
>  		handle_changed_spte_dirty_log(kvm, iter->as_id, iter->gfn,
>  					      iter->old_spte, new_spte,
>  					      iter->level);
> +}
>  
> -	handle_disconnected_sps(kvm, &disconnected_sps);
> +static inline void tdp_mmu_zap_spte(struct kvm *kvm, struct tdp_iter *iter,
> +				    struct list_head *disconnected_sps)
> +{
> +	__tdp_mmu_set_spte(kvm, iter, 0, true, true, disconnected_sps);
>  }
>  
>  static inline void tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
>  				    u64 new_spte)
>  {
> -	__tdp_mmu_set_spte(kvm, iter, new_spte, true, true);
> +	__tdp_mmu_set_spte(kvm, iter, new_spte, true, true, NULL);
>  }
>  
>  static inline void tdp_mmu_set_spte_no_acc_track(struct kvm *kvm,
>  						 struct tdp_iter *iter,
>  						 u64 new_spte)
>  {
> -	__tdp_mmu_set_spte(kvm, iter, new_spte, false, true);
> +	__tdp_mmu_set_spte(kvm, iter, new_spte, false, true, NULL);
>  }
>  
>  static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
>  						 struct tdp_iter *iter,
>  						 u64 new_spte)
>  {
> -	__tdp_mmu_set_spte(kvm, iter, new_spte, true, false);
> +	__tdp_mmu_set_spte(kvm, iter, new_spte, true, false, NULL);
>  }
>  
>  #define tdp_root_for_each_pte(_iter, _root, _start, _end) \
> @@ -757,6 +760,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>  	gfn_t max_gfn_host = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
>  	bool zap_all = (start == 0 && end >= max_gfn_host);
>  	struct tdp_iter iter;
> +	LIST_HEAD(disconnected_sps);
>  
>  	/*
>  	 * No need to try to step down in the iterator when zapping all SPTEs,
> @@ -799,7 +803,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>  			continue;
>  
>  		if (!shared) {
> -			tdp_mmu_set_spte(kvm, &iter, 0);
> +			tdp_mmu_zap_spte(kvm, &iter, &disconnected_sps);
>  			flush = true;
>  		} else if (!tdp_mmu_zap_spte_atomic(kvm, &iter)) {
>  			/*
> @@ -811,6 +815,12 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>  		}
>  	}
>  
> +	if (!list_empty(&disconnected_sps)) {
> +		kvm_flush_remote_tlbs(kvm);
> +		handle_disconnected_sps(kvm, &disconnected_sps);

It might be worth adding a comment that we purposely do not process
disconnected_sps during the cond resched earlier in the loop because it
is an expensive call and it itself needs to cond resched (next patch).

> +		flush = false;
> +	}
> +
>  	rcu_read_unlock();
>  	return flush;
>  }
> -- 
> 2.34.0.rc0.344.g81b53c2807-goog
> 
