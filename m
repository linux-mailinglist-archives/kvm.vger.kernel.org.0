Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5BA3D20CB
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 11:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbhGVIll (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 04:41:41 -0400
Received: from mail-bn8nam12on2071.outbound.protection.outlook.com ([40.107.237.71]:19681
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231187AbhGVIlk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jul 2021 04:41:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UWtd0WOIVAj4TGzDa+3jsL7Xv0Z2ytypnBRwos3HfCdL06XU8dVBuapbmxK/kkmpXbhW1vTJRdlDOLtAZ1nSyW2jAehaxiEVoa6LWBeF5yq3Y28xVUpommTbWnFfxyu+qHddGmiOIgVV2rpVew5ECb9/OO/mo4p/oQSsAXN2JSpK27vAwLCI46b2K7s84w2FjQb4AqbBCPMCTjog56UgxOXUi4vgLgtgcf890SH6ZO09bsneH3u/D4l8y5GyUCZQJkBNsh1uywNKJof0Cjv5ZPdnlg8L+tI2FoyNBrA1xfo4Tf3+PLB5nqKMJH32fQKiFoa+mdzMre+rqKmVF2OSXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+TGgA2NyhK2Z6USgy9AbNzK5mA5JEL+wRR6WtBAFimU=;
 b=WvaiNoapJqW6J7PBPw3Z5b7Pl/obFmVkU5kGEuxyup+QeY9sOkTe+s2JJ11HfPK1s5zZOezma/sUPmjg9knyYM/fwtKtqwJev3wJijcG0VakYnfNfGtyKn4VegZJoZOZvc7RYYTWFk/2JuP9H72t7v2nGWI2313alVH6damiIunEOxij07261j+tztnDPNTbZLMtZAnVqK68/d3uX8TGDytoTt9JzShpUkDJmC/wriRZafhSJFjW/3u5H1LCuoWj+/nQgyO4bfbLbEh1lJfbbkZuAmc0BcFFHiILVJq18ZkXZAEw4lcxhvLIFNJe59Rzgc4KLKzh2r9GK2vLN969Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+TGgA2NyhK2Z6USgy9AbNzK5mA5JEL+wRR6WtBAFimU=;
 b=l0UE+n9+hNAXeuS+DgnFpbcNlrCgI+Q7NZpDfR0fcX9tKg/TdBqiZJ4BIpgK8+n4XIbuARqSiSCZhJ+MoFQwzThwSKuGsRJowAMms7xusPbWkHng/12zuT7fkWX3gc1GDEjx1eh5CkMaWJJ3T7pDozKtyBoail3cjX6nIFcSWdJ4EZ0qG8IPIsUXMZxjjENA63LGsCbRgXRa4ZKCGt6mJNDa3tzw9zVC9hCiA6Ph2MwajqMplr+HqBwhBUXTrTEAYnSxneCx/boMgm02v+xdZFFGfCYVvX42jlHXgIVd764iTsNldGrlhwhvhqPJvXWf7Bw5fUXls1zPpVxCwsyXYA==
Received: from MWHPR20CA0029.namprd20.prod.outlook.com (2603:10b6:300:ed::15)
 by MN2PR12MB2974.namprd12.prod.outlook.com (2603:10b6:208:c1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Thu, 22 Jul
 2021 09:22:14 +0000
Received: from CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ed:cafe::f8) by MWHPR20CA0029.outlook.office365.com
 (2603:10b6:300:ed::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend
 Transport; Thu, 22 Jul 2021 09:22:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT042.mail.protection.outlook.com (10.13.174.250) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 09:22:13 +0000
Received: from [172.27.12.30] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 09:22:08 +0000
Subject: Re: [PATCH 12/12] vfio/pci: Introduce vfio_pci_core.ko
To:     Yishai Hadas <yishaih@nvidia.com>,
        Leon Romanovsky <leonro@kernel.org>
CC:     <bhelgaas@google.com>, <corbet@lwn.net>,
        <alex.williamson@redhat.com>, <diana.craciun@oss.nxp.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <masahiroy@kernel.org>, <michal.lkml@markovi.net>,
        <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, <jgg@nvidia.com>,
        <maorg@nvidia.com>
References: <20210721161609.68223-1-yishaih@nvidia.com>
 <20210721161609.68223-13-yishaih@nvidia.com> <YPhb6o06fX+/FiTY@unreal>
 <0b8db422-749d-9d93-6b3b-957259f3d0cb@nvidia.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <b7c19435-5abb-c5fd-383c-d0ebad11db31@nvidia.com>
Date:   Thu, 22 Jul 2021 12:22:05 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <0b8db422-749d-9d93-6b3b-957259f3d0cb@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48cfaa95-c3a8-4d88-e5fa-08d94cf230db
X-MS-TrafficTypeDiagnostic: MN2PR12MB2974:
X-Microsoft-Antispam-PRVS: <MN2PR12MB29747B3958A5DA1BE343CF9FDEE49@MN2PR12MB2974.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ASvWfhW0Dms8jY9SkVLM4W42n/gnTYMzpWthtM4mJ+0vWFeqAQqVR1s+OaespoQb9vLa1lynKupNAEPfB3dFQORqVperknu2xDorDVPMc4oVECrHVENpHjigRxQEGE22ze3j3hp8jE0FNUSMqB4n9r92On39jDFNMcnrMqryNnE1JyYzPsYCmchl3tMZ94MxdNYwilm8+WLXAuOBmz7p1PW2Vuz4hKRX2zvFoahiPNwR5kyyTjxAbjp6tIupnemar/5AhPEoN3YH07ODg2koq5dZv+MAa3kn+5LzAs9PRe90dBkEbCzRAJtaNAA0BuF9t0ZALASjQgEXDZBKAi/FzkAPQsZ5tWBGO4mzKthNjF79m5ZndyO0c14HoHozLGGWKixBtr/ljJo9fauJeuyajCstWy4AqrA2AI8tGGOH+LZ9iehTNCy9exUwjW6BnBbeotUQgzZ/6ZFoq6LY4wf0QuZE4fQhNGZTGPwF5iTAknaapHdGZcIz8fKHjHtqxi2Smswx2gJXFbhrQQUHUPV9xxNX540akBOWewxpOGsS5x35bHyX9OiIaLOrQwEnN/8EO+wRx/EaT/m9fFvmYEQzVHTRGpcL9/fx1MZEju3yYSD3IY68lwl5qS8KdrK7POh3/HqzWLSjiDYE7EG6vKWLKL8jPSTKQuIOyZguQIfWcfgyf7BinJq5Zs2UCivtd1i8lV2/RB8w5f4aPfLtFsFFir+dAoHb5k+2ot/Wl5u4VjU=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(36860700001)(356005)(508600001)(82310400003)(36756003)(186003)(7636003)(36906005)(2616005)(16526019)(8676002)(26005)(53546011)(107886003)(16576012)(4326008)(83380400001)(8936002)(336012)(47076005)(2906002)(86362001)(31696002)(316002)(70206006)(31686004)(6666004)(54906003)(5660300002)(7416002)(70586007)(426003)(110136005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 09:22:13.4150
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 48cfaa95-c3a8-4d88-e5fa-08d94cf230db
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2974
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/22/2021 12:06 PM, Yishai Hadas wrote:
> On 7/21/2021 8:39 PM, Leon Romanovsky wrote:
>> On Wed, Jul 21, 2021 at 07:16:09PM +0300, Yishai Hadas wrote:
>>> From: Max Gurtovoy <mgurtovoy@nvidia.com>
>>>
>>> Now that vfio_pci has been split into two source modules, one focusing
>>> on the "struct pci_driver" (vfio_pci.c) and a toolbox library of code
>>> (vfio_pci_core.c), complete the split and move them into two different
>>> kernel modules.
>>>
>>> As before vfio_pci.ko continues to present the same interface under
>>> sysfs and this change will have no functional impact.
>>>
>>> Splitting into another module and adding exports allows creating new HW
>>> specific VFIO PCI drivers that can implement device specific
>>> functionality, such as VFIO migration interfaces or specialized device
>>> requirements.
>>>
>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>>> ---
>>>   drivers/vfio/pci/Kconfig                      | 30 ++++++++------
>>>   drivers/vfio/pci/Makefile                     |  8 ++--
>>>   drivers/vfio/pci/vfio_pci.c                   | 14 ++-----
>>>   drivers/vfio/pci/vfio_pci_config.c            |  2 +-
>>>   drivers/vfio/pci/vfio_pci_core.c              | 41 
>>> ++++++++++++++++---
>>>   drivers/vfio/pci/vfio_pci_igd.c               |  2 +-
>>>   drivers/vfio/pci/vfio_pci_intrs.c             |  2 +-
>>>   drivers/vfio/pci/vfio_pci_rdwr.c              |  2 +-
>>>   drivers/vfio/pci/vfio_pci_zdev.c              |  2 +-
>>>   .../pci => include/linux}/vfio_pci_core.h     |  2 -
>>>   10 files changed, 66 insertions(+), 39 deletions(-)
>>>   rename {drivers/vfio/pci => include/linux}/vfio_pci_core.h (99%)
>> <...>
>>
>>> -#include "vfio_pci_core.h"
>>> +#include <linux/vfio_pci_core.h>
>>> +
>>> +#define DRIVER_VERSION  "0.2"
>> <...>
>>
>>> +MODULE_VERSION(DRIVER_VERSION);
>> Please don't add driver versions to the upstream kernel, they useless.
>>
>> Thanks
>
> This just preserves the code for driver/module version that was in 
> vfio_pci.ko before the split.
>
> However,  this can be removed in V2 if we may need to have.

Right, we already agreed to preserve vfio_pci versioning scheme and 
we'll not add it to new mlx5_vfio_pci or future drivers.


>
> Yishai
>
