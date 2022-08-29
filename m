Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 545B35A4B1F
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 14:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbiH2MJl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 08:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbiH2MIV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 08:08:21 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062a.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E9A8E446;
        Mon, 29 Aug 2022 04:53:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HriMKK0cog9eS5QzxT0w2ro2rB1b1ZNFxQ/jLbmuQz9CcCgna3ZNcK2hiAJbCJu+cv902Gvq57MeXNXH1KwiMWLaIwLF4hOgG9nZvMRLmD4pOtg1d8HOsbMlAnk7oUSGAc4/0fcYYhMaZ4de2I1O+g8IgRHBLA29rQy6Bat7adW/WCBlYku8EbRAmRP0/yypLMyzNX7sAlMbtgEdY2L1Mtbj+jcY/txyUqnAdnT47SGleylEGeD5xIOpEyoBnwW/e2n2rvoOHqTHaZuBNmPyGfl8CIacKLTczlPnhH+yZ0QG3uOayMeprmZv621HNgmVPG0imN62YxukXLQp4gF/IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LwkuhZRni3VilS+fViO2KXJWi5cSptkV4Lmh2gWdXSk=;
 b=In7BEeKWuV3WMjLjnUOiV6DoY1E3C6BJKLcOmogoDj39byZq/buFsnEY9ScI1Viwa6ffihSXebhPanxvoUBmkfefAMM/KJCpbDsu4IWyF9Z2CU/cg9+kPerSXP1LShipE8bCISfJy17cBu9aObr1zbP4o/llCOca9YlLWLOfaHPMr8wywNdnbRjJskZL6Z1ZCAQbH7dTroJeinFwIBZAhSQG9pQjTRjE3z6ltNSF0nuaY2mAR4AVrafIqDc1FPxOAfrEPjBqUI9Hg50niDMNN95BwgvVilHh8IiIUOewaQBS+goU3U8MsX/ecsWxgRIDsys3U0mRWGR48KrRjFogWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LwkuhZRni3VilS+fViO2KXJWi5cSptkV4Lmh2gWdXSk=;
 b=okBY/xTu+JHLWVJtstSC1kWlJVqbMv06yxgXmn8PP7mfUm2JS+S1nsZNWOA5uBVEhH5bTexRhFOWwlwDU0xbvW2Y8JzuduS+PqPJdPhqFlSK3BGjPGGlolxxLUt9vA0EPaXj3eWOqqgO90rd8epRcK/wOcYkJ88gGyoVri4nR9QRBUQQ6/lkJfHf6sF0ek8sNn4dER6vTJpjwVsRD3Ka9EtGJg1RfcWTGhsSub+2rmMgu+mInhGPK692qDaUK+YuDObTM7Ukf/Ioata0IZZWiSk+TDOmjZhi2WSFDVb2BfM+KUA6f7R0vP9DXmBsBdLch9c4faWeMB7lrkU5iI0nig==
Received: from DS7PR03CA0233.namprd03.prod.outlook.com (2603:10b6:5:3ba::28)
 by CH2PR12MB3831.namprd12.prod.outlook.com (2603:10b6:610:29::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16; Mon, 29 Aug
 2022 11:49:18 +0000
Received: from DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::24) by DS7PR03CA0233.outlook.office365.com
 (2603:10b6:5:3ba::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.18 via Frontend
 Transport; Mon, 29 Aug 2022 11:49:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT009.mail.protection.outlook.com (10.13.173.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Mon, 29 Aug 2022 11:49:18 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Mon, 29 Aug
 2022 11:49:18 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 29 Aug
 2022 04:49:17 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Mon, 29 Aug 2022 04:49:12 -0700
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
Subject: [PATCH v7 3/5] vfio/pci: Mask INTx during runtime suspend
Date:   Mon, 29 Aug 2022 17:18:48 +0530
Message-ID: <20220829114850.4341-4-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220829114850.4341-1-abhsahu@nvidia.com>
References: <20220829114850.4341-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45480123-51aa-4dcc-9728-08da89b48191
X-MS-TrafficTypeDiagnostic: CH2PR12MB3831:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zixo/UeLymTEDZ1HwKxXsS86kb4JmB0h+OZgmQx/3r8QiorffFmGzVwpwf9C4OyHKIhSmu0Ug9e4BZH1RgGmnK9ru1DelV9+9MoTT4T2pytVxYNcRlelNi0cE2E40sWvHFN/DkkjSc/DdTBZ0bLT6EE+xr3ctECo+rPJdPxSNZspc5IxHhGKX/EWIvlk2ICXEF4OyPQgWzQ7pfvr/3E8igv1w4wEWbow0NRPGNKNPJwFi4yFqkEwtJeuA+ry+7fh/u+hw6W6NXb7ch5F+E4AOcajL/1EJuAIbJT7svQ85/hxPTJUo099/Tnw/w2TjuDMILbdFhC19JId5mWsosVJW0fI1x7ghweVU037P1T1MdilIBmEozU4T7dOapoVxSerSOMQWuvvnBqQQDVL8+imrDuEhLXBIEsiykti0gYcW6TND6Wq9N0uSRGxlGRSy/edmn4fwnSMdUJUqDDpAXIEdA5UXrUZ1YFDxRS8DuUR3aovzT22m8pp+500iXtKSTbQCH88ktLfXMLWAXzkC7y3mGu+NTBD4gXhzmMJLglCtWIBwJWVCB7cC1hZ0eABLWyrOO/KBHl+EtCB/R6G52JXZSin7guZ/0og0DG2C4u9+0MTX3JbvfRjHnE3U2KsZuHsLxI6vja6xqTvsh7ZuseHuPKEWSliqTWHoOHPNCPw9oVHOkAt5M9clQQJGyh7c3B5+OJfmZD1/Read8QGJAwkgA0E1ZdRnrOQaEczwYlgcnWHMDcP3hjHhCflmJXfXuGU6LFpz/G8ubro/wlxKhd9ZStMZ1F6hkGrr+tTLcSduW2KdsQI2z2bdOSjVmNBbbS3
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(39860400002)(346002)(376002)(46966006)(40470700004)(36840700001)(36860700001)(1076003)(2616005)(336012)(186003)(426003)(2906002)(47076005)(83380400001)(110136005)(316002)(54906003)(70586007)(70206006)(4326008)(8676002)(5660300002)(26005)(107886003)(7696005)(6666004)(478600001)(15650500001)(7416002)(41300700001)(8936002)(81166007)(36756003)(40460700003)(40480700001)(86362001)(82310400005)(82740400003)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 11:49:18.6017
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45480123-51aa-4dcc-9728-08da89b48191
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3831
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
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
device, the 'irq_type' will be VFIO_PCI_NUM_IRQS and these
callbacks won't do anything.

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
 drivers/vfio/pci/vfio_pci_core.c  | 38 +++++++++++++++++++++++++++----
 drivers/vfio/pci/vfio_pci_intrs.c |  6 ++++-
 drivers/vfio/pci/vfio_pci_priv.h  |  2 +-
 include/linux/vfio_pci_core.h     |  1 +
 4 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 9273f1ffd0dd..207ede189c2a 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -277,16 +277,46 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
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
+	vdev->pm_intx_masked = ((vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX) &&
+				vfio_pci_intx_mask(vdev));
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
index 8cb987ef3c47..40c3d7cf163f 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -59,10 +59,12 @@ static void vfio_send_intx_eventfd(void *opaque, void *unused)
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
 
@@ -86,9 +88,11 @@ void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
 			disable_irq_nosync(pdev->irq);
 
 		vdev->ctx[0].masked = true;
+		masked_changed = true;
 	}
 
 	spin_unlock_irqrestore(&vdev->irqlock, flags);
+	return masked_changed;
 }
 
 /*
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index 58b8d34c162c..5e4fa69aee16 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -23,7 +23,7 @@ struct vfio_pci_ioeventfd {
 	bool			test_mem;
 };
 
-void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev);
+bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev);
 void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev);
 
 int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index e5cf0d3313a6..a0f1f36e42a2 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -78,6 +78,7 @@ struct vfio_pci_core_device {
 	bool			needs_reset;
 	bool			nointx;
 	bool			needs_pm_restore;
+	bool			pm_intx_masked;
 	struct pci_saved_state	*pci_saved_state;
 	struct pci_saved_state	*pm_save;
 	int			ioeventfds_nr;
-- 
2.17.1

