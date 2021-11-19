Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB804579CB
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 00:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236255AbhKTAB0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 19:01:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236200AbhKTABQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 19:01:16 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9833C061574
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:13 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id n6-20020a17090a670600b001a9647fd1aaso7470576pjj.1
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ORkMQIzkhcuqBRx3eJca9p54z3P3WQQiypjtLzoh9Ww=;
        b=EVSF8l2vRT5ze/yOakhU3W87MjlMAJgeJZV3rU6oZltmiUFxh+DyzzmdvRvSSZAPns
         XY8l9R6BnQ64vMmHMDgW7+QAwDxuY32vGK9MHNB5n6ldmHSDpPkafoWTkpWp9aIUtgSP
         +/ywtXMjb6MXL2xKJYw2FTqOPuRv856TVe0gOHyl1TizlNGA/H3C8Dg8Gy6emBUy6Y4C
         ZRySLnuK43nsg843viqcB20kVaeU6NfVMvjljgso/5eWEYJEFD2enkl6TFuWNR46DQFI
         hYnVD9CwD+llCGwW7jq9cVs/nW/5eUtQwPcVh6U2H7dvsFedECBCxyBzlev6OJdR5TkY
         c2ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ORkMQIzkhcuqBRx3eJca9p54z3P3WQQiypjtLzoh9Ww=;
        b=WnAUu0+RTeZLigsI6dYnZIeA+XUeEkOjFHPZqCpC3Lznb+pg71imrqY5YnchqSN/ls
         3913zjExJ9njwJKLsaD5X/SOrlht32cniOXb4A/RT6Ty4ZU2xp4K1qRD/RsTGplyBF+3
         mRY2sVmFHQaRyFkei6hAZ/k3DdOCeTWkXezC1XMdMU58Z5mIvlgDKflBfZ122eDTUH55
         dry9gpZU9jMR00N0tGvKcPiyl1u4wWj+GitA7HbIQW+AnVbjiPX3JaqvpNaeSDjXXcqx
         YJI5N9WF/DOyFc1zQVytaOK6dWXMGvaF/W8wi0ulx88HSjp64KEoaDZri0adFFzwlB/H
         FcsA==
X-Gm-Message-State: AOAM531RO4wuJ+WV6c8AVauJDMSyJ+H/EeV4PciiCkspEJaWznULKSTA
        sm3+UA76EvpJ+YolO2B5LY0j2TA85jlywg==
X-Google-Smtp-Source: ABdhPJxLdz2EWalCLqpJuTxAPY1Jh19P8TYAALRiU2AkUb/W0TGkkeemjFitnuvBcRG+X388eZUBcbtHyAR2uw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:a8e:b0:47b:a658:7f4d with SMTP
 id b14-20020a056a000a8e00b0047ba6587f4dmr67288414pfl.82.1637366293339; Fri,
 19 Nov 2021 15:58:13 -0800 (PST)
Date:   Fri, 19 Nov 2021 23:57:46 +0000
In-Reply-To: <20211119235759.1304274-1-dmatlack@google.com>
Message-Id: <20211119235759.1304274-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [RFC PATCH 02/15] KVM: x86/mmu: Rename __rmap_write_protect to rmap_write_protect
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that rmap_write_protect has been renamed, there is no need for the
double underscores in front of __rmap_write_protect.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 16ffb571bc75..1146f87044a6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1235,9 +1235,9 @@ static bool spte_write_protect(u64 *sptep, bool pt_protect)
 	return mmu_spte_update(sptep, spte);
 }
 
-static bool __rmap_write_protect(struct kvm *kvm,
-				 struct kvm_rmap_head *rmap_head,
-				 bool pt_protect)
+static bool rmap_write_protect(struct kvm *kvm,
+			       struct kvm_rmap_head *rmap_head,
+			       bool pt_protect)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
@@ -1317,7 +1317,7 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 	while (mask) {
 		rmap_head = gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
 					PG_LEVEL_4K, slot);
-		__rmap_write_protect(kvm, rmap_head, false);
+		rmap_write_protect(kvm, rmap_head, false);
 
 		/* clear the first set bit */
 		mask &= mask - 1;
@@ -1416,7 +1416,7 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 	if (kvm_memslots_have_rmaps(kvm)) {
 		for (i = min_level; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
 			rmap_head = gfn_to_rmap(gfn, i, slot);
-			write_protected |= __rmap_write_protect(kvm, rmap_head, true);
+			write_protected |= rmap_write_protect(kvm, rmap_head, true);
 		}
 	}
 
@@ -5780,7 +5780,7 @@ static bool slot_rmap_write_protect(struct kvm *kvm,
 				    struct kvm_rmap_head *rmap_head,
 				    const struct kvm_memory_slot *slot)
 {
-	return __rmap_write_protect(kvm, rmap_head, false);
+	return rmap_write_protect(kvm, rmap_head, false);
 }
 
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
-- 
2.34.0.rc2.393.gf8c9666880-goog

