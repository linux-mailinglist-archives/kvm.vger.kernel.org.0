Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0700F21B141
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 10:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgGJI1f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 04:27:35 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:13738 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728025AbgGJI1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 04:27:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594369654; x=1625905654;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=BmGNHg/cstlMQiiSUvy3nGutOnMJO9D0E0Q35pI61hU=;
  b=qSPnNVEvIHzri6ubZ67PujmpPDmZLvjNsAawKoW5T/14z8tdDrLOJ1rn
   2tLhRUHCaK9XAP31tWIn+bHgz0NakdqXy1+kPTN9hJfCCx+BlksDrsF98
   ne23y1lYdFmBo5987096kQ0/iqObqiLWctuCXcUoCrOg0J44qk9irwIJn
   hvHyElaZrDtRxyqH2hyo6ncC1Dr9snV2TliLcIDbcqZp16ndKKHNhnqXt
   Av5D4yxOz+3XU6U5uIe3p5JgoIwAWeid0wDf/3OrRsNeth7/hTMyQEC02
   w2NHnY5Dtl2ziUinbzN+0e/C7cRFAlmUEIX9emPs4BTlJUdYdaas+CHeL
   Q==;
IronPort-SDR: LIpCHghbhd0yD+RH9PQ77TfvokOAMhMgltaT/erCpZlXvBewNapiKbrX/5qVyK3H36OATLR5tX
 U72QKENmWqdCM/QRksmCyo48oBw+ER/7CXg0h7mUkPE8KtPPJEgYe5cJYFAtxuq1qBCVCvOsS2
 pUqhvnDnTpIqBfMXVAM379J9ivxECrw+1YQijiiQvlyh0v+Yb+lYaiHXThLNG+Eyl9bbHykmpv
 8zwoIx/Ofb9i/MgFI5ZE/gZ13HrJYcGxz+J6obGWfYhjfqSDAwKREKzIAiStSBAsAWXAYnTOMF
 o5Y=
X-IronPort-AV: E=Sophos;i="5.75,335,1589212800"; 
   d="scan'208";a="142275684"
Received: from mail-dm6nam11lp2170.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.170])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jul 2020 16:27:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jc+Z90+EzS6V7gAkcPXVp7SJRgMwDDdjCeJpk2wGGkW7MV4kayNcx1ybroKYa+9qLaUWrsS3oNE/F+KCTWAHM0irk58NQoOnkQoESlUz2cBmp6lBYjfXfE8iDK2TqFDnGCN1cDrUq9NXw4gsNfBnSWKfiQxBxtXHrsN2gZ505tvn1T+ALXMQADNizlDcEwGKIEXznZxgzLzi9ICX8+MQqD4GFWJrqmfv3J220sVi6CvlrmMR1IEGBj9PuU1LlshLWFHKiVBPmTWXOUKjsyk/TgaNnR8bNhESyF49KQlWdSe/DOBjROtwmXxGcSmXqL+ON87uhp40iG+Cv+BKK8c/bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/lzTSKU+F1mQYBS8yd/H92jquZiSagxX2X5FgS51KWc=;
 b=VmiV65fiGXVlpIjOco6w+FG2H89cr7bV/hN5t0jvVIqQQH1/t0tJfXn3Zzl+Mr+8/DzfPEBKr6ieW+eC79c9EljK62Zmq1lFat0/TnuvTQhQh6GCeoeVgChYTTsvmnuK+1fg4R4o8E3YZt70D5ChEknoo708K1shvBBraYF6uP/FmKyB/GHFC2KTv2TZgSVkr8yiuTD/wNkS7+AjfagIG6qOusJkzLZkd/PmXbg6Zdm3svzt2gHXVm7/d+bpjsaucl/S9MqJve5w4/w29e97adBtw7nLwNJwNnWjPrUJnc4uhNwuxokcJEwL9on1yBlFQtq2kIf2ClyDpWvkn040pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/lzTSKU+F1mQYBS8yd/H92jquZiSagxX2X5FgS51KWc=;
 b=Dghqd/opfSctSidvJV++NOdarFio18gkS2SkMNoV98MA/7zHLXyr0lKScyYUb73rxlucHxergcDq3pZ4LczjjogmIDrml+l1s3e5taIkf/COZCgKWvTmWyvYqCPcLbSKiljGvplZRbTpXjJ9P/J3tvHaic1S8i2gFH9BPfy95l8=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM5PR04MB0461.namprd04.prod.outlook.com (2603:10b6:3:ab::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Fri, 10 Jul
 2020 08:27:31 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::e0a4:aa82:1847:dea5]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::e0a4:aa82:1847:dea5%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 08:27:31 +0000
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
Subject: [PATCH v13 11/17] RISC-V: KVM: Implement MMU notifiers
Date:   Fri, 10 Jul 2020 13:55:42 +0530
Message-Id: <20200710082548.123180-12-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200710082548.123180-1-anup.patel@wdc.com>
References: <20200710082548.123180-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN1PR0101CA0035.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c00:c::21) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (103.15.57.207) by PN1PR0101CA0035.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:c::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Fri, 10 Jul 2020 08:27:25 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [103.15.57.207]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cdc7a5f4-1f4e-4cca-1823-08d824ab166d
X-MS-TrafficTypeDiagnostic: DM5PR04MB0461:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR04MB0461D4D984FD12F4CABF063A8D650@DM5PR04MB0461.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-Forefront-PRVS: 046060344D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lrhaTbxV9NcjnhP+wS3fYH3KIU8ZoifbtvwLdIy3fff89jHGlrf1w5q1AMdcSovrFAqq8HaJz5dd4JFVayex/pjdItu0eEyMvTSg+O9EqWey/jRBxvnuAZ/CgkIxvpmnbv0D01nOe80C0mAo2zzJZ01GEIlZG4HMa7NsSzF8Z8z2lc87Z1guaqBNQggnPnULePZKIeQXBxjWg5ALE3GELcuct8eO68RXgUPMCr5C0vWYoeKQCYV13gCkX5Ps4K7zW3VtR+OOBAARottFK/tQmvakshc+ZbEv0+9qem2jeuF9rIFYCyYC9s9Pc/6aiN22
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(2906002)(316002)(83380400001)(110136005)(54906003)(7416002)(478600001)(6666004)(86362001)(8936002)(5660300002)(7696005)(4326008)(2616005)(26005)(956004)(52116002)(8886007)(8676002)(186003)(66946007)(66476007)(55016002)(36756003)(66556008)(44832011)(16526019)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: uvmWuagtrT1Sgx8okjhlnN5Q+0fi+eVoCQp8xBXByNGlep5ZPJ1HuzbhnOhK2+crp4N26WId5NqQln3aYokFTPPD1k17gc3jnJ9tybUYgIHB23b0myZqfX3kfQe18PZuh1C0CpW7MfT91Z483BkEzNOXA+R2lWzQ4IF4W7qlt6hI5VD3Pn8nvgFjia5N/Zr92fWRrLgDosO+Q5nycpVMVSb17c+s/d7oOA06w0OzKY/pmtES2CIYZx+OcjzRIY8fZThDHLw4u6T0GhAfRmm/VTy5t0v1hM+NpyiDWNIz0oAC8+pTOEtLXJndhA2RspCT0bJprdWuRyjW+vYpGIJNhJ9WKL1xGJ6y1OKdxP7APh96BRr+qzlfcxxgECR2XGfXluFB4Eu8fvl1740fs0FRFGpBoWm0BREt3UC9Ev3vlu3UDCgFJLFGdojpCNMOgll/n/YdFRP9aCnWTXQcYUD/79lyqFLEUP6yXLRL+xN7FYY=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdc7a5f4-1f4e-4cca-1823-08d824ab166d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 08:27:31.0279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QnLU9rASlCAZ9Y+i2ASgBYmIzJ9sl4gylDADO6Jeq5qgXYydaoc983aKntSoLjemQaKRn+KGiw306fscqwj4qQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0461
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
index 9e754c0848b3..24985abbe2e7 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -200,6 +200,13 @@ static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
+#define KVM_ARCH_WANT_MMU_NOTIFIER
+int kvm_unmap_hva_range(struct kvm *kvm,
+			unsigned long start, unsigned long end);
+int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
+int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
+int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
+
 void __kvm_riscv_hfence_gvma_vmid_gpa(unsigned long gpa, unsigned long vmid);
 void __kvm_riscv_hfence_gvma_vmid(unsigned long vmid);
 void __kvm_riscv_hfence_gvma_gpa(unsigned long gpa);
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
index 3d13e15e7555..705c341e68cb 100644
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
 void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
 }
@@ -504,6 +536,95 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
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
 int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 			 struct kvm_memory_slot *memslot,
 			 gpa_t gpa, unsigned long hva, bool is_write)
@@ -518,7 +639,7 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 	struct kvm_mmu_page_cache *pcache = &vcpu->arch.mmu_page_cache;
 	bool logging = (memslot->dirty_bitmap &&
 			!(memslot->flags & KVM_MEM_READONLY)) ? true : false;
-	unsigned long vma_pagesize;
+	unsigned long vma_pagesize, mmu_seq;
 
 	mmap_read_lock(current->mm);
 
@@ -557,6 +678,8 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 		return ret;
 	}
 
+	mmu_seq = kvm->mmu_notifier_seq;
+
 	hfn = gfn_to_pfn_prot(kvm, gfn, is_write, &writeable);
 	if (hfn == KVM_PFN_ERR_HWPOISON) {
 		send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva,
@@ -575,6 +698,9 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 
 	spin_lock(&kvm->mmu_lock);
 
+	if (mmu_notifier_retry(kvm, mmu_seq))
+		goto out_unlock;
+
 	if (writeable) {
 		kvm_set_pfn_dirty(hfn);
 		mark_page_dirty(kvm, gfn);
@@ -588,6 +714,7 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
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
2.25.1

