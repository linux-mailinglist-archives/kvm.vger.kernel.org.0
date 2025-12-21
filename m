Return-Path: <kvm+bounces-66453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FA3BCD3BD0
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 05:38:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7D67630169B3
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 04:33:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62812239E75;
	Sun, 21 Dec 2025 04:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dv3rHMz/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C60224B12;
	Sun, 21 Dec 2025 04:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766291510; cv=none; b=X8mCLZe5gJGcEREyxFkaAENl0VIK78zuSMsCPKtJvmjUYnlivroN27URy2IEreBA4Ip4ScqlPDeWupLjVTiqNXgDNI/4ZlXU8f0cbkN+xPJHzgozh+kcARMxeaKP3U8kK8KWjI0bdCp0FJNK9WhfzTq/ln1ixHH1Nmx+Bvz0DtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766291510; c=relaxed/simple;
	bh=Tp2WE60FQZau2ypCW1hE/j91K5p9W1IYSRQjvongfI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ajfI5qXTpTgKyePRDJGqzA+ksPe4nzZGFxUkpV/Koo9EzGH3UkUXDBTjx5hvYRHvnf//Jz/u+zRV8x3DZ6mUUmJgxBc9IvfTq9bqktr6QO7e58ieYAAfaXCXVCGssRWHlNaAhEro8VyaG8hV+apkGWmHPN4LITj1hFhnVJElGcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dv3rHMz/; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766291508; x=1797827508;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Tp2WE60FQZau2ypCW1hE/j91K5p9W1IYSRQjvongfI4=;
  b=dv3rHMz/6mJzVrrmRkjjD1IMuYCRGJ5S4opR0JJNOcmnc4OtbuzJKqae
   nce5TJ3QQmsZ5prp+N1dU+8N/+P2zIWN31FRGwPcejl7Y9OZQXawpJnMA
   rGnEVz6fKx9rdQVu6PAyKDKHmvy9LlK2zCe7d3JDwx46DZxje7md6JoIk
   kjXjqvSkVrN10+9s8OdPZbygiyUIn31Yl4+UBSExbDVoQBNCHaOW/9JvV
   EeDNw9csYHhkRSKGU1Eh/2o6jhSg8/TKcFeScTtUURHo2SJ89HdSOJLyY
   dQLCbnA2WgbyhMk2uxyxWpCC5Fr6hxZDp8fxcxCSVN6yXofBlJxiwl4wY
   w==;
X-CSE-ConnectionGUID: vuhkc8ZSS/W82wab5iFgnA==
X-CSE-MsgGUID: CpuBo3+lQxSF4JJ1zFBMpA==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="68132424"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="68132424"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 20:31:47 -0800
X-CSE-ConnectionGUID: xMDg+UPlTRyfJEeaJ9lUUA==
X-CSE-MsgGUID: gYJ4j9ZYR9+3qd6eFbDm+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="229885030"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 20 Dec 2025 20:31:47 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH 11/16] KVM: emulate: Support REX2-prefixed opcode decode
Date: Sun, 21 Dec 2025 04:07:37 +0000
Message-ID: <20251221040742.29749-12-chang.seok.bae@intel.com>
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

The 0x40–0x4F opcode row was missing the No64 flag. While NoRex already
invalidates REX2 for these opcodes, adding No64 makes opcode attributes
explicit and complete.

Link: https://lore.kernel.org/CABgObfYYGTvkYpeyqLSr9JgKMDA_STSff2hXBNchLZuKFU+MMA@mail.gmail.com
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
Changes since last version:
* Simplify REX2 validation logic (Paolo).
* Add direct jumps to the relevant decode paths to reduce control flow
  complexity (Paolo).
* Rewrite and clarify the changelog.
---
 arch/x86/kvm/emulate.c | 38 ++++++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 242e043634b9..fc065ef53400 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4256,7 +4256,7 @@ static const struct opcode opcode_table[256] = {
 	/* 0x38 - 0x3F */
 	I6ALU(NoWrite, em_cmp), N, N,
 	/* 0x40 - 0x4F */
-	X8(I(DstReg | NoRex, em_inc)), X8(I(DstReg | NoRex, em_dec)),
+	X8(I(DstReg | NoRex | No64, em_inc)), X8(I(DstReg | NoRex | No64, em_dec)),
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


