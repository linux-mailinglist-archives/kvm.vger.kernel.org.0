Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F95D2E110E
	for <lists+kvm@lfdr.de>; Wed, 23 Dec 2020 02:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgLWBKN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Dec 2020 20:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbgLWBKN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Dec 2020 20:10:13 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF26C061282
        for <kvm@vger.kernel.org>; Tue, 22 Dec 2020 17:08:57 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id t30so16954524wrb.0
        for <kvm@vger.kernel.org>; Tue, 22 Dec 2020 17:08:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v7U7U4jz0qPoOqFuv9j8CJ9BAGWmcWI/E1Yka+1h8VE=;
        b=lOvZnuCC7lrIXGXYsdlhKMF/cGSrwkiN7fhVIdv+JsKLfBjUNcDZistIf5W+w1A0+q
         EDMoCTaMT47AQIsUWYYQ0dOmuWJCel/7qUaCFODQ8IWVEA87Vv8kMSSBRoM3I1inHgvf
         tXXowOWNXlWqqj+tESRAX1qNdarVscXVwAb5X+vMPR0ilomMgidtG5Ka+pvFq+aAt/7y
         TrXgIvaU16+AX9dXC45k+rr69C55AxMRdk2i/agtxACTGrynfJPj9FgC5zJIp6Ur4oDM
         39mBgQ8sSeSc3nfngzA5tQMUwkNtqgMQ2F3QuEr+xCp8F+xAznsHSgw2jwm3yVrF1hWE
         LWdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=v7U7U4jz0qPoOqFuv9j8CJ9BAGWmcWI/E1Yka+1h8VE=;
        b=YbBB8Opw31x4DZ+l5awhgD5CcC1aEXforw5vBMCBy5ziY3bB5FAVwlbhfCJBMcJfWZ
         RoLuU6eb80A4PucEAPHzApJv31tPcemXhwjIdnBGoWCxlG8MZWMnKLespsmZiMyP8laN
         cX71E505EMwRa7BnFVS+hucnxuC/XxUdSTf3pRb8gPZpzW3zIC7+HufhQd0jdM4PumSt
         s/0i6tEtVpuFxXJeh/9evlHcZl6JN+KtlP6yMANyS6ug9S5seuzRirYZHLe50WaDwVKW
         Av0laQbzWdeJO6+a85lh8GZv+S1f8RqbJLIvP3HYfBDYEYu8WPe/YngUsWgDO4AbCSsq
         RRew==
X-Gm-Message-State: AOAM532wHPfWzRvfFEfq1U60Ig1S10VjF9/IgdyvIE6F6y3/oDFhjm0I
        xoBUd8CjEUilNVgunf7C7LFC6Xj04JU=
X-Google-Smtp-Source: ABdhPJwggswt1c9Q3IYgrr0pNPkqRABJmGE2+BAlZ5dPw83ksEIx5XhC8jKugVxSHNRVfTGsuXDWrA==
X-Received: by 2002:adf:e512:: with SMTP id j18mr26657733wrm.52.1608685736241;
        Tue, 22 Dec 2020 17:08:56 -0800 (PST)
Received: from avogadro.lan ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id h83sm30995047wmf.9.2020.12.22.17.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 17:08:55 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com
Subject: [PATCH kvm-unit-tests 4/4] chaos: add edu device interrupt to the workload
Date:   Wed, 23 Dec 2020 02:08:50 +0100
Message-Id: <20201223010850.111882-5-pbonzini@redhat.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223010850.111882-1-pbonzini@redhat.com>
References: <20201223010850.111882-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/chaos.c | 85 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/x86/chaos.c b/x86/chaos.c
index 0b1e29c..8d421b5 100644
--- a/x86/chaos.c
+++ b/x86/chaos.c
@@ -8,9 +8,11 @@
 #include "alloc_page.h"
 #include "asm/page.h"
 #include "processor.h"
+#include "pci-edu.h"
 
 #define MAX_NR_CPUS 256
 
+#define EDU_MSI 0xc4
 #define TIMER_IRQ 0x44
 
 struct chaos_args {
@@ -20,21 +22,32 @@ struct chaos_args {
 
 	int hz;
 	bool hlt;
+
+	bool edu;
+	int edu_hz;
 };
 
 struct counters {
 	int ticks_left;
+	int edu_fraction;
+	int edu_msi;
 };
 
 int ncpus;
 struct chaos_args all_args[MAX_NR_CPUS];
 struct counters cnt[MAX_NR_CPUS];
 
+bool have_edu;
+struct pci_edu_dev edu_dev;
+
 static void parse_arg(struct chaos_args *args, const char *arg)
 {
 	char *s = strdup(arg);
 	char *p = s;
 
+	/* By default generate 17 MSIs per second (if enabled).  */
+	args->edu_hz = 17;
+
 	while (*p) {
 		char *word = p;
 		char delim = strdelim(&p, ",=");
@@ -84,10 +97,33 @@ static void parse_arg(struct chaos_args *args, const char *arg)
 			}
 			args->hlt = i;
 			printf("CPU %d: hlt=%ld\n", smp_id(), i);
+		} else if (!strcmp(word, "edu")) {
+			if (!have_arg)
+				i = 1;
+			else if (i != 0 && i != 1) {
+				printf("edu argument must be 0 or 1\n");
+				i = 1;
+			}
+			if (i != 0 && !have_edu) {
+				printf("edu device not found\n");
+				i = 0;
+			}
+			args->edu = i;
+			printf("CPU %d: edu=%ld\n", smp_id(), i);
+		} else if (!strcmp(word, "edu_hz")) {
+			if (!have_arg || !i)
+				i = 100;
+			args->edu_hz = i;
+			printf("CPU %d: edu_hz=%ld\n", smp_id(), i);
 		} else {
 			printf("invalid argument %s\n", word);
 		}
 	}
+	if (args->edu && args->edu_hz > args->hz) {
+		printf("MSI rate limited to the CPU's hz value\n");
+		args->edu_hz = args->hz;
+	}
+
 	free(s);
 }
 
@@ -97,12 +133,27 @@ static void do_timer(void)
 	struct counters *c = &cnt[cpu];
 	char out[4];
 	if (c->ticks_left > 0) {
+		/*
+		 * Bresenham algorithm, generate edu_hz MSIs interrupts
+		 * every hz timer ticks.  See the other half in the
+		 * stress function.
+		 */
+		if (all_args[cpu].edu)
+			c->edu_fraction += all_args[cpu].edu_hz;
+
 		c->ticks_left--;
 		return;
 	}
 
 	c->ticks_left = all_args[cpu].hz;
 
+	if (all_args[cpu].edu) {
+		if (!c->edu_msi) {
+			puts("!!! no MSI received for edu device\n");
+		}
+		c->edu_msi = 0;
+	}
+
 	/* Print current CPU number.  */
 	out[2] = (cpu % 10) + '0'; cpu /= 10;
 	out[1] = (cpu % 10) + '0'; cpu /= 10;
@@ -116,14 +167,33 @@ static void timer(isr_regs_t *regs)
         eoi();
 }
 
+static void edu(isr_regs_t *regs)
+{
+	int cpu = smp_id();
+	struct counters *c = &cnt[cpu];
+	c->edu_msi++;
+        eoi();
+}
+
+static void x86_setup_msi(struct pci_dev *pci_dev, int dest)
+{
+	u64 address = 0xFEE00000 + (dest << 12);
+	u32 data = EDU_MSI;
+	pci_setup_msi(pci_dev, address, data);
+}
+
 static void __attribute__((noreturn)) stress(void *data)
 {
     const char *arg = data;
     struct chaos_args *args = &all_args[smp_id()];
+    struct counters *c = &cnt[smp_id()];
 
     printf("starting CPU %d workload: %s\n", smp_id(), arg);
     parse_arg(args, arg);
 
+    /* Do not print errors the first time through.  */
+    c->edu_msi = 1;
+
     apic_write(APIC_TDCR, 0x0000000b);
     if (args->hz) {
 	    /* FIXME: assumes that the LAPIC timer counts in nanoseconds.  */
@@ -132,6 +202,11 @@ static void __attribute__((noreturn)) stress(void *data)
 	    apic_write(APIC_LVTT, TIMER_IRQ | APIC_LVT_TIMER_PERIODIC);
     }
 
+    if (args->edu) {
+	    printf("starting edu device\n");
+	    x86_setup_msi(&edu_dev.pci_dev, apic_id());
+    }
+
     irq_enable();
     for (;;) {
 	    if (args->mem) {
@@ -147,6 +222,13 @@ static void __attribute__((noreturn)) stress(void *data)
 	    }
 	    if (args->hlt)
 		    asm volatile("hlt");
+
+	    if (c->edu_fraction > args->hz) {
+		    c->edu_fraction -= args->hz;
+		    edu_reg_writel(&edu_dev, EDU_REG_INTR_RAISE, 1);
+		    while (!c->edu_msi)
+			    cpu_relax();
+	    }
     }
 }
 
@@ -159,12 +241,15 @@ int main(int argc, char *argv[])
         return 1;
     }
 
+    have_edu = edu_init(&edu_dev);
+
     argv++;
     argc--;
     ncpus = cpu_count();
     if (ncpus > MAX_NR_CPUS)
 	    ncpus = MAX_NR_CPUS;
 
+    handle_irq(EDU_MSI, edu);
     handle_irq(TIMER_IRQ, timer);
 
     for (i = 1; i < ncpus; ++i) {
-- 
2.29.2

