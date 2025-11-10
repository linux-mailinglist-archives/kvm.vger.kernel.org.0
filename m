Return-Path: <kvm+bounces-62565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 514AEC488F2
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 19:30:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4BE9734A4CB
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:29:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C2DA336EF8;
	Mon, 10 Nov 2025 18:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DPb9rnW1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC143358C1;
	Mon, 10 Nov 2025 18:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762799102; cv=none; b=DtnV6EQuxRVJte1wNJpjbEjHvBiTPqRFmIhg7jUyCTu9RHqFmKvLcKQuKWAR2auDNS3dqZ1YyQUMnsV+cA954PwxDC2iCc9hKLxoaj3UDz+JlMy1uQFA0beM/2fmVgA9AGQEV4CeWoSgGzMnj3BAsjev/QIB6uRPSuraRKCZI8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762799102; c=relaxed/simple;
	bh=OKF1FVbUobLfexLIDLKx2QfWN1Gg7JvJuzC6gMCI7cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AMW3Cb1waiM88KdONYbgTTWCw3V0VACu2Bjb/GKo75vZzfW/ByHduav4xf8OKdMG0Cy/KfdRqYupp30L6+ca9o1TbLfuEevmgsAh2r3/x0UH8fre1ypyAZAY1dfF2FJJ1Gm2m1ObuAdIUIMiN8+J50NZaBavWV465+Rc5U0q6PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DPb9rnW1; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762799101; x=1794335101;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OKF1FVbUobLfexLIDLKx2QfWN1Gg7JvJuzC6gMCI7cc=;
  b=DPb9rnW1d4wyoPR8HZ1IoUf7lxz4Z1/n+RGvHB7gMNTV/+tgCjbPBxkv
   miPaJQCDllrR8vAk9rwq/k/42pcgCIThOhEUAvRJS14dRZPdVNc+l2DE6
   SkPvjlBw4ysSQBPRVq+85/pnWHbiuTIXZnE916pgfJGASTa+KvIuqsp69
   QPMmPcihH7jIqo9xmu7dQlPJhZhIU4ueN//bdtidCE7yzQcy9F9bjFdJM
   1VJmnelNH6V/FK1aRgz/vRfcqWzsdQbvILoSPrATtyk3JW1E/kgfKfRm6
   n9OCwHp4STqOzI8p+o3o39IcRT6ayUHZRpuvZXGUl/DzB0/lLh80Dpnyz
   Q==;
X-CSE-ConnectionGUID: rNXvZYh/T/msRTpuFBABPA==
X-CSE-MsgGUID: ArYNEKU1S9yjRfl5qo84hQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="76305517"
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="76305517"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 10:25:01 -0800
X-CSE-ConnectionGUID: K2yW8NtuRD6FifplzeX6Fg==
X-CSE-MsgGUID: DjKKLPLpT66baPklZroZBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="219396191"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 10 Nov 2025 10:25:01 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	chao.gao@intel.com,
	zhao1.liu@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH RFC v1 14/20] KVM: x86: Emulate REX2-prefixed 64-bit absolute jump
Date: Mon, 10 Nov 2025 18:01:25 +0000
Message-ID: <20251110180131.28264-15-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251110180131.28264-1-chang.seok.bae@intel.com>
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for the new absolute jump, previously unimplemented.

This instruction has an unusual quirk: the REX2.W bit uses inverted
polarity. Unlike normal REX or REX2 semantics (where W=1 indicates a
64-bit operand size), this instruction uses W=0 to select an 8-byte
operand size.

The new InvertedWidthPolarity flag and its helper to interpret the
W bit correctly, avoiding special-case hacks in the emulator logic.

Since the ctxt->op_bytes depends on the instruction flags, the size
should be determined after the instruction lookup.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
 arch/x86/kvm/emulate.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 58879a31abcd..03f8e007b14e 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -179,6 +179,7 @@
 #define TwoMemOp    ((u64)1 << 55)  /* Instruction has two memory operand */
 #define IsBranch    ((u64)1 << 56)  /* Instruction is considered a branch. */
 #define ShadowStack ((u64)1 << 57)  /* Instruction affects Shadow Stacks. */
+#define InvertedWidthPolarity ((u64)1 << 58) /* Instruction uses inverted REX2.W polarity */
 
 #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)
 
@@ -993,6 +994,16 @@ EM_ASM_2W(btc);
 
 EM_ASM_2R(cmp, cmp_r);
 
+static inline bool is_64bit_operand_size(struct x86_emulate_ctxt *ctxt)
+{
+	/*
+	 * Most instructions interpret REX.W=1 as 64-bit operand size.
+	 * Some REX2 opcodes invert this logic.
+	 */
+	return ctxt->d & InvertedWidthPolarity ?
+	       ctxt->rex.bits.w == 0 : ctxt->rex.bits.w == 1;
+}
+
 static int em_bsf_c(struct x86_emulate_ctxt *ctxt)
 {
 	/* If src is zero, do not writeback, but update flags */
@@ -2472,7 +2483,7 @@ static int em_sysexit(struct x86_emulate_ctxt *ctxt)
 
 	setup_syscalls_segments(&cs, &ss);
 
-	if (ctxt->rex.bits.w)
+	if (is_64bit_operand_size(ctxt))
 		usermode = X86EMUL_MODE_PROT64;
 	else
 		usermode = X86EMUL_MODE_PROT32;
@@ -4486,7 +4497,8 @@ static struct opcode rex2_opcode_table[256]  __ro_after_init;
 static struct opcode rex2_twobyte_table[256] __ro_after_init;
 
 static const struct opcode undefined = D(Undefined);
-static const struct opcode notimpl   = N;
+static const struct opcode pfx_d5_a1 = I(SrcImm64 | NearBranch | IsBranch | InvertedWidthPolarity, \
+					 em_jmp_abs);
 
 #undef D
 #undef N
@@ -4543,6 +4555,7 @@ static bool is_ibt_instruction(struct x86_emulate_ctxt *ctxt)
 		return true;
 	case SrcNone:
 	case SrcImm:
+	case SrcImm64:
 	case SrcImmByte:
 	/*
 	 * Note, ImmU16 is used only for the stack adjustment operand on ENTER
@@ -4895,9 +4908,6 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 
 done_prefixes:
 
-	if (ctxt->rex.bits.w)
-		ctxt->op_bytes = 8;
-
 	/* Determine opcode byte(s): */
 	if (ctxt->rex_prefix == REX2_INVALID) {
 		/*
@@ -4936,6 +4946,9 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 	}
 	ctxt->d = opcode.flags;
 
+	if (is_64bit_operand_size(ctxt))
+		ctxt->op_bytes = 8;
+
 	if (ctxt->d & ModRM)
 		ctxt->modrm = insn_fetch(u8, ctxt);
 
@@ -5594,6 +5607,6 @@ void __init kvm_init_rex2_opcode_table(void)
 	undefine_row(&rex2_twobyte_table[0x30]);
 	undefine_row(&rex2_twobyte_table[0x80]);
 
-	/* Mark opcode not yet implemented: */
-	rex2_opcode_table[0xa1] = notimpl;
+	/* Define the REX2-specific absolute jump (0xA1) opcode */
+	rex2_opcode_table[0xa1] = pfx_d5_a1;
 }
-- 
2.51.0


