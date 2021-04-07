Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C281356BC8
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 14:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235259AbhDGMJn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 08:09:43 -0400
Received: from mail-dm6nam12on2042.outbound.protection.outlook.com ([40.107.243.42]:13795
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234810AbhDGMJj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 08:09:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W+iSFKK/47tly0COdPOrxyRWNi1d9AbaYm47IUSVeg8hSqgH52bj+lLJXw/oAo6mEiTDK3TgXr9jkjmSo2ClDkpV771XTsukZDPadLB69J20Y6DueEmN4kKnGVTh9Y+oVcQiDYZgao8XfwEyUadUY9E2R77tIE1NdLMeCu4hLDxOmu7Nd+sCWMN+yypE/ma6SJjI/aa9Zwelf27Yxs5khdk0S1iuU/tckW+0jaB5HyFNbfG9LhgksB/pGlFwOn4Ips2f73sYVXoXyHI7wBfbmRSo/1j7tDFkd0F8ZjKPXYYFvIVlgv7b7rGoDjD9ATobY3lP5YR2pRjE28MLK3s4Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yg4L4+RG827wx7kvUQi3gfqCTJEpv9Ob8nuvTmw4NVw=;
 b=VzFmWQLUopzTq0GjnrBsiCWc/qPC5ENl5XQY3wb/NzCGXXw+H/llL05c88pcC3V7CB8+cAjx753FoKhyLFzNuNghuUy8BZ9BnjvHGyRWJ+UhxWRhMqU/K1WdszqHTBltd3ATe18jGwUVdVX5by/Qm3wKezPQFcFoK1CesWIhlhbN9siOivCEPLsohV82QUOcVUUckUDJ932+HFpHKChIr3OVFLJHA9N69PWCxSchoZ2dgMJvTzGLCVXVR648hlEyzIasHx9xtl5SNICcvJ01J6qtaVqiu4+OqYnnOddr+4oSaptxuOpOgxHbhKQ59QgWfADGR0vOW4M8/aTgeNLsqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yg4L4+RG827wx7kvUQi3gfqCTJEpv9Ob8nuvTmw4NVw=;
 b=dRbxa/raRtFPLgjIbwezOwso1kYOqNR+LXdxSX4meoRHo//A9tPkGUHR/mjccYL7Qr8ppbFIZ3n0GeZN1ptNxNULViswVz8JHiiOfBBoBnZg29viXIL5+OEKFO3BQvEMkVJJMOsLV3wGNsmPTcsS7HhaMMZMNdN4fCoaLmr2MRrOLE5/Ioi8KYx4222dfslOirUD559kdEK+LF9+kgLl+5PUSk8teXv+zDHKP4gmcpkETeKS56BAB7Ld5PcoTsc/50rgR3cmn/ekns8C+OVUJAtTzsQ7nd9Ror3J+w5KvDPWGu3a7JH2sZSqWae9nxEqaO37YZyWrPC/vqHy0l11oA==
Received: from DS7PR05CA0025.namprd05.prod.outlook.com (2603:10b6:5:3b9::30)
 by DM5PR12MB1530.namprd12.prod.outlook.com (2603:10b6:4:4::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.27; Wed, 7 Apr 2021 12:09:28 +0000
Received: from DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::34) by DS7PR05CA0025.outlook.office365.com
 (2603:10b6:5:3b9::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.9 via Frontend
 Transport; Wed, 7 Apr 2021 12:09:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT037.mail.protection.outlook.com (10.13.172.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Wed, 7 Apr 2021 12:09:27 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 7 Apr
 2021 12:09:27 +0000
Received: from r-nvmx02.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 7 Apr 2021 12:09:25 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <mst@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <jasowang@redhat.com>
CC:     <oren@nvidia.com>, <nitzanc@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 1/3] virtio: update reset callback to return status
Date:   Wed, 7 Apr 2021 12:09:22 +0000
Message-ID: <20210407120924.133294-1-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8705d255-7db6-4be8-1a6d-08d8f9bdfde6
X-MS-TrafficTypeDiagnostic: DM5PR12MB1530:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1530541F95B1F4A8AAC8759DDE759@DM5PR12MB1530.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YByB3DotBcRpeaMBOFVBkCvXL2G70bZlCpv9Mnuo4t6nB/TSRY+DNHc6XSFoMsyFS7DgDIl52kRUsgrE21HWsxrR+dQOvTbKMxgB0SsuXuSti8Oz0eChxPDzFcMEqcQlwG8tuUqjwu4C2htksD+Eys9JW8N/g1xu+tVObXAssCw/YLWAkDYtMWR+vbY6Ap9XlARiuLXVrc6e+HJpluL1NWoKrjNbXfoj7tyZ4n1CmUSKmw7Pjt+ddRQoSOITTUigwtGZitVSMRdZa9ulx9olfn0TemE5zOjFhQ+HY7autShb9c8S6UECt8HsM3TPMiDOmt51egqmJA0G0M84kgtOCfMhH+xVGQQpITqgqQtROsvpiWW3JzcDWxnt+mWam1pSpIWTlFfIC++N6YJyTTUcwnS7dO850JnauUiK02elzxVtIiMJvx7VOM3S/F+DE0pMEv7P5mMB/+Qpj35JmDPpeiGgvM2BFDyaLBHbkh8JnaU4Rang9no7eOEifj/lObE2fR8g7kc66i8fjc20H3TyWNomjWhliCJj7q3yeu1/JAafbpwVIzk1dKEGRf/dnqut9PzoIuNsWZbj/yPlIFpg8r7K6EWdthQzPD45QDI4+mhMJjs3wi2GdvbSUzXXIrHTs4x5l2soY9bsb9kvYrVV9x5ByaP2XOlxdcY5rrypCMs=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(396003)(39860400002)(36840700001)(46966006)(316002)(6666004)(26005)(8936002)(2906002)(8676002)(36906005)(5660300002)(82740400003)(54906003)(110136005)(356005)(47076005)(36860700001)(86362001)(70206006)(83380400001)(70586007)(1076003)(478600001)(82310400003)(107886003)(7636003)(4326008)(36756003)(2616005)(336012)(186003)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 12:09:27.5596
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8705d255-7db6-4be8-1a6d-08d8f9bdfde6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1530
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The reset device operation, usually is an operation that might fail from
various reasons. For example, the controller might be in a bad state and
can't answer to any request. Usually, the paravirt SW based virtio
devices always succeed in reset operation but this is not the case for
HW based virtio devices.

This commit is also a preparation for adding a timeout mechanism for
resetting virtio devices.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/remoteproc/remoteproc_virtio.c |  3 ++-
 drivers/virtio/virtio.c                | 22 +++++++++++++++-------
 drivers/virtio/virtio_mmio.c           |  3 ++-
 drivers/virtio/virtio_pci_legacy.c     |  3 ++-
 drivers/virtio/virtio_pci_modern.c     |  3 ++-
 drivers/virtio/virtio_vdpa.c           |  3 ++-
 include/linux/virtio_config.h          |  5 +++--
 7 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index 0cc617f76068..432f39288c15 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -191,7 +191,7 @@ static void rproc_virtio_set_status(struct virtio_device *vdev, u8 status)
 	dev_dbg(&vdev->dev, "status: %d\n", status);
 }
 
-static void rproc_virtio_reset(struct virtio_device *vdev)
+static int rproc_virtio_reset(struct virtio_device *vdev)
 {
 	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
 	struct fw_rsc_vdev *rsc;
@@ -200,6 +200,7 @@ static void rproc_virtio_reset(struct virtio_device *vdev)
 
 	rsc->status = 0;
 	dev_dbg(&vdev->dev, "reset !\n");
+	return 0;
 }
 
 /* provide the vdev features as retrieved from the firmware */
diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 4b15c00c0a0a..ddbfd5b5f3bd 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -338,7 +338,7 @@ int register_virtio_device(struct virtio_device *dev)
 	/* Assign a unique device index and hence name. */
 	err = ida_simple_get(&virtio_index_ida, 0, 0, GFP_KERNEL);
 	if (err < 0)
-		goto out;
+		goto out_err;
 
 	dev->index = err;
 	dev_set_name(&dev->dev, "virtio%u", dev->index);
@@ -349,7 +349,9 @@ int register_virtio_device(struct virtio_device *dev)
 
 	/* We always start by resetting the device, in case a previous
 	 * driver messed it up.  This also tests that code path a little. */
-	dev->config->reset(dev);
+	err = dev->config->reset(dev);
+	if (err)
+		goto out_ida;
 
 	/* Acknowledge that we've seen the device. */
 	virtio_add_status(dev, VIRTIO_CONFIG_S_ACKNOWLEDGE);
@@ -362,10 +364,14 @@ int register_virtio_device(struct virtio_device *dev)
 	 */
 	err = device_add(&dev->dev);
 	if (err)
-		ida_simple_remove(&virtio_index_ida, dev->index);
-out:
-	if (err)
-		virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
+		goto out_ida;
+
+	return 0;
+
+out_ida:
+	ida_simple_remove(&virtio_index_ida, dev->index);
+out_err:
+	virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
 	return err;
 }
 EXPORT_SYMBOL_GPL(register_virtio_device);
@@ -408,7 +414,9 @@ int virtio_device_restore(struct virtio_device *dev)
 
 	/* We always start by resetting the device, in case a previous
 	 * driver messed it up. */
-	dev->config->reset(dev);
+	ret = dev->config->reset(dev);
+	if (ret)
+		goto err;
 
 	/* Acknowledge that we've seen the device. */
 	virtio_add_status(dev, VIRTIO_CONFIG_S_ACKNOWLEDGE);
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 56128b9c46eb..12b8f048c48d 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -256,12 +256,13 @@ static void vm_set_status(struct virtio_device *vdev, u8 status)
 	writel(status, vm_dev->base + VIRTIO_MMIO_STATUS);
 }
 
-static void vm_reset(struct virtio_device *vdev)
+static int vm_reset(struct virtio_device *vdev)
 {
 	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
 
 	/* 0 status means a reset. */
 	writel(0, vm_dev->base + VIRTIO_MMIO_STATUS);
+	return 0;
 }
 
 
diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
index d62e9835aeec..ff4d9506aa65 100644
--- a/drivers/virtio/virtio_pci_legacy.c
+++ b/drivers/virtio/virtio_pci_legacy.c
@@ -89,7 +89,7 @@ static void vp_set_status(struct virtio_device *vdev, u8 status)
 	iowrite8(status, vp_dev->ioaddr + VIRTIO_PCI_STATUS);
 }
 
-static void vp_reset(struct virtio_device *vdev)
+static int vp_reset(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	/* 0 status means a reset. */
@@ -99,6 +99,7 @@ static void vp_reset(struct virtio_device *vdev)
 	ioread8(vp_dev->ioaddr + VIRTIO_PCI_STATUS);
 	/* Flush pending VQ/configuration callbacks. */
 	vp_synchronize_vectors(vdev);
+	return 0;
 }
 
 static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vector)
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index fbd4ebc00eb6..cc3412a96a17 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -158,7 +158,7 @@ static void vp_set_status(struct virtio_device *vdev, u8 status)
 	vp_modern_set_status(&vp_dev->mdev, status);
 }
 
-static void vp_reset(struct virtio_device *vdev)
+static int vp_reset(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
@@ -174,6 +174,7 @@ static void vp_reset(struct virtio_device *vdev)
 		msleep(1);
 	/* Flush pending VQ/configuration callbacks. */
 	vp_synchronize_vectors(vdev);
+	return 0;
 }
 
 static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vector)
diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
index e28acf482e0c..da76190f7b07 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -97,11 +97,12 @@ static void virtio_vdpa_set_status(struct virtio_device *vdev, u8 status)
 	return ops->set_status(vdpa, status);
 }
 
-static void virtio_vdpa_reset(struct virtio_device *vdev)
+static int virtio_vdpa_reset(struct virtio_device *vdev)
 {
 	struct vdpa_device *vdpa = vd_get_vdpa(vdev);
 
 	vdpa_reset(vdpa);
+	return 0;
 }
 
 static bool virtio_vdpa_notify(struct virtqueue *vq)
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 8519b3ae5d52..d2b0f1699a75 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -44,9 +44,10 @@ struct virtio_shm_region {
  *	status: the new status byte
  * @reset: reset the device
  *	vdev: the virtio device
- *	After this, status and feature negotiation must be done again
+ *	Upon success, status and feature negotiation must be done again
  *	Device must not be reset from its vq/config callbacks, or in
  *	parallel with being added/removed.
+ *	Returns 0 on success or error status.
  * @find_vqs: find virtqueues and instantiate them.
  *	vdev: the virtio_device
  *	nvqs: the number of virtqueues to find
@@ -82,7 +83,7 @@ struct virtio_config_ops {
 	u32 (*generation)(struct virtio_device *vdev);
 	u8 (*get_status)(struct virtio_device *vdev);
 	void (*set_status)(struct virtio_device *vdev, u8 status);
-	void (*reset)(struct virtio_device *vdev);
+	int (*reset)(struct virtio_device *vdev);
 	int (*find_vqs)(struct virtio_device *, unsigned nvqs,
 			struct virtqueue *vqs[], vq_callback_t *callbacks[],
 			const char * const names[], const bool *ctx,
-- 
2.25.4

