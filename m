Return-Path: <kvm+bounces-1413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3CE27E7720
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 03:13:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4C6C3B212A6
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 02:13:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCBDF2109;
	Fri, 10 Nov 2023 02:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qMXxfJ+l"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8731875
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 02:13:21 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315944696
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 18:13:21 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-da0737dcb26so1995930276.3
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 18:13:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699582400; x=1700187200; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=uDpdyO5wteS2tCSVyIlZrwaNpirFZhycmLzD5CPKCCU=;
        b=qMXxfJ+lsiB4l4A6RJSu+pNo1t2eDnu+4Q0SzDS+F0wa9rlxvewJnWKHjFR7UFSytk
         gvEINr9Pv93m6yKwpovM5aozYPHV4U+vQ1TTG+c7ia0CPLk1f6PtQIGOoLh10RKOP6QW
         93jrx1wEFskG1U4eGSZWRCgD6QLJRVSzGSJ+bpQPP0OiHtWrq/7A2yA3P5ZJ0ka4mX+z
         rIhXOJcGzK+p9NNa7DeaW6SFcY57s2arI8xVvEBtIM9jokiTqBxM8is8tumSBbr1M60d
         LiuMsurxLIdr6CFcf9cvfvRlGS0dy0j/VoA69wyWxoza57XoAtMi5tos5t64q+LvMvcu
         VrRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699582400; x=1700187200;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uDpdyO5wteS2tCSVyIlZrwaNpirFZhycmLzD5CPKCCU=;
        b=UAUI54hyag3/8xJkq3qpl+bXZchOkRxQkjx7PCsX+LKg+sRZClAxHJsjgj2+ZXgyhN
         Pu6NK6+aMgWPXWNsk5BShqwswR+2Oa4MaWl/8Guo0qy4Elp8uJILjGaUwmRu93Qk8uG/
         bLfs9Pi7qrW78CFYn1Igqr+i2GHy3AnJQzYNb2pB0rarbdMAo93iPNL7Gii4EGoGJJ/L
         xk5pv5O9gNZ0pdFvZKya6TNi+wevuC6U4OuV+sS0cLJW0bsO7Yun5qtO1Rfh3nK3L8wy
         Ks5a28nuaUpCBUtTRwJbZusKgmlqeYNIkwAEbu+mBD+Y7zL+IqWh003VGYo6V2kIYGNG
         X3CQ==
X-Gm-Message-State: AOJu0Yw726Qmr4sVwSb57EtlHVAx4b5W6uipdbVMaOz/tw/yfMLNp8YS
	GFhbbRWI5KRTpyHe5WUDDr/3ifi+Fhk=
X-Google-Smtp-Source: AGHT+IE3hk2jW8uXQ54DbsLBHV3dm9I6uV2tMVC4BMKqHVvW/L2kF+m40xmeCrC9CkE/0s3M7H5X8gXIZ1Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c083:0:b0:da3:7486:bc4b with SMTP id
 c125-20020a25c083000000b00da37486bc4bmr185729ybf.3.1699582400454; Thu, 09 Nov
 2023 18:13:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  9 Nov 2023 18:12:44 -0800
In-Reply-To: <20231110021306.1269082-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110021306.1269082-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110021306.1269082-5-seanjc@google.com>
Subject: [PATCH v8 04/26] KVM: x86/pmu: Setup fixed counters' eventsel during
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
index c4f2c6a268e7..c9df139efc0c 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -409,27 +409,21 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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


