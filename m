Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F79336F19
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 10:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbhCKJoy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 04:44:54 -0500
Received: from mail-bn7nam10on2051.outbound.protection.outlook.com ([40.107.92.51]:60640
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232124AbhCKJou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 04:44:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GcsyNRAAdgdSeXCWJ6OL8mdhRXGxSkDRnHUYzqct4l1fwq41b//AHE6IUFz8rR0XzeFw1j/ebLeyIiKiZ8hIehh3XfdIJ/Tykjbud45x3WNkNplGxcqPJX7D5Q9piJvlYjV9UswQjrmOVpbFX91I7/0x5JHOmPp2W3CD4Fat/HKZ3qaUtLt9YuRw1Yx4HN791OFkXc60WlX7dmuf6V3d5xv/axxx4JFIKSv5x9F68It/irDfW/cm3AVh/tHh48Smxbn4NfyOvrRUv3kz/zeHorSYkIdWllj05Z/HeVi/ETdCi18wGVj9Y2Me/e8VeTrPJGIGUfK3luDgnTh7y7wbPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6r1QUTJSgO8GhMMJOlDvAcvMkgjfT/xkp0mShrQSZBs=;
 b=mz1acB+/PZZDTwQetlwM+PLOMD8AT7vy9UzhBzq1XG8pXV7BgLvwX494MJMOMOEBL+m+CIUhmA7lQLem9IJRswFtXsN3LpwwMduM1Ej9pmgzexoOFExMLTMsJSvV54kiIst3JuIXCpO9D7CyDowsRv5kWcXvfCSDMysWb5CDEDZkW7/aQ5yO5DuBVQT9tC49lbbsRGJPJYdLrrzv/rrWUG6DFtIrwPkWpJxUfJMUhyHKrZ18cfD+zGJ6Lz8z75s9GzGb9PY+UCiHUu5U0JVALHhy1fp1i8YZnMYwpZurGwEYqGs7jZzfjtHuSXbJ7f0sxlG1C41xYom+GwxzQNwY/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6r1QUTJSgO8GhMMJOlDvAcvMkgjfT/xkp0mShrQSZBs=;
 b=tM5Ox8zpUFVEKqdCMoeSr+/MWMQ96NzGPiCwsUf+MJuzNkgETpLkyeJnfXx1HuA7WwMpJDr32+suT47c11hCN0Gr02rVsM9kp8q4pxUboQnI6iXLXTHSf0wU0l2h0RWe+OE2/dr9vZLFqgjbVRSo0D4v9W+4lmpvCSQpwsG8MSVwUXxm5WwT4qZTsOowwW0kJcOpGmK6vVYu7jawwak+N1VfWrJ7hhM4OUkHxWrhnjoYQVqWyAt1gwl8vG7lO5wSV8LUz+9oyXJZ+vTEiRGp6PlwTYPxahRGPv7X7k0GIwRVosHYGdzJ2s3bVbylF6+wTuJcifaFJdCoZVwufxLrTQ==
Received: from BN6PR21CA0001.namprd21.prod.outlook.com (2603:10b6:404:8e::11)
 by MN2PR12MB3470.namprd12.prod.outlook.com (2603:10b6:208:d0::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 11 Mar
 2021 09:44:47 +0000
Received: from BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:8e:cafe::8) by BN6PR21CA0001.outlook.office365.com
 (2603:10b6:404:8e::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.3 via Frontend
 Transport; Thu, 11 Mar 2021 09:44:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT063.mail.protection.outlook.com (10.13.177.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 09:44:47 +0000
Received: from [172.27.11.33] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 09:44:41 +0000
Subject: Re: [PATCH 8/9] vfio/pci: export nvlink2 support into vendor vfio_pci
 drivers
To:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <mjrosato@linux.ibm.com>, <hch@lst.de>
References: <20210309083357.65467-1-mgurtovoy@nvidia.com>
 <20210309083357.65467-9-mgurtovoy@nvidia.com>
 <19e73e58-c7a9-03ce-65a7-50f37d52ca15@ozlabs.ru>
 <8941cf42-0c40-776e-6c02-9227146d3d66@nvidia.com>
 <20210310130246.GW2356281@nvidia.com>
 <3b772357-7448-5fa7-9ecc-c13c08df95c3@ozlabs.ru>
 <20210310194002.GD2356281@nvidia.com>
 <7f0310db-a8e3-4045-c83a-11111767a22f@ozlabs.ru>
 <20210311013443.GH2356281@nvidia.com>
 <d862adf9-6fe7-a99e-6c14-8413aae70cd4@ozlabs.ru>
 <20210311020056.GI2356281@nvidia.com>
 <73c99da0-6624-7aa2-2857-ef68092c0d07@ozlabs.ru>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <d2c32828-3417-1872-6451-2450e6fa763d@nvidia.com>
Date:   Thu, 11 Mar 2021 11:44:38 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <73c99da0-6624-7aa2-2857-ef68092c0d07@ozlabs.ru>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b8966b9-4317-40f6-ff34-08d8e4724f14
X-MS-TrafficTypeDiagnostic: MN2PR12MB3470:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3470B9143B88EDA43C31B568DE909@MN2PR12MB3470.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LcFKGbEOuL7iAHWrTEJe38pVLLYb3jDtRuSAMRW1zwwmlCjIa4f+GZ9cd1ZEbf0+CNc6NIKOhAWLRgMaME4ovf8aqG6zR3hzr4Nr9cymL4Wg4v+ATV0XKqn+dHd3uA/X4JGTmBaRtg1893UIJci2i143Ws2+dcLNwaRiBJiEpTcOIvhFVqLRG8sCzHk+Ou6RBRs64tsuf1q5xCWf6GdjQXViwRoNWBXt/ZveIp0jz1xxddxut93UNM/6AYj0Ni8bR6+iDl0+CMAItanvrzBwPluMNdXJH1qxN0feXfjpOrWrWNarFL2SPaVzaYDyIvQoLCzOR/J5P/v5+Qsrny4rPv2udtAdMq3exjhFLXRhgRYUT5St3ceBSCJdOUvfpRL8p9O9fk6cYULfOVGO8c28x0PCY+G9qCvRJSBgmcg7znBY+LFjdHerk2uPSYcFeYhUjjS4Il9kxieTIP4af0VBQDRHDtaFM0W/dYh2t6u8NAqLqPMqiNMpdUwGgE3Rb/4LYz+rsMU+Sva5/C1gUqwBuc0+HpCEbQWQFvlSK9+mKSOmX4Ruq82JHjNRFwEwe/O3HUjB2yggyyPXzZQLXyEbnU82phyi9a9oIsnpZGUeRSjOWD9AmxsP6agKUc0HtQqJZJO5rxHZeTU0xGwrrKjiEU2rej9Flta6nrgcNXJWlLRe7C/RX2vbTyjxpGtOczjDXiD7Pvd08tN9majKAGM3GL1NOl84St7Gvob17XM8JT3r4LrblzMKGlLP7h5upxsT
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(136003)(36840700001)(46966006)(8676002)(36860700001)(5660300002)(34070700002)(86362001)(110136005)(70586007)(6666004)(356005)(70206006)(2616005)(53546011)(16576012)(31696002)(336012)(36756003)(36906005)(82310400003)(7636003)(47076005)(6636002)(4326008)(31686004)(8936002)(478600001)(426003)(2906002)(82740400003)(316002)(54906003)(26005)(16526019)(186003)(21314003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 09:44:47.5526
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b8966b9-4317-40f6-ff34-08d8e4724f14
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3470
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/11/2021 9:54 AM, Alexey Kardashevskiy wrote:
>
>
> On 11/03/2021 13:00, Jason Gunthorpe wrote:
>> On Thu, Mar 11, 2021 at 12:42:56PM +1100, Alexey Kardashevskiy wrote:
>>>>> btw can the id list have only vendor ids and not have device ids?
>>>>
>>>> The PCI matcher is quite flexable, see the other patch from Max for
>>>> the igd
>>>   ah cool, do this for NVIDIA GPUs then please, I just discovered 
>>> another P9
>>> system sold with NVIDIA T4s which is not in your list.
>>
>> I think it will make things easier down the road if you maintain an
>> exact list <shrug>
>
>
> Then why do not you do the exact list for Intel IGD? The commit log 
> does not explain this detail.

I expect Intel team to review this series and give a more precise list.

I did the best I could in finding a proper configuration for igd.


>
>
>>>> But best practice is to be as narrow as possible as I hope this will
>>>> eventually impact module autoloading and other details.
>>>
>>> The amount of device specific knowledge is too little to tie it up 
>>> to device
>>> ids, it is a generic PCI driver with quirks. We do not have a separate
>>> drivers for the hardware which requires quirks.
>>
>> It provides its own capability structure exposed to userspace, that is
>> absolutely not a "quirk"
>>
>>> And how do you hope this should impact autoloading?
>>
>> I would like to autoload the most specific vfio driver for the target
>> hardware.
>
>
> Is there an idea how it is going to work? For example, the Intel IGD 
> driver and vfio-pci-igd - how should the system pick one? If there is 
> no MODULE_DEVICE_TABLE in vfio-pci-xxx, is the user supposed to try 
> binding all vfio-pci-xxx drivers until some binds?

For example, in my local setup I did a POC patch that convert some 
drivers to be "manual binding only drivers".

So the IGD driver will have the priority, user will unbind the device 
from it, load igd-vfio-pci, bind the device to it, ends with probing.

For now we separated the driver core stuff until we all agree that this 
series is the right way to go + we also make sure it's backward compatible.

>
>
>> If you someday need to support new GPU HW that needs a different VFIO
>> driver then you are really stuck because things become indeterminate
>> if there are two devices claiming the ID. We don't have the concept of
>> "best match", driver core works on exact match.
>
>
>
