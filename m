Return-Path: <kvm+bounces-67855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 40747D15F3F
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 01:18:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D469E3032A81
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:18:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63F6A226CF6;
	Tue, 13 Jan 2026 00:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hYg1GVvp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3471E21CC5C;
	Tue, 13 Jan 2026 00:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768263488; cv=none; b=Dm0kFJy0IdOwYpflltAEKD6nH4ovSxZJyEgsEAuBxBg49hpc6XKekM034DShvZgsZOsKuw63yMCfuaVW5+3WKjO332LOg0KniQHvXJS5ZYJ2+HruOuGxX93c2aXKL+fuAPuAR7L2lSNo4iuXhjGg/yl19pJ3SmNIWvjJjcUDwBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768263488; c=relaxed/simple;
	bh=jfswYib18G9iqzbp5TNF0aK44KVYdgLvSKUmm08NH7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ryiYPKtWpkjAUY0IyvImq83ZDDSDH9m4CB+pQLM2SLtjJyDzMqQJRbQkQJCmyq8nDhEivYoBYuoL2LSyWepGWnffyQNROg9NNeOAd/ss7QQVUQN7vgGIv+Q3QFH8mTan/DGSszZg3mTv9XwAuVbtHp1shM+BFyU7JN2WFAh6pFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hYg1GVvp; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768263487; x=1799799487;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jfswYib18G9iqzbp5TNF0aK44KVYdgLvSKUmm08NH7I=;
  b=hYg1GVvponVq8Gx20OZYkEVKTLPPe9GUuUo8nImXcjqslpM1mrms9Fkg
   MzcL7Yz4scJ8BlP8pF5Vg/CanKajxeUToPmcDQ28mWhL1RJPf+wHpZtZ3
   wDd+fTKuYmzJdjY78LvnXEL/4P/nKVp2cfVsb+veYVVprMyRZxVfVwUTb
   yXNNdCBiOsK8mqG7ZRPY2cmiSyn0nlL5qpW4OJtl7Lit1bv89hv2+GUB/
   XZUTDIO+m7sm34wFIo/0XC37LPSHnKcRQnzOVAPPeoRZfTrKBSpfAxOcE
   8EW2/uNLNeD7bQi9F8HDG0JnMxmbJaMJU+ZDDifw3xiHZ+u+kAASRkT9p
   A==;
X-CSE-ConnectionGUID: 1jEZ6YD1To2SJ8NUVyRbWQ==
X-CSE-MsgGUID: eRochI2eSmS4+HZokHX8Dw==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="80264187"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="80264187"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 16:18:06 -0800
X-CSE-ConnectionGUID: tBImvm6ITSyK3y5PIC4DHA==
X-CSE-MsgGUID: QB2kGqNTRZG+ngolEkTY8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="204042177"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa009.jf.intel.com with ESMTP; 12 Jan 2026 16:18:07 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH v2 02/16] KVM: x86: Refactor GPR accessors to differentiate register access types
Date: Mon, 12 Jan 2026 23:53:54 +0000
Message-ID: <20260112235408.168200-3-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112235408.168200-1-chang.seok.bae@intel.com>
References: <20260112235408.168200-1-chang.seok.bae@intel.com>
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
V1 -> V2: Move kvm_read_egpr()/kvm_write_egpr() to x86.c (Paolo)
---
 arch/x86/include/asm/kvm_host.h      | 18 ++++++++++++
 arch/x86/include/asm/kvm_vcpu_regs.h | 16 +++++++++++
 arch/x86/kvm/Kconfig                 |  4 +++
 arch/x86/kvm/x86.c                   | 41 ++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h                   | 19 +++++++++++--
 5 files changed, 96 insertions(+), 2 deletions(-)

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
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3256ad507265..9857b4d319ed 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1255,6 +1255,47 @@ static inline u64 kvm_guest_supported_xfd(struct kvm_vcpu *vcpu)
 }
 #endif
 
+#ifdef CONFIG_KVM_APX
+static unsigned long kvm_read_egpr(int reg)
+{
+	return 0;
+}
+
+static void kvm_write_egpr(int reg, unsigned long data)
+{
+}
+
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


