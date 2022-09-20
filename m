Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06C45BEC35
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 19:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbiITRqc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 13:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbiITRqO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 13:46:14 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FC361D6B
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 10:46:13 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id l2-20020a170902f68200b00177ee7e673eso2150583plg.2
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 10:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=0WKAUbzNduZWcQJDezq4mULZL7u8oBPWqooVtCo8CZo=;
        b=A4m9DEiDwnvT35knwdn96mrLfnhdr8IqH1Wz7qdVwQ6c/QFvXHnZgonGhYMP6O8X+u
         5NPzpgdG3pQhe/5V0GspJUNuM35yTvzj03jM0sH9XjEyNfA0hVThtC0lI0yy4TxIzfmL
         hGn9sYNeiDy8ZY0qZ2BebmkQqqkd8lZwbRufWv9do1Jcfzi9TKA3UiHmy/r0vLdm8NPP
         /0pt4U/0ZHbKpt5Dfnn+bPHBZmWdVbwT5qj05R+Zh5jW1XsKdOc6UJz/cGFJXoNiOT6T
         ix3M80gUwR2yOshtpISNWZkoHXtvm7RKN//klh1THIrDiPb7k1MRQKr8/yCNHvmWSWPN
         Yo8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=0WKAUbzNduZWcQJDezq4mULZL7u8oBPWqooVtCo8CZo=;
        b=OpAFBA+mAMY9E/aJYDsKNS1qmBugeP7rPro0DhP+AuKrySYhRBQ6AB2WStayH+tmHK
         zZMHUmpYekAGdsDBk2y84tyS3Y7pszuMF3tWr5ZG+ILs+MKbW/bvV2/U4o8UeEMcB1lG
         fmw4mECiZ3llxVwUULwkEgs7GLeFCG7iNrERnJNKmFemPfzCUzuZ9FR1xxwKo39s2yoT
         dtkMdHTqnllM3Tvk0xzQKrHuIiuC1YBK/Ksc7la8ul/X4wNGuQDFMIgVf7rb16k3ePzg
         X0S2PbLglxmRGlWTW96xxPLUkzs9EgeSGz6QXrpUtGARKjpbmpEv9/iK/3S0AejH7k8C
         A3Tg==
X-Gm-Message-State: ACrzQf34KKeBzEVySVq6w5EEwNhSIFPLujWwoCOSX08QmK1+BS2KiIqp
        Qq3F1HXzartu77PFcUZe2A/KgASRxiXE0jUCrMlqkQKk0KboKiMxRMkKdBk2/8wSJogpsQ0Y1MD
        1IQEDb21HbmpyUOnPWYk+fza7IeZ83Vw3ySZOTTk1qVSFcU/9FzZUtZALu+VKiHCzC5qU
X-Google-Smtp-Source: AMsMyM69ZGC3J4oPv+AapS4/k4CR/6UMRz23k3sl6qAhn4mplsg/x4HptQai9OIunmyslzAW5g/Bv1RxTqTqoL5P
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a63:8a4a:0:b0:439:49b3:6586 with SMTP
 id y71-20020a638a4a000000b0043949b36586mr21140378pgd.44.1663695972606; Tue,
 20 Sep 2022 10:46:12 -0700 (PDT)
Date:   Tue, 20 Sep 2022 17:45:57 +0000
In-Reply-To: <20220920174603.302510-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220920174603.302510-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920174603.302510-2-aaronlewis@google.com>
Subject: [PATCH v5 1/7] kvm: x86/pmu: Correct the mask used in a pmu event
 filter lookup
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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
Reviewed-by: Jim Mattson <jmattson@google.com>
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
2.37.3.968.ga6b4b080e4-goog

