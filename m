Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F494076A0
	for <lists+kvm@lfdr.de>; Sat, 11 Sep 2021 14:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235788AbhIKM6H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Sep 2021 08:58:07 -0400
Received: from mail-dm6nam08on2074.outbound.protection.outlook.com ([40.107.102.74]:38892
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230249AbhIKM6G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Sep 2021 08:58:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OTcFDNjVhQtUqJFGYNO8SzllJpHjFxzz+PuPRLzmYz9qkcP5ejHllJBFOT/6FHqn3ZLvlfhmMeNuYHQ+e+4FIH0UFxXUp6rOJHJgY6RTX2/dbqEIefTkyjR5nDzCfZ+J8Fx2ZVcNTa739tJt1rVRR5ir4yLY/A/vocJPZ8N4tMmieoJ6EVr1XpE8Av6/Xgo3yQ9fMLF3qUu0iul0ODksFnTqcWesEKAozSt/e86+nd3GeGQhdQNoJBIFhvLWV1bdFWUxPYHkB+/nMfqa3X1/AWYyH5ARZQQmAz5U3TZDyroPUDWyJYx4nB2Vog65zg9rSqMjWgwAQ0mx46EP1Xw2Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=97u9hwembo0GmVcymejpRtb/9J1Sq5DPaFJWvHZC80Y=;
 b=aBSY3Ed81U1z5D2glE6LTE9oM5ynJoCcL+OdBjMR/hpI+CmvP1JUN0fnRSDOS3kLmRayQKHR4+fvVUmJKzs6eh7k0Vn6d7ZXyRlvgfCO+6Zz+m9R8ixdQOeF7w/4/kfbP+kWCdT8uHLMcS4FzvIzWtXgfAno+VarxBQ6xwUtlXt7xOPZw+vKWEWLfkZmzStylko1QIS9W4+mLEyQMogvYJh4M1WrRBOn3zEzILnv+HeumCFcPF4u/e+FzLdgFGgnkly4xEAr4LOXrUr5NbEPwjxoplTJ8bR1O3mj22NqHLPLvvt+ukQhwxzXNZ3+E9x0K3ABuLnYgh3NaC7/z6FhkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=97u9hwembo0GmVcymejpRtb/9J1Sq5DPaFJWvHZC80Y=;
 b=RjOvSq2sLKAUYgHUbElK0p10MRVe3dFrp2BoZVE4CG9ZLdqhE0klD/AUVSlTVnxFH2/soF1RAQ73zb81JAy5COR2b7JE9iTts5ZhZtdsiKG7pZ7G4VXKNXNKmqo3kxodCvem71uY9OcdFGiUcCyeFOnOK/m0NbHYNcQlWs08DeDAeH5odpQhOu+LuUw+N392oKCc7ip1q2XfyeQgWbrN48XciQ1yBYkqn+lrQ/ZYaBEgtJ6aMGTxK2gLQol80fiPZpKjjtFLnAPTtMjmeBsOYfdJ9iT4m2VyQrOmst5cVnBJC0POf6h04LEk+WuHwmpXYmu00zLuBcRk7C8NjRQa7Q==
Received: from BN9PR03CA0478.namprd03.prod.outlook.com (2603:10b6:408:139::33)
 by MN2PR12MB3631.namprd12.prod.outlook.com (2603:10b6:208:c2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Sat, 11 Sep
 2021 12:56:51 +0000
Received: from BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:139:cafe::6a) by BN9PR03CA0478.outlook.office365.com
 (2603:10b6:408:139::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17 via Frontend
 Transport; Sat, 11 Sep 2021 12:56:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT009.mail.protection.outlook.com (10.13.176.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4500.14 via Frontend Transport; Sat, 11 Sep 2021 12:56:51 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sat, 11 Sep
 2021 12:56:51 +0000
Received: from [172.27.0.120] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sat, 11 Sep
 2021 12:56:47 +0000
Subject: Re: [PATCH v2 1/1] virtio-blk: add num_io_queues module parameter
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>, <hch@infradead.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <israelr@nvidia.com>, <nitzanc@nvidia.com>, <oren@nvidia.com>,
        <linux-block@vger.kernel.org>, <axboe@kernel.dk>
References: <20210905120234-mutt-send-email-mst@kernel.org>
 <98309fcd-3abe-1f27-fe52-e8fcc58bec13@nvidia.com>
 <20210906071957-mutt-send-email-mst@kernel.org>
 <1cbbe6e2-1473-8696-565c-518fc1016a1a@nvidia.com>
 <20210909094001-mutt-send-email-mst@kernel.org>
 <456e1704-67e9-aac9-a82a-44fed65dd153@nvidia.com>
 <20210909114029-mutt-send-email-mst@kernel.org>
 <da61fec0-e90f-0020-c836-c2e58d32be27@nvidia.com>
 <20210909123035-mutt-send-email-mst@kernel.org>
 <0cd4ab50-1bb2-3baf-fc00-b2045e8f8eb1@nvidia.com>
 <20210909185525-mutt-send-email-mst@kernel.org>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <9de9a43a-2d3a-493b-516e-4601778b9237@nvidia.com>
Date:   Sat, 11 Sep 2021 15:56:45 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210909185525-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cdcb6d30-4292-49a4-2817-08d975239fe2
X-MS-TrafficTypeDiagnostic: MN2PR12MB3631:
X-Microsoft-Antispam-PRVS: <MN2PR12MB36318242A3BE520564D2BE3FDED79@MN2PR12MB3631.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d5Z1ZiRIly+x+WFfRLr2dFVzVm0YBe/roDRseXaZjcsVWJb1ocdac2oMPRJeJpqarJWXHe4kJpGic7zGJctHBzbpmFMvhLyAj6VbNSFd/b/Wxo3+XtOeudQ259SCWI1Vn5t/gjbdgivJv951heA9lnak/iMbraywOBZQeMoZ1/mvOddpW1YfrBbljV9PBNQ6d5qKuPzLie1iiEaCBP6hi6/avoesV/gACdzCDUF4vRzgWYHYCtKD1/lGIh6dwrIYwA2Lq5zPhbTanPwy11uMCr1S3HFXvFcQSUA7QPvOiHlrt/hURuDhYGNzNSgAkZZlm7s4l+z2wnxFY6VEx2tKv+XpYEPx3L5lAWLGRz/AEBCBvp4PznaZkf6X8IAVXKk6HJx8NEbHJauqr8WXR7tCZf5dev059WGmEHG43V1Dtr5Ct2/ec6nxYANAtiSxgjZrUHKTf15VU82lpZMzTY8usxl7HWZ0gw6RDBkH8njYUJvvoKWpJXizWVBOLGCw3JbXb2IBAEzbgKqDGUbNLHwqn02HyW1fxyoElhTJocdBimZ6VLNl5F/PsEottEW9fs6RMsr5ZOthHH5/4FEGnb1K0tdMJLXlJFW1hvsO6vgwqvDmKtm3gPy8GJzCGGPcW6zHTwzTkcq5L51QuhnRxMRhVBpV+OsOSnBydHB3NuOAkIMrlSIWWP22AUWGdpB0g1IN4AxhbxqcN5MitvhRwJjcJ0JUe+GWrH96WkiKKv8grjI=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39860400002)(136003)(46966006)(36840700001)(2616005)(36756003)(356005)(36860700001)(31696002)(36906005)(186003)(31686004)(8676002)(426003)(82310400003)(7636003)(6916009)(70206006)(16526019)(4326008)(26005)(478600001)(70586007)(8936002)(53546011)(2906002)(82740400003)(54906003)(47076005)(83380400001)(5660300002)(16576012)(86362001)(336012)(316002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2021 12:56:51.4580
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cdcb6d30-4292-49a4-2817-08d975239fe2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3631
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/10/2021 1:57 AM, Michael S. Tsirkin wrote:
> On Thu, Sep 09, 2021 at 07:45:42PM +0300, Max Gurtovoy wrote:
>> On 9/9/2021 7:31 PM, Michael S. Tsirkin wrote:
>>> On Thu, Sep 09, 2021 at 06:51:56PM +0300, Max Gurtovoy wrote:
>>>> On 9/9/2021 6:40 PM, Michael S. Tsirkin wrote:
>>>>> On Thu, Sep 09, 2021 at 06:37:37PM +0300, Max Gurtovoy wrote:
>>>>>> On 9/9/2021 4:42 PM, Michael S. Tsirkin wrote:
>>>>>>> On Mon, Sep 06, 2021 at 02:59:40PM +0300, Max Gurtovoy wrote:
>>>>>>>> On 9/6/2021 2:20 PM, Michael S. Tsirkin wrote:
>>>>>>>>> On Mon, Sep 06, 2021 at 01:31:32AM +0300, Max Gurtovoy wrote:
>>>>>>>>>> On 9/5/2021 7:02 PM, Michael S. Tsirkin wrote:
>>>>>>>>>>> On Thu, Sep 02, 2021 at 02:45:52PM +0100, Stefan Hajnoczi wrote:
>>>>>>>>>>>> On Tue, Aug 31, 2021 at 04:50:35PM +0300, Max Gurtovoy wrote:
>>>>>>>>>>>>> Sometimes a user would like to control the amount of IO queues to be
>>>>>>>>>>>>> created for a block device. For example, for limiting the memory
>>>>>>>>>>>>> footprint of virtio-blk devices.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>>>>>>>>>>>> ---
>>>>>>>>>>>>>
>>>>>>>>>>>>> changes from v1:
>>>>>>>>>>>>>        - use param_set_uint_minmax (from Christoph)
>>>>>>>>>>>>>        - added "Should > 0" to module description
>>>>>>>>>>>>>
>>>>>>>>>>>>> Note: This commit apply on top of Jens's branch for-5.15/drivers
>>>>>>>>>>>>> ---
>>>>>>>>>>>>>        drivers/block/virtio_blk.c | 20 +++++++++++++++++++-
>>>>>>>>>>>>>        1 file changed, 19 insertions(+), 1 deletion(-)
>>>>>>>>>>>>>
>>>>>>>>>>>>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>>>>>>>>>>>>> index 4b49df2dfd23..9332fc4e9b31 100644
>>>>>>>>>>>>> --- a/drivers/block/virtio_blk.c
>>>>>>>>>>>>> +++ b/drivers/block/virtio_blk.c
>>>>>>>>>>>>> @@ -24,6 +24,22 @@
>>>>>>>>>>>>>        /* The maximum number of sg elements that fit into a virtqueue */
>>>>>>>>>>>>>        #define VIRTIO_BLK_MAX_SG_ELEMS 32768
>>>>>>>>>>>>> +static int virtblk_queue_count_set(const char *val,
>>>>>>>>>>>>> +		const struct kernel_param *kp)
>>>>>>>>>>>>> +{
>>>>>>>>>>>>> +	return param_set_uint_minmax(val, kp, 1, nr_cpu_ids);
>>>>>>>>>>>>> +}
>>>>>>>>> Hmm which tree is this for?
>>>>>>>> I've mentioned in the note that it apply on branch for-5.15/drivers. But now
>>>>>>>> you can apply it on linus/master as well.
>>>>>>>>
>>>>>>>>
>>>>>>>>>>>>> +
>>>>>>>>>>>>> +static const struct kernel_param_ops queue_count_ops = {
>>>>>>>>>>>>> +	.set = virtblk_queue_count_set,
>>>>>>>>>>>>> +	.get = param_get_uint,
>>>>>>>>>>>>> +};
>>>>>>>>>>>>> +
>>>>>>>>>>>>> +static unsigned int num_io_queues;
>>>>>>>>>>>>> +module_param_cb(num_io_queues, &queue_count_ops, &num_io_queues, 0644);
>>>>>>>>>>>>> +MODULE_PARM_DESC(num_io_queues,
>>>>>>>>>>>>> +		 "Number of IO virt queues to use for blk device. Should > 0");
>>>>>>>>> better:
>>>>>>>>>
>>>>>>>>> +MODULE_PARM_DESC(num_io_request_queues,
>>>>>>>>> +                "Limit number of IO request virt queues to use for each device. 0 for now limit");
>>>>>>>> You proposed it and I replied on it bellow.
>>>>>>> Can't say I understand 100% what you are saying. Want to send
>>>>>>> a description that does make sense to you but
>>>>>>> also reflects reality? 0 is the default so
>>>>>>> "should > 0" besides being ungrammatical does not seem t"
>>>>>>> reflect what it does ...
>>>>>> if you "modprobe virtio_blk" the previous behavior will happen.
>>>>>>
>>>>>> You can't "modprobe virtio_blk num_io_request_queues=0" since the minimal
>>>>>> value is 1.
>>>>>>
>>>>>> So your description is not reflecting the code.
>>>>>>
>>>>>> We can do:
>>>>>>
>>>>>> MODULE_PARM_DESC(num_io_request_queues, "Number of request virt queues to use for blk device. Minimum value is 1 queue");
>>>>> What's the default value? We should document that.
>>>> default value for static global variables is 0.
>>>>
>>>> MODULE_PARM_DESC(num_io_request_queues, "Number of request virt queues to
>>>> use for blk device. Minimum value is 1 queue. Default and Maximum value is
>>>> equal to the total number of CPUs");
>>> So it says it's the # of cpus but yoiu inspect it with
>>> sysfs and it's actually 0. Let's say that's confusing
>>> at the least. why not just let users set it to 0
>>> and document that?
>>>
>> Setting it by the user to 0 makes no sense.
>>
>> We can say "if not set, the value equals to the total number of CPUs".
> the value is 0. it seems to mean "no limit". the actual # of queues is
> then te smaller between # of cpus and # of hardware queues.
> I see no reason not to allow user to set that especially if
> it was originally the value then user changed it
> and is trying to change it back.

I fine with that.

MODULE_PARM_DESC(num_io_request_queues, "Number of request virt queues to use for blk device. 0 value means no limitation");


>
>> The actual value of the created queues can be seen in /sys/block/vda/mq/ as
>> done today.
>>>>>>>>>>>>> +
>>>>>>>>>>>>>        static int major;
>>>>>>>>>>>>>        static DEFINE_IDA(vd_index_ida);
>>>>>>>>>>>>> @@ -501,7 +517,9 @@ static int init_vq(struct virtio_blk *vblk)
>>>>>>>>>>>>>        	if (err)
>>>>>>>>>>>>>        		num_vqs = 1;
>>>>>>>>>>>>> -	num_vqs = min_t(unsigned int, nr_cpu_ids, num_vqs);
>>>>>>>>>>>>> +	num_vqs = min_t(unsigned int,
>>>>>>>>>>>>> +			min_not_zero(num_io_queues, nr_cpu_ids),
>>>>>>>>>>>>> +			num_vqs);
>>>>>>>>>>>> If you respin, please consider calling them request queues. That's the
>>>>>>>>>>>> terminology from the VIRTIO spec and it's nice to keep it consistent.
>>>>>>>>>>>> But the purpose of num_io_queues is clear, so:
>>>>>>>>>>>>
>>>>>>>>>>>> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
>>>>>>>>>>> I did this:
>>>>>>>>>>> +static unsigned int num_io_request_queues;
>>>>>>>>>>> +module_param_cb(num_io_request_queues, &queue_count_ops, &num_io_request_queues, 0644);
>>>>>>>>>>> +MODULE_PARM_DESC(num_io_request_queues,
>>>>>>>>>>> +                "Limit number of IO request virt queues to use for each device. 0 for now limit");
>>>>>>>>>> The parameter is writable and can be changed and then new devices might be
>>>>>>>>>> probed with new value.
>>>>>>>>>>
>>>>>>>>>> It can't be zero in the code. we can change param_set_uint_minmax args and
>>>>>>>>>> say that 0 says nr_cpus.
>>>>>>>>>>
>>>>>>>>>> I'm ok with the renaming but I prefer to stick to the description we gave in
>>>>>>>>>> V3 of this patch (and maybe enable value of 0 as mentioned above).
