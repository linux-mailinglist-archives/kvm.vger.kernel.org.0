Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 851982D1F16
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 01:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbgLHAiX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 19:38:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728748AbgLHAiX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 19:38:23 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6544C061794
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 16:37:42 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id bo9so22088791ejb.13
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 16:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wc59UVyyYsG4MSL5Uwdbqv0G30FtyphiU1+yChAdeOE=;
        b=rZiiY+p7sDRq/eDiWgYwVWDCXkKtMPzFjFGGoLdXOdzrqEfVv8PjKz5Xy0kjkNoMbc
         b6VejetpteRzP4glW99fS3Kz5BCZvhUJxYed8wFL6h+LxPfjylJDdrwgMcg+wOS27kau
         8L9P7cHbNJNdQHo+vFQwJSF9cTNe/UHvWaoEfRsQgCY2JfRGzo3S1BRv3qOVOeUee26g
         1jf0zcrWebfo0iEJcX4qmYcApPpSN/d1DnWS/RuTkLZKsNxX4OKQEfAIkx473874xR8e
         v8D+w0UM6/hHiyLV7SyUTnL9PCpbzazaq5xHDW5is5rT4z0B1clqV3m3KpmK6YJiBefb
         9NoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=wc59UVyyYsG4MSL5Uwdbqv0G30FtyphiU1+yChAdeOE=;
        b=A892+OtH54L/a/Y2dQOSo5mdKvd8hjFPsa5GKb8b5dHgDFesoVBIvljl18zvngQSXZ
         Wy9q11vMN+ua1nEY/jL6w8pff4Cyv7gwFAl3eBnkAHyXP7/Um+A3oc18YrYjau8j6bfU
         rMKw4XZU5DvlHYjEHz2BrgkZFD9NpZEFqWbtnVCr3WjVaMfUETMFxEkoZNmrRuuieFyt
         QpmWaIe8NjbjQMAVEZLD0nWVvinnX/ckRba24LwujfuHdXFQGSsK7SsBecxO1wxHmNp/
         r5PpnBYHkGm8lxy0QOBSm+fJW2jrR4ivz9R1RjaJdWHHyLenZaIOikpt1DkRkFTCmCGa
         o3Pg==
X-Gm-Message-State: AOAM531j8BzuJF2cZRRLuO1ZWRojKRmuXtfmISl1r0E8aU5AXVa92aKb
        izxKOx8AxER00SIW301WDNg=
X-Google-Smtp-Source: ABdhPJxOMAspRrPAEACiGM3Yu2xuWZ4PtjwSrLOlfbXYY9wzjsbWryiy+15xQFU3sMB8dF951GraMQ==
X-Received: by 2002:a17:906:3883:: with SMTP id q3mr20755205ejd.160.1607387861693;
        Mon, 07 Dec 2020 16:37:41 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id s1sm4884009ejx.25.2020.12.07.16.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 16:37:41 -0800 (PST)
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
Subject: [PATCH 07/17] target/mips: Extract msa_translate_init() from mips_tcg_init()
Date:   Tue,  8 Dec 2020 01:36:52 +0100
Message-Id: <20201208003702.4088927-8-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201208003702.4088927-1-f4bug@amsat.org>
References: <20201208003702.4088927-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extract the logic initialization of the MSA registers from
the generic initialization.

Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/translate.h |  3 +++
 target/mips/translate.c | 33 +++++++++++++++++++--------------
 2 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/target/mips/translate.h b/target/mips/translate.h
index dbf7df7ba6d..765018beeea 100644
--- a/target/mips/translate.h
+++ b/target/mips/translate.h
@@ -80,4 +80,7 @@ extern TCGv bcond;
         }                                                                     \
     } while (0)
 
+/* MSA */
+void msa_translate_init(void);
+
 #endif
diff --git a/target/mips/translate.c b/target/mips/translate.c
index 95d07e837c0..bbe06240510 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -31551,6 +31551,24 @@ void mips_cpu_dump_state(CPUState *cs, FILE *f, int flags)
     }
 }
 
+static void msa_translate_init(void)
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
@@ -31566,20 +31584,7 @@ void mips_tcg_init(void)
 
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

