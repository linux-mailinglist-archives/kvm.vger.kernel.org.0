Return-Path: <kvm+bounces-72894-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ACxcJxzCqWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72894-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:49:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E905A2167B7
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:49:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 349AA31A5B48
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:44:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 314D43EBF0A;
	Thu,  5 Mar 2026 17:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HEbF0w7B"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF4A3E7145;
	Thu,  5 Mar 2026 17:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732678; cv=none; b=Yx0xstz8NdyNGR8kWr/IAPoS7+lST6Vxpbm6ilO0DjPZtUxvoJe5Xc1Bu9nHGkjBzm+F8ynM7rVen61+LQjQSfAyZC43XNGlk9glGlKDziPxaT5DrFj6lrWgQpVJZZv9LOoy39mKU3Bz3CIA95QtFqfQv1fPE2leutlQ8kqTAuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732678; c=relaxed/simple;
	bh=KiZ6mxChNOoAxPa9NRJAAiG7+zC6bTu4ZfRSLi+aGFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwVmZ/PriEiTZV52SAgzcIPcF9tuNje+NjzV9VPPr65dcLEfrC1/AZOUX1hNI/KpAqSEfjdPOfTDOS5hWVuQLKk7LTtljPtmhEeVHEIW+46vX4UdrJpDKJ2GC+UfT+Qy4r4meY3dgS4ZGNEpqXzhCddIA8Ox3E3ZlETdtaCT8FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HEbF0w7B; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732676; x=1804268676;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KiZ6mxChNOoAxPa9NRJAAiG7+zC6bTu4ZfRSLi+aGFE=;
  b=HEbF0w7BKINZrj9zdWZ6gzqY8Ld1lFNIAZYl11BFMWPWoZ+bunIiZKHY
   Y5vP3WdYYPx85zN6ca5ovvWlUDJTmkPWKAAi5pfJio1E6pWG9s+hQT7nu
   mukAuLY2s8p91mWr0GWPyBNHiXe8tKv4JnVtlW8+Q4lM9cDRLIf5o6ATG
   98t63BBsMHzFO4IagQ8huRujOwLXuC+zJz9n+1JiW0dcivC2Bx1UHdgMY
   ZqYezEJxAERZb7aQ9pfX0lH/ETNfNWTLfEft8k97B9W1d6gDYousQbcJw
   ZCmqEQ+fH+5sxrXVFJrpAt3WPxUJsZxWJXVAEryb9oA0YJgUwt/f5uXwV
   Q==;
X-CSE-ConnectionGUID: EMEqXVJlQDuFypaVWU4aXQ==
X-CSE-MsgGUID: Oliy7TI6S3y860YB1J5ZfA==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="73798213"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="73798213"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:35 -0800
X-CSE-ConnectionGUID: mwh/N/jnS02BZtwxnQBE9w==
X-CSE-MsgGUID: 1pWExwllQX6dF9Kl36aAeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="215527254"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:35 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 08/36] KVM: nVMX: Disallow/allow guest APIC timer virtualization switch to/from L2
Date: Thu,  5 Mar 2026 09:43:48 -0800
Message-ID: <242a86c98c9b3e8306aa39b01563a98c7ab87ecc.1772732517.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1772732517.git.isaku.yamahata@intel.com>
References: <cover.1772732517.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E905A2167B7
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72894-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Disable guest APIC timer virtualization on nested VMEnter, enable it on
nested vmexit.

With VMX APIC timer virtualization, the CPU directly injects a guest timer
interrupt without VMExit.  When the L1 APIC timer fires while running the
nested (L2) vCPU, KVM should emulate VMExit from L2 to L1.  Switch to the
hv timer (preemption timer) or the sw timer when VMEntering from L1 to L2,
switch to guest APIC timer virtualization when VM exiting from L2 to L1.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
--
Changes v1->v2:
- Use EXPORT_SYMBOL_FOR_KVM_INTERNAL() instead of EXPORT_SYMBOL_GPL().
- Add in-kernel apic check.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/lapic.c      | 35 +++++++++++++++++++++++++++++++++++
 arch/x86/kvm/lapic.h      |  2 ++
 arch/x86/kvm/vmx/nested.c | 13 +++++++++++++
 arch/x86/kvm/vmx/vmx.c    |  5 +++++
 4 files changed, 55 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index a3c1a81e63e2..03667ca6357e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1909,6 +1909,41 @@ static void apic_cancel_apic_virt_timer(struct kvm_lapic *apic)
 	start_apic_timer(apic);
 }
 
+void kvm_sync_apic_virt_timer(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+
+	WARN_ON_ONCE(is_guest_mode(vcpu));
+
+	if (!lapic_in_kernel(vcpu))
+		return;
+
+	if (!apic->lapic_timer.apic_virt_timer_in_use)
+		return;
+
+	apic->lapic_timer.tscdeadline = kvm_x86_call(get_guest_tsc_deadline_virt)(vcpu);
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_sync_apic_virt_timer);
+
+void kvm_cancel_apic_virt_timer(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+
+	WARN_ON_ONCE(!is_guest_mode(vcpu));
+
+	if (!lapic_in_kernel(vcpu))
+		return;
+
+	if (!apic->lapic_timer.apic_virt_timer_in_use)
+		return;
+
+	apic->lapic_timer.apic_virt_timer_in_use = false;
+	trace_kvm_apic_virt_timer_state(vcpu->vcpu_id, false);
+
+	start_apic_timer(apic);
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_cancel_apic_virt_timer);
+
 static void apic_set_apic_virt_timer(struct kvm_lapic *apic)
 {
 	struct kvm_timer *ktimer = &apic->lapic_timer;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 0571b7438328..8e7ee5f3a01d 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -260,6 +260,8 @@ void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu);
 bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu);
 void kvm_lapic_restart_hv_timer(struct kvm_vcpu *vcpu);
 void kvm_update_apic_virt_timer(struct kvm_vcpu *vcpu);
+void kvm_sync_apic_virt_timer(struct kvm_vcpu *vcpu);
+void kvm_cancel_apic_virt_timer(struct kvm_vcpu *vcpu);
 
 static inline bool kvm_lapic_apic_virt_timer_in_use(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 101588914cbb..c475b8c94807 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3656,6 +3656,8 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	if (!enable_ept)
 		vmcs_writel(GUEST_CR3, vcpu->arch.cr3);
 
+	kvm_sync_apic_virt_timer(vcpu);
+
 	vmx_switch_vmcs(vcpu, &vmx->nested.vmcs02);
 
 	prepare_vmcs02_early(vmx, &vmx->vmcs01, vmcs12);
@@ -3731,6 +3733,14 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 		vmx_start_preemption_timer(vcpu, timer_value);
 	}
 
+	/*
+	 * Disable apic virtual timer for L1 to use sw timer (hr timer) or
+	 * hypervisor timer (VMX preemption timer).
+	 * When L1 timer interrupt occurs during running L2, KVM emulates
+	 * VMExit from L2 to L1.  Not directly injecting the interrupt into L2.
+	 */
+	kvm_cancel_apic_virt_timer(vcpu);
+
 	/*
 	 * Note no nested_vmx_succeed or nested_vmx_fail here. At this point
 	 * we are no longer running L1, and VMLAUNCH/VMRESUME has not yet
@@ -5158,6 +5168,9 @@ void __nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	/* in case we halted in L2 */
 	kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
 
+	/* If apic virtual timer is supported, switch back to it. */
+	kvm_update_apic_virt_timer(vcpu);
+
 	if (likely(!vmx->fail)) {
 		if (vm_exit_reason != -1)
 			trace_kvm_nested_vmexit_inject(vmcs12->vm_exit_reason,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5d36f2b632e9..9d5a493b6fe5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8373,6 +8373,9 @@ bool vmx_can_use_apic_virt_timer(struct kvm_vcpu *vcpu)
 	if (vcpu->kvm->arch.vm_type != KVM_X86_DEFAULT_VM)
 		return false;
 
+	if (is_guest_mode(vcpu))
+		return false;
+
 	return cpu_has_vmx_apic_timer_virt() &&
 		/* SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY and in-kernel apic */
 		kvm_vcpu_apicv_active(vcpu) &&
@@ -8384,6 +8387,8 @@ bool vmx_can_use_apic_virt_timer(struct kvm_vcpu *vcpu)
 
 void vmx_set_apic_virt_timer(struct kvm_vcpu *vcpu, u16 vector)
 {
+	WARN_ON_ONCE(is_guest_mode(vcpu));
+
 	vmcs_write16(GUEST_APIC_TIMER_VECTOR, vector);
 	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_TSC_DEADLINE, MSR_TYPE_RW);
 	tertiary_exec_controls_setbit(to_vmx(vcpu), TERTIARY_EXEC_GUEST_APIC_TIMER);
-- 
2.45.2


