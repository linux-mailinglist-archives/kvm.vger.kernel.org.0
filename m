Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9612EE87A
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbhAGWZR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727624AbhAGWZQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:25:16 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E318C0612FC
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:24:36 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id c5so7105998wrp.6
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:24:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LDza1xPJHLgPcRTP3LkN+2X1iZhd2c06drajcL8+MJU=;
        b=u7McaY5ZOFPgSgui9Y82tO0QSZuNWvAtKwv1fJAJ3BzvICR2REIrXHvhezyAD/caAz
         awSqgWTLvWnOY8zw7Zz5gwtrvPeui0P1VAGCO+zvYPy8gOB2LkZSvhA9QEjmD6Li4N3E
         Usp9xMHF6tCUriJroaGarSi1mjk7Do+jmXyStVih6KykFVMqRI5FC952hSS+NogEdmTm
         lqiFpzt6RpUuKryqezm4mHFD+Oz4zx9F789e4ZLEeK9xrd7d47Xmp0ngdC+DHZwyLAgi
         DQog/Xll9uXaPNxKyPjXJRqa+uD9dHCSiMZhViGvI+ZIyCz0N6AXP/laxVpNCuB2Uc8F
         Czhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=LDza1xPJHLgPcRTP3LkN+2X1iZhd2c06drajcL8+MJU=;
        b=t1uA4ziOBt5uhInUg/+LZE/GLc9kuP8M20ombs4nFnK/MsAlTaJv0WE0ODLbkwyssP
         WcMBEoRmcy//OcZ/cdpEs3ywIomfk8cfKisz6IO/YGzsZslMyX7d/PNIJvpn2Rg6gvlK
         aLVvbh0Pp4sP/oxMrL98vWt8PXWYzeCar0/Oi7sdQlzkgwgEXNQtSh+Q9zPanh111g89
         1nGcgaR2+4ne0D3e7T0Fcz8hMHgSKeP0PiSCysVGpVAGBWklhP2uq6VzLRWM5Do32NRy
         F7xJB6YBmOCDxRe1TyPd/necmsF40QMEqfZMwl5GBZHNyZBy8JP0PoLcMaTOypSr7d9n
         hJPg==
X-Gm-Message-State: AOAM532ZYUFG9EriI0no2NUeHLl+XuMcexRZUSy1G+2cB3bYZs2TGDlq
        24zCnglztRk5t3CM+ysnZp0=
X-Google-Smtp-Source: ABdhPJzZbJj2jP0coNCZGst8B6hah0/bCVtvfFQLvcALnm39BBi1/wYWYtIpo/dUiEchSaYAkdfcWw==
X-Received: by 2002:adf:e406:: with SMTP id g6mr657530wrm.255.1610058275274;
        Thu, 07 Jan 2021 14:24:35 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id k1sm10356498wrn.46.2021.01.07.14.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:24:34 -0800 (PST)
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
Subject: [PULL 19/66] target/mips: Inline cpu_state_reset() in mips_cpu_reset()
Date:   Thu,  7 Jan 2021 23:22:06 +0100
Message-Id: <20210107222253.20382-20-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201214183739.500368-2-f4bug@amsat.org>
---
 target/mips/cpu.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index 12126d37f16..4a251e2d3e8 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -104,10 +104,16 @@ static bool mips_cpu_has_work(CPUState *cs)
 
 #include "translate_init.c.inc"
 
-/* TODO QOM'ify CPU reset and remove */
-static void cpu_state_reset(CPUMIPSState *env)
+static void mips_cpu_reset(DeviceState *dev)
 {
-    CPUState *cs = env_cpu(env);
+    CPUState *cs = CPU(dev);
+    MIPSCPU *cpu = MIPS_CPU(cs);
+    MIPSCPUClass *mcc = MIPS_CPU_GET_CLASS(cpu);
+    CPUMIPSState *env = &cpu->env;
+
+    mcc->parent_reset(dev);
+
+    memset(env, 0, offsetof(CPUMIPSState, end_reset_fields));
 
     /* Reset registers to their default values */
     env->CP0_PRid = env->cpu_model->CP0_PRid;
@@ -330,20 +336,6 @@ static void cpu_state_reset(CPUMIPSState *env)
         /* UHI interface can be used to obtain argc and argv */
         env->active_tc.gpr[4] = -1;
     }
-}
-
-static void mips_cpu_reset(DeviceState *dev)
-{
-    CPUState *s = CPU(dev);
-    MIPSCPU *cpu = MIPS_CPU(s);
-    MIPSCPUClass *mcc = MIPS_CPU_GET_CLASS(cpu);
-    CPUMIPSState *env = &cpu->env;
-
-    mcc->parent_reset(dev);
-
-    memset(env, 0, offsetof(CPUMIPSState, end_reset_fields));
-
-    cpu_state_reset(env);
 
 #ifndef CONFIG_USER_ONLY
     if (kvm_enabled()) {
-- 
2.26.2

