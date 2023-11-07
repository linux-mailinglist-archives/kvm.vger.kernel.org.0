Return-Path: <kvm+bounces-1081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 99E927E49BE
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 21:21:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1A078B213FD
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 20:21:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB44938DE4;
	Tue,  7 Nov 2023 20:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HKG4ED9r"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B6B38DD2
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 20:20:47 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3E21BD5
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 12:20:46 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5afc00161daso71888637b3.1
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 12:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699388445; x=1699993245; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZQAw0ON8pSiwfP7SCUimnogabyDDeRCkLmZQJGRc1WY=;
        b=HKG4ED9ralL7HpTRXxFcYdGMCZ6vxeAcJgB2E+W58e1EwGHtdSIWVgPHOBUpT1eMzR
         vBp53Lb0XNeblTE1V7J6+7odMA5sPjc8srF1jU/PlLrxQNRUumjLdtcTWxSZsffKe8gA
         PXAh1T19/YNPOVZnySMN6aPbK2UvHIAYzto+Kc1/tqX0aG10e7O5pN01u2zIFN5RVZae
         KQ9URE/heaj6B/uSQHW3pLQfpQxb4Vhod8wXyB6rCJ5Rsfx0LT/+W3J2Pau7ARO0iuq1
         0ST0S9P0qN3X/hyhMJU7NBG+GUvh0CaDbJUhsoyDEdn2pLxqJUb59sJZ3sTugFanjz3y
         c7ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699388445; x=1699993245;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZQAw0ON8pSiwfP7SCUimnogabyDDeRCkLmZQJGRc1WY=;
        b=ubrYUghYMp0o1yxcs0G6C3922p8iGfqQl/4llgQIAYM2asdSNv8/YdZ2eOvkBHatNB
         3BUvmAJ6Zwiuo/UkjG34nAmdttIwskALDvUTaxyUlqT2TOwMJU+u+23UMOYWgjQgpFqw
         qKwWXY8rgHyRousALzn1/Ie2nAjRXC6thnLIe1gO3dcu562PnFCz/KZxr5W216E/N2CQ
         zPLz2RP5uYWo3ud5HqolMFQTNw7dmmoblwTcsbGZkVpoIBCdpXc8XHqMF948TtImz0FQ
         ZNouKvKSreRKYAIlhwwo6da5wUvM3B0DqppzXvfnytKD0QabKm8zezVJhv4bhm2V6X5r
         4kJw==
X-Gm-Message-State: AOJu0YwKgFPJkzBKnavgqbirMmFa7zgcukLWADkD/caZJ4ENp25v7Wfo
	nhZIbh6OPIZIYXBSgb7jSq6H4NoyBgh95BTGsazWy30aDPbz/qF1cO+Hr2iTyX56pVhS2AXZJ/2
	mY5WiLqOfrDhHpc30q8L4UVesx9cDb1h0EYZ097qCYMJGto7TlobH0iXQHfFF3aw=
X-Google-Smtp-Source: AGHT+IGGp0RrdBk3N/KBsHjgBX08s9Oh/FJF/LwNEpoqYzP7pNtygHXRwITYMsVvon7NnSywaSRhHMZFH7k/Og==
X-Received: from aghulati-dev.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:18bb])
 (user=aghulati job=sendgmr) by 2002:a0d:df4d:0:b0:5a7:b8d1:ef65 with SMTP id
 i74-20020a0ddf4d000000b005a7b8d1ef65mr286460ywe.3.1699388445403; Tue, 07 Nov
 2023 12:20:45 -0800 (PST)
Date: Tue,  7 Nov 2023 20:20:02 +0000
In-Reply-To: <20231107202002.667900-1-aghulati@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231107202002.667900-1-aghulati@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231107202002.667900-15-aghulati@google.com>
Subject: [RFC PATCH 14/14] KVM: VAC: Bring up VAC as a new module
From: Anish Ghulati <aghulati@google.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, hpa@zytor.com, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, peterz@infradead.org, paulmck@kernel.org, 
	Mark Rutland <mark.rutland@arm.com>
Cc: Anish Ghulati <aghulati@google.com>
Content-Type: text/plain; charset="UTF-8"

Add Kconfig options to build VAC as a new module. Make KVM dependent on
this new "base" module.

Add another Kconfig option to accept a postfix ID for multi-KVM. This
option allows setting a postfix to KVM module and character device names
to distinguish multiple KVMs running on the same host. Set the default
value to null.

Opportunistically fix indentation on the Makefile.

Resolve TODOs by moving vac_vmx/svm_init/exit() calls to the module_init
and module_exit functions of VAC.

Add exports for VAC data and functions that are required in KVM. Also
make some functions private now that they are not needed outside VAC.

TODO: Fix the module name, which is currently set to kvm-vac.

Signed-off-by: Anish Ghulati <aghulati@google.com>
---
 arch/x86/kvm/Kconfig      | 17 ++++++++++++++++
 arch/x86/kvm/Makefile     | 29 +++++++++++++++------------
 arch/x86/kvm/svm/svm.c    |  3 ---
 arch/x86/kvm/svm/vac.c    |  8 +++++++-
 arch/x86/kvm/vac.c        | 42 +++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/vac.h        |  2 --
 arch/x86/kvm/vmx/nested.c |  5 +++--
 arch/x86/kvm/vmx/vac.c    | 25 ++++++++++++++++++++---
 arch/x86/kvm/vmx/vac.h    |  2 --
 arch/x86/kvm/vmx/vmx.c    | 14 +++++--------
 arch/x86/kvm/x86.c        |  7 -------
 virt/kvm/Makefile.kvm     | 15 +++++++-------
 virt/kvm/kvm_main.c       |  7 ++++---
 virt/kvm/vac.c            |  7 +++++++
 14 files changed, 128 insertions(+), 55 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index adfa57d59643..42a0a0107572 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -17,10 +17,19 @@ menuconfig VIRTUALIZATION
 
 if VIRTUALIZATION
 
+config VAC
+	tristate "Virtualization Acceleration Component (VAC)"
+	select KVM_GENERIC_HARDWARE_ENABLING
+	help
+	  Support running multiple KVM modules on the same host. If VAC is not
+          selected to run as a separate module, it will run as part of KVM, and
+          the system will only support a single KVM.
+
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
 	depends on HIGH_RES_TIMERS
 	depends on X86_LOCAL_APIC
+	depends on VAC
 	select PREEMPT_NOTIFIERS
 	select MMU_NOTIFIER
 	select HAVE_KVM_IRQCHIP
@@ -60,6 +69,14 @@ config KVM
 
 	  If unsure, say N.
 
+config KVM_ID
+	string "KVM: Postfix ID for multi-KVM"
+	depends on KVM
+	default ""
+	help
+	  This is the postfix string to append to the KVM module and
+          character device to differentiate multiple KVM builds.
+
 config KVM_WERROR
 	bool "Compile KVM with -Werror"
 	# KASAN may cause the build to fail due to larger frames
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index b3de4bd7988f..48d263ecaffa 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -8,33 +8,36 @@ endif
 
 include $(srctree)/virt/kvm/Makefile.kvm
 
-kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
+kvm-vac-y                   := $(KVM)/vac.o vac.o
+kvm-vac-$(CONFIG_KVM_INTEL) += vmx/vac.o
+kvm-vac-$(CONFIG_KVM_AMD)   += svm/vac.o
+
+kvm$(CONFIG_KVM_ID)-y	   += x86.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
 			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o \
 			   mmu/spte.o
 
-kvm-y                   += vac.o vmx/vac.o svm/vac.o
-
 ifdef CONFIG_HYPERV
-kvm-y			+= kvm_onhyperv.o
+kvm$(CONFIG_KVM_ID)-y	    += kvm_onhyperv.o
 endif
 
-kvm-$(CONFIG_X86_64) += mmu/tdp_iter.o mmu/tdp_mmu.o
-kvm-$(CONFIG_KVM_XEN)	+= xen.o
-kvm-$(CONFIG_KVM_SMM)	+= smm.o
+kvm$(CONFIG_KVM_ID)-$(CONFIG_X86_64)    	+= mmu/tdp_iter.o mmu/tdp_mmu.o
+kvm$(CONFIG_KVM_ID)-$(CONFIG_KVM_XEN)		+= xen.o
+kvm$(CONFIG_KVM_ID)-$(CONFIG_KVM_SMM)		+= smm.o
 
-kvm-$(CONFIG_KVM_INTEL)	+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
-			   vmx/hyperv.o vmx/nested.o vmx/posted_intr.o
-kvm-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
+kvm$(CONFIG_KVM_ID)-$(CONFIG_KVM_INTEL)		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
+						vmx/hyperv.o vmx/nested.o vmx/posted_intr.o
+kvm$(CONFIG_KVM_ID)-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
 
-kvm-$(CONFIG_KVM_AMD)	+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o \
-			   svm/sev.o svm/hyperv.o
+kvm$(CONFIG_KVM_ID)-$(CONFIG_KVM_AMD)		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o \
+						svm/sev.o svm/hyperv.o
 
 ifdef CONFIG_HYPERV
 kvm-$(CONFIG_KVM_AMD)	+= svm/svm_onhyperv.o
 endif
 
-obj-$(CONFIG_KVM)	+= kvm.o
+obj-$(CONFIG_VAC)       += kvm-vac.o
+obj-$(CONFIG_KVM)	+= kvm$(CONFIG_KVM_ID).o
 
 AFLAGS_svm/vmenter.o    := -iquote $(obj)
 $(obj)/svm/vmenter.o: $(obj)/kvm-asm-offsets.h
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index fb2c72430c7a..6b9f81fc84db 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5166,9 +5166,6 @@ int __init svm_init(void)
 	if (r)
 		return r;
 
-	//TODO: Remove this init call once VAC is a module
-	vac_svm_init();
-
 	/*
 	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
 	 * exposed to userspace!
diff --git a/arch/x86/kvm/svm/vac.c b/arch/x86/kvm/svm/vac.c
index 7c4db99ca7d5..37ad2a3a9d2d 100644
--- a/arch/x86/kvm/svm/vac.c
+++ b/arch/x86/kvm/svm/vac.c
@@ -8,7 +8,10 @@
 #include "vac.h"
 
 DEFINE_PER_CPU(struct svm_cpu_data, svm_data);
+EXPORT_SYMBOL_GPL(svm_data);
+
 unsigned int max_sev_asid;
+EXPORT_SYMBOL_GPL(max_sev_asid);
 
 static bool __kvm_is_svm_supported(void)
 {
@@ -52,6 +55,7 @@ bool kvm_is_svm_supported(void)
 
 	return supported;
 }
+EXPORT_SYMBOL_GPL(kvm_is_svm_supported);
 
 static inline void kvm_cpu_svm_disable(void)
 {
@@ -87,6 +91,7 @@ void svm_hardware_disable(void)
 
 	amd_pmu_disable_virt();
 }
+EXPORT_SYMBOL_GPL(svm_hardware_disable);
 
 int svm_hardware_enable(void)
 {
@@ -152,6 +157,7 @@ int svm_hardware_enable(void)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(svm_hardware_enable);
 
 int __init vac_svm_init(void)
 {
@@ -160,7 +166,7 @@ int __init vac_svm_init(void)
 	return 0;
 }
 
-void vac_svm_exit(void)
+void __exit vac_svm_exit(void)
 {
 	cpu_emergency_unregister_virt_callback(svm_emergency_disable);
 }
diff --git a/arch/x86/kvm/vac.c b/arch/x86/kvm/vac.c
index 79f5c2ac159a..2d7ca59b4c90 100644
--- a/arch/x86/kvm/vac.c
+++ b/arch/x86/kvm/vac.c
@@ -2,13 +2,18 @@
 
 #include "vac.h"
 #include <asm/msr.h>
+#include <linux/module.h>
+
+MODULE_LICENSE("GPL");
 
 extern bool kvm_rebooting;
 
 u32 __read_mostly kvm_uret_msrs_list[KVM_MAX_NR_USER_RETURN_MSRS];
 struct kvm_user_return_msrs __percpu *user_return_msrs;
+EXPORT_SYMBOL_GPL(user_return_msrs);
 
 u32 __read_mostly kvm_nr_uret_msrs;
+EXPORT_SYMBOL_GPL(kvm_nr_uret_msrs);
 
 void kvm_on_user_return(struct user_return_notifier *urn)
 {
@@ -85,6 +90,7 @@ int kvm_add_user_return_msr(u32 msr)
 	kvm_uret_msrs_list[kvm_nr_uret_msrs] = msr;
 	return kvm_nr_uret_msrs++;
 }
+EXPORT_SYMBOL_GPL(kvm_add_user_return_msr);
 
 int kvm_find_user_return_msr(u32 msr)
 {
@@ -96,6 +102,7 @@ int kvm_find_user_return_msr(u32 msr)
 	}
 	return -1;
 }
+EXPORT_SYMBOL_GPL(kvm_find_user_return_msr);
 
 int kvm_set_user_return_msr(unsigned int slot, u64 value, u64 mask)
 {
@@ -118,6 +125,7 @@ int kvm_set_user_return_msr(unsigned int slot, u64 value, u64 mask)
 	}
 	return 0;
 }
+EXPORT_SYMBOL_GPL(kvm_set_user_return_msr);
 
 int kvm_arch_hardware_enable(void)
 {
@@ -158,8 +166,9 @@ noinstr void kvm_spurious_fault(void)
 	/* Fault while not rebooting.  We want the trace. */
 	BUG_ON(!kvm_rebooting);
 }
+EXPORT_SYMBOL_GPL(kvm_spurious_fault);
 
-int kvm_alloc_user_return_msrs(void)
+static int kvm_alloc_user_return_msrs(void)
 {
 	user_return_msrs = alloc_percpu(struct kvm_user_return_msrs);
 	if (!user_return_msrs) {
@@ -170,7 +179,36 @@ int kvm_alloc_user_return_msrs(void)
 	return 0;
 }
 
-void kvm_free_user_return_msrs(void)
+static void kvm_free_user_return_msrs(void)
 {
 	free_percpu(user_return_msrs);
 }
+
+int __init vac_init(void)
+{
+	int r = 0;
+
+	r = kvm_alloc_user_return_msrs();
+	if (r)
+		goto out_user_return_msrs;
+
+	if (kvm_is_vmx_supported())
+		r = vac_vmx_init();
+	else if (kvm_is_svm_supported())
+		r = vac_svm_init();
+
+out_user_return_msrs:
+	return r;
+}
+module_init(vac_init);
+
+void __exit vac_exit(void)
+{
+	if (kvm_is_vmx_supported())
+		vac_vmx_exit();
+	else if (kvm_is_svm_supported())
+		vac_svm_exit();
+
+	kvm_free_user_return_msrs();
+}
+module_exit(vac_exit);
diff --git a/arch/x86/kvm/vac.h b/arch/x86/kvm/vac.h
index daf1f137d196..a40e5309ec5f 100644
--- a/arch/x86/kvm/vac.h
+++ b/arch/x86/kvm/vac.h
@@ -56,8 +56,6 @@ struct kvm_user_return_msrs {
 
 extern u32 __read_mostly kvm_nr_uret_msrs;
 
-int kvm_alloc_user_return_msrs(void);
-void kvm_free_user_return_msrs(void);
 int kvm_add_user_return_msr(u32 msr);
 int kvm_find_user_return_msr(u32 msr);
 int kvm_set_user_return_msr(unsigned int slot, u64 value, u64 mask);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 5c6ac7662453..c4999b4cf257 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -307,7 +307,8 @@ static void free_nested(struct kvm_vcpu *vcpu)
 	vmx->nested.vmxon = false;
 	vmx->nested.smm.vmxon = false;
 	vmx->nested.vmxon_ptr = INVALID_GPA;
-	free_vpid(vmx->nested.vpid02);
+	if (enable_vpid)
+		free_vpid(vmx->nested.vpid02);
 	vmx->nested.posted_intr_nv = -1;
 	vmx->nested.current_vmptr = INVALID_GPA;
 	if (enable_shadow_vmcs) {
@@ -5115,7 +5116,7 @@ static int enter_vmx_operation(struct kvm_vcpu *vcpu)
 		     HRTIMER_MODE_ABS_PINNED);
 	vmx->nested.preemption_timer.function = vmx_preemption_timer_fn;
 
-	vmx->nested.vpid02 = allocate_vpid();
+	vmx->nested.vpid02 = enable_vpid ? allocate_vpid() : 0;
 
 	vmx->nested.vmcs02_initialized = false;
 	vmx->nested.vmxon = true;
diff --git a/arch/x86/kvm/vmx/vac.c b/arch/x86/kvm/vmx/vac.c
index cdfdeb67a719..e147b9890c99 100644
--- a/arch/x86/kvm/vmx/vac.c
+++ b/arch/x86/kvm/vmx/vac.c
@@ -8,6 +8,10 @@
 #include "vmx_ops.h"
 #include "posted_intr.h"
 
+// TODO: Move these to VAC
+void vmclear_error(struct vmcs *vmcs, u64 phys_addr) {}
+void invept_error(unsigned long ext, u64 eptp, gpa_t gpa) {}
+
 /*
  * We maintain a per-CPU linked-list of VMCS loaded on that CPU. This is needed
  * when a CPU is brought down, and we need to VMCLEAR all VMCSs loaded on it.
@@ -17,16 +21,19 @@ static DEFINE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
 static DEFINE_PER_CPU(struct vmcs *, vmxarea);
 
 DEFINE_PER_CPU(struct vmcs *, current_vmcs);
+EXPORT_SYMBOL_GPL(current_vmcs);
 
 void vac_set_vmxarea(struct vmcs *vmcs, int cpu)
 {
 	per_cpu(vmxarea, cpu) = vmcs;
 }
+EXPORT_SYMBOL_GPL(vac_set_vmxarea);
 
 struct vmcs *vac_get_vmxarea(int cpu)
 {
 	return per_cpu(vmxarea, cpu);
 }
+EXPORT_SYMBOL_GPL(vac_get_vmxarea);
 
 static DECLARE_BITMAP(vmx_vpid_bitmap, VMX_NR_VPIDS);
 static DEFINE_SPINLOCK(vmx_vpid_lock);
@@ -59,6 +66,7 @@ bool kvm_is_vmx_supported(void)
 
 	return supported;
 }
+EXPORT_SYMBOL_GPL(kvm_is_vmx_supported);
 
 int allocate_vpid(void)
 {
@@ -75,6 +83,7 @@ int allocate_vpid(void)
 	spin_unlock(&vmx_vpid_lock);
 	return vpid;
 }
+EXPORT_SYMBOL_GPL(allocate_vpid);
 
 void free_vpid(int vpid)
 {
@@ -84,6 +93,7 @@ void free_vpid(int vpid)
 	__clear_bit(vpid, vmx_vpid_bitmap);
 	spin_unlock(&vmx_vpid_lock);
 }
+EXPORT_SYMBOL_GPL(free_vpid);
 
 void add_vmcs_to_loaded_vmcss_on_cpu(
 		struct list_head *loaded_vmcss_on_cpu_link,
@@ -91,6 +101,7 @@ void add_vmcs_to_loaded_vmcss_on_cpu(
 {
 	list_add(loaded_vmcss_on_cpu_link, &per_cpu(loaded_vmcss_on_cpu, cpu));
 }
+EXPORT_SYMBOL_GPL(add_vmcs_to_loaded_vmcss_on_cpu);
 
 static void __loaded_vmcs_clear(void *arg)
 {
@@ -130,6 +141,7 @@ void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs)
 			 __loaded_vmcs_clear, loaded_vmcs, 1);
 
 }
+EXPORT_SYMBOL_GPL(loaded_vmcs_clear);
 
 static int kvm_cpu_vmxon(u64 vmxon_pointer)
 {
@@ -175,11 +187,16 @@ int vmx_hardware_enable(void)
 		return r;
 	}
 
-	if (enable_ept)
+	// TODO: VAC: Since we can have a mix of KVMs with enable_ept=0 and =1,
+	// we need to perform a global INVEPT here.
+	// TODO: Check for the
+	// vmx_capability invept bit before executing this.
+	if (1)
 		ept_sync_global();
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vmx_hardware_enable);
 
 static void vmclear_local_loaded_vmcss(void)
 {
@@ -246,6 +263,7 @@ void vmx_hardware_disable(void)
 
 	intel_pt_handle_vmx(0);
 }
+EXPORT_SYMBOL_GPL(vmx_hardware_disable);
 
 int __init vac_vmx_init(void)
 {
@@ -254,7 +272,8 @@ int __init vac_vmx_init(void)
 	for_each_possible_cpu(cpu) {
 		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
 
-		pi_init_cpu(cpu);
+		// TODO: Move posted interrupts list to VAC
+		// pi_init_cpu(cpu);
 	}
 
 	cpu_emergency_register_virt_callback(vmx_emergency_disable);
@@ -262,7 +281,7 @@ int __init vac_vmx_init(void)
 	return 0;
 }
 
-void vac_vmx_exit(void)
+void __exit vac_vmx_exit(void)
 {
 	cpu_emergency_unregister_virt_callback(vmx_emergency_disable);
 }
diff --git a/arch/x86/kvm/vmx/vac.h b/arch/x86/kvm/vmx/vac.h
index d5af0ca67e3f..991df7ad9d81 100644
--- a/arch/x86/kvm/vmx/vac.h
+++ b/arch/x86/kvm/vmx/vac.h
@@ -16,7 +16,5 @@ void add_vmcs_to_loaded_vmcss_on_cpu(
 		struct list_head *loaded_vmcss_on_cpu_link,
 		int cpu);
 void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs);
-int vmx_hardware_enable(void);
-void vmx_hardware_disable(void);
 
 #endif // ARCH_X86_KVM_VMX_VAC_H
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 69a6a8591996..8d749da61c71 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7201,7 +7201,8 @@ static void vmx_vcpu_free(struct kvm_vcpu *vcpu)
 
 	if (enable_pml)
 		vmx_destroy_pml_buffer(vmx);
-	free_vpid(vmx->vpid);
+	if (enable_vpid)
+		free_vpid(vmx->vpid);
 	nested_vmx_free_vcpu(vcpu);
 	free_loaded_vmcs(vmx->loaded_vmcs);
 }
@@ -7219,7 +7220,7 @@ static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 
 	err = -ENOMEM;
 
-	vmx->vpid = allocate_vpid();
+	vmx->vpid = enable_vpid ? allocate_vpid() : 0;
 
 	/*
 	 * If PML is turned on, failure on enabling PML just results in failure
@@ -7308,7 +7309,8 @@ static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 free_pml:
 	vmx_destroy_pml_buffer(vmx);
 free_vpid:
-	free_vpid(vmx->vpid);
+	if (enable_vpid)
+		free_vpid(vmx->vpid);
 	return err;
 }
 
@@ -7992,9 +7994,6 @@ static void __vmx_exit(void)
 {
 	allow_smaller_maxphyaddr = false;
 
-	//TODO: Remove this exit call once VAC is a module
-	vac_vmx_exit();
-
 	vmx_cleanup_l1d_flush();
 }
 
@@ -8436,9 +8435,6 @@ int __init vmx_init(void)
 	if (r)
 		goto err_l1d_flush;
 
-	//TODO: Remove this init call once VAC is a module
-	vac_vmx_init();
-
 	vmx_check_vmcs12_offsets();
 
 	/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a74139061e4d..57b5bee2d484 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9274,10 +9274,6 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 		return -ENOMEM;
 	}
 
-	r = kvm_alloc_user_return_msrs();
-	if (r)
-		goto out_free_x86_emulator_cache;
-
 	r = kvm_mmu_vendor_module_init();
 	if (r)
 		goto out_free_percpu;
@@ -9354,8 +9350,6 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 out_mmu_exit:
 	kvm_mmu_vendor_module_exit();
 out_free_percpu:
-	kvm_free_user_return_msrs();
-out_free_x86_emulator_cache:
 	kmem_cache_destroy(x86_emulator_cache);
 	return r;
 }
@@ -9393,7 +9387,6 @@ void kvm_x86_vendor_exit(void)
 #endif
 	static_call(kvm_x86_hardware_unsetup)();
 	kvm_mmu_vendor_module_exit();
-	kvm_free_user_return_msrs();
 	kmem_cache_destroy(x86_emulator_cache);
 #ifdef CONFIG_KVM_XEN
 	static_key_deferred_flush(&kvm_xen_enabled);
diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
index 7876021ea4d7..f1ad75797fe8 100644
--- a/virt/kvm/Makefile.kvm
+++ b/virt/kvm/Makefile.kvm
@@ -7,13 +7,12 @@ ccflags-y += -I$(srctree)/$(src) -D__KVM__
 
 KVM ?= ../../../virt/kvm
 
-kvm-y := $(KVM)/kvm_main.o $(KVM)/eventfd.o $(KVM)/binary_stats.o
+kvm$(CONFIG_KVM_ID)-y := $(KVM)/kvm_main.o $(KVM)/eventfd.o $(KVM)/binary_stats.o
 ifdef CONFIG_VFIO
-kvm-y += $(KVM)/vfio.o
+kvm$(CONFIG_KVM_ID)-y += $(KVM)/vfio.o
 endif
-kvm-y += $(KVM)/vac.o
-kvm-$(CONFIG_KVM_MMIO) += $(KVM)/coalesced_mmio.o
-kvm-$(CONFIG_KVM_ASYNC_PF) += $(KVM)/async_pf.o
-kvm-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
-kvm-$(CONFIG_HAVE_KVM_DIRTY_RING) += $(KVM)/dirty_ring.o
-kvm-$(CONFIG_HAVE_KVM_PFNCACHE) += $(KVM)/pfncache.o
+kvm$(CONFIG_KVM_ID)-$(CONFIG_KVM_MMIO) += $(KVM)/coalesced_mmio.o
+kvm$(CONFIG_KVM_ID)-$(CONFIG_KVM_ASYNC_PF) += $(KVM)/async_pf.o
+kvm$(CONFIG_KVM_ID)-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
+kvm$(CONFIG_KVM_ID)-$(CONFIG_HAVE_KVM_DIRTY_RING) += $(KVM)/dirty_ring.o
+kvm$(CONFIG_KVM_ID)-$(CONFIG_HAVE_KVM_PFNCACHE) += $(KVM)/pfncache.o
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 575f044fd842..c4af06b1e62c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5163,9 +5163,8 @@ static struct file_operations kvm_chardev_ops = {
 };
 
 static struct miscdevice kvm_dev = {
-	KVM_MINOR,
-	"kvm",
-	&kvm_chardev_ops,
+	.minor = KVM_MINOR,
+	.fops = &kvm_chardev_ops,
 };
 
 static void kvm_iodevice_destructor(struct kvm_io_device *dev)
@@ -5914,7 +5913,9 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	/*
 	 * Registration _must_ be the very last thing done, as this exposes
 	 * /dev/kvm to userspace, i.e. all infrastructure must be setup!
+	 * Append CONFIG_KVM_ID to the device name.
 	 */
+	kvm_dev.name = kasprintf(GFP_KERNEL, "kvm%s", CONFIG_KVM_ID);
 	r = misc_register(&kvm_dev);
 	if (r) {
 		pr_err("kvm: misc device register failed\n");
diff --git a/virt/kvm/vac.c b/virt/kvm/vac.c
index c628afeb3d4b..60f5bec2659a 100644
--- a/virt/kvm/vac.c
+++ b/virt/kvm/vac.c
@@ -10,6 +10,7 @@ DEFINE_PER_CPU(cpumask_var_t, cpu_kick_mask);
 EXPORT_SYMBOL(cpu_kick_mask);
 
 DEFINE_PER_CPU(struct kvm_vcpu *, kvm_running_vcpu);
+EXPORT_SYMBOL_GPL(kvm_running_vcpu);
 
 #ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
 DEFINE_MUTEX(vac_lock);
@@ -56,6 +57,7 @@ int kvm_online_cpu(unsigned int cpu)
 	mutex_unlock(&vac_lock);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(kvm_online_cpu);
 
 static void hardware_disable_nolock(void *junk)
 {
@@ -79,6 +81,7 @@ int kvm_offline_cpu(unsigned int cpu)
 	mutex_unlock(&vac_lock);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(kvm_offline_cpu);
 
 static void hardware_disable_all_nolock(void)
 {
@@ -97,6 +100,7 @@ void hardware_disable_all(void)
 	mutex_unlock(&vac_lock);
 	cpus_read_unlock();
 }
+EXPORT_SYMBOL_GPL(hardware_disable_all);
 
 int hardware_enable_all(void)
 {
@@ -129,6 +133,7 @@ int hardware_enable_all(void)
 
 	return r;
 }
+EXPORT_SYMBOL_GPL(hardware_enable_all);
 
 static int kvm_reboot(struct notifier_block *notifier, unsigned long val,
 		      void *v)
@@ -176,10 +181,12 @@ struct notifier_block kvm_reboot_notifier = {
 	.notifier_call = kvm_reboot,
 	.priority = 0,
 };
+EXPORT_SYMBOL_GPL(kvm_reboot_notifier);
 
 struct syscore_ops kvm_syscore_ops = {
 	.suspend = kvm_suspend,
 	.resume = kvm_resume,
 };
+EXPORT_SYMBOL_GPL(kvm_syscore_ops);
 
 #endif
-- 
2.42.0.869.gea05f2083d-goog


