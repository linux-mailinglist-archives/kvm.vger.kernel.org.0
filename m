Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7EA8570FFA
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 04:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbiGLCHl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 22:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbiGLCHc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 22:07:32 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F557CB4F
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 19:07:31 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id y37-20020a056a001ca500b00528bbf82c1eso1605738pfw.10
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 19:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=wC4daWuN72ntGNvsqnVV6vq+bt1gw7NePoqDxLLGrS8=;
        b=CVfLrEPTwIaX/ki4UHYkP2ZYB4PdTx80sHad8DGQnCFvjKorZ6JfnaYRfzbWOIJvW2
         itUY2sdVixbqHdbUNb5j7uQy41tHY1uo4vwY590DpNkmxAyfP6T71U64XE0p6rGWRPOQ
         4zULpdTPLDYFSAHe/VMpzNp5llohVFJbfQ0d+HDFFlr8op2cZywsn81iw+nSBCDzAxmu
         yUKf9e3Zh+S0hmBwRzIRA6wH5eaLxpZGN7G2g1skjxWOxRxEChRb0GcasYGWdF5itqR9
         12CwWrVUW6QLDxrLrkDXRmgoK7wacQgV/NLz2Agxy0kIgSDFUko16nV+OJ5j3+h2O3Pv
         gjOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=wC4daWuN72ntGNvsqnVV6vq+bt1gw7NePoqDxLLGrS8=;
        b=QZk40YXKNjCj7HPOsFKBwtmU9ScvLEONOJK4yV50PUInscjKmGK5S4bf7EI/WZ2XlS
         dZ2eWzT4Of4EIPvNFOYvWOashFKl4jhvzw2JMGiL+3L9NiJc2Oc24wzp4UH74NvxoSaD
         Pe3RQcuQIAnffGyAC3s8A2BIa204nNUFZnVXUQqklrtl2V/m76k3zJoyeKQA8J5t2911
         WH8QMAHMQA9MrzcJ+t+AD4FT5akAj8XwbwUW07FLPibJ5A7TNJJxXKuElSe6SJzQvQez
         sycwGAargI3vpisCqGQH5F8SvrLqdvfXdyhuEw64wjwDVSAvsLD3GEmgzIhabySMQmRi
         GkWA==
X-Gm-Message-State: AJIora+JKMRP3GR/PfF9blNLWMPXlFd1EC4QLqZAnSfudH4TJg+WAbHL
        aVhmGDUEpLU+WsPXDqtcEOuvgRokd/g=
X-Google-Smtp-Source: AGRyM1tamDaouxIjsR84u7D+TdWg376mrBI9rco87Xf1xz5mM8bsjTYhZ9LZN+mcQ4ZJ0rEVThTJZqUAw5g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr40863pje.0.1657591651230; Mon, 11 Jul
 2022 19:07:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 12 Jul 2022 02:07:24 +0000
In-Reply-To: <20220712020724.1262121-1-seanjc@google.com>
Message-Id: <20220712020724.1262121-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220712020724.1262121-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH v3 3/3] KVM: x86/mmu: Fix typo and tweak comment for
 split_desc_cache capacity
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>
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

Remove a spurious closing paranthesis and tweak the comment about the
cache capacity for PTE descriptors (rmaps) eager page splitting to tone
down the assertion slightly, and to call out that topup requires dropping
mmu_lock, which is the real motivation for avoiding topup (as opposed to
memory usage).

Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7a65e57b9b41..52664c3caaab 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6125,14 +6125,15 @@ static int topup_split_caches(struct kvm *kvm)
 {
 	/*
 	 * Allocating rmap list entries when splitting huge pages for nested
-	 * MMUs is uncommon as KVM needs to allocate if and only if there is
+	 * MMUs is uncommon as KVM needs to use a list if and only if there is
 	 * more than one rmap entry for a gfn, i.e. requires an L1 gfn to be
-	 * aliased by multiple L2 gfns.  Aliasing gfns when using TDP is very
-	 * atypical for VMMs; a few gfns are often aliased during boot, e.g.
-	 * when remapping firmware, but aliasing rarely occurs post-boot).  If
-	 * there is only one rmap entry, rmap->val points directly at that one
-	 * entry and doesn't need to allocate a list.  Buffer the cache by the
-	 * default capacity so that KVM doesn't have to topup the cache if it
+	 * aliased by multiple L2 gfns and/or from multiple nested roots with
+	 * different roles.  Aliasing gfns when using TDP is atypical for VMMs;
+	 * a few gfns are often aliased during boot, e.g. when remapping BIOS,
+	 * but aliasing rarely occurs post-boot or for many gfns.  If there is
+	 * only one rmap entry, rmap->val points directly at that one entry and
+	 * doesn't need to allocate a list.  Buffer the cache by the default
+	 * capacity so that KVM doesn't have to drop mmu_lock to topup if KVM
 	 * encounters an aliased gfn or two.
 	 */
 	const int capacity = SPLIT_DESC_CACHE_MIN_NR_OBJECTS +
-- 
2.37.0.144.g8ac04bfd2-goog

