Return-Path: <kvm+bounces-1113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B7087E4E21
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 01:33:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA2782815C5
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 00:33:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FED0EAC5;
	Wed,  8 Nov 2023 00:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1ysSe0cV"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F966DDA9
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 00:32:10 +0000 (UTC)
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F481BEE
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 16:32:10 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1cc591d8177so42780915ad.3
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 16:32:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699403529; x=1700008329; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=d/dAIl3E7dSknIpj/mbUAcQ6yoHoVBYd62xaxn7wfeg=;
        b=1ysSe0cVrhaGiWIeb1ZVFDTx+8uSlcMOSie46ndKOpihRbJxFFRA+pCRYPeYBe4VdM
         cYHfMpmEuns9s6jMuLb2KhP5oiSrKYMAk+gcCM9cVaDi3IPzOsvu9INdK3W1HqRDveUO
         iK92vbJuQZSgjY3GI4hiH68ZkJh9AiQE8WbZEJIajnRhmhuRs11pz4GUHj6cujKTzuGa
         SKHcWfNNu+jr6P3U1CSDx8nlim0vpadOJVq3b3bXNrFhSOfjdilQP8rgDXjvXpi5nHB5
         lfc3ByNLue1f6fwLsdfo60AGQ4RGRqJ6TIttnDsqXRjsiUmCwZaomL+ZWVtWciO7tf3j
         sxMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699403529; x=1700008329;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d/dAIl3E7dSknIpj/mbUAcQ6yoHoVBYd62xaxn7wfeg=;
        b=lvo+MgJdoH5yrWxlTOvszYh1sZdgixLoSLPXH3Q4bBjdEkR62rpuk7HFScXy2Vrz6g
         TAjs3jDoBDeXXs9fEwouMzllrhndYjNYlkWBEXcJWEUxEiRypzkzbIHchOdLAJBdJT0O
         x3wlCf0MfpK95PLHKD/+7h8UJ08mooo1vxjYxrUtcd3gfdKVlKw8WBez/QCRS1nwLGZH
         jRoOVi+kjxKwBa9ygJbR+UHeEuJPtZl7aIQJBpzYXXY33gvvp2VNbFot76ufLhn10syV
         g9GsvMT9e0cGsG7qHncttscLOnF8yUTHBsdPBU832iZs+nboQ1vTEOLMOSuteUfyuwBF
         nB3A==
X-Gm-Message-State: AOJu0Yxtotut0jSm+8U1RpGHhy8A0DFM+qBtuk2Z4p+3Pi/fDDoMs4Pu
	7ZFcFly5RVy1kNBUWTzmDoKPURtt52M=
X-Google-Smtp-Source: AGHT+IGu/iyGnKnELoi33jrkYhWYrFeoJOaJbKiDhgUCaYbTY5azCthXGWTcbU0o5GWdPu/JoBkablBFxG0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1390:b0:1cc:cc77:94ed with SMTP id
 jx16-20020a170903139000b001cccc7794edmr8893plb.10.1699403529654; Tue, 07 Nov
 2023 16:32:09 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Nov 2023 16:31:31 -0800
In-Reply-To: <20231108003135.546002-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231108003135.546002-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231108003135.546002-16-seanjc@google.com>
Subject: [PATCH v7 15/19] KVM: selftests: Add a helper to query if the PMU
 module param is enabled
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
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
index 90381382c51f..d775cc7e8fab 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -537,7 +537,7 @@ static void test_intel_counters(void)
 
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


