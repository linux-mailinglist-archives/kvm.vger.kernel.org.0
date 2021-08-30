Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBCA3FB558
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 14:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237198AbhH3MDS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 08:03:18 -0400
Received: from mail-dm6nam10on2081.outbound.protection.outlook.com ([40.107.93.81]:55328
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237127AbhH3MCK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 08:02:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KLVPJxOQQ00JsBZ4UJpk8YlKD3mTf71G25AE0u4nVzYK9GMTi7b5InYiG/bXvPFpu/HNkEKVR4a90Icx9TEOdgMxwLXNi9slVElGl6QE3j0y3PsNaw/cu03I7dsZvH+DgbCrj9jS8bmf6vZOKkpJ5CWbhEtFprU5O/uRxyEcxMMJ557L6eeM+JxNexgPfQEn+fy+7OSGM/h/F8ih15r/hDjsr30re++kg8MV4aCrbDQNV+8bhz+1d3q6GHH5oP+mZOoYCxFgKDaKAlBgDXHyuST+ZIzhvRsO61n9EGV+NKPDbJ462Nu1E0+3y0C5BcWR6UZSg5ZM6eOeyspzpSo0Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cR2jzuPUe3VVqgZb4denocdp6w1fWNYhXzn+EaXmiP8=;
 b=b5vUwjXAJwUmy5JnMTkFsHwwMJ397MIEHCaAfJ5yVdjnvtdKh57XI/s/w7riaxChaaI8sv2qnQEGxGYFoWpgxMBXp9eN+tg3bASoE1PMzYSzFO0TfGqz0eCWGBPaTpi03Mnuyfupp/c4vlnXlQZ577WCXsrxsM5R7VwKKVuailXsd9Igob79TFLSi6MQ+0wojy/ZVKbycKE9ppZmpuCU1MY9UuhAf2cPLGi2tL9wYMJ5aDjCp1S0Rz0lSOoRqZsreCAYdxLd6HnYoo4Q+H5ZfpT+LISxWADjhuqjS2JGzOy2vARKZ/0kOYIyC8dA5ZrpFUFYNobeg+kuZKf7fCvf4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cR2jzuPUe3VVqgZb4denocdp6w1fWNYhXzn+EaXmiP8=;
 b=TG33YbGFd0OkPIWW/zLjIRaLE2vFZUpIG1RRpX1k0Q2/netzOsB63llHLIwmkgNcNa7ePEPjwYdgV8UlFRrXHUHfbT/sPvXD/iS59eF+Xn0nM6Td2fVwiMLrUhP5HiTCXHm3RPl6QGS1hcWmRdoO0q+IrxP+1cKhnY2sQTOJryOMuoZA2xtAQtJ8ztiLG2vxOphaCJgb24SgLnLHSv2QMoJwH6ZXwnR0yNqeNntrgSor6S5sNb95Xf5wbBiMxm7FUDFiinvQD9mfzHT1ZqCd5YkUFYnuaA1miBAAGh4WI0KktE1EobmhcULIXbcz+WWyw0A7n0PTZ+KNRWKfaYqnSA==
Received: from BN6PR11CA0006.namprd11.prod.outlook.com (2603:10b6:405:2::16)
 by DM5PR12MB2375.namprd12.prod.outlook.com (2603:10b6:4:b3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Mon, 30 Aug
 2021 12:01:15 +0000
Received: from BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:2:cafe::37) by BN6PR11CA0006.outlook.office365.com
 (2603:10b6:405:2::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend
 Transport; Mon, 30 Aug 2021 12:01:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT025.mail.protection.outlook.com (10.13.177.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Mon, 30 Aug 2021 12:01:15 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 30 Aug
 2021 12:01:14 +0000
Received: from r-arch-stor02.mtr.labs.mlnx (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 30 Aug 2021 12:01:12 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <mst@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <kvm@vger.kernel.org>, <stefanha@redhat.com>
CC:     <oren@nvidia.com>, <linux-block@vger.kernel.org>,
        <axboe@kernel.dk>, "Max Gurtovoy" <mgurtovoy@nvidia.com>
Subject: [PATCH 1/1] virtio-blk: remove unneeded "likely" statements
Date:   Mon, 30 Aug 2021 15:01:11 +0300
Message-ID: <20210830120111.22661-1-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b0a8c85-1d4e-4767-8c6a-08d96badde7d
X-MS-TrafficTypeDiagnostic: DM5PR12MB2375:
X-Microsoft-Antispam-PRVS: <DM5PR12MB2375918867BAAD3A9C78FC3CDECB9@DM5PR12MB2375.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sp4VWzQpWGsZBbFa/riP5qOs38GmVmSAFCwJIjZ4RhmXzAq3aOYHP+FHs/bUexzXWrJR8H3pV0FzLy0huz+Oq5L0wrTGCANbFjZ6Qv8ErgOv1NSvqHpRrxLlS14doVa/i5V0DDU/SHvGfs3ip7F5xFLPcEjOhVwWjnoAJVLfbGS1rzdSBpoGsiMJs3h2iWn8XsataV6LFHaBObKh55eRheXCyAInovuyl8sy891KNUPWdqZs28P7ZOoYHhFdEgsN17GZRp41pkPWpTCQhwElwHs+6UCzJtHiQoPKid88XzwdSIZ9WNet/axtFhdChsmQ3DGngm7XqjGoU9Txtf9Vmf0BJWFA2mBHaYBP7mCXoyf8L080RCd4rrSBu2/KuFpvE6NoRVqj4yhOuBqxJX2fyxPgnJPYuxa7t+Q/xLB04F5nzkaLTL5tv9W+U/X05UpW+556DhY0Rx+PP/mHhtI61p+A6RlS3mXxHYHrgM7wq7Ft2AYCRSDiC3hotEkbYMv2kHJIR3/vQdal25etjpip3KCKOFilcdYL6bvxQcIgoBkFKRvMXQrab9za5THQQOAPppH3PjA+d2OprEohbH0diScmRFFj3S896CmXC3msgl6k0jlGze8iMd3FRbf9fYThBJpk8+QSZDVt1b9XsX44mz6By1qbuTRFXGbC9FkSuwbO3iThO2thPJbb09lraPW24i1LV+03KS1O4R/KtYy8LA==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(346002)(36840700001)(46966006)(1076003)(5660300002)(36906005)(8676002)(110136005)(70206006)(36756003)(7636003)(356005)(2616005)(316002)(2906002)(4326008)(26005)(83380400001)(47076005)(336012)(86362001)(426003)(82310400003)(36860700001)(70586007)(8936002)(186003)(107886003)(478600001)(54906003)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2021 12:01:15.4350
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b0a8c85-1d4e-4767-8c6a-08d96badde7d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2375
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Usually we use "likely/unlikely" to optimize the fast path. Remove
redundant "likely" statements in the control path to ease on the code.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
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

