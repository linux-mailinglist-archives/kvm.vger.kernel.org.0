Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC6B369936
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 20:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243329AbhDWSUq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 14:20:46 -0400
Received: from mail-dm6nam10on2071.outbound.protection.outlook.com ([40.107.93.71]:17148
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231728AbhDWSUn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 14:20:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jj9mff3G82fkv+HxwZqig2/SQDTEP+YwYP2vo/c95OYN/Sis4ODHGnvjr13YiOHkTUcR2mSdYlriMEKp6KAf92bgakxlggEeiZn0/6L0kYDRmZzar7EwTr0V9eQczpNtD7B+vaYnFBCNpPdgXlLsXxUvhYtPsxo0RkWIH80fD72IAPdpWjcM0COqVQkvHFnQ2fKnaUHJPTCH6kMxxt55H+PJRBMy8RlvknoucAsyf0nBgpwK+Nij447p6EURZ/e+L31sDociCipGfGHKH/lnin0+wGOrOIskm8M7mEgoPgtuatRCEPoUSk5hfkW5XvWpiQ2FR+UrrnTjSOkoIH4ieA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gapqk/8XKWL22oJQJG50Al6RLHuefx1vqDFPK/US01E=;
 b=Evot1KWRRGN/jwqHSGEyK/eYUfI+n9mp2zaZ3f2XfV1K4A4M+VbBEIf3QBwYtiaFM+X66p+VvtL+bL/ZOhW9xrkkNwM5QptC64TQTvLcugaA18CIN8WntHkctb9h9j2WMDkBrHF1vfcy/ExOUPrezpzqAv3qEXzTkU62RHWGtl8v8yv3acrGIbrP8fk6FHDtfbEaVamilrnCm0oS1jwHUrcYKP8UZgHwsBTqs5T81Y2eOXFDqJOCY5ErIkYRU4K718+asLcU9e6siKsklbTI/KVAjuHg3gAhUH7Sr9Vgz5lJHxktv0J2YMLT2B5MO71nvqqk51+dvDfSVqyD1RINow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=8bytes.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gapqk/8XKWL22oJQJG50Al6RLHuefx1vqDFPK/US01E=;
 b=oIjhLevVwq0uY60B2XIcS2Hj93TQkWlc52f1UFa6FCle+oWUlWJm/hB1gGopPmTn1Kz949SE7KLqu7r0AkiFVqB6c2GySAQDgRkTnUKvnxWeI6cNo7YXxbP9e4Y1srD9W5iv90vIDnSUPVHHIvkxpfTLPid/YpB941EHh6B06hY+ETw01ZZoNz35UBJ9Qh+IvSeSW9bhX8eUYwU3bnFov0lDrlGB+MfyyaFlUAQm88KwcyqUuwLsqJADlQ4b4zlkZt/KgXrDQIafvUtLRNQ7nyAHadvsbMmy2g70QkJBt8mjZ/yENEBkiF2sDhUUJKmLGhSJ7uOGJNBzRi7zo9AgMw==
Received: from BN7PR02CA0015.namprd02.prod.outlook.com (2603:10b6:408:20::28)
 by BN9PR12MB5196.namprd12.prod.outlook.com (2603:10b6:408:11d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Fri, 23 Apr
 2021 18:20:05 +0000
Received: from BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::f1) by BN7PR02CA0015.outlook.office365.com
 (2603:10b6:408:20::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend
 Transport; Fri, 23 Apr 2021 18:20:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; 8bytes.org; dkim=none (message not signed)
 header.d=none;8bytes.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT056.mail.protection.outlook.com (10.13.177.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 18:20:05 +0000
Received: from [10.41.23.128] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 23 Apr
 2021 18:19:58 +0000
Subject: Re: [PATCH v14 00/13] SMMUv3 Nested Stage Setup (IOMMU part)
To:     Krishna Reddy <vdumpa@nvidia.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "jiangkunkun@huawei.com" <jiangkunkun@huawei.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "maz@kernel.org" <maz@kernel.org>,
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
From:   Sumit Gupta <sumitg@nvidia.com>
Message-ID: <467c95cd-3ba5-519e-cdac-9f477da86ecb@nvidia.com>
Date:   Fri, 23 Apr 2021 23:49:55 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB37642B9AC7E5D907F5A664F6B3459@BY5PR12MB3764.namprd12.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b097732a-0214-45a3-b625-08d906846b48
X-MS-TrafficTypeDiagnostic: BN9PR12MB5196:
X-Microsoft-Antispam-PRVS: <BN9PR12MB51961A3DB446833C4BF166C0B9459@BN9PR12MB5196.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s7clLpzt7EUCUrBWYbruNWLmcrUC57NihX8c0LjC34rXtHll6TifhtX6u5kjk2G+p4tGGREF194u5FUM8VKEDkvgcqSkUVkVQwnN1JE94t9u+WxAgWwgmHXy/rgAm8oGlic3CWyiEX/vrNmS7irLSHc8r8rKiz0IYSYqHj03sqwqcNwrEhdfXy8T3zYIpFku1zTNQe6okX0GzZ0weBue2NDq6pJ82lfDmt57WZSd76FJ3F+BOkM25jUYMiqzvx/ia7lujQmhKH24Jb6bAtZlBGlfMJsItxbYswwYKaUFIWcLTiKHBnUmxx0yH0G3GCla229BUb6sRzf4Ak9VPfl6+sxk5muF/5ohgDkFaUuG9aIEmWdzkQ1UBmYzvmJIH+YqXV8yUtHwnJyqNkGXm3WgvyUdUhtAbwRsU58FDxmThKiWdvRu9o6sTSmnYgNyCD0wOFrVRTy5KmgFfnWqgLLb+gPmAxkyHPcjtBAKzPg1ci/DdgXS68L9sq1ntj5wXpiH6bRUuY3v5cLhBrbg8+t3Korr6poJOauLnrxhdANpyDc4MRXCdx3nSrJcEwbEgaygk3XAaUrGzBnSs3sX0qWcn93as3rbkxkkwEAU+1/D93TqzmdUPHCXpq8xiJrnq/gHORLJEKhSXoYjVeWBRlPFDFfW4m4eABEVcYTpXpqE/wYN+b2icnc0/3UPyr86DX7R
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(39860400002)(136003)(46966006)(36840700001)(70586007)(82310400003)(36756003)(5660300002)(31686004)(356005)(7636003)(54906003)(6666004)(107886003)(110136005)(82740400003)(70206006)(316002)(7416002)(26005)(31696002)(16526019)(16576012)(426003)(83380400001)(2906002)(2616005)(186003)(86362001)(478600001)(36906005)(36860700001)(336012)(4326008)(8676002)(8936002)(47076005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 18:20:05.3193
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b097732a-0214-45a3-b625-08d906846b48
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5196
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



>>> Did that patch cause any issue, or is it just not needed on your system?
>>> It fixes an hypothetical problem with the way ATS is implemented.
>>> Maybe I actually observed it on an old software model, I don't
>>> remember. Either way it's unlikely to go upstream but I'd like to know
>>> if I should drop it from my tree.
> 
>> Had to revert same patch "mm: notify remote TLBs when dirtying a PTE" to
>> avoid below crash[1]. I am not sure about the cause yet.
> 
> I have noticed this issue earlier with patch pointed here and root caused the issue as below.
> It happens after vfio_mmap request from QEMU for the PCIe device and during the access of VA when
> PTE access flags are updated.
> 
> kvm_mmu_notifier_change_pte() --> kvm_set_spte_hve() --> kvm_set_spte_hva() --> clean_dcache_guest_page()
> 
> The validation model doesn't have FWB capability supported.
> __clean_dcache_guest_page() attempts to perform dcache flush on pcie bar address(not a valid_pfn()) through page_address(),
> which doesn't have page table mapping and leads to exception.
> 
> I have worked around the issue by filtering out the request if the pfn is not valid in  __clean_dcache_guest_page().
> As the patch wasn't posted in the community, reverted it as well.

Thank you Krishna for sharing the analysis.

Best Regards,
Sumit Gupta
