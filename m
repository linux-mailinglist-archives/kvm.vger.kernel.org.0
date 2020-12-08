Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688AC2D1F21
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 01:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbgLHAjR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 19:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728616AbgLHAjQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 19:39:16 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D1D5C06179C
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 16:38:36 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id h16so4460390edt.7
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 16:38:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yhtDu79kLkCSqrQu4hOw+lBuuGt6Ru0GYKXsoZSpo/I=;
        b=E3A+KzHWpFwxE2ZVxAKr94LVEDqj52B826uiFo1WaCCB/6VWFE+udsYXGu3Gjco/G4
         uf5ex+XeSJ0UD2PL8Ma2pWMiwa4ncAr930QT5QTihRkylPQyjPHNxvLeFWuV6yurH/x2
         KaKl543PEwwPgDtpO0ZZtsvB+t33Z4pGYiIQ9W9xlXAwTvqOGvbS9aNHnaYSIx/ox5K1
         rdrHhjoVq4WSIK6u623eLV0M0m36R3ri9vdkFOacZQfXxVV41Ch8+hbDAXyIbHuP8PMm
         Ud9CFsUKGLmrHdBsIMqjUq1qPetViIP8vMmd/QmreebyXIg1HZNdCAkpAU6ElgoTIRMY
         v8yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=yhtDu79kLkCSqrQu4hOw+lBuuGt6Ru0GYKXsoZSpo/I=;
        b=h09eBcAVyO8jO1SV53dWwBVRt+aaErfOVKPRnrdttvPBfBZ+LBVPcdS7CFlcdau8+c
         q/vwW2I2hdR4g2CLs8opfj+j+JP0DLTNh8s8hSf227eEuEF5j65WBqEwF4rqUmR4vOO9
         TW88S3Xi2PuajPJIZTPpxfZ4hLUGIWWcHYiiNktFX4poK+XK5wNwY2usaaNgU1JVmoks
         UcacWJs5GCzCwLKjlb5e6djlBnA7/5x3I60DB0tUydILUNZ+7Hr10EcJFkZiq9rGkJEb
         0wvaR2/HgPce69K4nHVwEzwlROxKh3VBVvcsSRC6hgUnwAJLVZ1wfDcDgetTYTFWLkNA
         N2gA==
X-Gm-Message-State: AOAM531htFTY4Qsy6s0sXk3rdHjdkp3tZdNQ+ZU6OUnyovKW0wH5AGfw
        LAJlt6pdgak1C7pQmbvp1Yg=
X-Google-Smtp-Source: ABdhPJxcQpisrofx2fgZIGzL7itmsuUM7YtMSDh1aO50Iwk09j8weVmNtpVCfwyqPUmbRb2lDRL/gg==
X-Received: by 2002:aa7:d41a:: with SMTP id z26mr22580039edq.267.1607387915136;
        Mon, 07 Dec 2020 16:38:35 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id m7sm14982163eds.73.2020.12.07.16.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 16:38:34 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH 17/17] target/mips: Use decode_msa32() generated from decodetree
Date:   Tue,  8 Dec 2020 01:37:02 +0100
Message-Id: <20201208003702.4088927-18-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201208003702.4088927-1-f4bug@amsat.org>
References: <20201208003702.4088927-1-f4bug@amsat.org>
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
 target/mips/fpu_translate.h     | 10 ----------
 target/mips/translate.h         |  2 --
 target/mips/mod-msa_translate.c | 29 +----------------------------
 target/mips/translate.c         | 31 ++++++++++---------------------
 4 files changed, 11 insertions(+), 61 deletions(-)

diff --git a/target/mips/fpu_translate.h b/target/mips/fpu_translate.h
index f45314d2ec2..58e5e768c99 100644
--- a/target/mips/fpu_translate.h
+++ b/target/mips/fpu_translate.h
@@ -42,8 +42,6 @@ enum {
     OPC_BC1      = (0x08 << 21) | OPC_CP1, /* bc */
     OPC_BC1ANY2  = (0x09 << 21) | OPC_CP1,
     OPC_BC1ANY4  = (0x0A << 21) | OPC_CP1,
-    OPC_BZ_V     = (0x0B << 21) | OPC_CP1,
-    OPC_BNZ_V    = (0x0F << 21) | OPC_CP1,
     OPC_S_FMT    = (FMT_S << 21) | OPC_CP1,
     OPC_D_FMT    = (FMT_D << 21) | OPC_CP1,
     OPC_E_FMT    = (FMT_E << 21) | OPC_CP1,
@@ -53,14 +51,6 @@ enum {
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
diff --git a/target/mips/translate.h b/target/mips/translate.h
index c4fe18d187e..cba28f49753 100644
--- a/target/mips/translate.h
+++ b/target/mips/translate.h
@@ -82,8 +82,6 @@ extern TCGv bcond;
 
 /* MSA */
 void msa_translate_init(void);
-void gen_msa(DisasContext *ctx);
-void gen_msa_branch(DisasContext *ctx, uint32_t op1);
 bool decode_msa32(DisasContext *ctx, uint32_t insn);
 
 #endif
diff --git a/target/mips/mod-msa_translate.c b/target/mips/mod-msa_translate.c
index 02df39c6b6c..7e7fc0644ff 100644
--- a/target/mips/mod-msa_translate.c
+++ b/target/mips/mod-msa_translate.c
@@ -415,33 +415,6 @@ static bool trans_BNZ_x(DisasContext *ctx, arg_msa_bz *a)
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
@@ -2191,7 +2164,7 @@ static void gen_msa_vec(DisasContext *ctx)
     }
 }
 
-void gen_msa(DisasContext *ctx)
+static void gen_msa(DisasContext *ctx)
 {
     uint32_t opcode = ctx->opcode;
 
diff --git a/target/mips/translate.c b/target/mips/translate.c
index 5cd67459304..41c0b59a473 100644
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
@@ -141,8 +142,6 @@ enum {
     OPC_JIALC    = (0x3E << 26),
     /* MDMX ASE specific */
     OPC_MDMX     = (0x1E << 26),
-    /* MSA ASE, same as MDMX */
-    OPC_MSA      = OPC_MDMX,
     /* Cache and prefetch */
     OPC_CACHE    = (0x2F << 26),
     OPC_PREF     = (0x33 << 26),
@@ -28336,6 +28335,13 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
         gen_set_label(l1);
     }
 
+    /* Transition to the auto-generated decoder.  */
+
+    /* ISA Extensions */
+    if (ase_msa_available(env) && decode_msa32(ctx, ctx->opcode)) {
+        return;
+    }
+
     op = MASK_OP_MAJOR(ctx->opcode);
     rs = (ctx->opcode >> 21) & 0x1f;
     rt = (ctx->opcode >> 16) & 0x1f;
@@ -28853,20 +28859,6 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
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
             generate_exception_end(ctx, EXCP_RI);
@@ -29048,16 +29040,13 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
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
-- 
2.26.2

