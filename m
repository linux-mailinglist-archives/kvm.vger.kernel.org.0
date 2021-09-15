Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF9040C67C
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 15:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234403AbhIONhU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 15 Sep 2021 09:37:20 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3822 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233472AbhIONhT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 09:37:19 -0400
Received: from fraeml703-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H8h4q2gZdz67Mx2;
        Wed, 15 Sep 2021 21:33:47 +0800 (CST)
Received: from lhreml719-chm.china.huawei.com (10.201.108.70) by
 fraeml703-chm.china.huawei.com (10.206.15.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Wed, 15 Sep 2021 15:35:58 +0200
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml719-chm.china.huawei.com (10.201.108.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 14:35:57 +0100
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.008; Wed, 15 Sep 2021 14:35:57 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        "Jonathan Cameron" <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: RE: [PATCH v3 4/6] hisi-acc-vfio-pci: add new vfio_pci driver for
 HiSilicon ACC devices
Thread-Topic: [PATCH v3 4/6] hisi-acc-vfio-pci: add new vfio_pci driver for
 HiSilicon ACC devices
Thread-Index: AQHXqhdFSlg0yljEzk6Hfj1kozgJ0quk++8AgAAMoPA=
Date:   Wed, 15 Sep 2021 13:35:57 +0000
Message-ID: <d5579a725a3c41e08f9096fb8d2d8d64@huawei.com>
References: <20210915095037.1149-1-shameerali.kolothum.thodi@huawei.com>
 <20210915095037.1149-5-shameerali.kolothum.thodi@huawei.com>
 <20210915125146.GI4065468@nvidia.com>
In-Reply-To: <20210915125146.GI4065468@nvidia.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.83.177]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgg@nvidia.com]
> Sent: 15 September 2021 13:52
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-crypto@vger.kernel.org; alex.williamson@redhat.com;
> mgurtovoy@nvidia.com; Linuxarm <linuxarm@huawei.com>; liulongfang
> <liulongfang@huawei.com>; Zengtao (B) <prime.zeng@hisilicon.com>;
> Jonathan Cameron <jonathan.cameron@huawei.com>; Wangzhou (B)
> <wangzhou1@hisilicon.com>
> Subject: Re: [PATCH v3 4/6] hisi-acc-vfio-pci: add new vfio_pci driver for
> HiSilicon ACC devices
> 
> On Wed, Sep 15, 2021 at 10:50:35AM +0100, Shameer Kolothum wrote:
> > +static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
> > +	.name		= "hisi-acc-vfio-pci",
> > +	.open_device	= hisi_acc_vfio_pci_open_device,
> > +	.close_device	= vfio_pci_core_close_device,
> > +	.ioctl		= vfio_pci_core_ioctl,
> > +	.read		= vfio_pci_core_read,
> > +	.write		= vfio_pci_core_write,
> > +	.mmap		= vfio_pci_core_mmap,
> > +	.request	= vfio_pci_core_request,
> > +	.match		= vfio_pci_core_match,
> > +};
> 
> Avoid horizontal alignments please

Sure.

> 
> > +static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev) {
> > +	struct vfio_pci_core_device *vdev = dev_get_drvdata(&pdev->dev);
> > +
> > +	vfio_pci_core_unregister_device(vdev);
> > +	vfio_pci_core_uninit_device(vdev);
> > +	kfree(vdev);
> > +}
> > +
> > +static const struct pci_device_id hisi_acc_vfio_pci_table[] = {
> > +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_HUAWEI,
> SEC_VF_PCI_DEVICE_ID) },
> > +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_HUAWEI,
> HPRE_VF_PCI_DEVICE_ID) },
> > +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_HUAWEI,
> ZIP_VF_PCI_DEVICE_ID) },
> > +	{ 0, }
> 
> Just {}

Ok.

 
> > +};
> > +
> > +MODULE_DEVICE_TABLE(pci, hisi_acc_vfio_pci_table);
> > +
> > +static struct pci_driver hisi_acc_vfio_pci_driver = {
> > +	.name			= "hisi-acc-vfio-pci",
> 
> This shoud be KBUILD_MODNAME, the string must always match the module
> name

Ok. Will update.

Thanks,
Shameer
