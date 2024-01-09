Return-Path: <kvm+bounces-5938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C8F6829094
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 00:10:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 559E81C20B5A
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 23:10:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE211495C6;
	Tue,  9 Jan 2024 23:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RpgR6PX/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A6848CCA
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 23:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5f8ffd9fb8aso34885407b3.3
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 15:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704841410; x=1705446210; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=V3HBLKV9dLG9W0FGZjUnOV/dOoWVZS8lhx6QyuIwmfg=;
        b=RpgR6PX/Qf72r8uGhy98Ac5N5AZpzPmrsOy6e/FcSAORupfDMZ3k9ZVugwn3Wa983O
         gzp/FVwIf8maT8wzwz3F4vNn/xgRz/CsTxAtsHv+wv9ZNlQj+6eobNV2s4nHQA4+tYit
         6DyBqzFehobGxu+MfvmdIjiAjyKbqqohK9DXoQdp3xl7TGpPDYh7PjHIBjvdMb4NZiBb
         svOshw0bIsgobRmJ61l6J4PbJ8x++DROVLcQWJ4d2lHje7AKFX1YBAodTzzh1w24wAf6
         V4Ml4ajF0Wfpk0DyG/dNtsAOHCAOGMwtY3vlvciFEkWbNHiwaAwiPsr1DWqEG7SCu3lf
         rB9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704841410; x=1705446210;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V3HBLKV9dLG9W0FGZjUnOV/dOoWVZS8lhx6QyuIwmfg=;
        b=dCas6nPxUiEqYiAXFcfgNtGvnxeE9j3zbibyn9Th21/9BTvMoh9Sibwd/rwZ5haJzC
         Ul9BvnkdRCKNDZjc3jmwypHL4PfQCkY4TG5CVO9kvgh9JlQsQQSywfe/fYH3ct7A5buc
         aukEWYSUmBuhfF7PENd36mMNAbgu5QEg5bY0WA+oHg8yB8FhvaESkkx3VaTcwkqOY40X
         d1/wSM6XrNja88usTU6oZ13g+h4YQMxmrxP3lo3MqX0m90BNl7maez7E6TVTeVV+vKIi
         +D3IFukPRnB/n7tKomKfC3cZJaSMl3HJCenlVgRCyjl7GDTdpcAgMd/A2bPIf7ujMKq3
         W2gQ==
X-Gm-Message-State: AOJu0YwlkqdUJlbBV0Q/bvX0RrBKGOwWlfhZ4AMCHY0ZwnWLabWbt7dg
	AmJQtXKeHWsRCODjtOCiRsnY0udMU1S3vwSxpw==
X-Google-Smtp-Source: AGHT+IG1Ge95404hqGLT8btxtkMpRkXTbHOLwKNDNUdXtu0RebdAB+W5LspYi2Z7g+Z5RWmq9dd1g6wCFok=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:83d1:0:b0:dbc:ed8b:feaa with SMTP id
 v17-20020a2583d1000000b00dbced8bfeaamr33135ybm.10.1704841410603; Tue, 09 Jan
 2024 15:03:30 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 15:02:39 -0800
In-Reply-To: <20240109230250.424295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240109230250.424295-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240109230250.424295-20-seanjc@google.com>
Subject: [PATCH v10 19/29] KVM: selftests: Test consistency of CPUID with num
 of fixed counters
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

From: Jinrong Liang <cloudliang@tencent.com>

Extend the PMU counters test to verify KVM emulation of fixed counters in
addition to general purpose counters.  Fixed counters add an extra wrinkle
in the form of an extra supported bitmask.  Thus quoth the SDM:

  fixed-function performance counter 'i' is supported if ECX[i] || (EDX[4:0] > i)

Test that KVM handles a counter being available through either method.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 60 ++++++++++++++++++-
 1 file changed, 57 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index 863418842ef8..b07294af71a3 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -290,7 +290,7 @@ __GUEST_ASSERT(expect_gp ? vector == GP_VECTOR : !vector,			\
 		       msr, expected_val, val);
 
 static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters,
-				 uint8_t nr_counters)
+				 uint8_t nr_counters, uint32_t or_mask)
 {
 	uint8_t i;
 
@@ -301,7 +301,13 @@ static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters
 		 */
 		const uint64_t test_val = 0xffff;
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
@@ -343,7 +349,7 @@ static void guest_test_gp_counters(void)
 	else
 		base_msr = MSR_IA32_PERFCTR0;
 
-	guest_rd_wr_counters(base_msr, MAX_NR_GP_COUNTERS, nr_gp_counters);
+	guest_rd_wr_counters(base_msr, MAX_NR_GP_COUNTERS, nr_gp_counters, 0);
 }
 
 static void test_gp_counters(uint8_t pmu_version, uint64_t perf_capabilities,
@@ -363,9 +369,50 @@ static void test_gp_counters(uint8_t pmu_version, uint64_t perf_capabilities,
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
@@ -435,6 +482,13 @@ static void test_intel_counters(void)
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
2.43.0.472.g3155946c3a-goog


