Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 477E64CDF2E
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 22:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiCDUhi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 4 Mar 2022 15:37:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbiCDUh2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:37:28 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582AC219EFB;
        Fri,  4 Mar 2022 12:36:27 -0800 (PST)
Received: from fraeml702-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K9KNX3dmXz67Kvx;
        Sat,  5 Mar 2022 04:35:08 +0800 (CST)
Received: from lhreml718-chm.china.huawei.com (10.201.108.69) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Fri, 4 Mar 2022 21:36:24 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml718-chm.china.huawei.com (10.201.108.69) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 4 Mar 2022 20:36:24 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.021; Fri, 4 Mar 2022 20:36:24 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>,
        Linuxarm <linuxarm@huawei.com>
Subject: RE: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Topic: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Index: AQHYL1LUtVDDY2S/e06nk5NDxfriXKyu5+MQgAC55gCAAA3s0A==
Date:   Fri, 4 Mar 2022 20:36:24 +0000
Message-ID: <7a1802e00d1a4741bbf9978b960bfa06@huawei.com>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
        <20220303230131.2103-9-shameerali.kolothum.thodi@huawei.com>
        <0dc03eab33b74e6ea95f2ac0eb39cc83@huawei.com>
 <20220304124410.02423606.alex.williamson@redhat.com>
In-Reply-To: <20220304124410.02423606.alex.williamson@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.89.131]
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
> Sent: 04 March 2022 19:44
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-crypto@vger.kernel.org; linux-pci@vger.kernel.org; jgg@nvidia.com;
> cohuck@redhat.com; mgurtovoy@nvidia.com; yishaih@nvidia.com;
> liulongfang <liulongfang@huawei.com>; Zengtao (B)
> <prime.zeng@hisilicon.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>
> Subject: Re: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live
> migration
> 
> On Fri, 4 Mar 2022 08:48:27 +0000
> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> wrote:
> 
> > Hi Alex,
> >
> > > -----Original Message-----
> > > From: Shameerali Kolothum Thodi
> > > Sent: 03 March 2022 23:02
> > > To: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > > linux-crypto@vger.kernel.org
> > > Cc: linux-pci@vger.kernel.org; alex.williamson@redhat.com;
> jgg@nvidia.com;
> > > cohuck@redhat.com; mgurtovoy@nvidia.com; yishaih@nvidia.com;
> Linuxarm
> > > <linuxarm@huawei.com>; liulongfang <liulongfang@huawei.com>;
> Zengtao (B)
> > > <prime.zeng@hisilicon.com>; Jonathan Cameron
> > > <jonathan.cameron@huawei.com>; Wangzhou (B)
> <wangzhou1@hisilicon.com>
> > > Subject: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live
> migration
> > >
> > > From: Longfang Liu <liulongfang@huawei.com>
> > >
> > > VMs assigned with HiSilicon ACC VF devices can now perform live
> migration if
> > > the VF devices are bind to the hisi_acc_vfio_pci driver.
> > >
> > > Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> > > Signed-off-by: Shameer Kolothum
> <shameerali.kolothum.thodi@huawei.com>
> >
> > [...]
> > > +
> > > +static int vf_qm_check_match(struct hisi_acc_vf_core_device
> *hisi_acc_vdev,
> > > +			     struct hisi_acc_vf_migration_file *migf) {
> > > +	struct acc_vf_data *vf_data = &migf->vf_data;
> > > +	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
> > > +	struct hisi_qm *pf_qm = &hisi_acc_vdev->vf_qm;
> >
> > Oops, the above has to be,
> >   struct hisi_qm *pf_qm = hisi_acc_vdev->pf_qm;
> >
> > This was actually fixed in v6, but now that I rebased mainly to v5, missed it.
> > Please let me know if you want a re-spin with the above fix(in case there are
> no further
> > comments) or this is something you can take care.
> 
> To confirm, you're looking for this change:
> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index aa2e4b6bf598..f2a0c046413f 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -413,7 +413,7 @@ static int vf_qm_check_match(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
>  {
>  	struct acc_vf_data *vf_data = &migf->vf_data;
>  	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
> -	struct hisi_qm *pf_qm = &hisi_acc_vdev->vf_qm;
> +	struct hisi_qm *pf_qm = &hisi_acc_vdev->pf_qm;
>  	struct device *dev = &vf_qm->pdev->dev;
>  	u32 que_iso_state;
>  	int ret;
> 
> Right? 

Not really. pf_qm is a pointer. This is the change,

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 53e4c5cb3a71..54813772a071 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -413,7 +413,7 @@ static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 {
 	struct acc_vf_data *vf_data = &migf->vf_data;
 	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
-	struct hisi_qm *pf_qm = &hisi_acc_vdev->vf_qm;
+	struct hisi_qm *pf_qm = hisi_acc_vdev->pf_qm;
 	struct device *dev = &vf_qm->pdev->dev;
 	u32 que_iso_state;
 	int ret;

 I can roll that in assuming there are no further comments that
> would generate a respin.  Thanks,
> 
Thanks,
Shameer

