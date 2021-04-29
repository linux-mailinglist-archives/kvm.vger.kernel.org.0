Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75AA936F065
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 21:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhD2TYf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 15:24:35 -0400
Received: from mail-dm6nam11on2059.outbound.protection.outlook.com ([40.107.223.59]:13385
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242832AbhD2TPp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 15:15:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ne39nzxnJMPhErSlFk23QtilQ4uJk4ycxqN3VYr3irm6rjV+3QshkrYA3kLiCtyZUdDpOEXhO0GxjQMCVHVpUeLmI9u7g7fW+C0kVng7VtWT42fOEKmVHqeYH22qAPNXicEhJNMlNbj3hBYg31KMj+V94xWnbb3nA4v76wM1nEUMAHOuL/NuP/nfsjG9jtAaItjxvzo8ZeK3r3KnAO13nVEhzxA8z38/A9LmFIqM1vdFV9lXJ6LxEaSP0nlMgSVOQunJ0yA1kmjyP6HirtwFeA6V7i5z5FwG9KqrrclLgLwy+YbLqKmOGk9clXs0N1R/vYu6DOoaRyrc+4dzHHR9GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W0r6l3fZwjf4ZW7F4orjcbw5rDBOLI8/QO5Zgiblx/Y=;
 b=HRpuDo9k9tNVMOt5POFEb18txI0o8YUBk7GUbSXseqlZEGQ4M7NuLG4mE2OImh+2An41v6/A/Y2X9BpHg6Y8kULzqwq9MFtklXQYmgueITpXjzIFFAZiG1AqY+UjKL9VWNYkH+vuow6dAFlco+103fkpKU2vvL3CFe2WgWfN7lzUS5o1t1DZ9R0xStIjvhjwhVvgBct5N6zgzUNvwI/Lz3s5IWOEGVBYD1gUGeFdPtPcwIbVoLE/O1sqVXk2M0FxEaEHRrnZVgtb3X7A0ICaMdFdcNJyzQGPkrGLSxUCJPpGVFZAavthGgMhgdf+OPftiRh3HMMwwDkvy0SrWLuOvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W0r6l3fZwjf4ZW7F4orjcbw5rDBOLI8/QO5Zgiblx/Y=;
 b=SbOMgDLjw/55wg3AVnm0BEFwZJFaZaPe/jzJQpdZOJkaItCfM1OanrkykAf6in69kKCb/tbe9FxjvXp2q9ONp2fUoZv/QDX6OU3+WmSX6D9oYqli/9pf0UX+1fOPkcCvgkKHsjV+DTgURvhPPM5+VuzEiPDD6a9SjcGhEHeVTUf4V3lI5B8VOPZ+uhmx5H6r7k6ljZufsNcRh0sYzsYRu2Wjj80oVrBG/ECTafmlq9YSPQvPwmj8QJnwF1PSSbO+tKfVLEmPdT+Cg/diTHxqYIC2Iw946NzNufjXrDm4UHKjCXgRxwjvaiLx/vVLH/dbIz7qjC7WldZiOy+bKsbIiw==
Received: from BN9PR03CA0965.namprd03.prod.outlook.com (2603:10b6:408:109::10)
 by MWHPR12MB1471.namprd12.prod.outlook.com (2603:10b6:301:e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Thu, 29 Apr
 2021 19:14:57 +0000
Received: from BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:109:cafe::3c) by BN9PR03CA0965.outlook.office365.com
 (2603:10b6:408:109::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend
 Transport; Thu, 29 Apr 2021 19:14:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT032.mail.protection.outlook.com (10.13.177.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4087.27 via Frontend Transport; Thu, 29 Apr 2021 19:14:56 +0000
Received: from [10.20.22.163] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 29 Apr
 2021 19:14:54 +0000
Subject: Re: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, Vikram Sethi <vsethi@nvidia.com>,
        Jason Sequeira <jsequeira@nvidia.com>
References: <20210429162906.32742-1-sdonthineni@nvidia.com>
 <20210429162906.32742-2-sdonthineni@nvidia.com>
 <20210429122840.4f98f78e@redhat.com>
From:   Shanker R Donthineni <sdonthineni@nvidia.com>
Message-ID: <470360a7-0242-9ae5-816f-13608f957bf6@nvidia.com>
Date:   Thu, 29 Apr 2021 14:14:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210429122840.4f98f78e@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b77357cf-9db4-4805-c185-08d90b431356
X-MS-TrafficTypeDiagnostic: MWHPR12MB1471:
X-Microsoft-Antispam-PRVS: <MWHPR12MB14718F479ABC74D36BE4D188C75F9@MWHPR12MB1471.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bguPNV34ywz9UqJl5YLzH1FbSZKdc9+66BKkg+2WhO44Ln/E3RNRtbYUrsKfb3yPHEzBYsM7U7D1WCRUI4QUdO9EwRO4U3ScquPA9TAOIROs4l3qHkGUWQBVnQFIWNgN5fxh7sB3SrDJqSHK0YfLS/z2KtuB6SbPwVqBKEQ2nhrP6KUno9Q2dsUW6FK27EIRk9oLvmshAADxGKxqoHlcRrKgvKDYZb0rKkES8KIm8rXhzHg13AWUmQwi/GEJ9NoYFjhjlTCvYCPiu+MYl7kbfjc2hCgwXGN4wFNk1ATGtpE1ugW4JNkv6xlTpCzTnIOAuEoErCsq3fcdSJCWahJ+dVETmtlWsHBUIqtbcOTC472gS4ykTkN4lom4C1KmnIQFEaoG+USB8C1ZVO7E20djdZvBqkUdShBIKSdmnS+9kpE8ym1e9iKL0nzuq3v1gR2tLW2lnDX8bEYwAsyOoWVoMcj5v4j8pA4i2fVQV/lYY+wNP5IYma5x6pS5lWw+vtjxPNvQMTVamrTG0Ob+MpZ6SbuHZRalwEgMnANz8GZIS3Py+2fIx4EmDCZnNDbutxKVtDGAC7/vVFEqgaWUWAPhB87WlBbFqf87u/JD+WTsSm9rf+YA+FL1b+K2GugpdB94GVo/TvUbnfIIHGPoBRJm3dKUChIK7RlAb9DGSO+3WS8lCX4QxlllB7AZvlfUfPGcQy4+mh+TDGfqfVbadwp51g==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(346002)(376002)(46966006)(36840700001)(7636003)(31696002)(107886003)(36756003)(36906005)(70586007)(426003)(478600001)(316002)(70206006)(6916009)(36860700001)(2906002)(86362001)(26005)(336012)(53546011)(54906003)(8936002)(82310400003)(5660300002)(6666004)(83380400001)(356005)(31686004)(186003)(16576012)(82740400003)(47076005)(8676002)(16526019)(4326008)(2616005)(3714002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2021 19:14:56.3023
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b77357cf-9db4-4805-c185-08d90b431356
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1471
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks Alex for quick reply.

On 4/29/21 1:28 PM, Alex Williamson wrote:
> If this were a valid thing to do, it should be done for all
> architectures, not just ARM64.  However, a prefetchable range only
> necessarily allows merged writes, which seems like a subset of the
> semantics implied by a WC attribute, therefore this doesn't seem
> universally valid.
>
> I'm also a bit confused by your problem statement that indicates that
> without WC you're seeing unaligned accesses, does this suggest that
> your driver is actually relying on WC semantics to perform merging to
> achieve alignment?  That seems rather like a driver bug, I'd expect UC
> vs WC is largely a difference in performance, not a means to enforce
> proper driver access patterns.  Per the PCI spec, the bridge itself can
> merge writes to prefetchable areas, presumably regardless of this
> processor attribute, perhaps that's the feature your driver is relying
> on that might be missing here.  Thanks,
The driver uses WC semantics, It's mapping PCI prefetchable BARS using ioremap_wc().  We don't see any issue for x86 architecture,  driver works fine in the host and guest kernel. The same driver works on ARM64 kernel but crashes inside VM.
GPU driver uses the architecture agnostic function ioremap_wc() like other drivers. This limitation applies to all the drivers if they use WC memory and follow ARM64 NORMAL-NC access rules.

On ARM64, ioremap_wc() is mapped to non-cacheable memory-type, no side effects on reads and unaligned accesses are allowed as per ARM-ARM architecture. The driver behavior is different in host vs guest on ARM64. 

ARM CPU generating alignment faults before transaction reaches the PCI-RC/switch/end-point-device.

We've two concerns here:
   - Performance impacts for pass-through devices.
   - The definition of ioremap_wc() function doesn't match the host kernel on ARM64

 
> Alex
>

