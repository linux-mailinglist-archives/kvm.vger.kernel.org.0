Return-Path: <kvm+bounces-561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 314D47E0C80
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 01:04:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BC632B21992
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 00:04:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14D70BE69;
	Sat,  4 Nov 2023 00:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bs0lrI4s"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34F8BE4E
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 00:03:14 +0000 (UTC)
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0221510F3
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 17:03:08 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1cc23f2226bso20398605ad.2
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 17:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699056187; x=1699660987; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=2N5EUYzKIE6DRanUuff4sje3/Mjprhtofac5KNFLAZk=;
        b=bs0lrI4sAl18FK+Q6ggDjRpcjUspZfbXFqmsD9juxcfNjZURHrQw6+a23cIKlK3/UB
         lcf6GY6HDSsBgf8jLK9JFC860eg91bPJZFNDpsifkTg6YARL/IhHLe3kgROk3+4FvvfB
         20dqn3JDq5VLCjrI/Gaz2PywN4rxhrNHwiBsrWmVuuy684Tk90/P88/bvDGIuJ5WoT5g
         NFd6my6lSQgYw6CT5t0rEWm5uusGjrkY//gYh5SU16YoaFrNMnRLXaI69iEiE85yq39A
         ftIlIQT1YttBaXCcXDVbjAAWPGbxctsGUgtco73scJhHRzHk7zeuokdX2ucRbdl2NPsT
         sWUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699056187; x=1699660987;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2N5EUYzKIE6DRanUuff4sje3/Mjprhtofac5KNFLAZk=;
        b=rPCqWd4/UeSKKnQtC76WoL2GFalbrgFmDsjW6zaMsfwsxRbe3ge8z1tCgwBoCCqn1v
         lVksgdMNHdsrKzHw/W4MwXYhTU+IviI0wM6VzBrvm0fluHPR3LVbJGQ50u0n3b0QsOnI
         ruwHknAKYVXivmyCXRg7SRzVL8w0W5pIsEV8dfZWUSO0xkW6IaCh0ewC54rdZ/HaDUCW
         V9K1YVt4IgQJdhfLFKo2N/IJ5eSlROpfa6YA3FBZds0BQugH9B+tEXRhTgwvntDxE9eK
         /TmW6r7hbBrkoDJmHZmvHGV8OPz4gdiDVo7BQCMOHf9YCVmWC6b8IEOnyd4maOce6ImF
         UmvQ==
X-Gm-Message-State: AOJu0YzFGQGf3Lh9brrMXnURnXjEoYMf7JGXumAc4ejdGBdgQxj9i0mV
	6DsrlFPFmle7KCH0ZJX6duJJxmQBypo=
X-Google-Smtp-Source: AGHT+IGqoPsr7nHMsIRIqS5Cijc5tXUUdVWUCuDH52bcJkptXQ5GvX8eGJ+C1jIxZ8FR/7vCr/kscvaAhjU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d48c:b0:1cc:2f2a:7d33 with SMTP id
 c12-20020a170902d48c00b001cc2f2a7d33mr392773plg.2.1699056187424; Fri, 03 Nov
 2023 17:03:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Nov 2023 17:02:32 -0700
In-Reply-To: <20231104000239.367005-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231104000239.367005-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231104000239.367005-15-seanjc@google.com>
Subject: [PATCH v6 14/20] KVM: selftests: Add functional test for Intel's
 fixed PMU counters
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Like Xu <likexu@tencent.com>, 
	Jim Mattson <jmattson@google.com>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Jinrong Liang <cloudliang@tencent.com>

Extend the fixed counters test to verify that supported counters can
actually be enabled in the control MSRs, that unsupported counters cannot,
and that enabled counters actually count.

Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
[sean: fold into the rd/wr access test, massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 29 ++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index 52b9d9f615eb..5e3a1575bffc 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -324,7 +324,6 @@ static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters
 		vector = wrmsr_safe(msr, 0);
 		GUEST_ASSERT_PMC_MSR_ACCESS(WRMSR, msr, expect_gp, vector);
 	}
-	GUEST_DONE();
 }
 
 static void guest_test_gp_counters(void)
@@ -342,6 +341,7 @@ static void guest_test_gp_counters(void)
 		base_msr = MSR_IA32_PERFCTR0;
 
 	guest_rd_wr_counters(base_msr, MAX_NR_GP_COUNTERS, nr_gp_counters, 0);
+	GUEST_DONE();
 }
 
 static void test_gp_counters(uint8_t pmu_version, uint64_t perf_capabilities,
@@ -365,6 +365,7 @@ static void guest_test_fixed_counters(void)
 {
 	uint64_t supported_bitmask = 0;
 	uint8_t nr_fixed_counters = 0;
+	uint8_t i;
 
 	/* Fixed counters require Architectural vPMU Version 2+. */
 	if (guest_get_pmu_version() >= 2)
@@ -379,6 +380,32 @@ static void guest_test_fixed_counters(void)
 
 	guest_rd_wr_counters(MSR_CORE_PERF_FIXED_CTR0, MAX_NR_FIXED_COUNTERS,
 			     nr_fixed_counters, supported_bitmask);
+
+	for (i = 0; i < MAX_NR_FIXED_COUNTERS; i++) {
+		uint8_t vector;
+		uint64_t val;
+
+		if (i >= nr_fixed_counters && !(supported_bitmask & BIT_ULL(i))) {
+			vector = wrmsr_safe(MSR_CORE_PERF_FIXED_CTR_CTRL, BIT_ULL(4 * i));
+			__GUEST_ASSERT(vector == GP_VECTOR,
+				       "Expected #GP for counter %u in FIXED_CTRL_CTRL", i);
+
+			vector = wrmsr_safe(MSR_CORE_PERF_GLOBAL_CTRL, BIT_ULL(PMC_IDX_FIXED + i));
+			__GUEST_ASSERT(vector == GP_VECTOR,
+				       "Expected #GP for counter %u in PERF_GLOBAL_CTRL", i);
+			continue;
+		}
+
+		wrmsr(MSR_CORE_PERF_FIXED_CTR0 + i, 0);
+		wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, BIT_ULL(4 * i));
+		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, BIT_ULL(PMC_IDX_FIXED + i));
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
2.42.0.869.gea05f2083d-goog


