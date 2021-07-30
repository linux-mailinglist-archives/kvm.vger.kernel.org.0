Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2FA03DC128
	for <lists+kvm@lfdr.de>; Sat, 31 Jul 2021 00:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbhG3Wh3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 18:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233322AbhG3Wh1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 18:37:27 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58514C06175F
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 15:37:22 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id f62-20020a17090a28c4b02901733dbfa29cso15101167pjd.0
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 15:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=C8wsi/YpXV8rtnPArvQuTmmEPgRsr+T0f2WmE+1tIKc=;
        b=W2tOXIonhbyUDII+EidcljCQOcSIe5iUE2ZrdgCTlFu7041m4I02VARVFkyT/GkvnF
         UqEBFvKWdKcId+x9qxqUd4x+lXSIpNLmDUHHgVDo01GNi3Je+dBRP01Nmi4lAkiCjzAo
         b/GhgAZeFernKZ2OBbYJMztIkq+/YiVttFivbm9auFs9aZOpWPzeUOQgaiHwo5w71Hys
         WlV/RIbbzWCxSA6IFQssu9ODOtzoHe/Wzfhx/254j00JfaU+VkLJ8JlrY1GF2tl0CE5l
         xwPRsqrwBkGkcgP2FeCh40ebCt/RG4Vog7J+gtrDuLQ6DaVmDucGctbYp6F02l5yWzGx
         dzJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=C8wsi/YpXV8rtnPArvQuTmmEPgRsr+T0f2WmE+1tIKc=;
        b=mQ5KS9vumYKnAZCaQzRZy9QPemvIdYEPmxjC7Hq9hfMI6jkIhx9IgKSheTjhZnSq8m
         M6/Dt7KmsDCnbhtduqcRov0CeCKJ9B6EbEyZGHXldxbqk467LbBM6P9uGbjLpCgzPrPN
         rSaZFldU+5xCQRKHWcJkm4Rt8wcXoeXJxvxDI9hZWLhIRA+n1jBoSkG+JhaN0uXfW9xY
         YOD5QCU4bgP8pNcBU6sSZO6e2NdKEdbB2OzesLvCWakuRti5lOxvRLUs6rSYyS37XPPU
         jBvYrNM7CPUI9FcZM4XMydUQ16++se+4eJdU0DpNyKDaTcxkNC5EnzE4XPA2OQ7Z/Gnp
         Dvxg==
X-Gm-Message-State: AOAM5310jOpIE8ix0DU3scxxA7J6Xe6CHJEbVi0EQCnXY7v57kTZ0XVa
        F+SC8xyoGLuyNu2J/AY6Jx5us6Vjcqhe0u//oHXV0hUU0q55ACzEg8tBNSbUq7XPxzjKZp1M1Tp
        A8ESjq314PfK9AsSh/71t0rbNGYzuI6FS6NGj7XvMu4kUQsSITSUUt+KTi3YkyDI=
X-Google-Smtp-Source: ABdhPJyykJ4sAN4ft9cJ3uqJICBj9Be2CtGVlA9sX1e+0ejfcLAS7IcyqJ1Xqz3tbezEKqlhYWlNYLWDqNGlpw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:903:300d:b029:12c:916f:fedd with SMTP
 id o13-20020a170903300db029012c916ffeddmr4259981pla.19.1627684641735; Fri, 30
 Jul 2021 15:37:21 -0700 (PDT)
Date:   Fri, 30 Jul 2021 22:37:06 +0000
In-Reply-To: <20210730223707.4083785-1-dmatlack@google.com>
Message-Id: <20210730223707.4083785-6-dmatlack@google.com>
Mime-Version: 1.0
References: <20210730223707.4083785-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH 5/6] KVM: x86/mmu: Rename __gfn_to_rmap to gfn_to_rmap
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

gfn_to_rmap was removed in the previous patch so there is no need to
retain the double underscore on __gfn_to_rmap.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 370a6ebc2ede..df493729d86c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1034,8 +1034,8 @@ static bool pte_list_destroy(struct kvm_rmap_head *rmap_head,
 	return true;
 }
 
-static struct kvm_rmap_head *__gfn_to_rmap(gfn_t gfn, int level,
-					   const struct kvm_memory_slot *slot)
+static struct kvm_rmap_head *gfn_to_rmap(gfn_t gfn, int level,
+					 const struct kvm_memory_slot *slot)
 {
 	unsigned long idx;
 
@@ -1060,7 +1060,7 @@ static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 	sp = sptep_to_sp(spte);
 	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-	rmap_head = __gfn_to_rmap(gfn, sp->role.level, slot);
+	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
 	return pte_list_add(vcpu, spte, rmap_head);
 }
 
@@ -1084,7 +1084,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	slots = kvm_memslots_for_spte_role(kvm, sp->role);
 
 	slot = __gfn_to_memslot(slots, gfn);
-	rmap_head = __gfn_to_rmap(gfn, sp->role.level, slot);
+	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
 
 	__pte_list_remove(spte, rmap_head);
 }
@@ -1306,8 +1306,8 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 		return;
 
 	while (mask) {
-		rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
-					  PG_LEVEL_4K, slot);
+		rmap_head = gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
+					PG_LEVEL_4K, slot);
 		__rmap_write_protect(kvm, rmap_head, false);
 
 		/* clear the first set bit */
@@ -1339,8 +1339,8 @@ static void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 		return;
 
 	while (mask) {
-		rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
-					  PG_LEVEL_4K, slot);
+		rmap_head = gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
+					PG_LEVEL_4K, slot);
 		__rmap_clear_dirty(kvm, rmap_head, slot);
 
 		/* clear the first set bit */
@@ -1406,7 +1406,7 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 
 	if (kvm_memslots_have_rmaps(kvm)) {
 		for (i = min_level; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
-			rmap_head = __gfn_to_rmap(gfn, i, slot);
+			rmap_head = gfn_to_rmap(gfn, i, slot);
 			write_protected |= __rmap_write_protect(kvm, rmap_head, true);
 		}
 	}
@@ -1506,9 +1506,8 @@ rmap_walk_init_level(struct slot_rmap_walk_iterator *iterator, int level)
 {
 	iterator->level = level;
 	iterator->gfn = iterator->start_gfn;
-	iterator->rmap = __gfn_to_rmap(iterator->gfn, level, iterator->slot);
-	iterator->end_rmap = __gfn_to_rmap(iterator->end_gfn, level,
-					   iterator->slot);
+	iterator->rmap = gfn_to_rmap(iterator->gfn, level, iterator->slot);
+	iterator->end_rmap = gfn_to_rmap(iterator->end_gfn, level, iterator->slot);
 }
 
 static void
@@ -1638,7 +1637,7 @@ static void rmap_recycle(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 
 	sp = sptep_to_sp(spte);
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-	rmap_head = __gfn_to_rmap(gfn, sp->role.level, slot);
+	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
 
 	kvm_unmap_rmapp(vcpu->kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
 	kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
-- 
2.32.0.554.ge1b32706d8-goog

