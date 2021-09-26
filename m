Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D17B841899B
	for <lists+kvm@lfdr.de>; Sun, 26 Sep 2021 16:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbhIZO5F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Sep 2021 10:57:05 -0400
Received: from mail-dm6nam12on2063.outbound.protection.outlook.com ([40.107.243.63]:2144
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231849AbhIZO5E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Sep 2021 10:57:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JiYriGZIP6p8faZSSw+6w35IbGXg16xvGApvvSAluEPqvJkZu2pseLq0IYFkUW8IPfFZqYRVplDFO4wQn9turXb/J6ovewA8piosh7d52yeGiQwXHFqu9H79/0OHS6bsyk+0OikxMFdYMzX/h7x+P2NdX0fH9RPxnNUDNwSwJdZ+86+PVMI797C0Br6H1RIIukFhzdewrlOQVqFo/P7337+8NqILrS5h8QljJIW3v1SoCmyFpXndgrnUDA6E6iSDnwdWJO3vsPnrjnrJaktNrPv48q9hcYyC+DQcC7yj+mRS6RE1pmKTyGF2RiLjwDi6+H6aSfNqdstXftU5yNXaZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=D72RtD+0XIzMVwNEE6NNcRPmkUBQfdVivTc7H6NARuY=;
 b=PsEXtZ0OIgIC2eJDyi+qBB9U0teYAkvHa7CK/g3nCR2FEXOVKuzCG44rfIsdt79juVb3MwQBQcTp2oGUcgX8Ze/bqIu3IUTUJWwE9VV2EjgNf7d3U20UdlP0Lf+Rd6kU/JYOeDtNuBGDJfpESxoqEqjgXzLXug7i6CkWTAtbcsnDGPUNoqSfpaOQRhME9UF+BaNfUAuDmBZJro4wpkkVKOFLKTKGqR5NPmACRJyMR0FNF5WJv3TWYUHQNVhJPamPUBgxJgyrLuF2A4WY2NdBhtL6L5rggIGvXqjS+/gqzyKDVqaqm0YZciIpHMX6j5vPydE4vyr2ElGuLaoDBSbqMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=infradead.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D72RtD+0XIzMVwNEE6NNcRPmkUBQfdVivTc7H6NARuY=;
 b=sjKI4viRV22NPd8qZWdJ5RR7L0Ueq3tFVfxdlZUXJCTYlfnHhV7gi1FAwxopsaBjEmf6XZSo52fO+vya6VwSm6A3mCmYPru/tJl5vz6hIENw8DjQXrDvUKtlSIFhvO4flINVYZvTJFI9pClM52LX3qsojKamU85xW+Rgom4dnXliVzWG6+IDXVj2SfQfe5gEOFaiy9CE1lUd2JbG3G7IKhc0gA/FofVDmACLBep3jx3oAOuzu3+jTwXnWKipnQM1InenlOeZE6JmtXYmm2Qn9oZW265oz8PpHeHXgRcI02AZ9nix91LC3Iz6lcQwZD9XjVOaZIKFczHYD2d48y1yIA==
Received: from DM6PR04CA0008.namprd04.prod.outlook.com (2603:10b6:5:334::13)
 by DM6PR12MB3771.namprd12.prod.outlook.com (2603:10b6:5:1ca::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Sun, 26 Sep
 2021 14:55:26 +0000
Received: from DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:334:cafe::c6) by DM6PR04CA0008.outlook.office365.com
 (2603:10b6:5:334::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14 via Frontend
 Transport; Sun, 26 Sep 2021 14:55:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT023.mail.protection.outlook.com (10.13.173.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Sun, 26 Sep 2021 14:55:25 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 26 Sep
 2021 14:55:25 +0000
Received: from r-arch-stor02.mtr.labs.mlnx (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 26 Sep 2021 14:55:22 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <mst@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <kvm@vger.kernel.org>, <stefanha@redhat.com>
CC:     <oren@nvidia.com>, <nitzanc@nvidia.com>, <israelr@nvidia.com>,
        <hch@infradead.org>, <linux-block@vger.kernel.org>,
        <axboe@kernel.dk>, "Max Gurtovoy" <mgurtovoy@nvidia.com>
Subject: [PATCH 2/2] virtio-blk: set NUMA affinity for a tagset
Date:   Sun, 26 Sep 2021 17:55:18 +0300
Message-ID: <20210926145518.64164-2-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210926145518.64164-1-mgurtovoy@nvidia.com>
References: <20210926145518.64164-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a80d816b-8e36-4eb7-87f6-08d980fdac9d
X-MS-TrafficTypeDiagnostic: DM6PR12MB3771:
X-Microsoft-Antispam-PRVS: <DM6PR12MB37717912603FA1FE4B0E13A2DEA69@DM6PR12MB3771.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1013;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yHfyDUQ/Peoljwds1xA2XFVEJ1GrJldmagfp120MHGqHvXAVBpu8cSh95US00Gcpfu614IC00iPO7i0a/Zvdhd/MSEdFlKPYqrHJXGFIxPg1rmzQdAU1u/IVmjIvLaVx07LyAiSPEkYGaD2CPZXNRgj9r0QsVlv3+X+yrUfgCMTIpzUpjQjjjuVHKA1XyNabTN9ER5Y6LKG5FiOZOr746X+nfhbzQdPSJtiMU3KOKIV1ih5sdyx39nYpCjmwpjSvsFiPraeDWMNgldFo2HPkxEpCn8cn2urlA8Aag6dThcxBiC28qOki1HQk08aGrba7nLSmznqR1OybwCkH6xfOWlnHtaP1X5Uyjrz6a5QWHDPICLzcGhzUve5zNaPpWf0tRXjfL4xDiC7xgKT77oK5hzaFjJtVOYdK6lgY/rlTSDRLAQ4f5Qorb8aRgqBN0gmo8NZ67ix5yVqYucZNBbuFvflf6kycncvUMcA+c/T0hvXrHKEzS0OhoP3ZE6LPL3oANBsbthdeLnwq6I6/0iS0n6H+CRfaP6q01lMqAXIkFIxvQJTpPFXLXtcRoKOBshGIc6gZQDEMe6X00EbZZuP8zyK1Psps9mSCgMWPps7orQ/xMNG2Itzs9arkFjs6A7LovBvr4th4hc9aD7M9Y9PwVL4TKPNkbVgiFDlw3QoL0c8oHw+CNK29tBaiuQboGn3BeC8Ysjzhe75soWz5E+MZtw==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(508600001)(4744005)(47076005)(36756003)(426003)(2616005)(83380400001)(110136005)(7636003)(107886003)(70206006)(36860700001)(70586007)(54906003)(336012)(356005)(186003)(82310400003)(26005)(8676002)(8936002)(86362001)(2906002)(1076003)(316002)(36906005)(6666004)(4326008)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2021 14:55:25.9592
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a80d816b-8e36-4eb7-87f6-08d980fdac9d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3771
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To optimize performance, set the affinity of the block device tagset
according to the virtio device affinity.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/block/virtio_blk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 9b3bd083b411..1c68c3e0ebf9 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -774,7 +774,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 	memset(&vblk->tag_set, 0, sizeof(vblk->tag_set));
 	vblk->tag_set.ops = &virtio_mq_ops;
 	vblk->tag_set.queue_depth = queue_depth;
-	vblk->tag_set.numa_node = NUMA_NO_NODE;
+	vblk->tag_set.numa_node = virtio_dev_to_node(vdev);
 	vblk->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
 	vblk->tag_set.cmd_size =
 		sizeof(struct virtblk_req) +
-- 
2.18.1

