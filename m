Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A92741C1F6
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 11:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245182AbhI2JuC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 05:50:02 -0400
Received: from mail-dm3nam07on2064.outbound.protection.outlook.com ([40.107.95.64]:40705
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245148AbhI2JuB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 05:50:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j3tclpMfj7gA2fy5YL6mQ/huq0ddSaDTfudRuVhEOxAnTIEHRH7p64jNTFoa/Nv34ZNhe+sXjck1sQ5XQ9BhDEfbBQFn378l4kpMUG762cmt7q5J08zfhcxi6al3iVnHDuMmjoI+Xta9jCUPKEnzh0KVfjVufDUdlwZsbx7imxmZ3yH8PnQzyB5jYFMohPtEnG6y5x3fjUr6pj9F2SC8S/U8Et4HDAfw4Oeu6PyCTKXkGkTOAWZUuG6kaqyJvAPAlbFI37rEqsr+e1MrLuFoSanLDJM3IybPxtBmv01CRc6RwU41rGRUir0geYICXuX2wqCmfLSRPW3XGl87eAHEbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=2X3AOQAouOSR67Jg1qAMd9NT0x+jLn9eWYHInKF4MXk=;
 b=fvJFga/jMydAtQWS2eSDjS1pO7+mtUUz9VGllwxSYL3L5ek/MZelKzoe85scUyxhmLgjr/fZGkX+6eedOajGvmsZHNUaI75/1C61TNTfFBzFd9rIWD3M1IoLW9sRJ8U4D33JLf8+C2rEWcW/y64F7sR06NlzDQzPrSinQ5B32GTIv4gW9X9EcThS6ygJVI4Tz4SwpeVxlQ/OwXF8GfjTC0Gf+uC0wDzk4+G4A2Y3jIEzV5gKsHAj/JOb2/NZTfHGGYDJI2UPbc0VWCwvCMZlGYj9ZNdGdf/GmYotc6bTc6FegeQxoC/zPieRPdBj0Zsr817mI0D0tMR9t+ejfWdolg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=kernel.dk smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2X3AOQAouOSR67Jg1qAMd9NT0x+jLn9eWYHInKF4MXk=;
 b=L6CZy8kv8zWLspREqbjRNkgOlKxGEr1lR6kKuaO8yTAHuIYAqpFoWL59V1tkuw7l1D4he6FTOCeojApoLXBh4f2M6ophAjLZKvXmu3/Vh5L76ReugKXwh7z+xAkUkG8BYLN+sxhcdL0TnUNFrBwfpZYmc4dwK5knDGq9nyZY0GYSPwc6S5biA1lM9XqoEl2bzhkhtvJuQOMIgLSJFV2W//GC6egJVjG0tIkARzF5VRSjz6Ai9hDDlTTaMcxxeNG6tlzDcQ2ipMbb8C5zCWCmTN1jSsazV+4LdJSP8S5nqENQ9c4BkK9Ai7P7X2T1+zZHUUKSyWOE/pIE7xCFDdDUmA==
Received: from MW4PR04CA0009.namprd04.prod.outlook.com (2603:10b6:303:69::14)
 by BN8PR12MB3348.namprd12.prod.outlook.com (2603:10b6:408:47::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Wed, 29 Sep
 2021 09:48:18 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:69:cafe::8a) by MW4PR04CA0009.outlook.office365.com
 (2603:10b6:303:69::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend
 Transport; Wed, 29 Sep 2021 09:48:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 09:48:17 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 29 Sep
 2021 09:48:16 +0000
Received: from [172.27.14.186] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 29 Sep
 2021 09:48:12 +0000
Subject: Re: [PATCH 2/2] virtio-blk: set NUMA affinity for a tagset
To:     Leon Romanovsky <leon@kernel.org>
CC:     <mst@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <kvm@vger.kernel.org>, <stefanha@redhat.com>, <oren@nvidia.com>,
        <nitzanc@nvidia.com>, <israelr@nvidia.com>, <hch@infradead.org>,
        <linux-block@vger.kernel.org>, <axboe@kernel.dk>,
        Yaron Gepstein <yarong@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <20210926145518.64164-1-mgurtovoy@nvidia.com>
 <20210926145518.64164-2-mgurtovoy@nvidia.com> <YVGsMsIjD2+aS3eC@unreal>
 <0c155679-e1db-3d1e-2b4e-a0f12ce5950c@nvidia.com> <YVIMIFxjRcfDDub4@unreal>
 <f8de7c19-9f04-a458-6c1d-8133a83aa93f@nvidia.com> <YVNCflMxWh4m7ewU@unreal>
 <f0cc8cb4-92dc-f5f9-ea50-aa312ac6a056@nvidia.com> <YVQMp4aIBJNi9qrH@unreal>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <e1e28ed4-1bc5-1561-f1b3-a54de99f54b3@nvidia.com>
Date:   Wed, 29 Sep 2021 12:48:10 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YVQMp4aIBJNi9qrH@unreal>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f32e86a2-8585-473e-66a4-08d9832e43cb
X-MS-TrafficTypeDiagnostic: BN8PR12MB3348:
X-Microsoft-Antispam-PRVS: <BN8PR12MB3348DA2BD98FD0B49A686C03DEA99@BN8PR12MB3348.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j5eY1y6ikqMHyuvU5rMs5URxG/rNuzIDu3dseQFap1jVdxPl6VOCps16CQ04kRZWesdSHJFSWhjglyDCTePUQVicdo4w9opxAc6RKPm2c20i1Z/3e5E+ggFV5pKPjTudIlhK+A8BgEGYaLLBD55C/sUEecaKMS33cJFS9aeaB5vL4yTc9Hzis3DcOhmMgaQagszR0k8ZSuSvZ5FPahJ2pFlAqpCSQMO4ST5JtgpZWiOTxU8pOXsfP01BuWNPi5SNf6AtN/pILEY4xVEXcrJgWacMhLXmlWR5os0JK/Ny+2Wi+MR7OtYlyWPTt407nsYQWbJkPe6fBKrXcQPygxw47+DDyEB6rQCOk9bporupYszuxiQJAnKqTlYUV6mVEhomcPU0RVQWr0FNe3k9FFwyKQ80u8N8y0V8e7eTdNGBxzK8UOrQlyY3ISnaN9pSCqKevEjHT83k6HKd0atGZUT+RFs93MHy3dV54Qcqx6jeshm9Z+YUO59GnD9/BH8na/LiQ9OUe+s/8J1ISwkQ0kvXGpcuMDIvBVvejGwBo1zjKEutdL3pfaMTNG030lnHrw/J3J71wSTjgbI7z583R7+CuVINWwq0LskGrzm5tDxhTTUWH9BpQBFDA+wa4I46Ggrvmthu3Pf9SV/5+cF9OBRI0BoimRoU79WwG2jmni1KX9fOumSKSrlRmYkvobcShsqUqrVDWmACSYkUZCsAbYeXoAjZdrWZKexUQHAwnbWaNsGshRHMvz6j1OoxElvmuPS8BDkBxarHF5yRBDGkhSPnWpynJylaU7h9aFa4ImKcb3loKnlizhiaSqDjDheq7tQL
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(82310400003)(53546011)(8936002)(7636003)(2616005)(8676002)(356005)(31696002)(26005)(83380400001)(70206006)(70586007)(336012)(426003)(36860700001)(36756003)(316002)(4326008)(107886003)(508600001)(6916009)(54906003)(966005)(5660300002)(16576012)(86362001)(47076005)(186003)(16526019)(2906002)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 09:48:17.7630
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f32e86a2-8585-473e-66a4-08d9832e43cb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3348
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/29/2021 9:50 AM, Leon Romanovsky wrote:
> On Wed, Sep 29, 2021 at 02:28:08AM +0300, Max Gurtovoy wrote:
>> On 9/28/2021 7:27 PM, Leon Romanovsky wrote:
>>> On Tue, Sep 28, 2021 at 06:59:15PM +0300, Max Gurtovoy wrote:
>>>> On 9/27/2021 9:23 PM, Leon Romanovsky wrote:
>>>>> On Mon, Sep 27, 2021 at 08:25:09PM +0300, Max Gurtovoy wrote:
>>>>>> On 9/27/2021 2:34 PM, Leon Romanovsky wrote:
>>>>>>> On Sun, Sep 26, 2021 at 05:55:18PM +0300, Max Gurtovoy wrote:
>>>>>>>> To optimize performance, set the affinity of the block device tagset
>>>>>>>> according to the virtio device affinity.
>>>>>>>>
>>>>>>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>>>>>>> ---
>>>>>>>>      drivers/block/virtio_blk.c | 2 +-
>>>>>>>>      1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>>>
>>>>>>>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>>>>>>>> index 9b3bd083b411..1c68c3e0ebf9 100644
>>>>>>>> --- a/drivers/block/virtio_blk.c
>>>>>>>> +++ b/drivers/block/virtio_blk.c
>>>>>>>> @@ -774,7 +774,7 @@ static int virtblk_probe(struct virtio_device *vdev)
>>>>>>>>      	memset(&vblk->tag_set, 0, sizeof(vblk->tag_set));
>>>>>>>>      	vblk->tag_set.ops = &virtio_mq_ops;
>>>>>>>>      	vblk->tag_set.queue_depth = queue_depth;
>>>>>>>> -	vblk->tag_set.numa_node = NUMA_NO_NODE;
>>>>>>>> +	vblk->tag_set.numa_node = virtio_dev_to_node(vdev);
>>>>>>> I afraid that by doing it, you will increase chances to see OOM, because
>>>>>>> in NUMA_NO_NODE, MM will try allocate memory in whole system, while in
>>>>>>> the latter mode only on specific NUMA which can be depleted.
>>>>>> This is a common methodology we use in the block layer and in NVMe subsystem
>>>>>> and we don't afraid of the OOM issue you raised.
>>>>> There are many reasons for that, but we are talking about virtio here
>>>>> and not about NVMe.
>>>> Ok. what reasons ?
>>> For example, NVMe are physical devices that rely on DMA operations,
>>> PCI connectivity e.t.c to operate. Such systems indeed can benefit from
>>> NUMA locality hints. At the end, these devices are physically connected
>>> to that NUMA node.
>> FYI Virtio devices are also physical devices that have PCI interface and
>> rely on DMA operations.
>>
>> from virtio spec: "Virtio devices use normal bus mechanisms of interrupts
>> and DMA which should be familiar
>> to any device driver author".
> Yes, this is how bus in Linux is implemented, there is nothing new here.

So why you said that virtio is not a PCI device with DMA capabilities ?

>
>> Also we develop virtio HW at NVIDIA for blk and net devices with our SNAP
>> technology.
>>
>> These devices are connected via PCI bus to the host.
> How all these related to general virtio-blk implementation?

They use the same driver.

We develop HW virtio devices for bare metal cloud and also for 
virtualized cloud that use the SRIOV feature of the PF (real PF).

>
>> We also support SRIOV.
>>
>> Same it true also for paravirt devices that are emulated by QEMU but still
>> the guest sees them as PCI devices.
> Yes, the key word here - "emulated".

It doesn't matter. The guest kernel doesn't know if it's a paravirt 
device or real NVIDIA HW virtio SNAP device.

And FYI, a guest can also have 2 NUMA nodes and can benefit from this patch.

>
>>> In our case, virtio-blk is a software interface that doesn't have all
>>> these limitations. On the contrary, the virtio-blk can be created on one
>>> CPU and moved later to be close to the QEMU which can run on another NUMA
>>> node.
>> Not at all. virtio is HW interface.
> Virtio are para-virtualized devices that are represented as HW interfaces
> in the guest OS. They are not needed to be real devices in the hypervisor,
> which is my (and probably most of the world) use case.

Again, the kernel doesn't care or know if its a paravirt device or not. 
And it shouldn't care.

This patch is for kernel driver and not QEMU.

>
> My QEMU command line contains something like that: "-drive file=IMAGE.img,if=virtio"

This is one option.

For NVIDIA HW device, you pass a virtio device exactly how you pass a 
mlx5 device - using vfio + vfio_pci.


>
>> I don't understand what are you saying here ?
>>
>>> Also this patch increases chances to get OOM by factor of NUMA nodes.
>> This is common practice in Linux for storage drivers. Why does it bothers
>> you at all ?
> Do I need a reason to ask for a clarification for publicly posted patch
> in open mailing list?
>
> I use virtio and care about it.

I meant, why don't you want to change the entire block layer and NVMe 
subsystem ?

Why only this patch bothers you ?

>
>> I already decreased the memory footprint for virtio blk devices.
> As I wrote before, you decreased by several KB, but by this patch you
> limited available memory in magnitudes.
>
>>
>>> Before your patch, the virtio_blk can allocate from X memory, after your
>>> patch it will be X/NUMB_NUMA_NODES.
>> So go ahead and change all the block layer if it bothers you so much.
>>
>> Also please change the NVMe subsystem when you do it.
> I suggest less radical approach - don't take patches without proven
> benefit.
>
> We are in 2021, let's rely on NUMA node policy.

I'm trying to add NUMA policy here. Exactly.


>
>> And lets see what the community will say.
> Stephen asked you for performance data too. I'm not alone here.


I said I'll have a V2.

I also would like to hear the opinion of the block maintainers like Jens 
and Christoph regarding numa affinity for block drivers.

>>> In addition, it has all chances to even hurt performance.
>>>
>>> So yes, post v2, but as Stefan and I asked, please provide supportive
>>> performance results, because what was done for another subsystem doesn't
>>> mean that it will be applicable here.
>> I will measure the perf but even if we wont see an improvement since it
>> might not be the bottleneck, this changes should be merged since this is the
>> way the block layer is optimized.
> This is not acceptance criteria to merge patches.
>
>> This is a micro optimization that commonly used also in other subsystem. And
>> non of your above reasons (PCI, SW device, DMA) is true.
> Every subsystem is different, in some it makes sense, in others it doesn't.

But you were wrong saying that virtio device is not PCI HW device that 
uses DMA.

Do you understand the solution now ?

>
> We (RDMA) had very long discussion (together with perf data) and heavily tailored
> test to measure influence of per-node allocations and guess what? We didn't see
> any performance advantage.
>
> https://lore.kernel.org/linux-rdma/c34a864803f9bbd33d3f856a6ba2dd595ab708a7.1620729033.git.leonro@nvidia.com/

So go ahead and change all the kernel or the block layer.

As you said, for RDMA subsystem it might not be a good idea. I don't 
want to discuss RDMA considerations in this thread.

Lets talk storage and virtio.

>
>> Virtio blk device is in 99% a PCI device (paravirt or real HW) exactly like
>> any other PCI device you are familiar with.
>>
>> It's connected physically to some slot, it has a BAR, MMIO, configuration
>> space, etc..
> In general case, it is far from being true.

it's exactly true.

But let give MST and Stephan to comment.

>
>> Thanks.
>>
>>> Thanks
