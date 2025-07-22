Return-Path: <kvm+bounces-53071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E02C8B0D149
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 07:36:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B72A172746
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 05:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E030C28C2A8;
	Tue, 22 Jul 2025 05:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XvT7/0ES"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B9B1E377F;
	Tue, 22 Jul 2025 05:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753162580; cv=none; b=IrcsF0RX+CMg/riwCS38Sz/cCbYiAr6uOLCF1EQ66mwNzpX9unyofGajTtgXP8BJ4Z31t4hontO6biXvyOwxqT7Ov+HT6Etpryel8G6YKJ7urUfFBX8W3yHXxAG700J4SVQxfPcJf0urLHtk84dSkyHGXBMyGzO9R/MiUQ801ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753162580; c=relaxed/simple;
	bh=Ht84lyhmPROJj1BSFrangSyvdmx5lyxfxrorEw0o2wI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V0zLwK6mKeu7647p1dOimW0VDMoAJf29nUK6FuV0LhnEowKLmKcmzSueifpjtYRC3uvNTKV0jX4IykO/mK8XE8kQLH/2gX/mzBrm5Q665JVZssIv20h0RiKJ2ULxF8VGIP2oVG270QFzYrdSkDzbIO2UOi+if5AEq1elFJOohwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XvT7/0ES; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753162577; x=1784698577;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ht84lyhmPROJj1BSFrangSyvdmx5lyxfxrorEw0o2wI=;
  b=XvT7/0ESIrz7SIvuLIA2GcF9QK6h2dbgABtWFXcncN9OM12NT1rDXLaO
   azA8halqok/V4n2HgctMyKctYEHRMJ23cEa1CEVyh4+OTBzGqdh0T7Stv
   S6sNRRElou1j4XQ7Vv3jWUI4JetWwlTYNn/9ZNYgBlmQ2VcIpqnlcmv09
   vpwfP2p0wzpdMqgyQvCOSE73160YYLycopV33pJbztZnQM427torjLM5q
   +TKGP64i1rroD/DQNCKnlc3qk1+HRSS3bjD+uPv9OinacSRlFxWU1mjH1
   7BmtdROtc90W3U29SalEw7/yKJGEan9XN2sbCOfI6BVcwYyribCJXuBXH
   w==;
X-CSE-ConnectionGUID: nosZrL+9TyKbK2R5GR2uBw==
X-CSE-MsgGUID: Zf8Qja22S8yd5lPAPvJpRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="72965822"
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="72965822"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 22:36:16 -0700
X-CSE-ConnectionGUID: uQSKd6e7REGkUoyHhth1Jw==
X-CSE-MsgGUID: SUFj1nRtTTCLJch9qpJRPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="190020035"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 22:36:01 -0700
Message-ID: <c35b8c34-2736-45fe-8a97-bfedbf72537e@intel.com>
Date: Tue, 22 Jul 2025 13:35:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 11/21] KVM: x86/mmu: Allow NULL-able fault in
 kvm_max_private_mapping_level
To: Sean Christopherson <seanjc@google.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org,
 willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com,
 chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
 dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net,
 vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com,
 mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com,
 wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250717162731.446579-1-tabba@google.com>
 <20250717162731.446579-12-tabba@google.com>
 <8340ec70-1c44-47a7-8c48-89e175501e89@intel.com>
 <aH7KghhsjaiIL3En@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aH7KghhsjaiIL3En@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/22/2025 7:17 AM, Sean Christopherson wrote:
> On Fri, Jul 18, 2025, Xiaoyao Li wrote:
>> On 7/18/2025 12:27 AM, Fuad Tabba wrote:
>>> From: Ackerley Tng <ackerleytng@google.com>
>>>
>>> Refactor kvm_max_private_mapping_level() to accept a NULL kvm_page_fault
>>> pointer and rename it to kvm_gmem_max_mapping_level().
>>>
>>> The max_mapping_level x86 operation (previously private_max_mapping_level)
>>> is designed to potentially be called without an active page fault, for
>>> instance, when kvm_mmu_max_mapping_level() is determining the maximum
>>> mapping level for a gfn proactively.
>>>
>>> Allow NULL fault pointer: Modify kvm_max_private_mapping_level() to
>>> safely handle a NULL fault argument. This aligns its interface with the
>>> kvm_x86_ops.max_mapping_level operation it wraps, which can also be
>>> called with NULL.
>>
>> are you sure of it?
>>
>> The patch 09 just added the check of fault->is_private for TDX and SEV.
> 
> +1, this isn't quite right.  That's largely my fault (no pun intended) though, as
> I suggested the basic gist of the NULL @fault handling, and it's a mess.  More at
> the bottom.
> 
>>> Rename function to kvm_gmem_max_mapping_level(): This reinforces that
>>> the function's scope is for guest_memfd-backed memory, which can be
>>> either private or non-private, removing any remaining "private"
>>> connotation from its name.
>>>
>>> Optimize max_level checks: Introduce a check in the caller to skip
>>> querying for max_mapping_level if the current max_level is already
>>> PG_LEVEL_4K, as no further reduction is possible.
>>>
>>> Acked-by: David Hildenbrand <david@redhat.com>
>>> Suggested-by: Sean Christoperson <seanjc@google.com>
>>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>> ---
>>>    arch/x86/kvm/mmu/mmu.c | 16 +++++++---------
>>>    1 file changed, 7 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>>> index bb925994cbc5..6bd28fda0fd3 100644
>>> --- a/arch/x86/kvm/mmu/mmu.c
>>> +++ b/arch/x86/kvm/mmu/mmu.c
>>> @@ -4467,17 +4467,13 @@ static inline u8 kvm_max_level_for_order(int order)
>>>    	return PG_LEVEL_4K;
>>>    }
>>> -static u8 kvm_max_private_mapping_level(struct kvm *kvm,
>>> -					struct kvm_page_fault *fault,
>>> -					int gmem_order)
>>> +static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, int order,
>>> +				     struct kvm_page_fault *fault)
>>>    {
>>> -	u8 max_level = fault->max_level;
>>>    	u8 req_max_level;
>>> +	u8 max_level;
>>> -	if (max_level == PG_LEVEL_4K)
>>> -		return PG_LEVEL_4K;
>>> -
>>> -	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
>>> +	max_level = kvm_max_level_for_order(order);
>>>    	if (max_level == PG_LEVEL_4K)
>>>    		return PG_LEVEL_4K;
>>> @@ -4513,7 +4509,9 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
>>>    	}
>>>    	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
>>> -	fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault, max_order);
>>> +	if (fault->max_level >= PG_LEVEL_4K)
>>> +		fault->max_level = kvm_gmem_max_mapping_level(vcpu->kvm,
>>> +							      max_order, fault);
>>
>> I cannot understand why this change is required. In what case will
>> fault->max_level < PG_LEVEL_4K?
> 
> Yeah, I don't get this code either.  I also don't think KVM should call
> kvm_gmem_max_mapping_level() *here*.  That's mostly a problem with my suggested
> NULL @fault handling.  Dealing with kvm_gmem_max_mapping_level() here leads to
> weirdness, because kvm_gmem_max_mapping_level() also needs to be invoked for the
> !fault path, and then we end up with multiple call sites and the potential for a
> redundant call (gmem only, is private).
> 
> Looking through surrounding patches, the ordering of things is also "off".
> "Generalize private_max_mapping_level x86 op to max_mapping_level" should just
> rename the helper; reacting to !is_private memory in TDX belongs in "Consult
> guest_memfd when computing max_mapping_level", because that's where KVM plays
> nice with non-private memory.
> 
> But that patch is also doing too much, e.g. shuffling code around and short-circuting
> the non-fault case, which makes it confusing and hard to review.  Extending gmem
> hugepage support to shared memory should be "just" this:
> 
> @@ -3335,8 +3336,9 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
>          if (max_level == PG_LEVEL_4K)
>                  return PG_LEVEL_4K;
>   
> -       if (is_private)
> -               host_level = kvm_max_private_mapping_level(kvm, fault, slot, gfn);
> +       if (is_private || kvm_memslot_is_gmem_only(slot))
> +               host_level = kvm_gmem_max_mapping_level(kvm, fault, slot, gfn,
> +                                                       is_private);
>          else
>                  host_level = host_pfn_mapping_level(kvm, gfn, slot);
>          return min(host_level, max_level);
> 
> plus the plumbing and the small TDX change.  All the renames and code shuffling
> should be done in prep patches.
> 
> The attached patches are compile-tested only, but I think they get use where we
> want to be, and without my confusing suggestion to try and punt on private mappings
> in the hugepage recovery paths.  They should slot it at the right patch numbers
> (relative to v15).
> 
> Holler if the patches don't work, I'm happy to help sort things out so that v16
> is ready to go.

I have some feedback though the attached patches function well.

- In 0010-KVM-x86-mmu-Rename-.private_max_mapping_level-to-.gm.patch, 
there is double gmem in the name of vmx/vt 's callback implementation:

     vt_gmem_gmem_max_mapping_level
     tdx_gmem_gmem_max_mapping_level
     vt_op_tdx_only(gmem_gmem_max_mapping_level)

- In 0013-KVM-x86-mmu-Extend-guest_memfd-s-max-mapping-level-t.patch,
   kvm_x86_call(gmem_max_mapping_level)(...) returns 0 for !private case.
   It's not correct though it works without issue currently.

   Because current gmem doesn't support hugepage so that the max_level
   gotten from gmem is always PG_LEVEL_4K and it returns early in
   kvm_gmem_max_mapping_level() on

	if (max_level == PG_LEVEL_4K)
		return max_level;

   But just look at the following case:

     return min(max_level,
	kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private));

   For non-TDX case and non-SNP case, it will return 0, i.e.
   PG_LEVEL_NONE eventually.

   so either 1) return PG_LEVEL_NUM/PG_LEVEL_1G for the cases where
   .gmem_max_mapping_level callback doesn't have specific restriction.

   or 2)

	tmp = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private);
	if (tmp)
		return min(max_level, tmp);

	return max-level;


