Return-Path: <kvm+bounces-4854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80C49818F5A
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 19:11:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E21D6B23C2F
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 18:11:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A2233B2BF;
	Tue, 19 Dec 2023 18:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dpW7youp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2089.outbound.protection.outlook.com [40.107.93.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A723B194;
	Tue, 19 Dec 2023 18:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ebQZEu+WspDP1QYSfz0NnSQ6Kmlyx2BIOznSNVTJzG1L9ffwdGWpk4thDfgz3kOtDTpms9pgAv3rucU5kKuooYc1XNmiyrm0dT2booetnuDHg9F3FJH8GwvJjl38peRrSFsMFe+naaUcZPKRM5iyHXwB/dajMqLk1vJt6me6eu9mLDWbElXUVYp4QY9eD8svzmxnSzTCXNtgMQpFAYagmVhsXvAMLtmOn+E+5zCI5e7z3lKB6XhqXMyshBmCNVoGAgWZJxXe44TNX4ggFasT4ap1grbL94msJSwQjd7tudUTmtpcppsTXE23x4naSvJLrVFDD5qbGfMzeV9g/YN3nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vu78OW1bcKc+D9aGItF8zsUN18eG6wRMeld+vpa5LW0=;
 b=lMbqt7V6fzUUWDy4La4epikpUNAuDR6p8T34EuZcd1WIaKgUyWtwUifzp42p95a/CwoFkAD4sO0uANuSFyZP6tcNwb90d4l7tRlTzZif+b+MS1z048jA46wSz6pKpSv5EEMJ+6y3xUFAslSJ5/8MXxzSkWA/X3er/LbJvQsZkqTrT5m+FD7di2pYTb+s2j8FtSBX+esJ0mlN6niFAnRJiYgkTMtiQYEwWHhO2RloX8QBLjTZNVX7PRP5i1IZZuJhjl00ts0wRr6rt+FTSfELGEhcrH3D7QK+fuLYiCj50e5Afilcvb1QvY/bwYpBBjcRfwvIKw4L1YKGclSGW2/Bkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vu78OW1bcKc+D9aGItF8zsUN18eG6wRMeld+vpa5LW0=;
 b=dpW7youp2vJFWKKGbVx2/ggJ6/JJC9xSTXgX3rGmN0UncB8HReT/IjhQ8kJ3l5CD9anZlDO2mozIFgOG5nkb9DSYfyuYXXW18lkwhSr/HvNSAxYL4J9Hket43AHjJBfzFM/QEw/MfcL6fCJUtHhKTGeX7ZpDGR0dIAf5R5Lwr4dFYGrHpoqv/qWh2l2bOkpTOCe5YVvt9ahv0ivTausimWI1LU3GTs9/5chptyzp5xuSDH7gl7sQIcIaW1WLPZDGvDbbVyayfM+tXn2OPBWX7NfviE2dOUUJ3mYribUAGNZBsnSW5hPe6NP5b1V/bWUIVKk6RZRaNmY1sPfkpwsVjQ==
Received: from BL1P221CA0017.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:2c5::35)
 by SA3PR12MB7922.namprd12.prod.outlook.com (2603:10b6:806:314::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38; Tue, 19 Dec
 2023 18:09:32 +0000
Received: from BL6PEPF0001AB72.namprd02.prod.outlook.com
 (2603:10b6:208:2c5:cafe::a4) by BL1P221CA0017.outlook.office365.com
 (2603:10b6:208:2c5::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18 via Frontend
 Transport; Tue, 19 Dec 2023 18:09:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB72.mail.protection.outlook.com (10.167.242.165) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Tue, 19 Dec 2023 18:09:31 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:09:17 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:09:17 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Tue, 19 Dec 2023 10:09:13 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v4 03/15] vdpa: Add VHOST_BACKEND_F_CHANGEABLE_VQ_STATE_IN_SUSPEND flag
Date: Tue, 19 Dec 2023 20:08:46 +0200
Message-ID: <20231219180858.120898-4-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231219180858.120898-1-dtatulea@nvidia.com>
References: <20231219180858.120898-1-dtatulea@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB72:EE_|SA3PR12MB7922:EE_
X-MS-Office365-Filtering-Correlation-Id: 32a3734e-99f7-4866-031d-08dc00bda66d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6kjW57HZAiO05GgMrFppji681V5qQF0QV7RzqGlK6IbdsnqbsHmnOoSMWtFp3xqZK2MnI1KY+FPoAG2O8W5q5ACo1XpeL51gFB92XDAtdIF3EimFeuebINUmbd/Rwmnh7gagCCakO3j57QcxXOXthVFr0lB+cLw8cMjAd/fLN7LfXg8CXzROLkXVazdKUujip/Mst7NMhjKl/JoUny2rOVpHPXkT1QgZcqG1paaCjRcTz3Q7mr7Fs8Wwx2iOSPboIxmUnok6xN1j7jmKul4BeIduiJsKO1Qd4dE2UFb7lDbmbsjaKEc+08gPMzkL0quQtxa+w8Dlp2JSXReEZ/my0tYrIsKVe1iEDqKhD/gR3RBL4HXCG7ogv7/K0KmNDX2sOmWcRDiF1dXpQcqpUeCwyYbXj/gHIb4+cJFm4w8TKX9Lp2ngU9KTqi+81r7noLAdydjZr9OdQjrKkgTPNy/8ztWSRtq/P5tTIqk3TTk7a9dZYUd2oc6GoWRT2tu3wxFLjnf2roptamN0PYKma7x9L9eqJUswnW6Ossk5/BBB4NVIL0zEyTj3ooo+TxgdOk6w4XHiik0XYw9jLysvo+HLqiU25XBHOrcVoykVIGS5BOO7UvV7XqnzCs2y7zGtDUfmtd2LhYgpJUzQLapY2y0DzK5n5IQliGEWoBew7g/lem2SaYUv1mc6eCoEbH64xukxM5ovcZGCc4lQinBYvvQSTlVvxJ2jY8qzLgm4mKD7SgiqNLVi7W4bwYzlxt8t6hBB
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(136003)(376002)(39860400002)(230922051799003)(1800799012)(451199024)(82310400011)(186009)(64100799003)(46966006)(36840700001)(40470700004)(40460700003)(40480700001)(6666004)(426003)(1076003)(86362001)(2906002)(4744005)(2616005)(5660300002)(66574015)(336012)(83380400001)(7636003)(356005)(26005)(47076005)(36860700001)(82740400003)(316002)(110136005)(4326008)(36756003)(54906003)(41300700001)(6636002)(478600001)(8936002)(70206006)(8676002)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2023 18:09:31.8873
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32a3734e-99f7-4866-031d-08dc00bda66d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB72.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7922

The virtio spec doesn't allow changing virtqueue state after
DRIVER_OK. Some devices do support this operation when the device is
suspended. The VHOST_BACKEND_F_CHANGEABLE_VQ_STATE_IN_SUSPEND flag
advertises this support as a backend features.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Suggested-by: Eugenio Pérez <eperezma@redhat.com>
---
 include/uapi/linux/vhost_types.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_types.h
index aacd067afc89..848dadc95ca1 100644
--- a/include/uapi/linux/vhost_types.h
+++ b/include/uapi/linux/vhost_types.h
@@ -196,5 +196,9 @@ struct vhost_vdpa_iova_range {
  * and is in state DRIVER_OK.
  */
 #define VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND  0x9
+/* Device supports changing virtqueue state when device is suspended
+ * and is in state DRIVER_OK.
+ */
+#define VHOST_BACKEND_F_CHANGEABLE_VQ_STATE_IN_SUSPEND  0x10
 
 #endif
-- 
2.43.0


