Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C61147382E
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 23:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244058AbhLMW70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 17:59:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242437AbhLMW7Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 17:59:25 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90777C061574
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 14:59:25 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id z13-20020a63e10d000000b0033b165097ccso2825414pgh.6
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 14:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2TA0P4t2+QQyG2Bby8P9l3x7+4tWbJz2qK7x6SwpSAM=;
        b=Z4+oqeg3MDKtSXeSdu4mIvuIO/hXt4vXDxoJDwPaetMmB7RscplC93rG56++9Lmthr
         QMTRRrAgdFQhyrJVU3DgW0zlLqk3G4BDynIepMkm7iOQNvQVHQzwNXvyVt7g4QEOhzm8
         rwCtpchrwX2PhP01ww3Km4d3Neuil0Ja03oL3ed7QMRDg+dBcYkmia1iKQbExLpUHk+i
         Nl1iRO9sTy4CtvuCmTBCbPPFWjCR33HUZeOfQM8fpdFZnU+387HWqUT0TT/4qDrst9x6
         s/JufiSmoSFjLfA3TrGvDiCRTg3ykXmhHo9AZITWVHJmqhRYXqF4Kf7lZfaYCKgr0S3K
         VtmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2TA0P4t2+QQyG2Bby8P9l3x7+4tWbJz2qK7x6SwpSAM=;
        b=a2rRCL9S3SR3CMVQJPo0jMRKHRpkyNrFeHaC+DpTARtb9xFX0UtKGIhHAQK4NldQzN
         C4uvEb7bL37w/PjDEYfj6bI6DpP5dmxRDggBmzpMP1o+CYgMq9VfM5Pr0X4rhhVWhpCb
         /erHBzStoF/+RYA3snFlEbDnzQvbxmQiX3hsqy/ooCJ5DrSVsphULmOu1j05CuiWU+EN
         K3dnaRUBFm1+P/6qFFi1d8utkR/DjVFRMLjcRJ0SPa0OZaSPrrW0OxA5o6rd5O9qBF3b
         V12kM/gceY9lK328LgB4KmGr69fwufUQ75nDbWmYLt/xZ1/GIIOlUScsGKsd/ZEfIKxj
         nEhw==
X-Gm-Message-State: AOAM531oaL6YEEoYq4zC5AK5RpYI4vGWh7d/kSYvVARrJ13n9E+wq448
        FXKuOvRRMS0BxDwMbVxAcgVmcg33V0iy+A==
X-Google-Smtp-Source: ABdhPJyqpNq4jk0Hi8blCyO9o4k21Ls7fQyDDPkXGGsF9MaFNL8YuZXCr/FiE0HziCqj3o3bdglt/xkGPa6gCg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:a16:: with SMTP id
 gg22mr1061071pjb.0.1639436364524; Mon, 13 Dec 2021 14:59:24 -0800 (PST)
Date:   Mon, 13 Dec 2021 22:59:07 +0000
In-Reply-To: <20211213225918.672507-1-dmatlack@google.com>
Message-Id: <20211213225918.672507-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20211213225918.672507-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v1 02/13] KVM: x86/mmu: Rename __rmap_write_protect to rmap_write_protect
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that rmap_write_protect has been renamed, there is no need for the
double underscores in front of __rmap_write_protect.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 87c3135222b3..8b702f2b6a70 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1229,9 +1229,9 @@ static bool spte_write_protect(u64 *sptep, bool pt_protect)
 	return mmu_spte_update(sptep, spte);
 }
 
-static bool __rmap_write_protect(struct kvm *kvm,
-				 struct kvm_rmap_head *rmap_head,
-				 bool pt_protect)
+static bool rmap_write_protect(struct kvm *kvm,
+			       struct kvm_rmap_head *rmap_head,
+			       bool pt_protect)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
@@ -1311,7 +1311,7 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 	while (mask) {
 		rmap_head = gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
 					PG_LEVEL_4K, slot);
-		__rmap_write_protect(kvm, rmap_head, false);
+		rmap_write_protect(kvm, rmap_head, false);
 
 		/* clear the first set bit */
 		mask &= mask - 1;
@@ -1410,7 +1410,7 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 	if (kvm_memslots_have_rmaps(kvm)) {
 		for (i = min_level; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
 			rmap_head = gfn_to_rmap(gfn, i, slot);
-			write_protected |= __rmap_write_protect(kvm, rmap_head, true);
+			write_protected |= rmap_write_protect(kvm, rmap_head, true);
 		}
 	}
 
@@ -5787,7 +5787,7 @@ static bool slot_rmap_write_protect(struct kvm *kvm,
 				    struct kvm_rmap_head *rmap_head,
 				    const struct kvm_memory_slot *slot)
 {
-	return __rmap_write_protect(kvm, rmap_head, false);
+	return rmap_write_protect(kvm, rmap_head, false);
 }
 
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
-- 
2.34.1.173.g76aa8bc2d0-goog

