Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30CF2EE893
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728541AbhAGW1K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728408AbhAGW1J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:27:09 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0B1C0612FC
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:26:54 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id r7so7120938wrc.5
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:26:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bnGMuEIL+4VmlV+xdWwg0SJvZ11jLh/bemgKxGT4D88=;
        b=Sbw38LZaOgKRsa2cr7ciETm4KuxJk1r/FTDMGg1cFdjsnLucprvjzuOP7dWJP4GOB/
         rkUsNjC0bgAwZxDolwnejxMTHZ6s3GqpH32OY2Vn9yq0m7hO78ySx3f2zJF/m2pXng7i
         qmG+M8wmkx2e8qWt11DlBj9ZTLfdcjmhcElcGNQxp2wr38xJbxPiSA3qw1yd5qGpiB9G
         PgLSJa2zZRi77oo6gFaGWQCFDs8Ucx4vuWBZdSORt3w76fXwyNIN2oDEND2pa0cEe2h1
         kq+LWM/Sx4IV44XlnQivufBXnPza4me3f3y83wbwxgU7wbMa0VpSH3U3SWMEJ+g0eifA
         fGfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=bnGMuEIL+4VmlV+xdWwg0SJvZ11jLh/bemgKxGT4D88=;
        b=BCslxNkBxej+l2RDcFo7/KPkBy7NhtPm08zoDuP5sna5kzZYJfjgVlBgpq8TZXtGUy
         9mrlLdE4ax0BgC6g1pmNoGCPULxUZKMYoIXWIxjXw7ttyitOpHxaNSqBLZ45MRFe7ebh
         npoJYfpR4kgpvkECkviRI9hGL314tZlOTedtp6vGj+qHCIlQSA29Jq61m4dWBIqWLV5x
         yeHPfuqBVZXE3baFwFG+Ksrc4+d3QJ1Nc/pCwjZaFoZP8dyfP+/U7HfRBHwgm1SKH5pz
         +FArGplu6TCcfZBM5u10xbSvWV5lh8juPo1DvF/an3xymAk9druw+WwA4ShTnmiZ0tWL
         2JNA==
X-Gm-Message-State: AOAM530Fe784e/Xa7gdvF/aDqjWFgnpLqrPQbYQNy56sm+y8aQnRWRCc
        1Ol8GKNdifYbgzoDpKEPpwU=
X-Google-Smtp-Source: ABdhPJxePIlJhzELurqoS+K7alNqibaKNHaRCBr8+ZkgFJMw/suk4RQ4msNEseH0yAh1UdMXMgkIOQ==
X-Received: by 2002:adf:ec8c:: with SMTP id z12mr687776wrn.208.1610058413020;
        Thu, 07 Jan 2021 14:26:53 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id n9sm10110262wrq.41.2021.01.07.14.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:26:52 -0800 (PST)
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
Subject: [PULL 46/66] target/mips: Move msa_reset() to msa_helper.c
Date:   Thu,  7 Jan 2021 23:22:33 +0100
Message-Id: <20210107222253.20382-47-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
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
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201215225757.764263-15-f4bug@amsat.org>
Tested-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 target/mips/internal.h     |  2 ++
 target/mips/cpu.c          |  1 +
 target/mips/msa_helper.c   | 36 ++++++++++++++++++++++++++++++++++++
 target/mips/cpu-defs.c.inc | 36 ------------------------------------
 4 files changed, 39 insertions(+), 36 deletions(-)

diff --git a/target/mips/internal.h b/target/mips/internal.h
index 1048781bcf4..5dd17ff7333 100644
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
index 4c590b90b25..f45164012a4 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -33,6 +33,7 @@
 #include "hw/qdev-clock.h"
 #include "hw/semihosting/semihost.h"
 #include "qapi/qapi-commands-machine-target.h"
+#include "fpu_helper.h"
 
 #if !defined(CONFIG_USER_ONLY)
 
diff --git a/target/mips/msa_helper.c b/target/mips/msa_helper.c
index b89b4c44902..f0d728c03f0 100644
--- a/target/mips/msa_helper.c
+++ b/target/mips/msa_helper.c
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
index 3d44b394773..ba22ff4bcd1 100644
--- a/target/mips/cpu-defs.c.inc
+++ b/target/mips/cpu-defs.c.inc
@@ -18,8 +18,6 @@
  * License along with this library; if not, see <http://www.gnu.org/licenses/>.
  */
 
-#include "fpu_helper.h"
-
 /* CPU / CPU family specific config register values. */
 
 /* Have config1, uncached coherency */
@@ -975,37 +973,3 @@ static void mvp_init(CPUMIPSState *env)
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

