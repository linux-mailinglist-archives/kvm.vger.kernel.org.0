Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14EDF2D9F69
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 19:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440517AbgLNSlo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 13:41:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408886AbgLNSif (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 13:38:35 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F14C061794
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:37:53 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id r14so17460028wrn.0
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:37:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sHs7veobjgUtipOw413RUmMgxkozqNiInWyl2lKSMtU=;
        b=R6N8xTI/TZtt1/ttVRJTmldNvalaoWhTKj05I/CefXL1w6qwVuoX5FlfsUPcBdXMFD
         56U7USzIa7r4f9rCItTPiLdGHoD5wnwAcn/8gALZyd/AazBiwMgCdzM8IdQl8V80Rg8X
         JNHa0vDoEcrc5CuALtXrP2iSKIQ6yIumZm+kOzKMuNKzXlNwXvXmaohGukV+a5Y+QRRm
         ev6sbJeHWeYHg52DQ/KnKGRRcjPz/hoXWb6nTDucsf7Lzm68XBAZaHh4j54rhl58h5ST
         QrRKyGmqvMifpyWAC52NebHSz6bfrXtJe9BR9RXUOw4MBCf0N58rmEq5ywLAsDPQkZ9/
         RGfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=sHs7veobjgUtipOw413RUmMgxkozqNiInWyl2lKSMtU=;
        b=niK0BtqA/npolRj2ATarNz/+uH0v84+71bdF+tmXcVqn8n9PkJEKYds1v0yJfaPaAc
         PfxrVXYsutni13SHzubZqh/ASJjl1dmAXL4AQqMbGIjBUwXNMkLf9E8N+EF5CWSJs9oZ
         zuc4pEG0WJ/Ewh8DNoUH6ENO7VezX5pOVqPw8TyMjcmm7TpWs7uWDj3Nj7CG6O2eALp3
         UHJaeni3mpwaW5EUZTCRywuXi+ShW8rYb3AAIoG1DintEbaZ09eA5CfhhB3GUmMdIqjq
         dP9YOFlXSzGc/gvz+aWE+FIXVaf8lYuB3s6dUCXewVU6yKjH959iutouOb2wokYmi72h
         e1Qg==
X-Gm-Message-State: AOAM530GDEikEnUQFSHWulKSYg5Noxa4wqusBEf2AVe0Rv8KPnNGhpup
        QPwN2JUoaW1ECfSNv5Fr5+w=
X-Google-Smtp-Source: ABdhPJxr14U7LFHQpzDw1aBFzgQBJzKBC+fQhPUojU/M0bLtxPrBLZNJG3iXGeF6lA9w6JG8I1YYew==
X-Received: by 2002:a5d:6888:: with SMTP id h8mr30614055wru.268.1607971072553;
        Mon, 14 Dec 2020 10:37:52 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id a62sm35673893wmh.40.2020.12.14.10.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 10:37:51 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v2 02/16] target/mips: Extract FPU helpers to 'fpu_helper.h'
Date:   Mon, 14 Dec 2020 19:37:25 +0100
Message-Id: <20201214183739.500368-3-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201214183739.500368-1-f4bug@amsat.org>
References: <20201214183739.500368-1-f4bug@amsat.org>
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
 target/mips/fpu_helper.h         | 59 ++++++++++++++++++++++++++++++++
 target/mips/internal.h           | 49 --------------------------
 linux-user/mips/cpu_loop.c       |  1 +
 target/mips/fpu_helper.c         |  1 +
 target/mips/gdbstub.c            |  1 +
 target/mips/kvm.c                |  1 +
 target/mips/machine.c            |  1 +
 target/mips/msa_helper.c         |  1 +
 target/mips/op_helper.c          |  2 +-
 target/mips/translate.c          |  1 +
 target/mips/translate_init.c.inc |  2 ++
 11 files changed, 69 insertions(+), 50 deletions(-)
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
index e4d2d9f44f9..24d9f0d6a5c 100644
--- a/target/mips/internal.h
+++ b/target/mips/internal.h
@@ -9,7 +9,6 @@
 #define MIPS_INTERNAL_H
 
 #include "exec/memattrs.h"
-#include "fpu/softfloat-helpers.h"
 
 /*
  * MMU types, the first four entries have the same layout as the
@@ -75,13 +74,6 @@ struct mips_def_t {
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
@@ -220,49 +212,8 @@ bool mips_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
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
index bdb65065ee7..a3c05160b35 100644
--- a/target/mips/fpu_helper.c
+++ b/target/mips/fpu_helper.c
@@ -27,6 +27,7 @@
 #include "exec/exec-all.h"
 #include "exec/cpu_ldst.h"
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
index 477692566a4..a5b6fe35dbc 100644
--- a/target/mips/kvm.c
+++ b/target/mips/kvm.c
@@ -24,6 +24,7 @@
 #include "sysemu/runstate.h"
 #include "kvm_mips.h"
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
index 5aa97902e98..3386b8228e9 100644
--- a/target/mips/op_helper.c
+++ b/target/mips/op_helper.c
@@ -24,7 +24,7 @@
 #include "exec/helper-proto.h"
 #include "exec/exec-all.h"
 #include "exec/memop.h"
-
+#include "fpu_helper.h"
 
 /*****************************************************************************/
 /* Exceptions processing helpers */
diff --git a/target/mips/translate.c b/target/mips/translate.c
index 19933b7868c..d2614796214 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -35,6 +35,7 @@
 #include "exec/translator.h"
 #include "exec/log.h"
 #include "qemu/qemu-print.h"
+#include "fpu_helper.h"
 
 #define MIPS_DEBUG_DISAS 0
 
diff --git a/target/mips/translate_init.c.inc b/target/mips/translate_init.c.inc
index f72fee3b40a..915277dd1f6 100644
--- a/target/mips/translate_init.c.inc
+++ b/target/mips/translate_init.c.inc
@@ -18,6 +18,8 @@
  * License along with this library; if not, see <http://www.gnu.org/licenses/>.
  */
 
+#include "fpu_helper.h"
+
 /* CPU / CPU family specific config register values. */
 
 /* Have config1, uncached coherency */
-- 
2.26.2

