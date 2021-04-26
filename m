Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7293036BA7E
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 22:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241835AbhDZUBT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 16:01:19 -0400
Received: from mail-bn8nam08on2048.outbound.protection.outlook.com ([40.107.100.48]:25530
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241780AbhDZUBI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 16:01:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ldEwvOMohGp/7CBe/j3q4ytsByvWfm//0v4deytxdUm6cS1E6F9OMJecynt+O8pZPWZpeYuaQPbQT0PrPiHchDTY2R45LvkCFpaykH5INWpB5T7RjSD1k9vs5kHKPiHSL9Dw8z9oOjIqltxSJpvD8qaYxo1u3ezVxwpdWcjKdsv5nzP1R8pJDExqyMoM3wu5fA4ZC+4aqnT5tPV740DP5gB1BP8iQpLoc2SZ/OxgWgHhkyrzSmqBxYTKeB6VZZaaUUkRMB114eAdxSkS8UVUGUP6BW9XqQXOro0/Clo/fNMJzeaHVUhoFHtUNkfImX6Bf9wiahjRG90uhw4EGySXSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xJ2UbYUG6kpAcHGol5HZRiz/M3q/Jljm82+hlGYKWUM=;
 b=nFqNs1n0ccNZvqlelll034XAikUOdjEcD6FW50mXnz2avegjDCJruhPWP4qwguCV1+tK8Sr5ErGEEbDfy+/pltDPxBIW+TdM1wIrN49/BfHfsSv/k7Ve1/CBHNt1oobp0/RkcE5AlB0x0IUpxtEoDTHTTBwIl1M7MyisoDe2w1DfPiSxvmxh3tmUkMjni0Bs7XCQfktB3bJAZpIRs1HH4WTJoXM4XNapLnWOWiY1yQeFIM1nnDFiHmJniksj0jk1sQKmt2UJEhUOWLZDNdkamslLzGdluO0jifIDlnrFAkzyP7zz4XQQ56YVQRLE5+F7FvMFPFmD4TpS26Rqapm8bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xJ2UbYUG6kpAcHGol5HZRiz/M3q/Jljm82+hlGYKWUM=;
 b=BIVdTBNtQ/FtY9qdDEGHZJwNyWZu/j+hemxfV1Rbg5ccdTXkurjOlVwtQ2ngf1ItiT9cCow/6GVd5Z4wQVoDD9KIvxxahKd1cPXHSnB0FAiGJNeEXswVVo3VwLArYL2+5nLvcykfAkF23vjnlCOIjwyEGdu0OnAwZTPLNw1BC7FtuaTiJgnS1KsBnYIK4sq8btxR4vxbhfgqHu6fXMZMdrrUIxajezsIKOfU+hyhzMgOflpYe2iE4+94cpAAF172EUpTvYMtgTu/8W6dOeE1dejHMkyoi8ysbEVryB4WolU/GNJSK5v/kYfMOSCCJ6LYYsG2/wxvXr8lHJcIWMV77A==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3740.namprd12.prod.outlook.com (2603:10b6:5:1c3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Mon, 26 Apr
 2021 20:00:19 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4065.026; Mon, 26 Apr 2021
 20:00:19 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v2 09/13] vfio/mdev: Remove vfio_mdev.c
Date:   Mon, 26 Apr 2021 17:00:11 -0300
Message-Id: <9-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
In-Reply-To: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BLAPR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:208:32b::29) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BLAPR03CA0024.namprd03.prod.outlook.com (2603:10b6:208:32b::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend Transport; Mon, 26 Apr 2021 20:00:17 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lb7Oy-00DFZX-2w; Mon, 26 Apr 2021 17:00:16 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb9fc3fe-2c9a-47bf-7e0d-08d908ede9e1
X-MS-TrafficTypeDiagnostic: DM6PR12MB3740:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB37406EE424B4137A8255D465C2429@DM6PR12MB3740.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bh9M9hCmC8VgW2MlqS/xaQP22/nYRubBciEzwunzEJAySttc1dZ6HRQ4Qbyc/i1f+vy1PIDkSOrJqV2y1CL2gz3LAw+ySpkwR4KxJQn4ZMCxoIwzYAxuD0wPLmGDtHFCI1/75AW7f9V9BZfExVxeB/kDM0euNg2kL1aY+m74XOdEi50n+tqjldIRH46BTQ4YKZ3Yyk1UfSYtr7bhghblDfCEEt4xUt7TGx2eFeBSq8EgqecHMvYUhclo4wR3i3AUwJL7PZHDNZjjorjUdg1R1Z6vijfsNVsnnancVWpZHn/xYxhU2CAnCxUhh3YB9hV5++OwcB3IQJtZUrMdLRmEVwDH51+ejzp8/vDpVWyFYcYmn5PtEekFToZOhWHwT1AwKnOhFVAx8YssLGRsV4D5gzB564KptM2GoCK7dEQCTPi+pGlRHxHoxUun5SB/ynsH1/9VW+Dd0CXvVfxNruuzBDytWp8VbPQeg5V+8yq3d76QzUxQmHWPH4Syo0oJaiE6njSDEA6hF50l7f0Z0ljvCGDC5WZEZ13XKxD+Sfp1o7eGwBCyHHXaW5WIxPd933iSirfdXB5b4FGIqS8QgsGyuRqMktvIS+Fyy/MAdlGNdFGXN/Oy+BUE8fr9B8zO2orSQ8KtGoF8vkBAIoSjXNpyzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(136003)(396003)(376002)(66476007)(66556008)(9746002)(54906003)(426003)(110136005)(107886003)(186003)(26005)(6666004)(36756003)(316002)(2906002)(30864003)(2616005)(478600001)(9786002)(8936002)(83380400001)(38100700002)(86362001)(8676002)(5660300002)(4326008)(66946007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2JtzrnWGC88gs6NSf8Jp02/o0NXBVyc3qnlnp8v4a0cw1cwoDZ0ZRe8y0Dj9?=
 =?us-ascii?Q?5DACGwPlmRIQzHRHnQpgRTJNpyHJWRoc9DkyhvKvjQ1kZTsIZMkEQYnvfdAt?=
 =?us-ascii?Q?M8t9TTRVHrSYMns5pN2MS48Ca6ZFeD4CdoM5/K9ey3k9ldEvY9N3wXF3ExVE?=
 =?us-ascii?Q?xeiGgUGaosrWyVOi/R3eZhF+Sq3qee9YkzSJ++wC4EMKhxl7Gg8Hl3MRaNOk?=
 =?us-ascii?Q?g6TzOViBt1oMHdfWJYK7pCTsawOj9ItC9ctl9U0pju1I3+uSdyPzQSva6chD?=
 =?us-ascii?Q?ToPhMyWlaXhtBGRzWkydfR7+IP6l6ejC3KybfhZAlE3MQGOGFUJ/Y70RWrFa?=
 =?us-ascii?Q?aLNmdGI+vUR00SSJJ0IaD0MWqdmMe37OjvBwE8ajKFV4abayzzq1xdrMi7dA?=
 =?us-ascii?Q?S1W4U9u7bmjirQgSIWSdrnz+B21OHz5F+CJdLmA5Kdq9ys3ZtuWNayxceWJJ?=
 =?us-ascii?Q?gMg+YeUZmKomE7Rz4nHMhg2PX9tUOSjz9GXsQUedp57Nec4AGsWKYuHIqdhx?=
 =?us-ascii?Q?kHk8ozihblVefn7bSV56f0pCjVmuJ5nXthEyzMZYEQ9/VFLivaxKY6MxsaK0?=
 =?us-ascii?Q?bQPzKWnBQ6AdBiXOoZcjtVnzwqcmUXEyJrj/MRnnKDRQMkh3WQ2WUxAYfgXl?=
 =?us-ascii?Q?2+S/e0Ys7pUbIp41t2+ZN2shYak4B1qwfVGF5KcupwqUNalz4p4e+cJeLWtY?=
 =?us-ascii?Q?4NelFhQwAPAFqfVHxtE0p7EX5McQjQnE3on+JhRCazXWnLtOoxkpY7NUUDVZ?=
 =?us-ascii?Q?+QufEpTohV0Q/YsUPsLLL1tkpQflqfmzalkZHUYKE29IztLK83IjoGKSLhTS?=
 =?us-ascii?Q?FgP6Mlp0WRwNbRKhE0uWjCsVs6yIWgjdhZpWLnBsEExFvOZ5mqp9ivw0Nvd+?=
 =?us-ascii?Q?z+it14h1z7XTmB+BUG6TeQwpWdNi6y/DL62C+oY0TV/0pmAL4CiXzXP0ZOgx?=
 =?us-ascii?Q?2UJquFWKrncpcl+6mRuZxJNfOP/5ELscDOX1EWsjAQ0tNz1T4ercdEL0sqVb?=
 =?us-ascii?Q?yD7rrg2rv4aww/VJdW/WiIvgXC1Rf9OTrElPqnp0SaoCkkjPQ/QdNPRYG66H?=
 =?us-ascii?Q?yfD9d6jmEhuqlPTP8whj/rQ7iJ3hbI5Qevm6Q1jFPmwuAWIeE6pqqPv0MzXc?=
 =?us-ascii?Q?uQU5v0AjknT7vT/I969y8OUljAojcSPSBPaFNcWUSYcrKMq5e7M92OcNroA6?=
 =?us-ascii?Q?OFJTN8OaOUGcQ4kTnCQl9odVNgnygrv21Zczqp4PedXrecik3/4iH8/04kHK?=
 =?us-ascii?Q?myS2yzGvHjGiMpJEf2yKsFxlucE0ZCXez/yX0ZhtvUCIQQS39/e/BRfBxrI2?=
 =?us-ascii?Q?APEiEp2DRn9e5+Ml+Cn6+CaX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb9fc3fe-2c9a-47bf-7e0d-08d908ede9e1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 20:00:17.7404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W2DKpSexCIg3fr1BOWLf4ei6gOuRUtZOmS951vvoFjM8CFQcJ7+8qTB9vs8jdwcs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3740
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that all mdev drivers directly create their own mdev_device driver and
directly register with the vfio core's vfio_device_ops this is all dead
code.

Delete vfio_mdev.c and the mdev_parent_ops members that are connected to
it.

Preserve VFIO's design of allowing mdev drivers to be !GPL by allowing the
three functions that replace this module for !GPL usage. This goes along
with the other 19 symbols that are already marked !GPL in VFIO.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../driver-api/vfio-mediated-device.rst       |  19 ---
 drivers/vfio/mdev/Makefile                    |   2 +-
 drivers/vfio/mdev/mdev_core.c                 |  49 +-----
 drivers/vfio/mdev/mdev_driver.c               |  21 +--
 drivers/vfio/mdev/mdev_private.h              |   2 -
 drivers/vfio/mdev/vfio_mdev.c                 | 158 ------------------
 drivers/vfio/vfio.c                           |   6 +-
 include/linux/mdev.h                          |  52 ------
 include/linux/vfio.h                          |   4 +
 9 files changed, 16 insertions(+), 297 deletions(-)
 delete mode 100644 drivers/vfio/mdev/vfio_mdev.c

diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
index 1779b85f014e2f..5f866b17c93e69 100644
--- a/Documentation/driver-api/vfio-mediated-device.rst
+++ b/Documentation/driver-api/vfio-mediated-device.rst
@@ -137,25 +137,6 @@ The structures in the mdev_parent_ops structure are as follows:
 * mdev_attr_groups: attributes of the mediated device
 * supported_config: attributes to define supported configurations
 
-The functions in the mdev_parent_ops structure are as follows:
-
-* create: allocate basic resources in a driver for a mediated device
-* remove: free resources in a driver when a mediated device is destroyed
-
-(Note that mdev-core provides no implicit serialization of create/remove
-callbacks per mdev parent device, per mdev type, or any other categorization.
-Vendor drivers are expected to be fully asynchronous in this respect or
-provide their own internal resource protection.)
-
-The callbacks in the mdev_parent_ops structure are as follows:
-
-* open: open callback of mediated device
-* close: close callback of mediated device
-* ioctl: ioctl callback of mediated device
-* read : read emulation callback
-* write: write emulation callback
-* mmap: mmap emulation callback
-
 A driver should use the mdev_parent_ops structure in the function call to
 register itself with the mdev core driver::
 
diff --git a/drivers/vfio/mdev/Makefile b/drivers/vfio/mdev/Makefile
index ff9ecd80212503..7c236ba1b90eb1 100644
--- a/drivers/vfio/mdev/Makefile
+++ b/drivers/vfio/mdev/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-mdev-y := mdev_core.o mdev_sysfs.o mdev_driver.o vfio_mdev.o
+mdev-y := mdev_core.o mdev_sysfs.o mdev_driver.o
 
 obj-$(CONFIG_VFIO_MDEV) += mdev.o
diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 51b8a9fcf866ad..d507047e6ecf4a 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -89,17 +89,10 @@ void mdev_release_parent(struct kref *kref)
 static void mdev_device_remove_common(struct mdev_device *mdev)
 {
 	struct mdev_parent *parent = mdev->type->parent;
-	int ret;
 
 	mdev_remove_sysfs_files(mdev);
 	device_del(&mdev->dev);
 	lockdep_assert_held(&parent->unreg_sem);
-	if (parent->ops->remove) {
-		ret = parent->ops->remove(mdev);
-		if (ret)
-			dev_err(&mdev->dev, "Remove failed: err=%d\n", ret);
-	}
-
 	/* Balances with device_initialize() */
 	put_device(&mdev->dev);
 }
@@ -131,17 +124,13 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
 	/* check for mandatory ops */
 	if (!ops || !ops->supported_type_groups)
 		return -EINVAL;
-	if (!ops->device_driver && (!ops->create || !ops->remove))
+	if (!ops->device_driver)
 		return -EINVAL;
 
 	dev = get_device(dev);
 	if (!dev)
 		return -EINVAL;
 
-	/* Not mandatory, but its absence could be a problem */
-	if (!ops->request)
-		dev_info(dev, "Driver cannot be asked to release device\n");
-
 	mutex_lock(&parent_list_lock);
 
 	/* Check for duplicate */
@@ -263,15 +252,12 @@ static void mdev_device_release(struct device *dev)
  */
 static int mdev_bind_driver(struct mdev_device *mdev)
 {
-	struct mdev_driver *drv = mdev->type->parent->ops->device_driver;
 	int ret;
 
-	if (!drv)
-		drv = &vfio_mdev_driver;
-
 	while (1) {
 		device_lock(&mdev->dev);
-		if (mdev->dev.driver == &drv->driver) {
+		if (mdev->dev.driver ==
+		    &mdev->type->parent->ops->device_driver->driver) {
 			ret = 0;
 			goto out_unlock;
 		}
@@ -337,15 +323,9 @@ int mdev_device_create(struct mdev_type *type, const guid_t *uuid)
 		goto out_put_device;
 	}
 
-	if (parent->ops->create) {
-		ret = parent->ops->create(mdev);
-		if (ret)
-			goto out_unlock;
-	}
-
 	ret = device_add(&mdev->dev);
 	if (ret)
-		goto out_remove;
+		goto out_unlock;
 
 	ret = mdev_bind_driver(mdev);
 	if (ret)
@@ -363,9 +343,6 @@ int mdev_device_create(struct mdev_type *type, const guid_t *uuid)
 
 out_del:
 	device_del(&mdev->dev);
-out_remove:
-	if (parent->ops->remove)
-		parent->ops->remove(mdev);
 out_unlock:
 	up_read(&parent->unreg_sem);
 out_put_device:
@@ -408,28 +385,14 @@ int mdev_device_remove(struct mdev_device *mdev)
 
 static int __init mdev_init(void)
 {
-	int rc;
-
-	rc = mdev_bus_register();
-	if (rc)
-		return rc;
-	rc = mdev_register_driver(&vfio_mdev_driver);
-	if (rc)
-		goto err_bus;
-	return 0;
-err_bus:
-	mdev_bus_unregister();
-	return rc;
+	return bus_register(&mdev_bus_type);
 }
 
 static void __exit mdev_exit(void)
 {
-	mdev_unregister_driver(&vfio_mdev_driver);
-
 	if (mdev_bus_compat_class)
 		class_compat_unregister(mdev_bus_compat_class);
-
-	mdev_bus_unregister();
+	bus_unregister(&mdev_bus_type);
 }
 
 module_init(mdev_init)
diff --git a/drivers/vfio/mdev/mdev_driver.c b/drivers/vfio/mdev/mdev_driver.c
index 6e96c023d7823d..07ada55efd6228 100644
--- a/drivers/vfio/mdev/mdev_driver.c
+++ b/drivers/vfio/mdev/mdev_driver.c
@@ -74,15 +74,8 @@ static int mdev_remove(struct device *dev)
 static int mdev_match(struct device *dev, struct device_driver *drv)
 {
 	struct mdev_device *mdev = to_mdev_device(dev);
-	struct mdev_driver *target = mdev->type->parent->ops->device_driver;
-
-	/*
-	 * The ops specify the device driver to connect, fall back to the old
-	 * shim driver if the driver hasn't been converted.
-	 */
-	if (!target)
-		target = &vfio_mdev_driver;
-	return drv == &target->driver;
+
+	return drv == &mdev->type->parent->ops->device_driver->driver;
 }
 
 struct bus_type mdev_bus_type = {
@@ -118,13 +111,3 @@ void mdev_unregister_driver(struct mdev_driver *drv)
 	driver_unregister(&drv->driver);
 }
 EXPORT_SYMBOL(mdev_unregister_driver);
-
-int mdev_bus_register(void)
-{
-	return bus_register(&mdev_bus_type);
-}
-
-void mdev_bus_unregister(void)
-{
-	bus_unregister(&mdev_bus_type);
-}
diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
index 5461b67582289f..a656cfe0346c33 100644
--- a/drivers/vfio/mdev/mdev_private.h
+++ b/drivers/vfio/mdev/mdev_private.h
@@ -37,8 +37,6 @@ struct mdev_type {
 #define to_mdev_type(_kobj)		\
 	container_of(_kobj, struct mdev_type, kobj)
 
-extern struct mdev_driver vfio_mdev_driver;
-
 int  parent_create_sysfs_files(struct mdev_parent *parent);
 void parent_remove_sysfs_files(struct mdev_parent *parent);
 
diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
deleted file mode 100644
index d5b4eede47c1a5..00000000000000
--- a/drivers/vfio/mdev/vfio_mdev.c
+++ /dev/null
@@ -1,158 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * VFIO based driver for Mediated device
- *
- * Copyright (c) 2016, NVIDIA CORPORATION. All rights reserved.
- *     Author: Neo Jia <cjia@nvidia.com>
- *             Kirti Wankhede <kwankhede@nvidia.com>
- */
-
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/device.h>
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/vfio.h>
-#include <linux/mdev.h>
-
-#include "mdev_private.h"
-
-static int vfio_mdev_open(struct vfio_device *core_vdev)
-{
-	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
-	struct mdev_parent *parent = mdev->type->parent;
-
-	int ret;
-
-	if (unlikely(!parent->ops->open))
-		return -EINVAL;
-
-	if (!try_module_get(THIS_MODULE))
-		return -ENODEV;
-
-	ret = parent->ops->open(mdev);
-	if (ret)
-		module_put(THIS_MODULE);
-
-	return ret;
-}
-
-static void vfio_mdev_release(struct vfio_device *core_vdev)
-{
-	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
-	struct mdev_parent *parent = mdev->type->parent;
-
-	if (likely(parent->ops->release))
-		parent->ops->release(mdev);
-
-	module_put(THIS_MODULE);
-}
-
-static long vfio_mdev_unlocked_ioctl(struct vfio_device *core_vdev,
-				     unsigned int cmd, unsigned long arg)
-{
-	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
-	struct mdev_parent *parent = mdev->type->parent;
-
-	if (unlikely(!parent->ops->ioctl))
-		return -EINVAL;
-
-	return parent->ops->ioctl(mdev, cmd, arg);
-}
-
-static ssize_t vfio_mdev_read(struct vfio_device *core_vdev, char __user *buf,
-			      size_t count, loff_t *ppos)
-{
-	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
-	struct mdev_parent *parent = mdev->type->parent;
-
-	if (unlikely(!parent->ops->read))
-		return -EINVAL;
-
-	return parent->ops->read(mdev, buf, count, ppos);
-}
-
-static ssize_t vfio_mdev_write(struct vfio_device *core_vdev,
-			       const char __user *buf, size_t count,
-			       loff_t *ppos)
-{
-	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
-	struct mdev_parent *parent = mdev->type->parent;
-
-	if (unlikely(!parent->ops->write))
-		return -EINVAL;
-
-	return parent->ops->write(mdev, buf, count, ppos);
-}
-
-static int vfio_mdev_mmap(struct vfio_device *core_vdev,
-			  struct vm_area_struct *vma)
-{
-	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
-	struct mdev_parent *parent = mdev->type->parent;
-
-	if (unlikely(!parent->ops->mmap))
-		return -EINVAL;
-
-	return parent->ops->mmap(mdev, vma);
-}
-
-static void vfio_mdev_request(struct vfio_device *core_vdev, unsigned int count)
-{
-	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
-	struct mdev_parent *parent = mdev->type->parent;
-
-	if (parent->ops->request)
-		parent->ops->request(mdev, count);
-	else if (count == 0)
-		dev_notice(mdev_dev(mdev),
-			   "No mdev vendor driver request callback support, blocked until released by user\n");
-}
-
-static const struct vfio_device_ops vfio_mdev_dev_ops = {
-	.name		= "vfio-mdev",
-	.open		= vfio_mdev_open,
-	.release	= vfio_mdev_release,
-	.ioctl		= vfio_mdev_unlocked_ioctl,
-	.read		= vfio_mdev_read,
-	.write		= vfio_mdev_write,
-	.mmap		= vfio_mdev_mmap,
-	.request	= vfio_mdev_request,
-};
-
-static int vfio_mdev_probe(struct mdev_device *mdev)
-{
-	struct vfio_device *vdev;
-	int ret;
-
-	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
-	if (!vdev)
-		return -ENOMEM;
-
-	vfio_init_group_dev(vdev, &mdev->dev, &vfio_mdev_dev_ops);
-	ret = vfio_register_group_dev(vdev);
-	if (ret) {
-		kfree(vdev);
-		return ret;
-	}
-	dev_set_drvdata(&mdev->dev, vdev);
-	return 0;
-}
-
-static void vfio_mdev_remove(struct mdev_device *mdev)
-{
-	struct vfio_device *vdev = dev_get_drvdata(&mdev->dev);
-
-	vfio_unregister_group_dev(vdev);
-	kfree(vdev);
-}
-
-struct mdev_driver vfio_mdev_driver = {
-	.driver = {
-		.name = "vfio_mdev",
-		.owner = THIS_MODULE,
-		.mod_name = KBUILD_MODNAME,
-	},
-	.probe	= vfio_mdev_probe,
-	.remove	= vfio_mdev_remove,
-};
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 5e631c359ef23c..59bbdf6634f934 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -747,7 +747,7 @@ void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
 	device->dev = dev;
 	device->ops = ops;
 }
-EXPORT_SYMBOL_GPL(vfio_init_group_dev);
+EXPORT_SYMBOL(vfio_init_group_dev);
 
 int vfio_register_group_dev(struct vfio_device *device)
 {
@@ -796,7 +796,7 @@ int vfio_register_group_dev(struct vfio_device *device)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(vfio_register_group_dev);
+EXPORT_SYMBOL(vfio_register_group_dev);
 
 /**
  * Get a reference to the vfio_device for a device.  Even if the
@@ -927,7 +927,7 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 	/* Matches the get in vfio_register_group_dev() */
 	vfio_group_put(group);
 }
-EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
+EXPORT_SYMBOL(vfio_unregister_group_dev);
 
 /**
  * VFIO base fd, /dev/vfio/vfio
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 49cc4f65120d57..ea48c401e4fa63 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -61,45 +61,6 @@ struct device *mtype_get_parent_dev(struct mdev_type *mtype);
  * @mdev_attr_groups:	Attributes of the mediated device.
  * @supported_type_groups: Attributes to define supported types. It is mandatory
  *			to provide supported types.
- * @create:		Called to allocate basic resources in parent device's
- *			driver for a particular mediated device. It is
- *			mandatory to provide create ops.
- *			@mdev: mdev_device structure on of mediated device
- *			      that is being created
- *			Returns integer: success (0) or error (< 0)
- * @remove:		Called to free resources in parent device's driver for
- *			a mediated device. It is mandatory to provide 'remove'
- *			ops.
- *			@mdev: mdev_device device structure which is being
- *			       destroyed
- *			Returns integer: success (0) or error (< 0)
- * @open:		Open mediated device.
- *			@mdev: mediated device.
- *			Returns integer: success (0) or error (< 0)
- * @release:		release mediated device
- *			@mdev: mediated device.
- * @read:		Read emulation callback
- *			@mdev: mediated device structure
- *			@buf: read buffer
- *			@count: number of bytes to read
- *			@ppos: address.
- *			Retuns number on bytes read on success or error.
- * @write:		Write emulation callback
- *			@mdev: mediated device structure
- *			@buf: write buffer
- *			@count: number of bytes to be written
- *			@ppos: address.
- *			Retuns number on bytes written on success or error.
- * @ioctl:		IOCTL callback
- *			@mdev: mediated device structure
- *			@cmd: ioctl command
- *			@arg: arguments to ioctl
- * @mmap:		mmap callback
- *			@mdev: mediated device structure
- *			@vma: vma structure
- * @request:		request callback to release device
- *			@mdev: mediated device structure
- *			@count: request sequence number
  * Parent device that support mediated device should be registered with mdev
  * module with mdev_parent_ops structure.
  **/
@@ -109,19 +70,6 @@ struct mdev_parent_ops {
 	const struct attribute_group **dev_attr_groups;
 	const struct attribute_group **mdev_attr_groups;
 	struct attribute_group **supported_type_groups;
-
-	int     (*create)(struct mdev_device *mdev);
-	int     (*remove)(struct mdev_device *mdev);
-	int     (*open)(struct mdev_device *mdev);
-	void    (*release)(struct mdev_device *mdev);
-	ssize_t (*read)(struct mdev_device *mdev, char __user *buf,
-			size_t count, loff_t *ppos);
-	ssize_t (*write)(struct mdev_device *mdev, const char __user *buf,
-			 size_t count, loff_t *ppos);
-	long	(*ioctl)(struct mdev_device *mdev, unsigned int cmd,
-			 unsigned long arg);
-	int	(*mmap)(struct mdev_device *mdev, struct vm_area_struct *vma);
-	void	(*request)(struct mdev_device *mdev, unsigned int count);
 };
 
 /* interface for exporting mdev supported type attributes */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index a2c5b30e1763ba..c5e08be4c56395 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -64,6 +64,10 @@ void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
 int vfio_register_group_dev(struct vfio_device *device);
 void vfio_unregister_group_dev(struct vfio_device *device);
 extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
+static inline void vfio_device_get(struct vfio_device *device)
+{
+	refcount_inc(&device->refcount);
+}
 extern void vfio_device_put(struct vfio_device *device);
 
 /* events for the backend driver notify callback */
-- 
2.31.1

