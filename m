Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE50141DAF4
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 15:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351209AbhI3N0l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 09:26:41 -0400
Received: from mail-dm6nam10on2048.outbound.protection.outlook.com ([40.107.93.48]:41952
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1349373AbhI3N0l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 09:26:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VVFbBLtW69PcBJHjovzmyi9iA2DNSfQggsdAlUy+elPsEHz5QcnfNNP1bu9T1+bBu9Wf1dw/jPTBbWzPY6EjtBP5e+sXFMbafOOd2wbJQz0z9SA3nzjV5YK2nGD15mLjVh8gRfWdHHk07DAZa+GZF9U7V7QTfblFTXz4e/itqpwn3ErhZLLThUo9IfxcjsYiLu21NB9WYWX7BLCYZ7wiaq6xy1qVlrJpne4cLPapOdNOnpUVcsCJPVV+zLe8dEy92DYOsyhKuTK2n6Jj6seGgdVG9+7BN3TiNaukSRCU69OMbvfqomYH4vCmH+cigZwNEMUiV2OyaU1KRUkOTPI7+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=te0ZrFMASQDVmLIDv558Ax/mipjbB36bFGaUdWXKj8c=;
 b=NQRMb/Ble+J5b8HoK5KSNnkLM0h24tDrqETlU6qumPYoW6seL8JKJgvwdTyxymdjxaxtj6gTGZuhP/qZL09m4JUN9SS0XE2s8751Qsjzx9/VIPhYD0Oz7EJxLCvrFKFWbiCopu2dexjyuHqcx20apWtYW2cJiCxSvkGwF1vYsYsgfPXMNyUNkaRTq7j5csd3clmSRHRMD16rumCm7+5SJCIgKJdUpWaiBaf4Tz45bcs0PiglOo71UM2O7peffkZ+4uqJbiNk6zeMX2o51dQ84+lmt5zho+xZtvVEOmvqBk1YLSdIynQFVb0uGkBz9NGnYW/DK4WWtDVLyyIqL5Il7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=none pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=te0ZrFMASQDVmLIDv558Ax/mipjbB36bFGaUdWXKj8c=;
 b=ksLybhQg6VyMEjUG6+rBwhIM9t5OG/Tee/4tpY3gkE+7cRQixTEZXSwHyPcHoDGepk0Yt41PencHMj1X35/lWZrrHggb9GOQfGgvrZfWNDZeegpsFY5GKWn/Xgo6yKgnmTjl0l/mbax2kv88saYK3J7Y86F+kDSiW9pbZPVWdrNuqFXcsIxxW3dpyEDDfT9JH/tzycdA50+NTnCtKx7gkNQQAxtyEvl75Rd4seWZKNuFiU9pe+wMGZ59LZW/waRuIzpdWOpXNoB6J2n3JHsmVkLcvfudLx3CZ4YssYE/HYXHiHw9N6cfNKMrwGSICV1SDef/z8wT6W0qje4CCReJMw==
Received: from MWHPR15CA0041.namprd15.prod.outlook.com (2603:10b6:300:ad::27)
 by BY5PR12MB3828.namprd12.prod.outlook.com (2603:10b6:a03:1a4::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.16; Thu, 30 Sep
 2021 13:24:56 +0000
Received: from CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ad:cafe::d9) by MWHPR15CA0041.outlook.office365.com
 (2603:10b6:300:ad::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13 via Frontend
 Transport; Thu, 30 Sep 2021 13:24:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT029.mail.protection.outlook.com (10.13.174.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4566.14 via Frontend Transport; Thu, 30 Sep 2021 13:24:56 +0000
Received: from [172.27.13.136] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 30 Sep
 2021 13:24:50 +0000
Subject: Re: [PATCH 2/2] virtio-blk: set NUMA affinity for a tagset
To:     Stefan Hajnoczi <stefanha@redhat.com>
CC:     <mst@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <kvm@vger.kernel.org>, <oren@nvidia.com>, <nitzanc@nvidia.com>,
        <israelr@nvidia.com>, <hch@infradead.org>,
        <linux-block@vger.kernel.org>, <axboe@kernel.dk>
References: <20210926145518.64164-1-mgurtovoy@nvidia.com>
 <20210926145518.64164-2-mgurtovoy@nvidia.com>
 <YVF8RBZSaJs9BScd@stefanha-x1.localdomain>
 <21295187-41c4-5fb6-21c3-28004eb7c5d8@nvidia.com>
 <YVK6hdcrXwQHrXQ9@stefanha-x1.localdomain>
 <f15e1115-25c1-5b9a-223c-db122251d4c1@nvidia.com>
 <YVW4yIkWWEUMsBLp@stefanha-x1.localdomain>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <c9d92698-207f-e97d-c753-6c07977d523d@nvidia.com>
Date:   Thu, 30 Sep 2021 16:24:45 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YVW4yIkWWEUMsBLp@stefanha-x1.localdomain>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9bb2e456-ff12-43d4-7e01-08d98415b1e1
X-MS-TrafficTypeDiagnostic: BY5PR12MB3828:
X-Microsoft-Antispam-PRVS: <BY5PR12MB3828E8939B360D362A4C9B73DEAA9@BY5PR12MB3828.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ES2/zfGmv0IbB7s+nq/WeRIE08s5S6YT7DU0xzrjqdVpaTd/WhLoY8Iz5e9SED7xhbN5KzTHUZ9mS3w8FSb8vMDNq/qTr9vwb5mNJ73gRPi+xP1ZlLJIB0jmfr2un3+Q5uvVjdsq4T1eazJQQ2zw9HGyfAzuC7zxkdZ7u6n5/OKqVc5telCXr1hVu3wQ1qxCT0XtDgJO02i2TenJRnQEfQJ0ZWe/LDfM86epn/ift2uvy3HOsPAARYaU1K9n16YJALngGr7fBUmVqrP2DD/e2Z9e2gXk2M5TbO5JL1ps1mN6pdMZoCxrBM0auB+6c2nRBv3MDj/v7mcP1HTyQhJ1TWeZ1L2jKWqNmr9iBmqhD9q2+HO9Q2kjwV1VJ65iWCqNAJA57ix20oC7iBQcoOGVkKYTbl4S04sr7anBWKouJ9pzIyv8+qPgwcIsv20mIMgWWeJ6VbeKumGXJ1byhc/T0m3rjnUXeCcXZlESbMNEzE2udfJ0yUhECxgES6BG/IJF5BcXIONY2Qv8UwtXgsyENhqyXNcdiLKPEnm+Lo2hOCHTnSRZ53DIPmasenJH5RzEP8pXN8eaFEE4E9yUTG6HcH/qwMbyWaekP0+yV7d9oCDv1z4yaMnFNJ9memxglecInJjl7pncDQMOpVt6VMAWM7exY+MJyX+ydfEl32noAgqjJy81KZELnGtCLzh2r9p6tACUbVPvW8wEzo0qNQ34JRFSAGy9Q4EDKUNh3nbK9qRbHI3X6AWQJht8TavbODiZ8Lvzml34Qw7b0+azpWPXpeUbhhPrzeEI6BqRNj98Gk6dAMPC4x0kWa3yF7gM1xuu
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(36906005)(31686004)(8936002)(2616005)(83380400001)(70586007)(26005)(36860700001)(316002)(47076005)(8676002)(5660300002)(70206006)(86362001)(36756003)(16576012)(6666004)(7636003)(2906002)(82310400003)(4326008)(966005)(53546011)(356005)(31696002)(508600001)(6916009)(186003)(336012)(426003)(54906003)(16526019)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 13:24:56.2052
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bb2e456-ff12-43d4-7e01-08d98415b1e1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3828
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/30/2021 4:16 PM, Stefan Hajnoczi wrote:
> On Wed, Sep 29, 2021 at 06:07:52PM +0300, Max Gurtovoy wrote:
>> On 9/28/2021 9:47 AM, Stefan Hajnoczi wrote:
>>> On Mon, Sep 27, 2021 at 08:39:30PM +0300, Max Gurtovoy wrote:
>>>> On 9/27/2021 11:09 AM, Stefan Hajnoczi wrote:
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
>>>>>>     	vblk->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
>>>>>>     	vblk->tag_set.cmd_size =
>>>>>>     		sizeof(struct virtblk_req) +
>>>>> I implemented NUMA affinity in the past and could not demonstrate a
>>>>> performance improvement:
>>>>> https://lists.linuxfoundation.org/pipermail/virtualization/2020-June/048248.html
>>>>>
>>>>> The pathological case is when a guest with vNUMA has the virtio-blk-pci
>>>>> device on the "wrong" host NUMA node. Then memory accesses should cross
>>>>> NUMA nodes. Still, it didn't seem to matter.
>>>> I think the reason you didn't see any improvement is since you didn't use
>>>> the right device for the node query. See my patch 1/2.
>>> That doesn't seem to be the case. Please see
>>> drivers/base/core.c:device_add():
>>>
>>>     /* use parent numa_node */
>>>     if (parent && (dev_to_node(dev) == NUMA_NO_NODE))
>>>             set_dev_node(dev, dev_to_node(parent));
>>>
>>> IMO it's cleaner to use dev_to_node(&vdev->dev) than to directly access
>>> the parent.
>>>
>>> Have I missed something?
>> but dev_to_node(dev) is 0 IMO.
>>
>> who set it to NUMA_NO_NODE ?
> drivers/virtio/virtio.c:register_virtio_device():
>
>    device_initialize(&dev->dev);
>
> drivers/base/core.c:device_initialize():
>
>    set_dev_node(dev, -1);

Ohh I was searching NUMA_NO_NODE. I guess the initial commit from 
Christoph 15 years ago was before adding this macro.

I'll send a patch to fix it.

I hope I'll have a system to check your patches next week.

>
> Stefan
