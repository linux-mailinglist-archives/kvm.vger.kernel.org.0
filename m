Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3398F5E6BA9
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 21:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbiIVTUy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 15:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbiIVTUj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 15:20:39 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2066.outbound.protection.outlook.com [40.107.212.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E761CD1FE
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 12:20:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n2deX1IZ0FZOmHQ1OGg2KzSuDxcBKiYEWufKX1sj57fJwMoLGC/qHHCr7vPGUqjJR6tka3eX7a/drA4v1V0J1pJHAsQSJgOkFJht+qGypp6wlX/xBuEBi0xkpBcgWqWcwWDqsh59NulUe7g8TLPu2/emLXCGNlMoowtiClPIgO12i8fgDWi5YQZs6KuNB80upjHHGcf3dUFbhU0y/VAJEvuoPBM/r4ZgQl+SS57oFRey3cxKmLF/o0ZKySWu0GzAYCBTBTeIbFqEXUNkhUzMDyG6pbPVMghN22/0JadNavLDsjSWJ58UyScrpo4jSi8Qj+G2sIT1VxAafDIJNq00MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7YgPaEw1RQkDjJKpd1Z2F9M+vqkkHz2ybjNGQGWzWso=;
 b=Y24Cf30k5/0lv4Qs6O9kKMk+1BY8p+6jAqpn9Tj6m6g3PnpSLu+3HnWL+FuZyfM8KivA6f7YeBITRFqsXfsoQWdBIzMbeeCjUjMOTntct5hbslusXWbfP8RdEdlWCmtBfQPi/AFtYrLN85pHD7ubc00itEeTb7usvIOcbZwb4fipfLGrh+lMzY7skK1MuLyXqe55akh4gXq1uv8hNdDDdWXuLVVREGI35rDrvb1emxxT73uaSumrLkUrkYDLYICSVsXTivcvFqHk/aJ8WcpET9AU8DKlX0Bn9c9lPqM0Zb5txOK+xIacNXAVSEMcX+dYB55zQMhrF/oI9AU0PEcjGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7YgPaEw1RQkDjJKpd1Z2F9M+vqkkHz2ybjNGQGWzWso=;
 b=LCpKKGM2VKPVgItVmZ4k2ql7D72RW+hwiwZR6tKXi6HdShYbtcbnCbnW6TGxHqxHoD+v7Z3n0cwgFSWeJLdtDQVhixKmIRcKf89+5oFHAWGjOPgXPImtdYM8KL/BurEsV0nHL98Ddzk3GlkpYP/c+PEZDtp26OwC3aK6xroZZ/IIJNMTIpk+hvUwRMbhZQJG/9KF2g2vX9JRb/gBHpUvgYrLqby83ldlJ5xsSyni8C+So9Q1yzcdntyd46GgSfBJuf0l+ORNkXLAh62lJAt5SooQZ1sBhRzstYP8azWmj6FO5W7wyuoQfuNArHCUaUbc16QSg/wVh8zjLrC6iW6ozA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SJ0PR12MB5486.namprd12.prod.outlook.com (2603:10b6:a03:3bb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.19; Thu, 22 Sep
 2022 19:20:31 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 19:20:31 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v3 7/8] vfio: Split the register_device ops call into functions
Date:   Thu, 22 Sep 2022 16:20:25 -0300
Message-Id: <7-v3-297af71838d2+b9-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <0-v3-297af71838d2+b9-vfio_container_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0139.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::24) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|SJ0PR12MB5486:EE_
X-MS-Office365-Filtering-Correlation-Id: 391c5982-7463-42e7-6ffe-08da9ccf81a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uPEIAjXitkK68Mk9r3v7n8otPmQU+3bmmk4WXqu/mSYBUY869EHfj9O3cxkdNig72Sws2dVwYIh4qDM7U6fGr5djBdRlteaxaWXc3Rz4hoF6fMcHHyKGb0hLBii23jXGEFf5hqXtullYpEGXf2tatM08Tu6txfkR2WmeuPW3gCnGNV56yBf1lXA8x+4VYbQZW2A5NlQJHnDWpr3pgLLDK+GWFCUqU99yY7B9T7Fcwk+tAZeEHaxJHJaHPiDRamoaU2elBtPTz/6qel6vchb623Hb73ejtipOX7oqWY2NLVB+4A57CwIZHgcXmWN7jQQZBjpbMnHgWtwW86iMtnFrDOLWcRQs+eYquMNwyddAtEcrB45MJkyY/iHRqiXYAzDZ3gEE1jZnXZFoSo923BANeZgYEggO9a+Nd/0nkMp93ehTGSouaZDxhz4tSRJzTRICck4Cuzg4522WjQOF8EWEmCl+Zqk2VTv3Kw+a09rUjwd0gY2efj5LjFaaknqXrRKd5fmZC+YkBEjyahR4NzHxpKHQPOAVMuofc10URH3m+DLmsOpJ55do4923pev0D59q5z0jH+6XYXcxRcLZfepCG9IcmkFa6dlV7vA3iKZAsFQa/Eeu0T1v8PuXswQyDsckCaooKSJyr8dcuMp3Osj5+JLm9Ci9/uAeVJ4qeAHUx6NpAm02Ntpmfib20wy0uLRJrrWSfvtcYLRUAcpYc2/90Yt0fXPyC1ITfvHsfx4ltf87Hq7N8ac0etQeavwJA1xu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(39860400002)(366004)(136003)(451199015)(2616005)(36756003)(83380400001)(41300700001)(6506007)(6666004)(2906002)(8936002)(5660300002)(26005)(38100700002)(6512007)(186003)(316002)(86362001)(110136005)(6486002)(66556008)(478600001)(66476007)(66946007)(4326008)(8676002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4EEOuylU6LaN+klV3tKpy/YxKU9b7CZO3VGHqZ349xrWPEOjNOlDD8tM35HJ?=
 =?us-ascii?Q?yCLnqR+CAOcIMtiKd+uH6YTQLtWoslUTaUebLkwAymib/RUF6myDo3bQP0v9?=
 =?us-ascii?Q?xefou/jiZY/BxNMZlddM672IiSsycDUnNQh0Two83Co+7FQ+G3dluJC3fk+O?=
 =?us-ascii?Q?EL+Ha3WXci7Pc9umTRqsQ5Md21IDf0z/gelFkULYSipj8ZRvtQR2lZ9LXbqJ?=
 =?us-ascii?Q?Q43AltQioEOrAEfYM2dOeS845Tofgas+baf2sd145wqf/VH4PFX3xcS7Ro8v?=
 =?us-ascii?Q?FWf+ZDabbbSUNRJZF1obFcQfubyy9dPrtncwWrGB58Y6oOu8us5hLfZXSPXN?=
 =?us-ascii?Q?nCw5YuYlhwIVgc8BM7JNEfD9iIow45i05KCNnm0UITJINvYx/g8ObrCOr6+5?=
 =?us-ascii?Q?0HZxkLbCfxEzqf8LbChvDgfLvBKzO35vjr4Q6M1s6LT8n40ntC4kseICtwPf?=
 =?us-ascii?Q?XNyqtUQH9p6IFMwlmbYvhyHwN6bIvpZDcObJMU7JnhlmCcdzW2qYs0RAK2uV?=
 =?us-ascii?Q?kyrZwgNrpGHi6xEw57h9n0bHPuGDY/ozEce361a10lBGONjF8RS5c0138pAm?=
 =?us-ascii?Q?B4PCJ0YaFK4I1hYpyGy63jB1L8z7IJKmZv7Jj2IiMQq90Ucn0T0uDLuvtwbS?=
 =?us-ascii?Q?1eQFlJ6F48mraKV/s9amy0DJJtni3ym0Db9XeK2/xVqOKzWdccU5Z2z2uwnk?=
 =?us-ascii?Q?OeKLA4HZjiy+FAyRGFODm7Kfa4+6z4LVM3oJMLqllq4/yd3IB73yWKtE5wGt?=
 =?us-ascii?Q?ChfyKs7w3pnn+EmaZAlQqVvPxWKju7SuYz14RNVOXPsF/DNI1ebr1JhAucet?=
 =?us-ascii?Q?K0A3jIDkuRWQTBLLn7l+unrxYY41/Ovb2c6Jh6K3fFyVuaatdNFPoK+qAuJ8?=
 =?us-ascii?Q?Px4FV4uMOhWHqZsdOhSTBsLzywQ5welKsmgQ+mIyceJw4bQQxY2WQAJwXh0S?=
 =?us-ascii?Q?6s0VDXEHUylxZCUe75BRRMmb1evhxMhLlQfuPcY3byldd8c+IbRWqvk+nvY4?=
 =?us-ascii?Q?7PWWhlT0EiTCAqO2/Xzs2EIs3XmDYMwsjzlDpinM6xDAF+DjArblraqx8Mz5?=
 =?us-ascii?Q?RPkK720KcsTwofcp4PA+tU730UtSY5pL3V93H7VHW0aQe0dMLGB3/zo1+HWf?=
 =?us-ascii?Q?MIb0HWsq454HVRnMhMH9kuGIeYQCwDAMD+ynkmHKkVxrAewzli5RVKBxY445?=
 =?us-ascii?Q?a0Y2NuYsNER/7poY6s3Tqq4AlvH9oxZR2mMhXSfHlRctiI9p1i1EMNsIHqJ/?=
 =?us-ascii?Q?tSrTDCiJQ3TlL60tmyZX2epo4f5437sXVF/0g9Arqb+u+YGttg1+ckokjb8K?=
 =?us-ascii?Q?TC+m+1YoRJ3/X5aYdGHywjU3dHfDAb+FjmXq6iXTOIN4h4QAzkykA8nwduQO?=
 =?us-ascii?Q?h69ICu3rmSUjwjUBjV3kBzUEhQhausqP2/OI+g8CSE4gPyQxsRXeOfP8wfpc?=
 =?us-ascii?Q?uEwliyMwO5AP39zlZxe5gNP7sqCmYLXRVU/l8kcFAIVPJU03u6HpQ5kAYydY?=
 =?us-ascii?Q?i9YtgP6RRiz8KMTWRkXre5fQ0iSwAqlOifHkGod7gkawBERvw64j5PWiGcDS?=
 =?us-ascii?Q?KXjOM3V5HwbGZapEPWO7d60jbp7Y3CDm86/QEgFQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 391c5982-7463-42e7-6ffe-08da9ccf81a7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 19:20:27.4837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pW7I/o6Y/7mBTg2TCAuLvEljJ6BCja2Q9oGqcYqGVYhynR2P18bcakmaz7h7bfEi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5486
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a container item.

A following patch will move the vfio_container functions to their own .c
file.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c | 39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 33e55e40c41698..1ac7160f9329c5 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1226,9 +1226,28 @@ static void vfio_device_unassign_container(struct vfio_device *device)
 	up_write(&device->group->group_rwsem);
 }
 
+static void vfio_device_container_register(struct vfio_device *device)
+{
+	struct vfio_iommu_driver *iommu_driver =
+		device->group->container->iommu_driver;
+
+	if (iommu_driver && iommu_driver->ops->register_device)
+		iommu_driver->ops->register_device(
+			device->group->container->iommu_data, device);
+}
+
+static void vfio_device_container_unregister(struct vfio_device *device)
+{
+	struct vfio_iommu_driver *iommu_driver =
+		device->group->container->iommu_driver;
+
+	if (iommu_driver && iommu_driver->ops->unregister_device)
+		iommu_driver->ops->unregister_device(
+			device->group->container->iommu_data, device);
+}
+
 static struct file *vfio_device_open(struct vfio_device *device)
 {
-	struct vfio_iommu_driver *iommu_driver;
 	struct file *filep;
 	int ret;
 
@@ -1259,12 +1278,7 @@ static struct file *vfio_device_open(struct vfio_device *device)
 			if (ret)
 				goto err_undo_count;
 		}
-
-		iommu_driver = device->group->container->iommu_driver;
-		if (iommu_driver && iommu_driver->ops->register_device)
-			iommu_driver->ops->register_device(
-				device->group->container->iommu_data, device);
-
+		vfio_device_container_register(device);
 		up_read(&device->group->group_rwsem);
 	}
 	mutex_unlock(&device->dev_set->lock);
@@ -1302,10 +1316,7 @@ static struct file *vfio_device_open(struct vfio_device *device)
 	if (device->open_count == 1 && device->ops->close_device) {
 		device->ops->close_device(device);
 
-		iommu_driver = device->group->container->iommu_driver;
-		if (iommu_driver && iommu_driver->ops->unregister_device)
-			iommu_driver->ops->unregister_device(
-				device->group->container->iommu_data, device);
+		vfio_device_container_unregister(device);
 	}
 err_undo_count:
 	up_read(&device->group->group_rwsem);
@@ -1513,7 +1524,6 @@ static inline void vfio_device_pm_runtime_put(struct vfio_device *device)
 static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 {
 	struct vfio_device *device = filep->private_data;
-	struct vfio_iommu_driver *iommu_driver;
 
 	mutex_lock(&device->dev_set->lock);
 	vfio_assert_device_open(device);
@@ -1521,10 +1531,7 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 	if (device->open_count == 1 && device->ops->close_device)
 		device->ops->close_device(device);
 
-	iommu_driver = device->group->container->iommu_driver;
-	if (iommu_driver && iommu_driver->ops->unregister_device)
-		iommu_driver->ops->unregister_device(
-			device->group->container->iommu_data, device);
+	vfio_device_container_unregister(device);
 	up_read(&device->group->group_rwsem);
 	device->open_count--;
 	if (device->open_count == 0)
-- 
2.37.3

