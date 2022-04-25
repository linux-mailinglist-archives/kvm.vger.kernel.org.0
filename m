Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80FA550DCA0
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 11:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237909AbiDYJbp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 05:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238078AbiDYJaa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 05:30:30 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2070.outbound.protection.outlook.com [40.107.100.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21A8205D7;
        Mon, 25 Apr 2022 02:26:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XDxGpwGzeKjYoTiIULkKsbSxs3086mh8Fn5AD81NYexDajA4miXXjsavdYg1dKgBNeF/pPYtT6TjPqC5cuOBdJX0f0M3OpteWOYd4OOGP2BTTbMB9sEdwhdoI5VdZPzXyoW6yr5Y8hjwMuROvyaiZkkSREFDx+xaiy13R6YEa4055k85m/oIJAzuc9HBdoQs7vibrzmYzgzrKnEwoVGrupH4PmfI6Wg4ljKW6WqWfVSlQPlL9OJrDQT1/VFx43oYNhjoC+VqSm4GYqMVAvdMFNG42PMCpeSBIJonAkJ/NJCyAj9/4fTLJQuUKmNiostvrgG96LbgQ5Vlfr0SoT6QJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HtFV40+9YXfDIIQBOAFSyepWqMunY6MokbyKS6vXFuY=;
 b=kSaJEJrQkZK3rCKpn8+ba/ZQyQd2L8CzWYW2nQ/It9M0btLbWB3ytaQ4JDBScKPeLD+GFvnXM4trzSudWlN+fchUWxudhSYPT6Id1m9PLgmNeK2wDRxFWDj2E3aS7SYu/tRw2rIXH7CMT4up/IjkUcDMPPH0aBm7+62usxNBK4+BiHNHSYJ+c/cGcSuXE57ERhK6nzkb5zmXDGFZrqonYmwwD2iq6gZ82h8MMjPSwgzoT2MEPMB5Qt8SF2vAq+3nucrmqxTBDTWvnf+cpyYR61x3BboRK0UGQeP4ob67TPbAL8T6rXnW1EgDZ1bQodMP4zTbwIMS7n7yQF353RJh0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HtFV40+9YXfDIIQBOAFSyepWqMunY6MokbyKS6vXFuY=;
 b=mBUToX5iDxbp0xgaImARgrQXq19ZY9veQFdTzPqhbkglaq3sQhPeaLjwe+mzqPwSYB5uxzfDPPEdIIy1cbBs2zdERFlzP3QtWQgyurYHWY/aivsLo2jOYmR4MI6hEQ75ZIMsEqk75I01+lp1d/iaHJTbYrqrbV6q5l9G474brAoIQPEmAf0YfetzTkcbN/fjtau4QPi9mwUMXQAxGTjkS6zacazjuIMdRKa7QUXjHgB/7T2ek42u9+qENvwl0Ap8og63bIxZaIk0LxtxqEwRq+EGbZDmHGSPyYRajvHV121Icy5nfRx+3r0wfl04cGeWgp6mLCEp4aN0JH1UHTiTaA==
Received: from DM6PR03CA0083.namprd03.prod.outlook.com (2603:10b6:5:333::16)
 by MN2PR12MB2877.namprd12.prod.outlook.com (2603:10b6:208:ae::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Mon, 25 Apr
 2022 09:26:57 +0000
Received: from DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:333:cafe::26) by DM6PR03CA0083.outlook.office365.com
 (2603:10b6:5:333::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13 via Frontend
 Transport; Mon, 25 Apr 2022 09:26:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT037.mail.protection.outlook.com (10.13.172.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Mon, 25 Apr 2022 09:26:56 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 25 Apr
 2022 09:26:56 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 25 Apr
 2022 02:26:55 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 25 Apr 2022 02:26:50 -0700
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
Subject: [PATCH v3 5/8] vfio/pci: Enable runtime PM for vfio_pci_core based drivers
Date:   Mon, 25 Apr 2022 14:56:12 +0530
Message-ID: <20220425092615.10133-6-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220425092615.10133-1-abhsahu@nvidia.com>
References: <20220425092615.10133-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28326f7c-7642-4f71-89f0-08da269dbe3b
X-MS-TrafficTypeDiagnostic: MN2PR12MB2877:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB287706ECBB423F50473C941CCCF89@MN2PR12MB2877.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2gV/WxwgX/1vZ+iG9Xrhd86dAkKWItwr4aQBx67p7EmYfj/DXNCKGRBHg/TTg4c1oX5MvvvIO9vIZmHB9pz6HDm6LVUzBk8L0V6H5BY7bqwLbSd67hGVyGoH9+7gK6tmJbypHCUKP4IotuWUwb/aETFeyrmHWSzvdVtj5MYUa0KTBW732Ft+wWjfZGGqCtYnwZKv6GqkpDS4jDmObEIwAny2i4K55IgD7pXQbz8bqzhzfDLmLu2BE4qltRBXzvCEVH4UBRPyFzcGmTgJ+pe0D0UqnzYYEfPqpFzXyMshw0TvVyc9IOQ3Z6b26k6Sfw4Z3EeLKeCB+YKmymy6gblqYSxxEhF5Uvr6ueuTriGQfhVUACvyvqja6ADnHTqaefNcbeS+KJDZiQTGoQaY2gSRpoOmBVFiYftQsDToouaVa4GWfKhgjhspmvcdKU3VtL70ZeNeO8KN27PbiRQD31+wJZE36RgKik6dpMLyq7gXlg3kLNY32bCudQGsLEH7L0ifd/mg1EaSoo6PLQUCi2dgAlhyOyts7s27RDfUoxGARHhvrfY5bEB8irJ4dfpWZnlw9BJ/bO8fLp1n92clx3GczIW+lnYBEaUwMuI/XTR9rseHNGH9IFWGed5fTq1DPJ2Y+wVH8WjPe8iVNO1Thgm5CbgCsrj5C2BI7B2sevsZgFIo9/QjAFkk3pbyl/fIAeDZV0BGuK2fSjLxqlTVMiEGbw==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(110136005)(316002)(54906003)(81166007)(26005)(8936002)(5660300002)(30864003)(47076005)(70206006)(70586007)(7696005)(4326008)(356005)(6666004)(508600001)(86362001)(186003)(7416002)(40460700003)(83380400001)(336012)(426003)(8676002)(107886003)(82310400005)(2616005)(36860700001)(36756003)(1076003)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 09:26:56.7921
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 28326f7c-7642-4f71-89f0-08da269dbe3b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2877
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
   For preventing any runtime usage mismatch, pci_num_vf() has been
   called explicitly during disable.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 169 +++++++++++++++++++++----------
 1 file changed, 114 insertions(+), 55 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 953ac33b2f5f..aee5e0cd6137 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -156,7 +156,7 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 }
 
 struct vfio_pci_group_info;
-static bool vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
+static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
 static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 				      struct vfio_pci_group_info *groups);
 
@@ -261,6 +261,19 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
 	return ret;
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
@@ -268,21 +281,23 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
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
@@ -306,12 +321,8 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
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
@@ -332,6 +343,16 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 
 
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
 
@@ -439,8 +460,11 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
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
 
@@ -1879,19 +1903,24 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev,
 
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
@@ -1900,7 +1929,9 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev,
 
 out_power:
 	if (!disable_idle_d3)
-		vfio_pci_set_power_state(vdev, PCI_D0);
+		pm_runtime_get_noresume(dev);
+
+	pm_runtime_forbid(dev);
 out_vf:
 	vfio_pci_vf_uninit(vdev);
 out_drvdata:
@@ -1922,8 +1953,9 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 	vfio_pci_vga_uninit(vdev);
 
 	if (!disable_idle_d3)
-		vfio_pci_set_power_state(vdev, PCI_D0);
+		pm_runtime_get_noresume(dev);
 
+	pm_runtime_forbid(dev);
 	dev_set_drvdata(dev, NULL);
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_unregister_device);
@@ -1984,18 +2016,26 @@ int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 
 		/*
 		 * The PF power state should always be higher than the VF power
-		 * state. If PF is in the low power state, then change the
-		 * power state to D0 first before enabling SR-IOV.
+		 * state. If PF is in the runtime suspended state, then resume
+		 * it first before enabling SR-IOV.
 		 */
-		vfio_pci_set_power_state(vdev, PCI_D0);
-		ret = pci_enable_sriov(pdev, nr_virtfn);
+		ret = pm_runtime_resume_and_get(&pdev->dev);
 		if (ret)
 			goto out_del;
+
+		ret = pci_enable_sriov(pdev, nr_virtfn);
+		if (ret) {
+			pm_runtime_put(&pdev->dev);
+			goto out_del;
+		}
 		ret = nr_virtfn;
 		goto out_put;
 	}
 
-	pci_disable_sriov(pdev);
+	if (pci_num_vf(pdev)) {
+		pci_disable_sriov(pdev);
+		pm_runtime_put(&pdev->dev);
+	}
 
 out_del:
 	mutex_lock(&vfio_pci_sriov_pfs_mutex);
@@ -2072,6 +2112,30 @@ vfio_pci_dev_set_resettable(struct vfio_device_set *dev_set)
 	return pdev;
 }
 
+static int vfio_pci_dev_set_pm_runtime_get(struct vfio_device_set *dev_set)
+{
+	struct vfio_pci_core_device *cur_pm;
+	struct vfio_pci_core_device *cur;
+	int ret = 0;
+
+	list_for_each_entry(cur_pm, &dev_set->device_list, vdev.dev_set_list) {
+		ret = pm_runtime_resume_and_get(&cur_pm->pdev->dev);
+		if (ret < 0)
+			break;
+	}
+
+	if (!ret)
+		return 0;
+
+	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
+		if (cur == cur_pm)
+			break;
+		pm_runtime_put(&cur->pdev->dev);
+	}
+
+	return ret;
+}
+
 /*
  * We need to get memory_lock for each device, but devices can share mmap_lock,
  * therefore we need to zap and hold the vma_lock for each device, and only then
@@ -2178,43 +2242,38 @@ static bool vfio_pci_dev_set_needs_reset(struct vfio_device_set *dev_set)
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

