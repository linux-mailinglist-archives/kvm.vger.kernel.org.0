Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20BC55F442A
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 15:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiJDNUt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 09:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbiJDNUO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 09:20:14 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC921572F
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 06:20:03 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id y23-20020a1c4b17000000b003bd336914f9so787288wma.4
        for <kvm@vger.kernel.org>; Tue, 04 Oct 2022 06:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=MgJTGDBpQjQGrnVMnG5+sJMGIGyBv0ba2UQsV9L2XME=;
        b=HQA8XocsV0dRxud33n0KjAkB+ITX2AQ8MzxWFQZnYnjffdkDAPrLXEMoPdKVHL+D4t
         rbjFIskRE02a063tYssEZ5Mnzh10ULdqkMdkDfQsEjGrrKQUGnYSUUHAtemogWClOHn/
         e6Q88Q4x6fYQ8R+fwR2rFyQbmW892UQZkxSxKHw8awkp+IUsX5q6NlP2Gxr4/wL81ppS
         b9rsqfpFYtUOAxP5T3pIUjfvE1Cn6QZ5vDvTjln1PziXTn5zaIg6xip2LtfjhwGBZzO9
         ONX5qzNBUg4hSfEyPi/RM7K01sPPHqEu4KAJYySKGpjECP5V6TOlmxwbXEWCeDqt2IUt
         T4Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=MgJTGDBpQjQGrnVMnG5+sJMGIGyBv0ba2UQsV9L2XME=;
        b=C9sXXUE+0Aib6+IPm0AEZkR/DPaZqNXMG1lEh1b6j61nWO7M3lb21vIG5Qv5A49PJz
         /CLKpzReDuYC+bLQyf9ev3qc0jk4TkS1z8xbcwSJqb+3x0KvSlrSYROvcx8Lp4JL+p0c
         MFZsTFPdNlrflC5qC9lDmbmTG0pElMBU4WkewLf03Ivua2RCi+WM/o4Rs27N2iiQzt+Y
         WTRZwr39rlD0zSDiJEIjMWxrJ7VNKWHIM46CNjUQc3v6tPNIfmlppjk1aHV8tfkY6D8w
         NHNWgY/GR4KVtYLHzUErcorKG/eluNPBD+b07SjxHvItUT+wRQ/Dl5G/TdvkpCKefvIj
         OyuQ==
X-Gm-Message-State: ACrzQf1nojTFQaSVkiHnAGmBUyAwO9rTBVFjqycCWiTPlrPmSn/9Wag0
        152G/a2OpJWD434VD21NcTAQLoWGjRCp7g==
X-Google-Smtp-Source: AMsMyM4GgzZTJg1GvVCHM4C7u1n7Yx/pqJGwQ7/ZbX1+58cVDXz5lGDor+jgJ/TnTHRfbtrQzxHhFg==
X-Received: by 2002:a05:600c:1c1f:b0:3b4:8330:5a46 with SMTP id j31-20020a05600c1c1f00b003b483305a46mr10355125wms.45.1664889601304;
        Tue, 04 Oct 2022 06:20:01 -0700 (PDT)
Received: from zen.linaroharston ([185.81.254.11])
        by smtp.gmail.com with ESMTPSA id c63-20020a1c3542000000b003a6a3595edasm14802503wma.27.2022.10.04.06.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 06:19:58 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 2DB851FFDE;
        Tue,  4 Oct 2022 14:01:43 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     stefanha@redhat.com,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Mads Ynddal <mads@ynddal.dk>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [PULL 43/54] gdbstub: move sstep flags probing into AccelClass
Date:   Tue,  4 Oct 2022 14:01:27 +0100
Message-Id: <20221004130138.2299307-44-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221004130138.2299307-1-alex.bennee@linaro.org>
References: <20221004130138.2299307-1-alex.bennee@linaro.org>
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

The support of single-stepping is very much dependent on support from
the accelerator we are using. To avoid special casing in gdbstub move
the probing out to an AccelClass function so future accelerators can
put their code there.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Mads Ynddal <mads@ynddal.dk>
Message-Id: <20220929114231.583801-44-alex.bennee@linaro.org>

diff --git a/include/qemu/accel.h b/include/qemu/accel.h
index be56da1b99..ce4747634a 100644
--- a/include/qemu/accel.h
+++ b/include/qemu/accel.h
@@ -43,6 +43,10 @@ typedef struct AccelClass {
     bool (*has_memory)(MachineState *ms, AddressSpace *as,
                        hwaddr start_addr, hwaddr size);
 #endif
+
+    /* gdbstub related hooks */
+    int (*gdbstub_supported_sstep_flags)(void);
+
     bool *allowed;
     /*
      * Array of global properties that would be applied when specific
@@ -92,4 +96,12 @@ void accel_cpu_instance_init(CPUState *cpu);
  */
 bool accel_cpu_realizefn(CPUState *cpu, Error **errp);
 
+/**
+ * accel_supported_gdbstub_sstep_flags:
+ *
+ * Returns the supported single step modes for the configured
+ * accelerator.
+ */
+int accel_supported_gdbstub_sstep_flags(void);
+
 #endif /* QEMU_ACCEL_H */
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index efd6dee818..a20ad51aad 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -47,7 +47,6 @@ extern bool kvm_direct_msi_allowed;
 extern bool kvm_ioeventfd_any_length_allowed;
 extern bool kvm_msi_use_devid;
 extern bool kvm_has_guest_debug;
-extern int kvm_sstep_flags;
 
 #define kvm_enabled()           (kvm_allowed)
 /**
@@ -174,12 +173,6 @@ extern int kvm_sstep_flags;
  */
 #define kvm_supports_guest_debug() (kvm_has_guest_debug)
 
-/*
- * kvm_supported_sstep_flags
- * Returns: SSTEP_* flags that KVM supports for guest debug
- */
-#define kvm_get_supported_sstep_flags() (kvm_sstep_flags)
-
 #else
 
 #define kvm_enabled()           (0)
@@ -198,7 +191,6 @@ extern int kvm_sstep_flags;
 #define kvm_ioeventfd_any_length_enabled() (false)
 #define kvm_msi_devid_required() (false)
 #define kvm_supports_guest_debug() (false)
-#define kvm_get_supported_sstep_flags() (0)
 
 #endif  /* CONFIG_KVM_IS_POSSIBLE */
 
diff --git a/accel/accel-common.c b/accel/accel-common.c
index 50035bda55..df72cc989a 100644
--- a/accel/accel-common.c
+++ b/accel/accel-common.c
@@ -129,6 +129,16 @@ bool accel_cpu_realizefn(CPUState *cpu, Error **errp)
     return true;
 }
 
+int accel_supported_gdbstub_sstep_flags(void)
+{
+    AccelState *accel = current_accel();
+    AccelClass *acc = ACCEL_GET_CLASS(accel);
+    if (acc->gdbstub_supported_sstep_flags) {
+        return acc->gdbstub_supported_sstep_flags();
+    }
+    return 0;
+}
+
 static const TypeInfo accel_cpu_type = {
     .name = TYPE_ACCEL_CPU,
     .parent = TYPE_OBJECT,
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 5acab1767f..c55938453a 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -175,7 +175,7 @@ bool kvm_direct_msi_allowed;
 bool kvm_ioeventfd_any_length_allowed;
 bool kvm_msi_use_devid;
 bool kvm_has_guest_debug;
-int kvm_sstep_flags;
+static int kvm_sstep_flags;
 static bool kvm_immediate_exit;
 static hwaddr kvm_max_slot_size = ~0;
 
@@ -3712,6 +3712,17 @@ static void kvm_accel_instance_init(Object *obj)
     s->kvm_dirty_ring_size = 0;
 }
 
+/**
+ * kvm_gdbstub_sstep_flags():
+ *
+ * Returns: SSTEP_* flags that KVM supports for guest debug. The
+ * support is probed during kvm_init()
+ */
+static int kvm_gdbstub_sstep_flags(void)
+{
+    return kvm_sstep_flags;
+}
+
 static void kvm_accel_class_init(ObjectClass *oc, void *data)
 {
     AccelClass *ac = ACCEL_CLASS(oc);
@@ -3719,6 +3730,7 @@ static void kvm_accel_class_init(ObjectClass *oc, void *data)
     ac->init_machine = kvm_init;
     ac->has_memory = kvm_accel_has_memory;
     ac->allowed = &kvm_allowed;
+    ac->gdbstub_supported_sstep_flags = kvm_gdbstub_sstep_flags;
 
     object_class_property_add(oc, "kernel-irqchip", "on|off|split",
         NULL, kvm_set_kernel_irqchip,
diff --git a/accel/tcg/tcg-all.c b/accel/tcg/tcg-all.c
index 47952eecd7..30b503fb22 100644
--- a/accel/tcg/tcg-all.c
+++ b/accel/tcg/tcg-all.c
@@ -25,6 +25,7 @@
 
 #include "qemu/osdep.h"
 #include "sysemu/tcg.h"
+#include "sysemu/replay.h"
 #include "sysemu/cpu-timers.h"
 #include "tcg/tcg.h"
 #include "qapi/error.h"
@@ -207,12 +208,28 @@ static void tcg_set_splitwx(Object *obj, bool value, Error **errp)
     s->splitwx_enabled = value;
 }
 
+static int tcg_gdbstub_supported_sstep_flags(void)
+{
+    /*
+     * In replay mode all events will come from the log and can't be
+     * suppressed otherwise we would break determinism. However as those
+     * events are tied to the number of executed instructions we won't see
+     * them occurring every time we single step.
+     */
+    if (replay_mode != REPLAY_MODE_NONE) {
+        return SSTEP_ENABLE;
+    } else {
+        return SSTEP_ENABLE | SSTEP_NOIRQ | SSTEP_NOTIMER;
+    }
+}
+
 static void tcg_accel_class_init(ObjectClass *oc, void *data)
 {
     AccelClass *ac = ACCEL_CLASS(oc);
     ac->name = "tcg";
     ac->init_machine = tcg_init_machine;
     ac->allowed = &tcg_allowed;
+    ac->gdbstub_supported_sstep_flags = tcg_gdbstub_supported_sstep_flags;
 
     object_class_property_add_str(oc, "thread",
                                   tcg_get_thread,
diff --git a/gdbstub/gdbstub.c b/gdbstub/gdbstub.c
index 7d8fe475b3..a0755e6505 100644
--- a/gdbstub/gdbstub.c
+++ b/gdbstub/gdbstub.c
@@ -383,27 +383,13 @@ static void init_gdbserver_state(void)
     gdbserver_state.last_packet = g_byte_array_sized_new(MAX_PACKET_LENGTH + 4);
 
     /*
-     * In replay mode all events will come from the log and can't be
-     * suppressed otherwise we would break determinism. However as those
-     * events are tied to the number of executed instructions we won't see
-     * them occurring every time we single step.
-     */
-    if (replay_mode != REPLAY_MODE_NONE) {
-        gdbserver_state.supported_sstep_flags = SSTEP_ENABLE;
-    } else if (kvm_enabled()) {
-        gdbserver_state.supported_sstep_flags = kvm_get_supported_sstep_flags();
-    } else {
-        gdbserver_state.supported_sstep_flags =
-            SSTEP_ENABLE | SSTEP_NOIRQ | SSTEP_NOTIMER;
-    }
-
-    /*
-     * By default use no IRQs and no timers while single stepping so as to
-     * make single stepping like an ICE HW step.
+     * What single-step modes are supported is accelerator dependent.
+     * By default try to use no IRQs and no timers while single
+     * stepping so as to make single stepping like a typical ICE HW step.
      */
+    gdbserver_state.supported_sstep_flags = accel_supported_gdbstub_sstep_flags();
     gdbserver_state.sstep_flags = SSTEP_ENABLE | SSTEP_NOIRQ | SSTEP_NOTIMER;
     gdbserver_state.sstep_flags &= gdbserver_state.supported_sstep_flags;
-
 }
 
 #ifndef CONFIG_USER_ONLY
-- 
2.34.1

