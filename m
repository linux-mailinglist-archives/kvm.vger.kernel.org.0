Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42DD1309418
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 11:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbhA3KLv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jan 2021 05:11:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233093AbhA3Byn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 20:54:43 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D378EC06178A
        for <kvm@vger.kernel.org>; Fri, 29 Jan 2021 17:53:12 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id q7so10591248wre.13
        for <kvm@vger.kernel.org>; Fri, 29 Jan 2021 17:53:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9aLdl19C96C3GXRdvC9mwI7cbyJbYzl+Xi4/pdqV71I=;
        b=qxXJ6NS7gc+UGhx5DFTb2Xpax6DoUp1XDT6myxKlLWhft2T2JpgY0t/GcrbkAPA74S
         BYKzJUMJSUVzfGy8ahib79MmmFBxyR4C51gAaIk+IKe1ruKX31rhr/sQZfQIyKw5wrU/
         1hK3oMV0KFDk+pOoGsgAUL+Hzg3rp9RQLtbIAqNNQSgjushYDTMLUHnbKDGjBim56g9o
         NTH4trP5zRt4Djgg0ZMAiE0OskvRk8sUWZA13bfYoWDLJzMlRkxdTNC6X0pPEQosKjFj
         ZGk1FnxF2wKo59dWkyxHUJ3YCi/wdcYYO+prik3UxDZMOGyh0yuE3NsD7O32wT0hwbKE
         1BUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=9aLdl19C96C3GXRdvC9mwI7cbyJbYzl+Xi4/pdqV71I=;
        b=H/a7C4AgZr28t96bJ6/DaR9W5521UXBTYdaEwDXuamNOLwgZ2zxKvCiCVCFbg6Yh5E
         yY3iPPujW6pRLHezqf8d6+qyOFvDDojpNN8NhTmAeTZVJV0paUCTK4WNhi6sDVnjmm1u
         k1VW618Cj7dpxNbM/Gp6KBUxSDzDafjQ9NfpV62gnZi87ZO7f5mDiO4lzyajCqRMwEU7
         nXC1AC9puFZHOcWGS8xgk422KL7I60Ijd03vxkxfH43/75/pD7xoUofYhSaLnMYn/vQV
         OWjYeX02sJKPOdpxpQ2I6ky/1Hrx8sc7KW+2X3U9vHZvuyh94HWDXFCV/ZVfbA+deWwC
         zF7A==
X-Gm-Message-State: AOAM533fGIZktIp1oXpQpKyeSXAuye4ARoEUnxihf+tbBsnrqdKHIHAr
        N49/0BQPGnPAv5QB7D4Bp/U=
X-Google-Smtp-Source: ABdhPJzhiN23pGf2VqmdiIvY6PxgrMl9QORmviZzT3M+r/7egpP7DCxDAaxeN5Yt/ZE6GzZQSHs8ew==
X-Received: by 2002:a5d:5051:: with SMTP id h17mr7627630wrt.164.1611971591652;
        Fri, 29 Jan 2021 17:53:11 -0800 (PST)
Received: from localhost.localdomain (13.red-83-57-169.dynamicip.rima-tde.net. [83.57.169.13])
        by smtp.gmail.com with ESMTPSA id c18sm20017355wmk.0.2021.01.29.17.53.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 17:53:11 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
        Fam Zheng <fam@euphon.net>, Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Claudio Fontana <cfontana@suse.de>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v5 08/11] target/arm: Make m_helper.c optional via CONFIG_ARM_V7M
Date:   Sat, 30 Jan 2021 02:52:24 +0100
Message-Id: <20210130015227.4071332-9-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210130015227.4071332-1-f4bug@amsat.org>
References: <20210130015227.4071332-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

We've already got the CONFIG_ARM_V7M switch, but it currently can
not be disabled yet. The m_helper.c code should not be compiled
into the binary if the switch is not enabled. We also have to
provide some stubs in a separate file to make sure that we still
can link the other code without CONFIG_ARM_V7M.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20190903154810.27365-4-thuth@redhat.com>
[PMD: Keep m_helper-stub.c but extend it, rewrite the rest]
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
Rewrite since v3, therefore removed Richard R-b tag.
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/arm/cpu.h           | 12 -------
 target/arm/cpu_tcg.c       |  4 ++-
 target/arm/helper.c        |  7 ----
 target/arm/m_helper-stub.c | 73 ++++++++++++++++++++++++++++++++++++++
 target/arm/meson.build     |  4 ++-
 5 files changed, 79 insertions(+), 21 deletions(-)
 create mode 100644 target/arm/m_helper-stub.c

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index d080239863c..0bd0e51e498 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -2281,12 +2281,6 @@ uint32_t arm_phys_excp_target_el(CPUState *cs, uint32_t excp_idx,
 /* Interface between CPU and Interrupt controller.  */
 #ifndef CONFIG_USER_ONLY
 bool armv7m_nvic_can_take_pending_exception(void *opaque);
-#else
-static inline bool armv7m_nvic_can_take_pending_exception(void *opaque)
-{
-    return true;
-}
-#endif
 /**
  * armv7m_nvic_set_pending: mark the specified exception as pending
  * @opaque: the NVIC
@@ -2392,13 +2386,7 @@ int armv7m_nvic_raw_execution_priority(void *opaque);
  * @secure: the security state to test
  * This corresponds to the pseudocode IsReqExecPriNeg().
  */
-#ifndef CONFIG_USER_ONLY
 bool armv7m_nvic_neg_prio_requested(void *opaque, bool secure);
-#else
-static inline bool armv7m_nvic_neg_prio_requested(void *opaque, bool secure)
-{
-    return false;
-}
 #endif
 
 /* Interface for defining coprocessor registers.
diff --git a/target/arm/cpu_tcg.c b/target/arm/cpu_tcg.c
index 98544db2df3..3e1c9b40353 100644
--- a/target/arm/cpu_tcg.c
+++ b/target/arm/cpu_tcg.c
@@ -15,6 +15,7 @@
 /* CPU models. These are not needed for the AArch64 linux-user build. */
 #if !defined(CONFIG_USER_ONLY) || !defined(TARGET_AARCH64)
 
+#ifndef CONFIG_USER_ONLY
 static bool arm_v7m_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
     CPUClass *cc = CPU_GET_CLASS(cs);
@@ -38,6 +39,7 @@ static bool arm_v7m_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
     }
     return ret;
 }
+#endif /* CONFIG_USER_ONLY */
 
 static void arm926_initfn(Object *obj)
 {
@@ -666,9 +668,9 @@ static void arm_v7m_class_init(ObjectClass *oc, void *data)
     acc->info = data;
 #ifndef CONFIG_USER_ONLY
     cc->do_interrupt = arm_v7m_cpu_do_interrupt;
+    cc->cpu_exec_interrupt = arm_v7m_cpu_exec_interrupt;
 #endif
 
-    cc->cpu_exec_interrupt = arm_v7m_cpu_exec_interrupt;
     cc->gdb_core_xml_file = "arm-m-profile.xml";
 }
 
diff --git a/target/arm/helper.c b/target/arm/helper.c
index 47e266d7e64..fe3d0291f9c 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -12825,13 +12825,6 @@ int arm_mmu_idx_to_el(ARMMMUIdx mmu_idx)
     }
 }
 
-#ifndef CONFIG_TCG
-ARMMMUIdx arm_v7m_mmu_idx_for_secstate(CPUARMState *env, bool secstate)
-{
-    g_assert_not_reached();
-}
-#endif
-
 ARMMMUIdx arm_mmu_idx_el(CPUARMState *env, int el)
 {
     ARMMMUIdx idx;
diff --git a/target/arm/m_helper-stub.c b/target/arm/m_helper-stub.c
new file mode 100644
index 00000000000..6d751424e86
--- /dev/null
+++ b/target/arm/m_helper-stub.c
@@ -0,0 +1,73 @@
+/*
+ * ARM V7M related stubs.
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+#include "qemu/osdep.h"
+#include "cpu.h"
+#include "exec/helper-proto.h"
+#include "internals.h"
+
+void HELPER(v7m_bxns)(CPUARMState *env, uint32_t dest)
+{
+    g_assert_not_reached();
+}
+
+void HELPER(v7m_blxns)(CPUARMState *env, uint32_t dest)
+{
+    g_assert_not_reached();
+}
+
+uint32_t HELPER(v7m_mrs)(CPUARMState *env, uint32_t reg)
+{
+    g_assert_not_reached();
+}
+
+void HELPER(v7m_msr)(CPUARMState *env, uint32_t maskreg, uint32_t val)
+{
+    g_assert_not_reached();
+}
+
+uint32_t HELPER(v7m_tt)(CPUARMState *env, uint32_t addr, uint32_t op)
+{
+    g_assert_not_reached();
+}
+
+void HELPER(v7m_preserve_fp_state)(CPUARMState *env)
+{
+    g_assert_not_reached();
+}
+
+void write_v7m_exception(CPUARMState *env, uint32_t new_exc)
+{
+    g_assert_not_reached();
+}
+
+void HELPER(v7m_vlldm)(CPUARMState *env, uint32_t fptr)
+{
+    g_assert_not_reached();
+}
+
+void HELPER(v7m_vlstm)(CPUARMState *env, uint32_t fptr)
+{
+    g_assert_not_reached();
+}
+
+ARMMMUIdx arm_v7m_mmu_idx_for_secstate(CPUARMState *env, bool secstate)
+{
+    g_assert_not_reached();
+}
+
+#ifndef CONFIG_USER_ONLY
+
+bool armv7m_nvic_can_take_pending_exception(void *opaque)
+{
+    g_assert_not_reached();
+}
+
+void arm_v7m_cpu_do_interrupt(CPUState *cs)
+{
+    g_assert_not_reached();
+}
+
+#endif /* CONFIG_USER_ONLY */
diff --git a/target/arm/meson.build b/target/arm/meson.build
index 15b936c1010..6c6081966cd 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -21,7 +21,6 @@
   'gdbstub.c',
   'helper.c',
   'iwmmxt_helper.c',
-  'm_helper.c',
   'neon_helper.c',
   'op_helper.c',
   'tlb_helper.c',
@@ -32,6 +31,9 @@
 ))
 arm_ss.add(zlib)
 
+arm_ss.add(when: 'CONFIG_ARM_V7M', if_true: files('m_helper.c'), if_false: files('m_helper-stub.c'))
+arm_ss.add(when: 'CONFIG_TCG', if_false: files('m_helper-stub.c'))
+
 arm_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c', 'kvm64.c'), if_false: files('kvm-stub.c'))
 
 arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
-- 
2.26.2

