Return-Path: <kvm+bounces-4688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E9A6081683F
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 09:39:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C1E3280BE6
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 08:39:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2B1C107AB;
	Mon, 18 Dec 2023 08:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="s9w/o/wn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB5410A3A
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 08:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fi02hSIIL2YuyqM6dGQOL1FxIycgiOWwm621EjmYASGxG4D+aA3Ax9+7fGRmVYQv7V5qt5lJQHP7m8BPgALSlkTQtkfr4jqO3iUyOxckMTvHjekgVKepptx7FjQlrQCpOzYsLY26g7YzLjm7oCV/hoc9hyHW82XBjr05M9eVrYIlEG55OtBxxvmybi0Nz6EdEtBdQdNkc0JuERfbKL3Mw0t2bF+5sqCANW3sDrfe14zzD/J45BAD/4EyMOmw2JEKXOtfDv0SEsuWj2xJ47YxIY3wImj+/VQvkj/cvejFIoKMyrfAdmO8uboLFzUG6ePr5YMh5Ji/b7wytdCiAF1HMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ixQtpvTNaYyDToUTw43Dlrc0d/yTizWm3gUpC5jls0=;
 b=AodF6m6TJOSgNsHTTdOaaFVYcHWykfoWqA1RquDZZIV9oKPXv7G5BjjCB4blrPRgLRiFtFXDduaCHKGAlM1SDHfh3r1jjc9NeqOx2B9eBagf++UV/KnaPJAPJP9LMHFipmU7uWMem2w77RLnRa37fE43CbJVKddGMoW09EBmzTc31GQVi0j44dYtgYwKXqgA+o6znkAfDP/7DyvEHzW30O19wzMSaqFbnUTZ8H1iRfm1yy9P5cS0K0j/yLu0J3z+x6Mgdgc7qwcNn8TpPTeo8pivXEemkF9DBUWITqSkCJxG6NTTOsZzdkvCZLGbLc+td8UuaGp23vVo66ltf5xJWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ixQtpvTNaYyDToUTw43Dlrc0d/yTizWm3gUpC5jls0=;
 b=s9w/o/wnE/Z8Gf4BHWHdk05c6D3jX10KanXVcjIvHS2DsHmjBL8dgzpQR3zPSRKOKNmXHJuOGTL5lFoUaRuaA34PtWcedvfqyzP4blpwsnw1RyKPtHSiDcbtdmY/YYhW7Ra39/tB3O9rx3a92TnpF84lnOxA2GgMijyrfe8yj6+SDWUJd+pIclytUobvDC8/M6cBmWp+XQuUtwN9Oxe38KXxdLaNlg4SJKFT9nKJQToqliJnEIqWdiu7sOnSpfvNst2hrt6RkjxgI2cNttxIQ4r+eiy76nqcy4i7qD2zQWmHbzvSqEE02BA7AyIhiwsquyFOa5HKeEgTjFYe3kpoZQ==
Received: from BL0PR02CA0059.namprd02.prod.outlook.com (2603:10b6:207:3d::36)
 by PH0PR12MB8098.namprd12.prod.outlook.com (2603:10b6:510:29a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.37; Mon, 18 Dec
 2023 08:38:44 +0000
Received: from BL6PEPF0001AB72.namprd02.prod.outlook.com
 (2603:10b6:207:3d:cafe::5c) by BL0PR02CA0059.outlook.office365.com
 (2603:10b6:207:3d::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.37 via Frontend
 Transport; Mon, 18 Dec 2023 08:38:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB72.mail.protection.outlook.com (10.167.242.165) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Mon, 18 Dec 2023 08:38:43 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 18 Dec
 2023 00:38:26 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 18 Dec
 2023 00:38:24 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Mon, 18 Dec
 2023 00:38:19 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V9 vfio 1/9] virtio: Define feature bit for administration virtqueue
Date: Mon, 18 Dec 2023 10:37:47 +0200
Message-ID: <20231218083755.96281-2-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB72:EE_|PH0PR12MB8098:EE_
X-MS-Office365-Filtering-Correlation-Id: 4981b0da-65b1-405d-0dc2-08dbffa4beac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	PYNP0jAOXMo5TIf0a3hrqDI1Am8bl/+yzyPHWF3+q1vdmXxSHivOZvclx4ziM/32nP5y2nlBYGe/ht0of7jrksdcL146BQTXNYBkfhyjOFfoqz7EWDbdXn4wzIsvqfFkMRapDmp/Pxd+qqYZ5nPgHVjVs0tGy6nTO6VvzogSMGoTB6HOUBso9doP+CuEp0x/ZY8jWEHRSl4jA3koe4wnEexAitBA0zJT8pqdjcAihyi7nWHWt8ulswd1pGdHctCjbbreqjJCd8lMkLmwMpNlxxpu75IqANgFaWiaeiat2VplWxF1zLGI4p2wfFYlVwE97KgpFqSHMkiWD2XiFonTlsvT4HLXPB6cD3mzZpCEXvwy0F7nA8lEjo7Bg/EPhZEXg3m0kPl8E42U4cRtr/tETDMArrWo8wuVKLpLak0vIyktXW+06R0m8lw/Dimurh218Vr0jY0ppxsOiJax8Sgs4kR2LpNW5SobfFK6qYcbSFeAwP3iq+MCyIMLEOfTkm6fAxoXo0Yz50tOexizBD52z9zeFtUUsL6bdy6QheVvxAiwabw6T0nxtzLmsQf0eqJ0rf1eZZl0w2djQQOGsWf6XdcM92uhBP3N9/F79iNoUpoZAEjMpLQS0hj3CLzrFrzdkVVEDjPMI952B8bRU4F2n/l3FwC/E+XxjUf97lbGYXgEj9odS3DRtdXOB9qIqJgTx1Ocr9znTHqpMWviZaTEb5e0ZelfwfuCXpe4Q6tpEqdo9zb4YkC5i9LASMs7Zr/hTYcY3y2dm7w60tr5vdV5Eg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(136003)(376002)(39860400002)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(82310400011)(46966006)(36840700001)(40470700004)(40460700003)(1076003)(107886003)(26005)(336012)(2616005)(426003)(7696005)(6666004)(36860700001)(83380400001)(47076005)(5660300002)(41300700001)(2906002)(478600001)(54906003)(8676002)(8936002)(4326008)(70586007)(70206006)(110136005)(6636002)(316002)(82740400003)(356005)(36756003)(86362001)(7636003)(40480700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2023 08:38:43.9692
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4981b0da-65b1-405d-0dc2-08dbffa4beac
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB72.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8098

From: Feng Liu <feliu@nvidia.com>

Introduce VIRTIO_F_ADMIN_VQ which is used for administration virtqueue
support.

Signed-off-by: Feng Liu <feliu@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 include/uapi/linux/virtio_config.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
index 8881aea60f6f..2445f365bce7 100644
--- a/include/uapi/linux/virtio_config.h
+++ b/include/uapi/linux/virtio_config.h
@@ -52,7 +52,7 @@
  * rest are per-device feature bits.
  */
 #define VIRTIO_TRANSPORT_F_START	28
-#define VIRTIO_TRANSPORT_F_END		41
+#define VIRTIO_TRANSPORT_F_END		42
 
 #ifndef VIRTIO_CONFIG_NO_LEGACY
 /* Do we get callbacks when the ring is completely used, even if we've
@@ -114,4 +114,10 @@
  * This feature indicates that the driver can reset a queue individually.
  */
 #define VIRTIO_F_RING_RESET		40
+
+/*
+ * This feature indicates that the device support administration virtqueues.
+ */
+#define VIRTIO_F_ADMIN_VQ		41
+
 #endif /* _UAPI_LINUX_VIRTIO_CONFIG_H */
-- 
2.27.0


