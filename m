Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC07257950
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 14:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbgHaMd3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 08:33:29 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:41556 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727895AbgHaMb4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 08:31:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1598877116; x=1630413116;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=nPpaVPpVDQWPYWgjjnOaK0jZ8xU/AQAIMKRW9QTahmk=;
  b=LGaNhOqRSH1MlcWYPo6GUk0kGtAlVT98xqzZ0lbd8lV9nlQW0wrunJWb
   mv0Ytyy8fwZKwNVyrbTnL2/RXXnqkhYwnuuCchkJkvEfJtlLfUlc8OKqB
   dPNJpe8PeegBIiaXMW+aCbIyg4cPVQO5G1eCUTDpHiNAf3Fzs77bHgAHn
   VMsQqGm30nnjKd8HQ1jb/0Ch83RmAXIsu29fxET+q7fiKmaOIzOObOdP7
   8qqqCHZzXnuyXxdWCGLVYbNlMzha5yyMKV5LdBmsuIs+fE0CtigBWqjNi
   4I48rBJCgbPHYGSy5XN/rH3Nj1BwCt1nJuJ2HA5EawDKMXfBmNt+s+rk+
   g==;
IronPort-SDR: K4oqTcIGLAMx5w7adJc2heLNCch1ZVd6lk7cQt+vvVGbmkXau76NT2SG3rRvVlLNT7SNsN2Ac7
 BCGz3LUrP1RCU0FVUtKbW6RSnL/ZE7DjmhNejmhA2mp2nkgIf1TzmyerZR+0PI/CqX4CdLKlcN
 jyJ14BeX5bCC2MSqBw/6Buk4an2f2U8pg/Xp9SEVlMdJLQGr6SwWIHTWBTwqojBNrjRM34gBO+
 96Q9LbZB++G8c9c/pL/DwMcE8Ci8i19pjtl6KgP35WaSySpjzJoyJnlddqWKl1LMCh070qNw/l
 UIc=
X-IronPort-AV: E=Sophos;i="5.76,375,1592841600"; 
   d="scan'208";a="150559662"
Received: from mail-dm6nam12lp2171.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.171])
  by ob1.hgst.iphmx.com with ESMTP; 31 Aug 2020 20:31:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kwXZJfdq/oInNn8bWW90TlgfaXtPTZ0wP1lEfWo/8753o2HLc+hoatUJEiROuMeOLbrnsDMLON+XzujZNwxYPdw9rg92FvRyTuzcQ4i+YOoAUpB+K/WHGZDuMDC9BphTfO5WIJ9i5iG1TBZW4XeEuY2jhjFqMFTrgh8rVPoJ2hcwBHJPMYauX75ofVxlQR0IyLeHVVlgyFhRzB8DL3IEeb6aXsoaVe6jy6dB000s8UQqIUbJAdigv90N++g01AQvBf6HoWmfDAJ8ZCJNL6MZ/HwbdVUqtEHGKxgiKMmMXXOxvJPHxJewC1WECd6zItQlwNrkeXxOrEo8TePdgUE36g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vPEdpFz0SS6gW98bcRmvD/AE5s5tIPOTDejelGfrqxE=;
 b=cydOo70WTFonIfW0WUtqsneiFsrVOytynDv/TAldu2QxHAJDBR6xmm3LlNPw/9tq3fdbXpjY+m7NIW/dKx/qX22uEiY6JdBM+l3yNd6ODSw/9FcM6SJBmYSClECoC8LfaswDms3CtzvNXOJToW0Q9WL1msgCfSZwLD13C5wV60/VUfFpTPwETba+RJZ3z6MRnGCjdx6iiOjhpiVuVagc3EaheAgzxNeCvH2o2y3DeNZGtf81HqW3IT5M1Xs1snqujY/XmGfBFTntxnUozp61DmhqFHj4oo6WSccutpXsl/u0P4HpgucPYb3BLjAj2LYLcg2EmO0V3XC+HEjQwscpTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vPEdpFz0SS6gW98bcRmvD/AE5s5tIPOTDejelGfrqxE=;
 b=XF/3ejwiq7w4436ReCLsxcFHVfkhi7hX55t5E0MGOg0Am1VrMaAT2rNkZNa1gcBC+XnGlPwrb0V4F0F7vdg3FBGUWh2E+DMgvAG5JQS04tSHoZvUVJXjqsk79ihumoBy5Yg5JL5TFf+GgEWrz/9unoYGBZoI4ikECFMfk6YBLMM=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB6092.namprd04.prod.outlook.com (2603:10b6:5:12b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.23; Mon, 31 Aug
 2020 12:31:34 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::607a:44ed:1477:83e]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::607a:44ed:1477:83e%7]) with mapi id 15.20.3326.025; Mon, 31 Aug 2020
 12:31:34 +0000
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
Subject: [PATCH v14 11/17] RISC-V: KVM: Implement MMU notifiers
Date:   Mon, 31 Aug 2020 18:00:09 +0530
Message-Id: <20200831123015.336047-12-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831123015.336047-1-anup.patel@wdc.com>
References: <20200831123015.336047-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BM1PR0101CA0046.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:1a::32) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BM1PR0101CA0046.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:1a::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Mon, 31 Aug 2020 12:31:30 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [103.15.57.192]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 61c6c01b-ced0-4f50-20e6-08d84da9cc22
X-MS-TrafficTypeDiagnostic: DM6PR04MB6092:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB60922C0FFBAA3FC8940C03A58D510@DM6PR04MB6092.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UczorUGMOTlGMxbtJD5Eq0jy+jMCpNfZ9+U11MwI9VDWhRTfPy08NHXZGLOetuo2zcAufbWevb8DxJ/o5159JeyK358qtuBz565nAbfJcQd3ZqwmnC4M/gXaKbrq63UsVKXUa584o41aoLFlJamd9JEYl2CATtOGl560cw1OaVtbKufNZhZu3C0yWEB8RDSRyuTeJ0Y9yZ3fVCzHfuwGpRRvnYPKrAMneGFyO8z5mbpCdWB/4UaNTUCsJVWfkCvk5LZQWO7wwFor5xBTfIM7frNijAhGcYaiTU7VDwQ+aGFDmM6pEOGf4nfOgWnkKXuhtb4l1Pekl4gwpYAonGj6cA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(39860400002)(346002)(376002)(44832011)(6666004)(52116002)(8676002)(86362001)(36756003)(478600001)(6486002)(7416002)(110136005)(8936002)(54906003)(83380400001)(66946007)(1076003)(66556008)(2906002)(26005)(186003)(66476007)(956004)(316002)(16576012)(4326008)(5660300002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: +uBHVU8Dy3ivyNshiMU1iiPyI8VuI0dy8lEnhR/a6FvvCLXXc2i+iqX7t+L1N8rdFdmmj1ptWzzmm707cbmI9D3ijhsHIIM63E3o6gY5LLz/j9QsGCHHVrTyCaPZ1qmpp44xL9jaAT7zxvrq/ZbBmprOWSD6FvyukeHBfdRA2rJGtAbZJjbLQPfoS8PirDmgVdaIMURy3W/nFPp9UTw9rCNb3WxueAh1JHlCssNiYUxbA7KFw8QyJ2pliUWostfxeNI+pU3V7FFCiEhpT91zdRuhF7JX9A0KQoySAHiLke7J9OChZ9vZG1LBxS1z0VqGkQ2Oqj2PfW+XocssJyoioQacNEjMdI0CyANMMX+vyloJPn8Uuxp78aftbjoOsiEHHrEemrbHtm8sSNhoMMXmgD+LeZLzJ9ZFKj+dM2vVesK1YfoRD/ez4ch9BrY1icUlJmHNw3UlG6XCBG+t7sqwkQIe1sgN2IaNWuKVtajWhwFNQv4AYbqKI0EG5IQLyJZzbZvWLa4+NcUtCJRSOODhhJwdOoSvpTGLdSkEUNdba+oL2IOfvtANxeG1KLLb0z44l3DHC4v8wOYN/rg6RgTdNZdQnDiBnP71A7XrH5B9ustHhebtpe4U59brMtUwK3ztjvrmO+i81+Zi75GcK3QP1g==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61c6c01b-ced0-4f50-20e6-08d84da9cc22
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2020 12:31:34.6762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O763VFkfhT4EykIRCV3o91bKu9+tPC/Vk5pm0jifwVqWqnx9hG72OCUqF9VkpmloTq6CI9vpZDG8T/ThKagxHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6092
Sender: kvm-owner@vger.kernel.org
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
index 5d70c8cf3733..d25f181c3433 100644
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
index 35b9aabe6c57..b31db8a9f362 100644
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
 			 gpa_t gpa, unsigned long hva, bool is_write)
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
 	hfn = gfn_to_pfn_prot(kvm, gfn, is_write, &writeable);
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
@@ -674,7 +810,7 @@ void kvm_riscv_stage2_free_pgd(struct kvm *kvm)
 
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

