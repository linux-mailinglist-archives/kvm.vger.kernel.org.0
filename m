Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C073BB7B0
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 09:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbhGEHWv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 5 Jul 2021 03:22:51 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3350 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhGEHWv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jul 2021 03:22:51 -0400
Received: from fraeml713-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GJH1l3TrLz6FBHX;
        Mon,  5 Jul 2021 15:12:11 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml713-chm.china.huawei.com (10.206.15.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 5 Jul 2021 09:20:12 +0200
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 5 Jul 2021 08:20:11 +0100
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2176.012; Mon, 5 Jul 2021 08:20:11 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: RE: [RFC v2 1/4] hisi-acc-vfio-pci: add new vfio_pci driver for
 HiSilicon ACC devices
Thread-Topic: [RFC v2 1/4] hisi-acc-vfio-pci: add new vfio_pci driver for
 HiSilicon ACC devices
Thread-Index: AQHXbyjyY32E69+qSUOJDcpRvpWsY6swEs4AgAPb9MA=
Date:   Mon, 5 Jul 2021 07:20:11 +0000
Message-ID: <1582579447b449f496904f219402acb2@huawei.com>
References: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
        <20210702095849.1610-2-shameerali.kolothum.thodi@huawei.com>
 <20210702142924.57ad33dc.alex.williamson@redhat.com>
In-Reply-To: <20210702142924.57ad33dc.alex.williamson@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.83.49]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: 02 July 2021 21:29
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-crypto@vger.kernel.org; jgg@nvidia.com; mgurtovoy@nvidia.com;
> Linuxarm <linuxarm@huawei.com>; liulongfang <liulongfang@huawei.com>;
> Zengtao (B) <prime.zeng@hisilicon.com>; yuzenghui
> <yuzenghui@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>
> Subject: Re: [RFC v2 1/4] hisi-acc-vfio-pci: add new vfio_pci driver for HiSilicon
> ACC devices
> 
> On Fri, 2 Jul 2021 10:58:46 +0100
> Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:
> 
> > Add a vendor-specific vfio_pci driver for HiSilicon ACC devices.
> > This will be extended in follow-up patches to add support for
> > vfio live migration feature.
> >
> > Signed-off-by: Shameer Kolothum
> <shameerali.kolothum.thodi@huawei.com>
> > ---
> >  drivers/vfio/pci/Kconfig             |   9 +++
> >  drivers/vfio/pci/Makefile            |   2 +
> >  drivers/vfio/pci/hisi_acc_vfio_pci.c | 100 +++++++++++++++++++++++++++
> >  3 files changed, 111 insertions(+)
> >  create mode 100644 drivers/vfio/pci/hisi_acc_vfio_pci.c
> >
> > diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> > index 9cdef46dd299..709807c28153 100644
> > --- a/drivers/vfio/pci/Kconfig
> > +++ b/drivers/vfio/pci/Kconfig
> > @@ -57,3 +57,12 @@ config MLX5_VFIO_PCI
> >  	  framework.
> >
> >  	  If you don't know what to do here, say N.
> > +
> > +config HISI_ACC_VFIO_PCI
> > +	tristate "VFIO support for HiSilicon ACC devices"
> > +	depends on ARM64 && VFIO_PCI_CORE
> > +	help
> > +	  This provides generic PCI support for HiSilicon devices using the VFIO
> > +	  framework.
> > +
> > +	  If you don't know what to do here, say N.
> > diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> > index a0df9c2a4bd9..d1de3e81921f 100644
> > --- a/drivers/vfio/pci/Makefile
> > +++ b/drivers/vfio/pci/Makefile
> > @@ -3,6 +3,7 @@
> >  obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
> >  obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
> >  obj-$(CONFIG_MLX5_VFIO_PCI) += mlx5-vfio-pci.o
> > +obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisi-acc-vfio-pci.o
> >
> >  vfio-pci-core-y := vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o
> vfio_pci_config.o
> >  vfio-pci-core-$(CONFIG_S390) += vfio_pci_zdev.o
> > @@ -11,3 +12,4 @@ vfio-pci-y := vfio_pci.o
> >  vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
> >
> >  mlx5-vfio-pci-y := mlx5_vfio_pci.o
> > +hisi-acc-vfio-pci-y := hisi_acc_vfio_pci.o
> > diff --git a/drivers/vfio/pci/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisi_acc_vfio_pci.c
> > new file mode 100644
> > index 000000000000..a9e173098ab5
> > --- /dev/null
> > +++ b/drivers/vfio/pci/hisi_acc_vfio_pci.c
> > @@ -0,0 +1,100 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Copyright (c) 2021, HiSilicon Ltd.
> > + */
> > +
> > +#include <linux/device.h>
> > +#include <linux/eventfd.h>
> > +#include <linux/file.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/module.h>
> > +#include <linux/pci.h>
> > +#include <linux/vfio.h>
> > +#include <linux/vfio_pci_core.h>
> > +
> > +static int hisi_acc_vfio_pci_open(struct vfio_device *core_vdev)
> > +{
> > +	struct vfio_pci_core_device *vdev =
> > +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> > +	int ret;
> > +
> > +	lockdep_assert_held(&core_vdev->reflck->lock);
> > +
> > +	ret = vfio_pci_core_enable(vdev);
> > +	if (ret)
> > +		return ret;
> > +
> > +	vfio_pci_core_finish_enable(vdev);
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
> > +	.name		= "hisi-acc-vfio-pci",
> > +	.open		= hisi_acc_vfio_pci_open,
> > +	.release	= vfio_pci_core_release,
> > +	.ioctl		= vfio_pci_core_ioctl,
> > +	.read		= vfio_pci_core_read,
> > +	.write		= vfio_pci_core_write,
> > +	.mmap		= vfio_pci_core_mmap,
> > +	.request	= vfio_pci_core_request,
> > +	.match		= vfio_pci_core_match,
> > +	.reflck_attach	= vfio_pci_core_reflck_attach,
> > +};
> > +
> > +static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct
> pci_device_id *id)
> > +{
> > +	struct vfio_pci_core_device *vdev;
> > +	int ret;
> > +
> > +	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
> > +	if (!vdev)
> > +		return -ENOMEM;
> > +
> > +	ret = vfio_pci_core_register_device(vdev, pdev, &hisi_acc_vfio_pci_ops);
> > +	if (ret)
> > +		goto out_free;
> > +
> > +	dev_set_drvdata(&pdev->dev, vdev);
> > +
> > +	return 0;
> > +
> > +out_free:
> > +	kfree(vdev);
> > +	return ret;
> > +}
> > +
> > +static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
> > +{
> > +	struct vfio_pci_core_device *vdev = dev_get_drvdata(&pdev->dev);
> > +
> > +	vfio_pci_core_unregister_device(vdev);
> > +	kfree(vdev);
> > +}
> > +
> > +static const struct pci_device_id hisi_acc_vfio_pci_table[] = {
> > +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_HUAWEI,
> 0xa256) }, /* SEC VF */
> > +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_HUAWEI,
> 0xa259) }, /* HPRE VF */
> > +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_HUAWEI,
> 0xa251) }, /* ZIP VF */
> > +	{ 0, }
> > +};
> > +
> > +MODULE_DEVICE_TABLE(pci, hisi_acc_vfio_pci_table);
> > +
> > +static struct pci_driver hisi_acc_vfio_pci_driver = {
> > +	.name			= "hisi-acc-vfio-pci",
> > +	.id_table		= hisi_acc_vfio_pci_table,
> > +	.probe			= hisi_acc_vfio_pci_probe,
> > +	.remove			= hisi_acc_vfio_pci_remove,
> > +#ifdef CONFIG_PCI_IOV
> > +	.sriov_configure	= vfio_pci_core_sriov_configure,
> > +#endif
> 
> The device table suggests only VFs are supported by this driver, so it
> really shouldn't need sriov_configure support, right?  Thanks,

Right. Only VFs are supported. I will remove this.

Thanks,
Shameer

> 
> Alex
> 
> > +	.err_handler		= &vfio_pci_core_err_handlers,
> > +};
> > +
> > +module_pci_driver(hisi_acc_vfio_pci_driver);
> > +
> > +MODULE_LICENSE("GPL v2");
> > +MODULE_AUTHOR("Liu Longfang <liulongfang@huawei.com>");
> > +MODULE_AUTHOR("Shameer Kolothum
> <shameerali.kolothum.thodi@huawei.com>");
> > +MODULE_DESCRIPTION("HiSilicon VFIO PCI - Generic VFIO PCI driver for
> HiSilicon ACC device family");

