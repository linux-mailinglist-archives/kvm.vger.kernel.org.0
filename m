Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBA43FBF4D
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 01:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238964AbhH3XNr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 19:13:47 -0400
Received: from mail-dm6nam12on2075.outbound.protection.outlook.com ([40.107.243.75]:6241
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232217AbhH3XNr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 19:13:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QvK65rNEHDeznR9hqhSnCxP7Rl3MhaeoFvcy2z7YnaV5/2CYr+3CGdaEMzySwTR1Pa/MpxdquzHV7MMaxXH+Pew+UzjjpwKoxcPGLAECmibUxuIVTxgPg7a7FF97LWdtkuM2/136Cl8nvSvkSDBvsbQw2rcgvM2uudEFExuU+DdZLPNScuTXehKHZyEHsCUp6ND4NXLK/yia/xdjJ0dsqn9nIs0USHM8G51w7ovSxaRI2T/FFbdPYsJPAO/y1LtVN1t4z7La1/yhqIYtpiaADgcooxPK2QM5bO4JgsPMuqSxuTfHspVEqFAlITsMpudmwK7WxiV7zTwWsIvw+/ExyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WATPr2r5RBHJTIh4ecGQd6ZakZtex5hPykcAI3xY7cE=;
 b=F5tzidGtNyjCV0CtOcIShlwyN1drTMYkICUwY8JAVL0tG6VUaCKXL7jVIj2c2QwTIxTmrwWDZvJFJGYNiQw0FGflcHgJNbfYEoRZ37UTGMUl8E9kase/FY1LVgDyPlICtoLcWY7lz/F3tU9wBc/nSoZO0sO2SAJ90WpKfzL0YlvJENvgto5RoVksjifzyCixaDNPnoO6dUlVIjJBEJVktuIEPZT0Ljn1iTEIWKWGcQySvs3WVc02avxz44wJVijsgWOUl3fLiUoKXY9MBohXv4FeJs/0T7iWkMSLZtrfntPXp6ILUROl3hFL54V/TBwvkCYrVL/jefv6CtJJVTgg2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WATPr2r5RBHJTIh4ecGQd6ZakZtex5hPykcAI3xY7cE=;
 b=nPbY+/ru3bHzw+Jm9ORqGbZvk+LFhAlI/+oBvju8qh9juXEVP9wjginA7RV7+KLAMsjDSumESupcLIqqlDgkkynyhQcNIuNCxjGz0o1/PdDHjlisxKaQ5gcOym4efeNOo5xNpIBajv3kf7AOmEeGEDYsLP3Qffh8uReLbUKFAgq381UFs8Rz5OXNphy/X0oA2/mwEXeGujyVvoz1HXZLnQHQ05/OiItrlddp3kpWJxas/HTTW31DxAJdJMWEaBhOIKFjOxQkhMJZlAyeCNzYkEwC4JTRdGETU11xNnSZQJzQwTvR7oGc0QwVkEIz8ZdMiA+HUwu8DRK9updUeCVtDA==
Received: from BN0PR04CA0037.namprd04.prod.outlook.com (2603:10b6:408:e8::12)
 by DM5PR12MB1402.namprd12.prod.outlook.com (2603:10b6:3:73::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Mon, 30 Aug
 2021 23:12:51 +0000
Received: from BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e8:cafe::55) by BN0PR04CA0037.outlook.office365.com
 (2603:10b6:408:e8::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Mon, 30 Aug 2021 23:12:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT044.mail.protection.outlook.com (10.13.177.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Mon, 30 Aug 2021 23:12:51 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 30 Aug
 2021 23:12:51 +0000
Received: from [172.27.1.120] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 30 Aug
 2021 23:12:48 +0000
Subject: Re: [PATCH 1/1] virtio-blk: add num_io_queues module parameter
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <stefanha@redhat.com>, <oren@nvidia.com>,
        <linux-block@vger.kernel.org>, <axboe@kernel.dk>
References: <20210830120023.22202-1-mgurtovoy@nvidia.com>
 <20210830174345-mutt-send-email-mst@kernel.org>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <a34524d0-3a77-c560-8544-1dae92a92172@nvidia.com>
Date:   Tue, 31 Aug 2021 02:12:44 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210830174345-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc23c2b8-0634-408f-b00e-08d96c0bb0c9
X-MS-TrafficTypeDiagnostic: DM5PR12MB1402:
X-Microsoft-Antispam-PRVS: <DM5PR12MB140273D61463BDFAE4965866DECB9@DM5PR12MB1402.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NfhoMygH/3KRyZodl7XYQuMEayy2f5Ik+mGU0RIO7BlZcqPElek/jIkUEYXZPUWv24TQcCwsGc1jXp++brbHoJGLHY2rE1FmAhglXXjCM6gCsgysvJOKfZrLyhzLhFovOTgmWJp5UXiAvCyMJpk/HPrJjc4j5vGvptIn1uJlKbdVvoFxA2mrp4ed68S80X2wZFMtGz7JoiWCmDOCVwPpduZr1HovXdnIlF1jEsR6DlfAbSS6gsO/wr4SC0Iqrre9vPK3aIyUP30bQj5pHajWzA/M8US4Ii/H9CvG1NWamuHUDKmyB/6ShLACHhhYjXXDEsO9EayHmmKfaiwDL2KSQYJWSQ7e2p7PHmm6rDUlIwdteW2UdnMfrUwHxmAZjsWsZqBzBfDabQsgXTRsISxJy6PoFgGUQ3OOHSAHp0gCT5e1HPYCj8/U1/+L5+txvtmANANoH5w/uejYflKFZMtyCZJ4FX2noV30he2+rEd0WKc0TsD6GJsPe2pBGuItQtsjR70qYq1jRgVZpWZBATjRK/1TgoNHpynVxjrncppHA+sA6ildU6uUv1aWdj93ExTcHwJBo2iuOcQZ/CBaptSnLQ7J2LbScWQDyxnR8o8EZSDlKWVVEfv6Y+gCU/KlDjKCvGCkHL2g7htiQyMd6i8gJTY/A5kyCA4ZAE32B0w+oHTgGE5OW6BOHVClWW9Gw2uifR5RFrcq3Sk+g1oBEGnbAcY1WkTbV6X5JZbHuBus+eM=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(396003)(376002)(36840700001)(46966006)(16526019)(36756003)(5660300002)(54906003)(6916009)(6666004)(316002)(186003)(36906005)(336012)(31686004)(4326008)(2616005)(7636003)(26005)(8936002)(47076005)(70586007)(8676002)(53546011)(2906002)(83380400001)(82310400003)(31696002)(36860700001)(70206006)(478600001)(356005)(426003)(16576012)(82740400003)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2021 23:12:51.4284
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc23c2b8-0634-408f-b00e-08d96c0bb0c9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1402
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/31/2021 12:48 AM, Michael S. Tsirkin wrote:
> On Mon, Aug 30, 2021 at 03:00:23PM +0300, Max Gurtovoy wrote:
>> Sometimes a user would like to control the amount of IO queues to be
>> created for a block device. For example, for limiting the memory
>> footprint of virtio-blk devices.
>>
>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>
> Hmm. It's already limited by # of CPUs... Why not just limit
> from the hypervisor side? What's the actual use-case here?

Limiting and minimizing resource allocation is a real use case.

# of CPUs today might be 64 or 128. HW virtio-blk device might have this 
amount of queues (or at least 32).

But it's a waste to use all the queues since the device may reach to max 
IOPs with less queues. Multiply this by 16 or 32 devices we get a lot of 
memory wasted without a real need.

It's a common configuration we do in NVMf connect command and it can 
also be seen in other drivers in some variation (null_blk.submit_queues, 
ib_srp.ch_count and more).

Another use case is to add some flexibility for QOS.

Also if we can set the queue depth, it's a good idea to control the 
queue count as well.

If no objections, I'll take the comment from Christoph and send v2.

>
>> ---
>>   drivers/block/virtio_blk.c | 26 +++++++++++++++++++++++++-
>>   1 file changed, 25 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>> index e574fbf5e6df..77e8468e8593 100644
>> --- a/drivers/block/virtio_blk.c
>> +++ b/drivers/block/virtio_blk.c
>> @@ -24,6 +24,28 @@
>>   /* The maximum number of sg elements that fit into a virtqueue */
>>   #define VIRTIO_BLK_MAX_SG_ELEMS 32768
>>   
>> +static int virtblk_queue_count_set(const char *val,
>> +		const struct kernel_param *kp)
>> +{
>> +	unsigned int n;
>> +	int ret;
>> +
>> +	ret = kstrtouint(val, 10, &n);
>> +	if (ret != 0 || n > nr_cpu_ids)
>> +		return -EINVAL;
>> +	return param_set_uint(val, kp);
>> +}
>> +
>> +static const struct kernel_param_ops queue_count_ops = {
>> +	.set = virtblk_queue_count_set,
>> +	.get = param_get_uint,
>> +};
>> +
>> +static unsigned int num_io_queues;
>> +module_param_cb(num_io_queues, &queue_count_ops, &num_io_queues, 0644);
>> +MODULE_PARM_DESC(num_io_queues,
>> +		 "Number of IO virt queues to use for blk device.");
>> +
>>   static int major;
>>   static DEFINE_IDA(vd_index_ida);
>>   
>> @@ -501,7 +523,9 @@ static int init_vq(struct virtio_blk *vblk)
>>   	if (err)
>>   		num_vqs = 1;
>>   
>> -	num_vqs = min_t(unsigned int, nr_cpu_ids, num_vqs);
>> +	num_vqs = min_t(unsigned int,
>> +			min_not_zero(num_io_queues, nr_cpu_ids),
>> +			num_vqs);
>>   
>>   	vblk->vqs = kmalloc_array(num_vqs, sizeof(*vblk->vqs), GFP_KERNEL);
>>   	if (!vblk->vqs)
>> -- 
>> 2.18.1
