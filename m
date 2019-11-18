Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39BDA100A38
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 18:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfKRR3D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 12:29:03 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46230 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbfKRR3D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Nov 2019 12:29:03 -0500
Received: by mail-wr1-f68.google.com with SMTP id b3so20498286wrs.13
        for <kvm@vger.kernel.org>; Mon, 18 Nov 2019 09:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id;
        bh=YND6Zs40Ln4MrQ8TnFNfSflQxBifvkVl4mTVEIrw30s=;
        b=iNWZXzyIqChjfu1CKskiQERSMg1DM8i/ElBUDIbUch/frdAEaU+w9bsFPvo+cKqust
         SCSByoxOFKEQ+GJFRL2ckuqDXOu/2idaq5+tcmQunsQe8NjfuXT0yyu98wuwzdHqA5DU
         vl3gInqz0Y0Os7Ekq5zplKmOy0oYEDwlXdZ05qKLruVE/RX0+selsw4H7ZTdixPQIaqJ
         RHnCuDsxNmSiSmh8OljdCXuFoTvrWBcLiIeWrJiET9pCkEi2kh+HWveNE2SKby2F9VmI
         /DRrDJHuW6m78JklShiwjFW9p7h/7BJ2tvu0dFoy5knOl1JZGPFKq2BJRfXCqCnKQGy9
         t5RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id;
        bh=YND6Zs40Ln4MrQ8TnFNfSflQxBifvkVl4mTVEIrw30s=;
        b=luGaqjs3mi8LkoU+NrUaJoAtfI9jj76+evRHXBHYMTRtCQwUeHIMxoVkY+DBBU1LlW
         9epNOU3zYWssOxQkq4UbHDfcYvPce4iWxIymeGcfVMSkiw0kMmgzCv5LsBzxWx+ZIw7+
         4urs69dCi+XbxhYeg6Q/zzw5eG2u6MdIzSAyFaO4a2vCfVugvLonUOtEPsVCEiRj0jDu
         lsW71SZ3pfuPICc/g31HkLmm/jRgQ/5CPipMj4OnMhApwMW/J9smctonc9dUHt/FQdH+
         WXA4gucqjRpz8nIqNFhXGcUNhX3wrfjlX5x5lCPyvaggwHtO+L71qskp/P5fNhnirRi2
         9qAA==
X-Gm-Message-State: APjAAAWVrmFU8CrEvcuYj0x1+Kyff5kV243hbJBqHXhDwmQ1QYhoN4vD
        P0pcloJ2IvuWyTbcaahh2oBY6a/L
X-Google-Smtp-Source: APXvYqxjTTXs5htt1a65KzbwzRu0fdwhMYscANOlfzQ8yMquP/GqV5fV2VapRuW8JrHMKNL3KJA5lA==
X-Received: by 2002:adf:edc5:: with SMTP id v5mr16374652wro.322.1574098139378;
        Mon, 18 Nov 2019 09:28:59 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id b3sm21837wmj.44.2019.11.18.09.28.58
        for <kvm@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Nov 2019 09:28:58 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] x86: add tests for MSR_IA32_TSX_CTRL
Date:   Mon, 18 Nov 2019 18:28:56 +0100
Message-Id: <1574098136-48779-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 lib/x86/msr.h       | 14 +++++++++++++
 lib/x86/processor.h |  2 ++
 x86/Makefile.common |  2 +-
 x86/tsx-ctrl.c      | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 x86/vmexit.c        | 12 +++++++++++
 5 files changed, 89 insertions(+), 1 deletion(-)
 create mode 100644 x86/tsx-ctrl.c

diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index abf0d93..8dca964 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -221,6 +221,20 @@
 #define MSR_IA32_UCODE_WRITE		0x00000079
 #define MSR_IA32_UCODE_REV		0x0000008b
 
+#define MSR_IA32_ARCH_CAPABILITIES	0x0000010a
+#define ARCH_CAP_RDCL_NO		(1ULL << 0)
+#define ARCH_CAP_IBRS_ALL		(1ULL << 1)
+#define ARCH_CAP_SKIP_VMENTRY_L1DFLUSH	(1ULL << 3)
+#define ARCH_CAP_SSB_NO			(1ULL << 4)
+#define ARCH_CAP_MDS_NO			(1ULL << 5)
+#define ARCH_CAP_PSCHANGE_MC_NO		(1ULL << 6)
+#define ARCH_CAP_TSX_CTRL_MSR		(1ULL << 7)
+#define ARCH_CAP_TAA_NO			(1ULL << 8)
+
+#define MSR_IA32_TSX_CTRL		0x00000122
+#define TSX_CTRL_RTM_DISABLE		(1ULL << 0)
+#define TSX_CTRL_CPUID_CLEAR		(1ULL << 1)
+
 #define MSR_IA32_PERF_STATUS		0x00000198
 #define MSR_IA32_PERF_CTL		0x00000199
 
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 3f461dc..7057180 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -137,6 +137,7 @@ static inline u8 cpuid_maxphyaddr(void)
 #define	X86_FEATURE_XMM			(CPUID(0x1, 0, EDX, 25))
 #define	X86_FEATURE_XMM2		(CPUID(0x1, 0, EDX, 26))
 #define	X86_FEATURE_TSC_ADJUST		(CPUID(0x7, 0, EBX, 1))
+#define	X86_FEATURE_HLE			(CPUID(0x7, 0, EBX, 4))
 #define	X86_FEATURE_INVPCID_SINGLE	(CPUID(0x7, 0, EBX, 7))
 #define	X86_FEATURE_INVPCID		(CPUID(0x7, 0, EBX, 10))
 #define	X86_FEATURE_RTM			(CPUID(0x7, 0, EBX, 11))
@@ -149,6 +150,7 @@ static inline u8 cpuid_maxphyaddr(void)
 #define	X86_FEATURE_LA57		(CPUID(0x7, 0, ECX, 16))
 #define	X86_FEATURE_RDPID		(CPUID(0x7, 0, ECX, 22))
 #define	X86_FEATURE_SPEC_CTRL		(CPUID(0x7, 0, EDX, 26))
+#define	X86_FEATURE_ARCH_CAPABILITIES	(CPUID(0x7, 0, EDX, 29))
 #define	X86_FEATURE_NX			(CPUID(0x80000001, 0, EDX, 20))
 #define	X86_FEATURE_RDPRU		(CPUID(0x80000008, 0, EBX, 4))
 
diff --git a/x86/Makefile.common b/x86/Makefile.common
index e612dbe..b157154 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -58,7 +58,7 @@ tests-common = $(TEST_DIR)/vmexit.flat $(TEST_DIR)/tsc.flat \
                $(TEST_DIR)/init.flat $(TEST_DIR)/smap.flat \
                $(TEST_DIR)/hyperv_synic.flat $(TEST_DIR)/hyperv_stimer.flat \
                $(TEST_DIR)/hyperv_connections.flat \
-               $(TEST_DIR)/umip.flat
+               $(TEST_DIR)/umip.flat $(TEST_DIR)/tsx-ctrl.flat
 
 ifdef API
 tests-api = api/api-sample api/dirty-log api/dirty-log-perf
diff --git a/x86/tsx-ctrl.c b/x86/tsx-ctrl.c
new file mode 100644
index 0000000..f482cb5
--- /dev/null
+++ b/x86/tsx-ctrl.c
@@ -0,0 +1,60 @@
+/* TSX tests */
+
+#include "libcflat.h"
+#include "processor.h"
+#include "msr.h"
+
+static bool try_transaction(void)
+{
+    unsigned x;
+    int i;
+
+    for (i = 0; i < 100; i++) {
+        x = 0;
+        /*
+         * The value before the transaction is important, so make the
+         * operand input/output.
+         */
+        asm volatile("xbegin 2f; movb $1, %0; xend; 2:" : "+m" (x) : : "eax");
+        if (x) {
+            return true;
+        }
+    }
+    return false;
+}
+
+int main(int ac, char **av)
+{
+    if (!this_cpu_has(X86_FEATURE_RTM)) {
+        report_skip("TSX not available");
+	return 0;
+    }
+    if (!this_cpu_has(X86_FEATURE_ARCH_CAPABILITIES)) {
+        report_skip("ARCH_CAPABILITIES not available");
+	return 0;
+    }
+    if (!(rdmsr(MSR_IA32_ARCH_CAPABILITIES) & ARCH_CAP_TSX_CTRL_MSR)) {
+        report_skip("TSX_CTRL not available");
+	return 0;
+    }
+
+    report("TSX_CTRL should be 0", rdmsr(MSR_IA32_TSX_CTRL) == 0);
+    report("Transactions do not abort", try_transaction());
+
+    wrmsr(MSR_IA32_TSX_CTRL, TSX_CTRL_CPUID_CLEAR);
+    report("TSX_CTRL hides RTM", !this_cpu_has(X86_FEATURE_RTM));
+    report("TSX_CTRL hides HLE", !this_cpu_has(X86_FEATURE_HLE));
+
+    /* Microcode might hide HLE unconditionally */
+    wrmsr(MSR_IA32_TSX_CTRL, 0);
+    report("TSX_CTRL=0 unhides RTM", this_cpu_has(X86_FEATURE_RTM));
+
+    wrmsr(MSR_IA32_TSX_CTRL, TSX_CTRL_RTM_DISABLE);
+    report("TSX_CTRL causes transactions to abort", !try_transaction());
+
+    wrmsr(MSR_IA32_TSX_CTRL, 0);
+    report("TSX_CTRL=0 causes transactions to succeed", try_transaction());
+
+    return report_summary();
+}
+
diff --git a/x86/vmexit.c b/x86/vmexit.c
index 81b743b..acdcbdc 100644
--- a/x86/vmexit.c
+++ b/x86/vmexit.c
@@ -434,6 +434,17 @@ static void tscdeadline(void)
 	while (x == 0) barrier();
 }
 
+static void wr_tsx_ctrl_msr(void)
+{
+	wrmsr(MSR_IA32_TSX_CTRL, 0);
+}
+
+static int has_tsx_ctrl(void)
+{
+    return this_cpu_has(X86_FEATURE_ARCH_CAPABILITIES)
+	    && (rdmsr(MSR_IA32_ARCH_CAPABILITIES) & ARCH_CAP_TSX_CTRL_MSR);
+}
+
 static void wr_ibrs_msr(void)
 {
 	wrmsr(MSR_IA32_SPEC_CTRL, 1);
@@ -478,6 +489,7 @@ static struct test tests[] = {
 	{ ipi_halt, "ipi_halt", is_smp, .parallel = 0, },
 	{ ple_round_robin, "ple_round_robin", .parallel = 1 },
 	{ wr_kernel_gs_base, "wr_kernel_gs_base", .parallel = 1 },
+	{ wr_tsx_ctrl_msr, "wr_tsx_ctrl_msr", has_tsx_ctrl, .parallel = 1, },
 	{ wr_ibrs_msr, "wr_ibrs_msr", has_spec_ctrl, .parallel = 1 },
 	{ wr_ibpb_msr, "wr_ibpb_msr", has_ibpb, .parallel = 1 },
 	{ wr_tsc_adjust_msr, "wr_tsc_adjust_msr", .parallel = 1 },
-- 
1.8.3.1

