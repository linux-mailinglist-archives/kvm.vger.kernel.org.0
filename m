Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2F1C4C17EC
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 16:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242543AbiBWP6g convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 23 Feb 2022 10:58:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242541AbiBWP6f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 10:58:35 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F5CC249C;
        Wed, 23 Feb 2022 07:58:06 -0800 (PST)
Received: from fraeml739-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K3gYS5RWYz67mB8;
        Wed, 23 Feb 2022 23:53:16 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml739-chm.china.huawei.com (10.206.15.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 23 Feb 2022 16:58:04 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 23 Feb 2022 15:58:03 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.021; Wed, 23 Feb 2022 15:58:03 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Thread-Index: AQHYJxgOEQAq1mellU2EgPXLuddEUaygUS2AgAD74UA=
Date:   Wed, 23 Feb 2022 15:58:03 +0000
Message-ID: <76efe90279f64afb9a157b4f3fb45e4f@huawei.com>
References: <20220221114043.2030-1-shameerali.kolothum.thodi@huawei.com>
 <20220221114043.2030-8-shameerali.kolothum.thodi@huawei.com>
 <20220223005251.GJ10061@nvidia.com>
In-Reply-To: <20220223005251.GJ10061@nvidia.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.227.178]
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
> From: Jason Gunthorpe [mailto:jgg@nvidia.com]
> Sent: 23 February 2022 00:53
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-crypto@vger.kernel.org; alex.williamson@redhat.com;
> cohuck@redhat.com; mgurtovoy@nvidia.com; yishaih@nvidia.com; Linuxarm
> <linuxarm@huawei.com>; liulongfang <liulongfang@huawei.com>; Zengtao (B)
> <prime.zeng@hisilicon.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>
> Subject: Re: [PATCH v5 7/8] hisi_acc_vfio_pci: Add support for VFIO live
> migration
> 
> On Mon, Feb 21, 2022 at 11:40:42AM +0000, Shameer Kolothum wrote:
> 
> > +	/*
> > +	 * ACC VF dev BAR2 region consists of both functional register space
> > +	 * and migration control register space. For migration to work, we
> > +	 * need access to both. Hence, we map the entire BAR2 region here.
> > +	 * But from a security point of view, we restrict access to the
> > +	 * migration control space from Guest(Please see mmap/ioctl/read/write
> > +	 * override functions).
> > +	 *
> > +	 * Also the HiSilicon ACC VF devices supported by this driver on
> > +	 * HiSilicon hardware platforms are integrated end point devices
> > +	 * and has no capability to perform PCIe P2P.
> 
> If that is the case why not implement the RUNNING_P2P as well as a
> NOP?
> 
> Alex expressed concerned about proliferation of non-P2P devices as it
> complicates qemu to support mixes

Since both PRE_COPY and P2P are optional, Qemu anyway will have to check and
add the support, right?. Just worried the FSM will look complicated with both
PRE_COPY and P2P arcs now.

Thanks,
Shameer
