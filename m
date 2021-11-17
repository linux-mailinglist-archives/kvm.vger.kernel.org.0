Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22DC14547C6
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 14:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237890AbhKQNxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 08:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237901AbhKQNw7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 08:52:59 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D32C061570
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 05:50:00 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id i12so2278214wmq.4
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 05:50:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FKZX9XzizirNwqxN4tqdNZu3zcfZgS1Nv/Er8mya+3s=;
        b=E99G83VsGHAhu0iaCIG57Mcznryganx230MDYprSoLdf7HiqeIvvlQWBPzlMMhzLoZ
         X6xM5tNvLiGJ+BGEhoWudd4+V5exyXO+FNmx+9DCZSoT3axodDbYUDpEiBDv3fMII2ze
         PQLjB7o0+9fytb1escDVrVX9sT6fEoMcYiOTu8bee4xODS+pc9WOv2T2hU3eBsEYTeby
         /vDAL4l1iwJslQQDSqv2L4qcr6uR1T/bj82C9gx3hxjR6oC2PR3dkD0w9U1H/F8QlT/a
         2EUJVHU4RylASCQ7V4t+B93//aNLKksi9KCMhmnB7it8SotKCHoKhnNtC1EwJQ1O4YgL
         xVew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FKZX9XzizirNwqxN4tqdNZu3zcfZgS1Nv/Er8mya+3s=;
        b=ag5vjqJ9ml0QkseV4h8XGXXdILRGfO2qcJoPa9xRyoZyIaZx9y14GdVUeEynz5BJDM
         RjAP2MT46rzQvGLNbM0D0NgZMIJXbn29tz9Ie9MxQVSS+2ES3oSDSI8vPF8vipWJngav
         4SkWRWK2tvLnHMdFtM6WNPC8WT1szm24gtYq+zvJicIpZ7u1HbpMlm2kv9cfUf9zi0Qo
         HqJ394BFICh5g646w1NpXlbQ8wLKajbeKUPQ+Nd00+yYv+qsiMYk7e5Ep0VXLn60QGSg
         bZPpKsQl66cIQv3rKJM8tEpCbcSJRlEVE4hhFjT2yPlxWYw/QS+nC18Djr33/xs8Amr7
         UgNQ==
X-Gm-Message-State: AOAM531/zaPFfc8XD9M90ylawi/T19um7rjx0NI8BUKKbOT+T2ClUMZO
        KCiUFshe2OXtskdmtqpOjN/b1YFWyK8P5A==
X-Google-Smtp-Source: ABdhPJzktwOzh3Q/ZagACjF8qIF4tHd/MKAfVVm4mAp1J0fLmF94dl+vRF2Wa6VGKIFMw4o6K21GKA==
X-Received: by 2002:a05:600c:1f0c:: with SMTP id bd12mr58662650wmb.56.1637156998682;
        Wed, 17 Nov 2021 05:49:58 -0800 (PST)
Received: from xps15.suse.de (ip5f5aa686.dynamic.kabel-deutschland.de. [95.90.166.134])
        by smtp.gmail.com with ESMTPSA id m14sm28290709wrp.28.2021.11.17.05.49.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 05:49:58 -0800 (PST)
From:   Varad Gautam <varadgautam@gmail.com>
X-Google-Original-From: Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, zxwang42@gmail.com,
        marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [RFC kvm-unit-tests 07/12] lib/x86: Move xsave helpers to lib/
Date:   Wed, 17 Nov 2021 14:47:47 +0100
Message-Id: <20211117134752.32662-8-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117134752.32662-1-varad.gautam@suse.com>
References: <20211117134752.32662-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Processing CPUID #VC for AMD SEV-ES requires copying xcr0 into GHCB.
Move the xsave read/write helpers used by xsave testcase to lib/x86
to share as common code.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 lib/x86/xsave.c     | 37 +++++++++++++++++++++++++++++++++++++
 lib/x86/xsave.h     | 16 ++++++++++++++++
 x86/Makefile.common |  1 +
 x86/xsave.c         | 43 +------------------------------------------
 4 files changed, 55 insertions(+), 42 deletions(-)
 create mode 100644 lib/x86/xsave.c
 create mode 100644 lib/x86/xsave.h

diff --git a/lib/x86/xsave.c b/lib/x86/xsave.c
new file mode 100644
index 0000000..1c0f16e
--- /dev/null
+++ b/lib/x86/xsave.c
@@ -0,0 +1,37 @@
+#include "libcflat.h"
+#include "xsave.h"
+#include "processor.h"
+
+int xgetbv_checking(u32 index, u64 *result)
+{
+    u32 eax, edx;
+
+    asm volatile(ASM_TRY("1f")
+            ".byte 0x0f,0x01,0xd0\n\t" /* xgetbv */
+            "1:"
+            : "=a" (eax), "=d" (edx)
+            : "c" (index));
+    *result = eax + ((u64)edx << 32);
+    return exception_vector();
+}
+
+int xsetbv_checking(u32 index, u64 value)
+{
+    u32 eax = value;
+    u32 edx = value >> 32;
+
+    asm volatile(ASM_TRY("1f")
+            ".byte 0x0f,0x01,0xd1\n\t" /* xsetbv */
+            "1:"
+            : : "a" (eax), "d" (edx), "c" (index));
+    return exception_vector();
+}
+
+uint64_t get_supported_xcr0(void)
+{
+    struct cpuid r;
+    r = cpuid_indexed(0xd, 0);
+    printf("eax %x, ebx %x, ecx %x, edx %x\n",
+            r.a, r.b, r.c, r.d);
+    return r.a + ((u64)r.d << 32);
+}
diff --git a/lib/x86/xsave.h b/lib/x86/xsave.h
new file mode 100644
index 0000000..f1851a3
--- /dev/null
+++ b/lib/x86/xsave.h
@@ -0,0 +1,16 @@
+#ifndef _X86_XSAVE_H_
+#define _X86_XSAVE_H_
+
+#define X86_CR4_OSXSAVE			0x00040000
+#define XCR_XFEATURE_ENABLED_MASK       0x00000000
+#define XCR_XFEATURE_ILLEGAL_MASK       0x00000010
+
+#define XSTATE_FP       0x1
+#define XSTATE_SSE      0x2
+#define XSTATE_YMM      0x4
+
+int xgetbv_checking(u32 index, u64 *result);
+int xsetbv_checking(u32 index, u64 value);
+uint64_t get_supported_xcr0(void);
+
+#endif
diff --git a/x86/Makefile.common b/x86/Makefile.common
index c1e3e30..8ed8e59 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -22,6 +22,7 @@ cflatobjs += lib/x86/acpi.o
 cflatobjs += lib/x86/stack.o
 cflatobjs += lib/x86/fault_test.o
 cflatobjs += lib/x86/delay.o
+cflatobjs += lib/x86/xsave.o
 ifeq ($(TARGET_EFI),y)
 cflatobjs += lib/x86/amd_sev.o
 cflatobjs += lib/x86/amd_sev_vc.o
diff --git a/x86/xsave.c b/x86/xsave.c
index 892bf56..bd8fe11 100644
--- a/x86/xsave.c
+++ b/x86/xsave.c
@@ -1,6 +1,7 @@
 #include "libcflat.h"
 #include "desc.h"
 #include "processor.h"
+#include "xsave.h"
 
 #ifdef __x86_64__
 #define uint64_t unsigned long
@@ -8,48 +9,6 @@
 #define uint64_t unsigned long long
 #endif
 
-static int xgetbv_checking(u32 index, u64 *result)
-{
-    u32 eax, edx;
-
-    asm volatile(ASM_TRY("1f")
-            ".byte 0x0f,0x01,0xd0\n\t" /* xgetbv */
-            "1:"
-            : "=a" (eax), "=d" (edx)
-            : "c" (index));
-    *result = eax + ((u64)edx << 32);
-    return exception_vector();
-}
-
-static int xsetbv_checking(u32 index, u64 value)
-{
-    u32 eax = value;
-    u32 edx = value >> 32;
-
-    asm volatile(ASM_TRY("1f")
-            ".byte 0x0f,0x01,0xd1\n\t" /* xsetbv */
-            "1:"
-            : : "a" (eax), "d" (edx), "c" (index));
-    return exception_vector();
-}
-
-static uint64_t get_supported_xcr0(void)
-{
-    struct cpuid r;
-    r = cpuid_indexed(0xd, 0);
-    printf("eax %x, ebx %x, ecx %x, edx %x\n",
-            r.a, r.b, r.c, r.d);
-    return r.a + ((u64)r.d << 32);
-}
-
-#define X86_CR4_OSXSAVE			0x00040000
-#define XCR_XFEATURE_ENABLED_MASK       0x00000000
-#define XCR_XFEATURE_ILLEGAL_MASK       0x00000010
-
-#define XSTATE_FP       0x1
-#define XSTATE_SSE      0x2
-#define XSTATE_YMM      0x4
-
 static void test_xsave(void)
 {
     unsigned long cr4;
-- 
2.32.0

