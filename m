Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBB7E5AB914
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 21:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbiIBT7m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 15:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiIBT7i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 15:59:38 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2056.outbound.protection.outlook.com [40.107.102.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82CD124F32
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 12:59:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VbMRxrvEFBdu6xmOmWYhOGC7lZAEoWhxlmO7fc6Mgd6f/YWKlmmWgSGjeTXN8Gb8pwJIirTNT2rX6THspYRHbj0qS+WCAVvYIrOzIvpwVywtq3Bf5pIxADPW79SNZ5j6UhUDjpJK0zrCKz8Vf3fuJHuGTB1ARLg4qonjAsO8oFSt5o4+q50dZOM+xRGWUbz+j1qRPnhuBbeDka/mfcruXMr3RBLvLQ+NYcYHi8Q8ogbDjHxRKp5rvYOaA1LN42gdkZ+2VmSt0+STJAruMVcj6VKM6ymYp+URIWoLeu+4EHYLLB6Rw1AsB1PCXYGX356IDLunucGcy2zNO7RN+jkFyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3shBqC6ypCstg7aam4R1lVCPCGpLccet7wqwQW4tT7A=;
 b=GgWTwbxhC831l+l5yXPr7/jTkq7tu/m55zTHGLSiYkQqLp617nqvdCFW5Rpli8VDkI3kXXvpz1KMxGqHc9k1C3UyXHbXk0Gz8U38HYWOobQOCI2T81RUEEuZQaE/UfEzDkfmDooiHW/7cpWsBavoH5zqYla5iJfBIfVJEpjlE6ugr3hBU1xQWfyXqpMiUears8Kq+g85YMRR9Fp9cT+oj7lA2qSD8f7xer1Rhxl6+BCpxk2J5UF87BBRtuoYtqHukl//SLh4qjk8WjS823VgeWpD62ncofl+3oTbYWZlwXV9XdJhfZ5xP31cTewYxZ7aTHPag9G1ymLxYQziDIz9Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3shBqC6ypCstg7aam4R1lVCPCGpLccet7wqwQW4tT7A=;
 b=X7nSfRvVYq/9q5qCaO6qO3lhXOIvTpeywMWWGZt1PNAkIQgM2/yqsPbaI9j4UxJSzNst+cDQKdvnPWxLekTEyX1RajBPExxstNCtPEMH1YJlSikQLMyNCB8ix4WTeKuDcfUK62r3H6h3U1lz3RiNduXNzf3v3BbxOaQ56Mi+gaz2HkHGOeEzDgdl7Dk9qXHtQ9Ib9cPd9nmYfHRVTwzExMB9hrFQPlUyjGkqJ2579IiGKmm5cTXqb9Q1fImpadMd630eH6Me834/mZ5nDVTi/nyyqQavm8iQ2GKcwrSTVTKUROpaQphY5JXFuIY8iWIw8f3gnsVdikvpHsCsIoUb1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM4PR12MB6566.namprd12.prod.outlook.com (2603:10b6:8:8d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 19:59:31 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5588.016; Fri, 2 Sep 2022
 19:59:31 +0000
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
Subject: [PATCH RFC v2 09/13] iommufd: Add a HW pagetable object
Date:   Fri,  2 Sep 2022 16:59:25 -0300
Message-Id: <9-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0094.namprd03.prod.outlook.com
 (2603:10b6:208:32a::9) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94645e02-1b5a-4354-ae33-08da8d1da5f0
X-MS-TrafficTypeDiagnostic: DM4PR12MB6566:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IXxfAvum7qWF1PiSQPn1dj1Ma0z4xp5KWhnfXRnU6XFyQYWR2LN9pFW2Bt0qoE4tAo72Liy7emhNJ0r0TZEApBMiis/brtT3mpCiHKhnpuuj2Id/tXrqC2QBtSzTTiY1fm7OoKPURPqzKeux2EYNpVRxD3Iu3/+4V7mTbNKUEMfXmVY6qBYr+PJ9ezEoLTjJLXZ6+2OUWnZZvykhS4EWjZ7AVlL74dcdQdYd9wKnXzh54iF90JHP1sXRQHYrL3LQiPlS2tNLZAsd46BugUBgj1pb77iMRssGBIi81szmj+e1errL5Ypf8jMjsI0W2Xu9R7ddgAPFbd+UY98vkPR8VoFDdSU15QBECSi3CJO1htoZNgjHp2W3EE5CGhSXIe7tRZH99CDpI2zPN3qBu10w4lAjJ1/ZTn2bnH4IsBfoZYBcK1IKFP2qSbm3KaKZZHprM6h9XLbDadxbhQCg1Afr4xCcOIcEqGWYxc8+sKuD+NL7mw8nATVlwovS06lfqgHt6C00IN+lsj3ENR1OPqAywBf6HILNLrNJaAhwOzSh49xQUK59xtJC57VDC2E9lic8rZ4hMHyxnNx9R27qNfQKGZ65T709KtYheaZYKfQRBjzyWw1XZRwib6UK2WCVQnyO/4Z/F0OSsCcvURrVJcYkkhfjU6g7km20Qo2LGCb09/vmktYjIctgtYZFgI08qQw8OUYi74r5TjqOuayQFfb1wV/8g0+racDCmCSBw1UiO6oJPEoknkyM6YZ/wg1sdKHk4+Rx9SZ891AQ8ES7f76z7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(5660300002)(109986005)(6506007)(36756003)(83380400001)(41300700001)(8936002)(6666004)(6486002)(478600001)(2906002)(38100700002)(66476007)(8676002)(66946007)(66556008)(4326008)(86362001)(54906003)(7416002)(26005)(6512007)(186003)(2616005)(316002)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+BZG2Ymj6+xDLoLVcxe56HoRhZlsAu572OnSlyTKNPAQJLqjAGGAxvPCGtym?=
 =?us-ascii?Q?RdmUzLiM2XxTSjPvRvnMAxOpTWQuKkOCIZffljRxu2P+dityHNlcYfC3lu7a?=
 =?us-ascii?Q?7ifJ/xLQ23+N+vpziVgXuF3FvTnJTK+nBrLwY58fO2Cvt0UGg2RUlspxzSrb?=
 =?us-ascii?Q?ZoS7JR4SWW85i/jLSp/LtkFdULOSkPp+O5ABVuubkXn76PUExJAr0GU5GHo4?=
 =?us-ascii?Q?TigvBBe6mObXwyOxfsrupHJGLK8J8dnzWcYoU51hyEg28VJJCbVojj8rjrNZ?=
 =?us-ascii?Q?1RssWgtZYk+Poe9TCD6dHlAmbidSoZDdkmWHvE2FXU0wNI0wn8zIOfAsW659?=
 =?us-ascii?Q?n27CohJIc0mFmjpFZkJ6hjHHx6I1ml89eM7cldUze+BQ/R7swVYrwTCcgO7j?=
 =?us-ascii?Q?2wkCKMQAq1xvhTYP3ryz736Vyr9tiEL0gEDl9AFBh7BrtxyWsGJDdCGsCVFa?=
 =?us-ascii?Q?JM47T91MLqdeAsg7HltjJgcIV1DXnpQ04zXzoP6VZj/QEQiVSuroDr+y6NW1?=
 =?us-ascii?Q?pYk+LOvbwX8f/qFfWBOYOiWNJu5wPoFjmVDvIv23+Rjf+4dvHMK8K0jcJ93x?=
 =?us-ascii?Q?3IPaCQL1Lam+q/6owNl+c0iRinTfKbc4imMQ2SnyQtcYWj0WUJLbv4Ng/Y/Z?=
 =?us-ascii?Q?pR7FShqivlLJjUyrj1tmNvTS5Mtxb6hMSgDRMK2qV5R0ZEU2CfDnF1znU6b3?=
 =?us-ascii?Q?clmqdlWi2i41QJL18Xwa+EfkHtcsFu6bbHCDLAUIsqae093S97WafFxmY4fp?=
 =?us-ascii?Q?9LPI/p3+cfB2K8TmhGZ/ONbER/TOz4xmLnB0bj7B6pd2MSdmE7STuBamnxlL?=
 =?us-ascii?Q?1za0sypeScHwoC8DAbKhM0DH/BbfGp3SGr2uEmW4flsrbqEoPXJT1yLmQe83?=
 =?us-ascii?Q?VhiVGXg6DbYMY/q1kX1x9qly8jd/Omp30eLUTTXOYDF+lYXJlzu4Am36THS/?=
 =?us-ascii?Q?dd3O8mumGU++nKbd7Te0kjnWohTHMFQsDmvFduhiAIqqx+D7+Gdvw13f5dZf?=
 =?us-ascii?Q?1ApEQr5EWgX0yfsk3sM9yFXXP4IEB59VjRKNjLNhVE4s1XVVwk9glmgyLPJF?=
 =?us-ascii?Q?/qK5bpzuGLBZq99ScF3q0zZvfg2gzP3vYMvBn7p059SZw6QcStJtrovhvU7+?=
 =?us-ascii?Q?2x/4PKQzzljp/MleI2SWuBLg67Pb84nW0amk+QHynH3VY5GB5RfJwlifa28s?=
 =?us-ascii?Q?D9rIrdPAvqBRQy3IKqRsloZ1eVHGQw4gW5BlUGn+wlBXsaePw1oLB1DPjTYP?=
 =?us-ascii?Q?ndROBf3acnMgNw17z3An6McO3koEHjnxBpj0pyt8BtImsEIlVLImNO/Kthuw?=
 =?us-ascii?Q?K0KpnK/nanKZ3VvyKNLdAe3NK4UrwZcMc30uNp5e0u6HFTFB/DHLRR9qwPZs?=
 =?us-ascii?Q?NZeXE+MxfDsCFZq/xGYmmK9OV+AwKbUC//fh9YA+AfPEb2zJru+RjFAh8hKE?=
 =?us-ascii?Q?9TfyOfAAFNGqtjWajgdNbU1ZA77t3noIHa80i2i4dQ/dQObtGN+wa3UcWu2q?=
 =?us-ascii?Q?4899qAwXi2W2/oBkSx2vo1iR7Aa4car+pGFgWj5kuTk+tmBbka3EVip/ET6h?=
 =?us-ascii?Q?bddtSx1x9YGgr6a6vNIfjunytB3irmh1b4eS3Olt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94645e02-1b5a-4354-ae33-08da8d1da5f0
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 19:59:30.5959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IlxX7snXa5DtEsTxh8/gJ8tj3ClFyzsnRf+vK9qCMmK6m100fB5GX73gR1m9ObDx
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

The hw_pagetable object exposes the internal struct iommu_domain's to
userspace. An iommu_domain is required when any DMA device attaches to an
IOAS to control the io page table through the iommu driver.

For compatibility with VFIO the hw_pagetable is automatically created when
a DMA device is attached to the IOAS. If a compatible iommu_domain already
exists then the hw_pagetable associated with it is used for the
attachment.

In the initial series there is no iommufd uAPI for the hw_pagetable
object. The next patch provides driver facing APIs for IO page table
attachment that allows drivers to accept either an IOAS or a hw_pagetable
ID and for the driver to return the hw_pagetable ID that was auto-selected
from an IOAS. The expectation is the driver will provide uAPI through its
own FD for attaching its device to iommufd. This allows userspace to learn
the mapping of devices to iommu_domains and to override the automatic
attachment.

The future HW specific interface will allow userspace to create
hw_pagetable objects using iommu_domains with IOMMU driver specific
parameters. This infrastructure will allow linking those domains to IOAS's
and devices.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/Makefile          |  1 +
 drivers/iommu/iommufd/hw_pagetable.c    | 68 +++++++++++++++++++++++++
 drivers/iommu/iommufd/ioas.c            | 20 ++++++++
 drivers/iommu/iommufd/iommufd_private.h | 36 +++++++++++++
 drivers/iommu/iommufd/main.c            |  3 ++
 5 files changed, 128 insertions(+)
 create mode 100644 drivers/iommu/iommufd/hw_pagetable.c

diff --git a/drivers/iommu/iommufd/Makefile b/drivers/iommu/iommufd/Makefile
index 2b4f36f1b72f9d..e13e971aa28c60 100644
--- a/drivers/iommu/iommufd/Makefile
+++ b/drivers/iommu/iommufd/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 iommufd-y := \
+	hw_pagetable.o \
 	io_pagetable.o \
 	ioas.o \
 	main.o \
diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
new file mode 100644
index 00000000000000..c7e05ec7a11380
--- /dev/null
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES
+ */
+#include <linux/iommu.h>
+
+#include "iommufd_private.h"
+
+void iommufd_hw_pagetable_destroy(struct iommufd_object *obj)
+{
+	struct iommufd_hw_pagetable *hwpt =
+		container_of(obj, struct iommufd_hw_pagetable, obj);
+
+	WARN_ON(!list_empty(&hwpt->devices));
+
+	iommu_domain_free(hwpt->domain);
+	refcount_dec(&hwpt->ioas->obj.users);
+	mutex_destroy(&hwpt->devices_lock);
+}
+
+/**
+ * iommufd_hw_pagetable_alloc() - Get an iommu_domain for a device
+ * @ictx: iommufd context
+ * @ioas: IOAS to associate the domain with
+ * @dev: Device to get an iommu_domain for
+ *
+ * Allocate a new iommu_domain and return it as a hw_pagetable.
+ */
+struct iommufd_hw_pagetable *
+iommufd_hw_pagetable_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
+			   struct device *dev)
+{
+	struct iommufd_hw_pagetable *hwpt;
+	int rc;
+
+	hwpt = iommufd_object_alloc(ictx, hwpt, IOMMUFD_OBJ_HW_PAGETABLE);
+	if (IS_ERR(hwpt))
+		return hwpt;
+
+	hwpt->domain = iommu_domain_alloc(dev->bus);
+	if (!hwpt->domain) {
+		rc = -ENOMEM;
+		goto out_abort;
+	}
+
+	/*
+	 * If the IOMMU can block non-coherent operations (ie PCIe TLPs with
+	 * no-snoop set) then always turn it on. We currently don't have a uAPI
+	 * to allow userspace to restore coherency if it wants to use no-snoop
+	 * TLPs.
+	 */
+	if (hwpt->domain->ops->enforce_cache_coherency)
+		hwpt->enforce_cache_coherency =
+			hwpt->domain->ops->enforce_cache_coherency(
+				hwpt->domain);
+
+	INIT_LIST_HEAD(&hwpt->devices);
+	INIT_LIST_HEAD(&hwpt->hwpt_item);
+	mutex_init(&hwpt->devices_lock);
+	/* Pairs with iommufd_hw_pagetable_destroy() */
+	refcount_inc(&ioas->obj.users);
+	hwpt->ioas = ioas;
+	return hwpt;
+
+out_abort:
+	iommufd_object_abort(ictx, &hwpt->obj);
+	return ERR_PTR(rc);
+}
diff --git a/drivers/iommu/iommufd/ioas.c b/drivers/iommu/iommufd/ioas.c
index f9f545158a4891..42b9a04188a116 100644
--- a/drivers/iommu/iommufd/ioas.c
+++ b/drivers/iommu/iommufd/ioas.c
@@ -17,6 +17,7 @@ void iommufd_ioas_destroy(struct iommufd_object *obj)
 	rc = iopt_unmap_all(&ioas->iopt, NULL);
 	WARN_ON(rc && rc != -ENOENT);
 	iopt_destroy_table(&ioas->iopt);
+	mutex_destroy(&ioas->mutex);
 }
 
 struct iommufd_ioas *iommufd_ioas_alloc(struct iommufd_ctx *ictx)
@@ -31,6 +32,9 @@ struct iommufd_ioas *iommufd_ioas_alloc(struct iommufd_ctx *ictx)
 	rc = iopt_init_table(&ioas->iopt);
 	if (rc)
 		goto out_abort;
+
+	INIT_LIST_HEAD(&ioas->hwpt_list);
+	mutex_init(&ioas->mutex);
 	return ioas;
 
 out_abort:
@@ -314,3 +318,19 @@ int iommufd_ioas_unmap(struct iommufd_ucmd *ucmd)
 	iommufd_put_object(&ioas->obj);
 	return rc;
 }
+
+bool iommufd_ioas_enforced_coherent(struct iommufd_ioas *ioas)
+{
+	struct iommufd_hw_pagetable *hwpt;
+	bool ret = true;
+
+	mutex_lock(&ioas->mutex);
+	list_for_each_entry(hwpt, &ioas->hwpt_list, hwpt_item) {
+		if (!hwpt->enforce_cache_coherency) {
+			ret = false;
+			break;
+		}
+	}
+	mutex_unlock(&ioas->mutex);
+	return ret;
+}
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 0ef6b9bf4916eb..4f628800bc2b71 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -92,6 +92,7 @@ static inline int iommufd_ucmd_respond(struct iommufd_ucmd *ucmd,
 enum iommufd_object_type {
 	IOMMUFD_OBJ_NONE,
 	IOMMUFD_OBJ_ANY = IOMMUFD_OBJ_NONE,
+	IOMMUFD_OBJ_HW_PAGETABLE,
 	IOMMUFD_OBJ_IOAS,
 };
 
@@ -169,10 +170,20 @@ struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
  * io_pagetable object. It is a user controlled mapping of IOVA -> PFNs. The
  * mapping is copied into all of the associated domains and made available to
  * in-kernel users.
+ *
+ * Every iommu_domain that is created is wrapped in a iommufd_hw_pagetable
+ * object. When we go to attach a device to an IOAS we need to get an
+ * iommu_domain and wrapping iommufd_hw_pagetable for it.
+ *
+ * An iommu_domain & iommfd_hw_pagetable will be automatically selected
+ * for a device based on the hwpt_list. If no suitable iommu_domain
+ * is found a new iommu_domain will be created.
  */
 struct iommufd_ioas {
 	struct iommufd_object obj;
 	struct io_pagetable iopt;
+	struct mutex mutex;
+	struct list_head hwpt_list;
 };
 
 static inline struct iommufd_ioas *iommufd_get_ioas(struct iommufd_ucmd *ucmd,
@@ -182,6 +193,7 @@ static inline struct iommufd_ioas *iommufd_get_ioas(struct iommufd_ucmd *ucmd,
 					       IOMMUFD_OBJ_IOAS),
 			    struct iommufd_ioas, obj);
 }
+bool iommufd_ioas_enforced_coherent(struct iommufd_ioas *ioas);
 
 struct iommufd_ioas *iommufd_ioas_alloc(struct iommufd_ctx *ictx);
 int iommufd_ioas_alloc_ioctl(struct iommufd_ucmd *ucmd);
@@ -191,4 +203,28 @@ int iommufd_ioas_allow_iovas(struct iommufd_ucmd *ucmd);
 int iommufd_ioas_map(struct iommufd_ucmd *ucmd);
 int iommufd_ioas_copy(struct iommufd_ucmd *ucmd);
 int iommufd_ioas_unmap(struct iommufd_ucmd *ucmd);
+
+/*
+ * A HW pagetable is called an iommu_domain inside the kernel. This user object
+ * allows directly creating and inspecting the domains. Domains that have kernel
+ * owned page tables will be associated with an iommufd_ioas that provides the
+ * IOVA to PFN map.
+ */
+struct iommufd_hw_pagetable {
+	struct iommufd_object obj;
+	struct iommufd_ioas *ioas;
+	struct iommu_domain *domain;
+	bool auto_domain : 1;
+	bool enforce_cache_coherency : 1;
+	/* Head at iommufd_ioas::hwpt_list */
+	struct list_head hwpt_item;
+	struct mutex devices_lock;
+	struct list_head devices;
+};
+
+struct iommufd_hw_pagetable *
+iommufd_hw_pagetable_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
+			   struct device *dev);
+void iommufd_hw_pagetable_destroy(struct iommufd_object *obj);
+
 #endif
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 55b42eeb141b20..2a9b581cacffb6 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -330,6 +330,9 @@ static struct iommufd_object_ops iommufd_object_ops[] = {
 	[IOMMUFD_OBJ_IOAS] = {
 		.destroy = iommufd_ioas_destroy,
 	},
+	[IOMMUFD_OBJ_HW_PAGETABLE] = {
+		.destroy = iommufd_hw_pagetable_destroy,
+	},
 };
 
 static struct miscdevice iommu_misc_dev = {
-- 
2.37.3

