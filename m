Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13437563247
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 13:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237118AbiGALI5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 07:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237034AbiGALIw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 07:08:52 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B8313DD5;
        Fri,  1 Jul 2022 04:08:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IwgL629LFtv9HJjFeLPvrziRAUWsTkw3VBtezWtBONVLa3e8TY76n17G2txUq9+J76BQq2rZrHFcEnUGbA3O5m96ieFLtoFst9bD/RPgSmYBnIZD2gXkXWArw+XGIxpU+ucSxrEtDO6+PxVrqn61ZsYpi4XpUtzpUQgHM1upM4qPbfsR1YTqM6WaXlQLgYeL3LNKmOMGIEYsF7NPQSsJJZuIjth/g+Ab9BWfvgbvS3iG2n6N4lO/KbY8QzT++2Hl/n6jLrg0lri5X/xKU+WXEWQisvTuXXZZAfb6J3pc4Vh4DFjDqrpxxBnkhvC7+i6rIWyhpysq3zlXPEHe4NvNkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=txRmGD9+fJv66FTftqG5ureY8xI6M3kGOJL6wlNAUxM=;
 b=au843OEQAvdJFNww4x4VIeTjWfOLkmWgGPAPaHwkqZBn5/GbUl01qgeQ6GNDbG1eICJTG6WCQD7d9RfbMJ7OeU37mnjf6zpoPfqzXPsgmCU9S5WlSgwIUghuBt8VnsfMijrtXKgT7WoU27TnpsaU9ifElm7z776JSZlB0sJNQLyCE0EnreEKbLzCAlWszKkDrm7HsICQJycrlJCK2Eu7XGakt9wZtBrS5GRurYTyCbsb9/5cQVOJVBOa5oWM+iZoTa1jm7R79YXs1CPAFh4sxkwszWjxft1lgPmheUJnM2O7OhHCSnSfJG19F2bguaec43sscaDDbv/ozWJg6d0OXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=txRmGD9+fJv66FTftqG5ureY8xI6M3kGOJL6wlNAUxM=;
 b=IHHjzYb6Arj9tu1aOPTvMx7oZjTCxuonUI4sMTpuNPCJEk+xPQSDfB8bKftW9u/SRyUU0BCHhSuxOUg22DviiphH9JKj37wOHR6kWOmO8e8SjZYv7AKIA0zwid+iYSAnfuEe3zlalpZF0hFrBS2Oeb+f85S1VlJeOuQ66tfY51InSuMPXXMbyZQByoJ+iJZdIx3VAHU/azFrNjZvWlHzwDooWmJnqIO+6BMP7Xn8gH1e2eEPIe5OQyKaXYruOeqwhvCTGE1d8AK8ZTAs4lb9mbMfyyeWcHddb8QGwd5746FeZaHYuYTF+jH+9FTOQYd6Tqq5JOT0M6yTb8jgTciOJg==
Received: from CO2PR04CA0184.namprd04.prod.outlook.com (2603:10b6:104:5::14)
 by DM5PR1201MB0235.namprd12.prod.outlook.com (2603:10b6:4:4f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Fri, 1 Jul
 2022 11:08:47 +0000
Received: from CO1NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:5:cafe::cc) by CO2PR04CA0184.outlook.office365.com
 (2603:10b6:104:5::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13 via Frontend
 Transport; Fri, 1 Jul 2022 11:08:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT039.mail.protection.outlook.com (10.13.174.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Fri, 1 Jul 2022 11:08:47 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Fri, 1 Jul 2022 11:08:46 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Fri, 1 Jul 2022 04:08:44 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Fri, 1 Jul 2022 04:08:39 -0700
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
Subject: [PATCH v4 4/6] vfio/pci: Add the support for PCI D3cold state
Date:   Fri, 1 Jul 2022 16:38:12 +0530
Message-ID: <20220701110814.7310-5-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220701110814.7310-1-abhsahu@nvidia.com>
References: <20220701110814.7310-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d572e190-f921-49b5-b3e9-08da5b5211df
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0235:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3FjsfiUcQ94vPJfxFPPeuE8jQf78r8lbvx97x0sDtOvS/dtZAkTXPUi0bvx7dqICkm+qYPCGq3xnf+BrnpjbA2TsZOjtLverV/MHVc4rOra1kvKIpCtRYeP9Zuft8sJP+bTKevItwh7fQU0dZOjuxJq/ULWmpXnIn1h6dmDp03Dxfo6PNCponGPk1P+AdsolYvVzBIpnO87ZlIkCoOKsXh7EXfj1F0Ff4ApuYxVPavAmbFEgbjXz7D0s047Z1deaJoGTZKoFlBPizK8CM1tX44T10x9wHigOtqB8cxuoV7YzuuyJAa5W6ExcwlchQ8W7HVI7GOIhCCfthsz/ZweqXq21qVTe/KHGzfId2n9qvmfiFJAhMsIDS/K4b67D/0cS64R9VR4Ol9sATOXC7oADUPXikrhRXrMV4nrX50CQkQTCCeswMVGEeRmIAjUgKS6gPsi8R0QRO49y/RAZ/OaICkaYBvmJxLLjJffuOyS7HBtx1MATqefpbRttZ8FJYfIsy1KKqznjbiB1XEGNzwm3rlFaUX2kb+Apn2X7cyHGMyXFBRFOiLKHkWkdkCTXgGlP+AXdE93R6didalcxdVDlCv62KrNT97DrbuWDtQTj3OHEJjRlnG+slDypeX51i8tARWKnErndl0NCFLqYkfkrMaKzU7ZlHCQqESBb449pI49T8m6reUFTHYlS696YkNRmr3V2Qd9QgOtUtpJ5Ahhtu3TvGKBoT/X4S59R3BVO2qFhwTbCC7adlL3JCxCL0Dn+OhiEMgEv+yQTNDW4auxkuVeXx8jwU91ID4WQT7WYzTZEjQmn0WZ0fnh+PyMSQiOXq5HH7BoYkhyU/2xKO/iytP/lTKUW1E5fFmHCDPSDMd5KwgyzNyeG9jaw5bTd02H6
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(39860400002)(396003)(36840700001)(46966006)(40470700004)(478600001)(82740400003)(83380400001)(82310400005)(81166007)(356005)(36756003)(2616005)(107886003)(7696005)(41300700001)(316002)(426003)(336012)(186003)(110136005)(1076003)(54906003)(6666004)(47076005)(40480700001)(2906002)(40460700003)(70586007)(30864003)(8676002)(70206006)(4326008)(5660300002)(7416002)(8936002)(86362001)(36860700001)(26005)(32563001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 11:08:47.0259
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d572e190-f921-49b5-b3e9-08da5b5211df
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0235
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
   PM config registers. This patch implements the newly added
   'VFIO_DEVICE_FEATURE_POWER_MANAGEMENT' device feature which
    can be used for putting the device into the D3cold state.

2. The hypervisors can implement virtual ACPI methods. For example,
   in guest linux OS if PCI device ACPI node has _PR3 and _PR0 power
   resources with _ON/_OFF method, then guest linux OS invokes
   the _OFF method during D3cold transition and then _ON during D0
   transition. The hypervisor can tap these virtual ACPI calls and then
   call the  'VFIO_DEVICE_FEATURE_POWER_MANAGEMENT' with respective flags.

3. The vfio-pci driver uses runtime PM framework to achieve the
   D3cold state. For the D3cold transition, decrement the usage count and
   for the D0 transition, increment the usage count.

4. If the D3cold state is not supported, then the device will
   still be in the D3hot state. But with the runtime PM, the root port
   can now also go into the suspended state.

5. The 'pm_runtime_engaged' flag tracks the entry and exit to
   runtime PM. This flag is protected with 'memory_lock' semaphore.

6. During exit time, the flag clearing and usage count increment
   are protected with 'memory_lock'. The actual wake-up is happening
   outside 'memory_lock' since 'memory_lock' will be needed inside
   runtime_resume callback also in subsequent patches.

7. In D3cold, all kinds of device-related access (BAR read/write,
   config read/write, etc.) need to be disabled. For BAR-related access,
   we can use existing D3hot memory disable support. During the low power
   entry, invalidate the mmap mappings and add the check for
   'pm_runtime_engaged' flag.

8. For config space, ideally, we need to return an error whenever
   there is any config access from the user side once the user moved the
   device into low power state. But adding a check for
   'pm_runtime_engaged' flag alone won't be sufficient due to the
   following possible scenario from the user side where config space
   access happens parallelly with the low power entry IOCTL.

   a. Config space access happens and vfio_pci_config_rw() will be
      called.
   b. The IOCTL to move into low power state is called.
   c. The IOCTL will move the device into d3cold.
   d. Exit from vfio_pci_config_rw() happened.

   Now, if we just check 'pm_runtime_engaged', then in the above
   sequence the config space access will happen when the device already
   is in the low power state. To prevent this situation, we increment the
   usage count before any config space access and decrement the same
   after completing the access. Also, to prevent any similar cases for
   other types of access, the usage count will be incremented for all
   kinds of access.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_config.c |   2 +-
 drivers/vfio/pci/vfio_pci_core.c   | 169 +++++++++++++++++++++++++++--
 include/linux/vfio_pci_core.h      |   1 +
 3 files changed, 164 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 9343f597182d..21a4743d011f 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -408,7 +408,7 @@ bool __vfio_pci_memory_enabled(struct vfio_pci_core_device *vdev)
 	 * PF SR-IOV capability, there's therefore no need to trigger
 	 * faults based on the virtual value.
 	 */
-	return pdev->current_state < PCI_D3hot &&
+	return !vdev->pm_runtime_engaged && pdev->current_state < PCI_D3hot &&
 	       (pdev->no_command_memory || (cmd & PCI_COMMAND_MEMORY));
 }
 
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 5948d930449b..8c17ca41d156 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -264,6 +264,18 @@ static int vfio_pci_core_runtime_suspend(struct device *dev)
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
@@ -386,6 +398,7 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 	struct pci_dev *pdev = vdev->pdev;
 	struct vfio_pci_dummy_resource *dummy_res, *tmp;
 	struct vfio_pci_ioeventfd *ioeventfd, *ioeventfd_tmp;
+	bool do_resume = false;
 	int i, bar;
 
 	/* For needs_reset */
@@ -393,6 +406,25 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 
 	/*
 	 * This function can be invoked while the power state is non-D0.
+	 * This non-D0 power state can be with or without runtime PM.
+	 * Increment the usage count corresponding to pm_runtime_put()
+	 * called during setting of 'pm_runtime_engaged'. The device will
+	 * wake up if it has already gone into the suspended state.
+	 * Otherwise, the next vfio_pci_set_power_state() will change the
+	 * device power state to D0.
+	 */
+	down_write(&vdev->memory_lock);
+	if (vdev->pm_runtime_engaged) {
+		vdev->pm_runtime_engaged = false;
+		pm_runtime_get_noresume(&pdev->dev);
+		do_resume = true;
+	}
+	up_write(&vdev->memory_lock);
+
+	if (do_resume)
+		pm_runtime_resume(&pdev->dev);
+
+	/*
 	 * This function calls __pci_reset_function_locked() which internally
 	 * can use pci_pm_reset() for the function reset. pci_pm_reset() will
 	 * fail if the power state is non-D0. Also, for the devices which
@@ -1190,6 +1222,99 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl);
 
+static int vfio_pci_pm_validate_flags(u32 flags)
+{
+	if (!flags)
+		return -EINVAL;
+	/* Only valid flags should be set */
+	if (flags & ~(VFIO_PM_LOW_POWER_ENTER | VFIO_PM_LOW_POWER_EXIT))
+		return -EINVAL;
+	/* Both enter and exit should not be set */
+	if ((flags & (VFIO_PM_LOW_POWER_ENTER | VFIO_PM_LOW_POWER_EXIT)) ==
+	    (VFIO_PM_LOW_POWER_ENTER | VFIO_PM_LOW_POWER_EXIT))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int vfio_pci_core_feature_pm(struct vfio_device *device, u32 flags,
+				    void __user *arg, size_t argsz)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(device, struct vfio_pci_core_device, vdev);
+	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_device_feature_power_management vfio_pm = { 0 };
+	int ret = 0;
+
+	ret = vfio_check_feature(flags, argsz,
+				 VFIO_DEVICE_FEATURE_SET |
+				 VFIO_DEVICE_FEATURE_GET,
+				 sizeof(vfio_pm));
+	if (ret != 1)
+		return ret;
+
+	if (flags & VFIO_DEVICE_FEATURE_GET) {
+		down_read(&vdev->memory_lock);
+		if (vdev->pm_runtime_engaged)
+			vfio_pm.flags = VFIO_PM_LOW_POWER_ENTER;
+		else
+			vfio_pm.flags = VFIO_PM_LOW_POWER_EXIT;
+		up_read(&vdev->memory_lock);
+
+		if (copy_to_user(arg, &vfio_pm, sizeof(vfio_pm)))
+			return -EFAULT;
+
+		return 0;
+	}
+
+	if (copy_from_user(&vfio_pm, arg, sizeof(vfio_pm)))
+		return -EFAULT;
+
+	ret = vfio_pci_pm_validate_flags(vfio_pm.flags);
+	if (ret)
+		return ret;
+
+	/*
+	 * The vdev power related flags are protected with 'memory_lock'
+	 * semaphore.
+	 */
+	if (vfio_pm.flags & VFIO_PM_LOW_POWER_ENTER) {
+		vfio_pci_zap_and_down_write_memory_lock(vdev);
+		if (vdev->pm_runtime_engaged) {
+			up_write(&vdev->memory_lock);
+			return -EINVAL;
+		}
+
+		vdev->pm_runtime_engaged = true;
+		up_write(&vdev->memory_lock);
+		pm_runtime_put(&pdev->dev);
+	} else if (vfio_pm.flags & VFIO_PM_LOW_POWER_EXIT) {
+		down_write(&vdev->memory_lock);
+		if (!vdev->pm_runtime_engaged) {
+			up_write(&vdev->memory_lock);
+			return -EINVAL;
+		}
+
+		vdev->pm_runtime_engaged = false;
+		pm_runtime_get_noresume(&pdev->dev);
+		up_write(&vdev->memory_lock);
+		ret = pm_runtime_resume(&pdev->dev);
+		if (ret < 0) {
+			down_write(&vdev->memory_lock);
+			if (!vdev->pm_runtime_engaged) {
+				vdev->pm_runtime_engaged = true;
+				pm_runtime_put_noidle(&pdev->dev);
+			}
+			up_write(&vdev->memory_lock);
+			return ret;
+		}
+	} else {
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int vfio_pci_core_feature_token(struct vfio_device *device, u32 flags,
 				       void __user *arg, size_t argsz)
 {
@@ -1224,6 +1349,8 @@ int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
 	switch (flags & VFIO_DEVICE_FEATURE_MASK) {
 	case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
 		return vfio_pci_core_feature_token(device, flags, arg, argsz);
+	case VFIO_DEVICE_FEATURE_POWER_MANAGEMENT:
+		return vfio_pci_core_feature_pm(device, flags, arg, argsz);
 	default:
 		return -ENOTTY;
 	}
@@ -1234,31 +1361,47 @@ static ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
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
@@ -2157,6 +2300,15 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
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
@@ -2212,6 +2364,9 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
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
index cdfd328ba6b1..bf4823b008f9 100644
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

