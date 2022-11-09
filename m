Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4944D623452
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 21:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbiKIUO4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 15:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbiKIUOy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 15:14:54 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410701DF16
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 12:14:54 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id i8-20020a170902c94800b0018712ccd6bbso13959256pla.1
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 12:14:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9HIjSNn8JrbS4AFswlYT8b67KcklXVdBva5hU128egg=;
        b=R993WIRfCzkTUEK91Jxl4SK1PgV9Zt7Tz43vqIFVARj50xXtadivCbhUaiTQwjK7xU
         gHhqvr9Tl+NTefV/ZgvHJlCnUsagRiNNLcI143Q698KJokL8aI0SKPI41qBe3JtbaRZN
         UAU38toSr86qMs8NDRNSJS5T8moS6rS1nVMsfic6IlhgdFiUtQVy/O06/B+D0nvCFxN/
         ezeqsXfI7sH2aWiomUT3itNuXMNVMGOBarD6c0DnkNBT5qc23Rpq8Y9ILw2PVIeja5mN
         NXBg11Op3Jy9764e1JGc35UXRb1tf/0dJiEpqyKEusaNepsuQP++0OFqfSok5REYxzQ6
         5Gtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9HIjSNn8JrbS4AFswlYT8b67KcklXVdBva5hU128egg=;
        b=vPOr27Lx0kHgZCTDLMMYlNs5sbd2Cd1gbgv+nRcWOLaewFX7ea7DoIJFbnKo8m8Ij7
         z/vDMpgW7RNzmYB1sQ1KM2+SgDW0yuyaSS+x39WUBRfavYhrhu08jlb+J6He4X+O68bR
         CElv9i57MPM7SlXDjyzTox6IAI//HAjltippgZh6tSJ5dpIslPmLtaDoh4l5SlzrtlZx
         cuYFkuyWyf5tUuvIY4ZmXG7qZA9vVxTAzTa76TSn04BWayjiFNlUCVnMGkE/B6cxgpoC
         KeMMfk9dFslJTTm60DwcEGTvT5n7Oy5tvk8lAVR7FS3zVrJrd+OpCKJwOEYtCZTXIfDA
         6r8g==
X-Gm-Message-State: ACrzQf0xTH32pSN8W/UewLYbzXJRGDCoYQ0KlYMQyROaYVwY9ZZwYRE7
        ISunzgZBux367thUMw4N/AQ1dE4PUlnZJg0GOuS7cImmcW8IkUSpK8ADwpYj665brsBiLTWDTeQ
        Sr1zzXK+Kdo4sLNBbfjBeT3ZBmlFCYBYkyg0vFTmeDDTyM3K9BDJ2I2eWnZzbfp7idERL
X-Google-Smtp-Source: AMsMyM4+/X8dCM7fVr1Vtp2uSdhqMndqW4urN7MuduiueQ6TXqiO+WaKZnU59ZW3Iue8oMHKdIjaRpfxfiOyKmYL
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a05:6a00:1d9b:b0:562:9a93:7c91 with
 SMTP id z27-20020a056a001d9b00b005629a937c91mr1261294pfw.21.1668024893561;
 Wed, 09 Nov 2022 12:14:53 -0800 (PST)
Date:   Wed,  9 Nov 2022 20:14:40 +0000
In-Reply-To: <20221109201444.3399736-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221109201444.3399736-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221109201444.3399736-4-aaronlewis@google.com>
Subject: [PATCH v7 3/7] kvm: x86/pmu: prepare the pmu event filter for masked events
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
index 0a6ad955fc21..a98013b939e3 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -261,41 +261,51 @@ static int cmp_u64(const void *pa, const void *pb)
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
 
 static void reprogram_counter(struct kvm_pmc *pmc)
-- 
2.38.1.431.g37b22c650d-goog

