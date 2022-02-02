Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 236084A7589
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 17:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345696AbiBBQKM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 2 Feb 2022 11:10:12 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4662 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiBBQKJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 11:10:09 -0500
Received: from fraeml740-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JpmqB2Czqz67nGj;
        Thu,  3 Feb 2022 00:05:26 +0800 (CST)
Received: from lhreml716-chm.china.huawei.com (10.201.108.67) by
 fraeml740-chm.china.huawei.com (10.206.15.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Feb 2022 17:10:07 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml716-chm.china.huawei.com (10.201.108.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Feb 2022 16:10:06 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.021; Wed, 2 Feb 2022 16:10:06 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        "Jonathan Cameron" <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: RE: [RFC v2 0/4] vfio/hisilicon: add acc live migration driver
Thread-Topic: [RFC v2 0/4] vfio/hisilicon: add acc live migration driver
Thread-Index: AQHYGDbmFHRHIXj6i0KnDwR2h2vbX6yAR7aggAAeEICAAAa58A==
Date:   Wed, 2 Feb 2022 16:10:06 +0000
Message-ID: <c8a0731c589e49068a78afcc73d66bfa@huawei.com>
References: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
 <20220202131448.GA2538420@nvidia.com>
 <a29ae3ea51344e18b9659424772a4b42@huawei.com>
 <20220202153945.GT1786498@nvidia.com>
In-Reply-To: <20220202153945.GT1786498@nvidia.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.227.178]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgg@nvidia.com]
> Sent: 02 February 2022 15:40
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-crypto@vger.kernel.org; alex.williamson@redhat.com;
> mgurtovoy@nvidia.com; Linuxarm <linuxarm@huawei.com>; liulongfang
> <liulongfang@huawei.com>; Zengtao (B) <prime.zeng@hisilicon.com>;
> yuzenghui <yuzenghui@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>
> Subject: Re: [RFC v2 0/4] vfio/hisilicon: add acc live migration driver
> 
> On Wed, Feb 02, 2022 at 02:34:52PM +0000, Shameerali Kolothum Thodi
> wrote:
> 
> > > There are few topics to consider:
> > >  - Which of the three feature sets (STOP_COPY, P2P and PRECOPY) make
> > >    sense for this driver?
> >
> > I think it will be STOP_COPY only for now. We might have PRECOPY
> > feature once we have the SMMUv3 HTTU support in future.
> 
> HTTU is the dirty tracking feature? To be clear VFIO migration support for
> PRECOPY has nothing to do with IOMMU based dirty page tracking.

Yes, it is based on the IOMMU hardware dirty bit management support.
A RFC was posted sometime back,
https://lore.kernel.org/kvm/20210507103608.39440-1-zhukeqian1@huawei.com/

Ok, my guess was that the PRECOPY here was related. Thanks for clarifying.

> 
> > >  - I think we discussed the P2P implementation and decided it would
> > >    work for this device? Can you re-read and confirm?
> >
> > In our case these devices are Integrated End Point devices and doesn't
> > have P2P DMA capability. Hence the FSM arcs will be limited to
> > STOP_COPY feature I guess. Also, since we cannot guarantee a NDMA
> > state in STOP, my assumption currently is the onus of making sure that
> > no MMIO access happens in STOP is on the user. Is that a valid assumption?
> 
> Yes, you can treat RUNNING_P2P as the same as STOP and rely on no MMIO
> access to sustain it.

Ok.
 
> (and I'm wondering sometimes if we should rename RUNNING_P2P to
> STOP_P2P - ie the device is stopped but still allows inbound P2P to make this
> clearer)
> 
> > Do we need to set the below before the feature query?
> > Or am I using a wrong Qemu/kernel repo?
> >
> > +++ b/hw/vfio/migration.c
> > @@ -488,6 +488,7 @@ static int vfio_migration_query_flags(VFIODevice
> > *vbasedev, uint64_t *mig_flags)
> >      struct vfio_device_feature_migration *mig = (void
> > *)feature->data;
> >
> >      feature->argsz = sizeof(buf);
> > +    feature->flags = VFIO_DEVICE_FEATURE_MIGRATION |
> > + VFIO_DEVICE_FEATURE_GET;
> >      if (ioctl(vbasedev->fd, VFIO_DEVICE_FEATURE, feature) != 0)
> >          return -EOPNOTSUPP;
> 
> Oh, this is my mistake I thought this got pushed to that github already but
> didn't, I updated it.

Ok. Thanks.
 
> If you have a prototype can you post another RFC?

Sure, will do. I just started and has only a skeleton proto based on v2 now.
Will send out a RFC soon once I have all the FSM arcs implemented 
and sanity tested.

Thanks,
Shameer
