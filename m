Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB30400F47
	for <lists+kvm@lfdr.de>; Sun,  5 Sep 2021 13:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237818AbhIELSL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Sep 2021 07:18:11 -0400
Received: from mail-bn8nam12on2083.outbound.protection.outlook.com ([40.107.237.83]:12384
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237800AbhIELSK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Sep 2021 07:18:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mktP191P25m+pUa0VWfsVVN4bgxHzTMcSQUVmpH6hex8T3EjI/M6CfPmHA6yXXf596n9Zt9ss7VzVLU1JiW9+eDDxPHFuVL5+oAzYutK+kLwo3y66Zge9b92zjheGd+Afh+hGJ16Df1oyp13H/JuTtSYreMKZ221sl5iBd/prpPb/NeKf6eflzxM3RdeVdo+5lzEvuvaiDv7RcmWoKC/oJB52lgCreQ5ryExCtRq/fryE6+mivR50TUpbp63b5kmMGIqSwB64ha9qK0ozooqpswS1o3b6Z2oqfnCNC2V0ghP5ypg3yIvHOukmJowlI8nPyh0JJcYbrrJ96yqoJBBlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=9s+hE3KQJd31nH1iUjToBFwiR3orso/6Wdrwq2trmPQ=;
 b=nY2q8YIdCIhGnJ3o/KBTMZ6RJWqfcIjpFxYP6wJcLfa76JAZgvOhkGA9mHJs8iw4yHvtH1AT0RFT0AVv4V9YF+JJ4WGfnPNrwqs3fWiiTfiXXDoL8iuEfg3ZYY8va8FcijXKSSbrJQqG6E6kEiq7JeGiNjvD5+JqP+jQfruEzhkEhSQoy1GpLhex2RMndXYRXDDuSf0VYSHGPAAYMcZUDFcsoNtKRNBMHtSvRwNvXZIr+x1lGYEyjiFsBY+FovzJxibkVyUei+PEmeJ8lEJSopGWQ/tZsAw+RhqDAKEfrQJjxTLxhXkKQV6rHPkUMnyHLvrOn5oKYxWFnmweah3zXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=infradead.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9s+hE3KQJd31nH1iUjToBFwiR3orso/6Wdrwq2trmPQ=;
 b=kqF15zutJ9h7DTgIvrcING5J2dFtEaL7d3+/KMgcENHQWu6uNWqPgF54yIBufHoLaL+CIA0L0T6DiQvB3gEfzi4RCPzrU6QQWsjshdRD1RNORhJIc7nAKiiGKgXmdqi1E+dX3NJTp48Z9hBBeErRHLLwuDvk6ROTW8/TgWu0MDyEDWV0x7vK+2ucJNOAX/LN/Yrlo3W8eN8B05vxBY9Yj5kWWjCMc8ikDL1zEEkLYbu/6dhVOxtH0HytWmEA7Y0gvul3ELTf/E/VX2UjofteyTJGhRQuj7/Nl4CH6Fmnf8whCdjheZPPYmb/jBEikRT30oBXCgYjk7hwhiCjB3cwjw==
Received: from MWHPR21CA0068.namprd21.prod.outlook.com (2603:10b6:300:db::30)
 by DM5PR12MB2534.namprd12.prod.outlook.com (2603:10b6:4:b4::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.21; Sun, 5 Sep
 2021 11:17:05 +0000
Received: from CO1NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:db:cafe::5c) by MWHPR21CA0068.outlook.office365.com
 (2603:10b6:300:db::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.1 via Frontend
 Transport; Sun, 5 Sep 2021 11:17:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT023.mail.protection.outlook.com (10.13.175.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4478.19 via Frontend Transport; Sun, 5 Sep 2021 11:17:04 +0000
Received: from [172.27.15.146] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 5 Sep
 2021 11:17:00 +0000
Subject: Re: [PATCH v3 1/1] virtio-blk: add num_request_queues module
 parameter
To:     Leon Romanovsky <leon@kernel.org>
CC:     Chaitanya Kulkarni <ckulkarnilinux@gmail.com>, <hch@infradead.org>,
        <mst@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <kvm@vger.kernel.org>, <stefanha@redhat.com>, <israelr@nvidia.com>,
        <nitzanc@nvidia.com>, <oren@nvidia.com>,
        <linux-block@vger.kernel.org>, <axboe@kernel.dk>
References: <20210902204622.54354-1-mgurtovoy@nvidia.com>
 <YTR12AHOGs1nhfz1@unreal> <b2e60035-2e63-3162-6222-d8c862526a28@gmail.com>
 <e4455133-ac9f-44d0-a07d-be55b336ebcc@nvidia.com> <YTSZpm1GZGT4BUDR@unreal>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <5aada544-356f-5363-c6e4-6885e9812f82@nvidia.com>
Date:   Sun, 5 Sep 2021 14:16:58 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YTSZpm1GZGT4BUDR@unreal>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f05d723-6948-422d-4328-08d9705eb0cf
X-MS-TrafficTypeDiagnostic: DM5PR12MB2534:
X-Microsoft-Antispam-PRVS: <DM5PR12MB25346D14B7F7A4987E431729DED19@DM5PR12MB2534.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rG8ZckvI+u3+mh/Twtx/nKxcHgvl6MfL/QAJbo7Hs829RwyJqeNOPqqy2Iul7Tf1KhoAdPu9P91TlEOFeZNm6+XStO9VHd3e7UbFOtJKG5fhdJDWb/q2FGiTMoOA6vcKqhBe5PXRysTrWFTEuPNtYn94KArCQSctsmHTb1m1azPehVCChsTg8wfg47AIxjfG92eURS645GYOcQdVNbVFf5uWIoJoWnJXV1s3c+IZJXnJHm8VN5IOr8iBHFY4M20tGuPPFyJtz6yj4tfUp7ThN+d0Lgu4CfCxDaxGCnNOd8cmlFD7snOYJyse01aZSvbl8N19fm4Gh8U1ZNQ6Yq+TFrp44/kw7aRCTEJoLoeSWBJOLrPfJ9J77QguHj8t03lvdDKDow78xzEgt0RG8n1tGYeWYHIIGURLuUQPNWo+LHxKrFN4vdlQKJy3Vg6fe/alniHu8UIt+hc81WXVZL52s+TXXpsTss5lQLIpl5fkR5JuzOSZIOLUGnmdDi+iWbkekDz/YDTBdXI6uP3Avx/ew8k+hysY/xMC1YASzZjxD6v4N+S5AclXqaKQjdcsuL00B22Dkg0fveMLXFfhEqMKJUgp/8JHoKzWW60W4ooNw/xpNW6sPaRO7/CyICICJEPqQKuTkjFRLGdu2riIL/6n1dr4jSaqaLXLZbYPAaPZ4cO1TK+JDC0BfE578A+P6XuHir0n7ImRCAkIgXO8551Ieh2VBBMq4kxUQS5bHr8x9D0=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(6916009)(47076005)(82310400003)(186003)(316002)(31686004)(86362001)(16576012)(5660300002)(4326008)(31696002)(54906003)(36860700001)(7636003)(356005)(8676002)(8936002)(2616005)(426003)(2906002)(508600001)(16526019)(36906005)(83380400001)(336012)(36756003)(70206006)(70586007)(26005)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2021 11:17:04.4096
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f05d723-6948-422d-4328-08d9705eb0cf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2534
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/5/2021 1:19 PM, Leon Romanovsky wrote:
> On Sun, Sep 05, 2021 at 12:19:09PM +0300, Max Gurtovoy wrote:
>> On 9/5/2021 11:49 AM, Chaitanya Kulkarni wrote:
>>> On 9/5/2021 12:46 AM, Leon Romanovsky wrote:
>>>>> +static unsigned int num_request_queues;
>>>>> +module_param_cb(num_request_queues, &queue_count_ops,
>>>>> &num_request_queues,
>>>>> +        0644);
>>>>> +MODULE_PARM_DESC(num_request_queues,
>>>>> +         "Number of request queues to use for blk device.
>>>>> Should > 0");
>>>>> +
>>>> Won't it limit all virtio block devices to the same limit?
>>>>
>>>> It is very common to see multiple virtio-blk devices on the same system
>>>> and they probably need different limits.
>>>>
>>>> Thanks
>>>
>>> Without looking into the code, that can be done adding a configfs
>>>
>>> interface and overriding a global value (module param) when it is set
>>> from
>>>
>>> configfs.
>>>
>>>
>> You have many ways to overcome this issue.
>>
>> For example:
>>
>> # ls -l /sys/block/vda/mq/
>> drwxr-xr-x 18 root root 0 Sep  5 12:14 0
>> drwxr-xr-x 18 root root 0 Sep  5 12:14 1
>> drwxr-xr-x 18 root root 0 Sep  5 12:14 2
>> drwxr-xr-x 18 root root 0 Sep  5 12:14 3
>>
>> # echo virtio0 > /sys/bus/virtio/drivers/virtio_blk/unbind
>>
>> # echo 8 > /sys/module/virtio_blk/parameters/num_request_queues
> This is global to all virtio-blk devices.

You define a global module param but you bind/unbind a specific device.

Do you have a better way to control it ?

if the device is already probed, it's too late to change the queue_num.


>
>> # echo virtio0 > /sys/bus/virtio/drivers/virtio_blk/bind
>>
>> # ls -l /sys/block/vda/mq/
>> drwxr-xr-x 10 root root 0 Sep  5 12:17 0
>> drwxr-xr-x 10 root root 0 Sep  5 12:17 1
>> drwxr-xr-x 10 root root 0 Sep  5 12:17 2
>> drwxr-xr-x 10 root root 0 Sep  5 12:17 3
>> drwxr-xr-x 10 root root 0 Sep  5 12:17 4
>> drwxr-xr-x 10 root root 0 Sep  5 12:17 5
>> drwxr-xr-x 10 root root 0 Sep  5 12:17 6
>> drwxr-xr-x 10 root root 0 Sep  5 12:17 7
>>
>> -Max.
>>
>>
