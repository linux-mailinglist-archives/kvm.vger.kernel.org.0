Return-Path: <kvm+bounces-5941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DF45829099
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 00:11:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 984921C20A83
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 23:11:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C79794B5BF;
	Tue,  9 Jan 2024 23:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Sw6FAc/2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18FB4A9B3
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 23:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbe9ef2422cso3923197276.0
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 15:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704841416; x=1705446216; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xs0Tu69ShBr9y0BRF4QkbIzT6NPLb5tl+Q4gi6KQ7zM=;
        b=Sw6FAc/2HgTn2VDtKHnuQ8bxgGkPvuvWhTpuMfEAlxV5E2qb3dTTzzp6La/2hLe87n
         UMsAhAiT0UV4+4p3oW76fUB4t5IOMP2MwaGbudQmrguUGyibgdPfGV/vTbw7QJJ3f6A/
         pNQ+jCXd+ptwGa+2B7aczr9K5e7zo8fZk5E/StRxsH6MyU8zOGiuX+CeYGEZDiEdH7LG
         U4Q3/5/gxcp16rzGceARZV/5j4fX4BRkpNC4RcyYkc/7CGTp8KCUym0ZL6pnYxImbSHp
         XbvjkCPrFMMlXcVltCgObAzppRm8PZxCB4KMK2+rjN5QSKmhwUaH65o2O10GNShb6VWM
         rh+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704841416; x=1705446216;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xs0Tu69ShBr9y0BRF4QkbIzT6NPLb5tl+Q4gi6KQ7zM=;
        b=TIxgEW23hSAYcegLSwJWaggr3BgOf9R1StzxfvmVlQ8XrnKAjL9wRnzjD4mX/AZtDd
         jq9n+mMyHq0ZaQHb8/RolGafgJcrvKDrzB9KJrrOQdSIPXgIHVOI3YHB4A6X8Y+G8qTj
         0TVCa0xK7VX6d/x5qLphmrfm72SzRSSYsqUODjXbdQdLbmC0IGN8UU2ersGld7vtyRFs
         5nJxTHC5eQ6zWTbSQjKR6uyjf4P7TmxfBYhbz9z4Tzjw1pfc6cPaUAsLq+M5wFvXLTZt
         VxMQTHSbXlRk8oVcMErfHWSIV8ek0vbRECTDhKzIZc62OLLpfyYvaKAH0N5QGTLNVZGd
         i+YA==
X-Gm-Message-State: AOJu0YzPg5OG1YH9XRRH1c7FRYLqTQnkrQ6mB5x0nt6nMWEJQMb3t0Xp
	wNkX9m3LEAegRqQcNT1qnOTdg/ekSL28HRkWBA==
X-Google-Smtp-Source: AGHT+IG9ZsgQhQXqNM7DqFbl0VSMm15g4/tnqdP+I9jecPH3K8Ab3d5X141dsCgys7GSjDjlt5oHbIO4Ol0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8043:0:b0:dbd:6dff:943a with SMTP id
 a3-20020a258043000000b00dbd6dff943amr5679ybn.10.1704841416746; Tue, 09 Jan
 2024 15:03:36 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 15:02:42 -0800
In-Reply-To: <20240109230250.424295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240109230250.424295-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240109230250.424295-23-seanjc@google.com>
Subject: [PATCH v10 22/29] KVM: selftests: Add a helper to query if the PMU
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
index 92d4f8ecc730..ee082ae58f40 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -1217,6 +1217,11 @@ static inline uint8_t xsetbv_safe(uint32_t index, uint64_t value)
 
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
index 2a8d4ac2f020..8ded194c5a6d 100644
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
2.43.0.472.g3155946c3a-goog


