Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7141596884
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 07:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238365AbiHQFOR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 01:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238139AbiHQFOC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 01:14:02 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E475281C;
        Tue, 16 Aug 2022 22:13:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UNjq+wfH5U/Ntb3W1EmI8Er1qDZoWrNq4z6Y2Ce/wlp9nNcAkeu7BPSLfW+rFiOD2vzmhmk+Msf8R8/flGjuLe6Dmu+0SDrmNiN5NAZg+6lOyjLeI3E/cGEy7jJNtCAcnqgpGl2sAd7WMBeah/DHeQmME2srkk4OjsaXMeiQnC6PzSpZyXXMmvAyyUxrrWPedTZR8H5qadN6WVMDReRLlaEBLlRPBohMXy7UZK9Gj55HqkWO3bBduW9bNn3n2ka6oxv2ki4IfCLnMcDNN/3cyym2OgUsUw5oVoDU87Hy2zbVYZ5oTCHiQTr56MQbhgYbgC65a/59sTpy8VT70RR5mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zYcq+020TEMkHIt1a9/l5HvK3tXtJOS63qlRHnAdzEM=;
 b=YOxg56qW8TlEqaUodgWokN+qcYJniXZKluvqMJDwCGhflp0bSqmpH06RcdH2z8yqNSw8TwpncOup5TXpvfgkjKnAYDuK7sH+FnslsdTERR7YuBh9bpkacGk9xmL8haY19+joUJh3ZdEBV9gQ6CkcXusHPax4Gek/SfPmAPq30suyCnwCVroLM9Ca3FVJGtI608cVSJEGIOxwAg1miZw9LyhWbze13P2PFkidUJoQ62psv0XXPD3bxifXL3in11Ddjv1KE41iqVKxQnJpYgI7xdhBV3sB3eDxiIsWDoAQPWbBrJfBDIry3LCK8vtE6fHWOe7SrPd30RMTxdIS+ANlBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zYcq+020TEMkHIt1a9/l5HvK3tXtJOS63qlRHnAdzEM=;
 b=Aea9/5Mr9iAo/tp89DZsMvTUsA68EcFsXf75Ll7SIRrCAdCVTRBrB7UnoFXP6Ui1ciyaKW/Wx9xxCpzmd8oQiXQHJzJwqzCzy9TWEGUnn5SVXd4F9fXYQ/ebaA3om+6b3se9AtwEGxCOY9Ak6TabSqUug1MN7YmsMicsPrqobmkjUq5UNNespC+CYDeV4xro3Ilhd0NLCEQPH5G4grY0OFUtPtFcWu1PnxqCcQa5NPdpoqgyST+7u0sZFqystuNnDXDr6AN1QGoFwxreXBdaT+N6xAbQa14tsEWoUDbxKdpH2qtrQjWsGYWxsHIlSJke1v+jA5hnAuKoNOGVupc6/g==
Received: from DM6PR17CA0024.namprd17.prod.outlook.com (2603:10b6:5:1b3::37)
 by CY4PR12MB1926.namprd12.prod.outlook.com (2603:10b6:903:11b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Wed, 17 Aug
 2022 05:13:51 +0000
Received: from DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b3:cafe::2a) by DM6PR17CA0024.outlook.office365.com
 (2603:10b6:5:1b3::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19 via Frontend
 Transport; Wed, 17 Aug 2022 05:13:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT020.mail.protection.outlook.com (10.13.172.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.15 via Frontend Transport; Wed, 17 Aug 2022 05:13:51 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 17 Aug
 2022 05:13:50 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Tue, 16 Aug
 2022 22:13:49 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Tue, 16 Aug 2022 22:13:44 -0700
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
Subject: [PATCH v6 3/5] vfio/pci: Mask INTx during runtime suspend
Date:   Wed, 17 Aug 2022 10:43:21 +0530
Message-ID: <20220817051323.20091-4-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220817051323.20091-1-abhsahu@nvidia.com>
References: <20220817051323.20091-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 183d0be0-ad67-45a0-50f4-08da800f45e6
X-MS-TrafficTypeDiagnostic: CY4PR12MB1926:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TlCOZxbEd+tjnk9AhI/Fw4J+gsmNX0Eu+LLpRMPP6DCIK5vJXEtRdRQ+fwV5bmywjKPBdUjQlSzTbMy4A0HOQzyYtIjuO5DVzX+RbVOuiBBGkQcG9EFfVZwfcIb07Xj2HSjsC9mxz8S7GkJejeZtv59dh7EpdIoZTCl1u7yw2dZbvpXZSjkxBSZjJkEfmX6Aq0ydzpS3cSZF8mZQgwp3r8sigSScA/oVW6SCp5hDGCEShn2J4C3cJn32q69mj6USKH0ZlkoJRhtD1pBkcZaSvLK10Z4qfFIVUrbRdFGyjRj/BPPS7NhuqyhUm0/sGfnY23nPWUQ9n+iG/e6elcnZKqDgK9OChrzB8bS48B6JVWV2EXP/clc+CF6bGdzNcWoyqm+4JSNR0aRHNuoZVv/211MZPtoTFJtAluUpYsewAMHoY2nU6k1tbuhhlbjn+RQHoqWpwifhbo/80MbaMQ1yWV1BEBAii4aRzCtVIfPnL1jlL+dfMiUdayMWcWSd9qJHTvM0H5C3HJW8Cumw/BjKDD9w7JZ9X+gFQHrNGS/NVE5vZZP14f2EwkRCd3h8rTPapr5KsauR95KsKc33ztDWL1TfavhM+K7+j+IeGqZaTfgo9zAJgKe4xt24FvS3TpwBKwozze6lkpC2ekhELYAhtdbdiaoeliFIiiuAdXRMYz2EDtkEPV5AnwaPJFzXO3g17JlX5/a1kgPeiulGrLVX1Yf9xP8F+EZFF48VyGrT4sodBQfS8Csxc+kbSkZJMxjf3etVo2s8kcfJQ5IFhvHxkfktmcgqak+fAi/bD7MWTizUGzTWu0ixXVPqle62+G2sDijx+DThwqAsObCQDZLF6A==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(376002)(346002)(136003)(46966006)(40470700004)(36840700001)(47076005)(426003)(81166007)(8936002)(107886003)(2616005)(1076003)(336012)(83380400001)(8676002)(70206006)(15650500001)(2906002)(70586007)(5660300002)(7416002)(40480700001)(36756003)(4326008)(478600001)(110136005)(82310400005)(86362001)(316002)(54906003)(6666004)(41300700001)(7696005)(26005)(36860700001)(40460700003)(82740400003)(356005)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 05:13:51.0683
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 183d0be0-ad67-45a0-50f4-08da800f45e6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1926
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds INTx handling during runtime suspend/resume.
All the suspend/resume related code for the user to put the device
into the low power state will be added in subsequent patches.

The INTx lines may be shared among devices. Whenever any INTx
interrupt comes for the VFIO devices, then vfio_intx_handler() will be
called for each device sharing the interrupt. Inside vfio_intx_handler(),
it calls pci_check_and_mask_intx() and checks if the interrupt has
been generated for the current device. Now, if the device is already
in the D3cold state, then the config space can not be read. Attempt
to read config space in D3cold state can cause system unresponsiveness
in a few systems. To prevent this, mask INTx in runtime suspend callback,
and unmask the same in runtime resume callback. If INTx has been already
masked, then no handling is needed in runtime suspend/resume callbacks.
'pm_intx_masked' tracks this, and vfio_pci_intx_mask() has been updated
to return true if the INTx vfio_pci_irq_ctx.masked value is changed
inside this function.

For the runtime suspend which is triggered for the no user of VFIO
device, the is_intx() will return false and these callbacks won't do
anything.

The MSI/MSI-X are not shared so similar handling should not be
needed for MSI/MSI-X. vfio_msihandler() triggers eventfd_signal()
without doing any device-specific config access. When the user performs
any config access or IOCTL after receiving the eventfd notification,
then the device will be moved to the D0 state first before
servicing any request.

Another option was to check this flag 'pm_intx_masked' inside
vfio_intx_handler() instead of masking the interrupts. This flag
is being set inside the runtime_suspend callback but the device
can be in non-D3cold state (for example, if the user has disabled D3cold
explicitly by sysfs, the D3cold is not supported in the platform, etc.).
Also, in D3cold supported case, the device will be in D0 till the
PCI core moves the device into D3cold. In this case, there is
a possibility that the device can generate an interrupt. Adding check
in the IRQ handler will not clear the IRQ status and the interrupt
line will still be asserted. This can cause interrupt flooding.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c  | 37 +++++++++++++++++++++++++++----
 drivers/vfio/pci/vfio_pci_intrs.c |  6 ++++-
 include/linux/vfio_pci_core.h     |  3 ++-
 3 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index c8d3b0450fb3..a97fb8cbf903 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -260,16 +260,45 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
 	return ret;
 }
 
+#ifdef CONFIG_PM
+static int vfio_pci_core_runtime_suspend(struct device *dev)
+{
+	struct vfio_pci_core_device *vdev = dev_get_drvdata(dev);
+
+	/*
+	 * If INTx is enabled, then mask INTx before going into the runtime
+	 * suspended state and unmask the same in the runtime resume.
+	 * If INTx has already been masked by the user, then
+	 * vfio_pci_intx_mask() will return false and in that case, INTx
+	 * should not be unmasked in the runtime resume.
+	 */
+	vdev->pm_intx_masked = (is_intx(vdev) && vfio_pci_intx_mask(vdev));
+
+	return 0;
+}
+
+static int vfio_pci_core_runtime_resume(struct device *dev)
+{
+	struct vfio_pci_core_device *vdev = dev_get_drvdata(dev);
+
+	if (vdev->pm_intx_masked)
+		vfio_pci_intx_unmask(vdev);
+
+	return 0;
+}
+#endif /* CONFIG_PM */
+
 /*
- * The dev_pm_ops needs to be provided to make pci-driver runtime PM working,
- * so use structure without any callbacks.
- *
  * The pci-driver core runtime PM routines always save the device state
  * before going into suspended state. If the device is going into low power
  * state with only with runtime PM ops, then no explicit handling is needed
  * for the devices which have NoSoftRst-.
  */
-static const struct dev_pm_ops vfio_pci_core_pm_ops = { };
+static const struct dev_pm_ops vfio_pci_core_pm_ops = {
+	SET_RUNTIME_PM_OPS(vfio_pci_core_runtime_suspend,
+			   vfio_pci_core_runtime_resume,
+			   NULL)
+};
 
 int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 {
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 6069a11fb51a..8b805d5d19e1 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -33,10 +33,12 @@ static void vfio_send_intx_eventfd(void *opaque, void *unused)
 		eventfd_signal(vdev->ctx[0].trigger, 1);
 }
 
-void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
+/* Returns true if the INTx vfio_pci_irq_ctx.masked value is changed. */
+bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	unsigned long flags;
+	bool masked_changed = false;
 
 	spin_lock_irqsave(&vdev->irqlock, flags);
 
@@ -60,9 +62,11 @@ void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
 			disable_irq_nosync(pdev->irq);
 
 		vdev->ctx[0].masked = true;
+		masked_changed = true;
 	}
 
 	spin_unlock_irqrestore(&vdev->irqlock, flags);
+	return masked_changed;
 }
 
 /*
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 5579ece4347b..98c0af5b5bba 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -124,6 +124,7 @@ struct vfio_pci_core_device {
 	bool			needs_reset;
 	bool			nointx;
 	bool			needs_pm_restore;
+	bool			pm_intx_masked;
 	struct pci_saved_state	*pci_saved_state;
 	struct pci_saved_state	*pm_save;
 	int			ioeventfds_nr;
@@ -147,7 +148,7 @@ struct vfio_pci_core_device {
 #define is_irq_none(vdev) (!(is_intx(vdev) || is_msi(vdev) || is_msix(vdev)))
 #define irq_is(vdev, type) (vdev->irq_type == type)
 
-void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev);
+bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev);
 void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev);
 
 int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev,
-- 
2.17.1

