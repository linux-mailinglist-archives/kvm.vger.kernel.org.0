Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33AE3F90CC
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 01:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243820AbhHZWsV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 18:48:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34732 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231243AbhHZWsS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 18:48:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630018050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PPnWlBPbKNLnXZ0hDuLKj6kjZijb8yjDEBjjWvZzhkA=;
        b=gkNN5u/eXgx1cZg66Xk0dKFG/8eaAHxmg+E4cQANbi0AdEZt0F7HHeUq07w/210XTRR5IN
        WBKduDevQ5VQdIUx0EbQIptq16zDR2/gPBFJEuctBV9R4HjdKw5BXTQEdpk0nNzXCBSpYO
        RjTWNgbGC4zCzz/PfnSVg7NTvoINakI=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-a2lPfhmSNIaS2tyDQe0bTw-1; Thu, 26 Aug 2021 18:47:29 -0400
X-MC-Unique: a2lPfhmSNIaS2tyDQe0bTw-1
Received: by mail-ot1-f72.google.com with SMTP id x38-20020a05683040a600b0051e1c81337bso1877345ott.3
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 15:47:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PPnWlBPbKNLnXZ0hDuLKj6kjZijb8yjDEBjjWvZzhkA=;
        b=Z22/QjOmC0BAHp0eyvNxdRf8u3yJ/CUMvKGnFvCa5xIzbRw/nk6ZCsuBFoPwS6yb5q
         lkkYHHBS/Bi/WIn1iis7N3bkxmg+H5+ZITlNJ9FtmIVPz92CBx7YGYfRQ8nx/Sh48E7b
         yxWMTaK36li49ZSb95RZDVHUQkD2w6WX/vCFYF8NqJ/9fi0hOy9pZtGNTSX7OwlxeMAQ
         dw3JHV+MIwydTAo0a+FYlYPPO4z4C7wTwmU2slO9XPW0KpjfSdvIZkt5zcxxP5VfSA7U
         Gf9bU40kQPJExfjZIs9vsThBH+Tt9djiZxQDgCFAyhAr05VPwaM7lGDnJmNJEzF0ke5M
         E+WQ==
X-Gm-Message-State: AOAM533bioMCrZA6j2cVprZKN2Fl0thmOIm8Ph1D2ua/J8jnAwRk68XT
        09Tzr3HcjmBU58f96gJeX+fT+WBNmJy1wsqjXmkaZdY+3oxTWVys0lmUga2pn4pqiTpBoDactQ7
        QTo+cu+YqGjtO
X-Received: by 2002:a9d:ecc:: with SMTP id 70mr5451004otj.96.1630018048448;
        Thu, 26 Aug 2021 15:47:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxeFkNpoe8BVGEWgFJSsxm5B5UDROm3MO4dvuA6CkbP1Cg9ZmjBZ01+OFSgAnVOT/hrZopAPA==
X-Received: by 2002:a9d:ecc:: with SMTP id 70mr5450986otj.96.1630018048224;
        Thu, 26 Aug 2021 15:47:28 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id o26sm834070otk.77.2021.08.26.15.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 15:47:27 -0700 (PDT)
Date:   Thu, 26 Aug 2021 16:47:26 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH 05/14] vfio: refactor noiommu group creation
Message-ID: <20210826164726.5bb6a027.alex.williamson@redhat.com>
In-Reply-To: <20210826133424.3362-6-hch@lst.de>
References: <20210826133424.3362-1-hch@lst.de>
        <20210826133424.3362-6-hch@lst.de>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 26 Aug 2021 15:34:15 +0200
Christoph Hellwig <hch@lst.de> wrote:
> +#ifdef CONFIG_VFIO_NOIOMMU
> +static struct vfio_group *vfio_noiommu_group_alloc(struct device *dev)
>  {
>  	struct iommu_group *iommu_group;
>  	struct vfio_group *group;
> +	int ret;
> +
> +	iommu_group = iommu_group_alloc();
> +	if (IS_ERR(iommu_group))
> +		return ERR_CAST(iommu_group);
>  
> -	iommu_group = vfio_iommu_group_get(dev);
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
> +#ifdef CONFIG_VFIO_NOIOMMU
> +	if (!iommu_group && noiommu && !iommu_present(dev->bus)) {
> +		/*
> +		 * With noiommu enabled, create an IOMMU group for devices that
> +		 * don't already have one and don't have an iommu_ops on their
> +		 * bus.  Taint the kernel because we're about to give a DMA
> +		 * capable device to a user without IOMMU protection.
> +		 */
> +		group = vfio_noiommu_group_alloc(dev);
> +		if (group) {
> +			add_taint(TAINT_USER, LOCKDEP_STILL_OK);
> +			dev_warn(dev, "Adding kernel taint for vfio-noiommu group on device\n");
> +		}

Perhaps what Kevin was pointing out here in the previous version,
vfio_noiommu_group_alloc() returns a pointer, so this should test
!IS_ERR(group).  Thanks,

Alex

