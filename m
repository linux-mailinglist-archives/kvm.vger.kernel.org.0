Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C633FEDE8
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 14:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344663AbhIBMmK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 08:42:10 -0400
Received: from mail-dm3nam07on2061.outbound.protection.outlook.com ([40.107.95.61]:57988
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234098AbhIBMmK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 08:42:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TU0/Fg1W5YeTfz03Jc1nUnrWPD0e7q5/VMGtuC6dhuGuwKjGQuqcA4U9hoLfEAEqJW5u/Pr8Xldwx6iZG6MxnLQxEbYMu3gsvwKqQE2F5kKa7uAj282e+qatgO+sN0FHWCIxg9Px7WKJMaanAhmEgvXLTII7FC0LFUPgkOarhR5K2Hs4Ca9qHHIBnJkTTgciRfPfm2R9ztYnwPkKGZ+YdjdbwLzxcPo+91KA9OAhboCIDjmeFcNJ49iUoxh+BSte1ZEVryoGgGo7e6gqtLysm08FG1Tf9R8kPqhbLw9nQsC0MKpea/cygPA7b/P68/IvV0KWErwfE6v+DOaqDCeYvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=SARnDv7ZMhH2eqwgqjUe+EEnuThwlm2xat6htonBLAE=;
 b=IxDNf429XMzAA0Q/aOpGP8OiOobo1FOWx8tppD4IMPHQOUFtShexTdDcvcT32ZswMdSOalc3eNOXGA6UnXl9vnYEMF0L9vZjyyZpJIpdW88U5xQ+HYY/iAPqnUQm8jreLtY9xpS70/wLH0P3Hym7TEZjTZXJMWc/iBAm4uvrXHVNosfPzUh8qeo7QavZZwDuxSDyemh8dayFsYXzsIhBoj2G0WOFHhOEq6ZUAw+xPO5X6E9ExXsChP5glTnDrPpzeJPcoeAjwtTzueklj8KERTsHf1qMbkJMN5UYor09jdVonljQDAq3BGw5h55WPSjXXqnCZY8Gl9B8HssL54ALzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=infradead.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SARnDv7ZMhH2eqwgqjUe+EEnuThwlm2xat6htonBLAE=;
 b=sddEB2jf42XYL714SyqYEuFWukSjlMNw18mmFMsKhhCVdHK2WEfCMgHJpv1rAhXLtAYATq+ZQImc0lw/tdJk6gLALsqBrhHQWdkmyi5nIv8tLxzFUa9hYARRVzDEcorOCoAIVXtzt2gjUMAeollDG2RSTt/qcOSpb8hUmn/p0mRSEyfSPLwaFTsC80w9zZWJcc95CbI/ASRSCowK0CifIES1rxwgL+Q1+4vvGp5UJaasBSJxA2Qw1MJa1M2m4W+rF8PKOvc9DYbn4fqlAi+bxv/dEw+n9zJYYoy4euD+QIbf8NFXf7K5iaIVtyfIep6s1FP4dSNS1O45V4dxKxw/JQ==
Received: from DM6PR02CA0080.namprd02.prod.outlook.com (2603:10b6:5:1f4::21)
 by BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Thu, 2 Sep
 2021 12:41:10 +0000
Received: from DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1f4:cafe::90) by DM6PR02CA0080.outlook.office365.com
 (2603:10b6:5:1f4::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend
 Transport; Thu, 2 Sep 2021 12:41:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT004.mail.protection.outlook.com (10.13.172.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4478.19 via Frontend Transport; Thu, 2 Sep 2021 12:41:09 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 2 Sep
 2021 12:41:08 +0000
Received: from [172.27.1.153] (172.20.187.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 2 Sep 2021
 12:41:05 +0000
Subject: Re: [PATCH v3 1/1] virtio-blk: avoid preallocating big SGL for data
To:     Stefan Hajnoczi <stefanha@redhat.com>
CC:     <hch@infradead.org>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <israelr@nvidia.com>, <nitzanc@nvidia.com>, <oren@nvidia.com>,
        <linux-block@vger.kernel.org>, <axboe@kernel.dk>
References: <20210901131434.31158-1-mgurtovoy@nvidia.com>
 <YTDBx/E/UJZWTFlG@stefanha-x1.localdomain>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <c8107800-63fa-2ab5-235f-6f365e22abe1@nvidia.com>
Date:   Thu, 2 Sep 2021 15:41:02 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YTDBx/E/UJZWTFlG@stefanha-x1.localdomain>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9b295f6-062a-4b39-79e8-08d96e0ef0b1
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:
X-Microsoft-Antispam-PRVS: <BL0PR12MB2370B9C0056BE946ADCECEA0DECE9@BL0PR12MB2370.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yUMaIYeNHq1ikoZLNQH/M32uq4g+ahsT5qGN1c3zwLxzmyoUZ6QQQtOSjQ6GTLsus41sc+frl4K2asVRUO5/MDlK3jpj/zkwbbuSdifoisbKGofTNF8E3VNiEDpkC1N+bbKpuuAnSsvq53rF6zqNYG5sQm3IO4krKIK0Nz6BJCV9xT9YoUf5y3FM2UafsS7vsOzHIGlp3NTz1HXpoYNp3MLeWRHETjq40I0UYuUHfg3RAtWLFDj6P8/fjSlOPRR+KT+5LO26Q5TShoqTflFkjKQKWZ2zNOZziqMPlXZrFfFbCab9Mw51d1X3XZP+bOp78ML46squIjfGH96+CwW62wlXXwHJDibxyrtyteXuNkrn6PYYnXhfGvchFTQ/a2QbXJ0fSaI2l/KLpuMFrxWI0qshn5TNgsNXA6gjgyLDrNP+5Nk8vxWmkrsy21mr4fYW9SXL/VknI2fW52HMpyeNPT71PNIo/wQjwOo3ViOidjxzLRJE9OzlvjFZnCnOx/9MI7W18yPQSfR2TGVQR1/wMBfU0GB7CiVmgAWx0KxH/8wgRLjYqEQd15rq9Ee0gf8x2cqc8wY3ijd3VVr/eX1cDWjjx2NN0pwwhRN7vJ34/uYA8hSpe/F+FU3vIOcRlcBOy7rir5r99YqzzZWIquqhkN9PAc20B9taLzYGdZ2ckJ1BjLLb4c/MfmHCu1T7NmxewPFsjAX89aLDzQh0yenhtGaencFf7LKFUrLG+8KagaE=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(16576012)(316002)(36906005)(54906003)(83380400001)(6916009)(2906002)(26005)(508600001)(36756003)(5660300002)(8936002)(4326008)(6666004)(7636003)(8676002)(336012)(186003)(16526019)(426003)(2616005)(356005)(47076005)(53546011)(70586007)(31696002)(70206006)(82310400003)(36860700001)(31686004)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2021 12:41:09.5306
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e9b295f6-062a-4b39-79e8-08d96e0ef0b1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2370
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/2/2021 3:21 PM, Stefan Hajnoczi wrote:
> On Wed, Sep 01, 2021 at 04:14:34PM +0300, Max Gurtovoy wrote:
>> No need to pre-allocate a big buffer for the IO SGL anymore. If a device
>> has lots of deep queues, preallocation for the sg list can consume
>> substantial amounts of memory. For HW virtio-blk device, nr_hw_queues
>> can be 64 or 128 and each queue's depth might be 128. This means the
>> resulting preallocation for the data SGLs is big.
>>
>> Switch to runtime allocation for SGL for lists longer than 2 entries.
>> This is the approach used by NVMe drivers so it should be reasonable for
>> virtio block as well. Runtime SGL allocation has always been the case
>> for the legacy I/O path so this is nothing new.
>>
>> The preallocated small SGL depends on SG_CHAIN so if the ARCH doesn't
>> support SG_CHAIN, use only runtime allocation for the SGL.
>>
>> Re-organize the setup of the IO request to fit the new sg chain
>> mechanism.
>>
>> No performance degradation was seen (fio libaio engine with 16 jobs and
>> 128 iodepth):
>>
>> IO size      IOPs Rand Read (before/after)         IOPs Rand Write (before/after)
>> --------     ---------------------------------    ----------------------------------
>> 512B          318K/316K                                    329K/325K
>>
>> 4KB           323K/321K                                    353K/349K
>>
>> 16KB          199K/208K                                    250K/275K
>>
>> 128KB         36K/36.1K                                    39.2K/41.7K
>>
>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>> Reviewed-by: Israel Rukshin <israelr@nvidia.com>
>> ---
>>
>> changes from V2:
>>   - initialize vbr->out_hdr.sector during virtblk_setup_cmd
>>
>> changes from V1:
>>   - Kconfig update (from Christoph)
>>   - Re-order cmd setup (from Christoph)
>>   - use flexible sg pointer in the cmd (from Christoph)
>>   - added perf numbers to commit msg (from Feng Li)
>>
>> ---
>>   drivers/block/Kconfig      |   1 +
>>   drivers/block/virtio_blk.c | 155 +++++++++++++++++++++++--------------
>>   2 files changed, 100 insertions(+), 56 deletions(-)
> Hi Max,
> I can run benchmark to give everyone more confidence about this change.
> Should I test this version or are you still planning to make code
> changes?

Yes you can test v3.

Thanks,

Max.

>
> Stefan
