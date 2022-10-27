Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB92060FCE5
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 18:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236696AbiJ0QTg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 12:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236570AbiJ0QTB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 12:19:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33BCC196B64
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 09:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666887536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pocYbtNwQ3MvVypXtGO80iv68zGgKlOFCP+Ib8XwyNc=;
        b=UEl3JxJ0TUextNvUqudF4EhKYs0Cz5SNRfzwZ4sZ+AlFpbhSW3Mp4tdIIElqojl7t1jnFA
        10kU2QTc1+TxR4OHsT2eQvhF6+XcPCocyeEV/L1ci2XIHm41+VBMoObvCdeC3OVsAB2gWl
        W2RHZcDiHrOldiWtQW6MYtco3Q+/OsQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-425-kQDA980AMI6vgn4Chz07YQ-1; Thu, 27 Oct 2022 12:18:52 -0400
X-MC-Unique: kQDA980AMI6vgn4Chz07YQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C43A85A5A6;
        Thu, 27 Oct 2022 16:18:51 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA00D1415117;
        Thu, 27 Oct 2022 16:18:50 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mhal@rbox.co, seanjc@google.com
Subject: [PATCH 04/16] KVM: Shorten gfn_to_pfn_cache function names
Date:   Thu, 27 Oct 2022 12:18:37 -0400
Message-Id: <20221027161849.2989332-5-pbonzini@redhat.com>
In-Reply-To: <20221027161849.2989332-1-pbonzini@redhat.com>
References: <20221027161849.2989332-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michal Luczaj <mhal@rbox.co>

Formalize "gpc" as the acronym and use it in function names.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20221013211234.1318131-5-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c       |  8 ++++----
 arch/x86/kvm/xen.c       | 29 ++++++++++++++---------------
 include/linux/kvm_host.h | 21 ++++++++++-----------
 virt/kvm/pfncache.c      | 20 ++++++++++----------
 4 files changed, 38 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 521b433f978c..5e5c546cba66 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3034,12 +3034,12 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
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
index 512b4afa6785..5ea8f82d60b1 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -245,15 +245,14 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 
 	user_len = kvm_xen_runstate_info_size(v->kvm);
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
@@ -379,12 +378,12 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
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
@@ -444,8 +443,8 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 		     sizeof_field(struct compat_vcpu_info, evtchn_upcall_pending));
 
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gfn_to_pfn_cache_check(v->kvm, gpc, gpc->gpa,
-					   sizeof(struct vcpu_info))) {
+	while (!kvm_gpc_check(v->kvm, gpc, gpc->gpa,
+			      sizeof(struct vcpu_info))) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
 		/*
@@ -459,8 +458,8 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 		if (in_atomic() || !task_is_running(current))
 			return 1;
 
-		if (kvm_gfn_to_pfn_cache_refresh(v->kvm, gpc, gpc->gpa,
-						 sizeof(struct vcpu_info))) {
+		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa,
+				    sizeof(struct vcpu_info))) {
 			/*
 			 * If this failed, userspace has screwed up the
 			 * vcpu_info mapping. No interrupts for you.
@@ -995,7 +994,7 @@ static bool wait_pending_event(struct kvm_vcpu *vcpu, int nr_ports,
 
 	read_lock_irqsave(&gpc->lock, flags);
 	idx = srcu_read_lock(&kvm->srcu);
-	if (!kvm_gfn_to_pfn_cache_check(kvm, gpc, gpc->gpa, PAGE_SIZE))
+	if (!kvm_gpc_check(kvm, gpc, gpc->gpa, PAGE_SIZE))
 		goto out_rcu;
 
 	ret = false;
@@ -1386,7 +1385,7 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 	idx = srcu_read_lock(&kvm->srcu);
 
 	read_lock_irqsave(&gpc->lock, flags);
-	if (!kvm_gfn_to_pfn_cache_check(kvm, gpc, gpc->gpa, PAGE_SIZE))
+	if (!kvm_gpc_check(kvm, gpc, gpc->gpa, PAGE_SIZE))
 		goto out_rcu;
 
 	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode) {
@@ -1420,7 +1419,7 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 		gpc = &vcpu->arch.xen.vcpu_info_cache;
 
 		read_lock_irqsave(&gpc->lock, flags);
-		if (!kvm_gfn_to_pfn_cache_check(kvm, gpc, gpc->gpa, sizeof(struct vcpu_info))) {
+		if (!kvm_gpc_check(kvm, gpc, gpc->gpa, sizeof(struct vcpu_info))) {
 			/*
 			 * Could not access the vcpu_info. Set the bit in-kernel
 			 * and prod the vCPU to deliver it for itself.
@@ -1518,7 +1517,7 @@ static int kvm_xen_set_evtchn(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 			break;
 
 		idx = srcu_read_lock(&kvm->srcu);
-		rc = kvm_gfn_to_pfn_cache_refresh(kvm, gpc, gpc->gpa, PAGE_SIZE);
+		rc = kvm_gpc_refresh(kvm, gpc, gpc->gpa, PAGE_SIZE);
 		srcu_read_unlock(&kvm->srcu, idx);
 	} while(!rc);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 18592bdf4c1b..4dc6571c832f 100644
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
index 346e47f15572..23180f1d9c1c 100644
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
 
@@ -96,7 +96,7 @@ bool kvm_gfn_to_pfn_cache_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 
 	return true;
 }
-EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_check);
+EXPORT_SYMBOL_GPL(kvm_gpc_check);
 
 static void gpc_unmap_khva(struct kvm *kvm, kvm_pfn_t pfn, void *khva)
 {
@@ -238,8 +238,8 @@ static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 	return -EFAULT;
 }
 
-int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
-				 gpa_t gpa, unsigned long len)
+int kvm_gpc_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa,
+		    unsigned long len)
 {
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 	unsigned long page_offset = gpa & ~PAGE_MASK;
@@ -328,9 +328,9 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_refresh);
+EXPORT_SYMBOL_GPL(kvm_gpc_refresh);
 
-void kvm_gfn_to_pfn_cache_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
+void kvm_gpc_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 {
 	void *old_khva;
 	kvm_pfn_t old_pfn;
@@ -355,7 +355,7 @@ void kvm_gfn_to_pfn_cache_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 
 	gpc_unmap_khva(kvm, old_pfn, old_khva);
 }
-EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_unmap);
+EXPORT_SYMBOL_GPL(kvm_gpc_unmap);
 
 void kvm_gpc_init(struct gfn_to_pfn_cache *gpc)
 {
@@ -391,7 +391,7 @@ int kvm_gpc_activate(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 		gpc->active = true;
 		write_unlock_irq(&gpc->lock);
 	}
-	return kvm_gfn_to_pfn_cache_refresh(kvm, gpc, gpa, len);
+	return kvm_gpc_refresh(kvm, gpc, gpa, len);
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_activate);
 
@@ -411,7 +411,7 @@ void kvm_gpc_deactivate(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 		list_del(&gpc->list);
 		spin_unlock(&kvm->gpc_lock);
 
-		kvm_gfn_to_pfn_cache_unmap(kvm, gpc);
+		kvm_gpc_unmap(kvm, gpc);
 	}
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_deactivate);
-- 
2.31.1


