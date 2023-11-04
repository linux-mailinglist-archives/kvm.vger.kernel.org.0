Return-Path: <kvm+bounces-556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C160F7E0C7B
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 01:03:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 62997B2183B
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 00:03:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 848E38494;
	Sat,  4 Nov 2023 00:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2JNsa86Y"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4C96FBC
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 00:03:02 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F215E19D
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 17:02:58 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d9ab79816a9so3120109276.3
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 17:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699056178; x=1699660978; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1N0GaX165iT66psQLFguu13B6wTdKAbnF/+ecMums54=;
        b=2JNsa86YjKyGvL7VYfvUYmADES12Vl+vE8WEhrOQCHLeyxnf4+Vv/ohEifudVQmAzO
         z9WsetlRVUKMg/IxzWbwU/VCnl+nG2Ykl6p766WnbV6BBmjxp2Do3/btuxnL/GkdbUsc
         xnkCdyHPs7AzYSWuVQyEeIarYXusr9XBL5iWXx5Cfrvu/IpaYSiMNEhm8xcoJnyhAVLn
         VUOWIfaj2V5O0ZIZmVWkWDFe9dY7iuKppsGgUTi1IfP8TPvjczp03qbgN4Gb/dHZlNAD
         U6bv5APthuzZ2A6fD0MiMtrQowfDq6vIOxQSDtG2/gaCmYftRQQcuRcKeH39GhLIRmCF
         zZqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699056178; x=1699660978;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1N0GaX165iT66psQLFguu13B6wTdKAbnF/+ecMums54=;
        b=Y9LvggiYB3XzqJF27VpUf8EfiCo5EH21FT5xBcgZmwLtihQ0Izux6miVLJFZMVRDfW
         8wtOOYm78UsG0e4A9spERnxmwsvVMid1XZKOg4u1UmIgyqwhb13LTPRJT5LsCg5rxh1Y
         radDJhcM98i542Lzl+2SackLLN/Qfias9M3hOw5htfxLTsE6v5HnIX1RvaPqaG1MgV+I
         vnZckYiGljQbHzlVWDX0anQMbsYoSTfA/FIyE5Xze4lF322+0ZQbF/d8qblvW7OrxHvk
         KgBk8/igrCu3rL4HwxxsdDUDDWxvhALpG7DenjN/57wnsCRSRpU0iszSY6TP3MCoN5ej
         /q+A==
X-Gm-Message-State: AOJu0Yyn0wOn7hv6ZyDQEuOZGQsnlXeSNBRPdGr2aWUI+zD59Z11o/gL
	puW1i/1VCGujrIAjb+U8ai0LPeDnzVI=
X-Google-Smtp-Source: AGHT+IEQjT2v/PU5SLXROqSmaHsqanMiphnmX9YeDXgxUYF3idGqF/qqTh4wXE7Jcor4gDmM+946Bm8RILI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:5c2:0:b0:d9a:68de:16a1 with SMTP id
 185-20020a2505c2000000b00d9a68de16a1mr458880ybf.0.1699056178051; Fri, 03 Nov
 2023 17:02:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Nov 2023 17:02:27 -0700
In-Reply-To: <20231104000239.367005-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231104000239.367005-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231104000239.367005-10-seanjc@google.com>
Subject: [PATCH v6 09/20] KVM: selftests: Add pmu.h and lib/pmu.c for common
 PMU assets
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Like Xu <likexu@tencent.com>, 
	Jim Mattson <jmattson@google.com>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Jinrong Liang <cloudliang@tencent.com>

By defining the PMU performance events and masks relevant for x86 in
the new pmu.h and pmu.c, it becomes easier to reference them, minimizing
potential errors in code that handles these values.

Clean up pmu_event_filter_test.c by including pmu.h and removing
unnecessary macros.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
[sean: drop PSEUDO_ARCH_REFERENCE_CYCLES]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile          |  1 +
 tools/testing/selftests/kvm/include/pmu.h     | 84 +++++++++++++++++++
 tools/testing/selftests/kvm/lib/pmu.c         | 28 +++++++
 .../kvm/x86_64/pmu_event_filter_test.c        | 32 ++-----
 4 files changed, 122 insertions(+), 23 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/pmu.h
 create mode 100644 tools/testing/selftests/kvm/lib/pmu.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index a5963ab9215b..44d8d022b023 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -32,6 +32,7 @@ LIBKVM += lib/guest_modes.c
 LIBKVM += lib/io.c
 LIBKVM += lib/kvm_util.c
 LIBKVM += lib/memstress.c
+LIBKVM += lib/pmu.c
 LIBKVM += lib/guest_sprintf.c
 LIBKVM += lib/rbtree.c
 LIBKVM += lib/sparsebit.c
diff --git a/tools/testing/selftests/kvm/include/pmu.h b/tools/testing/selftests/kvm/include/pmu.h
new file mode 100644
index 000000000000..987602c62b51
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/pmu.h
@@ -0,0 +1,84 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2023, Tencent, Inc.
+ */
+#ifndef SELFTEST_KVM_PMU_H
+#define SELFTEST_KVM_PMU_H
+
+#include <stdint.h>
+
+#define X86_PMC_IDX_MAX				64
+#define INTEL_PMC_MAX_GENERIC				32
+#define KVM_PMU_EVENT_FILTER_MAX_EVENTS		300
+
+#define GP_COUNTER_NR_OFS_BIT				8
+#define EVENT_LENGTH_OFS_BIT				24
+
+#define PMU_VERSION_MASK				GENMASK_ULL(7, 0)
+#define EVENT_LENGTH_MASK				GENMASK_ULL(31, EVENT_LENGTH_OFS_BIT)
+#define GP_COUNTER_NR_MASK				GENMASK_ULL(15, GP_COUNTER_NR_OFS_BIT)
+#define FIXED_COUNTER_NR_MASK				GENMASK_ULL(4, 0)
+
+#define ARCH_PERFMON_EVENTSEL_EVENT			GENMASK_ULL(7, 0)
+#define ARCH_PERFMON_EVENTSEL_UMASK			GENMASK_ULL(15, 8)
+#define ARCH_PERFMON_EVENTSEL_USR			BIT_ULL(16)
+#define ARCH_PERFMON_EVENTSEL_OS			BIT_ULL(17)
+#define ARCH_PERFMON_EVENTSEL_EDGE			BIT_ULL(18)
+#define ARCH_PERFMON_EVENTSEL_PIN_CONTROL		BIT_ULL(19)
+#define ARCH_PERFMON_EVENTSEL_INT			BIT_ULL(20)
+#define ARCH_PERFMON_EVENTSEL_ANY			BIT_ULL(21)
+#define ARCH_PERFMON_EVENTSEL_ENABLE			BIT_ULL(22)
+#define ARCH_PERFMON_EVENTSEL_INV			BIT_ULL(23)
+#define ARCH_PERFMON_EVENTSEL_CMASK			GENMASK_ULL(31, 24)
+
+#define PMC_MAX_FIXED					16
+#define PMC_IDX_FIXED					32
+
+/* RDPMC offset for Fixed PMCs */
+#define PMC_FIXED_RDPMC_BASE				BIT_ULL(30)
+#define PMC_FIXED_RDPMC_METRICS			BIT_ULL(29)
+
+#define FIXED_BITS_MASK				0xFULL
+#define FIXED_BITS_STRIDE				4
+#define FIXED_0_KERNEL					BIT_ULL(0)
+#define FIXED_0_USER					BIT_ULL(1)
+#define FIXED_0_ANYTHREAD				BIT_ULL(2)
+#define FIXED_0_ENABLE_PMI				BIT_ULL(3)
+
+#define fixed_bits_by_idx(_idx, _bits)			\
+	((_bits) << ((_idx) * FIXED_BITS_STRIDE))
+
+#define AMD64_NR_COUNTERS				4
+#define AMD64_NR_COUNTERS_CORE				6
+
+#define PMU_CAP_FW_WRITES				BIT_ULL(13)
+#define PMU_CAP_LBR_FMT				0x3f
+
+enum intel_pmu_architectural_events {
+	/*
+	 * The order of the architectural events matters as support for each
+	 * event is enumerated via CPUID using the index of the event.
+	 */
+	INTEL_ARCH_CPU_CYCLES,
+	INTEL_ARCH_INSTRUCTIONS_RETIRED,
+	INTEL_ARCH_REFERENCE_CYCLES,
+	INTEL_ARCH_LLC_REFERENCES,
+	INTEL_ARCH_LLC_MISSES,
+	INTEL_ARCH_BRANCHES_RETIRED,
+	INTEL_ARCH_BRANCHES_MISPREDICTED,
+	NR_INTEL_ARCH_EVENTS,
+};
+
+enum amd_pmu_k7_events {
+	AMD_ZEN_CORE_CYCLES,
+	AMD_ZEN_INSTRUCTIONS,
+	AMD_ZEN_BRANCHES,
+	AMD_ZEN_BRANCH_MISSES,
+	NR_AMD_ARCH_EVENTS,
+};
+
+extern const uint64_t intel_pmu_arch_events[];
+extern const uint64_t amd_pmu_arch_events[];
+extern const int intel_pmu_fixed_pmc_events[];
+
+#endif /* SELFTEST_KVM_PMU_H */
diff --git a/tools/testing/selftests/kvm/lib/pmu.c b/tools/testing/selftests/kvm/lib/pmu.c
new file mode 100644
index 000000000000..27a6c35f98a1
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/pmu.c
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2023, Tencent, Inc.
+ */
+
+#include <stdint.h>
+
+#include "pmu.h"
+
+/* Definitions for Architectural Performance Events */
+#define ARCH_EVENT(select, umask) (((select) & 0xff) | ((umask) & 0xff) << 8)
+
+const uint64_t intel_pmu_arch_events[] = {
+	[INTEL_ARCH_CPU_CYCLES]			= ARCH_EVENT(0x3c, 0x0),
+	[INTEL_ARCH_INSTRUCTIONS_RETIRED]	= ARCH_EVENT(0xc0, 0x0),
+	[INTEL_ARCH_REFERENCE_CYCLES]		= ARCH_EVENT(0x3c, 0x1),
+	[INTEL_ARCH_LLC_REFERENCES]		= ARCH_EVENT(0x2e, 0x4f),
+	[INTEL_ARCH_LLC_MISSES]			= ARCH_EVENT(0x2e, 0x41),
+	[INTEL_ARCH_BRANCHES_RETIRED]		= ARCH_EVENT(0xc4, 0x0),
+	[INTEL_ARCH_BRANCHES_MISPREDICTED]	= ARCH_EVENT(0xc5, 0x0),
+};
+
+const uint64_t amd_pmu_arch_events[] = {
+	[AMD_ZEN_CORE_CYCLES]			= ARCH_EVENT(0x76, 0x00),
+	[AMD_ZEN_INSTRUCTIONS]			= ARCH_EVENT(0xc0, 0x00),
+	[AMD_ZEN_BRANCHES]			= ARCH_EVENT(0xc2, 0x00),
+	[AMD_ZEN_BRANCH_MISSES]			= ARCH_EVENT(0xc3, 0x00),
+};
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 283cc55597a4..b6e4f57a8651 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -11,31 +11,18 @@
  */
 
 #define _GNU_SOURCE /* for program_invocation_short_name */
-#include "test_util.h"
+
 #include "kvm_util.h"
+#include "pmu.h"
 #include "processor.h"
-
-/*
- * In lieu of copying perf_event.h into tools...
- */
-#define ARCH_PERFMON_EVENTSEL_OS			(1ULL << 17)
-#define ARCH_PERFMON_EVENTSEL_ENABLE			(1ULL << 22)
-
-/* End of stuff taken from perf_event.h. */
-
-/* Oddly, this isn't in perf_event.h. */
-#define ARCH_PERFMON_BRANCHES_RETIRED		5
+#include "test_util.h"
 
 #define NUM_BRANCHES 42
-#define INTEL_PMC_IDX_FIXED		32
-
-/* Matches KVM_PMU_EVENT_FILTER_MAX_EVENTS in pmu.c */
-#define MAX_FILTER_EVENTS		300
 #define MAX_TEST_EVENTS		10
 
 #define PMU_EVENT_FILTER_INVALID_ACTION		(KVM_PMU_EVENT_DENY + 1)
 #define PMU_EVENT_FILTER_INVALID_FLAGS			(KVM_PMU_EVENT_FLAGS_VALID_MASK << 1)
-#define PMU_EVENT_FILTER_INVALID_NEVENTS		(MAX_FILTER_EVENTS + 1)
+#define PMU_EVENT_FILTER_INVALID_NEVENTS		(KVM_PMU_EVENT_FILTER_MAX_EVENTS + 1)
 
 /*
  * This is how the event selector and unit mask are stored in an AMD
@@ -63,7 +50,6 @@
 
 #define AMD_ZEN_BR_RETIRED EVENT(0xc2, 0)
 
-
 /*
  * "Retired instructions", from Processor Programming Reference
  * (PPR) for AMD Family 17h Model 01h, Revision B1 Processors,
@@ -84,7 +70,7 @@ struct __kvm_pmu_event_filter {
 	__u32 fixed_counter_bitmap;
 	__u32 flags;
 	__u32 pad[4];
-	__u64 events[MAX_FILTER_EVENTS];
+	__u64 events[KVM_PMU_EVENT_FILTER_MAX_EVENTS];
 };
 
 /*
@@ -729,14 +715,14 @@ static void add_dummy_events(uint64_t *events, int nevents)
 
 static void test_masked_events(struct kvm_vcpu *vcpu)
 {
-	int nevents = MAX_FILTER_EVENTS - MAX_TEST_EVENTS;
-	uint64_t events[MAX_FILTER_EVENTS];
+	int nevents = KVM_PMU_EVENT_FILTER_MAX_EVENTS - MAX_TEST_EVENTS;
+	uint64_t events[KVM_PMU_EVENT_FILTER_MAX_EVENTS];
 
 	/* Run the test cases against a sparse PMU event filter. */
 	run_masked_events_tests(vcpu, events, 0);
 
 	/* Run the test cases against a dense PMU event filter. */
-	add_dummy_events(events, MAX_FILTER_EVENTS);
+	add_dummy_events(events, KVM_PMU_EVENT_FILTER_MAX_EVENTS);
 	run_masked_events_tests(vcpu, events, nevents);
 }
 
@@ -818,7 +804,7 @@ static void intel_run_fixed_counter_guest_code(uint8_t fixed_ctr_idx)
 		/* Only OS_EN bit is enabled for fixed counter[idx]. */
 		wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, BIT_ULL(4 * fixed_ctr_idx));
 		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL,
-		      BIT_ULL(INTEL_PMC_IDX_FIXED + fixed_ctr_idx));
+		      BIT_ULL(PMC_IDX_FIXED + fixed_ctr_idx));
 		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
 		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
 
-- 
2.42.0.869.gea05f2083d-goog


