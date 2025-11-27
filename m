Return-Path: <kvm+bounces-64851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FF0EC8D692
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 09:52:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 53DDF34D4FC
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 08:52:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4523D3242A7;
	Thu, 27 Nov 2025 08:52:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A84D2D3237;
	Thu, 27 Nov 2025 08:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=160.30.148.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764233533; cv=none; b=IH5UDkcIPwx6/QUBH718BQOJiNtsL5Kfqff+eNjq5KtRm7K6Urn6bUCGM/6F0ruFoVRXugDznrxpCk6POPS+aZ6cSLOWPTsL2JN18lMo7d9I9ULPOLc6GHcY4tCsXfJQkWLVnOqoAk0Rnc/6K4tMguq/pPL3RRv3jpT8J1F4w5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764233533; c=relaxed/simple;
	bh=OJFe4uir1r8fdPJo8g8dyTsjCzmwNS8H/eu98Y/hL7k=;
	h=Date:Message-ID:Mime-Version:From:To:Cc:Subject:Content-Type; b=dwhfE/VjofxBUqa+vyDNFLc+F3nk+nqi+nuGKBtZ11TGtSY/ms5+VuMsoBW+y4BAiHxZyY4cVXhYKafjZLdT9SfoNi9tle6egyNYun+Fw/0dLqR56lClBBwhVFr4qqboGRak8t/kc1jCp3V+bEQpAGqRmtxmcw4CkOTEaU7POkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=160.30.148.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4dH9Cq08M0z6FyC3;
	Thu, 27 Nov 2025 16:52:07 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 5AR8pZos089303;
	Thu, 27 Nov 2025 16:51:35 +0800 (+08)
	(envelope-from liu.xuemei1@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 27 Nov 2025 16:51:37 +0800 (CST)
Date: Thu, 27 Nov 2025 16:51:37 +0800 (CST)
X-Zmail-TransId: 2afb692811196d6-335c2
X-Mailer: Zmail v1.0
Message-ID: <20251127165137780QbUOVPKPAfWSGAFl5qtRy@zte.com.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: <liu.xuemei1@zte.com.cn>
To: <atish.patra@linux.dev>, <alex@ghiti.fr>, <anup@brainfault.org>
Cc: <pjw@kernel.org>, <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>,
        <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
        <inux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIHY0XSBSSVNDLVY6IEtWTTogVHJhbnNwYXJlbnQgaHVnZSBwYWdlIHN1cHBvcnQ=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 5AR8pZos089303
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: liu.xuemei1@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Thu, 27 Nov 2025 16:52:07 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69281137.000/4dH9Cq08M0z6FyC3

From: Jessica Liu <liu.xuemei1@zte.com.cn>

Use block mapping if backed by a THP, as implemented in architectures
like ARM and x86_64.

Signed-off-by: Jessica Liu <liu.xuemei1@zte.com.cn>
---
Changes in v4:
- Substituted kvm_riscv_gstage_get_mapping_size with get_hva_mapping_size

 arch/riscv/kvm/mmu.c    | 140 ++++++++++++++++++++++++++++++++++++++++
 arch/riscv/mm/pgtable.c |   2 +
 2 files changed, 142 insertions(+)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 58f5f3536ffd..38816c5895fe 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -302,6 +302,142 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	return pte_young(ptep_get(ptep));
 }

+static bool fault_supports_gstage_huge_mapping(struct kvm_memory_slot *memslot,
+					       unsigned long hva)
+{
+	hva_t uaddr_start, uaddr_end;
+	gpa_t gpa_start;
+	size_t size;
+
+	size = memslot->npages * PAGE_SIZE;
+	uaddr_start = memslot->userspace_addr;
+	uaddr_end = uaddr_start + size;
+
+	gpa_start = memslot->base_gfn << PAGE_SHIFT;
+
+	/*
+	 * Pages belonging to memslots that don't have the same alignment
+	 * within a PMD for userspace and GPA cannot be mapped with g-stage
+	 * PMD entries, because we'll end up mapping the wrong pages.
+	 *
+	 * Consider a layout like the following:
+	 *
+	 *    memslot->userspace_addr:
+	 *    +-----+--------------------+--------------------+---+
+	 *    |abcde|fgh  vs-stage block  |    vs-stage block tv|xyz|
+	 *    +-----+--------------------+--------------------+---+
+	 *
+	 *    memslot->base_gfn << PAGE_SHIFT:
+	 *      +---+--------------------+--------------------+-----+
+	 *      |abc|def  g-stage block  |    g-stage block   |tvxyz|
+	 *      +---+--------------------+--------------------+-----+
+	 *
+	 * If we create those g-stage blocks, we'll end up with this incorrect
+	 * mapping:
+	 *   d -> f
+	 *   e -> g
+	 *   f -> h
+	 */
+	if ((gpa_start & (PMD_SIZE - 1)) != (uaddr_start & (PMD_SIZE - 1)))
+		return false;
+
+	/*
+	 * Next, let's make sure we're not trying to map anything not covered
+	 * by the memslot. This means we have to prohibit block size mappings
+	 * for the beginning and end of a non-block aligned and non-block sized
+	 * memory slot (illustrated by the head and tail parts of the
+	 * userspace view above containing pages 'abcde' and 'xyz',
+	 * respectively).
+	 *
+	 * Note that it doesn't matter if we do the check using the
+	 * userspace_addr or the base_gfn, as both are equally aligned (per
+	 * the check above) and equally sized.
+	 */
+	return (hva >= ALIGN(uaddr_start, PMD_SIZE)) && (hva < ALIGN_DOWN(uaddr_end, PMD_SIZE));
+}
+
+static int get_hva_mapping_size(struct kvm *kvm,
+				unsigned long hva)
+{
+	int size = PAGE_SIZE;
+	unsigned long flags;
+	pgd_t pgd;
+	p4d_t p4d;
+	pud_t pud;
+	pmd_t pmd;
+
+	/*
+	 * Disable IRQs to prevent concurrent tear down of host page tables,
+	 * e.g. if the primary MMU promotes a P*D to a huge page and then frees
+	 * the original page table.
+	 */
+	local_irq_save(flags);
+
+	/*
+	 * Read each entry once.  As above, a non-leaf entry can be promoted to
+	 * a huge page _during_ this walk.  Re-reading the entry could send the
+	 * walk into the weeks, e.g. p*d_leaf() returns false (sees the old
+	 * value) and then p*d_offset() walks into the target huge page instead
+	 * of the old page table (sees the new value).
+	 */
+	pgd = pgdp_get(pgd_offset(kvm->mm, hva));
+	if (pgd_none(pgd))
+		goto out;
+
+	p4d = p4dp_get(p4d_offset(&pgd, hva));
+	if (p4d_none(p4d) || !p4d_present(p4d))
+		goto out;
+
+	pud = pudp_get(pud_offset(&p4d, hva));
+	if (pud_none(pud) || !pud_present(pud))
+		goto out;
+
+	if (pud_leaf(pud)) {
+		size = PUD_SIZE;
+		goto out;
+	}
+
+	pmd = pmdp_get(pmd_offset(&pud, hva));
+	if (pmd_none(pmd) || !pmd_present(pmd))
+		goto out;
+
+	if (pmd_leaf(pmd))
+		size = PMD_SIZE;
+
+out:
+	local_irq_restore(flags);
+	return size;
+}
+
+static unsigned long transparent_hugepage_adjust(struct kvm *kvm,
+						 struct kvm_memory_slot *memslot,
+						 unsigned long hva,
+						 kvm_pfn_t *hfnp, gpa_t *gpa)
+{
+	kvm_pfn_t hfn = *hfnp;
+
+	/*
+	 * Make sure the adjustment is done only for THP pages. Also make
+	 * sure that the HVA and GPA are sufficiently aligned and that the
+	 * block map is contained within the memslot.
+	 */
+	if (fault_supports_gstage_huge_mapping(memslot, hva)) {
+		int sz;
+
+		sz = get_hva_mapping_size(kvm, hva);
+		if (sz < PMD_SIZE)
+			return sz;
+
+		*gpa &= PMD_MASK;
+		hfn &= ~(PTRS_PER_PMD - 1);
+		*hfnp = hfn;
+
+		return PMD_SIZE;
+	}
+
+	return PAGE_SIZE;
+}
+
 int kvm_riscv_mmu_map(struct kvm_vcpu *vcpu, struct kvm_memory_slot *memslot,
 		      gpa_t gpa, unsigned long hva, bool is_write,
 		      struct kvm_gstage_mapping *out_map)
@@ -395,6 +531,10 @@ int kvm_riscv_mmu_map(struct kvm_vcpu *vcpu, struct kvm_memory_slot *memslot,
 	if (mmu_invalidate_retry(kvm, mmu_seq))
 		goto out_unlock;

+	/* check if we are backed by a THP and thus use block mapping if possible */
+	if (vma_pagesize == PAGE_SIZE)
+		vma_pagesize = transparent_hugepage_adjust(kvm, memslot, hva, &hfn, &gpa);
+
 	if (writable) {
 		mark_page_dirty_in_slot(kvm, memslot, gfn);
 		ret = kvm_riscv_gstage_map_page(&gstage, pcache, gpa, hfn << PAGE_SHIFT,
diff --git a/arch/riscv/mm/pgtable.c b/arch/riscv/mm/pgtable.c
index 8b6c0a112a8d..fe776f03cc12 100644
--- a/arch/riscv/mm/pgtable.c
+++ b/arch/riscv/mm/pgtable.c
@@ -49,6 +49,7 @@ pud_t *pud_offset(p4d_t *p4d, unsigned long address)

 	return (pud_t *)p4d;
 }
+EXPORT_SYMBOL_GPL(pud_offset);

 p4d_t *p4d_offset(pgd_t *pgd, unsigned long address)
 {
@@ -57,6 +58,7 @@ p4d_t *p4d_offset(pgd_t *pgd, unsigned long address)

 	return (p4d_t *)pgd;
 }
+EXPORT_SYMBOL_GPL(p4d_offset);
 #endif

 #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
-- 
2.27.0

