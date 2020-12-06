Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBD92D081F
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 00:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728605AbgLFXlg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 18:41:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728583AbgLFXlf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Dec 2020 18:41:35 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48CB7C061A51
        for <kvm@vger.kernel.org>; Sun,  6 Dec 2020 15:41:20 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id z7so11046482wrn.3
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 15:41:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xm/MxUEH7jkD1QG6cSrOIpJqx9OHIRmXgkVnHFu8QuE=;
        b=KyiSOuCQWG/R8m4WJmpVDlX6Irzi5kjH0pJ+KfpX4HifpbhVAWwyPEXoqrKyeWHWSL
         p4hwddyHrcVMm0pCUDsbjd2UcHADLhNdEbUJNc6Dh0axxwiW8bhuyz+bd8UD8rgZiuf3
         F2SHdWOe7OxS6H54N0jXVa0s/0tVzpPE6A5xssnRJjV1LNVNA2snFmcjxGC3mq6AEDx+
         MafT2MUI8kkAGgXkTuOEooO7M1mrxWCCtacSYLbAT4IsEjzSpeQufSqKJxiotDruilGd
         S9mM+6XXORONzD6ICCiCD0OPInGpWiHXFOUiD1dw6RVnYKTTibdJNfjr/sJXL5ptmjHV
         mRoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=Xm/MxUEH7jkD1QG6cSrOIpJqx9OHIRmXgkVnHFu8QuE=;
        b=k0gZujoeCqOhJySz1OAsAeW7eFgGlpRNqLUh1dLCfxKsLTkpEtvTwNo9uq1gh/y5nj
         h50VTer9MiRMTZh0WH5aCIpv351Rp4TOPYEclVz/rgz46s6n2qOQAH1ZxcQE93HKw0l8
         HiUl9arg099R0oZ1sMY53CrpW+LLredfMeNH6DsrlZOVs+VEZ3ugF9B10iDxob+r5tqV
         Z/CWkLd/kD8KKoT07ZfpI7yozaGXlChrjxiFumHG0c+OlcdifT5mEBQryyj8j2ZwT3D9
         9DbyTmILmJCUTHIYDiC2LYdRpmtzy8nxmnyt3otNnIEbE0OfM+qKgJgArrtMX2daNjE2
         lxlg==
X-Gm-Message-State: AOAM531EfLQlUk7G6i3CVzceOVDM7+Z2CeH1ldOqpYC+O5T+M6+nEC/p
        O9C76LrmY5iAgVl4ZlZ1A7k=
X-Google-Smtp-Source: ABdhPJzXt3ifQfM2cwjMdevwVqsOb/NkKyOt1a61/Zmv8kSIR8bdzs9XS/k1lZiuUpSeu/NFS7gg8g==
X-Received: by 2002:adf:ed51:: with SMTP id u17mr16909273wro.61.1607298079086;
        Sun, 06 Dec 2020 15:41:19 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id c4sm12542853wmf.19.2020.12.06.15.41.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 15:41:18 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 17/19] target/mips: Rename translate_init.c as cpu-defs.c
Date:   Mon,  7 Dec 2020 00:39:47 +0100
Message-Id: <20201206233949.3783184-18-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201206233949.3783184-1-f4bug@amsat.org>
References: <20201206233949.3783184-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This file is not TCG specific, contains CPU definitions
and is consumed by cpu.c. Rename it as such.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
cpu-defs.c still contains fpu_init()/mvp_init()/msa_reset().
They are moved out in different series (already posted).
---
 target/mips/cpu.c                                    | 11 ++++++++++-
 target/mips/{translate_init.c.inc => cpu-defs.c.inc} |  9 ---------
 2 files changed, 10 insertions(+), 10 deletions(-)
 rename target/mips/{translate_init.c.inc => cpu-defs.c.inc} (99%)

diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index 899a746c3e5..8a4486e3ea1 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -102,7 +102,16 @@ static bool mips_cpu_has_work(CPUState *cs)
     return has_work;
 }
 
-#include "translate_init.c.inc"
+#include "cpu-defs.c.inc"
+
+void mips_cpu_list(void)
+{
+    int i;
+
+    for (i = 0; i < ARRAY_SIZE(mips_defs); i++) {
+        qemu_printf("MIPS '%s'\n", mips_defs[i].name);
+    }
+}
 
 /* TODO QOM'ify CPU reset and remove */
 static void cpu_state_reset(CPUMIPSState *env)
diff --git a/target/mips/translate_init.c.inc b/target/mips/cpu-defs.c.inc
similarity index 99%
rename from target/mips/translate_init.c.inc
rename to target/mips/cpu-defs.c.inc
index f3daf451a63..ad578cb8601 100644
--- a/target/mips/translate_init.c.inc
+++ b/target/mips/cpu-defs.c.inc
@@ -922,15 +922,6 @@ const mips_def_t mips_defs[] =
 };
 const int mips_defs_number = ARRAY_SIZE(mips_defs);
 
-void mips_cpu_list(void)
-{
-    int i;
-
-    for (i = 0; i < ARRAY_SIZE(mips_defs); i++) {
-        qemu_printf("MIPS '%s'\n", mips_defs[i].name);
-    }
-}
-
 static void fpu_init (CPUMIPSState *env, const mips_def_t *def)
 {
     int i;
-- 
2.26.2

