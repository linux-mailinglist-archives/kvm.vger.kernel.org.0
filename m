Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2CE653896
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 23:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235123AbiLUWZq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 17:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234982AbiLUWZN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 17:25:13 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8D2275FA
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 14:24:42 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id r17-20020a17090aa09100b0021903e75f14so7486121pjp.9
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 14:24:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZvHSZ7wyO6HpWC7GgWotvlWeVl4F+Q0dZdGlQyXVA6g=;
        b=SZmxxj3D7ZU/s/vea1hbQX3dVt8uH8sCEHNP+G6nLRcEHVdJ8hshrQVvHHLhSFn40n
         gJwzzUv13Wwj4TPXk4zLMaNE7Il3+japKHq9hAOS3Uzam7+8ANCSXsQO5uZjmDyrib8v
         n7BsILS36PW4iMO4uWVAOs6+sx5t4+1pg/u9I3KpAsMyLw8mHxIVg/Wt2pfxeyHDqcxc
         HGT2NGqNDuzehTa0QijHcR97mXOs1J+H+2mJ46JHFhPk6XZfnisD+R37bMDh2M9WiZq3
         MSr8s3Qhiy5xIfqLB/smHZVEetk3udAPOdilIivf5+njgF/jOhq3oLoDwhHLecPyYFNr
         afyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZvHSZ7wyO6HpWC7GgWotvlWeVl4F+Q0dZdGlQyXVA6g=;
        b=UHuzIOCfPt+GjHDk6nhYABx2eUPd0sJLejYevBs9Itk27/dc3rbA/8qFjTmrznCEsr
         DAJfhGP5fQLYvHYOk8/SizYOWGlGa+jkkTNk0QEvcH/wZUnk4UwtNzTfl27NHyZZagnt
         oJCerCo2+mOZoX1lKniB6Ndau36KNNexQVRpNGia8JBSrAgbixWYaAzsbUyFl0161lOl
         KW8t+uiPZRPmyAtJd4g2n2KpYVogl60EkT7DnABA0fvSsMXdVax8KMYPf2lE+UN8gFij
         NgFv3oXg+vH+GqvXMATq8KSAAGzT0Kkr13JH04J6yIK+7YcFc9boZVeRe1X5h32GMJyx
         kwEg==
X-Gm-Message-State: AFqh2ko0YLxRolLBdEFQc+dfvPHxy+4fDnUDIZtexwJ7lYRDQeLyRQpV
        a8Ol1cM7QM/x8WaxBa1xkzwFXNsiE0gk
X-Google-Smtp-Source: AMrXdXsBIYopM+oXFd1TuMnwioq69ljz0C7ryUPd48AdQSG9d1WWHfGQSnTqu93hPAaLpy1hYVRjWli9HEic
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a05:6a00:3404:b0:577:4103:8da with SMTP id
 cn4-20020a056a00340400b00577410308damr245364pfb.1.1671661482452; Wed, 21 Dec
 2022 14:24:42 -0800 (PST)
Date:   Wed, 21 Dec 2022 22:24:16 +0000
In-Reply-To: <20221221222418.3307832-1-bgardon@google.com>
Mime-Version: 1.0
References: <20221221222418.3307832-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221221222418.3307832-13-bgardon@google.com>
Subject: [RFC 12/14] KVM: x86/MMU: Remove unneeded exports from shadow_mmu.c
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the various dirty logging / wrprot function implementations are
in shadow_mmu.c, do another round of cleanups to remove functions which
no longer need to be exposed and can be marked static.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/shadow_mmu.c | 30 +++++++++++++++++-------------
 arch/x86/kvm/mmu/shadow_mmu.h | 18 ------------------
 2 files changed, 17 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/mmu/shadow_mmu.c b/arch/x86/kvm/mmu/shadow_mmu.c
index 80b8c78daaeb..77472eb9b06a 100644
--- a/arch/x86/kvm/mmu/shadow_mmu.c
+++ b/arch/x86/kvm/mmu/shadow_mmu.c
@@ -632,8 +632,8 @@ unsigned int pte_list_count(struct kvm_rmap_head *rmap_head)
 	return count;
 }
 
-struct kvm_rmap_head *gfn_to_rmap(gfn_t gfn, int level,
-				  const struct kvm_memory_slot *slot)
+static struct kvm_rmap_head *gfn_to_rmap(gfn_t gfn, int level,
+					 const struct kvm_memory_slot *slot)
 {
 	unsigned long idx;
 
@@ -801,7 +801,7 @@ static bool spte_write_protect(u64 *sptep, bool pt_protect)
 	return mmu_spte_update(sptep, spte);
 }
 
-bool rmap_write_protect(struct kvm_rmap_head *rmap_head, bool pt_protect)
+static bool rmap_write_protect(struct kvm_rmap_head *rmap_head, bool pt_protect)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
@@ -840,8 +840,8 @@ static bool spte_wrprot_for_clear_dirty(u64 *sptep)
  *	- W bit on ad-disabled SPTEs.
  * Returns true iff any D or W bits were cleared.
  */
-bool __rmap_clear_dirty(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-			const struct kvm_memory_slot *slot)
+static bool __rmap_clear_dirty(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
+			       const struct kvm_memory_slot *slot)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
@@ -3045,6 +3045,11 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 	write_unlock(&vcpu->kvm->mmu_lock);
 }
 
+/* The return value indicates if tlb flush on all vcpus is needed. */
+typedef bool (*slot_level_handler) (struct kvm *kvm,
+				    struct kvm_rmap_head *rmap_head,
+				    const struct kvm_memory_slot *slot);
+
 /* The caller should hold mmu-lock before calling this function. */
 static __always_inline bool
 slot_handle_level_range(struct kvm *kvm, const struct kvm_memory_slot *memslot,
@@ -3073,10 +3078,10 @@ slot_handle_level_range(struct kvm *kvm, const struct kvm_memory_slot *memslot,
 	return flush;
 }
 
-__always_inline bool slot_handle_level(struct kvm *kvm,
-				       const struct kvm_memory_slot *memslot,
-				       slot_level_handler fn, int start_level,
-				       int end_level, bool flush_on_yield)
+static __always_inline bool
+slot_handle_level(struct kvm *kvm, const struct kvm_memory_slot *memslot,
+		  slot_level_handler fn, int start_level, int end_level,
+		  bool flush_on_yield)
 {
 	return slot_handle_level_range(kvm, memslot, fn, start_level,
 			end_level, memslot->base_gfn,
@@ -3084,10 +3089,9 @@ __always_inline bool slot_handle_level(struct kvm *kvm,
 			flush_on_yield, false);
 }
 
-__always_inline bool slot_handle_level_4k(struct kvm *kvm,
-					  const struct kvm_memory_slot *memslot,
-					  slot_level_handler fn,
-					  bool flush_on_yield)
+static __always_inline bool
+slot_handle_level_4k(struct kvm *kvm, const struct kvm_memory_slot *memslot,
+		     slot_level_handler fn, bool flush_on_yield)
 {
 	return slot_handle_level(kvm, memslot, fn, PG_LEVEL_4K,
 				 PG_LEVEL_4K, flush_on_yield);
diff --git a/arch/x86/kvm/mmu/shadow_mmu.h b/arch/x86/kvm/mmu/shadow_mmu.h
index c322eeaa0688..397fb463ef54 100644
--- a/arch/x86/kvm/mmu/shadow_mmu.h
+++ b/arch/x86/kvm/mmu/shadow_mmu.h
@@ -26,11 +26,6 @@ struct pte_list_desc {
 /* Only exported for debugfs.c. */
 unsigned int pte_list_count(struct kvm_rmap_head *rmap_head);
 
-struct kvm_rmap_head *gfn_to_rmap(gfn_t gfn, int level,
-				  const struct kvm_memory_slot *slot);
-bool rmap_write_protect(struct kvm_rmap_head *rmap_head, bool pt_protect);
-bool __rmap_clear_dirty(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-			const struct kvm_memory_slot *slot);
 bool kvm_zap_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 		  struct kvm_memory_slot *slot, gfn_t gfn, int level,
 		  pte_t unused);
@@ -78,22 +73,9 @@ int kvm_shadow_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 		       int bytes, struct kvm_page_track_notifier_node *node);
 
-/* The return value indicates if tlb flush on all vcpus is needed. */
-typedef bool (*slot_level_handler) (struct kvm *kvm,
-				    struct kvm_rmap_head *rmap_head,
-				    const struct kvm_memory_slot *slot);
-bool slot_handle_level(struct kvm *kvm, const struct kvm_memory_slot *memslot,
-		       slot_level_handler fn, int start_level, int end_level,
-		       bool flush_on_yield);
-bool slot_handle_level_4k(struct kvm *kvm, const struct kvm_memory_slot *memslot,
-			  slot_level_handler fn, bool flush_on_yield);
-
 void kvm_shadow_mmu_zap_obsolete_pages(struct kvm *kvm);
 bool kvm_shadow_mmu_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
 
-bool slot_rmap_write_protect(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-			     const struct kvm_memory_slot *slot);
-
 void kvm_shadow_mmu_try_split_huge_pages(struct kvm *kvm,
 					 const struct kvm_memory_slot *slot,
 					 gfn_t start, gfn_t end,
-- 
2.39.0.314.g84b9a713c41-goog

