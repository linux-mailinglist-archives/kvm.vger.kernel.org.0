Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7590A5FE3F7
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 23:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiJMVN2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 17:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiJMVNT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 17:13:19 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E221191D65
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 14:13:09 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id y18-20020a056a00181200b00565b27c2611so1768999pfa.14
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 14:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ZCYCVjmO2J72H0KFHJBSx9/YTLGBB6hsk4zZ8ILpai0=;
        b=BAJw0IF60pdsbuWPNmAB32su9AuL606MvSCrJ0kCG9QXn5CbIWEGqPpRHejSajjH9X
         VQXsslI/2hycC9eGhoX+Kp/GSiQXYxrZZvrdD3V4uJH8e7qeHpiegAxgd8Mv5iXNRFzY
         Gbwnbzbips8KTUvCTR1u068vE3OE3rK4qtaVtlW7+RV71nJiEUIHMbK/MVOEQt8afEuM
         0As8jmxorDCqpNDFublPhw39vixQLAh0b1DBIIk9Zd6/sZfXQ/tu5HPSp8k3yzO2tgPy
         jq8OUIFNk9+WAmTpB5/tCO+k2xaqNDEVoelle/75tyEb661C7vy2+wfzjiwEtjhiUFDE
         RSIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZCYCVjmO2J72H0KFHJBSx9/YTLGBB6hsk4zZ8ILpai0=;
        b=Y2YLL6H7W4WIugnGPm5ZmESMBBQQ8GRIb+t2kj8OE4jllr/qaPFAwxqLKS82X7vipY
         koijezStOBFgIBsi5O8VVqQLgDY6NuyBHlpUO78QFHZQWGe27zu7SZifXtDuBfvGKduF
         IzHwRDjI8XUuLiyOb1V2MGu4oEs17h+F0WvFX4zDOlY40j6WsaBVq4+2UI7+T+V/Yfgj
         WgJAiEull7iJyqIkmiiU+XhdM+ToqQ71cnsoVNQ+HNM8OufA6LLja7nJHbo41C4T4K4m
         5yi7KpVmlBVzqRZJKrv3ETx5RioRzNgzm6JoyBtKVnFoitPc02LGQ+CW6jlT/aQxLmFK
         nYlg==
X-Gm-Message-State: ACrzQf3EFW99JC3xuhX7puAdzrSFw0XmCCSdjJzZMlJWAcVzDNIfdVQQ
        ijt0+hKaMo+VyXmv8cWSKdASnlC+AsI=
X-Google-Smtp-Source: AMsMyM6gx+vDFWbDdQGIunEB0MXJrMfMZ6n/GycVSLwOykukLHA2lD8p/fsMb+tYz8smiS8IcfhQO+wwI7M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:234d:b0:561:ec04:e77e with SMTP id
 j13-20020a056a00234d00b00561ec04e77emr1527327pfj.14.1665695565830; Thu, 13
 Oct 2022 14:12:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 13 Oct 2022 21:12:22 +0000
In-Reply-To: <20221013211234.1318131-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221013211234.1318131-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221013211234.1318131-5-seanjc@google.com>
Subject: [PATCH v2 04/16] KVM: Shorten gfn_to_pfn_cache function names
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>,
        David Woodhouse <dwmw2@infradead.org>
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

From: Michal Luczaj <mhal@rbox.co>

Formalize "gpc" as the acronym and use it in function names.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c       |  8 ++++----
 arch/x86/kvm/xen.c       | 29 ++++++++++++++---------------
 include/linux/kvm_host.h | 21 ++++++++++-----------
 virt/kvm/pfncache.c      | 20 ++++++++++----------
 4 files changed, 38 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 943f039564e7..fd00e6a33203 100644
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
index 9e79ef2cca99..74d9f4985f93 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -215,15 +215,14 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 	user_len = sizeof(struct vcpu_runstate_info);
 
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
@@ -349,12 +348,12 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
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
@@ -414,8 +413,8 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 		     sizeof_field(struct compat_vcpu_info, evtchn_upcall_pending));
 
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gfn_to_pfn_cache_check(v->kvm, gpc, gpc->gpa,
-					   sizeof(struct vcpu_info))) {
+	while (!kvm_gpc_check(v->kvm, gpc, gpc->gpa,
+			      sizeof(struct vcpu_info))) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
 		/*
@@ -429,8 +428,8 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 		if (in_atomic() || !task_is_running(current))
 			return 1;
 
-		if (kvm_gfn_to_pfn_cache_refresh(v->kvm, gpc, gpc->gpa,
-						 sizeof(struct vcpu_info))) {
+		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa,
+				    sizeof(struct vcpu_info))) {
 			/*
 			 * If this failed, userspace has screwed up the
 			 * vcpu_info mapping. No interrupts for you.
@@ -963,7 +962,7 @@ static bool wait_pending_event(struct kvm_vcpu *vcpu, int nr_ports,
 
 	read_lock_irqsave(&gpc->lock, flags);
 	idx = srcu_read_lock(&kvm->srcu);
-	if (!kvm_gfn_to_pfn_cache_check(kvm, gpc, gpc->gpa, PAGE_SIZE))
+	if (!kvm_gpc_check(kvm, gpc, gpc->gpa, PAGE_SIZE))
 		goto out_rcu;
 
 	ret = false;
@@ -1354,7 +1353,7 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 	idx = srcu_read_lock(&kvm->srcu);
 
 	read_lock_irqsave(&gpc->lock, flags);
-	if (!kvm_gfn_to_pfn_cache_check(kvm, gpc, gpc->gpa, PAGE_SIZE))
+	if (!kvm_gpc_check(kvm, gpc, gpc->gpa, PAGE_SIZE))
 		goto out_rcu;
 
 	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode) {
@@ -1388,7 +1387,7 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 		gpc = &vcpu->arch.xen.vcpu_info_cache;
 
 		read_lock_irqsave(&gpc->lock, flags);
-		if (!kvm_gfn_to_pfn_cache_check(kvm, gpc, gpc->gpa, sizeof(struct vcpu_info))) {
+		if (!kvm_gpc_check(kvm, gpc, gpc->gpa, sizeof(struct vcpu_info))) {
 			/*
 			 * Could not access the vcpu_info. Set the bit in-kernel
 			 * and prod the vCPU to deliver it for itself.
@@ -1486,7 +1485,7 @@ static int kvm_xen_set_evtchn(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 			break;
 
 		idx = srcu_read_lock(&kvm->srcu);
-		rc = kvm_gfn_to_pfn_cache_refresh(kvm, gpc, gpc->gpa, PAGE_SIZE);
+		rc = kvm_gpc_refresh(kvm, gpc, gpc->gpa, PAGE_SIZE);
 		srcu_read_unlock(&kvm->srcu, idx);
 	} while(!rc);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 694c4cb6caf4..bb020ee3b2fe 100644
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
2.38.0.413.g74048e4d9e-goog

