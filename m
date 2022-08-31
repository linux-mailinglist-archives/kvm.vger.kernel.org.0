Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D677F5A830E
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 18:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbiHaQVw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 12:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbiHaQVt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 12:21:49 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ACE99A9B3
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 09:21:47 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id h5-20020a636c05000000b00429fa12cb65so7313755pgc.21
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 09:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=jZbwUjWT8IWaW9LOHj2Nyt4HQlGAskS4yyeLAfv04JQ=;
        b=Q4lG2Y+FC++ZBnN3cEDbvtPTtKHWyMNlW9u56X9OI8aVd/fbBqFO+FLp1cDqmqAZYV
         gEVi06CCEPMtceHjTTiKjw8OPhctqlBfzFNm7y8YJghVa2NORiUSe0QmDF8UZUxmu92u
         KIbwO/MhSbDhho/K6gdg4csBcjM8+C+GDH2DZkNrlZ+tGItGbsYa1nV/JipIP6yKYPcy
         k12feR8Z0TRdUXp8wQc1mhw17GCoXWg5LN7+ZG7EbGDAVLH+qSrQKYQdNLOSLTjvt82A
         Bw0lliiXOffPucTbxwEkrxv4fZO+OHJEa6f64p92t/TwHfdjYeO2wJA5NQpY0x+1bycp
         mEWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=jZbwUjWT8IWaW9LOHj2Nyt4HQlGAskS4yyeLAfv04JQ=;
        b=AYFvfVhLqZ7fvX54hEQMxVKN56iGlrqzJfVORddQ1uQ5bRbxW5TdcrOCdSe5Z9ErQ+
         81LZUO6ij4MTSoCrMNhvfqqNgGk8C4/xRGn+p3wwD17Xcxpg7MhVzMnhHl2XdSZVGjmC
         NT2bHwSMrNsk9gBu9vlUnte/LZFeDFpwLPJk0AkRHoDj9ChsXwvjuT3Rkls4YDz4bnRx
         rzLH0rYqX9FcgZW78IYCyaJ6Q+5ZKEU/jPg+2oGvfeQhGKg8Mi+Czgkj8DLW8AIgEdp5
         /LJGSwIiMmJiYR8qE/fbIWFzT7AgXizTS6EDpl/SEvhfdi1rJ8XcxhpI7ekKssvHnV2c
         YbjA==
X-Gm-Message-State: ACgBeo13UJIy4sn9fY9bog4AcRw9PMbOAqw9lTHGcZBRnAtOdLm8R+WQ
        +whNTWQrM1+yFlTw6Dak52Wftrry3Wgjen4XAYlOEST5zE+Ek3I9/nuvrIw7uTwyoyYgAgmK6zf
        j7eByrqx/mAdBzEMKbVzIIDpUpqXeosI1QNziYPMk++VVkQCi0BWys198DWiDj/RVREGB
X-Google-Smtp-Source: AA6agR4V0Rvjz8Wun7i9r+uMUvoSoNeWSbEEHY/JxQotoN5KYseBZINkRA667b1S4w8MbnWH8KoLIYfVW6NHk3Gg
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:6ac8:b0:175:44b5:5264 with SMTP
 id i8-20020a1709026ac800b0017544b55264mr3475728plt.19.1661962906246; Wed, 31
 Aug 2022 09:21:46 -0700 (PDT)
Date:   Wed, 31 Aug 2022 16:21:22 +0000
In-Reply-To: <20220831162124.947028-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220831162124.947028-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831162124.947028-6-aaronlewis@google.com>
Subject: [PATCH v4 5/7] selftests: kvm/x86: Add flags when creating a pmu
 event filter
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

Now that the flags field can be non-zero, pass it in when creating a
pmu event filter.

This is needed in preparation for testing masked events.

No functional change intended.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../testing/selftests/kvm/x86_64/pmu_event_filter_test.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index ea4e259a1e2e..bd7054a53981 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -221,14 +221,15 @@ static struct kvm_pmu_event_filter *alloc_pmu_event_filter(uint32_t nevents)
 
 
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
 
@@ -239,7 +240,7 @@ static struct kvm_pmu_event_filter *event_filter(uint32_t action)
 {
 	return create_pmu_event_filter(event_list,
 				       ARRAY_SIZE(event_list),
-				       action);
+				       action, 0);
 }
 
 /*
@@ -286,7 +287,7 @@ static void test_amd_deny_list(struct kvm_vcpu *vcpu)
 	struct kvm_pmu_event_filter *f;
 	uint64_t count;
 
-	f = create_pmu_event_filter(&event, 1, KVM_PMU_EVENT_DENY);
+	f = create_pmu_event_filter(&event, 1, KVM_PMU_EVENT_DENY, 0);
 	count = test_with_filter(vcpu, f);
 
 	free(f);
-- 
2.37.2.672.g94769d06f0-goog

