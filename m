Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 600C1579C8D
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 14:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241279AbiGSMkb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 08:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241540AbiGSMjt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 08:39:49 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2071.outbound.protection.outlook.com [40.107.243.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6B55C36B;
        Tue, 19 Jul 2022 05:16:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cXFcgU7tfPYXT4ulox3IVbCaCnFTu6z1HpShzFyT8hFZs+xD65wPtjKbXj1VaIll6nnsdxOtDXq0IOw6T6vf3zuES3nk4euc1FbMuRAeXOmTBeoNwl7DM65gAr1095JYe34pJJ/XMVGMlJKPemok0VaMCressJdGVBtyi6pZvH0/V0XSWmZr0tqqjSIbrcRsTM2+guTK1Yn4BuITZrRGu5trt2BXTrXii0jL2p2rYzZtTAhoH5elZT4mbVtV86mWsjlRb+5oV5lnIQMRhDWu5eX/w37/UmijdemOtnoST0+uZpeK5V+DLUPu2y7dh/slYH5BRe9vwAS+ZorbRUYeag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h6vVCKtKWmjl1TILDH0TXAeoi8G0VZKAzO55Wssu16Y=;
 b=eRZslSg0QF75QLZVmNmtGEYwirpZrtuN4RMcVljaIZlBAwv7WUaUOCFi5sszhGK5QlK+uO2jdkoTKm8ruZxoJk37SCGDCcGuOGEpNVcw0190v+GFNcp9wT8vRyXsZ2+QYSVKQXLfVmuho+uMLYRYSJKE1yvlowjYigqNL0dp8IqT9pDlyA3tbTm+xTXU7B5WFLaZeceaVCe6mhro/sHhU1LpdqsFVX4KevCOS4dETVRZpPYgVfxWVf7EhzCI6CridBBH9BC1FVxxoqG5xI/SU15vikRauuxG4ntcgQX693497m4TOWcBk7POUaZi2bSp9nMiYC4WCe7+oKeWOFDKQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h6vVCKtKWmjl1TILDH0TXAeoi8G0VZKAzO55Wssu16Y=;
 b=tS7HmmFyG69Gy9ZCbqCXeiO8Tpes7do1AQR9x5puNTfJXaDBCV6LK4pwSmnGef3wDu+CWAcEtXizGfBuqEk4pNqHTWbSnZp5Q31X8sBeln43Yq6Y5UZGLaKhyVJaeldLgN/A8C/zFOw/umKANlRoeNEvTgWNk5yCPfA32losVYybECL8n6RsARsdXdnBdhfGzd0mWUEeLfm4v1X1v6QYnIzRAn9mk/albSJ3SiLBvJpdXp7s7sf99UtD3feKOLbu/N054Ljm5q4vXUDaoeBTpqnzv879SDxuiITDhUWh7HMcW5lq2o2PqRy6FSNlVqTll88QLglDpsA5gwYVyxHxZg==
Received: from BN9PR03CA0973.namprd03.prod.outlook.com (2603:10b6:408:109::18)
 by MWHPR12MB1694.namprd12.prod.outlook.com (2603:10b6:301:11::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Tue, 19 Jul
 2022 12:16:02 +0000
Received: from BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:109:cafe::d6) by BN9PR03CA0973.outlook.office365.com
 (2603:10b6:408:109::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14 via Frontend
 Transport; Tue, 19 Jul 2022 12:16:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT061.mail.protection.outlook.com (10.13.177.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Tue, 19 Jul 2022 12:16:01 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 19 Jul 2022 12:16:00 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 19 Jul 2022 05:15:59 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Tue, 19 Jul 2022 05:15:55 -0700
From:   Abhishek Sahu <abhsahu@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Abhishek Sahu <abhsahu@nvidia.com>
Subject: [PATCH v5 4/5] vfio/pci: Implement VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY/EXIT
Date:   Tue, 19 Jul 2022 17:45:22 +0530
Message-ID: <20220719121523.21396-5-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220719121523.21396-1-abhsahu@nvidia.com>
References: <20220719121523.21396-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7284629-bd37-4975-c1a9-08da69807217
X-MS-TrafficTypeDiagnostic: MWHPR12MB1694:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: leMgE7TweL6xUzT8Ac1KUlkFAmFIRbR9AMIo4caxoNqsaU8KJkRsMTp+iGeQb5hfyEqLJwPOLo6PPJDvRud6qK+lwBXgLI1MlWUD64pLIO03BhoScUS1oAyjdNsEh3jwkUwhM59Sj+yvGMPrfIFVw0CqfIrfiEazqAeSali1HTKmw1rv0qpxPHehKlwob8gfVObfqw9xRMCRVD3qZltzOj4+DwkanGKuiXQPDNeJHZGA/9sMu40QHRZx+KK+TpH+XhzR8sJngOH7PATdkbB5/0qg6KLnPPuSl54SGOgiDWBEGly+frbIPF6F4JOYUFgisK8Cg0dMjY5EkmKJcjl8kOKTPmCOyBC1jl5MQcm+algdeRJTRfPWhjaNJnGgAE+kuJ7dGImbK986X1HHgV5cFAMda3YExTbEnsbCPmBDQcwQGmceRL/HUVBqrRSZnieAY2BqoEFdAJe8v6hi4WNN8bojp/1Fsy38RGc0Be5ebUDRbfHcivEQXH2JO8U3eQ8vMi9b5Y3nxmuYe4KbKomHav6IhT99JfEysK3d3/2vTbU/Gt9qH3WldAPYu/hsejkCF3g7Wr3wjI6D3vdfOR4JVBbclG7u6xowaM2fLiVWnVXXjQk5ESzFQ4qv+Gb2lrSVzEpu0xCG88ZqBnUzeudjn24d2pYzmgRq+cy/rKYxCkUJhW65abZv2O83/w4gcBGWNZLFuHneq/3X5ZjB1/0tLmcG8aGjB0Uj3KBwgSdjYjRCLbluurMuisrgy11DpQtVeOGTaEKJJyDnuzV7g6LddhAQauhyKLnoJd10etlU83FvGUjl6/uowcGXio0h7uvj5YYS3biTMkYxPiMEh/xLgQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(396003)(136003)(36840700001)(40470700004)(46966006)(86362001)(7696005)(426003)(36756003)(356005)(478600001)(2616005)(186003)(82740400003)(47076005)(30864003)(110136005)(26005)(6666004)(41300700001)(81166007)(336012)(1076003)(316002)(40460700003)(82310400005)(2906002)(70586007)(8936002)(5660300002)(4326008)(40480700001)(36860700001)(54906003)(7416002)(8676002)(107886003)(83380400001)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 12:16:01.5049
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7284629-bd37-4975-c1a9-08da69807217
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1694
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, if the runtime power management is enabled for vfio-pci
based devices in the guest OS, then the guest OS will do the register
write for PCI_PM_CTRL register. This write request will be handled in
vfio_pm_config_write() where it will do the actual register write of
PCI_PM_CTRL register. With this, the maximum D3hot state can be
achieved for low power. If we can use the runtime PM framework, then
we can achieve the D3cold state (on the supported systems) which will
help in saving maximum power.

1. D3cold state can't be achieved by writing PCI standard
   PM config registers. This patch implements the following
   newly added low power related device features:
    - VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY
    - VFIO_DEVICE_FEATURE_LOW_POWER_EXIT

   The VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY will move the device into
   the low power state, and the VFIO_DEVICE_FEATURE_LOW_POWER_EXIT
   will move the device out of the low power state.

2. The vfio-pci driver uses runtime PM framework for low power entry and
   exit. On the platforms where D3cold state is supported, the runtime
   PM framework will put the device into D3cold otherwise, D3hot or some
   other power state will be used. If the user has explicitly disabled
   runtime PM for the device, then the device will be in the power state
   configured by the guest OS through PCI_PM_CTRL.

3. The hypervisors can implement virtual ACPI methods. For example,
   in guest linux OS if PCI device ACPI node has _PR3 and _PR0 power
   resources with _ON/_OFF method, then guest linux OS invokes
   the _OFF method during D3cold transition and then _ON during D0
   transition. The hypervisor can tap these virtual ACPI calls and then
   call the low power device feature IOCTL.

4. The 'pm_runtime_engaged' flag tracks the entry and exit to
   runtime PM. This flag is protected with 'memory_lock' semaphore.

5. All the config and other region access are wrapped under
   pm_runtime_resume_and_get() and pm_runtime_put(). So, if any
   device access happens while the device is in the runtime suspended
   state, then the device will be resumed first before access. Once the
   access has been finished, then the device will again go into the
   runtime suspended state.

6. The memory region access through mmap will not be allowed in the low
   power state. Since __vfio_pci_memory_enabled() is a common function,
   so check for 'pm_runtime_engaged' has been added explicitly in
   vfio_pci_mmap_fault() to block only mmap'ed access.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 151 +++++++++++++++++++++++++++++--
 include/linux/vfio_pci_core.h    |   1 +
 2 files changed, 144 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 9517645acfa6..726a6f282496 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -259,11 +259,98 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
 	return ret;
 }
 
+static int vfio_pci_runtime_pm_entry(struct vfio_pci_core_device *vdev)
+{
+	/*
+	 * The vdev power related flags are protected with 'memory_lock'
+	 * semaphore.
+	 */
+	vfio_pci_zap_and_down_write_memory_lock(vdev);
+	if (vdev->pm_runtime_engaged) {
+		up_write(&vdev->memory_lock);
+		return -EINVAL;
+	}
+
+	vdev->pm_runtime_engaged = true;
+	pm_runtime_put_noidle(&vdev->pdev->dev);
+	up_write(&vdev->memory_lock);
+
+	return 0;
+}
+
+static int vfio_pci_core_pm_entry(struct vfio_device *device, u32 flags,
+				  void __user *arg, size_t argsz)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(device, struct vfio_pci_core_device, vdev);
+	int ret;
+
+	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET, 0);
+	if (ret != 1)
+		return ret;
+
+	/*
+	 * Inside vfio_pci_runtime_pm_entry(), only the runtime PM usage count
+	 * will be decremented. The pm_runtime_put() will be invoked again
+	 * while returning from the ioctl and then the device can go into
+	 * runtime suspended state.
+	 */
+	return vfio_pci_runtime_pm_entry(vdev);
+}
+
+static void vfio_pci_runtime_pm_exit(struct vfio_pci_core_device *vdev)
+{
+	/*
+	 * The vdev power related flags are protected with 'memory_lock'
+	 * semaphore.
+	 */
+	down_write(&vdev->memory_lock);
+	if (vdev->pm_runtime_engaged) {
+		vdev->pm_runtime_engaged = false;
+		pm_runtime_get_noresume(&vdev->pdev->dev);
+	}
+
+	up_write(&vdev->memory_lock);
+}
+
+static int vfio_pci_core_pm_exit(struct vfio_device *device, u32 flags,
+				 void __user *arg, size_t argsz)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(device, struct vfio_pci_core_device, vdev);
+	int ret;
+
+	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET, 0);
+	if (ret != 1)
+		return ret;
+
+	/*
+	 * The device should already be resumed by the vfio core layer.
+	 * vfio_pci_runtime_pm_exit() will internally increment the usage
+	 * count corresponding to pm_runtime_put() called during low power
+	 * feature entry.
+	 */
+	vfio_pci_runtime_pm_exit(vdev);
+	return 0;
+}
+
 #ifdef CONFIG_PM
 static int vfio_pci_core_runtime_suspend(struct device *dev)
 {
 	struct vfio_pci_core_device *vdev = dev_get_drvdata(dev);
 
+	down_write(&vdev->memory_lock);
+	/*
+	 * The user can move the device into D3hot state before invoking
+	 * power management IOCTL. Move the device into D0 state here and then
+	 * the pci-driver core runtime PM suspend function will move the device
+	 * into the low power state. Also, for the devices which have
+	 * NoSoftRst-, it will help in restoring the original state
+	 * (saved locally in 'vdev->pm_save').
+	 */
+	vfio_pci_set_power_state(vdev, PCI_D0);
+	up_write(&vdev->memory_lock);
+
 	/*
 	 * If INTx is enabled, then mask INTx before going into the runtime
 	 * suspended state and unmask the same in the runtime resume.
@@ -393,6 +480,18 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 
 	/*
 	 * This function can be invoked while the power state is non-D0.
+	 * This non-D0 power state can be with or without runtime PM.
+	 * vfio_pci_runtime_pm_exit() will internally increment the usage
+	 * count corresponding to pm_runtime_put() called during low power
+	 * feature entry and then pm_runtime_resume() will wake up the device,
+	 * if the device has already gone into the suspended state. Otherwise,
+	 * the vfio_pci_set_power_state() will change the device power state
+	 * to D0.
+	 */
+	vfio_pci_runtime_pm_exit(vdev);
+	pm_runtime_resume(&pdev->dev);
+
+	/*
 	 * This function calls __pci_reset_function_locked() which internally
 	 * can use pci_pm_reset() for the function reset. pci_pm_reset() will
 	 * fail if the power state is non-D0. Also, for the devices which
@@ -1224,6 +1323,10 @@ int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
 	switch (flags & VFIO_DEVICE_FEATURE_MASK) {
 	case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
 		return vfio_pci_core_feature_token(device, flags, arg, argsz);
+	case VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY:
+		return vfio_pci_core_pm_entry(device, flags, arg, argsz);
+	case VFIO_DEVICE_FEATURE_LOW_POWER_EXIT:
+		return vfio_pci_core_pm_exit(device, flags, arg, argsz);
 	default:
 		return -ENOTTY;
 	}
@@ -1234,31 +1337,47 @@ static ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			   size_t count, loff_t *ppos, bool iswrite)
 {
 	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	int ret;
 
 	if (index >= VFIO_PCI_NUM_REGIONS + vdev->num_regions)
 		return -EINVAL;
 
+	ret = pm_runtime_resume_and_get(&vdev->pdev->dev);
+	if (ret < 0) {
+		pci_info_ratelimited(vdev->pdev, "runtime resume failed %d\n",
+				     ret);
+		return -EIO;
+	}
+
 	switch (index) {
 	case VFIO_PCI_CONFIG_REGION_INDEX:
-		return vfio_pci_config_rw(vdev, buf, count, ppos, iswrite);
+		ret = vfio_pci_config_rw(vdev, buf, count, ppos, iswrite);
+		break;
 
 	case VFIO_PCI_ROM_REGION_INDEX:
 		if (iswrite)
-			return -EINVAL;
-		return vfio_pci_bar_rw(vdev, buf, count, ppos, false);
+			ret = -EINVAL;
+		else
+			ret = vfio_pci_bar_rw(vdev, buf, count, ppos, false);
+		break;
 
 	case VFIO_PCI_BAR0_REGION_INDEX ... VFIO_PCI_BAR5_REGION_INDEX:
-		return vfio_pci_bar_rw(vdev, buf, count, ppos, iswrite);
+		ret = vfio_pci_bar_rw(vdev, buf, count, ppos, iswrite);
+		break;
 
 	case VFIO_PCI_VGA_REGION_INDEX:
-		return vfio_pci_vga_rw(vdev, buf, count, ppos, iswrite);
+		ret = vfio_pci_vga_rw(vdev, buf, count, ppos, iswrite);
+		break;
+
 	default:
 		index -= VFIO_PCI_NUM_REGIONS;
-		return vdev->region[index].ops->rw(vdev, buf,
+		ret = vdev->region[index].ops->rw(vdev, buf,
 						   count, ppos, iswrite);
+		break;
 	}
 
-	return -EINVAL;
+	pm_runtime_put(&vdev->pdev->dev);
+	return ret;
 }
 
 ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
@@ -1453,7 +1572,11 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
 	mutex_lock(&vdev->vma_lock);
 	down_read(&vdev->memory_lock);
 
-	if (!__vfio_pci_memory_enabled(vdev)) {
+	/*
+	 * Memory region cannot be accessed if the low power feature is engaged
+	 * or memory access is disabled.
+	 */
+	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev)) {
 		ret = VM_FAULT_SIGBUS;
 		goto up_out;
 	}
@@ -2164,6 +2287,15 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 		goto err_unlock;
 	}
 
+	/*
+	 * Some of the devices in the dev_set can be in the runtime suspended
+	 * state. Increment the usage count for all the devices in the dev_set
+	 * before reset and decrement the same after reset.
+	 */
+	ret = vfio_pci_dev_set_pm_runtime_get(dev_set);
+	if (ret)
+		goto err_unlock;
+
 	list_for_each_entry(cur_vma, &dev_set->device_list, vdev.dev_set_list) {
 		/*
 		 * Test whether all the affected devices are contained by the
@@ -2219,6 +2351,9 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 		else
 			mutex_unlock(&cur->vma_lock);
 	}
+
+	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list)
+		pm_runtime_put(&cur->pdev->dev);
 err_unlock:
 	mutex_unlock(&dev_set->lock);
 	return ret;
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index e96cc3081236..7ec81271bd05 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -125,6 +125,7 @@ struct vfio_pci_core_device {
 	bool			nointx;
 	bool			needs_pm_restore;
 	bool			pm_intx_masked;
+	bool			pm_runtime_engaged;
 	struct pci_saved_state	*pci_saved_state;
 	struct pci_saved_state	*pm_save;
 	int			ioeventfds_nr;
-- 
2.17.1

