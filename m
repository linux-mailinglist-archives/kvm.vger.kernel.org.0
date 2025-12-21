Return-Path: <kvm+bounces-66445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E1627CD3BA6
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 05:33:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 309DC302EA3C
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 04:31:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EF16224B12;
	Sun, 21 Dec 2025 04:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y00Is0v4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D961DF723;
	Sun, 21 Dec 2025 04:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766291490; cv=none; b=H5v5WZFSdhBr+gCjN41NRm4k5U1JO6FCf4bubZy0wH3ko7xBawDG2/TCB+Uibwm1mZkqe1z5CTTqc/XqSxH6s4jletdbW/HEDf+WBDHrg6txK5RseB7gisK0reWV0CBW+WOvolfiy614Gk34pQpNBiW811AfcDvKbCqXHKiP7l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766291490; c=relaxed/simple;
	bh=8Qad+bux2mre6hURNDQPJKoXDr2wv4wMXXklm9GNArY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ibBwHrgohn3KSaOrhaLU44zAXnuaT7e2H2pfJ07OGcRrJ7hiyM2G0MBrUqF6BfY1HcDKNoFtnzYmAD8RyjZDy7NuSMnta6eSndxaAMC90GKqJlMV6d0YUJuKcYHvj76X9xkRgcGH0OFIWsDVddT6ZbSahh9+6k0B0+CP3+w5cIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y00Is0v4; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766291488; x=1797827488;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8Qad+bux2mre6hURNDQPJKoXDr2wv4wMXXklm9GNArY=;
  b=Y00Is0v4R78qqaseLrf/zHvxj/BvSbnV7cVn6W3ByoovDPpCdZ/upd1z
   S3P7KAtTcjCHUqB3qjJKwCdg7varxNPjdKFgrfz4XWRUvM7WeoVnOE9sr
   gBM0ew7Y8fcef4Y5QjdXJo4hKuF3/8uv4UW2vJQAOlv0q9Kvfw/ylkYij
   tSKCtgQ75QT0nkVj1JeYCMJAFuuJjAL1JlPNtRlvXpQmta0pHRw7Ek/+f
   4/l9q9Kup92yT/sJhOfi66ftfHNJiWHFEqeZ5WA952fOgBzLWmKwt7S6V
   8Ml6D4PAE7EiWdX/YQk5O3RKyNG130QDtuazkIjZoeyLAUSMe7D6OStV6
   Q==;
X-CSE-ConnectionGUID: 0pHVH37PReeBZnMvwBkKqg==
X-CSE-MsgGUID: TxtP/8FBRMmB6SzOKhwTvw==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="68132383"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="68132383"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 20:31:27 -0800
X-CSE-ConnectionGUID: 7XkRDpg/TX2rkdQrgrm5Sw==
X-CSE-MsgGUID: HD/NjcCWRf+l778PbmNG0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="229884959"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 20 Dec 2025 20:31:27 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH 03/16] KVM: x86: Implement accessors for extended GPRs
Date: Sun, 21 Dec 2025 04:07:29 +0000
Message-ID: <20251221040742.29749-4-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251221040742.29749-1-chang.seok.bae@intel.com>
References: <20251221040742.29749-1-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add helpers to directly read and write EGPRs (R16–R31).

Unlike legacy GPRs, EGPRs are not cached in vcpu->arch.regs[]. Their
contents remain live in hardware. If preempted, the EGPR state is
preserved in the guest XSAVE buffer.

The Advanced Performance Extensions (APX) feature introduces EGPRs as an
XSAVE-managed state component. The new helpers access the registers
directly between kvm_fpu_get() and kvm_fpu_put().

Callers should ensure that EGPRs are enabled before using these helpers.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
No change since last version
---
 arch/x86/kvm/fpu.h | 80 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 78 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/fpu.h b/arch/x86/kvm/fpu.h
index f2613924532d..f132cad4b49e 100644
--- a/arch/x86/kvm/fpu.h
+++ b/arch/x86/kvm/fpu.h
@@ -148,6 +148,61 @@ static inline void _kvm_write_mmx_reg(int reg, const u64 *data)
 	}
 }
 
+#ifdef CONFIG_X86_64
+/*
+ * Accessors for extended general-purpose registers. binutils >= 2.43 can
+ * recognize those register symbols.
+ */
+
+static inline void _kvm_read_egpr(int reg, unsigned long *data)
+{
+	/* mov %r16..%r31, %rax */
+	switch (reg) {
+	case __VCPU_XREG_R16: asm(".byte 0xd5, 0x48, 0x89, 0xc0" : "=a"(*data)); break;
+	case __VCPU_XREG_R17: asm(".byte 0xd5, 0x48, 0x89, 0xc8" : "=a"(*data)); break;
+	case __VCPU_XREG_R18: asm(".byte 0xd5, 0x48, 0x89, 0xd0" : "=a"(*data)); break;
+	case __VCPU_XREG_R19: asm(".byte 0xd5, 0x48, 0x89, 0xd8" : "=a"(*data)); break;
+	case __VCPU_XREG_R20: asm(".byte 0xd5, 0x48, 0x89, 0xe0" : "=a"(*data)); break;
+	case __VCPU_XREG_R21: asm(".byte 0xd5, 0x48, 0x89, 0xe8" : "=a"(*data)); break;
+	case __VCPU_XREG_R22: asm(".byte 0xd5, 0x48, 0x89, 0xf0" : "=a"(*data)); break;
+	case __VCPU_XREG_R23: asm(".byte 0xd5, 0x48, 0x89, 0xf8" : "=a"(*data)); break;
+	case __VCPU_XREG_R24: asm(".byte 0xd5, 0x4c, 0x89, 0xc0" : "=a"(*data)); break;
+	case __VCPU_XREG_R25: asm(".byte 0xd5, 0x4c, 0x89, 0xc8" : "=a"(*data)); break;
+	case __VCPU_XREG_R26: asm(".byte 0xd5, 0x4c, 0x89, 0xd0" : "=a"(*data)); break;
+	case __VCPU_XREG_R27: asm(".byte 0xd5, 0x4c, 0x89, 0xd8" : "=a"(*data)); break;
+	case __VCPU_XREG_R28: asm(".byte 0xd5, 0x4c, 0x89, 0xe0" : "=a"(*data)); break;
+	case __VCPU_XREG_R29: asm(".byte 0xd5, 0x4c, 0x89, 0xe8" : "=a"(*data)); break;
+	case __VCPU_XREG_R30: asm(".byte 0xd5, 0x4c, 0x89, 0xf0" : "=a"(*data)); break;
+	case __VCPU_XREG_R31: asm(".byte 0xd5, 0x4c, 0x89, 0xf8" : "=a"(*data)); break;
+	default: BUG();
+	}
+}
+
+static inline void _kvm_write_egpr(int reg, unsigned long *data)
+{
+	/* mov %rax, %r16...%r31*/
+	switch (reg) {
+	case __VCPU_XREG_R16: asm(".byte 0xd5, 0x18, 0x89, 0xc0" : : "a"(*data)); break;
+	case __VCPU_XREG_R17: asm(".byte 0xd5, 0x18, 0x89, 0xc1" : : "a"(*data)); break;
+	case __VCPU_XREG_R18: asm(".byte 0xd5, 0x18, 0x89, 0xc2" : : "a"(*data)); break;
+	case __VCPU_XREG_R19: asm(".byte 0xd5, 0x18, 0x89, 0xc3" : : "a"(*data)); break;
+	case __VCPU_XREG_R20: asm(".byte 0xd5, 0x18, 0x89, 0xc4" : : "a"(*data)); break;
+	case __VCPU_XREG_R21: asm(".byte 0xd5, 0x18, 0x89, 0xc5" : : "a"(*data)); break;
+	case __VCPU_XREG_R22: asm(".byte 0xd5, 0x18, 0x89, 0xc6" : : "a"(*data)); break;
+	case __VCPU_XREG_R23: asm(".byte 0xd5, 0x18, 0x89, 0xc7" : : "a"(*data)); break;
+	case __VCPU_XREG_R24: asm(".byte 0xd5, 0x19, 0x89, 0xc0" : : "a"(*data)); break;
+	case __VCPU_XREG_R25: asm(".byte 0xd5, 0x19, 0x89, 0xc1" : : "a"(*data)); break;
+	case __VCPU_XREG_R26: asm(".byte 0xd5, 0x19, 0x89, 0xc2" : : "a"(*data)); break;
+	case __VCPU_XREG_R27: asm(".byte 0xd5, 0x19, 0x89, 0xc3" : : "a"(*data)); break;
+	case __VCPU_XREG_R28: asm(".byte 0xd5, 0x19, 0x89, 0xc4" : : "a"(*data)); break;
+	case __VCPU_XREG_R29: asm(".byte 0xd5, 0x19, 0x89, 0xc5" : : "a"(*data)); break;
+	case __VCPU_XREG_R30: asm(".byte 0xd5, 0x19, 0x89, 0xc6" : : "a"(*data)); break;
+	case __VCPU_XREG_R31: asm(".byte 0xd5, 0x19, 0x89, 0xc7" : : "a"(*data)); break;
+	default: BUG();
+	}
+}
+#endif
+
 static inline void kvm_fpu_get(void)
 {
 	fpregs_lock();
@@ -205,8 +260,29 @@ static inline void kvm_write_mmx_reg(int reg, const u64 *data)
 }
 
 #ifdef CONFIG_X86_64
-static inline unsigned long kvm_read_egpr(int reg) { return 0; }
-static inline void kvm_write_egpr(int reg, unsigned long data) { }
+static inline unsigned long kvm_read_egpr(int reg)
+{
+	unsigned long data;
+
+	if (WARN_ON_ONCE(!cpu_has_xfeatures(XFEATURE_MASK_APX, NULL)))
+		return 0;
+
+	kvm_fpu_get();
+	_kvm_read_egpr(reg, &data);
+	kvm_fpu_put();
+
+	return data;
+}
+
+static inline void kvm_write_egpr(int reg, unsigned long data)
+{
+	if (WARN_ON_ONCE(!cpu_has_xfeatures(XFEATURE_MASK_APX, NULL)))
+		return;
+
+	kvm_fpu_get();
+	_kvm_write_egpr(reg, &data);
+	kvm_fpu_put();
+}
 #endif
 
 #endif
-- 
2.51.0


