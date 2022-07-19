Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C77C6579CB9
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 14:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241465AbiGSMmM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 08:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241088AbiGSMkL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 08:40:11 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2042.outbound.protection.outlook.com [40.107.100.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1165A7D1EA;
        Tue, 19 Jul 2022 05:16:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YT4fYvXCdhXGr81K3mNyXQFKFW6lAoGci7JwmHVBThBOLhsNVXjOP4gxu2RX2ELoHM4G5xRPNCWTgg91tCwjO0EYAiryUkI3ECbOHxJo9Oz/bQqKOZstIkVq3wqB09Lp9ERiLKQg2Q5TzgJa4SrHjMks09NrLOVhZtxST80bD8gfEeMSesMyESGmN/vA79VcXrHzCUko8NzetM7YcXaVcMtI6FeQFoWnDFs2OALJHu5faBzQqzZDWd+30zTpzq5hGzdaANpt2XDN6rZpbJfbMUfFe3yousFtwAyAeXXHMk99qDzfNvPHU4RgLD8jv7a6id6dMYmwvno9a7iYhynTyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sUj3qxu9m27AIc6jOuXv8oWnuMFNUnpK1oh7Wdq8gSE=;
 b=kwN7rKGsSs31x6X+PJNNE6Eg8EmDEimv2wNFK1UIOrpI5toE5cLYb1urz2Bqd6k9QlB5pX/8SRokJXZEwsDs3UmeZD1XYWjYk0O88aDzcsqn+5bibD+MNWfL+O+rbsrmOsRyIf6Kl54LcppkTVXSUaXqV65ivXSVLDrrMajIZ7L0OnFUOMdlv6CJ7rH5p8exMiBOwXYWBlQPPYGfKRZNpfR3X6KtzsuLmXL6wdETuxjysQbEZtKSi0LB8Pv9TV9fKkpOfY3AWqXgnm1MoTJxppG2b9tHEz71QT8pIzMBKjvkyzQYEOyuuqtEeXxwu8XpNbG7XGd32mfI9zOuLEzEBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sUj3qxu9m27AIc6jOuXv8oWnuMFNUnpK1oh7Wdq8gSE=;
 b=bGtchpVJzArZ3rakp+E2jsE62dt/SIFh/ltmxtxecuSRQfFgiHVIOwR2ptcjJtTZj95h4m3Y0LbCPQEr6qphxb7ZAHLdRVXI1/O/bFTTTHBRxmaGtYIDPd52pe0rwybuthHTXJK/9dsU+YpvBvthjHDrxhVha4Ji8KEDI53GY0Q7VYd48wPVVcHasPva/8B2XLCZvVwyF1O2GOyDRTS/7pbUDnv0JIf3zpax61iVuW03GgftV+Nn5g9C5lbP3RePpeMZrPnU2ZYuWGFf1cKq5/fv1RllbuszQl0G1vftD/q6npOvVH5V7MrElcpmn1Hkk4AcFEhVzBg6hFqnzzHnLg==
Received: from DS7PR06CA0018.namprd06.prod.outlook.com (2603:10b6:8:2a::9) by
 BY5PR12MB4966.namprd12.prod.outlook.com (2603:10b6:a03:1da::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Tue, 19 Jul
 2022 12:16:07 +0000
Received: from DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2a:cafe::71) by DS7PR06CA0018.outlook.office365.com
 (2603:10b6:8:2a::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12 via Frontend
 Transport; Tue, 19 Jul 2022 12:16:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT060.mail.protection.outlook.com (10.13.173.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Tue, 19 Jul 2022 12:16:07 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 19 Jul 2022 12:16:06 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 19 Jul 2022 05:16:05 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Tue, 19 Jul 2022 05:16:00 -0700
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
Subject: [PATCH v5 5/5] vfio/pci: Implement VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP
Date:   Tue, 19 Jul 2022 17:45:23 +0530
Message-ID: <20220719121523.21396-6-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220719121523.21396-1-abhsahu@nvidia.com>
References: <20220719121523.21396-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57cbd838-601b-4f56-0922-08da69807554
X-MS-TrafficTypeDiagnostic: BY5PR12MB4966:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WfmQxHTvEx8kNKj16NuKjH2orlyCj0WPhf5YWeEfgwHUDOhOXCZYRQTnahH26AzdjgpQ97iNC7iLbMuag340mo3OOSQ3DoARPToli4n2DScKQOG8dPW3s3kWJrKeFmegcml/irBFB1yQaUkQzdsl3YNXfbM2TTAh4LTgi3mpmmtWEmG0huTCtYiOL2oAIq4zI10FPl//8BqbB08q6GfJEfCHqp5kfBUDXTI54vepXgCSdUIbjhBtIBZ10HjfHNq2x+ezvyVfFtFoB2koaZsYK4YaG/sEZVl/zymy3NSX/PyEOuFh9ZsRfDUtTN8G9VCeNHTTJZtnStrmSFFSARuKHf+rvCaQ2MIzfloAZpaBFqx2ja1iFDJuIg6xRKRbyURBlif4yhvX426IrLPgfU9o/rfTRgFNn/b3mrxb2QP9g5z7pcxislSc1qrMQEqwQLDS6u7hgSWBfcwEcz+gr0KG9pV+zWiUorCB8pPw0XkBcoM5/p3oo088jKofL44Rh4clUBser9dTcBcBxkK6PBh5VKKh/xRcr2aCNgpv5+EdBpRrx+5MeGZ9ESQ6Ealh8Cmdf0hvYL5N1dwBUjatqQ+3RlJXkfLeHDVNJ75A1HHaLwEj6wbEHXUY4H9H3PW4mJwhPKJiioReaFNXnQGX+XWnWSHXG2ACftDdNK0aN+elqvmAn10DxGHjSLJCYNs1Bz8qaILhLKQOlo3qI79k161kdv8MO07zv2uCLU4MtZ2gsH/CWlPkQnlU0hBZ/Nj7HEmY0xVsUm+V/qC+FLGq4wUkk5XYXkBw5C5RtSZpGMVa3z6b3diV8/FAP6P0n/E8HFVRJj098I+y9Jut/2DrqzXEwA==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(136003)(396003)(46966006)(36840700001)(40470700004)(8936002)(7416002)(5660300002)(2906002)(356005)(82310400005)(82740400003)(81166007)(26005)(54906003)(316002)(110136005)(2616005)(107886003)(7696005)(478600001)(1076003)(6666004)(70586007)(4326008)(70206006)(8676002)(36860700001)(426003)(47076005)(336012)(186003)(40460700003)(83380400001)(36756003)(41300700001)(40480700001)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 12:16:07.0424
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 57cbd838-601b-4f56-0922-08da69807554
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4966
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implements VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP
device feature. In the VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY, if there is
any access for the VFIO device on the host side, then the device will
be moved out of the low power state without the user's guest driver
involvement. Once the device access has been finished, then the device
will be moved again into low power state. With the low power
entry happened through VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP,
the device will not be moved back into the low power state and
a notification will be sent to the user by triggering wakeup eventfd.

vfio_pci_core_pm_entry() will be called for both the variants of low
power feature entry so add an extra argument for wakeup eventfd context
and store locally in 'struct vfio_pci_core_device'.

For the entry happened without wakeup eventfd, all the exit related
handling will be done by the LOW_POWER_EXIT device feature only.
When the LOW_POWER_EXIT will be called, then the vfio core layer
vfio_device_pm_runtime_get() will increment the usage count and will
resume the device. In the driver runtime_resume callback,
the 'pm_wake_eventfd_ctx' will be NULL so the vfio_pci_runtime_pm_exit()
will return early. Then vfio_pci_core_pm_exit() will again call
vfio_pci_runtime_pm_exit() and now the exit related handling will be done.

For the entry happened with wakeup eventfd, in the driver resume
callback, eventfd will be triggered and all the exit related handling will
be done. When vfio_pci_runtime_pm_exit() will be called by
vfio_pci_core_pm_exit(), then it will return early. But if the user has
disabled the runtime PM on the host side, the device will never go
runtime suspended state and in this case, all the exit related handling
will be done during vfio_pci_core_pm_exit() only. Also, the eventfd will
not be triggered since the device power state has not been changed by the
host driver.

For vfio_pci_core_disable() also, all the exit related handling
needs to be done if user has closed the device after putting into
low power. In this case eventfd will not be triggered since
the device close has been initiated by the user only.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 78 ++++++++++++++++++++++++++++++--
 include/linux/vfio_pci_core.h    |  1 +
 2 files changed, 74 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 726a6f282496..dbe942bcaa67 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -259,7 +259,8 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
 	return ret;
 }
 
-static int vfio_pci_runtime_pm_entry(struct vfio_pci_core_device *vdev)
+static int vfio_pci_runtime_pm_entry(struct vfio_pci_core_device *vdev,
+				     struct eventfd_ctx *efdctx)
 {
 	/*
 	 * The vdev power related flags are protected with 'memory_lock'
@@ -272,6 +273,7 @@ static int vfio_pci_runtime_pm_entry(struct vfio_pci_core_device *vdev)
 	}
 
 	vdev->pm_runtime_engaged = true;
+	vdev->pm_wake_eventfd_ctx = efdctx;
 	pm_runtime_put_noidle(&vdev->pdev->dev);
 	up_write(&vdev->memory_lock);
 
@@ -295,21 +297,67 @@ static int vfio_pci_core_pm_entry(struct vfio_device *device, u32 flags,
 	 * while returning from the ioctl and then the device can go into
 	 * runtime suspended state.
 	 */
-	return vfio_pci_runtime_pm_entry(vdev);
+	return vfio_pci_runtime_pm_entry(vdev, NULL);
 }
 
-static void vfio_pci_runtime_pm_exit(struct vfio_pci_core_device *vdev)
+static int
+vfio_pci_core_pm_entry_with_wakeup(struct vfio_device *device, u32 flags,
+				   void __user *arg, size_t argsz)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(device, struct vfio_pci_core_device, vdev);
+	struct vfio_device_low_power_entry_with_wakeup entry;
+	struct eventfd_ctx *efdctx;
+	int ret;
+
+	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET,
+				 sizeof(entry));
+	if (ret != 1)
+		return ret;
+
+	if (copy_from_user(&entry, arg, sizeof(entry)))
+		return -EFAULT;
+
+	if (entry.wakeup_eventfd < 0)
+		return -EINVAL;
+
+	efdctx = eventfd_ctx_fdget(entry.wakeup_eventfd);
+	if (IS_ERR(efdctx))
+		return PTR_ERR(efdctx);
+
+	ret = vfio_pci_runtime_pm_entry(vdev, efdctx);
+	if (ret)
+		eventfd_ctx_put(efdctx);
+
+	return ret;
+}
+
+static void vfio_pci_runtime_pm_exit(struct vfio_pci_core_device *vdev,
+				     bool resume_callback)
 {
 	/*
 	 * The vdev power related flags are protected with 'memory_lock'
 	 * semaphore.
 	 */
 	down_write(&vdev->memory_lock);
+	if (resume_callback && !vdev->pm_wake_eventfd_ctx) {
+		up_write(&vdev->memory_lock);
+		return;
+	}
+
 	if (vdev->pm_runtime_engaged) {
 		vdev->pm_runtime_engaged = false;
 		pm_runtime_get_noresume(&vdev->pdev->dev);
 	}
 
+	if (vdev->pm_wake_eventfd_ctx) {
+		if (resume_callback)
+			eventfd_signal(vdev->pm_wake_eventfd_ctx, 1);
+
+		eventfd_ctx_put(vdev->pm_wake_eventfd_ctx);
+		vdev->pm_wake_eventfd_ctx = NULL;
+	}
+
 	up_write(&vdev->memory_lock);
 }
 
@@ -329,8 +377,18 @@ static int vfio_pci_core_pm_exit(struct vfio_device *device, u32 flags,
 	 * vfio_pci_runtime_pm_exit() will internally increment the usage
 	 * count corresponding to pm_runtime_put() called during low power
 	 * feature entry.
+	 *
+	 * For the low power entry happened with wakeup eventfd, there will
+	 * be two cases:
+	 *
+	 * 1. The device has gone into runtime suspended state. In this case,
+	 *    the runtime resume by the vfio core layer should already have
+	 *    performed all exit related handling and the
+	 *    vfio_pci_runtime_pm_exit() will return early.
+	 * 2. The device was in runtime active state. In this case, the
+	 *    vfio_pci_runtime_pm_exit() will do all the required handling.
 	 */
-	vfio_pci_runtime_pm_exit(vdev);
+	vfio_pci_runtime_pm_exit(vdev, false);
 	return 0;
 }
 
@@ -370,6 +428,13 @@ static int vfio_pci_core_runtime_resume(struct device *dev)
 	if (vdev->pm_intx_masked)
 		vfio_pci_intx_unmask(vdev);
 
+	/*
+	 * Only for the low power entry happened with wakeup eventfd,
+	 * the vfio_pci_runtime_pm_exit() will perform exit related handling
+	 * and will trigger eventfd. For the other cases, it will return early.
+	 */
+	vfio_pci_runtime_pm_exit(vdev, true);
+
 	return 0;
 }
 #endif /* CONFIG_PM */
@@ -488,7 +553,7 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 	 * the vfio_pci_set_power_state() will change the device power state
 	 * to D0.
 	 */
-	vfio_pci_runtime_pm_exit(vdev);
+	vfio_pci_runtime_pm_exit(vdev, false);
 	pm_runtime_resume(&pdev->dev);
 
 	/*
@@ -1325,6 +1390,9 @@ int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
 		return vfio_pci_core_feature_token(device, flags, arg, argsz);
 	case VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY:
 		return vfio_pci_core_pm_entry(device, flags, arg, argsz);
+	case VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP:
+		return vfio_pci_core_pm_entry_with_wakeup(device, flags,
+							  arg, argsz);
 	case VFIO_DEVICE_FEATURE_LOW_POWER_EXIT:
 		return vfio_pci_core_pm_exit(device, flags, arg, argsz);
 	default:
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 7ec81271bd05..fb25214e85c8 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -131,6 +131,7 @@ struct vfio_pci_core_device {
 	int			ioeventfds_nr;
 	struct eventfd_ctx	*err_trigger;
 	struct eventfd_ctx	*req_trigger;
+	struct eventfd_ctx	*pm_wake_eventfd_ctx;
 	struct list_head	dummy_resources_list;
 	struct mutex		ioeventfds_lock;
 	struct list_head	ioeventfds_list;
-- 
2.17.1

