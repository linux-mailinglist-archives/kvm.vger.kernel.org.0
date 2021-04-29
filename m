Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDCB36EE28
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 18:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240866AbhD2Qal (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 12:30:41 -0400
Received: from mail-eopbgr770054.outbound.protection.outlook.com ([40.107.77.54]:54052
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240840AbhD2Qak (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 12:30:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oIZQeOGp1wG4bbGQ/yA0+rq8Ood54TxuWWGdr6y9iVLPoo/8r7mZLdrRYP9VFrUHzjk657nxyK/I3oOi+QI2Ra7lB4sO7j+4C4Ubq/5DwmLF5UNYWAWCXjrklufAA4FxgDFf7PI/e2zdSf83z/WRRl+Wlfp60+ColDg6bbDDoRwidbOBC/vuEN2lWEsbmDLpMxDTVkzgz5jahU8M5abImenGFTJhAXKDrc9rq/Eabw6efuHDSLC84eqFz16wj4cVeP69rkgfM3fx2UV2WVn3vn4wEawtNbERAAYfryfHuRcnHP/DpowVRXhqeON/RaEfVcB09+iepcmZD0wn6KMA2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mqjCQz1aAl+3oCXJ0GFv1eQOmvjcPEuyGJqSfvcQcVs=;
 b=I5YMJWCAuI11oN5j6/YYEZQym/5ELe2AJB0QNRAyCKJ4irj0d49noE7ffwK8oY8W77lRKWKq6noUJftPbJIzLuaS6fI8LeSF8rZEXTn5b7hP9HgtVtGXpKfm/DKdv35N2wA5ZvXvDVwYVoiTq1+D7W4QhNWNehSW+opQJ6QeCHxgiFWZpKYVHU4hDSnXh2sW5fLHI9SO0CyDJyVOB07V8R+23jjpkQbS6nXu23vJfxQsifyry6j2FUsRBoajJB9CgPgB4+0AMvEE953z3Wu1jRUGorQcEknJE4YXyQWNyJgHX/B0QCuCPriC+uhph0C737tV7rHIict08s/Uak17SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=lists.cs.columbia.edu
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mqjCQz1aAl+3oCXJ0GFv1eQOmvjcPEuyGJqSfvcQcVs=;
 b=q99WVDJIbk4l7LNt6kP9CZPY7r/D/wz2Bn3UHLlN8T6DZVvKZTMGg/Mb0mgXZ0wtIZ0JKQIrIpkyHATa3Mtf4shZ8sAkbRpAjoek3wOhKriJlbtJYAXTJvzsTmrPzlsn2bTrTpxS0ueyVvCuG+mBBsNOish+MZuA6/w5CnRA9wtJ1h1t9VC1qQ5y2XqdIo65Qj3Q6bp37CUCL7tJPtxlGwA3lplvU1+LG2xDb9XC0I/ArfDqycve5/M4cvYK0H64ig2maapZWngYZYVn3hNkD9oL/1HhHJDs6Quh1BExbAJ42cbg9bFJdD9gDbSksqJKBzW6j6eRpv905T3qdMFtfA==
Received: from DM6PR18CA0022.namprd18.prod.outlook.com (2603:10b6:5:15b::35)
 by DM5PR12MB2406.namprd12.prod.outlook.com (2603:10b6:4:b7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Thu, 29 Apr
 2021 16:29:51 +0000
Received: from DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:15b:cafe::33) by DM6PR18CA0022.outlook.office365.com
 (2603:10b6:5:15b::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend
 Transport; Thu, 29 Apr 2021 16:29:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; lists.cs.columbia.edu; dkim=none (message not
 signed) header.d=none;lists.cs.columbia.edu; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT038.mail.protection.outlook.com (10.13.173.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4087.32 via Frontend Transport; Thu, 29 Apr 2021 16:29:51 +0000
Received: from SDONTHINENI-DESKTOP.nvidia.com (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 29 Apr 2021 16:29:49 +0000
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
Subject: [RFC 2/2] KVM: arm64: Add write-combine support for stage-2 entries
Date:   Thu, 29 Apr 2021 11:29:06 -0500
Message-ID: <20210429162906.32742-3-sdonthineni@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210429162906.32742-1-sdonthineni@nvidia.com>
References: <20210429162906.32742-1-sdonthineni@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa1474c6-ad95-44d9-c2ef-08d90b2c0374
X-MS-TrafficTypeDiagnostic: DM5PR12MB2406:
X-Microsoft-Antispam-PRVS: <DM5PR12MB2406F4C6F64D0ECFB3917810C75F9@DM5PR12MB2406.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C+xJhH4LvRMPKgxJsUyK80U6IJ766e84tN1+nBcAHk8hjPZXAqi6I8iy6HbfnDMEVGdgBxd0HIF+Z3t2Y1fAIAQfwJJ0aNN2Fq1G0yfTy+aynpu5I504hJkRbPBvtpa73CwbSJzEYCPDheYHqq2CIzX2x8GX5Kb3kmrNiTJF8StRN6aMnv/9xUei8QLN0qowfVjKWYGYcA5StnxY5R0U8E7HuyZmiCvP6p8rpXp8KXjYBeKzSDPNtw3qbXfyBxXzEaN7k9WUEnGESzn9+dDzRPXJe/UkoZQY+Il7StM5MrBX13PI4itIpP9DNcHhUUP7Iey+0Vu2nEFScLwBH9qsMnjlwnp1+FaBDNiENnhTm0+9uM2HUPRDhZyMn96QxO1WrD1zGnNJibDUnvkH/3/Hh9rx6lzxJAKApm1JVEXtPdex+KXpcxGhC+2x3oHtQlA/Iax9puaznv1/ygszNGwL4PlShTwC2ahHTzRqLKL0WKVnVpqZoTqUCcTtLeZFxra6iI/mHjyEePaOo/g+2QfDgygzUTzxI6w50U2Cs718znGeNz8Gz73ZtsirDvlBEAFFUKtDbJbVBwdqiIQmTL6sZwxysBwvAsSOS95eI2Tbmhhj9F0TqYgmi/ru7tq24ZVGJ96LnSxgyUvxIa/2e/tMvd3p9TO0MGM9DXzyy3VAiZIx3z3+dg1gh4mcpg/nufkg
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(39860400002)(376002)(46966006)(36840700001)(83380400001)(478600001)(54906003)(2616005)(107886003)(110136005)(316002)(6666004)(82740400003)(36906005)(336012)(5660300002)(36860700001)(36756003)(8936002)(82310400003)(426003)(26005)(1076003)(16526019)(4326008)(8676002)(2906002)(7696005)(186003)(70586007)(86362001)(47076005)(70206006)(7636003)(356005)(19627235002)(3714002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2021 16:29:51.2946
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa1474c6-ad95-44d9-c2ef-08d90b2c0374
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2406
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the current implementation, the device memory is always mapped as
DEVICE_nGnRE in stage-2. In the host kernel, device drivers have
flexibility whether to choose a memory-type device or write-combine
(Non-cacheable) depends on the use case. PCI specification has a
prefetchable BAR concept where multiple writes can be combined and
no side effects on reads. It provides huge performance improvement
and also allows unaligned access.

NVIDIA GPU PCIe devices have 3 BAR regions. Two regions are mapped to
video/compute memory and marked as prefetchable. The GPU driver takes
advantage of the write-combine feature for higher performance. The
same driver has no issues in the host kernel but crashes inside the
virtual machine because of unaligned accesses.

This patch finds the PTE attributes for device memory in VMA. It
updates the stage-2 attribute to NORMAL_NC for WC regions and
the default type DEVICE_nGnRE for non-WC regions.

Change-Id: Ibaea69c7a301df3c86609e871f6d066728391080
Signed-off-by: Shanker Donthineni <sdonthineni@nvidia.com>
---
 arch/arm64/include/asm/kvm_mmu.h     |  3 ++-
 arch/arm64/include/asm/kvm_pgtable.h |  2 ++
 arch/arm64/include/asm/memory.h      |  4 +++-
 arch/arm64/kvm/hyp/pgtable.c         |  9 +++++++--
 arch/arm64/kvm/mmu.c                 | 21 ++++++++++++++++++---
 arch/arm64/kvm/vgic/vgic-v2.c        |  2 +-
 6 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 90873851f677..dec498a6ba2f 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -160,7 +160,8 @@ void stage2_unmap_vm(struct kvm *kvm);
 int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu);
 void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
-			  phys_addr_t pa, unsigned long size, bool writable);
+			  phys_addr_t pa, unsigned long size, bool writable,
+			  bool writecombine);
 
 int kvm_handle_guest_abort(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 8886d43cfb11..26f28220f6f3 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -35,6 +35,7 @@ struct kvm_pgtable {
  * @KVM_PGTABLE_PROT_W:		Write permission.
  * @KVM_PGTABLE_PROT_R:		Read permission.
  * @KVM_PGTABLE_PROT_DEVICE:	Device attributes.
+ * @KVM_PGTABLE_PROT_WC:	Normal non-cacheable (WC).
  */
 enum kvm_pgtable_prot {
 	KVM_PGTABLE_PROT_X			= BIT(0),
@@ -42,6 +43,7 @@ enum kvm_pgtable_prot {
 	KVM_PGTABLE_PROT_R			= BIT(2),
 
 	KVM_PGTABLE_PROT_DEVICE			= BIT(3),
+	KVM_PGTABLE_PROT_WC			= BIT(4),
 };
 
 #define PAGE_HYP		(KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W)
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 0aabc3be9a75..04a812b59437 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -144,13 +144,15 @@
  * Memory types for Stage-2 translation
  */
 #define MT_S2_NORMAL		0xf
+#define MT_S2_WRITE_COMBINE	5
 #define MT_S2_DEVICE_nGnRE	0x1
 
 /*
  * Memory types for Stage-2 translation when ID_AA64MMFR2_EL1.FWB is 0001
- * Stage-2 enforces Normal-WB and Device-nGnRE
+ * Stage-2 enforces Normal-WB, Normal-NC and Device-nGnRE
  */
 #define MT_S2_FWB_NORMAL	6
+#define MT_S2_FWB_WRITE_COMBINE	5
 #define MT_S2_FWB_DEVICE_nGnRE	1
 
 #ifdef CONFIG_ARM64_4K_PAGES
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 926fc07074f5..bdfed559eae2 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -444,9 +444,14 @@ static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
 				    struct stage2_map_data *data)
 {
 	bool device = prot & KVM_PGTABLE_PROT_DEVICE;
-	kvm_pte_t attr = device ? PAGE_S2_MEMATTR(DEVICE_nGnRE) :
-			    PAGE_S2_MEMATTR(NORMAL);
 	u32 sh = KVM_PTE_LEAF_ATTR_LO_S2_SH_IS;
+	kvm_pte_t attr = PAGE_S2_MEMATTR(NORMAL);
+
+	if (device) {
+		attr = (prot & KVM_PGTABLE_PROT_WC) ?
+			PAGE_S2_MEMATTR(WRITE_COMBINE) :
+			PAGE_S2_MEMATTR(DEVICE_nGnRE);
+	}
 
 	if (!(prot & KVM_PGTABLE_PROT_X))
 		attr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8711894db8c2..5b8ec1ab12e2 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -487,6 +487,16 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 	}
 }
 
+/**
+ * is_vma_write_combine - check if VMA is mapped with writecombine or not
+ * Return true if VMA mapped with MT_NORMAL_NC otherwise fasle
+ */
+static bool inline is_vma_write_combine(struct vm_area_struct *vma)
+{
+	pteval_t pteval = pgprot_val(vma->vm_page_prot);
+	return ((pteval & PTE_ATTRINDX_MASK) == PTE_ATTRINDX(MT_NORMAL_NC));
+}
+
 /**
  * kvm_phys_addr_ioremap - map a device range to guest IPA
  *
@@ -495,9 +505,11 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
  * @pa:		The physical address of the device
  * @size:	The size of the mapping
  * @writable:   Whether or not to create a writable mapping
+ * @writecombine: Whether or not to create a writecombine mapping
  */
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
-			  phys_addr_t pa, unsigned long size, bool writable)
+			  phys_addr_t pa, unsigned long size, bool writable,
+			  bool writecombine)
 {
 	phys_addr_t addr;
 	int ret = 0;
@@ -505,6 +517,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
 				     KVM_PGTABLE_PROT_R |
+				     (writecombine ? KVM_PGTABLE_PROT_WC : 0) |
 				     (writable ? KVM_PGTABLE_PROT_W : 0);
 
 	size += offset_in_page(guest_ipa);
@@ -891,7 +904,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 	if (device)
-		prot |= KVM_PGTABLE_PROT_DEVICE;
+		prot |= KVM_PGTABLE_PROT_DEVICE |
+			(is_vma_write_combine(vma) ? KVM_PGTABLE_PROT_WC : 0);
 	else if (cpus_have_const_cap(ARM64_HAS_CACHE_DIC))
 		prot |= KVM_PGTABLE_PROT_X;
 
@@ -1357,7 +1371,8 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 
 			ret = kvm_phys_addr_ioremap(kvm, gpa, pa,
 						    vm_end - vm_start,
-						    writable);
+						    writable,
+						    is_vma_write_combine(vma));
 			if (ret)
 				break;
 		}
diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 11934c2af2f4..6f921efea6c0 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -336,7 +336,7 @@ int vgic_v2_map_resources(struct kvm *kvm)
 	if (!static_branch_unlikely(&vgic_v2_cpuif_trap)) {
 		ret = kvm_phys_addr_ioremap(kvm, dist->vgic_cpu_base,
 					    kvm_vgic_global_state.vcpu_base,
-					    KVM_VGIC_V2_CPU_SIZE, true);
+					    KVM_VGIC_V2_CPU_SIZE, true, false);
 		if (ret) {
 			kvm_err("Unable to remap VGIC CPU to VCPU\n");
 			return ret;
-- 
2.17.1

