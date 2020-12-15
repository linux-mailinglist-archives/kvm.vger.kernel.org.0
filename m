Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB692DB6B6
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 23:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgLOW6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 17:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbgLOW6r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 17:58:47 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242B6C061793
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:58:07 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id j22so12047867eja.13
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eBR/KP1XMbhrcgssotJd4G/2avIMrBZMV7G4WmoiWo8=;
        b=YrR0Z5DqkFBEJMEr1NVzef+bcwtTkoahx68HU/I9evKCqeSbblFgtzi4VwkRteuGlB
         alrA8YVrKnFX+Qmh04SBwbi4UktTCu8JTa5GIZoLuSqedrTqamgZjvge9k/ZMuj6RZv9
         0RmgIsSUZFdr60RFQPWxo20uMyRah+OAv4Hg0lBOEJrNCJXPTkVex4JsV7Td9l1UrgH8
         18sLjhIGG44a2+kwmIh29I3kxxH6eUDWLFp+NT3KAxoazrkdaDiEpHpw4+vvcikbRRB9
         Hpab1AIgsyW6ZGURc5Qrd31/2aT5JgQyU4ESaIVP0R1q+at+GxzUWO0g1NhFgG7SS0xd
         o/Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=eBR/KP1XMbhrcgssotJd4G/2avIMrBZMV7G4WmoiWo8=;
        b=UdWRhzdeQzwrgw/Zo8zW3JAkbuSjJ1QVRaKys5WZMm8dk5qcTSdFQtgQ1evx5D6lkg
         TSzrONUnbbx/ziO4fBd76oH2Ac+7c8nkmlXotzAimpUrJiOk9zpS1WZfeXoKSBJnNa8s
         qxDs4ulVZMWRnswXUUDkb7AL+THe8CN6Gmcc3zPPkLCWvWmmtvkLA8NnbujwCTVQzqSL
         8/sxamq82Vy35vcdvcfj6pDm7jb+O/MsnF/lzo9IfUinEGhiXKqgkZ4EEdUrxFYP3caE
         QDTxJQ8a2xYkDew+2YIePirBNXRGR5X23rBU/Clah6hoeoHssaXdgeSVL83ku/IKxJHC
         zRPg==
X-Gm-Message-State: AOAM5311oTzyDKj3UdTKLjHxLPbreKpNtkwtVrOHZf44kIQnQ71hZMQ/
        QOW0JzFzwAyHK7zE+lYn6tU=
X-Google-Smtp-Source: ABdhPJw8ylReeQsh/8yN74nzFbXTfd16F9/1BaCqotQgh4xKhIEOL+x+fifCJ+4D13ea5/hOaaDSYg==
X-Received: by 2002:a17:906:4a4f:: with SMTP id a15mr29198657ejv.541.1608073085939;
        Tue, 15 Dec 2020 14:58:05 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id o33sm19828818edd.50.2020.12.15.14.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 14:58:05 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Huacai Chen <chenhuacai@kernel.org>
Subject: [PATCH v2 01/24] target/mips/translate: Extract decode_opc_legacy() from decode_opc()
Date:   Tue, 15 Dec 2020 23:57:34 +0100
Message-Id: <20201215225757.764263-2-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201215225757.764263-1-f4bug@amsat.org>
References: <20201215225757.764263-1-f4bug@amsat.org>
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
---
 target/mips/translate.c | 45 ++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/target/mips/translate.c b/target/mips/translate.c
index cc876019bf7..5c62b32c6ae 100644
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

