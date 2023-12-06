Return-Path: <kvm+bounces-3671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D6328069DD
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 09:40:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0DCADB20D95
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 08:40:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D847F1A271;
	Wed,  6 Dec 2023 08:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="L25wHKBB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF00109
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 00:39:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c97BoA+Ua7FLSotydEv371usB/ybCZ4b9I4198o7NxPxYIVivR/ZHX7rgxCwnJVNGPE9LOVHGpcGgswAtvBlJ2ZY7kM771IdHWQjbrpnThhZ5YHaHa8oZrgBzaMJIiV0aEnMCK32EGI9jHdONvrEOuCTjVbwfyhqLCZScmsVDFVQpkhd8aZOLRdZmQhBuCxUw63x+24e1g0QkVcYM8l4i88MZ4+TuIlstwVyC9LDeoszjW92/LOhndr38IvlJMoCdFByR7tmvUzPTxLihnIj8wIyRQxkXt1RyWOomnyAs+VYLMd8Hu0r1isUY8QJBC/DFcYWfx5uIWIW3FjzjbQ+dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ixQtpvTNaYyDToUTw43Dlrc0d/yTizWm3gUpC5jls0=;
 b=nBuj38EPNNMIfHqVa2sZj1sO60tghzRCgvMCMj8PqwRyS1IgXWLCK6q825U83oJ6csQBl3/2fEGVv4V4/sC94u0L+kFl8X8PmH/iB09PP178CXkrutOBd39Kdk9FllCfnwm9ol7U+iJvDdsjaLrzEvnSlB3SKWlObKmgGIfCbUAuQR+mdQPAq/u+4VOYG00KdIz8vOudjK44Qb/sb87xQ+vRWEoxAcQlUdBE1ObtxAYJSdzgGY/DVDRMZJOa8eI0acBE18BI11J9vCQ9sV/bEWIUtktMAbAm6SjKfZvzqob+T6z78JiyDLfCEi+poqVeB6nmdQUlTuzoUMlUuaydRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ixQtpvTNaYyDToUTw43Dlrc0d/yTizWm3gUpC5jls0=;
 b=L25wHKBBrx8X6pC2zbfHhpm9N9+TWjkGsb0H/KK6VJi3bgkEhHHl/GkaAl6Fvmo+59NUwcpDx/bY4joWVdHIQOtAQQOOY8rk0/rVS9ku0VPha+FTz37pToRhVQ3ZEmRp2erE6AP3aS4yHxX2Z99nFn+t3F1jX0s1TxqMzUtbJtccgIJnOnoNTu6nknhSDXOTdiAki/YEqoKnI4ToBqJQgdCL19WbaHFe3UNXQ3UrHslNgGaCswr+g0HpWGmO+Jy/k7vc6NztE/hjx/gEGKDK6qCKN2dt3lTElICgYc737P/OBn77Dm+gmLgelyAc8jUFNEyTJT5X2B3qWWYIpz6g4A==
Received: from PH0PR07CA0109.namprd07.prod.outlook.com (2603:10b6:510:4::24)
 by SJ0PR12MB8614.namprd12.prod.outlook.com (2603:10b6:a03:47d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 08:39:53 +0000
Received: from SN1PEPF0002BA4C.namprd03.prod.outlook.com
 (2603:10b6:510:4:cafe::c2) by PH0PR07CA0109.outlook.office365.com
 (2603:10b6:510:4::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34 via Frontend
 Transport; Wed, 6 Dec 2023 08:39:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF0002BA4C.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.20 via Frontend Transport; Wed, 6 Dec 2023 08:39:53 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 6 Dec 2023
 00:39:43 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 6 Dec 2023
 00:39:42 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Wed, 6 Dec
 2023 00:39:38 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V6 vfio 1/9] virtio: Define feature bit for administration virtqueue
Date: Wed, 6 Dec 2023 10:38:49 +0200
Message-ID: <20231206083857.241946-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231206083857.241946-1-yishaih@nvidia.com>
References: <20231206083857.241946-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4C:EE_|SJ0PR12MB8614:EE_
X-MS-Office365-Filtering-Correlation-Id: 85a900c3-0dd1-414a-a64b-08dbf636eb14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QPVLcKavussH3otTdzPeaSfzsej2xQhW/5F3AOwSLshoGAD4ZnLzC9YRYTZPWCo9/a2L61SwKSX66sZNvfIo9M0WyqBFL3bpyon8Dm62MGXWUTIBJyQDGwhfMoPfK/sp62s6wqBnZ0qwyRfSzD8nN7yoAPn50wk3X+6/xqHXAUOu9zOXnzFl44m/ZmfnF93uexPpyCPJLsJUrLwwejPWMy8+hCDGgmiHy2IypAcKIvgmP8+VG/mGRBBa40Knhhs+ZfCNrG15jvScGHA+LpBZkdFjQDvPAe38lHVUhK2ArLdJ3eTJvEREbBCWAeYUm3EhrNy+gddvrV2u3OlIs64JMR/VakD1CgTlMUAbVwTdkZogdpJWfZCoFZtVxxHPi3+gWxeNigrgIZgX6oda5iq+wdqpMt5rlizcDFKVKikWJobQO3VB6HBF3zfJe0gWjppqhf7EWG9tcEoNuJGrDMkSnQgWr5lS2ytKs9Fo3UMg9upGRE1nmgnoon1I1yviFL2oDgurKZ7Yxu6k41g7zg+nKPBXCUMo24ZuT/oIGKOFts/Pbcdpj2llzWniBG4XSrQz29ZnIEZfn8QtwKx3f1Xj7wVXUf8sQJghHOm1Hkkk0tt9hDEXCgH88WL0+973UHwSI0ZNz2W8ANOLzClVrQ8MquxDopBFeDqnZQiFm7O7a3EWdG/m+C+sGCcsuMRJGGiey1+D7XV79A/pPv0mnq+WK/xskBeXXqcS6fxxoDC/9n/3YcUDv8W2RIpmmMpK5soyNn0wsIwsh6w1jzrhmgttYw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(396003)(39860400002)(136003)(230922051799003)(1800799012)(186009)(64100799003)(82310400011)(451199024)(46966006)(36840700001)(40470700004)(107886003)(1076003)(2616005)(4326008)(8676002)(8936002)(7696005)(83380400001)(47076005)(356005)(7636003)(40480700001)(36860700001)(426003)(336012)(82740400003)(26005)(478600001)(40460700003)(6666004)(70586007)(70206006)(110136005)(316002)(54906003)(6636002)(2906002)(41300700001)(36756003)(86362001)(5660300002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 08:39:53.4316
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 85a900c3-0dd1-414a-a64b-08dbf636eb14
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4C.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8614

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


