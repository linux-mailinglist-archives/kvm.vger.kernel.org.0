Return-Path: <kvm+bounces-66444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1713FCD3B91
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 05:31:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 556F8300BD99
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 04:31:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEF0E223339;
	Sun, 21 Dec 2025 04:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jAzWuMRd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3800221D599;
	Sun, 21 Dec 2025 04:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766291488; cv=none; b=FBDmjD8HOORGUy+uTnuhhrb0kGtuJ2NW079JbXvneAjD2P1TkJqu8i1k8udDAkGD636yEsHvGdPr4FThe7GJmxCedfRjK+/B1oCU5KaZGLWpwZdX9w+RehStM5KodgUBTh4/bKtItbT0Zj5odgC3/pbSoOtPfCUamaTWLTx9CKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766291488; c=relaxed/simple;
	bh=m4PVmqLInaUcMIDkus+7Y3RqDkU0G1ERKYiwTfpGyD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRX/otyuHP6z9zpYEHRwbivHosjco27SEM+jkk4iy+hRWWGagzbrEH5Ml6gunNbQxg5pu4kAh/Jf7bH38WfFmVeGUe3PB1dVclVDiLg9UTyfZJEPpZU3l9i2iowv8XkFjpUfTQbobkZi7brl4hahx3SbPKS9gh9t95Ull5yARWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jAzWuMRd; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766291486; x=1797827486;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m4PVmqLInaUcMIDkus+7Y3RqDkU0G1ERKYiwTfpGyD4=;
  b=jAzWuMRdbNv8NcAB4OWZqAtq965ZMNy6rBeZA+cBpLX0oOpAO8/y6vKi
   T9TsVWbiGX4EYlzVtyPIKPHX8QVt97bKh6TKYYqAarbqFeCmvLlDkCmil
   ZasCquK6571WHHHXyxc7o2/VS42N4qvWZ+dXhIgwamiAeunV3ihrFt/b9
   7siSvXWedAYWpDhkGE8gd5BtmPC1d5O02mUAzhmcfd3MUMtin2LWU/HXz
   TA2Kc4/HDuuPsiFChrtKnPuvk5S6BZE6UvENyMKWz9MxvSGNbqnRsbWmL
   0iPAbqQ+q32FfeoWZzqekOleUqR2+l+Ca1ZH8kAVILNosbCOQltxNDO8N
   Q==;
X-CSE-ConnectionGUID: DKziS7UUQJC1ACOLzw4HsA==
X-CSE-MsgGUID: 794Cv4UlQxWFjbAKtsjvTQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="68132380"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="68132380"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 20:31:26 -0800
X-CSE-ConnectionGUID: jqYtRxEtTtuDw3ixRAKfvA==
X-CSE-MsgGUID: m843+mkqTq2jV042+Z9yNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="229884953"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 20 Dec 2025 20:31:25 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH 02/16] KVM: x86: Refactor GPR accessors to differentiate register access types
Date: Sun, 21 Dec 2025 04:07:28 +0000
Message-ID: <20251221040742.29749-3-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251221040742.29749-1-chang.seok.bae@intel.com>
References: <20251221040742.29749-1-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the GPR accessors to introduce internal helpers to distinguish
between legacy and extended GPRs. Add CONFIG_KVM_APX to selectively
enable EGPR support.

EGPRs will initially remain unused in the kernel. Thus, the state will
not be saved in KVM register cache on every VM exit. Instead, the guest
state remains live in hardware registers or is stored in guest fpstate.

For now, the EGPR accessors are placeholders to be implemented later.

Link: https://lore.kernel.org/7cff2a78-94f3-4746-9833-c2a1bf51eed6@redhat.com
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
Changes since last version:
* Move kvm_gpr_read_raw() / kvm_gpr_write_raw() into x86.c
  (Paolo: https://lore.kernel.org/33eacd6f-5598-49cb-bb11-ca3a47bfb111@redhat.com)
* Add CONFIG_KVM_APX to compile out R16-R31 handling (Paolo). Massage the
  changelog to note this.
---
 arch/x86/include/asm/kvm_host.h      | 18 ++++++++++++++++
 arch/x86/include/asm/kvm_vcpu_regs.h | 16 ++++++++++++++
 arch/x86/kvm/Kconfig                 |  4 ++++
 arch/x86/kvm/fpu.h                   |  6 ++++++
 arch/x86/kvm/x86.c                   | 32 ++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h                   | 19 +++++++++++++++--
 6 files changed, 93 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5a3bfa293e8b..9dedb8d77222 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -212,6 +212,24 @@ enum {
 	VCPU_SREG_GS,
 	VCPU_SREG_TR,
 	VCPU_SREG_LDTR,
+#ifdef CONFIG_X86_64
+	VCPU_XREG_R16 = __VCPU_XREG_R16,
+	VCPU_XREG_R17 = __VCPU_XREG_R17,
+	VCPU_XREG_R18 = __VCPU_XREG_R18,
+	VCPU_XREG_R19 = __VCPU_XREG_R19,
+	VCPU_XREG_R20 = __VCPU_XREG_R20,
+	VCPU_XREG_R21 = __VCPU_XREG_R21,
+	VCPU_XREG_R22 = __VCPU_XREG_R22,
+	VCPU_XREG_R23 = __VCPU_XREG_R23,
+	VCPU_XREG_R24 = __VCPU_XREG_R24,
+	VCPU_XREG_R25 = __VCPU_XREG_R25,
+	VCPU_XREG_R26 = __VCPU_XREG_R26,
+	VCPU_XREG_R27 = __VCPU_XREG_R27,
+	VCPU_XREG_R28 = __VCPU_XREG_R28,
+	VCPU_XREG_R29 = __VCPU_XREG_R29,
+	VCPU_XREG_R30 = __VCPU_XREG_R30,
+	VCPU_XREG_R31 = __VCPU_XREG_R31,
+#endif
 };
 
 enum exit_fastpath_completion {
diff --git a/arch/x86/include/asm/kvm_vcpu_regs.h b/arch/x86/include/asm/kvm_vcpu_regs.h
index 1af2cb59233b..dd0cc171f405 100644
--- a/arch/x86/include/asm/kvm_vcpu_regs.h
+++ b/arch/x86/include/asm/kvm_vcpu_regs.h
@@ -20,6 +20,22 @@
 #define __VCPU_REGS_R13 13
 #define __VCPU_REGS_R14 14
 #define __VCPU_REGS_R15 15
+#define __VCPU_XREG_R16 16
+#define __VCPU_XREG_R17 17
+#define __VCPU_XREG_R18 18
+#define __VCPU_XREG_R19 19
+#define __VCPU_XREG_R20 20
+#define __VCPU_XREG_R21 21
+#define __VCPU_XREG_R22 22
+#define __VCPU_XREG_R23 23
+#define __VCPU_XREG_R24 24
+#define __VCPU_XREG_R25 25
+#define __VCPU_XREG_R26 26
+#define __VCPU_XREG_R27 27
+#define __VCPU_XREG_R28 28
+#define __VCPU_XREG_R29 29
+#define __VCPU_XREG_R30 30
+#define __VCPU_XREG_R31 31
 #endif
 
 #endif /* _ASM_X86_KVM_VCPU_REGS_H */
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 278f08194ec8..2b2995188e97 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -93,10 +93,14 @@ config KVM_SW_PROTECTED_VM
 
 	  If unsure, say "N".
 
+config KVM_APX
+	bool
+
 config KVM_INTEL
 	tristate "KVM for Intel (and compatible) processors support"
 	depends on KVM && IA32_FEAT_CTL
 	select X86_FRED if X86_64
+	select KVM_APX if X86_64
 	help
 	  Provides support for KVM on processors equipped with Intel's VT
 	  extensions, a.k.a. Virtual Machine Extensions (VMX).
diff --git a/arch/x86/kvm/fpu.h b/arch/x86/kvm/fpu.h
index f898781b6a06..f2613924532d 100644
--- a/arch/x86/kvm/fpu.h
+++ b/arch/x86/kvm/fpu.h
@@ -4,6 +4,7 @@
 #define __KVM_FPU_H_
 
 #include <asm/fpu/api.h>
+#include <asm/kvm_vcpu_regs.h>
 
 typedef u32		__attribute__((vector_size(16))) sse128_t;
 #define __sse128_u	union { sse128_t vec; u64 as_u64[2]; u32 as_u32[4]; }
@@ -203,4 +204,9 @@ static inline void kvm_write_mmx_reg(int reg, const u64 *data)
 	kvm_fpu_put();
 }
 
+#ifdef CONFIG_X86_64
+static inline unsigned long kvm_read_egpr(int reg) { return 0; }
+static inline void kvm_write_egpr(int reg, unsigned long data) { }
+#endif
+
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 23e57170898a..819986edb79c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1255,6 +1255,38 @@ static inline u64 kvm_guest_supported_xfd(struct kvm_vcpu *vcpu)
 }
 #endif
 
+#ifdef CONFIG_KVM_APX
+unsigned long kvm_gpr_read_raw(struct kvm_vcpu *vcpu, int reg)
+{
+	switch (reg) {
+	case VCPU_REGS_RAX ... VCPU_REGS_R15:
+		return kvm_register_read_raw(vcpu, reg);
+	case VCPU_XREG_R16 ... VCPU_XREG_R31:
+		return kvm_read_egpr(reg);
+	default:
+		WARN_ON_ONCE(1);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gpr_read_raw);
+
+void kvm_gpr_write_raw(struct kvm_vcpu *vcpu, int reg, unsigned long val)
+{
+	switch (reg) {
+	case VCPU_REGS_RAX ... VCPU_REGS_R15:
+		kvm_register_write_raw(vcpu, reg, val);
+		break;
+	case VCPU_XREG_R16 ... VCPU_XREG_R31:
+		kvm_write_egpr(reg, val);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+	}
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gpr_write_raw);
+#endif
+
 int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 {
 	u64 xcr0 = xcr;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 7d6c1c31539f..19183aa92855 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -400,9 +400,24 @@ static inline bool vcpu_match_mmio_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
 	return false;
 }
 
+#ifdef CONFIG_KVM_APX
+unsigned long kvm_gpr_read_raw(struct kvm_vcpu *vcpu, int reg);
+void kvm_gpr_write_raw(struct kvm_vcpu *vcpu, int reg, unsigned long val);
+#else
+static inline unsigned long kvm_gpr_read_raw(struct kvm_vcpu *vcpu, int reg)
+{
+	return kvm_register_read_raw(vcpu, reg);
+}
+
+static inline void kvm_gpr_write_raw(struct kvm_vcpu *vcpu, int reg, unsigned long val)
+{
+	kvm_register_write_raw(vcpu, reg, val);
+}
+#endif
+
 static inline unsigned long kvm_gpr_read(struct kvm_vcpu *vcpu, int reg)
 {
-	unsigned long val = kvm_register_read_raw(vcpu, reg);
+	unsigned long val = kvm_gpr_read_raw(vcpu, reg);
 
 	return is_64_bit_mode(vcpu) ? val : (u32)val;
 }
@@ -411,7 +426,7 @@ static inline void kvm_gpr_write(struct kvm_vcpu *vcpu, int reg, unsigned long v
 {
 	if (!is_64_bit_mode(vcpu))
 		val = (u32)val;
-	return kvm_register_write_raw(vcpu, reg, val);
+	kvm_gpr_write_raw(vcpu, reg, val);
 }
 
 static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)
-- 
2.51.0


