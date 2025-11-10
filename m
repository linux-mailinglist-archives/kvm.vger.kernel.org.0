Return-Path: <kvm+bounces-62567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F23AC48922
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 19:32:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2120A3BA44C
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EA82337BB1;
	Mon, 10 Nov 2025 18:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AFvhdxSC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4577233710F;
	Mon, 10 Nov 2025 18:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762799105; cv=none; b=FQQgwFxKsfvSZAHQ/zmoGNSxbVvx6V7owefja9tw4f7se57/OjxrVtzAOLtO1LMsa1fl4DUZN4zE1jBU4gGtj4E4jCF1EyW2GgIWStqDgp0CqllaflCAPcAwfPslGq0b8a7SnsB1m0CS8w34izg+m3fR3ta9WsG9bgk3wx2TylM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762799105; c=relaxed/simple;
	bh=EkIlUTsAjCozM0tNyupgDOe46m8fi+dk3CanNhD+v2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdgCq2ljdRzZfO8V80Ja7XeUBcvCIccyo0cVaJIDR+8bhsPeD/vLxVDIa8dd8+Td/WLLIL8q5MLul0rNkc3d4wvOh5P3tZUWu02eXP5OoobMYo8YH71+PuSGhjdzgR8oBcTiaQ+k41/29A15wYfi6EEI/dLARBw1hIdAnXqWsRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AFvhdxSC; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762799104; x=1794335104;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EkIlUTsAjCozM0tNyupgDOe46m8fi+dk3CanNhD+v2Q=;
  b=AFvhdxSCVutr+PB+LZipZMyMewoZxKsLCZhQmIxVFjOp24ccBCqEVDnM
   +PvTE9MzBFsZlObmVr2WC0vo2qDKoiQRzJT9d/dawFq9+U8iI+zy3B/Yn
   x1ALNtwmXwFCZE70p7l44pwm8bQ7WzcsVe3qU7tYek9Zt1WHoeyfqy9tR
   en3v7+H5H0PcWxTmO4RoZFhp7T0D1nO4gJXIyQqI97uNyhmWiV6Bu4ZHP
   +cRgNN9mDqTo9xBxp5tqT2MaTrWA7V/J27xlgzTjIs2m0DBb3ynis2kuE
   X0Oyn3f9HwX9S+dTUB5TAkMYsG5gja9Hnlf8uy9yCUnkkE3aJEiDnYJQJ
   Q==;
X-CSE-ConnectionGUID: nX4SsH2fSAKzUYhfUyhE5w==
X-CSE-MsgGUID: pgwRUCG9SOSNDlKUtJgP3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="76305521"
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="76305521"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 10:25:04 -0800
X-CSE-ConnectionGUID: FxIUYRg+Tr2eJNmT/rxdsg==
X-CSE-MsgGUID: QQsX7R7CR42UtpyQ9uljeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="219396213"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 10 Nov 2025 10:25:04 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	chao.gao@intel.com,
	zhao1.liu@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH RFC v1 16/20] KVM: x86: Decode REX2 prefix in the emulator
Date: Mon, 10 Nov 2025 18:01:27 +0000
Message-ID: <20251110180131.28264-17-chang.seok.bae@intel.com>
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

Extend the instruction emulator to recognize and interpret the REX2
prefix byte. Also, detect and flag invalid prefix sequences after a REX2
prefix.

In the existing prefix-decoding loop,
  * The loop exits when the first non-prefix byte is encountered.
  * Any non-REX prefix clears previously recorded REX information.

For REX2, however, once a REX2 prefix is encountered, most subsequent
prefixes are invalid. So, each subsequent prefix needs to be validated
before continuing the loop.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
RFC note:
The REX2 decoding itself is straightforward. The additional logic is
mainly to detect and handle invalid prefix sequences. If this seems
excessive, there is a chance to cut off this check since VMX would raise
'#UD' on such cases anyway.
---
 arch/x86/kvm/emulate.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 9bd61ea496e5..f9381a4055d6 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4844,7 +4844,7 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 	ctxt->op_bytes = def_op_bytes;
 	ctxt->ad_bytes = def_ad_bytes;
 
-	/* Legacy prefixes. */
+	/* Legacy and REX/REX2 prefixes. */
 	for (;;) {
 		switch (ctxt->b = insn_fetch(u8, ctxt)) {
 		case 0x66:	/* operand-size override */
@@ -4887,9 +4887,20 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 		case 0x40 ... 0x4f: /* REX */
 			if (mode != X86EMUL_MODE_PROT64)
 				goto done_prefixes;
+			if (ctxt->rex_prefix == REX2_PREFIX)
+				break;
 			ctxt->rex_prefix = REX_PREFIX;
 			ctxt->rex.raw    = 0x0f & ctxt->b;
 			continue;
+		case 0xd5: /* REX2 */
+			if (mode != X86EMUL_MODE_PROT64)
+				goto done_prefixes;
+			if (ctxt->rex_prefix == REX2_PREFIX &&
+			    ctxt->rex.bits.m0 == 0)
+				break;
+			ctxt->rex_prefix = REX2_PREFIX;
+			ctxt->rex.raw    = insn_fetch(u8, ctxt);
+			continue;
 		case 0xf0:	/* LOCK */
 			ctxt->lock_prefix = 1;
 			break;
@@ -4901,6 +4912,17 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 			goto done_prefixes;
 		}
 
+		if (ctxt->rex_prefix == REX2_PREFIX) {
+			/*
+			 * A legacy or REX prefix following a REX2 prefix
+			 * forms an invalid byte sequences. Likewise,
+			 * a second REX2 prefix following a REX2 prefix
+			 * with M0=0 is invalid.
+			 */
+			ctxt->rex_prefix = REX2_INVALID;
+			goto done_prefixes;
+		}
+
 		/* Any legacy prefix after a REX prefix nullifies its effect. */
 		ctxt->rex_prefix = REX_NONE;
 		ctxt->rex.raw = 0;
-- 
2.51.0


