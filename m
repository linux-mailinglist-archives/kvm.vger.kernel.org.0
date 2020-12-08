Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08EAC2D1F17
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 01:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbgLHAie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 19:38:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728671AbgLHAid (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 19:38:33 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A10EC0617B0
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 16:37:53 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id v22so15756553edt.9
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 16:37:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gl3oMtrsjL7vz0QKd+8xonphrNOt4bBvJxiMSG7akXM=;
        b=TboVAIByVJ0GTYoCjsgx5sycGwMrDlzcODXfxx1jMXGpIEg7kX1aPCXixeLGMNqjaR
         puKTh4wbzUu/gqFvY/4rcxYBjySKkPB0MGqZwlvXfxZnVGftqffvLmN7w/SfZVbdZ23R
         DOxLb+qCErNCmK9sqvX/A7G0rvAqHt7M0W4MVaa38YZQ/SxKtS1fHS16h2VAMSNCNY31
         DISAu86VbeTJ43Y8lHB1f9AAFf484N1mo04dEbdE6bXg8ZgveyUX1ydm7etkp4JAhnVq
         hOpGSVLSk08rDviDLLixC6eZ1kzzB6+U0t8G60DvfOMAUJTXN6RFgbwPbs1qkjJe7IHl
         00lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=gl3oMtrsjL7vz0QKd+8xonphrNOt4bBvJxiMSG7akXM=;
        b=TORz1gyS+WjFMKJXz9LLQS7qEKFjKhGPG8X3GFIff/pNZuHH/mqYGMf8+zZGrKo0L4
         xt1vUSDuMk9KkZSwH/3CtTZNjmr+evtzfyCXqN5mPP8lAduFgXFrMy9R58wIQj8OpWbe
         PIkvuXefH+xu9f8VrPJ4D1sngGDI9a28Wfc6z7yTvGtChvpjs2P7i5RLNoKf+8LtK2YJ
         X8hbxa5XuB9bcHc99PMuYFqBiNAJRMVw+dkk2popnbPIJG62CXV/vTLaGX9TiFsRXJZe
         FoOK7BaZmK1R1qJfAzYf1gudMD/cA6SQxWb155vgtmKtf9hKYpEeLOE7lFqSU5sU3BdL
         RihA==
X-Gm-Message-State: AOAM530MhKK2Xk2TopPpnEsQuX4+uhOuHUVB3oOG5aFaA5t70y/KdhNV
        uZRCzqR2hi91DPWFRkGSSZc=
X-Google-Smtp-Source: ABdhPJwM6x9jMd5CtJnJOHif2O47Du+oSBsYQ3wmjaIQ/FnVd6OQJzrokqJhB1bpwUJff2IimmxMqw==
X-Received: by 2002:a05:6402:411:: with SMTP id q17mr22633700edv.125.1607387872222;
        Mon, 07 Dec 2020 16:37:52 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id x15sm15115763edj.91.2020.12.07.16.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 16:37:51 -0800 (PST)
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
Subject: [PATCH 09/17] target/mips: Explode gen_msa_branch() as gen_msa_BxZ_V/BxZ()
Date:   Tue,  8 Dec 2020 01:36:54 +0100
Message-Id: <20201208003702.4088927-10-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201208003702.4088927-1-f4bug@amsat.org>
References: <20201208003702.4088927-1-f4bug@amsat.org>
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
index 5ed7072f275..8b1019506fe 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -28623,49 +28623,76 @@ static void gen_check_zero_element(TCGv tresult, uint8_t df, uint8_t wt)
     tcg_temp_free_i64(t1);
 }
 
+static bool gen_msa_BxZ_V(DisasContext *ctx, int wt, int s16, TCGCond cond)
+{
+    TCGv_i64 t0;
+
+    check_msa_access(ctx);
+
+    if (ctx->hflags & MIPS_HFLAG_BMASK) {
+        generate_exception_end(ctx, EXCP_RI);
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
+        generate_exception_end(ctx, EXCP_RI);
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
-        generate_exception_end(ctx, EXCP_RI);
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

