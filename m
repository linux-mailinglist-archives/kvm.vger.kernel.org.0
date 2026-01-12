Return-Path: <kvm+bounces-67862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A1312D15F48
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 01:19:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 92B97300FD55
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:18:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8344D22B8BD;
	Tue, 13 Jan 2026 00:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Cn0AIoKN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2158142AB7;
	Tue, 13 Jan 2026 00:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768263519; cv=none; b=I1HA70JdAJ5NABVdM0pdvhf+8+gQXW6B+62jFJl1Elgjx4KgTGGwscOxQakQWAbCI6AcJDLiiRfHrfWYhBWH/CvUHm9XxRLmuUArFYCQHtJx6deCiyrlWDwITyGchB/eB3R8SII9vB3+l6JonOyepFuJ2Wk8OL51s+pKhOK2KNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768263519; c=relaxed/simple;
	bh=j9NteoQM1X9ErYC0oA1l11qc0KR8u2v6ZijCHhf7BHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G0jeXtKJ4BNSWHLzHln4ND6eWVj1Txwt3gYhnQeYCpGZl+dPLh3Bk2ACr8OwTao+98P+s5B5nRiMX0NIAk/bUCOO4+QYvSmgOjpkz4QhnHwkzLHxqbmWIJnihynB3HIxH0cG3AL5xIRlWmkT0UmWZ91/eYifaDphWNlE8YpfjuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Cn0AIoKN; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768263515; x=1799799515;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j9NteoQM1X9ErYC0oA1l11qc0KR8u2v6ZijCHhf7BHU=;
  b=Cn0AIoKNDrGSoj9cPlweuMQ3RdoMt7nenP6V13DBIfOJysswqW12zkuv
   98GdALFkQHq2o1Iwq0H/wjKfO/+NT7/MypNuFIsol2MkVnc7OmL5PcIBA
   sbENeV2e3ItfMDTL0s+d88e1zPACNiT1PlA4RFCEzjZ5NvuWyIXntL+oh
   2qvK6KAGsnb8+1L7TuRA/Rn99gFYk1m4TQEBpyJimMMNplKmsn0z8+anq
   lUr1kM2ePmrVIt+bnSt76pj7TFEIqDjHyWYR4AFVIL1kX3rKYGhBmWGKD
   5jFEzV9e+BlfqePTOldyKp+tDFBEVLuRX3pIXRDyZCQsBBhN4AgeF+Tg+
   w==;
X-CSE-ConnectionGUID: ks5c+8diTba9NtzOus3U/Q==
X-CSE-MsgGUID: LatQ91qtQgayUQpoGQgx6w==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="80264244"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="80264244"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 16:18:32 -0800
X-CSE-ConnectionGUID: COJBFgOUS8OA4hOHTGTLww==
X-CSE-MsgGUID: A4hHAnAHS+Sav8Id8VnPtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="204042267"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa009.jf.intel.com with ESMTP; 12 Jan 2026 16:18:33 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH v2 09/16] KVM: emulate: Support EGPR accessing and tracking
Date: Mon, 12 Jan 2026 23:54:01 +0000
Message-ID: <20260112235408.168200-10-chang.seok.bae@intel.com>
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

Extend the emulator context and GPR accessors to handle EGPRs before
adding support for REX2-prefixed instructions.

Now the KVM GPR accessors can handle EGPRs. Then, the emulator can
uniformly cache and track all GPRs without requiring separate handling.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
 arch/x86/kvm/kvm_emulate.h | 10 +++++-----
 arch/x86/kvm/x86.c         |  4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index fb3dab4b5a53..16b35a796a7f 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -105,13 +105,13 @@ struct x86_instruction_info {
 struct x86_emulate_ops {
 	void (*vm_bugged)(struct x86_emulate_ctxt *ctxt);
 	/*
-	 * read_gpr: read a general purpose register (rax - r15)
+	 * read_gpr: read a general purpose register (rax - r31)
 	 *
 	 * @reg: gpr number.
 	 */
 	ulong (*read_gpr)(struct x86_emulate_ctxt *ctxt, unsigned reg);
 	/*
-	 * write_gpr: write a general purpose register (rax - r15)
+	 * write_gpr: write a general purpose register (rax - r31)
 	 *
 	 * @reg: gpr number.
 	 * @val: value to write.
@@ -314,7 +314,7 @@ typedef void (*fastop_t)(struct fastop *);
  * a ModRM or SIB byte.
  */
 #ifdef CONFIG_X86_64
-#define NR_EMULATOR_GPRS	16
+#define NR_EMULATOR_GPRS	32
 #else
 #define NR_EMULATOR_GPRS	8
 #endif
@@ -373,9 +373,9 @@ struct x86_emulate_ctxt {
 	u8 lock_prefix;
 	u8 rep_prefix;
 	/* bitmaps of registers in _regs[] that can be read */
-	u16 regs_valid;
+	u32 regs_valid;
 	/* bitmaps of registers in _regs[] that have been written */
-	u16 regs_dirty;
+	u32 regs_dirty;
 	/* modrm */
 	u8 modrm;
 	u8 modrm_mod;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index edac2ec11e2f..e7f858488f2c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8894,12 +8894,12 @@ static bool emulator_guest_cpuid_is_intel_compatible(struct x86_emulate_ctxt *ct
 
 static ulong emulator_read_gpr(struct x86_emulate_ctxt *ctxt, unsigned reg)
 {
-	return kvm_register_read_raw(emul_to_vcpu(ctxt), reg);
+	return kvm_gpr_read_raw(emul_to_vcpu(ctxt), reg);
 }
 
 static void emulator_write_gpr(struct x86_emulate_ctxt *ctxt, unsigned reg, ulong val)
 {
-	kvm_register_write_raw(emul_to_vcpu(ctxt), reg, val);
+	kvm_gpr_write_raw(emul_to_vcpu(ctxt), reg, val);
 }
 
 static void emulator_set_nmi_mask(struct x86_emulate_ctxt *ctxt, bool masked)
-- 
2.51.0


