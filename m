Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D203508DE
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 23:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbhCaVJ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 17:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232698AbhCaVJE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 17:09:04 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEDE0C061574
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 14:09:03 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id c1so2347755qke.8
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 14:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=shAgYfqF+cypy0/KRQK7wirhgcU0wHOuMRYUsNPex7o=;
        b=rQ0sJ7kmvyis0+Nu0wXg39UJkTyoKd5AR460peD4kAaJQY7hv028MU+6T3yUeV7aGY
         KsRRnH4PJIN6B5U2WoY/utuUlgrCKLdnBY/0FLbP34F2KCXkwWEj3Wsdh+BNM/mMvZXF
         mLLiV4x/eZ1tdOxm3ODWvVGalustQiSQfcgDLGrt67EVJ9Zm1xzN/oyNlrWxw2jfTHTo
         O42JEKWWBMt6c6guXYYqM9G4eFUP4Qbx0lwB87CRa8ggm/QvwDgbb2fQERyrE4x1jgkL
         oGO++kcbGEYdFbrjkgFIKt10dEKK5q+ZSrMX7qDX3gp+7nV6/syHZSQYlSpaOt2jWu8N
         1eBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=shAgYfqF+cypy0/KRQK7wirhgcU0wHOuMRYUsNPex7o=;
        b=cW5QQHUM8yeL2jEoTRIfwDZSiebE6ADY78FGC/S73URpk+7VcGfF3IS/PYPF/QP1LF
         MZ2xIdZLQmqjfIXpEVvb93OlY6Ix8vj/DGg7C39Tg3W+sOtNjSVx7l59CNk5WQUxhlRT
         fzdI17uynF77Im/vY/bi2c6DqUqg7XctsIediFEu0bsx/zhWCX4N+jtixqQT90NB9m/q
         Gr0Vx8JyVJpTbIWNVUk8cBgwGSWHWdjQtRsB0e0IJ3N5AoijtoE2qTf1/XD2cjTkVMus
         QxUq4ftovVrcc7eIfqht5w2xP2Br6IltOwt9SKEUq3LC91NinaaDf13+g8XfehZ9W0+C
         QPnQ==
X-Gm-Message-State: AOAM5316CYih+p73N2Orw/ScKz7rogqhLNmP/q65AUImGCfRseK96CZ3
        68H/OF1/QmfeArxAI5l18FYERWntXo6/
X-Google-Smtp-Source: ABdhPJzHLA2UAcsevKJygjkqztrpxd2hRINkIpoVNWxeuBp/FZPAb45lJOMhylWdILYORIDxrpW7yvxIyNEH
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:8026:6888:3d55:3842])
 (user=bgardon job=sendgmr) by 2002:ad4:5a14:: with SMTP id
 ei20mr4994453qvb.1.1617224942887; Wed, 31 Mar 2021 14:09:02 -0700 (PDT)
Date:   Wed, 31 Mar 2021 14:08:29 -0700
In-Reply-To: <20210331210841.3996155-1-bgardon@google.com>
Message-Id: <20210331210841.3996155-2-bgardon@google.com>
Mime-Version: 1.0
References: <20210331210841.3996155-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 01/13] KVM: x86/mmu: Re-add const qualifier in kvm_tdp_mmu_zap_collapsible_sptes
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_tdp_mmu_zap_collapsible_sptes unnecessarily removes the const
qualifier from its memlsot argument, leading to a compiler warning. Add
the const annotation and pass it to subsequent functions.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 10 +++++-----
 arch/x86/kvm/mmu/mmu_internal.h |  5 +++--
 arch/x86/kvm/mmu/tdp_mmu.c      |  4 ++--
 arch/x86/kvm/mmu/tdp_mmu.h      |  2 +-
 include/linux/kvm_host.h        |  2 +-
 5 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c6ed633594a2..f75cbb0fcc9c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -715,8 +715,7 @@ static void kvm_mmu_page_set_gfn(struct kvm_mmu_page *sp, int index, gfn_t gfn)
  * handling slots that are not large page aligned.
  */
 static struct kvm_lpage_info *lpage_info_slot(gfn_t gfn,
-					      struct kvm_memory_slot *slot,
-					      int level)
+		const struct kvm_memory_slot *slot, int level)
 {
 	unsigned long idx;
 
@@ -2736,7 +2735,7 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
 }
 
 static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
-				  struct kvm_memory_slot *slot)
+				  const struct kvm_memory_slot *slot)
 {
 	unsigned long hva;
 	pte_t *pte;
@@ -2762,8 +2761,9 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	return level;
 }
 
-int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_memory_slot *slot,
-			      gfn_t gfn, kvm_pfn_t pfn, int max_level)
+int kvm_mmu_max_mapping_level(struct kvm *kvm,
+			      const struct kvm_memory_slot *slot, gfn_t gfn,
+			      kvm_pfn_t pfn, int max_level)
 {
 	struct kvm_lpage_info *linfo;
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index e03267e93459..fc88f62d7bd9 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -156,8 +156,9 @@ enum {
 #define SET_SPTE_NEED_REMOTE_TLB_FLUSH	BIT(1)
 #define SET_SPTE_SPURIOUS		BIT(2)
 
-int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_memory_slot *slot,
-			      gfn_t gfn, kvm_pfn_t pfn, int max_level);
+int kvm_mmu_max_mapping_level(struct kvm *kvm,
+			      const struct kvm_memory_slot *slot, gfn_t gfn,
+			      kvm_pfn_t pfn, int max_level);
 int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 			    int max_level, kvm_pfn_t *pfnp,
 			    bool huge_page_disallowed, int *req_level);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f2c335854afb..6d4f4e305163 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1268,7 +1268,7 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
  */
 static void zap_collapsible_spte_range(struct kvm *kvm,
 				       struct kvm_mmu_page *root,
-				       struct kvm_memory_slot *slot)
+				       const struct kvm_memory_slot *slot)
 {
 	gfn_t start = slot->base_gfn;
 	gfn_t end = start + slot->npages;
@@ -1309,7 +1309,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
  * be replaced by large mappings, for GFNs within the slot.
  */
 void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
-				       struct kvm_memory_slot *slot)
+				       const struct kvm_memory_slot *slot)
 {
 	struct kvm_mmu_page *root;
 	int root_as_id;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 3b761c111bff..683d1d69c8c8 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -34,7 +34,7 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 				       gfn_t gfn, unsigned long mask,
 				       bool wrprot);
 void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
-				       struct kvm_memory_slot *slot);
+				       const struct kvm_memory_slot *slot);
 
 bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1b65e7204344..74e56e8673a6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1116,7 +1116,7 @@ __gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
 }
 
 static inline unsigned long
-__gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
+__gfn_to_hva_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
 {
 	return slot->userspace_addr + (gfn - slot->base_gfn) * PAGE_SIZE;
 }
-- 
2.31.0.291.g576ba9dcdaf-goog

