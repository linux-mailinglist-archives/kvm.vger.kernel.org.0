Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14EE2767A12
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237028AbjG2Atb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236965AbjG2AtO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:49:14 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E3749F7
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:48:36 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d27ac992539so1135356276.3
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591655; x=1691196455;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zg26OyCczKyFRFTxHD1ktdVAbwOnbHTDCM7ufXEGy6o=;
        b=yBgD4egDyD7rn5Rlgh5FzPjyIZK4NrQZnJM1XrsEWRbnhlUJw2W+HwTx6xEzr65Djo
         d5xWhDMzlm0ICw9QLqr0W/Pmm4dWjeERc0IF1lelxEBluV7VrHar/xOIrk7VKhd7mvKo
         U/IXmBY88FL+332U62NfJQT6PL5AF7CP+NHFuMECDhqsM1ymjNUVKHOgJWcF/Tp3+M+M
         zeOoyliISA4B2nUv4cyAPRkrkzcucMs56N9AE1YLAwXUh4cDFDq5lJByKszSr/GFE99y
         5qlO+lGEK4m9OiYMzAwk8RJtyKfLgfTYgAIPqlq5y9w/OkjyoWnZ8EZZvmsqK+tTEXGs
         4xAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591655; x=1691196455;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zg26OyCczKyFRFTxHD1ktdVAbwOnbHTDCM7ufXEGy6o=;
        b=QyAc23qScOpZgt/h2NF3xtncwexse8e1cZoiYkFphS9UNqKy8bQey+hM7UdFhZetOc
         NSn0hmfKqF+Ax4fBAxuZHXjoD5tN4fNnAkWCZ7s2ve0Mlv4YapvQKD1d+paAdz3AzWOd
         ZZE01ob6TLiCBM2jtoOQ0VwPhmdTXQ5b6U4OwWNtQwqDW7gSProjtpkLtYSjLuLP4YV6
         HXE0MXCN9Ontk8fKGzq9ybpfXSP2M2H0QuUu0aXvL/FGuL7DTDEsG3ODFiSDXlm/6ZSR
         5LJmpGaKIcydP9EBTvFyywOZLPauRN2+tm5GAEJvymV627dHHcnIukIEVx6/e8kTKxQu
         0diQ==
X-Gm-Message-State: ABy/qLZJ7bQkYX7YM4e6ArgjARVmrttl+HFRN1pZ9tKHcx0EaKrfjJ1o
        T1A7ZGtbyDk4i68iPxyEQZyL6qr8WJ4=
X-Google-Smtp-Source: APBJJlG4/uU8nu5xZXbyky4bUC5BOM5iTCGwVDMKaOGimw0QhzWTuEPEhaCE+OKPkruPWhR8uCo5iizSUfg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:100f:b0:cf9:3564:33cc with SMTP id
 w15-20020a056902100f00b00cf9356433ccmr24320ybt.13.1690591655397; Fri, 28 Jul
 2023 17:47:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:47:16 -0700
In-Reply-To: <20230729004722.1056172-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729004722.1056172-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729004722.1056172-7-seanjc@google.com>
Subject: [PATCH v3 06/12] KVM: x86/mmu: Rename MMU_WARN_ON() to KVM_MMU_WARN_ON()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename MMU_WARN_ON() to make it super obvious that the assertions are
all about KVM's MMU, not the primary MMU.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 4 ++--
 arch/x86/kvm/mmu/mmu_internal.h | 4 ++--
 arch/x86/kvm/mmu/spte.h         | 8 ++++----
 arch/x86/kvm/mmu/tdp_mmu.c      | 8 ++++----
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8a21b06a9646..80daaa84a8eb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1255,7 +1255,7 @@ static bool spte_clear_dirty(u64 *sptep)
 {
 	u64 spte = *sptep;
 
-	MMU_WARN_ON(!spte_ad_enabled(spte));
+	KVM_MMU_WARN_ON(!spte_ad_enabled(spte));
 	spte &= ~shadow_dirty_mask;
 	return mmu_spte_update(sptep, spte);
 }
@@ -1699,7 +1699,7 @@ static void kvm_mmu_check_sptes_at_free(struct kvm_mmu_page *sp)
 	int i;
 
 	for (i = 0; i < SPTE_ENT_PER_PAGE; i++) {
-		if (MMU_WARN_ON(is_shadow_present_pte(sp->spt[i])))
+		if (KVM_MMU_WARN_ON(is_shadow_present_pte(sp->spt[i])))
 			pr_err_ratelimited("SPTE %llx (@ %p) for gfn %llx shadow-present at free",
 					   sp->spt[i], &sp->spt[i],
 					   kvm_mmu_page_get_gfn(sp, i));
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 9ea80e4d463c..bb1649669bc9 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -9,9 +9,9 @@
 #undef MMU_DEBUG
 
 #ifdef MMU_DEBUG
-#define MMU_WARN_ON(x) WARN_ON(x)
+#define KVM_MMU_WARN_ON(x) WARN_ON(x)
 #else
-#define MMU_WARN_ON(x) do { } while (0)
+#define KVM_MMU_WARN_ON(x) do { } while (0)
 #endif
 
 /* Page table builder macros common to shadow (host) PTEs and guest PTEs. */
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 1279db2eab44..83e6614f3720 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -265,13 +265,13 @@ static inline bool sp_ad_disabled(struct kvm_mmu_page *sp)
 
 static inline bool spte_ad_enabled(u64 spte)
 {
-	MMU_WARN_ON(!is_shadow_present_pte(spte));
+	KVM_MMU_WARN_ON(!is_shadow_present_pte(spte));
 	return (spte & SPTE_TDP_AD_MASK) != SPTE_TDP_AD_DISABLED;
 }
 
 static inline bool spte_ad_need_write_protect(u64 spte)
 {
-	MMU_WARN_ON(!is_shadow_present_pte(spte));
+	KVM_MMU_WARN_ON(!is_shadow_present_pte(spte));
 	/*
 	 * This is benign for non-TDP SPTEs as SPTE_TDP_AD_ENABLED is '0',
 	 * and non-TDP SPTEs will never set these bits.  Optimize for 64-bit
@@ -282,13 +282,13 @@ static inline bool spte_ad_need_write_protect(u64 spte)
 
 static inline u64 spte_shadow_accessed_mask(u64 spte)
 {
-	MMU_WARN_ON(!is_shadow_present_pte(spte));
+	KVM_MMU_WARN_ON(!is_shadow_present_pte(spte));
 	return spte_ad_enabled(spte) ? shadow_accessed_mask : 0;
 }
 
 static inline u64 spte_shadow_dirty_mask(u64 spte)
 {
-	MMU_WARN_ON(!is_shadow_present_pte(spte));
+	KVM_MMU_WARN_ON(!is_shadow_present_pte(spte));
 	return spte_ad_enabled(spte) ? shadow_dirty_mask : 0;
 }
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 512163d52194..f881de40f9ef 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1548,8 +1548,8 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		if (!is_shadow_present_pte(iter.old_spte))
 			continue;
 
-		MMU_WARN_ON(kvm_ad_enabled() &&
-			    spte_ad_need_write_protect(iter.old_spte));
+		KVM_MMU_WARN_ON(kvm_ad_enabled() &&
+				spte_ad_need_write_protect(iter.old_spte));
 
 		if (!(iter.old_spte & dbit))
 			continue;
@@ -1607,8 +1607,8 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 		if (!mask)
 			break;
 
-		MMU_WARN_ON(kvm_ad_enabled() &&
-			    spte_ad_need_write_protect(iter.old_spte));
+		KVM_MMU_WARN_ON(kvm_ad_enabled() &&
+				spte_ad_need_write_protect(iter.old_spte));
 
 		if (iter.level > PG_LEVEL_4K ||
 		    !(mask & (1UL << (iter.gfn - gfn))))
-- 
2.41.0.487.g6d72f3e995-goog

