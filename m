Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCD9409473
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 16:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241766AbhIMObU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 10:31:20 -0400
Received: from mail-bn8nam11on2086.outbound.protection.outlook.com ([40.107.236.86]:20960
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346079AbhIMO2S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 10:28:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QH0uOR11jD/LCI/jOrjLHhx8CJV7e4BB9yStLlnfpeDDB37RRaTn7kVunTiEuYPgTGcvCpgBRQNoglxeVOE6WLPOm4SZiJzS8pl0TBMUGcX4lsh70/ZDMVQyzBqDopuVvHw41rfxDtunyC3tD0ok6y5bXcU7iUrzdzUcVgEZqSNyj1avJu4Keczt+Z+sGq2WfGAL6krBApQAb/p/SZE9+ZF10P2lDcL5jr8P2Ve7EQ9LTQoIozScuTrZcg9JfSyavmWYYO8QREF5bb6XM3ZW+Zg9NeaRji2zMw45tiZKMhBX5V9ZWn29LratGMqgnRFFxavUJzQ6JXEQ2Q+cFGYV2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=PqtFMWvYYMCCCQqbBsvZvfEr7oaF6mrkOLyUKwgY7Iw=;
 b=AwLy0W/z/If3x2MLnjMDFv2oFZUeDk6LEZ/hYNe+4NTMK1hnhufInXNsoK0H5/8SAVcquoqp0k++qUB3C6oA0++UOzDRiQim8jLxZyWA4oa5SmDIebVKQw9145t8xqDpuky7LncuLrUANTphTQ6jijn1pfOeWQKcNP289+pljt6WpQEqxjwSxP//TmV+UDRaE7B+wOWICXxXfjw5EYLColhrkYMxaNY7zAw/UngT3MONnQCPJMPBVW82y9q2BqKDvrggJL08ukcG2hjbulBYr6FBTIAnb2Bn/NFmEloV+s8c9T9zom8KrCW8YKlqa3hwZhSu8O+Ikgws6xlnvJ4Z1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PqtFMWvYYMCCCQqbBsvZvfEr7oaF6mrkOLyUKwgY7Iw=;
 b=jNo8N/VuI1oGBLs/wtGVVVOWxTf/93IY2FPaVVREfHFYyoCFOzU+GMbTbrT+v+qRD05eIF8TmAK1xDi9FdjiftJ5sWAMgaEpOPJTfwG3JiaJGygziEkibHXY42KdgzhQBl8kjAx2yfSeiNXS0F+Gh+X/y+vruA8hK63TQ1bnY4htVNJrmGbL+f8R/i7vKyr40Z4dyncz0CQvYgPJ/GgfQJHnzs/J27EyRCTNeAr/pWvXEgj4ouerFAJTMX+UBo/AbFNpltma8bQXUdkMVP4k/KelSwyvVwDGDhK9EVDZkdC7BOUi8TNKBN7JDbHIz4ezkGSLNuUzPiEaeA3FqlCsOQ==
Received: from CO1PR15CA0093.namprd15.prod.outlook.com (2603:10b6:101:21::13)
 by DM4PR12MB5213.namprd12.prod.outlook.com (2603:10b6:5:394::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 14:26:59 +0000
Received: from CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:21:cafe::9b) by CO1PR15CA0093.outlook.office365.com
 (2603:10b6:101:21::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend
 Transport; Mon, 13 Sep 2021 14:26:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT040.mail.protection.outlook.com (10.13.174.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 14:26:59 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 13 Sep
 2021 07:23:17 -0700
Received: from [172.27.12.36] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 13 Sep
 2021 14:23:14 +0000
Subject: Re: [PATCH v2 1/1] virtio-blk: add num_io_queues module parameter
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>, <hch@infradead.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <israelr@nvidia.com>, <nitzanc@nvidia.com>, <oren@nvidia.com>,
        <linux-block@vger.kernel.org>, <axboe@kernel.dk>
References: <20210909114029-mutt-send-email-mst@kernel.org>
 <da61fec0-e90f-0020-c836-c2e58d32be27@nvidia.com>
 <20210909123035-mutt-send-email-mst@kernel.org>
 <0cd4ab50-1bb2-3baf-fc00-b2045e8f8eb1@nvidia.com>
 <20210909185525-mutt-send-email-mst@kernel.org>
 <9de9a43a-2d3a-493b-516e-4601778b9237@nvidia.com>
 <20210912050531-mutt-send-email-mst@kernel.org>
 <f58f955e-ef27-fba1-7417-8d37a175e872@nvidia.com>
 <20210912054959-mutt-send-email-mst@kernel.org>
 <eb7c3e87-d71e-9f86-c5c6-6a8b9474f78a@nvidia.com>
 <20210912074308-mutt-send-email-mst@kernel.org>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <3b5b116b-ee91-a3ce-a618-e2153b5680f6@nvidia.com>
Date:   Mon, 13 Sep 2021 17:23:11 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210912074308-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 027e9f16-a377-4f1f-f7c8-08d976c28c04
X-MS-TrafficTypeDiagnostic: DM4PR12MB5213:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5213526FDB62DF9C6400CC63DED99@DM4PR12MB5213.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: coFEe8a/IutnafWD7zm4P4I/VIgCr/+OyOLLxWkI7VdBorEBiMCzmWCDHJZ+R2TD/WI/T5dOTI8V7zzmCN3cSjb+d/rwtQdCRz4tuVb+Hb4co6OGI7iepRM9v3LYoYgLWbbM6egmTFbDHFOy1xZ0zp6Ot8Lmt25+PyXJo32l4OBuLUwXSoIskB5haBnw8m/mPvEUG+QWXQ5XPHy1QLPDddj0t1EPDlfNYTgQg55lME6XTpVMmcnVVFAYcoM1kBH0NuwnQQIS5kP9xnxvN+LVjiwIEzlXAaHHTrprm/W3uNQb0daDvxdwFcoOmz0RMC+RysQIuca7BRyqmXC7BgGinyOnKFnMAZFZ+lFaXPaCdS6kgq/LWfqZPiDQibD2lg+BTzQlYtdvy6gSS5i2X9ujWBiopYY/3kWQCgCW9s1HSsGhVj/WSkiVYA1KF4HQ3i49fUs4r9rUM5/QYOvwG3jbyoTdW5KkrLSxFgUZkpkmGU0IcyCq1ljk3paVtSlVn/mURw3DxAwkB0PGpre1Lei8Emmp1lcfIoZw1VdftNqyr0Uon1CqT03DI0H8DKuNkWxbkuG+YeiOLHcyGYZwTUlu142RX8Dv5hqvPx24Q20zyLquyyTL9KBqG7GAlTAjdBXHqeu/L29mppBFHnX5/z+BPiPs2JNv8+SdPE/2a57dvODnAQpg14QjZpmw4pVmM0ZOzHdWU8Hrz+CPIMiII8w20NCqU8HpG6HORrOXNvumPDg=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(6916009)(86362001)(31696002)(70206006)(36860700001)(508600001)(47076005)(2616005)(31686004)(83380400001)(26005)(186003)(16526019)(5660300002)(336012)(70586007)(54906003)(426003)(8676002)(53546011)(316002)(16576012)(36756003)(4326008)(6666004)(8936002)(82310400003)(7636003)(356005)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 14:26:59.3015
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 027e9f16-a377-4f1f-f7c8-08d976c28c04
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5213
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/12/2021 2:45 PM, Michael S. Tsirkin wrote:
> On Sun, Sep 12, 2021 at 01:33:13PM +0300, Max Gurtovoy wrote:
>> On 9/12/2021 12:50 PM, Michael S. Tsirkin wrote:
>>> On Sun, Sep 12, 2021 at 12:37:26PM +0300, Max Gurtovoy wrote:
>>>> On 9/12/2021 12:07 PM, Michael S. Tsirkin wrote:
>>>>> On Sat, Sep 11, 2021 at 03:56:45PM +0300, Max Gurtovoy wrote:
>>>>>> On 9/10/2021 1:57 AM, Michael S. Tsirkin wrote:
>>>>>>> On Thu, Sep 09, 2021 at 07:45:42PM +0300, Max Gurtovoy wrote:
>>>>>>>> On 9/9/2021 7:31 PM, Michael S. Tsirkin wrote:
>>>>>>>>> On Thu, Sep 09, 2021 at 06:51:56PM +0300, Max Gurtovoy wrote:
>>>>>>>>>> On 9/9/2021 6:40 PM, Michael S. Tsirkin wrote:
>>>>>>>>>>> On Thu, Sep 09, 2021 at 06:37:37PM +0300, Max Gurtovoy wrote:
>>>>>>>>>>>> On 9/9/2021 4:42 PM, Michael S. Tsirkin wrote:
>>>>>>>>>>>>> On Mon, Sep 06, 2021 at 02:59:40PM +0300, Max Gurtovoy wrote:
>>>>>>>>>>>>>> On 9/6/2021 2:20 PM, Michael S. Tsirkin wrote:
>>>>>>>>>>>>>>> On Mon, Sep 06, 2021 at 01:31:32AM +0300, Max Gurtovoy wrote:
>>>>>>>>>>>>>>>> On 9/5/2021 7:02 PM, Michael S. Tsirkin wrote:
>>>>>>>>>>>>>>>>> On Thu, Sep 02, 2021 at 02:45:52PM +0100, Stefan Hajnoczi wrote:
>>>>>>>>>>>>>>>>>> On Tue, Aug 31, 2021 at 04:50:35PM +0300, Max Gurtovoy wrote:
>>>>>>>>>>>>>>>>>>> Sometimes a user would like to control the amount of IO queues to be
>>>>>>>>>>>>>>>>>>> created for a block device. For example, for limiting the memory
>>>>>>>>>>>>>>>>>>> footprint of virtio-blk devices.
>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>>>>>>>>>>>>>>>>>> ---
>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>> changes from v1:
>>>>>>>>>>>>>>>>>>>           - use param_set_uint_minmax (from Christoph)
>>>>>>>>>>>>>>>>>>>           - added "Should > 0" to module description
>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>> Note: This commit apply on top of Jens's branch for-5.15/drivers
>>>>>>>>>>>>>>>>>>> ---
>>>>>>>>>>>>>>>>>>>           drivers/block/virtio_blk.c | 20 +++++++++++++++++++-
>>>>>>>>>>>>>>>>>>>           1 file changed, 19 insertions(+), 1 deletion(-)
>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>>>>>>>>>>>>>>>>>>> index 4b49df2dfd23..9332fc4e9b31 100644
>>>>>>>>>>>>>>>>>>> --- a/drivers/block/virtio_blk.c
>>>>>>>>>>>>>>>>>>> +++ b/drivers/block/virtio_blk.c
>>>>>>>>>>>>>>>>>>> @@ -24,6 +24,22 @@
>>>>>>>>>>>>>>>>>>>           /* The maximum number of sg elements that fit into a virtqueue */
>>>>>>>>>>>>>>>>>>>           #define VIRTIO_BLK_MAX_SG_ELEMS 32768
>>>>>>>>>>>>>>>>>>> +static int virtblk_queue_count_set(const char *val,
>>>>>>>>>>>>>>>>>>> +		const struct kernel_param *kp)
>>>>>>>>>>>>>>>>>>> +{
>>>>>>>>>>>>>>>>>>> +	return param_set_uint_minmax(val, kp, 1, nr_cpu_ids);
>>>>>>>>>>>>>>>>>>> +}
>>>>>>>>>>>>>>> Hmm which tree is this for?
>>>>>>>>>>>>>> I've mentioned in the note that it apply on branch for-5.15/drivers. But now
>>>>>>>>>>>>>> you can apply it on linus/master as well.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>>>> +static const struct kernel_param_ops queue_count_ops = {
>>>>>>>>>>>>>>>>>>> +	.set = virtblk_queue_count_set,
>>>>>>>>>>>>>>>>>>> +	.get = param_get_uint,
>>>>>>>>>>>>>>>>>>> +};
>>>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>>>> +static unsigned int num_io_queues;
>>>>>>>>>>>>>>>>>>> +module_param_cb(num_io_queues, &queue_count_ops, &num_io_queues, 0644);
>>>>>>>>>>>>>>>>>>> +MODULE_PARM_DESC(num_io_queues,
>>>>>>>>>>>>>>>>>>> +		 "Number of IO virt queues to use for blk device. Should > 0");
>>>>>>>>>>>>>>> better:
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> +MODULE_PARM_DESC(num_io_request_queues,
>>>>>>>>>>>>>>> +                "Limit number of IO request virt queues to use for each device. 0 for now limit");
>>>>>>>>>>>>>> You proposed it and I replied on it bellow.
>>>>>>>>>>>>> Can't say I understand 100% what you are saying. Want to send
>>>>>>>>>>>>> a description that does make sense to you but
>>>>>>>>>>>>> also reflects reality? 0 is the default so
>>>>>>>>>>>>> "should > 0" besides being ungrammatical does not seem t"
>>>>>>>>>>>>> reflect what it does ...
>>>>>>>>>>>> if you "modprobe virtio_blk" the previous behavior will happen.
>>>>>>>>>>>>
>>>>>>>>>>>> You can't "modprobe virtio_blk num_io_request_queues=0" since the minimal
>>>>>>>>>>>> value is 1.
>>>>>>>>>>>>
>>>>>>>>>>>> So your description is not reflecting the code.
>>>>>>>>>>>>
>>>>>>>>>>>> We can do:
>>>>>>>>>>>>
>>>>>>>>>>>> MODULE_PARM_DESC(num_io_request_queues, "Number of request virt queues to use for blk device. Minimum value is 1 queue");
>>>>>>>>>>> What's the default value? We should document that.
>>>>>>>>>> default value for static global variables is 0.
>>>>>>>>>>
>>>>>>>>>> MODULE_PARM_DESC(num_io_request_queues, "Number of request virt queues to
>>>>>>>>>> use for blk device. Minimum value is 1 queue. Default and Maximum value is
>>>>>>>>>> equal to the total number of CPUs");
>>>>>>>>> So it says it's the # of cpus but yoiu inspect it with
>>>>>>>>> sysfs and it's actually 0. Let's say that's confusing
>>>>>>>>> at the least. why not just let users set it to 0
>>>>>>>>> and document that?
>>>>>>>>>
>>>>>>>> Setting it by the user to 0 makes no sense.
>>>>>>>>
>>>>>>>> We can say "if not set, the value equals to the total number of CPUs".
>>>>>>> the value is 0. it seems to mean "no limit". the actual # of queues is
>>>>>>> then te smaller between # of cpus and # of hardware queues.
>>>>>>> I see no reason not to allow user to set that especially if
>>>>>>> it was originally the value then user changed it
>>>>>>> and is trying to change it back.
>>>>>> I fine with that.
>>>>>>
>>>>>> MODULE_PARM_DESC(num_io_request_queues, "Number of request virt queues to use for blk device. 0 value means no limitation");
>>>>>>
>>>>> OK and the second distinction is that it's a limit on the
>>>>> number, not the actual number. It's never more than what's provided
>>>>> by the hypervisor.
>>>> MODULE_PARM_DESC(num_io_request_queues, "Maximal number of request virt queues to use for blk device. 0 value means no limitation");
>>>>
>>>> is that ok ?
>>> Looks ok. And then do we need to limit this to nr_cpu_ids?
>>> Setting a value that's too high seems harmless ...
>> why would you want that ?
> So one can write a script that keeps working even when hypervisor
> changes the # of CPU IDs.
>
> It's also consistent with other parameters, e.g.:
>
>          clocksource.verify_n_cpus= [KNL]
>                          Limit the number of CPUs checked for clocksources
>                          marked with CLOCK_SOURCE_VERIFY_PERCPU that
>                          are marked unstable due to excessive skew.
>                          A negative value says to check all CPUs, while
>                          zero says not to check any.  Values larger than
>                          nr_cpu_ids are silently truncated to nr_cpu_ids.
>
> 			^^^^^^^^^^^^
>
>                          The actual CPUs are chosen randomly, with
>                          no replacement if the same CPU is chosen twice.

I don't understand how this example is relevant. It's not a blk-mq 
device that allocate queues for submitting IOs.

There is no sense of creating more queues than the #CPUs in the blk-mq 
design.

And also no reason setting it to some high value that we'll silently 
decrease.

Why would anyone write a script with hard coded values of CPUs instead 
of checking it with some linux tool and then set the module param 
accordingly ?


>
>>>>>>>> The actual value of the created queues can be seen in /sys/block/vda/mq/ as
>>>>>>>> done today.
>>>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>>>>           static int major;
>>>>>>>>>>>>>>>>>>>           static DEFINE_IDA(vd_index_ida);
>>>>>>>>>>>>>>>>>>> @@ -501,7 +517,9 @@ static int init_vq(struct virtio_blk *vblk)
>>>>>>>>>>>>>>>>>>>           	if (err)
>>>>>>>>>>>>>>>>>>>           		num_vqs = 1;
>>>>>>>>>>>>>>>>>>> -	num_vqs = min_t(unsigned int, nr_cpu_ids, num_vqs);
>>>>>>>>>>>>>>>>>>> +	num_vqs = min_t(unsigned int,
>>>>>>>>>>>>>>>>>>> +			min_not_zero(num_io_queues, nr_cpu_ids),
>>>>>>>>>>>>>>>>>>> +			num_vqs);
>>>>>>>>>>>>>>>>>> If you respin, please consider calling them request queues. That's the
>>>>>>>>>>>>>>>>>> terminology from the VIRTIO spec and it's nice to keep it consistent.
>>>>>>>>>>>>>>>>>> But the purpose of num_io_queues is clear, so:
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
>>>>>>>>>>>>>>>>> I did this:
>>>>>>>>>>>>>>>>> +static unsigned int num_io_request_queues;
>>>>>>>>>>>>>>>>> +module_param_cb(num_io_request_queues, &queue_count_ops, &num_io_request_queues, 0644);
>>>>>>>>>>>>>>>>> +MODULE_PARM_DESC(num_io_request_queues,
>>>>>>>>>>>>>>>>> +                "Limit number of IO request virt queues to use for each device. 0 for now limit");
>>>>>>>>>>>>>>>> The parameter is writable and can be changed and then new devices might be
>>>>>>>>>>>>>>>> probed with new value.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> It can't be zero in the code. we can change param_set_uint_minmax args and
>>>>>>>>>>>>>>>> say that 0 says nr_cpus.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> I'm ok with the renaming but I prefer to stick to the description we gave in
>>>>>>>>>>>>>>>> V3 of this patch (and maybe enable value of 0 as mentioned above).
