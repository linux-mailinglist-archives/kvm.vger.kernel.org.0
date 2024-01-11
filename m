Return-Path: <kvm+bounces-6036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 81E9482A5BE
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 03:02:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32DF028B9D6
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 02:02:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17BCF6D39;
	Thu, 11 Jan 2024 02:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EGCWAu/R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8024C70
	for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 02:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5f69158f32eso64427597b3.2
        for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 18:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704938460; x=1705543260; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=rqBadYBCjb9CMnJD46FFXiqodKZoyoy85BjKjELucac=;
        b=EGCWAu/RoLW5bBt2zCHMnoPeZXE+ZUo7T4XO7g9D9PzcGx42PlKKRO3zAc2XgsgXG0
         4YlVgaWoyOOxieQoHrof0fLfqTUh1+DkbELePUrShMEh2nrpDsJ8CFTrOAS9i65K6kQZ
         st9peNN9CWJd2Mi1LoDjRn2t+dVG6l3yqyZZVhkkR0z4+EItI1V3YBlrGM1MB3grPDCC
         2xMi8RsIOPLD7YBkBE8BUQEG2sWN5cyHrINhFNnWo+k5IuP5imfjRYHcL1WT5/ASp/uj
         RQYNQgbFFpUpctcDDcSwRPnscYuWB/+NXZfsWr/K20sGxKFgWeDr6nH8YhXO8TSCMr9p
         fpjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704938460; x=1705543260;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rqBadYBCjb9CMnJD46FFXiqodKZoyoy85BjKjELucac=;
        b=ny7PhsHJnGWhQAaq4fMNeie//KJTNk+Gbwe1V2sN0Nv7iUkTz50y9GfcyJomUEM0De
         TKGrZOvNUvFuNpG+wiEQn/fhQuQSAWYmjCIPyUH8zZW+qck9wc1WroIggAj3CJYzsThj
         uGvx1WwbyaPTJ9I4d/iuIDrw6su6XGVLayZ/+wm7b82lajaeJzAp4YvH5zqwWY79orfu
         UTubkKK3hAthYS9h0NZrD2DtijiQKfoKHEOTGlzzAluTqmtsDCsZ5bpNgIHP35Ej2IcM
         W4mmgPqx4y3o8l/55GmQmSIM33FLuI//yFI+dRPOpENzDm1vq7BJvH4LJEm2pYMYHfFE
         WTmA==
X-Gm-Message-State: AOJu0Yz1VrhK4oliuDSTaFASTx9aI6YtHGHR9+Acmeq51XI04KHaqOVK
	jMwx0PGpKfMD9iQFQ6ptPXfJaHm4Q9Io249DKA==
X-Google-Smtp-Source: AGHT+IHfVtQseKKaCaqrvm06WnOcOa35Fgo35eG5hbD17jp+kZ/ViXCrRFzICGPMEErgkHJRcVy+SZx9Mgc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:fac4:0:b0:5f9:7737:d9a8 with SMTP id
 k187-20020a0dfac4000000b005f97737d9a8mr228905ywf.7.1704938460020; Wed, 10 Jan
 2024 18:01:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 10 Jan 2024 18:00:44 -0800
In-Reply-To: <20240111020048.844847-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240111020048.844847-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.275.g3460e3d667-goog
Message-ID: <20240111020048.844847-5-seanjc@google.com>
Subject: [PATCH 4/8] KVM: x86/mmu: Skip invalid roots when zapping leaf SPTEs
 for GFN range
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Pattara Teerapong <pteerapong@google.com>
Content-Type: text/plain; charset="UTF-8"

When zapping a GFN in response to an APICv or MTRR change, don't zap SPTEs
for invalid roots as KVM only needs to ensure the guest can't use stale
mappings for the GFN.  Unlike kvm_tdp_mmu_unmap_gfn_range(), which must
zap "unreachable" SPTEs to ensure KVM doesn't mark a page accessed/dirty,
kvm_tdp_mmu_zap_leafs() isn't used (and isn't intended to be used) to
handle freeing of host memory.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 60fff2aad59e..1a9c16e5c287 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -830,16 +830,16 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 }
 
 /*
- * Zap leaf SPTEs for the range of gfns, [start, end), for all roots. Returns
- * true if a TLB flush is needed before releasing the MMU lock, i.e. if one or
- * more SPTEs were zapped since the MMU lock was last acquired.
+ * Zap leaf SPTEs for the range of gfns, [start, end), for all *VALID** roots.
+ * Returns true if a TLB flush is needed before releasing the MMU lock, i.e. if
+ * one or more SPTEs were zapped since the MMU lock was last acquired.
  */
 bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush)
 {
 	struct kvm_mmu_page *root;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
-	for_each_tdp_mmu_root_yield_safe(kvm, root)
+	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, -1)
 		flush = tdp_mmu_zap_leafs(kvm, root, start, end, true, flush);
 
 	return flush;
-- 
2.43.0.275.g3460e3d667-goog


