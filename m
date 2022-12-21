Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F1B65388D
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 23:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235054AbiLUWZQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 17:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235002AbiLUWZC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 17:25:02 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F953275E6
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 14:24:36 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id o5-20020a170903210500b0018f9edbba6eso134842ple.11
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 14:24:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BM/X6lf5Q5u/NqA/5lapzPbr/TRyR56BZ+pcmqdxJ08=;
        b=qb64BZX2skXQRlPzR/gphfOKSPRkDwvBMkn7oaOZpTZ2gp5EHreY2v4lXCy1a9ufgK
         xN2ODq1pNGyJ8WN+gbl5Ci9n4tmFG1VHrj2V2fhMwYoUFMMUHFOvA6vV2L6tsnpg8ygl
         tXUsBzQ9SDD3ITbzPXAV49ShZhPEEvUx778mW6XLnI+FkqcU0BR+o0nw9YXw9yC0wa9h
         UlbCyVeUoOUdGp0IYDzYl8rnePgr5SU26yYQ1K8wRgygvowtWShEeKO5b1Xbv74eRFD4
         DZsd2gZiGHEBZb6KIU0q90BsAN3EJ8DQb4+qAU+ctS2eav0Bkp6We3Q3zzxklyeENq31
         Hjxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BM/X6lf5Q5u/NqA/5lapzPbr/TRyR56BZ+pcmqdxJ08=;
        b=wD7duxyY6jh3xS5rzGa+Xe76hihrjW5AY+fAnyjM3JiZtkFJWndsZflsSjQ0Xq4kWC
         wtefMHGQGa4g9xs3Nxi5ciCwnf0QURA3PgrZ5tnOH3MWuWLWlOPWEcFQKu6HFEjjEFW6
         0PtFrhHuMscpNCKqvMZUrXV4y0MRUAP2qSdci6njL+DrFLG015HNqmx5zJthR4f5l4u1
         Hdx4oqylth4tN0L+FdY8gRM8vEAmuqFoJs5AcZIULPiOW7yBLo0PWZzHh4/YAt+RkPrM
         w28NK8SC8kFj3nM0EG2kWvii45c7RXEnkXgo3vYOrmTdVGY4lNtYB+8CXq4maehuEw5u
         HPrQ==
X-Gm-Message-State: AFqh2kpdvEpjPIr0Fm6+LwCDkzOLXIyTygeDlwErM5OLzjkJJxRQ2xku
        x/qjdCcRHi47nrzeFoDTiSNJnsBMCtwG
X-Google-Smtp-Source: AMrXdXuIYxb8wwaa0x4dHvr8LQ0LAxW67fag3ohNfE+PlNGCJ7DafcYsm6xdERiSUGJuPa4Bc9sSe1NrmAmI
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a05:6a00:1d8f:b0:578:7184:b495 with SMTP
 id z15-20020a056a001d8f00b005787184b495mr270797pfw.16.1671661475626; Wed, 21
 Dec 2022 14:24:35 -0800 (PST)
Date:   Wed, 21 Dec 2022 22:24:12 +0000
In-Reply-To: <20221221222418.3307832-1-bgardon@google.com>
Mime-Version: 1.0
References: <20221221222418.3307832-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221221222418.3307832-9-bgardon@google.com>
Subject: [RFC 08/14] KVM: x86/MMU: Clean up naming of exported Shadow MMU functions
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Nagareddy Reddy <nspreddy@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change the naming scheme on several functions exported from the shadow
MMU to match the naming scheme used by the TDP MMU: kvm_shadow_mmu_.
More cleanups will follow to convert the remaining functions to a similar
naming scheme, but for now, start with the trivial renames.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 19 ++++++++++---------
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 arch/x86/kvm/mmu/shadow_mmu.c  | 19 ++++++++++---------
 arch/x86/kvm/mmu/shadow_mmu.h  | 17 +++++++++--------
 4 files changed, 30 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4c45a5b63356..bacb519ba7b4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1129,7 +1129,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	int r;
 
 	write_lock(&vcpu->kvm->mmu_lock);
-	r = make_mmu_pages_available(vcpu);
+	r = kvm_shadow_mmu_make_pages_available(vcpu);
 	if (r < 0)
 		goto out_unlock;
 
@@ -1204,7 +1204,7 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 	if (is_tdp_mmu(vcpu->arch.mmu))
 		leaf = kvm_tdp_mmu_get_walk(vcpu, addr, sptes, &root);
 	else
-		leaf = get_walk(vcpu, addr, sptes, &root);
+		leaf = kvm_shadow_mmu_get_walk(vcpu, addr, sptes, &root);
 
 	walk_shadow_page_lockless_end(vcpu);
 
@@ -1469,14 +1469,14 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (is_page_fault_stale(vcpu, fault, mmu_seq))
 		goto out_unlock;
 
-	r = make_mmu_pages_available(vcpu);
+	r = kvm_shadow_mmu_make_pages_available(vcpu);
 	if (r)
 		goto out_unlock;
 
 	if (is_tdp_mmu_fault)
 		r = kvm_tdp_mmu_map(vcpu, fault);
 	else
-		r = __direct_map(vcpu, fault);
+		r = kvm_shadow_mmu_direct_map(vcpu, fault);
 
 out_unlock:
 	if (is_tdp_mmu_fault)
@@ -1514,7 +1514,7 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 		trace_kvm_page_fault(vcpu, fault_address, error_code);
 
 		if (kvm_event_needs_reinjection(vcpu))
-			kvm_mmu_unprotect_page_virt(vcpu, fault_address);
+			kvm_shadow_mmu_unprotect_page_virt(vcpu, fault_address);
 		r = kvm_mmu_page_fault(vcpu, fault_address, error_code, insn,
 				insn_len);
 	} else if (flags & KVM_PV_REASON_PAGE_NOT_PRESENT) {
@@ -2791,7 +2791,8 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 * In order to ensure all vCPUs drop their soon-to-be invalid roots,
 	 * invalidating TDP MMU roots must be done while holding mmu_lock for
 	 * write and in the same critical section as making the reload request,
-	 * e.g. before kvm_zap_obsolete_pages() could drop mmu_lock and yield.
+	 * e.g. before kvm_shadow_mmu_zap_obsolete_pages() could drop mmu_lock
+	 * and yield.
 	 */
 	if (is_tdp_mmu_enabled(kvm))
 		kvm_tdp_mmu_invalidate_all_roots(kvm);
@@ -2806,7 +2807,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 */
 	kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_FREE_OBSOLETE_ROOTS);
 
-	kvm_zap_obsolete_pages(kvm);
+	kvm_shadow_mmu_zap_obsolete_pages(kvm);
 
 	write_unlock(&kvm->mmu_lock);
 
@@ -2892,7 +2893,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 
 	kvm_mmu_invalidate_begin(kvm, gfn_start, gfn_end);
 
-	flush = kvm_rmap_zap_gfn_range(kvm, gfn_start, gfn_end);
+	flush = kvm_shadow_mmu_zap_gfn_range(kvm, gfn_start, gfn_end);
 
 	if (is_tdp_mmu_enabled(kvm)) {
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
@@ -3036,7 +3037,7 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 {
 	if (kvm_memslots_have_rmaps(kvm)) {
 		write_lock(&kvm->mmu_lock);
-		kvm_rmap_zap_collapsible_sptes(kvm, slot);
+		kvm_shadow_mmu_zap_collapsible_sptes(kvm, slot);
 		write_unlock(&kvm->mmu_lock);
 	}
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 2e3b2aca64ad..85c0b186cb0a 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -874,7 +874,7 @@ int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	if (is_page_fault_stale(vcpu, fault, mmu_seq))
 		goto out_unlock;
 
-	r = make_mmu_pages_available(vcpu);
+	r = kvm_shadow_mmu_make_pages_available(vcpu);
 	if (r)
 		goto out_unlock;
 	r = FNAME(fetch)(vcpu, fault, &walker);
diff --git a/arch/x86/kvm/mmu/shadow_mmu.c b/arch/x86/kvm/mmu/shadow_mmu.c
index 1259c4a3b140..e36b4d9c67f2 100644
--- a/arch/x86/kvm/mmu/shadow_mmu.c
+++ b/arch/x86/kvm/mmu/shadow_mmu.c
@@ -1965,7 +1965,7 @@ static inline unsigned long kvm_mmu_available_pages(struct kvm *kvm)
 	return 0;
 }
 
-int make_mmu_pages_available(struct kvm_vcpu *vcpu)
+int kvm_shadow_mmu_make_pages_available(struct kvm_vcpu *vcpu)
 {
 	unsigned long avail = kvm_mmu_available_pages(vcpu->kvm);
 
@@ -2029,7 +2029,7 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 	return r;
 }
 
-int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
+int kvm_shadow_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
 {
 	gpa_t gpa;
 	int r;
@@ -2319,7 +2319,7 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
 	__direct_pte_prefetch(vcpu, sp, sptep);
 }
 
-int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+int kvm_shadow_mmu_direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_shadow_walk_iterator it;
 	struct kvm_mmu_page *sp;
@@ -2537,7 +2537,7 @@ int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		return r;
 
 	write_lock(&vcpu->kvm->mmu_lock);
-	r = make_mmu_pages_available(vcpu);
+	r = kvm_shadow_mmu_make_pages_available(vcpu);
 	if (r < 0)
 		goto out_unlock;
 
@@ -2785,7 +2785,8 @@ void kvm_mmu_sync_prev_roots(struct kvm_vcpu *vcpu)
  *
  * Must be called between walk_shadow_page_lockless_{begin,end}.
  */
-int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes, int *root_level)
+int kvm_shadow_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
+			    int *root_level)
 {
 	struct kvm_shadow_walk_iterator iterator;
 	int leaf = -1;
@@ -3091,7 +3092,7 @@ __always_inline bool slot_handle_level_4k(struct kvm *kvm,
 }
 
 #define BATCH_ZAP_PAGES	10
-void kvm_zap_obsolete_pages(struct kvm *kvm)
+void kvm_shadow_mmu_zap_obsolete_pages(struct kvm *kvm)
 {
 	struct kvm_mmu_page *sp, *node;
 	int nr_zapped, batch = 0;
@@ -3152,7 +3153,7 @@ bool kvm_shadow_mmu_has_zapped_obsolete_pages(struct kvm *kvm)
 	return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
 }
 
-bool kvm_rmap_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
+bool kvm_shadow_mmu_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 {
 	const struct kvm_memory_slot *memslot;
 	struct kvm_memslots *slots;
@@ -3404,8 +3405,8 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 	return need_tlb_flush;
 }
 
-void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
-				    const struct kvm_memory_slot *slot)
+void kvm_shadow_mmu_zap_collapsible_sptes(struct kvm *kvm,
+					  const struct kvm_memory_slot *slot)
 {
 	/*
 	 * Note, use KVM_MAX_HUGEPAGE_LEVEL - 1 since there's no need to zap
diff --git a/arch/x86/kvm/mmu/shadow_mmu.h b/arch/x86/kvm/mmu/shadow_mmu.h
index 9952aa1e86cf..148cc3593d2b 100644
--- a/arch/x86/kvm/mmu/shadow_mmu.h
+++ b/arch/x86/kvm/mmu/shadow_mmu.h
@@ -60,18 +60,19 @@ bool kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 			      struct list_head *invalid_list);
 void kvm_mmu_commit_zap_page(struct kvm *kvm, struct list_head *invalid_list);
 
-int make_mmu_pages_available(struct kvm_vcpu *vcpu);
+int kvm_shadow_mmu_make_pages_available(struct kvm_vcpu *vcpu);
 
-int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva);
+int kvm_shadow_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva);
 
-int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
+int kvm_shadow_mmu_direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 u64 *fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gpa_t gpa, u64 *spte);
 
 hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant, u8 level);
 int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu);
 int mmu_alloc_special_roots(struct kvm_vcpu *vcpu);
 
-int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes, int *root_level);
+int kvm_shadow_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
+			    int *root_level);
 
 void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 		       int bytes, struct kvm_page_track_notifier_node *node);
@@ -86,8 +87,8 @@ bool slot_handle_level(struct kvm *kvm, const struct kvm_memory_slot *memslot,
 bool slot_handle_level_4k(struct kvm *kvm, const struct kvm_memory_slot *memslot,
 			  slot_level_handler fn, bool flush_on_yield);
 
-void kvm_zap_obsolete_pages(struct kvm *kvm);
-bool kvm_rmap_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
+void kvm_shadow_mmu_zap_obsolete_pages(struct kvm *kvm);
+bool kvm_shadow_mmu_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
 
 bool slot_rmap_write_protect(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 			     const struct kvm_memory_slot *slot);
@@ -96,8 +97,8 @@ void kvm_shadow_mmu_try_split_huge_pages(struct kvm *kvm,
 					 const struct kvm_memory_slot *slot,
 					 gfn_t start, gfn_t end,
 					 int target_level);
-void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
-				    const struct kvm_memory_slot *slot);
+void kvm_shadow_mmu_zap_collapsible_sptes(struct kvm *kvm,
+					  const struct kvm_memory_slot *slot);
 
 bool kvm_shadow_mmu_has_zapped_obsolete_pages(struct kvm *kvm);
 unsigned long kvm_shadow_mmu_shrink_scan(struct kvm *kvm, int pages_to_free);
-- 
2.39.0.314.g84b9a713c41-goog

