Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01C085B2610
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 20:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbiIHSp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 14:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbiIHSpU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 14:45:20 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2081.outbound.protection.outlook.com [40.107.243.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAEC358DCE
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 11:45:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PhFMts6sQ55QIW1twL3jTgbTgJ4AYDVR0dgMpBc2onw8mk9E91OYmeVu/bCrVTcZ64dQc+ek9b2ODUaBpGuN1rfJmSwMtpxA02ojv5gd9p8f2r7g2MI4/uZD6Y74SvMC5qdC8TAppJff8RNKKOJ/VI9BIL6JP/1ZRzXyVH5Udm4ekOov1Dl2x52Y/DgdTMc8h/YsFwbqMftsXgPAsBoZ7tfEEsCsKOqzARYivQB8QMST7d9Iy42Xd+GlhxxAQK5FWRsBCnaK3M7uYfGzgyc0y0+yf+QJ1ucsepa7lk3nDIgWiLv5OzK9Ozya6kHz+5ismJU3pVBiB8HdQc0tBFfaSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+KBJhLPtShC3UrOTzLsOcLzVnaDG2sLkMWKF1duTsNY=;
 b=KGlSlpdlYzTLZwhLjyf6nxAQ+wRCce8ERn8yL3LG6Hah9XZg4tohbgXB+RqX3Lv09bUwfWyZkWAMBN5218m7HeUZNGtENhgrbT+c4mZeIvOTWeaGazvw7U4wBjQ8/irbBrXhBmuXLltq/6JRlqOtPdnbDc+orY891N/EJhTs9tccEopLxgQA+uZXHbWgts1KKpuXAfW7/ZtEfki40khqLHyfguczssfHKFLWRyywaxu2CZapL0CrqBYw0fgQW083NEGDyNNJd1ogtVSUE6bfBycuYlFOm67GWVEjHzhhdgcQSxSxf1lyCyNGLQ3aDKCZw12JBGEl99n0+Ga+HX/A4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+KBJhLPtShC3UrOTzLsOcLzVnaDG2sLkMWKF1duTsNY=;
 b=thxfTQ1R/Z8WQZOVaO2Uf/dvicQ/XvWlqkBbb8OJt1ehwxWIDs2mWL2VjwEXKCtmsVdJxxIwnzq7V2HA3ae3mSMRTdKe/vLLre/KtGFoh8FkYRyCIsiMW0U+eM8+a3sAS/eeQ2sG33aLWYEkJhCognLjbhvBLnNk31Dh6rjHzRXZml/o2yIk6tLGMfc8H6NlCpgMXdr2T1yFDzD5r14T4R/ieSblYRSLzoHUOBprRTkZbSfgVT0dYMZUjMkdjE4GvshtUvREUPqMqo2hUuhaLfSMzU/AsoCSNo6bBnyMEim/xdz0E3D2LG0dKVlt/LOrCOrTaaUyMZ+kR/X8qlz2Rg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY5PR12MB6429.namprd12.prod.outlook.com (2603:10b6:930:3b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.17; Thu, 8 Sep
 2022 18:45:03 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5612.019; Thu, 8 Sep 2022
 18:45:03 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>
Cc:     Qian Cai <cai@lca.pw>, Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH 2/4] vfio: Move the sanity check of the group to vfio_create_group()
Date:   Thu,  8 Sep 2022 15:44:59 -0300
Message-Id: <2-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com>
In-Reply-To: <0-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR06CA0008.namprd06.prod.outlook.com
 (2603:10b6:208:23d::13) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|CY5PR12MB6429:EE_
X-MS-Office365-Filtering-Correlation-Id: f171af80-0cb6-4d42-3330-08da91ca3d0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hSHj02sMeSU957CsGuzrecRgx7EXQDE4Ya4m+vJyD+iZcjYFwowiQ1cJHLeLUvLiOkVDdKF5TOGhNz9Xu9HJ1QZbTQbBjUIbLfBPjEHzPod+mJ9Zj4lh0RGYpIHJ+Wnt5Prg8gmxRQwqbHdsK4+anQRllf4xZorl93z6OeUcbY1TnKSYY2cO1ocK/4GFywI8XnSiCl7DPu+cCxjrwp7VEnod6kfQbRS/FGJDN30M35CdDmJGSiKB0wLxZFuMT7Bp9JLtFEEPQInggqI6aCu6vDOnA9o6T8xVm9gp9WUQ/VKRFjJ51vkZTL2w0vdSRx5wFzF4LZgXHuL7y5yjU6gYoPggJUpcO6EjYildbJPdk+jss8Pm4kT3GwfH+HL5MEmDW7MPYq3HmAvNajpKPJaiZ6yJxkRS3ylrSHPgm0magAH4h79i9T2lTGBA8VXHL79UTNiCcoVKmJy2HNx3SrntGNqqthfyAk8tG/zlSlDyzkj0S1xSbuEVNc8Mz0emcMOmbnjW/0efTlJGAm+EdDKU9mDxGgHG/etMpbu0k+9QuiCnK5hs2mdliAC6D1SmvaRiHdPFGbXiMp8xsnz0i9VwCmdyutoqz0kMrvpB9eTS0ailgdIHAnh0wkVNA0bJiTZ5BwfbqDX4vmqxZXCEkD0OThJcBVpSHj+VX2o9wnfEUlcxXUeTW+g2l3YnWOqm4pOfp4wUvJN6lPL0wTnUOUSjPtmMA/ia4xolAdGPGd+vZtHwVKWLEINN+7qqQDzNaNU2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(38100700002)(4326008)(66556008)(316002)(8676002)(66476007)(66946007)(110136005)(54906003)(41300700001)(8936002)(83380400001)(7416002)(5660300002)(2906002)(6512007)(186003)(2616005)(6506007)(478600001)(6486002)(36756003)(26005)(86362001)(6666004)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DCE5lnTIgUy/S5OauQ4Pqu+uzLkTa3E25dAE3iWe3SyXJXFzMmGUAJSErksf?=
 =?us-ascii?Q?7SNFnuAAeX7e9GXi40AUkOPT1AR89JphCsckrFspIe4pELo1+a3oUY8dyglg?=
 =?us-ascii?Q?JE4t83GIiuM2WBBTMjLR0bF25nHyDnAFpSKYa3Lqnt0jl5xOSh/nxIHtNtLh?=
 =?us-ascii?Q?y0zvs3HctOVX5bFeX4FqPTsaVOnzekkT/TPIETh49tBj9esnQgnjABrlu+66?=
 =?us-ascii?Q?RC+Lce2sxT2bNzFUEIFPjbM3dcBb4P92hw1nKqTKNRn/D0qXNaWpVDQXwH4n?=
 =?us-ascii?Q?QksQNSOeiU/OAGhWIrCathZc3dranK5VfY7RwaFREG0e2SCLrhcYemarlTtJ?=
 =?us-ascii?Q?QrbVophEuTYRIxUaoTYQVfGPf51A58t1IHf08m98O+wSpIZqelwLGCyv0Bvl?=
 =?us-ascii?Q?ca+uUI3wo/tSbvBYm3agPyxODULYdcGuIt3gpRWCqeM4E1TBycjXtpMLfq7z?=
 =?us-ascii?Q?E+tvAif8DSy1/mc369tpIE7LDkropsBd8IDoTRt85o58DTIlZV/gA2AzDtBy?=
 =?us-ascii?Q?ianmfHgcaOirw95NtcKcSuFYby3M0I46ZcV1Ni7XAHT1ViwtG/sSabGUMr/W?=
 =?us-ascii?Q?Z/4uIFoEnXFSSNlahXpnlhus15MJqhBfVOIeSNX2KHOUZD8WJvW+MVXODO3U?=
 =?us-ascii?Q?RfxT7Rnkwi0boXe98VKSeT9GRVawu6lwavtZomcdxdYOFw8zvOMknih6bXbW?=
 =?us-ascii?Q?2VwzRpXCXCt3Ix+DR52CmjBIZ9oIKXky7J9m9XDU5M/NDQt3HlZ+j2Uy4/z2?=
 =?us-ascii?Q?a8EJ2oNkbfCTysXXyMdTSSNTPPlG7aVx5iSp9eiWnMnfoHZ66b2jy2WjlnJo?=
 =?us-ascii?Q?6dWQmEOO0CBSFIAomkm53NQKgiRdb9vYQbdmUuenKfPcXbBfCFFLaMrcYKDD?=
 =?us-ascii?Q?TLpbUJBBomKyqDuxfGe/7FTLx4eYc9ItfYmyxQ3sg0RYMS+Hp6sLtVL+TrgF?=
 =?us-ascii?Q?tW8cIgvc5rWo/lwieNV/ddi0Q8nAzO8zjiVnFl7IOxahJ5HZU5ehEFCrMZrg?=
 =?us-ascii?Q?dvSKf0ora2c7RvQw/sRsAfwlYpWc/9bC6F2XPZEc3bk3TNUbqoVdv1tmxG4B?=
 =?us-ascii?Q?LMpJ5cAswZ+uZm841DuB52kZ7LMniMfCjE38jDwrk5HVCfZXzanCCFCWWpgk?=
 =?us-ascii?Q?AzxFD2ZX6IMxsu0lyz/AtqFpnVgH57lMZl5w1tVI3350Mi6BpR0nxwMuLkVQ?=
 =?us-ascii?Q?KISp1ZTnkXBCVIuy+/xVDp4ETSnVmsEDq2ns/YffUbodgnOyljXAcwhUbkzJ?=
 =?us-ascii?Q?Gxb4ANbRjV1Dpjw/fUlTwFgQPJ/6twko/tIvh7hYfHPDT/te8++kobSLHhSM?=
 =?us-ascii?Q?x1733/GHacq+OYw1C2LY/6nBNnMFpmXaTrFvZjmoiMDvAol8FF264lbMUpXj?=
 =?us-ascii?Q?pVBUsUEvSXgdujY/ipaflXwWO4fZcJjQyx9PcagPFexYBs6LX+UWhreHJ3z8?=
 =?us-ascii?Q?AVBFGkDHqWqEUS3UJ3a6y9lrr5zk8zmNTMyHZyvQqIOnvOzEM+8DxdMVZZYk?=
 =?us-ascii?Q?ZuQa6WZ+Uvj4Xl6i7zkxWRWzdH2kJpCZTWpZT2RElwH2gG2HhwrKxImLbNfv?=
 =?us-ascii?Q?QWUK+8leNj8LMNYSWL2yX3NLl/sZvbJOGp0u2JNs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f171af80-0cb6-4d42-3330-08da91ca3d0d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 18:45:02.3323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dbDAJ4hxnKmUOctFQKOcg7eBsfV9NWElLXw7VZ+lB0k07QV7Zivv/APGCOTn9ltc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6429
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

__vfio_register_dev() has a bit of code to sanity check if an (existing)
group is not corrupted by having two copies of the same struct device in
it. This should be impossible.

It then has some complicated error unwind to uncreate the group.

Instead check if the existing group is sane at the same time we locate
it. If a bug is found then there is no error unwind, just simply fail
allocation.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c | 79 ++++++++++++++++++----------------------
 1 file changed, 36 insertions(+), 43 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 4ab13808b536e1..ba8b6bed12c7e7 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -306,15 +306,15 @@ static void vfio_container_put(struct vfio_container *container)
  * Group objects - create, release, get, put, search
  */
 static struct vfio_group *
-__vfio_group_get_from_iommu(struct iommu_group *iommu_group)
+vfio_group_find_from_iommu(struct iommu_group *iommu_group)
 {
 	struct vfio_group *group;
 
+	lockdep_assert_held(&vfio.group_lock);
+
 	list_for_each_entry(group, &vfio.group_list, vfio_next) {
-		if (group->iommu_group == iommu_group) {
-			vfio_group_get(group);
+		if (group->iommu_group == iommu_group)
 			return group;
-		}
 	}
 	return NULL;
 }
@@ -365,11 +365,27 @@ static struct vfio_group *vfio_group_alloc(struct iommu_group *iommu_group,
 	return group;
 }
 
+static bool vfio_group_has_device(struct vfio_group *group, struct device *dev)
+{
+	struct vfio_device *device;
+
+	mutex_lock(&group->device_lock);
+	list_for_each_entry(device, &group->device_list, group_next) {
+		if (device->dev == dev) {
+			mutex_unlock(&group->device_lock);
+			return true;
+		}
+	}
+	mutex_unlock(&group->device_lock);
+	return false;
+}
+
 /*
  * Return a struct vfio_group * for the given iommu_group. If no vfio_group
  * already exists then create a new one.
  */
-static struct vfio_group *vfio_get_group(struct iommu_group *iommu_group,
+static struct vfio_group *vfio_get_group(struct device *dev,
+					 struct iommu_group *iommu_group,
 					 enum vfio_group_type type)
 {
 	struct vfio_group *group;
@@ -378,13 +394,20 @@ static struct vfio_group *vfio_get_group(struct iommu_group *iommu_group,
 
 	mutex_lock(&vfio.group_lock);
 
-	ret = __vfio_group_get_from_iommu(iommu_group);
-	if (ret)
-		goto err_unlock;
+	ret = vfio_group_find_from_iommu(iommu_group);
+	if (ret) {
+		if (WARN_ON(vfio_group_has_device(ret, dev))) {
+			ret = ERR_PTR(-EINVAL);
+			goto out_unlock;
+		}
+		/* Found an existing group */
+		vfio_group_get(ret);
+		goto out_unlock;
+	}
 
 	group = ret = vfio_group_alloc(iommu_group, type);
 	if (IS_ERR(ret))
-		goto err_unlock;
+		goto out_unlock;
 
 	err = dev_set_name(&group->dev, "%s%d",
 			   group->type == VFIO_NO_IOMMU ? "noiommu-" : "",
@@ -397,7 +420,7 @@ static struct vfio_group *vfio_get_group(struct iommu_group *iommu_group,
 	err = cdev_device_add(&group->cdev, &group->dev);
 	if (err) {
 		ret = ERR_PTR(err);
-		goto err_unlock;
+		goto out_unlock;
 	}
 
 	list_add(&group->vfio_next, &vfio.group_list);
@@ -407,7 +430,7 @@ static struct vfio_group *vfio_get_group(struct iommu_group *iommu_group,
 
 err_put:
 	put_device(&group->dev);
-err_unlock:
+out_unlock:
 	mutex_unlock(&vfio.group_lock);
 	return ret;
 }
@@ -454,22 +477,6 @@ static bool vfio_device_try_get(struct vfio_device *device)
 	return refcount_inc_not_zero(&device->refcount);
 }
 
-static struct vfio_device *vfio_group_get_device(struct vfio_group *group,
-						 struct device *dev)
-{
-	struct vfio_device *device;
-
-	mutex_lock(&group->device_lock);
-	list_for_each_entry(device, &group->device_list, group_next) {
-		if (device->dev == dev && vfio_device_try_get(device)) {
-			mutex_unlock(&group->device_lock);
-			return device;
-		}
-	}
-	mutex_unlock(&group->device_lock);
-	return NULL;
-}
-
 /*
  * VFIO driver API
  */
@@ -506,7 +513,7 @@ static struct vfio_group *vfio_noiommu_group_alloc(struct device *dev,
 	if (ret)
 		goto out_put_group;
 
-	group = vfio_get_group(iommu_group, type);
+	group = vfio_get_group(dev, iommu_group, type);
 	if (IS_ERR(group)) {
 		ret = PTR_ERR(group);
 		goto out_remove_device;
@@ -556,7 +563,7 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 		return ERR_PTR(-EINVAL);
 	}
 
-	group = vfio_get_group(iommu_group, VFIO_IOMMU);
+	group = vfio_get_group(dev, iommu_group, VFIO_IOMMU);
 
 	/* The vfio_group holds a reference to the iommu_group */
 	iommu_group_put(iommu_group);
@@ -566,8 +573,6 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 static int __vfio_register_dev(struct vfio_device *device,
 		struct vfio_group *group)
 {
-	struct vfio_device *existing_device;
-
 	if (IS_ERR(group))
 		return PTR_ERR(group);
 
@@ -578,18 +583,6 @@ static int __vfio_register_dev(struct vfio_device *device,
 	if (!device->dev_set)
 		vfio_assign_device_set(device, device);
 
-	existing_device = vfio_group_get_device(group, device->dev);
-	if (existing_device) {
-		dev_WARN(device->dev, "Device already exists on group %d\n",
-			 iommu_group_id(group->iommu_group));
-		vfio_device_put(existing_device);
-		if (group->type == VFIO_NO_IOMMU ||
-		    group->type == VFIO_EMULATED_IOMMU)
-			iommu_group_remove_device(device->dev);
-		vfio_group_put(group);
-		return -EBUSY;
-	}
-
 	/* Our reference on group is moved to the device */
 	device->group = group;
 
-- 
2.37.3

