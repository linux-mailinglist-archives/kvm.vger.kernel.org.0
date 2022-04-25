Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABAF850DCA4
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 11:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238340AbiDYJab (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 05:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237104AbiDYJ35 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 05:29:57 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2089.outbound.protection.outlook.com [40.107.220.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A165598;
        Mon, 25 Apr 2022 02:26:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tpl9m74kzedAseSsosC47E5P297qj7bGdo6rA4MgpQ4k7RB6TbJlltMnVYjPb5ViOp3zeGi0gLtmzLfZhIPWeu6fn7PzvqG0PyvD+kdvRtF0ADwvbtOr5oLigFJLfbxJHDDcpj08GmeW2ba5Fqc+YjImjXAkdgaKGuqRUwlXAJpdKc7eMQfGZ+7IKCOiz/KHWr3/Q/v08O3V0ELewITwOXDvfRfV3NCpFfgc5ZyBuVTvZAeLYfXv2VS67Fp/1vGSvy55+uxW/Z1BoM9NodA9JVYoiowT9ONGQWSyM+WFuVIlNNvD6Mxil/vNWKp5ueR6Fqhd82IVb1rUQ5HV8h86+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XF4DQJwVPGO1/HrAGjYmvpK5TFkOTisofm1vz5hCgQs=;
 b=E/QSbr+n9YmON7o5zU6QP1P76iBAaFowysocd+eOd6PdEFoJN/+wRwpNdxEG5rmfphn6Y9cL+0eOCA5xUbmxv1Zizl9/pghQD/G94H8mw31ntCo6bLYaknpQij6lWJMbRujS721xTwW2uZmVj55/ABpQ8pIVdmO4TkS2KPkNrv87PfSlZ5N4dCJRiTT+HMU1ZxSQ12q7XqFJTLAnB/6es9GGTuFmqiylDguAeGFY1g+PiOAKxLVU8S8ZagGv94XOjvjZQZ4b3H41qKKGBd36Otxl5ATreEATpe+bisXrOVsZK+LJ0k/+EefYqhxalp792waKuU5sZ7tRenHlKk+aYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XF4DQJwVPGO1/HrAGjYmvpK5TFkOTisofm1vz5hCgQs=;
 b=AnHLXA/8BkqUbNzU8K3ITMs4ZiTbtW3Tq10lumydYDC2vaMOCXGQ6mD1SV7W/deogJzBr1//oWdDTM524yKsqNKiGReLGhySn/SmPJcpfFMwCEmKEHLtxxqByHt4Qu8bqSvaPgDs+RUdXmEZ6FEHTRglouhWUfVSTocq4LsgMLcM7VmGTqlx8a8LvH1R5VcUPi+sy13eHCqNrlXOrJ7ZgiBpXTgR1IFkfDEaO/KEFtdcRhcg6zm509lbiK5m/88+8jL7obXygL7W6O270bt7H9qUf0Ix0w5HlvEBt9SudfLggqGiMpmnYXr9bvV0CKJznjQBMMdLdIO5X0S4q3Q6BA==
Received: from BN9PR03CA0874.namprd03.prod.outlook.com (2603:10b6:408:13c::9)
 by MWHPR12MB1837.namprd12.prod.outlook.com (2603:10b6:300:113::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 25 Apr
 2022 09:26:47 +0000
Received: from BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13c:cafe::5d) by BN9PR03CA0874.outlook.office365.com
 (2603:10b6:408:13c::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15 via Frontend
 Transport; Mon, 25 Apr 2022 09:26:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT050.mail.protection.outlook.com (10.13.177.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Mon, 25 Apr 2022 09:26:47 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 25 Apr
 2022 09:26:44 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 25 Apr
 2022 02:26:44 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 25 Apr 2022 02:26:39 -0700
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
Subject: [PATCH v3 3/8] vfio/pci: Virtualize PME related registers bits and initialize to zero
Date:   Mon, 25 Apr 2022 14:56:10 +0530
Message-ID: <20220425092615.10133-4-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220425092615.10133-1-abhsahu@nvidia.com>
References: <20220425092615.10133-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c66211fe-47ed-4316-15e8-08da269db86a
X-MS-TrafficTypeDiagnostic: MWHPR12MB1837:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB183766640F88D22136BBCA94CCF89@MWHPR12MB1837.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GX4aUNa4C/6x1NkGCtoVuphpEzOMPPYvVg/CjZwtlMfpNAzH7Vod7jd3P0ks/m8fCE24JEAN3Ll1wWfcbOkPaxnuSWAfB7eZKQJeX3bKmVgnrRG+r2IJH8G9P9O0i09k7cNeSDuuJq5syvlfRKC+jwso405Hrucnwqta0FUvOGcJNeV6SIJJLva/BzJAgm8zvdkI92vqSY2UoA5itCz+Uz81LdP92LyC1L9jQlqg/IgKWRljJk5EpCVYVkHATJ7MZnTiAbjPGpxhujtx4g4P5gFXptF4MWJ+0HdAW/vJYNZCv6Ld1kTaaaB2ndKIMrcWNxj55KHvY8UzL9Qveihk5hQ4xzwQuAmRlobLJcFy1MQTiUE77C99H0TNiHyNB7vHsOpgWlbji+vFhIBhJE2MjYOLbRlXMWMdQ30H5DS9B0EdSm0l+dGdVwCE3ckruptl7NBTM6Efm2fEfhDa3lt5Jf5X3BkrSVetVZKVhjeT5oCB5qSl/o3zB9MAhii8lRzRjKCOl52oUE4jpWL30+jXae7rEu8bPRHXqxsh6JYjyt6aOQgHjTmIGPNkl3GTTmrlJQptlTVhBkrjB+PnLQVmIUEVRLfP1BMS8fgrnRSSjbQgrqJtUhq0LNUszajtqZn+y6MaFjmCDsBsitBhDBYOP+MLj1b56P9jaZSi3+upC3JlwjVuyHhkzePlSF6wAg3JpaLllY9GW5XLA/f7L5kDjw==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(83380400001)(2906002)(70586007)(6666004)(336012)(508600001)(426003)(316002)(8676002)(4326008)(107886003)(1076003)(2616005)(8936002)(5660300002)(7416002)(7696005)(40460700003)(47076005)(86362001)(70206006)(26005)(186003)(54906003)(81166007)(110136005)(356005)(36860700001)(82310400005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 09:26:47.0309
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c66211fe-47ed-4316-15e8-08da269db86a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1837
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If any PME event will be generated by PCI, then it will be mostly
handled in the host by the root port PME code. For example, in the case
of PCIe, the PME event will be sent to the root port and then the PME
interrupt will be generated. This will be handled in
drivers/pci/pcie/pme.c at the host side. Inside this, the
pci_check_pme_status() will be called where PME_Status and PME_En bits
will be cleared. So, the guest OS which is using vfio-pci device will
not come to know about this PME event.

To handle these PME events inside guests, we need some framework so
that if any PME events will happen, then it needs to be forwarded to
virtual machine monitor. We can virtualize PME related registers bits
and initialize these bits to zero so vfio-pci device user will assume
that it is not capable of asserting the PME# signal from any power state.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_config.c | 33 +++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index dd557edae6e1..af0ae80ef324 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -755,12 +755,29 @@ static int __init init_pci_cap_pm_perm(struct perm_bits *perm)
 	 */
 	p_setb(perm, PCI_CAP_LIST_NEXT, (u8)ALL_VIRT, NO_WRITE);
 
+	/*
+	 * The guests can't process PME events. If any PME event will be
+	 * generated, then it will be mostly handled in the host and the
+	 * host will clear the PME_STATUS. So virtualize PME_Support bits.
+	 * The vconfig bits will be cleared during device capability
+	 * initialization.
+	 */
+	p_setw(perm, PCI_PM_PMC, PCI_PM_CAP_PME_MASK, NO_WRITE);
+
 	/*
 	 * Power management is defined *per function*, so we can let
 	 * the user change power state, but we trap and initiate the
 	 * change ourselves, so the state bits are read-only.
+	 *
+	 * The guest can't process PME from D3cold so virtualize PME_Status
+	 * and PME_En bits. The vconfig bits will be cleared during device
+	 * capability initialization.
 	 */
-	p_setd(perm, PCI_PM_CTRL, NO_VIRT, ~PCI_PM_CTRL_STATE_MASK);
+	p_setd(perm, PCI_PM_CTRL,
+	       PCI_PM_CTRL_PME_ENABLE | PCI_PM_CTRL_PME_STATUS,
+	       ~(PCI_PM_CTRL_PME_ENABLE | PCI_PM_CTRL_PME_STATUS |
+		 PCI_PM_CTRL_STATE_MASK));
+
 	return 0;
 }
 
@@ -1429,6 +1446,17 @@ static int vfio_ext_cap_len(struct vfio_pci_core_device *vdev, u16 ecap, u16 epo
 	return 0;
 }
 
+static void vfio_update_pm_vconfig_bytes(struct vfio_pci_core_device *vdev,
+					 int offset)
+{
+	__le16 *pmc = (__le16 *)&vdev->vconfig[offset + PCI_PM_PMC];
+	__le16 *ctrl = (__le16 *)&vdev->vconfig[offset + PCI_PM_CTRL];
+
+	/* Clear vconfig PME_Support, PME_Status, and PME_En bits */
+	*pmc &= ~cpu_to_le16(PCI_PM_CAP_PME_MASK);
+	*ctrl &= ~cpu_to_le16(PCI_PM_CTRL_PME_ENABLE | PCI_PM_CTRL_PME_STATUS);
+}
+
 static int vfio_fill_vconfig_bytes(struct vfio_pci_core_device *vdev,
 				   int offset, int size)
 {
@@ -1552,6 +1580,9 @@ static int vfio_cap_init(struct vfio_pci_core_device *vdev)
 		if (ret)
 			return ret;
 
+		if (cap == PCI_CAP_ID_PM)
+			vfio_update_pm_vconfig_bytes(vdev, pos);
+
 		prev = &vdev->vconfig[pos + PCI_CAP_LIST_NEXT];
 		pos = next;
 		caps++;
-- 
2.17.1

