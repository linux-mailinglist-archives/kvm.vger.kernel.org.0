Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B1A5973C5
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 18:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240648AbiHQQHk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 12:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240702AbiHQQHc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 12:07:32 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B8797D61
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 09:07:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G+Z06SBXYG4ktQ5qWajduzF3mmciAcCSbIc1iYOHRyJMdxcYUgcjEKZ4JWAyZUJnGYiY8vi1u2p6D0U3MgTmZP6HPY12sKDcIOcpaMSi1MhuZTmmyj49rTznLQrXLeeYEBYx39oOXbGoynsXXOFnofWbNf3XLI7qji7GubVTnClEf4O5cCbTct0oQjJF0+Ub6dPaCi41BGzzTk6YigVRSMnWxQPhmc+IhOhZc8vhYn35fItU04MTiYG6EyF+Yt/0FDC+zTlCfFzl0CoDRVQCdBYHihWWumH5p1wnUWDsLlUVqUmM0LbSb1f9fB57p3cQ0O33KGc+ouRY7DA2QeQdpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GVCRYaIuP2FXiYev7chF2oFskTcwGxY+npXW7PxBJHk=;
 b=oGBUW/rTEAK2r7sHj06LUo2aZ/6dby83pOpO3hisH45uoaORE5jusvBu2TcISoec8GmPf6k9G31vCz4IZstE2eUMBSISRlhkD/2sQDayfyZGV8QLrnSJK2YIc4p2DTKilEP/7OLoagZ08OKCeuANISEoO1pOROg5yezhP3y/FPEPbFojyEO+PVGC7F3jxtaRr9k+Z1I7UW7cBo3xN5ll82XYti0SJmg2Rtf+YmpU8SHCYemeHdYeqp5hlYnD8SBsDEkGCKvvu85hLk1nl2VbnxHlY7h13jNqFtaniMkrFdvDv9zqHv2kcAV+1MfgyFAD67laiKwBbujPtk2r+hVtEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GVCRYaIuP2FXiYev7chF2oFskTcwGxY+npXW7PxBJHk=;
 b=oTJKpEKK649voDxA9wKYpilkgFtTGDDmvlz3aFeq0+nF0463iw0NPRIXmaAnWannyhZBuC6sxLlFXntokCkkAhKqxgtIwU6SpwO/cum2QpKHCnAEuL36Hz6k4PBkO+Y9J9n4/6QjVKZMlkjwuynyxzv/6YyI+CfhPqWDFOnsM2epZ0HQqhUwxfZ+QanFzftolBkrApPFdJsCR0COkJ2ZEJcGGI2A+GrFJFktpXNKslMLNQNzI6PStmi2ldxCZzykONuFiVu1y/8edRs6oxf2mJP7Rk05OaSg91UD5tbPyh2gIgvzY+FLY6oPvkPNBwUBAqhminSK6GNwNuQDXKzMhg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY4PR1201MB0216.namprd12.prod.outlook.com (2603:10b6:910:18::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.18; Wed, 17 Aug
 2022 16:07:27 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%6]) with mapi id 15.20.5525.019; Wed, 17 Aug 2022
 16:07:27 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: [PATCH 6/8] vfio: Fold VFIO_GROUP_SET_CONTAINER into vfio_group_set_container()
Date:   Wed, 17 Aug 2022 13:07:23 -0300
Message-Id: <6-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
In-Reply-To: <0-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0065.namprd05.prod.outlook.com
 (2603:10b6:208:236::34) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53689b40-f6f2-4ba9-8b31-08da806a93fa
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0216:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SfrltqCVZk/P4+j28GHiUviHR0gop3HXLjNWKNWcPJ+yNsgj01CABcPSAo6N57ux42VhvoGcKQTJPk79GI9+ooLoHtyoWP2SOdpAYjlIV0pCXTX0c167wWDC5Mw8hx8v/xvT15ijRUcDmz5XSVfGVSfyyMbgelEboxju8RDNsDSa8h1a6LNEnH9wIc4A750kYsOgaHti+9HPDGCSZo0hvumY4RtOI9zdnUYL1eXFTdJ95++muOxL9PdVBDfwlZTK+HMScsQQmT9up74+iNMNCy/K7r4/CbT8FJN5w17kbn71VW9zhFEPCPrxPO32tmU+3oI8PP2UNwwi3G26CPHlcbkdZYb0UhSTIjwtThXLPLbhvhz3vyjmLv1OjJGLF+ghdZ15CP4NZYE28S50rbAbPWptVlcYWo2/3/r/KIza+gQiuCa0A9UQCUTXPbdh+BtfESzLYi1TW3Zvi+ui2rhGFueAdn8vzZmBw/ZkMqv8fyA6J6WGSMKVT3hI1SPfiOj35/kZ2N+TlYivPCQhomN3Ejqp2yMRdV9OLNHupfqEMtsS3Ki9/pxhmaXt4/ptMJyEr1l3Qja0E37GWzvbaqNbXxbzi9vz0s6IWjwkZMh3gUE2SicWlMWkUc0gDhx/Kubfggr0lnffjorrFxcJ0Xi2KWDT7P6S38TdF8nWXqH3ShQTJHFRWpcShuRydBHGnxw13C2m54QEAeSVAdpFux6zaniFOa8Wn/e13dale/USjfFNok+0wVq0TYcYr0eRYTuv6eQT+F8MTKc5Sn/xaos30A4rFV39aPjHrbPNAEysihY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(41300700001)(6506007)(6666004)(6486002)(26005)(66476007)(2906002)(478600001)(8676002)(66556008)(110136005)(36756003)(86362001)(316002)(6512007)(38100700002)(186003)(5660300002)(2616005)(8936002)(66946007)(83380400001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XK/aEaIR9XQLJ0zSxSE9pjkMUe3MPL4VHizfxwMS57gSGVPDBYvziYVR5CEi?=
 =?us-ascii?Q?BGpi6cm6fN68TxvReLyMoS0bKIZvSGUrgOjY+NkiJlXSlohRshpI79sirIgj?=
 =?us-ascii?Q?LOWODUhcZC24AoLChDWTQyDc2k4KMuhcJBYsEE4aGf4RVa6/qcbLiOybDhui?=
 =?us-ascii?Q?K1sTq1MOVDQp3w4EDS8LLdPE3qGQi9mqpUXC+hYTR53v4SXA7c+Mc0PS616q?=
 =?us-ascii?Q?Y9/FYKE7xE7dtnghh+OASo+/BXRimy/z9ax0embwzwOlbPfD8+ZrHsY3GzQC?=
 =?us-ascii?Q?XIbpvCpyUnxZ1Eg0JnVN9K88EFX3xS1JNvgQr/KxaUkBmTorNotIytDxIwFH?=
 =?us-ascii?Q?tyhDTrb8mz5U41DvT/jL746Q/6mBGhmdqtW2QineuXhyUhhW9yt5KxzDqB5H?=
 =?us-ascii?Q?gFTZ1IDzUsZ+flDH+rTBD15HXiTMOtgDd1UHJWVvIyyN8e0kterKKKhHl2Xw?=
 =?us-ascii?Q?/+34WsWsc5hlfvs2bTTQwDiHjgT/zchExEEr72hrPwIt52KGcFs/qf7GuhHP?=
 =?us-ascii?Q?5xd/BtpnXMRyIMos0IS3x/pEogDKNOgxtnN+fFKSqRK1jZXNNEWEfPzHqpy2?=
 =?us-ascii?Q?v81LJ3nWZMe1T2w52xQvbC7Pykv+mt58+EDoI+xhj7nlzrXxLSzHT6k7RyXD?=
 =?us-ascii?Q?jUiMP+OinJBok5YqFHbuWvlbGUR/Fd+yeVRvkewLPdTVLHD99FwVU3hLb+56?=
 =?us-ascii?Q?nxMSt9d6NhRtgVy/8Sn8a6EDqeqRhvahDkUl8KgcBx9GadnpM25J5fG6hpqM?=
 =?us-ascii?Q?a8slGGqhayhXGdckmxM1jcwm/bhF9GmFrUErHcxRevA0yAJcgngmkwDhoomv?=
 =?us-ascii?Q?bpsibMA9CSNnuMGQaEQteUwrlyWsWiBdr+f2e2ES55Jv+3kmfBSGYqYloUZa?=
 =?us-ascii?Q?jDQv0QNFr2L8lVPLJuoD+nP+D8IXSgD90CCni8eP1+67x++tUXmEevuFAtFn?=
 =?us-ascii?Q?rLx1dbSlfACnWwHZsLYRSr4WN5diJehGoP3B8FnTxp3nDD1NfI66F71eubSK?=
 =?us-ascii?Q?PnyrOK4pQDePvQeOczxyitUb7IW8eKnAlFHRaADJ+aVcP0J3xlRKURlV5BGz?=
 =?us-ascii?Q?D8ECRfEIb/yiiX+6SudcZKFg9SLQHBFg6WoPSz8Q1BVTisU/SzmlNgM2b4jI?=
 =?us-ascii?Q?7qyLDJsqzRvyR2R7e30U4HSUygsurufBP5pxxDX42+UNdS+G1qRGf9HcdJtF?=
 =?us-ascii?Q?v2omXyN+Mn/0+jSZbWuf6cDUSLf2XgxAUDlDwFExXM14NQ13ukB73m/1DlZP?=
 =?us-ascii?Q?JASKb5St2sXFgEhyu4jNBNzhRkMnwvlSQdzvcb2pFW7Ejdi5vAcE8LtIuXyv?=
 =?us-ascii?Q?46AV/YM6zz5JtG42qweZiY1LCHQgP0uCLZDxoS7jLE5GeVxMJkZ6zlS5040P?=
 =?us-ascii?Q?nuNvUkRTWziOKbhDEVCjOFEp3d/3NOAXsw9xd+l9SH0LmI55x9+s8l3+ECpU?=
 =?us-ascii?Q?ubl2328LJmyErk2SPcg3sSy6e+IsiUMgijLRidL3iPO/aOUFIuKnV/QVMEqG?=
 =?us-ascii?Q?38TiGHjxIIC7KB8Sz43drbbZ4Rz0tbXV/nKyZn5fTTdQf0I/+fK7DUgoyDLE?=
 =?us-ascii?Q?dpJ3AefcJyE3MVX0Uq+67SderSdrWapB4M8rSnnu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53689b40-f6f2-4ba9-8b31-08da806a93fa
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 16:07:26.4999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hJ4Sekd42NvHYN9whmfTocO9aKQMzFiVbXiTfc6gQ40craKEjBRd2ghA0qRKNc1L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0216
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No reason to split it up like this, just have one function to process the
ioctl. Move the lock into the function as well to avoid having a lockdep
annotation.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c | 51 +++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 27 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 3afef45b8d1a26..f7b02d3fd3108b 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -980,47 +980,54 @@ static int vfio_group_unset_container(struct vfio_group *group)
 	return 0;
 }
 
-static int vfio_group_set_container(struct vfio_group *group, int container_fd)
+static int vfio_group_ioctl_set_container(struct vfio_group *group,
+					  int __user *arg)
 {
 	struct fd f;
 	struct vfio_container *container;
 	struct vfio_iommu_driver *driver;
+	int container_fd;
 	int ret = 0;
 
-	lockdep_assert_held_write(&group->group_rwsem);
-
-	if (group->container || WARN_ON(group->container_users))
-		return -EINVAL;
-
 	if (group->type == VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO))
 		return -EPERM;
 
+	if (get_user(container_fd, arg))
+		return -EFAULT;
+	if (container_fd < 0)
+		return -EINVAL;
 	f = fdget(container_fd);
 	if (!f.file)
 		return -EBADF;
 
 	/* Sanity check, is this really our fd? */
 	if (f.file->f_op != &vfio_fops) {
-		fdput(f);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out_fdput;
 	}
-
 	container = f.file->private_data;
 	WARN_ON(!container); /* fget ensures we don't race vfio_release */
 
+	down_write(&group->group_rwsem);
+
+	if (group->container || WARN_ON(group->container_users)) {
+		ret = -EINVAL;
+		goto out_unlock_group;
+	}
+
 	down_write(&container->group_lock);
 
 	/* Real groups and fake groups cannot mix */
 	if (!list_empty(&container->group_list) &&
 	    container->noiommu != (group->type == VFIO_NO_IOMMU)) {
 		ret = -EPERM;
-		goto unlock_out;
+		goto out_unlock_container;
 	}
 
 	if (group->type == VFIO_IOMMU) {
 		ret = iommu_group_claim_dma_owner(group->iommu_group, f.file);
 		if (ret)
-			goto unlock_out;
+			goto out_unlock_container;
 	}
 
 	driver = container->iommu_driver;
@@ -1032,7 +1039,7 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
 			if (group->type == VFIO_IOMMU)
 				iommu_group_release_dma_owner(
 					group->iommu_group);
-			goto unlock_out;
+			goto out_unlock_container;
 		}
 	}
 
@@ -1044,8 +1051,11 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
 	/* Get a reference on the container and mark a user within the group */
 	vfio_container_get(container);
 
-unlock_out:
+out_unlock_container:
 	up_write(&container->group_lock);
+out_unlock_group:
+	up_write(&group->group_rwsem);
+out_fdput:
 	fdput(f);
 	return ret;
 }
@@ -1258,20 +1268,7 @@ static long vfio_group_fops_unl_ioctl(struct file *filep,
 		break;
 	}
 	case VFIO_GROUP_SET_CONTAINER:
-	{
-		int fd;
-
-		if (get_user(fd, (int __user *)arg))
-			return -EFAULT;
-
-		if (fd < 0)
-			return -EINVAL;
-
-		down_write(&group->group_rwsem);
-		ret = vfio_group_set_container(group, fd);
-		up_write(&group->group_rwsem);
-		break;
-	}
+		return  vfio_group_ioctl_set_container(group, uarg);
 	case VFIO_GROUP_UNSET_CONTAINER:
 		down_write(&group->group_rwsem);
 		ret = vfio_group_unset_container(group);
-- 
2.37.2

