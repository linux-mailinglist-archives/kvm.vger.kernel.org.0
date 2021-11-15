Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB6BD4505A8
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 14:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbhKONkY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 08:40:24 -0500
Received: from mail-bn7nam10on2062.outbound.protection.outlook.com ([40.107.92.62]:56320
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230038AbhKONjv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 08:39:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UmyFt0VtnPfMK12z20KLkLfRpCqgGc3Iuv5v/NM0cn5ed7158MwkEGboMN4mEOJ39nHKhX8Onimt/dNMdBGAkgSAcmXiHfLa4OqSYZmngszRyZ7KHi1zGBXBlhHs3n+uaeeX9Qdvr0g0m21fBkGV+bE92IG92tBGBHTisOPm77Ru5WffF2SoPSreudRtdrudMtKzH26RPW8V9nf80p/ej4GR+karV8g6MTP7xLkpv/b86snxixuYFwmhG2pJ8M5bwqZzsZ3B+kKoD0x8iDIVcNgj+jfP3iehwnWPwf15lfIZcL/P1omEmSXoYwhvuNWBGKnBVvVEr0mJV5TUJoqcGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+5HftWU/CvIfhFRgKud1LEl/kg1IPKGNx0gNaaTEXJU=;
 b=OMmpX4c3+wYorCVN/fiFhcIrofOeYVdjibLY5o+WQ4M84TTZ7dSTxI7p4Z8zhSpNzmvsfLxElFB+6xyB/YDqqi3sbYyP9r90/vn2S3b2YK5255g4M35n6ijAZpIQ0YtOhkKscZLCwpvrzqlstII6EcDnWZBodCazJnJXylOe7ELlA2B6giaHIb+RQxtLuhE31CBbxcaqu4qMngplIsHEarygdiGa91h/fq6yWP+ByrxCGPSganq53QUkjV/pdXoglF6Wecm52s0zvrB/fC8tZetlwpjrWW/KTpIWJyr8gB3oOYyyCw1TNf506CDT24FAY9AWOka32Bv+lR0Xn6zScg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+5HftWU/CvIfhFRgKud1LEl/kg1IPKGNx0gNaaTEXJU=;
 b=no0J9r0QHKckrCbZH9rSJojOeMFW6mOEBTRljln5L9ksYss5IZ4AUWaPyYpeT5NdvZ9pstIJvaNxOyNrRJGqD+eyCrSpDwxp37ip4Yk2Y/2IaE+HvfNY/lUtgqZ6J8ksLdeSeXG1xR6fZ3s1fpDfiB5+eUr8Z64S8P+Vu2Rkx1aTL6C1tv9+JBq+gRzgSK21hk+SaJWnsnv4TbOh2U4R32klPfP3pBaXqCpN+8NVJGUWkaarnzrXvYM4W7DfnUySvIfnh9heu8aIGM7uwK2ZrXzcWoKyY2d3Tc1iwtezhrICraAhEW4zqZy1C9PkYeXV0axllkzIW7oh71qtZuDjLA==
Received: from MW4P223CA0010.NAMP223.PROD.OUTLOOK.COM (2603:10b6:303:80::15)
 by BYAPR12MB2727.namprd12.prod.outlook.com (2603:10b6:a03:71::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Mon, 15 Nov
 2021 13:36:52 +0000
Received: from CO1NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:80:cafe::ec) by MW4P223CA0010.outlook.office365.com
 (2603:10b6:303:80::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend
 Transport; Mon, 15 Nov 2021 13:36:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT048.mail.protection.outlook.com (10.13.175.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4690.15 via Frontend Transport; Mon, 15 Nov 2021 13:36:52 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 15 Nov
 2021 13:36:52 +0000
Received: from nvidia-Inspiron-15-7510.nvidia.com (172.20.187.5) by
 mail.nvidia.com (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.18
 via Frontend Transport; Mon, 15 Nov 2021 13:36:47 +0000
From:   <abhsahu@nvidia.com>
To:     <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Abhishek Sahu <abhsahu@nvidia.com>
Subject: [RFC 1/3] vfio/pci: register vfio-pci driver with runtime PM framework
Date:   Mon, 15 Nov 2021 19:06:38 +0530
Message-ID: <20211115133640.2231-2-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211115133640.2231-1-abhsahu@nvidia.com>
References: <20211115133640.2231-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e00d750-099f-4b65-8be7-08d9a83cfbd6
X-MS-TrafficTypeDiagnostic: BYAPR12MB2727:
X-Microsoft-Antispam-PRVS: <BYAPR12MB272731299C4FB628AEB386BCCC989@BYAPR12MB2727.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gC8V+vCuCKIBPPX4wLRsjBUNN6X7No0+OKxp0ON1YMvmsUslkBdKIuud/Z/DINVMBqDyclYSzGDJeL3HBjI0JG7ymnnBZc6g2kFY31BaTMgDt3FegsyiUvVxR8dDMT+UvKfM6b06/yicmN/AwIMNQMzpstMIbznnt8FMcOgEPPKVn+2mqV8EHLEf5bVpYn0JKvJHI23Af8ZQAncrymbzrvWfHdqfEDRDblj/XyPKwaaVBOK9X85OPak834PU/+MW+OU2ibimMa4YmhVsK1UrKyPKPnDLG+iKPGezZpJOsvnYc43JuoXOoVZvtfynnjkZhHWw7DrWFLg6XXBKB39PxHJDXkk5y9BPPmTSUWcRM0Dpa8DA7OKldmNFIcewVNfSpqXg78s/g2irq0isJfoK6BU45G32jC6IYHMlFJtK8+exlXHvzc83WeSeDkOAVLNkA0wwVmOsuuuzIHLbrbD9KqHOpxDPY3enUWbhInNvgAoYteRZN0CJse4i9KK1JuHtOgLWFRdPoOyugazkX6H+XVMk6c72hOOQZ5nfTD2+MptAP21P9+vREtflfgTq3znbFhdr+vBNlts+flwAL0NW2VMDFQ0OtIViRW3Nq693SpMAgF/d/G+QgoAIuMBb555g7jsYz2FoMl3UyP8tOqc0Qoh1Q9fWHx1JMQecdaqp9tgCiuTIXAU9+1IHdQSheRigeUwLKHB1QoqGtR3xqv0WDg==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(2616005)(86362001)(6666004)(5660300002)(2906002)(70586007)(110136005)(7696005)(54906003)(186003)(70206006)(83380400001)(508600001)(2876002)(47076005)(36906005)(30864003)(7636003)(426003)(8676002)(26005)(8936002)(316002)(356005)(336012)(82310400003)(107886003)(36756003)(1076003)(4326008)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 13:36:52.4992
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e00d750-099f-4b65-8be7-08d9a83cfbd6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2727
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Abhishek Sahu <abhsahu@nvidia.com>

Currently, there is very limited power management support
available in upstream vfio-pci driver. If there is no user of vfio-pci
device, then the PCI device will be moved into D3Hot state by writing
directly into PCI PM registers. This D3Hot state help in saving some
amount of power but we can achieve zero power consumption if we go
into D3cold state. The D3cold state cannot be possible with Native PCI
PM. It requires interaction with platform firmware which is
system-specific. To go into low power states (including D3cold), the
runtime PM framework can be used which internally interacts with PCI
and platform firmware and puts the device into the lowest possible
D-States.

This patch registers vfio-pci driver with the runtime PM framework.

1. The PCI core framework takes care of most of the runtime PM
   related things. For enabling the runtime PM, the PCI driver needs to
   decrement the usage count and needs to register the runtime
   suspend/resume routines. For vfio-pci based driver, these routines can
   be stubbed since the vfio-pci driver is not doing the PCI device
   initialization. All the config state saving, and PCI power management
   related things will be done by PCI core framework itself inside its
   runtime suspend/resume callbacks.

2. To prevent frequent runtime, suspend/resume, it uses autosuspend
   support with a default delay of 1 second.

3. Inside pci_reset_bus(), all the devices in bus/slot will be moved
   out of D0 state. This state change to D0 can happen directly without
   going through the runtime PM framework. So if runtime PM is enabled,
   then pm_runtime_resume() makes the runtime state active. Since the PCI
   device power state is already D0, so it should return early when it
   tries to change the state with  pci_set_power_state(). Then
   pm_request_autosuspend() can be used which will internally check for
   device usage count and will move the device again into low power
   state.

4. Inside vfio_pci_core_disable(), the device usage count always needs
   to decremented which was incremented vfio_pci_core_enable() with
   pm_runtime_get_sync().

5. Since the runtime PM framework will provide the same functionality,
   so directly writing into PCI PM config register can be replaced with
   use of runtime PM routines. Also, the use of runtime PM can help us in
   more power saving.

   In the systems which do not support D3Cold,

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

   In the systems which support D3Cold,

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

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/pci/vfio_pci.c      |   3 +
 drivers/vfio/pci/vfio_pci_core.c | 104 +++++++++++++++++++++++--------
 include/linux/vfio_pci_core.h    |   4 ++
 3 files changed, 84 insertions(+), 27 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index a5ce92beb655..c8695baf3b54 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -193,6 +193,9 @@ static struct pci_driver vfio_pci_driver = {
 	.remove			= vfio_pci_remove,
 	.sriov_configure	= vfio_pci_sriov_configure,
 	.err_handler		= &vfio_pci_core_err_handlers,
+#if defined(CONFIG_PM)
+	.driver.pm              = &vfio_pci_core_pm_ops,
+#endif
 };
 
 static void __init vfio_pci_fill_ids(void)
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index f948e6cd2993..511a52e92b32 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -152,7 +152,7 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 }
 
 struct vfio_pci_group_info;
-static bool vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
+static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
 static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 				      struct vfio_pci_group_info *groups);
 
@@ -245,7 +245,8 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 	u16 cmd;
 	u8 msix_pos;
 
-	vfio_pci_set_power_state(vdev, PCI_D0);
+	if (!disable_idle_d3)
+		pm_runtime_get_sync(&pdev->dev);
 
 	/* Don't allow our initial saved state to include busmaster */
 	pci_clear_master(pdev);
@@ -405,8 +406,17 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 out:
 	pci_disable_device(pdev);
 
-	if (!vfio_pci_dev_set_try_reset(vdev->vdev.dev_set) && !disable_idle_d3)
-		vfio_pci_set_power_state(vdev, PCI_D3hot);
+	vfio_pci_dev_set_try_reset(vdev->vdev.dev_set);
+
+	/*
+	 * The device usage count always needs to decremented which was
+	 * incremented in vfio_pci_core_enable() with
+	 * pm_runtime_get_sync().
+	 */
+	if (!disable_idle_d3) {
+		pm_runtime_mark_last_busy(&pdev->dev);
+		pm_runtime_put_autosuspend(&pdev->dev);
+	}
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_disable);
 
@@ -1847,19 +1857,23 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 
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
+	pci_set_power_state(pdev, PCI_D0);
+	pm_runtime_set_autosuspend_delay(&pdev->dev, 1000);
+	pm_runtime_use_autosuspend(&pdev->dev);
+	pm_runtime_mark_last_busy(&pdev->dev);
+	pm_runtime_allow(&pdev->dev);
+
+	if (!disable_idle_d3)
+		pm_runtime_put_autosuspend(&pdev->dev);
 
 	ret = vfio_register_group_dev(&vdev->vdev);
 	if (ret)
@@ -1868,7 +1882,10 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 
 out_power:
 	if (!disable_idle_d3)
-		vfio_pci_set_power_state(vdev, PCI_D0);
+		pm_runtime_get_noresume(&pdev->dev);
+
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
+	pm_runtime_forbid(&pdev->dev);
 out_vf:
 	vfio_pci_vf_uninit(vdev);
 	return ret;
@@ -1887,7 +1904,10 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 	vfio_pci_vga_uninit(vdev);
 
 	if (!disable_idle_d3)
-		vfio_pci_set_power_state(vdev, PCI_D0);
+		pm_runtime_get_noresume(&pdev->dev);
+
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
+	pm_runtime_forbid(&pdev->dev);
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_unregister_device);
 
@@ -2093,33 +2113,63 @@ static bool vfio_pci_dev_set_needs_reset(struct vfio_device_set *dev_set)
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
 	int ret;
 
 	if (!vfio_pci_dev_set_needs_reset(dev_set))
-		return false;
+		return;
 
 	pdev = vfio_pci_dev_set_resettable(dev_set);
 	if (!pdev)
-		return false;
+		return;
 
 	ret = pci_reset_bus(pdev);
 	if (ret)
-		return false;
+		return;
 
 	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
 		cur->needs_reset = false;
-		if (!disable_idle_d3)
-			vfio_pci_set_power_state(cur, PCI_D3hot);
+		if (!disable_idle_d3) {
+			/*
+			 * Inside pci_reset_bus(), all the devices in bus/slot
+			 * will be moved out of D0 state. This state change to
+			 * D0 can happen directly without going through the
+			 * runtime PM framework. pm_runtime_resume() will
+			 * help make the runtime state as active and then
+			 * pm_request_autosuspend() can be used which will
+			 * internally check for device usage count and will
+			 * move the device again into the low power state.
+			 */
+			pm_runtime_resume(&pdev->dev);
+			pm_runtime_mark_last_busy(&pdev->dev);
+			pm_request_autosuspend(&pdev->dev);
+		}
 	}
-	return true;
 }
 
+#ifdef CONFIG_PM
+static int vfio_pci_core_runtime_suspend(struct device *dev)
+{
+	return 0;
+}
+
+static int vfio_pci_core_runtime_resume(struct device *dev)
+{
+	return 0;
+}
+
+const struct dev_pm_ops vfio_pci_core_pm_ops = {
+	SET_RUNTIME_PM_OPS(vfio_pci_core_runtime_suspend,
+			   vfio_pci_core_runtime_resume,
+			   NULL)
+};
+EXPORT_SYMBOL_GPL(vfio_pci_core_pm_ops);
+#endif
+
 void vfio_pci_core_set_params(bool is_nointxmask, bool is_disable_vga,
 			      bool is_disable_idle_d3)
 {
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index ef9a44b6cf5d..aafe09c9fa64 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -231,6 +231,10 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_disable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
 
+#ifdef CONFIG_PM
+extern const struct dev_pm_ops vfio_pci_core_pm_ops;
+#endif
+
 static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
 {
 	return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;
-- 
2.17.1

