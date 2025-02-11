Return-Path: <kvm+bounces-37788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BDB50A301CF
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 03:57:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5BD151695BC
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 02:57:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B7CC1D5ABA;
	Tue, 11 Feb 2025 02:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nB+V6w6Q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C601CAA60;
	Tue, 11 Feb 2025 02:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739242631; cv=none; b=rZfhbr79RGTT8d0JIAYa9P6s+GqkTbPt0ZttGcgZxnoxFAFV4o4xeZ3IMW+1yDvkOmfDqPRyFHvkxsvG0GqtsQrwo2r39pHZPQA08Sc73wl8Dt7ifXvRNNSf2UNL3swRSlfhNWNBXslKSo2fANorTScpInGNBS3kzf48ROtntKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739242631; c=relaxed/simple;
	bh=beqpcPbpt0kBQ99FPCRb6pHXTrCzsCNX64wYsTdCyQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7QQjTqKFhlJgr1cwc7lSkKzF0I6Suz7GyKu08Ketcs0YgHu8tV41dI+mQQRa3wm96mSpeU1/5FFrU1T0M8K6Y4JhGD9D/kxhTjlzaTOUI3Tw7WlVkFJEZMHcpEraC+AnMDLbwF4Dz3jJrj9vTAx8PIfYyEukoJ2hJwLP0U0qVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nB+V6w6Q; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739242630; x=1770778630;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=beqpcPbpt0kBQ99FPCRb6pHXTrCzsCNX64wYsTdCyQQ=;
  b=nB+V6w6Q6hW+O+NtXgUTZUVj2VusMaOlz6wrH4RBEfTHMmYIUCLgjDDR
   uZlzg0iAOkEA/MBpBQazyyvbsLJSRP4ZQLnYeuKtRoLfGjJ/FCJ8vs90g
   EC65fEQbq8Ei/VBR4XnBRFx3oyYkmsnqb+GjUPobZw8ZhAZ7+WayfYl6B
   viMUCWM+iso7wBcqlRDjCA9Mlt9VdBsaAxAJkUh7gl7gt6NSY4ZpQLygb
   U71kubxmxpFMckaQbdfprVVHJOBuDKNucpe3ytj50d/vTJB5RIc9hArYD
   UrveK4hDrgQezoBVBQmcP9HKckeVn5KYtyvTlMMHo5SKau6ZwdcP0WKYu
   g==;
X-CSE-ConnectionGUID: NEw+sgu+SkKaUOeyLmQQeg==
X-CSE-MsgGUID: +xH4Iy8rQra+4KfvW3Vkiw==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="43612434"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="43612434"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:57:10 -0800
X-CSE-ConnectionGUID: aygf2mLsSFuJ11YlnZ88ug==
X-CSE-MsgGUID: j4m3eTwKQeyOgaKTYlrPdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="112355246"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:56:51 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH v2 01/17] KVM: TDX: Add support for find pending IRQ in a protected local APIC
Date: Tue, 11 Feb 2025 10:58:12 +0800
Message-ID: <20250211025828.3072076-2-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
References: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

Add flag and hook to KVM's local APIC management to support determining
whether or not a TDX guest has a pending IRQ.  For TDX vCPUs, the virtual
APIC page is owned by the TDX module and cannot be accessed by KVM.  As a
result, registers that are virtualized by the CPU, e.g. PPR, cannot be
read or written by KVM.  To deliver interrupts for TDX guests, KVM must
send an IRQ to the CPU on the posted interrupt notification vector.  And
to determine if TDX vCPU has a pending interrupt, KVM must check if there
is an outstanding notification.

Return "no interrupt" in kvm_apic_has_interrupt() if the guest APIC is
protected to short-circuit the various other flows that try to pull an
IRQ out of the vAPIC, the only valid operation is querying _if_ an IRQ is
pending, KVM can't do anything based on _which_ IRQ is pending.

Intentionally omit sanity checks from other flows, e.g. PPR update, so as
not to degrade non-TDX guests with unnecessary checks.  A well-behaved KVM
and userspace will never reach those flows for TDX guests, but reaching
them is not fatal if something does go awry.

Note, this doesn't handle interrupts that have been delivered to the vCPU
but not yet recognized by the core, i.e. interrupts that are sitting in
vmcs.GUEST_INTR_STATUS.  Querying that state requires a SEAMCALL and will
be supported in a future patch.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX interrupts v2:
 - Fix a typo in changelog.

TDX interrupts v1:
 - Dropped vt_protected_apic_has_interrupt() with KVM_BUG_ON(), wire in
   tdx_protected_apic_has_interrupt() directly. (Rick)
 - Add {} on else in vt_hardware_setup()
---
 arch/x86/include/asm/kvm-x86-ops.h | 1 +
 arch/x86/include/asm/kvm_host.h    | 1 +
 arch/x86/kvm/irq.c                 | 3 +++
 arch/x86/kvm/lapic.c               | 3 +++
 arch/x86/kvm/lapic.h               | 2 ++
 arch/x86/kvm/vmx/main.c            | 3 +++
 arch/x86/kvm/vmx/tdx.c             | 6 ++++++
 arch/x86/kvm/vmx/x86_ops.h         | 2 ++
 8 files changed, 21 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index d953a454bafb..2eaabff66c82 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -115,6 +115,7 @@ KVM_X86_OP_OPTIONAL(pi_start_assignment)
 KVM_X86_OP_OPTIONAL(apicv_pre_state_restore)
 KVM_X86_OP_OPTIONAL(apicv_post_state_restore)
 KVM_X86_OP_OPTIONAL_RET0(dy_apicv_has_pending_interrupt)
+KVM_X86_OP_OPTIONAL(protected_apic_has_interrupt)
 KVM_X86_OP_OPTIONAL(set_hv_timer)
 KVM_X86_OP_OPTIONAL(cancel_hv_timer)
 KVM_X86_OP(setup_mce)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e855866bf600..ad275b606d68 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1838,6 +1838,7 @@ struct kvm_x86_ops {
 	void (*apicv_pre_state_restore)(struct kvm_vcpu *vcpu);
 	void (*apicv_post_state_restore)(struct kvm_vcpu *vcpu);
 	bool (*dy_apicv_has_pending_interrupt)(struct kvm_vcpu *vcpu);
+	bool (*protected_apic_has_interrupt)(struct kvm_vcpu *vcpu);
 
 	int (*set_hv_timer)(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
 			    bool *expired);
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 63f66c51975a..f0644d0bbe11 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -100,6 +100,9 @@ int kvm_cpu_has_interrupt(struct kvm_vcpu *v)
 	if (kvm_cpu_has_extint(v))
 		return 1;
 
+	if (lapic_in_kernel(v) && v->arch.apic->guest_apic_protected)
+		return static_call(kvm_x86_protected_apic_has_interrupt)(v);
+
 	return kvm_apic_has_interrupt(v) != -1;	/* LAPIC */
 }
 EXPORT_SYMBOL_GPL(kvm_cpu_has_interrupt);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index a1cbca31ec30..bbdede07d063 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2967,6 +2967,9 @@ int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
 	if (!kvm_apic_present(vcpu))
 		return -1;
 
+	if (apic->guest_apic_protected)
+		return -1;
+
 	__apic_update_ppr(apic, &ppr);
 	return apic_has_interrupt_for_ppr(apic, ppr);
 }
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 1a8553ebdb42..e33c969439f7 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -65,6 +65,8 @@ struct kvm_lapic {
 	bool sw_enabled;
 	bool irr_pending;
 	bool lvt0_in_nmi_mode;
+	/* Select registers in the vAPIC cannot be read/written. */
+	bool guest_apic_protected;
 	/* Number of bits set in ISR. */
 	s16 isr_count;
 	/* The highest vector set in ISR; if -1 - invalid, must scan ISR. */
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 7f1318c44040..2b1ea57a3a4e 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -62,6 +62,8 @@ static __init int vt_hardware_setup(void)
 		vt_x86_ops.set_external_spte = tdx_sept_set_private_spte;
 		vt_x86_ops.free_external_spt = tdx_sept_free_private_spt;
 		vt_x86_ops.remove_external_spte = tdx_sept_remove_private_spte;
+	} else {
+		vt_x86_ops.protected_apic_has_interrupt = NULL;
 	}
 
 	return 0;
@@ -371,6 +373,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.sync_pir_to_irr = vmx_sync_pir_to_irr,
 	.deliver_interrupt = vmx_deliver_interrupt,
 	.dy_apicv_has_pending_interrupt = pi_has_pending_interrupt,
+	.protected_apic_has_interrupt = tdx_protected_apic_has_interrupt,
 
 	.set_tss_addr = vmx_set_tss_addr,
 	.set_identity_map_addr = vmx_set_identity_map_addr,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 8f3147c6e602..6940ce812730 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -668,6 +668,7 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 
 	fpstate_set_confidential(&vcpu->arch.guest_fpu);
+	vcpu->arch.apic->guest_apic_protected = true;
 
 	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
 
@@ -709,6 +710,11 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	local_irq_enable();
 }
 
+bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
+{
+	return pi_has_pending_interrupt(vcpu);
+}
+
 /*
  * Compared to vmx_prepare_switch_to_guest(), there is not much to do
  * as SEAMCALL/SEAMRET calls take care of most of save and restore.
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 92716f6486e9..8086e5c58cd6 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -135,6 +135,7 @@ int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu);
 fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit);
 void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
 void tdx_vcpu_put(struct kvm_vcpu *vcpu);
+bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu);
 int tdx_handle_exit(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion fastpath);
 void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
@@ -173,6 +174,7 @@ static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediat
 }
 static inline void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
+static inline bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu) { return false; }
 static inline int tdx_handle_exit(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion fastpath) { return 0; }
 static inline void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason, u64 *info1,
-- 
2.46.0


