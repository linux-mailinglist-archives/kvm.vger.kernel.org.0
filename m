Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD7F60804B
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 22:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbiJUUvh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 16:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbiJUUv3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 16:51:29 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99061B574E
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 13:51:28 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id h186-20020a636cc3000000b0045a1966a975so1845998pgc.5
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 13:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SdYBIkNQsFd74tvgqxipUgQRM9sk8tbOtLgfO+Jzjgs=;
        b=IT5ofqEpLIZrOWgxvGmHD5wZyxD4CXt9kLNMr64QPdLvQwO2v9IVLIJWB50akgYfor
         IucRomJl8pNLwAhgnJWKp0jqdgeG4zO2wReJt3C23MObS4VFP6Y/gz9K5NMJEMkrZ0zC
         7azI2c/1gbLgwun3pAx3LMlOJKlGKighI8SymIMHX5KH9vaZekf8+nrC8fV2vmPxtYN2
         C9hw6GZI4JVv4I7T92Kt5R/2eJtZiaxKpV+81VBIZevgrm0h3Ku/gqtqkm5hcYcqqBC0
         DL4+wfZ9sfqS4bhtQ1YS4yy5qpduUeg7X9/jcISy++FBUw1b5cAiL/WJmcj5y0BPj9js
         mtjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SdYBIkNQsFd74tvgqxipUgQRM9sk8tbOtLgfO+Jzjgs=;
        b=8B5EeA860TGrKiJJexHGvXjkB9vzHobiBlyOWz9k0R5+f3MSJeHejO7AVEEuFtTTj2
         pRPBQ3j8ZwfSKyr3IDGa5qdB9GYi2E9+Ru3ELBi2TInQKatyjTlsWDXk/sTYnyTF1o/J
         hsHkEcxTXvbKgpwP6Br1RTqNkQgzunqJV9bCK2ayfuUOruj+i+tNJQxR47CsGaoXFyiu
         YPQ3rBC731kpyLjK29H2S48qYzc/R2ILE7Ab2we2E6ThA8GNUG3/ciUUTAZlp+o+n1db
         0cgqtuTNVTqIi5ID/0AcmYmexcOMv1bKokBPybbo8vvuqEJfRVpFkFwDhm0OnycMZd0P
         9Kog==
X-Gm-Message-State: ACrzQf1yoJk/0ESxOK9117CDcugdY06bGcvqIwHl0QlUlLakPAlulV8C
        zku0F6LCrdDIakLmTZTwJRZ0uYxnSmAxwjLIHR5q7SLOd/d2gTR2rUclmeyK06NH99XootxmdMV
        WpDDRAq0CkF48biAv7Y2G+xZO1E1H28wRt3+KulVss6uKw6zUKIUmNzrIHKdn89DoEFJw
X-Google-Smtp-Source: AMsMyM4pfJpms1lBe1AbFDLdgAB86fmiImaTuuX+rpPzzfx0+O9caW2rYQ5m4WRiK07ZV5ZjwC+YBY6Q/YvdmBHf
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:c94b:b0:185:2d36:9dc6 with SMTP
 id i11-20020a170902c94b00b001852d369dc6mr21401113pla.68.1666385488235; Fri,
 21 Oct 2022 13:51:28 -0700 (PDT)
Date:   Fri, 21 Oct 2022 20:51:03 +0000
In-Reply-To: <20221021205105.1621014-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221021205105.1621014-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
Message-ID: <20221021205105.1621014-6-aaronlewis@google.com>
Subject: [PATCH v6 5/7] selftests: kvm/x86: Add flags when creating a pmu
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
2.38.0.135.g90850a2211-goog

