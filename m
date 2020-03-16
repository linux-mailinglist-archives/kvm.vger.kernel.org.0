Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9E26186FC5
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 17:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732060AbgCPQOP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 12:14:15 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:29468 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732082AbgCPQOO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 12:14:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584375253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sJ9bxuRVskXYC2aJKl03+Z9cSr20F7Dbm9JRwxmo2e4=;
        b=fVbW+HJRVZyANTcxvQClZyNE3N9P+nz6AXBkuhcp9eUVOonTyKVsbD0sz+U1ryVb0vYxFF
        NqLEzjboAQrZM2Iu5W/lneoIYX7y2SFBwXZ79IN6driUHV37tB97oDGTJ0hPts9U27h/7c
        0TjhoH53Bw5GnushtmNjvn6218AiER8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-ULMw-yoBOE-rp-7oxgxqTA-1; Mon, 16 Mar 2020 12:08:02 -0400
X-MC-Unique: ULMw-yoBOE-rp-7oxgxqTA-1
Received: by mail-wm1-f71.google.com with SMTP id m4so6002111wmi.5
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 09:08:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sJ9bxuRVskXYC2aJKl03+Z9cSr20F7Dbm9JRwxmo2e4=;
        b=XNi8v47BfQ/X2xg2TJbSiAKLBLYrd4RU8+xjtwlsHyzSc9WXRTyVJLr4wbd3A6f8C/
         pv2Z1GizpysnhMxt3xC4uIhFZUocG6F8mdBFwC7WhW3QqC5Dc0WP1+cNZXokXSfqDvJX
         9gmyRMCJQKwB+xQpF6AgsGYrUagiY1os2lkACzz8jVPP60CozQhOHG5SUKnFcSjRh01j
         g1jE6MEuvbPrkvsvx6rSbRu+sZuXQcJFMG3TAkRiTTmK4I7Ldh6ZWnbEH5+/2ciYyT3s
         sythxpWmMHCYa/6hhm4wU4uz65uFSJ+/LMWe8YHlDBgjOJJGue0nvVc22a7ixGcXQ0OR
         e/6A==
X-Gm-Message-State: ANhLgQ0VFYezDl5sAr08CPy2U4BvR8c8GAe+yQrkW9K2crf1NY+wxlIf
        5oOoAGiGkDv3bkl6g51HbH5ZceutYqfcQEhM1mXXYA2aNAEY92xXhNkZOHXYON3Jwi6XhNGLlWH
        7qiDCAGu7wQvw
X-Received: by 2002:a5d:4488:: with SMTP id j8mr96062wrq.306.1584374879942;
        Mon, 16 Mar 2020 09:07:59 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsZjM9PYbzB11qOc3TO2Yn7YNmN1hMQ0DyCXu0fd112HXe4vZCCLfxIEsZneEmH7TNa6quBUA==
X-Received: by 2002:a5d:4488:: with SMTP id j8mr96041wrq.306.1584374879656;
        Mon, 16 Mar 2020 09:07:59 -0700 (PDT)
Received: from localhost.localdomain (96.red-83-59-163.dynamicip.rima-tde.net. [83.59.163.96])
        by smtp.gmail.com with ESMTPSA id f203sm206459wmf.18.2020.03.16.09.07.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 09:07:59 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v3 15/19] target/arm: Make m_helper.c optional via CONFIG_ARM_V7M
Date:   Mon, 16 Mar 2020 17:06:30 +0100
Message-Id: <20200316160634.3386-16-philmd@redhat.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200316160634.3386-1-philmd@redhat.com>
References: <20200316160634.3386-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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
[PMD: add write_v7m_exception() stub when not using TCG,
      remove CONFIG_ARM_V7M=y in default-configs/arm-softmmu.mak]
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 default-configs/arm-softmmu.mak |  6 ----
 target/arm/cpu.h                |  7 ++++
 target/arm/m_helper-stub.c      | 59 +++++++++++++++++++++++++++++++++
 target/arm/Makefile.objs        |  3 +-
 4 files changed, 68 insertions(+), 7 deletions(-)
 create mode 100644 target/arm/m_helper-stub.c

diff --git a/default-configs/arm-softmmu.mak b/default-configs/arm-softmmu.mak
index 511d74da58..7ae8006556 100644
--- a/default-configs/arm-softmmu.mak
+++ b/default-configs/arm-softmmu.mak
@@ -1,11 +1,5 @@
 # Default configuration for arm-softmmu
 
-# CONFIG_SEMIHOSTING is always required on this architecture
-CONFIG_SEMIHOSTING=y
-
-# TODO: ARM_V7M is currently always required - make this more flexible!
-CONFIG_ARM_V7M=y
-
 # CONFIG_PCI_DEVICES=n
 # CONFIG_TEST_DEVICES=n
 
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 4ffd991b6f..84e14ce5a9 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -1278,7 +1278,14 @@ void pmu_init(ARMCPU *cpu);
 /* Write a new value to v7m.exception, thus transitioning into or out
  * of Handler mode; this may result in a change of active stack pointer.
  */
+#if !defined(CONFIG_TCG)
+static inline void write_v7m_exception(CPUARMState *env, uint32_t new_exc)
+{
+    g_assert_not_reached();
+}
+#else
 void write_v7m_exception(CPUARMState *env, uint32_t new_exc);
+#endif
 
 /* Map EL and handler into a PSTATE_MODE.  */
 static inline unsigned int aarch64_pstate_mode(unsigned int el, bool handler)
diff --git a/target/arm/m_helper-stub.c b/target/arm/m_helper-stub.c
new file mode 100644
index 0000000000..9316a9995b
--- /dev/null
+++ b/target/arm/m_helper-stub.c
@@ -0,0 +1,59 @@
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
+    abort();
+}
+
+void HELPER(v7m_blxns)(CPUARMState *env, uint32_t dest)
+{
+    abort();
+}
+
+uint32_t HELPER(v7m_mrs)(CPUARMState *env, uint32_t reg)
+{
+    abort();
+}
+
+void HELPER(v7m_msr)(CPUARMState *env, uint32_t maskreg, uint32_t val)
+{
+    abort();
+}
+
+uint32_t HELPER(v7m_tt)(CPUARMState *env, uint32_t addr, uint32_t op)
+{
+    abort();
+}
+
+void HELPER(v7m_preserve_fp_state)(CPUARMState *env)
+{
+    abort();
+}
+
+void write_v7m_exception(CPUARMState *env, uint32_t new_exc)
+{
+    abort();
+}
+
+void HELPER(v7m_vlldm)(CPUARMState *env, uint32_t fptr)
+{
+    abort();
+}
+
+void HELPER(v7m_vlstm)(CPUARMState *env, uint32_t fptr)
+{
+    abort();
+}
+
+ARMMMUIdx arm_v7m_mmu_idx_for_secstate(CPUARMState *env, bool secstate)
+{
+    abort();
+}
diff --git a/target/arm/Makefile.objs b/target/arm/Makefile.objs
index a0df58526b..993899d731 100644
--- a/target/arm/Makefile.objs
+++ b/target/arm/Makefile.objs
@@ -66,7 +66,8 @@ obj-y += tlb_helper.o debug_helper.o
 obj-y += translate.o op_helper.o
 obj-y += crypto_helper.o
 obj-y += iwmmxt_helper.o vec_helper.o neon_helper.o
-obj-y += m_helper.o
+obj-$(CONFIG_ARM_V7M) += m_helper.o
+obj-$(call lnot,$(CONFIG_ARM_V7M)) += m_helper-stub.o
 
 obj-$(CONFIG_ARM_V4) += cpu_v4.o
 obj-$(CONFIG_ARM_V5) += cpu_v5.o
-- 
2.21.1

