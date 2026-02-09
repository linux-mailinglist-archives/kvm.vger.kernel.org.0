Return-Path: <kvm+bounces-70605-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MAgmFSMAimluFQAAu9opvQ
	(envelope-from <kvm+bounces-70605-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 16:41:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BAFE9112042
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 16:41:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 76A1F303D2FF
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 15:36:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7113237FF4D;
	Mon,  9 Feb 2026 15:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bhdTqqEF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38A1295DAC;
	Mon,  9 Feb 2026 15:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770651358; cv=none; b=U/4kgXPrY+dCvz+WrbExclUEivk4ji+avRz8w3mLGl2fhdS55tnM+8tQEDbeBI7r33cagVFGZPdjP157cKnSg1n+i6CtF3SH9BRIY0l13WalWLlu5cK4BI2lTStAfCv8VQuknbTY3ZMpl5z92MG8Ng9LenZ/Uuf5z/PutfX72MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770651358; c=relaxed/simple;
	bh=zFz8vUni6pgix6F/mutd/GIOhr7EcTWq5cAQdEFI/3s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gg1DetkovEUXBIP/sF7+mLridzwvM4kNThgxtG4M1PrDeWc01qgTDYXoFNTTIIle5P30YcQH7b2oXV4kZoZdMEJ+1tmJvWZ+rjWyzVo3OA+uJX/b1iOC96Ssdu81T1+sn6IyL/aoy4QZLEF0DJsE+VVhNV0fkfI4Bm8i70zEoEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bhdTqqEF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27CBAC116C6;
	Mon,  9 Feb 2026 15:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770651358;
	bh=zFz8vUni6pgix6F/mutd/GIOhr7EcTWq5cAQdEFI/3s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bhdTqqEFW/U2l1XAl5cmDWF9FoZVPME8mARaXEKe5Fxm78q0HCbx9NPbRB/5kgWdW
	 bg8dINgqRpeLag95c4uljAKU/ydNCrNLWXXVTuSQH6CYGOrVgPnCd8BY9jV6Qedt3n
	 wNFJ0LM1AK8jnnGABCJx25CtgCSuaY6oubiocc8VskI3BnFNsBWBRKTx6lzwlS6fcc
	 Y8h6FOpXIDKszS5Ces6ZHEOZUweyoW7EDqwozSsM+6hMKRzBSjZNeO1OYARgkAMDxx
	 /0mZq+gunlTDqcUAo8XXdhTmnjUhbLyGSam1gMxwnHpQIVSzPtEeTSF+mARMfv9/gf
	 BKtgoYrV/UdGw==
Message-ID: <0032ac8b-06ba-4f4b-ad66-f0195eea1c15@kernel.org>
Date: Mon, 9 Feb 2026 16:35:47 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/17] mm, kvm: allow uffd suppot in guest_memfd
To: Peter Xu <peterx@redhat.com>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins
 <hughd@google.com>, James Houghton <jthoughton@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 Nikita Kalyazin <kalyazin@amazon.com>, Oscar Salvador <osalvador@suse.de>,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20260127192936.1250096-1-rppt@kernel.org>
 <aYJg5lT9MG0BQFkG@x1.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aYJg5lT9MG0BQFkG@x1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70605-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[david@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BAFE9112042
X-Rspamd-Action: no action

On 2/3/26 21:56, Peter Xu wrote:
> On Tue, Jan 27, 2026 at 09:29:19PM +0200, Mike Rapoport wrote:
>> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>>
>> Hi,
>>
>> These patches enable support for userfaultfd in guest_memfd.
>> They are quite different from the latest posting [1] so I'm restarting the
>> versioning. As there was a lot of tension around the topic, this is an RFC
>> to get some feedback and see how we can move forward.
>>
>> As the ground work I refactored userfaultfd handling of PTE-based memory types
>> (anonymous and shmem) and converted them to use vm_uffd_ops for allocating a
>> folio or getting an existing folio from the page cache. shmem also implements
>> callbacks that add a folio to the page cache after the data passed in
>> UFFDIO_COPY was copied and remove the folio from the page cache if page table
>> update fails.
>>
>> In order for guest_memfd to notify userspace about page faults, there are new
>> VM_FAULT_UFFD_MINOR and VM_FAULT_UFFD_MISSING that a ->fault() handler can
>> return to inform the page fault handler that it needs to call
>> handle_userfault() to complete the fault.
>>
>> Nikita helped to plumb these new goodies into guest_memfd and provided basic
>> tests to verify that guest_memfd works with userfaultfd.
>>
>> I deliberately left hugetlb out, at least for the most part.
>> hugetlb handles acquisition of VMA and more importantly establishing of parent
>> page table entry differently than PTE-based memory types. This is a different
>> abstraction level than what vm_uffd_ops provides and people objected to
>> exposing such low level APIs as a part of VMA operations.
>>
>> Also, to enable uffd in guest_memfd refactoring of hugetlb is not needed and I
>> prefer to delay it until the dust settles after the changes in this set.
>>
>> [1] https://lore.kernel.org/all/20251130111812.699259-1-rppt@kernel.org
>>
>> Mike Rapoport (Microsoft) (12):
>>    userfaultfd: introduce mfill_copy_folio_locked() helper
>>    userfaultfd: introduce struct mfill_state
>>    userfaultfd: introduce mfill_get_pmd() helper.
>>    userfaultfd: introduce mfill_get_vma() and mfill_put_vma()
>>    userfaultfd: retry copying with locks dropped in mfill_atomic_pte_copy()
>>    userfaultfd: move vma_can_userfault out of line
>>    userfaultfd: introduce vm_uffd_ops
>>    userfaultfd, shmem: use a VMA callback to handle UFFDIO_CONTINUE
>>    userfaultfd: introduce vm_uffd_ops->alloc_folio()
>>    shmem, userfaultfd: implement shmem uffd operations using vm_uffd_ops
>>    userfaultfd: mfill_atomic() remove retry logic
>>    mm: introduce VM_FAULT_UFFD_MINOR fault reason
>>
>> Nikita Kalyazin (5):
>>    mm: introduce VM_FAULT_UFFD_MISSING fault reason
>>    KVM: guest_memfd: implement userfaultfd minor mode
>>    KVM: guest_memfd: implement userfaultfd missing mode
>>    KVM: selftests: test userfaultfd minor for guest_memfd
>>    KVM: selftests: test userfaultfd missing for guest_memfd
>>
>>   include/linux/mm.h                            |   5 +
>>   include/linux/mm_types.h                      |  15 +-
>>   include/linux/shmem_fs.h                      |  14 -
>>   include/linux/userfaultfd_k.h                 |  74 +-
>>   mm/hugetlb.c                                  |  21 +
>>   mm/memory.c                                   |   8 +-
>>   mm/shmem.c                                    | 188 +++--
>>   mm/userfaultfd.c                              | 671 ++++++++++--------
>>   .../testing/selftests/kvm/guest_memfd_test.c  | 191 +++++
>>   virt/kvm/guest_memfd.c                        | 134 +++-
>>   10 files changed, 871 insertions(+), 450 deletions(-)
> 
> Mike,
> 
> The idea looks good to me, thanks for this work!  Your process on
> UFFDIO_COPY over anon/shmem is nice to me.
> 
> If you remember, I used to raise a concern on introducing two new fault
> retvals only for userfaultfd:
> 
> https://lore.kernel.org/all/aShb8J18BaRrsA-u@x1.local/
> 
> IMHO they're not only unnecessarily leaking userfaultfd information into
> fault core definitions, but also cause code duplications.  I still think we
> should avoid them.
> 
> This time, I've attached a smoke tested patch removing both of them.
> 
> It's pretty small and it runs all fine with all old/new userfaultfd tests
> (including gmem ones). Feel free to have a look at the end.
> 
> I understand you want to avoid adding mnore complexity to this series, if
> you want I can also prepare such a patch after this series landed to remove
> the two retvals.  I'd still would like to know how you think about it,
> though, let me know if you have any comments.
> 
> Note that it may indeed need some perf tests to make sure there's zero
> overhead after this change.  Currently there's still some trivial overheads
> (e.g. unnecessary folio locks), but IIUC we can even avoid that.
> 
> Thanks,
> 
> ===8<===
>  From 5379d084494b17281f3e5365104a7edbdbe53759 Mon Sep 17 00:00:00 2001
> From: Peter Xu <peterx@redhat.com>
> Date: Tue, 3 Feb 2026 15:07:58 -0500
> Subject: [PATCH] mm/userfaultfd: Remove two userfaultfd fault retvals
> 
> They're not needed when with vm_uffd_ops.  We can remove both of them.
> Actually, another side benefit is drivers do not need to process
> userfaultfd missing / minor faults anymore in the main fault handler.
> 
> This patch will make get_folio_noalloc() required for either MISSING or
> MINOR fault, but that's not a problem, as it should be lightweight and the
> current only outside-mm user (gmem) will support both anyway.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>   include/linux/mm_types.h      | 15 +-----------
>   include/linux/userfaultfd_k.h |  2 +-
>   mm/memory.c                   | 45 +++++++++++++++++++++++++++++------
>   mm/shmem.c                    | 12 ----------
>   virt/kvm/guest_memfd.c        | 20 ----------------
>   5 files changed, 40 insertions(+), 54 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index a6d32470a78a3..3cc8ae7228860 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -1612,10 +1612,6 @@ typedef __bitwise unsigned int vm_fault_t;
>    *				fsync() to complete (for synchronous page faults
>    *				in DAX)
>    * @VM_FAULT_COMPLETED:		->fault completed, meanwhile mmap lock released
> - * @VM_FAULT_UFFD_MINOR:	->fault did not modify page tables and needs
> - *				handle_userfault(VM_UFFD_MINOR) to complete
> - * @VM_FAULT_UFFD_MISSING:	->fault did not modify page tables and needs
> - *				handle_userfault(VM_UFFD_MISSING) to complete
>    * @VM_FAULT_HINDEX_MASK:	mask HINDEX value
>    *
>    */
> @@ -1633,13 +1629,6 @@ enum vm_fault_reason {
>   	VM_FAULT_DONE_COW       = (__force vm_fault_t)0x001000,
>   	VM_FAULT_NEEDDSYNC      = (__force vm_fault_t)0x002000,
>   	VM_FAULT_COMPLETED      = (__force vm_fault_t)0x004000,
> -#ifdef CONFIG_USERFAULTFD
> -	VM_FAULT_UFFD_MINOR	= (__force vm_fault_t)0x008000,
> -	VM_FAULT_UFFD_MISSING	= (__force vm_fault_t)0x010000,
> -#else
> -	VM_FAULT_UFFD_MINOR	= (__force vm_fault_t)0x000000,
> -	VM_FAULT_UFFD_MISSING	= (__force vm_fault_t)0x000000,
> -#endif
>   	VM_FAULT_HINDEX_MASK    = (__force vm_fault_t)0x0f0000,
>   };
>   
> @@ -1664,9 +1653,7 @@ enum vm_fault_reason {
>   	{ VM_FAULT_FALLBACK,            "FALLBACK" },	\
>   	{ VM_FAULT_DONE_COW,            "DONE_COW" },	\
>   	{ VM_FAULT_NEEDDSYNC,           "NEEDDSYNC" },	\
> -	{ VM_FAULT_COMPLETED,           "COMPLETED" },	\
> -	{ VM_FAULT_UFFD_MINOR,		"UFFD_MINOR" }, \
> -	{ VM_FAULT_UFFD_MISSING,	"UFFD_MISSING" }
> +	{ VM_FAULT_COMPLETED,           "COMPLETED" }
>   
>   struct vm_special_mapping {
>   	const char *name;	/* The name, e.g. "[vdso]". */
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> index 75d5b09f2560c..5923e32de53b5 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -85,7 +85,7 @@ struct vm_uffd_ops {
>   	/* Checks if a VMA can support userfaultfd */
>   	bool (*can_userfault)(struct vm_area_struct *vma, vm_flags_t vm_flags);
>   	/*
> -	 * Called to resolve UFFDIO_CONTINUE request.
> +	 * Required by any uffd driver for either MISSING or MINOR fault.
>   	 * Should return the folio found at pgoff in the VMA's pagecache if it
>   	 * exists or ERR_PTR otherwise.
>   	 * The returned folio is locked and with reference held.
> diff --git a/mm/memory.c b/mm/memory.c
> index 456344938c72b..098febb761acc 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5338,6 +5338,33 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
>   	return VM_FAULT_OOM;
>   }
>   
> +static vm_fault_t fault_process_userfaultfd(struct vm_fault *vmf)
> +{
> +	struct vm_area_struct *vma = vmf->vma;
> +	struct inode *inode = file_inode(vma->vm_file);
> +	/*
> +	 * NOTE: we could double check this hook present when
> +	 * UFFDIO_REGISTER on MISSING or MINOR for a file driver.
> +	 */
> +	struct folio *folio =
> +	    vma->vm_ops->uffd_ops->get_folio_noalloc(inode, vmf->pgoff);
> +
> +	if (!IS_ERR_OR_NULL(folio)) {
> +		/*
> +		 * TODO: provide a flag for get_folio_noalloc() to avoid
> +		 * locking (or even the extra reference?)
> +		 */
> +		folio_unlock(folio);
> +		folio_put(folio);
> +		if (userfaultfd_minor(vma))
> +			return handle_userfault(vmf, VM_UFFD_MINOR);
> +	} else {
> +		return handle_userfault(vmf, VM_UFFD_MISSING);
> +	}
> +
> +	return 0;
> +}
> +
>   /*
>    * The mmap_lock must have been held on entry, and may have been
>    * released depending on flags and vma->vm_ops->fault() return value.
> @@ -5370,16 +5397,20 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
>   			return VM_FAULT_OOM;
>   	}
>   
> +	/*
> +	 * If this is an userfaultfd trap, process it in advance before
> +	 * triggering the genuine fault handler.
> +	 */
> +	if (userfaultfd_missing(vma) || userfaultfd_minor(vma)) {
> +		ret = fault_process_userfaultfd(vmf);
> +		if (ret)
> +			return ret;
> +	}
> +
>   	ret = vma->vm_ops->fault(vmf);
>   	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY |
> -			    VM_FAULT_DONE_COW | VM_FAULT_UFFD_MINOR |
> -			    VM_FAULT_UFFD_MISSING))) {
> -		if (ret & VM_FAULT_UFFD_MINOR)
> -			return handle_userfault(vmf, VM_UFFD_MINOR);
> -		if (ret & VM_FAULT_UFFD_MISSING)
> -			return handle_userfault(vmf, VM_UFFD_MISSING);
> +			    VM_FAULT_DONE_COW)))
>   		return ret;
> -	}
>   
>   	folio = page_folio(vmf->page);
>   	if (unlikely(PageHWPoison(vmf->page))) {
> diff --git a/mm/shmem.c b/mm/shmem.c
> index eafd7986fc2ec..5286f28b3e443 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2484,13 +2484,6 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
>   	fault_mm = vma ? vma->vm_mm : NULL;
>   
>   	folio = filemap_get_entry(inode->i_mapping, index);
> -	if (folio && vma && userfaultfd_minor(vma)) {
> -		if (!xa_is_value(folio))
> -			folio_put(folio);
> -		*fault_type = VM_FAULT_UFFD_MINOR;
> -		return 0;
> -	}
> -
>   	if (xa_is_value(folio)) {
>   		error = shmem_swapin_folio(inode, index, &folio,
>   					   sgp, gfp, vma, fault_type);
> @@ -2535,11 +2528,6 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
>   	 * Fast cache lookup and swap lookup did not find it: allocate.
>   	 */
>   
> -	if (vma && userfaultfd_missing(vma)) {
> -		*fault_type = VM_FAULT_UFFD_MISSING;
> -		return 0;
> -	}
> -
>   	/* Find hugepage orders that are allowed for anonymous shmem and tmpfs. */
>   	orders = shmem_allowable_huge_orders(inode, vma, index, write_end, false);
>   	if (orders > 0) {
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 14cca057fc0ec..bd0de685f42f8 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -421,26 +421,6 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>   	folio = __filemap_get_folio(inode->i_mapping, vmf->pgoff,
>   				    FGP_LOCK | FGP_ACCESSED, 0);
>   
> -	if (userfaultfd_armed(vmf->vma)) {
> -		/*
> -		 * If userfaultfd is registered in minor mode and a folio
> -		 * exists, return VM_FAULT_UFFD_MINOR to trigger the
> -		 * userfaultfd handler.
> -		 */
> -		if (userfaultfd_minor(vmf->vma) && !IS_ERR_OR_NULL(folio)) {
> -			ret = VM_FAULT_UFFD_MINOR;
> -			goto out_folio;
> -		}
> -
> -		/*
> -		 * Check if userfaultfd is registered in missing mode. If so,
> -		 * check if a folio exists in the page cache. If not, return
> -		 * VM_FAULT_UFFD_MISSING to trigger the userfaultfd handler.
> -		 */
> -		if (userfaultfd_missing(vmf->vma) && IS_ERR_OR_NULL(folio))
> -			return VM_FAULT_UFFD_MISSING;
> -	}
> -
>   	/* folio not in the pagecache, try to allocate */
>   	if (IS_ERR(folio))
>   		folio = __kvm_gmem_folio_alloc(inode, vmf->pgoff);

That looks better in general. We should likely find a better/more 
consistent name for fault_process_userfaultfd().

-- 
Cheers,

David

