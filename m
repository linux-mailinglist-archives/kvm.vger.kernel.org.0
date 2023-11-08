Return-Path: <kvm+bounces-1111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71A3C7E4E1E
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 01:32:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2AEDF28142D
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 00:32:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9394DDA3;
	Wed,  8 Nov 2023 00:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lyBjIQ5X"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A33D51E
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 00:32:06 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755271BDD
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 16:32:06 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5af9b0850fdso84444547b3.1
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 16:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699403525; x=1700008325; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=DXez8jM/aEISjIp4D8bbMEqvy5rF4I4jxOIMNNd6V3A=;
        b=lyBjIQ5XMT/AeIUzefVzZ1MIElN6D646JHLWWEg7/U9TLU8njDxdsd/aDaz4ThaHOw
         BoiGpYhJEonoropoT9flAcokZOxqZ1GJUMkiGpvl1L5EXd/MkcoVQ8EhPkcdpo8CsG/G
         YEth6QNRSPOkNxzKr3EiXCJdgG22Uo131WZnRfIm1JiU/Ehux4mfo9elF0Vq13wfOF4/
         Eth5CJKlGYYT54qVHX/zm0zMmnpBxFFPdnwXQ048hSAE+jqf/I/uzG/CTiKTjeLHA2cD
         /8uYTzXS8LEyUr7nxZToI5QSejnwMo1YWPwM3171Dqnd/kIOKmK98jwJKb1ioJ2axNQQ
         WxeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699403525; x=1700008325;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DXez8jM/aEISjIp4D8bbMEqvy5rF4I4jxOIMNNd6V3A=;
        b=mi0M7m2AdqlctL2gRaqzgnk6f6UJ8eAVl+cJ361nkJM5mbFLXszC83jp2kKVjLco2H
         rqGVqXBVa9T3x0FCQJgZElEJMUbrS6IUb3rQ9xaNE04EnpQN9oHYVEYHpYxmevnVmwTW
         RjgnUFgVS1BJpLwuoyy4PGZBmsyc+HRXtiFiu+zRTky8HJSDBmb9Opv4jU8sdiYamo4Z
         Rmnm9CEbnccIH2g7DX16pWJe3VYidMpkWoRC2q+5nB7kFQ5vb2LDVM8jdIsgaGP7KUMg
         t5otMemruy/b9btBLgFF1LcFrU4HV+YJl5ckGsARR5B2ylG45SrIqwt0RAEDvQA8kg0v
         rUjA==
X-Gm-Message-State: AOJu0YwyfVSqic9Ll9ha9V3T/AnZWaPJvX/PXkfUUVfLJ1msCJLjiHx2
	7Wx6Oh6khAWmqAYyFiKBhlPyDb7ScOA=
X-Google-Smtp-Source: AGHT+IHnm6a/RltPae9psNtK7VYkH94gMkTxVlCQBbqFkKkCymjuiyMSgSRzdqZJ+WHaKUQQgcQqeYrG4ts=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d80e:0:b0:5a7:b9ea:5c9d with SMTP id
 a14-20020a0dd80e000000b005a7b9ea5c9dmr4203ywe.8.1699403525714; Tue, 07 Nov
 2023 16:32:05 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Nov 2023 16:31:29 -0800
In-Reply-To: <20231108003135.546002-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231108003135.546002-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231108003135.546002-14-seanjc@google.com>
Subject: [PATCH v7 13/19] KVM: selftests: Add functional test for Intel's
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
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 31 ++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index 8c934e261f2d..b9c073d3ade9 100644
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
@@ -379,6 +380,34 @@ static void guest_test_fixed_counters(void)
 
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


