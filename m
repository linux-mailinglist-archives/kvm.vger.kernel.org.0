Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E792D9061
	for <lists+kvm@lfdr.de>; Sun, 13 Dec 2020 21:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392457AbgLMUVQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Dec 2020 15:21:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390539AbgLMUVQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Dec 2020 15:21:16 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D1AC0617B0
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:20:30 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id g185so13431486wmf.3
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WU7av211Gw3wbADY6XPgoCLNL0Q/6KDqRZlDd72LlCc=;
        b=lg3Plv9yDZIf0oqfQcqIFKuS+fY1twqqoLWJGkP/0s5QmgX9g+AcAhlXe1vIXb4SkU
         u6+sEEol4i03yQAqE9FQXbu+uJeG4jQ718E7L+3h4cgjvP6xQ1yzqV14WzhsvaDrVG0P
         XTMhtyIG1mGkUbiZ7EkPa89KKSkfSi4+ZKW1Capz0GuBJr3TBqqMgLU9DJ5WgV3BQGZ+
         CdCT70G6GNCe49e0Qzn/arC9q/YMgpkeOdC5fZdvpcze8suLyybPK+ZM84FYfw742Tk0
         SrhkkMAjcR233PY95gVChi8+8HwmS3hTg9g4QhMLzpOsJw2UyGpoLsFgG/Ul6Ol8kqE4
         8OqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=WU7av211Gw3wbADY6XPgoCLNL0Q/6KDqRZlDd72LlCc=;
        b=tNN4fLBhtdOWNzbFqI6nNKVYSxzgNDbLMl62o6yGKwqh4izOtehopzqzQRFnwZcyd5
         MEt9eTBs5QQL1DjeEKNzGf2c2cJjNo3ioO89sBJfvWtYKDOu8d75Nh39BXBm+aa2mNpc
         B8pxIIr0QnRO+4xkl0noi53qa3HFBqSOaVQ3E3bOJPVs2Px+6DaIbofeDsLE6O6wjPhQ
         8OtigYVveuY4CdUc6cNWQ7qDHDv5aqf3WTgWQTH62q2sSW5OTVKlkKRi4nwnHH0kWQLm
         kWGoAvaD+Qabn9MYoGGMXxeMF6UM0uRYTJd7Ck9/Oc4KCsuUxqzVMiZCz2Vy4Njes6UN
         A2kQ==
X-Gm-Message-State: AOAM531kLUoCJVAJRcat8aeaaaf3lGKIgLD/nZEXU5EzJtBrQodKlikG
        dTbXv9ewUM9FhcESzR26cj0=
X-Google-Smtp-Source: ABdhPJwGswfU1INeuc5+Xpdh/7IEhKrZYuniVVNcdgaPCtjzp2Ttm7znjOhHTptaP+0DrvPGZdnyxQ==
X-Received: by 2002:a1c:2182:: with SMTP id h124mr24378018wmh.25.1607890828851;
        Sun, 13 Dec 2020 12:20:28 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id 64sm28192537wmd.12.2020.12.13.12.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 12:20:28 -0800 (PST)
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
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PULL 08/26] target/mips: Also display exception names in user-mode
Date:   Sun, 13 Dec 2020 21:19:28 +0100
Message-Id: <20201213201946.236123-9-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201213201946.236123-1-f4bug@amsat.org>
References: <20201213201946.236123-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently MIPS exceptions are displayed as string in system-mode
emulation, but as number in user-mode.
Unify by extracting the current system-mode code as excp_name()
and use that in user-mode.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201119160536.1980329-1-f4bug@amsat.org>
---
 target/mips/helper.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/target/mips/helper.c b/target/mips/helper.c
index 041432489d6..59de58fcbc9 100644
--- a/target/mips/helper.c
+++ b/target/mips/helper.c
@@ -978,6 +978,7 @@ hwaddr cpu_mips_translate_address(CPUMIPSState *env, target_ulong address,
         return physical;
     }
 }
+#endif /* !CONFIG_USER_ONLY */
 
 static const char * const excp_names[EXCP_LAST + 1] = {
     [EXCP_RESET] = "reset",
@@ -1018,7 +1019,14 @@ static const char * const excp_names[EXCP_LAST + 1] = {
     [EXCP_MSADIS] = "MSA disabled",
     [EXCP_MSAFPE] = "MSA floating point",
 };
-#endif
+
+static const char *mips_exception_name(int32_t exception)
+{
+    if (exception < 0 || exception > EXCP_LAST) {
+        return "unknown";
+    }
+    return excp_names[exception];
+}
 
 target_ulong exception_resume_pc(CPUMIPSState *env)
 {
@@ -1091,19 +1099,13 @@ void mips_cpu_do_interrupt(CPUState *cs)
     bool update_badinstr = 0;
     target_ulong offset;
     int cause = -1;
-    const char *name;
 
     if (qemu_loglevel_mask(CPU_LOG_INT)
         && cs->exception_index != EXCP_EXT_INTERRUPT) {
-        if (cs->exception_index < 0 || cs->exception_index > EXCP_LAST) {
-            name = "unknown";
-        } else {
-            name = excp_names[cs->exception_index];
-        }
-
         qemu_log("%s enter: PC " TARGET_FMT_lx " EPC " TARGET_FMT_lx
                  " %s exception\n",
-                 __func__, env->active_tc.PC, env->CP0_EPC, name);
+                 __func__, env->active_tc.PC, env->CP0_EPC,
+                 mips_exception_name(cs->exception_index));
     }
     if (cs->exception_index == EXCP_EXT_INTERRUPT &&
         (env->hflags & MIPS_HFLAG_DM)) {
@@ -1490,8 +1492,9 @@ void QEMU_NORETURN do_raise_exception_err(CPUMIPSState *env,
 {
     CPUState *cs = env_cpu(env);
 
-    qemu_log_mask(CPU_LOG_INT, "%s: %d %d\n",
-                  __func__, exception, error_code);
+    qemu_log_mask(CPU_LOG_INT, "%s: %d (%s) %d\n",
+                  __func__, exception, mips_exception_name(exception),
+                  error_code);
     cs->exception_index = exception;
     env->error_code = error_code;
 
-- 
2.26.2

