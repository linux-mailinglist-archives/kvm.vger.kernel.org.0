Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A65B400EBF
	for <lists+kvm@lfdr.de>; Sun,  5 Sep 2021 10:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236559AbhIEI60 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Sep 2021 04:58:26 -0400
Received: from mail-dm6nam10on2067.outbound.protection.outlook.com ([40.107.93.67]:37889
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229482AbhIEI6Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Sep 2021 04:58:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hV0nCNpP4XtnxVtpw0oGvI4YCrKxWni+slIByB5JVhzJRQvwiVvYDqth9L1ThO/Z7FBXs7QBRZYn4tQ2RSEmRm1aGvOLeyRqUOjLS9Ci8vCclPX+cProWIZLO01E+LfG/5VZ8OVS33AFqT5gYx4LI9FokMApbQae5cbR/O7fpjW8v4IYe16u4vJ9TvSlj3OGPQpRZI0qOWOdeXyFAX3WN2ZCXQAin6bIjud4HtlNngSl/IbLdWBIpZlIlFu20DXfqwrlwE6Kp852E3zzLOHiA2cO4SKnKFs6AHenC2boXv8ClO9ktuTdu9CA4IXeY/gp0KhxEX2SLJk1yNxLVmut+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=BL9PDjOKb+NovwatQfpV0YU0oJjHUHahrvPqOd7qpvI=;
 b=dpVwxkydDpYOF4bwfJl+DI+B17I62rVFWNrpL5KVBX2T2YjiVpqpFwwDBjTANt156hhT8bSXkDqkTiQhvm6tEt/RD/Use9vjFuCq6g+kgmmX5tj0bHaOCuajPKogbofS/amjMuIjQtkzhQx5B/JiJQnJBkKLbGCOnHPw4ORqY6ExXCJIUA9S64kfCE4e49QtHpOkNTuKPBstkbMlX6IQWz8tLJLEawB/uYjtO0CASzZxDPOLzmgRTmWnGwfUa4LGLY09C2kbGYA6xko50uqgrt+rcht7buxWX5zgBfP8bMf+m5p78FJL1uPEm0NqwfTVD03Ni/tdH4rrDqZKz1h7Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BL9PDjOKb+NovwatQfpV0YU0oJjHUHahrvPqOd7qpvI=;
 b=aDICdIXlo7HsxY5sIYF4Irx9zLflH9i9RFFBIkChOOnFr5OCdT0psVUnWAhq3JFmvC6HmJAVr1nwyqzqb/qjnGzTungFg4hKYOdmOl3SD6CACWsMuR5TBoaO0ODVT17O4u+VcCiqFoIdS3vfodoTTi3D+ut9qUvq6Ieao8oIRoqRRsiileyCCTejbqHVnspCjFW2uYaGBTjzPt2vKDGsRizpzQTUKIgaPa7P3gok7i07zUqDyxVJQAwx/79D39ATQhaij0qZEG9oYNG4ikkBmwJCrLQTkwX4IStQJy2KjHFcCrI4jKNZeiPCqJmHfspyhyN7j2Xwz8glZepWYLHiqQ==
Received: from BN6PR21CA0006.namprd21.prod.outlook.com (2603:10b6:404:8e::16)
 by SA0PR12MB4349.namprd12.prod.outlook.com (2603:10b6:806:98::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.25; Sun, 5 Sep
 2021 08:57:21 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:8e:cafe::e0) by BN6PR21CA0006.outlook.office365.com
 (2603:10b6:404:8e::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.3 via Frontend
 Transport; Sun, 5 Sep 2021 08:57:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4478.19 via Frontend Transport; Sun, 5 Sep 2021 08:57:21 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 5 Sep
 2021 08:57:20 +0000
Received: from r-arch-stor02.mtr.labs.mlnx (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 5 Sep 2021 08:57:18 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <mst@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <kvm@vger.kernel.org>, <stefanha@redhat.com>
CC:     <linux-block@vger.kernel.org>, <axboe@kernel.dk>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH v2 1/1] virtio-blk: remove unneeded "likely" statements
Date:   Sun, 5 Sep 2021 11:57:17 +0300
Message-ID: <20210905085717.7427-1-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f916004-9468-47a9-639a-08d9704b2c1c
X-MS-TrafficTypeDiagnostic: SA0PR12MB4349:
X-Microsoft-Antispam-PRVS: <SA0PR12MB43493387A619920DE40A38C3DED19@SA0PR12MB4349.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:390;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wxJl1NAuEydfPhVul7/dZ8aOx1tmUbTGUZWQ6yY7oBs10WHnZ0+aUOsVz6KasMr+ktUvXTaY9T3qSHMBEmvh+07RLlyxAOei0hvCWlTY6/1xRsFJLSYnKyK/Smzn2du0UCYTZa8QHNcNNZ+Z7M+JI8RcgmE5pzAp0TeX9k248a7D9bRxknTDkuXHodAiQSmmNRXqddddTuKFaHpIE0kMNgyhFrGBLNgRWi7jG3ZPd3MqRvYLVwz5Rj1/ATj/JBy6UMYSz4ne1/wFPgGX19Y+//LOjf40Briqpdq/3QpnIy2VPvvS8Gsltrre7nod67946lVeHnOXpYE7tEF3+wkfV2uptFrZhdcPegOkhZ3BlB0HLp9NjWvbtDoVDwvmEpaO0/eB7mVhKHqSn8gNAKh86JlVzmwRevEp2UZN4GOKhJwcvVvn/9a1za3F1YgdPJN0wD5XDpyeXr5rGlhdj8RQSHxbpcqyZlO8f4GPmsSDe+LBUjMOYyoRcKnHq26WHO3i/JjrsNCbmHDT5O+DWRwChbybkq4vD4q2fipglFbbHhoaOLYM/PjsC82TqSuior1iRm87itBAAZPAIhJ1lihMKjvc7NIyHLaMWCgOrnTBNp3WJksUnRyyZnXwqr6qVH5pcA7VatNNtBYn/A4UX/TcSpZkXPy362Sgwi6nrozC0g6Olw8MiV1VJTHLQgkP0VbR97cyiRx98av4dRmucqsyDw==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(36840700001)(46966006)(70206006)(1076003)(70586007)(54906003)(110136005)(5660300002)(478600001)(8676002)(4326008)(316002)(36906005)(86362001)(47076005)(82740400003)(36860700001)(356005)(7636003)(336012)(2906002)(2616005)(83380400001)(8936002)(186003)(107886003)(26005)(426003)(82310400003)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2021 08:57:21.2882
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f916004-9468-47a9-639a-08d9704b2c1c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4349
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Usually we use "likely/unlikely" to optimize the fast path. Remove
redundant "likely/unlikely" statements in the control path to simplify
the code and make it easier to read.

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---

changes from v1:
 - added "Reviewed-by" (Stefan)
 - commit description update (Stefan)

---
 drivers/block/virtio_blk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index afb37aac09e8..e574fbf5e6df 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -765,7 +765,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 		goto out_free_vblk;
 
 	/* Default queue sizing is to fill the ring. */
-	if (likely(!virtblk_queue_depth)) {
+	if (!virtblk_queue_depth) {
 		queue_depth = vblk->vqs[0].vq->num_free;
 		/* ... but without indirect descs, we use 2 descs per req */
 		if (!virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC))
@@ -839,7 +839,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 	else
 		blk_size = queue_logical_block_size(q);
 
-	if (unlikely(blk_size < SECTOR_SIZE || blk_size > PAGE_SIZE)) {
+	if (blk_size < SECTOR_SIZE || blk_size > PAGE_SIZE) {
 		dev_err(&vdev->dev,
 			"block size is changed unexpectedly, now is %u\n",
 			blk_size);
-- 
2.18.1

