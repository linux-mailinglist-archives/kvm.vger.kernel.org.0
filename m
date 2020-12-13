Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CF32D9076
	for <lists+kvm@lfdr.de>; Sun, 13 Dec 2020 21:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406132AbgLMUWm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Dec 2020 15:22:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405991AbgLMUWa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Dec 2020 15:22:30 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5FC6C061285
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:21:49 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id e25so13419645wme.0
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LJkeleUBcGHGZISXoGddym+wEofBms0JlYm/28m4/UY=;
        b=reyXPlTsnGycXX/TRzVcaYnbIZrraBL/+1KXKqsJN518qKtofjV3OtHNLtKCd+Wqo2
         Hy6a4QWpLfWJpOdeaPucv4VDG+ZmA50p+k1bIYMXwunOMS5ZFWEMNjjQJo2hBDPNmJQn
         qBSUzBgNtwDk8Y3LilDtvW4faxdvEb+ePpYpJNlxO+HqPNAXcCPTvWJ9yuV8NCEjpvzj
         Yny9byxkkJcZMhMxoHX2lWxrHq0veg6FzSj+5XFNqN1g/xsiVUt2OD9tx+agwiNVqwfs
         qJ6Fxu0vDt+IHbYZkniWL2ODYcrE9P/QLEnKosFIHTbMnA7esKmJeKQHVLNUNKfuY8w5
         w08g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=LJkeleUBcGHGZISXoGddym+wEofBms0JlYm/28m4/UY=;
        b=ew1atTnkj/5VtFInZ8hD/fME1OtENfzWR7fBeY84d4nt0YAbIxhXxoL6TOYlV3wkaE
         hCcJ+d2hDxAeVh9DiD5lUA5ISjlVbAe1GRRB0hHtkcSBEP+arnrpX/z8T2vq4INzIwsZ
         8M7k6uIuYE3JN4vHLDbSfjwtfRoKNfinVrcnRV6+thdk86VHqrH3ljL8zeHbAqcHIIR5
         FoiudiOOMJuDfFB5e+X5aL6xv3nhIGG/jt7b8GK1Xv5ppowUi3aKmUsUxNb0sZBeZdNP
         PWQbMIViyH2heXMuFGSMLgemj/cwq7WXJv/Iz11JM2vPIjMHyQVE4FUypVAA54duLxgz
         ST/w==
X-Gm-Message-State: AOAM5315/8pAUrJlnyyib3AMNmt13z8vxPF+WPWxsKdd6lkG3xcb4US3
        e/rKAuvAFu25OHQSeaKWvNE=
X-Google-Smtp-Source: ABdhPJzMp3L7Q56kV+1c+M42iFI4YcY1kR8SEFv4g7CMPo7HH5NN8auAyFYmAwgHAOZbOuQSJxuF6w==
X-Received: by 2002:a1c:4d05:: with SMTP id o5mr25058616wmh.85.1607890908729;
        Sun, 13 Dec 2020 12:21:48 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id e16sm31304940wra.94.2020.12.13.12.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 12:21:48 -0800 (PST)
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
Subject: [PULL 24/26] target/mips: Inline cpu_mips_realize_env() in mips_cpu_realizefn()
Date:   Sun, 13 Dec 2020 21:19:44 +0100
Message-Id: <20201213201946.236123-25-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201213201946.236123-1-f4bug@amsat.org>
References: <20201213201946.236123-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201206233949.3783184-17-f4bug@amsat.org>
---
 target/mips/cpu.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index f2c4de7d070..aadc6f8e74d 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -104,17 +104,6 @@ static bool mips_cpu_has_work(CPUState *cs)
 
 #include "translate_init.c.inc"
 
-static void cpu_mips_realize_env(CPUMIPSState *env)
-{
-    env->exception_base = (int32_t)0xBFC00000;
-
-#ifndef CONFIG_USER_ONLY
-    mmu_init(env, env->cpu_model);
-#endif
-    fpu_init(env, env->cpu_model);
-    mvp_init(env);
-}
-
 /* TODO QOM'ify CPU reset and remove */
 static void cpu_state_reset(CPUMIPSState *env)
 {
@@ -400,6 +389,7 @@ static void mips_cpu_realizefn(DeviceState *dev, Error **errp)
 {
     CPUState *cs = CPU(dev);
     MIPSCPU *cpu = MIPS_CPU(dev);
+    CPUMIPSState *env = &cpu->env;
     MIPSCPUClass *mcc = MIPS_CPU_GET_CLASS(dev);
     Error *local_err = NULL;
 
@@ -423,7 +413,13 @@ static void mips_cpu_realizefn(DeviceState *dev, Error **errp)
         return;
     }
 
-    cpu_mips_realize_env(&cpu->env);
+    env->exception_base = (int32_t)0xBFC00000;
+
+#ifndef CONFIG_USER_ONLY
+    mmu_init(env, env->cpu_model);
+#endif
+    fpu_init(env, env->cpu_model);
+    mvp_init(env);
 
     cpu_reset(cs);
     qemu_init_vcpu(cs);
-- 
2.26.2

