Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C25E3FDE24
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 16:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbhIAO7k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 10:59:40 -0400
Received: from mail-dm3nam07on2071.outbound.protection.outlook.com ([40.107.95.71]:43841
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230350AbhIAO7g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 10:59:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IsGdT1IRLL7b53j5uNnUNzWznRv/0qH0UUJOrc9wUPFTlyGnyYEwSbYC9ymilF6SsKOHv+HyXxJbwp5LCLp8MA/Caxi8FAR/niuE7elmEbP4TgU5C2IQz3XmPLadFvvGWbqcphQLqi6p0hYzR9xWehTMXzBmR1/uWlvy85ElGKDnBCw3UpF5NRw+1SAZ7IZTdNyT9LDI9xYOGx5OZ9rBePLCdgvSyQoYfAn9DGteb7qgT7F6XNsX75DlIhvvhovt1WKL9sj8qU3ZAnaXw8/HNniGqd74tv2AcUAmY456YUk03CpA1E4JTS/OX/RzN6ClXJy1T6DEMd2vj9zEKuct9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=U8N2TovuKFI8N0vcs4qIWcCHXyyOA/zYle8huvQkGUc=;
 b=eA4PzWXq+H323VcUAqS7BKNtM9H3t01BfGOHszARqa8nC9gYUPDyNQRUAdqxaLU6iIcuIK/DYjDIS+Inks3tuqcQQOrl8OVc8aF6SOoATn9nISaYv5nhjVDC9eKUZLtBQbgo/TJdgZRjapf6SnwNaWwNu07hdvImlLu0raOHJT24i5stLBuNsrvzBJez9CHF6zIc7X12+AuOi8Ho8RXzZsM5UYp82tfH/vrxzQHw2E6XLSWV/9wXUWYJnKzLjdv7iUhS19aZvd81IUtizkDd9s8RkC0QrPmlNQhs3zoTkh6hCrVRKY2quds3u+HhFni/tcIO2rQIkefWjtILy8MgYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=infradead.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U8N2TovuKFI8N0vcs4qIWcCHXyyOA/zYle8huvQkGUc=;
 b=Lj/oWpXUBjae3cqe7YPo7l/eG235cdgV1/mSToYYkZZq3aYJcVltzLdhnA3TP8dSdAfOgmeigmqJd/rQr4OJoIuENggIKS3vBQC4/faGbiJn8FCOLuTcvxwUitimcRHcv/crEdWDAoBVuneo6nyRJUUUmQxSCHaUU/pl4WP2lSpTd+Ofi/VniM25Ef4kEpV8tIuUev9fNhZdN26eLqsFLc6e1yyQsY4rzPaKd16qOkW2mmA/VarvCqp2nliJCNWRP5sV/cP2DQA4WND06NHd1QDVM+a74wgx6cL3Xm2hkM+DybykmTo4oZapcZKwR6SEfOt/TpieHwJgiuk7x4/b0w==
Received: from DM5PR07CA0084.namprd07.prod.outlook.com (2603:10b6:4:ad::49) by
 DM5PR12MB1305.namprd12.prod.outlook.com (2603:10b6:3:75::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4478.19; Wed, 1 Sep 2021 14:58:38 +0000
Received: from DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ad:cafe::1a) by DM5PR07CA0084.outlook.office365.com
 (2603:10b6:4:ad::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.20 via Frontend
 Transport; Wed, 1 Sep 2021 14:58:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT024.mail.protection.outlook.com (10.13.172.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4478.19 via Frontend Transport; Wed, 1 Sep 2021 14:58:37 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Sep
 2021 14:58:37 +0000
Received: from [172.27.12.69] (172.20.187.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Sep 2021
 14:58:34 +0000
Subject: Re: [PATCH v3 1/1] virtio-blk: avoid preallocating big SGL for data
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     <hch@infradead.org>, <virtualization@lists.linux-foundation.org>,
        <kvm@vger.kernel.org>, <stefanha@redhat.com>, <israelr@nvidia.com>,
        <nitzanc@nvidia.com>, <oren@nvidia.com>,
        <linux-block@vger.kernel.org>, <axboe@kernel.dk>
References: <20210901131434.31158-1-mgurtovoy@nvidia.com>
 <20210901102623-mutt-send-email-mst@kernel.org>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <89d6dc30-a876-b1b0-4ff4-605415113611@nvidia.com>
Date:   Wed, 1 Sep 2021 17:58:31 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210901102623-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77de53d1-e04b-4f97-5e77-08d96d58faae
X-MS-TrafficTypeDiagnostic: DM5PR12MB1305:
X-Microsoft-Antispam-PRVS: <DM5PR12MB130588B8D1E59DD22FB06834DECD9@DM5PR12MB1305.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0ApmBzqKLX16itVC3qQgulnmUtAP2fLL4IpvbXmW9TGMk5t+4TK7apTESh/sncyNLeF0HK2Ke+xCyxKXg4mfB6+V4SHUqZvttYdZqlvPuvlVaqLyNUjWESikmt1HtasaiwQCSLDMScxEiznRmkq/kTfewRX/zSVDBSg9pYfdghDRs8gQy3PjFQtC7+HZU2yrgMPDxkg2eA+NLwNlmujClJNpr6pyWpHOnT2FwI3C0puRw4/TTmNBjazoVa64TpbH9ouOXTXfDLzNQjk+vkBtSlEuO7uGY17Y+u0NxOA+vc7hvy4vfXEBJfgY27VXR6WX64AimH56s8z9ZAAH4bKDVWviyKijHIM22eK6hikNF06Lfbhrc2OHnTTiOCwW7VD7PAGU6fd4g4O5ehhV+i9JWWeqBiM8dwKOOdtcnDywgbCtgzKO1nyi8lfbxwhmc7h/RJA0jpeJzPBQVTPeYCLgf29AA2/Lvpilj5pGbLHeiIQY3lrfx0RnQ3eN/h5z41AA1t02nYohIilPv9itFpCVHYGFU8MNzn/mHHd2/3QYKOCGWkf5++Yh4zqGezub9Uyg7Mbd97ISZZLlgGHAlgJjbECU8zeCIINuJWDzMjbmeid15hhZHhYRlkm00s+iOdRBe4veXCSlrQHA7/QIS4srCmGzxSn0Mwkc5UjlpJOX5N/+OVYL2O058JXdWrphP0apvQR7+wsZFc1FOqx5XUva5ouHLEb/3h9iR//A50bZafc=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(396003)(346002)(46966006)(36840700001)(2906002)(478600001)(83380400001)(4326008)(86362001)(16576012)(316002)(47076005)(31696002)(36756003)(36860700001)(31686004)(26005)(186003)(53546011)(16526019)(54906003)(2616005)(426003)(6666004)(336012)(36906005)(8676002)(82740400003)(70586007)(8936002)(5660300002)(6916009)(356005)(70206006)(7636003)(82310400003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2021 14:58:37.8877
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 77de53d1-e04b-4f97-5e77-08d96d58faae
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1305
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/1/2021 5:50 PM, Michael S. Tsirkin wrote:
> On Wed, Sep 01, 2021 at 04:14:34PM +0300, Max Gurtovoy wrote:
>> No need to pre-allocate a big buffer for the IO SGL anymore. If a device
>> has lots of deep queues, preallocation for the sg list can consume
>> substantial amounts of memory. For HW virtio-blk device, nr_hw_queues
>> can be 64 or 128 and each queue's depth might be 128. This means the
>> resulting preallocation for the data SGLs is big.
>>
>> Switch to runtime allocation for SGL for lists longer than 2 entries.
>> This is the approach used by NVMe drivers so it should be reasonable for
>> virtio block as well. Runtime SGL allocation has always been the case
>> for the legacy I/O path so this is nothing new.
>>
>> The preallocated small SGL depends on SG_CHAIN so if the ARCH doesn't
>> support SG_CHAIN, use only runtime allocation for the SGL.
>>
>> Re-organize the setup of the IO request to fit the new sg chain
>> mechanism.
>>
>> No performance degradation was seen (fio libaio engine with 16 jobs and
>> 128 iodepth):
>>
>> IO size      IOPs Rand Read (before/after)         IOPs Rand Write (before/after)
>> --------     ---------------------------------    ----------------------------------
>> 512B          318K/316K                                    329K/325K
>>
>> 4KB           323K/321K                                    353K/349K
>>
>> 16KB          199K/208K                                    250K/275K
>>
>> 128KB         36K/36.1K                                    39.2K/41.7K
>>
>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>> Reviewed-by: Israel Rukshin <israelr@nvidia.com>
> Could you use something to give confidence intervals maybe?
> As it is it looks like a 1-2% regression for 512B and 4KB.

1%-2% is not a regression. It's a device/env/test variance.

This is just one test results. I run it many times and got difference by 
+/- 2%-3% in each run for each sides.

Even if I run same driver without changes I get 2%-3% difference between 
runs.

If you have a perf test suite for virtio-blk it will be great if you can 
run it, or maybe Feng Li has.

>
>
>
>> ---
>>
>> changes from V2:
>>   - initialize vbr->out_hdr.sector during virtblk_setup_cmd
>>
>> changes from V1:
>>   - Kconfig update (from Christoph)
>>   - Re-order cmd setup (from Christoph)
>>   - use flexible sg pointer in the cmd (from Christoph)
>>   - added perf numbers to commit msg (from Feng Li)
>>
>> ---
>>   drivers/block/Kconfig      |   1 +
>>   drivers/block/virtio_blk.c | 155 +++++++++++++++++++++++--------------
>>   2 files changed, 100 insertions(+), 56 deletions(-)
>>
>> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
>> index 63056cfd4b62..ca25a122b8ee 100644
>> --- a/drivers/block/Kconfig
>> +++ b/drivers/block/Kconfig
>> @@ -395,6 +395,7 @@ config XEN_BLKDEV_BACKEND
>>   config VIRTIO_BLK
>>   	tristate "Virtio block driver"
>>   	depends on VIRTIO
>> +	select SG_POOL
>>   	help
>>   	  This is the virtual block driver for virtio.  It can be used with
>>             QEMU based VMMs (like KVM or Xen).  Say Y or M.
>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>> index 9332fc4e9b31..bdd6d415bd20 100644
>> --- a/drivers/block/virtio_blk.c
>> +++ b/drivers/block/virtio_blk.c
>> @@ -24,6 +24,12 @@
>>   /* The maximum number of sg elements that fit into a virtqueue */
>>   #define VIRTIO_BLK_MAX_SG_ELEMS 32768
>>   
>> +#ifdef CONFIG_ARCH_NO_SG_CHAIN
>> +#define VIRTIO_BLK_INLINE_SG_CNT	0
>> +#else
>> +#define VIRTIO_BLK_INLINE_SG_CNT	2
>> +#endif
>> +
>>   static int virtblk_queue_count_set(const char *val,
>>   		const struct kernel_param *kp)
>>   {
>> @@ -93,6 +99,7 @@ struct virtio_blk {
>>   struct virtblk_req {
>>   	struct virtio_blk_outhdr out_hdr;
>>   	u8 status;
>> +	struct sg_table sg_table;
>>   	struct scatterlist sg[];
>>   };
>>   
>> @@ -178,15 +185,94 @@ static int virtblk_setup_discard_write_zeroes(struct request *req, bool unmap)
>>   	return 0;
>>   }
>>   
>> -static inline void virtblk_request_done(struct request *req)
>> +static void virtblk_unmap_data(struct request *req, struct virtblk_req *vbr)
>>   {
>> -	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
>> +	if (blk_rq_nr_phys_segments(req))
>> +		sg_free_table_chained(&vbr->sg_table,
>> +				      VIRTIO_BLK_INLINE_SG_CNT);
>> +}
>> +
>> +static int virtblk_map_data(struct blk_mq_hw_ctx *hctx, struct request *req,
>> +		struct virtblk_req *vbr)
>> +{
>> +	int err;
>> +
>> +	if (!blk_rq_nr_phys_segments(req))
>> +		return 0;
>> +
>> +	vbr->sg_table.sgl = vbr->sg;
>> +	err = sg_alloc_table_chained(&vbr->sg_table,
>> +				     blk_rq_nr_phys_segments(req),
>> +				     vbr->sg_table.sgl,
>> +				     VIRTIO_BLK_INLINE_SG_CNT);
>> +	if (unlikely(err))
>> +		return -ENOMEM;
>>   
>> +	return blk_rq_map_sg(hctx->queue, req, vbr->sg_table.sgl);
>> +}
>> +
>> +static void virtblk_cleanup_cmd(struct request *req)
>> +{
>>   	if (req->rq_flags & RQF_SPECIAL_PAYLOAD) {
>>   		kfree(page_address(req->special_vec.bv_page) +
>>   		      req->special_vec.bv_offset);
>>   	}
>> +}
>> +
>> +static int virtblk_setup_cmd(struct virtio_device *vdev, struct request *req,
>> +		struct virtblk_req *vbr)
>> +{
>> +	bool unmap = false;
>> +	u32 type;
>> +
>> +	vbr->out_hdr.sector = 0;
>> +
>> +	switch (req_op(req)) {
>> +	case REQ_OP_READ:
>> +		type = VIRTIO_BLK_T_IN;
>> +		vbr->out_hdr.sector = cpu_to_virtio64(vdev,
>> +						      blk_rq_pos(req));
>> +		break;
>> +	case REQ_OP_WRITE:
>> +		type = VIRTIO_BLK_T_OUT;
>> +		vbr->out_hdr.sector = cpu_to_virtio64(vdev,
>> +						      blk_rq_pos(req));
>> +		break;
>> +	case REQ_OP_FLUSH:
>> +		type = VIRTIO_BLK_T_FLUSH;
>> +		break;
>> +	case REQ_OP_DISCARD:
>> +		type = VIRTIO_BLK_T_DISCARD;
>> +		break;
>> +	case REQ_OP_WRITE_ZEROES:
>> +		type = VIRTIO_BLK_T_WRITE_ZEROES;
>> +		unmap = !(req->cmd_flags & REQ_NOUNMAP);
>> +		break;
>> +	case REQ_OP_DRV_IN:
>> +		type = VIRTIO_BLK_T_GET_ID;
>> +		break;
>> +	default:
>> +		WARN_ON_ONCE(1);
>> +		return BLK_STS_IOERR;
>> +	}
>>   
>> +	vbr->out_hdr.type = cpu_to_virtio32(vdev, type);
>> +	vbr->out_hdr.ioprio = cpu_to_virtio32(vdev, req_get_ioprio(req));
>> +
>> +	if (type == VIRTIO_BLK_T_DISCARD || type == VIRTIO_BLK_T_WRITE_ZEROES) {
>> +		if (virtblk_setup_discard_write_zeroes(req, unmap))
>> +			return BLK_STS_RESOURCE;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static inline void virtblk_request_done(struct request *req)
>> +{
>> +	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
>> +
>> +	virtblk_unmap_data(req, vbr);
>> +	virtblk_cleanup_cmd(req);
>>   	blk_mq_end_request(req, virtblk_result(vbr));
>>   }
>>   
>> @@ -244,57 +330,23 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
>>   	int qid = hctx->queue_num;
>>   	int err;
>>   	bool notify = false;
>> -	bool unmap = false;
>> -	u32 type;
>>   
>>   	BUG_ON(req->nr_phys_segments + 2 > vblk->sg_elems);
>>   
>> -	switch (req_op(req)) {
>> -	case REQ_OP_READ:
>> -	case REQ_OP_WRITE:
>> -		type = 0;
>> -		break;
>> -	case REQ_OP_FLUSH:
>> -		type = VIRTIO_BLK_T_FLUSH;
>> -		break;
>> -	case REQ_OP_DISCARD:
>> -		type = VIRTIO_BLK_T_DISCARD;
>> -		break;
>> -	case REQ_OP_WRITE_ZEROES:
>> -		type = VIRTIO_BLK_T_WRITE_ZEROES;
>> -		unmap = !(req->cmd_flags & REQ_NOUNMAP);
>> -		break;
>> -	case REQ_OP_DRV_IN:
>> -		type = VIRTIO_BLK_T_GET_ID;
>> -		break;
>> -	default:
>> -		WARN_ON_ONCE(1);
>> -		return BLK_STS_IOERR;
>> -	}
>> -
>> -	vbr->out_hdr.type = cpu_to_virtio32(vblk->vdev, type);
>> -	vbr->out_hdr.sector = type ?
>> -		0 : cpu_to_virtio64(vblk->vdev, blk_rq_pos(req));
>> -	vbr->out_hdr.ioprio = cpu_to_virtio32(vblk->vdev, req_get_ioprio(req));
>> +	err = virtblk_setup_cmd(vblk->vdev, req, vbr);
>> +	if (unlikely(err))
>> +		return err;
>>   
>>   	blk_mq_start_request(req);
>>   
>> -	if (type == VIRTIO_BLK_T_DISCARD || type == VIRTIO_BLK_T_WRITE_ZEROES) {
>> -		err = virtblk_setup_discard_write_zeroes(req, unmap);
>> -		if (err)
>> -			return BLK_STS_RESOURCE;
>> -	}
>> -
>> -	num = blk_rq_map_sg(hctx->queue, req, vbr->sg);
>> -	if (num) {
>> -		if (rq_data_dir(req) == WRITE)
>> -			vbr->out_hdr.type |= cpu_to_virtio32(vblk->vdev, VIRTIO_BLK_T_OUT);
>> -		else
>> -			vbr->out_hdr.type |= cpu_to_virtio32(vblk->vdev, VIRTIO_BLK_T_IN);
>> +	num = virtblk_map_data(hctx, req, vbr);
>> +	if (unlikely(num < 0)) {
>> +		virtblk_cleanup_cmd(req);
>> +		return BLK_STS_RESOURCE;
>>   	}
>>   
>>   	spin_lock_irqsave(&vblk->vqs[qid].lock, flags);
>> -	err = virtblk_add_req(vblk->vqs[qid].vq, vbr, vbr->sg, num);
>> +	err = virtblk_add_req(vblk->vqs[qid].vq, vbr, vbr->sg_table.sgl, num);
>>   	if (err) {
>>   		virtqueue_kick(vblk->vqs[qid].vq);
>>   		/* Don't stop the queue if -ENOMEM: we may have failed to
>> @@ -303,6 +355,8 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
>>   		if (err == -ENOSPC)
>>   			blk_mq_stop_hw_queue(hctx);
>>   		spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
>> +		virtblk_unmap_data(req, vbr);
>> +		virtblk_cleanup_cmd(req);
>>   		switch (err) {
>>   		case -ENOSPC:
>>   			return BLK_STS_DEV_RESOURCE;
>> @@ -681,16 +735,6 @@ static const struct attribute_group *virtblk_attr_groups[] = {
>>   	NULL,
>>   };
>>   
>> -static int virtblk_init_request(struct blk_mq_tag_set *set, struct request *rq,
>> -		unsigned int hctx_idx, unsigned int numa_node)
>> -{
>> -	struct virtio_blk *vblk = set->driver_data;
>> -	struct virtblk_req *vbr = blk_mq_rq_to_pdu(rq);
>> -
>> -	sg_init_table(vbr->sg, vblk->sg_elems);
>> -	return 0;
>> -}
>> -
>>   static int virtblk_map_queues(struct blk_mq_tag_set *set)
>>   {
>>   	struct virtio_blk *vblk = set->driver_data;
>> @@ -703,7 +747,6 @@ static const struct blk_mq_ops virtio_mq_ops = {
>>   	.queue_rq	= virtio_queue_rq,
>>   	.commit_rqs	= virtio_commit_rqs,
>>   	.complete	= virtblk_request_done,
>> -	.init_request	= virtblk_init_request,
>>   	.map_queues	= virtblk_map_queues,
>>   };
>>   
>> @@ -783,7 +826,7 @@ static int virtblk_probe(struct virtio_device *vdev)
>>   	vblk->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
>>   	vblk->tag_set.cmd_size =
>>   		sizeof(struct virtblk_req) +
>> -		sizeof(struct scatterlist) * sg_elems;
>> +		sizeof(struct scatterlist) * VIRTIO_BLK_INLINE_SG_CNT;
>>   	vblk->tag_set.driver_data = vblk;
>>   	vblk->tag_set.nr_hw_queues = vblk->num_vqs;
>>   
>> -- 
>> 2.18.1
