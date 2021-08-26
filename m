Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4905E3F90DA
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 01:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243731AbhHZXJd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 19:09:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33633 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231251AbhHZXJc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 19:09:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630019324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lK4TopQi3jbqo9nNLov/8HsowxPiPoWmzVqHQD+2VVo=;
        b=aAvBfclQBN7dZggMethp9CnNUneoldUzp8CnO10d3QGULodxYZRyhSVvKRNA6lthVPiqf0
        SpU2Ddav+vjoT+/9BNEto9JI3Akjiu8SLXParXawYq32tFoGqi0fr2N+yP6VR1g4SfP9MW
        dUKIqfOlxAzA/wAo+Xt8SM7tWQh+Gfw=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-529-W4aOMJdjNOybC8TJ4URvjg-1; Thu, 26 Aug 2021 19:08:43 -0400
X-MC-Unique: W4aOMJdjNOybC8TJ4URvjg-1
Received: by mail-oi1-f199.google.com with SMTP id r25-20020a056808211900b00268b48af6baso2309186oiw.23
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 16:08:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lK4TopQi3jbqo9nNLov/8HsowxPiPoWmzVqHQD+2VVo=;
        b=sijp7ZJul8ULG/McKndFYiS09oDMRsB+hwiYRAXQWZG2PziY4Z9w7i6vVYbXjNuYW0
         8mBl74FmFP0DiRzBeL/txiZ4itk3KkoGjHBK9obktST0KUyJ5kUKcWYHLX2hyOsbGc+a
         Vei/oOBnIrrdJWTqzf0I1lb0E3fVWxuiA9FFhvFATL+2O5DN0VpREG0CIiL/slY9AtT1
         PwodVdDNwH5+OXx8yBWQPPo1Je93Pjgl9zD2hycqdTyLe6XJuP5Lsg5MSQ29Mw3eoHdR
         QFTNOgphRBuimrpRZUOenvYuSxoqaYV2uGwTQBBnLzKEOL0MhvaxnbXxR+Urz/2hGC2p
         4xGQ==
X-Gm-Message-State: AOAM532UWkrM3+sW93WtMrRm58QZj7DOFvbr4yJF5faJPUsWiZn8SJqM
        IlwXI3wJJ94GU71of4X8bY/rFS13UJTkEbAPh281jnEJgYQwdaG8tWgZTmKEDnlomFJQgOaV1Z2
        iXEPLcTBCjuNH
X-Received: by 2002:a9d:6e81:: with SMTP id a1mr5528027otr.248.1630019322182;
        Thu, 26 Aug 2021 16:08:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwrC/P30WQ5eHX8Hd6bFsDhqC+jPE0fR6ygBv457k9q7SAAxFBqq3co4oeAHZ0rredBDJrRhw==
X-Received: by 2002:a9d:6e81:: with SMTP id a1mr5528013otr.248.1630019321944;
        Thu, 26 Aug 2021 16:08:41 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id l44sm767635otv.81.2021.08.26.16.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 16:08:41 -0700 (PDT)
Date:   Thu, 26 Aug 2021 17:08:40 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH 13/14] vfio/iommu_type1: remove the "external" domain
Message-ID: <20210826170840.48618414.alex.williamson@redhat.com>
In-Reply-To: <20210826133424.3362-14-hch@lst.de>
References: <20210826133424.3362-1-hch@lst.de>
        <20210826133424.3362-14-hch@lst.de>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 26 Aug 2021 15:34:23 +0200
Christoph Hellwig <hch@lst.de> wrote:

> The external_domain concept rather misleading and not actually needed.
> Replace it with a list of emulated groups in struct vfio_iommu and
> document the purpose.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 121 ++++++++++++++------------------
>  1 file changed, 54 insertions(+), 67 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index ca3c995c84166f..1ef98d4e2abecf 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -65,7 +65,6 @@ MODULE_PARM_DESC(dma_entry_limit,
>  struct vfio_iommu {
>  	struct list_head	domain_list;
>  	struct list_head	iova_list;
> -	struct vfio_domain	*external_domain; /* domain for external user */
>  	struct mutex		lock;
>  	struct rb_root		dma_list;
>  	struct blocking_notifier_head notifier;
> @@ -78,6 +77,7 @@ struct vfio_iommu {
>  	bool			nesting;
>  	bool			dirty_page_tracking;
>  	bool			container_open;
> +	struct list_head	emulated_iommu_groups;
>  };
>  
>  struct vfio_domain {
> @@ -1892,8 +1892,8 @@ static struct vfio_iommu_group*
>  vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
>  			    struct iommu_group *iommu_group)
>  {
> +	struct vfio_iommu_group *group;
>  	struct vfio_domain *domain;
> -	struct vfio_iommu_group *group = NULL;
>  
>  	list_for_each_entry(domain, &iommu->domain_list, next) {
>  		group = find_iommu_group(domain, iommu_group);
> @@ -1901,10 +1901,10 @@ vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
>  			return group;
>  	}
>  
> -	if (iommu->external_domain)
> -		group = find_iommu_group(iommu->external_domain, iommu_group);
> -
> -	return group;
> +	list_for_each_entry(group, &iommu->emulated_iommu_groups, next)
> +		if (group->iommu_group == iommu_group)
> +			return group;
> +	return NULL;
>  }
>  
>  static bool vfio_iommu_has_sw_msi(struct list_head *group_resv_regions,
> @@ -2163,62 +2163,52 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  	struct vfio_iommu_group *group;
>  	struct vfio_domain *domain, *d;
>  	struct bus_type *bus = NULL;
> -	int ret;
>  	bool resv_msi, msi_remap;
>  	phys_addr_t resv_msi_base = 0;
>  	struct iommu_domain_geometry *geo;
>  	LIST_HEAD(iova_copy);
>  	LIST_HEAD(group_resv_regions);
> +	int ret = -EINVAL;
>  
>  	mutex_lock(&iommu->lock);
>  
>  	/* Check for duplicates */
> -	if (vfio_iommu_find_iommu_group(iommu, iommu_group)) {
> -		mutex_unlock(&iommu->lock);
> -		return -EINVAL;
> -	}
> +	if (vfio_iommu_find_iommu_group(iommu, iommu_group))
> +		goto out_unlock;
>  
> +	ret = -ENOMEM;
>  	group = kzalloc(sizeof(*group), GFP_KERNEL);
> -	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
> -	if (!group || !domain) {
> -		ret = -ENOMEM;
> -		goto out_free;
> -	}
> -
> +	if (!group)
> +		goto out_unlock;
>  	group->iommu_group = iommu_group;
>  
> -	/* Determine bus_type in order to allocate a domain */
> -	ret = iommu_group_for_each_dev(iommu_group, &bus, vfio_bus_type);
> -	if (ret)
> -		goto out_free;
> -
>  	if (flags & VFIO_EMULATED_IOMMU) {
> -		if (!iommu->external_domain) {
> -			INIT_LIST_HEAD(&domain->group_list);
> -			iommu->external_domain = domain;
> -			vfio_update_pgsize_bitmap(iommu);
> -		} else {
> -			kfree(domain);
> -		}
> -
> -		list_add(&group->next, &iommu->external_domain->group_list);
> +		list_add(&group->next, &iommu->emulated_iommu_groups);
>  		/*
> -		 * Non-iommu backed group cannot dirty memory directly, it can
> +		 * An emulated IOMMU group cannot dirty memory directly, it can
>  		 * only use interfaces that provide dirty tracking.
>  		 * The iommu scope can only be promoted with the addition of a
>  		 * dirty tracking group.
>  		 */


I didn't actually spot the additional documentation noted in the commit
log, is this it?  Thanks,

Alex


>  		group->pinned_page_dirty_scope = true;
> -		mutex_unlock(&iommu->lock);
> -
> -		return 0;
> +		ret = 0;
> +		goto out_unlock;
>  	}
>  
> +	/* Determine bus_type in order to allocate a domain */
> +	ret = iommu_group_for_each_dev(iommu_group, &bus, vfio_bus_type);
> +	if (ret)
> +		goto out_free_group;
> +
> +	ret = -ENOMEM;
> +	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
> +	if (!domain)
> +		goto out_free_group;
> +
> +	ret = -EIO;
>  	domain->domain = iommu_domain_alloc(bus);
> -	if (!domain->domain) {
> -		ret = -EIO;
> -		goto out_free;
> -	}
> +	if (!domain->domain)
> +		goto out_free_domain;
>  
>  	if (iommu->nesting) {
>  		ret = iommu_enable_nesting(domain->domain);
> @@ -2345,9 +2335,11 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  	iommu_domain_free(domain->domain);
>  	vfio_iommu_iova_free(&iova_copy);
>  	vfio_iommu_resv_free(&group_resv_regions);
> -out_free:
> +out_free_domain:
>  	kfree(domain);
> +out_free_group:
>  	kfree(group);
> +out_unlock:
>  	mutex_unlock(&iommu->lock);
>  	return ret;
>  }
> @@ -2472,25 +2464,19 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>  	LIST_HEAD(iova_copy);
>  
>  	mutex_lock(&iommu->lock);
> +	list_for_each_entry(group, &iommu->emulated_iommu_groups, next) {
> +		if (group->iommu_group != iommu_group)
> +			continue;
> +		update_dirty_scope = !group->pinned_page_dirty_scope;
> +		list_del(&group->next);
> +		kfree(group);
>  
> -	if (iommu->external_domain) {
> -		group = find_iommu_group(iommu->external_domain, iommu_group);
> -		if (group) {
> -			update_dirty_scope = !group->pinned_page_dirty_scope;
> -			list_del(&group->next);
> -			kfree(group);
> -
> -			if (list_empty(&iommu->external_domain->group_list)) {
> -				if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> -					WARN_ON(iommu->notifier.head);
> -					vfio_iommu_unmap_unpin_all(iommu);
> -				}
> -
> -				kfree(iommu->external_domain);
> -				iommu->external_domain = NULL;
> -			}
> -			goto detach_group_done;
> +		if (list_empty(&iommu->emulated_iommu_groups) &&
> +		    !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> +			WARN_ON(iommu->notifier.head);
> +			vfio_iommu_unmap_unpin_all(iommu);
>  		}
> +		goto detach_group_done;
>  	}
>  
>  	/*
> @@ -2518,7 +2504,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>  		 */
>  		if (list_empty(&domain->group_list)) {
>  			if (list_is_singular(&iommu->domain_list)) {
> -				if (!iommu->external_domain) {
> +				if (list_empty(&iommu->emulated_iommu_groups)) {
>  					WARN_ON(iommu->notifier.head);
>  					vfio_iommu_unmap_unpin_all(iommu);
>  				} else {
> @@ -2582,41 +2568,42 @@ static void *vfio_iommu_type1_open(unsigned long arg)
>  	mutex_init(&iommu->lock);
>  	BLOCKING_INIT_NOTIFIER_HEAD(&iommu->notifier);
>  	init_waitqueue_head(&iommu->vaddr_wait);
> +	INIT_LIST_HEAD(&iommu->emulated_iommu_groups);
>  
>  	return iommu;
>  }
>  
> -static void vfio_release_domain(struct vfio_domain *domain, bool external)
> +static void vfio_release_domain(struct vfio_domain *domain)
>  {
>  	struct vfio_iommu_group *group, *group_tmp;
>  
>  	list_for_each_entry_safe(group, group_tmp,
>  				 &domain->group_list, next) {
> -		if (!external)
> -			iommu_detach_group(domain->domain, group->iommu_group);
> +		iommu_detach_group(domain->domain, group->iommu_group);
>  		list_del(&group->next);
>  		kfree(group);
>  	}
>  
> -	if (!external)
> -		iommu_domain_free(domain->domain);
> +	iommu_domain_free(domain->domain);
>  }
>  
>  static void vfio_iommu_type1_release(void *iommu_data)
>  {
>  	struct vfio_iommu *iommu = iommu_data;
>  	struct vfio_domain *domain, *domain_tmp;
> +	struct vfio_iommu_group *group, *next_group;
>  
> -	if (iommu->external_domain) {
> -		vfio_release_domain(iommu->external_domain, true);
> -		kfree(iommu->external_domain);
> +	list_for_each_entry_safe(group, next_group,
> +			&iommu->emulated_iommu_groups, next) {
> +		list_del(&group->next);
> +		kfree(group);
>  	}
>  
>  	vfio_iommu_unmap_unpin_all(iommu);
>  
>  	list_for_each_entry_safe(domain, domain_tmp,
>  				 &iommu->domain_list, next) {
> -		vfio_release_domain(domain, false);
> +		vfio_release_domain(domain);
>  		list_del(&domain->next);
>  		kfree(domain);
>  	}

