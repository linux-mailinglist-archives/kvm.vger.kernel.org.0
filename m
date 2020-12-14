Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63242D9F5F
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 19:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408823AbgLNSkC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 13:40:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408629AbgLNSjZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 13:39:25 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59EBC06179C
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:38:44 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id w206so9537969wma.0
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:38:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z4msl+4E6QtN6RCQD089Ehf2sv+vjVAWY6z4uBcfgdk=;
        b=DrDZm/9e0lVMSvZGjsIYjHK94ow+Jg5D8TItRlY9LizKyMcpKEvRgNUACXmaxqgSm/
         rG16dqW9KtMQQ4EUwmY6ebTXQC+UAAV9zxqB8CoaYZx1l8VuToAuCWUjxhlYvabVB1X8
         L1rdGB4P1fUIPm+pYAfsNjlG/iicbg6rAkFKGNcTqzpQm0c8sdLJerwqElgw1M3tJ6G6
         xnZ44g/I12U9vLGVJbrctPB3k8joVqHIcOjVvfRUZ3cHezjvT+bPTbuOylBVikUyu3N8
         FlFKlM98G+kNm1e7mr9DPkOVWKHbfuvCkQp07yVSDl9dCzdPbJJmTYQaFnJhJFFbfSkZ
         tHMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=z4msl+4E6QtN6RCQD089Ehf2sv+vjVAWY6z4uBcfgdk=;
        b=sYyUSXEHGv5sZ63QpN77CJTEDX3G4uOVjpbg9AzgIDPV3k61Ey4ES7HCzdtMZ0mkJK
         RpcMb+oTyeozpww5FtNJY5aoa58gkPIM+ywl8/sbmTUR5x+gfToGkYXUqd6uosl1g4cX
         10QZzL7AG4sELlux1L34xxpY6//qnGNnrrBZl1SsRPTTkYqgvFfoMih+Hx3lxBZApvPc
         YQG3dfZIxo4+DH4E24MFeWpK/2JxC312+ekfifjy2x+elL4jufSgWcemuueX827JnOl0
         twX/HtNRCV153TANx5uaetmtrt2bZuuu7sL5evkxc7YuS3Smd8JU7ZqvO3F65dIrR6zC
         3z1A==
X-Gm-Message-State: AOAM530gf6MY8kKSX62aUnQnZ4v+gYhAyEVEZJyA0Wl/cqzrZkslsW9X
        nMFjglivT3VZaLQUNLzcc9umqdHzU40=
X-Google-Smtp-Source: ABdhPJwl6pcDop1GdGO4Cb9M9Dsjwa8SEcn5CnQdkLcnNoCGQzV5Bj0mR7LYdZNaxsMtDUxaCAAh4A==
X-Received: by 2002:a7b:cb93:: with SMTP id m19mr30063317wmi.45.1607971123469;
        Mon, 14 Dec 2020 10:38:43 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id v7sm31858058wma.26.2020.12.14.10.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 10:38:42 -0800 (PST)
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
Subject: [PATCH v2 12/16] target/mips/translate: Extract DisasContext structure
Date:   Mon, 14 Dec 2020 19:37:35 +0100
Message-Id: <20201214183739.500368-13-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201214183739.500368-1-f4bug@amsat.org>
References: <20201214183739.500368-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extract DisasContext to a new 'translate.h' header so
different translation files (ISA, ASE, extensions)
can use it.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201207235539.4070364-2-f4bug@amsat.org>
---
 target/mips/translate.h | 50 +++++++++++++++++++++++++++++++++++++++++
 target/mips/translate.c | 38 +------------------------------
 2 files changed, 51 insertions(+), 37 deletions(-)
 create mode 100644 target/mips/translate.h

diff --git a/target/mips/translate.h b/target/mips/translate.h
new file mode 100644
index 00000000000..fcda1a99001
--- /dev/null
+++ b/target/mips/translate.h
@@ -0,0 +1,50 @@
+/*
+ *  MIPS translation routines.
+ *
+ *  Copyright (c) 2004-2005 Jocelyn Mayer
+ *
+ * SPDX-License-Identifier: LGPL-2.1-or-later
+ */
+#ifndef TARGET_MIPS_TRANSLATE_H
+#define TARGET_MIPS_TRANSLATE_H
+
+#include "exec/translator.h"
+
+typedef struct DisasContext {
+    DisasContextBase base;
+    target_ulong saved_pc;
+    target_ulong page_start;
+    uint32_t opcode;
+    uint64_t insn_flags;
+    int32_t CP0_Config1;
+    int32_t CP0_Config2;
+    int32_t CP0_Config3;
+    int32_t CP0_Config5;
+    /* Routine used to access memory */
+    int mem_idx;
+    MemOp default_tcg_memop_mask;
+    uint32_t hflags, saved_hflags;
+    target_ulong btarget;
+    bool ulri;
+    int kscrexist;
+    bool rxi;
+    int ie;
+    bool bi;
+    bool bp;
+    uint64_t PAMask;
+    bool mvh;
+    bool eva;
+    bool sc;
+    int CP0_LLAddr_shift;
+    bool ps;
+    bool vp;
+    bool cmgcr;
+    bool mrp;
+    bool nan2008;
+    bool abs2008;
+    bool saar;
+    bool mi;
+    int gi;
+} DisasContext;
+
+#endif
diff --git a/target/mips/translate.c b/target/mips/translate.c
index 49570a95615..0db0fce3789 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -36,6 +36,7 @@
 #include "exec/log.h"
 #include "qemu/qemu-print.h"
 #include "fpu_helper.h"
+#include "translate.h"
 
 #define MIPS_DEBUG_DISAS 0
 
@@ -2554,43 +2555,6 @@ static TCGv mxu_CR;
     tcg_temp_free_i32(helper_tmp);                                \
     } while (0)
 
-typedef struct DisasContext {
-    DisasContextBase base;
-    target_ulong saved_pc;
-    target_ulong page_start;
-    uint32_t opcode;
-    uint64_t insn_flags;
-    int32_t CP0_Config1;
-    int32_t CP0_Config2;
-    int32_t CP0_Config3;
-    int32_t CP0_Config5;
-    /* Routine used to access memory */
-    int mem_idx;
-    MemOp default_tcg_memop_mask;
-    uint32_t hflags, saved_hflags;
-    target_ulong btarget;
-    bool ulri;
-    int kscrexist;
-    bool rxi;
-    int ie;
-    bool bi;
-    bool bp;
-    uint64_t PAMask;
-    bool mvh;
-    bool eva;
-    bool sc;
-    int CP0_LLAddr_shift;
-    bool ps;
-    bool vp;
-    bool cmgcr;
-    bool mrp;
-    bool nan2008;
-    bool abs2008;
-    bool saar;
-    bool mi;
-    int gi;
-} DisasContext;
-
 #define DISAS_STOP       DISAS_TARGET_0
 #define DISAS_EXIT       DISAS_TARGET_1
 
-- 
2.26.2

