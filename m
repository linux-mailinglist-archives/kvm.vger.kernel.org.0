Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D365B68ADE2
	for <lists+kvm@lfdr.de>; Sun,  5 Feb 2023 02:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbjBEBQW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Feb 2023 20:16:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232335AbjBEBPq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Feb 2023 20:15:46 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1AD26CEF
        for <kvm@vger.kernel.org>; Sat,  4 Feb 2023 17:15:34 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id h15so1517096plk.12
        for <kvm@vger.kernel.org>; Sat, 04 Feb 2023 17:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gjq8d2P8lqjqZuN79mCeSzj5gCsgyzcUeKJxexzB75I=;
        b=Y1KXdxa3QpYFqUSVrXzV8l5+MpcWqHM6Q2O6BxFrKjycxCRStoe8+LyZLpRWHpdYp3
         8B/JR1ejx8m3KkTFdSmIxlJ6RIPBT/BOjS9Q7L0hz2m9kwVPX6QhHLvWfG3ATcGW8AiX
         FvYKG/a/J92nW4dGZ+sKH6eJERqaeg28ZmOKmSSbM8mxjFlJxFoyAlhQ9Amss6TR168l
         SEb2rX3IKxX0KgISP7g/hoMvPWLfT0gdeW85C5q8+WxTZANcrWO4GLd2WUkrrUN+1ZM5
         2BiUf/xOQlRrGafiAE1bNwgSV5Qt0OAX0h6lt75ULVXV3QEKfR92gdXHmrw4PKNGmsE7
         tkkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gjq8d2P8lqjqZuN79mCeSzj5gCsgyzcUeKJxexzB75I=;
        b=r1geccZe8qfCk4UnWRDpETOQwdVLngORx6fRum2+xctTK2EJuy7YC3uNr/idxNgwPX
         neGTSNVz6QvX+GFJkKHtXhtnQqyswiMANHm+M7XTcj6SLLLWgQi3l+6Fm9Q34j5tM2/k
         fDph/yw7OrVQEf8lAugjSj1yZ1B1d/IWTc/VJp7EANLSMBu4Hq9amjdx2dFcNzrZeRYQ
         vAtJMOgwR44mxauStu0c4NgkrY+aKgaj+pejemAecvU9j48StS0wu/7iO5o1+wYaLSO4
         fbN1Omqnbt1TYsE8cnSB/AVeZ37oZyep9XqAZ1BLY8X6GcmYzuOehQXHXwGz07Zl5gFp
         7xtA==
X-Gm-Message-State: AO0yUKUtQUI2NVmJ3UO+tyo25Sw1VjSJHkmkJS42IwWrvlPjn9/mrA29
        y+wpSX8w3MtwiM1oip1TbrrjFQ==
X-Google-Smtp-Source: AK7set+f+wjOEQJcSAgk6Te27LgpbuiFyo+RYT+5UL78TCe40xmLHRxPm0a5aE7rwbaZV3jFxlNQ4Q==
X-Received: by 2002:a17:90b:218c:b0:228:de0e:c8af with SMTP id ku12-20020a17090b218c00b00228de0ec8afmr16591715pjb.16.1675559734471;
        Sat, 04 Feb 2023 17:15:34 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id c7-20020a17090a020700b0023080c4c3bcsm2721917pjc.31.2023.02.04.17.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 17:15:34 -0800 (PST)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Anup Patel <anup@brainfault.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v5 13/14] RISC-V: KVM: Support firmware events
Date:   Sat,  4 Feb 2023 17:15:14 -0800
Message-Id: <20230205011515.1284674-14-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230205011515.1284674-1-atishp@rivosinc.com>
References: <20230205011515.1284674-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SBI PMU extension defines a set of firmware events which can provide
useful information to guests about the number of SBI calls. As
hypervisor implements the SBI PMU extension, these firmware events
correspond to ecall invocations between VS->HS mode. All other firmware
events will always report zero if monitored as KVM doesn't implement them.

This patch adds all the infrastructure required to support firmware
events.

Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_vcpu_pmu.h |  17 ++++
 arch/riscv/kvm/vcpu_pmu.c             | 141 ++++++++++++++++++++------
 2 files changed, 125 insertions(+), 33 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
index 344a3ad..a8c73c81 100644
--- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
+++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
@@ -22,6 +22,14 @@
 
 #define RISCV_MAX_COUNTERS 64
 
+struct kvm_fw_event {
+	/* Current value of the event */
+	unsigned long value;
+
+	/* Event monitoring status */
+	bool started;
+};
+
 /* Per virtual pmu counter data */
 struct kvm_pmc {
 	u8 idx;
@@ -30,11 +38,14 @@ struct kvm_pmc {
 	union sbi_pmu_ctr_info cinfo;
 	/* Event monitoring status */
 	bool started;
+	/* Monitoring event ID */
+	unsigned long event_idx;
 };
 
 /* PMU data structure per vcpu */
 struct kvm_pmu {
 	struct kvm_pmc pmc[RISCV_MAX_COUNTERS];
+	struct kvm_fw_event fw_event[RISCV_KVM_MAX_FW_CTRS];
 	/* Number of the virtual firmware counters available */
 	int num_fw_ctrs;
 	/* Number of the virtual hardware counters available */
@@ -57,6 +68,7 @@ struct kvm_pmu {
 {.base = CSR_CYCLE,      .count = 31, .func = kvm_riscv_vcpu_pmu_read_hpm },
 #endif
 
+int kvm_riscv_vcpu_pmu_incr_fw(struct kvm_vcpu *vcpu, unsigned long fid);
 int kvm_riscv_vcpu_pmu_read_hpm(struct kvm_vcpu *vcpu, unsigned int csr_num,
 				unsigned long *val, unsigned long new_val,
 				unsigned long wr_mask);
@@ -88,6 +100,11 @@ struct kvm_pmu {
 { .base = 0,      .count = 0, .func = NULL },
 
 static inline void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu) {}
+static inline int kvm_riscv_vcpu_pmu_incr_fw(struct kvm_vcpu *vcpu, unsigned long fid)
+{
+	return 0;
+}
+
 static inline void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu) {}
 #endif /* CONFIG_RISCV_PMU_SBI */
diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 2ea0aa8..7a923b6 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -202,12 +202,18 @@ static int pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
 	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
 	u64 enabled, running;
+	int fevent_code;
 
 	pmc = &kvpmu->pmc[cidx];
-	if (!pmc->perf_event)
-		return -EINVAL;
 
-	pmc->counter_val += perf_event_read_value(pmc->perf_event, &enabled, &running);
+	if (pmc->cinfo.type == SBI_PMU_CTR_TYPE_FW) {
+		fevent_code = get_event_code(pmc->event_idx);
+		pmc->counter_val = kvpmu->fw_event[fevent_code].value;
+	} else if (pmc->perf_event) {
+		pmc->counter_val += perf_event_read_value(pmc->perf_event, &enabled, &running);
+	} else {
+		return -EINVAL;
+	}
 	*out_val = pmc->counter_val;
 
 	return 0;
@@ -223,6 +229,52 @@ static int kvm_pmu_validate_counter_mask(struct kvm_pmu *kvpmu, unsigned long ct
 	return 0;
 }
 
+static int kvm_pmu_create_perf_event(struct kvm_pmc *pmc, struct perf_event_attr *attr,
+				     unsigned long flags, unsigned long eidx, unsigned long evtdata)
+{
+	struct perf_event *event;
+
+	kvm_pmu_release_perf_event(pmc);
+	attr->config = kvm_pmu_get_perf_event_config(eidx, evtdata);
+	if (flags & SBI_PMU_CFG_FLAG_CLEAR_VALUE) {
+		//TODO: Do we really want to clear the value in hardware counter
+		pmc->counter_val = 0;
+	}
+
+	/*
+	 * Set the default sample_period for now. The guest specified value
+	 * will be updated in the start call.
+	 */
+	attr->sample_period = kvm_pmu_get_sample_period(pmc);
+
+	event = perf_event_create_kernel_counter(attr, -1, current, NULL, pmc);
+	if (IS_ERR(event)) {
+		pr_err("kvm pmu event creation failed for eidx %lx: %ld\n", eidx, PTR_ERR(event));
+		return PTR_ERR(event);
+	}
+
+	pmc->perf_event = event;
+	if (flags & SBI_PMU_CFG_FLAG_AUTO_START)
+		perf_event_enable(pmc->perf_event);
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_pmu_incr_fw(struct kvm_vcpu *vcpu, unsigned long fid)
+{
+	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
+	struct kvm_fw_event *fevent;
+
+	if (!kvpmu || fid >= SBI_PMU_FW_MAX)
+		return -EINVAL;
+
+	fevent = &kvpmu->fw_event[fid];
+	if (fevent->started)
+		fevent->value++;
+
+	return 0;
+}
+
 int kvm_riscv_vcpu_pmu_read_hpm(struct kvm_vcpu *vcpu, unsigned int csr_num,
 				unsigned long *val, unsigned long new_val,
 				unsigned long wr_mask)
@@ -289,6 +341,7 @@ int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
 	int i, pmc_index, sbiret = 0;
 	struct kvm_pmc *pmc;
+	int fevent_code;
 
 	if (kvm_pmu_validate_counter_mask(kvpmu, ctr_base, ctr_mask) < 0) {
 		sbiret = SBI_ERR_INVALID_PARAM;
@@ -303,7 +356,22 @@ int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 		pmc = &kvpmu->pmc[pmc_index];
 		if (flags & SBI_PMU_START_FLAG_SET_INIT_VALUE)
 			pmc->counter_val = ival;
-		if (pmc->perf_event) {
+		if (pmc->cinfo.type == SBI_PMU_CTR_TYPE_FW) {
+			fevent_code = get_event_code(pmc->event_idx);
+			if (fevent_code >= SBI_PMU_FW_MAX) {
+				sbiret = SBI_ERR_INVALID_PARAM;
+				goto out;
+			}
+
+			/* Check if the counter was already started for some reason */
+			if (kvpmu->fw_event[fevent_code].started) {
+				sbiret = SBI_ERR_ALREADY_STARTED;
+				continue;
+			}
+
+			kvpmu->fw_event[fevent_code].started = true;
+			kvpmu->fw_event[fevent_code].value = pmc->counter_val;
+		} else if (pmc->perf_event) {
 			if (unlikely(pmc->started)) {
 				sbiret = SBI_ERR_ALREADY_STARTED;
 				continue;
@@ -330,6 +398,7 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 	int i, pmc_index, sbiret = 0;
 	u64 enabled, running;
 	struct kvm_pmc *pmc;
+	int fevent_code;
 
 	if (kvm_pmu_validate_counter_mask(kvpmu, ctr_base, ctr_mask) < 0) {
 		sbiret = SBI_ERR_INVALID_PARAM;
@@ -342,7 +411,18 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 		if (!test_bit(pmc_index, kvpmu->pmc_in_use))
 			continue;
 		pmc = &kvpmu->pmc[pmc_index];
-		if (pmc->perf_event) {
+		if (pmc->cinfo.type == SBI_PMU_CTR_TYPE_FW) {
+			fevent_code = get_event_code(pmc->event_idx);
+			if (fevent_code >= SBI_PMU_FW_MAX) {
+				sbiret = SBI_ERR_INVALID_PARAM;
+				goto out;
+			}
+
+			if (!kvpmu->fw_event[fevent_code].started)
+				sbiret = SBI_ERR_ALREADY_STOPPED;
+
+			kvpmu->fw_event[fevent_code].started = false;
+		} else if (pmc->perf_event) {
 			if (pmc->started) {
 				/* Stop counting the counter */
 				perf_event_disable(pmc->perf_event);
@@ -356,11 +436,14 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 				pmc->counter_val += perf_event_read_value(pmc->perf_event,
 									  &enabled, &running);
 				kvm_pmu_release_perf_event(pmc);
-				clear_bit(pmc_index, kvpmu->pmc_in_use);
 			}
 		} else {
 			sbiret = SBI_ERR_INVALID_PARAM;
 		}
+		if (flags & SBI_PMU_STOP_FLAG_RESET) {
+			pmc->event_idx = SBI_PMU_EVENT_IDX_INVALID;
+			clear_bit(pmc_index, kvpmu->pmc_in_use);
+		}
 	}
 
 out:
@@ -374,12 +457,12 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
 				     unsigned long eidx, u64 evtdata,
 				     struct kvm_vcpu_sbi_return *retdata)
 {
-	int ctr_idx, sbiret = 0;
-	u64 config;
+	int ctr_idx, ret, sbiret = 0;
+	bool is_fevent;
+	unsigned long event_code;
 	u32 etype = kvm_pmu_get_perf_event_type(eidx);
 	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
-	struct perf_event *event;
-	struct kvm_pmc *pmc;
+	struct kvm_pmc *pmc = NULL;
 	struct perf_event_attr attr = {
 		.type = etype,
 		.size = sizeof(struct perf_event_attr),
@@ -400,7 +483,9 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
 		goto out;
 	}
 
-	if (kvm_pmu_is_fw_event(eidx)) {
+	event_code = get_event_code(eidx);
+	is_fevent = kvm_pmu_is_fw_event(eidx);
+	if (is_fevent && event_code >= SBI_PMU_FW_MAX) {
 		sbiret = SBI_ERR_NOT_SUPPORTED;
 		goto out;
 	}
@@ -424,33 +509,19 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
 	}
 
 	pmc = &kvpmu->pmc[ctr_idx];
-	kvm_pmu_release_perf_event(pmc);
 	pmc->idx = ctr_idx;
 
-	config = kvm_pmu_get_perf_event_config(eidx, evtdata);
-	attr.config = config;
-	if (flags & SBI_PMU_CFG_FLAG_CLEAR_VALUE) {
-		//TODO: Do we really want to clear the value in hardware counter
-		pmc->counter_val = 0;
-	}
-
-	/*
-	 * Set the default sample_period for now. The guest specified value
-	 * will be updated in the start call.
-	 */
-	attr.sample_period = kvm_pmu_get_sample_period(pmc);
-
-	event = perf_event_create_kernel_counter(&attr, -1, current, NULL, pmc);
-	if (IS_ERR(event)) {
-		pr_err("kvm pmu event creation failed for eidx %lx: %ld\n", eidx, PTR_ERR(event));
-		return PTR_ERR(event);
+	if (is_fevent) {
+		if (flags & SBI_PMU_CFG_FLAG_AUTO_START)
+			kvpmu->fw_event[event_code].started = true;
+	} else {
+		ret = kvm_pmu_create_perf_event(pmc, &attr, flags, eidx, evtdata);
+		if (ret)
+			return ret;
 	}
 
 	set_bit(ctr_idx, kvpmu->pmc_in_use);
-	pmc->perf_event = event;
-	if (flags & SBI_PMU_CFG_FLAG_AUTO_START)
-		perf_event_enable(pmc->perf_event);
-
+	pmc->event_idx = eidx;
 	retdata->out_val = ctr_idx;
 out:
 	retdata->err_val = sbiret;
@@ -493,6 +564,7 @@ void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
 	 */
 	kvpmu->num_hw_ctrs = num_hw_ctrs + 1;
 	kvpmu->num_fw_ctrs = SBI_PMU_FW_MAX;
+	memset(&kvpmu->fw_event, 0, SBI_PMU_FW_MAX * sizeof(struct kvm_fw_event));
 
 	/*
 	 * There is no correlation between the logical hardware counter and virtual counters.
@@ -506,6 +578,7 @@ void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
 			continue;
 		pmc = &kvpmu->pmc[i];
 		pmc->idx = i;
+		pmc->event_idx = SBI_PMU_EVENT_IDX_INVALID;
 		if (i < kvpmu->num_hw_ctrs) {
 			pmc->cinfo.type = SBI_PMU_CTR_TYPE_HW;
 			if (i < 3)
@@ -542,8 +615,10 @@ void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu)
 		pmc = &kvpmu->pmc[i];
 		pmc->counter_val = 0;
 		kvm_pmu_release_perf_event(pmc);
+		pmc->event_idx = SBI_PMU_EVENT_IDX_INVALID;
 	}
 	bitmap_zero(kvpmu->pmc_in_use, RISCV_MAX_COUNTERS);
+	memset(&kvpmu->fw_event, 0, SBI_PMU_FW_MAX * sizeof(struct kvm_fw_event));
 }
 
 void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu)
-- 
2.25.1

