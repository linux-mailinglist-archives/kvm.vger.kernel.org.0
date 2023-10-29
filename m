Return-Path: <kvm+bounces-14-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D9E317DABF7
	for <lists+kvm@lfdr.de>; Sun, 29 Oct 2023 11:17:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F07E281585
	for <lists+kvm@lfdr.de>; Sun, 29 Oct 2023 10:17:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 317729456;
	Sun, 29 Oct 2023 10:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE6A398
	for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 10:17:08 +0000 (UTC)
X-Greylist: delayed 1200 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 29 Oct 2023 03:17:06 PDT
Received: from 7.mo560.mail-out.ovh.net (7.mo560.mail-out.ovh.net [188.165.48.182])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB900C0
	for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 03:17:06 -0700 (PDT)
Received: from director4.ghost.mail-out.ovh.net (unknown [10.108.16.30])
	by mo560.mail-out.ovh.net (Postfix) with ESMTP id B8B9E26531
	for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 09:39:10 +0000 (UTC)
Received: from ghost-submission-6684bf9d7b-cv5d2 (unknown [10.110.171.164])
	by director4.ghost.mail-out.ovh.net (Postfix) with ESMTPS id 856C91FE5E;
	Sun, 29 Oct 2023 09:39:08 +0000 (UTC)
Received: from foxhound.fi ([37.59.142.103])
	by ghost-submission-6684bf9d7b-cv5d2 with ESMTPSA
	id JR/PGjwoPmW5FQAA0ek+iw
	(envelope-from <jose.pekkarinen@foxhound.fi>); Sun, 29 Oct 2023 09:39:08 +0000
Authentication-Results:garm.ovh; auth=pass (GARM-103G005964038db-79ba-4581-8d75-77bb2bfe47b4,
                    2D5A9C8C3C9544CFCEEB4DEE313913C815DB1A20) smtp.auth=jose.pekkarinen@foxhound.fi
X-OVh-ClientIp:87.94.110.144
From: =?UTF-8?q?Jos=C3=A9=20Pekkarinen?= <jose.pekkarinen@foxhound.fi>
To: seanjc@google.com,
	pbonzini@redhat.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	skhan@linuxfoundation.org
Cc: =?UTF-8?q?Jos=C3=A9=20Pekkarinen?= <jose.pekkarinen@foxhound.fi>,
	x86@kernel.org,
	hpa@zytor.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH] KVM: x86: cleanup unused variables
Date: Sun, 29 Oct 2023 11:38:59 +0200
Message-Id: <20231029093859.138442-1-jose.pekkarinen@foxhound.fi>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 2899755212625716902
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrleekgddthecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecunecujfgurhephffvvefufffkofggtgfgsehtkeertdertdejnecuhfhrohhmpeflohhsrocurfgvkhhkrghrihhnvghnuceojhhoshgvrdhpvghkkhgrrhhinhgvnhesfhhogihhohhunhgurdhfiheqnecuggftrfgrthhtvghrnhepfedtleeuteeitedvtedtteeuieevudejfeffvdetfeekleehhfelleefteetjeejnecukfhppeduvdejrddtrddtrddupdekjedrleegrdduuddtrddugeegpdefjedrheelrddugedvrddutdefnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeojhhoshgvrdhpvghkkhgrrhhinhgvnhesfhhogihhohhunhgurdhfiheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheeitddpmhhouggvpehsmhhtphhouhht

Reported by coccinelle, the following patch will remove some
redundant variables. This patch will address the following
warnings:

arch/x86/kvm/emulate.c:1315:5-7: Unneeded variable: "rc". Return "X86EMUL_CONTINUE" on line 1330
arch/x86/kvm/emulate.c:4557:5-7: Unneeded variable: "rc". Return "X86EMUL_CONTINUE" on line 4591
arch/x86/kvm/emulate.c:1180:5-7: Unneeded variable: "rc". Return "X86EMUL_CONTINUE" on line 1202

Signed-off-by: José Pekkarinen <jose.pekkarinen@foxhound.fi>
---
 arch/x86/kvm/emulate.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 2673cd5c46cb..c4bb03a88dfe 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1177,7 +1177,6 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 {
 	u8 sib;
 	int index_reg, base_reg, scale;
-	int rc = X86EMUL_CONTINUE;
 	ulong modrm_ea = 0;
 
 	ctxt->modrm_reg = ((ctxt->rex_prefix << 1) & 8); /* REX.R */
@@ -1199,16 +1198,16 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 			op->bytes = 16;
 			op->addr.xmm = ctxt->modrm_rm;
 			kvm_read_sse_reg(ctxt->modrm_rm, &op->vec_val);
-			return rc;
+			return X86EMUL_CONTINUE;
 		}
 		if (ctxt->d & Mmx) {
 			op->type = OP_MM;
 			op->bytes = 8;
 			op->addr.mm = ctxt->modrm_rm & 7;
-			return rc;
+			return X86EMUL_CONTINUE;
 		}
 		fetch_register_operand(op);
-		return rc;
+		return X86EMUL_CONTINUE;
 	}
 
 	op->type = OP_MEM;
@@ -1306,14 +1305,12 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 		ctxt->memop.addr.mem.ea = (u32)ctxt->memop.addr.mem.ea;
 
 done:
-	return rc;
+	return X86EMUL_CONTINUE;
 }
 
 static int decode_abs(struct x86_emulate_ctxt *ctxt,
 		      struct operand *op)
 {
-	int rc = X86EMUL_CONTINUE;
-
 	op->type = OP_MEM;
 	switch (ctxt->ad_bytes) {
 	case 2:
@@ -1327,7 +1324,7 @@ static int decode_abs(struct x86_emulate_ctxt *ctxt,
 		break;
 	}
 done:
-	return rc;
+	return X86EMUL_CONTINUE;
 }
 
 static void fetch_bit_operand(struct x86_emulate_ctxt *ctxt)
@@ -4554,8 +4551,6 @@ static unsigned imm_size(struct x86_emulate_ctxt *ctxt)
 static int decode_imm(struct x86_emulate_ctxt *ctxt, struct operand *op,
 		      unsigned size, bool sign_extension)
 {
-	int rc = X86EMUL_CONTINUE;
-
 	op->type = OP_IMM;
 	op->bytes = size;
 	op->addr.mem.ea = ctxt->_eip;
@@ -4588,7 +4583,7 @@ static int decode_imm(struct x86_emulate_ctxt *ctxt, struct operand *op,
 		}
 	}
 done:
-	return rc;
+	return X86EMUL_CONTINUE;
 }
 
 static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
-- 
2.39.2


