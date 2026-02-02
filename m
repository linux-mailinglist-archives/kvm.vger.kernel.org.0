Return-Path: <kvm+bounces-69911-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 55NnFPgYgWm0EAMAu9opvQ
	(envelope-from <kvm+bounces-69911-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 22:36:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E2DBD1AE1
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 22:36:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 791E030069A6
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 21:36:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E202314A6F;
	Mon,  2 Feb 2026 21:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BF4fpmuH";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="UwaOcFWZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2032EDD41
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 21:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770068209; cv=none; b=djA2eth25qwyONUhbrw6EN+mDrow7BdBdGGG53Ns+eTdKPdT4wNMm8XO4ZFPgd4FshSRBZ5sinROutDaw//NXgKRxhmv+o3wBKtEVAgOt4nVUhoQhPEMfKqHPx3x1wjwIKeTJhE3g85FKYVqNUx93cWE6j34Q8PwbNnMdjkixok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770068209; c=relaxed/simple;
	bh=ujTwnjdDkYxavoL5yUeQEJJvWLWzdHcHxj+yIzSE5Gs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nkMOgrajnij4fyDYUWKyCJW5mAbWsEpXaC8w1n30QlCzyue0VijaErhbkksWsR5hm7XJgHa36gidaGaKb8VuB78S46l4ci7+UozV5uvhuDxcnQBjRYWxMRpBz61YJZuH3tasg/EHX3doCSC+vRcqHWdb18FyRg2szpqWBOYOj0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BF4fpmuH; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=UwaOcFWZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770068205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tzs5uA52PlIRNKdYJ64VWzNZOW1AOPr7kIlD0JLXrwM=;
	b=BF4fpmuHyfLTg3DFZRuY0M6s2xCU3gwWB6NBpWiLW0f2YJJffqCyqWcQCfqc77EtBsbsFI
	GrUSF0g6QQ5SNwCzGVwQuhM62vWdL/iqHKUpheghYqC2qva1sKbEZep5hqwuf9GNxxmEos
	RrIEmrEOR/7qd6ahOq/BL7KutRcKvO8=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-365-9r5JkingPXqSdhpf5oqHqQ-1; Mon, 02 Feb 2026 16:36:44 -0500
X-MC-Unique: 9r5JkingPXqSdhpf5oqHqQ-1
X-Mimecast-MFC-AGG-ID: 9r5JkingPXqSdhpf5oqHqQ_1770068204
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8c538971a16so1256270285a.1
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 13:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770068204; x=1770673004; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tzs5uA52PlIRNKdYJ64VWzNZOW1AOPr7kIlD0JLXrwM=;
        b=UwaOcFWZ+/a7sQKOW9A5BTrOxpvLWoO+OO8BBq06FlB3ZGKzcpEIgkJK8A2lvMtik0
         0lki4N3XmEtk1KQ4iLhPykhNLpmdRd3rAmcJktQ3xpFZlVMP1Q+XAXyBB1vb2LLGDVmb
         ljBh8gqGHxDlz4HU6dIGDK7EhTrT352yqB6+0eudeH0+3hqaxH6Vrov84TNMKQHSyJyq
         WmXxxu6Nk8OKu/+Xvcy9v+Xlh22UDxA65abbLh/7YIplzoIq+lfFPlPcI1qbLmWBl84d
         irevdbdMdMkAFf4cvzcg/E0qeDUv79YpZOAfMoZzpYbjb9g3EqomA32LbgnDFWxqVVwW
         jthw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770068204; x=1770673004;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tzs5uA52PlIRNKdYJ64VWzNZOW1AOPr7kIlD0JLXrwM=;
        b=KS0URP34NXtDVZiKGL/fMWsAhjr4INGkRH9nj7TuNEq41uTc4dGuKHtmW7XmvhMp9Q
         EDTABvtLkjMz69HljSBSIOIruU9mkO5DinJYXGOgcHxYCEagEvaccuLkMLA/YtDicFvS
         Q/+ngv2q3hsmeXeQ11o68Lt0WvIisMq5S3TFCBSS+L0NwrHAeKHvBsG8RYH7XMpe5diU
         lwv3t3InlHq+hJrPqBgXailR4k2uj8sUilPXb8vAR8z2UI1HlQ0DGyBHmzoG/o7RWFZ7
         O70Kh6leuExlbajEIXhdSWbP24OTVNXjKWgjchssQD43enWGp7sGqzrg8ASmgD6v3fm2
         NRsg==
X-Forwarded-Encrypted: i=1; AJvYcCUH78cyvUOufN/yOiDL6fBxZ1ok+tS7UTsYSkd7CgCAjz6TohJne2roBELg+9ORvII5sU8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLNrnLxKAR1w7ZGNmU28EURw5UXOCwvXLiFx/4hixXr+fl2GpG
	WOHoSQowo6Hkhq+BlHsCpLFbOMPu2/idaSLc9/QkO7gFx5j2R/p9YhKnxD+4IBylpyDVsJowImp
	2UDVGpqHeIVXps2YMq25pKL5Z5RF/eU3ci2ZJhlRImmKy5UBwWyZbDg==
X-Gm-Gg: AZuq6aJOswL28B+E4GtuXGp+BtzldURrUZOnUkwlJXBpNgmbnLQo0+fOobKeFSNjnng
	miglX9GlIKLopRlRMLuFTYd5mC6j4uYGnXxF/+NhT9Eu27IuKnqL8YVGCEv1MbwveU4MdPAnL5z
	4+xV4JcZOH8daMhjekX7Rjuq31EQ5UyRKqQk5IWDaeWncSJbalgrQo5OvWqhB7qoBL0BD0uvLIu
	iGfQrPwc+4S+EGTqsmqtCwBjFX1r+6Ec5atZjjW9iiQW9pEcJB8YrIagSwBhCIDTQXfUruy+6Hw
	4XeN+4F6Etc47bdmP2p8UKokfqPJw8sJQkJaxvN22AtJKM+s6mtgleS3pSJ/8IpCp3lKTPFx3BZ
	oC1A=
X-Received: by 2002:a05:620a:2550:b0:8c6:e20b:e6c6 with SMTP id af79cd13be357-8c9eb2e0cbcmr1754504885a.52.1770068203726;
        Mon, 02 Feb 2026 13:36:43 -0800 (PST)
X-Received: by 2002:a05:620a:2550:b0:8c6:e20b:e6c6 with SMTP id af79cd13be357-8c9eb2e0cbcmr1754500585a.52.1770068203138;
        Mon, 02 Feb 2026 13:36:43 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c711d2889asm1276000185a.27.2026.02.02.13.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 13:36:42 -0800 (PST)
Date: Mon, 2 Feb 2026 16:36:40 -0500
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
Subject: Re: [PATCH RFC 07/17] userfaultfd: introduce vm_uffd_ops
Message-ID: <aYEY6PC0Qfu0m5gu@x1.local>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-8-rppt@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260127192936.1250096-8-rppt@kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69911-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterx@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,x1.local:mid]
X-Rspamd-Queue-Id: 5E2DBD1AE1
X-Rspamd-Action: no action

On Tue, Jan 27, 2026 at 09:29:26PM +0200, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Current userfaultfd implementation works only with memory managed by
> core MM: anonymous, shmem and hugetlb.
> 
> First, there is no fundamental reason to limit userfaultfd support only
> to the core memory types and userfaults can be handled similarly to
> regular page faults provided a VMA owner implements appropriate
> callbacks.
> 
> Second, historically various code paths were conditioned on
> vma_is_anonymous(), vma_is_shmem() and is_vm_hugetlb_page() and some of
> these conditions can be expressed as operations implemented by a
> particular memory type.
> 
> Introduce vm_uffd_ops extension to vm_operations_struct that will
> delegate memory type specific operations to a VMA owner.
> 
> Operations for anonymous memory are handled internally in userfaultfd
> using anon_uffd_ops that implicitly assigned to anonymous VMAs.
> 
> Start with a single operation, ->can_userfault() that will verify that a
> VMA meets requirements for userfaultfd support at registration time.
> 
> Implement that method for anonymous, shmem and hugetlb and move relevant
> parts of vma_can_userfault() into the new callbacks.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  include/linux/mm.h            |  5 +++++
>  include/linux/userfaultfd_k.h |  6 +++++
>  mm/hugetlb.c                  | 21 ++++++++++++++++++
>  mm/shmem.c                    | 23 ++++++++++++++++++++
>  mm/userfaultfd.c              | 41 ++++++++++++++++++++++-------------
>  5 files changed, 81 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 15076261d0c2..3c2caff646c3 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -732,6 +732,8 @@ struct vm_fault {
>  					 */
>  };
>  
> +struct vm_uffd_ops;
> +
>  /*
>   * These are the virtual MM functions - opening of an area, closing and
>   * unmapping it (needed to keep files on disk up-to-date etc), pointer
> @@ -817,6 +819,9 @@ struct vm_operations_struct {
>  	struct page *(*find_normal_page)(struct vm_area_struct *vma,
>  					 unsigned long addr);
>  #endif /* CONFIG_FIND_NORMAL_PAGE */
> +#ifdef CONFIG_USERFAULTFD
> +	const struct vm_uffd_ops *uffd_ops;
> +#endif
>  };
>  
>  #ifdef CONFIG_NUMA_BALANCING
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> index a49cf750e803..56e85ab166c7 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -80,6 +80,12 @@ struct userfaultfd_ctx {
>  
>  extern vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason);
>  
> +/* VMA userfaultfd operations */
> +struct vm_uffd_ops {
> +	/* Checks if a VMA can support userfaultfd */
> +	bool (*can_userfault)(struct vm_area_struct *vma, vm_flags_t vm_flags);
> +};
> +
>  /* A combined operation mode + behavior flags. */
>  typedef unsigned int __bitwise uffd_flags_t;
>  
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 51273baec9e5..909131910c43 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -4797,6 +4797,24 @@ static vm_fault_t hugetlb_vm_op_fault(struct vm_fault *vmf)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_USERFAULTFD
> +static bool hugetlb_can_userfault(struct vm_area_struct *vma,
> +				  vm_flags_t vm_flags)
> +{
> +	/*
> +	 * If user requested uffd-wp but not enabled pte markers for
> +	 * uffd-wp, then hugetlb is not supported.
> +	 */
> +	if (!uffd_supports_wp_marker() && (vm_flags & VM_UFFD_WP))
> +		return false;

IMHO we don't need to dup this for every vm_uffd_ops driver.  It might be
unnecessary to even make driver be aware how pte marker plays the role
here, because pte markers are needed for all page cache file systems
anyway.  There should have no outliers.  Instead we can just let
can_userfault() report whether the driver generically supports userfaultfd,
leaving the detail checks for core mm.

I understand you wanted to also make anon to be a driver, so this line
won't apply to anon.  However IMHO anon is special enough so we can still
make this in the generic path.

> +	return true;
> +}
> +
> +static const struct vm_uffd_ops hugetlb_uffd_ops = {
> +	.can_userfault = hugetlb_can_userfault,
> +};
> +#endif
> +
>  /*
>   * When a new function is introduced to vm_operations_struct and added
>   * to hugetlb_vm_ops, please consider adding the function to shm_vm_ops.
> @@ -4810,6 +4828,9 @@ const struct vm_operations_struct hugetlb_vm_ops = {
>  	.close = hugetlb_vm_op_close,
>  	.may_split = hugetlb_vm_op_split,
>  	.pagesize = hugetlb_vm_op_pagesize,
> +#ifdef CONFIG_USERFAULTFD
> +	.uffd_ops = &hugetlb_uffd_ops,
> +#endif
>  };
>  
>  static pte_t make_huge_pte(struct vm_area_struct *vma, struct folio *folio,
> diff --git a/mm/shmem.c b/mm/shmem.c
> index ec6c01378e9d..9b82cda271c4 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -5290,6 +5290,23 @@ static const struct super_operations shmem_ops = {
>  #endif
>  };
>  
> +#ifdef CONFIG_USERFAULTFD
> +static bool shmem_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
> +{
> +	/*
> +	 * If user requested uffd-wp but not enabled pte markers for
> +	 * uffd-wp, then shmem is not supported.
> +	 */
> +	if (!uffd_supports_wp_marker() && (vm_flags & VM_UFFD_WP))
> +		return false;
> +	return true;
> +}
> +
> +static const struct vm_uffd_ops shmem_uffd_ops = {
> +	.can_userfault	= shmem_can_userfault,
> +};
> +#endif
> +
>  static const struct vm_operations_struct shmem_vm_ops = {
>  	.fault		= shmem_fault,
>  	.map_pages	= filemap_map_pages,
> @@ -5297,6 +5314,9 @@ static const struct vm_operations_struct shmem_vm_ops = {
>  	.set_policy     = shmem_set_policy,
>  	.get_policy     = shmem_get_policy,
>  #endif
> +#ifdef CONFIG_USERFAULTFD
> +	.uffd_ops	= &shmem_uffd_ops,
> +#endif
>  };
>  
>  static const struct vm_operations_struct shmem_anon_vm_ops = {
> @@ -5306,6 +5326,9 @@ static const struct vm_operations_struct shmem_anon_vm_ops = {
>  	.set_policy     = shmem_set_policy,
>  	.get_policy     = shmem_get_policy,
>  #endif
> +#ifdef CONFIG_USERFAULTFD
> +	.uffd_ops	= &shmem_uffd_ops,
> +#endif
>  };
>  
>  int shmem_init_fs_context(struct fs_context *fc)
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 786f0a245675..d035f5e17f07 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -34,6 +34,25 @@ struct mfill_state {
>  	pmd_t *pmd;
>  };
>  
> +static bool anon_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
> +{
> +	/* anonymous memory does not support MINOR mode */
> +	if (vm_flags & VM_UFFD_MINOR)
> +		return false;
> +	return true;
> +}
> +
> +static const struct vm_uffd_ops anon_uffd_ops = {
> +	.can_userfault	= anon_can_userfault,
> +};
> +
> +static const struct vm_uffd_ops *vma_uffd_ops(struct vm_area_struct *vma)
> +{
> +	if (vma_is_anonymous(vma))
> +		return &anon_uffd_ops;
> +	return vma->vm_ops ? vma->vm_ops->uffd_ops : NULL;
> +}
> +
>  static __always_inline
>  bool validate_dst_vma(struct vm_area_struct *dst_vma, unsigned long dst_end)
>  {
> @@ -2019,13 +2038,15 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
>  bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
>  		       bool wp_async)
>  {
> -	vm_flags &= __VM_UFFD_FLAGS;
> +	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
>  
> -	if (vma->vm_flags & VM_DROPPABLE)
> +	/* only VMAs that implement vm_uffd_ops are supported */
> +	if (!ops)
>  		return false;
>  
> -	if ((vm_flags & VM_UFFD_MINOR) &&
> -	    (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma)))
> +	vm_flags &= __VM_UFFD_FLAGS;
> +
> +	if (vma->vm_flags & VM_DROPPABLE)
>  		return false;
>  
>  	/*
> @@ -2035,18 +2056,8 @@ bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
>  	if (wp_async && (vm_flags == VM_UFFD_WP))
>  		return true;
>  
> -	/*
> -	 * If user requested uffd-wp but not enabled pte markers for
> -	 * uffd-wp, then shmem & hugetlbfs are not supported but only
> -	 * anonymous.
> -	 */
> -	if (!uffd_supports_wp_marker() && (vm_flags & VM_UFFD_WP) &&
> -	    !vma_is_anonymous(vma))
> -		return false;
> -
>  	/* By default, allow any of anon|shmem|hugetlb */
> -	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma) ||
> -	    vma_is_shmem(vma);
> +	return ops->can_userfault(vma, vm_flags);
>  }
>  
>  static void userfaultfd_set_vm_flags(struct vm_area_struct *vma,
> -- 
> 2.51.0
> 

-- 
Peter Xu


