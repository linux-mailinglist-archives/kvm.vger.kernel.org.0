Return-Path: <kvm+bounces-3841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30FF980857C
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 11:30:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1CC27B21EEA
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 10:30:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46A19381A8;
	Thu,  7 Dec 2023 10:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qNuUPtcB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2063.outbound.protection.outlook.com [40.107.92.63])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6B7D4B
	for <kvm@vger.kernel.org>; Thu,  7 Dec 2023 02:29:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eU8Rij/LdLz0+zTWhy6hBgYGn+RVjUBaFkwOzAWIFY8HRzxXxb/x4OnFvM5jGPiX1z9qNNUCAYZMul0etLzhFrYtJF3c9eJR2gSYU5MZDES/qSJZ+9qw80qSmmhlQbUSaIucj49L2CRveJ89iosMvPjKgJTBbeNSZ22ay0v6ofOIYN8p+fOqChti1kRf8FAvVq43P+W/onEf968bZQGDGgHdPqJI1tGt6XAzGqCzXIEgQ+/lDqDZUv7zx3BlG7LT6r+UJfP2F6lvx5v1LvV+JXkprpNla5Lfdv5+M4rk9THIt3nDdRBg8mOr46Nu3FLDjWtOQrGffnsG3m+c1NnUGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=szqSpjH8gveSqBHOKS7GHJvcjlJTjHrh3TblVtqYI7o=;
 b=oLiNraQfEcZ0+HvxfF96JgY1KZ0TtNibQJbSDM2ayBElLQ4VKS6TY/EXZUvmEG1zpsMeG700X4nqlpidNx9nJZKxFzSSCcAEbohHdXWncDYnXzDAbwVklx/5j6syQoLAV+T6lIL7pYy6xDmLwdzcl4EURIfpYtuL8CO5xNxb2zUntobxPAdqr2loPe+WH1WlsuV2BwZC9TcYxPeQqEIQjrR5WQNJ342R3vtnxZqZe36sywRpK5vIhqKRkcmc1lJSKu5j88S9x9T52Tv2FONc1TVfo6HUB7Ynzonqi52SmOmj1ewxkLw7K/5f+dshN16Yyx649PuFxZXo4aCVyC4Kew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=szqSpjH8gveSqBHOKS7GHJvcjlJTjHrh3TblVtqYI7o=;
 b=qNuUPtcBRg6M7JeeALUeK9VKUr9Rs9n+fiz/Vkjp07/PoWr8Tieb3e+LxP8HSrXp67of9z8lV4TFDsFlXgUquLtvpevVeu1XpYC7ufRupo4mjYhbVQBHKH/Qqr2qNlWT941Hm2sox8KkaYNh+qLAPn9yFK2yKCOqn79yTqd7oWmy8YZhEPFhIzvUDrx0UX0IJPRj09iiWuqOzUSCatmRoqJBQRn3pObkvMxnEE8QFyeV2AZR87RN+WvSKv/vIFT+tBWAn7yCFWc4QOBVXj3BPUKe2BoBFHZB7Wwapu+jvMxydxDxn/KtuqSA2a6VPNuP38G31N8Sa2ZkbXbltk3Gpg==
Received: from SA1PR03CA0020.namprd03.prod.outlook.com (2603:10b6:806:2d3::17)
 by SA3PR12MB9178.namprd12.prod.outlook.com (2603:10b6:806:396::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.27; Thu, 7 Dec
 2023 10:29:25 +0000
Received: from SN1PEPF0002636B.namprd02.prod.outlook.com
 (2603:10b6:806:2d3:cafe::70) by SA1PR03CA0020.outlook.office365.com
 (2603:10b6:806:2d3::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.27 via Frontend
 Transport; Thu, 7 Dec 2023 10:29:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF0002636B.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.20 via Frontend Transport; Thu, 7 Dec 2023 10:29:25 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 7 Dec 2023
 02:29:15 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 7 Dec 2023
 02:29:15 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Thu, 7 Dec
 2023 02:29:11 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V7 vfio 4/9] virtio-pci: Introduce admin commands
Date: Thu, 7 Dec 2023 12:28:15 +0200
Message-ID: <20231207102820.74820-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231207102820.74820-1-yishaih@nvidia.com>
References: <20231207102820.74820-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636B:EE_|SA3PR12MB9178:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c9389d5-ace8-4288-72dd-08dbf70f62a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QbRbPiAjhTTp4yBglqbYr+aCItEaTETmcgErVMKjWGavl6sMDnNE9KFOTcchQETWlxBWibeEOtFOei1Fe99dDPSXmOtIHXd0de4kH+HB8GEk4L/FZEwJmOj+/xqIusw8QDcf45iLOFGDlIiHqTfSGKxb2Str0BhWLmijRZdPdzm/SuTIgNk1b9rLdOU/K1GEBVjG7uwJ1MOekJig1oWlgZxi4Ggr/PHaay930Cf6oEvDxZm6QlAoXe/AIlFfINDWhLFjkHx5viJStyZEgyC68nKgQpfAWdE8IW+FHS9yc2I6yC2j5P3QxOh8tggiOqe6iwVOXFudtq6Sk6yyqDf7S6SXkC0Vimi+MuqdI2rmzhYNzwUZRZzrtiEAfi4Eec0waNGGM1yddRkwM7nkz+8iN/4s0sWdpy9GUu4CyGnChZBIVDbjpTm62v7tewRMsmi6u9uHQi4jC2Z9MiLgq8xuuBsolB7RNxmLDEc93Z29P5iOjm6/l79JnXHiKu0YNapXZvP+8T+sHQBM05PbeotihHxH4iBO1UmxSxil43Hr/XCfjVD3yiD/AHIrON/KIKxfNFxqS9S1i2+po9IQ+GTs8WG3eO98+lAYnWP9o7p1bq4oazjZO45JLOtLWwyigC1DviUZs5ZxKFs5MT3ZGbOPXyw9tK6lodjyU4bJ7FDqbPbjwsFEHW0h2O9sLRjGZqm6C9n93W9HncR+1zNyEum7rUUncH8V6wiRjB1cSctRrcEKX4zskbG3bJKFhG57DXE/
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(376002)(39860400002)(396003)(230922051799003)(186009)(82310400011)(1800799012)(451199024)(64100799003)(40470700004)(36840700001)(46966006)(26005)(107886003)(1076003)(7696005)(2616005)(426003)(336012)(41300700001)(47076005)(40480700001)(82740400003)(83380400001)(70206006)(316002)(70586007)(54906003)(6636002)(110136005)(478600001)(36860700001)(7636003)(356005)(86362001)(40460700003)(5660300002)(2906002)(4326008)(8936002)(8676002)(36756003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2023 10:29:25.3296
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c9389d5-ace8-4288-72dd-08dbf70f62a6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9178

From: Feng Liu <feliu@nvidia.com>

Introduces admin commands, as follow:

The "list query" command can be used by the driver to query the
set of admin commands supported by the virtio device.
The "list use" command is used to inform the virtio device which
admin commands the driver will use.
The "legacy common cfg rd/wr" commands are used to read from/write
into the legacy common configuration structure.
The "legacy dev cfg rd/wr" commands are used to read from/write
into the legacy device configuration structure.
The "notify info" command is used to query the notification region
information.

Signed-off-by: Feng Liu <feliu@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 include/uapi/linux/virtio_pci.h | 41 +++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index 187fd9e34a30..ef3810dee7ef 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -226,6 +226,20 @@ struct virtio_pci_cfg_cap {
 /* Admin command status. */
 #define VIRTIO_ADMIN_STATUS_OK		0
 
+/* Admin command opcode. */
+#define VIRTIO_ADMIN_CMD_LIST_QUERY	0x0
+#define VIRTIO_ADMIN_CMD_LIST_USE	0x1
+
+/* Admin command group type. */
+#define VIRTIO_ADMIN_GROUP_TYPE_SRIOV	0x1
+
+/* Transitional device admin command. */
+#define VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE	0x2
+#define VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ		0x3
+#define VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE		0x4
+#define VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ		0x5
+#define VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO		0x6
+
 struct __packed virtio_admin_cmd_hdr {
 	__le16 opcode;
 	/*
@@ -245,4 +259,31 @@ struct __packed virtio_admin_cmd_status {
 	__u8 reserved2[4];
 };
 
+struct __packed virtio_admin_cmd_legacy_wr_data {
+	__u8 offset; /* Starting offset of the register(s) to write. */
+	__u8 reserved[7];
+	__u8 registers[];
+};
+
+struct __packed virtio_admin_cmd_legacy_rd_data {
+	__u8 offset; /* Starting offset of the register(s) to read. */
+};
+
+#define VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_END 0
+#define VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_OWNER_DEV 0x1
+#define VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_OWNER_MEM 0x2
+
+#define VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO 4
+
+struct __packed virtio_admin_cmd_notify_info_data {
+	__u8 flags; /* 0 = end of list, 1 = owner device, 2 = member device */
+	__u8 bar; /* BAR of the member or the owner device */
+	__u8 padding[6];
+	__le64 offset; /* Offset within bar. */
+};
+
+struct virtio_admin_cmd_notify_info_result {
+	struct virtio_admin_cmd_notify_info_data entries[VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO];
+};
+
 #endif
-- 
2.27.0


