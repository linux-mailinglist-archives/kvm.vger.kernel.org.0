Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C3E340EDF
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 21:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbhCRULr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 16:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbhCRULf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Mar 2021 16:11:35 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E285C06174A
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 13:11:35 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id h21so32481702qkl.12
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 13:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=UrlGHrWQC65GrWtCnUbevQPCG8mhT0b6JNNJOYVBIxs=;
        b=T8ylBXUHFqADelPsYQknCRt7iu1DV9VleqMiWHdlxNvv6zWntILaYo8dmGiPseOo31
         /L1K2u8ZUe/M1+SP3vegO+tZb+PNXNuZ6PhfhtrpKkFF/TrRTVEyXifiyNCb6m4O/rNq
         vzIoudaysQfuvF4jnqcYgCDHj8mlJmbX/pPK/e2AjMyLokwirdogC07oscMMwyGv3v9q
         Nyzi1juCNzyARaLLl9Fn7Ogl2BwvQqGuIAT/vyqJBil9cQXRBtRgvP6ZPiWU4sntzAmI
         YMiVelHw6sTcpYMKoL7vmumvF7YXriyZkctuKHFq8vHSb075Dz/U/9+k+MLhkq28SYHM
         omxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=UrlGHrWQC65GrWtCnUbevQPCG8mhT0b6JNNJOYVBIxs=;
        b=NjeGX3hbInnt0ie5ey8Oa4ZAmSyw2qq38mJN6Vwbq0/SCSHCIn7qvE7FhM1UIdjSgT
         +Br4muBnlzvRmNhnwflF9JdVDDLJ/6xx9meGmLtSqhqbNYG6jqMBF7ItHTEyxhAgjtc9
         x/1khFhWvs1OJ1OozBF5uMyfaLGnAKneJLjdgKzkvC2WG5SpXKyLQr3lrhfQPnv/YxL1
         YO2XGiEgnxzCzQ/qmn79Ih3SFtSf9zcFpLFLP0fnPCjEWaiG0X5bqsh4qHOgT2Fbiveq
         +Q2Y6pQHR91yhr4tByBfPGg/ZKdJM2yzyWeYUaEl/a7XfBkPxLsp+S7PdD1+kjuLsWrS
         63YA==
X-Gm-Message-State: AOAM532lsvEdFsAff5C4r8Qla54yD+h91LVgeCeMEdo2SGk6vG3xQ3b7
        EjCJXvkdkzmhZeOJUY+r6oUfuUR7m+c=
X-Google-Smtp-Source: ABdhPJxnCPZBmyndEzpObEGYQRzkibgrsSxHoCxeFFY16c0rsTVGGvY5epzx5nJcp2tNEBPtv12BZ7kN7Ig=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:25e0:6b8b:f878:23d1])
 (user=seanjc job=sendgmr) by 2002:ad4:44ef:: with SMTP id p15mr6169905qvt.25.1616098294483;
 Thu, 18 Mar 2021 13:11:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 18 Mar 2021 13:11:31 -0700
Message-Id: <20210318201131.3242619-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH] KVM: x86/mmu: Rename the special lm_root to pml4_root
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename the lm_root pointer, which is used when shadowing 32-bit L1 NPT
with 64-bit L0 NPT, to pml4_root.  KVM uses dedicated logic to configure
the levels that do not exist in L1's page tables, and to bypass them when
walking the shadow page tables.  That dedicated logic assumes 4-level
paging and will need to be updated if AMD ever gains 5-level paging.

No functional change intended.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu/mmu.c          | 20 ++++++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a52f973bdff6..890ada926387 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -396,7 +396,7 @@ struct kvm_mmu {
 	u32 pkru_mask;
 
 	u64 *pae_root;
-	u64 *lm_root;
+	u64 *pml4_root;
 
 	/*
 	 * check zero bits on shadow page table entries, these
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c6ed633594a2..a535fe249cd1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3324,10 +3324,10 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	if (mmu->shadow_root_level == PT64_ROOT_4LEVEL) {
 		pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
 
-		if (WARN_ON_ONCE(!mmu->lm_root))
+		if (WARN_ON_ONCE(!mmu->pml4_root))
 			return -EIO;
 
-		mmu->lm_root[0] = __pa(mmu->pae_root) | pm_mask;
+		mmu->pml4_root[0] = __pa(mmu->pae_root) | pm_mask;
 	}
 
 	for (i = 0; i < 4; ++i) {
@@ -3347,7 +3347,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	}
 
 	if (mmu->shadow_root_level == PT64_ROOT_4LEVEL)
-		mmu->root_hpa = __pa(mmu->lm_root);
+		mmu->root_hpa = __pa(mmu->pml4_root);
 	else
 		mmu->root_hpa = __pa(mmu->pae_root);
 
@@ -3360,7 +3360,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
-	u64 *lm_root, *pae_root;
+	u64 *pml4_root, *pae_root;
 
 	/*
 	 * When shadowing 32-bit or PAE NPT with 64-bit NPT, the PML4 and PDP
@@ -3379,14 +3379,14 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 	if (WARN_ON_ONCE(mmu->shadow_root_level != PT64_ROOT_4LEVEL))
 		return -EIO;
 
-	if (mmu->pae_root && mmu->lm_root)
+	if (mmu->pae_root && mmu->pml4_root)
 		return 0;
 
 	/*
 	 * The special roots should always be allocated in concert.  Yell and
 	 * bail if KVM ends up in a state where only one of the roots is valid.
 	 */
-	if (WARN_ON_ONCE(!tdp_enabled || mmu->pae_root || mmu->lm_root))
+	if (WARN_ON_ONCE(!tdp_enabled || mmu->pae_root || mmu->pml4_root))
 		return -EIO;
 
 	/*
@@ -3397,14 +3397,14 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 	if (!pae_root)
 		return -ENOMEM;
 
-	lm_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
-	if (!lm_root) {
+	pml4_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+	if (!pml4_root) {
 		free_page((unsigned long)pae_root);
 		return -ENOMEM;
 	}
 
 	mmu->pae_root = pae_root;
-	mmu->lm_root = lm_root;
+	mmu->pml4_root = pml4_root;
 
 	return 0;
 }
@@ -5281,7 +5281,7 @@ static void free_mmu_pages(struct kvm_mmu *mmu)
 	if (!tdp_enabled && mmu->pae_root)
 		set_memory_encrypted((unsigned long)mmu->pae_root, 1);
 	free_page((unsigned long)mmu->pae_root);
-	free_page((unsigned long)mmu->lm_root);
+	free_page((unsigned long)mmu->pml4_root);
 }
 
 static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
-- 
2.31.0.rc2.261.g7f71774620-goog

