Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0EF4DDFED
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 18:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239638AbiCRR3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 13:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239636AbiCRR3K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 13:29:10 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E877320C19E
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 10:27:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K1peycVRxBYRPofDFeialPeZYvdEf6XU46lBI2NAqmNXh2pMSbczW7GCP077mM/AIlzUns7BGFYvlwnNLzT7X4HdOo6HBAi7h/2uSeIIoDESEKNt5mp4CRRdR9MjgxF24POfrLVrkQWKe6AIc6D7DG1QFC+j/dRvmaL5xnvRMEcxoVfYYSqAP6ar6+WxZDZlEVH82hS8bceFW6DVnQUNMJ1NZlkgwPyPKlQOjxPdt5AASYhEmI/f3Gx4PyvBzHZ6Zlio8pDi5euGEF/W5BSkqrmkL3vfZ9Xai58R5tjIebwphZ/pPmA/IRJd/KQMzbtkwRT882SsNVcpKYy0Gf4/Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eBhljm885tuF+r13knAd8C5boMj48iH8g6P3EMq7lWA=;
 b=Qq3InIocfcn35TaxpOcD4FT13zPAi9WanOqO764WJZhjMR3TQDidT5kd5Tbq/5ZF3Ur2awlquoJQeVQFdLMpumMrus5eoeGPhPsQQahlOKezr6kveE4xNvX0MxGk3xsyBcvDQq8uMEO+wAZ/iPdueSvWUYZVil10FPZXOVcfrdHi9FuGyaT/8MB9FVDTfKuDIeYFxMlsqOG2ElinSHILMSBfIJxHEQNhQzjjIoCOgRnsNzkxqueN/zYa3wyPGCymgRQtDm4Roe4wWWjKgm1D265kYOu5QQGJJ1Z3/GbuFVnzepUEadE/0l+dmPnNOSuaYlNwtsBwj6FmmN9FOYfcaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eBhljm885tuF+r13knAd8C5boMj48iH8g6P3EMq7lWA=;
 b=sL3pP8bsTqND/kNqgbXJg4F7S02YpnVoXGfvbGu7Ak1jS8cS54jB7wpRRaTZMcV0Xc0Hax/erwy4YIOqQeO+ZMZCuTF7gwAK3wL0NX5q/3uhZHR2Rr20fsOf+DVUJFsZHpJrQ3Sa5eiIyIuTP/n8VU3eOabV+Q+tZXBLXswTbCqGROj2W0MIk+pUBsY+Ab3CeiBI4PWnswoX/0P77+OzTMjrT3QKel/2u4smz5A53et9uMZERo/NNu9QEYBOnLvNQ7CdFMaNd2RmvGPBguqZ0cu8xj9mDa3zQIhowuM9WiBRfWFVhv9HJwmztvZaH+XYIkbAQynNn6h6eFPyJ9kZjQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB3951.namprd12.prod.outlook.com (2603:10b6:208:16b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Fri, 18 Mar
 2022 17:27:44 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%5]) with mapi id 15.20.5081.018; Fri, 18 Mar 2022
 17:27:44 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
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
Subject: [PATCH RFC 09/12] iommufd: Add a HW pagetable object
Date:   Fri, 18 Mar 2022 14:27:34 -0300
Message-Id: <9-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0059.namprd19.prod.outlook.com
 (2603:10b6:208:19b::36) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0bd1f63b-dd01-4b3f-4eac-08da09049a7a
X-MS-TrafficTypeDiagnostic: MN2PR12MB3951:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3951EDDC33F273123DF15D69C2139@MN2PR12MB3951.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2sDi9ZMNho4StKQRCmLuA1HOKi3tiFSi5hDCFvZpgVGm+5EdsK4sF2uom1SxXk4wiVBQOSpf95JSMEMOH+QqnRN9hv+9moRigkQsczRMA77wuhzKCha61t5i4TMM23+GGfGSJUAczra2p3MiVuIKn8qsHOKa+VSJcHvgAT/qcczjkiNxw3jwOUx/PXpkf+3bOMjtu6wydU8lVSsyy/311z8y8RSpC8ZBeVn8RbR0i29NzUe4XbeC0b5FuWlCGHNO/k0QVVkO7oNJ7YgiACDHm6u3jQuoMFrDE8HpGzZa5o0UAddsK0eIq3iUu+qwZlVo04lzK6QSvhzlgRVp1ELRcCpRj4/6wOoJ5R5qxSe75461YAZs8n6VqHtihsQR6b6OxF/iJj8afuUbXTBGpVWOoooSguAFX7l59TRd+sNM0gCbCKD43aol5EBVsYYgLpmTSo4Kt4rnM61Zk0ACe7YReiGz5p3KMAb/wTVGwPUGP7moB1dzFvf9mAf4ad02yL6jQ/9fBKkSIo6z89pT/vaK5piUGdD2WtDKRSNNISalMjrqWRom0zrMl95RWfjYo1pGyhBcgTG6IUv431S1j40BFEYpUKarRL2b4x7vxQQeeZLHiKbXb7pybw33CGu91yqQ4nAoxfM0dLLgPtpTyioJlY+b5hv9TwH4whHustYDQ7ijuEYvVehDuJnb0Y14IJBx+HXFLJsGk2+VMd9M/xepMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(7416002)(4326008)(2906002)(86362001)(508600001)(8676002)(6512007)(6506007)(6666004)(5660300002)(8936002)(109986005)(66946007)(26005)(66476007)(186003)(316002)(66556008)(2616005)(36756003)(38100700002)(6486002)(54906003)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CUC4JDdRSDt7uqbCy6FFhwP8H+HcL9Ndf9w/CtsDdurxntbc95xOMEHciA2H?=
 =?us-ascii?Q?gD0dKXsbLvK9wOPv1otWLlg3CNGn2kzB2zpDFeryybL2Xl4pjN31B+ptVe4V?=
 =?us-ascii?Q?cnElErCj5Ttju41W48XaxQ1+FgUHs6xrshfykL4UfWuSfwSPQShmpSrQ7bpL?=
 =?us-ascii?Q?9MZdp1z36Mp8fFzOEUGQ1VxmT8hP6ryQgRFow5mqmHnzP8LLHWYm328QMIzg?=
 =?us-ascii?Q?8q5HTVUFx4IiblYSP09SKra/1cicupCIEMfH1kz66B0JN7NKnx9lRUStFjle?=
 =?us-ascii?Q?n1vd/gStcMPnhCCHc2E2kaNK2lMlGuVsw7n5RTXCuzVTuQRouy46WhpZMZ0Y?=
 =?us-ascii?Q?+mfX2nUKi8gVLCwdXiabdCQc8uhekTzgwdlIIP2i9qD84RMaQWBjC8w6gF6H?=
 =?us-ascii?Q?8sk4dkPcyG/UGRl8k/OPfCZBuEtDWLMtR3DmicpN1PADR0xOfNFVHoQfB7p5?=
 =?us-ascii?Q?ht8tF8XUZz8fsNkzWQUwpPhdzRfyn1sZqR2kgcygMMS0hyYKsdruf3GUEJXJ?=
 =?us-ascii?Q?cf/RDu6Oo4nJDnvlD0VFjdF5/C/gCi4+Lio/OCXsKdmQtlXkkj39l41i3atR?=
 =?us-ascii?Q?jS/GT2v0e2faWAtCG3ahiNlbOBkci84fRW6Dry/RxtkJ2lZBrhRyyeRrzN5X?=
 =?us-ascii?Q?+9xSe8sBeJxab8c/rm+SOlKQRfAe6L40zhdz8Z35GPVmVu0GlOdj8aoT4Lxr?=
 =?us-ascii?Q?Z/7yIz9T7fLFBoLEaAYWmtXLRcBxd8nNJxajkDMfBnbnDx5fzZMLtxFf6pY4?=
 =?us-ascii?Q?gGT6rEuHA9WnOohzyvCvasHlwL7vFoR7gXnGgjjrNdr+YJrTXJdm9QjOXAuk?=
 =?us-ascii?Q?F5A0rW+l+HDhlX0jkOfaGs1rFkMmlqPiBA5jmCuE1DYGJ07Q8lihu5DJOHo8?=
 =?us-ascii?Q?9u/Di/a+lWxKYH9e3qjhsA9hmxleEi0uDKYTmHATZgeT1DYkcaLQrtJB027e?=
 =?us-ascii?Q?g2GBJDzX5YjTO0V3kSjdb5tyGw1+hv1LxLt1lcO6R7zTGOkZygTKcgZJYR/l?=
 =?us-ascii?Q?FbBAGIJ4t+Tx0t5WI1+P7v6Sz1db4EtRHH0DLebmrRTIrgWqg424tyYTYIWY?=
 =?us-ascii?Q?WNMv5XgLqIKcq9Vh3bxQcgCL9NUcpJfnCFiAggqIC/+3po8xp3YluztPC9mH?=
 =?us-ascii?Q?ZLZzVL087u9cek5/g0kG1lcI5fpAWhLojeCopq0OJfq8IpO/U6HeHQwU0bsH?=
 =?us-ascii?Q?DjbEBBogWMYvdfo4+8d9fQbkfav3lfU+CuF9Og80PCbrisCFhYN1Vy980od9?=
 =?us-ascii?Q?LaGVcHBFt9oDshG2Q4IYWai6jCEka69I04z89Gzis1/LeeZF8Ebj5zf9jfrE?=
 =?us-ascii?Q?XNg+VaOc82BW+CCSUgM3tb4WOwckseiMv+V1W/GjM3T+ZsuNMAkPBPseCm3N?=
 =?us-ascii?Q?g74j9RstCNsYDsVMyHguixQFYRkryr0milIlZP+grJoeTeoP3bZ2DtWL/1GY?=
 =?us-ascii?Q?EU+kBD3B1IIQQB6bwNIDpFde2Ghxp0HG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bd1f63b-dd01-4b3f-4eac-08da09049a7a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 17:27:40.4603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Rv+JnpVvkSAsVMIgF9iebYrYkVV/Vja4fm4x5iiNnUzVvHDHVSO0Xse6lwV9jHO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3951
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
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
 drivers/iommu/iommufd/Makefile          |   1 +
 drivers/iommu/iommufd/hw_pagetable.c    | 142 ++++++++++++++++++++++++
 drivers/iommu/iommufd/ioas.c            |   4 +
 drivers/iommu/iommufd/iommufd_private.h |  35 ++++++
 drivers/iommu/iommufd/main.c            |   3 +
 5 files changed, 185 insertions(+)
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
index 00000000000000..bafd7d07918bfd
--- /dev/null
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -0,0 +1,142 @@
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
+	struct iommufd_ioas *ioas = hwpt->ioas;
+
+	WARN_ON(!list_empty(&hwpt->devices));
+	mutex_lock(&ioas->mutex);
+	list_del(&hwpt->auto_domains_item);
+	mutex_unlock(&ioas->mutex);
+
+	iommu_domain_free(hwpt->domain);
+	refcount_dec(&hwpt->ioas->obj.users);
+	mutex_destroy(&hwpt->devices_lock);
+}
+
+/*
+ * When automatically managing the domains we search for a compatible domain in
+ * the iopt and if one is found use it, otherwise create a new domain.
+ * Automatic domain selection will never pick a manually created domain.
+ */
+static struct iommufd_hw_pagetable *
+iommufd_hw_pagetable_auto_get(struct iommufd_ctx *ictx,
+			      struct iommufd_ioas *ioas, struct device *dev)
+{
+	struct iommufd_hw_pagetable *hwpt;
+	int rc;
+
+	/*
+	 * There is no differentiation when domains are allocated, so any domain
+	 * from the right ops is interchangeable with any other.
+	 */
+	mutex_lock(&ioas->mutex);
+	list_for_each_entry (hwpt, &ioas->auto_domains, auto_domains_item) {
+		/*
+		 * FIXME: We really need an op from the driver to test if a
+		 * device is compatible with a domain. This thing from VFIO
+		 * works sometimes.
+		 */
+		if (hwpt->domain->ops == dev_iommu_ops(dev)->default_domain_ops) {
+			if (refcount_inc_not_zero(&hwpt->obj.users)) {
+				mutex_unlock(&ioas->mutex);
+				return hwpt;
+			}
+		}
+	}
+
+	hwpt = iommufd_object_alloc(ictx, hwpt, IOMMUFD_OBJ_HW_PAGETABLE);
+	if (IS_ERR(hwpt)) {
+		rc = PTR_ERR(hwpt);
+		goto out_unlock;
+	}
+
+	hwpt->domain = iommu_domain_alloc(dev->bus);
+	if (!hwpt->domain) {
+		rc = -ENOMEM;
+		goto out_abort;
+	}
+
+	INIT_LIST_HEAD(&hwpt->devices);
+	mutex_init(&hwpt->devices_lock);
+	hwpt->ioas = ioas;
+	/* The calling driver is a user until iommufd_hw_pagetable_put() */
+	refcount_inc(&ioas->obj.users);
+
+	list_add_tail(&hwpt->auto_domains_item, &ioas->auto_domains);
+	/*
+	 * iommufd_object_finalize() consumes the refcount, get one for the
+	 * caller. This pairs with the first put in
+	 * iommufd_object_destroy_user()
+	 */
+	refcount_inc(&hwpt->obj.users);
+	iommufd_object_finalize(ictx, &hwpt->obj);
+
+	mutex_unlock(&ioas->mutex);
+	return hwpt;
+
+out_abort:
+	iommufd_object_abort(ictx, &hwpt->obj);
+out_unlock:
+	mutex_unlock(&ioas->mutex);
+	return ERR_PTR(rc);
+}
+
+/**
+ * iommufd_hw_pagetable_from_id() - Get an iommu_domain for a device
+ * @ictx: iommufd context
+ * @pt_id: ID of the IOAS or hw_pagetable object
+ * @dev: Device to get an iommu_domain for
+ *
+ * Turn a general page table ID into an iommu_domain contained in a
+ * iommufd_hw_pagetable object. If a hw_pagetable ID is specified then that
+ * iommu_domain is used, otherwise a suitable iommu_domain in the IOAS is found
+ * for the device, creating one automatically if necessary.
+ */
+struct iommufd_hw_pagetable *
+iommufd_hw_pagetable_from_id(struct iommufd_ctx *ictx, u32 pt_id,
+			     struct device *dev)
+{
+	struct iommufd_object *obj;
+
+	obj = iommufd_get_object(ictx, pt_id, IOMMUFD_OBJ_ANY);
+	if (IS_ERR(obj))
+		return ERR_CAST(obj);
+
+	switch (obj->type) {
+	case IOMMUFD_OBJ_HW_PAGETABLE:
+		iommufd_put_object_keep_user(obj);
+		return container_of(obj, struct iommufd_hw_pagetable, obj);
+	case IOMMUFD_OBJ_IOAS: {
+		struct iommufd_ioas *ioas =
+			container_of(obj, struct iommufd_ioas, obj);
+		struct iommufd_hw_pagetable *hwpt;
+
+		hwpt = iommufd_hw_pagetable_auto_get(ictx, ioas, dev);
+		iommufd_put_object(obj);
+		return hwpt;
+	}
+	default:
+		iommufd_put_object(obj);
+		return ERR_PTR(-EINVAL);
+	}
+}
+
+void iommufd_hw_pagetable_put(struct iommufd_ctx *ictx,
+			      struct iommufd_hw_pagetable *hwpt)
+{
+	if (list_empty(&hwpt->auto_domains_item)) {
+		/* Manually created hw_pagetables just keep going */
+		refcount_dec(&hwpt->obj.users);
+		return;
+	}
+	iommufd_object_destroy_user(ictx, &hwpt->obj);
+}
diff --git a/drivers/iommu/iommufd/ioas.c b/drivers/iommu/iommufd/ioas.c
index c530b2ba74b06b..48149988c84bbc 100644
--- a/drivers/iommu/iommufd/ioas.c
+++ b/drivers/iommu/iommufd/ioas.c
@@ -17,6 +17,7 @@ void iommufd_ioas_destroy(struct iommufd_object *obj)
 	rc = iopt_unmap_all(&ioas->iopt);
 	WARN_ON(rc);
 	iopt_destroy_table(&ioas->iopt);
+	mutex_destroy(&ioas->mutex);
 }
 
 struct iommufd_ioas *iommufd_ioas_alloc(struct iommufd_ctx *ictx)
@@ -31,6 +32,9 @@ struct iommufd_ioas *iommufd_ioas_alloc(struct iommufd_ctx *ictx)
 	rc = iopt_init_table(&ioas->iopt);
 	if (rc)
 		goto out_abort;
+
+	INIT_LIST_HEAD(&ioas->auto_domains);
+	mutex_init(&ioas->mutex);
 	return ioas;
 
 out_abort:
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index d24c9dac5a82a9..c5c9650cc86818 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -96,6 +96,7 @@ static inline int iommufd_ucmd_respond(struct iommufd_ucmd *ucmd,
 enum iommufd_object_type {
 	IOMMUFD_OBJ_NONE,
 	IOMMUFD_OBJ_ANY = IOMMUFD_OBJ_NONE,
+	IOMMUFD_OBJ_HW_PAGETABLE,
 	IOMMUFD_OBJ_IOAS,
 	IOMMUFD_OBJ_MAX,
 };
@@ -153,10 +154,20 @@ struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
  * io_pagetable object. It is a user controlled mapping of IOVA -> PFNs. The
  * mapping is copied into all of the associated domains and made available to
  * in-kernel users.
+ *
+ * Every iommu_domain that is created is wrapped in a iommufd_hw_pagetable
+ * object. When we go to attach a device to an IOAS we need to get an
+ * iommu_domain and wrapping iommufd_hw_pagetable for it.
+ *
+ * An iommu_domain & iommfd_hw_pagetable will be automatically selected
+ * for a device based on the auto_domains list. If no suitable iommu_domain
+ * is found a new iommu_domain will be created.
  */
 struct iommufd_ioas {
 	struct iommufd_object obj;
 	struct io_pagetable iopt;
+	struct mutex mutex;
+	struct list_head auto_domains;
 };
 
 static inline struct iommufd_ioas *iommufd_get_ioas(struct iommufd_ucmd *ucmd,
@@ -174,4 +185,28 @@ int iommufd_ioas_iova_ranges(struct iommufd_ucmd *ucmd);
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
+	/* Head at iommufd_ioas::auto_domains */
+	struct list_head auto_domains_item;
+	struct mutex devices_lock;
+	struct list_head devices;
+};
+
+struct iommufd_hw_pagetable *
+iommufd_hw_pagetable_from_id(struct iommufd_ctx *ictx, u32 pt_id,
+			     struct device *dev);
+void iommufd_hw_pagetable_put(struct iommufd_ctx *ictx,
+			      struct iommufd_hw_pagetable *hwpt);
+void iommufd_hw_pagetable_destroy(struct iommufd_object *obj);
+
 #endif
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index e506f493b54cfe..954cde173c86fc 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -287,6 +287,9 @@ static struct iommufd_object_ops iommufd_object_ops[] = {
 	[IOMMUFD_OBJ_IOAS] = {
 		.destroy = iommufd_ioas_destroy,
 	},
+	[IOMMUFD_OBJ_HW_PAGETABLE] = {
+		.destroy = iommufd_hw_pagetable_destroy,
+	},
 };
 
 static struct miscdevice iommu_misc_dev = {
-- 
2.35.1

