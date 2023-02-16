Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF73669991C
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 16:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjBPPlT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 10:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbjBPPlR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 10:41:17 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF9E252A2;
        Thu, 16 Feb 2023 07:40:49 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id e17so2388761plg.12;
        Thu, 16 Feb 2023 07:40:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SfxDB9XIy9b9CdyEXIgtoa+bLANGuYHYd7M+YJTBMrw=;
        b=DgkbZ9VX/h5X4KCffrWd3OJVGCVTEFnNwfAYl9NmI1P0PNmJ4b8fYOGzuJQp/wHTbS
         9x1TeieOFlQuNFfjr/894Bprz+v711lmUtcoEU7+C1TZFbnKf8PYbUP4C6nwXHwaYfVd
         2hQ6jFjgZUCCXS5ciVs6s2R0eaOTLTe+2KodY7psAydHpW2V0DKf4bmdKSn95m0lD1Fr
         xGlG+u7zMgfvRdLbBF5DfqA7sfyyezTD5uZdzqu4QHOWFOCGJBahwzp9kmpFAdXcKeB0
         /UxYvhmsyT2xHo4gFrH68hJddWSyp5MH57GD/HuA1QpeI6Gs1Z3k6QYiBgV/o8ag3FoK
         pJag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SfxDB9XIy9b9CdyEXIgtoa+bLANGuYHYd7M+YJTBMrw=;
        b=Q/bhnOshwHUIheQyEm255loa0CjnF3kRhvTIWnDb98/qmepsM2cG7OAS5IZCOCKvao
         q9eoyWuZYkEcgbQxPZHmj2oCs6EvFXuIgDDue5nFzaQI2kYOQiTWJtlFlKSd043eqRcL
         XsRZNjONkarloAxSoJYZDNOTFp86umBO1ri+DjChRUjTvq7snLi9/d+XcLk7DWE7mivC
         RQLxXOI78nAof4QDgRgD9UoWAU1NXVtkVbB3H+tmY+jSbY5d/89zoH6Pd+cFncYKDDhL
         3eBgnTGRW8LHloqDuFw+amdRVeLgkjNYXsRQw06bJc5rmLhj4pKe0GY2zIDtuE+Dk1Ww
         FObQ==
X-Gm-Message-State: AO0yUKWSDeafdDUSnEwhnJHDURO/VUATC+CevAmiD+oHaJyafinWyTvZ
        R2X/EepE7drLcScQNbzQ5IfQW+GwJBg=
X-Google-Smtp-Source: AK7set9tPQL1kxgqAY7GmVbUK5b1lBVU1kXEmv67SphafkvIWba1O0+AXile01WeniVOi8ZLjhOSJA==
X-Received: by 2002:a17:903:32c3:b0:19a:9686:ea85 with SMTP id i3-20020a17090332c300b0019a9686ea85mr7963755plr.17.1676562047478;
        Thu, 16 Feb 2023 07:40:47 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id j4-20020a170902c3c400b00196519d8647sm1491463plj.4.2023.02.16.07.40.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Feb 2023 07:40:46 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH V3 08/14] kvm: x86/mmu: Use KVM_MMU_ROOT_XXX for kvm_mmu_invalidate_addr()
Date:   Thu, 16 Feb 2023 23:41:14 +0800
Message-Id: <20230216154115.710033-9-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230216154115.710033-1-jiangshanlai@gmail.com>
References: <20230216154115.710033-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

The @root_hpa for kvm_mmu_invalidate_addr() is called with @mmu->root.hpa
or INVALID_PAGE where @mmu->root.hpa is to invalidate gva for the current
root (the same meaning as KVM_MMU_ROOT_CURRENT) and INVALID_PAGE is to
invalidate gva for all roots (the same meaning as KVM_MMU_ROOTS_ALL).

Change the argument type of kvm_mmu_invalidate_addr() and use
KVM_MMU_ROOT_XXX instead so that we can reuse the function for
kvm_mmu_invpcid_gva() and nested_ept_invalidate_addr() for invalidating
gva for different set of roots.

No fuctionalities changed.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu/mmu.c          | 39 +++++++++++++++++----------------
 arch/x86/kvm/x86.c              |  2 +-
 3 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5bd91c49c8b3..cce4243d6688 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2026,7 +2026,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 		       void *insn, int insn_len);
 void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
 void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-			     u64 addr, hpa_t root_hpa);
+			     u64 addr, unsigned long roots);
 void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
 void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a4793cb8d64a..9f261e444a32 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5764,10 +5764,12 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 EXPORT_SYMBOL_GPL(kvm_mmu_page_fault);
 
 void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-			     u64 addr, hpa_t root_hpa)
+			     u64 addr, unsigned long roots)
 {
 	int i;
 
+	WARN_ON_ONCE(roots & ~KVM_MMU_ROOTS_ALL);
+
 	/* It's actually a GPA for vcpu->arch.guest_mmu.  */
 	if (mmu != &vcpu->arch.guest_mmu) {
 		/* INVLPG on a non-canonical address is a NOP according to the SDM.  */
@@ -5780,31 +5782,30 @@ void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	if (!mmu->invlpg)
 		return;
 
-	if (root_hpa == INVALID_PAGE) {
+	if (roots & KVM_MMU_ROOT_CURRENT)
 		mmu->invlpg(vcpu, addr, mmu->root.hpa);
 
-		/*
-		 * INVLPG is required to invalidate any global mappings for the VA,
-		 * irrespective of PCID. Since it would take us roughly similar amount
-		 * of work to determine whether any of the prev_root mappings of the VA
-		 * is marked global, or to just sync it blindly, so we might as well
-		 * just always sync it.
-		 *
-		 * Mappings not reachable via the current cr3 or the prev_roots will be
-		 * synced when switching to that cr3, so nothing needs to be done here
-		 * for them.
-		 */
-		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
-			if (VALID_PAGE(mmu->prev_roots[i].hpa))
-				mmu->invlpg(vcpu, addr, mmu->prev_roots[i].hpa);
-	} else {
-		mmu->invlpg(vcpu, addr, root_hpa);
+	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
+		if ((roots & KVM_MMU_ROOT_PREVIOUS(i)) &&
+		    VALID_PAGE(mmu->prev_roots[i].hpa))
+			mmu->invlpg(vcpu, addr, mmu->prev_roots[i].hpa);
 	}
 }
 
 void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
 {
-	kvm_mmu_invalidate_addr(vcpu, vcpu->arch.walk_mmu, gva, INVALID_PAGE);
+	/*
+	 * INVLPG is required to invalidate any global mappings for the VA,
+	 * irrespective of PCID. Since it would take us roughly similar amount
+	 * of work to determine whether any of the prev_root mappings of the VA
+	 * is marked global, or to just sync it blindly, so we might as well
+	 * just always sync it.
+	 *
+	 * Mappings not reachable via the current cr3 or the prev_roots will be
+	 * synced when switching to that cr3, so nothing needs to be done here
+	 * for them.
+	 */
+	kvm_mmu_invalidate_addr(vcpu, vcpu->arch.walk_mmu, gva, KVM_MMU_ROOTS_ALL);
 	++vcpu->stat.invlpg;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_invlpg);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b9663623c128..37958763ae2f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -799,7 +799,7 @@ void kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
 	if ((fault->error_code & PFERR_PRESENT_MASK) &&
 	    !(fault->error_code & PFERR_RSVD_MASK))
 		kvm_mmu_invalidate_addr(vcpu, fault_mmu, fault->address,
-					fault_mmu->root.hpa);
+					KVM_MMU_ROOT_CURRENT);
 
 	fault_mmu->inject_page_fault(vcpu, fault);
 }
-- 
2.19.1.6.gb485710b

