Return-Path: <kvm+bounces-563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E1B987E0C81
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 01:04:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E0781C21131
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 00:04:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89B67C13E;
	Sat,  4 Nov 2023 00:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E535Frjf"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C2CBE4E
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 00:03:19 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D3B170A
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 17:03:12 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5afa071d100so53781177b3.1
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 17:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699056191; x=1699660991; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fb8zK0NPqfOOMlkznlpiln6Hi6vwYDSmOtwhx6NLtA4=;
        b=E535Frjfi5cszIDTrzQfIYALqzpxcvR2HuuPpKmh4+Cmep+Nso/htlhdJDdQPsj8XH
         o17KQW4PDOSMwhOD7brxh0fa5LmibYN7/7Bh/lKoQMi87wKvKLxNqO12DV/wxeK719Ht
         XF2sYFqAln7YrzBnZmhjDnmsBZA5yk/n5AgwXuSp9iPepju9G2su2galyjAp/lzYe0kK
         IEgalKGQka0e/Bo0aydzBYLplEt0VXuWcPXul7/lrEVzn+5XKzr+MmxC5AXgR/H9QvWT
         fWsDR4o1m/MoyU1aQNzwNmMNuVHLoabljSuv3lGSEbdyr95qzL7dmVjyNKpA0E2zBPMa
         ijJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699056191; x=1699660991;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fb8zK0NPqfOOMlkznlpiln6Hi6vwYDSmOtwhx6NLtA4=;
        b=UjISkhb9o5anNKq1vmaY9KmURJo7QcRqVr1qdaky9nvjcr2s/DAMXT3lUSf4Ej5212
         NSyfmirmiNrkNMwz1UfWO2R4mZp9Cr5cUpJiUv6zzlHex5pb1Mzcmn3CihVGP5RSlKD7
         rkjYqeosssdEEpYfqaZt9ILiLrRXrvTS2Wxlg9MDPWt0F26GBQTp8v8Xdn8GJAzOXC4d
         wNt3TN2S32uqDd3RiKIq2+WcDsTRJjsdo9PwsElbSuzT2ZoJVgr5CAz9pz8nJQHdL8rX
         ku2Mte+nHQZoJ167at/x87J7pm1ehExB6so0ckcMECTtMEydq0nb4IAtaXi8LcNncJ1s
         lN+A==
X-Gm-Message-State: AOJu0Ywdv+It8AREtZ30TJuyhVJvdLcATgC3gxgXPL4ZXJk/4LMBTbXC
	6BMSGeKuhYdr0ajVbY64BAuOoIDt4b4=
X-Google-Smtp-Source: AGHT+IEL2LRxWRcp04nBCCFP9y3lvnJP6fCOOR+pw/pOdCrhn01YAnoUjLyuXZZ/zPvkrHOPsQUb6e0bD1Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2589:0:b0:d9a:c946:c18c with SMTP id
 l131-20020a252589000000b00d9ac946c18cmr449384ybl.6.1699056191288; Fri, 03 Nov
 2023 17:03:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Nov 2023 17:02:34 -0700
In-Reply-To: <20231104000239.367005-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231104000239.367005-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231104000239.367005-17-seanjc@google.com>
Subject: [PATCH v6 16/20] KVM: selftests: Add a helper to query if the PMU
 module param is enabled
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Like Xu <likexu@tencent.com>, 
	Jim Mattson <jmattson@google.com>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a helper to problem KVM's "enable_pmu" param, open coding strings in
multiple places is just asking for a false negatives and/or runtime errors
due to typos.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h     | 5 +++++
 tools/testing/selftests/kvm/x86_64/pmu_counters_test.c     | 2 +-
 tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c | 2 +-
 tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c     | 2 +-
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index b103c462701b..1885e758eb4d 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -1214,6 +1214,11 @@ static inline uint8_t xsetbv_safe(uint32_t index, uint64_t value)
 
 bool kvm_is_tdp_enabled(void);
 
+static inline bool kvm_is_pmu_enabled(void)
+{
+	return get_kvm_param_bool("enable_pmu");
+}
+
 uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
 				    int *level);
 uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr);
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index 780f62e6a0f2..e6cf76d3499b 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -536,7 +536,7 @@ static void test_intel_counters(void)
 
 int main(int argc, char *argv[])
 {
-	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
+	TEST_REQUIRE(kvm_is_pmu_enabled());
 
 	TEST_REQUIRE(host_cpu_is_intel);
 	TEST_REQUIRE(kvm_cpu_has_p(X86_PROPERTY_PMU_VERSION));
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index b6e4f57a8651..95bdb6d5af50 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -906,7 +906,7 @@ int main(int argc, char *argv[])
 	struct kvm_vcpu *vcpu, *vcpu2 = NULL;
 	struct kvm_vm *vm;
 
-	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
+	TEST_REQUIRE(kvm_is_pmu_enabled());
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_PMU_EVENT_FILTER));
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_PMU_EVENT_MASKED_EVENTS));
 
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index ebbcb0a3f743..562b0152a122 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -237,7 +237,7 @@ int main(int argc, char *argv[])
 {
 	union perf_capabilities host_cap;
 
-	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
+	TEST_REQUIRE(kvm_is_pmu_enabled());
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));
 
 	TEST_REQUIRE(kvm_cpu_has_p(X86_PROPERTY_PMU_VERSION));
-- 
2.42.0.869.gea05f2083d-goog


