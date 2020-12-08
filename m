Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C17A2D1F15
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 01:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728747AbgLHAiX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 19:38:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728671AbgLHAiW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 19:38:22 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2EBCC061793
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 16:37:37 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id g20so22221656ejb.1
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 16:37:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QCW46ctbFpbEr1flyhvkcp2iVdNnukjjxtvYS//elDE=;
        b=hRTzVOiwtLffpf/RB7ghUL25ihR0Uvam5D62dW66XbHPy0j5iT/gmx2TYpCtUUV8RV
         /8RnWh30kChkM+V6dKTLQ0SSo1d2seXpsn91guMlLd92p4TSPrFgA+bz/pynqzI2/MeL
         tWYAIuZUZZ5BLUpojkZcT6VBLgt2037KKcNenD6inTqK8dpOTn+z8qdti54qIvEdKEcG
         y/u6tgRwPl28LvACxoLiNg1LN+PAKhGQeyPfKG3+Yoa91TvXsk5Tuu9CXU/HlGiN6FNQ
         P2YOIYFAQRu6Sia4QBJfqia35WObvqtb0c6/+ncGgPrOGfzgvZXmEbDlE1AIQ0UKdEP4
         4kag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=QCW46ctbFpbEr1flyhvkcp2iVdNnukjjxtvYS//elDE=;
        b=Ue68mIqdEq5JUZCnOT7NUmoeDhMv0PwHpDAj6nW6JsI7PAionQTf20oVBLsMFXndUn
         d+mEpJCIxWzgdT+0lfwjQqKFGSrJYvZgNCvG2B45vIr23PxaHzsOi9o9MWCS6QMI9u2x
         fLE6bWOjCGQCwurlepOYAVV7Uu8M9jY1z09zd8kIFeuqj6+4j2cBAAmzBgBKVA6TfOuS
         efV5ROGPSBcCG4cQiKt8Isbb0M7Z1DKYF/xhfnpol/H1+XgiDNTLkqBmc0HNK39huFkg
         Alz24uZQCX4zd6Y/hh/b6k4z3LxwfOx+TYGiAYswkwEZ9P8xFmbHe8gFB49PvDdW0cOT
         H9hg==
X-Gm-Message-State: AOAM533ymqHE3wYrV3sJF+lJYY+Kj+ZTvIMyYtvhUjeSdAmQWSd91Dmx
        3x8BchHWHrCK+rlWr5eSpdI=
X-Google-Smtp-Source: ABdhPJxWDv5KOtm3SwbxMT5bDcGrNzprFe9keLmkkknepOZtlOGbFAoR/ZG9joxns8mGd53tXugD0Q==
X-Received: by 2002:a17:906:17d1:: with SMTP id u17mr21748427eje.229.1607387856511;
        Mon, 07 Dec 2020 16:37:36 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id n16sm15448302edq.62.2020.12.07.16.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 16:37:35 -0800 (PST)
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
Subject: [PATCH 06/17] target/mips: Alias MSA vector registers on FPU scalar registers
Date:   Tue,  8 Dec 2020 01:36:51 +0100
Message-Id: <20201208003702.4088927-7-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201208003702.4088927-1-f4bug@amsat.org>
References: <20201208003702.4088927-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commits 863f264d10f ("add msa_reset(), global msa register") and
cb269f273fd ("fix multiple TCG registers covering same data")
removed the FPU scalar registers and replaced them by aliases to
the MSA vector registers.
While this might be the case for CPU implementing MSA, this makes
QEMU code incoherent for CPU not implementing it. It is simpler
to inverse the logic and alias the MSA vector registers on the
FPU scalar ones.

Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/translate.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/target/mips/translate.c b/target/mips/translate.c
index da0cb98df09..95d07e837c0 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -31561,16 +31561,20 @@ void mips_tcg_init(void)
                                         offsetof(CPUMIPSState,
                                                  active_tc.gpr[i]),
                                         regnames[i]);
-
     for (i = 0; i < 32; i++) {
         int off = offsetof(CPUMIPSState, active_fpu.fpr[i].wr.d[0]);
-        msa_wr_d[i * 2] =
-                tcg_global_mem_new_i64(cpu_env, off, msaregnames[i * 2]);
+
+        fpu_f64[i] = tcg_global_mem_new_i64(cpu_env, off, fregnames[i]);
+    }
+    /* MSA */
+    for (i = 0; i < 32; i++) {
+        int off = offsetof(CPUMIPSState, active_fpu.fpr[i].wr.d[0]);
+
         /*
-         * The scalar floating-point unit (FPU) registers are mapped on
-         * the MSA vector registers.
+         * The MSA vector registers are mapped on the
+         * scalar floating-point unit (FPU) registers.
          */
-        fpu_f64[i] = msa_wr_d[i * 2];
+        msa_wr_d[i * 2] = fpu_f64[i];
         off = offsetof(CPUMIPSState, active_fpu.fpr[i].wr.d[1]);
         msa_wr_d[i * 2 + 1] =
                 tcg_global_mem_new_i64(cpu_env, off, msaregnames[i * 2 + 1]);
-- 
2.26.2

