Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89D955BEC3B
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 19:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbiITRqk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 13:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbiITRqa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 13:46:30 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83816DF94
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 10:46:19 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id s16-20020a170902ea1000b00176cf52a348so2149388plg.3
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 10:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=rzYXp5WQnEAZeKlyKnAxtsq7oHUJ3RKxDsON93GIG1k=;
        b=SjBTtMmJDng3GlRvJDzNLF/o+wjrva1GqQXUWPbfhwkEoo7pSwZuNteLmNZQHb8D2d
         FmVaWQeFV/ZWllM1a4bP4Gn7/vX4oKPUz45w+m0rDgvBfNjU1WXtSxGG7c/qG7TwPhYc
         qIbnRStw58vDiVkqdg4dyPhKjRuwVdNa/v7rbgxUdBMLrvQowUKGsschcSjHaDayo8e1
         oRMoWnBW0vdnIvwU5sDlbOWE+xPIAU1qaXhOmbDkYgiNdiNSLeBNTChGPaZoEJY3wtjl
         kJO40DUpRwKMGwrD6z2IkVvIOIm4hvL3XS7zcxr8Xb9MSGUjGjtonRrYGM4vGGCxI78X
         1ycg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=rzYXp5WQnEAZeKlyKnAxtsq7oHUJ3RKxDsON93GIG1k=;
        b=LysJdymU4sLiVA1PtnD/YzJ7DSgLMx4lH1bzCgeh4SjEQQol0xBeoGY1HutZUcCz2t
         doltY1V2HlPE4nu6xjf634QxBDmHrFqnhVyjEa5ki+qA9jbNwhbvGxwryw11eotYGHj4
         SF4gHeVQFub+A7w3nA5U9fmswvC3UK4AWi4rreBMGsS70Vr6Uwa4C7b4Fjbbc9RGdBo1
         GofIpmCiR1FQysKAp0n4xXoUD3O2QDMrRUE+q9dH5WBnVizq3SHbTp+Xsb9TAUsTmfEX
         IS0tDUVkNmovEhDACdAX5A/oul1nDaNb67LDwPcJPhaAirNLYAQjZP7uVHVETxAmykD3
         nOQw==
X-Gm-Message-State: ACrzQf0/tTQiA+Dyyc44onl4XAr9Mibih18aH9zHu4muVOTSgxuxQZRZ
        owfWKPpOE6Kbl+nwbKYgtIGmId8oz1kRjGhns7yqmVd7JAx/vmCAjGTmRekm7MVTeF0GvUQKGk7
        6/eLaGDdCHGdo+cm++0ZJVe599nf8O0OF8p+/hi521yTUjifER1UEJqMclpaEKYz9pUIp
X-Google-Smtp-Source: AMsMyM73mIQYkxuHapgIoHSfAH1p/o3QuyxpyEz9KsafJ2ihR+z2GeJx4ZxV/NHQIlm7fFGk5s76NSA1O0Wb9Clw
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:aa7:88c7:0:b0:542:3229:8d11 with SMTP
 id k7-20020aa788c7000000b0054232298d11mr24884967pff.41.1663695979276; Tue, 20
 Sep 2022 10:46:19 -0700 (PDT)
Date:   Tue, 20 Sep 2022 17:46:01 +0000
In-Reply-To: <20220920174603.302510-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220920174603.302510-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920174603.302510-6-aaronlewis@google.com>
Subject: [PATCH v5 5/7] selftests: kvm/x86: Add flags when creating a pmu
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
Reviewed-by: Jim Mattson <jmattson@google.com>
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
2.37.3.968.ga6b4b080e4-goog

