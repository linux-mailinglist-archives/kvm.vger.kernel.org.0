Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA7E36981E
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 19:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbhDWRQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 13:16:55 -0400
Received: from mail-co1nam11on2050.outbound.protection.outlook.com ([40.107.220.50]:24096
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229691AbhDWRQy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 13:16:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QYRV3N2warzrnaaA7qPemCiZ76nKDsg20Sv84s/b8ysz22D7XaukMdX0hWE1vR6D55AjR+iy8WZKpMUmowijoJl8vMmWmzHgoZ6vgAigwxoGGT+B/DqXfBQeFj4nm+jenojlyDY85X4ei6wx/vpSwXZoeD2dOhfV7n+2+4njfhKe9G2N2dHc4XKBRi5DcnXzUzSJytQXuK6nz87LZb98CR2tvzSs8/b6DEqGA7+2HjmdKvctaPfEib7U0tRd0HrWA4xPoG5K/LKkA8xzWPkgIYC3ETfOEr15tTxWZBz2Tp8ZB2a6sXSHHK/F7O9RRVYAQUJ9LjA5alxRTOZ1UUZK0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JOiDgsmK9K+3d6PIMv4gcXiJUJYSqvoei8CaALsMauw=;
 b=KpacMh18hfPQ5SZMGdrRwrS/wGDgxcYzUnyMspL+zKB83q4DGsgAbXbe0l7tbUXR1XXiRmHKw5GEyGogVXEi4aP1Y0tE9M+D8DnHX5eULGYAWUiJ+h2uYxuo8Z4gKmE5U8aJETPvBvPJqa7mMQLuWNipBKvGPg0zij4lK8huE8v5tdnfEPkEcyCFvR2IAhr00qaWLRVjOVICGeEsyTjcgvqrdAZKuStA8ZP1Nh9GI2n+Zf3Fz1Lo7b0E+veBhsUCWZVRCkHa093XwdQmr6aGuoEZh+i09LjQU5XAoMutE3rSmUMOH0vhFDvf4AeGDF0GWQsRYUikCX31mqd8H+vQrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=8bytes.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JOiDgsmK9K+3d6PIMv4gcXiJUJYSqvoei8CaALsMauw=;
 b=TzUdifKfmLkRJSX/Adr02c/7uz0o22+GCQaOO86WvZveja0ovQV+Bzg7NU+5drkgnED49jk9LxDr8l+iEuk9pXVrQ87IyH2yu384lVzyseNAdYzrkB8dZvGp2i4JmYTQxJhVCM6ushEqlky3EyX8Q/L43r4xQD2KxWy8SptgWUhrPgYDkIQR9QZk7VD/X7A6yg9Y5jxrdSX/akMscolUHpGC+4XF4TNKXBWWNA2fpzLRxPaq8kABsiYitAobnQTJcqjvemYyNrQqRbCou8n/sBQOU4EhsmdUbikBlWeVlAujTPnibrty5A00AdsyUB6x3f26pa8lPAd7cEu46B9HCQ==
Received: from BN8PR04CA0049.namprd04.prod.outlook.com (2603:10b6:408:d4::23)
 by BY5PR12MB4146.namprd12.prod.outlook.com (2603:10b6:a03:20d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Fri, 23 Apr
 2021 17:16:16 +0000
Received: from BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:d4:cafe::f8) by BN8PR04CA0049.outlook.office365.com
 (2603:10b6:408:d4::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend
 Transport; Fri, 23 Apr 2021 17:16:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; 8bytes.org; dkim=none (message not signed)
 header.d=none;8bytes.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT012.mail.protection.outlook.com (10.13.177.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 17:16:16 +0000
Received: from [10.41.23.128] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 23 Apr
 2021 17:16:09 +0000
Subject: Re: [PATCH v14 00/13] SMMUv3 Nested Stage Setup (IOMMU part)
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
CC:     <eric.auger@redhat.com>, <alex.williamson@redhat.com>,
        <eric.auger.pro@gmail.com>, <iommu@lists.linux-foundation.org>,
        <jiangkunkun@huawei.com>, <joro@8bytes.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <linux-kernel@vger.kernel.org>,
        <lushenming@huawei.com>, <maz@kernel.org>, <robin.murphy@arm.com>,
        <tn@semihalf.com>, <vivek.gautam@arm.com>, <vsethi@nvidia.com>,
        <wangxingang5@huawei.com>, <will@kernel.org>,
        <zhangfei.gao@linaro.org>, <zhukeqian1@huawei.com>,
        Krishna Reddy <vdumpa@nvidia.com>,
        Sumit Gupta <sumitg@nvidia.com>,
        Sachin Nikam <Snikam@nvidia.com>, Bibek Basu <bbasu@nvidia.com>
References: <f99d8af1-425b-f1d5-83db-20e32b856143@redhat.com>
 <1619103878-6664-1-git-send-email-sumitg@nvidia.com>
 <YILFAJ50aqvkQaT/@myrica>
From:   Sumit Gupta <sumitg@nvidia.com>
Message-ID: <5a8825bc-286e-b316-515f-3bd3c9c70a80@nvidia.com>
Date:   Fri, 23 Apr 2021 22:46:06 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <YILFAJ50aqvkQaT/@myrica>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d24cc0c-63f9-4106-fa42-08d9067b80f3
X-MS-TrafficTypeDiagnostic: BY5PR12MB4146:
X-Microsoft-Antispam-PRVS: <BY5PR12MB41466CF3E92A0B69821C6D88B9459@BY5PR12MB4146.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: owOfu1AxzfFkTy0Tcw5Mc3CI8eO29v6lFwSzeOY7AKQ7vnT+hFbA/DtDGRjMzz+fJzPOCjj4SNbB6NEz32y4Zo8Ze5Ke26c7W4U2It6ysDVIX9CHHZN+UE3EMtDdaISUUzGKUjwHqPdagqboHvS8SHAE3Fwazp7ufgsTTAfmAdtBzTuNSE7O5SiBWlr3HT64bjC0APaX+JltKdg8FWfUPVUuTxUN+WDxF3GyWblC0YfjZp0hpb7H1LjNBzY/2RiVexsYS/qGe8ppmCfqPW/6myjyuacVuGVPXXkppoVI9XhO9Zu2FvgqBiQbT//AHkuFPgV5hCoNGT5heJRX6Zua+jZzmNPgSey2iw8PTZROzYFM1toPEM92gyqsH/0NHHV4RiTE7LyHlvwDO0Q6r2I6wXkLN9qV+EG1Ctm2qEAA9CohPomXaSPy6xYD5j4yprbZRsqxc5icq38LnyHCpQTyWVxq+AOBfGQdyJwoGEhMMfgpi7KZTYnf4FwSkHWyY3/eG9CdkHhRLOVGUe4e9HxD0o2kHfvmNdUL2VNfCs83LL6ANd9mk9tJhG2JOYKZhHBs8+pfSVuuh7jZRgMLRxbRWLn0qmY0FGMiw/d4j40h+zeo+9TEeHv/I3oVVbkXYD1SOrzeDbbOfAIGDsQIlEV9U8bNrRBWZn0U6AEqdlKQWOR9VPiObKSyz4SqdJtpVG1i
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(376002)(346002)(46966006)(36840700001)(186003)(478600001)(8936002)(6666004)(16526019)(31696002)(86362001)(54906003)(8676002)(16576012)(6916009)(36906005)(45080400002)(316002)(7416002)(2616005)(426003)(70586007)(26005)(2906002)(70206006)(107886003)(336012)(31686004)(7636003)(83380400001)(82740400003)(47076005)(36860700001)(82310400003)(5660300002)(4326008)(356005)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 17:16:16.2063
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d24cc0c-63f9-4106-fa42-08d9067b80f3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4146
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jean,


> Hi Sumit,
> 
> On Thu, Apr 22, 2021 at 08:34:38PM +0530, Sumit Gupta wrote:
>> Had to revert patch "mm: notify remote TLBs when dirtying a PTE".
> 
> Did that patch cause any issue, or is it just not needed on your system?
> It fixes an hypothetical problem with the way ATS is implemented. Maybe I
> actually observed it on an old software model, I don't remember. Either
> way it's unlikely to go upstream but I'd like to know if I should drop it
> from my tree.

I tried Nested SMMUv3 patches v15(Eric's branch: 
v5.12-rc6-jean-iopf-14-2stage-v15) on top of your current sva patches 
with Kernel-5.12.0-rc8.
Had to revert same patch "mm: notify remote TLBs when dirtying a PTE" to 
avoid below crash[1]. I am not sure about the cause yet.
Didn't get crash after reverting patch and nested translations worked.

[1]
[   11.730943] arm-smmu-v3 9050000.smmuv3: ias 44-bit, oas 44-bit 
(features 0x00008305)^M^M
[   11.833791] arm-smmu-v3 9050000.smmuv3: allocated 524288 entries for 
cmdq^M^M
[   11.979456] arm-smmu-v3 9050000.smmuv3: allocated 524288 entries for 
evtq^M^M
[   12.048895] cacheinfo: Unable to detect cache hierarchy for CPU 0^M^M
[   12.234175] loop: module loaded^M^M
[   12.279552] megasas: 07.714.04.00-rc1^M^M
[   12.408831] nvme 0000:00:02.0: Adding to iommu group 0^M^M
[   12.488063] nvme nvme0: pci function 0000:00:02.0^M^M
[   12.525887] nvme 0000:00:02.0: enabling device (0000 -> 0002)^M^M
[   12.612159] physmap-flash 0.flash: physmap platform flash device: 
[mem 0x00000000-0x03ffffff]^M^M
[ 1721.586943] Unable to handle kernel paging request at virtual address 
ffff617f80000000^M
[ 1721.587263] Mem abort info:^M
[ 1721.587776]   ESR = 0x96000145^M
[ 1721.587968]   EC = 0x25: DABT (current EL), IL = 32 bits^M
[ 1721.588416]   SET = 0, FnV = 0^M
[ 1721.588672]   EA = 0, S1PTW = 0^M
[ 1721.588863] Data abort info:^M
[ 1721.589120]   ISV = 0, ISS = 0x00000145^M
[ 1721.589311]   CM = 1, WnR = 1^M
[ 1721.589568] swapper pgtable: 64k pages, 48-bit VAs, 
pgdp=0000000111280000^M
[ 1721.589951] [ffff617f80000000] pgd=0000000000000000, 
p4d=0000000000000000, pud=0000000000000000^M
[ 1721.590592] Internal error: Oops: 96000145 [#1] PREEMPT SMP^M
[ 1721.590912] Modules linked in:^M
[ 1721.591232] CPU: 0 PID: 664 Comm: qemu-system-aar Not tainted 
5.12.0-rc8-tegra-229886-g4786d4a20d7 #22^M
[ 1721.591680] pstate: a0400005 (NzCv daif +PAN -UAO -TCO BTYPE=--)
[ 1721.592128] pc : __flush_dcache_area+0x20/0x38
[ 1721.592511] lr : kvm_set_spte_hva+0x64/0xc8
[ 1721.592832] sp : ffff8000145cfc30
[ 1721.593087] x29: ffff8000145cfc30 x28: ffff000095221c80
[ 1721.593599] x27: 0000000000000002 x26: ffff0000a3711c88
[ 1721.594112] x25: ffff00009333a740 x24: 01e8618000000f53
[ 1721.594624] x23: 0000ffffb8320000 x22: 0000000000000001
[ 1721.595136] x21: 0000ffffb8320000 x20: ffff0000a1268000
[ 1721.595647] x19: ffff800011c95000 x18: 0000000000000000
[ 1721.596160] x17: 0000000000000000 x16: 0000000000000000
[ 1721.596608] x15: 0000000000000000 x14: 0000000000000000
[ 1721.597120] x13: 0000000000000000 x12: 0000000000000000
[ 1721.597568] x11: 0000000000000000 x10: 0000000000000000
[ 1721.598080] x9 : 0000000000000000 x8 : ffff00009333a740
[ 1721.598592] x7 : 07fd000ffffb8320 x6 : ffff0000815bc190
[ 1721.599104] x5 : 0000000000011b06 x4 : 0000000000000000
[ 1721.599552] x3 : 000000000000003f x2 : 0000000000000040
[ 1721.600064] x1 : ffff617f80010000 x0 : ffff617f80000000
[ 1721.600576] Call trace:
[ 1721.600768]  __flush_dcache_area+0x20/0x38
[ 1721.601216]  kvm_mmu_notifier_change_pte+0x5c/0xa8
[ 1721.601601]  __mmu_notifier_change_pte+0x60/0xa0
[ 1721.601985]  __handle_mm_fault+0x740/0xde8
[ 1721.602367]  handle_mm_fault+0xe8/0x238
[ 1721.602751]  do_page_fault+0x160/0x3a8
[ 1721.603200]  do_mem_abort+0x40/0xb0
[ 1721.603520]  el0_da+0x20/0x30
[ 1721.603967]  el0_sync_handler+0x68/0xd0
[ 1721.604416]  el0_sync+0x154/0x180
[ 1721.604864] Code: 9ac32042 8b010001 d1000443 8a230000 (d50b7e20)
[ 1721.605184] ---[ end trace 7678eb97889b6fbd ]---
[ 1721.605504] Kernel panic - not syncing: Oops: Fatal exception
[ 1721.605824] Kernel Offset: disabled
[ 1721.606016] CPU features: 0x00340216,6280a018
[ 1721.606335] Memory Limit: 2909 MB
[ 1721.606656] ---[ end Kernel panic - not syncing: Oops: Fatal 
exception ]---
