Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1773A608049
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 22:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiJUUv3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 16:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiJUUvX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 16:51:23 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF08F07E0
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 13:51:22 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id t4-20020a635344000000b0045fe7baa222so1856754pgl.13
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 13:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VUFds0jvnwBKnCvVY61O6n/XoqIGuG9X/fm2+lv1bqQ=;
        b=pU3JuqQd2kEKrJmQLFXUq6z5h3Pse28HUl8KSb11W6On0S9Q5UY4X3zSepKt5Oso/0
         /1dzdipdqR4qM5qWufEUaqqyzLeTrNRGxxkWFUMLDpM9nGLzTxMgOIXYY6pWEmNpM6LD
         PpmKK2BIlqVpnoeUbaQLzQe7SDQZaNkB94mbjRkm7s5lpBXelV5v8x5i0gWBsQqGj/kM
         r34ha+pNcbx5vapGbdiYGJuJLPNjiCfZEed0uBjsunqLXiPGuAby9DV0FFh4rsSzyixh
         PJJex0C3GEY8Q7f0/KWd+Q9z+L76T7quD7IbCCTPJl4BNs5G+bvGgbTykEUqeZ7Vrxz/
         lQqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VUFds0jvnwBKnCvVY61O6n/XoqIGuG9X/fm2+lv1bqQ=;
        b=kT5j1OM7c7qbsMWKIGtFu+Kk0glDrAgQdhaz59mYkRUchDVJflK/3GdTW046PbDtEH
         uYX+w+DiZk9Nx54kBFTCeMk8WH5eGeqwrF5MABnUWrBcURgSrKZA7qM+GywxEQ4J2WHw
         GXSdmCzHoTPthE+5fcVky6JfSHGwgXlSzcctX95tAPER3bJCbU5WxY2SUbvv7ziDEkNB
         e3tABmAn9/3agUZl2H0qjlznEyplz/KLkqVnhQn1mbWj957zscD6vwsqWC6N/s1M0PCz
         Rx/BSTv47zmZfmaiDfACHDS+7sMBIW2Swt8D05Jz9dmU6R9P/6agTHOQajUkCRMjzddq
         hltw==
X-Gm-Message-State: ACrzQf0VmSDI+/GKdrdsQ/kXrro+e6LETM2XWiEzuMAtPdoVD+ysG5N/
        3LmDk09zWE/txaNxwTK9Zd0shqGAQB6GoKC46w7wBmh7BUAAY92KQGSiRSbaY8PYrES1VB1lsg9
        z26izD9eDRZMHTlE+yP9eqGF5Q1p9rK7XRpSomk6otMXW1VPrADUmPRcRmiwRBXXmMyEz
X-Google-Smtp-Source: AMsMyM4ZEnA8OKYk1KMJpuvrvqk3/jessUbLxMslTKuFEjktXwWqhWxwM/JhMiSC/cApAdsv2YQerq7D2NIrygVt
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90b:2705:b0:20a:b4fa:f624 with SMTP
 id px5-20020a17090b270500b0020ab4faf624mr24192523pjb.124.1666385481837; Fri,
 21 Oct 2022 13:51:21 -0700 (PDT)
Date:   Fri, 21 Oct 2022 20:51:01 +0000
In-Reply-To: <20221021205105.1621014-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221021205105.1621014-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
Message-ID: <20221021205105.1621014-4-aaronlewis@google.com>
Subject: [PATCH v6 3/7] kvm: x86/pmu: prepare the pmu event filter for masked events
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

Refactor check_pmu_event_filter() in preparation for masked events.

No functional changes intended

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/pmu.c | 56 +++++++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index a79f0d5ecaf0..64172e082404 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -257,41 +257,51 @@ static int cmp_u64(const void *pa, const void *pb)
 	return (a > b) - (a < b);
 }
 
+static u64 *find_filter_entry(struct kvm_pmu_event_filter *filter, u64 key)
+{
+	return bsearch(&key, filter->events, filter->nevents,
+		       sizeof(filter->events[0]), cmp_u64);
+}
+
+static bool is_gp_event_allowed(struct kvm_pmu_event_filter *filter, u64 eventsel)
+{
+	if (find_filter_entry(filter, eventsel & (kvm_pmu_ops.EVENTSEL_EVENT |
+						  ARCH_PERFMON_EVENTSEL_UMASK)))
+		return filter->action == KVM_PMU_EVENT_ALLOW;
+
+	return filter->action == KVM_PMU_EVENT_DENY;
+}
+
+static bool is_fixed_event_allowed(struct kvm_pmu_event_filter *filter, int idx)
+{
+	int fixed_idx = idx - INTEL_PMC_IDX_FIXED;
+
+	if (filter->action == KVM_PMU_EVENT_DENY &&
+	    test_bit(fixed_idx, (ulong *)&filter->fixed_counter_bitmap))
+		return false;
+	if (filter->action == KVM_PMU_EVENT_ALLOW &&
+	    !test_bit(fixed_idx, (ulong *)&filter->fixed_counter_bitmap))
+		return false;
+
+	return true;
+}
+
 static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu_event_filter *filter;
 	struct kvm *kvm = pmc->vcpu->kvm;
-	bool allow_event = true;
-	__u64 key;
-	int idx;
 
 	if (!static_call(kvm_x86_pmu_hw_event_available)(pmc))
 		return false;
 
 	filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
 	if (!filter)
-		goto out;
+		return true;
 
-	if (pmc_is_gp(pmc)) {
-		key = pmc->eventsel & (kvm_pmu_ops.EVENTSEL_EVENT |
-				       ARCH_PERFMON_EVENTSEL_UMASK);
-		if (bsearch(&key, filter->events, filter->nevents,
-			    sizeof(__u64), cmp_u64))
-			allow_event = filter->action == KVM_PMU_EVENT_ALLOW;
-		else
-			allow_event = filter->action == KVM_PMU_EVENT_DENY;
-	} else {
-		idx = pmc->idx - INTEL_PMC_IDX_FIXED;
-		if (filter->action == KVM_PMU_EVENT_DENY &&
-		    test_bit(idx, (ulong *)&filter->fixed_counter_bitmap))
-			allow_event = false;
-		if (filter->action == KVM_PMU_EVENT_ALLOW &&
-		    !test_bit(idx, (ulong *)&filter->fixed_counter_bitmap))
-			allow_event = false;
-	}
+	if (pmc_is_gp(pmc))
+		return is_gp_event_allowed(filter, pmc->eventsel);
 
-out:
-	return allow_event;
+	return is_fixed_event_allowed(filter, pmc->idx);
 }
 
 void reprogram_counter(struct kvm_pmc *pmc)
-- 
2.38.0.135.g90850a2211-goog

