Return-Path: <kvm+bounces-1403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 896597E7600
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 01:38:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB5361C20E4B
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 00:38:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62ACD1363;
	Fri, 10 Nov 2023 00:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jjNNQZ+P"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C86ED7
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 00:37:53 +0000 (UTC)
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF17D5B
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 16:37:52 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-58b2d243b26so1461252a12.3
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 16:37:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699576672; x=1700181472; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MmdhHxYOwYMfkPZtp5/MExUn9IRIS6kfJX7juQnYJGA=;
        b=jjNNQZ+PVbqRGRg7kht5BeT1GN2dmJw90JlsztT1qIkD10yUFfKzrUvBaIq7MV8M2I
         O/cAwVj7boBePWyH4tJU2BEki72oA9FOaZDTJNRhIsD6TdSMQCRwhN1j4Y8Em0xohRT5
         M2WYqedjmJFb2G7voccZSzmXUqAeZqPy587/sREralID3PzCI8CbcBjwvfFvTNlrtB7/
         oAnwD5QEq07HQw74QCpIgpNIkeFdCGzoCFOVv7O5y6cDGIv+b0kIkoPGvbd7lTzCstAn
         ruBLzLvcQazu6FOCWsqB7kltm63f3XK+9nTdfBWhUSuQVh9mG30Vr9yUynNeUi1kGaec
         0VrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699576672; x=1700181472;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MmdhHxYOwYMfkPZtp5/MExUn9IRIS6kfJX7juQnYJGA=;
        b=oH3dJnvjO+r7KI3iVWOGc0WLVbSHjhaJgVqD6lBqgA0iQEae3Nq6tWp4XdnViaDi9L
         332qg1KuCzoNW/Psju7vyBDZO4Krn4xMyYuH0YRZ7mCA7CnlzJOhX2G8Ff1dp+CDuaGh
         odqrppsLRJEtcDVcWJvlWeq8vwe8TMBqI2I1rH8zdbgrHAd69YSmuirT3fiNP0CAr4Jt
         Qc0dCsz2duM3p/D0zlqcJEZSNQPDrLP4cEOJI36/15HxYP6eg1qQQL/E1ML8891OYjYf
         GYmnOTZu29wsvJL6r5yk+occ8oUuzaMtPy/PXDFfJSLP5256fqKaeFKIfxgPUUqzrXwK
         V2SA==
X-Gm-Message-State: AOJu0YyRLkx3eJtLPRgm4LMS3l/V5dweqHTLeQh/EmA21+e+kJbXaQGt
	a/X4LNEwqAeMi95BNJEu+1JCea9MHSo=
X-Google-Smtp-Source: AGHT+IHCxa2Scy55p9xB8J4kEEqS7G44HHxZ6Nt8HLohdRy26Y3g1geBScIePcJ+T26SUPsIlSKRAYE8IEFK
X-Received: from jackyli.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3b51])
 (user=jackyli job=sendgmr) by 2002:a63:fc0e:0:b0:5b9:63f2:e4cc with SMTP id
 j14-20020a63fc0e000000b005b963f2e4ccmr798913pgi.2.1699576672296; Thu, 09 Nov
 2023 16:37:52 -0800 (PST)
Date: Fri, 10 Nov 2023 00:37:32 +0000
In-Reply-To: <20231110003734.1014084-1-jackyli@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110003734.1014084-1-jackyli@google.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
Message-ID: <20231110003734.1014084-3-jackyli@google.com>
Subject: [RFC PATCH 2/4] KVM: SEV: Plumb mmu_notifier_event into sev function
From: Jacky Li <jackyli@google.com>
To: Sean Christpherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Ovidiu Panait <ovidiu.panait@windriver.com>, Liam Merwick <liam.merwick@oracle.com>, 
	Ashish Kalra <Ashish.Kalra@amd.com>, David Rientjes <rientjes@google.com>, 
	David Kaplan <david.kaplan@amd.com>, Peter Gonda <pgonda@google.com>, 
	Mingwei Zhang <mizhang@google.com>, kvm@vger.kernel.org, Jacky Li <jackyli@google.com>
Content-Type: text/plain; charset="UTF-8"

Plumb mmu_notifier_event enum all the way to sev function so that the
enum can provide proper information for SEV/SEV-ES VMs to do the cache
flush when necessary.

Signed-off-by: Jacky Li <jackyli@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/svm/sev.c          |  3 ++-
 arch/x86/kvm/svm/svm.h          |  3 ++-
 arch/x86/kvm/x86.c              |  5 +++--
 include/linux/kvm_host.h        |  3 ++-
 virt/kvm/kvm_main.c             | 14 +++++++++-----
 6 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d7036982332e..c026e171a8c8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1741,7 +1741,8 @@ struct kvm_x86_ops {
 	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
 	int (*vm_move_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
-	void (*guest_memory_reclaimed)(struct kvm *kvm);
+	void (*guest_memory_reclaimed)(struct kvm *kvm,
+				       unsigned int mmu_notifier_event);
 
 	int (*get_msr_feature)(struct kvm_msr_entry *entry);
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7fbcb7dea2c0..8d30f6c5e872 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2329,7 +2329,8 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
 	wbinvd_on_all_cpus();
 }
 
-void sev_guest_memory_reclaimed(struct kvm *kvm)
+void sev_guest_memory_reclaimed(struct kvm *kvm,
+				unsigned int mmu_notifier_event)
 {
 	if (!sev_guest(kvm))
 		return;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index be67ab7fdd10..c8a911a02509 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -676,7 +676,8 @@ int sev_mem_enc_unregister_region(struct kvm *kvm,
 				  struct kvm_enc_region *range);
 int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd);
 int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd);
-void sev_guest_memory_reclaimed(struct kvm *kvm);
+void sev_guest_memory_reclaimed(struct kvm *kvm,
+				unsigned int mmu_notifier_event);
 
 void pre_sev_run(struct vcpu_svm *svm, int cpu);
 void __init sev_set_cpu_caps(void);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2c924075f6f1..2cde9a836bf7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10592,9 +10592,10 @@ static void vcpu_load_eoi_exitmap(struct kvm_vcpu *vcpu)
 		vcpu, (u64 *)vcpu->arch.ioapic_handled_vectors);
 }
 
-void kvm_arch_guest_memory_reclaimed(struct kvm *kvm)
+void kvm_arch_guest_memory_reclaimed(struct kvm *kvm,
+				     unsigned int mmu_notifier_event)
 {
-	static_call_cond(kvm_x86_guest_memory_reclaimed)(kvm);
+	static_call_cond(kvm_x86_guest_memory_reclaimed)(kvm, mmu_notifier_event);
 }
 
 static void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4944136efaa2..8984414c5b7a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2270,7 +2270,8 @@ static inline long kvm_arch_vcpu_async_ioctl(struct file *filp,
 }
 #endif /* CONFIG_HAVE_KVM_VCPU_ASYNC_IOCTL */
 
-void kvm_arch_guest_memory_reclaimed(struct kvm *kvm);
+void kvm_arch_guest_memory_reclaimed(struct kvm *kvm,
+				     unsigned int mmu_notifier_event);
 
 #ifdef CONFIG_HAVE_KVM_VCPU_RUN_PID_CHANGE
 int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 486800a7024b..18526e198993 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -154,7 +154,8 @@ static unsigned long long kvm_active_vms;
 
 static DEFINE_PER_CPU(cpumask_var_t, cpu_kick_mask);
 
-__weak void kvm_arch_guest_memory_reclaimed(struct kvm *kvm)
+__weak void kvm_arch_guest_memory_reclaimed(struct kvm *kvm,
+					    unsigned int mmu_notifier_event)
 {
 }
 
@@ -396,7 +397,7 @@ void kvm_flush_remote_tlbs_memslot(struct kvm *kvm,
 static void kvm_flush_shadow_all(struct kvm *kvm)
 {
 	kvm_arch_flush_shadow_all(kvm);
-	kvm_arch_guest_memory_reclaimed(kvm);
+	kvm_arch_guest_memory_reclaimed(kvm, MMU_NOTIFY_RELEASE);
 }
 
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
@@ -546,11 +547,13 @@ typedef bool (*hva_handler_t)(struct kvm *kvm, struct kvm_gfn_range *range);
 typedef void (*on_lock_fn_t)(struct kvm *kvm, unsigned long start,
 			     unsigned long end);
 
-typedef void (*on_unlock_fn_t)(struct kvm *kvm);
+typedef void (*on_unlock_fn_t)(struct kvm *kvm,
+			       unsigned int mmu_notifier_event);
 
 struct kvm_hva_range {
 	unsigned long start;
 	unsigned long end;
+	unsigned int event;
 	union kvm_mmu_notifier_arg arg;
 	hva_handler_t handler;
 	on_lock_fn_t on_lock;
@@ -647,7 +650,7 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 	if (locked) {
 		KVM_MMU_UNLOCK(kvm);
 		if (!IS_KVM_NULL_FN(range->on_unlock))
-			range->on_unlock(kvm);
+			range->on_unlock(kvm, range->event);
 	}
 
 	srcu_read_unlock(&kvm->srcu, idx);
@@ -774,6 +777,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	const struct kvm_hva_range hva_range = {
 		.start		= range->start,
 		.end		= range->end,
+		.event		= range->event,
 		.handler	= kvm_unmap_gfn_range,
 		.on_lock	= kvm_mmu_invalidate_begin,
 		.on_unlock	= kvm_arch_guest_memory_reclaimed,
@@ -1769,7 +1773,7 @@ static void kvm_invalidate_memslot(struct kvm *kvm,
 	 *	- kvm_is_visible_gfn (mmu_check_root)
 	 */
 	kvm_arch_flush_shadow_memslot(kvm, old);
-	kvm_arch_guest_memory_reclaimed(kvm);
+	kvm_arch_guest_memory_reclaimed(kvm, MMU_NOTIFY_UNMAP);
 
 	/* Was released by kvm_swap_active_memslots(), reacquire. */
 	mutex_lock(&kvm->slots_arch_lock);
-- 
2.43.0.rc0.421.g78406f8d94-goog


