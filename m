Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A76ED517CF9
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 08:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiECGGG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 02:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiECGFx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 02:05:53 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4176033A36
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 23:02:20 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id q13-20020a638c4d000000b003821725ad66so7983893pgn.23
        for <kvm@vger.kernel.org>; Mon, 02 May 2022 23:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lyIfp9262fAQLqy8qC0Pz4SUM4FAzF4N7A6nbmSHB2c=;
        b=NTvfdy6F18lFgUV8clR+0g6Lw3bcq5UgO40+92jzBn0iZGYe3Xw9MVeBL3+fvWQw5N
         LB3zzRWSU4HLPPJXB/Dyw7ffCQbjT5/AAfQ9WdrD5WumB7wAGc8Ii16bK1GqoyShUxFT
         T3kMr/bzKtBbctXnCXxWSUOFUbNsLWTvcedPoBzLgEc0OoGSRyBn6HFbR1QI6Sxm0ib1
         LETkvqwaLmlU1m3vcCJyPISK9GXof6Kzpm1nbZPFsnyvcGewnf1XII3NShtf5PlhixsL
         o+7dDUpiE1S+Xes0LqAZedN1LJOIxguMZTGVLGJBoZivv+psCSQs/f/P1ED6jOuNtCkh
         UBAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lyIfp9262fAQLqy8qC0Pz4SUM4FAzF4N7A6nbmSHB2c=;
        b=GK/ZHrDFus0Ijf8VqiQD0k/2jrL3tWuIUcf+N9kZY3WYACMytXexSQy2ieLjpcNe9a
         Q/c3ujkFzAuoQ/hKiREvLL+dKlsKfVMHhwYMKwfIkyNS2cEIwE5xuxWbBr/FnI2PK+8/
         9Q7jrZQoJNSifAU7x+UIyeBqwVaditJ5q9y7CbnRD3KleuT0Iyv6F+qJ9n9gvDHzRGMl
         2LJBTLX143Ib/umqBDstmVa/3dYOPCmQnoRdh4Kj0FHui0GdSXf6h4f6TmKPrcwBlUFY
         lG+arvtgWvonTgVyi4Ch/zTzQvTDPA3NA6uv+bFv9aPJT1oR8WI8SHa5SaYBLaFad0ff
         1yVg==
X-Gm-Message-State: AOAM533oxFTQdf79zfRM+RF6uzmvaX6cx1Cid2cj1bI2zaSVUP9X57rr
        chbwIXffSujPEp3x1eDqAOxYhiMdrkY=
X-Google-Smtp-Source: ABdhPJySoUR5II5RZFESdkmpRUNaWMWZc4db9m57Xb50n4CBJPr51KRBblc9PtMJAUv+qFnKQOynLlQ7TLQ=
X-Received: from oupton3.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a17:90b:e89:b0:1dc:18dc:26a0 with SMTP id
 fv9-20020a17090b0e8900b001dc18dc26a0mr2986517pjb.188.1651557739605; Mon, 02
 May 2022 23:02:19 -0700 (PDT)
Date:   Tue,  3 May 2022 06:02:05 +0000
In-Reply-To: <20220503060205.2823727-1-oupton@google.com>
Message-Id: <20220503060205.2823727-8-oupton@google.com>
Mime-Version: 1.0
References: <20220503060205.2823727-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v4 7/7] Revert "KVM/arm64: Don't emulate a PMU for 32-bit
 guests if feature not set"
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        reijiw@google.com, ricarkol@google.com,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This reverts commit 8f6379e207e7d834065a080f407a60d67349d961.

The original change was not problematic but chose nonarchitected PMU
register behavior over a NULL deref as KVM failed to hide the PMU in the
ID_DFR0.

Since KVM now provides a sane value for ID_DFR0 and UNDEFs the guest for
unsupported accesses, drop the unneeded checks in PMU register handlers.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 3dc990ac4f44..78fdc443adc7 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -177,9 +177,6 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
 
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return 0;
-
 	counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
 
 	if (kvm_pmu_pmc_is_chained(pmc) &&
@@ -201,9 +198,6 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
 {
 	u64 reg;
 
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return;
-
 	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
 	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
 	__vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
@@ -328,9 +322,6 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	struct kvm_pmc *pmc;
 
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return;
-
 	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) || !val)
 		return;
 
@@ -366,7 +357,7 @@ void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	struct kvm_pmc *pmc;
 
-	if (!kvm_vcpu_has_pmu(vcpu) || !val)
+	if (!val)
 		return;
 
 	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
@@ -536,9 +527,6 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	int i;
 
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return;
-
 	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E))
 		return;
 
@@ -588,9 +576,6 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 {
 	int i;
 
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return;
-
 	if (val & ARMV8_PMU_PMCR_E) {
 		kvm_pmu_enable_counter_mask(vcpu,
 		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
@@ -754,9 +739,6 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 {
 	u64 reg, mask;
 
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return;
-
 	mask  =  ARMV8_PMU_EVTYPE_MASK;
 	mask &= ~ARMV8_PMU_EVTYPE_EVENT;
 	mask |= kvm_pmu_event_mask(vcpu->kvm);
@@ -845,9 +827,6 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 	u64 val, mask = 0;
 	int base, i, nr_events;
 
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return 0;
-
 	if (!pmceid1) {
 		val = read_sysreg(pmceid0_el0);
 		base = 0;
-- 
2.36.0.464.gb9c8b46e94-goog

