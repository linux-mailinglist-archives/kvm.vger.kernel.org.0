Return-Path: <kvm+bounces-53150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AF52CB0E086
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 17:31:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC08D3ACDF5
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 15:31:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A81AB277C81;
	Tue, 22 Jul 2025 15:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N8lKJN4y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A55267B90;
	Tue, 22 Jul 2025 15:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753198305; cv=none; b=NS4ZCSDY6mniBa788bRPhYE1aFVfuBKy0x3CbISydJLxjRNxE4Hy+tlYaMW4u9RSjWD2OP1POy5NQhWryWkEkRbS6u+UENuvrK4LAuHwvc7EhloRKhYov++Q/RI6qKoWKpIu1LNrpqLQuNz2ruWtY7SJwQ5JwQnYyhxljkPCtQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753198305; c=relaxed/simple;
	bh=eMOvJum6/yj2AFgesWxtWNZbW5eBwagvx40YMuSBJSs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eDsjEZsR42VjtdL4WOCac3qIYLHxkXt67BsJXWzykHANuRLf1lHPEQXdR8ip6t+iyqk4u5VadwYvyyFKGWGNK2h2E/9wQFmeuPJcAofnEE3YvwX+2D5t6S2GZoQInz7BIeBVPMzPmh4u9vbkBuQfKmcqVPrL8txy9XUHWGs4dLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N8lKJN4y; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753198304; x=1784734304;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eMOvJum6/yj2AFgesWxtWNZbW5eBwagvx40YMuSBJSs=;
  b=N8lKJN4yOrqBa1dUAKVkHyt3m+lNNUGJ3wmrpmx5AVYbOTx6WI5bXOl2
   RVgacJrsx8KpG8UaQv0JlIldG4d4hFrwaVnlBQ2Dt34elfPUdmIQvqsdX
   uAAuvekursTavUWB50Ar3HisSRhgbq0lO93yVvIBsVc6lI6yJaO2ac40W
   rm8qCMWYq4T2EI5lGbIFhDJAhRf5J6aSkq4avKlupQSOhR64vclVFkjmv
   OAlxVWvVba1o0KInae4SVjzz0uJUeHZ2sTMEBxLk82trlVkzD6loLrGKu
   KWn+7H1RqbsibH/qOA+IVClgQG83ZTDrU7fF0q4rTc93VVYE5t+t/skhe
   Q==;
X-CSE-ConnectionGUID: qh6vnHQ0Tc2gmFUoWhqhZw==
X-CSE-MsgGUID: H+giYodBQ6u8MpkoCqebYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11500"; a="59255538"
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="59255538"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 08:31:36 -0700
X-CSE-ConnectionGUID: jwBETCkjRh2RI6ObMFZZ4g==
X-CSE-MsgGUID: nwHPGSaPTBCnDP5i0GeW2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="182888359"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 08:31:20 -0700
Message-ID: <13654746-3edc-4e4a-ac4f-fa281b83b2ae@intel.com>
Date: Tue, 22 Jul 2025 23:31:17 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 14/21] KVM: x86: Enable guest_memfd mmap for default
 VM type
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
 <20250717162731.446579-15-tabba@google.com>
 <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com>
 <608cc9a5-cf25-47fe-b4eb-bdaff7406c2e@intel.com>
 <aH-iGMkP3Ad5yncW@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aH-iGMkP3Ad5yncW@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/22/2025 10:37 PM, Sean Christopherson wrote:
> On Tue, Jul 22, 2025, Xiaoyao Li wrote:
>> On 7/21/2025 8:22 PM, Xiaoyao Li wrote:
>>> On 7/18/2025 12:27 AM, Fuad Tabba wrote:
>>>> +/*
>>>> + * CoCo VMs with hardware support that use guest_memfd only for
>>>> backing private
>>>> + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping
>>>> enabled.
>>>> + */
>>>> +#define kvm_arch_supports_gmem_mmap(kvm)        \
>>>> +    (IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP) &&    \
>>>> +     (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM)
>>>
>>> I want to share the findings when I do the POC to enable gmem mmap in QEMU.
>>>
>>> Actually, QEMU can use gmem with mmap support as the normal memory even
>>> without passing the gmem fd to kvm_userspace_memory_region2.guest_memfd
>>> on KVM_SET_USER_MEMORY_REGION2.
>>>
>>> Since the gmem is mmapable, QEMU can pass the userspace addr got from
>>> mmap() on gmem fd to kvm_userspace_memory_region(2).userspace_addr. It
>>> works well for non-coco VMs on x86.
>>
>> one more findings.
>>
>> I tested with QEMU by creating normal (non-private) memory with mmapable
>> guest memfd, and enforcily passing the fd of the gmem to struct
>> kvm_userspace_memory_region2 when QEMU sets up memory region.
>>
>> It hits the kvm_gmem_bind() error since QEMU tries to back different GPA
>> region with the same gmem.
>>
>> So, the question is do we want to allow the multi-binding for shared-only
>> gmem?
> 
> Can you elaborate, maybe with code?  I don't think I fully understand the setup.

well, I haven't fully sorted it out. Just share what I get so far.

the problem hit when SMM is enabled (which is enabled by default).

- The trace of "-machine q35,smm=off":

kvm_set_user_memory AddrSpace#0 Slot#0 flags=0x4 gpa=0x0 size=0x80000000 
ua=0x7f5733fff000 guest_memfd=15 guest_memfd_offset=0x0 ret=0
kvm_set_user_memory AddrSpace#0 Slot#1 flags=0x4 gpa=0x100000000 
size=0x80000000 ua=0x7f57b3fff000 guest_memfd=15 
guest_memfd_offset=0x80000000 ret=0
kvm_set_user_memory AddrSpace#0 Slot#2 flags=0x2 gpa=0xffc00000 
size=0x400000 ua=0x7f5840a00000 guest_memfd=-1 guest_memfd_offset=0x0 ret=0
kvm_set_user_memory AddrSpace#0 Slot#0 flags=0x0 gpa=0x0 size=0x0 
ua=0x7f5733fff000 guest_memfd=15 guest_memfd_offset=0x0 ret=0
kvm_set_user_memory AddrSpace#0 Slot#0 flags=0x4 gpa=0x0 size=0xc0000 
ua=0x7f5733fff000 guest_memfd=15 guest_memfd_offset=0x0 ret=0
kvm_set_user_memory AddrSpace#0 Slot#3 flags=0x2 gpa=0xc0000 
size=0x20000 ua=0x7f5841000000 guest_memfd=-1 guest_memfd_offset=0x0 ret=0
kvm_set_user_memory AddrSpace#0 Slot#4 flags=0x2 gpa=0xe0000 
size=0x20000 ua=0x7f5840de0000 guest_memfd=-1 
guest_memfd_offset=0x3e0000 ret=0
kvm_set_user_memory AddrSpace#0 Slot#5 flags=0x4 gpa=0x100000 
size=0x7ff00000 ua=0x7f57340ff000 guest_memfd=15 
guest_memfd_offset=0x100000 ret=0

- The trace of "-machine q35"

kvm_set_user_memory AddrSpace#0 Slot#0 flags=0x4 gpa=0x0 size=0x80000000 
ua=0x7f8faffff000 guest_memfd=15 guest_memfd_offset=0x0 ret=0
kvm_set_user_memory AddrSpace#0 Slot#1 flags=0x4 gpa=0x100000000 
size=0x80000000 ua=0x7f902ffff000 guest_memfd=15 
guest_memfd_offset=0x80000000 ret=0
kvm_set_user_memory AddrSpace#0 Slot#2 flags=0x2 gpa=0xffc00000 
size=0x400000 ua=0x7f90bd000000 guest_memfd=-1 guest_memfd_offset=0x0 ret=0
kvm_set_user_memory AddrSpace#0 Slot#3 flags=0x4 gpa=0xfeda0000 
size=0x20000 ua=0x7f8fb009f000 guest_memfd=15 guest_memfd_offset=0xa0000 
ret=-22
qemu-system-x86_64: kvm_set_user_memory_region: 
KVM_SET_USER_MEMORY_REGION2 failed, slot=3, start=0xfeda0000, 
size=0x20000, flags=0x4, guest_memfd=15, guest_memfd_offset=0xa0000: 
Invalid argument
kvm_set_phys_mem: error registering slot: Invalid argument


where QEMU tries to setup the memory region for [0xfeda0000, +0x20000], 
which is back'ed by gmem (fd is 15) allocated for normal RAM, from 
offset 0xa0000.

What I have tracked down in QEMU is mch_realize(), where it sets up some 
memory region starting from 0xfeda0000.

If you want to reproduce it yourself, here is my QEMU branch

   https://github.com/intel-staging/qemu-tdx.git lxy/gmem-mmap-poc

To boot a VM with guest memfd:

   -object memory-backend-guest-memfd,id=gmem0,size=$mem
   -machine memory-backend=gmem0


