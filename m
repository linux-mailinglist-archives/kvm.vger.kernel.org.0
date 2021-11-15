Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0604505A7
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 14:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbhKONkG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 08:40:06 -0500
Received: from mail-mw2nam12on2043.outbound.protection.outlook.com ([40.107.244.43]:50706
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231229AbhKONj5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 08:39:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ntIel/nquH2qf+Jvh4rMbm9P2qvHaxhFhVpDBf5KsLkmFw7RZWHOR4oUS67qB3g2W+hobRrIiYLKH6uC/v6K/M++TG1e7N3NTOyM/rbqrsjO6m9MsWe84lIYi+XXZ2+UAa4aAFVEoHZKIq4V9yPYMc2GMds7PrNzxxxS9yHGi9p779JJknAuo1pv3GaZCgif/7wZI+BZcS6Lj82clhnodsOWNM7F2zquT6WF2xess/HqpDzmcDIiJ4CN6FZPP+gkFDc5vrCtvd8EZnF33VPY/7+5Zrwa1T4Pc0MmpEg6LiF4ClhkqHKhmcEDd8dVolyJPHufTgkzqnUx71zOiI1vqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YCZ3YyQimU7Vjcq5jwhQg/CM4RuGF+ulw/K083/tF8g=;
 b=gx6XP9e0Di1+cOLSw5cZOrW7OKUBZp8BB+GKEm9whiPwAQ7npJm3w6JmtPVFActEdZ4IfFXFij7OgfrMPPF6cbq94Un0p2tP0L8os9QejoeNQjiTt58xPV2jhRSo0Bcy3f1X94i9EQ5EBLtLxRXeo74iEK4Kgln869MolzXojx9Iir+65ITI4AnW4JD0QE57SofGBBBMYQbB5Yx48KUrL58hREex1YlShydLaho40dDiqJ2LF6rS+CSmVBTKG0m8Oa8LdqR1LXpr3EKCnrKaD57wf/Tz/qPZNtqGp8RT4nDLDpVw0cB4i6HtyUIl36oCGhJu8GLQlqbz650nZZ+/pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YCZ3YyQimU7Vjcq5jwhQg/CM4RuGF+ulw/K083/tF8g=;
 b=IJLa6QXcBHhm28qcu8Ygu5ou93Zo/Kb/ElJ2jd2nY6LsGOUJ53GSS8bMMvwTetZU/eZ47Y6e9Mm38ciJBWGphh4kAR8uIDaW4qkFxC37Hq0EdVKbscmVrcVRiWAnCv2ryJybqLMiMYE04RJqmmZ+4ebW+Ck5eqcLRFfWoivxb+ojvpv3BrWi3vVCAt/pt0Mys19whZSPOqWg05ZigrcZpioYqNaeYXugEeNnI2L+6zzi7jYIkx/eQj9UyLnXPq3UvV+kYlhfnRSxe6vUf21KWeUqYaoNCOppCQf7NsN+2ybU35kwoBx+6jX6INGlooNQBlVMP24xXuUm5diDVnRqFg==
Received: from MW4PR03CA0153.namprd03.prod.outlook.com (2603:10b6:303:8d::8)
 by MWHPR12MB1213.namprd12.prod.outlook.com (2603:10b6:300:f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Mon, 15 Nov
 2021 13:36:57 +0000
Received: from CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::2) by MW4PR03CA0153.outlook.office365.com
 (2603:10b6:303:8d::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.25 via Frontend
 Transport; Mon, 15 Nov 2021 13:36:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT065.mail.protection.outlook.com (10.13.174.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4690.15 via Frontend Transport; Mon, 15 Nov 2021 13:36:57 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 15 Nov
 2021 13:36:56 +0000
Received: from nvidia-Inspiron-15-7510.nvidia.com (172.20.187.5) by
 mail.nvidia.com (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.18
 via Frontend Transport; Mon, 15 Nov 2021 13:36:52 +0000
From:   <abhsahu@nvidia.com>
To:     <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Abhishek Sahu <abhsahu@nvidia.com>
Subject: [RFC 2/3] vfio/pci: virtualize PME related registers bits and initialize to zero
Date:   Mon, 15 Nov 2021 19:06:39 +0530
Message-ID: <20211115133640.2231-3-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211115133640.2231-1-abhsahu@nvidia.com>
References: <20211115133640.2231-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c92ffb91-1e0d-4fb9-ef54-08d9a83cfe98
X-MS-TrafficTypeDiagnostic: MWHPR12MB1213:
X-Microsoft-Antispam-PRVS: <MWHPR12MB12132997B31875BE90A98883CC989@MWHPR12MB1213.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S2lEJCkLu5nRVNqb7CDQwsy8O/t7ZnUMyLqW3zFy7EsHl/eUp4F5ln84+4Q7hak++m9eDG5XZ+F1zPPtAbMnAKlcG8amtboiTaE0Aa6yQyaRyAyurb8rbzaamAQgFXMFAwM/0KYDsMBXrDzZ2ywkIB5LddH3H574gbWNeW8DIYaIYfDgF3thJymKML3RROVA4TwZQlzGIb/z6ZNcb1i/f3NJIQkbNBiQ/s1etGBbtRs4ih9KUDE6RJRi1XY7Z42693uYVjTY8RCkiBl1MkgfeXyLOzqjnXuWexGB989ASh/YfGxI7uKCLpWlkRSXfi/oJ0a4rXm2YhHjgnXZ4cZalBcEbuhtdFLFy1b3FG7L4vw0BAtaoXnCGXZAWCe+y70aUVEisDStRNlqSt+i+C2fXmPrPS60nzmFFwBVY3pc8MEldRX+evR1jGEZd8WDvGlMAvFx1bdZJgQc14Zsu9khfrcun6ISJoZvxZFUcCl2FHVeQbCeYRCdrOLn5gZmTBhJmYJTvEzyUilNvzwlHbadCQf4hj+yWAaUR/y8nq+m1rD2jAeTCmZqRWbaRTmm7rW8H1REHOsJSp2y/9/0MGxSN5ryzjytSK7H92MaY15kCSY5bORbo7Houc1LmhOH1XEeA8JRgfWw/zWLSRN2VrDg56LmGjj8aRIRVvoZ2lkpxnvf4rhlyPP+v59kannpjYGTH6c1+z1W4frqoULzUMUEgw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(36860700001)(6666004)(336012)(2616005)(7636003)(83380400001)(5660300002)(8676002)(356005)(7696005)(86362001)(36756003)(426003)(47076005)(8936002)(508600001)(82310400003)(70206006)(70586007)(2906002)(2876002)(107886003)(54906003)(26005)(1076003)(36906005)(316002)(110136005)(186003)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 13:36:57.1476
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c92ffb91-1e0d-4fb9-ef54-08d9a83cfe98
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1213
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Abhishek Sahu <abhsahu@nvidia.com>

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
 drivers/vfio/pci/vfio_pci_config.c | 32 +++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 6e58b4bf7a60..fb3a503a5b99 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -738,12 +738,27 @@ static int __init init_pci_cap_pm_perm(struct perm_bits *perm)
 	 */
 	p_setb(perm, PCI_CAP_LIST_NEXT, (u8)ALL_VIRT, NO_WRITE);
 
+	/*
+	 * The guests can't process PME events. If any PME event will be
+	 * generated, then it will be mostly handled in the host and the
+	 * host will clear the PME_STATUS. So virtualize PME_Support bits.
+	 * It will be initialized to zero later on.
+	 */
+	p_setw(perm, PCI_PM_PMC, PCI_PM_CAP_PME_MASK, NO_WRITE);
+
 	/*
 	 * Power management is defined *per function*, so we can let
 	 * the user change power state, but we trap and initiate the
 	 * change ourselves, so the state bits are read-only.
+	 *
+	 * The guest can't process PME from D3cold so virtualize PME_Status
+	 * and PME_En bits. It will be initialized to zero later on.
 	 */
-	p_setd(perm, PCI_PM_CTRL, NO_VIRT, ~PCI_PM_CTRL_STATE_MASK);
+	p_setd(perm, PCI_PM_CTRL,
+	       PCI_PM_CTRL_PME_ENABLE | PCI_PM_CTRL_PME_STATUS,
+	       ~(PCI_PM_CTRL_PME_ENABLE | PCI_PM_CTRL_PME_STATUS |
+		 PCI_PM_CTRL_STATE_MASK));
+
 	return 0;
 }
 
@@ -1412,6 +1427,18 @@ static int vfio_ext_cap_len(struct vfio_pci_core_device *vdev, u16 ecap, u16 epo
 	return 0;
 }
 
+static void vfio_update_pm_vconfig_bytes(struct vfio_pci_core_device *vdev,
+					 int offset)
+{
+	 /* initialize virtualized PME_Support bits to zero */
+	*(__le16 *)&vdev->vconfig[offset + PCI_PM_PMC] &=
+		~cpu_to_le16(PCI_PM_CAP_PME_MASK);
+
+	 /* initialize virtualized PME_Status and PME_En bits to zero */
+	*(__le16 *)&vdev->vconfig[offset + PCI_PM_CTRL] &=
+		~cpu_to_le16(PCI_PM_CTRL_PME_ENABLE | PCI_PM_CTRL_PME_STATUS);
+}
+
 static int vfio_fill_vconfig_bytes(struct vfio_pci_core_device *vdev,
 				   int offset, int size)
 {
@@ -1535,6 +1562,9 @@ static int vfio_cap_init(struct vfio_pci_core_device *vdev)
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

