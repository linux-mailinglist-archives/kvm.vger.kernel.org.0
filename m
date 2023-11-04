Return-Path: <kvm+bounces-562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D21817E0C82
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 01:04:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A879282016
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 00:04:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E19A0C120;
	Sat,  4 Nov 2023 00:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VssZ4LX+"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4662BE5E
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 00:03:17 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39FB1701
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 17:03:10 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-da033914f7cso3045326276.0
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 17:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699056189; x=1699660989; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SNIXMWVI/rV/XhYyCH+yp45fAcyW+5zQ2DF9WMsUi14=;
        b=VssZ4LX+pPY3agwjOGRmswQ9nVwGuaTp5aupScQcgT2v7SHoKcmAHE+dhIWxCP9rpd
         sNTIt5xppLlFP7dkjDONPr4mHkpAiRcrEyuiAb9VbQaz4RzMPxSJnh6hDahCSStjpqA2
         wY9HVkRgGeK2FVPX6EsEoUnUx0dOTdJ4g1bOcv2z3B0MVk+S3gVpe9I6TZo6UCAeKH7w
         yt8hv2LFGtJqodOvXXRQ0YetYS0hi9qicXJ8QTBRwSzsyD/ta9fIUxfDhcbG4i2CYVZk
         E0RMEtUblqtWFuMQxSzHZ7ofbgkUqmO+rJeq5dVBWWXQ5vJhC+37+rpzMe8GouehF/uv
         pR6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699056189; x=1699660989;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SNIXMWVI/rV/XhYyCH+yp45fAcyW+5zQ2DF9WMsUi14=;
        b=Ud0b3McBsq+mqHudSqEJisDlmByhakbJsKykKOV0L/XFsmmRJMGuUGGVuKhEQ40fbA
         xArs/onIexlufPVa+cFuZU2LXGylCdeRA5d/X/emGip63maBOLRaY5abHobilvZhz1T2
         XzQxVGxqx0UrCF5tydWPthyj62NhaNK4EkpBpwjNDF6uHKbmFiUiZ/cA787iAVzYPOAv
         i82ipJRSz96or1aQelfzpvpIr2aJFfB4f2yYOf3qKgBmG4vW5bfdemVwvhHFuefNigDT
         kaesXPOHDhJQGeJSRGIWLc2JXbmiLK3t2rX4+jYf23zvszzGITie93HbZKjgA//9Sgi7
         J9qQ==
X-Gm-Message-State: AOJu0YyYhFAcnFFBVUypH/hrcBPV0u51w2vGCYBkvj6GqtHKSHw8LaxT
	ViMod8VeuSEmQK3PhfIfFJlFhH/eXWo=
X-Google-Smtp-Source: AGHT+IGccoeoDvnRLxIfU7C7cqvqZ9GHc3Sgsk4Gov+293CUOKBuMEeG3EOjncb6JHuv/yY8RgRQLBz4taU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1083:b0:d9a:c3b8:4274 with SMTP id
 v3-20020a056902108300b00d9ac3b84274mr544419ybu.7.1699056189426; Fri, 03 Nov
 2023 17:03:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Nov 2023 17:02:33 -0700
In-Reply-To: <20231104000239.367005-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231104000239.367005-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231104000239.367005-16-seanjc@google.com>
Subject: [PATCH v6 15/20] KVM: selftests: Expand PMU counters test to verify
 LLC events
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Like Xu <likexu@tencent.com>, 
	Jim Mattson <jmattson@google.com>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Expand the PMU counters test to verify that LLC references and misses have
non-zero counts when the code being executed while the LLC event(s) is
active is evicted via CFLUSH{,OPT}.  Note, CLFLUSH{,OPT} requires a fence
of some kind to ensure the cache lines are flushed before execution
continues.  Use MFENCE for simplicity (performance is not a concern).

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 59 +++++++++++++------
 1 file changed, 40 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index 5e3a1575bffc..780f62e6a0f2 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -14,9 +14,9 @@
 /*
  * Number of "extra" instructions that will be counted, i.e. the number of
  * instructions that are needed to set up the loop and then disabled the
- * counter.  2 MOV, 2 XOR, 1 WRMSR.
+ * counter.  1 CLFLUSH/CLFLUSHOPT/NOP, 1 MFENCE, 2 MOV, 2 XOR, 1 WRMSR.
  */
-#define NUM_EXTRA_INSNS		5
+#define NUM_EXTRA_INSNS		7
 #define NUM_INSNS_RETIRED	(NUM_BRANCHES + NUM_EXTRA_INSNS)
 
 static uint8_t kvm_pmu_version;
@@ -107,6 +107,12 @@ static void guest_assert_event_count(uint8_t idx,
 	case INTEL_ARCH_BRANCHES_RETIRED:
 		GUEST_ASSERT_EQ(count, NUM_BRANCHES);
 		break;
+	case INTEL_ARCH_LLC_REFERENCES:
+	case INTEL_ARCH_LLC_MISSES:
+		if (!this_cpu_has(X86_FEATURE_CLFLUSHOPT) &&
+		    !this_cpu_has(X86_FEATURE_CLFLUSH))
+			break;
+		fallthrough;
 	case INTEL_ARCH_CPU_CYCLES:
 	case INTEL_ARCH_REFERENCE_CYCLES:
 		GUEST_ASSERT_NE(count, 0);
@@ -123,29 +129,44 @@ static void guest_assert_event_count(uint8_t idx,
 	GUEST_ASSERT_EQ(_rdpmc(pmc), 0xdead);
 }
 
+/*
+ * Enable and disable the PMC in a monolithic asm blob to ensure that the
+ * compiler can't insert _any_ code into the measured sequence.  Note, ECX
+ * doesn't need to be clobbered as the input value, @pmc_msr, is restored
+ * before the end of the sequence.
+ *
+ * If CLFUSH{,OPT} is supported, flush the cacheline containing (at least) the
+ * start of the loop to force LLC references and misses, i.e. to allow testing
+ * that those events actually count.
+ */
+#define GUEST_MEASURE_EVENT(_msr, _value, clflush)				\
+do {										\
+	__asm__ __volatile__("wrmsr\n\t"					\
+			     clflush "\n\t"					\
+			     "mfence\n\t"					\
+			     "1: mov $" __stringify(NUM_BRANCHES) ", %%ecx\n\t"	\
+			     "loop .\n\t"					\
+			     "mov %%edi, %%ecx\n\t"				\
+			     "xor %%eax, %%eax\n\t"				\
+			     "xor %%edx, %%edx\n\t"				\
+			     "wrmsr\n\t"					\
+			     :: "a"((uint32_t)_value), "d"(_value >> 32),	\
+				"c"(_msr), "D"(_msr)				\
+	);									\
+} while (0)
+
 static void __guest_test_arch_event(uint8_t idx, struct kvm_x86_pmu_feature event,
 				    uint32_t pmc, uint32_t pmc_msr,
 				    uint32_t ctrl_msr, uint64_t ctrl_msr_value)
 {
 	wrmsr(pmc_msr, 0);
 
-	/*
-	 * Enable and disable the PMC in a monolithic asm blob to ensure that
-	 * the compiler can't insert _any_ code into the measured sequence.
-	 * Note, ECX doesn't need to be clobbered as the input value, @pmc_msr,
-	 * is restored before the end of the sequence.
-	 */
-	__asm__ __volatile__("wrmsr\n\t"
-			     "mov $" __stringify(NUM_BRANCHES) ", %%ecx\n\t"
-			     "loop .\n\t"
-			     "mov %%edi, %%ecx\n\t"
-			     "xor %%eax, %%eax\n\t"
-			     "xor %%edx, %%edx\n\t"
-			     "wrmsr\n\t"
-			     :: "a"((uint32_t)ctrl_msr_value),
-				"d"(ctrl_msr_value >> 32),
-				"c"(ctrl_msr), "D"(ctrl_msr)
-			     );
+	if (this_cpu_has(X86_FEATURE_CLFLUSHOPT))
+		GUEST_MEASURE_EVENT(ctrl_msr, ctrl_msr_value, "clflushopt 1f");
+	else if (this_cpu_has(X86_FEATURE_CLFLUSH))
+		GUEST_MEASURE_EVENT(ctrl_msr, ctrl_msr_value, "clflush 1f");
+	else
+		GUEST_MEASURE_EVENT(ctrl_msr, ctrl_msr_value, "nop");
 
 	guest_assert_event_count(idx, event, pmc, pmc_msr);
 }
-- 
2.42.0.869.gea05f2083d-goog


