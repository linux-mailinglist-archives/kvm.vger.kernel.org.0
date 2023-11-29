Return-Path: <kvm+bounces-2769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D87397FD9B5
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 15:39:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 086F81C210E9
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 14:39:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E710332C87;
	Wed, 29 Nov 2023 14:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KtHieNs4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2049.outbound.protection.outlook.com [40.107.243.49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3AC1730
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 06:38:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a/J1E3t33jCBEzhFQpXzmU4loJi8JFt6Y1pq+fkBAmvRBV4uqlwNP01RkpHt9ZdH/udBaocXpnlIW55wUcalbUUIxshZXM75I4UYJ8E8BTCWnxVXHYa0pAuK+MzwQUAj+Hatqe5C3oEXeGHv5ZbDD/+ggSIKYALTB/f6w1x9ACTl3yGqw3VFm5g/Gh5noJh2AhzI31S/+LkWVQQdH5b82zF4JeSTJRTdbW7pU04n0Jv550XdSft6QoG2WVZWT5RZm3kCAq2RlQKzic/J7lkIr5CzVVzDrxCijb5OqGUn8TrdewYjVuWjLy/pRdAX3VYA64EBzkjgPPsBvYLUOE6SXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G2x/GagHKWc/K3dBv/nbaOtTwpwbGUgDOF6vOfqRdxg=;
 b=bH97vrUXzMa+GVZEHu1WcvKq21QOW3pPkRQdGByaeCKpiZKCcvYwGvbYVUDcB1qG9auf6ZKTZWYcn369t269Z+V3N7aV0BKbax7IcpR9AYQWfxQX9MKmBIhNQ93wABdjD8Eyw881/H/0pkhVZwcWBVeUaD2YCef7u6Q7dFsAczZ272H6CKO3RE9iWVLz7yDofw7BzAxaB6cTqKD6XPkavMbXEEUgHIJCI/+sA3a+Kb3EvzwmNaO0q1W9d6c5VDVsWJX44Maay12SO1nUDx2TwAE/0/D3AIKw1+YoM5cA+qokzSNbykdei4PdBVaew0Jg29aYL++3zP5Q7Y23f8RiVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2x/GagHKWc/K3dBv/nbaOtTwpwbGUgDOF6vOfqRdxg=;
 b=KtHieNs4xbGoAHJXeIVIv3n7pnps4ZPnpAjX5cptv+Y4TPMEXcq9N+SbbmP64J6ryehkdqfjkZhf7t570Gb8ic3HFJuY7mzSHGgpyjERW3ldzY0RYkx93OvXphcee7LMdhrY4QVbfCTq7FN2yZGHd4wfE1hIqExHc20QuYiUF4LXiOWSW2qNv1GZVSBLRjOPesNc92SBZ2k4LZckYoPxk+an2QlDg7dao20LtE29TCAxkqqguw/2LC6avpIV/Qm1XxijVD+wmiCO3p2f3LFuIpipIf2aefwJ2VzlduCuwovpuciOF5PrMalIsX22/JvjVrj5TqmELVa2EdQc2Yhr4A==
Received: from CY5PR15CA0142.namprd15.prod.outlook.com (2603:10b6:930:67::8)
 by PH7PR12MB6467.namprd12.prod.outlook.com (2603:10b6:510:1f5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.27; Wed, 29 Nov
 2023 14:38:45 +0000
Received: from CY4PEPF0000EDD0.namprd03.prod.outlook.com
 (2603:10b6:930:67:cafe::86) by CY5PR15CA0142.outlook.office365.com
 (2603:10b6:930:67::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.22 via Frontend
 Transport; Wed, 29 Nov 2023 14:38:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000EDD0.mail.protection.outlook.com (10.167.241.204) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7046.17 via Frontend Transport; Wed, 29 Nov 2023 14:38:44 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 29 Nov
 2023 06:38:43 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Wed, 29 Nov 2023 06:38:42 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Wed, 29 Nov 2023 06:38:39 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V4 vfio 4/9] virtio-pci: Introduce admin commands
Date: Wed, 29 Nov 2023 16:37:41 +0200
Message-ID: <20231129143746.6153-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231129143746.6153-1-yishaih@nvidia.com>
References: <20231129143746.6153-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD0:EE_|PH7PR12MB6467:EE_
X-MS-Office365-Filtering-Correlation-Id: 18d1ec95-c154-48e5-da1b-08dbf0e8e3bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zshpYLMg+EEI8WsOgyt4XXCF3dzACiZ6lIBPK35aCs81uys/znum7kyHoD3QkHuD7yABA8bJhUjinEFeZdwEsnKl6Ehpm1924eaDMBxPYr8DdTkNvAamNK+9JcJjBro9Dk+V8jlKOGUmG1g/HLQUJvs5/bN+DXM8rsNoKiU1WthAmG2V5B+B2RuZuUkcWGT8W55GilDrNWW6i9M+0c27uN8BADonAa8xM9Rpty3wwPicrmOCGzQytlNpsLpqimsG4wToBZmAWcxcMjRSXb/nHqZbjMU83NEpvLRALV5dOwEyom2SJ8l4azvphiONPZ3F0BobUoPqnqVSYNfOeyWL6ezw1y3pCSwbgqSQ/8uYKDYtdJR/XeDD+PPXmcHoIxS2a+FxTBCcdP1/XW5fhKBlCqPV15IHW9vh1pJkNvUWr/2MxPRf2H4VJfMRhCCbCck4F8H1Qrh1+j996fbS58aX81eVvhykUcQ9H31pAF7QTNQQpjIYz1M9RYi2X0iAzNO1g9sgwJkSTUZtxMiUjGnrxRz3aDTE3HWWO3pgRsNYe+UnxoDibhGeYycjdWZedY7NAlnaxfmHcX4BQpUIV8EfBc8cVhm8mMJ6HfrXD5i3d8LPZTT1quZGq41vBhIXWiZaPYBNGgIvscX+Yv/e+12MYqyfs8GXN5O6TixtWN+D1QMOCEEEt5W40H3URsgrBy0fUZ+n5XCdSPrgY84IP2D6ij09jK5+JyI4/nqX9R+nj4dpGKa/0Ofy6ICoPfPuU+z0
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(136003)(396003)(39860400002)(346002)(230922051799003)(64100799003)(186009)(1800799012)(82310400011)(451199024)(36840700001)(46966006)(40470700004)(1076003)(6666004)(107886003)(2616005)(7696005)(478600001)(36860700001)(336012)(41300700001)(426003)(83380400001)(316002)(40460700003)(2906002)(5660300002)(6636002)(70586007)(70206006)(8676002)(4326008)(8936002)(54906003)(110136005)(47076005)(7636003)(356005)(36756003)(86362001)(82740400003)(40480700001)(26005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2023 14:38:44.6068
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18d1ec95-c154-48e5-da1b-08dbf0e8e3bd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6467

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
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 include/uapi/linux/virtio_pci.h | 44 +++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index 187fd9e34a30..f920537f5541 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -226,6 +226,23 @@ struct virtio_pci_cfg_cap {
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
+/* Increment MAX_OPCODE to next value when new opcode is added */
+#define VIRTIO_ADMIN_MAX_CMD_OPCODE			0x6
+
 struct __packed virtio_admin_cmd_hdr {
 	__le16 opcode;
 	/*
@@ -245,4 +262,31 @@ struct __packed virtio_admin_cmd_status {
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


