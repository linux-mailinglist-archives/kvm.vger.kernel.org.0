Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 881435AEC20
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 16:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241535AbiIFOUg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 10:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242065AbiIFOT3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 10:19:29 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on20626.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::626])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489DD7C747;
        Tue,  6 Sep 2022 06:50:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DTiqYh0R9IQLyNNSTuMVrymfIIyWYTZWt+9q6+69OlUCcpfTO+IKfFysCZgrQFbTiQvEBzyttkvfn3BCYcHLcNl58Ldm8dX/8OQl5YBE2I1aAehg6dFWbEBNLztVxoNj6AaZ1df598XXQAhAYe/fNfKU3ouwu2FPOTEe6kY2otnQ98g2WdN16W7g39j11eWvsmT05gDAqiLMKBCAnuutaB5LmlabhDN4RmwgA/thFyNU/cqqL1cgWZsIQougCGMJVF3qbWLrlCGnrB7JEeUl5O5n9zUlSXGymXTeg0IH2PnfXH2YjYU5LWSCTCHf/owjWdHRTKiEXLRDU5hZqLv/4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jxrq6UNgnw9n2PFbKZm7D+rKr3QmAMqj2BlP6aDUCpw=;
 b=QTfMfPL/Ap0A4KjGRhXj8Bs9VLZceO5bpgnlFMYXz/8HJNNPw+yIdm2T5xEXYsV/8Of/6hYWOg1uYK4iz8W3WTq00vPaidptwBLt74FR8D62OCpOg1xGIb98RZ2veiZbld70D3lLiK+w+SSR/wvl7kMW4jS6gZnY/+InB82zjmMjS4k1An6hdVXNQgs7/3ftHRr++OxRq3qew2FmCvQd5xeWe9b8GfQLSVsARampb6V7oIl2cfk/TRLMi8A/t8+KX59x1GWmwJEM3MOzxajxkDYdTQqoq9M+3alN7beHq+AJ17MQj9EYpwDIFZGbaCF6k6grapBt58poZjKy8GHJ8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jxrq6UNgnw9n2PFbKZm7D+rKr3QmAMqj2BlP6aDUCpw=;
 b=Ymg6nWRPA9xIWZpCwDD7oNuTez2e9YK84/olVSEJyQcwieQSZm+3QHheag1GXffLwuCGp92809ei7bCpQljyTlhTvZXuSxShoAAjcPAfomxxliI/bLgp9SLKWp3ggaJ9Pk3eYe5AL0Jdb7KF5iF4G2uCeUXvmWcOFqcwi9fPg/M=
Received: from DS7PR07CA0021.namprd07.prod.outlook.com (2603:10b6:5:3af::23)
 by DM4PR12MB5988.namprd12.prod.outlook.com (2603:10b6:8:6b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.17; Tue, 6 Sep
 2022 13:49:24 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3af:cafe::cc) by DS7PR07CA0021.outlook.office365.com
 (2603:10b6:5:3af::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12 via Frontend
 Transport; Tue, 6 Sep 2022 13:49:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5588.10 via Frontend Transport; Tue, 6 Sep 2022 13:49:23 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 6 Sep
 2022 08:49:23 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 6 Sep
 2022 06:49:22 -0700
Received: from xhdipdslab49.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Tue, 6 Sep 2022 08:49:13 -0500
From:   Nipun Gupta <nipun.gupta@amd.com>
To:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <gregkh@linuxfoundation.org>, <rafael@kernel.org>,
        <eric.auger@redhat.com>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>, <puneet.gupta@amd.com>,
        <song.bao.hua@hisilicon.com>, <mchehab+huawei@kernel.org>,
        <maz@kernel.org>, <f.fainelli@gmail.com>,
        <jeffrey.l.hugo@gmail.com>, <saravanak@google.com>,
        <Michael.Srba@seznam.cz>, <mani@kernel.org>, <yishaih@nvidia.com>,
        <jgg@ziepe.ca>, <jgg@nvidia.com>, <robin.murphy@arm.com>,
        <will@kernel.org>, <joro@8bytes.org>, <masahiroy@kernel.org>,
        <ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kbuild@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <okaya@kernel.org>, <harpreet.anand@amd.com>,
        <nikhil.agarwal@amd.com>, <michal.simek@amd.com>,
        <aleksandar.radovanovic@amd.com>, <git@amd.com>,
        Nipun Gupta <nipun.gupta@amd.com>
Subject: [RFC PATCH v3 7/7] vfio/cdx: add interrupt support
Date:   Tue, 6 Sep 2022 19:18:01 +0530
Message-ID: <20220906134801.4079497-8-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220906134801.4079497-1-nipun.gupta@amd.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220906134801.4079497-1-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 458526e5-3474-4c86-6482-08da900e9b95
X-MS-TrafficTypeDiagnostic: DM4PR12MB5988:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F2mSicpu8HDq8g0JXDKxhSzoQTioj5+TO8p7RIfF18MjYsqFATw7U1PwCYS564tpQdS37NTeypjwbgJwGwM+RBT0DwbS6w3OOckBOjKAgpOOFETWkb6ke+h7oKyF42m6Nn9hvEugpL6vK8JzcfdOVIDUi6bRexaIcfRHEPLBnpDCn6L3yT6R7x1mthpyzPY+B0ieMJLm0v0D9G1vL2/2iLIr84s6MHVyS0JrFlAu0/vdyp8TlWdVQwcgqlZvPXiF+sKnXB4SikY2twCfie6MtyA2uERG/5PfllRBw8Xm2DxibqcJCcnHRxete/47HEP3yWd2afSqH/CcO1kXVgt2dSuHZyrEghMoAEMKn2KjlmMAJAVv4iIC4P/e5uihc1CC1AyeZT4vAfN/FFWmhXRDTmEOEjcg42RAIK1QS4xM7p06I8U7kdyon3nnyBaeUSuNTqbBQNykUEGJsHTTqHGNHvvDgmf3X+xzaSR3CGieMseKzwgXPFa83R0RNCfECWjFUn1VXMpY8/oN4iW+HwtIYQituXoaLWRtxK294IP+3qKXw6GYdy269FeczU5aMCcTK2SYbnqtHD8bvPNGcdk2xGGt55/YjBCAkUuQ8Fi0pw/qBEwQ0mKlJ4DoPZte0sF1KWl7xl7BOFxpbqrUEs4wVoD9iDHsY5XH5TeDxJF4PUrlXsV/jSbzZ9h18vxGCy/QODJNuT/kVn7p//qgR2id2TIHraTFQ0q8xKFGat1WcgYyBuH9DMbJlu5FrpwUPLMljl2TRUZdk1QR5oIcDJUj8Lz1397am8rbPM+LhUUfccXjuhipqss0WeR/mAsDEkiMX4etuAmBF2IjISYif+04SkLhMvoEvsrBWMTebFds9RMaUpQzG3s1P2DthGZiXR+h
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(136003)(346002)(396003)(46966006)(40470700004)(36840700001)(5660300002)(186003)(1076003)(336012)(47076005)(426003)(44832011)(36860700001)(4326008)(70586007)(8676002)(7416002)(8936002)(2906002)(83380400001)(70206006)(2616005)(110136005)(41300700001)(478600001)(316002)(81166007)(40480700001)(921005)(82310400005)(40460700003)(6666004)(82740400003)(36756003)(54906003)(86362001)(356005)(26005)(36900700001)(83996005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 13:49:23.9609
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 458526e5-3474-4c86-6482-08da900e9b95
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5988
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch allows to set an eventfd for cdx device interrupts
and also to trigger the interrupt eventfd from userspace.
All CDX device interrupts are MSIs. The MSIs are allocated from
the CDX-MSI domain.

Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
---
 drivers/vfio/cdx/vfio_cdx.c         |  53 +++++++
 drivers/vfio/cdx/vfio_cdx_intr.c    | 212 ++++++++++++++++++++++++++++
 drivers/vfio/cdx/vfio_cdx_private.h |  18 +++
 3 files changed, 283 insertions(+)
 create mode 100644 drivers/vfio/cdx/vfio_cdx_intr.c

diff --git a/drivers/vfio/cdx/vfio_cdx.c b/drivers/vfio/cdx/vfio_cdx.c
index 2e5bd494057a..4591b8057b2f 100644
--- a/drivers/vfio/cdx/vfio_cdx.c
+++ b/drivers/vfio/cdx/vfio_cdx.c
@@ -77,6 +77,8 @@ static void vfio_cdx_close_device(struct vfio_device *core_vdev)
 	if (WARN_ON(ret))
 		dev_warn(core_vdev->dev,
 			 "VFIO_CDX: reset device has failed (%d)\n", ret);
+
+	vfio_cdx_irqs_cleanup(vdev);
 }
 
 static long vfio_cdx_ioctl(struct vfio_device *core_vdev,
@@ -132,6 +134,57 @@ static long vfio_cdx_ioctl(struct vfio_device *core_vdev,
 			return -EFAULT;
 		return 0;
 	}
+	case VFIO_DEVICE_GET_IRQ_INFO:
+	{
+		struct vfio_irq_info info;
+
+		minsz = offsetofend(struct vfio_irq_info, count);
+		if (copy_from_user(&info, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (info.argsz < minsz)
+			return -EINVAL;
+
+		if (info.index >= 1)
+			return -EINVAL;
+
+		info.flags = VFIO_IRQ_INFO_EVENTFD;
+		info.count = cdx_dev->num_msi;
+
+		if (copy_to_user((void __user *)arg, &info, minsz))
+			return -EFAULT;
+		return 0;
+	}
+	case VFIO_DEVICE_SET_IRQS:
+	{
+		struct vfio_irq_set hdr;
+		u8 *data = NULL;
+		int ret = 0;
+		size_t data_size = 0;
+
+		minsz = offsetofend(struct vfio_irq_set, count);
+
+		if (copy_from_user(&hdr, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		ret = vfio_set_irqs_validate_and_prepare(&hdr,
+				cdx_dev->num_msi, 1, &data_size);
+		if (ret)
+			return ret;
+
+		if (data_size) {
+			data = memdup_user((void __user *)(arg + minsz),
+				   data_size);
+			if (IS_ERR(data))
+				return PTR_ERR(data);
+		}
+
+		ret = vfio_cdx_set_irqs_ioctl(vdev, hdr.flags,
+				hdr.index, hdr.start, hdr.count, data);
+		kfree(data);
+
+		return ret;
+	}
 	case VFIO_DEVICE_RESET:
 	{
 		return vfio_cdx_reset_device(vdev);
diff --git a/drivers/vfio/cdx/vfio_cdx_intr.c b/drivers/vfio/cdx/vfio_cdx_intr.c
new file mode 100644
index 000000000000..20fe87bce464
--- /dev/null
+++ b/drivers/vfio/cdx/vfio_cdx_intr.c
@@ -0,0 +1,212 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022, Advanced Micro Devices, Inc.
+ */
+
+#include <linux/vfio.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/eventfd.h>
+#include <linux/msi.h>
+#include <linux/interrupt.h>
+
+#include "linux/cdx/cdx_bus.h"
+#include "vfio_cdx_private.h"
+
+static irqreturn_t vfio_cdx_msihandler(int irq_no, void *arg)
+{
+	struct eventfd_ctx *trigger = arg;
+
+	eventfd_signal(trigger, 1);
+	return IRQ_HANDLED;
+}
+
+static int vfio_cdx_msi_enable(struct vfio_cdx_device *vdev, int nvec)
+{
+	struct device *dev = vdev->dev;
+	int msi_idx, ret;
+
+	vdev->cdx_irqs = kcalloc(nvec, sizeof(struct vfio_cdx_irq), GFP_KERNEL);
+	if (!vdev->cdx_irqs)
+		return -ENOMEM;
+
+	/* Allocate cdx MSIs */
+	ret = cdx_msi_domain_alloc_irqs(dev, nvec);
+	if (ret < 0) {
+		kfree(vdev->cdx_irqs);
+		return ret;
+	}
+
+	for (msi_idx = 0; msi_idx < nvec; msi_idx++)
+		vdev->cdx_irqs[msi_idx].irq_no = msi_get_virq(dev, msi_idx);
+
+	vdev->irq_count = nvec;
+	vdev->config_msi = 1;
+
+	return 0;
+}
+
+static int vfio_cdx_msi_set_vector_signal(struct vfio_cdx_device *vdev,
+					  int vector, int fd)
+{
+	struct eventfd_ctx *trigger;
+	int irq_no, ret;
+
+	if (vector < 0 || vector >= vdev->irq_count)
+		return -EINVAL;
+
+	irq_no = vdev->cdx_irqs[vector].irq_no;
+
+	if (vdev->cdx_irqs[vector].trigger) {
+		free_irq(irq_no, vdev->cdx_irqs[vector].trigger);
+		kfree(vdev->cdx_irqs[vector].name);
+		eventfd_ctx_put(vdev->cdx_irqs[vector].trigger);
+		vdev->cdx_irqs[vector].trigger = NULL;
+	}
+
+	if (fd < 0)
+		return 0;
+
+	vdev->cdx_irqs[vector].name = kasprintf(GFP_KERNEL, "vfio-msi[%d](%s)",
+						vector, dev_name(vdev->dev));
+	if (!vdev->cdx_irqs[vector].name)
+		return -ENOMEM;
+
+	trigger = eventfd_ctx_fdget(fd);
+	if (IS_ERR(trigger)) {
+		kfree(vdev->cdx_irqs[vector].name);
+		return PTR_ERR(trigger);
+	}
+
+	ret = request_irq(irq_no, vfio_cdx_msihandler, 0,
+			  vdev->cdx_irqs[vector].name, trigger);
+	if (ret) {
+		kfree(vdev->cdx_irqs[vector].name);
+		eventfd_ctx_put(trigger);
+		return ret;
+	}
+
+	vdev->cdx_irqs[vector].trigger = trigger;
+
+	return 0;
+}
+
+static int vfio_cdx_msi_set_block(struct vfio_cdx_device *vdev,
+				  unsigned int start, unsigned int count,
+				  int32_t *fds)
+{
+	int i, j, ret = 0;
+
+	if (start >= vdev->irq_count || start + count > vdev->irq_count)
+		return -EINVAL;
+
+	for (i = 0, j = start; i < count && !ret; i++, j++) {
+		int fd = fds ? fds[i] : -1;
+
+		ret = vfio_cdx_msi_set_vector_signal(vdev, j, fd);
+	}
+
+	if (ret) {
+		for (--j; j >= (int)start; j--)
+			vfio_cdx_msi_set_vector_signal(vdev, j, -1);
+	}
+
+	return ret;
+}
+
+static void vfio_cdx_msi_disable(struct vfio_cdx_device *vdev)
+{
+	struct device *dev = vdev->dev;
+
+	vfio_cdx_msi_set_block(vdev, 0, vdev->irq_count, NULL);
+
+	if (vdev->config_msi == 1)
+		cdx_msi_domain_free_irqs(dev);
+
+	vdev->config_msi = 0;
+	vdev->irq_count = 0;
+
+	kfree(vdev->cdx_irqs);
+}
+
+static int vfio_cdx_set_msi_trigger(struct vfio_cdx_device *vdev,
+				    unsigned int index, unsigned int start,
+				    unsigned int count, uint32_t flags,
+				    void *data)
+{
+	struct cdx_device *cdx_dev = vdev->cdx_dev;
+	int i;
+
+	if (start + count > cdx_dev->num_msi)
+		return -EINVAL;
+
+	if (!count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
+		vfio_cdx_msi_disable(vdev);
+		return 0;
+	}
+
+	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
+		s32 *fds = data;
+		int ret;
+
+		if (vdev->config_msi)
+			return vfio_cdx_msi_set_block(vdev, start, count,
+						  fds);
+		ret = vfio_cdx_msi_enable(vdev, start + count);
+		if (ret)
+			return ret;
+
+		ret = vfio_cdx_msi_set_block(vdev, start, count, fds);
+		if (ret)
+			vfio_cdx_msi_disable(vdev);
+
+		return ret;
+	}
+
+	for (i = start; i < start + count; i++) {
+		if (!vdev->cdx_irqs[i].trigger)
+			continue;
+		if (flags & VFIO_IRQ_SET_DATA_NONE) {
+			eventfd_signal(vdev->cdx_irqs[i].trigger, 1);
+		} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
+			u8 *bools = data;
+
+			if (bools[i - start])
+				eventfd_signal(vdev->cdx_irqs[i].trigger, 1);
+		}
+	}
+
+	return 0;
+}
+
+int vfio_cdx_set_irqs_ioctl(struct vfio_cdx_device *vdev,
+			    u32 flags, unsigned int index,
+			    unsigned int start, unsigned int count,
+			    void *data)
+{
+	if (flags & VFIO_IRQ_SET_ACTION_TRIGGER)
+		return vfio_cdx_set_msi_trigger(vdev, index, start,
+			  count, flags, data);
+	else
+		return -EINVAL;
+}
+
+/* Free All IRQs for the given device */
+void vfio_cdx_irqs_cleanup(struct vfio_cdx_device *vdev)
+{
+	/*
+	 * Device does not support any interrupt or the interrupts
+	 * were not configured
+	 */
+	if (!vdev->cdx_irqs)
+		return;
+
+	vfio_cdx_set_msi_trigger(vdev, 1, 0, 0,
+			VFIO_IRQ_SET_DATA_NONE, NULL);
+
+	if (vdev->config_msi) {
+		cdx_msi_domain_free_irqs(vdev->dev);
+		kfree(vdev->cdx_irqs);
+	}
+	vdev->cdx_irqs = NULL;
+}
diff --git a/drivers/vfio/cdx/vfio_cdx_private.h b/drivers/vfio/cdx/vfio_cdx_private.h
index d87b55663462..9f93fc8cabfd 100644
--- a/drivers/vfio/cdx/vfio_cdx_private.h
+++ b/drivers/vfio/cdx/vfio_cdx_private.h
@@ -14,6 +14,14 @@
 #define VFIO_CDX_INDEX_TO_OFFSET(index)	\
 	((u64)(index) << VFIO_CDX_OFFSET_SHIFT)
 
+struct vfio_cdx_irq {
+	u32			flags;
+	u32			count;
+	int			irq_no;
+	struct eventfd_ctx	*trigger;
+	char			*name;
+};
+
 struct vfio_cdx_region {
 	u32			flags;
 	u32			type;
@@ -27,6 +35,16 @@ struct vfio_cdx_device {
 	struct cdx_device		*cdx_dev;
 	struct device			*dev;
 	struct vfio_cdx_region		*regions;
+	struct vfio_cdx_irq		*cdx_irqs;
+	uint32_t			irq_count;
+	uint32_t			config_msi;
 };
 
+int vfio_cdx_set_irqs_ioctl(struct vfio_cdx_device *vdev,
+		u32 flags, unsigned int index,
+		unsigned int start, unsigned int count,
+		void *data);
+
+void vfio_cdx_irqs_cleanup(struct vfio_cdx_device *vdev);
+
 #endif /* VFIO_CDX_PRIVATE_H */
-- 
2.25.1

