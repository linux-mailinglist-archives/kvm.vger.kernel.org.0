Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93D3B6AD1C8
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 23:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjCFWlo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 17:41:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbjCFWlm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 17:41:42 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF23474A7C
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 14:41:36 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id w3-20020aa78583000000b005d244af158eso6231304pfn.23
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 14:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678142496;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E+fxwShkDb5dHF5T9HzQ/pz1bAD+wZheF6ykQqafhXc=;
        b=OrT0FbrKs4ORTv+USpAB4br2OHaiXGJPuCIu32oANDtvkADWxFu017TG+z3EbDOtvl
         4hhpn8AqRw1PQSkDkKbtFWzI7u3Ggk+B9pDVkPdmv2yW46Vx5ubJAeOfUVlWynI2vOxS
         L7foA1Mg6kS3VA02GkEFb+4DOSz948VkKrUa2pXZL1A3fCDSM8SA6mYFrprKVF5k/5ur
         NDCnxTBSC8mT6IDHRHsZdqfPCWHb4QcsVpt70nMn1jpF6h+M2bzp8LZ0ovO2vRoC/R3I
         Vg6qo8wKPNl0+1FQz8QTta7wSwoDIDIkWEoFrcY7T+YadXbJo2TtWfvc2JBPYUXjBFWf
         +Cmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678142496;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E+fxwShkDb5dHF5T9HzQ/pz1bAD+wZheF6ykQqafhXc=;
        b=sEe1QGMY7bgJgQUUoF5RlmurtMmqDJkANc10d1N4mcge6A72c9GVDANOeW6H6bOf/R
         fcMVxE17GMOwk7ob/uqcml6spkLRIXTqG/4TqeFZfr0/cipyds2Pvlw0wf1R8Nvaljtn
         KcituxugNIxgKtpbXA1XJibTa3trnQ/dPoIpRRwcYSwhxAE67xzjU3htx+OC65QiNAPF
         lLYFM3E5E72KZT3pmG6fiZZ5XC7SoxFSUXtf0BhXKOqZcBBzXqj8yeSEAtf9ajZCOTzH
         SyK+Je4J/3b9lSfMmHErPWoI4nisK5j6KmhY8ehtfhmzwFClC+uFoWC+KwRzn83Et8ln
         DCBQ==
X-Gm-Message-State: AO0yUKUKYknmD4lePJpD57ioOE2poPj/UXI/pIHEc0WDtgcVm6hTct6V
        qk3npSw3ofkso3jGVtg/8JGfj/xH0CcT
X-Google-Smtp-Source: AK7set8ARylYbd7dbgJM8WSkxYuSrTEawhfqFWJ/XQcVF1DdaaAV06Zg3oM2HeGunLdmf9/CQUhPTAUf23li
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a63:7e1c:0:b0:507:2c49:806d with SMTP id
 z28-20020a637e1c000000b005072c49806dmr3140509pgc.4.1678142496180; Mon, 06 Mar
 2023 14:41:36 -0800 (PST)
Date:   Mon,  6 Mar 2023 14:41:10 -0800
In-Reply-To: <20230306224127.1689967-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20230306224127.1689967-1-vipinsh@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230306224127.1689967-2-vipinsh@google.com>
Subject: [Patch v4 01/18] KVM: x86/mmu: Change KVM mmu shrinker to no-op
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com
Cc:     jmattson@google.com, mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
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

Remove page zapping logic from the shrinker. Keep shrinker
infrastructure in place, it will be reused in future commits to free KVM
page caches.

mmu_shrink_scan() is very disruptive to VMs. It picks the first VM in
the vm_list, zaps the oldest page which is most likely an upper level
SPTEs and most like to be reused. Prior to TDP MMU, this is even more
disruptive in nested VMs case, considering L1 SPTEs will be the oldest
even though most of the entries are for L2 SPTEs.

As discussed in
https://lore.kernel.org/lkml/Y45dldZnI6OIf+a5@google.com/ shrinker logic
has not be very useful in actually keeping VMs performant and reducing
memory usage.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 87 +++---------------------------------------
 1 file changed, 5 insertions(+), 82 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c8ebe542c565..0d07767f7922 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -166,7 +166,6 @@ struct kvm_shadow_walk_iterator {
 
 static struct kmem_cache *pte_list_desc_cache;
 struct kmem_cache *mmu_page_header_cache;
-static struct percpu_counter kvm_total_used_mmu_pages;
 
 static void mmu_spte_set(u64 *sptep, u64 spte);
 
@@ -1704,27 +1703,15 @@ static int is_empty_shadow_page(u64 *spt)
 }
 #endif
 
-/*
- * This value is the sum of all of the kvm instances's
- * kvm->arch.n_used_mmu_pages values.  We need a global,
- * aggregate version in order to make the slab shrinker
- * faster
- */
-static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
-{
-	kvm->arch.n_used_mmu_pages += nr;
-	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
-}
-
 static void kvm_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-	kvm_mod_used_mmu_pages(kvm, +1);
+	kvm->arch.n_used_mmu_pages++;
 	kvm_account_pgtable_pages((void *)sp->spt, +1);
 }
 
 static void kvm_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-	kvm_mod_used_mmu_pages(kvm, -1);
+	kvm->arch.n_used_mmu_pages--;
 	kvm_account_pgtable_pages((void *)sp->spt, -1);
 }
 
@@ -6072,11 +6059,6 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 		kvm_tdp_mmu_zap_invalidated_roots(kvm);
 }
 
-static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
-{
-	return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
-}
-
 static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
 			struct kvm_memory_slot *slot,
 			struct kvm_page_track_notifier_node *node)
@@ -6666,66 +6648,13 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
 static unsigned long
 mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
-	struct kvm *kvm;
-	int nr_to_scan = sc->nr_to_scan;
-	unsigned long freed = 0;
-
-	mutex_lock(&kvm_lock);
-
-	list_for_each_entry(kvm, &vm_list, vm_list) {
-		int idx;
-		LIST_HEAD(invalid_list);
-
-		/*
-		 * Never scan more than sc->nr_to_scan VM instances.
-		 * Will not hit this condition practically since we do not try
-		 * to shrink more than one VM and it is very unlikely to see
-		 * !n_used_mmu_pages so many times.
-		 */
-		if (!nr_to_scan--)
-			break;
-		/*
-		 * n_used_mmu_pages is accessed without holding kvm->mmu_lock
-		 * here. We may skip a VM instance errorneosly, but we do not
-		 * want to shrink a VM that only started to populate its MMU
-		 * anyway.
-		 */
-		if (!kvm->arch.n_used_mmu_pages &&
-		    !kvm_has_zapped_obsolete_pages(kvm))
-			continue;
-
-		idx = srcu_read_lock(&kvm->srcu);
-		write_lock(&kvm->mmu_lock);
-
-		if (kvm_has_zapped_obsolete_pages(kvm)) {
-			kvm_mmu_commit_zap_page(kvm,
-			      &kvm->arch.zapped_obsolete_pages);
-			goto unlock;
-		}
-
-		freed = kvm_mmu_zap_oldest_mmu_pages(kvm, sc->nr_to_scan);
-
-unlock:
-		write_unlock(&kvm->mmu_lock);
-		srcu_read_unlock(&kvm->srcu, idx);
-
-		/*
-		 * unfair on small ones
-		 * per-vm shrinkers cry out
-		 * sadness comes quickly
-		 */
-		list_move_tail(&kvm->vm_list, &vm_list);
-		break;
-	}
-
-	mutex_unlock(&kvm_lock);
-	return freed;
+	return SHRINK_STOP;
 }
 
 static unsigned long
 mmu_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
 {
-	return percpu_counter_read_positive(&kvm_total_used_mmu_pages);
+	return SHRINK_EMPTY;
 }
 
 static struct shrinker mmu_shrinker = {
@@ -6840,17 +6769,12 @@ int kvm_mmu_vendor_module_init(void)
 	if (!mmu_page_header_cache)
 		goto out;
 
-	if (percpu_counter_init(&kvm_total_used_mmu_pages, 0, GFP_KERNEL))
-		goto out;
-
 	ret = register_shrinker(&mmu_shrinker, "x86-mmu");
 	if (ret)
-		goto out_shrinker;
+		goto out;
 
 	return 0;
 
-out_shrinker:
-	percpu_counter_destroy(&kvm_total_used_mmu_pages);
 out:
 	mmu_destroy_caches();
 	return ret;
@@ -6867,7 +6791,6 @@ void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 void kvm_mmu_vendor_module_exit(void)
 {
 	mmu_destroy_caches();
-	percpu_counter_destroy(&kvm_total_used_mmu_pages);
 	unregister_shrinker(&mmu_shrinker);
 }
 
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

