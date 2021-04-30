Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBFF036FD19
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 17:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbhD3O7s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 10:59:48 -0400
Received: from mail-eopbgr770073.outbound.protection.outlook.com ([40.107.77.73]:4499
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231389AbhD3O7O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 10:59:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iPDdFZgHiqRSuyGZ0ffYJdtCckByV2S00zJ/Cn6e5QbQ7kp7iqOhctyN7VRQStJj8BrHeGdDUcgDHQJsytxQi7I2+Rh5kXvig46PNSJZnUChSr37ml5gG+VAc4ihqXqI60csQpWrWr88OBD72mDx1QCgRr458tCHX3fjCFrNUaarT9br7dQAgiQl3coss/WRzkF9HTeQheDlKbjAtfoar9YRvw01hNT47FBGkqE6Cj1xUTbhBo/drlz8JPYJYx5f/Dcam4geNL5trYXP97GzsPh3RK62EBTRKugOjM5oaVcyl0C2ClU8yugBs0nxyzVhmnSvoEN652eNDdV2niqAfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c1R+l2CcKmd6vOAMVfDzaF/KTbDH7EQDEkqRh2CopLk=;
 b=f6FgepBsH0xR+XzrUSqaAggXC7ArnrzI5eoe+8NkTBpqG6lxCCCkaDEcbaT6xsso4T9/2Cnqf7wWeko9q5DaD3S3A0u9pOT1yuB+P/SDs1l8GlcRCAUFAgICKSfpcjSBRuPHLWZwOyMlAwY4XjI0yRsGezU1H6IoRAhUQx+Oy4Uj9mmfYDwnt3Pe2JUXAY1KUMfVduyp2IDKAcct3/F2Hfuj547EfDzNm5f+Wkgowf40vfvjzG6n0ZFo0cvI1Ybl5qoUVwoznEvUXdr7hOLDup0G06e/syvf2PZUcO1dYBPMQ7EvkpereX/swXsPQh1TO9pUnjABk5k6akDge3XwWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c1R+l2CcKmd6vOAMVfDzaF/KTbDH7EQDEkqRh2CopLk=;
 b=LVqWKycIU3dKA5fzO0gVWuyom3bnixu/V5Lio01ZiHmI7/WhKFTMPc77Oi5kTYa5RENNKjpzoB246n7So6KqeaTDHMm5d7ML6RWdpkbPxBQMbvLaVOzSZL3ZBSPz46rs+4bqjkmfjEVuY1ETyb1oZwpd21eCgT9yD+TGE5s2r3TR2Qwt5KZyr8wBldnAJMVLaI7obR27btTdVBLTRUGAM93/9q0kyrIUy6DIrTkPTEXEcPcxIQJ4PuQHvhFi9hCW/6HFn9p7mOn04N6ZFSeXLC58HqrVisyNYqw0C4AmiqjKk2OnslAfqf09SgIB6QaAGjqe8XD8sAE5J0cWakZidw==
Received: from BN8PR15CA0051.namprd15.prod.outlook.com (2603:10b6:408:80::28)
 by BL1PR12MB5080.namprd12.prod.outlook.com (2603:10b6:208:30a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25; Fri, 30 Apr
 2021 14:58:25 +0000
Received: from BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:80:cafe::88) by BN8PR15CA0051.outlook.office365.com
 (2603:10b6:408:80::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend
 Transport; Fri, 30 Apr 2021 14:58:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT035.mail.protection.outlook.com (10.13.177.116) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4087.27 via Frontend Transport; Fri, 30 Apr 2021 14:58:24 +0000
Received: from [10.20.22.163] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 30 Apr
 2021 14:58:23 +0000
Subject: Re: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
To:     Marc Zyngier <maz@kernel.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Christoffer Dall" <christoffer.dall@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, Vikram Sethi <vsethi@nvidia.com>,
        Jason Sequeira <jsequeira@nvidia.com>
References: <20210429162906.32742-1-sdonthineni@nvidia.com>
 <20210429162906.32742-2-sdonthineni@nvidia.com>
 <20210429122840.4f98f78e@redhat.com>
 <470360a7-0242-9ae5-816f-13608f957bf6@nvidia.com>
 <20210429134659.321a5c3c@redhat.com>
 <e3d7fda8-5263-211c-3686-f699765ab715@nvidia.com>
 <87czucngdc.wl-maz@kernel.org>
From:   Shanker R Donthineni <sdonthineni@nvidia.com>
Message-ID: <1edb2c4e-23f0-5730-245b-fc6d289951e1@nvidia.com>
Date:   Fri, 30 Apr 2021 09:58:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87czucngdc.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12373b4a-c977-42be-468a-08d90be867cb
X-MS-TrafficTypeDiagnostic: BL1PR12MB5080:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5080461DE98CB94BD7004EF5C75E9@BL1PR12MB5080.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vCDDbXwrInF+MnLksUxtX3x7Kfczd2RBg1eytWnKm1evtms4LtVRXvJVUWwDFyCCxUx22faiEz3+OTq5FYzommeVc8o/d7ZmwcQiHUmBqu429kHrcHmB7I85RHTEkV72zMphop2bCaVSP0+pXVBOrugMjQ13MJq9c9mpQA2qnSL0405RMpooYAq+4bTIpLSLFjh5P/mtQaGsSMTLJHStQebTa9vmrXcRP7XQIZ3OlQHZ4RM53i6wHcsXMgbBKYcul0G5z0+GrcYkcRle83yVIv3sYSf8JG3VzlM5XT7FtFE1pwOg9rL726GAHHBcRC6iG9POY0VSDd7U5iTXRi9dlU4YIDEJFy6ZTUUXFLJROW487kr+pl8Q2Z9T2gtx5mZdEsNHxPlDJpB4y7DkxMGOYtX6QD6IRuSrCwu6TAIAP5EuOB84GNsTuZq/wm5MCyTbFU1xnLUz9Wv9avvqLERo2KxBaFq0JZDCmJfR2viehW/ZhT4qMgPeP8N7D1lj5ZNv0si/TG35bFi1r3FDLtn8+Vn6j23m8dbEVm0gbW4bNCjryEWrzq1OapuhuuNQBSYOx4Myn07GYKhQm2I1zGCGtcrWiM/dmEQoXWHN4OGqRiaTsoQ5YStvCnD1a6U49ZHauH6jWoA2KnYCKMO4NRxGb+lkaiJ58euY7kqJUm1CIJtoKPG5PD6+51JL79YsS2fe
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(136003)(39850400004)(46966006)(36840700001)(4326008)(36860700001)(2906002)(6666004)(426003)(47076005)(36756003)(2616005)(336012)(16526019)(5660300002)(82310400003)(107886003)(478600001)(6916009)(26005)(31686004)(186003)(70586007)(54906003)(70206006)(316002)(83380400001)(8936002)(356005)(31696002)(8676002)(53546011)(7636003)(86362001)(82740400003)(36906005)(16576012)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 14:58:24.9470
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 12373b4a-c977-42be-468a-08d90be867cb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 4/30/21 6:47 AM, Marc Zyngier wrote:
>
>>>> We've two concerns here:
>>>>    - Performance impacts for pass-through devices.
>>>>    - The definition of ioremap_wc() function doesn't match the host
>>>> kernel on ARM64
>>> Performance I can understand, but I think you're also using it to mask
>>> a driver bug which should be resolved first.  Thank
>> We’ve already instrumented the driver code and found the code path
>> for the unaligned accesses. We’ll fix this issue if it’s not
>> following WC semantics.
>>
>> Fixing the performance concern will be under KVM stage-2 page-table
>> control. We're looking for a guidance/solution for updating stage-2
>> PTE based on PCI-BAR attribute.
> Before we start discussing the *how*, I'd like to clearly understand
> what *arm64* memory attributes you are relying on. We already have
> established that the unaligned access was a bug, which was the biggest
> argument in favour of NORMAL_NC. What are the other requirements?
Sorry, my earlier response was not complete...

ARMv8 architecture has two features Gathering and Reorder transactions, very
important from a performance point of view. Small inline packets for NIC cards
and accesses to GPU's frame buffer are CPU-bound operations. We want to take
advantages of GRE features to achieve higher performance.

Both these features are disabled for prefetchable BARs in VM because memory-type
MT_DEVICE_nGnRE enforced in stage-2.
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

