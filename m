Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975BE3F3FED
	for <lists+kvm@lfdr.de>; Sun, 22 Aug 2021 16:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233697AbhHVOiA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Aug 2021 10:38:00 -0400
Received: from mail-dm6nam11on2059.outbound.protection.outlook.com ([40.107.223.59]:26944
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233642AbhHVOh7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Aug 2021 10:37:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sp12XYvQYvw3v4VgsanWVnTpaTqn343nPWoEaWn4BMGMcb0sPWKxroHtlT+gGPH3a6EuNTVZ/T9GO6n+h6rQ0PzfXqoFT5VsPYUaBpY4foPp01O9SxeKnctcC7Q4TJuVnVHYjqUgn6jf0KcGf/rfCqZ0Nx4KNx3E8The5h1/axu16/7ybdl1EZD6BB98dWtVHC4g0Dur/vTQHL+i+5B3bSb6p5I6jElVN2UjsQJhitQeUbT1VHvGTT5pEWOqgWIOZlxtobC8kvn2qj+jU1n/DRmYRCXchIsIUFP/XoR7HjW93oJpH0f+bpRmMQbU+ABWKfbmFsML/31vLLffNG+V4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EA12dOSs+X500lgNhQm9waVsEnhHX7aMIyxRdvZyw+8=;
 b=GDw88CzqLb9Z+OhDvCOmkbymWyD4oCqFnp0kWjyIcLuUmFi0+laxcD5sZMzgZJxnEf+AMwz3Yp+bLvKVBereWOHTUvORuJzXyeNFSCe/2GpRsEr6w1aAZswbcDkI3zmhBqBzkAjWqpARE+RE9FVptOQEuS52vM7+X3wp00t/UUJXzWocjOi6M5Lsx3l09bEupHjStzGXMrBNDQuA9yR5tXH0MZLYHolbc2EtGU7L7xhwP9tyk1mwwQJ3UHKNuyaA6mNEwM6is1u1LdGVaTTNwedGjSoz3m0xJvpSNChovAUyfgTC8XDTWDPLJMF7j4ZkTNHGFEPdhb9b/V1O+jEsbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EA12dOSs+X500lgNhQm9waVsEnhHX7aMIyxRdvZyw+8=;
 b=h3wNJ/QLGgvjwb3O1FIUiDimAlDW0I987If8emvh1oh/+Qq58FKNqs++ic2m29cuXxfICER3W3B2KX/7nDLATpkQ7Z8OiahQNuX9WXSxRlrmnTiKP3h4vsnwyxcqfH1lnC9WhpILC+KJNsqs+px1sZjSbCjRSzSmhLodmUlXSPshSGxQlXiFaAj+d22YOnKhy74QGMi76sCzUy7r8vQLYlN046tnKWpdHjHKsFIPkOyp7TfP35MIKObCxPcHMAfUzB/04mgvRzNc/6jFPSbBwBWcfiRKdzYBkR/6Z6vlTFtepIWugeYsQ0V+HfGRpLgQdGW5LZZyaVknubaa+oCTuw==
Received: from DS7PR06CA0002.namprd06.prod.outlook.com (2603:10b6:8:2a::16) by
 MN2PR12MB4221.namprd12.prod.outlook.com (2603:10b6:208:1d2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Sun, 22 Aug
 2021 14:37:16 +0000
Received: from DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2a:cafe::70) by DS7PR06CA0002.outlook.office365.com
 (2603:10b6:8:2a::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Sun, 22 Aug 2021 14:37:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT040.mail.protection.outlook.com (10.13.173.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Sun, 22 Aug 2021 14:37:16 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 22 Aug
 2021 14:37:15 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 22 Aug 2021 14:37:12 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <bhelgaas@google.com>, <corbet@lwn.net>,
        <alex.williamson@redhat.com>, <diana.craciun@oss.nxp.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <masahiroy@kernel.org>, <michal.lkml@markovi.net>
CC:     <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, <mgurtovoy@nvidia.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <leonro@nvidia.com>
Subject: [PATCH V3 05/13] vfio/pci: Include vfio header in vfio_pci_core.h
Date:   Sun, 22 Aug 2021 17:35:54 +0300
Message-ID: <20210822143602.153816-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210822143602.153816-1-yishaih@nvidia.com>
References: <20210822143602.153816-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed252cb7-631c-4227-01c8-08d9657a56c4
X-MS-TrafficTypeDiagnostic: MN2PR12MB4221:
X-Microsoft-Antispam-PRVS: <MN2PR12MB422173A3574C65DDE55CDFD8C3C39@MN2PR12MB4221.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ERs4iAepDtfLAQUqJeZEZZK0HfE9avthFJ4qRTIMqMSI/xpjqIgthv8yvMBgVKZQlVOc7ran6MeexAIMbuJ5Zn8+xOwiYWGjMqWZYO/S6PuLdZ9OhH/PU9t/LC4+qrEv7ck/ESNhto8fcL4M10KUk1zQ9fGKmJUC6TYxseYT/YC4Rh/VQvPJSCmgJ+FB7rzx/6Nb/36nRfilRRWzjtFv4UMjkEnKAPZCJlBeQ9oP6iE/FoUfo79UhfoWnGOk62LuL8uH9ut+mjj9pHaXg0U6X0fkrbL8xja8raXlAz+6rY4HMJ6JB7fMhqzysuhmFUS9xdq7ZRtWvXE6WFcMBt3MgLU1Ny6K0RUkXlcyadHzhSTHv5kLEpCDgJmaWOqnhcRzuW2g338XTP3MQoy1Zb0DTwAPbelGhlRst54uowHilQTxdhifdks8Gf05n56Xha+upYtdxhAiPN1msMaEZb4lA+Idmu0w9557J/cE+4tJm2sOYz3+y7JYrLpR/g+qDL66Wim6sghnRPmvTBVhoqj+GaqYcqpvyu3rgyz0wj12VNAb2iGOpyA5S1EqIdyjBt40Utm1La/UE+9MFovpt/jBp0qCHh/8WY4NLloOTx89fpzFBojvsEyjbjalc+sdId569DFe/lU/daPAQWd0k6AM1HwFCboWTzHmx2pI1rWnrfrN7mybSOqL2JhRY6BKrZ4DXjtUUt3jnyY9K7acU4R6pCuDYrZqlNus7ympbSfThFs=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(346002)(396003)(36840700001)(46966006)(6666004)(47076005)(83380400001)(107886003)(36756003)(426003)(70206006)(82310400003)(26005)(86362001)(36860700001)(316002)(7636003)(82740400003)(8936002)(2906002)(5660300002)(110136005)(54906003)(7696005)(1076003)(4326008)(356005)(36906005)(70586007)(2616005)(186003)(8676002)(478600001)(7416002)(336012)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2021 14:37:16.3818
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed252cb7-631c-4227-01c8-08d9657a56c4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4221
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

The vfio_device structure is embedded into the vfio_pci_core_device
structure, so there is no reason for not including the header file in the
vfio_pci_core header as well.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 1 -
 drivers/vfio/pci/vfio_pci_core.h | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index ee5c8fe2a324..94f062818e0c 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -23,7 +23,6 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/uaccess.h>
-#include <linux/vfio.h>
 #include <linux/vgaarb.h>
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
diff --git a/drivers/vfio/pci/vfio_pci_core.h b/drivers/vfio/pci/vfio_pci_core.h
index 2ceaa6e4ca25..17ad048752b6 100644
--- a/drivers/vfio/pci/vfio_pci_core.h
+++ b/drivers/vfio/pci/vfio_pci_core.h
@@ -10,6 +10,7 @@
 
 #include <linux/mutex.h>
 #include <linux/pci.h>
+#include <linux/vfio.h>
 #include <linux/irqbypass.h>
 #include <linux/types.h>
 #include <linux/uuid.h>
-- 
2.18.1

