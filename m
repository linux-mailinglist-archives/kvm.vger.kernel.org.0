Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664543FD78B
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 12:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234579AbhIAKU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 06:20:27 -0400
Received: from mail-dm6nam11on2075.outbound.protection.outlook.com ([40.107.223.75]:1280
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233214AbhIAKU0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 06:20:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RNSCCcJOn6q52QM+621CwVWabFt50Ex+72LGzaNgJvCJcckdq/PrBGu90BX1m9hdhfEZD3wuE34x+xpPCMGo6J2QjWDvsB7RUYMGGPUvSHWayBHivxqz9ThXiKkJt1NlIWY1ogNMBQyhjafaFPnCg6XuyfV+FcJowZ78OCNSh74U9B3qAJIolkDtCYEdJVN1efld85PZklJeD9nCSYjbCIUXhoEuY4NM4BpaFbSADAWJI9USrFm9MC0cgSzJdD4bPX1SS4wkvZJ4rAr9nUOiK5GoYNhyT3KkuOn5OHHVXZcn5/uOneZ7m3YyqBZKCI3NvZqU1zgP99K+dGXRvZAwXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oPQaiFO/ZfNP9yVUQLcQyezxQBXgP8bWBHbAweMc8Ng=;
 b=lD08Cda7cP+sLHZaIVp912Iqzl0jWHMrcVS6muWjRf+NwXeXbuGzRGRAfHAAwKtmhGrGYf6nLeKcot7jq8wSHilX0VBzeE3CHIRUWc1uthXJFSBZRHPo1DBVTn5jLhxnJfkUG2EBLfMM7CSElazizgwqjpBgTHaroc/s9lPY3B1CzLdiiHF1L8YWmlkH5N42mKEq/mQsvDyBYHinUi+Mimi0SWNqHyWMnXERZ5n5gVEzjrsdzIRE50orXntiMBRSBL0itrPUODbA6dia11fxuvnX0OBvku97+3z0YXPR3HNntl9f6eiicbClKVzCFZoBqsebg2U5omkBHqbLOw6lvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oPQaiFO/ZfNP9yVUQLcQyezxQBXgP8bWBHbAweMc8Ng=;
 b=fNqXvgdJ/61YiDWAVkv3pLp/am8IE6AXGwO0U+Si0HoojYgMNRMKpu2DIJ+8s9fQKHaHfJtkUAP1uuRPVbxbfF3yC0EUuMYQUSB2uizKAOELT/iLnUTUdtTI9T4gKkzPU2JvL175P6DaWOp1kKL2DnSVQBpazunnDhq8snoYrc9oz94Qn2WuHGmoqIAysaL8YAgTJGrC14HZ2VeQxhC+8RT9CqJeVf4NqHI72Q5AVt3cUfUAPJAmCqatRJtH81E5ZOT/K4dlC+ZSfjmw3bqkH9EdEj6dLkYsx5lQkarAGkjTqoGC4BCCN7nsrvLylE7iEVBWd572+8nkSW5AlyY4dg==
Received: from BN6PR22CA0032.namprd22.prod.outlook.com (2603:10b6:404:37::18)
 by MWHPR1201MB0016.namprd12.prod.outlook.com (2603:10b6:300:e4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Wed, 1 Sep
 2021 10:19:28 +0000
Received: from BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:37:cafe::79) by BN6PR22CA0032.outlook.office365.com
 (2603:10b6:404:37::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17 via Frontend
 Transport; Wed, 1 Sep 2021 10:19:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT057.mail.protection.outlook.com (10.13.177.49) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4478.19 via Frontend Transport; Wed, 1 Sep 2021 10:19:27 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Sep
 2021 03:19:26 -0700
Received: from [172.27.12.69] (172.20.187.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Sep 2021
 10:19:23 +0000
Subject: Re: [PATCH 1/1] virtio-blk: avoid preallocating big SGL for data
To:     Feng Li <lifeng1519@gmail.com>
CC:     <hch@infradead.org>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <stefanha@redhat.com>, <israelr@nvidia.com>, <nitzanc@nvidia.com>,
        <oren@nvidia.com>, linux-block <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
References: <20210830233500.51395-1-mgurtovoy@nvidia.com>
 <CAEK8JBBU3zNAWpC36-Lq0UBM1Dp+jYQG105psE38Fy8KRy=M-g@mail.gmail.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <165359fc-8f97-ede3-8ab5-35329ca61dbd@nvidia.com>
Date:   Wed, 1 Sep 2021 13:19:09 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAEK8JBBU3zNAWpC36-Lq0UBM1Dp+jYQG105psE38Fy8KRy=M-g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 489a32a6-609b-49a9-83d4-08d96d31fae5
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0016:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB001669BB715297AD939B343FDECD9@MWHPR1201MB0016.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:565;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b8X9mrEuzISIHJVC57983QVTvXZdft+T8+q8gQb7bBUkrIhLaq3VDzCehD8nw+fnGBzDTdg1Q3GJwtWjM9cHOoRJ9KItSpdwEXjGtco8wmvxXIWoYwszzvJQYM8R+Mk3yRrkRJ3aGZXPqWPusPEqaH1iRGX+sCKZvQVQVcwqvUvJ06nM6iAxpIbY+I1U4yI19YcBnn5vvDY9sF31mnOxPJ2siCpoooEoyBqbnIFjgjrBBY3RTorS5nWOcoRVKuNuZ52T3QIiFh7RGclO754+3HxcrIMdox8bUqNzhluxwe2v/vTnS43SCs1Nrsf0L3bNxousQYdgz1C98NdknZvDZU6gnq3TnT31aKT4IITykY4BDLaQecWr9ws/g1nYJP7YBMca2CUKsdgqRfXfAfGNmh9DT9JF2XEl1NHUI+ldEw3/Tw8BdbnVT3jpcWBFbTqIkw77ZH9z9sKGb18Wb+l1t7C6DYXg6eYGieoQr2M3el/ooRstNMO8WHC0wVSti5m9LxHnDebKGkC4+P5U1KGryAMQUkXAW534AKm/Xt7Xwx2+WIb2FWdAEBCK/FwCqk8zeuMihLh5G3ABlPb2yd70UGnfvuccp0IUO6ZlEse61VZse+a9KNYCJzCFYE2SYPNk3H1M4Szk2umaxOnYa3Nt/+B96dHusM6VBa8vBnckHi+MGkGJcscdDGnorEO9o/FAFbDZjq/tHY47ziOW6zyIPRYLShsjPznQdjyZK5MkaqQ=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(39860400002)(136003)(46966006)(36840700001)(5660300002)(356005)(8936002)(4326008)(36860700001)(7636003)(31696002)(36756003)(47076005)(86362001)(16576012)(6916009)(53546011)(478600001)(31686004)(186003)(82310400003)(6666004)(82740400003)(8676002)(83380400001)(54906003)(426003)(16526019)(336012)(70206006)(316002)(70586007)(26005)(2906002)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2021 10:19:27.8137
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 489a32a6-609b-49a9-83d4-08d96d31fae5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0016
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/1/2021 6:38 AM, Feng Li wrote:
> Does this hurt the performance of virtio-blk?
> I think a fio result is needed here.

No, we use this mechanism in NVMe/NVMf for few years already and didn't 
see any performance issues.

Also with the fio tests I run with our NVIDIA's Virtio-blk SNAP devices 
showed same perf numbers.

I can add it to v2.

>
> On Tue, Aug 31, 2021 at 7:36 AM Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
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
>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>> Reviewed-by: Israel Rukshin <israelr@nvidia.com>
>> ---
>>   drivers/block/virtio_blk.c | 37 ++++++++++++++++++++++---------------
>>   1 file changed, 22 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>> index 77e8468e8593..9a4c5d428b58 100644
>> --- a/drivers/block/virtio_blk.c
>> +++ b/drivers/block/virtio_blk.c
>> @@ -24,6 +24,12 @@
>>   /* The maximum number of sg elements that fit into a virtqueue */
>>   #define VIRTIO_BLK_MAX_SG_ELEMS 32768
>>
>> +#ifdef CONFIG_ARCH_NO_SG_CHAIN
>> +#define VIRTIO_BLK_INLINE_SG_CNT       0
>> +#else
>> +#define VIRTIO_BLK_INLINE_SG_CNT       2
>> +#endif
>> +
>>   static int virtblk_queue_count_set(const char *val,
>>                  const struct kernel_param *kp)
>>   {
>> @@ -99,7 +105,7 @@ struct virtio_blk {
>>   struct virtblk_req {
>>          struct virtio_blk_outhdr out_hdr;
>>          u8 status;
>> -       struct scatterlist sg[];
>> +       struct sg_table sg_table;
>>   };
>>
>>   static inline blk_status_t virtblk_result(struct virtblk_req *vbr)
>> @@ -188,6 +194,8 @@ static inline void virtblk_request_done(struct request *req)
>>   {
>>          struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
>>
>> +       sg_free_table_chained(&vbr->sg_table, VIRTIO_BLK_INLINE_SG_CNT);
>> +
>>          if (req->rq_flags & RQF_SPECIAL_PAYLOAD) {
>>                  kfree(page_address(req->special_vec.bv_page) +
>>                        req->special_vec.bv_offset);
>> @@ -291,7 +299,15 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
>>                          return BLK_STS_RESOURCE;
>>          }
>>
>> -       num = blk_rq_map_sg(hctx->queue, req, vbr->sg);
>> +       vbr->sg_table.sgl = (struct scatterlist *)(vbr + 1);
>> +       err = sg_alloc_table_chained(&vbr->sg_table,
>> +                                    blk_rq_nr_phys_segments(req),
>> +                                    vbr->sg_table.sgl,
>> +                                    VIRTIO_BLK_INLINE_SG_CNT);
>> +       if (err)
>> +               return BLK_STS_RESOURCE;
>> +
>> +       num = blk_rq_map_sg(hctx->queue, req, vbr->sg_table.sgl);
>>          if (num) {
>>                  if (rq_data_dir(req) == WRITE)
>>                          vbr->out_hdr.type |= cpu_to_virtio32(vblk->vdev, VIRTIO_BLK_T_OUT);
>> @@ -300,7 +316,7 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
>>          }
>>
>>          spin_lock_irqsave(&vblk->vqs[qid].lock, flags);
>> -       err = virtblk_add_req(vblk->vqs[qid].vq, vbr, vbr->sg, num);
>> +       err = virtblk_add_req(vblk->vqs[qid].vq, vbr, vbr->sg_table.sgl, num);
>>          if (err) {
>>                  virtqueue_kick(vblk->vqs[qid].vq);
>>                  /* Don't stop the queue if -ENOMEM: we may have failed to
>> @@ -309,6 +325,8 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
>>                  if (err == -ENOSPC)
>>                          blk_mq_stop_hw_queue(hctx);
>>                  spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
>> +               sg_free_table_chained(&vbr->sg_table,
>> +                                     VIRTIO_BLK_INLINE_SG_CNT);
>>                  switch (err) {
>>                  case -ENOSPC:
>>                          return BLK_STS_DEV_RESOURCE;
>> @@ -687,16 +705,6 @@ static const struct attribute_group *virtblk_attr_groups[] = {
>>          NULL,
>>   };
>>
>> -static int virtblk_init_request(struct blk_mq_tag_set *set, struct request *rq,
>> -               unsigned int hctx_idx, unsigned int numa_node)
>> -{
>> -       struct virtio_blk *vblk = set->driver_data;
>> -       struct virtblk_req *vbr = blk_mq_rq_to_pdu(rq);
>> -
>> -       sg_init_table(vbr->sg, vblk->sg_elems);
>> -       return 0;
>> -}
>> -
>>   static int virtblk_map_queues(struct blk_mq_tag_set *set)
>>   {
>>          struct virtio_blk *vblk = set->driver_data;
>> @@ -709,7 +717,6 @@ static const struct blk_mq_ops virtio_mq_ops = {
>>          .queue_rq       = virtio_queue_rq,
>>          .commit_rqs     = virtio_commit_rqs,
>>          .complete       = virtblk_request_done,
>> -       .init_request   = virtblk_init_request,
>>          .map_queues     = virtblk_map_queues,
>>   };
>>
>> @@ -805,7 +812,7 @@ static int virtblk_probe(struct virtio_device *vdev)
>>          vblk->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
>>          vblk->tag_set.cmd_size =
>>                  sizeof(struct virtblk_req) +
>> -               sizeof(struct scatterlist) * sg_elems;
>> +               sizeof(struct scatterlist) * VIRTIO_BLK_INLINE_SG_CNT;
>>          vblk->tag_set.driver_data = vblk;
>>          vblk->tag_set.nr_hw_queues = vblk->num_vqs;
>>
>> --
>> 2.18.1
>>
