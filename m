Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C55C73913D7
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 11:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbhEZJgD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 05:36:03 -0400
Received: from mail-dm6nam12on2060.outbound.protection.outlook.com ([40.107.243.60]:20755
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233117AbhEZJgC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 05:36:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RbMg7l7srFmf42kpmXGSb911cQrWPkvEeJvnoaaM8n9z0CBM9luUi3KoXh9GXAUEQfB3ckhzoFL+keZi4pw330gi3zn+3wonEE0kL7CND21xTLIVz8yfds/JgUK3vVD2hF7k5AAOo1XXJiQDtGSXG4fvywrjjJZf2VI6fcdUFmXz6MNbzmX30DakHBP0peRQauWWIxXw4vHjkHY1WAz0zNE+d/t7Hb+HGl0ZkJazZ3sW2YMwMdbmEhN+QP7NUfOyFAbEP17RVKm3nHtOIk220lbHxaPsXXQJFcfL9MVcPz2auZ9cTzCa0Lk8LnPTc4kSyhQDnegDxZkbRILzWJQXiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZfBjG40UsJnX1OzzHvPDGIYdQenGAzwC8oDfxtV7oM=;
 b=fxbFdQnlu+rnEHKyH3qK2DnqIhxRs8+nBSVr+uqKe2lCXKdNfsNysePUZiHl9GhBHV6fvKyAnW3zZ2C3P2tW+D35vQ62s8r710Sbzq/UdHXXRja2gPTMqmHiNUJ2igxRPSwIgwAqXJuLNI4of9SSFeu0dP6gQ+UWmcdFLTKVraKBobPDHO6jjE2ZIZN0KAJIk4sAtOjP6d+PM/t6c5TO3BCvarp8DPXMv9UYlOmPgrhUE0DWgjzHNllXxXlr7hrKC5DHQNQziOTyO85Bk0vhOx5fe0AXBPQlyYsAcivdYlVHtdn4le8eTTZN7hsvvxDDjGBNbKz+tDp62AoEEq2MYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZfBjG40UsJnX1OzzHvPDGIYdQenGAzwC8oDfxtV7oM=;
 b=f3xTfswjlpKuWe2sWuJsPycOWrwhEjZdrQ5GGg/Y+53qrf/+CKRY9PzidVBry7cDhbkaBC/R4BZv9sCUHni+HAw19GI8nP5BsQH+lCgedyLKaiylFaArOOalFL0l1D+7LkoLwwSXQN7xgrfrXfUAn+5GQtkI01o1kswg0t7nHTvOZUcRKEZnXf3Y9mLem++AFtIqIg3vB0CQ+nRcmPCvWBE6Sof0fRud0dXM141vcoAp8V06viPBJasroznbJBvtIKIwgEiZwvDTgkvdWHiJR0ylVNUq3wVhPPLtqHvg7lbTdvINvYBFtNAohW1SWtmMRK4q8uPEI5HK9MDP0yejRw==
Received: from BN9PR03CA0154.namprd03.prod.outlook.com (2603:10b6:408:f4::9)
 by MN2PR12MB3229.namprd12.prod.outlook.com (2603:10b6:208:102::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Wed, 26 May
 2021 09:34:29 +0000
Received: from BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f4:cafe::ef) by BN9PR03CA0154.outlook.office365.com
 (2603:10b6:408:f4::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Wed, 26 May 2021 09:34:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT068.mail.protection.outlook.com (10.13.177.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 26 May 2021 09:34:29 +0000
Received: from [172.27.15.108] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 09:34:27 +0000
Subject: Re: [PATCH 1/3] vfio/platform: fix module_put call in error flow
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <jgg@nvidia.com>, <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <oren@nvidia.com>, <eric.auger@redhat.com>
References: <20210518192133.59195-1-mgurtovoy@nvidia.com>
 <20210524133442.42dd2c46@x1.home.shazbot.org>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <ffd64fea-9032-224e-78bc-372569cb989c@nvidia.com>
Date:   Wed, 26 May 2021 12:34:24 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210524133442.42dd2c46@x1.home.shazbot.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a47d4f4-5113-4ef8-7dc4-08d92029763d
X-MS-TrafficTypeDiagnostic: MN2PR12MB3229:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3229AE841F69477228A27D3CDE249@MN2PR12MB3229.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BMZLnO8rh4o1AZ38+/zUQA7DDkFGw8W76diRRWZXdxGUaVlaqk7hE4COE58WAiKNtuF3O16j0/raKbFlBs+FdBXciYC2X9oi1ZUWA0cJgZGSg9SRCpnKXK53MaRJHetNs9XEIdCJC2egtzxjv6mughVGzkncW19qg4t934mr4M2OVlYcrmxRS1XEqEQQAGZ0SS0fW2vxaGVDr11F+L0lBQJbiK59CGoKdOFIEfbxoDwRrfLPUdIj0+whyd8Y8NH9Na4qzlOW9Y6IZEH0CIzH/pnl3HOPODp5VMK1MjwbVIx3j/IfBMPHBKpI8+LJ2tFsjzIoDBRsGlV6brN+Ngf/H3YlCz80oOE2BfM2/OIZb1pIP+DiI7KsWNwhAXQzV4NnQHoRQFeTB92Tthe9DNZ9dZYGEDLDCCRdLZOj2s1TnhBBSE//X/3s4G74TnV2Old+Yg3CdMCEYZvx6fpyMQq4ZpHrULknqCW/Xsy1Z4vgRwzpZPSRozHl3A8m/PQv8vOdC+VhQ7zUvj/t0SfgGzNIx/CnhE1/MPl/0c8Rb70CxLYpm+0e4Jh+53VyikqJj0sXESlmIWPWcG2HGenxWJyKqKyGM/pbsF7Lz7Sg8qA4sug0PZTOhO7z76UjyQVQGLbAd+8Y/1OCGjcQfvypiEP96A4NUNSQ1YvS2j334VJaefEZ/+vFcWuXkoL3AHLIZ2fX
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39860400002)(346002)(36840700001)(46966006)(478600001)(36860700001)(186003)(2906002)(47076005)(426003)(5660300002)(86362001)(8676002)(83380400001)(82740400003)(7636003)(356005)(70586007)(336012)(31686004)(6666004)(70206006)(26005)(16576012)(36756003)(54906003)(2616005)(16526019)(6916009)(36906005)(316002)(82310400003)(53546011)(31696002)(8936002)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 09:34:29.6546
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a47d4f4-5113-4ef8-7dc4-08d92029763d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3229
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/24/2021 10:34 PM, Alex Williamson wrote:
> On Tue, 18 May 2021 22:21:31 +0300
> Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
>
>> The ->parent_module is the one that use in try_module_get. It should
>> also be the one the we use in module_put during vfio_platform_open().
>>
>> Fixes: 32a2d71c4e808 ("vfio: platform: introduce vfio-platform-base module")
>>
>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>> ---
>>   drivers/vfio/platform/vfio_platform_common.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
>> index 361e5b57e369..470fcf7dac56 100644
>> --- a/drivers/vfio/platform/vfio_platform_common.c
>> +++ b/drivers/vfio/platform/vfio_platform_common.c
>> @@ -291,7 +291,7 @@ static int vfio_platform_open(struct vfio_device *core_vdev)
>>   	vfio_platform_regions_cleanup(vdev);
>>   err_reg:
>>   	mutex_unlock(&driver_lock);
>> -	module_put(THIS_MODULE);
>> +	module_put(vdev->parent_module);
>>   	return ret;
>>   }
>>   
> The series looks good to me.  This one is an obvious fix, so I'll queue
> that for v5.13 and save the latter two for the v5.14 merge window.
> Please do make use of cover letters in the future.  Thanks,

Thanks Alex.

I'll keep that in mind.

>
> Alex
>
