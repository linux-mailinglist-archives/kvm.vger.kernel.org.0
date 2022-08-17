Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4C35973AB
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 18:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240736AbiHQQHi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 12:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240688AbiHQQHb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 12:07:31 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9816CF45
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 09:07:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y5u2Ln2XmiD+1lammYT9aW+RigeEz0aaksqXfyXmHbY8CHWioy2K/q5PJb1cWmmZ4uB49VTdyYPgIBAUndBilvlLKP0FvlCEQN/7ZgIINuHAMkEJ26/bclx/5lsc9MBqgzeRYMLyZ5gVHOLbkVvKGZjv8VuVqNvPJC6Z+O4Y55G/DUpM/gjYUlt08S6HwemkYsd0hiENbxRDIMOYvlrTZnurjZ3VgN/8zMvfwzyiiBR6+Rg3xhe1yK/0TKJeE/33J6x0aUyRwLVsQ7j74EMJ0JIRuTWMr2IOYUveyls9aO1rqFJDIAMGD/3kLVhpCYXNZJmZOiT6d3/hMqxJ1MlTQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CSmL/er0JPEPFF0ZoWK5pSvEUZ6hjaxX3gNYA+Y28yI=;
 b=JTxekmvCyH+X1fstEbrvx8rmKUfdcpJxlmZ/+WyGvSS5WHyKvxF/zwsvPiCNBI3pugSW3MOFVml7A7iCee9LVFDP4Tems+fH5pYV0ZDaDfmhS9gFvfzqHzjrtsEw12osc+ytzf5+/fbZA9v71OM/pGI/FEVMr7ECMzmo4L0L1j+MZ3Hh2DH8zmuezg29LqieSzUAErZcYUqqKs64/ESTUMh/gvdVLAjItWJlvGnrN1PUDqyDRn6zNQE4O2auT9TvJtrDS8EGAwNV6D/G4HTNcXx9N0+Pr5UkU0ceN7sFJ6qeJylRiuGDrCPZsIlrkAO1a7ZmoWguMi6/PosZzVinAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CSmL/er0JPEPFF0ZoWK5pSvEUZ6hjaxX3gNYA+Y28yI=;
 b=GrDOwNsulUUhGPoZV7g7q5wTGNMoEXa0HDP7PsWHtofnVPxNFnxybtbx2j3PLptRMThxDzhtYUMmxBJ9k2lYpmED3pxIYYa7k82LlUWrJZp3Zq6jaMpSCEY6GgK9xBza8tO4pRAruiL+yJaA5maJQfyMBJ0os+NPW+eL1cJF9JIHQbQLezlNU+AMDtEKoBPP6oqZocS+L1sJsO0YVt8dSmSagdGHBdctRH3wPaVnGuKMF9/ZrxYix4Yqdae5OiriIsO06sd4YnPQg9Hu5PRg+dwPgWhU/OlvZl+iamQvgZ2pX2cSSf8xu/VJkHE5R2/5YuOPgdYDekMZIObeSZ6bKw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY4PR1201MB0216.namprd12.prod.outlook.com (2603:10b6:910:18::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.18; Wed, 17 Aug
 2022 16:07:26 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%6]) with mapi id 15.20.5525.019; Wed, 17 Aug 2022
 16:07:26 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: [PATCH 7/8] vfio: Follow the naming pattern for vfio_group_ioctl_unset_container()
Date:   Wed, 17 Aug 2022 13:07:24 -0300
Message-Id: <7-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
In-Reply-To: <0-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR0102CA0066.prod.exchangelabs.com
 (2603:10b6:208:25::43) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19305cfc-49d1-46a8-19cd-08da806a93c6
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0216:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I3TmGTft0/dhd/9+ixSRMvXUornyKiLRwYfyueyTWp4HAieK4vX1x+BjyZBGeRxj6wMgBm6a2XIiCe2IL6kJJXFgrvrwvUNB6VtO0o7B5LhWzglIVj5P2x5FKRipiKQ/Ym9wngJzTY7nxtW3mcz8AOzHVP/3bMExP8GuivDe3IZI5kb4o9ODxPQ/T/FrJksRiX9yhJRgZmUSJt2aKlrXF96Svo1qznNDHSyXmSF8TcQg4iEHHXlOsGx1xtqMQOsfB/iXz4t5yzPibghglfAfN3GN72UdiFmPB/KI0Qoey8bT4F5nHDAuGeSMC3uokJYf0N3fG4M7BE78Wlo+bx6IJYq8o1q7wdO77hm0/DIz4KMYOAbGjAS4RLt1JyHxQy8U7F4/dLMBcOzZlvRYNqU8/WpbjH7dzk3zcSlfPNeV4u9FA5ll60AFA2OxmruqlWtp094LweFst74mcqrKcqfKrSZz+7rzs4k1qLzDpG2Uop6OPhldeUw8P0FsgaLF1dcbsj3nm+6B5GFrLmhNZjwB/6Z+Ga2U3ePuIzC6EJ4y4Ix6hmwG56F9XiDq+iLbYfigAZ6mbbq+AzX1CcniGQ5fu1t8z0KiJzWpbJITng5AFMnsE9GPKCd9LlIL37SVIqqw54Thx9slXgrYF8RLstgASfp7nx4AWFgdETyopdb9hmQg3T+Tb8kvshf0uqRbHdI5g6FmyJ93szhra4CFYwOaCtf6GCZ4piRPZ3gSRhyzMbWO1VGYpONhpjenMzNo3eET7AVhflBJb8K9tzbHlnoly1A283+h3kQgkmHEwaXrm2o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(41300700001)(6506007)(6486002)(26005)(66476007)(2906002)(478600001)(8676002)(66556008)(110136005)(36756003)(86362001)(316002)(6512007)(38100700002)(186003)(5660300002)(2616005)(8936002)(66946007)(83380400001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xm+PsCYn81ExhlAgqr4OWhibHUh3HDQOOkQLf5nXnyhiqqHBtqa3oinbCDhF?=
 =?us-ascii?Q?7Zzx2eOpuMOiMHc3vNWgFcX6DzFnB+7/UjPqP6K/6emyJqZRpM21bq2q05p6?=
 =?us-ascii?Q?0z7yvAbDWcvIb7FHeGq8Lxpagcx1vgsC1aS7fKWok/dJnv4jKv2IYWqN7O2+?=
 =?us-ascii?Q?GFGiSIxITqoiW9d2rLxyJYli3ygvZRJ7EwzcwhDVNr+HrMQDqUlSZgBODSGX?=
 =?us-ascii?Q?5t3lW6OBd5LPHIDukAPr1Cq9Y/AkhLqs2BCQtkRe4v8KjHuPulRR6F/Ck2Wa?=
 =?us-ascii?Q?HPGb+rVhjsjmKbG8k7gXP4fD7ALHJiWgyrsxKetUzE/Gw0T2u3VfAxD71Aqo?=
 =?us-ascii?Q?nit4cM1I+V+xQ4k8BU1qOEP7Ik2IZbYK5DEoM4aMW5sMmcNhyaxT0yQoiDMu?=
 =?us-ascii?Q?LoAcmRt4Emru9oTx0vlwM6znFyllqgtNeBs6PMblRG/y7gr6+ge1uyPnViZt?=
 =?us-ascii?Q?5okzfK/HU8UbIFgCzwsehQboHRiv+hSGgzAOupsrb3q9g3J9kyfsOI4B4LNE?=
 =?us-ascii?Q?hFZ902GMlOlke5nkqHrdV0TaMXQdkEZZoLnSGpthm0pySqO+n+nWnlWsHa73?=
 =?us-ascii?Q?1hLt+vGNyoXQ9Frr3gPSE0REpTf6w8IEZsZ1bC0tm+SPzrF93EG5kY1BMZ/k?=
 =?us-ascii?Q?XxIr0ltHG4ntOyGjIwTM7WJaMLAHQdncI5gSP2q1jts9VhQLgAUz3D7Qnl/G?=
 =?us-ascii?Q?14ht8cA5p6tfZfN690nEVmAQEHZ+9PhSLNO57GMbjFCwa/UuoC/74vhUsG73?=
 =?us-ascii?Q?BmlKPbB804/cnnXC4Svz2JmyM04Vs8zW3GKd3ycfyJG97VS8cOG+ELoR7nrk?=
 =?us-ascii?Q?Ubq+cGuIqwXT8b0Bmsf7J2b4MQb2NFAPbYjwqLbtbZvMvx2C39vOP9mZGqCf?=
 =?us-ascii?Q?3HHKnNF2zmkzLTea3BuMiwWm0OjXtbH1jBbNcFhwynjQZB4Cqg+Uu8LsB4MJ?=
 =?us-ascii?Q?UTXG0b9/Y5tDqSZ6VyzFZKz7PBZW5MPcb5jdZf6qtXeD7d9MnSb5vTpxGEj1?=
 =?us-ascii?Q?WwwoOLu3m+B04bDKVeAIxvuu77CeRJXXy6TTCvUGzwe6u8GuDKWi7gtIGY8l?=
 =?us-ascii?Q?dd1rZAapM64kes59/443YYIPdat2EHH6IfvnQwDp943V0R5qAtbMjSoQhGzI?=
 =?us-ascii?Q?7x5uN5kPGcMv9cP9cJlqi/1x1NgmzpF7XlsVGU5VEmHLamM7ymVlFc9vAdNw?=
 =?us-ascii?Q?o2ahJ8YEgm6H9OaPobPWtVpaTg6JWiCMdPv6Piw0hcDJrW/dPMZ6gHWjc2Uw?=
 =?us-ascii?Q?CGIwvmfWjdQXU4ykFC0yUzneL2LR3lsASPCTP48/HBYob321KKvOFxaA+4re?=
 =?us-ascii?Q?D6VnVyFZ40QYOSfgfk1CpjZmMrh+y7OWLODwABUhf13EWjzQmZNitufKYkgA?=
 =?us-ascii?Q?r/Si/jBryi8ND1u/5MnhI/NIjH+3dVSUKXcgaq8YdoWR2qTXP56BD7flcBFN?=
 =?us-ascii?Q?8z3pa66fRPvPREStRm7BjWP/u/QoLB+s5zeH7l2ePeWrFpRsbdGdpDn9QbUZ?=
 =?us-ascii?Q?B65yMiGxJcDF+8De90vx2hxoZZU4borxqJ6YyTSu7KdQhWsTt7FYbGs7S5Ui?=
 =?us-ascii?Q?7IQqKBWbJ1OeD5H40QlMfVzwyELVtZXT+0GT54o/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19305cfc-49d1-46a8-19cd-08da806a93c6
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 16:07:26.2968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8yc3+4FIZTDRCX+hADQTISLuHtsIGGceaqlmNVM68AbgwKc1QN1oz/h0foJ+iz8H
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

Make it clear that this is the body of the ioctl - keep the mutex outside
the function since this function doesn't have and wouldn't benefit from
error unwind.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index f7b02d3fd3108b..78957f45c37a34 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -968,7 +968,7 @@ static void __vfio_group_unset_container(struct vfio_group *group)
  * the group, we know that still exists, therefore the only valid
  * transition here is 1->0.
  */
-static int vfio_group_unset_container(struct vfio_group *group)
+static int vfio_group_ioctl_unset_container(struct vfio_group *group)
 {
 	lockdep_assert_held_write(&group->group_rwsem);
 
@@ -1271,7 +1271,7 @@ static long vfio_group_fops_unl_ioctl(struct file *filep,
 		return  vfio_group_ioctl_set_container(group, uarg);
 	case VFIO_GROUP_UNSET_CONTAINER:
 		down_write(&group->group_rwsem);
-		ret = vfio_group_unset_container(group);
+		ret = vfio_group_ioctl_unset_container(group);
 		up_write(&group->group_rwsem);
 		break;
 	}
-- 
2.37.2

