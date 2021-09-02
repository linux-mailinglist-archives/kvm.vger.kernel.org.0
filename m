Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FEED3FF51E
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 22:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345179AbhIBUr2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 16:47:28 -0400
Received: from mail-bn8nam11on2053.outbound.protection.outlook.com ([40.107.236.53]:9089
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232087AbhIBUr1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 16:47:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YEiRrTDmDJ9PuxbWGR13He+qCfMx+kf4tD0uRDWLAo+Ywe9GnDnAD4P0b+wKdhQHEDFpZcufWYox/2MMfV/y7gYs2Sv9CXo5ywkVKqhfKaNsjCAzyPUQgnYogOr4uATVhn7EWOir5avRMSzIRAb1StIKk6QBFnCCH5Je9OTocF3KKsbJiX6R16gFONIwDZp9AlD1aSE0eBJNsbVVPA/v9OZm7S7ePLGOVCi1vz19rX/z0uVXkyhWDcTHeo5qrMVtceJdwWcvlkQRXnMFUdHVyNcJ2O/cplSeGB4hhPsxiPW7c2zwql9I1tsKwWD8SxQz2tfLPoMRil7y0vvi4/v8Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=VnjG7hOwbHF7uPGb0yfIhfWibnrl1c7MUbuk39LHUsc=;
 b=SmYkGz4GiIyOgbQGjG/qwpiauyuqD7CjXLec6Ad52N/OxImfQgjuUz0J115gn0PzCj5e9THah82q5braelCr2Tfe3miwGrQdUYSYu4OCkxM2DLFxuOD01cXmDI3cJeDY0D3nhFlB6abxB4+vUpEbip4kTa+Dy/U857kKEbzijiI+unBrRQz27uLR9NlLrXGnqNUOEhNZizlyKUthewPU0A0llctZICddbl09v89zPrmIJsMYX+V2oUCA1rFOTunqGW2Pf8xXhfz2bPXcAbMyxT+FLCwLWAFNnoKeaSBGfirpVcxNulYtRkhRByti05H8LYFlseqskVE+HE2GJHnA+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VnjG7hOwbHF7uPGb0yfIhfWibnrl1c7MUbuk39LHUsc=;
 b=jwCxXIS3t2OU1Bz3jogz085bPe58ZLZl47k6wxuu721VP7D0E9DGf/Z5Dnyvi+ZdbdH8Kc29m7i/RPPlYEiFOXrheCMz6s+uTtwKHfbKGb3YXWJNNqrDu22a4SbdQ8irmQv+3bwU5qhfPZo5ZP8ScJdhX7kr7h1rQPoa2NF52Joify/XQp2mqcvjhSbI636Cfeqk/kVa72tHn0fqxcrtLUoniYjgjcKU2/yoQz+WbdqpImIEVvGrVtxP3OfkyglJjOimImZwLQD+S636lu5z3w9pxxQD/Q7MPKKBQJ2M9oPno9eQ4iTcJmAPrgayJGjHQZKN7fL6xpY/g2QqBBa6qg==
Received: from BN9PR03CA0467.namprd03.prod.outlook.com (2603:10b6:408:139::22)
 by DM6PR12MB3289.namprd12.prod.outlook.com (2603:10b6:5:15d::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Thu, 2 Sep
 2021 20:46:27 +0000
Received: from BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:139:cafe::49) by BN9PR03CA0467.outlook.office365.com
 (2603:10b6:408:139::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend
 Transport; Thu, 2 Sep 2021 20:46:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT013.mail.protection.outlook.com (10.13.176.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4478.19 via Frontend Transport; Thu, 2 Sep 2021 20:46:26 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 2 Sep
 2021 20:46:26 +0000
Received: from r-arch-stor02.mtr.labs.mlnx (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 2 Sep 2021 20:46:23 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <hch@infradead.org>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <stefanha@redhat.com>
CC:     <israelr@nvidia.com>, <nitzanc@nvidia.com>, <oren@nvidia.com>,
        <linux-block@vger.kernel.org>, <axboe@kernel.dk>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH v3 1/1] virtio-blk: add num_request_queues module parameter
Date:   Thu, 2 Sep 2021 23:46:22 +0300
Message-ID: <20210902204622.54354-1-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8ee7b6f-9a6c-420e-3157-08d96e52bbf3
X-MS-TrafficTypeDiagnostic: DM6PR12MB3289:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3289562E44D8D1090C3D2E70DECE9@DM6PR12MB3289.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: re8RuBInIxhz0n2n9YIfhpCAclQCjJaLu0Qb7FrGE/mT1JIsvu3K40WatvLZ0Flu3zZNuxUqSHIFMR4fpET0LKWgaoEy2An/oHL4qKhO17O1N+w+tuMsSQ1kY5ToNvoFkAySMgBsB+HSlKhb58xu82F//5u5m1/b+WEnJah41Q5m0wNDIi3j9fIxCFYn4GEuLPWFKDGvSS0Jlr/4o8mi8s7VYMNuAMQOxNk+e4qhiUdU4LYgxhGn2NiY5JHngGE+lqJGY1pYHBD/lXDR2kxWxrQ8Tt9eUUm2sllX/gFD3lDFNjnoUWuoNKKv8+2m1U3n4A4j1A8E7VK5Qt5O3Dwi08RRyiyzXmSA1waA4i/O472vVcdBaOFM0KPWutTB3c1T5kBznYqMkwirc+oyEoGJf8WUDtAzjkEncALC+ZUxN0norllHD/IKEVd251kgKYTVvc5UNKepVjWzvCL8g1qh8If6FSjYGEqnOafESEbYXX1OZXDGuzTjICzZ2GYXpBYADPyRvS3Q1oiruG3oIErF89MSDHNQBAg+7Zb3ed0yr0n68CjMoY4wiiM9Mi4bjOaj04/RHQ48Y2cBECp9zFU2CCRsMrBbVE7Aj81h5ljpJoSckjToMIH/4DXr79ACnZsdvMe8Mi5Ou3u+rFuKXJYvvJmn93vwRayzCHiwC59z3i4cEB4WmcRRjaSdSDK2wUKuMBGvkdYNkgOZtr+kkrfe/Q==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(346002)(136003)(36840700001)(46966006)(316002)(36906005)(54906003)(83380400001)(2906002)(82740400003)(478600001)(107886003)(110136005)(8936002)(8676002)(7636003)(336012)(426003)(356005)(2616005)(186003)(4326008)(26005)(5660300002)(47076005)(36756003)(70586007)(1076003)(70206006)(82310400003)(86362001)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2021 20:46:26.7587
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a8ee7b6f-9a6c-420e-3157-08d96e52bbf3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3289
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sometimes a user would like to control the amount of request queues to
be created for a block device. For example, for limiting the memory
footprint of virtio-blk devices.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---

changes from v2:
 - renamed num_io_queues to num_request_queues (from Stefan)
 - added Reviewed-by signatures (from Stefan and Christoph)

changes from v1:
 - use param_set_uint_minmax (from Christoph)
 - added "Should > 0" to module description

Note: This commit apply on top of Jens's branch for-5.15/drivers

---
 drivers/block/virtio_blk.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 4b49df2dfd23..aaa2833a4734 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -24,6 +24,23 @@
 /* The maximum number of sg elements that fit into a virtqueue */
 #define VIRTIO_BLK_MAX_SG_ELEMS 32768
 
+static int virtblk_queue_count_set(const char *val,
+		const struct kernel_param *kp)
+{
+	return param_set_uint_minmax(val, kp, 1, nr_cpu_ids);
+}
+
+static const struct kernel_param_ops queue_count_ops = {
+	.set = virtblk_queue_count_set,
+	.get = param_get_uint,
+};
+
+static unsigned int num_request_queues;
+module_param_cb(num_request_queues, &queue_count_ops, &num_request_queues,
+		0644);
+MODULE_PARM_DESC(num_request_queues,
+		 "Number of request queues to use for blk device. Should > 0");
+
 static int major;
 static DEFINE_IDA(vd_index_ida);
 
@@ -501,7 +518,9 @@ static int init_vq(struct virtio_blk *vblk)
 	if (err)
 		num_vqs = 1;
 
-	num_vqs = min_t(unsigned int, nr_cpu_ids, num_vqs);
+	num_vqs = min_t(unsigned int,
+			min_not_zero(num_request_queues, nr_cpu_ids),
+			num_vqs);
 
 	vblk->vqs = kmalloc_array(num_vqs, sizeof(*vblk->vqs), GFP_KERNEL);
 	if (!vblk->vqs)
-- 
2.18.1

