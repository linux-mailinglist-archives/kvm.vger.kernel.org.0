Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE921841F7
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 08:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgCMH65 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 03:58:57 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:61317 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbgCMH64 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Mar 2020 03:58:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1584086336; x=1615622336;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=sbiPNb42XW2pCS0wlNJf9ewGNZ3FbpzF7mhy6dTqh+4=;
  b=fZrkHJ1bRlzHdA1/Bdw4zRpCE/wuBDO2Dz86e+DP7blIhRXNLkQwjbT/
   bIaDg6GkkW8wW4GbT+HzSncZfj0la3pYsMneJK5eG9ZKl2GpBbQs2+PO2
   PV9UgFH7dMU3NMJ4poMnKNtaKGduLMogxhrv94S3yJXah8QzLOa+gy4p3
   aDWNSi7szY86fLLskgmMfaFUGKysjnNUjRbSLjX3HzwBo0EAnEttKSWsv
   SKnQj68CgE9uqExEQyygONMXDBwiierLFeFGSrgIKjk6PD7pRe3biowB3
   6BQ840EARslV7aP3aYxmv9G7AwOgS0Rt/89kcTyJNl+jitucYc+0/x6hi
   Q==;
IronPort-SDR: BP9UXlR8KMd0OM92qWSbRKMnYuJ6hRQfWpo/CcCfh2nGZk9xPsySJWmIGY19bCeFYBLDUnB26W
 0OLsjZFRzCGLsH0RrYSBO/ejE6MZB8iCJgf9Xh4yI7JP78TETKqxyn1TMhfXzkvQwBEVWyLTKT
 jjgLdGV03JLeL2YjP3rV1SJHhbi9Dnlmq2EkzqoeHjV163ZLpALAzCNvOih1cQnYeBaSb43GgY
 anf9Yyycmp6Mz14HUeRmaE2kLCYxq0c3cZnU0s5k6s4vJY69cDFTiReabRg5PSA79P5GAMBG/P
 An0=
X-IronPort-AV: E=Sophos;i="5.70,547,1574092800"; 
   d="scan'208";a="240664511"
Received: from mail-cys01nam02lp2059.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.59])
  by ob1.hgst.iphmx.com with ESMTP; 13 Mar 2020 15:58:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gZCr5M+LrRFt6IZsgQZSCs2xxqcefps4uoVNFTGzdAbjMhL5ilMwnServxtkqBNHy4/2h9hL6nIQUkx2EyirzzvawFaMqjWB482kejIskbbiTXavw7GhKV6mwVteYa/3MhdevZcmO8wbNv6mORDGkhm6+v0TZzI+9YZP4Oa6z2swMRsT7stmoBjvd43s7S4Fsza9bw+1bpi3ySlFiuqSgjDazuRPlid4PvfSdKgteh4+0CCJS7/ffKKSuDuGsF4t4G9hJ+3yeyt+k83JlNM7uvem31QJYnfuj52RWaKn82THTca8yMOJK2c3Lc4qvNgrRl0EVtZTsKkN2pummW11Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/NSBIWCgKb3Oj/V9OHBFQvh2+zYSms6v2JteUhUSMaY=;
 b=YUcg5buhZ6EHvXSjIc3/4loUdvhXgU7gFWh27ypP6EsQx+/vQED7caawmYTit4/+/kyhPB4jjR0dDd/S91FZzhy/a/xFOaj4NOpQASdfhxhxaDBsXFCWvKxS95p38SOYZrPsaxzNYk+J6CWFjvg5qIA28kP6wE4Cl/YOxcNLtzogxleqvaXG5XEgst1kqv4UgIkdy49xUZvlj2ax8a0QYFyASvEEC77Fhq9GbKy6vWIY0GpMsI+ScXWUBqY0E8nl1bF3yvSNItUe2pIOhke77TYmuLfKnCFY8wuInuAsjOo/k+cdUC8O1NAiaRN7OM4j5et+tox/Yb7LXefwixS5bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/NSBIWCgKb3Oj/V9OHBFQvh2+zYSms6v2JteUhUSMaY=;
 b=IiB7L3r/xf2hFVv1SPNaYFBBeRhAM9M5vnUTU64ZBiKZikiUa0lMgaL6OWey+f7P3IcW880qiSvMY8/tGYaniT/n/PJ9TfSCGh58dkpzZE00vMRpj+V+4P58tDj5aacZhK40QrxKiHrdhG/qkfRhWlaZbGPkxj66r1csK6s6m2I=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
 by MN2PR04MB6944.namprd04.prod.outlook.com (2603:10b6:208:1ed::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14; Fri, 13 Mar
 2020 07:58:51 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8%6]) with mapi id 15.20.2814.018; Fri, 13 Mar 2020
 07:58:51 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v11 13/20] RISC-V: KVM: Implement stage2 page table programming
Date:   Fri, 13 Mar 2020 13:21:24 +0530
Message-Id: <20200313075131.69837-14-anup.patel@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200313075131.69837-1-anup.patel@wdc.com>
References: <20200313075131.69837-1-anup.patel@wdc.com>
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::19) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (1.39.129.91) by MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14 via Frontend Transport; Fri, 13 Mar 2020 07:58:32 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [1.39.129.91]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 212395ee-e84d-47c9-15f5-08d7c724589a
X-MS-TrafficTypeDiagnostic: MN2PR04MB6944:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR04MB694466F5855967423178F1518DFA0@MN2PR04MB6944.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 034119E4F6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(376002)(136003)(346002)(396003)(366004)(199004)(26005)(4326008)(44832011)(55016002)(1076003)(8936002)(478600001)(86362001)(36756003)(66556008)(16526019)(66946007)(956004)(66476007)(186003)(30864003)(2616005)(316002)(7416002)(6666004)(1006002)(110136005)(8886007)(8676002)(2906002)(81166006)(81156014)(5660300002)(54906003)(52116002)(7696005)(36456003)(42976004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6944;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3MajdPlD21X/5MbX0kXIyir2RiVWN6xO6CqyIPtLMBYv8rZnvtpzkHf8xX75bZRS1ZIOd6Hmt3ndl++2os+Z5glo4RtcNsb+D9wSbMzW/OHsYysqgrprAHzY9sVf2VvJAam/a+Sq0d00bfZLrqqAL+zCVdfqLj1Kl5k/TlH28CI5m/FcxfYGeWAUdiC8EpAdXQtJDx1JJB9GYyMnrVyyOheo8S77F5rDhNNKUMTiDib0dB42Ky3oHGUw20tRPYVFU4NHCMnJyWtaFfMJI42KGjYnvaEfgaeHSjgPFYhIwXAzh5PjBFuV2lgXTtVyMuFvDoLzJVuP8XN1mN6ngA1WuzTaK3JWQN1XRTKTdZBpl5ss3PjyotrCHMEGd5Fdd0WosLdkxX6ogIsXXIx9I2SWNfm8wgfW6Lfio71SPn/32i0hwYOKzhf/qfyV9TBz3fvRUVPoVsPSqRDez2XmSbF31Y1t3LhdTUbPaCh3xQFKFcM3Uf2m8jVBvZJmAGmQeEnVIrj/YgI0CfM+7e0hpDvo0w==
X-MS-Exchange-AntiSpam-MessageData: rcV9HQfaQHzpog1DBweL59ugg9+0Cv6TitNLhxIM82DGNVAcpzqBUJGABwMMmDM/YrAc7KFux3+n1NYS4AIoAaHYr5+H7IqSktEV06FontUmgcZJANHDR5tmXyMaCScoPB8fnpyUfycQgoMlSGq18A==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 212395ee-e84d-47c9-15f5-08d7c724589a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2020 07:58:51.6602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dygRMxqXLZJY4scn0Om13tNb9MDMrUA3HMZR9crVu3Lt9pI8jKe2SIQJkvAa3DV+6mveqek1EQSuTKE4ELGQvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6944
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implements all required functions for programming
the stage2 page table for each Guest/VM.

At high-level, the flow of stage2 related functions is similar
from KVM ARM/ARM64 implementation but the stage2 page table
format is quite different for KVM RISC-V.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/riscv/include/asm/kvm_host.h     |  10 +
 arch/riscv/include/asm/pgtable-bits.h |   1 +
 arch/riscv/kvm/mmu.c                  | 565 +++++++++++++++++++++++++-
 3 files changed, 566 insertions(+), 10 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 35a291493f05..dd1acb011fff 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -73,6 +73,13 @@ struct kvm_mmio_decode {
 	int return_handled;
 };
 
+#define KVM_MMU_PAGE_CACHE_NR_OBJS	32
+
+struct kvm_mmu_page_cache {
+	int nobjs;
+	void *objects[KVM_MMU_PAGE_CACHE_NR_OBJS];
+};
+
 struct kvm_cpu_context {
 	unsigned long zero;
 	unsigned long ra;
@@ -164,6 +171,9 @@ struct kvm_vcpu_arch {
 	/* MMIO instruction details */
 	struct kvm_mmio_decode mmio_decode;
 
+	/* Cache pages needed to program page tables with spinlock held */
+	struct kvm_mmu_page_cache mmu_page_cache;
+
 	/* VCPU power-off state */
 	bool power_off;
 
diff --git a/arch/riscv/include/asm/pgtable-bits.h b/arch/riscv/include/asm/pgtable-bits.h
index bbaeb5d35842..be49d62fcc2b 100644
--- a/arch/riscv/include/asm/pgtable-bits.h
+++ b/arch/riscv/include/asm/pgtable-bits.h
@@ -26,6 +26,7 @@
 
 #define _PAGE_SPECIAL   _PAGE_SOFT
 #define _PAGE_TABLE     _PAGE_PRESENT
+#define _PAGE_LEAF      (_PAGE_READ | _PAGE_WRITE | _PAGE_EXEC)
 
 /*
  * _PAGE_PROT_NONE is set on not-present pages (and ignored by the hardware) to
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 2b965f9aac07..f491c6aa4502 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -17,6 +17,357 @@
 #include <linux/sched/signal.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
+#include <asm/sbi.h>
+
+#ifdef CONFIG_64BIT
+#define stage2_have_pmd		true
+#define stage2_gpa_size		((phys_addr_t)(1ULL << 39))
+#define stage2_pgd_levels	3
+#define stage2_index_bits	9
+#else
+#define stage2_have_pmd		false
+#define stage2_gpa_size		((phys_addr_t)(1ULL << 32))
+#define stage2_pgd_levels	2
+#define stage2_index_bits	10
+#endif
+
+#define stage2_pte_index(addr, level) \
+(((addr) >> (PAGE_SHIFT + stage2_index_bits * (level))) & (PTRS_PER_PTE - 1))
+
+static inline unsigned long stage2_pte_page_vaddr(pte_t pte)
+{
+	return (unsigned long)pfn_to_virt(pte_val(pte) >> _PAGE_PFN_SHIFT);
+}
+
+static int stage2_page_size_to_level(unsigned long page_size, u32 *out_level)
+{
+	if (page_size == PAGE_SIZE)
+		*out_level = 0;
+	else if (page_size == PMD_SIZE)
+		*out_level = 1;
+	else if (page_size == PGDIR_SIZE)
+		*out_level = (stage2_have_pmd) ? 2 : 1;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
+static int stage2_level_to_page_size(u32 level, unsigned long *out_pgsize)
+{
+	switch (level) {
+	case 0:
+		*out_pgsize = PAGE_SIZE;
+		break;
+	case 1:
+		*out_pgsize = (stage2_have_pmd) ? PMD_SIZE : PGDIR_SIZE;
+		break;
+	case 2:
+		*out_pgsize = PGDIR_SIZE;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int stage2_cache_topup(struct kvm_mmu_page_cache *pcache,
+			      int min, int max)
+{
+	void *page;
+
+	BUG_ON(max > KVM_MMU_PAGE_CACHE_NR_OBJS);
+	if (pcache->nobjs >= min)
+		return 0;
+	while (pcache->nobjs < max) {
+		page = (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+		if (!page)
+			return -ENOMEM;
+		pcache->objects[pcache->nobjs++] = page;
+	}
+
+	return 0;
+}
+
+static void stage2_cache_flush(struct kvm_mmu_page_cache *pcache)
+{
+	while (pcache && pcache->nobjs)
+		free_page((unsigned long)pcache->objects[--pcache->nobjs]);
+}
+
+static void *stage2_cache_alloc(struct kvm_mmu_page_cache *pcache)
+{
+	void *p;
+
+	if (!pcache)
+		return NULL;
+
+	BUG_ON(!pcache->nobjs);
+	p = pcache->objects[--pcache->nobjs];
+
+	return p;
+}
+
+static bool stage2_get_leaf_entry(struct kvm *kvm, gpa_t addr,
+				  pte_t **ptepp, u32 *ptep_level)
+{
+	pte_t *ptep;
+	u32 current_level = stage2_pgd_levels - 1;
+
+	*ptep_level = current_level;
+	ptep = (pte_t *)kvm->arch.pgd;
+	ptep = &ptep[stage2_pte_index(addr, current_level)];
+	while (ptep && pte_val(*ptep)) {
+		if (pte_val(*ptep) & _PAGE_LEAF) {
+			*ptep_level = current_level;
+			*ptepp = ptep;
+			return true;
+		}
+
+		if (current_level) {
+			current_level--;
+			*ptep_level = current_level;
+			ptep = (pte_t *)stage2_pte_page_vaddr(*ptep);
+			ptep = &ptep[stage2_pte_index(addr, current_level)];
+		} else {
+			ptep = NULL;
+		}
+	}
+
+	return false;
+}
+
+static void stage2_remote_tlb_flush(struct kvm *kvm, u32 level, gpa_t addr)
+{
+	struct cpumask hmask;
+	unsigned long size = PAGE_SIZE;
+	struct kvm_vmid *vmid = &kvm->arch.vmid;
+
+	if (stage2_level_to_page_size(level, &size))
+		return;
+	addr &= ~(size - 1);
+
+	/*
+	 * TODO: Instead of cpu_online_mask, we should only target CPUs
+	 * where the Guest/VM is running.
+	 */
+	preempt_disable();
+	riscv_cpuid_to_hartid_mask(cpu_online_mask, &hmask);
+	sbi_remote_hfence_gvma_vmid(cpumask_bits(&hmask), addr, size,
+				    READ_ONCE(vmid->vmid));
+	preempt_enable();
+}
+
+static int stage2_set_pte(struct kvm *kvm, u32 level,
+			   struct kvm_mmu_page_cache *pcache,
+			   gpa_t addr, const pte_t *new_pte)
+{
+	u32 current_level = stage2_pgd_levels - 1;
+	pte_t *next_ptep = (pte_t *)kvm->arch.pgd;
+	pte_t *ptep = &next_ptep[stage2_pte_index(addr, current_level)];
+
+	if (current_level < level)
+		return -EINVAL;
+
+	while (current_level != level) {
+		if (pte_val(*ptep) & _PAGE_LEAF)
+			return -EEXIST;
+
+		if (!pte_val(*ptep)) {
+			next_ptep = stage2_cache_alloc(pcache);
+			if (!next_ptep)
+				return -ENOMEM;
+			*ptep = pfn_pte(PFN_DOWN(__pa(next_ptep)),
+					__pgprot(_PAGE_TABLE));
+		} else {
+			if (pte_val(*ptep) & _PAGE_LEAF)
+				return -EEXIST;
+			next_ptep = (pte_t *)stage2_pte_page_vaddr(*ptep);
+		}
+
+		current_level--;
+		ptep = &next_ptep[stage2_pte_index(addr, current_level)];
+	}
+
+	*ptep = *new_pte;
+	if (pte_val(*ptep) & _PAGE_LEAF)
+		stage2_remote_tlb_flush(kvm, current_level, addr);
+
+	return 0;
+}
+
+static int stage2_map_page(struct kvm *kvm,
+			   struct kvm_mmu_page_cache *pcache,
+			   gpa_t gpa, phys_addr_t hpa,
+			   unsigned long page_size, pgprot_t prot)
+{
+	int ret;
+	u32 level = 0;
+	pte_t new_pte;
+
+	ret = stage2_page_size_to_level(page_size, &level);
+	if (ret)
+		return ret;
+
+	new_pte = pfn_pte(PFN_DOWN(hpa), prot);
+	return stage2_set_pte(kvm, level, pcache, gpa, &new_pte);
+}
+
+enum stage2_op {
+	STAGE2_OP_NOP = 0,	/* Nothing */
+	STAGE2_OP_CLEAR,	/* Clear/Unmap */
+	STAGE2_OP_WP,		/* Write-protect */
+};
+
+static void stage2_op_pte(struct kvm *kvm, gpa_t addr,
+			  pte_t *ptep, u32 ptep_level, enum stage2_op op)
+{
+	int i, ret;
+	pte_t *next_ptep;
+	u32 next_ptep_level;
+	unsigned long next_page_size, page_size;
+
+	ret = stage2_level_to_page_size(ptep_level, &page_size);
+	if (ret)
+		return;
+
+	BUG_ON(addr & (page_size - 1));
+
+	if (!pte_val(*ptep))
+		return;
+
+	if (ptep_level && !(pte_val(*ptep) & _PAGE_LEAF)) {
+		next_ptep = (pte_t *)stage2_pte_page_vaddr(*ptep);
+		next_ptep_level = ptep_level - 1;
+		ret = stage2_level_to_page_size(next_ptep_level,
+						&next_page_size);
+		if (ret)
+			return;
+
+		if (op == STAGE2_OP_CLEAR)
+			set_pte(ptep, __pte(0));
+		for (i = 0; i < PTRS_PER_PTE; i++)
+			stage2_op_pte(kvm, addr + i * next_page_size,
+					&next_ptep[i], next_ptep_level, op);
+		if (op == STAGE2_OP_CLEAR)
+			put_page(virt_to_page(next_ptep));
+	} else {
+		if (op == STAGE2_OP_CLEAR)
+			set_pte(ptep, __pte(0));
+		else if (op == STAGE2_OP_WP)
+			set_pte(ptep, __pte(pte_val(*ptep) & ~_PAGE_WRITE));
+		stage2_remote_tlb_flush(kvm, ptep_level, addr);
+	}
+}
+
+static void stage2_unmap_range(struct kvm *kvm, gpa_t start, gpa_t size)
+{
+	int ret;
+	pte_t *ptep;
+	u32 ptep_level;
+	bool found_leaf;
+	unsigned long page_size;
+	gpa_t addr = start, end = start + size;
+
+	while (addr < end) {
+		found_leaf = stage2_get_leaf_entry(kvm, addr,
+						   &ptep, &ptep_level);
+		ret = stage2_level_to_page_size(ptep_level, &page_size);
+		if (ret)
+			break;
+
+		if (!found_leaf)
+			goto next;
+
+		if (!(addr & (page_size - 1)) && ((end - addr) >= page_size))
+			stage2_op_pte(kvm, addr, ptep,
+				      ptep_level, STAGE2_OP_CLEAR);
+
+next:
+		addr += page_size;
+	}
+}
+
+static void stage2_wp_range(struct kvm *kvm, gpa_t start, gpa_t end)
+{
+	int ret;
+	pte_t *ptep;
+	u32 ptep_level;
+	bool found_leaf;
+	gpa_t addr = start;
+	unsigned long page_size;
+
+	while (addr < end) {
+		found_leaf = stage2_get_leaf_entry(kvm, addr,
+						   &ptep, &ptep_level);
+		ret = stage2_level_to_page_size(ptep_level, &page_size);
+		if (ret)
+			break;
+
+		if (!found_leaf)
+			goto next;
+
+		if (!(addr & (page_size - 1)) && ((end - addr) >= page_size))
+			stage2_op_pte(kvm, addr, ptep,
+				      ptep_level, STAGE2_OP_WP);
+
+next:
+		addr += page_size;
+	}
+}
+
+void stage2_wp_memory_region(struct kvm *kvm, int slot)
+{
+	struct kvm_memslots *slots = kvm_memslots(kvm);
+	struct kvm_memory_slot *memslot = id_to_memslot(slots, slot);
+	phys_addr_t start = memslot->base_gfn << PAGE_SHIFT;
+	phys_addr_t end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
+
+	spin_lock(&kvm->mmu_lock);
+	stage2_wp_range(kvm, start, end);
+	spin_unlock(&kvm->mmu_lock);
+	kvm_flush_remote_tlbs(kvm);
+}
+
+int stage2_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
+		   unsigned long size, bool writable)
+{
+	pte_t pte;
+	int ret = 0;
+	unsigned long pfn;
+	phys_addr_t addr, end;
+	struct kvm_mmu_page_cache pcache = { 0, };
+
+	end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
+	pfn = __phys_to_pfn(hpa);
+
+	for (addr = gpa; addr < end; addr += PAGE_SIZE) {
+		pte = pfn_pte(pfn, PAGE_KERNEL);
+
+		if (!writable)
+			pte = pte_wrprotect(pte);
+
+		ret = stage2_cache_topup(&pcache,
+					 stage2_pgd_levels,
+					 KVM_MMU_PAGE_CACHE_NR_OBJS);
+		if (ret)
+			goto out;
+
+		spin_lock(&kvm->mmu_lock);
+		ret = stage2_set_pte(kvm, 0, &pcache, addr, &pte);
+		spin_unlock(&kvm->mmu_lock);
+		if (ret)
+			goto out;
+
+		pfn++;
+	}
+
+out:
+	stage2_cache_flush(&pcache);
+	return ret;
+
+}
 
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 			   struct kvm_memory_slot *dont)
@@ -35,7 +386,7 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	/* TODO: */
+	kvm_riscv_stage2_free_pgd(kvm);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
@@ -49,7 +400,13 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
 {
-	/* TODO: */
+	/*
+	 * At this point memslot has been committed and there is an
+	 * allocated dirty_bitmap[], dirty pages will be be tracked while the
+	 * memory slot is write protected.
+	 */
+	if (change != KVM_MR_DELETE && mem->flags & KVM_MEM_LOG_DIRTY_PAGES)
+		stage2_wp_memory_region(kvm, mem->slot);
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
@@ -57,34 +414,222 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				const struct kvm_userspace_memory_region *mem,
 				enum kvm_mr_change change)
 {
-	/* TODO: */
-	return 0;
+	hva_t hva = mem->userspace_addr;
+	hva_t reg_end = hva + mem->memory_size;
+	bool writable = !(mem->flags & KVM_MEM_READONLY);
+	int ret = 0;
+
+	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
+			change != KVM_MR_FLAGS_ONLY)
+		return 0;
+
+	/*
+	 * Prevent userspace from creating a memory region outside of the GPA
+	 * space addressable by the KVM guest GPA space.
+	 */
+	if ((memslot->base_gfn + memslot->npages) >=
+	    (stage2_gpa_size >> PAGE_SHIFT))
+		return -EFAULT;
+
+	down_read(&current->mm->mmap_sem);
+
+	/*
+	 * A memory region could potentially cover multiple VMAs, and
+	 * any holes between them, so iterate over all of them to find
+	 * out if we can map any of them right now.
+	 *
+	 *     +--------------------------------------------+
+	 * +---------------+----------------+   +----------------+
+	 * |   : VMA 1     |      VMA 2     |   |    VMA 3  :    |
+	 * +---------------+----------------+   +----------------+
+	 *     |               memory region                |
+	 *     +--------------------------------------------+
+	 */
+	do {
+		struct vm_area_struct *vma = find_vma(current->mm, hva);
+		hva_t vm_start, vm_end;
+
+		if (!vma || vma->vm_start >= reg_end)
+			break;
+
+		/*
+		 * Mapping a read-only VMA is only allowed if the
+		 * memory region is configured as read-only.
+		 */
+		if (writable && !(vma->vm_flags & VM_WRITE)) {
+			ret = -EPERM;
+			break;
+		}
+
+		/* Take the intersection of this VMA with the memory region */
+		vm_start = max(hva, vma->vm_start);
+		vm_end = min(reg_end, vma->vm_end);
+
+		if (vma->vm_flags & VM_PFNMAP) {
+			gpa_t gpa = mem->guest_phys_addr +
+				    (vm_start - mem->userspace_addr);
+			phys_addr_t pa;
+
+			pa = (phys_addr_t)vma->vm_pgoff << PAGE_SHIFT;
+			pa += vm_start - vma->vm_start;
+
+			/* IO region dirty page logging not allowed */
+			if (memslot->flags & KVM_MEM_LOG_DIRTY_PAGES) {
+				ret = -EINVAL;
+				goto out;
+			}
+
+			ret = stage2_ioremap(kvm, gpa, pa,
+					     vm_end - vm_start, writable);
+			if (ret)
+				break;
+		}
+		hva = vm_end;
+	} while (hva < reg_end);
+
+	if (change == KVM_MR_FLAGS_ONLY)
+		goto out;
+
+	spin_lock(&kvm->mmu_lock);
+	if (ret)
+		stage2_unmap_range(kvm, mem->guest_phys_addr,
+				   mem->memory_size);
+	spin_unlock(&kvm->mmu_lock);
+
+out:
+	up_read(&current->mm->mmap_sem);
+	return ret;
 }
 
 int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long hva,
 			 bool is_write)
 {
-	/* TODO: */
-	return 0;
+	int ret;
+	short lsb;
+	kvm_pfn_t hfn;
+	bool writeable;
+	gfn_t gfn = gpa >> PAGE_SHIFT;
+	struct vm_area_struct *vma;
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_mmu_page_cache *pcache = &vcpu->arch.mmu_page_cache;
+	unsigned long vma_pagesize;
+
+	down_read(&current->mm->mmap_sem);
+
+	vma = find_vma_intersection(current->mm, hva, hva + 1);
+	if (unlikely(!vma)) {
+		kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
+		up_read(&current->mm->mmap_sem);
+		return -EFAULT;
+	}
+
+	vma_pagesize = vma_kernel_pagesize(vma);
+
+	if (vma_pagesize == PMD_SIZE || vma_pagesize == PGDIR_SIZE)
+		gfn = (gpa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
+
+	up_read(&current->mm->mmap_sem);
+
+	if (vma_pagesize != PGDIR_SIZE &&
+	    vma_pagesize != PMD_SIZE &&
+	    vma_pagesize != PAGE_SIZE) {
+		kvm_err("Invalid VMA page size 0x%lx\n", vma_pagesize);
+		return -EFAULT;
+	}
+
+	/* We need minimum second+third level pages */
+	ret = stage2_cache_topup(pcache, stage2_pgd_levels,
+				 KVM_MMU_PAGE_CACHE_NR_OBJS);
+	if (ret) {
+		kvm_err("Failed to topup stage2 cache\n");
+		return ret;
+	}
+
+	hfn = gfn_to_pfn_prot(kvm, gfn, is_write, &writeable);
+	if (hfn == KVM_PFN_ERR_HWPOISON) {
+		if (is_vm_hugetlb_page(vma))
+			lsb = huge_page_shift(hstate_vma(vma));
+		else
+			lsb = PAGE_SHIFT;
+
+		send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva,
+				lsb, current);
+		return 0;
+	}
+	if (is_error_noslot_pfn(hfn))
+		return -EFAULT;
+	if (!writeable && is_write)
+		return -EPERM;
+
+	spin_lock(&kvm->mmu_lock);
+
+	if (writeable) {
+		kvm_set_pfn_dirty(hfn);
+		ret = stage2_map_page(kvm, pcache, gpa, hfn << PAGE_SHIFT,
+				      vma_pagesize, PAGE_WRITE_EXEC);
+	} else {
+		ret = stage2_map_page(kvm, pcache, gpa, hfn << PAGE_SHIFT,
+				      vma_pagesize, PAGE_READ_EXEC);
+	}
+
+	if (ret)
+		kvm_err("Failed to map in stage2\n");
+
+	spin_unlock(&kvm->mmu_lock);
+	kvm_set_pfn_accessed(hfn);
+	kvm_release_pfn_clean(hfn);
+	return ret;
 }
 
 void kvm_riscv_stage2_flush_cache(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
+	stage2_cache_flush(&vcpu->arch.mmu_page_cache);
 }
 
 int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm)
 {
-	/* TODO: */
+	if (kvm->arch.pgd != NULL) {
+		kvm_err("kvm_arch already initialized?\n");
+		return -EINVAL;
+	}
+
+	kvm->arch.pgd = alloc_pages_exact(PAGE_SIZE, GFP_KERNEL | __GFP_ZERO);
+	if (!kvm->arch.pgd)
+		return -ENOMEM;
+	kvm->arch.pgd_phys = virt_to_phys(kvm->arch.pgd);
+
 	return 0;
 }
 
 void kvm_riscv_stage2_free_pgd(struct kvm *kvm)
 {
-	/* TODO: */
+	void *pgd = NULL;
+
+	spin_lock(&kvm->mmu_lock);
+	if (kvm->arch.pgd) {
+		stage2_unmap_range(kvm, 0UL, stage2_gpa_size);
+		pgd = READ_ONCE(kvm->arch.pgd);
+		kvm->arch.pgd = NULL;
+		kvm->arch.pgd_phys = 0;
+	}
+	spin_unlock(&kvm->mmu_lock);
+
+	/* Free the HW pgd, one page at a time */
+	if (pgd)
+		free_pages_exact(pgd, PAGE_SIZE);
 }
 
 void kvm_riscv_stage2_update_hgatp(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
+	unsigned long hgatp = HGATP_MODE;
+	struct kvm_arch *k = &vcpu->kvm->arch;
+
+	hgatp |= (READ_ONCE(k->vmid.vmid) << HGATP_VMID_SHIFT) &
+		 HGATP_VMID_MASK;
+	hgatp |= (k->pgd_phys >> PAGE_SHIFT) & HGATP_PPN;
+
+	csr_write(CSR_HGATP, hgatp);
+
+	if (!kvm_riscv_stage2_vmid_bits())
+		__kvm_riscv_hfence_gvma_all();
 }
-- 
2.17.1

