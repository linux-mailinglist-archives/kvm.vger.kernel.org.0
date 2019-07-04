Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A310B5F844
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 14:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbfGDMge convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 4 Jul 2019 08:36:34 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:33050 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727686AbfGDMgd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 08:36:33 -0400
Received: from lhreml709-cah.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id E916422570C208935E2E;
        Thu,  4 Jul 2019 13:36:31 +0100 (IST)
Received: from LHREML524-MBS.china.huawei.com ([169.254.2.154]) by
 lhreml709-cah.china.huawei.com ([10.201.108.32]) with mapi id 14.03.0415.000;
 Thu, 4 Jul 2019 13:36:24 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "pmorel@linux.vnet.ibm.com" <pmorel@linux.vnet.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Linuxarm <linuxarm@huawei.com>,
        "John Garry" <john.garry@huawei.com>,
        "xuwei (O)" <xuwei5@huawei.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>
Subject: RE: [PATCH v7 1/6] vfio/type1: Introduce iova list and add iommu
 aperture validity check
Thread-Topic: [PATCH v7 1/6] vfio/type1: Introduce iova list and add iommu
 aperture validity check
Thread-Index: AQHVLDHPKQQdUzHkf0S0a1+iQm67I6a5VDgAgAEdS/A=
Date:   Thu, 4 Jul 2019 12:36:24 +0000
Message-ID: <5FC3163CFD30C246ABAA99954A238FA83F2DDB26@lhreml524-mbs.china.huawei.com>
References: <20190626151248.11776-1-shameerali.kolothum.thodi@huawei.com>
        <20190626151248.11776-2-shameerali.kolothum.thodi@huawei.com>
 <20190703143418.34a0f1c6@x1.home>
In-Reply-To: <20190703143418.34a0f1c6@x1.home>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.34.206.221]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: 03 July 2019 21:34
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: eric.auger@redhat.com; pmorel@linux.vnet.ibm.com;
> kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> iommu@lists.linux-foundation.org; Linuxarm <linuxarm@huawei.com>; John
> Garry <john.garry@huawei.com>; xuwei (O) <xuwei5@huawei.com>;
> kevin.tian@intel.com
> Subject: Re: [PATCH v7 1/6] vfio/type1: Introduce iova list and add iommu
> aperture validity check
> 
> 
> Welcome back Shameer ;)

Thanks Alex :)

> 
> On Wed, 26 Jun 2019 16:12:43 +0100
> Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:
> 
> > This introduces an iova list that is valid for dma mappings. Make sure
> > the new iommu aperture window doesn't conflict with the current one or
> > with any existing dma mappings during attach.
> >
> > Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > ---
> >  drivers/vfio/vfio_iommu_type1.c | 181
> > +++++++++++++++++++++++++++++++-
> >  1 file changed, 177 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/vfio/vfio_iommu_type1.c
> > b/drivers/vfio/vfio_iommu_type1.c index add34adfadc7..970d1ec06aed
> > 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -1,4 +1,3 @@
> > -// SPDX-License-Identifier: GPL-2.0-only
> >  /*
> >   * VFIO: IOMMU DMA mapping support for Type1 IOMMU
> >   *
> 
> Accidental merge deletion?  Thanks,
>

Yes it is. I will fix it.

Thanks,
Shameer

 
> Alex
