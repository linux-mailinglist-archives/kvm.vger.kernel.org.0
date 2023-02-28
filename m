Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73AF56A5005
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 01:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbjB1AJU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 19:09:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjB1AJN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 19:09:13 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CBBB23121
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 16:08:56 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id y35-20020a056a00182300b005e8e2c6afe2so4169861pfa.12
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 16:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a89MD90/uLzwK1MwsV9/HXg1EUzJUQbpy0l28i0eMws=;
        b=jzLICPz2NMjWYm5tnviLDEBUR7X0/N0P+qCjZhAtRMPGg2oYdQRnoEKrKG1qQWrQFj
         BgUXqwoKvAUpBA2hY1OvnqTvGm7c3gB3XkkXP7J5QRMMALosNG+ivn81YmHoptBXt/+s
         LVW0CHB+KtH9ss6C6B1YqJ637NqqZtK/PHQJB/XW+LRepKkPJifZIgaYIvTizMxr+uUb
         Ntyd4mD6I4pawER6svzv/7tl9oP7YzR0kQR7ZKSxen97JsdU8jgXq99c4t48Ib6LEU8+
         IqOzUWMKMN+Yki7glUE0d3Kavgktz/EiXcn2ehZ6kgl5S0RHv8Q+Axd0luCY+GTzHqN5
         KTeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a89MD90/uLzwK1MwsV9/HXg1EUzJUQbpy0l28i0eMws=;
        b=NcVYB5JOJH+2C1aDd3cRqiNYD+EUAm4JW5MxHBB5KCL4535Kk1rqoJL5sa00hHHsLh
         cfJU/HCBDasNX+uBFueugSRIMC/vLfGfh6A7VViANoD0ICR6Gz8IhMSvC4RZbgUEpg4O
         67Li+jtcMthIiPr+UQwZKAiStqTNIJZA8rpyE85Gpsz1bmPf3uscv3w+ouQAek26qSoT
         G6wsS7g4swNZxO5IG4IZMfdA2DSoZ/8ZlvbhFR5dc3uOSbet5NNCk3D5MxEAzZXtsZ1I
         2op2Qrps6cGpNwwcbMMzmBcET+waYmcBIESabqlrxQIzSWI+4eLLhI5xN0ZIblBP+OI5
         6TeA==
X-Gm-Message-State: AO0yUKUO9objfY8pqRtPGch3fmJpqz01jS2EwVxgT2n8hzYuHaMHsyTJ
        UJXhunUuVQcjEjLSzC+00Y+Crl7m2QMIoO45N48GYszO6TwRGPlH2WwPKgQSQs0oJapfLV0dEOm
        3b3YBev24H1aA8U9x5dQCNBooXBMr9tZtjByusvZ4/Fykf7DEWdA9n+pXknr9MKQCtOGn
X-Google-Smtp-Source: AK7set/XzxvIHXw5i+rJJWRhYxyibQMgKJ+qNEpAJGI55LeVC0DsXh9mOMfJC3UUyMfd5BOogrsAsuSb6N9zi4Ph
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a63:3707:0:b0:503:77ce:a1ab with SMTP
 id e7-20020a633707000000b0050377cea1abmr94969pga.9.1677542934421; Mon, 27 Feb
 2023 16:08:54 -0800 (PST)
Date:   Tue, 28 Feb 2023 00:06:43 +0000
In-Reply-To: <20230228000644.3204402-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230228000644.3204402-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230228000644.3204402-5-aaronlewis@google.com>
Subject: [PATCH v2 4/5] KVM: selftests: Fixup test asserts
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
2.39.2.722.g9855ee24e9-goog

