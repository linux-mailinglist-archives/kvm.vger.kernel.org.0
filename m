Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D21424E7442
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 14:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356520AbiCYNf7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 09:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345662AbiCYNf4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 09:35:56 -0400
Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2334B42A04
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 06:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1648215252;
        bh=QQwVDGD8oOKcI53tbJIu5zeSFqME8ho6LLmA81Kew9k=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=k/DHveUXU5OrrXVs7z8RepdnaM+xrA0tF4rgj3j0FMUpRuXic91nnirZ9fUd3ZkWy
         MDNdbJH7FKZMqA3q4Kvb/43pcALcUM0ISjY4bQ0Z7SQyOyZvMayzT5Fq4bGUNILQRy
         Y6van+uQ3YkZcdxASVL5+L5XB6TIjJFsbwlrOMvQ=
Received: from [IPv6:240e:362:43d:2e00:a8cc:839b:6dc9:9656] ([240e:362:43d:2e00:a8cc:839b:6dc9:9656])
        by newxmesmtplogicsvrsza9.qq.com (NewEsmtp) with SMTP
        id 888B0671; Fri, 25 Mar 2022 21:34:08 +0800
X-QQ-mid: xmsmtpt1648215248t8xgz82xf
Message-ID: <tencent_084E04DAF68A9A6613541A74836007D02006@qq.com>
X-QQ-XMAILINFO: NhUkPfKlCtQwLcveN0dwLOb1cLWfBFBFbdKtiQ51BSOxyt0Qg8TGaPIWGwX/MQ
         9zQcOwQYUfxXIjY82SWPrIS8dqMC+N/PxVg80oCkOQ208iiKZVPkkvO81q4h1af0Wpe+lyU+30ef
         3xW7esnqQpanJdtoUlE0AkqFr5Yp+tXn60CUTOfpvry86IsmRBzF0IH/GgWgpZkhKTN4hFvVjDPg
         Hj8R2jl+eCiz8SL/yFUBTNIrOP6P9qyEJ+89ES1vMf1Rtk7fCdRpmQQvHwAC0Mg1y9y3DrY5pods
         fnPGiRXzgBV3cv5oKuksPV50jRAYttX4PbTpgkkevQTtoo1p6z5eue6BsXX9SOge+J56Q6C6AhDQ
         F304qM5F89IXRVy2p/BtjqR3iL2oxv2sTj/TslLDIMnudXYbzWPTUHEmOLliH+J0ojopEP7/ioJn
         np9maFx/UetYZ4tEgf+8dvyyzBmYUzep9DWIlDX69e18JqVdcKZZO6o6D3sPT95+N0Kh+rmcjVPy
         F3xP0vcKrMHaYifFadKmfVlrXwQZuYRm4BGYNwCQIcBo4DtMq182LYuwxcdcG4Q4TD+rHDt+GC6B
         fjcuUfIe2Px9YJiwQ6j8wSErUIES+byFvtjxqTZ0UbTa06kwuabaGsNBBzyYL3KKDcwwuwOz3orl
         rZM2LDovIY/BFcSzO0jOJ+THWTKJMz5c4y/2WgjTuqqEHFgpcTxtNdAF7uLjZ98SS8weSRPtpKnY
         qabJnN9z/KnIJ1hhb9EmZCs87kIkor/AisRA90Q2V3kiPgAZ1faxYyvvRYJnKUbXWZBj8PwCFvKV
         1lurxz3u9HIXFi7G/DY7o0idSATwsAoiJ2KHrYUKfYanrWMvmqGpBbbjDTBCD+X7rdc++1Vehyq6
         eDPuAnuTqLO6uJiCGDl5lioZQU6Zo17Lj5/3s25C1YYdvBw/p6a5Esfvot2FDVrD3b27zbtTQY
Subject: Re: [PATCH RFC 07/12] iommufd: Data structure to provide IOVA to PFN
 mapping
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        iommu@lists.linux-foundation.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>
References: <7-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
From:   "zhangfei.gao@foxmail.com" <zhangfei.gao@foxmail.com>
X-OQ-MSGID: <99e788b3-5b9d-48b8-ed0b-abfb5a9a53b8@foxmail.com>
Date:   Fri, 25 Mar 2022 21:34:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_FROM,HELO_DYNAMIC_IPADDR,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,RDNS_DYNAMIC,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Jason

On 2022/3/19 上午1:27, Jason Gunthorpe via iommu wrote:
> This is the remainder of the IOAS data structure. Provide an object called
> an io_pagetable that is composed of iopt_areas pointing at iopt_pages,
> along with a list of iommu_domains that mirror the IOVA to PFN map.
>
> At the top this is a simple interval tree of iopt_areas indicating the map
> of IOVA to iopt_pages. An xarray keeps track of a list of domains. Based
> on the attached domains there is a minimum alignment for areas (which may
> be smaller than PAGE_SIZE) and an interval tree of reserved IOVA that
> can't be mapped.
>
> The concept of a 'user' refers to something like a VFIO mdev that is
> accessing the IOVA and using a 'struct page *' for CPU based access.
>
> Externally an API is provided that matches the requirements of the IOCTL
> interface for map/unmap and domain attachment.
>
> The API provides a 'copy' primitive to establish a new IOVA map in a
> different IOAS from an existing mapping.
>
> This is designed to support a pre-registration flow where userspace would
> setup an dummy IOAS with no domains, map in memory and then establish a
> user to pin all PFNs into the xarray.
>
> Copy can then be used to create new IOVA mappings in a different IOAS,
> with iommu_domains attached. Upon copy the PFNs will be read out of the
> xarray and mapped into the iommu_domains, avoiding any pin_user_pages()
> overheads.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/iommufd/Makefile          |   1 +
>   drivers/iommu/iommufd/io_pagetable.c    | 890 ++++++++++++++++++++++++
>   drivers/iommu/iommufd/iommufd_private.h |  35 +
>   3 files changed, 926 insertions(+)
>   create mode 100644 drivers/iommu/iommufd/io_pagetable.c
>
> diff --git a/drivers/iommu/iommufd/Makefile b/drivers/iommu/iommufd/Makefile
> index 05a0e91e30afad..b66a8c47ff55ec 100644
> --- a/drivers/iommu/iommufd/Makefile
> +++ b/drivers/iommu/iommufd/Makefile
> @@ -1,5 +1,6 @@
>   # SPDX-License-Identifier: GPL-2.0-only
>   iommufd-y := \
> +	io_pagetable.o \
>   	main.o \
>   	pages.o
>   
> diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
> new file mode 100644
> index 00000000000000..f9f3b06946bfb9
> --- /dev/null
> +++ b/drivers/iommu/iommufd/io_pagetable.c
> @@ -0,0 +1,890 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES.
> + *
> + * The io_pagetable is the top of datastructure that maps IOVA's to PFNs. The
> + * PFNs can be placed into an iommu_domain, or returned to the caller as a page
> + * list for access by an in-kernel user.
> + *
> + * The datastructure uses the iopt_pages to optimize the storage of the PFNs
> + * between the domains and xarray.
> + */
> +#include <linux/lockdep.h>
> +#include <linux/iommu.h>
> +#include <linux/sched/mm.h>
> +#include <linux/err.h>
> +#include <linux/slab.h>
> +#include <linux/errno.h>
> +
> +#include "io_pagetable.h"
> +
> +static unsigned long iopt_area_iova_to_index(struct iopt_area *area,
> +					     unsigned long iova)
> +{
> +	if (IS_ENABLED(CONFIG_IOMMUFD_TEST))
> +		WARN_ON(iova < iopt_area_iova(area) ||
> +			iova > iopt_area_last_iova(area));
> +	return (iova - (iopt_area_iova(area) & PAGE_MASK)) / PAGE_SIZE;
> +}
> +
> +static struct iopt_area *iopt_find_exact_area(struct io_pagetable *iopt,
> +					      unsigned long iova,
> +					      unsigned long last_iova)
> +{
> +	struct iopt_area *area;
> +
> +	area = iopt_area_iter_first(iopt, iova, last_iova);
> +	if (!area || !area->pages || iopt_area_iova(area) != iova ||
> +	    iopt_area_last_iova(area) != last_iova)
> +		return NULL;
> +	return area;
> +}
> +
> +static bool __alloc_iova_check_hole(struct interval_tree_span_iter *span,
> +				    unsigned long length,
> +				    unsigned long iova_alignment,
> +				    unsigned long page_offset)
> +{
> +	if (!span->is_hole || span->last_hole - span->start_hole < length - 1)
> +		return false;
> +
> +	span->start_hole =
> +		ALIGN(span->start_hole, iova_alignment) | page_offset;
> +	if (span->start_hole > span->last_hole ||
> +	    span->last_hole - span->start_hole < length - 1)
> +		return false;
> +	return true;
> +}
> +
> +/*
> + * Automatically find a block of IOVA that is not being used and not reserved.
> + * Does not return a 0 IOVA even if it is valid.
> + */
> +static int iopt_alloc_iova(struct io_pagetable *iopt, unsigned long *iova,
> +			   unsigned long uptr, unsigned long length)
> +{
> +	struct interval_tree_span_iter reserved_span;
> +	unsigned long page_offset = uptr % PAGE_SIZE;
> +	struct interval_tree_span_iter area_span;
> +	unsigned long iova_alignment;
> +
> +	lockdep_assert_held(&iopt->iova_rwsem);
> +
> +	/* Protect roundup_pow-of_two() from overflow */
> +	if (length == 0 || length >= ULONG_MAX / 2)
> +		return -EOVERFLOW;
> +
> +	/*
> +	 * Keep alignment present in the uptr when building the IOVA, this
> +	 * increases the chance we can map a THP.
> +	 */
> +	if (!uptr)
> +		iova_alignment = roundup_pow_of_two(length);
> +	else
> +		iova_alignment =
> +			min_t(unsigned long, roundup_pow_of_two(length),
> +			      1UL << __ffs64(uptr));
> +
> +	if (iova_alignment < iopt->iova_alignment)
> +		return -EINVAL;
> +	for (interval_tree_span_iter_first(&area_span, &iopt->area_itree,
> +					   PAGE_SIZE, ULONG_MAX - PAGE_SIZE);
> +	     !interval_tree_span_iter_done(&area_span);
> +	     interval_tree_span_iter_next(&area_span)) {
> +		if (!__alloc_iova_check_hole(&area_span, length, iova_alignment,
> +					     page_offset))
> +			continue;
> +
> +		for (interval_tree_span_iter_first(
> +			     &reserved_span, &iopt->reserved_iova_itree,
> +			     area_span.start_hole, area_span.last_hole);
> +		     !interval_tree_span_iter_done(&reserved_span);
> +		     interval_tree_span_iter_next(&reserved_span)) {
> +			if (!__alloc_iova_check_hole(&reserved_span, length,
> +						     iova_alignment,
> +						     page_offset))
> +				continue;
> +
> +			*iova = reserved_span.start_hole;
> +			return 0;
> +		}
> +	}
> +	return -ENOSPC;
> +}
> +
> +/*
> + * The area takes a slice of the pages from start_bytes to start_byte + length
> + */
> +static struct iopt_area *
> +iopt_alloc_area(struct io_pagetable *iopt, struct iopt_pages *pages,
> +		unsigned long iova, unsigned long start_byte,
> +		unsigned long length, int iommu_prot, unsigned int flags)
> +{
> +	struct iopt_area *area;
> +	int rc;
> +
> +	area = kzalloc(sizeof(*area), GFP_KERNEL);
> +	if (!area)
> +		return ERR_PTR(-ENOMEM);
> +
> +	area->iopt = iopt;
> +	area->iommu_prot = iommu_prot;
> +	area->page_offset = start_byte % PAGE_SIZE;
> +	area->pages_node.start = start_byte / PAGE_SIZE;
> +	if (check_add_overflow(start_byte, length - 1, &area->pages_node.last))
> +		return ERR_PTR(-EOVERFLOW);
> +	area->pages_node.last = area->pages_node.last / PAGE_SIZE;
> +	if (WARN_ON(area->pages_node.last >= pages->npages))
> +		return ERR_PTR(-EOVERFLOW);
> +
> +	down_write(&iopt->iova_rwsem);
> +	if (flags & IOPT_ALLOC_IOVA) {
> +		rc = iopt_alloc_iova(iopt, &iova,
> +				     (uintptr_t)pages->uptr + start_byte,
> +				     length);
> +		if (rc)
> +			goto out_unlock;
> +	}
> +
> +	if (check_add_overflow(iova, length - 1, &area->node.last)) {
> +		rc = -EOVERFLOW;
> +		goto out_unlock;
> +	}
> +
> +	if (!(flags & IOPT_ALLOC_IOVA)) {
> +		if ((iova & (iopt->iova_alignment - 1)) ||
> +		    (length & (iopt->iova_alignment - 1)) || !length) {
> +			rc = -EINVAL;
> +			goto out_unlock;
> +		}
> +
> +		/* No reserved IOVA intersects the range */
> +		if (interval_tree_iter_first(&iopt->reserved_iova_itree, iova,
> +					     area->node.last)) {
> +			rc = -ENOENT;
> +			goto out_unlock;
> +		}
> +
> +		/* Check that there is not already a mapping in the range */
> +		if (iopt_area_iter_first(iopt, iova, area->node.last)) {
> +			rc = -EADDRINUSE;
> +			goto out_unlock;
> +		}
> +	}
> +
> +	/*
> +	 * The area is inserted with a NULL pages indicating it is not fully
> +	 * initialized yet.
> +	 */
> +	area->node.start = iova;
> +	interval_tree_insert(&area->node, &area->iopt->area_itree);
> +	up_write(&iopt->iova_rwsem);
> +	return area;
> +
> +out_unlock:
> +	up_write(&iopt->iova_rwsem);
> +	kfree(area);
> +	return ERR_PTR(rc);
> +}
> +
> +static void iopt_abort_area(struct iopt_area *area)
> +{
> +	down_write(&area->iopt->iova_rwsem);
> +	interval_tree_remove(&area->node, &area->iopt->area_itree);
> +	up_write(&area->iopt->iova_rwsem);
> +	kfree(area);
> +}
> +
> +static int iopt_finalize_area(struct iopt_area *area, struct iopt_pages *pages)
> +{
> +	int rc;
> +
> +	down_read(&area->iopt->domains_rwsem);
> +	rc = iopt_area_fill_domains(area, pages);
> +	if (!rc) {
> +		/*
> +		 * area->pages must be set inside the domains_rwsem to ensure
> +		 * any newly added domains will get filled. Moves the reference
> +		 * in from the caller
> +		 */
> +		down_write(&area->iopt->iova_rwsem);
> +		area->pages = pages;
> +		up_write(&area->iopt->iova_rwsem);
> +	}
> +	up_read(&area->iopt->domains_rwsem);
> +	return rc;
> +}
> +
> +int iopt_map_pages(struct io_pagetable *iopt, struct iopt_pages *pages,
> +		   unsigned long *dst_iova, unsigned long start_bytes,
> +		   unsigned long length, int iommu_prot, unsigned int flags)
> +{
> +	struct iopt_area *area;
> +	int rc;
> +
> +	if ((iommu_prot & IOMMU_WRITE) && !pages->writable)
> +		return -EPERM;
> +
> +	area = iopt_alloc_area(iopt, pages, *dst_iova, start_bytes, length,
> +			       iommu_prot, flags);
> +	if (IS_ERR(area))
> +		return PTR_ERR(area);
> +	*dst_iova = iopt_area_iova(area);
> +
> +	rc = iopt_finalize_area(area, pages);
> +	if (rc) {
> +		iopt_abort_area(area);
> +		return rc;
> +	}
> +	return 0;
> +}
> +
> +/**
> + * iopt_map_user_pages() - Map a user VA to an iova in the io page table
> + * @iopt: io_pagetable to act on
> + * @iova: If IOPT_ALLOC_IOVA is set this is unused on input and contains
> + *        the chosen iova on output. Otherwise is the iova to map to on input
> + * @uptr: User VA to map
> + * @length: Number of bytes to map
> + * @iommu_prot: Combination of IOMMU_READ/WRITE/etc bits for the mapping
> + * @flags: IOPT_ALLOC_IOVA or zero
> + *
> + * iova, uptr, and length must be aligned to iova_alignment. For domain backed
> + * page tables this will pin the pages and load them into the domain at iova.
> + * For non-domain page tables this will only setup a lazy reference and the
> + * caller must use iopt_access_pages() to touch them.
> + *
> + * iopt_unmap_iova() must be called to undo this before the io_pagetable can be
> + * destroyed.
> + */
> +int iopt_map_user_pages(struct io_pagetable *iopt, unsigned long *iova,
> +			void __user *uptr, unsigned long length, int iommu_prot,
> +			unsigned int flags)
> +{
> +	struct iopt_pages *pages;
> +	int rc;
> +
> +	pages = iopt_alloc_pages(uptr, length, iommu_prot & IOMMU_WRITE);
> +	if (IS_ERR(pages))
> +		return PTR_ERR(pages);
> +
> +	rc = iopt_map_pages(iopt, pages, iova, uptr - pages->uptr, length,
> +			    iommu_prot, flags);
> +	if (rc) {
> +		iopt_put_pages(pages);
> +		return rc;
> +	}
> +	return 0;
> +}
> +
> +struct iopt_pages *iopt_get_pages(struct io_pagetable *iopt, unsigned long iova,
> +				  unsigned long *start_byte,
> +				  unsigned long length)
> +{
> +	unsigned long iova_end;
> +	struct iopt_pages *pages;
> +	struct iopt_area *area;
> +
> +	if (check_add_overflow(iova, length - 1, &iova_end))
> +		return ERR_PTR(-EOVERFLOW);
> +
> +	down_read(&iopt->iova_rwsem);
> +	area = iopt_find_exact_area(iopt, iova, iova_end);
> +	if (!area) {
> +		up_read(&iopt->iova_rwsem);
> +		return ERR_PTR(-ENOENT);
> +	}
> +	pages = area->pages;
> +	*start_byte = area->page_offset + iopt_area_index(area) * PAGE_SIZE;
> +	kref_get(&pages->kref);
> +	up_read(&iopt->iova_rwsem);
> +
> +	return pages;
> +}
> +
> +static int __iopt_unmap_iova(struct io_pagetable *iopt, struct iopt_area *area,
> +			     struct iopt_pages *pages)
> +{
> +	/* Drivers have to unpin on notification. */
> +	if (WARN_ON(atomic_read(&area->num_users)))
> +		return -EBUSY;
> +
> +	iopt_area_unfill_domains(area, pages);
> +	WARN_ON(atomic_read(&area->num_users));
> +	iopt_abort_area(area);
> +	iopt_put_pages(pages);
> +	return 0;
> +}
> +
> +/**
> + * iopt_unmap_iova() - Remove a range of iova
> + * @iopt: io_pagetable to act on
> + * @iova: Starting iova to unmap
> + * @length: Number of bytes to unmap
> + *
> + * The requested range must exactly match an existing range.
> + * Splitting/truncating IOVA mappings is not allowed.
> + */
> +int iopt_unmap_iova(struct io_pagetable *iopt, unsigned long iova,
> +		    unsigned long length)
> +{
> +	struct iopt_pages *pages;
> +	struct iopt_area *area;
> +	unsigned long iova_end;
> +	int rc;
> +
> +	if (!length)
> +		return -EINVAL;
> +
> +	if (check_add_overflow(iova, length - 1, &iova_end))
> +		return -EOVERFLOW;
> +
> +	down_read(&iopt->domains_rwsem);
> +	down_write(&iopt->iova_rwsem);
> +	area = iopt_find_exact_area(iopt, iova, iova_end);
> +	if (!area) {
> +		up_write(&iopt->iova_rwsem);
> +		up_read(&iopt->domains_rwsem);
> +		return -ENOENT;
> +	}
> +	pages = area->pages;
> +	area->pages = NULL;
> +	up_write(&iopt->iova_rwsem);
> +
> +	rc = __iopt_unmap_iova(iopt, area, pages);
> +	up_read(&iopt->domains_rwsem);
> +	return rc;
> +}
> +
> +int iopt_unmap_all(struct io_pagetable *iopt)
> +{
> +	struct iopt_area *area;
> +	int rc;
> +
> +	down_read(&iopt->domains_rwsem);
> +	down_write(&iopt->iova_rwsem);
> +	while ((area = iopt_area_iter_first(iopt, 0, ULONG_MAX))) {
> +		struct iopt_pages *pages;
> +
> +		/* Userspace should not race unmap all and map */
> +		if (!area->pages) {
> +			rc = -EBUSY;
> +			goto out_unlock_iova;
> +		}
> +		pages = area->pages;
> +		area->pages = NULL;
> +		up_write(&iopt->iova_rwsem);
> +
> +		rc = __iopt_unmap_iova(iopt, area, pages);
> +		if (rc)
> +			goto out_unlock_domains;
> +
> +		down_write(&iopt->iova_rwsem);
> +	}
> +	rc = 0;
> +
> +out_unlock_iova:
> +	up_write(&iopt->iova_rwsem);
> +out_unlock_domains:
> +	up_read(&iopt->domains_rwsem);
> +	return rc;
> +}
> +
> +/**
> + * iopt_access_pages() - Return a list of pages under the iova
> + * @iopt: io_pagetable to act on
> + * @iova: Starting IOVA
> + * @length: Number of bytes to access
> + * @out_pages: Output page list
> + * @write: True if access is for writing
> + *
> + * Reads @npages starting at iova and returns the struct page * pointers. These
> + * can be kmap'd by the caller for CPU access.
> + *
> + * The caller must perform iopt_unaccess_pages() when done to balance this.
> + *
> + * iova can be unaligned from PAGE_SIZE. The first returned byte starts at
> + * page_to_phys(out_pages[0]) + (iova % PAGE_SIZE). The caller promises not to
> + * touch memory outside the requested iova slice.
> + *
> + * FIXME: callers that need a DMA mapping via a sgl should create another
> + * interface to build the SGL efficiently
> + */
> +int iopt_access_pages(struct io_pagetable *iopt, unsigned long iova,
> +		      unsigned long length, struct page **out_pages, bool write)
> +{
> +	unsigned long cur_iova = iova;
> +	unsigned long last_iova;
> +	struct iopt_area *area;
> +	int rc;
> +
> +	if (!length)
> +		return -EINVAL;
> +	if (check_add_overflow(iova, length - 1, &last_iova))
> +		return -EOVERFLOW;
> +
> +	down_read(&iopt->iova_rwsem);
> +	for (area = iopt_area_iter_first(iopt, iova, last_iova); area;
> +	     area = iopt_area_iter_next(area, iova, last_iova)) {
> +		unsigned long last = min(last_iova, iopt_area_last_iova(area));
> +		unsigned long last_index;
> +		unsigned long index;
> +
> +		/* Need contiguous areas in the access */
> +		if (iopt_area_iova(area) < cur_iova || !area->pages) {
> +			rc = -EINVAL;
> +			goto out_remove;
> +		}
> +
> +		index = iopt_area_iova_to_index(area, cur_iova);
> +		last_index = iopt_area_iova_to_index(area, last);
> +		rc = iopt_pages_add_user(area->pages, index, last_index,
> +					 out_pages, write);
> +		if (rc)
> +			goto out_remove;
> +		if (last == last_iova)
> +			break;
> +		/*
> +		 * Can't cross areas that are not aligned to the system page
> +		 * size with this API.
> +		 */
> +		if (cur_iova % PAGE_SIZE) {
> +			rc = -EINVAL;
> +			goto out_remove;
> +		}
> +		cur_iova = last + 1;
> +		out_pages += last_index - index;
> +		atomic_inc(&area->num_users);
> +	}
> +
> +	up_read(&iopt->iova_rwsem);
> +	return 0;
> +
> +out_remove:
> +	if (cur_iova != iova)
> +		iopt_unaccess_pages(iopt, iova, cur_iova - iova);
> +	up_read(&iopt->iova_rwsem);
> +	return rc;
> +}
> +
> +/**
> + * iopt_unaccess_pages() - Undo iopt_access_pages
> + * @iopt: io_pagetable to act on
> + * @iova: Starting IOVA
> + * @length:- Number of bytes to access
> + *
> + * Return the struct page's. The caller must stop accessing them before calling
> + * this. The iova/length must exactly match the one provided to access_pages.
> + */
> +void iopt_unaccess_pages(struct io_pagetable *iopt, unsigned long iova,
> +			 size_t length)
> +{
> +	unsigned long cur_iova = iova;
> +	unsigned long last_iova;
> +	struct iopt_area *area;
> +
> +	if (WARN_ON(!length) ||
> +	    WARN_ON(check_add_overflow(iova, length - 1, &last_iova)))
> +		return;
> +
> +	down_read(&iopt->iova_rwsem);
> +	for (area = iopt_area_iter_first(iopt, iova, last_iova); area;
> +	     area = iopt_area_iter_next(area, iova, last_iova)) {
> +		unsigned long last = min(last_iova, iopt_area_last_iova(area));
> +		int num_users;
> +
> +		iopt_pages_remove_user(area->pages,
> +				       iopt_area_iova_to_index(area, cur_iova),
> +				       iopt_area_iova_to_index(area, last));
> +		if (last == last_iova)
> +			break;
> +		cur_iova = last + 1;
> +		num_users = atomic_dec_return(&area->num_users);
> +		WARN_ON(num_users < 0);
> +	}
> +	up_read(&iopt->iova_rwsem);
> +}
> +
> +struct iopt_reserved_iova {
> +	struct interval_tree_node node;
> +	void *owner;
> +};
> +
> +int iopt_reserve_iova(struct io_pagetable *iopt, unsigned long start,
> +		      unsigned long last, void *owner)
> +{
> +	struct iopt_reserved_iova *reserved;
> +
> +	lockdep_assert_held_write(&iopt->iova_rwsem);
> +
> +	if (iopt_area_iter_first(iopt, start, last))
> +		return -EADDRINUSE;
> +
> +	reserved = kzalloc(sizeof(*reserved), GFP_KERNEL);
> +	if (!reserved)
> +		return -ENOMEM;
> +	reserved->node.start = start;
> +	reserved->node.last = last;
> +	reserved->owner = owner;
> +	interval_tree_insert(&reserved->node, &iopt->reserved_iova_itree);
> +	return 0;
> +}
> +
> +void iopt_remove_reserved_iova(struct io_pagetable *iopt, void *owner)
> +{
> +
> +	struct interval_tree_node *node;
> +
> +	for (node = interval_tree_iter_first(&iopt->reserved_iova_itree, 0,
> +					     ULONG_MAX);
> +	     node;) {
> +		struct iopt_reserved_iova *reserved =
> +			container_of(node, struct iopt_reserved_iova, node);
> +
> +		node = interval_tree_iter_next(node, 0, ULONG_MAX);
> +
> +		if (reserved->owner == owner) {
> +			interval_tree_remove(&reserved->node,
> +					     &iopt->reserved_iova_itree);
> +			kfree(reserved);
> +		}
> +	}
> +}
> +
> +int iopt_init_table(struct io_pagetable *iopt)
> +{
> +	init_rwsem(&iopt->iova_rwsem);
> +	init_rwsem(&iopt->domains_rwsem);
> +	iopt->area_itree = RB_ROOT_CACHED;
> +	iopt->reserved_iova_itree = RB_ROOT_CACHED;
> +	xa_init(&iopt->domains);
> +
> +	/*
> +	 * iopt's start as SW tables that can use the entire size_t IOVA space
> +	 * due to the use of size_t in the APIs. They have no alignment
> +	 * restriction.
> +	 */
> +	iopt->iova_alignment = 1;
> +
> +	return 0;
> +}
> +
> +void iopt_destroy_table(struct io_pagetable *iopt)
> +{
> +	if (IS_ENABLED(CONFIG_IOMMUFD_TEST))
> +		iopt_remove_reserved_iova(iopt, NULL);
> +	WARN_ON(!RB_EMPTY_ROOT(&iopt->reserved_iova_itree.rb_root));
> +	WARN_ON(!xa_empty(&iopt->domains));
> +	WARN_ON(!RB_EMPTY_ROOT(&iopt->area_itree.rb_root));
> +}
> +
> +/**
> + * iopt_unfill_domain() - Unfill a domain with PFNs
> + * @iopt: io_pagetable to act on
> + * @domain: domain to unfill
> + *
> + * This is used when removing a domain from the iopt. Every area in the iopt
> + * will be unmapped from the domain. The domain must already be removed from the
> + * domains xarray.
> + */
> +static void iopt_unfill_domain(struct io_pagetable *iopt,
> +			       struct iommu_domain *domain)
> +{
> +	struct iopt_area *area;
> +
> +	lockdep_assert_held(&iopt->iova_rwsem);
> +	lockdep_assert_held_write(&iopt->domains_rwsem);
> +
> +	/*
> +	 * Some other domain is holding all the pfns still, rapidly unmap this
> +	 * domain.
> +	 */
> +	if (iopt->next_domain_id != 0) {
> +		/* Pick an arbitrary remaining domain to act as storage */
> +		struct iommu_domain *storage_domain =
> +			xa_load(&iopt->domains, 0);
> +
> +		for (area = iopt_area_iter_first(iopt, 0, ULONG_MAX); area;
> +		     area = iopt_area_iter_next(area, 0, ULONG_MAX)) {
> +			struct iopt_pages *pages = area->pages;
> +
> +			if (WARN_ON(!pages))
> +				continue;
> +
> +			mutex_lock(&pages->mutex);
> +			if (area->storage_domain != domain) {
> +				mutex_unlock(&pages->mutex);
> +				continue;
> +			}
> +			area->storage_domain = storage_domain;
> +			mutex_unlock(&pages->mutex);
> +		}
> +
> +
> +		iopt_unmap_domain(iopt, domain);
> +		return;
> +	}
> +
> +	for (area = iopt_area_iter_first(iopt, 0, ULONG_MAX); area;
> +	     area = iopt_area_iter_next(area, 0, ULONG_MAX)) {
> +		struct iopt_pages *pages = area->pages;
> +
> +		if (WARN_ON(!pages))
> +			continue;
> +
> +		mutex_lock(&pages->mutex);
> +		interval_tree_remove(&area->pages_node,
> +				     &area->pages->domains_itree);
> +		WARN_ON(area->storage_domain != domain);
> +		area->storage_domain = NULL;
> +		iopt_area_unfill_domain(area, pages, domain);
> +		mutex_unlock(&pages->mutex);
> +	}
> +}
> +
> +/**
> + * iopt_fill_domain() - Fill a domain with PFNs
> + * @iopt: io_pagetable to act on
> + * @domain: domain to fill
> + *
> + * Fill the domain with PFNs from every area in the iopt. On failure the domain
> + * is left unchanged.
> + */
> +static int iopt_fill_domain(struct io_pagetable *iopt,
> +			    struct iommu_domain *domain)
> +{
> +	struct iopt_area *end_area;
> +	struct iopt_area *area;
> +	int rc;
> +
> +	lockdep_assert_held(&iopt->iova_rwsem);
> +	lockdep_assert_held_write(&iopt->domains_rwsem);
> +
> +	for (area = iopt_area_iter_first(iopt, 0, ULONG_MAX); area;
> +	     area = iopt_area_iter_next(area, 0, ULONG_MAX)) {
> +		struct iopt_pages *pages = area->pages;
> +
> +		if (WARN_ON(!pages))
> +			continue;
> +
> +		mutex_lock(&pages->mutex);
> +		rc = iopt_area_fill_domain(area, domain);
> +		if (rc) {
> +			mutex_unlock(&pages->mutex);
> +			goto out_unfill;
> +		}
> +		if (!area->storage_domain) {
> +			WARN_ON(iopt->next_domain_id != 0);
> +			area->storage_domain = domain;
> +			interval_tree_insert(&area->pages_node,
> +					     &pages->domains_itree);
> +		}
> +		mutex_unlock(&pages->mutex);
> +	}
> +	return 0;
> +
> +out_unfill:
> +	end_area = area;
> +	for (area = iopt_area_iter_first(iopt, 0, ULONG_MAX); area;
> +	     area = iopt_area_iter_next(area, 0, ULONG_MAX)) {
> +		struct iopt_pages *pages = area->pages;
> +
> +		if (area == end_area)
> +			break;
> +		if (WARN_ON(!pages))
> +			continue;
> +		mutex_lock(&pages->mutex);
> +		if (iopt->next_domain_id == 0) {
> +			interval_tree_remove(&area->pages_node,
> +					     &pages->domains_itree);
> +			area->storage_domain = NULL;
> +		}
> +		iopt_area_unfill_domain(area, pages, domain);
> +		mutex_unlock(&pages->mutex);
> +	}
> +	return rc;
> +}
> +
> +/* All existing area's conform to an increased page size */
> +static int iopt_check_iova_alignment(struct io_pagetable *iopt,
> +				     unsigned long new_iova_alignment)
> +{
> +	struct iopt_area *area;
> +
> +	lockdep_assert_held(&iopt->iova_rwsem);
> +
> +	for (area = iopt_area_iter_first(iopt, 0, ULONG_MAX); area;
> +	     area = iopt_area_iter_next(area, 0, ULONG_MAX))
> +		if ((iopt_area_iova(area) % new_iova_alignment) ||
> +		    (iopt_area_length(area) % new_iova_alignment))
> +			return -EADDRINUSE;
> +	return 0;
> +}
> +
> +int iopt_table_add_domain(struct io_pagetable *iopt,
> +			  struct iommu_domain *domain)
> +{
> +	const struct iommu_domain_geometry *geometry = &domain->geometry;
> +	struct iommu_domain *iter_domain;
> +	unsigned int new_iova_alignment;
> +	unsigned long index;
> +	int rc;
> +
> +	down_write(&iopt->domains_rwsem);
> +	down_write(&iopt->iova_rwsem);
> +
> +	xa_for_each (&iopt->domains, index, iter_domain) {
> +		if (WARN_ON(iter_domain == domain)) {
> +			rc = -EEXIST;
> +			goto out_unlock;
> +		}
> +	}
> +
> +	/*
> +	 * The io page size drives the iova_alignment. Internally the iopt_pages
> +	 * works in PAGE_SIZE units and we adjust when mapping sub-PAGE_SIZE
> +	 * objects into the iommu_domain.
> +	 *
> +	 * A iommu_domain must always be able to accept PAGE_SIZE to be
> +	 * compatible as we can't guarantee higher contiguity.
> +	 */
> +	new_iova_alignment =
> +		max_t(unsigned long, 1UL << __ffs(domain->pgsize_bitmap),
> +		      iopt->iova_alignment);
> +	if (new_iova_alignment > PAGE_SIZE) {
> +		rc = -EINVAL;
> +		goto out_unlock;
> +	}
> +	if (new_iova_alignment != iopt->iova_alignment) {
> +		rc = iopt_check_iova_alignment(iopt, new_iova_alignment);
> +		if (rc)
> +			goto out_unlock;
> +	}
> +
> +	/* No area exists that is outside the allowed domain aperture */
> +	if (geometry->aperture_start != 0) {
> +		rc = iopt_reserve_iova(iopt, 0, geometry->aperture_start - 1,
> +				       domain);
> +		if (rc)
> +			goto out_reserved;
> +	}
> +	if (geometry->aperture_end != ULONG_MAX) {
> +		rc = iopt_reserve_iova(iopt, geometry->aperture_end + 1,
> +				       ULONG_MAX, domain);
> +		if (rc)
> +			goto out_reserved;
> +	}
> +
> +	rc = xa_reserve(&iopt->domains, iopt->next_domain_id, GFP_KERNEL);
> +	if (rc)
> +		goto out_reserved;
> +
> +	rc = iopt_fill_domain(iopt, domain);
> +	if (rc)
> +		goto out_release;
> +
> +	iopt->iova_alignment = new_iova_alignment;
> +	xa_store(&iopt->domains, iopt->next_domain_id, domain, GFP_KERNEL);
> +	iopt->next_domain_id++;
Not understand here.

Do we get the domain = xa_load(&iopt->domains, iopt->next_domain_id-1)?
Then how to get the domain if next_domain_id++.
For example, iopt_table_add_domain 3 times with 3 domains,
how to know which next_domain_id is the correct one.

Thanks
