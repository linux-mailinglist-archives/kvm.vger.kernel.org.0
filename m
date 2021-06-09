Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76453A1059
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 12:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238126AbhFIJmr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 05:42:47 -0400
Received: from mail-dm6nam12on2063.outbound.protection.outlook.com ([40.107.243.63]:38305
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234720AbhFIJmr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 05:42:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DEiHvIr/YrH0bvWzfAYWh0JtFTd7y3LvWxElM+p8FKVBulb3PRui0GYslWIC0MgtRTrlMJ5IUCfhGbo0hKbfBpZwBvIp7kpCR9QJCJqmWw+Bdfa2rGT+4SiMJWuHTjBkaHH0brWCsTAcduDKPlShfeK3uZO8gv7mnXtHGXjZ6omqywX9kYVuPsqxO/200CgmNNyENTsNdn+FDX/Y3YE8oFxly3hcavPSpUcuHvqhNLrwODt5CsUFVpjGygdUE3iHziZYeS2nH4M+i/rhtzRo+kh0oZMCMjEPvQJ59dNpW+qp/OLomWjVLl8fC//so93WK4QTgepOOM3waKwKb4Aciw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SPYRxarNN4+n8zFERWtc/2PKvQJzx5hQf1yUUmaI/dY=;
 b=Xq+x20Sb6qtTCoqPIt5CmVNaFWDfo8ube4xxX1TeKS7oOxGLLI29a719I2MllxwbM1hweZOtA3EfnxDy4jix9GPhjrnO4kpjd/vAH5aAdSGciix6iauwbKCKPbvJmlOACFFOeJWWV8pB3Nuiwh/pGYc5xL5FrANQUL59qNCYhW+M2I38Zg2T4mlsv9eSYZVgWPG1Unz285XioKeIlrINMFTwcy6Rl7VhYexJIYRS0bi4oZUkK6qpmklpAlYRtX1ZrZH9Bx08+MLZ3A9V1lGRofRNBjw7CJhyuoo2RV/n8bu82xYoZ2dLHB4KFGIkmqtqBtOiaNHSHVVwIhLr7c3sXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SPYRxarNN4+n8zFERWtc/2PKvQJzx5hQf1yUUmaI/dY=;
 b=hCKhsjrZDcXiM7OQ8PyIXOKBYAUEBbJyxtwBLEG6/ambKOw+XJMB2RCM07Alm3kMOOmPUBDRj3hKe7fz3d8WRaEBp13wCI+YMFQOj6S2kPo1IfMFZK1KwgM5juyDA9t2Ip/tnpYrZMppow1v4dat21xTR/K9Oz7sEocYLPp/26yokqM/R69AcYRS17wp+OJDXTcgWAU4a+Q+0vza5rbwqygkqnK+97ZY+FkXXV7Doxxkps8BrjHmp7xtMtTM3i3uqjfJ0SOkSpUYQOPADm6gY7YqW3B1Gsuok4iuY0kcRyaP1RA1Mr/wnAs4H4UExArjNxKXCE8dK6zJtikVoKMeJw==
Received: from DM6PR12CA0031.namprd12.prod.outlook.com (2603:10b6:5:1c0::44)
 by SN1PR12MB2509.namprd12.prod.outlook.com (2603:10b6:802:29::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Wed, 9 Jun
 2021 09:29:36 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1c0:cafe::9e) by DM6PR12CA0031.outlook.office365.com
 (2603:10b6:5:1c0::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend
 Transport; Wed, 9 Jun 2021 09:29:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 09:29:35 +0000
Received: from [172.27.14.222] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 9 Jun
 2021 09:29:30 +0000
Subject: Re: [PATCH 10/11] vfio-pci: introduce vfio_pci_core subsystem driver
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jgg@nvidia.com>,
        <aviadye@nvidia.com>, <oren@nvidia.com>, <shahafs@nvidia.com>,
        <parav@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <kevin.tian@intel.com>, <hch@infradead.org>, <targupta@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <liulongfang@huawei.com>,
        <yan.y.zhao@intel.com>
References: <20210603160809.15845-1-mgurtovoy@nvidia.com>
 <20210603160809.15845-11-mgurtovoy@nvidia.com>
 <20210608152656.5aa4cfa3.alex.williamson@redhat.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <2da8a815-17a6-fe4b-fe5b-12ec497efee6@nvidia.com>
Date:   Wed, 9 Jun 2021 12:29:27 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210608152656.5aa4cfa3.alex.williamson@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aeca3b94-e86f-4a7f-43cf-08d92b2918c6
X-MS-TrafficTypeDiagnostic: SN1PR12MB2509:
X-Microsoft-Antispam-PRVS: <SN1PR12MB2509601B48123B4238CB80A6DE369@SN1PR12MB2509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YEztPKvVYXUMNqmw/M3OKbxSSKZShy8TmPsmu+1F6j/UQC9S3vKA048beuFfbuQw0zAt0l9pr9Ik/JLJKCVDA/z8/Uafr775rpnYKbvESh2nZ4BZXO9NSdsBtBa4LTxJWAzKkGjdqzvPot6rPRgBc8LL1SlPq+sLUSlh9cVHUo9dcq/odmYk6/HKyBgfqWRPs70PWiKPIvGXDCP4EZLfsA8BNUma6N4XiVsNq+xb+3XJ7St4+51naBFeJKD1CL8erR15sOOkEkZv1/g9MxapBVtpB1DtH59vTKwYJ3WpzzGy3UebUISrjL46FEAwdv48LG2evosI9BHtsX6Loh4XTzulndc020iDYipI2U8/FcCy9m6wmsdmtYGyoAiI99Lq7p+EhGltO9CjP3YbjwewTy1HnRC3EhEEw9YmtUU3Ei7EkDaXO32r0qTV46wPYcBcF0Yrz42pimk6w2hK5E9aH7xKq7a+TOgM8jYxVPGwSmHRcZOpztOckIUkV7fTsfuissImY/LmGKAIU8xWKlm2czpNaGNeHiIxFic8kaE/jgUZNGqX4YSu22pZ1RKNy2uCORZFII+m53NSKLU+RYAyo9ggXrvTKY7XwnumN3EitGvbp3cIawHswYe30sEpLUsrV+qEW9+GdcYjvWLnvj3loXZxEGJ+Xe+oVqlqjiD6udSWsdgeHaNr33PbTMOQ6Iut
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(376002)(396003)(36840700001)(46966006)(8936002)(8676002)(36860700001)(36906005)(2616005)(426003)(316002)(16576012)(478600001)(16526019)(336012)(82310400003)(47076005)(31686004)(36756003)(82740400003)(26005)(356005)(186003)(54906003)(7636003)(53546011)(70206006)(86362001)(70586007)(2906002)(31696002)(6666004)(5660300002)(4326008)(6916009)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 09:29:35.7926
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aeca3b94-e86f-4a7f-43cf-08d92b2918c6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2509
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/9/2021 12:26 AM, Alex Williamson wrote:
> On Thu, 3 Jun 2021 19:08:08 +0300
> Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
>> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
>> index 5e2e1b9a9fd3..384d06661f30 100644
>> --- a/drivers/vfio/pci/Kconfig
>> +++ b/drivers/vfio/pci/Kconfig
>> @@ -1,6 +1,6 @@
>>   # SPDX-License-Identifier: GPL-2.0-only
>> -config VFIO_PCI
>> -	tristate "VFIO support for PCI devices"
>> +config VFIO_PCI_CORE
>> +	tristate "VFIO core support for PCI devices"
>>   	depends on VFIO && PCI && EVENTFD
>>   	depends on MMU
>>   	select VFIO_VIRQFD
>> @@ -11,9 +11,17 @@ config VFIO_PCI
>>   
>>   	  If you don't know what to do here, say N.
>>   
>> +config VFIO_PCI
>> +	tristate "VFIO support for PCI devices"
>> +	depends on VFIO_PCI_CORE
>> +	help
>> +	  This provides a generic PCI support using the VFIO framework.
>> +
>> +	  If you don't know what to do here, say N.
>> +
> I think it's going to generate a lot of user and distro frustration to
> hide VFIO_PCI behind a new VFIO_PCI_CORE option.  The core should be a
> dependency *selected* by the drivers, not a prerequisite for the
> driver.  Thanks,

I'll fix that. Thanks.


>
> Alex
>
