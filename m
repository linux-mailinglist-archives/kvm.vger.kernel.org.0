Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDCE05153ED
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 20:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380120AbiD2Stk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 14:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233167AbiD2Stj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 14:49:39 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2066.outbound.protection.outlook.com [40.107.236.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1B2C90FA
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 11:46:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i6mukaDjCdQwG8ZN0uGf5rxG2fchwVrpxAbwlGW24xWOPdcg/SRdzppOLUFSIDYAZNPQ2HzcqXp+O2hkCssEOtG26BFSOGDnlM9DjcrEBG04fLYq43uFTU2uEObGaSB1oaX4+Zd8VYJ/A8DvKgKxEmyOLdBLiM8X+WobJFUWIhfRCsxh6qcGebUnRHl7QeKQnY9j6h6EPyEQQc8e4pJEce4Wij/OJVvTPGRIHEn+AqW8D//yb3sFAEm7qNgeU31QNTX8MIvI6+ONQMoDDDN3yY6I3JfKQQfGMn2Wd2GI2vGBQN4qwmKGLv5kWaU1qJqjLssOsKCbNHL8bYf3zd5s1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e+WugyDiAICCVbFpyVb+f7p/Isz2b4JmSiU7HwZbeKw=;
 b=RJ72GFuuSIL5Yk6H/9uimBU2DfQxpty43hVjqRa3elumt+amHqPSSGuxnLPcqvi9UJiRK5JSa/g+11tw1pwg53chZVkUYzzv63HHe1I0BcVoeX7SmtpP9hoi2JEYWHsBELTLCcnHqQPRxAoCTzg1Q+z2s6X4yKCIgk4mdCErPvliKprXks+z3J+e2WZRa78L511YpsVj29BfaTy6FC8xSIY5JPpeZe0KIJoHEROInjlPvkIa0egeK6MVcajZBZ5fM7eKxOHiIgLayvX/aRjaXrt9yYVV9u3WT2KuW95oQ5EE6OShjYzI0jyJGPI5f8YTKiT2vn0poor3vbgWosJVwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e+WugyDiAICCVbFpyVb+f7p/Isz2b4JmSiU7HwZbeKw=;
 b=GZxfsQ3LYLNAdskOuWKfgz56saRhj5UDbLFcf6Du2PzqSs3InbB5dF4AbK+BquNwNX8lhSyietZDSVQXnaYwSe6VpqkP1HUUS1XKyel88RveOa6abwWqKLUfmuRK+k5udcVRr6T5YB5uQbmytSUHwLqp9feeex1+W3aXE6kjsoTGqQv1Z/YQhT1BBtdxsWsdVQdv25tSHqyzT8T/hoWAsP4eRexR+w1pOSAGSmFyDKaHFNrq7ylGFbo3FrNrNIQeAL2aCeHvd2cSkJg5dDkXJLW/3Fems7nkPV7K+DHhNQPYmrPIEXlZeYaCXZLW+lPv6X4tPfgYeylrsbaM/ZibaQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN6PR1201MB2528.namprd12.prod.outlook.com (2603:10b6:404:ae::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 29 Apr
 2022 18:46:19 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.026; Fri, 29 Apr 2022
 18:46:19 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH] vfio: Delete container_q
Date:   Fri, 29 Apr 2022 15:46:17 -0300
Message-Id: <0-v1-a1e8791d795b+6b-vfio_container_q_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0028.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::41) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b820ea02-bfe4-4e93-2b23-08da2a108c5f
X-MS-TrafficTypeDiagnostic: BN6PR1201MB2528:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB2528C03A51B0E29D65A8350BC2FC9@BN6PR1201MB2528.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xcW93nd7qxi9qh7y5uMdi4M6KjuVRkpgAHMiXSSIPECNvUF2D+t+x9QrNwORjT7CycDe0381SPc6eCBznIhK7GNYJEyNR+keicrKYmgXblDWkkDK/31hCW/zb/tOvo96fuGvMnh4GxqGsQuZd3KOsvLsrUG0NgKf7sIhzdRcoz0AjK9AI7FRTg71xn8bu0Zu9HS/JmLTqnPKopbJaE6KNebigZN62xL+U9YYByysMVIE0AH0SP55v7NpoqpMsAY91g9gYhrnutCecmPNS3j3fYsIcKlrTOl/si8+aztsI3PKx39jbanIVvEP1ceqMhiQLvbPBDwequjErnrI0OVkVKiwwC2/mzG1WPNQztK9uCoqDBbzQOUxzkqvGWBrYAVqoo7/zu6cxKe2DGK6Qa3JutVBdyUbylI0L1UiHgVCCfR2cuqOLbYwjYHAp0ghwjPEaP/StvyI9ZdIsaXzyax65WRA0hQlyYyfnwo6IO1U14Z3xoJoZwtcKTWyOPC4uqKeHsNUpVPbnbLQeYE3M3IxjNmKQMMY2XBWhYtvZ7kksqdLJ0RveaY1hJWPHhaPoI3COnjdSHeN2IGK2crOOhwyV5Ae0A8Oxt9gpv/OwxpxgYwIucElyv1vM1ymVvjoD+V3GNBYykLu+6BB2d0NAcvwQZxfIhaQBgii3ADIozPJBjaeCFjURoN9Cl+iNFxbIz1lAWJdVPPs7CgZijB+6Y1T0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(2616005)(38100700002)(66946007)(2906002)(6506007)(66476007)(66556008)(6512007)(26005)(186003)(8936002)(508600001)(316002)(6486002)(110136005)(86362001)(83380400001)(36756003)(8676002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mt/5s62IKo4mmAHYWpAbXVrzO121H1oKL2thrlnoHfglefNAvFvYeJkGKF08?=
 =?us-ascii?Q?uxg6h2LEuTqvBiUzxeMU6ROz3VBE8nPttRNzMD+mSWL+khKa6ekhm6Hp83AQ?=
 =?us-ascii?Q?YUBm3BG7POdoblhq5p3XlqEcGfDEp+FeMKGPxtjLeLfkYzInAxNb4DpxgSOa?=
 =?us-ascii?Q?B3UKSZtxGVpnC42GhfZ2wt6PBWw5ZkCYQypuwAUbBJ7btB387cguldaIQsBU?=
 =?us-ascii?Q?1g86agDrfEg+aAcsmYh+XAzu9d4ROrVW65xaOqXEcX/saa4v07sKN1fiUl0X?=
 =?us-ascii?Q?NpFvATZarA9pIIfO4mmNFJfEzh6Rf38dLpR2K5CA3kvHom55BuGmtYIpY8RY?=
 =?us-ascii?Q?kKlMS7KkOJ6iw5iSKZk7UhMkxvnssp993+sOS89bYWgLLcXRrXFgWEsnC9sD?=
 =?us-ascii?Q?WQ/tUxCp1oSyQNkZTru8668B43LgnNsuo7S+uj3olpwbJd+0fYZVKoRyNZDC?=
 =?us-ascii?Q?E9DAWsMjgAjIZvNLgIK+e5T+TEm4RIu3YfWTuu0+L9oQ0p40uTwyBnWWIRMt?=
 =?us-ascii?Q?FqXu7HTObFC82LWoTu9NQdfKupwMbyR4Svp5nUHe+gwjvGkOm4v+J4tA2cA7?=
 =?us-ascii?Q?/kv3m2sbQ4w2PEsvPWRu3IrQmSjZ9/k/rtrEPJku6Jl6O7h4vgZe9hlYNi4/?=
 =?us-ascii?Q?htj6tzG//nLdh8GlfOiRUm71MmboleviDrqG6+U+fdrwkVdriqqljq2HBK/b?=
 =?us-ascii?Q?H+Gv6c2vVuRSoVvqs3Y8uYPSgkpRxYDV7QdbIuB9sBqswbiFny/LCclsHnx+?=
 =?us-ascii?Q?zfgcbZAihhJWqpUGeiKD2FyHVcakwdcNzf01SJRnqoy1xTmqwXR6Wqv0ZzkA?=
 =?us-ascii?Q?HJsceQuqXHBVH9kI7QfZRLsH8QckSpA8MENraRBVMCsOuugjgusR50Vl/3gX?=
 =?us-ascii?Q?pwjetVcqmh8SD8CFYeZaGDMui24Rft+QpBbuh9UXh5SSVurv+AWshFLsf6eW?=
 =?us-ascii?Q?tPWnYO5qgE1A8pqY1sPgG5PTaji6VWxyWB1VER8hq5NfctpsSdJ8IIQh9CH6?=
 =?us-ascii?Q?0Xyty8peRrktk6eBVJWIVt4NoHNTnaqcB5ngow6Zrwyk+/LiOqJxFdAAIqZN?=
 =?us-ascii?Q?EjnwI/8SEoVAlqJherucTsbfByt+oNE6ZwR12+OoF3VbR7WTcd7fSBYbpRV5?=
 =?us-ascii?Q?sNcbsP4WiaWKH/GsNWKTOok2YHdU628JPH4aRnehjs/nuD++O7T/PmWYqjtK?=
 =?us-ascii?Q?aLE9ste1n9LDB0M26CEZyNAtJiF/pTMQicERbzZJAVMCDp3VVWmwFNMD/2G/?=
 =?us-ascii?Q?D0kvRE1hJsJV67zuhW+JXKzeBbBWJUkjOkVOZghvoExFifdOzuwI2JGDDrc4?=
 =?us-ascii?Q?G59DnHsYmKVPCRpOl/VKYXEOSMlyZPH4/BF7GFtluywNos8Jw6x0wkhPh3iz?=
 =?us-ascii?Q?uvmGlSpDA9EssIjAnFPlDtW4vk7Mf6Ji5lgidKINwQJvS3JAiXLNuB9o6Dzn?=
 =?us-ascii?Q?JdC7TShwVKYG5MRfZC1jVuIMeBKgJlr+9WOyhhMk05GQ1VCEcQ9S7diXa/y0?=
 =?us-ascii?Q?HIcnrVwfPXIZzPV3ar6USk58RYxXqDgsGcGHrCKoXMDeUXubJVkfOC8HnfrA?=
 =?us-ascii?Q?nhZKZaAhALyWGGEia6OMFXbWiYfLJ/XVUJR2tLXUG56qVGoYvcUaZxMOv851?=
 =?us-ascii?Q?c/nwSuR03V3SrBIncK8EDfb/rPITChCvGMboaq3dtCejkhKp/odm09FJa+Hs?=
 =?us-ascii?Q?otdpBmlEr0FstRLEyYfXFRQRc0T+5BbChI0SSAkIlg2G67ZiFUXCskL7lq+l?=
 =?us-ascii?Q?XpJHCh6woQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b820ea02-bfe4-4e93-2b23-08da2a108c5f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 18:46:19.0642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sVC6OAboNoM8gy9ksJOyEkevNOYrT11sk4rHPJ9Eq7MjMgQhieQLimuJXbhG90Xr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2528
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the iommu core takes care of isolation there is no race between
driver attach and container unset. Once iommu_group_release_dma_owner()
returns the device can immediately be re-used.

Remove this mechanism.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 20 --------------------
 1 file changed, 20 deletions(-)

This was missed in Baolu's series, and applies on top of "iommu: Remove iommu
group changes notifier"

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 0c766384cee0f8..4a1847f50c9289 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -74,7 +74,6 @@ struct vfio_group {
 	struct list_head		vfio_next;
 	struct list_head		container_next;
 	atomic_t			opened;
-	wait_queue_head_t		container_q;
 	enum vfio_group_type		type;
 	unsigned int			dev_counter;
 	struct kvm			*kvm;
@@ -363,7 +362,6 @@ static struct vfio_group *vfio_group_alloc(struct iommu_group *iommu_group,
 	refcount_set(&group->users, 1);
 	INIT_LIST_HEAD(&group->device_list);
 	mutex_init(&group->device_lock);
-	init_waitqueue_head(&group->container_q);
 	group->iommu_group = iommu_group;
 	/* put in vfio_group_release() */
 	iommu_group_ref_get(iommu_group);
@@ -723,23 +721,6 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 	group->dev_counter--;
 	mutex_unlock(&group->device_lock);
 
-	/*
-	 * In order to support multiple devices per group, devices can be
-	 * plucked from the group while other devices in the group are still
-	 * in use.  The container persists with this group and those remaining
-	 * devices still attached.  If the user creates an isolation violation
-	 * by binding this device to another driver while the group is still in
-	 * use, that's their fault.  However, in the case of removing the last,
-	 * or potentially the only, device in the group there can be no other
-	 * in-use devices in the group.  The user has done their due diligence
-	 * and we should lay no claims to those devices.  In order to do that,
-	 * we need to make sure the group is detached from the container.
-	 * Without this stall, we're potentially racing with a user process
-	 * that may attempt to immediately bind this device to another driver.
-	 */
-	if (list_empty(&group->device_list))
-		wait_event(group->container_q, !group->container);
-
 	if (group->type == VFIO_NO_IOMMU || group->type == VFIO_EMULATED_IOMMU)
 		iommu_group_remove_device(device->dev);
 
@@ -984,7 +965,6 @@ static void __vfio_group_unset_container(struct vfio_group *group)
 	iommu_group_release_dma_owner(group->iommu_group);
 
 	group->container = NULL;
-	wake_up(&group->container_q);
 	list_del(&group->container_next);
 
 	/* Detaching the last group deprivileges a container, remove iommu */

base-commit: 46788c84354d07f8b1e5df87e805500611fd04fb
-- 
2.36.0

