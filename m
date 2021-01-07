Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E318A2EE891
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbhAGW1F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727612AbhAGW1E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:27:04 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4921DC0612F4
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:26:49 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id c5so7110011wrp.6
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:26:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TAJNbn2BbAaev8vAtWe0g+lbpxYHDjLc2DhiH9wBBYA=;
        b=IsMM9sYb0osTtqOwV004HCtHqwZnJxLCcuymKn9d10Y/qUNr3dAt4sq75d2rtatyxq
         SpRmcetokXI/DabI/Lv/fXnemrR90gVFbIFnKNlkPKB967/tP5eorFZqWsEtv90QfJv5
         faQSMDf94aZqRWv3lyXg/mrokK7Wp0Ehi1M44XI5mu9Hb0IYbPK7iOeaiSr3qP4AgPGp
         jXYhX+sjuRF/d4nD3L2Xmp4oLhiiDc6adBDC8dutI2wnMvNtNirUfVq5nXBmOBbOofrA
         CC/L/yjO9srhl8WB4Ya0fEpAAYv7hIt7oelLhrQbeZyjLwA15RRNnlD8a1gjnYqw2EmX
         OcIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=TAJNbn2BbAaev8vAtWe0g+lbpxYHDjLc2DhiH9wBBYA=;
        b=ea814CXDtcf9kudn40mBxeTJOJl8NaNUqqWvmGb4dMR8qSHFTQYtueS2RmzNsLwR9F
         A2FApHDqY4E9LqMX9r7p1O6/yFounPjv6W5LnscA6yTlK2VLBaF/pk39VFSFPF6WGSs1
         0mCOGaOKWrsDcbOB9XE8pkSRXvOrqp9OA/ZPnuZnzNpI4QTuisu/j5MmWEhWsQD+CWqV
         4MXP2qBtOTLfQESK2ZV7iwRPF8faq3qJ79ADDnH7fTjDltag6q1jmFFQ/HX/kerpsOpV
         5wUfcvAlgZpTBzyhfuF+7f7nIheHZqFB/LQ1pf2DfyTqXxc3OGpc+1Gkz+yXfoiYxqUr
         neOg==
X-Gm-Message-State: AOAM5335pH5NqXYkNv4BkdA/oRn++tgCFTDaItGiEjIRFC7XiAzXYUDi
        scox6M6az5UrJcJ1fgSGOSQ=
X-Google-Smtp-Source: ABdhPJwY0HPV3lgS9e/0aRYZQN/VGQFKpVtCKmCbNNmLnINx/LTY348Lja+Zhea7D8VbG8YD+FdgUQ==
X-Received: by 2002:adf:a1d5:: with SMTP id v21mr703246wrv.24.1610058408097;
        Thu, 07 Jan 2021 14:26:48 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id h3sm9681113wmm.4.2021.01.07.14.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:26:47 -0800 (PST)
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
Subject: [PULL 45/66] target/mips: Explode gen_msa_branch() as gen_msa_BxZ_V/BxZ()
Date:   Thu,  7 Jan 2021 23:22:32 +0100
Message-Id: <20210107222253.20382-46-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
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
Tested-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-Id: <20201208003702.4088927-10-f4bug@amsat.org>
---
 target/mips/translate.c | 71 ++++++++++++++++++++++++++++-------------
 1 file changed, 49 insertions(+), 22 deletions(-)

diff --git a/target/mips/translate.c b/target/mips/translate.c
index 18cebe26bde..0e7b2abe8bb 100644
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

