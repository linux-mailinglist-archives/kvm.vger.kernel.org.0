Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F91407CAC
	for <lists+kvm@lfdr.de>; Sun, 12 Sep 2021 11:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233339AbhILJiu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Sep 2021 05:38:50 -0400
Received: from mail-dm6nam10on2079.outbound.protection.outlook.com ([40.107.93.79]:39009
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231302AbhILJit (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Sep 2021 05:38:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BLP7Y3y+Zs4oeGXtjzdnDd3apcKNPmMA2+KyXm7vF6PvDgBaq85fsE48S/zWcU8u8uBZ4/Ver3az3H5LNQaoR+IHcp+n3NNt/DELGYgIuefw76Ove9gilrtywcar1yq0jxC+tAk0eH7MC0B0UyTRwFEzTWlcq1oxWj2JlpFn03KxPFWRw9bDkJbe/LPrNfIgb1SlUV40IKHpi8yPiq+hkH8axCBhwx1fAVL2+3GGc7mbiIpL+mbLnypd4kGjPgX4tF/YjDO29IAIbzObaUJKP1EzcWDVgTZIydVMvbND7B+mjC0NR5XK85b5pz7ENuaOhLlCj86q+x80MqaZQ2PbdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=9mOKFQSPsg1V9nvrMeBRXENl0U+oHXLe9zRFXbbMfsY=;
 b=Uc4E1eF2qs6tt+klwSJvCb6zFZ2K9f07Q+ZUHwcuSZj18uOXt9uEVpNP/Fcv42Wg9KzakjXxH+g23Y+cAp6sMhhWHK+IGAtD/Hupdh53KXVWfjINjLV/FrE0gl7h5TUblbBfMnd4QZcW+F9zCSUEyyK8ZLKw0Ez2oAtgf2Js+MMDffjCPwKkjlKK04qZZnyt7rn5M+It9Cc4GjensTfVNHnX/+mJJFhEp5TTqYN1PRsQGcjW9vW8f225GCDL5mBqGvs4frFcFIDME5ZpHjQthwU7VdR1twPy6SdeBr+IfYZAi+q5CEJo4KYDtvhp8CXWcv02vgbP0FyR9jD9oX/KJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9mOKFQSPsg1V9nvrMeBRXENl0U+oHXLe9zRFXbbMfsY=;
 b=d9rqv0quLZVXiY2EgAp5NG2NBABQ2B7HtT/jpyh73pORbCN9G2LYMdzcuJJYeq9DpkwL37ueB/zdkXU0Su7kL45OAcJVRYcoqEZG4BSBnT0nqJpdtZH2JYRUXZZMDevB62nsZnFzxGKE5K9XFRCsJsLduaGZf2GoxqxNtGD3h2VcnYfFy0FU5DqKgv6UgYW1E0kcxvwZhXARJ9QVOI+IMBsSKlLnGerBC3jBDd99HgR3swe3ofkaNAOv0gOTKhzCQioZfDa97IVFCeAdzfMUCBhnsQchE1YieQh0TvzGbqmOsNdR2DCCDQDU6X1XfrlFgzMGgdTLiaFJ+BlNUiJSBQ==
Received: from BN6PR19CA0108.namprd19.prod.outlook.com (2603:10b6:404:a0::22)
 by DM6PR12MB3402.namprd12.prod.outlook.com (2603:10b6:5:3b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.18; Sun, 12 Sep
 2021 09:37:33 +0000
Received: from BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:a0:cafe::ad) by BN6PR19CA0108.outlook.office365.com
 (2603:10b6:404:a0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16 via Frontend
 Transport; Sun, 12 Sep 2021 09:37:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT025.mail.protection.outlook.com (10.13.177.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4500.14 via Frontend Transport; Sun, 12 Sep 2021 09:37:33 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 12 Sep
 2021 09:37:32 +0000
Received: from [172.27.15.193] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 12 Sep
 2021 09:37:29 +0000
Subject: Re: [PATCH v2 1/1] virtio-blk: add num_io_queues module parameter
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>, <hch@infradead.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <israelr@nvidia.com>, <nitzanc@nvidia.com>, <oren@nvidia.com>,
        <linux-block@vger.kernel.org>, <axboe@kernel.dk>
References: <20210906071957-mutt-send-email-mst@kernel.org>
 <1cbbe6e2-1473-8696-565c-518fc1016a1a@nvidia.com>
 <20210909094001-mutt-send-email-mst@kernel.org>
 <456e1704-67e9-aac9-a82a-44fed65dd153@nvidia.com>
 <20210909114029-mutt-send-email-mst@kernel.org>
 <da61fec0-e90f-0020-c836-c2e58d32be27@nvidia.com>
 <20210909123035-mutt-send-email-mst@kernel.org>
 <0cd4ab50-1bb2-3baf-fc00-b2045e8f8eb1@nvidia.com>
 <20210909185525-mutt-send-email-mst@kernel.org>
 <9de9a43a-2d3a-493b-516e-4601778b9237@nvidia.com>
 <20210912050531-mutt-send-email-mst@kernel.org>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <f58f955e-ef27-fba1-7417-8d37a175e872@nvidia.com>
Date:   Sun, 12 Sep 2021 12:37:26 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210912050531-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b65f62b-7a6b-4907-0802-08d975d0f28a
X-MS-TrafficTypeDiagnostic: DM6PR12MB3402:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3402EF0230742305218E223DDED89@DM6PR12MB3402.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kxUGyaPw0DjNY9TWOALM2WDydvX3axgU1aq0JWnSXZH0X6NuW6QYDpCMmnNHBQu8eBBQ+M+oJOiAZyPeSh8wO29VJ9KgFUpxUUdFH7a0swydx7TXmF4a1yMarxLn6P0Dm0kRFUvbChx0ahNCrubT4gY7GAHBJFcSIQFrdt1d0xL5rZn7ey/5/eo6May6CCU2VxEHCu9E9GMIQOW2vC85SjYtkwM8uCrkiQ3xepMUtZXHUp+bl4adrM7ARu1bghBoTBgfczlDRBcEbxEaMcEHexQyeQlufe8mZWPK8/enFffRFl4skrf9zLvRkpfvKdsqOxZHSi1vvAt7jSbiWxPBjvgUdJvNc3q4VOYl/3Su5tS4b1rwFgHWTt6rxBxf1UpDztZfCBs5xI1ly9cI+E9Bw92SpDbrdcswBxOgdsyM8M3CMUkOLVb2x2sIA0DNw9Eu5uZX2sLj6hsaDfoaEMlk7S84JIWM5KzWcOXd8o9lZPulfk8ftVa7LYE5Iay40+RQfEl4wjcDQpchmGv7qPdA5S81N99omMYvZ9A3O0XZEb4SowHjgD5aqJqAj1ufKLO6rhAdanl9sjWoC/G+4bn8cuh+h4yg43o5fkt0Sr5yoWmkFy5UHgpOgKQI/Bb10APn04eZEA+JcnH/JdEuP51DQnmRq6guAdZSi/ZzTbT3GSipIHriEY5jFhKdyyy5/DsqE4JD752grPxDJf3u74ilfarY6bIPRu8m5t5FQkWg/cQ=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(136003)(39860400002)(36840700001)(46966006)(8936002)(83380400001)(36860700001)(4326008)(316002)(36756003)(26005)(6666004)(31686004)(70206006)(86362001)(8676002)(16576012)(336012)(70586007)(186003)(36906005)(53546011)(16526019)(426003)(82310400003)(7636003)(2906002)(478600001)(356005)(6916009)(2616005)(31696002)(47076005)(5660300002)(54906003)(82740400003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2021 09:37:33.0716
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b65f62b-7a6b-4907-0802-08d975d0f28a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3402
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/12/2021 12:07 PM, Michael S. Tsirkin wrote:
> On Sat, Sep 11, 2021 at 03:56:45PM +0300, Max Gurtovoy wrote:
>> On 9/10/2021 1:57 AM, Michael S. Tsirkin wrote:
>>> On Thu, Sep 09, 2021 at 07:45:42PM +0300, Max Gurtovoy wrote:
>>>> On 9/9/2021 7:31 PM, Michael S. Tsirkin wrote:
>>>>> On Thu, Sep 09, 2021 at 06:51:56PM +0300, Max Gurtovoy wrote:
>>>>>> On 9/9/2021 6:40 PM, Michael S. Tsirkin wrote:
>>>>>>> On Thu, Sep 09, 2021 at 06:37:37PM +0300, Max Gurtovoy wrote:
>>>>>>>> On 9/9/2021 4:42 PM, Michael S. Tsirkin wrote:
>>>>>>>>> On Mon, Sep 06, 2021 at 02:59:40PM +0300, Max Gurtovoy wrote:
>>>>>>>>>> On 9/6/2021 2:20 PM, Michael S. Tsirkin wrote:
>>>>>>>>>>> On Mon, Sep 06, 2021 at 01:31:32AM +0300, Max Gurtovoy wrote:
>>>>>>>>>>>> On 9/5/2021 7:02 PM, Michael S. Tsirkin wrote:
>>>>>>>>>>>>> On Thu, Sep 02, 2021 at 02:45:52PM +0100, Stefan Hajnoczi wrote:
>>>>>>>>>>>>>> On Tue, Aug 31, 2021 at 04:50:35PM +0300, Max Gurtovoy wrote:
>>>>>>>>>>>>>>> Sometimes a user would like to control the amount of IO queues to be
>>>>>>>>>>>>>>> created for a block device. For example, for limiting the memory
>>>>>>>>>>>>>>> footprint of virtio-blk devices.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>>>>>>>>>>>>>> ---
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> changes from v1:
>>>>>>>>>>>>>>>         - use param_set_uint_minmax (from Christoph)
>>>>>>>>>>>>>>>         - added "Should > 0" to module description
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Note: This commit apply on top of Jens's branch for-5.15/drivers
>>>>>>>>>>>>>>> ---
>>>>>>>>>>>>>>>         drivers/block/virtio_blk.c | 20 +++++++++++++++++++-
>>>>>>>>>>>>>>>         1 file changed, 19 insertions(+), 1 deletion(-)
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>>>>>>>>>>>>>>> index 4b49df2dfd23..9332fc4e9b31 100644
>>>>>>>>>>>>>>> --- a/drivers/block/virtio_blk.c
>>>>>>>>>>>>>>> +++ b/drivers/block/virtio_blk.c
>>>>>>>>>>>>>>> @@ -24,6 +24,22 @@
>>>>>>>>>>>>>>>         /* The maximum number of sg elements that fit into a virtqueue */
>>>>>>>>>>>>>>>         #define VIRTIO_BLK_MAX_SG_ELEMS 32768
>>>>>>>>>>>>>>> +static int virtblk_queue_count_set(const char *val,
>>>>>>>>>>>>>>> +		const struct kernel_param *kp)
>>>>>>>>>>>>>>> +{
>>>>>>>>>>>>>>> +	return param_set_uint_minmax(val, kp, 1, nr_cpu_ids);
>>>>>>>>>>>>>>> +}
>>>>>>>>>>> Hmm which tree is this for?
>>>>>>>>>> I've mentioned in the note that it apply on branch for-5.15/drivers. But now
>>>>>>>>>> you can apply it on linus/master as well.
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>> +static const struct kernel_param_ops queue_count_ops = {
>>>>>>>>>>>>>>> +	.set = virtblk_queue_count_set,
>>>>>>>>>>>>>>> +	.get = param_get_uint,
>>>>>>>>>>>>>>> +};
>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>> +static unsigned int num_io_queues;
>>>>>>>>>>>>>>> +module_param_cb(num_io_queues, &queue_count_ops, &num_io_queues, 0644);
>>>>>>>>>>>>>>> +MODULE_PARM_DESC(num_io_queues,
>>>>>>>>>>>>>>> +		 "Number of IO virt queues to use for blk device. Should > 0");
>>>>>>>>>>> better:
>>>>>>>>>>>
>>>>>>>>>>> +MODULE_PARM_DESC(num_io_request_queues,
>>>>>>>>>>> +                "Limit number of IO request virt queues to use for each device. 0 for now limit");
>>>>>>>>>> You proposed it and I replied on it bellow.
>>>>>>>>> Can't say I understand 100% what you are saying. Want to send
>>>>>>>>> a description that does make sense to you but
>>>>>>>>> also reflects reality? 0 is the default so
>>>>>>>>> "should > 0" besides being ungrammatical does not seem t"
>>>>>>>>> reflect what it does ...
>>>>>>>> if you "modprobe virtio_blk" the previous behavior will happen.
>>>>>>>>
>>>>>>>> You can't "modprobe virtio_blk num_io_request_queues=0" since the minimal
>>>>>>>> value is 1.
>>>>>>>>
>>>>>>>> So your description is not reflecting the code.
>>>>>>>>
>>>>>>>> We can do:
>>>>>>>>
>>>>>>>> MODULE_PARM_DESC(num_io_request_queues, "Number of request virt queues to use for blk device. Minimum value is 1 queue");
>>>>>>> What's the default value? We should document that.
>>>>>> default value for static global variables is 0.
>>>>>>
>>>>>> MODULE_PARM_DESC(num_io_request_queues, "Number of request virt queues to
>>>>>> use for blk device. Minimum value is 1 queue. Default and Maximum value is
>>>>>> equal to the total number of CPUs");
>>>>> So it says it's the # of cpus but yoiu inspect it with
>>>>> sysfs and it's actually 0. Let's say that's confusing
>>>>> at the least. why not just let users set it to 0
>>>>> and document that?
>>>>>
>>>> Setting it by the user to 0 makes no sense.
>>>>
>>>> We can say "if not set, the value equals to the total number of CPUs".
>>> the value is 0. it seems to mean "no limit". the actual # of queues is
>>> then te smaller between # of cpus and # of hardware queues.
>>> I see no reason not to allow user to set that especially if
>>> it was originally the value then user changed it
>>> and is trying to change it back.
>> I fine with that.
>>
>> MODULE_PARM_DESC(num_io_request_queues, "Number of request virt queues to use for blk device. 0 value means no limitation");
>>
> OK and the second distinction is that it's a limit on the
> number, not the actual number. It's never more than what's provided
> by the hypervisor.

MODULE_PARM_DESC(num_io_request_queues, "Maximal number of request virt queues to use for blk device. 0 value means no limitation");

is that ok ?

>>>> The actual value of the created queues can be seen in /sys/block/vda/mq/ as
>>>> done today.
>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>         static int major;
>>>>>>>>>>>>>>>         static DEFINE_IDA(vd_index_ida);
>>>>>>>>>>>>>>> @@ -501,7 +517,9 @@ static int init_vq(struct virtio_blk *vblk)
>>>>>>>>>>>>>>>         	if (err)
>>>>>>>>>>>>>>>         		num_vqs = 1;
>>>>>>>>>>>>>>> -	num_vqs = min_t(unsigned int, nr_cpu_ids, num_vqs);
>>>>>>>>>>>>>>> +	num_vqs = min_t(unsigned int,
>>>>>>>>>>>>>>> +			min_not_zero(num_io_queues, nr_cpu_ids),
>>>>>>>>>>>>>>> +			num_vqs);
>>>>>>>>>>>>>> If you respin, please consider calling them request queues. That's the
>>>>>>>>>>>>>> terminology from the VIRTIO spec and it's nice to keep it consistent.
>>>>>>>>>>>>>> But the purpose of num_io_queues is clear, so:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
>>>>>>>>>>>>> I did this:
>>>>>>>>>>>>> +static unsigned int num_io_request_queues;
>>>>>>>>>>>>> +module_param_cb(num_io_request_queues, &queue_count_ops, &num_io_request_queues, 0644);
>>>>>>>>>>>>> +MODULE_PARM_DESC(num_io_request_queues,
>>>>>>>>>>>>> +                "Limit number of IO request virt queues to use for each device. 0 for now limit");
>>>>>>>>>>>> The parameter is writable and can be changed and then new devices might be
>>>>>>>>>>>> probed with new value.
>>>>>>>>>>>>
>>>>>>>>>>>> It can't be zero in the code. we can change param_set_uint_minmax args and
>>>>>>>>>>>> say that 0 says nr_cpus.
>>>>>>>>>>>>
>>>>>>>>>>>> I'm ok with the renaming but I prefer to stick to the description we gave in
>>>>>>>>>>>> V3 of this patch (and maybe enable value of 0 as mentioned above).
