Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADDE2D1F1C
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 01:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgLHAio (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 19:38:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728767AbgLHAio (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 19:38:44 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09BFAC0611CA
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 16:38:04 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id dk8so12891832edb.1
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 16:38:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HJfC/h9BxA47xiAn2bX5wMEFeliUIBESbbbnkjnhevs=;
        b=eKoyJyPo4jM7ONO8s65eXNGeIdy/J0u0dvc7qFl+zwSrKcgtsv1CyYoetFAl4oxqga
         rjKkh09MKAAgAb9y9TvqJVSX62Gns09fezDlJjNAQ250m/yZgovS8fD1OgAKgMo4396N
         eQnIY+fqpdHcsxjsNDixxQB2DYx3NpsN6Ds4tNqgvNC8jbSIUYhnU0jC0u7eeyNhRue3
         g9NZAmQdUdekBT9YKQJDlUHdYCN9/Lmdaoik3Ga+GKh3eyQKbFsMccHwpycSNwlRdl0f
         GqCCPydPYccc3dOtbgGiuUSb3DFycMO1kCtTbRnQboGXAlKN3AKngA98Ncv+Sv+lzwAS
         /4ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=HJfC/h9BxA47xiAn2bX5wMEFeliUIBESbbbnkjnhevs=;
        b=ctN1cN8rL1E3OwkoxiWtlM5ktiQAJzSXyYDjStrYQw7l/elCoIZaw5C2wsvK41JRfc
         4/Ib6QWiUFSKReZxpiKao+8BLi1C9cE5rMCT/2T09vPwX3oia6nMxCSfUH0AivRM/uj1
         rnMpR/y12jXo9faLILoR9V5E1/KtM+gHCo/IOpD0pBKu2/WkESuI0eKkJa497KewwI4K
         cnYVDWi9B1SgaFVC3yACYJDyBJiG9d6yZeWCuPLvx623jzdSAuosQZKr2GU67EinCA//
         y8L06VquI051W34tiihsi1Nc385Pu0cXF1xqepASzi2bT77slQOKqIQCVMyl7y0wym6o
         os8g==
X-Gm-Message-State: AOAM532YxieuRpoERzbnEbJuglXLkaoHRK3E23eSJN+i5Leeot6zjPYp
        iQgMm8taePaiu4WvRH3tMXx90uIkDzM=
X-Google-Smtp-Source: ABdhPJxkiRvPIJh42/zO15MexanV2Iy2soVWu7CEZ0SXqdozNkWFmgT9/GcL7BMOFXuDT6E2+NgCRA==
X-Received: by 2002:a50:e715:: with SMTP id a21mr22536767edn.285.1607387882785;
        Mon, 07 Dec 2020 16:38:02 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id cb14sm13977041ejb.105.2020.12.07.16.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 16:38:02 -0800 (PST)
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
Subject: [PATCH 11/17] target/mips: Move msa_reset() to mod-msa_helper.c
Date:   Tue,  8 Dec 2020 01:36:56 +0100
Message-Id: <20201208003702.4088927-12-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201208003702.4088927-1-f4bug@amsat.org>
References: <20201208003702.4088927-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

translate_init.c.inc mostly contains CPU definitions.
msa_reset() doesn't belong here, move it with the MSA
helpers.

One comment style is updated to avoid checkpatch.pl warning.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/internal.h           |  2 ++
 target/mips/mod-msa_helper.c     | 36 ++++++++++++++++++++++++++++++++
 target/mips/translate_init.c.inc | 34 ------------------------------
 3 files changed, 38 insertions(+), 34 deletions(-)

diff --git a/target/mips/internal.h b/target/mips/internal.h
index 3bd41239b1d..7813eb224c9 100644
--- a/target/mips/internal.h
+++ b/target/mips/internal.h
@@ -201,6 +201,8 @@ void mips_tcg_init(void);
 void cpu_state_reset(CPUMIPSState *s);
 void cpu_mips_realize_env(CPUMIPSState *env);
 
+void msa_reset(CPUMIPSState *env);
+
 /* cp0_timer.c */
 uint32_t cpu_mips_get_count(CPUMIPSState *env);
 void cpu_mips_store_count(CPUMIPSState *env, uint32_t value);
diff --git a/target/mips/mod-msa_helper.c b/target/mips/mod-msa_helper.c
index b89b4c44902..f0d728c03f0 100644
--- a/target/mips/mod-msa_helper.c
+++ b/target/mips/mod-msa_helper.c
@@ -8201,3 +8201,39 @@ void helper_msa_ffint_u_df(CPUMIPSState *env, uint32_t df, uint32_t wd,
 
     msa_move_v(pwd, pwx);
 }
+
+void msa_reset(CPUMIPSState *env)
+{
+    if (!ase_msa_available(env)) {
+        return;
+    }
+
+#ifdef CONFIG_USER_ONLY
+    /* MSA access enabled */
+    env->CP0_Config5 |= 1 << CP0C5_MSAEn;
+    env->CP0_Status |= (1 << CP0St_CU1) | (1 << CP0St_FR);
+#endif
+
+    /*
+     * MSA CSR:
+     * - non-signaling floating point exception mode off (NX bit is 0)
+     * - Cause, Enables, and Flags are all 0
+     * - round to nearest / ties to even (RM bits are 0)
+     */
+    env->active_tc.msacsr = 0;
+
+    restore_msa_fp_status(env);
+
+    /* tininess detected after rounding.*/
+    set_float_detect_tininess(float_tininess_after_rounding,
+                              &env->active_tc.msa_fp_status);
+
+    /* clear float_status exception flags */
+    set_float_exception_flags(0, &env->active_tc.msa_fp_status);
+
+    /* clear float_status nan mode */
+    set_default_nan_mode(0, &env->active_tc.msa_fp_status);
+
+    /* set proper signanling bit meaning ("1" means "quiet") */
+    set_snan_bit_is_one(0, &env->active_tc.msa_fp_status);
+}
diff --git a/target/mips/translate_init.c.inc b/target/mips/translate_init.c.inc
index f6752d00afe..4856f4c5a4a 100644
--- a/target/mips/translate_init.c.inc
+++ b/target/mips/translate_init.c.inc
@@ -1021,37 +1021,3 @@ static void mvp_init(CPUMIPSState *env)
                              (0x0 << CP0MVPC1_PCX) | (0x0 << CP0MVPC1_PCP2) |
                              (0x1 << CP0MVPC1_PCP1);
 }
-
-static void msa_reset(CPUMIPSState *env)
-{
-    if (!ase_msa_available(env)) {
-        return;
-    }
-
-#ifdef CONFIG_USER_ONLY
-    /* MSA access enabled */
-    env->CP0_Config5 |= 1 << CP0C5_MSAEn;
-    env->CP0_Status |= (1 << CP0St_CU1) | (1 << CP0St_FR);
-#endif
-
-    /* MSA CSR:
-       - non-signaling floating point exception mode off (NX bit is 0)
-       - Cause, Enables, and Flags are all 0
-       - round to nearest / ties to even (RM bits are 0) */
-    env->active_tc.msacsr = 0;
-
-    restore_msa_fp_status(env);
-
-    /* tininess detected after rounding.*/
-    set_float_detect_tininess(float_tininess_after_rounding,
-                              &env->active_tc.msa_fp_status);
-
-    /* clear float_status exception flags */
-    set_float_exception_flags(0, &env->active_tc.msa_fp_status);
-
-    /* clear float_status nan mode */
-    set_default_nan_mode(0, &env->active_tc.msa_fp_status);
-
-    /* set proper signanling bit meaning ("1" means "quiet") */
-    set_snan_bit_is_one(0, &env->active_tc.msa_fp_status);
-}
-- 
2.26.2

