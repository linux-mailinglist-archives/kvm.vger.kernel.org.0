Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 151112EE882
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728403AbhAGWZi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728416AbhAGWZh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:25:37 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5706AC0612F4
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:25:22 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id r3so7141745wrt.2
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2UuX+ygCL9NQhxyYPo8S/tX8V99CFSpKYjvju/1WTRw=;
        b=FtebATSCzssDKSTVyEBHTyfxZHEyueAnMcztoYO2nqONIlfNyNQ47V/b34tLC6l6t1
         oKM+cemUKzeLIspqo1pEWZQIiuDRkDk2rUy8OXEXwZSnGokAqUTwP2AttqLU+FkMcYMT
         wFTUF5n5meR9Z/ZixEHgLMRiQcjpKe+NVCsxpQtyN5Im14QXo6sxlLFkw6+KJJ+W9yXa
         yaB8mJ10nnJedDSDKRQhq+tnGWCeUuNXqeuM+edCvSvm4b7/waeMW1O520eh18ywKEpt
         SWnb8yAaF5mksm6wtMSNOqzp2XuOMYD+AlW3h/C24Y1/DBLOpxPmev9R02DQROaK8GNG
         ye+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=2UuX+ygCL9NQhxyYPo8S/tX8V99CFSpKYjvju/1WTRw=;
        b=AbBoFXgvpCexqfQFu41cruHn4Pdsi06jCRd1gCzM3xerzNTUbxUOQjcCXP5mmU9SFX
         2bVMPNvAFNtqo2ucrvomh9MdS2RkWb1TpNfl1jdDh7nEbIO+swvDlQCmODEiMguj/+N5
         oGzQQoRRZDHtwGvVg8P13B6IinCdyDrtYTOTD3ViJmnj63GU3qgnDw5mMoARvRQK/4rE
         gDKrBfAeeLTXWEoo1PR9vSN8/PeohAVghAeHpzOlOKjgasMjvtpKJNUFsbt1+WJvxJnL
         l3OpaTJxoKkq4xAdJ4a8yinFMZu0fgqQNwh669dA5C8qWRiMebhVnoF24g8waoXwn8IT
         PIDw==
X-Gm-Message-State: AOAM530VNnpoDamYFS+I6ZO8z0V4a8qtvd2R9u1JPs48Zf1gPU+n6fGi
        SYsX7pUt1ugRcFg5s1ewcYM=
X-Google-Smtp-Source: ABdhPJzMyJdqE/eO0phoPlTa/qBVpXHkKqr9ihmwxJoBQBQQQe/goVibMYsBjjZd/5mLbkiF7PY3xg==
X-Received: by 2002:adf:f891:: with SMTP id u17mr662412wrp.253.1610058321171;
        Thu, 07 Jan 2021 14:25:21 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id c7sm11513721wro.16.2021.01.07.14.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:25:20 -0800 (PST)
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
Subject: [PULL 28/66] target/mips/translate: Extract DisasContext structure
Date:   Thu,  7 Jan 2021 23:22:15 +0100
Message-Id: <20210107222253.20382-29-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
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
index f8f0f95509c..9e824e12d44 100644
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

