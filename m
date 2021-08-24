Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19EE43F6A5D
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 22:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbhHXUZ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 16:25:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27160 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229514AbhHXUZ5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Aug 2021 16:25:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629836712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QxvSf201KFSBW076i2SgwRvprPyd/kVoFUaugkXdgRE=;
        b=axBIUthu4dcqPmOWO2meEpUle+03DhORplS7LpNrocJI7ck89FfPyhjBllRfLai1oVQ1j9
        DhZmInqR1zz+X+eCLVdwv4O9MYsAP/ALOCLax5mH9yS9uZ1IaMtdwhl/Xba73oG1I7S707
        ExIqB0YiCvorHYIFy4OaFKyzRNFxtGY=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-CZphzVQcNsW1ofBe5fqcwg-1; Tue, 24 Aug 2021 16:25:11 -0400
X-MC-Unique: CZphzVQcNsW1ofBe5fqcwg-1
Received: by mail-ot1-f69.google.com with SMTP id x20-20020a9d6294000000b00519008d828eso13241744otk.19
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 13:25:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=QxvSf201KFSBW076i2SgwRvprPyd/kVoFUaugkXdgRE=;
        b=Ahr2omzu1Rdb1/dSElTuwMxMMelrR3aSOd1j+3kPyTxgBFT5r0mNXA11ukT46FvjH1
         QYP1MZ/BvkatResPuTBPOK4nA5oVsUyn2yXoHkdXaAuvCxj87ww3GnraHIdDgf3y2NeU
         XjkNdUf3nu1rbD35yVhrsPd4wxV6sbhTbFkJSkEjWU0d8tb3QdJJlZtj8rEsFjoAspWp
         pnk9GXjs0JID7LGqXl58rv38Kk/gmsKmTbRV3F1XKm3t8z5fDjGeu3ECDWx7BvDSNoT4
         W1Hp+u0XbNdXTIilwA3aGglSXq34wMC7s59kMTd94wpbB+CWXZGBE0Rg44YJt7JRU8TV
         aFXQ==
X-Gm-Message-State: AOAM533Fk+AxXuICDYL+g6DHsK8n7gTRdYE7dGzusyFQkLLvZ9iDZF6U
        fqsuEdiv038uYZJJZ0KgEyKrEifRhdMJkgqVtQoXs2bYyx+nCQ/4go5LcSv2csahbMIuE1eWZNz
        BLoiiv9kY2IqD
X-Received: by 2002:aca:6041:: with SMTP id u62mr4082182oib.178.1629836710565;
        Tue, 24 Aug 2021 13:25:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwC06GHa4oveVLRsb9u8HUh97lv9Yx7/U7iyJLGEGPwwV9S7b+zj9jN1eHCjWjAM84/3F6reQ==
X-Received: by 2002:aca:6041:: with SMTP id u62mr4082174oib.178.1629836710384;
        Tue, 24 Aug 2021 13:25:10 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id c10sm4263168ots.48.2021.08.24.13.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 13:25:10 -0700 (PDT)
Date:   Tue, 24 Aug 2021 14:25:08 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH 01/14] vfio: Move vfio_iommu_group_get() to
 vfio_register_group_dev()
Message-ID: <20210824142508.3a72fe4a.alex.williamson@redhat.com>
In-Reply-To: <20210824144649.1488190-2-hch@lst.de>
References: <20210824144649.1488190-1-hch@lst.de>
        <20210824144649.1488190-2-hch@lst.de>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 Aug 2021 16:46:36 +0200
Christoph Hellwig <hch@lst.de> wrote:

> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> We don't need to hold a reference to the group in the driver as well as
> obtain a reference to the same group as the first thing
> vfio_register_group_dev() does.
> 
> Since the drivers never use the group move this all into the core code.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c            | 17 ++-----------
>  drivers/vfio/pci/vfio_pci.c                  | 15 ++----------
>  drivers/vfio/platform/vfio_platform_common.c | 13 +---------
>  drivers/vfio/vfio.c                          | 25 ++++++--------------
>  include/linux/vfio.h                         |  3 ---
>  5 files changed, 12 insertions(+), 61 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index a4f44ea52fa324..b01c1c6cf1f5e6 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -1875,7 +1875,6 @@ static void vfio_pci_vga_uninit(struct vfio_pci_device *vdev)
>  static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  {
>  	struct vfio_pci_device *vdev;
> -	struct iommu_group *group;
>  	int ret;
>  
>  	if (vfio_pci_is_denylisted(pdev))
> @@ -1897,15 +1896,9 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  		return -EBUSY;
>  	}
>  
> -	group = vfio_iommu_group_get(&pdev->dev);
> -	if (!group)
> -		return -EINVAL;
> -
>  	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
> -	if (!vdev) {
> -		ret = -ENOMEM;
> -		goto out_group_put;
> -	}
> +	if (!vdev)
> +		return -ENOMEM;
>  
>  	vfio_init_group_dev(&vdev->vdev, &pdev->dev, &vfio_pci_ops);
>  	vdev->pdev = pdev;
> @@ -1971,8 +1964,6 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	vfio_uninit_group_dev(&vdev->vdev);
>  	kfree(vdev->pm_save);
>  	kfree(vdev);
> -out_group_put:
> -	vfio_iommu_group_put(group, &pdev->dev);
>  	return ret;
>  }
>  
> @@ -1988,8 +1979,6 @@ static void vfio_pci_remove(struct pci_dev *pdev)
>  	vfio_uninit_group_dev(&vdev->vdev);
>  	vfio_pci_vga_uninit(vdev);
>  
> -	vfio_iommu_group_put(pdev->dev.iommu_group, &pdev->dev);
> -
>  	if (!disable_idle_d3)
>  		vfio_pci_set_power_state(vdev, PCI_D0);
>  


I think this turns into the patch below on top of Yishai's
vfio-pci-core series.  Please verify.  If you'd like something
different, please post an update.  Thanks,

Alex

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index c67751948504..4134dceab3f7 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1807,7 +1807,6 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_uninit_device);
 int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
-	struct iommu_group *group;
 	int ret;
 
 	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
@@ -1826,10 +1825,6 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 		return -EBUSY;
 	}
 
-	group = vfio_iommu_group_get(&pdev->dev);
-	if (!group)
-		return -EINVAL;
-
 	if (pci_is_root_bus(pdev->bus)) {
 		ret = vfio_assign_device_set(&vdev->vdev, vdev);
 	} else if (!pci_probe_reset_slot(pdev->slot)) {
@@ -1843,10 +1838,10 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 	}
 
 	if (ret)
-		goto out_group_put;
+		return ret;
 	ret = vfio_pci_vf_init(vdev);
 	if (ret)
-		goto out_group_put;
+		return ret;
 	ret = vfio_pci_vga_init(vdev);
 	if (ret)
 		goto out_vf;
@@ -1877,8 +1872,6 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 		vfio_pci_set_power_state(vdev, PCI_D0);
 out_vf:
 	vfio_pci_vf_uninit(vdev);
-out_group_put:
-	vfio_iommu_group_put(group, &pdev->dev);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_register_device);
@@ -1894,8 +1887,6 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 	vfio_pci_vf_uninit(vdev);
 	vfio_pci_vga_uninit(vdev);
 
-	vfio_iommu_group_put(pdev->dev.iommu_group, &pdev->dev);
-
 	if (!disable_idle_d3)
 		vfio_pci_set_power_state(vdev, PCI_D0);
 }

