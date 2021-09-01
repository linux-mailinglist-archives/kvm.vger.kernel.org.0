Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC40D3FDD0A
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 15:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343876AbhIANDo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 09:03:44 -0400
Received: from mail-co1nam11on2041.outbound.protection.outlook.com ([40.107.220.41]:30272
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343816AbhIANDV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 09:03:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L2qQgwvUUswWSgSjL3uPDICjDnXZCrJTYmlXLk0l/eXPgu4N/s9NEvQ14BdfXSx0tarF6QGSeHDfZIwE6uRG6L107mMPXpmr3S9jGVieQwHLScU0lmiWRc/bzROnYuyaFyu/Lsn5hzZPPbTB6PxkWlPoQk+3L5VM6LiR9yS2gUlFBdTSh0rVVOTSM1tdL1nwldVC1Vemd8tAKlQnh86cYEvvNhJq6ABmeSYt485pAtuo+ZmN8s/YdaAdARKZsDRB/2In9AUlVfDMQ7qG4CKZyLu8qmtrKuIwr136Fc2VC39BxjwKfQyKZn5hGdDujYI+GtuoKw9XMjwfpxQyQEViaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jKljKRwlm7DxoAJhpc9j+/9uP0XIUJhaEPPJXPZqiq0=;
 b=AQHqHgu1mjEiEuW/FD4/9Hsxc+ambkr3K7mO8gv2scEzdGyreQl4lhuk427jnBtlOGvM8fxD9EBdn1waroiwg60VvBDjJoK9xRD6IwiHfdursOh3ehs8meZoQvSYH4YQY7gTNk5jrsievJZo63cpyX5D86G76Kg/nDokuwWLaCiRD2n1jmi1Ffg26Ph6Eku3NIM3fNMt9hdn29OstQg1AzUiPlbLm7emf4s0yTVpckSz+CPQ0ZHC7MXnICjOG6eD3rzE6ujXQd9OtahMQiPWJAMr721TdQnUP3s2QtZAsjigjr6wFSOmO7tW99MwdnTtEZGPTwg4aGwTVbhv4tN9RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jKljKRwlm7DxoAJhpc9j+/9uP0XIUJhaEPPJXPZqiq0=;
 b=srthAGmwG7o2yrYug3y2QKK8nWYBrW/p6wb/FwaVarj9wb+wmyeGqAHwoXJkLdAhjkPxsiizEEKwTRd6DMUR6li8EfXz5h5fPbtztcjmHqFvaGqECFEMMzwCzfVxAjfVWieJSu34x4t5MrvCGFAi0AC2nwpNDKBfgaZP7nbwzexrqRSWqh6dKbNp2XuU7hsNdqp6hMROh7AkH2hOaQipR2xHIWBW/E2HMf/w33J+aIPYVP/c9hn+mWSI0/c6i4oJz+HggIQFgndLhQJbTPYDtCZ1lg/TlgJIn1jbtWXlzhbSUT8vxc5tLTMyBCaftJr1Qi840ftoI9DI0tHkfyVc4Q==
Received: from MW4PR04CA0277.namprd04.prod.outlook.com (2603:10b6:303:89::12)
 by BYAPR12MB2646.namprd12.prod.outlook.com (2603:10b6:a03:65::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.20; Wed, 1 Sep
 2021 13:02:23 +0000
Received: from CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::71) by MW4PR04CA0277.outlook.office365.com
 (2603:10b6:303:89::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend
 Transport; Wed, 1 Sep 2021 13:02:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT065.mail.protection.outlook.com (10.13.174.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4478.19 via Frontend Transport; Wed, 1 Sep 2021 13:02:23 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Sep
 2021 13:02:22 +0000
Received: from r-arch-stor02.mtr.labs.mlnx (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 1 Sep 2021 13:02:20 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <hch@infradead.org>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <stefanha@redhat.com>
CC:     <israelr@nvidia.com>, <nitzanc@nvidia.com>, <oren@nvidia.com>,
        <linux-block@vger.kernel.org>, <axboe@kernel.dk>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH v2 1/1] virtio-blk: avoid preallocating big SGL for data
Date:   Wed, 1 Sep 2021 16:02:19 +0300
Message-ID: <20210901130219.27643-1-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efdccc4a-2d92-432c-02b5-08d96d48bd84
X-MS-TrafficTypeDiagnostic: BYAPR12MB2646:
X-Microsoft-Antispam-PRVS: <BYAPR12MB2646742AF957B58BCF2835FCDECD9@BYAPR12MB2646.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 84KRlpcXcZaT1BZgMujkBIe6xOpDS9rp+PpSUujD+bys7TPirH1f6oasHV6SLw2xxhJlqv7W4BUHARb+u8HIADyjTjlFGhkkqiKP/3LCAKW5v32CMIPdbe65m+EXCXhzi+45ozlC1FbhZZ2i7bOMyxNpsIuQZzXs6qkASugbkrxLNENMqp2nnHKNmjUaIxDPdkRre/NzfMZIM2H26o5TS5xCZcbpqo24Hn8A/kEBuB41t7/zDNfsv9dqZFYuWRmhxK+GoYlPDqoT5iCsvY61B27U+27TqVQdsGY7oMtf5/WvaDdR/G15i9lPWw0Xi92yHgtM3RkRHXAiQhzlA9wlKtkpVkFJ1eqXXfHeLp4z1n+lBk/8y40xdX30+mgEl/1QPeQUWXexLJ2qJo/dmFKcey4ulP4r/iFpIfxumR2Z6QmZG/WvQVzA8ZDboOV1gHdMbu7Ycsyit4Ct/fK0Hdc2ki1VkOI1pPhHHTAtygPJD1E3P2spSK4jh3aC3wk5kHZX1BUNp2BY8lTNIdTIVowTOU1H69KgyRkNRMgIiPurFub9hjBiXuDIibhEoyOVaxGaF2DWZbimpD5qZewqRYU3S9h5V1NqW555Tza2SDRb2VI23IZPEn4/AKAgSwde7LTk61zwa7UqCc7FqY4OYto9OV68ZBdE3Ov+oMJbc9FYqYB+yc3aHbGWn8OMeY/emRKF7NwJMXENFw77pMQ/PEThRA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(8936002)(2616005)(1076003)(47076005)(83380400001)(82310400003)(36860700001)(86362001)(5660300002)(70206006)(508600001)(336012)(110136005)(26005)(70586007)(8676002)(356005)(36756003)(107886003)(4326008)(7636003)(186003)(54906003)(316002)(426003)(2906002)(36906005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2021 13:02:23.3214
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: efdccc4a-2d92-432c-02b5-08d96d48bd84
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2646
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

Re-organize the setup of the IO request to fit the new sg chain
mechanism.

No performance degradation was seen (fio libaio engine with 16 jobs and
128 iodepth):

IO size      IOPs Rand Read (before/after)         IOPs Rand Write (before/after)
--------     ---------------------------------    ----------------------------------
512B          318K/316K                                    329K/325K

4KB           323K/321K                                    353K/349K

16KB          199K/208K                                    250K/275K

128KB         36K/36.1K                                    39.2K/41.7K

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Reviewed-by: Israel Rukshin <israelr@nvidia.com>
---

changes from V1:
 - Kconfig update (from Christoph)
 - Re-order cmd setup (from Christoph)
 - use flexible sg pointer in the cmd (from Christoph)
 - added perf numbers to commit msg (from Feng Li)

---
 drivers/block/Kconfig      |   1 +
 drivers/block/virtio_blk.c | 153 +++++++++++++++++++++++--------------
 2 files changed, 98 insertions(+), 56 deletions(-)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 63056cfd4b62..ca25a122b8ee 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -395,6 +395,7 @@ config XEN_BLKDEV_BACKEND
 config VIRTIO_BLK
 	tristate "Virtio block driver"
 	depends on VIRTIO
+	select SG_POOL
 	help
 	  This is the virtual block driver for virtio.  It can be used with
           QEMU based VMMs (like KVM or Xen).  Say Y or M.
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 9332fc4e9b31..7a1efa2a619e 100644
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
@@ -93,6 +99,7 @@ struct virtio_blk {
 struct virtblk_req {
 	struct virtio_blk_outhdr out_hdr;
 	u8 status;
+	struct sg_table sg_table;
 	struct scatterlist sg[];
 };
 
@@ -178,15 +185,92 @@ static int virtblk_setup_discard_write_zeroes(struct request *req, bool unmap)
 	return 0;
 }
 
-static inline void virtblk_request_done(struct request *req)
+static void virtblk_unmap_data(struct request *req, struct virtblk_req *vbr)
 {
-	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
+	if (blk_rq_nr_phys_segments(req))
+		sg_free_table_chained(&vbr->sg_table,
+				      VIRTIO_BLK_INLINE_SG_CNT);
+}
+
+static int virtblk_map_data(struct blk_mq_hw_ctx *hctx, struct request *req,
+		struct virtblk_req *vbr)
+{
+	int err;
+
+	if (!blk_rq_nr_phys_segments(req))
+		return 0;
+
+	vbr->sg_table.sgl = vbr->sg;
+	err = sg_alloc_table_chained(&vbr->sg_table,
+				     blk_rq_nr_phys_segments(req),
+				     vbr->sg_table.sgl,
+				     VIRTIO_BLK_INLINE_SG_CNT);
+	if (unlikely(err))
+		return -ENOMEM;
 
+	return blk_rq_map_sg(hctx->queue, req, vbr->sg_table.sgl);
+}
+
+static void virtblk_cleanup_cmd(struct request *req)
+{
 	if (req->rq_flags & RQF_SPECIAL_PAYLOAD) {
 		kfree(page_address(req->special_vec.bv_page) +
 		      req->special_vec.bv_offset);
 	}
+}
+
+static int virtblk_setup_cmd(struct virtio_device *vdev, struct request *req,
+		struct virtblk_req *vbr)
+{
+	bool unmap = false;
+	u32 type;
+
+	switch (req_op(req)) {
+	case REQ_OP_READ:
+		type = VIRTIO_BLK_T_IN;
+		vbr->out_hdr.sector = cpu_to_virtio64(vdev,
+						      blk_rq_pos(req));
+		break;
+	case REQ_OP_WRITE:
+		type = VIRTIO_BLK_T_OUT;
+		vbr->out_hdr.sector = cpu_to_virtio64(vdev,
+						      blk_rq_pos(req));
+		break;
+	case REQ_OP_FLUSH:
+		type = VIRTIO_BLK_T_FLUSH;
+		break;
+	case REQ_OP_DISCARD:
+		type = VIRTIO_BLK_T_DISCARD;
+		break;
+	case REQ_OP_WRITE_ZEROES:
+		type = VIRTIO_BLK_T_WRITE_ZEROES;
+		unmap = !(req->cmd_flags & REQ_NOUNMAP);
+		break;
+	case REQ_OP_DRV_IN:
+		type = VIRTIO_BLK_T_GET_ID;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return BLK_STS_IOERR;
+	}
+
+	vbr->out_hdr.type = cpu_to_virtio32(vdev, type);
+	vbr->out_hdr.ioprio = cpu_to_virtio32(vdev, req_get_ioprio(req));
+
+	if (type == VIRTIO_BLK_T_DISCARD || type == VIRTIO_BLK_T_WRITE_ZEROES) {
+		if (virtblk_setup_discard_write_zeroes(req, unmap))
+			return BLK_STS_RESOURCE;
+	}
+
+	return 0;
+}
 
+static inline void virtblk_request_done(struct request *req)
+{
+	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
+
+	virtblk_unmap_data(req, vbr);
+	virtblk_cleanup_cmd(req);
 	blk_mq_end_request(req, virtblk_result(vbr));
 }
 
@@ -244,57 +328,23 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
 	int qid = hctx->queue_num;
 	int err;
 	bool notify = false;
-	bool unmap = false;
-	u32 type;
 
 	BUG_ON(req->nr_phys_segments + 2 > vblk->sg_elems);
 
-	switch (req_op(req)) {
-	case REQ_OP_READ:
-	case REQ_OP_WRITE:
-		type = 0;
-		break;
-	case REQ_OP_FLUSH:
-		type = VIRTIO_BLK_T_FLUSH;
-		break;
-	case REQ_OP_DISCARD:
-		type = VIRTIO_BLK_T_DISCARD;
-		break;
-	case REQ_OP_WRITE_ZEROES:
-		type = VIRTIO_BLK_T_WRITE_ZEROES;
-		unmap = !(req->cmd_flags & REQ_NOUNMAP);
-		break;
-	case REQ_OP_DRV_IN:
-		type = VIRTIO_BLK_T_GET_ID;
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		return BLK_STS_IOERR;
-	}
-
-	vbr->out_hdr.type = cpu_to_virtio32(vblk->vdev, type);
-	vbr->out_hdr.sector = type ?
-		0 : cpu_to_virtio64(vblk->vdev, blk_rq_pos(req));
-	vbr->out_hdr.ioprio = cpu_to_virtio32(vblk->vdev, req_get_ioprio(req));
+	err = virtblk_setup_cmd(vblk->vdev, req, vbr);
+	if (unlikely(err))
+		return err;
 
 	blk_mq_start_request(req);
 
-	if (type == VIRTIO_BLK_T_DISCARD || type == VIRTIO_BLK_T_WRITE_ZEROES) {
-		err = virtblk_setup_discard_write_zeroes(req, unmap);
-		if (err)
-			return BLK_STS_RESOURCE;
-	}
-
-	num = blk_rq_map_sg(hctx->queue, req, vbr->sg);
-	if (num) {
-		if (rq_data_dir(req) == WRITE)
-			vbr->out_hdr.type |= cpu_to_virtio32(vblk->vdev, VIRTIO_BLK_T_OUT);
-		else
-			vbr->out_hdr.type |= cpu_to_virtio32(vblk->vdev, VIRTIO_BLK_T_IN);
+	num = virtblk_map_data(hctx, req, vbr);
+	if (unlikely(num < 0)) {
+		virtblk_cleanup_cmd(req);
+		return BLK_STS_RESOURCE;
 	}
 
 	spin_lock_irqsave(&vblk->vqs[qid].lock, flags);
-	err = virtblk_add_req(vblk->vqs[qid].vq, vbr, vbr->sg, num);
+	err = virtblk_add_req(vblk->vqs[qid].vq, vbr, vbr->sg_table.sgl, num);
 	if (err) {
 		virtqueue_kick(vblk->vqs[qid].vq);
 		/* Don't stop the queue if -ENOMEM: we may have failed to
@@ -303,6 +353,8 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
 		if (err == -ENOSPC)
 			blk_mq_stop_hw_queue(hctx);
 		spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
+		virtblk_unmap_data(req, vbr);
+		virtblk_cleanup_cmd(req);
 		switch (err) {
 		case -ENOSPC:
 			return BLK_STS_DEV_RESOURCE;
@@ -681,16 +733,6 @@ static const struct attribute_group *virtblk_attr_groups[] = {
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
@@ -703,7 +745,6 @@ static const struct blk_mq_ops virtio_mq_ops = {
 	.queue_rq	= virtio_queue_rq,
 	.commit_rqs	= virtio_commit_rqs,
 	.complete	= virtblk_request_done,
-	.init_request	= virtblk_init_request,
 	.map_queues	= virtblk_map_queues,
 };
 
@@ -783,7 +824,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 	vblk->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
 	vblk->tag_set.cmd_size =
 		sizeof(struct virtblk_req) +
-		sizeof(struct scatterlist) * sg_elems;
+		sizeof(struct scatterlist) * VIRTIO_BLK_INLINE_SG_CNT;
 	vblk->tag_set.driver_data = vblk;
 	vblk->tag_set.nr_hw_queues = vblk->num_vqs;
 
-- 
2.18.1

