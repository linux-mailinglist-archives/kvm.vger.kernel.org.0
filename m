Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB0454C198C
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 18:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243273AbiBWRJu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 23 Feb 2022 12:09:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243241AbiBWRHr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 12:07:47 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CF45D19A;
        Wed, 23 Feb 2022 09:07:16 -0800 (PST)
Received: from fraeml734-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K3j5G4wg6z680ZP;
        Thu, 24 Feb 2022 01:02:26 +0800 (CST)
Received: from lhreml715-chm.china.huawei.com (10.201.108.66) by
 fraeml734-chm.china.huawei.com (10.206.15.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 23 Feb 2022 18:07:07 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml715-chm.china.huawei.com (10.201.108.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 23 Feb 2022 17:07:06 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.021; Wed, 23 Feb 2022 17:07:06 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: RE: [PATCH v5 7/8] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Topic: [PATCH v5 7/8] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Index: AQHYJxgOEQAq1mellU2EgPXLuddEUaygUS2AgAEHKICAAAi68A==
Date:   Wed, 23 Feb 2022 17:07:06 +0000
Message-ID: <60d48005f88a4d63b9a9228c0f4d95b9@huawei.com>
References: <20220221114043.2030-1-shameerali.kolothum.thodi@huawei.com>
        <20220221114043.2030-8-shameerali.kolothum.thodi@huawei.com>
        <20220223005251.GJ10061@nvidia.com>
 <20220223093443.367ee531.alex.williamson@redhat.com>
In-Reply-To: <20220223093443.367ee531.alex.williamson@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.27.208]
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
> Sent: 23 February 2022 16:35
> To: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
> kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-crypto@vger.kernel.org; cohuck@redhat.com; mgurtovoy@nvidia.com;
> yishaih@nvidia.com; Linuxarm <linuxarm@huawei.com>; liulongfang
> <liulongfang@huawei.com>; Zengtao (B) <prime.zeng@hisilicon.com>;
> Jonathan Cameron <jonathan.cameron@huawei.com>; Wangzhou (B)
> <wangzhou1@hisilicon.com>
> Subject: Re: [PATCH v5 7/8] hisi_acc_vfio_pci: Add support for VFIO live
> migration
> 
> On Tue, 22 Feb 2022 20:52:51 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Mon, Feb 21, 2022 at 11:40:42AM +0000, Shameer Kolothum wrote:
> >
> > > +	/*
> > > +	 * ACC VF dev BAR2 region consists of both functional register space
> > > +	 * and migration control register space. For migration to work, we
> > > +	 * need access to both. Hence, we map the entire BAR2 region here.
> > > +	 * But from a security point of view, we restrict access to the
> > > +	 * migration control space from Guest(Please see mmap/ioctl/read/write
> > > +	 * override functions).
> > > +	 *
> > > +	 * Also the HiSilicon ACC VF devices supported by this driver on
> > > +	 * HiSilicon hardware platforms are integrated end point devices
> > > +	 * and has no capability to perform PCIe P2P.
> >
> > If that is the case why not implement the RUNNING_P2P as well as a
> > NOP?
> >
> > Alex expressed concerned about proliferation of non-P2P devices as it
> > complicates qemu to support mixes
> 
> I read the above as more of a statement about isolation, ie. grouping.

That's right. That's what I meant by " no capability to perform PCIe P2P"

Thanks,
Shameer

> Given that all DMA from the device is translated by the IOMMU, how is
> it possible that a device can entirely lack p2p support, or even know
> that the target address post-translation is to a peer device rather
> than system memory.  If this is the case, it sounds like a restriction
> of the SMMU not supporting translations that reflect back to the I/O
> bus rather than a feature of the device itself.  Thanks,
> 
> Alex

