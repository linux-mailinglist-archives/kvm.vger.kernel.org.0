Return-Path: <kvm+bounces-71700-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SDK/Fsgonmn5TgQAu9opvQ
	(envelope-from <kvm+bounces-71700-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:40:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 290EF18D7C4
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:40:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 17C2F30A856D
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 22:37:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72A6F3ACF13;
	Tue, 24 Feb 2026 22:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qr+9HrcZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3312A3A1E82;
	Tue, 24 Feb 2026 22:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771972471; cv=none; b=Ukj+Izcg5mcX9fcPCc2WU7fkcdAHJz+pNo2B6Aj+M2JetlYX91mQzuPk0l1y704RH/LOX/YgWghI0F1aaN/u8imf2x5onRU0fEMBewyu5/TxRpcZBEQnjgM01WeMJ8aNIKE+9Y4Yy1Lc1g2hw0WEEt9NwxFJw3APAKAN5N1c+ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771972471; c=relaxed/simple;
	bh=yp8GpW6eTx61cSDikx3my3G1B8Y0aqzVvQBCkxnm7iA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tjLV23KvnMXaIlTlzb0vpGqqARh/c1PiMT3bYnMDj7WzcpoyZ9Pnrk/1CtrpAglv9xtNO5FCu04kWWYh/ETDvoIAO36gY8sBMmsbcaJe2Nvcrg92oBDmpJt7MdI++/VjOh3ojy7q2dXbHoizMu1Nizi/Le0MCdARfNqsYrKNdK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qr+9HrcZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9BFC116D0;
	Tue, 24 Feb 2026 22:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771972471;
	bh=yp8GpW6eTx61cSDikx3my3G1B8Y0aqzVvQBCkxnm7iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qr+9HrcZriySJm4io98YLZydHdxQwI/EYFrbAS3Xd75swJeBKF2y5fN7uFlFmonm0
	 OXFoAcZdR8P+Tpzrh8XbPpuvXMk4nNlLFH7XG4DN8jxaru7oN5THTOn8dnt5Y50Zp2
	 bLnio/UOlE0arQB8TIabv7Tc52+0sTuMIe04P/XmgjVcbkqpSuMt7v96FdmNa/rAZv
	 MMclVuGud3zxg08xE9z0Tsy6BKI22N0cRauMZWoJUP46FdCgOuphqXWVGIh3jGNAS3
	 roc/ugloRe0sJEiricEu+DrQIQXl+A9YANAxiYv96Wspz+BNQudT/m3XFBRSwfg4cT
	 9tXAzw5DEZp3g==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v6 24/31] KVM: SVM: Rename vmcb->virt_ext to vmcb->misc_ctl2
Date: Tue, 24 Feb 2026 22:33:58 +0000
Message-ID: <20260224223405.3270433-25-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
In-Reply-To: <20260224223405.3270433-1-yosry@kernel.org>
References: <20260224223405.3270433-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71700-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 290EF18D7C4
X-Rspamd-Action: no action

'virt' is confusing in the VMCB because it is relative and ambiguous.
The 'virt_ext' field includes bits for LBR virtualization and
VMSAVE/VMLOAD virtualization, so it's just another miscellaneous control
field. Name it as such.

While at it, move the definitions of the bits below those for
'misc_ctl' and rename them for consistency.

Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/include/asm/svm.h                    |  7 +++----
 arch/x86/kvm/svm/nested.c                     | 16 +++++++--------
 arch/x86/kvm/svm/svm.c                        | 20 +++++++++----------
 arch/x86/kvm/svm/svm.h                        |  2 +-
 tools/testing/selftests/kvm/include/x86/svm.h |  8 ++++----
 .../kvm/x86/nested_vmsave_vmload_test.c       | 16 +++++++--------
 .../selftests/kvm/x86/svm_lbr_nested_state.c  |  4 ++--
 7 files changed, 36 insertions(+), 37 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 983db6575141d..c169256c415fb 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -148,7 +148,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u32 event_inj;
 	u32 event_inj_err;
 	u64 nested_cr3;
-	u64 virt_ext;
+	u64 misc_ctl2;
 	u32 clean;
 	u32 reserved_5;
 	u64 next_rip;
@@ -222,9 +222,6 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define X2APIC_MODE_SHIFT 30
 #define X2APIC_MODE_MASK (1 << X2APIC_MODE_SHIFT)
 
-#define LBR_CTL_ENABLE_MASK BIT_ULL(0)
-#define VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK BIT_ULL(1)
-
 #define SVM_INTERRUPT_SHADOW_MASK	BIT_ULL(0)
 #define SVM_GUEST_INTERRUPT_MASK	BIT_ULL(1)
 
@@ -243,6 +240,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_MISC_ENABLE_SEV		BIT(1)
 #define SVM_MISC_ENABLE_SEV_ES	BIT(2)
 
+#define SVM_MISC2_ENABLE_V_LBR	BIT_ULL(0)
+#define SVM_MISC2_ENABLE_V_VMLOAD_VMSAVE	BIT_ULL(1)
 
 #define SVM_TSC_RATIO_RSVD	0xffffff0000000000ULL
 #define SVM_TSC_RATIO_MIN	0x0000000000000001ULL
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 099cdab878d45..679ac9f6dfe80 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -116,7 +116,7 @@ static bool nested_vmcb_needs_vls_intercept(struct vcpu_svm *svm)
 	if (!nested_npt_enabled(svm))
 		return true;
 
-	if (!(svm->nested.ctl.virt_ext & VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK))
+	if (!(svm->nested.ctl.misc_ctl2 & SVM_MISC2_ENABLE_V_VMLOAD_VMSAVE))
 		return true;
 
 	return false;
@@ -179,7 +179,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
 		vmcb_set_intercept(c, INTERCEPT_VMLOAD);
 		vmcb_set_intercept(c, INTERCEPT_VMSAVE);
 	} else {
-		WARN_ON(!(c->virt_ext & VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK));
+		WARN_ON(!(c->misc_ctl2 & SVM_MISC2_ENABLE_V_VMLOAD_VMSAVE));
 	}
 }
 
@@ -516,7 +516,7 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 	to->event_inj_err       = from->event_inj_err;
 	to->next_rip            = from->next_rip;
 	to->nested_cr3          = from->nested_cr3;
-	to->virt_ext            = from->virt_ext;
+	to->misc_ctl2            = from->misc_ctl2;
 	to->pause_filter_count  = from->pause_filter_count;
 	to->pause_filter_thresh = from->pause_filter_thresh;
 
@@ -695,7 +695,7 @@ void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm)
 static bool nested_vmcb12_has_lbrv(struct kvm_vcpu *vcpu)
 {
 	return guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
-		(to_svm(vcpu)->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK);
+		(to_svm(vcpu)->nested.ctl.misc_ctl2 & SVM_MISC2_ENABLE_V_LBR);
 }
 
 static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
@@ -919,10 +919,10 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 			svm->soft_int_next_rip = vmcb12_rip;
 	}
 
-	/* LBR_CTL_ENABLE_MASK is controlled by svm_update_lbrv() */
+	/* SVM_MISC2_ENABLE_V_LBR is controlled by svm_update_lbrv() */
 
 	if (!nested_vmcb_needs_vls_intercept(svm))
-		vmcb02->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
+		vmcb02->control.misc_ctl2 |= SVM_MISC2_ENABLE_V_VMLOAD_VMSAVE;
 
 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_PAUSEFILTER))
 		pause_count12 = svm->nested.ctl.pause_filter_count;
@@ -1814,8 +1814,8 @@ static void nested_copy_vmcb_cache_to_control(struct vmcb_control_area *dst,
 	dst->event_inj            = from->event_inj;
 	dst->event_inj_err        = from->event_inj_err;
 	dst->next_rip             = from->next_rip;
-	dst->nested_cr3           = from->nested_cr3;
-	dst->virt_ext              = from->virt_ext;
+	dst->nested_cr3		  = from->nested_cr3;
+	dst->misc_ctl2		  = from->misc_ctl2;
 	dst->pause_filter_count   = from->pause_filter_count;
 	dst->pause_filter_thresh  = from->pause_filter_thresh;
 	/* 'clean' and 'hv_enlightenments' are not changed by KVM */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7bc8b72fe5ad8..94e14badddfa2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -710,7 +710,7 @@ void *svm_alloc_permissions_map(unsigned long size, gfp_t gfp_mask)
 static void svm_recalc_lbr_msr_intercepts(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	bool intercept = !(svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK);
+	bool intercept = !(svm->vmcb->control.misc_ctl2 & SVM_MISC2_ENABLE_V_LBR);
 
 	if (intercept == svm->lbr_msrs_intercepted)
 		return;
@@ -843,7 +843,7 @@ static void svm_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 
 static void __svm_enable_lbrv(struct kvm_vcpu *vcpu)
 {
-	to_svm(vcpu)->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
+	to_svm(vcpu)->vmcb->control.misc_ctl2 |= SVM_MISC2_ENABLE_V_LBR;
 }
 
 void svm_enable_lbrv(struct kvm_vcpu *vcpu)
@@ -855,16 +855,16 @@ void svm_enable_lbrv(struct kvm_vcpu *vcpu)
 static void __svm_disable_lbrv(struct kvm_vcpu *vcpu)
 {
 	KVM_BUG_ON(sev_es_guest(vcpu->kvm), vcpu->kvm);
-	to_svm(vcpu)->vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
+	to_svm(vcpu)->vmcb->control.misc_ctl2 &= ~SVM_MISC2_ENABLE_V_LBR;
 }
 
 void svm_update_lbrv(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	bool current_enable_lbrv = svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK;
+	bool current_enable_lbrv = svm->vmcb->control.misc_ctl2 & SVM_MISC2_ENABLE_V_LBR;
 	bool enable_lbrv = (svm->vmcb->save.dbgctl & DEBUGCTLMSR_LBR) ||
 			    (is_guest_mode(vcpu) && guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
-			    (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK));
+			    (svm->nested.ctl.misc_ctl2 & SVM_MISC2_ENABLE_V_LBR));
 
 	if (enable_lbrv && !current_enable_lbrv)
 		__svm_enable_lbrv(vcpu);
@@ -1023,7 +1023,7 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
 	}
 
 	/*
-	 * No need to toggle VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK here, it is
+	 * No need to toggle SVM_MISC2_ENABLE_V_VMLOAD_VMSAVE here, it is
 	 * always set if vls is enabled. If the intercepts are set, the bit is
 	 * meaningless anyway.
 	 */
@@ -1191,7 +1191,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu, bool init_event)
 	}
 
 	if (vls)
-		svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
+		svm->vmcb->control.misc_ctl2 |= SVM_MISC2_ENABLE_V_VMLOAD_VMSAVE;
 
 	if (vcpu->kvm->arch.bus_lock_detection_enabled)
 		svm_set_intercept(svm, INTERCEPT_BUSLOCK);
@@ -3368,7 +3368,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%016llx\n", "ghcb:", control->ghcb_gpa);
 	pr_err("%-20s%08x\n", "event_inj:", control->event_inj);
 	pr_err("%-20s%08x\n", "event_inj_err:", control->event_inj_err);
-	pr_err("%-20s%lld\n", "virt_ext:", control->virt_ext);
+	pr_err("%-20s%lld\n", "misc_ctl2:", control->misc_ctl2);
 	pr_err("%-20s%016llx\n", "next_rip:", control->next_rip);
 	pr_err("%-20s%016llx\n", "avic_backing_page:", control->avic_backing_page);
 	pr_err("%-20s%016llx\n", "avic_logical_id:", control->avic_logical_id);
@@ -4363,7 +4363,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 	 * VM-Exit), as running with the host's DEBUGCTL can negatively affect
 	 * guest state and can even be fatal, e.g. due to Bus Lock Detect.
 	 */
-	if (!(svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK) &&
+	if (!(svm->vmcb->control.misc_ctl2 & SVM_MISC2_ENABLE_V_LBR) &&
 	    vcpu->arch.host_debugctl != svm->vmcb->save.dbgctl)
 		update_debugctlmsr(svm->vmcb->save.dbgctl);
 
@@ -4394,7 +4394,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
 		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
 
-	if (!(svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK) &&
+	if (!(svm->vmcb->control.misc_ctl2 & SVM_MISC2_ENABLE_V_LBR) &&
 	    vcpu->arch.host_debugctl != svm->vmcb->save.dbgctl)
 		update_debugctlmsr(vcpu->arch.host_debugctl);
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f66e5c8565aad..304328c33e960 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -172,7 +172,7 @@ struct vmcb_ctrl_area_cached {
 	u32 event_inj_err;
 	u64 next_rip;
 	u64 nested_cr3;
-	u64 virt_ext;
+	u64 misc_ctl2;
 	u32 clean;
 	u64 bus_lock_rip;
 	union {
diff --git a/tools/testing/selftests/kvm/include/x86/svm.h b/tools/testing/selftests/kvm/include/x86/svm.h
index d81d8a9f5bfb6..c8539166270ea 100644
--- a/tools/testing/selftests/kvm/include/x86/svm.h
+++ b/tools/testing/selftests/kvm/include/x86/svm.h
@@ -103,7 +103,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u32 event_inj;
 	u32 event_inj_err;
 	u64 nested_cr3;
-	u64 virt_ext;
+	u64 misc_ctl2;
 	u32 clean;
 	u32 reserved_5;
 	u64 next_rip;
@@ -155,9 +155,6 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define AVIC_ENABLE_SHIFT 31
 #define AVIC_ENABLE_MASK (1 << AVIC_ENABLE_SHIFT)
 
-#define LBR_CTL_ENABLE_MASK BIT_ULL(0)
-#define VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK BIT_ULL(1)
-
 #define SVM_INTERRUPT_SHADOW_MASK 1
 
 #define SVM_IOIO_STR_SHIFT 2
@@ -178,6 +175,9 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_MISC_ENABLE_NP		BIT(0)
 #define SVM_MISC_ENABLE_SEV		BIT(1)
 
+#define SVM_MISC2_ENABLE_V_LBR BIT_ULL(0)
+#define SVM_MISC2_ENABLE_V_VMLOAD_VMSAVE BIT_ULL(1)
+
 struct __attribute__ ((__packed__)) vmcb_seg {
 	u16 selector;
 	u16 attrib;
diff --git a/tools/testing/selftests/kvm/x86/nested_vmsave_vmload_test.c b/tools/testing/selftests/kvm/x86/nested_vmsave_vmload_test.c
index 6764a48f9d4d9..71717118d6924 100644
--- a/tools/testing/selftests/kvm/x86/nested_vmsave_vmload_test.c
+++ b/tools/testing/selftests/kvm/x86/nested_vmsave_vmload_test.c
@@ -79,8 +79,8 @@ static void l1_guest_code(struct svm_test_data *svm)
 	svm->vmcb->control.intercept |= (BIT_ULL(INTERCEPT_VMSAVE) |
 					 BIT_ULL(INTERCEPT_VMLOAD));
 
-	 /* ..VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK cleared.. */
-	svm->vmcb->control.virt_ext &= ~VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
+	 /* ..SVM_MISC2_ENABLE_V_VMLOAD_VMSAVE cleared.. */
+	svm->vmcb->control.misc_ctl2 &= ~SVM_MISC2_ENABLE_V_VMLOAD_VMSAVE;
 
 	svm->vmcb->save.rip = (u64)l2_guest_code_vmsave;
 	run_guest(svm->vmcb, svm->vmcb_gpa);
@@ -90,8 +90,8 @@ static void l1_guest_code(struct svm_test_data *svm)
 	run_guest(svm->vmcb, svm->vmcb_gpa);
 	GUEST_ASSERT_EQ(svm->vmcb->control.exit_code, SVM_EXIT_VMLOAD);
 
-	/* ..and VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK set */
-	svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
+	/* ..and SVM_MISC2_ENABLE_V_VMLOAD_VMSAVE set */
+	svm->vmcb->control.misc_ctl2 |= SVM_MISC2_ENABLE_V_VMLOAD_VMSAVE;
 
 	svm->vmcb->save.rip = (u64)l2_guest_code_vmsave;
 	run_guest(svm->vmcb, svm->vmcb_gpa);
@@ -106,20 +106,20 @@ static void l1_guest_code(struct svm_test_data *svm)
 					  BIT_ULL(INTERCEPT_VMLOAD));
 
 	/*
-	 * Without VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK, the GPA will be
+	 * Without SVM_MISC2_ENABLE_V_VMLOAD_VMSAVE, the GPA will be
 	 * interpreted as an L1 GPA, so VMCB0 should be used.
 	 */
 	svm->vmcb->save.rip = (u64)l2_guest_code_vmcb0;
-	svm->vmcb->control.virt_ext &= ~VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
+	svm->vmcb->control.misc_ctl2 &= ~SVM_MISC2_ENABLE_V_VMLOAD_VMSAVE;
 	run_guest(svm->vmcb, svm->vmcb_gpa);
 	GUEST_ASSERT_EQ(svm->vmcb->control.exit_code, SVM_EXIT_VMMCALL);
 
 	/*
-	 * With VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK, the GPA will be interpeted as
+	 * With SVM_MISC2_ENABLE_V_VMLOAD_VMSAVE, the GPA will be interpeted as
 	 * an L2 GPA, and translated through the NPT to VMCB1.
 	 */
 	svm->vmcb->save.rip = (u64)l2_guest_code_vmcb1;
-	svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
+	svm->vmcb->control.misc_ctl2 |= SVM_MISC2_ENABLE_V_VMLOAD_VMSAVE;
 	run_guest(svm->vmcb, svm->vmcb_gpa);
 	GUEST_ASSERT_EQ(svm->vmcb->control.exit_code, SVM_EXIT_VMMCALL);
 
diff --git a/tools/testing/selftests/kvm/x86/svm_lbr_nested_state.c b/tools/testing/selftests/kvm/x86/svm_lbr_nested_state.c
index bf16abb1152e0..ff99438824d3a 100644
--- a/tools/testing/selftests/kvm/x86/svm_lbr_nested_state.c
+++ b/tools/testing/selftests/kvm/x86/svm_lbr_nested_state.c
@@ -69,9 +69,9 @@ static void l1_guest_code(struct svm_test_data *svm, bool nested_lbrv)
 			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
 
 	if (nested_lbrv)
-		vmcb->control.virt_ext = LBR_CTL_ENABLE_MASK;
+		vmcb->control.misc_ctl2 = SVM_MISC2_ENABLE_V_LBR;
 	else
-		vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
+		vmcb->control.misc_ctl2 &= ~SVM_MISC2_ENABLE_V_LBR;
 
 	run_guest(vmcb, svm->vmcb_gpa);
 	GUEST_ASSERT(svm->vmcb->control.exit_code == SVM_EXIT_VMMCALL);
-- 
2.53.0.414.gf7e9f6c205-goog


