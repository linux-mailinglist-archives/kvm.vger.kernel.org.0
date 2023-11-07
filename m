Return-Path: <kvm+bounces-1073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CFEA37E49B1
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 21:20:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 818DB281547
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 20:20:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7C5137171;
	Tue,  7 Nov 2023 20:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nLLdQt4L"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A5037163
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 20:20:27 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7242D10DF
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 12:20:26 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-da1aa98ec19so7351522276.2
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 12:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699388425; x=1699993225; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8hTPx+aup90plN/fbDSVsAALO6JNRfZPRbOkMrmrPC8=;
        b=nLLdQt4L4cl9w6U7qf+Q6GOj1de+8cIqjyn/hfU77zHSt0H7r3FNb2VK8w9SdoBPzx
         NIlHrygDILuYBIgryRWP4gnGNuG7t3HggFcXMHvK84GfIBzTLUqNNaicPgpG+NyDwLMa
         HrZ7BhSCpBCKIsGKvBy081rd39aXe4oHcqNQsNUUnkzJ4RPwepuPs1/pf5KK/5ww1LyF
         pfhjMCteiafOKpmfiPfF9uAW5r0YTfmqNi40CtdOHVxGK7mP5zj1Xbr0pQ2mjaZtx1Cx
         UYRXpiKvMuZOGPsp5Cm4GiHtmmjAzhCA9BA0YvrYYrvSeV2FdzKiZe5CtlyFBt0oNSLI
         VH3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699388425; x=1699993225;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8hTPx+aup90plN/fbDSVsAALO6JNRfZPRbOkMrmrPC8=;
        b=ImHWgUUCpY0AW9yKGHgwjMusnLCe4DNHMsD+L3Nv3y0cUy65xmWSv0/HQTYWtsjaNX
         yFjf95w4ZFV73/Em4Bv2jb5jyC16zhAcMPDiREGNl0GrjVSC9UZJU0m8mZ8f+u/AJlgK
         huwhOiXOR9Esuukju+S+8oxlGHVtC0xT5Ns1S0h9Nt4WgHhndIXwMo+nPLs9OQ8YzkWW
         j8EBLoggu//O3DTUaQC63F3WDCxTF2mcUlcuN6iGAkE8VKoaYorY4ZomRXMcHvHL3ZqY
         RleCoboj1+DuWyQ0yjIth2DvWT1hx/IJ/TB5mA5ZQg0fbxnDGtJJNZZhQAaeiR+1J8b9
         5JSw==
X-Gm-Message-State: AOJu0Yz3i8xY/IRKZF+nkBkeZomBANa9Us909fNb1GNoaz+SDkfLH/QR
	+LwVsSd3CZKq2V4FqrzblB+k0UAxrcAwXrKO6VSMnDYqBCGta/3Ne8O7mdc5o0tz4+IsntIBGKY
	nj9BJ3+rIqM+UbXQyhC8pyIMB0a9NukP0wjjKAYPjWwK3bXCJeKjVeFZCohJiW60=
X-Google-Smtp-Source: AGHT+IGFuCkbCR1A1bUznN/BWTvWpWl1o+nDarmfo493WniIMDt849Y4dSRYdT2hDRXzfE2ycUNoWV+9qMucDg==
X-Received: from aghulati-dev.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:18bb])
 (user=aghulati job=sendgmr) by 2002:a25:bc90:0:b0:d9c:c9a8:8c27 with SMTP id
 e16-20020a25bc90000000b00d9cc9a88c27mr627785ybk.13.1699388425154; Tue, 07 Nov
 2023 12:20:25 -0800 (PST)
Date: Tue,  7 Nov 2023 20:19:54 +0000
In-Reply-To: <20231107202002.667900-1-aghulati@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231107202002.667900-1-aghulati@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231107202002.667900-7-aghulati@google.com>
Subject: [RFC PATCH 06/14] KVM: x86: Move user return msr operations out of KVM
From: Anish Ghulati <aghulati@google.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, hpa@zytor.com, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, peterz@infradead.org, paulmck@kernel.org, 
	Mark Rutland <mark.rutland@arm.com>
Cc: Anish Ghulati <aghulati@google.com>
Content-Type: text/plain; charset="UTF-8"

Move kvm_user_return_msrs into VAC. Create helper functions to access
user return msrs from KVM and (temporarily) expose them via vac.h. When
more code is moved to VAC these functions will no longer need to be
public and can be made internal.

Signed-off-by: Anish Ghulati <aghulati@google.com>
---
 arch/x86/include/asm/kvm_host.h |  10 ---
 arch/x86/kvm/cpuid.c            |   1 +
 arch/x86/kvm/svm/svm.c          |   1 +
 arch/x86/kvm/vac.c              | 131 +++++++++++++++++++++++++++++
 arch/x86/kvm/vac.h              |  34 ++++++++
 arch/x86/kvm/vmx/vmx.c          |   1 +
 arch/x86/kvm/x86.c              | 142 ++------------------------------
 7 files changed, 173 insertions(+), 147 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e01d1aa3628c..34b995306c31 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1785,7 +1785,6 @@ struct kvm_arch_async_pf {
 	bool direct_map;
 };
 
-extern u32 __read_mostly kvm_nr_uret_msrs;
 extern u64 __read_mostly host_efer;
 extern bool __read_mostly allow_smaller_maxphyaddr;
 extern bool __read_mostly enable_apicv;
@@ -2139,15 +2138,6 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
 		    unsigned long ipi_bitmap_high, u32 min,
 		    unsigned long icr, int op_64_bit);
 
-int kvm_add_user_return_msr(u32 msr);
-int kvm_find_user_return_msr(u32 msr);
-int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
-
-static inline bool kvm_is_supported_user_return_msr(u32 msr)
-{
-	return kvm_find_user_return_msr(msr) >= 0;
-}
-
 u64 kvm_scale_tsc(u64 tsc, u64 ratio);
 u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc);
 u64 kvm_calc_nested_tsc_offset(u64 l1_offset, u64 l2_offset, u64 l2_multiplier);
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 01de1f659beb..961e5acd434c 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -28,6 +28,7 @@
 #include "trace.h"
 #include "pmu.h"
 #include "xen.h"
+#include "vac.h"
 
 /*
  * Unlike "struct cpuinfo_x86.x86_capability", kvm_cpu_caps doesn't need to be
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7fe9d11db8a6..f0a5cc43c023 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5,6 +5,7 @@
 #include "irq.h"
 #include "mmu.h"
 #include "kvm_cache_regs.h"
+#include "vac.h"
 #include "x86.h"
 #include "smm.h"
 #include "cpuid.h"
diff --git a/arch/x86/kvm/vac.c b/arch/x86/kvm/vac.c
index 18d2ae7d3e47..ab77aee4e1fa 100644
--- a/arch/x86/kvm/vac.c
+++ b/arch/x86/kvm/vac.c
@@ -1,3 +1,134 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
 #include "vac.h"
+#include <asm/msr.h>
+
+u32 __read_mostly kvm_uret_msrs_list[KVM_MAX_NR_USER_RETURN_MSRS];
+struct kvm_user_return_msrs __percpu *user_return_msrs;
+
+u32 __read_mostly kvm_nr_uret_msrs;
+
+void kvm_on_user_return(struct user_return_notifier *urn)
+{
+	unsigned int slot;
+	struct kvm_user_return_msrs *msrs
+		= container_of(urn, struct kvm_user_return_msrs, urn);
+	struct kvm_user_return_msr_values *values;
+	unsigned long flags;
+
+	/*
+	 * Disabling irqs at this point since the following code could be
+	 * interrupted and executed through kvm_arch_hardware_disable()
+	 */
+	local_irq_save(flags);
+	if (msrs->registered) {
+		msrs->registered = false;
+		user_return_notifier_unregister(urn);
+	}
+	local_irq_restore(flags);
+	for (slot = 0; slot < kvm_nr_uret_msrs; ++slot) {
+		values = &msrs->values[slot];
+		if (values->host != values->curr) {
+			wrmsrl(kvm_uret_msrs_list[slot], values->host);
+			values->curr = values->host;
+		}
+	}
+}
+
+void kvm_user_return_msr_cpu_online(void)
+{
+	unsigned int cpu = smp_processor_id();
+	struct kvm_user_return_msrs *msrs = per_cpu_ptr(user_return_msrs, cpu);
+	u64 value;
+	int i;
+
+	for (i = 0; i < kvm_nr_uret_msrs; ++i) {
+		rdmsrl_safe(kvm_uret_msrs_list[i], &value);
+		msrs->values[i].host = value;
+		msrs->values[i].curr = value;
+	}
+}
+
+void drop_user_return_notifiers(void)
+{
+	unsigned int cpu = smp_processor_id();
+	struct kvm_user_return_msrs *msrs = per_cpu_ptr(user_return_msrs, cpu);
+
+	if (msrs->registered)
+		kvm_on_user_return(&msrs->urn);
+}
+
+static int kvm_probe_user_return_msr(u32 msr)
+{
+	u64 val;
+	int ret;
+
+	preempt_disable();
+	ret = rdmsrl_safe(msr, &val);
+	if (ret)
+		goto out;
+	ret = wrmsrl_safe(msr, val);
+out:
+	preempt_enable();
+	return ret;
+}
+
+int kvm_add_user_return_msr(u32 msr)
+{
+	BUG_ON(kvm_nr_uret_msrs >= KVM_MAX_NR_USER_RETURN_MSRS);
+
+	if (kvm_probe_user_return_msr(msr))
+		return -1;
+
+	kvm_uret_msrs_list[kvm_nr_uret_msrs] = msr;
+	return kvm_nr_uret_msrs++;
+}
+
+int kvm_find_user_return_msr(u32 msr)
+{
+	int i;
+
+	for (i = 0; i < kvm_nr_uret_msrs; ++i) {
+		if (kvm_uret_msrs_list[i] == msr)
+			return i;
+	}
+	return -1;
+}
+
+int kvm_set_user_return_msr(unsigned int slot, u64 value, u64 mask)
+{
+	unsigned int cpu = smp_processor_id();
+	struct kvm_user_return_msrs *msrs = per_cpu_ptr(user_return_msrs, cpu);
+	int err;
+
+	value = (value & mask) | (msrs->values[slot].host & ~mask);
+	if (value == msrs->values[slot].curr)
+		return 0;
+	err = wrmsrl_safe(kvm_uret_msrs_list[slot], value);
+	if (err)
+		return 1;
+
+	msrs->values[slot].curr = value;
+	if (!msrs->registered) {
+		msrs->urn.on_user_return = kvm_on_user_return;
+		user_return_notifier_register(&msrs->urn);
+		msrs->registered = true;
+	}
+	return 0;
+}
+
+int kvm_alloc_user_return_msrs(void)
+{
+	user_return_msrs = alloc_percpu(struct kvm_user_return_msrs);
+	if (!user_return_msrs) {
+		pr_err("failed to allocate percpu kvm_user_return_msrs\n");
+		return -ENOMEM;
+	}
+	kvm_nr_uret_msrs = 0;
+	return 0;
+}
+
+void kvm_free_user_return_msrs(void)
+{
+	free_percpu(user_return_msrs);
+}
diff --git a/arch/x86/kvm/vac.h b/arch/x86/kvm/vac.h
index 4d5dc4700f4e..135d3be5461e 100644
--- a/arch/x86/kvm/vac.h
+++ b/arch/x86/kvm/vac.h
@@ -3,4 +3,38 @@
 #ifndef ARCH_X86_KVM_VAC_H
 #define ARCH_X86_KVM_VAC_H
 
+#include <linux/user-return-notifier.h>
+
+/*
+ * Restoring the host value for MSRs that are only consumed when running in
+ * usermode, e.g. SYSCALL MSRs and TSC_AUX, can be deferred until the CPU
+ * returns to userspace, i.e. the kernel can run with the guest's value.
+ */
+#define KVM_MAX_NR_USER_RETURN_MSRS 16
+
+struct kvm_user_return_msrs {
+	struct user_return_notifier urn;
+	bool registered;
+	struct kvm_user_return_msr_values {
+		u64 host;
+		u64 curr;
+	} values[KVM_MAX_NR_USER_RETURN_MSRS];
+};
+
+extern u32 __read_mostly kvm_nr_uret_msrs;
+
+int kvm_alloc_user_return_msrs(void);
+void kvm_free_user_return_msrs(void);
+int kvm_add_user_return_msr(u32 msr);
+int kvm_find_user_return_msr(u32 msr);
+int kvm_set_user_return_msr(unsigned int slot, u64 value, u64 mask);
+void kvm_on_user_return(struct user_return_notifier *urn);
+void kvm_user_return_msr_cpu_online(void);
+void drop_user_return_notifiers(void);
+
+static inline bool kvm_is_supported_user_return_msr(u32 msr)
+{
+	return kvm_find_user_return_msr(msr) >= 0;
+}
+
 #endif // ARCH_X86_KVM_VAC_H
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 629e662b131e..7fea84a17edf 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -64,6 +64,7 @@
 #include "vmcs12.h"
 #include "vmx.h"
 #include "x86.h"
+#include "vac.h"
 #include "smm.h"
 
 #ifdef MODULE
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0a8b94678928..7466a5945147 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -34,6 +34,7 @@
 #include "lapic.h"
 #include "xen.h"
 #include "smm.h"
+#include "vac.h"
 
 #include <linux/clocksource.h>
 #include <linux/interrupt.h>
@@ -205,26 +206,6 @@ module_param(eager_page_split, bool, 0644);
 static bool __read_mostly mitigate_smt_rsb;
 module_param(mitigate_smt_rsb, bool, 0444);
 
-/*
- * Restoring the host value for MSRs that are only consumed when running in
- * usermode, e.g. SYSCALL MSRs and TSC_AUX, can be deferred until the CPU
- * returns to userspace, i.e. the kernel can run with the guest's value.
- */
-#define KVM_MAX_NR_USER_RETURN_MSRS 16
-
-struct kvm_user_return_msrs {
-	struct user_return_notifier urn;
-	bool registered;
-	struct kvm_user_return_msr_values {
-		u64 host;
-		u64 curr;
-	} values[KVM_MAX_NR_USER_RETURN_MSRS];
-};
-
-u32 __read_mostly kvm_nr_uret_msrs;
-static u32 __read_mostly kvm_uret_msrs_list[KVM_MAX_NR_USER_RETURN_MSRS];
-static struct kvm_user_return_msrs __percpu *user_return_msrs;
-
 #define KVM_SUPPORTED_XCR0     (XFEATURE_MASK_FP | XFEATURE_MASK_SSE \
 				| XFEATURE_MASK_YMM | XFEATURE_MASK_BNDREGS \
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
@@ -358,115 +339,6 @@ static inline void kvm_async_pf_hash_reset(struct kvm_vcpu *vcpu)
 		vcpu->arch.apf.gfns[i] = ~0;
 }
 
-static void kvm_on_user_return(struct user_return_notifier *urn)
-{
-	unsigned slot;
-	struct kvm_user_return_msrs *msrs
-		= container_of(urn, struct kvm_user_return_msrs, urn);
-	struct kvm_user_return_msr_values *values;
-	unsigned long flags;
-
-	/*
-	 * Disabling irqs at this point since the following code could be
-	 * interrupted and executed through kvm_arch_hardware_disable()
-	 */
-	local_irq_save(flags);
-	if (msrs->registered) {
-		msrs->registered = false;
-		user_return_notifier_unregister(urn);
-	}
-	local_irq_restore(flags);
-	for (slot = 0; slot < kvm_nr_uret_msrs; ++slot) {
-		values = &msrs->values[slot];
-		if (values->host != values->curr) {
-			wrmsrl(kvm_uret_msrs_list[slot], values->host);
-			values->curr = values->host;
-		}
-	}
-}
-
-static int kvm_probe_user_return_msr(u32 msr)
-{
-	u64 val;
-	int ret;
-
-	preempt_disable();
-	ret = rdmsrl_safe(msr, &val);
-	if (ret)
-		goto out;
-	ret = wrmsrl_safe(msr, val);
-out:
-	preempt_enable();
-	return ret;
-}
-
-int kvm_add_user_return_msr(u32 msr)
-{
-	BUG_ON(kvm_nr_uret_msrs >= KVM_MAX_NR_USER_RETURN_MSRS);
-
-	if (kvm_probe_user_return_msr(msr))
-		return -1;
-
-	kvm_uret_msrs_list[kvm_nr_uret_msrs] = msr;
-	return kvm_nr_uret_msrs++;
-}
-
-int kvm_find_user_return_msr(u32 msr)
-{
-	int i;
-
-	for (i = 0; i < kvm_nr_uret_msrs; ++i) {
-		if (kvm_uret_msrs_list[i] == msr)
-			return i;
-	}
-	return -1;
-}
-
-static void kvm_user_return_msr_cpu_online(void)
-{
-	unsigned int cpu = smp_processor_id();
-	struct kvm_user_return_msrs *msrs = per_cpu_ptr(user_return_msrs, cpu);
-	u64 value;
-	int i;
-
-	for (i = 0; i < kvm_nr_uret_msrs; ++i) {
-		rdmsrl_safe(kvm_uret_msrs_list[i], &value);
-		msrs->values[i].host = value;
-		msrs->values[i].curr = value;
-	}
-}
-
-int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
-{
-	unsigned int cpu = smp_processor_id();
-	struct kvm_user_return_msrs *msrs = per_cpu_ptr(user_return_msrs, cpu);
-	int err;
-
-	value = (value & mask) | (msrs->values[slot].host & ~mask);
-	if (value == msrs->values[slot].curr)
-		return 0;
-	err = wrmsrl_safe(kvm_uret_msrs_list[slot], value);
-	if (err)
-		return 1;
-
-	msrs->values[slot].curr = value;
-	if (!msrs->registered) {
-		msrs->urn.on_user_return = kvm_on_user_return;
-		user_return_notifier_register(&msrs->urn);
-		msrs->registered = true;
-	}
-	return 0;
-}
-
-static void drop_user_return_notifiers(void)
-{
-	unsigned int cpu = smp_processor_id();
-	struct kvm_user_return_msrs *msrs = per_cpu_ptr(user_return_msrs, cpu);
-
-	if (msrs->registered)
-		kvm_on_user_return(&msrs->urn);
-}
-
 u64 kvm_get_apic_base(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.apic_base;
@@ -9415,13 +9287,9 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 		return -ENOMEM;
 	}
 
-	user_return_msrs = alloc_percpu(struct kvm_user_return_msrs);
-	if (!user_return_msrs) {
-		pr_err("failed to allocate percpu kvm_user_return_msrs\n");
-		r = -ENOMEM;
+	r = kvm_alloc_user_return_msrs();
+	if (r)
 		goto out_free_x86_emulator_cache;
-	}
-	kvm_nr_uret_msrs = 0;
 
 	r = kvm_mmu_vendor_module_init();
 	if (r)
@@ -9500,7 +9368,7 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 out_mmu_exit:
 	kvm_mmu_vendor_module_exit();
 out_free_percpu:
-	free_percpu(user_return_msrs);
+	kvm_free_user_return_msrs();
 out_free_x86_emulator_cache:
 	kmem_cache_destroy(x86_emulator_cache);
 	return r;
@@ -9539,7 +9407,7 @@ void kvm_x86_vendor_exit(void)
 #endif
 	static_call(kvm_x86_hardware_unsetup)();
 	kvm_mmu_vendor_module_exit();
-	free_percpu(user_return_msrs);
+	kvm_free_user_return_msrs();
 	kmem_cache_destroy(x86_emulator_cache);
 #ifdef CONFIG_KVM_XEN
 	static_key_deferred_flush(&kvm_xen_enabled);
-- 
2.42.0.869.gea05f2083d-goog


