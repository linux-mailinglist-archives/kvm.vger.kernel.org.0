Return-Path: <kvm+bounces-58932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 03555BA6A48
	for <lists+kvm@lfdr.de>; Sun, 28 Sep 2025 09:45:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD69F3A3350
	for <lists+kvm@lfdr.de>; Sun, 28 Sep 2025 07:45:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1A1E29BDAE;
	Sun, 28 Sep 2025 07:45:08 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60EC129C328;
	Sun, 28 Sep 2025 07:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=183.62.165.209
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759045508; cv=none; b=snvOQNkfpa/DW0AssPiUcbZFXqz3dDtTh+/tOEGxyfwWR/zxNui1l74bjK3tYwz2MHbdrc/LeSJBh+SJZntzkNLsHVK/LtPLnYVT6DUrgRc8+iVJSTEW7iMSPu1SZaNJHC+BBQbMuGwgPhg62NKWixDCSeEBabwqVyHf/ke/f8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759045508; c=relaxed/simple;
	bh=8v+e631znBwAZg5i7hqoToGtVrtix9uIbWoPeEnmmS0=;
	h=Date:Message-ID:Mime-Version:From:To:Cc:Subject:Content-Type; b=cKcuv1uqsZcMwsL5MW2SpVj5u702Ay5hopKWtwKrMAwh6KbZWbewrG5e10O+fWiiztUKU9rwAVE8v3AnCTbCkfAGFiBHEEua+vii3/FsN3PMjXCWtNuDVztZjfQhS/MYzAQ4jvh/bGypUKPUO+Jdt5uivhC8PPOr7RIzBBVfOGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=183.62.165.209
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4cZGYw5YCVz4xNt7;
	Sun, 28 Sep 2025 15:44:52 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 58S7imtK038376;
	Sun, 28 Sep 2025 15:44:48 +0800 (+08)
	(envelope-from liu.xuemei1@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 28 Sep 2025 15:44:50 +0800 (CST)
Date: Sun, 28 Sep 2025 15:44:50 +0800 (CST)
X-Zmail-TransId: 2afb68d8e7723ba-ff67b
X-Mailer: Zmail v1.0
Message-ID: <20250928154450701hRC3fm00QYFnGiM0_M1No@zte.com.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: <liu.xuemei1@zte.com.cn>
To: <anup@brainfault.org>
Cc: <atish.patra@linux.dev>, <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <aou@eecs.berkeley.edu>, <alex@ghiti.fr>, <kvm@vger.kernel.org>,
        <kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIXSBSSVNDLVY6IEtWTTogVHJhbnNwYXJlbnQgaHVnZSBwYWdlIHN1cHBvcnQ=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 58S7imtK038376
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: liu.xuemei1@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Sun, 28 Sep 2025 15:44:52 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 68D8E774.001/4cZGYw5YCVz4xNt7

From: Jessica Liu <liu.xuemei1@zte.com.cn>

Use block mapping if backed by a THP, as implemented in architectures
like ARM and x86_64.

Signed-off-by: Jessica Liu <liu.xuemei1@zte.com.cn>
---
 arch/riscv/include/asm/kvm_gstage.h |   3 +
 arch/riscv/kvm/gstage.c             | 100 ++++++++++++++++++++++++++++
 arch/riscv/kvm/mmu.c                |  12 +++-
 3 files changed, 114 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/kvm_gstage.h b/arch/riscv/include/asm/kvm_gstage.h
index 595e2183173e..cc67fb2d2d42 100644
--- a/arch/riscv/include/asm/kvm_gstage.h
+++ b/arch/riscv/include/asm/kvm_gstage.h
@@ -69,4 +69,7 @@ void kvm_riscv_gstage_wp_range(struct kvm_gstage *gstage, gpa_t start, gpa_t end

 void kvm_riscv_gstage_mode_detect(void);

+long kvm_riscv_gstage_thp_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
+				 unsigned long hva, kvm_pfn_t *pfnp, gpa_t *gpa);
+
 #endif
diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
index 24c270d6d0e2..98494b4b4652 100644
--- a/arch/riscv/kvm/gstage.c
+++ b/arch/riscv/kvm/gstage.c
@@ -77,6 +77,106 @@ static int gstage_level_to_page_size(u32 level, unsigned long *out_pgsize)
 	return 0;
 }

+static int gstage_get_user_mapping_size(struct kvm *kvm, u64 addr)
+{
+	pte_t *ptepp;
+	u32 ptep_level;
+	unsigned long out_pgsize;
+	struct kvm_gstage gstage = {
+		.pgd = kvm->mm->pgd
+	};
+
+	if (!kvm_riscv_gstage_get_leaf(&gstage, addr, &ptepp, &ptep_level))
+		return -EFAULT;
+
+	if (gstage_level_to_page_size(ptep_level, &out_pgsize))
+		return -EFAULT;
+
+	return out_pgsize;
+}
+
+static bool gstage_supports_huge_mapping(struct kvm_memory_slot *memslot, unsigned long hva)
+{
+	gpa_t gpa_start;
+	hva_t uaddr_start, uaddr_end;
+	size_t size;
+
+	size = memslot->npages * PAGE_SIZE;
+	uaddr_start = memslot->userspace_addr;
+	uaddr_end = uaddr_start + size;
+
+	gpa_start = memslot->base_gfn << PAGE_SIZE;
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
+long kvm_riscv_gstage_thp_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
+				 unsigned long hva, kvm_pfn_t *hfnp, gpa_t *gpa)
+{
+	kvm_pfn_t hfn = *hfnp;
+
+	/*
+	 * Make sure the adjustment is done only for THP pages. Also make
+	 * sure that the HVA and GPA are sufficiently aligned and that the
+	 * block map is contained within the memslot.
+	 */
+	if (gstage_supports_huge_mapping(memslot, hva)) {
+		int sz = gstage_get_user_mapping_size(kvm, hva);
+
+		if (sz < 0)
+			return sz;
+
+		if (sz < PMD_SIZE)
+			return PAGE_SIZE;
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
 bool kvm_riscv_gstage_get_leaf(struct kvm_gstage *gstage, gpa_t addr,
 			       pte_t **ptepp, u32 *ptep_level)
 {
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 525fb5a330c0..f70cf721ebb8 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -337,7 +337,8 @@ int kvm_riscv_mmu_map(struct kvm_vcpu *vcpu, struct kvm_memory_slot *memslot,
 	struct kvm_mmu_memory_cache *pcache = &vcpu->arch.mmu_page_cache;
 	bool logging = (memslot->dirty_bitmap &&
 			!(memslot->flags & KVM_MEM_READONLY)) ? true : false;
-	unsigned long vma_pagesize, mmu_seq;
+	unsigned long mmu_seq;
+	long vma_pagesize;
 	struct kvm_gstage gstage;
 	struct page *page;

@@ -416,6 +417,15 @@ int kvm_riscv_mmu_map(struct kvm_vcpu *vcpu, struct kvm_memory_slot *memslot,
 	if (mmu_invalidate_retry(kvm, mmu_seq))
 		goto out_unlock;

+	/* check if we are backed by a THP and thus use block mapping if possible */
+	if (vma_pagesize == PAGE_SIZE) {
+		vma_pagesize = kvm_riscv_gstage_thp_adjust(kvm, memslot, hva, &hfn, &gpa);
+		if (vma_pagesize < 0) {
+			ret = vma_pagesize;
+			goto out_unlock;
+		}
+	}
+
 	if (writable) {
 		mark_page_dirty_in_slot(kvm, memslot, gfn);
 		ret = kvm_riscv_gstage_map_page(&gstage, pcache, gpa, hfn << PAGE_SHIFT,
-- 
2.27.0

