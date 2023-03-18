Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E419E6BF7D1
	for <lists+kvm@lfdr.de>; Sat, 18 Mar 2023 05:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjCRExl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Mar 2023 00:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjCRExj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Mar 2023 00:53:39 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C78352F5A;
        Fri, 17 Mar 2023 21:53:38 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id 6-20020a17090a190600b00237c5b6ecd7so11268954pjg.4;
        Fri, 17 Mar 2023 21:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679115218;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eo4+KDyuVp6imZ3UoVGnSKhZHv3dQTebHtQbdniQRk4=;
        b=Skp4uPLkMYUbj5sNMV+AVikkLQfR9aBoLuO/Pz0cp1zlc1O2NHpbTyPjHFSpI8yuXk
         SN2ik85TihC1Iaxj8VhfUf0XvvIep0y6zon8pcHTflyxr1Zs0auF2K1kTBDgnXL2MWY2
         BrNxp9rtKIKQbyeMPBV30DtHngAvEgfbjHwwctptBVWN5x1VIbKZEZfnOSIetmi2Q5P7
         oqteB4n8uQ4VeQRD/ZVW+dD02fx/3cQlXNPxTfNUizx/NrN5qNonMTlFN+e4e2lo0Jtq
         e/MYdiPFOpRnzwO43o8yTY+id8NvFh0Z2ljIv+3cS5kKdE+zCa3t6gab+RY7Mb75qS3C
         NS9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679115218;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eo4+KDyuVp6imZ3UoVGnSKhZHv3dQTebHtQbdniQRk4=;
        b=kLVTiXgQa+bJinf01ni99+4I17sQvmgq+LWPNIu92P26LEswgojMcttW9gN6w5IHxr
         JEVJTmDYTuvSc5SMycff4KujQFm6mVz2TTaZfayXJz0BFAkiQfsZKlHrfPW6W2M1pMfW
         cLQ3+3dHWVGrNDiRNMVz5mxvIiuyZWZiLu+FBz3gAo/sQWEHTh9df4e98d/IMTQkTWP9
         K5hNeQG82eAJ/dqkxhz8VDYroiSwP3OWmjxaASE0DLNNFJQN0yj8AeQwfl5GGVd1r2Ex
         ylhYCBMRjqcwu00gvO6XsbKRDBsjixteoIUoIFW8Swm2iqmAFb5J1MxSAhE4hNEjO2z3
         H8PA==
X-Gm-Message-State: AO0yUKWIKIW11vo/22fT7YWhd+gFzEILtu9XDT9bxi4VGk+7bhKiCG1c
        zOM7K/19epxkFE9l4ceuxrU=
X-Google-Smtp-Source: AK7set+0DFjUKFvWbovf6YQtI5T6chx32hAisSjT6wgx9J/GRqhBGsEN9p772jBeRr3Df6891xVPAA==
X-Received: by 2002:a17:902:c755:b0:1a1:a790:c1e6 with SMTP id q21-20020a170902c75500b001a1a790c1e6mr3738983plq.46.1679115217716;
        Fri, 17 Mar 2023 21:53:37 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id n5-20020a170902968500b0019c3296844csm999379plp.301.2023.03.17.21.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 21:53:37 -0700 (PDT)
Date:   Fri, 17 Mar 2023 21:53:35 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, isaku.yamahata@gmail.com
Subject: Re: [PATCH RFC v8 01/56] KVM: x86: Add 'fault_is_private' x86 op
Message-ID: <20230318045335.GD408922@ls.amr.corp.intel.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-2-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230220183847.59159-2-michael.roth@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 20, 2023 at 12:37:52PM -0600,
Michael Roth <michael.roth@amd.com> wrote:

> This callback is used by the KVM MMU to check whether a #NPF was for a
> private GPA or not.
> 
> In some cases the full 64-bit error code for the #NPF will be needed to
> make this determination, so also update kvm_mmu_do_page_fault() to
> accept the full 64-bit value so it can be plumbed through to the
> callback.

Here is a patch to change error code 64-bit.

From 428a676face7a06a90e59dca1c32941c9b6ee001 Mon Sep 17 00:00:00 2001
Message-Id: <428a676face7a06a90e59dca1c32941c9b6ee001.1679114841.git.isaku.yamahata@intel.com>
From: Isaku Yamahata <isaku.yamahata@intel.com>
Date: Fri, 17 Mar 2023 12:58:42 -0700
Subject: [PATCH 1/4] KVM: x86/mmu: Pass round full 64-bit error code for the
 KVM page fault

In some cases the full 64-bit error code for the KVM page fault will be
needed to make this determination, so also update kvm_mmu_do_page_fault()
to accept the full 64-bit value so it can be plumbed through to the
callback.

The upper 32 bits of error code is discarded at kvm_mmu_page_fault()
by lower_32_bits().  Now it's passed down as full 64 bits. It turns out
that only FNAME(page_fault) depends on it.  Move lower_32_bits() into
FNAME(page_fault).

The accesses of fault->error_code are as follows
- FNAME(page_fault): change to explicitly use lower_32_bits()
- kvm_tdp_page_fault(): explicit mask with PFERR_LEVEL_MASK
- kvm_mmu_page_fault(): explicit mask with PFERR_RSVD_MASK,
                        PFERR_NESTED_GUEST_PAGE
- mmutrace: changed u32 -> u64
- pgprintk(): change %x -> %llx

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu.h              | 2 +-
 arch/x86/kvm/mmu/mmu.c          | 7 +++----
 arch/x86/kvm/mmu/mmu_internal.h | 4 ++--
 arch/x86/kvm/mmu/mmutrace.h     | 2 +-
 arch/x86/kvm/mmu/paging_tmpl.h  | 4 ++--
 5 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index de9c6b98c41b..4aaef2132b97 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -156,7 +156,7 @@ static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
 }
 
 kvm_pfn_t kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa,
-			       u32 error_code, int max_level);
+			       u64 error_code, int max_level);
 
 /*
  * Check if a given access (described through the I/D, W/R and U/S bits of a
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 960609d72dd6..0ec94c72895c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4860,7 +4860,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 static int nonpaging_page_fault(struct kvm_vcpu *vcpu,
 				struct kvm_page_fault *fault)
 {
-	pgprintk("%s: gva %llx error %x\n", __func__, fault->addr, fault->error_code);
+	pgprintk("%s: gva %llx error %llx\n", __func__, fault->addr, fault->error_code);
 
 	/* This path builds a PAE pagetable, we can map 2mb pages at maximum. */
 	fault->max_level = PG_LEVEL_2M;
@@ -4986,7 +4986,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 }
 
 kvm_pfn_t kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa,
-			       u32 error_code, int max_level)
+			       u64 error_code, int max_level)
 {
 	int r;
 	struct kvm_page_fault fault = (struct kvm_page_fault) {
@@ -6238,8 +6238,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	}
 
 	if (r == RET_PF_INVALID) {
-		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
-					  lower_32_bits(error_code), false);
+		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, error_code, false);
 		if (KVM_BUG_ON(r == RET_PF_INVALID, vcpu->kvm))
 			return -EIO;
 	}
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index aa0836191b5a..bb5709f1cb57 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -341,7 +341,7 @@ static inline bool is_nx_huge_page_enabled(struct kvm *kvm)
 struct kvm_page_fault {
 	/* arguments to kvm_mmu_do_page_fault.  */
 	const gpa_t addr;
-	const u32 error_code;
+	const u64 error_code;
 	const bool prefetch;
 
 	/* Derived from error_code.  */
@@ -427,7 +427,7 @@ enum {
 };
 
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-					u32 err, bool prefetch)
+					u64 err, bool prefetch)
 {
 	struct kvm_page_fault fault = {
 		.addr = cr2_or_gpa,
diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
index 2d7555381955..2e77883c92f6 100644
--- a/arch/x86/kvm/mmu/mmutrace.h
+++ b/arch/x86/kvm/mmu/mmutrace.h
@@ -261,7 +261,7 @@ TRACE_EVENT(
 	TP_STRUCT__entry(
 		__field(int, vcpu_id)
 		__field(gpa_t, cr2_or_gpa)
-		__field(u32, error_code)
+		__field(u64, error_code)
 		__field(u64 *, sptep)
 		__field(u64, old_spte)
 		__field(u64, new_spte)
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 594af2e1fd2f..cab6822709e2 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -791,7 +791,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	int r;
 	bool is_self_change_mapping;
 
-	pgprintk("%s: addr %llx err %x\n", __func__, fault->addr, fault->error_code);
+	pgprintk("%s: addr %llx err %llx\n", __func__, fault->addr, fault->error_code);
 	WARN_ON_ONCE(fault->is_tdp);
 
 	/*
@@ -800,7 +800,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 * The bit needs to be cleared before walking guest page tables.
 	 */
 	r = FNAME(walk_addr)(&walker, vcpu, fault->addr,
-			     fault->error_code & ~PFERR_RSVD_MASK);
+			     lower_32_bits(fault->error_code) & ~PFERR_RSVD_MASK);
 
 	/*
 	 * The page is not mapped by the guest.  Let the guest handle it.
-- 
2.25.1


-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
