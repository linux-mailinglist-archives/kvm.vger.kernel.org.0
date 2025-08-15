Return-Path: <kvm+bounces-54799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C94F3B28337
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 17:48:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E1DA17570E
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 15:48:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09D8726F44D;
	Fri, 15 Aug 2025 15:48:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 193A3305E1A;
	Fri, 15 Aug 2025 15:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755272913; cv=none; b=BpJgsyJxyFxXRD/9HVk3Z+UPcX3WEQjjkqwWDjQe6n8iq204Yc0sBqmBdyXp1ljgxQjsFEg0+9oPuKyrsQsFEXSZr+kwZ7+NW25lxuC7ns7lH0mpcd0Aa/SkJPx4BOakddpZWng4QjAXWzQzf2GPH7F9WF9ic1z7oPZysc1/MvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755272913; c=relaxed/simple;
	bh=udtTBB6Wuldv5fmyFD+F+56cDz1dwwYTcD4HNEovPiA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UC71DGTkRoXSwHTnEhC6Ecai6bnis2PgSbn9BKls8q1TSZLHRd/NRDW03zpZMrJveZxa8S8WUJCGg1KcDkUaCWZMImt3+nYPOoCGNyaMGVAK4pjwRiz09X9UJn8yG4NpDO34+LZXCkbzqRnQXN1/DFlvIt4SgepwZOdQkzqhDfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 01F0B1691;
	Fri, 15 Aug 2025 08:48:22 -0700 (PDT)
Received: from [10.1.29.14] (e122027.cambridge.arm.com [10.1.29.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 54F983F5A1;
	Fri, 15 Aug 2025 08:48:25 -0700 (PDT)
Message-ID: <23be7cdb-f094-4303-87ae-2fdfed80178b@arm.com>
Date: Fri, 15 Aug 2025 16:48:23 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 19/43] arm64: RME: Allow populating initial contents
To: Vishal Annapurve <vannapurve@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>
References: <20250611104844.245235-1-steven.price@arm.com>
 <20250611104844.245235-20-steven.price@arm.com>
 <CAGtprH-on3JdsHx-DyjN_z_5Z6HJoSQjJpA5o5_V6=rygMSbtQ@mail.gmail.com>
 <80c46a5c-7559-4763-bbf2-6c755a4b067c@arm.com>
 <CAGtprH_6DYk8POPy+sLc3RL0-5gcrTdPNcDWFTssOK5_U4B3Nw@mail.gmail.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <CAGtprH_6DYk8POPy+sLc3RL0-5gcrTdPNcDWFTssOK5_U4B3Nw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 14/08/2025 17:26, Vishal Annapurve wrote:
> On Wed, Aug 13, 2025 at 2:30 AM Steven Price <steven.price@arm.com> wrote:
>>
>> On 01/08/2025 02:56, Vishal Annapurve wrote:
>>> On Wed, Jun 11, 2025 at 3:59 AM Steven Price <steven.price@arm.com> wrote:
>>>>
>>>> +static int realm_create_protected_data_page(struct realm *realm,
>>>> +                                           unsigned long ipa,
>>>> +                                           kvm_pfn_t dst_pfn,
>>>> +                                           kvm_pfn_t src_pfn,
>>>> +                                           unsigned long flags)
>>>> +{
>>>> +       unsigned long rd = virt_to_phys(realm->rd);
>>>> +       phys_addr_t dst_phys, src_phys;
>>>> +       bool undelegate_failed = false;
>>>> +       int ret, offset;
>>>> +
>>>> +       dst_phys = __pfn_to_phys(dst_pfn);
>>>> +       src_phys = __pfn_to_phys(src_pfn);
>>>> +
>>>> +       for (offset = 0; offset < PAGE_SIZE; offset += RMM_PAGE_SIZE) {
>>>> +               ret = realm_create_protected_data_granule(realm,
>>>> +                                                         ipa,
>>>> +                                                         dst_phys,
>>>> +                                                         src_phys,
>>>> +                                                         flags);
>>>> +               if (ret)
>>>> +                       goto err;
>>>> +
>>>> +               ipa += RMM_PAGE_SIZE;
>>>> +               dst_phys += RMM_PAGE_SIZE;
>>>> +               src_phys += RMM_PAGE_SIZE;
>>>> +       }
>>>> +
>>>> +       return 0;
>>>> +
>>>> +err:
>>>> +       if (ret == -EIO) {
>>>> +               /* current offset needs undelegating */
>>>> +               if (WARN_ON(rmi_granule_undelegate(dst_phys)))
>>>> +                       undelegate_failed = true;
>>>> +       }
>>>> +       while (offset > 0) {
>>>> +               ipa -= RMM_PAGE_SIZE;
>>>> +               offset -= RMM_PAGE_SIZE;
>>>> +               dst_phys -= RMM_PAGE_SIZE;
>>>> +
>>>> +               rmi_data_destroy(rd, ipa, NULL, NULL);
>>>> +
>>>> +               if (WARN_ON(rmi_granule_undelegate(dst_phys)))
>>>> +                       undelegate_failed = true;
>>>> +       }
>>>> +
>>>> +       if (undelegate_failed) {
>>>> +               /*
>>>> +                * A granule could not be undelegated,
>>>> +                * so the page has to be leaked
>>>> +                */
>>>> +               get_page(pfn_to_page(dst_pfn));
>>>
>>> I would like to point out that the support for in-place conversion
>>> with guest_memfd using hugetlb pages [1] is under discussion.
>>>
>>> As part of the in-place conversion, the policy we are routing for is
>>> to avoid any "refcounts" from KVM on folios supplied by guest_memfd as
>>> in-place conversion works by splitting and merging folios during
>>> memory conversion as per discussion at LPC [2].
>>
>> CCA doesn't really support "in-place" conversions (see more detail
>> below). But here the issue is that something has gone wrong and the RMM
>> is refusing to give us a page back.
> 
> I think I overloaded the term "in-place" conversion in this context. I
> was talking about supporting "in-place" conversion without data
> preservation. i.e. Host will use the same GPA->HPA range mapping even
> after conversions, ensuring single backing for guest memory. This is
> achieved by guest_memfd keeping track of private/shared ranges based
> on userspace IOCTLs to change the tracking metadata.

Yes, so for a destructive conversion this is fine. We can remove the
page from the protected region and then place the same physical page in
the shared region (or vice versa).

Population is a special case because it's effectively non-destructive,
and in that case we need both the reference data and the final
(protected) physical page both available at same time.

>>
>>>
>>> The best way to avoid further use of this page with huge page support
>>> around would be either:
>>> 1) Explicitly Inform guest_memfd of a particular pfn being in use by
>>> KVM without relying on page refcounts or
>>
>> This might work, but note that the page is unavailable even after user
>> space has freed the guest_memfd. So at some point the page needs to be
>> marked so that it cannot be reallocated by the kernel. Holding a
>> refcount isn't ideal but I haven't come up with a better idea.
>>
>> Note that this is a "should never happen" situation - the code will have
>> WARN()ed already - so this is just a best effort to allow the system to
>> limp on.
>>
>>> 2) Set the page as hwpoisoned. (Needs further discussion)
>>
>> This certainly sounds like a closer fit - but I'm not very familiar with
>> hwpoison so I don't know how easy it would be to integrate with this.
>>
> 
> We had similar discussions with Intel specific SEPT management and the
> conclusion there was to just not hold refcounts and give a warning on
> such failures [1].
> 
> [1] https://lore.kernel.org/kvm/20250807094241.4523-1-yan.y.zhao@intel.com/

So these paths (should) all warn already. I guess the question is
whether we want the platform to limp on in these situations or not.
Certainly converting the WARNs to BUG_ON would be very easy, but the
intention here was to give the user some chance to save their work
before killing the system.

Just WARNing might be ok, but if the kernel allocates the page for one
of it's data structures then it's effectively a BUG_ON - there's no
reasonable recovery. Reallocation into user space we can sort of handle,
but only by killing the process.

>>> This page refcounting strategy will have to be revisited depending on
>>> which series lands first. That being said, it would be great if ARM
>>> could review/verify if the series [1] works for backing CCA VMs with
>>> huge pages.
>>>
>>> [1] https://lore.kernel.org/kvm/cover.1747264138.git.ackerleytng@google.com/
>>> [2] https://lpc.events/event/18/contributions/1764/
>>>
>>>> +       }
>>>> +
>>>> +       return -ENXIO;
>>>> +}
>>>> +
>>>> +static int populate_region(struct kvm *kvm,
>>>> +                          phys_addr_t ipa_base,
>>>> +                          phys_addr_t ipa_end,
>>>> +                          unsigned long data_flags)
>>>> +{
>>>> +       struct realm *realm = &kvm->arch.realm;
>>>> +       struct kvm_memory_slot *memslot;
>>>> +       gfn_t base_gfn, end_gfn;
>>>> +       int idx;
>>>> +       phys_addr_t ipa = ipa_base;
>>>> +       int ret = 0;
>>>> +
>>>> +       base_gfn = gpa_to_gfn(ipa_base);
>>>> +       end_gfn = gpa_to_gfn(ipa_end);
>>>> +
>>>> +       idx = srcu_read_lock(&kvm->srcu);
>>>> +       memslot = gfn_to_memslot(kvm, base_gfn);
>>>> +       if (!memslot) {
>>>> +               ret = -EFAULT;
>>>> +               goto out;
>>>> +       }
>>>> +
>>>> +       /* We require the region to be contained within a single memslot */
>>>> +       if (memslot->base_gfn + memslot->npages < end_gfn) {
>>>> +               ret = -EINVAL;
>>>> +               goto out;
>>>> +       }
>>>> +
>>>> +       if (!kvm_slot_can_be_private(memslot)) {
>>>> +               ret = -EPERM;
>>>> +               goto out;
>>>> +       }
>>>> +
>>>> +       while (ipa < ipa_end) {
>>>> +               struct vm_area_struct *vma;
>>>> +               unsigned long hva;
>>>> +               struct page *page;
>>>> +               bool writeable;
>>>> +               kvm_pfn_t pfn;
>>>> +               kvm_pfn_t priv_pfn;
>>>> +               struct page *gmem_page;
>>>> +
>>>> +               hva = gfn_to_hva_memslot(memslot, gpa_to_gfn(ipa));
>>>> +               vma = vma_lookup(current->mm, hva);
>>>> +               if (!vma) {
>>>> +                       ret = -EFAULT;
>>>> +                       break;
>>>> +               }
>>>> +
>>>> +               pfn = __kvm_faultin_pfn(memslot, gpa_to_gfn(ipa), FOLL_WRITE,
>>>> +                                       &writeable, &page);
>>>
>>> Is this assuming double backing of guest memory ranges? Is this logic
>>> trying to simulate a shared fault?
>>
>> Yes and yes...
>>
>>> Does memory population work with CCA if priv_pfn and pfn are the same?
>>> I am curious how the memory population will work with in-place
>>> conversion support available for guest_memfd files.
>>
>> The RMM interface doesn't support an in-place conversion. The
>> RMI_DATA_CREATE operation takes the PA of the already delegated
>> granule[1] along with the PA of a non-delegated granule with the data.
> 
> Ok, I think this will need a source buffer from userspace that is
> outside guest_memfd once guest_memfd will support a single backing for
> guest memory. You might want to simulate private access fault for
> destination GPAs backed by guest_memfd ranges for this initial data
> population -> similar to how memory population works today with TDX
> VMs.

Yes, that might well be the best option. At the moment I'm not sure what
the best approach from the perspective of the VMM is. The current setup
is nice because the VMM can populate the VM just like a normal non-coco
setup, so we don't need to special-case anything. Requiring the VMM to
load the initial contents into some other memory for the purpose of the
populate call is a little ugly.

The other option is to just return to the double-memcpy() approach of
emulating an in-place content-preserving populate by the kernel copying
the data out of guest_memfd into a temporary page before doing the
conversion and the RMM copying back from the temporary page. I worry
about the performance of this, although it doesn't prevent the first
option being added in the future if necessary. The big benefit is that
it goes back to looking like a non-coco VM (but using guest_memfd).

> Note that with single backing around, at least for x86, KVM
> shared/private stage2 faults will always be served using guest_memfd
> as the source of truth (i.e. not via userspace pagetables for shared
> faults).

Indeed, it's not yet clear to me whether we can only support this
"single backing" world for CCA, or if it's going to be an option
alongside using guest_memfd only for protected memory. Obviously we need
the guest_memfd changes to land first too...

At the moment I'm planning to post a v10 of this series soon, keeping
the same API. But we will definitely want to support the new guest_memfd
approach when it's ready.

Thanks,
Steve

>>
>> So to mimic an in-place conversion requires copying the data from the
>> page, delegating the (original) page and then using RMI_DATA_CREATE
>> which copies the data back. Fundamentally because there may be memory
>> encryption involved there is going to be a requirement for this double
>> memcpy() approach. Note that this is only relevant during the initial
>> setup phase - CCA doesn't (at least currently) permit populated pages to
>> be provided to the guest when it is running.
>>
>> The approach this series takes pre-dates the guest_memfd discussions and
>> so is assuming that the shared memory is not (directly) provided by the
>> guest_memfd but is using the user space pointer provided in the memslot.
>> It would be possible (with the patches proposed) for the VMM to mmap()
>> the guest_memfd when the memory is being shared so as to reuse the
>> physical pages.
>>
>> I do also plan to look at supporting the use of the guest_memfd for the
>> shared memory directly. But I've been waiting for the discussions to
>> conclude before attempting to implement that.
>>
>> [1] A 'granule' is the RMM's idea of a page size (RMM_PAGE_SIZE), which
>> is currently (RMM v1.0) always 4k. So may be different when Linux is
>> running with a larger page size.
>>
>> Thanks,
>> Steve
>>


