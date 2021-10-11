Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23BAC42984B
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 22:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235027AbhJKUqX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 16:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbhJKUqW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 16:46:22 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EFAEC061570
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 13:44:22 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id f9-20020a056a001ac900b0044c4f04a6b1so8009311pfv.23
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 13:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=qvl4iyoWhCXbt9RpQc4wbdRqI0EOK08ThyP4HTnKsaY=;
        b=OWEOq5UgEUtAEE0nIImklihqJ1d+5c8eibI5E21Yd0r/JFq7YLKBbAhaWR2KM2nUsO
         LE7HFyhjRbxrvEHDVXuwaEggjakSpS6BoNJ1vQ6HNIRkU+Jye+Gn7V96y1tadCDrl/cA
         c+SHVO1EKalGgWVzJpkbypbq6CvwPruiMfmSY2+QFhu+63EdjGZUEeazDFqpgYbtLdwv
         uYEKs+ep19fHVVq+u3rs+DtC6oOB0Deo8Ej8NJ65u+nHzReKGQp8Mqr41W44cOEjzbwj
         wUXXRlk5qJA/FJFbCDyyljUdUhyWzIdfkfOs61y6JQr4ayzVIvagtRpV3iEN5OUQet9/
         bz4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=qvl4iyoWhCXbt9RpQc4wbdRqI0EOK08ThyP4HTnKsaY=;
        b=RZwXPmSww9OT9ia6nstt+wycnoQfQv4DSXV5hNDfmasTvVr3afHz/zmQLXstQsuIJa
         EJT1XGm1NiUpiRFI7OdiAF8yR7rPtu+4aJzQ4V3YlFxy+NBUf3CnpE7xDlX3jHM4kWSa
         X4almobz1ZyZxGAoY58WAl9GE1kUDs6mxZi5VbVXZ1uZML7ywznxyyWfflXAhmbiGcN1
         cuA2JByKTdcVfZnpA0j14LSIwUgqg6TQwazsRWyi2GJMcXI/Qq5GxYZaLNQTRYHIo8/w
         OH70tV0N1JYzsW3CasQ8rfuUuQFky1++0+lWptwugtFNde4qTEnV5iBjKIt92BXKBXpv
         EZwA==
X-Gm-Message-State: AOAM533iZ13o/u3Ap0P1cujV+PeBbywFo5ISsUhcrC/qqQ5xf2T9vI/3
        3CP/vBA9xHPeoJ+j2honM7tQG8OFwKTmDg==
X-Google-Smtp-Source: ABdhPJwmbkXAQXd7Lh7B35h8Ggw3Ri57c+zj4AOL7UgaAuPzlD47PpHzZh3wxkxhYi/MGRZRcy5C3Dm09FzI3g==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:248a:b0:44c:ecc5:a165 with SMTP
 id c10-20020a056a00248a00b0044cecc5a165mr16880006pfv.43.1633985061720; Mon,
 11 Oct 2021 13:44:21 -0700 (PDT)
Date:   Mon, 11 Oct 2021 20:44:18 +0000
Message-Id: <20211011204418.162846-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH] KVM: x86/mmu: Rename slot_handle_leaf to slot_handle_level_4k
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Junaid Shahid <junaids@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

slot_handle_leaf is a misnomer because it only operates on 4K SPTEs
whereas "leaf" is used to describe any valid terminal SPTE (4K or
large page). Rename slot_handle_leaf to slot_handle_level_4k to
avoid confusion.

Making this change makes it more obvious there is a benign discrepency
between the legacy MMU and the TDP MMU when it comes to dirty logging.
The legacy MMU only operates on 4K SPTEs when zapping for collapsing
and when clearing D-bits. The TDP MMU, on the other hand, operates on
SPTEs on all levels. The TDP MMU behavior is technically overkill but
not incorrect. So opportunistically add comments to explain the
difference.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 24a9f4c3f5e7..f00644e79ef5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5382,8 +5382,8 @@ slot_handle_level(struct kvm *kvm, const struct kvm_memory_slot *memslot,
 }
 
 static __always_inline bool
-slot_handle_leaf(struct kvm *kvm, const struct kvm_memory_slot *memslot,
-		 slot_level_handler fn, bool flush_on_yield)
+slot_handle_level_4k(struct kvm *kvm, const struct kvm_memory_slot *memslot,
+		     slot_level_handler fn, bool flush_on_yield)
 {
 	return slot_handle_level(kvm, memslot, fn, PG_LEVEL_4K,
 				 PG_LEVEL_4K, flush_on_yield);
@@ -5772,7 +5772,12 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 
 	if (kvm_memslots_have_rmaps(kvm)) {
 		write_lock(&kvm->mmu_lock);
-		flush = slot_handle_leaf(kvm, slot, kvm_mmu_zap_collapsible_spte, true);
+		/*
+		 * Strictly speaking only 4k SPTEs need to be zapped because
+		 * KVM never creates intermediate 2m mappings when performing
+		 * dirty logging.
+		 */
+		flush = slot_handle_level_4k(kvm, slot, kvm_mmu_zap_collapsible_spte, true);
 		if (flush)
 			kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
 		write_unlock(&kvm->mmu_lock);
@@ -5809,8 +5814,11 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 
 	if (kvm_memslots_have_rmaps(kvm)) {
 		write_lock(&kvm->mmu_lock);
-		flush = slot_handle_leaf(kvm, memslot, __rmap_clear_dirty,
-					 false);
+		/*
+		 * Strictly speaking only 4k SPTEs need to be cleared because
+		 * KVM always performs dirty logging at a 4k granularity.
+		 */
+		flush = slot_handle_level_4k(kvm, memslot, __rmap_clear_dirty, false);
 		write_unlock(&kvm->mmu_lock);
 	}
 
-- 
2.33.0.882.g93a45727a2-goog

