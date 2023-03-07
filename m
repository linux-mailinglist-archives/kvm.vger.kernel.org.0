Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC2A46AE22E
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 15:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbjCGOXi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 09:23:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbjCGOXF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 09:23:05 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C288C87355
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 06:18:15 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id q24-20020a17090a2e1800b00237c37964d4so8137018pjd.8
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 06:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678198636;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g4NXzDS2mrtvREQbkOUU0m6WNlkGiCgwQxG1hZMlWok=;
        b=hFeZ3ud0NFE7B4AwiDXGCTpDwlLO9gl8GFtxWGsJPw8qAFnCzszJWJwCDAfgzjGsQo
         IAk19ayswF+sCOPRRa4bPZfUm3vvEa7dnA/rneLTDGHotIHbBpadHRcXzIRZwnzqYe1z
         +suFvygHvjCkRruF4XA5GPBKzzu3VkLcMEODvBePSnn66H7Et6yBNTCCycoAXM6zicJo
         vcw+D8sUeNyYo78auLpwMKkB9HVmULREnt9Q8veKxUCbDQWWdNbR1N0/zhNJ/u81wGPQ
         ec4hNaSzHKuoqtE6SzWkOr29+deWRuLnDcP8HUJavt/al5s4w2S/zT1XVs5Wqiw9Qt4/
         Vpdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678198636;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g4NXzDS2mrtvREQbkOUU0m6WNlkGiCgwQxG1hZMlWok=;
        b=I0St7dtBeE3Ru5lnm9Pu0hqwKzPdzSxxWgQMJxg/6N7DCMc43cdUNVdHjJ7Fmz4opv
         E5KipgKFN9M+hse0iZQW61Pxxc05OUdKV0d3kEGeJc5vGNN8NKZKxYlMFIKoCZkyHDsh
         PAAkYr71F07k0CSyhEzgiVMtjWz/SvrbvwtbfZ23BM/37uH8Z/DSI+peTXqYQv1j7i39
         2BUEGVMrImr0UcqgBLsF+R8afvTPzg6MM3kdMoOAR9TxD8m8AwXn3nALgMDcNdIdqXok
         BGSJ2VP9VEtiT0FwBqLbakC/H7J1g0TafTkFIdOPc+I+ZA/kFvmdhzk17WyyTaeCT8e7
         KsWQ==
X-Gm-Message-State: AO0yUKW+DS6Q3N5RIg1HXFCOgzairSdbtURdvAmL1khjOHop82Z2Nw3j
        R3yCU/WWOHOk0CnUaobRs0kGvpmsxCjOW563a15Sx+ArmkULx7waqhmFf3aRXmYf1kpuwcpyKUP
        IoyQNEiu8IFeDW+/llHKPk1Bfaohbkq8XopAZMgilFMHRHWwpmIMs99VyU5PrQvhuDf+P
X-Google-Smtp-Source: AK7set+pN9KrnwYMFlSLpwYenXxXpnXd0ngvcyPAoYnxq0VjKeJna9BvMVJHppCIkW6CWAQg/UWtwIPXac0oKwoS
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:efd4:b0:19a:efe3:b922 with SMTP
 id ja20-20020a170902efd400b0019aefe3b922mr5839766plb.9.1678198636029; Tue, 07
 Mar 2023 06:17:16 -0800 (PST)
Date:   Tue,  7 Mar 2023 14:13:59 +0000
In-Reply-To: <20230307141400.1486314-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230307141400.1486314-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230307141400.1486314-5-aaronlewis@google.com>
Subject: [PATCH v3 4/5] KVM: selftests: Fixup test asserts
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

Fix up both ASSERT_PMC_COUNTING and ASSERT_PMC_NOT_COUNTING in the
pmu_event_filter_test by adding additional context in the assert
message.

With the added context the print in ASSERT_PMC_NOT_COUNTING is
redundant.  Remove it.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../selftests/kvm/x86_64/pmu_event_filter_test.c      | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 8277b8f49dca..78bb48fcd33e 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -252,18 +252,17 @@ static struct kvm_pmu_event_filter *remove_event(struct kvm_pmu_event_filter *f,
 
 #define ASSERT_PMC_COUNTING(count)							\
 do {											\
-	if (count != NUM_BRANCHES)							\
+	if (count && count != NUM_BRANCHES)						\
 		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",	\
 			__func__, count, NUM_BRANCHES);					\
-	TEST_ASSERT(count, "Allowed PMU event is not counting.");			\
+	TEST_ASSERT(count, "%s: Branch instructions retired = %lu (expected > 0)",	\
+		    __func__, count);							\
 } while (0)
 
 #define ASSERT_PMC_NOT_COUNTING(count)							\
 do {											\
-	if (count)									\
-		pr_info("%s: Branch instructions retired = %lu (expected 0)\n",		\
-			__func__, count);						\
-	TEST_ASSERT(!count, "Disallowed PMU Event is counting");			\
+	TEST_ASSERT(!count, "%s: Branch instructions retired = %lu (expected 0)",	\
+		    __func__, count);							\
 } while (0)
 
 static void test_without_filter(struct kvm_vcpu *vcpu)
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

