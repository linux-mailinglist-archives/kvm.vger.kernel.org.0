Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E858352406
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 01:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236052AbhDAXhr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 19:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236000AbhDAXhq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 19:37:46 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C36DC0613E6
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 16:37:45 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id a128so878922pgc.9
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 16:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lUEmlvSjoIjUDkzyKzDbWns/XKvNm6OB5Sf7W1fM46I=;
        b=s7Io1QiTYK0QbMiTZ55cbB+/B+qinLsqNuX3/tqbgeSZe8QeFsqSfiIFbsNTl7yq4W
         YhASmXagbFieAGrP8VSUl2fpI9+nsbbRA83TJihDnOX4lKDPVzzqChKYWulKxQIOo8ag
         eRz5suN/fde9KsRWE7245tfrGJepveSJpX4DIskCaXVxXuNmmTLBEYsVODNQDlyjEodq
         Y2WevF9p82uTkhhnB46frTmPrCyTqSL8qFQHHdjs9M7kb/zKSLsVumgRCMlyP/fQGPCA
         1wizJFrOUmCq0nvg0mAnMDChUguVpUnmB843BYB7yKqBr5royFl4sO7ohpuca7nfykZz
         JxKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lUEmlvSjoIjUDkzyKzDbWns/XKvNm6OB5Sf7W1fM46I=;
        b=Uobf/T59VN9XtjAzgUhRnm8LKUzJrHHFnAxBIxKFGR3xKanFSL4KkGYqMxo7sLHcFc
         GltxTLEJrWsuVjqIFoJ9PJukIJ7RLZULZQJ/qvtjNFlAznaKyFRmIO0B3RPpSsygyOlv
         zyJW7hkJF6PV0BtcVlS/M4A25ruLUc13/8M+Ozc5WFMHiseXK4tL5JeR0/DtW1LYM5zr
         L74Coo4yi0gmmUTcXl4u5aea70xuhcvBMQ6C0Pg1nEg4y3tqnZxjaLXAA/ckYaCVSJT5
         sS3AFSSXh2Yk6ixKJErRSrc7Mb7l/rbksAxINdVI/1p7LgO2FueAwcrbnHUfNTJCwF9H
         X3zQ==
X-Gm-Message-State: AOAM533xT4Uef7GWCDra1x1cDikzjfye3dRw3n4Ptcb1NCjlSEUsbiG+
        SKPSBU8z+TOdXVfQToy26SYWgioqFDLb
X-Google-Smtp-Source: ABdhPJyOYn2mWXgiqJoC59ZluPIIISD2xUXTKX/6/h6IrQUAY5FhFt/dv1gh1ZOi/lGBZq54r3sYzN4kVPe6
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:e088:88b8:ea4a:22b6])
 (user=bgardon job=sendgmr) by 2002:a17:90a:5413:: with SMTP id
 z19mr10951048pjh.137.1617320264459; Thu, 01 Apr 2021 16:37:44 -0700 (PDT)
Date:   Thu,  1 Apr 2021 16:37:24 -0700
In-Reply-To: <20210401233736.638171-1-bgardon@google.com>
Message-Id: <20210401233736.638171-2-bgardon@google.com>
Mime-Version: 1.0
References: <20210401233736.638171-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 01/13] KVM: x86/mmu: Re-add const qualifier in kvm_tdp_mmu_zap_collapsible_sptes
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
 arch/x86/kvm/mmu/tdp_mmu.c      |  5 +++--
 arch/x86/kvm/mmu/tdp_mmu.h      |  3 ++-
 include/linux/kvm_host.h        |  2 +-
 5 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index efb41f31e80a..617809529987 100644
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
 
@@ -2735,7 +2734,7 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
 }
 
 static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
-				  struct kvm_memory_slot *slot)
+				  const struct kvm_memory_slot *slot)
 {
 	unsigned long hva;
 	pte_t *pte;
@@ -2761,8 +2760,9 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
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
index cead1d81e663..d44fe8a43a19 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -161,8 +161,9 @@ enum {
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
index ccf0d774a181..d5210a212c59 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1255,7 +1255,7 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
  */
 static bool zap_collapsible_spte_range(struct kvm *kvm,
 				       struct kvm_mmu_page *root,
-				       struct kvm_memory_slot *slot,
+				       const struct kvm_memory_slot *slot,
 				       bool flush)
 {
 	gfn_t start = slot->base_gfn;
@@ -1296,7 +1296,8 @@ static bool zap_collapsible_spte_range(struct kvm *kvm,
  * be replaced by large mappings, for GFNs within the slot.
  */
 bool kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
-				       struct kvm_memory_slot *slot, bool flush)
+				       const struct kvm_memory_slot *slot,
+				       bool flush)
 {
 	struct kvm_mmu_page *root;
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index bf3ce169122e..d7007480b3d2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -57,7 +57,8 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 				       gfn_t gfn, unsigned long mask,
 				       bool wrprot);
 bool kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
-				       struct kvm_memory_slot *slot, bool flush);
+				       const struct kvm_memory_slot *slot,
+				       bool flush);
 
 bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e6d77353025c..5e0d17b1ac2b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1124,7 +1124,7 @@ __gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
 }
 
 static inline unsigned long
-__gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
+__gfn_to_hva_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
 {
 	return slot->userspace_addr + (gfn - slot->base_gfn) * PAGE_SIZE;
 }
-- 
2.31.0.208.g409f899ff0-goog

