Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44F2A4D07B3
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 20:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244937AbiCGTaG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 7 Mar 2022 14:30:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbiCGTaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 14:30:05 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C39B6D1B9;
        Mon,  7 Mar 2022 11:29:09 -0800 (PST)
Received: from fraeml742-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KC7mX3YJtz67KPP;
        Tue,  8 Mar 2022 03:28:44 +0800 (CST)
Received: from lhreml714-chm.china.huawei.com (10.201.108.65) by
 fraeml742-chm.china.huawei.com (10.206.15.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 7 Mar 2022 20:29:07 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml714-chm.china.huawei.com (10.201.108.65) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 7 Mar 2022 19:29:06 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.021; Mon, 7 Mar 2022 19:29:06 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>,
        Xu Zaibo <xuzaibo@huawei.com>
Subject: RE: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Topic: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Index: AQHYL1LUtVDDY2S/e06nk5NDxfriXKyvtjsAgASXq4CAAAQkEA==
Date:   Mon, 7 Mar 2022 19:29:06 +0000
Message-ID: <aac9a26dc27140d9a1ce56ebdec393a6@huawei.com>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
        <20220303230131.2103-9-shameerali.kolothum.thodi@huawei.com>
        <20220304205720.GE219866@nvidia.com>
 <20220307120513.74743f17.alex.williamson@redhat.com>
In-Reply-To: <20220307120513.74743f17.alex.williamson@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.93.8]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: 07 March 2022 19:05
> To: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
> kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-crypto@vger.kernel.org; linux-pci@vger.kernel.org; cohuck@redhat.com;
> mgurtovoy@nvidia.com; yishaih@nvidia.com; Linuxarm
> <linuxarm@huawei.com>; liulongfang <liulongfang@huawei.com>; Zengtao (B)
> <prime.zeng@hisilicon.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>
> Subject: Re: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live
> migration
> 
> On Fri, 4 Mar 2022 16:57:20 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Thu, Mar 03, 2022 at 11:01:30PM +0000, Shameer Kolothum wrote:
> > > From: Longfang Liu <liulongfang@huawei.com>
> > >
> > > VMs assigned with HiSilicon ACC VF devices can now perform live
> migration
> > > if the VF devices are bind to the hisi_acc_vfio_pci driver.
> > >
> > > Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> > > Signed-off-by: Shameer Kolothum
> <shameerali.kolothum.thodi@huawei.com>
> > > ---
> > >  drivers/vfio/pci/hisilicon/Kconfig            |    7 +
> > >  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 1078 ++++++++++++++++-
> > >  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  114 ++
> > >  3 files changed, 1181 insertions(+), 18 deletions(-)
> > >  create mode 100644 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> > >
> > > diff --git a/drivers/vfio/pci/hisilicon/Kconfig
> b/drivers/vfio/pci/hisilicon/Kconfig
> > > index dc723bad05c2..2a68d39f339f 100644
> > > --- a/drivers/vfio/pci/hisilicon/Kconfig
> > > +++ b/drivers/vfio/pci/hisilicon/Kconfig
> > > @@ -3,6 +3,13 @@ config HISI_ACC_VFIO_PCI
> > >  	tristate "VFIO PCI support for HiSilicon ACC devices"
> > >  	depends on ARM64 || (COMPILE_TEST && 64BIT)
> > >  	depends on VFIO_PCI_CORE
> > > +	depends on PCI && PCI_MSI
> >
> > PCI is already in the depends from the 2nd line in
> > drivers/vfio/pci/Kconfig, but it is harmless
> >
> > > +	depends on UACCE || UACCE=n
> > > +	depends on ACPI
> >
> > Scratching my head a bit on why we have these
> 
> Same curiosity from me, each of the CRYPTO_DEV_HISI_* options selected
> also depend on these so they seem redundant.

Yes, they are redundant now since we have added CRYPTO_DEV_HISI_ drivers
as "depends" now. I will remove that.
 
> I think we still require acks from Bjorn and Zaibo for select patches
> in this series.

I checked with Ziabo. He moved projects and is no longer looking into crypto stuff.
Wangzhou and LiuLongfang now take care of this. Received acks from Wangzhou
already and I will request Longfang to provide his. Hope that's ok.

> 
> From me, I would request a MAINTAINERS entry similar to the one the
> mlx5 folks added for their driver.  This should be in patch 4/9 where
> the driver is originally added.  Thanks,

Ok I will do that. I will pick up the R-by tags as well and send out v9 by
tomorrow.

Thanks,
Shameer 

