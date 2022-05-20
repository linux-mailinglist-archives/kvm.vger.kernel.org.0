Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF1652E9CA
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 12:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348106AbiETKUs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 20 May 2022 06:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348105AbiETKUq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 06:20:46 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061B514CA11
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 03:20:42 -0700 (PDT)
Received: from kwepemi100009.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4L4N4N5cDmzfYkT;
        Fri, 20 May 2022 18:19:16 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (7.193.23.191) by
 kwepemi100009.china.huawei.com (7.221.188.242) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 20 May 2022 18:20:40 +0800
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 20 May 2022 18:20:39 +0800
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2375.024; Fri, 20 May 2022 11:20:38 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        liulongfang <liulongfang@huawei.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: RE: [PATCH] vfio/pci: Add driver_managed_dma to the new vfio_pci
 drivers
Thread-Topic: [PATCH] vfio/pci: Add driver_managed_dma to the new vfio_pci
 drivers
Thread-Index: AQHYa9Yld8RZ9zh0ek+K+czmOFXOEq0njUfw
Date:   Fri, 20 May 2022 10:20:37 +0000
Message-ID: <681b5ba288a24a0f9296f56ddbdf985a@huawei.com>
References: <0-v1-f9dfa642fab0+2b3-vfio_managed_dma_jgg@nvidia.com>
In-Reply-To: <0-v1-f9dfa642fab0+2b3-vfio_managed_dma_jgg@nvidia.com>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgg@nvidia.com]
> Sent: 20 May 2022 00:14
> To: Cornelia Huck <cohuck@redhat.com>; Kevin Tian <kevin.tian@intel.com>;
> kvm@vger.kernel.org; liulongfang <liulongfang@huawei.com>; Shameerali
> Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>; Lu Baolu
> <baolu.lu@linux.intel.com>; Joerg Roedel <jroedel@suse.de>; Yishai Hadas
> <yishaih@nvidia.com>
> Subject: [PATCH] vfio/pci: Add driver_managed_dma to the new vfio_pci
> drivers
> 
> When the iommu series adding driver_managed_dma was rebased it missed
> that
> new VFIO drivers were added and did not update them too.
> 
> Without this vfio will claim the groups are not viable.
> 
> Add driver_managed_dma to mlx5 and hisi.
> 
> Fixes: 70693f470848 ("vfio: Set DMA ownership for VFIO devices")
> Reported-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Thanks for this. Verified on HiSilicon platform.

FWIW:

Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Shameer


> ---
>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 1 +
>  drivers/vfio/pci/mlx5/main.c                   | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index e92376837b29e6..4def43f5f7b619 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -1323,6 +1323,7 @@ static struct pci_driver hisi_acc_vfio_pci_driver = {
>  	.probe = hisi_acc_vfio_pci_probe,
>  	.remove = hisi_acc_vfio_pci_remove,
>  	.err_handler = &hisi_acc_vf_err_handlers,
> +	.driver_managed_dma = true,
>  };
> 
>  module_pci_driver(hisi_acc_vfio_pci_driver);
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index dd1009b5ff9c82..0558d0649ddb8c 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -641,6 +641,7 @@ static struct pci_driver mlx5vf_pci_driver = {
>  	.probe = mlx5vf_pci_probe,
>  	.remove = mlx5vf_pci_remove,
>  	.err_handler = &mlx5vf_err_handlers,
> +	.driver_managed_dma = true,
>  };
> 
>  static void __exit mlx5vf_pci_cleanup(void)
> 
> base-commit: 9cfc47edbcd46edc6fb65ba00e7f12bacb1aab9c
> --
> 2.36.0

