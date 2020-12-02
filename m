Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E682CC5C6
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 19:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729469AbgLBSpp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 13:45:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729101AbgLBSpp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 13:45:45 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDD7C0613D4
        for <kvm@vger.kernel.org>; Wed,  2 Dec 2020 10:45:02 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id ga15so5961676ejb.4
        for <kvm@vger.kernel.org>; Wed, 02 Dec 2020 10:45:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eHXFXj870qIY4C/nWYXRi/ekP6hdOkoFn16uMxuOt10=;
        b=MOATcFxyWEXuIJOfCzgDGP/eo9oBYc/wwsOhQbE4b+OvOC1874QiVJXWDWt0x/vyop
         LwyMaNRD+fNKQMU3Xf5AN5Zg8HhoXohX2VnCiCWQDU9PepFqNbexMVRi/T2eHJRfnzAp
         ZDRWF6GupuD4xpKe3E8vEqEikkQUg4weSQ7ekH+iegJvqyljIqX6g4XdWFqoJT/b2hdu
         jCn0rg0XJMGotIJXVNGKX8Cgwex9acBzZKaQHQ4SWcEzX93Uhsy0PugTyo8qv8wMy5Cc
         JCUXdmgOtqdXxKJp9wEjIBH7pPoHuGe6sAg3jAyWUwdreWrSSf/YfCRL5mqcrLruZZJq
         TF3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=eHXFXj870qIY4C/nWYXRi/ekP6hdOkoFn16uMxuOt10=;
        b=OgimwbSBPYj1H8DqByc/2GPlSBYxZKir5UIQoILAnoJMKVc41ltJI4cEXMt1tE8Niz
         0MQXCTeGO9rjdL/F8acX7J3wdeF6lhQjBuA1n8G8OcHpLgqDXtAIEJQ4E3RAgK0F9dzV
         uCkr2o0HNJlB0Ae0VJH6DdlM+Wn3ZTfZ39L3ikL24G5GAGQKpMkxgHKskWPOBlS0P2kZ
         ILE1blQ8aXg+bvC2AFdnr/gy1mCNdtcDjXmrccuhl1WbwhzTzJOtT2cpOg6mJeTtQ6iZ
         3+EFwAX7GR9im33QcBDTO8SPweCHxqAfy5MrVQwBS73O4y9uPeik1jV/H73+KehDotQp
         DQRg==
X-Gm-Message-State: AOAM531aw8KEgKbFAfRgqhFIeAxGdrQiSeGN6Hzimo5KP1gn6z+THn0D
        U+91hPVs+BmIMw7wmJ/+Rnw=
X-Google-Smtp-Source: ABdhPJzY357Mkj0Ye7EAR4HvTrZLd8oLHnF74RVnfog/mNjIQhygZUKsA+/cv185VPgcdjEsEiLMBw==
X-Received: by 2002:a17:907:210b:: with SMTP id qn11mr1141345ejb.41.1606934701182;
        Wed, 02 Dec 2020 10:45:01 -0800 (PST)
Received: from x1w.redhat.com (111.red-88-21-205.staticip.rima-tde.net. [88.21.205.111])
        by smtp.gmail.com with ESMTPSA id cb14sm449258ejb.105.2020.12.02.10.44.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 10:45:00 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH 8/9] target/mips: Remove CPUMIPSState* argument from gen_msa*() methods
Date:   Wed,  2 Dec 2020 19:44:14 +0100
Message-Id: <20201202184415.1434484-9-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201202184415.1434484-1-f4bug@amsat.org>
References: <20201202184415.1434484-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The gen_msa*() methods don't use the "CPUMIPSState *env"
argument. Remove it to simplify.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/translate.c | 57 ++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 29 deletions(-)

diff --git a/target/mips/translate.c b/target/mips/translate.c
index a5112acc351..5311e6ced62 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -28744,7 +28744,7 @@ static void gen_check_zero_element(TCGv tresult, uint8_t df, uint8_t wt)
     tcg_temp_free_i64(t1);
 }
 
-static void gen_msa_branch(CPUMIPSState *env, DisasContext *ctx, uint32_t op1)
+static void gen_msa_branch(DisasContext *ctx, uint32_t op1)
 {
     uint8_t df = (ctx->opcode >> 21) & 0x3;
     uint8_t wt = (ctx->opcode >> 16) & 0x1f;
@@ -28789,7 +28789,7 @@ static void gen_msa_branch(CPUMIPSState *env, DisasContext *ctx, uint32_t op1)
     ctx->hflags |= MIPS_HFLAG_BDS32;
 }
 
-static void gen_msa_i8(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_i8(DisasContext *ctx)
 {
 #define MASK_MSA_I8(op)    (MASK_MSA_MINOR(op) | (op & (0x03 << 24)))
     uint8_t i8 = (ctx->opcode >> 16) & 0xff;
@@ -28847,7 +28847,7 @@ static void gen_msa_i8(CPUMIPSState *env, DisasContext *ctx)
     tcg_temp_free_i32(ti8);
 }
 
-static void gen_msa_i5(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_i5(DisasContext *ctx)
 {
 #define MASK_MSA_I5(op)    (MASK_MSA_MINOR(op) | (op & (0x7 << 23)))
     uint8_t df = (ctx->opcode >> 21) & 0x3;
@@ -28920,7 +28920,7 @@ static void gen_msa_i5(CPUMIPSState *env, DisasContext *ctx)
     tcg_temp_free_i32(timm);
 }
 
-static void gen_msa_bit(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_bit(DisasContext *ctx)
 {
 #define MASK_MSA_BIT(op)    (MASK_MSA_MINOR(op) | (op & (0x7 << 23)))
     uint8_t dfm = (ctx->opcode >> 16) & 0x7f;
@@ -29004,7 +29004,7 @@ static void gen_msa_bit(CPUMIPSState *env, DisasContext *ctx)
     tcg_temp_free_i32(tws);
 }
 
-static void gen_msa_3r(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_3r(DisasContext *ctx)
 {
 #define MASK_MSA_3R(op)    (MASK_MSA_MINOR(op) | (op & (0x7 << 23)))
     uint8_t df = (ctx->opcode >> 21) & 0x3;
@@ -29986,7 +29986,7 @@ static void gen_msa_3r(CPUMIPSState *env, DisasContext *ctx)
     tcg_temp_free_i32(tdf);
 }
 
-static void gen_msa_elm_3e(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_elm_3e(DisasContext *ctx)
 {
 #define MASK_MSA_ELM_DF3E(op)   (MASK_MSA_MINOR(op) | (op & (0x3FF << 16)))
     uint8_t source = (ctx->opcode >> 11) & 0x1f;
@@ -30018,8 +30018,7 @@ static void gen_msa_elm_3e(CPUMIPSState *env, DisasContext *ctx)
     tcg_temp_free_i32(tsr);
 }
 
-static void gen_msa_elm_df(CPUMIPSState *env, DisasContext *ctx, uint32_t df,
-        uint32_t n)
+static void gen_msa_elm_df(DisasContext *ctx, uint32_t df, uint32_t n)
 {
 #define MASK_MSA_ELM(op)    (MASK_MSA_MINOR(op) | (op & (0xf << 22)))
     uint8_t ws = (ctx->opcode >> 11) & 0x1f;
@@ -30129,7 +30128,7 @@ static void gen_msa_elm_df(CPUMIPSState *env, DisasContext *ctx, uint32_t df,
     tcg_temp_free_i32(tdf);
 }
 
-static void gen_msa_elm(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_elm(DisasContext *ctx)
 {
     uint8_t dfn = (ctx->opcode >> 16) & 0x3f;
     uint32_t df = 0, n = 0;
@@ -30148,17 +30147,17 @@ static void gen_msa_elm(CPUMIPSState *env, DisasContext *ctx)
         df = DF_DOUBLE;
     } else if (dfn == 0x3E) {
         /* CTCMSA, CFCMSA, MOVE.V */
-        gen_msa_elm_3e(env, ctx);
+        gen_msa_elm_3e(ctx);
         return;
     } else {
         generate_exception_end(ctx, EXCP_RI);
         return;
     }
 
-    gen_msa_elm_df(env, ctx, df, n);
+    gen_msa_elm_df(ctx, df, n);
 }
 
-static void gen_msa_3rf(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_3rf(DisasContext *ctx)
 {
 #define MASK_MSA_3RF(op)    (MASK_MSA_MINOR(op) | (op & (0xf << 22)))
     uint8_t df = (ctx->opcode >> 21) & 0x1;
@@ -30316,7 +30315,7 @@ static void gen_msa_3rf(CPUMIPSState *env, DisasContext *ctx)
     tcg_temp_free_i32(tdf);
 }
 
-static void gen_msa_2r(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_2r(DisasContext *ctx)
 {
 #define MASK_MSA_2R(op)     (MASK_MSA_MINOR(op) | (op & (0x1f << 21)) | \
                             (op & (0x7 << 18)))
@@ -30400,7 +30399,7 @@ static void gen_msa_2r(CPUMIPSState *env, DisasContext *ctx)
     tcg_temp_free_i32(tdf);
 }
 
-static void gen_msa_2rf(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_2rf(DisasContext *ctx)
 {
 #define MASK_MSA_2RF(op)    (MASK_MSA_MINOR(op) | (op & (0x1f << 21)) | \
                             (op & (0xf << 17)))
@@ -30471,7 +30470,7 @@ static void gen_msa_2rf(CPUMIPSState *env, DisasContext *ctx)
     tcg_temp_free_i32(tdf);
 }
 
-static void gen_msa_vec_v(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_vec_v(DisasContext *ctx)
 {
 #define MASK_MSA_VEC(op)    (MASK_MSA_MINOR(op) | (op & (0x1f << 21)))
     uint8_t wt = (ctx->opcode >> 16) & 0x1f;
@@ -30514,7 +30513,7 @@ static void gen_msa_vec_v(CPUMIPSState *env, DisasContext *ctx)
     tcg_temp_free_i32(twt);
 }
 
-static void gen_msa_vec(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_vec(DisasContext *ctx)
 {
     switch (MASK_MSA_VEC(ctx->opcode)) {
     case OPC_AND_V:
@@ -30524,13 +30523,13 @@ static void gen_msa_vec(CPUMIPSState *env, DisasContext *ctx)
     case OPC_BMNZ_V:
     case OPC_BMZ_V:
     case OPC_BSEL_V:
-        gen_msa_vec_v(env, ctx);
+        gen_msa_vec_v(ctx);
         break;
     case OPC_MSA_2R:
-        gen_msa_2r(env, ctx);
+        gen_msa_2r(ctx);
         break;
     case OPC_MSA_2RF:
-        gen_msa_2rf(env, ctx);
+        gen_msa_2rf(ctx);
         break;
     default:
         MIPS_INVAL("MSA instruction");
@@ -30539,7 +30538,7 @@ static void gen_msa_vec(CPUMIPSState *env, DisasContext *ctx)
     }
 }
 
-static void gen_msa(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa(DisasContext *ctx)
 {
     uint32_t opcode = ctx->opcode;
 
@@ -30549,15 +30548,15 @@ static void gen_msa(CPUMIPSState *env, DisasContext *ctx)
     case OPC_MSA_I8_00:
     case OPC_MSA_I8_01:
     case OPC_MSA_I8_02:
-        gen_msa_i8(env, ctx);
+        gen_msa_i8(ctx);
         break;
     case OPC_MSA_I5_06:
     case OPC_MSA_I5_07:
-        gen_msa_i5(env, ctx);
+        gen_msa_i5(ctx);
         break;
     case OPC_MSA_BIT_09:
     case OPC_MSA_BIT_0A:
-        gen_msa_bit(env, ctx);
+        gen_msa_bit(ctx);
         break;
     case OPC_MSA_3R_0D:
     case OPC_MSA_3R_0E:
@@ -30568,18 +30567,18 @@ static void gen_msa(CPUMIPSState *env, DisasContext *ctx)
     case OPC_MSA_3R_13:
     case OPC_MSA_3R_14:
     case OPC_MSA_3R_15:
-        gen_msa_3r(env, ctx);
+        gen_msa_3r(ctx);
         break;
     case OPC_MSA_ELM:
-        gen_msa_elm(env, ctx);
+        gen_msa_elm(ctx);
         break;
     case OPC_MSA_3RF_1A:
     case OPC_MSA_3RF_1B:
     case OPC_MSA_3RF_1C:
-        gen_msa_3rf(env, ctx);
+        gen_msa_3rf(ctx);
         break;
     case OPC_MSA_VEC:
-        gen_msa_vec(env, ctx);
+        gen_msa_vec(ctx);
         break;
     case OPC_LD_B:
     case OPC_LD_H:
@@ -31190,7 +31189,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
         case OPC_BNZ_W:
         case OPC_BNZ_D:
             if (ase_msa_available(env)) {
-                gen_msa_branch(env, ctx, op1);
+                gen_msa_branch(ctx, op1);
                 break;
             }
         default:
@@ -31382,7 +31381,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
         } else {
             /* MDMX: Not implemented. */
             if (ase_msa_available(env)) {
-                gen_msa(env, ctx);
+                gen_msa(ctx);
             }
         }
         break;
-- 
2.26.2

