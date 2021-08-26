Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1153F8CEC
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 19:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243172AbhHZRZN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 13:25:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43803 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243062AbhHZRZM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 13:25:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629998664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZMjylM79luTHELT/FDTj+zPFB7h3I8bEsPI0WLSfY60=;
        b=e25gtTS6NeBaEVa1Wpc7hQoxyrE3tHlDRjFq8B+cyBol3tjWrx7FCiunTiU/GzidQVBuC4
        l0od/d9uSkzwZo7juRPF0ng3CczkAEBox2PfpH7TktJ576kL2uXrq2PtryQ1nMTBNxGuAW
        J8skNv/Y7OPWwCLlO5Rgo5veJNVXFDs=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-gl84PtTVN0SAGwodD8-0ig-1; Thu, 26 Aug 2021 13:24:20 -0400
X-MC-Unique: gl84PtTVN0SAGwodD8-0ig-1
Received: by mail-io1-f71.google.com with SMTP id k21-20020a5e93150000b02905b30d664397so2193459iom.0
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 10:24:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ZMjylM79luTHELT/FDTj+zPFB7h3I8bEsPI0WLSfY60=;
        b=F8DUXMGXR2hbBELKOK2P6qgGuP3KfmwYqwYW9K+TAxKwjAkCiQrqztjTwgOqI/OUss
         Y8Q7HQ8kwOtMkHu8d/b0le4TMygf6A1qOK67FJF3a4QEn9BemYUeWMl4/RpS5+5Zi4W1
         IH7jTX63HaTabDxA0ukcORLM1U5ksc1i/avWyYfk5Qz5xZ6z98ZyBj1Z+5igJn+v5dKt
         4Vza+TLupI/2j3NnQrHwcEbPc/xw1EaDJyDWIVZuVhOKZAhNNobuqrMSGGG3N/xRKnxt
         dvPOaaSZUcx6kz7zO0GjWcPImCyaP/r273Bwygl/ZBltzGOqlDydF/rNt5CfPxccHHBG
         svLg==
X-Gm-Message-State: AOAM5325hRvHCSyHGCaA6uD8zVGrGPLmtphezAo+j1B7or7a6XV9E76D
        V/N5t6g2KnsOelirAy9qw9LLtwWC/xmJfDHWL/hlFdY70ptlMTyPk6K0vV8v88kwnwL+CwhTAlI
        JC8+8MCUtRYKS
X-Received: by 2002:a92:cdac:: with SMTP id g12mr3438864ild.201.1629998659596;
        Thu, 26 Aug 2021 10:24:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzoUmElZf+NHhHFtW0hh0EBVecM5cP3FrRANB0Q+0SPpFlTnFAGQJE6LSa6RUXG5FllrHcqeA==
X-Received: by 2002:a92:cdac:: with SMTP id g12mr3438848ild.201.1629998659321;
        Thu, 26 Aug 2021 10:24:19 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id p12sm2013202ilp.87.2021.08.26.10.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 10:24:18 -0700 (PDT)
Date:   Thu, 26 Aug 2021 11:24:17 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: Re: [PATCH 07/14] vfio: simplify iommu group allocation for
 mediated devices
Message-ID: <20210826112417.63a51327.alex.williamson@redhat.com>
In-Reply-To: <20210826133424.3362-8-hch@lst.de>
References: <20210826133424.3362-1-hch@lst.de>
        <20210826133424.3362-8-hch@lst.de>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[Cc +Tony]

On Thu, 26 Aug 2021 15:34:17 +0200
Christoph Hellwig <hch@lst.de> wrote:

> Reuse the logic in vfio_noiommu_group_alloc to allocate a fake
> single-device iommu group for mediated devices.  A new function is
> exposed to create vfio_device for this emulated case and the noiommu
> boolean field in struct vfio_group is replaced with a set of flags so
> that devices with an emulated IOMMU can be distinguished from those
> with no IOMMU at all.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/mdev/mdev_driver.c | 46 ++----------------
>  drivers/vfio/mdev/vfio_mdev.c   |  2 +-
>  drivers/vfio/vfio.c             | 82 ++++++++++++++++++++++-----------
>  include/linux/vfio.h            |  1 +
>  samples/vfio-mdev/mbochs.c      |  2 +-
>  samples/vfio-mdev/mdpy.c        |  2 +-
>  samples/vfio-mdev/mtty.c        |  2 +-
>  7 files changed, 65 insertions(+), 72 deletions(-)

As Jason suggested, I'll apply this after
0-v4-0203a4ab0596+f7-vfio_ap_jgg@nvidia.com and roll in the following:

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 2347808fa3e4..f04fe1278f99 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -350,7 +350,7 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
 	list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
 	mutex_unlock(&matrix_dev->lock);
 
-	ret = vfio_register_group_dev(&matrix_mdev->vdev);
+	ret = vfio_register_emulated_iommu_dev(&matrix_mdev->vdev);
 	if (ret)
 		goto err_list;
 	dev_set_drvdata(&mdev->dev, matrix_mdev);

Shout if this is incorrect.  Thanks,

Alex

