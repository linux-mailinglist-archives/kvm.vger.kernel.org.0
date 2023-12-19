Return-Path: <kvm+bounces-4855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DA5C818F5C
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 19:11:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC1BB286B44
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 18:11:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DD3B3C46F;
	Tue, 19 Dec 2023 18:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rTPm1bmK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2067.outbound.protection.outlook.com [40.107.223.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061333B18E;
	Tue, 19 Dec 2023 18:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ie0LEafI4GZYwVdYKfM5bYtFZxBsDlMrLwj28MEBzAKJVOwFvdH8meexzQzPP0Yc1kuVVpBWVp9WGB9VFVnsuVWlftmI42g6gF6vvRv8NzG+3a1G6Ld8ApcmSeDwXO1JojFz5acqGfWOvms9e7b52rk/TV5E7UmiC5jlyRIkqNR1Dlv3da4Sz/Pa00TM1DTIu+fWIzYUOCz3TZoU6WIJwsSLDrAoK8LWz40mh4YIaSNi58poxk+Sogd7i6hgq1IKBvv0p/W5h+1DS66EM7AMn7hprw64i7EQv/Ol4aYH1+3q6qs2SdGCo0aEFjX/P+lsI0OkPiZed/TgaWprys2/1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nguvkgd7vI+uB21EEtUqXSqoijHWYfY5mS4xdXcQ8Fc=;
 b=LAYP2moOZcS/jkfKiFFcDV7fdrsSbB0DWniWAQo2xE7P2uZIbLzcsR8xSztLk2VJvoe+CVxzqADwrmCWdO6oC8XeQVdbBhQlvN6Is2JNrrGr62Fcx/gaNfrcRYM42ZrMjoV1Zh7gJ3rQaFS3sRXovra+A5LFIf04iK999S6L7ZXrcqK9386JPwXkWKN/tZfJRWXIQcHqKOqhzOyQIVm2ZsCbn6zu3lwXsWt689flneYIp84NU4E1KvuSPCfpjdOrq420dovqvY5BSr544ELofHdWvzKTLE26X5Fs/mS5zHcsCNM42ALy9InO873SuFPfJ48qzX1/2HRqAVcke8Ixqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nguvkgd7vI+uB21EEtUqXSqoijHWYfY5mS4xdXcQ8Fc=;
 b=rTPm1bmKWBb51vKhnwsTVTBCt8bCmwKzU35CrFmmfhGvywpSBO8KEeZc6cYLJe201k9tMLLacXnXoq/OVJFotqgL+So2d2EkRhngboNpQc8d/t+prZpXZbtSXhuU5lh7p1LVTFeMFXvmGKHAvV27KE8mVQxhDEUKl+8iuRnWH03uQeCQtu/prpHmruYD2yKLhdkhltTLGU+0nj3GDziFo/dLzoZvVIWvUYhxDDK3HFXQ4Y0+BhRd51jFpBsws1UNxlah+SP2Yg3T8+mnyoz9jwRxMaKpIGEdhZtBVcpqPJkg0aCOZBPCzCMbFAch7pXy6lLnIBVoqT2mQk1EPjkTuw==
Received: from CH0P221CA0021.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:11c::17)
 by SA3PR12MB7903.namprd12.prod.outlook.com (2603:10b6:806:307::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.37; Tue, 19 Dec
 2023 18:09:32 +0000
Received: from DS3PEPF000099D3.namprd04.prod.outlook.com
 (2603:10b6:610:11c:cafe::21) by CH0P221CA0021.outlook.office365.com
 (2603:10b6:610:11c::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18 via Frontend
 Transport; Tue, 19 Dec 2023 18:09:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF000099D3.mail.protection.outlook.com (10.167.17.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Tue, 19 Dec 2023 18:09:32 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:09:21 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 10:09:20 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Tue, 19 Dec 2023 10:09:17 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v4 04/15] vdpa: Accept VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND backend feature
Date: Tue, 19 Dec 2023 20:08:47 +0200
Message-ID: <20231219180858.120898-5-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D3:EE_|SA3PR12MB7903:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c54d6cd-7dfe-477f-02b5-08dc00bda6b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	vMfKGckqlLqS2RkH3YC7d6KERtZs/a5w6cL6V3QPLHk/W9H7Tpb+pPwOdJgL8JUvjk8JKeKj8BPgfp5TLFGOhCKNHaGEsTtj31ZAL5hWirok6Zo0wMEBcQsNMEZ+KeoCkh2+4xg81+qp8ROUrugWq0VdMWDeDQ1M7LyPc5hY47DJbrwAjN2atIoTxxofXFwmPQArd/o2Ddnrx2IC03GNHISxDW/IUPWYTugmU4tDdYYoNRur+hySQlz6pWHN0GBGpkV4j23U8RKW+HMoDO43QZTKrzpOMfyNMgbB/wx2W8VFXhLlFn+i+uRSxMSjx2nK7MVQcu/yKhMGW1lkKz4dBJDp88swT22ZcT6r7VSAY9c7mlcWEYg3lElw677PSbiSdSZ7R43v4kUqxTJSpFJ9GovhPz4eBKDthS/6CvCBRx7huBAxFSGB3uw++DlpXqe/Xgf8BenCcWLSdpcemgNJscHPw/xH5H35pVkOlUoSJUk0bw/s6wdciowcfenaFAZRgjYoH/GtPfE6kWvG6BymHTXE31WwcFAiSAzG3fc3IRnMov+/mnDCdOJQFDvY5kH825Dh2UdrHCgFiajfU6ugfqsmrxBPMXHZCzmG3yU0AUTUc7xdotW+NIZMjpDoh5ygs2Zcg0eSVCe5aLfB2E2sKiWvZoG3JNC/jCQuQAGBH0NqSDuWS3Wc+wQfUy9HkWVhr+WXc9v8ht/5QQ3p2GTQBlwUcN5gt1b2AxJE+jXjqnQwZWKjPVagNycFpOdviCqz
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(396003)(376002)(136003)(230922051799003)(82310400011)(1800799012)(451199024)(186009)(64100799003)(40470700004)(36840700001)(46966006)(54906003)(316002)(6666004)(478600001)(26005)(47076005)(336012)(36860700001)(66574015)(426003)(2616005)(1076003)(4744005)(2906002)(5660300002)(41300700001)(8936002)(70586007)(70206006)(110136005)(4326008)(8676002)(83380400001)(6636002)(7636003)(40460700003)(356005)(82740400003)(36756003)(40480700001)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2023 18:09:32.3839
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c54d6cd-7dfe-477f-02b5-08dc00bda6b4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7903

If userland sets this feature, allow it.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Suggested-by: Eugenio Pérez <eperezma@redhat.com>
---
 drivers/vhost/vdpa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index da7ec77cdaff..2250fcd90e5b 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -749,6 +749,7 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 				 BIT_ULL(VHOST_BACKEND_F_IOTLB_PERSIST) |
 				 BIT_ULL(VHOST_BACKEND_F_SUSPEND) |
 				 BIT_ULL(VHOST_BACKEND_F_RESUME) |
+				 BIT_ULL(VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND) |
 				 BIT_ULL(VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK)))
 			return -EOPNOTSUPP;
 		if ((features & BIT_ULL(VHOST_BACKEND_F_SUSPEND)) &&
-- 
2.43.0


