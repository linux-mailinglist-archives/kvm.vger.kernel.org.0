Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6484DDFEA
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 18:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239635AbiCRR3O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 13:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239639AbiCRR3M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 13:29:12 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B912DED
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 10:27:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nd5FzH9omBHcaR09YqXoh+hK9TCTBOqP7c6H0xOSUbFK+GhSixkQSHQ5qiHUyJ4WjwOITib8wiFRRMMP3xA/Yz+QSdXnDwQ3zgt8js87ruWfp/fDwQ/KfY6MuZFMhL93HQHprFCBnvObFsNi1DE9E55Y7i3BipzRuaZVgtZa0xkksAtffbsnnTvolmAXV/Ekzp+KVGJQtW3vFhvKxX8vTxH4P1hU4Y3qJO7vzk4GGS14tLEo6Qsu0AYtqwDP4saYZCrgHaTXOf2v5QUbeoRtduPLCnQt43AkouRsXnpxa6pDx7qwOM3uZl07jhatu4UK+v+azyTFKSjiKbcD8qhScA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tfJq4DR+Yo1ZHM8NIH4c/wojdHPsryGCdV3gE+Wmn5Q=;
 b=M5RPk4rQTszZmBahO1yKmwfUquokcGXf7T6vcsKTyW/SejzS5WsRoXshSJ1y2X1laBGG3RPTzL5OxEH8kL88Th9sgn8zByRqr8cWA6vMLttGDCCj6LtwDPZgcc88Eplo0rcnAeKmH1jifJpIOGIPnmaAPRQt2alLPhaEPGjM1O4Jut3Lu0CH8HiY4/1i8ZXCzsfgqYRbYRCerCaUo1zV/HJhGRBZ/k3MT7nwIBjjYmdwcU20TBfzTAiq1UtDFlT7Lj58mCNcJKHVDPUfQ0JOV+H16Vli4xYWGuPsMSoFFXHnuk+35uDK9WhNIYB+puxfmugRL9v7iphAqrrqrRQzwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tfJq4DR+Yo1ZHM8NIH4c/wojdHPsryGCdV3gE+Wmn5Q=;
 b=YEHrGGsGbSvpcpulQ/m8j+WG8mZaS1KkfpYB/Eys9+hnEppzLaXanVcnp80qsyyGDK4ko17Xwj09EOkydFxdXPk8LNGkRE41ebWyJ+v4UQMreiZ63bHwxlwzQfPCXegssxBXZs4U9hrm8u/NfpiTFH7BYreT4VtTvX6E8IW/PNSxoDoLr2NKADAT5xs9Nru4a35a9MblSjzSibJRUglGTa5MAfjdTWJxp+JeyEZRy8nBsT6BJHbsTTmS0HFjxYhNbzDvtRSinBmwUO9T4sDaE/KpRuBJpZvUpSw44z1/4eY/cCWFDC0DyVcwM6eo/X4RRKQkfXcnz6vLeOserISU1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB3951.namprd12.prod.outlook.com (2603:10b6:208:16b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Fri, 18 Mar
 2022 17:27:45 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%5]) with mapi id 15.20.5081.018; Fri, 18 Mar 2022
 17:27:45 +0000
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
Subject: [PATCH RFC 10/12] iommufd: Add kAPI toward external drivers
Date:   Fri, 18 Mar 2022 14:27:35 -0300
Message-Id: <10-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0038.namprd19.prod.outlook.com
 (2603:10b6:208:19b::15) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c2cb800-5e35-41d2-609e-08da09049a8d
X-MS-TrafficTypeDiagnostic: MN2PR12MB3951:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3951399C911BBE622B69FE0EC2139@MN2PR12MB3951.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DlB/U9aQAvU1HRHgvKzz0JLQkE+UXncJIFMws8Xyb7ktHIjXByJmDHWbFRhaIv/WoQbcZOzBLcC4oSeQkuhW/oMJsQbjBxdP2LqzGCfsgCmm/uFaM6zlLOIj1Hw7cJaDyKUbixsbtlMgdWSgshwLBq8Oh9UmHyrNuUV4tFQv7zxQzZ4hXhB9uVsHoSC+sVdXVuNYkjwyBGN3fvmcJZG1RZhkz9jZSAacTjB+osPEt+s1XGI+J/XTwVaYm5CBEIYamUiUtmS/tGsAf4PVvhY6LbleilBf9QrlGe35r/ayCeQw2PktYiwAeDX3jA7m7ASqS1X3tqUmtMzsgmxteux+hD7BeU1xyDi9GMUdCzPSngFFVE8wCZ57qigbBEE+4Js325KC+P/DPH251cTXR2kYKPP0bK32AmnBfDfeXmCZwQkenF/pIpeAQd+XTPR3zkCnPI6ztKTdqZAb9D3CRKc1KqrbgNo4rAhN69zkDxmz2VQ2zu2pgAYVbLXanrSEkrykecrLiNhfuZbfKGZ/x/hqe3X/fCy4vwHfdAM3PB7C8D9TnoYR+B6ldzyWSe/kG+SbAWDIHK4mFKyJb25CGojRhj2DeWM1wtUjt/j6hgmtyM33olc9dm25HYrxaAFCTWJ0bdVKrlKR8ru9+vg8s0o8OrN2dXB3M6Ll7EeYzGb+sANhcGQ+uUfTPAu9mIS60zZq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(30864003)(83380400001)(7416002)(4326008)(2906002)(86362001)(508600001)(8676002)(6512007)(6506007)(6666004)(5660300002)(8936002)(109986005)(66946007)(26005)(66476007)(186003)(316002)(66556008)(2616005)(36756003)(38100700002)(6486002)(54906003)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vRkkSUAG/ax2WvTWGr84bcI1YRNQRQtuptMHEdpZUDFKIGnj80TmwavyiRdI?=
 =?us-ascii?Q?eJTxAyF6Va6nrqca9BfPm+p6/OgF+e9i2bfm7pW5GM+c5SEcKAoseJQDdSo1?=
 =?us-ascii?Q?MajeiBJSawB+MDUP2XFnnDYqnhZpyyILT77b+CctcZawt4TkNHcBem6oh4KO?=
 =?us-ascii?Q?PPW+1q7oVnxiDiXcdXJodYT05KY10k2FhlT3N+x5i63dSlXWEODn10km03JI?=
 =?us-ascii?Q?eJZZhUUdu5YGNEMJ8b+fHI/m3y84WDk99ecWzR3ftnsiovaPIlOfesvVXkCR?=
 =?us-ascii?Q?GD9l0rpkw4+d0Ztg2AdqEtmqu575d+ZDUlkWMZ3y6owfwlLz2sa7kGLslHSa?=
 =?us-ascii?Q?fduWV/hsygbd2YfZCR2Rk0eaVoJCQBrPyF1Cz5+liZGhccREgJirocgPoQrO?=
 =?us-ascii?Q?xHjXtrUNGwOVs4y7X8w7w29I/8qZKaJLb2i1jM3QGoNCqOBxKjLFF0+iO23V?=
 =?us-ascii?Q?DyL8ejtYs9wjteNDXVdWU/ivxtxlJiVQGHF0yLm/2JAQZPCQV24ioN1cHYtg?=
 =?us-ascii?Q?+K1z4OyfjlafNoRmIjUTAVxdQVQb7TTPkMwTSudPwXVA8wzmdba95m75fAMv?=
 =?us-ascii?Q?H6jaEgfCgK4fufb+SVS1ZvPw9s/z6FFEsRbUHnAgjjp/TVrU70yqxW7aFfVY?=
 =?us-ascii?Q?sobT8qFYX/Kw4uaqBbt7zTEzujNY8aqEHRyHoe1TGDcdsC/QDKj+9tuE2EZa?=
 =?us-ascii?Q?bemDu3YFyj6qPSAudEYxDFdUktf3shvb07bcn+xnj+mNLPK3AMW61jQ+Mxhd?=
 =?us-ascii?Q?fqbDDRI+86E6IYmbo8j5tOL3xhwmPqTRgGD+q5Sas4WgQdB9uPn1PYQ+CxNZ?=
 =?us-ascii?Q?1n7Ko7IGX1UHk2gnxHt0M1qDHQ7kqWFCznLlMxvR2WGQJfGOP/fLe26FLa4z?=
 =?us-ascii?Q?Q/v3H4/xW8cG0mcr5y0Jsb2MVuh7Y2h3CjDZxyonGK1fqKSerV6tPyaaxaoa?=
 =?us-ascii?Q?z/3pnI7exx/uA20ueTegIxgDd1SgAYq9TPvCJjEaYGSdtQH6WFr+EMXvJGiV?=
 =?us-ascii?Q?3Bs0b65+3eua6d/W31+hBCFEKBEubNWVtb1+PtcJ67btYIzF5WtAAU5EU61j?=
 =?us-ascii?Q?bvjM3f5BMzudb78IEqziYaTxhGNgTSwjZUgf+8EHkWXnFqJIaRW6ZbJ5+j4z?=
 =?us-ascii?Q?waQmzahqn4QuVkutduFI9UrdcLHN3HoAGUq8TWM36S+lqOVmWEgt4zc6X9kQ?=
 =?us-ascii?Q?X9Jf80nkL0PpkJ8amZ9tQ4N1fQ8JEHC7uHshjknlDoEYf3qJt79nQBF28AJn?=
 =?us-ascii?Q?1C50hnZkvDNgOSz6wjOv40c4MCgzK7R5bZVULydBNldLlQrscmoQvir2mWet?=
 =?us-ascii?Q?bgBD4yPam1q5Ke1D8AwD66E7blubYCSRbAMV3wjwV3sWvs/Ub4UI/Ho+dW8V?=
 =?us-ascii?Q?s6mQjSBladsLglVnM+NOeHUoAnAewt6pSCJnSYp+szcANDbzFc62w/poG0R+?=
 =?us-ascii?Q?efMrm4htZyotx/7QbWfze+s05TdCKIh8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c2cb800-5e35-41d2-609e-08da09049a8d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 17:27:40.5696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lAciH9CzOIoTKTj/jC2aG5SVLayhkYVfRryFZ1NITOJ5p/PEB6brygryWViVCyB9
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

Add the four functions external drivers need to connect physical DMA to
the IOMMUFD:

iommufd_bind_pci_device() / iommufd_unbind_device()
  Register the device with iommufd and establish security isolation.

iommufd_device_attach() / iommufd_device_detach()
  Connect a bound device to a page table

binding a device creates a device object ID in the uAPI, however the
generic API provides no IOCTLs to manipulate them.

An API to support the VFIO mdevs is a WIP at this point, but likely
involves requesting a struct iommufd_device without providing any struct
device, and then using the pin/unpin/rw operations on that iommufd_device.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/Makefile          |   1 +
 drivers/iommu/iommufd/device.c          | 274 ++++++++++++++++++++++++
 drivers/iommu/iommufd/iommufd_private.h |   4 +
 drivers/iommu/iommufd/main.c            |   3 +
 include/linux/iommufd.h                 |  50 +++++
 5 files changed, 332 insertions(+)
 create mode 100644 drivers/iommu/iommufd/device.c
 create mode 100644 include/linux/iommufd.h

diff --git a/drivers/iommu/iommufd/Makefile b/drivers/iommu/iommufd/Makefile
index e13e971aa28c60..ca28a135b9675f 100644
--- a/drivers/iommu/iommufd/Makefile
+++ b/drivers/iommu/iommufd/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 iommufd-y := \
+	device.o \
 	hw_pagetable.o \
 	io_pagetable.o \
 	ioas.o \
diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
new file mode 100644
index 00000000000000..c20bc9eab07e13
--- /dev/null
+++ b/drivers/iommu/iommufd/device.c
@@ -0,0 +1,274 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES
+ */
+#include <linux/iommufd.h>
+#include <linux/slab.h>
+#include <linux/iommu.h>
+#include <linux/file.h>
+#include <linux/pci.h>
+#include <linux/irqdomain.h>
+#include <linux/dma-iommu.h>
+
+#include "iommufd_private.h"
+
+/*
+ * A iommufd_device object represents the binding relationship between a
+ * consuming driver and the iommufd. These objects are created/destroyed by
+ * external drivers, not by userspace.
+ */
+struct iommufd_device {
+	struct iommufd_object obj;
+	struct iommufd_ctx *ictx;
+	struct iommufd_hw_pagetable *hwpt;
+	/* Head at iommufd_hw_pagetable::devices */
+	struct list_head devices_item;
+	/* always the physical device */
+	struct device *dev;
+	struct iommu_group *group;
+};
+
+void iommufd_device_destroy(struct iommufd_object *obj)
+{
+	struct iommufd_device *idev =
+		container_of(obj, struct iommufd_device, obj);
+
+	iommu_group_release_dma_owner(idev->group);
+	iommu_group_put(idev->group);
+	fput(idev->ictx->filp);
+}
+
+/**
+ * iommufd_bind_pci_device - Bind a physical device to an iommu fd
+ * @fd: iommufd file descriptor.
+ * @pdev: Pointer to a physical PCI device struct
+ * @id: Output ID number to return to userspace for this device
+ *
+ * A successful bind establishes an ownership over the device and returns
+ * struct iommufd_device pointer, otherwise returns error pointer.
+ *
+ * A driver using this API must set driver_managed_dma and must not touch
+ * the device until this routine succeeds and establishes ownership.
+ *
+ * Binding a PCI device places the entire RID under iommufd control.
+ *
+ * The caller must undo this with iommufd_unbind_device()
+ */
+struct iommufd_device *iommufd_bind_pci_device(int fd, struct pci_dev *pdev,
+					       u32 *id)
+{
+	struct iommufd_device *idev;
+	struct iommufd_ctx *ictx;
+	struct iommu_group *group;
+	int rc;
+
+	ictx = iommufd_fget(fd);
+	if (!ictx)
+		return ERR_PTR(-EINVAL);
+
+	group = iommu_group_get(&pdev->dev);
+	if (!group) {
+		rc = -ENODEV;
+		goto out_file_put;
+	}
+
+	/*
+	 * FIXME: Use a device-centric iommu api and this won't work with
+	 * multi-device groups
+	 */
+	rc = iommu_group_claim_dma_owner(group, ictx->filp);
+	if (rc)
+		goto out_group_put;
+
+	idev = iommufd_object_alloc(ictx, idev, IOMMUFD_OBJ_DEVICE);
+	if (IS_ERR(idev)) {
+		rc = PTR_ERR(idev);
+		goto out_release_owner;
+	}
+	idev->ictx = ictx;
+	idev->dev = &pdev->dev;
+	/* The calling driver is a user until iommufd_unbind_device() */
+	refcount_inc(&idev->obj.users);
+	/* group refcount moves into iommufd_device */
+	idev->group = group;
+
+	/*
+	 * If the caller fails after this success it must call
+	 * iommufd_unbind_device() which is safe since we hold this refcount.
+	 * This also means the device is a leaf in the graph and no other object
+	 * can take a reference on it.
+	 */
+	iommufd_object_finalize(ictx, &idev->obj);
+	*id = idev->obj.id;
+	return idev;
+
+out_release_owner:
+	iommu_group_release_dma_owner(group);
+out_group_put:
+	iommu_group_put(group);
+out_file_put:
+	fput(ictx->filp);
+	return ERR_PTR(rc);
+}
+EXPORT_SYMBOL_GPL(iommufd_bind_pci_device);
+
+void iommufd_unbind_device(struct iommufd_device *idev)
+{
+	bool was_destroyed;
+
+	was_destroyed = iommufd_object_destroy_user(idev->ictx, &idev->obj);
+	WARN_ON(!was_destroyed);
+}
+EXPORT_SYMBOL_GPL(iommufd_unbind_device);
+
+static bool iommufd_hw_pagetable_has_group(struct iommufd_hw_pagetable *hwpt,
+					   struct iommu_group *group)
+{
+	struct iommufd_device *cur_dev;
+
+	list_for_each_entry (cur_dev, &hwpt->devices, devices_item)
+		if (cur_dev->group == group)
+			return true;
+	return false;
+}
+
+static int iommufd_device_setup_msi(struct iommufd_device *idev,
+				    struct iommufd_hw_pagetable *hwpt,
+				    phys_addr_t sw_msi_start,
+				    unsigned int flags)
+{
+	int rc;
+
+	/*
+	 * IOMMU_CAP_INTR_REMAP means that the platform is isolating MSI,
+	 * nothing further to do.
+	 */
+	if (iommu_capable(idev->dev->bus, IOMMU_CAP_INTR_REMAP))
+		return 0;
+
+	/*
+	 * On ARM systems that set the global IRQ_DOMAIN_FLAG_MSI_REMAP every
+	 * allocated iommu_domain will block interrupts by default and this
+	 * special flow is needed to turn them back on.
+	 */
+	if (irq_domain_check_msi_remap()) {
+		if (WARN_ON(!sw_msi_start))
+			return -EPERM;
+		/*
+		 * iommu_get_msi_cookie() can only be called once per domain,
+		 * it returns -EBUSY on later calls.
+		 */
+		if (hwpt->msi_cookie)
+			return 0;
+		rc = iommu_get_msi_cookie(hwpt->domain, sw_msi_start);
+		if (rc && rc != -ENODEV)
+			return rc;
+		hwpt->msi_cookie = true;
+		return 0;
+	}
+
+	/*
+	 * Otherwise the platform has a MSI window that is not isolated. For
+	 * historical compat with VFIO allow a module parameter to ignore the
+	 * insecurity.
+	 */
+	if (!(flags & IOMMUFD_ATTACH_FLAGS_ALLOW_UNSAFE_INTERRUPT))
+		return -EPERM;
+	return 0;
+}
+
+/**
+ * iommufd_device_attach - Connect a device to an iommu_domain
+ * @idev: device to attach
+ * @pt_id: Input a IOMMUFD_OBJ_IOAS, or IOMMUFD_OBJ_HW_PAGETABLE
+ *         Output the IOMMUFD_OBJ_HW_PAGETABLE ID
+ * @flags: Optional flags
+ *
+ * This connects the device to an iommu_domain, either automatically or manually
+ * selected. Once this completes the device could do DMA.
+ *
+ * The caller should return the resulting pt_id back to userspace.
+ * This function is undone by calling iommufd_device_detach().
+ */
+int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id,
+			  unsigned int flags)
+{
+	struct iommufd_hw_pagetable *hwpt;
+	int rc;
+
+	refcount_inc(&idev->obj.users);
+
+	hwpt = iommufd_hw_pagetable_from_id(idev->ictx, *pt_id, idev->dev);
+	if (IS_ERR(hwpt)) {
+		rc = PTR_ERR(hwpt);
+		goto out_users;
+	}
+
+	mutex_lock(&hwpt->devices_lock);
+	/* FIXME: Use a device-centric iommu api. For now check if the
+	 * hw_pagetable already has a device of the same group joined to tell if
+	 * we are the first and need to attach the group. */
+	if (!iommufd_hw_pagetable_has_group(hwpt, idev->group)) {
+		phys_addr_t sw_msi_start = 0;
+
+		rc = iommu_attach_group(hwpt->domain, idev->group);
+		if (rc)
+			goto out_unlock;
+
+		/*
+		 * hwpt is now the exclusive owner of the group so this is the
+		 * first time enforce is called for this group.
+		 */
+		rc = iopt_table_enforce_group_resv_regions(
+			&hwpt->ioas->iopt, idev->group, &sw_msi_start);
+		if (rc)
+			goto out_detach;
+		rc = iommufd_device_setup_msi(idev, hwpt, sw_msi_start, flags);
+		if (rc)
+			goto out_iova;
+	}
+
+	idev->hwpt = hwpt;
+	if (list_empty(&hwpt->devices)) {
+		rc = iopt_table_add_domain(&hwpt->ioas->iopt, hwpt->domain);
+		if (rc)
+			goto out_iova;
+	}
+	list_add(&idev->devices_item, &hwpt->devices);
+	mutex_unlock(&hwpt->devices_lock);
+
+	*pt_id = idev->hwpt->obj.id;
+	return 0;
+
+out_iova:
+	iopt_remove_reserved_iova(&hwpt->ioas->iopt, idev->group);
+out_detach:
+	iommu_detach_group(hwpt->domain, idev->group);
+out_unlock:
+	mutex_unlock(&hwpt->devices_lock);
+	iommufd_hw_pagetable_put(idev->ictx, hwpt);
+out_users:
+	refcount_dec(&idev->obj.users);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(iommufd_device_attach);
+
+void iommufd_device_detach(struct iommufd_device *idev)
+{
+	struct iommufd_hw_pagetable *hwpt = idev->hwpt;
+
+	mutex_lock(&hwpt->devices_lock);
+	list_del(&idev->devices_item);
+	if (!iommufd_hw_pagetable_has_group(hwpt, idev->group)) {
+		iopt_remove_reserved_iova(&hwpt->ioas->iopt, idev->group);
+		iommu_detach_group(hwpt->domain, idev->group);
+	}
+	if (list_empty(&hwpt->devices))
+		iopt_table_remove_domain(&hwpt->ioas->iopt, hwpt->domain);
+	mutex_unlock(&hwpt->devices_lock);
+
+	iommufd_hw_pagetable_put(idev->ictx, hwpt);
+	idev->hwpt = NULL;
+
+	refcount_dec(&idev->obj.users);
+}
+EXPORT_SYMBOL_GPL(iommufd_device_detach);
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index c5c9650cc86818..e5c717231f851e 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -96,6 +96,7 @@ static inline int iommufd_ucmd_respond(struct iommufd_ucmd *ucmd,
 enum iommufd_object_type {
 	IOMMUFD_OBJ_NONE,
 	IOMMUFD_OBJ_ANY = IOMMUFD_OBJ_NONE,
+	IOMMUFD_OBJ_DEVICE,
 	IOMMUFD_OBJ_HW_PAGETABLE,
 	IOMMUFD_OBJ_IOAS,
 	IOMMUFD_OBJ_MAX,
@@ -196,6 +197,7 @@ struct iommufd_hw_pagetable {
 	struct iommufd_object obj;
 	struct iommufd_ioas *ioas;
 	struct iommu_domain *domain;
+	bool msi_cookie;
 	/* Head at iommufd_ioas::auto_domains */
 	struct list_head auto_domains_item;
 	struct mutex devices_lock;
@@ -209,4 +211,6 @@ void iommufd_hw_pagetable_put(struct iommufd_ctx *ictx,
 			      struct iommufd_hw_pagetable *hwpt);
 void iommufd_hw_pagetable_destroy(struct iommufd_object *obj);
 
+void iommufd_device_destroy(struct iommufd_object *obj);
+
 #endif
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 954cde173c86fc..6a895489fb5b82 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -284,6 +284,9 @@ struct iommufd_ctx *iommufd_fget(int fd)
 }
 
 static struct iommufd_object_ops iommufd_object_ops[] = {
+	[IOMMUFD_OBJ_DEVICE] = {
+		.destroy = iommufd_device_destroy,
+	},
 	[IOMMUFD_OBJ_IOAS] = {
 		.destroy = iommufd_ioas_destroy,
 	},
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
new file mode 100644
index 00000000000000..6caac05475e39f
--- /dev/null
+++ b/include/linux/iommufd.h
@@ -0,0 +1,50 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2021 Intel Corporation
+ * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES
+ */
+#ifndef __LINUX_IOMMUFD_H
+#define __LINUX_IOMMUFD_H
+
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/device.h>
+
+struct pci_dev;
+struct iommufd_device;
+
+#if IS_ENABLED(CONFIG_IOMMUFD)
+struct iommufd_device *iommufd_bind_pci_device(int fd, struct pci_dev *pdev,
+					       u32 *id);
+void iommufd_unbind_device(struct iommufd_device *idev);
+
+enum {
+	IOMMUFD_ATTACH_FLAGS_ALLOW_UNSAFE_INTERRUPT = 1 << 0,
+};
+int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id,
+			  unsigned int flags);
+void iommufd_device_detach(struct iommufd_device *idev);
+
+#else /* !CONFIG_IOMMUFD */
+static inline struct iommufd_device *
+iommufd_bind_pci_device(int fd, struct pci_dev *pdev, u32 *id)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+static inline void iommufd_unbind_device(struct iommufd_device *idev)
+{
+}
+
+static inline int iommufd_device_attach(struct iommufd_device *idev,
+					u32 ioas_id)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void iommufd_device_detach(struct iommufd_device *idev)
+{
+}
+#endif /* CONFIG_IOMMUFD */
+#endif
-- 
2.35.1

