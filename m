Return-Path: <kvm+bounces-5089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5934681BB29
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 16:44:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C2A34B2169A
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 15:44:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDDD558233;
	Thu, 21 Dec 2023 15:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZfHQT5WG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2086.outbound.protection.outlook.com [40.107.100.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6BB55E73;
	Thu, 21 Dec 2023 15:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KSWsejvyhGo6g7zwc2XKxJ3Qh/TTuc0IZpCs2wOhjU/mX9NcAP49i7sJ8MUFmjra9Ab/y1NPErBt1afinzaCp+mDCG6vfj9TDzUZie41SYEvKWVaCJvIkyWdPOQ8L0NFvfaUYioCGuzIN6M4om5Jx5RzxSW2gu6qo9RBizhqCTvIKTWS48EMm0noTFi3/ivHhH3USrcWHEcfAXjDgp6nwy1IEKvgI2vtCX+7H6lgthSM5JFdc12ua2wVt2EL+snywKIahupMHq+hIKCdYIqttCUJVlGCwNsWyqxNiUA5CRJeY57SLxdMB1fQdBbDp1LEtfBe2MdpVIWcaTpJ3RGF9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XqhY2soov2oX7haEDXfeTbYFAxvPDDLI3gnNdLnzU+A=;
 b=RD1AzpEA4AQIq7XEtiYns0b9FtV4/IPclunT456uZNDkS+oDLrLZs9Gsd048ZLbFJDf4OdQHIZ1iGGF2qA6lTduaR42jXlt554Ea+om2HDaGgbCT2fkDMX8AnszARyixvxVrzgp0KSAF2/0BwOsvwP2o0ao1PmQPPFKohvp1Huuf9pF14ExOJ79ba1iBQP6oiETwGuchDuuIfcOlpSDnDSASrhQg41ZVWaLjgm/lTJs/An/ONBJ4CiEfrbfuZBqNsv18/hAzH4QBVhBFC1HMp/DzjEJUpyRs5b2FDxYrky4YdVSmrc1FFIJ4w12x0ssTUrhk8uUsdykKde96X6eYzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XqhY2soov2oX7haEDXfeTbYFAxvPDDLI3gnNdLnzU+A=;
 b=ZfHQT5WGi56DQwp6c0q8Weenv9OdLARVbcengg+1Zi25eEKzgMQsd+A4WnDG9xbJ9ze1WnMybeyyIFuyNAldoTEeDe0DJUFteisxSVANAkCZeoPoiKg4mzuwTh3Zy+A6tffWt+V1tEE+SWp+JzURlVoBP4a6XcUz7+q+vu004Iq+3F9cUMDa6PkSnGzzoifVmY11Dfanblt8ZzZ95LKs99S1XxnsxHsEsZcYwEsyWlWhL5/fRFGAVVqirItn4KZNg47hVAp7O+qvDiQ44PpmVOMj8B/OxK2o9TktoXl648h+BBP0B9XlBAEBXsU4sLhIh8a8d+8iRXAE0ZKfHebOHw==
Received: from MN2PR01CA0061.prod.exchangelabs.com (2603:10b6:208:23f::30) by
 SJ0PR12MB5609.namprd12.prod.outlook.com (2603:10b6:a03:42c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18; Thu, 21 Dec
 2023 15:40:41 +0000
Received: from MN1PEPF0000ECDA.namprd02.prod.outlook.com
 (2603:10b6:208:23f:cafe::b0) by MN2PR01CA0061.outlook.office365.com
 (2603:10b6:208:23f::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.21 via Frontend
 Transport; Thu, 21 Dec 2023 15:40:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000ECDA.mail.protection.outlook.com (10.167.242.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Thu, 21 Dec 2023 15:40:40 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 21 Dec
 2023 07:40:23 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 21 Dec
 2023 07:40:22 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Thu, 21 Dec 2023 07:40:14 -0800
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
Subject: [PATCH v5 1/4] kvm: arm64: introduce new flag for non-cacheable IO memory
Date: Thu, 21 Dec 2023 21:09:59 +0530
Message-ID: <20231221154002.32622-2-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDA:EE_|SJ0PR12MB5609:EE_
X-MS-Office365-Filtering-Correlation-Id: 186301d9-cbac-41e2-c1a5-08dc023b2fc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ef6AWW8Vtngp0XQfwr87/WPcyE9fL2+PvLLsDNQ0X8Guh2dRpFDDWtTn5efcRUfrnLcObEKQljYDV4UCS+Ah7iKypyyjF6hlUT6YODyIaxh87vnV2hqfv7sewViJtCSwFmL7aP4csc5MVcnGu1E8+8jIQZ7s0Z+zFc6D7VM/qP/mWjMH0A5PHV/rZrtVvp15vsz8+j10ypCmeMH4KtWEFX1Az+JSM/s55YNXS6dmacPbsu295kZ4h67cUn3M52KrsUHxsIOVK1NCKQcOs5TySShvJH1Wuzu1EhKnIzdct+oUjgV5srn5BBRehFJLd3pnf6+v2uijJGpCHgltWIdwvzNUeNlTqGdkiQ6AjdBVXioPfyXoFTBH3QZaCLFiqgr0wCRiLxgE4TJOkIK51CAaFT+I3XdHjOooMBHm+/ygDFGbDErIgp82GNS3abVZatCXMwwGb2mHhv0W3DCUl4jGMwB7XaWU0ikm0qXn/q+aY+Javxx1ZBtFsX+h5ZgyKz3uI/kJPqRkf3TMxeQYpn0kc9cU5Xh4uFr0VqQc1MZzcAmm+m7vkiVI9D/vq5uWoXn6cjkaZT1C+yuQiNzEs1d+foulKvyKq6/MQNWgQr2x+l5Xej+v02LY08zU78l2tNfRvbUuTK0lllXPfhK2Qikf56fEOMoBwUW+oguM9vD8M3AuufKAZqKrZnqr9GoVd0bjx9POUuGQNjixFR7NPBjnSTyG5FqLkXQKJQ8krS2rh31uufEPzDXoVBDYQ11if6wzfowRNKhU5DxAgAvSbq8UKAXGlMqexzd7IAVMZO9uWUd1KMFlfLMWLE8Rl4EaOAclWUQKG7z4iidOXJ/D8LzIIQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(346002)(136003)(396003)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(82310400011)(36840700001)(40470700004)(46966006)(2876002)(2906002)(478600001)(47076005)(2616005)(5660300002)(7416002)(83380400001)(6666004)(36756003)(86362001)(7696005)(26005)(1076003)(36860700001)(41300700001)(921008)(336012)(8936002)(8676002)(40480700001)(54906003)(316002)(82740400003)(7636003)(110136005)(19627235002)(356005)(4326008)(70586007)(70206006)(426003)(40460700003)(21314003)(2101003)(83996005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2023 15:40:40.5289
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 186301d9-cbac-41e2-c1a5-08dc023b2fc1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECDA.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5609

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

A Normal-NC flag is not present today. So add a new kvm_pgtable_prot
(KVM_PGTABLE_PROT_NORMAL_NC) flag for it, along with its
corresponding PTE value 0x5 (0b101) determined from [1].

Lastly, adapt the stage2 PTE property setter function
(stage2_set_prot_attr) to handle the NormalNC attribute.

[1] section D8.5.5 - DDI0487J_a_a-profile_architecture_reference_manual.pdf
[2] section B2.8 - DDI0487J_a_a-profile_architecture_reference_manual.pdf
[3] sections 1.7.7.3/1.8.5.2/appendix C - DEN0029H_SBSA_7.1.pdf

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Ankit Agrawal <ankita@nvidia.com>

---
 arch/arm64/include/asm/kvm_pgtable.h |  2 ++
 arch/arm64/include/asm/memory.h      |  2 ++
 arch/arm64/kvm/hyp/pgtable.c         | 23 ++++++++++++++++++-----
 3 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index d3e354bb8351..de0b8845df7a 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -169,6 +169,7 @@ enum kvm_pgtable_stage2_flags {
  * @KVM_PGTABLE_PROT_W:		Write permission.
  * @KVM_PGTABLE_PROT_R:		Read permission.
  * @KVM_PGTABLE_PROT_DEVICE:	Device attributes.
+ * @KVM_PGTABLE_PROT_NORMAL_NC:	Normal noncacheable attributes.
  * @KVM_PGTABLE_PROT_SW0:	Software bit 0.
  * @KVM_PGTABLE_PROT_SW1:	Software bit 1.
  * @KVM_PGTABLE_PROT_SW2:	Software bit 2.
@@ -180,6 +181,7 @@ enum kvm_pgtable_prot {
 	KVM_PGTABLE_PROT_R			= BIT(2),
 
 	KVM_PGTABLE_PROT_DEVICE			= BIT(3),
+	KVM_PGTABLE_PROT_NORMAL_NC		= BIT(4),
 
 	KVM_PGTABLE_PROT_SW0			= BIT(55),
 	KVM_PGTABLE_PROT_SW1			= BIT(56),
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index fde4186cc387..c247e5f29d5a 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -147,6 +147,7 @@
  * Memory types for Stage-2 translation
  */
 #define MT_S2_NORMAL		0xf
+#define MT_S2_NORMAL_NC		0x5
 #define MT_S2_DEVICE_nGnRE	0x1
 
 /*
@@ -154,6 +155,7 @@
  * Stage-2 enforces Normal-WB and Device-nGnRE
  */
 #define MT_S2_FWB_NORMAL	6
+#define MT_S2_FWB_NORMAL_NC	5
 #define MT_S2_FWB_DEVICE_nGnRE	1
 
 #ifdef CONFIG_ARM64_4K_PAGES
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 1966fdee740e..8ffd31e0b9b5 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -695,15 +695,28 @@ void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
 static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot prot,
 				kvm_pte_t *ptep)
 {
-	bool device = prot & KVM_PGTABLE_PROT_DEVICE;
-	kvm_pte_t attr = device ? KVM_S2_MEMATTR(pgt, DEVICE_nGnRE) :
-			    KVM_S2_MEMATTR(pgt, NORMAL);
+	kvm_pte_t attr;
 	u32 sh = KVM_PTE_LEAF_ATTR_LO_S2_SH_IS;
 
+	switch (prot & (KVM_PGTABLE_PROT_DEVICE |
+			KVM_PGTABLE_PROT_NORMAL_NC)) {
+	case 0:
+		attr = KVM_S2_MEMATTR(pgt, NORMAL);
+		break;
+	case KVM_PGTABLE_PROT_DEVICE:
+		if (prot & KVM_PGTABLE_PROT_X)
+			return -EINVAL;
+		attr = KVM_S2_MEMATTR(pgt, DEVICE_nGnRE);
+		break;
+	case KVM_PGTABLE_PROT_NORMAL_NC:
+		attr = KVM_S2_MEMATTR(pgt, NORMAL_NC);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+	}
+
 	if (!(prot & KVM_PGTABLE_PROT_X))
 		attr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
-	else if (device)
-		return -EINVAL;
 
 	if (prot & KVM_PGTABLE_PROT_R)
 		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
-- 
2.17.1


