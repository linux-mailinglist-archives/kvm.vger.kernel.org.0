Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A110056C5AA
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 03:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiGIBRr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 21:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiGIBRq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 21:17:46 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA497CB69
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 18:17:46 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id z5-20020a170903018500b0016a561649abso154229plg.12
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 18:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=hj0VFsudFHP3KW0mfTwOi/6LN1hXxaNHelmz5ALfZeQ=;
        b=UqaIT0tGQ8dxjynR/LZJ7xr1ykzTMdXhP02q4JgKXOKdrIHGG3dcBAdm0FaOhG8Lgh
         Qlj/fJyKnPCr0Y6b5GNwfVsx+U9ZPf/QD+xfjFP19h9pzGppCnqlS1as4DTctr+Qoi6N
         s2y1Of2wLvL9JtJKvBUqns4HfHYIFWMZSa/V1JzMi3qwbUzY6z7lIe9gS+y3cReZHOMH
         2GvwzdfRpWzgzO3j9ZfrBpC5OjP95UG7WVyzCYph+1hZyiwwxsEkt4Cy1eWgLYmMZ5xM
         2p2EizlP2n6C4sP5/UUN2SD9WAMsjobr3qGePmKEfclyUhUyWZURHzhOmvnYoohdxs/+
         92CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hj0VFsudFHP3KW0mfTwOi/6LN1hXxaNHelmz5ALfZeQ=;
        b=UpXkJcpwDSIhamUYukyXoEUlJZFSKkOgD69MX7Uqz0phUcoG4tVY0ymQaf4525CqtO
         ERHCPosTkhdI1w2/UG2qJG8IkYHBRwonPJ1/hk4yd+9q83a39H7Gmzn2p8A94CUhY+Ub
         yKRXYaO4nxDrjt5uWptyBwD2FHPNGw6yCCqOnD6oZMxTqltgB041NREE3iDyiLZz3LgM
         K7kw5ux2CXLsfGZO3AdxkLG07WQ08Iznv7EUoinIowhqxFvqtPiFU4eRei+FapZQ+nRL
         PzmOJ6K4LCHH1gee2W0uJhys2sDAdLEilRaidA5DTRG4l8m2G3kIejW0gp4o3cQ0myiD
         y4Qw==
X-Gm-Message-State: AJIora/O9LDuyRSomMcloVXIA+bdWu9sv8LiHa/GKyjkPQdSvAhRvvbH
        bWkanWs+Lh1L20Mx7OeyfmsPZgzf8vaKU+MUMzot3/xBk26wXpacLshvbW9ixYL6M7J906sCxfC
        dfWGnWebwCJhKIjyxti5CynareHqBRDgxzr5Ob8ubs89CI0sQaQIk4g2KDa4SssDGAOTL
X-Google-Smtp-Source: AGRyM1uKsazFBRz+PV/2BkRZCygdnGEZsZL45mMwim8ZsQZr3sAAfwFgo6bh6T66FtAhHTmQXx2Ar8vHb3lxgaVj
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a62:2546:0:b0:505:b6d2:abc8 with SMTP
 id l67-20020a622546000000b00505b6d2abc8mr6714817pfl.11.1657329465565; Fri, 08
 Jul 2022 18:17:45 -0700 (PDT)
Date:   Sat,  9 Jul 2022 01:17:23 +0000
In-Reply-To: <20220709011726.1006267-1-aaronlewis@google.com>
Message-Id: <20220709011726.1006267-3-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220709011726.1006267-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH v3 2/5] selftests: kvm/x86: Add flags when creating a pmu
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
2.37.0.144.g8ac04bfd2-goog

