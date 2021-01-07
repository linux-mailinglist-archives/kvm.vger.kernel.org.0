Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 856D42EE896
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbhAGW1Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728557AbhAGW1Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:27:24 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C202C0612F6
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:26:44 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id 91so7129507wrj.7
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GAlr7Yg/YIz2ixZWT9Zck2hMBMZxfl4QxyfdbZb/wG0=;
        b=venv5W1SAsWKHVjKxQPTmD+f6/a4y/EYx28lbIMPpVglRkO02f769bxrRK79Gthmt4
         71Ql/HjA/jh6zJ8anUCfSfBPU5N3OThIBFMW00opxF9tKmBnRdQqyie3319sSNYgm2Dt
         D5sAdYUabWVz7/SJBhD8fk4QSEkoNrJY50WQ3dDZ2K+n057YjHdURGi4GHQnjH+I+GF3
         RqSF56R2o2bYenDufE39JZ/lReuXM6BkKDZwVv3+Sbe09+pBkQKbmJOUu6bsy0W2Kmbo
         fSPB9ZbUcWFQ3KKnbYY/b3hyIhEk3lhxPXRSLDTryaG6rkfMcnS0HITzLsiGVZ1J6Jxc
         x2qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=GAlr7Yg/YIz2ixZWT9Zck2hMBMZxfl4QxyfdbZb/wG0=;
        b=LDuMmuLtvTPUPZy+q+TyaDtxCH8JfEtKmJmhg2mcNCuyUFzlerk2TKvIezIwAaH/2d
         Fg8AGroNA6ASEg189d/u9FV6XKf5tF336EbtdgplwjpSCFoH04Gc33kiPBO54PYZWfoN
         0RbZK3R4ctCbpi97LdD8BnhVhntgC9vZD42u7Pyp85h9Y8mI04EY0xUsCcX4/qY1IgxQ
         zSERXGAO5NhnrP2Ns6eSZ4AGVADFBX14gDEG/3fwmpGPGmP3SgtEbFh+FFw+wOy1FZ8Y
         RgGU7eeGqL6fcyK6929K6ZyDa86GQqL6EgPoJaEI+0TiOjkygqHQXjLje9SmrlM4LMot
         HOow==
X-Gm-Message-State: AOAM531utk5EP4eQ/8E2FAv3MX3l3z6JocqS69RBhQ6x5mDbl1smiz2k
        i4PyUUtd1rqAnhJetwR6Qw4=
X-Google-Smtp-Source: ABdhPJzrxFZaLRADmPQ4Oo3Bc9rK/itUQ3lN9+wjKyg+kQQcuWXlyTAXIVVmCwkC3yrOm0yPGUVDDQ==
X-Received: by 2002:adf:ec8c:: with SMTP id z12mr687401wrn.208.1610058403161;
        Thu, 07 Jan 2021 14:26:43 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id a13sm10120831wrt.96.2021.01.07.14.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:26:42 -0800 (PST)
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
Subject: [PULL 44/66] target/mips: Remove CPUMIPSState* argument from gen_msa*() methods
Date:   Thu,  7 Jan 2021 23:22:31 +0100
Message-Id: <20210107222253.20382-45-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The gen_msa*() methods don't use the "CPUMIPSState *env"
argument. Remove it to simplify.

Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Tested-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-Id: <20201208003702.4088927-9-f4bug@amsat.org>
---
 target/mips/translate.c | 57 ++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 29 deletions(-)

diff --git a/target/mips/translate.c b/target/mips/translate.c
index bb9420b9f7f..18cebe26bde 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -28615,7 +28615,7 @@ static void gen_check_zero_element(TCGv tresult, uint8_t df, uint8_t wt)
     tcg_temp_free_i64(t1);
 }
 
-static void gen_msa_branch(CPUMIPSState *env, DisasContext *ctx, uint32_t op1)
+static void gen_msa_branch(DisasContext *ctx, uint32_t op1)
 {
     uint8_t df = (ctx->opcode >> 21) & 0x3;
     uint8_t wt = (ctx->opcode >> 16) & 0x1f;
@@ -28660,7 +28660,7 @@ static void gen_msa_branch(CPUMIPSState *env, DisasContext *ctx, uint32_t op1)
     ctx->hflags |= MIPS_HFLAG_BDS32;
 }
 
-static void gen_msa_i8(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_i8(DisasContext *ctx)
 {
 #define MASK_MSA_I8(op)    (MASK_MSA_MINOR(op) | (op & (0x03 << 24)))
     uint8_t i8 = (ctx->opcode >> 16) & 0xff;
@@ -28718,7 +28718,7 @@ static void gen_msa_i8(CPUMIPSState *env, DisasContext *ctx)
     tcg_temp_free_i32(ti8);
 }
 
-static void gen_msa_i5(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_i5(DisasContext *ctx)
 {
 #define MASK_MSA_I5(op)    (MASK_MSA_MINOR(op) | (op & (0x7 << 23)))
     uint8_t df = (ctx->opcode >> 21) & 0x3;
@@ -28791,7 +28791,7 @@ static void gen_msa_i5(CPUMIPSState *env, DisasContext *ctx)
     tcg_temp_free_i32(timm);
 }
 
-static void gen_msa_bit(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_bit(DisasContext *ctx)
 {
 #define MASK_MSA_BIT(op)    (MASK_MSA_MINOR(op) | (op & (0x7 << 23)))
     uint8_t dfm = (ctx->opcode >> 16) & 0x7f;
@@ -28875,7 +28875,7 @@ static void gen_msa_bit(CPUMIPSState *env, DisasContext *ctx)
     tcg_temp_free_i32(tws);
 }
 
-static void gen_msa_3r(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_3r(DisasContext *ctx)
 {
 #define MASK_MSA_3R(op)    (MASK_MSA_MINOR(op) | (op & (0x7 << 23)))
     uint8_t df = (ctx->opcode >> 21) & 0x3;
@@ -29857,7 +29857,7 @@ static void gen_msa_3r(CPUMIPSState *env, DisasContext *ctx)
     tcg_temp_free_i32(tdf);
 }
 
-static void gen_msa_elm_3e(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_elm_3e(DisasContext *ctx)
 {
 #define MASK_MSA_ELM_DF3E(op)   (MASK_MSA_MINOR(op) | (op & (0x3FF << 16)))
     uint8_t source = (ctx->opcode >> 11) & 0x1f;
@@ -29889,8 +29889,7 @@ static void gen_msa_elm_3e(CPUMIPSState *env, DisasContext *ctx)
     tcg_temp_free_i32(tsr);
 }
 
-static void gen_msa_elm_df(CPUMIPSState *env, DisasContext *ctx, uint32_t df,
-        uint32_t n)
+static void gen_msa_elm_df(DisasContext *ctx, uint32_t df, uint32_t n)
 {
 #define MASK_MSA_ELM(op)    (MASK_MSA_MINOR(op) | (op & (0xf << 22)))
     uint8_t ws = (ctx->opcode >> 11) & 0x1f;
@@ -30000,7 +29999,7 @@ static void gen_msa_elm_df(CPUMIPSState *env, DisasContext *ctx, uint32_t df,
     tcg_temp_free_i32(tdf);
 }
 
-static void gen_msa_elm(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_elm(DisasContext *ctx)
 {
     uint8_t dfn = (ctx->opcode >> 16) & 0x3f;
     uint32_t df = 0, n = 0;
@@ -30019,17 +30018,17 @@ static void gen_msa_elm(CPUMIPSState *env, DisasContext *ctx)
         df = DF_DOUBLE;
     } else if (dfn == 0x3E) {
         /* CTCMSA, CFCMSA, MOVE.V */
-        gen_msa_elm_3e(env, ctx);
+        gen_msa_elm_3e(ctx);
         return;
     } else {
         gen_reserved_instruction(ctx);
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
@@ -30187,7 +30186,7 @@ static void gen_msa_3rf(CPUMIPSState *env, DisasContext *ctx)
     tcg_temp_free_i32(tdf);
 }
 
-static void gen_msa_2r(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_2r(DisasContext *ctx)
 {
 #define MASK_MSA_2R(op)     (MASK_MSA_MINOR(op) | (op & (0x1f << 21)) | \
                             (op & (0x7 << 18)))
@@ -30271,7 +30270,7 @@ static void gen_msa_2r(CPUMIPSState *env, DisasContext *ctx)
     tcg_temp_free_i32(tdf);
 }
 
-static void gen_msa_2rf(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_2rf(DisasContext *ctx)
 {
 #define MASK_MSA_2RF(op)    (MASK_MSA_MINOR(op) | (op & (0x1f << 21)) | \
                             (op & (0xf << 17)))
@@ -30342,7 +30341,7 @@ static void gen_msa_2rf(CPUMIPSState *env, DisasContext *ctx)
     tcg_temp_free_i32(tdf);
 }
 
-static void gen_msa_vec_v(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_vec_v(DisasContext *ctx)
 {
 #define MASK_MSA_VEC(op)    (MASK_MSA_MINOR(op) | (op & (0x1f << 21)))
     uint8_t wt = (ctx->opcode >> 16) & 0x1f;
@@ -30385,7 +30384,7 @@ static void gen_msa_vec_v(CPUMIPSState *env, DisasContext *ctx)
     tcg_temp_free_i32(twt);
 }
 
-static void gen_msa_vec(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_vec(DisasContext *ctx)
 {
     switch (MASK_MSA_VEC(ctx->opcode)) {
     case OPC_AND_V:
@@ -30395,13 +30394,13 @@ static void gen_msa_vec(CPUMIPSState *env, DisasContext *ctx)
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
@@ -30410,7 +30409,7 @@ static void gen_msa_vec(CPUMIPSState *env, DisasContext *ctx)
     }
 }
 
-static void gen_msa(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa(DisasContext *ctx)
 {
     uint32_t opcode = ctx->opcode;
 
@@ -30420,15 +30419,15 @@ static void gen_msa(CPUMIPSState *env, DisasContext *ctx)
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
@@ -30439,18 +30438,18 @@ static void gen_msa(CPUMIPSState *env, DisasContext *ctx)
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
@@ -31044,7 +31043,7 @@ static bool decode_opc_legacy(CPUMIPSState *env, DisasContext *ctx)
         case OPC_BNZ_W:
         case OPC_BNZ_D:
             if (ase_msa_available(env)) {
-                gen_msa_branch(env, ctx, op1);
+                gen_msa_branch(ctx, op1);
                 break;
             }
             /* fall through */
@@ -31237,7 +31236,7 @@ static bool decode_opc_legacy(CPUMIPSState *env, DisasContext *ctx)
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

