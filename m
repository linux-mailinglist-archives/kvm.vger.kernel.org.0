Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC813BB998
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 10:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbhGEIuE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 5 Jul 2021 04:50:04 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3355 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbhGEIuD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jul 2021 04:50:03 -0400
Received: from fraeml708-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GJJqS2Hp9z6H8MM;
        Mon,  5 Jul 2021 16:33:24 +0800 (CST)
Received: from lhreml716-chm.china.huawei.com (10.201.108.67) by
 fraeml708-chm.china.huawei.com (10.206.15.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 5 Jul 2021 10:47:24 +0200
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml716-chm.china.huawei.com (10.201.108.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 5 Jul 2021 09:47:24 +0100
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2176.012; Mon, 5 Jul 2021 09:47:24 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        "Jonathan Cameron" <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: RE: [RFC v2 1/4] hisi-acc-vfio-pci: add new vfio_pci driver for
 HiSilicon ACC devices
Thread-Topic: [RFC v2 1/4] hisi-acc-vfio-pci: add new vfio_pci driver for
 HiSilicon ACC devices
Thread-Index: AQHXbyjyY32E69+qSUOJDcpRvpWsY6syVlwAgAGohwA=
Date:   Mon, 5 Jul 2021 08:47:23 +0000
Message-ID: <fc9d6b0b82254fbdb1cc96365b5bdef3@huawei.com>
References: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
 <20210702095849.1610-2-shameerali.kolothum.thodi@huawei.com>
 <YOFdTnlkcDZzw4b/@unreal>
In-Reply-To: <YOFdTnlkcDZzw4b/@unreal>
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
> From: Leon Romanovsky [mailto:leon@kernel.org]
> Sent: 04 July 2021 08:04
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-crypto@vger.kernel.org; alex.williamson@redhat.com; jgg@nvidia.com;
> mgurtovoy@nvidia.com; Linuxarm <linuxarm@huawei.com>; liulongfang
> <liulongfang@huawei.com>; Zengtao (B) <prime.zeng@hisilicon.com>;
> yuzenghui <yuzenghui@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>
> Subject: Re: [RFC v2 1/4] hisi-acc-vfio-pci: add new vfio_pci driver for HiSilicon
> ACC devices
> 
> On Fri, Jul 02, 2021 at 10:58:46AM +0100, Shameer Kolothum wrote:
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
> 
> <...>
> 
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
> 
> I don't remember what was proposed in vfio-pci-core conversion patches,
> but would expect that default behaviour is to fallback to vfio_pci_core_* API
> if ".release/.ioctl/e.t.c" are not redefined.

Yes, that would be nice, but don't think it does that in latest(v4).

Hi Max,
Could we please consider fall back to the core defaults, may be check and assign defaults
in vfio_pci_core_register_device() ?

Thanks,
Shameer
