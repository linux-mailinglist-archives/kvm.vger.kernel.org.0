Return-Path: <kvm+bounces-5939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 384AF829096
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 00:10:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48B4D1C24152
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 23:10:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 877F6495F9;
	Tue,  9 Jan 2024 23:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PNBGrC20"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C46F48CF5
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 23:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5f240ace2efso48088037b3.1
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 15:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704841412; x=1705446212; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=UmbwugfbZjx9BroAj5L+ZfHrFa8HDb/zVhEfTcoxtfc=;
        b=PNBGrC20KjTlNRwSmRKglaBQjnWMvV2NhhcSeGpSO/eGbavokHb/tkfZE+BEBoEKrA
         +NR40h+6MmYuAfYNBdv9VpTE/UthS6U7sGharyAphHCgt3Wz+6OwkpMyiE5DTMXYr0i5
         n56s+CvBO7pmwLu0fTzrlTpWdbqnocEml/qNodSZ9oZY6+3uXZ690PMwR9OdnZS/x6WD
         lUugeQDOiA5BaAP0WZiSjKl6iODsx6uvSwyoqFjF0QFnpi53j+Wa3WK4wcUcFqzHLukF
         7wGmDxp/etNP3oiaAkore0cHA2YxrTV2NNjsUsJHx/X4QU3EdPCYA4FuhdpFgT3Ia6oj
         RWzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704841412; x=1705446212;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UmbwugfbZjx9BroAj5L+ZfHrFa8HDb/zVhEfTcoxtfc=;
        b=F4GpZRC+WXlE3WdZ3fDIqZYACw4yEIMW+JPNApWHnQmO9Q9GAh4inKptv6AcFTnVxe
         tfnQ8kmevXxtmts5zilUyBj1pXc6sI08hN3pCnQQQxTFUr1fzXIkQjIaCLsf/8Uys9oo
         KSE7BavObA8qr0ZLXpXV5K9CFKuWKTKvMAJI0yywm4YgYdvtsv17YdaPFcirTFQ8MLLC
         7yi8Mekt5BI3RhajjecjT82jsZDaVVCgfKDU6yNvXdiwvVscFY2rWIEM3iVg5nHBugC1
         DDgTKQ8QZID4ZdfQwkDTzwfeCOvGnB2dmJ/Co4Wpu7BZoSbYJtHxaiDHAtV9xTBMnrkx
         xAeg==
X-Gm-Message-State: AOJu0YyCyTN73XsGdPRSe0oH3LSci6XCTppTloxFoni1voBy91ruzreb
	U7pHvRlxF9shTBCSVhnRBHWs92UA1JfMfNf/Xg==
X-Google-Smtp-Source: AGHT+IH55KoAefoSAgaGx1KUdGWyk7jVjq0nl1o93I+EEXhXygMCZvACNTy+k9279E6nOb8jlXDG24cKxK0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:b03:b0:5e3:2a36:b4d with SMTP id
 cj3-20020a05690c0b0300b005e32a360b4dmr88378ywb.1.1704841412585; Tue, 09 Jan
 2024 15:03:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 15:02:40 -0800
In-Reply-To: <20240109230250.424295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240109230250.424295-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240109230250.424295-21-seanjc@google.com>
Subject: [PATCH v10 20/29] KVM: selftests: Add functional test for Intel's
 fixed PMU counters
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

From: Jinrong Liang <cloudliang@tencent.com>

Extend the fixed counters test to verify that supported counters can
actually be enabled in the control MSRs, that unsupported counters cannot,
and that enabled counters actually count.

Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
[sean: fold into the rd/wr access test, massage changelog]
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 31 ++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index b07294af71a3..f5dedd112471 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -332,7 +332,6 @@ static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters
 		vector = wrmsr_safe(msr, 0);
 		GUEST_ASSERT_PMC_MSR_ACCESS(WRMSR, msr, expect_gp, vector);
 	}
-	GUEST_DONE();
 }
 
 static void guest_test_gp_counters(void)
@@ -350,6 +349,7 @@ static void guest_test_gp_counters(void)
 		base_msr = MSR_IA32_PERFCTR0;
 
 	guest_rd_wr_counters(base_msr, MAX_NR_GP_COUNTERS, nr_gp_counters, 0);
+	GUEST_DONE();
 }
 
 static void test_gp_counters(uint8_t pmu_version, uint64_t perf_capabilities,
@@ -373,6 +373,7 @@ static void guest_test_fixed_counters(void)
 {
 	uint64_t supported_bitmask = 0;
 	uint8_t nr_fixed_counters = 0;
+	uint8_t i;
 
 	/* Fixed counters require Architectural vPMU Version 2+. */
 	if (guest_get_pmu_version() >= 2)
@@ -387,6 +388,34 @@ static void guest_test_fixed_counters(void)
 
 	guest_rd_wr_counters(MSR_CORE_PERF_FIXED_CTR0, MAX_NR_FIXED_COUNTERS,
 			     nr_fixed_counters, supported_bitmask);
+
+	for (i = 0; i < MAX_NR_FIXED_COUNTERS; i++) {
+		uint8_t vector;
+		uint64_t val;
+
+		if (i >= nr_fixed_counters && !(supported_bitmask & BIT_ULL(i))) {
+			vector = wrmsr_safe(MSR_CORE_PERF_FIXED_CTR_CTRL,
+					    FIXED_PMC_CTRL(i, FIXED_PMC_KERNEL));
+			__GUEST_ASSERT(vector == GP_VECTOR,
+				       "Expected #GP for counter %u in FIXED_CTR_CTRL", i);
+
+			vector = wrmsr_safe(MSR_CORE_PERF_GLOBAL_CTRL,
+					    FIXED_PMC_GLOBAL_CTRL_ENABLE(i));
+			__GUEST_ASSERT(vector == GP_VECTOR,
+				       "Expected #GP for counter %u in PERF_GLOBAL_CTRL", i);
+			continue;
+		}
+
+		wrmsr(MSR_CORE_PERF_FIXED_CTR0 + i, 0);
+		wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, FIXED_PMC_CTRL(i, FIXED_PMC_KERNEL));
+		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, FIXED_PMC_GLOBAL_CTRL_ENABLE(i));
+		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
+		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+		val = rdmsr(MSR_CORE_PERF_FIXED_CTR0 + i);
+
+		GUEST_ASSERT_NE(val, 0);
+	}
+	GUEST_DONE();
 }
 
 static void test_fixed_counters(uint8_t pmu_version, uint64_t perf_capabilities,
-- 
2.43.0.472.g3155946c3a-goog


