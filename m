Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDED41BB02
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 01:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243262AbhI1X37 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 19:29:59 -0400
Received: from mail-dm6nam11on2089.outbound.protection.outlook.com ([40.107.223.89]:62177
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243204AbhI1X36 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 19:29:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l7UhuQGnxtKZdormvB50Na8sRIx7TwADB6tr4LlMIvmFAXiI4ax/Hg0OVZMN1Fp4Y8UT23tlcMdzUM7wcUdGxRRzYNFfUnh6AEwVFXZM3tKu8oFh/x2/daXRtjXEBu11nm83YK1poVohLAp2BDCknbyj9n7zvNvUBM3e3os+dOypnqcrcttuGEUifkoQl8N8lepR3hxu8ATrIc5XPWUOR3j/4wMeHO8mYDDced+vMjCUkmylZkwUxUo9EGiK9NhC125lwyVy7/FWntsz/kZ9D9yOs0r5RP94XpMyW1f8NSRPyDdbeB/6LrqAX2rzba8XUM6FeYPzre7KBnUJQlfIwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=kzqbAKDZYi/FfYimjuvC92bSLOo1S/p/m39qGG1mvH0=;
 b=P+AKlKpbPVPV0oBwRYprc6K3fPu9E/3sPGJX3vpNd+8vjAbKol/FpaCr8Bq2rZ2pnIHIjNcHtsyFj+yqAG19W8eSo0PkLZdgnEK/tTBxLOHOBS83hAIONXK7ZzK/00jtG9Uvx5UFisyOfriWt7o9QoJmYZh0yY6TO412HidiX+2Z3bUy+A4EIeplzEZjvMY9Pbx8rnt3XiNmRzFLUMc5qMT1mblyGJEUKlESobhZFY0n0G/arfAO58i5GfPGBV7Ow9rTF21WBnHPHsVqOIhEqC3DDTxahbd1xh8WwWGSJQdW4ta2ytIgk4BQt8yFQ+6IbtDOxvGZhKSJ0zwkzPZ7/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=kernel.dk smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kzqbAKDZYi/FfYimjuvC92bSLOo1S/p/m39qGG1mvH0=;
 b=nQSPvBtrZRcNKtZWHwCJ/pqrznofu0P6GgJwbEVyirBGDuPhUfHLrBDw0YdVj0EOTszZuWLrtfL3TokQDPtflK45yDKY/Is1ysJshVy7jyGzlLnaooX9/jGZRcMVC88GACSybO/WyBn9DmiaWNXH6gRCGWC3y7gKz148QgU89yVvAxXG7PcaqNM9pmRL0F0s0kxPeyI82Mx8GbWMCJQBkAfCvexObFSGs3/gt+O7s6OpgMgmz/FO9C9jOaHCHwNgg+eF+Gv2Ela5e1j8lMI9ZV1WhH2QqbxOKsXR9BdPE5+zWPGBDC8cwWdGSaREswjNB0ju5UXDj3BzsuCe125zpQ==
Received: from MW3PR06CA0020.namprd06.prod.outlook.com (2603:10b6:303:2a::25)
 by MN2PR12MB3517.namprd12.prod.outlook.com (2603:10b6:208:ab::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Tue, 28 Sep
 2021 23:28:16 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::77) by MW3PR06CA0020.outlook.office365.com
 (2603:10b6:303:2a::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend
 Transport; Tue, 28 Sep 2021 23:28:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Tue, 28 Sep 2021 23:28:15 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 28 Sep
 2021 23:28:15 +0000
Received: from [172.27.0.100] (172.20.187.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 28 Sep
 2021 23:28:10 +0000
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
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <f0cc8cb4-92dc-f5f9-ea50-aa312ac6a056@nvidia.com>
Date:   Wed, 29 Sep 2021 02:28:08 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YVNCflMxWh4m7ewU@unreal>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51201daa-2d96-4a32-989f-08d982d7a5bc
X-MS-TrafficTypeDiagnostic: MN2PR12MB3517:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3517CF561EEEBE7A2EAE9436DEA89@MN2PR12MB3517.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wnAhEy7MGUhfgvOLHjVLcnG95mBnJw1v+C6JJ1Llumi9mhpsG1bo4fvEzJFwQsq6OCVlosbPPRiylgZuIXH5PMhC7u7UI5l6kZxR4TIIWUf36WEM3dMJQTr1akKWtiHZFc36R5qm55J32PH0TE4yN8w1H7nd4eD+AobBLcQOPCpNW+Xwyos9CW2Ll0WXq9Tf7CEAXWyxgDiUr3qp9QRY+H6p81azHTCeiwOFXvUuuC0SIs4A8ki0oNmInWSEjZ82IRFCfqSYPymLXEmSpx27zc0d9p5XIkBCP2LESxp4NGLvwJ7Cjlcv16Q1j0tvfjrJ1FE7k240sOXYs76CRv/8LBiWgAIkWJzpHQYtNl7YicS/OCjgTadvI4TE+LPYxFTKJ0Yy8j4RAk0sjnmDVGcml3AmClFOCpf0CyTImRq5aSFynH/JmMU6g0PnSI5qybFNWzirJYTW0QHz98uFh1eXj5n+WdmDOrMuDlcNk5ZxPr8ASxSwyG9mPQZXQ4u1qH8+xLn51XeYlIg0uGCqdyo0Rx7a5j1HWccDhVtfT/VzIen+xdPXt7YEsRn+Ka3OvyA1Q9O/Bo8MQdEXyAM0h41ChFqS9DDkKZdsjHyhqNHOfJu4ooyqTIbCeZR7xS7OLH1Qs7u7qfOKK8KGOuvmMFQBflOujUUdHjQKcMz6CoM3y6qrHE7eNU//AfpPb52A1U2N3qFfJ6/8Dy046BMY32PEm8crD5nFvk+38b0+c5PFyMA=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(31696002)(36756003)(4326008)(31686004)(16576012)(107886003)(5660300002)(54906003)(316002)(86362001)(426003)(336012)(6916009)(7636003)(82310400003)(70206006)(36860700001)(508600001)(356005)(70586007)(26005)(2616005)(8676002)(2906002)(83380400001)(16526019)(47076005)(186003)(53546011)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 23:28:15.8656
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 51201daa-2d96-4a32-989f-08d982d7a5bc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3517
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/28/2021 7:27 PM, Leon Romanovsky wrote:
> On Tue, Sep 28, 2021 at 06:59:15PM +0300, Max Gurtovoy wrote:
>> On 9/27/2021 9:23 PM, Leon Romanovsky wrote:
>>> On Mon, Sep 27, 2021 at 08:25:09PM +0300, Max Gurtovoy wrote:
>>>> On 9/27/2021 2:34 PM, Leon Romanovsky wrote:
>>>>> On Sun, Sep 26, 2021 at 05:55:18PM +0300, Max Gurtovoy wrote:
>>>>>> To optimize performance, set the affinity of the block device tagset
>>>>>> according to the virtio device affinity.
>>>>>>
>>>>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>>>>> ---
>>>>>>     drivers/block/virtio_blk.c | 2 +-
>>>>>>     1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>>>>>> index 9b3bd083b411..1c68c3e0ebf9 100644
>>>>>> --- a/drivers/block/virtio_blk.c
>>>>>> +++ b/drivers/block/virtio_blk.c
>>>>>> @@ -774,7 +774,7 @@ static int virtblk_probe(struct virtio_device *vdev)
>>>>>>     	memset(&vblk->tag_set, 0, sizeof(vblk->tag_set));
>>>>>>     	vblk->tag_set.ops = &virtio_mq_ops;
>>>>>>     	vblk->tag_set.queue_depth = queue_depth;
>>>>>> -	vblk->tag_set.numa_node = NUMA_NO_NODE;
>>>>>> +	vblk->tag_set.numa_node = virtio_dev_to_node(vdev);
>>>>> I afraid that by doing it, you will increase chances to see OOM, because
>>>>> in NUMA_NO_NODE, MM will try allocate memory in whole system, while in
>>>>> the latter mode only on specific NUMA which can be depleted.
>>>> This is a common methodology we use in the block layer and in NVMe subsystem
>>>> and we don't afraid of the OOM issue you raised.
>>> There are many reasons for that, but we are talking about virtio here
>>> and not about NVMe.
>> Ok. what reasons ?
> For example, NVMe are physical devices that rely on DMA operations,
> PCI connectivity e.t.c to operate. Such systems indeed can benefit from
> NUMA locality hints. At the end, these devices are physically connected
> to that NUMA node.

FYI Virtio devices are also physical devices that have PCI interface and 
rely on DMA operations.

from virtio spec: "Virtio devices use normal bus mechanisms of 
interrupts and DMA which should be familiar
to any device driver author".

Also we develop virtio HW at NVIDIA for blk and net devices with our 
SNAP technology.

These devices are connected via PCI bus to the host.

We also support SRIOV.

Same it true also for paravirt devices that are emulated by QEMU but 
still the guest sees them as PCI devices.

>
> In our case, virtio-blk is a software interface that doesn't have all
> these limitations. On the contrary, the virtio-blk can be created on one
> CPU and moved later to be close to the QEMU which can run on another NUMA
> node.

Not at all. virtio is HW interface.

I don't understand what are you saying here ?

>
> Also this patch increases chances to get OOM by factor of NUMA nodes.

This is common practice in Linux for storage drivers. Why does it 
bothers you at all ?

I already decreased the memory footprint for virtio blk devices.


> Before your patch, the virtio_blk can allocate from X memory, after your
> patch it will be X/NUMB_NUMA_NODES.

So go ahead and change all the block layer if it bothers you so much.

Also please change the NVMe subsystem when you do it.

And lets see what the community will say.

> In addition, it has all chances to even hurt performance.
>
> So yes, post v2, but as Stefan and I asked, please provide supportive
> performance results, because what was done for another subsystem doesn't
> mean that it will be applicable here.

I will measure the perf but even if we wont see an improvement since it 
might not be the bottleneck, this changes should be merged since this is 
the way the block layer is optimized.

This is a micro optimization that commonly used also in other subsystem. 
And non of your above reasons (PCI, SW device, DMA) is true.

Virtio blk device is in 99% a PCI device (paravirt or real HW) exactly 
like any other PCI device you are familiar with.

It's connected physically to some slot, it has a BAR, MMIO, 
configuration space, etc..

Thanks.

>
> Thanks
