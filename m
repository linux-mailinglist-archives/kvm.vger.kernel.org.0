Return-Path: <kvm+bounces-1070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DB147E49AC
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 21:20:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B4C01F218AA
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 20:20:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 804153715A;
	Tue,  7 Nov 2023 20:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bZBHd76B"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA60437150
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 20:20:19 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355B910C8
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 12:20:19 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5aecf6e30e9so82676997b3.1
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 12:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699388418; x=1699993218; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HFazlnKy/oiKcoNTDFXdkEU774gU29WG9sFZNXKt1+4=;
        b=bZBHd76B3PmshImf3KyvGUD3LDdn8mKmwef9YD28nazBIvbFp9orODzOo5HTzj5zEK
         ocSUuEMOm4bJAD8cxk5p7g4vEcQf2k9fq6yF576W+jICZhTxdytn0heyu9dbY9QuWa3S
         QLrdM1TcI0fpRRxhNPjD2C5vL1+Sv+krJuO/T6vuuK0c/CCmPZZoayqy8lCQZnadJFxZ
         qCiEVsOfmNjOY0RBDMUj2ieZGY1lBVgnohSTabIXcCjB5NlpfONCGekHeY8DEO72akzo
         m4tUSO/Zui1GLqDcP5neVUeUeK+XjyZEtxaaxASkod0zuQOHYz4B+aVzjnPy/rJf++4X
         8a5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699388418; x=1699993218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HFazlnKy/oiKcoNTDFXdkEU774gU29WG9sFZNXKt1+4=;
        b=rzjLwYzXQLiIItKDda6SS+WOiUcFjTjeCB1TOunt1PQalkhJTCwoROQsvH7Dp/xF0w
         ACRaHLCvgnhf+X8LLBausA20xkZvo8I+EkgU36aUQVle94M+mJh8J94dZIa8utcZMXZ1
         aJ6TK23v61zRn5OtXUvBa7fMlx+HbqEpGdlTZ6mYT9qL2eIy+Tf+VZZT6z/XqY1Ul0fp
         5neLGy7Ya0ZytMc3G5gVEkxD06EipDCdJXdvEFzOQHmahPCikiiRiPKUK4cxXFE9ubDl
         hpqq1+LkVn4cyxSjGCu0fAU26bC43fxPDSPcddNF4PXLzRclIsrm+NepnkE46PYcL9Gw
         fVIg==
X-Gm-Message-State: AOJu0Yx3kJQIApf2cXAC84YN9CAYojw6rn8ZVs5qqUge1RUuLAXJ6mP7
	CHYdbBGEfuZMrgaGchcG/SHuwtOa+PQVeyTbmLfOC9pQv6L8BM/7ciGJATPD1K7nH3aAowy+cuH
	jpsmFg6OF41D9wGpjvmvsPbLxMCPWnLz9JsrAOm0dhQ1Mz/gN4qiac1jeWYjeuyc=
X-Google-Smtp-Source: AGHT+IHifkx3V9Ybwf/gyCpCeRDn4X+LkKh0bGSrR7G0PN3YPo5WxTxDEOadOW/0Z/HbCYnSNBv8M2sAvb1eyA==
X-Received: from aghulati-dev.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:18bb])
 (user=aghulati job=sendgmr) by 2002:a0d:d708:0:b0:5a7:b54e:bfc1 with SMTP id
 z8-20020a0dd708000000b005a7b54ebfc1mr289928ywd.10.1699388418403; Tue, 07 Nov
 2023 12:20:18 -0800 (PST)
Date: Tue,  7 Nov 2023 20:19:51 +0000
In-Reply-To: <20231107202002.667900-1-aghulati@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231107202002.667900-1-aghulati@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231107202002.667900-4-aghulati@google.com>
Subject: [RFC PATCH 03/14] KVM: x86: Remove unused exports
From: Anish Ghulati <aghulati@google.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, hpa@zytor.com, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, peterz@infradead.org, paulmck@kernel.org, 
	Mark Rutland <mark.rutland@arm.com>
Cc: Anish Ghulati <aghulati@google.com>
Content-Type: text/plain; charset="UTF-8"

Remove all the unused exports from KVM now that vendor modules no longer
exist.

Signed-off-by: Anish Ghulati <aghulati@google.com>
---
 arch/x86/kvm/cpuid.c        |   7 --
 arch/x86/kvm/hyperv.c       |   2 -
 arch/x86/kvm/irq.c          |   3 -
 arch/x86/kvm/irq_comm.c     |   2 -
 arch/x86/kvm/kvm_onhyperv.c |   3 -
 arch/x86/kvm/lapic.c        |  15 ----
 arch/x86/kvm/mmu/mmu.c      |  12 ----
 arch/x86/kvm/mmu/spte.c     |   4 --
 arch/x86/kvm/mtrr.c         |   1 -
 arch/x86/kvm/pmu.c          |   2 -
 arch/x86/kvm/x86.c          | 140 ------------------------------------
 11 files changed, 191 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0544e30b4946..01de1f659beb 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -34,7 +34,6 @@
  * aligned to sizeof(unsigned long) because it's not accessed via bitops.
  */
 u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
-EXPORT_SYMBOL_GPL(kvm_cpu_caps);
 
 u32 xstate_required_size(u64 xstate_bv, bool compacted)
 {
@@ -310,7 +309,6 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 {
 	__kvm_update_cpuid_runtime(vcpu, vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
 }
-EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
 
 static bool kvm_cpuid_has_hyperv(struct kvm_cpuid_entry2 *entries, int nent)
 {
@@ -808,7 +806,6 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_clear(X86_FEATURE_RDPID);
 	}
 }
-EXPORT_SYMBOL_GPL(kvm_set_cpu_caps);
 
 struct kvm_cpuid_array {
 	struct kvm_cpuid_entry2 *entries;
@@ -1432,7 +1429,6 @@ struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
 	return cpuid_entry2_find(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent,
 				 function, index);
 }
-EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry_index);
 
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
 					      u32 function)
@@ -1440,7 +1436,6 @@ struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
 	return cpuid_entry2_find(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent,
 				 function, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
 }
-EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry);
 
 /*
  * Intel CPUID semantics treats any query for an out-of-range leaf as if the
@@ -1560,7 +1555,6 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 			used_max_basic);
 	return exact;
 }
-EXPORT_SYMBOL_GPL(kvm_cpuid);
 
 int kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
 {
@@ -1578,4 +1572,3 @@ int kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
 	kvm_rdx_write(vcpu, edx);
 	return kvm_skip_emulated_instruction(vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_emulate_cpuid);
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 7c2dac6824e2..c093307dbfcb 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -917,7 +917,6 @@ bool kvm_hv_assist_page_enabled(struct kvm_vcpu *vcpu)
 		return false;
 	return vcpu->arch.pv_eoi.msr_val & KVM_MSR_ENABLED;
 }
-EXPORT_SYMBOL_GPL(kvm_hv_assist_page_enabled);
 
 int kvm_hv_get_assist_page(struct kvm_vcpu *vcpu)
 {
@@ -929,7 +928,6 @@ int kvm_hv_get_assist_page(struct kvm_vcpu *vcpu)
 	return kvm_read_guest_cached(vcpu->kvm, &vcpu->arch.pv_eoi.data,
 				     &hv_vcpu->vp_assist_page, sizeof(struct hv_vp_assist_page));
 }
-EXPORT_SYMBOL_GPL(kvm_hv_get_assist_page);
 
 static void stimer_prepare_msg(struct kvm_vcpu_hv_stimer *stimer)
 {
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index b2c397dd2bc6..88de44c8087e 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -89,7 +89,6 @@ int kvm_cpu_has_injectable_intr(struct kvm_vcpu *v)
 
 	return kvm_apic_has_interrupt(v) != -1; /* LAPIC */
 }
-EXPORT_SYMBOL_GPL(kvm_cpu_has_injectable_intr);
 
 /*
  * check if there is pending interrupt without
@@ -102,7 +101,6 @@ int kvm_cpu_has_interrupt(struct kvm_vcpu *v)
 
 	return kvm_apic_has_interrupt(v) != -1;	/* LAPIC */
 }
-EXPORT_SYMBOL_GPL(kvm_cpu_has_interrupt);
 
 /*
  * Read pending interrupt(from non-APIC source)
@@ -141,7 +139,6 @@ int kvm_cpu_get_interrupt(struct kvm_vcpu *v)
 
 	return kvm_get_apic_interrupt(v);	/* APIC */
 }
-EXPORT_SYMBOL_GPL(kvm_cpu_get_interrupt);
 
 void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 16d076a1b91a..fa12d7340844 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -120,7 +120,6 @@ void kvm_set_msi_irq(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
 	irq->level = 1;
 	irq->shorthand = APIC_DEST_NOSHORT;
 }
-EXPORT_SYMBOL_GPL(kvm_set_msi_irq);
 
 static inline bool kvm_msi_route_invalid(struct kvm *kvm,
 		struct kvm_kernel_irq_routing_entry *e)
@@ -356,7 +355,6 @@ bool kvm_intr_is_single_vcpu(struct kvm *kvm, struct kvm_lapic_irq *irq,
 
 	return r == 1;
 }
-EXPORT_SYMBOL_GPL(kvm_intr_is_single_vcpu);
 
 #define IOAPIC_ROUTING_ENTRY(irq) \
 	{ .gsi = irq, .type = KVM_IRQ_ROUTING_IRQCHIP,	\
diff --git a/arch/x86/kvm/kvm_onhyperv.c b/arch/x86/kvm/kvm_onhyperv.c
index ded0bd688c65..aed3fdbd4b92 100644
--- a/arch/x86/kvm/kvm_onhyperv.c
+++ b/arch/x86/kvm/kvm_onhyperv.c
@@ -101,13 +101,11 @@ int hv_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, gfn_t nr_pages)
 
 	return __hv_flush_remote_tlbs_range(kvm, &range);
 }
-EXPORT_SYMBOL_GPL(hv_flush_remote_tlbs_range);
 
 int hv_flush_remote_tlbs(struct kvm *kvm)
 {
 	return __hv_flush_remote_tlbs_range(kvm, NULL);
 }
-EXPORT_SYMBOL_GPL(hv_flush_remote_tlbs);
 
 void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp)
 {
@@ -121,4 +119,3 @@ void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp)
 		spin_unlock(&kvm_arch->hv_root_tdp_lock);
 	}
 }
-EXPORT_SYMBOL_GPL(hv_track_root_tdp);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index dcd60b39e794..1009ef21248d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -682,7 +682,6 @@ bool __kvm_apic_update_irr(u32 *pir, void *regs, int *max_irr)
 	return ((max_updated_irr != -1) &&
 		(max_updated_irr == *max_irr));
 }
-EXPORT_SYMBOL_GPL(__kvm_apic_update_irr);
 
 bool kvm_apic_update_irr(struct kvm_vcpu *vcpu, u32 *pir, int *max_irr)
 {
@@ -693,7 +692,6 @@ bool kvm_apic_update_irr(struct kvm_vcpu *vcpu, u32 *pir, int *max_irr)
 		apic->irr_pending = true;
 	return irr_updated;
 }
-EXPORT_SYMBOL_GPL(kvm_apic_update_irr);
 
 static inline int apic_search_irr(struct kvm_lapic *apic)
 {
@@ -736,7 +734,6 @@ void kvm_apic_clear_irr(struct kvm_vcpu *vcpu, int vec)
 {
 	apic_clear_irr(vec, vcpu->arch.apic);
 }
-EXPORT_SYMBOL_GPL(kvm_apic_clear_irr);
 
 static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
 {
@@ -811,7 +808,6 @@ int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu)
 	 */
 	return apic_find_highest_irr(vcpu->arch.apic);
 }
-EXPORT_SYMBOL_GPL(kvm_lapic_find_highest_irr);
 
 static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 			     int vector, int level, int trig_mode,
@@ -973,7 +969,6 @@ void kvm_apic_update_ppr(struct kvm_vcpu *vcpu)
 {
 	apic_update_ppr(vcpu->arch.apic);
 }
-EXPORT_SYMBOL_GPL(kvm_apic_update_ppr);
 
 static void apic_set_tpr(struct kvm_lapic *apic, u32 tpr)
 {
@@ -1084,7 +1079,6 @@ bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
 		return false;
 	}
 }
-EXPORT_SYMBOL_GPL(kvm_apic_match_dest);
 
 int kvm_vector_to_index(u32 vector, u32 dest_vcpus,
 		       const unsigned long *bitmap, u32 bitmap_size)
@@ -1497,7 +1491,6 @@ void kvm_apic_set_eoi_accelerated(struct kvm_vcpu *vcpu, int vector)
 	kvm_ioapic_send_eoi(apic, vector);
 	kvm_make_request(KVM_REQ_EVENT, apic->vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_apic_set_eoi_accelerated);
 
 void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
 {
@@ -1522,7 +1515,6 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
 
 	kvm_irq_delivery_to_apic(apic->vcpu->kvm, apic, &irq, NULL);
 }
-EXPORT_SYMBOL_GPL(kvm_apic_send_ipi);
 
 static u32 apic_get_tmcct(struct kvm_lapic *apic)
 {
@@ -1638,7 +1630,6 @@ u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic)
 
 	return valid_reg_mask;
 }
-EXPORT_SYMBOL_GPL(kvm_lapic_readable_reg_mask);
 
 static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 			      void *data)
@@ -1872,7 +1863,6 @@ void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 	    lapic_timer_int_injected(vcpu))
 		__kvm_wait_lapic_expire(vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_wait_lapic_expire);
 
 static void kvm_apic_inject_pending_timer_irqs(struct kvm_lapic *apic)
 {
@@ -2185,7 +2175,6 @@ void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu)
 out:
 	preempt_enable();
 }
-EXPORT_SYMBOL_GPL(kvm_lapic_expired_hv_timer);
 
 void kvm_lapic_switch_to_hv_timer(struct kvm_vcpu *vcpu)
 {
@@ -2438,7 +2427,6 @@ void kvm_lapic_set_eoi(struct kvm_vcpu *vcpu)
 {
 	kvm_lapic_reg_write(vcpu->arch.apic, APIC_EOI, 0);
 }
-EXPORT_SYMBOL_GPL(kvm_lapic_set_eoi);
 
 /* emulate APIC access in a trap manner */
 void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
@@ -2461,7 +2449,6 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
 		kvm_lapic_reg_write(apic, offset, (u32)val);
 	}
 }
-EXPORT_SYMBOL_GPL(kvm_apic_write_nodecode);
 
 void kvm_free_lapic(struct kvm_vcpu *vcpu)
 {
@@ -2627,7 +2614,6 @@ int kvm_alloc_apic_access_page(struct kvm *kvm)
 	mutex_unlock(&kvm->slots_lock);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(kvm_alloc_apic_access_page);
 
 void kvm_inhibit_apic_access_page(struct kvm_vcpu *vcpu)
 {
@@ -2858,7 +2844,6 @@ int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
 	__apic_update_ppr(apic, &ppr);
 	return apic_has_interrupt_for_ppr(apic, ppr);
 }
-EXPORT_SYMBOL_GPL(kvm_apic_has_interrupt);
 
 int kvm_apic_accept_pic_intr(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e1d011c67cc6..e9e66d635688 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3610,7 +3610,6 @@ void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 	write_unlock(&kvm->mmu_lock);
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_free_roots);
 
 void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu)
 {
@@ -3637,7 +3636,6 @@ void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu)
 
 	kvm_mmu_free_roots(kvm, mmu, roots_to_free);
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_free_guest_mode_roots);
 
 static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
 			    u8 level)
@@ -4441,7 +4439,6 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 
 	return r;
 }
-EXPORT_SYMBOL_GPL(kvm_handle_page_fault);
 
 #ifdef CONFIG_X86_64
 static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
@@ -4660,7 +4657,6 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
 			__clear_sp_write_flooding_count(sp);
 	}
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_new_pgd);
 
 static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
 			   unsigned int access)
@@ -5294,7 +5290,6 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 	shadow_mmu_init_context(vcpu, context, cpu_role, root_role);
 	kvm_mmu_new_pgd(vcpu, nested_cr3);
 }
-EXPORT_SYMBOL_GPL(kvm_init_shadow_npt_mmu);
 
 static union kvm_cpu_role
 kvm_calc_shadow_ept_root_page_role(struct kvm_vcpu *vcpu, bool accessed_dirty,
@@ -5348,7 +5343,6 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 
 	kvm_mmu_new_pgd(vcpu, new_eptp);
 }
-EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu);
 
 static void init_kvm_softmmu(struct kvm_vcpu *vcpu,
 			     union kvm_cpu_role cpu_role)
@@ -5413,7 +5407,6 @@ void kvm_init_mmu(struct kvm_vcpu *vcpu)
 	else
 		init_kvm_softmmu(vcpu, cpu_role);
 }
-EXPORT_SYMBOL_GPL(kvm_init_mmu);
 
 void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
@@ -5449,7 +5442,6 @@ void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
 	kvm_mmu_unload(vcpu);
 	kvm_init_mmu(vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_reset_context);
 
 int kvm_mmu_load(struct kvm_vcpu *vcpu)
 {
@@ -5763,7 +5755,6 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	return x86_emulate_instruction(vcpu, cr2_or_gpa, emulation_type, insn,
 				       insn_len);
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_page_fault);
 
 static void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 				      u64 addr, hpa_t root_hpa)
@@ -5829,7 +5820,6 @@ void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			__kvm_mmu_invalidate_addr(vcpu, mmu, addr, mmu->prev_roots[i].hpa);
 	}
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_invalidate_addr);
 
 void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
 {
@@ -5846,7 +5836,6 @@ void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
 	kvm_mmu_invalidate_addr(vcpu, vcpu->arch.walk_mmu, gva, KVM_MMU_ROOTS_ALL);
 	++vcpu->stat.invlpg;
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_invlpg);
 
 
 void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
@@ -5899,7 +5888,6 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 	else
 		max_huge_page_level = PG_LEVEL_2M;
 }
-EXPORT_SYMBOL_GPL(kvm_configure_mmu);
 
 /* The return value indicates if tlb flush on all vcpus is needed. */
 typedef bool (*slot_rmaps_handler) (struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 4a599130e9c9..feb3bbb16d70 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -22,7 +22,6 @@
 bool __read_mostly enable_mmio_caching = true;
 static bool __ro_after_init allow_mmio_caching;
 module_param_named(mmio_caching, enable_mmio_caching, bool, 0444);
-EXPORT_SYMBOL_GPL(enable_mmio_caching);
 
 u64 __read_mostly shadow_host_writable_mask;
 u64 __read_mostly shadow_mmu_writable_mask;
@@ -409,7 +408,6 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
 	shadow_mmio_mask  = mmio_mask;
 	shadow_mmio_access_mask = access_mask;
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
 
 void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask)
 {
@@ -420,7 +418,6 @@ void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask)
 	shadow_me_value = me_value;
 	shadow_me_mask = me_mask;
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_set_me_spte_mask);
 
 void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
 {
@@ -448,7 +445,6 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
 	kvm_mmu_set_mmio_spte_mask(VMX_EPT_MISCONFIG_WX_VALUE,
 				   VMX_EPT_RWX_MASK, 0);
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_set_ept_masks);
 
 void kvm_mmu_reset_all_pte_masks(void)
 {
diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index 3eb6e7f47e96..409225d19ac5 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -685,7 +685,6 @@ u8 kvm_mtrr_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn)
 
 	return type;
 }
-EXPORT_SYMBOL_GPL(kvm_mtrr_get_guest_memory_type);
 
 bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu, gfn_t gfn,
 					  int page_num)
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index edb89b51b383..f35511086046 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -27,7 +27,6 @@
 #define KVM_PMU_EVENT_FILTER_MAX_EVENTS 300
 
 struct x86_pmu_capability __read_mostly kvm_pmu_cap;
-EXPORT_SYMBOL_GPL(kvm_pmu_cap);
 
 /* Precise Distribution of Instructions Retired (PDIR) */
 static const struct x86_cpu_id vmx_pebs_pdir_cpu[] = {
@@ -773,7 +772,6 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
 			kvm_pmu_incr_counter(pmc);
 	}
 }
-EXPORT_SYMBOL_GPL(kvm_pmu_trigger_event);
 
 static bool is_masked_filter_valid(const struct kvm_x86_pmu_event_filter *filter)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e62daa2c3017..0a8b94678928 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -95,7 +95,6 @@
 struct kvm_caps kvm_caps __read_mostly = {
 	.supported_mce_cap = MCG_CTL_P | MCG_SER_P,
 };
-EXPORT_SYMBOL_GPL(kvm_caps);
 
 #define  ERR_PTR_USR(e)  ((void __user *)ERR_PTR(e))
 
@@ -149,7 +148,6 @@ module_param(ignore_msrs, bool, S_IRUGO | S_IWUSR);
 
 bool __read_mostly report_ignored_msrs = true;
 module_param(report_ignored_msrs, bool, S_IRUGO | S_IWUSR);
-EXPORT_SYMBOL_GPL(report_ignored_msrs);
 
 unsigned int min_timer_period_us = 200;
 module_param(min_timer_period_us, uint, S_IRUGO | S_IWUSR);
@@ -175,18 +173,15 @@ module_param(vector_hashing, bool, S_IRUGO);
 
 bool __read_mostly enable_vmware_backdoor = false;
 module_param(enable_vmware_backdoor, bool, S_IRUGO);
-EXPORT_SYMBOL_GPL(enable_vmware_backdoor);
 
 /*
  * If nested=1, nested virtualization is supported
  */
 bool __read_mostly nested = 1;
 module_param(nested, bool, S_IRUGO);
-EXPORT_SYMBOL_GPL(nested);
 
 bool __read_mostly enable_vnmi = 1;
 module_param(enable_vnmi, bool, S_IRUGO);
-EXPORT_SYMBOL_GPL(enable_vnmi);
 
 /*
  * Flags to manipulate forced emulation behavior (any non-zero value will
@@ -201,7 +196,6 @@ module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
 
 /* Enable/disable PMU virtualization */
 bool __read_mostly enable_pmu = true;
-EXPORT_SYMBOL_GPL(enable_pmu);
 module_param(enable_pmu, bool, 0444);
 
 bool __read_mostly eager_page_split = true;
@@ -228,7 +222,6 @@ struct kvm_user_return_msrs {
 };
 
 u32 __read_mostly kvm_nr_uret_msrs;
-EXPORT_SYMBOL_GPL(kvm_nr_uret_msrs);
 static u32 __read_mostly kvm_uret_msrs_list[KVM_MAX_NR_USER_RETURN_MSRS];
 static struct kvm_user_return_msrs __percpu *user_return_msrs;
 
@@ -238,19 +231,14 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
 				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
 
 u64 __read_mostly host_efer;
-EXPORT_SYMBOL_GPL(host_efer);
 
 bool __read_mostly allow_smaller_maxphyaddr = 0;
-EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);
 
 bool __read_mostly enable_apicv = true;
-EXPORT_SYMBOL_GPL(enable_apicv);
 
 u64 __read_mostly host_xss;
-EXPORT_SYMBOL_GPL(host_xss);
 
 u64 __read_mostly host_arch_capabilities;
-EXPORT_SYMBOL_GPL(host_arch_capabilities);
 
 const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS(),
@@ -422,7 +410,6 @@ int kvm_add_user_return_msr(u32 msr)
 	kvm_uret_msrs_list[kvm_nr_uret_msrs] = msr;
 	return kvm_nr_uret_msrs++;
 }
-EXPORT_SYMBOL_GPL(kvm_add_user_return_msr);
 
 int kvm_find_user_return_msr(u32 msr)
 {
@@ -434,7 +421,6 @@ int kvm_find_user_return_msr(u32 msr)
 	}
 	return -1;
 }
-EXPORT_SYMBOL_GPL(kvm_find_user_return_msr);
 
 static void kvm_user_return_msr_cpu_online(void)
 {
@@ -471,7 +457,6 @@ int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_set_user_return_msr);
 
 static void drop_user_return_notifiers(void)
 {
@@ -491,7 +476,6 @@ enum lapic_mode kvm_get_apic_mode(struct kvm_vcpu *vcpu)
 {
 	return kvm_apic_mode(kvm_get_apic_base(vcpu));
 }
-EXPORT_SYMBOL_GPL(kvm_get_apic_mode);
 
 int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
@@ -526,7 +510,6 @@ noinstr void kvm_spurious_fault(void)
 	/* Fault while not rebooting.  We want the trace. */
 	BUG_ON(!kvm_rebooting);
 }
-EXPORT_SYMBOL_GPL(kvm_spurious_fault);
 
 #define EXCPT_BENIGN		0
 #define EXCPT_CONTRIBUTORY	1
@@ -631,7 +614,6 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu,
 	ex->has_payload = false;
 	ex->payload = 0;
 }
-EXPORT_SYMBOL_GPL(kvm_deliver_exception_payload);
 
 static void kvm_queue_exception_vmexit(struct kvm_vcpu *vcpu, unsigned int vector,
 				       bool has_error_code, u32 error_code,
@@ -743,20 +725,17 @@ void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr)
 {
 	kvm_multiple_exception(vcpu, nr, false, 0, false, 0, false);
 }
-EXPORT_SYMBOL_GPL(kvm_queue_exception);
 
 void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned nr)
 {
 	kvm_multiple_exception(vcpu, nr, false, 0, false, 0, true);
 }
-EXPORT_SYMBOL_GPL(kvm_requeue_exception);
 
 void kvm_queue_exception_p(struct kvm_vcpu *vcpu, unsigned nr,
 			   unsigned long payload)
 {
 	kvm_multiple_exception(vcpu, nr, false, 0, true, payload, false);
 }
-EXPORT_SYMBOL_GPL(kvm_queue_exception_p);
 
 static void kvm_queue_exception_e_p(struct kvm_vcpu *vcpu, unsigned nr,
 				    u32 error_code, unsigned long payload)
@@ -774,7 +753,6 @@ int kvm_complete_insn_gp(struct kvm_vcpu *vcpu, int err)
 
 	return 1;
 }
-EXPORT_SYMBOL_GPL(kvm_complete_insn_gp);
 
 static int complete_emulated_insn_gp(struct kvm_vcpu *vcpu, int err)
 {
@@ -824,7 +802,6 @@ void kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
 
 	fault_mmu->inject_page_fault(vcpu, fault);
 }
-EXPORT_SYMBOL_GPL(kvm_inject_emulated_page_fault);
 
 void kvm_inject_nmi(struct kvm_vcpu *vcpu)
 {
@@ -836,13 +813,11 @@ void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code)
 {
 	kvm_multiple_exception(vcpu, nr, true, error_code, false, 0, false);
 }
-EXPORT_SYMBOL_GPL(kvm_queue_exception_e);
 
 void kvm_requeue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code)
 {
 	kvm_multiple_exception(vcpu, nr, true, error_code, false, 0, true);
 }
-EXPORT_SYMBOL_GPL(kvm_requeue_exception_e);
 
 /*
  * Checks if cpl <= required_cpl; if true, return true.  Otherwise queue
@@ -864,7 +839,6 @@ bool kvm_require_dr(struct kvm_vcpu *vcpu, int dr)
 	kvm_queue_exception(vcpu, UD_VECTOR);
 	return false;
 }
-EXPORT_SYMBOL_GPL(kvm_require_dr);
 
 static inline u64 pdptr_rsvd_bits(struct kvm_vcpu *vcpu)
 {
@@ -919,7 +893,6 @@ int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
 
 	return 1;
 }
-EXPORT_SYMBOL_GPL(load_pdptrs);
 
 static bool kvm_is_valid_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
@@ -977,7 +950,6 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon
 	    !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
 		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
 }
-EXPORT_SYMBOL_GPL(kvm_post_set_cr0);
 
 int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
@@ -1018,13 +990,11 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_set_cr0);
 
 void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw)
 {
 	(void)kvm_set_cr0(vcpu, kvm_read_cr0_bits(vcpu, ~0x0eul) | (msw & 0x0f));
 }
-EXPORT_SYMBOL_GPL(kvm_lmsw);
 
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
 {
@@ -1047,7 +1017,6 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
 	     kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE)))
 		write_pkru(vcpu->arch.pkru);
 }
-EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);
 
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
 {
@@ -1073,7 +1042,6 @@ void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
 	}
 
 }
-EXPORT_SYMBOL_GPL(kvm_load_host_xsave_state);
 
 #ifdef CONFIG_X86_64
 static inline u64 kvm_guest_supported_xfd(struct kvm_vcpu *vcpu)
@@ -1138,7 +1106,6 @@ int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu)
 
 	return kvm_skip_emulated_instruction(vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_emulate_xsetbv);
 
 bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
@@ -1150,7 +1117,6 @@ bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 
 	return true;
 }
-EXPORT_SYMBOL_GPL(__kvm_is_valid_cr4);
 
 static bool kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
@@ -1198,7 +1164,6 @@ void kvm_post_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned lon
 		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 
 }
-EXPORT_SYMBOL_GPL(kvm_post_set_cr4);
 
 int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
@@ -1229,7 +1194,6 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_set_cr4);
 
 static void kvm_invalidate_pcid(struct kvm_vcpu *vcpu, unsigned long pcid)
 {
@@ -1321,7 +1285,6 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_set_cr3);
 
 int kvm_set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8)
 {
@@ -1333,7 +1296,6 @@ int kvm_set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8)
 		vcpu->arch.cr8 = cr8;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_set_cr8);
 
 unsigned long kvm_get_cr8(struct kvm_vcpu *vcpu)
 {
@@ -1342,7 +1304,6 @@ unsigned long kvm_get_cr8(struct kvm_vcpu *vcpu)
 	else
 		return vcpu->arch.cr8;
 }
-EXPORT_SYMBOL_GPL(kvm_get_cr8);
 
 static void kvm_update_dr0123(struct kvm_vcpu *vcpu)
 {
@@ -1367,7 +1328,6 @@ void kvm_update_dr7(struct kvm_vcpu *vcpu)
 	if (dr7 & DR7_BP_EN_MASK)
 		vcpu->arch.switch_db_regs |= KVM_DEBUGREG_BP_ENABLED;
 }
-EXPORT_SYMBOL_GPL(kvm_update_dr7);
 
 static u64 kvm_dr6_fixed(struct kvm_vcpu *vcpu)
 {
@@ -1408,7 +1368,6 @@ int kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_set_dr);
 
 void kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val)
 {
@@ -1428,7 +1387,6 @@ void kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val)
 		break;
 	}
 }
-EXPORT_SYMBOL_GPL(kvm_get_dr);
 
 int kvm_emulate_rdpmc(struct kvm_vcpu *vcpu)
 {
@@ -1444,7 +1402,6 @@ int kvm_emulate_rdpmc(struct kvm_vcpu *vcpu)
 	kvm_rdx_write(vcpu, data >> 32);
 	return kvm_skip_emulated_instruction(vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_emulate_rdpmc);
 
 /*
  * The three MSR lists(msrs_to_save, emulated_msrs, msr_based_features) track
@@ -1758,7 +1715,6 @@ bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer)
 
 	return __kvm_valid_efer(vcpu, efer);
 }
-EXPORT_SYMBOL_GPL(kvm_valid_efer);
 
 static int set_efer(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
@@ -1797,7 +1753,6 @@ void kvm_enable_efer_bits(u64 mask)
 {
        efer_reserved_bits &= ~mask;
 }
-EXPORT_SYMBOL_GPL(kvm_enable_efer_bits);
 
 bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
 {
@@ -1840,7 +1795,6 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
 
 	return allowed;
 }
-EXPORT_SYMBOL_GPL(kvm_msr_allowed);
 
 /*
  * Write @data into the MSR specified by @index.  Select MSR specific fault
@@ -1988,13 +1942,11 @@ int kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data)
 {
 	return kvm_get_msr_ignored_check(vcpu, index, data, false);
 }
-EXPORT_SYMBOL_GPL(kvm_get_msr);
 
 int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data)
 {
 	return kvm_set_msr_ignored_check(vcpu, index, data, false);
 }
-EXPORT_SYMBOL_GPL(kvm_set_msr);
 
 static void complete_userspace_rdmsr(struct kvm_vcpu *vcpu)
 {
@@ -2083,7 +2035,6 @@ int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
 
 	return static_call(kvm_x86_complete_emulated_msr)(vcpu, r);
 }
-EXPORT_SYMBOL_GPL(kvm_emulate_rdmsr);
 
 int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
 {
@@ -2108,7 +2059,6 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
 
 	return static_call(kvm_x86_complete_emulated_msr)(vcpu, r);
 }
-EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
 
 int kvm_emulate_as_nop(struct kvm_vcpu *vcpu)
 {
@@ -2120,14 +2070,12 @@ int kvm_emulate_invd(struct kvm_vcpu *vcpu)
 	/* Treat an INVD instruction as a NOP and just skip it. */
 	return kvm_emulate_as_nop(vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_emulate_invd);
 
 int kvm_handle_invalid_op(struct kvm_vcpu *vcpu)
 {
 	kvm_queue_exception(vcpu, UD_VECTOR);
 	return 1;
 }
-EXPORT_SYMBOL_GPL(kvm_handle_invalid_op);
 
 
 static int kvm_emulate_monitor_mwait(struct kvm_vcpu *vcpu, const char *insn)
@@ -2143,13 +2091,11 @@ int kvm_emulate_mwait(struct kvm_vcpu *vcpu)
 {
 	return kvm_emulate_monitor_mwait(vcpu, "MWAIT");
 }
-EXPORT_SYMBOL_GPL(kvm_emulate_mwait);
 
 int kvm_emulate_monitor(struct kvm_vcpu *vcpu)
 {
 	return kvm_emulate_monitor_mwait(vcpu, "MONITOR");
 }
-EXPORT_SYMBOL_GPL(kvm_emulate_monitor);
 
 static inline bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu)
 {
@@ -2222,7 +2168,6 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(handle_fastpath_set_msr_irqoff);
 
 /*
  * Adapt set_msr() to msr_io()'s calling convention
@@ -2593,7 +2538,6 @@ u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)
 	return vcpu->arch.l1_tsc_offset +
 		kvm_scale_tsc(host_tsc, vcpu->arch.l1_tsc_scaling_ratio);
 }
-EXPORT_SYMBOL_GPL(kvm_read_l1_tsc);
 
 u64 kvm_calc_nested_tsc_offset(u64 l1_offset, u64 l2_offset, u64 l2_multiplier)
 {
@@ -2608,7 +2552,6 @@ u64 kvm_calc_nested_tsc_offset(u64 l1_offset, u64 l2_offset, u64 l2_multiplier)
 	nested_offset += l2_offset;
 	return nested_offset;
 }
-EXPORT_SYMBOL_GPL(kvm_calc_nested_tsc_offset);
 
 u64 kvm_calc_nested_tsc_multiplier(u64 l1_multiplier, u64 l2_multiplier)
 {
@@ -2618,7 +2561,6 @@ u64 kvm_calc_nested_tsc_multiplier(u64 l1_multiplier, u64 l2_multiplier)
 
 	return l1_multiplier;
 }
-EXPORT_SYMBOL_GPL(kvm_calc_nested_tsc_multiplier);
 
 static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 l1_offset)
 {
@@ -3525,7 +3467,6 @@ void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu)
 	if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu))
 		kvm_vcpu_flush_tlb_guest(vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_service_local_tlb_flush_requests);
 
 static void record_steal_time(struct kvm_vcpu *vcpu)
 {
@@ -4005,7 +3946,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_set_msr_common);
 
 static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 {
@@ -4363,7 +4303,6 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_get_msr_common);
 
 /*
  * Read or write a bunch of msrs. All parameters are kernel addresses.
@@ -7314,7 +7253,6 @@ gpa_t kvm_mmu_gva_to_gpa_read(struct kvm_vcpu *vcpu, gva_t gva,
 	u64 access = (static_call(kvm_x86_get_cpl)(vcpu) == 3) ? PFERR_USER_MASK : 0;
 	return mmu->gva_to_gpa(vcpu, mmu, gva, access, exception);
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_gva_to_gpa_read);
 
 gpa_t kvm_mmu_gva_to_gpa_write(struct kvm_vcpu *vcpu, gva_t gva,
 			       struct x86_exception *exception)
@@ -7325,7 +7263,6 @@ gpa_t kvm_mmu_gva_to_gpa_write(struct kvm_vcpu *vcpu, gva_t gva,
 	access |= PFERR_WRITE_MASK;
 	return mmu->gva_to_gpa(vcpu, mmu, gva, access, exception);
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_gva_to_gpa_write);
 
 /* uses this to access any guest's mapped memory without checking CPL */
 gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
@@ -7411,7 +7348,6 @@ int kvm_read_guest_virt(struct kvm_vcpu *vcpu,
 	return kvm_read_guest_virt_helper(addr, val, bytes, vcpu, access,
 					  exception);
 }
-EXPORT_SYMBOL_GPL(kvm_read_guest_virt);
 
 static int emulator_read_std(struct x86_emulate_ctxt *ctxt,
 			     gva_t addr, void *val, unsigned int bytes,
@@ -7483,7 +7419,6 @@ int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu, gva_t addr, void *val,
 	return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
 					   PFERR_WRITE_MASK, exception);
 }
-EXPORT_SYMBOL_GPL(kvm_write_guest_virt_system);
 
 static int kvm_can_emulate_insn(struct kvm_vcpu *vcpu, int emul_type,
 				void *insn, int insn_len)
@@ -7515,7 +7450,6 @@ int handle_ud(struct kvm_vcpu *vcpu)
 
 	return kvm_emulate_instruction(vcpu, emul_type);
 }
-EXPORT_SYMBOL_GPL(handle_ud);
 
 static int vcpu_is_mmio_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
 			    gpa_t gpa, bool write)
@@ -7985,7 +7919,6 @@ int kvm_emulate_wbinvd(struct kvm_vcpu *vcpu)
 	kvm_emulate_wbinvd_noskip(vcpu);
 	return kvm_skip_emulated_instruction(vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_emulate_wbinvd);
 
 
 
@@ -8460,7 +8393,6 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
 		kvm_set_rflags(vcpu, ctxt->eflags);
 	}
 }
-EXPORT_SYMBOL_GPL(kvm_inject_realmode_interrupt);
 
 static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu, u64 *data,
 					   u8 ndata, u8 *insn_bytes, u8 insn_size)
@@ -8526,13 +8458,11 @@ void __kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu, u64 *data,
 {
 	prepare_emulation_failure_exit(vcpu, data, ndata, NULL, 0);
 }
-EXPORT_SYMBOL_GPL(__kvm_prepare_emulation_failure_exit);
 
 void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
 {
 	__kvm_prepare_emulation_failure_exit(vcpu, NULL, 0);
 }
-EXPORT_SYMBOL_GPL(kvm_prepare_emulation_failure_exit);
 
 static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 {
@@ -8740,7 +8670,6 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 		r = kvm_vcpu_do_singlestep(vcpu);
 	return r;
 }
-EXPORT_SYMBOL_GPL(kvm_skip_emulated_instruction);
 
 static bool kvm_is_code_breakpoint_inhibited(struct kvm_vcpu *vcpu)
 {
@@ -8873,7 +8802,6 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
 
 	return r;
 }
-EXPORT_SYMBOL_GPL(x86_decode_emulated_instruction);
 
 int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			    int emulation_type, void *insn, int insn_len)
@@ -9061,14 +8989,12 @@ int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type)
 {
 	return x86_emulate_instruction(vcpu, 0, emulation_type, NULL, 0);
 }
-EXPORT_SYMBOL_GPL(kvm_emulate_instruction);
 
 int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
 					void *insn, int insn_len)
 {
 	return x86_emulate_instruction(vcpu, 0, 0, insn, insn_len);
 }
-EXPORT_SYMBOL_GPL(kvm_emulate_instruction_from_buffer);
 
 static int complete_fast_pio_out_port_0x7e(struct kvm_vcpu *vcpu)
 {
@@ -9163,7 +9089,6 @@ int kvm_fast_pio(struct kvm_vcpu *vcpu, int size, unsigned short port, int in)
 		ret = kvm_fast_pio_out(vcpu, size, port);
 	return ret && kvm_skip_emulated_instruction(vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_fast_pio);
 
 static int kvmclock_cpu_down_prep(unsigned int cpu)
 {
@@ -9591,7 +9516,6 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 
 	return r;
 }
-EXPORT_SYMBOL_GPL(kvm_x86_vendor_init);
 
 void kvm_x86_vendor_exit(void)
 {
@@ -9625,7 +9549,6 @@ void kvm_x86_vendor_exit(void)
 	kvm_x86_ops.hardware_enable = NULL;
 	mutex_unlock(&vendor_module_lock);
 }
-EXPORT_SYMBOL_GPL(kvm_x86_vendor_exit);
 
 static int __kvm_emulate_halt(struct kvm_vcpu *vcpu, int state, int reason)
 {
@@ -9650,7 +9573,6 @@ int kvm_emulate_halt_noskip(struct kvm_vcpu *vcpu)
 {
 	return __kvm_emulate_halt(vcpu, KVM_MP_STATE_HALTED, KVM_EXIT_HLT);
 }
-EXPORT_SYMBOL_GPL(kvm_emulate_halt_noskip);
 
 int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 {
@@ -9661,7 +9583,6 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 	 */
 	return kvm_emulate_halt_noskip(vcpu) && ret;
 }
-EXPORT_SYMBOL_GPL(kvm_emulate_halt);
 
 int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu)
 {
@@ -9670,7 +9591,6 @@ int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu)
 	return __kvm_emulate_halt(vcpu, KVM_MP_STATE_AP_RESET_HOLD,
 					KVM_EXIT_AP_RESET_HOLD) && ret;
 }
-EXPORT_SYMBOL_GPL(kvm_emulate_ap_reset_hold);
 
 #ifdef CONFIG_X86_64
 static int kvm_pv_clock_pairing(struct kvm_vcpu *vcpu, gpa_t paddr,
@@ -9734,7 +9654,6 @@ bool kvm_apicv_activated(struct kvm *kvm)
 {
 	return (READ_ONCE(kvm->arch.apicv_inhibit_reasons) == 0);
 }
-EXPORT_SYMBOL_GPL(kvm_apicv_activated);
 
 bool kvm_vcpu_apicv_activated(struct kvm_vcpu *vcpu)
 {
@@ -9743,7 +9662,6 @@ bool kvm_vcpu_apicv_activated(struct kvm_vcpu *vcpu)
 
 	return (vm_reasons | vcpu_reasons) == 0;
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_apicv_activated);
 
 static void set_or_clear_apicv_inhibit(unsigned long *inhibits,
 				       enum kvm_apicv_inhibit reason, bool set)
@@ -9917,7 +9835,6 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	++vcpu->stat.hypercalls;
 	return kvm_skip_emulated_instruction(vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
 
 static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
 {
@@ -10355,7 +10272,6 @@ void __kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 	preempt_enable();
 	up_read(&vcpu->kvm->arch.apicv_update_lock);
 }
-EXPORT_SYMBOL_GPL(__kvm_vcpu_update_apicv);
 
 static void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 {
@@ -10431,7 +10347,6 @@ void kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
 	__kvm_set_or_clear_apicv_inhibit(kvm, reason, set);
 	up_write(&kvm->arch.apicv_update_lock);
 }
-EXPORT_SYMBOL_GPL(kvm_set_or_clear_apicv_inhibit);
 
 static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
 {
@@ -10490,7 +10405,6 @@ void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu)
 {
 	smp_send_reschedule(vcpu->cpu);
 }
-EXPORT_SYMBOL_GPL(__kvm_request_immediate_exit);
 
 /*
  * Called within kvm->srcu read side.
@@ -11467,7 +11381,6 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
 	kvm_set_rflags(vcpu, ctxt->eflags);
 	return 1;
 }
-EXPORT_SYMBOL_GPL(kvm_task_switch);
 
 static bool kvm_is_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 {
@@ -12159,7 +12072,6 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	if (init_event)
 		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_reset);
 
 void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 {
@@ -12171,7 +12083,6 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 	kvm_set_segment(vcpu, &cs, VCPU_SREG_CS);
 	kvm_rip_write(vcpu, 0);
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_deliver_sipi_vector);
 
 int kvm_arch_hardware_enable(void)
 {
@@ -12286,7 +12197,6 @@ bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
 }
 
 __read_mostly DEFINE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
-EXPORT_SYMBOL_GPL(kvm_has_noapic_vcpu);
 
 void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
 {
@@ -12475,7 +12385,6 @@ void __user * __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
 
 	return (void __user *)hva;
 }
-EXPORT_SYMBOL_GPL(__x86_set_memory_region);
 
 void kvm_arch_pre_destroy_vm(struct kvm *kvm)
 {
@@ -12939,13 +12848,11 @@ unsigned long kvm_get_linear_rip(struct kvm_vcpu *vcpu)
 	return (u32)(get_segment_base(vcpu, VCPU_SREG_CS) +
 		     kvm_rip_read(vcpu));
 }
-EXPORT_SYMBOL_GPL(kvm_get_linear_rip);
 
 bool kvm_is_linear_rip(struct kvm_vcpu *vcpu, unsigned long linear_rip)
 {
 	return kvm_get_linear_rip(vcpu) == linear_rip;
 }
-EXPORT_SYMBOL_GPL(kvm_is_linear_rip);
 
 unsigned long kvm_get_rflags(struct kvm_vcpu *vcpu)
 {
@@ -12956,7 +12863,6 @@ unsigned long kvm_get_rflags(struct kvm_vcpu *vcpu)
 		rflags &= ~X86_EFLAGS_TF;
 	return rflags;
 }
-EXPORT_SYMBOL_GPL(kvm_get_rflags);
 
 static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 {
@@ -12971,7 +12877,6 @@ void kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 	__kvm_set_rflags(vcpu, rflags);
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_set_rflags);
 
 static inline u32 kvm_async_pf_hash_fn(gfn_t gfn)
 {
@@ -13188,37 +13093,31 @@ void kvm_arch_start_assignment(struct kvm *kvm)
 	if (atomic_inc_return(&kvm->arch.assigned_device_count) == 1)
 		static_call_cond(kvm_x86_pi_start_assignment)(kvm);
 }
-EXPORT_SYMBOL_GPL(kvm_arch_start_assignment);
 
 void kvm_arch_end_assignment(struct kvm *kvm)
 {
 	atomic_dec(&kvm->arch.assigned_device_count);
 }
-EXPORT_SYMBOL_GPL(kvm_arch_end_assignment);
 
 bool noinstr kvm_arch_has_assigned_device(struct kvm *kvm)
 {
 	return raw_atomic_read(&kvm->arch.assigned_device_count);
 }
-EXPORT_SYMBOL_GPL(kvm_arch_has_assigned_device);
 
 void kvm_arch_register_noncoherent_dma(struct kvm *kvm)
 {
 	atomic_inc(&kvm->arch.noncoherent_dma_count);
 }
-EXPORT_SYMBOL_GPL(kvm_arch_register_noncoherent_dma);
 
 void kvm_arch_unregister_noncoherent_dma(struct kvm *kvm)
 {
 	atomic_dec(&kvm->arch.noncoherent_dma_count);
 }
-EXPORT_SYMBOL_GPL(kvm_arch_unregister_noncoherent_dma);
 
 bool kvm_arch_has_noncoherent_dma(struct kvm *kvm)
 {
 	return atomic_read(&kvm->arch.noncoherent_dma_count);
 }
-EXPORT_SYMBOL_GPL(kvm_arch_has_noncoherent_dma);
 
 bool kvm_arch_has_irq_bypass(void)
 {
@@ -13291,8 +13190,6 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 {
 	return (vcpu->arch.msr_kvm_poll_control & 1) == 0;
 }
-EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
-
 
 int kvm_spec_ctrl_test_value(u64 value)
 {
@@ -13318,7 +13215,6 @@ int kvm_spec_ctrl_test_value(u64 value)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(kvm_spec_ctrl_test_value);
 
 void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_code)
 {
@@ -13343,7 +13239,6 @@ void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_c
 	}
 	vcpu->arch.walk_mmu->inject_page_fault(vcpu, &fault);
 }
-EXPORT_SYMBOL_GPL(kvm_fixup_and_inject_pf_error);
 
 /*
  * Handles kvm_read/write_guest_virt*() result and either injects #PF or returns
@@ -13372,7 +13267,6 @@ int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_handle_memory_failure);
 
 int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
 {
@@ -13432,7 +13326,6 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
 		return 1;
 	}
 }
-EXPORT_SYMBOL_GPL(kvm_handle_invpcid);
 
 static int complete_sev_es_emulated_mmio(struct kvm_vcpu *vcpu)
 {
@@ -13517,7 +13410,6 @@ int kvm_sev_es_mmio_write(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_sev_es_mmio_write);
 
 int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
 			 void *data)
@@ -13555,7 +13447,6 @@ int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_sev_es_mmio_read);
 
 static void advance_sev_es_emulated_pio(struct kvm_vcpu *vcpu, unsigned count, int size)
 {
@@ -13643,37 +13534,6 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 	return in ? kvm_sev_es_ins(vcpu, size, port)
 		  : kvm_sev_es_outs(vcpu, size, port);
 }
-EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
-
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_msr);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_cr);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmenter);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit_inject);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intr_vmexit);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmenter_failed);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_invlpga);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_skinit);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intercepts);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_write_tsc_offset);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_ple_window_update);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_pml_full);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_pi_irte_update);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_unaccelerated_access);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_incomplete_ipi);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_ga_log);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_kick_vcpu_slowpath);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_doorbell);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_apicv_accept_irq);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_enter);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_enter);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_exit);
 
 static int __init kvm_x86_init(void)
 {
-- 
2.42.0.869.gea05f2083d-goog


