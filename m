Return-Path: <kvm+bounces-70086-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4BKFNwVhgmkzTQMAu9opvQ
	(envelope-from <kvm+bounces-70086-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 21:56:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 74E67DEAD7
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 21:56:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 25ADE3064524
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 20:56:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA433342CAE;
	Tue,  3 Feb 2026 20:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PqP2q59l";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="o9rxQXhZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124392ED87F
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 20:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770152176; cv=none; b=ikg3m/3k5IrlL35mNWXFjr3I65+lFcZVLOIJcVH2ZpB1xvf+dn86/EtwBGRpUlZoNhTduOf6MmRbcznQQoYuR6qFHuA663a4/kKqYOQKwTy/1l0bb/hNr/vrFXWb3tyz/zjfa+ZDjJrUoLbLra3hpx0xATC7AiUNR9gyenOSsts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770152176; c=relaxed/simple;
	bh=TxhDDIsrmNPryvMJxA7I0wWrM51G0+YKn8PA6nC9juI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q16vIR7Wx8BgPygTieuK8XVBZ60+NQaqBSumZHZl9hYL6QF5GUqpFFYyctL8ZU4ZD4yFjZdZ4up0G2P7V9nZKCnVyZ4UUMAxqONL4rdj/TDKfW+SbB0XOWi/ExjMiEwUQp31TU4McMcm3ZEKNrLMIkPnceKtRD4SADrYMMOTRwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PqP2q59l; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=o9rxQXhZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770152172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OwRl5rPitk/eF4i9o9ZxWYkLMwqq6COPXHVuVOqJ7X0=;
	b=PqP2q59lV5W7EOJqmoUC5UomklzFYVdOPtRewRzgqLCX5JQjYXtZrWvqFdRGLekusSO8Gi
	9cA2mLL88lf/9rkJnkvYhXBTG5E1cJV4BYhIXIDu2eJiqUo1/HXbwJ/CaG/l3lUWBQf3Bd
	RcdenTMklD91vSQhtMwGvzrzjivplIA=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-6h95gI4rOWuGGcbLlCaVOA-1; Tue, 03 Feb 2026 15:56:11 -0500
X-MC-Unique: 6h95gI4rOWuGGcbLlCaVOA-1
X-Mimecast-MFC-AGG-ID: 6h95gI4rOWuGGcbLlCaVOA_1770152170
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-50148a2a5baso4266171cf.2
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 12:56:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770152170; x=1770756970; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OwRl5rPitk/eF4i9o9ZxWYkLMwqq6COPXHVuVOqJ7X0=;
        b=o9rxQXhZ+ZdyGOnIkRLlmsm+ZrWZLIFIAIn8gdPkMclu0t1v08E97r7tKaDfBV9yl6
         voBd1Wek02NyqzAzojXfWXJCW0+hZTKcb5KnIZ/1SGerC/yOX+e0eVAWX0+lf9AeA5Yn
         qqRQLlnKrxlY5zz/P7K9eJ6ZkXOLZtOnYuD0PYbrVnJ3oUpCCj5dJW0Uhh6pG1LlER8z
         iNR7y45MCKCtKICPl7m0UTraVB559/UjM5kpLeCQKf6emCfmxvnKZte1+h3AdYN6F6/s
         BoSSrUiwOFHv44DLQs2j8Ws7QjavrEGUzdDezf/3EDiwCIx68ffidOILdPBtbHGQOU+e
         IiaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770152170; x=1770756970;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OwRl5rPitk/eF4i9o9ZxWYkLMwqq6COPXHVuVOqJ7X0=;
        b=IPhP3jHGF2udtUmN9hp+Xb+ScfYvWZoblr/LcMDeC9iaHIZIwcOWfsbEpKU5KRO/8V
         pEUcW4MWnD5/WCgG5vU45mqDtSA59vlRqQ2MAYQp68rloztj8lRGWwUnnk/+ZzmJXLiM
         EzEMNj+t8OBVnKiUN5yduUr/6rh2xyWUaIaHy4onGBHHOHqnox+EVWKb/C9Q8cU5fSbk
         sRMdF7noUszWR0Zg8vaGs6KOHqsVgXOFyzjt1YPhTNz3O/17YmZBDcO2U5AsnFE11d3x
         HJHEHjujUVOAFnyFHlSv59UDFwdP/Qjag1y90jir/X/PbiYZSB24IewroebddGq38Xcr
         C0IA==
X-Forwarded-Encrypted: i=1; AJvYcCUQ6xLlKvRdar9fMmBBXec/Bnw5hE/0CGelUkD4gWK6DKsHNIJqiIiGm9Wqra47sDwAhCI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQU1lpRDfNRd/OxhkSXcKD+7Z/QqNSi5dSQ56HhQkEozMDXXOq
	H8B4bccET61UsyFxf6x9Pade53+bFJ7H10IQ8h6pzsft62ZE21c4+GCCpCLLF1smWdwiijCJxEN
	jSW9V5l+XUFKWE7YUoqMpsIHpgctjeUNkUVQYyINs/zFCx/9NGo6Chw==
X-Gm-Gg: AZuq6aLi7C0RHVl/z7zYaMp/sB6FyrW3U3E8/8g87Zfru0slCzncxVwbqRUsq8GXgi7
	g83FfMac/FSsOKQLzb2MW05uQxwk9nb8eRE1cf0NN2gxpaaTXbXaNSLDQxhVAlO1X6NMnYyQ94p
	mexO/g5iWz3saARWSNFNYFjVsHtM18og+azTh3/w/mWPT/RyeoYqGDBHE4BLMhjQATZKbHIZ5dD
	liY+s7Ov/e5UsXO8UnYuNwHuanjNx3Qclfh8W2EcW7odYm4udsW2oSkBj8RFN3qpi58malH1Ou3
	raWkvtwfLCQ0EP1SlflyIIdKW1D6nhNvmU2ZH1UXLvQWi6pyzKW+Cog9Y46f1OIYhIea+qbiYdU
	9gZI=
X-Received: by 2002:a05:622a:1207:b0:500:f02d:1c55 with SMTP id d75a77b69052e-5061c1b7f43mr9598701cf.57.1770152170293;
        Tue, 03 Feb 2026 12:56:10 -0800 (PST)
X-Received: by 2002:a05:622a:1207:b0:500:f02d:1c55 with SMTP id d75a77b69052e-5061c1b7f43mr9598341cf.57.1770152169738;
        Tue, 03 Feb 2026 12:56:09 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ca2fd41335sm47631285a.38.2026.02.03.12.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 12:56:09 -0800 (PST)
Date: Tue, 3 Feb 2026 15:56:06 -0500
From: Peter Xu <peterx@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 00/17] mm, kvm: allow uffd suppot in guest_memfd
Message-ID: <aYJg5lT9MG0BQFkG@x1.local>
References: <20260127192936.1250096-1-rppt@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260127192936.1250096-1-rppt@kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70086-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterx@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,x1.local:mid]
X-Rspamd-Queue-Id: 74E67DEAD7
X-Rspamd-Action: no action

On Tue, Jan 27, 2026 at 09:29:19PM +0200, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Hi,
> 
> These patches enable support for userfaultfd in guest_memfd.
> They are quite different from the latest posting [1] so I'm restarting the
> versioning. As there was a lot of tension around the topic, this is an RFC
> to get some feedback and see how we can move forward.
> 
> As the ground work I refactored userfaultfd handling of PTE-based memory types
> (anonymous and shmem) and converted them to use vm_uffd_ops for allocating a
> folio or getting an existing folio from the page cache. shmem also implements
> callbacks that add a folio to the page cache after the data passed in
> UFFDIO_COPY was copied and remove the folio from the page cache if page table
> update fails.
> 
> In order for guest_memfd to notify userspace about page faults, there are new
> VM_FAULT_UFFD_MINOR and VM_FAULT_UFFD_MISSING that a ->fault() handler can
> return to inform the page fault handler that it needs to call
> handle_userfault() to complete the fault.
> 
> Nikita helped to plumb these new goodies into guest_memfd and provided basic
> tests to verify that guest_memfd works with userfaultfd.
> 
> I deliberately left hugetlb out, at least for the most part.
> hugetlb handles acquisition of VMA and more importantly establishing of parent
> page table entry differently than PTE-based memory types. This is a different
> abstraction level than what vm_uffd_ops provides and people objected to
> exposing such low level APIs as a part of VMA operations.
> 
> Also, to enable uffd in guest_memfd refactoring of hugetlb is not needed and I
> prefer to delay it until the dust settles after the changes in this set.
> 
> [1] https://lore.kernel.org/all/20251130111812.699259-1-rppt@kernel.org
> 
> Mike Rapoport (Microsoft) (12):
>   userfaultfd: introduce mfill_copy_folio_locked() helper
>   userfaultfd: introduce struct mfill_state
>   userfaultfd: introduce mfill_get_pmd() helper.
>   userfaultfd: introduce mfill_get_vma() and mfill_put_vma()
>   userfaultfd: retry copying with locks dropped in mfill_atomic_pte_copy()
>   userfaultfd: move vma_can_userfault out of line
>   userfaultfd: introduce vm_uffd_ops
>   userfaultfd, shmem: use a VMA callback to handle UFFDIO_CONTINUE
>   userfaultfd: introduce vm_uffd_ops->alloc_folio()
>   shmem, userfaultfd: implement shmem uffd operations using vm_uffd_ops
>   userfaultfd: mfill_atomic() remove retry logic
>   mm: introduce VM_FAULT_UFFD_MINOR fault reason
> 
> Nikita Kalyazin (5):
>   mm: introduce VM_FAULT_UFFD_MISSING fault reason
>   KVM: guest_memfd: implement userfaultfd minor mode
>   KVM: guest_memfd: implement userfaultfd missing mode
>   KVM: selftests: test userfaultfd minor for guest_memfd
>   KVM: selftests: test userfaultfd missing for guest_memfd
> 
>  include/linux/mm.h                            |   5 +
>  include/linux/mm_types.h                      |  15 +-
>  include/linux/shmem_fs.h                      |  14 -
>  include/linux/userfaultfd_k.h                 |  74 +-
>  mm/hugetlb.c                                  |  21 +
>  mm/memory.c                                   |   8 +-
>  mm/shmem.c                                    | 188 +++--
>  mm/userfaultfd.c                              | 671 ++++++++++--------
>  .../testing/selftests/kvm/guest_memfd_test.c  | 191 +++++
>  virt/kvm/guest_memfd.c                        | 134 +++-
>  10 files changed, 871 insertions(+), 450 deletions(-)

Mike,

The idea looks good to me, thanks for this work!  Your process on
UFFDIO_COPY over anon/shmem is nice to me.

If you remember, I used to raise a concern on introducing two new fault
retvals only for userfaultfd:

https://lore.kernel.org/all/aShb8J18BaRrsA-u@x1.local/

IMHO they're not only unnecessarily leaking userfaultfd information into
fault core definitions, but also cause code duplications.  I still think we
should avoid them.

This time, I've attached a smoke tested patch removing both of them.

It's pretty small and it runs all fine with all old/new userfaultfd tests
(including gmem ones). Feel free to have a look at the end.

I understand you want to avoid adding mnore complexity to this series, if
you want I can also prepare such a patch after this series landed to remove
the two retvals.  I'd still would like to know how you think about it,
though, let me know if you have any comments.

Note that it may indeed need some perf tests to make sure there's zero
overhead after this change.  Currently there's still some trivial overheads
(e.g. unnecessary folio locks), but IIUC we can even avoid that.

Thanks,

===8<===
From 5379d084494b17281f3e5365104a7edbdbe53759 Mon Sep 17 00:00:00 2001
From: Peter Xu <peterx@redhat.com>
Date: Tue, 3 Feb 2026 15:07:58 -0500
Subject: [PATCH] mm/userfaultfd: Remove two userfaultfd fault retvals

They're not needed when with vm_uffd_ops.  We can remove both of them.
Actually, another side benefit is drivers do not need to process
userfaultfd missing / minor faults anymore in the main fault handler.

This patch will make get_folio_noalloc() required for either MISSING or
MINOR fault, but that's not a problem, as it should be lightweight and the
current only outside-mm user (gmem) will support both anyway.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/mm_types.h      | 15 +-----------
 include/linux/userfaultfd_k.h |  2 +-
 mm/memory.c                   | 45 +++++++++++++++++++++++++++++------
 mm/shmem.c                    | 12 ----------
 virt/kvm/guest_memfd.c        | 20 ----------------
 5 files changed, 40 insertions(+), 54 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index a6d32470a78a3..3cc8ae7228860 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1612,10 +1612,6 @@ typedef __bitwise unsigned int vm_fault_t;
  *				fsync() to complete (for synchronous page faults
  *				in DAX)
  * @VM_FAULT_COMPLETED:		->fault completed, meanwhile mmap lock released
- * @VM_FAULT_UFFD_MINOR:	->fault did not modify page tables and needs
- *				handle_userfault(VM_UFFD_MINOR) to complete
- * @VM_FAULT_UFFD_MISSING:	->fault did not modify page tables and needs
- *				handle_userfault(VM_UFFD_MISSING) to complete
  * @VM_FAULT_HINDEX_MASK:	mask HINDEX value
  *
  */
@@ -1633,13 +1629,6 @@ enum vm_fault_reason {
 	VM_FAULT_DONE_COW       = (__force vm_fault_t)0x001000,
 	VM_FAULT_NEEDDSYNC      = (__force vm_fault_t)0x002000,
 	VM_FAULT_COMPLETED      = (__force vm_fault_t)0x004000,
-#ifdef CONFIG_USERFAULTFD
-	VM_FAULT_UFFD_MINOR	= (__force vm_fault_t)0x008000,
-	VM_FAULT_UFFD_MISSING	= (__force vm_fault_t)0x010000,
-#else
-	VM_FAULT_UFFD_MINOR	= (__force vm_fault_t)0x000000,
-	VM_FAULT_UFFD_MISSING	= (__force vm_fault_t)0x000000,
-#endif
 	VM_FAULT_HINDEX_MASK    = (__force vm_fault_t)0x0f0000,
 };
 
@@ -1664,9 +1653,7 @@ enum vm_fault_reason {
 	{ VM_FAULT_FALLBACK,            "FALLBACK" },	\
 	{ VM_FAULT_DONE_COW,            "DONE_COW" },	\
 	{ VM_FAULT_NEEDDSYNC,           "NEEDDSYNC" },	\
-	{ VM_FAULT_COMPLETED,           "COMPLETED" },	\
-	{ VM_FAULT_UFFD_MINOR,		"UFFD_MINOR" }, \
-	{ VM_FAULT_UFFD_MISSING,	"UFFD_MISSING" }
+	{ VM_FAULT_COMPLETED,           "COMPLETED" }
 
 struct vm_special_mapping {
 	const char *name;	/* The name, e.g. "[vdso]". */
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index 75d5b09f2560c..5923e32de53b5 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -85,7 +85,7 @@ struct vm_uffd_ops {
 	/* Checks if a VMA can support userfaultfd */
 	bool (*can_userfault)(struct vm_area_struct *vma, vm_flags_t vm_flags);
 	/*
-	 * Called to resolve UFFDIO_CONTINUE request.
+	 * Required by any uffd driver for either MISSING or MINOR fault.
 	 * Should return the folio found at pgoff in the VMA's pagecache if it
 	 * exists or ERR_PTR otherwise.
 	 * The returned folio is locked and with reference held.
diff --git a/mm/memory.c b/mm/memory.c
index 456344938c72b..098febb761acc 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5338,6 +5338,33 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 	return VM_FAULT_OOM;
 }
 
+static vm_fault_t fault_process_userfaultfd(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct inode *inode = file_inode(vma->vm_file);
+	/*
+	 * NOTE: we could double check this hook present when
+	 * UFFDIO_REGISTER on MISSING or MINOR for a file driver.
+	 */
+	struct folio *folio =
+	    vma->vm_ops->uffd_ops->get_folio_noalloc(inode, vmf->pgoff);
+
+	if (!IS_ERR_OR_NULL(folio)) {
+		/*
+		 * TODO: provide a flag for get_folio_noalloc() to avoid
+		 * locking (or even the extra reference?)
+		 */
+		folio_unlock(folio);
+		folio_put(folio);
+		if (userfaultfd_minor(vma))
+			return handle_userfault(vmf, VM_UFFD_MINOR);
+	} else {
+		return handle_userfault(vmf, VM_UFFD_MISSING);
+	}
+
+	return 0;
+}
+
 /*
  * The mmap_lock must have been held on entry, and may have been
  * released depending on flags and vma->vm_ops->fault() return value.
@@ -5370,16 +5397,20 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
 			return VM_FAULT_OOM;
 	}
 
+	/*
+	 * If this is an userfaultfd trap, process it in advance before
+	 * triggering the genuine fault handler.
+	 */
+	if (userfaultfd_missing(vma) || userfaultfd_minor(vma)) {
+		ret = fault_process_userfaultfd(vmf);
+		if (ret)
+			return ret;
+	}
+
 	ret = vma->vm_ops->fault(vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY |
-			    VM_FAULT_DONE_COW | VM_FAULT_UFFD_MINOR |
-			    VM_FAULT_UFFD_MISSING))) {
-		if (ret & VM_FAULT_UFFD_MINOR)
-			return handle_userfault(vmf, VM_UFFD_MINOR);
-		if (ret & VM_FAULT_UFFD_MISSING)
-			return handle_userfault(vmf, VM_UFFD_MISSING);
+			    VM_FAULT_DONE_COW)))
 		return ret;
-	}
 
 	folio = page_folio(vmf->page);
 	if (unlikely(PageHWPoison(vmf->page))) {
diff --git a/mm/shmem.c b/mm/shmem.c
index eafd7986fc2ec..5286f28b3e443 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2484,13 +2484,6 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	fault_mm = vma ? vma->vm_mm : NULL;
 
 	folio = filemap_get_entry(inode->i_mapping, index);
-	if (folio && vma && userfaultfd_minor(vma)) {
-		if (!xa_is_value(folio))
-			folio_put(folio);
-		*fault_type = VM_FAULT_UFFD_MINOR;
-		return 0;
-	}
-
 	if (xa_is_value(folio)) {
 		error = shmem_swapin_folio(inode, index, &folio,
 					   sgp, gfp, vma, fault_type);
@@ -2535,11 +2528,6 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	 * Fast cache lookup and swap lookup did not find it: allocate.
 	 */
 
-	if (vma && userfaultfd_missing(vma)) {
-		*fault_type = VM_FAULT_UFFD_MISSING;
-		return 0;
-	}
-
 	/* Find hugepage orders that are allowed for anonymous shmem and tmpfs. */
 	orders = shmem_allowable_huge_orders(inode, vma, index, write_end, false);
 	if (orders > 0) {
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 14cca057fc0ec..bd0de685f42f8 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -421,26 +421,6 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 	folio = __filemap_get_folio(inode->i_mapping, vmf->pgoff,
 				    FGP_LOCK | FGP_ACCESSED, 0);
 
-	if (userfaultfd_armed(vmf->vma)) {
-		/*
-		 * If userfaultfd is registered in minor mode and a folio
-		 * exists, return VM_FAULT_UFFD_MINOR to trigger the
-		 * userfaultfd handler.
-		 */
-		if (userfaultfd_minor(vmf->vma) && !IS_ERR_OR_NULL(folio)) {
-			ret = VM_FAULT_UFFD_MINOR;
-			goto out_folio;
-		}
-
-		/*
-		 * Check if userfaultfd is registered in missing mode. If so,
-		 * check if a folio exists in the page cache. If not, return
-		 * VM_FAULT_UFFD_MISSING to trigger the userfaultfd handler.
-		 */
-		if (userfaultfd_missing(vmf->vma) && IS_ERR_OR_NULL(folio))
-			return VM_FAULT_UFFD_MISSING;
-	}
-
 	/* folio not in the pagecache, try to allocate */
 	if (IS_ERR(folio))
 		folio = __kvm_gmem_folio_alloc(inode, vmf->pgoff);
-- 
2.50.1


-- 
Peter Xu


