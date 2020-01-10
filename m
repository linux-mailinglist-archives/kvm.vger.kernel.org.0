Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCE52136C0A
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 12:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgAJLhi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 06:37:38 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56484 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727841AbgAJLhh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jan 2020 06:37:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578656256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XSFuiYR2PZERDTku2YvwYe+XWSs9j9e1KmhR60usaA8=;
        b=Q/sS/BUrP9PhTLXzXPx6pO2f56w9H3TOE+PBw1sEhU97w/f9o67TLecO/eWv9YFun/x/RH
        gVmxR+LdXy9giN3NWkONONirPo2LCrXQ9WL7krUL94B/5nH+ULTlBiBAgiPZPBS+//8h9r
        5YiiheA4ht0dCnguIw7bughs28R9j4E=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-gZMAuUzpOCWvDbK_eBocIQ-1; Fri, 10 Jan 2020 06:37:35 -0500
X-MC-Unique: gZMAuUzpOCWvDbK_eBocIQ-1
Received: by mail-wr1-f69.google.com with SMTP id i9so781378wru.1
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2020 03:37:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=XSFuiYR2PZERDTku2YvwYe+XWSs9j9e1KmhR60usaA8=;
        b=kv4lft98s9WWGaSr8zcPoM2Rylc2pBhnpr5YPFiS/MFiuYzUnX6quQbHOlHvWWzhnf
         rXLmkdzEsZ5bB31G2rW5CoVWsZAKkQeOnMy9uUrmt0m4gTWwdSnTrciMgDLsKw+IBeO6
         I/km5IIIz45rFNpV2pxS73aUyFbyiEVjoSavwZt6RPmjzZaEUS+o3n6G0GgAqf1bfvKU
         nLNG6+p9xcX6J6vAYfRcEB9AT3esByIO7UCZ8sdT8M5qdS+ZPEnyHLcWCe5Gy0GVjHis
         UfbW0htHz57gIIjXxO+e5vvEN+MppjBf6RQ+5UxskQ1dp6KEtynQtHzSexapQlVvjRmi
         bLCg==
X-Gm-Message-State: APjAAAUFNVFEEqW6HX+Ji9yKQ56R0WvYeKZHo+XPyM/BODkBV0JwssOt
        +pQtzbsS5e5UW/19nBERDD78Ii75Q4Mgpi/IBlrcSWyfnbBNF6utH2hMAfe6VqePWVnCMBNQ9Ru
        xscNqddcieZqy
X-Received: by 2002:a7b:cc09:: with SMTP id f9mr3843681wmh.71.1578656254338;
        Fri, 10 Jan 2020 03:37:34 -0800 (PST)
X-Google-Smtp-Source: APXvYqx+d6SvnqdC1f9FSBAc9hyNlY6rnXIR+81Nwiu9+yueJupymHOMnZZlAasMKv4NRpIMHykLXw==
X-Received: by 2002:a7b:cc09:: with SMTP id f9mr3843661wmh.71.1578656254114;
        Fri, 10 Jan 2020 03:37:34 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id h66sm1978031wme.41.2020.01.10.03.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 03:37:33 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Laight <David.Laight@ACULAB.COM>,
        Arvind Sankar <nivedita@alum.mit.edu>
Subject: Re: [PATCH v2 2/2] KVM: x86/mmu: Micro-optimize nEPT's bad memptype/XWR checks
In-Reply-To: <20200109230640.29927-3-sean.j.christopherson@intel.com>
References: <20200109230640.29927-1-sean.j.christopherson@intel.com> <20200109230640.29927-3-sean.j.christopherson@intel.com>
Date:   Fri, 10 Jan 2020 12:37:33 +0100
Message-ID: <878smfr18i.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Rework the handling of nEPT's bad memtype/XWR checks to micro-optimize
> the checks as much as possible.  Move the check to a separate helper,
> __is_bad_mt_xwr(), which allows the guest_rsvd_check usage in
> paging_tmpl.h to omit the check entirely for paging32/64 (bad_mt_xwr is
> always zero for non-nEPT) while retaining the bitwise-OR of the current
> code for the shadow_zero_check in walk_shadow_page_get_mmio_spte().
>
> Add a comment for the bitwise-OR usage in the mmio spte walk to avoid
> future attempts to "fix" the code, which is what prompted this
> optimization in the first place[*].
>
> Opportunistically remove the superfluous '!= 0' and parantheses, and
> use BIT_ULL() instead of open coding its equivalent.
>
> The net effect is that code generation is largely unhanged

unchanged? (or who's gonna hang that code? :-) )

> for walk_shadow_page_get_mmio_spte(), marginally better for
> ept_prefetch_invalid_gpte(), and significantly improved for
> paging32/64_prefetch_invalid_gpte().
>
> Note, walk_shadow_page_get_mmio_spte() can't use a templated version of
> the memtype/XRW as it works on the host's shadow PTEs, e.g. checks that
> KVM hasn't borked its EPT tables.  Even if it could be templated, the
> benefits of having a single implementation far outweight the few uops
> that would be saved for NPT or non-TDP paging, e.g. most compilers
> inline it all the way to up kvm_mmu_page_fault().
>
> [*] https://lkml.kernel.org/r/20200108001859.25254-1-sean.j.christopherson@intel.com
>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: David Laight <David.Laight@ACULAB.COM>
> Cc: Arvind Sankar <nivedita@alum.mit.edu>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/mmu/mmu.c         | 26 ++++++++++++++------------
>  arch/x86/kvm/mmu/paging_tmpl.h | 19 +++++++++++++++++--
>  2 files changed, 31 insertions(+), 14 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 7269130ea5e2..2992ff7b42a7 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3968,20 +3968,14 @@ static gpa_t nonpaging_gva_to_gpa_nested(struct kvm_vcpu *vcpu, gpa_t vaddr,
>  static bool
>  __is_rsvd_bits_set(struct rsvd_bits_validate *rsvd_check, u64 pte, int level)
>  {
> -	int bit7 = (pte >> 7) & 1, low6 = pte & 0x3f;
> +	int bit7 = (pte >> 7) & 1;
>  
> -	return (pte & rsvd_check->rsvd_bits_mask[bit7][level-1]) |
> -		((rsvd_check->bad_mt_xwr & (1ull << low6)) != 0);
> +	return pte & rsvd_check->rsvd_bits_mask[bit7][level-1];
>  }
>  
> -static bool is_rsvd_bits_set(struct kvm_mmu *mmu, u64 gpte, int level)
> +static bool __is_bad_mt_xwr(struct rsvd_bits_validate *rsvd_check, u64 pte)
>  {
> -	return __is_rsvd_bits_set(&mmu->guest_rsvd_check, gpte, level);
> -}
> -
> -static bool is_shadow_zero_bits_set(struct kvm_mmu *mmu, u64 spte, int level)
> -{
> -	return __is_rsvd_bits_set(&mmu->shadow_zero_check, spte, level);
> +	return rsvd_check->bad_mt_xwr & BIT_ULL(pte & 0x3f);
>  }
>  
>  static bool mmio_info_in_cache(struct kvm_vcpu *vcpu, u64 addr, bool direct)
> @@ -4005,9 +3999,12 @@ walk_shadow_page_get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
>  {
>  	struct kvm_shadow_walk_iterator iterator;
>  	u64 sptes[PT64_ROOT_MAX_LEVEL], spte = 0ull;
> +	struct rsvd_bits_validate *rsvd_check;
>  	int root, leaf;
>  	bool reserved = false;
>  
> +	rsvd_check = &vcpu->arch.mmu->shadow_zero_check;
> +
>  	walk_shadow_page_lockless_begin(vcpu);
>  
>  	for (shadow_walk_init(&iterator, vcpu, addr),
> @@ -4022,8 +4019,13 @@ walk_shadow_page_get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
>  		if (!is_shadow_present_pte(spte))
>  			break;
>  
> -		reserved |= is_shadow_zero_bits_set(vcpu->arch.mmu, spte,
> -						    iterator.level);
> +		/*
> +		 * Use a bitwise-OR instead of a logical-OR to aggregate the
> +		 * reserved bit and EPT's invalid memtype/XWR checks to avoid
> +		 * adding a Jcc in the loop.
> +		 */
> +		reserved |= __is_bad_mt_xwr(rsvd_check, spte) |
> +			    __is_rsvd_bits_set(rsvd_check, spte, iterator.level);
>  	}
>  
>  	walk_shadow_page_lockless_end(vcpu);
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 1fde6a1c506d..eaa00c4daeb1 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -128,6 +128,21 @@ static inline int FNAME(is_present_gpte)(unsigned long pte)
>  #endif
>  }
>  
> +static bool FNAME(is_bad_mt_xwr)(struct rsvd_bits_validate *rsvd_check, u64 gpte)
> +{
> +#if PTTYPE != PTTYPE_EPT
> +	return false;
> +#else
> +	return __is_bad_mt_xwr(rsvd_check, gpte);
> +#endif
> +}
> +
> +static bool FNAME(is_rsvd_bits_set)(struct kvm_mmu *mmu, u64 gpte, int level)
> +{
> +	return __is_rsvd_bits_set(&mmu->guest_rsvd_check, gpte, level) ||
> +	       FNAME(is_bad_mt_xwr)(&mmu->guest_rsvd_check, gpte);
> +}
> +

Not sure if it would make sense/difference (well, this is famous KVM
MMU!) but as FNAME(is_bad_mt_xwr)

has only one call site we could've as well merged it, something like:

static bool FNAME(is_rsvd_bits_set)(struct kvm_mmu *mmu, u64 gpte, int level)
{
#if PTTYPE == PTTYPE_EPT
	bool res =  __is_bad_mt_xwr(&mmu->guest_rsvd_check, gpte);
#else
	bool res = false;
#endif
	return __is_rsvd_bits_set(&mmu->guest_rsvd_check, gpte, level) || res;
}

but keeping it in-line with __is_rsvd_bits_set()/__is_bad_mt_xwr() in
mmu.c likely has greater benefits.

>  static int FNAME(cmpxchg_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  			       pt_element_t __user *ptep_user, unsigned index,
>  			       pt_element_t orig_pte, pt_element_t new_pte)
> @@ -183,7 +198,7 @@ static bool FNAME(prefetch_invalid_gpte)(struct kvm_vcpu *vcpu,
>  	    !(gpte & PT_GUEST_ACCESSED_MASK))
>  		goto no_present;
>  
> -	if (is_rsvd_bits_set(vcpu->arch.mmu, gpte, PT_PAGE_TABLE_LEVEL))
> +	if (FNAME(is_rsvd_bits_set)(vcpu->arch.mmu, gpte, PT_PAGE_TABLE_LEVEL))
>  		goto no_present;
>  
>  	return false;
> @@ -400,7 +415,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>  		if (unlikely(!FNAME(is_present_gpte)(pte)))
>  			goto error;
>  
> -		if (unlikely(is_rsvd_bits_set(mmu, pte, walker->level))) {
> +		if (unlikely(FNAME(is_rsvd_bits_set)(mmu, pte, walker->level))) {
>  			errcode = PFERR_RSVD_MASK | PFERR_PRESENT_MASK;
>  			goto error;
>  		}

FWIW,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

I've also smoke-tested with with a Hyper-V guest (just in case) and
nothing seems to be broken.

-- 
Vitaly

