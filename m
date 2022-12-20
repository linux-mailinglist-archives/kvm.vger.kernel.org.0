Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBDB2652472
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 17:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233993AbiLTQNC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 11:13:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233972AbiLTQMz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 11:12:55 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473051AA36
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 08:12:55 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id nb2-20020a17090b35c200b00221433a393dso5411495pjb.5
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 08:12:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7BUmsvG+cvgMmEmZkdEtI/fD7B2MntECYD+/XsbliQE=;
        b=kgo/nDqp7z5QnRlLq+v/GPi4oDzfocdNMMQjF6Lag//khD6BTpLOD9mMt4MyMLKtNa
         7xnzWFWPZ17YZFlZPDmh6kSD1HTkKsDFhebD91B1JU0jg1TJJirLAfWIUnHa0RlJxxSH
         slYcjVperssE4R/Jl5iVM5tZEI2vq4bBfg/ULOMgYw9oUiRuxmvs7frYhlsC2LC6geuG
         eCvS7gDBfp+Kv/qKJpfHhGcHeU164BbcF6ubkHi61rznhKXMR6H/X4eANiJboZ7iWF+d
         5lo92UAjIvXKm1FKrBAuAKdyeNniAfh+L06GiXI1/WteZcxF5FeByTr1m0JbyFFOpRh2
         yWqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7BUmsvG+cvgMmEmZkdEtI/fD7B2MntECYD+/XsbliQE=;
        b=zlE5C6fIRBfln9a5L3L6Dqoz9NOalNlrFmO1bnedDbDWkZW9fAO7ygl5z/nhxy0vfQ
         o5XRZl1roUCMZTTf6RVAbjffpJMg8bsPEF8t/g2DfRirvHrN1DOkPLU5uiZSENvBp/Gp
         FDY6bYBmphCh3V30xPPynTX6zI6rSgsZh7glXHAZ9E+wmfvLBmwx5oYpxgZPup7hWSLG
         N2BvXbr/GBXGdI/VGAPFqRGoPVsdiKWAMgbiTD1jR0KH4sk5u6iRUqqEzFix3i9YqOB7
         ZDoueBLDuavVtfNjI0YniBLV1elh2lDOGxOZQriWu+cHFpBqXH75ZAm3ETN4AZAALiiK
         PJ8A==
X-Gm-Message-State: ANoB5pnzWRnZQxH7HjrKnrB8Qd48lux2ZzYHCgwTwEJZ6ZaQTBc3EpWi
        USLVmHoO0oRBERxugTHL7e78fgLK8xcnj+NJgEbJNP4HCA8P4V8/7xLrWSHQ5UqXE5gUESfc6gC
        ASKJ9LT2zdHERK6e9P1SDX9+pjU0sltD3fCDG5MHwv38HGM8u35+WQRMT7KtoeE1h22yS
X-Google-Smtp-Source: AA0mqf4y6HCK/NnTC3I4g6BALTgerqHRWXsCFO4jydfdczGHYnhSZlZs1UNQ6wyRrdRGaPm+LpisBX6NP98KGCva
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:903:192:b0:189:ab7f:7f40 with SMTP
 id z18-20020a170903019200b00189ab7f7f40mr40871781plg.145.1671552774744; Tue,
 20 Dec 2022 08:12:54 -0800 (PST)
Date:   Tue, 20 Dec 2022 16:12:35 +0000
In-Reply-To: <20221220161236.555143-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221220161236.555143-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221220161236.555143-7-aaronlewis@google.com>
Subject: [PATCH v8 6/7] selftests: kvm/x86: Add testing for KVM_SET_PMU_EVENT_FILTER
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

Test that masked events are not using invalid bits, and if they are,
ensure the pmu event filter is not accepted by KVM_SET_PMU_EVENT_FILTER.
The only valid bits that can be used for masked events are set when
using KVM_PMU_ENCODE_MASKED_ENTRY() with one exception: If any of the
high bits (35:32) of the event select are set when using Intel, the pmu
event filter will fail.

Also, because validation was not being done prior to the introduction
of masked events, only expect validation to fail when masked events
are used.  E.g. in the first test a filter event with all its bits set
is accepted by KVM_SET_PMU_EVENT_FILTER when flags = 0.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../kvm/x86_64/pmu_event_filter_test.c        | 36 +++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index d50c8c160658..a96830243195 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -404,6 +404,39 @@ static bool use_amd_pmu(void)
 		 is_zen3(family, model));
 }
 
+static int run_filter_test(struct kvm_vcpu *vcpu, const uint64_t *events,
+			   int nevents, uint32_t flags)
+{
+	struct kvm_pmu_event_filter *f;
+	int r;
+
+	f = create_pmu_event_filter(events, nevents, KVM_PMU_EVENT_ALLOW, flags);
+	r = __vm_ioctl(vcpu->vm, KVM_SET_PMU_EVENT_FILTER, f);
+	free(f);
+
+	return r;
+}
+
+static void test_filter_ioctl(struct kvm_vcpu *vcpu)
+{
+	uint64_t e = ~0ul;
+	int r;
+
+	/*
+	 * Unfortunately having invalid bits set in event data is expected to
+	 * pass when flags == 0 (bits other than eventsel+umask).
+	 */
+	r = run_filter_test(vcpu, &e, 1, 0);
+	TEST_ASSERT(r == 0, "Valid PMU Event Filter is failing");
+
+	r = run_filter_test(vcpu, &e, 1, KVM_PMU_EVENT_FLAG_MASKED_EVENTS);
+	TEST_ASSERT(r != 0, "Invalid PMU Event Filter is expected to fail");
+
+	e = KVM_PMU_EVENT_ENCODE_MASKED_ENTRY(0xff, 0xff, 0xff, 0xf);
+	r = run_filter_test(vcpu, &e, 1, KVM_PMU_EVENT_FLAG_MASKED_EVENTS);
+	TEST_ASSERT(r == 0, "Valid PMU Event Filter is failing");
+}
+
 int main(int argc, char *argv[])
 {
 	void (*guest_code)(void);
@@ -411,6 +444,7 @@ int main(int argc, char *argv[])
 	struct kvm_vm *vm;
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_PMU_EVENT_FILTER));
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_PMU_EVENT_MASKED_EVENTS));
 
 	TEST_REQUIRE(use_intel_pmu() || use_amd_pmu());
 	guest_code = use_intel_pmu() ? intel_guest_code : amd_guest_code;
@@ -431,6 +465,8 @@ int main(int argc, char *argv[])
 	test_not_member_deny_list(vcpu);
 	test_not_member_allow_list(vcpu);
 
+	test_filter_ioctl(vcpu);
+
 	kvm_vm_free(vm);
 
 	test_pmu_config_disable(guest_code);
-- 
2.39.0.314.g84b9a713c41-goog

