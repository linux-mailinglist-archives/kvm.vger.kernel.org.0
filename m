Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01BBC570FC5
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 03:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbiGLB4L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 21:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232081AbiGLB4H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 21:56:07 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCA93D5BA
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 18:56:07 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id g67-20020a636b46000000b0040e64eee874so2609198pgc.4
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 18:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=UMTmbKNVtvYEiz66mHbd+juViopDmYcWF5zxIfoz7rg=;
        b=m8hXvaMknJpczY/qlVucKqde8IXT7SnMcrN79wSiIv75dBOi83l3/D1g39dHHlGT24
         bnqm6JK4gMYtdq1AqLIsEzgNf6rCSGJy5JChZ4GpiFbyRus4w3x0njdzrK1envtpwDMF
         r6/hsqNPBe77XfFMnSCmyr5/NX1DduwWTC19vpjXY8rIctcwf0VKuODgigRk9tQMwBct
         +sDIQGgE+MX6MU9rwvpmMXRnDrlMxPpE6KVqejEKzyp3V9sWs2S67nMFBeuC5JxHhfVT
         lCWdeD8v0TI5zknqK5NGG/CISkNLMaAE52Y4GfRA9lytEengHExCqeL3YUtscfjzRSnG
         CISw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=UMTmbKNVtvYEiz66mHbd+juViopDmYcWF5zxIfoz7rg=;
        b=G3lketcAf1U7MOL6XanVqNqtI1UJAzbFJzSdYd7h2le25olC8BmdiCTU9+hQ/GIwme
         lo6RXOASKLD0bSpIC7XnwiHCnbuF2r29+sIx0KwOalcaecRJ/yPaYJTol5oLvHsWh865
         v3+u3XXvdFOddJcqPUijOZFwjC5IIFMyzZWwGk+qUJryeyce4pNrsT9EDhfptFU4hH3Q
         lbiC+WUEN11GQ19aOEUVwd1fbjVpvnZevdVbIWYhnOYdYbiHzGw/w5W1PglFzxKS7KbK
         xfZCaeiALKotaJyAnj5Wv1UavC+wdjfhan2pA/IwnAkNh5FJ7VKwJ4v6ISt520yvfn9G
         2u1g==
X-Gm-Message-State: AJIora+CfKddX3qGTNusGlfa6WbS8op04ntsyTZg7U2cyZ+EHHCqMQ4h
        aAadbynKgSIlBAn8ViIc20FIY7Co+GE=
X-Google-Smtp-Source: AGRyM1seuEp30SuB5d8qo63MlDqAeQhdTRgCoYP/EYKVGCm9ECIbuTx128l91aynk+iR230jzOx9aODUxQY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:b513:0:b0:52a:af7f:c6e3 with SMTP id
 y19-20020a62b513000000b0052aaf7fc6e3mr21158910pfe.34.1657590966878; Mon, 11
 Jul 2022 18:56:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 12 Jul 2022 01:55:56 +0000
In-Reply-To: <20220712015558.1247978-1-seanjc@google.com>
Message-Id: <20220712015558.1247978-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220712015558.1247978-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH 3/5] KVM: x86/mmu: Remove underscores from __pte_list_remove()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

Remove the underscores from __pte_list_remove(), the function formerly
known as pte_list_remove() is now named ____kvm_zap_rmaps() to show that
it zaps rmaps/PTEs, i.e. doesn't just remove an entry from a list.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 32f9427f3334..fbe808bb0ce1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -921,7 +921,7 @@ pte_list_desc_remove_entry(struct kvm_rmap_head *rmap_head,
 	mmu_free_pte_list_desc(desc);
 }
 
-static void __pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
+static void pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
 {
 	struct pte_list_desc *desc;
 	struct pte_list_desc *prev_desc;
@@ -961,7 +961,7 @@ static void kvm_zap_one_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 			     u64 *sptep)
 {
 	mmu_spte_clear_track_bits(kvm, sptep);
-	__pte_list_remove(sptep, rmap_head);
+	pte_list_remove(sptep, rmap_head);
 }
 
 /* Return true if at least one rmap was zapped, false otherwise */
@@ -1050,7 +1050,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	slot = __gfn_to_memslot(slots, gfn);
 	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
 
-	__pte_list_remove(spte, rmap_head);
+	pte_list_remove(spte, rmap_head);
 }
 
 /*
@@ -1692,7 +1692,7 @@ static void mmu_page_add_parent_pte(struct kvm_mmu_memory_cache *cache,
 static void mmu_page_remove_parent_pte(struct kvm_mmu_page *sp,
 				       u64 *parent_pte)
 {
-	__pte_list_remove(parent_pte, &sp->parent_ptes);
+	pte_list_remove(parent_pte, &sp->parent_ptes);
 }
 
 static void drop_parent_pte(struct kvm_mmu_page *sp,
-- 
2.37.0.144.g8ac04bfd2-goog

