Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A933B529568
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 01:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349074AbiEPXln (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 19:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349319AbiEPXl2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 19:41:28 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6B218E26
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:41:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gUXLsh5vEUpymqehdzBoqm3zF27TKWURuHDcU+dHcEvWM6fuxVhyGxZFO0iOjxGZDFhw79KWBjBqOb3iI8rxWPnoPsj2mXvSJCZP5U93tAiFSsHRSMcQTjOPQe6W3yr6vD994zl3Ef7EJj4ghwZBIrICDoYabfJbu9SgosWBCdN0Kl7+fFDDE085UlJXVL2P1eWw0fjGQ1sJCRyaLlwh3P5m+aqMmrePRty3XxAQpjPvhZo/gosHvv5hW/nmDcMXVnePOJqgZhghNZ7lr0BaGyqbd5zlYA74mkgNWXd0FKGUja1IJ2Qqrf3DCg94djxe4xaxU2Fb4yWi0GuJPKl7sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hf61ZOBm73II/BsjbZWIsZo9oKL0cfnPyZYtaD1mtKo=;
 b=mufQ3CG7xOGxlfl6bZW+X/PLtXqGpI3s2/vGiIR1Ym9V1g/Jg9J1smB9yzKeVPV6iKpzLwGkHxzbHb2abMIntmsNtycMa1VUNllr3DrY88n+cubjqoPfQWWIJrmsAOgqWMy6nUaE7n2aSLU5v13StLfsvhOS37Y/GOodIa7ZHfyg6Uv8PuEQu+7Nnw17eOBXRtdW10RBAlz53h/ptuT8zmiXMBZqvzdc0ENJP8KCuAahINISZ933ak00LUrm1luSy5/oZL/YXGzHRBcuE54eoHEA5JIg4CUTPftFR4xm61uzJmZ4xrQardl9qXi3OEn2QquEqfVsC4yadvpaXGhI3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hf61ZOBm73II/BsjbZWIsZo9oKL0cfnPyZYtaD1mtKo=;
 b=GZjv5qK2Fy9+fRUrJY812Hpx5Fozsp1eCDfgw7fRL4ntJnFzrgkLBKwiwEEISag7DECPktVT6Q2EGAwCASoBdFJfqY85PzTKTjSPLrg29IyM3EhEl7Q1eLm2Y7GnJPpdCbHXA8m3p8U6IAfxTRftllK3Qz5iOEDIRRSBHLdslb+nmPC7zGgrz9v4xcq0LdV6j+OM7BNoXoMFZpj6IyXgiaEGLIMbgGnJnr8ptkUpqmyvh0usNHGxfxKK3+JCHhVMj6hIiPqTBaKtL3hIeCCyW2CjLIjleyqZCnYuHzOdhUrpYGQwc/1vKClv9IORnhNfOmWbJ3UbYBlBvdJekx1b0Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BYAPR12MB3319.namprd12.prod.outlook.com (2603:10b6:a03:dc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Mon, 16 May
 2022 23:41:25 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 23:41:25 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Xiao Guangrong <guangrong.xiao@linux.intel.com>,
        Jike Song <jike.song@intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Subject: [PATCH v2 5/6] vfio: Simplify the life cycle of the group FD
Date:   Mon, 16 May 2022 20:41:21 -0300
Message-Id: <5-v2-d035a1842d81+1bf-vfio_group_locking_jgg@nvidia.com>
In-Reply-To: <0-v2-d035a1842d81+1bf-vfio_group_locking_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0050.namprd16.prod.outlook.com
 (2603:10b6:208:234::19) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b749d10c-5e6e-425a-7100-08da3795960d
X-MS-TrafficTypeDiagnostic: BYAPR12MB3319:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3319852A7258CF59D9D06A52C2CF9@BYAPR12MB3319.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7nyGTEV0ftdIgDDkJbsXqeyjX2DfSmvR6TjP7dG4x55eo2x5RNVSXwQIfvhVoaZx/ImxSFrJD5FoMa4wBBYhmHfztbSiy0vOht/wlhPj+RSlpc4l3NKU1BePU4UBo2dHqm+LsK+A990kryUXAkXmTcBaRogxR4YxL+jDO+C3huEtUPUgtmLVT302hS6J5SzmQE7IhsM90NAC5uWP+G/RAeoBgWdBdmt/l7Qt44mkIKKFltJX+pdBq4hhFU25XiGyKv4/gIkk4ozazY26qKPLPh9Xp4VLKUoyLdPZBwc/3V656DAqWysbW7eOaUVA+burKwvZr5MJIUpOcMq0RJusW3lX3sX3tkYSnHC3UZ3bWNVBECjWfmNHfug7mTz4GWMiNKCQ/O1mDFtGYDV3ks2R7xMP1BOv8sCvhpUL3zD/b1ogzVlXxrr3Dbj5CptV12+D+4Y8kyHXw+nRvI473ND0QepKMYPKxITNzDqOm2nEDjR3/Bp6ZaeJY/M0G+U5HpbaG7EAB91axnGT4PEB1DDO3Acxa0kMXuBhj+ogUc+tnMbX6CAgg17eFqnXUHxKhUaN6PAbzyXDpEmgrnJCM1EOcZqWODgpp4Om0/HPsVKRNn8m58hmZPKDyf1UXjV+8GKDRArIYVys+PyiLKP9EhOrjF4474KcLGIXdSvGTL5pL4Sugq71yQtpvPrMazyFKw/+pdJPp/GX5mVU5zzust0VTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(66946007)(66556008)(8936002)(4326008)(8676002)(66476007)(86362001)(508600001)(6486002)(186003)(26005)(6506007)(36756003)(2616005)(107886003)(2906002)(54906003)(6666004)(38100700002)(83380400001)(6512007)(110136005)(316002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eIJzr6EYjoTPeY+PW4J4mob2euBud6rizdOXZEUXKhVVxMFhSWDj5wdIE0En?=
 =?us-ascii?Q?WMtA5FD03x5ELhjqUIiBalIlA8ujBqVhq2bPsNyb6/6uy/HqIEVcqx3Fk6qW?=
 =?us-ascii?Q?BPPYZU4nL7w6YADCjrwEmq2fcmo9ff5JsBna+x/ug+9yGMJyXHjl8fQ86XB7?=
 =?us-ascii?Q?2FLfccEGZLarkj8BYPZWTH6hkVqyqQ1okcrPPztaQA6XeSHktpoy5vLkXTWs?=
 =?us-ascii?Q?ghHptUZAZiX2j81jLOhYTz0YOzH5v3lyGF2IIz3N7xMtqM57AkIlxXlXpRzY?=
 =?us-ascii?Q?X5XTLKgsSSGevGquuDK2zW8GrbjsiUkJ2hLIjITW5WY5+O7mHfya6kdJFJHg?=
 =?us-ascii?Q?bFT4NrcLyThgBP3jO/fFKxwynm3P663mE/wgubAYsASQOGsjdfaJ2agcZJ/j?=
 =?us-ascii?Q?B9PNS5CMJPEAntSn/hzAc4Aa2iOWRqtSKI5zpMi75P7T8GNXo3JOv+n567yd?=
 =?us-ascii?Q?9UmhwYiJoeOHBJTyiQZTmlwDpd1bEt2ZD+niBDrcaoCFnH4aoaLM0hzqga8h?=
 =?us-ascii?Q?9NH9DOxW9U1acn1+l84jJbG8fzb6/l1cjb9zDirStzGyPXIjX3fDolGxJYVU?=
 =?us-ascii?Q?5hVw7tcp+xY5RTXKbIZd0Ht4oMzbUVFL27C7ystM7sf+osr+kIj4F1PEYoSw?=
 =?us-ascii?Q?ESaEwrPDcVW4oHYD2nntNb9ICUmdsaldjQO01TkTwl2yCN7/DW/vfxlzhBma?=
 =?us-ascii?Q?1r88MwUxGflN4rFlj3ehuMk0gBfzc8+sBV7TUHSvAuHvXTHt50OAmtLcd8B3?=
 =?us-ascii?Q?WSV2uBYzwODMHjs+uDlW4xONwIqX01D80GqGScBpRNf7YaGHPiAwg1uz9wcX?=
 =?us-ascii?Q?AoC2BcQXbP1ik98NXlmgpW59DidVd3A/L0BGdiXThtAbI59ly/QgXR6QhEdi?=
 =?us-ascii?Q?uggIc4lM2R/mMyU0uXYn4PtHII0lS6U5pHJ6PtNZmsPckCw+gStHqOVTg6Au?=
 =?us-ascii?Q?+8aHKzLk/71s3ncHeHG09sIPm1RJ6S+xEnz6mD/9C/bnlr4H7nNyaU6JFsy3?=
 =?us-ascii?Q?4tL5OLixH06rNme5hH4ajIKfXzpro749BQXeP545rvfZPUamte0LmH5rPt99?=
 =?us-ascii?Q?JbQSkAFCx9ojydnqbt/Uu+abKVDR4gjPNNO1tZ0HnKuwAx+k+D68DyXAHH1X?=
 =?us-ascii?Q?pj8GBMJfDpGZnXe/NWOJZbcPNfjl+VaCXzfxHAzX5e/MRzRwZcO+UQ6owh2k?=
 =?us-ascii?Q?5Jsvvefj17/OycRRo91wbEcVvsPwv6oUD4EmCN/wX2i5BrUiL085Wrx2Ocq0?=
 =?us-ascii?Q?K1L6SxmDjkg/qKyCkoj6fU59T8Vzczvv4RD7AEY3SxCe/lUzoVipwxo20/nL?=
 =?us-ascii?Q?h+Hxu2bvjx3Wiq9IJoxbvx24/KzuQBLkhNtQohUa4ujlVUest+O8HuH7GwYv?=
 =?us-ascii?Q?Fu9Lo+EySw0ItnMtbfWSiNwNDhChKni0XX2jhlvXVPMo917zd6geFxpihtiy?=
 =?us-ascii?Q?fbMSx0RiI1fwbthsQYfq+/qxkUDg95VWoK2vZHIZ1+0qEzpaM4YArKRy3WfZ?=
 =?us-ascii?Q?4YRpqNTazVTLnI2mNgQAPfpilXoirF7m6GMfRgRGm181duWAXxNMd7jm+6QT?=
 =?us-ascii?Q?IE+yibBr358mdV2JYWmnCadsJG1zEk8iT5HBppMpquRG7OfUpSywstITH2cH?=
 =?us-ascii?Q?VYlb1RUqfuF3mp9qB+xoXo8cGpnjWzNSOxILXqnFNUwYV8VnFHvwoRgil1Ae?=
 =?us-ascii?Q?frWelOSShI3/J+j1+8+SCukGJ2cgpbMfj+iW4fZXI/kSDX+QFoXm4atzhNz+?=
 =?us-ascii?Q?IgMV67k5Tw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b749d10c-5e6e-425a-7100-08da3795960d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 23:41:23.5026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GC1wv0G34fiMmdGC7HYLrFGMeaJ+hzcqSeg0tvZ7fLvx+RT+sAK/Qbi1n10Ovgpb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3319
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Once userspace opens a group FD it is prevented from opening another
instance of that same group FD until all the prior group FDs and users of
the container are done.

The first is done trivially by checking the group->opened during group FD
open.

However, things get a little weird if userspace creates a device FD and
then closes the group FD. The group FD still cannot be re-opened, but this
time it is because the group->container is still set and container_users
is elevated by the device FD.

Due to this mismatched lifecycle we have the
vfio_group_try_dissolve_container() which tries to auto-free a container
after the group FD is closed but the device FD remains open.

Instead have the device FD hold onto a reference to the single group
FD. This directly prevents vfio_group_fops_release() from being called
when any device FD exists and makes the lifecycle model more
understandable.

vfio_group_try_dissolve_container() is removed as the only place a
container is auto-deleted is during vfio_group_fops_release(). At this
point the container_users is either 1 or 0 since all device FDs must be
closed.

Change group->opened to group->opened_file which points to the single
struct file * that is open for the group. If the group->open_file is
NULL then group->container == NULL.

If all device FDs have closed then the group's notifier list must be
empty.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 52 +++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 28 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 81330c8ca7fea8..149c25840130f9 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -73,11 +73,11 @@ struct vfio_group {
 	struct mutex			device_lock;
 	struct list_head		vfio_next;
 	struct list_head		container_next;
-	bool				opened;
 	enum vfio_group_type		type;
 	unsigned int			dev_counter;
 	struct rw_semaphore		group_rwsem;
 	struct kvm			*kvm;
+	struct file			*opened_file;
 	struct blocking_notifier_head	notifier;
 };
 
@@ -967,20 +967,6 @@ static int vfio_group_unset_container(struct vfio_group *group)
 	return 0;
 }
 
-/*
- * When removing container users, anything that removes the last user
- * implicitly removes the group from the container.  That is, if the
- * group file descriptor is closed, as well as any device file descriptors,
- * the group is free.
- */
-static void vfio_group_try_dissolve_container(struct vfio_group *group)
-{
-	down_write(&group->group_rwsem);
-	if (0 == atomic_dec_if_positive(&group->container_users))
-		__vfio_group_unset_container(group);
-	up_write(&group->group_rwsem);
-}
-
 static int vfio_group_set_container(struct vfio_group *group, int container_fd)
 {
 	struct fd f;
@@ -1068,10 +1054,19 @@ static int vfio_device_assign_container(struct vfio_device *device)
 	if (group->type == VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO))
 		return -EPERM;
 
+	get_file(group->opened_file);
 	atomic_inc(&group->container_users);
 	return 0;
 }
 
+static void vfio_device_unassign_container(struct vfio_device *device)
+{
+	down_write(&device->group->group_rwsem);
+	atomic_dec(&device->group->container_users);
+	fput(device->group->opened_file);
+	up_write(&device->group->group_rwsem);
+}
+
 static struct file *vfio_device_open(struct vfio_device *device)
 {
 	struct file *filep;
@@ -1133,7 +1128,7 @@ static struct file *vfio_device_open(struct vfio_device *device)
 	mutex_unlock(&device->dev_set->lock);
 	module_put(device->dev->driver->owner);
 err_unassign_container:
-	vfio_group_try_dissolve_container(device->group);
+	vfio_device_unassign_container(device);
 	return ERR_PTR(ret);
 }
 
@@ -1264,18 +1259,12 @@ static int vfio_group_fops_open(struct inode *inode, struct file *filep)
 
 	/*
 	 * Do we need multiple instances of the group open?  Seems not.
-	 * Is something still in use from a previous open?
 	 */
-	if (group->opened || group->container) {
+	if (group->opened_file) {
 		ret = -EBUSY;
 		goto err_put;
 	}
-	group->opened = true;
-
-	/* Warn if previous user didn't cleanup and re-init to drop them */
-	if (WARN_ON(group->notifier.head))
-		BLOCKING_INIT_NOTIFIER_HEAD(&group->notifier);
-
+	group->opened_file = filep;
 	filep->private_data = group;
 
 	up_write(&group->group_rwsem);
@@ -1293,10 +1282,17 @@ static int vfio_group_fops_release(struct inode *inode, struct file *filep)
 
 	filep->private_data = NULL;
 
-	vfio_group_try_dissolve_container(group);
-
 	down_write(&group->group_rwsem);
-	group->opened = false;
+	/*
+	 * Device FDs hold a group file reference, therefore the group release
+	 * is only called when there are no open devices.
+	 */
+	WARN_ON(group->notifier.head);
+	if (group->container) {
+		WARN_ON(atomic_read(&group->container_users) != 1);
+		__vfio_group_unset_container(group);
+	}
+	group->opened_file = NULL;
 	up_write(&group->group_rwsem);
 
 	vfio_group_put(group);
@@ -1328,7 +1324,7 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 
 	module_put(device->dev->driver->owner);
 
-	vfio_group_try_dissolve_container(device->group);
+	vfio_device_unassign_container(device);
 
 	vfio_device_put(device);
 
-- 
2.36.0

