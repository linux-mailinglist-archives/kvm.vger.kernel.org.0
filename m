Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91696652471
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 17:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiLTQM4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 11:12:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233942AbiLTQMv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 11:12:51 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4911A380
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 08:12:50 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id p11-20020a17090a680b00b002233455d706so5320488pjj.4
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 08:12:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FtIHA1Drow+/V9yCfd4Q5QXogAoqlOIazwa+GIrvvZ4=;
        b=jsjOG6zPOty0MHM7BmrreB8Zt+dg3m67LOWqBOgF03puzrGVsW/KFBiA8aHcm8ThPb
         csgjCf5i/km/wEh5+/MYAlwVnmgVnBQ2LyqwKA5n79/pEtvMPzOr7/VGcSVduqpbyRNA
         HfFAMU40+Ah2a17xponmtpoelxEnH9xgtxulpQ8HI6xyee40QUVARgfubEOhKUbQDyu5
         B2XjYK+Lgd2h2NzIK++Qk/GV6Vq7vZaI5VjFAEJXnObYJofIa0W1SvK1Sd4ap1o1OVGG
         +rQhBQyOV7r3OrNmvbpOGfsXy6v8SnZBNYHlfk55mOT4Ut3447X0hc1BFYzISR5oyHCG
         YVzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FtIHA1Drow+/V9yCfd4Q5QXogAoqlOIazwa+GIrvvZ4=;
        b=izh3rsUF9voOnEoJrKQ3shDhATCaukjkglSQWuamrZ09uhqKIN2OQhzuRh64MoVieA
         Bh/InXB39PQuhsuA44lv9ZMOAi44QbcluTL4VdF3/ADIVw3krKpRF6yu0GBPQz94OB+i
         Oeea31gjHy8H9NuQ+f/4wMbEZIBH49uXMNBFBBmK9iyvPJe12mV/iLy+8wK1hkEB96Tg
         5Mywwi9TIRtMvW5MMGU39FEo1srjm5Vxx+xEVMbs9voQEVATvqvXEINK078S1pSvcj04
         CFHkVdSk0uIb6G7IRLVclSsFNpvghSCUXfCij1FidvWbApJKzbl9egMbKtciB2Q6WK9x
         BsSA==
X-Gm-Message-State: AFqh2kruP04iS/8iig4jwxJQFKDQzszwqxvGexIBWvFWb5fA4+RtQIVL
        FrLnT5v8glopaDcA1E2RMOTtiJs7CfgmuWXkvqAp5e3nSzKcuAPQVktpjwr+1vcHneCAV3f5C6c
        1ph/JMTlGAhgHdi+oLUycZU8DEGGAA2seLqLGmo5khkf+U1gVec++eNgtdGblvjnX87U9
X-Google-Smtp-Source: AMrXdXuWez+TpvqBXjV0Qjcwo+powYcD4+/V4cLKyxlvag7OTuJ1g3WZDloEN8x+66uQSbmJT/YFxrh0/+SElwGd
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90a:4701:b0:218:8398:5846 with SMTP
 id h1-20020a17090a470100b0021883985846mr2024072pjg.241.1671552770147; Tue, 20
 Dec 2022 08:12:50 -0800 (PST)
Date:   Tue, 20 Dec 2022 16:12:32 +0000
In-Reply-To: <20221220161236.555143-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221220161236.555143-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221220161236.555143-4-aaronlewis@google.com>
Subject: [PATCH v8 3/7] kvm: x86/pmu: prepare the pmu event filter for masked events
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, Aaron Lewis <aaronlewis@google.com>
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
index 51aac749cb5f..b09a43b66dbe 100644
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
2.39.0.314.g84b9a713c41-goog

