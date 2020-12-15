Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFD42DB6C4
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 00:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbgLOXAB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 18:00:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730344AbgLOW7j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 17:59:39 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C2CC061794
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:58:58 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id qw4so29993992ejb.12
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9CkPJcd6xJbMtrAkYBIpDMUHZeAN46ko14KRtiJapA4=;
        b=BiQ2ycjsxQHoeJ2ijcxRmvB57TPrTeX5ViuRES6OZFetdzaT9AOzR2TawHUGWuQv8D
         npUNOkwDu/1Dcys6loUgqcXWYP9mrw1DqBHpDwsNtf00lQqYLqXIatAhGwA8Jp0Alj+2
         b/w0mDwRvb5SieQVa6SpAm36h63x3N5//j+CS0xfAH2Fo34wz8bQu1Lxe9sGz5i1mKKk
         VFXboKx8Llpn5KIa8VLLy2cAn/ma77mM97VtslIJKwbhpFvUMgVRqrsqMleMi427ejAG
         Rhwn4E1aGvCzu37vOQMqRTckjJpU72dpgaEs5woeDuWsNRZTxY2DfrIlHech18Kj73Eu
         NO0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=9CkPJcd6xJbMtrAkYBIpDMUHZeAN46ko14KRtiJapA4=;
        b=s87Y4WC3gJ9iRoy/NpjsGOOTAGEL1F5Im3sIfb0l1VvlcgULd9aXHNuFVcqDBgXB6S
         CflUI+8F2I0P6zlM7qQ6KUcnwvvftgnEBDwifx9B1n8T4ylaEk81+q/mEg+YKwgJUrBk
         61Ej6teCDFauPA7QjMngfYpAuzRvjb0dVCIN5eUnH+/adbouDio6dzSnZTtoCX2Qa+vW
         6mmFJSifCse4p5gC5JW7L8+bBDoXSjeXa1BGDWvSQQ2WI3j6cf5rXoblrRcSbXiEbRa9
         bpscA1NbwRpuTkg5oXanoyqevMRSefdudPzKFKjaJxOdD1zWpH5NtSwCEANlyX84uJdA
         /2rA==
X-Gm-Message-State: AOAM5335vk9Zc1mPIJevXZYpYwMoHm6mcPjoWrSK9veq8od+qE8jEl53
        xXw8RXubR/gklQLfhHaoGms=
X-Google-Smtp-Source: ABdhPJyZlHppOI2Oq3wCyB7RtVd2wgnPpWTwgBne8+vso2vjRRs+QQxQcUYlhx4l3UGpsUSEF85sVQ==
X-Received: by 2002:a17:906:26ca:: with SMTP id u10mr15722070ejc.165.1608073137198;
        Tue, 15 Dec 2020 14:58:57 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id f11sm20315906edy.59.2020.12.15.14.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 14:58:56 -0800 (PST)
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
Subject: [PATCH v2 10/24] target/mips: Extract msa_translate_init() from mips_tcg_init()
Date:   Tue, 15 Dec 2020 23:57:43 +0100
Message-Id: <20201215225757.764263-11-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201215225757.764263-1-f4bug@amsat.org>
References: <20201215225757.764263-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The msa_wr_d[] registers are only initialized/used by MSA.

They are declared static. We want to move them to the new
'mod-msa_translate.c' unit in few commits, without having to
declare them global (with extern).

Extract first the logic initialization of the MSA registers
from the generic initialization. We will later move this
function along with the MSA registers to the new C unit.

Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/translate.h |  3 +++
 target/mips/translate.c | 33 +++++++++++++++++++--------------
 2 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/target/mips/translate.h b/target/mips/translate.h
index 942d803476c..f7e7037bab8 100644
--- a/target/mips/translate.h
+++ b/target/mips/translate.h
@@ -161,4 +161,7 @@ extern TCGv bcond;
         }                                                                     \
     } while (0)
 
+/* MSA */
+void msa_translate_init(void);
+
 #endif
diff --git a/target/mips/translate.c b/target/mips/translate.c
index 9b5b551b616..2dc7b446e9a 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -31550,6 +31550,24 @@ void mips_cpu_dump_state(CPUState *cs, FILE *f, int flags)
     }
 }
 
+void msa_translate_init(void)
+{
+    int i;
+
+    for (i = 0; i < 32; i++) {
+        int off = offsetof(CPUMIPSState, active_fpu.fpr[i].wr.d[0]);
+
+        /*
+         * The MSA vector registers are mapped on the
+         * scalar floating-point unit (FPU) registers.
+         */
+        msa_wr_d[i * 2] = fpu_f64[i];
+        off = offsetof(CPUMIPSState, active_fpu.fpr[i].wr.d[1]);
+        msa_wr_d[i * 2 + 1] =
+                tcg_global_mem_new_i64(cpu_env, off, msaregnames[i * 2 + 1]);
+    }
+}
+
 void mips_tcg_init(void)
 {
     int i;
@@ -31565,20 +31583,7 @@ void mips_tcg_init(void)
 
         fpu_f64[i] = tcg_global_mem_new_i64(cpu_env, off, fregnames[i]);
     }
-    /* MSA */
-    for (i = 0; i < 32; i++) {
-        int off = offsetof(CPUMIPSState, active_fpu.fpr[i].wr.d[0]);
-
-        /*
-         * The MSA vector registers are mapped on the
-         * scalar floating-point unit (FPU) registers.
-         */
-        msa_wr_d[i * 2] = fpu_f64[i];
-        off = offsetof(CPUMIPSState, active_fpu.fpr[i].wr.d[1]);
-        msa_wr_d[i * 2 + 1] =
-                tcg_global_mem_new_i64(cpu_env, off, msaregnames[i * 2 + 1]);
-    }
-
+    msa_translate_init();
     cpu_PC = tcg_global_mem_new(cpu_env,
                                 offsetof(CPUMIPSState, active_tc.PC), "PC");
     for (i = 0; i < MIPS_DSP_ACC; i++) {
-- 
2.26.2

