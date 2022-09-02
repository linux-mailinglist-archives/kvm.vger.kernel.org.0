Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFA95AB91A
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 22:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbiIBT7z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 15:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbiIBT7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 15:59:43 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2075.outbound.protection.outlook.com [40.107.237.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35BE27DFB
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 12:59:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bcOaQVaBY/7fVcgNjVsC+YV91d2M8hobkYgR1vOI5FfxlQVCy1Ong2NOdOMHhvNbcqENIaC83UbLpaXejiIePhjBiQPnyRem2/r0G3S3B751HwuV3XExgIMd0MfHqOgEu3SMMRhk8IMEZMxGL/DcVPe3Zu+X7KxP0hapnYd4sF7ADLgAKxur+gR9/Mx55znWWK4w99Q35kJrkh2SZ7Sew6nxMPXLPBWVR4qF9N+Azb++luH+h2ewYhwK+pP7ls74h3tEDmFp1a6+/6DQotyxawUNK3Vt3DzXmw+/h2ks8wDe9YWlSqRgsFQS4nU3r9ctSJ4jgu96CWCzwXJzzS6gnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BqScPx5CK4+ZsgI60IkeKemGw3h250JtVuHRFSgNE7k=;
 b=YakMTYDx2nCyGHEP85leN5imBChZTc0wFC+XG+xf5KL/5DvBzrWeungzsTdJvefHq92SERXbGqz2ygKnymDRDoTiBNW0AAxkXWeuhvVvKbBGaNLO2vxDUQStBko/x+IsEpk3icH5JsrnBwwKd00ND/PbRpSjZfvEJ1tU0DWV14/woE3g5P+xSzecQKN7Fbw1/D3fkRknV79Ti8i63B+lQWZpoEYEyFoguWdDVOMZgf30k8uXr4pw3S7+dYXpTGh0EO+JYM7xRN2diH3z3+gnm+utoIn5gj71LOMbu+YEJ9xqYNmSaUA9j4WHGSu6Mo2Up7OYi3nTdAG9LQtXqWJ20Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BqScPx5CK4+ZsgI60IkeKemGw3h250JtVuHRFSgNE7k=;
 b=AlR4LTG9woGK7Yh6hfY7+9cWv3NIJCCfyPtd6aiXmc/kmbepgY5hQEv0/bxt4+SWFu0dpQ7n3jWFpd8G9a6ImOG5OODQDls7/A5rgCHQJOhRgZvlXSAEfWdKwOw2ee5rQqVaMlKv8ggU/xBwU7kfa/XNWo4u420Hnlgn57amAQHlnz07pdo1jbdeWrJUY2kziI35En0DSOtbRRkyl92sM+AZ9oRdX7ZLu422KZCT0xexh5vw2PFqdItyVfELghwRmn9T7RAe71vNttJwH6APY3ykqJpyu+oRCfSDpehG8edHMUB8Btu75NpJgpBZgPHKFZY2KRJ6N86LhuAnFpfFoA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM4PR12MB6566.namprd12.prod.outlook.com (2603:10b6:8:8d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 19:59:32 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5588.016; Fri, 2 Sep 2022
 19:59:32 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH RFC v2 08/13] iommufd: IOCTLs for the io_pagetable
Date:   Fri,  2 Sep 2022 16:59:24 -0300
Message-Id: <8-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR01CA0002.prod.exchangelabs.com (2603:10b6:208:71::15)
 To MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4e105a0-231f-4bd1-fbb2-08da8d1da5fe
X-MS-TrafficTypeDiagnostic: DM4PR12MB6566:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B434539r0kPpt/K0kDqMB4MUTnEcMOWc4Ph2YgF2SdEd6To8K30oeszKTHDyIXUVCpGsowBgLgxiSapPkJUMCRF3vmmwbo/hZnFmuuaF3jQtXmCDjFEwDeWWKy7cJQH15ugHAfdgvp9vpu1Ta0JDKyHfIQDYnw/giu49M/MS9zPFCRDqj5LofAGmjXSfGKvv3yj/uWRcrlcSZqD1C5Rf5Lf65kywwPn3YkQonT2mUFII+tRMV30K1mTX5t+yGz6XcWgujjP9jIwhVNyuqzGjC+IX3Wm7Tx1SLMxCrKM4ywXGI7Bq2t6FFxQXBskuODRYWs6RjlUqzflThEqb80/VAtx1ZMvpFMN7ML+owOtQwRAa0oqdRibfmX1VFE6JoTjhQjk7DKSJS9mTIsNozmThyQbgrQLS4ZqrtTuW+yQqDVhvVmWSHlZrvEmnnhsovaTB5IwDfQoFfiNR+s9VCdOrEGdNrIYtx6Z52PCv4CYvGOJpvVyMvKz0EIy0jMoa5aj3II/XmWTFyEB9PdDYbY+4UVktWlDUh29RrVEHks5PV84LX2K3LlGoHUNLHQHnuxgTR0XK48mLDIHY5aHPK2iX4ujG6uqm4cvWmI0tgJSgEB3kpfYrgzXM54Y4LA57oW80yOYMTtW8IDhYysWN0Inh9C3JPDjZID0S4kCobp1U86QHR6wL8QFTZTCGvHjogSFSsbOmj7OPfGbiIoEqqe8D8H+9cP+FGaBH5Gbyn/KR1E416iOptXWGD5wUH3UYtXo20yd4gERbFo/2vQ5W7gWiWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(30864003)(5660300002)(109986005)(6506007)(36756003)(83380400001)(41300700001)(8936002)(6666004)(6486002)(478600001)(2906002)(38100700002)(66476007)(8676002)(66946007)(66556008)(4326008)(86362001)(54906003)(7416002)(26005)(6512007)(186003)(2616005)(316002)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YLSnxWLIy2YYFLYzpyVEAlFti07hN5l7vM2CwP3kv2TYbltR6zZSuQGpdDfH?=
 =?us-ascii?Q?p6ORcfNG+aYOBZprdvEnaDRFObXe7P0CcdbegKKB88sfR5ydMNAG95/zOFVw?=
 =?us-ascii?Q?qabhDvJ0EBSc4C2NHW/K44aMRCreHjHjVImHumpI3VV1biSHYq5RssD5DNNC?=
 =?us-ascii?Q?ab7OCh9FU5HPxc/CJyxR6pAXtfAulGygL+9aeaRg3VEFVhzdvj2ogp6SkFZ+?=
 =?us-ascii?Q?3eVy5tM4nimeO1iypOzXXz5Ll2hTRRR8m2cY09MAPrUbpOB3H6xVUV4Rw1Yx?=
 =?us-ascii?Q?v3NGi8+PEeNAIGHjK4iVn0yMxk0Yt2GxEDnfM/p+hTOdnJp2RT9lIsvuuLhU?=
 =?us-ascii?Q?3P+AX6SM1cpKA9+3D9h41POanZV7WkJA3NgRjemiY0qB6boqmkJQ5tqnPC+3?=
 =?us-ascii?Q?cyX7/1wsiukbsCGb+s/fiEzJKZXz4ejGs0PvUbaqyedoYUhDIf5WGF9RYCnI?=
 =?us-ascii?Q?JMpejaV7whZ9uxq9DYVZga+x6Y6RRX0uHBUyW3Z00VqUZB/OgdXjmvqJBcZM?=
 =?us-ascii?Q?eKoOn8GepjTKub21rpeJ/yHcjXB+f0B8fi3awW44LpSubRz1+H17jKJnoTF4?=
 =?us-ascii?Q?6gE8gZhcQqa3lrnYGL6aa8vXpUJrkaw9ROGrssGyZU4+QWGUF7gVUymLm7r0?=
 =?us-ascii?Q?sR00EIUQV6JL0z6aSQFtWtEbj4XpH+HAUTVWwF5di75P9rT1YKvJMkxnyp6O?=
 =?us-ascii?Q?7mHl+Je5ilpkcpGgb/agapAI6Mnsu5VQXOAZaHzbQh1UBoiV+bTQgkVPAx4l?=
 =?us-ascii?Q?RZwt0RSMlxD0J3ljD5Dgmqa3rRBDNkiEV4kfIWo7UIikWov6HRsqcwwGnjpP?=
 =?us-ascii?Q?LRZkz+kq8h6tjGwGytsZuGWTob8F5S3IPLv6vj8yX2XGTGVQcVwOE1bF+wum?=
 =?us-ascii?Q?rSH3DSV2BOepzoif1GYfZ3M6gGkWqKp92a3IZi6yjM2JfhLlq9Ye9bL7BNpP?=
 =?us-ascii?Q?wNmXrYLsQ37Zb1x5Ry7hE8kHQi36gQ7MuVTObj/LkgUGfICxf1F1009vcGlP?=
 =?us-ascii?Q?lRb4/faeiXLarPnkics5BUVJ0NTbGcp2x0hTlyxeeLKFrNUZJ1Bz2Zqb720K?=
 =?us-ascii?Q?KJ4QIW4BllHhpaQlD2q3e1ToO011r/DuAUcnR3soZ/gZb7XN3/hjk6i/dM9r?=
 =?us-ascii?Q?RCgm3ajaz9bZEimIqI7Eha5MZZ0/uR1MEoNyMLp0Vp6dus+yfzpg9KSUPjsl?=
 =?us-ascii?Q?y36BOIz6FeuY3s5LSdE3WkEstZc2x2VjsfEB1zym/VnGidSA1J36rKVpfcpj?=
 =?us-ascii?Q?bMH4I/DE0LMq5B6NbDzFzMbsFtg4ygUcsgwQk/G/pc6Jx/t/so/Q1me9ee1V?=
 =?us-ascii?Q?aconiJ+rIAHyepXzTzZ5laJA4YWvp2RbUwYBECi6IYCl4niluQkFnSYIQbN5?=
 =?us-ascii?Q?p9Fios4l/kFFnlOcDpiJHuHOkdnCijuTKx4vKz10UGB/y+vDIfkrDG3uTLGM?=
 =?us-ascii?Q?NvSbdGhbVbi+NNZqEqVBqWzfMlbIdzZ42CGeALNEub8H+rPgr8UUzz+aWocT?=
 =?us-ascii?Q?P3N/DIiNrSnRHPMPxI6HJd2cwezSCEYUOWqp/ikJhq5Yc11uyuRwxk36RsIJ?=
 =?us-ascii?Q?8dEy3hvuasFocT/L2MTK9watHnbs8quxN2rxXd5l?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4e105a0-231f-4bd1-fbb2-08da8d1da5fe
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 19:59:30.7052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dOkUrS/WxdOyRtNa6Jw5aAr0/3fk646tirtmgcvZJ/oXdYkrk/R+AAhJqVXhtePT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6566
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Connect the IOAS to its IOCTL interface. This exposes most of the
functionality in the io_pagetable to userspace.

This is intended to be the core of the generic interface that IOMMUFD will
provide. Every IOMMU driver should be able to implement an iommu_domain
that is compatible with this generic mechanism.

It is also designed to be easy to use for simple non virtual machine
monitor users, like DPDK:
 - Universal simple support for all IOMMUs (no PPC special path)
 - An IOVA allocator that considers the aperture and the allowed/reserved
   ranges
 - io_pagetable allows any number of iommu_domains to be connected to the
   IOAS

Along with room in the design to add non-generic features to cater to
specific HW functionality.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/iommufd/Makefile          |   1 +
 drivers/iommu/iommufd/ioas.c            | 316 ++++++++++++++++++++++++
 drivers/iommu/iommufd/iommufd_private.h |  28 +++
 drivers/iommu/iommufd/main.c            |  20 ++
 include/uapi/linux/iommufd.h            | 188 ++++++++++++++
 5 files changed, 553 insertions(+)
 create mode 100644 drivers/iommu/iommufd/ioas.c

diff --git a/drivers/iommu/iommufd/Makefile b/drivers/iommu/iommufd/Makefile
index b66a8c47ff55ec..2b4f36f1b72f9d 100644
--- a/drivers/iommu/iommufd/Makefile
+++ b/drivers/iommu/iommufd/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 iommufd-y := \
 	io_pagetable.o \
+	ioas.o \
 	main.o \
 	pages.o
 
diff --git a/drivers/iommu/iommufd/ioas.c b/drivers/iommu/iommufd/ioas.c
new file mode 100644
index 00000000000000..f9f545158a4891
--- /dev/null
+++ b/drivers/iommu/iommufd/ioas.c
@@ -0,0 +1,316 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES
+ */
+#include <linux/interval_tree.h>
+#include <linux/iommufd.h>
+#include <linux/iommu.h>
+#include <uapi/linux/iommufd.h>
+
+#include "io_pagetable.h"
+
+void iommufd_ioas_destroy(struct iommufd_object *obj)
+{
+	struct iommufd_ioas *ioas = container_of(obj, struct iommufd_ioas, obj);
+	int rc;
+
+	rc = iopt_unmap_all(&ioas->iopt, NULL);
+	WARN_ON(rc && rc != -ENOENT);
+	iopt_destroy_table(&ioas->iopt);
+}
+
+struct iommufd_ioas *iommufd_ioas_alloc(struct iommufd_ctx *ictx)
+{
+	struct iommufd_ioas *ioas;
+	int rc;
+
+	ioas = iommufd_object_alloc(ictx, ioas, IOMMUFD_OBJ_IOAS);
+	if (IS_ERR(ioas))
+		return ioas;
+
+	rc = iopt_init_table(&ioas->iopt);
+	if (rc)
+		goto out_abort;
+	return ioas;
+
+out_abort:
+	iommufd_object_abort(ictx, &ioas->obj);
+	return ERR_PTR(rc);
+}
+
+int iommufd_ioas_alloc_ioctl(struct iommufd_ucmd *ucmd)
+{
+	struct iommu_ioas_alloc *cmd = ucmd->cmd;
+	struct iommufd_ioas *ioas;
+	int rc;
+
+	if (cmd->flags)
+		return -EOPNOTSUPP;
+
+	ioas = iommufd_ioas_alloc(ucmd->ictx);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+
+	cmd->out_ioas_id = ioas->obj.id;
+	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
+	if (rc)
+		goto out_table;
+	iommufd_object_finalize(ucmd->ictx, &ioas->obj);
+	return 0;
+
+out_table:
+	iommufd_ioas_destroy(&ioas->obj);
+	return rc;
+}
+
+int iommufd_ioas_iova_ranges(struct iommufd_ucmd *ucmd)
+{
+	struct iommu_ioas_iova_ranges __user *uptr = ucmd->ubuffer;
+	struct iommu_ioas_iova_ranges *cmd = ucmd->cmd;
+	struct iommufd_ioas *ioas;
+	struct interval_tree_span_iter span;
+	u32 max_iovas;
+	int rc;
+
+	if (cmd->__reserved)
+		return -EOPNOTSUPP;
+
+	max_iovas = cmd->size - sizeof(*cmd);
+	if (max_iovas % sizeof(cmd->out_valid_iovas[0]))
+		return -EINVAL;
+	max_iovas /= sizeof(cmd->out_valid_iovas[0]);
+
+	ioas = iommufd_get_ioas(ucmd, cmd->ioas_id);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+
+	down_read(&ioas->iopt.iova_rwsem);
+	cmd->out_num_iovas = 0;
+	interval_tree_for_each_span (&span, &ioas->iopt.reserved_itree,
+				     0, ULONG_MAX) {
+		if (!span.is_hole)
+			continue;
+		if (cmd->out_num_iovas < max_iovas) {
+			rc = put_user((u64)span.start_hole,
+				      &uptr->out_valid_iovas[cmd->out_num_iovas]
+					       .start);
+			if (rc)
+				goto out_put;
+			rc = put_user(
+				(u64)span.last_hole,
+				&uptr->out_valid_iovas[cmd->out_num_iovas].last);
+			if (rc)
+				goto out_put;
+		}
+		cmd->out_num_iovas++;
+	}
+	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
+	if (rc)
+		goto out_put;
+	if (cmd->out_num_iovas > max_iovas)
+		rc = -EMSGSIZE;
+out_put:
+	up_read(&ioas->iopt.iova_rwsem);
+	iommufd_put_object(&ioas->obj);
+	return rc;
+}
+
+static int iommufd_ioas_load_iovas(struct rb_root_cached *itree,
+				   struct iommu_iova_range __user *ranges,
+				   u32 num)
+{
+	u32 i;
+
+	for (i = 0; i != num; i++) {
+		struct iommu_iova_range range;
+		struct iopt_allowed *allowed;
+
+		if (copy_from_user(&range, ranges + i, sizeof(range)))
+			return -EFAULT;
+
+		if (range.start >= range.last)
+			return -EINVAL;
+
+		if (interval_tree_iter_first(itree, range.start, range.last))
+			return -EINVAL;
+
+		allowed = kzalloc(sizeof(*allowed), GFP_KERNEL_ACCOUNT);
+		if (!allowed)
+			return -ENOMEM;
+		allowed->node.start = range.start;
+		allowed->node.last = range.last;
+
+		interval_tree_insert(&allowed->node, itree);
+	}
+	return 0;
+}
+
+int iommufd_ioas_allow_iovas(struct iommufd_ucmd *ucmd)
+{
+	struct iommu_ioas_allow_iovas *cmd = ucmd->cmd;
+	struct rb_root_cached allowed_iova = RB_ROOT_CACHED;
+	struct interval_tree_node *node;
+	struct iommufd_ioas *ioas;
+	struct io_pagetable *iopt;
+	int rc = 0;
+
+	ioas = iommufd_get_ioas(ucmd, cmd->ioas_id);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+	iopt = &ioas->iopt;
+
+	rc = iommufd_ioas_load_iovas(&allowed_iova,
+				      u64_to_user_ptr(cmd->allowed_iovas),
+				      cmd->num_iovas);
+	if (rc)
+		goto out_free;
+
+	rc = iopt_set_allow_iova(iopt, &allowed_iova);
+out_free:
+	while ((node = interval_tree_iter_first(&allowed_iova, 0, ULONG_MAX))) {
+		interval_tree_remove(node, &allowed_iova);
+		kfree(container_of(node, struct iopt_allowed, node));
+	}
+	iommufd_put_object(&ioas->obj);
+	return rc;
+}
+
+static int conv_iommu_prot(u32 map_flags)
+{
+	int iommu_prot;
+
+	/*
+	 * We provide no manual cache coherency ioctls to userspace and most
+	 * architectures make the CPU ops for cache flushing privileged.
+	 * Therefore we require the underlying IOMMU to support CPU coherent
+	 * operation. Support for IOMMU_CACHE is enforced by the
+	 * dev_is_dma_coherent() test during bind.
+	 */
+	iommu_prot = IOMMU_CACHE;
+	if (map_flags & IOMMU_IOAS_MAP_WRITEABLE)
+		iommu_prot |= IOMMU_WRITE;
+	if (map_flags & IOMMU_IOAS_MAP_READABLE)
+		iommu_prot |= IOMMU_READ;
+	return iommu_prot;
+}
+
+int iommufd_ioas_map(struct iommufd_ucmd *ucmd)
+{
+	struct iommu_ioas_map *cmd = ucmd->cmd;
+	struct iommufd_ioas *ioas;
+	unsigned int flags = 0;
+	unsigned long iova;
+	int rc;
+
+	if ((cmd->flags &
+	     ~(IOMMU_IOAS_MAP_FIXED_IOVA | IOMMU_IOAS_MAP_WRITEABLE |
+	       IOMMU_IOAS_MAP_READABLE)) ||
+	    cmd->__reserved)
+		return -EOPNOTSUPP;
+	if (cmd->iova >= ULONG_MAX || cmd->length >= ULONG_MAX)
+		return -EOVERFLOW;
+
+	ioas = iommufd_get_ioas(ucmd, cmd->ioas_id);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+
+	if (!(cmd->flags & IOMMU_IOAS_MAP_FIXED_IOVA))
+		flags = IOPT_ALLOC_IOVA;
+	iova = cmd->iova;
+	rc = iopt_map_user_pages(&ioas->iopt, &iova,
+				 u64_to_user_ptr(cmd->user_va), cmd->length,
+				 conv_iommu_prot(cmd->flags), flags);
+	if (rc)
+		goto out_put;
+
+	cmd->iova = iova;
+	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
+out_put:
+	iommufd_put_object(&ioas->obj);
+	return rc;
+}
+
+int iommufd_ioas_copy(struct iommufd_ucmd *ucmd)
+{
+	struct iommu_ioas_copy *cmd = ucmd->cmd;
+	struct iommufd_ioas *src_ioas;
+	struct iommufd_ioas *dst_ioas;
+	struct iopt_pages *pages;
+	unsigned int flags = 0;
+	unsigned long iova;
+	unsigned long start_byte;
+	int rc;
+
+	if ((cmd->flags &
+	     ~(IOMMU_IOAS_MAP_FIXED_IOVA | IOMMU_IOAS_MAP_WRITEABLE |
+	       IOMMU_IOAS_MAP_READABLE)))
+		return -EOPNOTSUPP;
+	if (cmd->length >= ULONG_MAX)
+		return -EOVERFLOW;
+
+	src_ioas = iommufd_get_ioas(ucmd, cmd->src_ioas_id);
+	if (IS_ERR(src_ioas))
+		return PTR_ERR(src_ioas);
+	/* FIXME: copy is not limited to an exact match anymore */
+	pages = iopt_get_pages(&src_ioas->iopt, cmd->src_iova, &start_byte,
+			       cmd->length);
+	iommufd_put_object(&src_ioas->obj);
+	if (IS_ERR(pages))
+		return PTR_ERR(pages);
+
+	dst_ioas = iommufd_get_ioas(ucmd, cmd->dst_ioas_id);
+	if (IS_ERR(dst_ioas)) {
+		iopt_put_pages(pages);
+		return PTR_ERR(dst_ioas);
+	}
+
+	if (!(cmd->flags & IOMMU_IOAS_MAP_FIXED_IOVA))
+		flags = IOPT_ALLOC_IOVA;
+	iova = cmd->dst_iova;
+	rc = iopt_map_pages(&dst_ioas->iopt, pages, &iova, start_byte,
+			    cmd->length, conv_iommu_prot(cmd->flags), flags);
+	if (rc) {
+		iopt_put_pages(pages);
+		goto out_put_dst;
+	}
+
+	cmd->dst_iova = iova;
+	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
+out_put_dst:
+	iommufd_put_object(&dst_ioas->obj);
+	return rc;
+}
+
+int iommufd_ioas_unmap(struct iommufd_ucmd *ucmd)
+{
+	struct iommu_ioas_unmap *cmd = ucmd->cmd;
+	struct iommufd_ioas *ioas;
+	unsigned long unmapped = 0;
+	int rc;
+
+	ioas = iommufd_get_ioas(ucmd, cmd->ioas_id);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+
+	if (cmd->iova == 0 && cmd->length == U64_MAX) {
+		rc = iopt_unmap_all(&ioas->iopt, &unmapped);
+		if (rc)
+			goto out_put;
+	} else {
+		if (cmd->iova >= ULONG_MAX || cmd->length >= ULONG_MAX) {
+			rc = -EOVERFLOW;
+			goto out_put;
+		}
+		rc = iopt_unmap_iova(&ioas->iopt, cmd->iova, cmd->length,
+				     &unmapped);
+		if (rc)
+			goto out_put;
+	}
+
+	cmd->length = unmapped;
+	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
+
+out_put:
+	iommufd_put_object(&ioas->obj);
+	return rc;
+}
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 560ab06fbc3366..0ef6b9bf4916eb 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -92,6 +92,7 @@ static inline int iommufd_ucmd_respond(struct iommufd_ucmd *ucmd,
 enum iommufd_object_type {
 	IOMMUFD_OBJ_NONE,
 	IOMMUFD_OBJ_ANY = IOMMUFD_OBJ_NONE,
+	IOMMUFD_OBJ_IOAS,
 };
 
 /* Base struct for all objects with a userspace ID handle. */
@@ -163,4 +164,31 @@ struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
 			     type),                                            \
 		     typeof(*(ptr)), obj)
 
+/*
+ * The IO Address Space (IOAS) pagetable is a virtual page table backed by the
+ * io_pagetable object. It is a user controlled mapping of IOVA -> PFNs. The
+ * mapping is copied into all of the associated domains and made available to
+ * in-kernel users.
+ */
+struct iommufd_ioas {
+	struct iommufd_object obj;
+	struct io_pagetable iopt;
+};
+
+static inline struct iommufd_ioas *iommufd_get_ioas(struct iommufd_ucmd *ucmd,
+						    u32 id)
+{
+	return container_of(iommufd_get_object(ucmd->ictx, id,
+					       IOMMUFD_OBJ_IOAS),
+			    struct iommufd_ioas, obj);
+}
+
+struct iommufd_ioas *iommufd_ioas_alloc(struct iommufd_ctx *ictx);
+int iommufd_ioas_alloc_ioctl(struct iommufd_ucmd *ucmd);
+void iommufd_ioas_destroy(struct iommufd_object *obj);
+int iommufd_ioas_iova_ranges(struct iommufd_ucmd *ucmd);
+int iommufd_ioas_allow_iovas(struct iommufd_ucmd *ucmd);
+int iommufd_ioas_map(struct iommufd_ucmd *ucmd);
+int iommufd_ioas_copy(struct iommufd_ucmd *ucmd);
+int iommufd_ioas_unmap(struct iommufd_ucmd *ucmd);
 #endif
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index a5b1e2302ba59d..55b42eeb141b20 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -204,6 +204,11 @@ static int iommufd_fops_release(struct inode *inode, struct file *filp)
 
 union ucmd_buffer {
 	struct iommu_destroy destroy;
+	struct iommu_ioas_alloc alloc;
+	struct iommu_ioas_allow_iovas allow_iovas;
+	struct iommu_ioas_iova_ranges iova_ranges;
+	struct iommu_ioas_map map;
+	struct iommu_ioas_unmap unmap;
 };
 
 struct iommufd_ioctl_op {
@@ -224,6 +229,18 @@ struct iommufd_ioctl_op {
 	}
 static struct iommufd_ioctl_op iommufd_ioctl_ops[] = {
 	IOCTL_OP(IOMMU_DESTROY, iommufd_destroy, struct iommu_destroy, id),
+	IOCTL_OP(IOMMU_IOAS_ALLOC, iommufd_ioas_alloc_ioctl,
+		 struct iommu_ioas_alloc, out_ioas_id),
+	IOCTL_OP(IOMMU_IOAS_ALLOW_IOVAS, iommufd_ioas_allow_iovas,
+		 struct iommu_ioas_allow_iovas, allowed_iovas),
+	IOCTL_OP(IOMMU_IOAS_COPY, iommufd_ioas_copy, struct iommu_ioas_copy,
+		 src_iova),
+	IOCTL_OP(IOMMU_IOAS_IOVA_RANGES, iommufd_ioas_iova_ranges,
+		 struct iommu_ioas_iova_ranges, __reserved),
+	IOCTL_OP(IOMMU_IOAS_MAP, iommufd_ioas_map, struct iommu_ioas_map,
+		 __reserved),
+	IOCTL_OP(IOMMU_IOAS_UNMAP, iommufd_ioas_unmap, struct iommu_ioas_unmap,
+		 length),
 };
 
 static long iommufd_fops_ioctl(struct file *filp, unsigned int cmd,
@@ -310,6 +327,9 @@ void iommufd_ctx_put(struct iommufd_ctx *ictx)
 EXPORT_SYMBOL_GPL(iommufd_ctx_put);
 
 static struct iommufd_object_ops iommufd_object_ops[] = {
+	[IOMMUFD_OBJ_IOAS] = {
+		.destroy = iommufd_ioas_destroy,
+	},
 };
 
 static struct miscdevice iommu_misc_dev = {
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 2f7f76ec6db4cb..b7b0ac4016bb70 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -37,6 +37,12 @@
 enum {
 	IOMMUFD_CMD_BASE = 0x80,
 	IOMMUFD_CMD_DESTROY = IOMMUFD_CMD_BASE,
+	IOMMUFD_CMD_IOAS_ALLOC,
+	IOMMUFD_CMD_IOAS_ALLOW_IOVAS,
+	IOMMUFD_CMD_IOAS_COPY,
+	IOMMUFD_CMD_IOAS_IOVA_RANGES,
+	IOMMUFD_CMD_IOAS_MAP,
+	IOMMUFD_CMD_IOAS_UNMAP,
 };
 
 /**
@@ -52,4 +58,186 @@ struct iommu_destroy {
 };
 #define IOMMU_DESTROY _IO(IOMMUFD_TYPE, IOMMUFD_CMD_DESTROY)
 
+/**
+ * struct iommu_ioas_alloc - ioctl(IOMMU_IOAS_ALLOC)
+ * @size: sizeof(struct iommu_ioas_alloc)
+ * @flags: Must be 0
+ * @out_ioas_id: Output IOAS ID for the allocated object
+ *
+ * Allocate an IO Address Space (IOAS) which holds an IO Virtual Address (IOVA)
+ * to memory mapping.
+ */
+struct iommu_ioas_alloc {
+	__u32 size;
+	__u32 flags;
+	__u32 out_ioas_id;
+};
+#define IOMMU_IOAS_ALLOC _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_ALLOC)
+
+/**
+ * struct iommu_iova_range
+ * @start: First IOVA
+ * @last: Inclusive last IOVA
+ *
+ * An interval in IOVA space.
+ */
+struct iommu_iova_range {
+	__aligned_u64 start;
+	__aligned_u64 last;
+};
+
+/**
+ * struct iommu_ioas_iova_ranges - ioctl(IOMMU_IOAS_IOVA_RANGES)
+ * @size: sizeof(struct iommu_ioas_iova_ranges)
+ * @ioas_id: IOAS ID to read ranges from
+ * @out_num_iovas: Output total number of ranges in the IOAS
+ * @__reserved: Must be 0
+ * @out_valid_iovas: Array of valid IOVA ranges. The array length is the smaller
+ *                   of out_num_iovas or the length implied by size.
+ * @out_valid_iovas.start: First IOVA in the allowed range
+ * @out_valid_iovas.last: Inclusive last IOVA in the allowed range
+ *
+ * Query an IOAS for ranges of allowed IOVAs. Mapping IOVA outside these ranges
+ * is not allowed. out_num_iovas will be set to the total number of iovas and
+ * the out_valid_iovas[] will be filled in as space permits. size should include
+ * the allocated flex array.
+ *
+ * The allowed ranges are dependent on the HW path the DMA operation takes, and
+ * can change during the lifetime of the IOAS. A fresh empty IOAS will have a
+ * full range, and each attached device will narrow the ranges based on that
+ * devices HW restrictions. Detatching a device can widen the ranges. Userspace
+ * should query ranges after every attach/detatch to know what IOVAs are valid
+ * for mapping.
+ */
+struct iommu_ioas_iova_ranges {
+	__u32 size;
+	__u32 ioas_id;
+	__u32 out_num_iovas;
+	__u32 __reserved;
+	struct iommu_valid_iovas {
+		__aligned_u64 start;
+		__aligned_u64 last;
+	} out_valid_iovas[];
+};
+#define IOMMU_IOAS_IOVA_RANGES _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_IOVA_RANGES)
+
+/**
+ * struct iommu_ioas_allow_iovas - ioctl(IOMMU_IOAS_ALLOW_IOVAS)
+ * @size: sizeof(struct iommu_ioas_allow_iovas)
+ * @ioas_id: IOAS ID to allow IOVAs from
+ * @allowed_iovas: Pointer to array of struct iommu_iova_range
+ *
+ * Ensure a range of IOVAs are always available for allocation. If this call
+ * succeeds then IOMMU_IOAS_IOVA_RANGES will never return a list of IOVA ranges
+ * that are narrower than the ranges provided here. This call will fail if
+ * IOMMU_IOAS_IOVA_RANGES is currently narrower than the given ranges.
+ *
+ * When an IOAS is first created the IOVA_RANGES will be maximally sized, and as
+ * devices are attached the IOVA will narrow based on the device restrictions.
+ * When an allowed range is specified any narrowing will be refused, ie device
+ * attachment can fail if the device requires limiting within the allowed range.
+ *
+ * Automatic IOVA allocation is also impacted by this call, it MAP will allocate
+ * within the allowed IOVAs if they are present.
+ *
+ * This call replaces the entire allowed list with the given list.
+ */
+struct iommu_ioas_allow_iovas {
+	__u32 size;
+	__u32 ioas_id;
+	__u32 num_iovas;
+	__u32 __reserved;
+	__aligned_u64 allowed_iovas;
+};
+#define IOMMU_IOAS_ALLOW_IOVAS _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_ALLOW_IOVAS)
+
+/**
+ * enum iommufd_ioas_map_flags - Flags for map and copy
+ * @IOMMU_IOAS_MAP_FIXED_IOVA: If clear the kernel will compute an appropriate
+ *                             IOVA to place the mapping at
+ * @IOMMU_IOAS_MAP_WRITEABLE: DMA is allowed to write to this mapping
+ * @IOMMU_IOAS_MAP_READABLE: DMA is allowed to read from this mapping
+ */
+enum iommufd_ioas_map_flags {
+	IOMMU_IOAS_MAP_FIXED_IOVA = 1 << 0,
+	IOMMU_IOAS_MAP_WRITEABLE = 1 << 1,
+	IOMMU_IOAS_MAP_READABLE = 1 << 2,
+};
+
+/**
+ * struct iommu_ioas_map - ioctl(IOMMU_IOAS_MAP)
+ * @size: sizeof(struct iommu_ioas_map)
+ * @flags: Combination of enum iommufd_ioas_map_flags
+ * @ioas_id: IOAS ID to change the mapping of
+ * @__reserved: Must be 0
+ * @user_va: Userspace pointer to start mapping from
+ * @length: Number of bytes to map
+ * @iova: IOVA the mapping was placed at. If IOMMU_IOAS_MAP_FIXED_IOVA is set
+ *        then this must be provided as input.
+ *
+ * Set an IOVA mapping from a user pointer. If FIXED_IOVA is specified then the
+ * mapping will be established at iova, otherwise a suitable location will be
+ * automatically selected and returned in iova.
+ */
+struct iommu_ioas_map {
+	__u32 size;
+	__u32 flags;
+	__u32 ioas_id;
+	__u32 __reserved;
+	__aligned_u64 user_va;
+	__aligned_u64 length;
+	__aligned_u64 iova;
+};
+#define IOMMU_IOAS_MAP _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_MAP)
+
+/**
+ * struct iommu_ioas_copy - ioctl(IOMMU_IOAS_COPY)
+ * @size: sizeof(struct iommu_ioas_copy)
+ * @flags: Combination of enum iommufd_ioas_map_flags
+ * @dst_ioas_id: IOAS ID to change the mapping of
+ * @src_ioas_id: IOAS ID to copy from
+ * @length: Number of bytes to copy and map
+ * @dst_iova: IOVA the mapping was placed at. If IOMMU_IOAS_MAP_FIXED_IOVA is
+ *            set then this must be provided as input.
+ * @src_iova: IOVA to start the copy
+ *
+ * Copy an already existing mapping from src_ioas_id and establish it in
+ * dst_ioas_id. The src iova/length must exactly match a range used with
+ * IOMMU_IOAS_MAP.
+ *
+ * This may be used to efficiently clone a subset of an IOAS to another, or as a
+ * kind of 'cache' to speed up mapping. Copy has an effciency advantage over
+ * establishing equivilant new mappings, as internal resources are shared, and
+ * the kernel will pin the user memory only once.
+ */
+struct iommu_ioas_copy {
+	__u32 size;
+	__u32 flags;
+	__u32 dst_ioas_id;
+	__u32 src_ioas_id;
+	__aligned_u64 length;
+	__aligned_u64 dst_iova;
+	__aligned_u64 src_iova;
+};
+#define IOMMU_IOAS_COPY _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_COPY)
+
+/**
+ * struct iommu_ioas_unmap - ioctl(IOMMU_IOAS_UNMAP)
+ * @size: sizeof(struct iommu_ioas_copy)
+ * @ioas_id: IOAS ID to change the mapping of
+ * @iova: IOVA to start the unmapping at
+ * @length: Number of bytes to unmap, and return back the bytes unmapped
+ *
+ * Unmap an IOVA range. The iova/length must be a superset of a previously
+ * mapped range used with IOMMU_IOAS_PAGETABLE_MAP or COPY. Splitting or
+ * truncating ranges is not allowed. The values 0 to U64_MAX will unmap
+ * everything.
+ */
+struct iommu_ioas_unmap {
+	__u32 size;
+	__u32 ioas_id;
+	__aligned_u64 iova;
+	__aligned_u64 length;
+};
+#define IOMMU_IOAS_UNMAP _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_UNMAP)
 #endif
-- 
2.37.3

