Return-Path: <kvm+bounces-67864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 04B3ED15F93
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 01:24:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2D5AC30E631A
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:18:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F56123ED6A;
	Tue, 13 Jan 2026 00:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RxEKoHde"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59FA221721;
	Tue, 13 Jan 2026 00:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768263520; cv=none; b=tpm1HuPuRn1dGWv+Rr6ol0Fr/8DZpy/dc3KsHVbH93MIWGRyKBFg14bz7hsbGrszWQRm+TOprEI5Plf8nQ1h/rxg4FVAkyijOBKHASaHy6OxgJiahuLuO4Z90s9iiv+PylPZfafJECNo10hDKtUT5L2AkXATMVS92y078FANc/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768263520; c=relaxed/simple;
	bh=2UDZSf/uCc4ahoJNM9mnReJM05Zh9eEyzJWh1HAGYF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DJdbf8M6tFrUrzYPfobkCTpV/a+wFZz57INA2urag68zHq8nHaAzymrQZL0dlrTLTdPpuJMAgWRpic6bmrXT1ra7VvUGbrsuu2lNkJUyTc2kTiKxlChiVbs6e4pUXiGPqTdeAZoSL+W4RTQ/X8qiVz/DhnYhYUToybAwwf6xXpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RxEKoHde; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768263518; x=1799799518;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2UDZSf/uCc4ahoJNM9mnReJM05Zh9eEyzJWh1HAGYF0=;
  b=RxEKoHdeeONWs2AfcTq9NmwTjgl79yPV44h8ZNJPI0il05dGrTa1TAsR
   T4+NCKRIWirx6tfWjoCAjatT82RWW6G6QN5kCxznrIQCiytQqF0QtKlPu
   U8am+9GUDRLApXOOIxAh3XpT7lJw+bipVbUjeq1x9onFO/BaLW/TpA7JP
   lh0QnSJ/T1K2Kyl7fOeHt8G6VsMWrSE3FO1QrkVh2J+0TA+JCCk3CgEE2
   k45cJO6Ah4lqdVNJEuj2Y5PtTTOf07wDGeVP5CR5WPMSITb2Qq4RimLNe
   JBcf48zGNtqWINydLRq+uH2XvBlS5JzDfP7rJ6nqtzqm37oj7TwHpwA9q
   g==;
X-CSE-ConnectionGUID: eQs4E9WGQXid7YYJeo5Pqg==
X-CSE-MsgGUID: bFlkYmAZSGutLS+Va9Kavg==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="80264257"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="80264257"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 16:18:38 -0800
X-CSE-ConnectionGUID: 1S0t5tWLSm66hAST5rl/Ow==
X-CSE-MsgGUID: pt4uTyosQJup9MaWqhR+Wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="204042285"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa009.jf.intel.com with ESMTP; 12 Jan 2026 16:18:38 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH v2 11/16] KVM: emulate: Support REX2-prefixed opcode decode
Date: Mon, 12 Jan 2026 23:54:03 +0000
Message-ID: <20260112235408.168200-12-chang.seok.bae@intel.com>
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

Extend the instruction decoder to recognize and handle the REX2 prefix,
including validation of prefix sequences and correct opcode table
selection.

REX2 is a terminal prefix: once 0xD5 is encountered, the following byte
is the opcode. When REX.M=0, most prefix bytes are invalid after REX2,
including REX, VEX, EVEX, and another REX2. Also, REX2-prefixed
instructions are only valid in 64-bit mode.

All of the invalid prefix combinations after REX2 coincide with opcodes
that are architecturally invalid in 64-bit mode. Thus, marking such
opcodes with No64 in opcode_table[] naturally disallows those illegal
prefix sequences.

The 0x40–0x4F opcode row was missing the No64 flag. While NoRex2 already
invalidates REX2 for these opcodes, adding No64 makes opcode attributes
explicit and complete.

Link: https://lore.kernel.org/CABgObfYYGTvkYpeyqLSr9JgKMDA_STSff2hXBNchLZuKFU+MMA@mail.gmail.com
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
 arch/x86/kvm/emulate.c | 38 ++++++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index ef0da1acab5a..1a565a4e3ff7 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4256,7 +4256,7 @@ static const struct opcode opcode_table[256] = {
 	/* 0x38 - 0x3F */
 	I6ALU(NoWrite, em_cmp), N, N,
 	/* 0x40 - 0x4F */
-	X8(I(DstReg | NoRex2, em_inc)), X8(I(DstReg | NoRex2, em_dec)),
+	X8(I(DstReg | NoRex2 | No64, em_inc)), X8(I(DstReg | NoRex2 | No64, em_dec)),
 	/* 0x50 - 0x57 */
 	X8(I(SrcReg | Stack, em_push)),
 	/* 0x58 - 0x5F */
@@ -4850,6 +4850,17 @@ static int x86_decode_avx(struct x86_emulate_ctxt *ctxt,
 	return rc;
 }
 
+static inline bool rex2_invalid(struct x86_emulate_ctxt *ctxt)
+{
+	const struct x86_emulate_ops *ops = ctxt->ops;
+	u64 xcr = 0;
+
+	return ctxt->rex_prefix == REX_PREFIX ||
+	       !(ops->get_cr(ctxt, 4) & X86_CR4_OSXSAVE) ||
+	       ops->get_xcr(ctxt, 0, &xcr) ||
+	       !(xcr & XFEATURE_MASK_APX);
+}
+
 int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int emulation_type)
 {
 	int rc = X86EMUL_CONTINUE;
@@ -4903,7 +4914,7 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 	ctxt->op_bytes = def_op_bytes;
 	ctxt->ad_bytes = def_ad_bytes;
 
-	/* Legacy prefixes. */
+	/* Legacy and REX/REX2 prefixes. */
 	for (;;) {
 		switch (ctxt->b = insn_fetch(u8, ctxt)) {
 		case 0x66:	/* operand-size override */
@@ -4949,6 +4960,17 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 			ctxt->rex_prefix = REX_PREFIX;
 			ctxt->rex_bits   = ctxt->b & 0xf;
 			continue;
+		case 0xd5: /* REX2 */
+			if (mode != X86EMUL_MODE_PROT64)
+				goto done_prefixes;
+			if (rex2_invalid(ctxt)) {
+				opcode = ud;
+				goto done_modrm;
+			}
+			ctxt->rex_prefix = REX2_PREFIX;
+			ctxt->rex_bits   = insn_fetch(u8, ctxt);
+			ctxt->b          = insn_fetch(u8, ctxt);
+			goto done_prefixes;
 		case 0xf0:	/* LOCK */
 			ctxt->lock_prefix = 1;
 			break;
@@ -4971,6 +4993,12 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 	if (ctxt->rex_bits & REX_W)
 		ctxt->op_bytes = 8;
 
+	/* REX2 opcode is one byte unless M-bit selects the two-byte map */
+	if (ctxt->rex_bits & REX_M)
+		goto decode_twobytes;
+	else if (ctxt->rex_prefix == REX2_PREFIX)
+		goto decode_onebyte;
+
 	/* Opcode byte(s). */
 	if (ctxt->b == 0xc4 || ctxt->b == 0xc5) {
 		/* VEX or LDS/LES */
@@ -4988,17 +5016,19 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 			goto done;
 	} else if (ctxt->b == 0x0f) {
 		/* Two- or three-byte opcode */
-		ctxt->opcode_len = 2;
 		ctxt->b = insn_fetch(u8, ctxt);
+decode_twobytes:
+		ctxt->opcode_len = 2;
 		opcode = twobyte_table[ctxt->b];
 
 		/* 0F_38 opcode map */
-		if (ctxt->b == 0x38) {
+		if (ctxt->b == 0x38 && ctxt->rex_prefix != REX2_PREFIX) {
 			ctxt->opcode_len = 3;
 			ctxt->b = insn_fetch(u8, ctxt);
 			opcode = opcode_map_0f_38[ctxt->b];
 		}
 	} else {
+decode_onebyte:
 		/* Opcode byte(s). */
 		opcode = opcode_table[ctxt->b];
 	}
-- 
2.51.0


