Return-Path: <kvm+bounces-62564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CD43EC48910
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 19:31:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 877DE1893572
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:29:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85D46335BC1;
	Mon, 10 Nov 2025 18:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Iqb1AOMr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07877335561;
	Mon, 10 Nov 2025 18:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762799100; cv=none; b=Y577w9hNO9niBMtyfzSPkZqOGfTn5nHXcmAQ13K3hGXcK9URpmu+0wTPfyqGirw7y/Ve5D+Z6j8lF3o4Q7n53HzLgjpN8ALMWNiJWq5CPxUazrmuOZIEFLJod5NFzo61jM9FHyiqviBhaSJ3FBjd/+wj5NtKrBiwo0BhaqDkAOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762799100; c=relaxed/simple;
	bh=EzMDv1UxMuKuzGlYtOJ78agTEmG6+hpaQI8j2t+mVT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SM45IdIoXkCEgzx3thM0grKZiLXb0FBVrnFLVdUDX2OP9yvN9v6v7lXcjnCiHC7Hv0waxl77FtqaBxBzB6RZBCXfZMnaZ+EUipq+QYNxldcCW8BpcXIFdND7Ya0oCcLV0Q4WVnWyZ4GfIKxdYHbr1E4/vmq0Y2MHMtmQ4nhTuPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Iqb1AOMr; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762799099; x=1794335099;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EzMDv1UxMuKuzGlYtOJ78agTEmG6+hpaQI8j2t+mVT0=;
  b=Iqb1AOMrv7nuadeUfzvcsxa00ywDILa6r1Hc9UyzWqG+V1JvWuGU2EV0
   E8Gu+SL8uz9tZ6zu7zOg2a71XSnFZP9l+OoJmhdj202stSJSkItF3RuVI
   t8xXYHCcrd1TQzu9K5DGn8RIwi8ZjJCnM01mvF213i13bfMklr3YT8Aqb
   /FJv2LfutWhR8phe+qEOBjO3r81nKVbvk28RRyuKOKAhTiyDOTk5j5+zh
   nvcuUeligLVvvnPcg+xUkFTJg2iZS8rw57D8NK2Mnoctt4bMXLUIGFCW7
   tg5BKji/XnQq6SlL/9r6lYeL0NVDP05N7EQG5mABZ8zbK7GbwXgbT5X5d
   A==;
X-CSE-ConnectionGUID: WImzNt/bTLyfgWYEB+MmqQ==
X-CSE-MsgGUID: oomtmbWhRX+ICnbkswCQ3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="76305514"
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="76305514"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 10:24:59 -0800
X-CSE-ConnectionGUID: e8mBaDGqR32p+KuNOIYqVg==
X-CSE-MsgGUID: 2//SVxCvTUSxlESXbQDVLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="219396179"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 10 Nov 2025 10:24:59 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	chao.gao@intel.com,
	zhao1.liu@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH RFC v1 13/20] KVM: x86: Add REX2 opcode tables to the instruction decoder
Date: Mon, 10 Nov 2025 18:01:24 +0000
Message-ID: <20251110180131.28264-14-chang.seok.bae@intel.com>
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

Extend the decoder to find REX2-prefixed opcodes by introducing dedicated
REX2 opcode tables. During initialization, clone the legacy opcode tables
and patch entries that differ under REX2.

Although most REX2-prefixed opcodes follow the legacy tables, some differ
for instructions that do not reference extended register bits or are
newly introduced under REX2. Using separate tables simplifies the
lookup logic and allows efficient patching of exceptions.

The EGPR checker will be implemented later.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
RFC note:
The lookup logic could be separated from the table population, but
keeping the user of the tables close to their initialization helps
clarify the purpose of the new table. If this becomes hard to follow,
splitting the lookup separately can be an option.
---
 arch/x86/kvm/emulate.c     | 73 +++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/kvm_emulate.h |  2 ++
 arch/x86/kvm/x86.c         |  1 +
 3 files changed, 75 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index ed3a8c0bca20..58879a31abcd 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4475,6 +4475,19 @@ static const struct opcode opcode_map_0f_38[256] = {
 	N, N, X4(N), X8(N)
 };
 
+/*
+ * REX2 opcode tables.
+ *
+ * REX2-prefixed opcodes mostly follow the legacy tables but differ slightly
+ * for instructions that do not use R/X/B register bits. Initialize the REX2
+ * tables by copying the legacy ones, then mark mismatched rows as undefined.
+ */
+static struct opcode rex2_opcode_table[256]  __ro_after_init;
+static struct opcode rex2_twobyte_table[256] __ro_after_init;
+
+static const struct opcode undefined = D(Undefined);
+static const struct opcode notimpl   = N;
+
 #undef D
 #undef N
 #undef G
@@ -4761,6 +4774,11 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
 	return rc;
 }
 
+static inline bool emul_egpr_enabled(struct x86_emulate_ctxt *ctxt __maybe_unused)
+{
+	return false;
+}
+
 int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int emulation_type)
 {
 	int rc = X86EMUL_CONTINUE;
@@ -4881,7 +4899,24 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 		ctxt->op_bytes = 8;
 
 	/* Determine opcode byte(s): */
-	if (ctxt->b == 0x0f) {
+	if (ctxt->rex_prefix == REX2_INVALID) {
+		/*
+		 * A REX2 prefix was detected, but the prefix decoder
+		 * found invalid byte sequence.
+		 */
+		opcode = undefined;
+	} else if (ctxt->rex_prefix == REX2_PREFIX) {
+		/* REX2 prefix is only valid when EGPRs are enabled. */
+		if (!emul_egpr_enabled(ctxt)) {
+			opcode = undefined;
+		} else if (ctxt->rex.bits.m0) {
+			ctxt->opcode_len = 2;
+			opcode = rex2_twobyte_table[ctxt->b];
+		} else {
+			ctxt->opcode_len = 1;
+			opcode = rex2_opcode_table[ctxt->b];
+		}
+	} else if (ctxt->b == 0x0f) {
 		/* Escape byte: start two-byte opcode sequence */
 		ctxt->b = insn_fetch(u8, ctxt);
 		if (ctxt->b == 0x38) {
@@ -5526,3 +5561,39 @@ bool emulator_can_use_gpa(struct x86_emulate_ctxt *ctxt)
 
 	return true;
 }
+
+static void undefine_row(struct opcode *row)
+{
+	struct opcode *ptr = row;
+	int i;
+
+	/* Clear 16 entries per row */
+	for (i = 0; i < 0x10; i++, ptr++)
+		*ptr = undefined;
+}
+
+/*
+ * Populate REX2 opcode table:
+ *
+ * REX2-prefixed opcodes mostly reuse the legacy layout, except for those that
+ * neither reference extended register bits nor are newly introduced under the
+ * REX2 prefix. Initialize both single- and two-byte tables by cloning the
+ * legacy versions, then patch the table for some exceptions.
+ */
+void __init kvm_init_rex2_opcode_table(void)
+{
+	/* Copy legacy tables: */
+	memcpy(rex2_opcode_table, opcode_table, sizeof(opcode_table));
+	memcpy(rex2_twobyte_table, twobyte_table, sizeof(twobyte_table));
+
+	/* Undefine reserved opcode ranges: */
+	undefine_row(&rex2_opcode_table[0x40]);
+	undefine_row(&rex2_opcode_table[0x70]);
+	undefine_row(&rex2_opcode_table[0xa0]);
+	undefine_row(&rex2_opcode_table[0xe0]);
+	undefine_row(&rex2_twobyte_table[0x30]);
+	undefine_row(&rex2_twobyte_table[0x80]);
+
+	/* Mark opcode not yet implemented: */
+	rex2_opcode_table[0xa1] = notimpl;
+}
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index b285299ebfa4..cc16211d61f6 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -589,4 +589,6 @@ static inline ulong *reg_rmw(struct x86_emulate_ctxt *ctxt, unsigned nr)
 	return reg_write(ctxt, nr);
 }
 
+void __init kvm_init_rex2_opcode_table(void);
+
 #endif /* _ASM_X86_KVM_X86_EMULATE_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 338986a5a3ae..4c8c2fc3bda6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -14354,6 +14354,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_rmp_fault);
 static int __init kvm_x86_init(void)
 {
 	kvm_init_xstate_sizes();
+	kvm_init_rex2_opcode_table();
 
 	kvm_mmu_x86_module_init();
 	mitigate_smt_rsb &= boot_cpu_has_bug(X86_BUG_SMT_RSB) && cpu_smt_possible();
-- 
2.51.0


