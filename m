Return-Path: <kvm+bounces-6039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 890D882A5C3
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 03:03:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F1CC61F22900
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 02:03:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B8F4DF61;
	Thu, 11 Jan 2024 02:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1EX4g/8o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B371D298
	for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 02:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6d9b266183eso3125148b3a.1
        for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 18:01:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704938465; x=1705543265; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1yded+bpmAK7QB4V7SI1S7JIiv7Mm++nYuN9zOqBzwE=;
        b=1EX4g/8oJpSk4+xYbfSN1ML93P8YbI0VWrU8dwBgDvYtTwx/zRG+iL2zvn2PhUNPCC
         N8ER6kn4Xx/MnkeW2J+IbI1dU0iSeyQsBylKf++jj/y4xgnMo5hvCDfYg10TsUfOXewm
         rHQabi7SVhyhG/oicwowxqBjmPSI2tj55dybM2Pj89WchlptNluwgCtd7/pZlVHeEPIP
         z/Kr3QrsW5Mw7OVWblROPr2ZLCX6UszT5Klk4zKIgrU/eVG7zJbHtaLXxo34h/vuJckE
         QghmpWmE+vUhWZtzJ+2uqg/4lGoehj/GYYDT08qGMd/TV4HEhw1ytuk7l+Ljttk/Wic8
         1iuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704938465; x=1705543265;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1yded+bpmAK7QB4V7SI1S7JIiv7Mm++nYuN9zOqBzwE=;
        b=jkjLZEFmH4uhnTlRZ0MGCWA5QMUMXdpIT2fz4gJjqoP784+/4M5evcdhXyfEICyXqO
         SGpV70GhQLHTPRFnDlpQBv5729h5YLRYDBhdtL5mpM7LdGgUbvgpu+b2hiv0AYePTI4j
         BqSoppTIgHrUsmdJGj/++XjWOU9zLdqhpfIfdr/a8KysPmSilcM1tcg0OcwSSWSk/e/D
         rgNvK273rLu906QIilgO6fXOShLSK9fJE48HpM4F8NecsJpZ0zgqHDD6kjhp7ETDfu7C
         JjskePz9g+n7c23URwFbE1BcHTQv9r0e/MxbxDeKoL4iourK83x0xxDBHcfa6pBIfeLz
         Y1Ng==
X-Gm-Message-State: AOJu0YyViC1zcBXz807bP1slEdcGtfDo1uLUoND40ITJcMhZf+AxzC0t
	JcGSPZi7ZZBrlqgWx2d/T39E+L8or7vR9K6cXA==
X-Google-Smtp-Source: AGHT+IFvq58twADSMJm+6d/S+IGe2SEDfp86/oaj1BjXVD6hOjWWQD6324p/9p6gR2+0tHp36tMWsUDDvVw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3905:b0:6d9:a971:9685 with SMTP id
 fh5-20020a056a00390500b006d9a9719685mr64912pfb.6.1704938465257; Wed, 10 Jan
 2024 18:01:05 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 10 Jan 2024 18:00:47 -0800
In-Reply-To: <20240111020048.844847-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240111020048.844847-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.275.g3460e3d667-goog
Message-ID: <20240111020048.844847-8-seanjc@google.com>
Subject: [PATCH 7/8] KVM: x86/mmu: Alloc TDP MMU roots while holding mmu_lock
 for read
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Pattara Teerapong <pteerapong@google.com>
Content-Type: text/plain; charset="UTF-8"

Allocate TDP MMU roots while holding mmu_lock for read, and instead use
tdp_mmu_pages_lock to guard against duplicate roots.  This allows KVM to
create new roots without forcing kvm_tdp_mmu_zap_invalidated_roots() to
yield, e.g. allows vCPUs to load new roots after memslot deletion without
forcing the zap thread to detect contention and yield (or complete if the
kernel isn't preemptible).

Note, creating a new TDP MMU root as an mmu_lock reader is safe for two
reasons: (1) paths that must guarantee all roots/SPTEs are *visited* take
mmu_lock for write and so are still mutually exclusive, e.g. mmu_notifier
invalidations, and (2) paths that require all roots/SPTEs to *observe*
some given state without holding mmu_lock for write must ensure freshness
through some other means, e.g. toggling dirty logging must first wait for
SRCU readers to recognize the memslot flags change before processing
existing roots/SPTEs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 55 +++++++++++++++-----------------------
 1 file changed, 22 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 9a8250a14fc1..d078157e62aa 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -223,51 +223,42 @@ static void tdp_mmu_init_child_sp(struct kvm_mmu_page *child_sp,
 	tdp_mmu_init_sp(child_sp, iter->sptep, iter->gfn, role);
 }
 
-static struct kvm_mmu_page *kvm_tdp_mmu_try_get_root(struct kvm_vcpu *vcpu)
-{
-	union kvm_mmu_page_role role = vcpu->arch.mmu->root_role;
-	int as_id = kvm_mmu_role_as_id(role);
-	struct kvm *kvm = vcpu->kvm;
-	struct kvm_mmu_page *root;
-
-	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, as_id) {
-		if (root->role.word == role.word)
-			return root;
-	}
-
-	return NULL;
-}
-
 int kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	union kvm_mmu_page_role role = mmu->root_role;
+	int as_id = kvm_mmu_role_as_id(role);
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_page *root;
 
 	/*
-	 * Check for an existing root while holding mmu_lock for read to avoid
+	 * Check for an existing root before acquiring the pages lock to avoid
 	 * unnecessary serialization if multiple vCPUs are loading a new root.
 	 * E.g. when bringing up secondary vCPUs, KVM will already have created
 	 * a valid root on behalf of the primary vCPU.
 	 */
 	read_lock(&kvm->mmu_lock);
-	root = kvm_tdp_mmu_try_get_root(vcpu);
-	read_unlock(&kvm->mmu_lock);
 
-	if (root)
-		goto out;
+	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, as_id) {
+		if (root->role.word == role.word)
+			goto out_read_unlock;
+	}
 
-	write_lock(&kvm->mmu_lock);
+	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 
 	/*
-	 * Recheck for an existing root after acquiring mmu_lock for write.  It
-	 * is possible a new usable root was created between dropping mmu_lock
-	 * (for read) and acquiring it for write.
+	 * Recheck for an existing root after acquiring the pages lock, another
+	 * vCPU may have raced ahead and created a new usable root.  Manually
+	 * walk the list of roots as the standard macros assume that the pages
+	 * lock is *not* held.  WARN if grabbing a reference to a usable root
+	 * fails, as the last reference to a root can only be put *after* the
+	 * root has been invalidated, which requires holding mmu_lock for write.
 	 */
-	root = kvm_tdp_mmu_try_get_root(vcpu);
-	if (root)
-		goto out_unlock;
+	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
+		if (root->role.word == role.word &&
+		    !WARN_ON_ONCE(!kvm_tdp_mmu_get_root(root)))
+			goto out_spin_unlock;
+	}
 
 	root = tdp_mmu_alloc_sp(vcpu);
 	tdp_mmu_init_sp(root, NULL, 0, role);
@@ -280,14 +271,12 @@ int kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
 	 * is ultimately put by kvm_tdp_mmu_zap_invalidated_roots().
 	 */
 	refcount_set(&root->tdp_mmu_root_count, 2);
-
-	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 	list_add_rcu(&root->link, &kvm->arch.tdp_mmu_roots);
-	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 
-out_unlock:
-	write_unlock(&kvm->mmu_lock);
-out:
+out_spin_unlock:
+	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+out_read_unlock:
+	read_unlock(&kvm->mmu_lock);
 	/*
 	 * Note, KVM_REQ_MMU_FREE_OBSOLETE_ROOTS will prevent entering the guest
 	 * and actually consuming the root if it's invalidated after dropping
-- 
2.43.0.275.g3460e3d667-goog


