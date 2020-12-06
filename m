Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17F5B2D081B
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 00:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728538AbgLFXlZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 18:41:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727468AbgLFXlY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Dec 2020 18:41:24 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6A6C0613D0
        for <kvm@vger.kernel.org>; Sun,  6 Dec 2020 15:40:39 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id a12so4230992wrv.8
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 15:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m3yW7Q/kZO8O6aW6XbRUlcf0EmcrkqsX0rg11stnjUs=;
        b=q2xge+aIvR1sBZv4AWVUi6UC4i1ICC7CvStloK6ObHRbBh/Xhnh3/ZQ8/gaPbj/imf
         J1yZ0a82F0Hh75erzBJDt3bQ231e6t50hzFZre7FvGxZseLzrOtZIBQYRk96/9GT6s7v
         cjrdZBpvMKAjMoH9jPG9HOJM72zVHuGnEMN1UBtdciWNQRdvFMoJE0PE8UMLXXu7WaCX
         gaLrNNDJhQe5Nj6xlgfMov6atxHx3ShKd7NMlCfIz/1hjXQudQsgisrmluQvmocmvgG0
         RO6RA9qBs0DPcPUtOHQl7ZqzDBYwlKDtYpppa3KD/r85zxnFz4wdat6OW5kOR0RnnVWX
         ZyfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=m3yW7Q/kZO8O6aW6XbRUlcf0EmcrkqsX0rg11stnjUs=;
        b=Dlpfol04sUYDGhTIGAJT5xKuVZsDHFA9v422b0GxSEoe0znhvu8Gbmlc0UfP24GTBo
         JRUHnLtDcvmqv71JhmBExCLYYig+/yR/ofYXX6ZSrp2tiTK49Z/JbHg1pPdaPKIV1fC/
         XTS6ilhCyupCyuy44Gia/H/4qMlEv7rc/ZJmYAQVikiVnrl8nJdP1TV0bDbTvWCp/CuT
         CwQX7PJLy3ZWkOF3JfypgXYogdL6HqY0ipTDN3sKEFc0Nb3xAKuB+9tRwbAIa5m8VNJT
         xWDhGtnq6Bqd+MfZUfFaEegJqFl5H9BFkq0mPABzmXIGPzv9iyOXgtdjEU9IdbiYfEaV
         Q/+Q==
X-Gm-Message-State: AOAM530caoTy4NSluCLgm55pHz/uQNH71oU4xuvKUexsupOM398ghmA7
        yi29zadZyNdOFsjGG8WC73o=
X-Google-Smtp-Source: ABdhPJwFcv3NFWbse7VYk8f1/MogekTdhhYhfUCC6z6eGhN/SHrc0wkos4mLTsztd6KyNRJ5ZrurGA==
X-Received: by 2002:adf:b194:: with SMTP id q20mr5061839wra.199.1607298038017;
        Sun, 06 Dec 2020 15:40:38 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id 94sm3638043wrq.22.2020.12.06.15.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 15:40:37 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 09/19] target/mips: Move mips_cpu_add_definition() from helper.c to cpu.c
Date:   Mon,  7 Dec 2020 00:39:39 +0100
Message-Id: <20201206233949.3783184-10-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201206233949.3783184-1-f4bug@amsat.org>
References: <20201206233949.3783184-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/cpu.c    | 33 +++++++++++++++++++++++++++++++++
 target/mips/helper.c | 33 ---------------------------------
 2 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index 8d9ef139f07..e612a7ac41a 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -30,6 +30,7 @@
 #include "exec/exec-all.h"
 #include "hw/qdev-properties.h"
 #include "hw/qdev-clock.h"
+#include "qapi/qapi-commands-machine-target.h"
 
 static void mips_cpu_set_pc(CPUState *cs, vaddr value)
 {
@@ -299,6 +300,38 @@ static void mips_cpu_register_types(void)
 
 type_init(mips_cpu_register_types)
 
+static void mips_cpu_add_definition(gpointer data, gpointer user_data)
+{
+    ObjectClass *oc = data;
+    CpuDefinitionInfoList **cpu_list = user_data;
+    CpuDefinitionInfoList *entry;
+    CpuDefinitionInfo *info;
+    const char *typename;
+
+    typename = object_class_get_name(oc);
+    info = g_malloc0(sizeof(*info));
+    info->name = g_strndup(typename,
+                           strlen(typename) - strlen("-" TYPE_MIPS_CPU));
+    info->q_typename = g_strdup(typename);
+
+    entry = g_malloc0(sizeof(*entry));
+    entry->value = info;
+    entry->next = *cpu_list;
+    *cpu_list = entry;
+}
+
+CpuDefinitionInfoList *qmp_query_cpu_definitions(Error **errp)
+{
+    CpuDefinitionInfoList *cpu_list = NULL;
+    GSList *list;
+
+    list = object_class_get_list(TYPE_MIPS_CPU, false);
+    g_slist_foreach(list, mips_cpu_add_definition, &cpu_list);
+    g_slist_free(list);
+
+    return cpu_list;
+}
+
 /* Could be used by generic CPU object */
 MIPSCPU *mips_cpu_create_with_clock(const char *cpu_type, Clock *cpu_refclk)
 {
diff --git a/target/mips/helper.c b/target/mips/helper.c
index 063b65c0528..bb962a3e8cc 100644
--- a/target/mips/helper.c
+++ b/target/mips/helper.c
@@ -24,7 +24,6 @@
 #include "exec/cpu_ldst.h"
 #include "exec/log.h"
 #include "hw/mips/cpudevs.h"
-#include "qapi/qapi-commands-machine-target.h"
 
 enum {
     TLBRET_XI = -6,
@@ -1497,35 +1496,3 @@ void QEMU_NORETURN do_raise_exception_err(CPUMIPSState *env,
 
     cpu_loop_exit_restore(cs, pc);
 }
-
-static void mips_cpu_add_definition(gpointer data, gpointer user_data)
-{
-    ObjectClass *oc = data;
-    CpuDefinitionInfoList **cpu_list = user_data;
-    CpuDefinitionInfoList *entry;
-    CpuDefinitionInfo *info;
-    const char *typename;
-
-    typename = object_class_get_name(oc);
-    info = g_malloc0(sizeof(*info));
-    info->name = g_strndup(typename,
-                           strlen(typename) - strlen("-" TYPE_MIPS_CPU));
-    info->q_typename = g_strdup(typename);
-
-    entry = g_malloc0(sizeof(*entry));
-    entry->value = info;
-    entry->next = *cpu_list;
-    *cpu_list = entry;
-}
-
-CpuDefinitionInfoList *qmp_query_cpu_definitions(Error **errp)
-{
-    CpuDefinitionInfoList *cpu_list = NULL;
-    GSList *list;
-
-    list = object_class_get_list(TYPE_MIPS_CPU, false);
-    g_slist_foreach(list, mips_cpu_add_definition, &cpu_list);
-    g_slist_free(list);
-
-    return cpu_list;
-}
-- 
2.26.2

