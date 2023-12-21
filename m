Return-Path: <kvm+bounces-5087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BCF181BB24
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 16:43:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A679AB21562
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 15:43:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 483A755E46;
	Thu, 21 Dec 2023 15:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="U4GIbdT3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FFB4B13B;
	Thu, 21 Dec 2023 15:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IKmZsaDyUiSRGciZWMk59kic+te+5KNkq026ebL7igcaaABcD6HwT643x6y8uYbteu8jZI8GxItt/IvNmEilT2QSUshcaH4NeHeGQqp/GCueF1H0Tp42Qb6o1NiMRp/8L1Ghbl8D2nR8mnyd9JkNoHldBc5YCLHEec81Ty797jrbp4WllHbOEKhwh/DaC76NqO2yy69e/b5Af6X/71LDHT+exUms0TGDyxSl0+PJCTsGQsBX124mn0LR8qHLyxFDN7Ngj9LYKGmLXt4lCca6sdTWknckXUn/x+rRmCxgfI2dj9D+gEr2SdB6ePkWEmBQ9vLjbtD4nDJogHmPaNaPiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZVJ2yze0YmVP/aNa+3VP+/URtFNPgqSKDly7j8c9ugY=;
 b=IU9/TLD/V7bFFBkjJ7aY6ic4m+tZQYvkZnsoSMV8Pjzg0I9Pwq/tJNpT6/S2U4DL6tjPDI/J4qCAiXBBfO5t8kWh0gjro+S0o/zTGHQqNS3yLk6BJbVSSXRpfdng/QMkwCEAB0c0HICBW1JoDj8tldhxHrJHAHDfjGitfdCjXjk5OpxtQWjpGtkT+jQPQsPndzS7GEYYqgJO+xEmCR2Gss0BqT0iiItTCRcLm9iDTvB2zgilKCC80yyZhs9a4zFKTKNI990701XrBYhzZgOfK4GDAtmXnC2FAOwaqBw/DlwIS9OjXR8NZzzYi3Z5khJp4N2ycaTpLXjOs8/YhAilzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZVJ2yze0YmVP/aNa+3VP+/URtFNPgqSKDly7j8c9ugY=;
 b=U4GIbdT3DCWFkRH0wudVDA33KrLmRCsaGLyfH3u/yAerVC+Mw4XErp2exhYx2F/IJKiMCzR/P33inC54urvTqtb9UjfjHrRGKiE3dpGiVilZAYsg4OgPzV/VezyLuBVmYDaWRJvSNQXIfLlBQ6MIVWs8PjaoaVFRMKChnqtHL3UQfveW/7xrvTKe/jFs3pkl/oCKIXpX/6Zuy06k5n/uwcVjfjfkFi43eEHuW+xtbWnh6jSTjWMx9fNdmsaezLvndEB27lh0TvQa1EWjMD/r0u1T9rWPRGSjq7HKvZ/df6kdFobVt63mnCe85+JBzhXLAB/r1VLlni8MRKmBXAFkZw==
Received: from SA0PR11CA0048.namprd11.prod.outlook.com (2603:10b6:806:d0::23)
 by IA1PR12MB9029.namprd12.prod.outlook.com (2603:10b6:208:3f0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18; Thu, 21 Dec
 2023 15:40:24 +0000
Received: from SN1PEPF00026368.namprd02.prod.outlook.com
 (2603:10b6:806:d0:cafe::ad) by SA0PR11CA0048.outlook.office365.com
 (2603:10b6:806:d0::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18 via Frontend
 Transport; Thu, 21 Dec 2023 15:40:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF00026368.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Thu, 21 Dec 2023 15:40:23 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 21 Dec
 2023 07:40:13 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 21 Dec
 2023 07:40:12 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Thu, 21 Dec 2023 07:40:04 -0800
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
Subject: [PATCH v5 0/4] kvm: arm64: allow the VM to select DEVICE_* and NORMAL_NC for IO memory
Date: Thu, 21 Dec 2023 21:09:58 +0530
Message-ID: <20231221154002.32622-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00026368:EE_|IA1PR12MB9029:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ef1661c-80a8-4f05-384e-08dc023b25db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	SoIKoPio4uScRVmUBxblH0pIm+MWLTFLVmkmzdG4ibcD2/7I3pDwUa1uAtpwgYkffwkpHZC6/Rn+GdAPaDyO8JxJAzMWDhy7ghKhw5PEOPZleGr5LwrtianNVSHklLHFAr8W4ckEygLdKPkW8lF+QN9gTa/tzyqkWLQLzzIntJri4Ys47dy0F75WkAMN0ClIstgo3e+neExhwdYWbwj0Tuu8WR9JkQ7QzQuoFMNyES79zfB649tVFcZ8cWzYmzHxD9ftQ1RGcEiybESiWtqiUZXtPx8uiq7P+GYZOspZyFvUNNXTMQfdNn/hdfYJrQ29uYzzmKMyqiM1BX59MF+YcbxEZGP/S3oqm2dFJDEVk8zjg7jKzzD5PixVcmh+/Js7nWYxYjWobBs7tOMY07RZThzIrYIhqPS0WBASzCMYbnvxHhsjLbM8dbDYFrcG3tUG0ZD34L56QynFL6ny7KTAIqjftLf4D5jHkyorPnFL57OI5vDtM36FJWZnUfqCG49JhcKDRWiH85el/NhXm42Afd5K1XuXDbqd9U0WO9RN+qHzdc1BDeJyvpANQFlGqny6IlYiRumAxqPWhJxKzCPmHo0rL1L2XXz89p/eS+U0kT6Z5jxVv/Ba3tQuXihZzZoQxddJCl3bZ3KK9H2GZxNPHmgmeSyKpM1r5xdRy0Pr0JbGq09pTOfD8ZNX5N4dnuyH1kjhrMygDv5RWHsmZkRVhwovlzL/1pS475GGc0QdEkVHxKDO0dQI+mXa4Y3kQH4+SaV57KFWPFJp/K5eIBOpJ3tXoBMKp6XDkt0BJR/fJhXBWBg1QNgcF3URzF3tV30khFbRd1mh8CbAoQkGndObdBYtTjfMngcvzZwWwtepWFjGD1Zk8vhNsTSQHjW5KmJPe2CuNyn2mAjCx1mB4bIvYw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(39860400002)(136003)(396003)(376002)(230273577357003)(230922051799003)(230173577357003)(186009)(64100799003)(82310400011)(1800799012)(451199024)(46966006)(36840700001)(40470700004)(7696005)(6666004)(478600001)(7636003)(356005)(426003)(47076005)(336012)(83380400001)(1076003)(2616005)(26005)(40480700001)(36860700001)(86362001)(70586007)(7416002)(41300700001)(110136005)(316002)(2876002)(54906003)(70206006)(8936002)(2906002)(8676002)(5660300002)(36756003)(4326008)(82740400003)(966005)(921008)(40460700003)(2101003)(83996005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2023 15:40:23.9811
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ef1661c-80a8-4f05-384e-08dc023b25db
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00026368.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9029

From: Ankit Agrawal <ankita@nvidia.com>

Currently, KVM for ARM64 maps at stage 2 memory that is considered device
with DEVICE_nGnRE memory attributes; this setting overrides (per
ARM architecture [1]) any device MMIO mapping present at stage 1,
resulting in a set-up whereby a guest operating system cannot
determine device MMIO mapping memory attributes on its own but
it is always overridden by the KVM stage 2 default.

This set-up does not allow guest operating systems to select device
memory attributes independently from KVM stage-2 mappings
(refer to [1], "Combining stage 1 and stage 2 memory type attributes"),
which turns out to be an issue in that guest operating systems
(e.g. Linux) may request to map devices MMIO regions with memory
attributes that guarantee better performance (e.g. gathering
attribute - that for some devices can generate larger PCIe memory
writes TLPs) and specific operations (e.g. unaligned transactions)
such as the NormalNC memory type.

The default device stage 2 mapping was chosen in KVM for ARM64 since
it was considered safer (i.e. it would not allow guests to trigger
uncontained failures ultimately crashing the machine) but this
turned out to be asynchronous (SError) defeating the purpose.

For these reasons, relax the KVM stage 2 device memory attributes
from DEVICE_nGnRE to Normal-NC.

Generalizing to other devices may be problematic, however. E.g.
GICv2 VCPU interface, which is effectively a shared peripheral, can
allow a guest to affect another guest's interrupt distribution. Hence
limit the change to VFIO PCI as caution. This is achieved by
making the VFIO PCI core module set a flag that is tested by KVM
to activate the code. This could be extended to other devices in
the future once that is deemed safe.

[1] section D8.5 - DDI0487J_a_a-profile_architecture_reference_manual.pdf

Applied over v6.7-rc3.

History
=======
v4 -> v5
- Moved the cover letter description text to patch 1/4.
- Cleaned up stage2_set_prot_attr() based on Marc Zyngier suggestions.
- Moved the mm header file changes to a separate patch.
- Rebased to v6.7-rc3.

v3 -> v4
- Moved the vfio-pci change to use the VM_VFIO_ALLOW_WC into
  separate patch.
- Added check to warn on the case NORMAL_NC and DEVICE are
  set simultaneously.
- Fixed miscellaneous nitpicks suggested in v3.

v2 -> v3
- Added a new patch (and converted to patch series) suggested by
  Catalin Marinas to ensure the code changes are restricted to
  VFIO PCI devices.
- Introduced VM_VFIO_ALLOW_WC flag for VFIO PCI to communicate
  with VMM.
- Reverted GIC mapping to DEVICE.

v1 -> v2
- Updated commit log to the one posted by
  Lorenzo Pieralisi <lpieralisi@kernel.org> (Thanks!)
- Added new flag to represent the NORMAL_NC setting. Updated
  stage2_set_prot_attr() to handle new flag.

v4 Link:
https://lore.kernel.org/all/20231218090719.22250-1-ankita@nvidia.com/

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Ankit Agrawal <ankita@nvidia.com>

Ankit Agrawal (4):
  kvm: arm64: introduce new flag for non-cacheable IO memory
  mm: introduce new flag to indicate wc safe
  kvm: arm64: set io memory s2 pte as normalnc for vfio pci devices
  vfio: convey kvm that the vfio-pci device is wc safe

 arch/arm64/include/asm/kvm_pgtable.h |  2 ++
 arch/arm64/include/asm/memory.h      |  2 ++
 arch/arm64/kvm/hyp/pgtable.c         | 23 ++++++++++++++++++-----
 arch/arm64/kvm/mmu.c                 | 18 ++++++++++++++----
 drivers/vfio/pci/vfio_pci_core.c     |  3 ++-
 include/linux/mm.h                   | 14 ++++++++++++++
 6 files changed, 52 insertions(+), 10 deletions(-)

-- 
2.17.1


