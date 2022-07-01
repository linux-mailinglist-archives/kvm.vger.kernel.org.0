Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0947556323A
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 13:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236857AbiGALIf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 07:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236617AbiGALId (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 07:08:33 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2E7F7B;
        Fri,  1 Jul 2022 04:08:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N6CHtIPqKxXfkkRDJELvBD9xg+SLsS+F8VmAlYZpx/s1bji8dRKgphhwtqN7ddc8KoH9liE3EWvaIIucVGYwGoEYodQDHchvHBxT1II/KsptjMOyUyZDzRwOsQ84YIEBqkRRDg4poR3ZwbCELBLXiYf3MvdMh/FXukfV/sPmcpzyDPkubCnjRyF3MEhkh77zLJJkIMIjJ2+G2+PxAfIZg41uzX0kihlzArkryAVQxD+72A5jS0OA21hsZUOTwCnszcO9rSVFu3P/tpFZwwcqWaUAzgcLwgeOu7tYT6aC10Uc7QgKwJi6AOUJ20W/wxcj+I4j4o83ScB5HhENlpKH6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RNZ3MniP9gKjKRS2Yf8HW5nXx4euFO0ADBl0wdG4jcQ=;
 b=HgDSd+KZhKfqCHZZPfE5j+zSYIYLhka6EUg0OKrQ1ZT/soIIBRhokXVXpWHVgtuWmN+xVPwArC9vydBxFe+pGnbUL4wj0jMTZ8KEKd7cfTDN6Noylqk5g9EyH2XEVPKEc73CbdVGkbX3M+M5GCYIV6WOrZ6bBoYq2xCjAIDDhFc+abRLBiR7TiZe9TayRv2rGUKqQUFWbhtw/O+yNydSUlSOwgOG0k0Ck0VenXqSwT9pvjTM7yc5UxVe4yaA0IVjsKUqg6p+RyvKt1mwxWOY7vQoGuC6O8v4A/lCQw7uSK7tucv6t/bLPWqUspu4FLxAt3EWpizHkooVksWRbZ44eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNZ3MniP9gKjKRS2Yf8HW5nXx4euFO0ADBl0wdG4jcQ=;
 b=bVH6NY4KWbjzuAriQaRct3dXWE5izs3qZ0AlRULDfcP9mGFCfZ7aDoVXHuIFqS02QqZwcmLMurkxqfoH2N6tRuLgWHz53sYMsviHipGrX3FS9Z/m9w7N1bz5XXUMK+qzZFclKphSFUKziDyVA2Wj1BaWB6bk75FLnRjQ6EzgRjmM4R6hOAyijJvnJYqVplLVukHmGbDKE4GwCUup4HvJmUWJORnbd+7COGJVpk85LrteDcD5YMFSzXHZXguJdMw6pinteBG+9wjmCKS0Zb2M4OdVUeCjnMJh1amFE/NEImD8qdwnapl2QwCDC1Lzvu39nNHIy2Sq4G6bc34lhyy6FQ==
Received: from DS7PR05CA0007.namprd05.prod.outlook.com (2603:10b6:5:3b9::12)
 by DM5PR12MB1401.namprd12.prod.outlook.com (2603:10b6:3:71::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Fri, 1 Jul
 2022 11:08:30 +0000
Received: from DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::cd) by DS7PR05CA0007.outlook.office365.com
 (2603:10b6:5:3b9::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Fri, 1 Jul 2022 11:08:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT056.mail.protection.outlook.com (10.13.173.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Fri, 1 Jul 2022 11:08:30 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Fri, 1 Jul 2022 11:08:29 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Fri, 1 Jul 2022 04:08:28 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Fri, 1 Jul 2022 04:08:23 -0700
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
Subject: [PATCH v4 1/6] vfio/pci: Mask INTx during runtime suspend
Date:   Fri, 1 Jul 2022 16:38:09 +0530
Message-ID: <20220701110814.7310-2-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220701110814.7310-1-abhsahu@nvidia.com>
References: <20220701110814.7310-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f52d75d-a1e5-434a-dff9-08da5b5207d4
X-MS-TrafficTypeDiagnostic: DM5PR12MB1401:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J8FbxU+SOc9yH+1O+LufotCHNx0XAihAMUdae0yXh4U36cSND0C5zV64n74JYgbm5PlntoRLPkc9LicXv8AVJ8vBksWmC/bCA42Htx1nuIpI6sTmly4R1FzK/TCikoAJVl88HyBgJizWNVqRpusfmPlbki8bC6h9cgqrrHIrDvKrXvO5or3obpd/zD3Xish+swG6Pb/USqAYKG0oOfgAsriXxFxwqxHMR1kiXZ7/B93yYn9FSVoSYlLtv0bOhmk2NR486pl7ETHTopSCGrb5vl8if0A6yVmDLGBo2Msngzpi5lC+q0eG8cKCEQcs/nFfRzMnGEkhRZ4ovvzj2h5NSORr0EoVZIXX1nyKY4Ne3iAt8wf3ckagBKXhR1G6ugSUNX9ojx+hiRIZlCY6rs83/j4GLZBQtbtDT7dRaSbW6AUsvMoLZ9QPfJEmIbw2h2pq/pPV1WfapuBApjY9FuVoFvPK/NI4rIgb+0xvniAuoLtE2cBWCNsXpluEFgbkH6TLmuduTZTVGvoF0gU1ANqwkbQBRcsC6l74mmJJP5LsaAZ2vH8NGhkBFWmqNFwuIckwneGO8+9r5IpqCrmM9svJge9qkCdgxKjJ972/cyaDctu+xSsY3CWiahAXCwHbTVtRiTAX9JxIxPh9FpZgKEK0vqsmSM6esJQt9iGr0OYqWquo4zTKeTfAkazX1j9TCtZGTLqFC1rmnOIBHMNYCIi/nwWA9XmFV6OvXiiSU0KdcawCnCpOVNEfA5Cmeo2yvPkX/IT4wqt4Uj4JuY8M44DxXyjnYiWOpCPp0JMeH2dmVW8AbcsiYYGjJ+MiC4sXYl7zzDxUmnsN59SS2CYG5UKAUUN+0KBpWJoQZe1xfeR6ZMs=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(376002)(39860400002)(46966006)(40470700004)(36840700001)(26005)(7696005)(6666004)(478600001)(82740400003)(15650500001)(110136005)(40460700003)(54906003)(70586007)(36756003)(40480700001)(82310400005)(70206006)(316002)(36860700001)(2906002)(107886003)(186003)(1076003)(86362001)(83380400001)(2616005)(8936002)(7416002)(336012)(426003)(81166007)(4326008)(5660300002)(47076005)(8676002)(356005)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 11:08:30.1933
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f52d75d-a1e5-434a-dff9-08da5b5207d4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1401
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds INTx handling during runtime suspend/resume.
All the suspend/resume related code for the user to put the device
into the low power state will be added in subsequent patches.

The INTx are shared among devices. Whenever any INTx interrupt comes
for the VFIO devices, then vfio_intx_handler() will be called for each
device. Inside vfio_intx_handler(), it calls pci_check_and_mask_intx()
and checks if the interrupt has been generated for the current device.
Now, if the device is already in the D3cold state, then the config space
can not be read. Attempt to read config space in D3cold state can
cause system unresponsiveness in a few systems. To prevent this, mask
INTx in runtime suspend callback and unmask the same in runtime resume
callback. If INTx has been already masked, then no handling is needed
in runtime suspend/resume callbacks. 'pm_intx_masked' tracks this, and
vfio_pci_intx_mask() has been updated to return true if INTx has been
masked inside this function.

For the runtime suspend which is triggered for the no user of VFIO
device, the is_intx() will return false and these callbacks won't do
anything.

The MSI/MSI-X are not shared so similar handling should not be
needed for MSI/MSI-X. vfio_msihandler() triggers eventfd_signal()
without doing any device-specific config access. When the user performs
any config access or IOCTL after receiving the eventfd notification,
then the device will be moved to the D0 state first before
servicing any request.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c  | 37 +++++++++++++++++++++++++++----
 drivers/vfio/pci/vfio_pci_intrs.c |  6 ++++-
 include/linux/vfio_pci_core.h     |  3 ++-
 3 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index a0d69ddaf90d..5948d930449b 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -259,16 +259,45 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
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
index 6069a11fb51a..1a37db99df48 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -33,10 +33,12 @@ static void vfio_send_intx_eventfd(void *opaque, void *unused)
 		eventfd_signal(vdev->ctx[0].trigger, 1);
 }
 
-void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
+/* Returns true if INTx has been masked by this function. */
+bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	unsigned long flags;
+	bool intx_masked = false;
 
 	spin_lock_irqsave(&vdev->irqlock, flags);
 
@@ -60,9 +62,11 @@ void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
 			disable_irq_nosync(pdev->irq);
 
 		vdev->ctx[0].masked = true;
+		intx_masked = true;
 	}
 
 	spin_unlock_irqrestore(&vdev->irqlock, flags);
+	return intx_masked;
 }
 
 /*
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 23c176d4b073..cdfd328ba6b1 100644
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
 
-extern void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev);
+extern bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev);
 extern void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev);
 
 extern int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev,
-- 
2.17.1

