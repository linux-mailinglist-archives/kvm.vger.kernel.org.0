Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 246612DB6CB
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 00:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730612AbgLOXAf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 18:00:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730423AbgLOXAJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 18:00:09 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249F2C061793
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:59:54 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id cm17so22843277edb.4
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YiCWC0K0BpPtxSsBugnUMdi5L646sG0eSz98PXvsG6o=;
        b=Kf4y9LhBkewDzJQ+65mUKnwTqwCVxZRL88BKSVzrUSgOprshgYVL5eFH6g7OJYXUii
         fsu1oUPyCvQHTMaQmfRjkWHzm/8CnJmysMv5jgPr16OrKxNK7bkERELxLPbb1mqVnkAJ
         /vTQpRTycqWWjr3RvNCqgEl7iN+2S2jaMheJtW8LtCfwcV3OiA7VuQztp8YUXhMubLul
         /dNdrQgqKr6R09ubRN7DdPH8Y+4y+KnzzHYOZOqg9PjMp7nneynAUjGz453GDBTSCa4g
         d4eq8hr4dp9DAbKzbXFv56JCI4iou7c73XU8Yht7scPfQ5C32pgas6Fc/6j4j+M/NUo0
         iRfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=YiCWC0K0BpPtxSsBugnUMdi5L646sG0eSz98PXvsG6o=;
        b=YT6OJNLUwSTlTSsjrt7fgoz+7KDRc2PdW5Yhvxf3pJAdGdhdzMZxX96M7L8JsbkCl5
         IYhnYVtN3hwKJhY6CLtMV9stBY/SfAprahYiUzokGUWjvYfCT2m3grvMQpLffq8WyLuN
         IVzKtJRcmgaJtmsegRaFLfKNA/QOFg9a6hKesOjG6cZ8PvyDFqFDLBH8rXdviVfE5f1/
         EGYar9ZH/bs26kJfsDZohFmAwOiowODHwQ2D+EwqdgAbIQPEXlymKzMmVituLAVbAT1a
         sayPSZqt8m6eAxEYds13DVx2ORkmTvXOw4T5OAHBUcE6rPfUBkHkPQgl1aU4rbXMVQ4C
         GKww==
X-Gm-Message-State: AOAM532bznKg+b59UPGLvR7KoaYIzGTGmGuseo2qutzN1zdDQU7+b8CR
        n0R0O845hVt3mLfEX1wwhrw=
X-Google-Smtp-Source: ABdhPJy7G+MixB/CP0tzpA6lyu2mwvF/wF9LYIcPPlO3BTa38GHeef+LM0daH+IODqs+NauCk0ysTQ==
X-Received: by 2002:a50:bb44:: with SMTP id y62mr31377675ede.103.1608073192913;
        Tue, 15 Dec 2020 14:59:52 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id w20sm19937008edi.12.2020.12.15.14.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 14:59:52 -0800 (PST)
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
Subject: [PATCH v2 20/24] target/mips: Use decode_ase_msa() generated from decodetree
Date:   Tue, 15 Dec 2020 23:57:53 +0100
Message-Id: <20201215225757.764263-21-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201215225757.764263-1-f4bug@amsat.org>
References: <20201215225757.764263-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we can decode the MSA ASE opcodes with decode_msa32(),
use it and remove the unreachable code.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/translate.h         | 12 ------------
 target/mips/mod-msa_translate.c | 29 +----------------------------
 target/mips/translate.c         | 31 ++++++++++---------------------
 3 files changed, 11 insertions(+), 61 deletions(-)

diff --git a/target/mips/translate.h b/target/mips/translate.h
index 7ca92bd6beb..8d84e0c254d 100644
--- a/target/mips/translate.h
+++ b/target/mips/translate.h
@@ -82,8 +82,6 @@ enum {
     OPC_BC1      = (0x08 << 21) | OPC_CP1, /* bc */
     OPC_BC1ANY2  = (0x09 << 21) | OPC_CP1,
     OPC_BC1ANY4  = (0x0A << 21) | OPC_CP1,
-    OPC_BZ_V     = (0x0B << 21) | OPC_CP1,
-    OPC_BNZ_V    = (0x0F << 21) | OPC_CP1,
     OPC_S_FMT    = (FMT_S << 21) | OPC_CP1,
     OPC_D_FMT    = (FMT_D << 21) | OPC_CP1,
     OPC_E_FMT    = (FMT_E << 21) | OPC_CP1,
@@ -93,14 +91,6 @@ enum {
     OPC_PS_FMT   = (FMT_PS << 21) | OPC_CP1,
     OPC_BC1EQZ   = (0x09 << 21) | OPC_CP1,
     OPC_BC1NEZ   = (0x0D << 21) | OPC_CP1,
-    OPC_BZ_B     = (0x18 << 21) | OPC_CP1,
-    OPC_BZ_H     = (0x19 << 21) | OPC_CP1,
-    OPC_BZ_W     = (0x1A << 21) | OPC_CP1,
-    OPC_BZ_D     = (0x1B << 21) | OPC_CP1,
-    OPC_BNZ_B    = (0x1C << 21) | OPC_CP1,
-    OPC_BNZ_H    = (0x1D << 21) | OPC_CP1,
-    OPC_BNZ_W    = (0x1E << 21) | OPC_CP1,
-    OPC_BNZ_D    = (0x1F << 21) | OPC_CP1,
 };
 
 #define MASK_CP1_FUNC(op)           (MASK_CP1(op) | (op & 0x3F))
@@ -163,8 +153,6 @@ extern TCGv bcond;
 
 /* MSA */
 void msa_translate_init(void);
-void gen_msa(DisasContext *ctx);
-void gen_msa_branch(DisasContext *ctx, uint32_t op1);
 
 /* decodetree generated */
 bool decode_ase_msa(DisasContext *ctx, uint32_t insn);
diff --git a/target/mips/mod-msa_translate.c b/target/mips/mod-msa_translate.c
index d0e393a6831..d1a8a95e62e 100644
--- a/target/mips/mod-msa_translate.c
+++ b/target/mips/mod-msa_translate.c
@@ -414,33 +414,6 @@ static bool trans_BNZ_x(DisasContext *ctx, arg_msa_bz *a)
     return gen_msa_BxZ(ctx, a->df, a->wt, a->s16, true);
 }
 
-void gen_msa_branch(DisasContext *ctx, uint32_t op1)
-{
-    uint8_t df = (ctx->opcode >> 21) & 0x3;
-    uint8_t wt = (ctx->opcode >> 16) & 0x1f;
-    int64_t s16 = (int16_t)ctx->opcode;
-
-    switch (op1) {
-    case OPC_BZ_V:
-    case OPC_BNZ_V:
-        gen_msa_BxZ_V(ctx, wt, s16, (op1 == OPC_BZ_V) ?
-                                    TCG_COND_EQ : TCG_COND_NE);
-        break;
-    case OPC_BZ_B:
-    case OPC_BZ_H:
-    case OPC_BZ_W:
-    case OPC_BZ_D:
-        gen_msa_BxZ(ctx, df, wt, s16, false);
-        break;
-    case OPC_BNZ_B:
-    case OPC_BNZ_H:
-    case OPC_BNZ_W:
-    case OPC_BNZ_D:
-        gen_msa_BxZ(ctx, df, wt, s16, true);
-        break;
-    }
-}
-
 static void gen_msa_i8(DisasContext *ctx)
 {
 #define MASK_MSA_I8(op)    (MASK_MSA_MINOR(op) | (op & (0x03 << 24)))
@@ -2190,7 +2163,7 @@ static void gen_msa_vec(DisasContext *ctx)
     }
 }
 
-void gen_msa(DisasContext *ctx)
+static void gen_msa(DisasContext *ctx)
 {
     uint32_t opcode = ctx->opcode;
 
diff --git a/target/mips/translate.c b/target/mips/translate.c
index f36255f073a..2ce3dc10dfb 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -6,6 +6,7 @@
  *  Copyright (c) 2006 Thiemo Seufer (MIPS32R2 support)
  *  Copyright (c) 2009 CodeSourcery (MIPS16 and microMIPS support)
  *  Copyright (c) 2012 Jia Liu & Dongxue Zhang (MIPS ASE DSP support)
+ *  Copyright (c) 2020 Philippe Mathieu-Daudé
  *
  * This library is free software; you can redistribute it and/or
  * modify it under the terms of the GNU Lesser General Public
@@ -135,8 +136,6 @@ enum {
     OPC_JIALC    = (0x3E << 26),
     /* MDMX ASE specific */
     OPC_MDMX     = (0x1E << 26),
-    /* MSA ASE, same as MDMX */
-    OPC_MSA      = OPC_MDMX,
     /* Cache and prefetch */
     OPC_CACHE    = (0x2F << 26),
     OPC_PREF     = (0x33 << 26),
@@ -28828,20 +28827,6 @@ static bool decode_opc_legacy(CPUMIPSState *env, DisasContext *ctx)
             }
             break;
         }
-        case OPC_BZ_V:
-        case OPC_BNZ_V:
-        case OPC_BZ_B:
-        case OPC_BZ_H:
-        case OPC_BZ_W:
-        case OPC_BZ_D:
-        case OPC_BNZ_B:
-        case OPC_BNZ_H:
-        case OPC_BNZ_W:
-        case OPC_BNZ_D:
-            if (ase_msa_available(env)) {
-                gen_msa_branch(ctx, op1);
-                break;
-            }
         default:
             MIPS_INVAL("cp1");
             gen_reserved_instruction(ctx);
@@ -29023,16 +29008,13 @@ static bool decode_opc_legacy(CPUMIPSState *env, DisasContext *ctx)
             gen_compute_branch(ctx, op, 4, rs, rt, offset, 4);
         }
         break;
-    case OPC_MSA: /* OPC_MDMX */
+    case OPC_MDMX: /* MMI_OPC_LQ */
         if (ctx->insn_flags & INSN_R5900) {
 #if defined(TARGET_MIPS64)
-            gen_mmi_lq(env, ctx);    /* MMI_OPC_LQ */
+            gen_mmi_lq(env, ctx);
 #endif
         } else {
             /* MDMX: Not implemented. */
-            if (ase_msa_available(env)) {
-                gen_msa(ctx);
-            }
         }
         break;
     case OPC_PCREL:
@@ -29065,6 +29047,13 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
         gen_set_label(l1);
     }
 
+    /* Transition to the auto-generated decoder.  */
+
+    /* ISA Extensions */
+    if (ase_msa_available(env) && decode_ase_msa(ctx, ctx->opcode)) {
+        return;
+    }
+
     if (!decode_opc_legacy(env, ctx)) {
         gen_reserved_instruction(ctx);
     }
-- 
2.26.2

