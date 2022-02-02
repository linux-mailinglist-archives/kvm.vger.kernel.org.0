Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED7A84A7341
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 15:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345031AbiBBOe4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 2 Feb 2022 09:34:56 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4661 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234062AbiBBOez (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 09:34:55 -0500
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jpkp33h5Xz67cpv;
        Wed,  2 Feb 2022 22:34:19 +0800 (CST)
Received: from lhreml713-chm.china.huawei.com (10.201.108.64) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Feb 2022 15:34:52 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml713-chm.china.huawei.com (10.201.108.64) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Feb 2022 14:34:52 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.021; Wed, 2 Feb 2022 14:34:52 +0000
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
Thread-Index: AQHYGDbmFHRHIXj6i0KnDwR2h2vbX6yAR7ag
Date:   Wed, 2 Feb 2022 14:34:52 +0000
Message-ID: <a29ae3ea51344e18b9659424772a4b42@huawei.com>
References: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
 <20220202131448.GA2538420@nvidia.com>
In-Reply-To: <20220202131448.GA2538420@nvidia.com>
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
> Sent: 02 February 2022 13:15
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-crypto@vger.kernel.org; alex.williamson@redhat.com;
> mgurtovoy@nvidia.com; Linuxarm <linuxarm@huawei.com>; liulongfang
> <liulongfang@huawei.com>; Zengtao (B) <prime.zeng@hisilicon.com>;
> yuzenghui <yuzenghui@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>
> Subject: Re: [RFC v2 0/4] vfio/hisilicon: add acc live migration driver
> 
> On Fri, Jul 02, 2021 at 10:58:45AM +0100, Shameer Kolothum wrote:
> > This series attempts to add vfio live migration support for
> > HiSilicon ACC VF devices. HiSilicon ACC VF device MMIO space
> > includes both the functional register space and migration
> > control register space. As discussed in RFCv1[0], this may create
> > security issues as these regions get shared between the Guest
> > driver and the migration driver. Based on the feedback, we tried
> > to address those concerns in this version.
> >
> > This is now based on the new vfio-pci-core framework proposal[1].
> > Understand that the framework proposal is still under discussion,
> > but really appreciate any feedback on the approach taken here
> > to mitigate the security risks.
> 
> Hi, can you look at the v6 proposal for the mlx5 implementation of the
> migration API and see if it meets hisilicon acc's needs as well?
> 
> https://lore.kernel.org/all/20220130160826.32449-1-yishaih@nvidia.com/

Yes, I saw that one. Thanks for that and is now looking into it.

> 
> There are few topics to consider:
>  - Which of the three feature sets (STOP_COPY, P2P and PRECOPY) make
>    sense for this driver?

I think it will be STOP_COPY only for now. We might have PRECOPY feature once
we have the SMMUv3 HTTU support in future.

> 
>    I see pf_qm_state_pre_save() but didn't understand why it wanted to
>    send the first 32 bytes in the PRECOPY mode? It is fine, but it
>    will add some complexity to continue to do this.

That was mainly to do a quick verification between src and dst compatibility
before we start saving the state. I think probably we can delay that check
for later.

>  - I think we discussed the P2P implementation and decided it would
>    work for this device? Can you re-read and confirm?

In our case these devices are Integrated End Point devices and doesn't have
P2P DMA capability. Hence the FSM arcs will be limited to STOP_COPY feature
I guess. Also, since we cannot guarantee a NDMA state in STOP, my
assumption currently is the onus of making sure that no MMIO access happens 
in STOP is on the user. Is that a valid assumption?

>  - Are the arcs we defined going to work here as well? The current
>    implementation in hisi_acc_vf_set_device_state() is very far away
>    from what the v1 protocol is, so I'm having a hard time guessing,
>    but..

Right. The FSM has changed a couple of times since we posted this.
I am going to rebase all that now.

>       RESUMING -> STOP
>         Probably vf_qm_state_resume()
> 
>       RUNNING -> STOP
>         vf_qm_fun_restart() - that is oddly named..
> 
>       STOP -> RESUMING
>         Seems to be a nop (likely a bug)
> 
>       STOP -> RUNNING
>          Not implemented currenty? (also a bug)
> 
>       STOP -> STOP_COPY
>          pf_qm_state_pre_save / vf_qm_state_save
> 
>       STOP_COPY -> STOP
>          NOP

I will check and verify this.

>    And the modification for the P2P/NO DMA is presumably just
>    fun_restart too since stopping the device and stopping DMA are
>    going to be the same thing here?

Yes, in our case stopping device and stopping DMA are effectively the
same thing.

> 
> The mlx5 implementation linked above is a full example you can cut and
> paste from for how to implement the state function and the how to do
> the data transfer. The f_ops read/write implementation for acc looks
> trivial as it only streams the fixed size and pre-allocated 'struct
> acc_vf_data'
> 
> It looks like it would be a short path to implement our v2 proposal
> and remove a lot of driver code, as we saw in mlx5.
> 

Ok. These are the git repo I am using for the rework,
https://github.com/jgunthorpe/qemu/commits/vfio_migration_v2
https://github.com/jgunthorpe/linux/tree/vfio_migration_v2

Please let me know if the above are not up to date.

Also, just noted that my quick prototype is now failing
with below error,

" Error: VFIO device doesn't support migration"

Do we need to set the below before the feature query?
Or am I using a wrong Qemu/kernel repo?

--- a/hw/vfio/migration.c
+++ b/hw/vfio/migration.c
@@ -488,6 +488,7 @@ static int vfio_migration_query_flags(VFIODevice
*vbasedev, uint64_t *mig_flags)
     struct vfio_device_feature_migration *mig = (void *)feature->data;

     feature->argsz = sizeof(buf);
+    feature->flags = VFIO_DEVICE_FEATURE_MIGRATION | VFIO_DEVICE_FEATURE_GET;
     if (ioctl(vbasedev->fd, VFIO_DEVICE_FEATURE, feature) != 0)
         return -EOPNOTSUPP;

Thanks,
Shameer

