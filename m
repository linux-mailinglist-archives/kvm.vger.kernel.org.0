Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 824642DB6D3
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 00:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730672AbgLOXBQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 18:01:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730655AbgLOXA4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 18:00:56 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC69C061793
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 15:00:16 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id b9so5113794ejy.0
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 15:00:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DTZIrFlHcNm9YcGLkUm/8b5t2eShtDyueJmi4bfarso=;
        b=o/Lg9AW6RsdSbatw9ZvZiaqGAphftza4xV+qx2aTN7AIRuAThHpFz8i03HC30uKif4
         k09ZCCY9ml9P9upy+m6AILYY/L92yYpHq6eo071QIX5MR2XFCcw1tpcKSFq0Beh5kBFZ
         eKuGpJf3YtIbB+EBHr94w4ud4pJuvCmbR5HK2mjoL1KsceIV2cYIwLjkL4P2WdxN7xH1
         7df04zElquESuERW5RwQxmyaw6EG/LLy+y0CDF2GlnYq4Rkd2jxAIN8Ee/ajZh/6bxN2
         gRZNrILg4ZZK8S//9V52n0Ty1QvOpXo2VFq6XbSTeEgotNf9yw3JM8JO37yUKdAdf80o
         muow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=DTZIrFlHcNm9YcGLkUm/8b5t2eShtDyueJmi4bfarso=;
        b=uWZvDxRMfjJN/a6RH3TEFBpO5jIrNE80FN6AV3neVjPhkSUPII2kAHmZrRHdBMYm3y
         lnQtqAMBDA+FbeCWShShBvSHMGo/Zt0oFXv6Wn+0bLDwWM+vufjipdmFvoXskIFG5f4v
         o6Wff9XOmzz5cYDzWl6PZ1q7IP7iniYBRQkH9+AbPCe4fMIraJB6puYHjHDVJTQNkuSX
         LxB6LfYh1VP4KehwUoVM77gP7lNeRwNop0rLdr6JeTBlcBx2fU+wue++MzSvjdmBzZ+E
         MhFxPkQ1mRkQ/4B3EDTPTZgGYceI4GdtOQOG+/8SrSGt1sk/mWeqTwityfXjsUFL06U9
         30Fg==
X-Gm-Message-State: AOAM533OIojf98xFlbNbb5iyeYCY/UgTJLSfHiYs1HWdYIZ0x6Iz6O2c
        1ADAhjyXFor1S2MDuHVy1HufmzY1Uc5N1g==
X-Google-Smtp-Source: ABdhPJwwyM69vtNujuLHaxpzJ3Xo4kw4/9pTA0EnBDUB6BwcABn54DD4EgmC3yUoZ3BDWepNBGrQAw==
X-Received: by 2002:a17:907:94c6:: with SMTP id dn6mr29085549ejc.13.1608073214898;
        Tue, 15 Dec 2020 15:00:14 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id f11sm20320776edy.59.2020.12.15.15.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 15:00:14 -0800 (PST)
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
Subject: [RFC PATCH v2 24/24] target/mips/mod-msa: Pass TCGCond argument to gen_check_zero_element()
Date:   Tue, 15 Dec 2020 23:57:57 +0100
Message-Id: <20201215225757.764263-25-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201215225757.764263-1-f4bug@amsat.org>
References: <20201215225757.764263-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Simplify gen_check_zero_element() by passing the TCGCond
argument along.

Suggested-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
Maybe this can be named 'msa_translate.c' after all...
---
 target/mips/mod-msa_translate.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/target/mips/mod-msa_translate.c b/target/mips/mod-msa_translate.c
index f139ba784dc..7ad14b19b0c 100644
--- a/target/mips/mod-msa_translate.c
+++ b/target/mips/mod-msa_translate.c
@@ -309,7 +309,8 @@ static inline int check_msa_access(DisasContext *ctx)
     return 1;
 }
 
-static void gen_check_zero_element(TCGv tresult, uint8_t df, uint8_t wt)
+static void gen_check_zero_element(TCGv tresult, uint8_t df, uint8_t wt,
+                                   TCGCond cond)
 {
     /* generates tcg ops to check if any element is 0 */
     /* Note this function only works with MSA_WRLEN = 128 */
@@ -344,7 +345,7 @@ static void gen_check_zero_element(TCGv tresult, uint8_t df, uint8_t wt)
     tcg_gen_or_i64(t0, t0, t1);
     /* if all bits are zero then all elements are not zero */
     /* if some bit is non-zero then some element is zero */
-    tcg_gen_setcondi_i64(TCG_COND_NE, t0, t0, 0);
+    tcg_gen_setcondi_i64(cond, t0, t0, 0);
     tcg_gen_trunc_i64_tl(tresult, t0);
     tcg_temp_free_i64(t0);
     tcg_temp_free_i64(t1);
@@ -393,10 +394,7 @@ static bool gen_msa_BxZ(DisasContext *ctx, int df, int wt, int s16, bool if_not)
         return true;
     }
 
-    gen_check_zero_element(bcond, df, wt);
-    if (if_not) {
-        tcg_gen_setcondi_tl(TCG_COND_EQ, bcond, bcond, 0);
-    }
+    gen_check_zero_element(bcond, df, wt, if_not ? TCG_COND_EQ : TCG_COND_NE);
 
     ctx->btarget = ctx->base.pc_next + (s16 << 2) + 4;
     ctx->hflags |= MIPS_HFLAG_BC;
-- 
2.26.2

