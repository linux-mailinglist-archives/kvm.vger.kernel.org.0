Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1CAA56C5AD
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 03:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiGIBSE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 21:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiGIBSC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 21:18:02 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F197CB72
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 18:18:01 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d13-20020a170903230d00b0016c1efef9ecso163124plh.6
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 18:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=sfm4dBk5MlpTuuR/go/pzRnNlq5AMilQYrAv/k/L8ik=;
        b=ZjHNXVgRonmKvjKP+rwRbOnscSdljTYb/keCmEFAa/qCWbJUWuQnoiMn0n1HtEouQT
         z4qD1I2tLqPxQlZAd5UzH+T3LxgdnPqrtT4EgYnSx8P2mfkBQhrl9fnmzYXZ685q3X2z
         FwLN7+C8OyiEA+YALDIy66/kp28lEVlTeFFbGFxmzgK3VP+/xTeFbXjFrjpqegBQX5SX
         E+15fooNX2noAU/WlaOwYwAs0lcD9ZK4yJi0EJWxDYZrLXMcKo+B1wjGslPaD4tB4btj
         0jJhFnsrd0VWaTl7QIoIwrqHJiNYQ3BFIeC4x/7dsstDqN5o5xbwJfzl8eHF38JGH3Td
         7x3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=sfm4dBk5MlpTuuR/go/pzRnNlq5AMilQYrAv/k/L8ik=;
        b=jS99mLPVd0r3O1UfhqeTSgs5Q4xH+8yiz0+o1vDcLhlQergxS8beBb+QJvjFtP8IXi
         cWL86Nelak1Wk6+zLCPzbwumsFPWY8Uu+1khvM4cSE9UukvX+avQQ0Vp3cLTbT1NHT2G
         rWInmB2s3Wp5kaKiX9VUpfQzxI95lpikh/smVWtbthJF/f/fxie1Z9r9+0oP5lgBWARk
         2pyXOPifsL4KBEVOaPXPtNntLolrozSXenyw0GHbRxlVMJD2oJdvj+sX24RszFxN8FyO
         gqrJE3BHM4fLl0OcKfcyvttNPgm/QPG83Xmevpv7WozVJkKKAO9fv+XbEAab3HvXN2ib
         MbUQ==
X-Gm-Message-State: AJIora9Qf5xOKTjQ3N0/VOsngPh5MiylHLRCzmSOIhhg+s+Im29jVJbR
        sL+HZCfqtpCiQMumGyizJ/Sc/uNyikgs0M7cplfEUGK6t8ee4NQa7+SezJHGeAzJvoHh0j1XHNk
        UrjZ1nswdzJsoGrbLMmjWzSQvWosvCh8vwDeHExUEO3bNF2TVj48gWONjDvG81enH48fz
X-Google-Smtp-Source: AGRyM1t7HHJNvIs2uFtNU53gSPOSyIcFnth03XEP53lMiEaOTByj5LM/Dt+9WV1LC81Zc+i2iAi+ZEODaZ8HWEUp
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:e5cb:b0:16a:7321:c3a1 with SMTP
 id u11-20020a170902e5cb00b0016a7321c3a1mr6239590plf.62.1657329480960; Fri, 08
 Jul 2022 18:18:00 -0700 (PDT)
Date:   Sat,  9 Jul 2022 01:17:26 +0000
In-Reply-To: <20220709011726.1006267-1-aaronlewis@google.com>
Message-Id: <20220709011726.1006267-6-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220709011726.1006267-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH v3 5/5] selftests: kvm/x86: Add testing for KVM_SET_PMU_EVENT_FILTER
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

Test that masked events are not using invalid bits, and if they are,
ensure the pmu event filter is not accepted by KVM_SET_PMU_EVENT_FILTER.
The only valid bits that can be used for masked events are set when
using KVM_PMU_EVENT_ENCODE_MASKED_EVENT() with one caveat.  If any bits
in the high nybble[1] of the eventsel for AMD are used on Intel setting
the pmu event filter with KVM_SET_PMU_EVENT_FILTER will fail.

Also, because no validation was being done on the event list prior to
the introduction of masked events, verify that this continues for the
original event type (flags == 0).  If invalid bits are set (bits other
than eventsel+umask) the pmu event filter will be accepted by
KVM_SET_PMU_EVENT_FILTER.

[1] bits 35:32 in the event and bits 11:8 in the eventsel.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../kvm/x86_64/pmu_event_filter_test.c        | 31 +++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 95beec32d9eb..344fee080c5e 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -610,6 +610,36 @@ static void test_inverted_masked_events(struct kvm_vm *vm)
 	expect_failure(count);
 }
 
+static void test_filter_ioctl(struct kvm_vm *vm)
+{
+	struct kvm_pmu_event_filter *f;
+	uint64_t e = ~0ul;
+	int r;
+
+	/*
+	 * Unfortunately having invalid bits set in event data is expected to
+	 * pass when flags == 0 (bits other than eventsel+umask).
+	 */
+	f = create_pmu_event_filter(&e, 1, KVM_PMU_EVENT_ALLOW, 0);
+	r = _vm_ioctl(vm, KVM_SET_PMU_EVENT_FILTER, (void *)f);
+	TEST_ASSERT(r == 0, "Valid PMU Event Filter is failing");
+	free(f);
+
+	f = create_pmu_event_filter(&e, 1, KVM_PMU_EVENT_ALLOW,
+				    KVM_PMU_EVENT_FLAG_MASKED_EVENTS);
+	r = _vm_ioctl(vm, KVM_SET_PMU_EVENT_FILTER, (void *)f);
+	TEST_ASSERT(r != 0, "Invalid PMU Event Filter is expected to fail");
+	free(f);
+
+	e = ENCODE_MASKED_EVENT(0xff, 0xff, 0xff, 0xf);
+
+	f = create_pmu_event_filter(&e, 1, KVM_PMU_EVENT_ALLOW,
+				    KVM_PMU_EVENT_FLAG_MASKED_EVENTS);
+	r = _vm_ioctl(vm, KVM_SET_PMU_EVENT_FILTER, (void *)f);
+	TEST_ASSERT(r == 0, "Valid PMU Event Filter is failing");
+	free(f);
+}
+
 int main(int argc, char *argv[])
 {
 	void (*guest_code)(void) = NULL;
@@ -656,6 +686,7 @@ int main(int argc, char *argv[])
 
 	test_masked_events(vm);
 	test_inverted_masked_events(vm);
+	test_filter_ioctl(vm);
 
 	kvm_vm_free(vm);
 
-- 
2.37.0.144.g8ac04bfd2-goog

