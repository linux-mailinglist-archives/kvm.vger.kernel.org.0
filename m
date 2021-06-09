Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF7C3A1CCB
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 20:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhFISc6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 14:32:58 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:50757 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbhFISc4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 14:32:56 -0400
Received: by mail-pj1-f41.google.com with SMTP id g4so1959962pjk.0
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 11:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aNx0tA5Vs9m9kIMEzCJ3O6wSOTh+ZL6QRIQmS9jrPkI=;
        b=XX9cVuPcLUjnY20exj7R8sXeW05ChNTKR5Shu14qJxfdTC9UjiwFPlTn5ZxFK5Efzo
         OCBmYZtPLQVM9LWvEmFH8+Hg69xZJFZpMqbsJZwMZYFGxmYAriZUmbSR0PjVKc+mZSpJ
         zuh89sp8tp08NSRuRpMqvzqKVLZO7MD9MLkETjGaOaGNXgm1pH8mRxxhO1l/hCyOukwP
         wjPRawxbxkVm83t87da3GS/eHEuovKKCZdywRR0s8g2k4d/f2ubCrEal1PM0kbEnarUC
         QmLCQLk2mLXAxBhJxRzCvRTCGKHeO9ZiIXHDErcshJcLZBjNF+/djD3Aa67yS3Uzb+Rb
         ajRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aNx0tA5Vs9m9kIMEzCJ3O6wSOTh+ZL6QRIQmS9jrPkI=;
        b=V945hhXpTQd9/PcWNGw+VrY1S7cFKfWTbaY6PP0ddLdsC4RrPNtPHlapAXgLo76tbw
         s561uou7VF7bBNKS7jrXqwrh6Z2keq3etGSSvzq0jm7fYJjpEQ/+P+F4Dcg4OWEOW+yS
         FKMmiU34sgNoswWFnC7ofuqZdPHT/D7xwzLr0BFc+v75ImV9CS7JTJWUn7+nRvQrGOL0
         l/hAupMFyDGe15KiC/5p52TUP5VrsqBFgbuml5WzzR6pa230Pzc4uD8RFqDqQSrNdK0K
         If5zrX3Ae8Oc6EJ0N4QEWtvxyugGnhfrwCG7YNyAHR87+YemlTsjhqdvlffCgxYj8GDT
         702w==
X-Gm-Message-State: AOAM532V6YnwOFHF4yqhV7vHpiVadnXEkUwl4JJKBwsZFLlXjyiPC3xQ
        NFJ0iLB+kmgN9qF84z416Zs3HRcDJHRlHQ==
X-Google-Smtp-Source: ABdhPJzntxmFRSZWxYBBdGnES0Tjz2niOTEzrrF9MvJj/nFzZLrfuS1CJBKs0ILZYyLSGqTvaP1y4g==
X-Received: by 2002:a17:902:724c:b029:ef:571f:8894 with SMTP id c12-20020a170902724cb02900ef571f8894mr871297pll.49.1623263401512;
        Wed, 09 Jun 2021 11:30:01 -0700 (PDT)
Received: from ubuntu-server-2004.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id y34sm249092pfa.181.2021.06.09.11.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 11:30:01 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH 4/8] x86/hypercall: enable the test on non-KVM environment
Date:   Wed,  9 Jun 2021 18:29:41 +0000
Message-Id: <20210609182945.36849-5-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210609182945.36849-1-nadav.amit@gmail.com>
References: <20210609182945.36849-1-nadav.amit@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <nadav.amit@gmail.com>

KVM knows to emulate both vmcall and vmmcall regardless of the
actual architecture. Native hardware does not behave this way. Based on
the availability of test-device, figure out that the test is run on
non-KVM environment, and if so, run vmcall/vmmcall based on the actual
architecture.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 lib/x86/processor.h |  8 ++++++++
 x86/hypercall.c     | 31 +++++++++++++++++++++++--------
 2 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index abc04b0..517ee70 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -118,6 +118,14 @@ static inline u8 cpuid_maxphyaddr(void)
     return raw_cpuid(0x80000008, 0).a & 0xff;
 }
 
+static inline bool is_intel(void)
+{
+	struct cpuid c = cpuid(0);
+	u32 name[4] = {c.b, c.d, c.c };
+
+	return strcmp((char *)name, "GenuineIntel") == 0;
+}
+
 #define	CPUID(a, b, c, d) ((((unsigned long long) a) << 32) | (b << 16) | \
 			  (c << 8) | d)
 
diff --git a/x86/hypercall.c b/x86/hypercall.c
index 28760e3..a02ee33 100644
--- a/x86/hypercall.c
+++ b/x86/hypercall.c
@@ -2,6 +2,7 @@
 #include "vm.h"
 #include "desc.h"
 #include "alloc_page.h"
+#include "fwcfg.h"
 
 #define KVM_HYPERCALL_INTEL ".byte 0x0f,0x01,0xc1"
 #define KVM_HYPERCALL_AMD ".byte 0x0f,0x01,0xd9"
@@ -51,10 +52,18 @@ test_edge(void)
 
 int main(int ac, char **av)
 {
-	kvm_hypercall0_intel(-1u);
-	printf("Hypercall via VMCALL: OK\n");
-	kvm_hypercall0_amd(-1u);
-	printf("Hypercall via VMMCALL: OK\n");
+	bool test_vmcall = !no_test_device || is_intel();
+	bool test_vmmcall = !no_test_device || !is_intel();
+
+	if (test_vmcall) {
+		kvm_hypercall0_intel(-1u);
+		printf("Hypercall via VMCALL: OK\n");
+	}
+
+	if (test_vmmcall) {
+		kvm_hypercall0_amd(-1u);
+		printf("Hypercall via VMMCALL: OK\n");
+	}
 
 #ifdef __x86_64__
 	setup_vm();
@@ -70,12 +79,18 @@ int main(int ac, char **av)
 	topmost[4093] = 0x0f;
 	topmost[4094] = 0x01;
 	topmost[4095] = 0xc1;
-	report(test_edge(),
-	       "VMCALL on edge of canonical address space (intel)");
+
+	if (test_vmcall) {
+		report(test_edge(),
+		       "VMCALL on edge of canonical address space (intel)");
+	}
 
 	topmost[4095] = 0xd9;
-	report(test_edge(),
-	       "VMMCALL on edge of canonical address space (AMD)");
+
+	if (test_vmmcall) {
+		report(test_edge(),
+		       "VMMCALL on edge of canonical address space (AMD)");
+	}
 #endif
 
 	return report_summary();
-- 
2.25.1

