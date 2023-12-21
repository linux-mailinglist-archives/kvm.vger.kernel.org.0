Return-Path: <kvm+bounces-5090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B79E881BB2C
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 16:44:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2DD991F25913
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 15:44:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3F8B59913;
	Thu, 21 Dec 2023 15:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Mi73mWwL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F68A5990C;
	Thu, 21 Dec 2023 15:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mjzw+bkmk8DF2EQDC7p/EOf4ki8dP6g+2ILMvKZKGqXIO5ByqHMqCc6dJ8RXSejaZ7GQL6otJX/VLHfGBe7G6L52a+LlcJGQerFgtIN4ryxa7yRWB6OVQ7GtuuviC1ixQeA02vYd9EppxDeU9VjazRlAJGpt9wT1Ym6+K178qZFJGJZZr3HN4F7ChUJyMwlDwI+dGB98B/h/GvnlemZylhyhY6ZNUS1KlUKaO+rFOKdnMkXdg5GUTFMlwSKhNrdZGd0r9L/JRCje8vowBe30egai5EOmQXjLVgZCR42RpRunc5LZnX7fn4IVPtARjAiOOdWb3eFtz8tvIbCT3zzHVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d+qlOPgGc2o7pR2aPUUYh2TFfVO1m/A29YPA6WA2Oy0=;
 b=kSpk21ffBPx/pTWQZZWm7ijPWhHWrEzMPi3hNZhsCrjrsnjv/DQ05hd0k0FyZSnGhm0qUKQuzRf9p7FANHvgfmYlnUuzAsOk7e4WYz1bQtgoa6X7W4pxe3rLPHJCI2mhTLSlwXvwbU1Kz6EVdnr8O9xYhNYPCfr+0Chj+h+P9OzNnd5lYFqap093FCDj1m5mrc9zDnSdvvn8h12OFudgk89MWTV6lSQ8BPcS3KbJTWCJJM4oNGvYNQrR8Z4E2uPQ7p+8QkZ9vhfMyjhvJaL/7mszeTirdr0VgRCWAGP2/YJRhA67RbUG2UBCkC3SnL7KsMuCu6PlfyxklcH57T23lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d+qlOPgGc2o7pR2aPUUYh2TFfVO1m/A29YPA6WA2Oy0=;
 b=Mi73mWwLmOOPM4NG1tr/X2/nPjnLapcv37Ks0QEkfsoZQc2xD0CO36E4xrpKqeCa0yhZ8B4N+1EAgUOg5jl/Agv5zNVr8zmQZ4zQL0WMrMMdFyI4FYV/VeDq28OIoNAhPRoHS9N6H+kU2Umc/rbMmzXXKX2BA4m8oLRP3nCif/A+IfZdm1CJMga9b+Tdlrf7uaCuBWzf4jn/DKYpFkqedaaT+VfwaxeRC9dKP24dHy/fAqz9wg4GP5+igjrWzyjnBeXgZzoeBzvYt8o6pYm1UFTsq5om0FmSjxhYGrhTtdvRZZ4u/+Z8d+tx1j8JGRn2RHhnc1mlWTLUTb6if+v73w==
Received: from CY5PR18CA0001.namprd18.prod.outlook.com (2603:10b6:930:5::6) by
 DM6PR12MB4530.namprd12.prod.outlook.com (2603:10b6:5:2aa::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.21; Thu, 21 Dec 2023 15:40:59 +0000
Received: from CY4PEPF0000E9D8.namprd05.prod.outlook.com
 (2603:10b6:930:5:cafe::ec) by CY5PR18CA0001.outlook.office365.com
 (2603:10b6:930:5::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.21 via Frontend
 Transport; Thu, 21 Dec 2023 15:40:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000E9D8.mail.protection.outlook.com (10.167.241.83) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Thu, 21 Dec 2023 15:40:59 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 21 Dec
 2023 07:40:41 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 21 Dec
 2023 07:40:40 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Thu, 21 Dec 2023 07:40:32 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <alex.williamson@redhat.com>,
	<kevin.tian@intel.com>, <yi.l.liu@intel.com>, <ardb@kernel.org>,
	<akpm@linux-foundation.org>, <gshan@redhat.com>, <mochs@nvidia.com>,
	<lpieralisi@kernel.org>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<linux-mm@kvack.org>, <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v5 3/4] kvm: arm64: set io memory s2 pte as normalnc for vfio pci devices
Date: Thu, 21 Dec 2023 21:10:01 +0530
Message-ID: <20231221154002.32622-4-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231221154002.32622-1-ankita@nvidia.com>
References: <20231221154002.32622-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D8:EE_|DM6PR12MB4530:EE_
X-MS-Office365-Filtering-Correlation-Id: bf7f2a21-cc1b-4078-15e9-08dc023b3b16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+W+szar1QmHDe0BIL+42ckDW1lABQ+6vw+OcE4G+kpGqaNty5zLq5uKN/z5ocGEjlZ3ghM+vTl2efBg4uR/8CYh4WbpNdtiDhZNGAJIA1yHIlw1DZYY9hbOkXhBa+ti6ET75Rt01dCsm6V8ec28letVoSVxTostapKer2PtCzNmLLlr1LerJZPv6WPzle1vOH89YIicwSNE6f47R33wEZQmcDXg7z15DYbLst7crlyg26HPsVOicepk4GZgZZH0E2Sg8TCqjs3K6iI4oOe2W7/zDiWkvcgQh44xcqHGessOGc5b/E4oeX9oed74d+0XiWmmVdS6Rl6JeMKR4w3wLG/l4W+C7ufSpeIZwNLhC37Yu2f/BE6VEYLCf32kMOBOfVMKBuiPSx0whZyO2cfbhPFlNvXxYHUW9/luzasMsoeEyr7z7yKmsxA4TVoWCtndlSGjrEGrWhXB+3/uk++uyDwEjhY73s7JYsBX3NF7roEjERIKDKip6lNZsf1lv++IDA4abxTTkFK65khOwqOF9VQZkSolg2+uvLMIb77MwVVwFess48QIqYdrIMRK47YbJ2+zn78d7X4bAtYTLoXWNKfJn9ZJcACmXStw76i3WTgRxW30zqqkjpxOBvd8/Tv5/hzhk8KTBaK/59+1iKNwt+6OUjO3LP5l9yQ3+TJ4aFuiJB3ueVGXoQOwkWozv88lOl7x5fNY6iBENBr+H5xUb9t+MpU5m8DyOU+YnxqbeP33sEDVDe8eL0LOZTMAa+wLg7k/g5i561zONzh8Q0KkJ94VGYhjNdEpPeW0vvXTzrkH1ArWuJOh/FMs7/Z/xHFNV
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(346002)(376002)(39860400002)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(82310400011)(46966006)(36840700001)(40470700004)(40460700003)(26005)(2616005)(1076003)(336012)(83380400001)(426003)(6666004)(7696005)(47076005)(36860700001)(5660300002)(7416002)(2906002)(41300700001)(2876002)(478600001)(8676002)(4326008)(70586007)(8936002)(70206006)(110136005)(316002)(54906003)(356005)(7636003)(36756003)(86362001)(82740400003)(921008)(40480700001)(2101003)(83996005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2023 15:40:59.6303
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf7f2a21-cc1b-4078-15e9-08dc023b3b16
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4530

From: Ankit Agrawal <ankita@nvidia.com>

To provide VM with the ability to get device IO memory with NormalNC
property, map device MMIO in KVM for ARM64 at stage2 as NormalNC.
Having NormalNC S2 default puts guests in control (based on [1],
"Combining stage 1 and stage 2 memory type attributes") of device
MMIO regions memory mappings. The rules are summarized below:
([(S1) - stage1], [(S2) - stage 2])

S1           |  S2           | Result
NORMAL-WB    |  NORMAL-NC    | NORMAL-NC
NORMAL-WT    |  NORMAL-NC    | NORMAL-NC
NORMAL-NC    |  NORMAL-NC    | NORMAL-NC
DEVICE<attr> |  NORMAL-NC    | DEVICE<attr>

Still this cannot be generalized to non PCI devices such as GICv2.
There is insufficient information and uncertainity in the behavior
of non PCI driver. A driver must indicate support using the
new flag VM_VFIO_ALLOW_WC.

Adapt KVM to make use of the flag VM_VFIO_ALLOW_WC as indicator to
activate the S2 setting to NormalNc.

[1] section D8.5.5 of DDI0487J_a_a-profile_architecture_reference_manual.pdf

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Ankit Agrawal <ankita@nvidia.com>

---
 arch/arm64/kvm/mmu.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d87c8fcc4c24..7e01fff78e23 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1379,7 +1379,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	int ret = 0;
 	bool write_fault, writable, force_pte = false;
 	bool exec_fault, mte_allowed;
-	bool device = false;
+	bool device = false, vfio_allow_wc = false;
 	unsigned long mmu_seq;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
@@ -1471,6 +1471,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	gfn = fault_ipa >> PAGE_SHIFT;
 	mte_allowed = kvm_vma_mte_allowed(vma);
 
+	vfio_allow_wc = (vma->vm_flags & VM_VFIO_ALLOW_WC);
+
 	/* Don't use the VMA after the unlock -- it may have vanished */
 	vma = NULL;
 
@@ -1557,10 +1559,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (exec_fault)
 		prot |= KVM_PGTABLE_PROT_X;
 
-	if (device)
-		prot |= KVM_PGTABLE_PROT_DEVICE;
-	else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
+	if (device) {
+		/*
+		 * To provide VM with the ability to get device IO memory
+		 * with NormalNC property, map device MMIO as NormalNC in S2.
+		 */
+		if (vfio_allow_wc)
+			prot |= KVM_PGTABLE_PROT_NORMAL_NC;
+		else
+			prot |= KVM_PGTABLE_PROT_DEVICE;
+	} else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC)) {
 		prot |= KVM_PGTABLE_PROT_X;
+	}
 
 	/*
 	 * Under the premise of getting a FSC_PERM fault, we just need to relax
-- 
2.17.1


