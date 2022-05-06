Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC3851CDD4
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 02:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387515AbiEFA3N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 20:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387520AbiEFA24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 20:28:56 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2047.outbound.protection.outlook.com [40.107.220.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F8ABF4
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 17:25:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=coZ3ZI6ANGftSP/4h7c/0fm4xqH+0mg53t2PPMxHLPDi6nnJQqW1gRi25MV3l2wvHHbE4ctiAjMoGwWPu3i6y2jA++cnHNs0MM7I4ecS2Pjy/vprU9nnAjdQR2p+dLW2iuThcevhZd4EsqPx7GCaut+sBXDjdc0FUombA6XYeSLj6kFCO1RBKxmvSnPM3oFvSRzSh/c4NQx+rR7QDb2dDK4RuLmFuuMB92WNQOGFI+h1cgWds+zZSbb/8pr4iVaImC9Hkmj9F/WHmx21H/2WpE24Jrbty0XNMz8Y1ysaiQxlKXvO9mJfOKisvFKFjOd1H7SjR9Y+932Lsz9DKDv/Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NdVPTI9IgA3QTxqpiN9T+eRXCGDE20rE7hL3H4t26jE=;
 b=L94i0umOz3qfNxeXED9TS7wXpJ7B/mVr/LMwSaLcr6usfXofkEpgB2cTJAOlA3/y2JeS1g1ya2az+yt2dkGVGSDT3VDjB+rRZro2slOLDQEmHIwL2StiHIWpBgP7PSucDNbPM8O9DiSXOvT8QCsvhogr97zDvdnBz/jszXgxOfNWLYbw1bS8GUiOGu9nn7VfCZiBQ2+at/55DJrhiSkorAk014LQssTrPixSojWUwiAyPcW4k8bKkY6clzy03mU6ldwaX/zrPInXbmE8cb0D+VDiDV6QeSgJ/x2nJH2lnR57v0PtSPUYXeTBxYvBYYY7j6pSSQ7T5gdbhQQHGfo7yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NdVPTI9IgA3QTxqpiN9T+eRXCGDE20rE7hL3H4t26jE=;
 b=VYTbcr46YGDuLgPn9egHyh7v8ZCSBdq99QGXN7a42WNZ3XmqxwnN1Zx+xF8+kZVOak893v4U4BJ3CUVcUmSnfLH5fYx8VnXKdGCSnljkUh0gm5vJn11JBQnzbmVy++gsVdw5SubWn3ddHvWSPtsiPo/TKbM8UlzVQ+7r6jYEmnR1MjAng/4pAgic2/KisLsINiQ9clOQVrhIGOlH3N2E+IlzU0xFb1S+pjKHo7ucaeYgUyaeLpdWCIoknz5LrMldcJFR1qIJWPpYehGZuc7i7SlWA6LuKiROhe3JxgsNNEOdCdi58nsM9VsFRgF7gvm4tm+41BH73tyH/Nejdwzb3g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH0PR12MB5025.namprd12.prod.outlook.com (2603:10b6:610:d5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Fri, 6 May
 2022 00:25:10 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.027; Fri, 6 May 2022
 00:25:10 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Xiao Guangrong <guangrong.xiao@linux.intel.com>,
        Jike Song <jike.song@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4/6] vfio: Fully lock struct vfio_group::container
Date:   Thu,  5 May 2022 21:25:04 -0300
Message-Id: <4-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
In-Reply-To: <0-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0043.namprd19.prod.outlook.com
 (2603:10b6:208:19b::20) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83ff7a76-6367-4084-f8da-08da2ef6e078
X-MS-TrafficTypeDiagnostic: CH0PR12MB5025:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB50250F48A5941A5193FB7DFCC2C59@CH0PR12MB5025.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UWYMyJD5Kd2GnPWH3G/gEw8Q52oSVXLcG704fyyvFiSmJ8WvnLkbmOUosC0TznkAeP3KKxFnBfDN9RLVEc2aop+ff17B9VjlWw+YI6dzjfJLWmkk7FYPniHW2FFq/czPL6ScSUrNSNJFAG2wyU0BgEp/+OP/5bgU+H0FJLg8BIfzGdAUdsUYqEEYH1szOy+Inm+GqDUBOibXZ4CjBFytFjKtu2humKUIkbjFENTY28vq8ZvT72+/JWBY8Zbg8nfEEQAo9M8VfyVUal+G6rG/8Id1K13NCco3gCFG0F+2SiXUZqj6NOKw0RjtKUAfxNf12/YNJ2iJc+ZFIWQuxlpiGmE8ZRHICk5X8adPnpTZXEDPNTYo5cXFuDSuDlNMOkhjfgm5zkdO2J0ICr8a1fa7LZDik3RzwBzN9CVBU2ng2TS6Uh1myv59X1QxoeZZDUSugZf8qHbh1TWkn/dlW1J8vig94uRnA4oJCbWW0C/1MkJz8cf1pMCLa+f+t+sM21nwSh/wGABTqjOfBJiLlo9ErpijUEuKlRS4L23NPGgDETuwYb5iIGvB2UQ6aaZjrNu3WSe+ijDUX5tp03db2pCpCeH239ttHotYdJgMT6e1H53RvkN3Tg+NKQke/Z/B88PwQhqK7mYVWAVnuCzoQpoJHSBqfQzMEpWwbCSU6yDzIkeBD7x/CcAnuT3/gx2l0wWK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(54906003)(110136005)(38100700002)(316002)(2616005)(6506007)(66476007)(66556008)(8676002)(4326008)(66946007)(8936002)(2906002)(83380400001)(6666004)(508600001)(36756003)(86362001)(26005)(6512007)(6486002)(5660300002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PwSSqIAdF0HbRyasoZ8fAQt/PdZZT8M6pAwPimcJKc27s1K3TYS4aBPnpKzO?=
 =?us-ascii?Q?0swyaHJI9oPi8NHFncbZ2LS8QMqsdaJn887G726veENCESr6BKe1WdYNp1Uq?=
 =?us-ascii?Q?32LeR/Ws3qxvBoabA/MkTBUGPum+qtlhty5oziXdFCRJnZKXH4b23MNI4/2k?=
 =?us-ascii?Q?mYohBK67vf6AwK71QGAHFF5j7CaH3+0oFlojAmcW8OVcplWcmBaG3RZb7TW2?=
 =?us-ascii?Q?GFRj0FlaQbi2GqD5LJpGF26Y+2mF4//MfhyAYZCiCFo3/jheAGF7oODVdt1H?=
 =?us-ascii?Q?gyHM6kGoveg1ekK0bRutKd980tL29phONCqCu1pd9sREclKRibN04wv7ar8j?=
 =?us-ascii?Q?PkaUkToWVmAHiSqkLhOiTrVXSH+ctTaNZtjJ0uopHDzLSP+jUxeHApLTAlTD?=
 =?us-ascii?Q?Qyvsq5H9V1zp3PW7son48wSkPwO4Bl4QrhNFn7spT1+VJVd11dHnqs1gO3VX?=
 =?us-ascii?Q?D4qr+Z/8ZHRgyKUgOSMBt3kUhKRo1liyEOK6v7F2mTAyXiQEJx4LKuRZO4Zn?=
 =?us-ascii?Q?HvD0rUO4GHSO3LefNyO8hnOpI4wYPGVioHUL0TtRCtYmgPXYYu57pF1BR/Jv?=
 =?us-ascii?Q?/BzUhFfHI5kP0GSUnH6xAR6W5wpqkESYrt24eJC4OsXVIBJkParTCkWzMFr1?=
 =?us-ascii?Q?sX/QkEn7cUfQBYqndI711FzA15NC0wa80xDG1w+80nHN0xy9HGmxEubcQG1u?=
 =?us-ascii?Q?MJMLF2dkmqy2GrIeCR+JCjO4QRADaZJRZGtLgkX9cgXPt8hprcyYYov23BKg?=
 =?us-ascii?Q?11uilGMRRavN2cDsRKArOUjxKaJRtODYOXSDFA2vWxn6PCW9ZfYptfimA22Q?=
 =?us-ascii?Q?yWSv3ZPcsn7wPQMe1iqHboVrBSHaWZYGt2NV1xLYJghPbkcwsIp/nT5a3/U3?=
 =?us-ascii?Q?k3jrtVraeFStOmhoQWyHbknKEq6jypM5bVGjz9j5CkhRfZGoiojV/Pb+DsHw?=
 =?us-ascii?Q?uyxaM9TipVNnO3hZqthCmVQ+dT+OaKmPms+dkVLg7DHjoAitH9LDBzU2wLr/?=
 =?us-ascii?Q?bXpYfW744SeEDnVhZxhhpxqnJs2XroHeieYAL3Uk8iotcmtG7TGev+8qPHJG?=
 =?us-ascii?Q?tgvgrY+kMVcZex1rVXAydVXLD7O74ycnPQ/rQoPYwf21kXFTWf3r/Go/DvqS?=
 =?us-ascii?Q?389Rz1WUBBHfukK37ViTyGgKA58vqvedjryXjCZrHImwXcQYKk+rEK/InT8u?=
 =?us-ascii?Q?sA98d6BPbazj7Z4z4ZbtRrcr6eLi1FhReVNKnjL9L/Dfeu1ag4k3UBENMJgb?=
 =?us-ascii?Q?9nYIsbyeloTPboTbSG6OZKpYy+J+s/lGjYA3aRUSMvmzfBwcz+DU7kBnOBVo?=
 =?us-ascii?Q?ADzsGeLG+OPoof6p8qpPRDZs5To35NSFohrQwClKP0UHadz3oHNjsaRMJdup?=
 =?us-ascii?Q?zZOHWODDrWESWlCQ5r52OqkPxd8PmFWH8bnSKzvIKAZaZP36oS2Z8ls8Dhur?=
 =?us-ascii?Q?LZEPw42gza53DdK2j0JAXJX0YH+3sO4TYrB97ykFB9O3IrXIvAtPEB+3Dv0w?=
 =?us-ascii?Q?3EEr0kGMCDhq3sUvsz59wzgoYMH82sZ+SzmjK4+gq9BQ2FpcIlLZsbiTzc8e?=
 =?us-ascii?Q?40L3aITR7XjV7EO3yvdRFeI0bIFdA6BUpx6b+0AV1YUB3k4ka9/i3zlGZdZ8?=
 =?us-ascii?Q?x3qZImeHedrBMTWrnR8Cb2MUkj+qMgQQjo/Dg8Npw5BIYSdsTCC2WJqI7Mzq?=
 =?us-ascii?Q?tKn7FBTuQIVR/R9Y/6oGkDX4yvGsCQJUtPl6qFPTq05eKxI14L6sohYE1nqH?=
 =?us-ascii?Q?DF2WepKEkg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83ff7a76-6367-4084-f8da-08da2ef6e078
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 00:25:09.0609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IX7eVJh63mT+kQQ5K/1ImJOea32+OLstOcc7kyBSm2MSvpItsE7v6/tUIUNXRso2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5025
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is necessary to avoid various user triggerable races, for instance
racing SET_CONTAINER/UNSET_CONTAINER:

                                  ioctl(VFIO_GROUP_SET_CONTAINER)
ioctl(VFIO_GROUP_UNSET_CONTAINER)
 vfio_group_unset_container
    int users = atomic_cmpxchg(&group->container_users, 1, 0);
    // users == 1 container_users == 0
    __vfio_group_unset_container(group);

                                    vfio_group_set_container()
	                              if (atomic_read(&group->container_users))
				        down_write(&container->group_lock);
				        group->container = container;
				        up_write(&container->group_lock);

      down_write(&container->group_lock);
      group->container = NULL;
      up_write(&container->group_lock);
      vfio_container_put(container);
      /* woops we leaked the original container  */

This can then go on to NULL pointer deref since container == 0 and
container_users == 1.

Wrap all touches of container, except those on a performance path with a
known open device, with the group_rwsem.

The only user of vfio_group_add_container_user() holds the user count for
a simple operation, change it to just hold the group_lock over the
operation and delete vfio_group_add_container_user(). Containers now only
gain a user when a device FD is opened.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 66 +++++++++++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 26 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index d8d14e528ab795..63f7fa872eae60 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -937,6 +937,8 @@ static void __vfio_group_unset_container(struct vfio_group *group)
 	struct vfio_container *container = group->container;
 	struct vfio_iommu_driver *driver;
 
+	lockdep_assert_held_write(&group->group_rwsem);
+
 	down_write(&container->group_lock);
 
 	driver = container->iommu_driver;
@@ -973,6 +975,8 @@ static int vfio_group_unset_container(struct vfio_group *group)
 {
 	int users = atomic_cmpxchg(&group->container_users, 1, 0);
 
+	lockdep_assert_held_write(&group->group_rwsem);
+
 	if (!users)
 		return -EINVAL;
 	if (users != 1)
@@ -991,8 +995,10 @@ static int vfio_group_unset_container(struct vfio_group *group)
  */
 static void vfio_group_try_dissolve_container(struct vfio_group *group)
 {
+	down_write(&group->group_rwsem);
 	if (0 == atomic_dec_if_positive(&group->container_users))
 		__vfio_group_unset_container(group);
+	up_write(&group->group_rwsem);
 }
 
 static int vfio_group_set_container(struct vfio_group *group, int container_fd)
@@ -1002,6 +1008,8 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
 	struct vfio_iommu_driver *driver;
 	int ret = 0;
 
+	lockdep_assert_held_write(&group->group_rwsem);
+
 	if (atomic_read(&group->container_users))
 		return -EINVAL;
 
@@ -1059,23 +1067,6 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
 	return ret;
 }
 
-static int vfio_group_add_container_user(struct vfio_group *group)
-{
-	if (!atomic_inc_not_zero(&group->container_users))
-		return -EINVAL;
-
-	if (group->type == VFIO_NO_IOMMU) {
-		atomic_dec(&group->container_users);
-		return -EPERM;
-	}
-	if (!group->container->iommu_driver) {
-		atomic_dec(&group->container_users);
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 static const struct file_operations vfio_device_fops;
 
 /* true if the vfio_device has open_device() called but not close_device() */
@@ -1088,6 +1079,8 @@ static int vfio_device_assign_container(struct vfio_device *device)
 {
 	struct vfio_group *group = device->group;
 
+	lockdep_assert_held_write(&group->group_rwsem);
+
 	if (0 == atomic_read(&group->container_users) ||
 	    !group->container->iommu_driver)
 		return -EINVAL;
@@ -1109,7 +1102,9 @@ static struct file *vfio_device_open(struct vfio_device *device)
 	struct file *filep;
 	int ret;
 
+	down_write(&device->group->group_rwsem);
 	ret = vfio_device_assign_container(device);
+	up_write(&device->group->group_rwsem);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -1219,11 +1214,13 @@ static long vfio_group_fops_unl_ioctl(struct file *filep,
 
 		status.flags = 0;
 
+		down_read(&group->group_rwsem);
 		if (group->container)
 			status.flags |= VFIO_GROUP_FLAGS_CONTAINER_SET |
 					VFIO_GROUP_FLAGS_VIABLE;
 		else if (!iommu_group_dma_owner_claimed(group->iommu_group))
 			status.flags |= VFIO_GROUP_FLAGS_VIABLE;
+		up_read(&group->group_rwsem);
 
 		if (copy_to_user((void __user *)arg, &status, minsz))
 			return -EFAULT;
@@ -1241,11 +1238,15 @@ static long vfio_group_fops_unl_ioctl(struct file *filep,
 		if (fd < 0)
 			return -EINVAL;
 
+		down_write(&group->group_rwsem);
 		ret = vfio_group_set_container(group, fd);
+		up_write(&group->group_rwsem);
 		break;
 	}
 	case VFIO_GROUP_UNSET_CONTAINER:
+		down_write(&group->group_rwsem);
 		ret = vfio_group_unset_container(group);
+		up_write(&group->group_rwsem);
 		break;
 	case VFIO_GROUP_GET_DEVICE_FD:
 	{
@@ -1731,15 +1732,19 @@ bool vfio_file_enforced_coherent(struct file *file)
 	if (file->f_op != &vfio_group_fops)
 		return true;
 
-	/*
-	 * Since the coherency state is determined only once a container is
-	 * attached the user must do so before they can prove they have
-	 * permission.
-	 */
-	if (vfio_group_add_container_user(group))
-		return true;
-	ret = vfio_ioctl_check_extension(group->container, VFIO_DMA_CC_IOMMU);
-	vfio_group_try_dissolve_container(group);
+	down_read(&group->group_rwsem);
+	if (group->container) {
+		ret = vfio_ioctl_check_extension(group->container,
+						 VFIO_DMA_CC_IOMMU);
+	} else {
+		/*
+		 * Since the coherency state is determined only once a container
+		 * is attached the user must do so before they can prove they
+		 * have permission.
+		 */
+		ret = true;
+	}
+	up_read(&group->group_rwsem);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
@@ -1932,6 +1937,7 @@ int vfio_pin_pages(struct vfio_device *device, unsigned long *user_pfn,
 	if (group->dev_counter > 1)
 		return -EINVAL;
 
+	/* group->container cannot change while a vfio device is open */
 	container = group->container;
 	driver = container->iommu_driver;
 	if (likely(driver && driver->ops->pin_pages))
@@ -1967,6 +1973,7 @@ int vfio_unpin_pages(struct vfio_device *device, unsigned long *user_pfn,
 	if (npage > VFIO_PIN_PAGES_MAX_ENTRIES)
 		return -E2BIG;
 
+	/* group->container cannot change while a vfio device is open */
 	container = device->group->container;
 	driver = container->iommu_driver;
 	if (likely(driver && driver->ops->unpin_pages))
@@ -2006,6 +2013,7 @@ int vfio_dma_rw(struct vfio_device *device, dma_addr_t user_iova, void *data,
 	if (!data || len <= 0 || !vfio_assert_device_open(device))
 		return -EINVAL;
 
+	/* group->container cannot change while a vfio device is open */
 	container = device->group->container;
 	driver = container->iommu_driver;
 
@@ -2026,6 +2034,7 @@ static int vfio_register_iommu_notifier(struct vfio_group *group,
 	struct vfio_iommu_driver *driver;
 	int ret;
 
+	down_read(&group->group_rwsem);
 	container = group->container;
 	driver = container->iommu_driver;
 	if (likely(driver && driver->ops->register_notifier))
@@ -2033,6 +2042,8 @@ static int vfio_register_iommu_notifier(struct vfio_group *group,
 						     events, nb);
 	else
 		ret = -ENOTTY;
+	up_read(&group->group_rwsem);
+
 	return ret;
 }
 
@@ -2043,6 +2054,7 @@ static int vfio_unregister_iommu_notifier(struct vfio_group *group,
 	struct vfio_iommu_driver *driver;
 	int ret;
 
+	down_read(&group->group_rwsem);
 	container = group->container;
 	driver = container->iommu_driver;
 	if (likely(driver && driver->ops->unregister_notifier))
@@ -2050,6 +2062,8 @@ static int vfio_unregister_iommu_notifier(struct vfio_group *group,
 						       nb);
 	else
 		ret = -ENOTTY;
+	up_read(&group->group_rwsem);
+
 	return ret;
 }
 
-- 
2.36.0

