Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3DED409695
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 16:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346811AbhIMOx4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 10:53:56 -0400
Received: from mail-bn1nam07on2060.outbound.protection.outlook.com ([40.107.212.60]:28134
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346698AbhIMOvq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 10:51:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XwFVG3Xyd4gqLtnSVx7kt+8egEww66fLAJ/GzbhrJiNvKhMUPJ5L2oPWzaMyquNHRlD8jrVtZtlVb+K2OOPRp02yDFnXCBSrq9l8/vqlMlPAFkYfm7z2xsolYkjVL72BnTW/gDlBa3AYyBce/W7GWwi906StQ3EAyS3iUsDIeN6ZPM7MpZzlr5OhyIVG9hYXNAzx54GWk50FQ7+EBgIAwlOEARs+UUovRnzsSo1CvxCSdhbDgzSyOAHmmgYZqk6jKOauxXVii+cEeafxRl3mi+8NuD3tn8ct0HOa06wPnABrpW8OXWVGp2sJ2EDldJj0mPd0RtgU90zkf0q1BfcjDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=X/7PVLnpUiwifl8VCbtwbyRfLH6LjiLezykc1aYGpxw=;
 b=UkkT9aPoc6to++ugak69XwmNNPRnqgNcbCES4xNuQHzz2QzXsoDdOr5UX7j4Obvw5jYTBl2bwF3HWHVPQ9kMSjPH3LgHU9f3JY25A5b8+1TQXlHvYcanEm7ykfuRuFABrzcMZRl34/ijIEqbLDIo4C4EUUaE73gr4ZeVzkhFGo9wuoZXGHEXWwrp4JfiKj9M0s/2qA+0ddiCMyRKrXxbOMHAzpt/+7nHM6FDaoBL2B3ibBKig/6EBCiKP1BFyg5WdJ5pqlLniVSVhSb3ZIy96D7xXukQGg1RztdaN1RXtc/6gAfZRfLU561SFW6gaqKZ1Jk2gTev6cmdRCgu7ZrBLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=infradead.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X/7PVLnpUiwifl8VCbtwbyRfLH6LjiLezykc1aYGpxw=;
 b=DhHfNGLvY4KRFoiIyU4h+VjqVPH1a88Tl1QEuDkxEjqmVHxnFXI39pgWTO8JeB4xwhKXBgnZ54EVzkmWZD99ebhlUK4lqIzCs/3YM4cS41evCbWuSh1Z2Zv0ut835O8FG/m6rp+s/L60t6usjJLXyNeWdxPQebBWIc1ub0INTnSThVUD1jvTJceo4LilRoA4WgllwSiplD2pWILzDdcQuKArhlt4EDMndOZktMOkBVknYeegrh6aeHu4frzEdQhyeFojiwHM8TDRvJi73l9ZHgmtQiwN6INCs8e/ZycKtyoRulajmamGKhcDrtlLAcm85l/i0j4ejJHHn/noru3lkw==
Received: from MWHPR02CA0003.namprd02.prod.outlook.com (2603:10b6:300:4b::13)
 by CY4PR12MB1559.namprd12.prod.outlook.com (2603:10b6:910:c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Mon, 13 Sep
 2021 14:50:28 +0000
Received: from CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:4b:cafe::92) by MWHPR02CA0003.outlook.office365.com
 (2603:10b6:300:4b::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend
 Transport; Mon, 13 Sep 2021 14:50:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT045.mail.protection.outlook.com (10.13.175.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 14:50:27 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 13 Sep
 2021 07:50:27 -0700
Received: from [172.27.12.36] (172.20.187.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 13 Sep
 2021 14:50:24 +0000
Subject: Re: [PATCH v3 1/1] virtio-blk: avoid preallocating big SGL for data
To:     Stefan Hajnoczi <stefanha@redhat.com>
CC:     <hch@infradead.org>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <israelr@nvidia.com>, <nitzanc@nvidia.com>, <oren@nvidia.com>,
        <linux-block@vger.kernel.org>, <axboe@kernel.dk>
References: <20210901131434.31158-1-mgurtovoy@nvidia.com>
 <YTYvOetMHvocg9UZ@stefanha-x1.localdomain>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <692f8e81-8585-1d39-e7a4-576ae01438a1@nvidia.com>
Date:   Mon, 13 Sep 2021 17:50:21 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YTYvOetMHvocg9UZ@stefanha-x1.localdomain>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c0db69c-3c13-4d8b-9f51-08d976c5d37b
X-MS-TrafficTypeDiagnostic: CY4PR12MB1559:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1559404E9A1406240ADB1167DED99@CY4PR12MB1559.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4WBafKxoj7oae40fWxWE1gKLMDgjV9TZmK22OGtVy+O8meCzFpOm5yH6pcj8povG6n1/XtbV6p+fY7Ieu4Eb9NV/HeED9WHhZnn8ptLsOd8wiHMZ8yhPGK6Ef4nXNpKwdJAm2HX9km0bcFQA8mfV0fZv6ai9Fu6UX7YB69V7lhG9IbPhRp9VLH/a6Iz5rHdu6YbSEDr+0rmc0Jx9cjBx/QNn7a4ylmHbExMnLWq7GRubypc8pia2txjTO0zpBywBNT0GR4lLCFTrFwf+cVeRiCxQQs8+qV3ishy5DpUGRTTO1vjBupWmnOspZlhC3bbglT0iX9YetvMP5G5g96EeKMV948ZhJbGxV2oUQcQRBgjTzLi0tX8I8eFY+NXnCITC5EuPsLeCulu0JtDCyYS2048luv3yRO6qz4uaV96hRJ1NBXVYSNOQLTL9EzSMNLE3+En/vjWWGF1p81Z8RIbrFd25Qwdh2AB8hxCrx7rdha9hW1V6UZuh6ut7ifDKXqtbEzWRWjCU7STNl09nLSAQR9GVgouNNhgmseidok1ciZpyoeeL2c1d49hTms2i/WkTkerH+RfuLrUI7Dyw/3AoUuWGUCe5Vd18Q53yL8S43fBrON3SDHBhfQ9WN5c8L4fqrw6eQl7sBv9F091PFI06ieWeA6/yLS5/UlMl7CMQHv4E4iF56VAQJ5sa6pBQGzl4e+X2r6FaYNK8TvkvCh/VKH0BuXgO+ZBt6QY7FIR+nJD5nKJ2oY8JGDdZmNOVhrG3FkqN/4RIDxok5jkssOFUm2xLs7UFs2LJME9fyunag7cmvTmEReuZ9ybowUKq+157
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(39860400002)(376002)(46966006)(36840700001)(82740400003)(2616005)(36860700001)(16576012)(6666004)(47076005)(54906003)(83380400001)(966005)(8676002)(86362001)(36756003)(16526019)(31686004)(356005)(4326008)(82310400003)(5660300002)(6916009)(7636003)(53546011)(478600001)(2906002)(426003)(31696002)(8936002)(336012)(186003)(316002)(70206006)(26005)(70586007)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 14:50:27.7225
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c0db69c-3c13-4d8b-9f51-08d976c5d37b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1559
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/6/2021 6:09 PM, Stefan Hajnoczi wrote:
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
> I ran fio randread benchmarks with 4k, 16k, 64k, and 128k at iodepth 1,
> 8, and 64 on two vCPUs. The results look fine, there is no significant
> regression.
>
> iodepth=1 and iodepth=64 are very consistent. For some reason the
> iodepth=8 has significant variance but I don't think it's the fault of
> this patch.
>
> Fio results and the Jupyter notebook export are available here (check
> out benchmark.html to see the graphs):
>
> https://gitlab.com/stefanha/virt-playbooks/-/tree/virtio-blk-sgl-allocation-benchmark/notebook
>
> Guest:
> - Fedora 34
> - Linux v5.14
> - 2 vCPUs (pinned), 4 GB RAM (single host NUMA node)
> - 1 IOThread (pinned)
> - virtio-blk aio=native,cache=none,format=raw
> - QEMU 6.1.0
>
> Host:
> - RHEL 8.3
> - Linux 4.18.0-240.22.1.el8_3.x86_64
> - Intel(R) Xeon(R) Silver 4214 CPU @ 2.20GHz
> - Intel Optane DC P4800X
>
> Stefan

Thanks, Stefan.

Would you like me to add some of the results in my commit msg ? or 
Tested-By sign ?

