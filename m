Return-Path: <kvm+bounces-53251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E90E8B0F4A1
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 15:56:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF8A0189D296
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 13:56:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2C132E54A1;
	Wed, 23 Jul 2025 13:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ArkXHQDL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9771E1DFC;
	Wed, 23 Jul 2025 13:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753278972; cv=none; b=taIUoDMaAyeR2f7Xmm4zDh7BaczMB/1VnS7S3QKYFyk9fEH41pkT4LROIfhCceGejwwjRBk1C4MO84Vl8scG3MQH3+t0ZVbJEi6Ej8pCYWxSuZ5WuSLmc/01woKHYdF5tnt74t5Tc841QXcNMtleA92DdPrqxpwg+M8TsgO0r2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753278972; c=relaxed/simple;
	bh=c8kuwhSWCLXC+0Y2fVqX0LnjkpKYcmdlz+rgqy/SZtc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hfo7iVcNU0RYrvtYChwlwmAi/kCo+rKb4AKPlGTFvII0HtoecICf2ZChoHJMBYtfQx84QSWlr27N8ERpwQeAwZVMb7V4TzvXVNaeu2CtLUo2ssm6c8sJ/A59XX/WTp654F3YoYmrzL3jjW3ShWCc95g1l19smUdBkDnFjMMtdrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ArkXHQDL; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753278970; x=1784814970;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=c8kuwhSWCLXC+0Y2fVqX0LnjkpKYcmdlz+rgqy/SZtc=;
  b=ArkXHQDLNOtqTpY0ycIRqqmTauWeMSszlrTxYp+RNt5nh2KJGticA5T3
   TGsyuSb7VIXGgOuxTIYeqgEUfKhxWamLttS6b8IE+GCQwslmxuw9/0lrd
   83033Y4fb6FG0gcU3o9aQ3b1m6xMFH2sdjzGFdCBX8VJ6uEOp5TvMDPSK
   vzqgGYxeoTyksQ6tmkGbZdTYxtV0O0KGfthbJPlo3LyEbiLtzPL99yEhs
   LTy5cIs99Upuzk/Wv3pL5bj9m+1GKzQRat2Egx2+B7Xut6rRttu9bPEyi
   Q3Kd1upgIFt+eWGFgNG2dVagXczhzVksPDAmNgaffIYiDAIBcbjdjgsqD
   w==;
X-CSE-ConnectionGUID: wTaERLeSRVas9tvEJq1XXQ==
X-CSE-MsgGUID: j8EbsT34T3i8DTK/cJ9lzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="78098941"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="78098941"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 06:56:09 -0700
X-CSE-ConnectionGUID: FUy24KQQTXSLB7tBu314zA==
X-CSE-MsgGUID: wepDHHHERX67GzCbFIqzPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="158797033"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 06:55:56 -0700
Message-ID: <1ff6a90a-3e03-4104-9833-4b07bb84831f@intel.com>
Date: Wed, 23 Jul 2025 21:55:52 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 14/22] KVM: x86/mmu: Enforce guest_memfd's max order
 when recovering hugepages
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
 ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250723104714.1674617-1-tabba@google.com>
 <20250723104714.1674617-15-tabba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250723104714.1674617-15-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/2025 6:47 PM, Fuad Tabba wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Rework kvm_mmu_max_mapping_level() to consult guest_memfd (and relevant)
> vendor code when recovering hugepages, e.g. after disabling live migration.
> The flaw has existed since guest_memfd was originally added, but has gone
> unnoticed due to lack of guest_memfd hugepage support.
> 
> Get all information on-demand from the memslot and guest_memfd instance,
> even though KVM could pull the pfn from the SPTE.  However, the max
> order/level needs to come from guest_memfd, and using kvm_gmem_get_pfn()
> avoids adding a new gmem API, and avoids having to retrieve the pfn and
> plumb it into kvm_mmu_max_mapping_level() (the pfn is needed for SNP to
> consult the RMP).
> 
> Note, calling kvm_mem_is_private() in the non-fault path is safe, so long
> as mmu_lock is held, as hugepage recovery operates on shadow-present SPTEs,
> i.e. calling kvm_mmu_max_mapping_level() with @fault=NULL is mutually
> exclusive with kvm_vm_set_mem_attributes() changing the PRIVATE attribute
> of the gfn.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c          | 83 +++++++++++++++++++--------------
>   arch/x86/kvm/mmu/mmu_internal.h |  2 +-
>   arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
>   3 files changed, 50 insertions(+), 37 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 20dd9f64156e..6148cc96f7d4 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3302,31 +3302,55 @@ static u8 kvm_max_level_for_order(int order)
>   	return PG_LEVEL_4K;
>   }
>   
> -static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
> -					u8 max_level, int gmem_order)
> +static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
> +					const struct kvm_memory_slot *slot, gfn_t gfn)
>   {
> -	u8 req_max_level;
> +	struct page *page;
> +	kvm_pfn_t pfn;
> +	u8 max_level;
>   
> -	if (max_level == PG_LEVEL_4K)
> -		return PG_LEVEL_4K;
> +	/* For faults, use the gmem information that was resolved earlier. */
> +	if (fault) {
> +		pfn = fault->pfn;
> +		max_level = fault->max_level;
> +	} else {
> +		/* TODO: Constify the guest_memfd chain. */
> +		struct kvm_memory_slot *__slot = (struct kvm_memory_slot *)slot;
> +		int max_order, r;
>   
> -	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
> -	if (max_level == PG_LEVEL_4K)
> -		return PG_LEVEL_4K;
> +		r = kvm_gmem_get_pfn(kvm, __slot, gfn, &pfn, &page, &max_order);
> +		if (r)
> +			return PG_LEVEL_4K;
>   
> -	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
> -	if (req_max_level)
> -		max_level = min(max_level, req_max_level);
> +		if (page)
> +			put_page(page);
>   
> -	return max_level;
> +		max_level = kvm_max_level_for_order(max_order);
> +	}
> +
> +	if (max_level == PG_LEVEL_4K)
> +		return max_level;
> +
> +	return min(max_level,
> +		   kvm_x86_call(gmem_max_mapping_level)(kvm, pfn));
>   }

I don't mean to want a next version.

But I have to point it out that, the coco_level stuff in the next patch 
should be put in this patch actually. Because this patch does the wrong 
thing to change from

	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
	if (req_max_level)
		max_level = min(max_level, req_max_level);

to

	return min(max_level,
		   kvm_x86_call(gmem_max_mapping_level)(kvm, pfn));	

