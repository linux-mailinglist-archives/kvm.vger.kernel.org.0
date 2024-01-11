Return-Path: <kvm+bounces-6038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDA6282A5C2
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 03:03:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 48ABFB271BB
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 02:03:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 146B2D52C;
	Thu, 11 Jan 2024 02:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yfjUfKDo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567199457
	for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 02:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-28c2033b552so5099485a91.2
        for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 18:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704938463; x=1705543263; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=S8K/qn0TNKAsHDt1ajFUKBR5bZ6xARBJmrA6iyLHTPU=;
        b=yfjUfKDoElqVE3+fRe6KWLVGB3Ngr7yy7xljEHS1HPNOEWZN9mOEEstx0jqMwCXvnA
         DE8TDHc5uZkiT8/jH39O+ltF8ZhlaQm5aRe/i30g8YVDgOfE5qPnqTZ37jvwSaUAV5c0
         PyMNUE/8jKq5/bonxkYsnewkyMpP8HfmrSbjW4y2dClUFQgpcwP85A0dCjBJDUi4dnnl
         JpOb1Z28eKj60zZju4xgG2Oh450Bv4ophVHtZ24ApVyeFBR5nGf5wIpWIqb6ZG1GR/Ik
         eABmdHa/KVNu4FomG2yCV/Zn0Q1iljcug2tS17HiL+xpgbYRPaHdRN5u7G1FKtP2w6Ts
         DYDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704938463; x=1705543263;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S8K/qn0TNKAsHDt1ajFUKBR5bZ6xARBJmrA6iyLHTPU=;
        b=EHKgIp0oxw6T4j7WAdnRKl1Fl2xfXnMVKXVY6Mm7VsX3kMKx6IpkJwIdv/SskGhO0B
         mtfEXCnzE8nNM6UYv5k5zfcsisrwsVRiljR/0EkPOGoLRanyvMr5JxAp352x7JwBIc4c
         Q5xJvLjEulIkNHz92lee5LS2ATpIw9wFVpJ7TW3TpuXoAXjf4VPgyL1ekkCRCfAwe7dx
         TQ5W8vLvsfPR98tRfnQtnkvSspVqRpsJnPty91FaObhjdUk2a35IkypfkF7qgt8DJZam
         9vvP1/c+MQhbT4dkc60JD2IdD0wOiXCHdUkxFcikV43Plk2ZW3jJqimtr7AXBY+Ariaz
         Fv5Q==
X-Gm-Message-State: AOJu0YzSmdsq64YIhOXu9rwyG6brY3+rYdcIy6UAIPTmco8yx6FDiZJo
	hbVM41UUESikLmFb0Fnym39GeTq+9MfENs6o1Q==
X-Google-Smtp-Source: AGHT+IHSD9fjbqJvlkpqaABL6emPcHj6dKK9SdhpI0/FNTBle8c/824ljZA4HSmlBkdYHtVhi4s3w3qBcGk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:2e8d:b0:28d:34d0:125b with SMTP id
 sn13-20020a17090b2e8d00b0028d34d0125bmr10583pjb.7.1704938463699; Wed, 10 Jan
 2024 18:01:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 10 Jan 2024 18:00:46 -0800
In-Reply-To: <20240111020048.844847-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240111020048.844847-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.275.g3460e3d667-goog
Message-ID: <20240111020048.844847-7-seanjc@google.com>
Subject: [PATCH 6/8] KVM: x86/mmu: Check for usable TDP MMU root while holding
 mmu_lock for read
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Pattara Teerapong <pteerapong@google.com>
Content-Type: text/plain; charset="UTF-8"

When allocating a new TDP MMU root, check for a usable root while holding
mmu_lock for read and only acquire mmu_lock for write if a new root needs
to be created.  There is no need to serialize other MMU operations if a
vCPU is simply grabbing a reference to an existing root, holding mmu_lock
for write is "necessary" (spoiler alert, it's not strictly necessary) only
to ensure KVM doesn't end up with duplicate roots.

Allowing vCPUs to get "new" roots in parallel is beneficial to VM boot and
to setups that frequently delete memslots, i.e. which force all vCPUs to
reload all roots.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     |  8 ++---
 arch/x86/kvm/mmu/tdp_mmu.c | 60 +++++++++++++++++++++++++++++++-------
 arch/x86/kvm/mmu/tdp_mmu.h |  2 +-
 3 files changed, 55 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3c844e428684..ea18aca23196 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3693,15 +3693,15 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	unsigned i;
 	int r;
 
+	if (tdp_mmu_enabled)
+		return kvm_tdp_mmu_alloc_root(vcpu);
+
 	write_lock(&vcpu->kvm->mmu_lock);
 	r = make_mmu_pages_available(vcpu);
 	if (r < 0)
 		goto out_unlock;
 
-	if (tdp_mmu_enabled) {
-		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
-		mmu->root.hpa = root;
-	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
+	if (shadow_root_level >= PT64_ROOT_4LEVEL) {
 		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level);
 		mmu->root.hpa = root;
 	} else if (shadow_root_level == PT32E_ROOT_LEVEL) {
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index e0a8343f66dc..9a8250a14fc1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -223,21 +223,52 @@ static void tdp_mmu_init_child_sp(struct kvm_mmu_page *child_sp,
 	tdp_mmu_init_sp(child_sp, iter->sptep, iter->gfn, role);
 }
 
-hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
+static struct kvm_mmu_page *kvm_tdp_mmu_try_get_root(struct kvm_vcpu *vcpu)
 {
 	union kvm_mmu_page_role role = vcpu->arch.mmu->root_role;
+	int as_id = kvm_mmu_role_as_id(role);
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_page *root;
 
-	lockdep_assert_held_write(&kvm->mmu_lock);
-
-	/* Check for an existing root before allocating a new one. */
-	for_each_valid_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
-		if (root->role.word == role.word &&
-		    kvm_tdp_mmu_get_root(root))
-			goto out;
+	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, as_id) {
+		if (root->role.word == role.word)
+			return root;
 	}
 
+	return NULL;
+}
+
+int kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
+{
+	struct kvm_mmu *mmu = vcpu->arch.mmu;
+	union kvm_mmu_page_role role = mmu->root_role;
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_mmu_page *root;
+
+	/*
+	 * Check for an existing root while holding mmu_lock for read to avoid
+	 * unnecessary serialization if multiple vCPUs are loading a new root.
+	 * E.g. when bringing up secondary vCPUs, KVM will already have created
+	 * a valid root on behalf of the primary vCPU.
+	 */
+	read_lock(&kvm->mmu_lock);
+	root = kvm_tdp_mmu_try_get_root(vcpu);
+	read_unlock(&kvm->mmu_lock);
+
+	if (root)
+		goto out;
+
+	write_lock(&kvm->mmu_lock);
+
+	/*
+	 * Recheck for an existing root after acquiring mmu_lock for write.  It
+	 * is possible a new usable root was created between dropping mmu_lock
+	 * (for read) and acquiring it for write.
+	 */
+	root = kvm_tdp_mmu_try_get_root(vcpu);
+	if (root)
+		goto out_unlock;
+
 	root = tdp_mmu_alloc_sp(vcpu);
 	tdp_mmu_init_sp(root, NULL, 0, role);
 
@@ -254,8 +285,17 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 	list_add_rcu(&root->link, &kvm->arch.tdp_mmu_roots);
 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 
+out_unlock:
+	write_unlock(&kvm->mmu_lock);
 out:
-	return __pa(root->spt);
+	/*
+	 * Note, KVM_REQ_MMU_FREE_OBSOLETE_ROOTS will prevent entering the guest
+	 * and actually consuming the root if it's invalidated after dropping
+	 * mmu_lock, and the root can't be freed as this vCPU holds a reference.
+	 */
+	mmu->root.hpa = __pa(root->spt);
+	mmu->root.pgd = 0;
+	return 0;
 }
 
 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
@@ -917,7 +957,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
  * the VM is being destroyed).
  *
  * Note, kvm_tdp_mmu_zap_invalidated_roots() is gifted the TDP MMU's reference.
- * See kvm_tdp_mmu_get_vcpu_root_hpa().
+ * See kvm_tdp_mmu_alloc_root().
  */
 void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
 {
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 20d97aa46c49..6e1ea04ca885 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -10,7 +10,7 @@
 void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
 
-hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
+int kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu);
 
 __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
 {
-- 
2.43.0.275.g3460e3d667-goog


