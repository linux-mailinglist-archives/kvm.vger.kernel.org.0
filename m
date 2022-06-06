Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF3B53ED43
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 19:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiFFRxt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 13:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbiFFRxp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 13:53:45 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B538F14640A
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 10:53:43 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id u8-20020a170903124800b0015195a5826cso8113608plh.4
        for <kvm@vger.kernel.org>; Mon, 06 Jun 2022 10:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=DaF9KSZ65paej3K5cVkPeneqfkvSWx8TBryPelAmSyg=;
        b=Qza6dG1LznRAnSGyPeMVwt9f989sQlODWg3K2AM4aOYAjjuOG9yEsQeZg/R9E2LmFu
         KhMzWSTA3e6ywpEm1IOoscbNkhe3IUaYaXVFHI20dQihRLdObHJ2T5LGP28LAk7aLufp
         wXaWDcP3EMSUPHsHV3H4o/lrampk67/RtBwHWC8xXkcvIw+zUHYQWJTndlVK/1RC9v4M
         /MG9c78hNiCofiee6j+yRuXg+Z0D3jhaZ45anlB4p9CxyP97Cw+FHXndG/bhRPvsa3SM
         TcuC+J5CVkoSGBGdsSHH7+yzHdXc1/Sc4FZHXOJQNnHVRS7UVIfyC6zzjKo5w8t9n5Ts
         mpOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=DaF9KSZ65paej3K5cVkPeneqfkvSWx8TBryPelAmSyg=;
        b=HDbViHilw0Wq0GDFQyLtD8ZBFU0WxOw4ERbm63DrlYIiFjpBmh/4VAitVAtOsXRy08
         vPSXBMrXamGDnLi/R5iieP4uH1KMAeAOvaxb/fWoYkqsy161QbTU3RduK6a3PAprOZWs
         l41xsN8zYwqD0fVhwEzJEoaIIiULzPzHZoGsNYM64rtkBHEJW7MKeB9ZXfRPuwecgwRs
         xZWxFaOGQAUQ0SnfbDcFu55wXvElLzRe7QsK0GatIaFI7mm/JUq3UQHQWsxOv/b7MPl+
         YpKKBv68GVQf/LlaAnLGzmOem5cFRpT13NNZjRKRpQThsX0PpUxgvkwpfEalXtA5iBHo
         TCQQ==
X-Gm-Message-State: AOAM530ppah6tEQDaBPDX53cmfe4p7x9Jwl0KGnDIt+8rB2H34Zpluto
        n1pgqIKBwRBJYAzXjNmsI5vPMm/UrBPpnh48HZso4Qh3j1JKTCZkEimPjx1m3vNx8IuN0+pfUXG
        aevTCsWmV3yDLfnWqzHlEX0leSBN9qQGNIRJivmK7X3ytb2m2VnWXW22ra4DBm5PFhJ3R
X-Google-Smtp-Source: ABdhPJykMZo2zfHYs8+HB3663LzFN178ZxGkgB5RPHYFpgn/g4r61iXBKb6Y4e/4YyEVAd+YwGNdm5p508lcIYcP
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90b:3696:b0:1e6:6f6d:962b with SMTP
 id mj22-20020a17090b369600b001e66f6d962bmr29668213pjb.8.1654538022979; Mon,
 06 Jun 2022 10:53:42 -0700 (PDT)
Date:   Mon,  6 Jun 2022 17:52:47 +0000
In-Reply-To: <20220606175248.1884041-1-aaronlewis@google.com>
Message-Id: <20220606175248.1884041-3-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220606175248.1884041-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 2/4] selftests: kvm/x86: Add flags when creating a pmu
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
index 93d77574b255..4bff4c71ac45 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -222,14 +222,15 @@ static struct kvm_pmu_event_filter *alloc_pmu_event_filter(uint32_t nevents)
 
 
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
 
@@ -240,7 +241,7 @@ static struct kvm_pmu_event_filter *event_filter(uint32_t action)
 {
 	return create_pmu_event_filter(event_list,
 				       ARRAY_SIZE(event_list),
-				       action);
+				       action, 0);
 }
 
 /*
@@ -287,7 +288,7 @@ static void test_amd_deny_list(struct kvm_vm *vm)
 	struct kvm_pmu_event_filter *f;
 	uint64_t count;
 
-	f = create_pmu_event_filter(&event, 1, KVM_PMU_EVENT_DENY);
+	f = create_pmu_event_filter(&event, 1, KVM_PMU_EVENT_DENY, 0);
 	count = test_with_filter(vm, f);
 
 	free(f);
-- 
2.36.1.255.ge46751e96f-goog

