Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A74E529EBA
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 12:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245597AbiEQKDF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 06:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245556AbiEQKDB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 06:03:01 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2058.outbound.protection.outlook.com [40.107.92.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D8331343;
        Tue, 17 May 2022 03:02:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MlKgMPBYADOyCu2XJEQyAEDdPsro0TB5zmz4OpACAZmBj3Cj0+2jL6OFxzSDi1ygJqnzoxmQu4hPa4S/y2qiIH6lYL6uG+WuI7X2W1XJDzLh+HnXBn7Ntl0mrKX9sK/pAreMoyI+7gvNtVa9W3oRYYHXnOh30NegAJn75xs7BBI+4OwTr/bYTKyGgEbAcOZBoqUlRaNVjRmVTsQQPqufrHcGhVDSAb0rR8a+ikgaJ/4bKQfNE3ayTWAsUaAJDuBBTXWQt073UGsXZgTSm8Djelrlmn0fFbyujiFFHycB42uDjp3Ooaq7TLHp9IbgTl3ijJx8WId7k0XP6GooNgiE8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UzxqugbF7Z3UqrAB5Yl8UAXFcrLwGvNARDZ7fg9dcC0=;
 b=PM3lfi128/KBZElbeus3DK6QmcLdGKqh/38vMnhrvwp316nbFGLwdWyai+OHd1fuU+Q+LzH5bDNgecXo9haUg2udo33wtWXR21IdKDqcrmQOt4KDfhZP80MpSBBdCGjEMwSUrdeH0dGyGUWn477qEgp2BJbfgSQuduvY/vyNYyy42XHntfxYJPzU443dThSDohyEq6XodsVZTxxbl2T6VujbwrFWGBDtfILWdCpaz59FNbu7A/eP1DaN9bDCr8g4VKEeV8RrtnCcjTbHh5t9crkCMxoGjK8+VUMnPY32NVrDUKxPqj+UfCoCzdUSO6BLz8ln4T7e5pUHaWiqmboGuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UzxqugbF7Z3UqrAB5Yl8UAXFcrLwGvNARDZ7fg9dcC0=;
 b=tuifrO3Kf4IKa+B5QcwUIfN67dbv8SiMdMDBVRBV4dvVW88cOvhkFc2jjfhybdu4Aq4ACrhx8Q1woooj+HDfTsyad8f8GlJYCkOlfYt87m9lty0rT1VeOtwC+dYjkCNQhxhWXNTAtE/GzK4HsgYeXmglynvX+cCvh7nofJzyUIdb90Q8pbUJLIgPXr6gCS94rO7lPxfEot2WtbDhdpEZr2uHOF05IJULJ7h40PLJX2kMdXLhzremlzVGpkuuJDxL3KDoYmhbcWtFs0spCDwlGYnckoC5N0DMOKDiUkiXWL8QBMmzOS73/qT7L+EBkX1uHk8ai7omt7XbySd4p6IdVw==
Received: from BN9PR03CA0871.namprd03.prod.outlook.com (2603:10b6:408:13c::6)
 by BY5PR12MB4642.namprd12.prod.outlook.com (2603:10b6:a03:1f6::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Tue, 17 May
 2022 10:02:56 +0000
Received: from BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13c:cafe::79) by BN9PR03CA0871.outlook.office365.com
 (2603:10b6:408:13c::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13 via Frontend
 Transport; Tue, 17 May 2022 10:02:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT062.mail.protection.outlook.com (10.13.177.34) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Tue, 17 May 2022 10:02:56 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 17 May 2022 10:02:55 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 17 May 2022 03:02:55 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Tue, 17 May 2022 03:02:50 -0700
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
Subject: [PATCH v4 4/4] vfio/pci: Move the unused device into low power state with runtime PM
Date:   Tue, 17 May 2022 15:32:19 +0530
Message-ID: <20220517100219.15146-5-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220517100219.15146-1-abhsahu@nvidia.com>
References: <20220517100219.15146-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5cfa318-4374-45a1-4a7b-08da37ec6aa3
X-MS-TrafficTypeDiagnostic: BY5PR12MB4642:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4642550D8FF7ACB9517D5CEDCCCE9@BY5PR12MB4642.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tFu4MuJE4inOVwwuBGkLVDvcBjSztiqru+Nsr9raG3MRcvAukNJGqwdNJaeVzO2vQ4ZQRfNDKeAsaxPBtuvlC5Kn2d/gJ/ghFq54Z/06vP+EpSw/oy5DnTtFbrd8dscBU+zKSixaL7eCcISJfRN08LkFhVOp+0HbmMKFmnpejLDXoi3rx2I+aL+dnno/C9k+LaP/OjT+OGKoeEICmJsnICeRqhWytAsz1bUki7/zhiYWLPERDw7EDZM0YK3GpgYA/4qGpBYKoBfh+3q7jTOEFlFPse+Y96JtLiOmLdmyH6J7LmTfu028k8Vyheg7UyNvkGbOHBwaiYbI6Lz+v5Bv0cpjWPnBmSvHbLS4eiaXk5NRuztjPRpq0sWlepzaO8O0QFLxk7FHFmTIZpE3gceJtkdNhfEgWQWC93hdth8x3yKLwGzk+DrrRb9JfRKGBYiLkFaTYRKNtnMrYHURrGxCm27B03KQg8cWPbwTZxOd49zYj1Crvy+u0t9HWRU+vV7ZP7Tr1G/JlJMkQHFzG79QARmM0eih5sPeXY5g9+dodNEo/KHV9zuXwUioaagfOpm1BiLx2WncHSryr21hAnEcmDX5YqKmOALLr7MFxpCVEDGcSz1uqnBBqA8FrZoX19EloEo+4150GlmXQ0Z5HQCEVDZyoyXXhfdq2BMwFZl3nZHUVtO5yRPJbE1lU5Vpnk2h7AT+8p1+5ecUxZdpVUQliQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(107886003)(4326008)(2616005)(81166007)(8676002)(5660300002)(426003)(186003)(82310400005)(336012)(70206006)(70586007)(1076003)(2906002)(36756003)(40460700003)(7696005)(508600001)(86362001)(316002)(7416002)(356005)(54906003)(36860700001)(47076005)(110136005)(83380400001)(30864003)(6666004)(8936002)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 10:02:56.4742
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f5cfa318-4374-45a1-4a7b-08da37ec6aa3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4642
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, there is very limited power management support
available in the upstream vfio_pci_core based drivers. If there
are no users of the device, then the PCI device will be moved into
D3hot state by writing directly into PCI PM registers. This D3hot
state help in saving power but we can achieve zero power consumption
if we go into the D3cold state. The D3cold state cannot be possible
with native PCI PM. It requires interaction with platform firmware
which is system-specific. To go into low power states (including D3cold),
the runtime PM framework can be used which internally interacts with PCI
and platform firmware and puts the device into the lowest possible
D-States.

This patch registers vfio_pci_core based drivers with the
runtime PM framework.

1. The PCI core framework takes care of most of the runtime PM
   related things. For enabling the runtime PM, the PCI driver needs to
   decrement the usage count and needs to provide 'struct dev_pm_ops'
   at least. The runtime suspend/resume callbacks are optional and needed
   only if we need to do any extra handling. Now there are multiple
   vfio_pci_core based drivers. Instead of assigning the
   'struct dev_pm_ops' in individual parent driver, the vfio_pci_core
   itself assigns the 'struct dev_pm_ops'. There are other drivers where
   the 'struct dev_pm_ops' is being assigned inside core layer
   (For example, wlcore_probe() and some sound based driver, etc.).

2. This patch provides the stub implementation of 'struct dev_pm_ops'.
   The subsequent patch will provide the runtime suspend/resume
   callbacks. All the config state saving, and PCI power management
   related things will be done by PCI core framework itself inside its
   runtime suspend/resume callbacks (pci_pm_runtime_suspend() and
   pci_pm_runtime_resume()).

3. Inside pci_reset_bus(), all the devices in dev_set needs to be
   runtime resumed. vfio_pci_dev_set_pm_runtime_get() will take
   care of the runtime resume and its error handling.

4. Inside vfio_pci_core_disable(), the device usage count always needs
   to be decremented which was incremented in vfio_pci_core_enable().

5. Since the runtime PM framework will provide the same functionality,
   so directly writing into PCI PM config register can be replaced with
   the use of runtime PM routines. Also, the use of runtime PM can help
   us in more power saving.

   In the systems which do not support D3cold,

   With the existing implementation:

   // PCI device
   # cat /sys/bus/pci/devices/0000\:01\:00.0/power_state
   D3hot
   // upstream bridge
   # cat /sys/bus/pci/devices/0000\:00\:01.0/power_state
   D0

   With runtime PM:

   // PCI device
   # cat /sys/bus/pci/devices/0000\:01\:00.0/power_state
   D3hot
   // upstream bridge
   # cat /sys/bus/pci/devices/0000\:00\:01.0/power_state
   D3hot

   So, with runtime PM, the upstream bridge or root port will also go
   into lower power state which is not possible with existing
   implementation.

   In the systems which support D3cold,

   // PCI device
   # cat /sys/bus/pci/devices/0000\:01\:00.0/power_state
   D3hot
   // upstream bridge
   # cat /sys/bus/pci/devices/0000\:00\:01.0/power_state
   D0

   With runtime PM:

   // PCI device
   # cat /sys/bus/pci/devices/0000\:01\:00.0/power_state
   D3cold
   // upstream bridge
   # cat /sys/bus/pci/devices/0000\:00\:01.0/power_state
   D3cold

   So, with runtime PM, both the PCI device and upstream bridge will
   go into D3cold state.

6. If 'disable_idle_d3' module parameter is set, then also the runtime
   PM will be enabled, but in this case, the usage count should not be
   decremented.

7. vfio_pci_dev_set_try_reset() return value is unused now, so this
   function return type can be changed to void.

8. Use the runtime PM API's in vfio_pci_core_sriov_configure().
   The device can be in low power state either with runtime
   power management (when there is no user) or PCI_PM_CTRL register
   write by the user. In both the cases, the PF should be moved to
   D0 state. For preventing any runtime usage mismatch, pci_num_vf()
   has been called explicitly during disable.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 172 +++++++++++++++++++++----------
 1 file changed, 117 insertions(+), 55 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 4fe9a4efc751..5ea1b3099036 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -156,7 +156,7 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 }
 
 struct vfio_pci_group_info;
-static bool vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
+static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
 static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 				      struct vfio_pci_group_info *groups);
 
@@ -275,6 +275,19 @@ void vfio_pci_lock_and_set_power_state(struct vfio_pci_core_device *vdev,
 	up_write(&vdev->memory_lock);
 }
 
+#ifdef CONFIG_PM
+/*
+ * The dev_pm_ops needs to be provided to make pci-driver runtime PM working,
+ * so use structure without any callbacks.
+ *
+ * The pci-driver core runtime PM routines always save the device state
+ * before going into suspended state. If the device is going into low power
+ * state with only with runtime PM ops, then no explicit handling is needed
+ * for the devices which have NoSoftRst-.
+ */
+static const struct dev_pm_ops vfio_pci_core_pm_ops = { };
+#endif
+
 int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
@@ -282,21 +295,23 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 	u16 cmd;
 	u8 msix_pos;
 
-	vfio_pci_set_power_state(vdev, PCI_D0);
+	if (!disable_idle_d3) {
+		ret = pm_runtime_resume_and_get(&pdev->dev);
+		if (ret < 0)
+			return ret;
+	}
 
 	/* Don't allow our initial saved state to include busmaster */
 	pci_clear_master(pdev);
 
 	ret = pci_enable_device(pdev);
 	if (ret)
-		return ret;
+		goto out_power;
 
 	/* If reset fails because of the device lock, fail this path entirely */
 	ret = pci_try_reset_function(pdev);
-	if (ret == -EAGAIN) {
-		pci_disable_device(pdev);
-		return ret;
-	}
+	if (ret == -EAGAIN)
+		goto out_disable_device;
 
 	vdev->reset_works = !ret;
 	pci_save_state(pdev);
@@ -320,12 +335,8 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 	}
 
 	ret = vfio_config_init(vdev);
-	if (ret) {
-		kfree(vdev->pci_saved_state);
-		vdev->pci_saved_state = NULL;
-		pci_disable_device(pdev);
-		return ret;
-	}
+	if (ret)
+		goto out_free_state;
 
 	msix_pos = pdev->msix_cap;
 	if (msix_pos) {
@@ -346,6 +357,16 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 
 
 	return 0;
+
+out_free_state:
+	kfree(vdev->pci_saved_state);
+	vdev->pci_saved_state = NULL;
+out_disable_device:
+	pci_disable_device(pdev);
+out_power:
+	if (!disable_idle_d3)
+		pm_runtime_put(&pdev->dev);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_enable);
 
@@ -453,8 +474,11 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 out:
 	pci_disable_device(pdev);
 
-	if (!vfio_pci_dev_set_try_reset(vdev->vdev.dev_set) && !disable_idle_d3)
-		vfio_pci_set_power_state(vdev, PCI_D3hot);
+	vfio_pci_dev_set_try_reset(vdev->vdev.dev_set);
+
+	/* Put the pm-runtime usage counter acquired during enable */
+	if (!disable_idle_d3)
+		pm_runtime_put(&pdev->dev);
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_disable);
 
@@ -1839,10 +1863,11 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_uninit_device);
 int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
+	struct device *dev = &pdev->dev;
 	int ret;
 
 	/* Drivers must set the vfio_pci_core_device to their drvdata */
-	if (WARN_ON(vdev != dev_get_drvdata(&vdev->pdev->dev)))
+	if (WARN_ON(vdev != dev_get_drvdata(dev)))
 		return -EINVAL;
 
 	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
@@ -1884,19 +1909,24 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 
 	vfio_pci_probe_power_state(vdev);
 
-	if (!disable_idle_d3) {
-		/*
-		 * pci-core sets the device power state to an unknown value at
-		 * bootup and after being removed from a driver.  The only
-		 * transition it allows from this unknown state is to D0, which
-		 * typically happens when a driver calls pci_enable_device().
-		 * We're not ready to enable the device yet, but we do want to
-		 * be able to get to D3.  Therefore first do a D0 transition
-		 * before going to D3.
-		 */
-		vfio_pci_set_power_state(vdev, PCI_D0);
-		vfio_pci_set_power_state(vdev, PCI_D3hot);
-	}
+	/*
+	 * pci-core sets the device power state to an unknown value at
+	 * bootup and after being removed from a driver.  The only
+	 * transition it allows from this unknown state is to D0, which
+	 * typically happens when a driver calls pci_enable_device().
+	 * We're not ready to enable the device yet, but we do want to
+	 * be able to get to D3.  Therefore first do a D0 transition
+	 * before enabling runtime PM.
+	 */
+	vfio_pci_set_power_state(vdev, PCI_D0);
+
+#if defined(CONFIG_PM)
+	dev->driver->pm = &vfio_pci_core_pm_ops,
+#endif
+
+	pm_runtime_allow(dev);
+	if (!disable_idle_d3)
+		pm_runtime_put(dev);
 
 	ret = vfio_register_group_dev(&vdev->vdev);
 	if (ret)
@@ -1905,7 +1935,9 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 
 out_power:
 	if (!disable_idle_d3)
-		vfio_pci_set_power_state(vdev, PCI_D0);
+		pm_runtime_get_noresume(dev);
+
+	pm_runtime_forbid(dev);
 out_vf:
 	vfio_pci_vf_uninit(vdev);
 	return ret;
@@ -1922,7 +1954,9 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 	vfio_pci_vga_uninit(vdev);
 
 	if (!disable_idle_d3)
-		vfio_pci_set_power_state(vdev, PCI_D0);
+		pm_runtime_get_noresume(&vdev->pdev->dev);
+
+	pm_runtime_forbid(&vdev->pdev->dev);
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_unregister_device);
 
@@ -1967,17 +2001,29 @@ int vfio_pci_core_sriov_configure(struct vfio_pci_core_device *vdev,
 
 		/*
 		 * The PF power state should always be higher than the VF power
-		 * state. If PF is in the low power state, then change the
-		 * power state to D0 first before enabling SR-IOV.
+		 * state. The PF can be in low power state either with runtime
+		 * power management (when there is no user) or PCI_PM_CTRL
+		 * register write by the user. If PF is in the low power state,
+		 * then change the power state to D0 first before enabling
+		 * SR-IOV.
 		 */
+		ret = pm_runtime_resume_and_get(&pdev->dev);
+		if (ret)
+			goto out_del;
+
 		vfio_pci_lock_and_set_power_state(vdev, PCI_D0);
 		ret = pci_enable_sriov(pdev, nr_virtfn);
-		if (ret)
+		if (ret) {
+			pm_runtime_put(&pdev->dev);
 			goto out_del;
+		}
 		return nr_virtfn;
 	}
 
-	pci_disable_sriov(pdev);
+	if (pci_num_vf(pdev)) {
+		pci_disable_sriov(pdev);
+		pm_runtime_put(&pdev->dev);
+	}
 
 out_del:
 	mutex_lock(&vfio_pci_sriov_pfs_mutex);
@@ -2052,6 +2098,27 @@ vfio_pci_dev_set_resettable(struct vfio_device_set *dev_set)
 	return pdev;
 }
 
+static int vfio_pci_dev_set_pm_runtime_get(struct vfio_device_set *dev_set)
+{
+	struct vfio_pci_core_device *cur;
+	int ret;
+
+	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
+		ret = pm_runtime_resume_and_get(&cur->pdev->dev);
+		if (ret)
+			goto unwind;
+	}
+
+	return 0;
+
+unwind:
+	list_for_each_entry_continue_reverse(cur, &dev_set->device_list,
+					     vdev.dev_set_list)
+		pm_runtime_put(&cur->pdev->dev);
+
+	return ret;
+}
+
 /*
  * We need to get memory_lock for each device, but devices can share mmap_lock,
  * therefore we need to zap and hold the vma_lock for each device, and only then
@@ -2158,43 +2225,38 @@ static bool vfio_pci_dev_set_needs_reset(struct vfio_device_set *dev_set)
  *  - At least one of the affected devices is marked dirty via
  *    needs_reset (such as by lack of FLR support)
  * Then attempt to perform that bus or slot reset.
- * Returns true if the dev_set was reset.
  */
-static bool vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set)
+static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set)
 {
 	struct vfio_pci_core_device *cur;
 	struct pci_dev *pdev;
-	int ret;
+	bool reset_done = false;
 
 	if (!vfio_pci_dev_set_needs_reset(dev_set))
-		return false;
+		return;
 
 	pdev = vfio_pci_dev_set_resettable(dev_set);
 	if (!pdev)
-		return false;
+		return;
 
 	/*
-	 * The pci_reset_bus() will reset all the devices in the bus.
-	 * The power state can be non-D0 for some of the devices in the bus.
-	 * For these devices, the pci_reset_bus() will internally set
-	 * the power state to D0 without vfio driver involvement.
-	 * For the devices which have NoSoftRst-, the reset function can
-	 * cause the PCI config space reset without restoring the original
-	 * state (saved locally in 'vdev->pm_save').
+	 * Some of the devices in the bus can be in the runtime suspended
+	 * state. Increment the usage count for all the devices in the dev_set
+	 * before reset and decrement the same after reset.
 	 */
-	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list)
-		vfio_pci_set_power_state(cur, PCI_D0);
+	if (!disable_idle_d3 && vfio_pci_dev_set_pm_runtime_get(dev_set))
+		return;
 
-	ret = pci_reset_bus(pdev);
-	if (ret)
-		return false;
+	if (!pci_reset_bus(pdev))
+		reset_done = true;
 
 	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
-		cur->needs_reset = false;
+		if (reset_done)
+			cur->needs_reset = false;
+
 		if (!disable_idle_d3)
-			vfio_pci_set_power_state(cur, PCI_D3hot);
+			pm_runtime_put(&cur->pdev->dev);
 	}
-	return true;
 }
 
 void vfio_pci_core_set_params(bool is_nointxmask, bool is_disable_vga,
-- 
2.17.1

