Return-Path: <kvm+bounces-52857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD88CB09B26
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 08:09:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A801E3B282C
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 06:09:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43C131EF363;
	Fri, 18 Jul 2025 06:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yj5iO7gJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01ADE17578;
	Fri, 18 Jul 2025 06:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752818986; cv=none; b=afSePKIt2/LNe8qDwRHuN32YBhsmHgTud9wrDWCrOi99dl5TFHLT2xUOFMpp2WAr/tkCmCJBqz6/r3kSzviSGOYe1Isk65F9nsTXtNV4RPyTxKHrWWYMsiTW/xnjPrWd39EeQmMAUoiwFQYYEfKtR/7cWZE5CBBIwRVOTSfD1Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752818986; c=relaxed/simple;
	bh=Muu4to5olDa5hJVh7CdT0a9aefhZ6PwtM5Jz5Cbadhk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YsQNpkmLsroZQIuaCBcwGOzP3Q7BrkuDrUD7+2aq4XmZ1oGwNAq+/KbXdAI+zMxMMM1pch4O+BYkWkdqniPPhWdUmLr18tLAkvecgLbTb59lQXIKDgSI2dWLsIhw+gh7c/junwjq44raOgyZmWFdjfY6BOYJNjtWiotG08woyYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yj5iO7gJ; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752818985; x=1784354985;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Muu4to5olDa5hJVh7CdT0a9aefhZ6PwtM5Jz5Cbadhk=;
  b=Yj5iO7gJS7h4jD+PykKzPbIDC/ddULV7qTLm5DvNrsbn0puBogdowtB4
   RPl2y+bcGOdtSFMxeKRe4h094WZGK312sgjxHhf13AXzsFKmMtxF0Fz1H
   YHdNxjlODW85a2xSYhXrawdMq71k77t/D7bR5HplGLD4yyycC2oTHOoA8
   YEdc5LsNHaOG2Pmpks6Jz2Tzt1tGaZBA8sSMrLzEq8AZXLySAlKqzD3MS
   O/8MmzQ1+1vqm8B4LpAGaJR+H0l6eR4YOj48jUKo+RbghCBeslP9dFz0I
   jWkSTowB2zX+h+kiE8a4aBI/G/4XpoqC2AQfIUjIQzrAFUivsS7jvQOWh
   Q==;
X-CSE-ConnectionGUID: 4xqw34QpRACkklvHwIJEaQ==
X-CSE-MsgGUID: GwsIB3ZPR1C25tO2A8cBxw==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="55231384"
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="55231384"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 23:09:44 -0700
X-CSE-ConnectionGUID: b3Qe9VFRT1yDBJGJPtpzNw==
X-CSE-MsgGUID: xpob/a9xSH2SyoR3DNf2uA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="157367080"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 23:09:27 -0700
Message-ID: <9f8bd84d-6386-4e3c-802b-de598b8ac0c2@intel.com>
Date: Fri, 18 Jul 2025 14:09:24 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 13/21] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
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
References: <20250717162731.446579-1-tabba@google.com>
 <20250717162731.446579-14-tabba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250717162731.446579-14-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/18/2025 12:27 AM, Fuad Tabba wrote:
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

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>


Note to myself:

After this patch, it looks possible that 
kvm_mmu_prepare_memory_fault_exit() in kvm_mmu_faultin_pfn_gmem() might 
be triggered for guest_memfd with mmap support, though I'm not sure if 
there is real case to trigger it.

This requires some change in QEMU when it adds support for guest_memfd 
mmap support, since current QEMU handles KVM_EXIT_MEMORY_FAULT by always 
converting the memory attribute.

> ---
>   arch/x86/kvm/mmu/mmu.c | 13 +++++++++----
>   1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 94be15cde6da..ad5f337b496c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4511,8 +4511,8 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
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
> @@ -4536,13 +4536,18 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
>   	return RET_PF_CONTINUE;
>   }
>   
> +static bool fault_from_gmem(struct kvm_page_fault *fault)
> +{
> +	return fault->is_private || kvm_memslot_is_gmem_only(fault->slot);
> +}
> +
>   static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
>   				 struct kvm_page_fault *fault)
>   {
>   	unsigned int foll = fault->write ? FOLL_WRITE : 0;
>   
> -	if (fault->is_private)
> -		return kvm_mmu_faultin_pfn_private(vcpu, fault);
> +	if (fault_from_gmem(fault))
> +		return kvm_mmu_faultin_pfn_gmem(vcpu, fault);
>   
>   	foll |= FOLL_NOWAIT;
>   	fault->pfn = __kvm_faultin_pfn(fault->slot, fault->gfn, foll,


