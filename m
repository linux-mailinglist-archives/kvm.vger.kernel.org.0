Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52C3A529569
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 01:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349385AbiEPXlp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 19:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350463AbiEPXl3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 19:41:29 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F23D18E2B
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:41:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iYaSff2aZ47aTYZ4KHWuOHB6ryhKQ2UiRGlJBL6qcQ6JN49wXMGRnT5AFLnwSAGopKmSScTxdbAnjABTYJ9oQD4KS2l4VPKPaPyHFD22TWgTepUbOUFBq7smk0xIuMuz81h2+vo+DZx8h0YN/W4vYnPdkSVx8GbAcX6YQ/WI96qfPvRAXJI6wqoG1G4tK0WGfVIe+SIWxWs7sw4qO/M6qOLAgwHdX2RQrj8S9BKArKm772xTL30ONjQWJiVJRkZv1hsXz0jQ6OXM63KJBkVtvuCyzm9vQi9w1iEgobsBR6zASOfJSVGV/lFo2OcVlyOVHaYMNRkBxGwCSwdW+gUnfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xyLGEnyJwzyQ4iu2r8UHDxWDxTonvvhoXm/ksa+LQPc=;
 b=mkiNtQG7B+kRM5Uc4Ay1ZXdQbk1zpGAYYDGG2uCkkpJB8if+YOyCeuxThZA8QP3VccN8Tz4B18IjNzb/nJKLbEsxqMv/jNoXMfseS6UhHb+A1p7mebxXgM1zzHwWKqmmBGVPqLT+6fKMw1e94qqyn0CENO6XIG85vcNBGSxPIgU14mUq+OV++2hKcOoE2hv1ToInhd4AMh7/bxGYAE0AO3eiGuvDk28Fbya1NOZUAsC509kGR59g9KfzVKKhc5cPnlRiOaY7bcHMKOkVdO8uUu6gjwvBV3OsuRnWgHi93BF1TN5/luaflyM+kpAN3x9/eXpZSjG9P1dUPHfrO6mqQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xyLGEnyJwzyQ4iu2r8UHDxWDxTonvvhoXm/ksa+LQPc=;
 b=O9nOMbjR58SA1AoWrYr/6jhUznQnQk8WOexLnS1l70UWKEU8xkprp8rxfe+8u1IQiCJyT/CXdeKO/PjINy7ODTOt24aOPgQKAq+b6BvuR9RHkEODWO5/FR5lHOaFwj+HvtAgFJMDsvLke57AhlbviB/a3Ih9cFPqIlL9k24UPKij07GDIRU3lYUksTg7g39KBwCnQ8ldnUqocAF4kKu3JPkv4QwOw/ddEhsPMODsTJZf1rR7eEO8ABQ6mJC6abx4edbu5ROEL+TwXPQoScS20iXU8DwM2lPvFni6WDmkrMBYr2xXsr//taZAEXdmOx5RfxQGNZthL4nzxUtlKoA/tw==
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
 23:41:25 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Xiao Guangrong <guangrong.xiao@linux.intel.com>,
        Jike Song <jike.song@intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Subject: [PATCH v2 6/6] vfio: Change struct vfio_group::container_users to a non-atomic int
Date:   Mon, 16 May 2022 20:41:22 -0300
Message-Id: <6-v2-d035a1842d81+1bf-vfio_group_locking_jgg@nvidia.com>
In-Reply-To: <0-v2-d035a1842d81+1bf-vfio_group_locking_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0057.namprd16.prod.outlook.com
 (2603:10b6:208:234::26) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01aa2882-bc01-46ac-3294-08da37959631
X-MS-TrafficTypeDiagnostic: CH2PR12MB3832:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB38320792389F4B5A38D50D6DC2CF9@CH2PR12MB3832.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I5/3C6qDHaS8Zu1lnD6V/HLXdaAdELiF53C4v2ip1a0p/mGhgLwIGq84MY5DXD9gew8SKSrxYjTz5yDUDWeR2KRMa7AgI2B1CBwlvOu6wzgMXc+JZhBnUCRiaU2HMpA/ihYx/yen4+E/lwhohI7ilAXYclxsbNtmT7W5jhj2RDaXpRa6h2AoO395FanoBs7pX4FpY9EetFJIM83es+QsGvRnYKfnPPipInSIoSXrwwUCiMtea7tLtnKHJmuIM7Tf9wkAgRUsS55qlAfbbPk90xzJUJQ9O2CGgFt75EsUSJmOJ3cKy9FUXEw5DzATF20bXYHYLJlP0PwCXh26jt5zcLmR4ewWW9DYXUILzhEGSb63EMGM9TM1Nef+Bj2kawllPkx6AkWCvMQpwA4bZibqBqPgGmYOTa6K1y+otAgmjA91WJvI652E44UW6Z4+dffQukNyGBaVMjlAtWyFbTV6s7teE1sy3nQ62jxxR4pLbYnav3SOUUaGYC+FCUXhv6Pm4PS26DxM3KqiJg9H9OR/ICFoTrruyIRzwTwJ19X5PWi5V913iHHreEPrcrYpx1FR3A5FxFTfooY6jjtOfWmkDCuC7ZPwGrP8oGRdU7fpCu79BltFaQm3VERNqTAVUDK8CrrxQOd/xyY+PXzufIm4bPZC9W8bndCb+gmaT3g2WkRFo6YnEjobvgWuQw/HRmRKjuKrCcym0W0s9n50OkUBdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(6486002)(5660300002)(66946007)(110136005)(54906003)(316002)(66556008)(66476007)(2906002)(8936002)(4326008)(6506007)(86362001)(107886003)(26005)(2616005)(6512007)(36756003)(83380400001)(186003)(8676002)(6666004)(38100700002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bAHBUFt/mrqtzhsQhdX+vvHIIyoqdxsTOEZ/hQ3skGP/gQcp5TMxmR/4z34L?=
 =?us-ascii?Q?YBqSJccsGSL4KiIUVcvnzF+jmlMK9NBqMA+jeFWYUTPChiJHKNHVK4SuW9i7?=
 =?us-ascii?Q?Cpt2Ix140oZgVtvjvrsY+ob1seZ49ubsWgRTOu1vFJ1slNDbB7zq6G/5hlnk?=
 =?us-ascii?Q?qwm6LQofDviop21xId7/LSE4AVyTapdEbhhe9Sh6iCQRq80+2O1PKyVRxK5O?=
 =?us-ascii?Q?Xq5Tbfz2gL4lWV4GmyHJr+Ln9Sq1kNqMYQfUPVz3rZKAOX4fqSEXNqxr0KP+?=
 =?us-ascii?Q?A28lQpcisOb3+JeWNAB5uaK28UFdGhCHKVIm+DNFgT9P5PzItww5b0gHJmz5?=
 =?us-ascii?Q?vu7DIoCgNXP89TdnJsmomE+4YO7d9JmezPbywQhpl5eHTiGGl6CY8Ez6NASI?=
 =?us-ascii?Q?X01wKw9L7n9icG8fkE3dxZ02LZdQKZDO1PFGw4bwVgIUSKe6Ba8Slgzdz0pm?=
 =?us-ascii?Q?amBKo8eY7rGPvO/jUD1N3u4aheGDGD0R1cwEfkS3KIZC7y/kl79DYrNKmTgH?=
 =?us-ascii?Q?Q6JpSKTBzthBiivSN3A2MeFdYEgwN74iG9AtbiJs3L4oSAvGRAXmK9PEgVza?=
 =?us-ascii?Q?BaTFzKLiD6ZGEPDfRPOrsmLahyu/eLZzid6GhAgWj4c+C1fKV7tt2TwPgGOm?=
 =?us-ascii?Q?vceaae+s8C7ocRaUSSZu1LZMsCB2xK0IFFXIIPBwZq0PcK8zd1I2cVbJOZJ9?=
 =?us-ascii?Q?zOGs1ObotQgy7pxK6g5VQP8pGcbA5Vh/tZ9yQpTH9ngrvcPY8uIKTae7kCw1?=
 =?us-ascii?Q?/adfXPdgvuCKEn4GspSu0dz3Kmy/RpSAqB9oy1zum81MpHkOsyWHcUm5h+vw?=
 =?us-ascii?Q?bhdpKTtsA7qZAplpZSSUVSMBvYP8IryibUg4CfYCKR8cu2pOpH2PLRTsFgsw?=
 =?us-ascii?Q?tib+2uJoP1VrBUInTsv5nVcS8XAddNIAa3RZASbWw9IG/Iwgp2X/21uzjApP?=
 =?us-ascii?Q?TIVMNDqNh2Jma8GLeMT6bFZe9Lf7YcJQHuZZmPo2Q6CAmIz2zT0TjEPQTl9h?=
 =?us-ascii?Q?x7oYcafV10BiosLL9Kn3iuINhx4lbbJW2Fs8mNzAHt55prCFJmD1sgk6Q089?=
 =?us-ascii?Q?K2Z9lriEg64r7oA6m5ae+llnQqrhA3pvr9Sr7lc3GE0+at1QCIX6nEDhYy8a?=
 =?us-ascii?Q?4ECSqFHVeMeKzQyQvBr0xMqdg3v8Ct+UHc55U54XkEjpm2gJUCTCnqAB0vcf?=
 =?us-ascii?Q?UwdnDZq7jpFTbV/YyUSwmzbO1Q1nfZSu5KW4x8ZEGH/OTR0D/N+kuo+eFmMu?=
 =?us-ascii?Q?Eq1mcg1dz8/f1j4ccpj9pCks1o60ZxOOEkYYijcto6xWpwyBQ5/qNLb/GOJ3?=
 =?us-ascii?Q?ve+eHJbXd4IlrksgCuIg5T2xq0KseDQsmPYQtBo8X0sVyUg3P8HmyIci/u37?=
 =?us-ascii?Q?2Pdix5/K0Pv9LxRLsdBwFs/Z8gjXlqeOXjz9DlmkX2oiPOlUXVsP5mCVxe3/?=
 =?us-ascii?Q?Q46iOHH0DhIfcDquyZNhm0l3LVt2o+FZen6oSBxf4P77H/UWNXXdAx2+t/7R?=
 =?us-ascii?Q?7Uu/iJqkUBy8LmCLNofFX7f12zp/g3UAIsoAHjB0PZBdZ1YDRElwOPpbpCDu?=
 =?us-ascii?Q?TE8cmn17CgdZiqXSF8K6X2EsD6h2rag5+97/TUhr9TruzMlPISJ5ytIsPxrm?=
 =?us-ascii?Q?Aw5fA3PLIKzxLsOojMhpPWdK05Hf3obvuqheJG1+7kVnhld3L7C08KhG4ZP5?=
 =?us-ascii?Q?iU6lsVdN7KlrmUrylRhTSKGQ0bpaJTbFpP94LOx9TIGzooV4oO9xASTXweR/?=
 =?us-ascii?Q?phNg5S1gAA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01aa2882-bc01-46ac-3294-08da37959631
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 23:41:23.6902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oIQw+petmlPNvY01qVYltnbfUfKtWJt4Bi66+svKjnzdkqJHaVwJCza7c0V4BztN
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

Now that everything is fully locked there is no need for container_users
to remain as an atomic, change it to an unsigned int.

Use 'if (group->container)' as the test to determine if the container is
present or not instead of using container_users.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 149c25840130f9..cfcff7764403fc 100644
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
@@ -429,7 +429,7 @@ static void vfio_group_put(struct vfio_group *group)
 	 * properly hold the group reference.
 	 */
 	WARN_ON(!list_empty(&group->device_list));
-	WARN_ON(atomic_read(&group->container_users));
+	WARN_ON(group->container || group->container_users);
 	WARN_ON(group->notifier.head);
 
 	list_del(&group->vfio_next);
@@ -930,6 +930,7 @@ static void __vfio_group_unset_container(struct vfio_group *group)
 	iommu_group_release_dma_owner(group->iommu_group);
 
 	group->container = NULL;
+	group->container_users = 0;
 	list_del(&group->container_next);
 
 	/* Detaching the last group deprivileges a container, remove iommu */
@@ -953,17 +954,13 @@ static void __vfio_group_unset_container(struct vfio_group *group)
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
 
@@ -976,7 +973,7 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
 
 	lockdep_assert_held_write(&group->group_rwsem);
 
-	if (atomic_read(&group->container_users))
+	if (group->container || WARN_ON(group->container_users))
 		return -EINVAL;
 
 	if (group->type == VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO))
@@ -1020,12 +1017,12 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
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
@@ -1047,22 +1044,23 @@ static int vfio_device_assign_container(struct vfio_device *device)
 
 	lockdep_assert_held_write(&group->group_rwsem);
 
-	if (0 == atomic_read(&group->container_users) ||
-	    !group->container->iommu_driver)
+	if (!group->container || !group->container->iommu_driver ||
+	    WARN_ON(!group->container_users))
 		return -EINVAL;
 
 	if (group->type == VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO))
 		return -EPERM;
 
 	get_file(group->opened_file);
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
 	fput(device->group->opened_file);
 	up_write(&device->group->group_rwsem);
 }
@@ -1289,7 +1287,7 @@ static int vfio_group_fops_release(struct inode *inode, struct file *filep)
 	 */
 	WARN_ON(group->notifier.head);
 	if (group->container) {
-		WARN_ON(atomic_read(&group->container_users) != 1);
+		WARN_ON(group->container_users != 1);
 		__vfio_group_unset_container(group);
 	}
 	group->opened_file = NULL;
-- 
2.36.0

