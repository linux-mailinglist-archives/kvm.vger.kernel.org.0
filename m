Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800492D1EA8
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 00:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbgLGX5E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 18:57:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgLGX5D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 18:57:03 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7097BC061285
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 15:56:04 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id r5so15652395eda.12
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 15:56:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2j0CQXtPFftuXNpmWEUjMSBohbrajeTcUm20t1SQymg=;
        b=s+x4YaKiiZjShUuR0C5zkcABAbWLWGDyhwm/cU3oAGM4lL+AxAneIQRUwdPpEbUZn+
         VmfNAu9WrUCi+GRB14a1k3jyXtuA43snLIaNgg3TGsfZohyoseA74OSdvJCA9W0Qcs51
         3t9J1hzv5IlS4W/J1Thgg6PDfXD3U5NlnBCv7jYD4iavSmUraw14V4OFQzw7px6VSlcg
         zz1KHJ9Iq6BIeUATEONSgZiXrYRSOlTSS0DZ7M2/tOZz3Gkmsv0fHG69jblqHQVkSknl
         JivGPTEP+d7YVdKPYAOFKs6ruMd9oM/J+E1e6vuRzOZf7B/oXyseemV6pxjlcuPCMqFZ
         GK9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=2j0CQXtPFftuXNpmWEUjMSBohbrajeTcUm20t1SQymg=;
        b=dFtH+WWJqfR+KcV6BkyPUtL22I7i6Spv7KVyBa2Vd86Zj5EsUS13wELRKaC8X02UpT
         TUu8Muno9n3/N38sNPid3Miv9fGJ7RSaCtHezZBopP2Yqwwyh5Ca4zxH5GXr2R9Zwggl
         DIlczsR0A4O+SEGs/V9A4cuijiZTC2+CcBg7ZyKPtQJRyzY/FOE0XISXxWXrSkViQRGG
         Dm+1sNPse82g/82b3c4nt54GDd6PkPgEbuvD1yQZwcdBN/KHaaP2+3nzP5opN5ZW7Fgm
         YuwN3W5Io292wUgEFk59eGrqIigkahXncXann16zzGKTQwlTjIzkhP8ybvivNv0H0dqX
         z5+A==
X-Gm-Message-State: AOAM5327ZIuYv+tozgVYePax1LubX/xBp1f1kWTdFWOvtDTuUqAIaX5+
        iSC74GveUmKJneRHowaCORY=
X-Google-Smtp-Source: ABdhPJyfXUMhXJ5q4xwg0TwkGPb6gQ77vHz1jK9BXN9heagE34hT/j+Bh5wblKdjqDraEfqGS1QDug==
X-Received: by 2002:a05:6402:229b:: with SMTP id cw27mr22087417edb.23.1607385362716;
        Mon, 07 Dec 2020 15:56:02 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id b9sm13825936ejb.0.2020.12.07.15.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 15:56:02 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Laurent Vivier <laurent@vivier.eu>,
        Richard Henderson <richard.henderson@linaro.org>,
        Huacai Chen <chenhuacai@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH 4/7] target/mips: Extract FPU helpers to 'fpu_helper.h'
Date:   Tue,  8 Dec 2020 00:55:36 +0100
Message-Id: <20201207235539.4070364-5-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201207235539.4070364-1-f4bug@amsat.org>
References: <20201207235539.4070364-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extract FPU specific helpers from "internal.h" to "fpu_helper.h".

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Message-Id: <20201120210844.2625602-2-f4bug@amsat.org>
---
 target/mips/fpu_helper.h   | 59 ++++++++++++++++++++++++++++++++++++++
 target/mips/internal.h     | 50 --------------------------------
 linux-user/mips/cpu_loop.c |  1 +
 target/mips/fpu_helper.c   |  1 +
 target/mips/gdbstub.c      |  1 +
 target/mips/kvm.c          |  1 +
 target/mips/machine.c      |  1 +
 target/mips/msa_helper.c   |  1 +
 target/mips/op_helper.c    |  1 +
 target/mips/translate.c    |  1 +
 10 files changed, 67 insertions(+), 50 deletions(-)
 create mode 100644 target/mips/fpu_helper.h

diff --git a/target/mips/fpu_helper.h b/target/mips/fpu_helper.h
new file mode 100644
index 00000000000..1c2d6d35a71
--- /dev/null
+++ b/target/mips/fpu_helper.h
@@ -0,0 +1,59 @@
+/*
+ * Helpers for emulation of FPU-related MIPS instructions.
+ *
+ *  Copyright (C) 2004-2005  Jocelyn Mayer
+ *
+ * SPDX-License-Identifier: LGPL-2.1-or-later
+ */
+#include "fpu/softfloat-helpers.h"
+#include "cpu.h"
+
+extern const FloatRoundMode ieee_rm[4];
+
+uint32_t float_class_s(uint32_t arg, float_status *fst);
+uint64_t float_class_d(uint64_t arg, float_status *fst);
+
+static inline void restore_rounding_mode(CPUMIPSState *env)
+{
+    set_float_rounding_mode(ieee_rm[env->active_fpu.fcr31 & 3],
+                            &env->active_fpu.fp_status);
+}
+
+static inline void restore_flush_mode(CPUMIPSState *env)
+{
+    set_flush_to_zero((env->active_fpu.fcr31 & (1 << FCR31_FS)) != 0,
+                      &env->active_fpu.fp_status);
+}
+
+static inline void restore_snan_bit_mode(CPUMIPSState *env)
+{
+    set_snan_bit_is_one((env->active_fpu.fcr31 & (1 << FCR31_NAN2008)) == 0,
+                        &env->active_fpu.fp_status);
+}
+
+static inline void restore_fp_status(CPUMIPSState *env)
+{
+    restore_rounding_mode(env);
+    restore_flush_mode(env);
+    restore_snan_bit_mode(env);
+}
+
+/* MSA */
+
+enum CPUMIPSMSADataFormat {
+    DF_BYTE = 0,
+    DF_HALF,
+    DF_WORD,
+    DF_DOUBLE
+};
+
+static inline void restore_msa_fp_status(CPUMIPSState *env)
+{
+    float_status *status = &env->active_tc.msa_fp_status;
+    int rounding_mode = (env->active_tc.msacsr & MSACSR_RM_MASK) >> MSACSR_RM;
+    bool flush_to_zero = (env->active_tc.msacsr & MSACSR_FS_MASK) != 0;
+
+    set_float_rounding_mode(ieee_rm[rounding_mode], status);
+    set_flush_to_zero(flush_to_zero, status);
+    set_flush_inputs_to_zero(flush_to_zero, status);
+}
diff --git a/target/mips/internal.h b/target/mips/internal.h
index 5d8a8a1838e..6b9d1d4b93b 100644
--- a/target/mips/internal.h
+++ b/target/mips/internal.h
@@ -8,8 +8,6 @@
 #ifndef MIPS_INTERNAL_H
 #define MIPS_INTERNAL_H
 
-#include "fpu/softfloat-helpers.h"
-
 /*
  * MMU types, the first four entries have the same layout as the
  * CP0C0_MT field.
@@ -74,13 +72,6 @@ struct mips_def_t {
 extern const struct mips_def_t mips_defs[];
 extern const int mips_defs_number;
 
-enum CPUMIPSMSADataFormat {
-    DF_BYTE = 0,
-    DF_HALF,
-    DF_WORD,
-    DF_DOUBLE
-};
-
 void mips_cpu_do_interrupt(CPUState *cpu);
 bool mips_cpu_exec_interrupt(CPUState *cpu, int int_req);
 void mips_cpu_dump_state(CPUState *cpu, FILE *f, int flags);
@@ -223,49 +214,8 @@ bool mips_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
                        bool probe, uintptr_t retaddr);
 
 /* op_helper.c */
-uint32_t float_class_s(uint32_t arg, float_status *fst);
-uint64_t float_class_d(uint64_t arg, float_status *fst);
-
-extern const FloatRoundMode ieee_rm[4];
-
 void update_pagemask(CPUMIPSState *env, target_ulong arg1, int32_t *pagemask);
 
-static inline void restore_rounding_mode(CPUMIPSState *env)
-{
-    set_float_rounding_mode(ieee_rm[env->active_fpu.fcr31 & 3],
-                            &env->active_fpu.fp_status);
-}
-
-static inline void restore_flush_mode(CPUMIPSState *env)
-{
-    set_flush_to_zero((env->active_fpu.fcr31 & (1 << FCR31_FS)) != 0,
-                      &env->active_fpu.fp_status);
-}
-
-static inline void restore_snan_bit_mode(CPUMIPSState *env)
-{
-    set_snan_bit_is_one((env->active_fpu.fcr31 & (1 << FCR31_NAN2008)) == 0,
-                        &env->active_fpu.fp_status);
-}
-
-static inline void restore_fp_status(CPUMIPSState *env)
-{
-    restore_rounding_mode(env);
-    restore_flush_mode(env);
-    restore_snan_bit_mode(env);
-}
-
-static inline void restore_msa_fp_status(CPUMIPSState *env)
-{
-    float_status *status = &env->active_tc.msa_fp_status;
-    int rounding_mode = (env->active_tc.msacsr & MSACSR_RM_MASK) >> MSACSR_RM;
-    bool flush_to_zero = (env->active_tc.msacsr & MSACSR_FS_MASK) != 0;
-
-    set_float_rounding_mode(ieee_rm[rounding_mode], status);
-    set_flush_to_zero(flush_to_zero, status);
-    set_flush_inputs_to_zero(flush_to_zero, status);
-}
-
 static inline void restore_pamask(CPUMIPSState *env)
 {
     if (env->hflags & MIPS_HFLAG_ELPA) {
diff --git a/linux-user/mips/cpu_loop.c b/linux-user/mips/cpu_loop.c
index cfe7ba5c47d..b58dbeb83d1 100644
--- a/linux-user/mips/cpu_loop.c
+++ b/linux-user/mips/cpu_loop.c
@@ -23,6 +23,7 @@
 #include "cpu_loop-common.h"
 #include "elf.h"
 #include "internal.h"
+#include "fpu_helper.h"
 
 # ifdef TARGET_ABI_MIPSO32
 #  define MIPS_SYSCALL_NUMBER_UNUSED -1
diff --git a/target/mips/fpu_helper.c b/target/mips/fpu_helper.c
index 501bd401a16..7d949cd8e3a 100644
--- a/target/mips/fpu_helper.c
+++ b/target/mips/fpu_helper.c
@@ -31,6 +31,7 @@
 #include "exec/memop.h"
 #include "sysemu/kvm.h"
 #include "fpu/softfloat.h"
+#include "fpu_helper.h"
 
 
 /* Complex FPU operations which may need stack space. */
diff --git a/target/mips/gdbstub.c b/target/mips/gdbstub.c
index e39f8d75cf0..f1c2a2cf6d6 100644
--- a/target/mips/gdbstub.c
+++ b/target/mips/gdbstub.c
@@ -21,6 +21,7 @@
 #include "cpu.h"
 #include "internal.h"
 #include "exec/gdbstub.h"
+#include "fpu_helper.h"
 
 int mips_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
diff --git a/target/mips/kvm.c b/target/mips/kvm.c
index cbd0cb8faa4..3ca3a0da93f 100644
--- a/target/mips/kvm.c
+++ b/target/mips/kvm.c
@@ -27,6 +27,7 @@
 #include "kvm_mips.h"
 #include "exec/memattrs.h"
 #include "hw/boards.h"
+#include "fpu_helper.h"
 
 #define DEBUG_KVM 0
 
diff --git a/target/mips/machine.c b/target/mips/machine.c
index 5b23e3e912a..a4ea67c2980 100644
--- a/target/mips/machine.c
+++ b/target/mips/machine.c
@@ -2,6 +2,7 @@
 #include "cpu.h"
 #include "internal.h"
 #include "migration/cpu.h"
+#include "fpu_helper.h"
 
 static int cpu_post_load(void *opaque, int version_id)
 {
diff --git a/target/mips/msa_helper.c b/target/mips/msa_helper.c
index 249f0fdad80..b89b4c44902 100644
--- a/target/mips/msa_helper.c
+++ b/target/mips/msa_helper.c
@@ -23,6 +23,7 @@
 #include "exec/exec-all.h"
 #include "exec/helper-proto.h"
 #include "fpu/softfloat.h"
+#include "fpu_helper.h"
 
 /* Data format min and max values */
 #define DF_BITS(df) (1 << ((df) + 3))
diff --git a/target/mips/op_helper.c b/target/mips/op_helper.c
index 5184a1838be..72613706188 100644
--- a/target/mips/op_helper.c
+++ b/target/mips/op_helper.c
@@ -28,6 +28,7 @@
 #include "exec/cpu_ldst.h"
 #include "exec/memop.h"
 #include "sysemu/kvm.h"
+#include "fpu_helper.h"
 
 
 /*****************************************************************************/
diff --git a/target/mips/translate.c b/target/mips/translate.c
index 46aab26b868..6614512a828 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -39,6 +39,7 @@
 #include "exec/translator.h"
 #include "exec/log.h"
 #include "qemu/qemu-print.h"
+#include "fpu_helper.h"
 #include "translate.h"
 
 enum {
-- 
2.26.2

