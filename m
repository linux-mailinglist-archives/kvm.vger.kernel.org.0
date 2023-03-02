Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBF556A8926
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 20:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjCBTJ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 14:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjCBTJM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 14:09:12 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D3B34C11
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 11:08:53 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id p23-20020a05600c1d9700b003ead4835046so2540736wms.0
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 11:08:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jGgBwMUcyIBik2rNBr0fhqXEGqg20UF3VvqGQKmkW3Y=;
        b=YVMjUsdlRGu5n3GOK7fu9LV2wUJ8rJIFQJO/hX/rEsdugWl8LyVId7p16V53Fwjwf1
         3vb5b4bnrnttlbLudOKrcsqbP2cPCjrOh5bQBy2eHSFuv/HZS3DhOXUghKvZwkeX4kY1
         7IjZKWdV6DFQy/Q8JvveYRFJamQN+2E2BL20pvPDbzZXnTw0dBhOw5eJzgoH/SLazN1q
         yR5RXyp8n0QafdRjlFVvN9Wqu5+w+solznDCuRd8MvNkLgn+Wx+kcyehpPo3HRY7TjeA
         ZdV78NMyTIMYpi1IYIbLKUBkGrleAuA+BpuTrAC7VDkDs7UM3zCfxnC+GrloSRp1aJdk
         KiyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jGgBwMUcyIBik2rNBr0fhqXEGqg20UF3VvqGQKmkW3Y=;
        b=xww7qOO0iLSaMO6AskTsI9lYJJ/p/iqgmR1nTLjZCEE9WAc0qzqM4T4KegCx9NpHN8
         usSqzi9r5bNJQ26DcHwrIebC6dPkGA8BJnWpyFMBS74aLvt2He5pAeXQUUCF+OPbGagk
         LioDfki2OVPC8PFNVQC4JibfJA9xnLaRWO9zo0YdQf+LrXtT2r9zhtipUmvwTU3P5bs8
         fhfJMXQ8oJW+wJcC9uYk69n/vOM/QEojAP4HvBvvNbJjZKVmDjNRzSLNDIETxfzh1KpD
         PzpGjmv3+L7TjV1JkiDb0az4yzE2z1Og/4XyHIP/j7gtLSFHXWmyc+NX34Cnp/9WGseL
         XuVg==
X-Gm-Message-State: AO0yUKXBO4I9yRF0zIDu+9cXTl0XsVMnY6iFW75k6M6chtN7OnatAYNT
        kowa2o60k9G10/kyOVXpjM8Rhw==
X-Google-Smtp-Source: AK7set/cNdM7jQ++k3nkvmJwAiZ7hCs3e8eESAMApYjctdji+9SeV4nFRuXMKCMeNkcSGRS+KeksmA==
X-Received: by 2002:a05:600c:4aa8:b0:3eb:3947:41ea with SMTP id b40-20020a05600c4aa800b003eb394741eamr7902497wmp.37.1677784131868;
        Thu, 02 Mar 2023 11:08:51 -0800 (PST)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id l8-20020a05600c4f0800b003b47b80cec3sm4627458wmq.42.2023.03.02.11.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 11:08:48 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id E242E1FFB8;
        Thu,  2 Mar 2023 19:08:47 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Weiwei Li <liweiwei@iscas.ac.cn>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Laurent Vivier <laurent@vivier.eu>,
        nicolas.eder@lauterbach.com, Ilya Leoshkevich <iii@linux.ibm.com>,
        kvm@vger.kernel.org,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        qemu-s390x@nongnu.org, Stafford Horne <shorne@gmail.com>,
        Bin Meng <bin.meng@windriver.com>, Marek Vasut <marex@denx.de>,
        Greg Kurz <groug@kaod.org>, Song Gao <gaosong@loongson.cn>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Chris Wulff <crwulff@gmail.com>, qemu-riscv@nongnu.org,
        Michael Rolnik <mrolnik@gmail.com>, qemu-arm@nongnu.org,
        Cleber Rosa <crosa@redhat.com>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Alexandre Iooss <erdnaxe@crans.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        mads@ynddal.dk, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        qemu-ppc@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        John Snow <jsnow@redhat.com>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mahmoud Mandour <ma.mandourr@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Yanan Wang <wangyanan55@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Taylor Simpson <tsimpson@quicinc.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Fabiano Rosas <farosas@suse.de>
Subject: [PATCH v4 10/26] gdbstub: move chunk of softmmu functionality to own file
Date:   Thu,  2 Mar 2023 19:08:30 +0000
Message-Id: <20230302190846.2593720-11-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230302190846.2593720-1-alex.bennee@linaro.org>
References: <20230302190846.2593720-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is mostly code motion but a number of things needed to be done
for this minimal patch set:

  - move shared structures to internals.h
  - splitting some functions into user and softmmu versions
  - fixing a few casting issues to keep softmmu common

More CONFIG_USER_ONLY stuff will be handled in a following patches.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Fabiano Rosas <farosas@suse.de>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

---
v3
  - rebase fixes
  - move extern to internals.h
v4
  - checkpatch updates
---
 gdbstub/internals.h  |  43 ++++-
 gdbstub/gdbstub.c    | 421 +-----------------------------------------
 gdbstub/softmmu.c    | 423 +++++++++++++++++++++++++++++++++++++++++++
 gdbstub/trace-events |   4 +-
 4 files changed, 478 insertions(+), 413 deletions(-)

diff --git a/gdbstub/internals.h b/gdbstub/internals.h
index cf76627cf7..83989af859 100644
--- a/gdbstub/internals.h
+++ b/gdbstub/internals.h
@@ -17,6 +17,18 @@
  * Shared structures and definitions
  */
 
+enum {
+    GDB_SIGNAL_0 = 0,
+    GDB_SIGNAL_INT = 2,
+    GDB_SIGNAL_QUIT = 3,
+    GDB_SIGNAL_TRAP = 5,
+    GDB_SIGNAL_ABRT = 6,
+    GDB_SIGNAL_ALRM = 14,
+    GDB_SIGNAL_IO = 23,
+    GDB_SIGNAL_XCPU = 24,
+    GDB_SIGNAL_UNKNOWN = 143
+};
+
 typedef struct GDBProcess {
     uint32_t pid;
     bool attached;
@@ -57,6 +69,8 @@ typedef struct GDBState {
     int supported_sstep_flags;
 } GDBState;
 
+/* lives in main gdbstub.c */
+extern GDBState gdbserver_state;
 
 /*
  * Inline utility function, convert from int to hex and back
@@ -101,7 +115,6 @@ CPUState *gdb_first_attached_cpu(void);
 void gdb_append_thread_id(CPUState *cpu, GString *buf);
 int gdb_get_cpu_index(CPUState *cpu);
 
-void gdb_init_gdbserver_state(void);
 void gdb_create_default_process(GDBState *s);
 
 /*
@@ -109,6 +122,34 @@ void gdb_create_default_process(GDBState *s);
  */
 void gdb_put_buffer(const uint8_t *buf, int len);
 
+/*
+ * Command handlers - either softmmu or user only
+ */
+void gdb_init_gdbserver_state(void);
+
+typedef enum GDBThreadIdKind {
+    GDB_ONE_THREAD = 0,
+    GDB_ALL_THREADS,     /* One process, all threads */
+    GDB_ALL_PROCESSES,
+    GDB_READ_THREAD_ERR
+} GDBThreadIdKind;
+
+typedef union GdbCmdVariant {
+    const char *data;
+    uint8_t opcode;
+    unsigned long val_ul;
+    unsigned long long val_ull;
+    struct {
+        GDBThreadIdKind kind;
+        uint32_t pid;
+        uint32_t tid;
+    } thread_id;
+} GdbCmdVariant;
+
+#define get_param(p, i)    (&g_array_index(p, GdbCmdVariant, i))
+
+void gdb_handle_query_rcmd(GArray *params, void *user_ctx); /* softmmu */
+
 /*
  * Break/Watch point support - there is an implementation for softmmu
  * and user mode.
diff --git a/gdbstub/gdbstub.c b/gdbstub/gdbstub.c
index f59ab12cc3..4b939c689c 100644
--- a/gdbstub/gdbstub.c
+++ b/gdbstub/gdbstub.c
@@ -24,8 +24,6 @@
  */
 
 #include "qemu/osdep.h"
-#include "qapi/error.h"
-#include "qemu/error-report.h"
 #include "qemu/ctype.h"
 #include "qemu/cutils.h"
 #include "qemu/module.h"
@@ -34,9 +32,6 @@
 #ifdef CONFIG_USER_ONLY
 #include "qemu.h"
 #else
-#include "monitor/monitor.h"
-#include "chardev/char.h"
-#include "chardev/char-fe.h"
 #include "hw/cpu/cluster.h"
 #include "hw/boards.h"
 #endif
@@ -88,30 +83,15 @@ static inline int target_memory_rw_debug(CPUState *cpu, target_ulong addr,
 /*
  * Return the GDB index for a given vCPU state.
  *
- * For user mode this is simply the thread id. In system mode GDB
- * numbers CPUs from 1 as 0 is reserved as an "any cpu" index.
+ * For user mode this is simply the thread id.
  */
+#if defined(CONFIG_USER_ONLY)
 int gdb_get_cpu_index(CPUState *cpu)
 {
-#if defined(CONFIG_USER_ONLY)
     TaskState *ts = (TaskState *) cpu->opaque;
     return ts ? ts->ts_tid : -1;
-#else
-    return cpu->cpu_index + 1;
-#endif
 }
-
-enum {
-    GDB_SIGNAL_0 = 0,
-    GDB_SIGNAL_INT = 2,
-    GDB_SIGNAL_QUIT = 3,
-    GDB_SIGNAL_TRAP = 5,
-    GDB_SIGNAL_ABRT = 6,
-    GDB_SIGNAL_ALRM = 14,
-    GDB_SIGNAL_IO = 23,
-    GDB_SIGNAL_XCPU = 24,
-    GDB_SIGNAL_UNKNOWN = 143
-};
+#endif
 
 #ifdef CONFIG_USER_ONLY
 
@@ -333,15 +313,9 @@ typedef struct {
     int running_state;
 } GDBUserState;
 static GDBUserState gdbserver_user_state;
-#else
-typedef struct {
-    CharBackend chr;
-    Chardev *mon_chr;
-} GDBSystemState;
-static GDBSystemState gdbserver_system_state;
 #endif
 
-static GDBState gdbserver_state;
+GDBState gdbserver_state;
 
 void gdb_init_gdbserver_state(void)
 {
@@ -362,15 +336,6 @@ void gdb_init_gdbserver_state(void)
     gdbserver_state.sstep_flags &= gdbserver_state.supported_sstep_flags;
 }
 
-#ifndef CONFIG_USER_ONLY
-static void reset_gdbserver_state(void)
-{
-    g_free(gdbserver_state.processes);
-    gdbserver_state.processes = NULL;
-    gdbserver_state.process_num = 0;
-}
-#endif
-
 bool gdb_has_xml;
 
 #ifdef CONFIG_USER_ONLY
@@ -446,7 +411,7 @@ static bool stub_can_reverse(void)
 }
 
 /* Resume execution.  */
-static inline void gdb_continue(void)
+static void gdb_continue(void)
 {
 
 #ifdef CONFIG_USER_ONLY
@@ -525,9 +490,9 @@ static int gdb_continue_partial(char *newstates)
     return res;
 }
 
+#ifdef CONFIG_USER_ONLY
 void gdb_put_buffer(const uint8_t *buf, int len)
 {
-#ifdef CONFIG_USER_ONLY
     int ret;
 
     while (len > 0) {
@@ -540,12 +505,8 @@ void gdb_put_buffer(const uint8_t *buf, int len)
             len -= ret;
         }
     }
-#else
-    /* XXX this blocks entire thread. Rewrite to use
-     * qemu_chr_fe_write and background I/O callbacks */
-    qemu_chr_fe_write_all(&gdbserver_system_state.chr, buf, len);
-#endif
 }
+#endif
 
 /* writes 2*len+1 bytes in buf */
 void gdb_memtohex(GString *buf, const uint8_t *mem, int len)
@@ -993,13 +954,6 @@ void gdb_append_thread_id(CPUState *cpu, GString *buf)
     }
 }
 
-typedef enum GDBThreadIdKind {
-    GDB_ONE_THREAD = 0,
-    GDB_ALL_THREADS,     /* One process, all threads */
-    GDB_ALL_PROCESSES,
-    GDB_READ_THREAD_ERR
-} GDBThreadIdKind;
-
 static GDBThreadIdKind read_thread_id(const char *buf, const char **end_buf,
                                       uint32_t *pid, uint32_t *tid)
 {
@@ -1180,20 +1134,6 @@ out:
     return res;
 }
 
-typedef union GdbCmdVariant {
-    const char *data;
-    uint8_t opcode;
-    unsigned long val_ul;
-    unsigned long long val_ull;
-    struct {
-        GDBThreadIdKind kind;
-        uint32_t pid;
-        uint32_t tid;
-    } thread_id;
-} GdbCmdVariant;
-
-#define get_param(p, i)    (&g_array_index(p, GdbCmdVariant, i))
-
 static const char *cmd_next_param(const char *param, const char delimiter)
 {
     static const char all_delimiters[] = ",;:=";
@@ -2025,32 +1965,6 @@ static void handle_query_offsets(GArray *params, void *user_ctx)
                     ts->info->data_offset);
     gdb_put_strbuf();
 }
-#else
-static void handle_query_rcmd(GArray *params, void *user_ctx)
-{
-    const guint8 zero = 0;
-    int len;
-
-    if (!params->len) {
-        gdb_put_packet("E22");
-        return;
-    }
-
-    len = strlen(get_param(params, 0)->data);
-    if (len % 2) {
-        gdb_put_packet("E01");
-        return;
-    }
-
-    g_assert(gdbserver_state.mem_buf->len == 0);
-    len = len / 2;
-    gdb_hextomem(gdbserver_state.mem_buf, get_param(params, 0)->data, len);
-    g_byte_array_append(gdbserver_state.mem_buf, &zero, 1);
-    qemu_chr_be_write(gdbserver_system_state.mon_chr,
-                      gdbserver_state.mem_buf->data,
-                      gdbserver_state.mem_buf->len);
-    gdb_put_packet("OK");
-}
 #endif
 
 static void handle_query_supported(GArray *params, void *user_ctx)
@@ -2264,7 +2178,7 @@ static const GdbCmdParseEntry gdb_gen_query_table[] = {
     },
 #else
     {
-        .handler = handle_query_rcmd,
+        .handler = gdb_handle_query_rcmd,
         .cmd = "Rcmd,",
         .cmd_startswith = 1,
         .schema = "s0"
@@ -2648,100 +2562,6 @@ void gdb_set_stop_cpu(CPUState *cpu)
     gdbserver_state.g_cpu = cpu;
 }
 
-#ifndef CONFIG_USER_ONLY
-static void gdb_vm_state_change(void *opaque, bool running, RunState state)
-{
-    CPUState *cpu = gdbserver_state.c_cpu;
-    g_autoptr(GString) buf = g_string_new(NULL);
-    g_autoptr(GString) tid = g_string_new(NULL);
-    const char *type;
-    int ret;
-
-    if (running || gdbserver_state.state == RS_INACTIVE) {
-        return;
-    }
-    /* Is there a GDB syscall waiting to be sent?  */
-    if (gdbserver_state.current_syscall_cb) {
-        gdb_put_packet(gdbserver_state.syscall_buf);
-        return;
-    }
-
-    if (cpu == NULL) {
-        /* No process attached */
-        return;
-    }
-
-    gdb_append_thread_id(cpu, tid);
-
-    switch (state) {
-    case RUN_STATE_DEBUG:
-        if (cpu->watchpoint_hit) {
-            switch (cpu->watchpoint_hit->flags & BP_MEM_ACCESS) {
-            case BP_MEM_READ:
-                type = "r";
-                break;
-            case BP_MEM_ACCESS:
-                type = "a";
-                break;
-            default:
-                type = "";
-                break;
-            }
-            trace_gdbstub_hit_watchpoint(type, gdb_get_cpu_index(cpu),
-                    (target_ulong)cpu->watchpoint_hit->vaddr);
-            g_string_printf(buf, "T%02xthread:%s;%swatch:" TARGET_FMT_lx ";",
-                            GDB_SIGNAL_TRAP, tid->str, type,
-                            (target_ulong)cpu->watchpoint_hit->vaddr);
-            cpu->watchpoint_hit = NULL;
-            goto send_packet;
-        } else {
-            trace_gdbstub_hit_break();
-        }
-        tb_flush(cpu);
-        ret = GDB_SIGNAL_TRAP;
-        break;
-    case RUN_STATE_PAUSED:
-        trace_gdbstub_hit_paused();
-        ret = GDB_SIGNAL_INT;
-        break;
-    case RUN_STATE_SHUTDOWN:
-        trace_gdbstub_hit_shutdown();
-        ret = GDB_SIGNAL_QUIT;
-        break;
-    case RUN_STATE_IO_ERROR:
-        trace_gdbstub_hit_io_error();
-        ret = GDB_SIGNAL_IO;
-        break;
-    case RUN_STATE_WATCHDOG:
-        trace_gdbstub_hit_watchdog();
-        ret = GDB_SIGNAL_ALRM;
-        break;
-    case RUN_STATE_INTERNAL_ERROR:
-        trace_gdbstub_hit_internal_error();
-        ret = GDB_SIGNAL_ABRT;
-        break;
-    case RUN_STATE_SAVE_VM:
-    case RUN_STATE_RESTORE_VM:
-        return;
-    case RUN_STATE_FINISH_MIGRATE:
-        ret = GDB_SIGNAL_XCPU;
-        break;
-    default:
-        trace_gdbstub_hit_unknown(state);
-        ret = GDB_SIGNAL_UNKNOWN;
-        break;
-    }
-    gdb_set_stop_cpu(cpu);
-    g_string_printf(buf, "T%02xthread:%s;", ret, tid->str);
-
-send_packet:
-    gdb_put_packet(buf->str);
-
-    /* disable single step if it was enabled */
-    cpu_single_step(cpu, 0);
-}
-#endif
-
 /* Send a gdb syscall request.
    This accepts limited printf-style format specifiers, specifically:
     %x  - target_ulong argument printed in hex.
@@ -2971,6 +2791,7 @@ void gdb_read_byte(uint8_t ch)
     }
 }
 
+#ifdef CONFIG_USER_ONLY
 /* Tell the remote gdb that the process has exited.  */
 void gdb_exit(int code)
 {
@@ -2979,24 +2800,19 @@ void gdb_exit(int code)
     if (!gdbserver_state.init) {
         return;
     }
-#ifdef CONFIG_USER_ONLY
     if (gdbserver_user_state.socket_path) {
         unlink(gdbserver_user_state.socket_path);
     }
     if (gdbserver_user_state.fd < 0) {
         return;
     }
-#endif
 
     trace_gdbstub_op_exiting((uint8_t)code);
 
     snprintf(buf, sizeof(buf), "W%02x", (uint8_t)code);
     gdb_put_packet(buf);
-
-#ifndef CONFIG_USER_ONLY
-    qemu_chr_fe_deinit(&gdbserver_system_state.chr, true);
-#endif
 }
+#endif
 
 /*
  * Create the process that will contain all the "orphan" CPUs (that are not
@@ -3252,221 +3068,4 @@ void gdbserver_fork(CPUState *cpu)
     cpu_breakpoint_remove_all(cpu, BP_GDB);
     cpu_watchpoint_remove_all(cpu, BP_GDB);
 }
-#else
-static int gdb_chr_can_receive(void *opaque)
-{
-  /* We can handle an arbitrarily large amount of data.
-   Pick the maximum packet size, which is as good as anything.  */
-  return MAX_PACKET_LENGTH;
-}
-
-static void gdb_chr_receive(void *opaque, const uint8_t *buf, int size)
-{
-    int i;
-
-    for (i = 0; i < size; i++) {
-        gdb_read_byte(buf[i]);
-    }
-}
-
-static void gdb_chr_event(void *opaque, QEMUChrEvent event)
-{
-    int i;
-    GDBState *s = (GDBState *) opaque;
-
-    switch (event) {
-    case CHR_EVENT_OPENED:
-        /* Start with first process attached, others detached */
-        for (i = 0; i < s->process_num; i++) {
-            s->processes[i].attached = !i;
-        }
-
-        s->c_cpu = gdb_first_attached_cpu();
-        s->g_cpu = s->c_cpu;
-
-        vm_stop(RUN_STATE_PAUSED);
-        replay_gdb_attached();
-        gdb_has_xml = false;
-        break;
-    default:
-        break;
-    }
-}
-
-static int gdb_monitor_write(Chardev *chr, const uint8_t *buf, int len)
-{
-    g_autoptr(GString) hex_buf = g_string_new("O");
-    gdb_memtohex(hex_buf, buf, len);
-    gdb_put_packet(hex_buf->str);
-    return len;
-}
-
-#ifndef _WIN32
-static void gdb_sigterm_handler(int signal)
-{
-    if (runstate_is_running()) {
-        vm_stop(RUN_STATE_PAUSED);
-    }
-}
-#endif
-
-static void gdb_monitor_open(Chardev *chr, ChardevBackend *backend,
-                             bool *be_opened, Error **errp)
-{
-    *be_opened = false;
-}
-
-static void char_gdb_class_init(ObjectClass *oc, void *data)
-{
-    ChardevClass *cc = CHARDEV_CLASS(oc);
-
-    cc->internal = true;
-    cc->open = gdb_monitor_open;
-    cc->chr_write = gdb_monitor_write;
-}
-
-#define TYPE_CHARDEV_GDB "chardev-gdb"
-
-static const TypeInfo char_gdb_type_info = {
-    .name = TYPE_CHARDEV_GDB,
-    .parent = TYPE_CHARDEV,
-    .class_init = char_gdb_class_init,
-};
-
-static int find_cpu_clusters(Object *child, void *opaque)
-{
-    if (object_dynamic_cast(child, TYPE_CPU_CLUSTER)) {
-        GDBState *s = (GDBState *) opaque;
-        CPUClusterState *cluster = CPU_CLUSTER(child);
-        GDBProcess *process;
-
-        s->processes = g_renew(GDBProcess, s->processes, ++s->process_num);
-
-        process = &s->processes[s->process_num - 1];
-
-        /*
-         * GDB process IDs -1 and 0 are reserved. To avoid subtle errors at
-         * runtime, we enforce here that the machine does not use a cluster ID
-         * that would lead to PID 0.
-         */
-        assert(cluster->cluster_id != UINT32_MAX);
-        process->pid = cluster->cluster_id + 1;
-        process->attached = false;
-        process->target_xml[0] = '\0';
-
-        return 0;
-    }
-
-    return object_child_foreach(child, find_cpu_clusters, opaque);
-}
-
-static int pid_order(const void *a, const void *b)
-{
-    GDBProcess *pa = (GDBProcess *) a;
-    GDBProcess *pb = (GDBProcess *) b;
-
-    if (pa->pid < pb->pid) {
-        return -1;
-    } else if (pa->pid > pb->pid) {
-        return 1;
-    } else {
-        return 0;
-    }
-}
-
-static void create_processes(GDBState *s)
-{
-    object_child_foreach(object_get_root(), find_cpu_clusters, s);
-
-    if (gdbserver_state.processes) {
-        /* Sort by PID */
-        qsort(gdbserver_state.processes, gdbserver_state.process_num, sizeof(gdbserver_state.processes[0]), pid_order);
-    }
-
-    gdb_create_default_process(s);
-}
-
-int gdbserver_start(const char *device)
-{
-    trace_gdbstub_op_start(device);
-
-    char gdbstub_device_name[128];
-    Chardev *chr = NULL;
-    Chardev *mon_chr;
-
-    if (!first_cpu) {
-        error_report("gdbstub: meaningless to attach gdb to a "
-                     "machine without any CPU.");
-        return -1;
-    }
-
-    if (!gdb_supports_guest_debug()) {
-        error_report("gdbstub: current accelerator doesn't support guest debugging");
-        return -1;
-    }
-
-    if (!device)
-        return -1;
-    if (strcmp(device, "none") != 0) {
-        if (strstart(device, "tcp:", NULL)) {
-            /* enforce required TCP attributes */
-            snprintf(gdbstub_device_name, sizeof(gdbstub_device_name),
-                     "%s,wait=off,nodelay=on,server=on", device);
-            device = gdbstub_device_name;
-        }
-#ifndef _WIN32
-        else if (strcmp(device, "stdio") == 0) {
-            struct sigaction act;
-
-            memset(&act, 0, sizeof(act));
-            act.sa_handler = gdb_sigterm_handler;
-            sigaction(SIGINT, &act, NULL);
-        }
-#endif
-        /*
-         * FIXME: it's a bit weird to allow using a mux chardev here
-         * and implicitly setup a monitor. We may want to break this.
-         */
-        chr = qemu_chr_new_noreplay("gdb", device, true, NULL);
-        if (!chr)
-            return -1;
-    }
-
-    if (!gdbserver_state.init) {
-        gdb_init_gdbserver_state();
-
-        qemu_add_vm_change_state_handler(gdb_vm_state_change, NULL);
-
-        /* Initialize a monitor terminal for gdb */
-        mon_chr = qemu_chardev_new(NULL, TYPE_CHARDEV_GDB,
-                                   NULL, NULL, &error_abort);
-        monitor_init_hmp(mon_chr, false, &error_abort);
-    } else {
-        qemu_chr_fe_deinit(&gdbserver_system_state.chr, true);
-        mon_chr = gdbserver_system_state.mon_chr;
-        reset_gdbserver_state();
-    }
-
-    create_processes(&gdbserver_state);
-
-    if (chr) {
-        qemu_chr_fe_init(&gdbserver_system_state.chr, chr, &error_abort);
-        qemu_chr_fe_set_handlers(&gdbserver_system_state.chr,
-                                 gdb_chr_can_receive,
-                                 gdb_chr_receive, gdb_chr_event,
-                                 NULL, &gdbserver_state, NULL, true);
-    }
-    gdbserver_state.state = chr ? RS_IDLE : RS_INACTIVE;
-    gdbserver_system_state.mon_chr = mon_chr;
-    gdbserver_state.current_syscall_cb = NULL;
-
-    return 0;
-}
-
-static void register_types(void)
-{
-    type_register_static(&char_gdb_type_info);
-}
-
-type_init(register_types);
 #endif
diff --git a/gdbstub/softmmu.c b/gdbstub/softmmu.c
index 05db6f8a9f..86a94f1519 100644
--- a/gdbstub/softmmu.c
+++ b/gdbstub/softmmu.c
@@ -11,10 +11,433 @@
  */
 
 #include "qemu/osdep.h"
+#include "qapi/error.h"
+#include "qemu/error-report.h"
+#include "qemu/cutils.h"
 #include "exec/gdbstub.h"
+#include "exec/hwaddr.h"
+#include "exec/tb-flush.h"
 #include "sysemu/cpus.h"
+#include "sysemu/runstate.h"
+#include "sysemu/replay.h"
+#include "hw/core/cpu.h"
+#include "hw/cpu/cluster.h"
+#include "hw/boards.h"
+#include "chardev/char.h"
+#include "chardev/char-fe.h"
+#include "monitor/monitor.h"
+#include "trace.h"
 #include "internals.h"
 
+/* System emulation specific state */
+typedef struct {
+    CharBackend chr;
+    Chardev *mon_chr;
+} GDBSystemState;
+
+GDBSystemState gdbserver_system_state;
+
+static void reset_gdbserver_state(void)
+{
+    g_free(gdbserver_state.processes);
+    gdbserver_state.processes = NULL;
+    gdbserver_state.process_num = 0;
+}
+
+/*
+ * Return the GDB index for a given vCPU state.
+ *
+ * In system mode GDB numbers CPUs from 1 as 0 is reserved as an "any
+ * cpu" index.
+ */
+int gdb_get_cpu_index(CPUState *cpu)
+{
+    return cpu->cpu_index + 1;
+}
+
+/*
+ * GDB Connection management. For system emulation we do all of this
+ * via our existing Chardev infrastructure which allows us to support
+ * network and unix sockets.
+ */
+
+void gdb_put_buffer(const uint8_t *buf, int len)
+{
+    /*
+     * XXX this blocks entire thread. Rewrite to use
+     * qemu_chr_fe_write and background I/O callbacks
+     */
+    qemu_chr_fe_write_all(&gdbserver_system_state.chr, buf, len);
+}
+
+static void gdb_chr_event(void *opaque, QEMUChrEvent event)
+{
+    int i;
+    GDBState *s = (GDBState *) opaque;
+
+    switch (event) {
+    case CHR_EVENT_OPENED:
+        /* Start with first process attached, others detached */
+        for (i = 0; i < s->process_num; i++) {
+            s->processes[i].attached = !i;
+        }
+
+        s->c_cpu = gdb_first_attached_cpu();
+        s->g_cpu = s->c_cpu;
+
+        vm_stop(RUN_STATE_PAUSED);
+        replay_gdb_attached();
+        gdb_has_xml = false;
+        break;
+    default:
+        break;
+    }
+}
+
+static void gdb_vm_state_change(void *opaque, bool running, RunState state)
+{
+    CPUState *cpu = gdbserver_state.c_cpu;
+    g_autoptr(GString) buf = g_string_new(NULL);
+    g_autoptr(GString) tid = g_string_new(NULL);
+    const char *type;
+    int ret;
+
+    if (running || gdbserver_state.state == RS_INACTIVE) {
+        return;
+    }
+    /* Is there a GDB syscall waiting to be sent?  */
+    if (gdbserver_state.current_syscall_cb) {
+        gdb_put_packet(gdbserver_state.syscall_buf);
+        return;
+    }
+
+    if (cpu == NULL) {
+        /* No process attached */
+        return;
+    }
+
+    gdb_append_thread_id(cpu, tid);
+
+    switch (state) {
+    case RUN_STATE_DEBUG:
+        if (cpu->watchpoint_hit) {
+            switch (cpu->watchpoint_hit->flags & BP_MEM_ACCESS) {
+            case BP_MEM_READ:
+                type = "r";
+                break;
+            case BP_MEM_ACCESS:
+                type = "a";
+                break;
+            default:
+                type = "";
+                break;
+            }
+            trace_gdbstub_hit_watchpoint(type,
+                                         gdb_get_cpu_index(cpu),
+                                         cpu->watchpoint_hit->vaddr);
+            g_string_printf(buf, "T%02xthread:%s;%swatch:%" VADDR_PRIx ";",
+                            GDB_SIGNAL_TRAP, tid->str, type,
+                            cpu->watchpoint_hit->vaddr);
+            cpu->watchpoint_hit = NULL;
+            goto send_packet;
+        } else {
+            trace_gdbstub_hit_break();
+        }
+        tb_flush(cpu);
+        ret = GDB_SIGNAL_TRAP;
+        break;
+    case RUN_STATE_PAUSED:
+        trace_gdbstub_hit_paused();
+        ret = GDB_SIGNAL_INT;
+        break;
+    case RUN_STATE_SHUTDOWN:
+        trace_gdbstub_hit_shutdown();
+        ret = GDB_SIGNAL_QUIT;
+        break;
+    case RUN_STATE_IO_ERROR:
+        trace_gdbstub_hit_io_error();
+        ret = GDB_SIGNAL_IO;
+        break;
+    case RUN_STATE_WATCHDOG:
+        trace_gdbstub_hit_watchdog();
+        ret = GDB_SIGNAL_ALRM;
+        break;
+    case RUN_STATE_INTERNAL_ERROR:
+        trace_gdbstub_hit_internal_error();
+        ret = GDB_SIGNAL_ABRT;
+        break;
+    case RUN_STATE_SAVE_VM:
+    case RUN_STATE_RESTORE_VM:
+        return;
+    case RUN_STATE_FINISH_MIGRATE:
+        ret = GDB_SIGNAL_XCPU;
+        break;
+    default:
+        trace_gdbstub_hit_unknown(state);
+        ret = GDB_SIGNAL_UNKNOWN;
+        break;
+    }
+    gdb_set_stop_cpu(cpu);
+    g_string_printf(buf, "T%02xthread:%s;", ret, tid->str);
+
+send_packet:
+    gdb_put_packet(buf->str);
+
+    /* disable single step if it was enabled */
+    cpu_single_step(cpu, 0);
+}
+
+#ifndef _WIN32
+static void gdb_sigterm_handler(int signal)
+{
+    if (runstate_is_running()) {
+        vm_stop(RUN_STATE_PAUSED);
+    }
+}
+#endif
+
+static int gdb_monitor_write(Chardev *chr, const uint8_t *buf, int len)
+{
+    g_autoptr(GString) hex_buf = g_string_new("O");
+    gdb_memtohex(hex_buf, buf, len);
+    gdb_put_packet(hex_buf->str);
+    return len;
+}
+
+static void gdb_monitor_open(Chardev *chr, ChardevBackend *backend,
+                             bool *be_opened, Error **errp)
+{
+    *be_opened = false;
+}
+
+static void char_gdb_class_init(ObjectClass *oc, void *data)
+{
+    ChardevClass *cc = CHARDEV_CLASS(oc);
+
+    cc->internal = true;
+    cc->open = gdb_monitor_open;
+    cc->chr_write = gdb_monitor_write;
+}
+
+#define TYPE_CHARDEV_GDB "chardev-gdb"
+
+static const TypeInfo char_gdb_type_info = {
+    .name = TYPE_CHARDEV_GDB,
+    .parent = TYPE_CHARDEV,
+    .class_init = char_gdb_class_init,
+};
+
+static int gdb_chr_can_receive(void *opaque)
+{
+  /*
+   * We can handle an arbitrarily large amount of data.
+   * Pick the maximum packet size, which is as good as anything.
+   */
+  return MAX_PACKET_LENGTH;
+}
+
+static void gdb_chr_receive(void *opaque, const uint8_t *buf, int size)
+{
+    int i;
+
+    for (i = 0; i < size; i++) {
+        gdb_read_byte(buf[i]);
+    }
+}
+
+static int find_cpu_clusters(Object *child, void *opaque)
+{
+    if (object_dynamic_cast(child, TYPE_CPU_CLUSTER)) {
+        GDBState *s = (GDBState *) opaque;
+        CPUClusterState *cluster = CPU_CLUSTER(child);
+        GDBProcess *process;
+
+        s->processes = g_renew(GDBProcess, s->processes, ++s->process_num);
+
+        process = &s->processes[s->process_num - 1];
+
+        /*
+         * GDB process IDs -1 and 0 are reserved. To avoid subtle errors at
+         * runtime, we enforce here that the machine does not use a cluster ID
+         * that would lead to PID 0.
+         */
+        assert(cluster->cluster_id != UINT32_MAX);
+        process->pid = cluster->cluster_id + 1;
+        process->attached = false;
+        process->target_xml[0] = '\0';
+
+        return 0;
+    }
+
+    return object_child_foreach(child, find_cpu_clusters, opaque);
+}
+
+static int pid_order(const void *a, const void *b)
+{
+    GDBProcess *pa = (GDBProcess *) a;
+    GDBProcess *pb = (GDBProcess *) b;
+
+    if (pa->pid < pb->pid) {
+        return -1;
+    } else if (pa->pid > pb->pid) {
+        return 1;
+    } else {
+        return 0;
+    }
+}
+
+static void create_processes(GDBState *s)
+{
+    object_child_foreach(object_get_root(), find_cpu_clusters, s);
+
+    if (gdbserver_state.processes) {
+        /* Sort by PID */
+        qsort(gdbserver_state.processes,
+              gdbserver_state.process_num,
+              sizeof(gdbserver_state.processes[0]),
+              pid_order);
+    }
+
+    gdb_create_default_process(s);
+}
+
+int gdbserver_start(const char *device)
+{
+    trace_gdbstub_op_start(device);
+
+    char gdbstub_device_name[128];
+    Chardev *chr = NULL;
+    Chardev *mon_chr;
+
+    if (!first_cpu) {
+        error_report("gdbstub: meaningless to attach gdb to a "
+                     "machine without any CPU.");
+        return -1;
+    }
+
+    if (!gdb_supports_guest_debug()) {
+        error_report("gdbstub: current accelerator doesn't "
+                     "support guest debugging");
+        return -1;
+    }
+
+    if (!device) {
+        return -1;
+    }
+    if (strcmp(device, "none") != 0) {
+        if (strstart(device, "tcp:", NULL)) {
+            /* enforce required TCP attributes */
+            snprintf(gdbstub_device_name, sizeof(gdbstub_device_name),
+                     "%s,wait=off,nodelay=on,server=on", device);
+            device = gdbstub_device_name;
+        }
+#ifndef _WIN32
+        else if (strcmp(device, "stdio") == 0) {
+            struct sigaction act;
+
+            memset(&act, 0, sizeof(act));
+            act.sa_handler = gdb_sigterm_handler;
+            sigaction(SIGINT, &act, NULL);
+        }
+#endif
+        /*
+         * FIXME: it's a bit weird to allow using a mux chardev here
+         * and implicitly setup a monitor. We may want to break this.
+         */
+        chr = qemu_chr_new_noreplay("gdb", device, true, NULL);
+        if (!chr) {
+            return -1;
+        }
+    }
+
+    if (!gdbserver_state.init) {
+        gdb_init_gdbserver_state();
+
+        qemu_add_vm_change_state_handler(gdb_vm_state_change, NULL);
+
+        /* Initialize a monitor terminal for gdb */
+        mon_chr = qemu_chardev_new(NULL, TYPE_CHARDEV_GDB,
+                                   NULL, NULL, &error_abort);
+        monitor_init_hmp(mon_chr, false, &error_abort);
+    } else {
+        qemu_chr_fe_deinit(&gdbserver_system_state.chr, true);
+        mon_chr = gdbserver_system_state.mon_chr;
+        reset_gdbserver_state();
+    }
+
+    create_processes(&gdbserver_state);
+
+    if (chr) {
+        qemu_chr_fe_init(&gdbserver_system_state.chr, chr, &error_abort);
+        qemu_chr_fe_set_handlers(&gdbserver_system_state.chr,
+                                 gdb_chr_can_receive,
+                                 gdb_chr_receive, gdb_chr_event,
+                                 NULL, &gdbserver_state, NULL, true);
+    }
+    gdbserver_state.state = chr ? RS_IDLE : RS_INACTIVE;
+    gdbserver_system_state.mon_chr = mon_chr;
+    gdbserver_state.current_syscall_cb = NULL;
+
+    return 0;
+}
+
+static void register_types(void)
+{
+    type_register_static(&char_gdb_type_info);
+}
+
+type_init(register_types);
+
+/* Tell the remote gdb that the process has exited.  */
+void gdb_exit(int code)
+{
+    char buf[4];
+
+    if (!gdbserver_state.init) {
+        return;
+    }
+
+    trace_gdbstub_op_exiting((uint8_t)code);
+
+    snprintf(buf, sizeof(buf), "W%02x", (uint8_t)code);
+    gdb_put_packet(buf);
+
+    qemu_chr_fe_deinit(&gdbserver_system_state.chr, true);
+}
+
+/*
+ * Softmmu specific command helpers
+ */
+void gdb_handle_query_rcmd(GArray *params, void *user_ctx)
+{
+    const guint8 zero = 0;
+    int len;
+
+    if (!params->len) {
+        gdb_put_packet("E22");
+        return;
+    }
+
+    len = strlen(get_param(params, 0)->data);
+    if (len % 2) {
+        gdb_put_packet("E01");
+        return;
+    }
+
+    g_assert(gdbserver_state.mem_buf->len == 0);
+    len = len / 2;
+    gdb_hextomem(gdbserver_state.mem_buf, get_param(params, 0)->data, len);
+    g_byte_array_append(gdbserver_state.mem_buf, &zero, 1);
+    qemu_chr_be_write(gdbserver_system_state.mon_chr,
+                      gdbserver_state.mem_buf->data,
+                      gdbserver_state.mem_buf->len);
+    gdb_put_packet("OK");
+}
+
+/*
+ * Break/Watch point helpers
+ */
+
 bool gdb_supports_guest_debug(void)
 {
     const AccelOpsClass *ops = cpus_get_accel();
diff --git a/gdbstub/trace-events b/gdbstub/trace-events
index 03f0c303bf..0c18a4d70a 100644
--- a/gdbstub/trace-events
+++ b/gdbstub/trace-events
@@ -7,7 +7,6 @@ gdbstub_op_continue(void) "Continuing all CPUs"
 gdbstub_op_continue_cpu(int cpu_index) "Continuing CPU %d"
 gdbstub_op_stepping(int cpu_index) "Stepping CPU %d"
 gdbstub_op_extra_info(const char *info) "Thread extra info: %s"
-gdbstub_hit_watchpoint(const char *type, int cpu_gdb_index, uint64_t vaddr) "Watchpoint hit, type=\"%s\" cpu=%d, vaddr=0x%" PRIx64 ""
 gdbstub_hit_internal_error(void) "RUN_STATE_INTERNAL_ERROR"
 gdbstub_hit_break(void) "RUN_STATE_DEBUG"
 gdbstub_hit_paused(void) "RUN_STATE_PAUSED"
@@ -27,3 +26,6 @@ gdbstub_err_invalid_repeat(uint8_t ch) "got invalid RLE count: 0x%02x"
 gdbstub_err_invalid_rle(void) "got invalid RLE sequence"
 gdbstub_err_checksum_invalid(uint8_t ch) "got invalid command checksum digit: 0x%02x"
 gdbstub_err_checksum_incorrect(uint8_t expected, uint8_t got) "got command packet with incorrect checksum, expected=0x%02x, received=0x%02x"
+
+# softmmu.c
+gdbstub_hit_watchpoint(const char *type, int cpu_gdb_index, uint64_t vaddr) "Watchpoint hit, type=\"%s\" cpu=%d, vaddr=0x%" PRIx64 ""
-- 
2.39.2

