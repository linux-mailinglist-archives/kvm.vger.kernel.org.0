Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0AD53174AC
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 00:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234022AbhBJXr3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 18:47:29 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:8619 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbhBJXr1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 18:47:27 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602470660001>; Wed, 10 Feb 2021 15:46:46 -0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 23:46:45 +0000
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 23:46:43 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 10 Feb 2021 23:46:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P16YXOm7pRPkhJYZgziw8l5isp0zyfliZOwZ0AJJERRF0mJHzXSw7gguKtdNmAAIbcqKRwIs1v5oB4Jep+s/WzpPGPWvu5/LXfpeS22W98z4MAhQjRY9IayyJk0WHh7CO82cPFcPTCwdgxQF5Nc2iHT0xLx8pHFtZkoG3+lumZQ7/C4IGx+Ri09N7nn4zEEcs7rmLlauHNRGToMlnP0T+vECcZD/ARStz9TgTucEkIdPAoCLWsYMGMKEtxdX4d7eV5mgvYfMoWfLtyylESbolCltcryT1YoP18rNg2rSKlabEjpsWvTlExX2aV2IzG6bjz2ZlK1V0B5cIlut6e2HGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TYzgz2EPPt+1Sp2WSxI20EaufzxLlSqAypZsTggrFcA=;
 b=JbSoF07xekIY5aA8idoR5qeo/BFAPTxzsZricUjj/v2o9GB9ZZd0VwXp3ddp9n4Bm1x3M9gcfiyjFbFCmAXK3XzRzymlPJevT6xbRVQBvDGJhOCcnl9tsubqnKp0a7NDBUp1oDxC+HxsvOfnv1Yzzb1xnL8q7Y27wX4ZlClOVY3Tszvs+yei2uFUCmHJGkj/GBl7AXBjtqYQq0ciyi0DwMIo/ibmC9XqR5+RbWF5NZdVibm47zXYkNPPMQymZaq5Dr9GFutYPORoYmxgXFAQHu1g+ACziUE1F1ixRj7VxiMKDF0vbw1+WmdPP0QbMvmhW+MLX/IQkKGGiFOtjOq1cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1756.namprd12.prod.outlook.com (2603:10b6:3:108::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.27; Wed, 10 Feb
 2021 23:46:41 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3846.027; Wed, 10 Feb 2021
 23:46:41 +0000
Date:   Wed, 10 Feb 2021 19:46:39 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dave Jiang <dave.jiang@intel.com>
CC:     <alex.williamson@redhat.com>, <kwankhede@nvidia.com>,
        <tglx@linutronix.de>, <vkoul@kernel.org>, <megha.dey@intel.com>,
        <jacob.jun.pan@intel.com>, <ashok.raj@intel.com>,
        <yi.l.liu@intel.com>, <baolu.lu@intel.com>, <kevin.tian@intel.com>,
        <sanjay.k.kumar@intel.com>, <tony.luck@intel.com>,
        <dan.j.williams@intel.com>, <eric.auger@redhat.com>,
        <parav@mellanox.com>, <netanelg@mellanox.com>,
        <shahafs@mellanox.com>, <pbonzini@redhat.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 04/14] vfio/mdev: idxd: Add auxialary device plumbing
 for idxd mdev support
Message-ID: <20210210234639.GI4247@nvidia.com>
References: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
 <161255839829.339900.16438737078488315104.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <161255839829.339900.16438737078488315104.stgit@djiang5-desk3.ch.intel.com>
X-ClientProxiedBy: MN2PR19CA0032.namprd19.prod.outlook.com
 (2603:10b6:208:178::45) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR19CA0032.namprd19.prod.outlook.com (2603:10b6:208:178::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Wed, 10 Feb 2021 23:46:40 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l9zBv-006HwC-Bs; Wed, 10 Feb 2021 19:46:39 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613000806; bh=TYzgz2EPPt+1Sp2WSxI20EaufzxLlSqAypZsTggrFcA=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=rVGvDrFLVTyOmoySC2Dv8k6ZW3a14uKQ6wEiNDPDzmzj85JB+Klx0BA7tKeDw54Cu
         1kq8kmU88lmLn73eQA1M5kqihAaQPwTiS0ycOpqHUzAWSemgByS20wxa8yJZUtpdGj
         cvNXYO8tRRM4TeeB/FOkdwPKi0mgvrmjvvyyw7RrsA0LUsBgkxFzRh0tjMPTFmYgBY
         4f0P4hCU/5t/adJy2JR2PPA0BBBXIHKHZKmJ145s85Hxh3GptMQoRv2kDok+MofuSM
         RxSjfHTIcsqIAWotsP9UphdBetJVsagh/SZBoZfoyzCbKbB8zMCkGWkyjERx46Lm+O
         lAXrtSjolFIWQ==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 05, 2021 at 01:53:18PM -0700, Dave Jiang wrote:
> diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
> index a2438b3166db..f02c96164515 100644
> +++ b/drivers/dma/idxd/idxd.h
> @@ -8,6 +8,7 @@
>  #include <linux/percpu-rwsem.h>
>  #include <linux/wait.h>
>  #include <linux/cdev.h>
> +#include <linux/auxiliary_bus.h>
>  #include "registers.h"
>  
>  #define IDXD_DRIVER_VERSION	"1.00"
> @@ -221,6 +222,8 @@ struct idxd_device {
>  	struct work_struct work;
>  
>  	int *int_handles;
> +
> +	struct auxiliary_device *mdev_auxdev;
>  };

If there is only one aux device there not much reason to make it a
dedicated allocation.

>  /* IDXD software descriptor */
> @@ -282,6 +285,10 @@ enum idxd_interrupt_type {
>  	IDXD_IRQ_IMS,
>  };
>  
> +struct idxd_mdev_aux_drv {
> +	        struct auxiliary_driver auxiliary_drv;
> +};

Wrong indent. What is this even for?

> +
>  static inline int idxd_get_wq_portal_offset(enum idxd_portal_prot prot,
>  					    enum idxd_interrupt_type irq_type)
>  {
> diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
> index ee56b92108d8..fd57f39e4b7d 100644
> +++ b/drivers/dma/idxd/init.c
> @@ -382,6 +382,74 @@ static void idxd_disable_system_pasid(struct idxd_device *idxd)
>  	idxd->sva = NULL;
>  }
>  
> +static void idxd_remove_mdev_auxdev(struct idxd_device *idxd)
> +{
> +	if (!IS_ENABLED(CONFIG_VFIO_MDEV_IDXD))
> +		return;
> +
> +	auxiliary_device_delete(idxd->mdev_auxdev);
> +	auxiliary_device_uninit(idxd->mdev_auxdev);
> +}
> +
> +static void idxd_auxdev_release(struct device *dev)
> +{
> +	struct auxiliary_device *auxdev = to_auxiliary_dev(dev);
> +	struct idxd_device *idxd = dev_get_drvdata(dev);

Nope, where did you see drvdata being used like this? You need to use
container_of.

If put the mdev_auxdev as a non pointer member then this is just:

     struct idxd_device *idxd = container_of(dev, struct idxd_device, mdev_auxdev)
     
     put_device(&idxd->conf_dev);

And fix the 'setup' to match this design

> +	kfree(auxdev->name);

This is weird, the name shouldn't be allocated, it is supposed to be a
fixed string to make it easy to find the driver name in the code base.

> +static int idxd_setup_mdev_auxdev(struct idxd_device *idxd)
> +{
> +	struct auxiliary_device *auxdev;
> +	struct device *dev = &idxd->pdev->dev;
> +	int rc;
> +
> +	if (!IS_ENABLED(CONFIG_VFIO_MDEV_IDXD))
> +		return 0;
> +
> +	auxdev = kzalloc(sizeof(*auxdev), GFP_KERNEL);
> +	if (!auxdev)
> +		return -ENOMEM;
> +
> +	auxdev->name = kasprintf(GFP_KERNEL, "mdev-%s", idxd_name[idxd->type]);
> +	if (!auxdev->name) {
> +		rc = -ENOMEM;
> +		goto err_name;
> +	}
> +
> +	dev_dbg(&idxd->pdev->dev, "aux dev mdev: %s\n", auxdev->name);
> +
> +	auxdev->dev.parent = dev;
> +	auxdev->dev.release = idxd_auxdev_release;
> +	auxdev->id = idxd->id;
> +
> +	rc = auxiliary_device_init(auxdev);
> +	if (rc < 0) {
> +		dev_err(dev, "Failed to init aux dev: %d\n", rc);
> +		goto err_auxdev;
> +	}

Put the init earlier so it can handle the error unwinds

> +	rc = auxiliary_device_add(auxdev);
> +	if (rc < 0) {
> +		dev_err(dev, "Failed to add aux dev: %d\n", rc);
> +		goto err_auxdev;
> +	}
> +
> +	idxd->mdev_auxdev = auxdev;
> +	dev_set_drvdata(&auxdev->dev, idxd);

No to using drvdata, and this is in the wrong order anyhow.

> +	return 0;
> +
> + err_auxdev:
> +	kfree(auxdev->name);
> + err_name:
> +	kfree(auxdev);
> +	return rc;
> +}
> +
>  static int idxd_probe(struct idxd_device *idxd)
>  {
>  	struct pci_dev *pdev = idxd->pdev;
> @@ -434,11 +502,19 @@ static int idxd_probe(struct idxd_device *idxd)
>  		goto err_idr_fail;
>  	}
>  
> +	rc = idxd_setup_mdev_auxdev(idxd);
> +	if (rc < 0)
> +		goto err_auxdev_fail;
> +
>  	idxd->major = idxd_cdev_get_major(idxd);
>  
>  	dev_dbg(dev, "IDXD device %d probed successfully\n", idxd->id);
>  	return 0;
>  
> + err_auxdev_fail:
> +	mutex_lock(&idxd_idr_lock);
> +	idr_remove(&idxd_idrs[idxd->type], idxd->id);
> +	mutex_unlock(&idxd_idr_lock);

Probably wrong to order things like this..

Also somehow this has a 

	idxd = devm_kzalloc(dev, sizeof(struct idxd_device), GFP_KERNEL);

but the idxd has a kref'd struct device in it:

struct idxd_device {
	enum idxd_type type;
	struct device conf_dev;

So that's not right either

You'll need to fix the lifetime model for idxd_device before you get
to adding auxdevices

> +static int idxd_mdev_host_init(struct idxd_device *idxd)
> +{
> +	/* FIXME: Fill in later */
> +	return 0;
> +}
> +
> +static int idxd_mdev_host_release(struct idxd_device *idxd)
> +{
> +	/* FIXME: Fill in later */
> +	return 0;
> +}

Don't leave empty stubs like this, just provide the whole driver in
the next patch

> +static int idxd_mdev_aux_probe(struct auxiliary_device *auxdev,
> +			       const struct auxiliary_device_id *id)
> +{
> +	struct idxd_device *idxd = dev_get_drvdata(&auxdev->dev);

Continuing no to using drvdata, must use container_of

> +	int rc;
> +
> +	rc = idxd_mdev_host_init(idxd);

And why add this indirection? Just write what it here

> +static struct idxd_mdev_aux_drv idxd_mdev_aux_drv = {
> +	.auxiliary_drv = {
> +		.id_table = idxd_mdev_auxbus_id_table,
> +		.probe = idxd_mdev_aux_probe,
> +		.remove = idxd_mdev_aux_remove,
> +	},
> +};

Why idxd_mdev_aux_drv ? Does a later patch add something here?

> +static int idxd_mdev_auxdev_drv_register(struct idxd_mdev_aux_drv *drv)
> +{
> +	return auxiliary_driver_register(&drv->auxiliary_drv);
> +}
> +
> +static void idxd_mdev_auxdev_drv_unregister(struct idxd_mdev_aux_drv *drv)
> +{
> +	auxiliary_driver_unregister(&drv->auxiliary_drv);
> +}
> +
> +module_driver(idxd_mdev_aux_drv, idxd_mdev_auxdev_drv_register, idxd_mdev_auxdev_drv_unregister);

There is some auxillary driver macro that does this boilerplate

Jason
