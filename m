Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 207B62AB713
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 12:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730071AbgKILem (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 06:34:42 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:44538 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730020AbgKILea (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 06:34:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1604921670; x=1636457670;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Pykd3u/h8Qxjga2KWdrLf4qc8Ji9IMnR6vF9hX7FV0s=;
  b=kof6bfZQE3ZdZvo1oViFn0WmL/O8h05rrv/LEhrerOOrzTe3feSuxZsD
   F5Pv31cnhDDTZftMlK+sOBIhTxYqnHhPE1GQ4F/9D2iYebIl4vLwURV9O
   jtR8iQkx9FNtEarY8tL6IXdWMc67gmDvMybouJFQKwHY930HVRnwHs19U
   IgC61Hs49BqskqYe1KfW2o6PG2Xz6BR4n1PLnwsyKJRlwms1WYCyz/adr
   ogTpzGd+mII0bGRinUVb+cdV4xHh1wdgRE7GtD+b+ULI5L1hhxacm+evA
   Ns5Kuqnsxb3l9yWOu+tPdx65oifud/Bf/IHIwWKbzAd60QtR56u1d4Jo2
   g==;
IronPort-SDR: xrlMA1ea9BdCvG/iuLJlHVU5sEVFcuBUimAtuPtxeaPPEJzIyTdFdrMjcYpL8QCsgXp9/LTC2c
 DENet4YS3NBWa0iD4yzqqqT+S027Uu8GJdD+JfH7+NMU/27ZySRgklVrzH069mmhkIP7qivZOS
 c2rtg5LH0Fk2d0FDHV6ADLGFPqSHqzk4SFpMwkhroX9VuGwLgbZq6FPKewY04Pl+ZWR8oCD4Ut
 cdJnDXjiP9mPqbWLZw+8B1eTxF1TM2/ofTISWjylzQCnApYRPo41lxmFV15+ZNg0KyZLCZ+F1+
 rOU=
X-IronPort-AV: E=Sophos;i="5.77,463,1596470400"; 
   d="scan'208";a="262186948"
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2020 19:34:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NwReIPW15NZ+4svwaQCxOjme8TsFpBaozZXeVUQJddx6KWaeweLe6ayxHFvhR4SZXFU4B1C0XMLqbBg4J1i3UTc3aTJDabntOTOhWZcpOOxQ6UEuYUCcKW0kygsmv993BLHXxgE5ZfqPVRDDhGu1ZUrGQesW+3PAljiM3QPHA62o3NL97WFJnKnq400XIvFWmxYR4s4aRrDJ4nF/62hj/IAFo7oR6BSCD7njmJE+tWkfH/Z9umEjjoradRmpF+ekdxq4J/mb2UnZuUoy5up4Ef+KAXka7dJ+B8izLIfMEWvP55XgsV53SGVJ0WcCKQLwtDvpcnYqfjgKIKLHPCMg4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hZiGFPX9Y4ELrKEriqJKBZJ0PkTDMiSMV6UVrg1QdLI=;
 b=Z1hXbgyVhz4EfAFqXdhPcEhVIOLQysbSOKxCTikREWNMeCyhkohasGF5If0R1VTLqFa25BOK+yr9eYMj6i5jrxY/ac8VIAnPlIefZuXMiEeSW2XCDjELI/3UtYya+6oOSwvcgXNRT6RsEQ0HxVEwyNFHRz6K3I6DeZ+t358RnrntXcdHBaJ0M+6dUJYLvuxV9bwLMBUH5K5d36rGEPo1GbL9yKbEiNPxHwh1hoHLBQbmCrU4mn54qGlwjwn3JPfaCz6pHKclSlTEi1OOXYMkScjmRl9bGPK7uQkevwPlDNXo9QnilJb1kowZ6Fv3A0NCu2A8jljcOAna4qMbhpyemg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hZiGFPX9Y4ELrKEriqJKBZJ0PkTDMiSMV6UVrg1QdLI=;
 b=gh50cSd1RnNyVZ19R8f9patQFnXmTn2lEy6MOfxJDKcxNnhH8z4OLdw7PqeWqfxRNEiCHXooY1ckfZfhgysnmBWcyfS5/pDUEug3tvzw0mshws4QjBeuJOyeTqH4kOlzTNWFv1J1VQBLQoWLK0bFO9Q5pxgJ0T5jo+7M+921SJM=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB3866.namprd04.prod.outlook.com (2603:10b6:5:ad::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Mon, 9 Nov
 2020 11:34:27 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::d035:e2c6:c11:51dd]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::d035:e2c6:c11:51dd%6]) with mapi id 15.20.3541.025; Mon, 9 Nov 2020
 11:34:27 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v15 11/17] RISC-V: KVM: Implement MMU notifiers
Date:   Mon,  9 Nov 2020 17:02:34 +0530
Message-Id: <20201109113240.3733496-12-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201109113240.3733496-1-anup.patel@wdc.com>
References: <20201109113240.3733496-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.171.188.68]
X-ClientProxiedBy: MAXPR01CA0099.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:5d::17) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.171.188.68) by MAXPR01CA0099.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:5d::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 11:34:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1d18d3b1-1b26-4b7a-a666-08d884a36a7f
X-MS-TrafficTypeDiagnostic: DM6PR04MB3866:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB3866CC3F42AE2B57611CE8478DEA0@DM6PR04MB3866.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ScsysJLYa3bvBk8kADkEq52xthFK1EQmmtiruAbjoXgHnTQrOogNXK1jVbQQy93CZXRUgiz3/Jk04jerd8IU//2yiJW+4dZhLfMH+EQoRwLIyhkznwUgiceS3REaw7Ng59C/hmqfXA8e+pxz8pSr8FPuWYt1crCaZUtbhNlq1l02ekA4A2WDu3yERkwThLzTF0qQIgzs+SIi9jDW6V+yA0ntIxcoHJwUhf++M6x9hf6Coq89PEVtHawqSSsgLt8ATBIw8F1m7L6wa1LbxH8lO8qAU6bcAmaMO+Z5kzRCH26fQJCfYGLrkJw06fAkeZkJC48HpIvxb8fFtkV3uonNDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(55016002)(7416002)(83380400001)(1076003)(44832011)(16526019)(186003)(316002)(26005)(8676002)(110136005)(54906003)(5660300002)(52116002)(7696005)(956004)(2616005)(478600001)(66476007)(66556008)(4326008)(66946007)(6666004)(2906002)(36756003)(86362001)(8886007)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Zb9mLqNWcLlR/pn8CGCaVanXhkzvW5NuJEHR8bi3fEGy6hGrycqd5UJpaLz04lVXL3bqulxGJOAZa+o7EZx4hWJCr30A0l1YYrNd3hQDS20ESzzCdHpieDOEjWWxzbpGAWV2HMU4kGzIzBmk8AnQ4wgM5oM1dFY6xX/deU7/54T+SMITBpjG5V7FfxmlN+If38rKoB1drbxkUJw3C1GVocBTkbU9eKSyB8W7aN8TYrNmdBTvaM2DnWjk8Mznl1nilPFUCxjg5uCN+77VmENbASHWMWiWdFDCRVg2bhWe480FTOHeBQIZwfcA8VE0dfcHNB3dVPiwhDVFSBZj73XcZ2ObQ0vC+mDbeiqX9LVOF7tPSHrr8D7Xar7qQt+uCgsDVOfL1HaeEWYeqFdwLgXihJsJmJcnLpc5/loA4kyFamHwzpnoVFMb3uy3Z9OAL39QgBE44AmbnGXfTIaMlFszRDAXpTpIkLAYQQYNfm/RJYAIkSsUVROQhnjCXGCpi1aHXZ9cVyPw7t2KsDe3D+0R2CIodAD4DL1zvHKSrJtq9DTxN2I+X15hrc/9HwfW7c/U+c9Lt8BotQ27iQQYJgLjJ3oQB+jvWz2X+v7fChjPraYM33+iAc//SrVqdCitcx+OOzNBXhFefhD0sy20KnLzzg==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d18d3b1-1b26-4b7a-a666-08d884a36a7f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 11:34:27.6290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XghDn56WvsZm1B8UhQ6vhvn2VTLBZMXXobwxD1KGu6k+hdXDfMfOASYCUPn4ikoX3m2ry+D9GUuBSb7A5mO5Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB3866
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implements MMU notifiers for KVM RISC-V so that Guest
physical address space is in-sync with Host physical address space.

This will allow swapping, page migration, etc to work transparently
with KVM RISC-V.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 arch/riscv/include/asm/kvm_host.h |   7 ++
 arch/riscv/kvm/Kconfig            |   1 +
 arch/riscv/kvm/mmu.c              | 144 +++++++++++++++++++++++++++++-
 arch/riscv/kvm/vm.c               |   1 +
 4 files changed, 149 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 1c4c71e06e5b..64311b262ee1 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -203,6 +203,13 @@ static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
+#define KVM_ARCH_WANT_MMU_NOTIFIER
+int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start,
+			unsigned long end, unsigned int flags);
+int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
+int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
+int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
+
 void __kvm_riscv_hfence_gvma_vmid_gpa(unsigned long gpa, unsigned long vmid);
 void __kvm_riscv_hfence_gvma_vmid(unsigned long vmid);
 void __kvm_riscv_hfence_gvma_gpa(unsigned long gpa);
diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
index 633063edaee8..a712bb910cda 100644
--- a/arch/riscv/kvm/Kconfig
+++ b/arch/riscv/kvm/Kconfig
@@ -20,6 +20,7 @@ if VIRTUALIZATION
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support (EXPERIMENTAL)"
 	depends on RISCV_SBI && MMU
+	select MMU_NOTIFIER
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	select KVM_MMIO
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 39063d1372cb..fcaeadc9b34d 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -296,7 +296,8 @@ static void stage2_op_pte(struct kvm *kvm, gpa_t addr,
 	}
 }
 
-static void stage2_unmap_range(struct kvm *kvm, gpa_t start, gpa_t size)
+static void stage2_unmap_range(struct kvm *kvm, gpa_t start,
+			       gpa_t size, bool may_block)
 {
 	int ret;
 	pte_t *ptep;
@@ -321,6 +322,13 @@ static void stage2_unmap_range(struct kvm *kvm, gpa_t start, gpa_t size)
 
 next:
 		addr += page_size;
+
+		/*
+		 * If the range is too large, release the kvm->mmu_lock
+		 * to prevent starvation and lockup detector warnings.
+		 */
+		if (may_block && addr < end)
+			cond_resched_lock(&kvm->mmu_lock);
 	}
 }
 
@@ -404,6 +412,38 @@ int stage2_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
 
 }
 
+static int handle_hva_to_gpa(struct kvm *kvm,
+			     unsigned long start,
+			     unsigned long end,
+			     int (*handler)(struct kvm *kvm,
+					    gpa_t gpa, u64 size,
+					    void *data),
+			     void *data)
+{
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *memslot;
+	int ret = 0;
+
+	slots = kvm_memslots(kvm);
+
+	/* we only care about the pages that the guest sees */
+	kvm_for_each_memslot(memslot, slots) {
+		unsigned long hva_start, hva_end;
+		gfn_t gpa;
+
+		hva_start = max(start, memslot->userspace_addr);
+		hva_end = min(end, memslot->userspace_addr +
+					(memslot->npages << PAGE_SHIFT));
+		if (hva_start >= hva_end)
+			continue;
+
+		gpa = hva_to_gfn_memslot(hva_start, memslot) << PAGE_SHIFT;
+		ret |= handler(kvm, gpa, (u64)(hva_end - hva_start), data);
+	}
+
+	return ret;
+}
+
 void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 					     struct kvm_memory_slot *slot,
 					     gfn_t gfn_offset,
@@ -549,7 +589,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	spin_lock(&kvm->mmu_lock);
 	if (ret)
 		stage2_unmap_range(kvm, mem->guest_phys_addr,
-				   mem->memory_size);
+				   mem->memory_size, false);
 	spin_unlock(&kvm->mmu_lock);
 
 out:
@@ -557,6 +597,96 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	return ret;
 }
 
+static int kvm_unmap_hva_handler(struct kvm *kvm,
+				 gpa_t gpa, u64 size, void *data)
+{
+	unsigned int flags = *(unsigned int *)data;
+	bool may_block = flags & MMU_NOTIFIER_RANGE_BLOCKABLE;
+
+	stage2_unmap_range(kvm, gpa, size, may_block);
+	return 0;
+}
+
+int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start,
+			unsigned long end, unsigned int flags)
+{
+	if (!kvm->arch.pgd)
+		return 0;
+
+	handle_hva_to_gpa(kvm, start, end, &kvm_unmap_hva_handler, &flags);
+	return 0;
+}
+
+static int kvm_set_spte_handler(struct kvm *kvm,
+				gpa_t gpa, u64 size, void *data)
+{
+	pte_t *pte = (pte_t *)data;
+
+	WARN_ON(size != PAGE_SIZE);
+	stage2_set_pte(kvm, 0, NULL, gpa, pte);
+
+	return 0;
+}
+
+int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
+{
+	unsigned long end = hva + PAGE_SIZE;
+	kvm_pfn_t pfn = pte_pfn(pte);
+	pte_t stage2_pte;
+
+	if (!kvm->arch.pgd)
+		return 0;
+
+	stage2_pte = pfn_pte(pfn, PAGE_WRITE_EXEC);
+	handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &stage2_pte);
+
+	return 0;
+}
+
+static int kvm_age_hva_handler(struct kvm *kvm,
+				gpa_t gpa, u64 size, void *data)
+{
+	pte_t *ptep;
+	u32 ptep_level = 0;
+
+	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PGDIR_SIZE);
+
+	if (!stage2_get_leaf_entry(kvm, gpa, &ptep, &ptep_level))
+		return 0;
+
+	return ptep_test_and_clear_young(NULL, 0, ptep);
+}
+
+int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
+{
+	if (!kvm->arch.pgd)
+		return 0;
+
+	return handle_hva_to_gpa(kvm, start, end, kvm_age_hva_handler, NULL);
+}
+
+static int kvm_test_age_hva_handler(struct kvm *kvm,
+				    gpa_t gpa, u64 size, void *data)
+{
+	pte_t *ptep;
+	u32 ptep_level = 0;
+
+	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE);
+	if (!stage2_get_leaf_entry(kvm, gpa, &ptep, &ptep_level))
+		return 0;
+
+	return pte_young(*ptep);
+}
+
+int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
+{
+	if (!kvm->arch.pgd)
+		return 0;
+
+	return handle_hva_to_gpa(kvm, hva, hva,
+				 kvm_test_age_hva_handler, NULL);
+}
+
 int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 			 struct kvm_memory_slot *memslot,
 			 gpa_t gpa, unsigned long hva,
@@ -571,7 +701,7 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 	struct kvm_mmu_page_cache *pcache = &vcpu->arch.mmu_page_cache;
 	bool logging = (memslot->dirty_bitmap &&
 			!(memslot->flags & KVM_MEM_READONLY)) ? true : false;
-	unsigned long vma_pagesize;
+	unsigned long vma_pagesize, mmu_seq;
 
 	mmap_read_lock(current->mm);
 
@@ -610,6 +740,8 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 		return ret;
 	}
 
+	mmu_seq = kvm->mmu_notifier_seq;
+
 	hfn = gfn_to_pfn_prot(kvm, gfn, is_write, NULL);
 	if (hfn == KVM_PFN_ERR_HWPOISON) {
 		send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva,
@@ -628,6 +760,9 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 
 	spin_lock(&kvm->mmu_lock);
 
+	if (mmu_notifier_retry(kvm, mmu_seq))
+		goto out_unlock;
+
 	if (writeable) {
 		kvm_set_pfn_dirty(hfn);
 		mark_page_dirty(kvm, gfn);
@@ -641,6 +776,7 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 	if (ret)
 		kvm_err("Failed to map in stage2\n");
 
+out_unlock:
 	spin_unlock(&kvm->mmu_lock);
 	kvm_set_pfn_accessed(hfn);
 	kvm_release_pfn_clean(hfn);
@@ -677,7 +813,7 @@ void kvm_riscv_stage2_free_pgd(struct kvm *kvm)
 
 	spin_lock(&kvm->mmu_lock);
 	if (kvm->arch.pgd) {
-		stage2_unmap_range(kvm, 0UL, stage2_gpa_size);
+		stage2_unmap_range(kvm, 0UL, stage2_gpa_size, false);
 		pgd = READ_ONCE(kvm->arch.pgd);
 		kvm->arch.pgd = NULL;
 		kvm->arch.pgd_phys = 0;
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index 6cde69a82252..00a1a88008be 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -49,6 +49,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_IOEVENTFD:
 	case KVM_CAP_DEVICE_CTRL:
 	case KVM_CAP_USER_MEMORY:
+	case KVM_CAP_SYNC_MMU:
 	case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
 	case KVM_CAP_ONE_REG:
 	case KVM_CAP_READONLY_MEM:
-- 
2.25.1

