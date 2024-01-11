Return-Path: <kvm+bounces-6037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 61D3682A5BF
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 03:02:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 129C628BA11
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 02:02:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FDB4C8FD;
	Thu, 11 Jan 2024 02:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KsyZc9+X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6A763A9
	for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 02:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5cdacf76cb0so1499179a12.0
        for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 18:01:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704938462; x=1705543262; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MERWwVvejuOoLKFvXvHDQW4SBfvZPExzmuJgrpmkPtA=;
        b=KsyZc9+X753QEbMYIxIFHgh2aSpt1CIkEbAzz4Gc+jChvwQU96S3a9W6Enby7BQD/z
         BaqVCAGI9HujSMaaKdCbJTFetadmlmI+M20+kqOquSeFibmGd3qqvk7/dPMU4Rry+1X9
         6gsfoBc1TZlboafJSMMWgiwh76fB4hU94l36MRUeD7sZJd5z4yCNKDcEYOpzK4xapGYg
         ABTaIQ8eX3WRMDbEAiJPNoJaUW/sLIUb1YBUbMLQpFGPtF5owgev6/JVBhRo2fS2opJ9
         AysvSTtSGsuAHM9HXt9LkbcRmk5JufHD/zTto1KxysEIe8jxQcOfUhP7Dp7/uw/O4Y0W
         rSKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704938462; x=1705543262;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MERWwVvejuOoLKFvXvHDQW4SBfvZPExzmuJgrpmkPtA=;
        b=Pkjk1EYOACn7uUUhlPXd5I5QjR36Lfe9aF24NzF+cpIgQaIk7QruKJDGa8pDJzGlZD
         8usp9xvAsQOfooCfA1J4fuVQ2yBQpxhojxF/KPPZbhVEvLPQJpICwxGFBiCJAyJiH6wX
         OiNXfVk6TLBZDkZ39IOkKxObu6X4KCcH5S3PeHSFvpC/+UYnczvOEv31UA9XWXvlC1BI
         OBc0WTFMa9josVFXXuoVEwuPs1wQPzoaHApV0QT+ahGBBckCjBzNAqJ240pHYejgfMZ5
         RPXoiqg0pw9qSg3Qn1hlEeV/SAAGolBMN1ndHh7LbsvD1uBGUIT0m6KShdfcTlBvExuo
         O9xQ==
X-Gm-Message-State: AOJu0YyQPvpm1ZpRlHtS4Sy+a+BZ5ZA6AYRdSGR7i5DJShGp9bUcyEzB
	Th1lryejluPK7i3oU5S6o+sMXqgecvpXYZBciQ==
X-Google-Smtp-Source: AGHT+IEOXGSNva7+1Hjq8n3roSHCuS96MuRgZ5O0CIDTBvuo6MOx+0GOvFC6l2NkE5Z2+nycZJZ4g32dEtU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f68f:b0:1d4:c27a:db7d with SMTP id
 l15-20020a170902f68f00b001d4c27adb7dmr2556plg.0.1704938461751; Wed, 10 Jan
 2024 18:01:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 10 Jan 2024 18:00:45 -0800
In-Reply-To: <20240111020048.844847-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240111020048.844847-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.275.g3460e3d667-goog
Message-ID: <20240111020048.844847-6-seanjc@google.com>
Subject: [PATCH 5/8] KVM: x86/mmu: Skip invalid TDP MMU roots when
 write-protecting SPTEs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Pattara Teerapong <pteerapong@google.com>
Content-Type: text/plain; charset="UTF-8"

When write-protecting SPTEs, don't process invalid roots as invalid roots
are unreachable, i.e. can't be used to access guest memory and thus don't
need to be write-protected.

Note, this is *almost* a nop for kvm_tdp_mmu_clear_dirty_pt_masked(),
which is called under slots_lock, i.e. is mutually exclusive with
kvm_mmu_zap_all_fast().  But it's possible for something other than the
"fast zap" thread to grab a reference to an invalid root and thus keep a
root alive (but completely empty) after kvm_mmu_zap_all_fast() completes.

The kvm_tdp_mmu_write_protect_gfn() case is more interesting as KVM write-
protects SPTEs for reasons other than dirty logging, e.g. if a KVM creates
a SPTE for a nested VM while a fast zap is in-progress.

Add another TDP MMU iterator to visit only valid roots, and
opportunistically convert kvm_tdp_mmu_get_vcpu_root_hpa() to said iterator.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1a9c16e5c287..e0a8343f66dc 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -171,12 +171,19 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
  * Holding mmu_lock for write obviates the need for RCU protection as the list
  * is guaranteed to be stable.
  */
-#define for_each_tdp_mmu_root(_kvm, _root, _as_id)				\
+#define __for_each_tdp_mmu_root(_kvm, _root, _as_id, _only_valid)		\
 	list_for_each_entry(_root, &_kvm->arch.tdp_mmu_roots, link)		\
 		if (kvm_lockdep_assert_mmu_lock_held(_kvm, false) &&		\
-		    _as_id >= 0 && kvm_mmu_page_as_id(_root) != _as_id) {	\
+		    ((_as_id >= 0 && kvm_mmu_page_as_id(_root) != _as_id) ||	\
+		     ((_only_valid) && (_root)->role.invalid))) {		\
 		} else
 
+#define for_each_tdp_mmu_root(_kvm, _root, _as_id)			\
+	__for_each_tdp_mmu_root(_kvm, _root, _as_id, false)
+
+#define for_each_valid_tdp_mmu_root(_kvm, _root, _as_id)		\
+	__for_each_tdp_mmu_root(_kvm, _root, _as_id, true)
+
 static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu_page *sp;
@@ -224,11 +231,8 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
-	/*
-	 * Check for an existing root before allocating a new one.  Note, the
-	 * role check prevents consuming an invalid root.
-	 */
-	for_each_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
+	/* Check for an existing root before allocating a new one. */
+	for_each_valid_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
 		if (root->role.word == role.word &&
 		    kvm_tdp_mmu_get_root(root))
 			goto out;
@@ -1639,7 +1643,7 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 {
 	struct kvm_mmu_page *root;
 
-	for_each_tdp_mmu_root(kvm, root, slot->as_id)
+	for_each_valid_tdp_mmu_root(kvm, root, slot->as_id)
 		clear_dirty_pt_masked(kvm, root, gfn, mask, wrprot);
 }
 
@@ -1757,7 +1761,7 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 	bool spte_set = false;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
-	for_each_tdp_mmu_root(kvm, root, slot->as_id)
+	for_each_valid_tdp_mmu_root(kvm, root, slot->as_id)
 		spte_set |= write_protect_gfn(kvm, root, gfn, min_level);
 
 	return spte_set;
-- 
2.43.0.275.g3460e3d667-goog


