Return-Path: <kvm+bounces-1068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A9757E49A6
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 21:20:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6B999B20FF0
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 20:20:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1665D37148;
	Tue,  7 Nov 2023 20:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l5rpy2Uq"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B71D30F97
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 20:20:14 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A41810C0
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 12:20:14 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5b0c27d504fso580727b3.1
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 12:20:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699388413; x=1699993213; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=n5hqzLmoyRbfXoD17FLyCrxsjfvh0aIGlQdq5ev3Q9c=;
        b=l5rpy2UqTpN1rQCT8Jnx3570IjP2yUYqfJ7y0Tq7VCavv1tmxyOybrsYVuB1yC6Fa/
         OLBzkjr4Aa2UjmjHbbeeY+bycIMrjo9dmEWDGQwZZV8cOgsh1hUXONP6g58Ns0qMsOtx
         uxcPr90TJcIpQ0GrwMaeCFk71pHq9xrHQ0OSlCRnShkGXuYQzfUwa3fFh8UfUAD6dYUl
         JsaNW54oNypanHxEHDgy8cYLTt8vwYB+M3WLsXaj8Cc/uzMmlaML3UHMlcsgU7NZhTYQ
         IGIk6aY6S9+4Ug+V1Xnip0T0NN1A4vOqDwNwsp6zVoA1yzUXNOFT7pokk0uAJLbAkjs0
         Y3qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699388413; x=1699993213;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n5hqzLmoyRbfXoD17FLyCrxsjfvh0aIGlQdq5ev3Q9c=;
        b=Oz4Oh/dPLufSbSFHpdqbTtEKHPtZsxqI2SpNROIXII/WAQHXsi1HQskyE8Z9+G3uF6
         2lGnYNYYLK18jYjqP4FzDA6Mu2SEOa0TAcrJOjAth4htW5vdRA5BlKPBMNiM1KgWhThR
         e2+CAf0IuAuDL4ZwZtLf8OO23wOSNSFFwWgGCZNPu0P7l1DLudeEohJDjumF0j7mYdiD
         eLat5BtNkFLYzVTUDDFXM/kmf4p+tkVVXCj8oMzB9Q8ukXyqRIIKfweB9/VjKoDEq/pZ
         8J1iigkl9wtiqQpQTlPsQZqn7U/Y8ekZit8b/WklI0Md/ADzFCA2QQCKUUuGSanTYtZh
         UiHA==
X-Gm-Message-State: AOJu0Yy4SIbkTroGcStVyXllObzo89ptCcqrqAK3LEfhOAGTEn2+Ilzm
	2+jcrbJR+aEb0Ks634Mgok23Df9hY+1MAazje5tyi0OGy53t8UGxA96UX/rE8K7ZGmJg3ObEl61
	uI/0DMPZLAxpnTzVs4GSu1oGEA4I7IRaHNqV2i5NhzOvePhkbXXkUvfZrSy9HonQ=
X-Google-Smtp-Source: AGHT+IH5TlkA0A8QmLKrs5St2q9LNsq3BVxdtAUXbMa8iB4fXv45uhXsqEMlUmVz1s49M/d7cy62oIp5RAP5pg==
X-Received: from aghulati-dev.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:18bb])
 (user=aghulati job=sendgmr) by 2002:a0d:cb86:0:b0:5a7:b4d5:5f27 with SMTP id
 n128-20020a0dcb86000000b005a7b4d55f27mr76083ywd.5.1699388413421; Tue, 07 Nov
 2023 12:20:13 -0800 (PST)
Date: Tue,  7 Nov 2023 20:19:49 +0000
In-Reply-To: <20231107202002.667900-1-aghulati@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231107202002.667900-1-aghulati@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231107202002.667900-2-aghulati@google.com>
Subject: [RFC PATCH 01/14] KVM: x86: Move common module params from SVM/VMX to x86
From: Anish Ghulati <aghulati@google.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, hpa@zytor.com, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, peterz@infradead.org, paulmck@kernel.org, 
	Mark Rutland <mark.rutland@arm.com>
Cc: Anish Ghulati <aghulati@google.com>
Content-Type: text/plain; charset="UTF-8"

Move nested and enable_vnmi from SVM and VMX into x86.

Signed-off-by: Anish Ghulati <aghulati@google.com>
---
 arch/x86/kvm/svm/nested.c |  4 ++--
 arch/x86/kvm/svm/svm.c    | 17 +++++------------
 arch/x86/kvm/svm/svm.h    |  3 +--
 arch/x86/kvm/vmx/vmx.c    | 11 -----------
 arch/x86/kvm/x86.c        | 11 +++++++++++
 arch/x86/kvm/x86.h        |  4 ++++
 6 files changed, 23 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index dd496c9e5f91..aebccf7c1c2d 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -666,7 +666,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	else
 		int_ctl_vmcb01_bits |= (V_GIF_MASK | V_GIF_ENABLE_MASK);
 
-	if (vnmi) {
+	if (enable_vnmi) {
 		if (vmcb01->control.int_ctl & V_NMI_PENDING_MASK) {
 			svm->vcpu.arch.nmi_pending++;
 			kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
@@ -1083,7 +1083,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 		svm_update_lbrv(vcpu);
 	}
 
-	if (vnmi) {
+	if (enable_vnmi) {
 		if (vmcb02->control.int_ctl & V_NMI_BLOCKING_MASK)
 			vmcb01->control.int_ctl |= V_NMI_BLOCKING_MASK;
 		else
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f283eb47f6ac..3d44e42f4f22 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -197,10 +197,6 @@ module_param(pause_filter_count_max, ushort, 0444);
 bool npt_enabled = true;
 module_param_named(npt, npt_enabled, bool, 0444);
 
-/* allow nested virtualization in KVM/SVM */
-static int nested = true;
-module_param(nested, int, S_IRUGO);
-
 /* enable/disable Next RIP Save */
 int nrips = true;
 module_param(nrips, int, 0444);
@@ -234,9 +230,6 @@ module_param(dump_invalid_vmcb, bool, 0644);
 bool intercept_smi = true;
 module_param(intercept_smi, bool, 0444);
 
-bool vnmi = true;
-module_param(vnmi, bool, 0444);
-
 static bool svm_gp_erratum_intercept = true;
 
 static u8 rsm_ins_bytes[] = "\x0f\xaa";
@@ -1357,7 +1350,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	if (kvm_vcpu_apicv_active(vcpu))
 		avic_init_vmcb(svm, vmcb);
 
-	if (vnmi)
+	if (enable_vnmi)
 		svm->vmcb->control.int_ctl |= V_NMI_ENABLE_MASK;
 
 	if (vgif) {
@@ -5089,7 +5082,7 @@ static __init void svm_set_cpu_caps(void)
 		if (vgif)
 			kvm_cpu_cap_set(X86_FEATURE_VGIF);
 
-		if (vnmi)
+		if (enable_vnmi)
 			kvm_cpu_cap_set(X86_FEATURE_VNMI);
 
 		/* Nested VM can receive #VMEXIT instead of triggering #GP */
@@ -5253,11 +5246,11 @@ static __init int svm_hardware_setup(void)
 			pr_info("Virtual GIF supported\n");
 	}
 
-	vnmi = vgif && vnmi && boot_cpu_has(X86_FEATURE_VNMI);
-	if (vnmi)
+	enable_vnmi = vgif && enable_vnmi && boot_cpu_has(X86_FEATURE_VNMI);
+	if (enable_vnmi)
 		pr_info("Virtual NMI enabled\n");
 
-	if (!vnmi) {
+	if (!enable_vnmi) {
 		svm_x86_ops.is_vnmi_pending = NULL;
 		svm_x86_ops.set_vnmi_pending = NULL;
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f41253958357..436632706848 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -38,7 +38,6 @@ extern int nrips;
 extern int vgif;
 extern bool intercept_smi;
 extern bool x2avic_enabled;
-extern bool vnmi;
 
 /*
  * Clean bits in VMCB.
@@ -510,7 +509,7 @@ static inline bool is_x2apic_msrpm_offset(u32 offset)
 
 static inline struct vmcb *get_vnmi_vmcb_l1(struct vcpu_svm *svm)
 {
-	if (!vnmi)
+	if (!enable_vnmi)
 		return NULL;
 
 	if (is_guest_mode(&svm->vcpu))
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 43b87ad5fde8..65d59de3cc63 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -80,9 +80,6 @@ MODULE_DEVICE_TABLE(x86cpu, vmx_cpu_id);
 bool __read_mostly enable_vpid = 1;
 module_param_named(vpid, enable_vpid, bool, 0444);
 
-static bool __read_mostly enable_vnmi = 1;
-module_param_named(vnmi, enable_vnmi, bool, S_IRUGO);
-
 bool __read_mostly flexpriority_enabled = 1;
 module_param_named(flexpriority, flexpriority_enabled, bool, S_IRUGO);
 
@@ -107,14 +104,6 @@ module_param(enable_apicv, bool, S_IRUGO);
 bool __read_mostly enable_ipiv = true;
 module_param(enable_ipiv, bool, 0444);
 
-/*
- * If nested=1, nested virtualization is supported, i.e., guests may use
- * VMX and be a hypervisor for its own guests. If nested=0, guests may not
- * use VMX instructions.
- */
-static bool __read_mostly nested = 1;
-module_param(nested, bool, S_IRUGO);
-
 bool __read_mostly enable_pml = 1;
 module_param_named(pml, enable_pml, bool, S_IRUGO);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index aab095f89d9e..6b7f89fd2d47 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -176,6 +176,17 @@ bool __read_mostly enable_vmware_backdoor = false;
 module_param(enable_vmware_backdoor, bool, S_IRUGO);
 EXPORT_SYMBOL_GPL(enable_vmware_backdoor);
 
+/*
+ * If nested=1, nested virtualization is supported
+ */
+bool __read_mostly nested = 1;
+module_param(nested, bool, S_IRUGO);
+EXPORT_SYMBOL_GPL(nested);
+
+bool __read_mostly enable_vnmi = 1;
+module_param(enable_vnmi, bool, S_IRUGO);
+EXPORT_SYMBOL_GPL(enable_vnmi);
+
 /*
  * Flags to manipulate forced emulation behavior (any non-zero value will
  * enable forced emulation).
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 1e7be1f6ab29..6b5490319d1b 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -367,6 +367,10 @@ extern unsigned int min_timer_period_us;
 
 extern bool enable_vmware_backdoor;
 
+extern bool nested;
+
+extern bool enable_vnmi;
+
 extern int pi_inject_timer;
 
 extern bool report_ignored_msrs;
-- 
2.42.0.869.gea05f2083d-goog


