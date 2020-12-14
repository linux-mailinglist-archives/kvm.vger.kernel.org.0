Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D747B2D9F57
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 19:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408802AbgLNSjp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 13:39:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408537AbgLNSjQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 13:39:16 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88703C061793
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:38:34 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id a11so9707504wrr.13
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:38:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LfYo5MaDY/iw8/2Abe7qf6wWPlyXVqcAmraXknKsAuI=;
        b=cDfL6rFJmoXL5vtpNF/4gnVblMRdchArkhxPQyCm3J2TZeP57Jcvrf5TIbIrVGIUeT
         35nGhFPTcFlGqxFusVNpIQlEjtGgbkvzQIr+L9MnVklUn/V5secx8J6xPA5GHYOY5qna
         nFlJwbfJ51llCxurlCT8mDUQkPXNIBZuW7Qpa4O1304oeGInFXN5/C6MmL5myfYLE4WJ
         mGjVrgqzk0p6Jin1wWS95Wbq7VGZVjmsNQKunn2SmQdefd5mIluNkKGBoEaQOVNJlXY1
         UvxRg5mRSj2T1apqPMkD46FISkHhgdZY2lI54fRnk9jU6IpjeUZ7jCpcgGOq5nO79xbg
         nyag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=LfYo5MaDY/iw8/2Abe7qf6wWPlyXVqcAmraXknKsAuI=;
        b=CL7kEOnsv5pmFmXppSI7L9a4R+AW+4GhOJ5MmTfZCIhhpyNwfUEIbd7KLkPAydAO+T
         Ksjz0jxIoqNUCKHMihDN8N7OEsOjw99Pe5s2t97/sB47xKVklhR+rNzajAhiVSFJKi+7
         WXDjb61tjgED3jiUGfmbRBl3nojifT0DG4jUkC1TaCm7CE6eB8R/VSjHEjnSDsm2j97E
         WMDsvt7c4ZOyOFizhPHbwk1TPTVF8cy6U66f8nD7mH44BngWwzX+7LZX+QgZNjL3LQSZ
         XScau+zWcWYfnGUlfxNujspv47IJ2G4uF95TtotI21KwNZrXSBKhXaQhAuVkVnFxPbo4
         K5/w==
X-Gm-Message-State: AOAM531hG2oxV4X/A8CcwBM9j0YPCvXKqIXXdJPmrICVj9ZCzv8UHQCR
        uA2vDmkwO2Mnne7u4TvF2/Q=
X-Google-Smtp-Source: ABdhPJxPEIZTvdb4fQSO7SAH8bxWAMxU5T9x6Cy3p1ighhXZQ87LEqC4RFNJudb1413UkAGHmoxApA==
X-Received: by 2002:a5d:61c4:: with SMTP id q4mr30479856wrv.304.1607971113318;
        Mon, 14 Dec 2020 10:38:33 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id o7sm16373552wrw.62.2020.12.14.10.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 10:38:32 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v2 10/16] target/mips: Replace gen_exception_err(err=0) by gen_exception_end()
Date:   Mon, 14 Dec 2020 19:37:33 +0100
Message-Id: <20201214183739.500368-11-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201214183739.500368-1-f4bug@amsat.org>
References: <20201214183739.500368-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

generate_exception_err(err=0) is simply generate_exception_end().

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/translate.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/target/mips/translate.c b/target/mips/translate.c
index d2614796214..2662cf26fe7 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -2956,7 +2956,7 @@ static inline void gen_move_high32(TCGv ret, TCGv_i64 arg)
 static inline void check_cp0_enabled(DisasContext *ctx)
 {
     if (unlikely(!(ctx->hflags & MIPS_HFLAG_CP0))) {
-        generate_exception_err(ctx, EXCP_CpU, 0);
+        generate_exception_end(ctx, EXCP_CpU);
     }
 }
 
@@ -3162,10 +3162,10 @@ static inline void check_mt(DisasContext *ctx)
 static inline void check_cp0_mt(DisasContext *ctx)
 {
     if (unlikely(!(ctx->hflags & MIPS_HFLAG_CP0))) {
-        generate_exception_err(ctx, EXCP_CpU, 0);
+        generate_exception_end(ctx, EXCP_CpU);
     } else {
         if (unlikely(!(ctx->CP0_Config3 & (1 << CP0C3_MT)))) {
-            generate_exception_err(ctx, EXCP_RI, 0);
+            generate_exception_end(ctx, EXCP_RI);
         }
     }
 }
-- 
2.26.2

