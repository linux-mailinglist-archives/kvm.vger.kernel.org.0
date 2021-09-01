Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44B63FE573
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 00:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242332AbhIAW0I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 18:26:08 -0400
Received: from mail-dm3nam07on2064.outbound.protection.outlook.com ([40.107.95.64]:39840
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236791AbhIAW0I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 18:26:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n9oRwI3NYIoBLYCwpBRWMMtQ+S7lwK8hgTSlcCdnHcJcFm5uOHCpj762Mur2t0hzxF2YbdXc9occ9tFoMjbXpujcoijjDFcpdQ+cySCgi3H6K4yoT4LzT5234+vZ56WNAqL6te0TzK9XO0wPKdPqjKfsu05FwmuaU4txesMJ5u9plEy8g++nKoQO+xDK4x6iBzSzkdrnBPNgiB4G0cebu3czHkqssWJvdGkPlrf8WoFEb/BQcpAmp/i36TXNmZgw+tVWLbSrER9ATXLWBzDTy1dSvlciSskjKbKMWMGYrZ4L80NZfKVVZx0hywOwUzmMmDKau+tSR3zLEz3XREg5PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YWQzvsEvun1zKASGqq5q7rOzglsaquan+gyWB6zskss=;
 b=jMkXPjnbosD+5YTg5emB2WBjAYguMUlPSEc9Oie4CqwBmIcU0QwQ4QfPP9kNM6Ab0okwS0UTh2ZYoOxn3D2WYGw7Sydcb2GH2PoJraOPpTVQIti+S/VYx8CJcxe1lXZFbIfGJRRi1n/sQAPRdMzX6NF0j3/PsxFAkKSxcTQiYQjifCr0z68Cfq9ts+XS0z3M/qLaUS4Xct73O8cvqOqEZzRiDvktLs2XpFfhyJ2bMkfG5muw+ity2oMNOmrL9efsTfOS91oTP8D53+9+jrbatmeUXU/BgMrIOzgv9xPGW+K+1CGjWVjBIVy/ZbJ4hn1RDpm11XIc9XpK3vNejd2waA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YWQzvsEvun1zKASGqq5q7rOzglsaquan+gyWB6zskss=;
 b=ZrefpsErH5H2f+wA+9ahH3lLmbOqlokxZ7+xMwaIDpSd89OXgvUvvUqBJOrsjOqFFmA3qPwUNcLXM4VrWiMxUH391azinKHZ7GccAh7yHAhqtk8mVQ6IQcy93tL4G6QxLVDnMD1cTQblKGm63G90s3AnF5z8wGr3Ga1aTNUwji2pRVdiPyxPjgfhEN5VPgfEOvujhty8ypUzuhdi3v9llASiyQT06mSI6RICoJBn5DbnIRpCTxKD2w/xEzP9lIC+eXJ0Zs/JP+OAbYvsLT1N3BQTm1cJD2cyA79sV3GAttPr0z0yb+xO7FqbcRN7Br2tHKxbj7iPJz41aw6lFk9Lqg==
Received: from MWHPR2201CA0045.namprd22.prod.outlook.com
 (2603:10b6:301:16::19) by BN6PR1201MB2497.namprd12.prod.outlook.com
 (2603:10b6:404:b3::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Wed, 1 Sep
 2021 22:25:09 +0000
Received: from CO1NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:16:cafe::a8) by MWHPR2201CA0045.outlook.office365.com
 (2603:10b6:301:16::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17 via Frontend
 Transport; Wed, 1 Sep 2021 22:25:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT023.mail.protection.outlook.com (10.13.175.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4478.19 via Frontend Transport; Wed, 1 Sep 2021 22:25:08 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Sep
 2021 22:25:07 +0000
Received: from [172.27.1.128] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Sep 2021
 22:25:05 +0000
Subject: Re: [PATCH v3 1/1] virtio-blk: avoid preallocating big SGL for data
To:     Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>
CC:     <hch@infradead.org>, <virtualization@lists.linux-foundation.org>,
        <kvm@vger.kernel.org>, <stefanha@redhat.com>, <israelr@nvidia.com>,
        <nitzanc@nvidia.com>, <oren@nvidia.com>,
        <linux-block@vger.kernel.org>
References: <20210901131434.31158-1-mgurtovoy@nvidia.com>
 <20210901102623-mutt-send-email-mst@kernel.org>
 <89d6dc30-a876-b1b0-4ff4-605415113611@nvidia.com>
 <6a648daf-dd93-0c16-58d6-e4a59334bf0b@kernel.dk>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <3ee9405e-733f-30f5-aee2-26b74fbc9cfc@nvidia.com>
Date:   Thu, 2 Sep 2021 01:25:01 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <6a648daf-dd93-0c16-58d6-e4a59334bf0b@kernel.dk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06f89c7b-cb5c-43b5-c436-08d96d975b22
X-MS-TrafficTypeDiagnostic: BN6PR1201MB2497:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB24977005B52C446C812658C3DECD9@BN6PR1201MB2497.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yG5nvEBoF+BVY1wWcpwuKs8CKVYzTG1zDamayrskvHvjQsZoZ5Y7TSyekzv7Qx8a0g3XyoQYF8o/guk7XiHvvVfN5Mki0A8H62HrCWkqCK6Por5pfxQ8Jt7dm5AC4kxE3mebJ6FLmn5lzAbdqOm1i/kOE5+BHs0tXnBa3IEP8mv+zq3mdrWSc7uSNZAmW97HKhSSzMdCPm0Ftc4zzbUzQnbFQ52u/Em62lG7Sjdfdm5jQQBtugVfXtH37un3fgwnWhTYcJCZiBRpVnYlOYVPmmV3YeYDvlidjUulyuDQOaEp09RhTgxdpvXcTEANWp5+8YKyp9dxKdRuqrfSUwS4mHXPxlSuBGnacLmbtYqAmpFB1xVlIO3QEwZdiuMFiOUdOPQOce58P3DDtZeGvl7Rz4IFVTQEruCthIfeXnWlbIsuHt6UeecOg01QTMoXiPhPbuccUez7cCtsS/2DqxOYzmDPvgHZjZq8h75J/nwpwC5H1wf4ZMLmKrNC5a/QO6gSK6XqmjCjQMsD0UnqKbhgbmFNxWUiNZ3SmFrEp5UQCUQOWll8oWh5BmiGqmbYnQxUHWwDI+aXCqyfebnAdm5r/D1RpGyzMyIyYsD63yUjHKgx+n0Q8L66Z6IilNg84lSODd0xuXhcsysdzpXWhdG8Pug6kIEv+whhAKs4HVVqY09VWVrXw0UPBFqsuwOIP0bH6X9t6xU/KGfZ42IJv/D1/Mx5mZRvujMHo8Nli5//Atg=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(39860400002)(396003)(36840700001)(46966006)(8936002)(2616005)(36756003)(356005)(82740400003)(31686004)(47076005)(2906002)(5660300002)(8676002)(7636003)(36860700001)(86362001)(31696002)(53546011)(26005)(82310400003)(4326008)(83380400001)(316002)(110136005)(36906005)(54906003)(6666004)(16576012)(478600001)(70206006)(186003)(16526019)(426003)(336012)(70586007)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2021 22:25:08.4671
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 06f89c7b-cb5c-43b5-c436-08d96d975b22
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2497
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/1/2021 6:27 PM, Jens Axboe wrote:
> On 9/1/21 8:58 AM, Max Gurtovoy wrote:
>> On 9/1/2021 5:50 PM, Michael S. Tsirkin wrote:
>>> On Wed, Sep 01, 2021 at 04:14:34PM +0300, Max Gurtovoy wrote:
>>>> No need to pre-allocate a big buffer for the IO SGL anymore. If a device
>>>> has lots of deep queues, preallocation for the sg list can consume
>>>> substantial amounts of memory. For HW virtio-blk device, nr_hw_queues
>>>> can be 64 or 128 and each queue's depth might be 128. This means the
>>>> resulting preallocation for the data SGLs is big.
>>>>
>>>> Switch to runtime allocation for SGL for lists longer than 2 entries.
>>>> This is the approach used by NVMe drivers so it should be reasonable for
>>>> virtio block as well. Runtime SGL allocation has always been the case
>>>> for the legacy I/O path so this is nothing new.
>>>>
>>>> The preallocated small SGL depends on SG_CHAIN so if the ARCH doesn't
>>>> support SG_CHAIN, use only runtime allocation for the SGL.
>>>>
>>>> Re-organize the setup of the IO request to fit the new sg chain
>>>> mechanism.
>>>>
>>>> No performance degradation was seen (fio libaio engine with 16 jobs and
>>>> 128 iodepth):
>>>>
>>>> IO size      IOPs Rand Read (before/after)         IOPs Rand Write (before/after)
>>>> --------     ---------------------------------    ----------------------------------
>>>> 512B          318K/316K                                    329K/325K
>>>>
>>>> 4KB           323K/321K                                    353K/349K
>>>>
>>>> 16KB          199K/208K                                    250K/275K
>>>>
>>>> 128KB         36K/36.1K                                    39.2K/41.7K
>>>>
>>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>>> Reviewed-by: Israel Rukshin <israelr@nvidia.com>
>>> Could you use something to give confidence intervals maybe?
>>> As it is it looks like a 1-2% regression for 512B and 4KB.
>> 1%-2% is not a regression. It's a device/env/test variance.
>>
>> This is just one test results. I run it many times and got difference by
>> +/- 2%-3% in each run for each sides.
>>
>> Even if I run same driver without changes I get 2%-3% difference between
>> runs.
>>
>> If you have a perf test suite for virtio-blk it will be great if you can
>> run it, or maybe Feng Li has.
> You're adding an allocation to the hot path, and a free to the
> completion hot path. It's not unreasonable to expect that there could be
> performance implications associated with that. Which would be
> particularly evident with 1 segment requests, as the results would seem
> to indicate as well.

but for sg_nents <= 2 there is no dynamic allocation also in this patch 
exactly as we do in nvmf RDMA and FC for example.


>
> Probably needs better testing. A profile of a peak run before and after
> and a diff of the two might also be interesting.

I'll run ezfio test suite with stronger virtio-blk device that reach > 
800KIOPs


>
> The common idiom for situations like this is to have an inline part that
> holds 1-2 segments, and then only punt to alloc if you need more than
> that. As the number of segments grows, the cost per request matters
> less.

isn't this the case here ? or am I missing something ?


