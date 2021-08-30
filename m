Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A233D3FBF77
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 01:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236771AbhH3XgC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 19:36:02 -0400
Received: from mail-bn8nam12on2041.outbound.protection.outlook.com ([40.107.237.41]:25227
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231601AbhH3XgB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 19:36:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kRVqkgpTn/MOd0RkX8RiTMmDOygpdOyZiYPnb2s7R2axSSdEzKkRyn3XegAbRDSXzokfwYfnIszDw6McJR/LNeDx8fTqRHqGKAVfzV75yfQBnAQLFgS0jYpV15TauUjBlK9CPG6zRtGduaia7rW5AjjSTfKZnn0Sw+dUg426Q+F/e10TTl/UxXxtZh0BfSe6BCvE1wi7nz4CAcHdwTa3GV3pbMt4/MGfLnGciAkJkP87kpi8CVx4ZXN4Zy44RJSBBTbF4//b9zFxUnzRIPC+XlJ1n+m1pJnOZI7udHTt34GXfVD+L59i6BWvgiCMxKkDBF1ePTSlFrng4igmfVPSCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lNTxPTCtUTA4Dvtxj447/Y12jvJKagIZd2UOMvY4RNg=;
 b=LCHxSWIf4fg0wA7hfXdatPpLiUvaZkx+QFFE7BqH9aLsmnm8vrwdOZGavozcq8IU2IcGCYlUhMdRwkrryTpsmI0r6kQPLQ+vEqcyopbNi9qPTAQSfG54dSGN95dLKjP3yVPjbX4EIan2bp0fzL4KhcxpSSeeOrEEtIpw7XRFJPZRubdjSxV/IJTfi4Ohi2om6bdc9hv/VfaxBeq885li9kOAUBjKD1SK9dBFit8mh/dU4kZakWRhrY4RBMe9p2O3xp2dEztciiOG7pwFS0NkOa3JxeX+nHJVchvNHyHFOC2ywEooUFp8AoNxJzb//VDwaN0Pa2G8h2M1UgIpZFBJMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lNTxPTCtUTA4Dvtxj447/Y12jvJKagIZd2UOMvY4RNg=;
 b=FIQ3UM7vf6RK1Bn4rdMRs98KXQI+N0H6OnehgYNMXizZ2nGnTv5a+Dej1pCmiikVCNoeDSCwyT5Q/mRa87c7My8OSueQrn9d0lIS4DVl7PW2vSbZg3Z3PIelyJRyBIF8Fdvupi/81ArwWzf5OkvU+YoG8479D+qzuAXOLRL3tU+j8M/1Okh2p/8PbXcsnUDiwMk/uvZpga9io9uFnQ6vIKCg30YhhM9Lzh9bYID5/Evcg4LyieBytuz80Ry5mPDZxwvvR9RaBeJmILTB8R7EBga7GMRhnXJ/YHNAGMAFpeK5Xkgbt3KO6EwbhZJh1uJujpkp7aFjy44iKeiNa1vBEA==
Received: from BN9PR03CA0725.namprd03.prod.outlook.com (2603:10b6:408:110::10)
 by MW2PR12MB2444.namprd12.prod.outlook.com (2603:10b6:907:11::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.24; Mon, 30 Aug
 2021 23:35:05 +0000
Received: from BN8NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:110:cafe::f) by BN9PR03CA0725.outlook.office365.com
 (2603:10b6:408:110::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18 via Frontend
 Transport; Mon, 30 Aug 2021 23:35:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT042.mail.protection.outlook.com (10.13.177.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Mon, 30 Aug 2021 23:35:04 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 30 Aug
 2021 23:35:03 +0000
Received: from r-arch-stor02.mtr.labs.mlnx (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 30 Aug 2021 23:35:01 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <hch@infradead.org>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <stefanha@redhat.com>
CC:     <israelr@nvidia.com>, <nitzanc@nvidia.com>, <oren@nvidia.com>,
        <linux-block@vger.kernel.org>, <axboe@kernel.dk>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 1/1] virtio-blk: avoid preallocating big SGL for data
Date:   Tue, 31 Aug 2021 02:35:00 +0300
Message-ID: <20210830233500.51395-1-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3bc2df1-3406-4a4b-c0a3-08d96c0ecb97
X-MS-TrafficTypeDiagnostic: MW2PR12MB2444:
X-Microsoft-Antispam-PRVS: <MW2PR12MB2444FDA0750342100CF60B3FDECB9@MW2PR12MB2444.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1122;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SSgyUhTB6woPfnpQASXIMJP+yIci+NSr9/G/7WkmMO3d64sZ/WxaEb6hqhRrNZfI9eVwqu5jgntgZOIwyMN9QvZoO6gH8C9hcZVYP0mI0OUO9xMS5Ytq9C98UKZroVG0/QCOWvN7EXKhDhNQm9SAtQ2PoKdOmwcC03MuBNWzkxWdG0Q1BsOjFz/LOXF5qtPNleY/ZQ+yHNIl2O6xnEFLvDlC0woouEhC6qZZzpbujJ1RmTFj4t6i9mDEkcbEdnPhj++z1UuHLkUgEPtNsur57HMEcEpBmwaRoikKnhQBgVoOiVrnNuywHAbddCKColvNAj4uGah+2o2va5nvI/DE0I1gvLMxS8kzM4ftdL10R0JXGpzH2PsDfVcdSG5Zdm3O0xhSLG2MblBlQdo5rU0gaEc7c5VlnellJtb4r005r4n69PCxeok8BgS+juvIuObRd6gRvw6vJOgAG0e9UveDuIXLRUolDGWEzyHSEbDnf/Fqc98iTqZ9Xs0ajxfhYgy9ydAy/j0Z7glUHli5mb36NTTSOO6r4ZljBkcQ0d1uzzrCjWvIiaEokRfkAsAu97szCS51ADIg5OeQis9oFR2cpnzXzVeLrJ/Ulsy1L+npygCTUv/f+K7JNSFxmKWFbmIQuy55GgZcGXBxGvVJWj/EsH63jq+TRgsjPYwgIdL/rkVSeGyleWv6GJLvfwh9TkbPf7SDaH99cagLNO+ujClqDQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(346002)(39860400002)(36840700001)(46966006)(54906003)(1076003)(83380400001)(110136005)(8936002)(86362001)(70206006)(4326008)(70586007)(5660300002)(2906002)(82310400003)(336012)(47076005)(36860700001)(36756003)(82740400003)(2616005)(26005)(426003)(107886003)(356005)(7636003)(8676002)(36906005)(186003)(316002)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2021 23:35:04.9118
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e3bc2df1-3406-4a4b-c0a3-08d96c0ecb97
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2444
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No need to pre-allocate a big buffer for the IO SGL anymore. If a device
has lots of deep queues, preallocation for the sg list can consume
substantial amounts of memory. For HW virtio-blk device, nr_hw_queues
can be 64 or 128 and each queue's depth might be 128. This means the
resulting preallocation for the data SGLs is big.

Switch to runtime allocation for SGL for lists longer than 2 entries.
This is the approach used by NVMe drivers so it should be reasonable for
virtio block as well. Runtime SGL allocation has always been the case
for the legacy I/O path so this is nothing new.

The preallocated small SGL depends on SG_CHAIN so if the ARCH doesn't
support SG_CHAIN, use only runtime allocation for the SGL.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Reviewed-by: Israel Rukshin <israelr@nvidia.com>
---
 drivers/block/virtio_blk.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 77e8468e8593..9a4c5d428b58 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -24,6 +24,12 @@
 /* The maximum number of sg elements that fit into a virtqueue */
 #define VIRTIO_BLK_MAX_SG_ELEMS 32768
 
+#ifdef CONFIG_ARCH_NO_SG_CHAIN
+#define VIRTIO_BLK_INLINE_SG_CNT	0
+#else
+#define VIRTIO_BLK_INLINE_SG_CNT	2
+#endif
+
 static int virtblk_queue_count_set(const char *val,
 		const struct kernel_param *kp)
 {
@@ -99,7 +105,7 @@ struct virtio_blk {
 struct virtblk_req {
 	struct virtio_blk_outhdr out_hdr;
 	u8 status;
-	struct scatterlist sg[];
+	struct sg_table sg_table;
 };
 
 static inline blk_status_t virtblk_result(struct virtblk_req *vbr)
@@ -188,6 +194,8 @@ static inline void virtblk_request_done(struct request *req)
 {
 	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
 
+	sg_free_table_chained(&vbr->sg_table, VIRTIO_BLK_INLINE_SG_CNT);
+
 	if (req->rq_flags & RQF_SPECIAL_PAYLOAD) {
 		kfree(page_address(req->special_vec.bv_page) +
 		      req->special_vec.bv_offset);
@@ -291,7 +299,15 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
 			return BLK_STS_RESOURCE;
 	}
 
-	num = blk_rq_map_sg(hctx->queue, req, vbr->sg);
+	vbr->sg_table.sgl = (struct scatterlist *)(vbr + 1);
+	err = sg_alloc_table_chained(&vbr->sg_table,
+				     blk_rq_nr_phys_segments(req),
+				     vbr->sg_table.sgl,
+				     VIRTIO_BLK_INLINE_SG_CNT);
+	if (err)
+		return BLK_STS_RESOURCE;
+
+	num = blk_rq_map_sg(hctx->queue, req, vbr->sg_table.sgl);
 	if (num) {
 		if (rq_data_dir(req) == WRITE)
 			vbr->out_hdr.type |= cpu_to_virtio32(vblk->vdev, VIRTIO_BLK_T_OUT);
@@ -300,7 +316,7 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
 	}
 
 	spin_lock_irqsave(&vblk->vqs[qid].lock, flags);
-	err = virtblk_add_req(vblk->vqs[qid].vq, vbr, vbr->sg, num);
+	err = virtblk_add_req(vblk->vqs[qid].vq, vbr, vbr->sg_table.sgl, num);
 	if (err) {
 		virtqueue_kick(vblk->vqs[qid].vq);
 		/* Don't stop the queue if -ENOMEM: we may have failed to
@@ -309,6 +325,8 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
 		if (err == -ENOSPC)
 			blk_mq_stop_hw_queue(hctx);
 		spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
+		sg_free_table_chained(&vbr->sg_table,
+				      VIRTIO_BLK_INLINE_SG_CNT);
 		switch (err) {
 		case -ENOSPC:
 			return BLK_STS_DEV_RESOURCE;
@@ -687,16 +705,6 @@ static const struct attribute_group *virtblk_attr_groups[] = {
 	NULL,
 };
 
-static int virtblk_init_request(struct blk_mq_tag_set *set, struct request *rq,
-		unsigned int hctx_idx, unsigned int numa_node)
-{
-	struct virtio_blk *vblk = set->driver_data;
-	struct virtblk_req *vbr = blk_mq_rq_to_pdu(rq);
-
-	sg_init_table(vbr->sg, vblk->sg_elems);
-	return 0;
-}
-
 static int virtblk_map_queues(struct blk_mq_tag_set *set)
 {
 	struct virtio_blk *vblk = set->driver_data;
@@ -709,7 +717,6 @@ static const struct blk_mq_ops virtio_mq_ops = {
 	.queue_rq	= virtio_queue_rq,
 	.commit_rqs	= virtio_commit_rqs,
 	.complete	= virtblk_request_done,
-	.init_request	= virtblk_init_request,
 	.map_queues	= virtblk_map_queues,
 };
 
@@ -805,7 +812,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 	vblk->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
 	vblk->tag_set.cmd_size =
 		sizeof(struct virtblk_req) +
-		sizeof(struct scatterlist) * sg_elems;
+		sizeof(struct scatterlist) * VIRTIO_BLK_INLINE_SG_CNT;
 	vblk->tag_set.driver_data = vblk;
 	vblk->tag_set.nr_hw_queues = vblk->num_vqs;
 
-- 
2.18.1

