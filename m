Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00EA636A0E3
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 13:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233420AbhDXLaM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Apr 2021 07:30:12 -0400
Received: from mail-co1nam11on2051.outbound.protection.outlook.com ([40.107.220.51]:20815
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231203AbhDXLaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Apr 2021 07:30:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jFY3N4OlaFdwEJjeOA9NAQmRcPuyT6ugX0h7GBURUNsnhCa9oNy4Ig2whUotGNbq9s/wh7bzVQOyHYsjd6g3p7I/gqIJ0Mr6iijjYIKNMY+D6rqHPjx9wC0YQDzY2I+QOJGW3zS1vDdfFT2VUNbietXJgbSyKdxEgfUP5blsCO7M2XOnqONd2o6WvCNQjjRvs5OIeRmqVjhvNRHhXkpdAK/M5WB0unwIT5dsFdc54lL+7j6KYdfFBrLR+onB3HvzNLyHwmjB85Y3GLckh0pT6LOjXN+dZAF8p3PtIkBl8D/wn50ZpMJNvuUCNQpk/6Ng0zpttOlzmih8IHf1WB7wqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ykx4uMEoOCSMq6XNucMt7D7HKIWQOy8IFPx8Oe62g5Q=;
 b=jfq/70bWP7nGAKVGx8BQiV8hvdfvHRGgGNFm3l59EXjYQ6O0SAPSUATfH7VF1NuHxQDSHZqXwtiI84O1xYEPaUKagaNXGOjAFlqrPqeOHNr9J8VuYHCECK8TUjysCWhJdgljolv60pn5CWIxuCxuJCLx44HXgpBH0QFhB+xsnDdjWhxg15egk88ebtmMp7rPwK+mO63olgt7eXmQw/op5bJywxjesuY6f6awAScwX79k/gTUZ9FncUXBwE2DLAVLvbItKcEzD7a76GiKCzKONN8c6x9I6kLFHWqswnRyDNZxec5qT6C8oHL+/xE9zC0sP9kjnAkTcSE1Dn+XZtUv6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ykx4uMEoOCSMq6XNucMt7D7HKIWQOy8IFPx8Oe62g5Q=;
 b=U/S0DSxa4gem6U1/5gtevc5OZ4yMAKxP7doqf5QuUghBZmQCEKFvIXlruFn1Rxsho9R0IolMbOnFfii3VhxtiuW5zQ0Jj6gW5pB2hSZS/jN90SPVwNrd6l3+GW4oCXRxVOPxfBL7zMcO0zVot0KyK9sc2JLh+mNusqGY83rStSpZF3AJWVoduN5uliMdgOjf1S08oqWglsr8m+JAJqPL4b+AyDyt3diE2Yqs+bgj/3FtndcBb2E+LN359tLuTZ1WClY2uXvSliIGY+6NjyPe3BkMwnrEKRkBTkTIgXttOFSZiFpMCa1m/24U0bRM120x5bzekz1ddGkTmalA4Ljrdw==
Received: from BN9PR03CA0387.namprd03.prod.outlook.com (2603:10b6:408:f7::32)
 by PH0PR12MB5433.namprd12.prod.outlook.com (2603:10b6:510:e1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Sat, 24 Apr
 2021 11:29:26 +0000
Received: from BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f7:cafe::9d) by BN9PR03CA0387.outlook.office365.com
 (2603:10b6:408:f7::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Sat, 24 Apr 2021 11:29:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT032.mail.protection.outlook.com (10.13.177.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Sat, 24 Apr 2021 11:29:25 +0000
Received: from [10.41.23.128] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 24 Apr
 2021 11:29:18 +0000
Subject: Re: [PATCH v14 00/13] SMMUv3 Nested Stage Setup (IOMMU part)
To:     Marc Zyngier <maz@kernel.org>, Krishna Reddy <vdumpa@nvidia.com>
CC:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "jiangkunkun@huawei.com" <jiangkunkun@huawei.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "tn@semihalf.com" <tn@semihalf.com>,
        "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
        Vikram Sethi <vsethi@nvidia.com>,
        "wangxingang5@huawei.com" <wangxingang5@huawei.com>,
        "will@kernel.org" <will@kernel.org>,
        "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
        "zhukeqian1@huawei.com" <zhukeqian1@huawei.com>,
        Sachin Nikam <Snikam@nvidia.com>,
        Bibek Basu <bbasu@nvidia.com>,
        Shanker Donthineni <sdonthineni@nvidia.com>,
        Sumit Gupta <sumitg@nvidia.com>
References: <f99d8af1-425b-f1d5-83db-20e32b856143@redhat.com>
 <1619103878-6664-1-git-send-email-sumitg@nvidia.com>
 <YILFAJ50aqvkQaT/@myrica> <5a8825bc-286e-b316-515f-3bd3c9c70a80@nvidia.com>
 <BY5PR12MB37642B9AC7E5D907F5A664F6B3459@BY5PR12MB3764.namprd12.prod.outlook.com>
 <87r1j0rqzk.wl-maz@kernel.org>
From:   Sumit Gupta <sumitg@nvidia.com>
Message-ID: <a372b4b6-ae34-c618-3569-4d5f5ab760c1@nvidia.com>
Date:   Sat, 24 Apr 2021 16:59:15 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <87r1j0rqzk.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 080f0a4e-9a95-446d-3311-08d90714372b
X-MS-TrafficTypeDiagnostic: PH0PR12MB5433:
X-Microsoft-Antispam-PRVS: <PH0PR12MB543389F7FE0DC0D0F979C71DB9449@PH0PR12MB5433.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GL4XkJeuLiDbxPpAU/l5rHNsB7LTP+dZx1WjN74RTxrmBTDO1StoUg5QAbizNB8NTo0IMr16XFeKc/Al9+mmJHtlMir9XViNjQtC5tUb+y/l+BpZ7I+RzMEtZLRAiCWWoj7wK4alGhdfBK/K88JcFBdkeLq67waeZwDVh2fvxaV4oGDBaJI4TKAfQ27wykPxEHE64F59LElRM+delmRoJPR3SsgsooBVCYm6/WNjlri5N1tVe7pI9t6IrZPxc4h5Eq+jxBcnuWG0cTQT82Mw1AqB0mchZXVf5gXR9Wt4pLnuWn4itBe/Ici+89f+6yuHdUCF8mmcI5WOhWT9QbohyGz6ObQlw7y8iAN9mfbsALvudmIxiH2dGkzRF9e2RKhipMfdS9f2smm4Plk5vQhfkAMF8yWXLmsmkLVlY/zsSnLZkqKs8gA7yiEGLtq6chK5EvfMfIawglagr5fyER7ervElxyXHIeevD55iOEjYorIAAuidRq03WsoAS9xUAPKq4tWvroG9oxz59uT0w61qvjSgOEcpvtr/50RFM4/HGHV87xXpyntEzsFFOOjshqFm43Fv9VHnRk3j3Kj8MXV9Y9wJ4sl3dITJAhnv68KQD3Jeie9pTiW9dZUbuVRJJtmt5z2HBBbe3mjdprPmTi6I81N6G77MMvp56N0t9bB+hWQOkPpbnLXThBWahczvvMRX
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(136003)(346002)(36840700001)(46966006)(336012)(86362001)(83380400001)(31686004)(82310400003)(82740400003)(356005)(2616005)(36860700001)(7636003)(8676002)(426003)(36906005)(54906003)(16526019)(16576012)(186003)(5660300002)(36756003)(47076005)(26005)(70586007)(107886003)(110136005)(8936002)(6666004)(70206006)(2906002)(6636002)(4326008)(316002)(31696002)(7416002)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 11:29:25.3585
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 080f0a4e-9a95-446d-3311-08d90714372b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5433
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


>> I have worked around the issue by filtering out the request if the
>> pfn is not valid in __clean_dcache_guest_page().  As the patch
>> wasn't posted in the community, reverted it as well.
> 
> That's papering over the real issue, and this mapping path needs
> fixing as it was only ever expected to be called for CoW.
> 
> Can you please try the following patch and let me know if that fixes
> the issue for good?
> 

Hi Marc,

Thank you for the patch. This patch fixed the crash for me.
For the formal patch, please add:

Tested-by: Sumit Gupta <sumitg@nvidia.com>

> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 77cb2d28f2a4..b62dd40a4083 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1147,7 +1147,8 @@ int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
>           * We've moved a page around, probably through CoW, so let's treat it
>           * just like a translation fault and clean the cache to the PoC.
>           */
> -       clean_dcache_guest_page(pfn, PAGE_SIZE);
> +       if (!kvm_is_device_pfn(pfn))
> +               clean_dcache_guest_page(pfn, PAGE_SIZE);
>          handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &pfn);
>          return 0;
>   }
> 
> 
> --
> Without deviation from the norm, progress is not possible.
> 
