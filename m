Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0185B5A8307
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 18:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbiHaQVo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 12:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231731AbiHaQVf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 12:21:35 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324C5696E3
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 09:21:34 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id z8-20020a17090abd8800b001fd5f11fca7so9384491pjr.6
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 09:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=xHvfAoKyk2MXLRXi8CR/QLeALLLFoEGFWHwBw1hufPU=;
        b=VmnfHIMUtvPMebGoQg/lst5MYA8z1bX8UiM88taX1z//JNHflqFBHuEASLKK0jkJnq
         AyT+pR8WZgOzoRC//OLny77XOekb6egMWZKknGZjBHUoJzwqxM5xDTIncOfKF1HvO9EY
         XT3VVB1SLQdFeVpoW63LMWXyZCiTvH1hijUljZ4FcY/DdMyH1KNWn+Zj9Bw0+TL1xltx
         x8sialOZvP5gmLm/1QUXtCT8T9yx6RuB5TNpizfTwWN/T38x05hRso3lupVGpmxdf3Oi
         ac2R+OVB0ehzHEs5pVbFkhAMKhrZZs8WmGoq6HEnx4vq9dqpgd3m9CTvzulkCIkNmzCJ
         3nGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=xHvfAoKyk2MXLRXi8CR/QLeALLLFoEGFWHwBw1hufPU=;
        b=1R89Q2lFk2hLWteCdysAMIzMEau2f3OzrgInndYBAa/HEP24IWEBMQ0tbuo5kFvm1k
         z0VNPEGNzIKM5oVQMtBoQTj3YmVGpArRMDReVUFy2DsPUjBFvZf5d6sfe/l5ID6Lhvvx
         yYOWIHZuwBIzpY2ZuOTzbJD8ECVmS/NUgE/f1XSlBAIvEoIR7KL2WLAiNmxvHKP67eFm
         9tvZsNt6pHMQL11cS/ypQQQLaqnXjlujT7NMYbjThT8YGoSjpznylzKbUeJY532vKmez
         az6WWELb3IdTOVmz55NcgFjyuUR/dbMrxFwEX0PqMHYv86r+qENtxyg3dIPySlQ/tiOu
         Hx5w==
X-Gm-Message-State: ACgBeo2huHy22QejGPy8/iXCqktw5knZD0Yz3vc166vWPzNOuR9pRLwu
        FtMA1yxwEw7430jQO6ArwrdP6I2BaJ5x2oWoQjUtj1IjzSjrlFZLhBrdX+phaW2ijn/+kE7tPLm
        V24v+ky5HwvwEwOIJRdNK76JewWoE7H9uPs+ZpO2bLvfprU1MM1dRuuihPZeJvmACFXPQ
X-Google-Smtp-Source: AA6agR5e424wM5jpy3e7kSGBwZCE/A9pwXdDeKFXg/CaI4279ezmReyu+IN2mshveXApfS10lKuoCzaMHA3/uIx4
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP
 id t9-20020a17090a024900b001e0a8a33c6cmr233247pje.0.1661962893208; Wed, 31
 Aug 2022 09:21:33 -0700 (PDT)
Date:   Wed, 31 Aug 2022 16:21:18 +0000
In-Reply-To: <20220831162124.947028-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220831162124.947028-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831162124.947028-2-aaronlewis@google.com>
Subject: [PATCH v4 1/7] kvm: x86/pmu: Correct the mask used in a pmu event
 filter lookup
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When checking if a pmu event the guest is attempting to program should
be filtered, only consider the event select + unit mask in that
decision. Use an architecture specific mask to mask out all other bits,
including bits 35:32 on Intel.  Those bits are not part of the event
select and should not be considered in that decision.

Fixes: 66bb8a065f5a ("KVM: x86: PMU Event Filter")
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/include/asm/kvm-x86-pmu-ops.h |  1 +
 arch/x86/kvm/pmu.c                     | 15 ++++++++++++++-
 arch/x86/kvm/pmu.h                     |  1 +
 arch/x86/kvm/svm/pmu.c                 |  6 ++++++
 arch/x86/kvm/vmx/pmu_intel.c           |  6 ++++++
 5 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
index c17e3e96fc1d..e0280cc3e6e4 100644
--- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
+++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
@@ -24,6 +24,7 @@ KVM_X86_PMU_OP(set_msr)
 KVM_X86_PMU_OP(refresh)
 KVM_X86_PMU_OP(init)
 KVM_X86_PMU_OP(reset)
+KVM_X86_PMU_OP(get_eventsel_event_mask)
 KVM_X86_PMU_OP_OPTIONAL(deliver_pmi)
 KVM_X86_PMU_OP_OPTIONAL(cleanup)
 
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 02f9e4f245bd..98f383789579 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -247,6 +247,19 @@ static int cmp_u64(const void *pa, const void *pb)
 	return (a > b) - (a < b);
 }
 
+static inline u64 get_event_select(u64 eventsel)
+{
+	return eventsel & static_call(kvm_x86_pmu_get_eventsel_event_mask)();
+}
+
+static inline u64 get_raw_event(u64 eventsel)
+{
+	u64 event_select = get_event_select(eventsel);
+	u64 unit_mask = eventsel & ARCH_PERFMON_EVENTSEL_UMASK;
+
+	return event_select | unit_mask;
+}
+
 static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu_event_filter *filter;
@@ -263,7 +276,7 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 		goto out;
 
 	if (pmc_is_gp(pmc)) {
-		key = pmc->eventsel & AMD64_RAW_EVENT_MASK_NB;
+		key = get_raw_event(pmc->eventsel);
 		if (bsearch(&key, filter->events, filter->nevents,
 			    sizeof(__u64), cmp_u64))
 			allow_event = filter->action == KVM_PMU_EVENT_ALLOW;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 5cc5721f260b..4e22f9f55400 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -40,6 +40,7 @@ struct kvm_pmu_ops {
 	void (*reset)(struct kvm_vcpu *vcpu);
 	void (*deliver_pmi)(struct kvm_vcpu *vcpu);
 	void (*cleanup)(struct kvm_vcpu *vcpu);
+	u64 (*get_eventsel_event_mask)(void);
 };
 
 void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index f24613a108c5..0b35eb04aa60 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -294,6 +294,11 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 	}
 }
 
+static u64 amd_pmu_get_eventsel_event_mask(void)
+{
+	return AMD64_EVENTSEL_EVENT;
+}
+
 struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.hw_event_available = amd_hw_event_available,
 	.pmc_is_enabled = amd_pmc_is_enabled,
@@ -307,4 +312,5 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.refresh = amd_pmu_refresh,
 	.init = amd_pmu_init,
 	.reset = amd_pmu_reset,
+	.get_eventsel_event_mask = amd_pmu_get_eventsel_event_mask,
 };
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index c399637a3a79..0aec7576af0c 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -793,6 +793,11 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
 	}
 }
 
+static u64 intel_pmu_get_eventsel_event_mask(void)
+{
+	return ARCH_PERFMON_EVENTSEL_EVENT;
+}
+
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.hw_event_available = intel_hw_event_available,
 	.pmc_is_enabled = intel_pmc_is_enabled,
@@ -808,4 +813,5 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.reset = intel_pmu_reset,
 	.deliver_pmi = intel_pmu_deliver_pmi,
 	.cleanup = intel_pmu_cleanup,
+	.get_eventsel_event_mask = intel_pmu_get_eventsel_event_mask,
 };
-- 
2.37.2.672.g94769d06f0-goog

