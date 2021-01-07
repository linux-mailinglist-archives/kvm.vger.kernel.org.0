Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385C32EE889
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727344AbhAGW0R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728516AbhAGW0Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:26:16 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0FFC0612FB
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:25:58 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id g185so6832742wmf.3
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:25:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RlmjZD/A3T2fr0JUoH85vuwC1Fo52rRxQmVB1QjBz9E=;
        b=SBMuA4EtFqwEkxXdKSMPXgSAj5wO/ro1U0KG3liHYmdnBG8jNhHd3jQFjxQMVPmtuQ
         djha6PXbWdgHLoBYZZp0NTWSPTsV+dVZb9mQvq1lc2Id0/jLLwWoqu4OlN93PI3Qt9B7
         +aHRMKklepcEu/z3bOSwAd2zZWXM4frr5tPFC9ISQC+ikKfTuaBSzmlFPXiEA+emzwux
         C4g1kt2Eu1Zb9rAmUGwnh62YQUShiUMouxwhGtycXrW0rMK2Wtxyspcm+12W4/5NnvCJ
         af3Bqe9WZ2CCR0Cw3QDw72F2W4BQv1wF5AxgZP17OzkknmMt90a4UqO5+UyA4Zc1L9JZ
         dLww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=RlmjZD/A3T2fr0JUoH85vuwC1Fo52rRxQmVB1QjBz9E=;
        b=r1n5XZvbHDQGR9kcdjFudc7TZh++fNcchqs+EVNlEHSb78o3rKpt2wTkbSfrR8tYA1
         DZolcDgZvEG6G94S7LCyD40tTVAZUOfxkAN6Ok4/Bd8rA2at0Qq98PggIjDlCyyqfKPN
         uhNuEtBTrwpWzzziYDm6Q5P9aaBJ5g0qDfGqcr1moOjfWb2k1Msoav6T3tgP9N8/InrE
         puHU+ZS7LH2NqyKevRQGIPNU6a2HHqyHvqHrCyuGJv6ev85v0yvaUvKyWpn8mHSMFco6
         L4xbnfShqIBKczlaUFG/ROnLnOA6dqQALMu+bmRBgzwPyIw5wIkpmt3/wG8pcgh0y/a7
         qXjQ==
X-Gm-Message-State: AOAM532HTetQfX+gS0FRIMN0kAil3DniAs8eW1DPhUYhdJhwU27J196U
        4jbjXRzhqBQV6yMSwEj9/cc=
X-Google-Smtp-Source: ABdhPJwoJVLzZ/qFA+Cy7r9W3UMAsAZQYt1Z3j0t6hvrmnMMZTF2r3KKkM6n6BLOL4rOpv3nSHSgnw==
X-Received: by 2002:a1c:5410:: with SMTP id i16mr543118wmb.30.1610058357273;
        Thu, 07 Jan 2021 14:25:57 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id z3sm11193357wrn.59.2021.01.07.14.25.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:25:56 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     libvir-list@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>, kvm@vger.kernel.org,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paul Burton <paulburton@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PULL 35/66] target/mips/translate: Extract decode_opc_legacy() from decode_opc()
Date:   Thu,  7 Jan 2021 23:22:22 +0100
Message-Id: <20210107222253.20382-36-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As we will slowly move to decodetree generated decoders,
extract the legacy decoding from decode_opc(), so new
decoders are added in decode_opc() while old code is
removed from decode_opc_legacy().

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201215225757.764263-2-f4bug@amsat.org>
---
 target/mips/translate.c | 45 ++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/target/mips/translate.c b/target/mips/translate.c
index 39b57794b36..7d2120dd51c 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -30518,30 +30518,13 @@ static void gen_msa(CPUMIPSState *env, DisasContext *ctx)
 
 }
 
-static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
+static bool decode_opc_legacy(CPUMIPSState *env, DisasContext *ctx)
 {
     int32_t offset;
     int rs, rt, rd, sa;
     uint32_t op, op1;
     int16_t imm;
 
-    /* make sure instructions are on a word boundary */
-    if (ctx->base.pc_next & 0x3) {
-        env->CP0_BadVAddr = ctx->base.pc_next;
-        generate_exception_err(ctx, EXCP_AdEL, EXCP_INST_NOTAVAIL);
-        return;
-    }
-
-    /* Handle blikely not taken case */
-    if ((ctx->hflags & MIPS_HFLAG_BMASK_BASE) == MIPS_HFLAG_BL) {
-        TCGLabel *l1 = gen_new_label();
-
-        tcg_gen_brcondi_tl(TCG_COND_NE, bcond, 0, l1);
-        tcg_gen_movi_i32(hflags, ctx->hflags & ~MIPS_HFLAG_BMASK);
-        gen_goto_tb(ctx, 1, ctx->base.pc_next + 4);
-        gen_set_label(l1);
-    }
-
     op = MASK_OP_MAJOR(ctx->opcode);
     rs = (ctx->opcode >> 21) & 0x1f;
     rt = (ctx->opcode >> 16) & 0x1f;
@@ -31269,8 +31252,32 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
         break;
     default:            /* Invalid */
         MIPS_INVAL("major opcode");
+        return false;
+    }
+    return true;
+}
+
+static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
+{
+    /* make sure instructions are on a word boundary */
+    if (ctx->base.pc_next & 0x3) {
+        env->CP0_BadVAddr = ctx->base.pc_next;
+        generate_exception_err(ctx, EXCP_AdEL, EXCP_INST_NOTAVAIL);
+        return;
+    }
+
+    /* Handle blikely not taken case */
+    if ((ctx->hflags & MIPS_HFLAG_BMASK_BASE) == MIPS_HFLAG_BL) {
+        TCGLabel *l1 = gen_new_label();
+
+        tcg_gen_brcondi_tl(TCG_COND_NE, bcond, 0, l1);
+        tcg_gen_movi_i32(hflags, ctx->hflags & ~MIPS_HFLAG_BMASK);
+        gen_goto_tb(ctx, 1, ctx->base.pc_next + 4);
+        gen_set_label(l1);
+    }
+
+    if (!decode_opc_legacy(env, ctx)) {
         gen_reserved_instruction(ctx);
-        break;
     }
 }
 
-- 
2.26.2

