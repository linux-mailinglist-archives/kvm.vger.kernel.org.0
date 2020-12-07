Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3EF2D1EA2
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 00:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728315AbgLGX4f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 18:56:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728248AbgLGX4e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 18:56:34 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8E0C061794
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 15:55:48 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id n26so22042747eju.6
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 15:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rwO8LiwFgyb0U3AML1ri+5J9BRwA5KGBeXVuU1ilwAY=;
        b=IsEQt9eHq9o2acsK71gmBFTuGXV5lC+YqQx9+pL9as6Vue5qugTfLFzUt93gj7wtWp
         kozJHMY4DbdOLBwrBb7Vf0YYsOQcFiTpeexlwXep7Ln5XwAn3ahdQwoTU3+huR9lez/o
         Eq22pHnDvoo6cyUOzba75NxtpN0sOKjmJ7kjUdLasaLdyq9RHcTMak1AhwOsy+dxD+a1
         N8fdoJtuG2+YnbDhpb3mOwNJzPmQzBkxESoOGgLzAHhLvxSITLrrVD9GHuH8wmdLBFrM
         uaX9Oo2D0XdXkkWg8fCHYNHp9WkOGMTVY53fc/CSvnuqbMhCgN8f0on5QZcDA96+3JrS
         wwJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=rwO8LiwFgyb0U3AML1ri+5J9BRwA5KGBeXVuU1ilwAY=;
        b=NTqqfp9dKJVy3xhJ4rObSghhjo7iSynpZiDUzl5uu9m358rs2WyDX8v3RPBVmaE2A0
         hwNTrUYcjZLQv2eRkyvVPBRbRexO/7gnRV8G3DCouwZCWgbKsC2AcIx2qe2IdpVNRi2C
         M+H8F4MJLT0fj6QBx0dkuYkGF0/asrovDjtuls8WyTcylQ6Zer+Q1PoQd4uk47eOI+rv
         jgdBp55yA8HBJoK27/PB9p5hDAcgg1odGI2Amb7gZTrLToqqEu6nldTtEXKftJRAgoOv
         iK8yRfdjyUw82JgsDa8v0M2ktzR1SUSvZjaq/G/PaiPiXhZ+xlhCb/xkf3g7BWuXZ59j
         exFQ==
X-Gm-Message-State: AOAM530FGqiUPHWGcm/YDrvaqo1AXRHiBihD2FLNrupP50x+Of7sGSJI
        KMYJQfMdVrct4zCQTWllEWs=
X-Google-Smtp-Source: ABdhPJyQuO9/gar2g2osp7t5aul42q7+WXXIAflzr+Fjc1MLTB5i7v/dLVh1dDWA69f1KSvnvy96xA==
X-Received: by 2002:a17:906:2499:: with SMTP id e25mr21090103ejb.446.1607385346908;
        Mon, 07 Dec 2020 15:55:46 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id op5sm13736899ejb.43.2020.12.07.15.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 15:55:46 -0800 (PST)
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
Subject: [PATCH 1/7] target/mips/translate: Extract DisasContext structure
Date:   Tue,  8 Dec 2020 00:55:33 +0100
Message-Id: <20201207235539.4070364-2-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201207235539.4070364-1-f4bug@amsat.org>
References: <20201207235539.4070364-1-f4bug@amsat.org>
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
index ee45dce9a50..d7f5a1e8d84 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -39,6 +39,7 @@
 #include "exec/translator.h"
 #include "exec/log.h"
 #include "qemu/qemu-print.h"
+#include "translate.h"
 
 #define MIPS_DEBUG_DISAS 0
 
@@ -2557,43 +2558,6 @@ static TCGv mxu_CR;
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

