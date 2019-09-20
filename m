Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06BE9B99EF
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2019 01:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407052AbfITXIL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 19:08:11 -0400
Received: from mail-qt1-f202.google.com ([209.85.160.202]:33856 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407049AbfITXIK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Sep 2019 19:08:10 -0400
Received: by mail-qt1-f202.google.com with SMTP id y10so10011360qti.1
        for <kvm@vger.kernel.org>; Fri, 20 Sep 2019 16:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ytV4HUGMPUG3noaOCrZb1OFf1mumPpmyS7qh+vN6Ff8=;
        b=YYyIbwXekgZXCnSg6HnHSYWc6LBE8WGSDTyilsi5rLDD7IZTUDeDeWT5SubSrOjR7S
         p8g48EmtETsJXVbrtmNvMvA3tRnjiRl7rb+eVGJPa7FuwFGFCLNtdaISt0twQPD0ZO3w
         j7V4TF5egHaMPNZZ7KoeoQE3avxoQHHshKKdE6PoOQwSlt+HNBBxAdO+BeO+o/bNm8x9
         3CQdpgfhbgFwf31cnnDws6nlIremy7/ZR0c7YqzNpd3uI8v4HnJ4QUaXx9mjh02vSPjA
         YXy31O4ZT6BSyuae8g/5+00vLDW1btC3Ji2zYvfb2hwBcV9vXOmqMOlSmKEybNDkd+Kv
         YurQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ytV4HUGMPUG3noaOCrZb1OFf1mumPpmyS7qh+vN6Ff8=;
        b=DxDrdeUFQfhO/RSNyDANBAT18kixQ4vT130sji5iZzisww4KYk8NYTpOhousr2rCho
         xdhHVDRaXHvxZ3f++5/XBjbp2dYCEv4O/M5t0V48r65L9r/ntHvFr8/uRfoTvx7gpueR
         MrPVx6y0G4Ybrs2ymg4IQeZ34tXIl2RgEvNelGxO3g7j8ZbtrdrkSmkqlavSEDtrm8Qm
         yvTPenjeGJfN75rZYuBgz07zIM2hiGtqFAvKcwDDf1Hr3Yl/gpTMFgJmClkpvmqJCN9n
         XywFJSQp/bpdvYRsdtFuMb60/D0kM8ysWA86vYuPOQr1FKp6SxNhPLx2/JVTh+OlChx4
         iIhQ==
X-Gm-Message-State: APjAAAXAdL03DTFPjKFwGJAKV4sd9CSfXqfpzIq+JtlJSTOeXocSIcQF
        0mkJhal9cqpZa7/S0zexPm9nF/gx7A5dsmBc+wohtN2D+/YxJpldN/Y2HNI10QHFTpxe91Ss3Yg
        dn4MUqUlHi+kKVlpa+Mx58JJgFSTij/De+M/o+bcqhhqvQlmmj9QAKBBU1eFtdZM=
X-Google-Smtp-Source: APXvYqyntiMVBkZ+US0xboMvO/T1n0+/PMD0f6Zea5CHE67rrcAfRXK+Gna0stR+yQ74biJAxw80QVfLL1F/Hw==
X-Received: by 2002:a37:4c14:: with SMTP id z20mr6617564qka.296.1569020889719;
 Fri, 20 Sep 2019 16:08:09 -0700 (PDT)
Date:   Fri, 20 Sep 2019 16:08:05 -0700
Message-Id: <20190920230805.111064-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
Subject: [kvm-unit-tests PATCH v2] kvm-unit-test: x86: Add RDPRU test
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running in a VM, ensure that support for RDPRU is not enumerated
in the guest's CPUID and that the RDPRU instruction raises #UD.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 lib/x86/processor.h |  2 ++
 x86/Makefile.x86_64 |  1 +
 x86/rdpru.c         | 27 +++++++++++++++++++++++++++
 x86/unittests.cfg   |  5 +++++
 4 files changed, 35 insertions(+)
 create mode 100644 x86/rdpru.c

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index b1c579b..fe72c13 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -131,6 +131,7 @@ static inline u8 cpuid_maxphyaddr(void)
 #define	X86_FEATURE_XSAVE		(CPUID(0x1, 0, ECX, 26))
 #define	X86_FEATURE_OSXSAVE		(CPUID(0x1, 0, ECX, 27))
 #define	X86_FEATURE_RDRAND		(CPUID(0x1, 0, ECX, 30))
+#define	X86_FEATURE_HYPERVISOR		(CPUID(0x1, 0, ECX, 31))
 #define	X86_FEATURE_MCE			(CPUID(0x1, 0, EDX, 7))
 #define	X86_FEATURE_APIC		(CPUID(0x1, 0, EDX, 9))
 #define	X86_FEATURE_CLFLUSH		(CPUID(0x1, 0, EDX, 19))
@@ -150,6 +151,7 @@ static inline u8 cpuid_maxphyaddr(void)
 #define	X86_FEATURE_RDPID		(CPUID(0x7, 0, ECX, 22))
 #define	X86_FEATURE_SPEC_CTRL		(CPUID(0x7, 0, EDX, 26))
 #define	X86_FEATURE_NX			(CPUID(0x80000001, 0, EDX, 20))
+#define	X86_FEATURE_RDPRU		(CPUID(0x80000008, 0, EBX, 4))
 
 /*
  * AMD CPUID features
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index 51f9b80..010102b 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -19,6 +19,7 @@ tests += $(TEST_DIR)/vmx.flat
 tests += $(TEST_DIR)/tscdeadline_latency.flat
 tests += $(TEST_DIR)/intel-iommu.flat
 tests += $(TEST_DIR)/vmware_backdoors.flat
+tests += $(TEST_DIR)/rdpru.flat
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
diff --git a/x86/rdpru.c b/x86/rdpru.c
new file mode 100644
index 0000000..87a517e
--- /dev/null
+++ b/x86/rdpru.c
@@ -0,0 +1,27 @@
+/* RDPRU test */
+
+#include "libcflat.h"
+#include "processor.h"
+#include "desc.h"
+
+static int rdpru_checking(void)
+{
+	asm volatile (ASM_TRY("1f")
+		      ".byte 0x0f,0x01,0xfd \n\t" /* rdpru */
+		      "1:" : : "c" (0) : "eax", "edx");
+	return exception_vector();
+}
+
+int main(int ac, char **av)
+{
+	setup_idt();
+
+	if (this_cpu_has(X86_FEATURE_HYPERVISOR)) {
+		report("RDPRU not supported", !this_cpu_has(X86_FEATURE_RDPRU));
+		report("RDPRU raises #UD", rdpru_checking() == UD_VECTOR);
+	} else {
+		report_skip("Not in a VM");
+	}
+
+	return report_summary();
+}
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 694ee3d..9764e18 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -221,6 +221,11 @@ file = pcid.flat
 extra_params = -cpu qemu64,+pcid
 arch = x86_64
 
+[rdpru]
+file = rdpru.flat
+extra_params = -cpu host
+arch = x86_64
+
 [umip]
 file = umip.flat
 extra_params = -cpu qemu64,+umip
-- 
2.23.0.351.gc4317032e6-goog

