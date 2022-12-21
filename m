Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44B4865389A
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 23:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235144AbiLUW0J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 17:26:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235090AbiLUWZj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 17:25:39 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E2F27B0E
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 14:24:46 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id o11-20020a17090a9f8b00b00225b041ba39so254115pjp.7
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 14:24:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4TdMmKeh9xdWHOqsXuzcwDMeXjRCekoXNuBTvbORk4Y=;
        b=KtV0pVIMfC+oSFEy+6xnaTAWg/otjtJQ3S9SFSJiaqziSxkFyLCWYd++OxLcdI3jLy
         4C3EcV/Ykpd+HnLaclxh7dAhhVAMH+ziDlp47PaFQ91e+QjdlZFuVFPdGMEr8SQDDGbx
         4/Qpcj76ezTxKGP/PoSZw5IxJNR4zFVMJw+5YccygGPHkQL/5G9lr6mY+qVDAXiRMPvO
         ySvjpodRibFvIKqH+VUZxLjHX8bpBBDQMz2OR1ENE/Bah4ZAlIy3N86pUGBWVap6Wjn7
         WB8Yrqmpcq1Rq2w5AxKxOvBTJUTDeI9MXknD17Fi+uhVGb3ypwV5HytB2WWzpjdGu1z2
         BZTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4TdMmKeh9xdWHOqsXuzcwDMeXjRCekoXNuBTvbORk4Y=;
        b=zxLFy8mW38uxBnTWwoZ/WExLcn4LPkcSyYmPrwE7pHN3k65ugtCs4a4mYq0NSl5UsG
         7jKh087zQJIbR/veiuGYUcwaVECbccz6OzNA99VviS7uIosRy9xIrYUoQZWsevQHn5MR
         Ji1Kj9VSktASCB9yMbRHRG5JEB7UQC6DQhrOr7HOIKgjFhcGmEmDYVfI/lM1FVyEgNv+
         GXrOBCQ5Er64MM63mnulOrAK8k7yKSGospnIYzhJUeT0V10liS/EUTQ8jM4eFMrJiVqD
         t4ITi1yoyoELWeiKq02/4cz5ZZiL2RF5t72QAfw5liCwg+6XnfOJcOBiAp12ReVaqaEf
         Ybbg==
X-Gm-Message-State: AFqh2kr+qW3JyZ/fhddhSyb+7Cp2esupmKi6xMbfNwghNTov7CSvMUb+
        6pXE6QOJBxzp27qxgQrW/SQCsFnV2KfV
X-Google-Smtp-Source: AMrXdXvNqVXX6zU/V4HwnaQF1OmpHJ80B/IXAmbw1M/S+cN3+VYASEke/ukeHnemFxM/uBOEi3zro3UdIF9T
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:902:ab4e:b0:189:5c50:ce5 with SMTP id
 ij14-20020a170902ab4e00b001895c500ce5mr204757plb.14.1671661485557; Wed, 21
 Dec 2022 14:24:45 -0800 (PST)
Date:   Wed, 21 Dec 2022 22:24:18 +0000
In-Reply-To: <20221221222418.3307832-1-bgardon@google.com>
Mime-Version: 1.0
References: <20221221222418.3307832-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221221222418.3307832-15-bgardon@google.com>
Subject: [RFC 14/14] KVM: x86/MMU: Add kvm_shadow_mmu_ to the last few
 functions in shadow_mmu.h
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

Fix up the names of the last few Shadow MMU functions in shadow_mmu.h.
This gives a clean and obvious interface between the shared x86 MMU
code and the Shadow MMU. There are still a few functions exported from
paging_tmpl.h that are left as-is, but changing those will need to be
done separately, if at all.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c        | 23 ++++++++++--------
 arch/x86/kvm/mmu/shadow_mmu.c | 44 +++++++++++++++++++----------------
 arch/x86/kvm/mmu/shadow_mmu.h | 16 +++++++------
 3 files changed, 46 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ceb3146016d0..8f3b96af470d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -921,9 +921,11 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		u64 new_spte;
 
 		if (is_tdp_mmu(vcpu->arch.mmu))
-			sptep = kvm_tdp_mmu_fast_pf_get_last_sptep(vcpu, fault->addr, &spte);
+			sptep = kvm_tdp_mmu_fast_pf_get_last_sptep(vcpu,
+							fault->addr, &spte);
 		else
-			sptep = fast_pf_get_last_sptep(vcpu, fault->addr, &spte);
+			sptep = kvm_shadow_mmu_fast_pf_get_last_sptep(vcpu,
+							fault->addr, &spte);
 
 		if (!is_shadow_present_pte(spte))
 			break;
@@ -1113,7 +1115,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
 		mmu->root.hpa = root;
 	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
-		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level);
+		root = kvm_shadow_mmu_alloc_root(vcpu, 0, 0, shadow_root_level);
 		mmu->root.hpa = root;
 	} else if (shadow_root_level == PT32E_ROOT_LEVEL) {
 		if (WARN_ON_ONCE(!mmu->pae_root)) {
@@ -1124,8 +1126,8 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 		for (i = 0; i < 4; ++i) {
 			WARN_ON_ONCE(IS_VALID_PAE_ROOT(mmu->pae_root[i]));
 
-			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT), 0,
-					      PT32_ROOT_LEVEL);
+			root = kvm_shadow_mmu_alloc_root(vcpu,
+					i << (30 - PAGE_SHIFT), 0, PT32_ROOT_LEVEL);
 			mmu->pae_root[i] = root | PT_PRESENT_MASK |
 					   shadow_me_value;
 		}
@@ -1665,7 +1667,7 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
 	 * count. Otherwise, clear the write flooding count.
 	 */
 	if (!new_role.direct)
-		__clear_sp_write_flooding_count(
+		kvm_shadow_mmu_clear_sp_write_flooding_count(
 				to_shadow_page(vcpu->arch.mmu->root.hpa));
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_new_pgd);
@@ -2447,13 +2449,13 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	r = mmu_topup_memory_caches(vcpu, !vcpu->arch.mmu->root_role.direct);
 	if (r)
 		goto out;
-	r = mmu_alloc_special_roots(vcpu);
+	r = kvm_shadow_mmu_alloc_special_roots(vcpu);
 	if (r)
 		goto out;
 	if (vcpu->arch.mmu->root_role.direct)
 		r = mmu_alloc_direct_roots(vcpu);
 	else
-		r = mmu_alloc_shadow_roots(vcpu);
+		r = kvm_shadow_mmu_alloc_shadow_roots(vcpu);
 	if (r)
 		goto out;
 
@@ -2679,7 +2681,8 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 	 * generally doesn't use PAE paging and can skip allocating the PDP
 	 * table.  The main exception, handled here, is SVM's 32-bit NPT.  The
 	 * other exception is for shadowing L1's 32-bit or PAE NPT on 64-bit
-	 * KVM; that horror is handled on-demand by mmu_alloc_special_roots().
+	 * KVM; that horror is handled on-demand by
+	 * kvm_shadow_mmu_alloc_special_roots().
 	 */
 	if (tdp_enabled && kvm_mmu_get_tdp_level(vcpu) > PT32E_ROOT_LEVEL)
 		return 0;
@@ -2820,7 +2823,7 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 	if (r < 0)
 		return r;
 
-	node->track_write = kvm_mmu_pte_write;
+	node->track_write = kvm_shadow_mmu_pte_write;
 	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
 	kvm_page_track_register_notifier(kvm, node);
 
diff --git a/arch/x86/kvm/mmu/shadow_mmu.c b/arch/x86/kvm/mmu/shadow_mmu.c
index 1c6ff6fe3d2c..6f3e201af670 100644
--- a/arch/x86/kvm/mmu/shadow_mmu.c
+++ b/arch/x86/kvm/mmu/shadow_mmu.c
@@ -1402,14 +1402,14 @@ static int mmu_sync_children(struct kvm_vcpu *vcpu, struct kvm_mmu_page *parent,
 	return 0;
 }
 
-void __clear_sp_write_flooding_count(struct kvm_mmu_page *sp)
+void kvm_shadow_mmu_clear_sp_write_flooding_count(struct kvm_mmu_page *sp)
 {
 	atomic_set(&sp->write_flooding_count,  0);
 }
 
 static void clear_sp_write_flooding_count(u64 *spte)
 {
-	__clear_sp_write_flooding_count(sptep_to_sp(spte));
+	kvm_shadow_mmu_clear_sp_write_flooding_count(sptep_to_sp(spte));
 }
 
 /*
@@ -1480,7 +1480,7 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
 				kvm_flush_remote_tlbs(kvm);
 		}
 
-		__clear_sp_write_flooding_count(sp);
+		kvm_shadow_mmu_clear_sp_write_flooding_count(sp);
 
 		goto out;
 	}
@@ -1605,12 +1605,13 @@ static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct,
 	 * Concretely, a 4-byte PDE consumes bits 31:22, while an 8-byte PDE
 	 * consumes bits 29:21.  To consume bits 31:30, KVM's uses 4 shadow
 	 * PDPTEs; those 4 PAE page directories are pre-allocated and their
-	 * quadrant is assigned in mmu_alloc_root().   A 4-byte PTE consumes
-	 * bits 21:12, while an 8-byte PTE consumes bits 20:12.  To consume
-	 * bit 21 in the PTE (the child here), KVM propagates that bit to the
-	 * quadrant, i.e. sets quadrant to '0' or '1'.  The parent 8-byte PDE
-	 * covers bit 21 (see above), thus the quadrant is calculated from the
-	 * _least_ significant bit of the PDE index.
+	 * quadrant is assigned in kvm_shadow_mmu_alloc_root().
+	 * A 4-byte PTE consumes bits 21:12, while an 8-byte PTE consumes
+	 * bits 20:12.  To consume bit 21 in the PTE (the child here), KVM
+	 * propagates that bit to the quadrant, i.e. sets quadrant to
+	 * '0' or '1'.  The parent 8-byte PDE covers bit 21 (see above), thus
+	 * the quadrant is calculated from the _least_ significant bit of the
+	 * PDE index.
 	 */
 	if (role.has_4_byte_gpte) {
 		WARN_ON_ONCE(role.level != PG_LEVEL_4K);
@@ -2377,7 +2378,8 @@ int kvm_shadow_mmu_direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *faul
  *  - Must be called between walk_shadow_page_lockless_{begin,end}.
  *  - The returned sptep must not be used after walk_shadow_page_lockless_end.
  */
-u64 *fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gpa_t gpa, u64 *spte)
+u64 *kvm_shadow_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gpa_t gpa,
+					   u64 *spte)
 {
 	struct kvm_shadow_walk_iterator iterator;
 	u64 old_spte;
@@ -2430,7 +2432,8 @@ static int mmu_check_root(struct kvm_vcpu *vcpu, gfn_t root_gfn)
 	return ret;
 }
 
-hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant, u8 level)
+hpa_t kvm_shadow_mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
+				u8 level)
 {
 	union kvm_mmu_page_role role = vcpu->arch.mmu->root_role;
 	struct kvm_mmu_page *sp;
@@ -2447,7 +2450,7 @@ hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant, u8 level)
 	return __pa(sp->spt);
 }
 
-static int mmu_first_shadow_root_alloc(struct kvm *kvm)
+static int kvm_shadow_mmu_first_shadow_root_alloc(struct kvm *kvm)
 {
 	struct kvm_memslots *slots;
 	struct kvm_memory_slot *slot;
@@ -2508,7 +2511,7 @@ static int mmu_first_shadow_root_alloc(struct kvm *kvm)
 	return r;
 }
 
-int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
+int kvm_shadow_mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	u64 pdptrs[4], pm_mask;
@@ -2537,7 +2540,7 @@ int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	r = mmu_first_shadow_root_alloc(vcpu->kvm);
+	r = kvm_shadow_mmu_first_shadow_root_alloc(vcpu->kvm);
 	if (r)
 		return r;
 
@@ -2551,8 +2554,8 @@ int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 * write-protect the guests page table root.
 	 */
 	if (mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL) {
-		root = mmu_alloc_root(vcpu, root_gfn, 0,
-				      mmu->root_role.level);
+		root = kvm_shadow_mmu_alloc_root(vcpu, root_gfn, 0,
+						 mmu->root_role.level);
 		mmu->root.hpa = root;
 		goto set_root_pgd;
 	}
@@ -2605,7 +2608,8 @@ int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		 */
 		quadrant = (mmu->cpu_role.base.level == PT32_ROOT_LEVEL) ? i : 0;
 
-		root = mmu_alloc_root(vcpu, root_gfn, quadrant, PT32_ROOT_LEVEL);
+		root = kvm_shadow_mmu_alloc_root(vcpu, root_gfn, quadrant,
+						 PT32_ROOT_LEVEL);
 		mmu->pae_root[i] = root | pm_mask;
 	}
 
@@ -2624,7 +2628,7 @@ int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	return r;
 }
 
-int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
+int kvm_shadow_mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	bool need_pml5 = mmu->root_role.level > PT64_ROOT_4LEVEL;
@@ -2997,8 +3001,8 @@ static u64 *get_written_sptes(struct kvm_mmu_page *sp, gpa_t gpa, int *nspte)
 	return spte;
 }
 
-void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
-		       int bytes, struct kvm_page_track_notifier_node *node)
+void kvm_shadow_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
+			      int bytes, struct kvm_page_track_notifier_node *node)
 {
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	struct kvm_mmu_page *sp;
diff --git a/arch/x86/kvm/mmu/shadow_mmu.h b/arch/x86/kvm/mmu/shadow_mmu.h
index 2ded3d674cb0..a3e6daa36236 100644
--- a/arch/x86/kvm/mmu/shadow_mmu.h
+++ b/arch/x86/kvm/mmu/shadow_mmu.h
@@ -26,7 +26,7 @@ struct pte_list_desc {
 /* Only exported for debugfs.c. */
 unsigned int pte_list_count(struct kvm_rmap_head *rmap_head);
 
-void __clear_sp_write_flooding_count(struct kvm_mmu_page *sp);
+void kvm_shadow_mmu_clear_sp_write_flooding_count(struct kvm_mmu_page *sp);
 
 bool __kvm_shadow_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 				       struct list_head *invalid_list,
@@ -41,17 +41,19 @@ int kvm_shadow_mmu_make_pages_available(struct kvm_vcpu *vcpu);
 int kvm_shadow_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva);
 
 int kvm_shadow_mmu_direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
-u64 *fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gpa_t gpa, u64 *spte);
+u64 *kvm_shadow_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gpa_t gpa,
+					   u64 *spte);
 
-hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant, u8 level);
-int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu);
-int mmu_alloc_special_roots(struct kvm_vcpu *vcpu);
+hpa_t kvm_shadow_mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
+				u8 level);
+int kvm_shadow_mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu);
+int kvm_shadow_mmu_alloc_special_roots(struct kvm_vcpu *vcpu);
 
 int kvm_shadow_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 			    int *root_level);
 
-void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
-		       int bytes, struct kvm_page_track_notifier_node *node);
+void kvm_shadow_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
+			      int bytes, struct kvm_page_track_notifier_node *node);
 
 void kvm_shadow_mmu_zap_obsolete_pages(struct kvm *kvm);
 bool kvm_shadow_mmu_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
-- 
2.39.0.314.g84b9a713c41-goog

