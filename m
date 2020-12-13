Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37DE72D905E
	for <lists+kvm@lfdr.de>; Sun, 13 Dec 2020 21:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403928AbgLMUVL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Dec 2020 15:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390355AbgLMUVL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Dec 2020 15:21:11 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE63C0617A6
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:20:20 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id r3so14411598wrt.2
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:20:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s6etg05C/BF399R/sCtLPATOdY8AkUS5HEwSvbkWAQM=;
        b=q4Prp5VDpN3rINMABx1tB5qHHGoJp9wExi3jL5uSHNsSREz9xmjlJpKgJLDEI0nRnb
         SEH5OLN2DDe1Uv+sCv4EFmTSzWAr62LWrJUCmGGhw4U/NciSZWU/xewdzor/2AQLvCA2
         VK0sNiuweaJZ/Z66bF/qSabLa+jLFxy1NH9kJDRbtSwQ6/bVEhvBBclWGJhywWlaYLAm
         JA6mpkIMwqyOMXu9EO99W3KGya+i7RL/n9G2A59bifZZmi0I77DgpBuzLC4Inv6wsWwD
         YNzZKn82oQuaYqRuB55jAm80wN4awzHSd0CtpIwZn5en4Re0uwMungEGFH97Axt+iFji
         XXFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=s6etg05C/BF399R/sCtLPATOdY8AkUS5HEwSvbkWAQM=;
        b=Rdo6Zn5Mwue0IHJ0WA1fB0FqghfdFKHhBtawmmmAUVEhAZa0frXVT1upYrIER6/zxO
         z+HS6obYlEcFHhaBtPSjbCaSuHR0lxIN2KHwHlLSfnLj5pvRQwrfRtlJosuOaL1jKMZd
         TPNlohjQuMoSljsVBQKyibcqmM8tEz5nx074Q+z85mOO8v0HlkQDIo2/NPZV27vWMd1n
         bXk0eJ4qv+UdlUo6VV+k3/jpCQkJ64+EZRcP2i7Y+kFm40n2ssV/bKE60yXeDYElJaZ3
         e5PR7tNlNZ7tBpY5hyibVkQIlUiCx6eDr1zFsdINQRTYQ5IBKzbSvz/p7JSs+/Sc7C6Q
         lh3A==
X-Gm-Message-State: AOAM532QrSM3J+RoW1G1wtMl3a+7frRIh8zMnpiAOIoWvfMjE7sAPajT
        X8LKtciBiaRXIQARP1ViJPc=
X-Google-Smtp-Source: ABdhPJyZsyojoo5AMZgAvYJyhWWykvGk9uZc61cVzGwJ7TbpydQtRq7kaBJdz/R8v4Gzu5uT0JKT6A==
X-Received: by 2002:adf:ded1:: with SMTP id i17mr23100083wrn.190.1607890818932;
        Sun, 13 Dec 2020 12:20:18 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id x7sm19488199wmi.11.2020.12.13.12.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 12:20:18 -0800 (PST)
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
Subject: [PULL 06/26] target/mips: Do not include CP0 helpers in user-mode emulation
Date:   Sun, 13 Dec 2020 21:19:26 +0100
Message-Id: <20201213201946.236123-7-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201213201946.236123-1-f4bug@amsat.org>
References: <20201213201946.236123-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CP0 helpers are restricted to system-mode emulation.
Do not intent do build cp0_helper.c in user-mode (this
allows to simplify some #ifdef'ry).

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Huacai Chen <chenhc@lemote.com>
Message-Id: <20201109090422.2445166-3-f4bug@amsat.org>
---
 target/mips/cp0_helper.c | 4 ----
 target/mips/meson.build  | 2 +-
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/target/mips/cp0_helper.c b/target/mips/cp0_helper.c
index e8b9343ec9c..caaaefcc8ad 100644
--- a/target/mips/cp0_helper.c
+++ b/target/mips/cp0_helper.c
@@ -32,7 +32,6 @@
 #include "sysemu/kvm.h"
 
 
-#ifndef CONFIG_USER_ONLY
 /* SMP helpers.  */
 static bool mips_vpe_is_wfi(MIPSCPU *c)
 {
@@ -1667,10 +1666,8 @@ target_ulong helper_evpe(CPUMIPSState *env)
     }
     return prev;
 }
-#endif /* !CONFIG_USER_ONLY */
 
 /* R6 Multi-threading */
-#ifndef CONFIG_USER_ONLY
 target_ulong helper_dvp(CPUMIPSState *env)
 {
     CPUState *other_cs = first_cpu;
@@ -1709,4 +1706,3 @@ target_ulong helper_evp(CPUMIPSState *env)
     }
     return prev;
 }
-#endif /* !CONFIG_USER_ONLY */
diff --git a/target/mips/meson.build b/target/mips/meson.build
index fa1f024e782..681a5524c0e 100644
--- a/target/mips/meson.build
+++ b/target/mips/meson.build
@@ -1,6 +1,5 @@
 mips_ss = ss.source_set()
 mips_ss.add(files(
-  'cp0_helper.c',
   'cpu.c',
   'dsp_helper.c',
   'fpu_helper.c',
@@ -15,6 +14,7 @@
 
 mips_softmmu_ss = ss.source_set()
 mips_softmmu_ss.add(files(
+  'cp0_helper.c',
   'cp0_timer.c',
   'machine.c',
   'mips-semi.c',
-- 
2.26.2

