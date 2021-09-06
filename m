Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B79E401AD6
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 14:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241352AbhIFMAz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 08:00:55 -0400
Received: from mail-mw2nam12on2068.outbound.protection.outlook.com ([40.107.244.68]:8065
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239993AbhIFMAy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Sep 2021 08:00:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EOZYaJg+GS/a4al2paDpgOmWgwl3gMGmzpCstWWdqBmifbf0GR9be+zdHYWb9HP6UuXE+tUv9Ln1ne1qIuyxKIyS4Jkfn8j1tERWyDvG3hcdvpr3i9mnIkJ5Rpr8nkUNbiOGW8JJJP9mKR9MvCjBQoHvKML8D+N40wptbiBSkX0haN9uptwSAt6tAL7opUIay+7bh7AmW/qZPy2r5kaGXkVbkY8zQffIRdDiQP7P2/3svCRVrevHcPNuWrlJIuQhINNgoGByGg+mbOT+pUMnoH3Z+CkR4sjl3/A4NujDhLt18S1BsbHp4rNN4mU+S4/T251pxf7G6SAJXJlnR5Y9QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=6Md+c5I5CGlHGgPXOEzuEpVghQBokq552hSjC3YM4Is=;
 b=NKtXz2FUjAHc77tbo8QRpw6bBpC2/lw1sXdNMIlIQUq6PKtqifFOs833rdgAHwqOwBjaiayJk+oVbUFee+bmLTHI5rbUOtTFtQcwa9p6FMUNmjmuSxppzSWZ6CMwt82ZWCdfi5eapjDcuGuyPyKq8hivqNRp0xinEksLgBWbr+3eSbQ/OgOGBtk51RRb9i9UjfXVMTDwGyaRdlwiZuNwdvMUiVM1KZihg9tp4XcOjLgDsZunKwKhulMPytIAapdJpK/+2axAQ1WQADxOT6bIUWl/CYMNhETuJbMP3ohMLuI++UFK53Eu2NmnAjUiSwE9An4xwT0cOmq6cFYu09Lv+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=infradead.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Md+c5I5CGlHGgPXOEzuEpVghQBokq552hSjC3YM4Is=;
 b=VEI2V18s9AZhYP76eUVy5A59bHNrhd//JsGjraMQILwI6SRqXQ8QZt+99VBW8lbdstjTijMInYfJ36+N+ciEl8bF0t4dbtbLg0/lbJF5FbWUfYGOeinOtPsjGlQiq1tfVGH9hhMmnDHz4TG13qi2Z9SauL3Wd5yX5AX2G9etrg5MmM+J9ltHAh0iANSiDCPYa1BXYGCFbyDhF0Rp0+Ei7hUccmLvvJboYdvn1sjt36jvZU1roZD8Ux3iPLZvJr+YbQggVgBYOCjEaEvsot7gbqUZmmEdmmI2R95QJTrmJXcjf/yypQm6rWfSx8GPSJpyHEJ2oB72jv1BuKxD+BePzg==
Received: from DM6PR02CA0113.namprd02.prod.outlook.com (2603:10b6:5:1b4::15)
 by DM6PR12MB3404.namprd12.prod.outlook.com (2603:10b6:5:3a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22; Mon, 6 Sep
 2021 11:59:48 +0000
Received: from DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b4:cafe::54) by DM6PR02CA0113.outlook.office365.com
 (2603:10b6:5:1b4::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend
 Transport; Mon, 6 Sep 2021 11:59:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT025.mail.protection.outlook.com (10.13.172.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4478.19 via Frontend Transport; Mon, 6 Sep 2021 11:59:47 +0000
Received: from [172.27.1.210] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 6 Sep
 2021 11:59:44 +0000
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
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <1cbbe6e2-1473-8696-565c-518fc1016a1a@nvidia.com>
Date:   Mon, 6 Sep 2021 14:59:40 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210906071957-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d4c848f-d0d1-4a85-32a4-08d9712dd313
X-MS-TrafficTypeDiagnostic: DM6PR12MB3404:
X-Microsoft-Antispam-PRVS: <DM6PR12MB340430A23117B8FA746B46DCDED29@DM6PR12MB3404.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gmnv6e2qlywnwmtUBSU/Dl1a8aqi33wkBoIbm7FbX3QS1DrkLFRBGBs4V2NbXDbC8ZqgBCPh9hbm0HVHtfGcU9GfafvLx43Nl6qdnSdhvk+bYBglgb2+wlU0/xB9rTOzMT42AOjEFhHwnK1x5zMJ64uJbEYxsOx+Y1gaUT5uqx7XhRRXk5/gLDoE9xL+GrtZvtrznFeg1jez9+xTla/2ZDtNEVfx2FtD8EcXT5sLDJdda2AP8Pm2Ds2beLaoQfW+RMHz6Mx6l1UEju5qFq0d695Q84cOV6jzHlmDCv3P/hIuUo6YL5lq7xukyTFI3sftQw5q5NxPJDoqJZ47Ff+4cY/KSouEBpGAIWWP1xVJyr7K9W8IVL4e5o4BzacwWKL7T9yLUJ+mvTvBVLzPJt115mQ5DgfIFyD6lOvpsPwvMVVxg1KtAviV6ZVAizDMlf6vqxi6OuRUgcRj0X2Q5o8t0N20qgcgB5WAiqx4FORR5Xp/TIlh8R7lmaPaY6Lb80euiH41CT9o5SKYe5WYzyF6/00bzfNCHmfQGJTjqzi4mZfNsnV8Ks+Sb9zAuS5W+jjnUCIRKpCpw97gMe9wT31jk/DUS1tDOK4Irm1+ibjYGIMC9q/3KFyzZu0La7DE9vD6cCvXsItPN++WjwdcZBLcjlC6vg2AqlYbMdgjoCVmSFkpGqlXepi9XfU0qAPFT0n87FVazLTIhxwI9g6gSybJHMmCBMyEfhVb7BwMydARUSI=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(136003)(46966006)(36840700001)(36906005)(47076005)(316002)(86362001)(336012)(82740400003)(82310400003)(8676002)(36860700001)(36756003)(70586007)(186003)(5660300002)(16576012)(16526019)(31696002)(426003)(356005)(70206006)(31686004)(2906002)(83380400001)(26005)(4326008)(7636003)(8936002)(478600001)(6666004)(6916009)(2616005)(54906003)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2021 11:59:47.7314
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d4c848f-d0d1-4a85-32a4-08d9712dd313
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3404
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/6/2021 2:20 PM, Michael S. Tsirkin wrote:
> On Mon, Sep 06, 2021 at 01:31:32AM +0300, Max Gurtovoy wrote:
>> On 9/5/2021 7:02 PM, Michael S. Tsirkin wrote:
>>> On Thu, Sep 02, 2021 at 02:45:52PM +0100, Stefan Hajnoczi wrote:
>>>> On Tue, Aug 31, 2021 at 04:50:35PM +0300, Max Gurtovoy wrote:
>>>>> Sometimes a user would like to control the amount of IO queues to be
>>>>> created for a block device. For example, for limiting the memory
>>>>> footprint of virtio-blk devices.
>>>>>
>>>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>>>> ---
>>>>>
>>>>> changes from v1:
>>>>>    - use param_set_uint_minmax (from Christoph)
>>>>>    - added "Should > 0" to module description
>>>>>
>>>>> Note: This commit apply on top of Jens's branch for-5.15/drivers
>>>>> ---
>>>>>    drivers/block/virtio_blk.c | 20 +++++++++++++++++++-
>>>>>    1 file changed, 19 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>>>>> index 4b49df2dfd23..9332fc4e9b31 100644
>>>>> --- a/drivers/block/virtio_blk.c
>>>>> +++ b/drivers/block/virtio_blk.c
>>>>> @@ -24,6 +24,22 @@
>>>>>    /* The maximum number of sg elements that fit into a virtqueue */
>>>>>    #define VIRTIO_BLK_MAX_SG_ELEMS 32768
>>>>> +static int virtblk_queue_count_set(const char *val,
>>>>> +		const struct kernel_param *kp)
>>>>> +{
>>>>> +	return param_set_uint_minmax(val, kp, 1, nr_cpu_ids);
>>>>> +}
>
> Hmm which tree is this for?

I've mentioned in the note that it apply on branch for-5.15/drivers. But 
now you can apply it on linus/master as well.


>
>>>>> +
>>>>> +static const struct kernel_param_ops queue_count_ops = {
>>>>> +	.set = virtblk_queue_count_set,
>>>>> +	.get = param_get_uint,
>>>>> +};
>>>>> +
>>>>> +static unsigned int num_io_queues;
>>>>> +module_param_cb(num_io_queues, &queue_count_ops, &num_io_queues, 0644);
>>>>> +MODULE_PARM_DESC(num_io_queues,
>>>>> +		 "Number of IO virt queues to use for blk device. Should > 0");
>
>
> better:
>
> +MODULE_PARM_DESC(num_io_request_queues,
> +                "Limit number of IO request virt queues to use for each device. 0 for now limit");

You proposed it and I replied on it bellow.


>
>
>>>>> +
>>>>>    static int major;
>>>>>    static DEFINE_IDA(vd_index_ida);
>>>>> @@ -501,7 +517,9 @@ static int init_vq(struct virtio_blk *vblk)
>>>>>    	if (err)
>>>>>    		num_vqs = 1;
>>>>> -	num_vqs = min_t(unsigned int, nr_cpu_ids, num_vqs);
>>>>> +	num_vqs = min_t(unsigned int,
>>>>> +			min_not_zero(num_io_queues, nr_cpu_ids),
>>>>> +			num_vqs);
>>>> If you respin, please consider calling them request queues. That's the
>>>> terminology from the VIRTIO spec and it's nice to keep it consistent.
>>>> But the purpose of num_io_queues is clear, so:
>>>>
>>>> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
>>> I did this:
>>> +static unsigned int num_io_request_queues;
>>> +module_param_cb(num_io_request_queues, &queue_count_ops, &num_io_request_queues, 0644);
>>> +MODULE_PARM_DESC(num_io_request_queues,
>>> +                "Limit number of IO request virt queues to use for each device. 0 for now limit");
>> The parameter is writable and can be changed and then new devices might be
>> probed with new value.
>>
>> It can't be zero in the code. we can change param_set_uint_minmax args and
>> say that 0 says nr_cpus.
>>
>> I'm ok with the renaming but I prefer to stick to the description we gave in
>> V3 of this patch (and maybe enable value of 0 as mentioned above).
