Return-Path: <kvm+bounces-52592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 36B15B070F5
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 10:53:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4D2347AAFBD
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 08:51:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D0262EF9D2;
	Wed, 16 Jul 2025 08:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GLwLjflv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46322E88B5;
	Wed, 16 Jul 2025 08:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752655964; cv=none; b=Dfiq/Vbdu25Izq6dBYCTFW/l2M1dvXCiXLPZ1A8pzgEgmaIzVX5PcC+xMX5i7pEW95eY5dYZdxPwxFGoxabNvwf/TM/IxK9palRibluHm+QwTo1LlL2J8IA0uV0+h6ZIKswkq1NBPeGc/bmPyIs1jkASSTbdBMdytYfiGkAX/XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752655964; c=relaxed/simple;
	bh=94kf4M+XD6NApSPBMCDqmsn2ygZAgx+ZZdELWr26Y9s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LO/fa8uzNn29HpRWoDdoVbYC3/mNZknfrXF8nKpXWIlJk9zQptTegNFQR2hH0WVXRmGjZzK5qP2Fi5HbSqgmIsw9rLJuS/svwpBcJ1sviqPEmeBBWDK/81tXiHj4cKn38ZTEAy+2hboiLLoGMVa1889TPUS/c7htXR179TGvH/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GLwLjflv; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752655963; x=1784191963;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=94kf4M+XD6NApSPBMCDqmsn2ygZAgx+ZZdELWr26Y9s=;
  b=GLwLjflvStxM1HxaZI9WXUq6OVE9PhQka6J/3EuqwweyTTeK6bIo4PRx
   wXsHBBUDrs602N/vWZHRyHVjIyWVXYAXlw2ph82E+/KjwYcLP9Sz8wMxw
   dDlL9XrAWAOV4E5yRzA+pNkHVVEGoEsMzeN+OHiYRra0eqwWv6oM/Xbty
   mRgbKugEGu283TswETlkp7Zn5yhCQ9i8yx82yVpJ2qL0FZ8d6qFSFXBA8
   Es1VPfMPSAyVQqzTIPQHh/LqV7uFqEvXHMxAvQdq1rPH3QjYz9nGnkciq
   zpp3lMIp25/u5E3X3AGznjMZIFWjYUbqIcktYm1wEg1rvQe5L4uUpTZO0
   A==;
X-CSE-ConnectionGUID: 0Dwb0hK8RHyzRvlVU/P+Rw==
X-CSE-MsgGUID: petg+5MFQr+nV0LxdLjm3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="55013966"
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="55013966"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2025 01:52:42 -0700
X-CSE-ConnectionGUID: v3EhzNgHRDyuDzMapsSL+g==
X-CSE-MsgGUID: pr/19EOUSoCs0Cadba9NhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="157534744"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2025 01:52:27 -0700
Message-ID: <47bc83a0-5b5b-4f00-a6d2-1e5b4486f94f@intel.com>
Date: Wed, 16 Jul 2025 16:52:25 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 09/21] KVM: guest_memfd: Track guest_memfd mmap
 support in memslot
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org,
 mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com,
 viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org,
 akpm@linux-foundation.org, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
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
References: <20250715093350.2584932-1-tabba@google.com>
 <20250715093350.2584932-10-tabba@google.com>
 <eb9d39b4-0de8-4abb-b0f7-7180dc1aaee5@intel.com>
 <CA+EHjTw8Pezyut+pjpRyT9R5ZWvjOZUes27SHJAEeygCOV_HQA@mail.gmail.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CA+EHjTw8Pezyut+pjpRyT9R5ZWvjOZUes27SHJAEeygCOV_HQA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/2025 4:21 PM, Fuad Tabba wrote:
> Hi Xiaoyao,
> 
> On Wed, 16 Jul 2025 at 07:11, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>>
>> On 7/15/2025 5:33 PM, Fuad Tabba wrote:
>>> Add a new internal flag, KVM_MEMSLOT_GMEM_ONLY, to the top half of
>>> memslot->flags. This flag tracks when a guest_memfd-backed memory slot
>>> supports host userspace mmap operations. It's strictly for KVM's
>>> internal use.
>>
>> I would expect some clarification of why naming it with
>> KVM_MEMSLOT_GMEM_ONLY, not something like KVM_MEMSLOT_GMEM_MMAP_ENABLED
>>
>> There was a patch to check the userspace_addr of the memslot refers to
>> the same memory as guest memfd[1], but that patch was dropped. Without
>> the background that when guest memfd is mmapable, userspace doesn't need
>> to provide separate memory via userspace_addr, it's hard to understand
>> and accept the name of GMEM_ONLY.
> 
> The commit message could have clarified this a bit more. Regarding the
> rationale for the naming, there have been various threads and live
> discussions in the biweekly guest_memfd meeting . Instead of rehashing
> the discussion here, I can refer you to a couple [1, 2].

I don't object the name. Just want the clarification in commit message 
and even better add comment in code. That will be truly helpful for 
future readers.

> [1] https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?tab=t.0#heading=h.a15es1buok51
> [2] https://lore.kernel.org/all/aFwChljXL5QJYLM_@google.com/
> 
> Thanks,
> /fuad
> 
>> [1] https://lore.kernel.org/all/20250513163438.3942405-9-tabba@google.com/
>>
>>> This optimization avoids repeatedly checking the underlying guest_memfd
>>> file for mmap support, which would otherwise require taking and
>>> releasing a reference on the file for each check. By caching this
>>> information directly in the memslot, we reduce overhead and simplify the
>>> logic involved in handling guest_memfd-backed pages for host mappings.
>>>
>>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>>> Reviewed-by: Shivank Garg <shivankg@amd.com>
>>> Acked-by: David Hildenbrand <david@redhat.com>
>>> Suggested-by: David Hildenbrand <david@redhat.com>
>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>> ---
>>>    include/linux/kvm_host.h | 11 ++++++++++-
>>>    virt/kvm/guest_memfd.c   |  2 ++
>>>    2 files changed, 12 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>>> index 9ac21985f3b5..d2218ec57ceb 100644
>>> --- a/include/linux/kvm_host.h
>>> +++ b/include/linux/kvm_host.h
>>> @@ -54,7 +54,8 @@
>>>     * used in kvm, other bits are visible for userspace which are defined in
>>>     * include/uapi/linux/kvm.h.
>>>     */
>>> -#define KVM_MEMSLOT_INVALID  (1UL << 16)
>>> +#define KVM_MEMSLOT_INVALID                  (1UL << 16)
>>> +#define KVM_MEMSLOT_GMEM_ONLY                        (1UL << 17)
>>>
>>>    /*
>>>     * Bit 63 of the memslot generation number is an "update in-progress flag",
>>> @@ -2536,6 +2537,14 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
>>>                vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
>>>    }
>>>
>>> +static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
>>> +{
>>> +     if (!IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP))
>>> +             return false;
>>> +
>>> +     return slot->flags & KVM_MEMSLOT_GMEM_ONLY;
>>> +}
>>> +
>>>    #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
>>>    static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
>>>    {
>>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>>> index 07a4b165471d..2b00f8796a15 100644
>>> --- a/virt/kvm/guest_memfd.c
>>> +++ b/virt/kvm/guest_memfd.c
>>> @@ -592,6 +592,8 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
>>>         */
>>>        WRITE_ONCE(slot->gmem.file, file);
>>>        slot->gmem.pgoff = start;
>>> +     if (kvm_gmem_supports_mmap(inode))
>>> +             slot->flags |= KVM_MEMSLOT_GMEM_ONLY;
>>>
>>>        xa_store_range(&gmem->bindings, start, end - 1, slot, GFP_KERNEL);
>>>        filemap_invalidate_unlock(inode->i_mapping);
>>


