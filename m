Return-Path: <kvm+bounces-53720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A34DB159B2
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 09:37:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFAA53BB6A3
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 07:37:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1C3C28FFD8;
	Wed, 30 Jul 2025 07:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hgM3Qo0g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A47228F925;
	Wed, 30 Jul 2025 07:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753861061; cv=none; b=obLTj/hAQMxGapCK25NlH0YfCxN5vMV2YtjtGunMTqkiVDF4TGKegPTsNJu8J7rc9gj/2QCkOb3GJW05/WCLNnnkf6MOkky/pmii0B1hCFuDsFl2tTuviwYcT23CecmhuHz6Tz3toJ7kNrCDeRVPTZZhGG8i5yI9KCM0RWi8VwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753861061; c=relaxed/simple;
	bh=Wx/PGqRnErvPvMGDFamkrBsB3gh6iDSc0BGeARtBkZM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jASvRc6um9pkrVg6+B0EmTlzUTp+aLfG6OMUlClO8PMGfeBREvsqmJFYDRLxxnbBT9q34KRiKqlgw7Igegv780/doMYpjVUOCq+miOR1L3IFbjH0AHG2c1qmmUIs6JnlElXjzieQ25FWah4I1y8E6j33KXcTb6Ng21l7KqOAUeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hgM3Qo0g; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753861061; x=1785397061;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Wx/PGqRnErvPvMGDFamkrBsB3gh6iDSc0BGeARtBkZM=;
  b=hgM3Qo0g3Y+vzYNr0KC7dY8zfLzDbvdw/9zwn1y4WxD7OiaGlFSAxIJI
   r5qCPADAAc7ssxCU29AjmViqXe3umfUJ/lGqpZfsKMSLxn0ItWDNrlc0H
   Cou4FXeLgE2f1a8T4hgHtO99PJZlaXAwF6ub0PrhwsjJ9/uL+9EgsKiPH
   +3uAIWQRfC7ZwgfJ1AovZdyB0w2ct836+wYEhMuCEU+I0SSFa6J0eAQly
   x+Xko5DGOat6E+vyI6wKjovU1jMibrpBwaXQvETUSIjwasceoCBn7VmwE
   iyeSmOXj+AVEHVe/pSWlLoKsFgbJkN9eqtKwh7b0ZBLdEQKDutw4w4W86
   w==;
X-CSE-ConnectionGUID: GM28TgK4SKiddUf0d+wp3w==
X-CSE-MsgGUID: zhSk0EbeTVeBW03NWA8MBw==
X-IronPort-AV: E=McAfee;i="6800,10657,11506"; a="56037755"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="56037755"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 00:37:38 -0700
X-CSE-ConnectionGUID: feCkmU4NS/GnJCZ7axVvKA==
X-CSE-MsgGUID: yuXXeCjDTC2mBvEuGPXruA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="167395719"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 00:37:34 -0700
Message-ID: <cf196e44-4ec1-45ab-9cd4-dd8cb10bd44f@intel.com>
Date: Wed, 30 Jul 2025 15:37:31 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 16/24] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
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
 <20250729225455.670324-17-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250729225455.670324-17-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/2025 6:54 AM, Sean Christopherson wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Update the KVM MMU fault handler to service guest page faults
> for memory slots backed by guest_memfd with mmap support. For such
> slots, the MMU must always fault in pages directly from guest_memfd,
> bypassing the host's userspace_addr.
> 
> This ensures that guest_memfd-backed memory is always handled through
> the guest_memfd specific faulting path, regardless of whether it's for
> private or non-private (shared) use cases.
> 
> Additionally, rename kvm_mmu_faultin_pfn_private() to
> kvm_mmu_faultin_pfn_gmem(), as this function is now used to fault in
> pages from guest_memfd for both private and non-private memory,
> accommodating the new use cases.
> 
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Co-developed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> [sean: drop the helper]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/mmu/mmu.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e83d666f32ad..56c80588efa0 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4561,8 +4561,8 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
>   				 r == RET_PF_RETRY, fault->map_writable);
>   }
>   
> -static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
> -				       struct kvm_page_fault *fault)
> +static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
> +				    struct kvm_page_fault *fault)
>   {
>   	int max_order, r;
>   
> @@ -4589,8 +4589,8 @@ static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
>   {
>   	unsigned int foll = fault->write ? FOLL_WRITE : 0;
>   
> -	if (fault->is_private)
> -		return kvm_mmu_faultin_pfn_private(vcpu, fault);
> +	if (fault->is_private || kvm_memslot_is_gmem_only(fault->slot))
> +		return kvm_mmu_faultin_pfn_gmem(vcpu, fault);
>   
>   	foll |= FOLL_NOWAIT;
>   	fault->pfn = __kvm_faultin_pfn(fault->slot, fault->gfn, foll,


