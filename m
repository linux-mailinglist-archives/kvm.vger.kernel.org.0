Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3B15A326B
	for <lists+kvm@lfdr.de>; Sat, 27 Aug 2022 01:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345460AbiHZXNN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 19:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345470AbiHZXNF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 19:13:05 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6599CEA314
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 16:12:52 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-33dd097f993so47979367b3.10
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 16:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=Kff/0R5ZAb3eLKnoS/NhGeKWqIVOtWmm3mC7ca1Wnx0=;
        b=ixJZSKVKYIY0ufhPfhIBQMcpSQDUn+9ZD2MAsqeYZdMVGdshQ61gEcp4PYT0sYiVc2
         vw3hxhQEDlls3DH7HpeeJ18HVa+IBzAnbLPB1IRhSywYmZwYt6vSgVmLD7cBw2tuVlRn
         ct5G9x6fogv27y461CRdh1djWGuYEfbmbFRGYR6t8Dlfs9bpHqeV3PbgI8G07+zkOI4w
         0TN2RzBxAFuVTSCBVyHN+O6vogn9loFUiSrVk8LTVatcGjlbNs98lkL/FXPWnjD5gGHy
         O0cBSRpyDIs2+L89qsRBdk+DsCKngf6xSx5I6Ps8Bjc62LMx30xcCb1RrQyjJ/H2/2WG
         Fmuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=Kff/0R5ZAb3eLKnoS/NhGeKWqIVOtWmm3mC7ca1Wnx0=;
        b=JvHR1G9UOvbgqlXNi5El7PYHdGuHNGjJ368hB+DFDuH2oh56Nf8T1+3KZ3X+L9q8x8
         JxlPnzdKlvdyo9ZJ/OG0Lvileykpc9806ilDBJPM+O06nnFvF/PFTcMaFMBsPsbd1lGo
         lGo72aa88JdYvS1wElHX6fRw8YcVMmiz1Km7fhRdVtJm/793uU2ii5JbfUl1Vbx1KamH
         glwX5OJSssAno8+TrJ8q5KXelsSA46T+EppXT4TlzfKQYqah0TL3kqXTNl7M5lVP47L4
         MK3Xo6P3YuvRtgf/6VSXPUetnVBfDlAJxHOhh8/87FcwN3oRZVAo0MWctAir7/I/hF8F
         YPtg==
X-Gm-Message-State: ACgBeo1QbRq2rFUa8F3D3KuAWQJ6zcK7kPkaf69tALnv8TMxGUQo/Jyt
        3YPUyOAwDQIdy0EUl8JtvDrRJXZl7rn9Kw==
X-Google-Smtp-Source: AA6agR5MMe7z+aB+vesbd3gopa7ekwSpPGMtzaYXWCWtGv/bgz/4TA6dFHt3Hk/sN5a7sRfWLiyJ2f2gS9Hn8A==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:d791:0:b0:695:9953:d27b with SMTP id
 o139-20020a25d791000000b006959953d27bmr1677782ybg.61.1661555571929; Fri, 26
 Aug 2022 16:12:51 -0700 (PDT)
Date:   Fri, 26 Aug 2022 16:12:27 -0700
In-Reply-To: <20220826231227.4096391-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20220826231227.4096391-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220826231227.4096391-11-dmatlack@google.com>
Subject: [PATCH v2 10/10] KVM: x86/mmu: Rename __direct_map() to direct_map()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename __direct_map() to direct_map() since the leading underscores are
unnecessary. This also makes the page fault handler names more
consistent: kvm_tdp_mmu_page_fault() calls kvm_tdp_mmu_map() and
direct_page_fault() calls direct_map().

Opportunistically make some trivial cleanups to comments that had to be
modified anyway since they mentioned __direct_map(). Specifically, use
"()" when referring to functions, and include kvm_tdp_mmu_map() among
the various callers of disallowed_hugepage_adjust().

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 14 +++++++-------
 arch/x86/kvm/mmu/mmu_internal.h |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 803aed2c0e74..2d68adc3bfb1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3082,11 +3082,11 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
 	    is_shadow_present_pte(spte) &&
 	    !is_large_pte(spte)) {
 		/*
-		 * A small SPTE exists for this pfn, but FNAME(fetch)
-		 * and __direct_map would like to create a large PTE
-		 * instead: just force them to go down another level,
-		 * patching back for them into pfn the next 9 bits of
-		 * the address.
+		 * A small SPTE exists for this pfn, but FNAME(fetch),
+		 * direct_map(), or kvm_tdp_mmu_map() would like to create a
+		 * large PTE instead: just force them to go down another level,
+		 * patching back for them into pfn the next 9 bits of the
+		 * address.
 		 */
 		u64 page_mask = KVM_PAGES_PER_HPAGE(cur_level) -
 				KVM_PAGES_PER_HPAGE(cur_level - 1);
@@ -3095,7 +3095,7 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
 	}
 }
 
-static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+static int direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_shadow_walk_iterator it;
 	struct kvm_mmu_page *sp;
@@ -4269,7 +4269,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (r)
 		goto out_unlock;
 
-	r = __direct_map(vcpu, fault);
+	r = direct_map(vcpu, fault);
 
 out_unlock:
 	write_unlock(&vcpu->kvm->mmu_lock);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 1e91f24bd865..b8c116ec1a89 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -198,7 +198,7 @@ struct kvm_page_fault {
 
 	/*
 	 * Maximum page size that can be created for this fault; input to
-	 * FNAME(fetch), __direct_map and kvm_tdp_mmu_map.
+	 * FNAME(fetch), direct_map() and kvm_tdp_mmu_map().
 	 */
 	u8 max_level;
 
-- 
2.37.2.672.g94769d06f0-goog

