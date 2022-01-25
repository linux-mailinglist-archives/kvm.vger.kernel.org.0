Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0523A49BF59
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 00:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234654AbiAYXHS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 18:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbiAYXHR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 18:07:17 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F55C06161C
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 15:07:17 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id z37-20020a056a001da500b004c74e3fd644so6915231pfw.1
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 15:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=pj1P7x8X7Ztb282Wj3Bmrv1L4P94RF1b7x52MOCWza4=;
        b=rYZoX8kxiFsQyvsl9DsRt5gN5DgAAIXMF4LdjF6t27+wxPEO/CzPwbF+cRh6tdjbHk
         Nb0+4hNNoU7BV0RvNe7q2UyKXNogSYflQXDz+aguFJ6ID8NmlSl0TuC8jnHsEAjDUMbr
         uWd6sC81MoHVt1ieEWz6XUbP6xE2JnyAP7v86COxQAzA2Oe2Mb4Euaybj2y0eRT8BGv6
         zK08klcphjrmvlBfbU5ciKkA3DX6uaXnUw/K3zqabHbeYMFaCn28M1jn95EKwDLROj4+
         lK4CF0YNpytz1GWnvhhiiqtbcdmTBMzTyefdrvhL62Q87t2b2qhNtBmQxV8JASMaEjos
         mbNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=pj1P7x8X7Ztb282Wj3Bmrv1L4P94RF1b7x52MOCWza4=;
        b=BQgN/WvjL4Kcnyet3aCndjKUXiMkWgeC8GAU3ntIJkce/kAdPKCsVnVtMH+ztfCgm4
         5uz7NxnlBMiYJfVnMb1fIWB4Y+TCwVSO4Icz5ufDIqXrD8+m9dhYItKmxcIZbMwsdZdO
         wQfRs7J8hVx9f3UQVv2GjDoNY5N9a5HLi2/tnARN3bwJLDX2yq1dZ1YelmtuZmH+zOcA
         L3A2IfHLeIIiY49umiiiV/AU1+s2W3HtHjGYXFMI7PuLhf6Gu9p1OiUKFQEE8Ukxgf1A
         +fBtfo+oWkJ/jrdQBNafC1fI9nF18Gu5YGSv3bXCcfucRsCmUV0NW8+jE9Y5nQVuzBt8
         Qp5w==
X-Gm-Message-State: AOAM533FxaBJlZYepwTj8zdCXq67sgvZSWKxW7Z7dexyuljbc9KZ4+/f
        DENLaTSi0UREsc4s+yFT5WKag/4pCX3SRg==
X-Google-Smtp-Source: ABdhPJzQcOGKL9PXP4agWmfsmouEcPlm0KKTvr3/sLN7RHf4XUMyp/VzLriEH1jGP3h9Uc/Mf2EZtnVF8/fVcQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:2484:b0:4c8:ffbd:4c78 with SMTP
 id c4-20020a056a00248400b004c8ffbd4c78mr11224261pfv.24.1643152036746; Tue, 25
 Jan 2022 15:07:16 -0800 (PST)
Date:   Tue, 25 Jan 2022 23:07:13 +0000
Message-Id: <20220125230713.1700406-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 4/5] KVM: x86/mmu: Rename DEFAULT_SPTE_MMU_WRITEABLE to DEFAULT_SPTE_MMU_WRITABLE
From:   David Matlack <dmatlack@google.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Both "writeable" and "writable" are valid, but we should be consistent
about which we use. DEFAULT_SPTE_MMU_WRITEABLE was the odd one out in
the SPTE code, so rename it to DEFAULT_SPTE_MMU_WRITABLE.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c  | 2 +-
 arch/x86/kvm/mmu/spte.c | 4 ++--
 arch/x86/kvm/mmu/spte.h | 8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 795db506c230..88f3aa5f2a36 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5847,7 +5847,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 	 * will clear a separate software-only bit (MMU-writable) and skip the
 	 * flush if-and-only-if this bit was already clear.
 	 *
-	 * See DEFAULT_SPTE_MMU_WRITEABLE for more details.
+	 * See DEFAULT_SPTE_MMU_WRITABLE for more details.
 	 */
 	if (flush)
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 24d66bb899a4..ad6acdd61a9f 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -360,8 +360,8 @@ void kvm_mmu_reset_all_pte_masks(void)
 	shadow_acc_track_mask	= 0;
 	shadow_me_mask		= sme_me_mask;
 
-	shadow_host_writable_mask = DEFAULT_SPTE_HOST_WRITEABLE;
-	shadow_mmu_writable_mask  = DEFAULT_SPTE_MMU_WRITEABLE;
+	shadow_host_writable_mask = DEFAULT_SPTE_HOST_WRITABLE;
+	shadow_mmu_writable_mask  = DEFAULT_SPTE_MMU_WRITABLE;
 
 	/*
 	 * Set a reserved PA bit in MMIO SPTEs to generate page faults with
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index e1ddba45bba1..a179f089e3dd 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -75,7 +75,7 @@ static_assert(SPTE_TDP_AD_ENABLED_MASK == 0);
 static_assert(!(SPTE_TDP_AD_MASK & SHADOW_ACC_TRACK_SAVED_MASK));
 
 /*
- * *_SPTE_HOST_WRITEABLE (aka Host-writable) indicates whether the host permits
+ * *_SPTE_HOST_WRITABLE (aka Host-writable) indicates whether the host permits
  * writes to the guest page mapped by the SPTE. This bit is cleared on SPTEs
  * that map guest pages in read-only memslots and read-only VMAs.
  *
@@ -83,7 +83,7 @@ static_assert(!(SPTE_TDP_AD_MASK & SHADOW_ACC_TRACK_SAVED_MASK));
  *  - If Host-writable is clear, PT_WRITABLE_MASK must be clear.
  *
  *
- * *_SPTE_MMU_WRITEABLE (aka MMU-writable) indicates whether the shadow MMU
+ * *_SPTE_MMU_WRITABLE (aka MMU-writable) indicates whether the shadow MMU
  * allows writes to the guest page mapped by the SPTE. This bit is cleared when
  * the guest page mapped by the SPTE contains a page table that is being
  * monitored for shadow paging. In this case the SPTE can only be made writable
@@ -100,8 +100,8 @@ static_assert(!(SPTE_TDP_AD_MASK & SHADOW_ACC_TRACK_SAVED_MASK));
  */
 
 /* Bits 9 and 10 are ignored by all non-EPT PTEs. */
-#define DEFAULT_SPTE_HOST_WRITEABLE	BIT_ULL(9)
-#define DEFAULT_SPTE_MMU_WRITEABLE	BIT_ULL(10)
+#define DEFAULT_SPTE_HOST_WRITABLE	BIT_ULL(9)
+#define DEFAULT_SPTE_MMU_WRITABLE	BIT_ULL(10)
 
 /*
  * Low ignored bits are at a premium for EPT, use high ignored bits, taking care
-- 
2.35.0.rc0.227.g00780c9af4-goog

