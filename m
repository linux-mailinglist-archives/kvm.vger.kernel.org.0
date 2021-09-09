Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697B2405B2A
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 18:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236993AbhIIQrB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 12:47:01 -0400
Received: from mail-mw2nam10on2060.outbound.protection.outlook.com ([40.107.94.60]:43239
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230144AbhIIQrA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 12:47:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dOpi0yg47Kdkl4nwifZjO9hbYpCa81nSu0EUTSOHSZaOA9Y81HI7eIwzTtqm7gbiysqUHy9V8u3aAs9gDPqjZ/Cf4mUDOXueJn37CJqcyvuHFwM+CNLBDuDNmC/BDUqThXq1HR4lsIl8G0Z8rJGdqdTS2m210nOnSrOc1Ev2w30iwi2jL/Roa0165UOr7OHghEb+0r+7McVO1Zf7kn+y1YzNK5gKNWlSWXRdmrkV48Jiwz2XhPqN0j2warO7LmGV2G1d/O+KOAxttAE1SayU0f1s6mNBjwJshFT6QLJ/s4HuNT3p6bsRwRCRDCehDRBdlhS7QgOMUH6QuPV7HhIJ4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=CZYcnr9HpasWTyXveWl8JoX56+QUYAnSwbyHossFOJo=;
 b=IMAKl1aR66NYQXD4OfETPu+X4MFGqD+n7gA78bow8vQQlAQ274hODCNkGC0of3v7UfhJw1oMgkWGideUL1Tp6/4KIA3AncZJkS+ozhI5tVLclLYkqjZYrHrN2uleRrwAEvTjstTrZXRQSBimNoPSz3MCcbkbHda9zkqSIxrnvRiqTUnW/PcP0vfs/5rMG/NDKolp8L2IpKnnPHzompjZuNwDv0QZAzaVt5HmorxOUgPgl5zob/aMzyA+Pi1v3jTFuAhrUL1vceVE1bPrBRa/kxQlJt9MiuG873yJ3MeApXHii7S38VBzmgY7m2aVZD+r1I/FtUJAqqh8uHzUKWQLNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CZYcnr9HpasWTyXveWl8JoX56+QUYAnSwbyHossFOJo=;
 b=CHr7OK5yGnkVbzAJmHUy7sFfJ6oQlcyKHc3KMtIZQTl+kcSWYeVgcExHAxo9IeP3vtgGU1nOL22jmJFEXk+drTfIfuLKQ14M9iSwTiyHWyqDrPrgFuW8x7y4maf7kAv0wqFN7CE3O0wGgWxsUcSVJRiwl7BEB40PFVYV+wueK9pKz4eUzrJSHm96UzgsaL8OEok8nUZdA//YGh3neb+LweyhsTzcO/VIBGlxfPeHNqh0F9HtqLe/oy8DafwwbrTOYrmmEXGVA8ewndxVWG4VT6F+qoDefCfpCfVU28q1cv6/2g/LkXe6pMDwUFOEkLbsgMBqGQSzup4UfFLF8PJLGw==
Received: from MW4PR03CA0187.namprd03.prod.outlook.com (2603:10b6:303:b8::12)
 by DM6PR12MB3817.namprd12.prod.outlook.com (2603:10b6:5:1c9::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.21; Thu, 9 Sep
 2021 16:45:49 +0000
Received: from CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b8:cafe::f7) by MW4PR03CA0187.outlook.office365.com
 (2603:10b6:303:b8::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend
 Transport; Thu, 9 Sep 2021 16:45:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT009.mail.protection.outlook.com (10.13.175.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4500.14 via Frontend Transport; Thu, 9 Sep 2021 16:45:48 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 9 Sep
 2021 16:45:48 +0000
Received: from [172.27.14.161] (172.20.187.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 9 Sep
 2021 16:45:45 +0000
Subject: Re: [PATCH v2 1/1] virtio-blk: add num_io_queues module parameter
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>, <hch@infradead.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <israelr@nvidia.com>, <nitzanc@nvidia.com>, <oren@nvidia.com>,
        <linux-block@vger.kernel.org>, <axboe@kernel.dk>
References: <20210831135035.6443-1-mgurtovoy@nvidia.com>
 <YTDVkDIr5WLdlRsK@stefanha-x1.localdomain>
 <20210905120234-mutt-send-email-mst@kernel.org>
 <98309fcd-3abe-1f27-fe52-e8fcc58bec13@nvidia.com>
 <20210906071957-mutt-send-email-mst@kernel.org>
 <1cbbe6e2-1473-8696-565c-518fc1016a1a@nvidia.com>
 <20210909094001-mutt-send-email-mst@kernel.org>
 <456e1704-67e9-aac9-a82a-44fed65dd153@nvidia.com>
 <20210909114029-mutt-send-email-mst@kernel.org>
 <da61fec0-e90f-0020-c836-c2e58d32be27@nvidia.com>
 <20210909123035-mutt-send-email-mst@kernel.org>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <0cd4ab50-1bb2-3baf-fc00-b2045e8f8eb1@nvidia.com>
Date:   Thu, 9 Sep 2021 19:45:42 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210909123035-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f16f511-f4f9-4aff-e931-08d973b1472c
X-MS-TrafficTypeDiagnostic: DM6PR12MB3817:
X-Microsoft-Antispam-PRVS: <DM6PR12MB38178801825153C710BE874ADED59@DM6PR12MB3817.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gjtTd85GRIP40HGrOBmpDpLMQYbSTXTU/AZuyW2FhTatbLqtsKjfDa6pS8eEax573mQwANzxn7BzoC28p4M+2Y4JtXcnGYKUlOxFuzej031dDdoYEteYbZvN8/owV1l/0woNqcPUDXvcuucXV7pghdjYb2Z8FAnoWHQ730+6O6Jz1gnzKZlc8TWwTd5SRwP53Nxayr8rWjeKZZOhkxH9iIJFXpBOfTI75cCUtUe7qM8177ObTrxEwGD/AUF2f4bLdafcJ3Uzrudf0JV1Ss63n+HJuixUohchccnMjlALNAaVB5J6LubEKrfZYOnY00R2mh0Z6nyMpd5FbOg0mwxmYjpGJcAgKlXnvnn3K7yW5NEEkfn6Vfl6za67nH2Bx2j915AVrazsepIJmIfdL8kBTgxNgro48oQmEOuXYYAVV6Eb4jOKuzhCgdRNWQAWm9hTUfJDDnSJ0NnS/ngiihhTe7lvp6vkqLg4VwuCH/Q74OATiijHkRpTOmGoThhgfkEsGK3ii2jDoaZ/2brF7a0JbHoMGoGwRrOu3zZ9dSH8O5pifC2FPOctSKMwari/8IK3nnUzIsax/tL/fP3ppGDfz2pCw3nLEL5rTwE57F+eVpF59UwCmHHfmNDPiUhjahSko3P8AI0TpXc2+NrcAHfnApo61wHY+vm5Xpw7MBWpARrHBL1uQkmSf7hJWGrIQWOW4UxWCUX2Ru2ssVGFvc8ukvws3Mim4O+Cfv407Q4PNSU=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(396003)(39860400002)(36840700001)(46966006)(16576012)(316002)(36860700001)(47076005)(2906002)(82740400003)(83380400001)(26005)(31686004)(6916009)(31696002)(426003)(186003)(70586007)(336012)(70206006)(8676002)(6666004)(54906003)(36756003)(478600001)(82310400003)(8936002)(2616005)(7636003)(356005)(4326008)(36906005)(16526019)(5660300002)(86362001)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2021 16:45:48.9087
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f16f511-f4f9-4aff-e931-08d973b1472c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3817
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/9/2021 7:31 PM, Michael S. Tsirkin wrote:
> On Thu, Sep 09, 2021 at 06:51:56PM +0300, Max Gurtovoy wrote:
>> On 9/9/2021 6:40 PM, Michael S. Tsirkin wrote:
>>> On Thu, Sep 09, 2021 at 06:37:37PM +0300, Max Gurtovoy wrote:
>>>> On 9/9/2021 4:42 PM, Michael S. Tsirkin wrote:
>>>>> On Mon, Sep 06, 2021 at 02:59:40PM +0300, Max Gurtovoy wrote:
>>>>>> On 9/6/2021 2:20 PM, Michael S. Tsirkin wrote:
>>>>>>> On Mon, Sep 06, 2021 at 01:31:32AM +0300, Max Gurtovoy wrote:
>>>>>>>> On 9/5/2021 7:02 PM, Michael S. Tsirkin wrote:
>>>>>>>>> On Thu, Sep 02, 2021 at 02:45:52PM +0100, Stefan Hajnoczi wrote:
>>>>>>>>>> On Tue, Aug 31, 2021 at 04:50:35PM +0300, Max Gurtovoy wrote:
>>>>>>>>>>> Sometimes a user would like to control the amount of IO queues to be
>>>>>>>>>>> created for a block device. For example, for limiting the memory
>>>>>>>>>>> footprint of virtio-blk devices.
>>>>>>>>>>>
>>>>>>>>>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>>>>>>>>>> ---
>>>>>>>>>>>
>>>>>>>>>>> changes from v1:
>>>>>>>>>>>       - use param_set_uint_minmax (from Christoph)
>>>>>>>>>>>       - added "Should > 0" to module description
>>>>>>>>>>>
>>>>>>>>>>> Note: This commit apply on top of Jens's branch for-5.15/drivers
>>>>>>>>>>> ---
>>>>>>>>>>>       drivers/block/virtio_blk.c | 20 +++++++++++++++++++-
>>>>>>>>>>>       1 file changed, 19 insertions(+), 1 deletion(-)
>>>>>>>>>>>
>>>>>>>>>>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>>>>>>>>>>> index 4b49df2dfd23..9332fc4e9b31 100644
>>>>>>>>>>> --- a/drivers/block/virtio_blk.c
>>>>>>>>>>> +++ b/drivers/block/virtio_blk.c
>>>>>>>>>>> @@ -24,6 +24,22 @@
>>>>>>>>>>>       /* The maximum number of sg elements that fit into a virtqueue */
>>>>>>>>>>>       #define VIRTIO_BLK_MAX_SG_ELEMS 32768
>>>>>>>>>>> +static int virtblk_queue_count_set(const char *val,
>>>>>>>>>>> +		const struct kernel_param *kp)
>>>>>>>>>>> +{
>>>>>>>>>>> +	return param_set_uint_minmax(val, kp, 1, nr_cpu_ids);
>>>>>>>>>>> +}
>>>>>>> Hmm which tree is this for?
>>>>>> I've mentioned in the note that it apply on branch for-5.15/drivers. But now
>>>>>> you can apply it on linus/master as well.
>>>>>>
>>>>>>
>>>>>>>>>>> +
>>>>>>>>>>> +static const struct kernel_param_ops queue_count_ops = {
>>>>>>>>>>> +	.set = virtblk_queue_count_set,
>>>>>>>>>>> +	.get = param_get_uint,
>>>>>>>>>>> +};
>>>>>>>>>>> +
>>>>>>>>>>> +static unsigned int num_io_queues;
>>>>>>>>>>> +module_param_cb(num_io_queues, &queue_count_ops, &num_io_queues, 0644);
>>>>>>>>>>> +MODULE_PARM_DESC(num_io_queues,
>>>>>>>>>>> +		 "Number of IO virt queues to use for blk device. Should > 0");
>>>>>>> better:
>>>>>>>
>>>>>>> +MODULE_PARM_DESC(num_io_request_queues,
>>>>>>> +                "Limit number of IO request virt queues to use for each device. 0 for now limit");
>>>>>> You proposed it and I replied on it bellow.
>>>>> Can't say I understand 100% what you are saying. Want to send
>>>>> a description that does make sense to you but
>>>>> also reflects reality? 0 is the default so
>>>>> "should > 0" besides being ungrammatical does not seem t"
>>>>> reflect what it does ...
>>>> if you "modprobe virtio_blk" the previous behavior will happen.
>>>>
>>>> You can't "modprobe virtio_blk num_io_request_queues=0" since the minimal
>>>> value is 1.
>>>>
>>>> So your description is not reflecting the code.
>>>>
>>>> We can do:
>>>>
>>>> MODULE_PARM_DESC(num_io_request_queues, "Number of request virt queues to use for blk device. Minimum value is 1 queue");
>>> What's the default value? We should document that.
>> default value for static global variables is 0.
>>
>> MODULE_PARM_DESC(num_io_request_queues, "Number of request virt queues to
>> use for blk device. Minimum value is 1 queue. Default and Maximum value is
>> equal to the total number of CPUs");
> So it says it's the # of cpus but yoiu inspect it with
> sysfs and it's actually 0. Let's say that's confusing
> at the least. why not just let users set it to 0
> and document that?
>
Setting it by the user to 0 makes no sense.

We can say "if not set, the value equals to the total number of CPUs".

The actual value of the created queues can be seen in /sys/block/vda/mq/ 
as done today.

>>>>>>>>>>> +
>>>>>>>>>>>       static int major;
>>>>>>>>>>>       static DEFINE_IDA(vd_index_ida);
>>>>>>>>>>> @@ -501,7 +517,9 @@ static int init_vq(struct virtio_blk *vblk)
>>>>>>>>>>>       	if (err)
>>>>>>>>>>>       		num_vqs = 1;
>>>>>>>>>>> -	num_vqs = min_t(unsigned int, nr_cpu_ids, num_vqs);
>>>>>>>>>>> +	num_vqs = min_t(unsigned int,
>>>>>>>>>>> +			min_not_zero(num_io_queues, nr_cpu_ids),
>>>>>>>>>>> +			num_vqs);
>>>>>>>>>> If you respin, please consider calling them request queues. That's the
>>>>>>>>>> terminology from the VIRTIO spec and it's nice to keep it consistent.
>>>>>>>>>> But the purpose of num_io_queues is clear, so:
>>>>>>>>>>
>>>>>>>>>> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
>>>>>>>>> I did this:
>>>>>>>>> +static unsigned int num_io_request_queues;
>>>>>>>>> +module_param_cb(num_io_request_queues, &queue_count_ops, &num_io_request_queues, 0644);
>>>>>>>>> +MODULE_PARM_DESC(num_io_request_queues,
>>>>>>>>> +                "Limit number of IO request virt queues to use for each device. 0 for now limit");
>>>>>>>> The parameter is writable and can be changed and then new devices might be
>>>>>>>> probed with new value.
>>>>>>>>
>>>>>>>> It can't be zero in the code. we can change param_set_uint_minmax args and
>>>>>>>> say that 0 says nr_cpus.
>>>>>>>>
>>>>>>>> I'm ok with the renaming but I prefer to stick to the description we gave in
>>>>>>>> V3 of this patch (and maybe enable value of 0 as mentioned above).
