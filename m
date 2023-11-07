Return-Path: <kvm+bounces-1080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D11AB7E49BC
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 21:21:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EBCEB1C20B6E
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 20:21:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BB5E38DE0;
	Tue,  7 Nov 2023 20:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NsEjyrMO"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CAC374E0
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 20:20:45 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849691BC1
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 12:20:44 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5b0c27d504fso584647b3.1
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 12:20:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699388444; x=1699993244; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yXDUOFgM+YJ6fuoNpSYf2QUTfSwK89RGtXlj6ZKeva0=;
        b=NsEjyrMOBOiWjvQskSwxahyBoLK9q+VErmNWJkesgpAtVQ34oMrDzeikmUogyVBO92
         liq0ldbxkW67PYUqxuh2H8jZPw7p8Nh5cc4/5ZsqRvS9/IgeNnwP2yiyDdgmSxDBDBpD
         ZZaILfQ4wAmjfyoCIBgbA9/FYdjp3xJee0pSDag+x4WdGumadwTBPqLzVNSbVbhBkrxu
         7YZIUMI10pwllIdVvEr4KhLIRfYD32lnIGcILQJUbPbVLB2HWykRuvybRdI8hsCayqFK
         Xg73hpsu176dckd6thXsY+WnUVnklAWOHy2EYXprRB7OIIKSCI05ktFUz/1L4tZLCRWP
         ou2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699388444; x=1699993244;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yXDUOFgM+YJ6fuoNpSYf2QUTfSwK89RGtXlj6ZKeva0=;
        b=H921HdBa1e14QZBCqHBVQDCxBFAff+yPE4i8e+b/luO/wVwHLpS3aHasd1eczWN1UZ
         qi4NcNBu9ryKR5JCrjWagyZV9lTXRtGZE6ge9ditne+ixshvqj/Yq3OtvR6kSI2YEWvW
         htTM17LdppeGHxWSQ4arVYaxBLxDT6TTsMkLSS02pmOvKVEY66lH36B/77qcNPUaIf3e
         Vh+3pvnAauMNa0tfgofn8GqxeqazROuP46YuUIVHBfrg133u+7GVtFBXKJGoMLKgxI+w
         8vFAul/R7JYRPqxwI9Z0rqDh+j96N2FCRRvgS0urwAz2wrP8KWl4/i4igYox8+I5H7NW
         CPRA==
X-Gm-Message-State: AOJu0Yzz8L4tAuTbVgp6lQ+qCtR7WDRQVvQIPJLJ/MGLj3uiALcW1LcO
	lLk6h0k6ScC+ZjnaV6SxoC5wG38TEXnOb5zS97tYRYLw36WfTJxB1UgJ2US4o20n4O9WaUjPPVj
	5uapU+Ztpsq/43P2zFk+eUpa8M2uq4RTdukdAl55lSfe8OivDn3ecu8AVyVOMaMY=
X-Google-Smtp-Source: AGHT+IGngbHKbHvkhMevIYXtZILRES11OdFIH5EJXTOVmK/Q4JcN12vJAVedP442pRgmwB2lAyEha9qaYf+TcQ==
X-Received: from aghulati-dev.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:18bb])
 (user=aghulati job=sendgmr) by 2002:a0d:d7cb:0:b0:58c:e8da:4d1a with SMTP id
 z194-20020a0dd7cb000000b0058ce8da4d1amr81006ywd.2.1699388443344; Tue, 07 Nov
 2023 12:20:43 -0800 (PST)
Date: Tue,  7 Nov 2023 20:20:01 +0000
In-Reply-To: <20231107202002.667900-1-aghulati@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231107202002.667900-1-aghulati@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231107202002.667900-14-aghulati@google.com>
Subject: [RFC PATCH 13/14] KVM: x86: VAC: Move all hardware enable/disable
 code into VAC
From: Anish Ghulati <aghulati@google.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, hpa@zytor.com, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, peterz@infradead.org, paulmck@kernel.org, 
	Mark Rutland <mark.rutland@arm.com>
Cc: Anish Ghulati <aghulati@google.com>
Content-Type: text/plain; charset="UTF-8"

De-indirect hardware enable and disable. Now that all of these functions
are in the VAC, they don't need to be called via an indirect ops table and
static call.

Signed-off-by: Anish Ghulati <aghulati@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |   2 -
 arch/x86/kvm/svm/svm.c             |   2 -
 arch/x86/kvm/svm/svm_ops.h         |   1 +
 arch/x86/kvm/vac.c                 |  46 +++++++++++-
 arch/x86/kvm/vac.h                 |   9 ++-
 arch/x86/kvm/vmx/vmx.c             |   2 -
 arch/x86/kvm/vmx/vmx_ops.h         |   1 +
 arch/x86/kvm/x86.c                 | 117 -----------------------------
 arch/x86/kvm/x86.h                 |   2 -
 include/linux/kvm_host.h           |   2 +
 virt/kvm/vac.h                     |   5 ++
 11 files changed, 58 insertions(+), 131 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 764be4a26a0c..340dcae9dd32 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -16,8 +16,6 @@ BUILD_BUG_ON(1)
  */
 KVM_X86_OP(vendor_exit)
 KVM_X86_OP(check_processor_compatibility)
-KVM_X86_OP(hardware_enable)
-KVM_X86_OP(hardware_disable)
 KVM_X86_OP(hardware_unsetup)
 KVM_X86_OP(has_emulated_msr)
 KVM_X86_OP(vcpu_after_set_cpuid)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index df5673c98e7b..fb2c72430c7a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4739,8 +4739,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.check_processor_compatibility = svm_check_processor_compat,
 
 	.hardware_unsetup = svm_hardware_unsetup,
-	.hardware_enable = svm_hardware_enable,
-	.hardware_disable = svm_hardware_disable,
 	.has_emulated_msr = svm_has_emulated_msr,
 
 	.vcpu_create = svm_vcpu_create,
diff --git a/arch/x86/kvm/svm/svm_ops.h b/arch/x86/kvm/svm/svm_ops.h
index 36c8af87a707..5e89c06b5147 100644
--- a/arch/x86/kvm/svm/svm_ops.h
+++ b/arch/x86/kvm/svm/svm_ops.h
@@ -4,6 +4,7 @@
 
 #include <linux/compiler_types.h>
 
+#include "../vac.h"
 #include "x86.h"
 
 #define svm_asm(insn, clobber...)				\
diff --git a/arch/x86/kvm/vac.c b/arch/x86/kvm/vac.c
index ab77aee4e1fa..79f5c2ac159a 100644
--- a/arch/x86/kvm/vac.c
+++ b/arch/x86/kvm/vac.c
@@ -3,6 +3,8 @@
 #include "vac.h"
 #include <asm/msr.h>
 
+extern bool kvm_rebooting;
+
 u32 __read_mostly kvm_uret_msrs_list[KVM_MAX_NR_USER_RETURN_MSRS];
 struct kvm_user_return_msrs __percpu *user_return_msrs;
 
@@ -35,7 +37,7 @@ void kvm_on_user_return(struct user_return_notifier *urn)
 	}
 }
 
-void kvm_user_return_msr_cpu_online(void)
+static void kvm_user_return_msr_cpu_online(void)
 {
 	unsigned int cpu = smp_processor_id();
 	struct kvm_user_return_msrs *msrs = per_cpu_ptr(user_return_msrs, cpu);
@@ -49,7 +51,7 @@ void kvm_user_return_msr_cpu_online(void)
 	}
 }
 
-void drop_user_return_notifiers(void)
+static void drop_user_return_notifiers(void)
 {
 	unsigned int cpu = smp_processor_id();
 	struct kvm_user_return_msrs *msrs = per_cpu_ptr(user_return_msrs, cpu);
@@ -117,6 +119,46 @@ int kvm_set_user_return_msr(unsigned int slot, u64 value, u64 mask)
 	return 0;
 }
 
+int kvm_arch_hardware_enable(void)
+{
+	int ret = -EIO;
+
+	kvm_user_return_msr_cpu_online();
+
+	if (kvm_is_vmx_supported())
+		ret = vmx_hardware_enable();
+	else if (kvm_is_svm_supported())
+		ret = svm_hardware_enable();
+	if (ret != 0)
+		return ret;
+
+	// TODO: Handle unstable TSC
+
+	return 0;
+}
+
+void kvm_arch_hardware_disable(void)
+{
+	if (kvm_is_vmx_supported())
+		vmx_hardware_disable();
+	else if (kvm_is_svm_supported())
+		svm_hardware_disable();
+	drop_user_return_notifiers();
+}
+
+/*
+ * Handle a fault on a hardware virtualization (VMX or SVM) instruction.
+ *
+ * Hardware virtualization extension instructions may fault if a reboot turns
+ * off virtualization while processes are running.  Usually after catching the
+ * fault we just panic; during reboot instead the instruction is ignored.
+ */
+noinstr void kvm_spurious_fault(void)
+{
+	/* Fault while not rebooting.  We want the trace. */
+	BUG_ON(!kvm_rebooting);
+}
+
 int kvm_alloc_user_return_msrs(void)
 {
 	user_return_msrs = alloc_percpu(struct kvm_user_return_msrs);
diff --git a/arch/x86/kvm/vac.h b/arch/x86/kvm/vac.h
index 5be30cce5a1c..daf1f137d196 100644
--- a/arch/x86/kvm/vac.h
+++ b/arch/x86/kvm/vac.h
@@ -5,13 +5,14 @@
 
 #include <linux/user-return-notifier.h>
 
-int __init vac_init(void);
-void vac_exit(void);
+void kvm_spurious_fault(void);
 
 #ifdef CONFIG_KVM_INTEL
 bool kvm_is_vmx_supported(void);
 int __init vac_vmx_init(void);
 void vac_vmx_exit(void);
+int vmx_hardware_enable(void);
+void vmx_hardware_disable(void);
 #else
 bool kvm_is_vmx_supported(void) { return false }
 int __init vac_vmx_init(void)
@@ -25,6 +26,8 @@ void vac_vmx_exit(void) {}
 bool kvm_is_svm_supported(void);
 int __init vac_svm_init(void);
 void vac_svm_exit(void);
+int svm_hardware_enable(void);
+void svm_hardware_disable(void);
 #else
 bool kvm_is_svm_supported(void) { return false }
 int __init vac_svm_init(void)
@@ -59,8 +62,6 @@ int kvm_add_user_return_msr(u32 msr);
 int kvm_find_user_return_msr(u32 msr);
 int kvm_set_user_return_msr(unsigned int slot, u64 value, u64 mask);
 void kvm_on_user_return(struct user_return_notifier *urn);
-void kvm_user_return_msr_cpu_online(void);
-void drop_user_return_notifiers(void);
 
 static inline bool kvm_is_supported_user_return_msr(u32 msr)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6301b49e0e80..69a6a8591996 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8013,8 +8013,6 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 
 	.hardware_unsetup = vmx_hardware_unsetup,
 
-	.hardware_enable = vmx_hardware_enable,
-	.hardware_disable = vmx_hardware_disable,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
 	.vm_size = sizeof(struct kvm_vmx),
diff --git a/arch/x86/kvm/vmx/vmx_ops.h b/arch/x86/kvm/vmx/vmx_ops.h
index 33af7b4c6eb4..60325fd39120 100644
--- a/arch/x86/kvm/vmx/vmx_ops.h
+++ b/arch/x86/kvm/vmx/vmx_ops.h
@@ -8,6 +8,7 @@
 
 #include "hyperv.h"
 #include "vmcs.h"
+#include "../vac.h"
 #include "../x86.h"
 
 void vmread_error(unsigned long field);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7466a5945147..a74139061e4d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -370,19 +370,6 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return 0;
 }
 
-/*
- * Handle a fault on a hardware virtualization (VMX or SVM) instruction.
- *
- * Hardware virtualization extension instructions may fault if a reboot turns
- * off virtualization while processes are running.  Usually after catching the
- * fault we just panic; during reboot instead the instruction is ignored.
- */
-noinstr void kvm_spurious_fault(void)
-{
-	/* Fault while not rebooting.  We want the trace. */
-	BUG_ON(!kvm_rebooting);
-}
-
 #define EXCPT_BENIGN		0
 #define EXCPT_CONTRIBUTORY	1
 #define EXCPT_PF		2
@@ -9363,7 +9350,6 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	return 0;
 
 out_unwind_ops:
-	kvm_x86_ops.hardware_enable = NULL;
 	static_call(kvm_x86_hardware_unsetup)();
 out_mmu_exit:
 	kvm_mmu_vendor_module_exit();
@@ -9414,7 +9400,6 @@ void kvm_x86_vendor_exit(void)
 	WARN_ON(static_branch_unlikely(&kvm_xen_enabled.key));
 #endif
 	mutex_lock(&vendor_module_lock);
-	kvm_x86_ops.hardware_enable = NULL;
 	mutex_unlock(&vendor_module_lock);
 }
 
@@ -11952,108 +11937,6 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 	kvm_rip_write(vcpu, 0);
 }
 
-int kvm_arch_hardware_enable(void)
-{
-	struct kvm *kvm;
-	struct kvm_vcpu *vcpu;
-	unsigned long i;
-	int ret;
-	u64 local_tsc;
-	u64 max_tsc = 0;
-	bool stable, backwards_tsc = false;
-
-	kvm_user_return_msr_cpu_online();
-
-	ret = kvm_x86_check_processor_compatibility();
-	if (ret)
-		return ret;
-
-	ret = static_call(kvm_x86_hardware_enable)();
-	if (ret != 0)
-		return ret;
-
-	local_tsc = rdtsc();
-	stable = !kvm_check_tsc_unstable();
-	list_for_each_entry(kvm, &vm_list, vm_list) {
-		kvm_for_each_vcpu(i, vcpu, kvm) {
-			if (!stable && vcpu->cpu == smp_processor_id())
-				kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
-			if (stable && vcpu->arch.last_host_tsc > local_tsc) {
-				backwards_tsc = true;
-				if (vcpu->arch.last_host_tsc > max_tsc)
-					max_tsc = vcpu->arch.last_host_tsc;
-			}
-		}
-	}
-
-	/*
-	 * Sometimes, even reliable TSCs go backwards.  This happens on
-	 * platforms that reset TSC during suspend or hibernate actions, but
-	 * maintain synchronization.  We must compensate.  Fortunately, we can
-	 * detect that condition here, which happens early in CPU bringup,
-	 * before any KVM threads can be running.  Unfortunately, we can't
-	 * bring the TSCs fully up to date with real time, as we aren't yet far
-	 * enough into CPU bringup that we know how much real time has actually
-	 * elapsed; our helper function, ktime_get_boottime_ns() will be using boot
-	 * variables that haven't been updated yet.
-	 *
-	 * So we simply find the maximum observed TSC above, then record the
-	 * adjustment to TSC in each VCPU.  When the VCPU later gets loaded,
-	 * the adjustment will be applied.  Note that we accumulate
-	 * adjustments, in case multiple suspend cycles happen before some VCPU
-	 * gets a chance to run again.  In the event that no KVM threads get a
-	 * chance to run, we will miss the entire elapsed period, as we'll have
-	 * reset last_host_tsc, so VCPUs will not have the TSC adjusted and may
-	 * loose cycle time.  This isn't too big a deal, since the loss will be
-	 * uniform across all VCPUs (not to mention the scenario is extremely
-	 * unlikely). It is possible that a second hibernate recovery happens
-	 * much faster than a first, causing the observed TSC here to be
-	 * smaller; this would require additional padding adjustment, which is
-	 * why we set last_host_tsc to the local tsc observed here.
-	 *
-	 * N.B. - this code below runs only on platforms with reliable TSC,
-	 * as that is the only way backwards_tsc is set above.  Also note
-	 * that this runs for ALL vcpus, which is not a bug; all VCPUs should
-	 * have the same delta_cyc adjustment applied if backwards_tsc
-	 * is detected.  Note further, this adjustment is only done once,
-	 * as we reset last_host_tsc on all VCPUs to stop this from being
-	 * called multiple times (one for each physical CPU bringup).
-	 *
-	 * Platforms with unreliable TSCs don't have to deal with this, they
-	 * will be compensated by the logic in vcpu_load, which sets the TSC to
-	 * catchup mode.  This will catchup all VCPUs to real time, but cannot
-	 * guarantee that they stay in perfect synchronization.
-	 */
-	if (backwards_tsc) {
-		u64 delta_cyc = max_tsc - local_tsc;
-		list_for_each_entry(kvm, &vm_list, vm_list) {
-			kvm->arch.backwards_tsc_observed = true;
-			kvm_for_each_vcpu(i, vcpu, kvm) {
-				vcpu->arch.tsc_offset_adjustment += delta_cyc;
-				vcpu->arch.last_host_tsc = local_tsc;
-				kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
-			}
-
-			/*
-			 * We have to disable TSC offset matching.. if you were
-			 * booting a VM while issuing an S4 host suspend....
-			 * you may have some problem.  Solving this issue is
-			 * left as an exercise to the reader.
-			 */
-			kvm->arch.last_tsc_nsec = 0;
-			kvm->arch.last_tsc_write = 0;
-		}
-
-	}
-	return 0;
-}
-
-void kvm_arch_hardware_disable(void)
-{
-	static_call(kvm_x86_hardware_disable)();
-	drop_user_return_notifiers();
-}
-
 bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
 {
 	return vcpu->kvm->arch.bsp_vcpu_id == vcpu->vcpu_id;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 1da8efcd3e9c..17ff3917b9a8 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -40,8 +40,6 @@ struct kvm_caps {
 	u64 supported_perf_cap;
 };
 
-void kvm_spurious_fault(void);
-
 #define KVM_NESTED_VMENTER_CONSISTENCY_CHECK(consistency_check)		\
 ({									\
 	bool failed = (consistency_check);				\
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f0afe549c0d6..d26671682764 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1467,9 +1467,11 @@ static inline void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu) {}
 #endif
 
 #ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
+#ifndef CONFIG_X86
 int kvm_arch_hardware_enable(void);
 void kvm_arch_hardware_disable(void);
 #endif
+#endif
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/vac.h b/virt/kvm/vac.h
index f3e7b08168df..b5159fa3f18d 100644
--- a/virt/kvm/vac.h
+++ b/virt/kvm/vac.h
@@ -13,6 +13,11 @@ int kvm_offline_cpu(unsigned int cpu);
 void hardware_disable_all(void);
 int hardware_enable_all(void);
 
+#ifdef CONFIG_X86
+int kvm_arch_hardware_enable(void);
+void kvm_arch_hardware_disable(void);
+#endif
+
 extern struct notifier_block kvm_reboot_notifier;
 
 extern struct syscore_ops kvm_syscore_ops;
-- 
2.42.0.869.gea05f2083d-goog


