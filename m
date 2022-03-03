Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB054CBEDA
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 14:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbiCCN2t convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 3 Mar 2022 08:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233718AbiCCN2i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 08:28:38 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C1C45AC9;
        Thu,  3 Mar 2022 05:27:50 -0800 (PST)
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K8WwX3c3Bz67LY8;
        Thu,  3 Mar 2022 21:26:36 +0800 (CST)
Received: from lhreml717-chm.china.huawei.com (10.201.108.68) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Thu, 3 Mar 2022 14:27:47 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml717-chm.china.huawei.com (10.201.108.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 3 Mar 2022 13:27:47 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.021; Thu, 3 Mar 2022 13:27:47 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: RE: [PATCH v7 09/10] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Topic: [PATCH v7 09/10] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Index: AQHYLltL2nbHr5hFZkexUhHVpQU6TqyszJkAgADNzBCAAAc9gIAAApOwgAABvwCAAAGdUA==
Date:   Thu, 3 Mar 2022 13:27:47 +0000
Message-ID: <e1b861245e244bf4af27d0f96fa42efc@huawei.com>
References: <20220302172903.1995-1-shameerali.kolothum.thodi@huawei.com>
 <20220302172903.1995-10-shameerali.kolothum.thodi@huawei.com>
 <20220303002142.GE1026713@nvidia.com>
 <19e294814f284755b207be3ba7054ec2@huawei.com>
 <20220303130411.GY219866@nvidia.com>
 <f2172fa9f84447699cb0973bec3ca0da@huawei.com>
 <20220303131938.GA219866@nvidia.com>
In-Reply-To: <20220303131938.GA219866@nvidia.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.82.4]
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
> Sent: 03 March 2022 13:20
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-crypto@vger.kernel.org; linux-pci@vger.kernel.org;
> alex.williamson@redhat.com; cohuck@redhat.com; mgurtovoy@nvidia.com;
> yishaih@nvidia.com; Linuxarm <linuxarm@huawei.com>; liulongfang
> <liulongfang@huawei.com>; Zengtao (B) <prime.zeng@hisilicon.com>;
> Jonathan Cameron <jonathan.cameron@huawei.com>; Wangzhou (B)
> <wangzhou1@hisilicon.com>
> Subject: Re: [PATCH v7 09/10] hisi_acc_vfio_pci: Add support for VFIO live
> migration
> 
> On Thu, Mar 03, 2022 at 01:17:05PM +0000, Shameerali Kolothum Thodi
> wrote:
> > > Tthere is a scenario that transfers only QM_MATCH_SIZE in stop_copy?
> > > This doesn't seem like a good idea, I think you should transfer a
> > > positive indication 'this device is not ready' instead of truncating
> > > the stream. A truncated stream should not be a valid stream.
> > >
> > > ie always transfer the whole struct.
> >
> > We could add a 'qm_state' and return the whole struct. But the rest
> > of the struct is basically invalid if qm_state = QM_NOT_REDAY.
> 
> This seems like the right thing to do to me
> 
> > > > Looks like setting the total_length = 0 in STOP_COPY is a better
> > > > solution(If there are no other issues with that) as it will avoid
> > > > grabbing the state_mutex as you mentioned above.
> > >
> > > That seems really weird, I wouldn't recommend doing that..
> >
> > Does that mean we don't support a zero data transfer in STOP_COPY?
> 
> total_length should not go backwards
> 
> > The concern is if we always transfer the whole struct, we end up reading
> > and writing the whole thing even if most of the data is invalid.
> 
> Well, you can't know if the device is not ready or not until the
> reaching STOP_COPY, so you have to transfer something to avoid
> truncating the data stream. The state here is tiny, is the extra
> transfer a real worry?

Ok, don't think so. I will introduce the 'qm_state' and handle it as discussed
above then.

Thanks,
Shameer 
