Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39EF2EE88F
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbhAGW0y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727870AbhAGW0y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:26:54 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C008EC0612F5
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:26:13 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id r7so7119759wrc.5
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:26:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gpgHQHdilrFY/Au0x7qNpr3WUr1jSj6gUqKW5wcmkNw=;
        b=e7okNRHBZtMqgGM6d5VNmV9C7y+TdjUXNAA8R5c9aj9y+IDIowU9RL2Hqz+LPtcyMC
         0L1s7+txvq7SZt9mQT7Kf8+YW0qXTa4X52bjKfCvZD60Y27a+NdtCwqjP5yXe8+OS42o
         D9TOnCzW2D5L00uWnL2WPnta0DxDCKGH4rokFeIkPGhXzAMxPcuh/49gKSrZtqQbpHlB
         MQkAhbqs/NdILIs/1iRc5oMJCsYwRResxCBWCf7YDkxKwdcPJG0wtwpC69Ck8TrbHLWW
         RL/C0tPAI/Uvs/xqHllBw7hhYYPX5czkP22v/7L3/i3p5J/5AfaOAIJuR6ArKuEaN9AY
         fBzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=gpgHQHdilrFY/Au0x7qNpr3WUr1jSj6gUqKW5wcmkNw=;
        b=MOEQEe7nUIx6MXa1YUJ9LqrVA7QbT404IvrXMa0rv+dk06HRK4uH1fW568wo7IpUBh
         A45mUOHBRrHOxhhXzjCeYnX48p3rR89Sog/s4TbT2LyniK9LnXdzG1g+CvJKECLKH62x
         Yb4rWcdCUbi6Sds70mRgX++h5eaBVi7X9KwGCnXoAJJ14611xSGzPaEpTewjUzfOrXcf
         qxTSO+WfOEvliL3n4/9NLP6W0ExnmAWVDGeKE8RfOxpDa/W6MKJUdi0oDGGLeMWPiBW3
         abqL0xLsMr5NFIXeNzH4OOfQ2H0OwYOwbPTDkGRS9rGGoIhgbXU04+VOSkWF1eVr8SPh
         /13w==
X-Gm-Message-State: AOAM533cvMNO9eUVCfNQ0FtIqQvd494fIn0A4gtD2Ku2tZ3no2LrnQ4e
        5BRAI8HJE1R4Tnk4fWUquYk=
X-Google-Smtp-Source: ABdhPJxkJD3JxPHzQTm/T+0q95uHk/ybzsKYtj/FjAirlGxa6q54t6h5V2wZ+EtDdMERaIxkpjsp/w==
X-Received: by 2002:adf:e60f:: with SMTP id p15mr699194wrm.60.1610058372562;
        Thu, 07 Jan 2021 14:26:12 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id r13sm10551180wrt.10.2021.01.07.14.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:26:11 -0800 (PST)
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
Subject: [PULL 38/66] target/mips: Simplify msa_reset()
Date:   Thu,  7 Jan 2021 23:22:25 +0100
Message-Id: <20210107222253.20382-39-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
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
Tested-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-Id: <20201208003702.4088927-3-f4bug@amsat.org>
---
 target/mips/cpu.c          | 5 +----
 target/mips/cpu-defs.c.inc | 4 ++++
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index 45375ebc45c..4c590b90b25 100644
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
index 535d4c0c702..fe0f47aadf8 100644
--- a/target/mips/cpu-defs.c.inc
+++ b/target/mips/cpu-defs.c.inc
@@ -978,6 +978,10 @@ static void mvp_init(CPUMIPSState *env)
 
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

