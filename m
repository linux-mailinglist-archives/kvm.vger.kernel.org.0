Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64E4B5C055F
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 19:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbiIURgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 13:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbiIURgO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 13:36:14 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66088A2AAD
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 10:36:11 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id my9-20020a17090b4c8900b002027721b2b0so8822926pjb.6
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 10:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=frPFjutnZyX4kmWlL629KtyJA6Gga7/ub7irz0TIO9Y=;
        b=Uzvi5kj2R/yJWKiYENo/aY+C44+aQ4ocF2VD/h45xbhg/mKa1jQqEPY/EMgMBH7lOX
         CWmwV1XAlww/BG6yL3LBqU2L8A724XjPjSrnJq+2TYBHQDl/4ozcHmvExNRLDnzg6/Pm
         +/0bRKxmYuTMXsyGPzL0l1SNLLK+uWlQs1m8+5gVgdgbyfnrHQWXbD9KBrl8Vjbrb7Dm
         cKLbDq9WHHm8BS5VXc0D+fvE+a8KKNL3yHXNa2mShdStLY+dKS8LZnH+OCi0/K6NzNL3
         3oTp2S5GIWICLQQHZLSqiMDxpmflVVx8fkxqaEpnYACxPw4bBd6c6CNHaWTNQ1mL5ZUy
         r5ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=frPFjutnZyX4kmWlL629KtyJA6Gga7/ub7irz0TIO9Y=;
        b=ixEsW3r79Tu1axEPQxEn2zBl464jRPfO0ZjtwnlrCM6AvB41V4YOsZiNnkkPiJbM7x
         boN4XWR/0Arp1issciOPps5ZOGhvZZWO++9PxKCPNFC9+nAI7XdeocGylE9pp+yIsNHt
         QTAmF3Y1wyZAw6+FaSIPmX1UjKa4c7hPUcfnmTUmu5DXX7kFQH2zDtZRO46hNNOslACM
         wItNWoZszRZ/E9wdKJ9Mn5kakIaNj23u/12cGcperq7AKtEUJBIJNKmIJ6BnyhE4tZ5A
         O4RFOwRN2G/yhX+kx2gDhCCCQEXpX9F4CB8RmBkywLb0BAm3qZY1ukd3BCQ+rW7fiPqr
         zddA==
X-Gm-Message-State: ACrzQf1VffSlLjv3vtK/tXJItAPNPypVpw7Hm0U8LyDx7Du89qK3DZv8
        kBCAC3UVBZwURes1MVjUlnFfGr7XKOEFDQ==
X-Google-Smtp-Source: AMsMyM4h+S/GM9KT3LlvNDktvL63E2AZsbW0wHlGyODwF5WKWRZFEFmNqo7KlgIv5YLS0GC6Ydxm5mf9xHG6hQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:1181:b0:203:ae0e:6a21 with SMTP
 id gk1-20020a17090b118100b00203ae0e6a21mr694473pjb.0.1663781769726; Wed, 21
 Sep 2022 10:36:09 -0700 (PDT)
Date:   Wed, 21 Sep 2022 10:35:46 -0700
In-Reply-To: <20220921173546.2674386-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20220921173546.2674386-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220921173546.2674386-11-dmatlack@google.com>
Subject: [PATCH v3 10/10] KVM: x86/mmu: Rename __direct_map() to direct_map()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Peter Xu <peterx@redhat.com>
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
index 4ad70fa371df..a0b4bc3c9202 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3079,11 +3079,11 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
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
@@ -3092,7 +3092,7 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
 	}
 }
 
-static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+static int direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_shadow_walk_iterator it;
 	struct kvm_mmu_page *sp;
@@ -4265,7 +4265,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
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
2.37.3.998.g577e59143f-goog

