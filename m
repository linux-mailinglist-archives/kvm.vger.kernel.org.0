Return-Path: <kvm+bounces-1435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 495257E774B
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 03:15:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0158F281781
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 02:15:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32CC012B68;
	Fri, 10 Nov 2023 02:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m4jnRaPO"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718F5125AE
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 02:14:04 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF83E46A2
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 18:14:03 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-da0cb98f66cso1871569276.2
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 18:14:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699582443; x=1700187243; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=HhKpd1SrztABGm/U/aQBO8MgOdSjtPm1/FH+XbVpKsc=;
        b=m4jnRaPOMa1ghC1NR+EN38TtemHSytDQX+0OzCHCThb+07voZlaL/nZ7za+Bd1r/o4
         HTDQAIwyrWA119M8RRfkacyCgiChaAPlQvm4D/NCU7ETDv3zjsO8Cqyhb2Tb7D+fLQ8m
         v3l7ASGhlRagf7Xr3CFNsgs3T0A/bkqf+/oOTu9GHvdUvBga3ldZMzH63ZBHXsJ7NGRs
         UXtuBPs8QdbteWHMR61ri8fsL6+eQ9r+0v+ndesv5+1nfavXQkVYcCt9GMKloYz/mgOq
         UdTWpqyDSEcH6a67BqGOxVctB9vBUc46IIu3FAmmapy7nvWrfeGV2oNtfgCFieSPVKVd
         LeyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699582443; x=1700187243;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HhKpd1SrztABGm/U/aQBO8MgOdSjtPm1/FH+XbVpKsc=;
        b=c4NiJ/VnayJBf8tOYJtfCHUtFrpOZbApKwv/WeX2D/E+n5AKjdpjregbv5qo1JPQQN
         SBAIoFCV6OadbQwV/8zwieD2t/AeFlBoFwBrdFuJeO0xudP7PlODfSQ80QJl9odjksfC
         32mJ7mVhw2/O6fiDASTUOxwPAFPhXA0l0sI4vEBjtpnFrvMitizvXcDJtgEGoX/RR8ua
         YQDIqE6Ls+VGLB7q7dIUbonpG8WNumDboRZHDKT+1evGJ2XFhOj0+UGAzXM5FWE6RsqE
         NzeC1Dr/qUah+N+kOUnqIL4EHQuMpVf8ULRQ1iWaC/irr9bfQMwwshV4Yt77k536K9ke
         u7iA==
X-Gm-Message-State: AOJu0Ywhcr3RYpjgnM3J73FUPctL1Ipkf+IjrwlCeZSEph+7ZojKg8y5
	roqcwFcPpIHiYWVU41r4gYJiSfkVKu0=
X-Google-Smtp-Source: AGHT+IFpa5+5TQ+Re0pGStxstHQjvzE+KLpTjR1CFF+Bg+wuHzmd7p/Tahi8Gt+fyKyBmhf01tN65xhF9P0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1366:b0:dae:49a3:ae23 with SMTP id
 bt6-20020a056902136600b00dae49a3ae23mr179118ybb.7.1699582443106; Thu, 09 Nov
 2023 18:14:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  9 Nov 2023 18:13:06 -0800
In-Reply-To: <20231110021306.1269082-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110021306.1269082-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110021306.1269082-27-seanjc@google.com>
Subject: [PATCH v8 26/26] KVM: selftests: Extend PMU counters test to validate
 RDPMC after WRMSR
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
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 31 +++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index cb808ac827ba..248ebe8c0577 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -328,6 +328,7 @@ __GUEST_ASSERT(expect_gp ? vector == GP_VECTOR : !vector,			\
 static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters,
 				 uint8_t nr_counters, uint32_t or_mask)
 {
+	const bool pmu_has_fast_mode = !guest_get_pmu_version();
 	uint8_t i;
 
 	for (i = 0; i < nr_possible_counters; i++) {
@@ -352,6 +353,7 @@ static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters
 		const uint64_t expected_val = expect_success ? test_val : 0;
 		const bool expect_gp = !expect_success && msr != MSR_P6_PERFCTR0 &&
 				       msr != MSR_P6_PERFCTR1;
+		uint32_t rdpmc_idx;
 		uint8_t vector;
 		uint64_t val;
 
@@ -365,6 +367,35 @@ static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters
 		if (!expect_gp)
 			GUEST_ASSERT_PMC_VALUE(RDMSR, msr, val, expected_val);
 
+		rdpmc_idx = i;
+		if (base_msr == MSR_CORE_PERF_FIXED_CTR0)
+			rdpmc_idx |= INTEL_RDPMC_FIXED;
+
+		/* Redo the read tests with RDPMC, and with forced emulation. */
+		vector = rdpmc_safe(rdpmc_idx, &val);
+		GUEST_ASSERT_PMC_MSR_ACCESS(RDPMC, rdpmc_idx, !expect_success, vector);
+		if (expect_success)
+			GUEST_ASSERT_PMC_VALUE(RDPMC, rdpmc_idx, val, expected_val);
+
+		vector = rdpmc_safe_fep(rdpmc_idx, &val);
+		GUEST_ASSERT_PMC_MSR_ACCESS(RDPMC, rdpmc_idx, !expect_success, vector);
+		if (expect_success)
+			GUEST_ASSERT_PMC_VALUE(RDPMC, rdpmc_idx, val, expected_val);
+
+		/*
+		 * KVM doesn't support non-architectural PMUs, i.e. it should
+		 * impossible to have fast mode RDPMC.  Verify that attempting
+		 * to use fast RDPMC always #GPs.
+		 */
+		GUEST_ASSERT(!expect_success || !pmu_has_fast_mode);
+		rdpmc_idx |= INTEL_RDPMC_FAST;
+
+		vector = rdpmc_safe(rdpmc_idx, &val);
+		GUEST_ASSERT_PMC_MSR_ACCESS(RDPMC, rdpmc_idx, true, vector);
+
+		vector = rdpmc_safe_fep(rdpmc_idx, &val);
+		GUEST_ASSERT_PMC_MSR_ACCESS(RDPMC, rdpmc_idx, true, vector);
+
 		vector = wrmsr_safe(msr, 0);
 		GUEST_ASSERT_PMC_MSR_ACCESS(WRMSR, msr, expect_gp, vector);
 	}
-- 
2.42.0.869.gea05f2083d-goog


