Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB0FE2DB6B7
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 23:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729791AbgLOW6z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 17:58:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbgLOW6x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 17:58:53 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8259C061794
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:58:12 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id b9so5108567ejy.0
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:58:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nIvvusNJm60WWqveYR8Cj3EE3xSaf0EEqwOHmNBN40o=;
        b=rE1wg4s+BQFCEk8G4qW/EZvLlvRn6pVxQO3rKh4VPhBKrCVG/5yqEwoiblwqOAVg+s
         1jKsfSERkOnk3qfv8sVj922EN1A+gxv1DwbsZUIgZHOBv+BNMQu+6ohBNFP3RnovvOj9
         zdyVuynSE1umCq28i/rSVXS5jcEkECpHS2kohBMsXcdYTT8lV+AEga+bmJkpBPnSyWEl
         y3VaMmRFsjzHzim7xhbqmXib/rnEdeYVp7dPdzpjnLSgh7ViyON5jFRke9Pf8B1deDuj
         z0dFvMtjfL3QZy1GJxE5hhfYq/jO+10+I6BjV0/xVVDbTYHvVBr90l4FPpqIMxnY9PBn
         5atQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=nIvvusNJm60WWqveYR8Cj3EE3xSaf0EEqwOHmNBN40o=;
        b=B2qMYXlPAZaDSxT5bJje0om4TkgWn1zjY5bvbyIWUtqmQuaAgt5btxTkQ2jQQ4b+4F
         z4nsZZiWq776X9rBzrDa5t3yKaf5uk0P+zGandp7I5ePDIAWHpq4qwtUdwwc6hGX+lnl
         LSfGMo1Mn+XUrj4O/dygy2X3nWv+LyPzxlhLlgOfrDMkgA9QGEWBeEw7+xJ03J9CvXiF
         xp5C4BmtSzWl0ZSaIdv7Fl0d03xvSb+ZseNpRFIYJ7lavBFp0dGUU3tuCEfFbVP8o2HK
         EZLR4vjrq6ah4Ex5UIE8EDrH5RrLzwuml2ADLNy7Oum9LpViDwmfqpJjKIzmyyysqxqF
         ajAA==
X-Gm-Message-State: AOAM532NCicmmlkeYNaYPegOXf9uh6rDopPSiwVnHNrDAE4VkvzG/tdv
        RjzevMeexIOgNq4n5R4Q02a0VGVsg3n9vQ==
X-Google-Smtp-Source: ABdhPJyJfKCLWMingZozHIiLHLT59KgzZqGQr2a+zB0lXaXEIGcuoBun5nXBUlkaB1EB0fOznCztLA==
X-Received: by 2002:a17:906:2c54:: with SMTP id f20mr4559736ejh.318.1608073091601;
        Tue, 15 Dec 2020 14:58:11 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id f20sm8514210edx.92.2020.12.15.14.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 14:58:10 -0800 (PST)
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
Subject: [PATCH v2 02/24] target/mips/translate: Expose check_mips_64() to 32-bit mode
Date:   Tue, 15 Dec 2020 23:57:35 +0100
Message-Id: <20201215225757.764263-3-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201215225757.764263-1-f4bug@amsat.org>
References: <20201215225757.764263-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To allow compiling 64-bit specific translation code more
generically (and removing #ifdef'ry), allow compiling
check_mips_64() on 32-bit targets.
If ever called on 32-bit, we obviously emit a reserved
instruction exception.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/translate.h | 2 --
 target/mips/translate.c | 8 +++-----
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/target/mips/translate.h b/target/mips/translate.h
index a9eab69249f..942d803476c 100644
--- a/target/mips/translate.h
+++ b/target/mips/translate.h
@@ -127,9 +127,7 @@ void generate_exception_err(DisasContext *ctx, int excp, int err);
 void generate_exception_end(DisasContext *ctx, int excp);
 void gen_reserved_instruction(DisasContext *ctx);
 void check_insn(DisasContext *ctx, uint64_t flags);
-#ifdef TARGET_MIPS64
 void check_mips_64(DisasContext *ctx);
-#endif
 void check_cp1_enabled(DisasContext *ctx);
 
 void gen_base_offset_addr(DisasContext *ctx, TCGv addr, int base, int offset);
diff --git a/target/mips/translate.c b/target/mips/translate.c
index 5c62b32c6ae..af543d1f375 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -2972,18 +2972,16 @@ static inline void check_ps(DisasContext *ctx)
     check_cp1_64bitmode(ctx);
 }
 
-#ifdef TARGET_MIPS64
 /*
- * This code generates a "reserved instruction" exception if 64-bit
- * instructions are not enabled.
+ * This code generates a "reserved instruction" exception if cpu is not
+ * 64-bit or 64-bit instructions are not enabled.
  */
 void check_mips_64(DisasContext *ctx)
 {
-    if (unlikely(!(ctx->hflags & MIPS_HFLAG_64))) {
+    if (unlikely((TARGET_LONG_BITS != 64) || !(ctx->hflags & MIPS_HFLAG_64))) {
         gen_reserved_instruction(ctx);
     }
 }
-#endif
 
 #ifndef CONFIG_USER_ONLY
 static inline void check_mvh(DisasContext *ctx)
-- 
2.26.2

