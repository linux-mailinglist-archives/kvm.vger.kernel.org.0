Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0AF63C947
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236562AbiK2UaV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235880AbiK2UaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:30:05 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ECE964578
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:30:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZbL+QYn3EQBsR+ngCZDJy6Cr09woyYk8dKhUWV4HdlK0TYjM82EtkMHW48gANEH+IlpknhFv84fF+iZuz4vi+qPpIhB7nYkMekiWjSYtFePCuEEBGbgBAUnup0PHE7DHnjC52MbWch4j+7wGfa5xF62e1iVfIy2s5XXzdJCY2Cy7t6BjgcUKDsmc/5ImoiKJZvh3tjPTwEBvUEbTkxPK5qCQClgO4MZr4yWVPffZrfGbDd+f5C8cgeYvE4lamYGkpHPvV2dWGxbPku4P9rhpW8GLakmi8ZEECJJ9f3DYZVrRqoSlpQC50cFNbi+F88dZs9qdYuYVXFbUM1inRLMjaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rm1H/k1/uooREtSn7PmhOi8qhidkGBlVdZEtH/HO1vw=;
 b=Gv+8SFtPA+jWNdhhdSgjlyNa27rcKKPGwtsv0dIXR3F4sg32u9/wykbHRjKCVNzkOjlgiqYVrM/okL+YsAwWyOmDOQj1s4Z83Y/uCKn/o84i5oGpfmdV3frCUl8HZFRJntHLxGNlSL5xHa5WMvgXpAATXtrg/NqcD+zaf1yia+dJ1+ctT+s2haJyFx4RsE8KAzm5/72d4j9/GSv3Jy0yCcC/hlb1F+po9ZhFdlaZyMQieQHUVKe4mp1ASzUOPiAiZK5NjJRqaLqcaf3AY9R5G17Zy/Crb+xGqx/JJJY7QRDE3NFkDXBDWs5gVDvylJwF/x2ERH0HL6rRZG4xmS/oOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rm1H/k1/uooREtSn7PmhOi8qhidkGBlVdZEtH/HO1vw=;
 b=HXSXQ8GPyTUKbysKxItjc8Ku4SIvKueeTqBFg8FzftaKlx1ZdGumpuWKQW2qB3KsQL+N8xfUIJlvvZpCQpF/JwbYrik6PwE3DsPyibh/WGWiC9XgUchG9mosuzc/FCle/WBbWU8FLsNj6jQlW6dczOFrJz1Sr/qPlF5AqkGyqNAk1/mGOT+c3jCJABzkJm8emxz94CnQQYn17cuA2F3V9sM+yDhsHaTcYsL9d5kQ58gFaB/ez8HummhtNe0GczJf5c9Qy1R50AnQKhTmhqBCARtIPmwDXXC5IKey9867AILjn477w2MX/VBvyQdQdR/r4lcHFJN22WbKYaGWDWVqLA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH8PR12MB6796.namprd12.prod.outlook.com (2603:10b6:510:1c7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 20:29:49 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 20:29:49 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Anthony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH v6 08/19] iommufd: PFN handling for iopt_pages
Date:   Tue, 29 Nov 2022 16:29:31 -0400
Message-Id: <8-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0061.namprd05.prod.outlook.com
 (2603:10b6:a03:74::38) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH8PR12MB6796:EE_
X-MS-Office365-Filtering-Correlation-Id: b058734b-5e5d-4164-87cd-08dad2487404
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gV7ZUF9rcJTgDOzup/4rbPbAkHovP8Ml1HC6ZTItz9Y0zYnTPVak63dfaeDFL/yRux4S+LEvdVNxFUlbkYq7dEjOVtIcU6067CeMdkEOC+slp6Fz7ahZs9CbZmpTJhRd9gMPPwiu2WavH8hMDjzLj0MjeXOi4FCBl1aK/pUMKNXb2wL4K+CUT0yXawsR+kL6yGmRpPfNkWBY0Ei4ijW8ULP5fkPu8t4lIw7f1mqoIKt7UWcWbV9M6eIwHlRTHPc0/vCbUnoA9famP7JMoqg75YphtKRNIreoAlSqWX3r5vLdXv5VgxJf5+RUitNDVT8xdoMGCdwvqByRf/YU8q1rhpAKc6POGP8bLulagUPZscbQRKlfpD79dmr6Nyti0G+FL1oheQ5D01mrZfBFX+VJmoFSS4yoBfEzBGkm7uZsIRCKmFW0Fwgn9aLwANED2OiR3lOLBbmHFc9weJy1I7R2UiuYFlZuggBBNiJY+IfjWqjEnJkjx/eNXgUoqO/Ry/1rLrzI8DooaaOagV8SBAshKjCHPoA9/2UoLQIsMP3EvaK91+z8kx2O2wiKak8SN8sIBbpsCIG38llFpm4MxvnqsOvW+rj6FV5r877FbhGmzF4uZ2v4ahoT+EVfpzdwsc+kCN+V++a7iF1RM6ej6hCXYiKl9x9BCCN3Cb/4N3z3llyoSlNb7btDkHMcwgbzXNgHrQqqD697mPTnJ0DQ4kQfqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(451199015)(109986013)(2616005)(186003)(54906003)(316002)(6486002)(36756003)(86362001)(38100700002)(26005)(83380400001)(6666004)(6506007)(6512007)(30864003)(478600001)(7416002)(8676002)(41300700001)(2906002)(8936002)(66946007)(66476007)(66556008)(5660300002)(4326008)(4216001)(266003)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b2Q86mArg8cSZOKju+R+dHNU8rWmE/jAruXlMkjWgOSi3FnAaJRkc33T7tKY?=
 =?us-ascii?Q?KPEHutFSIh8LHLL9r/U66zI+8FJaJZFLE8CCTbczQVPG9C3Mk3DDsEZFy+Vw?=
 =?us-ascii?Q?6bJd/3/wL5cskOaHQYiuBkF+e6ryd7bogp+xKxB6/yJwLhaeelDFhjg0bWfH?=
 =?us-ascii?Q?Qa6Ctrz8j4LGixc7UZ30AhrxRvX2We6DFOW/wqoB6rg7mFFpfPpcTNToq0Ia?=
 =?us-ascii?Q?bRrucR4MHfh6fnyn9lOjp3dc0hHUdXB49Fzvxon7PCKyRDHtHlUTKWY+j0Xd?=
 =?us-ascii?Q?FS37ZeM2u0A7FYqgI2GU9bdHuarzES8R+XuVLjALV4yZ4UhzPWUjmCopyvGQ?=
 =?us-ascii?Q?HwN0R5TfvW2beuDxmKDrgyLilRoRRj7a+7e4obof86Lk/v+blkhR+7nyRcbr?=
 =?us-ascii?Q?iD9/w4RhF2B7V7DTn1B3cXWyE1hRtHbddA3X+qhmM+2to44Y1jfS0Bfa8g7R?=
 =?us-ascii?Q?HJeqq4+rNHW+iN9InAC/sFZZl2yz0H4hAy3FHI++QqYxaXOdTnDBTd9E24Oy?=
 =?us-ascii?Q?3bQKWIRdsJg17a7OZCUWqyXPlgXj9wIsHUpFesD20p+SgUL+pt1CmFDyIPXD?=
 =?us-ascii?Q?KLjPj40R1wJTeEuF9iFWFvkNWdlvlr6MTHOpbTEXK6lesUjAn4M8cOBE9D/Y?=
 =?us-ascii?Q?2R9sbPJ0ITQS/Idt1a+cN+0V+Cb401AXpAPMq6mm/AOSvXPI22ElznPhXJdm?=
 =?us-ascii?Q?oO7enIradpRukI8hMUnlaMuYHMFo8EyMLSSv/WrI0absThvXLKNRCxjUgl3X?=
 =?us-ascii?Q?RYDUXGNHgQzlLQu8MgAoOOKq4euSNoT8G0zS4XFeqJ6x6VCBCuS8xgHBplGG?=
 =?us-ascii?Q?2KSsybP55jydQfreFqIUxMgi215iueyCkNlVBW2vWT0JQUSog3ViclFfsH0Y?=
 =?us-ascii?Q?N6nqA+LP4htkMU6v0KpFvmHtSYFPsMoYabT4nJIp1/+sKMq+X7TeWL6sq6XD?=
 =?us-ascii?Q?JGf6sJMQU2qq5IAfU+v7hyiC/+LuKr7MaGsGYXH9tKnZJx5gQql/ZIhUXs8h?=
 =?us-ascii?Q?Dn3VK1R3OsPKNjV8O6lwcuWSVfSr9B4nyCh7sVFxDdA2d59g7HeNrmXQoLDy?=
 =?us-ascii?Q?00J97AMhIldRU9lBAUosdccnFKPEmuPRAlv+m7YTfU2j6Rj3bTpWaSN2fXZa?=
 =?us-ascii?Q?6gWXXBwm/6ag0u3CblULnrEAv74v5Fo/99RGlKQZ68X/3izrVycVlEkdlNjv?=
 =?us-ascii?Q?V3GQBECLtCSbtSadPOA2T3IRN3Xn/RloDW5RgDJ1IXpNY09CymjJrC3Z8VbT?=
 =?us-ascii?Q?1VdlbAtLug5Tz1qOeaaoi/1OVtuX6ukhZ0JS+oBQyEbo9EkpOghkxQhD5pgQ?=
 =?us-ascii?Q?+XpDCQhM3Y5bwz8iX6WXlxu7kPwUS7xuQazhZfiQ+U2/gNxv+zzzRIvbYl0r?=
 =?us-ascii?Q?rvrBigWn1yvXjK961VjWzKmMvyvr2Eh3lSKvB9sInSjCp6z+9OAG4xkAk3Xd?=
 =?us-ascii?Q?Zs5vMKZM8i2Ts4tE8cXZJ/Pvdlz6CHxSMfgvv0LKlUWmHXACNm5nQpSO37dC?=
 =?us-ascii?Q?bYC3rCW2rZvh+t2BkPN9QBQd34niw0szRMPcekDRXMG1BFOKQ/MJROAIZQtI?=
 =?us-ascii?Q?o2+fMo2d58Hcdld8rdyB2pfZLKyeWHduasGXks/k?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b058734b-5e5d-4164-87cd-08dad2487404
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 20:29:45.7916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fASzjQu2+1+dz6IQpHLCdLpDivIaMCLlBZGKXMcOCjjbYUEnsE0oJ8tILi79t/ZY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6796
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

The top of the data structure provides an IO Address Space (IOAS) that is
similar to a VFIO container. The IOAS allows map/unmap of memory into
ranges of IOVA called iopt_areas. Multiple IOMMU domains (IO page tables)
and in-kernel accesses (like VFIO mdevs) can be attached to the IOAS to
access the PFNs that those IOVA areas cover.

The IO Address Space (IOAS) datastructure is composed of:
 - struct io_pagetable holding the IOVA map
 - struct iopt_areas representing populated portions of IOVA
 - struct iopt_pages representing the storage of PFNs
 - struct iommu_domain representing each IO page table in the system IOMMU
 - struct iopt_pages_access representing in-kernel accesses of PFNs (ie
   VFIO mdevs)
 - struct xarray pinned_pfns holding a list of pages pinned by in-kernel
   accesses

This patch introduces the lowest part of the datastructure - the movement
of PFNs in a tiered storage scheme:
 1) iopt_pages::pinned_pfns xarray
 2) Multiple iommu_domains
 3) The origin of the PFNs, i.e. the userspace pointer

PFN have to be copied between all combinations of tiers, depending on the
configuration.

The interface is an iterator called a 'pfn_reader' which determines which
tier each PFN is stored and loads it into a list of PFNs held in a struct
pfn_batch.

Each step of the iterator will fill up the pfn_batch, then the caller can
use the pfn_batch to send the PFNs to the required destination. Repeating
this loop will read all the PFNs in an IOVA range.

The pfn_reader and pfn_batch also keep track of the pinned page accounting.

While PFNs are always stored and accessed as full PAGE_SIZE units the
iommu_domain tier can store with a sub-page offset/length to support
IOMMUs with a smaller IOPTE size than PAGE_SIZE.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Lixiao Yang <lixiao.yang@intel.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .clang-format                           |    1 +
 drivers/iommu/iommufd/Makefile          |    3 +-
 drivers/iommu/iommufd/double_span.h     |   53 ++
 drivers/iommu/iommufd/io_pagetable.h    |  109 +++
 drivers/iommu/iommufd/iommufd_private.h |   24 +
 drivers/iommu/iommufd/pages.c           | 1066 +++++++++++++++++++++++
 include/linux/iommufd.h                 |    7 +
 7 files changed, 1262 insertions(+), 1 deletion(-)
 create mode 100644 drivers/iommu/iommufd/double_span.h
 create mode 100644 drivers/iommu/iommufd/io_pagetable.h
 create mode 100644 drivers/iommu/iommufd/pages.c

diff --git a/.clang-format b/.clang-format
index 96d07786dcfb46..501241f8977664 100644
--- a/.clang-format
+++ b/.clang-format
@@ -440,6 +440,7 @@ ForEachMacros:
   - 'inet_lhash2_for_each_icsk'
   - 'inet_lhash2_for_each_icsk_continue'
   - 'inet_lhash2_for_each_icsk_rcu'
+  - 'interval_tree_for_each_double_span'
   - 'interval_tree_for_each_span'
   - 'intlist__for_each_entry'
   - 'intlist__for_each_entry_safe'
diff --git a/drivers/iommu/iommufd/Makefile b/drivers/iommu/iommufd/Makefile
index a07a8cffe937c6..05a0e91e30afad 100644
--- a/drivers/iommu/iommufd/Makefile
+++ b/drivers/iommu/iommufd/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 iommufd-y := \
-	main.o
+	main.o \
+	pages.o
 
 obj-$(CONFIG_IOMMUFD) += iommufd.o
diff --git a/drivers/iommu/iommufd/double_span.h b/drivers/iommu/iommufd/double_span.h
new file mode 100644
index 00000000000000..b37aab7488c0fa
--- /dev/null
+++ b/drivers/iommu/iommufd/double_span.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES.
+ */
+#ifndef __IOMMUFD_DOUBLE_SPAN_H
+#define __IOMMUFD_DOUBLE_SPAN_H
+
+#include <linux/interval_tree.h>
+
+/*
+ * This is a variation of the general interval_tree_span_iter that computes the
+ * spans over the union of two different interval trees. Used ranges are broken
+ * up and reported based on the tree that provides the interval. The first span
+ * always takes priority. Like interval_tree_span_iter it is greedy and the same
+ * value of is_used will not repeat on two iteration cycles.
+ */
+struct interval_tree_double_span_iter {
+	struct rb_root_cached *itrees[2];
+	struct interval_tree_span_iter spans[2];
+	union {
+		unsigned long start_hole;
+		unsigned long start_used;
+	};
+	union {
+		unsigned long last_hole;
+		unsigned long last_used;
+	};
+	/* 0 = hole, 1 = used span[0], 2 = used span[1], -1 done iteration */
+	int is_used;
+};
+
+void interval_tree_double_span_iter_update(
+	struct interval_tree_double_span_iter *iter);
+void interval_tree_double_span_iter_first(
+	struct interval_tree_double_span_iter *iter,
+	struct rb_root_cached *itree1, struct rb_root_cached *itree2,
+	unsigned long first_index, unsigned long last_index);
+void interval_tree_double_span_iter_next(
+	struct interval_tree_double_span_iter *iter);
+
+static inline bool
+interval_tree_double_span_iter_done(struct interval_tree_double_span_iter *state)
+{
+	return state->is_used == -1;
+}
+
+#define interval_tree_for_each_double_span(span, itree1, itree2, first_index, \
+					   last_index)                        \
+	for (interval_tree_double_span_iter_first(span, itree1, itree2,       \
+						  first_index, last_index);   \
+	     !interval_tree_double_span_iter_done(span);                      \
+	     interval_tree_double_span_iter_next(span))
+
+#endif
diff --git a/drivers/iommu/iommufd/io_pagetable.h b/drivers/iommu/iommufd/io_pagetable.h
new file mode 100644
index 00000000000000..b74bf01ffc52c2
--- /dev/null
+++ b/drivers/iommu/iommufd/io_pagetable.h
@@ -0,0 +1,109 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES.
+ *
+ */
+#ifndef __IO_PAGETABLE_H
+#define __IO_PAGETABLE_H
+
+#include <linux/interval_tree.h>
+#include <linux/mutex.h>
+#include <linux/kref.h>
+#include <linux/xarray.h>
+
+#include "iommufd_private.h"
+
+struct iommu_domain;
+
+/*
+ * Each io_pagetable is composed of intervals of areas which cover regions of
+ * the iova that are backed by something. iova not covered by areas is not
+ * populated in the page table. Each area is fully populated with pages.
+ *
+ * iovas are in byte units, but must be iopt->iova_alignment aligned.
+ *
+ * pages can be NULL, this means some other thread is still working on setting
+ * up or tearing down the area. When observed under the write side of the
+ * domain_rwsem a NULL pages must mean the area is still being setup and no
+ * domains are filled.
+ *
+ * storage_domain points at an arbitrary iommu_domain that is holding the PFNs
+ * for this area. It is locked by the pages->mutex. This simplifies the locking
+ * as the pages code can rely on the storage_domain without having to get the
+ * iopt->domains_rwsem.
+ *
+ * The io_pagetable::iova_rwsem protects node
+ * The iopt_pages::mutex protects pages_node
+ * iopt and immu_prot are immutable
+ * The pages::mutex protects num_accesses
+ */
+struct iopt_area {
+	struct interval_tree_node node;
+	struct interval_tree_node pages_node;
+	struct io_pagetable *iopt;
+	struct iopt_pages *pages;
+	struct iommu_domain *storage_domain;
+	/* How many bytes into the first page the area starts */
+	unsigned int page_offset;
+	/* IOMMU_READ, IOMMU_WRITE, etc */
+	int iommu_prot;
+	unsigned int num_accesses;
+};
+
+static inline unsigned long iopt_area_index(struct iopt_area *area)
+{
+	return area->pages_node.start;
+}
+
+static inline unsigned long iopt_area_last_index(struct iopt_area *area)
+{
+	return area->pages_node.last;
+}
+
+static inline unsigned long iopt_area_iova(struct iopt_area *area)
+{
+	return area->node.start;
+}
+
+static inline unsigned long iopt_area_last_iova(struct iopt_area *area)
+{
+	return area->node.last;
+}
+
+enum {
+	IOPT_PAGES_ACCOUNT_NONE = 0,
+	IOPT_PAGES_ACCOUNT_USER = 1,
+	IOPT_PAGES_ACCOUNT_MM = 2,
+};
+
+/*
+ * This holds a pinned page list for multiple areas of IO address space. The
+ * pages always originate from a linear chunk of userspace VA. Multiple
+ * io_pagetable's, through their iopt_area's, can share a single iopt_pages
+ * which avoids multi-pinning and double accounting of page consumption.
+ *
+ * indexes in this structure are measured in PAGE_SIZE units, are 0 based from
+ * the start of the uptr and extend to npages. pages are pinned dynamically
+ * according to the intervals in the access_itree and domains_itree, npinned
+ * records the current number of pages pinned.
+ */
+struct iopt_pages {
+	struct kref kref;
+	struct mutex mutex;
+	size_t npages;
+	size_t npinned;
+	size_t last_npinned;
+	struct task_struct *source_task;
+	struct mm_struct *source_mm;
+	struct user_struct *source_user;
+	void __user *uptr;
+	bool writable:1;
+	u8 account_mode;
+
+	struct xarray pinned_pfns;
+	/* Of iopt_pages_access::node */
+	struct rb_root_cached access_itree;
+	/* Of iopt_area::pages_node */
+	struct rb_root_cached domains_itree;
+};
+
+#endif
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index bb720bc113178d..169a30ff3bf0df 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -14,6 +14,30 @@ struct iommufd_ctx {
 	struct xarray objects;
 };
 
+/*
+ * The IOVA to PFN map. The map automatically copies the PFNs into multiple
+ * domains and permits sharing of PFNs between io_pagetable instances. This
+ * supports both a design where IOAS's are 1:1 with a domain (eg because the
+ * domain is HW customized), or where the IOAS is 1:N with multiple generic
+ * domains.  The io_pagetable holds an interval tree of iopt_areas which point
+ * to shared iopt_pages which hold the pfns mapped to the page table.
+ *
+ * The locking order is domains_rwsem -> iova_rwsem -> pages::mutex
+ */
+struct io_pagetable {
+	struct rw_semaphore domains_rwsem;
+	struct xarray domains;
+	unsigned int next_domain_id;
+
+	struct rw_semaphore iova_rwsem;
+	struct rb_root_cached area_itree;
+	/* IOVA that cannot become reserved, struct iopt_allowed */
+	struct rb_root_cached allowed_itree;
+	/* IOVA that cannot be allocated, struct iopt_reserved */
+	struct rb_root_cached reserved_itree;
+	u8 disable_large_pages;
+};
+
 struct iommufd_ucmd {
 	struct iommufd_ctx *ictx;
 	void __user *ubuffer;
diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
new file mode 100644
index 00000000000000..ebca78e743c6f3
--- /dev/null
+++ b/drivers/iommu/iommufd/pages.c
@@ -0,0 +1,1066 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES.
+ *
+ * The iopt_pages is the center of the storage and motion of PFNs. Each
+ * iopt_pages represents a logical linear array of full PFNs. The array is 0
+ * based and has npages in it. Accessors use 'index' to refer to the entry in
+ * this logical array, regardless of its storage location.
+ *
+ * PFNs are stored in a tiered scheme:
+ *  1) iopt_pages::pinned_pfns xarray
+ *  2) An iommu_domain
+ *  3) The origin of the PFNs, i.e. the userspace pointer
+ *
+ * PFN have to be copied between all combinations of tiers, depending on the
+ * configuration.
+ *
+ * When a PFN is taken out of the userspace pointer it is pinned exactly once.
+ * The storage locations of the PFN's index are tracked in the two interval
+ * trees. If no interval includes the index then it is not pinned.
+ *
+ * If access_itree includes the PFN's index then an in-kernel access has
+ * requested the page. The PFN is stored in the xarray so other requestors can
+ * continue to find it.
+ *
+ * If the domains_itree includes the PFN's index then an iommu_domain is storing
+ * the PFN and it can be read back using iommu_iova_to_phys(). To avoid
+ * duplicating storage the xarray is not used if only iommu_domains are using
+ * the PFN's index.
+ *
+ * As a general principle this is designed so that destroy never fails. This
+ * means removing an iommu_domain or releasing a in-kernel access will not fail
+ * due to insufficient memory. In practice this means some cases have to hold
+ * PFNs in the xarray even though they are also being stored in an iommu_domain.
+ *
+ * While the iopt_pages can use an iommu_domain as storage, it does not have an
+ * IOVA itself. Instead the iopt_area represents a range of IOVA and uses the
+ * iopt_pages as the PFN provider. Multiple iopt_areas can share the iopt_pages
+ * and reference their own slice of the PFN array, with sub page granularity.
+ *
+ * In this file the term 'last' indicates an inclusive and closed interval, eg
+ * [0,0] refers to a single PFN. 'end' means an open range, eg [0,0) refers to
+ * no PFNs.
+ *
+ * Be cautious of overflow. An IOVA can go all the way up to U64_MAX, so
+ * last_iova + 1 can overflow. An iopt_pages index will always be much less than
+ * ULONG_MAX so last_index + 1 cannot overflow.
+ */
+#include <linux/overflow.h>
+#include <linux/slab.h>
+#include <linux/iommu.h>
+#include <linux/sched/mm.h>
+#include <linux/highmem.h>
+#include <linux/kthread.h>
+#include <linux/iommufd.h>
+
+#include "io_pagetable.h"
+#include "double_span.h"
+
+#define TEMP_MEMORY_LIMIT 65536
+#define BATCH_BACKUP_SIZE 32
+
+/*
+ * More memory makes pin_user_pages() and the batching more efficient, but as
+ * this is only a performance optimization don't try too hard to get it. A 64k
+ * allocation can hold about 26M of 4k pages and 13G of 2M pages in an
+ * pfn_batch. Various destroy paths cannot fail and provide a small amount of
+ * stack memory as a backup contingency. If backup_len is given this cannot
+ * fail.
+ */
+static void *temp_kmalloc(size_t *size, void *backup, size_t backup_len)
+{
+	void *res;
+
+	if (WARN_ON(*size == 0))
+		return NULL;
+
+	if (*size < backup_len)
+		return backup;
+	*size = min_t(size_t, *size, TEMP_MEMORY_LIMIT);
+	res = kmalloc(*size, GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY);
+	if (res)
+		return res;
+	*size = PAGE_SIZE;
+	if (backup_len) {
+		res = kmalloc(*size, GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY);
+		if (res)
+			return res;
+		*size = backup_len;
+		return backup;
+	}
+	return kmalloc(*size, GFP_KERNEL);
+}
+
+void interval_tree_double_span_iter_update(
+	struct interval_tree_double_span_iter *iter)
+{
+	unsigned long last_hole = ULONG_MAX;
+	unsigned int i;
+
+	for (i = 0; i != ARRAY_SIZE(iter->spans); i++) {
+		if (interval_tree_span_iter_done(&iter->spans[i])) {
+			iter->is_used = -1;
+			return;
+		}
+
+		if (iter->spans[i].is_hole) {
+			last_hole = min(last_hole, iter->spans[i].last_hole);
+			continue;
+		}
+
+		iter->is_used = i + 1;
+		iter->start_used = iter->spans[i].start_used;
+		iter->last_used = min(iter->spans[i].last_used, last_hole);
+		return;
+	}
+
+	iter->is_used = 0;
+	iter->start_hole = iter->spans[0].start_hole;
+	iter->last_hole =
+		min(iter->spans[0].last_hole, iter->spans[1].last_hole);
+}
+
+void interval_tree_double_span_iter_first(
+	struct interval_tree_double_span_iter *iter,
+	struct rb_root_cached *itree1, struct rb_root_cached *itree2,
+	unsigned long first_index, unsigned long last_index)
+{
+	unsigned int i;
+
+	iter->itrees[0] = itree1;
+	iter->itrees[1] = itree2;
+	for (i = 0; i != ARRAY_SIZE(iter->spans); i++)
+		interval_tree_span_iter_first(&iter->spans[i], iter->itrees[i],
+					      first_index, last_index);
+	interval_tree_double_span_iter_update(iter);
+}
+
+void interval_tree_double_span_iter_next(
+	struct interval_tree_double_span_iter *iter)
+{
+	unsigned int i;
+
+	if (iter->is_used == -1 ||
+	    iter->last_hole == iter->spans[0].last_index) {
+		iter->is_used = -1;
+		return;
+	}
+
+	for (i = 0; i != ARRAY_SIZE(iter->spans); i++)
+		interval_tree_span_iter_advance(
+			&iter->spans[i], iter->itrees[i], iter->last_hole + 1);
+	interval_tree_double_span_iter_update(iter);
+}
+
+static void iopt_pages_add_npinned(struct iopt_pages *pages, size_t npages)
+{
+	pages->npinned += npages;
+}
+
+static void iopt_pages_sub_npinned(struct iopt_pages *pages, size_t npages)
+{
+	pages->npinned -= npages;
+}
+
+static void iopt_pages_err_unpin(struct iopt_pages *pages,
+				 unsigned long start_index,
+				 unsigned long last_index,
+				 struct page **page_list)
+{
+	unsigned long npages = last_index - start_index + 1;
+
+	unpin_user_pages(page_list, npages);
+	iopt_pages_sub_npinned(pages, npages);
+}
+
+/*
+ * index is the number of PAGE_SIZE units from the start of the area's
+ * iopt_pages. If the iova is sub page-size then the area has an iova that
+ * covers a portion of the first and last pages in the range.
+ */
+static unsigned long iopt_area_index_to_iova(struct iopt_area *area,
+					     unsigned long index)
+{
+	index -= iopt_area_index(area);
+	if (index == 0)
+		return iopt_area_iova(area);
+	return iopt_area_iova(area) - area->page_offset + index * PAGE_SIZE;
+}
+
+static unsigned long iopt_area_index_to_iova_last(struct iopt_area *area,
+						  unsigned long index)
+{
+	if (index == iopt_area_last_index(area))
+		return iopt_area_last_iova(area);
+	return iopt_area_iova(area) - area->page_offset +
+	       (index - iopt_area_index(area) + 1) * PAGE_SIZE - 1;
+}
+
+static void iommu_unmap_nofail(struct iommu_domain *domain, unsigned long iova,
+			       size_t size)
+{
+	size_t ret;
+
+	ret = iommu_unmap(domain, iova, size);
+	/*
+	 * It is a logic error in this code or a driver bug if the IOMMU unmaps
+	 * something other than exactly as requested. This implies that the
+	 * iommu driver may not fail unmap for reasons beyond bad agruments.
+	 * Particularly, the iommu driver may not do a memory allocation on the
+	 * unmap path.
+	 */
+	WARN_ON(ret != size);
+}
+
+static struct iopt_area *iopt_pages_find_domain_area(struct iopt_pages *pages,
+						     unsigned long index)
+{
+	struct interval_tree_node *node;
+
+	node = interval_tree_iter_first(&pages->domains_itree, index, index);
+	if (!node)
+		return NULL;
+	return container_of(node, struct iopt_area, pages_node);
+}
+
+/*
+ * A simple datastructure to hold a vector of PFNs, optimized for contiguous
+ * PFNs. This is used as a temporary holding memory for shuttling pfns from one
+ * place to another. Generally everything is made more efficient if operations
+ * work on the largest possible grouping of pfns. eg fewer lock/unlock cycles,
+ * better cache locality, etc
+ */
+struct pfn_batch {
+	unsigned long *pfns;
+	u32 *npfns;
+	unsigned int array_size;
+	unsigned int end;
+	unsigned int total_pfns;
+};
+
+static void batch_clear(struct pfn_batch *batch)
+{
+	batch->total_pfns = 0;
+	batch->end = 0;
+	batch->pfns[0] = 0;
+	batch->npfns[0] = 0;
+}
+
+/*
+ * Carry means we carry a portion of the final hugepage over to the front of the
+ * batch
+ */
+static void batch_clear_carry(struct pfn_batch *batch, unsigned int keep_pfns)
+{
+	if (!keep_pfns)
+		return batch_clear(batch);
+
+	batch->total_pfns = keep_pfns;
+	batch->npfns[0] = keep_pfns;
+	batch->pfns[0] = batch->pfns[batch->end - 1] +
+			 (batch->npfns[batch->end - 1] - keep_pfns);
+	batch->end = 0;
+}
+
+static void batch_skip_carry(struct pfn_batch *batch, unsigned int skip_pfns)
+{
+	if (!batch->total_pfns)
+		return;
+	skip_pfns = min(batch->total_pfns, skip_pfns);
+	batch->pfns[0] += skip_pfns;
+	batch->npfns[0] -= skip_pfns;
+	batch->total_pfns -= skip_pfns;
+}
+
+static int __batch_init(struct pfn_batch *batch, size_t max_pages, void *backup,
+			size_t backup_len)
+{
+	const size_t elmsz = sizeof(*batch->pfns) + sizeof(*batch->npfns);
+	size_t size = max_pages * elmsz;
+
+	batch->pfns = temp_kmalloc(&size, backup, backup_len);
+	if (!batch->pfns)
+		return -ENOMEM;
+	batch->array_size = size / elmsz;
+	batch->npfns = (u32 *)(batch->pfns + batch->array_size);
+	batch_clear(batch);
+	return 0;
+}
+
+static int batch_init(struct pfn_batch *batch, size_t max_pages)
+{
+	return __batch_init(batch, max_pages, NULL, 0);
+}
+
+static void batch_init_backup(struct pfn_batch *batch, size_t max_pages,
+			      void *backup, size_t backup_len)
+{
+	__batch_init(batch, max_pages, backup, backup_len);
+}
+
+static void batch_destroy(struct pfn_batch *batch, void *backup)
+{
+	if (batch->pfns != backup)
+		kfree(batch->pfns);
+}
+
+/* true if the pfn could be added, false otherwise */
+static bool batch_add_pfn(struct pfn_batch *batch, unsigned long pfn)
+{
+	const unsigned int MAX_NPFNS = type_max(typeof(*batch->npfns));
+
+	if (batch->end &&
+	    pfn == batch->pfns[batch->end - 1] + batch->npfns[batch->end - 1] &&
+	    batch->npfns[batch->end - 1] != MAX_NPFNS) {
+		batch->npfns[batch->end - 1]++;
+		batch->total_pfns++;
+		return true;
+	}
+	if (batch->end == batch->array_size)
+		return false;
+	batch->total_pfns++;
+	batch->pfns[batch->end] = pfn;
+	batch->npfns[batch->end] = 1;
+	batch->end++;
+	return true;
+}
+
+/*
+ * Fill the batch with pfns from the domain. When the batch is full, or it
+ * reaches last_index, the function will return. The caller should use
+ * batch->total_pfns to determine the starting point for the next iteration.
+ */
+static void batch_from_domain(struct pfn_batch *batch,
+			      struct iommu_domain *domain,
+			      struct iopt_area *area, unsigned long start_index,
+			      unsigned long last_index)
+{
+	unsigned int page_offset = 0;
+	unsigned long iova;
+	phys_addr_t phys;
+
+	iova = iopt_area_index_to_iova(area, start_index);
+	if (start_index == iopt_area_index(area))
+		page_offset = area->page_offset;
+	while (start_index <= last_index) {
+		/*
+		 * This is pretty slow, it would be nice to get the page size
+		 * back from the driver, or have the driver directly fill the
+		 * batch.
+		 */
+		phys = iommu_iova_to_phys(domain, iova) - page_offset;
+		if (!batch_add_pfn(batch, PHYS_PFN(phys)))
+			return;
+		iova += PAGE_SIZE - page_offset;
+		page_offset = 0;
+		start_index++;
+	}
+}
+
+static struct page **raw_pages_from_domain(struct iommu_domain *domain,
+					   struct iopt_area *area,
+					   unsigned long start_index,
+					   unsigned long last_index,
+					   struct page **out_pages)
+{
+	unsigned int page_offset = 0;
+	unsigned long iova;
+	phys_addr_t phys;
+
+	iova = iopt_area_index_to_iova(area, start_index);
+	if (start_index == iopt_area_index(area))
+		page_offset = area->page_offset;
+	while (start_index <= last_index) {
+		phys = iommu_iova_to_phys(domain, iova) - page_offset;
+		*(out_pages++) = pfn_to_page(PHYS_PFN(phys));
+		iova += PAGE_SIZE - page_offset;
+		page_offset = 0;
+		start_index++;
+	}
+	return out_pages;
+}
+
+/* Continues reading a domain until we reach a discontiguity in the pfns. */
+static void batch_from_domain_continue(struct pfn_batch *batch,
+				       struct iommu_domain *domain,
+				       struct iopt_area *area,
+				       unsigned long start_index,
+				       unsigned long last_index)
+{
+	unsigned int array_size = batch->array_size;
+
+	batch->array_size = batch->end;
+	batch_from_domain(batch, domain, area, start_index, last_index);
+	batch->array_size = array_size;
+}
+
+/*
+ * This is part of the VFIO compatibility support for VFIO_TYPE1_IOMMU. That
+ * mode permits splitting a mapped area up, and then one of the splits is
+ * unmapped. Doing this normally would cause us to violate our invariant of
+ * pairing map/unmap. Thus, to support old VFIO compatibility disable support
+ * for batching consecutive PFNs. All PFNs mapped into the iommu are done in
+ * PAGE_SIZE units, not larger or smaller.
+ */
+static int batch_iommu_map_small(struct iommu_domain *domain,
+				 unsigned long iova, phys_addr_t paddr,
+				 size_t size, int prot)
+{
+	unsigned long start_iova = iova;
+	int rc;
+
+	while (size) {
+		rc = iommu_map(domain, iova, paddr, PAGE_SIZE, prot);
+		if (rc)
+			goto err_unmap;
+		iova += PAGE_SIZE;
+		paddr += PAGE_SIZE;
+		size -= PAGE_SIZE;
+	}
+	return 0;
+
+err_unmap:
+	if (start_iova != iova)
+		iommu_unmap_nofail(domain, start_iova, iova - start_iova);
+	return rc;
+}
+
+static int batch_to_domain(struct pfn_batch *batch, struct iommu_domain *domain,
+			   struct iopt_area *area, unsigned long start_index)
+{
+	bool disable_large_pages = area->iopt->disable_large_pages;
+	unsigned long last_iova = iopt_area_last_iova(area);
+	unsigned int page_offset = 0;
+	unsigned long start_iova;
+	unsigned long next_iova;
+	unsigned int cur = 0;
+	unsigned long iova;
+	int rc;
+
+	/* The first index might be a partial page */
+	if (start_index == iopt_area_index(area))
+		page_offset = area->page_offset;
+	next_iova = iova = start_iova =
+		iopt_area_index_to_iova(area, start_index);
+	while (cur < batch->end) {
+		next_iova = min(last_iova + 1,
+				next_iova + batch->npfns[cur] * PAGE_SIZE -
+					page_offset);
+		if (disable_large_pages)
+			rc = batch_iommu_map_small(
+				domain, iova,
+				PFN_PHYS(batch->pfns[cur]) + page_offset,
+				next_iova - iova, area->iommu_prot);
+		else
+			rc = iommu_map(domain, iova,
+				       PFN_PHYS(batch->pfns[cur]) + page_offset,
+				       next_iova - iova, area->iommu_prot);
+		if (rc)
+			goto err_unmap;
+		iova = next_iova;
+		page_offset = 0;
+		cur++;
+	}
+	return 0;
+err_unmap:
+	if (start_iova != iova)
+		iommu_unmap_nofail(domain, start_iova, iova - start_iova);
+	return rc;
+}
+
+static void batch_from_xarray(struct pfn_batch *batch, struct xarray *xa,
+			      unsigned long start_index,
+			      unsigned long last_index)
+{
+	XA_STATE(xas, xa, start_index);
+	void *entry;
+
+	rcu_read_lock();
+	while (true) {
+		entry = xas_next(&xas);
+		if (xas_retry(&xas, entry))
+			continue;
+		WARN_ON(!xa_is_value(entry));
+		if (!batch_add_pfn(batch, xa_to_value(entry)) ||
+		    start_index == last_index)
+			break;
+		start_index++;
+	}
+	rcu_read_unlock();
+}
+
+static void batch_from_xarray_clear(struct pfn_batch *batch, struct xarray *xa,
+				    unsigned long start_index,
+				    unsigned long last_index)
+{
+	XA_STATE(xas, xa, start_index);
+	void *entry;
+
+	xas_lock(&xas);
+	while (true) {
+		entry = xas_next(&xas);
+		if (xas_retry(&xas, entry))
+			continue;
+		WARN_ON(!xa_is_value(entry));
+		if (!batch_add_pfn(batch, xa_to_value(entry)))
+			break;
+		xas_store(&xas, NULL);
+		if (start_index == last_index)
+			break;
+		start_index++;
+	}
+	xas_unlock(&xas);
+}
+
+static void clear_xarray(struct xarray *xa, unsigned long start_index,
+			 unsigned long last_index)
+{
+	XA_STATE(xas, xa, start_index);
+	void *entry;
+
+	xas_lock(&xas);
+	xas_for_each(&xas, entry, last_index)
+		xas_store(&xas, NULL);
+	xas_unlock(&xas);
+}
+
+static int pages_to_xarray(struct xarray *xa, unsigned long start_index,
+			   unsigned long last_index, struct page **pages)
+{
+	struct page **end_pages = pages + (last_index - start_index) + 1;
+	XA_STATE(xas, xa, start_index);
+
+	do {
+		void *old;
+
+		xas_lock(&xas);
+		while (pages != end_pages) {
+			old = xas_store(&xas, xa_mk_value(page_to_pfn(*pages)));
+			if (xas_error(&xas))
+				break;
+			WARN_ON(old);
+			pages++;
+			xas_next(&xas);
+		}
+		xas_unlock(&xas);
+	} while (xas_nomem(&xas, GFP_KERNEL));
+
+	if (xas_error(&xas)) {
+		if (xas.xa_index != start_index)
+			clear_xarray(xa, start_index, xas.xa_index - 1);
+		return xas_error(&xas);
+	}
+	return 0;
+}
+
+static void batch_from_pages(struct pfn_batch *batch, struct page **pages,
+			     size_t npages)
+{
+	struct page **end = pages + npages;
+
+	for (; pages != end; pages++)
+		if (!batch_add_pfn(batch, page_to_pfn(*pages)))
+			break;
+}
+
+static void batch_unpin(struct pfn_batch *batch, struct iopt_pages *pages,
+			unsigned int first_page_off, size_t npages)
+{
+	unsigned int cur = 0;
+
+	while (first_page_off) {
+		if (batch->npfns[cur] > first_page_off)
+			break;
+		first_page_off -= batch->npfns[cur];
+		cur++;
+	}
+
+	while (npages) {
+		size_t to_unpin = min_t(size_t, npages,
+					batch->npfns[cur] - first_page_off);
+
+		unpin_user_page_range_dirty_lock(
+			pfn_to_page(batch->pfns[cur] + first_page_off),
+			to_unpin, pages->writable);
+		iopt_pages_sub_npinned(pages, to_unpin);
+		cur++;
+		first_page_off = 0;
+		npages -= to_unpin;
+	}
+}
+
+static void copy_data_page(struct page *page, void *data, unsigned long offset,
+			   size_t length, unsigned int flags)
+{
+	void *mem;
+
+	mem = kmap_local_page(page);
+	if (flags & IOMMUFD_ACCESS_RW_WRITE) {
+		memcpy(mem + offset, data, length);
+		set_page_dirty_lock(page);
+	} else {
+		memcpy(data, mem + offset, length);
+	}
+	kunmap_local(mem);
+}
+
+static unsigned long batch_rw(struct pfn_batch *batch, void *data,
+			      unsigned long offset, unsigned long length,
+			      unsigned int flags)
+{
+	unsigned long copied = 0;
+	unsigned int npage = 0;
+	unsigned int cur = 0;
+
+	while (cur < batch->end) {
+		unsigned long bytes = min(length, PAGE_SIZE - offset);
+
+		copy_data_page(pfn_to_page(batch->pfns[cur] + npage), data,
+			       offset, bytes, flags);
+		offset = 0;
+		length -= bytes;
+		data += bytes;
+		copied += bytes;
+		npage++;
+		if (npage == batch->npfns[cur]) {
+			npage = 0;
+			cur++;
+		}
+		if (!length)
+			break;
+	}
+	return copied;
+}
+
+/* pfn_reader_user is just the pin_user_pages() path */
+struct pfn_reader_user {
+	struct page **upages;
+	size_t upages_len;
+	unsigned long upages_start;
+	unsigned long upages_end;
+	unsigned int gup_flags;
+	/*
+	 * 1 means mmget() and mmap_read_lock(), 0 means only mmget(), -1 is
+	 * neither
+	 */
+	int locked;
+};
+
+static void pfn_reader_user_init(struct pfn_reader_user *user,
+				 struct iopt_pages *pages)
+{
+	user->upages = NULL;
+	user->upages_start = 0;
+	user->upages_end = 0;
+	user->locked = -1;
+
+	if (pages->writable) {
+		user->gup_flags = FOLL_LONGTERM | FOLL_WRITE;
+	} else {
+		/* Still need to break COWs on read */
+		user->gup_flags = FOLL_LONGTERM | FOLL_FORCE | FOLL_WRITE;
+	}
+}
+
+static void pfn_reader_user_destroy(struct pfn_reader_user *user,
+				    struct iopt_pages *pages)
+{
+	if (user->locked != -1) {
+		if (user->locked)
+			mmap_read_unlock(pages->source_mm);
+		if (pages->source_mm != current->mm)
+			mmput(pages->source_mm);
+		user->locked = 0;
+	}
+
+	kfree(user->upages);
+	user->upages = NULL;
+}
+
+static int pfn_reader_user_pin(struct pfn_reader_user *user,
+			       struct iopt_pages *pages,
+			       unsigned long start_index,
+			       unsigned long last_index)
+{
+	bool remote_mm = pages->source_mm != current->mm;
+	unsigned long npages;
+	uintptr_t uptr;
+	long rc;
+
+	if (!user->upages) {
+		/* All undone in pfn_reader_destroy() */
+		user->upages_len =
+			(last_index - start_index + 1) * sizeof(*user->upages);
+		user->upages = temp_kmalloc(&user->upages_len, NULL, 0);
+		if (!user->upages)
+			return -ENOMEM;
+	}
+
+	if (user->locked == -1) {
+		/*
+		 * The majority of usages will run the map task within the mm
+		 * providing the pages, so we can optimize into
+		 * get_user_pages_fast()
+		 */
+		if (remote_mm) {
+			if (!mmget_not_zero(pages->source_mm))
+				return -EFAULT;
+		}
+		user->locked = 0;
+	}
+
+	npages = min_t(unsigned long, last_index - start_index + 1,
+		       user->upages_len / sizeof(*user->upages));
+
+	uptr = (uintptr_t)(pages->uptr + start_index * PAGE_SIZE);
+	if (!remote_mm)
+		rc = pin_user_pages_fast(uptr, npages, user->gup_flags,
+					 user->upages);
+	else {
+		if (!user->locked) {
+			mmap_read_lock(pages->source_mm);
+			user->locked = 1;
+		}
+		/*
+		 * FIXME: last NULL can be &pfns->locked once the GUP patch
+		 * is merged.
+		 */
+		rc = pin_user_pages_remote(pages->source_mm, uptr, npages,
+					   user->gup_flags, user->upages, NULL,
+					   NULL);
+	}
+	if (rc <= 0) {
+		if (WARN_ON(!rc))
+			return -EFAULT;
+		return rc;
+	}
+	iopt_pages_add_npinned(pages, rc);
+	user->upages_start = start_index;
+	user->upages_end = start_index + rc;
+	return 0;
+}
+
+/* This is the "modern" and faster accounting method used by io_uring */
+static int incr_user_locked_vm(struct iopt_pages *pages, unsigned long npages)
+{
+	unsigned long lock_limit;
+	unsigned long cur_pages;
+	unsigned long new_pages;
+
+	lock_limit = task_rlimit(pages->source_task, RLIMIT_MEMLOCK) >>
+		     PAGE_SHIFT;
+	npages = pages->npinned - pages->last_npinned;
+	do {
+		cur_pages = atomic_long_read(&pages->source_user->locked_vm);
+		new_pages = cur_pages + npages;
+		if (new_pages > lock_limit)
+			return -ENOMEM;
+	} while (atomic_long_cmpxchg(&pages->source_user->locked_vm, cur_pages,
+				     new_pages) != cur_pages);
+	return 0;
+}
+
+static void decr_user_locked_vm(struct iopt_pages *pages, unsigned long npages)
+{
+	if (WARN_ON(atomic_long_read(&pages->source_user->locked_vm) < npages))
+		return;
+	atomic_long_sub(npages, &pages->source_user->locked_vm);
+}
+
+/* This is the accounting method used for compatibility with VFIO */
+static int update_mm_locked_vm(struct iopt_pages *pages, unsigned long npages,
+			       bool inc, struct pfn_reader_user *user)
+{
+	bool do_put = false;
+	int rc;
+
+	if (user && user->locked) {
+		mmap_read_unlock(pages->source_mm);
+		user->locked = 0;
+		/* If we had the lock then we also have a get */
+	} else if ((!user || !user->upages) &&
+		   pages->source_mm != current->mm) {
+		if (!mmget_not_zero(pages->source_mm))
+			return -EINVAL;
+		do_put = true;
+	}
+
+	mmap_write_lock(pages->source_mm);
+	rc = __account_locked_vm(pages->source_mm, npages, inc,
+				 pages->source_task, false);
+	mmap_write_unlock(pages->source_mm);
+
+	if (do_put)
+		mmput(pages->source_mm);
+	return rc;
+}
+
+static int do_update_pinned(struct iopt_pages *pages, unsigned long npages,
+			    bool inc, struct pfn_reader_user *user)
+{
+	int rc = 0;
+
+	switch (pages->account_mode) {
+	case IOPT_PAGES_ACCOUNT_NONE:
+		break;
+	case IOPT_PAGES_ACCOUNT_USER:
+		if (inc)
+			rc = incr_user_locked_vm(pages, npages);
+		else
+			decr_user_locked_vm(pages, npages);
+		break;
+	case IOPT_PAGES_ACCOUNT_MM:
+		rc = update_mm_locked_vm(pages, npages, inc, user);
+		break;
+	}
+	if (rc)
+		return rc;
+
+	pages->last_npinned = pages->npinned;
+	if (inc)
+		atomic64_add(npages, &pages->source_mm->pinned_vm);
+	else
+		atomic64_sub(npages, &pages->source_mm->pinned_vm);
+	return 0;
+}
+
+static void update_unpinned(struct iopt_pages *pages)
+{
+	if (WARN_ON(pages->npinned > pages->last_npinned))
+		return;
+	if (pages->npinned == pages->last_npinned)
+		return;
+	do_update_pinned(pages, pages->last_npinned - pages->npinned, false,
+			 NULL);
+}
+
+/*
+ * Changes in the number of pages pinned is done after the pages have been read
+ * and processed. If the user lacked the limit then the error unwind will unpin
+ * everything that was just pinned. This is because it is expensive to calculate
+ * how many pages we have already pinned within a range to generate an accurate
+ * prediction in advance of doing the work to actually pin them.
+ */
+static int pfn_reader_user_update_pinned(struct pfn_reader_user *user,
+					 struct iopt_pages *pages)
+{
+	unsigned long npages;
+	bool inc;
+
+	lockdep_assert_held(&pages->mutex);
+
+	if (pages->npinned == pages->last_npinned)
+		return 0;
+
+	if (pages->npinned < pages->last_npinned) {
+		npages = pages->last_npinned - pages->npinned;
+		inc = false;
+	} else {
+		npages = pages->npinned - pages->last_npinned;
+		inc = true;
+	}
+	return do_update_pinned(pages, npages, inc, user);
+}
+
+/*
+ * PFNs are stored in three places, in order of preference:
+ * - The iopt_pages xarray. This is only populated if there is a
+ *   iopt_pages_access
+ * - The iommu_domain under an area
+ * - The original PFN source, ie pages->source_mm
+ *
+ * This iterator reads the pfns optimizing to load according to the
+ * above order.
+ */
+struct pfn_reader {
+	struct iopt_pages *pages;
+	struct interval_tree_double_span_iter span;
+	struct pfn_batch batch;
+	unsigned long batch_start_index;
+	unsigned long batch_end_index;
+	unsigned long last_index;
+
+	struct pfn_reader_user user;
+};
+
+static int pfn_reader_update_pinned(struct pfn_reader *pfns)
+{
+	return pfn_reader_user_update_pinned(&pfns->user, pfns->pages);
+}
+
+/*
+ * The batch can contain a mixture of pages that are still in use and pages that
+ * need to be unpinned. Unpin only pages that are not held anywhere else.
+ */
+static void pfn_reader_unpin(struct pfn_reader *pfns)
+{
+	unsigned long last = pfns->batch_end_index - 1;
+	unsigned long start = pfns->batch_start_index;
+	struct interval_tree_double_span_iter span;
+	struct iopt_pages *pages = pfns->pages;
+
+	lockdep_assert_held(&pages->mutex);
+
+	interval_tree_for_each_double_span(&span, &pages->access_itree,
+					   &pages->domains_itree, start, last) {
+		if (span.is_used)
+			continue;
+
+		batch_unpin(&pfns->batch, pages, span.start_hole - start,
+			    span.last_hole - span.start_hole + 1);
+	}
+}
+
+/* Process a single span to load it from the proper storage */
+static int pfn_reader_fill_span(struct pfn_reader *pfns)
+{
+	struct interval_tree_double_span_iter *span = &pfns->span;
+	unsigned long start_index = pfns->batch_end_index;
+	struct iopt_area *area;
+	int rc;
+
+	if (span->is_used == 1) {
+		batch_from_xarray(&pfns->batch, &pfns->pages->pinned_pfns,
+				  start_index, span->last_used);
+		return 0;
+	}
+
+	if (span->is_used == 2) {
+		/*
+		 * Pull as many pages from the first domain we find in the
+		 * target span. If it is too small then we will be called again
+		 * and we'll find another area.
+		 */
+		area = iopt_pages_find_domain_area(pfns->pages, start_index);
+		if (WARN_ON(!area))
+			return -EINVAL;
+
+		/* The storage_domain cannot change without the pages mutex */
+		batch_from_domain(
+			&pfns->batch, area->storage_domain, area, start_index,
+			min(iopt_area_last_index(area), span->last_used));
+		return 0;
+	}
+
+	if (start_index >= pfns->user.upages_end) {
+		rc = pfn_reader_user_pin(&pfns->user, pfns->pages, start_index,
+					 span->last_hole);
+		if (rc)
+			return rc;
+	}
+
+	batch_from_pages(&pfns->batch,
+			 pfns->user.upages +
+				 (start_index - pfns->user.upages_start),
+			 pfns->user.upages_end - start_index);
+	return 0;
+}
+
+static bool pfn_reader_done(struct pfn_reader *pfns)
+{
+	return pfns->batch_start_index == pfns->last_index + 1;
+}
+
+static int pfn_reader_next(struct pfn_reader *pfns)
+{
+	int rc;
+
+	batch_clear(&pfns->batch);
+	pfns->batch_start_index = pfns->batch_end_index;
+
+	while (pfns->batch_end_index != pfns->last_index + 1) {
+		unsigned int npfns = pfns->batch.total_pfns;
+
+		rc = pfn_reader_fill_span(pfns);
+		if (rc)
+			return rc;
+
+		if (WARN_ON(!pfns->batch.total_pfns))
+			return -EINVAL;
+
+		pfns->batch_end_index =
+			pfns->batch_start_index + pfns->batch.total_pfns;
+		if (pfns->batch_end_index == pfns->span.last_used + 1)
+			interval_tree_double_span_iter_next(&pfns->span);
+
+		/* Batch is full */
+		if (npfns == pfns->batch.total_pfns)
+			return 0;
+	}
+	return 0;
+}
+
+static int pfn_reader_init(struct pfn_reader *pfns, struct iopt_pages *pages,
+			   unsigned long start_index, unsigned long last_index)
+{
+	int rc;
+
+	lockdep_assert_held(&pages->mutex);
+
+	pfns->pages = pages;
+	pfns->batch_start_index = start_index;
+	pfns->batch_end_index = start_index;
+	pfns->last_index = last_index;
+	pfn_reader_user_init(&pfns->user, pages);
+	rc = batch_init(&pfns->batch, last_index - start_index + 1);
+	if (rc)
+		return rc;
+	interval_tree_double_span_iter_first(&pfns->span, &pages->access_itree,
+					     &pages->domains_itree, start_index,
+					     last_index);
+	return 0;
+}
+
+/*
+ * There are many assertions regarding the state of pages->npinned vs
+ * pages->last_pinned, for instance something like unmapping a domain must only
+ * decrement the npinned, and pfn_reader_destroy() must be called only after all
+ * the pins are updated. This is fine for success flows, but error flows
+ * sometimes need to release the pins held inside the pfn_reader before going on
+ * to complete unmapping and releasing pins held in domains.
+ */
+static void pfn_reader_release_pins(struct pfn_reader *pfns)
+{
+	struct iopt_pages *pages = pfns->pages;
+
+	if (pfns->user.upages_end > pfns->batch_end_index) {
+		size_t npages = pfns->user.upages_end - pfns->batch_end_index;
+
+		/* Any pages not transferred to the batch are just unpinned */
+		unpin_user_pages(pfns->user.upages + (pfns->batch_end_index -
+						      pfns->user.upages_start),
+				 npages);
+		iopt_pages_sub_npinned(pages, npages);
+		pfns->user.upages_end = pfns->batch_end_index;
+	}
+	if (pfns->batch_start_index != pfns->batch_end_index) {
+		pfn_reader_unpin(pfns);
+		pfns->batch_start_index = pfns->batch_end_index;
+	}
+}
+
+static void pfn_reader_destroy(struct pfn_reader *pfns)
+{
+	struct iopt_pages *pages = pfns->pages;
+
+	pfn_reader_release_pins(pfns);
+	pfn_reader_user_destroy(&pfns->user, pfns->pages);
+	batch_destroy(&pfns->batch, NULL);
+	WARN_ON(pages->last_npinned != pages->npinned);
+}
+
+static int pfn_reader_first(struct pfn_reader *pfns, struct iopt_pages *pages,
+			    unsigned long start_index, unsigned long last_index)
+{
+	int rc;
+
+	rc = pfn_reader_init(pfns, pages, start_index, last_index);
+	if (rc)
+		return rc;
+	rc = pfn_reader_next(pfns);
+	if (rc) {
+		pfn_reader_destroy(pfns);
+		return rc;
+	}
+	return 0;
+}
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index d1817472c27373..26e09d539737bb 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -13,6 +13,13 @@
 struct iommufd_ctx;
 struct file;
 
+enum {
+	IOMMUFD_ACCESS_RW_READ = 0,
+	IOMMUFD_ACCESS_RW_WRITE = 1 << 0,
+	/* Set if the caller is in a kthread then rw will use kthread_use_mm() */
+	IOMMUFD_ACCESS_RW_KTHREAD = 1 << 1,
+};
+
 void iommufd_ctx_get(struct iommufd_ctx *ictx);
 
 #if IS_ENABLED(CONFIG_IOMMUFD)
-- 
2.38.1

