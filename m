Return-Path: <kvm+bounces-5948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2411B8290A8
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 00:14:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B35A41F26224
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 23:14:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AF8F4D130;
	Tue,  9 Jan 2024 23:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ad/fdzU8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682374D105
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 23:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbee47bacb5so3903669276.1
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 15:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704841430; x=1705446230; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=KPmV5XTeXIjrJabLJdrKSKnfueERqfbYH9Vd6C8BrEE=;
        b=ad/fdzU8zoAarCh2kPmtvWjzsYFcdCgNeFlKbGbXUN47nLaO7FkHokEgAvnkMpVLOB
         hgoZJADaV4hN+X7inq9HWftIthyE7bP34CLUbHL0Mex8dguNB/XkvQn/VEtH9D/ajGbC
         UDtYMBoyVs7hbUBY83Wde1jPjGW77mdDLcD+c5iKZjJf/59txOtoNP7UrJjnoaB0y8of
         ewfau7T5KsbPq04QEHhU23xKiaygNHQb1eOSzKwNFlTAIIWyBIywNFGjQ3pEfgJBpfes
         iuKafT0xHBESUOZUulO6FJoLN/g04RuMayW4qAzaPuMJ9RNhLg5Dy0ZhMV9Cxmg48V0H
         922A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704841430; x=1705446230;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KPmV5XTeXIjrJabLJdrKSKnfueERqfbYH9Vd6C8BrEE=;
        b=OK9Fu526A+s55CeTDEQMWSlavhGXCQ2xyg8YsUfdyx2lbIL1+7MFjdjDZYHSMB4IYE
         +UtMBDjogkE/+sqDIl53kDGzp9QT2qr+MdThGoY59An4xTaWknKUcjax8oTR5SNNrZFV
         tRFGvuBzuY8KinVDyEZHxSjW7oeW5QEBt4ADNA5rphaKTA1VwCi48mUV092VJzLfJpdI
         whCltbGnNld2JWAS+SFAp9rEmXN2DmB/S9CupYU40IitfETUoPJylqP/peCo/YRR7lB8
         LPl/205kmJ+y0kEFP1b/rPXlR15CYxFPLkfCdNmVSg+GvxFPs20qmbnWb2L3ajdrFfvL
         JpjA==
X-Gm-Message-State: AOJu0YwwpAG+3GyegL97NBSYy37YqVNQS7Ejl2RQ3SgMYwiC1J6sIkAm
	QdqIPJxnvpn6fw65mzNAKWPPQNpkOakWi7V+yQ==
X-Google-Smtp-Source: AGHT+IFKFj7UWt0nW0skQEeBaGqmZnlHaiJGfY0quyK3EQ+1Sm76KUaFfHiI6t6TK+z1TaL1Os331OvwqRw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8750:0:b0:dbd:30b0:828e with SMTP id
 e16-20020a258750000000b00dbd30b0828emr98708ybn.1.1704841430539; Tue, 09 Jan
 2024 15:03:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 15:02:49 -0800
In-Reply-To: <20240109230250.424295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240109230250.424295-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240109230250.424295-30-seanjc@google.com>
Subject: [PATCH v10 29/29] KVM: selftests: Extend PMU counters test to
 validate RDPMC after WRMSR
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Extend the read/write PMU counters subtest to verify that RDPMC also reads
back the written value.  Opportunsitically verify that attempting to use
the "fast" mode of RDPMC fails, as the "fast" flag is only supported by
non-architectural PMUs, which KVM doesn't virtualize.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 41 +++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index cb808ac827ba..ae5f6042f1e8 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -325,9 +325,30 @@ __GUEST_ASSERT(expect_gp ? vector == GP_VECTOR : !vector,			\
 		       "Expected " #insn "(0x%x) to yield 0x%lx, got 0x%lx",	\
 		       msr, expected_val, val);
 
+static void guest_test_rdpmc(uint32_t rdpmc_idx, bool expect_success,
+			     uint64_t expected_val)
+{
+	uint8_t vector;
+	uint64_t val;
+
+	vector = rdpmc_safe(rdpmc_idx, &val);
+	GUEST_ASSERT_PMC_MSR_ACCESS(RDPMC, rdpmc_idx, !expect_success, vector);
+	if (expect_success)
+		GUEST_ASSERT_PMC_VALUE(RDPMC, rdpmc_idx, val, expected_val);
+
+	if (!is_forced_emulation_enabled)
+		return;
+
+	vector = rdpmc_safe_fep(rdpmc_idx, &val);
+	GUEST_ASSERT_PMC_MSR_ACCESS(RDPMC, rdpmc_idx, !expect_success, vector);
+	if (expect_success)
+		GUEST_ASSERT_PMC_VALUE(RDPMC, rdpmc_idx, val, expected_val);
+}
+
 static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters,
 				 uint8_t nr_counters, uint32_t or_mask)
 {
+	const bool pmu_has_fast_mode = !guest_get_pmu_version();
 	uint8_t i;
 
 	for (i = 0; i < nr_possible_counters; i++) {
@@ -352,6 +373,7 @@ static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters
 		const uint64_t expected_val = expect_success ? test_val : 0;
 		const bool expect_gp = !expect_success && msr != MSR_P6_PERFCTR0 &&
 				       msr != MSR_P6_PERFCTR1;
+		uint32_t rdpmc_idx;
 		uint8_t vector;
 		uint64_t val;
 
@@ -365,6 +387,25 @@ static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters
 		if (!expect_gp)
 			GUEST_ASSERT_PMC_VALUE(RDMSR, msr, val, expected_val);
 
+		/*
+		 * Redo the read tests with RDPMC, which has different indexing
+		 * semantics and additional capabilities.
+		 */
+		rdpmc_idx = i;
+		if (base_msr == MSR_CORE_PERF_FIXED_CTR0)
+			rdpmc_idx |= INTEL_RDPMC_FIXED;
+
+		guest_test_rdpmc(rdpmc_idx, expect_success, expected_val);
+
+		/*
+		 * KVM doesn't support non-architectural PMUs, i.e. it should
+		 * impossible to have fast mode RDPMC.  Verify that attempting
+		 * to use fast RDPMC always #GPs.
+		 */
+		GUEST_ASSERT(!expect_success || !pmu_has_fast_mode);
+		rdpmc_idx |= INTEL_RDPMC_FAST;
+		guest_test_rdpmc(rdpmc_idx, false, -1ull);
+
 		vector = wrmsr_safe(msr, 0);
 		GUEST_ASSERT_PMC_MSR_ACCESS(WRMSR, msr, expect_gp, vector);
 	}
-- 
2.43.0.472.g3155946c3a-goog


