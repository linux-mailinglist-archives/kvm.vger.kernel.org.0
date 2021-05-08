Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A11377307
	for <lists+kvm@lfdr.de>; Sat,  8 May 2021 18:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhEHQeY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 8 May 2021 12:34:24 -0400
Received: from mail-bn8nam12on2046.outbound.protection.outlook.com ([40.107.237.46]:30945
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229883AbhEHQeW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 May 2021 12:34:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bDeYybri3RIGGkm7yE5rKP5mw1IEKhyt7HcpaiAuKh0nalH0mhx8x5E1yVqhNO9oSJd45bCaWGO/+z2Z8L5T+DTWM8PsJwyXV/iQ7601nsmSouUBN92DKi7Oj02cy/oD1oBsS/Joa+rOm0iOE15RLfDT6edUDlgocEeX+eJq2a33dDZ1KeBdQeH9t3aEv9Dzsd22kJqzI5vIlQmBVIU3Q11jFiaA86Rum1ggNr/SeFb/GjdWP5+6cCSqf5Rtrioix++0TGFzm5YiqJlc1palk69LhvTvXpeJYIs2uu6uYD2KhwmhMmjz6utqAwSPgd/6f+Px1fFomL/fuqLw10FYCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RpOX5jZLLuH/VgnoT2Hp+vaQgRDiX23wl94X5U30XQg=;
 b=W5kVQCLbmGlPpW1VayXZnamClInL67LYipDtzLUR8+Z/LS+UHxw/sFVj9l6E8hpRwu+Sr0769xrbbSqTrxRHDJyZCDIJN40yQSVu3rDXWVF+Q+M74hMKZqUBaiRtcT+OKwMSDK+w2gZSYktYlXuDpjuG/38i7whghCuFtWKWfFbIlAP6sicgOXOfjhv9mnhVnOUEJnEXIfpQ6sCFjktUHf6VUc4nrUSil/ybn8dJXr6auoIG9DTVlPn6Q3njbko8HBOAwJP1YTN8ptrGSBaLZ42yz8MjhxEVKJ64AoKbvRoXxM44sfQ/ATy2RB50vhI4ME6c+1ClasA5JirPLueqaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=xs4all.nl smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RpOX5jZLLuH/VgnoT2Hp+vaQgRDiX23wl94X5U30XQg=;
 b=Eb1Ygo1/mkBc55DbQPHRNpDzgdheLi6Kzyzi3KcKlpSHKcOp25CtF6E36doNF6K5LbQaub/RR9oamfmc83Jvo60Gmyms7yt7PyNZAhvJEm/485fprCjcZkL18rS4eXkv0HkXJgh1t9qL7o1yS2zEgXYRfzDSnNoQZoBYH18qzg6Xtaa98rqtnrGyBatQ/Yg5ORSjHtEonNCSXFAfdViTGF8rKlZJ8lH4p/vK7ETCtJeEJnM0ma2CSvYeuH9uOjmtuV0J2mDvA5ocgrHnn/jOC0c3QmskwHMOTYkfpMzJnmJP8c6vka7lRisIUKfMnNDD4oIvwvHCxzDuNpGph43KFg==
Received: from BN0PR04CA0067.namprd04.prod.outlook.com (2603:10b6:408:ea::12)
 by DM6PR12MB3705.namprd12.prod.outlook.com (2603:10b6:5:14a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.30; Sat, 8 May
 2021 16:33:18 +0000
Received: from BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ea:cafe::a2) by BN0PR04CA0067.outlook.office365.com
 (2603:10b6:408:ea::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Sat, 8 May 2021 16:33:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; xs4all.nl; dkim=none (message not signed)
 header.d=none;xs4all.nl; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT029.mail.protection.outlook.com (10.13.177.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4108.25 via Frontend Transport; Sat, 8 May 2021 16:33:18 +0000
Received: from [10.20.23.38] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 8 May
 2021 16:33:15 +0000
Subject: Re: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
CC:     Vikram Sethi <vsethi@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Mark Kettenis <mark.kettenis@xs4all.nl>,
        "Marc Zyngier" <maz@kernel.org>,
        "christoffer.dall@arm.com" <christoffer.dall@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Sequeira <jsequeira@nvidia.com>
References: <878s4zokll.wl-maz@kernel.org>
 <BL0PR12MB2532CC436EBF626966B15994BD5E9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <87eeeqvm1d.wl-maz@kernel.org>
 <BL0PR12MB25329EF5DFA7BBAA732064A7BD5C9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <87bl9sunnw.wl-maz@kernel.org> <c1bd514a531988c9@bloch.sibelius.xs4all.nl>
 <BL0PR12MB253296086906C4A850EC68E6BD5B9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <20210503084432.75e0126d@x1.home.shazbot.org>
 <BL0PR12MB2532BEAE226E7D68A8A2F97EBD5B9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <20210504083005.GA12290@willie-the-truck> <20210505180228.GA3874@arm.com>
From:   Shanker R Donthineni <sdonthineni@nvidia.com>
Message-ID: <273ba1c2-dfe6-7dc1-3e40-03398e82469b@nvidia.com>
Date:   Sat, 8 May 2021 11:33:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210505180228.GA3874@arm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1933258b-34ed-4da5-1154-08d9123efcb0
X-MS-TrafficTypeDiagnostic: DM6PR12MB3705:
X-Microsoft-Antispam-PRVS: <DM6PR12MB370599BE314CAC5594526251C7569@DM6PR12MB3705.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WvbMLr67Mje535X8RHWmEi0f+6+vuK6ydDHE9c1sGCE4gYk1wqln8zzeNwDP5/5v1lDo4h7dBkymH+O21p9S/Cc38XjpMpkpV4DzFdDkW3kmzCCEwxwvQPAFonUAG6rqw+Ov8giqpxOc+TEO/uhA3y8PHlFfiW0q1WjupSaFoKnpPPeljKTTl/cWnMYSNcJF8HFa4MvAbr2AuQtNy3eFTYEg9BhMQYvascZYT4mMG01JTu9/RihJLVJZQz2wS9wclr5xMxq5PC1CjW+Gd+aeXf1XPMT2Sw6El3J2QAReUgXV9EmM8nYP2+N8mxTRvYDt2CCPs3vI8jX5ZLKYRU2um3qGiPZf51CB++VuWpFqWMI7oGXjDI9wyeKXzdL1USNKDO8dLsvvCe7G0XAsubIVrgaSnwJ8x0+KMWAyDfzbZpYwx32IuZrfKL316p5oIzSGB6422lXPDJUJr/AA6DdhVPZtD0p23MgbA58r2aSfRHCUVISj2tbU6dlNF6bWvHzh2PEMGMyhVjLMTcFHW9yXCMI1SGdNAMZnONr/DbyDK4H9aQPVXc7AXWDOxkn/0mgNTFWtPDoU9lxRut6OlLhYu7zYXZrk6ZGL41emV6MThJtI/NkrjEl0qnbtrYG8PNOxUr21UgIyDMuwGezZxni+N5X/fahjCAUq1TnnyEyLlUVzQJ9WXz7yQ+PcLRPmSaOb
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(376002)(396003)(46966006)(36840700001)(53546011)(16576012)(26005)(54906003)(36860700001)(31696002)(86362001)(8676002)(31686004)(316002)(110136005)(4326008)(82310400003)(107886003)(7416002)(8936002)(82740400003)(36906005)(478600001)(36756003)(356005)(7636003)(83380400001)(70206006)(2616005)(70586007)(2906002)(47076005)(16526019)(426003)(6666004)(186003)(336012)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2021 16:33:18.4566
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1933258b-34ed-4da5-1154-08d9123efcb0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3705
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 5/5/21 1:02 PM, Catalin Marinas wrote:
>>> Will/Catalin, perhaps you could explain your thought process on why you chose
>>> Normal NC for ioremap_wc on the armv8 linux port instead of Device GRE or other
>>> Device Gxx.
>> I think a combination of: compatibility with 32-bit Arm, the need to
>> support unaligned accesses and the potential for higher performance.
> IIRC the _wc suffix also matches the pgprot_writecombine() used by some
> drivers to map a video framebuffer into user space. Accesses to the
> framebuffer are not guaranteed to be aligned (memset/memcpy don't ensure
> alignment on arm64 and the user doesn't have a memset_io or memcpy_toio).
>
>> Furthermore, ioremap() already gives you a Device memory type, and we're
>> tight on MAIR space.
> We have MT_DEVICE_GRE currently reserved though no in-kernel user, we
> might as well remove it.
@Marc, Could you provide your thoughts/guidance for the next step? The
proposal of getting hints for prefetchable regions from VFIO/QEMU is not
recommended, The only option left is to implement ARM64 dependent logic
in KVM.

Option-1: I think we could take advantage of stage-1/2 combining rules to
allow NORMAL_NC memory-type for device memory in VM. Always map
device memory at stage-2 as NORMAL-NC and trust VM's stage-1 MT.

---------------------------------------------------------------
Stage-2 MT     Stage-1 MT    Resultant MT (combining-rules/FWB)
---------------------------------------------------------------
Normal-NC      Normal-WT           Normal-NC
   -           Normal-WB              -
   -           Normal-NC              -
   -           Device-<attr>       Device-<attr>
---------------------------------------------------------------

We've been using this option internally for testing purpose and validated with
NVME/Mellanox/GPU pass-through devices on Marvell-Thundex2 platform.

Option-2: Get resource properties associated with MMIO using lookup_resource()
and map at stage-2 as Normal-NC if IORESOURCE_PREFETCH is set in flags.


