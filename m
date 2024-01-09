Return-Path: <kvm+bounces-5924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DAF0F829071
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 00:05:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8351B1F25EBB
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 23:05:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86E6E3FE42;
	Tue,  9 Jan 2024 23:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1TJ3eTbm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE103FB20
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 23:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbcd9f4396eso4780054276.0
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 15:03:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704841382; x=1705446182; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=w1FIQniV5Y7kaVFZp970t8OKo7Z30rt5vxBHoT10l/c=;
        b=1TJ3eTbmUJxm5A8aCYU27LvnI7qYfb39aOfr9/vnG53+4g0e0jTSd/NQ3KCZS1Vq34
         owBfof/BroOssxbp3X+XcMrLxh+/nbvO1n9Ngx50KyqCmc377/pa0vfSmsDpjfXGWU1d
         cdcssPDAX0thnx+MmZKPR0Nt/BrFeMmmE/r2fpkKkkLQur9mPsKxuE7CUe9CjUqev7QJ
         /P88NMY3QmFS+ees4pJWATW8gEjMl9MyxDLZkwIIh4g8TgiKQKf3V2y3tkI7gLwhZ8DC
         BcHfSUBOJu6tTFsZ9sj8Bp3tl4Lopej46JYZKEtw/Bezw8ptAuGJQ+ypS871tLwmtHgf
         t+xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704841382; x=1705446182;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w1FIQniV5Y7kaVFZp970t8OKo7Z30rt5vxBHoT10l/c=;
        b=hEuz9s5bRPgjwkchX+Yb5+KB1Fr/9tHqmf2Mo/sLesLIotVSfNRUzPukt/yA297Nav
         oQznX8tcIhVnJWGdtYqS85Q9M4o9qbh3SvZoROwyVLl8w/XiSfKYWQqCWJX/EiyTAP/z
         TT/yYRucAgrJ0Y0nh4AuKwlwOWpTe1B++Z21wB/0YlG70u34pcYPKVGmuCY2BqLbugxN
         aMJKQawKxQs0oHCTTAw0CofeyPecaWovjOwZCVTd1Oq5eM04MZ3a3O8TtFm6iscDXePs
         8MDPB1nm6M3jXmIk0MTSRxaK57EHgS+JhKUnzlYmEZSIqchHLZvKq6JJulVmMV9QbeZg
         qZBQ==
X-Gm-Message-State: AOJu0YzGFqJliyuluNsjvMGxqjqJSFoezaV4MC02iNyFaqtiR09s87eq
	zLrs8v9RBvCzxT3Wd/2TSTiSuYeK7fuellbg6w==
X-Google-Smtp-Source: AGHT+IH5yDHCFJ5U9z7zRkzpSnWzCPJ9rOvqJ3lgo3YhoNdwT69avrh3ITugnpnqFasJw5AXyvCzTP5nkfY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:bf8d:0:b0:dbd:4683:21da with SMTP id
 l13-20020a25bf8d000000b00dbd468321damr41195ybk.8.1704841382519; Tue, 09 Jan
 2024 15:03:02 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 15:02:25 -0800
In-Reply-To: <20240109230250.424295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240109230250.424295-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240109230250.424295-6-seanjc@google.com>
Subject: [PATCH v10 05/29] KVM: x86/pmu: Get eventsel for fixed counters from perf
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
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 98e92b9ece09..ec4feaef3d55 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -404,24 +404,28 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
2.43.0.472.g3155946c3a-goog


