Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1BB136EE24
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 18:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240816AbhD2Qah (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 12:30:37 -0400
Received: from mail-dm6nam11on2084.outbound.protection.outlook.com ([40.107.223.84]:15136
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233302AbhD2Qag (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 12:30:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DV0ATN2ybJSbGaOcgFaNG/5ubyTqtTCUSepKDkSAbYrLRGcqR6Vh0lgja/IFKAB+eprKzyxSEKlGEW98Glt3n4iw26lcffhbenGJeNDew4oXC9ld4FVZb/JcgZJo2aNxsB6jB2vM8RcWJMNV7i9SpZJCP6PsZe977bDqScMADC0BlaUjMiFTQe0KeEn9lRdRK3ufjiHN8nY/Y9e1dgu4/QV6Ejlbno+ps8SoWm1ufC1zMyPBBwS8lViRACYJKdgvMFNiFqaMcTkyenVZqpWOCPTzuRVB8P/vLsS89PQ2l/euZgumZFBoxQgZcyq5kHBzvkpGWrXmzFQoBIN9mXYrBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MKwmcvJlnAryc2O6/Z+gYUK6HFhpJR4lqcr9k33pB4Q=;
 b=bnHOH34+Dn/8QRkgfLQ/LH05BqShguZrvZEzkltsbJi1I2kv454U+8E9eJK2+UbW//Vx4dCmGZ3tUOmfyv0r+PbLsg/IqLQB+jHq3pWlEBZHthepfTB1erTIqUp4fB9e+dfhmUOqrLPvlrN0ONUPVn3wGyj3MXLTFSNmxLA77oYbnqpba0t2Xn+9rFy/LctpVqGSlGLFaoWVu6mLoGPTgC7xAQeoYLbByiGwK4L9FCvvJ3qYtRcRWLrFmmcFL0E4o4NQ3I7XlPwK9gBD0xF9FcZGoR8dqh5jLoEexq9ltbP2k16ck40IWgMb/xCdJDsb71OQZhJqJzGgDMXgBrcMwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=lists.cs.columbia.edu
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MKwmcvJlnAryc2O6/Z+gYUK6HFhpJR4lqcr9k33pB4Q=;
 b=Y0lgFBEp0B8kAw0Fr8k3f8yyD758FK8fHHglbbkNtXSwd9zeTMkI75ZCpON3U7/2Pzb1SCFng6fp2ICrjV1s4KGy7oP1HZ/sOeFASp5Rp3BJf4UcYjS11AcVvw/qRIAT3DEUka9OWOQ/QXu7iIGQM2KQkRs8RrrCHMR3A7sWkic7WwVTBCOQZvGCoLQtSmWGMNZRvqAlyJsC4bwpu6nwZ/DLbmd2dJerxN0WHuNkK7+WafHe20shc1/ih3sQVw+T4Vr1nnDWGGByCnIdhCp7DcKmpdqJO7RJbTRCIUIzGGicBcYsWqEzNCRafUxCPwTzfubPmyaH70gtSx/wHopheQ==
Received: from DS7PR05CA0028.namprd05.prod.outlook.com (2603:10b6:5:3b9::33)
 by CY4PR12MB1399.namprd12.prod.outlook.com (2603:10b6:903:38::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Thu, 29 Apr
 2021 16:29:48 +0000
Received: from DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::87) by DS7PR05CA0028.outlook.office365.com
 (2603:10b6:5:3b9::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend
 Transport; Thu, 29 Apr 2021 16:29:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; lists.cs.columbia.edu; dkim=none (message not
 signed) header.d=none;lists.cs.columbia.edu; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT015.mail.protection.outlook.com (10.13.172.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4087.32 via Frontend Transport; Thu, 29 Apr 2021 16:29:48 +0000
Received: from SDONTHINENI-DESKTOP.nvidia.com (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 29 Apr 2021 16:29:46 +0000
From:   Shanker Donthineni <sdonthineni@nvidia.com>
To:     Marc Zyngier <maz@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, Vikram Sethi <vsethi@nvidia.com>,
        Shanker Donthineni <sdonthineni@nvidia.com>,
        "Jason Sequeira" <jsequeira@nvidia.com>
Subject: [RFC 0/2] [RFC] Honor PCI prefetchable attributes for a virtual machine on ARM64
Date:   Thu, 29 Apr 2021 11:29:04 -0500
Message-ID: <20210429162906.32742-1-sdonthineni@nvidia.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2330b376-b545-4e6b-6277-08d90b2c0196
X-MS-TrafficTypeDiagnostic: CY4PR12MB1399:
X-Microsoft-Antispam-PRVS: <CY4PR12MB13991218BC5E5EC130F7FDA4C75F9@CY4PR12MB1399.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oTdymT9Lxt922Nr8khytSCv3ci8vzPYf62xPKnj3uzn2oPBcisRsn2ajRLpXPm0KqvEPKiEw/DjGVegozQFePTGXhq5Pl8fnOWh8p0ycnwFd6mGF/xRd1rrcZzjdLyrz+xdONwk0gdyKOnErytdfKnWIm4jW4PVYKLKVU9c1PkY2FRv8aeNzfWgENccoBNzMlpM8zPV74NDaGRopAtXXK16mhzIqeBYesUyCWaHqvHZBduB82Yd2Mx4dLsu1/GMDA3fjNQXXpGSIXrk8Z8meaUCOua/E1imp1D3gb1Hf9+FxMJZSXFrxZ2Kg/k38QD3Cg4/Uk1JAmoITEvQKgMejelfZFHVmfvqkcvjNdN0v7R8txzxoXmvUbErmwl3hgGzhCSWC6Y4W+qJzzPJEclyU2TZpVpPJLX8SZlN5tSEJcLjP3Ydvhu0F8a84bgNmDKmoSTa3/2JcUg0Nkhp7TYi1VRBwNe7pF3Hw2SuNSS2VI+aK7vjQRiH3wI3RcAwx5/IAhGQr6RCOSzCrtW1XZ0IoWU30hynKIa/5mGINRs05vK1KGTtMzvd0NuIrX4g6qZAI1hywDWrVzYBxPW5Ze1odtPffz6vB8Vy1YItXUdZbCtkJqj+GfixmT3fKwvWPQaA8ipcTDYoNamDyUPznwrHLR+a9yh7+syvtc1cpwUI5LpE=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(136003)(39850400004)(46966006)(36840700001)(36756003)(7696005)(70586007)(70206006)(2906002)(2616005)(8936002)(356005)(8676002)(86362001)(5660300002)(83380400001)(336012)(7636003)(36860700001)(82310400003)(1076003)(47076005)(110136005)(82740400003)(107886003)(54906003)(316002)(26005)(16526019)(186003)(36906005)(478600001)(6666004)(4326008)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2021 16:29:48.0066
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2330b376-b545-4e6b-6277-08d90b2c0196
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1399
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Problem statement: Virtual machine crashes when NVIDIA GPU driver access a prefetchable BAR space due to the unaligned reads/writes for pass-through devices. The same binary works fine as expected in the host kernel. Only one BAR has control & status registers (CSR) and other PCI BARs are marked as prefetchable. NVIDIA GPU driver uses the write-combine feature for mapping the prefetchable BARs to improve performance. This problem applies to all other drivers which want to enable WC.
 
Solution: Honor PCI prefetchable attributes for the guest operating systems.
 
Proposal: ARM64-KVM uses VMA struct for the needed information e.g. region physical address, size, and memory-type (struct page backed mapping or anonymous memory) for setting up a stage-2 page table. Right now memory region either can be mapped as DEVICE (strongly ordered) or NORMAL (write-back cache) depends on the flag VM_PFNMAP in VMA. VFIO-PCI will keep the prefetchable (write-combine) information in vma->vm_page_prot similar to other fields, and KVM will prepare stage-2 entries based on the memory-type attribute that was set in VMA.

Shanker Donthineni (2):
  vfio/pci: keep the prefetchable attribute of a BAR region in VMA
  KVM: arm64: Add write-combine support for stage-2 entries

 arch/arm64/include/asm/kvm_mmu.h     |  3 ++-
 arch/arm64/include/asm/kvm_pgtable.h |  2 ++
 arch/arm64/include/asm/memory.h      |  4 +++-
 arch/arm64/kvm/hyp/pgtable.c         |  9 +++++++--
 arch/arm64/kvm/mmu.c                 | 22 +++++++++++++++++++---
 arch/arm64/kvm/vgic/vgic-v2.c        |  2 +-
 drivers/vfio/pci/vfio_pci.c          |  6 +++++-
 7 files changed, 39 insertions(+), 9 deletions(-)

-- 
2.17.1

