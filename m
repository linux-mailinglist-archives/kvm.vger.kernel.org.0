Return-Path: <kvm+bounces-16831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 071438BE44E
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 15:38:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D58A21C21348
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 13:38:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9187A15F412;
	Tue,  7 May 2024 13:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WBGz/PPr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8691635C0;
	Tue,  7 May 2024 13:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715088674; cv=none; b=JO0plv+2AZUBPHISnF6W172M3njE/y/sdFdua1aSSJhHXThYC+2ODhzZfBE3bxlKm8ZlV3MUkcwdYDceCSp7zj/9oF0R0GtG5B3ibDMVctf06x+prjRR4vofeWk++hMTryiU7jZAdP3wc7eGwT4WrO/ZmRcZeoeNrBNWBG4/BJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715088674; c=relaxed/simple;
	bh=tI5bfvMuyvwGZQzWYKlBWEDGkJUkHaG1SOQDdjqaZPE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ISBnlH0u672s60P3rWe9/3TQHfEZTcljJpkD3bhPbXjKaFHzSs4lLlIrmxr0qyTJmzzauQgHe6IwHy3AgD/826hAJxxEsSs1s68ujzKdQrwYZYEKnqLFPWawzmd5YCxooFVqDH5E6ojFv6dH1Sgi7W1vE0ucwEcnJmZAeTJSDA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WBGz/PPr; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715088672; x=1746624672;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tI5bfvMuyvwGZQzWYKlBWEDGkJUkHaG1SOQDdjqaZPE=;
  b=WBGz/PPrDNAx6eXFisiRO+NV1gNVTK+2K9C6hahDIgtOKbGUNqTWRGav
   zE5XrSG9zymB4JDf1+L296vzmtE7peH6qWjd+Eu0t5Bq+cGLv8NIYEpC+
   cmxHp74IuCuMnf2azOEtmwLkphLp5j+oPYjYMX6FXbJS/h7zbzsuiRQKi
   W6FEtneb8Aii5vVG06gCZfJ4tl1mM7zi1klK4Pl9U0LhE+PLIxue0lDTs
   LM4fh58K0lqYjloqC9L2bTQjK62MTHhnvlQS+tqW3K4nWP1nYBseaAJyQ
   pVRatYdpuiBzVzkv4ZAa+aE96BazyhRTewi95pXKS/LLmkDr86E7ADmgf
   w==;
X-CSE-ConnectionGUID: gizgSbQyQByvW7O+foM9JQ==
X-CSE-MsgGUID: kFCFJZN6QUWgMmPhPMnSew==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="28361552"
X-IronPort-AV: E=Sophos;i="6.08,261,1712646000"; 
   d="scan'208";a="28361552"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 06:31:12 -0700
X-CSE-ConnectionGUID: tzVpYcFQQiyjO9ZG82vk9Q==
X-CSE-MsgGUID: T8hfRl2oS4y1ixT1EkzxdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,261,1712646000"; 
   d="scan'208";a="33330782"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by orviesa005.jf.intel.com with ESMTP; 07 May 2024 06:31:10 -0700
From: Wei Wang <wei.w.wang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v4 1/3] KVM: x86: Replace static_call_cond() with static_call()
Date: Tue,  7 May 2024 21:31:01 +0800
Message-Id: <20240507133103.15052-2-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20240507133103.15052-1-wei.w.wang@intel.com>
References: <20240507133103.15052-1-wei.w.wang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The use of static_call_cond() is essentially the same as static_call() on
x86 (e.g. static_call() now handles a NULL pointer as a NOP), so replace
it with static_call() to simplify the code.

Link: https://lore.kernel.org/all/3916caa1dcd114301a49beafa5030eca396745c1.1679456900.git.jpoimboe@kernel.org/
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++--
 arch/x86/kvm/irq.c              |  2 +-
 arch/x86/kvm/lapic.c            | 24 ++++++++++++------------
 arch/x86/kvm/pmu.c              |  6 +++---
 arch/x86/kvm/x86.c              | 24 ++++++++++++------------
 5 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6efd1497b026..b45a73a93efa 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2280,12 +2280,12 @@ static inline bool kvm_irq_is_postable(struct kvm_lapic_irq *irq)
 
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
 {
-	static_call_cond(kvm_x86_vcpu_blocking)(vcpu);
+	static_call(kvm_x86_vcpu_blocking)(vcpu);
 }
 
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 {
-	static_call_cond(kvm_x86_vcpu_unblocking)(vcpu);
+	static_call(kvm_x86_vcpu_unblocking)(vcpu);
 }
 
 static inline int kvm_cpu_get_apicid(int mps_cpu)
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index ad9ca8a60144..7cf93d427484 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -157,7 +157,7 @@ void __kvm_migrate_timers(struct kvm_vcpu *vcpu)
 {
 	__kvm_migrate_apic_timer(vcpu);
 	__kvm_migrate_pit_timer(vcpu);
-	static_call_cond(kvm_x86_migrate_timers)(vcpu);
+	static_call(kvm_x86_migrate_timers)(vcpu);
 }
 
 bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args)
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index ebf41023be38..eaf840699d27 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -728,7 +728,7 @@ static inline void apic_clear_irr(int vec, struct kvm_lapic *apic)
 	if (unlikely(apic->apicv_active)) {
 		/* need to update RVI */
 		kvm_lapic_clear_vector(vec, apic->regs + APIC_IRR);
-		static_call_cond(kvm_x86_hwapic_irr_update)(apic->vcpu,
+		static_call(kvm_x86_hwapic_irr_update)(apic->vcpu,
 							    apic_find_highest_irr(apic));
 	} else {
 		apic->irr_pending = false;
@@ -755,7 +755,7 @@ static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
 	 * just set SVI.
 	 */
 	if (unlikely(apic->apicv_active))
-		static_call_cond(kvm_x86_hwapic_isr_update)(vec);
+		static_call(kvm_x86_hwapic_isr_update)(vec);
 	else {
 		++apic->isr_count;
 		BUG_ON(apic->isr_count > MAX_APIC_VECTOR);
@@ -800,7 +800,7 @@ static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
 	 * and must be left alone.
 	 */
 	if (unlikely(apic->apicv_active))
-		static_call_cond(kvm_x86_hwapic_isr_update)(apic_find_highest_isr(apic));
+		static_call(kvm_x86_hwapic_isr_update)(apic_find_highest_isr(apic));
 	else {
 		--apic->isr_count;
 		BUG_ON(apic->isr_count < 0);
@@ -2567,7 +2567,7 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 
 	if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE)) {
 		kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
-		static_call_cond(kvm_x86_set_virtual_apic_mode)(vcpu);
+		static_call(kvm_x86_set_virtual_apic_mode)(vcpu);
 	}
 
 	apic->base_address = apic->vcpu->arch.apic_base &
@@ -2677,7 +2677,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 	u64 msr_val;
 	int i;
 
-	static_call_cond(kvm_x86_apicv_pre_state_restore)(vcpu);
+	static_call(kvm_x86_apicv_pre_state_restore)(vcpu);
 
 	if (!init_event) {
 		msr_val = APIC_DEFAULT_PHYS_BASE | MSR_IA32_APICBASE_ENABLE;
@@ -2732,9 +2732,9 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vcpu->arch.pv_eoi.msr_val = 0;
 	apic_update_ppr(apic);
 	if (apic->apicv_active) {
-		static_call_cond(kvm_x86_apicv_post_state_restore)(vcpu);
-		static_call_cond(kvm_x86_hwapic_irr_update)(vcpu, -1);
-		static_call_cond(kvm_x86_hwapic_isr_update)(-1);
+		static_call(kvm_x86_apicv_post_state_restore)(vcpu);
+		static_call(kvm_x86_hwapic_irr_update)(vcpu, -1);
+		static_call(kvm_x86_hwapic_isr_update)(-1);
 	}
 
 	vcpu->arch.apic_arb_prio = 0;
@@ -3014,7 +3014,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	int r;
 
-	static_call_cond(kvm_x86_apicv_pre_state_restore)(vcpu);
+	static_call(kvm_x86_apicv_pre_state_restore)(vcpu);
 
 	kvm_lapic_set_base(vcpu, vcpu->arch.apic_base);
 	/* set SPIV separately to get count of SW disabled APICs right */
@@ -3041,9 +3041,9 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	kvm_lapic_set_reg(apic, APIC_TMCCT, 0);
 	kvm_apic_update_apicv(vcpu);
 	if (apic->apicv_active) {
-		static_call_cond(kvm_x86_apicv_post_state_restore)(vcpu);
-		static_call_cond(kvm_x86_hwapic_irr_update)(vcpu, apic_find_highest_irr(apic));
-		static_call_cond(kvm_x86_hwapic_isr_update)(apic_find_highest_isr(apic));
+		static_call(kvm_x86_apicv_post_state_restore)(vcpu);
+		static_call(kvm_x86_hwapic_irr_update)(vcpu, apic_find_highest_irr(apic));
+		static_call(kvm_x86_hwapic_isr_update)(apic_find_highest_isr(apic));
 	}
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 	if (ioapic_in_kernel(vcpu->kvm))
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index a593b03c9aed..1d456b69ddc6 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -607,7 +607,7 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
 {
 	if (lapic_in_kernel(vcpu)) {
-		static_call_cond(kvm_x86_pmu_deliver_pmi)(vcpu);
+		static_call(kvm_x86_pmu_deliver_pmi)(vcpu);
 		kvm_apic_local_deliver(vcpu->arch.apic, APIC_LVTPC);
 	}
 }
@@ -740,7 +740,7 @@ static void kvm_pmu_reset(struct kvm_vcpu *vcpu)
 
 	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status = 0;
 
-	static_call_cond(kvm_x86_pmu_reset)(vcpu);
+	static_call(kvm_x86_pmu_reset)(vcpu);
 }
 
 
@@ -818,7 +818,7 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
 			pmc_stop_counter(pmc);
 	}
 
-	static_call_cond(kvm_x86_pmu_cleanup)(vcpu);
+	static_call(kvm_x86_pmu_cleanup)(vcpu);
 
 	bitmap_zero(pmu->pmc_in_use, X86_PMC_IDX_MAX);
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 91478b769af0..bb602fb2f8d3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5134,7 +5134,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
 				    struct kvm_lapic_state *s)
 {
-	static_call_cond(kvm_x86_sync_pir_to_irr)(vcpu);
+	static_call(kvm_x86_sync_pir_to_irr)(vcpu);
 
 	return kvm_apic_get_state(vcpu, s);
 }
@@ -9285,7 +9285,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			kvm_rip_write(vcpu, ctxt->eip);
 			if (r && (ctxt->tf || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)))
 				r = kvm_vcpu_do_singlestep(vcpu);
-			static_call_cond(kvm_x86_update_emulated_instruction)(vcpu);
+			static_call(kvm_x86_update_emulated_instruction)(vcpu);
 			__kvm_set_rflags(vcpu, ctxt->eflags);
 		}
 
@@ -10680,7 +10680,7 @@ static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
 	if (irqchip_split(vcpu->kvm))
 		kvm_scan_ioapic_routes(vcpu, vcpu->arch.ioapic_handled_vectors);
 	else {
-		static_call_cond(kvm_x86_sync_pir_to_irr)(vcpu);
+		static_call(kvm_x86_sync_pir_to_irr)(vcpu);
 		if (ioapic_in_kernel(vcpu->kvm))
 			kvm_ioapic_scan_entry(vcpu, vcpu->arch.ioapic_handled_vectors);
 	}
@@ -10703,17 +10703,17 @@ static void vcpu_load_eoi_exitmap(struct kvm_vcpu *vcpu)
 		bitmap_or((ulong *)eoi_exit_bitmap,
 			  vcpu->arch.ioapic_handled_vectors,
 			  to_hv_synic(vcpu)->vec_bitmap, 256);
-		static_call_cond(kvm_x86_load_eoi_exitmap)(vcpu, eoi_exit_bitmap);
+		static_call(kvm_x86_load_eoi_exitmap)(vcpu, eoi_exit_bitmap);
 		return;
 	}
 #endif
-	static_call_cond(kvm_x86_load_eoi_exitmap)(
+	static_call(kvm_x86_load_eoi_exitmap)(
 		vcpu, (u64 *)vcpu->arch.ioapic_handled_vectors);
 }
 
 void kvm_arch_guest_memory_reclaimed(struct kvm *kvm)
 {
-	static_call_cond(kvm_x86_guest_memory_reclaimed)(kvm);
+	static_call(kvm_x86_guest_memory_reclaimed)(kvm);
 }
 
 static void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
@@ -10721,7 +10721,7 @@ static void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
 	if (!lapic_in_kernel(vcpu))
 		return;
 
-	static_call_cond(kvm_x86_set_apic_access_page_addr)(vcpu);
+	static_call(kvm_x86_set_apic_access_page_addr)(vcpu);
 }
 
 /*
@@ -10961,7 +10961,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 * i.e. they can post interrupts even if APICv is temporarily disabled.
 	 */
 	if (kvm_lapic_enabled(vcpu))
-		static_call_cond(kvm_x86_sync_pir_to_irr)(vcpu);
+		static_call(kvm_x86_sync_pir_to_irr)(vcpu);
 
 	if (kvm_vcpu_exit_request(vcpu)) {
 		vcpu->mode = OUTSIDE_GUEST_MODE;
@@ -11010,7 +11010,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			break;
 
 		if (kvm_lapic_enabled(vcpu))
-			static_call_cond(kvm_x86_sync_pir_to_irr)(vcpu);
+			static_call(kvm_x86_sync_pir_to_irr)(vcpu);
 
 		if (unlikely(kvm_vcpu_exit_request(vcpu))) {
 			exit_fastpath = EXIT_FASTPATH_EXIT_HANDLED;
@@ -11758,7 +11758,7 @@ static int __set_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs,
 	*mmu_reset_needed |= kvm_read_cr3(vcpu) != sregs->cr3;
 	vcpu->arch.cr3 = sregs->cr3;
 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
-	static_call_cond(kvm_x86_post_set_cr3)(vcpu, sregs->cr3);
+	static_call(kvm_x86_post_set_cr3)(vcpu, sregs->cr3);
 
 	kvm_set_cr8(vcpu, sregs->cr8);
 
@@ -12713,7 +12713,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 		mutex_unlock(&kvm->slots_lock);
 	}
 	kvm_unload_vcpu_mmus(kvm);
-	static_call_cond(kvm_x86_vm_destroy)(kvm);
+	static_call(kvm_x86_vm_destroy)(kvm);
 	kvm_free_msr_filter(srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1));
 	kvm_pic_destroy(kvm);
 	kvm_ioapic_destroy(kvm);
@@ -13409,7 +13409,7 @@ bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu)
 void kvm_arch_start_assignment(struct kvm *kvm)
 {
 	if (atomic_inc_return(&kvm->arch.assigned_device_count) == 1)
-		static_call_cond(kvm_x86_pi_start_assignment)(kvm);
+		static_call(kvm_x86_pi_start_assignment)(kvm);
 }
 EXPORT_SYMBOL_GPL(kvm_arch_start_assignment);
 
-- 
2.27.0


