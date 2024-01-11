Return-Path: <kvm+bounces-6040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 466F182A5C6
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 03:04:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9698CB27409
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 02:04:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CFBBF515;
	Thu, 11 Jan 2024 02:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mrAA3av0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBCFDDDA
	for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 02:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-28cb44ab1cbso3234727a91.3
        for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 18:01:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704938467; x=1705543267; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jlRZWhcWzn+fD2gGlO5tUrHHod5m3bTS9lxlAjC7rqo=;
        b=mrAA3av08b+1wU9XXI6KJBfPy9It8WVJVAkoqCHGd2dC+6xdLo8mtXh+26raYQgPqx
         1LOP0tqzcxtccxpEBRclGRh89lbpB8RRWzZMM7WHBfq3H8Cxv8zWoODBU27sz16RV79u
         +Q8fKqETL8k4mC9v12Dv6VSKlAxJ0h1nq/hHs8e9uzbhkNLyEA7H/2Mto6Y9fK3sAqDq
         luMZPUvHVIKXfb9WcgrlOAuH1CInLo7Lx/YGM34prPMt0qAmMRCPVnppNEC8+g+FZ2Md
         k/W9xJqTopLRZQyW//coFpTh2mXeHl6LScWtlbh/8hJ4lpBwxIqIKcIak0ki2qr2CKGh
         nR3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704938467; x=1705543267;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jlRZWhcWzn+fD2gGlO5tUrHHod5m3bTS9lxlAjC7rqo=;
        b=C2CQe6NpUzsVN+XT5X0rkKBIdTn8Hi826/PVqgS4eN3mFBjPWLnp+M6pv9pkRap8tI
         l/5W3slGWg8hB1mwrRM0jMWqUChs0sTjh+XhnMEz8tz65ltRVup7ubxNpskzdFPYoCUf
         V8D+aQSg6+CaPbnLNCipqFCAxAuo6UTYvJcq/GLhQVb8zWuADW45miuELwFtDb89OqK1
         JOrWgSpU0mGpcwxwEWxcgaRH5Xf6jsDlszxEqfZme19HZIzvwBYluM6L4eK84aaJHLQ7
         m+KVkNKjuTp/LPGnuSzzX+JlGX3CFggEe3idWMZiLmaDufgwyL7mrWuE8eVx+dUVUoPD
         6oNQ==
X-Gm-Message-State: AOJu0YzitVpTlxZ7VFSJ/2L8RkSFqGZe34BgVAkFerLOCH75J9uwjs38
	FwJE/N6rZEt9tVKZClO+3PuO5S3d1R0SH/Awug==
X-Google-Smtp-Source: AGHT+IGljudK2WkxjvCUXom4s/baTziit1tp1cV/SDZ+pOowIaMwxm7n0RoCWyaSi/GHX1x6iql700kjaSA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:2e04:b0:28d:c7ba:c44d with SMTP id
 sl4-20020a17090b2e0400b0028dc7bac44dmr2389pjb.9.1704938467174; Wed, 10 Jan
 2024 18:01:07 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 10 Jan 2024 18:00:48 -0800
In-Reply-To: <20240111020048.844847-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240111020048.844847-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.275.g3460e3d667-goog
Message-ID: <20240111020048.844847-9-seanjc@google.com>
Subject: [PATCH 8/8] KVM: x86/mmu: Free TDP MMU roots while holding mmy_lock
 for read
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Pattara Teerapong <pteerapong@google.com>
Content-Type: text/plain; charset="UTF-8"

Free TDP MMU roots from vCPU context while holding mmu_lock for read, it
is completely legal to invoke kvm_tdp_mmu_put_root() as a reader.  This
eliminates the last mmu_lock writer in the TDP MMU's "fast zap" path
after requesting vCPUs to reload roots, i.e. allows KVM to zap invalidated
roots, free obsolete roots, and allocate new roots in parallel.

On large VMs, e.g. 100+ vCPUs, allowing the bulk of the "fast zap"
operation to run in parallel with freeing and allocating roots reduces the
worst case latency for a vCPU to reload a root from 2-3ms to <100us.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ea18aca23196..90773cdb73bb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3575,10 +3575,14 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 	if (WARN_ON_ONCE(!sp))
 		return;
 
-	if (is_tdp_mmu_page(sp))
+	if (is_tdp_mmu_page(sp)) {
+		lockdep_assert_held_read(&kvm->mmu_lock);
 		kvm_tdp_mmu_put_root(kvm, sp);
-	else if (!--sp->root_count && sp->role.invalid)
-		kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
+	} else {
+		lockdep_assert_held_write(&kvm->mmu_lock);
+		if (!--sp->root_count && sp->role.invalid)
+			kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
+	}
 
 	*root_hpa = INVALID_PAGE;
 }
@@ -3587,6 +3591,7 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
 			ulong roots_to_free)
 {
+	bool is_tdp_mmu = tdp_mmu_enabled && mmu->root_role.direct;
 	int i;
 	LIST_HEAD(invalid_list);
 	bool free_active_root;
@@ -3609,7 +3614,10 @@ void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
 			return;
 	}
 
-	write_lock(&kvm->mmu_lock);
+	if (is_tdp_mmu)
+		read_lock(&kvm->mmu_lock);
+	else
+		write_lock(&kvm->mmu_lock);
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 		if (roots_to_free & KVM_MMU_ROOT_PREVIOUS(i))
@@ -3635,8 +3643,13 @@ void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
 		mmu->root.pgd = 0;
 	}
 
-	kvm_mmu_commit_zap_page(kvm, &invalid_list);
-	write_unlock(&kvm->mmu_lock);
+	if (is_tdp_mmu) {
+		read_unlock(&kvm->mmu_lock);
+		WARN_ON_ONCE(!list_empty(&invalid_list));
+	} else {
+		kvm_mmu_commit_zap_page(kvm, &invalid_list);
+		write_unlock(&kvm->mmu_lock);
+	}
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_free_roots);
 
-- 
2.43.0.275.g3460e3d667-goog


