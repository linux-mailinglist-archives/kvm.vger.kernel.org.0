Return-Path: <kvm+bounces-1426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CFE5B7E7738
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 03:14:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 096481C2091D
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 02:14:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0502AE579;
	Fri, 10 Nov 2023 02:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U5mwE0HK"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332A2D514
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 02:13:47 +0000 (UTC)
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E42F4C3C
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 18:13:46 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-28003f0ecedso1713856a91.2
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 18:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699582426; x=1700187226; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=JH9+qpUXl836Ph+awMmTwSGh8Ty89oPMRk1LH3tw8s4=;
        b=U5mwE0HKUK4wWia7KWOs+sRqcQy6ImyUbbQIakpNYTH45YOdXze0K14XrNHwr8RRG5
         bCtVZZUHlMsKtxlsb3Y9SmNPH0knDNFbD1BFyfelTG72vn64mq2C6jOrTwvhJObP/H2a
         hlUQmYDmq22eigaxFP6otUMQMZoEv10coOxLsd3z6Q+D8O0bDO2YRNAxlL5P0g3q3VVP
         kGhCvJq3OhBJLuJqNL7MIyvz/EsYKvhEXxqXsl3Rwg5va5uwF82RgSg9jO7FufumDBsF
         7cT9i1zfW7Rm2OL3xjqOt73tnLhqlOuo7L4qE7yQfGHTrQaaIhpEauybF5RNi736GdwL
         lPRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699582426; x=1700187226;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JH9+qpUXl836Ph+awMmTwSGh8Ty89oPMRk1LH3tw8s4=;
        b=s7L2QSKYqB+8Tum1nTrK2ykFk2xIWEYkdcoGLImCzzPAcfO0nQ0KX0LFiHGrkvKw5s
         1l4iUHBSo/+QFm2CqtW8uVVrNay805muqggBMUNonpqZmizKbnmfdAYeVV96RZTaXhc4
         wvIu9D+/Fz4Xws5+Nm3/r3LfWCAylqpOGklVqgB5cBF7+ZcifIr++EFMu/BgKOOCEeJz
         KKkSv96dteQyNzQJHeWqtPv3qQhYf3AbhTEjFFADBvxl9828IHAoBsMyLLOb8+n4wVqi
         mHlevAKzs7urN6UPwkpuLLIE+C1SzE19txJgQ5repnodhk7bI6VYGm3MpCqcW1yOg/e8
         nn/Q==
X-Gm-Message-State: AOJu0YzyFkX47T/dIYOwL4GEFuOuVpr9Xbuz0FPtmP7FSmwPU6j7gsmp
	1lnlzm8jbitILyeYUSNfS3CMe/7tCmA=
X-Google-Smtp-Source: AGHT+IECumHEwC4qoDbNH2oeAFTGH5z87NEBzmBmdcyxjebJn7y2REJEvm4jaesyDQVOJ2kmOtwLlmpcpqw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:69a4:b0:27c:ff2d:418 with SMTP id
 s33-20020a17090a69a400b0027cff2d0418mr827687pjj.6.1699582425767; Thu, 09 Nov
 2023 18:13:45 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  9 Nov 2023 18:12:57 -0800
In-Reply-To: <20231110021306.1269082-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110021306.1269082-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110021306.1269082-18-seanjc@google.com>
Subject: [PATCH v8 17/26] KVM: selftests: Add functional test for Intel's
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
2.42.0.869.gea05f2083d-goog


