Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E1B75D7BA
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 01:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbjGUXAT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 19:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbjGUXAR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 19:00:17 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD143A93
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 16:00:16 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5771e0959f7so25402577b3.3
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 16:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689980415; x=1690585215;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=omheWi+fB4D/RinebRnnTaXxuGsxp/H5OZ8/iJL52gg=;
        b=vbdN8OctTXpcWhp32zvgNfnvRtfWXnph6+vcUlc57CGOPd/R/4a75ImhrgGJ3xAHn1
         HaUh6pk8xronY2t50P13VcHS9megjWcRGLgMyQ7QhQfCyyCR28TJ495s7uhFE9oLDv/v
         BUKnqDhACAN7T+UUwH5DpfGaHlhnS+WA5TMxO/jxbTNz4qzlhXWxxK5UwaB7GT7i4Jjk
         MisNKnGlVNq6+vnwALgo0EqgsXSHKXoZErQKj4TAW98IFS+aKdGQZ9cgBSAxem3upUdi
         wSCmNRxyhGEmgLGpYFwC6/jF6+ThqolhHilmyYC0Q4N9SXDCrO8n4iHEdPaFAavMSBM9
         k6SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689980415; x=1690585215;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=omheWi+fB4D/RinebRnnTaXxuGsxp/H5OZ8/iJL52gg=;
        b=dOY5obKyHMy+qe0ZZEXqoaF7ZmgI58NcLj++4JX4Vj+qvJe13hIL+Oy0EdKHgHNgSQ
         uSnSYPcD0wuDH9lvghKvnuMpB/lQYQMH9yIZhyTyAe6uDwlVuLZxx0BKz0+2sBkpafX5
         98JETipYeoA8kgQHuF3oEiV575Ug0Lnj3dajy5xY3BLSD7XRqoDrV4jbzqZrgS9OZwCT
         YHbkQyogJZuc8DeU22WkPzyH5tt9ikpr3SwG1LCWanoHZT38XAYkGCOKJT1MUzx3z5Su
         Vatg6r2WAS761g+ZV9NruUB5c++d9q7Bmy4JTwGWvPsFjfxaIedqF8Yn06Yjv3KQYRJ8
         iYXA==
X-Gm-Message-State: ABy/qLZMXTjqd4GF2BoGG7RPRouhtZgzW7oWAtySYQb9+whmUwyvlDrP
        Eywv5Ln1Qo1ZUiWcV/3pkNwJ4Qj7klQ=
X-Google-Smtp-Source: APBJJlED9CgDOHYdLhezvIRO12CxHnBgshIulfAAdeWhiRCGQ3PWOvbdpCPlyTEInQj7kA8j2mFdN/93DVQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b668:0:b0:56f:f62b:7a11 with SMTP id
 h40-20020a81b668000000b0056ff62b7a11mr13119ywk.8.1689980415400; Fri, 21 Jul
 2023 16:00:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 16:00:00 -0700
In-Reply-To: <20230721230006.2337941-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230721230006.2337941-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721230006.2337941-4-seanjc@google.com>
Subject: [PATCH v2 3/9] KVM: x86/mmu: Rename MMU_WARN_ON() to KVM_MMU_WARN_ON()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
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
index b16092d71d3f..c87539dd1ac0 100644
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
@@ -1735,7 +1735,7 @@ static void kvm_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 
 static void kvm_mmu_free_shadow_page(struct kvm_mmu_page *sp)
 {
-	MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
+	KVM_MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
 	hlist_del(&sp->hash_link);
 	list_del(&sp->link);
 	free_page((unsigned long)sp->spt);
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

