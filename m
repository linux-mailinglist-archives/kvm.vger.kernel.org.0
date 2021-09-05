Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A594011F5
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 00:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbhIEWco (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Sep 2021 18:32:44 -0400
Received: from mail-co1nam11on2064.outbound.protection.outlook.com ([40.107.220.64]:22912
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229510AbhIEWco (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Sep 2021 18:32:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QRxW8tt5JQz/bNSpZ8Wll3CuKVF5EpN7Zl/U9kOfUGrgxI9lU9+sR/CXV+AXL9KDrFwQ/GMxJ2PXBxL2KoFl8XcSq9voTCfJ1nmKCdUig8SiH8U48WfBcrvX3+7k+GTa1MDwzccRtWCd+fVkQzmap2vx36/N5VkzOaTT5xESG4KG5pa28bseOoy5/aAhslonIQHtDG22tcAz2pplWebdbqZEhoPAiGsXyr6WNnDfsddeYQbS0+1bbHlaAzzKUPQsj7ZHrMxRxH/QTP7RMRd1NC494Lp0o0L/xXY70iTrmNkEBT0AMmkiJrDYsdzUvC16CIb6c+be1EWwLLU+Q2SxKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=GccFvgXq3R75ItwnSYjFtCx+DWM3w7HnrcTjpRoBtX8=;
 b=AgDXAfSDYhedvYOv0l66w0KM5hkhqGP7ymvTqbyflFrkR5+8fReYXg5S+JNAdJOWjMHrctXsQJWetTBZ4K7tQk/6A5CmkXmgtm+A+3GbJGULmPqgRRmlgGRVnUGNOS8KlKBBmNvmiCqsTNswTeJgr6reyXuH8lWZa3ZYWtFu4CEYjq8NJhKzKza98yZkQwBRdKOZ45eU/91COIFw/thU+mg3uNb49ABF+vMQI0iqFIWftbLUqE3Ds+cjw97qU9uSzxqBHspZi4ihbwgst1w8//S3eVpt86nvkvR0LKpalkwHswZPDkrpM3IYUYL5tK9VsE54W5j7Oh4+C0URpeoJSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=infradead.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GccFvgXq3R75ItwnSYjFtCx+DWM3w7HnrcTjpRoBtX8=;
 b=dXLKkGTBNErqeQ6u1hiwi3Giyb0bcFp2Y/QPp//K4a1DlfHpV9SgIyxFq20H/rA21eSqEvOB7uWtNkpJonAFOT5AZ0vrx/UwdXIZAZIZHv/AO4XEGfuAcb5TSKDx0l1D7DbyRtqIlqhMxLP4ZZbaGEftTil37k8Wu8GvO+gC4nyBAqOS4ferMUeQRLQgocZs9z6S8l5kq18VbLGhVD/EDW3cUkNGPY+soJGHVGLo/Pl+eRNL8y2ZSLcR5iyM1oGV+rXTFCyaT48TDr3xSnFLlwvUoo88CvX7Ag/P7z+tsbF+xBsY6c5aRlSwmwipWCZhiA6awDrHpC5ogXi8Q93aNA==
Received: from MWHPR04CA0053.namprd04.prod.outlook.com (2603:10b6:300:6c::15)
 by DM6PR12MB2682.namprd12.prod.outlook.com (2603:10b6:5:42::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Sun, 5 Sep
 2021 22:31:38 +0000
Received: from CO1NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:6c:cafe::67) by MWHPR04CA0053.outlook.office365.com
 (2603:10b6:300:6c::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17 via Frontend
 Transport; Sun, 5 Sep 2021 22:31:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT048.mail.protection.outlook.com (10.13.175.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4478.19 via Frontend Transport; Sun, 5 Sep 2021 22:31:38 +0000
Received: from [172.27.0.7] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 5 Sep
 2021 22:31:35 +0000
Subject: Re: [PATCH v2 1/1] virtio-blk: add num_io_queues module parameter
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
CC:     <hch@infradead.org>, <virtualization@lists.linux-foundation.org>,
        <kvm@vger.kernel.org>, <israelr@nvidia.com>, <nitzanc@nvidia.com>,
        <oren@nvidia.com>, <linux-block@vger.kernel.org>, <axboe@kernel.dk>
References: <20210831135035.6443-1-mgurtovoy@nvidia.com>
 <YTDVkDIr5WLdlRsK@stefanha-x1.localdomain>
 <20210905120234-mutt-send-email-mst@kernel.org>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <98309fcd-3abe-1f27-fe52-e8fcc58bec13@nvidia.com>
Date:   Mon, 6 Sep 2021 01:31:32 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210905120234-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 844677d2-0338-4d78-3efc-08d970bced02
X-MS-TrafficTypeDiagnostic: DM6PR12MB2682:
X-Microsoft-Antispam-PRVS: <DM6PR12MB2682EC4130F02D1DBC59B6CFDED19@DM6PR12MB2682.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yPpP/hpgvAOkrwUQwZO5E62rvdrOe4P80k0XeuJjhLRYihE0X2FmK52I2oYfLl9tO5/SN/lNMMANSYfQxCsfQeTi/w2LrL2eb7vCJlTv4KhFbUvhzZUvkJJUZ/aWxpYU5gy/KUbjzFyF7D7CpWxyjvTPp4/8toCFct1CAvm5ot8XhBscSWDhsuTw9nbewY5Lj6lI26q+op/jys1otih5DihGDnix8AomO8SqRTjwpUx1V3QOnRO1C4+QrY2G5SFwh0qSjD/CfB3/3o6zzwX1a1zeqSy9ZytMbUq4mROR/RpyRIRrCsdjho5svCnG2LCz9Qze1BLIpg//DvoGyUwHNIxqDujg2Z5NvpUUVkiQfBK6w7mms6eMzHnLFVy2rnQdliSGSiJMAAMpDqaA1udYcFJiJO74+0m5LPJtldE+khb+iMSIRwlYgd1BQ1tdDTK6FzwQa+NcoZ01Z4ajK6IyRvOi35Nht1dJzNNii4iLjNwen4LFmuP1DuKYc2gJtNCy4ZV4gR2Nep4b9jCypP0xnvWUKxTa/bb0TgIV3lfe/Icy4jZNuInJhOZTx2cfG7v4lPw+glkkCXXGZOPurxdldB4BDEUxhcuxGmKGBcjQjZH6PaA5oX35QuESnneBiATtmLCW7QCcdLTzvp8cXiA/moI+ceFKqWVFB1cCSJrgKXVznp8RGkzdjLbPlLwj1TAERf6h5/Nx4Twf/lH4nV0yM5GzkHZjdQYYyKa+PaVl/AA=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(316002)(36906005)(16576012)(110136005)(54906003)(2906002)(47076005)(70586007)(6666004)(508600001)(356005)(36756003)(7636003)(70206006)(86362001)(336012)(5660300002)(426003)(31696002)(2616005)(31686004)(83380400001)(4326008)(8936002)(53546011)(16526019)(26005)(8676002)(36860700001)(82310400003)(186003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2021 22:31:38.0972
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 844677d2-0338-4d78-3efc-08d970bced02
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2682
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/5/2021 7:02 PM, Michael S. Tsirkin wrote:
> On Thu, Sep 02, 2021 at 02:45:52PM +0100, Stefan Hajnoczi wrote:
>> On Tue, Aug 31, 2021 at 04:50:35PM +0300, Max Gurtovoy wrote:
>>> Sometimes a user would like to control the amount of IO queues to be
>>> created for a block device. For example, for limiting the memory
>>> footprint of virtio-blk devices.
>>>
>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>> ---
>>>
>>> changes from v1:
>>>   - use param_set_uint_minmax (from Christoph)
>>>   - added "Should > 0" to module description
>>>
>>> Note: This commit apply on top of Jens's branch for-5.15/drivers
>>> ---
>>>   drivers/block/virtio_blk.c | 20 +++++++++++++++++++-
>>>   1 file changed, 19 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>>> index 4b49df2dfd23..9332fc4e9b31 100644
>>> --- a/drivers/block/virtio_blk.c
>>> +++ b/drivers/block/virtio_blk.c
>>> @@ -24,6 +24,22 @@
>>>   /* The maximum number of sg elements that fit into a virtqueue */
>>>   #define VIRTIO_BLK_MAX_SG_ELEMS 32768
>>>   
>>> +static int virtblk_queue_count_set(const char *val,
>>> +		const struct kernel_param *kp)
>>> +{
>>> +	return param_set_uint_minmax(val, kp, 1, nr_cpu_ids);
>>> +}
>>> +
>>> +static const struct kernel_param_ops queue_count_ops = {
>>> +	.set = virtblk_queue_count_set,
>>> +	.get = param_get_uint,
>>> +};
>>> +
>>> +static unsigned int num_io_queues;
>>> +module_param_cb(num_io_queues, &queue_count_ops, &num_io_queues, 0644);
>>> +MODULE_PARM_DESC(num_io_queues,
>>> +		 "Number of IO virt queues to use for blk device. Should > 0");
>>> +
>>>   static int major;
>>>   static DEFINE_IDA(vd_index_ida);
>>>   
>>> @@ -501,7 +517,9 @@ static int init_vq(struct virtio_blk *vblk)
>>>   	if (err)
>>>   		num_vqs = 1;
>>>   
>>> -	num_vqs = min_t(unsigned int, nr_cpu_ids, num_vqs);
>>> +	num_vqs = min_t(unsigned int,
>>> +			min_not_zero(num_io_queues, nr_cpu_ids),
>>> +			num_vqs);
>> If you respin, please consider calling them request queues. That's the
>> terminology from the VIRTIO spec and it's nice to keep it consistent.
>> But the purpose of num_io_queues is clear, so:
>>
>> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> I did this:
> +static unsigned int num_io_request_queues;
> +module_param_cb(num_io_request_queues, &queue_count_ops, &num_io_request_queues, 0644);
> +MODULE_PARM_DESC(num_io_request_queues,
> +                "Limit number of IO request virt queues to use for each device. 0 for now limit");

The parameter is writable and can be changed and then new devices might 
be probed with new value.

It can't be zero in the code. we can change param_set_uint_minmax args 
and say that 0 says nr_cpus.

I'm ok with the renaming but I prefer to stick to the description we 
gave in V3 of this patch (and maybe enable value of 0 as mentioned above).

