Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33EC8674018
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 18:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbjASRg1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 12:36:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbjASRgV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 12:36:21 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 055BC8F7E7
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 09:36:19 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id i10-20020a25f20a000000b006ea4f43c0ddso2974684ybe.21
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 09:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YgIeMtGXDOnExqyujNWC0I9b1VXR1Gfs99VbmAsRW+k=;
        b=giV2bYNflM1JWbc19J5WY/OrTHA78PbEfEaGruYZpasDOKcsChZyc7ERYncTqgomiZ
         9PaIiH7tqSF4adItkEgaawlNmE1F0ueIp9Y2xeYlO4p3UB8iZBoIZYwBwzNTSf/gZmGr
         3NKMurcu39ncVL5I6NoG0RlMIEYCIbiOs3BqTH9TTJLRVwhSPYuWqTnVz6sdMZ8sg5tz
         Q+i63pfT3HowCiwOhETAH2Phm/zP3pxDGwMgc1WCkQiUw9sRd1n7WhY5CLufzlC1bw/Y
         5TOre+jDSiOUVTkE/B5jhyHe+OwRwn4l/WTKrw0kv3ubQ5/DMZgUCROeNCDn+/+pFKZX
         /Utw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YgIeMtGXDOnExqyujNWC0I9b1VXR1Gfs99VbmAsRW+k=;
        b=TQ6evZ5Ke4qM2vbXUWt11K9roq6SN+cQDIWjsExyLCzpeeHIbyNuj5oZfL+EFfuAa4
         gdVp3u82gFVVrhB5FymnJ7yPYsmb/SpkBvmppFzApvvMlEizvtX5Hm1mkUopBHd+e35g
         sPbrJdujI5at7nKJPzlZ+hOdRR7IrFwMuYCinTa/Us13RqaPdyIoQP4bADYAg0vkwN3u
         3r5eDPVAiCkApWwZzLArWPpIvswYBlhkQ8CbUqYt/ZvXk3uSCoXQs6BxRQGzY5RYI7KI
         tskUJOSDzWP9VWlShK6lT9tYJF6uIJ6RotGYeaRboToCpF2F1lkisuUzM161wonnJrj+
         o0/w==
X-Gm-Message-State: AFqh2krRYkG7YnLD06WDS/8iVTvpczsz049kpDSWSXkLtFxrrKBoskKV
        8e1d6x57+XDwIqDo+YG0ytXbB2gDIJ2OJQ==
X-Google-Smtp-Source: AMrXdXv2vGhlzkyCDtRgVIwxrqEebGv4h47Grh18nzdI7jcrY6V2k//XsBdUo25o0Vf4cjHFmIEsjoCzUjnkfQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:e41:0:b0:4ed:612d:2559 with SMTP id
 62-20020a810e41000000b004ed612d2559mr1400135ywo.46.1674149778116; Thu, 19 Jan
 2023 09:36:18 -0800 (PST)
Date:   Thu, 19 Jan 2023 09:35:56 -0800
In-Reply-To: <20230119173559.2517103-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20230119173559.2517103-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230119173559.2517103-5-dmatlack@google.com>
Subject: [PATCH 4/7] KVM: x86/mmu: Rename kvm_flush_remote_tlbs_with_address()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org,
        David Matlack <dmatlack@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
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

Rename kvm_flush_remote_tlbs_with_address() to
kvm_flush_remote_tlbs_range(). This name is shorter, which reduces the
number of callsites that need to be broken up across multiple lines, and
more readable since it conveys a range of memory is being flushed rather
than a single address.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 36 +++++++++++++++------------------
 arch/x86/kvm/mmu/mmu_internal.h |  3 +--
 arch/x86/kvm/mmu/paging_tmpl.h  |  4 ++--
 arch/x86/kvm/mmu/tdp_mmu.c      |  7 +++----
 4 files changed, 22 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7740ca52dab4..36ce3110b7da 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -246,8 +246,7 @@ static inline bool kvm_available_flush_tlb_with_range(void)
 	return kvm_x86_ops.tlb_remote_flush_with_range;
 }
 
-void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
-		u64 start_gfn, u64 pages)
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, u64 start_gfn, u64 pages)
 {
 	struct kvm_tlb_range range;
 	int ret = -EOPNOTSUPP;
@@ -806,7 +805,7 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 	kvm_mmu_gfn_disallow_lpage(slot, gfn);
 
 	if (kvm_mmu_slot_gfn_write_protect(kvm, slot, gfn, PG_LEVEL_4K))
-		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
+		kvm_flush_remote_tlbs_range(kvm, gfn, 1);
 }
 
 void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
@@ -1180,8 +1179,8 @@ static void drop_large_spte(struct kvm *kvm, u64 *sptep, bool flush)
 	drop_spte(kvm, sptep);
 
 	if (flush)
-		kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
-			KVM_PAGES_PER_HPAGE(sp->role.level));
+		kvm_flush_remote_tlbs_range(kvm, sp->gfn,
+					    KVM_PAGES_PER_HPAGE(sp->role.level));
 }
 
 /*
@@ -1462,7 +1461,7 @@ static bool kvm_set_pte_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 	}
 
 	if (need_flush && kvm_available_flush_tlb_with_range()) {
-		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
+		kvm_flush_remote_tlbs_range(kvm, gfn, 1);
 		return false;
 	}
 
@@ -1632,8 +1631,8 @@ static void __rmap_add(struct kvm *kvm,
 		kvm->stat.max_mmu_rmap_size = rmap_count;
 	if (rmap_count > RMAP_RECYCLE_THRESHOLD) {
 		kvm_zap_all_rmap_sptes(kvm, rmap_head);
-		kvm_flush_remote_tlbs_with_address(
-				kvm, sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
+		kvm_flush_remote_tlbs_range(kvm, sp->gfn,
+					    KVM_PAGES_PER_HPAGE(sp->role.level));
 	}
 }
 
@@ -2398,7 +2397,7 @@ static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			return;
 
 		drop_parent_pte(child, sptep);
-		kvm_flush_remote_tlbs_with_address(vcpu->kvm, child->gfn, 1);
+		kvm_flush_remote_tlbs_range(vcpu->kvm, child->gfn, 1);
 	}
 }
 
@@ -2882,8 +2881,8 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	}
 
 	if (flush)
-		kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn,
-				KVM_PAGES_PER_HPAGE(level));
+		kvm_flush_remote_tlbs_range(vcpu->kvm, gfn,
+					    KVM_PAGES_PER_HPAGE(level));
 
 	pgprintk("%s: setting spte %llx\n", __func__, *sptep);
 
@@ -5814,9 +5813,8 @@ slot_handle_level_range(struct kvm *kvm, const struct kvm_memory_slot *memslot,
 
 		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
 			if (flush && flush_on_yield) {
-				kvm_flush_remote_tlbs_with_address(kvm,
-						start_gfn,
-						iterator.gfn - start_gfn + 1);
+				kvm_flush_remote_tlbs_range(kvm, start_gfn,
+							    iterator.gfn - start_gfn + 1);
 				flush = false;
 			}
 			cond_resched_rwlock_write(&kvm->mmu_lock);
@@ -6171,8 +6169,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 	}
 
 	if (flush)
-		kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
-						   gfn_end - gfn_start);
+		kvm_flush_remote_tlbs_range(kvm, gfn_start, gfn_end - gfn_start);
 
 	kvm_mmu_invalidate_end(kvm, 0, -1ul);
 
@@ -6511,8 +6508,8 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 			kvm_zap_one_rmap_spte(kvm, rmap_head, sptep);
 
 			if (kvm_available_flush_tlb_with_range())
-				kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
-					KVM_PAGES_PER_HPAGE(sp->role.level));
+				kvm_flush_remote_tlbs_range(kvm, sp->gfn,
+							    KVM_PAGES_PER_HPAGE(sp->role.level));
 			else
 				need_tlb_flush = 1;
 
@@ -6562,8 +6559,7 @@ void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
 	 * is observed by any other operation on the same memslot.
 	 */
 	lockdep_assert_held(&kvm->slots_lock);
-	kvm_flush_remote_tlbs_with_address(kvm, memslot->base_gfn,
-					   memslot->npages);
+	kvm_flush_remote_tlbs_range(kvm, memslot->base_gfn, memslot->npages);
 }
 
 void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index ac00bfbf32f6..e606a6d5e040 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -164,8 +164,7 @@ void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn,
 				    int min_level);
-void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
-					u64 start_gfn, u64 pages);
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, u64 start_gfn, u64 pages);
 unsigned int pte_list_count(struct kvm_rmap_head *rmap_head);
 
 extern int nx_huge_pages;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index e5662dbd519c..fdad03f131c8 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -929,8 +929,8 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 
 			mmu_page_zap_pte(vcpu->kvm, sp, sptep, NULL);
 			if (is_shadow_present_pte(old_spte))
-				kvm_flush_remote_tlbs_with_address(vcpu->kvm,
-					sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
+				kvm_flush_remote_tlbs_range(vcpu->kvm, sp->gfn,
+							    KVM_PAGES_PER_HPAGE(sp->role.level));
 
 			if (!rmap_can_add(vcpu))
 				break;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index bba33aea0fb0..7c21d15c58d8 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -680,8 +680,7 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	if (ret)
 		return ret;
 
-	kvm_flush_remote_tlbs_with_address(kvm, iter->gfn,
-					   KVM_PAGES_PER_HPAGE(iter->level));
+	kvm_flush_remote_tlbs_range(kvm, iter->gfn, KVM_PAGES_PER_HPAGE(iter->level));
 
 	/*
 	 * No other thread can overwrite the removed SPTE as they must either
@@ -1080,8 +1079,8 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 		return RET_PF_RETRY;
 	else if (is_shadow_present_pte(iter->old_spte) &&
 		 !is_last_spte(iter->old_spte, iter->level))
-		kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
-						   KVM_PAGES_PER_HPAGE(iter->level + 1));
+		kvm_flush_remote_tlbs_range(vcpu->kvm, sp->gfn,
+					    KVM_PAGES_PER_HPAGE(iter->level + 1));
 
 	/*
 	 * If the page fault was caused by a write but the page is write
-- 
2.39.0.246.g2a6d74b583-goog

