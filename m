Return-Path: <kvm+bounces-62021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A5F2DC32DBB
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 21:01:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D4C791883ED3
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 20:01:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0238F2E92B3;
	Tue,  4 Nov 2025 20:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZCdENvJr"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95514223710
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 20:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762286416; cv=none; b=Y8D9C6IilJfZryzmId+c1qeyX333+CsaID/ZSzYR5o9HovFekNofwcM0+ZzLozI56CtJLExgZlR4btILrgSQfzoF3zTAhWEBJJpiTcqG+x8c0odz8nQzdtWaCkGAWtcqvebF+p/Useu/tXkdb+v2c8vm7wwRwc7PLOQFC/xjafY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762286416; c=relaxed/simple;
	bh=h0L/NkbhZdhTM9E/L975PlP8KgvJQ7ZzowLY6XRpgFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZ7DKDryqRbs4WwOdXvPwFYD026BVrmMmrLwfaQJsT4gPTd7D/7BoUWnhtD/XYIFEp4PckHKgQrxeP5GBu8zA8Huu8NNp1jc9CCLgDLfdMzNssBAASZaIxV/32hadf6Z4ZT5P42zcvNWwk9ztpBz/D7ZJZiwITHzWFc+7TLJBR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZCdENvJr; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762286412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ol7e08tK3xFYTuBVTR54hcOqGHK7zg3eFXRC0JQMPDs=;
	b=ZCdENvJr3mfHMNv+ArumPjZUITCCTuETMA6HT4jhAxuSqctKgYj1iCWrRyXHbMMt5/E7hP
	vrk2DobUIdTxMTfqMpkcXK1k+NBZF5fhU4TNPdLVIc85gP5TjFeWMBtr2WpVhL2iDp6dQD
	3J/cNSprXtmWaeKlEhfhIdQitiiU8mw=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 04/11] KVM: SVM: Rename vmcb->nested_ctl to vmcb->misc_ctl
Date: Tue,  4 Nov 2025 19:59:42 +0000
Message-ID: <20251104195949.3528411-5-yosry.ahmed@linux.dev>
In-Reply-To: <20251104195949.3528411-1-yosry.ahmed@linux.dev>
References: <20251104195949.3528411-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The 'nested_ctl' field is misnamed. Although the first bit is for nested
paging, the other defined bits are for SEV/SEV-ES. Other bits in the
same field according to the APM (but not defined by KVM) include "Guest
Mode Execution Trap", "Enable INVLPGB/TLBSYNC", and other control bits
unrelated to 'nested'.

There is nothing common among these bits, so just name the field
misc_ctl.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/include/asm/svm.h                    |  8 ++++----
 arch/x86/kvm/svm/nested.c                     | 10 +++++-----
 arch/x86/kvm/svm/sev.c                        |  4 ++--
 arch/x86/kvm/svm/svm.c                        |  4 ++--
 arch/x86/kvm/svm/svm.h                        |  4 ++--
 tools/testing/selftests/kvm/include/x86/svm.h |  6 +++---
 6 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 3a9441a8954f3..ead275da9850e 100644
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
@@ -236,9 +236,9 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_IOIO_SIZE_MASK (7 << SVM_IOIO_SIZE_SHIFT)
 #define SVM_IOIO_ASIZE_MASK (7 << SVM_IOIO_ASIZE_SHIFT)
 
-#define SVM_NESTED_CTL_NP_ENABLE	BIT(0)
-#define SVM_NESTED_CTL_SEV_ENABLE	BIT(1)
-#define SVM_NESTED_CTL_SEV_ES_ENABLE	BIT(2)
+#define SVM_MISC_CTL_NP_ENABLE		BIT(0)
+#define SVM_MISC_CTL_SEV_ENABLE		BIT(1)
+#define SVM_MISC_CTL_SEV_ES_ENABLE	BIT(2)
 
 
 #define SVM_TSC_RATIO_RSVD	0xffffff0000000000ULL
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 8641ac9331c5d..9e6b996753e4e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -364,7 +364,7 @@ static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 	if (CC(control->asid == 0))
 		return false;
 
-	if (control->nested_ctl & SVM_NESTED_CTL_NP_ENABLE) {
+	if (control->misc_ctl & SVM_MISC_CTL_NP_ENABLE) {
 		if (CC(!kvm_vcpu_is_legal_gpa(vcpu, control->nested_cr3)))
 			return false;
 		if (CC(!(l1_cr0 & X86_CR0_PG)))
@@ -474,7 +474,7 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 	to->exit_info_2         = from->exit_info_2;
 	to->exit_int_info       = from->exit_int_info;
 	to->exit_int_info_err   = from->exit_int_info_err;
-	to->nested_ctl          = from->nested_ctl;
+	to->misc_ctl          = from->misc_ctl;
 	to->event_inj           = from->event_inj;
 	to->event_inj_err       = from->event_inj_err;
 	to->next_rip            = from->next_rip;
@@ -800,7 +800,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	}
 
 	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
-	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
+	vmcb02->control.misc_ctl = vmcb01->control.misc_ctl;
 	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
 	vmcb02->control.msrpm_base_pa = vmcb01->control.msrpm_base_pa;
 	vmcb_mark_dirty(vmcb02, VMCB_PERM_MAP);
@@ -951,7 +951,7 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 				 vmcb12->save.rip,
 				 vmcb12->control.int_ctl,
 				 vmcb12->control.event_inj,
-				 vmcb12->control.nested_ctl,
+				 vmcb12->control.misc_ctl,
 				 vmcb12->control.nested_cr3,
 				 vmcb12->save.cr3,
 				 KVM_ISA_SVM);
@@ -1742,7 +1742,7 @@ static void nested_copy_vmcb_cache_to_control(struct vmcb_control_area *dst,
 	dst->exit_info_2          = from->exit_info_2;
 	dst->exit_int_info        = from->exit_int_info;
 	dst->exit_int_info_err    = from->exit_int_info_err;
-	dst->nested_ctl           = from->nested_ctl;
+	dst->misc_ctl		  = from->misc_ctl;
 	dst->event_inj            = from->event_inj;
 	dst->event_inj_err        = from->event_inj_err;
 	dst->next_rip             = from->next_rip;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0835c664fbfdb..4eff5cc43821a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4553,7 +4553,7 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm, bool init_event)
 	struct kvm_sev_info *sev = to_kvm_sev_info(svm->vcpu.kvm);
 	struct vmcb *vmcb = svm->vmcb01.ptr;
 
-	svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ES_ENABLE;
+	svm->vmcb->control.misc_ctl |= SVM_MISC_CTL_SEV_ES_ENABLE;
 
 	/*
 	 * An SEV-ES guest requires a VMSA area that is a separate from the
@@ -4624,7 +4624,7 @@ void sev_init_vmcb(struct vcpu_svm *svm, bool init_event)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
-	svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ENABLE;
+	svm->vmcb->control.misc_ctl |= SVM_MISC_CTL_SEV_ENABLE;
 	clr_exception_intercept(svm, UD_VECTOR);
 
 	/*
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f14709a511aa4..9ef7683fb2ff0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1124,7 +1124,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu, bool init_event)
 
 	if (npt_enabled) {
 		/* Setup VMCB for Nested Paging */
-		control->nested_ctl |= SVM_NESTED_CTL_NP_ENABLE;
+		control->misc_ctl |= SVM_MISC_CTL_NP_ENABLE;
 		svm_clr_intercept(svm, INTERCEPT_INVLPG);
 		clr_exception_intercept(svm, PF_VECTOR);
 		svm_clr_intercept(svm, INTERCEPT_CR3_READ);
@@ -3280,7 +3280,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%016llx\n", "exit_info2:", control->exit_info_2);
 	pr_err("%-20s%08x\n", "exit_int_info:", control->exit_int_info);
 	pr_err("%-20s%08x\n", "exit_int_info_err:", control->exit_int_info_err);
-	pr_err("%-20s%lld\n", "nested_ctl:", control->nested_ctl);
+	pr_err("%-20s%lld\n", "misc_ctl:", control->misc_ctl);
 	pr_err("%-20s%016llx\n", "nested_cr3:", control->nested_cr3);
 	pr_err("%-20s%016llx\n", "avic_vapic_bar:", control->avic_vapic_bar);
 	pr_err("%-20s%016llx\n", "ghcb:", control->ghcb_gpa);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index efcf923264c55..980560a815868 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -169,7 +169,7 @@ struct vmcb_ctrl_area_cached {
 	u64 exit_info_2;
 	u32 exit_int_info;
 	u32 exit_int_info_err;
-	u64 nested_ctl;
+	u64 misc_ctl;
 	u32 event_inj;
 	u32 event_inj_err;
 	u64 next_rip;
@@ -554,7 +554,7 @@ static inline bool gif_set(struct vcpu_svm *svm)
 static inline bool nested_npt_enabled(struct vcpu_svm *svm)
 {
 	return guest_cpu_cap_has(&svm->vcpu, X86_FEATURE_NPT) &&
-		svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
+		svm->nested.ctl.misc_ctl & SVM_MISC_CTL_NP_ENABLE;
 }
 
 static inline bool nested_vnmi_enabled(struct vcpu_svm *svm)
diff --git a/tools/testing/selftests/kvm/include/x86/svm.h b/tools/testing/selftests/kvm/include/x86/svm.h
index 29cffd0a91816..5d2bcce34c019 100644
--- a/tools/testing/selftests/kvm/include/x86/svm.h
+++ b/tools/testing/selftests/kvm/include/x86/svm.h
@@ -98,7 +98,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u64 exit_info_2;
 	u32 exit_int_info;
 	u32 exit_int_info_err;
-	u64 nested_ctl;
+	u64 misc_ctl;
 	u64 avic_vapic_bar;
 	u8 reserved_4[8];
 	u32 event_inj;
@@ -176,8 +176,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_VM_CR_SVM_LOCK_MASK 0x0008ULL
 #define SVM_VM_CR_SVM_DIS_MASK  0x0010ULL
 
-#define SVM_NESTED_CTL_NP_ENABLE	BIT(0)
-#define SVM_NESTED_CTL_SEV_ENABLE	BIT(1)
+#define SVM_MISC_CTL_CTL_NP_ENABLE	BIT(0)
+#define SVM_MISC_CTL_SEV_ENABLE		BIT(1)
 
 struct __attribute__ ((__packed__)) vmcb_seg {
 	u16 selector;
-- 
2.51.2.1026.g39e6a42477-goog


