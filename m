Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C3053ED44
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 19:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbiFFRxu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 13:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiFFRxr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 13:53:47 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0AB81455B3
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 10:53:45 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n201-20020a2540d2000000b0065cbae85d67so13033345yba.11
        for <kvm@vger.kernel.org>; Mon, 06 Jun 2022 10:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=QzopdMwdu4IBE2IoQwg6i1+thAJhsUz4qkuEcGV8vhw=;
        b=RSJlD7UyBwEdBbjKT5KR3abwvG1riPQmNDuFYX0ESS6oi6v6MiIUwkH0iSHV6F4Gx7
         s+hiIIonGGxyAWkgdUQN+ZuwWueh7CwKNGwweQCqprCAfupNO7dEPCWsnsQC8v5b7u4r
         WkOGv8/L3OfcWfMfgI/qtBSnb8kVvuGM+C6CFdQfmigx4qKtr9mZtMd3Bud1eHUJbdD5
         mhkiUo0irlTr7qMOclk7U7RJ0Es0zEKV29XxuwEi51cV0aec0HYDO7lsjZViNuDzoLc8
         tlhtiFRaysdZh2IfJoM+tfR5Vg0/1wKG78ot9LVW4lDVM3so/HoTt636ag448+SInS6v
         kqnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QzopdMwdu4IBE2IoQwg6i1+thAJhsUz4qkuEcGV8vhw=;
        b=iacTT5M4QhB6JqjynDVFijCQtnQ06Dv3hM9aJ1Npa4Z/7jANd6YLxnsCFHQUB7Sc1m
         axlMjI8HNa8PJhP8iXsDkVce7Wt32Dh6xEgTXfhsT4qntoSSVQoybXMUSyOchTp0rws5
         gI8YfKmbK99ZXziqNYvTcHl/KxBii+SO2NAuKrCl3MfQdJ8jn5IIsq0BYFQVtUbO1eIF
         G6RzmkVzwDeEpEyZmzjJ/YZsuC9o9wcQ16Jtryxaqe4i1p89ob8QXSLwnqzwg6wKX++L
         LTBs2e4HIU92vk05NsdG1GomJWwZDrBlfrjlC3Xoub4mjdBRNU6TIxTpqG+IpD+3MXYV
         KiUQ==
X-Gm-Message-State: AOAM530IKZaW87JGvbCG3jtGFOzeV9Isa48DmlnhZGCx14M34E5t9XD2
        jAWkfkEAnTeuBRWOO3PKFxXfqvl4jVBeaJSpdkXhJ3zbKuDPTRu3TxWeSvlg2OPq7D9EE7ml40D
        r8FXUYt1VeJsIrvTkSO/+l5YHSfpt93oWvdi2jE3S7lHD0HnW4dq3a+/obf+lzv1Z46gE
X-Google-Smtp-Source: ABdhPJwMYFZPRZpMmZNRIYdj/CgU2kELfWH50tixyku1nohz2ATY64/DpNNc7pHrTAsBYSzyrsiaWZ5JWxqNESrQ
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a25:d906:0:b0:663:aa8e:b379 with SMTP
 id q6-20020a25d906000000b00663aa8eb379mr4506341ybg.455.1654538024804; Mon, 06
 Jun 2022 10:53:44 -0700 (PDT)
Date:   Mon,  6 Jun 2022 17:52:48 +0000
In-Reply-To: <20220606175248.1884041-1-aaronlewis@google.com>
Message-Id: <20220606175248.1884041-4-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220606175248.1884041-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 3/4] selftests: kvm/x86: Add testing for masked events
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

Add testing for the pmu event filter's masked events.  These tests run
through different ways of finding an event the guest is attempting to
program in an event list.  For any given eventsel, there may be
multiple instances of it in an event list.  These tests try different
ways of looking up a match to force the matching algorithm to walk the
relevant eventsel's and ensure it is able to a) find a match, b) stays
within its bounds.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../kvm/x86_64/pmu_event_filter_test.c        | 107 ++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 4bff4c71ac45..5b0163f9ba84 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -18,8 +18,12 @@
 /*
  * In lieu of copying perf_event.h into tools...
  */
+#define ARCH_PERFMON_EVENTSEL_EVENT			0x000000FFULL
 #define ARCH_PERFMON_EVENTSEL_OS			(1ULL << 17)
 #define ARCH_PERFMON_EVENTSEL_ENABLE			(1ULL << 22)
+#define AMD64_EVENTSEL_EVENT	\
+	(ARCH_PERFMON_EVENTSEL_EVENT | (0x0FULL << 32))
+
 
 union cpuid10_eax {
 	struct {
@@ -445,6 +449,107 @@ static bool use_amd_pmu(void)
 		 is_zen3(entry->eax));
 }
 
+#define ENCODE_MASKED_EVENT(select, mask, match, invert) \
+		KVM_PMU_EVENT_ENCODE_MASKED_EVENT(select, mask, match, invert)
+
+static void expect_success(uint64_t count)
+{
+	if (count != NUM_BRANCHES)
+		pr_info("masked filter: Branch instructions retired = %lu (expected %u)\n",
+			count, NUM_BRANCHES);
+	TEST_ASSERT(count, "Allowed PMU event is not counting");
+}
+
+static void expect_failure(uint64_t count)
+{
+	if (count)
+		pr_info("masked filter: Branch instructions retired = %lu (expected 0)\n",
+			count);
+	TEST_ASSERT(!count, "Disallowed PMU Event is counting");
+}
+
+static void run_masked_filter_test(struct kvm_vm *vm, uint64_t masked_events[],
+				   const int nmasked_events, uint64_t event,
+				   uint32_t action, bool invert,
+				   void (*expected_func)(uint64_t))
+{
+	struct kvm_pmu_event_filter *f;
+	uint64_t old_event;
+	uint64_t count;
+	int i;
+
+	for (i = 0; i < nmasked_events; i++) {
+		if ((masked_events[i] & AMD64_EVENTSEL_EVENT) != EVENT(event, 0))
+			continue;
+
+		old_event = masked_events[i];
+
+		masked_events[i] =
+			ENCODE_MASKED_EVENT(event, ~0x00, 0x00, invert);
+
+		f = create_pmu_event_filter(masked_events, nmasked_events, action,
+				   KVM_PMU_EVENT_FLAG_MASKED_EVENTS);
+
+		count = test_with_filter(vm, f);
+		free(f);
+
+		expected_func(count);
+
+		masked_events[i] = old_event;
+	}
+}
+
+static void run_masked_filter_tests(struct kvm_vm *vm, uint64_t masked_events[],
+				    const int nmasked_events, uint64_t event)
+{
+	run_masked_filter_test(vm, masked_events, nmasked_events, event,
+			       KVM_PMU_EVENT_ALLOW, /*invert=*/false,
+			       expect_success);
+	run_masked_filter_test(vm, masked_events, nmasked_events, event,
+			       KVM_PMU_EVENT_ALLOW, /*invert=*/true,
+			       expect_failure);
+	run_masked_filter_test(vm, masked_events, nmasked_events, event,
+			       KVM_PMU_EVENT_DENY, /*invert=*/false,
+			       expect_failure);
+	run_masked_filter_test(vm, masked_events, nmasked_events, event,
+			       KVM_PMU_EVENT_DENY, /*invert=*/true,
+			       expect_success);
+}
+
+static void test_masked_filters(struct kvm_vm *vm)
+{
+	uint64_t masked_events[11];
+	const int nmasked_events = ARRAY_SIZE(masked_events);
+	uint64_t prev_event, event, next_event;
+	int i;
+
+	if (use_intel_pmu()) {
+		/* Instructions retired */
+		prev_event = 0xc0;
+		event = INTEL_BR_RETIRED;
+		/* Branch misses retired */
+		next_event = 0xc5;
+	} else {
+		TEST_ASSERT(use_amd_pmu(), "Unknown platform");
+		/* Retired instructions */
+		prev_event = 0xc0;
+		event = AMD_ZEN_BR_RETIRED;
+		/* Retired branch instructions mispredicted */
+		next_event = 0xc3;
+	}
+
+	for (i = 0; i < nmasked_events; i++)
+		masked_events[i] =
+			ENCODE_MASKED_EVENT(event, ~0x00, i+1, 0);
+
+	run_masked_filter_tests(vm, masked_events, nmasked_events, event);
+
+	masked_events[0] = ENCODE_MASKED_EVENT(prev_event, ~0x00, 0, 0);
+	masked_events[1] = ENCODE_MASKED_EVENT(next_event, ~0x00, 0, 0);
+
+	run_masked_filter_tests(vm, masked_events, nmasked_events, event);
+}
+
 int main(int argc, char *argv[])
 {
 	void (*guest_code)(void) = NULL;
@@ -489,6 +594,8 @@ int main(int argc, char *argv[])
 	test_not_member_deny_list(vm);
 	test_not_member_allow_list(vm);
 
+	test_masked_filters(vm);
+
 	kvm_vm_free(vm);
 
 	test_pmu_config_disable(guest_code);
-- 
2.36.1.255.ge46751e96f-goog

