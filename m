Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4534505A6
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 14:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhKONkD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 08:40:03 -0500
Received: from mail-mw2nam12on2057.outbound.protection.outlook.com ([40.107.244.57]:40160
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231499AbhKONj7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 08:39:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GbvuVHIQE+FRR5G6S/MfIP4rxQ41CvBy/owAjMnbpa1Wm6V2UctigAVgNs4MMIjEuoXAHBjXrMRd8XDGglsxyh32CBDv+c1M+1MT4ZgvtZAN8la8rXIBX+SNbbCr/4blP8hrK/I7fqrD7e+eEHirQ1SwvIt4/78iSefVOGaHJjka9fB6GjTsPX7vAUOqNmk4F/R0Y9DIDhm2gCNwomliDU6kox/zm8lADHDDyYoYilTyXV/l8VV1Rz+yCK44iSAq5Ddn5izKTKd51CvrnzjJm4SpHOA/RT+Q93Vo9rFuMvCiWtc4qKb6gjoUTlXSCTzIlG2arW92l8YIQzqQv3M6ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GquOSi3GXoCvXSfQnsbmFJyDIVo13bofunDrZUkH8ns=;
 b=dw0xA1HUC2F7gtOuNUMyU6Q6c8J/mS56vHMexzE4RdFyRwpjQTB0v593b1qx2Ou5kf5QG3SEP2aZdQGetpgoGeWK4Sg3+wfpoU+FpE3vhaWovvbc+xqeA8oK4ggNw+gNqbVhOPiKbxjtIN6uzIhy9eQ8+lVDyh+b6o6XhZZy3AoMEYZgzZn1aXIEPKbdVmODiUKEtrzv99rY+bT65ag0aoCk1a8FU+7zeE8M3ALUWgjeGeC6BhLDY06wE9+7/5E1MytJqoVGkjPvyaBUEiDZpxLhMy2bpHkZwt3bosxn781xuMvAaywesKZWW+xZXtxNcc3coZYUxljiQgNslEMN6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GquOSi3GXoCvXSfQnsbmFJyDIVo13bofunDrZUkH8ns=;
 b=RJ3HkXPmAZcOXd1bSpHfq2RKgfrSN+3iGWAth1KRZEcAAYtl1IPo1jkjQY65qNAk2fvWBFSV0uprTZd1B51Y14J12T+EM7gnWbZH8b044W/BcsvCf7HBCEwcfw4AUNVUOTa1zGO4K6Cofl4izEOH6ki++hHCPlZ+40wiBzgTy+/q7C8PTDL+Q6WSEVqcKz0OmaNqsFF0dmR4w9adRhUVzhi6XSE3TtBeGSlgYSxCT9oXTky2mQa/qZGtZUmcV55b5pq6WnvZb8IFzGjS1HBG/Dir3AoS6iz7PopR7q2nb/mhVpq1NrmutnlMzAmEHnme+Ks0coqtVX4kkHpQao60eQ==
Received: from MW4P221CA0008.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::13)
 by BY5PR12MB4226.namprd12.prod.outlook.com (2603:10b6:a03:203::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Mon, 15 Nov
 2021 13:37:02 +0000
Received: from CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::4a) by MW4P221CA0008.outlook.office365.com
 (2603:10b6:303:8b::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.25 via Frontend
 Transport; Mon, 15 Nov 2021 13:37:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT037.mail.protection.outlook.com (10.13.174.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4690.15 via Frontend Transport; Mon, 15 Nov 2021 13:37:02 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 15 Nov
 2021 13:37:01 +0000
Received: from nvidia-Inspiron-15-7510.nvidia.com (172.20.187.5) by
 mail.nvidia.com (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.18
 via Frontend Transport; Mon, 15 Nov 2021 13:36:57 +0000
From:   <abhsahu@nvidia.com>
To:     <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Abhishek Sahu <abhsahu@nvidia.com>
Subject: [RFC 3/3] vfio/pci: use runtime PM for vfio-device into low power state
Date:   Mon, 15 Nov 2021 19:06:40 +0530
Message-ID: <20211115133640.2231-4-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211115133640.2231-1-abhsahu@nvidia.com>
References: <20211115133640.2231-1-abhsahu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb94279b-e7c8-44ca-de61-08d9a83d0181
X-MS-TrafficTypeDiagnostic: BY5PR12MB4226:
X-Microsoft-Antispam-PRVS: <BY5PR12MB422668C90AA7DB1D639063D7CC989@BY5PR12MB4226.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ONb9SkEuiVdF/IX7kkfyaBAMVJTIHodVxDgcFQ+tuGkSoFsf5aXOYWILvkmjeAijTvcOprt0rCB7X6ntHcaC71X0gY4RPkpOWm/W483XvsxAViojDAKa+2MqQGzmx6eb8T/Dy7FmN0pFUPB7+5mvnsb+Z1h5WKbH391erIq45EKHDFG2Xf17K9gBhkxDwo7+72ITsihjvkX+4A/UIo7bPI6mlP9/h0r9nUWWIFn64LOriSPr/C2/tQ8tzNxFkTvuTvoC18A4diZi6i23xaRlfbOLKGmeoVWiMc++BofYNvOFrhxgPWYpd4ng5Z+0MSqBXaLA7RNe9fo768b1DB7N5XlG6DjkYdvFH1ksFv/oMDsqK41HLiwzQRz0kf7qTsbrMzkuc7Q/UzorbSQi66y+nDw5JBcSLTAs273mbr/Hat5rZ5NL3SeFayyunhN73lyoHi+2qy3d1b/NgK84j/f3rC4SgYhkpuHWYtaszAuieyH4a7AyYLWsiZYVp5k71a5xiHgT+6+qvg3S5312ol3jAqOn+29M2wwvfCzvqcWWD9MzAAO211mfLU4TvQZKjVIo2VJug9oloPbDJbsiCIIs6/cKqo1HmW7Vxr26ewsAj4Imubw3DiMGIl8Q/5CFY8wSjRjVeCsHOlwTWOJ25BzW2jLU0fZAEH1xIYG+eRIVWvtPl3nbBXBUgPW4wqKfSxG5Am+cS4rIe14ZJB/nZrSNtA==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(54906003)(8936002)(36906005)(7696005)(36860700001)(110136005)(70586007)(6666004)(36756003)(336012)(2906002)(5660300002)(70206006)(508600001)(1076003)(356005)(47076005)(107886003)(83380400001)(8676002)(426003)(7636003)(2616005)(186003)(30864003)(86362001)(26005)(316002)(82310400003)(2876002)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 13:37:02.0346
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb94279b-e7c8-44ca-de61-08d9a83d0181
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4226
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Abhishek Sahu <abhsahu@nvidia.com>

Currently, if the runtime power management is enabled for vfio-pci
device in guest OS, then guest OS will do the register write for
PCI_PM_CTRL register. This write request will be handled in
vfio_pm_config_write() where it will do the actual register write of
PCI_PM_CTRL register. With this, the maximum D3hot state can be
achieved for low power. If we can use the runtime PM framework, then
we can achieve the D3cold state which will help in saving
maximum power.

This patch uses runtime PM framework whenever vfio-pci device will
be put in the low power state.

1. If runtime PM is enabled, then instead of directly writing
   PCI_PM_CTRL register, decrement the device usage counter whenever
   the power state is non-D0. The kernel runtime PM framework will
   itself put the PCI device in low power state when device usage
   counter will become zero. Similarly, when the power state will be
   again changed back to D0, then increment the device usage counter
   and the kernel runtime PM framework will itself bring the PCI device
   out of low power state.

2. The guest OS will read the PCI_PM_CTRL register back to
   confirm the current power state so virtual register bits can be
   used. For this, before decrementing the usage count, read the actual
   PCI_PM_CTRL register, update the power state related bits, and then
   update the vconfig bits corresponding to PCI_PM_CTRL offset. For
   PCI_PM_CTRL register read, return the virtual value if runtime PM is
   requested. This vconfig bits will be cleared when the power state
   will be changed back to D0.

3. For the guest OS, the PCI power state will be still D3hot
   even if put the actual PCI device into D3cold state. In the D3hot
   state, the config space can still be read. So, if there is any request
   from guest OS to read the config space, then we need to move the actual
   PCI device again back to D0. For this, increment the device usage
   count before reading/writing the config space and then decrement it
   again after reading/writing the config space. There can be
   back-to-back config register read/write request, but since the auto
   suspend methods are being used here so only first access will
   wake up the PCI device and for the remaining access, the device will
   already be active.

4. This above-mentioned wake up is not needed if the register
   read/write is done completely with virtual bits. For handling this
   condition, the actual resume of device will only being done in
   vfio_user_config_read()/vfio_user_config_write(). All the config
   register access will come vfio_pci_config_rw(). So, in this
   function, use the pm_runtime_get_noresume() so that only usage count
   will be incremented without resuming the device. Inside,
   vfio_user_config_read()/vfio_user_config_write(), use the routines
   with pm_runtime_put_noidle() so that the PCI device won’t be
   suspended in the lower level functions. Again in the top level
   vfio_pci_config_rw(), use the pm_runtime_put_autosuspend(). Now the
   auto suspend timer will be started and the device will be suspended
   again. If the device is already runtime suspended, then this routine
   will return early.

5. In the host side D3cold will only be used if the platform has
   support for this, otherwise some other state will be used. The
   config space can be read if the device is not in D3cold state. So in
   this case, we can skip the resuming of PCI device. The wrapper
   function vfio_pci_config_pm_runtime_get() takes care of this
   condition and invoke the pm_runtime_resume() only if current power
   state is D3cold.

6. For vfio_pci_config_pm_runtime_get()/vfio_
   pci_config_pm_runtime_put(), the reference code is taken from
   pci_config_pm_runtime_get()/pci_config_pm_runtime_put() and then it
   is modified according to vfio-pci driver requirement.

7. vfio_pci_set_power_state() will be unused after moving to runtime
   PM, so this function can be removed along with other related
   functions and structure fields.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_config.c | 178 ++++++++++++++++++++++++++---
 drivers/vfio/pci/vfio_pci_core.c   |  64 ++---------
 include/linux/vfio_pci_core.h      |   3 +-
 3 files changed, 174 insertions(+), 71 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index fb3a503a5b99..5576eb4308b4 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -25,6 +25,7 @@
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 
 #include <linux/vfio_pci_core.h>
 
@@ -119,12 +120,51 @@ struct perm_bits {
 #define	NO_WRITE	0
 #define	ALL_WRITE	0xFFFFFFFFU
 
-static int vfio_user_config_read(struct pci_dev *pdev, int offset,
+static void vfio_pci_config_pm_runtime_get(struct pci_dev *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device *parent = dev->parent;
+
+	if (parent)
+		pm_runtime_get_sync(parent);
+
+	pm_runtime_get_noresume(dev);
+	/*
+	 * pdev->current_state is set to PCI_D3cold during suspending,
+	 * so wait until suspending completes
+	 */
+	pm_runtime_barrier(dev);
+	/*
+	 * Only need to resume devices in D3cold, because config
+	 * registers are still accessible for devices suspended but
+	 * not in D3cold.
+	 */
+	if (pdev->current_state == PCI_D3cold)
+		pm_runtime_resume(dev);
+}
+
+static void vfio_pci_config_pm_runtime_put(struct pci_dev *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device *parent = dev->parent;
+
+	pm_runtime_mark_last_busy(dev);
+	pm_runtime_put_noidle(dev);
+
+	if (parent)
+		pm_runtime_put_noidle(parent);
+}
+
+static int vfio_user_config_read(struct vfio_pci_core_device *vdev, int offset,
 				 __le32 *val, int count)
 {
+	struct pci_dev *pdev = vdev->pdev;
 	int ret = -EINVAL;
 	u32 tmp_val = 0;
 
+	if (vdev->pm_runtime_suspended)
+		vfio_pci_config_pm_runtime_get(pdev);
+
 	switch (count) {
 	case 1:
 	{
@@ -147,15 +187,22 @@ static int vfio_user_config_read(struct pci_dev *pdev, int offset,
 
 	*val = cpu_to_le32(tmp_val);
 
+	if (vdev->pm_runtime_suspended)
+		vfio_pci_config_pm_runtime_put(pdev);
+
 	return ret;
 }
 
-static int vfio_user_config_write(struct pci_dev *pdev, int offset,
+static int vfio_user_config_write(struct vfio_pci_core_device *vdev, int offset,
 				  __le32 val, int count)
 {
+	struct pci_dev *pdev = vdev->pdev;
 	int ret = -EINVAL;
 	u32 tmp_val = le32_to_cpu(val);
 
+	if (vdev->pm_runtime_suspended)
+		vfio_pci_config_pm_runtime_get(pdev);
+
 	switch (count) {
 	case 1:
 		ret = pci_user_write_config_byte(pdev, offset, tmp_val);
@@ -168,6 +215,9 @@ static int vfio_user_config_write(struct pci_dev *pdev, int offset,
 		break;
 	}
 
+	if (vdev->pm_runtime_suspended)
+		vfio_pci_config_pm_runtime_put(pdev);
+
 	return ret;
 }
 
@@ -183,11 +233,10 @@ static int vfio_default_config_read(struct vfio_pci_core_device *vdev, int pos,
 
 	/* Any non-virtualized bits? */
 	if (cpu_to_le32(~0U >> (32 - (count * 8))) != virt) {
-		struct pci_dev *pdev = vdev->pdev;
 		__le32 phys_val = 0;
 		int ret;
 
-		ret = vfio_user_config_read(pdev, pos, &phys_val, count);
+		ret = vfio_user_config_read(vdev, pos, &phys_val, count);
 		if (ret)
 			return ret;
 
@@ -224,18 +273,17 @@ static int vfio_default_config_write(struct vfio_pci_core_device *vdev, int pos,
 
 	/* Non-virtualzed and writable bits go to hardware */
 	if (write & ~virt) {
-		struct pci_dev *pdev = vdev->pdev;
 		__le32 phys_val = 0;
 		int ret;
 
-		ret = vfio_user_config_read(pdev, pos, &phys_val, count);
+		ret = vfio_user_config_read(vdev, pos, &phys_val, count);
 		if (ret)
 			return ret;
 
 		phys_val &= ~(write & ~virt);
 		phys_val |= (val & (write & ~virt));
 
-		ret = vfio_user_config_write(pdev, pos, phys_val, count);
+		ret = vfio_user_config_write(vdev, pos, phys_val, count);
 		if (ret)
 			return ret;
 	}
@@ -250,7 +298,7 @@ static int vfio_direct_config_read(struct vfio_pci_core_device *vdev, int pos,
 {
 	int ret;
 
-	ret = vfio_user_config_read(vdev->pdev, pos, val, count);
+	ret = vfio_user_config_read(vdev, pos, val, count);
 	if (ret)
 		return ret;
 
@@ -275,7 +323,7 @@ static int vfio_raw_config_write(struct vfio_pci_core_device *vdev, int pos,
 {
 	int ret;
 
-	ret = vfio_user_config_write(vdev->pdev, pos, val, count);
+	ret = vfio_user_config_write(vdev, pos, val, count);
 	if (ret)
 		return ret;
 
@@ -288,7 +336,7 @@ static int vfio_raw_config_read(struct vfio_pci_core_device *vdev, int pos,
 {
 	int ret;
 
-	ret = vfio_user_config_read(vdev->pdev, pos, val, count);
+	ret = vfio_user_config_read(vdev, pos, val, count);
 	if (ret)
 		return ret;
 
@@ -692,13 +740,86 @@ static int __init init_pci_cap_basic_perm(struct perm_bits *perm)
 	return 0;
 }
 
+static int vfio_perform_runtime_pm(struct vfio_pci_core_device *vdev, int pos,
+				   int count, struct perm_bits *perm,
+				   int offset, __le32 val, pci_power_t state)
+{
+	/*
+	 * If runtime PM is enabled, then instead of directly writing
+	 * PCI_PM_CTRL register, decrement the device usage counter whenever
+	 * the power state is non-D0. The kernel runtime PM framework will
+	 * itself put the PCI device in the low power state when device usage
+	 * counter will become zero. The guest OS will read the PCI_PM_CTRL
+	 * register back to confirm the current power state so virtual
+	 * register bits can be used. For this, read the actual PCI_PM_CTRL
+	 * register, update the power state related bits and then update the
+	 * vconfig bits corresponding to PCI_PM_CTRL offset. If the
+	 * pm_runtime_suspended status is set, then return the virtual
+	 * register value for PCI_PM_CTRL register read. All the bits
+	 * in PCI_PM_CTRL are being returned from virtual config, so that
+	 * this register read will not wake up the PCI device from suspended
+	 * state.
+	 *
+	 * Once power state will be changed back to D0, then clear the power
+	 * state related bits in vconfig. After this, increment the device
+	 * usage counter which will internally wake up the PCI device from
+	 * suspended state.
+	 */
+	if (state != PCI_D0 && !vdev->pm_runtime_suspended) {
+		__le32 virt_val = 0;
+
+		count = vfio_default_config_write(vdev, pos, count, perm,
+						  offset, val);
+		if (count < 0)
+			return count;
+
+		vfio_default_config_read(vdev, pos, 4, perm, offset, &virt_val);
+		virt_val &= ~cpu_to_le32(PCI_PM_CTRL_STATE_MASK);
+		virt_val |= (val & cpu_to_le32(PCI_PM_CTRL_STATE_MASK));
+		memcpy(vdev->vconfig + pos, &virt_val, 4);
+		vdev->pm_runtime_suspended = true;
+		pm_runtime_mark_last_busy(&vdev->pdev->dev);
+		pm_runtime_put_autosuspend(&vdev->pdev->dev);
+		return count;
+	}
+
+	if (vdev->pm_runtime_suspended && state == PCI_D0) {
+		vdev->pm_runtime_suspended = false;
+		*(__le16 *)&vdev->vconfig[pos] &=
+			~cpu_to_le16(PCI_PM_CTRL_STATE_MASK);
+		pm_runtime_get_sync(&vdev->pdev->dev);
+	}
+
+	return vfio_default_config_write(vdev, pos, count, perm, offset, val);
+}
+
+static int vfio_pm_config_read(struct vfio_pci_core_device *vdev, int pos,
+			       int count, struct perm_bits *perm,
+			       int offset, __le32 *val)
+{
+	/*
+	 * If pm_runtime_suspended status is set, then return the virtual
+	 * register value for PCI_PM_CTRL register read.
+	 */
+	if (vdev->pm_runtime_suspended &&
+	    offset >= PCI_PM_CTRL && offset < (PCI_PM_CTRL + 4)) {
+		memcpy(val, vdev->vconfig + pos, count);
+		return count;
+	}
+
+	return vfio_default_config_read(vdev, pos, count, perm, offset, val);
+}
+
 static int vfio_pm_config_write(struct vfio_pci_core_device *vdev, int pos,
 				int count, struct perm_bits *perm,
 				int offset, __le32 val)
 {
-	count = vfio_default_config_write(vdev, pos, count, perm, offset, val);
-	if (count < 0)
-		return count;
+	if (offset != PCI_PM_CTRL) {
+		count = vfio_default_config_write(vdev, pos, count, perm,
+						  offset, val);
+		if (count < 0)
+			return count;
+	}
 
 	if (offset == PCI_PM_CTRL) {
 		pci_power_t state;
@@ -718,7 +839,8 @@ static int vfio_pm_config_write(struct vfio_pci_core_device *vdev, int pos,
 			break;
 		}
 
-		vfio_pci_set_power_state(vdev, state);
+		count = vfio_perform_runtime_pm(vdev, pos, count, perm,
+						offset, val, state);
 	}
 
 	return count;
@@ -731,6 +853,7 @@ static int __init init_pci_cap_pm_perm(struct perm_bits *perm)
 		return -ENOMEM;
 
 	perm->writefn = vfio_pm_config_write;
+	perm->readfn = vfio_pm_config_read;
 
 	/*
 	 * We always virtualize the next field so we can remove
@@ -1921,13 +2044,31 @@ ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 	size_t done = 0;
 	int ret = 0;
 	loff_t pos = *ppos;
+	bool runtime_put_required = false;
 
 	pos &= VFIO_PCI_OFFSET_MASK;
 
+	/*
+	 * For virtualized bits read/write, the device should not be resumed.
+	 * Increment the device usage count alone so that the device won't be
+	 * runtime suspended during config read/write.
+	 */
+	if (vdev->pm_runtime_suspended) {
+		pm_runtime_get_noresume(&vdev->pdev->dev);
+		runtime_put_required = true;
+	}
+
 	while (count) {
 		ret = vfio_config_do_rw(vdev, buf, count, &pos, iswrite);
-		if (ret < 0)
+		if (ret < 0) {
+			/*
+			 * Decrement the device usage counter corresponding to
+			 * previous pm_runtime_get_noresume().
+			 */
+			if (runtime_put_required)
+				pm_runtime_put_autosuspend(&vdev->pdev->dev);
 			return ret;
+		}
 
 		count -= ret;
 		done += ret;
@@ -1937,5 +2078,12 @@ ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 
 	*ppos += done;
 
+	/*
+	 * Decrement the device usage counter corresponding to previous
+	 * pm_runtime_get_noresume().
+	 */
+	if (runtime_put_required)
+		pm_runtime_put_autosuspend(&vdev->pdev->dev);
+
 	return done;
 }
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 511a52e92b32..79fa86914b6c 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -187,57 +187,6 @@ static bool vfio_pci_nointx(struct pci_dev *pdev)
 	return false;
 }
 
-static void vfio_pci_probe_power_state(struct vfio_pci_core_device *vdev)
-{
-	struct pci_dev *pdev = vdev->pdev;
-	u16 pmcsr;
-
-	if (!pdev->pm_cap)
-		return;
-
-	pci_read_config_word(pdev, pdev->pm_cap + PCI_PM_CTRL, &pmcsr);
-
-	vdev->needs_pm_restore = !(pmcsr & PCI_PM_CTRL_NO_SOFT_RESET);
-}
-
-/*
- * pci_set_power_state() wrapper handling devices which perform a soft reset on
- * D3->D0 transition.  Save state prior to D0/1/2->D3, stash it on the vdev,
- * restore when returned to D0.  Saved separately from pci_saved_state for use
- * by PM capability emulation and separately from pci_dev internal saved state
- * to avoid it being overwritten and consumed around other resets.
- */
-int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t state)
-{
-	struct pci_dev *pdev = vdev->pdev;
-	bool needs_restore = false, needs_save = false;
-	int ret;
-
-	if (vdev->needs_pm_restore) {
-		if (pdev->current_state < PCI_D3hot && state >= PCI_D3hot) {
-			pci_save_state(pdev);
-			needs_save = true;
-		}
-
-		if (pdev->current_state >= PCI_D3hot && state <= PCI_D0)
-			needs_restore = true;
-	}
-
-	ret = pci_set_power_state(pdev, state);
-
-	if (!ret) {
-		/* D3 might be unsupported via quirk, skip unless in D3 */
-		if (needs_save && pdev->current_state >= PCI_D3hot) {
-			vdev->pm_save = pci_store_saved_state(pdev);
-		} else if (needs_restore) {
-			pci_load_and_free_saved_state(pdev, &vdev->pm_save);
-			pci_restore_state(pdev);
-		}
-	}
-
-	return ret;
-}
-
 int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
@@ -323,6 +272,16 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 	/* For needs_reset */
 	lockdep_assert_held(&vdev->vdev.dev_set->lock);
 
+	/*
+	 * The vfio device user can close the device after putting the device
+	 * into runtime suspended state so wake up the device first in
+	 * this case.
+	 */
+	if (vdev->pm_runtime_suspended) {
+		vdev->pm_runtime_suspended = false;
+		pm_runtime_get_sync(&pdev->dev);
+	}
+
 	/* Stop the device from further DMA */
 	pci_clear_master(pdev);
 
@@ -1809,7 +1768,6 @@ void vfio_pci_core_uninit_device(struct vfio_pci_core_device *vdev)
 	mutex_destroy(&vdev->vma_lock);
 	vfio_uninit_group_dev(&vdev->vdev);
 	kfree(vdev->region);
-	kfree(vdev->pm_save);
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_uninit_device);
 
@@ -1855,8 +1813,6 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 	if (ret)
 		goto out_vf;
 
-	vfio_pci_probe_power_state(vdev);
-
 	/*
 	 * pci-core sets the device power state to an unknown value at
 	 * bootup and after being removed from a driver.  The only
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index aafe09c9fa64..2b1a556ce73f 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -123,9 +123,8 @@ struct vfio_pci_core_device {
 	bool			has_vga;
 	bool			needs_reset;
 	bool			nointx;
-	bool			needs_pm_restore;
+	bool                    pm_runtime_suspended;
 	struct pci_saved_state	*pci_saved_state;
-	struct pci_saved_state	*pm_save;
 	int			ioeventfds_nr;
 	struct eventfd_ctx	*err_trigger;
 	struct eventfd_ctx	*req_trigger;
-- 
2.17.1

