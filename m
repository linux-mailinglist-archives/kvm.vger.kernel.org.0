Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9C053E9AAD
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 00:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbhHKWEN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 18:04:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51453 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232166AbhHKWEJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Aug 2021 18:04:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628719424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k1QwZ6Djzqkro42oBp8vYjoq5RsI+0pO6iMVcRZVL80=;
        b=GHd2HNlF+DT5ym53YroeA38sxRBPtxw+Ldd56nN1GZHynAuINKcoVUumyNR9UnX8lR1cED
        e0h4BT9P7iW7VxCxEjMd8cJuM/8njbtNOiWw8Bbs7VtBaPZrN9SYhsawIVLl0MoHLyauCs
        kjOyHrGL7bLK7QsCjO2Q1y81nxsbRvs=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-iF0q_QA0PJCwh2r9pjAM2w-1; Wed, 11 Aug 2021 18:03:43 -0400
X-MC-Unique: iF0q_QA0PJCwh2r9pjAM2w-1
Received: by mail-ot1-f69.google.com with SMTP id b1-20020a0568301041b02904d0a18787d4so1484749otp.5
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 15:03:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k1QwZ6Djzqkro42oBp8vYjoq5RsI+0pO6iMVcRZVL80=;
        b=Q/dRnQv/GXRB/uGr5OvYL1tbxfFpWyTkRkiIds6GEStDI+pQ+AWQwmWJoMVI8QwhjO
         OI7xFJYtBWKr8PT7iMHe14ro2R5pOnzra4raVQWhSPBY3JDJVUmcLfL5RI4TTPTYqQ6e
         azj8pciPr8D/tUJWQghnswHtvq7/kn3polbGQrhOSoLmMO/ZVEwORnYX+JbEPTxQozVr
         UQ0VQaiHtAchVVh5w2XOMAnkSIN2tNyZXEB412QCssul2teBFWH1pS5BUiR9g/GN5bTu
         jGZ37s+aQinzHbc35/7GSmez3IOlk8M4aUc2M/um9QcGMc0eueYdnOPuGlke6BmhIuZn
         iGPg==
X-Gm-Message-State: AOAM5325R7boqML6DZIUC3hWsRPXV/KyFmB/UiNwXT2N2beuYZiklioC
        8CqGGQbdyZebxvq0EfWx3ri6iLB7zidlYuwbmkSmyC4rem7KLJUzcPOIlE5F0hhWK6UTBKZThgC
        5tg7O4ZyGfpHL
X-Received: by 2002:aca:b608:: with SMTP id g8mr9006874oif.66.1628719422296;
        Wed, 11 Aug 2021 15:03:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8c0yHGwib1bDgE5mRB4/5vmLAYTW9TCwGbFFiLBMVtPQ4MGbExM5oTEyIPN0YYUQNGAq+7w==
X-Received: by 2002:aca:b608:: with SMTP id g8mr9006859oif.66.1628719422159;
        Wed, 11 Aug 2021 15:03:42 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id s32sm142490oiw.46.2021.08.11.15.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 15:03:41 -0700 (PDT)
Date:   Wed, 11 Aug 2021 16:03:41 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org
Subject: Re: [PATCH 05/14] vfio: refactor noiommu group creation
Message-ID: <20210811160341.573a5b82.alex.williamson@redhat.com>
In-Reply-To: <20210811151500.2744-6-hch@lst.de>
References: <20210811151500.2744-1-hch@lst.de>
        <20210811151500.2744-6-hch@lst.de>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 11 Aug 2021 17:14:51 +0200
Christoph Hellwig <hch@lst.de> wrote:
> @@ -833,14 +789,61 @@ void vfio_uninit_group_dev(struct vfio_device *device)
>  }
>  EXPORT_SYMBOL_GPL(vfio_uninit_group_dev);
>  
> -struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
> +#ifdef CONFIG_VFIO_NOIOMMU
> +static struct vfio_group *vfio_noiommu_group_alloc(struct device *dev)
>  {
>  	struct iommu_group *iommu_group;
>  	struct vfio_group *group;
> +	int ret;
>  
> -	iommu_group = vfio_iommu_group_get(dev);
> -	if (!iommu_group)
> +	iommu_group = iommu_group_alloc();
> +	if (IS_ERR(iommu_group))
> +		return ERR_CAST(iommu_group);
> +
> +	iommu_group_set_name(iommu_group, "vfio-noiommu");
> +	iommu_group_set_iommudata(iommu_group, &noiommu, NULL);
> +	ret = iommu_group_add_device(iommu_group, dev);
> +	if (ret)
> +		goto out_put_group;
> +
> +	group = vfio_create_group(iommu_group);
> +	if (IS_ERR(group)) {
> +		ret = PTR_ERR(group);
> +		goto out_remove_device;
> +	}
> +
> +	return group;
> +
> +out_remove_device:
> +	iommu_group_remove_device(dev);
> +out_put_group:
> +	iommu_group_put(iommu_group);
> +	return ERR_PTR(ret);
> +}
> +#endif
> +
> +static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
> +{
> +	struct iommu_group *iommu_group;
> +	struct vfio_group *group;
> +
> +	iommu_group = iommu_group_get(dev);
> +	if (!iommu_group) {
> +#ifdef CONFIG_VFIO_NOIOMMU
> +		/*
> +		 * With noiommu enabled, create an IOMMU group for devices that
> +		 * don't already have one and don't have an iommu_ops on their
> +		 * bus.  Taint the kernel because we're about to give a DMA
> +		 * capable device to a user without IOMMU protection.
> +		 */
> +		if (noiommu && !iommu_present(dev->bus)) {
> +			add_taint(TAINT_USER, LOCKDEP_STILL_OK);
> +			dev_warn(dev, "Adding kernel taint for vfio-noiommu group on device\n");
> +			return vfio_noiommu_group_alloc(dev);

Nit, we taint regardless of the success of this function, should we
move the tainting back into the function (using the flags to skip for
mdev in subsequent patches) or swap the order to check the return value
before tainting?  Thanks,

Alex

