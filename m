Return-Path: <kvm+bounces-1102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 04CA07E4E0D
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 01:32:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B304D2813DE
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 00:32:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6B503FFE;
	Wed,  8 Nov 2023 00:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NoyOZ8tv"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B374E1C11
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 00:31:48 +0000 (UTC)
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B581711
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 16:31:48 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1cc5ef7e815so44360135ad.3
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 16:31:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699403507; x=1700008307; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=eOsNu1hfSZJra6BKusRtLnJPQ4S9SkH0BAaz2rzZCWg=;
        b=NoyOZ8tvKa10YQU8dxWgfxeaZ6ZN0SBerdImfyGt1C62VfoeysYKNCHcxeLufylL6d
         fsgmtPub5D1mt4DtTyfJR7Wqy5CzpdKPXEs5yYy+HKAaMCm/bsPEJ4THn4XgLl94RNP4
         33qDzj0cCAZWBrQD5diUAFVY7dsFaXYjEh6Pu46zhVM8EQQGsg5SomdBA47jfuGvq2xj
         4pHr8/j2HJCu+e90jD7z9wEXzwbJ1vwFbGKPAawDdJrBISMPnuSBzY4iC+5MKY6bJYVF
         EJF+jmbQQVgNccCAjeIhmON3YCHMFxfrEZiOVNI3lyHbs14gk+5UGCTUIEOdNo6b3OQy
         fCFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699403507; x=1700008307;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eOsNu1hfSZJra6BKusRtLnJPQ4S9SkH0BAaz2rzZCWg=;
        b=YhU8JEOU+u1Fj1F7xP1YTs97vB7PYVzBrYle2LnXCoixFkr63SIbuifMKEzFlSVsgP
         j0T7oz9KFWtboPIqse+kgT9ZJvZ6WRlmyycpdozYi3O7jIzun2JHeWLlZpQvpZ6Wfub9
         TbjNs2YvNu+MExeZUQ7IOb7+Cl670lyBotri8gUUO9gaXD7jltLTuTivzUGPtWMvsOQM
         M6YAgD32EyfUomplrY4uH6evezPVUKRjgP2wU98lBx7CU8UTYY7xWHOf42l7DTJojL/R
         sZwgerg/eb07ItBruoJQr4shmz2k42qFkExxMOuPUqMdllKbjAN89uV1s2zNmkeQaXFZ
         Klvw==
X-Gm-Message-State: AOJu0Yx1vjQ5dvDidLWAoBQC7sMvogBhOryQzGZKuMsSK0rXfdnPvNcH
	m38blaBZZNLplKqA/ZK21n1sPdtYAQU=
X-Google-Smtp-Source: AGHT+IFucPzlJqg7tHjMuPAfTTVqnx8AOWjcGJMPuJs/O5C3yihzxvcXC3aNBY+ndlc9GvpWGX8R4usyxo4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:6b06:b0:1cc:2f2a:7d33 with SMTP id
 o6-20020a1709026b0600b001cc2f2a7d33mr10169plk.2.1699403507489; Tue, 07 Nov
 2023 16:31:47 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Nov 2023 16:31:20 -0800
In-Reply-To: <20231108003135.546002-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231108003135.546002-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231108003135.546002-5-seanjc@google.com>
Subject: [PATCH v7 04/19] KVM: x86/pmu: Setup fixed counters' eventsel during
 PMU initialization
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Set the eventsel for all fixed counters during PMU initialization, the
eventsel is hardcoded and consumed if and only if the counter is supported,
i.e. there is no reason to redo the setup every time the PMU is refreshed.

Configuring all KVM-supported fixed counter also eliminates a potential
pitfall if/when KVM supports discontiguous fixed counters, in which case
configuring only nr_arch_fixed_counters will be insufficient (ignoring the
fact that KVM will need many other changes to support discontiguous fixed
counters).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index c4f2c6a268e7..5fc5a62af428 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -409,7 +409,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
  * Note, reference cycles is counted using a perf-defined "psuedo-encoding",
  * as there is no architectural general purpose encoding for reference cycles.
  */
-static void setup_fixed_pmc_eventsel(struct kvm_pmu *pmu)
+static u64 intel_get_fixed_pmc_eventsel(int index)
 {
 	const struct {
 		u8 eventsel;
@@ -419,17 +419,11 @@ static void setup_fixed_pmc_eventsel(struct kvm_pmu *pmu)
 		[1] = { 0x3c, 0x00 }, /* CPU Cycles/ PERF_COUNT_HW_CPU_CYCLES. */
 		[2] = { 0x00, 0x03 }, /* Reference Cycles / PERF_COUNT_HW_REF_CPU_CYCLES*/
 	};
-	int i;
 
 	BUILD_BUG_ON(ARRAY_SIZE(fixed_pmc_events) != KVM_PMC_MAX_FIXED);
 
-	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
-		int index = array_index_nospec(i, KVM_PMC_MAX_FIXED);
-		struct kvm_pmc *pmc = &pmu->fixed_counters[index];
-
-		pmc->eventsel = (fixed_pmc_events[index].unit_mask << 8) |
-				 fixed_pmc_events[index].eventsel;
-	}
+	return (fixed_pmc_events[index].unit_mask << 8) |
+		fixed_pmc_events[index].eventsel;
 }
 
 static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
@@ -495,7 +489,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 						  kvm_pmu_cap.bit_width_fixed);
 		pmu->counter_bitmask[KVM_PMC_FIXED] =
 			((u64)1 << edx.split.bit_width_fixed) - 1;
-		setup_fixed_pmc_eventsel(pmu);
 	}
 
 	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
@@ -573,6 +566,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 		pmu->fixed_counters[i].vcpu = vcpu;
 		pmu->fixed_counters[i].idx = i + INTEL_PMC_IDX_FIXED;
 		pmu->fixed_counters[i].current_config = 0;
+		pmu->fixed_counters[i].eventsel = intel_get_fixed_pmc_eventsel(i);
 	}
 
 	lbr_desc->records.nr = 0;
-- 
2.42.0.869.gea05f2083d-goog


