Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A65D355C6B
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 21:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244935AbhDFTlJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 15:41:09 -0400
Received: from mail-eopbgr760073.outbound.protection.outlook.com ([40.107.76.73]:37142
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244919AbhDFTlB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 15:41:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q5tTlin1FPUd1t99bSg1c+jSW494OixGC1K7ySUAZ+CGO+QKuUBucJ3BHwH9ZWecAVBFP7yVpfPgl2DA7VW2BmTfcFnQpZLFYEr9wZYXd9LdColCsjOFBFm/0TvHDVSiNfK3H8/P/pQs5qmPozkMM9MUXxHEtTRt5KV6elPqysFjRI5ET3dHpFWUWS+pqC9AMeskyaIUKa2DUKjo616loWPB10ezwXXqAu6fmGjacWcisHow6JUx+pBgSjQbbqosZi16fS8IYTKYsmQi+S03rksLuSKr70qFSkQpyFXS/bQmVBLDFUvMhv+h5RoRLR2uaSnp6O94HzyqBTy4eCmYPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0FQj00VVNg6rlFwj6jhe1iw9BZC/IV+c6ye6Z6XpS20=;
 b=aau8rw4gtfPfYnHmDXz1QTRoC8p5fjrc+uJLuwX+bn4VZQTxppbMLDWdys82cO6JGCYGbs2wrNWEbVIz71lMtQiWgHW+fovND++E/NVQDrGviGhaXp+bTUDs8eobIkUf/QEtbXLqJw0PBeigNFvxtuJq648aWCuPSkrfiMypJC82JY5TliKhycA9tdoGxeYpco7mi851bmodfV/L6AJhQc2Qj28BvgzmUt2WLg4oWNLhByvR7zSUW6C3TV+7E6QNgEFpPSztOw7QyhydO9XSbUW1RibtQCpN7OpgvOUbDetwaaA6piVd7gfojUa8iqvsDuI9B4NCJN9oNw1OkMSSIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0FQj00VVNg6rlFwj6jhe1iw9BZC/IV+c6ye6Z6XpS20=;
 b=g1uzu8DQ2VaRXrzn1YCzcwbTdV+YW1kjJSNwVd2x9TDSI5Pnu8V3ZITYx1MylyBRZzOoo/MbPZViYJyr4aQqwesGe63N/RQZBbrU7mvR0/wCRTZWw/BhDACDdSIbHAHp/kmtZbB8vxiw3cUqmDZSG10TXHjgBTjF3jK7EGCPdR7CWquwa+q6+X4d7ipBrYO1ZAzmVh9bSGTPiFbzuMd3K5heB1iWrcP/8t+HbeOJLUuGG0wsh9WRUMsBWcxUX5O3VNDPLL/sa28u3R4XrbjZqRmi/RbJM83Q0Fbw7BxC1LefAifXYxkTSeqDPhSRbHwPAjw3yggcDgTK/anwTp9VlQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1546.namprd12.prod.outlook.com (2603:10b6:4:8::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4020.16; Tue, 6 Apr 2021 19:40:52 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 19:40:51 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v2 03/18] vfio/mdev: Add missing typesafety around mdev_device
Date:   Tue,  6 Apr 2021 16:40:26 -0300
Message-Id: <3-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
In-Reply-To: <0-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR16CA0014.namprd16.prod.outlook.com
 (2603:10b6:208:134::27) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR16CA0014.namprd16.prod.outlook.com (2603:10b6:208:134::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Tue, 6 Apr 2021 19:40:47 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lTrZ3-001mX0-Uf; Tue, 06 Apr 2021 16:40:41 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 401a96d6-dba8-4aa4-8ebf-08d8f933e013
X-MS-TrafficTypeDiagnostic: DM5PR12MB1546:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB154610DB0B0A90D09C3C4040C2769@DM5PR12MB1546.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XtRAI6XCe5057WVp/d/PjuXdLVcerwuui4H2Qh/NF9q63LzI77UwVsCTqzrRM83rB/jt1/xg+WsV7v59jfma9lQzXI925/Z5qNCD8kgW1efDkBFfkCb4h35ELjnvhCXUzh9IS1RovEEATcdXYuW5auH2n8u+dPVfzbxRYO8PQFtY6W6rykZXk4x4venqzRy30x6b4oMwZmouCDhAntewuDJachxSErO7fnou46qWsXZUqUOBkZ3yDccPFNQNuGjLB9TI7HJgFiNv0bdi227YJQJhKQkdFYRCkoeZpv0rpJKvJ1eZGs/8DTn7Jqq+QXGYVJPRWlaXIha/lSKsGKeLCM7V5TWgpzb4tsfOHcuWncSDIXSmgVtt9ku7r5jGvDSQlJrG2oSUgfTwMAUKRVIBXJhqJKK2a3ucRfjhNrYevrxSlOOahHqd/ceAi/YzhuZm9OH1aYJQ/I8/YKn3Am8FDqHs3gdmg8AqTRgRvd7aj3wX32FkdGlHvw9cHxqqBPUVEZmqhy+qyKtg5ZAh91/1ygeTqFtNDmLcbP2UO/y8skI9xG6ikkn8FMl6s+/O1lXowalSc/ENNVRev1SjgAAzvDAU8q9bgSY8NV0Oo0cBtNmpZ8qpSU8/zOYYUxW5KQbqvXOyjxSQl1r92+ezdlOLyLYc99oXl1F7GwZ8v1EK0ooAHDkpSBiN5py9ki7FSxJl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(39860400002)(376002)(366004)(316002)(86362001)(5660300002)(8676002)(186003)(66946007)(4326008)(8936002)(66556008)(66476007)(2906002)(30864003)(38100700001)(83380400001)(9786002)(478600001)(54906003)(426003)(36756003)(9746002)(2616005)(6666004)(110136005)(107886003)(26005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?p9V3rMW8D3dCqc1kUxPuCStRfyhXlJBVghP12yLeOa1+LhMhd0p3+7L7dooG?=
 =?us-ascii?Q?9iuMqsPSHkfWkcRLV0aTuR/Nkjo6+m2MEigqE7gEyL1ikTJFC3x4xp88z3JJ?=
 =?us-ascii?Q?IbJd8ivTwt1RG/1XaZ1JBXt7hEXjhO0LWzGeadrfaHTfGuykAMoc1EI5O8Wp?=
 =?us-ascii?Q?lXJiDjo9xMPts3mPTAJEECQO88CokSgQ9xkFl0N4L3vb/txufy7ECzl7T+Qd?=
 =?us-ascii?Q?PYT4jlYZyWPCZdPsmxEyoOWXP8xkAtOMGbDOZTGUzs8lsv4PHxSX9rIxzeR/?=
 =?us-ascii?Q?lHTybk8Wyp/7jOvwL4qz4/zwMOj6/FMkAEVFl1OZrgYhvWznwPfY7YODW7Jt?=
 =?us-ascii?Q?ZbWz9t6PnzPslezwDpkrgDZYfNKB/l/LKMwwE4w425Kf3X75OIYKd/SsxBw7?=
 =?us-ascii?Q?ut5Nq7IcLbCYfI2K8muSM3ZVqxk1/LLIae1h57oirFg98NIiA6QsCb3Vqdc2?=
 =?us-ascii?Q?/bJJuKu15mCCG2DxtLFXivWe9oJC3TNXohkGk4qtlT6621ifO1Pr4ddsnG6s?=
 =?us-ascii?Q?M2DanPaYkWbBPdGq6Ygadv3mP2kxO+lHavwk2tFcVBLtK/53TRY/w5vCouJS?=
 =?us-ascii?Q?bp/M+xJKLid4pZRxt13MlK/foX9XzcqQ/9HaIQ0xVUX/occ01TNt3iOSrWDj?=
 =?us-ascii?Q?8HbuwMiOzIYqMG0I8/1G5euuUHPPn0xh0OPdYY0QUFF6wDTP/z7553WiJK9x?=
 =?us-ascii?Q?xHZsjuXoGL8Xt48QhL/wjaTLVXHBgY4JJaGwwHeqy8geV4jOtM1lwjXDJdtc?=
 =?us-ascii?Q?SHNdsT+e9OUWhOdBuyDNEewxrYKIFoM3z8vRr/PLv0axq8VvUAtBnSy6MN76?=
 =?us-ascii?Q?pyhL3BXNzut1Xy0GZYLSZuBwb5aOOlApdrwwjOErZMDhLS6I/uIFkwF25Yp+?=
 =?us-ascii?Q?i7ZWZjzCcjNk7sRVmHDamjooG/yljPEPtq0JPoRgJTSatXjnNvc1vV0K2neA?=
 =?us-ascii?Q?loYi4t5Xn8+bFywUndOIGp22umKH06itos43vkP4jD5XpWvg4EXYH3p2s+Hn?=
 =?us-ascii?Q?1fnR0+zzd+YY9Xs9pFA3OqzBd5eyk7XQW5bxOEFwRiy5lhpp35DozUWJduLS?=
 =?us-ascii?Q?U9A2qxbWnCBD97EbAnGYhhQ26Jt2hbYfXmfVCklqEjaWAQjYg2Dbstw8AXz4?=
 =?us-ascii?Q?5SPwHSwYw7jIbG8jOJuatnzgNJJCPLP/tvAUoVuyP/HojmTFBqWhkZqUHhLM?=
 =?us-ascii?Q?GfHCVvtszXObiuU+YCD+VFDQQoU2U8Aw3kNAgPfYAM8vkc7m4ynV+HHxjQ6v?=
 =?us-ascii?Q?QRAu+/bPf3p5g5yyJMhEUbjb4/v4EicGW/vQEV2/nrKE5yBBDvmjvRGNSELq?=
 =?us-ascii?Q?weeJDVLWo8O7TwnsMStoQYadswFzHyGt0F6ClGIsmG+0Qw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 401a96d6-dba8-4aa4-8ebf-08d8f933e013
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 19:40:47.8357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TsbparaVvv0Ss7Fimx2EbOWg09ae59KpNrt5YopQal7+Bd186+anuEj2TtunpNaO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1546
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The mdev API should accept and pass a 'struct mdev_device *' in all
places, not pass a 'struct device *' and cast it internally with
to_mdev_device(). Particularly in its struct mdev_driver functions, the
whole point of a bus's struct device_driver wrapper is to provide type
safety compared to the default struct device_driver.

Further, the driver core standard is for bus drivers to expose their
device structure in their public headers that can be used with
container_of() inlines and '&foo->dev' to go between the class levels, and
'&foo->dev' to be used with dev_err/etc driver core helper functions. Move
'struct mdev_device' to mdev.h

Once done this allows moving some one instruction exported functions to
static inlines, which in turns allows removing one of the two grotesque
symbol_get()'s related to mdev in the core code.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../driver-api/vfio-mediated-device.rst       |  4 +-
 drivers/vfio/mdev/mdev_core.c                 | 64 ++-----------------
 drivers/vfio/mdev/mdev_driver.c               |  4 +-
 drivers/vfio/mdev/mdev_private.h              | 23 +------
 drivers/vfio/mdev/mdev_sysfs.c                | 26 ++++----
 drivers/vfio/mdev/vfio_mdev.c                 |  7 +-
 drivers/vfio/vfio_iommu_type1.c               | 25 ++------
 include/linux/mdev.h                          | 58 +++++++++++++----
 8 files changed, 83 insertions(+), 128 deletions(-)

diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
index 25eb7d5b834ba3..c43c1dc3333373 100644
--- a/Documentation/driver-api/vfio-mediated-device.rst
+++ b/Documentation/driver-api/vfio-mediated-device.rst
@@ -105,8 +105,8 @@ structure to represent a mediated device's driver::
       */
      struct mdev_driver {
 	     const char *name;
-	     int  (*probe)  (struct device *dev);
-	     void (*remove) (struct device *dev);
+	     int  (*probe)  (struct mdev_device *dev);
+	     void (*remove) (struct mdev_device *dev);
 	     struct device_driver    driver;
      };
 
diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 6de97d25a3f87d..057922a1707e04 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -33,36 +33,6 @@ struct device *mdev_parent_dev(struct mdev_device *mdev)
 }
 EXPORT_SYMBOL(mdev_parent_dev);
 
-void *mdev_get_drvdata(struct mdev_device *mdev)
-{
-	return mdev->driver_data;
-}
-EXPORT_SYMBOL(mdev_get_drvdata);
-
-void mdev_set_drvdata(struct mdev_device *mdev, void *data)
-{
-	mdev->driver_data = data;
-}
-EXPORT_SYMBOL(mdev_set_drvdata);
-
-struct device *mdev_dev(struct mdev_device *mdev)
-{
-	return &mdev->dev;
-}
-EXPORT_SYMBOL(mdev_dev);
-
-struct mdev_device *mdev_from_dev(struct device *dev)
-{
-	return dev_is_mdev(dev) ? to_mdev_device(dev) : NULL;
-}
-EXPORT_SYMBOL(mdev_from_dev);
-
-const guid_t *mdev_uuid(struct mdev_device *mdev)
-{
-	return &mdev->uuid;
-}
-EXPORT_SYMBOL(mdev_uuid);
-
 /* Should be called holding parent_list_lock */
 static struct mdev_parent *__find_parent_device(struct device *dev)
 {
@@ -107,7 +77,7 @@ static void mdev_device_remove_common(struct mdev_device *mdev)
 	int ret;
 
 	type = to_mdev_type(mdev->type_kobj);
-	mdev_remove_sysfs_files(&mdev->dev, type);
+	mdev_remove_sysfs_files(mdev, type);
 	device_del(&mdev->dev);
 	parent = mdev->parent;
 	lockdep_assert_held(&parent->unreg_sem);
@@ -122,12 +92,10 @@ static void mdev_device_remove_common(struct mdev_device *mdev)
 
 static int mdev_device_remove_cb(struct device *dev, void *data)
 {
-	if (dev_is_mdev(dev)) {
-		struct mdev_device *mdev;
+	struct mdev_device *mdev = mdev_from_dev(dev);
 
-		mdev = to_mdev_device(dev);
+	if (mdev)
 		mdev_device_remove_common(mdev);
-	}
 	return 0;
 }
 
@@ -332,7 +300,7 @@ int mdev_device_create(struct kobject *kobj,
 	if (ret)
 		goto add_fail;
 
-	ret = mdev_create_sysfs_files(&mdev->dev, type);
+	ret = mdev_create_sysfs_files(mdev, type);
 	if (ret)
 		goto sysfs_fail;
 
@@ -354,13 +322,11 @@ int mdev_device_create(struct kobject *kobj,
 	return ret;
 }
 
-int mdev_device_remove(struct device *dev)
+int mdev_device_remove(struct mdev_device *mdev)
 {
-	struct mdev_device *mdev, *tmp;
+	struct mdev_device *tmp;
 	struct mdev_parent *parent;
 
-	mdev = to_mdev_device(dev);
-
 	mutex_lock(&mdev_list_lock);
 	list_for_each_entry(tmp, &mdev_list, next) {
 		if (tmp == mdev)
@@ -390,24 +356,6 @@ int mdev_device_remove(struct device *dev)
 	return 0;
 }
 
-int mdev_set_iommu_device(struct device *dev, struct device *iommu_device)
-{
-	struct mdev_device *mdev = to_mdev_device(dev);
-
-	mdev->iommu_device = iommu_device;
-
-	return 0;
-}
-EXPORT_SYMBOL(mdev_set_iommu_device);
-
-struct device *mdev_get_iommu_device(struct device *dev)
-{
-	struct mdev_device *mdev = to_mdev_device(dev);
-
-	return mdev->iommu_device;
-}
-EXPORT_SYMBOL(mdev_get_iommu_device);
-
 static int __init mdev_init(void)
 {
 	return mdev_bus_register();
diff --git a/drivers/vfio/mdev/mdev_driver.c b/drivers/vfio/mdev/mdev_driver.c
index 0d3223aee20b83..44c3ba7e56d923 100644
--- a/drivers/vfio/mdev/mdev_driver.c
+++ b/drivers/vfio/mdev/mdev_driver.c
@@ -48,7 +48,7 @@ static int mdev_probe(struct device *dev)
 		return ret;
 
 	if (drv && drv->probe) {
-		ret = drv->probe(dev);
+		ret = drv->probe(mdev);
 		if (ret)
 			mdev_detach_iommu(mdev);
 	}
@@ -62,7 +62,7 @@ static int mdev_remove(struct device *dev)
 	struct mdev_device *mdev = to_mdev_device(dev);
 
 	if (drv && drv->remove)
-		drv->remove(dev);
+		drv->remove(mdev);
 
 	mdev_detach_iommu(mdev);
 
diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
index 74c2e541146999..bb60ec4a8d9d21 100644
--- a/drivers/vfio/mdev/mdev_private.h
+++ b/drivers/vfio/mdev/mdev_private.h
@@ -24,23 +24,6 @@ struct mdev_parent {
 	struct rw_semaphore unreg_sem;
 };
 
-struct mdev_device {
-	struct device dev;
-	struct mdev_parent *parent;
-	guid_t uuid;
-	void *driver_data;
-	struct list_head next;
-	struct kobject *type_kobj;
-	struct device *iommu_device;
-	bool active;
-};
-
-static inline struct mdev_device *to_mdev_device(struct device *dev)
-{
-	return container_of(dev, struct mdev_device, dev);
-}
-#define dev_is_mdev(d)		((d)->bus == &mdev_bus_type)
-
 struct mdev_type {
 	struct kobject kobj;
 	struct kobject *devices_kobj;
@@ -57,11 +40,11 @@ struct mdev_type {
 int  parent_create_sysfs_files(struct mdev_parent *parent);
 void parent_remove_sysfs_files(struct mdev_parent *parent);
 
-int  mdev_create_sysfs_files(struct device *dev, struct mdev_type *type);
-void mdev_remove_sysfs_files(struct device *dev, struct mdev_type *type);
+int  mdev_create_sysfs_files(struct mdev_device *mdev, struct mdev_type *type);
+void mdev_remove_sysfs_files(struct mdev_device *mdev, struct mdev_type *type);
 
 int  mdev_device_create(struct kobject *kobj,
 			struct device *dev, const guid_t *uuid);
-int  mdev_device_remove(struct device *dev);
+int  mdev_device_remove(struct mdev_device *dev);
 
 #endif /* MDEV_PRIVATE_H */
diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index 367ff5412a3879..18114f3e090a2a 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -225,6 +225,7 @@ int parent_create_sysfs_files(struct mdev_parent *parent)
 static ssize_t remove_store(struct device *dev, struct device_attribute *attr,
 			    const char *buf, size_t count)
 {
+	struct mdev_device *mdev = to_mdev_device(dev);
 	unsigned long val;
 
 	if (kstrtoul(buf, 0, &val) < 0)
@@ -233,7 +234,7 @@ static ssize_t remove_store(struct device *dev, struct device_attribute *attr,
 	if (val && device_remove_file_self(dev, attr)) {
 		int ret;
 
-		ret = mdev_device_remove(dev);
+		ret = mdev_device_remove(mdev);
 		if (ret)
 			return ret;
 	}
@@ -248,34 +249,37 @@ static const struct attribute *mdev_device_attrs[] = {
 	NULL,
 };
 
-int  mdev_create_sysfs_files(struct device *dev, struct mdev_type *type)
+int mdev_create_sysfs_files(struct mdev_device *mdev, struct mdev_type *type)
 {
+	struct kobject *kobj = &mdev->dev.kobj;
 	int ret;
 
-	ret = sysfs_create_link(type->devices_kobj, &dev->kobj, dev_name(dev));
+	ret = sysfs_create_link(type->devices_kobj, kobj, dev_name(&mdev->dev));
 	if (ret)
 		return ret;
 
-	ret = sysfs_create_link(&dev->kobj, &type->kobj, "mdev_type");
+	ret = sysfs_create_link(kobj, &type->kobj, "mdev_type");
 	if (ret)
 		goto type_link_failed;
 
-	ret = sysfs_create_files(&dev->kobj, mdev_device_attrs);
+	ret = sysfs_create_files(kobj, mdev_device_attrs);
 	if (ret)
 		goto create_files_failed;
 
 	return ret;
 
 create_files_failed:
-	sysfs_remove_link(&dev->kobj, "mdev_type");
+	sysfs_remove_link(kobj, "mdev_type");
 type_link_failed:
-	sysfs_remove_link(type->devices_kobj, dev_name(dev));
+	sysfs_remove_link(type->devices_kobj, dev_name(&mdev->dev));
 	return ret;
 }
 
-void mdev_remove_sysfs_files(struct device *dev, struct mdev_type *type)
+void mdev_remove_sysfs_files(struct mdev_device *mdev, struct mdev_type *type)
 {
-	sysfs_remove_files(&dev->kobj, mdev_device_attrs);
-	sysfs_remove_link(&dev->kobj, "mdev_type");
-	sysfs_remove_link(type->devices_kobj, dev_name(dev));
+	struct kobject *kobj = &mdev->dev.kobj;
+
+	sysfs_remove_files(kobj, mdev_device_attrs);
+	sysfs_remove_link(kobj, "mdev_type");
+	sysfs_remove_link(type->devices_kobj, dev_name(&mdev->dev));
 }
diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
index ae7e322fbe3c26..91b7b8b9eb9cb8 100644
--- a/drivers/vfio/mdev/vfio_mdev.c
+++ b/drivers/vfio/mdev/vfio_mdev.c
@@ -124,9 +124,8 @@ static const struct vfio_device_ops vfio_mdev_dev_ops = {
 	.request	= vfio_mdev_request,
 };
 
-static int vfio_mdev_probe(struct device *dev)
+static int vfio_mdev_probe(struct mdev_device *mdev)
 {
-	struct mdev_device *mdev = to_mdev_device(dev);
 	struct vfio_device *vdev;
 	int ret;
 
@@ -144,9 +143,9 @@ static int vfio_mdev_probe(struct device *dev)
 	return 0;
 }
 
-static void vfio_mdev_remove(struct device *dev)
+static void vfio_mdev_remove(struct mdev_device *mdev)
 {
-	struct vfio_device *vdev = dev_get_drvdata(dev);
+	struct vfio_device *vdev = dev_get_drvdata(&mdev->dev);
 
 	vfio_unregister_group_dev(vdev);
 	kfree(vdev);
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index be444407664af7..51749b73075885 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1927,28 +1927,13 @@ static bool vfio_iommu_has_sw_msi(struct list_head *group_resv_regions,
 	return ret;
 }
 
-static struct device *vfio_mdev_get_iommu_device(struct device *dev)
-{
-	struct device *(*fn)(struct device *dev);
-	struct device *iommu_device;
-
-	fn = symbol_get(mdev_get_iommu_device);
-	if (fn) {
-		iommu_device = fn(dev);
-		symbol_put(mdev_get_iommu_device);
-
-		return iommu_device;
-	}
-
-	return NULL;
-}
-
 static int vfio_mdev_attach_domain(struct device *dev, void *data)
 {
+	struct mdev_device *mdev = to_mdev_device(dev);
 	struct iommu_domain *domain = data;
 	struct device *iommu_device;
 
-	iommu_device = vfio_mdev_get_iommu_device(dev);
+	iommu_device = mdev_get_iommu_device(mdev);
 	if (iommu_device) {
 		if (iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
 			return iommu_aux_attach_device(domain, iommu_device);
@@ -1961,10 +1946,11 @@ static int vfio_mdev_attach_domain(struct device *dev, void *data)
 
 static int vfio_mdev_detach_domain(struct device *dev, void *data)
 {
+	struct mdev_device *mdev = to_mdev_device(dev);
 	struct iommu_domain *domain = data;
 	struct device *iommu_device;
 
-	iommu_device = vfio_mdev_get_iommu_device(dev);
+	iommu_device = mdev_get_iommu_device(mdev);
 	if (iommu_device) {
 		if (iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
 			iommu_aux_detach_device(domain, iommu_device);
@@ -2012,9 +1998,10 @@ static bool vfio_bus_is_mdev(struct bus_type *bus)
 
 static int vfio_mdev_iommu_device(struct device *dev, void *data)
 {
+	struct mdev_device *mdev = to_mdev_device(dev);
 	struct device **old = data, *new;
 
-	new = vfio_mdev_get_iommu_device(dev);
+	new = mdev_get_iommu_device(mdev);
 	if (!new || (*old && *old != new))
 		return -EINVAL;
 
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 27eb383cb95de0..52f7ea19dd0f56 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -10,7 +10,21 @@
 #ifndef MDEV_H
 #define MDEV_H
 
-struct mdev_device;
+struct mdev_device {
+	struct device dev;
+	struct mdev_parent *parent;
+	guid_t uuid;
+	void *driver_data;
+	struct list_head next;
+	struct kobject *type_kobj;
+	struct device *iommu_device;
+	bool active;
+};
+
+static inline struct mdev_device *to_mdev_device(struct device *dev)
+{
+	return container_of(dev, struct mdev_device, dev);
+}
 
 /*
  * Called by the parent device driver to set the device which represents
@@ -19,12 +33,17 @@ struct mdev_device;
  *
  * @dev: the mediated device that iommu will isolate.
  * @iommu_device: a pci device which represents the iommu for @dev.
- *
- * Return 0 for success, otherwise negative error value.
  */
-int mdev_set_iommu_device(struct device *dev, struct device *iommu_device);
+static inline void mdev_set_iommu_device(struct mdev_device *mdev,
+					 struct device *iommu_device)
+{
+	mdev->iommu_device = iommu_device;
+}
 
-struct device *mdev_get_iommu_device(struct device *dev);
+static inline struct device *mdev_get_iommu_device(struct mdev_device *mdev)
+{
+	return mdev->iommu_device;
+}
 
 /**
  * struct mdev_parent_ops - Structure to be registered for each parent device to
@@ -126,16 +145,25 @@ struct mdev_type_attribute mdev_type_attr_##_name =		\
  **/
 struct mdev_driver {
 	const char *name;
-	int  (*probe)(struct device *dev);
-	void (*remove)(struct device *dev);
+	int (*probe)(struct mdev_device *dev);
+	void (*remove)(struct mdev_device *dev);
 	struct device_driver driver;
 };
 
 #define to_mdev_driver(drv)	container_of(drv, struct mdev_driver, driver)
 
-void *mdev_get_drvdata(struct mdev_device *mdev);
-void mdev_set_drvdata(struct mdev_device *mdev, void *data);
-const guid_t *mdev_uuid(struct mdev_device *mdev);
+static inline void *mdev_get_drvdata(struct mdev_device *mdev)
+{
+	return mdev->driver_data;
+}
+static inline void mdev_set_drvdata(struct mdev_device *mdev, void *data)
+{
+	mdev->driver_data = data;
+}
+static inline const guid_t *mdev_uuid(struct mdev_device *mdev)
+{
+	return &mdev->uuid;
+}
 
 extern struct bus_type mdev_bus_type;
 
@@ -146,7 +174,13 @@ int mdev_register_driver(struct mdev_driver *drv, struct module *owner);
 void mdev_unregister_driver(struct mdev_driver *drv);
 
 struct device *mdev_parent_dev(struct mdev_device *mdev);
-struct device *mdev_dev(struct mdev_device *mdev);
-struct mdev_device *mdev_from_dev(struct device *dev);
+static inline struct device *mdev_dev(struct mdev_device *mdev)
+{
+	return &mdev->dev;
+}
+static inline struct mdev_device *mdev_from_dev(struct device *dev)
+{
+	return dev->bus == &mdev_bus_type ? to_mdev_device(dev) : NULL;
+}
 
 #endif /* MDEV_H */
-- 
2.31.1

