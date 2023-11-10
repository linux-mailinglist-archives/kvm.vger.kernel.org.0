Return-Path: <kvm+bounces-1414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 809287E7721
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 03:13:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B1D9B1C20D24
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 02:13:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B4543C3F;
	Fri, 10 Nov 2023 02:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sG6k1ZRJ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06321FBB
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 02:13:23 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BC8446AB
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 18:13:23 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a7af69a4baso22865427b3.0
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 18:13:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699582402; x=1700187202; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CokfVr+85rJcN61ZUPYqVGKL5YI2MWC/M4+QQUo01DY=;
        b=sG6k1ZRJReNESYiPt6vQbsTzV/osLW2+DeKS1wIba6sclRyr1+elUpvLG/i67oSZU1
         rLgzwf00c5x/mnrgPVJM2ID5d9AZau+0+SHSeso507fQZ6QFPIgwMEXiv8VRdDOvuccH
         wisnYor82zy+AzE82MrLfHxM+kS4PHNk2n0p0NoPYAO3M7jyMYLX9WTJp5lGBNViuMUR
         W8K2g5Rd4ywxlNPBU7HnoEHbcU570Ez+oi/7pCRKX0LAK4SDaLBGSXYGbtW29OKYMi3/
         SEx9VvsYQCb+1JXTOKHJ60+lEgM0epPw1nzAPeUVaVHlqxSODzir6EqSv7rABOAoasg4
         3nfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699582402; x=1700187202;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CokfVr+85rJcN61ZUPYqVGKL5YI2MWC/M4+QQUo01DY=;
        b=mIBdqIeP5APFrLTAd9J+FDbaUZQeTyP035/91hBlxnbkhXNkPD/6RWfXnnO+K8YCfQ
         r4OW4hFY9ETUpGv8QmVNXbS6Oqffgt1KX0jxIc8+Dei03wWg51s7VcYPcP+6eagZH5St
         HC8zydy7qaUQJosryM2zKsqSfBGMTFVV5IQLVG6ac/t9/GOxprUPZXpzic9rf/+P802l
         64k+QgvPjRI7uCYvh0rgsM+YnSZeQZ31HxRAF21BtefVvdhdbRRym02PdLPmo0QutKEr
         eq4FAwQYQ7qkZ5uPI9FKEeV5YH9Uph6pGHeVNJU8+pk3YiCbHxVUOErbuABFV4iMYoGq
         FuNw==
X-Gm-Message-State: AOJu0Yz4KaO/MkZQ76057xqUTbB4/EBPlH0Nr2sxl+ucy6X4jKpae3/w
	zAns9uMuUkno4LWvNcaf2kHtA7AvIYo=
X-Google-Smtp-Source: AGHT+IG0ivYvg9Uo/CP7uxla1Fuc2ljsG5mSxBTMA6o6TE7C7DWvtjYyQ9vmGTV3vIblFHw1ZaKGBqI3dVQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ac26:0:b0:d9a:6b49:433d with SMTP id
 w38-20020a25ac26000000b00d9a6b49433dmr172418ybi.6.1699582402503; Thu, 09 Nov
 2023 18:13:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  9 Nov 2023 18:12:45 -0800
In-Reply-To: <20231110021306.1269082-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110021306.1269082-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110021306.1269082-6-seanjc@google.com>
Subject: [PATCH v8 05/26] KVM: x86/pmu: Get eventsel for fixed counters from perf
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Get the event selectors used to effectively request fixed counters for
perf events from perf itself instead of hardcoding them in KVM and hoping
that they match the underlying hardware.  While fixed counters 0 and 1 use
architectural events, as of ffbe4ab0beda ("perf/x86/intel: Extend the
ref-cycles event to GP counters") fixed counter 2 (reference TSC cycles)
may use a software-defined pseudo-encoding or a real hardware-defined
encoding.

Reported-by: Kan Liang <kan.liang@linux.intel.com>
Closes: https://lkml.kernel.org/r/4281eee7-6423-4ec8-bb18-c6aeee1faf2c%40linux.intel.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index c9df139efc0c..3bac3b32b485 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -406,24 +406,28 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
  * result is the same (ignoring the fact that using a general purpose counter
  * will likely exacerbate counter contention).
  *
- * Note, reference cycles is counted using a perf-defined "psuedo-encoding",
- * as there is no architectural general purpose encoding for reference cycles.
+ * Forcibly inlined to allow asserting on @index at build time, and there should
+ * never be more than one user.
  */
-static u64 intel_get_fixed_pmc_eventsel(int index)
+static __always_inline u64 intel_get_fixed_pmc_eventsel(unsigned int index)
 {
-	const struct {
-		u8 event;
-		u8 unit_mask;
-	} fixed_pmc_events[] = {
-		[0] = { 0xc0, 0x00 }, /* Instruction Retired / PERF_COUNT_HW_INSTRUCTIONS. */
-		[1] = { 0x3c, 0x00 }, /* CPU Cycles/ PERF_COUNT_HW_CPU_CYCLES. */
-		[2] = { 0x00, 0x03 }, /* Reference Cycles / PERF_COUNT_HW_REF_CPU_CYCLES*/
+	const enum perf_hw_id fixed_pmc_perf_ids[] = {
+		[0] = PERF_COUNT_HW_INSTRUCTIONS,
+		[1] = PERF_COUNT_HW_CPU_CYCLES,
+		[2] = PERF_COUNT_HW_REF_CPU_CYCLES,
 	};
+	u64 eventsel;
 
-	BUILD_BUG_ON(ARRAY_SIZE(fixed_pmc_events) != KVM_PMC_MAX_FIXED);
+	BUILD_BUG_ON(ARRAY_SIZE(fixed_pmc_perf_ids) != KVM_PMC_MAX_FIXED);
+	BUILD_BUG_ON(index >= KVM_PMC_MAX_FIXED);
 
-	return (fixed_pmc_events[index].unit_mask << 8) |
-		fixed_pmc_events[index].event;
+	/*
+	 * Yell if perf reports support for a fixed counter but perf doesn't
+	 * have a known encoding for the associated general purpose event.
+	 */
+	eventsel = perf_get_hw_event_config(fixed_pmc_perf_ids[index]);
+	WARN_ON_ONCE(!eventsel && index < kvm_pmu_cap.num_counters_fixed);
+	return eventsel;
 }
 
 static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
-- 
2.42.0.869.gea05f2083d-goog


