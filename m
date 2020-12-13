Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A70E2D9078
	for <lists+kvm@lfdr.de>; Sun, 13 Dec 2020 21:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405739AbgLMUXZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Dec 2020 15:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405892AbgLMUWU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Dec 2020 15:22:20 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB75DC061793
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:21:39 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id x22so11944903wmc.5
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:21:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=elw3dkJb0pO4uN20lOWqB+T8hVaJgjod16PJg5LRYBw=;
        b=OakRocpid6FZj3s/PHYLg8MdRlpbGGdPHt0I1Hb3XrhOxXp3/vJv5KwyCgWALrU1gD
         cy5QiYNzKe4CL63vdsi0D1njoMUzsX59RGAdylbSTMxcaagw3mMevgxeLXuzYfRBFfey
         0FiwS7SCZsQxFLdbxVsGsavlw0q/uUP5pSakgEzriGTJ+oyDfEM/5vaeqZSWkRhZ+t2I
         6T6kvP20RAGbVNzgqNGKz8SnndsmKOKQI61NyIC7M7aQoqa9B6XIQoTlMV342ZF6GR7k
         plpVy02/WeD/36qp+tsHL80j8nR85pYGGf71Zx8TtAQGRIJWV5Sn3Hgcu2yw1InrB4zD
         hyEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=elw3dkJb0pO4uN20lOWqB+T8hVaJgjod16PJg5LRYBw=;
        b=TWbvQyyTTFQXnroWiNN5thQlEQ4V3UBRFWpp19idbxOixENxia2da9mTjdE9oqcEiD
         0bnij4J2KXuYO2GDOKu6mVYPT9WGtH9AruDCPLJPNcX9tBIxGzTsFSCMfT5AhF5UnIt4
         kyfMzrppHlXI5lXHb1eyoAyrseKplsmnLx6MHfz9mJkg134Tcwg4d2yBm9LXgGRPK1QG
         1+8z93Mg08qGF9dNGjNCpYsacpoFxO4t8NlKU3sYLYmr+0vhLncWasK3oGnqGN9NLlaX
         ewXwgYhVRxOg4L9pa80rv9SxzsoHAttBD7HsIIPmaNwIqedFTIx9lT5HjtyF+Jm2cBs9
         6tCQ==
X-Gm-Message-State: AOAM530dr7LepxAapNUPKIJlDWw6CLwOpr8gSb7vl8jUg7iR/o5lFWS+
        DoEcTMwtfAfswj92C3o+KcAB21uNpnw=
X-Google-Smtp-Source: ABdhPJxYfakzKjYyS+h5ikBDwAbUZrCSc5kwJtqdOV5z+575/HCCL+TNCGZORrpxlu3KFPynTy49wg==
X-Received: by 2002:a1c:8016:: with SMTP id b22mr24363664wmd.135.1607890898684;
        Sun, 13 Dec 2020 12:21:38 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id j7sm26852271wmb.40.2020.12.13.12.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 12:21:38 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Paul Burton <paulburton@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PULL 22/26] target/mips: Move mips_cpu_add_definition() from helper.c to cpu.c
Date:   Sun, 13 Dec 2020 21:19:42 +0100
Message-Id: <20201213201946.236123-23-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201213201946.236123-1-f4bug@amsat.org>
References: <20201213201946.236123-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201206233949.3783184-10-f4bug@amsat.org>
---
 target/mips/cpu.c    | 33 +++++++++++++++++++++++++++++++++
 target/mips/helper.c | 33 ---------------------------------
 2 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index 3024c51a211..c29fef29d00 100644
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
index 0c657865793..87296fbad69 100644
--- a/target/mips/helper.c
+++ b/target/mips/helper.c
@@ -24,7 +24,6 @@
 #include "exec/cpu_ldst.h"
 #include "exec/log.h"
 #include "hw/mips/cpudevs.h"
-#include "qapi/qapi-commands-machine-target.h"
 
 enum {
     TLBRET_XI = -6,
@@ -1500,35 +1499,3 @@ void QEMU_NORETURN do_raise_exception_err(CPUMIPSState *env,
 
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

