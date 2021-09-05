Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7681400ECD
	for <lists+kvm@lfdr.de>; Sun,  5 Sep 2021 11:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbhIEJUW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Sep 2021 05:20:22 -0400
Received: from mail-dm6nam12on2041.outbound.protection.outlook.com ([40.107.243.41]:42208
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229482AbhIEJUV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Sep 2021 05:20:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AwbkLjOejtSS5d9/GCrBzOYR47rBGM8bdwR0kepy07xtkirCHIKom4CQVXmAttPp631Jk0LOqvKibZuYrCxHo6GW22jOMzrx/WLFmiJ9qEOdgJ+XJbLtawVZs4aER8MDh/8x6+NVhzVrlt49KEwiZKWbkoUPo1ulFyImLI1lVZbtSOqynsDaRUjcs7TQqlX14FqhuAhI15b9ySdpsNDQlxzjmqmXsjpcPSr4SttMfNqN+QAEANvedz8ezwH7ZKuEWw6AdoCfAbNZ6pm61MCbDi41nU/HHWb3Ck0RswLSW4kNio5dcM6ZrwnmMH2nS+QXxQBicOrngEZjKUk3/xM8DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=tnTINZIgpdQ19oCCgiR0Uc56DggEfwzFYbtw8nI13vo=;
 b=QfzfDpCsjTzZv5zXXryyWuc4E/zvVCJWoW9p21X53n9pHQPR5S8j6U+Yu1RhTQBwLjhRpkJtnvVgVN7y1r53qvLYqf+Oac9gHDxGtpL+OPjiH0GW5mq1gFHqK4nEbs7RULXiv+wKrU+472Me7W2NJEtGVqKNHg+f2docQkfgakIsoyq+AK+RPP02z1lE+7Wi1/Wk7kwQrpnq8zy7flMHyweMrKl5lhLsSEUJvQiqaJcD1bBRkKWk2lRZqe8LfuZBvEUCcpnNpss9shT/DvoXQ+JTke+8lx77iiYSnxPZcNAABS7Ob86MJHWZ/22kUSo+axx6mgp/O4pjD1ITpR0ozg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=infradead.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tnTINZIgpdQ19oCCgiR0Uc56DggEfwzFYbtw8nI13vo=;
 b=lEI58h2aX9K8svWzoBsIT9+fSzb1mgo1rzVvH/dU9Vf4rmRn3/bEJ8AgCHPudd1C7q5Ap2V7y33N+5zs5tBq2ToIChfC3l7/Yur1RIT1rjYJjpNvFOIpnlohecgf7LLKPElK5Zzm3JlVcLgUac8FCgyabtTUGPrI2Qa0Zbv1hC5AHD85s2kmFJm+bjDxEh/IB9FPE7ZmMPCehdga0SFUQktyQRNBieCecWxMqRdI+U8E3bnKOdwJUp4bs5Ff147IyXjLyCqz3obXs/Sp7FqBa3TrwIsxxJD36hGiPghk8OMNJTQUy3fvoNbXDavnwk51SuSQRfnJDjDU/MUJN/aqsw==
Received: from MW2PR16CA0011.namprd16.prod.outlook.com (2603:10b6:907::24) by
 CY4PR1201MB0184.namprd12.prod.outlook.com (2603:10b6:910:1d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.21; Sun, 5 Sep
 2021 09:19:16 +0000
Received: from CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::d4) by MW2PR16CA0011.outlook.office365.com
 (2603:10b6:907::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.20 via Frontend
 Transport; Sun, 5 Sep 2021 09:19:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT068.mail.protection.outlook.com (10.13.175.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4478.19 via Frontend Transport; Sun, 5 Sep 2021 09:19:16 +0000
Received: from [172.27.15.146] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 5 Sep
 2021 09:19:11 +0000
Subject: Re: [PATCH v3 1/1] virtio-blk: add num_request_queues module
 parameter
To:     Chaitanya Kulkarni <ckulkarnilinux@gmail.com>,
        Leon Romanovsky <leon@kernel.org>
CC:     <hch@infradead.org>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <stefanha@redhat.com>, <israelr@nvidia.com>, <nitzanc@nvidia.com>,
        <oren@nvidia.com>, <linux-block@vger.kernel.org>, <axboe@kernel.dk>
References: <20210902204622.54354-1-mgurtovoy@nvidia.com>
 <YTR12AHOGs1nhfz1@unreal> <b2e60035-2e63-3162-6222-d8c862526a28@gmail.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <e4455133-ac9f-44d0-a07d-be55b336ebcc@nvidia.com>
Date:   Sun, 5 Sep 2021 12:19:09 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <b2e60035-2e63-3162-6222-d8c862526a28@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9cf913fc-487b-47bb-a241-08d9704e3bbb
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0184:
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0184D6738B2360A6833D35B8DED19@CY4PR1201MB0184.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J9bujj9KHguGppdRXXTYTeTfE52z/0eZE6nuME+h+hdeU/F/FR0B2L3ByAdFQLNc4MWL6JvJRZKTmroPvv6Hvazq36LBwezg7ZT+XGNS2r3uIVv4XRokFt8aeEiqIOpPaEwPjBF56KG79ISDoKFGJHSz3I5nOhRNHdTRE3wEL6kSn9zBNBrOkwovqna5qusixXlwZaGAF+M3U+yfKx495VYdQk7ArZueV83kM8IEnAjjBV+qO7yDfWRWmttoUdMlB2QtHiPdud2lElPDIb+8eH0syB1Q8G5bChUQ/fsjpZkG4MgK3OZQRIqtGhfTWZ/8XBrPrJQDEJmosU5V1ySqFBqaYMD1FaJEqGzVUeazFJFKbSXH8xV5Uln8LqEVyzkpnzgTe4SaSg/l14jWvgNqilXkNjtaH5Ze0oUTuS6L9Uq2SQcGS+BC1QIAIepFmRwaW0WwcacNR6TytCeRN0ZybDv/E/jrILAMnDtAS/lt6Bo3AXEhV4j/4KHFNkBaF97HYMRv0ny/ZT1FZSACPALosGXG+ThsTDsQ5xY8cAjQfb/uFpcc61+USalPb86RCDvjVxpXhkhw6syrjTw6JlVxV69Kmkl1zYjZflrQu86YTRFWgy13VrbDPT09yKyGZwVsFGp5RH42T+21FTz2ScRtALsWxWJgFnOpuLo60/nF+C9BLmDkLjphuN80IhbZV1a8edzWNjTM5qiuJpuLhYtM6/xa+MNtzu2VQ9z68K4njjM=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(36756003)(31696002)(36860700001)(16526019)(186003)(47076005)(26005)(8936002)(70206006)(5660300002)(70586007)(83380400001)(82310400003)(7636003)(356005)(54906003)(336012)(8676002)(110136005)(508600001)(2616005)(36906005)(4326008)(31686004)(86362001)(53546011)(426003)(16576012)(316002)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2021 09:19:16.0390
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cf913fc-487b-47bb-a241-08d9704e3bbb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0184
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/5/2021 11:49 AM, Chaitanya Kulkarni wrote:
>
> On 9/5/2021 12:46 AM, Leon Romanovsky wrote:
>>> +static unsigned int num_request_queues;
>>> +module_param_cb(num_request_queues, &queue_count_ops, 
>>> &num_request_queues,
>>> +        0644);
>>> +MODULE_PARM_DESC(num_request_queues,
>>> +         "Number of request queues to use for blk device. Should > 
>>> 0");
>>> +
>> Won't it limit all virtio block devices to the same limit?
>>
>> It is very common to see multiple virtio-blk devices on the same system
>> and they probably need different limits.
>>
>> Thanks
>
>
> Without looking into the code, that can be done adding a configfs
>
> interface and overriding a global value (module param) when it is set 
> from
>
> configfs.
>
>
You have many ways to overcome this issue.

For example:

# ls -l /sys/block/vda/mq/
drwxr-xr-x 18 root root 0 Sep  5 12:14 0
drwxr-xr-x 18 root root 0 Sep  5 12:14 1
drwxr-xr-x 18 root root 0 Sep  5 12:14 2
drwxr-xr-x 18 root root 0 Sep  5 12:14 3

# echo virtio0 > /sys/bus/virtio/drivers/virtio_blk/unbind

# echo 8 > /sys/module/virtio_blk/parameters/num_request_queues

# echo virtio0 > /sys/bus/virtio/drivers/virtio_blk/bind

# ls -l /sys/block/vda/mq/
drwxr-xr-x 10 root root 0 Sep  5 12:17 0
drwxr-xr-x 10 root root 0 Sep  5 12:17 1
drwxr-xr-x 10 root root 0 Sep  5 12:17 2
drwxr-xr-x 10 root root 0 Sep  5 12:17 3
drwxr-xr-x 10 root root 0 Sep  5 12:17 4
drwxr-xr-x 10 root root 0 Sep  5 12:17 5
drwxr-xr-x 10 root root 0 Sep  5 12:17 6
drwxr-xr-x 10 root root 0 Sep  5 12:17 7

-Max.


