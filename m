Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 726B75BEC38
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 19:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbiITRqm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 13:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbiITRqb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 13:46:31 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94BE6E2FC
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 10:46:21 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id r7-20020a632047000000b00439d0709849so2018768pgm.22
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 10:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=NAsanB3vQZ9bxau0wNd4LNIEqMiagw1T0WlwtZnZHTU=;
        b=XC0thiMB5FsALg+OeNvHlun/06tzsqnfvJKdO71xUaFmtGFcYNCKDwHSEe2YzAVLYt
         jCJ+RHyyCpefOJ2CmivtrKzITGDHW6dOxovASVDIh+Eacbr+O2L8VXH6fYuPgcWYqpev
         ojzKiWX30AzRsjTyUcSLPOh9etoEkVg8Ne0dSyT9GGCL4yzzCqcw47KYYhV3gTCG8LnL
         cD7YZfLIuf20qOS5Bkzhokjq/SORu9KP07jeNK7szCbvx0kGHGd3Y3AmiPF16HocJyNr
         c1XI7JDq05upJEO+G5W90Fk8kpldiBVpZ6wvsVoV4zvh1fKPtJvfGQxHYygBbg6HjJIS
         FT6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=NAsanB3vQZ9bxau0wNd4LNIEqMiagw1T0WlwtZnZHTU=;
        b=FNjK82yZOESuuOwaIEVW3IHEc4xJWjtyv76srOfk8t95LAV0bDCaRBxWo6GVLiQ45p
         9Lv64SuF/MpksTr+0skRNnJd1Xqkqkt39S72+PYNQm1POIKxdY500t54P/ebdxBsu4jM
         iTQfnIMVYvJRSpJb/47W/6P+5/1VptxUhWBKrBgDvxFJLwfbzIFEABZD0CaDCMut/63d
         uKSqawZemPzLcmJoLvvK1Qr/SJDxgQ+JM9UsR0h0LSUmK10/WKQblC4I6Am7U69g4HUU
         dmSV7A/n+i+jNRM9IKTfkh6WesSOgaDWfluKcB9IPFpwII/+Z3WOTiFdvIARKE5uXyTt
         jh7A==
X-Gm-Message-State: ACrzQf2u6uysOVamF56U/5jbiCGx834GuBRT+zZaRqp9O9AlXhsJXQN6
        aaZUl5oewDMRxtnP91tMWWGYi7iTmjsUI0+LWn9X6XF9WoQCRW11IhnegOodd6Ipisuh9WCQrOo
        /FSzNwNdlDVctbNvFKRRS37hoV7vkgYv1v8CsBt+k6HKNFYVB8tNl6nV/sirct2BCrlrz
X-Google-Smtp-Source: AMsMyM7F3HppuLSoB4Z3gcLLTUySQmruLmJkpozrmthy5/4PlNSBwSw3yiLIQ0PMocmLyC5Y150ClwXkOUSbqCwO
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a62:fb18:0:b0:548:9dff:89da with SMTP
 id x24-20020a62fb18000000b005489dff89damr25175324pfm.23.1663695981188; Tue,
 20 Sep 2022 10:46:21 -0700 (PDT)
Date:   Tue, 20 Sep 2022 17:46:02 +0000
In-Reply-To: <20220920174603.302510-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220920174603.302510-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920174603.302510-7-aaronlewis@google.com>
Subject: [PATCH v5 6/7] selftests: kvm/x86: Add testing for KVM_SET_PMU_EVENT_FILTER
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

Test that masked events are not using invalid bits, and if they are,
ensure the pmu event filter is not accepted by KVM_SET_PMU_EVENT_FILTER.
The only valid bits that can be used for masked events are set when
using KVM_PMU_EVENT_ENCODE_MASKED_EVENT() with one exception: If any
of the high bits (11:8) of the event select are set when using Intel,
the PMU event filter will fail.

Also, because validation was not being done prior to the introduction
of masked events, only expect validation to fail when masked events
are used.  E.g. in the first test a filter event with all its bits set
is accepted by KVM_SET_PMU_EVENT_FILTER when flags = 0.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../kvm/x86_64/pmu_event_filter_test.c        | 36 +++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index bd7054a53981..0750e2fa7a38 100644
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
@@ -452,6 +485,7 @@ int main(int argc, char *argv[])
 	setbuf(stdout, NULL);
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_PMU_EVENT_FILTER));
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_PMU_EVENT_MASKED_EVENTS));
 
 	TEST_REQUIRE(use_intel_pmu() || use_amd_pmu());
 	guest_code = use_intel_pmu() ? intel_guest_code : amd_guest_code;
@@ -472,6 +506,8 @@ int main(int argc, char *argv[])
 	test_not_member_deny_list(vcpu);
 	test_not_member_allow_list(vcpu);
 
+	test_filter_ioctl(vcpu);
+
 	kvm_vm_free(vm);
 
 	test_pmu_config_disable(guest_code);
-- 
2.37.3.968.ga6b4b080e4-goog

