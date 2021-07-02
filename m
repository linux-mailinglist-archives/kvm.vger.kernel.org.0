Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B332D3BA4AA
	for <lists+kvm@lfdr.de>; Fri,  2 Jul 2021 22:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhGBUcC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 16:32:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32347 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230434AbhGBUcA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Jul 2021 16:32:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625257767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fmc5dDCDNgUCGurtDUVLQJtKxPKiPIBI/PH7SfH7U+s=;
        b=UxvVJPf12oS0gUgJKi2w2eKEt3eTpdJ9HFzMSWuQxp2o4aht1I7hcnmND1Is6AuO6FsH9F
        ipuhSaQXROGBK3APhhKQAikYHQDtKo/PyAqYFqEVK+6+EcYY6EUFvc/jUGVrLgL+ddDGYD
        V7BsFRJtulDoSWRQT0pavGBjW0Cthxg=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-gluKmR0zMB-iOg52pj2ydQ-1; Fri, 02 Jul 2021 16:29:26 -0400
X-MC-Unique: gluKmR0zMB-iOg52pj2ydQ-1
Received: by mail-ot1-f71.google.com with SMTP id e7-20020a0568302007b029047bf63db9fbso3058273otp.0
        for <kvm@vger.kernel.org>; Fri, 02 Jul 2021 13:29:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fmc5dDCDNgUCGurtDUVLQJtKxPKiPIBI/PH7SfH7U+s=;
        b=h1e7xMffCCQTF3WrlQge7DaD2gRqRr45/pPRcOfA/i8pS25T+NS2XCMVj/b0Loh1u6
         hLZz5WQOys/EStLba6XUDnfVkl8+DI6+Lycd++/54jGACCes9p3PtLCg8DXlvz9R2L16
         wT3A7vbOSrU7+0jIJ67f4m8fSqx7C/23UjZA8B4SpCXqoJq0xV2a8PG0egPy/OaiaCU7
         5ejBYiZGMuG4hmayEWAMuDJsH6RvLnedXRdMxGck/PGY8SeUpkttPowTA/mDcICUtSDK
         ULNvDqnbjcFjRY6A3uLQrlwrNNB2LekYl0yRCU/nQAp/8qKHc8Plcg3BROI5GvtA9EaR
         4dSA==
X-Gm-Message-State: AOAM531hI1Xe4dkeU/yEKh772xV9gy9pbkc/t4yGmgIj1DpsNx5br3Ud
        5NRE6l+BBtb8l+IcGCVUsxpA8WlyCPvsPQq9rY0CaJDYCEfCzzEgitTdgM7OMLRz/6ET3VCEqp2
        DddvWXMkYcF5P
X-Received: by 2002:aca:5c83:: with SMTP id q125mr1212838oib.145.1625257765870;
        Fri, 02 Jul 2021 13:29:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxID8tFygzc63+V/OnOwmURZq1R+FB5/h+aIx/TaQ4be7u+W/7HkgR7SQpmZd2ecmJ0FbfCDQ==
X-Received: by 2002:aca:5c83:: with SMTP id q125mr1212817oib.145.1625257765667;
        Fri, 02 Jul 2021 13:29:25 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id v3sm800954oon.11.2021.07.02.13.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 13:29:25 -0700 (PDT)
Date:   Fri, 2 Jul 2021 14:29:24 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <jgg@nvidia.com>,
        <mgurtovoy@nvidia.com>, <linuxarm@huawei.com>,
        <liulongfang@huawei.com>, <prime.zeng@hisilicon.com>,
        <yuzenghui@huawei.com>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: Re: [RFC v2 1/4] hisi-acc-vfio-pci: add new vfio_pci driver for
 HiSilicon ACC devices
Message-ID: <20210702142924.57ad33dc.alex.williamson@redhat.com>
In-Reply-To: <20210702095849.1610-2-shameerali.kolothum.thodi@huawei.com>
References: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
        <20210702095849.1610-2-shameerali.kolothum.thodi@huawei.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2 Jul 2021 10:58:46 +0100
Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:

> Add a vendor-specific vfio_pci driver for HiSilicon ACC devices.
> This will be extended in follow-up patches to add support for
> vfio live migration feature.
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  drivers/vfio/pci/Kconfig             |   9 +++
>  drivers/vfio/pci/Makefile            |   2 +
>  drivers/vfio/pci/hisi_acc_vfio_pci.c | 100 +++++++++++++++++++++++++++
>  3 files changed, 111 insertions(+)
>  create mode 100644 drivers/vfio/pci/hisi_acc_vfio_pci.c
> 
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index 9cdef46dd299..709807c28153 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -57,3 +57,12 @@ config MLX5_VFIO_PCI
>  	  framework.
>  
>  	  If you don't know what to do here, say N.
> +
> +config HISI_ACC_VFIO_PCI
> +	tristate "VFIO support for HiSilicon ACC devices"
> +	depends on ARM64 && VFIO_PCI_CORE
> +	help
> +	  This provides generic PCI support for HiSilicon devices using the VFIO
> +	  framework.
> +
> +	  If you don't know what to do here, say N.
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index a0df9c2a4bd9..d1de3e81921f 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -3,6 +3,7 @@
>  obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
>  obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
>  obj-$(CONFIG_MLX5_VFIO_PCI) += mlx5-vfio-pci.o
> +obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisi-acc-vfio-pci.o
>  
>  vfio-pci-core-y := vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
>  vfio-pci-core-$(CONFIG_S390) += vfio_pci_zdev.o
> @@ -11,3 +12,4 @@ vfio-pci-y := vfio_pci.o
>  vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
>  
>  mlx5-vfio-pci-y := mlx5_vfio_pci.o
> +hisi-acc-vfio-pci-y := hisi_acc_vfio_pci.o
> diff --git a/drivers/vfio/pci/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisi_acc_vfio_pci.c
> new file mode 100644
> index 000000000000..a9e173098ab5
> --- /dev/null
> +++ b/drivers/vfio/pci/hisi_acc_vfio_pci.c
> @@ -0,0 +1,100 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2021, HiSilicon Ltd.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/eventfd.h>
> +#include <linux/file.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/vfio.h>
> +#include <linux/vfio_pci_core.h>
> +
> +static int hisi_acc_vfio_pci_open(struct vfio_device *core_vdev)
> +{
> +	struct vfio_pci_core_device *vdev =
> +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> +	int ret;
> +
> +	lockdep_assert_held(&core_vdev->reflck->lock);
> +
> +	ret = vfio_pci_core_enable(vdev);
> +	if (ret)
> +		return ret;
> +
> +	vfio_pci_core_finish_enable(vdev);
> +
> +	return 0;
> +}
> +
> +static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
> +	.name		= "hisi-acc-vfio-pci",
> +	.open		= hisi_acc_vfio_pci_open,
> +	.release	= vfio_pci_core_release,
> +	.ioctl		= vfio_pci_core_ioctl,
> +	.read		= vfio_pci_core_read,
> +	.write		= vfio_pci_core_write,
> +	.mmap		= vfio_pci_core_mmap,
> +	.request	= vfio_pci_core_request,
> +	.match		= vfio_pci_core_match,
> +	.reflck_attach	= vfio_pci_core_reflck_attach,
> +};
> +
> +static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> +{
> +	struct vfio_pci_core_device *vdev;
> +	int ret;
> +
> +	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
> +	if (!vdev)
> +		return -ENOMEM;
> +
> +	ret = vfio_pci_core_register_device(vdev, pdev, &hisi_acc_vfio_pci_ops);
> +	if (ret)
> +		goto out_free;
> +
> +	dev_set_drvdata(&pdev->dev, vdev);
> +
> +	return 0;
> +
> +out_free:
> +	kfree(vdev);
> +	return ret;
> +}
> +
> +static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
> +{
> +	struct vfio_pci_core_device *vdev = dev_get_drvdata(&pdev->dev);
> +
> +	vfio_pci_core_unregister_device(vdev);
> +	kfree(vdev);
> +}
> +
> +static const struct pci_device_id hisi_acc_vfio_pci_table[] = {
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_HUAWEI, 0xa256) }, /* SEC VF */
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_HUAWEI, 0xa259) }, /* HPRE VF */
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_HUAWEI, 0xa251) }, /* ZIP VF */
> +	{ 0, }
> +};
> +
> +MODULE_DEVICE_TABLE(pci, hisi_acc_vfio_pci_table);
> +
> +static struct pci_driver hisi_acc_vfio_pci_driver = {
> +	.name			= "hisi-acc-vfio-pci",
> +	.id_table		= hisi_acc_vfio_pci_table,
> +	.probe			= hisi_acc_vfio_pci_probe,
> +	.remove			= hisi_acc_vfio_pci_remove,
> +#ifdef CONFIG_PCI_IOV
> +	.sriov_configure	= vfio_pci_core_sriov_configure,
> +#endif

The device table suggests only VFs are supported by this driver, so it
really shouldn't need sriov_configure support, right?  Thanks,

Alex

> +	.err_handler		= &vfio_pci_core_err_handlers,
> +};
> +
> +module_pci_driver(hisi_acc_vfio_pci_driver);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Liu Longfang <liulongfang@huawei.com>");
> +MODULE_AUTHOR("Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>");
> +MODULE_DESCRIPTION("HiSilicon VFIO PCI - Generic VFIO PCI driver for HiSilicon ACC device family");

