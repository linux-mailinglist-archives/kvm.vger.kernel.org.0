Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDBB3464B1
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 17:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbhCWQPd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 12:15:33 -0400
Received: from mail-bn7nam10on2089.outbound.protection.outlook.com ([40.107.92.89]:23521
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233127AbhCWQPO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 12:15:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OHQhHSF/0EgU/CDVrT4XUErMPHtuisKJa4m4tIMWVMzfpbzLJ0a8Zx1qg+GX0ezk+Xz/vuqq6mY8p2s2rQ/kikYJPbcixhiKXuRFvHAGCdZvV8U2k9GlWdlb9v/Lz8SbNL5FhVgZmHJ9+J7amS7bVjOMvQCfZMCdA9+oBQ4K4CjGWNcfjZtB2E6DUQ3HXNLfsdD62CX/yAvHDOaiSSDd4rKx21oueWYfLWk4UdrcONRWMk2iWMeB8nnx2v+KNmFWat+qi55Wa9eSRhKC5c1r7K0+IKGjVp1a11Yim5FqKQqjD09wUNgc9XYNGwBMx6vyE0ud5XouatYa07oxorVjkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k3Qoue6mKiKM6pBM0skuOa/a/7zY0XMpX4DKf8IH8aY=;
 b=E4uqviuD9CGlnblPQ8OldZ630ysEBCj/f83W+anojmq3zRd6l9x2S2t7QLnK+1S8DuIEZJh1xRwK1z1Xr77E67Azh8qidekUFwHSCz+LuPM7a9pdFey1bWYTeONdy+prF6HRyBrG6XTk9HDLsK0/5rAT/LwV750Djj+EKZdy5FoL7dJTw49IAqBoBhon2ZOMwTbwHEsM5u8eNhNSKx/35jUKYY5k3VExPfS09MozlQRnlz4n6Z/CinuoZ10h/J1dhsjf3idaL6QUnCAtCsHDug//DunvgQDq62ZPDtMW/pWnU1NDwq+e0U15jNxqOm37e4orXWJscB1UsTLltc/FNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k3Qoue6mKiKM6pBM0skuOa/a/7zY0XMpX4DKf8IH8aY=;
 b=UVq9QEf9b+E4+l7wwRWm7WVoOax0/fKWcKzegoR1zOTK2p7D6jOJxfVXLTx5ToUAZPjJOHKxK9E9ZP2XAw9RQ7ZCSRLivTyvF8dDXWAfz7WS8Nvx538oi9xxNR/oUpSVDYCIB1sF0P4q17MlDPnbL9KjlIcspqGod14EZ+tHqrl+xbc5gPPkrQC33cT4LfBVkwZCr/BMZ0gBApu8LckMb6JfAmFzv/esw1ZQHvvejDnwP4Ke0GTZDJHMCGzKOa1spI/apYmgcJ7kZeL4rs/ETs+AG/s+JYOrATOzUyOAOWLtSH9L5F58XMjIN06qf7J8za61xB0sExH3v0coDF+/4g==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4267.namprd12.prod.outlook.com (2603:10b6:5:21e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Tue, 23 Mar
 2021 16:15:12 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 16:15:10 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v3 05/14] vfio/fsl-mc: Re-order vfio_fsl_mc_probe()
Date:   Tue, 23 Mar 2021 13:14:57 -0300
Message-Id: <5-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: BL1PR13CA0173.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::28) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by BL1PR13CA0173.namprd13.prod.outlook.com (2603:10b6:208:2bd::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.9 via Frontend Transport; Tue, 23 Mar 2021 16:15:08 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOjgQ-001aCg-Ho; Tue, 23 Mar 2021 13:15:06 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71b7bca2-b3cc-4ce4-556d-08d8ee16d3e7
X-MS-TrafficTypeDiagnostic: DM6PR12MB4267:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB426743914BD76502D32E3154C2649@DM6PR12MB4267.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IIvCQGLRA+mDSWFJ3Cqna2o5sS10M/3LvnmpdsDVRtaFnxK+nqBAIhuC3M4anbkmkdQ1wQrZk0T5A1pbFEFRwfGnVH1G3PXnCZSX2gUMosf3wNO/WWzmMEV+Pz+Y5zsNE7mGzYuJi7oAzn7E5L9LZWw4Vy627XbCU4ExsmMzaT8Ocpkk0XwZWtUEVXMZMUoekXyFm+dQEwRtu+tSu47MHafgy1/mXzR1Np2LFR9kSOzKe3+cXfvxWbLqg8G2jXC9NmxcsdBjnOE2D/wRDxtyQloufGmlCEIZsyu8fqlYbQBF4CJZQ2L/QU3tYQBkULmfR/3rqo64omE8emimxoP9lqFrGQIOH2769T7qacnD9itX2dsC3I+Zrb7sLVl9yX/VwLiW+uzTwxDxZ8OugLtybmq2pndzO9USJDHBKBa/OBIVJrd/xTnxNedDwsBrCRL4oZk9xUzZyCI6T7lC4LZooMmXtVnhzsAEXkSohfrcYU6KtfRPt3VN/fMIUgtN2XHfxWNGlPdyFgmMoL3Nb8DFXoDSA74tu7Tc2OENWnLzXeWrVkJayuacEMPnFWZiHgCjoM4k6VTJ8TmoTaMqULv+mlPXawZFcF3gnrFE93UePZYg0bzb+xFv0AUaN2oVfsGTLRWJwo/tY5rJjTH+ZAIynTTbxDcQkv+oiQNHXzFOUl8JR31clktRTrMTaSFF3VIG/5iB6MSeC3Tu0z3fdKyHyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(5660300002)(66476007)(2616005)(66946007)(66556008)(2906002)(186003)(7416002)(6666004)(83380400001)(426003)(54906003)(316002)(8936002)(478600001)(8676002)(107886003)(4326008)(26005)(9746002)(9786002)(86362001)(36756003)(38100700001)(4216001)(169823001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?hfQl7jJEgW30aqAVR5IZCl4HvhMavvGLJTDZYjvcXKu5WgXQFcwwcZ2IuCX/?=
 =?us-ascii?Q?X/Xnye+xPJMGxOU4dePmdll3bTFRiaJTBGKtQCB7tjgBjBdQYScBdHkW3uuY?=
 =?us-ascii?Q?fzv0i6u88NxpMlHSwYeH07s6rajRLuPE1feK8OU5wijT3FJ31Gh9bcyMi7A+?=
 =?us-ascii?Q?MXy98KaPWbabUxQV+vAZ1FxzQ7MzozdFYFmlsynDKIVCkpk72kjYES8OBYzP?=
 =?us-ascii?Q?emHbFcJt6EeslD/UAY2fy52zBKSwFOGzGc3FFivCSNaxEKCloTAKdvtkn1tu?=
 =?us-ascii?Q?1gw1mvVLsddOejxeBNwgHhhS+7XCSxecWeco9UeuGMCWq180wChySOsYa58P?=
 =?us-ascii?Q?CnpSeavC7CT7TZiK5cSXj6lYLTfVEqBoENxY3cBWMqcDbEReIdbUoX/A+aRM?=
 =?us-ascii?Q?NPdG4M82aX8Ck9UdlfSwfs6KCvZmZrVY9MkAmulkYGua38nw7sGul/Y8RrWW?=
 =?us-ascii?Q?X+yRQ2A98h8C+igCOQ6xpy4Lsa/quoHStTlPte9qurnDDygpeS5I6kmCP1WU?=
 =?us-ascii?Q?K8DvQdesCwbQIEbVtToN/APFxb3WE+KHF9jwvyidXnPltR8EkU1o49NKydQo?=
 =?us-ascii?Q?0t6goINJwTRRYfy+7syNCSBLG0Ct+8GwTek4AoPSEl0s6jnVn3KtVrUjikY8?=
 =?us-ascii?Q?7Vq1W3hQgOXcEAM0WkZQLJiO3EpAVcVchu0zUUO5hsifhd0WG8oBfI/3grxr?=
 =?us-ascii?Q?dGsHdlqzem0/sXN1vaqwXHVttYilJ3BKhUD1sJMD5sThBSkJFk8Ymt6JrrpR?=
 =?us-ascii?Q?K9EOhCtuF37oQQtNI1KMszSMzGkAbwPoVMCFnS4tApaLoA0DjUxZp0tNL1gt?=
 =?us-ascii?Q?XuYCfGIExGNkictc2HHhlaRoeYzuyx1z0Q1Ou+EhfGlkYBpQZWYcaZoPRdb+?=
 =?us-ascii?Q?SouLlvfofiU+TLPJ6wObc+8aGeChKfdIlUpx0nW6uRIVqMNGQWB27YOOLPmk?=
 =?us-ascii?Q?SOaebMKrfoueJBgmArg5djXeCCsU8C1QbdL5WZai+VPBtRFkNhtZv182JQ8R?=
 =?us-ascii?Q?w7MUcv6ZE0WqDKfieGMC87WPRRJOd+GZ73aCQSMgi2Az1JQ0znld/O7lw64e?=
 =?us-ascii?Q?3Bc/3FCSooAq4vCMNAL+8RZYmbCjL58RW1ISB67Cm3RdOeKQ7hTWqDbMgOwt?=
 =?us-ascii?Q?DwNdfRQiZJ6ki/MxcNPApl4Wj/auZhdnC06LXo42xGlI+TbFiEaslErpKxIJ?=
 =?us-ascii?Q?VcitB7zOO8fvh2rxFMzit400NyvqW6pbuMBhQsdNFjbCxHHrViCdlECEIJzB?=
 =?us-ascii?Q?7MzmM4Svb+nRilaEYcGTJJ072aK7zZF9OkhqID1uNdcm0iPRcKkNtvECXeHZ?=
 =?us-ascii?Q?YGXQRj1rV1ZNubaHJGKd4xO/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71b7bca2-b3cc-4ce4-556d-08d8ee16d3e7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 16:15:08.7508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tMBUpRVrW5neZmA+U1TbLGmcWNJaRw68zKguOrYXLWxRIfHrHy0/EgLyE14bWsm9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4267
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio_add_group_dev() must be called only after all of the private data in
vdev is fully setup and ready, otherwise there could be races with user
space instantiating a device file descriptor and starting to call ops.

For instance vfio_fsl_mc_reflck_attach() sets vdev->reflck and
vfio_fsl_mc_open(), called by fops open, unconditionally derefs it, which
will crash if things get out of order.

This driver started life with the right sequence, but two commits added
stuff after vfio_add_group_dev().

Fixes: 2e0d29561f59 ("vfio/fsl-mc: Add irq infrastructure for fsl-mc devices")
Fixes: f2ba7e8c947b ("vfio/fsl-mc: Added lock support in preparation for interrupt handling")
Co-developed-by: Diana Craciun OSS <diana.craciun@oss.nxp.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c | 74 ++++++++++++++++++++-----------
 1 file changed, 47 insertions(+), 27 deletions(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index f27e25112c4037..8722f5effacd44 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -568,23 +568,39 @@ static int vfio_fsl_mc_init_device(struct vfio_fsl_mc_device *vdev)
 		dev_err(&mc_dev->dev, "VFIO_FSL_MC: Failed to setup DPRC (%d)\n", ret);
 		goto out_nc_unreg;
 	}
+	return 0;
+
+out_nc_unreg:
+	bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
+	return ret;
+}
 
+static int vfio_fsl_mc_scan_container(struct fsl_mc_device *mc_dev)
+{
+	int ret;
+
+	/* non dprc devices do not scan for other devices */
+	if (!is_fsl_mc_bus_dprc(mc_dev))
+		return 0;
 	ret = dprc_scan_container(mc_dev, false);
 	if (ret) {
-		dev_err(&mc_dev->dev, "VFIO_FSL_MC: Container scanning failed (%d)\n", ret);
-		goto out_dprc_cleanup;
+		dev_err(&mc_dev->dev,
+			"VFIO_FSL_MC: Container scanning failed (%d)\n", ret);
+		dprc_remove_devices(mc_dev, NULL, 0);
+		return ret;
 	}
-
 	return 0;
+}
+
+static void vfio_fsl_uninit_device(struct vfio_fsl_mc_device *vdev)
+{
+	struct fsl_mc_device *mc_dev = vdev->mc_dev;
+
+	if (!is_fsl_mc_bus_dprc(mc_dev))
+		return;
 
-out_dprc_cleanup:
-	dprc_remove_devices(mc_dev, NULL, 0);
 	dprc_cleanup(mc_dev);
-out_nc_unreg:
 	bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
-	vdev->nb.notifier_call = NULL;
-
-	return ret;
 }
 
 static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
@@ -607,29 +623,39 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
 	}
 
 	vdev->mc_dev = mc_dev;
-
-	ret = vfio_add_group_dev(dev, &vfio_fsl_mc_ops, vdev);
-	if (ret) {
-		dev_err(dev, "VFIO_FSL_MC: Failed to add to vfio group\n");
-		goto out_group_put;
-	}
+	mutex_init(&vdev->igate);
 
 	ret = vfio_fsl_mc_reflck_attach(vdev);
 	if (ret)
-		goto out_group_dev;
+		goto out_group_put;
 
 	ret = vfio_fsl_mc_init_device(vdev);
 	if (ret)
 		goto out_reflck;
 
-	mutex_init(&vdev->igate);
+	ret = vfio_add_group_dev(dev, &vfio_fsl_mc_ops, vdev);
+	if (ret) {
+		dev_err(dev, "VFIO_FSL_MC: Failed to add to vfio group\n");
+		goto out_device;
+	}
 
+	/*
+	 * This triggers recursion into vfio_fsl_mc_probe() on another device
+	 * and the vfio_fsl_mc_reflck_attach() must succeed, which relies on the
+	 * vfio_add_group_dev() above. It has no impact on this vdev, so it is
+	 * safe to be after the vfio device is made live.
+	 */
+	ret = vfio_fsl_mc_scan_container(mc_dev);
+	if (ret)
+		goto out_group_dev;
 	return 0;
 
-out_reflck:
-	vfio_fsl_mc_reflck_put(vdev->reflck);
 out_group_dev:
 	vfio_del_group_dev(dev);
+out_device:
+	vfio_fsl_uninit_device(vdev);
+out_reflck:
+	vfio_fsl_mc_reflck_put(vdev->reflck);
 out_group_put:
 	vfio_iommu_group_put(group, dev);
 	return ret;
@@ -646,16 +672,10 @@ static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
 
 	mutex_destroy(&vdev->igate);
 
+	dprc_remove_devices(mc_dev, NULL, 0);
+	vfio_fsl_uninit_device(vdev);
 	vfio_fsl_mc_reflck_put(vdev->reflck);
 
-	if (is_fsl_mc_bus_dprc(mc_dev)) {
-		dprc_remove_devices(mc_dev, NULL, 0);
-		dprc_cleanup(mc_dev);
-	}
-
-	if (vdev->nb.notifier_call)
-		bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
-
 	vfio_iommu_group_put(mc_dev->dev.iommu_group, dev);
 
 	return 0;
-- 
2.31.0

