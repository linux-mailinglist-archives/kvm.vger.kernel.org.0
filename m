Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90BFF51CDCF
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 02:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387533AbiEFA3J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 20:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243846AbiEFA2w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 20:28:52 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2047.outbound.protection.outlook.com [40.107.220.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203985DA71
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 17:25:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e2FdKgMQLiyCAtQBzNQxv6Ub3SQK8ffDKnAq4eWN7tnTmKj/2OgXQoeE6KGbcXDKOBz/mSQqMdjviUxGGfm7edojL/JvxthfguNY69QxoV5nMi/Jb82lBL7BzB+uSdanGVI5YynDybO0ATnh27FgtoOrq15lUxFSR/eZZuFy25N3VjcpFCcKA+3B5c3uSF2bMGeVZGV8/eQI0jlNPAwo9zDWd0zfgUqDcCH/vh35m0ddaFOd3JnDn4vWYedKmvzZuoJ6giacUjrX4cxMgVOYmEiyxQyQqTAibsKWVcQls7lsJAJwgxMkiHX9taCM/cUw8/xvhantabYRj9I866drzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8TqFLzkyC0P1sVJfswMKrYuHWw3fxAmaQyEyMLkTrzw=;
 b=Yei2jE1AoA7hoEWUzm5vzcjxosnKhIQmhpaTk1ojjTBiotgpZZi7psc79bSZOFr/hlHlwn+sEznZddv1rLulwGcovLHwQdXw9uGS94tVplSRxXxFvorItMinNbRXjVgYfNeU6n7+1zQHm/U4R9r7Dqs/d2LxERcStMPry+daDc1gMeeY8Ql8CfGNiM2NW9axfZEVSSDsbHFtUcoP8xwFrKoz9nzvOwHFl5R1/0Jd7mc4RWvAKP46YCMAtW07s/1hEAXCyXFeO6cWJ8Zl2jlA6VhTOaCsoLyWCIVY7hEPE57DFgP4GbHdFwWGfDIsFqZS6GPmTy9A0dS+XyEEnxC4kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8TqFLzkyC0P1sVJfswMKrYuHWw3fxAmaQyEyMLkTrzw=;
 b=T/nsM5TeO8O+ypub7pj7jRXmc+z3kkESx6AOVp3JJ3aZW2x7ofEjP9iwn1TLo75QbtSMOlzIG0DX1EC3DzxX24i4lNxdJldC3twG2tFRP1VW2XwSVvR+MmXomMH1KBUkj+QrcaFfjt3SFrqzo0r7ZchyoZq2s53DY2knDMXIZL0o/Uvswt/enW8xlU55EZgUR5/zdVD03HSOCsR5wkSqEDHdG43C5XbkMNxyvjaL+zB0eaal/QsQi5MbRgBg2j6+b1WVA6bKVB4tnlCD6V05WUtTfYkqQ3OTt4D8z4va/qvX+24RTluMSscpLGhb5LyYAIy1XkON8f41Ze6B9A3x/w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH0PR12MB5025.namprd12.prod.outlook.com (2603:10b6:610:d5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Fri, 6 May
 2022 00:25:08 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.027; Fri, 6 May 2022
 00:25:08 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Xiao Guangrong <guangrong.xiao@linux.intel.com>,
        Jike Song <jike.song@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6/6] vfio: Change struct vfio_group::container_users to a non-atomic int
Date:   Thu,  5 May 2022 21:25:06 -0300
Message-Id: <6-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
In-Reply-To: <0-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR07CA0007.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::17) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80c7b1c4-b998-43bb-bfb2-08da2ef6dfe7
X-MS-TrafficTypeDiagnostic: CH0PR12MB5025:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB5025D723CFFFA895195EC176C2C59@CH0PR12MB5025.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r5uEzhjPHCgVix14O9Ew9CyB8Mdsv0e5faKZLxMLt8hzjbZl2HqrxFPFcnR8i/97c/lLyDnQam1x5hX1R+Cp5EQ3pKISETNC8d15DkfWXJIad3SrCKit+brf6/JU7m6WldLx2OOvkOUyHYcs+0cRR98DW5QcXzolanAO8V9OnZsileuM7MDoJ1RYeqBwoNhcry5G6VhCH63TwjGId9fuGFNxevvSUQbT/fGsvrTFWyGU4iNpU0AULwFNtyQQ4N5lQw5JBGFRYvKhM9mKnx9lVp5xxqpC3vVsTWzsIMunL+NzoF2DafMZBI7ZnRIhqWuJh7tSycuwXSmxZnHzsyr7aHqSqARErRSKRCJGi2OSZpnHXVyCf991RjquoCIfcZUEVUMVjUa7iAuY6BatXTu74wKHjZsFaRvQWDJN+ENVc3o8VWqyzZPoRg+MQPs+36rEtwY7y4Kh2iefPRQiDTVuZ0TgpLimuRUqoaTErOuy8zJt/f3TwPeRk2ceINtZrjJXEq6tGw5EJ1BKtSAkwnNAd/I0LrCv0wq441lPEBQeKXppNbR40CqGscs83B/Ae7DzejjwpnMgz2s59glz+w9/nvQ2wSTph1UMl+wmyhGJ0WS9lGOhchx/SAc6CdDU/AhgfpArdo7IEzV+BxXou0F9YcFs79cL3cj1cUntU1t7XlO51saMKZJ85+8tOT4eJFF6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(54906003)(110136005)(38100700002)(316002)(2616005)(6506007)(66476007)(66556008)(8676002)(4326008)(66946007)(8936002)(2906002)(83380400001)(508600001)(36756003)(86362001)(26005)(6512007)(6486002)(5660300002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PYZXY0hyndjrgg9rNtGxT6pQPYyWdVewF1sz8MQElhqYYROh6o1xeHOMaM5T?=
 =?us-ascii?Q?t5BtmJxLVpX+opPfDp56oq0yQfsSI10XoZlq9gQBvtI98QGgA2BAXCDh/kcP?=
 =?us-ascii?Q?6Qs5yMn9UD1w8ImCM3TdhdvytVLJAK1QjcrQlyAes7aVIJmRuxN9eqk7sRIO?=
 =?us-ascii?Q?5/ptFFU04/tdU27puH0trp9ZF+X7k8qcdEcTUg7hFSjT6vSJqYv8OcYq6Ox4?=
 =?us-ascii?Q?8bWpubnOV3ODoHFEG+5nvfYDucWS3DyHtZD9kdUT7U1bfnj0Zg/z4JDCXSlq?=
 =?us-ascii?Q?+TuALT1ZOyvMWoiAvpyQ1Mm4zjShRsifTGu9alFzu6zGf+YU36oRn7h6vA+Y?=
 =?us-ascii?Q?QpuzNShM3ZB3AgvUxHFzPV6ejsNKcY3PpBBO8m+cbGwRu3O/Id2RpWJ8gaVH?=
 =?us-ascii?Q?0+rpk4JyEJYd6MQUW0/SI/2e+JABFRQkG6Od1DWYLSsVO4mNjUAB6PtKcC1u?=
 =?us-ascii?Q?NHATnxAILv+ANU+3bEAtQmE1MopuDdLc5jGIF9JA/RbQjQ8vvX2WezYNijTR?=
 =?us-ascii?Q?x/8xqtj25pz0fi/wY3wNXkrGWvhQ1Y6eWvRgb4c24DIm3OhW7uO6scVnGvRr?=
 =?us-ascii?Q?DnQwcy18NNfmNGtOaIBo8y46gO3tCKXdsp9N66PsbuA1e/V3j1HzPuoC4IQO?=
 =?us-ascii?Q?VcO8wNjtLMfB2+amoerEFv9wT92MlrG+ZBnrllwCwQQhX224DXxKxLjUSVZ5?=
 =?us-ascii?Q?d2fA2lttE02S/RIuuUdeppRNI4mwm0ws05Kh23gi6XwR4TszCfXcehkuMLj4?=
 =?us-ascii?Q?X09HkFhylcTSvD4NmCR7SJ8uNG+x0wBawQhNydi2f+iYZX692Yz3NzoFe5zL?=
 =?us-ascii?Q?WSdZ3xmLztCsaZYVoBDc7SI0rjFruI4zpyQQkz91dgRD08HyRycyPlk4JQzV?=
 =?us-ascii?Q?bzDgYI7smXTFC/YJdhayPFh/mF3cYjWjgTV2pn/UNew1V0E/IqdjEpX28d7d?=
 =?us-ascii?Q?QfEcGE2SEOrEtaKg03+gQmPokkzDEx+s3antQq1Uwdse6mkQ6Y38nICn1f0T?=
 =?us-ascii?Q?CMigSD3DRhAvvzvqBLNNvje9nNUc9AlPt8CxlIqv77DQ0qlsoWZrXmlvBZ7d?=
 =?us-ascii?Q?pi1rzQ3MmAqfRuIGdJS/q1/heTYs9PcPOKjiyO8OOWsxZudaeSkR7VrS0RCo?=
 =?us-ascii?Q?XWFCWkyjPbFxvXlWRxBAR/FQ8T1FPzPna6zL+U+6Wd5o8TdY7tZuaFK5i0PY?=
 =?us-ascii?Q?fyBkJup3KxbifxpOCLeyzt5QK152H3zFGg3MBxFJwybjcmIc0OvYHOpnKCfM?=
 =?us-ascii?Q?6Pqwis1wPV03kf5IYwzpbgrNeEBVtAGzMDViQ+EyoFKH/Td/BmV70hz2Muya?=
 =?us-ascii?Q?4MwOQSInPTfI7fMRIGVWLR93arRhGu2PBTt/pp9aWpa8MuD/n1u8p85N2WS0?=
 =?us-ascii?Q?wzIkwQKeKlVrdPKG0hy/u+AghPHaSZsHYS35/ijGk7i1L2aQ0tNAnMNLoKHv?=
 =?us-ascii?Q?8DYyoxg164oicogee+KSOdovr/jmMzaOpxY2wS00Sbd3cAAOXNs6M3aFMqbt?=
 =?us-ascii?Q?i/VtMBIhdtXMGcJ0mf2uY50EqWsQw/0Zi744bEW0STxCfClm7WGFFMkSqdcM?=
 =?us-ascii?Q?1m5g3mP31doISDDaAvrWEZMfRgmZiJqaXfsc0OKaxQcbbi+yzYSztFN3QjEL?=
 =?us-ascii?Q?WrKDvpwyD7dNQ98b4i8kkhmSxAO1WkR6y0KfY4efbqxfUITBEE9wW5lb2Y0X?=
 =?us-ascii?Q?8s0xtLMBE9VCAbxmofGkfWGpkmZ33lfGRaFceUY3gKt5BxCEX/AWE56O4ZLk?=
 =?us-ascii?Q?dyZUDPVMgQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80c7b1c4-b998-43bb-bfb2-08da2ef6dfe7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 00:25:08.0936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W2kYH6Lkja/Pe4xDcGSIOuUEpXrnC+/WeMPBP33LNDkUh3sqNyDlmxC+guzJ3mDd
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

Now that everything is fully locked there is no need for container_users
to remain as an atomic, change it to an unsigned int.

Use 'if (group->container)' as the test to determine if the container is
present or not instead of using container_users.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 94ab415190011d..5c9f56d05f9dfa 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -66,7 +66,7 @@ struct vfio_group {
 	struct device 			dev;
 	struct cdev			cdev;
 	refcount_t			users;
-	atomic_t			container_users;
+	unsigned int			container_users;
 	struct iommu_group		*iommu_group;
 	struct vfio_container		*container;
 	struct list_head		device_list;
@@ -431,7 +431,7 @@ static void vfio_group_put(struct vfio_group *group)
 	 * properly hold the group reference.
 	 */
 	WARN_ON(!list_empty(&group->device_list));
-	WARN_ON(atomic_read(&group->container_users));
+	WARN_ON(group->container || group->container_users);
 	WARN_ON(group->notifier.head);
 
 	list_del(&group->vfio_next);
@@ -949,6 +949,7 @@ static void __vfio_group_unset_container(struct vfio_group *group)
 	iommu_group_release_dma_owner(group->iommu_group);
 
 	group->container = NULL;
+	group->container_users = 0;
 	wake_up(&group->container_q);
 	list_del(&group->container_next);
 
@@ -973,17 +974,13 @@ static void __vfio_group_unset_container(struct vfio_group *group)
  */
 static int vfio_group_unset_container(struct vfio_group *group)
 {
-	int users = atomic_cmpxchg(&group->container_users, 1, 0);
-
 	lockdep_assert_held_write(&group->group_rwsem);
 
-	if (!users)
+	if (!group->container)
 		return -EINVAL;
-	if (users != 1)
+	if (group->container_users != 1)
 		return -EBUSY;
-
 	__vfio_group_unset_container(group);
-
 	return 0;
 }
 
@@ -996,7 +993,7 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
 
 	lockdep_assert_held_write(&group->group_rwsem);
 
-	if (atomic_read(&group->container_users))
+	if (group->container || WARN_ON(group->container_users))
 		return -EINVAL;
 
 	if (group->type == VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO))
@@ -1040,12 +1037,12 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
 	}
 
 	group->container = container;
+	group->container_users = 1;
 	container->noiommu = (group->type == VFIO_NO_IOMMU);
 	list_add(&group->container_next, &container->group_list);
 
 	/* Get a reference on the container and mark a user within the group */
 	vfio_container_get(container);
-	atomic_inc(&group->container_users);
 
 unlock_out:
 	up_write(&container->group_lock);
@@ -1067,8 +1064,8 @@ static int vfio_device_assign_container(struct vfio_device *device)
 
 	lockdep_assert_held_write(&group->group_rwsem);
 
-	if (0 == atomic_read(&group->container_users) ||
-	    !group->container->iommu_driver)
+	if (!group->container || !group->container->iommu_driver ||
+	    WARN_ON(!group->container_users))
 		return -EINVAL;
 
 	if (group->type == VFIO_NO_IOMMU) {
@@ -1080,14 +1077,15 @@ static int vfio_device_assign_container(struct vfio_device *device)
 	}
 
 	get_file(group->singleton_file);
-	atomic_inc(&group->container_users);
+	group->container_users++;
 	return 0;
 }
 
 static void vfio_device_unassign_container(struct vfio_device *device)
 {
 	down_write(&device->group->group_rwsem);
-	atomic_dec(&device->group->container_users);
+	WARN_ON(device->group->container_users <= 1);
+	device->group->container_users--;
 	fput(device->group->singleton_file);
 	up_write(&device->group->group_rwsem);
 }
@@ -1308,7 +1306,7 @@ static int vfio_group_fops_release(struct inode *inode, struct file *filep)
 	/* All device FDs must be released before the group fd releases. */
 	WARN_ON(group->notifier.head);
 	if (group->container) {
-		WARN_ON(atomic_read(&group->container_users) != 1);
+		WARN_ON(group->container_users != 1);
 		__vfio_group_unset_container(group);
 	}
 	group->singleton_file = NULL;
-- 
2.36.0

