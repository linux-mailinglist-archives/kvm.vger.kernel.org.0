Return-Path: <kvm+bounces-52851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2EACB09AD0
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 07:10:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5E27A62F54
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 05:10:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03192191F9C;
	Fri, 18 Jul 2025 05:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JfHHYYGG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C1A3214;
	Fri, 18 Jul 2025 05:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752815423; cv=none; b=rBxyXe9tm+FzbpxlXx93iXjDkr9zQ0DUSCMU+jev/HsxDw4FyEv1A5T4SRdpoNYi8VbML9xx/+MTm3DHpRVLH204wk4CoNGa5vWsyCVBv+DNv1AP1algmPw85OCySjBjgeQeEdQm454IDoSQoVj3IJrPu43G+mbHKQ/RMiZ8JUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752815423; c=relaxed/simple;
	bh=b7MC4xw+aWrHxKCyUGT5BCdoygo0xZwVblE3fF3ETJ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JY4hQUONRaOIQlJ7yXw5caUzXEa5obZq7ngNoKeyVlJvVe7XDgPADZVAqzsIT4Mhm5vbcxTVWPh0NlS0cPPuHmm+YQAOJO4QAyjJcHyvNlkV7Zl8YTlXVHGkLSTttlmyn0RHu9PAebvAoBavk2U0DVcQ52e9Yv68YuemiDrqJI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JfHHYYGG; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752815422; x=1784351422;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=b7MC4xw+aWrHxKCyUGT5BCdoygo0xZwVblE3fF3ETJ4=;
  b=JfHHYYGGNUnzmLk5AemuQUuAgSPAcmkkLS3WSmUJTrq+s7Izyz8scLES
   UVDCCLhs5lcSHML5o2gBJJ39R6/tNsSOz/zciV/x6eC2OWJ19MgDuZfGX
   uCPFT1ytcu/B2HsEPBh98YnIgkDz+UHJ5T86bBWeVwKhz/A+NUSNGig+/
   Aj0BoF/Lnyu3OzBhdzMr+1Ir/GSeWmRuD4AyCrCU5zdveL6KeNkLy6YdI
   CX1ZthXW2Tc3dUzrlk0EnKEnNJBBsqDeqkmctATd9XAkdfNLHrPgsHyBg
   KPM5FC+NliKIOJaQmdoTsO+wB7KQMSHctu8UNPMzNY/bY3jrGWTxF6Qxu
   Q==;
X-CSE-ConnectionGUID: OJp3gODqTKuf04LMdByTug==
X-CSE-MsgGUID: NBDxx5mZSiC1FYdiECZTzA==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="55228314"
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="55228314"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 22:10:21 -0700
X-CSE-ConnectionGUID: a9b4WvSRTtaaMhuxuVj91Q==
X-CSE-MsgGUID: TqPVZm1bRiiCBhRpewpQBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="158671869"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 22:10:04 -0700
Message-ID: <8340ec70-1c44-47a7-8c48-89e175501e89@intel.com>
Date: Fri, 18 Jul 2025 13:10:00 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 11/21] KVM: x86/mmu: Allow NULL-able fault in
 kvm_max_private_mapping_level
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
 <20250717162731.446579-12-tabba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250717162731.446579-12-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/18/2025 12:27 AM, Fuad Tabba wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Refactor kvm_max_private_mapping_level() to accept a NULL kvm_page_fault
> pointer and rename it to kvm_gmem_max_mapping_level().
> 
> The max_mapping_level x86 operation (previously private_max_mapping_level)
> is designed to potentially be called without an active page fault, for
> instance, when kvm_mmu_max_mapping_level() is determining the maximum
> mapping level for a gfn proactively.
> 
> Allow NULL fault pointer: Modify kvm_max_private_mapping_level() to
> safely handle a NULL fault argument. This aligns its interface with the
> kvm_x86_ops.max_mapping_level operation it wraps, which can also be
> called with NULL.

are you sure of it?

The patch 09 just added the check of fault->is_private for TDX and SEV.

> Rename function to kvm_gmem_max_mapping_level(): This reinforces that
> the function's scope is for guest_memfd-backed memory, which can be
> either private or non-private, removing any remaining "private"
> connotation from its name.
> 
> Optimize max_level checks: Introduce a check in the caller to skip
> querying for max_mapping_level if the current max_level is already
> PG_LEVEL_4K, as no further reduction is possible.
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Sean Christoperson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 16 +++++++---------
>   1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index bb925994cbc5..6bd28fda0fd3 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4467,17 +4467,13 @@ static inline u8 kvm_max_level_for_order(int order)
>   	return PG_LEVEL_4K;
>   }
>   
> -static u8 kvm_max_private_mapping_level(struct kvm *kvm,
> -					struct kvm_page_fault *fault,
> -					int gmem_order)
> +static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, int order,
> +				     struct kvm_page_fault *fault)
>   {
> -	u8 max_level = fault->max_level;
>   	u8 req_max_level;
> +	u8 max_level;
>   
> -	if (max_level == PG_LEVEL_4K)
> -		return PG_LEVEL_4K;
> -
> -	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
> +	max_level = kvm_max_level_for_order(order);
>   	if (max_level == PG_LEVEL_4K)
>   		return PG_LEVEL_4K;
>   
> @@ -4513,7 +4509,9 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
>   	}
>   
>   	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
> -	fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault, max_order);
> +	if (fault->max_level >= PG_LEVEL_4K)
> +		fault->max_level = kvm_gmem_max_mapping_level(vcpu->kvm,
> +							      max_order, fault);

I cannot understand why this change is required. In what case will 
fault->max_level < PG_LEVEL_4K?


>   	return RET_PF_CONTINUE;
>   }


