Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7534D416846
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 00:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243533AbhIWXBA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 19:01:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22403 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243492AbhIWXBA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Sep 2021 19:01:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632437967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1+3xHMqeV4/oTr13YVjaq5l8eevt1G1gdFYL7vi8Ico=;
        b=g/x17LvaoEOU5Mmm+ymsR35JeLtNaMbFTpHeIziGxHnTW9IiwDrvM0KBGfRGwoDuA7Sk+2
        BV21NqF/FI3x+GkGWVJ6WzlwOSeZxJ0s9XtSk71fDA+npnvToPO8IsWhdydZ/le5JZ2GBn
        ypHbdD0mvX2pLLdQyl8qO+pHpMYKAIM=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-5f9Z_blHON2zD4TsTsYXRA-1; Thu, 23 Sep 2021 18:59:26 -0400
X-MC-Unique: 5f9Z_blHON2zD4TsTsYXRA-1
Received: by mail-oo1-f72.google.com with SMTP id m10-20020a4a240a000000b002adae1d3d06so3147923oof.9
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 15:59:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1+3xHMqeV4/oTr13YVjaq5l8eevt1G1gdFYL7vi8Ico=;
        b=f8VhlRpssP3cSA6l5wN/lY6++yl/D41suxkdUa0+mEqVbIgstIGJLJUJiD/HCIIaft
         IzOr8nbsAvqT34J4fNbIkyK+xfxqa4AbbX/xkJf70v58hXFJtkFghxBT88/OsewBj6oj
         lzicKhx8ADO/2jUhVTGo5pZJRnjPNHc6xVbwzGOIVmRUYSUUgqRHB3/s1YFeXllMx97d
         sWYjFW0rrJX2CnUK/lxwKl+ZT2YEBewM9lKz0uMvlQANQ1k+RJpHFW0LsJVfQjeiFz8/
         lb0Y0G2N2QcxSQgkozRe4apGFUsc5pwSN8M3Pg1VODhjZeGTZIx3u9Apy6lQ9ifDWE0J
         0Nrw==
X-Gm-Message-State: AOAM530M0HoGrJ0rDguhI1a/lGDp1g85LpFALvwK+RluG886/VN6L0Ob
        fUZK/uJzFd8WRp4WBlriIyEltiZb36BNrVTLmrrml7M8CEAVyRulp1fQMZSrZykCf4qaxzltXFs
        fbUX+IJLPO/tM
X-Received: by 2002:a05:6830:1ad3:: with SMTP id r19mr1045793otc.98.1632437965860;
        Thu, 23 Sep 2021 15:59:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJylcODK7HALLZRokymKqtRa6PtpmKRbF4dWFHgKD4kOVLZlxkxTM6Yha6YFELQihgrQV9hW4g==
X-Received: by 2002:a05:6830:1ad3:: with SMTP id r19mr1045788otc.98.1632437965672;
        Thu, 23 Sep 2021 15:59:25 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id l13sm1642869otp.29.2021.09.23.15.59.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 15:59:25 -0700 (PDT)
Date:   Thu, 23 Sep 2021 16:59:24 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Terrence Xu <terrence.xu@intel.com>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH 13/14] vfio/iommu_type1: remove the "external" domain
Message-ID: <20210923165924.2d8100ff.alex.williamson@redhat.com>
In-Reply-To: <20210913071606.2966-14-hch@lst.de>
References: <20210913071606.2966-1-hch@lst.de>
        <20210913071606.2966-14-hch@lst.de>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 13 Sep 2021 09:16:05 +0200
Christoph Hellwig <hch@lst.de> wrote:

> The external_domain concept rather misleading and not actually needed.
> Replace it with a list of emulated groups in struct vfio_iommu.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 121 ++++++++++++++------------------
>  1 file changed, 54 insertions(+), 67 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index a48e9f597cb213..d2db62cb2aaa39 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
...
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
>  	if (type == VFIO_EMULATED_IOMMU) {
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
>  		group->pinned_page_dirty_scope = true;
> -		mutex_unlock(&iommu->lock);
> -
> -		return 0;
> +		ret = 0;
> +		goto out_unlock;
>  	}

I think this dropped the call to vfio_update_pgsize_bitmap(), which
would leave iommu->pgsize_bitmap = 0 for a container hosting only mdev
devices, which leads us to undefined behavior when we're using ffs on
it to validate maps, unmaps, dirty bitmap support, etc.   Did I miss
this getting moved elsewhere?  Thanks,

Alex

