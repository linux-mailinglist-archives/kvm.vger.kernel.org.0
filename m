Return-Path: <kvm+bounces-70499-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mNOULDs+hmnzLAQAu9opvQ
	(envelope-from <kvm+bounces-70499-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:17:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 29A5F102963
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:17:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5CD0430DF7F8
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 19:11:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08A46441032;
	Fri,  6 Feb 2026 19:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Pqyun2A5"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1730C441024
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 19:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770404986; cv=none; b=KGCSGrU6/BFJdN+rSeChk14bsXi0ZqujJAaDBvW0veyoRI1lMd6o3uBVyg3vcBLOrdY7BwHK+I+I7hIAcX1uhW9Qx00+hL/i5jZ0TkSa76sw88UmNfxeeSF+sxPLn46iPHR0/03+1xxBkLxGetpBZ2HDHqbR+Iq3tOFEgX28iCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770404986; c=relaxed/simple;
	bh=JUDT+7Eh/cU+Y4SWZVSQLxL80w6YiNf4szRRp1A7WjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tpmc2Gri/LTNrCrctE6sIO53HC5Vh13znDV74cqAyQwcYuTYRv349m1Unk2nbCc7YX3rn7tzwRq7oYt8HsrV/mi6O0jdkLOHLon3Wtt2TidFJwGUqB6tjpB0ruRe5pvkrCkQpukf9jVucT7qxEKq6rHPIhA/sKEBFHriYrCL89Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Pqyun2A5; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770404984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j/tWCaP02zzkvXRIhMh2iPl6Wt9VXsdZeGUi4/BxY64=;
	b=Pqyun2A5z1wazY7AQjXzqRRD+3Hc+w8mq7Y8eO4QWhdgK0ObVra3MKD4Z+nYCZ6fpYRmos
	kstZdDb6qQBvOieLzkd20jHg4CASW3zM3G9ChViSnIANuuLKEZbOWyjWxIr2LWnJ5ZkAl5
	Snp4f1IYc6fMfpQaIf3A7F+Jl88qGO0=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v5 21/26] KVM: SVM: Rename vmcb->nested_ctl to vmcb->misc_ctl
Date: Fri,  6 Feb 2026 19:08:46 +0000
Message-ID: <20260206190851.860662-22-yosry.ahmed@linux.dev>
In-Reply-To: <20260206190851.860662-1-yosry.ahmed@linux.dev>
References: <20260206190851.860662-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70499-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	NEURAL_HAM(-0.00)[-0.996];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 29A5F102963
X-Rspamd-Action: no action

The 'nested_ctl' field is misnamed. Although the first bit is for nested
paging, the other defined bits are for SEV/SEV-ES. Other bits in the
same field according to the APM (but not defined by KVM) include "Guest
Mode Execution Trap", "Enable INVLPGB/TLBSYNC", and other control bits
unrelated to 'nested'.

There is nothing common among these bits, so just name the field
misc_ctl. Also rename the flags accordingly.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/include/asm/svm.h                    |  8 ++++----
 arch/x86/kvm/svm/nested.c                     | 14 +++++++-------
 arch/x86/kvm/svm/sev.c                        |  4 ++--
 arch/x86/kvm/svm/svm.c                        |  4 ++--
 arch/x86/kvm/svm/svm.h                        |  4 ++--
 tools/testing/selftests/kvm/include/x86/svm.h |  6 +++---
 tools/testing/selftests/kvm/lib/x86/svm.c     |  2 +-
 7 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index edde36097ddc..983db6575141 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -142,7 +142,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u64 exit_info_2;
 	u32 exit_int_info;
 	u32 exit_int_info_err;
-	u64 nested_ctl;
+	u64 misc_ctl;
 	u64 avic_vapic_bar;
 	u64 ghcb_gpa;
 	u32 event_inj;
@@ -239,9 +239,9 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_IOIO_SIZE_MASK (7 << SVM_IOIO_SIZE_SHIFT)
 #define SVM_IOIO_ASIZE_MASK (7 << SVM_IOIO_ASIZE_SHIFT)
 
-#define SVM_NESTED_CTL_NP_ENABLE	BIT(0)
-#define SVM_NESTED_CTL_SEV_ENABLE	BIT(1)
-#define SVM_NESTED_CTL_SEV_ES_ENABLE	BIT(2)
+#define SVM_MISC_ENABLE_NP		BIT(0)
+#define SVM_MISC_ENABLE_SEV		BIT(1)
+#define SVM_MISC_ENABLE_SEV_ES	BIT(2)
 
 
 #define SVM_TSC_RATIO_RSVD	0xffffff0000000000ULL
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 42f0dbd86a89..10673615ab39 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -399,7 +399,7 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 	if (CC(control->asid == 0))
 		return false;
 
-	if (control->nested_ctl & SVM_NESTED_CTL_NP_ENABLE) {
+	if (control->misc_ctl & SVM_MISC_ENABLE_NP) {
 		if (CC(!kvm_vcpu_is_legal_gpa(vcpu, control->nested_cr3)))
 			return false;
 		if (CC(!(l1_cr0 & X86_CR0_PG)))
@@ -494,10 +494,10 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 	nested_svm_sanitize_intercept(vcpu, to, SKINIT);
 	nested_svm_sanitize_intercept(vcpu, to, RDPRU);
 
-	/* Always clear SVM_NESTED_CTL_NP_ENABLE if the guest cannot use NPTs */
-	to->nested_ctl          = from->nested_ctl;
+	/* Always clear SVM_MISC_ENABLE_NP if the guest cannot use NPTs */
+	to->misc_ctl = from->misc_ctl;
 	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_NPT))
-		to->nested_ctl &= ~SVM_NESTED_CTL_NP_ENABLE;
+		to->misc_ctl &= ~SVM_MISC_ENABLE_NP;
 
 	to->iopm_base_pa        = from->iopm_base_pa;
 	to->msrpm_base_pa       = from->msrpm_base_pa;
@@ -833,7 +833,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	}
 
 	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
-	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
+	vmcb02->control.misc_ctl = vmcb01->control.misc_ctl;
 	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
 	vmcb02->control.msrpm_base_pa = vmcb01->control.msrpm_base_pa;
 	vmcb_mark_dirty(vmcb02, VMCB_PERM_MAP);
@@ -989,7 +989,7 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 				 vmcb12->save.rip,
 				 vmcb12->control.int_ctl,
 				 vmcb12->control.event_inj,
-				 vmcb12->control.nested_ctl,
+				 vmcb12->control.misc_ctl,
 				 vmcb12->control.nested_cr3,
 				 vmcb12->save.cr3,
 				 KVM_ISA_SVM);
@@ -1801,7 +1801,7 @@ static void nested_copy_vmcb_cache_to_control(struct vmcb_control_area *dst,
 	dst->exit_info_2          = from->exit_info_2;
 	dst->exit_int_info        = from->exit_int_info;
 	dst->exit_int_info_err    = from->exit_int_info_err;
-	dst->nested_ctl           = from->nested_ctl;
+	dst->misc_ctl		  = from->misc_ctl;
 	dst->event_inj            = from->event_inj;
 	dst->event_inj_err        = from->event_inj_err;
 	dst->next_rip             = from->next_rip;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ea515cf41168..0ed9cfed1cbc 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4599,7 +4599,7 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm, bool init_event)
 	struct kvm_sev_info *sev = to_kvm_sev_info(svm->vcpu.kvm);
 	struct vmcb *vmcb = svm->vmcb01.ptr;
 
-	svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ES_ENABLE;
+	svm->vmcb->control.misc_ctl |= SVM_MISC_ENABLE_SEV_ES;
 
 	/*
 	 * An SEV-ES guest requires a VMSA area that is a separate from the
@@ -4670,7 +4670,7 @@ void sev_init_vmcb(struct vcpu_svm *svm, bool init_event)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
-	svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ENABLE;
+	svm->vmcb->control.misc_ctl |= SVM_MISC_ENABLE_SEV;
 	clr_exception_intercept(svm, UD_VECTOR);
 
 	/*
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a534c08fbe61..c9120dc3d6ff 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1152,7 +1152,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu, bool init_event)
 
 	if (npt_enabled) {
 		/* Setup VMCB for Nested Paging */
-		control->nested_ctl |= SVM_NESTED_CTL_NP_ENABLE;
+		control->misc_ctl |= SVM_MISC_ENABLE_NP;
 		svm_clr_intercept(svm, INTERCEPT_INVLPG);
 		clr_exception_intercept(svm, PF_VECTOR);
 		svm_clr_intercept(svm, INTERCEPT_CR3_READ);
@@ -3358,7 +3358,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%016llx\n", "exit_info2:", control->exit_info_2);
 	pr_err("%-20s%08x\n", "exit_int_info:", control->exit_int_info);
 	pr_err("%-20s%08x\n", "exit_int_info_err:", control->exit_int_info_err);
-	pr_err("%-20s%lld\n", "nested_ctl:", control->nested_ctl);
+	pr_err("%-20s%lld\n", "misc_ctl:", control->misc_ctl);
 	pr_err("%-20s%016llx\n", "nested_cr3:", control->nested_cr3);
 	pr_err("%-20s%016llx\n", "avic_vapic_bar:", control->avic_vapic_bar);
 	pr_err("%-20s%016llx\n", "ghcb:", control->ghcb_gpa);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0a5d5a4453b7..f66e5c8565aa 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -167,7 +167,7 @@ struct vmcb_ctrl_area_cached {
 	u64 exit_info_2;
 	u32 exit_int_info;
 	u32 exit_int_info_err;
-	u64 nested_ctl;
+	u64 misc_ctl;
 	u32 event_inj;
 	u32 event_inj_err;
 	u64 next_rip;
@@ -579,7 +579,7 @@ static inline bool gif_set(struct vcpu_svm *svm)
 
 static inline bool nested_npt_enabled(struct vcpu_svm *svm)
 {
-	return svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
+	return svm->nested.ctl.misc_ctl & SVM_MISC_ENABLE_NP;
 }
 
 static inline bool nested_vnmi_enabled(struct vcpu_svm *svm)
diff --git a/tools/testing/selftests/kvm/include/x86/svm.h b/tools/testing/selftests/kvm/include/x86/svm.h
index 10b30b38bb3f..d81d8a9f5bfb 100644
--- a/tools/testing/selftests/kvm/include/x86/svm.h
+++ b/tools/testing/selftests/kvm/include/x86/svm.h
@@ -97,7 +97,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u64 exit_info_2;
 	u32 exit_int_info;
 	u32 exit_int_info_err;
-	u64 nested_ctl;
+	u64 misc_ctl;
 	u64 avic_vapic_bar;
 	u8 reserved_4[8];
 	u32 event_inj;
@@ -175,8 +175,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_VM_CR_SVM_LOCK_MASK 0x0008ULL
 #define SVM_VM_CR_SVM_DIS_MASK  0x0010ULL
 
-#define SVM_NESTED_CTL_NP_ENABLE	BIT(0)
-#define SVM_NESTED_CTL_SEV_ENABLE	BIT(1)
+#define SVM_MISC_ENABLE_NP		BIT(0)
+#define SVM_MISC_ENABLE_SEV		BIT(1)
 
 struct __attribute__ ((__packed__)) vmcb_seg {
 	u16 selector;
diff --git a/tools/testing/selftests/kvm/lib/x86/svm.c b/tools/testing/selftests/kvm/lib/x86/svm.c
index 2e5c480c9afd..eb20b00112c7 100644
--- a/tools/testing/selftests/kvm/lib/x86/svm.c
+++ b/tools/testing/selftests/kvm/lib/x86/svm.c
@@ -126,7 +126,7 @@ void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_r
 	guest_regs.rdi = (u64)svm;
 
 	if (svm->ncr3_gpa) {
-		ctrl->nested_ctl |= SVM_NESTED_CTL_NP_ENABLE;
+		ctrl->misc_ctl |= SVM_MISC_ENABLE_NP;
 		ctrl->nested_cr3 = svm->ncr3_gpa;
 	}
 }
-- 
2.53.0.rc2.204.g2597b5adb4-goog


