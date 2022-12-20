Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBC365246D
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 17:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbiLTQNB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 11:13:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233927AbiLTQMz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 11:12:55 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B691D1ADA0
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 08:12:53 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id o5-20020a170903210500b0018f9edbba6eso9379150ple.11
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 08:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kcooLlYptNqSV36Ac6pCN6HPdHuTD5deegfKpT4i+us=;
        b=XxJLMc3F9e8kCCalLcEoGf6S1KJQ3vUPdm7T5xy1kaIKlog6ITHpPb+NDuqsMhV3PC
         /uap4dHWsC7zUd44AsWXNx8igkT3TT17lCtqVvzK57dwoUtGzCO7OsESgMpM8s+qvhNZ
         bsO9vYgmEjnq9a16v7eEfhM06aobtPxIRZYd5q87yDxc7Gg/WnO6TQpTZAt0yp6hQ+kp
         1Jtv3xyhgIFZgHxUG9CYV2U8GxhE8tvmuzYXHN39saJbVqkWFqcLv7vfif2QkVo81rsN
         JG8ezRhLqFj7gyIMpx3MXVG4NgBUBMxIyhMypCc0tghL/9vDdkMIqnpBB5k9TuBL6613
         lvCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kcooLlYptNqSV36Ac6pCN6HPdHuTD5deegfKpT4i+us=;
        b=yujwdvdn4KecwXliUyRrbAP78xiCCQzPXF0XFg3e0EHMQIi8Ea7cZpks4R/OEXN+E6
         pAL5xd1XaQoXU9ZWVADd5T4TpiZToQ0EZB3ZCKS84r//DC5PF2wzvxqMFg9wV0GDCHSd
         mS78SoeFAp9Ie4OB0NCQFgpfCin+cnx/H79RC8prcbke0MmgOF1FPQte+DD7+S/sT+io
         0rdWlhkfoK6k19z6GuQgksMYiI09rb3IGLPfJ5AxLrAawhXq2k4rQeWdrvlOFV2QxqEr
         TnuV9P5vNgZiRaw+MbYxOk9yQJQXg60vDJMsNi5jzdWKEBDYm3b36ZCAxy+b3U4HUX4h
         eZTg==
X-Gm-Message-State: ANoB5pmwVDg9cGT+r657LuzItHYGAxpYhmN5bYi5fQWdQA+MAUULZAGj
        Mpl8ARnkb0oBHej75PzDLguEYGCeU2eQG69y8xlntvdRZLUreA7BVA7EhOhX7AboocGx9V7nz8S
        rB3vjvSAe+IjNEEwdSGhvi1aAmHR2bpYNW2rZ4ALAJAKyS8+UdGRvhD4Z1UqzeQCSYBsj
X-Google-Smtp-Source: AA0mqf5RoArpprLewLqaswft0KxAW2drVJe0bjz1dbX7VlqOgTTfiEhspL2R2ngA9AoYInw+xtBWFeulO7sqbbtU
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a62:1acb:0:b0:578:776b:eb88 with SMTP
 id a194-20020a621acb000000b00578776beb88mr2435059pfa.77.1671552773077; Tue,
 20 Dec 2022 08:12:53 -0800 (PST)
Date:   Tue, 20 Dec 2022 16:12:34 +0000
In-Reply-To: <20221220161236.555143-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221220161236.555143-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221220161236.555143-6-aaronlewis@google.com>
Subject: [PATCH v8 5/7] selftests: kvm/x86: Add flags when creating a pmu
 event filter
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

Now that the flags field can be non-zero, pass it in when creating a
pmu event filter.

This is needed in preparation for testing masked events.

No functional change intended.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../testing/selftests/kvm/x86_64/pmu_event_filter_test.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 2de98fce7edd..d50c8c160658 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -198,14 +198,15 @@ static struct kvm_pmu_event_filter *alloc_pmu_event_filter(uint32_t nevents)
 
 
 static struct kvm_pmu_event_filter *
-create_pmu_event_filter(const uint64_t event_list[],
-			int nevents, uint32_t action)
+create_pmu_event_filter(const uint64_t event_list[], int nevents,
+			uint32_t action, uint32_t flags)
 {
 	struct kvm_pmu_event_filter *f;
 	int i;
 
 	f = alloc_pmu_event_filter(nevents);
 	f->action = action;
+	f->flags = flags;
 	for (i = 0; i < nevents; i++)
 		f->events[i] = event_list[i];
 
@@ -216,7 +217,7 @@ static struct kvm_pmu_event_filter *event_filter(uint32_t action)
 {
 	return create_pmu_event_filter(event_list,
 				       ARRAY_SIZE(event_list),
-				       action);
+				       action, 0);
 }
 
 /*
@@ -263,7 +264,7 @@ static void test_amd_deny_list(struct kvm_vcpu *vcpu)
 	struct kvm_pmu_event_filter *f;
 	uint64_t count;
 
-	f = create_pmu_event_filter(&event, 1, KVM_PMU_EVENT_DENY);
+	f = create_pmu_event_filter(&event, 1, KVM_PMU_EVENT_DENY, 0);
 	count = test_with_filter(vcpu, f);
 
 	free(f);
-- 
2.39.0.314.g84b9a713c41-goog

