Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58BBB357DCF
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 10:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbhDHIL1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 04:11:27 -0400
Received: from mail-eopbgr680076.outbound.protection.outlook.com ([40.107.68.76]:27904
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229586AbhDHIL1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 04:11:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O46Q38GA48wbDNxDsM99Aek2zg4RN0zkhYolSvUyYp6i4L4JSKTDS2A5UaUSeKYNECnAsywoxDL5bbrr6h/gEl9gOxXhH4hpNV6qtb73b2ZMitI2Ba7iB/PZr9RwmK1L59/wBnxiNlakdmcXLRcYowrd6VayoVFEGRXfAsDROOukue6Tolw5ZaQdOipeOX+6g9Tq6w2jnXZRx3EikQ+swpRcndDP0h/p/fDeFU+EHEoM95ab1X2/DktCqnnHHUxqNIwsGGhqnKOsJu0Oi0MhPOaQV/oiWRl9VGE4XwBy3GSZXQsWNjHHI9duNEdonwMdl/2eqnBTGyxEuPc46EC/kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P1mwYaM6JmQW45V9+z7rNmoVf8/o0ooE41rlJ7DO/uU=;
 b=aJmcRjyokVvlyFkoD3JsBYUilVy5wwKkyo95Ljru194np1aH6L2N9YVPi8WwCMz7YBvxbtNLGQsw9lQWP+Ktow+pFvCAj7QqO7abYE1D4WktCPIT5JlD5FYwgLBgROmjbjCpCLbZhxaGxuAMo4CmcjeutEhbfPxGGpy6gL74y7Q6wQ98hssYJ0Q0cmSg10YYRPJjYWpxdp60Hw4WjifmAaFlCcjQUPCQAmd3/Jg8AJikLLspgfqRoiNOYgrb+jM64no0byxe65WLaKo+BEPwYrrUnB3UiXRFdeM2VifuvbWuv6LcYY2nsJHi2sSLvVXsz9ipnkOnD5IV7xcARRgsqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P1mwYaM6JmQW45V9+z7rNmoVf8/o0ooE41rlJ7DO/uU=;
 b=Bv0uANrlaJy6LlLKrDfmRPQWEnHxA5PG7mCb9sWihhoZmYJy7l9jQ9T4OCdKRe2lmQTZbbcn9ZLnhiSF1YeAMrQbGfwti2fEUtsVRzDsTUpH+2XxlA66nWBO13xkB/rbPwW6oZFDtlcvNgKrUY3sSFa0yCyqAo58ql3b/Tyi5sZd6wBzbIrn3sYn0ZUZdLjF51gw80VZbZCwXYxrTzRCaLWSsWS8wbFUXZr6tjkQrkkXxLJtzzAisIbwkIPxguQZyq4ubAxHVX8ktstwyOBmgWyYGeSgQbK5nnw6ncDLm3TZmm8RqLVJQZyNsXZpdE7o/6elSvKV2mMsBvpybSC6MA==
Received: from BN6PR13CA0027.namprd13.prod.outlook.com (2603:10b6:404:13e::13)
 by BYAPR12MB2949.namprd12.prod.outlook.com (2603:10b6:a03:12f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Thu, 8 Apr
 2021 08:11:13 +0000
Received: from BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:13e:cafe::7a) by BN6PR13CA0027.outlook.office365.com
 (2603:10b6:404:13e::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.8 via Frontend
 Transport; Thu, 8 Apr 2021 08:11:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT029.mail.protection.outlook.com (10.13.177.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 08:11:13 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Apr
 2021 01:11:12 -0700
Received: from r-nvmx02.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 8 Apr 2021 01:11:10 -0700
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <mst@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <jasowang@redhat.com>
CC:     <oren@nvidia.com>, <nitzanc@nvidia.com>, <cohuck@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH v2 1/3] virtio: update reset callback to return status
Date:   Thu, 8 Apr 2021 08:11:07 +0000
Message-ID: <20210408081109.56537-1-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af8c6e37-7640-4fc4-659f-08d8fa65e060
X-MS-TrafficTypeDiagnostic: BYAPR12MB2949:
X-Microsoft-Antispam-PRVS: <BYAPR12MB2949CB171BD35E536D81A345DE749@BYAPR12MB2949.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H1xl8awJlhTgDxhyIQmAQxvww1gB8EPzN0EARpPt2nQnhDLIaJ2Q1+IcfJxCE42uRpaP6gEiH2qQJeXR0TEd/vZ5/mtYmamMlKtrovCoi6kZigClO1w2msy0BBxlrdcSYSmVfZ+jnFj+8uCy5V6Kl1wI61RQloEkFhH/A5N1SE/LGhf4Di7BohEN4qFYaMVJFB6Ah9AdS8dpo2LgGp3QyNmNqjsx8/mydk75jBDDavWpvDR6V8gXJZerWV6QR4WRsSQzYoEU5VP0svSM34GUGI21qswExHkFu5M98W40UMiubQXBZg5jhYJPvhap6FraCRhdJolb29UbASaMzbhxApfWt17DoplAUEUNB7okmMs1TihgIBhi9yFWlWrzc8ljKS3rtSOKBDBF6sLquuSuBl9FnZJL1VVBfe5PvRAJpyTG+OkkcEyyvErTYJ5IHfEBFAFo37rWUFNkzayVrPNdtp5sBv1WoUG+mlr5wvUjMD88P+V8rH4MO5AWiaY1tnlzHVqmDK+XjZSSL0jkgRwbSClj7+22ksbt+enOhN00KvlGFWLYj7G1XdlLJ1cIIicywmRrLMdVlsAHeIJa1Dcu7iFDeYvQoWnBx3lghj3u7cX8Ull0SMaMh8zkC0VvJ6F+ppNNy+wWNmjFizhJ/jPZx50ax2jhUSVVJs7ifjDUT6c=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(39860400002)(376002)(36840700001)(46966006)(82740400003)(54906003)(7636003)(36756003)(110136005)(186003)(426003)(336012)(356005)(107886003)(2616005)(4326008)(86362001)(8676002)(6666004)(70586007)(47076005)(8936002)(2906002)(36860700001)(82310400003)(70206006)(1076003)(83380400001)(15650500001)(478600001)(5660300002)(26005)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 08:11:13.3471
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af8c6e37-7640-4fc4-659f-08d8fa65e060
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2949
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

changes from v1:
 - update virtio_ccw.c (Cornelia)
 - update virtio_uml.c
 - update mlxbf-tmfifo.c

---
 arch/um/drivers/virtio_uml.c             |  4 +++-
 drivers/platform/mellanox/mlxbf-tmfifo.c |  4 +++-
 drivers/remoteproc/remoteproc_virtio.c   |  4 +++-
 drivers/s390/virtio/virtio_ccw.c         |  9 ++++++---
 drivers/virtio/virtio.c                  | 22 +++++++++++++++-------
 drivers/virtio/virtio_mmio.c             |  3 ++-
 drivers/virtio/virtio_pci_legacy.c       |  4 +++-
 drivers/virtio/virtio_pci_modern.c       |  3 ++-
 drivers/virtio/virtio_vdpa.c             |  4 +++-
 include/linux/virtio_config.h            |  5 +++--
 10 files changed, 43 insertions(+), 19 deletions(-)

diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
index 91ddf74ca888..b6e66265ed32 100644
--- a/arch/um/drivers/virtio_uml.c
+++ b/arch/um/drivers/virtio_uml.c
@@ -827,11 +827,13 @@ static void vu_set_status(struct virtio_device *vdev, u8 status)
 	vu_dev->status = status;
 }
 
-static void vu_reset(struct virtio_device *vdev)
+static int vu_reset(struct virtio_device *vdev)
 {
 	struct virtio_uml_device *vu_dev = to_virtio_uml_device(vdev);
 
 	vu_dev->status = 0;
+
+	return 0;
 }
 
 static void vu_del_vq(struct virtqueue *vq)
diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c b/drivers/platform/mellanox/mlxbf-tmfifo.c
index bbc4e71a16ff..c192b8ac5d9e 100644
--- a/drivers/platform/mellanox/mlxbf-tmfifo.c
+++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
@@ -980,11 +980,13 @@ static void mlxbf_tmfifo_virtio_set_status(struct virtio_device *vdev,
 }
 
 /* Reset the device. Not much here for now. */
-static void mlxbf_tmfifo_virtio_reset(struct virtio_device *vdev)
+static int mlxbf_tmfifo_virtio_reset(struct virtio_device *vdev)
 {
 	struct mlxbf_tmfifo_vdev *tm_vdev = mlxbf_vdev_to_tmfifo(vdev);
 
 	tm_vdev->status = 0;
+
+	return 0;
 }
 
 /* Read the value of a configuration field. */
diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index 0cc617f76068..ca9573c62c3d 100644
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
@@ -200,6 +200,8 @@ static void rproc_virtio_reset(struct virtio_device *vdev)
 
 	rsc->status = 0;
 	dev_dbg(&vdev->dev, "reset !\n");
+
+	return 0;
 }
 
 /* provide the vdev features as retrieved from the firmware */
diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index 54e686dca6de..52b32555e746 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -732,14 +732,15 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 	return ret;
 }
 
-static void virtio_ccw_reset(struct virtio_device *vdev)
+static int virtio_ccw_reset(struct virtio_device *vdev)
 {
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
 	struct ccw1 *ccw;
+	int ret;
 
 	ccw = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*ccw));
 	if (!ccw)
-		return;
+		return -ENOMEM;
 
 	/* Zero status bits. */
 	vcdev->dma_area->status = 0;
@@ -749,8 +750,10 @@ static void virtio_ccw_reset(struct virtio_device *vdev)
 	ccw->flags = 0;
 	ccw->count = 0;
 	ccw->cda = 0;
-	ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_RESET);
+	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_RESET);
 	ccw_device_dma_free(vcdev->cdev, ccw, sizeof(*ccw));
+
+	return ret;
 }
 
 static u64 virtio_ccw_get_features(struct virtio_device *vdev)
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
index d62e9835aeec..0b5d95e3efa1 100644
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
@@ -99,6 +99,8 @@ static void vp_reset(struct virtio_device *vdev)
 	ioread8(vp_dev->ioaddr + VIRTIO_PCI_STATUS);
 	/* Flush pending VQ/configuration callbacks. */
 	vp_synchronize_vectors(vdev);
+
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
index e28acf482e0c..5fd4e627a9b0 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -97,11 +97,13 @@ static void virtio_vdpa_set_status(struct virtio_device *vdev, u8 status)
 	return ops->set_status(vdpa, status);
 }
 
-static void virtio_vdpa_reset(struct virtio_device *vdev)
+static int virtio_vdpa_reset(struct virtio_device *vdev)
 {
 	struct vdpa_device *vdpa = vd_get_vdpa(vdev);
 
 	vdpa_reset(vdpa);
+
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

