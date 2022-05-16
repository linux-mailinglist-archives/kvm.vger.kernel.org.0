Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 199E052956B
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 01:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240092AbiEPXl4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 19:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238034AbiEPXlb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 19:41:31 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D4219012
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:41:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=de27EuJJhHXDdoVLQhGtdQbAIvg4b3v74XBFfvHJggiG9MKTESL/5b82dSmPnWKelG6UO1pp+4VwGw/Xx1+jJNL/g5KJFkTDdqD1u1yvZsUrkSVamtiTI5gOD9cDVkCVfn0s7kfAiyrVARk7XKB02plClOVu2Xv4A6qSizjNnN5lwTT8OeRHLhv50ocDWZpKC2AgcjjDpPp0LCTurHPZ/8h8u2UOjjJqqyTWgVQkSgM7yclN7KSlDNAFdIx9VaW/KeyKzWJ+K1vUzBceIrNt9oJnfzSo/Gopli/BJQ1EXJJ7x3oI1jcr7I6DFyjiHRIDMvscGJXAkIsQ+RMsRkXERg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JGzE1TM3nM0zn7aouwMxPCfgO7xW+yw3YohiHbpDsGU=;
 b=I5Z4AuXpAs2WaqIH8Ps1lACdYIm01jrZIl9/oKjmLn+ivrNc1XBcJvwjvVXJN5+a7QxpEs1Wh8VqcJwXaOqf19PqHLCz/dINnXgrzgOe+y9hUvlhEs3UFbdGCytE9P77jHnOPcDCI3EKu8yxQrT2tq0FC/E8Gmm4RsaiC+LMm1iYemVfFwKCBUYw5ZLqT5N4nI94N36zjNG5uFKBEJwoo2IU5epTFnZTZ0Treez/qVa855ejeH4kEPj8gMqdNkrHCsMqjnVhxt1p98xsRC2duu89ojdJcYsNfLrKZwfLjfyBjv2RbzddeRerwYB8YwMSmn1ORfDMUR6XVeBVT5NPsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JGzE1TM3nM0zn7aouwMxPCfgO7xW+yw3YohiHbpDsGU=;
 b=YrCxQLSRX1RmG/qcAre4GUDjTOmbGkJR+GYvsNm5zgXRMPKqe1Ya6QZInCMdh1ZsHjBFE6Wz2lvGWweIpTnDvw1kJXZD33hsRRMDoNxKtCp9VosFRytn7vpOqmiFf65/Syd0VaDKoQmmlY+9Bw/Z3VcmFuQvWGG1phUx8p55NoAWT5J16yUI5A7Vl13hTt5civNWv/jP9pkZ5wTmdsye8Hx+2rrzFCvK0OTNJxrIxvOpkxpaDwWh2NTuC4+5Tg85JyPhSbZf0gCKHEnyZZZHVrCbJwkS/2a6IHAbJ5ABnKs39WyuvHFASNFzbSPnEU56EmnQaJVrwVhjFWVMgtNBgA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH2PR12MB3832.namprd12.prod.outlook.com (2603:10b6:610:24::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Mon, 16 May
 2022 23:41:26 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 23:41:26 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Xiao Guangrong <guangrong.xiao@linux.intel.com>,
        Jike Song <jike.song@intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Subject: [PATCH v2 4/6] vfio: Fully lock struct vfio_group::container
Date:   Mon, 16 May 2022 20:41:20 -0300
Message-Id: <4-v2-d035a1842d81+1bf-vfio_group_locking_jgg@nvidia.com>
In-Reply-To: <0-v2-d035a1842d81+1bf-vfio_group_locking_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0062.namprd16.prod.outlook.com
 (2603:10b6:208:234::31) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1237868-bb7d-416c-94d3-08da37959633
X-MS-TrafficTypeDiagnostic: CH2PR12MB3832:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB3832D0BAF6EBE4D7DB0A5858C2CF9@CH2PR12MB3832.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6f6lEEB+gE9POXLkrsfE3CKne6bm5Eb/dJjWmak6aSt8McX46WGgStMgl9ITGHglC+9SL02SQCpNqVUdY6r9i0g6oJsUr50YeIGN7ZamTHPiQ5QbLRvvw6Hv4icUMipiDpdtQY0Vn0YU0mRoJKRXLvTwElxNDLLl8yS26bgNGRK0QmOZkygOe5vID7pQoa+xMqAxX/qRxiCZPV7CMgoiWms1KzIIGA6T+tUEBe7wPN5j9DSLSizgvA5cE7Qp+63KGoXtZU13pJiTo9TYjx3IwIxOYtX327ERzYK6RYI/aNgOkSKnHSnen7LMsoT9G7NyGVRVWhAmIbDa12SK3Yyde8wM9lzqdJlj8MVGpzAy9eS/AJcf2GMHFt0N6dbkWzChaB3H3jWxwb7KnV2GYPII77ucckMAcLkSenzGTkN7yiDcTEbVuLw/uMMrpEtrcISAYk9V3e/uPkmmHsU8FTdi/7gUBOuYDizCX2f+GC/KFB+HUTCr5LaMHl54ARzb6SUcvRNRKmZmBi/LrCPoTV0p75vsFaI2AwtiCdVM5FCxiCZaI/5STJyU+dd+56qRY17MBCED5hC92RmPk+IhOWmUwHZ5AqtaRuPWfbNvyeCEqZx6ALPOLcdpRTm2Stzq62poF5w+GdwavZDgO/MrymZKhTDIMc7A/x/nP7TKCQWXOaEhNGEDJVRGbwkvpXeNyO17sfqiMB5UcNi+DLewTYk1CA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(6486002)(5660300002)(66946007)(110136005)(54906003)(316002)(66556008)(66476007)(2906002)(8936002)(4326008)(6506007)(86362001)(107886003)(26005)(2616005)(6512007)(36756003)(83380400001)(186003)(8676002)(6666004)(38100700002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VQN3PkepOush2H3wPLtMNJv3AcVWp8wYo3CHosmkvSZ5TRKdvFvdBDnfJJck?=
 =?us-ascii?Q?OVb2KY0n+lShdTrMzn/+xSo0ag+778OHRr/KcJ/6YfSOiMCOWPiIZxKSndxe?=
 =?us-ascii?Q?jNUaKskCrllv7Z1L/Bec47AbAZGZnh24SGdtiMaLMdOqZ8oXGCXhg0qQlO18?=
 =?us-ascii?Q?BJAS2ICQrPn59AmuNeFSoeZ21YR9TPNBUZPLYytu5GbpaZW6MICYgeEmLSwD?=
 =?us-ascii?Q?wQzWeravuVnqIngSBdxVdBNp3yemzw/AqmINZjencO5T/e+AseXkNOon7/Nf?=
 =?us-ascii?Q?+UgH5+j24keodODrT9uC+HhKgzar7yT+7LPC/A8zE2IfTZE+XtLm4PqAVy3H?=
 =?us-ascii?Q?M5NCBeF7sLMvOFATswgdGYoTlsO1KX4ox1fMI6K/fcY3nx90dMHdC81U7Rm7?=
 =?us-ascii?Q?ojjv+S3eJt4SYezGBYhj8r6mvtTjxT8Fp+B0sRo79lPh9QNU2mj3F8nxqmtL?=
 =?us-ascii?Q?efNjoerB3SxVj8DSRKCTKUbk9qr7+nmRVgFubidRb5EfqgJ7X3neFUG3sCSR?=
 =?us-ascii?Q?WLFO6uKk7j2ynjy3HDdRCw31fXxGdPdqYb/b+34X9q1bOjmj57h2BG41iAR1?=
 =?us-ascii?Q?XUpkDa/lTEmzz6RxRGWGAuJ7aw7Z55hW+CuXMP2AyaNBL0w6Jgy3QgNOzXzx?=
 =?us-ascii?Q?RtGuXiRQWVuk9HSiirGTl8QRQ89K509rURCfxSiHah707CoUG6Oacj9K4N5x?=
 =?us-ascii?Q?+M3+11+ozeLyu2QCRjx4DnJdoQqK5RfnqP7ipsJx64+cjD0vw0e5f8DprzmZ?=
 =?us-ascii?Q?Yl1iNLKKPii6yxdq4l48SCCPjEWBfzueWfIfYWc5Wqi8EgiDidUw7bTYIvs9?=
 =?us-ascii?Q?PTUXve1Ig56vRvR9rDF86kzXDhwL71hSQ3CiQD4sQyxmpGwediTUdPw9Op5Z?=
 =?us-ascii?Q?Glr0fety7RZTIq/hnVu7n0uOpsy9fczfTajGtApz6hm76Z/RcNKzPU5iLZLK?=
 =?us-ascii?Q?W3FYEJp7XYqSstMB+7NZnXcjoDkxsOYB+m5pMUUoxNxc1Kl+3b6vh+v2Z1nz?=
 =?us-ascii?Q?uwovwHmQdcWEl88xv92l1VBLZWCUIl85IRWNT7heYhbii7K+moX7nKQuBDfu?=
 =?us-ascii?Q?draTJZ0e+yeZikniZrzI5owoldtpZpIuqzEHnGS3f8iFmJhgGQN19fyCW0EZ?=
 =?us-ascii?Q?NqSgF25Dbn7PmA89W7khs0UQQVNADozS0R6sAR2KgG1FV046ufvcz+gNeJHb?=
 =?us-ascii?Q?k9AwOYIHiivt1HUpyfZWztYDL8GQMbXOFdLxHbPtX8WPVEDvzbCdaKsR1Spc?=
 =?us-ascii?Q?CF2TSkNMir6QPiYysj4xYFNDdxAKdC7BYBi8/M6TjRWzekb5w2clX8QTa6Lm?=
 =?us-ascii?Q?Pg2WdORadFGE7UyUvYrtAiCCNOWINtPzOJKRHyIvjtOR0SjrEiTUT/ur/N2j?=
 =?us-ascii?Q?fKXmjDek1DO6Zz0NGnFq2vFEqyxy+mmcgvk3QFIe4B8XRYL1z58TgMw6N+HQ?=
 =?us-ascii?Q?VWm7GtuJgMYlUPb7zpYjdbnTNG82oQnrdQQA1URKZW7hYTk/TO+HBFhTBy/b?=
 =?us-ascii?Q?U9HM2JHIpu2HY9SdsCMEIJ0BsJLMdUy/FlxV/diVwQG3aYtprpKV1iW8cOyJ?=
 =?us-ascii?Q?cb5fxbA01v4ukX813KbVyAy07p9iBHt/O57/b0UiJcT5ykZSAPTkpZw2RyH3?=
 =?us-ascii?Q?SJ8ZWtSzyoDgBOkZQJTP1lroO0fRv2dZe4lr4fx75E444AIR7G0BbAhl0XOQ?=
 =?us-ascii?Q?h21nZPD/XwYoahoBqxXgum89pUlI4wlZ8gxx6Y+LC6KIjQT0I649iE3mVRLt?=
 =?us-ascii?Q?R6NH8HU64A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1237868-bb7d-416c-94d3-08da37959633
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 23:41:23.7526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9T5Ue4HEjLV+dGzTxedzXcXeV+dj2V4G6g666CqP534mhcG8vElawTrTZm55fvRy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3832
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
      container = group->container;
                                    vfio_group_set_container()
	                              if (!atomic_read(&group->container_users))
				        down_write(&container->group_lock);
				        group->container = container;
				        up_write(&container->group_lock);

      down_write(&container->group_lock);
      group->container = NULL;
      up_write(&container->group_lock);
      vfio_container_put(container);
      /* woops we lost/leaked the new container  */

This can then go on to NULL pointer deref since container == 0 and
container_users == 1.

Wrap all touches of container, except those on a performance path with a
known open device, with the group_rwsem.

The only user of vfio_group_add_container_user() holds the user count for
a simple operation, change it to just hold the group_lock over the
operation and delete vfio_group_add_container_user(). Containers now only
gain a user when a device FD is opened.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 66 +++++++++++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 26 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 21db0e8d0d4004..81330c8ca7fea8 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -918,6 +918,8 @@ static void __vfio_group_unset_container(struct vfio_group *group)
 	struct vfio_container *container = group->container;
 	struct vfio_iommu_driver *driver;
 
+	lockdep_assert_held_write(&group->group_rwsem);
+
 	down_write(&container->group_lock);
 
 	driver = container->iommu_driver;
@@ -953,6 +955,8 @@ static int vfio_group_unset_container(struct vfio_group *group)
 {
 	int users = atomic_cmpxchg(&group->container_users, 1, 0);
 
+	lockdep_assert_held_write(&group->group_rwsem);
+
 	if (!users)
 		return -EINVAL;
 	if (users != 1)
@@ -971,8 +975,10 @@ static int vfio_group_unset_container(struct vfio_group *group)
  */
 static void vfio_group_try_dissolve_container(struct vfio_group *group)
 {
+	down_write(&group->group_rwsem);
 	if (0 == atomic_dec_if_positive(&group->container_users))
 		__vfio_group_unset_container(group);
+	up_write(&group->group_rwsem);
 }
 
 static int vfio_group_set_container(struct vfio_group *group, int container_fd)
@@ -982,6 +988,8 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
 	struct vfio_iommu_driver *driver;
 	int ret = 0;
 
+	lockdep_assert_held_write(&group->group_rwsem);
+
 	if (atomic_read(&group->container_users))
 		return -EINVAL;
 
@@ -1039,23 +1047,6 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
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
@@ -1068,6 +1059,8 @@ static int vfio_device_assign_container(struct vfio_device *device)
 {
 	struct vfio_group *group = device->group;
 
+	lockdep_assert_held_write(&group->group_rwsem);
+
 	if (0 == atomic_read(&group->container_users) ||
 	    !group->container->iommu_driver)
 		return -EINVAL;
@@ -1084,7 +1077,9 @@ static struct file *vfio_device_open(struct vfio_device *device)
 	struct file *filep;
 	int ret;
 
+	down_write(&device->group->group_rwsem);
 	ret = vfio_device_assign_container(device);
+	up_write(&device->group->group_rwsem);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -1197,11 +1192,13 @@ static long vfio_group_fops_unl_ioctl(struct file *filep,
 
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
@@ -1219,11 +1216,15 @@ static long vfio_group_fops_unl_ioctl(struct file *filep,
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
@@ -1709,15 +1710,19 @@ bool vfio_file_enforced_coherent(struct file *file)
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
@@ -1910,6 +1915,7 @@ int vfio_pin_pages(struct vfio_device *device, unsigned long *user_pfn,
 	if (group->dev_counter > 1)
 		return -EINVAL;
 
+	/* group->container cannot change while a vfio device is open */
 	container = group->container;
 	driver = container->iommu_driver;
 	if (likely(driver && driver->ops->pin_pages))
@@ -1945,6 +1951,7 @@ int vfio_unpin_pages(struct vfio_device *device, unsigned long *user_pfn,
 	if (npage > VFIO_PIN_PAGES_MAX_ENTRIES)
 		return -E2BIG;
 
+	/* group->container cannot change while a vfio device is open */
 	container = device->group->container;
 	driver = container->iommu_driver;
 	if (likely(driver && driver->ops->unpin_pages))
@@ -1984,6 +1991,7 @@ int vfio_dma_rw(struct vfio_device *device, dma_addr_t user_iova, void *data,
 	if (!data || len <= 0 || !vfio_assert_device_open(device))
 		return -EINVAL;
 
+	/* group->container cannot change while a vfio device is open */
 	container = device->group->container;
 	driver = container->iommu_driver;
 
@@ -2004,6 +2012,7 @@ static int vfio_register_iommu_notifier(struct vfio_group *group,
 	struct vfio_iommu_driver *driver;
 	int ret;
 
+	down_read(&group->group_rwsem);
 	container = group->container;
 	driver = container->iommu_driver;
 	if (likely(driver && driver->ops->register_notifier))
@@ -2011,6 +2020,8 @@ static int vfio_register_iommu_notifier(struct vfio_group *group,
 						     events, nb);
 	else
 		ret = -ENOTTY;
+	up_read(&group->group_rwsem);
+
 	return ret;
 }
 
@@ -2021,6 +2032,7 @@ static int vfio_unregister_iommu_notifier(struct vfio_group *group,
 	struct vfio_iommu_driver *driver;
 	int ret;
 
+	down_read(&group->group_rwsem);
 	container = group->container;
 	driver = container->iommu_driver;
 	if (likely(driver && driver->ops->unregister_notifier))
@@ -2028,6 +2040,8 @@ static int vfio_unregister_iommu_notifier(struct vfio_group *group,
 						       nb);
 	else
 		ret = -ENOTTY;
+	up_read(&group->group_rwsem);
+
 	return ret;
 }
 
-- 
2.36.0

