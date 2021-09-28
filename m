Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D829E41B367
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 18:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241647AbhI1QBj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 12:01:39 -0400
Received: from mail-mw2nam12on2061.outbound.protection.outlook.com ([40.107.244.61]:25121
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241523AbhI1QBi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 12:01:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nk7jmkqpaWHkNAL2sGGfuh1bme9xY3/aBS/maqk8/qVdLd/JElA6BpvwGp1NFTfIR5zio9boB3Z/IFti3MAlLCM+SvsZraG2iPXfBL4ndPiavZ3eQ++sIDpaE4JrWLtXZbuHYqRI+84mH0n4Qv0SHJ3AsA2OY/EEsrFWtaZVQ2zebaProubhjKYu35Tt1o/+O4V95ydsiMe8Ywv7iD+2A2negQdgAM9j8gb2NSYqpSp+trEM+7+xMTlcc7AloOB8vJDvCZGsYL0yHf4CVIdoOEOlDina1wUGWsXfzLYh887Sa1oWAJ1lGpRlSzXGlzBuK65LtsFvHlmpVBnfNcLeBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=PlneoeLxO5A4SdoYD9CIPF6hMkE7xgx3Xk0MaBzsKzs=;
 b=MZ0D+c7R8K2rz16+P19DNGUouJD4PGdZ1UL2FJS/6R0dXVhASzkk/JcEzkG8ImUmZMieIZuTQec9m9t72Ld0NiCsQTFL53u29rdKtf+oJ4v32Sz7htZqITUcVUR/Jslown48rZs5HZnhmnOmgRZxhdtz+9ZD2fPfQZOeQWMysjcnM1zEILo/3PtlsyGjThhbrVjNEDKCTCjctf38eF1KjLI7WJckXEbO+yYt2FgR35L71f7CYEygS3KuIHvZTbJXwpxaHuYhrDkdUaKSKKeK1wZTT920B2ePzoh6L6UPcB9buaHcxOLvaSGQaPdAow4iy7whMPCx2k6PrMObFaHPmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.dk smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PlneoeLxO5A4SdoYD9CIPF6hMkE7xgx3Xk0MaBzsKzs=;
 b=ngtxr5St/OI04TNVHlAJCXAru4QbGa4ZcdomrY6ngnAb9Cb4UJ1wqwTzlo+m53M8d2Wfz6XsGX0dlaC2ExE/MOF092hL3IHHR9c+Xj7pMwrLMS1YbwlVhU0MTWuUjwTjeIvWgEJG00yQbbHsPkvT9jinm4BOLzyQlqTwfqFPQF6lxGHrir0wXJSFB8WgZewdT19GMWT03CEBCGLby3UTTwMa9GZ9sGQu3j/HIfFdQeb0sYvOFBK3NBEel6KQp7jM4T/bnn+x9PWRpUQvxeAkVWeHriDcDMop8jMSJNPzNLJ4u08JvszBXBtjZEoFJ9KNLBZfOsTlNdRrrh0zCm9zYA==
Received: from BN8PR04CA0049.namprd04.prod.outlook.com (2603:10b6:408:d4::23)
 by DM6PR12MB5517.namprd12.prod.outlook.com (2603:10b6:5:1be::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Tue, 28 Sep
 2021 15:59:57 +0000
Received: from BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:d4:cafe::71) by BN8PR04CA0049.outlook.office365.com
 (2603:10b6:408:d4::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13 via Frontend
 Transport; Tue, 28 Sep 2021 15:59:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT050.mail.protection.outlook.com (10.13.177.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Tue, 28 Sep 2021 15:59:56 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 28 Sep
 2021 15:59:56 +0000
Received: from [172.27.0.114] (172.20.187.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 28 Sep
 2021 15:59:52 +0000
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
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <f8de7c19-9f04-a458-6c1d-8133a83aa93f@nvidia.com>
Date:   Tue, 28 Sep 2021 18:59:15 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YVIMIFxjRcfDDub4@unreal>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5486440-f210-4509-c12f-08d9829904ae
X-MS-TrafficTypeDiagnostic: DM6PR12MB5517:
X-Microsoft-Antispam-PRVS: <DM6PR12MB5517418DA4CBA021776C4BC4DEA89@DM6PR12MB5517.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Brj9pGJg+ZxtDndd5oTzf/VlIa7edWVGK3+4gFsY4tJaen3L7txFzpqPV0rvAp645BtcAsTSWyYkqTBXYSBtsInqwIApJ3r7C8QD6UA4Z3XdxQubKSZk69ji3SNOkpyvjv8Dd+cVer7atozFYlHvECYAs/LtktwCy9N/Bil5gYuBOhhp/9O9CTgkWGDInSIv14Cq3zdb8AcRPrFrv0mI2e/Q+0kRwMTjb6xYRnTSaaZjUdSSUNQePf6TJkVsugbGe/nqOd1bCDddW225cW3P6p77+oGBX9ORELDXCSjvIpOBPioKYuVbUzOto+Cu7W3tQh0/0vlLALsaE9LVQoguslpvRZbjMFFaf586GN9Id7xo6yFU4cSwgFcOp0PVsCjStWAm9pGAiqKqvuW1Quhxb8FxERQfIfn7oiv5Ui7QLjlCg2PSoJjX/WrUZYmvA/4f/00E5SR2UiQCDkG5qh39LaatEXzgD2yB7G3++2XwNH6ed350AJXKbniP80V8MuN8AM4YHslA34LBYQafKTXCa82zuWSaDJx1aX6NDiqFC6BV4CAO+dhedl+5HUR2N/E/GpmuZt8nZyTytYz6K9sGWMEtnkUkSwNFlVCeuR2XTfnkdgTMmUEtYjjnIo2LObVNC1I8G37SbmOOLv62oQC82OodkGqCz+lm2G2NcqrdTVjOl63AtxS8y/yCNfZF0sMfXyJ05w8rC6uFkIRj+CT81L4JfkOvsL1xLVFeneXdfoM=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(7636003)(31686004)(356005)(6916009)(36756003)(82310400003)(36860700001)(2906002)(5660300002)(2616005)(186003)(426003)(26005)(336012)(16526019)(6666004)(70586007)(70206006)(53546011)(83380400001)(107886003)(47076005)(16576012)(31696002)(54906003)(86362001)(508600001)(36906005)(8676002)(4326008)(316002)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 15:59:56.8015
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a5486440-f210-4509-c12f-08d9829904ae
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5517
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/27/2021 9:23 PM, Leon Romanovsky wrote:
> On Mon, Sep 27, 2021 at 08:25:09PM +0300, Max Gurtovoy wrote:
>> On 9/27/2021 2:34 PM, Leon Romanovsky wrote:
>>> On Sun, Sep 26, 2021 at 05:55:18PM +0300, Max Gurtovoy wrote:
>>>> To optimize performance, set the affinity of the block device tagset
>>>> according to the virtio device affinity.
>>>>
>>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>>> ---
>>>>    drivers/block/virtio_blk.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>>>> index 9b3bd083b411..1c68c3e0ebf9 100644
>>>> --- a/drivers/block/virtio_blk.c
>>>> +++ b/drivers/block/virtio_blk.c
>>>> @@ -774,7 +774,7 @@ static int virtblk_probe(struct virtio_device *vdev)
>>>>    	memset(&vblk->tag_set, 0, sizeof(vblk->tag_set));
>>>>    	vblk->tag_set.ops = &virtio_mq_ops;
>>>>    	vblk->tag_set.queue_depth = queue_depth;
>>>> -	vblk->tag_set.numa_node = NUMA_NO_NODE;
>>>> +	vblk->tag_set.numa_node = virtio_dev_to_node(vdev);
>>> I afraid that by doing it, you will increase chances to see OOM, because
>>> in NUMA_NO_NODE, MM will try allocate memory in whole system, while in
>>> the latter mode only on specific NUMA which can be depleted.
>> This is a common methodology we use in the block layer and in NVMe subsystem
>> and we don't afraid of the OOM issue you raised.
> There are many reasons for that, but we are talking about virtio here
> and not about NVMe.

Ok. what reasons ?


>
>> This is not new and I guess that the kernel MM will (or should) be handling
>> the fallback you raised.
> I afraid that it is not. Can you point me to the place where such
> fallback is implemented?
>
>> Anyway, if we're doing this in NVMe I don't see a reason to afraid doing it
>> in virtio-blk.
> Still, it is nice to have some empirical data to support this copy/paste.

I'm not sure what you meant when you say that, but this was just an 
example as everyone else saw. No copy/paste.

Anyhow, taking good ideas from other Linux subsystems is common and I 
don't see a problem doing so.

I'll let the storage experts to comment on that and the maintainers to 
decide whether they would like to take this optimization among other 
optimizations I've sent to this subsystem.

I'll send a v2 in few days.

Thanks.

>
> There are too many myths related to optimizations, so finally it will be
> good to get some supportive data.
>
> Thanks
