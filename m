Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 510222DB6E1
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 00:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730418AbgLOXF1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 18:05:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730422AbgLOW7u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 17:59:50 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F906C061248
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:59:09 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id h16so22814025edt.7
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:59:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TYp1kFF/ZgtqaQVDZQD7fDzIxF3789Kks3naiine5GE=;
        b=YWlPSVWSZefcgqL2OOi4n8nNKyDmAM/Pepw9gPoSE4bCQNU7Tz1a8xMhnOMvaSNhxb
         rP0U59oLP8X+jkyFKYd//GViJfEscsRsvQHDx+qXGosWQTU5GjfVxk6I75ULh73GWgBc
         HlyYvm+66XPg8jaiKHCf1JuuN7Q6R5OR1BTIVl94V97NXTGOeRqBZgQ3LRoZDhDUb2BN
         iPauZaf0aslRCdAuJlf2HRVEv5nOUHfsqvHE45amY7uPwnE1DSI7s8cHNv8eCwWLaqJ2
         kDSNP9MFBrKN8K1ptOH3WkUaRBbEX+vrhjm5wMhn6pQRU1gDbZvB77Xf5NAApfqF+9Dy
         coOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=TYp1kFF/ZgtqaQVDZQD7fDzIxF3789Kks3naiine5GE=;
        b=ikMkxZgLIGeSylICxrvdgF5SIIel7bqCURPHepoYRZPfjn/HGtCaiJYBP03hODAJh4
         7OBNJxxlmyc+U16BryvnGPkOYQkbFOB3GzleTkR0AvwoNCdahfl35JGJ8hELylI5Vk4l
         waKUO+b++oKCpEgXZzeVXm4E0PPTbJqSTfWbFnJ8sdxhSwksBDyTfjAVXFQhg4JiVL17
         Layj7D6YzTq0lm4fxVS0CzbbCdNuRKYMazP23UMrdPAMO42/QkRKJdnW1HivvwQuVE50
         yW3xeqXYmAdeo0o44ZoI0Ek4J017M+dPeTrBB6VDdy8waN4Wdo98fx924Biai0iXWFbn
         3nQA==
X-Gm-Message-State: AOAM530PgaN7y/bn/qo2uNZmxOe8Y9OsrkDUOK22T0Us05eh39Va7x+t
        hXi71wqpB/NUpDTQA6OMnSQ=
X-Google-Smtp-Source: ABdhPJxJK5sIiExhW7Lpjype3ogdUyNqClpfMJ8TWGQC/YZBHN1qZavGmRQMlTo+hmfU5hM6CP5Qrg==
X-Received: by 2002:aa7:c919:: with SMTP id b25mr30495247edt.108.1608073148427;
        Tue, 15 Dec 2020 14:59:08 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id r16sm19543291edp.43.2020.12.15.14.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 14:59:07 -0800 (PST)
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
Subject: [PATCH v2 12/24] target/mips: Explode gen_msa_branch() as gen_msa_BxZ_V/BxZ()
Date:   Tue, 15 Dec 2020 23:57:45 +0100
Message-Id: <20201215225757.764263-13-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201215225757.764263-1-f4bug@amsat.org>
References: <20201215225757.764263-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation of using the decodetree script, explode
gen_msa_branch() as following:

- OPC_BZ_V              -> BxZ_V(EQ)
- OPC_BNZ_V             -> BxZ_V(NE)
- OPC_BZ_[BHWD]         -> BxZ(false)
- OPC_BNZ_[BHWD]        -> BxZ(true)

Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/translate.c | 71 ++++++++++++++++++++++++++++-------------
 1 file changed, 49 insertions(+), 22 deletions(-)

diff --git a/target/mips/translate.c b/target/mips/translate.c
index a3618a3beb2..9be946256b3 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -28615,49 +28615,76 @@ static void gen_check_zero_element(TCGv tresult, uint8_t df, uint8_t wt)
     tcg_temp_free_i64(t1);
 }
 
+static bool gen_msa_BxZ_V(DisasContext *ctx, int wt, int s16, TCGCond cond)
+{
+    TCGv_i64 t0;
+
+    check_msa_access(ctx);
+
+    if (ctx->hflags & MIPS_HFLAG_BMASK) {
+        gen_reserved_instruction(ctx);
+        return true;
+    }
+    t0 = tcg_temp_new_i64();
+    tcg_gen_or_i64(t0, msa_wr_d[wt << 1], msa_wr_d[(wt << 1) + 1]);
+    tcg_gen_setcondi_i64(cond, t0, t0, 0);
+    tcg_gen_trunc_i64_tl(bcond, t0);
+    tcg_temp_free_i64(t0);
+
+    ctx->btarget = ctx->base.pc_next + (s16 << 2) + 4;
+
+    ctx->hflags |= MIPS_HFLAG_BC;
+    ctx->hflags |= MIPS_HFLAG_BDS32;
+
+    return true;
+}
+
+static bool gen_msa_BxZ(DisasContext *ctx, int df, int wt, int s16, bool if_not)
+{
+    check_msa_access(ctx);
+
+    if (ctx->hflags & MIPS_HFLAG_BMASK) {
+        gen_reserved_instruction(ctx);
+        return true;
+    }
+
+    gen_check_zero_element(bcond, df, wt);
+    if (if_not) {
+        tcg_gen_setcondi_tl(TCG_COND_EQ, bcond, bcond, 0);
+    }
+
+    ctx->btarget = ctx->base.pc_next + (s16 << 2) + 4;
+    ctx->hflags |= MIPS_HFLAG_BC;
+    ctx->hflags |= MIPS_HFLAG_BDS32;
+
+    return true;
+}
+
 static void gen_msa_branch(DisasContext *ctx, uint32_t op1)
 {
     uint8_t df = (ctx->opcode >> 21) & 0x3;
     uint8_t wt = (ctx->opcode >> 16) & 0x1f;
     int64_t s16 = (int16_t)ctx->opcode;
 
-    check_msa_access(ctx);
-
-    if (ctx->hflags & MIPS_HFLAG_BMASK) {
-        gen_reserved_instruction(ctx);
-        return;
-    }
     switch (op1) {
     case OPC_BZ_V:
     case OPC_BNZ_V:
-        {
-            TCGv_i64 t0 = tcg_temp_new_i64();
-            tcg_gen_or_i64(t0, msa_wr_d[wt << 1], msa_wr_d[(wt << 1) + 1]);
-            tcg_gen_setcondi_i64((op1 == OPC_BZ_V) ?
-                    TCG_COND_EQ : TCG_COND_NE, t0, t0, 0);
-            tcg_gen_trunc_i64_tl(bcond, t0);
-            tcg_temp_free_i64(t0);
-        }
+        gen_msa_BxZ_V(ctx, wt, s16, (op1 == OPC_BZ_V) ?
+                                    TCG_COND_EQ : TCG_COND_NE);
         break;
     case OPC_BZ_B:
     case OPC_BZ_H:
     case OPC_BZ_W:
     case OPC_BZ_D:
-        gen_check_zero_element(bcond, df, wt);
+        gen_msa_BxZ(ctx, df, wt, s16, false);
         break;
     case OPC_BNZ_B:
     case OPC_BNZ_H:
     case OPC_BNZ_W:
     case OPC_BNZ_D:
-        gen_check_zero_element(bcond, df, wt);
-        tcg_gen_setcondi_tl(TCG_COND_EQ, bcond, bcond, 0);
+        gen_msa_BxZ(ctx, df, wt, s16, true);
         break;
     }
-
-    ctx->btarget = ctx->base.pc_next + (s16 << 2) + 4;
-
-    ctx->hflags |= MIPS_HFLAG_BC;
-    ctx->hflags |= MIPS_HFLAG_BDS32;
 }
 
 static void gen_msa_i8(DisasContext *ctx)
-- 
2.26.2

