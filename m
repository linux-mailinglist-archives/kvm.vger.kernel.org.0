Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28A7956C5AB
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 03:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiGIBSB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 21:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiGIBSA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 21:18:00 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3B87CB69
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 18:17:58 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d13-20020a170903230d00b0016c1efef9ecso163069plh.6
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 18:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SpKUYC4B8/X/ODEvGGrNRNxQbhnqpAqhDWhCr+1x2E8=;
        b=czaC4/PLOauZhhI5JFhrxIRiVh5Y10xOGWv+iQWO7vFY2DD9x/tlSBh69SthAUSLBX
         nOvD2K7X9UbbLKDhYAbQevF9KaAyeqJuZ8E/gm+nDRosKdsyfPCYYzqR3Krm9UzI6S9N
         5fsERBXGQ5jEFAs1kq+GFSXPPS1WcTfdAPhMANdTTqIn8tOPY0tJtmUDJbwfxYdcj7ME
         Pw4xAvFo2dqrO8M3wf8D2b4lHFohlthjMrEmsYAivMuqKH3pJWinSneYo5UhjD8FQUhN
         eVD54rCLOf5nuC7hbVu/qFdmodPLjT8sP+dTT7CNw1ZxFhV6QODoIrzfO645EzkmcYwa
         V/Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SpKUYC4B8/X/ODEvGGrNRNxQbhnqpAqhDWhCr+1x2E8=;
        b=f0dMu3tNO+f3c4BhTNSmXk1euVqLQiPVfunBq2nXzEoIILQi/LhThr+pPdYxssjoD6
         cROXdAGXtXz9M9uTFvjLe04HusDXs+LtYkn9HbrAK6RcLBihgSJwQ1kZ2lnF0/uOH6Pl
         YeLgKAresLqthxfy1o0Mp6xlSrjYiLE1yixnoVx/MKbMe8NAwJg3TnPcYNoIbuSxk18A
         NlLyTXCdVrhRAidSIGoEdnOc7L+eMZHf76K0Y8K6aCegsRMSWXO1spZqueBJIFVVxH1y
         77Cqt91Qn1xrT3rBJYIJ63GLIxlttLUahKlwQGEbUdPazKn9riRyJ2xVEoMW0YcLOwW8
         /NFg==
X-Gm-Message-State: AJIora809giYDCvutKdZldeHxfW2FvCch9eFssGINsdgpyKNhLiI9y91
        uPaq9CvcAuQ8/RltDA8MFNLbb2kfjG0xB0gTISGdjyiMt1mt0H8Dru4Qr7FhIlqXcBPbBEwisUp
        ht3QogCo09qzZG5UOZL456QorOXEqhPE/qYHnQxxu5NsEi4IAquAjXKFKU5WqH9dmEfLQ
X-Google-Smtp-Source: AGRyM1vOg9U0XM6BDG6KO/KXdzLoYPrQGXdpXI/CXJVVYb5qekJgcHD1GJ5sA8ArZq3RXNx1D2Q+wZbkXLm3F9ia
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a62:1891:0:b0:528:5d43:c3ab with SMTP
 id 139-20020a621891000000b005285d43c3abmr6754836pfy.79.1657329478119; Fri, 08
 Jul 2022 18:17:58 -0700 (PDT)
Date:   Sat,  9 Jul 2022 01:17:25 +0000
In-Reply-To: <20220709011726.1006267-1-aaronlewis@google.com>
Message-Id: <20220709011726.1006267-5-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220709011726.1006267-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH v3 4/5] selftests: kvm/x86: Add testing for inverted masked events
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

Add four tests for inverted masked events.

In the first two tests the guest event matches the masked event *and*
the inverted masked event.  That causes the guest event to not be
filtered.  Matching the inverted event negates the original match.  As
a result it behaves as if it was not filtered.  So, for an allow list
the guest event will not be programmed in the PMU, and for a deny list
it will.

In the second two tests the opposite happens.  The inverted masked
events do not match the guest event, but it does match the masked
event.  As a result they are both filtered.  For the allow list the
guest event is programmed in the PMU.  For the deny list it is not.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../kvm/x86_64/pmu_event_filter_test.c        | 69 +++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 29abe9c88f4f..95beec32d9eb 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -542,6 +542,74 @@ static void test_masked_events(struct kvm_vm *vm)
 	run_masked_events_tests(vm, masked_events, nmasked_events, event);
 }
 
+static uint64_t run_inverted_masked_events_test(struct kvm_vm *vm,
+						uint64_t masked_events[],
+						const int nmasked_events,
+						uint32_t action)
+{
+	struct kvm_pmu_event_filter *f;
+	uint64_t count;
+
+	f = create_pmu_event_filter(masked_events, nmasked_events, action,
+				    KVM_PMU_EVENT_FLAG_MASKED_EVENTS);
+	count = test_with_filter(vm, f);
+	free(f);
+
+	return count;
+}
+
+static void test_inverted_masked_events(struct kvm_vm *vm)
+{
+	uint64_t masked_events[] = {
+		/*
+		 * Force the guest's unit mask to match the inverted masked
+		 * event by setting the match to the only valid unit mask
+		 * possible (0).
+		 * ie: guest_unit_mask & 0xff == 0.
+		 */
+		ENCODE_MASKED_EVENT(AMD_ZEN_BR_RETIRED, ~0x00, 0, 1),
+		ENCODE_MASKED_EVENT(INTEL_BR_RETIRED, ~0x00, 0, 1),
+		/*
+		 * Set the masked events to match any unit mask.
+		 * ie: guest_unit_mask & 0 == 0.
+		 */
+		ENCODE_MASKED_EVENT(AMD_ZEN_BR_RETIRED, 0, 0, 0),
+		ENCODE_MASKED_EVENT(INTEL_BR_RETIRED, 0, 0, 0),
+	};
+	const int nmasked_events = ARRAY_SIZE(masked_events);
+	uint64_t count;
+
+	count = run_inverted_masked_events_test(vm, masked_events,
+						nmasked_events,
+						KVM_PMU_EVENT_ALLOW);
+	expect_failure(count);
+
+	count = run_inverted_masked_events_test(vm, masked_events,
+						nmasked_events,
+						KVM_PMU_EVENT_DENY);
+	expect_success(count);
+
+	/*
+	 * Force the guest's unit mask to *not* match the inverted masked
+	 * event by setting the match to an invalid unit mask (1).
+	 * ie: guest_unit_mask & 0xff == 1.
+	 */
+	masked_events[0] =
+		ENCODE_MASKED_EVENT(AMD_ZEN_BR_RETIRED, ~0x00, 1, 1);
+	masked_events[1] =
+		ENCODE_MASKED_EVENT(INTEL_BR_RETIRED, ~0x00, 1, 1);
+
+	count = run_inverted_masked_events_test(vm, masked_events,
+						nmasked_events,
+						KVM_PMU_EVENT_ALLOW);
+	expect_success(count);
+
+	count = run_inverted_masked_events_test(vm, masked_events,
+						nmasked_events,
+						KVM_PMU_EVENT_DENY);
+	expect_failure(count);
+}
+
 int main(int argc, char *argv[])
 {
 	void (*guest_code)(void) = NULL;
@@ -587,6 +655,7 @@ int main(int argc, char *argv[])
 	test_not_member_allow_list(vm);
 
 	test_masked_events(vm);
+	test_inverted_masked_events(vm);
 
 	kvm_vm_free(vm);
 
-- 
2.37.0.144.g8ac04bfd2-goog

