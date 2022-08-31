Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBBA75A830F
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 18:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbiHaQVx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 12:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232240AbiHaQVv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 12:21:51 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4008A1EF
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 09:21:50 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id a33-20020a630b61000000b00429d91cc649so7196532pgl.8
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 09:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=LmQz89/c7E8kUZEOsXFABtlpqeqCio5+05CLVm49q8Y=;
        b=LaZHMQzG0chq+Zp21l4bqtFpaeCySJpfMGIxbe8oCmdTuaH0vjjWIh1KHLV9H6vuix
         L1ZoR51g+NmetKJmrEhOQkbochJ4vPqcGXVZOBPX1SLJHJcxMmMa5QEFvWa6BAb2pHhH
         slOXdXOntVxTuYBB8eLViCtjpu620Mrc5SXH+LOyNLuQOT0JpctL8GVcgJj1f+BJaCBi
         f2oGeUtCw79J6QT/CzQQDQHE/S6PR1dYqCn+iDEpyXgLSmbIblduXkXBhk23RArrbkR5
         0uRX0bVkAOt1a41WDxiiS7mBXroen2u8gRm1+j1AadHyFCeH0W1O0XGAu2T6dRxTjmWQ
         gbsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=LmQz89/c7E8kUZEOsXFABtlpqeqCio5+05CLVm49q8Y=;
        b=DRh91hWZ/3++s9AtniFnnVzFNcmxmQyflWmGBzA8pMtbyL2EumDsFXvc4xn4tad5Ww
         TQInEmV3S4Ja3PQgABAMql1jhT936R6uNl4raammmZ75loXTiZnJA/AVJ9TWait2axq5
         htwZoNhK1WVflivBy8LNj4dUHEkx1fC/Cl4RTkCs+z7o1AjwPfVNuGmHA5aL9pzmiWQe
         qrxLSPtYCRxC4j1GfHF3dUwUKtxqwuY8OvSanisQzWDTR93QRsxObqWYYyPdqSG3Z05q
         fXxnr6yInmZ+qaaeR9yNv8CEGHYy/aArRpfmrvQH0gKvTT0e+fvNLRUQXpR6gcrcklXz
         esnw==
X-Gm-Message-State: ACgBeo3tXl7Tz44Q7XVKJC9o5uSk7zivtThGEWBmq4Z/TZWuQmJzoIn3
        cMUNh5+Mv7YltEKeeqqFLYY3rSWFhtpNm7A+gV3MrdkVuO34CsVO/3/jWvk0dPAGso1HT3PRZvo
        iLgQLEtzlxBVVVf4h3RN2baRPKnjJeSZPlp6RAvxggGm6/g6Pjf8rse8j9cUdOzbEDuCS
X-Google-Smtp-Source: AA6agR5FvluS8jCTVprFU/7EoOu0lAwIjq7pt8umFpFWcEAGTMWygybQmHDfDOu1mpj8MYDLMt3xbkAmot36pAOb
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90b:278a:b0:1fd:c2bf:81f5 with SMTP
 id pw10-20020a17090b278a00b001fdc2bf81f5mr4011696pjb.81.1661962909423; Wed,
 31 Aug 2022 09:21:49 -0700 (PDT)
Date:   Wed, 31 Aug 2022 16:21:23 +0000
In-Reply-To: <20220831162124.947028-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220831162124.947028-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831162124.947028-7-aaronlewis@google.com>
Subject: [PATCH v4 6/7] selftests: kvm/x86: Add testing for KVM_SET_PMU_EVENT_FILTER
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
using KVM_PMU_EVENT_ENCODE_MASKED_EVENT() with one exception: If any
of the high bits (11:8) of the event select are set when using Intel,
the PMU event filter will fail.

Also, because validation was not being done prior to the introduction
of masked events, only expect validation to fail when masked events
are used.  E.g. in the first test a filter event with all it's bits set
is accepted by KVM_SET_PMU_EVENT_FILTER when flags = 0.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../kvm/x86_64/pmu_event_filter_test.c        | 35 +++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index bd7054a53981..73a81262ca72 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -442,6 +442,39 @@ static bool use_amd_pmu(void)
 		 is_zen3(entry->eax));
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
@@ -472,6 +505,8 @@ int main(int argc, char *argv[])
 	test_not_member_deny_list(vcpu);
 	test_not_member_allow_list(vcpu);
 
+	test_filter_ioctl(vcpu);
+
 	kvm_vm_free(vm);
 
 	test_pmu_config_disable(guest_code);
-- 
2.37.2.672.g94769d06f0-goog

