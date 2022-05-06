Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02BF251CDD3
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 02:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387539AbiEFA3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 20:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387515AbiEFA2y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 20:28:54 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2047.outbound.protection.outlook.com [40.107.220.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583F55DBCE
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 17:25:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mKwdgeBDLZnWxVCBtW+UQ1fKcxf7Tp8XoNEVO3j8wRj945DfHzjA+iD8ulmRjRZkufVDYae/wH12m5ogUrfa14yit/B1SmQysPjH8py4I6pqqFNCCdn9tlU6Z5j05UdOYZKHdZskm7N/Aa65bumR2rp8WfjcLWLAhRLNxoQ8VH92OvVuKE8uXw3NFjHCPpkDOj1/LWPhsNfJEpLz8JyeyoU1gxcSuFWcIZ3aDSZ0Es+vCx92otDa5Fqcf89YonYqEi8D/Wz6j++MO0IumDWcwDlzm6rJYA9aWoFYFZBz8vrLVjYXCEUnqkHymTt0JRlf3wkZr9ZbiRJaQQ2UwYkIPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=80JY/iuz/hiv2mGz6BHe35BOWY/uX7MJVUT2UMo/fm0=;
 b=jD9+O6+L9cBB8XpDZXgbIn3A2wJJlc8UnDy915hiGaCPVv8DDiX28pQ/rsBMIz6N0aM4o74rNu/UeJInMbEz14/+SNDqUp7WJszeeDzbzKFto5qbzML/bitbtwAQzUaVSRpeHCT6gy2QVa0cIh+k3Aky+B5gwqFYu103TR5f2+imTzxRmRL5PgsJV6q/VV2o65SZr9MzLoy3sKWHrocfNTQ5JS7NAXSvw0Bf/7O6DmHvn5Q21xNzfOeepX+pey0ycjgigGvFDjKL/uGWlxsJ8USYPMCjPLx+RE1JxMipmxjWXXNhcPVAdpk6loVNOc4kdgyD4EnWJDy0pH1l5beTkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=80JY/iuz/hiv2mGz6BHe35BOWY/uX7MJVUT2UMo/fm0=;
 b=Jv0jTg/ZjnhZPq8fFSlP+5cbrtFh4jYlQwIgS4BFc0U8shuv9AA4DFauUPDLIDx3tVOU+wXi/0Hu8k/LBwxqW4Eb8XLjENu8mwAekAjQTAzd8AQfvxiUGrwx6wcmRN/N/fcONY/U6ZPykyIlU8jAWfa/rqOo55q7kuXH5jPicdLAKl8SFmIA9pdwLW4kgt6zTC2SIQLfHL4GD3QScCWC7o8EKRffvxv5QtqRQxVvfkBNDjFo1lV9OXZfxWDFYe6l/tsGPPq0nDmeoSFWfxDOzyyaKE6O2ESwLJG4Ty3n9vbyyyWRgyBVLp4dEzx5hrIXPEH3ea33qeTpfgCX0vrn1w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH0PR12MB5025.namprd12.prod.outlook.com (2603:10b6:610:d5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Fri, 6 May
 2022 00:25:09 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.027; Fri, 6 May 2022
 00:25:09 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Xiao Guangrong <guangrong.xiao@linux.intel.com>,
        Jike Song <jike.song@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5/6] vfio: Simplify the life cycle of the group FD
Date:   Thu,  5 May 2022 21:25:05 -0300
Message-Id: <5-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
In-Reply-To: <0-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR22CA0010.namprd22.prod.outlook.com
 (2603:10b6:208:238::15) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e76ee945-9fd7-4bd7-1fad-08da2ef6e028
X-MS-TrafficTypeDiagnostic: CH0PR12MB5025:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB50251D9603115A4E597967AEC2C59@CH0PR12MB5025.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5LSXcmIlUAdtSl79GoQLXqne5wpzn1JFEJXvz6xbWIAi/BRdPyhS8+wq3BUGJpnFZQECMtGx3URlyQKrp4Oy1tVEBE7wsbEWIncCuue0tgCXvOkS83gAGJtNQ87S6wU2rQP7saRvKNh8UCw9HT8xP2K/M8MRhZruV2wKFUm5ECFSsNFJ9LlAfNzmNzPcmBAL+Dag9aVuqafnFmtr01DVqWl6//YIHt0Vx03U/1YpN0Ee5Ib2+DLbxr5m/RMkF7VpKvKiSP5zzXhyPPTASgcJTgbYFDnUpI8DOz6ToTHOHTIpOQsCyLHIT1ODAAs6LlJmxqYRzp4B7JfFAfyBxK5R5uUJKuFj9jc1SAs/vvrghXKAIl63SfphXlWY7fnXp1yGPzinrCYxREHA+PMVi+ubxtdJx7Vwjaaf+nu2ckwioNI3jzOyClHJlvNXddapASNcsnED/nLR80BHJ6HCxF8+yPL+5VQsTI2qNnlYzQ0aqlww9eAC+WfqRSBETks2fhNGlRZXqHmI1XHtouFGAYZp17dqbOq8MjOBvP2NHTvAkhVxZribrRfgPyru+G0l9akSMvM7yfmTsws+7N4oFYAD3d3FMMZk/4ukh39ZFsUy7hp8HGhP3nACxBxgeA1GUptspjvdON4QcJDcaLeGZGP2LUJBbUzGXwGeQl/ACWw39R0TaIcudBRJafr4OOAXChEv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(54906003)(110136005)(38100700002)(316002)(2616005)(6506007)(66476007)(66556008)(8676002)(4326008)(66946007)(8936002)(2906002)(83380400001)(6666004)(508600001)(36756003)(86362001)(26005)(6512007)(6486002)(5660300002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b4hZPlY9cjLrW5Mofikj8bJFCVRTE+V0r93Qa1gkQ0AFG8sud7KvBSVLcxPX?=
 =?us-ascii?Q?omGOPe6Ll91qMEJC4a0vh6fQdN+YUiZN4YUnIWToDdsgrPJ9Z27d3rOLWkvC?=
 =?us-ascii?Q?j6vMTbWHw16/GtmX7gMbx10MOBJD74w7lTNE11LtgAzZIAoQesxJ6Nc9YEF1?=
 =?us-ascii?Q?aKgtUK/cKvKw8MeufNh6Aw02Zm4LSnWVbU9wA4Q0/Ro2PlVpeY6xonOsCtR4?=
 =?us-ascii?Q?BSTZ4P9x4l+AD0PRh8QRQoYZFhhk9PvKPWwLZ77GBMwyY2ZzWPs9waLcVlHm?=
 =?us-ascii?Q?YakrYzodg5Bq1QO2hGRFGSAjxkOpMcuCumG2qdS3YuLNJLD9RbKE8qj7nE7h?=
 =?us-ascii?Q?nJM1NQZxnRJT+vw19PZsVWF79VjZpwvICwilALzIMW1ntFHrqkCHfg6HlIeO?=
 =?us-ascii?Q?Ohnvg34H0P6pd5STMx8CtnS0KfTefnkhMbfZDUD6CC/LY57uNrHDKACYqtAf?=
 =?us-ascii?Q?vNEOwhubLJATt0KVUxRMGyv5qds+Fu6q7gQoLVfl7WgIh0taxIlof/KKZqmT?=
 =?us-ascii?Q?Fptjlf/mJtY5VyggQJiDNQ2wFdJIcbv6ClISxtnAIQWjzahvZKxj5Dqu4ITH?=
 =?us-ascii?Q?/ltCQoQaLH8+nYeC0fOorqPRe8WTmq5mf7QO0m9o6UwT3fAun71ZHAwtt3Zm?=
 =?us-ascii?Q?pGGhrJ9h+e1Tuyvu4xVCDi6AcYHF4hKCE3CcU+141e05aPafReTo+CkJR+Z3?=
 =?us-ascii?Q?yLjnMPsGEhh8DQSOaY+VXeuG1UrezeV1BGc+Kw7+NjO0HelFSHyefcAWAg/h?=
 =?us-ascii?Q?djTFc9XEh+ezp37yN/4Q3o0L25pJyunJVlKtCOIEpJlpstKzqKzxWzO9cNfn?=
 =?us-ascii?Q?31DZ8mvOybcI17dBnu4l9o0/adbI0N4aPXbZ5tVZJCG4At5ahTxchlqDZjLk?=
 =?us-ascii?Q?IpERQuikbm7tZEDqql6Y8g7ZWmFJGxu8FAfJKY4AjFgZPojmNrXiFWGOemu0?=
 =?us-ascii?Q?jUN5Lrxhh8JTYe6X5o1j0geex25g6b+kPGmG67ZSYvhCpDyH2Afe0CV/hoQ3?=
 =?us-ascii?Q?dcD/hcVxuNsVKL4RkuhWW0kCs3iAfUP5R8YBWRc6JhhxHK6hXNzddN7SdIsj?=
 =?us-ascii?Q?hkHiC5t9pBV6R2Nhpw2+MZeojkrN0f4VFYMWiKeDSgcQAodkZntjp9mySLyC?=
 =?us-ascii?Q?S8Wb6i2sbucnKmHrRy0iAHfPYmVji8nC/E5GmXUwj+n/8+WikhmETTBZYbcO?=
 =?us-ascii?Q?/eEylvc/m4xwssL0FQIDJixqDfTV8/VM502SWwYq+tgV66Hwes6NjH6+L9wn?=
 =?us-ascii?Q?0UOyYB8bxaKmZmimiZVl1O+fkGjXYf/4TfsUboxzU0Iy8M0RI2Lmxml6gUyE?=
 =?us-ascii?Q?Qco2qSTQe+XnTkez2Sp5QVsH7q1Fu//2Vlu4hvtQoKYwg/H4qOOrUb/tFtfM?=
 =?us-ascii?Q?Lfuq7yFZP8boQKpaVibIGH6ObgTiacz64y76/Ii+6hmOB4sHOQ1tK8ADL2xK?=
 =?us-ascii?Q?HZistVf45HoVP2mOH4B7ho3gmxKZ1x3IOSxUT4BZaW/KvgcvhK4hGC5lm1iW?=
 =?us-ascii?Q?f3YwVD2InfDRWGoXiradm8JUysVuPuY9CUMmwesPK6WSFTJ0FdDfvw2FSMl/?=
 =?us-ascii?Q?zU97p0FEvv/WhaW1NNK8NrQV+8QKsXWCwGTantgKXqgyembpiJXyKfuRp7rM?=
 =?us-ascii?Q?EwVflk9rJhvdVtgwxYgGWzbGYxPhd4H9TMFyRITNH75CTKPksvJCaBC0iquV?=
 =?us-ascii?Q?tFWtWFHVPBJ0gFHwFStYBjKHvzyi3xH/4lrBfVQsXSZ501OXweZBoVBehQ9o?=
 =?us-ascii?Q?3BNyrQKJPg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e76ee945-9fd7-4bd7-1fad-08da2ef6e028
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 00:25:08.4841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LbNGgZ7d+p3894DOEX7oC5bc7wNmvrWoMPXfGPCVaMzU1BDHhK8F3twbQM66tq9M
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

Once userspace opens a group FD it is prevented from opening another
instance of that same group FD until all the prior group FDs and users of
the container are done.

The first is done trivially by checking the group->owned during group FD
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

Change group->owner to group->singleton_filep which points to the single
struct file * that is open for the group. If the group->singleton_filep is
NULL then group->container == NULL.

If all device FDs have closed then the group's notifier list must be
empty.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 49 +++++++++++++++++++--------------------------
 1 file changed, 21 insertions(+), 28 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 63f7fa872eae60..94ab415190011d 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -73,12 +73,12 @@ struct vfio_group {
 	struct mutex			device_lock;
 	struct list_head		vfio_next;
 	struct list_head		container_next;
-	bool				opened;
 	wait_queue_head_t		container_q;
 	enum vfio_group_type		type;
 	unsigned int			dev_counter;
 	struct rw_semaphore		group_rwsem;
 	struct kvm			*kvm;
+	struct file			*singleton_file;
 	struct blocking_notifier_head	notifier;
 };
 
@@ -987,20 +987,6 @@ static int vfio_group_unset_container(struct vfio_group *group)
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
@@ -1093,10 +1079,19 @@ static int vfio_device_assign_container(struct vfio_device *device)
 			 current->comm, task_pid_nr(current));
 	}
 
+	get_file(group->singleton_file);
 	atomic_inc(&group->container_users);
 	return 0;
 }
 
+static void vfio_device_unassign_container(struct vfio_device *device)
+{
+	down_write(&device->group->group_rwsem);
+	atomic_dec(&device->group->container_users);
+	fput(device->group->singleton_file);
+	up_write(&device->group->group_rwsem);
+}
+
 static struct file *vfio_device_open(struct vfio_device *device)
 {
 	struct file *filep;
@@ -1155,7 +1150,7 @@ static struct file *vfio_device_open(struct vfio_device *device)
 	mutex_unlock(&device->dev_set->lock);
 	module_put(device->dev->driver->owner);
 err_unassign_container:
-	vfio_group_try_dissolve_container(device->group);
+	vfio_device_unassign_container(device);
 	return ERR_PTR(ret);
 }
 
@@ -1286,18 +1281,12 @@ static int vfio_group_fops_open(struct inode *inode, struct file *filep)
 
 	/*
 	 * Do we need multiple instances of the group open?  Seems not.
-	 * Is something still in use from a previous open?
 	 */
-	if (group->opened || group->container) {
+	if (group->singleton_file) {
 		ret = -EBUSY;
 		goto err_put;
 	}
-	group->opened = true;
-
-	/* Warn if previous user didn't cleanup and re-init to drop them */
-	if (WARN_ON(group->notifier.head))
-		BLOCKING_INIT_NOTIFIER_HEAD(&group->notifier);
-
+	group->singleton_file = filep;
 	filep->private_data = group;
 
 	up_write(&group->group_rwsem);
@@ -1315,10 +1304,14 @@ static int vfio_group_fops_release(struct inode *inode, struct file *filep)
 
 	filep->private_data = NULL;
 
-	vfio_group_try_dissolve_container(group);
-
 	down_write(&group->group_rwsem);
-	group->opened = false;
+	/* All device FDs must be released before the group fd releases. */
+	WARN_ON(group->notifier.head);
+	if (group->container) {
+		WARN_ON(atomic_read(&group->container_users) != 1);
+		__vfio_group_unset_container(group);
+	}
+	group->singleton_file = NULL;
 	up_write(&group->group_rwsem);
 
 	vfio_group_put(group);
@@ -1350,7 +1343,7 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 
 	module_put(device->dev->driver->owner);
 
-	vfio_group_try_dissolve_container(device->group);
+	vfio_device_unassign_container(device);
 
 	vfio_device_put(device);
 
-- 
2.36.0

