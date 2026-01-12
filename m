Return-Path: <kvm+bounces-67856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F6F2D15F51
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 01:19:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C0D9A30754F7
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:18:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D213D222560;
	Tue, 13 Jan 2026 00:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gu5okEnP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A713E42AB7;
	Tue, 13 Jan 2026 00:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768263497; cv=none; b=tE+s61swxb0g5xYGFrE4RbQ+buJ93DxL4OFSrAJI16XVzdr7KB1vBfyRBEeACyVoCe/1+/QKD1d9DpuuefwMSdIekMzXerdSNgf8PFnp8iZyLXaOZfsNcYnBcf2gPCQKpea1jcCCPc9tNqzt3BcnJPX5FkGvLxcwzW86TZMkNks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768263497; c=relaxed/simple;
	bh=UJfTfUgVJma1z/+48v2CwqmAHQqvXi2ak4IRqDvVblU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N4mDG/cfQMd3L5PUSgFFIvkcoSZ8LJJyq15YjfVn5+V3cHEATz2nYG19frmzktdsnma62QXBWy0bpjWR32phgCZn3gV6nzHGeUZzhKHGggLdCuKv7gfM9KUw2pvfRifKco87K1DYEOCv9KWE5cRMhJ9R1ojrl7qa3HL+/6ocSl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gu5okEnP; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768263495; x=1799799495;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UJfTfUgVJma1z/+48v2CwqmAHQqvXi2ak4IRqDvVblU=;
  b=gu5okEnPRg7DFEH2UaaXacPKuZS0F8DIueBlYGetyBVEAwCSs5HoZz2P
   5hfY7kFYM0g7yTHJV2kGpTw21WwsgBqPrS2IQEesBs0EOJXLzPCrLOjje
   KI8m2M3fTiF6MhpxOx+VUCvvP8eID8X46j+7FJFOc3+tz9DTuTa8jHFMC
   PZqt8svffykF0oyxa0mAi/b3ICgMf2TS5kon/vWQA/pRMWyoyUzAZuyoJ
   gUjLpjMIUVKuejfpR3qIB7XQem0WLSwVz4Nhj2vHKc41kcxEw82coiiwA
   q23uYkaOK517l2rUfVa671Su9Vf/bT3MeTZVcZ8bIDcYCk3i4p2128PnZ
   A==;
X-CSE-ConnectionGUID: aFVqBrYtQLuXWnfQDwSQUw==
X-CSE-MsgGUID: JDE5LxDRRqacKAyLNH7tkA==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="80264198"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="80264198"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 16:18:11 -0800
X-CSE-ConnectionGUID: 0IpEs106SkyHWDO0QSdbOQ==
X-CSE-MsgGUID: C8htxSFBTtKjdxvF7ZrtRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="204042204"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa009.jf.intel.com with ESMTP; 12 Jan 2026 16:18:11 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH v2 03/16] KVM: x86: Implement accessors for extended GPRs
Date: Mon, 12 Jan 2026 23:53:55 +0000
Message-ID: <20260112235408.168200-4-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112235408.168200-1-chang.seok.bae@intel.com>
References: <20260112235408.168200-1-chang.seok.bae@intel.com>
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
V1 -> V2: Move _kvm_read_egpr()/_kvm_write_egpr() to x86.c (Paolo)
---
 arch/x86/kvm/x86.c | 70 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 69 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9857b4d319ed..edac2ec11e2f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1256,13 +1256,81 @@ static inline u64 kvm_guest_supported_xfd(struct kvm_vcpu *vcpu)
 #endif
 
 #ifdef CONFIG_KVM_APX
+/*
+ * Accessors for extended general-purpose registers. binutils >= 2.43 can
+ * recognize those register symbols.
+ */
+
+static void _kvm_read_egpr(int reg, unsigned long *data)
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
+static void _kvm_write_egpr(int reg, unsigned long *data)
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
+
 static unsigned long kvm_read_egpr(int reg)
 {
-	return 0;
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
 }
 
 static void kvm_write_egpr(int reg, unsigned long data)
 {
+	if (WARN_ON_ONCE(!cpu_has_xfeatures(XFEATURE_MASK_APX, NULL)))
+		return;
+
+	kvm_fpu_get();
+	_kvm_write_egpr(reg, &data);
+	kvm_fpu_put();
 }
 
 unsigned long kvm_gpr_read_raw(struct kvm_vcpu *vcpu, int reg)
-- 
2.51.0


