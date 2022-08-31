Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A42A95A7320
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 03:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbiHaBCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 21:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiHaBCP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 21:02:15 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2053.outbound.protection.outlook.com [40.107.101.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 212629E2CE
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 18:02:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sk8t6Fn1a+/+Jhz4dAfxDaOU4i0G1evInsoh4s/LzfA71JxDhlCQIRkB5OVcvL5WTbCNx+1sDXk5TWLTJ9hVDFQh0derwSFvelOCDSyvvbPwaqZq6NzbWw48mtMrk+9nSQzWKpRUF1BrDJqQMRZ8HeFO5YOKJyoXc6/+RBwz/cmMDW2uvpy2TCBKdcVMaWT6QxBVFBW/9n+fnQhvxel3KxbOwTxyx3UMtqQlY2wnY28znNndjQ38ttvr+U92TxRe2Tr8NjIpBh6HHZGYsz2wV6D0QIYx4rd4HkhBLNLKtarsS7lBysR4etVx86k2nGS8XCKvB8R4x0Lz3zycx1dFGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AAD5NYYSYq9pxycTHCfGaSoODuFC9DvPRh8PxWMh6H4=;
 b=F7EooZeQiYS0h9sGyAFrq77wsKqT5vnM6qGF2Yc9fDyVjkx2ZlpnJZIphMM511YYQ2dp+Ed8m7c1uhcU+KxTFklBAUdyWm+MMVwvX8uSBI+SE1xzMeDFphKuJ72K7ibIgiXyXh4drpYk/3BRtfgZ+GvD3F5O5xsxOvKu+h7pillR3CvFi0MEUxDK0GFOwoVCdvVAjXB7SxuxM+sN/5/ukB0AeCkHBe/+Rmt0O6qTtJ5SjQG1D9oYpq6TTqz74aI8CStNYE9uTx7tNqsyKvtNmg7eSkZL4DPGhbNkjWkcK+kJQW8oLODN1d+2J9h+0yWxq4k+9oz7ZVafwUeD0/YXeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AAD5NYYSYq9pxycTHCfGaSoODuFC9DvPRh8PxWMh6H4=;
 b=DE6s6nQgp5ucsEz1Up5PbLi9OugUXCAzrauyGJsG5kj7HAIu9XVzM5t9dhWEaEM3/USVFtbEOmGQfdyzZpBiMfsns/ZpEH0RfFwBm47LIq2Xk/GE8xD9RZxG628bfrPyX5gCR83X+EeE479Yl59fTJ/lUHPErbZ4OGL/tBd7weeT6sw54MZe4cEuVDmWrTdGflh3xkhe6CcMkBKi+X/ZgcnFP9zQQvrCz/XX6YCP7UcSqHdJY7mEFyhe0DV7qwHd6PQP1KLLqlyAyo86bj2nhu+Irb37Ro1Hq+J5GHslVBMO7FnV4g+yqttbPEl6P9yjTXClKTnlEnZH/cSHG+ePpw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CO6PR12MB5410.namprd12.prod.outlook.com (2603:10b6:5:35b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Wed, 31 Aug
 2022 01:02:07 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5566.021; Wed, 31 Aug 2022
 01:02:07 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org
Subject: [PATCH 8/8] vfio: Move container code into drivers/vfio/container.c
Date:   Tue, 30 Aug 2022 22:02:02 -0300
Message-Id: <8-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0302.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::7) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0144e66c-2e3c-4293-399b-08da8aec6b18
X-MS-TrafficTypeDiagnostic: CO6PR12MB5410:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IlFYEgs2IWdTSO+ugVc2/Z4DQUvqdBH9OKf5wh6KqVNm2ofmJ1MoCZSHXsMz19/TnJwRAadjoJaYArWhrJq25pTAqE3fdvbkPcYWK0jbF6fPdjo4Eof6VSGSZ1yhzHpK0Y3fh7IMfe2q0T5xs6v0bo7ZJ2/Ngiuq0CWQOSlHBYYS7r8Gj4lqmww9/IrrDi83oJRFv1ubXwdyI5MPK3/Y8WbqnQkdaNBADg8yVM8ir57DJ8w4W4tqM6Bcd47nSVHSpw6S4+unOKkkJQrVLX8AQBZuTWd8wRlgGAgkKf9bggAneJ7/GotOr7r0FZ8lH7gLhlurqqzFc7z/9wisawLBOI5hKs48QRe1fgx78UYefvkjBmInKGtkiv5aehl4kOHBiIP9ZX/OkAUWiBxafule9xXdyNNJBxYJhIVz9WJuiN41s9r6j2wLJQRLC5ak2dUOgOMtpxKbUsP3WoASC5cC9CyvdY4Lh/A85PmRXOc2f524pqtuNbzEDk+v3AvGdAcSoONjV5uvDLFXq1IBVg3TXJgxzTrn2ijGZ/BU+m+8WaRjJ8Sx3NHjw4IHYqXhJyLLzPZ9/GkbO06SgnpWhZHTsqzWPe3tnTR7yyKLkew1bqTtBehyIMuRs8U5RXUlXPggystpwm8dcXryKZKxodRAWXi8KOhPtPDJn3Hl+YzM/CxBAhjBQAEYXQlRjWfPnfXHEDT2eyu5lon6IHO0eVonvru+Tom0kwwzm+WfDDkXaowCqmBxmSPcShQopn/cYgVC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(6486002)(316002)(110136005)(66556008)(66476007)(66946007)(8676002)(86362001)(36756003)(5660300002)(8936002)(478600001)(41300700001)(26005)(2616005)(6506007)(2906002)(6512007)(30864003)(6666004)(38100700002)(83380400001)(186003)(4216001)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PQcxxwRPDj8HI1CHZHhVKy3W5qeMFaz3zsAZHxqsvTb/rX8kwsJUeRYmjReC?=
 =?us-ascii?Q?hSfCHLMzPNBYLIJl8CJrI6f90DHQbgmTQvd3FF1kX3YweQro+28GLMu1i0sw?=
 =?us-ascii?Q?fzZdkErgMQa0so5rbbMELHfn0Rt93jjD80UOLLXSYYoYdHi4KJQ8Q46ctH5b?=
 =?us-ascii?Q?9kLTMnlzPx/Jggn+focfxr7XcQrnK+edllM4Cl3lZ2hIus70Dpwhiy/kjM7x?=
 =?us-ascii?Q?Q6QFue5ybR/gQ8fyfZTLacqwxGpvRtqekF/E7wreD8Y2NhnPe/JdrN3T9XN+?=
 =?us-ascii?Q?iaXUzHSW3zf6m81eeuYqaNATVkwql90VlDKDu2CsblFhzdDjtDU3AP+BRm9S?=
 =?us-ascii?Q?aoiWfpsd9z8Sl2JU+mbJgQrneZb70xd7IO9hiw7bznrQ+5M60SYZDNGW9sk2?=
 =?us-ascii?Q?J4cGoU8AmGE8h8KbGNFt/TRykGmf0UJrRhjN4S9TQ4eZzeXcKArgZRp0y3cn?=
 =?us-ascii?Q?MLF08iehstnitnWEkutMBXhGH5JU43BgFJ87qzHvhBHkWGLppWg4xrU0wUtz?=
 =?us-ascii?Q?h1xSxDAWXRamy3i1Q3x0rqw84qIVGc5OsjVSLr6YSz7y0NnT3R1QqqdlbYvr?=
 =?us-ascii?Q?Ae/OGgi6d8B8ZlYsmsDMQthmzqUV0PJVWMiI4JYBCjfRNzOV8TlTT1aIh6tl?=
 =?us-ascii?Q?NoKihxBzZIpO8fOTavXY3Nbz7OZstJpOnBSGD/HuQkkN8GktwlfLq5L8fSJN?=
 =?us-ascii?Q?N1CQyWyp+zGJMmyLDXUCrRjvD9sOSnVcoYBk1dpXcH3jd8UxGug+7+ivORek?=
 =?us-ascii?Q?MzOaqThbmGMddngsl1t54lsltsqMM9y1FulV0tiiHfl3zBHsZuO7T4imau0J?=
 =?us-ascii?Q?PcI2UGNAB9JocVD61SP3R/dEBItUd1IQvdoVdU2xbZMzyouFPLSZdljXaA0j?=
 =?us-ascii?Q?4iyOk7YSD6bSnsdbCV3HlZb9fJg0WqQQeBhItWLflzqDpO5xd36KcWJnCmW3?=
 =?us-ascii?Q?UlC76X/HYDR84lyKBg7uapaJpjp2zixIs0apnRo1fVaP2rLaGSJelztC8B89?=
 =?us-ascii?Q?HraLiD/1yFi/qscCvG48KcWS50j9lArqpZDZc85fIkWD7j6nEaV8pTvgs57P?=
 =?us-ascii?Q?vxkPyTKPUhTKCt3rrrGZA/AqFMyhKZz24FR4ZwvD0pOItxERmVOoLTDm6uod?=
 =?us-ascii?Q?ELcY8B2jTX//MX9/wAXzTULWHQvlHHsAD9Q1Ws5WQP9SYkbsaBAzUHBi1rWW?=
 =?us-ascii?Q?P76fX2bLcpUfa5nvZEJ5Od8QqOePrT8Ph+Abg8UQJTJhGU7/cMrr4rxEvhmG?=
 =?us-ascii?Q?ssXI99yyNDoGTeWeh1phaFOjpLi+q+KDA58LnfaasoVgNEMXbdnChDiZHxy/?=
 =?us-ascii?Q?Jpe1caem2A76bNtn32fEbsoYfCfkPVEP9zNSlmMiFPayH7e80xrEkh15OQv/?=
 =?us-ascii?Q?EwAsbNnhnZ4i4qE0FwNdKLzf5UVy0oU27/iyVVQ79AqGWC+xWETEYCBAZThB?=
 =?us-ascii?Q?vS4PKBIU3zWXg1uw0Uxh9LBtE0V35l3SV+PVEJdrUdsfy2ghojvqxNwS/NOl?=
 =?us-ascii?Q?OiNGMA/boQDLlZoDqmSYVXb9jeiLgGcdz73zlE2Iye89uXmWkLkzUpuFpFz4?=
 =?us-ascii?Q?Rl7vA7ENhdTQPSoT9YplEksJU32rRhMJG0gNiy1W?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0144e66c-2e3c-4293-399b-08da8aec6b18
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 01:02:04.2042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cNwdE4TGKcYLINFbSSzmHsPJEq9N+3gYW/SMhrM5ujAFcwGpiGL23F6lxC1HHR3H
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

All the functions that dereference struct vfio_container are moved into
container.c.

Simple code motion, no functional change.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/Makefile    |   1 +
 drivers/vfio/container.c | 680 ++++++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio.h      |  47 +++
 drivers/vfio/vfio_main.c | 693 +--------------------------------------
 4 files changed, 729 insertions(+), 692 deletions(-)
 create mode 100644 drivers/vfio/container.c

diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index 1a32357592e3ea..d5ae6921eb4ece 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 vfio_virqfd-y := virqfd.o
 
+vfio-y += container.o
 vfio-y += vfio_main.o
 
 obj-$(CONFIG_VFIO) += vfio.o
diff --git a/drivers/vfio/container.c b/drivers/vfio/container.c
new file mode 100644
index 00000000000000..2b1e021ae58a83
--- /dev/null
+++ b/drivers/vfio/container.c
@@ -0,0 +1,680 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
+ *
+ * VFIO container (/dev/vfio/vfio)
+ */
+#include <linux/file.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/capability.h>
+#include <linux/iommu.h>
+#include <linux/miscdevice.h>
+#include <linux/vfio.h>
+#include <uapi/linux/vfio.h>
+
+#include "vfio.h"
+
+struct vfio_container {
+	struct kref			kref;
+	struct list_head		group_list;
+	struct rw_semaphore		group_lock;
+	struct vfio_iommu_driver	*iommu_driver;
+	void				*iommu_data;
+	bool				noiommu;
+};
+
+static struct vfio {
+	struct list_head		iommu_drivers_list;
+	struct mutex			iommu_drivers_lock;
+} vfio;
+
+#ifdef CONFIG_VFIO_NOIOMMU
+bool vfio_noiommu __read_mostly;
+module_param_named(enable_unsafe_noiommu_mode,
+		   vfio_noiommu, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(enable_unsafe_noiommu_mode, "Enable UNSAFE, no-IOMMU mode.  This mode provides no device isolation, no DMA translation, no host kernel protection, cannot be used for device assignment to virtual machines, requires RAWIO permissions, and will taint the kernel.  If you do not know what this is for, step away. (default: false)");
+#endif
+
+static void *vfio_noiommu_open(unsigned long arg)
+{
+	if (arg != VFIO_NOIOMMU_IOMMU)
+		return ERR_PTR(-EINVAL);
+	if (!capable(CAP_SYS_RAWIO))
+		return ERR_PTR(-EPERM);
+
+	return NULL;
+}
+
+static void vfio_noiommu_release(void *iommu_data)
+{
+}
+
+static long vfio_noiommu_ioctl(void *iommu_data,
+			       unsigned int cmd, unsigned long arg)
+{
+	if (cmd == VFIO_CHECK_EXTENSION)
+		return vfio_noiommu && (arg == VFIO_NOIOMMU_IOMMU) ? 1 : 0;
+
+	return -ENOTTY;
+}
+
+static int vfio_noiommu_attach_group(void *iommu_data,
+		struct iommu_group *iommu_group, enum vfio_group_type type)
+{
+	return 0;
+}
+
+static void vfio_noiommu_detach_group(void *iommu_data,
+				      struct iommu_group *iommu_group)
+{
+}
+
+static const struct vfio_iommu_driver_ops vfio_noiommu_ops = {
+	.name = "vfio-noiommu",
+	.owner = THIS_MODULE,
+	.open = vfio_noiommu_open,
+	.release = vfio_noiommu_release,
+	.ioctl = vfio_noiommu_ioctl,
+	.attach_group = vfio_noiommu_attach_group,
+	.detach_group = vfio_noiommu_detach_group,
+};
+
+/*
+ * Only noiommu containers can use vfio-noiommu and noiommu containers can only
+ * use vfio-noiommu.
+ */
+static bool vfio_iommu_driver_allowed(struct vfio_container *container,
+				      const struct vfio_iommu_driver *driver)
+{
+	if (!IS_ENABLED(CONFIG_VFIO_NOIOMMU))
+		return true;
+	return container->noiommu == (driver->ops == &vfio_noiommu_ops);
+}
+
+/*
+ * IOMMU driver registration
+ */
+int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops)
+{
+	struct vfio_iommu_driver *driver, *tmp;
+
+	if (WARN_ON(!ops->register_device != !ops->unregister_device))
+		return -EINVAL;
+
+	driver = kzalloc(sizeof(*driver), GFP_KERNEL);
+	if (!driver)
+		return -ENOMEM;
+
+	driver->ops = ops;
+
+	mutex_lock(&vfio.iommu_drivers_lock);
+
+	/* Check for duplicates */
+	list_for_each_entry(tmp, &vfio.iommu_drivers_list, vfio_next) {
+		if (tmp->ops == ops) {
+			mutex_unlock(&vfio.iommu_drivers_lock);
+			kfree(driver);
+			return -EINVAL;
+		}
+	}
+
+	list_add(&driver->vfio_next, &vfio.iommu_drivers_list);
+
+	mutex_unlock(&vfio.iommu_drivers_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_register_iommu_driver);
+
+void vfio_unregister_iommu_driver(const struct vfio_iommu_driver_ops *ops)
+{
+	struct vfio_iommu_driver *driver;
+
+	mutex_lock(&vfio.iommu_drivers_lock);
+	list_for_each_entry(driver, &vfio.iommu_drivers_list, vfio_next) {
+		if (driver->ops == ops) {
+			list_del(&driver->vfio_next);
+			mutex_unlock(&vfio.iommu_drivers_lock);
+			kfree(driver);
+			return;
+		}
+	}
+	mutex_unlock(&vfio.iommu_drivers_lock);
+}
+EXPORT_SYMBOL_GPL(vfio_unregister_iommu_driver);
+
+/*
+ * Container objects - containers are created when /dev/vfio/vfio is
+ * opened, but their lifecycle extends until the last user is done, so
+ * it's freed via kref.  Must support container/group/device being
+ * closed in any order.
+ */
+static void vfio_container_release(struct kref *kref)
+{
+	struct vfio_container *container;
+	container = container_of(kref, struct vfio_container, kref);
+
+	kfree(container);
+}
+
+static void vfio_container_get(struct vfio_container *container)
+{
+	kref_get(&container->kref);
+}
+
+static void vfio_container_put(struct vfio_container *container)
+{
+	kref_put(&container->kref, vfio_container_release);
+}
+
+void vfio_container_register_device(struct vfio_device *device)
+{
+	struct vfio_iommu_driver *iommu_driver =
+		device->group->container->iommu_driver;
+
+	if (iommu_driver && iommu_driver->ops->register_device)
+		iommu_driver->ops->register_device(
+			device->group->container->iommu_data, device);
+}
+
+void vfio_container_unregister_device(struct vfio_device *device)
+{
+	struct vfio_iommu_driver *iommu_driver =
+		device->group->container->iommu_driver;
+
+	if (iommu_driver && iommu_driver->ops->unregister_device)
+		iommu_driver->ops->unregister_device(
+			device->group->container->iommu_data, device);
+}
+
+long vfio_container_ioctl_check_extension(struct vfio_container *container,
+					  unsigned long arg)
+{
+	struct vfio_iommu_driver *driver;
+	long ret = 0;
+
+	down_read(&container->group_lock);
+
+	driver = container->iommu_driver;
+
+	switch (arg) {
+		/* No base extensions yet */
+	default:
+		/*
+		 * If no driver is set, poll all registered drivers for
+		 * extensions and return the first positive result.  If
+		 * a driver is already set, further queries will be passed
+		 * only to that driver.
+		 */
+		if (!driver) {
+			mutex_lock(&vfio.iommu_drivers_lock);
+			list_for_each_entry(driver, &vfio.iommu_drivers_list,
+					    vfio_next) {
+
+				if (!list_empty(&container->group_list) &&
+				    !vfio_iommu_driver_allowed(container,
+							       driver))
+					continue;
+				if (!try_module_get(driver->ops->owner))
+					continue;
+
+				ret = driver->ops->ioctl(NULL,
+							 VFIO_CHECK_EXTENSION,
+							 arg);
+				module_put(driver->ops->owner);
+				if (ret > 0)
+					break;
+			}
+			mutex_unlock(&vfio.iommu_drivers_lock);
+		} else
+			ret = driver->ops->ioctl(container->iommu_data,
+						 VFIO_CHECK_EXTENSION, arg);
+	}
+
+	up_read(&container->group_lock);
+
+	return ret;
+}
+
+/* hold write lock on container->group_lock */
+static int __vfio_container_attach_groups(struct vfio_container *container,
+					  struct vfio_iommu_driver *driver,
+					  void *data)
+{
+	struct vfio_group *group;
+	int ret = -ENODEV;
+
+	list_for_each_entry(group, &container->group_list, container_next) {
+		ret = driver->ops->attach_group(data, group->iommu_group,
+						group->type);
+		if (ret)
+			goto unwind;
+	}
+
+	return ret;
+
+unwind:
+	list_for_each_entry_continue_reverse(group, &container->group_list,
+					     container_next) {
+		driver->ops->detach_group(data, group->iommu_group);
+	}
+
+	return ret;
+}
+
+static long vfio_ioctl_set_iommu(struct vfio_container *container,
+				 unsigned long arg)
+{
+	struct vfio_iommu_driver *driver;
+	long ret = -ENODEV;
+
+	down_write(&container->group_lock);
+
+	/*
+	 * The container is designed to be an unprivileged interface while
+	 * the group can be assigned to specific users.  Therefore, only by
+	 * adding a group to a container does the user get the privilege of
+	 * enabling the iommu, which may allocate finite resources.  There
+	 * is no unset_iommu, but by removing all the groups from a container,
+	 * the container is deprivileged and returns to an unset state.
+	 */
+	if (list_empty(&container->group_list) || container->iommu_driver) {
+		up_write(&container->group_lock);
+		return -EINVAL;
+	}
+
+	mutex_lock(&vfio.iommu_drivers_lock);
+	list_for_each_entry(driver, &vfio.iommu_drivers_list, vfio_next) {
+		void *data;
+
+		if (!vfio_iommu_driver_allowed(container, driver))
+			continue;
+		if (!try_module_get(driver->ops->owner))
+			continue;
+
+		/*
+		 * The arg magic for SET_IOMMU is the same as CHECK_EXTENSION,
+		 * so test which iommu driver reported support for this
+		 * extension and call open on them.  We also pass them the
+		 * magic, allowing a single driver to support multiple
+		 * interfaces if they'd like.
+		 */
+		if (driver->ops->ioctl(NULL, VFIO_CHECK_EXTENSION, arg) <= 0) {
+			module_put(driver->ops->owner);
+			continue;
+		}
+
+		data = driver->ops->open(arg);
+		if (IS_ERR(data)) {
+			ret = PTR_ERR(data);
+			module_put(driver->ops->owner);
+			continue;
+		}
+
+		ret = __vfio_container_attach_groups(container, driver, data);
+		if (ret) {
+			driver->ops->release(data);
+			module_put(driver->ops->owner);
+			continue;
+		}
+
+		container->iommu_driver = driver;
+		container->iommu_data = data;
+		break;
+	}
+
+	mutex_unlock(&vfio.iommu_drivers_lock);
+	up_write(&container->group_lock);
+
+	return ret;
+}
+
+static long vfio_fops_unl_ioctl(struct file *filep,
+				unsigned int cmd, unsigned long arg)
+{
+	struct vfio_container *container = filep->private_data;
+	struct vfio_iommu_driver *driver;
+	void *data;
+	long ret = -EINVAL;
+
+	if (!container)
+		return ret;
+
+	switch (cmd) {
+	case VFIO_GET_API_VERSION:
+		ret = VFIO_API_VERSION;
+		break;
+	case VFIO_CHECK_EXTENSION:
+		ret = vfio_container_ioctl_check_extension(container, arg);
+		break;
+	case VFIO_SET_IOMMU:
+		ret = vfio_ioctl_set_iommu(container, arg);
+		break;
+	default:
+		driver = container->iommu_driver;
+		data = container->iommu_data;
+
+		if (driver) /* passthrough all unrecognized ioctls */
+			ret = driver->ops->ioctl(data, cmd, arg);
+	}
+
+	return ret;
+}
+
+static int vfio_fops_open(struct inode *inode, struct file *filep)
+{
+	struct vfio_container *container;
+
+	container = kzalloc(sizeof(*container), GFP_KERNEL);
+	if (!container)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&container->group_list);
+	init_rwsem(&container->group_lock);
+	kref_init(&container->kref);
+
+	filep->private_data = container;
+
+	return 0;
+}
+
+static int vfio_fops_release(struct inode *inode, struct file *filep)
+{
+	struct vfio_container *container = filep->private_data;
+	struct vfio_iommu_driver *driver = container->iommu_driver;
+
+	if (driver && driver->ops->notify)
+		driver->ops->notify(container->iommu_data,
+				    VFIO_IOMMU_CONTAINER_CLOSE);
+
+	filep->private_data = NULL;
+
+	vfio_container_put(container);
+
+	return 0;
+}
+
+static const struct file_operations vfio_fops = {
+	.owner		= THIS_MODULE,
+	.open		= vfio_fops_open,
+	.release	= vfio_fops_release,
+	.unlocked_ioctl	= vfio_fops_unl_ioctl,
+	.compat_ioctl	= compat_ptr_ioctl,
+};
+
+struct vfio_container *vfio_container_from_file(struct file *file)
+{
+	struct vfio_container *container;
+
+	/* Sanity check, is this really our fd? */
+	if (file->f_op != &vfio_fops)
+		return NULL;
+
+	container = file->private_data;
+	WARN_ON(!container); /* fget ensures we don't race vfio_release */
+	return container;
+}
+
+static struct miscdevice vfio_dev = {
+	.minor = VFIO_MINOR,
+	.name = "vfio",
+	.fops = &vfio_fops,
+	.nodename = "vfio/vfio",
+	.mode = S_IRUGO | S_IWUGO,
+};
+
+int vfio_container_attach_group(struct vfio_group *group,
+				struct vfio_container *container)
+{
+	struct vfio_iommu_driver *driver;
+	int ret = 0;
+
+	lockdep_assert_held_write(&group->group_rwsem);
+
+	if (group->type == VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO))
+		return -EPERM;
+
+	down_write(&container->group_lock);
+
+	/* Real groups and fake groups cannot mix */
+	if (!list_empty(&container->group_list) &&
+	    container->noiommu != (group->type == VFIO_NO_IOMMU)) {
+		ret = -EPERM;
+		goto out_unlock_container;
+	}
+
+	if (group->type == VFIO_IOMMU) {
+		ret = iommu_group_claim_dma_owner(group->iommu_group, group);
+		if (ret)
+			goto out_unlock_container;
+	}
+
+	driver = container->iommu_driver;
+	if (driver) {
+		ret = driver->ops->attach_group(container->iommu_data,
+						group->iommu_group,
+						group->type);
+		if (ret) {
+			if (group->type == VFIO_IOMMU)
+				iommu_group_release_dma_owner(
+					group->iommu_group);
+			goto out_unlock_container;
+		}
+	}
+
+	group->container = container;
+	group->container_users = 1;
+	container->noiommu = (group->type == VFIO_NO_IOMMU);
+	list_add(&group->container_next, &container->group_list);
+
+	/* Get a reference on the container and mark a user within the group */
+	vfio_container_get(container);
+
+out_unlock_container:
+	up_write(&container->group_lock);
+	return ret;
+}
+
+void vfio_container_detatch_group(struct vfio_group *group)
+{
+	struct vfio_container *container = group->container;
+	struct vfio_iommu_driver *driver;
+
+	lockdep_assert_held_write(&group->group_rwsem);
+	WARN_ON(group->container_users != 1);
+
+	down_write(&container->group_lock);
+
+	driver = container->iommu_driver;
+	if (driver)
+		driver->ops->detach_group(container->iommu_data,
+					  group->iommu_group);
+
+	if (group->type == VFIO_IOMMU)
+		iommu_group_release_dma_owner(group->iommu_group);
+
+	group->container = NULL;
+	group->container_users = 0;
+	list_del(&group->container_next);
+
+	/* Detaching the last group deprivileges a container, remove iommu */
+	if (driver && list_empty(&container->group_list)) {
+		driver->ops->release(container->iommu_data);
+		module_put(driver->ops->owner);
+		container->iommu_driver = NULL;
+		container->iommu_data = NULL;
+	}
+
+	up_write(&container->group_lock);
+
+	vfio_container_put(container);
+}
+
+int vfio_device_assign_container(struct vfio_device *device)
+{
+	struct vfio_group *group = device->group;
+
+	lockdep_assert_held_write(&group->group_rwsem);
+
+	if (!group->container || !group->container->iommu_driver ||
+	    WARN_ON(!group->container_users))
+		return -EINVAL;
+
+	if (group->type == VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO))
+		return -EPERM;
+
+	get_file(group->opened_file);
+	group->container_users++;
+	return 0;
+}
+
+void vfio_device_unassign_container(struct vfio_device *device)
+{
+	down_write(&device->group->group_rwsem);
+	WARN_ON(device->group->container_users <= 1);
+	device->group->container_users--;
+	fput(device->group->opened_file);
+	up_write(&device->group->group_rwsem);
+}
+
+/*
+ * Pin contiguous user pages and return their associated host pages for local
+ * domain only.
+ * @device [in]  : device
+ * @iova [in]    : starting IOVA of user pages to be pinned.
+ * @npage [in]   : count of pages to be pinned.  This count should not
+ *		   be greater than VFIO_PIN_PAGES_MAX_ENTRIES.
+ * @prot [in]    : protection flags
+ * @pages[out]   : array of host pages
+ * Return error or number of pages pinned.
+ */
+int vfio_pin_pages(struct vfio_device *device, dma_addr_t iova,
+		   int npage, int prot, struct page **pages)
+{
+	struct vfio_container *container;
+	struct vfio_group *group = device->group;
+	struct vfio_iommu_driver *driver;
+	int ret;
+
+	if (!pages || !npage || !vfio_assert_device_open(device))
+		return -EINVAL;
+
+	if (npage > VFIO_PIN_PAGES_MAX_ENTRIES)
+		return -E2BIG;
+
+	if (group->dev_counter > 1)
+		return -EINVAL;
+
+	/* group->container cannot change while a vfio device is open */
+	container = group->container;
+	driver = container->iommu_driver;
+	if (likely(driver && driver->ops->pin_pages))
+		ret = driver->ops->pin_pages(container->iommu_data,
+					     group->iommu_group, iova,
+					     npage, prot, pages);
+	else
+		ret = -ENOTTY;
+
+	return ret;
+}
+EXPORT_SYMBOL(vfio_pin_pages);
+
+/*
+ * Unpin contiguous host pages for local domain only.
+ * @device [in]  : device
+ * @iova [in]    : starting address of user pages to be unpinned.
+ * @npage [in]   : count of pages to be unpinned.  This count should not
+ *                 be greater than VFIO_PIN_PAGES_MAX_ENTRIES.
+ */
+void vfio_unpin_pages(struct vfio_device *device, dma_addr_t iova, int npage)
+{
+	struct vfio_container *container;
+	struct vfio_iommu_driver *driver;
+
+	if (WARN_ON(npage <= 0 || npage > VFIO_PIN_PAGES_MAX_ENTRIES))
+		return;
+
+	if (WARN_ON(!vfio_assert_device_open(device)))
+		return;
+
+	/* group->container cannot change while a vfio device is open */
+	container = device->group->container;
+	driver = container->iommu_driver;
+
+	driver->ops->unpin_pages(container->iommu_data, iova, npage);
+}
+EXPORT_SYMBOL(vfio_unpin_pages);
+
+/*
+ * This interface allows the CPUs to perform some sort of virtual DMA on
+ * behalf of the device.
+ *
+ * CPUs read/write from/into a range of IOVAs pointing to user space memory
+ * into/from a kernel buffer.
+ *
+ * As the read/write of user space memory is conducted via the CPUs and is
+ * not a real device DMA, it is not necessary to pin the user space memory.
+ *
+ * @device [in]		: VFIO device
+ * @iova [in]		: base IOVA of a user space buffer
+ * @data [in]		: pointer to kernel buffer
+ * @len [in]		: kernel buffer length
+ * @write		: indicate read or write
+ * Return error code on failure or 0 on success.
+ */
+int vfio_dma_rw(struct vfio_device *device, dma_addr_t iova, void *data,
+		size_t len, bool write)
+{
+	struct vfio_container *container;
+	struct vfio_iommu_driver *driver;
+	int ret = 0;
+
+	if (!data || len <= 0 || !vfio_assert_device_open(device))
+		return -EINVAL;
+
+	/* group->container cannot change while a vfio device is open */
+	container = device->group->container;
+	driver = container->iommu_driver;
+
+	if (likely(driver && driver->ops->dma_rw))
+		ret = driver->ops->dma_rw(container->iommu_data,
+					  iova, data, len, write);
+	else
+		ret = -ENOTTY;
+	return ret;
+}
+EXPORT_SYMBOL(vfio_dma_rw);
+
+int __init vfio_container_init(void)
+{
+	int ret;
+
+	mutex_init(&vfio.iommu_drivers_lock);
+	INIT_LIST_HEAD(&vfio.iommu_drivers_list);
+
+	ret = misc_register(&vfio_dev);
+	if (ret) {
+		pr_err("vfio: misc device register failed\n");
+		return ret;
+	}
+
+	if (IS_ENABLED(CONFIG_VFIO_NOIOMMU)) {
+		ret = vfio_register_iommu_driver(&vfio_noiommu_ops);
+		if (ret)
+			goto err_misc;
+	}
+	return 0;
+
+err_misc:
+	misc_deregister(&vfio_dev);
+	return ret;
+}
+
+void vfio_container_cleanup(void)
+{
+	if (IS_ENABLED(CONFIG_VFIO_NOIOMMU))
+		vfio_unregister_iommu_driver(&vfio_noiommu_ops);
+	misc_deregister(&vfio_dev);
+	mutex_destroy(&vfio.iommu_drivers_lock);
+}
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 093784f1dea7a9..c4f11225cca015 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -11,6 +11,8 @@
 #include <linux/module.h>
 
 struct iommu_group;
+struct vfio_device;
+struct vfio_container;
 
 enum vfio_group_type {
 	/*
@@ -36,6 +38,25 @@ enum vfio_group_type {
 	VFIO_NO_IOMMU,
 };
 
+struct vfio_group {
+	struct device 			dev;
+	struct cdev			cdev;
+	refcount_t			users;
+	unsigned int			container_users;
+	struct iommu_group		*iommu_group;
+	struct vfio_container		*container;
+	struct list_head		device_list;
+	struct mutex			device_lock;
+	struct list_head		vfio_next;
+	struct list_head		container_next;
+	enum vfio_group_type		type;
+	unsigned int			dev_counter;
+	struct rw_semaphore		group_rwsem;
+	struct kvm			*kvm;
+	struct file			*opened_file;
+	struct blocking_notifier_head	notifier;
+};
+
 /* events for the backend driver notify callback */
 enum vfio_iommu_notify_type {
 	VFIO_IOMMU_CONTAINER_CLOSE = 0,
@@ -75,7 +96,33 @@ struct vfio_iommu_driver_ops {
 				  enum vfio_iommu_notify_type event);
 };
 
+struct vfio_iommu_driver {
+	const struct vfio_iommu_driver_ops	*ops;
+	struct list_head			vfio_next;
+};
+
 int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
 void vfio_unregister_iommu_driver(const struct vfio_iommu_driver_ops *ops);
 
+bool vfio_assert_device_open(struct vfio_device *device);
+
+struct vfio_container *vfio_container_from_file(struct file *filep);
+int vfio_device_assign_container(struct vfio_device *device);
+void vfio_device_unassign_container(struct vfio_device *device);
+int vfio_container_attach_group(struct vfio_group *group,
+                                struct vfio_container *container);
+void vfio_container_detatch_group(struct vfio_group *group);
+void vfio_container_register_device(struct vfio_device *device);
+void vfio_container_unregister_device(struct vfio_device *device);
+long vfio_container_ioctl_check_extension(struct vfio_container *container,
+					  unsigned long arg);
+int __init vfio_container_init(void);
+void vfio_container_cleanup(void);
+
+#ifdef CONFIG_VFIO_NOIOMMU
+extern bool vfio_noiommu __read_mostly;
+#else
+enum { vfio_noiommu = false };
+#endif
+
 #endif
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index cf4b5418f497a9..dcbb3482b1b53b 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -40,56 +40,12 @@
 
 static struct vfio {
 	struct class			*class;
-	struct list_head		iommu_drivers_list;
-	struct mutex			iommu_drivers_lock;
 	struct list_head		group_list;
 	struct mutex			group_lock; /* locks group_list */
 	struct ida			group_ida;
 	dev_t				group_devt;
 } vfio;
 
-struct vfio_iommu_driver {
-	const struct vfio_iommu_driver_ops	*ops;
-	struct list_head			vfio_next;
-};
-
-struct vfio_container {
-	struct kref			kref;
-	struct list_head		group_list;
-	struct rw_semaphore		group_lock;
-	struct vfio_iommu_driver	*iommu_driver;
-	void				*iommu_data;
-	bool				noiommu;
-};
-
-struct vfio_group {
-	struct device 			dev;
-	struct cdev			cdev;
-	refcount_t			users;
-	unsigned int			container_users;
-	struct iommu_group		*iommu_group;
-	struct vfio_container		*container;
-	struct list_head		device_list;
-	struct mutex			device_lock;
-	struct list_head		vfio_next;
-	struct list_head		container_next;
-	enum vfio_group_type		type;
-	unsigned int			dev_counter;
-	struct rw_semaphore		group_rwsem;
-	struct kvm			*kvm;
-	struct file			*opened_file;
-	struct blocking_notifier_head	notifier;
-};
-
-#ifdef CONFIG_VFIO_NOIOMMU
-static bool vfio_noiommu __read_mostly;
-module_param_named(enable_unsafe_noiommu_mode,
-		   vfio_noiommu, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(enable_unsafe_noiommu_mode, "Enable UNSAFE, no-IOMMU mode.  This mode provides no device isolation, no DMA translation, no host kernel protection, cannot be used for device assignment to virtual machines, requires RAWIO permissions, and will taint the kernel.  If you do not know what this is for, step away. (default: false)");
-#else
-enum { vfio_noiommu = false };
-#endif
-
 static DEFINE_XARRAY(vfio_device_set_xa);
 static const struct file_operations vfio_group_fops;
 
@@ -164,140 +120,8 @@ static void vfio_release_device_set(struct vfio_device *device)
 	xa_unlock(&vfio_device_set_xa);
 }
 
-static void *vfio_noiommu_open(unsigned long arg)
-{
-	if (arg != VFIO_NOIOMMU_IOMMU)
-		return ERR_PTR(-EINVAL);
-	if (!capable(CAP_SYS_RAWIO))
-		return ERR_PTR(-EPERM);
-
-	return NULL;
-}
-
-static void vfio_noiommu_release(void *iommu_data)
-{
-}
-
-static long vfio_noiommu_ioctl(void *iommu_data,
-			       unsigned int cmd, unsigned long arg)
-{
-	if (cmd == VFIO_CHECK_EXTENSION)
-		return vfio_noiommu && (arg == VFIO_NOIOMMU_IOMMU) ? 1 : 0;
-
-	return -ENOTTY;
-}
-
-static int vfio_noiommu_attach_group(void *iommu_data,
-		struct iommu_group *iommu_group, enum vfio_group_type type)
-{
-	return 0;
-}
-
-static void vfio_noiommu_detach_group(void *iommu_data,
-				      struct iommu_group *iommu_group)
-{
-}
-
-static const struct vfio_iommu_driver_ops vfio_noiommu_ops = {
-	.name = "vfio-noiommu",
-	.owner = THIS_MODULE,
-	.open = vfio_noiommu_open,
-	.release = vfio_noiommu_release,
-	.ioctl = vfio_noiommu_ioctl,
-	.attach_group = vfio_noiommu_attach_group,
-	.detach_group = vfio_noiommu_detach_group,
-};
-
-/*
- * Only noiommu containers can use vfio-noiommu and noiommu containers can only
- * use vfio-noiommu.
- */
-static bool vfio_iommu_driver_allowed(struct vfio_container *container,
-				      const struct vfio_iommu_driver *driver)
-{
-	if (!IS_ENABLED(CONFIG_VFIO_NOIOMMU))
-		return true;
-	return container->noiommu == (driver->ops == &vfio_noiommu_ops);
-}
-
-/*
- * IOMMU driver registration
- */
-int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops)
-{
-	struct vfio_iommu_driver *driver, *tmp;
-
-	if (WARN_ON(!ops->register_device != !ops->unregister_device))
-		return -EINVAL;
-
-	driver = kzalloc(sizeof(*driver), GFP_KERNEL);
-	if (!driver)
-		return -ENOMEM;
-
-	driver->ops = ops;
-
-	mutex_lock(&vfio.iommu_drivers_lock);
-
-	/* Check for duplicates */
-	list_for_each_entry(tmp, &vfio.iommu_drivers_list, vfio_next) {
-		if (tmp->ops == ops) {
-			mutex_unlock(&vfio.iommu_drivers_lock);
-			kfree(driver);
-			return -EINVAL;
-		}
-	}
-
-	list_add(&driver->vfio_next, &vfio.iommu_drivers_list);
-
-	mutex_unlock(&vfio.iommu_drivers_lock);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(vfio_register_iommu_driver);
-
-void vfio_unregister_iommu_driver(const struct vfio_iommu_driver_ops *ops)
-{
-	struct vfio_iommu_driver *driver;
-
-	mutex_lock(&vfio.iommu_drivers_lock);
-	list_for_each_entry(driver, &vfio.iommu_drivers_list, vfio_next) {
-		if (driver->ops == ops) {
-			list_del(&driver->vfio_next);
-			mutex_unlock(&vfio.iommu_drivers_lock);
-			kfree(driver);
-			return;
-		}
-	}
-	mutex_unlock(&vfio.iommu_drivers_lock);
-}
-EXPORT_SYMBOL_GPL(vfio_unregister_iommu_driver);
-
 static void vfio_group_get(struct vfio_group *group);
 
-/*
- * Container objects - containers are created when /dev/vfio/vfio is
- * opened, but their lifecycle extends until the last user is done, so
- * it's freed via kref.  Must support container/group/device being
- * closed in any order.
- */
-static void vfio_container_get(struct vfio_container *container)
-{
-	kref_get(&container->kref);
-}
-
-static void vfio_container_release(struct kref *kref)
-{
-	struct vfio_container *container;
-	container = container_of(kref, struct vfio_container, kref);
-
-	kfree(container);
-}
-
-static void vfio_container_put(struct vfio_container *container)
-{
-	kref_put(&container->kref, vfio_container_release);
-}
-
 /*
  * Group objects - create, release, get, put, search
  */
@@ -702,263 +526,9 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 }
 EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
 
-/*
- * VFIO base fd, /dev/vfio/vfio
- */
-static long
-vfio_container_ioctl_check_extension(struct vfio_container *container,
-				     unsigned long arg)
-{
-	struct vfio_iommu_driver *driver;
-	long ret = 0;
-
-	down_read(&container->group_lock);
-
-	driver = container->iommu_driver;
-
-	switch (arg) {
-		/* No base extensions yet */
-	default:
-		/*
-		 * If no driver is set, poll all registered drivers for
-		 * extensions and return the first positive result.  If
-		 * a driver is already set, further queries will be passed
-		 * only to that driver.
-		 */
-		if (!driver) {
-			mutex_lock(&vfio.iommu_drivers_lock);
-			list_for_each_entry(driver, &vfio.iommu_drivers_list,
-					    vfio_next) {
-
-				if (!list_empty(&container->group_list) &&
-				    !vfio_iommu_driver_allowed(container,
-							       driver))
-					continue;
-				if (!try_module_get(driver->ops->owner))
-					continue;
-
-				ret = driver->ops->ioctl(NULL,
-							 VFIO_CHECK_EXTENSION,
-							 arg);
-				module_put(driver->ops->owner);
-				if (ret > 0)
-					break;
-			}
-			mutex_unlock(&vfio.iommu_drivers_lock);
-		} else
-			ret = driver->ops->ioctl(container->iommu_data,
-						 VFIO_CHECK_EXTENSION, arg);
-	}
-
-	up_read(&container->group_lock);
-
-	return ret;
-}
-
-/* hold write lock on container->group_lock */
-static int __vfio_container_attach_groups(struct vfio_container *container,
-					  struct vfio_iommu_driver *driver,
-					  void *data)
-{
-	struct vfio_group *group;
-	int ret = -ENODEV;
-
-	list_for_each_entry(group, &container->group_list, container_next) {
-		ret = driver->ops->attach_group(data, group->iommu_group,
-						group->type);
-		if (ret)
-			goto unwind;
-	}
-
-	return ret;
-
-unwind:
-	list_for_each_entry_continue_reverse(group, &container->group_list,
-					     container_next) {
-		driver->ops->detach_group(data, group->iommu_group);
-	}
-
-	return ret;
-}
-
-static long vfio_ioctl_set_iommu(struct vfio_container *container,
-				 unsigned long arg)
-{
-	struct vfio_iommu_driver *driver;
-	long ret = -ENODEV;
-
-	down_write(&container->group_lock);
-
-	/*
-	 * The container is designed to be an unprivileged interface while
-	 * the group can be assigned to specific users.  Therefore, only by
-	 * adding a group to a container does the user get the privilege of
-	 * enabling the iommu, which may allocate finite resources.  There
-	 * is no unset_iommu, but by removing all the groups from a container,
-	 * the container is deprivileged and returns to an unset state.
-	 */
-	if (list_empty(&container->group_list) || container->iommu_driver) {
-		up_write(&container->group_lock);
-		return -EINVAL;
-	}
-
-	mutex_lock(&vfio.iommu_drivers_lock);
-	list_for_each_entry(driver, &vfio.iommu_drivers_list, vfio_next) {
-		void *data;
-
-		if (!vfio_iommu_driver_allowed(container, driver))
-			continue;
-		if (!try_module_get(driver->ops->owner))
-			continue;
-
-		/*
-		 * The arg magic for SET_IOMMU is the same as CHECK_EXTENSION,
-		 * so test which iommu driver reported support for this
-		 * extension and call open on them.  We also pass them the
-		 * magic, allowing a single driver to support multiple
-		 * interfaces if they'd like.
-		 */
-		if (driver->ops->ioctl(NULL, VFIO_CHECK_EXTENSION, arg) <= 0) {
-			module_put(driver->ops->owner);
-			continue;
-		}
-
-		data = driver->ops->open(arg);
-		if (IS_ERR(data)) {
-			ret = PTR_ERR(data);
-			module_put(driver->ops->owner);
-			continue;
-		}
-
-		ret = __vfio_container_attach_groups(container, driver, data);
-		if (ret) {
-			driver->ops->release(data);
-			module_put(driver->ops->owner);
-			continue;
-		}
-
-		container->iommu_driver = driver;
-		container->iommu_data = data;
-		break;
-	}
-
-	mutex_unlock(&vfio.iommu_drivers_lock);
-	up_write(&container->group_lock);
-
-	return ret;
-}
-
-static long vfio_fops_unl_ioctl(struct file *filep,
-				unsigned int cmd, unsigned long arg)
-{
-	struct vfio_container *container = filep->private_data;
-	struct vfio_iommu_driver *driver;
-	void *data;
-	long ret = -EINVAL;
-
-	if (!container)
-		return ret;
-
-	switch (cmd) {
-	case VFIO_GET_API_VERSION:
-		ret = VFIO_API_VERSION;
-		break;
-	case VFIO_CHECK_EXTENSION:
-		ret = vfio_container_ioctl_check_extension(container, arg);
-		break;
-	case VFIO_SET_IOMMU:
-		ret = vfio_ioctl_set_iommu(container, arg);
-		break;
-	default:
-		driver = container->iommu_driver;
-		data = container->iommu_data;
-
-		if (driver) /* passthrough all unrecognized ioctls */
-			ret = driver->ops->ioctl(data, cmd, arg);
-	}
-
-	return ret;
-}
-
-static int vfio_fops_open(struct inode *inode, struct file *filep)
-{
-	struct vfio_container *container;
-
-	container = kzalloc(sizeof(*container), GFP_KERNEL);
-	if (!container)
-		return -ENOMEM;
-
-	INIT_LIST_HEAD(&container->group_list);
-	init_rwsem(&container->group_lock);
-	kref_init(&container->kref);
-
-	filep->private_data = container;
-
-	return 0;
-}
-
-static int vfio_fops_release(struct inode *inode, struct file *filep)
-{
-	struct vfio_container *container = filep->private_data;
-	struct vfio_iommu_driver *driver = container->iommu_driver;
-
-	if (driver && driver->ops->notify)
-		driver->ops->notify(container->iommu_data,
-				    VFIO_IOMMU_CONTAINER_CLOSE);
-
-	filep->private_data = NULL;
-
-	vfio_container_put(container);
-
-	return 0;
-}
-
-static const struct file_operations vfio_fops = {
-	.owner		= THIS_MODULE,
-	.open		= vfio_fops_open,
-	.release	= vfio_fops_release,
-	.unlocked_ioctl	= vfio_fops_unl_ioctl,
-	.compat_ioctl	= compat_ptr_ioctl,
-};
-
 /*
  * VFIO Group fd, /dev/vfio/$GROUP
  */
-static void vfio_container_detatch_group(struct vfio_group *group)
-{
-	struct vfio_container *container = group->container;
-	struct vfio_iommu_driver *driver;
-
-	lockdep_assert_held_write(&group->group_rwsem);
-	WARN_ON(group->container_users != 1);
-
-	down_write(&container->group_lock);
-
-	driver = container->iommu_driver;
-	if (driver)
-		driver->ops->detach_group(container->iommu_data,
-					  group->iommu_group);
-
-	if (group->type == VFIO_IOMMU)
-		iommu_group_release_dma_owner(group->iommu_group);
-
-	group->container = NULL;
-	group->container_users = 0;
-	list_del(&group->container_next);
-
-	/* Detaching the last group deprivileges a container, remove iommu */
-	if (driver && list_empty(&container->group_list)) {
-		driver->ops->release(container->iommu_data);
-		module_put(driver->ops->owner);
-		container->iommu_driver = NULL;
-		container->iommu_data = NULL;
-	}
-
-	up_write(&container->group_lock);
-
-	vfio_container_put(container);
-}
-
 /*
  * VFIO_GROUP_UNSET_CONTAINER should fail if there are other users or
  * if there was no container to unset.  Since the ioctl is called on
@@ -977,71 +547,6 @@ static int vfio_group_ioctl_unset_container(struct vfio_group *group)
 	return 0;
 }
 
-static struct vfio_container *vfio_container_from_file(struct file *file)
-{
-	struct vfio_container *container;
-
-	/* Sanity check, is this really our fd? */
-	if (file->f_op != &vfio_fops)
-		return NULL;
-
-	container = file->private_data;
-	WARN_ON(!container); /* fget ensures we don't race vfio_release */
-	return container;
-}
-
-static int vfio_container_attach_group(struct vfio_group *group,
-				       struct vfio_container *container)
-{
-	struct vfio_iommu_driver *driver;
-	int ret = 0;
-
-	lockdep_assert_held_write(&group->group_rwsem);
-
-	if (group->type == VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO))
-		return -EPERM;
-
-	down_write(&container->group_lock);
-
-	/* Real groups and fake groups cannot mix */
-	if (!list_empty(&container->group_list) &&
-	    container->noiommu != (group->type == VFIO_NO_IOMMU)) {
-		ret = -EPERM;
-		goto out_unlock_container;
-	}
-
-	if (group->type == VFIO_IOMMU) {
-		ret = iommu_group_claim_dma_owner(group->iommu_group, group);
-		if (ret)
-			goto out_unlock_container;
-	}
-
-	driver = container->iommu_driver;
-	if (driver) {
-		ret = driver->ops->attach_group(container->iommu_data,
-						group->iommu_group,
-						group->type);
-		if (ret) {
-			if (group->type == VFIO_IOMMU)
-				iommu_group_release_dma_owner(
-					group->iommu_group);
-			goto out_unlock_container;
-		}
-	}
-
-	group->container = container;
-	group->container_users = 1;
-	container->noiommu = (group->type == VFIO_NO_IOMMU);
-	list_add(&group->container_next, &container->group_list);
-
-	/* Get a reference on the container and mark a user within the group */
-	vfio_container_get(container);
-
-out_unlock_container:
-	up_write(&container->group_lock);
-	return ret;
-}
-
 static int vfio_group_ioctl_set_container(struct vfio_group *group,
 					  int __user *arg)
 {
@@ -1078,58 +583,11 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
 static const struct file_operations vfio_device_fops;
 
 /* true if the vfio_device has open_device() called but not close_device() */
-static bool vfio_assert_device_open(struct vfio_device *device)
+bool vfio_assert_device_open(struct vfio_device *device)
 {
 	return !WARN_ON_ONCE(!READ_ONCE(device->open_count));
 }
 
-static int vfio_device_assign_container(struct vfio_device *device)
-{
-	struct vfio_group *group = device->group;
-
-	lockdep_assert_held_write(&group->group_rwsem);
-
-	if (!group->container || !group->container->iommu_driver ||
-	    WARN_ON(!group->container_users))
-		return -EINVAL;
-
-	if (group->type == VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO))
-		return -EPERM;
-
-	get_file(group->opened_file);
-	group->container_users++;
-	return 0;
-}
-
-static void vfio_device_unassign_container(struct vfio_device *device)
-{
-	down_write(&device->group->group_rwsem);
-	WARN_ON(device->group->container_users <= 1);
-	device->group->container_users--;
-	fput(device->group->opened_file);
-	up_write(&device->group->group_rwsem);
-}
-
-static void vfio_container_register_device(struct vfio_device *device)
-{
-	struct vfio_iommu_driver *iommu_driver =
-		device->group->container->iommu_driver;
-
-	if (iommu_driver && iommu_driver->ops->register_device)
-		iommu_driver->ops->register_device(
-			device->group->container->iommu_data, device);
-}
-
-static void vfio_container_unregister_device(struct vfio_device *device)
-{
-	struct vfio_iommu_driver *iommu_driver =
-		device->group->container->iommu_driver;
-
-	if (iommu_driver && iommu_driver->ops->unregister_device)
-		iommu_driver->ops->unregister_device(
-			device->group->container->iommu_data, device);
-}
-
 static struct file *vfio_device_open(struct vfio_device *device)
 {
 	struct file *filep;
@@ -1951,114 +1409,6 @@ int vfio_set_irqs_validate_and_prepare(struct vfio_irq_set *hdr, int num_irqs,
 }
 EXPORT_SYMBOL(vfio_set_irqs_validate_and_prepare);
 
-/*
- * Pin contiguous user pages and return their associated host pages for local
- * domain only.
- * @device [in]  : device
- * @iova [in]    : starting IOVA of user pages to be pinned.
- * @npage [in]   : count of pages to be pinned.  This count should not
- *		   be greater than VFIO_PIN_PAGES_MAX_ENTRIES.
- * @prot [in]    : protection flags
- * @pages[out]   : array of host pages
- * Return error or number of pages pinned.
- */
-int vfio_pin_pages(struct vfio_device *device, dma_addr_t iova,
-		   int npage, int prot, struct page **pages)
-{
-	struct vfio_container *container;
-	struct vfio_group *group = device->group;
-	struct vfio_iommu_driver *driver;
-	int ret;
-
-	if (!pages || !npage || !vfio_assert_device_open(device))
-		return -EINVAL;
-
-	if (npage > VFIO_PIN_PAGES_MAX_ENTRIES)
-		return -E2BIG;
-
-	if (group->dev_counter > 1)
-		return -EINVAL;
-
-	/* group->container cannot change while a vfio device is open */
-	container = group->container;
-	driver = container->iommu_driver;
-	if (likely(driver && driver->ops->pin_pages))
-		ret = driver->ops->pin_pages(container->iommu_data,
-					     group->iommu_group, iova,
-					     npage, prot, pages);
-	else
-		ret = -ENOTTY;
-
-	return ret;
-}
-EXPORT_SYMBOL(vfio_pin_pages);
-
-/*
- * Unpin contiguous host pages for local domain only.
- * @device [in]  : device
- * @iova [in]    : starting address of user pages to be unpinned.
- * @npage [in]   : count of pages to be unpinned.  This count should not
- *                 be greater than VFIO_PIN_PAGES_MAX_ENTRIES.
- */
-void vfio_unpin_pages(struct vfio_device *device, dma_addr_t iova, int npage)
-{
-	struct vfio_container *container;
-	struct vfio_iommu_driver *driver;
-
-	if (WARN_ON(npage <= 0 || npage > VFIO_PIN_PAGES_MAX_ENTRIES))
-		return;
-
-	if (WARN_ON(!vfio_assert_device_open(device)))
-		return;
-
-	/* group->container cannot change while a vfio device is open */
-	container = device->group->container;
-	driver = container->iommu_driver;
-
-	driver->ops->unpin_pages(container->iommu_data, iova, npage);
-}
-EXPORT_SYMBOL(vfio_unpin_pages);
-
-/*
- * This interface allows the CPUs to perform some sort of virtual DMA on
- * behalf of the device.
- *
- * CPUs read/write from/into a range of IOVAs pointing to user space memory
- * into/from a kernel buffer.
- *
- * As the read/write of user space memory is conducted via the CPUs and is
- * not a real device DMA, it is not necessary to pin the user space memory.
- *
- * @device [in]		: VFIO device
- * @iova [in]		: base IOVA of a user space buffer
- * @data [in]		: pointer to kernel buffer
- * @len [in]		: kernel buffer length
- * @write		: indicate read or write
- * Return error code on failure or 0 on success.
- */
-int vfio_dma_rw(struct vfio_device *device, dma_addr_t iova, void *data,
-		size_t len, bool write)
-{
-	struct vfio_container *container;
-	struct vfio_iommu_driver *driver;
-	int ret = 0;
-
-	if (!data || len <= 0 || !vfio_assert_device_open(device))
-		return -EINVAL;
-
-	/* group->container cannot change while a vfio device is open */
-	container = device->group->container;
-	driver = container->iommu_driver;
-
-	if (likely(driver && driver->ops->dma_rw))
-		ret = driver->ops->dma_rw(container->iommu_data,
-					  iova, data, len, write);
-	else
-		ret = -ENOTTY;
-	return ret;
-}
-EXPORT_SYMBOL(vfio_dma_rw);
-
 /*
  * Module/class support
  */
@@ -2067,47 +1417,6 @@ static char *vfio_devnode(struct device *dev, umode_t *mode)
 	return kasprintf(GFP_KERNEL, "vfio/%s", dev_name(dev));
 }
 
-static struct miscdevice vfio_dev = {
-	.minor = VFIO_MINOR,
-	.name = "vfio",
-	.fops = &vfio_fops,
-	.nodename = "vfio/vfio",
-	.mode = S_IRUGO | S_IWUGO,
-};
-
-static int __init vfio_container_init(void)
-{
-	int ret;
-
-	mutex_init(&vfio.iommu_drivers_lock);
-	INIT_LIST_HEAD(&vfio.iommu_drivers_list);
-
-	ret = misc_register(&vfio_dev);
-	if (ret) {
-		pr_err("vfio: misc device register failed\n");
-		return ret;
-	}
-
-	if (IS_ENABLED(CONFIG_VFIO_NOIOMMU)) {
-		ret = vfio_register_iommu_driver(&vfio_noiommu_ops);
-		if (ret)
-			goto err_misc;
-	}
-	return 0;
-
-err_misc:
-	misc_deregister(&vfio_dev);
-	return ret;
-}
-
-static void vfio_container_cleanup(void)
-{
-	if (IS_ENABLED(CONFIG_VFIO_NOIOMMU))
-		vfio_unregister_iommu_driver(&vfio_noiommu_ops);
-	misc_deregister(&vfio_dev);
-	mutex_destroy(&vfio.iommu_drivers_lock);
-}
-
 static int __init vfio_init(void)
 {
 	int ret;
-- 
2.37.2

