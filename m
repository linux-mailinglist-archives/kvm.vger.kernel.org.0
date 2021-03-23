Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916353464BD
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 17:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbhCWQPo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 12:15:44 -0400
Received: from mail-co1nam11on2068.outbound.protection.outlook.com ([40.107.220.68]:19553
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233163AbhCWQPT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 12:15:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XTtAnMXWAQ3cHX33qR/iEWo+nTI9wOnP2Mq7pYz65eQ+cgDtfcMoq2mw7XOKWj4CnKflzXNzD/PQnzozd8U8RXJ5r06lRkB1fwcTmie+QqFi4ZHmwpOvy2RDr6LOIW+rQK5JITMFGvihjYrTEZAEW0ODFEZmA8eOw/FR0Z+2WsgMa4+9JXr+nJiuUP9dqtGHSB0lUxArXAFE5vB9oD99WL1Ahf3EngkpLNQOie6mZmOHN8+mxOdWTCVsGVhcZ9NEJuLWozxMdWjME/Q4P6Bl6d8qQip3yAO2Tn3O0lTnOHnywt+mGfMPylAjJYHLADIsDpiKVCGzrWigKvyruq/puQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L6ysqxGZrhdOpZxb0cVTWjHkX9ItpBvek1siVut3oiA=;
 b=Au/KMbSRm5P0dDAm3BxM+gBcreoGjWNbyh0aUlYKaCh7g8Bx66s5wt9PUS7xunfOam1LcX1QlHFdJKVeIaJCVvAUSSPF7OsryZlnxIvLOvUokzbPBvx5jNo0NXaPmz8dn8O32aSVBjIxPRbDn4E7pcd4kOVdEEcwlztxwIz7YsPvut5H9aTbpg5q/zdu9UC0+5bcaEGmwx6nVJ2KajxkwsMj5T65pxCNIyZQuPXUw4wOEg6ZQbeWfmxMnuOX7owm8/27j5maHazZi9DnYUBIFi/A1L3Z+NYIKWaDggRt6ysFaCDFuXIk7HhbICiHXrxXMhXswJk/xbVxGiZowfrBOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L6ysqxGZrhdOpZxb0cVTWjHkX9ItpBvek1siVut3oiA=;
 b=UsioVh3c/f0rJTCUGpWWc32jQIt+MgxoEJp2XQ3WCf3+jiDmknGsIyA1GiOyhIkZMDNF9L35OnHxQ0PfkVVzaAq7i66n2V5/uBWnhP05CCi+v1oeaeL5xdfRQdTDsGbhHEn2HObU8h4gAErzveySiKCfmCGftDzbmceApEo45P2unmm+OHTbj3Xjlpr5hZX3Y8KDRssi9cObm5+DpgCKVaZSa8GHr2lfvTcAEhTvC4xrLHYSIsYK8EVUX3cuVCkF+XoDIxlJ+BYQ3bZgtV4O49r126SdBxvPBESxYI7vFM5UzgPO6FVuIOIshBGMGpH6dD+UoqQ/SsuAXFPZullBSw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4267.namprd12.prod.outlook.com (2603:10b6:5:21e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Tue, 23 Mar
 2021 16:15:14 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 16:15:14 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        Liu Yi L <yi.l.liu@intel.com>
Subject: [PATCH v3 10/14] vfio/mdev: Use vfio_init/register/unregister_group_dev
Date:   Tue, 23 Mar 2021 13:15:02 -0300
Message-Id: <10-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: BL1PR13CA0194.namprd13.prod.outlook.com
 (2603:10b6:208:2be::19) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by BL1PR13CA0194.namprd13.prod.outlook.com (2603:10b6:208:2be::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.10 via Frontend Transport; Tue, 23 Mar 2021 16:15:10 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOjgQ-001aD0-Oz; Tue, 23 Mar 2021 13:15:06 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 940d608a-8416-48d1-8353-08d8ee16d538
X-MS-TrafficTypeDiagnostic: DM6PR12MB4267:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4267A876C0F8FA3CCB3843B2C2649@DM6PR12MB4267.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y8McTMbF0zF6/zjRieDrxKRw83jKc8XmqWYvawgpwmghs+AyBqs9iYX6Qirl4V/l/jlNyuoPu51/3btM+bvv2UF02o7UIlB37sPT0OSf1RnTJfSHzCdnfpIgCpBLkyq6UDyUcTICyvjEnRJSDF8vx47edg09hdWRuD+or4TV3j2Rpj+501hdbDP2UNN8ruvosvVMC+GWURxxpLQonFZqraNgdxwyAuGW/pZg4Fiw3xe3ox/yFecIRoxQD9uKBEihhTh/L4Q6GxKHy6LDW/tElQ2v6m3O/Ag3XWywwqT7sNfH5/goBHczyTgmSKs5bu+WCGHuy68uobzJofdxzCcTKNrGDAgBRW91XLSmu8vwm7a+X8O+ILXUL24LdoNCwsbJk0EqPko1ChnLPEwZH2A3BMy+VXZIFnxWV3WeZhWb6dUMJtqf6RSjDTukqeMRbOOWo9u4H5upbJxuVhwOYxQtbS5NtInPZOyPRw4AAcHxzGYECX7X1NiDiYa5+jaNs/2jVZiTyAfyAshS8IX/YzCq+wjhDk5tl2aBHIt5YVgdqzFrmRfPmEND5mWkAl/0wW0zDwW/Pam+OGupiONxexZbiGfPpikyjOdzgWOyCc/Qbbx97MwfxGRMRJzCugm+ppHomB/wExTGEsrwJIV9/mirwiYEI9BpDTHU9Z3gYWrixus=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(6636002)(5660300002)(66476007)(2616005)(66946007)(66556008)(2906002)(186003)(6666004)(83380400001)(426003)(54906003)(110136005)(316002)(8936002)(478600001)(8676002)(4326008)(26005)(9746002)(9786002)(86362001)(36756003)(38100700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2enOmlo9N6h0mTAAk20SQ7OKtTGnry0g+uNTxyfCIecHIB/hl8pReYbzmcVN?=
 =?us-ascii?Q?fOwHaiW+PYFhMvO5LsajX/QVrSukelmzi0y/dJOyHNtuDsq5c4VUCBa1lMh+?=
 =?us-ascii?Q?Y90eOzRIdFv5RP+vnBGKt7tR/nDwMQO9MP+zoZPqcL4KdFn13pMInyMQNLoi?=
 =?us-ascii?Q?DrD6Jb+C2Cwdy+ynzr8uO7qKe14KqvCRvhctXKHuHK23K1LKT8Mh82oM4zbl?=
 =?us-ascii?Q?kiJ0qjov8v5xw9Jnvt1YScWlZkqTESa1YlpGRCU376EuadInI3n4gOIvR+Kx?=
 =?us-ascii?Q?9zxGBQZ0E9/c/uLA5hdDdK9osYrb5eNMH63aySb7JjRS3nSwkKxAW+UxUE3s?=
 =?us-ascii?Q?gW9QRRQlZDBSKV0YR4y5yW4hIHGkxEeeUnoV4PF0HlGxuE3Ah7473xL3Wq5V?=
 =?us-ascii?Q?DLP+bKTPXBEF0XsR5h00LwMoDmJEtvPeBD+O/Yx5l+R4Q4yEZDvAEnYJrOee?=
 =?us-ascii?Q?UjW01tBnTFXGHp+u4m7dPLUA+B8cIbIJpk35Z7hdMoyM0tHZmShgBmrICP0t?=
 =?us-ascii?Q?by1xtMzDsixtIjn5pGdbD2YIpvrQvJ7Fhygj1obf/OGkWdBszDvmXESoiTLp?=
 =?us-ascii?Q?4H6IioSY5b8i8oxqZNpWsPV8QvA/ZUmHS0tVpcGzL36jvnyYBAR/XlxgoM3X?=
 =?us-ascii?Q?eohO+ykv0zqFW3//budQhLQHTi4xEFUSTClgpGsYasreE8d7mHZKFEEC5qg3?=
 =?us-ascii?Q?TfSP8Q+4ns9J3M91X1tSgjWrPjNoaZ+N0InWQpDdjJGIS5c9TDrKuEimP/0D?=
 =?us-ascii?Q?nt56x6nJpzbWbFGjtvBZs4CztDvd1aflPp8eEo7IFQKwJTPXFVfog9XV7TgM?=
 =?us-ascii?Q?sSguTn4fY7AbwYHywx3sYGfZxQ1Mn7qSBPt5cR+ptTxYLB/r0TMz/drCmdgF?=
 =?us-ascii?Q?UTAL1zcq/NYEPSzrUUoGK9XVcj3jn6pT7fQES4JWduUK0UGCn0QpYAbllUuM?=
 =?us-ascii?Q?UkZqnJWeAn8fmc/o6ZrrulW/oU8y3Aoi7hOLLo/Kxrsqh7wkGkPyr02yDX/x?=
 =?us-ascii?Q?sIkY1FS6NhjPmy105xWVITNWiM83QxVhEV20vVQyYKHgc85XXCjwaRVDupZB?=
 =?us-ascii?Q?K+aRGkIHi1UjdAN/vt9PvQ+CHLN++zqVSZPpfdr/FL74QcSS1+kEt+UDNpDk?=
 =?us-ascii?Q?vTHYdfMtuu7ZijkZRzt13BryR0K8eZx1OrP7tD4orL+XFFZ9QjSOjYBSVws2?=
 =?us-ascii?Q?Q8LEo/1OhG6MwLGfXEGTXyaZVPJnc/Pz1TNLm83DjHblZAeLtSACqlcmloJ5?=
 =?us-ascii?Q?/oqp0FmNkqkRWRuM6iiljv53hC/x8xbtdTxglJfC9O/i0VjYww0nGoaCYV3+?=
 =?us-ascii?Q?5M+WbPUIpNgwDXkvgomjssg2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 940d608a-8416-48d1-8353-08d8ee16d538
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 16:15:10.9095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JLip+pvxl1Hvm90w3k4hBCeYUYY61AA7L3QZs4wsQ2IlM84w/ZS0p7N9SOIxaum2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4267
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

mdev gets little benefit because it doesn't actually do anything, however
it is the last user, so move the vfio_init/register/unregister_group_dev()
code here for now.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Liu Yi L <yi.l.liu@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/mdev/vfio_mdev.c | 20 ++++++++++++++++--
 drivers/vfio/vfio.c           | 39 ++---------------------------------
 include/linux/vfio.h          |  5 -----
 3 files changed, 20 insertions(+), 44 deletions(-)

diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
index b52eea128549ee..4043cc91f9524e 100644
--- a/drivers/vfio/mdev/vfio_mdev.c
+++ b/drivers/vfio/mdev/vfio_mdev.c
@@ -124,13 +124,29 @@ static const struct vfio_device_ops vfio_mdev_dev_ops = {
 static int vfio_mdev_probe(struct device *dev)
 {
 	struct mdev_device *mdev = to_mdev_device(dev);
+	struct vfio_device *vdev;
+	int ret;
 
-	return vfio_add_group_dev(dev, &vfio_mdev_dev_ops, mdev);
+	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
+	if (!vdev)
+		return -ENOMEM;
+
+	vfio_init_group_dev(vdev, &mdev->dev, &vfio_mdev_dev_ops, mdev);
+	ret = vfio_register_group_dev(vdev);
+	if (ret) {
+		kfree(vdev);
+		return ret;
+	}
+	dev_set_drvdata(&mdev->dev, vdev);
+	return 0;
 }
 
 static void vfio_mdev_remove(struct device *dev)
 {
-	vfio_del_group_dev(dev);
+	struct vfio_device *vdev = dev_get_drvdata(dev);
+
+	vfio_unregister_group_dev(vdev);
+	kfree(vdev);
 }
 
 static struct mdev_driver vfio_mdev_driver = {
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 2ea430de505b3b..180b4ab02d115a 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -99,8 +99,8 @@ MODULE_PARM_DESC(enable_unsafe_noiommu_mode, "Enable UNSAFE, no-IOMMU mode.  Thi
 /*
  * vfio_iommu_group_{get,put} are only intended for VFIO bus driver probe
  * and remove functions, any use cases other than acquiring the first
- * reference for the purpose of calling vfio_add_group_dev() or removing
- * that symmetric reference after vfio_del_group_dev() should use the raw
+ * reference for the purpose of calling vfio_register_group_dev() or removing
+ * that symmetric reference after vfio_unregister_group_dev() should use the raw
  * iommu_group_{get,put} functions.  In particular, vfio_iommu_group_put()
  * removes the device from the dummy group and cannot be nested.
  */
@@ -799,29 +799,6 @@ int vfio_register_group_dev(struct vfio_device *device)
 }
 EXPORT_SYMBOL_GPL(vfio_register_group_dev);
 
-int vfio_add_group_dev(struct device *dev, const struct vfio_device_ops *ops,
-		       void *device_data)
-{
-	struct vfio_device *device;
-	int ret;
-
-	device = kzalloc(sizeof(*device), GFP_KERNEL);
-	if (!device)
-		return -ENOMEM;
-
-	vfio_init_group_dev(device, dev, ops, device_data);
-	ret = vfio_register_group_dev(device);
-	if (ret)
-		goto err_kfree;
-	dev_set_drvdata(dev, device);
-	return 0;
-
-err_kfree:
-	kfree(device);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(vfio_add_group_dev);
-
 /**
  * Get a reference to the vfio_device for a device.  Even if the
  * caller thinks they own the device, they could be racing with a
@@ -962,18 +939,6 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 }
 EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
 
-void *vfio_del_group_dev(struct device *dev)
-{
-	struct vfio_device *device = dev_get_drvdata(dev);
-	void *device_data = device->device_data;
-
-	vfio_unregister_group_dev(device);
-	dev_set_drvdata(dev, NULL);
-	kfree(device);
-	return device_data;
-}
-EXPORT_SYMBOL_GPL(vfio_del_group_dev);
-
 /**
  * VFIO base fd, /dev/vfio/vfio
  */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index ad8b579d67d34a..4995faf51efeae 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -63,11 +63,6 @@ extern void vfio_iommu_group_put(struct iommu_group *group, struct device *dev);
 void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
 			 const struct vfio_device_ops *ops, void *device_data);
 int vfio_register_group_dev(struct vfio_device *device);
-extern int vfio_add_group_dev(struct device *dev,
-			      const struct vfio_device_ops *ops,
-			      void *device_data);
-
-extern void *vfio_del_group_dev(struct device *dev);
 void vfio_unregister_group_dev(struct vfio_device *device);
 extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
 extern void vfio_device_put(struct vfio_device *device);
-- 
2.31.0

