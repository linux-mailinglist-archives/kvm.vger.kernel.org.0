Return-Path: <kvm+bounces-560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 962847E0C7F
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 01:04:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D240D281FA0
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 00:04:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 821EABA48;
	Sat,  4 Nov 2023 00:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R07e9vhA"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730FFAD30
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 00:03:11 +0000 (UTC)
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53381D49
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 17:03:06 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1cc29f3afe0so20466995ad.2
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 17:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699056185; x=1699660985; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Q3Wa1t4oywOoWiKyaSylJlH+a4g8C6o2ts0796QA/2g=;
        b=R07e9vhAsl2IWu4KXyx8c9qzMQJKyDdyQ0tJd3FtaU4/0DZ8Pwtd6EjDF0223y3vHB
         8WjBJCXUFEzrGkVUTqxcdnGan/3NFm2RKZJwvMBIUrIr6ku0eMcD5NucWBsZxc8754LU
         PXuoWykqpB5BGRPORMs5tmTRrV3xSI+km1cbsnyhM87072IEfnROcLEQBhw6Fy0vJyIy
         n0HIy0dWV1KR1wqOn3XYcu3iorYhAc6aerNz3Ei5qQeUNhhTj1ENdVze6D8PyMQHvAMb
         TADSvFdcqYnqkIpYuFAIS7jesPNZ3vHCblQb4bmIwv6Yg9Z5A7zdodV3QU8YHk/AgyjA
         UMWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699056185; x=1699660985;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q3Wa1t4oywOoWiKyaSylJlH+a4g8C6o2ts0796QA/2g=;
        b=N1vq9HgvqyGuoPdkCrXpdnjRWoSK/UD3MwsVX2k00Z6CkhjlZdYvq3bkV5EMM8bDov
         q/Y5TgPqlXG7RuGyAq4MPtniJt23nS9yJGtQ1LvtYhfbO301XapXFNEeOp4gsDtSrUvu
         wVVfzikKfKBTtFspVEg+ejMNXjiDrX98kVR5HzhYzygc6+GcSVy38A/xjtv3g6vZDZDp
         2THbo1AL8V6OTgZeMYgZs9HskEIiHs8QW9Ruolc6B3MlreqC3VnLq3EnUn1ykpQsqexw
         e+dPD/YgJ9owmAox1s+fbCBrqLQc3mN5J0XAEHlJGu9ewjlIfHJy7zHRSBqWaZOs2cv4
         oa+A==
X-Gm-Message-State: AOJu0Yw4VMlJUU2fX6cQ3hgNTRd04wD9sC632pPNY9cddeGpDy998KAW
	+aODtdbMFGHHh+CcLt9uYDoQeExFndQ=
X-Google-Smtp-Source: AGHT+IFugYl7g7KDjaby2dbPe3lBADWmAk9vp1ufT7CHxwrV0MTPydKK3WqAuBlF3WWj/TdOW1JpD9MCWTw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2616:b0:1cc:2549:c281 with SMTP id
 jd22-20020a170903261600b001cc2549c281mr416287plb.13.1699056185478; Fri, 03
 Nov 2023 17:03:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Nov 2023 17:02:31 -0700
In-Reply-To: <20231104000239.367005-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231104000239.367005-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231104000239.367005-14-seanjc@google.com>
Subject: [PATCH v6 13/20] KVM: selftests: Test consistency of CPUID with num
 of fixed counters
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Like Xu <likexu@tencent.com>, 
	Jim Mattson <jmattson@google.com>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Jinrong Liang <cloudliang@tencent.com>

Extend the PMU counters test to verify KVM emulation of fixed counters in
addition to general purpose counters.  Fixed counters add an extra wrinkle
in the form of an extra supported bitmask.  Thus quoth the SDM:

  fixed-function performance counter 'i' is supported if ECX[i] || (EDX[4:0] > i)

Test that KVM handles a counter being available through either method.

Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 60 ++++++++++++++++++-
 1 file changed, 57 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index 232b9a80a9db..52b9d9f615eb 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -285,13 +285,19 @@ __GUEST_ASSERT(expect_gp ? vector == GP_VECTOR : !vector,			\
 	       expect_gp ? "#GP" : "no fault", msr, vector)			\
 
 static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters,
-				 uint8_t nr_counters)
+				 uint8_t nr_counters, uint32_t or_mask)
 {
 	uint8_t i;
 
 	for (i = 0; i < nr_possible_counters; i++) {
 		const uint32_t msr = base_msr + i;
-		const bool expect_success = i < nr_counters;
+
+		/*
+		 * Fixed counters are supported if the counter is less than the
+		 * number of enumerated contiguous counters *or* the counter is
+		 * explicitly enumerated in the supported counters mask.
+		 */
+		const bool expect_success = i < nr_counters || (or_mask & BIT(i));
 
 		/*
 		 * KVM drops writes to MSR_P6_PERFCTR[0|1] if the counters are
@@ -335,7 +341,7 @@ static void guest_test_gp_counters(void)
 	else
 		base_msr = MSR_IA32_PERFCTR0;
 
-	guest_rd_wr_counters(base_msr, MAX_NR_GP_COUNTERS, nr_gp_counters);
+	guest_rd_wr_counters(base_msr, MAX_NR_GP_COUNTERS, nr_gp_counters, 0);
 }
 
 static void test_gp_counters(uint8_t pmu_version, uint64_t perf_capabilities,
@@ -355,9 +361,50 @@ static void test_gp_counters(uint8_t pmu_version, uint64_t perf_capabilities,
 	kvm_vm_free(vm);
 }
 
+static void guest_test_fixed_counters(void)
+{
+	uint64_t supported_bitmask = 0;
+	uint8_t nr_fixed_counters = 0;
+
+	/* Fixed counters require Architectural vPMU Version 2+. */
+	if (guest_get_pmu_version() >= 2)
+		nr_fixed_counters = this_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
+
+	/*
+	 * The supported bitmask for fixed counters was introduced in PMU
+	 * version 5.
+	 */
+	if (guest_get_pmu_version() >= 5)
+		supported_bitmask = this_cpu_property(X86_PROPERTY_PMU_FIXED_COUNTERS_BITMASK);
+
+	guest_rd_wr_counters(MSR_CORE_PERF_FIXED_CTR0, MAX_NR_FIXED_COUNTERS,
+			     nr_fixed_counters, supported_bitmask);
+}
+
+static void test_fixed_counters(uint8_t pmu_version, uint64_t perf_capabilities,
+				uint8_t nr_fixed_counters,
+				uint32_t supported_bitmask)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_test_fixed_counters,
+					 pmu_version, perf_capabilities);
+
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_FIXED_COUNTERS_BITMASK,
+				supported_bitmask);
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_NR_FIXED_COUNTERS,
+				nr_fixed_counters);
+
+	run_vcpu(vcpu);
+
+	kvm_vm_free(vm);
+}
+
 static void test_intel_counters(void)
 {
 	uint8_t nr_arch_events = kvm_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
+	uint8_t nr_fixed_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
 	uint8_t nr_gp_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
 	uint8_t pmu_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION);
 	unsigned int i;
@@ -428,6 +475,13 @@ static void test_intel_counters(void)
 				v, perf_caps[i]);
 			for (j = 0; j <= nr_gp_counters; j++)
 				test_gp_counters(v, perf_caps[i], j);
+
+			pr_info("Testing fixed counters, PMU version %u, perf_caps = %lx\n",
+				v, perf_caps[i]);
+			for (j = 0; j <= nr_fixed_counters; j++) {
+				for (k = 0; k <= (BIT(nr_fixed_counters) - 1); k++)
+					test_fixed_counters(v, perf_caps[i], j, k);
+			}
 		}
 	}
 }
-- 
2.42.0.869.gea05f2083d-goog


