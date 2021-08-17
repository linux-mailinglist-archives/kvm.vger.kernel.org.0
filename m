Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E847E3EEC0A
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 14:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239824AbhHQMEA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 08:04:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52817 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236892AbhHQMD6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Aug 2021 08:03:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629201804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wH8R8tOox9tNr1NbSIewFreuWGg0xq13x6MdSwBJzMw=;
        b=G6yLjKdKADJHrdYjdg8DliD1IL7TLEk9A/bNwLmMmODpH4lw+LgvWuHJZQC8oXPQxixqXi
        wR2EmDkimu75cUdY+m4LGYKLfXF+rxK+0qGlFZvRUdq9PfJ0qI8Lx6KVyfNRLiNME/+Mki
        BHPn6pySNn4fxS6Urg5kjDV9+nqN9D0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-mLlyNgemPJSdMIfP7Dwugg-1; Tue, 17 Aug 2021 08:03:23 -0400
X-MC-Unique: mLlyNgemPJSdMIfP7Dwugg-1
Received: by mail-wm1-f72.google.com with SMTP id z186-20020a1c7ec30000b02902e6a27a9962so885267wmc.3
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 05:03:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wH8R8tOox9tNr1NbSIewFreuWGg0xq13x6MdSwBJzMw=;
        b=O/B+o1uZnLsydS9GV9/FdqTbh4caB/rg031cFXHIihPhjyFwg6zyZTlUQoSrI2qfHw
         PxkGHfdadD8zGFMtEgWdyfCO1zAN5CKgWmr6ZfIK9qhA3JIEs4vAUAl3oj1PG9U+pZcS
         n21R525jnIHn8wakzlO6ruAx6cdtnP3IiXytmWD+cRyxIwxnwd5vnLYEVC3eJS386sbQ
         eJLr5DYqLcpuhvZ4V+g+zGs7f3vyrA+K/wYIL9d0a3ybJUTmCF4wJIu6hQlUPvhWO2ST
         ADL2XVTM9Md93QnxBRDoIowZxF7sJalrNyTjj1xfpphxxueE5VKTjBXXxqR+Gz1vt0Hv
         pGrA==
X-Gm-Message-State: AOAM533BI3dq7MCcgCrObOJ3fHjEdscoxV1EUBaW13CS9i7MfqUSIIpy
        uNSlPUnpLydGuJK1WW4k4rkGwXGovATxa2/Md6JEtdt8dH38xx0q2Nd2sj4iyfsDB/cLHZVrIWx
        7Y34px3FcsY4n
X-Received: by 2002:a05:6000:18a4:: with SMTP id b4mr3697792wri.162.1629201802070;
        Tue, 17 Aug 2021 05:03:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwhX1txqYjiA7pX/3AOrJAINDVUb+F6wqV/zYbzscyv0lae2HLC2fNvSLJZokVYiIIQMbwqJQ==
X-Received: by 2002:a05:6000:18a4:: with SMTP id b4mr3697765wri.162.1629201801855;
        Tue, 17 Aug 2021 05:03:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b12sm2588974wrx.72.2021.08.17.05.03.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 05:03:21 -0700 (PDT)
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <20210813203504.2742757-1-dmatlack@google.com>
 <20210813203504.2742757-6-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 5/6] KVM: x86/mmu: Avoid memslot lookup in rmap_add
Message-ID: <e6070335-3f7e-aebd-93cd-3fb42a426425@redhat.com>
Date:   Tue, 17 Aug 2021 14:03:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210813203504.2742757-6-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/08/21 22:35, David Matlack wrote:
> Avoid the memslot lookup in rmap_add by passing it down from the fault
> handling code to mmu_set_spte and then to rmap_add.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

I think before doing this we should take another look at the aguments
for make_spte, set_spte and mmu_set_spte.  St

static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
                         u64 *sptep, unsigned int pte_access, bool write_fault,
                         int level, gfn_t gfn, kvm_pfn_t pfn, bool speculative,
                         bool host_writable)

static int set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
                     u64 *sptep, unsigned int pte_access, int level,
                     gfn_t gfn, kvm_pfn_t pfn, bool speculative,
                     bool can_unsync, bool host_writable)

int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
                      gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool speculative,
                      bool can_unsync, bool host_writable, bool ad_disabled,
                      u64 *new_spte)

In particular:

- set_spte should be inlined in its two callers.  The SET_SPTE_*
flags are overkill if both functions can just call make_spte+mmu_spte_update:
mmu_set_spte can check *sptep == spte and return RET_PF_SPURIOUS directly,
while SET_SPTE_NEED_REMOTE_TLB_FLUSH can become just a bool that is
returned by make_spte.

- level and ad_disabled can be replaced by a single pointer to struct
kvm_mmu_page (tdp_mmu does not set ad_disabled in page_role_for_level,
but that's not an issue).

- in mmu_set_spte, write_fault, speculative and host_writable are either
false/true/true (prefetching) or fault->write, fault->prefault,
fault->map_writable (pagefault).  So they can be replaced by a single
struct kvm_page_fault pointer, where NULL means false/true/true.  Then
if set_spte is inlined, the ugly bool arguments only remain in make_spte
(minus ad_disabled).

This does not remove the need for a separate slot parameter,
but at least the balance is that there are no extra arguments to
make_spte (two go, level and ad_disabled; two come, sp and slot).

I've started hacking on the above, but didn't quite finish.  I'll
keep patches 4-6 in my queue, but they'll have to wait for 5.15.

Paolo

> ---
>   arch/x86/kvm/mmu/mmu.c         | 29 ++++++++---------------------
>   arch/x86/kvm/mmu/paging_tmpl.h | 12 +++++++++---
>   2 files changed, 17 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c148d481e9b5..41e2ef8ad09b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1630,16 +1630,15 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
>   
>   #define RMAP_RECYCLE_THRESHOLD 1000
>   
> -static void rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
> +static void rmap_add(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
> +		     u64 *spte, gfn_t gfn)
>   {
> -	struct kvm_memory_slot *slot;
>   	struct kvm_mmu_page *sp;
>   	struct kvm_rmap_head *rmap_head;
>   	int rmap_count;
>   
>   	sp = sptep_to_sp(spte);
>   	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
> -	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
>   	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
>   	rmap_count = pte_list_add(vcpu, spte, rmap_head);
>   
> @@ -2679,9 +2678,9 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>   	return ret;
>   }
>   
> -static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
> -			unsigned int pte_access, bool write_fault, int level,
> -			gfn_t gfn, kvm_pfn_t pfn, bool speculative,
> +static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
> +			u64 *sptep, unsigned int pte_access, bool write_fault,
> +			int level, gfn_t gfn, kvm_pfn_t pfn, bool speculative,
>   			bool host_writable)
>   {
>   	int was_rmapped = 0;
> @@ -2744,24 +2743,12 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>   
>   	if (!was_rmapped) {
>   		kvm_update_page_stats(vcpu->kvm, level, 1);
> -		rmap_add(vcpu, sptep, gfn);
> +		rmap_add(vcpu, slot, sptep, gfn);
>   	}
>   
>   	return ret;
>   }
>   
> -static kvm_pfn_t pte_prefetch_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
> -				     bool no_dirty_log)
> -{
> -	struct kvm_memory_slot *slot;
> -
> -	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, no_dirty_log);
> -	if (!slot)
> -		return KVM_PFN_ERR_FAULT;
> -
> -	return gfn_to_pfn_memslot_atomic(slot, gfn);
> -}
> -
>   static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
>   				    struct kvm_mmu_page *sp,
>   				    u64 *start, u64 *end)
> @@ -2782,7 +2769,7 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
>   		return -1;
>   
>   	for (i = 0; i < ret; i++, gfn++, start++) {
> -		mmu_set_spte(vcpu, start, access, false, sp->role.level, gfn,
> +		mmu_set_spte(vcpu, slot, start, access, false, sp->role.level, gfn,
>   			     page_to_pfn(pages[i]), true, true);
>   		put_page(pages[i]);
>   	}
> @@ -2979,7 +2966,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   			account_huge_nx_page(vcpu->kvm, sp);
>   	}
>   
> -	ret = mmu_set_spte(vcpu, it.sptep, ACC_ALL,
> +	ret = mmu_set_spte(vcpu, fault->slot, it.sptep, ACC_ALL,
>   			   fault->write, fault->goal_level, base_gfn, fault->pfn,
>   			   fault->prefault, fault->map_writable);
>   	if (ret == RET_PF_SPURIOUS)
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 50ade6450ace..653ca44afa58 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -561,6 +561,7 @@ static bool
>   FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>   		     u64 *spte, pt_element_t gpte, bool no_dirty_log)
>   {
> +	struct kvm_memory_slot *slot;
>   	unsigned pte_access;
>   	gfn_t gfn;
>   	kvm_pfn_t pfn;
> @@ -573,8 +574,13 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>   	gfn = gpte_to_gfn(gpte);
>   	pte_access = sp->role.access & FNAME(gpte_access)(gpte);
>   	FNAME(protect_clean_gpte)(vcpu->arch.mmu, &pte_access, gpte);
> -	pfn = pte_prefetch_gfn_to_pfn(vcpu, gfn,
> +
> +	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn,
>   			no_dirty_log && (pte_access & ACC_WRITE_MASK));
> +	if (!slot)
> +		return false;
> +
> +	pfn = gfn_to_pfn_memslot_atomic(slot, gfn);
>   	if (is_error_pfn(pfn))
>   		return false;
>   
> @@ -582,7 +588,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>   	 * we call mmu_set_spte() with host_writable = true because
>   	 * pte_prefetch_gfn_to_pfn always gets a writable pfn.
>   	 */
> -	mmu_set_spte(vcpu, spte, pte_access, false, PG_LEVEL_4K, gfn, pfn,
> +	mmu_set_spte(vcpu, slot, spte, pte_access, false, PG_LEVEL_4K, gfn, pfn,
>   		     true, true);
>   
>   	kvm_release_pfn_clean(pfn);
> @@ -749,7 +755,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>   		}
>   	}
>   
> -	ret = mmu_set_spte(vcpu, it.sptep, gw->pte_access, fault->write,
> +	ret = mmu_set_spte(vcpu, fault->slot, it.sptep, gw->pte_access, fault->write,
>   			   it.level, base_gfn, fault->pfn, fault->prefault,
>   			   fault->map_writable);
>   	if (ret == RET_PF_SPURIOUS)
> 

