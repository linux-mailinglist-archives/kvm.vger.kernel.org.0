Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFFAA5F547F
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 14:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiJEMbr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 08:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiJEMbn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 08:31:43 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06CBE22502
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 05:31:41 -0700 (PDT)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1og3Yq-00GedN-8z; Wed, 05 Oct 2022 14:31:40 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=RMI/AG/i+xYOrQqKjORbLmuUiJo4b9WZPKI4QjCONKo=; b=geIeH8C/BB6Shxyk/QKPjI7EFe
        tnF49anZnOLxnvaax1sRWXH9REV+ccaZvWnJhhr3TNI5gCMatW7vFvRglMv/Gyetkn4wITKzdWuCD
        uIsH075AByuuck9x46gzta/nIGqzS4LmzdcoQYA8YxKI6kJzYdSlCcKuRqHYjLPHpU9PM5UcSjYC1
        k+VYB1TlZsKD+6gOE2w+QBOk6OJDJRjlsOa/EUzw9BGqtdI+ZZAvsBVhVScK6WcNJ+ldCFm14Vm0E
        iWJ9b6XKS/pk+kWg9lofzGkG9grEURYykynh0/CIXk8AZVyGIwHp242zUkcKxHhXNT/dtcG2pSuYj
        B2+5/y9A==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1og3Yp-0001Kk-To; Wed, 05 Oct 2022 14:31:40 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1og3YQ-0007vp-2F; Wed, 05 Oct 2022 14:31:14 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH v2 2/8] KVM: x86: Shorten gfn_to_pfn_cache function names
Date:   Wed,  5 Oct 2022 14:30:45 +0200
Message-Id: <20221005123051.895056-3-mhal@rbox.co>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221005123051.895056-1-mhal@rbox.co>
References: <YySujDJN2Wm3ivi/@google.com>
 <20221005123051.895056-1-mhal@rbox.co>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Formalize "gpc" as the acronym and use it in function names.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 arch/x86/kvm/x86.c       |  8 ++++----
 arch/x86/kvm/xen.c       | 29 ++++++++++++++---------------
 include/linux/kvm_host.h | 21 ++++++++++-----------
 virt/kvm/pfncache.c      | 20 ++++++++++----------
 4 files changed, 38 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 15032b7f0589..45136ce7185e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3020,12 +3020,12 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 	unsigned long flags;
 
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gfn_to_pfn_cache_check(v->kvm, gpc, gpc->gpa,
-					   offset + sizeof(*guest_hv_clock))) {
+	while (!kvm_gpc_check(v->kvm, gpc, gpc->gpa,
+			      offset + sizeof(*guest_hv_clock))) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
-		if (kvm_gfn_to_pfn_cache_refresh(v->kvm, gpc, gpc->gpa,
-						 offset + sizeof(*guest_hv_clock)))
+		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa,
+				    offset + sizeof(*guest_hv_clock)))
 			return;
 
 		read_lock_irqsave(&gpc->lock, flags);
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index cecf8299b187..361f77dc7a3d 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -218,15 +218,14 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 		user_len = sizeof(struct compat_vcpu_runstate_info);
 
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gfn_to_pfn_cache_check(v->kvm, gpc, gpc->gpa,
-					   user_len)) {
+	while (!kvm_gpc_check(v->kvm, gpc, gpc->gpa, user_len)) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
 		/* When invoked from kvm_sched_out() we cannot sleep */
 		if (state == RUNSTATE_runnable)
 			return;
 
-		if (kvm_gfn_to_pfn_cache_refresh(v->kvm, gpc, gpc->gpa, user_len))
+		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa, user_len))
 			return;
 
 		read_lock_irqsave(&gpc->lock, flags);
@@ -352,12 +351,12 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
 	 * little more honest about it.
 	 */
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gfn_to_pfn_cache_check(v->kvm, gpc, gpc->gpa,
-					   sizeof(struct vcpu_info))) {
+	while (!kvm_gpc_check(v->kvm, gpc, gpc->gpa,
+			      sizeof(struct vcpu_info))) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
-		if (kvm_gfn_to_pfn_cache_refresh(v->kvm, gpc, gpc->gpa,
-						 sizeof(struct vcpu_info)))
+		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa,
+				    sizeof(struct vcpu_info)))
 			return;
 
 		read_lock_irqsave(&gpc->lock, flags);
@@ -417,8 +416,8 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 		     sizeof_field(struct compat_vcpu_info, evtchn_upcall_pending));
 
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gfn_to_pfn_cache_check(v->kvm, gpc, gpc->gpa,
-					   sizeof(struct vcpu_info))) {
+	while (!kvm_gpc_check(v->kvm, gpc, gpc->gpa,
+			      sizeof(struct vcpu_info))) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
 		/*
@@ -432,8 +431,8 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 		if (in_atomic() || !task_is_running(current))
 			return 1;
 
-		if (kvm_gfn_to_pfn_cache_refresh(v->kvm, gpc, gpc->gpa,
-						 sizeof(struct vcpu_info))) {
+		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa,
+				    sizeof(struct vcpu_info))) {
 			/*
 			 * If this failed, userspace has screwed up the
 			 * vcpu_info mapping. No interrupts for you.
@@ -966,7 +965,7 @@ static bool wait_pending_event(struct kvm_vcpu *vcpu, int nr_ports,
 
 	read_lock_irqsave(&gpc->lock, flags);
 	idx = srcu_read_lock(&kvm->srcu);
-	if (!kvm_gfn_to_pfn_cache_check(kvm, gpc, gpc->gpa, PAGE_SIZE))
+	if (!kvm_gpc_check(kvm, gpc, gpc->gpa, PAGE_SIZE))
 		goto out_rcu;
 
 	ret = false;
@@ -1358,7 +1357,7 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 	idx = srcu_read_lock(&kvm->srcu);
 
 	read_lock_irqsave(&gpc->lock, flags);
-	if (!kvm_gfn_to_pfn_cache_check(kvm, gpc, gpc->gpa, PAGE_SIZE))
+	if (!kvm_gpc_check(kvm, gpc, gpc->gpa, PAGE_SIZE))
 		goto out_rcu;
 
 	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode) {
@@ -1392,7 +1391,7 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 		gpc = &vcpu->arch.xen.vcpu_info_cache;
 
 		read_lock_irqsave(&gpc->lock, flags);
-		if (!kvm_gfn_to_pfn_cache_check(kvm, gpc, gpc->gpa, sizeof(struct vcpu_info))) {
+		if (!kvm_gpc_check(kvm, gpc, gpc->gpa, sizeof(struct vcpu_info))) {
 			/*
 			 * Could not access the vcpu_info. Set the bit in-kernel
 			 * and prod the vCPU to deliver it for itself.
@@ -1490,7 +1489,7 @@ static int kvm_xen_set_evtchn(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 			break;
 
 		idx = srcu_read_lock(&kvm->srcu);
-		rc = kvm_gfn_to_pfn_cache_refresh(kvm, gpc, gpc->gpa, PAGE_SIZE);
+		rc = kvm_gpc_refresh(kvm, gpc, gpc->gpa, PAGE_SIZE);
 		srcu_read_unlock(&kvm->srcu, idx);
 	} while(!rc);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9fd67026d91a..f687e56c24bc 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1271,16 +1271,15 @@ void kvm_gpc_init(struct gfn_to_pfn_cache *gpc);
  *                 -EFAULT for an untranslatable guest physical address.
  *
  * This primes a gfn_to_pfn_cache and links it into the @kvm's list for
- * invalidations to be processed.  Callers are required to use
- * kvm_gfn_to_pfn_cache_check() to ensure that the cache is valid before
- * accessing the target page.
+ * invalidations to be processed.  Callers are required to use kvm_gpc_check()
+ * to ensure that the cache is valid before accessing the target page.
  */
 int kvm_gpc_activate(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 		     struct kvm_vcpu *vcpu, enum pfn_cache_usage usage,
 		     gpa_t gpa, unsigned long len);
 
 /**
- * kvm_gfn_to_pfn_cache_check - check validity of a gfn_to_pfn_cache.
+ * kvm_gpc_check - check validity of a gfn_to_pfn_cache.
  *
  * @kvm:	   pointer to kvm instance.
  * @gpc:	   struct gfn_to_pfn_cache object.
@@ -1297,11 +1296,11 @@ int kvm_gpc_activate(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
  * Callers in IN_GUEST_MODE may do so without locking, although they should
  * still hold a read lock on kvm->scru for the memslot checks.
  */
-bool kvm_gfn_to_pfn_cache_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
-				gpa_t gpa, unsigned long len);
+bool kvm_gpc_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa,
+		   unsigned long len);
 
 /**
- * kvm_gfn_to_pfn_cache_refresh - update a previously initialized cache.
+ * kvm_gpc_refresh - update a previously initialized cache.
  *
  * @kvm:	   pointer to kvm instance.
  * @gpc:	   struct gfn_to_pfn_cache object.
@@ -1318,11 +1317,11 @@ bool kvm_gfn_to_pfn_cache_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
  * still lock and check the cache status, as this function does not return
  * with the lock still held to permit access.
  */
-int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
-				 gpa_t gpa, unsigned long len);
+int kvm_gpc_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa,
+		    unsigned long len);
 
 /**
- * kvm_gfn_to_pfn_cache_unmap - temporarily unmap a gfn_to_pfn_cache.
+ * kvm_gpc_unmap - temporarily unmap a gfn_to_pfn_cache.
  *
  * @kvm:	   pointer to kvm instance.
  * @gpc:	   struct gfn_to_pfn_cache object.
@@ -1331,7 +1330,7 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
  * but at least the mapping from GPA to userspace HVA will remain cached
  * and can be reused on a subsequent refresh.
  */
-void kvm_gfn_to_pfn_cache_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc);
+void kvm_gpc_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc);
 
 /**
  * kvm_gpc_deactivate - deactivate and unlink a gfn_to_pfn_cache.
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 08f97cf97264..cc65fab0dbef 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -76,8 +76,8 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
 	}
 }
 
-bool kvm_gfn_to_pfn_cache_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
-				gpa_t gpa, unsigned long len)
+bool kvm_gpc_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa,
+		   unsigned long len)
 {
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 
@@ -93,7 +93,7 @@ bool kvm_gfn_to_pfn_cache_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 
 	return true;
 }
-EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_check);
+EXPORT_SYMBOL_GPL(kvm_gpc_check);
 
 static void gpc_unmap_khva(struct kvm *kvm, kvm_pfn_t pfn, void *khva)
 {
@@ -235,8 +235,8 @@ static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 	return -EFAULT;
 }
 
-int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
-				 gpa_t gpa, unsigned long len)
+int kvm_gpc_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa,
+		    unsigned long len)
 {
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 	unsigned long page_offset = gpa & ~PAGE_MASK;
@@ -317,9 +317,9 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_refresh);
+EXPORT_SYMBOL_GPL(kvm_gpc_refresh);
 
-void kvm_gfn_to_pfn_cache_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
+void kvm_gpc_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 {
 	void *old_khva;
 	kvm_pfn_t old_pfn;
@@ -344,7 +344,7 @@ void kvm_gfn_to_pfn_cache_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 
 	gpc_unmap_khva(kvm, old_pfn, old_khva);
 }
-EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_unmap);
+EXPORT_SYMBOL_GPL(kvm_gpc_unmap);
 
 void kvm_gpc_init(struct gfn_to_pfn_cache *gpc)
 {
@@ -372,7 +372,7 @@ int kvm_gpc_activate(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 		list_add(&gpc->list, &kvm->gpc_list);
 		spin_unlock(&kvm->gpc_lock);
 	}
-	return kvm_gfn_to_pfn_cache_refresh(kvm, gpc, gpa, len);
+	return kvm_gpc_refresh(kvm, gpc, gpa, len);
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_activate);
 
@@ -383,7 +383,7 @@ void kvm_gpc_deactivate(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 		list_del(&gpc->list);
 		spin_unlock(&kvm->gpc_lock);
 
-		kvm_gfn_to_pfn_cache_unmap(kvm, gpc);
+		kvm_gpc_unmap(kvm, gpc);
 		gpc->active = false;
 	}
 }
-- 
2.37.3

