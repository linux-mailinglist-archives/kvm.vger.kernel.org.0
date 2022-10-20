Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02FAE606AF1
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 00:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiJTWDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 18:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiJTWDY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 18:03:24 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023D2226E49
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 15:03:23 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id a6-20020a17090abe0600b0020d7c0c6650so4869059pjs.0
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 15:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S1VD5C+pAgvew+V4xoo1uUoaM3ZMiEwvUilJ3S/jYtQ=;
        b=IK87+moPvFtmGU5qN/L/sVsaLQuL2Kgl8JKr6y9wROs1N1A2EOxXsEBi4OpVrlhuaA
         +P4Av/p/ArpdHupvBIshtM8X60pz0b2Dax7XHVHdrky/m6g3BRKlB9bhKaCAQ4LJVS2/
         xz5CY0ji/JS7OkG/9FHTMp/pzpAoZGGHuaG5kEiWgpBzKLu3sfB0NoDzAuVvKK7jiftn
         ohHEdmxghMCy66c8HoCSiahSfxdlACMGl5UyTDgHdF+/Nsr2ZB5njMntsFTCUr1r9u36
         +VdF+NahOO2IepLt5pe2re2VXxY4jNUpGSpHww5RX2f+vnYQC8hCBfKL9O540nd7uQpN
         R6Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S1VD5C+pAgvew+V4xoo1uUoaM3ZMiEwvUilJ3S/jYtQ=;
        b=NA3zAnOsu8K+6+G7sNwGIe/OiGRmK/vIONrN3HEKNU3MRCG1RZuAQQo2MLl455gukt
         CKKQ166qdr6VvuHGxuJFXYGrevnCAjuyGfI7UxZqNmF9/BIeNgqgxvQ4Ij/+TI8qNm9p
         WSDpprSrEZmTKjm2ZQHkLJDeNa8h+4ZVci3/O6DUXzSNLRncEPkdoI1z7shbDWedfZWR
         img0ZQgyOMbX9GPjvso7gwjpKZx03OOmBbp0mO9pmZdEJq+TKaCgEf7jK1QnFApmO8W1
         rdNDqVHujGvdr7gYxJ0lRsYEhiHDWYLgR//Di3pM8NTm8lVOJlNGBrQnQfcncJojHFPL
         3dFQ==
X-Gm-Message-State: ACrzQf1EiiKXmE3u/YNPqg/k7lvHWjekdTLOrpGP7Qw/baDJ9bO/DjXg
        6PtykL5suJKcni4GCpaLmllpegujNjPWOg==
X-Google-Smtp-Source: AMsMyM6hcDMwpLpfdl0Uup5Y0ftIO7MoF5BPzjpLCOs8Dj09s3x90YJ41cFsobBZEHmTvog+XgkMow==
X-Received: by 2002:a17:90b:17c9:b0:20d:b4ee:aec2 with SMTP id me9-20020a17090b17c900b0020db4eeaec2mr43764464pjb.234.1666303402230;
        Thu, 20 Oct 2022 15:03:22 -0700 (PDT)
Received: from google.com (33.5.83.34.bc.googleusercontent.com. [34.83.5.33])
        by smtp.gmail.com with ESMTPSA id w67-20020a626246000000b005623df48a39sm14178897pfb.13.2022.10.20.15.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 15:03:21 -0700 (PDT)
Date:   Thu, 20 Oct 2022 22:03:17 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] KVM: x86/mmu: Split huge pages mapped by the TDP
 MMU on fault
Message-ID: <Y1HFpTl+bZBFHaCQ@google.com>
References: <20221019234050.3919566-1-dmatlack@google.com>
 <20221019234050.3919566-3-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019234050.3919566-3-dmatlack@google.com>
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

On Wed, Oct 19, 2022, David Matlack wrote:
> Now that the TDP MMU has a mechanism to split huge pages, use it in the
> fault path when a huge page needs to be replaced with a mapping at a
> lower level.
> 
> This change reduces the negative performance impact of NX HugePages.
> Prior to this change if a vCPU executed from a huge page and NX
> HugePages was enabled, the vCPU would take a fault, zap the huge page,
> and mapping the faulting address at 4KiB with execute permissions
> enabled. The rest of the memory would be left *unmapped* and have to be
> faulted back in by the guest upon access (read, write, or execute). If
> guest is backed by 1GiB, a single execute instruction can zap an entire
> GiB of its physical address space.
> 
> For example, it can take a VM longer to execute from its memory than to
> populate that memory in the first place:
> 
> $ ./execute_perf_test -s anonymous_hugetlb_1gb -v96
> 
> Populating memory             : 2.748378795s
> Executing from memory         : 2.899670885s
> 
> With this change, such faults split the huge page instead of zapping it,
> which avoids the non-present faults on the rest of the huge page:
> 
> $ ./execute_perf_test -s anonymous_hugetlb_1gb -v96
> 
> Populating memory             : 2.729544474s
> Executing from memory         : 0.111965688s   <---
> 
> This change also reduces the performance impact of dirty logging when
> eager_page_split=N. eager_page_split=N (abbreviated "eps=N" below) can
> be desirable for read-heavy workloads, as it avoids allocating memory to
> split huge pages that are never written and avoids increasing the TLB
> miss cost on reads of those pages.
> 
>              | Config: ept=Y, tdp_mmu=Y, 5% writes           |
>              | Iteration 1 dirty memory time                 |
>              | --------------------------------------------- |
> vCPU Count   | eps=N (Before) | eps=N (After) | eps=Y        |
> ------------ | -------------- | ------------- | ------------ |
> 2            | 0.332305091s   | 0.019615027s  | 0.006108211s |
> 4            | 0.353096020s   | 0.019452131s  | 0.006214670s |
> 8            | 0.453938562s   | 0.019748246s  | 0.006610997s |
> 16           | 0.719095024s   | 0.019972171s  | 0.007757889s |
> 32           | 1.698727124s   | 0.021361615s  | 0.012274432s |
> 64           | 2.630673582s   | 0.031122014s  | 0.016994683s |
> 96           | 3.016535213s   | 0.062608739s  | 0.044760838s |
> 
> Eager page splitting remains beneficial for write-heavy workloads, but
> the gap is now reduced.
> 
>              | Config: ept=Y, tdp_mmu=Y, 100% writes         |
>              | Iteration 1 dirty memory time                 |
>              | --------------------------------------------- |
> vCPU Count   | eps=N (Before) | eps=N (After) | eps=Y        |
> ------------ | -------------- | ------------- | ------------ |
> 2            | 0.317710329s   | 0.296204596s  | 0.058689782s |
> 4            | 0.337102375s   | 0.299841017s  | 0.060343076s |
> 8            | 0.386025681s   | 0.297274460s  | 0.060399702s |
> 16           | 0.791462524s   | 0.298942578s  | 0.062508699s |
> 32           | 1.719646014s   | 0.313101996s  | 0.075984855s |
> 64           | 2.527973150s   | 0.455779206s  | 0.079789363s |
> 96           | 2.681123208s   | 0.673778787s  | 0.165386739s |
> 
> Further study is needed to determine if the remaining gap is acceptable
> for customer workloads or if eager_page_split=N still requires a-priori
> knowledge of the VM workload, especially when considering these costs
> extrapolated out to large VMs with e.g. 416 vCPUs and 12TB RAM.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 72 ++++++++++++++++++--------------------
>  1 file changed, 34 insertions(+), 38 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 4e5b3ae824c1..c53767104d5b 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1146,6 +1146,9 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
>  	return 0;
>  }
>  
> +static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
> +				   struct kvm_mmu_page *sp, bool shared);
> +
>  /*
>   * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
>   * page tables and SPTEs to translate the faulting guest physical address.
> @@ -1171,49 +1174,42 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  		if (iter.level == fault->goal_level)
>  			break;
>  
> -		/*
> -		 * If there is an SPTE mapping a large page at a higher level
> -		 * than the target, that SPTE must be cleared and replaced
> -		 * with a non-leaf SPTE.
> -		 */
> +		/* Step down into the lower level page table if it exists. */
>  		if (is_shadow_present_pte(iter.old_spte) &&
> -		    is_large_pte(iter.old_spte)) {
> -			if (tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter))
> -				break;
> +		    !is_large_pte(iter.old_spte))
> +			continue;
>  
> -			/*
> -			 * The iter must explicitly re-read the spte here
> -			 * because the new value informs the !present
> -			 * path below.
> -			 */
> -			iter.old_spte = kvm_tdp_mmu_read_spte(iter.sptep);
> -		}
> +		/*
> +		 * If SPTE has been frozen by another thread, just give up and
> +		 * retry, avoiding unnecessary page table allocation and free.
> +		 */
> +		if (is_removed_spte(iter.old_spte))
> +			break;
>  
> -		if (!is_shadow_present_pte(iter.old_spte)) {
> -			/*
> -			 * If SPTE has been frozen by another thread, just
> -			 * give up and retry, avoiding unnecessary page table
> -			 * allocation and free.
> -			 */
> -			if (is_removed_spte(iter.old_spte))
> -				break;
> +		/*
> +		 * The SPTE is either non-present or points to a huge page that
> +		 * needs to be split.
> +		 */
> +		sp = tdp_mmu_alloc_sp(vcpu);
> +		tdp_mmu_init_child_sp(sp, &iter);
>  
> -			sp = tdp_mmu_alloc_sp(vcpu);
> -			tdp_mmu_init_child_sp(sp, &iter);
> +		sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
>  
> -			sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
> +		if (is_shadow_present_pte(iter.old_spte))
> +			ret = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
> +		else
> +			ret = tdp_mmu_link_sp(kvm, &iter, sp, true);
>  
> -			if (tdp_mmu_link_sp(kvm, &iter, sp, true)) {
> -				tdp_mmu_free_sp(sp);
> -				break;
> -			}
> +		if (ret) {
> +			tdp_mmu_free_sp(sp);
> +			break;
> +		}
>  
> -			if (fault->huge_page_disallowed &&
> -			    fault->req_level >= iter.level) {
> -				spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> -				track_possible_nx_huge_page(kvm, sp);
> -				spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> -			}
> +		if (fault->huge_page_disallowed &&
> +		    fault->req_level >= iter.level) {
> +			spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> +			track_possible_nx_huge_page(kvm, sp);
> +			spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
>  		}
>  	}
>  
> @@ -1484,8 +1480,6 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
>  	const int level = iter->level;
>  	int ret, i;
>  
> -	tdp_mmu_init_child_sp(sp, iter);
> -
David, thanks for the alignment with the precise nx huge page series.

Nit: since this patch puts tdp_mmu_init_child_sp() out of the
tdp_mmu_split_huge_page(), can we add a comment mentioned that, i.e.,
initialization of child sp is required before invoking the function?

With that action done,

Reviewed-by: Mingwei Zhang <mizhang@google.com>

>  	/*
>  	 * No need for atomics when writing to sp->spt since the page table has
>  	 * not been linked in yet and thus is not reachable from any other CPU.
> @@ -1561,6 +1555,8 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
>  				continue;
>  		}
>  
> +		tdp_mmu_init_child_sp(sp, &iter);
> +
>  		if (tdp_mmu_split_huge_page(kvm, &iter, sp, shared))
>  			goto retry;
>  
> -- 
> 2.38.0.413.g74048e4d9e-goog
> 
