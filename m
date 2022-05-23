Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C11E6531E1E
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 23:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbiEWVln (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 17:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiEWVlZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 17:41:25 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992AEAE64
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 14:41:24 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id m12-20020aa7900c000000b005183e9b0fd5so5084404pfo.23
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 14:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PXdx7JDx6ESM+Vo6+UUctX9yIlvES7xFJJg3g/ilWQk=;
        b=LMusL3HdIRqvsu8G5RLUiHOGdjMixT7zvy0AgOGAea8G6nTb2QoVsgw9oy75BBlQqn
         mlww+JH6reYXn9M1OlyRG2zYjdKWTjxLEpq9O+rj+5i+4sUF+AZzrzgLhceXZ5VECYIL
         W21HGEP4YHLs7LO2KW4KxmhQvQEoCDwlKoBXIURLLvX/d7hBEC41tPk389O7B969U2Ns
         aO3CJb6xWJL0ep/djLHeNHUT4kt4SRItwZJEgouUsC8+behjd6mRNTg9+zRrTnb3stNe
         haB7VMsKDlCyo6ROIPuPlxn7+fyqbC4SaUvX8rQMfCMZA4IRu2UUIpfaLj0JXB+wAkwL
         wHNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PXdx7JDx6ESM+Vo6+UUctX9yIlvES7xFJJg3g/ilWQk=;
        b=dPnXHuq+1kL43WQt3VcgIS2qj4PfaD4sPAIC8/iP5S9PuiE6RuUr+FXucKmbcujmOE
         ZRiKnicd0AY4fhsHYjBd3o58UOCVWXuCbMuq+JJeGI5bDSou9PYJg6ob+Zj+8fEwJtOz
         Nylvn/SV7gxIOdznvCuszB1mNwUmEtE9KI8kg3AE5qh43pg5UN6q7PNVK4rlcGHSEgij
         GpuATBNP3GNZKNgII9t1dgIWCWin5dIDM6HBMRUCN8VJCdLGLNjTasCkTOE905fBdbzN
         sDavKJhlIcJDE3IyK0enmkqbZnN7pyMHmF1aluvYrwmpI8wsSQF4ZLVUpnkZAKaJo5G1
         +FTg==
X-Gm-Message-State: AOAM530kvNf8T9V2+wtkrjxQ3c7miIb4itwQ061U3ofGBUBsM24r30tl
        HWZAcgFnuFjVLMDC8h0gLSO3h91J7r+rKt1n5biuWg1KljyHu573hNfKs+aosY7Uw4vPlOujrz5
        nwLFjfFwM47wKgYDWeExCCcuNwcJQwN4m/T8Jmg3Lcoqqz+g8vArCZ1GBVhWmneAiS5F4
X-Google-Smtp-Source: ABdhPJw5ZVNBZBm8D4Z6Z9b5F/TiQics6dpr/8JQEk0bTDpxYHq4wAWYyU4np5AiEFddxeNhsROl8Y6sfNHm9Gip
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:903:2d1:b0:156:7ceb:b56f with SMTP
 id s17-20020a17090302d100b001567cebb56fmr24291597plk.11.1653342083972; Mon,
 23 May 2022 14:41:23 -0700 (PDT)
Date:   Mon, 23 May 2022 21:41:09 +0000
In-Reply-To: <20220523214110.1282480-1-aaronlewis@google.com>
Message-Id: <20220523214110.1282480-4-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220523214110.1282480-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH 3/4] selftests: kvm/x86: Add testing for masked events
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
index 4bff4c71ac45..4071043bbe26 100644
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
+		if((masked_events[i] & AMD64_EVENTSEL_EVENT) != EVENT(event, 0))
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
2.36.1.124.g0e6072fb45-goog

