Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50E044BE5C1
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 19:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357054AbiBULxc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 06:53:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357031AbiBULxX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 06:53:23 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC406201A8;
        Mon, 21 Feb 2022 03:52:43 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id cp23-20020a17090afb9700b001bbfe0fbe94so5466972pjb.3;
        Mon, 21 Feb 2022 03:52:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M67FiBJerTGSJ6FYysDGd8HKiVNhS/J/iyD2gNN+Z8g=;
        b=Ai2REqt+PAh8C4xXE6Nrmri7da/xhQeDl08pts38TG7XEiDCTQ1x0wDOFai7SzGSGB
         0sYvQRsO30RCSnPGXTMcJAXo5CdTHCIupar7CycOzolhV1gvLc7/IZ+91ZREZBYQonxN
         YzZqtmHUjt+k4k8PeiTGLeeY7q8iNmDLMqgDpFjsetUVWSicicUJnN5yz+cPJzHIwQqY
         1/G/O1QW4C064nx6gNbWWNmwzJF/E8kMBGCP4I9tG2v9gYZpVAc076FD4k51hZyeIvLx
         qb6RAdX/xEbfXzD3BlVr6O7F3akCWYyDURB4+MOw1vJlY/p53tZoopH/N2ZXbYR7fwQ/
         WTYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M67FiBJerTGSJ6FYysDGd8HKiVNhS/J/iyD2gNN+Z8g=;
        b=iG43KAEUkN0f0oAdm9AeOwTCqR9EIFZlBbG5nHG9XVRSQ3x14hjBO225EcNfrjMmXh
         JPnX6PKMWbKJWgS5LCsvO0PFwgwZ4EXhb+ZF5OUtUvoT5sABv9GQRFmDNrdxpUZ/Losz
         sR1WZco80gxsoW+Y8F8IuRPbNrYSpjvAybqgMLugTIastNLhQLaBaIHlg9RRIPypRMHM
         N7Yixl1oK6/Wct9bPurEEr4XBsBfQBDR72pJ6isEniWz4EhbZFHT4FxPkMx3KotbuAl3
         qulA4Ujle6TS+8KzP/irdRXv6cryUehO28+iwfOjm/L9yIe0ZISrR6tLSUDHweSALQ/0
         xsQQ==
X-Gm-Message-State: AOAM533ifQ24UkL6u3W6bMqSnC0oHFrNZdIZPp5AxmfAavK8p3urRu8g
        2jJtSA+d3Y1VCHMr2iSkmOJ5F7qVvxBiDw==
X-Google-Smtp-Source: ABdhPJzfNyXJ+kYZX5VcZQKNOUs1r33xHf6s9iL2+7tlqlfbafr/U7fPi4Px5zLBtyLYiWL9a2XIrQ==
X-Received: by 2002:a17:90a:d494:b0:1bc:54d7:9e80 with SMTP id s20-20020a17090ad49400b001bc54d79e80mr1468997pju.4.1645444363434;
        Mon, 21 Feb 2022 03:52:43 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z14sm13055011pfe.30.2022.02.21.03.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 03:52:43 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH 10/11] KVM: x86/pmu: Drop amd_event_mapping[] in the KVM context
Date:   Mon, 21 Feb 2022 19:52:00 +0800
Message-Id: <20220221115201.22208-11-likexu@tencent.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220221115201.22208-1-likexu@tencent.com>
References: <20220221115201.22208-1-likexu@tencent.com>
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

All gp or fixed counters have been reprogrammed using PERF_TYPE_RAW,
which means that the table that maps perf_hw_id to event select values is
no longer useful, at least for AMD.

For Intel, the logic to check if the pmu event reported by Intel cpuid is
not available is still required, in which case pmc_perf_hw_id() could be
renamed to hw_event_is_unavail() and a bool value is returned to replace
the semantics of "PERF_COUNT_HW_MAX+1".

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c           |  6 +++---
 arch/x86/kvm/pmu.h           |  2 +-
 arch/x86/kvm/svm/pmu.c       | 34 +++-------------------------------
 arch/x86/kvm/vmx/pmu_intel.c | 11 ++++-------
 4 files changed, 11 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index a6bfcbd3412d..40a6e778b3d9 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -112,9 +112,6 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		.config = config,
 	};
 
-	if (type == PERF_TYPE_HARDWARE && config >= PERF_COUNT_HW_MAX)
-		return;
-
 	attr.sample_period = get_sample_period(pmc, pmc->counter);
 
 	if (in_tx)
@@ -188,6 +185,9 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	__u64 key;
 	int idx;
 
+	if (kvm_x86_ops.pmu_ops->hw_event_is_unavail(pmc))
+		return false;
+
 	filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
 	if (!filter)
 		goto out;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 201b99628423..a2b4037759a2 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -24,7 +24,7 @@ struct kvm_event_hw_type_mapping {
 };
 
 struct kvm_pmu_ops {
-	unsigned int (*pmc_perf_hw_id)(struct kvm_pmc *pmc);
+	bool (*hw_event_is_unavail)(struct kvm_pmc *pmc);
 	bool (*pmc_is_enabled)(struct kvm_pmc *pmc);
 	struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
 	struct kvm_pmc *(*rdpmc_ecx_to_pmc)(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index b264e8117be1..031962a5e50f 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -33,18 +33,6 @@ enum index {
 	INDEX_ERROR,
 };
 
-/* duplicated from amd_perfmon_event_map, K7 and above should work. */
-static struct kvm_event_hw_type_mapping amd_event_mapping[] = {
-	[0] = { 0x76, 0x00, PERF_COUNT_HW_CPU_CYCLES },
-	[1] = { 0xc0, 0x00, PERF_COUNT_HW_INSTRUCTIONS },
-	[2] = { 0x7d, 0x07, PERF_COUNT_HW_CACHE_REFERENCES },
-	[3] = { 0x7e, 0x07, PERF_COUNT_HW_CACHE_MISSES },
-	[4] = { 0xc2, 0x00, PERF_COUNT_HW_BRANCH_INSTRUCTIONS },
-	[5] = { 0xc3, 0x00, PERF_COUNT_HW_BRANCH_MISSES },
-	[6] = { 0xd0, 0x00, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND },
-	[7] = { 0xd1, 0x00, PERF_COUNT_HW_STALLED_CYCLES_BACKEND },
-};
-
 static unsigned int get_msr_base(struct kvm_pmu *pmu, enum pmu_type type)
 {
 	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
@@ -138,25 +126,9 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
 	return &pmu->gp_counters[msr_to_index(msr)];
 }
 
-static unsigned int amd_pmc_perf_hw_id(struct kvm_pmc *pmc)
+static bool amd_hw_event_is_unavail(struct kvm_pmc *pmc)
 {
-	u8 event_select = pmc->eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
-	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
-	int i;
-
-	/* return PERF_COUNT_HW_MAX as AMD doesn't have fixed events */
-	if (WARN_ON(pmc_is_fixed(pmc)))
-		return PERF_COUNT_HW_MAX;
-
-	for (i = 0; i < ARRAY_SIZE(amd_event_mapping); i++)
-		if (amd_event_mapping[i].eventsel == event_select
-		    && amd_event_mapping[i].unit_mask == unit_mask)
-			break;
-
-	if (i == ARRAY_SIZE(amd_event_mapping))
-		return PERF_COUNT_HW_MAX;
-
-	return amd_event_mapping[i].event_type;
+	return false;
 }
 
 /* check if a PMC is enabled by comparing it against global_ctrl bits. Because
@@ -322,7 +294,7 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 }
 
 struct kvm_pmu_ops amd_pmu_ops = {
-	.pmc_perf_hw_id = amd_pmc_perf_hw_id,
+	.hw_event_is_unavail = amd_hw_event_is_unavail,
 	.pmc_is_enabled = amd_pmc_is_enabled,
 	.pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
 	.rdpmc_ecx_to_pmc = amd_rdpmc_ecx_to_pmc,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 98a01f6a9d5d..58ea46bd92ac 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -84,7 +84,7 @@ static void global_ctrl_changed(struct kvm_pmu *pmu, u64 data)
 	}
 }
 
-static unsigned int intel_pmc_perf_hw_id(struct kvm_pmc *pmc)
+static bool intel_hw_event_is_unavail(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 	u8 event_select = pmc->eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
@@ -98,15 +98,12 @@ static unsigned int intel_pmc_perf_hw_id(struct kvm_pmc *pmc)
 
 		/* disable event that reported as not present by cpuid */
 		if ((i < 7) && !(pmu->available_event_types & (1 << i)))
-			return PERF_COUNT_HW_MAX + 1;
+			return true;
 
 		break;
 	}
 
-	if (i == ARRAY_SIZE(intel_arch_events))
-		return PERF_COUNT_HW_MAX;
-
-	return intel_arch_events[i].event_type;
+	return false;
 }
 
 /* check if a PMC is enabled by comparing it with globl_ctrl bits. */
@@ -720,7 +717,7 @@ static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
 }
 
 struct kvm_pmu_ops intel_pmu_ops = {
-	.pmc_perf_hw_id = intel_pmc_perf_hw_id,
+	.hw_event_is_unavail = intel_hw_event_is_unavail,
 	.pmc_is_enabled = intel_pmc_is_enabled,
 	.pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
 	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
-- 
2.35.0

