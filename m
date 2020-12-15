Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE90B2DB784
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 01:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbgLPAAy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 19:00:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729666AbgLOW7i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 17:59:38 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A25C0611CA
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:59:20 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id cm17so22842264edb.4
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r721GGoO1vJJZamWSQ/I62tzPtsotRE5k1CFdAPPmsI=;
        b=ksGYyZqUjnjTpQUlnJkwvhrtsTgCJRP3j5mC6OARLNZQF2ZrJ1V+UhVw8CojGWW3/3
         WO5B8qupZBGOhKvfYWG4DItmratQ+a/4+qPS1HLXosQWnWKkPc/nkPvCs4l+Jov8kDx/
         t8HSxfIh8b5woyVg5KHKoYSQqbU2txnbWYDuKV6NSfRJQ/j+skrIqCkyHWey8VVbqiOM
         XM9lf20J9/7RHu09BygD1EfvPu3uGCxO3lFf1xFqjRZUCHqPNhVX/Xkxqw6aBL8HTfbW
         UPhbdt4btRRu8RbClKYwtZcbkLrYPvFR9aadTWTEpUQ0BSzijYdMj1wdVlse/Vx66Doe
         SxkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=r721GGoO1vJJZamWSQ/I62tzPtsotRE5k1CFdAPPmsI=;
        b=Zn1Ny8cKf5q6xhvlDir3F6mMX93PAlC4pn2EHpgjSUBfpn9+l8DgRLETNqg28M17BQ
         CHlXCv30QL4+zv5vFpEumcIaG8ZsTIlTc3+760ueHr2OcPqZ4ZarQcsCAPN/CfgNSC99
         s6V6wAzdHqwcQZligD3oL81gkmuagxTMUZKZBrZEjIKkqbaboncKNAE15DeoBhAQYxov
         hGzytZMtwlyuBPjwmTnz1v4ydGCU+c0hwQp5jyNZ9QgExdmdt6VGBJpVaAq6XwisPZFw
         j0a14tAyXQTeiHi0s6JH/A+5D8PPmso1Jjn/ai4nXwulnLY22JlLYNI/chbLZTU8Qnsz
         0GjQ==
X-Gm-Message-State: AOAM533JGoD1Wi0jmeWRVtIxL6HbPo0Yispeq8JGGn2eZ0En1jYXposE
        0Eiypbu8qEftdzFYeKtgV44=
X-Google-Smtp-Source: ABdhPJzDX2qNpMB5rixf8fmszl3M6Xc5Sf7KCB17rbtRfsvmzCRyz1COJgMcmCqIhuY2FxDNAuNTPQ==
X-Received: by 2002:aa7:d75a:: with SMTP id a26mr30675115eds.230.1608073159415;
        Tue, 15 Dec 2020 14:59:19 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id f11sm20317375edy.59.2020.12.15.14.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 14:59:18 -0800 (PST)
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
Subject: [PATCH v2 14/24] target/mips: Move msa_reset() to mod-msa_helper.c
Date:   Tue, 15 Dec 2020 23:57:47 +0100
Message-Id: <20201215225757.764263-15-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201215225757.764263-1-f4bug@amsat.org>
References: <20201215225757.764263-1-f4bug@amsat.org>
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
 target/mips/internal.h       |  2 ++
 target/mips/cpu.c            |  1 +
 target/mips/mod-msa_helper.c | 36 ++++++++++++++++++++++++++++++++++++
 target/mips/cpu-defs.c.inc   | 36 ------------------------------------
 4 files changed, 39 insertions(+), 36 deletions(-)

diff --git a/target/mips/internal.h b/target/mips/internal.h
index 1ab2454e61d..76269cfc7bb 100644
--- a/target/mips/internal.h
+++ b/target/mips/internal.h
@@ -199,6 +199,8 @@ static inline bool cpu_mips_hw_interrupts_pending(CPUMIPSState *env)
 
 void mips_tcg_init(void);
 
+void msa_reset(CPUMIPSState *env);
+
 /* cp0_timer.c */
 uint32_t cpu_mips_get_count(CPUMIPSState *env);
 void cpu_mips_store_count(CPUMIPSState *env, uint32_t value);
diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index 77ebd94c655..26e110b687e 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -33,6 +33,7 @@
 #include "hw/qdev-clock.h"
 #include "hw/semihosting/semihost.h"
 #include "qapi/qapi-commands-machine-target.h"
+#include "fpu_helper.h"
 
 #if !defined(CONFIG_USER_ONLY)
 
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
diff --git a/target/mips/cpu-defs.c.inc b/target/mips/cpu-defs.c.inc
index 325b24b8e2c..320ebf29f1f 100644
--- a/target/mips/cpu-defs.c.inc
+++ b/target/mips/cpu-defs.c.inc
@@ -18,8 +18,6 @@
  * License along with this library; if not, see <http://www.gnu.org/licenses/>.
  */
 
-#include "fpu_helper.h"
-
 /* CPU / CPU family specific config register values. */
 
 /* Have config1, uncached coherency */
@@ -973,37 +971,3 @@ static void mvp_init(CPUMIPSState *env)
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

