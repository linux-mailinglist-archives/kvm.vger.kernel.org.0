Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1130F2DB6BA
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 23:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730015AbgLOW7N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 17:59:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729847AbgLOW7K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 17:59:10 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDF7C0613D6
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:58:30 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id 6so15406898ejz.5
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0ud89HtdSyuwzqz0NlT4/PCPOyWmeeMuUKVW0RQc4ak=;
        b=R8Q/u6+uWuVnK9aH5rSnyo3uq6CPH9LEzjvDfihNcP/Oqy1TpUAulCP7BgTnEaSu4G
         l+E/Q9AflTdohyTRq2LrpLNOj5c3Hm1PmbOdImn5u8eVBGJXO3zK6L546r9SjcTivbT8
         uNKS3mINCH6gJ6HQPW6Ea37Ma/9B+Hqt/Igf/P9CrljRhNBDFze2k1Fprkj8Q2ZF5STN
         +k9TbVyjUVYNFxPht7VEuoe26q1yTuuiDilT1OX8cJ09eMHdPWQ/viDNbawwCKLMpI81
         p64BZ59K/3DLKJnE8lbAIivgAo3tFU9ftiSOyxTwRyiZTiga5uYW4tcrlhMF0wQrm/MN
         PiXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=0ud89HtdSyuwzqz0NlT4/PCPOyWmeeMuUKVW0RQc4ak=;
        b=Xg2OD5BsfW3u0yqeX1LG3rJToGIe6JuOIEiJCQj5Thwi71xbDs4hZ61VbSaLTyXG5c
         D9Fxlf67zkGDMOwvOIQVxGWPkJJf2RMehbKGXWvGFTywXi5TdkHy5GVGpYupvqRvKHQs
         Wx8bN2aOSPiyVvG4uFI90iHq97kZhJ7Qdy20rdoZA37WUqOcTM3cABB0U/0fgA5aozjO
         DdX3lfLz6FneWrW8K8D2XIlTfJIEA7kOM+tXxMJQAGgTJyMu/bRoRQdCPE34alS4fOv5
         XheXwVX5Qiewq66dkRTHIqjEGUYoLYci5VGPxyY/keNFoDqJbtNoI1N/iUIxpqdrZQtE
         WLVQ==
X-Gm-Message-State: AOAM533yUNWQJ7PRrhdQwU1Y0TTiytizc678FcsPm4Qf6WUW2FW04P0Z
        RrFaK8fCuyz0ryeWaC3Hu14=
X-Google-Smtp-Source: ABdhPJz4LrH39C3yWw1Con4fZAHpZ4vpgToMC4Fn3eXoof1muEPI7fFCR+i/YKfY8AYmXD1Csav6+Q==
X-Received: by 2002:a17:906:4412:: with SMTP id x18mr6572504ejo.301.1608073109258;
        Tue, 15 Dec 2020 14:58:29 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id z96sm19329766ede.81.2020.12.15.14.58.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 14:58:28 -0800 (PST)
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
Subject: [PATCH v2 05/24] target/mips: Simplify msa_reset()
Date:   Tue, 15 Dec 2020 23:57:38 +0100
Message-Id: <20201215225757.764263-6-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201215225757.764263-1-f4bug@amsat.org>
References: <20201215225757.764263-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Call msa_reset() unconditionally, but only reset
the MSA registers if MSA is implemented.

Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/cpu.c          | 5 +----
 target/mips/cpu-defs.c.inc | 4 ++++
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index 1b4c13bc972..77ebd94c655 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -531,10 +531,7 @@ static void mips_cpu_reset(DeviceState *dev)
         env->hflags |= MIPS_HFLAG_M16;
     }
 
-    /* MSA */
-    if (ase_msa_available(env)) {
-        msa_reset(env);
-    }
+    msa_reset(env);
 
     compute_hflags(env);
     restore_fp_status(env);
diff --git a/target/mips/cpu-defs.c.inc b/target/mips/cpu-defs.c.inc
index a788f5a6b6d..bf12e91f715 100644
--- a/target/mips/cpu-defs.c.inc
+++ b/target/mips/cpu-defs.c.inc
@@ -976,6 +976,10 @@ static void mvp_init(CPUMIPSState *env)
 
 static void msa_reset(CPUMIPSState *env)
 {
+    if (!ase_msa_available(env)) {
+        return;
+    }
+
 #ifdef CONFIG_USER_ONLY
     /* MSA access enabled */
     env->CP0_Config5 |= 1 << CP0C5_MSAEn;
-- 
2.26.2

