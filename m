Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724023D6E68
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 07:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235797AbhG0F4m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 01:56:42 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:33076 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235684AbhG0F4G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 01:56:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627365365; x=1658901365;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=XcblKwC4eJ7kKauQKOdiVCJfP7wmNFd5gDp0qXUHFDM=;
  b=lLaeDA1wJ8BrWe4RQISxjNTqTOGXW4fO1zrs93eiI5mvNJ7Gu9WE7NLE
   LvhdHoOE898wGKy6aOidBZVlbSyz83r9Rs+LZi9woJsip370j+ICXswN2
   ySdfBFfT4Tge4bMKTODqVSbknHYfkZuqWSZr0TccmsGJvtP5ts6KnnZbz
   OAOeBF/UbNx7hF7H3IXxr5ScM6MtboZOE4KP9GyaIDcXtPaYeUgaW3mn8
   SPrWU4tGo5H7x1IqL4GPSTaWrrHGN5uQ5VQC1YwEcHjpim6MXz+i+qKl2
   3F5neB/9allfCsjhUgLgqI06BXYiUODj13WLBdAQt018MSE5m2drbb+4F
   g==;
X-IronPort-AV: E=Sophos;i="5.84,272,1620662400"; 
   d="scan'208";a="180385922"
Received: from mail-mw2nam12lp2044.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.44])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jul 2021 13:56:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jbPYQyttu1SfWVb7VN+xO0cEmx9YlU0hTdpUkgmjqRq9H1mnhygGEqSKA1SnSLDjEoet9zv4PHr+06opUdR5+Ql538ZA/2Fpk+wdgwkoEykMk9mCMNhWYbTfqqSTVopABnw/bFYojvaq1LwbpxV9eiaUXspvZwLQmSGfbdXryyyoffWZmYoZ7BKtyxO5ClesuONLvNiHiYUkN5cs1bD2BqHJKzZNJqxE6EQQWfMXo+Tr61ICGkHMlImqjKLY4O7uTPxlvQ247s74qMyHMoAopqHT7qM/4KHqQltedoy7fCoAoc8W4GNhkrPVKV/U3+4JI+0F+6Qi471OtlU9BzFgDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hQ1c/4a6JyoQqD9cp06bRu0VXYaTNpBIwflkL93kh2o=;
 b=h4pFKiR3fSM+PpZsk91blIoepAiq7oj0MV/59RNSL09TNB+OGm9TyF8UV7ecy4JkZEmz/yjpUoYIAcmSoEDucHlHRUFFGnSEFAk1zRJkpMTEVdpdFlyp8G5F94IbvH/TJch5ujDrx7TiJ2vkMTua4GKRTsxY/tX00cL04r1YqKNoDUAMXwQSRmyGv/2pzGleOmAmlUAcA4aidWBa44CkOekfsK7BIekB694HebGG6IAcXWci4N00+H/LTTjE6IFKg3EG/no1sDHMjU0IwSy50vGzDHRSsHrmVpHTd8vR0GkzmeCjROQd/NDXVrGm0qDnNz/G/Ix4zUhQpFwEJw29iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hQ1c/4a6JyoQqD9cp06bRu0VXYaTNpBIwflkL93kh2o=;
 b=y8SE5Q58hhjlCbp5vtOroIV7uAe3B70/vZRZSZvwtt6/7TPewU6yNl4ASU/EUEsdK19P8gWpsdUZ/EY4GIkz/3QQoZJ+UCLnYVBDtcWCkENpsM//md4Z4WZoh5uczbvds4UhNr7c85dfgm/k1lmvGesLNv+dTIqrnCqNKbcXfIY=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB8377.namprd04.prod.outlook.com (2603:10b6:303:140::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 05:56:05 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::a153:b7f8:c87f:89f8]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::a153:b7f8:c87f:89f8%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 05:56:05 +0000
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
Subject: [PATCH v19 11/17] RISC-V: KVM: Implement MMU notifiers
Date:   Tue, 27 Jul 2021 11:24:44 +0530
Message-Id: <20210727055450.2742868-12-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210727055450.2742868-1-anup.patel@wdc.com>
References: <20210727055450.2742868-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0030.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:22::16) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.171.179.229) by MA1PR0101CA0030.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:22::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Tue, 27 Jul 2021 05:56:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aed955d7-82ee-420f-67fa-08d950c338a0
X-MS-TrafficTypeDiagnostic: CO6PR04MB8377:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB837795C5884BFA5389988BE58DE99@CO6PR04MB8377.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MNfk/NsjQbpufdUzGDHHOzAhUl0ObiWu5IaTIutX4kHkDtS3WFFyNAOyGFLOQAq6qceXldegz6UE3hHMjkjWfVdyvsaVKk63W0yPfc2W4QTr2pg9sfHeKCkHdW65KHs40k3FvIrEaFo7h3hJqaCfcxsGG8ckVNxJljKKwXE+PfsNS6m/Vim5dBF3eFBIMeoJr1zQ0ZO43lmW4mYSZ9DRBkDIqLP1kMkQOWu8OVs5fWhd5mRXHIpEEqCbVtM/3piLPfSmLddZcGOrmI6gB7K5zUqdUd+xKLfYOdDXTgWpVTwMIpQEqmP5SscTSQz40XxpVSlai2zW+IkG/Vu958Nb1O0x4MIOFW4Wy+/g/k+NV+DHhjgax6eN8Z7gsxP3Em22m2uQYE7GD3PeE8bM1UWMgkqLyQlSs0c6t81X9vMjTrA+4HhY1/I3T6flRJ/84sJ2L1ejXTdVAxhpsxv+XhlAj0Wjst/BvYbsx7mhr65yHDiSSPtHV2IdDxiDfgCwijtFzgkOP8wD5mfJdLbOHh0apf2HK+qcv2HKWAK1RFuhihy7zeLM5orIdzQdRvRI3/BbLpjvS6UWZzoLP022i6PDfyq71AIIPfmRcLjKrQ7KvBOODs365qUcKotWdqMosRh5U5FQ3fSao6O2i070iGhAH6Z1awggXRhu5TvrcdiNbZR3FKu021Cywi5JdkjRfsCpX7zrBUydD8Ab8xejUAMT7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7696005)(52116002)(26005)(66946007)(54906003)(5660300002)(6666004)(956004)(2616005)(8936002)(186003)(38100700002)(316002)(36756003)(508600001)(8886007)(7416002)(66476007)(2906002)(1076003)(110136005)(86362001)(44832011)(83380400001)(8676002)(4326008)(66556008)(55016002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DBy8dlN9tFjy3NdvtAFH/HFZVszSi8KrhcKLZSvshh2rgaOGZncM699izz3P?=
 =?us-ascii?Q?mkUhd3JiETPxWAleb5ZmDXvJtiz+fOHixqgi4NfY4YBWZvErjlP3+lTv4sIv?=
 =?us-ascii?Q?fm2FG1ThxAy99FD6bxluvpJWO7YXl2U4EB5gMOuu9jaOZu5PNVpa0scMbMdj?=
 =?us-ascii?Q?sXejHRy2RcESVU/n8YivoAZKJwA22HNVJ5Dyt7i6r5/ViTGxHwO0Xq0+ZqAz?=
 =?us-ascii?Q?Zt2J7tPKGmbxsiMZsJoNosLBDTGvNK/nvuCRAXjJgpRjYop+S8+t0+HB3hLO?=
 =?us-ascii?Q?wOapySk/1L27QeKZ6ONcH+fnBSvqQxO3k0VFQYnciJNYzv97dNxrwYT6rrTE?=
 =?us-ascii?Q?tqJIJN8FF9mXHbZxzq8+IIEnhTbQMCpnTOqaP3kDsovzzEfiuLD74kxM12/J?=
 =?us-ascii?Q?dyalMNOE/TIuetl9mxxRJcelB2gMPABARRGQzbZOodqVAfjz7vNKCKjXuCP4?=
 =?us-ascii?Q?U0C3G98Ba/Rd/F6K34HHqZww5/mJtewLCca2SGl2Yy5u7kdgre2iC85tkPCU?=
 =?us-ascii?Q?6L8TZu9Fnp86Ulu3ftYHSCFaFPzeQRq4HGLBwJ+eers63f6M5uzWh1HMW7l3?=
 =?us-ascii?Q?78G2Yu9hug4Lu4VdAC0zf8HrbwGfP5PSiimZPmvGgccZQskpdbGTUzftKkrH?=
 =?us-ascii?Q?AoygeAGK6PC17VLOX6s9y4z6/GuKEBNnweCjkQ8dHcF6BOgXNqkXNMR/5r6R?=
 =?us-ascii?Q?Z55Y2/DpEuOVsXQxAIqLdEkdGtz7JRrA0FkPtYGOqVtaPhiGE0sZ51pU9KiF?=
 =?us-ascii?Q?UM4hDH0vtNjba05z0cUMBydsdiKdTGxe61qyCshqKWBq1If2o5ZVZQqhm8IQ?=
 =?us-ascii?Q?MiRZrRcwrdj3eMDqSg/CDte//kCB+T2NTK4whqKor9QCRkxCOY+szWHREzrr?=
 =?us-ascii?Q?1GncCLOWeREpXsviYgVg/dANuFE3PkKzBR+Zj+LJOFBghBrc0tznw5HyyDaE?=
 =?us-ascii?Q?lRIbGO88xp7oFYC9z4yFF17VCr1WzVKuMx5xTLyj+OWdCRH4FuIPSVgm030/?=
 =?us-ascii?Q?DGEtsPbnjvvNxgSbFvY7RW9r24W/WPZl1i74zySWvpYA/tk1t/jdjLcgRRtc?=
 =?us-ascii?Q?0JqYq954IHKFGhFqyPvpmgf8Kzg4oWSxcgGIOd6pfGxHSWsiNA6V5qfvL4pg?=
 =?us-ascii?Q?Q47QHdwALJZqe7UwwNOK5azLuAILnDQoNdzzY8fct1jANUPQhbHKqS6vwDqS?=
 =?us-ascii?Q?aEzp3LVVVSMXPoBNtOfuHoJubZF703JPMVxYJdoQbCeYbeiHzMhng016FoPG?=
 =?us-ascii?Q?UZeToZ8jkkoTOPDAbaAFeqd7lrFYErvghoVNJc8ZSNWJGKFibymcjcEFQh99?=
 =?us-ascii?Q?fAwtxUb+SmVcQ6WZRfMOv+ib?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aed955d7-82ee-420f-67fa-08d950c338a0
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 05:56:05.1842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cXdus/uYFhJNfr7QVraVofxSnVYl48iHU/a3cp3kWpT3w+xpy1CEvMoN5dzueeb0M56Ay+KwJFHFMWXFX24MLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8377
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
 arch/riscv/include/asm/kvm_host.h |  2 +
 arch/riscv/kvm/Kconfig            |  1 +
 arch/riscv/kvm/mmu.c              | 90 +++++++++++++++++++++++++++++--
 arch/riscv/kvm/vm.c               |  1 +
 4 files changed, 89 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 33255c5dd555..a54a58a4026d 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -196,6 +196,8 @@ static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
+#define KVM_ARCH_WANT_MMU_NOTIFIER
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
index fa9a4f9b9542..4b294113c63b 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -300,7 +300,8 @@ static void stage2_op_pte(struct kvm *kvm, gpa_t addr,
 	}
 }
 
-static void stage2_unmap_range(struct kvm *kvm, gpa_t start, gpa_t size)
+static void stage2_unmap_range(struct kvm *kvm, gpa_t start,
+			       gpa_t size, bool may_block)
 {
 	int ret;
 	pte_t *ptep;
@@ -325,6 +326,13 @@ static void stage2_unmap_range(struct kvm *kvm, gpa_t start, gpa_t size)
 
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
 
@@ -405,7 +413,6 @@ static int stage2_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
 out:
 	stage2_cache_flush(&pcache);
 	return ret;
-
 }
 
 void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
@@ -547,7 +554,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	spin_lock(&kvm->mmu_lock);
 	if (ret)
 		stage2_unmap_range(kvm, mem->guest_phys_addr,
-				   mem->memory_size);
+				   mem->memory_size, false);
 	spin_unlock(&kvm->mmu_lock);
 
 out:
@@ -555,6 +562,73 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	return ret;
 }
 
+bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	if (!kvm->arch.pgd)
+		return 0;
+
+	stage2_unmap_range(kvm, range->start << PAGE_SHIFT,
+			   (range->end - range->start) << PAGE_SHIFT,
+			   range->may_block);
+	return 0;
+}
+
+bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	int ret;
+	kvm_pfn_t pfn = pte_pfn(range->pte);
+
+	if (!kvm->arch.pgd)
+		return 0;
+
+	WARN_ON(range->end - range->start != 1);
+
+	ret = stage2_map_page(kvm, NULL, range->start << PAGE_SHIFT,
+			      __pfn_to_phys(pfn), PAGE_SIZE, true, true);
+	if (ret) {
+		kvm_err("Failed to map stage2 page (error %d)\n", ret);
+		return 1;
+	}
+
+	return 0;
+}
+
+bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	pte_t *ptep;
+	u32 ptep_level = 0;
+	u64 size = (range->end - range->start) << PAGE_SHIFT;
+
+	if (!kvm->arch.pgd)
+		return 0;
+
+	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PGDIR_SIZE);
+
+	if (!stage2_get_leaf_entry(kvm, range->start << PAGE_SHIFT,
+				   &ptep, &ptep_level))
+		return 0;
+
+	return ptep_test_and_clear_young(NULL, 0, ptep);
+}
+
+bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	pte_t *ptep;
+	u32 ptep_level = 0;
+	u64 size = (range->end - range->start) << PAGE_SHIFT;
+
+	if (!kvm->arch.pgd)
+		return 0;
+
+	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PGDIR_SIZE);
+
+	if (!stage2_get_leaf_entry(kvm, range->start << PAGE_SHIFT,
+				   &ptep, &ptep_level))
+		return 0;
+
+	return pte_young(*ptep);
+}
+
 int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 			 struct kvm_memory_slot *memslot,
 			 gpa_t gpa, unsigned long hva, bool is_write)
@@ -569,7 +643,7 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 	struct kvm_mmu_page_cache *pcache = &vcpu->arch.mmu_page_cache;
 	bool logging = (memslot->dirty_bitmap &&
 			!(memslot->flags & KVM_MEM_READONLY)) ? true : false;
-	unsigned long vma_pagesize;
+	unsigned long vma_pagesize, mmu_seq;
 
 	mmap_read_lock(current->mm);
 
@@ -608,6 +682,8 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 		return ret;
 	}
 
+	mmu_seq = kvm->mmu_notifier_seq;
+
 	hfn = gfn_to_pfn_prot(kvm, gfn, is_write, &writeable);
 	if (hfn == KVM_PFN_ERR_HWPOISON) {
 		send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva,
@@ -626,6 +702,9 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 
 	spin_lock(&kvm->mmu_lock);
 
+	if (mmu_notifier_retry(kvm, mmu_seq))
+		goto out_unlock;
+
 	if (writeable) {
 		kvm_set_pfn_dirty(hfn);
 		mark_page_dirty(kvm, gfn);
@@ -639,6 +718,7 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 	if (ret)
 		kvm_err("Failed to map in stage2\n");
 
+out_unlock:
 	spin_unlock(&kvm->mmu_lock);
 	kvm_set_pfn_accessed(hfn);
 	kvm_release_pfn_clean(hfn);
@@ -675,7 +755,7 @@ void kvm_riscv_stage2_free_pgd(struct kvm *kvm)
 
 	spin_lock(&kvm->mmu_lock);
 	if (kvm->arch.pgd) {
-		stage2_unmap_range(kvm, 0UL, stage2_gpa_size);
+		stage2_unmap_range(kvm, 0UL, stage2_gpa_size, false);
 		pgd = READ_ONCE(kvm->arch.pgd);
 		kvm->arch.pgd = NULL;
 		kvm->arch.pgd_phys = 0;
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index 38a644417627..0110267eb7e3 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -64,6 +64,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_IOEVENTFD:
 	case KVM_CAP_DEVICE_CTRL:
 	case KVM_CAP_USER_MEMORY:
+	case KVM_CAP_SYNC_MMU:
 	case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
 	case KVM_CAP_ONE_REG:
 	case KVM_CAP_READONLY_MEM:
-- 
2.25.1

