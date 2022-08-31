Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C81EA5A803C
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 16:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbiHaObn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 31 Aug 2022 10:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbiHaObk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 10:31:40 -0400
X-Greylist: delayed 954 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 31 Aug 2022 07:31:38 PDT
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2064D481C3
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 07:31:37 -0700 (PDT)
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4MHmNS3DltzxSyB;
        Wed, 31 Aug 2022 22:12:56 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 31 Aug 2022 22:15:40 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2375.024;
 Wed, 31 Aug 2022 15:15:38 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        liulongfang <liulongfang@huawei.com>,
        Linuxarm <linuxarm@huawei.com>
Subject: RE: [PATCH] hisi_acc_vfio_pci: Correct the function prefix for
 hssi_acc_drvdata()
Thread-Topic: [PATCH] hisi_acc_vfio_pci: Correct the function prefix for
 hssi_acc_drvdata()
Thread-Index: AQHYvRgT4cwavauhXEWYYOLJVg/ba63I/GUAgAARBlA=
Date:   Wed, 31 Aug 2022 14:15:38 +0000
Message-ID: <f0eb49b8497940049b3e7aa227dd6c69@huawei.com>
References: <20220831085943.993-1-shameerali.kolothum.thodi@huawei.com>
 <20220831081216.0f8df490.alex.williamson@redhat.com>
In-Reply-To: <20220831081216.0f8df490.alex.williamson@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.195.245.177]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: 31 August 2022 15:12
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvm@vger.kernel.org; jgg@nvidia.com; kevin.tian@intel.com; liulongfang
> <liulongfang@huawei.com>; Linuxarm <linuxarm@huawei.com>
> Subject: Re: [PATCH] hisi_acc_vfio_pci: Correct the function prefix for
> hssi_acc_drvdata()
> 
> On Wed, 31 Aug 2022 09:59:43 +0100
> Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:
> 
> > Commit 91be0bd6c6cf("vfio/pci: Have all VFIO PCI drivers store the
> > vfio_pci_core_device in drvdata") introduced a helper function to
> > retrieve the drvdata but used "hssi" instead of "hisi" for the
> > function prefix. Correct that and also while at it, moved the
> > function a bit down so that it's close to other hisi_ prefixed
> > functions.
> >
> > No functional changes.
> >
> > Fixes: 91be0bd6c6cf("vfio/pci: Have all VFIO PCI drivers store the
> vfio_pci_core_device in drvdata")
> 
> The above two lines are usually mutually exclusive, the latter will
> cause this change to be backported to all releases including that
> commit.  As a largely aesthetic change, is that what you're looking
> for?  Thanks,

Nope. I don't think we need to backport this. Hope you can remove
the "Fixes" tag while applying the patch.

Thanks,
Shameer

> Alex
> 
> > Signed-off-by: Shameer Kolothum
> <shameerali.kolothum.thodi@huawei.com>
> > ---
> >  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 20 +++++++++----------
> >  1 file changed, 10 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> > index ea762e28c1cc..258cae0863ea 100644
> > --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> > +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> > @@ -337,14 +337,6 @@ static int vf_qm_cache_wb(struct hisi_qm *qm)
> >  	return 0;
> >  }
> >
> > -static struct hisi_acc_vf_core_device *hssi_acc_drvdata(struct pci_dev
> *pdev)
> > -{
> > -	struct vfio_pci_core_device *core_device =
> dev_get_drvdata(&pdev->dev);
> > -
> > -	return container_of(core_device, struct hisi_acc_vf_core_device,
> > -			    core_device);
> > -}
> > -
> >  static void vf_qm_fun_reset(struct hisi_acc_vf_core_device
> *hisi_acc_vdev,
> >  			    struct hisi_qm *qm)
> >  {
> > @@ -552,6 +544,14 @@ static int vf_qm_state_save(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
> >  	return 0;
> >  }
> >
> > +static struct hisi_acc_vf_core_device *hisi_acc_drvdata(struct pci_dev
> *pdev)
> > +{
> > +	struct vfio_pci_core_device *core_device =
> dev_get_drvdata(&pdev->dev);
> > +
> > +	return container_of(core_device, struct hisi_acc_vf_core_device,
> > +			    core_device);
> > +}
> > +
> >  /* Check the PF's RAS state and Function INT state */
> >  static int
> >  hisi_acc_check_int_state(struct hisi_acc_vf_core_device *hisi_acc_vdev)
> > @@ -970,7 +970,7 @@ hisi_acc_vfio_pci_get_device_state(struct
> vfio_device *vdev,
> >
> >  static void hisi_acc_vf_pci_aer_reset_done(struct pci_dev *pdev)
> >  {
> > -	struct hisi_acc_vf_core_device *hisi_acc_vdev =
> hssi_acc_drvdata(pdev);
> > +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
> >
> >  	if (hisi_acc_vdev->core_device.vdev.migration_flags !=
> >  				VFIO_MIGRATION_STOP_COPY)
> > @@ -1301,7 +1301,7 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev
> *pdev, const struct pci_device
> >
> >  static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
> >  {
> > -	struct hisi_acc_vf_core_device *hisi_acc_vdev =
> hssi_acc_drvdata(pdev);
> > +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
> >
> >  	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
> >  	vfio_pci_core_uninit_device(&hisi_acc_vdev->core_device);
> 

