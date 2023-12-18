Return-Path: <kvm+bounces-4691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F48D816846
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 09:39:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 74DDB1C22521
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 08:39:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FFD410964;
	Mon, 18 Dec 2023 08:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="N2mepzZg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2047.outbound.protection.outlook.com [40.107.220.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0190111713
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 08:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=di3L3VTzePsYwMHUdvG9bIgOHgNKQmsViJ5C4wEckr2xHSX13MxQMR+cmTHQOciyCXXFApGO7EBAAowLkM6mivip9zesCkqXx4BpVypf0aUUDABUZCfgw553INtP9JcEyOcED0SWkmMphZOQ7sbudSUz83MdXIOlPB5O8b8gTRKZGIOp+6xl/fcjY58pFPkBToiJ4mZS6N2ZnHUfr2dMEEeCAGK4LyibsxoK6Vib9rfEQAmTufq6sUfcp8nZbAig/GkkesmWeshGQ+lYIdneZ3XYaxNvDO3DfAj4RvtAxm+Gy/FxCLgo960hAXxp2PekSF6uUN/fPobSTgfcHJ4SSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=szqSpjH8gveSqBHOKS7GHJvcjlJTjHrh3TblVtqYI7o=;
 b=K1pr1fOMA6TuPkeDdf1lFjll1xijbGiVyodb1KC/679dIlq3KQcZHa8EDPJpUF2rsWaacFMXFL6xTKsjoVyOX3JdX1Olr24TfPjB+Gr5OuU0CInV3+MoPdnq8PMEwbW0s3S6cuA8CkqBJnwe4Eoe6M3qwnfl0wtnWeizM0Ljapmx2Bb3Z7+L9N8Lu23bpTlJdzRULdIcJMvazmNfjblWr49BjqmoK9FyZrhk3Uqhvo3DZ3EkMlVi06R3HlDu4x/8X5uafI445PxO1b5Qzn46Hrkdn1tF6OkGk6Au/6OBPWFqFsEVKxwr09MfOPv8AeJlTHAAk6yN/GQl/soe7nXUEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=szqSpjH8gveSqBHOKS7GHJvcjlJTjHrh3TblVtqYI7o=;
 b=N2mepzZgj62IPZYCgrrOwPabVe7CnoCvUT3ZePXcRiCnOwDGIMdg4VOepY0GoaT4fGSulJmqXkKmZLCljXY9W2JiImcigl2Z33Jwttm/2MMjYPFXUHF6TNk2X3zKtUd6GxuQE0XcpU4hcI2F50Guf7koB60CoBcqRAVkOBabXWZJVNwq8IAcPDDJaRGkPmyXbSuWPu1cZDPvSGgntLqGT/GwZYDuQaWgnoLcpWANIQTd0DazrgMCC+LliFP7Vf4JlvrjWf+m3IQUPvPQahtFQX4u9EgEGCCQZLwORsnV3ZkIp1+K0QRrBZqUDHownsv0Ly08T2jgg+/22eNO91jAzg==
Received: from BL0PR0102CA0055.prod.exchangelabs.com (2603:10b6:208:25::32) by
 PH7PR12MB8040.namprd12.prod.outlook.com (2603:10b6:510:26b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.37; Mon, 18 Dec
 2023 08:38:56 +0000
Received: from BL6PEPF0001AB73.namprd02.prod.outlook.com
 (2603:10b6:208:25:cafe::4f) by BL0PR0102CA0055.outlook.office365.com
 (2603:10b6:208:25::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.37 via Frontend
 Transport; Mon, 18 Dec 2023 08:38:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB73.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Mon, 18 Dec 2023 08:38:55 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 18 Dec
 2023 00:38:42 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 18 Dec
 2023 00:38:40 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Mon, 18 Dec
 2023 00:38:35 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V9 vfio 4/9] virtio-pci: Introduce admin commands
Date: Mon, 18 Dec 2023 10:37:50 +0200
Message-ID: <20231218083755.96281-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231218083755.96281-1-yishaih@nvidia.com>
References: <20231218083755.96281-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB73:EE_|PH7PR12MB8040:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ec67d21-17e8-40b4-1ab8-08dbffa4c5d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0lROWTmDb2d9qRmhqPH0UFg6EkwejIHkGsEgdytFPtjI2746TnWO/s90DMnKFF9cJ3w6AfAZm6KP+KxBehdXTxX8N+E55SNWXl8wbfmgBleVpuxj8N78k0mh8Zef5Fh4iM78LK+sYhAHRJQleJ2GqqerrZ/+X0QNlqfJ0C2gIyqZKyqNHI76mwXrGaECpFmQBXaJTsfZbciqcsyZWBNmVvNpZ0DklgjgFcP9D4WFyFSKmf0eAk9eTQehNf6rnNuf13nwWOEvQTQ8PorKduTGNmwYjwwP8hA4vI6OU7Yj4MRMwYQXDOnyw95FwOM4IwrmfD2U6yDlGVRvQFwJOA1P08bO5QHAuvr6yHufM5THTBP42vbzDLHHDYzAtsR9jgpBF31d03YkSK6AhsDeyjPsO6INEN7f+M/9cl16EuqEQ1ff6ojifkxTNxZDPfYehQrCRv3zLN/vBuGmNRwhhSU0nmtThMZlP3gS/vh2gzhbtbB4+Oj6suxZROf/Dp3PBCPTKlvL2SfWLaoAS8I+SYYcNQhKFBrwH+HYn0zpguYZfjGYj2bZNWbym2344/GDZAnVr4dHUv2UVONCPa4yEVoX5W3akw6xPdQp+WByX+PMbHm83YdyNGeP8IqEP/NPPUSUgSCDDwo01D136S/5XJOYJzltNXHsPs30EFmrHPj1WnJqRk0mrfbOKNmAMMxJuTS1Y7WiL4apwd+fTUAHIemB+9Fhi370zs4AEEKC+FAcpwE8yXU99mB0gJchrubxTo8Q
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(376002)(346002)(39860400002)(230922051799003)(64100799003)(186009)(451199024)(82310400011)(1800799012)(36840700001)(46966006)(40470700004)(40460700003)(40480700001)(26005)(426003)(2616005)(1076003)(107886003)(6666004)(7696005)(336012)(82740400003)(356005)(7636003)(70206006)(86362001)(36756003)(8936002)(8676002)(4326008)(110136005)(36860700001)(478600001)(2906002)(5660300002)(47076005)(83380400001)(41300700001)(6636002)(70586007)(54906003)(316002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2023 08:38:55.9848
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ec67d21-17e8-40b4-1ab8-08dbffa4c5d3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB73.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8040

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


