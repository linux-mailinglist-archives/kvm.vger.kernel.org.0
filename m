Return-Path: <kvm+bounces-1428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FC067E773C
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 03:15:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 321B42816EC
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 02:15:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB73310786;
	Fri, 10 Nov 2023 02:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YMNKbB+a"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7B4101CD
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 02:13:50 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC5D4EE4
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 18:13:50 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5be6d0a23beso11842247b3.1
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 18:13:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699582429; x=1700187229; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=u1oA1WU+H0wBHafKtshVkBCE9ktzVNyHnD3r1OYhd/M=;
        b=YMNKbB+aduxL5RO9h0qwYDk1RhnweXTBQqQfmrJv3trZGcKf4NVABeKCWWrFCw+41/
         kakpYXk8XQderU71w5kw+UuEOSbcMyzWyG5yIb/Uz8ivq/kzS5s4y1i65L8bG4RFrQss
         DcNlqW2DQ23jYGgiq5qB6tbYtFnN78H1hpP1K7RBIKMeyYNwjiMmFHEAOvLrczxjB+sQ
         sSnK5ek99h1uQ/TMnDfKwK1JF0voGCptIk43OHwYF0XSgMkpy22t2iDayi1i6aph4RSj
         4hra2o7tfvAuMxHQNxVi3tn2rD4PkWvZgrp/gkA9bT8Jgaic73vsL0/cPhropa+wATt/
         C9sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699582429; x=1700187229;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u1oA1WU+H0wBHafKtshVkBCE9ktzVNyHnD3r1OYhd/M=;
        b=autHd+bnvQIpwY8WMT8OQbpVv948zrSDFo3s3POkS1GSxSCoAK3A2LfRBjH3LAE540
         6x9BASYjKWApkGdxppHzceOpYEd77LrbsyzgutuKyckxCv26yxx4xUP1rX333ICWv8KL
         bpVQg8wd8WX6zZjv/ymhUUfYBBiTKIidDwCZrFi2c8z397FOvlqtarY1StlxHmqOVCwD
         g/C0uwrwffMnFFIF7OFwK3xk25KSn7tnFqJX+JC8siUyfPwSUXWP+Lr4k8ChaCMIxJ3M
         n3iiC/pE7JldNGTwxZ8AAlhR1V8j50Q0/NP4Glh+4/nfsIYTjAcK0TueehDe4QtxOfOJ
         uhdA==
X-Gm-Message-State: AOJu0YwwmpdGkUUrgyn5k22rvnVG+jibPdlqFaUE3wIOJKGcyAiNO1i2
	BrxRLwg/0qQSkSSFlOMkYpK0IVPbfbw=
X-Google-Smtp-Source: AGHT+IHXQ6IED6p9KV/ySel6E8YxHS+OmKow+FAsjw7BDoOlHxk6vo6znkUufP3EZ8FfUADJLGmSRQTJxJU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:250a:b0:5a8:207a:143a with SMTP id
 dt10-20020a05690c250a00b005a8207a143amr39667ywb.0.1699582429656; Thu, 09 Nov
 2023 18:13:49 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  9 Nov 2023 18:12:59 -0800
In-Reply-To: <20231110021306.1269082-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110021306.1269082-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110021306.1269082-20-seanjc@google.com>
Subject: [PATCH v8 19/26] KVM: selftests: Add a helper to query if the PMU
 module param is enabled
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Add a helper to probe KVM's "enable_pmu" param, open coding strings in
multiple places is just asking for false negatives and/or runtime errors
due to typos.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h     | 5 +++++
 tools/testing/selftests/kvm/x86_64/pmu_counters_test.c     | 2 +-
 tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c | 2 +-
 tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c     | 2 +-
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 64aecb3dcf60..c261e0941dfe 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -1216,6 +1216,11 @@ static inline uint8_t xsetbv_safe(uint32_t index, uint64_t value)
 
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
index 4c7133ddcda8..9e9dc4084c0d 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -545,7 +545,7 @@ static void test_intel_counters(void)
 
 int main(int argc, char *argv[])
 {
-	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
+	TEST_REQUIRE(kvm_is_pmu_enabled());
 
 	TEST_REQUIRE(host_cpu_is_intel);
 	TEST_REQUIRE(kvm_cpu_has_p(X86_PROPERTY_PMU_VERSION));
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 7ec9fbed92e0..fa407e2ccb2f 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -867,7 +867,7 @@ int main(int argc, char *argv[])
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


