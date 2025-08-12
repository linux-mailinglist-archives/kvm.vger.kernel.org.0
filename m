Return-Path: <kvm+bounces-54491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C51A1B21B21
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 05:01:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E59851A25016
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 03:01:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96AAE2E975A;
	Tue, 12 Aug 2025 02:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k/fpH+Qi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF49D2E88A1;
	Tue, 12 Aug 2025 02:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754967400; cv=none; b=VhBI44M13e/w0X/VY367IO4hhE0jqz0PHyhu/Q9eUeyBf8HTm5CwxsI2dZTVQWIqWRoNFXqXTZzM0d2bp5QTps21Y0749KwQqdeTbjA2jApLQGb71oCxXGZsE01/TJ4hndEG3xaZZJHjyBm6UGqUUxNKv5Kh3R0Q7X7+i+ipAww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754967400; c=relaxed/simple;
	bh=dXQQ6a4EW2NVwV3ot4UhfBim9c1Mpdn5wm1COxgLrU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxRk1Nj5FLH8wkAPdC4ACAT3u/JGmIh+oF59yHGuz7N8m1OZdr8AEMUs+fy0iFhM9sF7LNXg2r1XP/k7pNve3ELQvA5vNS82KPOk3N6LFHD6Y0FR1NnWz/iMWA8S1Z51aJYdaNoxLSQ4mw09de88od8STRAAV9pOMmSonBoF/bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k/fpH+Qi; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754967399; x=1786503399;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dXQQ6a4EW2NVwV3ot4UhfBim9c1Mpdn5wm1COxgLrU0=;
  b=k/fpH+QiGL7jtZ9xxSrBZZoRYf1zVPlFKO4S+8ng0NmJpxoNL3xNkt7f
   cOiwWaQe0G/ChYMZBz6FgUhntATelOP6k/nQi4oZzGq0njknIm87IEtPI
   +GzR/c+V2T3+u0kcmWBnGGIRiHHkeGK4ynmOlP5FFJDDrk8wOU2q0nej9
   7ML9IPCZbfNf7kK9hwoMh5NT6VA2RQTE3qvxDnHRvMgswkNSR/9DArFtl
   dndseUmXaeI+bv70675Nh41TRvQHRnGu9OYbuMIaLi85jlom88vrgXRhX
   rWOOkrZ4B44mkJu6FGs7EYk0sUUWogR2tDqIxD/oy4K0Tzf6WjeMZL11I
   A==;
X-CSE-ConnectionGUID: pKWcvkDvQua7Gk4TOjLU6w==
X-CSE-MsgGUID: eExxvCgARz27Q+NmyRI4Fg==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="57100620"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="57100620"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:37 -0700
X-CSE-ConnectionGUID: 8M7JzkofTFO43FrUak2t3g==
X-CSE-MsgGUID: sVLhmJzKTnyRE2+a4R7a8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="171321354"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:37 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: mlevitsk@redhat.com,
	rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com,
	xin@zytor.com,
	Chao Gao <chao.gao@intel.com>,
	Mathias Krause <minipli@grsecurity.net>,
	John Allen <john.allen@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v12 19/24] KVM: x86: Don't emulate instructions guarded by CET
Date: Mon, 11 Aug 2025 19:55:27 -0700
Message-ID: <20250812025606.74625-20-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250812025606.74625-1-chao.gao@intel.com>
References: <20250812025606.74625-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

Don't emulate the branch instructions, e.g., CALL/RET/JMP etc., when CET
is active in guest, return KVM_INTERNAL_ERROR_EMULATION to userspace to
handle it.

KVM doesn't emulate CPU behaviors to check CET protected stuffs while
emulating guest instructions, instead it stops emulation on detecting
the instructions in process are CET protected. By doing so, it can avoid
generating bogus #CP in guest and preventing CET protected execution flow
subversion from guest side.

Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/emulate.c | 46 ++++++++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 1349e278cd2a..80b9d1e4a50a 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -178,6 +178,8 @@
 #define IncSP       ((u64)1 << 54)  /* SP is incremented before ModRM calc */
 #define TwoMemOp    ((u64)1 << 55)  /* Instruction has two memory operand */
 #define IsBranch    ((u64)1 << 56)  /* Instruction is considered a branch. */
+#define ShadowStack ((u64)1 << 57)  /* Instruction protected by Shadow Stack. */
+#define IndirBrnTrk ((u64)1 << 58)  /* Instruction protected by IBT. */
 
 #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)
 
@@ -4068,9 +4070,11 @@ static const struct opcode group4[] = {
 static const struct opcode group5[] = {
 	F(DstMem | SrcNone | Lock,		em_inc),
 	F(DstMem | SrcNone | Lock,		em_dec),
-	I(SrcMem | NearBranch | IsBranch,       em_call_near_abs),
-	I(SrcMemFAddr | ImplicitOps | IsBranch, em_call_far),
-	I(SrcMem | NearBranch | IsBranch,       em_jmp_abs),
+	I(SrcMem | NearBranch | IsBranch | ShadowStack | IndirBrnTrk,
+	em_call_near_abs),
+	I(SrcMemFAddr | ImplicitOps | IsBranch | ShadowStack | IndirBrnTrk,
+	em_call_far),
+	I(SrcMem | NearBranch | IsBranch | IndirBrnTrk, em_jmp_abs),
 	I(SrcMemFAddr | ImplicitOps | IsBranch, em_jmp_far),
 	I(SrcMem | Stack | TwoMemOp,		em_push), D(Undefined),
 };
@@ -4332,11 +4336,11 @@ static const struct opcode opcode_table[256] = {
 	/* 0xC8 - 0xCF */
 	I(Stack | SrcImmU16 | Src2ImmByte | IsBranch, em_enter),
 	I(Stack | IsBranch, em_leave),
-	I(ImplicitOps | SrcImmU16 | IsBranch, em_ret_far_imm),
-	I(ImplicitOps | IsBranch, em_ret_far),
-	D(ImplicitOps | IsBranch), DI(SrcImmByte | IsBranch, intn),
+	I(ImplicitOps | SrcImmU16 | IsBranch | ShadowStack, em_ret_far_imm),
+	I(ImplicitOps | IsBranch | ShadowStack, em_ret_far),
+	D(ImplicitOps | IsBranch), DI(SrcImmByte | IsBranch | ShadowStack, intn),
 	D(ImplicitOps | No64 | IsBranch),
-	II(ImplicitOps | IsBranch, em_iret, iret),
+	II(ImplicitOps | IsBranch | ShadowStack, em_iret, iret),
 	/* 0xD0 - 0xD7 */
 	G(Src2One | ByteOp, group2), G(Src2One, group2),
 	G(Src2CL | ByteOp, group2), G(Src2CL, group2),
@@ -4352,7 +4356,7 @@ static const struct opcode opcode_table[256] = {
 	I2bvIP(SrcImmUByte | DstAcc, em_in,  in,  check_perm_in),
 	I2bvIP(SrcAcc | DstImmUByte, em_out, out, check_perm_out),
 	/* 0xE8 - 0xEF */
-	I(SrcImm | NearBranch | IsBranch, em_call),
+	I(SrcImm | NearBranch | IsBranch | ShadowStack, em_call),
 	D(SrcImm | ImplicitOps | NearBranch | IsBranch),
 	I(SrcImmFAddr | No64 | IsBranch, em_jmp_far),
 	D(SrcImmByte | ImplicitOps | NearBranch | IsBranch),
@@ -4371,7 +4375,8 @@ static const struct opcode opcode_table[256] = {
 static const struct opcode twobyte_table[256] = {
 	/* 0x00 - 0x0F */
 	G(0, group6), GD(0, &group7), N, N,
-	N, I(ImplicitOps | EmulateOnUD | IsBranch, em_syscall),
+	N, I(ImplicitOps | EmulateOnUD | IsBranch | ShadowStack | IndirBrnTrk,
+	em_syscall),
 	II(ImplicitOps | Priv, em_clts, clts), N,
 	DI(ImplicitOps | Priv, invd), DI(ImplicitOps | Priv, wbinvd), N, N,
 	N, D(ImplicitOps | ModRM | SrcMem | NoAccess), N, N,
@@ -4402,8 +4407,9 @@ static const struct opcode twobyte_table[256] = {
 	IIP(ImplicitOps, em_rdtsc, rdtsc, check_rdtsc),
 	II(ImplicitOps | Priv, em_rdmsr, rdmsr),
 	IIP(ImplicitOps, em_rdpmc, rdpmc, check_rdpmc),
-	I(ImplicitOps | EmulateOnUD | IsBranch, em_sysenter),
-	I(ImplicitOps | Priv | EmulateOnUD | IsBranch, em_sysexit),
+	I(ImplicitOps | EmulateOnUD | IsBranch | ShadowStack | IndirBrnTrk,
+	em_sysenter),
+	I(ImplicitOps | Priv | EmulateOnUD | IsBranch | ShadowStack, em_sysexit),
 	N, N,
 	N, N, N, N, N, N, N, N,
 	/* 0x40 - 0x4F */
@@ -4941,6 +4947,24 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 	if (ctxt->d == 0)
 		return EMULATION_FAILED;
 
+	if (ctxt->ops->get_cr(ctxt, 4) & X86_CR4_CET) {
+		u64 u_cet, s_cet;
+		bool stop_em;
+
+		if (ctxt->ops->get_msr(ctxt, MSR_IA32_U_CET, &u_cet) ||
+		    ctxt->ops->get_msr(ctxt, MSR_IA32_S_CET, &s_cet))
+			return EMULATION_FAILED;
+
+		stop_em = ((u_cet & CET_SHSTK_EN) || (s_cet & CET_SHSTK_EN)) &&
+			  (opcode.flags & ShadowStack);
+
+		stop_em |= ((u_cet & CET_ENDBR_EN) || (s_cet & CET_ENDBR_EN)) &&
+			   (opcode.flags & IndirBrnTrk);
+
+		if (stop_em)
+			return EMULATION_FAILED;
+	}
+
 	ctxt->execute = opcode.u.execute;
 
 	if (unlikely(emulation_type & EMULTYPE_TRAP_UD) &&
-- 
2.47.1


