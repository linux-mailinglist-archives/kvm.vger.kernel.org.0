Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3FCE2D905F
	for <lists+kvm@lfdr.de>; Sun, 13 Dec 2020 21:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391069AbgLMUVL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Dec 2020 15:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbgLMUVL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Dec 2020 15:21:11 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299E6C06179C
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:20:15 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id e25so13417256wme.0
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:20:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2ISNCVzJYbaoq1vI61by2IBAkaqbdNie7OHgVDeXnbA=;
        b=QnkMcMiqG8UVyDMMuGRox71t7T+UqZBUKvKswBUB2KOeED01VBfl1gTqc5svpwe1CC
         rgudl0VE4QS0bigb8esLT9df+NjBOsWyrZfVj+qQPS449oSmXo9w2OybNxuwdEVbGcnf
         9OZMrO0pd1dU/wYb+ybwrpJ0agz5ct4pj1VARipaQZi2eWaE2lDbgFBkJv4TXxPQ73ds
         n3sXcx4L7PddPgiwLLwSksoL8J28lLeRaYWBl/pcU7PRnZTDyVwPmI//BYk9vZdt7FsQ
         HwBqSaqbkszXuQTYtepR5kp0AgKMRup1qCrXkbc0/S+7Kkax0P9mPw/pOaLd5c2R2Ccw
         wprA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=2ISNCVzJYbaoq1vI61by2IBAkaqbdNie7OHgVDeXnbA=;
        b=q0j42VthGUdggprPYjMpqc0lG4aDrVhQeHP/FbEq+g6uLs22q4q/e7CD83LY93YdWO
         2BeHZHfesxhJBTlqrM57z6a89YgjhAl89INgABQ4qOdvHpLiKetVV1peZQGdldSzq/kK
         1S3CP/JtyjTAdYXsUrLgewjzZVGVeFgFLI7+eqCCbAmy+AkWtqMzxVhm6BCIR1+zVdSr
         nxqD2xi8Evd0JpYDVZ/Gn1VZZ6HExLhChF7PUhmBQYNtpF02pGkpBoLqG7K9YvK88j4n
         uYDDfIZLtBeb2XAbThTfekmxS8Y8ImV5xGVc61ODyNe7H9ktibLt/rxFQ9lpf9B3+x+6
         Ep+w==
X-Gm-Message-State: AOAM533s48Hp0fljAHawiY072ifxaS3bmi8GAQ1KDnznCH+gUdSn8jv8
        1RF2yfoU3Q/8I+6l0ji/LzM=
X-Google-Smtp-Source: ABdhPJw2ev9B7VvAvmY2StzAj4Kxo6/UL0BE2A2EbJKABhbhMiX+nTwfhVj5Xh5TwXp8OPQeLmPEsw==
X-Received: by 2002:a1c:2b46:: with SMTP id r67mr24316116wmr.162.1607890813972;
        Sun, 13 Dec 2020 12:20:13 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id l8sm20448668wrb.73.2020.12.13.12.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 12:20:13 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Paul Burton <paulburton@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PULL 05/26] target/mips: Replace magic values by CP0PM_MASK or TARGET_PAGE_BITS_MIN
Date:   Sun, 13 Dec 2020 21:19:25 +0100
Message-Id: <20201213201946.236123-6-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201213201946.236123-1-f4bug@amsat.org>
References: <20201213201946.236123-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace magic values related to page size:

  12 -> TARGET_PAGE_BITS_MIN
  13 -> CP0PM_MASK

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Huacai Chen <chenhc@lemote.com>
Message-Id: <20201109090422.2445166-2-f4bug@amsat.org>
---
 target/mips/cp0_helper.c | 5 +++--
 target/mips/helper.c     | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/target/mips/cp0_helper.c b/target/mips/cp0_helper.c
index a1b5140ccaf..e8b9343ec9c 100644
--- a/target/mips/cp0_helper.c
+++ b/target/mips/cp0_helper.c
@@ -904,7 +904,7 @@ void update_pagemask(CPUMIPSState *env, target_ulong arg1, int32_t *pagemask)
         goto invalid;
     }
     /* We don't support VTLB entry smaller than target page */
-    if ((maskbits + 12) < TARGET_PAGE_BITS) {
+    if ((maskbits + TARGET_PAGE_BITS_MIN) < TARGET_PAGE_BITS) {
         goto invalid;
     }
     env->CP0_PageMask = mask << CP0PM_MASK;
@@ -913,7 +913,8 @@ void update_pagemask(CPUMIPSState *env, target_ulong arg1, int32_t *pagemask)
 
 invalid:
     /* When invalid, set to default target page size. */
-    env->CP0_PageMask = (~TARGET_PAGE_MASK >> 12) << CP0PM_MASK;
+    mask = (~TARGET_PAGE_MASK >> TARGET_PAGE_BITS_MIN);
+    env->CP0_PageMask = mask << CP0PM_MASK;
 }
 
 void helper_mtc0_pagemask(CPUMIPSState *env, target_ulong arg1)
diff --git a/target/mips/helper.c b/target/mips/helper.c
index 063b65c0528..041432489d6 100644
--- a/target/mips/helper.c
+++ b/target/mips/helper.c
@@ -858,8 +858,8 @@ refill:
             break;
         }
     }
-    pw_pagemask = m >> 12;
-    update_pagemask(env, pw_pagemask << 13, &pw_pagemask);
+    pw_pagemask = m >> TARGET_PAGE_BITS_MIN;
+    update_pagemask(env, pw_pagemask << CP0PM_MASK, &pw_pagemask);
     pw_entryhi = (address & ~0x1fff) | (env->CP0_EntryHi & 0xFF);
     {
         target_ulong tmp_entryhi = env->CP0_EntryHi;
-- 
2.26.2

