Return-Path: <kvm+bounces-53717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 60728B159A6
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 09:34:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 564CF5429DA
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 07:34:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E02328ECE1;
	Wed, 30 Jul 2025 07:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lPxWuQMt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3ED71EEA3C;
	Wed, 30 Jul 2025 07:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753860842; cv=none; b=P2OjOwDaiW00xMpYqvqBAw5LF3eYPMffIn1OqNn9goxJ0e5XH8/QeiQubuhYIZnVgtN2SS3LkrxwlNVjgGXIKdTvppr+ljhIPa1U3fnht1Dx3hkxnV9Ukdj6qzxbE/lYMdlrmbodbZZguosUasVHLE/DYLncllxwhb5RwvJUOvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753860842; c=relaxed/simple;
	bh=2RgN0j+ENwauyGI9Svu9rEjlit08q6gOS10LSTOfkCM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fnMetgAmf95OCHzTrRsj+kjxtBbr3JziQcZQTy03LrOa2Kk+0+X0Q/jtnmTipMHTopgp9/kacb2nXUHGCLvU84fLZvRnZvCUOvrjGzngj0XYKj+9XaEb3zf0W/m/Cyl82hi9yb0JDAeUfHzIiBDRnqQ8aEzXqA7PTtnRVAjDqAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lPxWuQMt; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753860841; x=1785396841;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2RgN0j+ENwauyGI9Svu9rEjlit08q6gOS10LSTOfkCM=;
  b=lPxWuQMt/s10ym5f0bQaeubszvlX0gYS6Fb/DSPSzrZCoGql5qNxR5UN
   qi8egKMVb+OFsI15dFx+nMuRG1/QEKb7rNRz38H0PuibmgCalntQyB4JJ
   MMd1FlF1lhq/98y1Um0yHgrkZ55ccG7vqy4E2Rx+FqW9ZI23Kl7L2tPGp
   yAVP6OMDd7O3jurz+OpVsIOr1k7o3ufA0Qh2Q33xZaWQVH3eZ1sHCDxij
   H5NdXBX0z33M0m+POtqu+NA9fryRPdG5aZ2wsWTMSmX6tdEj82zLjAPZ/
   BHAAHgQ7kAeZN51OUKjvLkPJd0qO3laR/x4wu9Smn6E4zyUfUkVcJbSIa
   Q==;
X-CSE-ConnectionGUID: eYbQ83uASP+yqHOq8qPVGw==
X-CSE-MsgGUID: nOE0tXHWRV6iSQYPawkktw==
X-IronPort-AV: E=McAfee;i="6800,10657,11506"; a="56240677"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="56240677"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 00:34:00 -0700
X-CSE-ConnectionGUID: H09GH9DDRK6iwMUT5DFTZA==
X-CSE-MsgGUID: 9J0CZfBtR+i2FENGg5ZkzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="162636483"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 00:33:54 -0700
Message-ID: <e67b0825-abcb-4bac-bc3c-2e8b513f1d57@intel.com>
Date: Wed, 30 Jul 2025 15:33:51 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 14/24] KVM: x86/mmu: Enforce guest_memfd's max order
 when recovering hugepages
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>,
 Shivank Garg <shivankg@amd.com>, Vlastimil Babka <vbabka@suse.cz>,
 David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>,
 Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>,
 James Houghton <jthoughton@google.com>
References: <20250729225455.670324-1-seanjc@google.com>
 <20250729225455.670324-15-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250729225455.670324-15-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/2025 6:54 AM, Sean Christopherson wrote:
> Rework kvm_mmu_max_mapping_level() to provide the plumbing to consult
> guest_memfd (and relevant vendor code) when recovering hugepages, e.g.
> after disabling live migration.  The flaw has existed since guest_memfd was
> originally added, but has gone unnoticed due to lack of guest_memfd support
> for hugepages or dirty logging.
> 
> Don't actually call into guest_memfd at this time, as it's unclear as to
> what the API should be.  Ideally, KVM would simply use kvm_gmem_get_pfn(),
> but invoking kvm_gmem_get_pfn() would lead to sleeping in atomic context
> if guest_memfd needed to allocate memory (mmu_lock is held).  Luckily,
> the path isn't actually reachable, so just add a TODO and WARN to ensure
> the functionality is added alongisde guest_memfd hugepage support, and
> punt the guest_memfd API design question to the future.
> 
> Note, calling kvm_mem_is_private() in the non-fault path is safe, so long
> as mmu_lock is held, as hugepage recovery operates on shadow-present SPTEs,
> i.e. calling kvm_mmu_max_mapping_level() with @fault=NULL is mutually
> exclusive with kvm_vm_set_mem_attributes() changing the PRIVATE attribute
> of the gfn.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c          | 82 +++++++++++++++++++--------------
>   arch/x86/kvm/mmu/mmu_internal.h |  2 +-
>   arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
>   3 files changed, 49 insertions(+), 37 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 20dd9f64156e..61eb9f723675 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3302,31 +3302,54 @@ static u8 kvm_max_level_for_order(int order)
>   	return PG_LEVEL_4K;
>   }
>   
> -static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
> -					u8 max_level, int gmem_order)
> +static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
> +					const struct kvm_memory_slot *slot, gfn_t gfn)

I don't see why slot and gfn are needed here. Just to keep consistent 
with host_pfn_mapping_level()?

>   {
> -	u8 req_max_level;
> +	u8 max_level, coco_level;
> +	kvm_pfn_t pfn;
>   
> -	if (max_level == PG_LEVEL_4K)
> -		return PG_LEVEL_4K;
> +	/* For faults, use the gmem information that was resolved earlier. */
> +	if (fault) {
> +		pfn = fault->pfn;
> +		max_level = fault->max_level;
> +	} else {
> +		/* TODO: Call into guest_memfd once hugepages are supported. */
> +		WARN_ONCE(1, "Get pfn+order from guest_memfd");
> +		pfn = KVM_PFN_ERR_FAULT;
> +		max_level = PG_LEVEL_4K;
> +	}
>   
> -	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
>   	if (max_level == PG_LEVEL_4K)
> -		return PG_LEVEL_4K;
> +		return max_level;
>   
> -	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
> -	if (req_max_level)
> -		max_level = min(max_level, req_max_level);
> +	/*
> +	 * CoCo may influence the max mapping level, e.g. due to RMP or S-EPT
> +	 * restrictions.  A return of '0' means "no additional restrictions", to
> +	 * allow for using an optional "ret0" static call.
> +	 */
> +	coco_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
> +	if (coco_level)
> +		max_level = min(max_level, coco_level);
>   
>   	return max_level;
>   }
>   
> -static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
> -				       const struct kvm_memory_slot *slot,
> -				       gfn_t gfn, int max_level, bool is_private)
> +int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
> +			      const struct kvm_memory_slot *slot, gfn_t gfn)
>   {
>   	struct kvm_lpage_info *linfo;
> -	int host_level;
> +	int host_level, max_level;
> +	bool is_private;
> +
> +	lockdep_assert_held(&kvm->mmu_lock);
> +
> +	if (fault) {
> +		max_level = fault->max_level;
> +		is_private = fault->is_private;
> +	} else {
> +		max_level = PG_LEVEL_NUM;
> +		is_private = kvm_mem_is_private(kvm, gfn);
> +	}
>   
>   	max_level = min(max_level, max_huge_page_level);
>   	for ( ; max_level > PG_LEVEL_4K; max_level--) {
> @@ -3335,25 +3358,16 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
>   			break;
>   	}
>   
> +	if (max_level == PG_LEVEL_4K)
> +		return PG_LEVEL_4K;
> +
>   	if (is_private)
> -		return max_level;
> -
> -	if (max_level == PG_LEVEL_4K)
> -		return PG_LEVEL_4K;
> -
> -	host_level = host_pfn_mapping_level(kvm, gfn, slot);
> +		host_level = kvm_max_private_mapping_level(kvm, fault, slot, gfn);
> +	else
> +		host_level = host_pfn_mapping_level(kvm, gfn, slot);
>   	return min(host_level, max_level);
>   }
>   
> -int kvm_mmu_max_mapping_level(struct kvm *kvm,
> -			      const struct kvm_memory_slot *slot, gfn_t gfn)
> -{
> -	bool is_private = kvm_slot_has_gmem(slot) &&
> -			  kvm_mem_is_private(kvm, gfn);
> -
> -	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM, is_private);
> -}
> -
>   void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   {
>   	struct kvm_memory_slot *slot = fault->slot;
> @@ -3374,9 +3388,8 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>   	 * Enforce the iTLB multihit workaround after capturing the requested
>   	 * level, which will be used to do precise, accurate accounting.
>   	 */
> -	fault->req_level = __kvm_mmu_max_mapping_level(vcpu->kvm, slot,
> -						       fault->gfn, fault->max_level,
> -						       fault->is_private);
> +	fault->req_level = kvm_mmu_max_mapping_level(vcpu->kvm, fault,
> +						     fault->slot, fault->gfn);
>   	if (fault->req_level == PG_LEVEL_4K || fault->huge_page_disallowed)
>   		return;
>   
> @@ -4564,8 +4577,7 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
>   	}
>   
>   	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
> -	fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault->pfn,
> -							 fault->max_level, max_order);
> +	fault->max_level = kvm_max_level_for_order(max_order);
>   
>   	return RET_PF_CONTINUE;
>   }
> @@ -7165,7 +7177,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
>   		 * mapping if the indirect sp has level = 1.
>   		 */
>   		if (sp->role.direct &&
> -		    sp->role.level < kvm_mmu_max_mapping_level(kvm, slot, sp->gfn)) {
> +		    sp->role.level < kvm_mmu_max_mapping_level(kvm, NULL, slot, sp->gfn)) {
>   			kvm_zap_one_rmap_spte(kvm, rmap_head, sptep);
>   
>   			if (kvm_available_flush_remote_tlbs_range())
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 65f3c89d7c5d..b776be783a2f 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -411,7 +411,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>   	return r;
>   }
>   
> -int kvm_mmu_max_mapping_level(struct kvm *kvm,
> +int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
>   			      const struct kvm_memory_slot *slot, gfn_t gfn);
>   void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
>   void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level);
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 7f3d7229b2c1..740cb06accdb 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1813,7 +1813,7 @@ static void recover_huge_pages_range(struct kvm *kvm,
>   		if (iter.gfn < start || iter.gfn >= end)
>   			continue;
>   
> -		max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot, iter.gfn);
> +		max_mapping_level = kvm_mmu_max_mapping_level(kvm, NULL, slot, iter.gfn);
>   		if (max_mapping_level < iter.level)
>   			continue;
>   


