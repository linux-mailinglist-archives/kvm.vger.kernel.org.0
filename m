Return-Path: <kvm+bounces-5923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 04344829070
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 00:04:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A9E551F25DAB
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 23:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB0C83FE25;
	Tue,  9 Jan 2024 23:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CZ3HgNV0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D2D3FB13
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 23:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5f7942a16c3so44181527b3.3
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 15:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704841380; x=1705446180; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LadkSkOnespq7J+bb9MybmOp6ANC4ZDI49MV81r/bQE=;
        b=CZ3HgNV0hOupopA4+p9nuwDSscAzTLrKVCboN3zZ9Ces+bq4Yf0/QzkcD3ttrkV5MM
         2y6OaV39QPEddBuLGlL12i5bp+/iWgReVsWx2SLD7z6OyNR9Ejpng7U+toBExEjL0cSQ
         5dXrBHZRWgJZfIMZCflX9ARKwLo3BbeDbTCXpoYNILFLM6qSL5AMuvlvSUO1RhGrCTrk
         TuvXAIo+6Z1oRBdfqO4JY3kn65kmtHEjsL6L4BqIkCat/W+87EhryPAeVrGb11x54LqE
         AyXDLNmP/GYcARXi6YPM2kACkcOw/lk8xxLzpIQlMEswMMB87oYQJn58J/HAhF2rPiZr
         CLYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704841380; x=1705446180;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LadkSkOnespq7J+bb9MybmOp6ANC4ZDI49MV81r/bQE=;
        b=PrRe0m0u6xGfL3Nc3DiTbhYDwmEqeBuJ4eF0YXiJV+O7TDUnNVKughAbApPd6Fo0K9
         xvA6e4QCVnd5ZTw+YwBSmdLzq58M1Lm685gEAeVIA9DdvgkjZR0R1PVDZOy5DUWXKvJW
         XdhkZOW2pYVOr+I6k0sIDmdJxDE6dt1uxOcgRm5DKdU+BpHBsRtubAdWnawICty9MHiz
         XFe3qERwBjFLCBi+eqH+VaVnoEFLH2BCNfwkjUbs5roAoGXWkSqrWcU3rvoesbjA8pEZ
         1gDx89RtiacavEWL4nYDqazmb10jPGkUFvtZ4kK8x84za/XhK6847SLhIiiktQyFhtjv
         vdKw==
X-Gm-Message-State: AOJu0YxsVqwoseFC5ZjIxI2B6kSPDf+BViiKGNN3dCwDznk/Nn40YpC7
	uMDAHdrQ1HQKAG7TzOxajipJjTeoHDlNtClizg==
X-Google-Smtp-Source: AGHT+IH+wwm+B9UodY/w3WuN8h1tNmWmYi6IBiza4wg28y9Lz6PYElcilIEWQr8f7lQ/uZg7EHBE+DknZNE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:a9a:b0:5f6:f1ec:2da5 with SMTP id
 ci26-20020a05690c0a9a00b005f6f1ec2da5mr104412ywb.9.1704841380561; Tue, 09 Jan
 2024 15:03:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 15:02:24 -0800
In-Reply-To: <20240109230250.424295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240109230250.424295-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240109230250.424295-5-seanjc@google.com>
Subject: [PATCH v10 04/29] KVM: x86/pmu: Setup fixed counters' eventsel during
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
 arch/x86/kvm/vmx/pmu_intel.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index f3c44ddc09f8..98e92b9ece09 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -407,27 +407,21 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
  * Note, reference cycles is counted using a perf-defined "psuedo-encoding",
  * as there is no architectural general purpose encoding for reference cycles.
  */
-static void setup_fixed_pmc_eventsel(struct kvm_pmu *pmu)
+static u64 intel_get_fixed_pmc_eventsel(int index)
 {
 	const struct {
-		u8 eventsel;
+		u8 event;
 		u8 unit_mask;
 	} fixed_pmc_events[] = {
 		[0] = { 0xc0, 0x00 }, /* Instruction Retired / PERF_COUNT_HW_INSTRUCTIONS. */
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
+		fixed_pmc_events[index].event;
 }
 
 static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
@@ -493,7 +487,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 						  kvm_pmu_cap.bit_width_fixed);
 		pmu->counter_bitmask[KVM_PMC_FIXED] =
 			((u64)1 << edx.split.bit_width_fixed) - 1;
-		setup_fixed_pmc_eventsel(pmu);
 	}
 
 	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
@@ -571,6 +564,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 		pmu->fixed_counters[i].vcpu = vcpu;
 		pmu->fixed_counters[i].idx = i + INTEL_PMC_IDX_FIXED;
 		pmu->fixed_counters[i].current_config = 0;
+		pmu->fixed_counters[i].eventsel = intel_get_fixed_pmc_eventsel(i);
 	}
 
 	lbr_desc->records.nr = 0;
-- 
2.43.0.472.g3155946c3a-goog


