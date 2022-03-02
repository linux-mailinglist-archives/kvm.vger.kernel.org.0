Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0304E4CA2F9
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 12:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241357AbiCBLO4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 06:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241306AbiCBLOs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 06:14:48 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A27AC5FF3D;
        Wed,  2 Mar 2022 03:14:02 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id p3-20020a17090a680300b001bbfb9d760eso4500411pjj.2;
        Wed, 02 Mar 2022 03:14:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oRqNxSI8JpSv4mCnF5OeOINua/1Jvz4rIlrtr/F2+30=;
        b=NGCuJhq72MOxkJkFa6eEhIgwWnHyo2x1Ze70WR18Rwen6EFC+335loZvD5B9EZNoP3
         iBu5cGDaNqaFGx/F9tuLQxOmb5K5+QrD5JT8I6KDalOdO53/T1+3119mdUBWXCgz9pA+
         Fv6oNGdL8ULsDCIZ8OD7LLPtyV339b3WxpnZqHIpNIaIzVBnebStf3lEnYXloawAFTtk
         RPBOH2MjM7gO3lz9ZboAH5NIf2v5I6sDXvNZ0vyj8ABCoPqLdA0zbvAxod+8R++Lp6Jj
         yU+ym9V9u2NlUyIHWXDz/vM15FFkjT3CHxbmcY9HkxanYTIwu1DZfkWAA5Jlbqv8EfL+
         VXXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oRqNxSI8JpSv4mCnF5OeOINua/1Jvz4rIlrtr/F2+30=;
        b=rwYod6S3Y3H8IOP5BhRz3Q3/dCO7jYqwaZRBR+vRH5CuaZkHwVjCw7npXQXRbCMpHl
         OyRGKdOjJbFEK7XUo5JS6ZDZEHgXn2m5oMfnMOfnb9xX1j7kglIrU+BGT5CMENzKmu8v
         qgeiFULPu7e2kbI1QiuXkCODw4ONTbrowhs/g2DJpLMv3aIHHxTbMz7NePIAi7zumXfd
         +k7h1GUI7s5ARz/l8F/ntzpDERfrJTRaHWhfcpvfvdf4v4N2YSGW3XABBBs27u0FtsC4
         2dcVD2qSXXW12+MWQpJDwG7HiUD1WNS0o7MnR8BpyX0EjcOOtulMpn6FI8NXyi8xsYcN
         TwLA==
X-Gm-Message-State: AOAM533fnV/gA9lo39GWiGEsO5C5bFDDe22AA4g7YoJO5yyNVyxUJGV+
        aPs/SKjreOPVLwBeHvtRvzg=
X-Google-Smtp-Source: ABdhPJx5TnBse/IEuhRhhkkfHmY3AR+YCUF0+oqbpB9qPyYt3UJs838S6X15dPYerhxGhMhLXhyjKg==
X-Received: by 2002:a17:90a:fe86:b0:1bc:6935:346 with SMTP id co6-20020a17090afe8600b001bc69350346mr26946641pjb.150.1646219642118;
        Wed, 02 Mar 2022 03:14:02 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id v22-20020a17090ad59600b001b7deb42251sm4681847pju.15.2022.03.02.03.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 03:14:01 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Like Xu <likexu@tencent.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v2 07/12] KVM: x86/pmu: Use PERF_TYPE_RAW to merge reprogram_{gp, fixed}counter()
Date:   Wed,  2 Mar 2022 19:13:29 +0800
Message-Id: <20220302111334.12689-8-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220302111334.12689-1-likexu@tencent.com>
References: <20220302111334.12689-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The code sketch for reprogram_{gp, fixed}_counter() is similar, while the
fixed counter using the PERF_TYPE_HARDWAR type and the gp being
able to use either PERF_TYPE_HARDWAR or PERF_TYPE_RAW type
depending on the pmc->eventsel value.

After 'commit 761875634a5e ("KVM: x86/pmu: Setup pmc->eventsel
for fixed PMCs")', the pmc->eventsel of the fixed counter will also have
been setup with the same semantic value and will not be changed during
the guest runtime. But essentially, "the HARDWARE is just a convenience
wrapper over RAW IIRC", quoated from Peterz. So it could be pretty safe
to use the PERF_TYPE_RAW type only to program both gp and fixed
counters naturally in the reprogram_counter().

To make the gp and fixed counters more semantically symmetrical,
the selection of EVENTSEL_{USER, OS, INT} bits is temporarily translated
via fixed_ctr_ctrl before the pmc_reprogram_counter() call.

Cc: Peter Zijlstra <peterz@infradead.org>
Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c           | 128 +++++++++++++----------------------
 arch/x86/kvm/vmx/pmu_intel.c |   2 +-
 2 files changed, 47 insertions(+), 83 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 5299488b002c..00e1660c10ca 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -215,85 +215,60 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	return allow_event;
 }
 
-static void reprogram_gp_counter(struct kvm_pmc *pmc)
-{
-	u64 config;
-	u32 type = PERF_TYPE_RAW;
-	u64 eventsel = pmc->eventsel;
-
-	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
-		printk_once("kvm pmu: pin control bit is ignored\n");
-
-	pmc_pause_counter(pmc);
-
-	if (!(eventsel & ARCH_PERFMON_EVENTSEL_ENABLE) || !pmc_is_enabled(pmc))
-		return;
-
-	if (!check_pmu_event_filter(pmc))
-		return;
-
-	if (!(eventsel & (ARCH_PERFMON_EVENTSEL_EDGE |
-			  ARCH_PERFMON_EVENTSEL_INV |
-			  ARCH_PERFMON_EVENTSEL_CMASK |
-			  HSW_IN_TX |
-			  HSW_IN_TX_CHECKPOINTED))) {
-		config = kvm_x86_ops.pmu_ops->pmc_perf_hw_id(pmc);
-		if (config != PERF_COUNT_HW_MAX)
-			type = PERF_TYPE_HARDWARE;
-	}
-
-	if (type == PERF_TYPE_RAW)
-		config = eventsel & AMD64_RAW_EVENT_MASK;
-
-	if (pmc->current_config == eventsel && pmc_resume_counter(pmc))
-		return;
-
-	pmc_release_perf_event(pmc);
-
-	pmc->current_config = eventsel;
-	pmc_reprogram_counter(pmc, type, config,
-			      !(eventsel & ARCH_PERFMON_EVENTSEL_USR),
-			      !(eventsel & ARCH_PERFMON_EVENTSEL_OS),
-			      eventsel & ARCH_PERFMON_EVENTSEL_INT,
-			      (eventsel & HSW_IN_TX),
-			      (eventsel & HSW_IN_TX_CHECKPOINTED));
-}
-
-static void reprogram_fixed_counter(struct kvm_pmc *pmc)
+static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
-	int idx = pmc->idx - INTEL_PMC_IDX_FIXED;
-	u8 ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl, idx);
-	unsigned en_field = ctrl & 0x3;
-	bool pmi = ctrl & 0x8;
 
-	pmc_pause_counter(pmc);
+	if (pmc_is_fixed(pmc))
+		return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
+			pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
 
-	if (!en_field || !pmc_is_enabled(pmc))
-		return;
-
-	if (!check_pmu_event_filter(pmc))
-		return;
-
-	if (pmc->current_config == (u64)ctrl && pmc_resume_counter(pmc))
-		return;
-
-	pmc_release_perf_event(pmc);
-
-	pmc->current_config = (u64)ctrl;
-	pmc_reprogram_counter(pmc, PERF_TYPE_HARDWARE,
-			      kvm_x86_ops.pmu_ops->pmc_perf_hw_id(pmc),
-			      !(en_field & 0x2), /* exclude user */
-			      !(en_field & 0x1), /* exclude kernel */
-			      pmi, false, false);
+	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
 }
 
 void reprogram_counter(struct kvm_pmc *pmc)
 {
-	if (pmc_is_gp(pmc))
-		reprogram_gp_counter(pmc);
-	else
-		reprogram_fixed_counter(pmc);
+	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+	u64 eventsel = pmc->eventsel;
+	u64 new_config = eventsel;
+	u8 fixed_ctr_ctrl;
+
+	pmc_pause_counter(pmc);
+
+	if (!pmc_speculative_in_use(pmc) || !pmc_is_enabled(pmc))
+		return;
+
+	if (!check_pmu_event_filter(pmc))
+		return;
+
+	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
+		printk_once("kvm pmu: pin control bit is ignored\n");
+
+	if (pmc_is_fixed(pmc)) {
+		fixed_ctr_ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl,
+						  pmc->idx - INTEL_PMC_IDX_FIXED);
+		if (fixed_ctr_ctrl & 0x1)
+			eventsel |= ARCH_PERFMON_EVENTSEL_OS;
+		if (fixed_ctr_ctrl & 0x2)
+			eventsel |= ARCH_PERFMON_EVENTSEL_USR;
+		if (fixed_ctr_ctrl & 0x8)
+			eventsel |= ARCH_PERFMON_EVENTSEL_INT;
+		new_config = (u64)fixed_ctr_ctrl;
+	}
+
+	if (pmc->current_config == new_config && pmc_resume_counter(pmc))
+		return;
+
+	pmc_release_perf_event(pmc);
+
+	pmc->current_config = new_config;
+	pmc_reprogram_counter(pmc, PERF_TYPE_RAW,
+			(eventsel & AMD64_RAW_EVENT_MASK),
+			!(eventsel & ARCH_PERFMON_EVENTSEL_USR),
+			!(eventsel & ARCH_PERFMON_EVENTSEL_OS),
+			eventsel & ARCH_PERFMON_EVENTSEL_INT,
+			(eventsel & HSW_IN_TX),
+			(eventsel & HSW_IN_TX_CHECKPOINTED));
 }
 EXPORT_SYMBOL_GPL(reprogram_counter);
 
@@ -451,17 +426,6 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 	kvm_pmu_refresh(vcpu);
 }
 
-static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
-{
-	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
-
-	if (pmc_is_fixed(pmc))
-		return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
-			pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
-
-	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
-}
-
 /* Release perf_events for vPMCs that have been unused for a full time slice.  */
 void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 19b78a9d9d47..d823fbe4e155 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -492,7 +492,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->reserved_bits = 0xffffffff00200000ull;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
-	if (!entry || !vcpu->kvm->arch.enable_pmu)
+	if (!entry || !vcpu->kvm->arch.enable_pmu || !boot_cpu_has(X86_FEATURE_ARCH_PERFMON))
 		return;
 	eax.full = entry->eax;
 	edx.full = entry->edx;
-- 
2.35.1

