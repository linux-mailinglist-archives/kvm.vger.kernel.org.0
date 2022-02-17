Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F53F4BA001
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 13:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240365AbiBQMWO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 07:22:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240372AbiBQMWL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 07:22:11 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2070.outbound.protection.outlook.com [40.107.237.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1451A1D9657;
        Thu, 17 Feb 2022 04:21:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QvwFSf4L6NylwrLhBw7YS39Ga2n+08qq4G5UNHLhAOML5R+W0PzLdBwcl4/8Z5RVEXD3o+ttL7Mzyb83iInY6/mB20MKIt+bt8fBB3ZmXi0IUMtFZy71b8PkuCUxqCvt7vJkEektI3c6AzqGj+82XIkX/4YUlgSlLJmKZGQxKMoOHNt7/xSUzCvDUX74047rK2BSCAZhZIfrawgmaL4tlHBia6EM7p4863rgj0ZgWc7soVkRTDpKvRF9dy3p+Dqb1N+DG/GlxY8W7UdEBPjtICRStmFpHi2a40Iqq1/mzCzXkXAALRAy4IHq1v5TQu5wtXUvMZeTqnz8oSu+oY4GpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zbul8SlZoyULh/7AZW6F4+X/7Sr4ZclfduAXJB1lLt4=;
 b=VmvuIG5cySYyDghpmNTpR7lAQHUxEbp9SCeqRzQ2STAR7y4FesaR/7n6+/FjHtwhppREfh0ZoHXkYWrkKvYNFrT4kJHX99hny2v6h/KCKA6Aqwi+yNnu0RtiJTBS2KzG+mGrRGduEkBygbHMxO5MVhmn3hdVAQ7eC8sAEpYwalLfWG53d83/fiaaZ22gYjr/Pvy1xxhAhywG70EJ2hbRpC3UJ871snVgNxDgDJeiU8eZKk2rPhkJRUrUs7h7rGxOFI0DLNf4rNCepsYm62kT+9MFO6w7qqD9GOBVwweIuCV/BmnJ3Lkm2bNtVga/zmYceG9Fe1CDv+QLMYyZAXnaDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zbul8SlZoyULh/7AZW6F4+X/7Sr4ZclfduAXJB1lLt4=;
 b=T/VmiBqj+pJC1J0cXvL6G03tL0SCiox9lwLKfFdvgPF4ClH6xfe5OxuRCXiO+mCb9jKgBMds9q4qCuISgN4wHYPqXCm7AUfJs1SkOAFEa0PcDc9kn56wAzU5yNCN+Ad45iYXLpCXCtPyZpqWR1w3CWUKl4Zrljt6CM0nOdkNzAqZN3VM66oFMLZEAXQgnZrp3apLafGw2W4QQq3CJKrZ37h0oT1MDIjzYwht3lIVi071t0QJRNbufj7m1SBZngAj5Y+Sr+pacTwX6eR+aNoVEql1J/TTpTxlKfrNelR4cOMxiTvD0S/lLWQQrgEKRmt9XsNCleRU0/1DZDTPTJaL6A==
Received: from DS7PR03CA0085.namprd03.prod.outlook.com (2603:10b6:5:3bb::30)
 by DM6PR12MB3916.namprd12.prod.outlook.com (2603:10b6:5:1ca::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Thu, 17 Feb
 2022 12:21:53 +0000
Received: from DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3bb:cafe::e) by DS7PR03CA0085.outlook.office365.com
 (2603:10b6:5:3bb::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16 via Frontend
 Transport; Thu, 17 Feb 2022 12:21:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT036.mail.protection.outlook.com (10.13.172.64) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Thu, 17 Feb 2022 12:21:53 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 17 Feb
 2022 12:21:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 17 Feb 2022
 04:21:33 -0800
Received: from nvidia-Inspiron-15-7510.nvidia.com (10.127.8.9) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.9 via
 Frontend Transport; Thu, 17 Feb 2022 04:21:29 -0800
From:   Abhishek Sahu <abhsahu@nvidia.com>
To:     <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Abhishek Sahu <abhsahu@nvidia.com>
Subject: [PATCH v3 2/2] vfio/pci: wake-up devices around reset functions
Date:   Thu, 17 Feb 2022 17:51:07 +0530
Message-ID: <20220217122107.22434-3-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220217122107.22434-1-abhsahu@nvidia.com>
References: <20220217122107.22434-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac969d76-57d5-47af-97ae-08d9f21014db
X-MS-TrafficTypeDiagnostic: DM6PR12MB3916:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3916F883A89025488D0CB871CC369@DM6PR12MB3916.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fUHKHnpB4h4VV9S7u3DEcd4NbWY97hw3ltYTicXrHYfn5NyO8eX4saUJLl0XbzE/q7++m/X1wA6UE8aeYdiUAfXOxUDEaQEZymX62aRWeMCguUWwFtTONNBUOPcID7L5O6E1VMhDPiSDfTsJAN31HFW5S4ExW1t+fe43BuxSAUZDMXP4qtKYjUqZEW2Ew2QcVFZg4ohxhA54TSoCa/U0Iv4B5DlY3MDvgeO4nQ9QCNP4ox47ECe0gjWHSqiPW/baD+VX32sb64i56jDi6jkft5bbIOT7Qnet/ZFdx5Uyxljr2FvI71S6pJosLiVIFkiErdbNz6h4U+NG76DMiEfoMWEqRAhuVmJgKSSyUQz/TMGZ7zWoykw4CSWjiCMfrru42YRTKbRVWSPtFiH92uDuuJLsHYfgrkeEAzFt+WymQMrfMDJhmiUVJDtlgcSb2uCsI4OUN+Gkk6X+UqDbhaDLlL/aYWfPpoj9AzDJdxoM6IQUdoLXiJG0WzScV0L7t67oJbFiyqnCZuGPaHVyucPVErMFpG3rl6z1Bf6dEB0DtBZPFYHsBsbZUhviAL6/jAciiyGBdL/6308SURMrnJ8zPHaMBUF9+LuCuLg7aGVQCj8OeTdKpDTrURVwRahnoCGzcGSyzRQqOPOhC1kpnFeKET9SP5aSw1tZ+eb+0VWZ2EI9UqVpCo6H+8s8fpKRvoNW/qi+vHKv5Vf9NCpdHu3UaQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(36860700001)(83380400001)(7696005)(2616005)(36756003)(107886003)(5660300002)(47076005)(186003)(26005)(1076003)(336012)(426003)(2906002)(81166007)(8936002)(316002)(356005)(8676002)(6666004)(4326008)(40460700003)(54906003)(110136005)(86362001)(70586007)(70206006)(508600001)(82310400004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 12:21:53.1407
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac969d76-57d5-47af-97ae-08d9f21014db
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3916
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If 'vfio_pci_core_device::needs_pm_restore' is set (PCI device does
not have No_Soft_Reset bit set in its PMCSR config register), then the
current PCI state will be saved locally in
'vfio_pci_core_device::pm_save' during D0->D3hot transition and same
will be restored back during D3hot->D0 transition. For reset-related
functionalities, vfio driver uses PCI reset API's. These
API's internally change the PCI power state back to D0 first if
the device power state is non-D0. This state change to D0 will happen
without the involvement of vfio driver.

Let's consider the following example:

1. The device is in D3hot.
2. User invokes VFIO_DEVICE_RESET ioctl.
3. pci_try_reset_function() will be called which internally
   invokes pci_dev_save_and_disable().
4. pci_set_power_state(dev, PCI_D0) will be called first.
5. pci_save_state() will happen then.

Now, for the devices which has NoSoftRst-, the pci_set_power_state()
can trigger soft reset and the original PCI config state will be lost
at step (4) and this state cannot be restored again. This original PCI
state can include any setting which is performed by SBIOS or host
linux kernel (for example LTR, ASPM L1 substates, etc.). When this
soft reset will be triggered, then all these settings will be reset,
and the device state saved at step (5) will also have this setting
cleared so it cannot be restored. Since the vfio driver only exposes
limited PCI capabilities to its user, so the vfio driver user also
won't have the option to save and restore these capabilities state
either and these original settings will be permanently lost.

For pci_reset_bus() also, we can have the above situation.
The other functions/devices can be in D3hot and the reset will change
the power state of all devices to D0 without the involvement of vfio
driver.

So, before calling any reset-related API's, we need to make sure that
the device state is D0. This is mainly to preserve the state around
soft reset.

For vfio_pci_core_disable(), we use __pci_reset_function_locked()
which internally can use pci_pm_reset() for the function reset.
pci_pm_reset() requires the device power state to be in D0, otherwise
it returns error.

This patch changes the device power state to D0 by invoking
vfio_pci_set_power_state() explicitly before calling any reset related
API's.

Fixes: 51ef3a004b1e ("vfio/pci: Restore device state on PM transition")
Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 48 ++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 87b288affc13..2e6409cc11ad 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -335,6 +335,17 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 	/* For needs_reset */
 	lockdep_assert_held(&vdev->vdev.dev_set->lock);
 
+	/*
+	 * This function can be invoked while the power state is non-D0.
+	 * This function calls __pci_reset_function_locked() which internally
+	 * can use pci_pm_reset() for the function reset. pci_pm_reset() will
+	 * fail if the power state is non-D0. Also, for the devices which
+	 * have NoSoftRst-, the reset function can cause the PCI config space
+	 * reset without restoring the original state (saved locally in
+	 * 'vdev->pm_save').
+	 */
+	vfio_pci_set_power_state(vdev, PCI_D0);
+
 	/* Stop the device from further DMA */
 	pci_clear_master(pdev);
 
@@ -934,6 +945,19 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 			return -EINVAL;
 
 		vfio_pci_zap_and_down_write_memory_lock(vdev);
+
+		/*
+		 * This function can be invoked while the power state is non-D0.
+		 * If pci_try_reset_function() has been called while the power
+		 * state is non-D0, then pci_try_reset_function() will
+		 * internally set the power state to D0 without vfio driver
+		 * involvement. For the devices which have NoSoftRst-, the
+		 * reset function can cause the PCI config space reset without
+		 * restoring the original state (saved locally in
+		 * 'vdev->pm_save').
+		 */
+		vfio_pci_set_power_state(vdev, PCI_D0);
+
 		ret = pci_try_reset_function(vdev->pdev);
 		up_write(&vdev->memory_lock);
 
@@ -2068,6 +2092,18 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 	}
 	cur_mem = NULL;
 
+	/*
+	 * The pci_reset_bus() will reset all the devices in the bus.
+	 * The power state can be non-D0 for some of the devices in the bus.
+	 * For these devices, the pci_reset_bus() will internally set
+	 * the power state to D0 without vfio driver involvement.
+	 * For the devices which have NoSoftRst-, the reset function can
+	 * cause the PCI config space reset without restoring the original
+	 * state (saved locally in 'vdev->pm_save').
+	 */
+	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list)
+		vfio_pci_set_power_state(cur, PCI_D0);
+
 	ret = pci_reset_bus(pdev);
 
 err_undo:
@@ -2121,6 +2157,18 @@ static bool vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set)
 	if (!pdev)
 		return false;
 
+	/*
+	 * The pci_reset_bus() will reset all the devices in the bus.
+	 * The power state can be non-D0 for some of the devices in the bus.
+	 * For these devices, the pci_reset_bus() will internally set
+	 * the power state to D0 without vfio driver involvement.
+	 * For the devices which have NoSoftRst-, the reset function can
+	 * cause the PCI config space reset without restoring the original
+	 * state (saved locally in 'vdev->pm_save').
+	 */
+	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list)
+		vfio_pci_set_power_state(cur, PCI_D0);
+
 	ret = pci_reset_bus(pdev);
 	if (ret)
 		return false;
-- 
2.17.1

