Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3290D529EB0
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 12:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbiEQKC5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 06:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiEQKCs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 06:02:48 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F03472CDE8;
        Tue, 17 May 2022 03:02:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JLaTZIgPYGPqOxeaOb+l7ofMDrtEmXqEq/DAq7MxMaUDJ7ta6nLsPfAklziMALJzhTiIKz1aa3ul7Il2cMd7pdvgbdqBd8kk0GqwvEvyLK00bcIObIe5Cv6LKOaCaBKsGyGoC+F+MZZAZwxAZq2myaBOrFyQXW5q21RCsPWzDFHATBQNEwQzstzeXfeK6Wm+zCcCnx/iY33Pdg9XdTMDq32C2S4VtXuvuy/yQ6y7XiT7AQHHO1rRzXOY32pPjC6jXtzuXZlrqh+OfSQAihidMr1DLbUx0zpL9lu06DZNPN6ijEQTl08mFfcBfNcl3mQsjrE05xraRa3Gm5IS2HIfiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ftJwlz+hNN8i20Tovb9/C+Z9VCP6pdxowx/RRmpe7nU=;
 b=hr3mv/21ukNPGc1Jaz6DBeWWZKDePBtVsdZ0gtMCGeNwAe2xDsMr9XQBi5mRBmxij9i2mamMxpEh9xQZ0SZpegjLwGE1b+sWQTLJwl6KS79RkcKxub/joj0BAt0JjYw7V4cITkHIvATNyIDwAmZq2OQlynKGPc2zaoh0r03W/QgCKGwGT5Gc/xFJ4M1SylorGD7Z32Ya1vnform8SnERfAON+1Zxm+G+ssYGj/B0WVB4KMJpOwQ9XqQ2FDfPp/uOlHMZIgGPuPpszNPmVE3e58dBxP/pcaKHPSMkZbEHdGqEuE0qD1qezsaCcrlYjYieK0xVfsqqJ0CA2cPLDW5dHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ftJwlz+hNN8i20Tovb9/C+Z9VCP6pdxowx/RRmpe7nU=;
 b=pZqw+S6XMbUATUdar2j9bRVflL2WjWjTlXYPw3QbYeXYoAYW/Gh4kYXkfLznz5v+QzhgvN2nKzk6eFV+qrfpI38NOr1/KB43hj58Vd8qnbzi0hsP1QAmOalFK0pv4/gfgPqcMiizGTC2yVboOHwKHKZUmscqaraT/EPaKvE4phjz1vvKTMfmbjZQwWBh9Wu0xqrnvTT9oJ+UrRH9Nd3j31wjpIofRfCEmnBmenygbBeSGZIcNhvd/jHrdfBvuVoYuEeBJqXmjFMouIpeFL6BuUn4hXwuo312esRz0mCvL7hmnEkZ6sy4C4LpnjZ48LYyEtjpi9zOa87Lg02OFCoB8g==
Received: from MW4PR04CA0274.namprd04.prod.outlook.com (2603:10b6:303:89::9)
 by MN2PR12MB3375.namprd12.prod.outlook.com (2603:10b6:208:cc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.17; Tue, 17 May
 2022 10:02:45 +0000
Received: from CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::23) by MW4PR04CA0274.outlook.office365.com
 (2603:10b6:303:89::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14 via Frontend
 Transport; Tue, 17 May 2022 10:02:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT041.mail.protection.outlook.com (10.13.174.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Tue, 17 May 2022 10:02:45 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 17 May 2022 10:02:39 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 17 May 2022 03:02:38 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Tue, 17 May 2022 03:02:33 -0700
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
Subject: [PATCH v4 1/4] vfio/pci: Invalidate mmaps and block the access in D3hot power state
Date:   Tue, 17 May 2022 15:32:16 +0530
Message-ID: <20220517100219.15146-2-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220517100219.15146-1-abhsahu@nvidia.com>
References: <20220517100219.15146-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd361098-0c30-4ac9-ffa4-08da37ec63d6
X-MS-TrafficTypeDiagnostic: MN2PR12MB3375:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB337561191AB66DEC67F756A9CCCE9@MN2PR12MB3375.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z8mCICEDaOF5Nvx+rsybOi+4dZ4sr6qnFCcJXCgMsEo6uSc5/uqcJ0HkKHa2Zvbvw4KxoQjnZ0ctgInMpPh6ZFO2+srr0oZLYQVNJ3ozjRjJov25/ZHs5xCk+CwzEKVbnj9TPvPJSJJtyJHZiWwt1UG0LiYY5+WaFfV59yO9fiOri+/fR6fEkqUCSCPc6hchO1ub72YuHGpPCf+6k51XjP8BCAl/2Q7lomu6FjLhZDdbILwYs+F+hQ6CK9CGweFCNkjiYaSvxY1VIslnhV0NxJQPUCrtUMwnrzH3ocnl1Fmo+woeB1v2soP3zaQ/35SvNK+ZvDMigQnQ1Gpj2ImOnbT2CboklU6Ez4lNN//zRP7j7uh5P1UMHbid/0NOBU66XRNF8IX1da27SnK8yu3hV62Lq5JL3y7tlDJsuKpcCoWFgd8Q24+u/62hJ46kKGiSOETSBGoZrjBXAKu1lBNz9cXDKWOKGmSE4754pMD96aG4vtyQN4F2DTYbPW4c+HS5CJbYQkclA5tltUbJqMajkGSW0NB1Knh/SCIriTLO+zF0azH56IksLAN0+BPxZ+XotX0lgBuyLpvxYk5fFxf1Q/Rmn2dtzSKrV6c+wuGrhIM3RHr6O9YUJnMJBoRNbLwQUaUV6tw3UuAoO970UfQlOFbDAOiUQJTsfW6+fPwPLlLrMtCD79Kb2E84wduzRW1mMbndVw/019+ZnXXPlwIj88Lg7Ljf76zAoEzkgc0guk4=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(316002)(7696005)(82310400005)(110136005)(186003)(1076003)(8676002)(83380400001)(2616005)(336012)(426003)(86362001)(6666004)(70206006)(107886003)(47076005)(81166007)(26005)(7416002)(5660300002)(40460700003)(8936002)(70586007)(54906003)(36756003)(36860700001)(4326008)(356005)(508600001)(2906002)(32563001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 10:02:45.1784
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd361098-0c30-4ac9-ffa4-08da37ec63d6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3375
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to [PCIe v5 5.3.1.4.1] for D3hot state

 "Configuration and Message requests are the only TLPs accepted by a
  Function in the D3Hot state. All other received Requests must be
  handled as Unsupported Requests, and all received Completions may
  optionally be handled as Unexpected Completions."

Currently, if the vfio PCI device has been put into D3hot state and if
user makes non-config related read/write request in D3hot state, these
requests will be forwarded to the host and this access may cause
issues on a few systems.

This patch leverages the memory-disable support added in commit
'abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO access on
disabled memory")' to generate page fault on mmap access and
return error for the direct read/write. If the device is D3hot state,
then the error will be returned for MMIO access. The IO access generally
does not make the system unresponsive so the IO access can still happen
in D3hot state. The default value should be returned in this case
without bringing down the complete system.

Also, the power related structure fields need to be protected so
we can use the same 'memory_lock' to protect these fields also.
This protection is mainly needed when user changes the PCI
power state by writing into PCI_PM_CTRL register.
vfio_pci_lock_and_set_power_state() wrapper function will take the
required locks and then it will invoke the vfio_pci_set_power_state().

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_config.c |  7 +++++--
 drivers/vfio/pci/vfio_pci_core.c   | 16 ++++++++++++++++
 include/linux/vfio_pci_core.h      |  2 ++
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 6e58b4bf7a60..d9077627117f 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -402,11 +402,14 @@ bool __vfio_pci_memory_enabled(struct vfio_pci_core_device *vdev)
 	u16 cmd = le16_to_cpu(*(__le16 *)&vdev->vconfig[PCI_COMMAND]);
 
 	/*
+	 * Memory region cannot be accessed if device power state is D3.
+	 *
 	 * SR-IOV VF memory enable is handled by the MSE bit in the
 	 * PF SR-IOV capability, there's therefore no need to trigger
 	 * faults based on the virtual value.
 	 */
-	return pdev->no_command_memory || (cmd & PCI_COMMAND_MEMORY);
+	return pdev->current_state < PCI_D3hot &&
+	       (pdev->no_command_memory || (cmd & PCI_COMMAND_MEMORY));
 }
 
 /*
@@ -718,7 +721,7 @@ static int vfio_pm_config_write(struct vfio_pci_core_device *vdev, int pos,
 			break;
 		}
 
-		vfio_pci_set_power_state(vdev, state);
+		vfio_pci_lock_and_set_power_state(vdev, state);
 	}
 
 	return count;
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 05a3aa95ba52..b9f222ca48cf 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -255,6 +255,22 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
 	return ret;
 }
 
+/*
+ * It takes all the required locks to protect the access of power related
+ * variables and then invokes vfio_pci_set_power_state().
+ */
+void vfio_pci_lock_and_set_power_state(struct vfio_pci_core_device *vdev,
+				       pci_power_t state)
+{
+	if (state >= PCI_D3hot)
+		vfio_pci_zap_and_down_write_memory_lock(vdev);
+	else
+		down_write(&vdev->memory_lock);
+
+	vfio_pci_set_power_state(vdev, state);
+	up_write(&vdev->memory_lock);
+}
+
 int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 23c176d4b073..8f20056e0b8d 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -189,6 +189,8 @@ extern int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
 
 extern int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev,
 				    pci_power_t state);
+extern void vfio_pci_lock_and_set_power_state(struct vfio_pci_core_device *vdev,
+					      pci_power_t state);
 
 extern bool __vfio_pci_memory_enabled(struct vfio_pci_core_device *vdev);
 extern void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_core_device
-- 
2.17.1

