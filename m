Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB9E438738
	for <lists+kvm@lfdr.de>; Sun, 24 Oct 2021 09:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbhJXHWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Oct 2021 03:22:38 -0400
Received: from mail-dm6nam12on2042.outbound.protection.outlook.com ([40.107.243.42]:6112
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229638AbhJXHWi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Oct 2021 03:22:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dtXgzt8SfWgx4xeHBYGhRITCuTABTBY+oomKKK7ZW919Px9BF/U2YyT3C6gVWiRqHVkwpA/YWnFscmpTLfcZpFESowa7sHt2SW0xaBN2G7LlerFRryM3cq/8i49NRA5+Zx2WYT7LoD1JlTz6/9B5k9qz95rQiL2E96uEUyPl8YgLE3uW/xNvCUxPa6XmT2Z5FDlYzdi9Lxe6ww+ed5iVa9yNlmTIKiCiY3CH0otUs/Om6OVauTJsaM/GHag9v+z6iIPxnoCgo6Nvf+gfg6pOpXiCuAdhE0vA0BPP6Gg2mYRz7BuHs56TpCGcWTivXphBWvKDbK14V9VvqNco2i61qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+6Pg6HsRHuaWuHrsvD14GMHhqbo3H+AG7q4EA95Obik=;
 b=CRRwqR27pm2QIMtvcuQyOmcySnkBajwKs2RmSj6jFagKQU1mv7wcc31CtW8lPJ+K3PAo4eL3Fftgcd/83gGD4LSjAS1AzrU/Z4uzeI/mQIjtmY2lR2IkOEAVDM/hcsREgLjbGeiCIqjXk56hBAVsqDxescWp50F01jjn19EqM4WKCIuTxKjzCQiIkSTZWAtvFm380Kvgg5Bets9JTHBuSak6Pq4KwTJHUzPdTTVEbERCeqnLNkkA1j9/OABIkpkLf09LZpEfxriL1EKcRCd24GBrKve3H2kijUsv636ZnorADtK9blxfqe6Ip0XnzQyS7DNPJMXTA7uIheXBk03iWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+6Pg6HsRHuaWuHrsvD14GMHhqbo3H+AG7q4EA95Obik=;
 b=Lx3vbeQDBNmLli+mbSPm2IK4HdL3v3wMn7XM7uZ4iMthQc0DZVQa1aeKB1Wco22LqKD6FxiUXCS/xHTxKS3zMiSCFJ1eJM7dYndPWoi1HLPh6mZ1mfKSgiOHqNqngE+J/SWokikVo75e9OmWa4CsQ/4Bgb1LZgkqKNik6utQfpn9HNbEBNhoEJOXPniIm+mj+Wcc3AriUrZ86uWkwqu+Oe4umq/J5dyyiSmdgRddkqib/dFQBtq7ebNbhczgzxPLSfwZl/5Igb/FsF5//KjXx2jkTF1aQmogfRI1ysWLBk7yW8rp5BNI/F2XP3CIewWbLpu48ozcYz0NIHV+f21arA==
Received: from DM6PR03CA0082.namprd03.prod.outlook.com (2603:10b6:5:333::15)
 by CH2PR12MB5563.namprd12.prod.outlook.com (2603:10b6:610:6a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Sun, 24 Oct
 2021 07:20:15 +0000
Received: from DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:333:cafe::df) by DM6PR03CA0082.outlook.office365.com
 (2603:10b6:5:333::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend
 Transport; Sun, 24 Oct 2021 07:20:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT051.mail.protection.outlook.com (10.13.172.243) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Sun, 24 Oct 2021 07:20:15 +0000
Received: from [172.27.13.118] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 24 Oct
 2021 07:20:11 +0000
Message-ID: <19cbe00a-409c-fd4b-4466-6b9fe650229f@nvidia.com>
Date:   Sun, 24 Oct 2021 10:19:51 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3 1/1] virtio-blk: add num_request_queues module
 parameter
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     <hch@infradead.org>, <virtualization@lists.linux-foundation.org>,
        <kvm@vger.kernel.org>, <stefanha@redhat.com>, <israelr@nvidia.com>,
        <nitzanc@nvidia.com>, <oren@nvidia.com>,
        <linux-block@vger.kernel.org>, <axboe@kernel.dk>
References: <20210902204622.54354-1-mgurtovoy@nvidia.com>
 <20211022052950-mutt-send-email-mst@kernel.org>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <20211022052950-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae0bba88-86a5-43c8-e70c-08d996beb9b7
X-MS-TrafficTypeDiagnostic: CH2PR12MB5563:
X-Microsoft-Antispam-PRVS: <CH2PR12MB556346C3196B974E7703B8D2DE829@CH2PR12MB5563.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0ZWwV1CLv+bOXhXBd1jlnXj8ZB6Vx3OhEM50XEN07MSwZ/b5/XQl3NdIj5rtEVo4kE0M0R5OZ+mVB5EeTWBqoLPrECNYslbSZ/xy9T8k0mkcWX3TRrLRu/4VvXOAogOCPB4SUPEfYUb9kV+cpDuLa8ElmiweuAHLheFRJfbSk/QmxJXNxQZcEiYMFgQRORYcRCQpg2TAIFeRmWGpMoFxjJVDhgDg76rbDfDJvo6dvICUxKql6KPjDDY/LU2/XUbKX27M3TO+EhXwcTAkuk83cPIKyQn87Pti/7Tdvb7m8Scieb2lQvwF2s0tCuqwwJIQkoud8ItM+BRok4gcikN9ybTWb5Hhb9WasqaLe0hlEZWNkiSgDnRtENO+NvX1c2Jy1yOeZ6wSoaVvr/E4qeO9HracdRUwS1ZeOkZatdCg1apUA7MYJCppkRs4Kpj8SSW0O1Ombx9GyGCZMVsH3ga8ovRBEEJMokKh+6RGv1sNP5PIp3bdFz7sn8WC1lpwhiLulG0S6dB5IsLPLJlbVzk00KDAD7ww0cVAXGBk30u7PRGfpG39uOpiIHyPKB/YA7ePiIji3B4pCUdS7x4Ww2fAVmIDIxlh6xbtO16U/TEOjZyUoqP8TqUPNUeOqi9csrTr6lFsqYH/GC/m+V0gWD6Ro8FGC5qqgsH97x595HWISorts7V45c0EhD+S0PswKRIka/HjaHk4lgOjZoU+tVaX6jOj5+2LRtZU+Mr7sIVXuAA=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(8676002)(31686004)(6666004)(4326008)(426003)(336012)(54906003)(70586007)(5660300002)(2906002)(508600001)(82310400003)(83380400001)(16576012)(70206006)(356005)(6916009)(316002)(36860700001)(53546011)(31696002)(86362001)(2616005)(8936002)(36756003)(7636003)(47076005)(26005)(16526019)(186003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2021 07:20:15.2276
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae0bba88-86a5-43c8-e70c-08d996beb9b7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5563
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/22/2021 12:30 PM, Michael S. Tsirkin wrote:
> On Thu, Sep 02, 2021 at 11:46:22PM +0300, Max Gurtovoy wrote:
>> Sometimes a user would like to control the amount of request queues to
>> be created for a block device. For example, for limiting the memory
>> footprint of virtio-blk devices.
>>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>> ---
>>
>> changes from v2:
>>   - renamed num_io_queues to num_request_queues (from Stefan)
>>   - added Reviewed-by signatures (from Stefan and Christoph)
>>
>> changes from v1:
>>   - use param_set_uint_minmax (from Christoph)
>>   - added "Should > 0" to module description
>>
>> Note: This commit apply on top of Jens's branch for-5.15/drivers
>>
>> ---
>>   drivers/block/virtio_blk.c | 21 ++++++++++++++++++++-
>>   1 file changed, 20 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>> index 4b49df2dfd23..aaa2833a4734 100644
>> --- a/drivers/block/virtio_blk.c
>> +++ b/drivers/block/virtio_blk.c
>> @@ -24,6 +24,23 @@
>>   /* The maximum number of sg elements that fit into a virtqueue */
>>   #define VIRTIO_BLK_MAX_SG_ELEMS 32768
>>   
>> +static int virtblk_queue_count_set(const char *val,
>> +		const struct kernel_param *kp)
>> +{
>> +	return param_set_uint_minmax(val, kp, 1, nr_cpu_ids);
>> +}
>> +
>> +static const struct kernel_param_ops queue_count_ops = {
>> +	.set = virtblk_queue_count_set,
>> +	.get = param_get_uint,
>> +};
>> +
>> +static unsigned int num_request_queues;
>> +module_param_cb(num_request_queues, &queue_count_ops, &num_request_queues,
>> +		0644);
>> +MODULE_PARM_DESC(num_request_queues,
>> +		 "Number of request queues to use for blk device. Should > 0");
>> +
>>   static int major;
>>   static DEFINE_IDA(vd_index_ida);
>>   
> I wasn't happy with the message here so I tweaked it.
>
> Please look at it in linux-next and confirm. Thanks!

Looks good.


>
>
>> @@ -501,7 +518,9 @@ static int init_vq(struct virtio_blk *vblk)
>>   	if (err)
>>   		num_vqs = 1;
>>   
>> -	num_vqs = min_t(unsigned int, nr_cpu_ids, num_vqs);
>> +	num_vqs = min_t(unsigned int,
>> +			min_not_zero(num_request_queues, nr_cpu_ids),
>> +			num_vqs);
>>   
>>   	vblk->vqs = kmalloc_array(num_vqs, sizeof(*vblk->vqs), GFP_KERNEL);
>>   	if (!vblk->vqs)
>> -- 
>> 2.18.1
