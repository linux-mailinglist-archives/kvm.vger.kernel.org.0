Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEAC4CA04F
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 10:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240325AbiCBJIZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 2 Mar 2022 04:08:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237615AbiCBJIY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 04:08:24 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D7A31532;
        Wed,  2 Mar 2022 01:07:41 -0800 (PST)
Received: from fraeml743-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K7pBv2bRRz67LWc;
        Wed,  2 Mar 2022 17:06:31 +0800 (CST)
Received: from lhreml717-chm.china.huawei.com (10.201.108.68) by
 fraeml743-chm.china.huawei.com (10.206.15.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 10:07:39 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml717-chm.china.huawei.com (10.201.108.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 09:07:38 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.021; Wed, 2 Mar 2022 09:07:38 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
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
Subject: RE: [PATCH v6 09/10] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Topic: [PATCH v6 09/10] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Index: AQHYLIIBaGfq6jzuvUWvoNXYZoVi1qypDgGAgAAyBYCAAAJ0AIAAJJMAgAADqICAAA5SAIAAKPSAgABSJgCAAI+xAIAAaN2AgAATPQCAACLkgIAAFhCAgACQeqA=
Date:   Wed, 2 Mar 2022 09:07:38 +0000
Message-ID: <635f11c40e814d749ccf533f1414ba4e@huawei.com>
References: <20220228180520.GO219866@nvidia.com>
 <20220228131614.27ad37dc.alex.williamson@redhat.com>
 <20220228202919.GP219866@nvidia.com>
 <20220228142034.024e7be6.alex.williamson@redhat.com>
 <20220228234709.GV219866@nvidia.com>
 <20220228214110.4deb551f.alex.williamson@redhat.com>
 <20220301131528.GW219866@nvidia.com>
 <20220301123047.1171c730.alex.williamson@redhat.com>
 <20220301203938.GY219866@nvidia.com>
 <20220301154431.42b27278.alex.williamson@redhat.com>
 <20220302000329.GZ219866@nvidia.com>
In-Reply-To: <20220302000329.GZ219866@nvidia.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.91.128]
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
> Sent: 02 March 2022 00:03
> To: Alex Williamson <alex.williamson@redhat.com>
> Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
> kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-crypto@vger.kernel.org; cohuck@redhat.com; mgurtovoy@nvidia.com;
> yishaih@nvidia.com; Linuxarm <linuxarm@huawei.com>; liulongfang
> <liulongfang@huawei.com>; Zengtao (B) <prime.zeng@hisilicon.com>;
> Jonathan Cameron <jonathan.cameron@huawei.com>; Wangzhou (B)
> <wangzhou1@hisilicon.com>
> Subject: Re: [PATCH v6 09/10] hisi_acc_vfio_pci: Add support for VFIO live
> migration
> 
> On Tue, Mar 01, 2022 at 03:44:31PM -0700, Alex Williamson wrote:
> > On Tue, 1 Mar 2022 16:39:38 -0400
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > > On Tue, Mar 01, 2022 at 12:30:47PM -0700, Alex Williamson wrote:
> > > > Wouldn't it make more sense if initial-bytes started at QM_MATCH_SIZE
> > > > and dirty-bytes was always sizeof(vf_data) - QM_MATCH_SIZE?  ie.
> QEMU
> > > > would know that it has sizeof(vf_data) - QM_MATCH_SIZE remaining even
> > > > while it's getting ENOMSG after reading QM_MATCH_SIZE bytes of data.
> > >
> > > The purpose of this ioctl is to help userspace guess when moving on to
> > > STOP_COPY is a good idea ie when the device has done almost all the
> > > work it is going to be able to do in PRE_COPY. ENOMSG is a similar
> > > indicator.
> > >
> > > I expect all devices to have some additional STOP_COPY trailer_data in
> > > addition to their PRE_COPY initial_data and dirty_data
> > >
> > > There is a choice to make if we report the trailer_data during
> > > PRE_COPY or not. As this is all estimates, it doesn't matter unless
> > > the trailer_data is very big.
> > >
> > > Having all devices trend toward a 0 dirty_bytes to say they are are
> > > done all the pre-copy they can do makes sense from an API
> > > perspective. If one device trends toward 10MB due to a big
> > > trailer_data and one trends toward 0 bytes, how will qemu consistently
> > > decide when best to trigger STOP_COPY? It makes the API less useful.
> > >
> > > So, I would not include trailer_data in the dirty_bytes.
> >
> > That assumes that it's possible to keep up with the device dirty
> > rate.
> 
> It keeps options open so we have this choice someday.
> 
> We already see that implementations are using vCPU throttling as part
> of their migration strategy, and we are seriously looking at DMA
> throttling. It is not a big leap to imagine that
> internal-state-dirtying throttling will happne someday.
> 
> With throttling iterations would ratchet up the throttle until they
> reach an absolute small amount of dirty then cut over to STOP_COPY
> 
> > It seems like a better approach for userspace would be to look at how
> > dirty_bytes is trending.
> 
> It may be biw, but this approach doesn't care if the trailing_bytes
> are included or not, so lets leave them out and preserve the other
> operating model.
> 
> > If we exclude STOP_COPY trailing data from the VFIO_DEVICE_MIG_PRECOPY
> > ioctl, it seems even more of a disconnect that when we enter the
> > STOP_COPY state, suddenly we start getting new data out of a PRECOPY
> > ioctl.
> 
> Why? That amounts can go up at any time, how does it matter if it goes
> up after STOP_COPY or instantly before?
> 
> > BTW, "VFIO_DEVICE" should be reserved for ioctls and data structures
> > relative to the device FD, appending it with _MIG is too subtle for me.
> > This is also a GET operation for INFO, so I'd think for consistency
> > with the existing vfio uAPI we'd name this something like
> > VFIO_MIG_GET_PRECOPY_INFO where the structure might be named
> > vfio_precopy_info.
> 
> Sure
> 
> > So if we don't think this is the right approach for STOP_COPY, then why
> > are we pushing that it has any purpose outside of PRECOPY or might be
> > implemented by a non-PRECOPY driver for use in STOP_COPY?
> 
> It is just simpler and more consistent to implement the math under
> this ioctl in all cases then to try and artificially restrict it.
> 
> But I don't have a use case for it, so lets block it if you prefer.
> 
> Shameerali will you make these adjustments to the PRE_COPY patch?

Sure. I think we can summarize the discussion as below,

 - Rename the MIG_PRECOPY ioctl to VFIO_MIG_GET_PRECOPY_INFO and
  structure to vfio_precopy_info.
 - This ioctl is only valid in PRE_COPY state and should return -EINVAL in
  other states(Update the documentation).
 - No changes to the initial_bytes & dirty_bytes descriptions.

Please let me know if I missed anything.

I will address other comments on this series as well and sent out a
revised one soon.

Thanks,
Shameer    
