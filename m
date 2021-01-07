Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A53DB2EE88A
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbhAGW0T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbhAGW0S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:26:18 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8E5C0612F6
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:26:03 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id t16so7145514wra.3
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:26:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xMINXm1sTVzeUT3ZE6sRQjEA5ZHRpEpLUaOQgOSkVsQ=;
        b=EHAE3Ol5/HOD8NEgpNC9Z7QLjkfjlPScUCA/+1Ni7Wvc/Ouh8RmBNpTvF44ACC+O94
         ui3rGx1wKxHQQoWQyUnB9heNVZifzrLk54YRq8z3DH4E8rDIK8hHUaSM/Kf04dakP5vJ
         Fd/RQeSsatodFbulCqF6x8TiPphBSmQSoE2oFdRH4mW2S4ao8xDf4CPQc974T0fgAWgw
         KUM9zTusnII0RIHXs5cxNPaR4GTj5lKYOe9TbQos2ZzdL0gfkCVrktIaf+TvwrLhWRw7
         fAdNPsepUBUnfdlphWJmcp2vcwOQupadPCDedEMM2CG1BB56BBZBMIvmFZBdizHwPzJH
         WgPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=xMINXm1sTVzeUT3ZE6sRQjEA5ZHRpEpLUaOQgOSkVsQ=;
        b=Igx3HgWY+QqKTheGOucTF1Agi7TKBBcq0mBAuOrmtPQ3ePDRrVFNmN/s6FxwHoyoTr
         C9DhKJJB8U03tqS5m40Zf5s2E4tL3Kgg2BKbeAaXM0wAFWAoMmxyUfCM4vz3abFObXEJ
         PhzS4Xb7EYyaMTgE6hNICGMljPnhYUBAHM+sxHaI+Sb0SaEBZxY9Hi2zOgj9kdw2TJxZ
         y0wRHZ+NXfU/GnL2x3wSSVA8gv1Sr1DjxAhZH4dPoHc15qn7UxqI/FH1KoZurdoy2BH7
         7I5DjKv6ws4kT6lboo80lElLlnaRm4Mlpb+82HNRHg5KBjXglIXhMmVCiSTJWvvPJmXo
         LGSA==
X-Gm-Message-State: AOAM5317c4iSQ5YiEjqS++SXctGRmNPAIY85iXtO0hKzrNcrZTlAgXaj
        B2cPday4U0E87W3vO0rEZ7Y=
X-Google-Smtp-Source: ABdhPJwjVucGLGwLTP8ZlzahNzVV4CW6S2hcO4HB4SrTqZzAZcO7bXWXd4P/foDdI4h565pPc3KKDw==
X-Received: by 2002:a5d:60c1:: with SMTP id x1mr660228wrt.271.1610058362338;
        Thu, 07 Jan 2021 14:26:02 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id i9sm10795243wrs.70.2021.01.07.14.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:26:01 -0800 (PST)
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
        Paul Burton <paulburton@kernel.org>
Subject: [PULL 36/66] target/mips/translate: Expose check_mips_64() to 32-bit mode
Date:   Thu,  7 Jan 2021 23:22:23 +0100
Message-Id: <20210107222253.20382-37-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
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
Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-Id: <20201215225757.764263-3-f4bug@amsat.org>
---
 target/mips/translate.h | 2 --
 target/mips/translate.c | 8 +++-----
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/target/mips/translate.h b/target/mips/translate.h
index c70bca998fb..402bc5e8846 100644
--- a/target/mips/translate.h
+++ b/target/mips/translate.h
@@ -128,9 +128,7 @@ void generate_exception_err(DisasContext *ctx, int excp, int err);
 void generate_exception_end(DisasContext *ctx, int excp);
 void gen_reserved_instruction(DisasContext *ctx);
 void check_insn(DisasContext *ctx, uint64_t flags);
-#ifdef TARGET_MIPS64
 void check_mips_64(DisasContext *ctx);
-#endif
 void check_cp1_enabled(DisasContext *ctx);
 
 void gen_base_offset_addr(DisasContext *ctx, TCGv addr, int base, int offset);
diff --git a/target/mips/translate.c b/target/mips/translate.c
index 7d2120dd51c..69fa8a50790 100644
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

