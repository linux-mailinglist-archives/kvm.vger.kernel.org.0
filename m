Return-Path: <kvm+bounces-4697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 93500816961
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 10:09:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0E1BEB20BD1
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 09:09:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 974231549B;
	Mon, 18 Dec 2023 09:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lCNevV9/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5FD14F7C;
	Mon, 18 Dec 2023 09:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AqWMx12MNPceA8nR6z8ovY0jco9bENHZthL7Av50OT/i2pYQkxZw4v5dsraNVUp0K9Pu/HgQxz6jgd1YYB6G6jaZEWbJ7x5LEk5kjNUa6m9X9mqX+dXVXbh4z16QkcuV/UPb0hTbi6aJaJS0u+ojKyJbLV9wuKLPG28hwyn+hUzYYUOC8iu0JvHe8A+1LRPSiQHyF8IJByUsJPSq2b4sL3qitL8L5RmOFT1iBO33knjD6WGNlWb1pVQE6eXqq7f8NaKsKiUIXt3PnSDto631EIkk54OwYCPGUIMHLDgYJryaMb0Br4SghvmKOqpDFo7oDidRu1gO5f3F8Y22xJ36kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FeETJ5iT+sTJLpG2UXVLsMFOj1QTOkoM4Fp0BcTnX9g=;
 b=OpWXVGFENJ3vhQ6XpU65AMttTpxvyf0kkKl665DirUlofvZeO3fhVHlGMtuWiuqSgWANmNWUrDScRbpKxs4NSNEBGy7pr1qCGlIy9upiRaMP5V1gO0aYLaMd3EdHubfTCEWlIMvB/dWDDBp0bhr//Vdz6LWzUlHF2ZvKHaQXBoKltXDls+lK3rFy2kW12Oa0fF0c69yniqhim2MoKfJMM58hTEg1mtyTtLoCTNHCljwa2h9numPSKq69Fg4iwk12YPahzfUCaEfNf5K+UDynA7yzNHnEiUC+UOgECI7CD2FrvI3ZnqmBV8Fz75o99qTt5KCUtWxHNPZ3Wza7+Q5gRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FeETJ5iT+sTJLpG2UXVLsMFOj1QTOkoM4Fp0BcTnX9g=;
 b=lCNevV9/dKLgLGso6VOyamfwsGEZ6nt4plLRhsneIuqVW5/JpF/LaU9CXpXaB1oR/uQL0z9kjGnxg3tKBiSb8NabiBP4pLj3NKv8zb3fykc+WEosukTeXuPdqpcJ1KjpwjPlLYGlEPSHCFIKki/AKsfS1Gq3O/D9ZnurAIBys70AdBdRxUTiYlbnK7iIp1ySEk4fy0oIsde8eKvISHXXqkSsptqhQBkESy1UVFnUFBaY8b2J+eJgFuh9pNO9wZSBv9TjrKdsjIPp8WTT1Gwc1v0gTb7pH82Ho5l08NBfpkP/I09LGTle3XtRH9UgB61X6Et6Jhr5Eap8xeQo+bdiyQ==
Received: from SN7PR04CA0064.namprd04.prod.outlook.com (2603:10b6:806:121::9)
 by DS0PR12MB8270.namprd12.prod.outlook.com (2603:10b6:8:fe::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38; Mon, 18 Dec
 2023 09:07:41 +0000
Received: from SN1PEPF0002BA4E.namprd03.prod.outlook.com
 (2603:10b6:806:121:cafe::31) by SN7PR04CA0064.outlook.office365.com
 (2603:10b6:806:121::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.37 via Frontend
 Transport; Mon, 18 Dec 2023 09:07:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF0002BA4E.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Mon, 18 Dec 2023 09:07:41 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 18 Dec
 2023 01:07:30 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 18 Dec
 2023 01:07:29 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Mon, 18 Dec 2023 01:07:21 -0800
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
Subject: [PATCH v4 0/3] kvm: arm64: allow the VM to select DEVICE_* and NORMAL_NC for IO memory
Date: Mon, 18 Dec 2023 14:37:16 +0530
Message-ID: <20231218090719.22250-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4E:EE_|DS0PR12MB8270:EE_
X-MS-Office365-Filtering-Correlation-Id: 32de3081-8508-4c58-0cf3-08dbffa8ca3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Kv2KJL93FsOQJYDl7jQAEWDuzHmAXo0PC9iVSVlLTG/wtJPKShaSkncfHLdh0u46WJXWjXP1uOA8kmdITd2f4hTzi8Bc1+Q0UkUH8q0Hc3tUS3lR56aQ0xy/oFJdbhO5jEwgf7uRuZynAE3roCbaOKSlKS86fycwKg4HUzGfv1ypqHCKY67v0eGtchQBeS/8xhUl18UPgtGOWj2czZqD6zktLHFm/i6BRrYwOsITNnQ/uXvCldWt+vXql6UyXoGTp9uJPFqUsRdq9R6ym0IOCaZkbLDZnB/jBpsfLnNs+YrsIsQWRa6hYLKHzVOQc1MbzSju0/WKJ08Ickm0IL8cr0b3/dCAV4LHZVIKFyQ4QnYON9M9AJ5bY6ALH6eZQCSksM5jsRSdf2S2GJEkgbx5fJA/m+UJHllbnHby9sIdm8K45+IeOljWBM74yfdP4XuBj1SRI7mZh5yFCWs29a8HR70I/0/+vnunFWbC2qBdCOEUeIO0H9V82gPS6tX+G/OvFTgpl0oUvtZYeae96tPEHH+zd8j9mlNz4cZ4Hjrcsem0eqwbR1YPuotcpZ+fUYOxehoDSdb9kgmUa7ck4omOeFDT07PUOjL3wtGNCSqCs2skpF2hXJgFEQ46nR+rU6O0EPmdGoWoUj7/RqoS/Fb/hlI23FDVPAICPLxkygTMh9ceTCR9tzXemn1T70EJt+ASfqNVv0qTl9IAehGUrcuc4hDgbBdIn8W/4lTojH5J6A7P8FLalDEK+iJds3PF0s6vjUrSwdz7F51C/XkrdSE3+NJnqJjjmZbRI/DFSmhCHtH18KJPEf+GswVmGNk9MHxJAuOGiJfgZLnatEZAhcX/mdXcTaX2VkwXCNAICt46N7LoHmJJp2PIwH1Eubw0FPeV7CfeAGr2b7I5QelPkgvZ7/PSX98Ax8kJMkHzW/ZFlqA=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(39860400002)(396003)(136003)(376002)(230173577357003)(230922051799003)(230273577357003)(1800799012)(186009)(82310400011)(64100799003)(451199024)(36840700001)(46966006)(40470700004)(921008)(40480700001)(40460700003)(70206006)(70586007)(7636003)(356005)(82740400003)(36756003)(86362001)(36860700001)(1076003)(336012)(26005)(426003)(83380400001)(2616005)(7696005)(7416002)(2906002)(2876002)(316002)(8676002)(8936002)(54906003)(110136005)(6666004)(966005)(478600001)(5660300002)(47076005)(41300700001)(4326008)(21314003)(2101003)(83996005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2023 09:07:41.4197
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32de3081-8508-4c58-0cf3-08dbffa8ca3a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8270

From: Ankit Agrawal <ankita@nvidia.com>

Currently, KVM for ARM64 maps at stage 2 memory that is considered device
(i.e. it is not RAM) with DEVICE_nGnRE memory attributes; this setting
overrides (as per the ARM architecture [1]) any device MMIO mapping
present at stage 1, resulting in a set-up whereby a guest operating
system cannot determine device MMIO mapping memory attributes on its
own but it is always overridden by the KVM stage 2 default.

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

Failures containability is a property of the platform and is independent
from the memory type used for MMIO device memory mappings.

Actually, DEVICE_nGnRE memory type is even more problematic than
Normal-NC memory type in terms of faults containability in that e.g.
aborts triggered on DEVICE_nGnRE loads cannot be made, architecturally,
synchronous (i.e. that would imply that the processor should issue at
most 1 load transaction at a time - it cannot pipeline them - otherwise
the synchronous abort semantics would break the no-speculation attribute
attached to DEVICE_XXX memory).

This means that regardless of the combined stage1+stage2 mappings a
platform is safe if and only if device transactions cannot trigger
uncontained failures and that in turn relies on platform capabilities
and the device type being assigned (i.e. PCIe AER/DPC error containment
and RAS architecture[3]); therefore the default KVM device stage 2
memory attributes play no role in making device assignment safer
for a given platform (if the platform design adheres to design
guidelines outlined in [3]) and therefore can be relaxed.

For all these reasons, relax the KVM stage 2 device memory attributes
from DEVICE_nGnRE to Normal-NC.

The NormalNC was chosen over a different Normal memory type default
at stage-2 (e.g. Normal Write-through) to avoid cache allocation/snooping.

Relaxing S2 KVM device MMIO mappings to Normal-NC is not expected to
trigger any issue on guest device reclaim use cases either (i.e. device
MMIO unmap followed by a device reset) at least for PCIe devices, in that
in PCIe a device reset is architected and carried out through PCI config
space transactions that are naturally ordered with respect to MMIO
transactions according to the PCI ordering rules.

Having Normal-NC S2 default puts guests in control (thanks to
stage1+stage2 combined memory attributes rules [1]) of device MMIO
regions memory mappings, according to the rules described in [1]
and summarized here ([(S1) - stage1], [(S2) - stage 2]):

S1           |  S2           | Result
NORMAL-WB    |  NORMAL-NC    | NORMAL-NC
NORMAL-WT    |  NORMAL-NC    | NORMAL-NC
NORMAL-NC    |  NORMAL-NC    | NORMAL-NC
DEVICE<attr> |  NORMAL-NC    | DEVICE<attr>

It is worth noting that currently, to map devices MMIO space to user
space in a device pass-through use case the VFIO framework applies memory
attributes derived from pgprot_noncached() settings applied to VMAs, which
result in device-nGnRnE memory attributes for the stage-1 VMM mappings.

This means that a userspace mapping for device MMIO space carried
out with the current VFIO framework and a guest OS mapping for the same
MMIO space may result in a mismatched alias as described in [2].

Defaulting KVM device stage-2 mappings to Normal-NC attributes does not
change anything in this respect, in that the mismatched aliases would
only affect (refer to [2] for a detailed explanation) ordering between
the userspace and GuestOS mappings resulting stream of transactions
(i.e. it does not cause loss of property for either stream of
transactions on its own), which is harmless given that the userspace
and GuestOS access to the device is carried out through independent
transactions streams.

Generalizing to other devices may be problematic. E.g. GICv2 VCPU
interface, which is effectively a shared peripheral, can allow a
guest to affect another guest's interrupt distribution. Hence
limit the change to VFIO PCI as caution. This is achieved by
making the VFIO PCI core module set a flag that is tested by KVM
to activate the code. This could be extended to other devices in
the future once that is deemed safe.

[1] section D8.5 - DDI0487J_a_a-profile_architecture_reference_manual.pdf
[2] section B2.8 - DDI0487J_a_a-profile_architecture_reference_manual.pdf
[3] sections 1.7.7.3/1.8.5.2/appendix C - DEN0029H_SBSA_7.1.pdf

Applied over next-20231211

History
=======
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

v3 Link:
https://lore.kernel.org/all/20231208164709.23101-1-ankita@nvidia.com/

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Ankit Agrawal <ankita@nvidia.com>

Ankit Agrawal (3):
  kvm: arm64: introduce new flag for non-cacheable IO memory
  kvm: arm64: set io memory s2 pte as normalnc for vfio pci devices
  vfio: convey kvm that the vfio-pci device is wc safe

 arch/arm64/include/asm/kvm_pgtable.h |  2 ++
 arch/arm64/include/asm/memory.h      |  2 ++
 arch/arm64/kvm/hyp/pgtable.c         | 13 +++++++++++--
 arch/arm64/kvm/mmu.c                 | 18 ++++++++++++++----
 drivers/vfio/pci/vfio_pci_core.c     |  3 ++-
 include/linux/mm.h                   | 13 +++++++++++++
 6 files changed, 44 insertions(+), 7 deletions(-)

-- 
2.17.1


