Return-Path: <kvm+bounces-33261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D07C9E88D6
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 02:06:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A6CD1644E7
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 01:06:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9BB473446;
	Mon,  9 Dec 2024 01:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C5Mffl+k"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2811D481D1;
	Mon,  9 Dec 2024 01:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733706345; cv=none; b=uF1pVKXwp8xnDLAlnMi9GuSG6+Pz7R2PRtlPU2ymMP7W3+hBZ576BUlZ+Y6q4egtJGkvbOd7GAJBvGVZnTqS6aRQVxNHSMilSNH34lEJFQJsKwW4zpd+aYbQchHVDgovuKmUVBMnAbaE5RymtUGwN6EvzbY/CNGH4rSnaOMzckE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733706345; c=relaxed/simple;
	bh=4adhL5u3hUfgPLc4VTabWbBFLG8IN5BleN4J0IbXz1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z3FgYqFmvRvzzAm8RoctRwfepmpEfa1vCWSyvPf+ULIxBuTW57RsPRirNr5wCBJ1mS5EnPT/MLSFQt707ZuQU0d9WTVZdTsy8pRbnQj2ChhrR8niUS7xp43EEWxHudfBh7xsWYnt1uke94dNBCJKufNlVsD/LF1aALchtshxupo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C5Mffl+k; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733706343; x=1765242343;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4adhL5u3hUfgPLc4VTabWbBFLG8IN5BleN4J0IbXz1k=;
  b=C5Mffl+kgqq1nISTIhRJa1pK4Lr/ioZctuvZEi3e8uwlhWOZb8fGU4b7
   DWgaTdpiR7wECAcGJsQRp1lSyj5/f8Gxfu7Ecy7oAsCn1DsbALenLqPsY
   4ZyGWucUIUCRN2gTy7f5ybPF8mYEU9a8l1itOP5p4Nsp9EXevQiAb1iHI
   7KatfRX6geo05wbAu0UUuj3ZhmEUlgMmbCcHxUUk8p2MeKk8fgMrQ41kd
   V7iM+hSuY0516gC1lCqEg/ZRhv0xoh4Ewbn3jOj3yomnqYHubiK7SfNSc
   dFDUVRft7ctCsIWHZBuufkc05pRmebzN/UtaaJLr44kkiJ340q4OoBVvn
   g==;
X-CSE-ConnectionGUID: egmq0oN/ROCV2YzEZulyYQ==
X-CSE-MsgGUID: PALQuRNFRKeAHRsJWOy3/A==
X-IronPort-AV: E=McAfee;i="6700,10204,11280"; a="36833686"
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="36833686"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2024 17:05:43 -0800
X-CSE-ConnectionGUID: VSqs0o3jQwSkgERNq7SKqQ==
X-CSE-MsgGUID: tKn7eoaXR9KCv+HUwK3ixQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="95402407"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2024 17:05:39 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH 02/16] KVM: VMX: Remove use of struct vcpu_vmx from posted_intr.c
Date: Mon,  9 Dec 2024 09:07:16 +0800
Message-ID: <20241209010734.3543481-3-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Unify the layout for vcpu_vmx and vcpu_tdx at the top of the structure
with members needed in posted-intr.c, and introduce a struct vcpu_pi to
have the common part.  Use vcpu_pi instead of vcpu_vmx to enable TDX
compatibility with posted_intr.c.

To minimize the diff size, code conversion such as changing vmx->pi_desc
to vmx->common->pi_desc is avoided.  Instead, compile-time checks are
added to ensure the layout is as expected.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX interrupts breakout:
- Renamed from "KVM: TDX: remove use of struct vcpu_vmx from posted_interrupt.c"
  to "KVM: VMX: Remove use of struct vcpu_vmx from posted_intr.c".
- Use vcpu_pi instead vcpu_vmx in pi_wakeup_handler(). (Binbin)
- Update change log.
- Remove functional change from the code refactor patch, move into its
  own separate patch. (Chao)
---
 arch/x86/kvm/vmx/posted_intr.c | 43 +++++++++++++++++++++++++---------
 arch/x86/kvm/vmx/posted_intr.h | 11 +++++++++
 arch/x86/kvm/vmx/tdx.c         |  1 +
 arch/x86/kvm/vmx/tdx.h         | 11 +++++++++
 arch/x86/kvm/vmx/vmx.h         | 14 ++++++-----
 5 files changed, 63 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index ec08fa3caf43..8951c773a475 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -11,6 +11,7 @@
 #include "posted_intr.h"
 #include "trace.h"
 #include "vmx.h"
+#include "tdx.h"
 
 /*
  * Maintain a per-CPU list of vCPUs that need to be awakened by wakeup_handler()
@@ -31,9 +32,29 @@ static DEFINE_PER_CPU(struct list_head, wakeup_vcpus_on_cpu);
  */
 static DEFINE_PER_CPU(raw_spinlock_t, wakeup_vcpus_on_cpu_lock);
 
+/*
+ * The layout of the head of struct vcpu_vmx and struct vcpu_tdx must match with
+ * struct vcpu_pi.
+ */
+static_assert(offsetof(struct vcpu_pi, pi_desc) ==
+	      offsetof(struct vcpu_vmx, pi_desc));
+static_assert(offsetof(struct vcpu_pi, pi_wakeup_list) ==
+	      offsetof(struct vcpu_vmx, pi_wakeup_list));
+#ifdef CONFIG_INTEL_TDX_HOST
+static_assert(offsetof(struct vcpu_pi, pi_desc) ==
+	      offsetof(struct vcpu_tdx, pi_desc));
+static_assert(offsetof(struct vcpu_pi, pi_wakeup_list) ==
+	      offsetof(struct vcpu_tdx, pi_wakeup_list));
+#endif
+
+static inline struct vcpu_pi *vcpu_to_pi(struct kvm_vcpu *vcpu)
+{
+	return (struct vcpu_pi *)vcpu;
+}
+
 static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
 {
-	return &(to_vmx(vcpu)->pi_desc);
+	return &vcpu_to_pi(vcpu)->pi_desc;
 }
 
 static int pi_try_set_control(struct pi_desc *pi_desc, u64 *pold, u64 new)
@@ -52,8 +73,8 @@ static int pi_try_set_control(struct pi_desc *pi_desc, u64 *pold, u64 new)
 
 void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 {
-	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct vcpu_pi *vcpu_pi = vcpu_to_pi(vcpu);
+	struct pi_desc *pi_desc = &vcpu_pi->pi_desc;
 	struct pi_desc old, new;
 	unsigned long flags;
 	unsigned int dest;
@@ -90,7 +111,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 	 */
 	if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR) {
 		raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
-		list_del(&vmx->pi_wakeup_list);
+		list_del(&vcpu_pi->pi_wakeup_list);
 		raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
 	}
 
@@ -145,15 +166,15 @@ static bool vmx_can_use_vtd_pi(struct kvm *kvm)
  */
 static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
 {
-	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct vcpu_pi *vcpu_pi = vcpu_to_pi(vcpu);
+	struct pi_desc *pi_desc = &vcpu_pi->pi_desc;
 	struct pi_desc old, new;
 	unsigned long flags;
 
 	local_irq_save(flags);
 
 	raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
-	list_add_tail(&vmx->pi_wakeup_list,
+	list_add_tail(&vcpu_pi->pi_wakeup_list,
 		      &per_cpu(wakeup_vcpus_on_cpu, vcpu->cpu));
 	raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
 
@@ -220,13 +241,13 @@ void pi_wakeup_handler(void)
 	int cpu = smp_processor_id();
 	struct list_head *wakeup_list = &per_cpu(wakeup_vcpus_on_cpu, cpu);
 	raw_spinlock_t *spinlock = &per_cpu(wakeup_vcpus_on_cpu_lock, cpu);
-	struct vcpu_vmx *vmx;
+	struct vcpu_pi *pi;
 
 	raw_spin_lock(spinlock);
-	list_for_each_entry(vmx, wakeup_list, pi_wakeup_list) {
+	list_for_each_entry(pi, wakeup_list, pi_wakeup_list) {
 
-		if (pi_test_on(&vmx->pi_desc))
-			kvm_vcpu_wake_up(&vmx->vcpu);
+		if (pi_test_on(&pi->pi_desc))
+			kvm_vcpu_wake_up(&pi->vcpu);
 	}
 	raw_spin_unlock(spinlock);
 }
diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
index 1715d2ab07be..e579e8c3ad2e 100644
--- a/arch/x86/kvm/vmx/posted_intr.h
+++ b/arch/x86/kvm/vmx/posted_intr.h
@@ -5,6 +5,17 @@
 #include <linux/find.h>
 #include <asm/posted_intr.h>
 
+struct vcpu_pi {
+	struct kvm_vcpu	vcpu;
+
+	/* Posted interrupt descriptor */
+	struct pi_desc pi_desc;
+
+	/* Used if this vCPU is waiting for PI notification wakeup. */
+	struct list_head pi_wakeup_list;
+	/* Until here common layout between vcpu_vmx and vcpu_tdx. */
+};
+
 void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu);
 void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu);
 void pi_wakeup_handler(void);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 877cf9e1fd65..478da0ebd225 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -723,6 +723,7 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 
 	fpstate_set_confidential(&vcpu->arch.guest_fpu);
 	vcpu->arch.apic->guest_apic_protected = true;
+	INIT_LIST_HEAD(&tdx->pi_wakeup_list);
 
 	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
 
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index a7dd2b0b5dd7..d6a0fc20ecaa 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -17,6 +17,10 @@ enum kvm_tdx_state {
 	TD_STATE_RUNNABLE,
 };
 
+
+#include "irq.h"
+#include "posted_intr.h"
+
 struct kvm_tdx {
 	struct kvm kvm;
 
@@ -52,6 +56,13 @@ enum tdx_prepare_switch_state {
 struct vcpu_tdx {
 	struct kvm_vcpu	vcpu;
 
+	/* Posted interrupt descriptor */
+	struct pi_desc pi_desc;
+
+	/* Used if this vCPU is waiting for PI notification wakeup. */
+	struct list_head pi_wakeup_list;
+	/* Until here same layout to struct vcpu_pi. */
+
 	unsigned long tdvpr_pa;
 	unsigned long *tdcx_pa;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 37a555c6dfbf..e7f570ca3c19 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -230,6 +230,14 @@ struct nested_vmx {
 
 struct vcpu_vmx {
 	struct kvm_vcpu       vcpu;
+
+	/* Posted interrupt descriptor */
+	struct pi_desc pi_desc;
+
+	/* Used if this vCPU is waiting for PI notification wakeup. */
+	struct list_head pi_wakeup_list;
+	/* Until here same layout to struct vcpu_pi. */
+
 	u8                    fail;
 	u8		      x2apic_msr_bitmap_mode;
 
@@ -299,12 +307,6 @@ struct vcpu_vmx {
 
 	union vmx_exit_reason exit_reason;
 
-	/* Posted interrupt descriptor */
-	struct pi_desc pi_desc;
-
-	/* Used if this vCPU is waiting for PI notification wakeup. */
-	struct list_head pi_wakeup_list;
-
 	/* Support for a guest hypervisor (nested VMX) */
 	struct nested_vmx nested;
 
-- 
2.46.0


