Return-Path: <kvm+bounces-1078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B9707E49BA
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 21:21:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00E8C2814F3
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 20:21:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05460374F0;
	Tue,  7 Nov 2023 20:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IQ/cf+xa"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAFF374E0
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 20:20:39 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7951985
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 12:20:38 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d9a5a3f2d4fso7030288276.3
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 12:20:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699388438; x=1699993238; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HcP2JfbYvCw/6vKNNLkZyRn6aBpcgrYpuBFRwc0hmn0=;
        b=IQ/cf+xaepm+MGWALo8fsH9cJ8sM5jJT2Do1ne5KPRiGSEK8Pr7Pr0iIZLp/n+WDl5
         D/yyFDNWQfo/H4Fx8Q8tH5P34Rnsl0umVencmTwIoNtcmS0EUKIxAxzSHsLCMFKimI2S
         FzLkIV7Zek2I55YbHUbrrQFhhgS80Q7/0WvAzE1ELKmoWKb35c1zHFp1PA28TDIFRvfs
         tKpKykBF7XuTXCowt42LUN4ISWr6m8Q1G1AgWaCNXzWh4batacsD2OiC6i/vbkkcpZ2P
         ooUNFOrOKgFYRWbNvejngKwkQEQLSEYj4hfCLUL1X+N/dIm2ZC09cM2ch+qNfbS65IZj
         lFww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699388438; x=1699993238;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HcP2JfbYvCw/6vKNNLkZyRn6aBpcgrYpuBFRwc0hmn0=;
        b=sWPQAPKHpUN4dnwVareysx5hZftL6s+QaMyqA6cSpSNx8PUrKN7/KBV/jRXYuec+1h
         jou5wD9XfEfPakFnjKGM50b3itYgrYata+0PYoXnOQpzR0ZJasrfXrEt9Y7zw0DC0ril
         OsUFHQtwz+a4m8EHazH0hAGxT4lUFUOMfWGU4AVa6BDmfD8T802D6OPxWIP4Gwa/Mspo
         CaxHCTd6RoJZA/YTcdLMDJ8+5BNWW2lMWFdvUHGKNzv8SFs1EcQEuZLPbFpGFwltL5w0
         YVrFJVGqPbOyqFoLazMHfHS1y07bByPU3xN4fBj6g655sF1PnzX7Sx3uQf55/6DRzw9g
         RL9w==
X-Gm-Message-State: AOJu0YwIihwTUpSC/nBGUKxCrJLLiH3goDeVGcV2dNiLbQOLdWlycUyX
	lkhVkkMeAP2Cs75ErWnfbwBTXQjD3EIUaG5KlBu+KLd5C0s4dStu7ozadckd5tkPXzEA7S355y/
	BfFhvz3ZffElmOGUGZjsKY29P+KzpqIqHVboarD19pX4JLO5SxrSfSYFvNcF3S8g=
X-Google-Smtp-Source: AGHT+IEEZXHgQn3L9aMmtKQfE9PGuocDJc957229d1gnLhARPapn1CWQw0gIogGanXDFPZy9eCQNEGYaazDpoA==
X-Received: from aghulati-dev.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:18bb])
 (user=aghulati job=sendgmr) by 2002:a05:6902:1746:b0:d9a:59cb:8bed with SMTP
 id bz6-20020a056902174600b00d9a59cb8bedmr576141ybb.5.1699388438149; Tue, 07
 Nov 2023 12:20:38 -0800 (PST)
Date: Tue,  7 Nov 2023 20:19:59 +0000
In-Reply-To: <20231107202002.667900-1-aghulati@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231107202002.667900-1-aghulati@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231107202002.667900-12-aghulati@google.com>
Subject: [RFC PATCH 11/14] KVM: SVM: Move SVM enable and disable into VAC
From: Anish Ghulati <aghulati@google.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, hpa@zytor.com, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, peterz@infradead.org, paulmck@kernel.org, 
	Mark Rutland <mark.rutland@arm.com>
Cc: Anish Ghulati <aghulati@google.com>
Content-Type: text/plain; charset="UTF-8"

Move SVM's hardware enable and disable into VAC.

Similar to VMX this requires a temporary call to new init and exit
functions within VAC, and moving svm_init_erratum_383 into svm_init
instead of hardware enable.

Delete __svm_exit and make svm_module_exit a noop.

Signed-off-by: Anish Ghulati <aghulati@google.com>
---
 arch/x86/kvm/svm/sev.c      |   2 +-
 arch/x86/kvm/svm/svm.c      | 129 ++----------------------------------
 arch/x86/kvm/svm/svm.h      |   4 +-
 arch/x86/kvm/svm/svm_data.h |  23 +++++++
 arch/x86/kvm/svm/vac.c      | 116 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/vac.h      |  23 +++----
 arch/x86/kvm/vac.h          |  12 ++++
 arch/x86/kvm/vmx/vac.h      |   5 ++
 8 files changed, 175 insertions(+), 139 deletions(-)
 create mode 100644 arch/x86/kvm/svm/svm_data.h

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b9a0a939d59f..d7b76710ab0a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -28,6 +28,7 @@
 #include "mmu.h"
 #include "x86.h"
 #include "svm.h"
+#include "svm_data.h"
 #include "svm_ops.h"
 #include "cpuid.h"
 #include "trace.h"
@@ -68,7 +69,6 @@ module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
-unsigned int max_sev_asid;
 static unsigned int min_sev_asid;
 static unsigned long sev_me_mask;
 static unsigned int nr_asids;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d53808d8ec37..752f769c0333 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5,11 +5,11 @@
 #include "irq.h"
 #include "mmu.h"
 #include "kvm_cache_regs.h"
-#include "vac.h"
 #include "x86.h"
 #include "smm.h"
 #include "cpuid.h"
 #include "pmu.h"
+#include "vac.h"
 
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
@@ -68,12 +68,6 @@ static bool erratum_383_found __read_mostly;
 
 u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 
-/*
- * Set osvw_len to higher value when updated Revision Guides
- * are published and we know what the new status bits are
- */
-static uint64_t osvw_len = 4, osvw_status;
-
 static DEFINE_PER_CPU(u64, current_tsc_ratio);
 
 #define X2APIC_MSR(x)	(APIC_BASE_MSR + (x >> 4))
@@ -211,9 +205,6 @@ module_param(vgif, int, 0444);
 static int lbrv = true;
 module_param(lbrv, int, 0444);
 
-static int tsc_scaling = true;
-module_param(tsc_scaling, int, 0444);
-
 /*
  * enable / disable AVIC.  Because the defaults differ for APICv
  * support between VMX and SVM we cannot use module_param_named.
@@ -584,106 +575,6 @@ static void __svm_write_tsc_multiplier(u64 multiplier)
 	__this_cpu_write(current_tsc_ratio, multiplier);
 }
 
-static inline void kvm_cpu_svm_disable(void)
-{
-	uint64_t efer;
-
-	wrmsrl(MSR_VM_HSAVE_PA, 0);
-	rdmsrl(MSR_EFER, efer);
-	if (efer & EFER_SVME) {
-		/*
-		 * Force GIF=1 prior to disabling SVM, e.g. to ensure INIT and
-		 * NMI aren't blocked.
-		 */
-		stgi();
-		wrmsrl(MSR_EFER, efer & ~EFER_SVME);
-	}
-}
-
-static void svm_emergency_disable(void)
-{
-	kvm_rebooting = true;
-
-	kvm_cpu_svm_disable();
-}
-
-static void svm_hardware_disable(void)
-{
-	/* Make sure we clean up behind us */
-	if (tsc_scaling)
-		__svm_write_tsc_multiplier(SVM_TSC_RATIO_DEFAULT);
-
-	kvm_cpu_svm_disable();
-
-	amd_pmu_disable_virt();
-}
-
-static int svm_hardware_enable(void)
-{
-
-	struct svm_cpu_data *sd;
-	uint64_t efer;
-	int me = raw_smp_processor_id();
-
-	rdmsrl(MSR_EFER, efer);
-	if (efer & EFER_SVME)
-		return -EBUSY;
-
-	sd = per_cpu_ptr(&svm_data, me);
-	sd->asid_generation = 1;
-	sd->max_asid = cpuid_ebx(SVM_CPUID_FUNC) - 1;
-	sd->next_asid = sd->max_asid + 1;
-	sd->min_asid = max_sev_asid + 1;
-
-	wrmsrl(MSR_EFER, efer | EFER_SVME);
-
-	wrmsrl(MSR_VM_HSAVE_PA, sd->save_area_pa);
-
-	if (static_cpu_has(X86_FEATURE_TSCRATEMSR)) {
-		/*
-		 * Set the default value, even if we don't use TSC scaling
-		 * to avoid having stale value in the msr
-		 */
-		__svm_write_tsc_multiplier(SVM_TSC_RATIO_DEFAULT);
-	}
-
-
-	/*
-	 * Get OSVW bits.
-	 *
-	 * Note that it is possible to have a system with mixed processor
-	 * revisions and therefore different OSVW bits. If bits are not the same
-	 * on different processors then choose the worst case (i.e. if erratum
-	 * is present on one processor and not on another then assume that the
-	 * erratum is present everywhere).
-	 */
-	if (cpu_has(&boot_cpu_data, X86_FEATURE_OSVW)) {
-		uint64_t len, status = 0;
-		int err;
-
-		len = native_read_msr_safe(MSR_AMD64_OSVW_ID_LENGTH, &err);
-		if (!err)
-			status = native_read_msr_safe(MSR_AMD64_OSVW_STATUS,
-						      &err);
-
-		if (err)
-			osvw_status = osvw_len = 0;
-		else {
-			if (len < osvw_len)
-				osvw_len = len;
-			osvw_status |= status;
-			osvw_status &= (1ULL << osvw_len) - 1;
-		}
-	} else
-		osvw_status = osvw_len = 0;
-
-	svm_init_erratum_383();
-
-	amd_pmu_enable_virt();
-
-	return 0;
-}
-
 static void svm_cpu_uninit(int cpu)
 {
 	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
@@ -4878,14 +4769,9 @@ static int svm_vm_init(struct kvm *kvm)
 	return 0;
 }
 
-static void __svm_exit(void)
-{
-	cpu_emergency_unregister_virt_callback(svm_emergency_disable);
-}
-
 void svm_module_exit(void)
 {
-	__svm_exit();
+	return;
 }
 
 static struct kvm_x86_ops svm_x86_ops __initdata = {
@@ -5325,7 +5211,8 @@ int __init svm_init(void)
 	if (r)
 		return r;
 
-	cpu_emergency_register_virt_callback(svm_emergency_disable);
+	//TODO: Remove this init call once VAC is a module
+	vac_svm_init();
 
 	/*
 	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
@@ -5334,11 +5221,9 @@ int __init svm_init(void)
 	r = kvm_init(sizeof(struct vcpu_svm), __alignof__(struct vcpu_svm),
 		     THIS_MODULE);
 	if (r)
-		goto err_kvm_init;
+		return r;
 
-	return 0;
+	svm_init_erratum_383();
 
-err_kvm_init:
-	__svm_exit();
-	return r;
+	return 0;
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7fc652b1b92d..7bd0dc0e000f 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -24,7 +24,7 @@
 
 #include "cpuid.h"
 #include "kvm_cache_regs.h"
-#include "vac.h"
+#include "svm_data.h"
 
 #define __sme_page_pa(x) __sme_set(page_to_pfn(x) << PAGE_SHIFT)
 
@@ -651,8 +651,6 @@ void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu);
 #define GHCB_VERSION_MIN	1ULL
 
 
-extern unsigned int max_sev_asid;
-
 void sev_vm_destroy(struct kvm *kvm);
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp);
 int sev_mem_enc_register_region(struct kvm *kvm,
diff --git a/arch/x86/kvm/svm/svm_data.h b/arch/x86/kvm/svm/svm_data.h
new file mode 100644
index 000000000000..9605807fc9d4
--- /dev/null
+++ b/arch/x86/kvm/svm/svm_data.h
@@ -0,0 +1,23 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#ifndef ARCH_X86_KVM_SVM_DATA_H
+#define ARCH_X86_KVM_SVM_DATA_H
+
+struct svm_cpu_data {
+	u64 asid_generation;
+	u32 max_asid;
+	u32 next_asid;
+	u32 min_asid;
+
+	struct page *save_area;
+	unsigned long save_area_pa;
+
+	struct vmcb *current_vmcb;
+
+	/* index = sev_asid, value = vmcb pointer */
+	struct vmcb **sev_vmcbs;
+};
+
+extern unsigned int max_sev_asid;
+
+#endif // ARCH_X86_KVM_SVM_DATA_H
diff --git a/arch/x86/kvm/svm/vac.c b/arch/x86/kvm/svm/vac.c
index 3e79279c6b34..2dd1c763f7d6 100644
--- a/arch/x86/kvm/svm/vac.c
+++ b/arch/x86/kvm/svm/vac.c
@@ -1,7 +1,123 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
+#include <asm/reboot.h>
+#include <asm/svm.h>
 #include <linux/percpu-defs.h>
 
+#include "svm_ops.h"
 #include "vac.h"
 
 DEFINE_PER_CPU(struct svm_cpu_data, svm_data);
+unsigned int max_sev_asid;
+
+static inline void kvm_cpu_svm_disable(void)
+{
+	uint64_t efer;
+
+	wrmsrl(MSR_VM_HSAVE_PA, 0);
+	rdmsrl(MSR_EFER, efer);
+	if (efer & EFER_SVME) {
+		/*
+		 * Force GIF=1 prior to disabling SVM, e.g. to ensure INIT and
+		 * NMI aren't blocked.
+		 */
+		stgi();
+		wrmsrl(MSR_EFER, efer & ~EFER_SVME);
+	}
+}
+
+static void svm_emergency_disable(void)
+{
+	kvm_rebooting = true;
+
+	kvm_cpu_svm_disable();
+}
+
+void svm_hardware_disable(void)
+{
+	/* Make sure we clean up behind us */
+	if (tsc_scaling)
+		// TODO: Fix everything TSC
+		// __svm_write_tsc_multiplier(SVM_TSC_RATIO_DEFAULT);
+
+	kvm_cpu_svm_disable();
+
+	amd_pmu_disable_virt();
+}
+
+int svm_hardware_enable(void)
+{
+
+	struct svm_cpu_data *sd;
+	uint64_t efer;
+	int me = raw_smp_processor_id();
+
+	rdmsrl(MSR_EFER, efer);
+	if (efer & EFER_SVME)
+		return -EBUSY;
+
+	sd = per_cpu_ptr(&svm_data, me);
+	sd->asid_generation = 1;
+	sd->max_asid = cpuid_ebx(SVM_CPUID_FUNC) - 1;
+	sd->next_asid = sd->max_asid + 1;
+	sd->min_asid = max_sev_asid + 1;
+
+	wrmsrl(MSR_EFER, efer | EFER_SVME);
+
+	wrmsrl(MSR_VM_HSAVE_PA, sd->save_area_pa);
+
+	if (static_cpu_has(X86_FEATURE_TSCRATEMSR)) {
+		/*
+		 * Set the default value, even if we don't use TSC scaling
+		 * to avoid having stale value in the msr
+		 */
+		// TODO: Fix everything TSC
+		// __svm_write_tsc_multiplier(SVM_TSC_RATIO_DEFAULT);
+	}
+
+
+	/*
+	 * Get OSVW bits.
+	 *
+	 * Note that it is possible to have a system with mixed processor
+	 * revisions and therefore different OSVW bits. If bits are not the same
+	 * on different processors then choose the worst case (i.e. if erratum
+	 * is present on one processor and not on another then assume that the
+	 * erratum is present everywhere).
+	 */
+	if (cpu_has(&boot_cpu_data, X86_FEATURE_OSVW)) {
+		uint64_t len, status = 0;
+		int err;
+
+		len = native_read_msr_safe(MSR_AMD64_OSVW_ID_LENGTH, &err);
+		if (!err)
+			status = native_read_msr_safe(MSR_AMD64_OSVW_STATUS,
+						      &err);
+
+		if (err)
+			osvw_status = osvw_len = 0;
+		else {
+			if (len < osvw_len)
+				osvw_len = len;
+			osvw_status |= status;
+			osvw_status &= (1ULL << osvw_len) - 1;
+		}
+	} else
+		osvw_status = osvw_len = 0;
+
+	amd_pmu_enable_virt();
+
+	return 0;
+}
+
+int __init vac_svm_init(void)
+{
+	cpu_emergency_register_virt_callback(svm_emergency_disable);
+
+	return 0;
+}
+
+void vac_svm_exit(void)
+{
+	cpu_emergency_unregister_virt_callback(svm_emergency_disable);
+}
diff --git a/arch/x86/kvm/svm/vac.h b/arch/x86/kvm/svm/vac.h
index 2d42e4472703..870cb8a9c8d2 100644
--- a/arch/x86/kvm/svm/vac.h
+++ b/arch/x86/kvm/svm/vac.h
@@ -1,23 +1,20 @@
 // SPDX-License-Identifier: GPL-2.0-only
-//
+
 #ifndef ARCH_X86_KVM_SVM_VAC_H
 #define ARCH_X86_KVM_SVM_VAC_H
 
 #include "../vac.h"
+#include "svm_data.h"
 
-struct svm_cpu_data {
-	u64 asid_generation;
-	u32 max_asid;
-	u32 next_asid;
-	u32 min_asid;
-
-	struct page *save_area;
-	unsigned long save_area_pa;
+static int tsc_scaling = true;
 
-	struct vmcb *current_vmcb;
+/*
+ * Set osvw_len to higher value when updated Revision Guides
+ * are published and we know what the new status bits are
+ */
+static uint64_t osvw_len = 4, osvw_status;
 
-	/* index = sev_asid, value = vmcb pointer */
-	struct vmcb **sev_vmcbs;
-};
+int svm_hardware_enable(void);
+void svm_hardware_disable(void);
 
 #endif // ARCH_X86_KVM_SVM_VAC_H
diff --git a/arch/x86/kvm/vac.h b/arch/x86/kvm/vac.h
index 59cbf36ff8ce..6c0a480ee9e3 100644
--- a/arch/x86/kvm/vac.h
+++ b/arch/x86/kvm/vac.h
@@ -19,6 +19,18 @@ int __init vac_vmx_init(void)
 void vac_vmx_exit(void) {}
 #endif
 
+#ifdef CONFIG_KVM_AMD
+int __init vac_svm_init(void);
+void vac_svm_exit(void);
+#else
+int __init vac_svm_init(void)
+{
+	return 0;
+}
+void vac_svm_exit(void) {}
+#endif
+
+
 /*
  * Restoring the host value for MSRs that are only consumed when running in
  * usermode, e.g. SYSCALL MSRs and TSC_AUX, can be deferred until the CPU
diff --git a/arch/x86/kvm/vmx/vac.h b/arch/x86/kvm/vmx/vac.h
index daeea8ef0d33..d5af0ca67e3f 100644
--- a/arch/x86/kvm/vmx/vac.h
+++ b/arch/x86/kvm/vmx/vac.h
@@ -1,5 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
+#ifndef ARCH_X86_KVM_VMX_VAC_H
+#define ARCH_X86_KVM_VMX_VAC_H
+
 #include <asm/vmx.h>
 
 #include "../vac.h"
@@ -15,3 +18,5 @@ void add_vmcs_to_loaded_vmcss_on_cpu(
 void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs);
 int vmx_hardware_enable(void);
 void vmx_hardware_disable(void);
+
+#endif // ARCH_X86_KVM_VMX_VAC_H
-- 
2.42.0.869.gea05f2083d-goog


