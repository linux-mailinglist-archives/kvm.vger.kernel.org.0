Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29FFB2F78AB
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730794AbhAOMVW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:21:22 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:36557 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730642AbhAOMVV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 07:21:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610713280; x=1642249280;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=u29/SueXKW1DpPDViFxJGsCGvvm89lnF+d0mLKA2kyQ=;
  b=rFyOsEgguta9+GKjS6uSSAa/TSzyPKQ1G7eDUdIoG7xC7wGsxsxn8ES6
   L5WmWfIvuyCRYjsIOSLJHA7rr53NK0kc2q/PU1SempWLGDnNPix8fcw8V
   2wDHOHsuerPlHg1EhRjb3ZGFKRc4WPZlykxo2RSH9H3AJf8qKCLMhKJn8
   +qgPvfkPWCW4RVoKXzmftLOMVt/Lhn8slCgJ89ywMqBJd6DciFiBuRuvm
   CS5I/0IlbQfZ+kjSRzmTwYZBykm4CeWQz4gX+G6pzq1+POVF3VffulON6
   sXgykR798MYAdsC58vRnBy75LF6hb/nFQFcfqdhz0tc8NTEFbiaBiKcJS
   g==;
IronPort-SDR: UAl9DNDAV20r5XwLtZNX3UndRsB5eJXpoPb0W1uLk+mbXOVYmPPeHiHKrFRqGTt08aqoJxwpn3
 nSZQY/3oszWEi1cRGUMqekTLUdHhXrky9Ny1DbSzUpHHVwCjvM9QHrofKcthUqia+DP25hJ10P
 9m2G1yw8neN7GR3cpldm8PP/wSlhV3P2OGKpQrNsAx6d+EzOQzfsPQgyevJm8XPBmPeWYP+I/F
 uGjKkd4GqAUnqe6bTcqXz5YAtYDUhncIV0pr5AxkaN6x/ZAbnUjty5I+yvXdkUfSUM3MV0Bs2I
 irE=
X-IronPort-AV: E=Sophos;i="5.79,349,1602518400"; 
   d="scan'208";a="267829228"
Received: from mail-dm6nam12lp2172.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.172])
  by ob1.hgst.iphmx.com with ESMTP; 15 Jan 2021 20:20:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Buh/itnuTFNL1ODtMcQH3KyImcyzA1i7nfWq20iRHR80KyfkzD6kAZjTGZUVYlBPlgvQC1ifEB7Zt272x/I6F48X8gKFHwArKm+sZXLXUlP9kAlQMYpqHkdMFlvVVrxTDZlZ17d7JVivXrxYwcNZnxxjS7tB/NZHQbv6vIuV28pROisMwvPk3NVL6PFTxRKvIaSLlBfp5W6EC5TnVwip9h33hynfdx3iz6rsY1jEYmHN9eDXigqkGGrRGnnQdUgRN0T4uiSfrbNksSRV9tCMjEAhOEbDHBUNUozCWBDEzXB8fXg67K+8Hf7cXFDb5Nz8Pzd+8RoN3U4vho1bWHSWMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUazC6/O3nKuAlp0HjZyjYvTLGK0pW2bPfZzUI8a9zc=;
 b=h1Kdi/5b+vNU4bPM8tBYT8u/D74DTrdS2nPzDw79d5oTrf+jO38FWT5RoJpWqZ3NSQeQTjdz+q8N8YrU66WLbaFSnxJSQcv4hbYw2sqz+Y4+YVxzhfrTggpr4cICrhOJzUzuKPkuLZjcqvplCQgI1rG30uNavOPAYJwAC2qtt6MyaIGHS1paSOyryTRubfdKstdiZ1GALMcG430P4QVU7NiKyOdVEhH0NH3Vm48WMCRSvmd971XDMQ2fJO6/NZ4yv7zzEJAQ1sh9w1r9ODYNNCSuB6BXJta3TiesbCMRwZWTb/3B6f5qji8vVf2FtaB0tsId8bmPeo0kUoXMKBJ/XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUazC6/O3nKuAlp0HjZyjYvTLGK0pW2bPfZzUI8a9zc=;
 b=cHe7LuA9KjSWqnvOt6NPN5AXBUi03/oBlnjCFYckbd4JgUcK8zybGublSntbAaHEyR6n4/Fcz7daubjhGTvKNuMtfSmfyEE9YCoMGL0BKSxcQ3QreHlfgwRz4PbNG8jNZCkW8QNofzKtsrsovzJXeZQqvqcVLYl9SEhYG3H8OkM=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB4330.namprd04.prod.outlook.com (2603:10b6:5:a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 15 Jan
 2021 12:20:12 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97%5]) with mapi id 15.20.3742.012; Fri, 15 Jan 2021
 12:20:11 +0000
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
Subject: [PATCH v16 11/17] RISC-V: KVM: Implement MMU notifiers
Date:   Fri, 15 Jan 2021 17:48:40 +0530
Message-Id: <20210115121846.114528-12-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210115121846.114528-1-anup.patel@wdc.com>
References: <20210115121846.114528-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.167.152.18]
X-ClientProxiedBy: MAXPR0101CA0024.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::34) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.167.152.18) by MAXPR0101CA0024.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Fri, 15 Jan 2021 12:20:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 77e1346f-7bd6-411a-54a6-08d8b94fe7d9
X-MS-TrafficTypeDiagnostic: DM6PR04MB4330:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB4330657C65C5B61C67AE6EB58DA70@DM6PR04MB4330.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mkzTk8iKkUj061a/vW71WSoeSjejX5tlIZystnP9WOkTEWQwZyjTOyw8BbXck5myddq5l2xZ1xNlZovpXZKjMMScmRmHGpHMUh0hMjZx09VOBSGYl9+rcsn5dyzeqPRIZ06otVwakWUrfxylTwjzCSJRrJF9zbdE4P3U6JwWhXZR5/BAKMo6OtoFHN66O0UU3uNfmo+VwwfM33ZgyOuiSEg83/zkFvj+393fM/VE7mEoL5OTaQXBtplN15J5qpdrVJF98urY+RbIP2gtKHyhf516gDL9T/hhvZbqIoH9BDtWRnozLyOwjOBmPGyZIGOxY1UpoiFA94DCiZyOOxIgrvHz/2sxng31PhxnIcUM2A7tR1rU4myVFA0IbFJT6MHJMtsMIIAfcFao1UX4W4kiow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(7416002)(66946007)(316002)(1076003)(66476007)(8936002)(110136005)(186003)(66556008)(86362001)(16526019)(36756003)(44832011)(6666004)(7696005)(4326008)(26005)(52116002)(8676002)(2616005)(478600001)(2906002)(54906003)(956004)(8886007)(55016002)(83380400001)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?cCDZ+LNOrNmUSP6wLcsKktB/RZK1WmzJPCsjPH0Aqd/aWzs1PxrbkrYmrF+O?=
 =?us-ascii?Q?lNvlwBR9pVqsAPcZSwckYMB5UB2pvkrSIITE1QwGv/QfpAebQwKGFqjBR69C?=
 =?us-ascii?Q?W/a3Nhj+sN9Wa8rGCDtUQ8K0fG/hi31bzJrj8jjwPJxUlYddJdGU+gChacS/?=
 =?us-ascii?Q?a1eByET1oweAc6bfWU3QXouM9wRF4CpPMWdReMuerpHMBoZQufm89gI32k94?=
 =?us-ascii?Q?E6DaUNsaXb1+Gbigu8kN9Ytuz4S0EB1BydSAc1s5HX5lM24ZxVLE6TUFMt/C?=
 =?us-ascii?Q?7rQ/sqpKf1QWeay0D1WeVAshHE1ikDpmCplfbW1gpC8kLjlYv1l55r/7IvXf?=
 =?us-ascii?Q?ltwWOnGl247CRN2AsUdsEaXcTnjCuiVkvYETxTTAIrm0GTzaOZ7a80SWDcjW?=
 =?us-ascii?Q?RwI3++KQ1+/BpMXdju7r8B+ZEjVKt6nf0ZWzFum2awtZ60nylPLLMwlH6IBQ?=
 =?us-ascii?Q?YZtr+FjM24l3ht9atu9JOcytkL3jNxMyz8ca3Dq8BeJm3C3qITeIMLLAUzeB?=
 =?us-ascii?Q?JRpC/QqzEd6RScAUdOh2wyOx1aRm+2kJbiqtM2BV3y4SgLIfr5XFSVL6LNqC?=
 =?us-ascii?Q?PAbIA5b3/zDGfJd1W3vAlxa+A36MUym8is5Ol85r2x+Ai+lOVaJNUNcR0jLI?=
 =?us-ascii?Q?oXM10pxdM7SkYc5aren7XulLXJXhKyScQS7A3UKpKPDhMnMDnWl+Tdi6dWkm?=
 =?us-ascii?Q?wGRCWj5SgzmKys2trE/pCl6ouTodXvf3lxK+2YaOgc9OfqO+1whZmc9B8Z7J?=
 =?us-ascii?Q?WLMDIQfdZo4odAGxQXEBmg04v2EGoiX+Ns15nZnF5UC+wbn7pzwmc7+/3srX?=
 =?us-ascii?Q?6TTvH2H1frDysqhpl+UF28d+s9xEzWW1PYd1LX4vql6wpL6nfCmi3b3vR6uf?=
 =?us-ascii?Q?z1eQt2xGHE1c6H2fxsFHv140k+AkJkdXt+oGOTAHmW/BtEWpwn/pK1CjLvDm?=
 =?us-ascii?Q?cAzhCmYn1+1Lm5I/dEbGb96CUDbaiMkoQbhBloORhdGbtxipREfe/X1QEw70?=
 =?us-ascii?Q?xHiq?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77e1346f-7bd6-411a-54a6-08d8b94fe7d9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 12:20:11.8808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DFqzy8D/Y9bfiGrkklaBv8yr5A6ladpQy+WnW+IqECcHuckpZ5gejsUzH3ar9QVCLCAQcMiD7mU6sDgDi3XU9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4330
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
index e311c4bb0b8a..56fda9ef70fd 100644
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

