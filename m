Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 700045A7318
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 03:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbiHaBCJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 21:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiHaBCH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 21:02:07 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2053.outbound.protection.outlook.com [40.107.101.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602C16EF18
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 18:02:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QVZKXfZXvdBaIBwaDrmfntV3OvEkra6RBubZ8cbR1ZX0DEDboSGeM+aAdsAt0KNJ0MaY8SqDziwXZ+oG/pQcCH4VmV+s0kIL4nbBZyQSsAEeJb2LlqOXepo3XkCJUB1oqcGN7AXlWDqwZ8/hoV/uOiYa8F/PgR/Nd12AyDdlCuX1ED2hRa0/+P9a4fvfFhLt7Xjb1Um7lAzwXZWuQeImFFfWCujssjq5MRsg5NR1rhfCdwmgyiwFpPpSPWgDAeRtOJ0ObNIo8YHUq0/M1RltKtOBS9WZ21vHoLlhUo80Ir58y9WV4LBlHKZzUPyOOlJgO+e5k/k5iBhLl0e1wGtnoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XEZezB3kjCFXFO/vT3eEtUOQgNvHFlaEnMWLW+PXwrw=;
 b=nDTb4NsooYGFPHR1owOKc475nXI5z4LIkBVJVf2BBwLnC92XS3DUVp7ANvYnyaFMfepag6QsAz8svrvuYHzCv1zJuK039jhA0gTWN1eXrin2yX0uYorAwwER9ec/urEA3hoRHdTwOIjITIGWZJb+SQhiPatiCBK8EsQ1yxTkAKouveheJmHf89J1pb6yx7GJaj5jysjjRfqORUdiSjgIvkgwa0E9+W5hWjQfAKXQa44a+r6H+FLtlWI40spxsoCpf536Weyz8zpBTEiDQH5boftDcbFdiWtp12DY4LLT5DIcCtTISX9gTo0bHw+XLyl5JK9TUxv7JFm5yij1kESF0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XEZezB3kjCFXFO/vT3eEtUOQgNvHFlaEnMWLW+PXwrw=;
 b=nygjlRu0xgC2uXFSlBZeJMSCoxBT5YKYsN2AUnkXXHN8kh7h7ZctS8qFhOCWoR2qiHdT6nAysou526FcXadwWqO2fmgYD99ub0DFnZRVf/Hv8dPgoZ++Lg0dbO+7p02Gr6CZ1gGPNpEFTuMG7MpJRTezNEvf5C5Fi9PiTi2lm+v0g2AFmpoajkvWwomY7tECtANi7o5tEFCsdSTz8d5OVK6XNZ3XQ1E1WG/vB02uoAvtrxPwyONUG2xjexuhZiKCurLh3JV+CjhSyUhkcxanm4m5/Caejywz2lGgYgfjA+yVlgdMmKfzRvyWiiHT8MZBfBkAZ5blRTrUCPgAv3HG+Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CO6PR12MB5410.namprd12.prod.outlook.com (2603:10b6:5:35b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Wed, 31 Aug
 2022 01:02:05 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5566.021; Wed, 31 Aug 2022
 01:02:04 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org
Subject: [PATCH 2/8] vfio: Rename __vfio_group_unset_container()
Date:   Tue, 30 Aug 2022 22:01:56 -0300
Message-Id: <2-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR06CA0006.namprd06.prod.outlook.com
 (2603:10b6:208:23d::11) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4535924-d6cd-4304-06be-08da8aec6ac0
X-MS-TrafficTypeDiagnostic: CO6PR12MB5410:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5r3n9E9wczChubcSXYW/qVMt0PEWYFXxGoqmfbTqo8BhAIEmGnGaEvT9vakyc3Ba3J5XtnbK7obizzNI+QPww6iWzyf4w7NsZeV463mKHXSnEwGOInbWMHMNv7rfPxVLYH+PHuCPy9NAXYpRmegctHUMOFT14RM8QFnk04dlnCJ9664WGejhKHbJOoOuCDZBINDY39QzqXN4U76wiBiNLcjGhMHz3pBnSDstSTI5wVMgBMXD4rSD0NLXuVERsPQH0ybSSWvcPwe/Oi0Smrx7mvgWU/N4i4VrtEfM9KxpJgMGjN/oytJ1AWmp6ru1bmyx9X36acawNbOq1uf1pHaY/EdJg12wII6U+OlFUImgPBsztZHp9AEiqjmk7dm0NmfeJ8pHyd0iiFVu58X/jRkcZlhlDxkd5zFdgChMomYXSReQcEbwU1ielWZtREmOwq2RdoDs0CqLA81k7af8zoGCAu8NRTZddwQU5n0SDi/hmgHfWlPmQkdWd+AFiomq4o4CMqPIw4Zud2PydVVOmdUlO4EKewuPPPq5PZcG9tIM3k8Sh0sXVPScXkEY73QfqMGvSYxyxezrwe1pczPmQlYa58+iRLEB87O+j96p5IktRghf6qn3H9x8m+8CgE49kaTA7A7ydkGwyCeW9ygngkNS9U4ft0df7TzGZDScmyH1ALqnDJwxge8L5hZ1R6lm286GFFBJL2GF7n/Y+EG58uE3UZmmlxv/m+pJ6zOlVH5vH/Ya5Ci3bIgKJ0DBsBbwU8lJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(6486002)(316002)(110136005)(66556008)(66476007)(66946007)(8676002)(86362001)(36756003)(5660300002)(8936002)(478600001)(41300700001)(26005)(2616005)(6506007)(2906002)(6512007)(6666004)(38100700002)(83380400001)(186003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z6rP4lwBO/BHhnAkOtfZHVF0AKZTIgQ/9+DFkIpZZD6KBdvEB5KSm57Y7Vdh?=
 =?us-ascii?Q?REhOBNYUu58JeuVyPTm4xw0vBzouIVhyRZOAd+6+p+jNqlHhyfcw+ATsjXdE?=
 =?us-ascii?Q?yBs8Nlhl/ZpioeukiH/+QXPyLDtHPOJZ2j1MwqvMBUO/15xCBaQc6HUMsveC?=
 =?us-ascii?Q?xYbLWmDpnu9G00Z/yh27V371hVBMJizpzh0MmOJoogRA5UgdiRNTxEao2Prv?=
 =?us-ascii?Q?WiEaWNX8rpjymOZgIuOaBlaZRfBEk8mtoA+4xjrt91Mn6GJl/SyUjdKyJWrb?=
 =?us-ascii?Q?AbUC5mMmLsx1QWeOlvbHRpP7IGfAfPi7PkIb39HaLcsBPnSenfmhzb85+T3L?=
 =?us-ascii?Q?kGwff87xekFG/MJZMxCMqiE1nZm6Xv13WxFWf0TVRqDcY03QX27s8uYoWbP7?=
 =?us-ascii?Q?dwYwmxpMJ/7Jwq6OVjltc7Msu0ZaePb5i5A1T2ncBsa1ECO8uVot23lqD96a?=
 =?us-ascii?Q?G0f3JTchqkLllWg6vmMLO653njDDlHhGDDbHMYraMCbRIZgeFjdIwpnk1UOD?=
 =?us-ascii?Q?PGxv7zxHU75g8SLzqrLq2xxyJulF8X8oAX+dArb70QMJppza1521eTPq8Kvb?=
 =?us-ascii?Q?WcCrsMsW+Vd54xXIw/lq1wSqD2AF98pDCDypTXxjNjvJHmYG8LxzUXukYe1I?=
 =?us-ascii?Q?M+jEfQ5u1rdjVQuwYiP06aW9Q5ljCM4b1jBtts/p25l3W44Qazs4OgZbq9GB?=
 =?us-ascii?Q?9lqpLE1sz1V9s+KUPkaNRchQgp3YeRGkEhXHqQFduvj+0iQq/oi91bqXkHxL?=
 =?us-ascii?Q?8ncXBsePBJxlBynU7PqSrf1ZUBn/pjRLGKw1Yj4QzaQImvOtkuhz+VZU5EwT?=
 =?us-ascii?Q?+pLMzjAMsySZizR0DHM426ifzdoepaAmRy/A4vSvohLeFvCP18ZpCaPkbiWU?=
 =?us-ascii?Q?FULvNYqQXHJHLlZyGjkaIOXs3fFSJYZc0ZvXcTutkq8IGXEIdlUFrqAcvQaf?=
 =?us-ascii?Q?9XHBz8OW9obaGs7YPZ4i9RjxWy5u7OLS68v7BJzSztYZYI8nM+tsItGVffmm?=
 =?us-ascii?Q?XEqqQwe4JWtLPxImr7V/JRT6/TTYT7DiVJDwPUyI/mgcDjOUo6CtnmaHXlON?=
 =?us-ascii?Q?WIDorO5yLeKT2iJvHYxpbzkqGbJeU9pi8tZrl3ycFcWDGlRCoI922AiganYa?=
 =?us-ascii?Q?FiSBkWAgmFBZa2kwngcLgyVeVm1/ELU0FpTA8EaVJErNQ7Ed5u/SXIuOKsED?=
 =?us-ascii?Q?tsYmBGY83hEJAnDu2zT/h1QS9UE8SeJsGT82m9vEG364aEGmFzoqM3iCYpuk?=
 =?us-ascii?Q?nZfMbLsV/dbJDy6crrcQXU5icCeX8Qvj+XUwjkv58/AiWuvl0yFV5m4Mpt7l?=
 =?us-ascii?Q?N81COIrXgS63kagnZJtIx5jDazU6mQjDxFCVh0YsAA4ez7br27Luc/dBxcHb?=
 =?us-ascii?Q?pHnKPM/3Onc2osedV8AFtPo/lNf9+oeSE6g6ivzh7i5MhGSzhZdzQQlONQC8?=
 =?us-ascii?Q?rUnxbDuiWHxPGlyMuzyypQIZ2DPLPNWdb4xh3XDS/PmON8PDq4Ne7gtOflNh?=
 =?us-ascii?Q?ZGRYYpRf15csTrZlbcEIYkfGp29m05pr0iL1JYfELPzELOKO3LInLS09PN1p?=
 =?us-ascii?Q?/cE8RyNxSJNRy4NIGiY3wSokc8aNm81b/3S6KRNn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4535924-d6cd-4304-06be-08da8aec6ac0
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 01:02:03.5480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yhrW63z1POD8HBrjV1/BCiuJYG0Wnk7dn8vrw8qKK+jFXpIqkrnMcCm1ncBy6Gro
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5410
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To vfio_container_detatch_group(). This function is really a container
function.

Fold the WARN_ON() into it as a precondition assertion.

A following patch will move the vfio_container functions to their own .c
file.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index bfa6119ba47337..e145c87f208f3a 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -928,12 +928,13 @@ static const struct file_operations vfio_fops = {
 /*
  * VFIO Group fd, /dev/vfio/$GROUP
  */
-static void __vfio_group_unset_container(struct vfio_group *group)
+static void vfio_container_detatch_group(struct vfio_group *group)
 {
 	struct vfio_container *container = group->container;
 	struct vfio_iommu_driver *driver;
 
 	lockdep_assert_held_write(&group->group_rwsem);
+	WARN_ON(group->container_users != 1);
 
 	down_write(&container->group_lock);
 
@@ -976,7 +977,7 @@ static int vfio_group_ioctl_unset_container(struct vfio_group *group)
 		return -EINVAL;
 	if (group->container_users != 1)
 		return -EBUSY;
-	__vfio_group_unset_container(group);
+	vfio_container_detatch_group(group);
 	return 0;
 }
 
@@ -1329,10 +1330,8 @@ static int vfio_group_fops_release(struct inode *inode, struct file *filep)
 	 * is only called when there are no open devices.
 	 */
 	WARN_ON(group->notifier.head);
-	if (group->container) {
-		WARN_ON(group->container_users != 1);
-		__vfio_group_unset_container(group);
-	}
+	if (group->container)
+		vfio_container_detatch_group(group);
 	group->opened_file = NULL;
 	up_write(&group->group_rwsem);
 
-- 
2.37.2

