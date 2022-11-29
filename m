Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46E9563C960
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236051AbiK2UcH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:32:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235779AbiK2UcD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:32:03 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2064.outbound.protection.outlook.com [40.107.223.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0A065E49
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:32:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dpjzILwTpY8YtEOuovpwdHAHe02iX6lEQClbosO9Dl7LR0879HYT4H/ejq8y4BuPylWUqDZIQ5j0+7cMNXqrSH6aIUdvSx5kdvLmbnL+K3pDJjKGyIt3nI25JhKkYqas5l7AfRz6ftV+DlJpi2argQ7UVyb6ehUh3Qf9vkbcF+pXHCMFGbSQzmgU91eWHZhf7yziQYNVKQayI+z4R8273XTFjliP6vDu+PC+XR12TS0wcJJP0pDfNCyhTevc9RiJ8k/pKJqY9W2bCdHOXiVe2+C3XMVroiCiXH8ZNSjbMUNqsBEwsUSbTcGvaXezwLFL4cOUU3yi39cXTkLqNzhXmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EHgYvVbfWBUl3S9gV31npkG/TW/G8a78fDH+HNt7HuQ=;
 b=EndmMg8uSHQX92Wz+ssvhwXfHvQgD96Ww8Pz2YN+i3jeDycvrufcMWQdO5dxyA1ND+CbvSEl6wwLnI2QUZUula81vX12nstXwD1xuamLZSCrqBiuOYi37SOeTSze7ZWla243dejw8uPzvCis5Rlr5knA3Ul0+5f1B4h5y9SMeA3GGBcrFjivRdfgtcrzjgPVlyfkmwnpGuTQkL3DMD3xnduOMH/PYJCjzR4yrC1v3RVqJTbx7IuQFWtEqHkpM8D5DE+tGxX0DXW5Q7MpkCr1q20dLew66erP+FC1UCygVAYNQhYrApRL+XzUa0krF/MT1spsUAySGM/MKnbhHbblcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EHgYvVbfWBUl3S9gV31npkG/TW/G8a78fDH+HNt7HuQ=;
 b=Fe7gAL51T1HgmA3/q6ZYqxwfkjADP3qnljVaFVQc3k+WiPME1rCXu2WVBN1WiDPyT12rahMa8DNfiQHFbPpGDpEydoHUsgBv7OB1Nzsnz8l+vfbmCP8cuE2+ciAoP0TSSv8jhEycEzwvSuQFCsHw8TwRR8oDBSnkPuV+i2oTL4NcXkvda6Jd3S7YclUet4QnjF/OscxtVpVMXgwDsxsZskBPsO24ZK4+fpiZ6pbE6OFyvXgJt9a44hmyvFPK9XxC+wt9D6HCon+PSbpFr6agWk/tWYgZtp6Aod3d/oZXow4V0uE9wUlm9FEZkKdLS8h3Ap2wYVmShwdcfOsVRQ06lQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB6439.namprd12.prod.outlook.com (2603:10b6:8:c9::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Tue, 29 Nov 2022 20:31:59 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 20:31:58 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>
Subject: [PATCH v4 02/10] vfio: Move vfio_device_assign_container() into vfio_device_first_open()
Date:   Tue, 29 Nov 2022 16:31:47 -0400
Message-Id: <2-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com>
In-Reply-To: <0-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0063.namprd08.prod.outlook.com
 (2603:10b6:a03:117::40) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB6439:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b0ba067-506b-4b66-3168-08dad248c32c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3MWjJd5L4ioiv+AX5icODEcbNXiuADsbPdNXfA8KvfTmtqSToyHZ2iBGm2pthCMRyz/fx7fC+VJvQYwo2fMuVAnpa8FUqU5oiRnwJ9+OTMBnWkmc2+Zdvr1SLxrplHJGuvPUg/VBK8Ae2NcNoc2cTihbzxLu+oz1SpyI4L/a736dAMYd81XGaesiHi2LsBiG318X1fX/2XWyUnb4w3AkkkkvhvL79HScfIFMoiX2gcZuNb9WLF8p+okrkV3N0vKeHa+j38SqBEo6kCFJmeEDMIMHFJl62vEvCHtqcP8XaDMubyn1Iv+MREdmPh6Nj65TRVsoDWTfHXSqiA3fbX2N+8Qu13oHJJ0tKy7wlrhp+pGESDJoHrj2iYby+TI0ijy97WPNX8RG5EJE9uwq6Dsrwu6Y/jpH28RM+UFJ5IxG5YbA95G3QQ1PKJ8iueZdALE8OBibUvKxevkopMFay1uq/GdxukClz16UeDek38RDL9huLxX9cXtdLbVXGVG1qjlbJ4KhOtFprv/OqZjatgf4eBT4jkOlg4ifTFdm1zq8/8mNY6ZJFE0SRWBE7h5HWtC+N0tBJFpkbSCc9cd4jbzItBhktsjGiBI44XnTnm0waya2LjaCPxNXmWzA2CjUL6ogWw/yGcUFhhLIuq5j3bTqHRJ8D93QJzRVF5xsq0WqrQaLNjaqE7vyPNaxxD+MQk0FkZVS7MwKUrc01knSETwo0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(366004)(39860400002)(396003)(376002)(109986013)(451199015)(26005)(86362001)(2616005)(6512007)(186003)(54906003)(6506007)(6486002)(6666004)(478600001)(38100700002)(83380400001)(36756003)(2906002)(66946007)(66556008)(66476007)(4326008)(8676002)(316002)(8936002)(7416002)(5660300002)(41300700001)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G4acSL3H0QtkJj/UKRpClPc4yTnHjYbuhGfaLWGHzWPelgzVVsASSeCvGFQP?=
 =?us-ascii?Q?FCdjQWc/FNr3EAzMuRy0pQUa79ivAZ/2Ft1UEbLBx487nE3d8clZu270cgco?=
 =?us-ascii?Q?W3MfIms5x3czeRNdU696NRV1xHRc6ungJz8cFMiBA5jGVR2TgJCs0tmYzHLI?=
 =?us-ascii?Q?17lsg5JqI+ZmTq/yvN69F3QtFqt/3psXXoD0LSIW7JAR29cxswlkGPPaanP7?=
 =?us-ascii?Q?D8aB1bVtOVThFJLr5AJEPZROfnmFXZv9LdYdEsx8iEQz0hXZo4dfWaTA9H/H?=
 =?us-ascii?Q?92al2uPazzr6HY+6DMk6JKjOA06LdzTZWxpKLEl3Lf3BRFsSu0CKu2Jv2DeQ?=
 =?us-ascii?Q?c7EAzsw9UJXIZMpQzPZS3PiTu47GZoZGcwTvi4WvK/FiwaktKS53R86vsaI9?=
 =?us-ascii?Q?cUzgPeGebHFstBjE20b1yBQsyJ2+fBYkn/nKBX9Dmm4RYjcbHEI0UwalZ36N?=
 =?us-ascii?Q?NpQFch9GuEVQ3wKa5HIpY2RJ9EuBZq+LwIN+GPPUCnZeIgfFOmB33b3Z8ryX?=
 =?us-ascii?Q?BhlsiKmFlXKe965llZPVUmHE2xsDMj6ArmEOsDgsOGf8Ut+Gq0qDjW0aElYT?=
 =?us-ascii?Q?HnWy1yEIKdpcqjpSvvvCG9QWNDWymcIrF7OfaWZGR88HmsnHjJ+8QEjJY1LD?=
 =?us-ascii?Q?CUzula3WHVrGhT1uLLEUMSSvJOx+BBi6q/QTPr8QghOMML+3MYd9s/y2lbbQ?=
 =?us-ascii?Q?eR7gif8wtfJTxwarvdnL8+JssklR5hSxBPlYntfKDEoZ0RLG2DqLUVQKnM10?=
 =?us-ascii?Q?ZUtJRdqg1gLkJ/fUO6iP6Lu0ccClqyeOe2Bkmkg08PLCyortmERgvEfx+cWW?=
 =?us-ascii?Q?Ck8sM17jGmMqq4LSx8mRULY9MwPVzDE8m9defOhv4T+KHpUcpFWfBjw1Rm+O?=
 =?us-ascii?Q?Dak2Yuo59DqHN7tvNWj5oqJRWkS0CCk+b0bn1YskxtkVdcY+a/T7bCXknk7v?=
 =?us-ascii?Q?DY9dLyNHDkr0ym+nZ8nyG8P04kPn9Fwwt3+zDWS2MsLF3qFeds1MOSF4wlZ8?=
 =?us-ascii?Q?Kr8UHO1mMQJs6Bcq+utEQLLAN2I4CFG7eFmMBqJ/pMrt/Fmm+kfj0+sZEbR+?=
 =?us-ascii?Q?9lXlm2v7DW9Ea02SQjaWqTUo6j3RMbEyPTz1P76UMOOylwe7P6evzsJE5zcO?=
 =?us-ascii?Q?mRvV+l6hx7O/+WjXtkIDoNu1dKzOD0yca3X41qNDyYj8zR1xqHQ/ryxoysBz?=
 =?us-ascii?Q?YT804Eaa5SsrZGhJ//tCEtsPG5n/zM0S/x2/pJPM+N+tZUAW4YJOuDw+Kv2h?=
 =?us-ascii?Q?0wPc5ZFUTc7I+DhDLoaeq3F83uqokeBufXP+435wA+XgEs/QP3/XUq5IDb54?=
 =?us-ascii?Q?ksicyTKYTNHQrEhuMLliVA+IzhdcNMrg6nmxUhzCD99Yn2gYNVkQN12UM7mR?=
 =?us-ascii?Q?ZyqOrLV5kQx+5jf/msRBxFm/3oG4ZGzspSpKdX2iHSm6v2P/PVhuqEVyXCoQ?=
 =?us-ascii?Q?S11kfLI3OATO5tjm2J8rrt5hXWFe+TP77d9hb5aKDAQAL+X6TR5dWY0qOpPP?=
 =?us-ascii?Q?k2gMlU8IbmgO3cSGh7Pll4aH2zVlHPgpavlycK5hLR7iFAiGXKqJgNW4pZhz?=
 =?us-ascii?Q?RTvpNRjFKe2+Bm59PUKYxUXopySuR5YUPvJ5haOy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b0ba067-506b-4b66-3168-08dad248c32c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 20:31:58.2621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k1QX7AHjPaokEFAhX9nlV4c9wbeQDRenTnZi1SmLGJDU1tEkXTxwMvbZ7Na7Qmj/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6439
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The only thing this function does is assert the group has an assigned
container and incrs refcounts.

The overall model we have is that once a container_users refcount is
incremented it cannot be de-assigned from the group -
vfio_group_ioctl_unset_container() will fail and the group FD cannot be
closed.

Thus we do not need to check this on every device FD open, just the
first. Reorganize the code so that only the first open and last close
manages the container.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Lixiao Yang <lixiao.yang@intel.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Yu He <yu.he@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/container.c |  4 ++--
 drivers/vfio/vfio_main.c | 24 +++++++++++-------------
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/vfio/container.c b/drivers/vfio/container.c
index d74164abbf401d..dd79a66ec62cad 100644
--- a/drivers/vfio/container.c
+++ b/drivers/vfio/container.c
@@ -531,11 +531,11 @@ int vfio_device_assign_container(struct vfio_device *device)
 
 void vfio_device_unassign_container(struct vfio_device *device)
 {
-	mutex_lock(&device->group->group_lock);
+	lockdep_assert_held_write(&device->group->group_lock);
+
 	WARN_ON(device->group->container_users <= 1);
 	device->group->container_users--;
 	fput(device->group->opened_file);
-	mutex_unlock(&device->group->group_lock);
 }
 
 /*
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 2e8346d13c16ca..717c7f404feeea 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -749,18 +749,24 @@ static int vfio_device_first_open(struct vfio_device *device)
 	 * during close_device.
 	 */
 	mutex_lock(&device->group->group_lock);
+	ret = vfio_device_assign_container(device);
+	if (ret)
+		goto err_module_put;
+
 	device->kvm = device->group->kvm;
 	if (device->ops->open_device) {
 		ret = device->ops->open_device(device);
 		if (ret)
-			goto err_module_put;
+			goto err_container;
 	}
 	vfio_device_container_register(device);
 	mutex_unlock(&device->group->group_lock);
 	return 0;
 
-err_module_put:
+err_container:
 	device->kvm = NULL;
+	vfio_device_unassign_container(device);
+err_module_put:
 	mutex_unlock(&device->group->group_lock);
 	module_put(device->dev->driver->owner);
 	return ret;
@@ -775,6 +781,7 @@ static void vfio_device_last_close(struct vfio_device *device)
 	if (device->ops->close_device)
 		device->ops->close_device(device);
 	device->kvm = NULL;
+	vfio_device_unassign_container(device);
 	mutex_unlock(&device->group->group_lock);
 	module_put(device->dev->driver->owner);
 }
@@ -784,18 +791,12 @@ static struct file *vfio_device_open(struct vfio_device *device)
 	struct file *filep;
 	int ret;
 
-	mutex_lock(&device->group->group_lock);
-	ret = vfio_device_assign_container(device);
-	mutex_unlock(&device->group->group_lock);
-	if (ret)
-		return ERR_PTR(ret);
-
 	mutex_lock(&device->dev_set->lock);
 	device->open_count++;
 	if (device->open_count == 1) {
 		ret = vfio_device_first_open(device);
 		if (ret)
-			goto err_unassign_container;
+			goto err_unlock;
 	}
 	mutex_unlock(&device->dev_set->lock);
 
@@ -830,10 +831,9 @@ static struct file *vfio_device_open(struct vfio_device *device)
 	mutex_lock(&device->dev_set->lock);
 	if (device->open_count == 1)
 		vfio_device_last_close(device);
-err_unassign_container:
+err_unlock:
 	device->open_count--;
 	mutex_unlock(&device->dev_set->lock);
-	vfio_device_unassign_container(device);
 	return ERR_PTR(ret);
 }
 
@@ -1040,8 +1040,6 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 	device->open_count--;
 	mutex_unlock(&device->dev_set->lock);
 
-	vfio_device_unassign_container(device);
-
 	vfio_device_put_registration(device);
 
 	return 0;
-- 
2.38.1

