Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38B0E623454
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 21:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbiKIUPA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 15:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbiKIUO7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 15:14:59 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 140EE1DA67
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 12:14:58 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id nl16-20020a17090b385000b002138288fd51so1970890pjb.6
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 12:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1Ems4DuloFYGcSsRCUY4EFa8uX8Hx7Kg+wd/blVe0fM=;
        b=koB4Rx0OHBFORPj6y/NBm5RACPCkj4aCdpMEtzl9GIVPgm7O9vkID9H1BySckneY80
         TqgtCrvxYN8Koe+HhSueqzdJ0q8IFxzLnv9RDAyZIbVQp59sa0/1IRDSE+xtSStq0USv
         12Pf8nFdqe+s/1eIqZXfV6AzWXIVWkbek1h41ioGamKUTWGv4OASM7yDARhTr3Kcbrmj
         UmN1W3GU12aoo/2wotPrSFgSNBl+kfUeqhtVc/e0ZpjfEzXWE0Bqm0LlowGX9qKceuoS
         bU9gMYw3NiAMtdcOolWzY2SV4qsHr1l3sb4CJWh4+xYEhCWiBhNDuKqngWaAmg6pQQZf
         cAng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Ems4DuloFYGcSsRCUY4EFa8uX8Hx7Kg+wd/blVe0fM=;
        b=S9ISDfsC6HgP7q35p/OKxNIkV8nTsmEvtanqAolpFQdTId/D5iISpMdSTUYtaalybw
         pRZL2U4LAViO/DXboSgUSyYlBzCUDFD3fq/7OMwx5mU6sxAb7+J5gHNR2gVD1Vu3ODze
         PLD04vFxjvnAdW0PIK7zmUVVgc4NKHejS4z6Te7EdVM3WnoBqPcWdMuNOAA9G9YjI0ci
         mVwRDhy1/H6akbZAoonh86rwzwoKFrzJOujt51wLUaeoDzjibqU2SROGi3hcq4tkXq3w
         3qGqhR7fEj4PFXJINDJMJiJ+sIfLeK7w+dSEd1OFS0QTMIqDv1VK6pnMb48AVUoMr5zg
         5yRg==
X-Gm-Message-State: ANoB5plkWJEOCrnnWMFZXwUrJDx73d4khQod/3aAAGkTzrgJPZyf6wp9
        0YPwxNebYFyD3MSOhsA6eaxyAq2LoDReWyHAtlki801wg3ZbavTaTEGhO6In5Iu29XCJBB/LpUQ
        OPd/fUNCULVOplIxwXjIdVz58zYRLx/RUPRSX+HgDYAFTxsB5XRl1FO0CqF3oGLd3lAqm
X-Google-Smtp-Source: AA0mqf6nbl8Cf175wM9hKwjYEswWFEoDQHskXKVa9dUki8bcrekvxgfRtFBYKiG+CZbmXRwmATYt/rBfjzuUXo2S
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90b:4003:b0:20a:fee1:8f69 with SMTP
 id ie3-20020a17090b400300b0020afee18f69mr73037pjb.0.1668024897113; Wed, 09
 Nov 2022 12:14:57 -0800 (PST)
Date:   Wed,  9 Nov 2022 20:14:42 +0000
In-Reply-To: <20221109201444.3399736-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221109201444.3399736-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221109201444.3399736-6-aaronlewis@google.com>
Subject: [PATCH v7 5/7] selftests: kvm/x86: Add flags when creating a pmu
 event filter
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
2.38.1.431.g37b22c650d-goog

