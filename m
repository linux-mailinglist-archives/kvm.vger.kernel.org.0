Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 205E46C0B09
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 08:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjCTHEL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 03:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbjCTHEA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 03:04:00 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 388CE1ACC6
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 00:03:59 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id l9-20020a17090a3f0900b0023d32684e7fso12791780pjc.1
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 00:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679295838;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1tQmlH7ZocUDF0XviWXYfrYIsuWU/7HBNkukLP3mZWY=;
        b=UDw+Qhwc6kyU8atOdcu+GlFw447W11hwebun4pHIgj9Z5isM5B+ByvxwxVETzcJW9f
         /bnBpBMR612JCAvaWAbpaigivilHt+zKU/FWd2dPCvv74qzM/M/f+SaLvf3qazXhLRXU
         VQgCXEme4bUCOTYUGKm37oETfriEON2my8uxRB2VBPJxsykUuhk8zpKMg5RWvgfFwtOj
         Ir8zqhaU+SlVGVB0lCJ6L0QpbqOAqjJgZwjE6ZalZrgujzLfp383uaKA2ch/U+NGWdRY
         JVlb7Jjcq1PmkAp/4na7FRqMv8Tm++ldTYk+zd2FATf9VUuccPQ6rzXeRgzCgqG854iG
         Rb/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679295838;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1tQmlH7ZocUDF0XviWXYfrYIsuWU/7HBNkukLP3mZWY=;
        b=5x3RJ7JrR9JPA99Haiuql9S8QuYoLEhtc+3nO5wPfdk25LKBMi2S2WsHgmE6vVyIZV
         Vz4y50yFI28pGGYmXYbimPgtyiSukn7HvvKXbzgDXc1VBl8QuKyN5oiZDXUob8zXzIGo
         KyUVFuGofjqlKFCmV/OeqKM25csNMEIKeoA09gZQSfCaatZeglvM2BPZwq0Xpbsdg4Ak
         6lwlM87ZVQFkDI6AYEoN9aMe4d1yTqztiaumXrJ8vaHVD7GH4xs1pnC0XE+mAjKC3Eae
         62qKw1PxW6sAC2sJWQn9xbewPvOhsnc1Tkdsdz0zHzCwFbL/HI27RVPLET5hTexSDE3G
         ExKA==
X-Gm-Message-State: AO0yUKVkEEdQsi5+O3Yj8EkEf/7RczKJm89aV8PG70YW86xw9Vcss/wz
        CD3MWrLjERM5sfyrIKjNXMhFKLo14cI=
X-Google-Smtp-Source: AK7set+QP/6Ucs8sQNhK/+HHAZ15k0UsRku/ZyMaRMdcvGSyeqTzJ0eQTQRHN6jCPOW+OtbRUAp0qQ==
X-Received: by 2002:a05:6a20:748b:b0:bf:58d1:cea0 with SMTP id p11-20020a056a20748b00b000bf58d1cea0mr12081628pzd.31.1679295838243;
        Mon, 20 Mar 2023 00:03:58 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (121-44-69-75.tpgi.com.au. [121.44.69.75])
        by smtp.gmail.com with ESMTPSA id r17-20020a632b11000000b0050f7f783ff0sm1039414pgr.76.2023.03.20.00.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 00:03:57 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests v2 03/10] powerpc: abstract H_CEDE calls into a sleep functions
Date:   Mon, 20 Mar 2023 17:03:32 +1000
Message-Id: <20230320070339.915172-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230320070339.915172-1-npiggin@gmail.com>
References: <20230320070339.915172-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This consolidates several implementations, and it no longer leaves
MSR[EE] enabled after the decrementer interrupt is handled, but
rather disables it on return.

The handler no longer allows a continuous ticking, but rather dec
has to be re-armed and EE re-enabled (e.g., via H_CEDE hcall) each
time.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/powerpc/asm/handlers.h  |  2 +-
 lib/powerpc/asm/ppc_asm.h   |  1 +
 lib/powerpc/asm/processor.h |  7 +++++++
 lib/powerpc/handlers.c      | 10 ++++-----
 lib/powerpc/processor.c     | 42 +++++++++++++++++++++++++++++++++++++
 powerpc/sprs.c              |  6 +-----
 powerpc/tm.c                | 20 +-----------------
 7 files changed, 57 insertions(+), 31 deletions(-)

diff --git a/lib/powerpc/asm/handlers.h b/lib/powerpc/asm/handlers.h
index 64ba727..e4a0cd4 100644
--- a/lib/powerpc/asm/handlers.h
+++ b/lib/powerpc/asm/handlers.h
@@ -3,6 +3,6 @@
 
 #include <asm/ptrace.h>
 
-void dec_except_handler(struct pt_regs *regs, void *data);
+void dec_handler_oneshot(struct pt_regs *regs, void *data);
 
 #endif /* _ASMPOWERPC_HANDLERS_H_ */
diff --git a/lib/powerpc/asm/ppc_asm.h b/lib/powerpc/asm/ppc_asm.h
index 1b85f6b..6299ff5 100644
--- a/lib/powerpc/asm/ppc_asm.h
+++ b/lib/powerpc/asm/ppc_asm.h
@@ -36,6 +36,7 @@
 #endif /* __BYTE_ORDER__ */
 
 /* Machine State Register definitions: */
+#define MSR_EE_BIT	15			/* External Interrupts Enable */
 #define MSR_SF_BIT	63			/* 64-bit mode */
 
 #endif /* _ASMPOWERPC_PPC_ASM_H */
diff --git a/lib/powerpc/asm/processor.h b/lib/powerpc/asm/processor.h
index ac001e1..ebfeff2 100644
--- a/lib/powerpc/asm/processor.h
+++ b/lib/powerpc/asm/processor.h
@@ -20,6 +20,8 @@ static inline uint64_t get_tb(void)
 
 extern void delay(uint64_t cycles);
 extern void udelay(uint64_t us);
+extern void sleep_tb(uint64_t cycles);
+extern void usleep(uint64_t us);
 
 static inline void mdelay(uint64_t ms)
 {
@@ -27,4 +29,9 @@ static inline void mdelay(uint64_t ms)
 		udelay(1000);
 }
 
+static inline void msleep(uint64_t ms)
+{
+	usleep(ms * 1000);
+}
+
 #endif /* _ASMPOWERPC_PROCESSOR_H_ */
diff --git a/lib/powerpc/handlers.c b/lib/powerpc/handlers.c
index c8721e0..296f14f 100644
--- a/lib/powerpc/handlers.c
+++ b/lib/powerpc/handlers.c
@@ -9,15 +9,13 @@
 #include <libcflat.h>
 #include <asm/handlers.h>
 #include <asm/ptrace.h>
+#include <asm/ppc_asm.h>
 
 /*
  * Generic handler for decrementer exceptions (0x900)
- * Just reset the decrementer back to the value specified when registering the
- * handler
+ * Return with MSR[EE] disabled.
  */
-void dec_except_handler(struct pt_regs *regs __unused, void *data)
+void dec_handler_oneshot(struct pt_regs *regs, void *data)
 {
-	uint64_t dec = *((uint64_t *) data);
-
-	asm volatile ("mtdec %0" : : "r" (dec));
+	regs->msr &= ~(1UL << MSR_EE_BIT);
 }
diff --git a/lib/powerpc/processor.c b/lib/powerpc/processor.c
index ec85b9d..e77a240 100644
--- a/lib/powerpc/processor.c
+++ b/lib/powerpc/processor.c
@@ -10,6 +10,8 @@
 #include <asm/ptrace.h>
 #include <asm/setup.h>
 #include <asm/barrier.h>
+#include <asm/hcall.h>
+#include <asm/handlers.h>
 
 static struct {
 	void (*func)(struct pt_regs *, void *data);
@@ -54,3 +56,43 @@ void udelay(uint64_t us)
 {
 	delay((us * tb_hz) / 1000000);
 }
+
+void sleep_tb(uint64_t cycles)
+{
+	uint64_t start, end, now;
+
+	start = now = get_tb();
+	end = start + cycles;
+
+	while (end > now) {
+		uint64_t left = end - now;
+
+		/* Could support large decrementer */
+		if (left > 0x7fffffff)
+			left = 0x7fffffff;
+
+		asm volatile ("mtdec %0" : : "r" (left));
+		handle_exception(0x900, &dec_handler_oneshot, NULL);
+		/*
+		 * H_CEDE is called with MSR[EE] clear and enables it as part
+		 * of the hcall, returning with EE enabled. The dec interrupt
+		 * is then taken immediately and the handler disables EE.
+		 *
+		 * If H_CEDE returned for any other interrupt than dec
+		 * expiring, that is considered an unhandled interrupt and
+		 * the test case would be stopped.
+		 */
+		if (hcall(H_CEDE) != H_SUCCESS) {
+			printf("H_CEDE failed\n");
+			abort();
+		}
+		handle_exception(0x900, NULL, NULL);
+
+		now = get_tb();
+	}
+}
+
+void usleep(uint64_t us)
+{
+	sleep_tb((us * tb_hz) / 1000000);
+}
diff --git a/powerpc/sprs.c b/powerpc/sprs.c
index 5cc1cd1..ba4ddee 100644
--- a/powerpc/sprs.c
+++ b/powerpc/sprs.c
@@ -254,7 +254,6 @@ int main(int argc, char **argv)
 		0x1234567890ABCDEFULL, 0xFEDCBA0987654321ULL,
 		-1ULL,
 	};
-	static uint64_t decr = 0x7FFFFFFF; /* Max value */
 
 	for (i = 1; i < argc; i++) {
 		if (!strcmp(argv[i], "-w")) {
@@ -288,10 +287,7 @@ int main(int argc, char **argv)
 	if (pause) {
 		migrate_once();
 	} else {
-		puts("Sleeping...\n");
-		handle_exception(0x900, &dec_except_handler, &decr);
-		asm volatile ("mtdec %0" : : "r" (0x3FFFFFFF));
-		hcall(H_CEDE);
+		msleep(2000);
 	}
 
 	get_sprs(after);
diff --git a/powerpc/tm.c b/powerpc/tm.c
index 65cacdf..7fa9163 100644
--- a/powerpc/tm.c
+++ b/powerpc/tm.c
@@ -48,17 +48,6 @@ static int count_cpus_with_tm(void)
 	return available;
 }
 
-static int h_cede(void)
-{
-	register uint64_t r3 asm("r3") = H_CEDE;
-
-	asm volatile ("sc 1" : "+r"(r3) :
-			     : "r0", "r4", "r5", "r6", "r7", "r8", "r9",
-			       "r10", "r11", "r12", "xer", "ctr", "cc");
-
-	return r3;
-}
-
 /*
  * Enable transactional memory
  * Returns:	FALSE - Failure
@@ -95,14 +84,10 @@ static bool enable_tm(void)
 static void test_h_cede_tm(int argc, char **argv)
 {
 	int i;
-	static uint64_t decr = 0x3FFFFF; /* ~10ms */
 
 	if (argc > 2)
 		report_abort("Unsupported argument: '%s'", argv[2]);
 
-	handle_exception(0x900, &dec_except_handler, &decr);
-	asm volatile ("mtdec %0" : : "r" (decr));
-
 	if (!start_all_cpus(halt, 0))
 		report_abort("Failed to start secondary cpus");
 
@@ -120,10 +105,7 @@ static void test_h_cede_tm(int argc, char **argv)
 		      "bf 2,1b" : : : "cr0");
 
 	for (i = 0; i < 500; i++) {
-		uint64_t rval = h_cede();
-
-		if (rval != H_SUCCESS)
-			break;
+		msleep(10);
 		mdelay(5);
 	}
 
-- 
2.37.2

