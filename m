Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC2744FDE5D
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 13:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241628AbiDLL06 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 07:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352805AbiDLLZm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 07:25:42 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C190628E31
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 03:08:31 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id z6-20020a17090a398600b001cb9fca3210so2412868pjb.1
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 03:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fWSYu135o9Xwb2UpEPAVRY0VLWr642R/esqJyR3U11c=;
        b=PYbS94dDUsDc3iSzILlYA8hAPKHWKe6pK7J4SpB/bYXXsnxQ7iL/1G0D/mE5AIlTwf
         p6XURlVZF05sGVYLoeKHPvRZuJEyHLkX1e6JzN0HIoEV6G5idkMf6qvmiWi0eskGhkyd
         EXqWnQ1EFE9gwuaKJKmHAYE+7QBkWZy8qavFfW+Zy73E0GRLEhHR6n+4O/kBuVD0nfYr
         6FXXxFvOKOqfCy6IIH/g/Fcx+cv72HMke9e/Gv/KGSv6nD16iQbv3IJtoMpkYZIaK0+H
         rEDLLbymhgzjzz8hnkHLn0ygXv+XBf962sBs62kPIdQnnUxKQatVBa2WBF+6+I9DR+ys
         N9wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fWSYu135o9Xwb2UpEPAVRY0VLWr642R/esqJyR3U11c=;
        b=fSHuXmOXMtK0VHFIyhrsciqt3oc90huozFC93A2awvmm3kBRDnHmnD2f57GCq2AaY5
         i29VjGkJos2KkhbKRQHXUjQFffXjV+bNDsyZztgBNL4a0X1QnkXWIpq9Did+eWhycdFS
         98juFpAwAMnLeMSewwTMoSYxUaaRANh7LK/xl6HbyZSy21zlxyz+KYVb5cPdHTET8eJH
         Jjw846vQy23hLZkzRk4Pe0hq/pNjjV/BVc0gIeBM/wgGC8golOezf/M7Eq3ybSC0+G10
         XTb/MsfM3G04ILLc1O629Gq642iJA5nAo5HZPb6kjf+0etoHMlbWnTUOT6hRFzH5ope3
         lNvg==
X-Gm-Message-State: AOAM533pIWr7Cruhyghgh6axqQ8zqWREqix1p+vA98sKt2UldLNxtXjz
        HOgPXNNCv0keVqY4/sEYR5mqYw==
X-Google-Smtp-Source: ABdhPJyJxlRnBLMFzMuh/jILS7RBKph72UR+omrn/wLK/76hN9XoHydvgWTw6TRx8kcILHyi1bI6Tg==
X-Received: by 2002:a17:902:ecc1:b0:158:6e96:83a7 with SMTP id a1-20020a170902ecc100b001586e9683a7mr7388136plh.79.1649758111116;
        Tue, 12 Apr 2022 03:08:31 -0700 (PDT)
Received: from localhost.localdomain ([122.182.197.47])
        by smtp.gmail.com with ESMTPSA id j9-20020a056a00130900b004f73df40914sm37515088pfu.82.2022.04.12.03.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 03:08:30 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 1/6] RISC-V: KVM: Use G-stage name for hypervisor page table
Date:   Tue, 12 Apr 2022 15:37:08 +0530
Message-Id: <20220412100713.1415094-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220412100713.1415094-1-apatel@ventanamicro.com>
References: <20220412100713.1415094-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The two-stage address translation defined by the RISC-V privileged
specification defines: VS-stage (guest virtual address to guest
physical address) programmed by the Guest OS  and G-stage (guest
physical addree to host physical address) programmed by the
hypervisor.

To align with above terminology, we replace "stage2" with "gstage"
and "Stage2" with "G-stage" name everywhere in KVM RISC-V sources.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_host.h |  30 ++--
 arch/riscv/kvm/main.c             |   8 +-
 arch/riscv/kvm/mmu.c              | 222 +++++++++++++++---------------
 arch/riscv/kvm/vcpu.c             |  10 +-
 arch/riscv/kvm/vcpu_exit.c        |   6 +-
 arch/riscv/kvm/vm.c               |   8 +-
 arch/riscv/kvm/vmid.c             |  18 +--
 7 files changed, 151 insertions(+), 151 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 78da839657e5..3e2cbbd7d1c9 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -54,10 +54,10 @@ struct kvm_vmid {
 };
 
 struct kvm_arch {
-	/* stage2 vmid */
+	/* G-stage vmid */
 	struct kvm_vmid vmid;
 
-	/* stage2 page table */
+	/* G-stage page table */
 	pgd_t *pgd;
 	phys_addr_t pgd_phys;
 
@@ -210,21 +210,21 @@ void __kvm_riscv_hfence_gvma_vmid(unsigned long vmid);
 void __kvm_riscv_hfence_gvma_gpa(unsigned long gpa_divby_4);
 void __kvm_riscv_hfence_gvma_all(void);
 
-int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
+int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 			 struct kvm_memory_slot *memslot,
 			 gpa_t gpa, unsigned long hva, bool is_write);
-int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm);
-void kvm_riscv_stage2_free_pgd(struct kvm *kvm);
-void kvm_riscv_stage2_update_hgatp(struct kvm_vcpu *vcpu);
-void kvm_riscv_stage2_mode_detect(void);
-unsigned long kvm_riscv_stage2_mode(void);
-int kvm_riscv_stage2_gpa_bits(void);
-
-void kvm_riscv_stage2_vmid_detect(void);
-unsigned long kvm_riscv_stage2_vmid_bits(void);
-int kvm_riscv_stage2_vmid_init(struct kvm *kvm);
-bool kvm_riscv_stage2_vmid_ver_changed(struct kvm_vmid *vmid);
-void kvm_riscv_stage2_vmid_update(struct kvm_vcpu *vcpu);
+int kvm_riscv_gstage_alloc_pgd(struct kvm *kvm);
+void kvm_riscv_gstage_free_pgd(struct kvm *kvm);
+void kvm_riscv_gstage_update_hgatp(struct kvm_vcpu *vcpu);
+void kvm_riscv_gstage_mode_detect(void);
+unsigned long kvm_riscv_gstage_mode(void);
+int kvm_riscv_gstage_gpa_bits(void);
+
+void kvm_riscv_gstage_vmid_detect(void);
+unsigned long kvm_riscv_gstage_vmid_bits(void);
+int kvm_riscv_gstage_vmid_init(struct kvm *kvm);
+bool kvm_riscv_gstage_vmid_ver_changed(struct kvm_vmid *vmid);
+void kvm_riscv_gstage_vmid_update(struct kvm_vcpu *vcpu);
 
 void __kvm_riscv_unpriv_trap(void);
 
diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index 2e5ca43c8c49..c374dad82eee 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -89,13 +89,13 @@ int kvm_arch_init(void *opaque)
 		return -ENODEV;
 	}
 
-	kvm_riscv_stage2_mode_detect();
+	kvm_riscv_gstage_mode_detect();
 
-	kvm_riscv_stage2_vmid_detect();
+	kvm_riscv_gstage_vmid_detect();
 
 	kvm_info("hypervisor extension available\n");
 
-	switch (kvm_riscv_stage2_mode()) {
+	switch (kvm_riscv_gstage_mode()) {
 	case HGATP_MODE_SV32X4:
 		str = "Sv32x4";
 		break;
@@ -110,7 +110,7 @@ int kvm_arch_init(void *opaque)
 	}
 	kvm_info("using %s G-stage page table format\n", str);
 
-	kvm_info("VMID %ld bits available\n", kvm_riscv_stage2_vmid_bits());
+	kvm_info("VMID %ld bits available\n", kvm_riscv_gstage_vmid_bits());
 
 	return 0;
 }
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index f80a34fbf102..dc0520792e31 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -21,50 +21,50 @@
 #include <asm/sbi.h>
 
 #ifdef CONFIG_64BIT
-static unsigned long stage2_mode = (HGATP_MODE_SV39X4 << HGATP_MODE_SHIFT);
-static unsigned long stage2_pgd_levels = 3;
-#define stage2_index_bits	9
+static unsigned long gstage_mode = (HGATP_MODE_SV39X4 << HGATP_MODE_SHIFT);
+static unsigned long gstage_pgd_levels = 3;
+#define gstage_index_bits	9
 #else
-static unsigned long stage2_mode = (HGATP_MODE_SV32X4 << HGATP_MODE_SHIFT);
-static unsigned long stage2_pgd_levels = 2;
-#define stage2_index_bits	10
+static unsigned long gstage_mode = (HGATP_MODE_SV32X4 << HGATP_MODE_SHIFT);
+static unsigned long gstage_pgd_levels = 2;
+#define gstage_index_bits	10
 #endif
 
-#define stage2_pgd_xbits	2
-#define stage2_pgd_size	(1UL << (HGATP_PAGE_SHIFT + stage2_pgd_xbits))
-#define stage2_gpa_bits	(HGATP_PAGE_SHIFT + \
-			 (stage2_pgd_levels * stage2_index_bits) + \
-			 stage2_pgd_xbits)
-#define stage2_gpa_size	((gpa_t)(1ULL << stage2_gpa_bits))
+#define gstage_pgd_xbits	2
+#define gstage_pgd_size	(1UL << (HGATP_PAGE_SHIFT + gstage_pgd_xbits))
+#define gstage_gpa_bits	(HGATP_PAGE_SHIFT + \
+			 (gstage_pgd_levels * gstage_index_bits) + \
+			 gstage_pgd_xbits)
+#define gstage_gpa_size	((gpa_t)(1ULL << gstage_gpa_bits))
 
-#define stage2_pte_leaf(__ptep)	\
+#define gstage_pte_leaf(__ptep)	\
 	(pte_val(*(__ptep)) & (_PAGE_READ | _PAGE_WRITE | _PAGE_EXEC))
 
-static inline unsigned long stage2_pte_index(gpa_t addr, u32 level)
+static inline unsigned long gstage_pte_index(gpa_t addr, u32 level)
 {
 	unsigned long mask;
-	unsigned long shift = HGATP_PAGE_SHIFT + (stage2_index_bits * level);
+	unsigned long shift = HGATP_PAGE_SHIFT + (gstage_index_bits * level);
 
-	if (level == (stage2_pgd_levels - 1))
-		mask = (PTRS_PER_PTE * (1UL << stage2_pgd_xbits)) - 1;
+	if (level == (gstage_pgd_levels - 1))
+		mask = (PTRS_PER_PTE * (1UL << gstage_pgd_xbits)) - 1;
 	else
 		mask = PTRS_PER_PTE - 1;
 
 	return (addr >> shift) & mask;
 }
 
-static inline unsigned long stage2_pte_page_vaddr(pte_t pte)
+static inline unsigned long gstage_pte_page_vaddr(pte_t pte)
 {
 	return (unsigned long)pfn_to_virt(pte_val(pte) >> _PAGE_PFN_SHIFT);
 }
 
-static int stage2_page_size_to_level(unsigned long page_size, u32 *out_level)
+static int gstage_page_size_to_level(unsigned long page_size, u32 *out_level)
 {
 	u32 i;
 	unsigned long psz = 1UL << 12;
 
-	for (i = 0; i < stage2_pgd_levels; i++) {
-		if (page_size == (psz << (i * stage2_index_bits))) {
+	for (i = 0; i < gstage_pgd_levels; i++) {
+		if (page_size == (psz << (i * gstage_index_bits))) {
 			*out_level = i;
 			return 0;
 		}
@@ -73,27 +73,27 @@ static int stage2_page_size_to_level(unsigned long page_size, u32 *out_level)
 	return -EINVAL;
 }
 
-static int stage2_level_to_page_size(u32 level, unsigned long *out_pgsize)
+static int gstage_level_to_page_size(u32 level, unsigned long *out_pgsize)
 {
-	if (stage2_pgd_levels < level)
+	if (gstage_pgd_levels < level)
 		return -EINVAL;
 
-	*out_pgsize = 1UL << (12 + (level * stage2_index_bits));
+	*out_pgsize = 1UL << (12 + (level * gstage_index_bits));
 
 	return 0;
 }
 
-static bool stage2_get_leaf_entry(struct kvm *kvm, gpa_t addr,
+static bool gstage_get_leaf_entry(struct kvm *kvm, gpa_t addr,
 				  pte_t **ptepp, u32 *ptep_level)
 {
 	pte_t *ptep;
-	u32 current_level = stage2_pgd_levels - 1;
+	u32 current_level = gstage_pgd_levels - 1;
 
 	*ptep_level = current_level;
 	ptep = (pte_t *)kvm->arch.pgd;
-	ptep = &ptep[stage2_pte_index(addr, current_level)];
+	ptep = &ptep[gstage_pte_index(addr, current_level)];
 	while (ptep && pte_val(*ptep)) {
-		if (stage2_pte_leaf(ptep)) {
+		if (gstage_pte_leaf(ptep)) {
 			*ptep_level = current_level;
 			*ptepp = ptep;
 			return true;
@@ -102,8 +102,8 @@ static bool stage2_get_leaf_entry(struct kvm *kvm, gpa_t addr,
 		if (current_level) {
 			current_level--;
 			*ptep_level = current_level;
-			ptep = (pte_t *)stage2_pte_page_vaddr(*ptep);
-			ptep = &ptep[stage2_pte_index(addr, current_level)];
+			ptep = (pte_t *)gstage_pte_page_vaddr(*ptep);
+			ptep = &ptep[gstage_pte_index(addr, current_level)];
 		} else {
 			ptep = NULL;
 		}
@@ -112,12 +112,12 @@ static bool stage2_get_leaf_entry(struct kvm *kvm, gpa_t addr,
 	return false;
 }
 
-static void stage2_remote_tlb_flush(struct kvm *kvm, u32 level, gpa_t addr)
+static void gstage_remote_tlb_flush(struct kvm *kvm, u32 level, gpa_t addr)
 {
 	unsigned long size = PAGE_SIZE;
 	struct kvm_vmid *vmid = &kvm->arch.vmid;
 
-	if (stage2_level_to_page_size(level, &size))
+	if (gstage_level_to_page_size(level, &size))
 		return;
 	addr &= ~(size - 1);
 
@@ -131,19 +131,19 @@ static void stage2_remote_tlb_flush(struct kvm *kvm, u32 level, gpa_t addr)
 	preempt_enable();
 }
 
-static int stage2_set_pte(struct kvm *kvm, u32 level,
+static int gstage_set_pte(struct kvm *kvm, u32 level,
 			   struct kvm_mmu_memory_cache *pcache,
 			   gpa_t addr, const pte_t *new_pte)
 {
-	u32 current_level = stage2_pgd_levels - 1;
+	u32 current_level = gstage_pgd_levels - 1;
 	pte_t *next_ptep = (pte_t *)kvm->arch.pgd;
-	pte_t *ptep = &next_ptep[stage2_pte_index(addr, current_level)];
+	pte_t *ptep = &next_ptep[gstage_pte_index(addr, current_level)];
 
 	if (current_level < level)
 		return -EINVAL;
 
 	while (current_level != level) {
-		if (stage2_pte_leaf(ptep))
+		if (gstage_pte_leaf(ptep))
 			return -EEXIST;
 
 		if (!pte_val(*ptep)) {
@@ -155,23 +155,23 @@ static int stage2_set_pte(struct kvm *kvm, u32 level,
 			*ptep = pfn_pte(PFN_DOWN(__pa(next_ptep)),
 					__pgprot(_PAGE_TABLE));
 		} else {
-			if (stage2_pte_leaf(ptep))
+			if (gstage_pte_leaf(ptep))
 				return -EEXIST;
-			next_ptep = (pte_t *)stage2_pte_page_vaddr(*ptep);
+			next_ptep = (pte_t *)gstage_pte_page_vaddr(*ptep);
 		}
 
 		current_level--;
-		ptep = &next_ptep[stage2_pte_index(addr, current_level)];
+		ptep = &next_ptep[gstage_pte_index(addr, current_level)];
 	}
 
 	*ptep = *new_pte;
-	if (stage2_pte_leaf(ptep))
-		stage2_remote_tlb_flush(kvm, current_level, addr);
+	if (gstage_pte_leaf(ptep))
+		gstage_remote_tlb_flush(kvm, current_level, addr);
 
 	return 0;
 }
 
-static int stage2_map_page(struct kvm *kvm,
+static int gstage_map_page(struct kvm *kvm,
 			   struct kvm_mmu_memory_cache *pcache,
 			   gpa_t gpa, phys_addr_t hpa,
 			   unsigned long page_size,
@@ -182,7 +182,7 @@ static int stage2_map_page(struct kvm *kvm,
 	pte_t new_pte;
 	pgprot_t prot;
 
-	ret = stage2_page_size_to_level(page_size, &level);
+	ret = gstage_page_size_to_level(page_size, &level);
 	if (ret)
 		return ret;
 
@@ -193,9 +193,9 @@ static int stage2_map_page(struct kvm *kvm,
 	 *    PTE so that software can update these bits.
 	 *
 	 * We support both options mentioned above. To achieve this, we
-	 * always set 'A' and 'D' PTE bits at time of creating stage2
+	 * always set 'A' and 'D' PTE bits at time of creating G-stage
 	 * mapping. To support KVM dirty page logging with both options
-	 * mentioned above, we will write-protect stage2 PTEs to track
+	 * mentioned above, we will write-protect G-stage PTEs to track
 	 * dirty pages.
 	 */
 
@@ -213,24 +213,24 @@ static int stage2_map_page(struct kvm *kvm,
 	new_pte = pfn_pte(PFN_DOWN(hpa), prot);
 	new_pte = pte_mkdirty(new_pte);
 
-	return stage2_set_pte(kvm, level, pcache, gpa, &new_pte);
+	return gstage_set_pte(kvm, level, pcache, gpa, &new_pte);
 }
 
-enum stage2_op {
-	STAGE2_OP_NOP = 0,	/* Nothing */
-	STAGE2_OP_CLEAR,	/* Clear/Unmap */
-	STAGE2_OP_WP,		/* Write-protect */
+enum gstage_op {
+	GSTAGE_OP_NOP = 0,	/* Nothing */
+	GSTAGE_OP_CLEAR,	/* Clear/Unmap */
+	GSTAGE_OP_WP,		/* Write-protect */
 };
 
-static void stage2_op_pte(struct kvm *kvm, gpa_t addr,
-			  pte_t *ptep, u32 ptep_level, enum stage2_op op)
+static void gstage_op_pte(struct kvm *kvm, gpa_t addr,
+			  pte_t *ptep, u32 ptep_level, enum gstage_op op)
 {
 	int i, ret;
 	pte_t *next_ptep;
 	u32 next_ptep_level;
 	unsigned long next_page_size, page_size;
 
-	ret = stage2_level_to_page_size(ptep_level, &page_size);
+	ret = gstage_level_to_page_size(ptep_level, &page_size);
 	if (ret)
 		return;
 
@@ -239,31 +239,31 @@ static void stage2_op_pte(struct kvm *kvm, gpa_t addr,
 	if (!pte_val(*ptep))
 		return;
 
-	if (ptep_level && !stage2_pte_leaf(ptep)) {
-		next_ptep = (pte_t *)stage2_pte_page_vaddr(*ptep);
+	if (ptep_level && !gstage_pte_leaf(ptep)) {
+		next_ptep = (pte_t *)gstage_pte_page_vaddr(*ptep);
 		next_ptep_level = ptep_level - 1;
-		ret = stage2_level_to_page_size(next_ptep_level,
+		ret = gstage_level_to_page_size(next_ptep_level,
 						&next_page_size);
 		if (ret)
 			return;
 
-		if (op == STAGE2_OP_CLEAR)
+		if (op == GSTAGE_OP_CLEAR)
 			set_pte(ptep, __pte(0));
 		for (i = 0; i < PTRS_PER_PTE; i++)
-			stage2_op_pte(kvm, addr + i * next_page_size,
+			gstage_op_pte(kvm, addr + i * next_page_size,
 					&next_ptep[i], next_ptep_level, op);
-		if (op == STAGE2_OP_CLEAR)
+		if (op == GSTAGE_OP_CLEAR)
 			put_page(virt_to_page(next_ptep));
 	} else {
-		if (op == STAGE2_OP_CLEAR)
+		if (op == GSTAGE_OP_CLEAR)
 			set_pte(ptep, __pte(0));
-		else if (op == STAGE2_OP_WP)
+		else if (op == GSTAGE_OP_WP)
 			set_pte(ptep, __pte(pte_val(*ptep) & ~_PAGE_WRITE));
-		stage2_remote_tlb_flush(kvm, ptep_level, addr);
+		gstage_remote_tlb_flush(kvm, ptep_level, addr);
 	}
 }
 
-static void stage2_unmap_range(struct kvm *kvm, gpa_t start,
+static void gstage_unmap_range(struct kvm *kvm, gpa_t start,
 			       gpa_t size, bool may_block)
 {
 	int ret;
@@ -274,9 +274,9 @@ static void stage2_unmap_range(struct kvm *kvm, gpa_t start,
 	gpa_t addr = start, end = start + size;
 
 	while (addr < end) {
-		found_leaf = stage2_get_leaf_entry(kvm, addr,
+		found_leaf = gstage_get_leaf_entry(kvm, addr,
 						   &ptep, &ptep_level);
-		ret = stage2_level_to_page_size(ptep_level, &page_size);
+		ret = gstage_level_to_page_size(ptep_level, &page_size);
 		if (ret)
 			break;
 
@@ -284,8 +284,8 @@ static void stage2_unmap_range(struct kvm *kvm, gpa_t start,
 			goto next;
 
 		if (!(addr & (page_size - 1)) && ((end - addr) >= page_size))
-			stage2_op_pte(kvm, addr, ptep,
-				      ptep_level, STAGE2_OP_CLEAR);
+			gstage_op_pte(kvm, addr, ptep,
+				      ptep_level, GSTAGE_OP_CLEAR);
 
 next:
 		addr += page_size;
@@ -299,7 +299,7 @@ static void stage2_unmap_range(struct kvm *kvm, gpa_t start,
 	}
 }
 
-static void stage2_wp_range(struct kvm *kvm, gpa_t start, gpa_t end)
+static void gstage_wp_range(struct kvm *kvm, gpa_t start, gpa_t end)
 {
 	int ret;
 	pte_t *ptep;
@@ -309,9 +309,9 @@ static void stage2_wp_range(struct kvm *kvm, gpa_t start, gpa_t end)
 	unsigned long page_size;
 
 	while (addr < end) {
-		found_leaf = stage2_get_leaf_entry(kvm, addr,
+		found_leaf = gstage_get_leaf_entry(kvm, addr,
 						   &ptep, &ptep_level);
-		ret = stage2_level_to_page_size(ptep_level, &page_size);
+		ret = gstage_level_to_page_size(ptep_level, &page_size);
 		if (ret)
 			break;
 
@@ -319,15 +319,15 @@ static void stage2_wp_range(struct kvm *kvm, gpa_t start, gpa_t end)
 			goto next;
 
 		if (!(addr & (page_size - 1)) && ((end - addr) >= page_size))
-			stage2_op_pte(kvm, addr, ptep,
-				      ptep_level, STAGE2_OP_WP);
+			gstage_op_pte(kvm, addr, ptep,
+				      ptep_level, GSTAGE_OP_WP);
 
 next:
 		addr += page_size;
 	}
 }
 
-static void stage2_wp_memory_region(struct kvm *kvm, int slot)
+static void gstage_wp_memory_region(struct kvm *kvm, int slot)
 {
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 	struct kvm_memory_slot *memslot = id_to_memslot(slots, slot);
@@ -335,12 +335,12 @@ static void stage2_wp_memory_region(struct kvm *kvm, int slot)
 	phys_addr_t end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
 
 	spin_lock(&kvm->mmu_lock);
-	stage2_wp_range(kvm, start, end);
+	gstage_wp_range(kvm, start, end);
 	spin_unlock(&kvm->mmu_lock);
 	kvm_flush_remote_tlbs(kvm);
 }
 
-static int stage2_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
+static int gstage_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
 			  unsigned long size, bool writable)
 {
 	pte_t pte;
@@ -361,12 +361,12 @@ static int stage2_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
 		if (!writable)
 			pte = pte_wrprotect(pte);
 
-		ret = kvm_mmu_topup_memory_cache(&pcache, stage2_pgd_levels);
+		ret = kvm_mmu_topup_memory_cache(&pcache, gstage_pgd_levels);
 		if (ret)
 			goto out;
 
 		spin_lock(&kvm->mmu_lock);
-		ret = stage2_set_pte(kvm, 0, &pcache, addr, &pte);
+		ret = gstage_set_pte(kvm, 0, &pcache, addr, &pte);
 		spin_unlock(&kvm->mmu_lock);
 		if (ret)
 			goto out;
@@ -388,7 +388,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
 	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
 
-	stage2_wp_range(kvm, start, end);
+	gstage_wp_range(kvm, start, end);
 }
 
 void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
@@ -411,7 +411,7 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	kvm_riscv_stage2_free_pgd(kvm);
+	kvm_riscv_gstage_free_pgd(kvm);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
@@ -421,7 +421,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 	phys_addr_t size = slot->npages << PAGE_SHIFT;
 
 	spin_lock(&kvm->mmu_lock);
-	stage2_unmap_range(kvm, gpa, size, false);
+	gstage_unmap_range(kvm, gpa, size, false);
 	spin_unlock(&kvm->mmu_lock);
 }
 
@@ -436,7 +436,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	 * the memory slot is write protected.
 	 */
 	if (change != KVM_MR_DELETE && new->flags & KVM_MEM_LOG_DIRTY_PAGES)
-		stage2_wp_memory_region(kvm, new->id);
+		gstage_wp_memory_region(kvm, new->id);
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
@@ -458,7 +458,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	 * space addressable by the KVM guest GPA space.
 	 */
 	if ((new->base_gfn + new->npages) >=
-	    (stage2_gpa_size >> PAGE_SHIFT))
+	    (gstage_gpa_size >> PAGE_SHIFT))
 		return -EFAULT;
 
 	hva = new->userspace_addr;
@@ -514,7 +514,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				goto out;
 			}
 
-			ret = stage2_ioremap(kvm, gpa, pa,
+			ret = gstage_ioremap(kvm, gpa, pa,
 					     vm_end - vm_start, writable);
 			if (ret)
 				break;
@@ -527,7 +527,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 
 	spin_lock(&kvm->mmu_lock);
 	if (ret)
-		stage2_unmap_range(kvm, base_gpa, size, false);
+		gstage_unmap_range(kvm, base_gpa, size, false);
 	spin_unlock(&kvm->mmu_lock);
 
 out:
@@ -540,7 +540,7 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (!kvm->arch.pgd)
 		return false;
 
-	stage2_unmap_range(kvm, range->start << PAGE_SHIFT,
+	gstage_unmap_range(kvm, range->start << PAGE_SHIFT,
 			   (range->end - range->start) << PAGE_SHIFT,
 			   range->may_block);
 	return false;
@@ -556,10 +556,10 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 
 	WARN_ON(range->end - range->start != 1);
 
-	ret = stage2_map_page(kvm, NULL, range->start << PAGE_SHIFT,
+	ret = gstage_map_page(kvm, NULL, range->start << PAGE_SHIFT,
 			      __pfn_to_phys(pfn), PAGE_SIZE, true, true);
 	if (ret) {
-		kvm_debug("Failed to map stage2 page (error %d)\n", ret);
+		kvm_debug("Failed to map G-stage page (error %d)\n", ret);
 		return true;
 	}
 
@@ -577,7 +577,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 
 	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PGDIR_SIZE);
 
-	if (!stage2_get_leaf_entry(kvm, range->start << PAGE_SHIFT,
+	if (!gstage_get_leaf_entry(kvm, range->start << PAGE_SHIFT,
 				   &ptep, &ptep_level))
 		return false;
 
@@ -595,14 +595,14 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 
 	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PGDIR_SIZE);
 
-	if (!stage2_get_leaf_entry(kvm, range->start << PAGE_SHIFT,
+	if (!gstage_get_leaf_entry(kvm, range->start << PAGE_SHIFT,
 				   &ptep, &ptep_level))
 		return false;
 
 	return pte_young(*ptep);
 }
 
-int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
+int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 			 struct kvm_memory_slot *memslot,
 			 gpa_t gpa, unsigned long hva, bool is_write)
 {
@@ -648,9 +648,9 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 	}
 
 	/* We need minimum second+third level pages */
-	ret = kvm_mmu_topup_memory_cache(pcache, stage2_pgd_levels);
+	ret = kvm_mmu_topup_memory_cache(pcache, gstage_pgd_levels);
 	if (ret) {
-		kvm_err("Failed to topup stage2 cache\n");
+		kvm_err("Failed to topup G-stage cache\n");
 		return ret;
 	}
 
@@ -680,15 +680,15 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 	if (writeable) {
 		kvm_set_pfn_dirty(hfn);
 		mark_page_dirty(kvm, gfn);
-		ret = stage2_map_page(kvm, pcache, gpa, hfn << PAGE_SHIFT,
+		ret = gstage_map_page(kvm, pcache, gpa, hfn << PAGE_SHIFT,
 				      vma_pagesize, false, true);
 	} else {
-		ret = stage2_map_page(kvm, pcache, gpa, hfn << PAGE_SHIFT,
+		ret = gstage_map_page(kvm, pcache, gpa, hfn << PAGE_SHIFT,
 				      vma_pagesize, true, true);
 	}
 
 	if (ret)
-		kvm_err("Failed to map in stage2\n");
+		kvm_err("Failed to map in G-stage\n");
 
 out_unlock:
 	spin_unlock(&kvm->mmu_lock);
@@ -697,7 +697,7 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
-int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm)
+int kvm_riscv_gstage_alloc_pgd(struct kvm *kvm)
 {
 	struct page *pgd_page;
 
@@ -707,7 +707,7 @@ int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm)
 	}
 
 	pgd_page = alloc_pages(GFP_KERNEL | __GFP_ZERO,
-				get_order(stage2_pgd_size));
+				get_order(gstage_pgd_size));
 	if (!pgd_page)
 		return -ENOMEM;
 	kvm->arch.pgd = page_to_virt(pgd_page);
@@ -716,13 +716,13 @@ int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm)
 	return 0;
 }
 
-void kvm_riscv_stage2_free_pgd(struct kvm *kvm)
+void kvm_riscv_gstage_free_pgd(struct kvm *kvm)
 {
 	void *pgd = NULL;
 
 	spin_lock(&kvm->mmu_lock);
 	if (kvm->arch.pgd) {
-		stage2_unmap_range(kvm, 0UL, stage2_gpa_size, false);
+		gstage_unmap_range(kvm, 0UL, gstage_gpa_size, false);
 		pgd = READ_ONCE(kvm->arch.pgd);
 		kvm->arch.pgd = NULL;
 		kvm->arch.pgd_phys = 0;
@@ -730,12 +730,12 @@ void kvm_riscv_stage2_free_pgd(struct kvm *kvm)
 	spin_unlock(&kvm->mmu_lock);
 
 	if (pgd)
-		free_pages((unsigned long)pgd, get_order(stage2_pgd_size));
+		free_pages((unsigned long)pgd, get_order(gstage_pgd_size));
 }
 
-void kvm_riscv_stage2_update_hgatp(struct kvm_vcpu *vcpu)
+void kvm_riscv_gstage_update_hgatp(struct kvm_vcpu *vcpu)
 {
-	unsigned long hgatp = stage2_mode;
+	unsigned long hgatp = gstage_mode;
 	struct kvm_arch *k = &vcpu->kvm->arch;
 
 	hgatp |= (READ_ONCE(k->vmid.vmid) << HGATP_VMID_SHIFT) &
@@ -744,18 +744,18 @@ void kvm_riscv_stage2_update_hgatp(struct kvm_vcpu *vcpu)
 
 	csr_write(CSR_HGATP, hgatp);
 
-	if (!kvm_riscv_stage2_vmid_bits())
+	if (!kvm_riscv_gstage_vmid_bits())
 		__kvm_riscv_hfence_gvma_all();
 }
 
-void kvm_riscv_stage2_mode_detect(void)
+void kvm_riscv_gstage_mode_detect(void)
 {
 #ifdef CONFIG_64BIT
-	/* Try Sv48x4 stage2 mode */
+	/* Try Sv48x4 G-stage mode */
 	csr_write(CSR_HGATP, HGATP_MODE_SV48X4 << HGATP_MODE_SHIFT);
 	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV48X4) {
-		stage2_mode = (HGATP_MODE_SV48X4 << HGATP_MODE_SHIFT);
-		stage2_pgd_levels = 4;
+		gstage_mode = (HGATP_MODE_SV48X4 << HGATP_MODE_SHIFT);
+		gstage_pgd_levels = 4;
 	}
 	csr_write(CSR_HGATP, 0);
 
@@ -763,12 +763,12 @@ void kvm_riscv_stage2_mode_detect(void)
 #endif
 }
 
-unsigned long kvm_riscv_stage2_mode(void)
+unsigned long kvm_riscv_gstage_mode(void)
 {
-	return stage2_mode >> HGATP_MODE_SHIFT;
+	return gstage_mode >> HGATP_MODE_SHIFT;
 }
 
-int kvm_riscv_stage2_gpa_bits(void)
+int kvm_riscv_gstage_gpa_bits(void)
 {
-	return stage2_gpa_bits;
+	return gstage_gpa_bits;
 }
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 6785aef4cbd4..0b8073374ed7 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -135,7 +135,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	/* Cleanup VCPU timer */
 	kvm_riscv_vcpu_timer_deinit(vcpu);
 
-	/* Free unused pages pre-allocated for Stage2 page table mappings */
+	/* Free unused pages pre-allocated for G-stage page table mappings */
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
 }
 
@@ -632,7 +632,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	csr_write(CSR_HVIP, csr->hvip);
 	csr_write(CSR_VSATP, csr->vsatp);
 
-	kvm_riscv_stage2_update_hgatp(vcpu);
+	kvm_riscv_gstage_update_hgatp(vcpu);
 
 	kvm_riscv_vcpu_timer_restore(vcpu);
 
@@ -687,7 +687,7 @@ static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
 			kvm_riscv_reset_vcpu(vcpu);
 
 		if (kvm_check_request(KVM_REQ_UPDATE_HGATP, vcpu))
-			kvm_riscv_stage2_update_hgatp(vcpu);
+			kvm_riscv_gstage_update_hgatp(vcpu);
 
 		if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu))
 			__kvm_riscv_hfence_gvma_all();
@@ -759,7 +759,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		/* Check conditions before entering the guest */
 		cond_resched();
 
-		kvm_riscv_stage2_vmid_update(vcpu);
+		kvm_riscv_gstage_vmid_update(vcpu);
 
 		kvm_riscv_check_vcpu_requests(vcpu);
 
@@ -797,7 +797,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		kvm_riscv_update_hvip(vcpu);
 
 		if (ret <= 0 ||
-		    kvm_riscv_stage2_vmid_ver_changed(&vcpu->kvm->arch.vmid) ||
+		    kvm_riscv_gstage_vmid_ver_changed(&vcpu->kvm->arch.vmid) ||
 		    kvm_request_pending(vcpu)) {
 			vcpu->mode = OUTSIDE_GUEST_MODE;
 			local_irq_enable();
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index aa8af129e4bb..79772c32d881 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -412,7 +412,7 @@ static int emulate_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	return 0;
 }
 
-static int stage2_page_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
+static int gstage_page_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			     struct kvm_cpu_trap *trap)
 {
 	struct kvm_memory_slot *memslot;
@@ -440,7 +440,7 @@ static int stage2_page_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		};
 	}
 
-	ret = kvm_riscv_stage2_map(vcpu, memslot, fault_addr, hva,
+	ret = kvm_riscv_gstage_map(vcpu, memslot, fault_addr, hva,
 		(trap->scause == EXC_STORE_GUEST_PAGE_FAULT) ? true : false);
 	if (ret < 0)
 		return ret;
@@ -686,7 +686,7 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	case EXC_LOAD_GUEST_PAGE_FAULT:
 	case EXC_STORE_GUEST_PAGE_FAULT:
 		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
-			ret = stage2_page_fault(vcpu, run, trap);
+			ret = gstage_page_fault(vcpu, run, trap);
 		break;
 	case EXC_SUPERVISOR_SYSCALL:
 		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index c768f75279ef..945a2bf5e3f6 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -31,13 +31,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	int r;
 
-	r = kvm_riscv_stage2_alloc_pgd(kvm);
+	r = kvm_riscv_gstage_alloc_pgd(kvm);
 	if (r)
 		return r;
 
-	r = kvm_riscv_stage2_vmid_init(kvm);
+	r = kvm_riscv_gstage_vmid_init(kvm);
 	if (r) {
-		kvm_riscv_stage2_free_pgd(kvm);
+		kvm_riscv_gstage_free_pgd(kvm);
 		return r;
 	}
 
@@ -75,7 +75,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = KVM_USER_MEM_SLOTS;
 		break;
 	case KVM_CAP_VM_GPA_BITS:
-		r = kvm_riscv_stage2_gpa_bits();
+		r = kvm_riscv_gstage_gpa_bits();
 		break;
 	default:
 		r = 0;
diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
index 2fa4f7b1813d..01fdc342ad76 100644
--- a/arch/riscv/kvm/vmid.c
+++ b/arch/riscv/kvm/vmid.c
@@ -20,7 +20,7 @@ static unsigned long vmid_next;
 static unsigned long vmid_bits;
 static DEFINE_SPINLOCK(vmid_lock);
 
-void kvm_riscv_stage2_vmid_detect(void)
+void kvm_riscv_gstage_vmid_detect(void)
 {
 	unsigned long old;
 
@@ -40,12 +40,12 @@ void kvm_riscv_stage2_vmid_detect(void)
 		vmid_bits = 0;
 }
 
-unsigned long kvm_riscv_stage2_vmid_bits(void)
+unsigned long kvm_riscv_gstage_vmid_bits(void)
 {
 	return vmid_bits;
 }
 
-int kvm_riscv_stage2_vmid_init(struct kvm *kvm)
+int kvm_riscv_gstage_vmid_init(struct kvm *kvm)
 {
 	/* Mark the initial VMID and VMID version invalid */
 	kvm->arch.vmid.vmid_version = 0;
@@ -54,7 +54,7 @@ int kvm_riscv_stage2_vmid_init(struct kvm *kvm)
 	return 0;
 }
 
-bool kvm_riscv_stage2_vmid_ver_changed(struct kvm_vmid *vmid)
+bool kvm_riscv_gstage_vmid_ver_changed(struct kvm_vmid *vmid)
 {
 	if (!vmid_bits)
 		return false;
@@ -63,13 +63,13 @@ bool kvm_riscv_stage2_vmid_ver_changed(struct kvm_vmid *vmid)
 			READ_ONCE(vmid_version));
 }
 
-void kvm_riscv_stage2_vmid_update(struct kvm_vcpu *vcpu)
+void kvm_riscv_gstage_vmid_update(struct kvm_vcpu *vcpu)
 {
 	unsigned long i;
 	struct kvm_vcpu *v;
 	struct kvm_vmid *vmid = &vcpu->kvm->arch.vmid;
 
-	if (!kvm_riscv_stage2_vmid_ver_changed(vmid))
+	if (!kvm_riscv_gstage_vmid_ver_changed(vmid))
 		return;
 
 	spin_lock(&vmid_lock);
@@ -78,7 +78,7 @@ void kvm_riscv_stage2_vmid_update(struct kvm_vcpu *vcpu)
 	 * We need to re-check the vmid_version here to ensure that if
 	 * another vcpu already allocated a valid vmid for this vm.
 	 */
-	if (!kvm_riscv_stage2_vmid_ver_changed(vmid)) {
+	if (!kvm_riscv_gstage_vmid_ver_changed(vmid)) {
 		spin_unlock(&vmid_lock);
 		return;
 	}
@@ -96,7 +96,7 @@ void kvm_riscv_stage2_vmid_update(struct kvm_vcpu *vcpu)
 		 * instances is invalid and we have force VMID re-assignement
 		 * for all Guest instances. The Guest instances that were not
 		 * running will automatically pick-up new VMIDs because will
-		 * call kvm_riscv_stage2_vmid_update() whenever they enter
+		 * call kvm_riscv_gstage_vmid_update() whenever they enter
 		 * in-kernel run loop. For Guest instances that are already
 		 * running, we force VM exits on all host CPUs using IPI and
 		 * flush all Guest TLBs.
@@ -112,7 +112,7 @@ void kvm_riscv_stage2_vmid_update(struct kvm_vcpu *vcpu)
 
 	spin_unlock(&vmid_lock);
 
-	/* Request stage2 page table update for all VCPUs */
+	/* Request G-stage page table update for all VCPUs */
 	kvm_for_each_vcpu(i, v, vcpu->kvm)
 		kvm_make_request(KVM_REQ_UPDATE_HGATP, v);
 }
-- 
2.25.1

