Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55D4C1841FA
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 08:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgCMH7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 03:59:10 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:9476 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgCMH7K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Mar 2020 03:59:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1584086349; x=1615622349;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=YAIJLnZvobyxJy0SBvzqsFEq90XwopffdCzBW7qlVvs=;
  b=R6mN97L3PJGtfsgUO6c+htlVqJLe+qpxfbKKHxIZaW8dz/JQfAVS6UIu
   RFBTjA9Lf+x3iWc90Z8vGdg09ZWDshzkTejbh9OnE1wigZOaJHO2Qdy7F
   eJzhqJtRCy8jDJftO086oyH1iDhTYDOXirDixOoK/bmW1GRhTdjzhX5hL
   xp7YO0+Fp5OoRnlTj7lMr+HxPGiLdF0B4TLhxd0fSBynCqatxEkcZIAXk
   gBJ3pzhnXi7a84rM5NLZq1S4nt3bArtU4+Z38yD9bSMyeK9IC4+1NvklR
   zUSRrS5gqS5UAbZGPnI3eDTqwsnpqWXLBtnepZFK9gTlubZawJx77fiab
   A==;
IronPort-SDR: U+HzWt21LIJ2hq2lOF5Eqfhm5DLWph/jEVawyCRT3+vHv7x8BPaTW1o6MhJRR3Mk9GaDOZXQTA
 W2zJLeL8gJCg/3dv2Ibj2+Ex1giYEaDzlDfZ9Hx2+Sjn5boRS7K5kQe5IFi99AgMm0qdYG/tSL
 hZPCMmTcxOC3sPEjgE0DtdzN6dnTaBQ3VKX/1k0vHivPbd/C/GjhUQG3wxKzh7V74Jkwp9jG6z
 DkABFcZXDIeJPD8OxJV9hZm6qLa1S7zprdLP9zkYJL9pYJggJQZbfcKW0/X6VBZMEH1oHqh3Fz
 uro=
X-IronPort-AV: E=Sophos;i="5.70,547,1574092800"; 
   d="scan'208";a="132827927"
Received: from mail-bn7nam10lp2102.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.102])
  by ob1.hgst.iphmx.com with ESMTP; 13 Mar 2020 15:59:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YIku4H3tWFi6tsD8Hrpp3nBJHuRtO1FvkHlPjrSJZw+z4p8lqxylYXFXYWaj5wu9gdQhIHuShy3SRPU+OqPnjaBuEyjooKcSt8tFL9yt1TcIEBL81dx7C9MnwILX9LsL1a4MGPj2n9YMrlxMXQQAWql7JxOey/B8Z5hy5/h1Re/gtItavEkrctfMo5+Vww/2O0VmKdNC+ecinbmn1A2x0/X3w/xceAfKqdjU2bdHIdiKus41eGiUwJ4FH+RFMfVMQAwvP787yDPSH+ysUDx0YIDxgSAvMwMpwFpRFpwMqsKwxP3OQgmUZqYhF+ZBLco24OhtF88W6p7LaqUOqPW4kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9CByRPzw1st0PE5/D2jYSfzp7JaxdLOYkGn+BXF0+O0=;
 b=HuZctJUQiLmu1NkOfordPNULpYMAh0aHRMovdQCPTPrwOYJNtE70qPe8CMvNpZ62VRUolyNQgtTLeFuvOSdkcFXa1qCfWW4GI9jHnnyD7YWi+UJTrBSzNDHvyfrZfYDvYFU+uhe838YB2n+FOFmiJClFkia0cyf4a6T3i7QR2kvbVxui+e0viBnNjaXyS71dlf3dCLxAz6Qexm5eGT/5gLmReZlGpgHjiA/BL8CBTjIjI/TTjnczDTIpaavLOqmzHpj9Mv3te0R5YD76HhwkPLWxlF5aIfKaHmRTpdNi8V4dZ8BHR2dxK0Yb4e3nGr3mNBZi/7M8zTRoMbtyF2Wpiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9CByRPzw1st0PE5/D2jYSfzp7JaxdLOYkGn+BXF0+O0=;
 b=C1CXTXXa9e0OwI7hpvcFCrNIVGpw/QeipkwYSDe99wbdSfiLngAMU12lGiDOtCeGG1dy/r2kxIOt64dw2+fk9W1Qet+xu9PMFxuqZk3M/JOsQB/b+VjG9LtVLkNRUg8oWD96g2+C+I1AklLRooDGGbfYSH3vptMjjQ2FhLKkxMk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
 by MN2PR04MB6319.namprd04.prod.outlook.com (2603:10b6:208:1aa::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16; Fri, 13 Mar
 2020 07:59:06 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8%6]) with mapi id 15.20.2814.018; Fri, 13 Mar 2020
 07:59:06 +0000
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
Subject: [PATCH v11 14/20] RISC-V: KVM: Implement MMU notifiers
Date:   Fri, 13 Mar 2020 13:21:25 +0530
Message-Id: <20200313075131.69837-15-anup.patel@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200313075131.69837-1-anup.patel@wdc.com>
References: <20200313075131.69837-1-anup.patel@wdc.com>
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::19) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (1.39.129.91) by MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14 via Frontend Transport; Fri, 13 Mar 2020 07:58:55 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [1.39.129.91]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a934518b-4d09-47bc-f46f-08d7c724677b
X-MS-TrafficTypeDiagnostic: MN2PR04MB6319:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR04MB631918221FFA5E31CF0A3A9D8DFA0@MN2PR04MB6319.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-Forefront-PRVS: 034119E4F6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(396003)(136003)(346002)(366004)(376002)(199004)(1006002)(478600001)(2616005)(956004)(8886007)(8936002)(7416002)(36756003)(81156014)(16526019)(81166006)(1076003)(55016002)(186003)(52116002)(86362001)(26005)(44832011)(7696005)(8676002)(54906003)(5660300002)(4326008)(66556008)(316002)(6666004)(66476007)(110136005)(66946007)(2906002)(36456003)(42976004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6319;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BEMGjoeGuKINmxXCgZwHKVq93G0wCpVvGc7LjxC46RFvjsCHvH57azMY0Jkp4WPj65r29S9J38pTFX+BIaw7HI8/rml7e7vwZeyxDpOe5koo/Vzl1SkWjfVSjD7U/Dap3re+qYMPnOSdP+aLqTTgsqvRfevaz81SGlcK/sRFOC9ixd/GB9gM0RczedA9BWDdGtETcWvnCxn3CFgLzU7cwsrnq+SOFVRUHfJNPQbQJ26XV8tVuZI2YpgpqqNj9l5TTyTRdEixfubhU+l3P+c/bQc8gN7GMLSGEXU55XeHzfkm+rhJXsda7Cx9tuCsfs01eBv7DdBwofGSOPvSuvNWEa8L9KoCW7EP5icWcfZ74ozmefJZbhcQUKxHcDk8RgWcLmuj4zpdD9Dqy56WHXrhrhta5bRYyit+1k9/2LB9ua/EB9Il4vqBtx9u0lEMSNj02DBALI51lHxjWjoGhIlb41aGkAtK6bT0a3tfYEF6VL6aZBKQ1781wt71ScyvtoThH1PeWV/T7qd3zVsMhnaNnQ==
X-MS-Exchange-AntiSpam-MessageData: 7SUJumF97o0EODJ0krh/pGpN5iTfmbgzzhlhyV3Zc3O6BcTaA7huGAceEUnoY8gFnd3gCgLA8NrINFtP3zopwhkQyyWIWVDkvCtbXvKnf5D0mpkgOffEITeqCeGWMn9hnTZYU2M7iogeyLwHo5ktcw==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a934518b-4d09-47bc-f46f-08d7c724677b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2020 07:59:06.8339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7m7brSE8p5MCYy5NvLFcb3pZstHQdTWRKvdTh6Cw0WJpMp5rODnjU2oRDfNOdPuqfOoSE3rsEs1ttR4SblKapQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6319
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
 arch/riscv/kvm/mmu.c              | 129 +++++++++++++++++++++++++++++-
 arch/riscv/kvm/vm.c               |   1 +
 4 files changed, 137 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index dd1acb011fff..cc0b09918431 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -190,6 +190,13 @@ static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
+#define KVM_ARCH_WANT_MMU_NOTIFIER
+int kvm_unmap_hva_range(struct kvm *kvm,
+			unsigned long start, unsigned long end);
+int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
+int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
+int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
+
 void __kvm_riscv_hfence_gvma_vmid_gpa(unsigned long vmid,
 				      unsigned long gpa);
 void __kvm_riscv_hfence_gvma_vmid(unsigned long vmid);
diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
index 88edd477b3a8..2356dc52ebb3 100644
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
index f491c6aa4502..d88a50cde750 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -369,6 +369,38 @@ int stage2_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
 
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
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 			   struct kvm_memory_slot *dont)
 {
@@ -501,6 +533,95 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	return ret;
 }
 
+static int kvm_unmap_hva_handler(struct kvm *kvm,
+				 gpa_t gpa, u64 size, void *data)
+{
+	stage2_unmap_range(kvm, gpa, size);
+	return 0;
+}
+
+int kvm_unmap_hva_range(struct kvm *kvm,
+			unsigned long start, unsigned long end)
+{
+	if (!kvm->arch.pgd)
+		return 0;
+
+	handle_hva_to_gpa(kvm, start, end,
+			  &kvm_unmap_hva_handler, NULL);
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
+	handle_hva_to_gpa(kvm, hva, end,
+			  &kvm_set_spte_handler, &stage2_pte);
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
 int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long hva,
 			 bool is_write)
 {
@@ -512,7 +633,7 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long hva,
 	struct vm_area_struct *vma;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_page_cache *pcache = &vcpu->arch.mmu_page_cache;
-	unsigned long vma_pagesize;
+	unsigned long vma_pagesize, mmu_seq;
 
 	down_read(&current->mm->mmap_sem);
 
@@ -545,6 +666,8 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long hva,
 		return ret;
 	}
 
+	mmu_seq = kvm->mmu_notifier_seq;
+
 	hfn = gfn_to_pfn_prot(kvm, gfn, is_write, &writeable);
 	if (hfn == KVM_PFN_ERR_HWPOISON) {
 		if (is_vm_hugetlb_page(vma))
@@ -563,6 +686,9 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long hva,
 
 	spin_lock(&kvm->mmu_lock);
 
+	if (mmu_notifier_retry(kvm, mmu_seq))
+		goto out_unlock;
+
 	if (writeable) {
 		kvm_set_pfn_dirty(hfn);
 		ret = stage2_map_page(kvm, pcache, gpa, hfn << PAGE_SHIFT,
@@ -575,6 +701,7 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long hva,
 	if (ret)
 		kvm_err("Failed to map in stage2\n");
 
+out_unlock:
 	spin_unlock(&kvm->mmu_lock);
 	kvm_set_pfn_accessed(hfn);
 	kvm_release_pfn_clean(hfn);
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index c5aab5478c38..fd84b4d914dc 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -54,6 +54,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	switch (ext) {
 	case KVM_CAP_DEVICE_CTRL:
 	case KVM_CAP_USER_MEMORY:
+	case KVM_CAP_SYNC_MMU:
 	case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
 	case KVM_CAP_ONE_REG:
 	case KVM_CAP_READONLY_MEM:
-- 
2.17.1

